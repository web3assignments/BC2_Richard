pragma solidity ^0.6.0;

import "./provableAPI.sol";
import "./SafeMath.sol";
import "./Mortal.sol";
import "./RoleControlled.sol";

/// @title A coinflip dapp for flipping coins and earning money
/// @author Richard Kerkvliet
/// @notice A contract for flippin' coins mate
/// @dev This contract allows users to flip coins. It is using provable for random values, RoleControlled for user specific functions and Mortal for updating
contract CoinFlip is usingProvable, RoleControlled, Mortal {
    /// @dev using SafeMath copied from @openzeppelin
    using SafeMath for uint256;

    /// @author Richard Kerkvliet
    /// @notice A struct of a game
    struct Game {
        address payable player;
        uint8 choice;
        uint256 bet;
    }

    mapping(bytes32 => Game) public pendingGames;
    mapping(address => uint256) private playerLosses;
    mapping(address => uint256) private playerWinings;

    /// @author Richard Kerkvliet
    /// @notice The result of a game
    /// @dev Emitted when the result of the game is in
    event Result(bool winner, uint256 winnings, uint8 result);
    /// @author Richard Kerkvliet
    /// @notice The firing of a new provable query
    /// @dev Emitted when a new query is send to provable
    event LogNewProvableQuery(bytes32 queryId);

    /// @author Richard Kerkvliet
    /// @dev modifier for the minimum bet a user must provide
    modifier minimumBet(uint256 bet) {
        require(msg.value >= bet, "Minimum bet not reached");
        _;
    }

    /// @author Richard Kerkvliet
    /// @dev modifier for checking if users choice is either 0 or 1
    modifier allowedChoices(uint8 _choice) {
        require(_choice == 0 || _choice == 1, "Choice must either be 0 or 1");
        _;
    }

    constructor() public payable {}

    receive() external payable {}

    fallback() external payable {}

    /// @author Richard Kerkvliet
    /// @notice The actual flip function callable for users
    /// @dev This function sends a query to provable
    /// @param _choice a uint either 0 or 1
    function flip(uint8 _choice) public payable minimumBet(0.2 ether) allowedChoices(_choice) minimumRole(Roles.FREE) {
        require(msg.value <= address(this).balance, "Contract can't pay out that kind of money right now");
        // bytes32 queryId = provable_newRandomDSQuery(0, 1, 2000000);
        bytes32 queryId = bytes32(keccak256("test"));
        emit LogNewProvableQuery(queryId);
        pendingGames[queryId] = Game(msg.sender, _choice, msg.value);
    }

    /// @author Richard Kerkvliet
    /// @notice for returning the users losses
    /// @dev only usable for users with the USER role
    function getMyLosses() public minimumRole(Roles.USER) returns(uint256) {
        return playerLosses[msg.sender];
    }

    /// @author Richard Kerkvliet
    /// @notice for returning the users winnings
    /// @dev only usable for users with the USER role
    function getMyWinings() public minimumRole(Roles.USER) returns(uint256) {
        return playerWinings[msg.sender];
    }

    /// @author Richard Kerkvliet
    /// @notice for resetting a player
    /// @dev only usable for users with the ADMIN role
    /// @param _player ethereum address of the player to be reset
    function resetPlayer(address _player) public minimumRole(Roles.ADMIN) returns (bool){
        delete playerLosses[_player];
        delete playerWinings[_player];
        delete userRoles[_player];

        if (playerLosses[_player] == 0 && playerWinings[_player] == 0 && userRoles[_player] == Roles.FREE) {
            return true;
        }
        return false;
    }

    /// @author Richard Kerkvliet
    /// @dev callback function to be executed only by the provable address, never to be touched so back off
    function __callback(bytes32 _queryId, string memory _result)
        public
        override
    {
        // require(msg.sender == provable_cbAddress());
        uint8 result = uint8(uint256(keccak256(abi.encodePacked(_result))) % 2);
        Game memory game = pendingGames[_queryId];
        bool playerWon = (game.choice == result);
        uint256 winnings = 0;
        if (playerWon) {
            winnings = game.bet * 2;
            game.player.transfer(winnings);
            playerWinings[game.player].add(game.bet);
        } else {
            playerLosses[game.player].add(game.bet);
        }
        delete pendingGames[_queryId];
        emit Result(playerWon, winnings, result);
    }
}

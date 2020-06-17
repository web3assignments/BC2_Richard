pragma solidity ^0.6.0;

import "./provableAPI.sol";
import "./SafeMath.sol";
import "./Mortal.sol";
import "./RoleControlled.sol";

contract CoinFlip is usingProvable, RoleControlled, Mortal {
    using SafeMath for uint256;

    struct Game {
        address payable player;
        uint8 choice;
        uint256 bet;
    }

    mapping(bytes32 => Game) private pendingGames;
    mapping(address => uint256) private playerLosses;
    mapping(address => uint256) private playerWinings;

    event Result(bool winner, uint256 winnings);
    event LogNewProvableQuery(string description);

    modifier minimumBet(uint256 bet) {
        require(msg.value >= bet, "Minimum bet not reached");
        _;
    }

    modifier allowedChoices(uint8 _choice) {
        require(_choice == 0 || _choice == 1, "Choice must either be 1 or 0");
        _;
    }

    constructor() public payable {}

    fallback() external payable {}

    receive() external payable {}

    function flip(uint8 _choice) public payable minimumBet(0.2 ether) allowedChoices(_choice) minimumRole(Roles.FREE) {
        require(
            msg.value * 2 <= address(this).balance,
            "Contract can't pay out that kind of money right now"
        );

        bytes32 queryId = provable_newRandomDSQuery(0, 1, 2000000);
        emit LogNewProvableQuery("genereated query");
        pendingGames[queryId] = Game(msg.sender, _choice, msg.value);
    }

    function getMyLosses() public minimumRole(Roles.USER) returns (uint256 losses) {
        return playerLosses[msg.sender];
    }

    function getMyWinings() public minimumRole(Roles.USER) returns (uint256 winings) {
        return playerWinings[msg.sender];
    }

    function resetPlayer(address _player) public minimumRole(Roles.ADMIN) returns (bool success){
        delete playerLosses[_player];
        delete playerWinings[_player];
        delete userRoles[_player];

        if (playerLosses[_player] == 0 && playerWinings[_player] == 0 && userRoles[_player] == Roles.FREE) {
            return true;
        }
        return false;
    }

    function __callback(bytes32 _queryId, string memory _result)
        public
        override
    {
        require(msg.sender == provable_cbAddress());
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
        emit Result(playerWon, winnings);
    }
}

pragma solidity ^0.6.0;

import "github.com/provable-things/ethereum-api/provableAPI_0.6.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/contracts/math/SafeMath.sol";
import "./Mortal.sol";

contract CoinFlip is Mortal, usingProvable {
    using SafeMath for uint256;

    struct Game {
        address payable player;
        uint8 choice;
        uint256 bet;
    }

    mapping(bytes32 => Game) private pendingGames;
    mapping(address => uint256) public playerLosses;
    mapping(address => uint256) public playerWinings;

    event Result(bool winner, uint256 winnings);
    event LogNewProvableQuery(string description);

    constructor() public payable {}

    fallback() external payable {}

    receive() external payable {}

    function flip(uint8 _choice) public payable {
        require(msg.value > 0.2 ether, "Bet must be at least 0.2 Ether");
        require(
            msg.value * 2 <= address(this).balance,
            "Contract can't pay out that kind of money right now"
        );
        require(_choice == 0 || _choice == 1, "Choice must either be 1 or 0");

        bytes32 queryId = provable_newRandomDSQuery(0, 1, 2000000);
        emit LogNewProvableQuery("genereated query");
        pendingGames[queryId] = Game(msg.sender, _choice, msg.value);
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

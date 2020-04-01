pragma solidity 0.5.12;

contract CoinFlip {
  uint256 public balance;
  mapping (address => uint256) public playerLosses;
  mapping (address => uint256) public playerWinings;

  constructor() public payable {
      balance += msg.value;
  }

  event Result(bool winner, uint256 winnings);

  function flip(uint8 _choice) public payable {
    require(msg.value > 0.2 ether, "Bet must be at least 0.2 Ether");
    require(msg.value <= balance, "Contract can't pay out that kind of money right now");
    require(_choice == 0 || _choice == 1, "Choice must either be 1 or 0");
    bool playerWon = (random() == _choice);
    uint256 winnings = 0;
    if (playerWon) {
      winnings = msg.value * 2;
      balance -= msg.value;
      msg.sender.transfer(winnings);
      playerWinings[msg.sender] += msg.value;
    } else {
      balance += msg.value;
      playerLosses[msg.sender] += msg.value;
    }
    emit Result(playerWon, winnings);
  }

  function random() private view returns(uint8){
    return uint8(now % 2);
  }
}
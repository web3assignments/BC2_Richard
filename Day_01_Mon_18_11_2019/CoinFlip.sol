pragma solidity 0.5.12;

contract CoinFlip {
  uint256 public balance;
  constructor() public payable {
      balance += msg.value;
  }

  function flip(uint8 _choice) public payable {
    bool win = (random() == _choice);
    if (win) {
      uint256 winnings = msg.value * 2;
      balance -= msg.value;
      msg.sender.transfer(winnings);
    } else {
      balance += msg.value;
    }
  }

  function random() private view returns(uint8){
    return uint8(now % 2);
  }
}
pragma solidity ^0.6.0;

contract Ownable {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can execute action");
        _;
    }

    function transferOwner(address newOwner) public onlyOwner {
        owner = newOwner;
    }
}

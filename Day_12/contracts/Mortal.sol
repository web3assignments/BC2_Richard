pragma solidity ^0.6.0;

import "./Ownable.sol";

contract Mortal is Ownable {
    event deleteEvent(address contracAddress);

    function destroy() public payable onlyOwner {
        emit deleteEvent(address(this));
        selfdestruct(msg.sender);
    }

    function destroyAndSend(address payable _recipient) public onlyOwner {
        selfdestruct(_recipient);
    }
}

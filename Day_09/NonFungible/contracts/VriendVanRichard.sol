pragma solidity >=0.6.0 <0.7.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract VriendVanRichard is ERC721 {
  constructor (string memory name, string memory symbol, string memory baseURI) ERC721(name, symbol) public {
    _setBaseURI(baseURI);
    _mint(msg.sender, 1);
    _mint(msg.sender, 2);
    _mint(msg.sender, 3);
    _mint(msg.sender, 4);
    _mint(msg.sender, 5);
  }
}
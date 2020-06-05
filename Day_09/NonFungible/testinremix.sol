pragma solidity >=0.6.0 <0.7.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
contract VriendVanRichard is ERC721 {
constructor() ERC721("Vriend van Richard", "VVR" )  public {  
    _setBaseURI("https://web3assignments.github.io/BC2_Richard/Tokens/");
    _mint(msg.sender, 1);
    
  }
}


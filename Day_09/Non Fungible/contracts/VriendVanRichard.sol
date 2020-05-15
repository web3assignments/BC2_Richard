pragma solidity ^0.5.12;

import "./ERC165.sol";
import "./IERC721.sol";
import "./IERC721Enumerable.sol";
import "./IERC721Metadata.sol";
import "./EnumerableSet.sol";

contract VriendVanRichard is ERC165, IERC721, IERC721Enumerable, IERC721Metadata {
  using EnumerableSet for EnumerableSet.UintSet;

  bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
  bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
  bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
  bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;

  string private _name;
  string private _symbol;

  mapping(uint256 => string) private _tokenURIs;

  constructor (string memory name, string memory symbol) public {
    _name = name;
    _symbol = symbol;

    // register the supported interfaces to conform to ERC721 via ERC165
    _registerInterface(_INTERFACE_ID_ERC721);
    _registerInterface(_INTERFACE_ID_ERC721_METADATA);
    _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
  }
}
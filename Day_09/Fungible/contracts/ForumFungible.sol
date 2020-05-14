pragma solidity ^0.5.12;

import "./IERC20.sol";

contract ForumFungible is IERC20 {
  address payable _owner;
  string private _name;
  string private _symbol;
  uint8 private _decimals;
  uint256 private _totalSupply;
  mapping (address => uint256) private _balances;

  modifier onlyOwner() {
    require(msg.sender == _owner, "Only owner action");
    _;
  }

  constructor(string memory name, string memory symbol, uint8 decimals) public {
    _owner = msg.sender;
    _name = name;
    _symbol = symbol;
    _decimals = decimals;
    _mint(msg.sender, 1000 * (10 ** uint256(_decimals)));
  }

  function destroy() public onlyOwner {
    selfdestruct(_owner);
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a, "SafeMath: addition overflow");
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a, "SafeMath: subtraction overflow");
    uint256 c = a - b;
    return c;
  }

  function name() public view returns (string memory) {
    return _name;
  }

  function symbol() public view returns (string memory) {
    return _symbol;
  }

  function decimals() public view returns (uint8) {
    return _decimals;
  }

  // function: totalSupply
  function totalSupply() public view returns (uint256) {
    return _totalSupply;
  }

  // function: balanceOf
  function balanceOf(address account) public view returns (uint256) {
    return _balances[account];
  }

  // function: transfer
  function transfer(address recipient, uint256 amount) public returns (bool) {
    _transfer(msg.sender, recipient, amount);
    return true;
  }

  function _transfer(address sender, address recipient, uint256 amount) internal {
    require(sender != address(0), "ERC20: transfer from the zero address");
    require(recipient != address(0), "ERC20: transfer to the zero address");
    _balances[sender] = sub(_balances[sender],amount);
    _balances[recipient] = add(_balances[recipient],amount);
    emit Transfer(sender, recipient, amount);
  }

  function _mint(address account, uint256 amount) public onlyOwner {
    require(account != address(0), "ERC20: mint to the zero address");
    _totalSupply = add(_totalSupply, amount);
    _balances[account] = add(_balances[account], amount);
    emit Transfer(address(0), account, amount);
  }
}
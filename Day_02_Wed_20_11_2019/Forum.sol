pragma solidity 0.5.12;

contract Forum {
  address public owner;
  mapping (address => bool) public operators;
  mapping (address => int32) public participantReputation;
  mapping (string => uint256) public questionBounty;

  event answerAccepted(string answer);

  constructor () public {
    owner = msg.sender;
    operators[owner] = true;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "Only the onwer of this contract can execute this function");
    _;
  }

  modifier onlyOperator() {
    require(!operators[msg.sender], "Must be an operator to perform this action");
    _;
  }

  function destroy() public onlyOwner {
    selfdestruct(msg.sender);
  }

  function upVote(address _participant, uint16 _reputation) public {
    participantReputation[_participant] += _reputation;
  }

  function downVote(address _participant, uint16 _reputation) public {
    participantReputation[_participant] -= _reputation;
  }

  function addBounty(string memory _question) public payable {
    questionBounty[_question] = msg.value;
  }

  function acceptAnswer(address _participant, string memory _question, string memory _answer) public {
    upVote(_participant, 10);
    emit answerAccepted(_answer);
    address(uint160(_participant)).transfer(questionBounty[_question]);
  }

  function kick(address _participant) public onlyOperator {
    participantReputation[_participant] = 0;
  }

  function addOperator(address _participant) public onlyOwner {
    operators[_participant] = true;
  }

  function removeOperator(address _participant) public onlyOwner {
    operators[_participant] = false;
  }

  function changeOwner(address _newOwner) public onlyOwner {
    operators[owner] = false;
    owner = _newOwner;
    operators[_newOwner] = true;
  }
}
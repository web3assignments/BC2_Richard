pragma solidity 0.5.12;

contract Forum {

  struct Thread {
    uint256 id;
    address owner;
    string question;
    int32 score;
    uint256 answerCount;
  }

  struct Answer {
    address owner;
    string answer;
    int32 score;
    bool accepted;
  }

  address public owner;
  uint256 public threadCount;
  mapping (uint256 => Thread) public threads;
  mapping (uint256 => mapping (uint256 => Answer)) public threadAnswers;
  mapping (address => int32) public participantReputation;

  event answerAccepted(string answer);
  event threadUpdated(uint256 threadId);

  constructor () public {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "Only the onwer of this contract can execute this function");
    _;
  }

  function destroy() public onlyOwner {
    selfdestruct(msg.sender);
  }

  function startThread(string memory _question) public {
    threads[threadCount] = Thread(threadCount, msg.sender, _question, 0, 0);
    emit threadUpdated(threadCount);
    threadCount++;
  }

  function addAnswer(uint256 _threadId, string memory _answer) public {
    Answer memory answer = Answer(msg.sender, _answer, 0, false);
    Thread storage thread = threads[_threadId];
    threadAnswers[_threadId][thread.answerCount] = answer;
    thread.answerCount++;
    emit threadUpdated(_threadId);
  }

  function vote(uint256 _threadId, uint256 _answerId, int32 _points) public {
    require(_points != 0, "Points must not be 0");
    if (_answerId < 0) {
      voteAnswer(_threadId, _answerId, _points);
    } else {
      voteThread(_threadId, _points);
    }
    emit threadUpdated(_threadId);
  }

  function voteAnswer(uint256 _threadId, uint256 _answerId, int32 _points) private {
    Answer storage answer = threadAnswers[_threadId][_answerId];
    answer.score += _points;
    participantReputation[answer.owner] += _points;
  }

  function voteThread(uint256 _threadId, int32 _points) private {
    Thread storage thread = threads[_threadId];
    thread.score += _points;
    participantReputation[thread.owner] += _points;
  }

  function acceptAnswer(uint256 _threadId, uint256 _answerId, int32 _points) public {
    threadAnswers[_threadId][_answerId].accepted = true;
    vote(_threadId, _answerId, _points);
  }
}
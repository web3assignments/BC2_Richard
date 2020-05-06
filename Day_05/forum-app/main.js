var web3 = new Web3(Web3.givenProvider);
var contract;
var accounts;
// const forumAddress = '0x16A3cdD93BBA58DB9699bcfb7f85A1a989E16a65'; // Ganache
const forumAddress = '0x1d2e3D11d749DdAE671393C282a41A2711A330fb'; // Ropsten
const threads = [];

function printThreads({id, owner, question, score, answerCount}) {
  var scoreLabel = document.createElement("label");
  scoreLabel.innerHTML = `Score: ${score}`;
  
  var upVoteButton = document.createElement("button");
  upVoteButton.innerHTML = "&uarr;";
  upVoteButton.onclick = () => vote(id, -1, 1);
  
  var downVoteButton = document.createElement("button");
  downVoteButton.innerHTML = "&darr;";
  downVoteButton.onclick = () => vote(id, -1, -1);
  
  var questionPar = document.createElement("p");
  questionPar.innerHTML = question;
  
  var threadDiv = document.createElement("div");
  threadDiv.appendChild(scoreLabel);
  threadDiv.appendChild(upVoteButton);
  threadDiv.appendChild(downVoteButton);
  threadDiv.appendChild(questionPar)

  var threadsElement = document.getElementById('threads');
  threadsElement.appendChild(threadDiv);
}

function vote(threadId, answerId, score) {
  contract.methods.vote(threadId, answerId, score).send({ from: accounts[0] });
}

function setAccount(account) {
  var connectedAccount = document.getElementById('connected-account');
  connectedAccount.innerHTML = `Connected with: ${account}`;
}

async function setNetwork() {
  var connectedNetwork = document.getElementById('connected-network');
  var forum = document.getElementById('forum');
  var error = document.getElementById('error');
  web3.eth.net.getNetworkType().then((network) => {
    connectedNetwork.innerHTML = `To network: ${network}`;
    if (network == 'private' || network == 'ropsten') {
      contract = new web3.eth.Contract(forumABI, forumAddress);
      error.style.display = "none";
      forum.style.display = "block";
      getInitialData();
      contract.events.threadUpdated(async(err, {returnValues}) => {
        updateThreads(returnValues['threadId']);
      });
    } else {
      error.style.display = "block";
      forum.style.display = "none";
    }
  });
}

function startThread() {
  var question = document.getElementById('newThread').value;
  contract.methods.startThread(question).send({ from: accounts[0] });
}

async function updateThreads(threadId) {
  var result = await contract.methods.threads(threadId).call();
  var index = threads.findIndex(x => x.id == result.id);
  if (index >= 0) {
    threads[index] = result;
  } else {
    threads.push(result);
  }
  reRenderThreads();
}

function reRenderThreads() {
  var threadsElement = document.getElementById('threads');
  threadsElement.innerHTML = '';
  threads.forEach(thread => {
    printThreads(thread);
  });
}

async function getInitialData() {
  var threadCount = await contract.methods.threadCount().call();
  for (let x = 0; x < threadCount; x++) {
    var result = await contract.methods.threads(x).call();
    threads.push(result);
  }
  threads.forEach(thread => {
    printThreads(thread);
  });
}

async function init() {
  var result = await ethereum.enable();
  threads.forEach(thread => {
    printThreads(thread);
  });
  accounts = await web3.eth.getAccounts();
  setAccount(accounts[0]);
  setNetwork();
  ethereum.on("accountsChanged", setAccount);
  ethereum.on("chainIdChanged", setNetwork);
  ethereum.autoRefreshOnNetworkChange = false;
}

init();
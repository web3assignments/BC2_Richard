Web3Modal = require("web3modal");
WalletConnectProvider = require("@walletconnect/web3-provider").default;
Web3 = require("web3");

roles = {
  FREE: 0,
  USER: 1,
  ADMIN: 2,
  OWNER: 3
}

const infuraKey = "37a4c5643fe0470c944325f1e9e12d50";
const contractAddress = "0x2976ba4738672368aEE29fe3B4d358a8E3b94Fcb";
providerOptions = {
  walletconnect: {
    package: WalletConnectProvider, // required
    options: {
      infuraId: infuraKey // required
    }
  }
};

async function init() {
  web3modal = new Web3Modal.default({
    network: "rinkeby",
    providerOptions,
    theme: "dark"
  });
  web3modal.on("connect", OnConnect);
  web3modal.on("disconnect", onDisconnect);
  connect();

  document.getElementById('connect').onclick = function() {connect()};
  document.getElementById('start-game').onclick = function() {startGame()};
}

async function OnConnect(provider) {
  web3 = new Web3(provider);
  if (await web3.eth.getChainId() != 4) {
    addError("Please connect with rinkeby network address");
  } else {
    accounts = await web3.eth.getAccounts();
    document.getElementById("un-connected").style.display = 'none';
    document.getElementById("connected").style.display = 'block';
    document.getElementById("signed-in-header").innerText = `signed in as ${accounts[0]}`
    removeError();
    contract = new web3.eth.Contract(abi, contractAddress);

    contract.events.Result((err, event) => {
      if (err) addError(err);
      printResult(event);
    })
    var player = await contract.methods.userRoles(accounts[0]).call();
    if (player > roles.FREE) {

    }
  }
}

async function onDisconnect(shit) {
  document.getElementById("un-connected").style.display = 'block';
  document.getElementById("connected").style.display = 'none';
}

function connect() {
  web3modal.toggleModal();
}

function printResult(result) {
  removeError();
  if (result.returnValues.winner) {
    addError(`You won! ${web3.utils.fromWei(result.returnValues.winnings)}Ξ added to your account`)
  } else {
    addError(`You lost! please try again`);
  }
  document.getElementById("flip").style.display = 'block';
}

function addError(msg) {
  var errors = document.getElementById("errors")
  errors.style.display = 'block';
  var h2 = document.createElement("h2");
  var node = document.createTextNode(msg);
  h2.appendChild(node);
  errors.appendChild(h2);
}

function removeError() {
  var errors = document.getElementById("errors")
  errors.style.display = 'none';
  errors.innerHTML = '';
}

function startGame() {
  var bet = document.getElementById("bet").valueAsNumber;
  var side = parseInt(document.querySelector('input[name="side"]:checked').value);
  if (!bet || bet <= 0.2) {
    addError("Bet is to low!");
  } else {
    removeError();
    addError("Flippin' coin...");
    document.getElementById("flip").style.display = 'none';
    contract.methods.flip(side).send({from: accounts[0], value: web3.utils.toWei(`${bet}`)})
  }
}

window.onload = init();
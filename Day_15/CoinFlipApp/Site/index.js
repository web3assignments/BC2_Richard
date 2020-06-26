Web3Modal = require("web3modal");
WalletConnectProvider = require("@walletconnect/web3-provider").default;
Web3 = require("web3");

const infuraKey = "37a4c5643fe0470c944325f1e9e12d50";
const providerOptions = {
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
}

async function OnConnect(provider) {
  web3 = new Web3(provider);
  if (await web3.eth.getChainId() != 4) {
    addError("Please connect with rinkeby network address");
  } else {
    const accounts = await web3.eth.getAccounts();
    document.getElementById("un-connected").style.display = 'none';
    document.getElementById("connected").style.display = 'block';
    document.getElementById("signed-in-header").innerText = `signed in as ${accounts[0]}`
    removeError();
  }
}

async function onDisconnect(shit) {
  document.getElementById("un-connected").style.display = 'block';
  document.getElementById("connected").style.display = 'none';
}

function connect() {
  web3modal.toggleModal();
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

window.onload = init();
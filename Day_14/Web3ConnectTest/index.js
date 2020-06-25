const Web3 = require("web3");
const Web3Modal = require("web3modal");
const WalletConnect = require("@walletconnect/web3-provider").default;

const fs = require('fs');
const infuraKey = fs.readFileSync(".infura").toString().trim();

var provider;

function log(logstr) {
  document.getElementById("log").innerHTML += "\n" + logstr;
}

const providerOptions = {
  walletconnect: {
    package: WalletConnect, // required
    options: {
      infuraId: infuraKey // required
    }
  }
};

const web3Modal = new Web3Modal.default({
  network: "rinkeby",
  providerOptions
});

async function init() {
  web3Modal.on("connect", OnConnect);
  web3Modal.toggleModal();
}

async function OnConnect(provider) {
  const web3 = new Web3(provider);
  var acts = await web3.eth.getAccounts().catch(log);
  log(`${JSON.stringify(acts)}`)
}

init();
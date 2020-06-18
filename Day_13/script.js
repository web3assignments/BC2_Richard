var contract;
var account;
var address;
var ens;
var name = 'richardkerkvliet.eth';
var contract;

function setAccount(address) {
  var connectedAccount = document.getElementById('connected-account');
  connectedAccount.innerHTML = `Connected with: ${address}`;
}

async function setNetwork() {
  var connectedNetwork = document.getElementById('connected-network');
  connectedNetwork.innerHTML = await web3.eth.net.getNetworkType();
}

async function getMyWinings() {
  var winnings = await contract.methods.getMyWinings().call({from: account});
  console.log(winnings);
}

async function init() {
  setAccount(account);
  setNetwork();
  ethereum.on("accountsChanged", setAccount);
  ethereum.on("chainIdChanged", setNetwork);
  ethereum.autoRefreshOnNetworkChange = false;

  
  const ens = await ENS(web3.currentProvider);
  var ResolverContract = await ens.resolver(name);

  if (ResolverContract)
    contract = new web3.eth.Contract(ABI, await ResolverContract.addr());
}

window.onload = async function() {
  if (typeof web3 !== "undefined") {
    const accounts = await ethereum.enable();
    account = accounts[0];
    web3 = await new Web3(Web3.givenProvider);
    init();
  } else {
    window.alert("without metamask this is not going to work mate");
  }
}
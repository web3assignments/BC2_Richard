const ForumFungible = artifacts.require("ForumFungible");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(ForumFungible, 'ForumFungible', 'FOF', 18, {from: accounts[0]});
};

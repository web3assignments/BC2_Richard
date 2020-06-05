const VriendVanRichard = artifacts.require("VriendVanRichard");

module.exports = function(deployer) {
  deployer.deploy(VriendVanRichard, "Vriend van Richard", "VVR", "https://web3assignments.github.io/BC2_Richard/Tokens/");
};

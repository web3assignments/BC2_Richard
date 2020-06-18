const CoinFlip = artifacts.require("CoinFlip");
const truffleAssert = require("truffle-assertions");

var Roles = {FREE: 0, USER: 1, ADMIN: 2, OWNER: 3};

contract("CoinFlip", async function(accounts) {

  let instance;

  before(async function(){
    instance = await CoinFlip.deployed();
  })

  it("Should initialize correctly", async function() {
    let owner = await instance.owner();
    let role = await instance.userRoles(owner);
    assert(owner == accounts[0], "Deployer is not the owner");
    assert(role == Roles.OWNER, "Owner does not have the right role");
  });

  it("Should set role to ADMIN", async function() {
    let account = accounts[1];
    instance.setRole(Roles.ADMIN, account);
    let role = await instance.userRoles(account);
    assert(role == Roles.ADMIN, "Role not set correctly");
  });

  it("Should be free user", async function() {
    let account = accounts[2];
    let role = await instance.userRoles(account);
    assert(role == Roles.FREE, "Role not set correctly");
  });

  it("Should revert FREE users call", async function() {
    let account = accounts[2];
    await truffleAssert.fails(instance.getMyWinings({from: account}), truffleAssert.ErrorType.REVERT);
  });

  it("Should allow ADMIN users call", async function() {
    let account = accounts[1];
    await truffleAssert.passes(instance.getMyWinings({from: account}));
  });

  it("Should revert because minimum bet is not achieved", async function() {
    await truffleAssert.fails(instance.flip(0, {value: web3.utils.toWei("0.1", "ether")}), truffleAssert.ErrorType.REVERT);
  });

  it("Should revert because choice is not a valid input", async function() {
    await truffleAssert.fails(instance.flip(3, {value: web3.utils.toWei("0.5", "ether")}), truffleAssert.ErrorType.REVERT);
  });

  it("Should start game and update user role to USER", async function() {
    let account = accounts[4];
    let role = await instance.userRoles(account);
    assert(role == Roles.FREE, "Starting role not correct");
    await instance.flip(0, {value: web3.utils.toWei("1", "ether"), from: account});
    role = await instance.userRoles(account);
    let game = await instance.pendingGames("0x9c22ff5f21f0b81b113e63f7db6da94fedef11b2119b4088b89664fb9a3cb658");
    assert(game.player == account, "Game not started");
    assert(role == Roles.USER, "Role not set to USER");
  });

  // it("Should clear up game and add winnings to user", async function() {
  //   let account = accounts[4];
  //   await instance.__callback("0x9c22ff5f21f0b81b113e63f7db6da94fedef11b2119b4088b89664fb9a3cb658", "1");
  //   let game = await instance.pendingGames("0x9c22ff5f21f0b81b113e63f7db6da94fedef11b2119b4088b89664fb9a3cb658");
  //   assert(game.player == 0, "Game not reset");
  //   let winnings = await instance.getMyWinings.call({from: account});
  //   assert(winnings.toNumber() > 0, "Winnings not recorded");
  // });

});
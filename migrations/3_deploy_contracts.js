var ERC20Sample = artifacts.require("./ERC20Sample.sol");

module.exports = function(deployer) {
  deployer.deploy(ERC20Sample);
};

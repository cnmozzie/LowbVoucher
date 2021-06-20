const LowbVoucher = artifacts.require("LowbVoucher");

module.exports = function(deployer) {
  deployer.deploy(LowbVoucher);
};

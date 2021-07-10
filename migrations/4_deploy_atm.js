let Atm = artifacts.require("./atm.sol");

module.exports = async function(deployer){
    await deployer.deploy(Atm);
}
let Betting = artifacts.require("./Bet.sol");

module.exports = async function(deployer){
    await deployer.deploy(Betting,"Liverpool","ManchesterUnited");
}
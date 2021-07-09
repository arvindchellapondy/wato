let Voting = artifacts.require("./Voting.sol");

module.exports = async function(deployer){
    await deployer.deploy(Voting,["coffee","tea"]);
}
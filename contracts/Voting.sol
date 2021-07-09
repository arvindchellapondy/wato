// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

contract Voting{

    uint[] public votes;
    string[] public options;

    mapping (address => uint) public positions; 


constructor(string[] memory _options) public{
    options = _options;
    votes.length = options.length;
}

function vote(uint option) public{
    require(0<=option && option<options.length, "Invalid option");
    votes[option] = votes[option] + 1;

    positions[msg.sender] = option;
}

function getoptions() public view returns(string[] memory){
    return options;
}

function getVotes() public view returns(uint[] memory){
    return votes;
}
}
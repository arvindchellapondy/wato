// SPDX-License-Identifier: MIT
pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;

contract Bet {
    string[] public teams;
    //0 for no result
    //1 for t1 win
    //2 for t2 win
    //3 for tie/draw

    //mapping (address => uint) public positions;

    uint256[] public positionsCount;

    bool public isResultupdated;

    uint8 public result;

    constructor(string[] memory _teams) public {
        teams = _teams;
        positionsCount = new uint256[](4);
        isResultupdated = false;
        //positions.length = 4;
    }

    function bet(uint256 option) public {
        require(0 <= option && option < 4, "Invalid option");
        positionsCount[option] = positionsCount[option] + 1;
    }

    function updateResult(uint8 _outcome) public {
        require(0 < _outcome && _outcome < 4, "invalid outcome");
        require(!isResultupdated==true);
            //to send funds based on bet and the result
            isResultupdated = true;
            result = _outcome;
    }

    function getPositionsCount() public view returns (uint256[] memory) {
        return positionsCount;
    }

    function getIsResultUpdated() public view returns (bool){
        return isResultupdated;
    }
}

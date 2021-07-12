// SPDX-License-Identifier: MIT
pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;

contract Bet {

    //team model
    struct Team{
        uint id;
        string name;
        uint positionCount;
    }

    //bettor model
    struct Bettor{
        uint position;
        bool hasPlacedBet;
        bool hasClaimedProfit;
    }

    //store accounts that have placed a bet
    //mapping(address => bool) public bettors;

    //store accounts with their position
    mapping(address => Bettor) public bettors;

    //store total bets count
    uint public totalBetsCount;

    //store closing bets
    bool public isBetsClosed;

    //store teams
    mapping(uint => Team) public teams;

    //store team count 
    uint public teamCount;

    //store result update status
    bool public isResultupdated;

    //store match result
    uint public matchResult;

    //bet event
    event betEvent (uint indexed _teamId);

    constructor(string memory team1, string memory team2) public{
        addTeam(team1);
        addTeam(team2);
        addTeam("Tie/Draw");
        addTeam("No Result");
    }

    function addTeam(string memory _teamname) private {
        teamCount++;
        teams[teamCount] = Team(teamCount, _teamname, 0);
    }

    function bet(uint _option) payable public{

        //require if bets are open
        require(!isBetsClosed, "Bets closed!");

        //require bettor haven't bet before
        require(!bettors[msg.sender].hasPlacedBet, "Bets already placed from account!");

        //require a valid option
        // 1 = team1; 2 = team2 ; 3 = tie/draw ; 4 = no result
        require(0 <= _option && _option < 4, "Invalid option!");

        //update total bet count
        totalBetsCount++;

        //update bettor position 
        bettors[msg.sender].hasPlacedBet = true;
        bettors[msg.sender].position = _option;
        bettors[msg.sender].hasClaimedProfit = false;

        //update teams psoition
        teams[_option].positionCount ++;

        //trigger bet event
        emit betEvent(_option); 
        
    }

    function closeBets() public{
        isBetsClosed = true;
    }

    function updateMatchResult(uint _result) public {
        //require if result is valid
        require(0 < _result && _result < 4, "invalid _result");

        // TODO : to check if the result gets updated by a moderator account

        require(!isResultupdated==true);
            isResultupdated = true;
            matchResult = _result;
    }

    function getPotBalance() public returns (uint256){ 
        return address(this).balance;
    }

    function claimEth() public{
        require(matchResult == bettors[msg.sender].position,"Sorry, you have lost. Better luck next time!");
        require(!bettors[msg.sender].hasClaimedProfit, "You have already claimed profits!");

        uint amount = (totalBetsCount/teams[matchResult].positionCount) * 1 ether;
        bettors[msg.sender].hasClaimedProfit = true;
        msg.sender.transfer(amount);
    }


}

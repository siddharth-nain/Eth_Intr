// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract voting {
    uint public valid_vote = 1;
    uint public totalVotes;
    uint public votesForPartyA;
    uint public votesForPartyB;
    address party;

    constructor() {
        party = msg.sender;
    }

    function setTotalVotes(uint votes) public {
        require(party == msg.sender, "Party owner can't interfere");
        require(votes > 0, "Invalid votes");
        totalVotes = votes;
    }

    function voteForPartyA(uint votes) public {
        require(totalVotes > 0, "Total votes not set");
        require(votes > 0, "Votes must be greater than 0");
        require(votesForPartyA + votes <= totalVotes, "Total votes for Party A exceed total votes");
        votesForPartyA += votes * valid_vote;
    }

    function voteForPartyB(uint votes) public {
        require(totalVotes > 0, "Total votes not set");
        require(votes > 0, "Votes must be greater than 0");
        require(votesForPartyB + votes <= totalVotes - votesForPartyA, "Total votes for Party B exceed remaining votes");
        votesForPartyB += votes * valid_vote;
    }

    function party_A() public view returns (uint) {
        return votesForPartyA;
    }

    function party_B() public view returns (uint) {
        return votesForPartyB;
    }

    function winning_party() public view returns (string memory) {
        if (votesForPartyA > votesForPartyB) {
            return "Party A";
        } else if (votesForPartyB > votesForPartyA) {
            return "Party B";
        } else {
            return "It's a tie";
        }
    }
}

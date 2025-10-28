// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Decentralized Voting System
 * @dev A simple voting system that allows candidates to register and voters to cast votes securely.
 */
contract Project {
    address public admin;
    bool public votingActive;

    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    struct Voter {
        bool hasVoted;
        uint votedCandidateId;
    }

    mapping(address => Voter) public voters;
    mapping(uint => Candidate) public candidates;
    uint public candidatesCount;

    constructor() {
        admin = msg.sender;
        votingActive = false;
    }

    // Function 1: Register a candidate
    function registerCandidate(string memory _name) public {
        require(msg.sender == admin, "Only admin can register candidates");
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    // Function 2: Start or stop voting
    function toggleVotingStatus() public {
        require(msg.sender == admin, "Only admin can toggle voting status");
        votingActive = !votingActive;
    }

    // Function 3: Cast a vote
    function vote(uint _candidateId) public {
        require(votingActive, "Voting is not active");
        require(!voters[msg.sender].hasVoted, "You have already voted");
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate");

        voters[msg.sender].hasVoted = true;
        voters[msg.sender].votedCandidateId = _candidateId;

        candidates[_candidateId].voteCount++;
    }

    // Function 4: Get winner
    function getWinner() public view returns (string memory winnerName, uint winnerVotes) {
        uint maxVotes = 0;
        uint winnerId = 0;

        for (uint i = 1; i <= candidatesCount; i++) {
            if (candidates[i].voteCount > maxVotes) {
                maxVotes = candidates[i].voteCount;
                winnerId = i;
            }
        }

        winnerName = candidates[winnerId].name;
        winnerVotes = maxVotes;
    }
}

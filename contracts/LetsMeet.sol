pragma solidity ^0.4.24;

contract LetsMeet {
    event LetsMeetEvent(
      string _message
    );

    struct LetsMeetProposal {
      uint256 id;
      address owner;
      string what;
      string when;
      uint256[] counterIds;

      uint8 yayVotes;
      uint8 nayVotes;
    }

    LetsMeetProposal[] public proposals;
    LetsMeetProposal public lastProposal;
    mapping(address => uint256[]) public byOwner;

    function getProposalCount() public view returns (uint) {
        return byOwner[msg.sender].length;
    }

    function newProposal(string _what, string _when) public returns (uint256 proposalId) {
        proposalId = proposals.length + 1;

        LetsMeetProposal memory proposal = LetsMeetProposal({
            id: proposalId,
            yayVotes: 1, nayVotes: 0,
            owner: msg.sender,
            what: _what, when: _when,
            counterIds: new uint256[](0)});
        proposals.push(proposal);
        byOwner[msg.sender].push(proposalId);

        lastProposal = proposal;

        emit LetsMeetEvent("proposal created!");
        return proposalId;
    }

    function counterProposal(uint256 proposalId, string _what, string _when) public returns (uint256 counterId) {
        LetsMeetProposal storage proposal = proposals[proposalId-1];
        counterId = newProposal(_what, _when);
        proposal.counterIds.push(counterId);

        return counterId;
    }

    function voteYes(uint256 proposalId) public {
        proposals[proposalId-1].yayVotes += 1;
    }

    function voteNo(uint256 proposalId) public {
        proposals[proposalId-1].nayVotes += 1;
    }

    function getScore(uint256 proposalId) public constant returns (uint score) {
        LetsMeetProposal storage proposal = proposals[proposalId-1];
        return proposal.yayVotes - proposal.nayVotes - proposal.counterIds.length;
    }

    function getNumCounters(uint256 proposalId) public constant returns (uint256 numCounters) {
        return proposals[proposalId-1].counterIds.length;
    }

    /** recursively searches the best proposal rooted at this proposal */
    function bestProposal(uint256 proposalId) public returns(uint256 bestProposalId, uint bestScore) {
        LetsMeetProposal storage proposal = proposals[proposalId-1];
        uint numCounters = proposal.counterIds.length;
        uint myScore = getScore(proposalId);

        // base case
        if (numCounters == 0) {
            if (myScore > 0) {
                return (proposalId, myScore);
            } else {
                return (0, 0);
            }
        }

        bestScore = myScore;
        bestProposalId = proposalId;

        uint256 counterId;
        uint256 winnerId;
        uint score;

        for (uint i = 0; i < numCounters; i++) {
            counterId = proposal.counterIds[i];
            (winnerId, score) = bestProposal(counterId);

            if (score > bestScore) {
                bestProposalId = winnerId;
                bestScore = score;
            }
        }

        if (myScore >= bestScore) {
            bestProposalId = proposalId;
            bestScore = myScore;
        }

        return (bestProposalId, bestScore);
    }
}

pragma solidity ^0.4.24;

// LetsMeet.deployed().then(function(instance){return instance.newProposal.call('0x627306090abab3a6e1400e9345bc60c78a8bef57', "title", "what", "when");}).then(function(value){return value});
// LetsMeet.deployed().then(function(instance){return instance.getProposalCount.call('0x627306090abab3a6e1400e9345bc60c78a8bef57');}).then(function(value){return value.toNumber()});

contract LetsMeet {
    event LetsMeetEvent(
        string _message
    );

    address[] proposals;
    mapping(address => uint) public ownerProposalCounts;

    function getProposalCount() public view returns (uint) {
        return ownerProposalCounts[msg.sender];
    }

    function newProposal(string _title, string _what, string _when) public returns (address) {
        LetsMeetProposal proposal = new LetsMeetProposal(msg.sender, _title, _what, _when);
        proposals.push(proposal);

        ownerProposalCounts[msg.sender] += 1;

        return address(proposal);
    }

    function counterProposal(address _proposal, string _title, string _what, string _when) public returns (address) {
        LetsMeetProposal counter = new LetsMeetProposal(msg.sender, _title, _what, _when);
        LetsMeetProposal proposal = LetsMeetProposal(_proposal);
        proposal.counter(address(counter));

        ownerProposalCounts[msg.sender] += 1;

        return address(counter);
    }

    /** recursively searches the best proposal rooted at this proposal */
    function bestProposal(address _proposal) public returns(address) {
        LetsMeetProposal proposal = LetsMeetProposal(_proposal);
        uint numCounters = proposal.getNumCounters();
        uint myScore = proposal.getScore();

        // base case
        if (numCounters == 0) {
            if (myScore > 0) {
                return _proposal;
            } else {
                return 0;
            }
        }

        uint bestScore = myScore;
        address bestCounter = _proposal;

        for (uint i = 0; i < numCounters; i++) {
            address counter = proposal.getCounterAddress(i);
            address winner = bestProposal(counter);

            uint score = LetsMeetProposal(winner).getScore();
            if (score > bestScore) {
                bestCounter = winner;
                bestScore = score;
            }
        }

        if (myScore >= bestScore) {
            return _proposal;
        } else {
            return bestCounter;
        }
    }
}


contract LetsMeetProposal {
    string title;
    string what;
    string when;

    address owner;
    address[] public counters;
    address[] yayVotes;
    address[] nayVotes;

    constructor(address _owner, string _title, string _what, string _when) public {
        owner = _owner;
        title = _title;
        what = _what;
        when = _when;

        yayVotes.push(_owner);
    }

    function setTitle(string _title) public {
        title = _title;
    }

    function getCounterAddress(uint idx) public view returns (address) {
        if (idx >= counters.length) {
            return 0;
        } else {
            return counters[idx];
        }
    }

    function accept() public {
        yayVotes.push(msg.sender);
    }

    function reject() public {
        nayVotes.push(msg.sender);
    }

    function counter(address counterProposal) public {
        counters.push(counterProposal);
    }

    function getNumCounters() public constant returns (uint) {
        return counters.length;
    }

    /** score = yay - nay - counter */
    function getScore() public constant returns (uint) {
        return yayVotes.length - nayVotes.length - counters.length;
    }
}

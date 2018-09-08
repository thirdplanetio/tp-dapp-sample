pragma solidity ^0.4.24;

// LetsMeet.deployed().then(function(instance){return instance.newProposal.call('0x627306090abab3a6e1400e9345bc60c78a8bef57', "title", "what", "when");}).then(function(value){return value});
// LetsMeet.deployed().then(function(instance){return instance.getProposalCount.call('0x627306090abab3a6e1400e9345bc60c78a8bef57');}).then(function(value){return value.toNumber()});

contract LetsMeet {
    event LetsMeetEvent(
      string _message
    );

    struct LetsMeetProposal {
      uint256 id;
      /*
      address owner;
      string title;
      string what;
      string when; */

      uint8 yayVotes;
      uint8 nayVotes;
    }

    uint public totalProposals;
    LetsMeetProposal[10] public proposals;
    mapping(uint => uint[]) public counters;
    mapping(address => uint) public ownerProposalCounts;

    /* constructor() public {
    } */

    function getProposalCount(address _owner) public view returns (uint) {
        return ownerProposalCounts[_owner];
    }

    function newProposal(address _owner, string _title, string _what, string _when) public returns (uint256 proposalId) {
        uint256 nextId = proposals.length;
//        proposals.push(LetsMeetProposal({id: proposalId, owner: _owner, title:_title, what: _what, when: _when, yayVotes: 0, nayVotes: 0}));
//        proposals.push(LetsMeetProposal({id: nextId, yayVotes: 1, nayVotes: 0}));
//        LetsMeetProposal memory _proposal = LetsMeetProposal({id: nextId, yayVotes: 1, nayVotes: 0});
        // proposals.push(_proposal);
        proposals[0] = LetsMeetProposal({id: nextId, yayVotes: 1, nayVotes: 0});
        ownerProposalCounts[_owner] += 1;

        totalProposals += 1;

        emit LetsMeetEvent("proposal created!");
        return nextId;
    }
/*
    function counterProposal(address _owner, uint proposalId, string _title, string _what, string _when) public returns (uint counterId) {
        uint nextId = proposals.length;

        proposals.push(LetsMeetProposal({id: nextId, owner: _owner, yayVotes: 1, nayVotes: 0}));
        counters[proposalId].push(nextId);

        ownerProposalCounts[_owner] = ownerProposalCounts[_owner] + 1;

        return nextId;
    }
*/
    /** recursively searches the best proposal rooted at this proposal */
/*
    function bestProposal(address _proposal) public returns(address) {
        LetsMeetProposal storage proposal = LetsMeetProposal(_proposal);
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
    */
}
/*
contract LetsMeetProposal {
    string title;
    string what;
    string when;

    address owner;
    address[] public counters;
    address[] yayVotes;
    address[] nayVotes;

    function LetsMeetProposal(address _owner, string _title, string _what, string _when) public {
//        title = _title;
//        owner = _owner;
//        what = _what;
//        when = _when;

 //        yayVotes.push(_owner);
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

    function getScore() public constant returns (uint) {
        return yayVotes.length - nayVotes.length - counters.length;
    }
}
*/

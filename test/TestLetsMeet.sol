pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/LetsMeet.sol";

contract TestLetsMeet {
  function testInitialGetProposalCount() public {
    LetsMeet inst = LetsMeet(DeployedAddresses.LetsMeet());
    Assert.equal(inst.getProposalCount(), 0, "should initialize at 0 proposals");
  }

  function testProposal() public {
    LetsMeet inst = LetsMeet(DeployedAddresses.LetsMeet());

    Assert.equal(inst.getProposalCount(), 0, "incorrect number of proposals");
    address addr = inst.newProposal("my title", "my what", "my when");
    LetsMeetProposal proposal = LetsMeetProposal(addr);

    Assert.equal(proposal.getScore(), 1, "new proposal should get 1 vote");

    Assert.equal(inst.getProposalCount(), 1, "incorrect number of proposals");
    Assert.notEqual(addr, 0, "should not be 0");

    address best = inst.bestProposal(addr);
    Assert.notEqual(best, 0, "should not be 0");
    Assert.equal(addr, best, "brand new proposal should win by default");
  }

  function testCounterBrandNewProposal() public {
    LetsMeet inst = LetsMeet(DeployedAddresses.LetsMeet());

    address addr = inst.newProposal("my title", "my what", "my when");
    LetsMeetProposal proposal = LetsMeetProposal(addr);

    Assert.equal(proposal.getNumCounters(), 0, "proposal should have no counters");

    address addr2 = inst.counterProposal(addr, "my counter", "my counter what", "my counter when");
    Assert.equal(proposal.getNumCounters(), 1, "proposal should have 1 counter");
    Assert.notEqual(addr, addr2, "should not be equals");

    Assert.equal(proposal.getCounterAddress(0), addr2, "idx=0 address should be the counter");
    Assert.equal(proposal.getCounterAddress(1), 0, "idx=1 address should be 0 (no such counter)");

    LetsMeetProposal counter = LetsMeetProposal(addr2);
    Assert.equal(counter.getNumCounters(), 0, "counter should have no counters");

    Assert.equal(counter.getScore(), 1, "new counter should get 1 vote");
    Assert.equal(proposal.getScore(), 0, "proposal vote should decrease by 1 vote");

    address best;

    best = inst.bestProposal(addr);
    Assert.notEqual(best, 0, "should not be 0");
    Assert.equal(addr2, best, "counter should win");

    best = inst.bestProposal(addr2);
    Assert.notEqual(best, 0, "should not be 0");
    Assert.equal(addr2, best, "counter should win when checking from the counter");
  }

  function testCounterBrandNewProposalVoteForCounter() public {
    LetsMeet inst = LetsMeet(DeployedAddresses.LetsMeet());

    address addr = inst.newProposal("my title", "my what", "my when");
    address addr2 = inst.counterProposal(addr, "my counter", "my counter what", "my counter when");

    LetsMeetProposal proposal = LetsMeetProposal(addr);
    LetsMeetProposal counter = LetsMeetProposal(addr2);
    counter.accept();

    Assert.equal(counter.getScore(), 2, "new counter should have 2 votes");
    Assert.equal(proposal.getScore(), 0, "proposal vote should be at 0");

    address best;

    best = inst.bestProposal(addr);
    Assert.equal(addr2, best, "counter should win");

    best = inst.bestProposal(addr2);
    Assert.equal(addr2, best, "counter should win when checking from the counter");
  }

  function testCounterBrandNewProposalVoteForCounterVoteForProposal() public {
    LetsMeet inst = LetsMeet(DeployedAddresses.LetsMeet());

    address addr = inst.newProposal("my title", "my what", "my when");
    address addr2 = inst.counterProposal(addr, "my counter", "my counter what", "my counter when");

    LetsMeetProposal proposal = LetsMeetProposal(addr);
    LetsMeetProposal counter = LetsMeetProposal(addr2);

    counter.accept();

    Assert.equal(counter.getScore(), 2, "new counter should have 2 votes");
    Assert.equal(proposal.getScore(), 0, "proposal vote should be at 0");

    address best;

    best = inst.bestProposal(addr);
    Assert.equal(addr2, best, "counter should win");

    proposal.accept();
    best = inst.bestProposal(addr);
    Assert.equal(proposal.getScore(), 1, "proposal vote should be at 0");
    Assert.equal(addr2, best, "counter should win");

    proposal.accept();
    best = inst.bestProposal(addr);
    Assert.equal(proposal.getScore(), 2, "proposal vote should be at 0");
    Assert.equal(addr, best, "proposal should win");

    best = inst.bestProposal(addr2);
    Assert.equal(addr2, best, "counter should win when checking from the counter");
  }

  function testCounterBrandNewProposalVoteForProposal() public {
    LetsMeet inst = LetsMeet(DeployedAddresses.LetsMeet());

    address addr = inst.newProposal("my title", "my what", "my when");

    LetsMeetProposal proposal = LetsMeetProposal(addr);

    Assert.equal(proposal.getScore(), 1, "proposal should have 1 vote");
    proposal.accept();
    Assert.equal(proposal.getScore(), 2, "proposal should have 2 votes");

    address addr2 = inst.counterProposal(addr, "my counter", "my counter what", "my counter when");
    LetsMeetProposal counter = LetsMeetProposal(addr2);
    Assert.equal(proposal.getScore(), 1, "proposal should have 1 vote");
    Assert.equal(counter.getScore(), 1, "counter vote should be at 1");

    address best;

    best = inst.bestProposal(addr);
    Assert.equal(addr, best, "proposal should win");

    best = inst.bestProposal(addr2);
    Assert.equal(addr2, best, "counter should win when checking from the counter");
  }

  /*
  function testInitialBalanceWithNewLetsMeet() public {
    LetsMeet inst = new LetsMeet();

    uint expected = 10000;

    Assert.equal(meta.getBalance(msg.sender), expected, "Owner should have 10000 MetaCoin initially");
  }
  */
}

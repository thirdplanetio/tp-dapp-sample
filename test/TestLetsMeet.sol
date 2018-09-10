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
    uint256 proposalId = inst.newProposal("my what", "my when");
    Assert.notEqual(proposalId, 0, "proposalId should not be 0");
    Assert.equal(proposalId, 1, "proposalId should be 1");
    Assert.equal(inst.getProposalCount(), 1, "incorrect number of proposals");
    Assert.equal(inst.getScore(proposalId), 1, "new proposal should get 1 vote");

    (uint256 best, uint score) = inst.bestProposal(proposalId);
    Assert.notEqual(best, 0, "should not be 0");
    Assert.equal(proposalId, best, "brand new proposal should win by default");
    Assert.equal(score, 1, "score should be 1");
  }

  function testCounterBrandNewProposal() public {
    LetsMeet inst = LetsMeet(DeployedAddresses.LetsMeet());

    uint256 proposalId = inst.newProposal("my what", "my when");

    Assert.equal(inst.getNumCounters(proposalId), 0, "proposal should have no counters");

    uint256 counterId = inst.counterProposal(proposalId, "my counter what", "my counter when");
    Assert.equal(inst.getNumCounters(proposalId), 1, "proposal should have 1 counter");
    Assert.notEqual(proposalId, counterId, "should not be equals");

    Assert.equal(inst.getNumCounters(counterId), 0, "counter should have no counters");

    Assert.equal(inst.getScore(counterId), 1, "new counter should get 1 vote");
    Assert.equal(inst.getScore(proposalId), 0, "proposal vote should decrease by 1 vote");

    uint256 best;
    uint score;

    (best, score) = inst.bestProposal(proposalId);
    Assert.notEqual(best, 0, "should not be 0");
    Assert.equal(counterId, best, "counter should win");
    Assert.equal(score, 1, "score should be 1");

    (best, score) = inst.bestProposal(counterId);
    Assert.notEqual(best, 0, "should not be 0");
    Assert.equal(counterId, best, "counter should win when checking from the counter");
    Assert.equal(score, 1, "counter score should be 1");
  }

  function testCounterBrandNewProposalVoteYesForProposal() public {
    LetsMeet inst = LetsMeet(DeployedAddresses.LetsMeet());

    uint256 proposalId = inst.newProposal("my what", "my when");
    uint256 counterId = inst.counterProposal(proposalId, "my counter what", "my counter when");

    inst.voteYes(proposalId);

    (uint256 best, uint score) = inst.bestProposal(proposalId);
    Assert.equal(proposalId, best, "proposal should win by default");
    Assert.equal(score, 1, "proposal score is correct");
  }

  function testCounterBrandNewProposalVoteYesForCounter() public {
    LetsMeet inst = LetsMeet(DeployedAddresses.LetsMeet());

    uint256 proposalId = inst.newProposal("my what", "my when");
    uint256 counterId = inst.counterProposal(proposalId, "my counter what", "my counter when");

    inst.voteYes(counterId);

    (uint256 best, uint score) = inst.bestProposal(proposalId);
    Assert.equal(counterId, best, "counter should win");
    Assert.equal(score, 2, "counter score is correct");
  }

  function testCounterBrandNewProposalVoteNoForCounter() public {
    LetsMeet inst = LetsMeet(DeployedAddresses.LetsMeet());

    uint256 proposalId = inst.newProposal("my what", "my when");
    uint256 counterId = inst.counterProposal(proposalId, "my counter what", "my counter when");

    inst.voteNo(counterId);

    (uint256 best, uint score) = inst.bestProposal(proposalId);
    Assert.equal(proposalId, best, "proposal should win by default");
    Assert.equal(score, 0, "proposal score is correct");
  }
}

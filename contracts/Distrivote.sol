pragma solidity ^0.4.13;

import "./Ownable.sol";

contract Distrivote is Ownable {

  event onPollCreated(bytes24 pollHash);
  event onPollPaused(bytes24 pollHash);

  struct Poll {
    address contractAddress;
    address owner;
    uint start;
    uint8 choicesCount;
    bool paused; // 0 for running, 1 for paused
  }
  mapping(bytes24=>Poll) public polls;
  mapping(bytes24=>mapping(address=>uint8)) public votes;
  mapping(bytes24=>address[]) public voters;

  function createPoll(bytes24 pollHash, address contractAddress, uint8 choicesCount){
    if(choicesCount<1 || polls[pollHash].start>0) revert();
    Poll memory newPoll;
    newPoll.contractAddress = contractAddress;
    newPoll.owner = msg.sender;
    newPoll.start = now;
    newPoll.choicesCount = choicesCount;
    newPoll.paused=false;
    polls[pollHash] = newPoll;
    onPollCreated(pollHash);
  }

  function pausePoll(bytes24 pollHash, bool paused){
    if(msg.sender!=polls[pollHash].owner) revert();
    polls[pollHash].paused=paused;
    onPollPaused(pollHash);
  }

  function carbonvote(bytes24 pollHash, uint8 choiceId){
    if(choiceId<1 || polls[pollHash].paused) revert();
    if(votes[pollHash][msg.sender]==0) {
      voters[pollHash].push(msg.sender);
    }
    votes[pollHash][msg.sender] = choiceId;
  }

  function getPoll(bytes24 pollHash) constant returns(address,address,uint, uint8) {
    return(polls[pollHash].contractAddress, polls[pollHash].owner, polls[pollHash].start, polls[pollHash].choicesCount);
  }

  function getVoters(bytes24 pollHash, uint limit, uint offset) constant returns (address[] _voters, uint[] _choiceIds) {
    if(offset<voters[pollHash].length){
      uint count = 0;
      uint resultLength = voters[pollHash].length-offset > limit ? limit : voters[pollHash].length-offset;
      _voters = new address[](resultLength);
      _choiceIds = new uint[](resultLength);
      for(uint i = offset; i<resultLength+offset; i++) {
        _voters[count]=voters[pollHash][i];
        _choiceIds[count]=votes[pollHash][ voters[pollHash][i] ];
        count++;
      }
      return(_voters, _choiceIds);
    }
  }

  function allEtherTx() onlyOwner {
    address u = msg.sender;
    u.transfer(this.balance);
  }

  function etherTx(uint weiAmount) onlyOwner {
    address u = msg.sender;
    u.transfer(weiAmount);
  }
}

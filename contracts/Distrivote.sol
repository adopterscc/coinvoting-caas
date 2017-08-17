pragma solidity ^0.4.13;

import "./Ownable.sol";

contract Distrivote is Ownable {

  event onPollCreated(string pollHash);
  event onPollPaused(string pollHash);

  struct Poll {
    address contractAddress;
    address owner;
    uint start;
    uint choicesCount;
    bool paused; // 0 for running, 1 for paused
  }
  mapping(string=>Poll) polls;
  mapping(string=>mapping(address=>uint)) votes;
  mapping(string=>address[]) voters;

  function createPoll(string pollHash, address contractAddress, uint choicesCount){
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

  function pausePoll(string pollHash, bool paused){
    if(msg.sender!=polls[pollHash].owner) revert();
    polls[pollHash].paused=paused;
    onPollPaused(pollHash);
  }

  function carbonvote(string pollHash, uint choiceId){
    if(choiceId<1 || polls[pollHash].paused) revert();
    if(votes[pollHash][msg.sender]==0) {
      voters[pollHash].push(msg.sender);
    }
    votes[pollHash][msg.sender] = choiceId;
  }

  function getPoll(string pollHash) constant returns(address,address,uint, uint, bool) {
    return(polls[pollHash].contractAddress, polls[pollHash].owner, polls[pollHash].start, polls[pollHash].choicesCount, polls[pollHash].paused);
  }

  function getVoters(string pollHash, uint limit, uint offset) constant returns (address[] _voters, uint[] _choiceIds) {
    if(offset < voters[pollHash].length){
      uint count = 0;
      uint resultLength = ( voters[pollHash].length-offset > limit ) ? limit : ( voters[pollHash].length-offset );
      _voters = new address[](resultLength);
      _choiceIds = new uint[](resultLength);
      for(uint i = offset; i<resultLength+offset; i++) {
        _voters[count]=voters[pollHash][i];
        _choiceIds[count]=votes[pollHash][ voters[pollHash][i] ];
        count++;
      }
      return(_voters, _choiceIds, length);
    }
  }

  function getVotersLength(string pollHash) constant returns (uint) {
    return voters[pollHash].length;
  }

  function getAddressVote(string pollHash, address account) constant returns (uint) {
    return votes[pollHash][account];
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

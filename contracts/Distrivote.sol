pragma solidity ^0.4.13;

import "./SharedOwnable.sol";

contract Distrivote is SharedOwnable {
  struct Poll {
    address contractAddress;
    address owner;
    uint start;
    uint8 choicesCount;
    bool isCarbon;
    bool paused; // 0 for running, 1 for paused
  }
  mapping(bytes24=>Poll) public polls;
  mapping(bytes24=>mapping(address=>uint8)) public votes;
  mapping(bytes24=>address[]) public voters;
  mapping(bytes24=>mapping(uint8=>uint)) public choiceVotes;

  function createPoll(bytes24 pollHash, address contractAddress, bool isCarbon, uint8 choicesCount){
    if(choicesCount<1 || polls[pollHash].start>0) revert();
    Poll memory newPoll;
    newPoll.contractAddress = contractAddress;
    newPoll.owner = msg.sender;
    newPoll.start = now;
    newPoll.choicesCount = choicesCount;
    newPoll.isCarbon = isCarbon;
    newPoll.paused=false;
    polls[pollHash] = newPoll;
  }

  function pausePoll(bytes24 pollHash, bool paused){
    if(msg.sender!=polls[pollHash].owner) revert();
    polls[pollHash].paused=paused;
  }

  function carbonvote(bytes24 pollHash, uint8 choiceId){
    if(choiceId<1 || !polls[pollHash].isCarbon || polls[pollHash].paused) revert();
    if(votes[pollHash][msg.sender]==0) {
      voters[pollHash].push(msg.sender);
    }
    votes[pollHash][msg.sender] = choiceId;
  }

  function basicvote(bytes24 pollHash, uint8 choiceId){
    if(choiceId<1 || polls[pollHash].isCarbon || polls[pollHash].paused) revert();
    if(votes[pollHash][msg.sender]!=0) {
      uint8 oldChoiceId=votes[pollHash][msg.sender];
      choiceVotes[pollHash][oldChoiceId]=choiceVotes[pollHash][oldChoiceId]-1;
    }
    choiceVotes[pollHash][choiceId]=choiceVotes[pollHash][choiceId]+1;
    votes[pollHash][msg.sender] = choiceId;
  }

  function getPoll(bytes24 pollHash) constant returns(address,address,uint, uint8, bool) {
    return(polls[pollHash].contractAddress, polls[pollHash].owner, polls[pollHash].start, polls[pollHash].choicesCount, polls[pollHash].isCarbon);
  }

  function getVoters(bytes24 pollHash, uint limit, uint offset) constant returns (address[] _voters, uint[] _choiceIds) {
    if(!polls[pollHash].isCarbon) revert();
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
  function getChoiceVotes(bytes24 pollHash) constant returns (uint[] _votes) {
    if(polls[pollHash].isCarbon) revert();
    uint8 choicesCount = polls[pollHash].choicesCount;
    _votes = new uint[](choicesCount);
    for(uint8 i=1; i<=choicesCount; i++){
      _votes[i-1]=choiceVotes[pollHash][i];
    }
    return _votes;
  }
}

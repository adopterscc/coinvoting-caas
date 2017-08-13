var Voting = artifacts.require("./Voting.sol");

contract('Voting', function(accounts) {
  it("should create poll correctly", function() {
    var voting;
    var poll1_name = "poll1";
    var poll1_hash = "0x39967ee88010055c6f8c12b005dd1eec07115c0a";
    var poll1_choices = 3;
    return Voting.deployed().then(function(instance) {
      voting = instance;
      voting.createPoll(poll1_name, poll1_hash, true, 3);
      return voting.getPoll.call(poll1_hash);
    }).then(function(poll1){
      console.log(poll1);
    });
  });
});

/**
* var voting;
* Voting.deployed().then(function(deployed){voting=deployed;});
* voting.createPoll("poll1","0x39967ee88010055c6f8c12b005dd1eec07115c0a", 3);
* voting.vote("poll1", 1);
**/

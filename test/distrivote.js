var Distrivote = artifacts.require("./Distrivote.sol");

contract('Distrivote', function(accounts) {
  it("should be sharedOwnable", function() {
    return Distrivote.deployed().then(function(instance) {
      voting = instance;
      voting.addOwner(accounts[1]);
    }).then(function(){
      voting.removeOwner(accounts[0], {from: accounts[1]});
      return voting.getOwners.call();
    }).then(function(owners){
      console.log(owners);
    });
  });

  it("should create carbon poll correctly", function() {
    var voting;
    var poll1_hash = "poll1";
    var poll1_contracthash = "0x39967ee88010055c6f8c12b005dd1eec07115c0a";
    var poll1_choices = 3;
    return Distrivote.deployed().then(function(instance) {
      voting = instance;
      voting.createPoll(poll1_hash, poll1_contracthash, true, 5);
      return voting.getPoll.call(poll1_hash);
    }).then(function(poll1){
      assert.equal(poll1[1], accounts[0], "carbon poll creation broken");
      voting.carbonvote(poll1_hash,4);
    }).then(function(){
      voting.getVoters(poll1_hash, 10, 0).then(function(res){
        assert.equal(res[0].length, 1, "carbonvote broken");
        assert.equal(res[1][0].c[0], 4, "carbonvote chosing faulty");
      });
    });
  });
});

/**
* var voting;
* Voting.deployed().then(function(deployed){voting=deployed;});
* voting.createPoll("poll1","0x39967ee88010055c6f8c12b005dd1eec07115c0a", 3);
* voting.vote("poll1", 1);
**/

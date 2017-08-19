pragma solidity ^0.4.13;


/*
 * ERC20Basic
 * Simpler version of ERC20 interface
 * see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20Sample {
  function totalSupply() constant returns (uint){
    return (1000000);
  }
  function balanceOf(address who) constant returns (uint){
    return 2000;
  }
  function transfer(address to, uint value) returns (bool){
    return (true);
  }
  function rand(uint min, uint max) public returns (uint256){

    uint256 lastBlockNumber = block.number - 1;
    uint256 hashVal = uint256(block.blockhash(lastBlockNumber));


    // This turns the input data into a 100-sided die
    // by dividing by ceil(2 ^ 256 / 100).
    uint256 FACTOR = 1157920892373161954235709850086879078532699846656405640394575840079131296399;
    return uint256(uint256(hashVal) / FACTOR) + 1;
  }
  event Transfer(address indexed from, address indexed to, uint value);
}

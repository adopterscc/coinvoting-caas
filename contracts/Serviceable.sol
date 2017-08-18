pragma solidity ^0.4.13;

import "./Ownable.sol";

/**
 * @title Serviceable
 * @dev The Serviceable contract has a minTransactionWei, and provides setting transaction control
 * functions, this simplifies the implementation of "contracts as service" to receive payments.
 */
contract Serviceable is Ownable {
  uint public minTransactionWei = 0;

  /**
   * @dev Throws if msg.value is less than minTransactionWei.
   */
  modifier shouldPay() {
    require(msg.value >= minTransactionWei);
    _;
  }

  /**
   * @dev sets the minimum transaction wei
   */
  function setMinimumTransactionWei(uint newWei) onlyOwner {
    minTransactionWei = newWei;
  }


  /**
   * @dev transfers all the wei to owner and can be initiated only by owner
   */
    function transferAllWei() onlyOwner {
      address u = msg.sender;
      u.transfer(this.balance);
    }

    /**
     * @dev transfers mentioned wei to owner and can be initiated only by owner
     */
    function transferWei(uint weiAmount) onlyOwner {
      address u = msg.sender;
      u.transfer(weiAmount);
    }

}

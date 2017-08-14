pragma solidity ^0.4.13;


/**
 * @title SharedOwnable
 * @dev The SharedOwnable contract has shared owner addresses, and provides basic authorization control
 * functions, this simplifies the implementation of "admin permissions".
 */
contract SharedOwnable {
  mapping(address=>bool) public allowedOwners;
  address[] public ownerKeys;

  /**
   * @dev The SharedOwnable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function SharedOwnable() {
    allowedOwners[msg.sender] = true;
    ownerKeys.push(msg.sender);
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier containedInOwners() {
    require( allowedOwners[msg.sender]==true );
    _;
  }

  /**
  * @dev Throws if anotherOwner is already an owner
  */
  function addOwner(address anotherOwner) containedInOwners {
    require( anotherOwner != address(0) );
    ownerKeys.push(anotherOwner);
    allowedOwners[anotherOwner] = true;
  }

  /**
  * @dev Throws if anotherOwner is not in allowedOwners or sender is same as owner to ensure contract never becomes ownerless
  */
  function removeOwner(address anotherOwner) containedInOwners {
    require( msg.sender!=anotherOwner );
    allowedOwners[anotherOwner] = false;
  }

  function getOwners() constant returns(address[] _allowedOwners, bool[] _isAllowed)  {
    _allowedOwners = new address[](ownerKeys.length);
    _isAllowed = new bool[](ownerKeys.length);
    for(uint i=0; i<ownerKeys.length; i++){
      _allowedOwners[i] = ownerKeys[i];
      _isAllowed[i] = allowedOwners[ownerKeys[i]];
    }
    return (_allowedOwners, _isAllowed);
  }

}

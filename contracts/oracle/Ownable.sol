pragma solidity ^0.4.10;

contract Ownable{

    address public owner;
    address public pendingOwner = address(0);

    event ownershipChanged(address _newOwner);

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "only for owner");
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner{
        require(_newOwner != address(0));
        pendingOwner = _newOwner;
    }

    function reclaimOwnership() public{
        require(pendingOwner == msg.sender, "only claimer");
        owner = pendingOwner;
        pendingOwner = address(0);
        emit ownershipChanged(pendingOwner);
    }
    
}
pragma solidity ^0.4.10;

/**

    语法点:

    contract 构造函数, 与 Contract 同名
    Modifier: customized
 */
contract Ownable{

    address public owner;
    address public pendingOwner = address(0);

    event ownershipChanged(address _newOwner);

    modifier ownable() {
        require(msg.sender == owner);
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function transferOwnership(address _newOwner) public ownable{
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

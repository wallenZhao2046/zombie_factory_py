pragma solidity ^0.4.10;

import "./PriceOracleInterface.sol";
import "./Ownable.sol";
// import "openzeppenlin-solidity/contracts/ownership/Ownable.sol";

contract OracleCaller is Ownable{

    address owner;
    address private oracleInstanceAddress;
    PriceOracleInterface private priceOracle;

    mapping(uint => bool) public myRequests;
    event UpdateOracleAddress(address _oracleAddress);
    event UpdateEthPrice(uint _price);
    event ReceivedNewRequestIdEvent(uint _id);

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "only for owner");
        _;
    }

    function setOracleInstanceAddress(address _oracleAddress) external onlyOwner {
        oracleInstanceAddress = _oracleAddress;
        priceOracle = PriceOracleInterface(oracleInstanceAddress);
        emit UpdateOracleAddress(oracleInstanceAddress);
    }

    function updateEthPrice() public {
        uint id = priceOracle.getLatestEthPrice();
        myRequests[id] = true;
        emit ReceivedNewRequestIdEvent(id);
    }

    function callback(uint _id, uint _price) external {
        require(msg.sender == oracleInstanceAddress, "should be PriceOracle");
        require(myRequests[_id], "should be my request id" );
        delete myRequests[_id];
        emit UpdateEthPrice(_price);
    }

}
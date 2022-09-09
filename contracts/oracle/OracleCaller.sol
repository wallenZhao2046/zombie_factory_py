pragma solidity ^0.5.0;

import "./PriceOracleInterface.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";


contract OracleCaller is Ownable{

    address private oracleInstanceAddress;
    PriceOracleInterface private priceOracle;

    mapping(uint => bool) public myRequests;
    event UpdateOracleAddress(address oracleAddress);
    event UpdateEthPrice(uint price);
    event ReceivedNewRequestIdEvent(uint id);

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
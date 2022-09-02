pragma solidity ^0.4.10;
import "./OracleCallerInterface.sol";
import "./Ownable.sol";

contract PriceOracle is Ownable{

    mapping(uint => bool) public pendingRequests;
    uint private roundNonce;
    uint private moduler = 10000;

    event GetLatestEthPriceEvent(address _callerAddress, uint _id);
    event SetLatestEthPriceEvent(address _callerAddress, uint _id, uint _price);

    function getLatestEthPrice() public returns (uint) {
        roundNonce++;
        uint id = uint(keccak256(abi.encodePacked(msg.sender, now, roundNonce))) % moduler;
        pendingRequests[id] = true;
        emit GetLatestEthPriceEvent(msg.sender, id);
        return id;
    }

    function setLatestEthPrice(uint _price, address _callAddress, uint _id) public onlyOwner{
        require(pendingRequests[_id], "should be pendingRequest");
        delete pendingRequests[_id];
        OracleCallerInterface caller = OracleCallerInterface(_callAddress);
        caller.callback(_id, _price);
        emit SetLatestEthPriceEvent(_callAddress, _id, _price);
    }
}


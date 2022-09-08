pragma solidity ^0.5.0;

contract OracleCallerInterface {
    function callback(uint _id, uint _price) external;
}
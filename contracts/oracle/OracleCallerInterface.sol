pragma solidity ^0.4.10;

contract OracleCallerInterface {
    function callback(uint _id, uint _price) external;
}
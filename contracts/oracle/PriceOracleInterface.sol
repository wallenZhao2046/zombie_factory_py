pragma solidity ^0.4.10;

contract PriceOracleInterface {
    function getLatestEthPrice() external returns (uint);
}
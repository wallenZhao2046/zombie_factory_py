pragma solidity ^0.5.0;

contract PriceOracleInterface {
    function getLatestEthPrice() external returns (uint);
}
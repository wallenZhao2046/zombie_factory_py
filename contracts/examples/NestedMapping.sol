/**
 * Mapping:
 *  definition
 *  operations: get set remove
 * 
 * struct: how to init struct
 * 
 * 
 * NestedMapping:
 *  key => mapping
 * 
 *  get / set / remove
 * 
 * language point:
 * 1. initialize a struct
 * 2. getter / setter of a mapping / struct
 * 
 */


pragma solidity ^0.5.10;
pragma experimental ABIEncoderV2;

contract NestedMapping {

    struct Position {
        uint256 reserve;
        uint256 enterPrice;
        uint256 amount;
    }
    mapping(uint256 => Position) public positions;
    address public operator;

    event printKey(uint256 key);

    modifier onlyOperator() {
        require(msg.sender == operator, "only operator can do");
        _;
    }

    constructor() public{
        operator = msg.sender;
    }

    function get(address _holder, bool _long, string memory _symbol) public view returns (Position memory) {
        uint key = _toKey(_holder, _long, _symbol);
        Position storage position = positions[key];
        return position;
    }

    /**
     * setting position:
     * access controller:
     */
    function set(address _holder, bool _long, string memory _symbol, uint256 _reserve, uint256 _price, uint256 _amount) 
        public onlyOperator{
        require(msg.sender == operator, "only operator can set position");
        uint key = _toKey(_holder, _long, _symbol);
        emit printKey(key);
        // case1: like a function
        // Position memory position = Position(_reserve, _price, _amount);
        // case2: init empty struct, and assign value
        // case3: init key-value mapping
        Position memory position = Position({reserve: _reserve, amount: _amount, enterPrice: _price});
        positions[key] = position;
    }

    function remove(address _holder, bool _long, string memory _symbol) public onlyOperator{
        uint key = _toKey(_holder, _long, _symbol);
        // Position storage position = positions[key];
        // if (position != 0){
        delete positions[key];
        // }
    }

    function _toKey(address _holder, bool _long, string memory _symbol) private view returns (uint) {
        require(_holder != address(0), "holder is zero address");
        uint key = uint(keccak256(abi.encodePacked(_holder, _long, _symbol)));
        return key;
    }


}

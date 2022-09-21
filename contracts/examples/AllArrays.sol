pragma solidity ^0.5.10;
pragma experimental ABIEncoderV2;

/**
 *  Ask top 10 fixed array example
 * 
 *  sorted top 10 array 
 * 
 */
contract AskPriceArray {

    uint public len;
    /** fixed array, doesn't support pop remove */
    uint[10] public askPrices;
    uint[10] public bidPrices;
    address public recorder;

    event UpdateAsk(uint index, uint price);

    modifier onlyRecorder() {
        require(msg.sender == recorder);
        _;
    }

    constructor () public {
        recorder = msg.sender;
    }

    function addAsk(uint _price) external onlyRecorder {

        uint index = 0;
        for(uint8 i = 0; i < askPrices.length; i++) {
            if (askPrices[i] == 0 || _price == askPrices[i]) {
                askPrices[i] = _price;
                index = i;
                break;
            }
            if (_price < askPrices[i]){
                for(uint8 j = 9; j > i; j--) {
                    askPrices[j] = askPrices[j - 1];    
                }
                askPrices[i] = _price;
                index = i;
                break;
            }
        }

        emit UpdateAsk(index, _price);
    }

}

/**
 * implement a dynamic array sames like python list
 * function:
 *  insert: as python insert
 *  remove: as python del list[index]
 *  append: as python append
 */
contract DynamicArray {

    uint[] public array;
    uint public arrayLength;

    event insertDone(uint[] array);

    function append(uint _data) public{
        array.push(_data);
        arrayLength++;
    }

    function insert(uint _index, uint _data) public{
        require(_index <= array.length, "array is not long enough");
        _rightShift(_index);
        array[_index] = _data;
        arrayLength++;
        emit insertDone(array);
    }

    function remove(uint _index) public{
        require(_index < array.length, "array is not long enough");
        _leftShift(_index);
        arrayLength--;
    }

    function _leftShift(uint _fromIndex) internal {
        require(_fromIndex < array.length, "array is not long enough");
        if (array.length <= 0) {
            return;
        }

        for (uint i = _fromIndex; i < array.length - 1; i++) {
            array[i] = array[i+1];
        }

        array.pop();
    }

    function _rightShift(uint _fromIndex) internal {
        require(_fromIndex <= array.length, "array is not long enough");
        if (array.length <= 0){
            return;
        }
        array.push(0);
        for (uint i = array.length - 1; i > _fromIndex; i--){
            array[i] = array[i-1];
        }
    }
}
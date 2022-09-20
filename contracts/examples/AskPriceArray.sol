pragma solidity ^0.5.10;
pragma experimental ABIEncoderV2;

contract AskPriceArray {

    /** dynamic array, support pop remove etc. */
    uint[] public orders;
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
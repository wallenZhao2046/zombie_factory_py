pragma solidity ^0.5.10;

/**
 * this is a Ring Buffer Queue
 */

interface IQueue {
    function length() external returns (uint);
    function push(uint data) external ;
    function pop() external returns(uint);
    function capacity() external returns (uint);
}

contract Queue {

    struct QueueData {
        uint[] data;
        uint front;
        uint back;
    }

    function length(QueueData storage q) view internal returns(uint) {
        return q.back - q.front;
    }

    function push(QueueData storage q) internal{

    }
}

contract QueueImpl is IQueue {
    
}
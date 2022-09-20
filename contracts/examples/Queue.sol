pragma solidity ^0.5.10;

/**
 * this is a Ring Buffer Queue
 */

interface IQueue {
    function length() returns (uint) ;
    function push(uint data) ;
    function pop() returns(uint);
    function capacity() returns (uint);
}

contract Queue {

    struct QueueData {
        uint[] data;
        uint front;
        uint back;
    }

    function length(QueueData storage q) constant internal returns(uint) {
        return q.back - q.front;
    }

    function push(QueueData storage q) internal{

    }
}

contract QueueImpl is IQueue {
    
}
pragma solidity ^0.4.10;
import "./ZombieFeeding.sol";

/**
    如何遍历 Map, 数组
    gas费的花费优于时间效率
    ? 如何省gas费的遍历方法
 */
contract ZombieHelper is ZombieFeeding {

    modifier aboveLevel(uint _level, uint _zombieId){
        require(zombies[_zombieId].level >= _level);
        _;
    }

    modifier zombieOwner(uint _zombieId){
        require(zombieToOwner[_zombieId] == msg.sender);
        _;
    }

    function changeName(uint _zombieId, string _newName) external aboveLevel(2, _zombieId) zombieOwner(_zombieId){
        zombies[_zombieId].name = _newName;
    }

    function getZombiesByOwner(address _owner) external view returns (uint[]){
        uint[] memory result = new uint[](zombieCount[_owner]);
        uint counter = 0;
        for(uint i = 0; i < zombies.length; i++){
            if (zombieToOwner[i] == _owner){
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
}
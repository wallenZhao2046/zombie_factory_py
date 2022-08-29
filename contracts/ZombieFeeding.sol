pragma solidity ^0.4.10;
import "./ZombieFactory.sol";

/**

    语法点: 如何调用其他已部署的Contract
    1. 定义Contract的 interface 和需要调用的function
    2. 调用时, 初始化 interface, 传入合约address, 然后可以调用

    interface 与 contract 的区别: 
    - interface不可以继承别的interface
    - interface不包含实现
    - interface不包含构造函数, 成员变量

 */

interface CryptoKittyInterface {
    function getKitty(uint _id) external view returns (
        bool isGestating,
        bool isReady,
        uint256 cooldownIndex,
        uint256 nextActionAt,
        uint256 siringWithId,
        uint256 birthTime,
        uint256 matronId,
        uint256 sireId,
        uint256 generation,
        uint256 genes
    );
}

contract ZombieFeeding is ZombieFactory {

    address public kittyAddress;
    modifier zombieOwner(uint _id){
        require(zombieToOwner[_id] == msg.sender);
        _;
    }

    function setCryptoKittyAddress(address _kittyAddress) external ownable {
        kittyAddress = _kittyAddress;
    }

    function feedAndMutiply(uint _id, uint _targetDna, string zombieType) internal zombieOwner(_id) {
        Zombie memory zombie = zombies[_id];
        uint newDna = uint((zombie.dna + _targetDna) / 2) % 1e16;

        if (keccak256(zombieType) == keccak256("kitty")){
            newDna = newDna - newDna % 1e2 + 99;
        }

        _createZombie("NoName", newDna);
    }

    function feedOnKitty(uint _id, uint _kittyId) public zombieOwner(_id) {
        require(kittyAddress != address(0), "need to initialize CryptoKittyInterface address");
        CryptoKittyInterface kittyInterface = CryptoKittyInterface(kittyAddress);
        uint kittyDna;
        (, , , , , , , , kittyDna) = kittyInterface.getKitty(_kittyId);
        feedAndMutiply(_id, kittyDna, "kitty");
    }

    function cooldown(uint _id) internal zombieOwner(_id){
        zombies[_id].readyTime = uint32(now + cooldownTime);
    }


}



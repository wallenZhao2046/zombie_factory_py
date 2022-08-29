pragma solidity ^0.4.10;
import "./Ownable.sol";

/**

    ZombieFactory 
    - generateRandomZombie: 没有地址可以创建一个randomDNA的 zombie
    - _createZombie: 创建 zombie 的内部方法:
        - 创建zombie 并 加入zombies storage
        - 维护 zombieToOwner
        - 维护 zombieCount
        - emit event
    语法点:
    struct 数据结构: 只有属性, 没有方法, 
        Zombie: 用于存储Zombie的各种属性数据
    array 数组: 相同类型的数据集合, 动态数组, 静态数组
        zombies Zombie的集合
    mapping 数据结构: key -> value 结构, 用于存储一对多的关联关系
        zombieToOwner: zombieId 与 owner的对应关系, 一个zombie只属于一个owner
        zombieCount: 每个owner的zombie数量, 用于快速得出owner拥有zombie的数量
    函数:
        签名格式: function 名字(参数 参数类型) 可见性 状态可变性 自定义限定条件 returns(返回值列表) {函数体}
        
        函数可见性: this 可以调用external函数
        modifier:
            函数可变性修饰符
                pure: function
                view: function
                payable: function
            状态变量可变性修饰符
                constant: state variable, 初始化后就不能改了, 不占storage slot
                immutable: state variable, 在构造时assign后就不能改了
            事件修饰符
                anonymous: event 
            事件参数修饰符
                indexed: event parameter
            继承关系
                virtual: function and modifier changes behaviour
                override: states that function, modifier or public state variable changes behaviour

        
    
*/
contract ZombieFactory is Ownable {
    struct Zombie{
        string name;
        uint dna;
        uint32 readyTime;
        uint16 level;
        uint32 winCount;
        uint32 lossCount;
    }

    event zombieCreated(string _name, uint dna);

    Zombie[] public zombies;
    uint32 cooldownTime = 1 days;
    mapping(uint => address) public zombieToOwner;
    mapping(address => uint) public zombieCount;

    function generateRandomZombie(string _name) public {
        require(zombieCount[msg.sender] == 0);
        uint dna = uint(keccak256(_name)) % 1e16;
        _createZombie(_name, dna);
    }

    function _createZombie(string _name, uint _dna) internal{
        uint length = zombies.push(Zombie(_name, _dna, uint32(now + cooldownTime), 1, 0, 0));
        uint index = length - 1;
        zombieToOwner[index] = msg.sender;
        zombieCount[msg.sender]++;
        zombieCreated(_name, _dna);
    }
}





pragma solidity ^0.4.10;
import "./ZombieHelper.sol";

contract ZombieAttack is ZombieHelper {

    uint winProbability = 70;
    uint round = 0;
    event attackWon(uint _id, uint _winCount);
    event attackLost(uint _id, uint _lossCount);

    function attack(uint _id, uint _targetId) public zombieOwner(_id) {
        Zombie storage attacker = zombies[_id];
        // require(attacker.readyTime <= now);
        round++;
        uint rand = uint(keccak256(now, msg.sender, round)) % 1e2;
        Zombie storage defender = zombies[_targetId];
        if (rand <= winProbability) {
            attacker.winCount++;
            attacker.level++;
            feedAndMutiply(_id, defender.dna, "zombie");
            emit attackWon(_id, attacker.winCount);
        }else{
            attacker.lossCount++;
            emit attackLost(_id, attacker.lossCount);
        }
        cooldown(_id);
    }

}

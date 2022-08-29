import brownie
import pytest
from brownie import ZombieAttack, accounts, chain
import allure


@allure.title("test attack contract")
@allure.description("attack: 70% probability to win for attacker")
def test_attack(deployer, guy, from_deployer, from_guy, attack):
    print(f'---------- {chain.height}')
    attack.generateRandomZombie('张三', from_deployer)
    attack.generateRandomZombie('李四', from_guy)

    attack.attack(0, 1, from_deployer)
    attacker = attack.zombies(0)
    defender = attack.zombies(1)

    if attacker['winCount'] > 0:
        assert attack.zombieCount(deployer.address) > 1
        assert attacker['level'] > 1
    else:
        assert attack.zombieCount(deployer.address) == 1
        assert attacker['lossCount'] > 0
        assert attacker['level'] == 0


    

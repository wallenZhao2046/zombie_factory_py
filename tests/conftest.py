from brownie import accounts, chain, ZombieAttack
import pytest

@pytest.fixture(scope='module')
def deployer():
    return accounts[0]

@pytest.fixture(scope='module')
def from_deployer(deployer):
    return {'from': deployer}

@pytest.fixture(scope='module')
def guy():
    return accounts[1]

@pytest.fixture(scope='module')
def from_guy(guy):
    return {'from': guy}
    

@pytest.fixture(autouse=True)
def setup_and_teardown_each_test():
    print('------- setup_and_teardown ----------')
    chain.snapshot()
    yield
    chain.revert()

@pytest.fixture(scope='module')
def attack(from_deployer):
    print('--------- deployed ZombieAttack --------')
    attack_contract = ZombieAttack.deploy(from_deployer)
    return attack_contract


def steal_eth(account, amount):
    weth = accounts.at('0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', force=True)
    weth.transfer(account, amount)
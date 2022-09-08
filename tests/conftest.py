from brownie import accounts, chain, ZombieAttack, PriceOracleDecentralize, OracleCaller
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

@pytest.fixture(scope='module')
def bob():
    return accounts[2]

@pytest.fixture(scope='module')
def owner():
    return accounts[3]

@pytest.fixture(scope='module')
def tom():
    return accounts[4]

@pytest.fixture(scope='module')
def cat():
    return accounts[5]

@pytest.fixture(scope='module')
def caller():
    return accounts[6]
    
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

@pytest.fixture(scope='module')
def priceOracle(from_deployer, owner):
    price_oracle = PriceOracleDecentralize.deploy(owner.address, from_deployer)
    return price_oracle

@pytest.fixture(scope='module')
def oracleCaller(from_deployer):
    oracleCaller = OracleCaller.deploy(from_deployer)
    return oracleCaller


def steal_eth(account, amount):
    weth = accounts.at('0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', force=True)
    weth.transfer(account, amount)
from brownie import NestedMapping, accounts
import pytest

print(len(accounts))

def test_nested_mapping(mapping, deployer, bob, guy, tom):
    
    print(f'---- {len(accounts)}')
    
    _verify_position(mapping, bob, deployer)
    _verify_position(mapping, guy, deployer)
    _verify_position(mapping, tom, deployer)

def _verify_position(mapping, account, deployer):
    import random
    reserver_value = random.randint(1000, 100000)
    price = random.randint(1000, 100000)
    amount = random.randint(1000, 100000)
    trx = mapping.set(account.address, True, 'btcusdt', reserver_value, price, amount, {'from': deployer})
    print(trx.events[0].name)
    print(trx.events[0]['key'])
    
    position = mapping.get(account.address, True, 'btcusdt')
    print(position)
    assert position['reserve'] == reserver_value
    assert position['enterPrice'] == price
    assert position['amount'] == amount

import brownie

def test_add_oracle(priceOracle, owner, bob, guy):

    oracles = [bob, guy]
    tx_list = _add_oracles(priceOracle, oracles, owner)
    for tx in tx_list:
        assert len(tx.events) == 1
        assert tx.events[0].name == 'AddOracle'

def test_add_oracle_by_no_owner(priceOracle, owner, bob, guy):

    oracles = [bob, guy]
    with brownie.reverts('only for owner'):
        tx_list = _add_oracles(priceOracle, oracles, bob)


def test_remove_oracle(priceOracle, owner, bob, guy):
    oracles = [bob, guy]
    _add_oracles(priceOracle, oracles, owner)
    tx = priceOracle.removeOracle(bob.address, {'from': owner})
    assert len(tx.events) == 1
    assert tx.events[0].name == 'RemoveOracle'

def test_remove_oracle_no_owner(priceOracle, owner, bob, guy):
    oracles = [bob, guy]
    _add_oracles(priceOracle, oracles, owner)
    with brownie.reverts("only for owner"):
        tx = priceOracle.removeOracle(bob.address, {'from': bob})

def test_remove_all_oracle(priceOracle, owner, bob, guy):
    oracles = [bob, guy]
    _add_oracles(priceOracle, oracles, owner)
    priceOracle.removeOracle(bob.address, {'from': owner})
    with brownie.reverts("at least one oracle"):
        priceOracle.removeOracle(guy.address, {'from': owner})

def test_remove_nonexistent_oracle(priceOracle, owner, bob, guy, tom):
    oracles = [bob, guy]
    _add_oracles(priceOracle, oracles, owner)
    non_oracle = tom
    
    with brownie.reverts("no this oracle"):
        priceOracle.removeOracle(non_oracle.address, {'from': owner})

def test_set_threshold(priceOracle, owner):
    priceOracle.setThreshold(5, {'from': owner})
    assert priceOracle.threshold() == 5


def test_get_price(priceOracle, oracleCaller, deployer, caller):
    
    id, tx = _caller_get_price(oracleCaller, priceOracle, deployer, caller)
    print(f'events length: {len(tx.events)}')
    assert len(tx.events) == 2
    assert tx.events[0].name == 'GetLatestEthPrice'
    assert tx.events[0]['id'] > 0
    assert tx.events[0]['caller'] == oracleCaller.address
    req_id = tx.events[0]['id']
    print(f'req id : {req_id}')

    assert tx.events[1].name == 'ReceivedNewRequestIdEvent'
    assert tx.events[1]['id'] == req_id
    


def test_set_price(priceOracle, oracleCaller, owner, deployer, caller, bob, guy, tom, cat):
    (id, tx) = _caller_get_price(oracleCaller, priceOracle, deployer, caller)
    print(id)
    _add_oracles(priceOracle, [bob, guy, tom, cat], owner)
    priceOracle.setThreshold(4, {'from': owner})

    prices = [1500, 1600, 1550, 1555]
    priceOracle.setLatestEthPrice(prices[0], oracleCaller.address, id, {'from': bob})
    priceOracle.setLatestEthPrice(prices[1], oracleCaller.address, id, {'from': guy})
    priceOracle.setLatestEthPrice(prices[2], oracleCaller.address, id, {'from': cat})

    tx = priceOracle.setLatestEthPrice(prices[3], oracleCaller.address, id, {'from': tom})

    assert tx.events[0].name == 'UpdateEthPrice'
    assert tx.events[1].name == 'SetLatestEthPrice'
    

    avg_price = 0
    for p in prices:
        avg_price += p
    avg_price = avg_price / len(prices)
    
    assert tx.events[0]['price'] == avg_price
    assert tx.events[1]['price'] == avg_price
    assert tx.events[1]['id'] == id
    assert tx.events[1]['caller'] == oracleCaller.address


def _add_oracles(priceOracle, oracles:list, owner):
    tx_list = []
    for oracle in oracles:
        tx = priceOracle.addOracle(oracle.address, {'from': owner})
        tx_list.append(tx)
    return tx_list

def _caller_get_price(oracleCaller, priceOracle, deployer, caller):
    oracleCaller.setOracleInstanceAddress(priceOracle.address, {'from': deployer})
    tx = oracleCaller.updateEthPrice({'from': caller})
    req_id = tx.events[0]['id']
    return req_id, tx

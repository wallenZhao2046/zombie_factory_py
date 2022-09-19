from brownie import NestedMapping

def test_nested_mapping(bob, guy):
    mapping = NestedMapping.deploy({'from': bob})
    
    mapping.set(guy.address, True, 'btcusdt', 1000, 15000, 200, {'from': bob})

    position = mapping.get(guy.address, True, 'btcusdt')
    print(position)
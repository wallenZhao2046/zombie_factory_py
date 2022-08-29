from brownie import accounts, ZombieFeeding

def main():
    ZombieFeeding.deploy({'from': accounts[0]})

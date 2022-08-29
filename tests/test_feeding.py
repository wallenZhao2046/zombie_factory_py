import brownie
from brownie import ZombieAttack, accounts, chain
import allure

@allure.title("for zombie feeding contract")
@allure.description("zombie feeding on random or kitty")
def test_random_feed(deployer, guy, from_deployer, from_guy, attack):
    #  = ZombieFeeding.deploy(tx_deployer)
    # attack = ZombieAttack.deploy(from_deployer)
    print(attack.address)
    print(f'---------- {chain.height}')

    attack.generateRandomZombie('zhangsan', from_deployer)

    with brownie.reverts():
        print('only one generateRandomZombie')
        attack.generateRandomZombie('lisi', from_deployer)

    zombie = attack.zombies(0)
    assert zombie['name'] == 'zhangsan'


def test_feed_on_kitty(deployer, guy, from_deployer, from_guy, attack):

    cryptoKittyAddr = '0x06012c8cf97BEaD5deAe237070F9587f8E7A266d'
    with brownie.reverts():
        attack.setCryptoKittyAddress(cryptoKittyAddr, from_guy)
    attack.setCryptoKittyAddress(cryptoKittyAddr, from_deployer)

    attack.feedOnKitty(0, 1, from_deployer)
    zombie_kitty = attack.zombies(1)
    assert zombie_kitty['name'] == 'NoName'

    zombie_kitty_dna = zombie_kitty['dna']
    print(f'zombie_kitty_dna: {zombie_kitty_dna}')
    assert int(zombie_kitty_dna % 1e2) == 99

    attack.feedOnKitty(0, 2, from_deployer)

    zombie_indexs = attack.getZombiesByOwner(deployer.address)
    print(f'zombies index array: {zombie_indexs}')
    assert len(zombie_indexs) == 3
    assert attack.zombies(zombie_indexs[1])['name'] == 'NoName'


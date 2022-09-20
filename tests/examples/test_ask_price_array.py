from brownie import interface


def test_add_ask(AskPriceArray, deployer, bob):
    askArray = AskPriceArray.deploy({'from': deployer})
    
    import random
    price_list = [random.randint(1, 10000) for i in range(10)]

    for price in price_list:
        trx = askArray.addAsk(price, {'from': deployer})
        print(f"index: {trx.events[0]['index']} => price: {trx.events[0]['price']}")
    
    result_list = [askArray.askPrices(i) for i in range(10)]

    price_list.sort()
    print(result_list)
    assert result_list == price_list

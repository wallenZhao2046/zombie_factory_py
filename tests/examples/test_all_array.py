from brownie import interface
import random
import pytest

def test_add_ask(AskPriceArray, deployer, bob):
    askArray = AskPriceArray.deploy({'from': deployer})
    
    price_list = [random.randint(1, 10000) for i in range(10)]

    for price in price_list:
        trx = askArray.addAsk(price, {'from': deployer})
        print(f"index: {trx.events[0]['index']} => price: {trx.events[0]['price']}")
    
    result_list = [askArray.askPrices(i) for i in range(10)]

    price_list.sort()
    print(result_list)
    assert result_list == price_list

@pytest.mark.parametrize('alist', [[], [10], [10, 20, 30], [1, 2, 3, 4, 5, 6], [random.randint(1, 10000) for i in range(10)]])
def test_dynamic_array(DynamicArray, deployer, bob, alist):
    darray = DynamicArray.deploy({'from':deployer})
    _verify_dync_array(alist, bob, darray)

def _verify_dync_array(init_list, account, darray):
    expect_list = []
    for item in init_list:
        darray.append(item, {'from': account})
        expect_list.append(item)
    
    for item in init_list:
        darray.insert(1, item, {'from': account})
        expect_list.insert(1, item)
    assert _get_array(darray) == expect_list

    for index in range(int(len(init_list) / 2), len(init_list)):
        darray.remove(index, {'from': account})
        del expect_list[index]
    assert _get_array(darray) == expect_list

    for item in init_list:
        darray.insert(_get_array_len(darray) - 1, item, {'from': account})
        expect_list.insert(len(expect_list) - 1, item)
    assert _get_array(darray) == expect_list

    for index in range(_get_array_len(darray) - 1, int(_get_array_len(darray) / 2), -1):
        darray.remove(index, {'from': account})
        del expect_list[index]
    assert _get_array(darray) == expect_list

    for item in init_list:
        darray.insert(0, item, {'from': account})
        expect_list.insert(0, item)
    assert _get_array(darray) == expect_list

    for index in range(0,  int(_get_array_len(darray) / 2), -1):
        darray.remove(index, {'from': account})
        del expect_list[index]
    assert _get_array(darray) == expect_list


def _get_array(darray):
    array_result = []
    for i in range(darray.arrayLength()):
        array_result.append(darray.array(i))
    print(array_result)
    return array_result

def _get_array_len(darray):
    return darray.arrayLength()
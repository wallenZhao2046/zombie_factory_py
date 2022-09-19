from brownie import NestedMapping
import pytest

@pytest.fixture(scope="module")
def mapping(deployer):
    _mapping = NestedMapping.deploy({'from': deployer})
    return _mapping


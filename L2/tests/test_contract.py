"""contract.cairo test file."""
import os

import pytest
from starkware.starknet.testing.starknet import Starknet

# The path to the contract source code.
CONTRACT_FILE = os.path.join("contracts", "contract.cairo")

OWNER = 0x07445Bd422e6B9C9cDF04E73a4Cf36Ea7C011A737795D13c9342593e789A6a33
L1_CONTRACT_ADDRESS = 0x0

@pytest.mark.asyncio
async def test_deploy():
    """Test increase_balance method."""
    starknet = await Starknet.empty()

    # Deploy the contract.
    deployed_contract = await starknet.deploy(
        source=CONTRACT_FILE,
        constructor_calldata=[OWNER, L1_CONTRACT_ADDRESS]
    )
    l1_contract = await deployed_contract.get_l1_contract().call()
    assert l1_contract.result.l1_address == 0

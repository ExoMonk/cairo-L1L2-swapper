import os
import asyncio
from starknet_py.net.gateway_client import GatewayClient
from starknet_py.contract import Contract
from starknet_py.net.networks import TESTNET
from dotenv import load_dotenv
load_dotenv()

CONTRACT_FILE = ['contracts/contract.cairo']

OWNER = 0x07445Bd422e6B9C9cDF04E73a4Cf36Ea7C011A737795D13c9342593e789A6a33
L1_CONTRACT_ADDRESS = int(os.environ.get('L1_CONTRACT'), 16)

async def deploy():
    client = GatewayClient(TESTNET)
    print("⏳ Deploying Contract...")
    contrat = await Contract.deploy(
        client=client,
        compilation_source=CONTRACT_FILE,
        constructor_args=[OWNER, L1_CONTRACT_ADDRESS]
    )
    print(f'✨ Contract deployed at {hex(contrat.deployed_contract.address)}')
    await contrat.wait_for_acceptance()
    print(f'✨ Contract deployment accepted on L2 !')
    return

if __name__ == '__main__':
    loop = asyncio.get_event_loop()
    loop.run_until_complete(deploy())
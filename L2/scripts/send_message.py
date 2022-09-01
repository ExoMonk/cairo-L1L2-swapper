import os
import json
import asyncio
from starknet_py.net.gateway_client import GatewayClient
from starknet_py.contract import Contract
from starknet_py.net.account.account_client import AccountClient
from starknet_py.net.networks import TESTNET
from starknet_py.net.signer.stark_curve_signer import KeyPair
from dotenv import load_dotenv
load_dotenv()

CONTRACT_FILE = ['contracts/contract.cairo']

OWNER = 0x07445Bd422e6B9C9cDF04E73a4Cf36Ea7C011A737795D13c9342593e789A6a33
L2_CONTRACT = int(os.environ.get('L2_CONTRACT'), 16)
L1_CALLER = int(os.environ.get('L1_CALLER'), 16)


with open('./artifacts/abis/contract.json', 'r') as f:
    ABI = json.load(f)

async def send_message():
    client = GatewayClient(TESTNET)
    print("⏳ Retrieving Deployed Contract from Account...")
    acc_client = AccountClient(OWNER, client, key_pair=KeyPair(
        int(os.environ.get('PRIVATE_KEY')),
        int(os.environ.get('PUBLIC_KEY'))
    ))
    contract = await Contract.from_address(client=acc_client, address=L2_CONTRACT)
    print("⏳ Sending Message to L1...")
    invocation = await contract.functions["swap_token_message"].invoke(
        l1_caller=L1_CALLER, token_from=0, token_to=1, amount=100, max_fee=int(1e16)
    )
    await invocation.wait_for_acceptance()
    print(f'✨ Message sent to relayer on L1 !')
    return

if __name__ == '__main__':
    loop = asyncio.get_event_loop()
    loop.run_until_complete(send_message())
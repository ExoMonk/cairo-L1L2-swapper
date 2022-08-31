const hre = require("hardhat");

async function main() {
    const [owner, otherAccount] = await hre.ethers.getSigners();
    console.log(owner.address)//0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
    const L1PoolSwapper = await hre.ethers.getContractFactory("L1PoolSwapper");
    const L1PoolSwapperContract = L1PoolSwapper.attach("0xcf7ed3acca5a467e9e704c703e8d87f634fb0fc9").connect(owner)

    let l2ContractAddress = await L1PoolSwapperContract.l2_contract()
    console.log(`✨ Initialized L2 Address : ${l2ContractAddress}`)
    console.log('⏳ Updating L2 Address..')
    const updateL2Address = await L1PoolSwapperContract.updateL2Contract("0x99999");
    await updateL2Address.wait()
    l2ContractAddress = await L1PoolSwapperContract.l2_contract()
    console.log(`✨ Initialized L2 Address : ${l2ContractAddress}`)
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
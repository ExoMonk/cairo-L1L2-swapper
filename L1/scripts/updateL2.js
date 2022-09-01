const hre = require("hardhat");

async function main() {
    const [owner, otherAccount] = await hre.ethers.getSigners();
    const L1PoolSwapper = await hre.ethers.getContractFactory("L1PoolSwapper");
    const L1PoolSwapperContract = L1PoolSwapper.attach(process.env.DEPLOYED_GOERLI_L1_CONTRACT_ADDRESS).connect(owner)

    let l2ContractAddress = await L1PoolSwapperContract.l2_contract()
    console.log(`✨ Initialized L2 Address : ${l2ContractAddress}`)
    console.log('⏳ Updating L2 Address..')
    const updateL2Address = await L1PoolSwapperContract.updateL2Contract(process.env.DEPLOYED_GOERLI_L2_CONTRACT_ADDRESS);
    await updateL2Address.wait()
    l2ContractAddress = await L1PoolSwapperContract.l2_contract()
    console.log(`✨ Initialized L2 Address : ${l2ContractAddress}`)
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
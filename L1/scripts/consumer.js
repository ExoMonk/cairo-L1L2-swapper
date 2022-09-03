const hre = require("hardhat");

async function main() {
    
    const [owner, otherAccount] = await hre.ethers.getSigners();
    const L1PoolSwapper = await hre.ethers.getContractFactory("L1PoolSwapper");
    const L1PoolSwapperContract = L1PoolSwapper.attach(process.env.DEPLOYED_GOERLI_L1_CONTRACT_ADDRESS).connect(owner)

    let ethUserBalance = await L1PoolSwapperContract.getBalance(0)
    let uniUserBalance = await L1PoolSwapperContract.getBalance(1)
    console.log(`✨ Current $UNI User Balance in Pool : ${uniUserBalance}`)
    console.log(`✨ Current $WETH User Balance in Pool : ${ethUserBalance}`)
    console.log(`⏳ Consuming L2 Message and automate Swap...`)
    const consumer = await L1PoolSwapperContract.messageConsumer(1, 0, 100)
    await consumer.wait()
    ethUserBalance = await L1PoolSwapperContract.getBalance(0)
    uniUserBalance = await L1PoolSwapperContract.getBalance(1)
    console.log(`✨ Current $UNI User Balance in Pool : ${uniUserBalance}`)
    console.log(`✨ Current $WETH User Balance in Pool : ${ethUserBalance}`)
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
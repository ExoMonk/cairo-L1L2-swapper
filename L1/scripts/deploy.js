const hre = require("hardhat");

async function main() {

  const L1PoolSwapper = await hre.ethers.getContractFactory("L1PoolSwapper");
  const pool_swapper = await L1PoolSwapper.deploy(unlockTime, { value: lockedAmount });

  await pool_swapper.deployed();

  console.log(
    `✨ Deployed L1PoolSwapper contract to ${pool_swapper.address}`
  );
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

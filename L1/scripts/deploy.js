const hre = require("hardhat");

async function main() {

  const [owner, otherAccount] = await hre.ethers.getSigners();
  console.log(owner.address)
  const l2ContractAddress = "0x0";
  const starknetCore = "0xde29d060D45901Fb19ED6C6e959EB22d8626708e";
  const uniswapRouter = "0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45";
  const usdcAddress = "0x07865c6e87b9f70255377e024ace6630c1eaa37f";
  const wethAddress = "0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6";
  const uniAddress = "0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984";


  const L1PoolSwapper = await hre.ethers.getContractFactory("L1PoolSwapper");
  const pool_swapper = await L1PoolSwapper.connect(owner).deploy(
    starknetCore, 
    uniswapRouter, 
    l2ContractAddress, 
    wethAddress,
    usdcAddress, 
    uniAddress
  )

  await pool_swapper.deployed();

  console.log(
    `✨ Deployed L1PoolSwapper contract to ${pool_swapper.address}`
  );
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

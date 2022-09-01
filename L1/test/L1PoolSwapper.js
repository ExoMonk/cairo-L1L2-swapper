const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

describe("L1PoolSwapper", function () {
  async function deployL1PoolSwapperFixture() {

    const [owner, otherAccount] = await ethers.getSigners();
    const L1PoolSwapper = await ethers.getContractFactory("L1PoolSwapper");
    const l2ContractAddress = "0x0";
    const starknetCore = "0xde29d060D45901Fb19ED6C6e959EB22d8626708e";
    const uniswapRouter = "0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45";
    const usdcAddress = "0x07865c6e87b9f70255377e024ace6630c1eaa37f";
    const wethAddress = "0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6";
    const uniAddress = "0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984";
    const pool_swapper = await L1PoolSwapper.connect(owner).deploy(
      starknetCore, 
      uniswapRouter, 
      l2ContractAddress, 
      wethAddress,
      usdcAddress, 
      uniAddress
    )

    return { pool_swapper, l2ContractAddress, owner, otherAccount };
  }

  describe("Deployment", function () {
    it("Should set the right contract address", async function () {
      const { pool_swapper, l2ContractAddress } = await loadFixture(deployL1PoolSwapperFixture);

      expect(await pool_swapper.l2_contract()).to.equal(l2ContractAddress);
    });

    it("Should set the right owner", async function () {
      const { pool_swapper, owner } = await loadFixture(deployL1PoolSwapperFixture);

      expect(await pool_swapper.owner()).to.equal(owner.address);
    });

    it("Should have no balance", async function () {
      const { pool_swapper } = await loadFixture(deployL1PoolSwapperFixture);
      expect(await ethers.provider.getBalance(pool_swapper.address)).to.equal(
        0
      );
    });
  });

  describe("Features", function () {
    it("Should have balance after deposit", async function () {
      const { pool_swapper, owner } = await loadFixture(deployL1PoolSwapperFixture);
      expect(await pool_swapper.connect(owner).getBalance(0)).to.equal(0);
      console.log("OK")
      await pool_swapper.connect(owner).deposit(0, 1, { value: ethers.utils.parseEther("0.5") })
      expect(await pool_swapper.connect(owner).getBalance(0)).to.equal(100);
    });
  });
});

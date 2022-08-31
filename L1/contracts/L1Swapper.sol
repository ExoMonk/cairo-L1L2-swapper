// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "./IStarknetCore.sol";
import '@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol';
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";

enum TokenType {
    WETH,
    DAI,
    USDC
}


contract L1Swapper is Ownable {

    ///////////////
    /// Storage ///
    ///////////////

    //Contracts
    IStarknetCore immutable public starknetCore;
    ISwapRouter immutable public swapRouter;
    address public l2_contract;

    //ERC20
    IERC20 immutable public usdc;
    IERC20 immutable public weth;

    event receivedAmount(address sender, uint amount);

    ///////////////////
    /// Constructor ///
    ///////////////////

    constructor(
        IStarknetCore starknetCore_,
        ISwapRouter swapRouter_,
        address l2_contract_,
        IERC20 usdc_, 
        IERC20 weth_
    ) payable {
        require(address(starknetCore_) != address(0));
        swapRouter = swapRouter_;
        starknetCore = starknetCore_;
        l2_contract = l2_contract_;

        usdc = usdc_;
        weth = weth_;
    }

    function updateL2Contract(address l2_new_contract_) public onlyOwner {
        l2_contract = l2_new_contract_;
    }


    function swap_token() public onlyOwner {

    }
}

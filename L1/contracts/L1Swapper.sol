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
    uint256 public l2_contract;

    //ERC20
    mapping (TokenType => IERC20) availableTokens;

    event receivedAmount(address sender, uint amount);
    event swappedToken(TokenType token_from, TokenType token_to, uint amount);

    ///////////////////
    /// Constructor ///
    ///////////////////

    constructor(
        IStarknetCore starknetCore_,
        ISwapRouter swapRouter_,
        uint256 l2_contract_,
        IERC20 weth_,
        IERC20 usdc_, 
        IERC20 dai_
    ) payable {
        require(address(starknetCore_) != address(0));
        swapRouter = swapRouter_;
        starknetCore = starknetCore_;
        l2_contract = l2_contract_;

        availableTokens[TokenType.WETH] = weth_;
        availableTokens[TokenType.USDC] = usdc_;
        availableTokens[TokenType.DAI] = dai_;
    }

    ////////////////////////
    /// Public Functions ///
    ////////////////////////

    function updateL2Contract(uint256 l2_new_contract_) public onlyOwner {
        l2_contract = l2_new_contract_;
    }

    function swap_token(TokenType token_from, TokenType token_to, uint amount) public onlyOwner {

        availableTokens[token_from].approve(address(swapRouter), amount+100000);

        //Use swapInterface


    }


    function messageConsumer(TokenType token_from, TokenType token_to, uint amount) public onlyOwner {

        uint256[] memory payload = new uint256[](3);
        payload[0] = uint256(token_from);
        payload[1] = uint256(token_to);
        payload[2] = amount;
        //Transaction is reverted if payload is false
        starknetCore.consumeMessageFromL2(l2_contract, payload);

        swap_token(token_from, token_to, amount);
        emit swappedToken(token_from, token_to, amount);
    }
}

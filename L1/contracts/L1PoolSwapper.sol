// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "./IStarknetCore.sol";
import '@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol';
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";


enum TokenType {
    WETH,
    UNI,
    USDC
}

struct DepositValue {
    uint weth_deposit;
    uint usdc_deposit;
    uint uni_deposit;
    bool hasValue;
}


contract L1PoolSwapper is Ownable {

    ///////////////
    /// Storage ///
    ///////////////

    //Contracts
    IStarknetCore immutable public starknetCore;
    ISwapRouter immutable public swapRouter;
    uint256 public l2_contract;

    //ERC20
    mapping (TokenType => IERC20) availableTokens;


    //Pool
    address[] public users;
    mapping(address => DepositValue) public deposits;


    event receivedAmount(address sender, TokenType token_type,  uint amount);
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
        IERC20 uni_
    ) payable {
        require(address(starknetCore_) != address(0));
        swapRouter = swapRouter_;
        starknetCore = starknetCore_;
        l2_contract = l2_contract_;

        availableTokens[TokenType.WETH] = weth_;
        availableTokens[TokenType.USDC] = usdc_;
        availableTokens[TokenType.UNI] = uni_;
    }

    ////////////////////////
    /// Public Functions ///
    ////////////////////////

    function updateL2Contract(uint256 l2_new_contract_) public onlyOwner {
        l2_contract = l2_new_contract_;
    }

    function messageConsumer(address sender, TokenType token_from, TokenType token_to, uint amount) public onlyOwner {
        uint256 senderAsUint256 = uint256(uint160(sender));
        uint256[] memory payload = new uint256[](4);
        payload[0] = senderAsUint256;
        payload[1] = uint256(token_from);
        payload[2] = uint256(token_to);
        payload[3] = amount;
        //Transaction is reverted if payload is false
        starknetCore.consumeMessageFromL2(l2_contract, payload);

        swap_token(token_from, token_to, amount);
        emit swappedToken(token_from, token_to, amount);
    }


    function deposit(TokenType token_type, uint amount) public payable {
        require(msg.value > 0, 'Deposit must be positive.');

        if(!deposits[msg.sender].hasValue){
            users.push(msg.sender);
            deposits[msg.sender].hasValue = true;
        }

        availableTokens[token_type].transferFrom(msg.sender, address(this), amount);
        if (token_type == TokenType.WETH){
            deposits[msg.sender].weth_deposit += msg.value;
        } else if (token_type == TokenType.USDC){
            deposits[msg.sender].usdc_deposit += msg.value;
        } else if (token_type == TokenType.UNI){
            deposits[msg.sender].uni_deposit += msg.value;
        }
        emit receivedAmount(msg.sender, token_type, amount);
    }

    function withdraw(TokenType token_type, uint amount) public payable {
        
        //Checking user has enough tokens
        if (token_type == TokenType.WETH){
            require(deposits[msg.sender].weth_deposit >= amount);
        } else if (token_type == TokenType.USDC){
            require(deposits[msg.sender].usdc_deposit >= amount);
        } else if (token_type == TokenType.UNI){
            require(deposits[msg.sender].uni_deposit >= amount);
        }
        availableTokens[token_type].transfer(msg.sender, amount);
    }

    function swap_token(TokenType token_from, TokenType token_to, uint amount) public {

        //Check that user has enough balance to swap
        if (token_from == TokenType.WETH){
            require(deposits[msg.sender].weth_deposit >= amount);
        } else if (token_from == TokenType.USDC){
            require(deposits[msg.sender].usdc_deposit >= amount);
        } else if (token_from == TokenType.UNI){
            require(deposits[msg.sender].uni_deposit >= amount);
        }

        availableTokens[token_from].approve(address(swapRouter), amount);

        ISwapRouter.ExactInputSingleParams memory parameters =
            ISwapRouter.ExactInputSingleParams({
                tokenIn: address(availableTokens[token_from]),
                tokenOut: address(availableTokens[token_to]),
                fee: 2500,
                recipient: address(this),
                deadline: (block.timestamp + 60*500),
                amountIn: amount,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
        });

        if (token_from == TokenType.WETH){
            deposits[msg.sender].weth_deposit -= amount;
        } else if (token_from == TokenType.USDC){
            deposits[msg.sender].usdc_deposit -= amount;
        } else if (token_from == TokenType.UNI){
            deposits[msg.sender].uni_deposit -= amount;
        }

        if (token_to == TokenType.WETH){
            deposits[msg.sender].weth_deposit += swapRouter.exactInputSingle(parameters);
        } else if (token_to == TokenType.USDC){
            deposits[msg.sender].usdc_deposit += swapRouter.exactInputSingle(parameters);
        } else if (token_to == TokenType.UNI){
            deposits[msg.sender].uni_deposit += swapRouter.exactInputSingle(parameters);
        }
    }

}

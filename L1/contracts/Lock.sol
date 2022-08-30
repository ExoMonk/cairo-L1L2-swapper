// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.14;

// Import this file to use console.log
import "./IStarknetCore.sol";
import "hardhat/console.sol";

contract Lock {

    ///////////////
    /// Storage ///
    ///////////////

    IStarknetCore immutable public starknetCore;
    address payable public owner;

    event Withdrawal(uint amount, uint when);

    constructor(
        IStarknetCore starknetCore_
    ) payable {
        
        require(address(starknetCore_) != address(0));
        starknetCore = starknetCore_;
        owner = payable(msg.sender);
    }

    function withdraw() public {

        require(msg.sender == owner, "You aren't the owner");

        emit Withdrawal(address(this).balance, block.timestamp);

        owner.transfer(address(this).balance);
    }
}

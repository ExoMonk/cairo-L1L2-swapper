# cairo-L1L2-interactions

Sample Contracts to handle transactions on L1 from StarkNet L2
Contracts on L2 can interact asynchronously with contracts on L1 via the L2 -> L1 messaging protocol.

How this works ?


1. The StarkNet(L2) contract calls the syscall starknet function `send_message_to_l1()`
    - The destination L1 contract to send message
    - the payload size
    - The payload data to send

2. The L1 contract specified by the to address invokes the `consumeMessageFromL2()` of the StarkNet core contract.
Since any L2 contract can send message to any L1 contract, it's highly recommended that the L1 contract check the from address.

![l2l1](./docs/img/l2l1.png)

## Project Configuration

Since we will handle both L1 contracts and L2 contracts, the projeect setup needs to be done seperatly in 2 different environment : 

1. L1 - Solidity Contracts

Go to L1 repository and check README.md

```
cd L1
```

1. L2 - Cairo Contracts

Go to L2 repository and check README.md

```
cd L2
```
# L1 Locking contract

Setup : 

```shell
npm install

npx hardhat help
npx hardhat test
GAS_REPORT=true npx hardhat test
npx hardhat node --network localhost
```

## Handling Contract

- Deployment

```
npx hardhat run scripts/deploy.js --network localhost
```

- Deposit

```
npx hardhat run scripts/deposit.js --network localhost
```

- Update StarkNet Layer 2 Address

```
npx hardhat run scripts/updateL2.js --network localhost
```

- Consume L2 Message

```
npx hardhat run scripts/consumer.js --network localhost
```
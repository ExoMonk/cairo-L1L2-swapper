
# L2 Cairo Contracts

# Installation & Setup

```
python -m venv cairo-venv
source cairo-venv/bin/activate

sudo apt install -y libgmp3-dev
(or for M1 macbook)
CFLAGS=-I`brew --prefix gmp`/include LDFLAGS=-L`brew --prefix gmp`/lib pip install ecdsa fastecdsa sympy
pip install --upgrade pip
pip install cairo-lang
pip install cairo-nile 
pip install openzeppelin-cairo-contracts
pip install immutablex-starknet

nile init
yarn install


cd ../
cd L1
```

# Compiling Contracts

- Compiling Contracts

```
nile compile contracts/contract.cairo
🔨 Compiling contracts/contract.cairo 
✅ Done
```


# Deploying Contracts

```
python scripts/deploy.py
```

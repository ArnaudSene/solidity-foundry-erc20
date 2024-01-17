# ERC20 token smart contract

## About

This code is to create a token based on ERC20.

- [OpenZeppelin ERC20](https://github.com/OpenZeppelin/openzeppelin-contracts/tree/master/contracts/token/ERC20)

## How it works?

1. Deploy the contract with an initial supply
2. Use all function defined in ERC20 as
   1. totalSupply
   2. balanceOf
   3. transfer
   4. transferFrom
   5. allowance
   6. approve

## Usage

> Required
> Rename `sample-env` by `.env` and replace with the approrpiate values

### Test 
```shell
make help
```
```
Usage:
  make deploy [ARGS=...]
    example: make deploy ARGS="--network sepolia"

  make fund [ARGS=...]
    example: make deploy ARGS="--network sepolia"
```



### Deploy
local chain (Anvil)
```shell
make deploy
```
Sepolia testnet
```shell
make deploy ARGS="--network sepolia"
```

### Install dependencies
```shell
make install
```

### Build
```shell
make build
```

### Test
```shell
make test
```
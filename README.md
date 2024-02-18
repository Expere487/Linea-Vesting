# Linea Vesting - Linear Vesting Module / Contract

Linea Vesting is a linear vesting module for Sui. It allows for the creation of linear vesting schedules for a set of coins. The module is designed to be used by the Sui governance to distribute tokens to team members, investors, and other stakeholders over a period of time.

## Features

- Create linear vesting schedules for a set of coins
- Schedule vesting for a set of coins
- Release coins from a vesting schedule
- Get the current vesting schedule for a set of coins

## How to Publish

This guide assumes you have a private key, already have faucet coins in testnet or devnet.

To build:

```bash
sui move build
```

To publish:

```bash
sui client publish --gas-budget 100000000 --json
```

## How to Interact

You can use Linea Vesting with the Linear Vesting module using Sui CLI and Sui Explorer/Suivision/Suiscan.

- To create a new linear vesting wallet:

```bash
sui client call --package $PACKAGE_ID --module linear_vesting --function new --type-args $COIN_TYPE --args $COIN_ID "0x6" $START_DATE $DURATION $RECEIVER --gas-budget 1000000000 --json
```

- To claim coins from a linear vesting wallet:

```bash
sui client call --package $PACKAGE_ID --module linear_vesting --function entry_claim --type-args $COIN_TYPE --args $WALLET_ID "0x6" --gas-budget 1000000000 --json
```

- To check total amount left in the linear vesting wallet:

```bash
sui client call --package $PACKAGE_ID --module linear_vesting --function balance --type-args $COIN_TYPE --args $WALLET_ID --gas-budget 1000000000 --json
```

- To check total amount released from the linear vesting wallet:

```bash
sui client call --package $PACKAGE_ID --module linear_vesting --function released --type-args $COIN_TYPE --args $WALLET_ID --gas-budget 1000000000 --json
```

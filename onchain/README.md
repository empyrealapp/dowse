## Onchain Utilities

This repository contains utilities for working with the onchain aspects of the dowse agent management.

The agent manages a registry of supported chains, with the deployment address of their deposit contracts.
These funds get accumulated on each Depositor contract, and tracked in the deposit contract on Sapphire.

A user has a deposit address for each chain that represents their account.

For example, they can setup an account with the agent, using their twitter.  It will then generate a deposit address for each chain:

- ethereum
- solana
- move

The user can then deposit to any of the deposit contracts, which will be credited to the user's account on sapphire.

### Setup

This is a hybrid setup that uses both Foundry and Hardhat.

The `src` directory contains the smart contracts for the dowse agent management.
The `ignition` directory contains the Hardhat project for deploying the smart contracts.
The `hardhat.config.ts` file contains the configuration for the Hardhat project.
The `foundry.toml` file contains the configuration for the Foundry project.
The `package.json` file contains the dependencies for the project.

This is because foundry is better for testing most contracts, but hardhat is necessary for sapphire deployments.

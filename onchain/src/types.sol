// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

enum TargetNetworkType {
    EVM,
    SOLANA,
    MOVE  // sui/aptos/etc.
}

type UserId is uint256;
type TokenAddress is address;
type AssetId is bytes32;

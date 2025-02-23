// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {UserId, TokenAddress, AssetId} from "../types.sol";

interface IEscrow {
    function submitDeposit(UserId user, uint256 chainId, TokenAddress tokenAddress, uint256 amount, uint256 depositIndex) external;
    function updateUserBalance(UserId user, AssetId assetId, int256 amount) external;
}

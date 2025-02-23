// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {UserId, TokenAddress, AssetId} from "../types.sol";

interface IDepositor {
    function deposit(UserId userAddress) external payable;
    function deposit(UserId userAddress, TokenAddress tokenAddress, uint256 amount) external payable;
}

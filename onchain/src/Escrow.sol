// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IEscrow} from "./interfaces/IEscrow.sol";
import {UserId, TokenAddress, AssetId} from "./types.sol";

contract Escrow is IEscrow {
    /*
     * A user is assigned a User ID, and is given deposit addresses across multiple chains.
     * When a deposit is made, the deposit is tracked by a deposit idnex on that chain on
     * the Depositor contract.
     *
     * Then the deposit is normalized across an asset class for the user.
     */

    address public owner;
    /// standardize an asset across multiple chains
    mapping(uint256 chainId => mapping(TokenAddress => AssetId)) public assets;
    /// track user balance for an asset class
    mapping(UserId => mapping(AssetId => uint256 balance)) internal _balances;
    /// track if a deposit index has been used for a chain
    mapping(uint256 chainId => mapping(uint256 depositIndex => bool)) private _depositIndexUsed;

    constructor(address _owner) {
        owner = _owner;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function hasUsedDepositIndex(uint256 chainId, uint256 depositIndex) external view returns (bool) {
        return _depositIndexUsed[chainId][depositIndex];
    }

    function setAsset(AssetId asset, uint256[] memory chainIds, TokenAddress[] memory tokenAddresses) external {
        // standardize an asset across multiple chains
        for (uint256 i = 0; i < chainIds.length; i++) {
            assets[chainIds[i]][tokenAddresses[i]] = asset;
        }
    }

    function submitDeposit(UserId user, uint256 chainId, TokenAddress tokenAddress, uint256 amount, uint256 depositIndex) external onlyOwner {
        AssetId assetId = assets[chainId][tokenAddress];
        require(AssetId.unwrap(assetId) != bytes32(0), "Asset not found");
        _balances[user][assetId] += amount;
        _depositIndexUsed[chainId][depositIndex] = true;
    }

    function updateUserBalance(UserId user, AssetId assetId, int256 amount) external onlyOwner {
        if (amount > 0) {
            _balances[user][assetId] += uint256(amount);
        } else {
            _balances[user][assetId] -= uint256(-amount);
        }
    }
}

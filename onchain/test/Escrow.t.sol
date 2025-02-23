// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Escrow} from "../src/Escrow.sol";
import {UserId, TokenAddress, AssetId} from "../src/types.sol";

contract PublicEscrow is Escrow {
    function getBalance(UserId user, AssetId assetId) external view returns (uint256) {
        return _balances[user][assetId];
    }

    constructor(address _owner) Escrow(_owner) {}
}

contract EscrowTest is Test {
    PublicEscrow public escrow;
    address public owner = address(1);

    AssetId asset = AssetId.wrap(bytes32("asset"));
    TokenAddress tokenAddress = TokenAddress.wrap(address(0x123));

    function setUp() public {
        escrow = new PublicEscrow(owner);
    }

    function test_SetAsset() public {
        uint256[] memory chainIds = new uint256[](1);
        chainIds[0] = 1;
        TokenAddress[] memory tokenAddresses = new TokenAddress[](1);
        tokenAddresses[0] = tokenAddress;

        vm.prank(owner);
        escrow.setAsset(asset, chainIds, tokenAddresses);

        assertEq(AssetId.unwrap(escrow.assets(1, tokenAddress)), bytes32("asset"));
    }

    function test_SubmitDeposit() public {
        test_SetAsset();
        UserId user = UserId.wrap(1);
        uint256 chainId = 1;
        uint256 amount = 100;
        uint256 depositIndex = 1;

        vm.prank(owner);
        escrow.submitDeposit(user, chainId, tokenAddress, amount, depositIndex);

        assertEq(escrow.getBalance(user, asset), amount);
        assertTrue(escrow.hasUsedDepositIndex(chainId, depositIndex));
    }
}

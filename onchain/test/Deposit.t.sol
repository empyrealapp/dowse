// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Depositor} from "../src/Depositor.sol";
import {UserId, TokenAddress} from "../src/types.sol";
import {IERC20} from "../src/interfaces/IERC20.sol";

contract DepositorTest is Test {
    Depositor public depositor;
    address public owner = address(1);
    address public user = address(2);
    TokenAddress public tokenAddress = TokenAddress.wrap(address(0x123));
    UserId public userId = UserId.wrap(1);

    function setUp() public {
        depositor = new Depositor(owner);
        vm.prank(owner);
        depositor.updateTokenApproval(tokenAddress, true);
    }

    function test_DepositGasToken() public {
        uint256 depositAmount = 1 ether;

        vm.deal(user, depositAmount);

        // Check the deposit event
        vm.expectEmit(true, true, true, true);
        emit Depositor.Deposit(1, userId, TokenAddress.wrap(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE), depositAmount);

        vm.prank(user);
        depositor.deposit{value: depositAmount}(userId);
    }

    function test_DepositERC20Token() public {
        uint256 depositAmount = 100;
        IERC20 token = IERC20(TokenAddress.unwrap(tokenAddress));

        // Mock the transferFrom function
        vm.mockCall(
            address(token),
            abi.encodeWithSelector(token.transferFrom.selector, user, address(depositor), depositAmount),
            abi.encode(true)
        );

        // Check the deposit event
        vm.expectEmit(true, true, true, true);
        emit Depositor.Deposit(1, userId, tokenAddress, depositAmount);

        vm.prank(user);
        depositor.deposit(userId, tokenAddress, depositAmount);

    }
}

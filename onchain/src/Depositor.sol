// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IERC20} from "./interfaces/IERC20.sol";
import {IDepositor} from "./interfaces/IDepositor.sol";
import {UserId, TokenAddress} from "./types.sol";

contract Depositor is IDepositor {
    address public owner;

    uint256 public depositIndex;

    mapping(TokenAddress => bool) public isTokenAllowed;
    TokenAddress constant GAS_TOKEN = TokenAddress.wrap(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
    event Deposit(uint256 indexed index, UserId indexed accountId, TokenAddress tokenAddress, uint256 amount);

    constructor(address _owner) {
        owner = _owner;
        isTokenAllowed[GAS_TOKEN] = true;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function updateTokenApproval(TokenAddress tokenAddress, bool isAllowed) external onlyOwner {
        isTokenAllowed[tokenAddress] = isAllowed;
    }

    function deposit(UserId userAddress) external payable {
        /// we don't check balance because the user's balance can change frequently.
        /// we just want to track the deposit via onchain events.

        _checkTokenAddress(GAS_TOKEN);
        depositIndex++;

        emit Deposit(depositIndex, userAddress, GAS_TOKEN, msg.value);
    }

    function deposit(UserId userAddress, TokenAddress tokenAddress, uint256 amount) external payable {
        /// we can limit what tokens we support users depositing
        _checkTokenAddress(tokenAddress);
        IERC20(TokenAddress.unwrap(tokenAddress)).transferFrom(msg.sender, address(this), amount);
        depositIndex++;

        emit Deposit(depositIndex, userAddress, tokenAddress, amount);
    }

    function _checkTokenAddress(TokenAddress tokenAddress) internal view {
        require(isTokenAllowed[tokenAddress], "Token not allowed");
    }

    function withdrawToAddress(address recipient, TokenAddress token, uint256 amount) external onlyOwner {
        // The agent can withdraw to any account

        if (TokenAddress.unwrap(token) == TokenAddress.unwrap(GAS_TOKEN)) {
            payable(recipient).transfer(amount);
        } else {
            IERC20(TokenAddress.unwrap(token)).transfer(recipient, amount);
        }
    }

    function call(address[] calldata targets, bytes[] calldata data) external onlyOwner returns (bytes[] memory results) {
        /// owner can call any contract with arbitrary data
        /// This can be used to bridge funds between chains, swap funds between assets, etc.

        for (uint256 i = 0; i < targets.length; i++) {
            (bool success, bytes memory result) = targets[i].call(data[i]);
            require(success, "Call failed");
            results[i] = result;
        }
    }
}

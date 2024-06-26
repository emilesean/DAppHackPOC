// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

interface ICointroller {

    event ActionPaused(string action, bool pauseState);
    event ActionPaused(address rToken, string action, bool pauseState);
    event ContributorRifiSpeedUpdated(address indexed contributor, uint256 newSpeed);
    event DistributedBorrowerRifi(
        address indexed rToken, address indexed borrower, uint256 rifiDelta, uint256 rifiBorrowIndex
    );
    event DistributedSupplierRifi(
        address indexed rToken, address indexed supplier, uint256 rifiDelta, uint256 rifiSupplyIndex
    );
    event Failure(uint256 error, uint256 info, uint256 detail);
    event MarketEntered(address rToken, address account);
    event MarketExited(address rToken, address account);
    event MarketListed(address rToken);
    event NewBorrowCap(address indexed rToken, uint256 newBorrowCap);
    event NewBorrowCapGuardian(address oldBorrowCapGuardian, address newBorrowCapGuardian);
    event NewCloseFactor(uint256 oldCloseFactorMantissa, uint256 newCloseFactorMantissa);
    event NewCollateralFactor(address rToken, uint256 oldCollateralFactorMantissa, uint256 newCollateralFactorMantissa);
    event NewLiquidationIncentive(uint256 oldLiquidationIncentiveMantissa, uint256 newLiquidationIncentiveMantissa);
    event NewPauseGuardian(address oldPauseGuardian, address newPauseGuardian);
    event NewPriceOracle(address oldPriceOracle, address newPriceOracle);
    event RifiGranted(address recipient, uint256 amount);
    event RifiSpeedUpdated(address indexed rToken, uint256 newSpeed);

    function _become(address unitroller) external;

    function _borrowGuardianPaused() external view returns (bool);

    function _grantRifi(address recipient, uint256 amount) external;

    function _mintGuardianPaused() external view returns (bool);

    function _setBorrowCapGuardian(address newBorrowCapGuardian) external;

    function _setBorrowPaused(address rToken, bool state) external returns (bool);

    function _setCloseFactor(uint256 newCloseFactorMantissa) external returns (uint256);

    function _setCollateralFactor(address rToken, uint256 newCollateralFactorMantissa) external returns (uint256);

    function _setContributorRifiSpeed(address contributor, uint256 rifiSpeed) external;

    function _setLiquidationIncentive(uint256 newLiquidationIncentiveMantissa) external returns (uint256);

    function _setMarketBorrowCaps(address[] memory rTokens, uint256[] memory newBorrowCaps) external;

    function _setMintPaused(address rToken, bool state) external returns (bool);

    function _setPauseGuardian(address newPauseGuardian) external returns (uint256);

    function _setPriceOracle(address newOracle) external returns (uint256);

    function _setRifiSpeed(address rToken, uint256 rifiSpeed) external;

    function _setSeizePaused(bool state) external returns (bool);

    function _setTransferPaused(bool state) external returns (bool);

    function _supportMarket(address rToken) external returns (uint256);

    function accountAssets(address, uint256) external view returns (address);

    function admin() external view returns (address);

    function allMarkets(uint256) external view returns (address);

    function borrowAllowed(address rToken, address borrower, uint256 borrowAmount) external returns (uint256);

    function borrowCapGuardian() external view returns (address);

    function borrowCaps(address) external view returns (uint256);

    function borrowGuardianPaused(address) external view returns (bool);

    function borrowVerify(address rToken, address borrower, uint256 borrowAmount) external;

    function checkMembership(address account, address rToken) external view returns (bool);

    function claimRifi(address[] memory holders, address[] memory rTokens, bool borrowers, bool suppliers) external;

    function claimRifi(address holder, address[] memory rTokens) external;

    function claimRifi(address holder) external;

    function closeFactorMantissa() external view returns (uint256);

    function cointrollerImplementation() external view returns (address);

    function enterMarkets(address[] memory rTokens) external returns (uint256[] memory);

    function exitMarket(address rTokenAddress) external returns (uint256);

    function getAccountLiquidity(address account) external view returns (uint256, uint256, uint256);

    function getAllMarkets() external view returns (address[] memory);

    function getAssetsIn(address account) external view returns (address[] memory);

    function getBlockNumber() external view returns (uint256);

    function getHypotheticalAccountLiquidity(
        address account,
        address rTokenModify,
        uint256 redeemTokens,
        uint256 borrowAmount
    ) external view returns (uint256, uint256, uint256);

    function getRifiAddress() external view returns (address);

    function initialize(address rifi) external;

    function isCointroller() external view returns (bool);

    function lastContributorBlock(address) external view returns (uint256);

    function liquidateBorrowAllowed(
        address rTokenBorrowed,
        address rTokenCollateral,
        address liquidator,
        address borrower,
        uint256 repayAmount
    ) external returns (uint256);

    function liquidateBorrowVerify(
        address rTokenBorrowed,
        address rTokenCollateral,
        address liquidator,
        address borrower,
        uint256 actualRepayAmount,
        uint256 seizeTokens
    ) external;

    function liquidateCalculateSeizeTokens(address rTokenBorrowed, address rTokenCollateral, uint256 actualRepayAmount)
        external
        view
        returns (uint256);

    function liquidationIncentiveMantissa() external view returns (uint256);

    function markets(address) external view returns (bool isListed, uint256 collateralFactorMantissa, bool isRified);

    function maxAssets() external view returns (uint256);

    function mintAllowed(address rToken, address minter, uint256 mintAmount) external returns (uint256);

    function mintGuardianPaused(address) external view returns (bool);

    function mintVerify(address rToken, address minter, uint256 actualMintAmount, uint256 mintTokens) external;

    function oracle() external view returns (address);

    function pauseGuardian() external view returns (address);

    function pendingAdmin() external view returns (address);

    function pendingCointrollerImplementation() external view returns (address);

    function redeemAllowed(address rToken, address redeemer, uint256 redeemTokens) external returns (uint256);

    function redeemVerify(address rToken, address redeemer, uint256 redeemAmount, uint256 redeemTokens) external;

    function repayBorrowAllowed(address rToken, address payer, address borrower, uint256 repayAmount)
        external
        returns (uint256);

    function repayBorrowVerify(
        address rToken,
        address payer,
        address borrower,
        uint256 actualRepayAmount,
        uint256 borrowerIndex
    ) external;

    function rifiAccrued(address) external view returns (uint256);

    function rifiBorrowState(address) external view returns (uint224 index, uint32 block);

    function rifiBorrowerIndex(address, address) external view returns (uint256);

    function rifiContributorSpeeds(address) external view returns (uint256);

    function rifiInitialIndex() external view returns (uint224);

    function rifiRate() external view returns (uint256);

    function rifiSpeeds(address) external view returns (uint256);

    function rifiSupplierIndex(address, address) external view returns (uint256);

    function rifiSupplyState(address) external view returns (uint224 index, uint32 block);

    function seizeAllowed(
        address rTokenCollateral,
        address rTokenBorrowed,
        address liquidator,
        address borrower,
        uint256 seizeTokens
    ) external returns (uint256);

    function seizeGuardianPaused() external view returns (bool);

    function seizeVerify(
        address rTokenCollateral,
        address rTokenBorrowed,
        address liquidator,
        address borrower,
        uint256 seizeTokens
    ) external;

    function transferAllowed(address rToken, address src, address dst, uint256 transferTokens)
        external
        returns (uint256);

    function transferGuardianPaused() external view returns (bool);

    function transferVerify(address rToken, address src, address dst, uint256 transferTokens) external;

    function updateContributorRewards(address contributor) external;

}

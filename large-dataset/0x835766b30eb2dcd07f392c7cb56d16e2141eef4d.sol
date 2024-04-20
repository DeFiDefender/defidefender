// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;


// 
interface IERC20 {

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);



    // non-standard

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

}

// 
interface IOracle {

    // Each oracle should have a set function. The first parameter will be 'address pair' and any parameters can come after.

    // Setting should only be allowed ONCE for each pair.



    // Get the latest exchange rate, if no valid (recent) rate is available, return false

    function get(address pair) external returns (bool, uint256);



    // Check the last exchange rate without any state changes

    function peek(address pair) external view returns (uint256);

}

// 
interface IVault {

    event FlashLoan(address indexed user, address indexed token, uint256 amount, uint256 fee);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    event PairContractSet(address indexed pairContract, bool enabled);

    event PairCreated(

        address indexed pairContract, IERC20 indexed tokenCollateral, IERC20 indexed tokenAsset, address oracle, address clone_address);

    event SwapperSet(address swapper, bool enabled);

    function dev() external view returns (address);

    function feeTo() external view returns (address);

    function feesPending(address) external view returns (uint256);

    function isPair(address) external view returns (bool);

    function owner() external view returns (address);

    function pairContracts(address) external view returns (bool);

    function renounceOwnership() external;

    function swappers(address) external view returns (bool);

    function transferOwnership(address newOwner) external;

    function setPairContract(address pairContract, bool enabled) external;

    function setSwapper(address swapper, bool enabled) external;

    function setFeeTo(address newFeeTo) external;

    function setDev(address newDev) external;

    function deploy(address pairContract, IERC20 tokenCollateral, IERC20 tokenAsset, address oracle, bytes calldata oracleData) external;

    function transfer(IERC20 token, address to, uint256 amount) external;

    function transferFrom(IERC20 token, address from, uint256 amount) external;

    function flashLoan(address user, address token, uint256 amount, bytes calldata params) external;

    function withdrawFees(address token) external;

}

// 
interface IPair {

    event AddAsset(address indexed user, uint256 amount, uint256 share);

    event AddBorrow(address indexed user, uint256 amount, uint256 share);

    event AddCollateral(address indexed user, uint256 amount, uint256 share);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    event NewExchangeRate(uint256 rate);

    event RemoveAsset(address indexed user, uint256 amount, uint256 share);

    event RemoveBorrow(address indexed user, uint256 amount, uint256 share);

    event RemoveCollateral(address indexed user, uint256 amount, uint256 share);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    function approve(address spender, uint256 amount) external returns (bool success);

    function balanceOf(address) external view returns (uint256);

    function colRate() external view returns (uint256);

    function decimals() external view returns (uint8);

    function exchangeRate() external view returns (uint256);

    function feesPending() external view returns (uint256);

    function interestPerBlock() external view returns (uint256);

    function lastBlockAccrued() external view returns (uint256);

    function lastInterestBlock() external view returns (uint256);

    function liqMultiplier() external view returns (uint256);

    function name() external view returns (string memory);

    function openColRate() external view returns (uint256);

    function oracle() external view returns (IOracle);

    function symbol() external view returns (string memory);

    function tokenAsset() external view returns (IERC20);

    function tokenCollateral() external view returns (IERC20);

    function totalAsset() external view returns (uint256);

    function totalBorrow() external view returns (uint256);

    function totalBorrowShare() external view returns (uint256);

    function totalCollateral() external view returns (uint256);

    function totalCollateralShare() external view returns (uint256);

    function totalSupply() external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool success);

    function transferFrom(address from, address to, uint256 amount) external returns (bool success);

    function userBorrowShare(address) external view returns (uint256);

    function userCollateralShare(address) external view returns (uint256);

    function vault() external view returns (IVault);

    function init(IVault vault_, IERC20 collateral_address, IERC20 asset_address, IOracle oracle_address, bytes calldata oracleData) external;

    function accrue() external;

    function withdrawFees() external;

    function isSolvent(address user, bool open) external view returns (bool);

    function updateExchangeRate() external returns (uint256);

    function updateInterestRate() external;

    function addCollateral(uint256 amount) external;

    function addAsset(uint256 amount) external;

    function removeCollateral(uint256 share, address to) external;

    function removeAsset(uint256 share, address to) external;

    function borrow(uint256 amount, address to) external;

    function repay(uint256 share) external;

    function short(address swapper, uint256 amountAsset, uint256 minAmountCollateral) external;

    function unwind(address swapper, uint256 borrowShare, uint256 maxAmountCollateral) external;

    function liquidate(address[] calldata users, uint256[] calldata borrowShares, address to, address swapper, bool open) external;

}

// 
contract BentoHelper {

    struct PairInfo {

        IPair pair;

        IOracle oracle;

        IVault vault;

        IERC20 tokenAsset;

        IERC20 tokenCollateral;



        uint256 latestExchangeRate;

        uint256 lastBlockAccrued;

        uint256 interestRate;

        uint256 totalCollateral;

        uint256 totalAsset;

        uint256 totalBorrow;



        uint256 totalCollateralShare;

        uint256 totalAssetShare;

        uint256 totalBorrowShare;



        uint256 interestPerBlock;

        uint256 lastInterestBlock;



        uint256 colRate;

        uint256 openColRate;

        uint256 liqMultiplier;

        uint256 feesPending;



        uint256 userCollateralShare;

        uint256 userAssetShare;

        uint256 userBorrowShare;



        uint256 userAssetBalance;

        uint256 userCollateralBalance;

        uint256 userAssetAllowance;

        uint256 userCollateralAllowance;

    }



    function getPairs(address user, IPair[] calldata pairs) public view returns (PairInfo[] memory info) {

        info = new PairInfo[](pairs.length);

        for(uint256 i = 0; i < pairs.length; i++) {

            IPair pair = pairs[i];

            info[i].pair = pair;

            info[i].oracle = pair.oracle();

            info[i].vault = pair.vault();

            info[i].tokenAsset = pair.tokenAsset();

            info[i].tokenCollateral = pair.tokenCollateral();



            info[i].latestExchangeRate = info[i].oracle.peek(address(pair));

            info[i].lastBlockAccrued = pair.lastBlockAccrued();

            info[i].totalCollateral = pair.totalCollateral();

            info[i].totalAsset = pair.totalAsset();

            info[i].totalBorrow = pair.totalBorrow();



            info[i].totalCollateralShare = pair.totalCollateralShare();

            info[i].totalAssetShare = pair.totalSupply();

            info[i].totalBorrowShare = pair.totalBorrowShare();



            info[i].interestPerBlock = pair.interestPerBlock();

            info[i].lastInterestBlock = pair.lastInterestBlock();



            info[i].colRate = pair.colRate();

            info[i].openColRate = pair.openColRate();

            info[i].liqMultiplier = pair.liqMultiplier();

            info[i].feesPending = pair.feesPending();



            info[i].userCollateralShare = pair.userCollateralShare(user);

            info[i].userAssetShare = pair.balanceOf(user);

            info[i].userBorrowShare = pair.userBorrowShare(user);



            info[i].userAssetBalance = info[i].tokenAsset.balanceOf(user);

            info[i].userCollateralBalance = info[i].tokenCollateral.balanceOf(user);

            info[i].userAssetAllowance = info[i].tokenAsset.allowance(user, address(info[i].vault));

            info[i].userCollateralAllowance = info[i].tokenCollateral.allowance(user, address(info[i].vault));

        }

    }

}

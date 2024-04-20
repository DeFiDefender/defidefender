// File: @openzeppelin\\contracts  oken\\ERC20\\IERC20.sol



pragma solidity ^0.6.0;



/**

 * @dev Interface of the ERC20 standard as defined in the EIP.

 */

interface IERC20 {

    /**

     * @dev Returns the amount of tokens in existence.

     */

    function totalSupply() external view returns (uint256);



    /**

     * @dev Returns the amount of tokens owned by `account`.

     */

    function balanceOf(address account) external view returns (uint256);



    /**

     * @dev Moves `amount` tokens from the caller's account to `recipient`.

     *

     * Returns a boolean value indicating whether the operation succeeded.

     *

     * Emits a {Transfer} event.

     */

    function transfer(address recipient, uint256 amount) external returns (bool);



    /**

     * @dev Returns the remaining number of tokens that `spender` will be

     * allowed to spend on behalf of `owner` through {transferFrom}. This is

     * zero by default.

     *

     * This value changes when {approve} or {transferFrom} are called.

     */

    function allowance(address owner, address spender) external view returns (uint256);



    /**

     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.

     *

     * Returns a boolean value indicating whether the operation succeeded.

     *

     * IMPORTANT: Beware that changing an allowance with this method brings the risk

     * that someone may use both the old and the new allowance by unfortunate

     * transaction ordering. One possible solution to mitigate this race

     * condition is to first reduce the spender's allowance to 0 and set the

     * desired value afterwards:

     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729

     *

     * Emits an {Approval} event.

     */

    function approve(address spender, uint256 amount) external returns (bool);



    /**

     * @dev Moves `amount` tokens from `sender` to `recipient` using the

     * allowance mechanism. `amount` is then deducted from the caller's

     * allowance.

     *

     * Returns a boolean value indicating whether the operation succeeded.

     *

     * Emits a {Transfer} event.

     */

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);



    /**

     * @dev Emitted when `value` tokens are moved from one account (`from`) to

     * another (`to`).

     *

     * Note that `value` may be zero.

     */

    event Transfer(address indexed from, address indexed to, uint256 value);



    /**

     * @dev Emitted when the allowance of a `spender` for an `owner` is set by

     * a call to {approve}. `value` is the new allowance.

     */

    event Approval(address indexed owner, address indexed spender, uint256 value);

}



// File: @openzeppelin\\contracts\\math\\SafeMath.sol



pragma solidity ^0.6.0;



/**

 * @dev Wrappers over Solidity's arithmetic operations with added overflow

 * checks.

 *

 * Arithmetic operations in Solidity wrap on overflow. This can easily result

 * in bugs, because programmers usually assume that an overflow raises an

 * error, which is the standard behavior in high level programming languages.

 * `SafeMath` restores this intuition by reverting the transaction when an

 * operation overflows.

 *

 * Using this library instead of the unchecked operations eliminates an entire

 * class of bugs, so it's recommended to use it always.

 */

library SafeMath {

    /**

     * @dev Returns the addition of two unsigned integers, reverting on

     * overflow.

     *

     * Counterpart to Solidity's `+` operator.

     *

     * Requirements:

     *

     * - Addition cannot overflow.

     */

    function add(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a + b;

        require(c >= a, "SafeMath: addition overflow");



        return c;

    }



    /**

     * @dev Returns the subtraction of two unsigned integers, reverting on

     * overflow (when the result is negative).

     *

     * Counterpart to Solidity's `-` operator.

     *

     * Requirements:

     *

     * - Subtraction cannot overflow.

     */

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {

        return sub(a, b, "SafeMath: subtraction overflow");

    }



    /**

     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on

     * overflow (when the result is negative).

     *

     * Counterpart to Solidity's `-` operator.

     *

     * Requirements:

     *

     * - Subtraction cannot overflow.

     */

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b <= a, errorMessage);

        uint256 c = a - b;



        return c;

    }



    /**

     * @dev Returns the multiplication of two unsigned integers, reverting on

     * overflow.

     *

     * Counterpart to Solidity's `*` operator.

     *

     * Requirements:

     *

     * - Multiplication cannot overflow.

     */

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {

        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the

        // benefit is lost if 'b' is also tested.

        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522

        if (a == 0) {

            return 0;

        }



        uint256 c = a * b;

        require(c / a == b, "SafeMath: multiplication overflow");



        return c;

    }



    /**

     * @dev Returns the integer division of two unsigned integers. Reverts on

     * division by zero. The result is rounded towards zero.

     *

     * Counterpart to Solidity's `/` operator. Note: this function uses a

     * `revert` opcode (which leaves remaining gas untouched) while Solidity

     * uses an invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     *

     * - The divisor cannot be zero.

     */

    function div(uint256 a, uint256 b) internal pure returns (uint256) {

        return div(a, b, "SafeMath: division by zero");

    }



    /**

     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on

     * division by zero. The result is rounded towards zero.

     *

     * Counterpart to Solidity's `/` operator. Note: this function uses a

     * `revert` opcode (which leaves remaining gas untouched) while Solidity

     * uses an invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     *

     * - The divisor cannot be zero.

     */

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b > 0, errorMessage);

        uint256 c = a / b;

        // assert(a == b * c + a % b); // There is no case in which this doesn't hold



        return c;

    }



    /**

     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),

     * Reverts when dividing by zero.

     *

     * Counterpart to Solidity's `%` operator. This function uses a `revert`

     * opcode (which leaves remaining gas untouched) while Solidity uses an

     * invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     *

     * - The divisor cannot be zero.

     */

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {

        return mod(a, b, "SafeMath: modulo by zero");

    }



    /**

     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),

     * Reverts with custom message when dividing by zero.

     *

     * Counterpart to Solidity's `%` operator. This function uses a `revert`

     * opcode (which leaves remaining gas untouched) while Solidity uses an

     * invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     *

     * - The divisor cannot be zero.

     */

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b != 0, errorMessage);

        return a % b;

    }

}



// File: contracts\\strategies\\Interfaces\\Compound\\CTokenI.sol



pragma solidity >=0.5.0;



interface CTokenI{



    /*** Market Events ***/



    /**

     * @notice Event emitted when interest is accrued

     */

    event AccrueInterest(uint cashPrior, uint interestAccumulated, uint borrowIndex, uint totalBorrows);



    /**

     * @notice Event emitted when tokens are minted

     */

    event Mint(address minter, uint mintAmount, uint mintTokens);



    /**

     * @notice Event emitted when tokens are redeemed

     */

    event Redeem(address redeemer, uint redeemAmount, uint redeemTokens);



    /**

     * @notice Event emitted when underlying is borrowed

     */

    event Borrow(address borrower, uint borrowAmount, uint accountBorrows, uint totalBorrows);



    /**

     * @notice Event emitted when a borrow is repaid

     */

    event RepayBorrow(address payer, address borrower, uint repayAmount, uint accountBorrows, uint totalBorrows);



    /**

     * @notice Event emitted when a borrow is liquidated

     */

    event LiquidateBorrow(address liquidator, address borrower, uint repayAmount, address cTokenCollateral, uint seizeTokens);





    /*** Admin Events ***/



    /**

     * @notice Event emitted when pendingAdmin is changed

     */

    event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);



    /**

     * @notice Event emitted when pendingAdmin is accepted, which means admin is updated

     */

    event NewAdmin(address oldAdmin, address newAdmin);



    /**

     * @notice Event emitted when the reserve factor is changed

     */

    event NewReserveFactor(uint oldReserveFactorMantissa, uint newReserveFactorMantissa);



    /**

     * @notice Event emitted when the reserves are added

     */

    event ReservesAdded(address benefactor, uint addAmount, uint newTotalReserves);



    /**

     * @notice Event emitted when the reserves are reduced

     */

    event ReservesReduced(address admin, uint reduceAmount, uint newTotalReserves);



    /**

     * @notice EIP20 Transfer event

     */

    event Transfer(address indexed from, address indexed to, uint amount);



    /**

     * @notice EIP20 Approval event

     */

    event Approval(address indexed owner, address indexed spender, uint amount);



    /**

     * @notice Failure event

     */

    event Failure(uint error, uint info, uint detail);



    function transfer(address dst, uint amount) external returns (bool);

    function transferFrom(address src, address dst, uint amount) external returns (bool);

    function approve(address spender, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function balanceOf(address owner) external view returns (uint);

    function balanceOfUnderlying(address owner) external returns (uint);

    function getAccountSnapshot(address account) external view returns (uint, uint, uint, uint);

    function borrowRatePerBlock() external view returns (uint);

    function supplyRatePerBlock() external view returns (uint);

    function totalBorrowsCurrent() external returns (uint);

    function borrowBalanceCurrent(address account) external returns (uint);

    function borrowBalanceStored(address account) external view returns (uint);

    function exchangeRateCurrent() external returns (uint);

    function accrualBlockNumber() external view returns (uint);

    function exchangeRateStored() external view returns (uint);

    function getCash() external view returns (uint);

    function accrueInterest() external returns (uint);

    function seize(address liquidator, address borrower, uint seizeTokens) external returns (uint);



    function totalBorrows() external view returns (uint);

    function totalSupply() external view returns (uint);



}



// File: contracts\\strategies\\Interfaces\\Compound\\CErc20I.sol



pragma solidity >=0.5.0;





interface CErc20I is CTokenI{

    function mint(uint mintAmount) external returns (uint);

    function redeem(uint redeemTokens) external returns (uint);

    function redeemUnderlying(uint redeemAmount) external returns (uint);

    function borrow(uint borrowAmount) external returns (uint);

    function repayBorrow(uint repayAmount) external returns (uint);

    function repayBorrowBehalf(address borrower, uint repayAmount) external returns (uint);

    function liquidateBorrow(address borrower, uint repayAmount, CTokenI cTokenCollateral) external returns (uint);



    function underlying() external returns (address);

}



// File: contracts\\strategies\\Interfaces\\Compound\\ComptrollerI.sol



pragma solidity >=0.5.0;

pragma experimental ABIEncoderV2;





interface ComptrollerI {



    function enterMarkets(address[] calldata cTokens) external returns (uint[] memory);

    function exitMarket(address cToken) external returns (uint);



    /*** Policy Hooks ***/



    function mintAllowed(address cToken, address minter, uint mintAmount) external returns (uint);

    function mintVerify(address cToken, address minter, uint mintAmount, uint mintTokens) external;



    function redeemAllowed(address cToken, address redeemer, uint redeemTokens) external returns (uint);

    function redeemVerify(address cToken, address redeemer, uint redeemAmount, uint redeemTokens) external;



    function borrowAllowed(address cToken, address borrower, uint borrowAmount) external returns (uint);

    function borrowVerify(address cToken, address borrower, uint borrowAmount) external;



    function repayBorrowAllowed(

        address cToken,

        address payer,

        address borrower,

        uint repayAmount) external returns (uint);

    function repayBorrowVerify(

        address cToken,

        address payer,

        address borrower,

        uint repayAmount,

        uint borrowerIndex) external;



    function liquidateBorrowAllowed(

        address cTokenBorrowed,

        address cTokenCollateral,

        address liquidator,

        address borrower,

        uint repayAmount) external returns (uint);

    function liquidateBorrowVerify(

        address cTokenBorrowed,

        address cTokenCollateral,

        address liquidator,

        address borrower,

        uint repayAmount,

        uint seizeTokens) external;



    function seizeAllowed(

        address cTokenCollateral,

        address cTokenBorrowed,

        address liquidator,

        address borrower,

        uint seizeTokens) external returns (uint);

    function seizeVerify(

        address cTokenCollateral,

        address cTokenBorrowed,

        address liquidator,

        address borrower,

        uint seizeTokens) external;



    function transferAllowed(address cToken, address src, address dst, uint transferTokens) external returns (uint);

    function transferVerify(address cToken, address src, address dst, uint transferTokens) external;



    /*** Liquidity/Liquidation Calculations ***/



    function liquidateCalculateSeizeTokens(

        address cTokenBorrowed,

        address cTokenCollateral,

        uint repayAmount) external view returns (uint, uint);



    function getAccountLiquidity(address account) external view returns (uint, uint, uint);





    /***  Comp claims ****/

    function claimComp(address holder) external;

    function claimComp(address holder, CTokenI[] memory cTokens) external;

    function markets(address ctoken) external view returns (bool, uint, bool);



    

    function compSpeeds(address ctoken) external view returns (uint);



    



}



// File: contracts\\strategies\\Interfaces\\UniswapInterfaces\\IUniswapV2Router01.sol



pragma solidity >=0.6.2;



interface IUniswapV2Router01 {

    function factory() external pure returns (address);

    function WETH() external pure returns (address);



    function addLiquidity(

        address tokenA,

        address tokenB,

        uint amountADesired,

        uint amountBDesired,

        uint amountAMin,

        uint amountBMin,

        address to,

        uint deadline

    ) external returns (uint amountA, uint amountB, uint liquidity);

    function addLiquidityETH(

        address token,

        uint amountTokenDesired,

        uint amountTokenMin,

        uint amountETHMin,

        address to,

        uint deadline

    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);

    function removeLiquidity(

        address tokenA,

        address tokenB,

        uint liquidity,

        uint amountAMin,

        uint amountBMin,

        address to,

        uint deadline

    ) external returns (uint amountA, uint amountB);

    function removeLiquidityETH(

        address token,

        uint liquidity,

        uint amountTokenMin,

        uint amountETHMin,

        address to,

        uint deadline

    ) external returns (uint amountToken, uint amountETH);

    function removeLiquidityWithPermit(

        address tokenA,

        address tokenB,

        uint liquidity,

        uint amountAMin,

        uint amountBMin,

        address to,

        uint deadline,

        bool approveMax, uint8 v, bytes32 r, bytes32 s

    ) external returns (uint amountA, uint amountB);

    function removeLiquidityETHWithPermit(

        address token,

        uint liquidity,

        uint amountTokenMin,

        uint amountETHMin,

        address to,

        uint deadline,

        bool approveMax, uint8 v, bytes32 r, bytes32 s

    ) external returns (uint amountToken, uint amountETH);

    function swapExactTokensForTokens(

        uint amountIn,

        uint amountOutMin,

        address[] calldata path,

        address to,

        uint deadline

    ) external returns (uint[] memory amounts);

    function swapTokensForExactTokens(

        uint amountOut,

        uint amountInMax,

        address[] calldata path,

        address to,

        uint deadline

    ) external returns (uint[] memory amounts);

    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)

        external

        payable

        returns (uint[] memory amounts);

    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)

        external

        returns (uint[] memory amounts);

    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)

        external

        returns (uint[] memory amounts);

    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)

        external

        payable

        returns (uint[] memory amounts);



    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);

    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);

    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);

    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);

    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);

}



// File: contracts\\strategies\\Interfaces\\UniswapInterfaces\\IUniswapV2Router02.sol



pragma solidity >=0.6.2;





interface IUniswapV2Router02 is IUniswapV2Router01 {

    function removeLiquidityETHSupportingFeeOnTransferTokens(

        address token,

        uint liquidity,

        uint amountTokenMin,

        uint amountETHMin,

        address to,

        uint deadline

    ) external returns (uint amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(

        address token,

        uint liquidity,

        uint amountTokenMin,

        uint amountETHMin,

        address to,

        uint deadline,

        bool approveMax, uint8 v, bytes32 r, bytes32 s

    ) external returns (uint amountETH);



    function swapExactTokensForTokensSupportingFeeOnTransferTokens(

        uint amountIn,

        uint amountOutMin,

        address[] calldata path,

        address to,

        uint deadline

    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(

        uint amountOutMin,

        address[] calldata path,

        address to,

        uint deadline

    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(

        uint amountIn,

        uint amountOutMin,

        address[] calldata path,

        address to,

        uint deadline

    ) external;

}



// File: contracts\\strategies\\Interfaces\\Yearn\\IController.sol



pragma solidity ^0.6.9;



interface IController {

    function withdraw(address, uint256) external;



    function balanceOf(address) external view returns (uint256);



    function earn(address, uint256) external;



    function want(address) external view returns (address);



    function rewards() external view returns (address);



    function vaults(address) external view returns (address);



    function approveStrategy(address, address) external;



    function setStrategy(address, address) external;



    function strategies(address) external view returns (address);

}



// File: contracts\\strategies\\Interfaces\\DyDx\\ISoloMargin.sol



pragma solidity >=0.5.7;





library Account {

    enum Status {Normal, Liquid, Vapor}

    struct Info {

        address owner; // The address that owns the account

        uint256 number; // A nonce that allows a single address to control many accounts

    }

    struct Storage {

        mapping(uint256 => Types.Par) balances; // Mapping from marketId to principal

        Status status;

    }

}





library Actions {

    enum ActionType {

        Deposit, // supply tokens

        Withdraw, // borrow tokens

        Transfer, // transfer balance between accounts

        Buy, // buy an amount of some token (publicly)

        Sell, // sell an amount of some token (publicly)

        Trade, // trade tokens against another account

        Liquidate, // liquidate an undercollateralized or expiring account

        Vaporize, // use excess tokens to zero-out a completely negative account

        Call // send arbitrary data to an address

    }



    enum AccountLayout {OnePrimary, TwoPrimary, PrimaryAndSecondary}



    enum MarketLayout {ZeroMarkets, OneMarket, TwoMarkets}



    struct ActionArgs {

        ActionType actionType;

        uint256 accountId;

        Types.AssetAmount amount;

        uint256 primaryMarketId;

        uint256 secondaryMarketId;

        address otherAddress;

        uint256 otherAccountId;

        bytes data;

    }



    struct DepositArgs {

        Types.AssetAmount amount;

        Account.Info account;

        uint256 market;

        address from;

    }



    struct WithdrawArgs {

        Types.AssetAmount amount;

        Account.Info account;

        uint256 market;

        address to;

    }



    struct TransferArgs {

        Types.AssetAmount amount;

        Account.Info accountOne;

        Account.Info accountTwo;

        uint256 market;

    }



    struct BuyArgs {

        Types.AssetAmount amount;

        Account.Info account;

        uint256 makerMarket;

        uint256 takerMarket;

        address exchangeWrapper;

        bytes orderData;

    }



    struct SellArgs {

        Types.AssetAmount amount;

        Account.Info account;

        uint256 takerMarket;

        uint256 makerMarket;

        address exchangeWrapper;

        bytes orderData;

    }



    struct TradeArgs {

        Types.AssetAmount amount;

        Account.Info takerAccount;

        Account.Info makerAccount;

        uint256 inputMarket;

        uint256 outputMarket;

        address autoTrader;

        bytes tradeData;

    }



    struct LiquidateArgs {

        Types.AssetAmount amount;

        Account.Info solidAccount;

        Account.Info liquidAccount;

        uint256 owedMarket;

        uint256 heldMarket;

    }



    struct VaporizeArgs {

        Types.AssetAmount amount;

        Account.Info solidAccount;

        Account.Info vaporAccount;

        uint256 owedMarket;

        uint256 heldMarket;

    }



    struct CallArgs {

        Account.Info account;

        address callee;

        bytes data;

    }

}





library Decimal {

    struct D256 {

        uint256 value;

    }

}





library Interest {

    struct Rate {

        uint256 value;

    }



    struct Index {

        uint96 borrow;

        uint96 supply;

        uint32 lastUpdate;

    }

}





library Monetary {

    struct Price {

        uint256 value;

    }

    struct Value {

        uint256 value;

    }

}





library Storage {

    // All information necessary for tracking a market

    struct Market {

        // Contract address of the associated ERC20 token

        address token;

        // Total aggregated supply and borrow amount of the entire market

        Types.TotalPar totalPar;

        // Interest index of the market

        Interest.Index index;

        // Contract address of the price oracle for this market

        address priceOracle;

        // Contract address of the interest setter for this market

        address interestSetter;

        // Multiplier on the marginRatio for this market

        Decimal.D256 marginPremium;

        // Multiplier on the liquidationSpread for this market

        Decimal.D256 spreadPremium;

        // Whether additional borrows are allowed for this market

        bool isClosing;

    }



    // The global risk parameters that govern the health and security of the system

    struct RiskParams {

        // Required ratio of over-collateralization

        Decimal.D256 marginRatio;

        // Percentage penalty incurred by liquidated accounts

        Decimal.D256 liquidationSpread;

        // Percentage of the borrower's interest fee that gets passed to the suppliers

        Decimal.D256 earningsRate;

        // The minimum absolute borrow value of an account

        // There must be sufficient incentivize to liquidate undercollateralized accounts

        Monetary.Value minBorrowedValue;

    }



    // The maximum RiskParam values that can be set

    struct RiskLimits {

        uint64 marginRatioMax;

        uint64 liquidationSpreadMax;

        uint64 earningsRateMax;

        uint64 marginPremiumMax;

        uint64 spreadPremiumMax;

        uint128 minBorrowedValueMax;

    }



    // The entire storage state of Solo

    struct State {

        // number of markets

        uint256 numMarkets;

        // marketId => Market

        mapping(uint256 => Market) markets;

        // owner => account number => Account

        mapping(address => mapping(uint256 => Account.Storage)) accounts;

        // Addresses that can control other users accounts

        mapping(address => mapping(address => bool)) operators;

        // Addresses that can control all users accounts

        mapping(address => bool) globalOperators;

        // mutable risk parameters of the system

        RiskParams riskParams;

        // immutable risk limits of the system

        RiskLimits riskLimits;

    }

}





library Types {

    enum AssetDenomination {

        Wei, // the amount is denominated in wei

        Par // the amount is denominated in par

    }



    enum AssetReference {

        Delta, // the amount is given as a delta from the current value

        Target // the amount is given as an exact number to end up at

    }



    struct AssetAmount {

        bool sign; // true if positive

        AssetDenomination denomination;

        AssetReference ref;

        uint256 value;

    }



    struct TotalPar {

        uint128 borrow;

        uint128 supply;

    }



    struct Par {

        bool sign; // true if positive

        uint128 value;

    }



    struct Wei {

        bool sign; // true if positive

        uint256 value;

    }

}





interface ISoloMargin {

    struct OperatorArg {

        address operator1;

        bool trusted;

    }



    function ownerSetSpreadPremium(

        uint256 marketId,

        Decimal.D256 memory spreadPremium

    ) external;



    function getIsGlobalOperator(address operator1) external view returns (bool);



    function getMarketTokenAddress(uint256 marketId)

        external

        view

        returns (address);



    function ownerSetInterestSetter(uint256 marketId, address interestSetter)

        external;



    function getAccountValues(Account.Info memory account)

        external

        view

        returns (Monetary.Value memory, Monetary.Value memory);



    function getMarketPriceOracle(uint256 marketId)

        external

        view

        returns (address);



    function getMarketInterestSetter(uint256 marketId)

        external

        view

        returns (address);



    function getMarketSpreadPremium(uint256 marketId)

        external

        view

        returns (Decimal.D256 memory);



    function getNumMarkets() external view returns (uint256);



    function ownerWithdrawUnsupportedTokens(address token, address recipient)

        external

        returns (uint256);



    function ownerSetMinBorrowedValue(Monetary.Value memory minBorrowedValue)

        external;



    function ownerSetLiquidationSpread(Decimal.D256 memory spread) external;



    function ownerSetEarningsRate(Decimal.D256 memory earningsRate) external;



    function getIsLocalOperator(address owner, address operator1)

        external

        view

        returns (bool);



    function getAccountPar(Account.Info memory account, uint256 marketId)

        external

        view

        returns (Types.Par memory);



    function ownerSetMarginPremium(

        uint256 marketId,

        Decimal.D256 memory marginPremium

    ) external;



    function getMarginRatio() external view returns (Decimal.D256 memory);



    function getMarketCurrentIndex(uint256 marketId)

        external

        view

        returns (Interest.Index memory);



    function getMarketIsClosing(uint256 marketId) external view returns (bool);



    function getRiskParams() external view returns (Storage.RiskParams memory);



    function getAccountBalances(Account.Info memory account)

        external

        view

        returns (address[] memory, Types.Par[] memory, Types.Wei[] memory);



    function renounceOwnership() external;



    function getMinBorrowedValue() external view returns (Monetary.Value memory);



    function setOperators(OperatorArg[] memory args) external;



    function getMarketPrice(uint256 marketId) external view returns (address);



    function owner() external view returns (address);



    function isOwner() external view returns (bool);



    function ownerWithdrawExcessTokens(uint256 marketId, address recipient)

        external

        returns (uint256);



    function ownerAddMarket(

        address token,

        address priceOracle,

        address interestSetter,

        Decimal.D256 memory marginPremium,

        Decimal.D256 memory spreadPremium

    ) external;



    function operate(

        Account.Info[] memory accounts,

        Actions.ActionArgs[] memory actions

    ) external;



    function getMarketWithInfo(uint256 marketId)

        external

        view

        returns (

            Storage.Market memory,

            Interest.Index memory,

            Monetary.Price memory,

            Interest.Rate memory

        );



    function ownerSetMarginRatio(Decimal.D256 memory ratio) external;



    function getLiquidationSpread() external view returns (Decimal.D256 memory);



    function getAccountWei(Account.Info memory account, uint256 marketId)

        external

        view

        returns (Types.Wei memory);



    function getMarketTotalPar(uint256 marketId)

        external

        view

        returns (Types.TotalPar memory);



    function getLiquidationSpreadForPair(

        uint256 heldMarketId,

        uint256 owedMarketId

    ) external view returns (Decimal.D256 memory);



    function getNumExcessTokens(uint256 marketId)

        external

        view

        returns (Types.Wei memory);



    function getMarketCachedIndex(uint256 marketId)

        external

        view

        returns (Interest.Index memory);



    function getAccountStatus(Account.Info memory account)

        external

        view

        returns (uint8);



    function getEarningsRate() external view returns (Decimal.D256 memory);



    function ownerSetPriceOracle(uint256 marketId, address priceOracle) external;



    function getRiskLimits() external view returns (Storage.RiskLimits memory);



    function getMarket(uint256 marketId)

        external

        view

        returns (Storage.Market memory);



    function ownerSetIsClosing(uint256 marketId, bool isClosing) external;



    function ownerSetGlobalOperator(address operator1, bool approved) external;



    function transferOwnership(address newOwner) external;



    function getAdjustedAccountValues(Account.Info memory account)

        external

        view

        returns (Monetary.Value memory, Monetary.Value memory);



    function getMarketMarginPremium(uint256 marketId)

        external

        view

        returns (Decimal.D256 memory);



    function getMarketInterestRate(uint256 marketId)

        external

        view

        returns (Interest.Rate memory);

}



// File: contracts\\strategies\\Interfaces\\DyDx\\DydxFlashLoanBase.sol



pragma solidity >=0.5.7;







contract DydxFlashloanBase {

    using SafeMath for uint256;



    // -- Internal Helper functions -- //



    function _getMarketIdFromTokenAddress(address _solo, address token)

        internal

        view

        returns (uint256)

    {

        ISoloMargin solo = ISoloMargin(_solo);



        uint256 numMarkets = solo.getNumMarkets();



        address curToken;

        for (uint256 i = 0; i < numMarkets; i++) {

            curToken = solo.getMarketTokenAddress(i);



            if (curToken == token) {

                return i;

            }

        }



        revert("No marketId found for provided token");

    }



    function _getRepaymentAmountInternal(uint256 amount)

        internal

        view

        returns (uint256)

    {

        // Needs to be overcollateralize

        // Needs to provide +2 wei to be safe

        return amount.add(2);

    }



    function _getAccountInfo() internal view returns (Account.Info memory) {

        return Account.Info({owner: address(this), number: 1});

    }



    function _getWithdrawAction(uint marketId, uint256 amount)

        internal

        view

        returns (Actions.ActionArgs memory)

    {

        return

            Actions.ActionArgs({

                actionType: Actions.ActionType.Withdraw,

                accountId: 0,

                amount: Types.AssetAmount({

                    sign: false,

                    denomination: Types.AssetDenomination.Wei,

                    ref: Types.AssetReference.Delta,

                    value: amount

                }),

                primaryMarketId: marketId,

                secondaryMarketId: 0,

                otherAddress: address(this),

                otherAccountId: 0,

                data: ""

            });

    }



    function _getCallAction(bytes memory data)

        internal

        view

        returns (Actions.ActionArgs memory)

    {

        return

            Actions.ActionArgs({

                actionType: Actions.ActionType.Call,

                accountId: 0,

                amount: Types.AssetAmount({

                    sign: false,

                    denomination: Types.AssetDenomination.Wei,

                    ref: Types.AssetReference.Delta,

                    value: 0

                }),

                primaryMarketId: 0,

                secondaryMarketId: 0,

                otherAddress: address(this),

                otherAccountId: 0,

                data: data

            });

    }



    function _getDepositAction(uint marketId, uint256 amount)

        internal

        view

        returns (Actions.ActionArgs memory)

    {

        return

            Actions.ActionArgs({

                actionType: Actions.ActionType.Deposit,

                accountId: 0,

                amount: Types.AssetAmount({

                    sign: true,

                    denomination: Types.AssetDenomination.Wei,

                    ref: Types.AssetReference.Delta,

                    value: amount

                }),

                primaryMarketId: marketId,

                secondaryMarketId: 0,

                otherAddress: address(this),

                otherAccountId: 0,

                data: ""

            });

    }

}



// File: contracts\\strategies\\Interfaces\\DyDx\\ICallee.sol



pragma solidity >=0.5.7;







/**

 * @title ICallee

 * @author dYdX

 *

 * Interface that Callees for Solo must implement in order to ingest data.

 */

interface ICallee {



    // ============ Public Functions ============



    /**

     * Allows users to send this contract arbitrary data.

     *

     * @param  sender       The msg.sender to Solo

     * @param  accountInfo  The account from which the data is being sent

     * @param  data         Arbitrary data given by the sender

     */

    function callFunction(

        address sender,

        Account.Info memory accountInfo,

        bytes memory data

    )

        external;

}





// File: node_modules\\@openzeppelin\\contracts\\utils\\Address.sol





pragma solidity ^0.6.2;



/**

 * @dev Collection of functions related to the address type

 */

library Address {

    /**

     * @dev Returns true if `account` is a contract.

     *

     * [IMPORTANT]

     * ====

     * It is unsafe to assume that an address for which this function returns

     * false is an externally-owned account (EOA) and not a contract.

     *

     * Among others, `isContract` will return false for the following

     * types of addresses:

     *

     *  - an externally-owned account

     *  - a contract in construction

     *  - an address where a contract will be created

     *  - an address where a contract lived, but was destroyed

     * ====

     */

    function isContract(address account) internal view returns (bool) {

        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts

        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned

        // for accounts without code, i.e. `keccak256('')`

        bytes32 codehash;

        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;

        // solhint-disable-next-line no-inline-assembly

        assembly { codehash := extcodehash(account) }

        return (codehash != accountHash && codehash != 0x0);

    }



    /**

     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to

     * `recipient`, forwarding all available gas and reverting on errors.

     *

     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost

     * of certain opcodes, possibly making contracts go over the 2300 gas limit

     * imposed by `transfer`, making them unable to receive funds via

     * `transfer`. {sendValue} removes this limitation.

     *

     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].

     *

     * IMPORTANT: because control is transferred to `recipient`, care must be

     * taken to not create reentrancy vulnerabilities. Consider using

     * {ReentrancyGuard} or the

     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].

     */

    function sendValue(address payable recipient, uint256 amount) internal {

        require(address(this).balance >= amount, "Address: insufficient balance");



        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value

        (bool success, ) = recipient.call{ value: amount }("");

        require(success, "Address: unable to send value, recipient may have reverted");

    }



    /**

     * @dev Performs a Solidity function call using a low level `call`. A

     * plain`call` is an unsafe replacement for a function call: use this

     * function instead.

     *

     * If `target` reverts with a revert reason, it is bubbled up by this

     * function (like regular Solidity function calls).

     *

     * Returns the raw returned data. To convert to the expected return value,

     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].

     *

     * Requirements:

     *

     * - `target` must be a contract.

     * - calling `target` with `data` must not revert.

     *

     * _Available since v3.1._

     */

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {

      return functionCall(target, data, "Address: low-level call failed");

    }



    /**

     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with

     * `errorMessage` as a fallback revert reason when `target` reverts.

     *

     * _Available since v3.1._

     */

    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {

        return _functionCallWithValue(target, data, 0, errorMessage);

    }



    /**

     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],

     * but also transferring `value` wei to `target`.

     *

     * Requirements:

     *

     * - the calling contract must have an ETH balance of at least `value`.

     * - the called Solidity function must be `payable`.

     *

     * _Available since v3.1._

     */

    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {

        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");

    }



    /**

     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but

     * with `errorMessage` as a fallback revert reason when `target` reverts.

     *

     * _Available since v3.1._

     */

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {

        require(address(this).balance >= value, "Address: insufficient balance for call");

        return _functionCallWithValue(target, data, value, errorMessage);

    }



    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {

        require(isContract(target), "Address: call to non-contract");



        // solhint-disable-next-line avoid-low-level-calls

        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);

        if (success) {

            return returndata;

        } else {

            // Look for revert reason and bubble it up if present

            if (returndata.length > 0) {

                // The easiest way to bubble the revert reason is using memory via assembly



                // solhint-disable-next-line no-inline-assembly

                assembly {

                    let returndata_size := mload(returndata)

                    revert(add(32, returndata), returndata_size)

                }

            } else {

                revert(errorMessage);

            }

        }

    }

}



// File: @openzeppelin\\contracts  oken\\ERC20\\SafeERC20.sol



pragma solidity ^0.6.0;









/**

 * @title SafeERC20

 * @dev Wrappers around ERC20 operations that throw on failure (when the token

 * contract returns false). Tokens that return no value (and instead revert or

 * throw on failure) are also supported, non-reverting calls are assumed to be

 * successful.

 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,

 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.

 */

library SafeERC20 {

    using SafeMath for uint256;

    using Address for address;



    function safeTransfer(IERC20 token, address to, uint256 value) internal {

        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));

    }



    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {

        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));

    }



    /**

     * @dev Deprecated. This function has issues similar to the ones found in

     * {IERC20-approve}, and its usage is discouraged.

     *

     * Whenever possible, use {safeIncreaseAllowance} and

     * {safeDecreaseAllowance} instead.

     */

    function safeApprove(IERC20 token, address spender, uint256 value) internal {

        // safeApprove should only be called when setting an initial allowance,

        // or when resetting it to zero. To increase and decrease it, use

        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'

        // solhint-disable-next-line max-line-length

        require((value == 0) || (token.allowance(address(this), spender) == 0),

            "SafeERC20: approve from non-zero to non-zero allowance"

        );

        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));

    }



    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {

        uint256 newAllowance = token.allowance(address(this), spender).add(value);

        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));

    }



    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {

        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");

        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));

    }



    /**

     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement

     * on the return value: the return value is optional (but if data is returned, it must not be false).

     * @param token The token targeted by the call.

     * @param data The call data (encoded using abi.encode or one of its variants).

     */

    function _callOptionalReturn(IERC20 token, bytes memory data) private {

        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since

        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that

        // the target address contains contract code and also asserts for success in the low-level call.



        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional

            // solhint-disable-next-line max-line-length

            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");

        }

    }

}



// File: contracts\\strategies\\Interfaces\\Aave\\IFlashLoanReceiver.sol



pragma solidity ^0.6.6;



/**

* @title IFlashLoanReceiver interface

* @notice Interface for the Aave fee IFlashLoanReceiver.

* @author Aave

* @dev implement this interface to develop a flashloan-compatible flashLoanReceiver contract

**/

interface IFlashLoanReceiver {

    function executeOperation(address _reserve, uint256 _amount, uint256 _fee, bytes calldata _params) external;

}



// File: contracts\\strategies\\Interfaces\\Aave\\ILendingPoolAddressesProvider.sol



pragma solidity ^0.6.6;



/**

    @title ILendingPoolAddressesProvider interface

    @notice provides the interface to fetch the LendingPoolCore address

 */



interface ILendingPoolAddressesProvider {

    function getLendingPoolCore() external view returns (address payable);

    function getLendingPool() external view returns (address);

}



// File: node_modules\\@openzeppelin\\contracts\\GSN\\Context.sol





pragma solidity ^0.6.0;



/*

 * @dev Provides information about the current execution context, including the

 * sender of the transaction and its data. While these are generally available

 * via msg.sender and msg.data, they should not be accessed in such a direct

 * manner, since when dealing with GSN meta-transactions the account sending and

 * paying for execution may not be the actual sender (as far as an application

 * is concerned).

 *

 * This contract is only required for intermediate, library-like contracts.

 */

abstract contract Context {

    function _msgSender() internal view virtual returns (address payable) {

        return msg.sender;

    }



    function _msgData() internal view virtual returns (bytes memory) {

        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691

        return msg.data;

    }

}



// File: @openzeppelin\\contracts  oken\\ERC20\\ERC20.sol





pragma solidity ^0.6.0;











/**

 * @dev Implementation of the {IERC20} interface.

 *

 * This implementation is agnostic to the way tokens are created. This means

 * that a supply mechanism has to be added in a derived contract using {_mint}.

 * For a generic mechanism see {ERC20PresetMinterPauser}.

 *

 * TIP: For a detailed writeup see our guide

 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How

 * to implement supply mechanisms].

 *

 * We have followed general OpenZeppelin guidelines: functions revert instead

 * of returning `false` on failure. This behavior is nonetheless conventional

 * and does not conflict with the expectations of ERC20 applications.

 *

 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.

 * This allows applications to reconstruct the allowance for all accounts just

 * by listening to said events. Other implementations of the EIP may not emit

 * these events, as it isn't required by the specification.

 *

 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}

 * functions have been added to mitigate the well-known issues around setting

 * allowances. See {IERC20-approve}.

 */

contract ERC20 is Context, IERC20 {

    using SafeMath for uint256;

    using Address for address;



    mapping (address => uint256) private _balances;



    mapping (address => mapping (address => uint256)) private _allowances;



    uint256 private _totalSupply;



    string private _name;

    string private _symbol;

    uint8 private _decimals;



    /**

     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with

     * a default value of 18.

     *

     * To select a different value for {decimals}, use {_setupDecimals}.

     *

     * All three of these values are immutable: they can only be set once during

     * construction.

     */

    constructor (string memory name, string memory symbol) public {

        _name = name;

        _symbol = symbol;

        _decimals = 18;

    }



    /**

     * @dev Returns the name of the token.

     */

    function name() public view returns (string memory) {

        return _name;

    }



    /**

     * @dev Returns the symbol of the token, usually a shorter version of the

     * name.

     */

    function symbol() public view returns (string memory) {

        return _symbol;

    }



    /**

     * @dev Returns the number of decimals used to get its user representation.

     * For example, if `decimals` equals `2`, a balance of `505` tokens should

     * be displayed to a user as `5,05` (`505 / 10 ** 2`).

     *

     * Tokens usually opt for a value of 18, imitating the relationship between

     * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is

     * called.

     *

     * NOTE: This information is only used for _display_ purposes: it in

     * no way affects any of the arithmetic of the contract, including

     * {IERC20-balanceOf} and {IERC20-transfer}.

     */

    function decimals() public view returns (uint8) {

        return _decimals;

    }



    /**

     * @dev See {IERC20-totalSupply}.

     */

    function totalSupply() public view override returns (uint256) {

        return _totalSupply;

    }



    /**

     * @dev See {IERC20-balanceOf}.

     */

    function balanceOf(address account) public view override returns (uint256) {

        return _balances[account];

    }



    /**

     * @dev See {IERC20-transfer}.

     *

     * Requirements:

     *

     * - `recipient` cannot be the zero address.

     * - the caller must have a balance of at least `amount`.

     */

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {

        _transfer(_msgSender(), recipient, amount);

        return true;

    }



    /**

     * @dev See {IERC20-allowance}.

     */

    function allowance(address owner, address spender) public view virtual override returns (uint256) {

        return _allowances[owner][spender];

    }



    /**

     * @dev See {IERC20-approve}.

     *

     * Requirements:

     *

     * - `spender` cannot be the zero address.

     */

    function approve(address spender, uint256 amount) public virtual override returns (bool) {

        _approve(_msgSender(), spender, amount);

        return true;

    }



    /**

     * @dev See {IERC20-transferFrom}.

     *

     * Emits an {Approval} event indicating the updated allowance. This is not

     * required by the EIP. See the note at the beginning of {ERC20};

     *

     * Requirements:

     * - `sender` and `recipient` cannot be the zero address.

     * - `sender` must have a balance of at least `amount`.

     * - the caller must have allowance for ``sender``'s tokens of at least

     * `amount`.

     */

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {

        _transfer(sender, recipient, amount);

        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));

        return true;

    }



    /**

     * @dev Atomically increases the allowance granted to `spender` by the caller.

     *

     * This is an alternative to {approve} that can be used as a mitigation for

     * problems described in {IERC20-approve}.

     *

     * Emits an {Approval} event indicating the updated allowance.

     *

     * Requirements:

     *

     * - `spender` cannot be the zero address.

     */

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {

        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));

        return true;

    }



    /**

     * @dev Atomically decreases the allowance granted to `spender` by the caller.

     *

     * This is an alternative to {approve} that can be used as a mitigation for

     * problems described in {IERC20-approve}.

     *

     * Emits an {Approval} event indicating the updated allowance.

     *

     * Requirements:

     *

     * - `spender` cannot be the zero address.

     * - `spender` must have allowance for the caller of at least

     * `subtractedValue`.

     */

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {

        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));

        return true;

    }



    /**

     * @dev Moves tokens `amount` from `sender` to `recipient`.

     *

     * This is internal function is equivalent to {transfer}, and can be used to

     * e.g. implement automatic token fees, slashing mechanisms, etc.

     *

     * Emits a {Transfer} event.

     *

     * Requirements:

     *

     * - `sender` cannot be the zero address.

     * - `recipient` cannot be the zero address.

     * - `sender` must have a balance of at least `amount`.

     */

    function _transfer(address sender, address recipient, uint256 amount) internal virtual {

        require(sender != address(0), "ERC20: transfer from the zero address");

        require(recipient != address(0), "ERC20: transfer to the zero address");



        _beforeTokenTransfer(sender, recipient, amount);



        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");

        _balances[recipient] = _balances[recipient].add(amount);

        emit Transfer(sender, recipient, amount);

    }



    /** @dev Creates `amount` tokens and assigns them to `account`, increasing

     * the total supply.

     *

     * Emits a {Transfer} event with `from` set to the zero address.

     *

     * Requirements

     *

     * - `to` cannot be the zero address.

     */

    function _mint(address account, uint256 amount) internal virtual {

        require(account != address(0), "ERC20: mint to the zero address");



        _beforeTokenTransfer(address(0), account, amount);



        _totalSupply = _totalSupply.add(amount);

        _balances[account] = _balances[account].add(amount);

        emit Transfer(address(0), account, amount);

    }



    /**

     * @dev Destroys `amount` tokens from `account`, reducing the

     * total supply.

     *

     * Emits a {Transfer} event with `to` set to the zero address.

     *

     * Requirements

     *

     * - `account` cannot be the zero address.

     * - `account` must have at least `amount` tokens.

     */

    function _burn(address account, uint256 amount) internal virtual {

        require(account != address(0), "ERC20: burn from the zero address");



        _beforeTokenTransfer(account, address(0), amount);



        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");

        _totalSupply = _totalSupply.sub(amount);

        emit Transfer(account, address(0), amount);

    }



    /**

     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.

     *

     * This is internal function is equivalent to `approve`, and can be used to

     * e.g. set automatic allowances for certain subsystems, etc.

     *

     * Emits an {Approval} event.

     *

     * Requirements:

     *

     * - `owner` cannot be the zero address.

     * - `spender` cannot be the zero address.

     */

    function _approve(address owner, address spender, uint256 amount) internal virtual {

        require(owner != address(0), "ERC20: approve from the zero address");

        require(spender != address(0), "ERC20: approve to the zero address");



        _allowances[owner][spender] = amount;

        emit Approval(owner, spender, amount);

    }



    /**

     * @dev Sets {decimals} to a value other than the default one of 18.

     *

     * WARNING: This function should only be called from the constructor. Most

     * applications that interact with token contracts will not expect

     * {decimals} to ever change, and may work incorrectly if it does.

     */

    function _setupDecimals(uint8 decimals_) internal {

        _decimals = decimals_;

    }



    /**

     * @dev Hook that is called before any transfer of tokens. This includes

     * minting and burning.

     *

     * Calling conditions:

     *

     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens

     * will be to transferred to `to`.

     * - when `from` is zero, `amount` tokens will be minted for `to`.

     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.

     * - `from` and `to` are never both zero.

     *

     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].

     */

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }

}



// File: @openzeppelin\\contracts\\access\\Ownable.sol





pragma solidity ^0.6.0;



/**

 * @dev Contract module which provides a basic access control mechanism, where

 * there is an account (an owner) that can be granted exclusive access to

 * specific functions.

 *

 * By default, the owner account will be the one that deploys the contract. This

 * can later be changed with {transferOwnership}.

 *

 * This module is used through inheritance. It will make available the modifier

 * `onlyOwner`, which can be applied to your functions to restrict their use to

 * the owner.

 */

contract Ownable is Context {

    address private _owner;



    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);



    /**

     * @dev Initializes the contract setting the deployer as the initial owner.

     */

    constructor () internal {

        address msgSender = _msgSender();

        _owner = msgSender;

        emit OwnershipTransferred(address(0), msgSender);

    }



    /**

     * @dev Returns the address of the current owner.

     */

    function owner() public view returns (address) {

        return _owner;

    }



    /**

     * @dev Throws if called by any account other than the owner.

     */

    modifier onlyOwner() {

        require(_owner == _msgSender(), "Ownable: caller is not the owner");

        _;

    }



    /**

     * @dev Leaves the contract without owner. It will not be possible to call

     * `onlyOwner` functions anymore. Can only be called by the current owner.

     *

     * NOTE: Renouncing ownership will leave the contract without an owner,

     * thereby removing any functionality that is only available to the owner.

     */

    function renounceOwnership() public virtual onlyOwner {

        emit OwnershipTransferred(_owner, address(0));

        _owner = address(0);

    }



    /**

     * @dev Transfers ownership of the contract to a new account (`newOwner`).

     * Can only be called by the current owner.

     */

    function transferOwnership(address newOwner) public virtual onlyOwner {

        require(newOwner != address(0), "Ownable: new owner is the zero address");

        emit OwnershipTransferred(_owner, newOwner);

        _owner = newOwner;

    }

}



// File: contracts\\strategies\\Interfaces\\utils\\Withdrawable.sol



pragma solidity ^0.6.6;









/**

    Ensures that any contract that inherits from this contract is able to

    withdraw funds that are accidentally received or stuck.

 */

 

contract Withdrawable is Ownable {

    using SafeERC20 for ERC20;

    address constant ETHER = address(0);



    event LogWithdraw(

        address indexed _from,

        address indexed _assetAddress,

        uint amount

    );



    /**

     * @dev Withdraw asset.

     * @param _assetAddress Asset to be withdrawn.

     */

    function withdraw(address _assetAddress) public onlyOwner {

        uint assetBalance;

        if (_assetAddress == ETHER) {

            address self = address(this); // workaround for a possible solidity bug

            assetBalance = self.balance;

            msg.sender.transfer(assetBalance);

        } else {

            assetBalance = ERC20(_assetAddress).balanceOf(address(this));

            ERC20(_assetAddress).safeTransfer(msg.sender, assetBalance);

        }

        emit LogWithdraw(msg.sender, _assetAddress, assetBalance);

    }

}



// File: contracts\\strategies\\Interfaces\\Aave\\FlashLoanReceiverBase.sol



pragma solidity ^0.6.6;















abstract contract FlashLoanReceiverBase is IFlashLoanReceiver, Withdrawable {

    using SafeERC20 for IERC20;

    using SafeMath for uint256;



    address constant ethAddress = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    ILendingPoolAddressesProvider public addressesProvider;



    constructor(address _addressProvider) public {

        addressesProvider = ILendingPoolAddressesProvider(_addressProvider);

    }



    receive() external payable {}



    function transferFundsBackToPoolInternal(address _reserve, uint256 _amount) internal {

        address payable core = addressesProvider.getLendingPoolCore();

        transferInternal(core, _reserve, _amount);

    }



    function transferInternal(

        address payable _destination,

        address _reserve,

        uint256 _amount

    ) internal {

        if (_reserve == ethAddress) {

            (bool success, ) = _destination.call{value: _amount}("");

            require(success == true, "Couldn't transfer ETH");

            return;

        }

        IERC20(_reserve).safeTransfer(_destination, _amount);

    }



    function getBalanceInternal(address _target, address _reserve) internal view returns (uint256) {

        if (_reserve == ethAddress) {

            return _target.balance;

        }

        return IERC20(_reserve).balanceOf(_target);

    }

}



// File: contracts\\strategies\\Interfaces\\Aave\\ILendingPool.sol



pragma solidity ^0.6.6;



interface ILendingPool {

  function addressesProvider () external view returns ( address );

  function deposit ( address _reserve, uint256 _amount, uint16 _referralCode ) external payable;

  function redeemUnderlying ( address _reserve, address _user, uint256 _amount ) external;

  function borrow ( address _reserve, uint256 _amount, uint256 _interestRateMode, uint16 _referralCode ) external;

  function repay ( address _reserve, uint256 _amount, address _onBehalfOf ) external payable;

  function swapBorrowRateMode ( address _reserve ) external;

  function rebalanceFixedBorrowRate ( address _reserve, address _user ) external;

  function setUserUseReserveAsCollateral ( address _reserve, bool _useAsCollateral ) external;

  function liquidationCall ( address _collateral, address _reserve, address _user, uint256 _purchaseAmount, bool _receiveAToken ) external payable;

  function flashLoan ( address _receiver, address _reserve, uint256 _amount, bytes calldata _params ) external;

  function getReserveConfigurationData ( address _reserve ) external view returns ( uint256 ltv, uint256 liquidationThreshold, uint256 liquidationDiscount, address interestRateStrategyAddress, bool usageAsCollateralEnabled, bool borrowingEnabled, bool fixedBorrowRateEnabled, bool isActive );

  function getReserveData ( address _reserve ) external view returns ( uint256 totalLiquidity, uint256 availableLiquidity, uint256 totalBorrowsFixed, uint256 totalBorrowsVariable, uint256 liquidityRate, uint256 variableBorrowRate, uint256 fixedBorrowRate, uint256 averageFixedBorrowRate, uint256 utilizationRate, uint256 liquidityIndex, uint256 variableBorrowIndex, address aTokenAddress, uint40 lastUpdateTimestamp );

  function getUserAccountData ( address _user ) external view returns ( uint256 totalLiquidityETH, uint256 totalCollateralETH, uint256 totalBorrowsETH, uint256 availableBorrowsETH, uint256 currentLiquidationThreshold, uint256 ltv, uint256 healthFactor );

  function getUserReserveData ( address _reserve, address _user ) external view returns ( uint256 currentATokenBalance, uint256 currentUnderlyingBalance, uint256 currentBorrowBalance, uint256 principalBorrowBalance, uint256 borrowRateMode, uint256 borrowRate, uint256 liquidityRate, uint256 originationFee, uint256 variableBorrowIndex, uint256 lastUpdateTimestamp, bool usageAsCollateralEnabled );

  function getReserves () external view;

}



// File: contracts\\strategies\\Interfaces\\Chainlink\\AggregatorV3Interface.sol



pragma solidity >=0.6.0;



interface AggregatorV3Interface {



  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);



  // getRoundData and latestRoundData should both raise "No data present"

  // if they do not have data to report, instead of returning unset values

  // which could be misinterpreted as actual reported values.

  function getRoundData(uint80 _roundId)

    external

    view

    returns (

      uint80 roundId,

      int256 answer,

      uint256 startedAt,

      uint256 updatedAt,

      uint80 answeredInRound

    );

  function latestRoundData()

    external

    view

    returns (

      uint80 roundId,

      uint256 answer,

      uint256 startedAt,

      uint256 updatedAt,

      uint80 answeredInRound

    );



}



// File: contracts\\strategies\\BaseStrategy.sol



pragma solidity >=0.6.0 <0.7.0;







struct StrategyParams {

    uint256 performanceFee;

    uint256 activation;

    uint256 debtLimit;

    uint256 rateLimit;

    uint256 lastSync;

    uint256 totalDebt;

    uint256 totalReturns;

}



interface VaultAPI {

    function token() external view returns (address);



    function strategies(address _strategy) external view returns (StrategyParams memory);



    /*

     * View how much the Vault would increase this strategy's borrow limit,

     * based on it's present performance (since its last report). Can be used to

     * determine expectedReturn in your strategy.

     */

    function creditAvailable() external view returns (uint256);



    /*

     * View how much the Vault would like to pull back from the Strategy,

     * based on it's present performance (since its last report). Can be used to

     * determine expectedReturn in your strategy.

     */

    function debtOutstanding() external view returns (uint256);



    /*

     * View how much the Vault expect this strategy to return at the current block,

     * based on it's present performance (since its last report). Can be used to

     * determine expectedReturn in your strategy.

     */

    function expectedReturn() external view returns (uint256);



    /*

     * This is the main contact point where the strategy interacts with the Vault.

     * It is critical that this call is handled as intended by the Strategy.

     * Therefore, this function will be called by BaseStrategy to make sure the

     * integration is correct.

     */

    function report(uint256 _harvest) external returns (uint256);



    /*

     * This function is used in the scenario where there is a newer strategy that

     * would hold the same positions as this one, and those positions are easily

     * transferrable to the newer strategy. These positions must be able to be

     * transferred at the moment this call is made, if any prep is required to

     * execute a full transfer in one transaction, that must be accounted for

     * separately from this call.

     */

    function migrateStrategy(address _newStrategy) external;



    /*

     * This function should only be used in the scenario where the strategy is

     * being retired but no migration of the positions are possible, or in the

     * extreme scenario that the Strategy needs to be put into "Emergency Exit"

     * mode in order for it to exit as quickly as possible. The latter scenario

     * could be for any reason that is considered "critical" that the Strategy

     * exits it's position as fast as possible, such as a sudden change in market

     * conditions leading to losses, or an imminent failure in an external

     * dependency.

     */

    function revokeStrategy() external;



    /*

     * View the governance address of the Vault to assert privileged functions

     * can only be called by governance. The Strategy serves the Vault, so it

     * is subject to governance defined by the Vault.

     *

     */

    function governance() external view returns (address);

}



/*

 * This interface is here for the keeper bot to use

 */

interface StrategyAPI {

    function vault() external view returns (address);



    function keeper() external view returns (address);



    function tendTrigger(uint256 gasCost) external view returns (bool);



    function tend() external;



    function harvestTrigger(uint256 gasCost) external view returns (bool);



    function harvest() external;



    event Harvested(uint256 wantEarned, uint256 lifetimeEarned);

}



/*

 * BaseStrategy implements all of the required functionality to interoperate closely

 * with the core protocol. This contract should be inherited and the abstract methods

 * implemented to adapt the strategy to the particular needs it has to create a return.

 */



abstract contract BaseStrategy {

    using SafeMath for uint256;



    // Version of this contract

    function version() external pure returns (string memory) {

        return "0.1.1";

    }



    VaultAPI public vault;

    address public strategist;

    address public keeper;



    IERC20 public want;



    // So indexers can keep track of this

    event Harvested(uint256 wantEarned, uint256 lifetimeEarned);



    // Adjust this to keep some of the position in reserve in the strategy,

    // to accomodate larger variations needed to sustain the strategy's core positon(s)

    uint256 public reserve = 0;



    // This gets adjusted every time the Strategy reports to the Vault,

    // and should be used during adjustment of the strategy's positions to "deleverage"

    // in order to pay back the amount the next time it reports.

    //

    // NOTE: Do not edit this variable, for safe usage (only read from it)

    // NOTE: Strategy should not expect to increase it's working capital until this value

    //       is zero.

    uint256 public outstanding = 0;



    bool public emergencyExit;



    constructor(address _vault) public {



        vault = VaultAPI(_vault);

        want = IERC20(vault.token());

        want.approve(_vault, uint256(-1)); // Give Vault unlimited access (might save gas)

        strategist = msg.sender;

        keeper = msg.sender;

    }



    function setStrategist(address _strategist) external {

        require(msg.sender == strategist || msg.sender == governance(), "!governance");

        strategist = _strategist;

    }



    function setKeeper(address _keeper) external {

        require(msg.sender == strategist || msg.sender == governance(), "!governance");

        keeper = _keeper;

    }



    /*

     * Resolve governance address from Vault contract, used to make

     * assertions on protected functions in the Strategy

     */

    function governance() internal view returns (address) {

        return vault.governance();

    }



    /*

     * Provide an accurate expected value for the return this strategy

     * would provide to the Vault the next time `report()` is called

     * (since the last time it was called)

     */

    function expectedReturn() public virtual view returns (uint256);



    /*

     * Provide an accurate estimate for the total amount of assets (principle + return)

     * that this strategy is currently managing, denominated in terms of `want` tokens.

     * This total should be "realizable" e.g. the total value that could *actually* be

     * obtained from this strategy if it were to divest it's entire position based on

     * current on-chain conditions.

     *

     * NOTE: care must be taken in using this function, since it relies on external

     *       systems, which could be manipulated by the attacker to give an inflated

     *       (or reduced) value produced by this function, based on current on-chain

     *       conditions (e.g. this function is possible to influence through flashloan

     *       attacks, oracle manipulations, or other DeFi attack mechanisms).

     *

     * NOTE: It is up to governance to use this function in order to correctly order

     *       this strategy relative to its peers in order to minimize losses for the

     *       Vault based on sudden withdrawals. This value should be higher than the

     *       total debt of the strategy and higher than it's expected value to be "safe".

     */

    function estimatedTotalAssets() public virtual view returns (uint256);



    /*

     * Perform any strategy unwinding or other calls necessary to capture

     * the "free return" this strategy has generated since the last time it's

     * core position(s) were adusted. Examples include unwrapping extra rewards.

     * This call is only used during "normal operation" of a Strategy, and should

     * be optimized to minimize losses as much as possible. It is okay to report

     * "no returns", however this will affect the credit limit extended to the

     * strategy and reduce it's overall position if lower than expected returns

     * are sustained for long periods of time.

     */

    function prepareReturn() internal virtual;



    /*

     * Perform any adjustments to the core position(s) of this strategy given

     * what change the Vault made in the "investable capital" available to the

     * strategy. Note that all "free capital" in the strategy after the report

     * was made is available for reinvestment. Also note that this number could

     * be 0, and you should handle that scenario accordingly.

     */

    function adjustPosition() internal virtual;



    /*

     * Make as much capital as possible "free" for the Vault to take. Some slippage

     * is allowed, since when this method is called the strategist is no longer receiving

     * their performance fee. The goal is for the strategy to divest as quickly as possible

     * while not suffering exorbitant losses. This function is used during emergency exit

     * instead of `prepareReturn()`

     */

    function exitPosition() internal virtual;



    /*

     * Provide a signal to the keeper that `tend()` should be called. The keeper will provide

     * the estimated gas cost that they would pay to call `tend()`, and this function should

     * use that estimate to make a determination if calling it is "worth it" for the keeper.

     * This is not the only consideration into issuing this trigger, for example if the position

     * would be negatively affected if `tend()` is not called shortly, then this can return `true`

     * even if the keeper might be "at a loss" (keepers are always reimbursed by yEarn)

     *

     * NOTE: this call and `harvestTrigger` should never return `true` at the same time.

     * NOTE: if `tend()` is never intended to be called, it should always return `false`

     */

    function tendTrigger(uint256 gasCost) public virtual view returns (bool);



    function tend() external {

        if (keeper != address(0)) require(msg.sender == keeper || msg.sender == strategist || msg.sender == governance());

        // NOTE: Don't take profits with this call, but adjust for better gains

        adjustPosition();

    }



    /*

     * Provide a signal to the keeper that `harvest()` should be called. The keeper will provide

     * the estimated gas cost that they would pay to call `harvest()`, and this function should

     * use that estimate to make a determination if calling it is "worth it" for the keeper.

     * This is not the only consideration into issuing this trigger, for example if the position

     * would be negatively affected if `harvest()` is not called shortly, then this can return `true`

     * even if the keeper might be "at a loss" (keepers are always reimbursed by yEarn)

     *

     * NOTE: this call and `tendTrigger` should never return `true` at the same time.

     */

    function harvestTrigger(uint256 gasCost) public virtual view returns (bool);



    function harvest() external {

        if (keeper != address(0)) require(msg.sender == keeper || msg.sender == strategist || msg.sender == governance());



        if (emergencyExit) {

            exitPosition(); // Free up as much capital as possible

            // NOTE: Don't take performance fee in this scenario

        } else {

            prepareReturn(); // Free up returns for Vault to pull

        }



        if (reserve > want.balanceOf(address(this))) reserve = want.balanceOf(address(this));



        // Allow Vault to take up to the "harvested" balance of this contract, which is

        // the amount it has earned since the last time it reported to the Vault

        uint256 wantEarned = want.balanceOf(address(this)).sub(reserve);

        outstanding = vault.report(wantEarned);



        adjustPosition(); // Check if free returns are left, and re-invest them



        emit Harvested(wantEarned, vault.strategies(address(this)).totalReturns);

    }



    /*

     * Liquidate as many assets as possible to `want`, irregardless of slippage,

     * up to `_amount`. Any excess should be re-invested here as well.

     */

    function liquidatePosition(uint256 _amount) internal virtual;



    function withdraw(uint256 _amount) external {

        require(msg.sender == address(vault), "!vault");

        liquidatePosition(_amount); // Liquidates as much as possible to `want`, up to `_amount`

        want.transfer(msg.sender, want.balanceOf(address(this)).sub(reserve));

    }



    /*

     * Do anything necesseary to prepare this strategy for migration, such

     * as transfering any reserve or LP tokens, CDPs, or other tokens or stores of value.

     */

    function prepareMigration(address _newStrategy) internal virtual;



    function migrate(address _newStrategy) external {

        require(msg.sender == address(vault) || msg.sender == governance());

        require(BaseStrategy(_newStrategy).vault() == vault);

        prepareMigration(_newStrategy);

    }



    function setEmergencyExit() external {

        require(msg.sender == strategist || msg.sender == governance());

        emergencyExit = true;

        exitPosition();

        vault.revokeStrategy();

        if (reserve > want.balanceOf(address(this))) reserve = want.balanceOf(address(this));

        outstanding = vault.report(want.balanceOf(address(this)).sub(reserve));

    }



    // Override this to add all tokens this contract manages on a *persistant* basis

    // (e.g. not just for swapping back to want ephemerally)

    // NOTE: Must inclide `want` token

    function protectedTokens() internal virtual view returns (address[] memory) {

        address[] memory protected = new address[](1);

        protected[0] = address(want);

        return protected;

    }



    function sweep(address _token) external {

        address[] memory _protectedTokens = protectedTokens();

        for (uint256 i; i < _protectedTokens.length; i++) require(_token != _protectedTokens[i], "!protected");



        IERC20(_token).transfer(governance(), IERC20(_token).balanceOf(address(this)));

    }

}



// File: contracts\\strategies\\YearnDaiCompStratV2.sol



pragma solidity ^0.6.9;





























/********************

*   A simple Comp farming strategy from leveraged lending of DAI. 

*   Uses Flash Loan to leverage up quicker. But not neccessary for operation

*   https://github.com/Grandthrax/yearnv2/blob/master/contracts/YearnDaiCompStratV2.sol

*

********************* */



contract YearnDaiCompStratV2 is BaseStrategy, DydxFlashloanBase, ICallee, FlashLoanReceiverBase {

    using SafeERC20 for IERC20;

    using Address for address;

    using SafeMath for uint256;

    

    // @notice emitted when trying to do Flash Loan. flashLoan address is 0x00 when no flash loan used

    event Leverage(uint amountRequested, uint amountGiven, bool deficit, address flashLoan);



    string public constant name = "LeveragedDaiCompStrategyV2";



    //Flash Loan Providers

    address private constant SOLO = 0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e;

    address private constant AAVE_LENDING = 0x24a42fD28C976A61Df5D00D0599C34c4f90748c8;



    // Chainlink price feed contracts

    address private constant COMP2USD = 0xdbd020CAeF83eFd542f4De03e3cF0C28A4428bd5;

    address private constant DAI2USD = 0xAed0c38402a5d19df6E4c03F4E2DceD6e29c1ee9;

    address private constant ETH2USD = 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419;



    // Comptroller address for compound.finance

    ComptrollerI public constant compound = ComptrollerI(0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B); 



    //Only three tokens we use

    address public constant comp =  address(0xc00e94Cb662C3520282E6f5717214004A7f26888);

    CErc20I public constant cDAI = CErc20I(address(0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643));

    address public constant DAI = address(0x6B175474E89094C44Da98b954EedeAC495271d0F);



    address public constant uniswapRouter = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

    address public constant weth = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2); 



    //Operating variables

    uint256 public collateralTarget = 0.73 ether;  // 73% 

    uint256 public blocksToLiquidationDangerZone = 46500;  // 24 hours =  60*60*24*7/13



    uint256 public minDAI = 10 ether; //Only lend if we have enough DAI to be worth it

    uint256 public minCompToSell = 0.5 ether; //used both as the threshold to sell but also as a trigger for harvest

    uint256 public gasFactor = 50; // multiple before triggering harvest



    //To deactivate flash loan provider if needed

    bool public DyDxActive = true;

    bool public AaveActive = true;



    constructor(address _vault) public BaseStrategy(_vault) FlashLoanReceiverBase(AAVE_LENDING)

    {



        //only accept DAI vault

        require(vault.token() == DAI, "!DAI");

                    

        //pre-set approvals

        IERC20(comp).safeApprove(uniswapRouter, uint256(-1));

        want.safeApprove(address(cDAI), uint256(-1));

        want.safeApprove(SOLO, uint256(-1));



    }



    /*

    * Control Functions

    */

    function disableDyDx() external {

        require(msg.sender == governance() || msg.sender == strategist, "!management");// dev: not governance or strategist

        DyDxActive = false;

    }

    function enableDyDx() external {

        require(msg.sender == governance() || msg.sender == strategist, "!management");// dev: not governance or strategist

        DyDxActive = true;

    }

    function disableAave() external {

        require(msg.sender == governance() || msg.sender == strategist, "!management");// dev: not governance or strategist

        AaveActive = false;

    }

    function enableAave() external {

        require(msg.sender == governance() || msg.sender == strategist, "!management");// dev: not governance or strategist

        AaveActive = true;

    }

    function setGasFactor(uint _gasFactor) external {

        require(msg.sender == governance() || msg.sender == strategist, "!management");// dev: not governance or strategist

        gasFactor = _gasFactor;

    }

    function setMinCompToSell(uint _minCompToSell) external {

        require(msg.sender == governance() || msg.sender == strategist, "!management");// dev: not governance or strategist

        minCompToSell = _minCompToSell;

    }

    function setCollateralTarget(uint _collateralTarget) external {

        require(msg.sender == governance() || msg.sender == strategist, "!management");// dev: not governance or strategist

        collateralTarget = _collateralTarget;

    }



    /*

    * Base External Facing Functions 

    */



    /*

     * Expected return this strategy would provide to the Vault the next time `report()` is called

     *

     * The total assets currently in strategy minus what vault believes we have

     * Does not include unrealised profit such as comp.

     */

    function expectedReturn() public override view returns (uint256) {

        uint estimateAssets =  estimatedTotalAssets();



        uint debt = vault.strategies(address(this)).totalDebt;

        if(debt > estimateAssets){

            return 0;

        }else{

            return estimateAssets - debt;

        }

    }



    /*

     * An accurate estimate for the total amount of assets (principle + return)

     * that this strategy is currently managing, denominated in terms of DAI tokens.

     */

    function estimatedTotalAssets() public override view returns (uint256) {

        (uint deposits, uint borrows) = getCurrentPosition();

        

        uint256 _claimableComp = predictCompAccrued();

        uint currentComp = IERC20(comp).balanceOf(address(this));



        // Use chainlink price feed to retrieve COMP and DAI prices expressed in USD. Then convert

        uint256 latestExchangeRate = getLatestExchangeRate();



        uint256 estimatedDAI = latestExchangeRate.mul(_claimableComp.add(currentComp));

        uint256 conservativeDai = estimatedDAI.mul(9).div(10); //10% pessimist

        

        return want.balanceOf(address(this)).add(deposits).add(conservativeDai).sub(borrows);



    }



    /*

     * Aggragate the value in USD for COMP and DAI onchain from different chainlink nodes

     * reducing risk of price manipulation within onchain market.

     * Operation: COMP_PRICE_IN_USD / DAI_PRICE_IN_USD

     */

    function getLatestExchangeRate() public view returns(uint256) {

      ( , uint256 price_comp, , ,  ) = AggregatorV3Interface(COMP2USD).latestRoundData();

      ( , uint256 price_dai, , ,  ) = AggregatorV3Interface(DAI2USD).latestRoundData();

      

      return price_comp.mul(1 ether).div(price_dai).div(1 ether);

    }



    function getCompValInWei(uint256 _amount) public view returns(uint256) {

      ( , uint256 price_comp, , ,  ) = AggregatorV3Interface(COMP2USD).latestRoundData();

      ( , uint256 price_eth, , ,  ) = AggregatorV3Interface(ETH2USD).latestRoundData();

      

      return price_comp.mul(1 ether).div(price_eth).mul(_amount).div(1 ether);

    }



    /*

     * Provide a signal to the keeper that `tend()` should be called. 

     * (keepers are always reimbursed by yEarn)

     *

     * NOTE: this call and `harvestTrigger` should never return `true` at the same time.

     */

    function tendTrigger(uint256 gasCost) public override view returns (bool) {

        if(harvestTrigger(0)){

            //harvest takes priority

            return false;

        }



        if(getblocksUntilLiquidation() <= blocksToLiquidationDangerZone){

                return true;

        }

    }



    /*

     * Provide a signal to the keeper that `harvest()` should be called.

     * gasCost is expected_gas_use * gas_price 

     * (keepers are always reimbursed by yEarn)

     *

     * NOTE: this call and `tendTrigger` should never return `true` at the same time.

     */

    function harvestTrigger(uint256 gasCost) public override view returns (bool) {



        



        if(vault.creditAvailable() > minDAI.mul(gasFactor))

        {

            return true;

        }



        // after enough comp has accrued we want the bot to run

        uint256 _claimableComp = predictCompAccrued();



        if(_claimableComp > minCompToSell) {

            // check value of COMP in wei

            uint256 _compWei = getCompValInWei(_claimableComp.add(IERC20(comp).balanceOf(address(this))));

            if(_compWei > gasCost.mul(gasFactor)) {

                return true;

            }

        }

       

        return false;

    }





    /*****************

    * Public non-base function

    ******************/



    //Calculate how many blocks until we are in liquidation based on current interest rates

    //WARNING does not include compounding so the estimate becomes more innacurate the further ahead we look

    //equation. Compound doesn't include compounding for most blocks

    //((deposits*colateralThreshold - borrows) / (borrows*borrowrate - deposits*colateralThreshold*interestrate));

    function getblocksUntilLiquidation() public view returns (uint256 blocks){

        

        (, uint collateralFactorMantissa,) = compound.markets(address(cDAI));

        

        (uint deposits, uint borrows) = getCurrentPosition();



        uint borrrowRate = cDAI.borrowRatePerBlock();



        uint supplyRate = cDAI.supplyRatePerBlock();



        uint collateralisedDeposit1 = deposits.mul(collateralFactorMantissa);

        uint collateralisedDeposit = collateralisedDeposit1.div(1e18);



        uint denom1 = borrows.mul(borrrowRate);

        uint denom2 =  collateralisedDeposit.mul(supplyRate);

      

        if(denom2 >= denom1 ){

            blocks = uint256(-1);

        }else{

            uint numer = collateralisedDeposit.sub(borrows);

            uint denom = denom1 - denom2;



            blocks = numer.mul(1e18).div(denom);

        }

    }



    // This function makes a prediction on how much comp is accrued

    // It is not 100% accurate as it uses current balances in Compound to predict into the past

    function predictCompAccrued() public view returns (uint) {

        

        (uint256 deposits, uint256 borrows) = getCurrentPosition();

        if(deposits == 0){

            return 0; // should be impossible to have 0 balance and positive comp accrued

        }

        

        //comp speed is amount to borrow or deposit (so half the total distribution for dai)

        uint256 distributionPerBlock = compound.compSpeeds(address(cDAI));



        uint256 totalBorrow = cDAI.totalBorrows();



        //total supply needs to be echanged to underlying using exchange rate

        uint256 totalSupplyCtoken = cDAI.totalSupply();

        uint256 totalSupply = totalSupplyCtoken.mul(cDAI.exchangeRateStored()).div(1e18);



        uint256 blockShareSupply = deposits.mul(distributionPerBlock).div(totalSupply);

        uint256 blockShareBorrow = borrows.mul(distributionPerBlock).div(totalBorrow);



        //how much we expect to earn per block

        uint256 blockShare = blockShareSupply.add(blockShareBorrow);

      

        //last time we ran harvest

        uint256 lastReport = vault.strategies(address(this)).lastSync;

        return (block.number.sub(lastReport)).mul(blockShare);

    }

    

    //Returns the current position

    //WARNING - this returns just the balance at last time someone touched the cDAI token. Does not accrue interst in between

    //cDAI is very active so not normally an issue.

    function getCurrentPosition() public view returns (uint deposits, uint borrows) {



        (, uint ctokenBalance, uint borrowBalance, uint exchangeRate) = cDAI.getAccountSnapshot(address(this));

        borrows = borrowBalance;



        deposits =  ctokenBalance.mul(exchangeRate).div(1e18);

    }



    //statechanging version

    function getLivePosition() public returns (uint deposits, uint borrows) {

        deposits = cDAI.balanceOfUnderlying(address(this));



        //we can use non state changing now because we updated state with balanceOfUnderlying call

        borrows = cDAI.borrowBalanceStored(address(this));

    }



    //Same warning as above

    function netBalanceLent() public view returns (uint256) {

        (uint deposits, uint borrows) =getCurrentPosition();

        return deposits.sub(borrows);

    }





    /***********

    * internal core logic

    *********** */  

    /*

     * A core method. 

     * Called at beggining of harvest before providing report to owner

     * 1 - claim accrued comp

     * 2 - if enough to be worth it we sell

     * 3 - because we lose money on our loans we need to offset profit from comp. 

     */ 

    function prepareReturn() internal override {

        if(cDAI.balanceOf(address(this)) == 0){

            //no position to harvest

            return;

        }



        //claim comp accrued

        _claimComp();

        //sell comp

        _disposeOfComp();



        uint daiBalance = want.balanceOf(address(this));

        if(outstanding > daiBalance){

            //withdrawn the money we need. False so we dont use backup and pay aave fees for mature deleverage

            (uint deposits, uint borrows) = getLivePosition();

            _withdrawSome(deposits - borrows, false);



            return;

        }



        uint balance = estimatedTotalAssets();

        

        

        uint debt = vault.strategies(address(this)).totalDebt;



        //Balance - Total Debt is profit

        if(balance > debt){

             uint profit = balance- debt;

            

            if(profit >= daiBalance ){

                //all reserve is profit

                reserve = 0;

            }else{



                //some dai is not profit and needs to pay off our interest

                //this is most likely situation

                reserve = daiBalance.sub(profit);

            }

        } else{

            //no profit so we set our reserves to our total balance

            reserve = daiBalance;

        }  

    }



    /*

     * Second core function. Happens after report call.

     *

     * Similar to deposit function from V1 strategy

     */



    function adjustPosition() internal override {



        //emergency exit is dealt with in prepareReturn

        if(emergencyExit){

            return;

        }



        if(reserve != 0){

            //reset reserve so it doesnt interfere anywhere else

            reserve = 0;

        }



        //we are spending all our cash unless

        //we dont care about outstanding debt until next return

        uint _wantBal = want.balanceOf(address(this));        



        // We pass in the balance we are adding. 

        // We get returned the amount we need to reduce or add to our loan positions to keep at our target collateral ratio

        (uint256 position, bool deficit) = _calculateDesiredPosition(_wantBal, true);

        

        //if we are below minimun DAI change it is not worth doing        

        if (position > minDAI) {



            //if dydx is not active we just try our best with basic leverage

            if(!DyDxActive){

                _noFlashLoan(position, deficit);

            }else{

                //if there is huge position to improve we want to do normal leverage. it is quicker

                if(position > IERC20(DAI).balanceOf(SOLO)){

                    position = position.sub(_noFlashLoan(position, deficit));

                }

           

                //flash loan to position 

                doDyDxFlashLoan(deficit, position);

            }

        }

    }



    /*************

    * Very important function

    * Input: amount we want to withdraw and whether we are happy to pay extra for Aave. 

    *       cannot be more than we have

    * Returns amount we were able to withdraw. notall if user has some balance left

    *

    * Deleverage position -> redeem our cTokens

    ******************** */

    function _withdrawSome(uint256 _amount, bool _useBackup) internal returns (bool notAll) {



        (uint256 position, bool deficit) = _calculateDesiredPosition(_amount, false);



        //If there is no deficit we dont need to adjust position

        if(deficit){



            //we do a flash loan to give us a big gap. from here on out it is cheaper to use normal deleverage. Use Aave for extremely large loans

            if(DyDxActive){

                position = position.sub(doDyDxFlashLoan(deficit, position));

            }

            

            // Will decrease number of interactions using aave as backup

            // because of fee we only use in emergency

            if(position >0 && AaveActive && _useBackup) {

               position = position.sub(doAaveFlashLoan(deficit, position));

            }



            uint8 i = 0;

            //position will equal 0 unless we haven't been able to deleverage enough with flash loan

            //if we are not in deficit we dont need to do flash loan

            while(position >0){



                position = position.sub(_noFlashLoan(position, true));

                i++;



                //A limit set so we don't run out of gas

                if(i >= 5){

                    notAll= true;

                    break;

               }

            }

        }

        

        //now withdraw

        //if we want too much we just take max



        //This part makes sure our withdrawal does not force us into liquidation        

        (uint depositBalance ,uint borrowBalance) = getCurrentPosition();

        uint AmountNeeded = borrowBalance.mul(1e18).div(collateralTarget);

        if(depositBalance.sub(AmountNeeded) < _amount){

            cDAI.redeemUnderlying(depositBalance.sub(AmountNeeded));

        }else{

            cDAI.redeemUnderlying(_amount);

        }



        //let's sell some comp if we have more than needed

        //flash loan would have sent us comp if we had some accrued so we don't need to call claim comp

        _disposeOfComp();

    }



    /***********

    *  This is the main logic for calculating how to change our lends and borrows

    *  Input: balance. The net amount we are going to deposit/withdraw.

    *  Input: dep. Is it a deposit or withdrawal

    *  Output: position. The amount we want to change our current borrow position.                   

    *  Output: deficit. True if we are reducing position size

    *

    *  For instance deficit =false, position 100 means increase borrowed balance by 100

    ****** */

    function _calculateDesiredPosition(uint256 balance, bool dep) internal returns (uint256 position, bool deficit) {



        //we want to use statechanging for safety

        (uint deposits, uint borrows) = getLivePosition();



        //When we unwind we end up with the difference between borrow and supply

        uint unwoundDeposit = deposits.sub(borrows);



        //we want to see how close to collateral target we are. 

        //So we take our unwound deposits and add or remove the balance we are are adding/removing.

        //This gives us our desired future undwoundDeposit (desired supply)



        uint desiredSupply = 0;

        if(dep){

            desiredSupply = unwoundDeposit.add(balance);

        }else{

            desiredSupply = unwoundDeposit.sub(balance);            

        }



        //(ds *c)/(1-c)

        uint num = desiredSupply.mul(collateralTarget);

        uint den = uint256(1e18).sub(collateralTarget);



        uint desiredBorrow = num.div(den);

        if(desiredBorrow > 1e18 ){

            //stop us going right up to the wire

            desiredBorrow = desiredBorrow - 1e18;

        }



        //now we see if we want to add or remove balance

        // if the desired borrow is less than our current borrow we are in deficit. so we want to reduce position

        if(desiredBorrow < borrows){

            deficit = true;

            position = borrows - desiredBorrow; //safemath check done in if statement



        }else{

            //otherwise we want to increase position

            deficit = false;

            position = desiredBorrow - borrows;

        }

    }



    /*

     * Liquidate as many assets as possible to `want`, irregardless of slippage,

     * up to `_amount`. Any excess should be re-invested here as well.

     */

    function liquidatePosition(uint256 _amount) internal override {



        uint256 _balance = want.balanceOf(address(this));

        

        if(netBalanceLent().add(_balance) < _amount){

            //if we cant afford to withdraw we take all we can

            //withdraw all we can

            exitPosition();

        }else{



            if (_balance < _amount) {

                require(!_withdrawSome(_amount.sub(_balance), true), "DelevFirst");

            }

        }

    }



     function _claimComp() internal {

      

        CTokenI[] memory tokens = new CTokenI[](1);

        tokens[0] =  cDAI;



        compound.claimComp(address(this), tokens);

    }



    //sell comp function

    function _disposeOfComp() internal {



        uint256 _comp = IERC20(comp).balanceOf(address(this));

        

        if (_comp > minCompToSell) {



            address[] memory path = new address[](3);

            path[0] = comp;

            path[1] = weth;

            path[2] = DAI;



            IUniswapV2Router02(uniswapRouter).swapExactTokensForTokens(_comp, uint256(0), path, address(this), now);

        }

    }



    /*

     * Make as much capital as possible "free" for the Vault to take. Some slippage

     * is allowed. 

     */

    function exitPosition() internal override {



        //we dont use getCurrentPosition() because it won't be exact

        (uint deposits, uint borrows) = getLivePosition();

        _withdrawSome(deposits.sub(borrows), true);



    }



    //lets leave

    function prepareMigration(address _newStrategy) internal override{

        exitPosition();

       

        (, , uint borrowBalance,) = cDAI.getAccountSnapshot(address(this));



        require(borrowBalance ==0, "DELEVERAGE_FIRST");



        want.safeTransfer(_newStrategy, want.balanceOf(address(this)));



        cDAI.transfer(_newStrategy, cDAI.balanceOf(address(this)));

        

        IERC20 _comp = IERC20(comp);

        _comp.safeTransfer(_newStrategy, _comp.balanceOf(address(this)));



    }



    //Three functions covering normal leverage and deleverage situations

    // max is the max amount we want to increase our borrowed balance

    // returns the amount we actually did

    function _noFlashLoan(uint256 max, bool deficit) internal returns (uint256 amount){



        //we can use non-state changing because this function is always called after _calculateDesiredPosition

        (uint lent, uint borrowed) = getCurrentPosition();

       

        if(borrowed == 0){

             return 0;

         }



        (, uint collateralFactorMantissa,) = compound.markets(address(cDAI));



        if(deficit){

           amount = _normalDeleverage(max, lent, borrowed, collateralFactorMantissa);

        }else{

           amount = _normalLeverage(max, lent, borrowed, collateralFactorMantissa);

        }



        emit Leverage(max, amount, deficit,  address(0));

    }



    //maxDeleverage is how much we want to reduce by

    function _normalDeleverage(uint256 maxDeleverage, uint lent, uint borrowed, uint collatRatio) internal returns (uint256 deleveragedAmount) {



        uint theoreticalLent = borrowed.mul(1e18).div(collatRatio);



        deleveragedAmount = lent.sub(theoreticalLent);

        

        if(deleveragedAmount >= borrowed){

            deleveragedAmount = borrowed;

        }

        if(deleveragedAmount >= maxDeleverage){

            deleveragedAmount = maxDeleverage;

        }



        cDAI.redeemUnderlying(deleveragedAmount);

        

        //our borrow has been increased by no more than maxDeleverage

        cDAI.repayBorrow(deleveragedAmount);

    }



    //maxDeleverage is how much we want to increase by

    function _normalLeverage(uint256 maxLeverage, uint lent, uint borrowed, uint collatRatio) internal returns (uint256 leveragedAmount){



        uint theoreticalBorrow = lent.mul(collatRatio).div(1e18);



        leveragedAmount = theoreticalBorrow.sub(borrowed);



        if(leveragedAmount >= maxLeverage){

            leveragedAmount = maxLeverage;

        }



        cDAI.borrow(leveragedAmount);

        cDAI.mint(want.balanceOf(address(this)));



    }



    //called by flash loan

    function _loanLogic(bool deficit, uint256 amount, uint256 repayAmount) internal {

        //if in deficit we repay amount and then withdraw

        if(deficit) {

           



            cDAI.repayBorrow(amount);



            //if we are withdrawing we take more to cover fee

            cDAI.redeemUnderlying(repayAmount);

        } else {   

      

            require(cDAI.mint(want.balanceOf(address(this))) == 0, "mint error");



            //borrow more to cover fee

            // fee is so low for dydx that it does not effect our liquidation risk. 

            //DONT USE FOR AAVE

            cDAI.borrow(repayAmount);



        }

    }



   function protectedTokens() internal override view returns (address[] memory) {

        address[] memory protected = new address[](3);

        protected[0] = address(want);

        protected[1] = comp;

        protected[2] = address(cDAI);

        return protected;

    }



    /******************

    * Flash loan stuff

    ****************/



    // Flash loan DXDY

    // amount desired is how much we are willing for position to change

    function doDyDxFlashLoan(bool deficit, uint256 amountDesired) internal returns (uint256) {



        uint amount = amountDesired;

        ISoloMargin solo = ISoloMargin(SOLO);

        uint256 marketId = _getMarketIdFromTokenAddress(SOLO, address(want));



        // Not enough DAI in DyDx. So we take all we can

        uint amountInSolo = want.balanceOf(SOLO);

  

        if(amountInSolo < amount)

        {

            amount = amountInSolo;

        }



        uint256 repayAmount = _getRepaymentAmountInternal(amount);



        bytes memory data = abi.encode(deficit, amount, repayAmount);



        // 1. Withdraw $

        // 2. Call callFunction(...)

        // 3. Deposit back $

        Actions.ActionArgs[] memory operations = new Actions.ActionArgs[](3);



        operations[0] = _getWithdrawAction(marketId, amount);

        operations[1] = _getCallAction(

            // Encode custom data for callFunction

            data

        );

        operations[2] = _getDepositAction(marketId, repayAmount);



        Account.Info[] memory accountInfos = new Account.Info[](1);

        accountInfos[0] = _getAccountInfo();



        solo.operate(accountInfos, operations);



        emit Leverage(amountDesired, amount, deficit, SOLO);



        return amount;

     }



    //returns our current collateralisation ratio. Should be compared with collateralTarget

     function storedCollateralisation() public view returns (uint256 collat){

          ( uint256 lend, uint256 borrow) = getCurrentPosition();

        if(lend == 0){

            return 0;

        }

         collat = uint(1e18).mul(borrow).div(lend);

     }



    //DyDx calls this function after doing flash loan

    function callFunction(

        address sender,

        Account.Info memory account,

        bytes memory data

    ) public override {

        

        (bool deficit, uint256 amount, uint repayAmount) = abi.decode(data,(bool, uint256, uint256));



        _loanLogic(deficit, amount, repayAmount);

    }



    function doAaveFlashLoan (

        bool deficit,

        uint256 _flashBackUpAmount

    )   public returns (uint256 amount)

    {

        //we do not want to do aave flash loans for leveraging up. Fee could put us into liquidation

        if(!deficit){

            return _flashBackUpAmount;

        }



        ILendingPool lendingPool = ILendingPool(addressesProvider.getLendingPool());



        uint256 availableLiquidity = want.balanceOf(address(0x3dfd23A6c5E8BbcFc9581d2E864a68feb6a076d3));



        if(availableLiquidity < _flashBackUpAmount) {

            amount = availableLiquidity;

        }else{

            amount = _flashBackUpAmount;

        }

        

        require(amount <= _flashBackUpAmount); // dev: "incorrect amount"



        bytes memory data = abi.encode(deficit, amount);

       

        lendingPool.flashLoan(

                        address(this), 

                        address(want), 

                        amount, 

                        data);



        emit Leverage(_flashBackUpAmount, amount, deficit, AAVE_LENDING);



    }



    //Aave calls this function after doing flash loan

    function executeOperation(

        address _reserve,

        uint256 _amount,

        uint256 _fee,

        bytes calldata _params

    )

        external

        override

    {

        (bool deficit, uint256 amount) = abi.decode(_params,(bool, uint256));



        _loanLogic(deficit, amount, amount.add(_fee));



        // return the flash loan plus Aave's flash loan fee back to the lending pool

        uint totalDebt = _amount.add(_fee);

        transferFundsBackToPoolInternal(_reserve, totalDebt);

    }



   

}

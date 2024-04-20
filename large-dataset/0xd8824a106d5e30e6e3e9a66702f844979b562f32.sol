// File: contracts/interfaces/IERC20.sol



pragma solidity 0.5.7;



/**

 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include

 * the optional functions; to access them see {ERC20Detailed}.

 */

contract IERC20 {

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

    function transfer(address recipient, uint256 amount)

        external

        returns (bool);



    /**

     * @dev Returns the remaining number of tokens that `spender` will be

     * allowed to spend on behalf of `owner` through {transferFrom}. This is

     * zero by default.

     *

     * This value changes when {approve} or {transferFrom} are called.

     */

    function allowance(address owner, address spender)

        external

        view

        returns (uint256);



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

    function transferFrom(address sender, address recipient, uint256 amount)

        external

        returns (bool);



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

    event Approval(

        address indexed owner,

        address indexed spender,

        uint256 value

    );

}



// File: contracts/interfaces/ComptrollerInterface.sol



pragma solidity ^0.5.7;



interface ComptrollerInterface {

    /**

     * @notice Marker function used for light validation when updating the comptroller of a market

     * @dev Implementations should simply return true.

     * @return true

     */

    function isComptroller() external view returns (bool);



    /*** Assets You Are In ***/



    function enterMarkets(address[] calldata cTokens)

        external

        returns (uint256[] memory);

    function exitMarket(address cToken) external returns (uint256);



    /*** Policy Hooks ***/



    function mintAllowed(address cToken, address minter, uint256 mintAmount)

        external

        returns (uint256);

    function mintVerify(

        address cToken,

        address minter,

        uint256 mintAmount,

        uint256 mintTokens

    ) external;



    function redeemAllowed(

        address cToken,

        address redeemer,

        uint256 redeemTokens

    ) external returns (uint256);

    function redeemVerify(

        address cToken,

        address redeemer,

        uint256 redeemAmount,

        uint256 redeemTokens

    ) external;



    function borrowAllowed(

        address cToken,

        address borrower,

        uint256 borrowAmount

    ) external returns (uint256);

    function borrowVerify(

        address cToken,

        address borrower,

        uint256 borrowAmount

    ) external;



    function repayBorrowAllowed(

        address cToken,

        address payer,

        address borrower,

        uint256 repayAmount

    ) external returns (uint256);

    function repayBorrowVerify(

        address cToken,

        address payer,

        address borrower,

        uint256 repayAmount,

        uint256 borrowerIndex

    ) external;



    function liquidateBorrowAllowed(

        address cTokenBorrowed,

        address cTokenCollateral,

        address liquidator,

        address borrower,

        uint256 repayAmount

    ) external returns (uint256);

    function liquidateBorrowVerify(

        address cTokenBorrowed,

        address cTokenCollateral,

        address liquidator,

        address borrower,

        uint256 repayAmount,

        uint256 seizeTokens

    ) external;



    function seizeAllowed(

        address cTokenCollateral,

        address cTokenBorrowed,

        address liquidator,

        address borrower,

        uint256 seizeTokens

    ) external returns (uint256);

    function seizeVerify(

        address cTokenCollateral,

        address cTokenBorrowed,

        address liquidator,

        address borrower,

        uint256 seizeTokens

    ) external;



    function transferAllowed(

        address cToken,

        address src,

        address dst,

        uint256 transferTokens

    ) external returns (uint256);

    function transferVerify(

        address cToken,

        address src,

        address dst,

        uint256 transferTokens

    ) external;



    /*** Liquidity/Liquidation Calculations ***/



    function liquidateCalculateSeizeTokens(

        address cTokenBorrowed,

        address cTokenCollateral,

        uint256 repayAmount

    ) external view returns (uint256, uint256);

}



// File: contracts/interfaces/InterestRateModel.sol



pragma solidity ^0.5.7;



/**

  * @title Compound's InterestRateModel Interface

  * @author Compound

  */

interface InterestRateModel {

    /**

     * @notice Indicator that this is an InterestRateModel contract (for inspection)

     */

    function isInterestRateModel() external pure returns (bool);



    /**

      * @notice Calculates the current borrow interest rate per block

      * @param cash The total amount of cash the market has

      * @param borrows The total amount of borrows the market has outstanding

      * @param reserves The total amnount of reserves the market has

      * @return The borrow rate per block (as a percentage, and scaled by 1e18)

      */

    function getBorrowRate(uint256 cash, uint256 borrows, uint256 reserves)

        external

        view

        returns (uint256);



    /**

      * @notice Calculates the current supply interest rate per block

      * @param cash The total amount of cash the market has

      * @param borrows The total amount of borrows the market has outstanding

      * @param reserves The total amnount of reserves the market has

      * @param reserveFactorMantissa The current reserve factor the market has

      * @return The supply rate per block (as a percentage, and scaled by 1e18)

      */

    function getSupplyRate(

        uint256 cash,

        uint256 borrows,

        uint256 reserves,

        uint256 reserveFactorMantissa

    ) external view returns (uint256);



}



// File: contracts/interfaces/CTokenInterfaces.sol



pragma solidity ^0.5.7;







contract CTokenStorage {

    /**

     * @dev Guard variable for re-entrancy checks

     */

    bool internal _notEntered;



    /**

     * @notice EIP-20 token name for this token

     */

    string public name;



    /**

     * @notice EIP-20 token symbol for this token

     */

    string public symbol;



    /**

     * @notice EIP-20 token decimals for this token

     */

    uint8 public decimals;



    /**

     * @notice Maximum borrow rate that can ever be applied (.0005% / block)

     */



    uint256 internal constant borrowRateMaxMantissa = 0.0005e16;



    /**

     * @notice Maximum fraction of interest that can be set aside for reserves

     */

    uint256 internal constant reserveFactorMaxMantissa = 1e18;



    /**

     * @notice Administrator for this contract

     */

    address payable public admin;



    /**

     * @notice Pending administrator for this contract

     */

    address payable public pendingAdmin;



    /**

     * @notice Contract which oversees inter-cToken operations

     */

    ComptrollerInterface public comptroller;



    /**

     * @notice Model which tells what the current interest rate should be

     */

    InterestRateModel public interestRateModel;



    /**

     * @notice Initial exchange rate used when minting the first CTokens (used when totalSupply = 0)

     */

    uint256 internal initialExchangeRateMantissa;



    /**

     * @notice Fraction of interest currently set aside for reserves

     */

    uint256 public reserveFactorMantissa;



    /**

     * @notice Block number that interest was last accrued at

     */

    uint256 public accrualBlockNumber;



    /**

     * @notice Accumulator of the total earned interest rate since the opening of the market

     */

    uint256 public borrowIndex;



    /**

     * @notice Total amount of outstanding borrows of the underlying in this market

     */

    uint256 public totalBorrows;



    /**

     * @notice Total amount of reserves of the underlying held in this market

     */

    uint256 public totalReserves;



    /**

     * @notice Total number of tokens in circulation

     */

    uint256 public totalSupply;



    /**

     * @notice Official record of token balances for each account

     */

    mapping(address => uint256) internal accountTokens;



    /**

     * @notice Approved token transfer amounts on behalf of others

     */

    mapping(address => mapping(address => uint256)) internal transferAllowances;



    /**

     * @notice Container for borrow balance information

     * @member principal Total balance (with accrued interest), after applying the most recent balance-changing action

     * @member interestIndex Global borrowIndex as of the most recent balance-changing action

     */

    struct BorrowSnapshot {

        uint256 principal;

        uint256 interestIndex;

    }



    /**

     * @notice Mapping of account addresses to outstanding borrow balances

     */

    mapping(address => BorrowSnapshot) internal accountBorrows;

}



contract CTokenInterface is CTokenStorage {

    /**

     * @notice Indicator that this is a CToken contract (for inspection)

     */

    bool public constant isCToken = true;



    /*** Market Events ***/



    /**

     * @notice Event emitted when interest is accrued

     */

    event AccrueInterest(

        uint256 cashPrior,

        uint256 interestAccumulated,

        uint256 borrowIndex,

        uint256 totalBorrows

    );



    /**

     * @notice Event emitted when tokens are minted

     */

    event Mint(address minter, uint256 mintAmount, uint256 mintTokens);



    /**

     * @notice Event emitted when tokens are redeemed

     */

    event Redeem(address redeemer, uint256 redeemAmount, uint256 redeemTokens);



    /**

     * @notice Event emitted when underlying is borrowed

     */

    event Borrow(

        address borrower,

        uint256 borrowAmount,

        uint256 accountBorrows,

        uint256 totalBorrows

    );



    /**

     * @notice Event emitted when a borrow is repaid

     */

    event RepayBorrow(

        address payer,

        address borrower,

        uint256 repayAmount,

        uint256 accountBorrows,

        uint256 totalBorrows

    );



    /**

     * @notice Event emitted when a borrow is liquidated

     */

    event LiquidateBorrow(

        address liquidator,

        address borrower,

        uint256 repayAmount,

        address cTokenCollateral,

        uint256 seizeTokens

    );



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

     * @notice Event emitted when comptroller is changed

     */

    event NewComptroller(

        ComptrollerInterface oldComptroller,

        ComptrollerInterface newComptroller

    );



    /**

     * @notice Event emitted when interestRateModel is changed

     */

    event NewMarketInterestRateModel(

        InterestRateModel oldInterestRateModel,

        InterestRateModel newInterestRateModel

    );



    /**

     * @notice Event emitted when the reserve factor is changed

     */

    event NewReserveFactor(

        uint256 oldReserveFactorMantissa,

        uint256 newReserveFactorMantissa

    );



    /**

     * @notice Event emitted when the reserves are added

     */

    event ReservesAdded(

        address benefactor,

        uint256 addAmount,

        uint256 newTotalReserves

    );



    /**

     * @notice Event emitted when the reserves are reduced

     */

    event ReservesReduced(

        address admin,

        uint256 reduceAmount,

        uint256 newTotalReserves

    );



    /**

     * @notice EIP20 Transfer event

     */

    event Transfer(address indexed from, address indexed to, uint256 amount);



    /**

     * @notice EIP20 Approval event

     */

    event Approval(

        address indexed owner,

        address indexed spender,

        uint256 amount

    );



    /**

     * @notice Failure event

     */

    event Failure(uint256 error, uint256 info, uint256 detail);



    /*** User Interface ***/



    function transfer(address dst, uint256 amount) external returns (bool);

    function transferFrom(address src, address dst, uint256 amount)

        external

        returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);

    function allowance(address owner, address spender)

        external

        view

        returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function balanceOfUnderlying(address owner) external returns (uint256);

    function getAccountSnapshot(address account)

        external

        view

        returns (uint256, uint256, uint256, uint256);

    function borrowRatePerBlock() external view returns (uint256);

    function supplyRatePerBlock() external view returns (uint256);

    function totalBorrowsCurrent() external returns (uint256);

    function borrowBalanceCurrent(address account) external returns (uint256);

    function borrowBalanceStored(address account) public view returns (uint256);

    function exchangeRateCurrent() public returns (uint256);

    function exchangeRateStored() public view returns (uint256);

    function getCash() external view returns (uint256);

    function accrueInterest() public returns (uint256);

    function seize(address liquidator, address borrower, uint256 seizeTokens)

        external

        returns (uint256);



    function mint(uint256 mintAmount) external returns (uint256);

    function redeem(uint256 redeemTokens) external returns (uint256);

    function redeemUnderlying(uint256 redeemAmount) external returns (uint256);

    function borrow(uint256 borrowAmount) external returns (uint256);

    function repayBorrow(uint256 repayAmount) external returns (uint256);

    function repayBorrowBehalf(address borrower, uint256 repayAmount)

        external

        returns (uint256);

    function liquidateBorrow(

        address borrower,

        uint256 repayAmount,

        CTokenInterface cTokenCollateral

    ) external returns (uint256);

}



// File: contracts/utils/SafeMath.sol



pragma solidity 0.5.7;



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

     * - Subtraction cannot overflow.

     *

     * _Available since v2.4.0._

     */

    function sub(uint256 a, uint256 b, string memory errorMessage)

        internal

        pure

        returns (uint256)

    {

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

     * - The divisor cannot be zero.

     *

     * _Available since v2.4.0._

     */

    function div(uint256 a, uint256 b, string memory errorMessage)

        internal

        pure

        returns (uint256)

    {

        // Solidity only automatically asserts when dividing by 0

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

     * - The divisor cannot be zero.

     *

     * _Available since v2.4.0._

     */

    function mod(uint256 a, uint256 b, string memory errorMessage)

        internal

        pure

        returns (uint256)

    {

        require(b != 0, errorMessage);

        return a % b;

    }

}



// File: contracts/utils/Context.sol



pragma solidity 0.5.7;





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

contract Context {

    // Empty internal constructor, to prevent people from mistakenly deploying

    // an instance of this contract, which should be used via inheritance.

    constructor () internal {}

    // solhint-disable-previous-line no-empty-blocks



    function _msgSender() internal view returns (address payable) {

        return msg.sender;

    }



    function _msgData() internal view returns (bytes memory) {

        this;

        // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691

        return msg.data;

    }

}



// File: contracts/utils/Ownable.sol



pragma solidity 0.5.7;





/**

 * @dev Contract module which provides a basic access control mechanism, where

 * there is an account (an owner) that can be granted exclusive access to

 * specific functions.

 *

 * This module is used through inheritance. It will make available the modifier

 * `onlyOwner`, which can be applied to your functions to restrict their use to

 * the owner.

 */

contract Ownable is Context {

    address private _owner;



    event OwnershipTransferred(

        address indexed previousOwner,

        address indexed newOwner

    );



    /**

     * @dev Initializes the contract setting the deployer as the initial owner.

     */

    constructor() internal {

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

        require(isOwner(), "Ownable: caller is not the owner");

        _;

    }



    /**

     * @dev Returns true if the caller is the current owner.

     */

    function isOwner() public view returns (bool) {

        return _msgSender() == _owner;

    }



    /**

     * @dev Leaves the contract without owner. It will not be possible to call

     * `onlyOwner` functions anymore. Can only be called by the current owner.

     *

     * NOTE: Renouncing ownership will leave the contract without an owner,

     * thereby removing any functionality that is only available to the owner.

     */

    function renounceOwnership() public onlyOwner {

        emit OwnershipTransferred(_owner, address(0));

        _owner = address(0);

    }



    /**

     * @dev Transfers ownership of the contract to a new account (`newOwner`).

     * Can only be called by the current owner.

     */

    function transferOwnership(address newOwner) public onlyOwner {

        _transferOwnership(newOwner);

    }



    /**

     * @dev Transfers ownership of the contract to a new account (`newOwner`).

     */

    function _transferOwnership(address newOwner) internal {

        require(

            newOwner != address(0),

            "Ownable: new owner is the zero address"

        );

        emit OwnershipTransferred(_owner, newOwner);

        _owner = newOwner;

    }

}



// File: @openzeppelin/contracts/utils/ReentrancyGuard.sol



pragma solidity ^0.5.0;



/**

 * @dev Contract module that helps prevent reentrant calls to a function.

 *

 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier

 * available, which can be applied to functions to make sure there are no nested

 * (reentrant) calls to them.

 *

 * Note that because there is a single `nonReentrant` guard, functions marked as

 * `nonReentrant` may not call one another. This can be worked around by making

 * those functions `private`, and then adding `external` `nonReentrant` entry

 * points to them.

 *

 * TIP: If you would like to learn more about reentrancy and alternative ways

 * to protect against it, check out our blog post

 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].

 *

 * _Since v2.5.0:_ this module is now much more gas efficient, given net gas

 * metering changes introduced in the Istanbul hardfork.

 */

contract ReentrancyGuard {

    bool private _notEntered;



    constructor () internal {

        // Storing an initial non-zero value makes deployment a bit more

        // expensive, but in exchange the refund on every call to nonReentrant

        // will be lower in amount. Since refunds are capped to a percetange of

        // the total transaction's gas, it is best to keep them low in cases

        // like this one, to increase the likelihood of the full refund coming

        // into effect.

        _notEntered = true;

    }



    /**

     * @dev Prevents a contract from calling itself, directly or indirectly.

     * Calling a `nonReentrant` function from another `nonReentrant`

     * function is not supported. It is possible to prevent this from happening

     * by making the `nonReentrant` function external, and make it call a

     * `private` function that does the actual work.

     */

    modifier nonReentrant() {

        // On the first call to nonReentrant, _notEntered will be true

        require(_notEntered, "ReentrancyGuard: reentrant call");



        // Any calls to nonReentrant after this point will fail

        _notEntered = false;



        _;



        // By storing the original value once again, a refund is triggered (see

        // https://eips.ethereum.org/EIPS/eip-2200)

        _notEntered = true;

    }

}



// File: contracts/TALEVotingBonus.sol



pragma solidity 0.5.7;













/**

@notice contract for staking

 */

contract TALEVotingBonus is Ownable, ReentrancyGuard {

    using SafeMath for uint256;



    IERC20 public token;

    IERC20 public dai;

    CTokenInterface public cDai;



    // EVENTS

    event ContractInitialized(uint256 stakeTimeStart, uint256 stakeTimeStop);

    event Staked(address user, uint256 amountToken);

    event StakedDai(address user, uint256 amountToken);

    event TokensUnstaked(address voter, uint256 amountToken);

    event DaiUnstaked(address voter, uint256 amountToken);



    /**

    @notice Vote struct */

    struct Vote {

        uint256 tokenAmount;

        address voter;

        uint8 personalityVoted;

        uint256[] txsTimeToken;

        uint256[] stakesToken;

        // uint256 stakesCount;

        uint256 unstakedTimestamp;

        bool withdrawn;

    }



    struct VoteDai {

        uint256 tokenAmount;

        address voter;

        uint256 stakedTimestamp;

        uint256 unstakedTimestamp;

        bool withdrawn;

    }



    mapping(address => Vote) private votes; // mapping from voter to Vote struct



    mapping(address => VoteDai) private votesDai; // mapping from voter to VoteDai struct

    mapping(address => bool) public isDaiVoter;



    address[] public voters;

    mapping(uint8 => uint256) public stakesByPersonality;



    uint256 public totalStakesCount; // total count of stakes

    uint256 public totalStakedAmountToken;

    uint256 public totalDaiStaked;



    uint256 public stakeTimeStart;

    uint256 public stakeTimeStop;



    uint256 public minimumStakingAmountToken;



    uint256 public tokenRewardMultiplier;



    uint256 public minimumDAIStakingDays;

    uint256 public tokenInterestShare;

    uint256 public tokenPrice;



    bool public contractState;



    modifier onlyActive() {

        require(contractState == true, "contract is not active");

        _;

    }



    constructor(

        address _token,

        address _daiToken,

        address _cDai,

        uint256 _minStakingAmountToken,

        uint256 _tokenRewardMultiplier,

        uint256 _minimumDAIStakingDays,

        uint256 _tokenInterestShare,

        uint256 _tokenPrice

    ) public {

        token = IERC20(_token);

        dai = IERC20(_daiToken);

        cDai = CTokenInterface(_cDai);

        tokenRewardMultiplier = _tokenRewardMultiplier;

        setMinimumStakingAmountToken(_minStakingAmountToken);

        minimumDAIStakingDays = _minimumDAIStakingDays;

        tokenInterestShare = _tokenInterestShare;

        tokenPrice = _tokenPrice;

    }



    function init(uint256 startTime, uint256 stopTime) public onlyOwner {

        require(!contractState, "contract is already initialized");



        require(startTime > now, "start time cannot be set in the past");



        require(

            stopTime > startTime,

            "stop time should be greater than stop time"

        );



        stakeTimeStart = startTime;

        stakeTimeStop = stopTime;



        contractState = true;



        emit ContractInitialized(stakeTimeStart, stakeTimeStop);

    }



    function stake(uint8 personality, uint256 tokensAmount) public {

        require(

            contractState == true &&

                now <= stakeTimeStop &&

                now >= stakeTimeStart,

            "cannot stake"

        );



        require(

            personality == 1 || personality == 2,

            "personality can be either 1 or 2"

        );



        Vote storage _vote = votes[msg.sender];



        if (_vote.tokenAmount > 0) {

            require(

                _vote.personalityVoted == personality,

                "You cannot raise stake on a different personality"

            );

        }



        if (_vote.tokenAmount == 0) {

            addVoter(msg.sender);

            // create a new stake entity

            uint256[] memory txs = new uint256[](0);

            uint256[] memory stx = new uint256[](0);



            Vote memory newVote = Vote(0, msg.sender, 0, txs, stx, 0, false);



            votes[msg.sender] = newVote;

            votes[msg.sender].personalityVoted = personality;

        }



        require(

            tokensAmount >= minimumStakingAmountToken,

            "tokens must be greater than or equal to minimumStakingAmount"

        );



        _vote.tokenAmount = _vote.tokenAmount.add(tokensAmount);

        _vote.stakesToken.push(tokensAmount);

        _vote.txsTimeToken.push(now);

        stakesByPersonality[personality] = stakesByPersonality[personality].add(

            tokensAmount

        );



        bool success = token.transferFrom(

            msg.sender,

            address(this),

            tokensAmount

        );



        require(success, "failed in transferFrom of stakeTokens");



        totalStakedAmountToken = totalStakedAmountToken.add(tokensAmount);



        emit Staked(msg.sender, tokensAmount);



    }

    /**

        @notice Stake DAI into compound protocol

        @dev user needs to approve the DAI tokens contract first

     */

    function stakeDAI(uint256 daiAmount) external onlyActive {

        VoteDai storage _vote = votesDai[msg.sender];



        if (_vote.tokenAmount == 0) {

            isDaiVoter[msg.sender] = true;

            votesDai[msg.sender] = VoteDai(0, msg.sender, 0, 0, false);

        }



        require(

            daiAmount >= minimumStakingAmountToken,

            "dai must be greater than or equal to minimumStakingAmount"

        );



        _vote.tokenAmount = _vote.tokenAmount.add(daiAmount);

        _vote.stakedTimestamp = now;



        // Transfer tokens from user

        require(

            dai.transferFrom(msg.sender, address(this), daiAmount),

            "failed in transferFrom of dai Tokens"

        );



        // Approve cDai to transfer DAI tokens

        require(

            dai.approve(address(cDai), daiAmount),

            "failed in approve of dai Tokens"

        );



        // Supply to Compound, expect no errors

        assert(cDai.mint(daiAmount) == 0);



        totalDaiStaked = totalDaiStaked.add(daiAmount);



        emit StakedDai(msg.sender, daiAmount);



    }



    function sendTokens(address[] memory _addresses, uint256[] memory _amounts)

        public

        onlyOwner

        returns (bool)

    {

        require(

            _addresses.length == _amounts.length,

            "addresses and amounts do not match"

        );



        for (uint256 i = 0; i < _addresses.length; i++) {

            require(

                token.transfer(_addresses[i], _amounts[i]),

                "token transfer failed"

            );

        }



        return true;

    }



    /**

    @notice this is function is called by the voter to unstake tokens

     */

    function unstake() public {

        require(contractState == true && now > stakeTimeStop, "cannot unstake");



        Vote storage _vote = votes[msg.sender];



        require(_vote.txsTimeToken.length > 0, "No stake found by the user");



        require(!_vote.withdrawn, "Stake is already withdrawn");



        uint8 winnerPersonality = stakesByPersonality[1] >

            stakesByPersonality[2]

            ? 1

            : 2;



        uint256 withdrawAmountToken;



        if (_vote.personalityVoted == winnerPersonality) {

            withdrawAmountToken = _vote.tokenAmount.mul(tokenRewardMultiplier);

        } else {

            withdrawAmountToken = _vote.tokenAmount;

        }



        _vote.withdrawn = true;

        _vote.unstakedTimestamp = now;



        bool success = token.transfer(msg.sender, withdrawAmountToken);



        require(success, "transfer failed in withdraw");



        emit TokensUnstaked(msg.sender, withdrawAmountToken);

    }



    function calculateInterest(address user) public view returns (uint256) {

        VoteDai storage _vote = votesDai[user];

        uint256 amountToRedeem = _vote.tokenAmount;

        uint256 daysPassed = now.sub(_vote.stakedTimestamp).div(1 days);



        if (daysPassed < minimumDAIStakingDays) return 0;



        uint256 tokenInterest = amountToRedeem

            .mul(getDailyAPY())

            .mul(daysPassed)

            .mul(tokenInterestShare)

            .div(tokenPrice)

            .div(100);



        return tokenInterest;



    }



    /**

        @notice Unstake Dai tokens from contract

        @dev this is function is called by the voter to unstake DAI tokens

     */

    function unstakeDAI() external nonReentrant onlyActive {

        VoteDai storage _vote = votesDai[msg.sender];

        uint256 daysPassed = now.sub(_vote.stakedTimestamp).div(1 days);



        require(

            daysPassed >= minimumDAIStakingDays,

            "cannot unstake, min days not met"

        );



        require(!_vote.withdrawn, "Stake is already withdrawn");



        uint256 amountToRedeem = _vote.tokenAmount;



        _vote.tokenAmount = 0;

        _vote.withdrawn = true;

        _vote.unstakedTimestamp = now;



        // Redeem DAI from compound and send back to user

        require(

            cDai.redeemUnderlying(amountToRedeem) == 0,

            "Cannot redeem from compound"

        );

        require(

            dai.transfer(msg.sender, amountToRedeem),

            "transfer failed in withdraw"

        );



        // Calculate interest and send it to user

        uint256 tokenAmount = calculateInterest(msg.sender);

        require(

            token.transfer(msg.sender, tokenAmount),

            "transfer failed in transfer of interes"

        );



        emit TokensUnstaked(msg.sender, amountToRedeem);

    }



    function getDailyAPY() public view returns (uint256) {

        // TODO: check calculation with compound discord team

        return cDai.supplyRatePerBlock().mul(4).mul(60).mul(24);

    }



    function getStakeInfo(address _voter)

        public

        view

        returns (

            uint256 amountToken,

            uint8 personality,

            uint256[] memory txsTimeToken,

            uint256[] memory stakesToken,

            uint256 unstakedTimestamp,

            bool withdrawn

        )

    {

        Vote memory vote = votes[_voter];



        amountToken = vote.tokenAmount;

        personality = vote.personalityVoted;

        withdrawn = vote.withdrawn;

        unstakedTimestamp = vote.unstakedTimestamp;

        txsTimeToken = vote.txsTimeToken;

        stakesToken = vote.stakesToken;

    }



    function getDaiStakeInfo(address _voter)

        public

        view

        returns (

            uint256 amountToken,

            uint256 stakedTimeStamp,

            uint256 unstakedTimestamp,

            bool withdrawn

        )

    {

        VoteDai memory vote = votesDai[_voter];



        amountToken = vote.tokenAmount;

        withdrawn = vote.withdrawn;

        unstakedTimestamp = vote.unstakedTimestamp;

        stakedTimeStamp = vote.stakedTimestamp;

    }



    function getAllVoters() public view returns (address[] memory allVoters) {

        allVoters = voters;

    }



    function getTokenStakeAmountByPersonalityId(uint256 personalityId)

        public

        view

        returns (uint256 amount)

    {

        for (uint256 i = 0; i < voters.length; i++) {

            Vote memory v = votes[voters[i]];

            if (v.personalityVoted == personalityId) {

                amount = amount.add(v.tokenAmount);

            }

        }

    }



    function isContractActive() public view returns (bool) {

        return now >= stakeTimeStart && now <= stakeTimeStop;

    }



    function isVoter(address _address) internal view returns (bool, uint256) {

        for (uint256 i = 0; i < voters.length; i++) {

            if (_address == voters[i]) {

                return (true, i);

            }

        }

        return (false, 0);

    }



    function addVoter(address _voter) internal {

        (bool _isVoter, ) = isVoter(_voter);

        if (!_isVoter) {

            voters.push(_voter);



        }



    }



    // OWNER SETTINGS



    function withdrawTokens() external onlyOwner {

        uint256 balance = token.balanceOf(address(this));

        require(

            token.transfer(owner(), balance),

            "Error withdrawing tokens from contract"

        );

    }



    function setMinimumStakingAmountToken(uint256 _value) public onlyOwner {

        minimumStakingAmountToken = _value;

    }



    function setTokenRewardMultiplier(uint256 _value) public onlyOwner {

        tokenRewardMultiplier = _value;

    }



    function setMinimumDAIStakingDays(uint256 _value) public onlyOwner {

        minimumDAIStakingDays = _value;

    }



    function setTokenInterestShare(uint256 _value) public onlyOwner {

        tokenInterestShare = _value;

    }



    function setTokenPrice(uint256 _value) public onlyOwner {

        tokenPrice = _value;

    }



    function setTokenAddress(uint256 _token) public onlyOwner {

        token = IERC20(_token);

    }

}

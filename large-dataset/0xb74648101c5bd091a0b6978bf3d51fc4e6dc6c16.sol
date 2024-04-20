pragma solidity ^0.5.12;



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

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

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

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b != 0, errorMessage);

        return a % b;

    }

}



/**

 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include

 * the optional functions; to access them see {ERC20Detailed}.

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



/**

 * @title PToken Interface

 */

interface IPToken {

    /* solhint-disable func-order */

    //Standart ERC20

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);



    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);



    //Mintable & Burnable

    function mint(address account, uint256 amount) external returns (bool);

    function burn(uint256 amount) external;

    function burnFrom(address account, uint256 amount) external;



    //Distributions

    function distribute(uint256 amount) external;

    function claimDistributions(address account) external returns(uint256);

    function claimDistributions(address account, uint256 lastDistribution) external returns(uint256);

    function claimDistributions(address[] calldata accounts) external;

    function claimDistributions(address[] calldata accounts, uint256 toDistribution) external;

    function fullBalanceOf(address account) external view returns(uint256);

    function calculateDistributedAmount(uint256 startDistribution, uint256 nextDistribution, uint256 initialBalance) external view returns(uint256);

    function nextDistribution() external view returns(uint256);

    function distributionTotalSupply() external view returns(uint256);

    function distributionBalanceOf(address account) external view returns(uint256);

}



interface IAccessModule {

    enum Operation {

        // LiquidityModule

        Deposit,

        Withdraw,

        // LoanModule

        CreateDebtProposal,

        AddPledge,

        WithdrawPledge,

        CancelDebtProposal,

        ExecuteDebtProposal,

        Repay,

        ExecuteDebtDefault,

        WithdrawUnlockedPledge

    }

    

    /**

     * @notice Check if operation is allowed

     * @param operation Requested operation

     * @param sender Sender of transaction

     */

    function isOperationAllowed(Operation operation, address sender) external view returns(bool);

}



/**

 * @title Funds Module Interface

 * @dev Funds module is responsible for token transfers, provides info about current liquidity/debts and pool token price.

 */

interface IFundsModule {

    event Status(uint256 lBalance, uint256 lDebts, uint256 lProposals, uint256 pEnterPrice, uint256 pExitPrice);



    /**

     * @notice Deposit liquid tokens to the pool

     * @param from Address of the user, who sends tokens. Should have enough allowance.

     * @param amount Amount of tokens to deposit

     */

    function depositLTokens(address from, uint256 amount) external;

    /**

     * @notice Withdraw liquid tokens from the pool

     * @param to Address of the user, who sends tokens. Should have enough allowance.

     * @param amount Amount of tokens to deposit

     */

    function withdrawLTokens(address to, uint256 amount) external;



    /**

     * @notice deposit liquid tokens received as interest and distribute PTK

     * @param amount Amount of liquid tokens to deposit

     * @return Amount of PTK distributed

     */

    function distributeLInterest(uint256 amount) external returns(uint256);



    /**

     * @notice Withdraw liquid tokens from the pool

     * @param to Address of the user, who sends tokens. Should have enough allowance.

     * @param amount Amount of tokens to deposit

     * @param poolFee Pool fee will be sent to pool owner

     */

    function withdrawLTokens(address to, uint256 amount, uint256 poolFee) external;



    /**

     * @notice Deposit pool tokens to the pool

     * @param from Address of the user, who sends tokens. Should have enough allowance.

     * @param amount Amount of tokens to deposit

     */

    function depositPTokens(address from, uint256 amount) external;



    /**

     * @notice Withdraw pool tokens from the pool

     * @param to Address of the user, who sends tokens. Should have enough allowance.

     * @param amount Amount of tokens to deposit

     */

    function withdrawPTokens(address to, uint256 amount) external;



    /**

     * @notice Mint new PTokens

     * @param to Address of the user, who sends tokens.

     * @param amount Amount of tokens to mint

     */

    function mintPTokens(address to, uint256 amount) external;



    /**

     * @notice Mint new PTokens and distribute the to other PToken holders

     * @param amount Amount of tokens to mint

     */

    function distributePTokens(uint256 amount) external;



    /**

     * @notice Burn pool tokens

     * @param from Address of the user, whos tokens we burning. Should have enough allowance.

     * @param amount Amount of tokens to burn

     */

    function burnPTokens(address from, uint256 amount) external;



    function lockPTokens(address[] calldata from, uint256[] calldata amount) external;



    function mintAndLockPTokens(uint256 amount) external;



    function unlockAndWithdrawPTokens(address to, uint256 amount) external;



    function burnLockedPTokens(uint256 amount) external;



    function emitStatusEvent() external;



    /**

     * @notice Calculates how many pTokens should be given to user for increasing liquidity

     * @param lAmount Amount of liquid tokens which will be put into the pool

     * @return Amount of pToken which should be sent to sender

     */

    function calculatePoolEnter(uint256 lAmount) external view returns(uint256);



    /**

     * @notice Calculates how many pTokens should be taken from user for decreasing liquidity

     * @param lAmount Amount of liquid tokens which will be removed from the pool

     * @return Amount of pToken which should be taken from sender

     */

    function calculatePoolExit(uint256 lAmount) external view returns(uint256);



    /**

     * @notice Calculates how many liquid tokens should be removed from pool when decreasing liquidity

     * @param pAmount Amount of pToken which should be taken from sender

     * @return Amount of liquid tokens which will be removed from the pool: total, part for sender, part for pool

     */

    function calculatePoolExitInverse(uint256 pAmount) external view returns(uint256, uint256, uint256);



    /**

     * @notice Calculates how many pTokens should be taken from user for decreasing liquidity

     * @param lAmount Amount of liquid tokens which will be removed from the pool

     * @return Amount of pToken which should be taken from sender

     */

    function calculatePoolExitWithFee(uint256 lAmount) external view returns(uint256);



    /**

     * @notice Current pool liquidity

     * @return available liquidity

     */

    function lBalance() external view returns(uint256);



    /**

     * @return Amount of pTokens locked in FundsModule by account

     */

    function pBalanceOf(address account) external view returns(uint256);



}



/**

 * @title Liquidity Module Interface

 * @dev Liquidity module is responsible for deposits, withdrawals and works with Funds module.

 */

interface ILiquidityModule {



    event Deposit(address indexed sender, uint256 lAmount, uint256 pAmount);

    event Withdraw(address indexed sender, uint256 lAmountTotal, uint256 lAmountUser, uint256 pAmount);



    /*

     * @notice Deposit amount of lToken and mint pTokens

     * @param lAmount Amount of liquid tokens to invest

     * @param pAmountMin Minimal amout of pTokens suitable for sender

     */ 

    function deposit(uint256 lAmount, uint256 pAmountMin) external;



    /**

     * @notice Withdraw amount of lToken and burn pTokens

     * @param pAmount Amount of pTokens to send

     * @param lAmountMin Minimal amount of liquid tokens to withdraw

     */

    function withdraw(uint256 pAmount, uint256 lAmountMin) external;



    /**

     * @notice Simulate withdrawal for loan repay with PTK

     * @param pAmount Amount of pTokens to use

     */

    function withdrawForRepay(address borrower, uint256 pAmount) external;

}



/**

 * @title Initializable

 *

 * @dev Helper contract to support initializer functions. To use it, replace

 * the constructor with a function that has the `initializer` modifier.

 * WARNING: Unlike constructors, initializer functions must be manually

 * invoked. This applies both to deploying an Initializable contract, as well

 * as extending an Initializable contract via inheritance.

 * WARNING: When used with inheritance, manual care must be taken to not invoke

 * a parent initializer twice, or ensure that all initializers are idempotent,

 * because this is not dealt with automatically as with constructors.

 */

contract Initializable {



  /**

   * @dev Indicates that the contract has been initialized.

   */

  bool private initialized;



  /**

   * @dev Indicates that the contract is in the process of being initialized.

   */

  bool private initializing;



  /**

   * @dev Modifier to use in the initializer function of a contract.

   */

  modifier initializer() {

    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");



    bool isTopLevelCall = !initializing;

    if (isTopLevelCall) {

      initializing = true;

      initialized = true;

    }



    _;



    if (isTopLevelCall) {

      initializing = false;

    }

  }



  /// @dev Returns true if and only if the function is running in the constructor

  function isConstructor() private view returns (bool) {

    // extcodesize checks the size of the code stored in an address, and

    // address returns the current address. Since the code is still not

    // deployed when running a constructor, any checks on its code size will

    // yield zero, making it an effective way to detect if a contract is

    // under construction or not.

    address self = address(this);

    uint256 cs;

    assembly { cs := extcodesize(self) }

    return cs == 0;

  }



  // Reserved storage space to allow for layout changes in the future.

  uint256[50] private ______gap;

}



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

contract Context is Initializable {

    // Empty internal constructor, to prevent people from mistakenly deploying

    // an instance of this contract, which should be used via inheritance.

    constructor () internal { }

    // solhint-disable-previous-line no-empty-blocks



    function _msgSender() internal view returns (address payable) {

        return msg.sender;

    }



    function _msgData() internal view returns (bytes memory) {

        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691

        return msg.data;

    }

}



/**

 * @dev Contract module which provides a basic access control mechanism, where

 * there is an account (an owner) that can be granted exclusive access to

 * specific functions.

 *

 * This module is used through inheritance. It will make available the modifier

 * `onlyOwner`, which can be aplied to your functions to restrict their use to

 * the owner.

 */

contract Ownable is Initializable, Context {

    address private _owner;



    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);



    /**

     * @dev Initializes the contract setting the deployer as the initial owner.

     */

    function initialize(address sender) public initializer {

        _owner = sender;

        emit OwnershipTransferred(address(0), _owner);

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

     * > Note: Renouncing ownership will leave the contract without an owner,

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

        require(newOwner != address(0), "Ownable: new owner is the zero address");

        emit OwnershipTransferred(_owner, newOwner);

        _owner = newOwner;

    }



    uint256[50] private ______gap;

}



/**

 * Base contract for all modules

 */

contract Base is Initializable, Context, Ownable {

    address constant  ZERO_ADDRESS = address(0);



    function initialize() public initializer {

        Ownable.initialize(_msgSender());

    }



}



/**

 * @dev List of module names

 */

contract ModuleNames {

    // Pool Modules

    string internal constant MODULE_ACCESS            = "access";

    string internal constant MODULE_PTOKEN            = "ptoken";

    string internal constant MODULE_DEFI              = "defi";

    string internal constant MODULE_CURVE             = "curve";

    string internal constant MODULE_FUNDS             = "funds";

    string internal constant MODULE_LIQUIDITY         = "liquidity";

    string internal constant MODULE_LOAN              = "loan";

    string internal constant MODULE_LOAN_LIMTS        = "loan_limits";

    string internal constant MODULE_LOAN_PROPOSALS    = "loan_proposals";

    string internal constant MODULE_FLASHLOANS        = "flashloans";

    string internal constant MODULE_ARBITRAGE         = "arbitrage";



    // External Modules (used to store addresses of external contracts)

    string internal constant MODULE_LTOKEN            = "ltoken";

    string internal constant MODULE_CDAI              = "cdai";

    string internal constant MODULE_RAY               = "ray";

}



/**

 * Base contract for all modules

 */

contract Module is Base, ModuleNames {

    event PoolAddressChanged(address newPool);

    address public pool;



    function initialize(address _pool) public initializer {

        Base.initialize();

        setPool(_pool);

    }



    function setPool(address _pool) public onlyOwner {

        require(_pool != ZERO_ADDRESS, "Module: pool address can't be zero");

        pool = _pool;

        emit PoolAddressChanged(_pool);        

    }



    function getModuleAddress(string memory module) public view returns(address){

        require(pool != ZERO_ADDRESS, "Module: no pool");

        (bool success, bytes memory result) = pool.staticcall(abi.encodeWithSignature("get(string)", module));

        

        //Forward error from Pool contract

        if (!success) assembly {

            revert(add(result, 32), result)

        }



        address moduleAddress = abi.decode(result, (address));

        if (moduleAddress == ZERO_ADDRESS) {

            string memory error = string(abi.encodePacked("Module: requested module not found: ", module));

            revert(error);

        }

        return moduleAddress;

    }



}



contract LiquidityModule is Module, ILiquidityModule {

    struct LiquidityLimits {

        uint256 lDepositMin;     // Minimal amount of liquid tokens for deposit

        uint256 pWithdrawMin;    // Minimal amount of pTokens for withdraw

    }



    LiquidityLimits public limits;



    modifier operationAllowed(IAccessModule.Operation operation) {

        IAccessModule am = IAccessModule(getModuleAddress(MODULE_ACCESS));

        require(am.isOperationAllowed(operation, _msgSender()), "LiquidityModule: operation not allowed");

        _;

    }



    function initialize(address _pool) public initializer {

        Module.initialize(_pool);

        setLimits(10*10**18, 0);    //10 DAI minimal enter

    }



    /**

     * @notice Deposit amount of lToken and mint pTokens

     * @param lAmount Amount of liquid tokens to invest

     * @param pAmountMin Minimal amout of pTokens suitable for sender

     */ 

    function deposit(uint256 lAmount, uint256 pAmountMin) public operationAllowed(IAccessModule.Operation.Deposit) {

        require(lAmount > 0, "LiquidityModule: lAmount should not be 0");

        require(lAmount >= limits.lDepositMin, "LiquidityModule: amount should be >= lDepositMin");

        uint pAmount = fundsModule().calculatePoolEnter(lAmount);

        require(pAmount >= pAmountMin, "LiquidityModule: Minimal amount is too high");

        fundsModule().depositLTokens(_msgSender(), lAmount);

        fundsModule().mintPTokens(_msgSender(), pAmount);

        emit Deposit(_msgSender(), lAmount, pAmount);

    }



    /**

     * @notice Withdraw amount of lToken and burn pTokens

     * @dev This operation also repays all interest on all debts

     * @param pAmount Amount of pTokens to send (this amount does not include pTokens used to pay interest)

     * @param lAmountMin Minimal amount of liquid tokens to withdraw

     */

    function withdraw(uint256 pAmount, uint256 lAmountMin) public operationAllowed(IAccessModule.Operation.Withdraw) {

        require(pAmount > 0, "LiquidityModule: pAmount should not be 0");

        require(pAmount >= limits.pWithdrawMin, "LiquidityModule: amount should be >= pWithdrawMin");

        (uint256 lAmountT, uint256 lAmountU, uint256 lAmountP) = fundsModule().calculatePoolExitInverse(pAmount);

        require(lAmountU >= lAmountMin, "LiquidityModule: Minimal amount is too high");

        uint256 availableLiquidity = fundsModule().lBalance();

        require(lAmountT <= availableLiquidity, "LiquidityModule: not enough liquidity");

        fundsModule().burnPTokens(_msgSender(), pAmount);

        fundsModule().withdrawLTokens(_msgSender(), lAmountU, lAmountP);

        emit Withdraw(_msgSender(), lAmountT, lAmountU, pAmount);

    }



    /**

     * @notice Withdraw amount of lToken and burn pTokens

     * @param borrower Address of the borrower

     * @param pAmount Amount of pTokens to send

     */

    function withdrawForRepay(address borrower, uint256 pAmount) public {

        require(_msgSender() == getModuleAddress(MODULE_LOAN), "LiquidityModule: call only allowed from LoanModule");

        require(pAmount > 0, "LiquidityModule: pAmount should not be 0");

        //require(pAmount >= limits.pWithdrawMin, "LiquidityModule: amount should be >= pWithdrawMin"); //Limit disabled, because this is actually repay

        (uint256 lAmountT, uint256 lAmountU, uint256 lAmountP) = fundsModule().calculatePoolExitInverse(pAmount);

        uint256 availableLiquidity = fundsModule().lBalance();

        require(lAmountP <= availableLiquidity, "LiquidityModule: not enough liquidity");

        fundsModule().burnPTokens(borrower, pAmount);           //We just burn pTokens, withous sending lTokens to _msgSender()

        fundsModule().withdrawLTokens(borrower, 0, lAmountP);   //This call is required to send pool fee

        emit Withdraw(borrower, lAmountT, lAmountU, pAmount);

    }



    function setLimits(uint256 lDepositMin, uint256 pWithdrawMin) public onlyOwner {

        limits.lDepositMin = lDepositMin;

        limits.pWithdrawMin = pWithdrawMin;

    }



    function fundsModule() internal view returns(IFundsModule) {

        return IFundsModule(getModuleAddress(MODULE_FUNDS));

    }

}



/**

 * @notice PensionFundLiquidityModule is a modification of standart

 * LiquidityModule which changes withdrawal rules according to pension plan.

 * Pension plan has a specific duration, and partial withdrawals allowed only 

 * after end of its deposit period.

 * Before end of this period user only allowed to cancel his plan with a penalty, 

 * proportional to the time till end of this period.

 * After the end of deposit period plan user is allowed to withraw during withdrawal

 * period, proportionally to the time till end of this period.

 */

contract PensionFundModule is LiquidityModule {

    using SafeMath for uint256;



    event PlanCreated(address indexed beneficiary, uint256 depostiPeriodEnd, uint256 withdrawPeriodEnd);

    event PlanClosed(address indexed beneficiary, uint256 pRefund, uint256 pPenalty);

    event PlanSettingsChanged(uint256 depositPeriodDuration, uint256 minPenalty, uint256 maxPenalty, uint256 withdrawPeriodDuration, uint256 initalWithdrawAllowance);



    uint256 public constant MULTIPLIER = 1e18;

    uint256 private constant ANNUAL_SECONDS = 365*24*60*60+(24*60*60/4);  // Seconds in a year + 1/4 day to compensate leap years



    struct PensionPlanSettings {

        uint256 depositPeriodDuration;      // Duration of deposit period

        uint256 minPenalty;                 // Min penalty (if withdraw full amount just before deposit period ends or during withdraw period)

        uint256 maxPenalty;                 // Max penalty (if withdraw rigt after deposit). Calculated as pBalance*maxPenalty/MULTIPLIER

        uint256 withdrawPeriodDuration;     // Duration of withdraw period

        uint256 initalWithdrawAllowance;    // How much user can withdraw right after deposit period ends. Calculated as pBalance*initalWithdrawAllowance/MULTIPLIER

    }



    struct PensionPlan {

        uint256 created;    // Timestamp of first deposit, which created this plan

        uint256 pWithdrawn; // pTokens already withdawn from this plan

    }



    PensionPlanSettings public planSettings;        // Settings of all pension plans



    mapping(address => PensionPlan) public plans;   // Attributes of pension plan per user



    function initialize(address _pool) public initializer {

        LiquidityModule.initialize(_pool);

        setPlanSettings(

            30*ANNUAL_SECONDS,

            10*MULTIPLIER/100,

            90*MULTIPLIER/100,

            20*ANNUAL_SECONDS,

            0*MULTIPLIER/100

        );

    }



    function setPlanSettings(

        uint256 depositPeriodDuration, 

        uint256 minPenalty, 

        uint256 maxPenalty, 

        uint256 withdrawPeriodDuration,

        uint256 initalWithdrawAllowance

    ) public onlyOwner {

        planSettings = PensionPlanSettings({

            depositPeriodDuration: depositPeriodDuration, 

            minPenalty: minPenalty, 

            maxPenalty: maxPenalty, 

            withdrawPeriodDuration: withdrawPeriodDuration,

            initalWithdrawAllowance: initalWithdrawAllowance

        });

        emit PlanSettingsChanged(depositPeriodDuration, minPenalty, maxPenalty, withdrawPeriodDuration, initalWithdrawAllowance);

    }



    /**

     * @notice Deposit amount of lToken and mint pTokens

     * @param lAmount Amount of liquid tokens to invest

     * @param pAmountMin Minimal amout of pTokens suitable for sender

     */ 

    function deposit(uint256 lAmount, uint256 pAmountMin) public /*operationAllowed(IAccessModule.Operation.Deposit)*/ {

        address user = _msgSender();

        PensionPlan storage plan  = plans[user];

        bool creation;

        if (plan.created == 0){

            //create new plan

            plan.created = now;

            creation = true;

        }

        uint256 depositPeriodEnd = plan.created.add(planSettings.depositPeriodDuration);

        uint256 planEnd = depositPeriodEnd.add(planSettings.withdrawPeriodDuration);

        require(planEnd > now, "PensionFundLiquidityModule: plan ended");

        super.deposit(lAmount, pAmountMin);

        if (creation){

            emit PlanCreated(user, depositPeriodEnd, planEnd);

        }

    }



    /**

     * @notice Withdraw amount of lToken and burn pTokens

     * @param pAmount Amount of pTokens to send (this amount does not include pTokens used to pay interest)

     * @param lAmountMin Minimal amount of liquid tokens to withdraw

     */

    function withdraw(uint256 pAmount, uint256 lAmountMin) public /*operationAllowed(IAccessModule.Operation.Withdraw)*/ {

        address user = _msgSender();

        PensionPlan storage plan  = plans[user];

        require(plan.created != 0, "PensionFundLiquidityModule: plan not found");

        uint256 pBalance = pToken().distributionBalanceOf(user);

        uint256 allownce = _withdrawLimit(plan, pBalance);

        require(allownce >= pAmount, "PensionFundLiquidityModule: not enough withdraw allowance");

        plan.pWithdrawn = plan.pWithdrawn.add(pAmount);

        super.withdraw(pAmount, lAmountMin);

        

        //Additional balance request required because of possible distributions which could be claimed during withdraw

        uint256 pLeft = pToken().distributionBalanceOf(user); 

        if (pLeft == 0) {

            delete plans[user];   //Close plan, so that user can create a new one

            emit PlanClosed(user, 0, 0);

        }

    }



    /**

     * @notice Close plan withdrawing all available lTokens

     * @param lAmountMin Minimal amount of liquid tokens to withdraw

     */

    function closePlan(uint256 lAmountMin) public operationAllowed(IAccessModule.Operation.Withdraw) {

        address user = _msgSender();

        PensionPlan storage plan  = plans[user];

        require(plan.created != 0, "PensionFundLiquidityModule: plan not found");

        IPToken pToken = pToken();

        pToken.claimDistributions(user);    // We need to claim distributions to know full user balance

        uint256 pBalance = pToken.distributionBalanceOf(user);

        uint256 pWithdrawableBalance = pToken.balanceOf(user);

        require(pBalance == pWithdrawableBalance, "PensionFundLiquidityModule: has locked PTK");   //Some funds may be locked in proposals

        uint256 pPenalty = _pPenalty(plan, pBalance);

        uint256 pRefund = pBalance.sub(pPenalty);

        

        if (pRefund > 0) {

            super.withdraw(pRefund, lAmountMin);

        } else {

            require(lAmountMin == 0, "PensionFundLiquidityModule: lAmountMin prevents zero refund");

        }

        if (pPenalty > 0) {

            IFundsModule fundsModule = fundsModule();

            fundsModule.burnPTokens(user, pPenalty);

            fundsModule.distributePTokens(pPenalty);

        }



        // Check balance again to prevent possible actions during lToken transfer

        pBalance = pToken.distributionBalanceOf(user);

        require(pBalance == 0, "PensionFundLiquidityModule: not zero balance after full withdraw");

        delete plans[user]; 

        emit PlanClosed(user, pRefund, pPenalty);

    }



    function withdrawForRepay(address, uint256) public {

        revert("PensionFundLiquidityModule: operation not supported");

    }



    /**

     * @notice Calculates amount of pToken user can withdraw during withdraw period

     * @dev This calculation does not count possible not-yet-claimed distributions

     */

    function withdrawLimit(address user) public view returns(uint256) {

        PensionPlan storage plan  = plans[user];

        if (plan.created == 0) return 0;

        uint256 pBalance = pToken().distributionBalanceOf(user);

        return _withdrawLimit(plan, pBalance);

    }



    /**

     * @notice Calculates amount of pToken user can withdraw during deposit period on plan close

     * @dev This calculation does not count possible not-yet-claimed distributions

     */

    function pRefund(address user) public view returns(uint256) {

        PensionPlan storage plan  = plans[user];

        if (plan.created == 0) return 0;

        uint256 pBalance = pToken().distributionBalanceOf(user);

        uint256 pPenalty = _pPenalty(plan, pBalance);

        return pBalance.sub(pPenalty);

    }



    function _withdrawLimit(PensionPlan storage plan, uint256 pBalance) internal view returns(uint256) {

        uint256 withdrawStart = plan.created.add(planSettings.depositPeriodDuration);

        if (withdrawStart >= now) return 0;

        uint256 sinceWithdrawStart = now.sub(withdrawStart);

        if (sinceWithdrawStart >= planSettings.withdrawPeriodDuration) {

            return pBalance;

        }

        uint256 pInitialAllowance = pBalance.mul(planSettings.initalWithdrawAllowance).div(MULTIPLIER);

        uint256 pTimeAllowance = pBalance.sub(pInitialAllowance).mul(sinceWithdrawStart).div(planSettings.withdrawPeriodDuration);

        uint256 fullAllowance = pInitialAllowance.add(pTimeAllowance);

        if (fullAllowance <= plan.pWithdrawn) return 0;

        return fullAllowance - plan.pWithdrawn;

    }



    function _pPenalty(PensionPlan storage plan, uint256 pBalance) internal view returns(uint256) {

        uint256 withdrawStart = plan.created.add(planSettings.depositPeriodDuration);

        uint256 planEnd = withdrawStart.add(planSettings.withdrawPeriodDuration);

        if (now >= planEnd) {

            //After end ow withdraw period - can close plan without penalty            

            return 0;

        }

        uint256 pPenalty;

        if (now < withdrawStart){

            //During deposit period

            uint256 tillWithdrawStart = withdrawStart.sub(now);

            uint256 pMinPenalty = pBalance.mul(planSettings.minPenalty).div(MULTIPLIER);

            uint256 pMaxPenalty = pBalance.mul(planSettings.maxPenalty).div(MULTIPLIER);

            pPenalty = pMinPenalty.add(pMaxPenalty.sub(pMinPenalty).mul(tillWithdrawStart).div(planSettings.depositPeriodDuration));

        } else {

            //During withdraw period

            uint256 allowance = _withdrawLimit(plan, pBalance);

            if (allowance < pBalance) {

                pPenalty = pBalance.sub(allowance).mul(planSettings.minPenalty).div(MULTIPLIER);

            } else {

                return 0;

            }

        }

        return pPenalty;

    }



    function fundsModule() internal view returns(IFundsModule) {

        return IFundsModule(getModuleAddress(MODULE_FUNDS));

    }



    function pToken() private view returns(IPToken){

        return IPToken(getModuleAddress(MODULE_PTOKEN));

    }

}

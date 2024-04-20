pragma solidity ^0.5.12;



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

 * @notice Interface for contracts receiving flash loans. 

 * Compatible with Aave flash loans, see 

 * https://github.com/aave/aave-protocol/blob/master/contracts/flashloan/interfaces/IFlashLoanReceiver.sol

 */

interface IFlashLoanReceiver {

    /**

     * @notice Execute flash-loan

     * @param token Address of loaned token

     * @param amount Amount loaned

     * @param fee Fee has to be returned alongside with amount

     * @param data Any parameters your contract may need, use ABI-encoded form to pass multiple parameteres

     *

     * @dev When Pool calls executeOperation(), it already transfered tokens to receiver contract.

     * It's receiver responcibility to transfer back (to msg.sender) amount+fee tokens.

     */

    function executeOperation(address token, uint256 amount, uint256 fee, bytes calldata data) external;

}



/**

 * @title FlashLoans Module Interface

 * @dev FlashLoans module is responsible for managing flash-loans.

 */

interface IFlashLoansModule {

    function executeLoan(IFlashLoanReceiver receiver, uint256 amount, bytes calldata data) external;



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



contract FlashLoansModule is Module, IFlashLoansModule {

    using SafeMath for uint256;



    event FeeChanged(uint256 oldFee, uint256 newFee);



    uint256 public constant LOAN_FEE_MULTIPLIER = 1e18;

    uint256 loanFee;        // Loan fee will be calculated as loanAmount*loanFee/LOAN_FEE_MULTIPLIER



    function initialize(address _pool) public initializer {

        Module.initialize(_pool);

        loanFee = LOAN_FEE_MULTIPLIER*5/10000;   // 0.05% fee

    }



    /**

     * @notice Execute flash loan

     * @param receiver A contract which receives flash loan

     * @param amount Amount of lToken to send to receiever

     */

    function executeLoan(IFlashLoanReceiver receiver, uint256 amount, bytes calldata data) external {

        uint256 fee = getLoanFee(amount);

        require(fee > 0, "FlashLoansModule: loan amount is too small");

        IFundsModule fundsModule = fundsModule();

        require(fundsModule.lBalance() >= amount, "FlashLoansModule: not enough liquidity");

        IERC20 lToken = lToken();

        uint256 balance = lToken.balanceOf(address(this));

        require(balance == 0, "FlashLoansModule: invalid state");



        // Transfer tokens to receiver

        fundsModule.withdrawLTokens(address(receiver), amount, 0);



        // Execute flash-loan

        receiver.executeOperation(address(lToken), amount, fee, data); 



        // Validate & return funds

        balance = lToken.balanceOf(address(this));

        require(balance == amount.add(fee), "FlashLoansModule: returned amount is not correct");

        lToken.approve(address(fundsModule), balance);

        fundsModule.depositLTokens(address(this), balance);



    }



    function setFee(uint256 _loanFee) public onlyOwner{

        uint256 oldFee = loanFee;

        loanFee = _loanFee;

        emit FeeChanged(oldFee, loanFee);

    }



    function getLoanFee() public view returns(uint256){

        return loanFee;

    }



    function getLoanFee(uint256 amount) public view returns(uint256){

        return amount.mul(loanFee).div(LOAN_FEE_MULTIPLIER);

    }



    function fundsModule() internal view returns(IFundsModule) {

        return IFundsModule(getModuleAddress(MODULE_FUNDS));

    }

    

    function lToken() private view returns(IERC20){

        return IERC20(getModuleAddress(MODULE_LTOKEN));

    }

}

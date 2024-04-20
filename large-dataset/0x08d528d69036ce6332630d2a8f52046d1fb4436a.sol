// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol



pragma solidity ^0.5.0;



/**

 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include

 * the optional functions; to access them see `ERC20Detailed`.

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

     * Emits a `Transfer` event.

     */

    function transfer(address recipient, uint256 amount) external returns (bool);



    /**

     * @dev Returns the remaining number of tokens that `spender` will be

     * allowed to spend on behalf of `owner` through `transferFrom`. This is

     * zero by default.

     *

     * This value changes when `approve` or `transferFrom` are called.

     */

    function allowance(address owner, address spender) external view returns (uint256);



    /**

     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.

     *

     * Returns a boolean value indicating whether the operation succeeded.

     *

     * > Beware that changing an allowance with this method brings the risk

     * that someone may use both the old and the new allowance by unfortunate

     * transaction ordering. One possible solution to mitigate this race

     * condition is to first reduce the spender's allowance to 0 and set the

     * desired value afterwards:

     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729

     *

     * Emits an `Approval` event.

     */

    function approve(address spender, uint256 amount) external returns (bool);



    /**

     * @dev Moves `amount` tokens from `sender` to `recipient` using the

     * allowance mechanism. `amount` is then deducted from the caller's

     * allowance.

     *

     * Returns a boolean value indicating whether the operation succeeded.

     *

     * Emits a `Transfer` event.

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

     * a call to `approve`. `value` is the new allowance.

     */

    event Approval(address indexed owner, address indexed spender, uint256 value);

}



// File: openzeppelin-solidity/contracts/math/SafeMath.sol



pragma solidity ^0.5.0;



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

        require(b <= a, "SafeMath: subtraction overflow");

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

        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522

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

        // Solidity only automatically asserts when dividing by 0

        require(b > 0, "SafeMath: division by zero");

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

        require(b != 0, "SafeMath: modulo by zero");

        return a % b;

    }

}



// File: contracts/crowdsale/IIvoCrowdsale.sol



/**

 * @title Interface of IVO Crowdale

 * @author Validity Labs AG <info@validitylabs.org>

 */

// solhint-disable-next-line compiler-fixed, compiler-gt-0_5

pragma solidity ^0.5.0;





contract IIvoCrowdsale {

    /**

     * @return The starting time of the crowdsale.

     */

    function startingTime() public view returns(uint256);

}



// File: contracts/vault/IVault.sol



/*

 * @title Interface for basic vaults

 * @author Validity Labs AG <info@validitylabs.org>

 */

// solhint-disable-next-line compiler-fixed, compiler-gt-0_5

pragma solidity ^0.5.0;





contract IVault {

    /**

     * @notice Adding beneficiary to the vault

     * @param beneficiary The account that receives token

     * @param value The amount of token allocated

     */

    function receiveFor(address beneficiary, uint256 value) public;



    /**

     * @notice Update the releaseTime for vaults

     * @param roundEndTime The new releaseTime

     */

    function updateReleaseTime(uint256 roundEndTime) public;

}



// File: contracts/property/CounterGuard.sol



/**

 * @title modifier contract that guards certain properties only triggered once

 * @author Validity Labs AG <info@validitylabs.org>

 */

// solhint-disable-next-line compiler-fixed, compiler-gt-0_5

pragma solidity ^0.5.0;





contract CounterGuard {

    /**

     * @notice Controle if a boolean attribute (false by default) was updated to true.

     * @dev This attribute is designed specifically for recording an action.

     * @param criterion The boolean attribute that records if an action has taken place

     */

    modifier onlyOnce(bool criterion) {

        require(criterion == false, "Already been set");

        _;

    }

}



// File: openzeppelin-solidity/contracts/ownership/Ownable.sol



pragma solidity ^0.5.0;



/**

 * @dev Contract module which provides a basic access control mechanism, where

 * there is an account (an owner) that can be granted exclusive access to

 * specific functions.

 *

 * This module is used through inheritance. It will make available the modifier

 * `onlyOwner`, which can be aplied to your functions to restrict their use to

 * the owner.

 */

contract Ownable {

    address private _owner;



    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);



    /**

     * @dev Initializes the contract setting the deployer as the initial owner.

     */

    constructor () internal {

        _owner = msg.sender;

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

        return msg.sender == _owner;

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

}



// File: openzeppelin-solidity/contracts/utils/Address.sol



pragma solidity ^0.5.0;



/**

 * @dev Collection of functions related to the address type,

 */

library Address {

    /**

     * @dev Returns true if `account` is a contract.

     *

     * This test is non-exhaustive, and there may be false-negatives: during the

     * execution of a contract's constructor, its address will be reported as

     * not containing a contract.

     *

     * > It is unsafe to assume that an address for which this function returns

     * false is an externally-owned account (EOA) and not a contract.

     */

    function isContract(address account) internal view returns (bool) {

        // This method relies in extcodesize, which returns 0 for contracts in

        // construction, since the code is only stored at the end of the

        // constructor execution.



        uint256 size;

        // solhint-disable-next-line no-inline-assembly

        assembly { size := extcodesize(account) }

        return size > 0;

    }

}



// File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol



pragma solidity ^0.5.0;









/**

 * @title SafeERC20

 * @dev Wrappers around ERC20 operations that throw on failure (when the token

 * contract returns false). Tokens that return no value (and instead revert or

 * throw on failure) are also supported, non-reverting calls are assumed to be

 * successful.

 * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,

 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.

 */

library SafeERC20 {

    using SafeMath for uint256;

    using Address for address;



    function safeTransfer(IERC20 token, address to, uint256 value) internal {

        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));

    }



    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {

        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));

    }



    function safeApprove(IERC20 token, address spender, uint256 value) internal {

        // safeApprove should only be called when setting an initial allowance,

        // or when resetting it to zero. To increase and decrease it, use

        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'

        // solhint-disable-next-line max-line-length

        require((value == 0) || (token.allowance(address(this), spender) == 0),

            "SafeERC20: approve from non-zero to non-zero allowance"

        );

        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));

    }



    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {

        uint256 newAllowance = token.allowance(address(this), spender).add(value);

        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));

    }



    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {

        uint256 newAllowance = token.allowance(address(this), spender).sub(value);

        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));

    }



    /**

     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement

     * on the return value: the return value is optional (but if data is returned, it must not be false).

     * @param token The token targeted by the call.

     * @param data The call data (encoded using abi.encode or one of its variants).

     */

    function callOptionalReturn(IERC20 token, bytes memory data) private {

        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since

        // we're implementing it ourselves.



        // A Solidity high level call has three parts:

        //  1. The target address is checked to verify it contains contract code

        //  2. The call itself is made, and success asserted

        //  3. The return value is decoded, which in turn checks the size of the returned data.

        // solhint-disable-next-line max-line-length

        require(address(token).isContract(), "SafeERC20: call to non-contract");



        // solhint-disable-next-line avoid-low-level-calls

        (bool success, bytes memory returndata) = address(token).call(data);

        require(success, "SafeERC20: low-level call failed");



        if (returndata.length > 0) { // Return data is optional

            // solhint-disable-next-line max-line-length

            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");

        }

    }

}



// File: contracts/property/Reclaimable.sol



/**

 * @title Reclaimable

 * @dev This contract gives owner right to recover any ERC20 tokens accidentally sent to 

 * the token contract. The recovered token will be sent to the owner of token. 

 * @author Validity Labs AG <info@validitylabs.org>

 */

// solhint-disable-next-line compiler-fixed, compiler-gt-0_5

pragma solidity ^0.5.0;











contract Reclaimable is Ownable {

    using SafeERC20 for IERC20;



    /**

     * @notice Let the owner to retrieve other tokens accidentally sent to this contract.

     * @dev This function is suitable when no token of any kind shall be stored under

     * the address of the inherited contract.

     * @param tokenToBeRecovered address of the token to be recovered.

     */

    function reclaimToken(IERC20 tokenToBeRecovered) external onlyOwner {

        uint256 balance = tokenToBeRecovered.balanceOf(address(this));

        tokenToBeRecovered.safeTransfer(owner(), balance);

    }

}



// File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol



pragma solidity ^0.5.0;



/**

 * @dev Contract module that helps prevent reentrant calls to a function.

 *

 * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier

 * available, which can be aplied to functions to make sure there are no nested

 * (reentrant) calls to them.

 *

 * Note that because there is a single `nonReentrant` guard, functions marked as

 * `nonReentrant` may not call one another. This can be worked around by making

 * those functions `private`, and then adding `external` `nonReentrant` entry

 * points to them.

 */

contract ReentrancyGuard {

    /// @dev counter to allow mutex lock with only one SSTORE operation

    uint256 private _guardCounter;



    constructor () internal {

        // The counter starts at one to prevent changing it from zero to a non-zero

        // value, which is a more expensive operation.

        _guardCounter = 1;

    }



    /**

     * @dev Prevents a contract from calling itself, directly or indirectly.

     * Calling a `nonReentrant` function from another `nonReentrant`

     * function is not supported. It is possible to prevent this from happening

     * by making the `nonReentrant` function external, and make it call a

     * `private` function that does the actual work.

     */

    modifier nonReentrant() {

        _guardCounter += 1;

        uint256 localCounter = _guardCounter;

        _;

        require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");

    }

}



// File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol



pragma solidity ^0.5.0;











/**

 * @title Crowdsale

 * @dev Crowdsale is a base contract for managing a token crowdsale,

 * allowing investors to purchase tokens with ether. This contract implements

 * such functionality in its most fundamental form and can be extended to provide additional

 * functionality and/or custom behavior.

 * The external interface represents the basic interface for purchasing tokens, and conforms

 * the base architecture for crowdsales. It is *not* intended to be modified / overridden.

 * The internal interface conforms the extensible and modifiable surface of crowdsales. Override

 * the methods to add functionality. Consider using 'super' where appropriate to concatenate

 * behavior.

 */

contract Crowdsale is ReentrancyGuard {

    using SafeMath for uint256;

    using SafeERC20 for IERC20;



    // The token being sold

    IERC20 private _token;



    // Address where funds are collected

    address payable private _wallet;



    // How many token units a buyer gets per wei.

    // The rate is the conversion between wei and the smallest and indivisible token unit.

    // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK

    // 1 wei will give you 1 unit, or 0.001 TOK.

    uint256 private _rate;



    // Amount of wei raised

    uint256 private _weiRaised;



    /**

     * Event for token purchase logging

     * @param purchaser who paid for the tokens

     * @param beneficiary who got the tokens

     * @param value weis paid for purchase

     * @param amount amount of tokens purchased

     */

    event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);



    /**

     * @param rate Number of token units a buyer gets per wei

     * @dev The rate is the conversion between wei and the smallest and indivisible

     * token unit. So, if you are using a rate of 1 with a ERC20Detailed token

     * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.

     * @param wallet Address where collected funds will be forwarded to

     * @param token Address of the token being sold

     */

    constructor (uint256 rate, address payable wallet, IERC20 token) public {

        require(rate > 0, "Crowdsale: rate is 0");

        require(wallet != address(0), "Crowdsale: wallet is the zero address");

        require(address(token) != address(0), "Crowdsale: token is the zero address");



        _rate = rate;

        _wallet = wallet;

        _token = token;

    }



    /**

     * @dev fallback function ***DO NOT OVERRIDE***

     * Note that other contracts will transfer funds with a base gas stipend

     * of 2300, which is not enough to call buyTokens. Consider calling

     * buyTokens directly when purchasing tokens from a contract.

     */

    function () external payable {

        buyTokens(msg.sender);

    }



    /**

     * @return the token being sold.

     */

    function token() public view returns (IERC20) {

        return _token;

    }



    /**

     * @return the address where funds are collected.

     */

    function wallet() public view returns (address payable) {

        return _wallet;

    }



    /**

     * @return the number of token units a buyer gets per wei.

     */

    function rate() public view returns (uint256) {

        return _rate;

    }



    /**

     * @return the amount of wei raised.

     */

    function weiRaised() public view returns (uint256) {

        return _weiRaised;

    }



    /**

     * @dev low level token purchase ***DO NOT OVERRIDE***

     * This function has a non-reentrancy guard, so it shouldn't be called by

     * another `nonReentrant` function.

     * @param beneficiary Recipient of the token purchase

     */

    function buyTokens(address beneficiary) public nonReentrant payable {

        uint256 weiAmount = msg.value;

        _preValidatePurchase(beneficiary, weiAmount);



        // calculate token amount to be created

        uint256 tokens = _getTokenAmount(weiAmount);



        // update state

        _weiRaised = _weiRaised.add(weiAmount);



        _processPurchase(beneficiary, tokens);

        emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);



        _updatePurchasingState(beneficiary, weiAmount);



        _forwardFunds();

        _postValidatePurchase(beneficiary, weiAmount);

    }



    /**

     * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.

     * Use `super` in contracts that inherit from Crowdsale to extend their validations.

     * Example from CappedCrowdsale.sol's _preValidatePurchase method:

     *     super._preValidatePurchase(beneficiary, weiAmount);

     *     require(weiRaised().add(weiAmount) <= cap);

     * @param beneficiary Address performing the token purchase

     * @param weiAmount Value in wei involved in the purchase

     */

    function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {

        require(beneficiary != address(0), "Crowdsale: beneficiary is the zero address");

        require(weiAmount != 0, "Crowdsale: weiAmount is 0");

    }



    /**

     * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid

     * conditions are not met.

     * @param beneficiary Address performing the token purchase

     * @param weiAmount Value in wei involved in the purchase

     */

    function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {

        // solhint-disable-previous-line no-empty-blocks

    }



    /**

     * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends

     * its tokens.

     * @param beneficiary Address performing the token purchase

     * @param tokenAmount Number of tokens to be emitted

     */

    function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {

        _token.safeTransfer(beneficiary, tokenAmount);

    }



    /**

     * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send

     * tokens.

     * @param beneficiary Address receiving the tokens

     * @param tokenAmount Number of tokens to be purchased

     */

    function _processPurchase(address beneficiary, uint256 tokenAmount) internal {

        _deliverTokens(beneficiary, tokenAmount);

    }



    /**

     * @dev Override for extensions that require an internal state to check for validity (current user contributions,

     * etc.)

     * @param beneficiary Address receiving the tokens

     * @param weiAmount Value in wei involved in the purchase

     */

    function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {

        // solhint-disable-previous-line no-empty-blocks

    }



    /**

     * @dev Override to extend the way in which ether is converted to tokens.

     * @param weiAmount Value in wei to be converted into tokens

     * @return Number of tokens that can be purchased with the specified _weiAmount

     */

    function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {

        return weiAmount.mul(_rate);

    }



    /**

     * @dev Determines how ETH is stored/forwarded on purchases.

     */

    function _forwardFunds() internal {

        _wallet.transfer(msg.value);

    }

}



// File: openzeppelin-solidity/contracts/access/Roles.sol



pragma solidity ^0.5.0;



/**

 * @title Roles

 * @dev Library for managing addresses assigned to a Role.

 */

library Roles {

    struct Role {

        mapping (address => bool) bearer;

    }



    /**

     * @dev Give an account access to this role.

     */

    function add(Role storage role, address account) internal {

        require(!has(role, account), "Roles: account already has role");

        role.bearer[account] = true;

    }



    /**

     * @dev Remove an account's access to this role.

     */

    function remove(Role storage role, address account) internal {

        require(has(role, account), "Roles: account does not have role");

        role.bearer[account] = false;

    }



    /**

     * @dev Check if an account has this role.

     * @return bool

     */

    function has(Role storage role, address account) internal view returns (bool) {

        require(account != address(0), "Roles: account is the zero address");

        return role.bearer[account];

    }

}



// File: contracts/membership/ManagerRole.sol



/**

 * @title Manager Role

 * @dev This contract is developed based on the Manager contract of OpenZeppelin.

 * The key difference is the management of the manager roles is restricted to one owner

 * account. At least one manager should exist in any situation.

 * @author Validity Labs AG <info@validitylabs.org>

 */

// solhint-disable-next-line compiler-fixed, compiler-gt-0_5

pragma solidity ^0.5.0;











contract ManagerRole is Ownable {

    using Roles for Roles.Role;

    using SafeMath for uint256;



    event ManagerAdded(address indexed account);

    event ManagerRemoved(address indexed account);



    Roles.Role private managers;

    uint256 private _numManager;



    constructor() internal {

        _addManager(msg.sender);

        _numManager = 1;

    }



    /**

     * @notice Only manager can take action

     */

    modifier onlyManager() {

        require(isManager(msg.sender), "The account is not a manager");

        _;

    }



    /**

     * @notice This function allows to add managers in batch with control of the number of 

     * interations

     * @param accounts The accounts to be added in batch

     */

    // solhint-disable-next-line

    function addManagers(address[] calldata accounts) external onlyOwner {

        uint256 length = accounts.length;

        require(length <= 256, "too many accounts");

        for (uint256 i = 0; i < length; i++) {

            _addManager(accounts[i]);

        }

    }

    

    /**

     * @notice Add an account to the list of managers,

     * @param account The account address whose manager role needs to be removed.

     */

    function removeManager(address account) external onlyOwner {

        _removeManager(account);

    }



    /**

     * @notice Check if an account is a manager

     * @param account The account to be checked if it has a manager role

     * @return true if the account is a manager. Otherwise, false

     */

    function isManager(address account) public view returns (bool) {

        return managers.has(account);

    }



    /**

     *@notice Get the number of the current managers

     */

    function numManager() public view returns (uint256) {

        return _numManager;

    }



    /**

     * @notice Add an account to the list of managers,

     * @param account The account that needs to tbe added as a manager

     */

    function addManager(address account) public onlyOwner {

        require(account != address(0), "account is zero");

        _addManager(account);

    }



    /**

     * @notice Renounce the manager role

     * @dev This function was not explicitly required in the specs. There should be at

     * least one manager at any time. Therefore, at least two when one manage renounces

     * themselves.

     */

    function renounceManager() public {

        require(_numManager >= 2, "Managers are fewer than 2");

        _removeManager(msg.sender);

    }



    /** OVERRIDE 

    * @notice Allows the current owner to relinquish control of the contract.

    * @dev Renouncing to ownership will leave the contract without an owner.

    * It will not be possible to call the functions with the `onlyOwner`

    * modifier anymore.

    */

    function renounceOwnership() public onlyOwner {

        revert("Cannot renounce ownership");

    }



    /**

     * @notice Internal function to be called when adding a manager

     * @param account The address of the manager-to-be

     */

    function _addManager(address account) internal {

        _numManager = _numManager.add(1);

        managers.add(account);

        emit ManagerAdded(account);

    }



    /**

     * @notice Internal function to remove one account from the manager list

     * @param account The address of the to-be-removed manager

     */

    function _removeManager(address account) internal {

        _numManager = _numManager.sub(1);

        managers.remove(account);

        emit ManagerRemoved(account);

    }

}



// File: contracts/membership/PausableManager.sol



/**

 * @title Pausable Manager Role

 * @dev This manager can also pause a contract. This contract is developed based on the 

 * Pause contract of OpenZeppelin.

 * @author Validity Labs AG <info@validitylabs.org>

 */

// solhint-disable-next-line compiler-fixed, compiler-gt-0_5

pragma solidity ^0.5.0;







contract PausableManager is ManagerRole {



    event BePaused(address manager);

    event BeUnpaused(address manager);



    bool private _paused;   // If the crowdsale contract is paused, controled by the manager...



    constructor() internal {

        _paused = false;

    }



   /**

    * @notice Modifier to make a function callable only when the contract is not paused.

    */

    modifier whenNotPaused() {

        require(!_paused, "not paused");

        _;

    }



    /**

    * @notice Modifier to make a function callable only when the contract is paused.

    */

    modifier whenPaused() {

        require(_paused, "paused");

        _;

    }



    /**

    * @return true if the contract is paused, false otherwise.

    */

    function paused() public view returns(bool) {

        return _paused;

    }



    /**

    * @notice called by the owner to pause, triggers stopped state

    */

    function pause() public onlyManager whenNotPaused {

        _paused = true;

        emit BePaused(msg.sender);

    }



    /**

    * @notice called by the owner to unpause, returns to normal state

    */

    function unpause() public onlyManager whenPaused {

        _paused = false;

        emit BeUnpaused(msg.sender);

    }

}



// File: contracts/property/ValidAddress.sol



/**

 * @title modifier contract that checks if the address is valid

 * @author Validity Labs AG <info@validitylabs.org>

 */

// solhint-disable-next-line compiler-fixed, compiler-gt-0_5

pragma solidity ^0.5.0;





contract ValidAddress {

    /**

     * @notice Check if the address is not zero

     */

    modifier onlyValidAddress(address _address) {

        require(_address != address(0), "Not a valid address");

        _;

    }



    /**

     * @notice Check if the address is not the sender's address

    */

    modifier isSenderNot(address _address) {

        require(_address != msg.sender, "Address is the same as the sender");

        _;

    }



    /**

     * @notice Check if the address is the sender's address

    */

    modifier isSender(address _address) {

        require(_address == msg.sender, "Address is different from the sender");

        _;

    }

}



// File: contracts/membership/Whitelist.sol



/**

 * @title Whitelist

 * @dev The WhitelistCrowdsale was not included in OZ's release at the moment of the 

 * development of this contract. Therefore, we've developed the Whitelist contract and

 * the WhitelistCrowdsale contract.

 * @author Validity Labs AG <info@validitylabs.org>

 */

// solhint-disable-next-line compiler-fixed, compiler-gt-0_5

pragma solidity ^0.5.0;









contract Whitelist is ValidAddress, PausableManager {

    

    bool private _isWhitelisting;

    mapping (address => bool) private _isWhitelisted;



    event AddedWhitelisted(address indexed account);

    event RemovedWhitelisted(address indexed account);



    /**

     * @notice Adding account control, only whitelisted accounts could do certain actions.

     * @dev Whitelisting is enabled by default, There is not even the opportunity to 

     * disable it.

     */

    constructor() internal {

        _isWhitelisting = true;

    }

    

    /**

     * @dev Add an account to the whitelist, calling the corresponding internal function

     * @param account The address of the investor

     */

    function addWhitelisted(address account) external onlyManager {

        _addWhitelisted(account);

    }

    

    /**

     * @notice This function allows to whitelist investors in batch 

     * with control of number of interations

     * @param accounts The accounts to be whitelisted in batch

     */

    // solhint-disable-next-line 

    function addWhitelisteds(address[] calldata accounts) external onlyManager {

        uint256 length = accounts.length;

        require(length <= 256, "too long");

        for (uint256 i = 0; i < length; i++) {

            _addWhitelisted(accounts[i]);

        }

    }



    /**

     * @notice Remove an account from the whitelist, calling the corresponding internal 

     * function

     * @param account The address of the investor that needs to be removed

     */

    function removeWhitelisted(address account) 

        external 

        onlyManager  

    {

        _removeWhitelisted(account);

    }



    /**

     * @notice This function allows to whitelist investors in batch 

     * with control of number of interations

     * @param accounts The accounts to be whitelisted in batch

     */

    // solhint-disable-next-line 

    function removeWhitelisteds(address[] calldata accounts) 

        external 

        onlyManager  

    {

        uint256 length = accounts.length;

        require(length <= 256, "too long");

        for (uint256 i = 0; i < length; i++) {

            _removeWhitelisted(accounts[i]);

        }

    }



    /**

     * @notice Check if an account is whitelisted or not

     * @param account The account to be checked

     * @return true if the account is whitelisted. Otherwise, false.

     */

    function isWhitelisted(address account) public view returns (bool) {

        return _isWhitelisted[account];

    }



    /**

     * @notice Add an investor to the whitelist

     * @param account The address of the investor that has successfully passed KYC

     */

    function _addWhitelisted(address account) 

        internal

        onlyValidAddress(account)

    {

        require(_isWhitelisted[account] == false, "account already whitelisted");

        _isWhitelisted[account] = true;

        emit AddedWhitelisted(account);

    }



    /**

     * @notice Remove an investor from the whitelist

     * @param account The address of the investor that needs to be removed

     */

    function _removeWhitelisted(address account) 

        internal 

        onlyValidAddress(account)

    {

        require(_isWhitelisted[account] == true, "account was not whitelisted");

        _isWhitelisted[account] = false;

        emit RemovedWhitelisted(account);

    }

}



// File: contracts/crowdsale/WhitelistCrowdsale.sol



/**

 * @title Crowdsale with whitelists

 * @dev The WhitelistCrowdsale was not included in OZ's release at the moment of the 

 * development of this contract. Therefore, we've developed the Whitelist contract and

 * the WhitelistCrowdsale contract.

 * @author Validity Labs AG <info@validitylabs.org>

 */

// solhint-disable-next-line compiler-fixed, compiler-gt-0_5

pragma solidity ^0.5.0;









/**

 * @title WhitelistCrowdsale

 * @dev Crowdsale in which only whitelisted users can contribute.

 */

contract WhitelistCrowdsale is Whitelist, Crowdsale {

    /**

    * @notice Extend parent behavior requiring beneficiary to be whitelisted. 

    * @dev Note that no restriction is imposed on the account sending the transaction.

    * @param _beneficiary Token beneficiary

    * @param _weiAmount Amount of wei contributed

    */

    function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) 

        internal 

        view 

    {

        require(isWhitelisted(_beneficiary), "beneficiary is not whitelisted");

        super._preValidatePurchase(_beneficiary, _weiAmount);

    }

}



// File: contracts/crowdsale/NonEthPurchasableCrowdsale.sol



/**

 * @title Crowdsale that allows to be purchased with fiat

 * @dev Functionalities in this contract could also be pausable, besides managerOnly

 * @author Validity Labs AG <info@validitylabs.org>

 */

// solhint-disable-next-line compiler-fixed, compiler-gt-0_5

pragma solidity ^0.5.0;









contract NonEthPurchasableCrowdsale is Crowdsale {

    event NonEthTokenPurchased(address indexed beneficiary, uint256 tokenAmount);



    /**

     * @notice Allows onlyManager to mint token for beneficiary.

     * @param beneficiary Recipient of the token purchase

     * @param tokenAmount Amount of token purchased

     */

    function nonEthPurchase(address beneficiary, uint256 tokenAmount) 

        public 

    {

        _preValidatePurchase(beneficiary, tokenAmount);

        _processPurchase(beneficiary, tokenAmount);

        emit NonEthTokenPurchased(beneficiary, tokenAmount);

    }

}



// File: contracts/crowdsale/UpdatableRateCrowdsale.sol



/**

 * @title Crowdsale with updatable exchange rate

 * @dev Functionalities in this contract could also be pausable, besides managerOnly

 * @author Validity Labs AG <info@validitylabs.org>

 */

// solhint-disable-next-line compiler-fixed, compiler-gt-0_5

pragma solidity ^0.5.0;











// @TODO change the pausable manager to other role or the role to be created ->

// whitelisted admin

contract UpdatableRateCrowdsale is PausableManager, Crowdsale {

    using SafeMath for uint256;

    

    /*** PRE-DEPLOYMENT CONFIGURED CONSTANTS */

    // 1 IVO = 0.3213 USD

    uint256 private constant TOKEN_PRICE_USD = 3213;

    uint256 private constant TOKEN_PRICE_BASE = 10000;

    uint256 private constant FIAT_RATE_BASE = 100;



    // This vairable is not goint to override the _rate vairable in OZ's _rate vairable

    // because of the scope/visibility, however, we could override the getter function

    uint256 private _rate;

    // USD to ETH rate, as shown on CoinMarketCap.com

    // _rate = _fiatRate / ((1 - discount) * (TOKEN_PRICE_USD / TOKEN_PRICE_BASE))

    // e.g. If 1 ETH = 110.24 USD, _fiatRate is 11024.

    uint256 private _fiatRate; 



    /**

   * Event for fiat to ETH rate update

   * @param value the fiatrate

   * @param timestamp blocktime of the update

   */

    event UpdatedFiatRate (uint256 value, uint256 timestamp);



    /**

     * @param initialFiatRate The fiat rate (ETH/USD) when crowdsale starts

     * @dev 2 decimals. e.g. If 1 ETH = 110.24 USD, _fiatRate is 11024.

     */

    constructor (uint256 initialFiatRate) internal {

        require(initialFiatRate > 0, "fiat rate is not positive");

        _updateRate(initialFiatRate);

    }



    /**

     * @dev Allow manager to update the exchange rate when necessary.

     */

    function updateRate(uint256 newFiatRate) external onlyManager {

        _updateRate(newFiatRate);

    }



    /** OVERRIDE

    * @return the number of token units a buyer gets per wei.

    */

    function rate() public view returns (uint256) {

        return _rate;

    }



    /**

     * @return the ETH price (in USD) currently used in the crowdsale

     */

    function fiatRate() public view returns (uint256) {

        return _fiatRate;

    }



    /**

    * @notice Calculate the amount of token to be sold based on the amount of wei

    * @dev To be overriden to extend the way in which ether is converted to tokens.

    * @param weiAmount Value in wei to be converted into tokens

    * @return Number of tokens that can be purchased with the specified _weiAmount

    */

    function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {

        return weiAmount.mul(_rate);

    }



    /**

     * @notice Update the exchange rate when the fiat rate is changed

     * @dev Since we round the _rate now into an integer. There is a loss in purchase

     * E.g. When ETH is at 110.24$, one could have 343.106 IVO with 1 ETH of net 

     * contribution (after deducting the KYC/AML fee) in mainsale. However, only 343 IVO 

     * will be issued, due to the rounding, resulting in a loss of 0.35 $/ETH purchase.

     */

    function _updateRate(uint256 newFiatRate) internal {

        _fiatRate = newFiatRate;

        _rate = _fiatRate.mul(TOKEN_PRICE_BASE).div(TOKEN_PRICE_USD * FIAT_RATE_BASE);

        emit UpdatedFiatRate(_fiatRate, block.timestamp);

    }

}



// File: contracts/crowdsale/CappedMultiRoundCrowdsale.sol



/**

 * @title Multi-round with cap Crowdsale

 * @author Validity Labs AG <info@validitylabs.org>

 */

// solhint-disable-next-line compiler-fixed, compiler-gt-0_5

pragma solidity ^0.5.0;















contract CappedMultiRoundCrowdsale is UpdatableRateCrowdsale {

    using SafeMath for uint256;

    using SafeERC20 for IERC20;



    /*** PRE-DEPLOYMENT CONFIGURED CONSTANTS */

    uint256 private constant ROUNDS = 3;

    uint256 private constant CAP_ROUND_ONE = 22500000 ether;

    uint256 private constant CAP_ROUND_TWO = 37500000 ether;

    uint256 private constant CAP_ROUND_THREE = 52500000 ether;

    uint256 private constant HARD_CAP = 52500000 ether;

    uint256 private constant PRICE_PERCENTAGE_ROUND_ONE = 80;

    uint256 private constant PRICE_PERCENTAGE_ROUND_TWO = 90;

    uint256 private constant PRICE_PERCENTAGE_ROUND_THREE = 100;

    uint256 private constant PRICE_PERCENTAGE_BASE = 100;



    uint256 private _currentRoundCap;

    uint256 private _mintedByCrowdsale;

    uint256 private _currentRound;

    uint256[ROUNDS] private _capOfRound;

    uint256[ROUNDS] private _pricePercentagePerRound;

    address private privateVaultAddress;

    address private presaleVaultAddress;

    address private reserveVaultAddress;



    /**

     * Event for multi-round logging

     * @param roundNumber number of the current rounnd, starting from 0

     * @param timestamp blocktime of the start of the next block

     */

    event RoundStarted(uint256 indexed roundNumber, uint256 timestamp);



    /**

     * Constructor for the capped multi-round crowdsale

     * @param startingTime Time when the first round starts

     */

    /* solhint-disable */

    constructor (uint256 startingTime) internal {

        // update the private variable as the round number and the discount percentage is not changed.

        _pricePercentagePerRound[0] = PRICE_PERCENTAGE_ROUND_ONE;

        _pricePercentagePerRound[1] = PRICE_PERCENTAGE_ROUND_TWO;

        _pricePercentagePerRound[2] = PRICE_PERCENTAGE_ROUND_THREE;

        // update the milestones

        _capOfRound[0] = CAP_ROUND_ONE;

        _capOfRound[1] = CAP_ROUND_TWO;

        _capOfRound[2] = CAP_ROUND_THREE;

        // initiallization

        _currentRound;

        _currentRoundCap = _capOfRound[_currentRound];

        emit RoundStarted(_currentRound, startingTime);

    }

    /* solhint-enable */

    

    /**

    * @notice Modifier to be executed when multi-round is still going on

    */

    modifier stillInRounds() {

        require(_currentRound < ROUNDS, "Not in rounds");

        _;

    }



    /**

     * @notice Check vault addresses are correcly settled.

     */

     /* solhint-disable */

    modifier vaultAddressesSet() {

        require(privateVaultAddress != address(0) && presaleVaultAddress != address(0) && reserveVaultAddress != address(0), "Vaults are not set");

        _;

    }

    /* solhint-enable */



    /**

    * @return the cap of the crowdsale.

    */

    function hardCap() public pure returns(uint256) {

        return HARD_CAP;

    }



    /**

    * @return the cap of the current round of crowdsale.

    */

    function currentRoundCap() public view returns(uint256) {

        return _currentRoundCap;

    }

    

    /**

    * @return the amount of token issued by the crowdsale.

    */

    function mintedByCrowdsale() public view returns(uint256) {

        return _mintedByCrowdsale;

    }



    /**

    * @return the total round of crowdsales.

    */

    function rounds() public pure returns(uint256) {

        return ROUNDS;

    }



    /**

    * @return the index of current round.

    */

    function currentRound() public view returns(uint256) {

        return _currentRound;

    }



    /**

    * @return the cap of one round (relative value)

    */

    function capOfRound(uint256 index) public view returns(uint256) {

        return _capOfRound[index];

    }



    /**

    * @return the discounted price of the current round

    */

    function pricePercentagePerRound(uint256 index) public view returns(uint256) {

        return _pricePercentagePerRound[index];

    }

    

    /**

    * @notice Checks whether the cap has been reached.

    * @dev These two following functions should not be held because the state should be 

    * reverted, if the condition is met, therefore no more tokens that exceeds the cap

    * shall be minted.

    * @return Whether the cap was reached

    */

    function hardCapReached() public view returns (bool) {

        return _mintedByCrowdsale >= HARD_CAP;

    }



    /**

    * @notice Checks whether the cap has been reached.

    * @return Whether the cap was reached

    */

    function currentRoundCapReached() public view returns (bool) {

        return _mintedByCrowdsale >= _currentRoundCap;

    }



    /**

     * @notice Allows manager to manually close the round

     */

    function closeCurrentRound() public onlyManager stillInRounds {

        _capOfRound[_currentRound] = _mintedByCrowdsale;

        _updateRoundCaps(_currentRound);

    }



    /**

    * @dev Extend parent behavior requiring the crowdsale is in a valid round

    * @param beneficiary Token purchaser

    * @param weiAmount Amount of wei contributed

    */

    function _preValidatePurchase(

        address beneficiary,

        uint256 weiAmount

    )

        internal

        view

        stillInRounds

    {

        super._preValidatePurchase(beneficiary, weiAmount);

    }



    /**

    * @notice Extend parent behavior requiring purchase to respect the max 

    * token cap for crowdsale.

    * @dev If the transaction is about to exceed the hardcap, the crowdsale contract

    * will revert the entire transaction, because the contract will not refund any part

    * of msg.value

    * @param beneficiary Token purchaser

    * @param tokenAmount Amount of tokens purchased

    */

    function _processPurchase(

        address beneficiary,

        uint256 tokenAmount

    )

        internal

    {

        // Check if the hard cap (in IVO) is reached

        // This requirement is actually controlled when calculating the tokenAmount

        // inside _dealWithBigTokenPurchase(). So comment the following ou at the moment

        // require(_mintedByCrowdsale.add(tokenAmount) <= HARD_CAP, "Too many tokens that exceeds the cap");

        // After calculating the generated amount, now update the current round.

        // The following block is to process a purchase with amouts that exceeds the current cap.

        uint256 finalAmount = _mintedByCrowdsale.add(tokenAmount);

        uint256 totalMintedAmount = _mintedByCrowdsale;



        for (uint256 i = _currentRound; i < ROUNDS; i = i.add(1)) {

            if (finalAmount > _capOfRound[i]) {

                sendToCorrectAddress(beneficiary, _capOfRound[i].sub(totalMintedAmount), _currentRound);

                // the rest needs to be dealt in the next round.

                totalMintedAmount = _capOfRound[i];

                _updateRoundCaps(_currentRound);

            } else {

                _mintedByCrowdsale = finalAmount;

                sendToCorrectAddress(beneficiary, finalAmount.sub(totalMintedAmount), _currentRound);

                if (finalAmount == _capOfRound[i]) {

                    _updateRoundCaps(_currentRound);

                }

                break;

            }

        }

    }



    /**

    * @dev Override to extend the way in which ether is converted to tokens.

    * It tokens "discount" into consideration as well as multi-rounds.

    * @param weiAmount Value in wei to be converted into tokens

    * @return Number of tokens that can be purchased with the specified _weiAmount

    */

    function _getTokenAmount(uint256 weiAmount)

        internal view returns (uint256)

    {

        // Here we need to check if all tokens are sold in the same round.

        uint256 tokenAmountBeforeDiscount = super._getTokenAmount(weiAmount);

        uint256 tokenAmountForThisRound;

        uint256 tokenAmountForNextRound;

        uint256 tokenAmount;

        for (uint256 round = _currentRound; round < ROUNDS; round = round.add(1)) {

            (tokenAmountForThisRound, tokenAmountForNextRound) = 

            _dealWithBigTokenPurchase(tokenAmountBeforeDiscount, round);

            tokenAmount = tokenAmount.add(tokenAmountForThisRound);

            if (tokenAmountForNextRound == 0) {

                break;

            } else {

                tokenAmountBeforeDiscount = tokenAmountForNextRound;

            }

        }

        // After three rounds of calculation, there should be no more token to be 

        // purchased in the "next" round. Otherwise, it reaches the hardcap.

        require(tokenAmountForNextRound == 0, "there is still tokens for the next round...");

        return tokenAmount;

    }



    /**

     * @dev Set up addresses for vaults. Should only be called once during.

     * @param privateVault The vault address for private sale

     * @param presaleVault The vault address for presale.

     * @param reserveVault The vault address for reserve.

     */

    function _setVaults(

        IVault privateVault,

        IVault presaleVault,

        IVault reserveVault

    )

        internal

    {

        require(address(privateVault) != address(0), "Not valid address: privateVault");

        require(address(presaleVault) != address(0), "Not valid address: presaleVault");

        require(address(reserveVault) != address(0), "Not valid address: reserveVault");

        privateVaultAddress = address(privateVault);

        presaleVaultAddress = address(presaleVault);

        reserveVaultAddress = address(reserveVault);

    }



    /**

     * @dev When a big token purchase happens, it automatically jumps to the next round if

     * the cap of the current round reaches. 

     * @param tokenAmount The amount of tokens that is converted from wei according to the

     * updatable fiat rate. This amount has not yet taken the discount rate into account.

     * @return The amount of token sold in this round

     * @return The amount of token ready to be sold in the next round.

     */

    function _dealWithBigTokenPurchase(uint256 tokenAmount, uint256 round) 

        private

        view 

        stillInRounds 

        returns (uint256, uint256) 

    {

        // Get the maximum "tokenAmount" that can be issued in the current around with the

        // corresponding discount.

        // maxAmount = (absolut cap of the current round - already issued) * discount

        uint256 maxTokenAmountOfCurrentRound = (_capOfRound[round]

                                                .sub(_mintedByCrowdsale))

                                                .mul(_pricePercentagePerRound[round])

                                                .div(PRICE_PERCENTAGE_BASE);

        if (tokenAmount < maxTokenAmountOfCurrentRound) {

            // this purchase will be settled entirely in the current round

            return (tokenAmount.mul(PRICE_PERCENTAGE_BASE).div(_pricePercentagePerRound[round]), 0);

        } else {

            // need to consider cascading to the next round

            uint256 tokenAmountOfNextRound = tokenAmount.sub(maxTokenAmountOfCurrentRound);

            return (maxTokenAmountOfCurrentRound, tokenAmountOfNextRound);

        }

    }



    /**

     * @dev this function delivers token according to the information of the current round...

     * @param beneficiary The address of the account that should receive tokens in reality

     * @param tokenAmountToBeSent The amount of token sent to the destination addression.

     * @param roundNumber Round number where tokens shall be purchased...

     */

    function sendToCorrectAddress(

        address beneficiary, 

        uint256 tokenAmountToBeSent,

        uint256 roundNumber

    )

        private 

        vaultAddressesSet

    {

        if (roundNumber == 2) {

            // then tokens could be minted directly to holder's account

            // the amount shall be the 

            super._processPurchase(beneficiary, tokenAmountToBeSent);

        } else if (roundNumber == 0) {

            // tokens should be minted to the private sale vault...

            super._processPurchase(privateVaultAddress, tokenAmountToBeSent);

            // update the balance of the corresponding vault

            IVault(privateVaultAddress).receiveFor(beneficiary, tokenAmountToBeSent);

        } else {

            // _currentRound == 1, tokens should be minted to the presale vault

            super._processPurchase(presaleVaultAddress, tokenAmountToBeSent);

            // update the balance of the corresponding vault

            IVault(presaleVaultAddress).receiveFor(beneficiary, tokenAmountToBeSent);

        }

    }



    /**

     * @notice Eachtime, when a manager closes a round or a round_cap is reached, it needs

     * to update the info of the _currentRound, _currentRoundCap, _hardCap and _capPerRound[];

     * @param round currentRound number

     * @dev This function should only be triggered when there is a need of updating all

     * the params. The capPerRound shall be updated with the current mintedValue.

     */

    function _updateRoundCaps(uint256 round) private {

        if (round == 0) {

            // update the releasing time of private sale vault

            IVault(privateVaultAddress).updateReleaseTime(block.timestamp);

            _currentRound = 1;

            _currentRoundCap = _capOfRound[1];

        } else if (round == 1) {

            // update the releasing time of presale vault

            IVault(presaleVaultAddress).updateReleaseTime(block.timestamp);

            _currentRound = 2;

            _currentRoundCap = _capOfRound[2];

        } else {

            // when _currentRound == 2

            IVault(reserveVaultAddress).updateReleaseTime(block.timestamp);

            // finalize the crowdsale

            _currentRound = 3;

            _currentRoundCap = _capOfRound[2];

        }

        emit RoundStarted(_currentRound, block.timestamp);

    }

}



// File: contracts/crowdsale/PausableCrowdsale.sol



/**

 * @title Crowdsale with check on pausible

 * @dev Functionalities in this contract could also be pausable, besides managerOnly

 * This contract is similar to OpenZeppelin's PausableCrowdsale, yet with different 

 * contract inherited

 * @author Validity Labs AG <info@validitylabs.org>

 */

// solhint-disable-next-line compiler-fixed, compiler-gt-0_5

pragma solidity ^0.5.0;









contract PausableCrowdsale is PausableManager, Crowdsale {



    /**

     * @notice Validation of an incoming purchase.

     * @dev Use require statements to revert state when conditions are not met. Adding

     * the validation that the crowdsale must not be paused.

     * @param _beneficiary Address performing the token purchase

     * @param _weiAmount Value in wei involved in the purchase

     */

    function _preValidatePurchase(

        address _beneficiary, 

        uint256 _weiAmount

    )

        internal 

        view 

        whenNotPaused 

    {

        return super._preValidatePurchase(_beneficiary, _weiAmount);

    }



}



// File: contracts/crowdsale/StartingTimedCrowdsale.sol



/**

 * @title Crowdsale with a limited opening time

 * @dev This contract is developed based on OpenZeppelin's TimedCrowdsale contract 

 * but removing the endTime. As the function `hasEnded()` is public accessible and 

 * necessary to return true when the crowdsale is ready to be finalized, yet no direct

 * link exists between the time and the end, here we take OZ's originalCrowdsale contract

 * and tweak according to the need.

 * @author Validity Labs AG <info@validitylabs.org>

 */

// solhint-disable-next-line compiler-fixed, compiler-gt-0_5

pragma solidity ^0.5.0;









contract StartingTimedCrowdsale is Crowdsale {

    using SafeMath for uint256;



    uint256 private _startingTime;



    /**

    * @notice Reverts if not in crowdsale time range.

    */

    modifier onlyWhileOpen {

        require(isStarted(), "Not yet started");

        _;

    }



    /**

    * @notice Constructor, takes crowdsale opening and closing times.

    * @param startingTime Crowdsale opening time

    */

    constructor(uint256 startingTime) internal {

        // solium-disable-next-line security/no-block-members

        require(startingTime >= block.timestamp, "Starting time is in the past");



        _startingTime = startingTime;

    }



    /**

    * @return the crowdsale opening time.

    */

    function startingTime() public view returns(uint256) {

        return _startingTime;

    }



    /**

    * @return true if the crowdsale is open, false otherwise.

    */

    function isStarted() public view returns (bool) {

        // solium-disable-next-line security/no-block-members

        return block.timestamp >= _startingTime;

    }



    /**

    * @notice Extend parent behavior requiring to be within contributing period

    * @param beneficiary Token purchaser

    * @param weiAmount Amount of wei contributed

    */

    function _preValidatePurchase(

        address beneficiary,

        uint256 weiAmount

    )

        internal

        onlyWhileOpen

        view

    {

        super._preValidatePurchase(beneficiary, weiAmount);

    }

}



// File: contracts/crowdsale/FinalizableCrowdsale.sol



/**

 * @title Finalizable crowdsale

 * @dev This contract is developed based on OpenZeppelin's FinalizableCrowdsale contract 

 * with a different inherited contract. 

 * @author Validity Labs AG <info@validitylabs.org>

 */

// solhint-disable-next-line compiler-fixed, compiler-gt-0_5

pragma solidity ^0.5.0;









/**

 * @title FinalizableCrowdsale

 * @notice Extension of Crowdsale with a one-off finalization action, where one

 * can do extra work after finishing.

 * @dev Slightly different from OZ;s contract, due to the inherited "TimedCrowdsale" 

 * contract

 */

contract FinalizableCrowdsale is StartingTimedCrowdsale {

    using SafeMath for uint256;



    bool private _finalized;



    event CrowdsaleFinalized(address indexed account);



    constructor () internal {

        _finalized = false;

    }



    /**

     * @return true if the crowdsale is finalized, false otherwise.

     */

    function finalized() public view returns (bool) {

        return _finalized;

    }



    /**

     * @notice Must be called after crowdsale ends, to do some extra finalization

     * work. Calls the contract's finalization function.

     * @dev The requirement of endingTimeis removed

     */

    function finalize() public {

        require(!_finalized, "already finalized");



        _finalized = true;



        emit CrowdsaleFinalized(msg.sender);

    }

}



// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol



pragma solidity ^0.5.0;







/**

 * @dev Implementation of the `IERC20` interface.

 *

 * This implementation is agnostic to the way tokens are created. This means

 * that a supply mechanism has to be added in a derived contract using `_mint`.

 * For a generic mechanism see `ERC20Mintable`.

 *

 * *For a detailed writeup see our guide [How to implement supply

 * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*

 *

 * We have followed general OpenZeppelin guidelines: functions revert instead

 * of returning `false` on failure. This behavior is nonetheless conventional

 * and does not conflict with the expectations of ERC20 applications.

 *

 * Additionally, an `Approval` event is emitted on calls to `transferFrom`.

 * This allows applications to reconstruct the allowance for all accounts just

 * by listening to said events. Other implementations of the EIP may not emit

 * these events, as it isn't required by the specification.

 *

 * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`

 * functions have been added to mitigate the well-known issues around setting

 * allowances. See `IERC20.approve`.

 */

contract ERC20 is IERC20 {

    using SafeMath for uint256;



    mapping (address => uint256) private _balances;



    mapping (address => mapping (address => uint256)) private _allowances;



    uint256 private _totalSupply;



    /**

     * @dev See `IERC20.totalSupply`.

     */

    function totalSupply() public view returns (uint256) {

        return _totalSupply;

    }



    /**

     * @dev See `IERC20.balanceOf`.

     */

    function balanceOf(address account) public view returns (uint256) {

        return _balances[account];

    }



    /**

     * @dev See `IERC20.transfer`.

     *

     * Requirements:

     *

     * - `recipient` cannot be the zero address.

     * - the caller must have a balance of at least `amount`.

     */

    function transfer(address recipient, uint256 amount) public returns (bool) {

        _transfer(msg.sender, recipient, amount);

        return true;

    }



    /**

     * @dev See `IERC20.allowance`.

     */

    function allowance(address owner, address spender) public view returns (uint256) {

        return _allowances[owner][spender];

    }



    /**

     * @dev See `IERC20.approve`.

     *

     * Requirements:

     *

     * - `spender` cannot be the zero address.

     */

    function approve(address spender, uint256 value) public returns (bool) {

        _approve(msg.sender, spender, value);

        return true;

    }



    /**

     * @dev See `IERC20.transferFrom`.

     *

     * Emits an `Approval` event indicating the updated allowance. This is not

     * required by the EIP. See the note at the beginning of `ERC20`;

     *

     * Requirements:

     * - `sender` and `recipient` cannot be the zero address.

     * - `sender` must have a balance of at least `value`.

     * - the caller must have allowance for `sender`'s tokens of at least

     * `amount`.

     */

    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {

        _transfer(sender, recipient, amount);

        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));

        return true;

    }



    /**

     * @dev Atomically increases the allowance granted to `spender` by the caller.

     *

     * This is an alternative to `approve` that can be used as a mitigation for

     * problems described in `IERC20.approve`.

     *

     * Emits an `Approval` event indicating the updated allowance.

     *

     * Requirements:

     *

     * - `spender` cannot be the zero address.

     */

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {

        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));

        return true;

    }



    /**

     * @dev Atomically decreases the allowance granted to `spender` by the caller.

     *

     * This is an alternative to `approve` that can be used as a mitigation for

     * problems described in `IERC20.approve`.

     *

     * Emits an `Approval` event indicating the updated allowance.

     *

     * Requirements:

     *

     * - `spender` cannot be the zero address.

     * - `spender` must have allowance for the caller of at least

     * `subtractedValue`.

     */

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {

        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));

        return true;

    }



    /**

     * @dev Moves tokens `amount` from `sender` to `recipient`.

     *

     * This is internal function is equivalent to `transfer`, and can be used to

     * e.g. implement automatic token fees, slashing mechanisms, etc.

     *

     * Emits a `Transfer` event.

     *

     * Requirements:

     *

     * - `sender` cannot be the zero address.

     * - `recipient` cannot be the zero address.

     * - `sender` must have a balance of at least `amount`.

     */

    function _transfer(address sender, address recipient, uint256 amount) internal {

        require(sender != address(0), "ERC20: transfer from the zero address");

        require(recipient != address(0), "ERC20: transfer to the zero address");



        _balances[sender] = _balances[sender].sub(amount);

        _balances[recipient] = _balances[recipient].add(amount);

        emit Transfer(sender, recipient, amount);

    }



    /** @dev Creates `amount` tokens and assigns them to `account`, increasing

     * the total supply.

     *

     * Emits a `Transfer` event with `from` set to the zero address.

     *

     * Requirements

     *

     * - `to` cannot be the zero address.

     */

    function _mint(address account, uint256 amount) internal {

        require(account != address(0), "ERC20: mint to the zero address");



        _totalSupply = _totalSupply.add(amount);

        _balances[account] = _balances[account].add(amount);

        emit Transfer(address(0), account, amount);

    }



     /**

     * @dev Destoys `amount` tokens from `account`, reducing the

     * total supply.

     *

     * Emits a `Transfer` event with `to` set to the zero address.

     *

     * Requirements

     *

     * - `account` cannot be the zero address.

     * - `account` must have at least `amount` tokens.

     */

    function _burn(address account, uint256 value) internal {

        require(account != address(0), "ERC20: burn from the zero address");



        _totalSupply = _totalSupply.sub(value);

        _balances[account] = _balances[account].sub(value);

        emit Transfer(account, address(0), value);

    }



    /**

     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.

     *

     * This is internal function is equivalent to `approve`, and can be used to

     * e.g. set automatic allowances for certain subsystems, etc.

     *

     * Emits an `Approval` event.

     *

     * Requirements:

     *

     * - `owner` cannot be the zero address.

     * - `spender` cannot be the zero address.

     */

    function _approve(address owner, address spender, uint256 value) internal {

        require(owner != address(0), "ERC20: approve from the zero address");

        require(spender != address(0), "ERC20: approve to the zero address");



        _allowances[owner][spender] = value;

        emit Approval(owner, spender, value);

    }



    /**

     * @dev Destoys `amount` tokens from `account`.`amount` is then deducted

     * from the caller's allowance.

     *

     * See `_burn` and `_approve`.

     */

    function _burnFrom(address account, uint256 amount) internal {

        _burn(account, amount);

        _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));

    }

}



// File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol



pragma solidity ^0.5.0;





contract MinterRole {

    using Roles for Roles.Role;



    event MinterAdded(address indexed account);

    event MinterRemoved(address indexed account);



    Roles.Role private _minters;



    constructor () internal {

        _addMinter(msg.sender);

    }



    modifier onlyMinter() {

        require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");

        _;

    }



    function isMinter(address account) public view returns (bool) {

        return _minters.has(account);

    }



    function addMinter(address account) public onlyMinter {

        _addMinter(account);

    }



    function renounceMinter() public {

        _removeMinter(msg.sender);

    }



    function _addMinter(address account) internal {

        _minters.add(account);

        emit MinterAdded(account);

    }



    function _removeMinter(address account) internal {

        _minters.remove(account);

        emit MinterRemoved(account);

    }

}



// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol



pragma solidity ^0.5.0;







/**

 * @dev Extension of `ERC20` that adds a set of accounts with the `MinterRole`,

 * which have permission to mint (create) new tokens as they see fit.

 *

 * At construction, the deployer of the contract is the only minter.

 */

contract ERC20Mintable is ERC20, MinterRole {

    /**

     * @dev See `ERC20._mint`.

     *

     * Requirements:

     *

     * - the caller must have the `MinterRole`.

     */

    function mint(address account, uint256 amount) public onlyMinter returns (bool) {

        _mint(account, amount);

        return true;

    }

}



// File: openzeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol



pragma solidity ^0.5.0;







/**

 * @title MintedCrowdsale

 * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.

 * Token ownership should be transferred to MintedCrowdsale for minting.

 */

contract MintedCrowdsale is Crowdsale {

    /**

     * @dev Overrides delivery by minting tokens upon purchase.

     * @param beneficiary Token purchaser

     * @param tokenAmount Number of tokens to be minted

     */

    function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {

        // Potentially dangerous assumption about the type of the token.

        require(

            ERC20Mintable(address(token())).mint(beneficiary, tokenAmount),

                "MintedCrowdsale: minting failed"

        );

    }

}



// File: contracts/crowdsale/IvoCrowdsale.sol



/**

 * @title INVAO Crowdsale

 * @author Validity Labs AG <info@validitylabs.org>

 */

// solhint-disable-next-line compiler-fixed, compiler-gt-0_5

pragma solidity ^0.5.0;





























contract IvoCrowdsale is IIvoCrowdsale, CounterGuard, Reclaimable, MintedCrowdsale, 

    NonEthPurchasableCrowdsale, CappedMultiRoundCrowdsale, WhitelistCrowdsale, 

    PausableCrowdsale, FinalizableCrowdsale {

    /*** PRE-DEPLOYMENT CONFIGURED CONSTANTS */

    uint256 private constant ROUNDS = 3;

    uint256 private constant KYC_AML_RATE_DEDUCTED = 965;

    uint256 private constant KYC_AML_FEE_BASE = 1000;

    bool private _setRole;



    /**

     * @param startingTime The starting time of the crowdsale

     * @param rate Token per wei. This rate is going to be overriden, hence not important.

     * @param initialFiatRate USD per ETH. (As the number on CoinMarketCap.com)

     * Value written in cent.

     * @param wallet The address of the team which receives investors ETH payment.

     * @param token The address of the token.

     */

    /* solhint-disable */

    constructor(

        uint256 startingTime,

        uint256 rate,

        uint256 initialFiatRate,

        address payable wallet, 

        IERC20 token

    ) 

        public

        Crowdsale(rate, wallet, token)

        UpdatableRateCrowdsale(initialFiatRate)

        CappedMultiRoundCrowdsale(startingTime)

        StartingTimedCrowdsale(startingTime) {}

    /* solhint-enable */

    

    /**

     * @notice Batch minting tokens for investors paid with non-ETH

     * @param beneficiaries Recipients of the token purchase

     * @param amounts Amounts of token purchased

     */

    function nonEthPurchases(

        address[] calldata beneficiaries, 

        uint256[] calldata amounts

    ) 

        external

        onlyManager 

    {

        uint256 length = amounts.length;

        require(beneficiaries.length == length, "length !=");

        require(length <= 256, "To long, please consider shorten the array");

        for (uint256 i = 0; i < length; i++) {

            super.nonEthPurchase(beneficiaries[i], amounts[i]);

        }

    }

    

    /** OVERRIDE

     * @notice Allows onlyManager to mint token for beneficiaries.

     * @param beneficiary Recipient of the token purchase

     * @param tokenAmount Amount of token purchased

     */

    function nonEthPurchase(address beneficiary, uint256 tokenAmount) 

        public 

        onlyManager 

    {

        super.nonEthPurchase(beneficiary, tokenAmount);

    }



    /**

     * @notice Allows manager to manually close the round

     */

    function closeCurrentRound() public onlyWhileOpen {

        super.closeCurrentRound();

    }



    /**

     * @notice setup roles and contract addresses for the crowdsale contract

     * @dev This function can only be called once by the owner.

     * @param newOwner The address of the new owner/manager.

     * @param privateVault The address of private sale vault

     * @param presaleVault The address of presale vault.

     * @param reserveVault The address of reverve vault.

     */

    function roleSetup(

        address newOwner,

        IVault privateVault,

        IVault presaleVault,

        IVault reserveVault

    )

        public

        onlyOwner

        onlyOnce(_setRole)

    {

        _setVaults(privateVault, presaleVault, reserveVault);

        addManager(newOwner);

        _removeManager(msg.sender);

        transferOwnership(newOwner);

        _setRole = true;

    }



     /** OVERRIDE

     * @notice Specify the actions in the finalization of the crowdsale. 

     * Add the manager as a token minter and renounce itself the minter role

     * role of the token contract. 

     */

    function finalize() public onlyManager {

        require(this.currentRound() == ROUNDS, "Multi-rounds has not yet completed");

        super.finalize();

        PausableManager(address(token())).unpause();

        ERC20Mintable(address(token())).addMinter(msg.sender);

        ERC20Mintable(address(token())).renounceMinter();

    }



    /*** INTERNAL/PRIVATE ***/    

    /** OVERRIDE

    * @notice Calculate the usable wei after taking out the KYC/AML fee, i.e. 96.5 %

    * @dev Override to extend the way in which ether is converted to tokens.

    * @param weiAmount Value in wei to be converted into tokens

    * @return Number of tokens that can be purchased after deducting the AML/KYC fee.

    */

    function _getTokenAmount(uint256 weiAmount)

        internal

        view 

        returns (uint256)

    {

        uint256 availableWei = weiAmount.mul(KYC_AML_RATE_DEDUCTED).div(KYC_AML_FEE_BASE);

        return super._getTokenAmount(availableWei);

    }

}

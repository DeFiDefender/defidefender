// File: contracts\\SafeMath.sol



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



// File: contracts\\Context.sol



pragma solidity ^0.5.0;



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



// File: contracts\\Ownable.sol



pragma solidity ^0.5.0;



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

        require(newOwner != address(0), "Ownable: new owner is the zero address");

        emit OwnershipTransferred(_owner, newOwner);

        _owner = newOwner;

    }

}



// File: contracts\\IERC20.sol



pragma solidity ^0.5.0;



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



// File: contracts\\Address.sol



pragma solidity ^0.5.5;



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

     * @dev Converts an `address` into `address payable`. Note that this is

     * simply a type cast: the actual underlying value is not changed.

     *

     * _Available since v2.4.0._

     */

    function toPayable(address account) internal pure returns (address payable) {

        return address(uint160(account));

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

     *

     * _Available since v2.4.0._

     */

    function sendValue(address payable recipient, uint256 amount) internal {

        require(address(this).balance >= amount, "Address: insufficient balance");



        // solhint-disable-next-line avoid-call-value

        (bool success, ) = recipient.call.value(amount)("");

        require(success, "Address: unable to send value, recipient may have reverted");

    }

}



// File: contracts\\SafeERC20.sol



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

        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");

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



// File: contracts\\ReentrancyGuard.sol



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



// File: contracts\\Crowdsale.sol



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

contract Crowdsale is Context, ReentrancyGuard {

    // Humanity test

    modifier onlyHuman {

        if (_isHuman()) {

            _;

        }

    }



    using SafeMath for uint256;

    using SafeERC20 for IERC20;



    // The token being sold

    IERC20 private _token;



    // Addresses where funds are collected

    address payable private _platformWallet;

    address payable private _priceTokenBackingWallet;

    address payable private _investBoxWallet;

    address payable private _otherWallet;



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

     * @dev standard crowdale Constructor

     * @param platformWallet The address where the funds raised for the development of the platform will be directed

     * @param priceTokenBackingWallet The address where the funds raised to support the token price on the exchange will be sent

     * @param investBoxWallet Address where the funds raised for investBox will be directed

     * @param otherWallet Address where the rest of the collected funds will be sent

     * @param token Address of the token being sold

     */

    constructor (

        address payable platformWallet,

        address payable priceTokenBackingWallet,

        address payable investBoxWallet,

        address payable otherWallet,

        IERC20 token

    )

    public

    {

        require(platformWallet != address(0), "Crowdsale: platformWallet is the zero address");

        require(priceTokenBackingWallet != address(0), "Crowdsale: priceTokenBackingWallet is the zero address");

        require(investBoxWallet != address(0), "Crowdsale: investBoxWallet is the zero address");

        require(otherWallet != address(0), "Crowdsale: otherWallet is the zero address");

        require(address(token) != address(0), "Crowdsale: token is the zero address");



        _platformWallet = platformWallet;

        _priceTokenBackingWallet = priceTokenBackingWallet;

        _investBoxWallet = investBoxWallet;

        _otherWallet = otherWallet;

        _token = token;

    }



    /**

     * @dev fallback function ***DO NOT OVERRIDE***

     * Note that other contracts will transfer funds with a base gas stipend

     * of 2300, which is not enough to call buyTokens. Consider calling

     * buyTokens directly when purchasing tokens from a contract.

     */

    function () external onlyHuman payable {

        buyTokens(_msgSender());

    }



    /**

     * @dev Checking if the calling function is a contract

     */

    function _isContract() view internal returns(bool) {

        return msg.sender != tx.origin;

    }



    /**

     * @dev Humanity test

     */

    function _isHuman() view internal returns(bool) {

        return !_isContract();

    }



    /**

     * @return the token being sold.

     */

    function token() public view returns (IERC20) {

        return _token;

    }



    /**

     * @return the address where the funds raised for the development of the platform are collected.

     */

    function platformWallet() public view returns (address payable) {

        return _platformWallet;

    }



    /**

     * @return the number of token units a buyer gets per wei.

     */

    function rate() public view returns (uint256) {

        return _rate;

    }



    /**

     * @dev internal function for setting the amount of tokens that the buyer receives for the vey.

     * Used to change the price during the transition from stage to stage

     */

    function setRate(uint256 stageRate) internal {

        _rate = stageRate;

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

    function buyTokens(address beneficiary) public nonReentrant onlyHuman payable {

        uint256 weiAmount = msg.value;

        _preValidatePurchase(beneficiary, weiAmount);



        // calculate token amount to be created

        uint256 tokens = _getTokenAmount(weiAmount);



        // update state

        _weiRaised = _weiRaised.add(weiAmount);



        _processPurchase(beneficiary, tokens);

        emit TokensPurchased(_msgSender(), beneficiary, weiAmount, tokens);



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



        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691

    }



    /**

     * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid

     * conditions are not met.

     * @param beneficiary Address performing the token purchase

     * @param weiAmount Value in wei involved in the purchase

     */

    function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal {

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

        uint256 sum = msg.value;

        uint256 platformSum = sum.div(100).mul(25);

        uint256 backingSum = sum.div(100).mul(7);

        uint256 investBoxSum = sum.div(100).mul(10);

        uint256 buyoutSum = sum.div(100).mul(20);

        uint256 otherSum = sum.sub(platformSum).sub(backingSum).sub(investBoxSum).sub(buyoutSum);



        _platformWallet.transfer(platformSum);

        _priceTokenBackingWallet.transfer(backingSum);

        _investBoxWallet.transfer(investBoxSum);

        _otherWallet.transfer(otherSum);

    }

}



// File: contracts\\StatCrowdsale.sol



pragma solidity ^0.5.0;

pragma experimental ABIEncoderV2;







/**

 * @title Crowdsale statistics

 * @dev To collect crowdsale statistics

 */

contract StatCrowdsale is Crowdsale {

    struct partDist {   // A structural unit indicating whether the address to which this unit belongs is involved in the distribution of unsold tokens at each stage

        uint256 sumWei;     // the amount of wei spent by the address in the stage

        uint256 sumHpa;     // the amount of tokens acquired by the address at the stage

        bool part;          // true if the address is involved in the distribution of unsold tokens

    }



    struct stageStat {          // Stage statistics unit

        uint256 tokensSold;         // The number of tokens sold at the stage

        uint256 numPurchases;       // Number of purchases per stage

        uint256 tokensUnsold;       // The number of unsold tokens at the stage

        uint256 numBuyersDist;      // The number of participants in the distribution of unsold tokens at the stage

        mapping (address => partDist) partsDist;    // indicates whether the address is involved in the distribution of unsold tokens at each stage

        uint256 start;              // Stage Start Time (in timestamp)

        uint256 end;                // Stage End Time (in timestamp)

    }



    struct buyerStat {              //Buyer Statistics unit

        buyerReferral[] referrals;      // Array of referral addresses for this customer

        uint256 numReferrals;           // Number of customer referrals

        mapping (uint256 => bool) stagesPartDist;   // Stages in which a given buyer is involved in the distribution of unsold tokens

        purchase[] purchases;           // Purchase statistics

        uint256 numPurchases;           // Number of purchases

    }



    struct buyerReferral {      // The structural unit of statistics on referrals for the buyer

        address referral;           // Referral Address

        uint256 referralSum;        // The amount of tokens brought by a referral

        uint256 referralEth;        // The amount of ether (in wei) that the referral brought

    }



    struct purchase {       // Purchase Statistics Unit

        uint256 stage;          // Stage at which the purchase was made

        uint256 price;          // The price for the token at which the purchase was made

        uint256 sumEth;         // Amount of spent ether (in wei)

        uint256 sumHpa;         // Amount of purchased tokens

        uint256 time;           // Purchase time

    }



    // Stage Statistics

    stageStat[15] internal _stagesStats;

    // Customer statistics

    mapping (address => buyerStat) internal buyersStats;



    /**

     * @dev When creating a contract, initial statistics for the stages are set

     */

    constructor () public {

        setStageStat(0,0,0,0,0);

        setStageStat(1,0,0,50000 ether,0);

        setStageStat(2,0,0,500000 ether,0);

        setStageStat(3,0,0,2500000 ether,0);

        setStageStat(4,0,0,7500000 ether,0);

        setStageStat(5,0,0,15000000 ether,0);

        setStageStat(6,0,0,22500000 ether,0);

        setStageStat(7,0,0,10000000 ether,0);

        setStageStat(8,0,0,5000000 ether,0);

        setStageStat(9,0,0,3000000 ether,0);

        setStageStat(10,0,0,1000000 ether,0);

        setStageStat(11,0,0,500004 ether,0);

        setStageStat(12,0,0,200004 ether,0);

        setStageStat(13,0,0,100002 ether,0);

        setStageStat(14,0,0,50000 ether,0);

    }



    /**

    * @dev sets statistics for the stage

    * @param stageNumber The stage number

    * @param tokensSold The number of tokens sold at the stage

    * @param numPurchases Number of purchases per stage

    * @param tokensUnsold The number of unsold tokens at the stage

    * @param numBuyersDist The number of participants in the distribution of unsold tokens at the stage

    */

    function setStageStat(

        uint256 stageNumber,

        uint256 tokensSold,

        uint256 numPurchases,

        uint256 tokensUnsold,

        uint256 numBuyersDist

    )

    internal

    {

        _stagesStats[stageNumber] = stageStat({

            tokensSold: tokensSold,

            numPurchases: numPurchases,

            tokensUnsold: tokensUnsold,

            numBuyersDist: numBuyersDist,

            start: 0,

            end: 0

            });

    }



    /**

     * @return stage stats.

     * @param s stage

     */

    function viewStageStat(uint256 s) public view returns (uint256, uint256, uint256, uint256, uint256, uint256) {

        stageStat memory _stat = _stagesStats[s];

        return (_stat.tokensSold, _stat.numPurchases, _stat.tokensUnsold, _stat.numBuyersDist, _stat.start, _stat.end);

    }



    /**

     * @dev sets the start time of the stage

     * @param stageNumber The stage number

     * @param time timestamp

     */

    function setStageStartTime(uint256 stageNumber, uint256 time) internal {

        _stagesStats[stageNumber].start = time;

    }



    /**

     * @dev sets stage end time

     * @param stageNumber The stage number

     * @param time timestamp

     */

    function setStageEndTime(uint256 stageNumber, uint256 time) internal {

        _stagesStats[stageNumber].end = time;

    }



    /**

     * @dev records referral statistics for the specified referrer

     * @param referer who attracted

     * @param referral who attracted

     * @param sum earn HPA tokens

     * @param sumEth earn ether

     */

    function addReferralStat(address referer, address referral, uint256 sum, uint256 sumEth) internal {

        buyersStats[referer].referrals.push(buyerReferral({

            referral: referral,

            referralSum: sum,

            referralEth: sumEth

            }));

        buyersStats[referer].numReferrals = buyersStats[referer].numReferrals.add(1);

    }



    /**

     * @return information about the participation of the specified buyer

     * in the distribution of unsold tokens at the specified stage

     * @param stage for what stage information is requested

     * @param buyer for which participant information is requested

     */

    function getBuyerStagePartDistInfo(uint256 stage, address buyer) public view returns (uint256, uint256, bool) {

        return (

        _stagesStats[stage].partsDist[buyer].sumWei,

        _stagesStats[stage].partsDist[buyer].sumHpa,

        _stagesStats[stage].partsDist[buyer].part

        );

    }



    /**

     * @return statistics on purchases of the address that called this function

     */

    function getMyInfo() public view returns (uint256, buyerReferral[] memory, uint256, purchase[] memory) {

        address buyer = msg.sender;

        return (

        buyersStats[buyer].numReferrals,

        buyersStats[buyer].referrals,

        buyersStats[buyer].numPurchases,

        buyersStats[buyer].purchases

        );

    }

}



// File: contracts\\ERC20.sol



pragma solidity ^0.5.0;









/**

 * @dev Implementation of the {IERC20} interface.

 *

 * This implementation is agnostic to the way tokens are created. This means

 * that a supply mechanism has to be added in a derived contract using {_mint}.

 * For a generic mechanism see {ERC20Mintable}.

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



    mapping (address => uint256) private _balances;



    mapping (address => mapping (address => uint256)) private _allowances;



    uint256 private _totalSupply;



    /**

     * @dev See {IERC20-totalSupply}.

     */

    function totalSupply() public view returns (uint256) {

        return _totalSupply;

    }



    /**

     * @dev See {IERC20-balanceOf}.

     */

    function balanceOf(address account) public view returns (uint256) {

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

    function transfer(address recipient, uint256 amount) public returns (bool) {

        _transfer(_msgSender(), recipient, amount);

        return true;

    }



    /**

     * @dev See {IERC20-allowance}.

     */

    function allowance(address owner, address spender) public view returns (uint256) {

        return _allowances[owner][spender];

    }



    /**

     * @dev See {IERC20-approve}.

     *

     * Requirements:

     *

     * - `spender` cannot be the zero address.

     */

    function approve(address spender, uint256 amount) public returns (bool) {

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

     * - the caller must have allowance for `sender`'s tokens of at least

     * `amount`.

     */

    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {

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

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {

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

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {

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

    function _transfer(address sender, address recipient, uint256 amount) internal {

        require(sender != address(0), "ERC20: transfer from the zero address");

        require(recipient != address(0), "ERC20: transfer to the zero address");



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

    function _mint(address account, uint256 amount) internal {

        require(account != address(0), "ERC20: mint to the zero address");



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

    function _burn(address account, uint256 amount) internal {

        require(account != address(0), "ERC20: burn from the zero address");



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

    function _approve(address owner, address spender, uint256 amount) internal {

        require(owner != address(0), "ERC20: approve from the zero address");

        require(spender != address(0), "ERC20: approve to the zero address");



        _allowances[owner][spender] = amount;

        emit Approval(owner, spender, amount);

    }



    /**

     * @dev Destroys `amount` tokens from `account`.`amount` is then deducted

     * from the caller's allowance.

     *

     * See {_burn} and {_approve}.

     */

    function _burnFrom(address account, uint256 amount) internal {

        _burn(account, amount);

        _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));

    }

}



// File: contracts\\Roles.sol



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



// File: contracts\\MinterRole.sol



pragma solidity ^0.5.0;







contract MinterRole is Context {

    using Roles for Roles.Role;



    event MinterAdded(address indexed account);

    event MinterRemoved(address indexed account);



    Roles.Role private _minters;



    constructor () internal {

        _addMinter(_msgSender());

    }



    modifier onlyMinter() {

        require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");

        _;

    }



    function isMinter(address account) public view returns (bool) {

        return _minters.has(account);

    }



    function addMinter(address account) public onlyMinter {

        _addMinter(account);

    }



    function renounceMinter() public {

        _removeMinter(_msgSender());

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



// File: contracts\\ERC20Mintable.sol



pragma solidity ^0.5.0;







/**

 * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},

 * which have permission to mint (create) new tokens as they see fit.

 *

 * At construction, the deployer of the contract is the only minter.

 */

contract ERC20Mintable is ERC20, MinterRole {

    /**

     * @dev See {ERC20-_mint}.

     *

     * Requirements:

     *

     * - the caller must have the {MinterRole}.

     */

    function mint(address account, uint256 amount) public onlyMinter returns (bool) {

        _mint(account, amount);

        return true;

    }

}



// File: contracts\\MintedCrowdsale.sol



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



// File: contracts\\ReferralCrowdsale.sol



pragma solidity ^0.5.0;









/**

 * @title Referral Crowdsale

 * @dev Crowdsale with referral reward system for attracting participants

 */

contract ReferralCrowdsale is StatCrowdsale, MintedCrowdsale {

    // Referrals persent

    uint256 private _refPercent;



    /**

     * @dev Sets the initial percentage that the referrer receives from the purchase of a referral

     * @param startPercent initial percentage

     */

    constructor (uint256 startPercent) public {

        require(startPercent > 0, "ReferralCrowdsale: percentage must be greater than zero");



        _refPercent = startPercent;

    }



    /**

     * @return the referral percent.

     */

    function refPercent() public view returns (uint256) {

        return _refPercent;

    }



    /**

    * @dev setup referral percent for current stage

    * @param stageRefPercent Referral percent

    */

    function setRefPercent(uint256 stageRefPercent) internal {

        _refPercent = stageRefPercent;

    }



    function bytesToAddress(bytes memory source) internal pure returns(address) {

        uint result;

        uint mul = 1;

        for(uint i = 20; i > 0; i--) {

            result += uint8(source[i-1])*mul;

            mul = mul*256;

        }

        return address(result);

    }



    /**

     * @dev calculate and transfer tokens to refer

     * @param beneficiary Address performing the token purchase

     * @param weiAmount Value in wei involved in the purchase

     */

    function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal {



        uint256 tokens = _getTokenAmount(weiAmount);



        if(msg.data.length == 20) {

            address referer = bytesToAddress(bytes(msg.data));

            address payable refererPayable = address(uint160(referer));

            require(referer != beneficiary, "Referral crowdsale: The beneficiary cannot be a referer");

            require(referer != msg.sender, "Referral crowdsale: The sender cannot be a referer");

            require(referer != address(0), "Referral crowdsale: referer is the zero address");

            uint refererTokens = tokens.mul(_refPercent).div(100);

            uint256 refSum = weiAmount.div(100).mul(10);

            // transfer tokens to refer

            emit TokensPurchased(_msgSender(), beneficiary, 0, refererTokens);

            addReferralStat(referer, beneficiary, refererTokens, refSum);

            _deliverTokens(referer, refererTokens);

            refererPayable.transfer(refSum);

        }

    }

}



// File: contracts\\StagesCrowdsale.sol



pragma solidity ^0.5.0;









/**

 * @title StagesCrowdsale

 * @dev Crowdsale passing through stages with limits and a time limit.

 */

contract StagesCrowdsale is ReferralCrowdsale, Ownable {

    using SafeMath for uint256;



    // Current stage

    uint256 private _currentStage;



    struct stage {                  // Structural Unit of Stage Parameters

        uint256 rate;

        uint256 cap;

        uint256 refPercent;

        uint256 unsoldDistPercent;

        uint256 minEthDist;

        uint256 minHpaDist;

        uint256 period;

    }



    // Parameters of all stages

    stage[15] internal _stages;



    /**

     * Stage close event

     * @param stage closing stage

     * @param time closing time

     */

    event CloseStage(uint256 stage, uint256 time);

    /**

     * Stage opening event

     * @param stage open stage

     * @param time opening time

     */

    event OpenStage(uint256 stage, uint256 time);



    /**

     * @dev When creating a contract, stage parameters and other parameters are set

     */

    constructor () public ReferralCrowdsale(5) {

        setStage(0,0,0,0,0,0,0,0);

        setStage(1,100000000,500 szabo,5,0,0,0,0);

        setStage(2,10000000,50500 szabo,5,0,0,0,0);

        setStage(3,1000000,2550500 szabo,7,0,0,0,0);

        setStage(4,100000,77550500 szabo,10,0,0,0,0);

        setStage(5,10000,1577550500 szabo,15,0,0,0,0);

        setStage(6,1000,24077550500 szabo,20,0,0,0,0);

        setStage(7,200,74077550500 szabo,25,0,0,0,10 days);

        setStage(8,100,124077550500 szabo,30,3,10 ether,1000 ether,10 days);

        setStage(9,50,184077550500 szabo,35,5,7 ether,350 ether,10 days);

        setStage(10,25,224077550500 szabo,40,7,5 ether,125 ether,10 days);

        setStage(11,12,265744550500 szabo,45,10,3 ether,36 ether,10 days);

        setStage(12,6,299078550500 szabo,50,15,2 ether,12 ether,10 days);

        setStage(13,3,332412550500 szabo,70,20,1 ether,3 ether,10 days);

        setStage(14,2,357412550500 szabo,100,40,200 finney,400 finney,10 days);



        _currentStage = 1;

        setRefPercent(_stages[_currentStage].refPercent);

        setRate(_stages[_currentStage].rate);

        setStageStartTime(_currentStage, now);

    }



    /**

     * @return current stage.

     */

    function currentStage() public view returns (uint256) {

        return _currentStage;

    }



    /**

     * @dev Setting Stage Parameters

     */

    function setStage(

        uint256 stageNumber,

        uint256 rate,

        uint256 cap,

        uint256 refPercent,

        uint256 unsoldDistPercent,

        uint256 minEthDist,

        uint256 minHpaDist,

        uint256 period

    )

    internal

    {

        _stages[stageNumber] = stage({

            rate: rate,

            cap: cap,

            refPercent: refPercent,

            unsoldDistPercent: unsoldDistPercent,

            minEthDist: minEthDist,

            minHpaDist: minHpaDist,

            period: period

            });

    }



    /**

     * @return Remaining Stage Time

     */

    function remStageTime() public view returns (uint256) {

        if (_stages[_currentStage].period > 0) {

            return _stages[_currentStage].period - (now - _stagesStats[_currentStage].start);

        } else {

            return 0;

        }

    }



    /**

     * @dev Closes the current stage

     */

    function closeCurrentStage() internal {

        emit CloseStage(_currentStage, now);

        setStageEndTime(_currentStage, now);

    }



    /**

     * @dev Activates the next stage, provided that not all stages have passed and the crowdsale has not ended

     */

    function openNewStage() internal {

        _currentStage = _currentStage.add(1);

        setRefPercent(_stages[_currentStage].refPercent);

        setRate(_stages[_currentStage].rate);

        emit OpenStage(_currentStage, now);

        setStageStartTime(_currentStage, now);

    }



    /**

     * @return stage parameters.

     */

    function viewStage(uint256 s) public view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {

        stage memory _stage = _stages[s];

        return (_stage.rate, _stage.cap, _stage.refPercent, _stage.unsoldDistPercent, _stage.minEthDist, _stage.minHpaDist, _stage.period);

    }



    /**

     * @dev Checks whether the stage cap has been reached.

     * @return Whether the stage cap was reached

     */

    function stageCapReached() public view returns (bool) {

        return weiRaised() >= _stages[_currentStage].cap;

    }



    /**

     * @return the stage opening and closing time.

     */

    function stageTiming(uint256 stageNumber) public view returns (uint256, uint256) {

        return (_stagesStats[stageNumber].start, _stagesStats[stageNumber].end);

    }



    /**

     * @return true if the crowdsale is open, false otherwise.

     */

    function isOpen() public view returns (bool) {

        uint256 numStages = _stages.length.sub(1);

        if (_currentStage == numStages) {

            if (_stagesStats[_currentStage].end > 0) {

                return false;

            }

            if (_stages[_currentStage].period > 0) {

                if (_stagesStats[_currentStage].start + _stages[_currentStage].period <= now) {

                    return false;

                }

            }

            if (weiRaised() == _stages[_currentStage].cap) {

                return false;

            }

        }

        return true;

    }



    /**

     * @dev Checks whether the period in which the crowdsale is open has already elapsed.

     * @return Whether crowdsale period has elapsed

     */

    function hasClosed() public view returns (bool) {

        return !isOpen();

    }



    /**

     * @dev checks the current stage, closes it and returns true if it is finished.

     * Returns false if the stage is not finished.

     */

    function checkEndStage() internal returns (bool) {

        if (_stagesStats[_currentStage].end > 0) {

            return true;

        }

        if (_stages[_currentStage].period > 0) {

            if (_stagesStats[_currentStage].start + _stages[_currentStage].period <= now) {

                closeCurrentStage();

                return true;

            }

        }

        if (weiRaised() == _stages[_currentStage].cap) {

            closeCurrentStage();

            return true;

        }

        return false;

    }



    /**

     * @dev Manualy close current stage

     */

    function manualyCloseCurrentStage() public onlyOwner returns (bool) {

        if (checkEndStage()) {

            if (isOpen()) {

                openNewStage();

            }

            return true;

        }

        return false;

    }



    /**

     * @dev Extend parent behavior requiring purchase to respect the funding cap.

     * It works before the purchase operation.

     * Checks before buying whether the crowdsale is closed, if the limit for the current stage is not exceeded,

     * and also the maximum percentage of purchase for the current stage is not exceeded

     * @param beneficiary Token purchaser

     * @param weiAmount Amount of wei contributed

     */

    function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {

        super._preValidatePurchase(beneficiary, weiAmount);

        require(isOpen(), "StagesCrowdsale: Final stage completed. Crowdsale already closed");

        require(weiRaised().add(weiAmount) <= _stages[_currentStage].cap, "StagesCrowdsale: stage cap exceeded");

        require(weiAmount <= _stages[_currentStage].cap.div(5), "StagesCrowdsale: cannot buy more than 20% stage cap");

    }



    /**

    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid

    * conditions are not met.

    * Checks completion of a stage and opens a new one if the current stage is completed

    * @param beneficiary Address performing the token purchase

    * @param weiAmount Value in wei involved in the purchase

    */

    function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal {

        super._postValidatePurchase(beneficiary, weiAmount);

        if (checkEndStage()) {

            if (isOpen()) {

                openNewStage();

            }

        }

    }



    /**

     * @dev Override for extensions that require an internal state to check for validity (current user contributions,

     * etc.)

     * Saves statistics of the operation

     * @param beneficiary Address receiving the tokens

     * @param weiAmount Value in wei involved in the purchase

     */

    function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {

        super._updatePurchasingState(beneficiary, weiAmount);

        uint256 tokens = _getTokenAmount(weiAmount);

        setCurrentStageStat(beneficiary, weiAmount, tokens);

        setPurchaseStat(beneficiary, weiAmount, tokens);

    }



    /**

     * @dev Override for extensions that require an internal state to check for validity (current user contributions,

     * etc.)

     * Saves stage statistics

     * @param beneficiary Address receiving the tokens

     * @param weiAmount Value in wei involved in the purchase

     * @param tokens Value in HPA tokens involved in the purchase

     */

    function setCurrentStageStat(address beneficiary, uint256 weiAmount, uint256 tokens) internal {

        _stagesStats[_currentStage].tokensSold = _stagesStats[_currentStage].tokensSold.add(tokens);

        _stagesStats[_currentStage].numPurchases = _stagesStats[_currentStage].numPurchases.add(1);

        _stagesStats[_currentStage].tokensUnsold = _stagesStats[_currentStage].tokensUnsold.sub(tokens);

        if (_stages[_currentStage].unsoldDistPercent > 0) {

            _stagesStats[_currentStage].partsDist[beneficiary].sumWei = _stagesStats[_currentStage].partsDist[beneficiary].sumWei.add(weiAmount);

            _stagesStats[_currentStage].partsDist[beneficiary].sumHpa = _stagesStats[_currentStage].partsDist[beneficiary].sumHpa.add(tokens);

            if (

                _stagesStats[_currentStage].partsDist[beneficiary].sumWei >= _stages[_currentStage].minEthDist &&

                _stagesStats[_currentStage].partsDist[beneficiary].sumHpa >= _stages[_currentStage].minHpaDist

            ) {

                if (!_stagesStats[_currentStage].partsDist[beneficiary].part) {

                    _stagesStats[_currentStage].numBuyersDist = _stagesStats[_currentStage].numBuyersDist.add(1);

                }

                _stagesStats[_currentStage].partsDist[beneficiary].part = true;

                buyersStats[beneficiary].stagesPartDist[_currentStage] = true;

            }

        }

    }



    /**

     * @dev Override for extensions that require an internal state to check for validity (current user contributions,

     * etc.)

     * Saves statistics of the operation

     * @param beneficiary Address receiving the tokens

     * @param weiAmount Value in wei involved in the purchase

     * @param tokens Value in HPA tokens involved in the purchase

     */

    function setPurchaseStat(address beneficiary, uint256 weiAmount, uint256 tokens) internal {

        uint256 hpa = 1 ether;

        uint256 price = hpa.div(rate());

        buyersStats[beneficiary].purchases.push(purchase({

            stage: _currentStage,

            price: price,

            sumEth: weiAmount,

            sumHpa: tokens,

            time: now

            }));

        buyersStats[beneficiary].numPurchases = buyersStats[beneficiary].numPurchases.add(1);

    }



    /**

     * @return contract balance in wei

     */

    function getThisBalance() public view returns (uint256) {

        return address(this).balance;

    }

}



// File: contracts\\DistCrowdsale.sol



pragma solidity ^0.5.0;







/**

 * @title Distribution on crowdsale

 * @dev Accounting and regulation of the distribution of unsold tokens in the late stages of Crowdsale

 */

contract DistCrowdsale is StagesCrowdsale {

    uint256 private _unsoldTokens;  // Total unsold tokens

    uint256 private _numStages;     // Total number of stages

    uint256 private _distTokens;    // Total number of tokens received during distribution (requested tokens)

    bool private _calcDone = false; // Have tokens been calculated for distribution?



    struct stagesUnsoldTokens {     // A structural unit containing information on the distribution of unsold tokens by stages

        uint256 stage;                  // The stage for which information is contained in the structural unit

        uint256 percent;                // The percentage of allocated unsold tokens for distribution at this stage

        uint256 stageUnsoldTokens;      // Unsold tokens at this stage

        uint256 distTokens;             // The number of tokens allocated to each participant who has fulfilled the requirement to receive unsold tokens

    }



    // Information on the distribution of unsold tokens for all stages

    mapping (uint256 => stagesUnsoldTokens) _stagesDistTokens;

    // Information about the tokens received during the distribution process for each address that made the distribution request

    mapping (address => uint256) collectedUnsoldTokens;



    /**

     * Event triggered when calculating the number of tokens that each participant in the distribution program will receive

     * @param unsoldTokens Total unsold tokens

     * @param time Calculation Time

     */

    event DistCalculation(uint256 unsoldTokens, uint256 time);



    /**

     * @dev Creating a contract with setting the total number of stages

     */

    constructor () public {

        _numStages = _stages.length.sub(1);

    }



    /**

     * @return information about the distribution of tokens at the specified stage

     * @param s stage

     */

    function viewStageDistTokens(uint256 s) public view returns (uint256, uint256, uint256) {

        stagesUnsoldTokens memory _dist = _stagesDistTokens[s];

        return (_dist.percent, _dist.stageUnsoldTokens, _dist.distTokens);

    }



    /**

     * @return total number of tokens received during distribution (requested tokens)

     */

    function getDistTokens() public view returns(uint) {

        return _distTokens;

    }



    /**

     * @return total unsold tokens

     */

    function getUnsoldTokens() public view returns(uint) {

        return _unsoldTokens;

    }



    /**

     * @return the number of tokens received during the distribution process for the specified buyer

     * @param buyer for which participant information is requested

     */

    function getBuyerCollectedUnsoldTokens(address buyer) public view returns (uint256) {

        return collectedUnsoldTokens[buyer];

    }



    /**

     * @dev Internal function calculating the total number of unsold tokens.

     * It is possible to start only after the crowdsale ends.

     */

    function sumUnsoldTokens() internal {

        require(hasClosed(), "DistCrowdsale: Crowdsale not complete");

        uint256 unsoldTokens;

        for (uint256 i = 1; i <= _numStages; i++) {

            //if (_stages[i].unsoldDistPercent > 0) {

            unsoldTokens = unsoldTokens.add(_stagesStats[i].tokensUnsold);

            _stagesDistTokens[i].percent = _stages[i].unsoldDistPercent;

            //}

        }

        _unsoldTokens = unsoldTokens;

    }



    /**

     * @dev An internal function that calculates the number of tokens to be distributed

     * to each and other information. Calculated for each stage.

     * It is possible to launch only after the end of the sale and provided that not all tokens are sold

     */

    function calcDistUnsoldTokens() internal {

        require(hasClosed(), "DistCrowdsale: Crowdsale not complete");

        require(_unsoldTokens > 0, "DistCrowdsale: The number of unsold tokens should not be zero");

        for (uint256 i = 1; i <= _numStages; i++) {

            if (_stages[i].unsoldDistPercent > 0) {

                _stagesDistTokens[i].stage = i;

                _stagesDistTokens[i].stageUnsoldTokens = _unsoldTokens.div(100).mul(_stagesDistTokens[i].percent);

                if (_stagesStats[i].numBuyersDist > 0) {

                    _stagesDistTokens[i].distTokens = _stagesDistTokens[i].stageUnsoldTokens.div(_stagesStats[i].numBuyersDist);

                }

            }

        }

    }



    /**

     * @dev An external function to run all calculations.

     * It is possible to start only if the calculations have not yet been made and if the sale is completed.

     */

    function distCalc() external onlyHuman {

        require(hasClosed(), "DistCrowdsale: Crowdsale not complete");

        require(!_calcDone, "DistCrowdsale: Calculation complete");

        sumUnsoldTokens();

        emit DistCalculation(_unsoldTokens, now);

        calcDistUnsoldTokens();

        _calcDone = true;

    }



    /**

     * @dev An external function for requesting the accrual of unsold tokens to the specified address from each stage.

     * It is checked whether the address that made the function call is involved in the distribution of tokens at each stage

     * It is possible to start only if the calculations have not yet been made and if the sale is completed.

     * @param beneficiary The address tokens will be transferred to

     */

    function withdrawalUnsoldTokens(address beneficiary) external onlyHuman {

        require(hasClosed(), "DistCrowdsale: Crowdsale not complete");

        require(_calcDone, "DistCrowdsale: Calculation not complete");

        uint256 tokensSend = 0;

        for (uint256 i = 1; i <= _numStages; i++) {

            if (buyersStats[beneficiary].stagesPartDist[i]) {

                tokensSend = tokensSend.add(_stagesDistTokens[i].distTokens);

                buyersStats[beneficiary].stagesPartDist[i] = false;

            }

        }

        _distTokens = _distTokens.add(tokensSend);

        collectedUnsoldTokens[beneficiary] = tokensSend;



        emit TokensPurchased(_msgSender(), beneficiary, 0, tokensSend);

        _processPurchase(beneficiary, tokensSend);

    }

}



// File: contracts\\BuybackCrowdsale.sol



pragma solidity ^0.5.0;







/**

 * @title Token buyback contract

 * @dev The calculation of the redemption price of tokens, as well as the

 * redemption of tokens after the crowdsale at the calculated price

 */

contract BuybackCrowdsale is DistCrowdsale {

    uint256 private _buybackBalance;    // ETH balance for redemption of tokens

    uint256 private _buybackPrice;      // Token buyback price

    uint256 private _timeCalc;          // Price calculation time



    // Token buyback completion time, after which the contract owner

    // will be able to withdraw the ETH remaining on the contract.

    // The countdown starts from the time of the price calculation (_timeCalc).

    uint256 private _timeBuybackEnd;



    address private _burnAddress;       // Address for burning purchased tokens

    bool private _calcDone = false;     // The parameter determining whether the price was calculated



    struct buyerBuyback {       // The structure of accounting statistics of token buyback operations

        address beneficiary;        // ETH receiving address

        uint256 tokenAmount;        // Token Amount

        uint256 price;              // Calculated Token Buyback Price

        uint256 sumEther;           // Amount ETH

        uint256 time;               // Operation time

    }



    // Accounting for all statistics of token buyback operations

    mapping (address => buyerBuyback[]) buyersBuybacks;



    /**

     * Event Token price calculation event

     * @param buybackBalance ETH balance for redemption of tokens

     * @param buybackPrice token buyback price

     * @param timeCalc price calculation time

     * @param timeBuybackEnd token buyback completion time

     */

    event BuybackCalculation(uint256 buybackBalance, uint256 buybackPrice, uint256 timeCalc, uint256 timeBuybackEnd);



    /**

     * Event Token buyback event

     * @param beneficiary ETH receiving address

     * @param amount Token Amount

     * @param sumEther Amount ETH

     * @param time Event time

     */

    event Buyback(address indexed beneficiary, uint256 amount, uint256 sumEther, uint256 time);



    /**

     * Event ETN withdrawal event after the end of the crowdsale

     * @param ownerAddress ETH receiving address

     * @param amount Amount ETH

     * @param time Event time

     */

    event Withdrawal(address indexed ownerAddress, uint256 amount, uint256 time);



    /**

     * @dev Launch of a token buyback contract after the end of the sale.

     * The address to which the tokens will be sent is owned by no one and no one will be able to access the tokens.

     * In the process of creating a contract, a deadline is established after which the redemption of tokens ends

     * and the contract owner will be able to withdraw the remaining ETH

     * @param burnAddress The address tokens will be sent after the buyback (token burning)

     */

    constructor (address burnAddress) public {

        _timeBuybackEnd = 180 days;

        //_burnAddress = address(0x0000000000000000000000000000000000000001);

        _burnAddress = burnAddress;

    }



    /**

     * @return ETH balance for redemption of tokens

     */

    function getBuybackBalance() public view returns (uint256) {

        return _buybackBalance;

    }



    /**

     * @return Token buyback price

     */

    function getBuybackPrice() public view returns (uint256) {

        return _buybackPrice;

    }



    /**

     * @return Price calculation time

     */

    function getTimeCalc() public view returns (uint256) {

        return _timeCalc;

    }



    /**

     * @return Token buyback completion time

     */

    function getTimeBuyback() public view returns (uint256) {

        return _timeBuybackEnd;

    }



    /**

     * @dev request statistics on distributed tokens for the specified participant

     * @param buyer Token buyer who sold the tokens to the contract (according to the token redemption procedure)

     * @return An array of statistics on token buyback operations of a specified buyer

     */

    function getBuyerBuybacks(address buyer) public view returns (buyerBuyback[] memory) {

        return buyersBuybacks[buyer];

    }



    /**

     * @dev The function of calculating the price of tokens, which can be called by anyone

     * (if the owner of the contract does not), but only after the sale is completed.

     * The calculation is made only once and only if the account balance has ETH.

     */

    function buybackCalc() external onlyHuman {

        require(hasClosed(), "BuybackCrowdsale: Crowdsale not complete");

        require(!_calcDone, "BuybackCrowdsale: Calculation complete");

        _buybackBalance = address(this).balance;

        require(_buybackBalance > 0, "BuybackCrowdsale: Contract ETH should not be zero");

        _buybackPrice = _buybackBalance.div(token().totalSupply().div(10 ether));

        _calcDone = true;

        _timeCalc = now;

        emit BuybackCalculation(_buybackBalance, _buybackPrice, _timeCalc, _timeCalc.add(_timeBuybackEnd));

    }



    /**

     * @dev An external function that is used to request a buyback of tokens.

     * The caller of this function sells tokens to the contract at the previously calculated price.

     * Calling this function is possible only after the end of the crowdsale and the price calculation.

     * If there is no money left on the contract, then this function will stop working.

     * The address (beneficiary) to which ETH will be transferred for tokens should not be empty.

     * The minimum token sale amount is 1 HPA token.

     * The indicated amount of tokens (hpaAmount) should be on the account of the address that called this function.

     *

     * @param beneficiary ETH receiving address

     * @param hpaAmount Token Amount

     */

    function buyback(address payable beneficiary, uint256 hpaAmount) external onlyHuman {

        require(hasClosed(), "BuybackCrowdsale: Crowdsale not complete");

        require(_calcDone, "BuybackCrowdsale: Calculation not complete");

        require(address(this).balance > 0, "BuybackCrowdsale: Contract ETH should not be zero");

        require(beneficiary != address(0), "BuybackCrowdsale: Beneficiary is the zero address");

        require(hpaAmount >= 1 ether, "BuybackCrowdsale: You must specify at least one token");

        require(token().balanceOf(beneficiary) >= hpaAmount, "BuybackCrowdsale: Missing HPA token amount");



        uint256 sumEther = hpaAmount.div(1 ether).mul(_buybackPrice);

        require(address(this).balance >= sumEther, "BuybackCrowdsale: There is not enough ether on the contract for this transaction. Specify fewer tokens");

        buyersBuybacks[msg.sender].push(buyerBuyback({

            beneficiary: beneficiary,

            tokenAmount: hpaAmount,

            price: _buybackPrice,

            sumEther: sumEther,

            time: now

            }));

        _buybackBalance = _buybackBalance.sub(sumEther);

        emit Buyback(beneficiary, hpaAmount, sumEther, now);

        token().transferFrom(msg.sender, _burnAddress, hpaAmount);

        beneficiary.transfer(sumEther);

    }



    /**

     * @dev The function of withdrawing the remaining and not requested for redemption ETH.

     * It can only be called by the owner of the contract, after the end of the token buyback period

     *

     * @param ownerAddress Address of the owner to which the withdrawal ETH`s will be displayed

     */

    function withdrawal(address payable ownerAddress) external onlyOwner {

        require(hasClosed(), "BuybackCrowdsale: Crowdsale not complete");

        require(_calcDone, "BuybackCrowdsale: Calculation not complete");

        require(now > _timeCalc.add(_timeBuybackEnd), "BuybackCrowdsale: Buyback not complete");

        require(ownerAddress != address(0), "BuybackCrowdsale: ownerAddress is the zero address");



        emit Withdrawal(ownerAddress, address(this).balance, now);

        ownerAddress.transfer(address(this).balance);

    }

}



// File: contracts\\ERC20Detailed.sol



pragma solidity ^0.5.0;





/**

 * @dev Optional functions from the ERC20 standard.

 */

contract ERC20Detailed is IERC20 {

    string private _name;

    string private _symbol;

    uint8 private _decimals;



    /**

     * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of

     * these values are immutable: they can only be set once during

     * construction.

     */

    constructor (string memory name, string memory symbol, uint8 decimals) public {

        _name = name;

        _symbol = symbol;

        _decimals = decimals;

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

     * Ether and Wei.

     *

     * NOTE: This information is only used for _display_ purposes: it in

     * no way affects any of the arithmetic of the contract, including

     * {IERC20-balanceOf} and {IERC20-transfer}.

     */

    function decimals() public view returns (uint8) {

        return _decimals;

    }

}



// File: contracts\\HighlyProfitableAnonymousToken.sol



pragma solidity ^0.5.0;







/**

 * @title HighlyProfitableAnonymousToken

 * @dev Very simple ERC20 Token that can be minted.

 * It is meant to be used in a crowdsale contract.

 */

contract HighlyProfitableAnonymousToken is ERC20Mintable, ERC20Detailed {

    constructor () public ERC20Detailed("Highly Profitable Anonymous Token", "HPA", 18) {

        // solhint-disable-previous-line no-empty-blocks

    }

}



// File: contracts\\HPACrowdsale.sol



pragma solidity ^0.5.0;







/**************************************************************************************************

|$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$|

|$$ -------------------------------------------------------------------------------------------- $$|

|$$|                                                                                            |$$|

|$$|   \u00b6\u00b6  \u00b6\u00b6 \u00b6\u00b6\u00b6\u00b6\u00b6   \u00b6\u00b6\u00b6\u00b6      \u00b6\u00b6\u00b6\u00b6  \u00b6\u00b6\u00b6\u00b6\u00b6   \u00b6\u00b6\u00b6\u00b6  \u00b6\u00b6   \u00b6\u00b6 \u00b6\u00b6\u00b6\u00b6\u00b6   \u00b6\u00b6\u00b6\u00b6   \u00b6\u00b6\u00b6\u00b6  \u00b6\u00b6     \u00b6\u00b6\u00b6\u00b6\u00b6   |$$|

|$$|   \u00b6\u00b6  \u00b6\u00b6 \u00b6\u00b6  \u00b6\u00b6 \u00b6\u00b6  \u00b6\u00b6    \u00b6\u00b6  \u00b6\u00b6 \u00b6\u00b6  \u00b6\u00b6 \u00b6\u00b6  \u00b6\u00b6 \u00b6\u00b6   \u00b6\u00b6 \u00b6\u00b6  \u00b6\u00b6 \u00b6\u00b6     \u00b6\u00b6  \u00b6\u00b6 \u00b6\u00b6     \u00b6\u00b6      |$$|

|$$|   \u00b6\u00b6\u00b6\u00b6\u00b6\u00b6 \u00b6\u00b6\u00b6\u00b6\u00b6  \u00b6\u00b6\u00b6\u00b6\u00b6\u00b6    \u00b6\u00b6     \u00b6\u00b6\u00b6\u00b6\u00b6  \u00b6\u00b6  \u00b6\u00b6 \u00b6\u00b6 \u00b6 \u00b6\u00b6 \u00b6\u00b6  \u00b6\u00b6  \u00b6\u00b6\u00b6\u00b6  \u00b6\u00b6\u00b6\u00b6\u00b6\u00b6 \u00b6\u00b6     \u00b6\u00b6\u00b6\u00b6    |$$|

|$$|   \u00b6\u00b6  \u00b6\u00b6 \u00b6\u00b6     \u00b6\u00b6  \u00b6\u00b6    \u00b6\u00b6  \u00b6\u00b6 \u00b6\u00b6  \u00b6\u00b6 \u00b6\u00b6  \u00b6\u00b6 \u00b6\u00b6\u00b6\u00b6\u00b6\u00b6\u00b6 \u00b6\u00b6  \u00b6\u00b6     \u00b6\u00b6 \u00b6\u00b6  \u00b6\u00b6 \u00b6\u00b6     \u00b6\u00b6      |$$|

|$$|   \u00b6\u00b6  \u00b6\u00b6 \u00b6\u00b6     \u00b6\u00b6  \u00b6\u00b6     \u00b6\u00b6\u00b6\u00b6  \u00b6\u00b6  \u00b6\u00b6  \u00b6\u00b6\u00b6\u00b6   \u00b6\u00b6 \u00b6\u00b6  \u00b6\u00b6\u00b6\u00b6\u00b6   \u00b6\u00b6\u00b6\u00b6  \u00b6\u00b6  \u00b6\u00b6 \u00b6\u00b6\u00b6\u00b6\u00b6\u00b6 \u00b6\u00b6\u00b6\u00b6\u00b6   |$$|

|$$|                                                                                            |$$|

|$$ -------------------------------------------------------------------------------------------- $$|

|$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$|

\\**************************************************************************************************/



/**

 * @title HpaCrowdsale

 * @dev Highly Profitable Anonymous Token

 * Highly Profitable Anonymous Token is an ICO Token that provides the opportunity to earn money

 * on the purchase of currencies with a significant discount and other bonuses, as well as

 * the opportunity to participate in crowdfunding of the platform of cryptocurrency projects.

 *

 */

contract HpaCrowdsale is BuybackCrowdsale {

    uint256 private _platformTokens = 100000; // Tokens issued for the needs of the platform



    // The time after the sale is completed, during which it impossible to withdraw tokens issued

    // for the needs of the platform

    uint256 private _withdrawalTokensTime = 30 days;

    address payable initPlatformWallet = 0x4B536E67f532ea3129881266eC8B1D562D7B89E8;

    address payable initPriceTokenBackingWallet = 0x4830121fb404b279D8354D99468D723bcaf69702;

    address payable initInvestBoxWallet = 0x0Ee5bb8371A2605Fe5D46a915650CDDb745372cf;

    address payable initOtherWallet = 0x0450080ba40cb9c27326304749064cd628E967E5;

    address initBurnAddress = 0x0000000000000000000000000000000000000001;



    constructor ()

    public

    Crowdsale(

        initPlatformWallet,

        initPriceTokenBackingWallet,

        initInvestBoxWallet,

        initOtherWallet,

        new  HighlyProfitableAnonymousToken()

    )

    BuybackCrowdsale(initBurnAddress)

    {

        uint256 tokenAmount = _platformTokens.mul(1 ether);

        emit TokensPurchased(_msgSender(), address(this), 0, tokenAmount);

        _processPurchase(address(this), tokenAmount);

    }



    /**

     * @dev The function of withdrawing tokens issued for the needs of the platform.

     * You can use the output after the time specified in the _withdrawalTokensTime parameter,

     * after the crowdsale is completed

     * @param ownerAddress Recipient of the token purchase

     */

    function withdrawalPlatformTokens(address payable ownerAddress) external onlyOwner {

        require(hasClosed(), "HpaCrowdsale: Crowdsale not complete");

        require(now > _stagesStats[14].end.add(_withdrawalTokensTime), "HpaCrowdsale: Please wait");

        require(ownerAddress != address(0), "HpaCrowdsale: ownerAddress is the zero address");



        token().transfer(ownerAddress, _platformTokens.mul(1 ether));

    }

}

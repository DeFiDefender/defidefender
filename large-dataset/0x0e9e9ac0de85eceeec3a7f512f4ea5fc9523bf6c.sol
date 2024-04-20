// File: @openzeppelin/contracts/GSN/Context.sol



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



// File: @openzeppelin/contracts/ownership/Ownable.sol



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



// File: @openzeppelin/contracts/access/Roles.sol



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



// File: @openzeppelin/contracts/access/roles/WhitelistAdminRole.sol



pragma solidity ^0.5.0;







/**

 * @title WhitelistAdminRole

 * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.

 */

contract WhitelistAdminRole is Context {

    using Roles for Roles.Role;



    event WhitelistAdminAdded(address indexed account);

    event WhitelistAdminRemoved(address indexed account);



    Roles.Role private _whitelistAdmins;



    constructor () internal {

        _addWhitelistAdmin(_msgSender());

    }



    modifier onlyWhitelistAdmin() {

        require(isWhitelistAdmin(_msgSender()), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");

        _;

    }



    function isWhitelistAdmin(address account) public view returns (bool) {

        return _whitelistAdmins.has(account);

    }



    function addWhitelistAdmin(address account) public onlyWhitelistAdmin {

        _addWhitelistAdmin(account);

    }



    function renounceWhitelistAdmin() public {

        _removeWhitelistAdmin(_msgSender());

    }



    function _addWhitelistAdmin(address account) internal {

        _whitelistAdmins.add(account);

        emit WhitelistAdminAdded(account);

    }



    function _removeWhitelistAdmin(address account) internal {

        _whitelistAdmins.remove(account);

        emit WhitelistAdminRemoved(account);

    }

}



// File: @openzeppelin/contracts/access/roles/WhitelistedRole.sol



pragma solidity ^0.5.0;









/**

 * @title WhitelistedRole

 * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a

 * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove

 * it), and not Whitelisteds themselves.

 */

contract WhitelistedRole is Context, WhitelistAdminRole {

    using Roles for Roles.Role;



    event WhitelistedAdded(address indexed account);

    event WhitelistedRemoved(address indexed account);



    Roles.Role private _whitelisteds;



    modifier onlyWhitelisted() {

        require(isWhitelisted(_msgSender()), "WhitelistedRole: caller does not have the Whitelisted role");

        _;

    }



    function isWhitelisted(address account) public view returns (bool) {

        return _whitelisteds.has(account);

    }



    function addWhitelisted(address account) public onlyWhitelistAdmin {

        _addWhitelisted(account);

    }



    function removeWhitelisted(address account) public onlyWhitelistAdmin {

        _removeWhitelisted(account);

    }



    function renounceWhitelisted() public {

        _removeWhitelisted(_msgSender());

    }



    function _addWhitelisted(address account) internal {

        _whitelisteds.add(account);

        emit WhitelistedAdded(account);

    }



    function _removeWhitelisted(address account) internal {

        _whitelisteds.remove(account);

        emit WhitelistedRemoved(account);

    }

}



// File: contracts/whitelist/WhitelistExtension.sol



pragma solidity 0.5.11;









/// @dev Extension of WhitelistedRole to allow add multiple whitelisted admins or accounts

/// in a single transaction

/// also added Pausable

contract WhitelistExtension is Ownable, WhitelistedRole {



    event Paused(address account);

    event Unpaused(address account);



    bool private _paused;



    modifier whenNotPaused() {

        require(!_paused, "paused");

        _;

    }



    modifier whenPaused() {

        require(_paused, "not paused");

        _;

    }



    constructor() public {

        _paused = false;

    }



    function pause() public onlyWhitelistAdmin whenNotPaused {

        _paused = true;

        emit Paused(msg.sender);

    }



    function unpause() public onlyWhitelistAdmin whenPaused {

        _paused = false;

        emit Unpaused(msg.sender);

    }



    /// @dev update whitelisted admins

    /// only owner can update this list

    function updateWhitelistedAdmins(

        address[] calldata admins,

        bool isAdd

    )

        external onlyOwner

    {

        for(uint256 i = 0; i < admins.length; i++) {

            if (isAdd) {

                if (!isWhitelistAdmin(admins[i])) _addWhitelistAdmin(admins[i]);

            } else {

                if (isWhitelistAdmin(admins[i])) _removeWhitelistAdmin(admins[i]);

            }

        }

    }



    /// @dev update whitelisted addresses

    /// only whitelisted admins can call this function

    function updateWhitelistedUsers(

        address[] calldata users,

        bool isAdd

    )

        external onlyWhitelistAdmin 

    {

        for(uint256 i = 0; i < users.length; i++) {

            if (isAdd) {

                if (!isWhitelisted(users[i])) _addWhitelisted(users[i]);

            } else {

                if (isWhitelisted(users[i])) _removeWhitelisted(users[i]);

            }

        }

    }



    function isPaused() external view returns (bool) {

        return _paused;

    }

}



// File: @openzeppelin/contracts/token/ERC20/IERC20.sol



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



// File: @openzeppelin/contracts/math/SafeMath.sol



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



// File: @openzeppelin/contracts/utils/Address.sol



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



// File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol



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



// File: @openzeppelin/contracts/crowdsale/Crowdsale.sol



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

        buyTokens(_msgSender());

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



// File: @openzeppelin/contracts/crowdsale/validation/TimedCrowdsale.sol



pragma solidity ^0.5.0;







/**

 * @title TimedCrowdsale

 * @dev Crowdsale accepting contributions only within a time frame.

 */

contract TimedCrowdsale is Crowdsale {

    using SafeMath for uint256;



    uint256 private _openingTime;

    uint256 private _closingTime;



    /**

     * Event for crowdsale extending

     * @param newClosingTime new closing time

     * @param prevClosingTime old closing time

     */

    event TimedCrowdsaleExtended(uint256 prevClosingTime, uint256 newClosingTime);



    /**

     * @dev Reverts if not in crowdsale time range.

     */

    modifier onlyWhileOpen {

        require(isOpen(), "TimedCrowdsale: not open");

        _;

    }



    /**

     * @dev Constructor, takes crowdsale opening and closing times.

     * @param openingTime Crowdsale opening time

     * @param closingTime Crowdsale closing time

     */

    constructor (uint256 openingTime, uint256 closingTime) public {

        // solhint-disable-next-line not-rely-on-time

        require(openingTime >= block.timestamp, "TimedCrowdsale: opening time is before current time");

        // solhint-disable-next-line max-line-length

        require(closingTime > openingTime, "TimedCrowdsale: opening time is not before closing time");



        _openingTime = openingTime;

        _closingTime = closingTime;

    }



    /**

     * @return the crowdsale opening time.

     */

    function openingTime() public view returns (uint256) {

        return _openingTime;

    }



    /**

     * @return the crowdsale closing time.

     */

    function closingTime() public view returns (uint256) {

        return _closingTime;

    }



    /**

     * @return true if the crowdsale is open, false otherwise.

     */

    function isOpen() public view returns (bool) {

        // solhint-disable-next-line not-rely-on-time

        return block.timestamp >= _openingTime && block.timestamp <= _closingTime;

    }



    /**

     * @dev Checks whether the period in which the crowdsale is open has already elapsed.

     * @return Whether crowdsale period has elapsed

     */

    function hasClosed() public view returns (bool) {

        // solhint-disable-next-line not-rely-on-time

        return block.timestamp > _closingTime;

    }



    /**

     * @dev Extend parent behavior requiring to be within contributing period.

     * @param beneficiary Token purchaser

     * @param weiAmount Amount of wei contributed

     */

    function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {

        super._preValidatePurchase(beneficiary, weiAmount);

    }



    /**

     * @dev Extend crowdsale.

     * @param newClosingTime Crowdsale closing time

     */

    function _extendTime(uint256 newClosingTime) internal {

        require(!hasClosed(), "TimedCrowdsale: already closed");

        // solhint-disable-next-line max-line-length

        require(newClosingTime > _closingTime, "TimedCrowdsale: new closing time is before current closing time");



        emit TimedCrowdsaleExtended(_closingTime, newClosingTime);

        _closingTime = newClosingTime;

    }

}



// File: @openzeppelin/contracts/crowdsale/distribution/FinalizableCrowdsale.sol



pragma solidity ^0.5.0;







/**

 * @title FinalizableCrowdsale

 * @dev Extension of TimedCrowdsale with a one-off finalization action, where one

 * can do extra work after finishing.

 */

contract FinalizableCrowdsale is TimedCrowdsale {

    using SafeMath for uint256;



    bool private _finalized;



    event CrowdsaleFinalized();



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

     * @dev Must be called after crowdsale ends, to do some extra finalization

     * work. Calls the contract's finalization function.

     */

    function finalize() public {

        require(!_finalized, "FinalizableCrowdsale: already finalized");

        require(hasClosed(), "FinalizableCrowdsale: not closed");



        _finalized = true;



        _finalization();

        emit CrowdsaleFinalized();

    }



    /**

     * @dev Can be overridden to add finalization logic. The overriding function

     * should call super._finalization() to ensure the chain of finalization is

     * executed entirely.

     */

    function _finalization() internal {

        // solhint-disable-previous-line no-empty-blocks

    }

}



// File: contracts/SeedSwap.sol



pragma solidity 0.5.11;















/// @dev SeedSwap contract for presale TEA token

/// Some notations:

/// dAmount - distributed token amount

/// uAmount - undistributed token amount

/// tAmount - token amount

/// eAmount - eth amount

contract SeedSwap is WhitelistExtension, ReentrancyGuard {

    using SafeERC20 for IERC20;

    using SafeMath for uint256;

    using SafeMath for uint80;



    IERC20  public constant ETH_ADDRESS = IERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);

    uint256 public constant MAX_UINT_80 = 2**79 - 1;

    uint256 public constant HARD_CAP = 320 ether;

    uint256 public constant MIN_INDIVIDUAL_CAP = 1 ether;

    uint256 public constant MAX_INDIVIDUAL_CAP = 10 ether;

    // user can call to distribute tokens after WITHDRAWAL_DEADLINE + saleEndTime

    uint256 public constant WITHDRAWAL_DEADLINE = 180 days;

    uint256 public constant SAFE_DISTRIBUTE_NUMBER = 150; // safe to distribute to 150 users at once

    uint256 public constant DISTRIBUTE_PERIOD_UNIT = 1 days;



    IERC20  public saleToken;

    uint256 public saleStartTime = 1609693200;  // 00:00:00, 4 Jan 2021 GMT+7

    uint256 public saleEndTime = 1610384340;    // 23:59:00, 11 Jan 2021 GMT+7

    uint256 public saleRate = 25000;            // 1 eth = 25,000 token



    // address to receive eth of presale, default owner

    address payable public ethRecipient;

    // total eth and token amounts that all users have swapped

    struct TotalSwappedData {

        uint128 eAmount;

        uint128 tAmount;

    }

    TotalSwappedData public totalData;

    uint256 public totalDistributedToken = 0;



    struct SwapData {

        address user;

        uint80 eAmount; // eth amount

        uint80 tAmount; // token amount

        uint80 dAmount; // distributed token amount

        uint16 daysID;

    }



    // all swaps that are made by users

    SwapData[] public listSwaps;



    // list indices of user's swaps in listSwaps array

    mapping(address => uint256[]) public userSwapData;

    mapping(address => address) public userTokenRecipient;



    event SwappedEthToTea(

        address indexed trader,

        uint256 indexed ethAmount,

        uint256 indexed teaAmount,

        uint256 blockTimestamp,

        uint16 daysID

    );

    event UpdateSaleTimes(

        uint256 indexed newStartTime,

        uint256 newEndTime

    );

    event UpdateSaleRate(uint256 indexed newSaleRate);

    event UpdateEthRecipient(address indexed newRecipient);

    event Distributed(

        address indexed user,

        address indexed recipient,

        uint256 dAmount,

        uint256 indexed percentage,

        uint256 timestamp

    );

    event SelfWithdrawToken(

        address indexed sender,

        address indexed recipient,

        uint256 indexed dAmount,

        uint256 timestamp

    );

    event EmergencyOwnerWithdraw(

        address indexed sender,

        IERC20 indexed token,

        uint256 amount

    );

    event UpdatedTokenRecipient(

        address user,

        address recipient

    );



    modifier whenNotStarted() {

        require(block.timestamp < saleStartTime, "already started");

        _;

    }



    modifier whenNotEnded() {

        require(block.timestamp <= saleEndTime, "already ended");

        _;

    }



    modifier whenEnded() {

        require(block.timestamp > saleEndTime, "not ended yet");

        _;

    }



    modifier onlyValidPercentage(uint256 percentage) {

        require(0 < percentage && percentage <= 100, "percentage out of range");

        _;

    }



    /// @dev Conditions:

    /// 1. sale must be in progress

    /// 2. hard cap is not reached yet

    /// 3. user's total swapped eth amount is within individual caps

    /// 4. user is whitelisted

    /// 5. if total eth amount after the swap is higher than hard cap, still allow

    /// Note: _paused is checked independently.

    modifier onlyCanSwap(uint256 ethAmount) {

        require(ethAmount > 0, "onlyCanSwap: amount is 0");

        // check sale is in progress

        uint256 timestamp = block.timestamp;

        require(timestamp >= saleStartTime, "onlyCanSwap: not started yet");

        require(timestamp <= saleEndTime, "onlyCanSwap: already ended");

        // check hardcap is not reached

        require(totalData.eAmount < HARD_CAP, "onlyCanSwap: HARD_CAP reached");

        address sender = msg.sender;

        // check whitelisted

        require(isWhitelisted(sender), "onlyCanSwap: sender is not whitelisted");

        // check total user's swap eth amount is within individual cap

        (uint80 userEthAmount, ,) = _getUserSwappedAmount(sender);

        uint256 totalEthAmount = ethAmount.add(uint256(userEthAmount));

        require(

            totalEthAmount >= MIN_INDIVIDUAL_CAP,

            "onlyCanSwap: eth amount is lower than min individual cap"

        );

        require(

            totalEthAmount <= MAX_INDIVIDUAL_CAP,

            "onlyCapSwap: max individual cap reached"

        );

        _;

    }



    constructor(address payable _owner, IERC20 _token) public {

        require(_token != IERC20(0), "constructor: invalid token");

        // (safe) check timestamp

        // assert(block.timestamp < saleStartTime);

        assert(saleStartTime < saleEndTime);



        saleToken = _token;

        ethRecipient = _owner;



        // add owner as whitelisted admin and transfer ownership if needed

        if (msg.sender != _owner) {

            _addWhitelistAdmin(_owner);

            transferOwnership(_owner);

        }

    }



    function () external payable {

        swapEthToToken();

    }



    /// ================ UPDATE DEFAULT DATA ====================



    /// @dev the owner can update start and end times when it is not yet started

    function updateSaleTimes(uint256 _newStartTime, uint256 _newEndTime)

        external whenNotStarted onlyOwner

    {

        if (_newStartTime != 0) saleStartTime = _newStartTime;

        if (_newEndTime != 0) saleEndTime = _newEndTime;

        require(saleStartTime < saleEndTime, "Times: invalid start and end time");

        require(block.timestamp < saleStartTime, "Times: invalid start time");

        emit UpdateSaleTimes(saleStartTime, saleEndTime);

    }



    /// @dev the owner can update the sale rate whenever the sale is not ended yet

    function updateSaleRate(uint256 _newsaleRate)

        external whenNotEnded onlyOwner

    {

        require(

            _newsaleRate < MAX_UINT_80 / MAX_INDIVIDUAL_CAP,

            "Rates: new rate is out of range"

        );

        // safe check rate not different more than 50% than the current rate

        require(_newsaleRate >= saleRate / 2, "Rates: new rate too low");

        require(_newsaleRate <= saleRate * 3 / 2, "Rates: new rate too high");



        saleRate = _newsaleRate;

        emit UpdateSaleRate(_newsaleRate);

    }



    /// @dev the owner can update the recipient of eth any time

    function updateEthRecipientAddress(address payable _newRecipient)

        external onlyOwner

    {

        require(_newRecipient != address(0), "Receipient: invalid eth recipient address");

        ethRecipient = _newRecipient;

        emit UpdateEthRecipient(_newRecipient);

    }



    /// ================ SWAP ETH TO TEA TOKEN ====================

    /// @dev user can call this function to swap eth to TEA token

    /// or just deposit eth directly to the contract

    function swapEthToToken()

        public payable

        nonReentrant

        whenNotPaused

        onlyCanSwap(msg.value)

        returns (uint256 tokenAmount)

    {

        address sender = msg.sender;

        uint256 ethAmount = msg.value;

        tokenAmount = _getTokenAmount(ethAmount);



        // should pass the check that presale has started, so no underflow here

        uint256 daysID = (block.timestamp - saleStartTime) / DISTRIBUTE_PERIOD_UNIT;

        assert(daysID < 2**16); // should have only few days for presale

        // record new swap

        SwapData memory _swapData = SwapData({

            user: sender,

            eAmount: uint80(ethAmount),

            tAmount: uint80(tokenAmount),

            dAmount: uint80(0),

            daysID: uint16(daysID)

        });

        listSwaps.push(_swapData);

        // update user swap data

        userSwapData[sender].push(listSwaps.length - 1);



        // update total swap eth and token amounts

        TotalSwappedData memory swappedData = totalData;

        totalData = TotalSwappedData({

            eAmount: swappedData.eAmount + uint128(ethAmount),

            tAmount: swappedData.tAmount + uint128(tokenAmount)

        });



        // transfer eth to recipient

        ethRecipient.transfer(ethAmount);



        emit SwappedEthToTea(sender, ethAmount, tokenAmount, block.timestamp, uint16(daysID));

    }



    /// ================ DISTRIBUTE TOKENS ====================



    /// @dev admin can call this function to perform distribute to all eligible swaps

    /// @param percentage percentage of undistributed amount will be distributed

    /// @param daysID only distribute for swaps that were made at that day from start

    function distributeAll(uint256 percentage, uint16 daysID)

        external onlyWhitelistAdmin whenEnded whenNotPaused onlyValidPercentage(percentage)

        returns (uint256 totalAmount)

    {

        for(uint256 i = 0; i < listSwaps.length; i++) {

            if (listSwaps[i].daysID == daysID) {

                totalAmount += _distributedToken(i, percentage);

            }

        }

        totalDistributedToken = totalDistributedToken.add(totalAmount);

    }



    /// @dev admin can also use this function to distribute by batch,

    ///      in case distributeAll can be out of gas

    /// @param percentage percentage of undistributed amount will be distributed

    /// @param ids list of ids in the listSwaps to be distributed

    function distributeBatch(uint256 percentage, uint256[] calldata ids)

        external onlyWhitelistAdmin whenEnded whenNotPaused onlyValidPercentage(percentage)

        returns (uint256 totalAmount)

    {

        uint256 len = listSwaps.length;

        for(uint256 i = 0; i < ids.length; i++) {

            require(ids[i] < len, "Distribute: invalid id");

            // safe prevent duplicated ids in 1 batch

            if (i > 0) require(ids[i - 1] < ids[i], "Distribute: indices are not in order");

            totalAmount += _distributedToken(ids[i], percentage);

        }

        totalDistributedToken = totalDistributedToken.add(totalAmount);

    }



    /// ================ EMERGENCY FOR USER AND OWNER ====================



    /// @dev in case after WITHDRAWAL_DEADLINE from end sale time

    /// user can call this function to claim all of their tokens

    /// also update user's swap records

    function selfWithdrawToken() external returns (uint256 tokenAmount) {

        require(

            block.timestamp > WITHDRAWAL_DEADLINE + saleEndTime,

            "Emergency: not open for emergency withdrawal"

        );

        address sender = msg.sender;

        (, uint80 tAmount, uint80 dAmount) = _getUserSwappedAmount(sender);

        tokenAmount = tAmount.sub(dAmount);

        require(tokenAmount > 0, "Emergency: user has claimed all tokens");

        require(

            tokenAmount <= saleToken.balanceOf(address(this)),

            "Emergency: not enough token to distribute"

        );



        // update each user's record

        uint256[] memory ids = userSwapData[sender];

        for(uint256 i = 0; i < ids.length; i++) {

            // safe check

            assert(listSwaps[ids[i]].user == sender);

            // update distributed amount for each swap data

            listSwaps[ids[i]].dAmount = listSwaps[ids[i]].tAmount;

        }

        totalDistributedToken = totalDistributedToken.add(tokenAmount);

        // transfer token to user

        address recipient = _transferToken(sender, tokenAmount);

        emit SelfWithdrawToken(sender, recipient, tokenAmount, block.timestamp);

    }



    /// @dev emergency to allow owner withdraw eth or tokens inside the contract

    /// in case anything happens

    function emergencyOwnerWithdraw(IERC20 token, uint256 amount) external onlyOwner {

        if (token == ETH_ADDRESS) {

            // whenever someone transfer eth to this contract

            // it will either to the swap or revert

            // so there should be no eth inside the contract

            msg.sender.transfer(amount);

        } else {

            token.safeTransfer(msg.sender, amount);

        }

        emit EmergencyOwnerWithdraw(msg.sender, token, amount);

    }



    /// @dev only in case user has lost their wallet, or wrongly send eth from third party platforms

    function updateUserTokenRecipient(address user, address recipient) external onlyOwner {

        require(recipient != address(0), "invalid recipient");

        userTokenRecipient[user] = recipient;

        emit UpdatedTokenRecipient(user, recipient);

    }



    /// ================ GETTERS ====================

    function getNumberSwaps() external view returns (uint256) {

        return listSwaps.length;

    }



    function getAllSwaps()

        external view

        returns (

            address[] memory users,

            uint80[] memory ethAmounts,

            uint80[] memory tokenAmounts,

            uint80[] memory distributedAmounts,

            uint16[] memory daysIDs

        )

    {

        uint256 len = listSwaps.length;

        users = new address[](len);

        ethAmounts = new uint80[](len);

        tokenAmounts = new uint80[](len);

        distributedAmounts = new uint80[](len);

        daysIDs = new uint16[](len);



        for(uint256 i = 0; i < len; i++) {

            SwapData memory data = listSwaps[i];

            users[i] = data.user;

            ethAmounts[i] = data.eAmount;

            tokenAmounts[i] = data.tAmount;

            distributedAmounts[i] = data.dAmount;

            daysIDs[i] = data.daysID;

        }

    }



    /// @dev return full details data of a user

    function getUserSwapData(address user)

        external view 

        returns (

            address tokenRecipient,

            uint256 totalEthAmount,

            uint80 totalTokenAmount,

            uint80 distributedAmount,

            uint80 remainingAmount,

            uint80[] memory ethAmounts,

            uint80[] memory tokenAmounts,

            uint80[] memory distributedAmounts,

            uint16[] memory daysIDs

        )

    {

        tokenRecipient = _getRecipient(user);

        (totalEthAmount, totalTokenAmount, distributedAmount) = _getUserSwappedAmount(user);

        remainingAmount = totalTokenAmount - distributedAmount;



        // record of all user's swaps

        uint256[] memory swapDataIDs = userSwapData[user];

        ethAmounts = new uint80[](swapDataIDs.length);

        tokenAmounts = new uint80[](swapDataIDs.length);

        distributedAmounts = new uint80[](swapDataIDs.length);

        daysIDs = new uint16[](swapDataIDs.length);



        for(uint256 i = 0; i < swapDataIDs.length; i++) {

            ethAmounts[i] = listSwaps[swapDataIDs[i]].eAmount;

            tokenAmounts[i] = listSwaps[swapDataIDs[i]].tAmount;

            distributedAmounts[i] = listSwaps[swapDataIDs[i]].dAmount;

            daysIDs[i] = listSwaps[swapDataIDs[i]].daysID;

        }

    }



    function getData()

        external view

        returns(

            uint256 _startTime,

            uint256 _endTime,

            uint256 _rate,

            address _ethRecipient,

            uint128 _tAmount,

            uint128 _eAmount,

            uint256 _hardcap

        )

    {

        _startTime = saleStartTime;

        _endTime = saleEndTime;

        _rate = saleRate;

        _ethRecipient = ethRecipient;

        _tAmount = totalData.tAmount;

        _eAmount = totalData.eAmount;

        _hardcap = HARD_CAP;

    }



    /// @dev returns list of users and distributed amounts if user calls distributeAll function

    /// in case anything is wrong, it will fail and not return anything

    /// @param percentage percentage of undistributed amount will be distributed

    /// @param daysID only distribute for swaps that were made at daysID from start

    function estimateDistributedAllData(

        uint80 percentage,

        uint16 daysID

    )

        external view

        whenEnded

        whenNotPaused

        onlyValidPercentage(percentage)

        returns(

            bool isSafe,

            uint256 totalUsers,

            uint256 totalDistributingAmount,

            uint256[] memory selectedIds,

            address[] memory users,

            address[] memory recipients,

            uint80[] memory distributingAmounts,

            uint16[] memory daysIDs

        )

    {

        // count number of data that can be distributed

        totalUsers = 0;

        for(uint256 i = 0; i < listSwaps.length; i++) {

            if (listSwaps[i].daysID == daysID && listSwaps[i].tAmount > listSwaps[i].dAmount) {

                totalUsers += 1;

            }

        }



        // return data that will be used to distribute

        selectedIds = new uint256[](totalUsers);

        users = new address[](totalUsers);

        recipients = new address[](totalUsers);

        distributingAmounts = new uint80[](totalUsers);

        daysIDs = new uint16[](totalUsers);



        uint256 counter = 0;

        for(uint256 i = 0; i < listSwaps.length; i++) {

            SwapData memory data = listSwaps[i];

            if (listSwaps[i].daysID == daysID && listSwaps[i].tAmount > listSwaps[i].dAmount) {

                selectedIds[counter] = i;

                users[counter] = data.user;

                recipients[counter] = _getRecipient(data.user);

                // don't need to use SafeMath here

                distributingAmounts[counter] = data.tAmount * percentage / 100;

                require(

                    distributingAmounts[counter] + data.dAmount <= data.tAmount,

                    "Estimate: total distribute more than 100%"

                );

                daysIDs[counter] = listSwaps[i].daysID;

                totalDistributingAmount += distributingAmounts[counter];

                counter += 1;

            }

        }

        require(

            totalDistributingAmount <= saleToken.balanceOf(address(this)),

            "Estimate: not enough token balance"

        );

        isSafe = totalUsers <= SAFE_DISTRIBUTE_NUMBER;

    }



    /// @dev returns list of users and distributed amounts if user calls distributeBatch function

    /// in case anything is wrong, it will fail and not return anything

    /// @param percentage percentage of undistributed amount will be distributed

    /// @param ids list indices to distribute in listSwaps

    /// ids must be in asc order

    function estimateDistributedBatchData(

        uint80 percentage,

        uint256[] calldata ids

    )

        external view

        whenEnded

        whenNotPaused

        onlyValidPercentage(percentage)

        returns(

            bool isSafe,

            uint256 totalUsers,

            uint256 totalDistributingAmount,

            uint256[] memory selectedIds,

            address[] memory users,

            address[] memory recipients,

            uint80[] memory distributingAmounts,

            uint16[] memory daysIDs

        )

    {

        totalUsers = 0;

        for(uint256 i = 0; i < ids.length; i++) {

            require(ids[i] < listSwaps.length, "Estimate: id out of range");

            if (i > 0) require(ids[i] > ids[i - 1], "Estimate: duplicated ids");

            // has undistributed amount

            if (listSwaps[i].tAmount > listSwaps[i].dAmount) totalUsers += 1;

        }

        // return data that will be used to distribute

        selectedIds = new uint256[](totalUsers);

        users = new address[](totalUsers);

        recipients = new address[](totalUsers);

        distributingAmounts = new uint80[](totalUsers);

        daysIDs = new uint16[](totalUsers);



        uint256 counter = 0;

        for(uint256 i = 0; i < ids.length; i++) {

            if (listSwaps[i].tAmount <= listSwaps[i].dAmount) continue;

            SwapData memory data = listSwaps[ids[i]];

            selectedIds[counter] = ids[i];

            users[counter] = data.user;

            recipients[counter] = _getRecipient(data.user);

            // don't need to use SafeMath here

            distributingAmounts[counter] = data.tAmount * percentage / 100;

            require(

                distributingAmounts[counter] + data.dAmount <= data.tAmount,

                "Estimate: total distribute more than 100%"

            );

            totalDistributingAmount += distributingAmounts[counter];

            daysIDs[counter] = listSwaps[i].daysID;

            counter += 1;

        }

        require(

            totalDistributingAmount <= saleToken.balanceOf(address(this)),

            "Estimate: not enough token balance"

        );

        isSafe = totalUsers <= SAFE_DISTRIBUTE_NUMBER;

    }



    /// @dev calculate amount token to distribute and send to user

    function _distributedToken(uint256 id, uint256 percentage)

        internal

        returns (uint256 distributingAmount)

    {

        SwapData memory data = listSwaps[id];

        distributingAmount = uint256(data.tAmount).mul(percentage).div(100);

        require(

            distributingAmount.add(data.dAmount) <= data.tAmount,

            "Distribute: total distribute more than 100%"

        );

        // percentage > 0, data.tAmount > 0

        assert (distributingAmount > 0);

        require(

            distributingAmount <= saleToken.balanceOf(address(this)),

            "Distribute: not enough token to distribute"

        );

        // no overflow, so don't need to use SafeMath here

        listSwaps[id].dAmount += uint80(distributingAmount);

        // send token to user's wallet

        address recipient = _transferToken(data.user, distributingAmount);

        emit Distributed(data.user, recipient, distributingAmount, percentage, block.timestamp);

    }



    function _transferToken(address user, uint256 amount) internal returns (address recipient) {

        recipient = _getRecipient(user);

        // safe check

        assert(recipient != address(0));

        saleToken.safeTransfer(recipient, amount);

    }



    function _getRecipient(address user) internal view returns(address recipient) {

        recipient = userTokenRecipient[user];

        if (recipient == address(0)) {

            recipient = user;

        }

    }



    /// @dev return received tokenAmount given ethAmount

    /// note that token decimals is 18

    function _getTokenAmount(uint256 ethAmount) internal view returns (uint256) {

        return ethAmount.mul(saleRate);

    }



    function _getUserSwappedAmount(address sender)

        internal view returns(

            uint80 eAmount,

            uint80 tAmount,

            uint80 dAmount

        )

    {

        uint256[] memory ids = userSwapData[sender];

        for(uint256 i = 0; i < ids.length; i++) {

            SwapData memory data = listSwaps[ids[i]];

            eAmount += data.eAmount;

            tAmount += data.tAmount;

            dAmount += data.dAmount;

        }

    }

}

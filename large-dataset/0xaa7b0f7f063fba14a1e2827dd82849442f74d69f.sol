// SPDX-License-Identifier: MIT



/**

 *Submitted for verification at Etherscan.io on 2020-09-03

*/



pragma solidity ^0.6.12;



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



/**

 * @title Various utilities useful for uint256.

 */

library UInt256Lib {



    uint256 private constant MAX_INT256 = ~(uint256(1) << 255);



    /**

     * @dev Safely converts a uint256 to an int256.

     */

    function toInt256Safe(uint256 a)

    internal

    pure

    returns (int256)

    {

        require(a <= MAX_INT256);

        return int256(a);

    }

}



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

     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.

     *

     * This internal function is equivalent to `approve`, and can be used to

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



interface HPPMerchantProof {

    function mint(address _to, uint256 _amount) external;

    function burn(address _account, uint256 _amount) external;

    function transfer(address recipient, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    function balanceOf(address account) external view returns (uint256);

}



interface HPPToken {

    function mint(address to, uint256 _amount) external;

    function burn(uint256 _amount) external;

    function transfer(address recipient, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    function balanceOf(address account) external view returns (uint256);

    function canMint(uint256 _amount) external view returns (bool);

}



contract MerchantPool is Ownable, Initializable {



    using SafeMath for uint256;

    using SafeERC20 for IERC20;



    // Info of each user.

    struct UserInfo {

        uint256 amount;     // How many LP tokens the user has provided.

        uint256 rewardDebt; // Reward debt. See explanation below.

        //

        // We do some fancy math here. Basically, any point in time, the amount of token

        // entitled to a user but is pending to be distributed is:

        //

        //   pending reward = (user.amount * pool.accPerShare) - user.rewardDebt

        //

        // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:

        //   1. The pool's `accPerShare` (and `lastRewardBlock`) gets updated.

        //   2. User receives the pending reward sent to his/her address.

        //   3. User's `amount` gets updated.

        //   4. User's `rewardDebt` gets updated.

    }



    struct MerchantInfo {

        uint256 sid;

        string name;

        string addr;

        string desc;

        int256 longitude;

        int256 latitude;

        address salesman;

        // Does the merchant support the burn of a part of consumption when receiving payment, in order to gain mining speed growth.

        // Open by default, you can choose to close.

        bool supportBurn;

        uint256 status;         // 1=normal, 2=deleted

    }



    struct SalesmanInfo {

        uint256 salesmanMargin;

        uint256 status;         // 1=normal, 2=cancel, 3=punish

    }



    uint256 constant DENOMINATOR = 100;

    uint256 public MIN_BLOCK_REWARD = 2 * 10**18;



    HPPToken public token;

    uint256 public perBlock;

    uint256 public reduceBlockCount;

    uint256 public lastReduceBlock;

    uint256 public reduceRate;

    uint256 public startBlock;



    HPPMerchantProof public lpToken;           // Address of LP token contract.

    uint256 public lastRewardBlock;  // Last block number that token distribution occurs.

    uint256 public accPerShare;    // Accumulated token per share, times 1e12. See below.



    uint256 public salesmanMargin;  // Deposit required to become a salesman

    uint256 public salesmanRewardRatio; // Percentage of salesman earning the merchant\u2019s mining share

    uint256 public consumptionDiscountRatio; // Discount rate for user purchase, the default is 10%

    uint256 public consumptionBurnRatio;    // The proportion of the amount of money that is destroyed when merchant collection, the default is 8%

    uint256 public serviceProviderRatio;     // The proportion of the collection share obtained by the operating service party, the default is 2%

    address public master;

    address public admin;

    mapping (address => SalesmanInfo) public salesmanInfo;

    mapping (address => MerchantInfo) public merchantInfo;

    // Info of each user that stakes LP tokens.

    mapping (address => UserInfo) public userInfo;

    address[] public merchantArray;

    mapping(bytes32 => bool) private consumeHashes;



    event Deposit(address indexed user, uint256 amount);

    event Withdraw(address indexed user, uint256 amount);

    event EmergencyWithdraw(address indexed user, uint256 amount);

    event RegisterSalesman(address indexed user);

    event RegisterMerchant(address indexed salesmanAddress, address indexed merchant, string name);

    event CancelSalesman(address indexed salesmanAddress);

    event RemoveMerchant(address indexed merchant);

    event PunishSalesman(address indexed salesmanAddress, address[] indexed merchants);

    event ChangeMerchantAddress(address indexed oldAddress, address indexed newAddress);

    event ChangeMerchantInfo(address indexed merchant);

    event Consume(address indexed user, address indexed merchant, address serviceProvider, uint256 indexed amount,

        uint256 merchantReceiveAmount, uint256 userDiscountAmount, uint256 serviceProviderAmount, uint256 burnAmount);



    modifier onlyMaster() {

        require(_msgSender() == master, "Only master.");

        _;

    }



    modifier onlyAdmin() {

        require(_msgSender() == admin, "Only admin.");

        _;

    }



    modifier onlySalesman() {

        require(salesmanInfo[_msgSender()].status == 1, "Only salesman.");

        _;

    }



    modifier onlyMerchant() {

        require(merchantInfo[_msgSender()].status == 1, "Only merchant.");

        _;

    }



    function initialize(HPPToken _token, uint256 _perBlock, uint256 _startBlock, uint256 _reduceBlockCount, HPPMerchantProof _lpToken, uint256 _salesmanMargin, address _master) public onlyOwner initializer {

        token = _token;

        perBlock = _perBlock;

        startBlock = _startBlock;

        reduceBlockCount = _reduceBlockCount;

        lastRewardBlock = block.number > startBlock ? block.number : _startBlock;

        lastReduceBlock = _startBlock;

        reduceRate = 3;



        lpToken = _lpToken;

        master = _master;

        admin = _master;

        salesmanMargin = _salesmanMargin;

        salesmanRewardRatio  = 10; // 10%

        consumptionDiscountRatio = 10;  // 10%

        consumptionBurnRatio = 8;      // 8%

        serviceProviderRatio = 2;  // 2%

    }



    function registerSalesman() public {

        address salesmanAddress = _msgSender();

        SalesmanInfo storage salesman = salesmanInfo[salesmanAddress];

        // Salesman who have been cancelled or punished can register again

        require(salesman.status != 1, "Cannot register twice.");

        uint256 bal = token.balanceOf(salesmanAddress);

        require(bal >= salesmanMargin, "Insufficient margin.");

        token.transferFrom(salesmanAddress, address(this), salesmanMargin);

        salesman.status = 1;

        salesman.salesmanMargin = salesmanMargin;



        emit RegisterSalesman(salesmanAddress);

    }



    function cancelSalesman() public onlySalesman {

        address salesmanAddress = _msgSender();

        SalesmanInfo storage salesman = salesmanInfo[salesmanAddress];

        require(salesman.status == 1, "The address is not salesman.");

        safeTokenTransfer(salesmanAddress, salesman.salesmanMargin);

        salesman.status = 2;

        salesman.salesmanMargin = 0;



        emit CancelSalesman(salesmanAddress);

    }



    function registerMerchant(address _address, string memory _name, string memory _desc, string memory _addr, int256 _longitude, int256 _latitude) public onlySalesman {

        MerchantInfo storage merchant = merchantInfo[_address];

        require(merchant.status == 0, "The merchant is already registered");

        merchant.sid = merchantArray.length;

        merchant.name = _name;

        merchant.desc = _desc;

        merchant.addr = _addr;

        merchant.longitude = _longitude;

        merchant.latitude = _latitude;

        merchant.salesman = _msgSender();

        merchant.supportBurn = true;

        merchant.status = 1;



        merchantArray.push(_address);

        lpToken.mint(_address, 10**18);

        emit RegisterMerchant(merchant.salesman, _address, _name);

    }



    function punishSalesman(address _salesmanAddress, address[] memory merchants) public onlyAdmin {

        SalesmanInfo storage salesman = salesmanInfo[_salesmanAddress];

        require(salesman.status == 1, "The address is not salesman.");

        burnToken(salesman.salesmanMargin);

        salesman.status = 3;

        salesman.salesmanMargin = 0;



        for (uint i = 0; i < merchants.length; i++) {

            address merchantAddress = merchants[i];

            UserInfo storage user = userInfo[merchantAddress];

            lpToken.burn(address(this), user.amount);

            user.amount = 0;

            user.rewardDebt = 0;

            delete userInfo[merchantAddress];



            MerchantInfo storage merchant = merchantInfo[merchantAddress];

            require(merchant.salesman == _salesmanAddress, "Merchant and salesman mismatch.");

            merchant.status = 2;



            emit RemoveMerchant(merchantAddress);

        }

        updatePool();

        emit PunishSalesman(_salesmanAddress, merchants);

    }



    function deleteMerchant(address _merchant) public onlyAdmin {

        UserInfo storage user = userInfo[_merchant];

        lpToken.burn(address(this), user.amount);

        user.amount = 0;

        user.rewardDebt = 0;

        delete userInfo[_merchant];



        MerchantInfo storage merchant = merchantInfo[_merchant];

        merchant.status = 2;



        updatePool();

        emit RemoveMerchant(_merchant);

    }



    function changeAdmin(address _admin) public onlyAdmin {

        admin = _admin;

    }



    function changeMaster(address _master) public onlyMaster {

        master = _master;

    }



    function changeSalesmanMargin(uint256 _salesmanMargin) public onlyMaster {

        salesmanMargin = _salesmanMargin;

    }



    function changeSalesmanRewardRatio(uint256 _salesmanRewardRatio) public onlyMaster {

        require(_salesmanRewardRatio >= 0 && _salesmanRewardRatio <= 20, "salesmanRewardRatio need >= 0 and <= 20");

        salesmanRewardRatio = _salesmanRewardRatio;

    }



    function changeConsumptionDiscountRatio(uint256 _consumptionDiscountRatio) public onlyMaster {

        require(_consumptionDiscountRatio >= 0 && _consumptionDiscountRatio <= 50, "consumptionDiscountRatio need >= 0 and <= 50");

        consumptionDiscountRatio = _consumptionDiscountRatio;

    }



    function changeConsumptionBurnRatio(uint256 _consumptionBurnRatio) public onlyMaster {

        require(_consumptionBurnRatio >= 0 && _consumptionBurnRatio <= 20, "consumptionBurnRatio need >= 0 and <= 20");

        consumptionBurnRatio = _consumptionBurnRatio;

    }



    function changeServiceProviderRatio(uint256 _serviceProviderRatio) public onlyMaster {

        require(_serviceProviderRatio >= 0 && _serviceProviderRatio <= 10, "serviceProviderRatio need >= 0 and <= 10");

        serviceProviderRatio = _serviceProviderRatio;

    }



    function changeReduce(uint256 _reduceBlockCount, uint256 _reduceRate) public onlyMaster {

        reduceBlockCount = _reduceBlockCount;

        reduceRate = _reduceRate;

    }



    function changeMerchantAddress(address _address) public onlyMerchant {

        require(merchantInfo[_address].status == 0, "Duplicate merchant address.");

        MerchantInfo storage merchant = merchantInfo[msg.sender];

        merchantInfo[_address] = merchant;

        merchantArray[merchant.sid] = _address;

        delete merchantInfo[msg.sender];



        UserInfo storage user = userInfo[msg.sender];

        userInfo[_address] = user;

        delete userInfo[msg.sender];



        emit ChangeMerchantAddress(msg.sender, _address);

    }



    function changeMerchantInfo(string memory _name, string memory _desc, string memory _addr, int256 _longitude, int256 _latitude) public onlyMerchant {

        MerchantInfo storage merchant = merchantInfo[msg.sender];

        merchant.name = _name;

        merchant.desc = _desc;

        merchant.addr = _addr;

        merchant.longitude = _longitude;

        merchant.latitude = _latitude;



        emit ChangeMerchantInfo(msg.sender);

    }



    function changeBurnFlag(bool supportBurn) public onlyMerchant {

        MerchantInfo storage merchant = merchantInfo[msg.sender];

        merchant.supportBurn = supportBurn;

    }



    // Consumption pay method, product realization end guides users to call this method

    function consume1(address _merchant, address _serviceProvider, uint256 _amount) public {

        consume(msg.sender, _merchant, _serviceProvider, _amount);

    }



    // Consumption payment method, the product realization end is available for merchants to call, due to the high gas fee, this method can pass the payment cost to the merchant, reducing the user cost

    // For other rules, please refer to consume1 method

    function consume2(address _merchant, address _serviceProvider, uint256 _amount, uint256 time, bytes memory signature) public {

        bytes32 hash = keccak256(abi.encodePacked(_merchant, _serviceProvider, _amount, time));

        require(!consumeHashes[hash], "Repeat consumption.");

        address userAddress = ecrecovery(hash, signature);

        require(userAddress != address(0), "Signature error.");

        consume(userAddress, _merchant, _serviceProvider, _amount);

        consumeHashes[hash] = true;

    }



    // View function to see pending token on frontend.

    function pendingToken(address _user) external view returns (uint256) {

        UserInfo storage user = userInfo[_user];

        uint256 lpSupply = lpToken.balanceOf(address(this));

        uint256 accPerShareTemp = accPerShare;

        if (block.number > lastRewardBlock && lpSupply != 0) {

            uint256 reward;

            uint256 afterReduceBlock;

            uint256 afterPerBlock;

            (reward, afterPerBlock, afterReduceBlock) = calculateReward();

            accPerShareTemp = accPerShareTemp.add(reward.mul(1e12).div(lpSupply));

        }

        uint256 pendingReward = user.amount.mul(accPerShareTemp).div(1e12).sub(user.rewardDebt);

        if (salesmanRewardRatio > 0) {

            pendingReward = pendingReward.sub(pendingReward.mul(salesmanRewardRatio).div(DENOMINATOR));

        }

        return pendingReward;

    }



    function updatePool() public {

        if (block.number <= lastRewardBlock) {

            return;

        }

        uint256 reward;

        uint256 afterReduceBlock;

        uint256 afterPerBlock;

        (reward, afterPerBlock, afterReduceBlock) = calculateReward();

        if (afterReduceBlock != lastReduceBlock) {

            lastReduceBlock = afterReduceBlock;

        }

        if (afterPerBlock != perBlock) {

            perBlock = afterPerBlock;

        }

        uint256 lpSupply = lpToken.balanceOf(address(this));

        if (lpSupply == 0) {

            lastRewardBlock = block.number;

            return;

        }

        if (token.canMint(reward)) {

            token.mint(address(this), reward);

            accPerShare = accPerShare.add(reward.mul(1e12).div(lpSupply));

        }

        lastRewardBlock = block.number;

    }



    function deposit(uint256 _amount) public onlyMerchant {

        UserInfo storage user = userInfo[msg.sender];

        updatePool();

        if (user.amount > 0) {

            sendReward(user, msg.sender);

        }

        if (_amount > 0) {

            lpToken.transferFrom(address(msg.sender), address(this), _amount);

        }

        user.amount = user.amount.add(_amount);

        user.rewardDebt = user.amount.mul(accPerShare).div(1e12);

        emit Deposit(msg.sender, _amount);

    }



    // Withdraw LP tokens from pool.

    function withdraw(uint256 _amount) public onlyMerchant {

        UserInfo storage user = userInfo[msg.sender];

        require(user.amount >= _amount, "withdraw: not good");

        updatePool();

        sendReward(user, msg.sender);

        user.amount = user.amount.sub(_amount);

        user.rewardDebt = user.amount.mul(accPerShare).div(1e12);

        if (_amount > 0) {

            lpToken.transfer(address(msg.sender), _amount);

        }

        emit Withdraw(msg.sender, _amount);

    }



    function sendReward(UserInfo storage _user, address receiveAddress) internal {

        uint256 pending = _user.amount.mul(accPerShare).div(1e12).sub(_user.rewardDebt);

        if (pending == 0) {

            return;

        }

        if (salesmanRewardRatio > 0) {

            uint256 salesmanReward = pending.mul(salesmanRewardRatio).div(DENOMINATOR);

            MerchantInfo storage merchant = merchantInfo[receiveAddress];

            if (salesmanInfo[merchant.salesman].status == 1) {

                safeTokenTransfer(merchant.salesman, salesmanReward);

            } else {

                burnToken(salesmanReward);

            }

            pending = pending.sub(salesmanReward);

        }

        safeTokenTransfer(receiveAddress, pending);

    }



    function safeTokenTransfer(address _to, uint256 _amount) internal {

        uint256 bal = token.balanceOf(address(this));

        if (_amount > bal) {

            token.transfer(_to, bal);

        } else {

            token.transfer(_to, _amount);

        }

    }



    function burnToken(uint256 _amount) internal {

        token.burn(_amount);

    }



    function consume(address _user, address _merchant, address _serviceProvider, uint256 _amount) internal {

        require(token.balanceOf(_user) >= _amount, "Insufficient balance.");

        MerchantInfo storage merchant = merchantInfo[_merchant];

        require(merchant.status == 1, "The merchant is wrong.");



        bool suc = token.transferFrom(_user, address(this), _amount);

        require(suc, "Transfer failed.");



        uint256 userDiscountAmount = _amount.mul(consumptionDiscountRatio).div(DENOMINATOR);

        uint256 serviceProviderAmount = uint256(0);

        if (_serviceProvider != address(0x0)) {

            serviceProviderAmount = _amount.mul(serviceProviderRatio).div(DENOMINATOR);

            safeTokenTransfer(_serviceProvider, serviceProviderAmount);

        }

        uint256 burnAmount = uint256(0);

        uint256 rewardLPAmount = uint256(0);

        if (merchant.supportBurn) {

            burnAmount = _amount.mul(consumptionBurnRatio).div(DENOMINATOR);

            burnToken(burnAmount);

            rewardLPAmount = 5 * 10 ** 16;

        } else {

            rewardLPAmount = 1 * 10 ** 16;

        }

        updatePool();

        UserInfo storage user = userInfo[_merchant];

        if (user.amount > 0) {

            sendReward(user, _merchant);

        }

        lpToken.mint(address(this), rewardLPAmount);

        user.amount = user.amount.add(rewardLPAmount);

        user.rewardDebt = user.amount.mul(accPerShare).div(1e12);



        uint256 merchantReceiveAmount = _amount.sub(userDiscountAmount).sub(serviceProviderAmount).sub(burnAmount);

        safeTokenTransfer(_merchant, merchantReceiveAmount);

        safeTokenTransfer(_user, userDiscountAmount);



        emit Consume(_user, _merchant, _serviceProvider, _amount, merchantReceiveAmount, userDiscountAmount, serviceProviderAmount, burnAmount);

    }



    function calculateReward() internal view returns (uint256, uint256, uint256) {

        uint256 segmentCount = (block.number.sub(lastReduceBlock)).div(reduceBlockCount);

        uint256 reward = (block.number.sub(lastRewardBlock)).mul(perBlock);

        uint256 afterPerBlock = perBlock;

        uint256 afterReduceBlock = lastReduceBlock;

        if (segmentCount > 0) {

            reward = (lastReduceBlock.add(reduceBlockCount).sub(lastRewardBlock)).mul(perBlock);

            for (uint256 i = 1 ; i <= segmentCount ; i++) {

                afterPerBlock = afterPerBlock.mul(DENOMINATOR.sub(reduceRate)).div(DENOMINATOR);

                if (afterPerBlock < MIN_BLOCK_REWARD) {

                    afterPerBlock = MIN_BLOCK_REWARD;

                }

                uint256 segmentBlockCount = reduceBlockCount;

                uint256 segmentEndCount = lastReduceBlock.add(reduceBlockCount.mul(i + 1));

                if (block.number < segmentEndCount) {

                    segmentBlockCount = block.number.sub(lastReduceBlock.add(reduceBlockCount.mul(i)));

                }

                uint256 segmentReward = segmentBlockCount.mul(afterPerBlock);

                reward = reward.add(segmentReward);

            }

            afterReduceBlock = afterReduceBlock.add(segmentCount.mul(reduceBlockCount));

        }

        return (reward, afterPerBlock, afterReduceBlock);

    }



    function merchantLength() public view returns (uint256) {

        return merchantArray.length;

    }



    function ecrecovery(bytes32 hash, bytes memory sig) private pure returns (address) {

        bytes32 r;

        bytes32 s;

        uint8 v;

        if (sig.length != 65) {

            return address(0);

        }

        assembly {

            r := mload(add(sig, 32))

            s := mload(add(sig, 64))

            v := byte(0, mload(add(sig, 96)))

        }

        // https://github.com/ethereum/go-ethereum/issues/2053

        if (v < 27) {

            v += 27;

        }

        if (v != 27 && v != 28) {

            return address(0);

        }

        return ecrecover(hash, v, r, s);

    }

}

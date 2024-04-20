// File: @openzeppelin/contracts/math/SafeMath.sol



pragma solidity >=0.6.0 <0.8.0;



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



// File: @openzeppelin/contracts/token/ERC20/IERC20.sol







pragma solidity >=0.6.0 <0.8.0;



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



// File: @openzeppelin/contracts/utils/Address.sol







pragma solidity >=0.6.2 <0.8.0;



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

        // This method relies on extcodesize, which returns 0 for contracts in

        // construction, since the code is only stored at the end of the

        // constructor execution.



        uint256 size;

        // solhint-disable-next-line no-inline-assembly

        assembly { size := extcodesize(account) }

        return size > 0;

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

        return functionCallWithValue(target, data, 0, errorMessage);

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

        require(isContract(target), "Address: call to non-contract");



        // solhint-disable-next-line avoid-low-level-calls

        (bool success, bytes memory returndata) = target.call{ value: value }(data);

        return _verifyCallResult(success, returndata, errorMessage);

    }



    /**

     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],

     * but performing a static call.

     *

     * _Available since v3.3._

     */

    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {

        return functionStaticCall(target, data, "Address: low-level static call failed");

    }



    /**

     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],

     * but performing a static call.

     *

     * _Available since v3.3._

     */

    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {

        require(isContract(target), "Address: static call to non-contract");



        // solhint-disable-next-line avoid-low-level-calls

        (bool success, bytes memory returndata) = target.staticcall(data);

        return _verifyCallResult(success, returndata, errorMessage);

    }



    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {

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



// File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol







pragma solidity >=0.6.0 <0.8.0;









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



// File: contracts/aave/IFlashLoanReceiver.sol



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



// File: contracts/aave/ILendingPoolAddressesProvider.sol



pragma solidity ^0.6.6;



/**

    @title ILendingPoolAddressesProvider interface

    @notice provides the interface to fetch the LendingPoolCore address

 */



interface ILendingPoolAddressesProvider {

    function getLendingPoolCore() external view returns (address payable);

    function getLendingPool() external view returns (address);

}



// File: @openzeppelin/contracts/GSN/Context.sol







pragma solidity >=0.6.0 <0.8.0;



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



// File: @openzeppelin/contracts/token/ERC20/ERC20.sol







pragma solidity >=0.6.0 <0.8.0;









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

    constructor (string memory name_, string memory symbol_) public {

        _name = name_;

        _symbol = symbol_;

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

     * required by the EIP. See the note at the beginning of {ERC20}.

     *

     * Requirements:

     *

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

     * Requirements:

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

     * Requirements:

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



// File: @openzeppelin/contracts/access/Ownable.sol







pragma solidity >=0.6.0 <0.8.0;



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

abstract contract Ownable is Context {

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



// File: contracts/utils/Withdrawable.sol



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



// File: contracts/aave/FlashLoanReceiverBase.sol



pragma solidity ^0.6.6;















abstract contract FlashLoanReceiverBase is IFlashLoanReceiver, Withdrawable {



    using SafeERC20 for IERC20;

    using SafeMath for uint256;



    address constant ethAddress = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    ILendingPoolAddressesProvider public addressesProvider;



    constructor(address _addressProvider) public {

        addressesProvider = ILendingPoolAddressesProvider(_addressProvider);

    }



    receive() payable external {}



    function transferFundsBackToPoolInternal(address _reserve, uint256 _amount) internal {

        address payable core = addressesProvider.getLendingPoolCore();

        transferInternal(core, _reserve, _amount);

    }



    function transferInternal(address payable _destination, address _reserve, uint256 _amount) internal {

        if(_reserve == ethAddress) {

            (bool success, ) = _destination.call{value: _amount}("");

            require(success == true, "Couldn't transfer ETH");

            return;

        }

        IERC20(_reserve).safeTransfer(_destination, _amount);

    }



    function getBalanceInternal(address _target, address _reserve) internal view returns(uint256) {

        if(_reserve == ethAddress) {

            return _target.balance;

        }

        return IERC20(_reserve).balanceOf(_target);

    }

}



// File: contracts/aave/ILendingPool.sol



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



// File: contracts/wepiggy/IComptroller.sol



pragma solidity 0.6.12;



interface IComptroller {



    /*** Assets You Are In ***/



    /**

     * PIGGY-MODIFY:

     * @notice Add assets to be included in account liquidity calculation

     * @param pTokens The list of addresses of the cToken markets to be enabled

     * @return Success indicator for whether each corresponding market was entered

     */

    function enterMarkets(address[] calldata pTokens) external returns (uint[] memory);



    /**

     * PIGGY-MODIFY:

     * @notice Removes asset from sender's account liquidity calculation

     * @dev Sender must not have an outstanding borrow balance in the asset,

     *  or be providing necessary collateral for an outstanding borrow.

     * @param pTokenAddress The address of the asset to be removed

     * @return Whether or not the account successfully exited the market

     */

    function exitMarket(address pTokenAddress) external returns (uint);



    /*** Policy Hooks ***/



    /**

     * PIGGY-MODIFY:

     * @notice Checks if the account should be allowed to mint tokens in the given market

     * @param pToken The market to verify the mint against

     * @param minter The account which would get the minted tokens

     * @param mintAmount The amount of underlying being supplied to the market in exchange for tokens

     * @return 0 if the mint is allowed, otherwise a semi-opaque error code (See ErrorReporter.sol)

     */

    function mintAllowed(

        address pToken,

        address minter,

        uint mintAmount

    ) external returns (uint);



    /**

     * PIGGY-MODIFY:

     * @notice Validates mint and reverts on rejection. May emit logs.

     * @param pToken Asset being minted

     * @param minter The address minting the tokens

     * @param mintAmount The amount of the underlying asset being minted

     * @param mintTokens The number of tokens being minted

     */

    function mintVerify(

        address pToken,

        address minter,

        uint mintAmount,

        uint mintTokens

    ) external;



    /**

     * PIGGY-MODIFY:

     * @notice Checks if the account should be allowed to redeem tokens in the given market

     * @param pToken The market to verify the redeem against

     * @param redeemer The account which would redeem the tokens

     * @param redeemTokens The number of cTokens to exchange for the underlying asset in the market

     * @return 0 if the redeem is allowed, otherwise a semi-opaque error code (See ErrorReporter.sol)

     */

    function redeemAllowed(

        address pToken,

        address redeemer,

        uint redeemTokens

    ) external returns (uint);



    /**

     * PIGGY-MODIFY:

     * @notice Validates redeem and reverts on rejection. May emit logs.

     * @param pToken Asset being redeemed

     * @param redeemer The address redeeming the tokens

     * @param redeemAmount The amount of the underlying asset being redeemed

     * @param redeemTokens The number of tokens being redeemed

     */

    function redeemVerify(

        address pToken,

        address redeemer,

        uint redeemAmount,

        uint redeemTokens

    ) external;



    /**

     * PIGGY-MODIFY:

     * @notice Checks if the account should be allowed to borrow the underlying asset of the given market

     * @param pToken The market to verify the borrow against

     * @param borrower The account which would borrow the asset

     * @param borrowAmount The amount of underlying the account would borrow

     * @return 0 if the borrow is allowed, otherwise a semi-opaque error code (See ErrorReporter.sol)

     */

    function borrowAllowed(

        address pToken,

        address borrower,

        uint borrowAmount

    ) external returns (uint);



    /**

     * PIGGY-MODIFY:

     * @notice Validates borrow and reverts on rejection. May emit logs.

     * @param pToken Asset whose underlying is being borrowed

     * @param borrower The address borrowing the underlying

     * @param borrowAmount The amount of the underlying asset requested to borrow

     */

    function borrowVerify(

        address pToken,

        address borrower,

        uint borrowAmount

    ) external;



    /**

     * PIGGY-MODIFY:

     * @notice Checks if the account should be allowed to repay a borrow in the given market

     * @param pToken The market to verify the repay against

     * @param payer The account which would repay the asset

     * @param borrower The account which would borrowed the asset

     * @param repayAmount The amount of the underlying asset the account would repay

     * @return 0 if the repay is allowed, otherwise a semi-opaque error code (See ErrorReporter.sol)

     */

    function repayBorrowAllowed(

        address pToken,

        address payer,

        address borrower,

        uint repayAmount

    ) external returns (uint);



    /**

     * PIGGY-MODIFY:

     * @notice Validates repayBorrow and reverts on rejection. May emit logs.

     * @param pToken Asset being repaid

     * @param payer The address repaying the borrow

     * @param borrower The address of the borrower

     * @param repayAmount The amount of underlying being repaid

     */

    function repayBorrowVerify(

        address pToken,

        address payer,

        address borrower,

        uint repayAmount,

        uint borrowerIndex

    ) external;



    /**

     * PIGGY-MODIFY:

     * @notice Checks if the liquidation should be allowed to occur

     * @param pTokenBorrowed Asset which was borrowed by the borrower

     * @param pTokenCollateral Asset which was used as collateral and will be seized

     * @param liquidator The address repaying the borrow and seizing the collateral

     * @param borrower The address of the borrower

     * @param repayAmount The amount of underlying being repaid

     */

    function liquidateBorrowAllowed(

        address pTokenBorrowed,

        address pTokenCollateral,

        address liquidator,

        address borrower,

        uint repayAmount

    ) external returns (uint);



    /**

     * PIGGY-MODIFY:

     * @notice Validates liquidateBorrow and reverts on rejection. May emit logs.

     * @param pTokenBorrowed Asset which was borrowed by the borrower

     * @param pTokenCollateral Asset which was used as collateral and will be seized

     * @param liquidator The address repaying the borrow and seizing the collateral

     * @param borrower The address of the borrower

     * @param repayAmount The amount of underlying being repaid

     */

    function liquidateBorrowVerify(

        address pTokenBorrowed,

        address pTokenCollateral,

        address liquidator,

        address borrower,

        uint repayAmount,

        uint seizeTokens

    ) external;



    /**

     * PIGGY-MODIFY:

     * @notice Checks if the seizing of assets should be allowed to occur

     * @param pTokenCollateral Asset which was used as collateral and will be seized

     * @param pTokenBorrowed Asset which was borrowed by the borrower

     * @param liquidator The address repaying the borrow and seizing the collateral

     * @param borrower The address of the borrower

     * @param seizeTokens The number of collateral tokens to seize

     */

    function seizeAllowed(

        address pTokenCollateral,

        address pTokenBorrowed,

        address liquidator,

        address borrower,

        uint seizeTokens

    ) external returns (uint);



    /**

     * PIGGY-MODIFY:

     * @notice Validates seize and reverts on rejection. May emit logs.

     * @param pTokenCollateral Asset which was used as collateral and will be seized

     * @param pTokenBorrowed Asset which was borrowed by the borrower

     * @param liquidator The address repaying the borrow and seizing the collateral

     * @param borrower The address of the borrower

     * @param seizeTokens The number of collateral tokens to seize

     */

    function seizeVerify(

        address pTokenCollateral,

        address pTokenBorrowed,

        address liquidator,

        address borrower,

        uint seizeTokens

    ) external;



    /**

     * PIGGY-MODIFY:

     * @notice Checks if the account should be allowed to transfer tokens in the given market

     * @param pToken The market to verify the transfer against

     * @param src The account which sources the tokens

     * @param dst The account which receives the tokens

     * @param transferTokens The number of pTokens to transfer

     * @return 0 if the transfer is allowed, otherwise a semi-opaque error code (See ErrorReporter.sol)

     */

    function transferAllowed(

        address pToken,

        address src,

        address dst,

        uint transferTokens

    ) external returns (uint);



    /**

     * PIGGY-MODIFY:

     * @notice Validates transfer and reverts on rejection. May emit logs.

     * @param pToken Asset being transferred

     * @param src The account which sources the tokens

     * @param dst The account which receives the tokens

     * @param transferTokens The number of pTokens to transfer

     */

    function transferVerify(

        address pToken,

        address src,

        address dst,

        uint transferTokens

    ) external;



    /*** Liquidity/Liquidation Calculations ***/



    /**

     * PIGGY-MODIFY:

    * @notice Calculate number of tokens of collateral asset to seize given an underlying amount

    * @dev Used in liquidation (called in cToken.liquidateBorrowFresh)

    * @param pTokenBorrowed The address of the borrowed cToken

    * @param pTokenCollateral The address of the collateral cToken

    * @param repayAmount The amount of cTokenBorrowed underlying to convert into cTokenCollateral tokens

    * @return (errorCode, number of cTokenCollateral tokens to be seized in a liquidation)

    */

    function liquidateCalculateSeizeTokens(

        address pTokenBorrowed,

        address pTokenCollateral,

        uint repayAmount

    ) external view returns (uint, uint);

}



// File: contracts/wepiggy/IInterestRateModel.sol



pragma solidity ^0.6.0;



/**

  * @title wepiggy's IInterestRateModel Interface

  * @author wepiggy

  */

interface IInterestRateModel {

    /**

      * @notice Calculates the current borrow interest rate per block

      * @param cash The total amount of cash the market has

      * @param borrows The total amount of borrows the market has outstanding

      * @param reserves The total amount of reserves the market has

      * @return The borrow rate per block (as a percentage, and scaled by 1e18)

      */

    function getBorrowRate(uint cash, uint borrows, uint reserves) external view returns (uint);



    /**

      * @notice Calculates the current supply interest rate per block

      * @param cash The total amount of cash the market has

      * @param borrows The total amount of borrows the market has outstanding

      * @param reserves The total amount of reserves the market has

      * @param reserveFactorMantissa The current reserve factor the market has

      * @return The supply rate per block (as a percentage, and scaled by 1e18)

      */

    function getSupplyRate(uint cash, uint borrows, uint reserves, uint reserveFactorMantissa) external view returns (uint);



}



// File: contracts/wepiggy/IPToken.sol



pragma solidity ^0.6.0;







contract PTokenStorage {

    /**

     * @notice Indicator that this is a PToken contract (for inspection)

     */

    bool public constant isPToken = true;



    /**

     * @dev Guard variable for re-entrancy checks

     */

    bool internal _notEntered;



    /**

     * @dev

     * @notice EIP-20 token name for this token

     */

    string public name;



    /**

     * @dev

     * @notice EIP-20 token symbol for this token

     */

    string public symbol;



    /**

     * @dev

     * @notice EIP-20 token decimals for this token

     */

    uint8 public decimals;



    /**

     * @dev

     * @notice Maximum borrow rate that can ever be applied (.0005% / block)

     */



    uint256 internal constant borrowRateMaxMantissa = 0.0005e16;



    /**

     * @dev

     * @notice Maximum fraction of interest that can be set aside for reserves

     */

    uint256 internal constant reserveFactorMaxMantissa = 1e18;



    /**

     * @dev

     * @notice Contract which oversees inter-pToken operations

     */

    IComptroller public comptroller;



    /**

     * @dev

     * @notice Model which tells what the current interest rate should be

     */

    IInterestRateModel public interestRateModel;



    /**

     * @dev

     * @notice Initial exchange rate used when minting the first PTokens (used when totalSupply = 0)

     */

    uint256 internal initialExchangeRateMantissa;



    /**

     * @dev

     * @notice Fraction of interest currently set aside for reserves

     */

    uint256 public reserveFactorMantissa;



    /**

     * @dev

     * @notice Block number that interest was last accrued at

     */

    uint256 public accrualBlockNumber;



    /**

     * @dev

     * @notice Accumulator of the total earned interest rate since the opening of the market

     */

    uint256 public borrowIndex;



    /**

     * @dev

     * @notice Total amount of outstanding borrows of the underlying in this market

     */

    uint256 public totalBorrows;



    /**

     * @dev

     * @notice Total amount of reserves of the underlying held in this market

     */

    uint256 public totalReserves;



    /**

     * @dev

     * @notice Total number of tokens in circulation

     */

    uint256 public totalSupply;



    /**

     * @dev

     * @notice Official record of token balances for each account

     */

    mapping(address => uint256) internal accountTokens;



    /**

     * @dev

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

     * @dev

     * @notice Mapping of account addresses to outstanding borrow balances

     */

    mapping(address => BorrowSnapshot) internal accountBorrows;



    address public migrator;



    uint256 public minInterestAccumulated;



}



abstract contract IPToken is PTokenStorage {



    /*** User Interface ***/



    function transfer(address dst, uint256 amount) external virtual returns (bool);



    function transferFrom(address src, address dst, uint256 amount) external virtual returns (bool);



    function approve(address spender, uint256 amount) external virtual returns (bool);



    function allowance(address owner, address spender) external virtual view returns (uint256);



    function balanceOf(address owner) external virtual view returns (uint256);



    function balanceOfUnderlying(address owner) external virtual returns (uint256);



    function getAccountSnapshot(address account) external virtual view returns (uint256, uint256, uint256, uint256);



    function borrowRatePerBlock() external virtual view returns (uint256);



    function supplyRatePerBlock() external virtual view returns (uint256);



    function totalBorrowsCurrent() external virtual returns (uint256);



    function borrowBalanceCurrent(address account) external virtual returns (uint256);



    function borrowBalanceStored(address account) public virtual view returns (uint256);



    function exchangeRateCurrent() public virtual returns (uint256);



    function exchangeRateStored() public virtual view returns (uint256);



    function getCash() external virtual view returns (uint256);



    function accrueInterest() public virtual returns (uint256);



    function seize(address liquidator, address borrower, uint256 seizeTokens) external virtual returns (uint256);



    /*** Admin Functions ***/



    function _setComptroller(IComptroller newComptroller) public virtual returns (uint256);



    function _setReserveFactor(uint256 newReserveFactorMantissa) external virtual returns (uint256);



    function _reduceReserves(uint256 reduceAmount) external virtual returns (uint256);



    function _setInterestRateModel(IInterestRateModel newInterestRateModel) public virtual returns (uint256);



    function _setMigrator(address newMigrator) public virtual returns (uint256);



    function _setMinInterestAccumulated(uint _minInterestAccumulated) public virtual returns (uint256);

}



// File: contracts/wepiggy/IPETH.sol



pragma solidity ^0.6.0;





abstract contract IPETH is IPToken {



    /*** User Interface ***/

    function mint() external payable virtual;



    function redeem(uint redeemTokens) external virtual returns (uint);



    function redeemUnderlying(uint redeemAmount) external virtual returns (uint);



    function borrow(uint borrowAmount) external virtual returns (uint);



    function repayBorrow() external payable virtual;



    function repayBorrowBehalf(address borrower) external virtual payable;



    function liquidateBorrow(address borrower, IPToken pTokenCollateral) external virtual payable;



}



// File: contracts/wepiggy/IPERC20.sol



pragma solidity ^0.6.0;





abstract contract IPERC20 is IPToken {



    address public underlying;



    /*** User Interface ***/



    function mint(uint256 mintAmount) external virtual returns (uint256);



    function redeem(uint256 redeemTokens) external virtual returns (uint256);



    function redeemUnderlying(uint256 redeemAmount) external virtual returns (uint256);



    function borrow(uint256 borrowAmount) external virtual returns (uint256);



    function repayBorrow(uint256 repayAmount) external virtual returns (uint256);



    function repayBorrowBehalf(address borrower, uint256 repayAmount) external virtual returns (uint256);



    function liquidateBorrow(address borrower, uint256 repayAmount, IPToken pTokenCollateral) external virtual returns (uint256);



    /*** Admin Functions ***/



    function _addReserves(uint256 addAmount) external virtual returns (uint256);

}



// File: contracts/uniswap/IUniswapV2Router01.sol



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



// File: contracts/uniswap/IUniswapV2Router02.sol



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



// File: contracts/FlashLoanLiquidateWePiggy.sol



pragma solidity 0.6.12;























contract FlashLoanLiquidateWePiggy is FlashLoanReceiverBase {



    using SafeMath for uint256;



    IComptroller public comptroller;

    IUniswapV2Router02 public uniswapRouter;

    bool public transferAtOnce;



    constructor(address _addressProvider, address _addressComptroller, address _addressUniswapRouter) FlashLoanReceiverBase(_addressProvider) public {

        comptroller = IComptroller(_addressComptroller);

        uniswapRouter = IUniswapV2Router02(_addressUniswapRouter);

    }



    /**

        This function is called after your contract has received the flash loaned amount

     */

    function executeOperation(

        address _reserve,

        uint256 _amount,

        uint256 _fee,

        bytes calldata _params

    )

    external

    override

    {

        require(_amount <= getBalanceInternal(address(this), _reserve), "Invalid balance, was the flashLoan successful?");



        // pTokenBorrow \u8981\u88ab\u6e05\u7b97\u7684pToken ; pTokenCollateral \u62b5\u62bc\u7269pToken ; borrower \u501f\u6b3e\u4eba ; repayAmount \u6e05\u7b97\u6570\u91cf ; path uniswap\u7684\u4ea4\u6613\u8def\u5f84

        (address _pTokenBorrow,address _pTokenCollateral,address borrower, uint repayAmount,address[] memory path) = abi.decode(_params, (address, address, address, uint, address[]));



        IPToken pTokenBorrow = IPToken(_pTokenBorrow);

        IPToken pTokenCollateral = IPToken(_pTokenCollateral);



        uint totalDebt = _amount.add(_fee);



        //enterMarket

        address[] memory pTokens = new address[](2);

        pTokens[0] = _pTokenBorrow;

        pTokens[1] = _pTokenCollateral;

        comptroller.enterMarkets(pTokens);



        if (_isEth(pTokenBorrow.symbol()) && _isEth(pTokenCollateral.symbol())) {



            _liquidateETHAndRepayETH(IPETH(_pTokenBorrow), IPETH(_pTokenCollateral), borrower, repayAmount, path, totalDebt);



        } else if (_isEth(pTokenBorrow.symbol()) && !_isEth(pTokenCollateral.symbol())) {



            _liquidateETHAndRepayERC20(IPETH(_pTokenBorrow), IPERC20(_pTokenCollateral), borrower, repayAmount, path, totalDebt);



        } else if (!_isEth(pTokenBorrow.symbol()) && _isEth(pTokenCollateral.symbol())) {



            _liquidateERC20AndRepayETH(IPERC20(_pTokenBorrow), IPETH(_pTokenCollateral), borrower, repayAmount, path, totalDebt);



        } else if (!_isEth(pTokenBorrow.symbol()) && !_isEth(pTokenCollateral.symbol())) {



            _liquidateERC20AndRepayERC20(IPERC20(_pTokenBorrow), IPERC20(_pTokenCollateral), borrower, repayAmount, path, totalDebt);

        }





        transferFundsBackToPoolInternal(_reserve, totalDebt);

    }



    /**

    *  _asset \u9700\u8981\u501f\u6b3e\u7684\u4ee3\u5e01\u7684\u5408\u7ea6\u5730\u5740\uff0cETH\u4e3a 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE

    *  amount \u9700\u8981\u501f\u6b3e\u7684\u91d1\u989d

    */

    function flashloan(address _asset, uint amount, bytes memory data) public {

        ILendingPool lendingPool = ILendingPool(addressesProvider.getLendingPool());

        lendingPool.flashLoan(address(this), _asset, amount, data);



        if (transferAtOnce) {

            _transferInternal(_asset, msg.sender, getBalanceInternal(address(this), _asset));

        }

    }



    function transfer(address _asset, address payable _to, uint amount) public onlyOwner {

        _transferInternal(_asset, _to, amount);

    }



    function setTransferAtOnce(bool _transferAtOnce) public onlyOwner {

        transferAtOnce = _transferAtOnce;

    }





    // \u6e05\u7b97ETH && \u8d4e\u56deETH

    function _liquidateETHAndRepayETH(

        IPETH pTokenBorrow,

        IPETH pTokenCollateral,

        address borrower,

        uint repayAmount,

        address[] memory path,

        uint totalDebt

    )

    internal

    {



        address self = address(this);



        //\u8ba1\u7b97\u6e05\u7b97\u7684\u503c

        (,uint seized) = comptroller.liquidateCalculateSeizeTokens(address(pTokenBorrow), address(pTokenCollateral), repayAmount);



        //\u8c03\u7528\u6e05\u7b97\u65b9\u6cd5

        pTokenBorrow.liquidateBorrow{value : repayAmount}(borrower, pTokenCollateral);



        //\u8d4e\u56deETH

        pTokenCollateral.redeem(seized);



    }



    // \u6e05\u7b97ETH && \u8d4e\u56deERC20 \uff0c \u5f97\u5230 ETH

    function _liquidateETHAndRepayERC20(

        IPETH pTokenBorrow,

        IPERC20 pTokenCollateral,

        address borrower,

        uint repayAmount,

        address[] memory path,

        uint totalDebt

    )

    internal

    {



        address self = address(this);



        //\u8ba1\u7b97\u6e05\u7b97\u7684\u503c

        (,uint seized) = comptroller.liquidateCalculateSeizeTokens(address(pTokenBorrow), address(pTokenCollateral), repayAmount);



        //\u8c03\u7528\u6e05\u7b97\u65b9\u6cd5

        pTokenBorrow.liquidateBorrow{value : repayAmount}(borrower, pTokenCollateral);



        //\u8d4e\u56deERC20

        pTokenCollateral.redeem(seized);



        //\u53bb uniSwap\u7b49\u4ea4\u6613\u6240\u8fdb\u884c\u4ea4\u6613\uff0c\u83b7\u5f97 ETH

        IERC20 erc20 = IERC20(pTokenCollateral.underlying());

        uint amountIn = erc20.balanceOf(self);

        _approveMax(address(erc20), address(uniswapRouter), amountIn);



        uniswapRouter.swapExactTokensForETH(amountIn, totalDebt, path, self, block.timestamp);



    }



    // \u6e05\u7b97ERC20 && \u8d4e\u56deETH \uff0c \u5f97\u5230 ERC20  --> OK

    function _liquidateERC20AndRepayETH(

        IPERC20 pTokenBorrow,

        IPETH pTokenCollateral,

        address borrower,

        uint repayAmount,

        address[] memory path,

        uint totalDebt

    )

    internal

    {

        address self = address(this);



        //\u8ba1\u7b97\u6e05\u7b97\u7684\u503c

        (,uint seized) = comptroller.liquidateCalculateSeizeTokens(address(pTokenBorrow), address(pTokenCollateral), repayAmount);



        //\u8c03\u7528\u6e05\u7b97\u65b9\u6cd5

        IERC20 erc20 = IERC20(pTokenBorrow.underlying());

        _approveMax(address(erc20), address(pTokenBorrow), repayAmount);

        pTokenBorrow.liquidateBorrow(borrower, repayAmount, pTokenCollateral);



        //\u8d4e\u56deETH

        pTokenCollateral.redeem(seized);



        //\u53bb uniSwap\u7b49\u4ea4\u6613\u6240\u8fdb\u884c\u4ea4\u6613\uff0c\u83b7\u5f97 \u5bf9\u5e94\u7684token

        uint amountIn = self.balance;

        uniswapRouter.swapExactETHForTokens{value : amountIn}(totalDebt, path, self, block.timestamp);



    }



    // \u6e05\u7b97ERC20 && \u8d4e\u56deERC20  --> OK

    function _liquidateERC20AndRepayERC20(

        IPERC20 pTokenBorrow,

        IPERC20 pTokenCollateral,

        address borrower,

        uint repayAmount,

        address[] memory path,

        uint totalDebt

    )

    internal

    {



        address self = address(this);



        //\u8ba1\u7b97\u6e05\u7b97\u7684\u503c

        (,uint seized) = comptroller.liquidateCalculateSeizeTokens(address(pTokenBorrow), address(pTokenCollateral), repayAmount);



        //\u8c03\u7528\u6e05\u7b97\u65b9\u6cd5

        IERC20 erc20 = IERC20(pTokenBorrow.underlying());

        _approveMax(address(erc20), address(pTokenBorrow), repayAmount);

        pTokenBorrow.liquidateBorrow(borrower, repayAmount, pTokenCollateral);



        //\u83b7\u5f97balance

        uint balance = pTokenCollateral.balanceOf(self);



        //\u8d4e\u56deERC20

        pTokenCollateral.redeem(seized);



        //\u53bb uniSwap\u7b49\u4ea4\u6613\u6240\u8fdb\u884c\u4ea4\u6613\uff0c\u83b7\u5f97 ERC20\u3002\uff08\u4e0d\u76f8\u540c\u7684\u65f6\u5019\u8fdb\u884c\u4ea4\u6613\uff09

        if (pTokenBorrow.underlying() != pTokenCollateral.underlying()) {

            IERC20 erc20 = IERC20(pTokenCollateral.underlying());

            uint amountIn = erc20.balanceOf(self);

            _approveMax(address(erc20), address(uniswapRouter), amountIn);

            uniswapRouter.swapExactTokensForTokens(amountIn, totalDebt, path, self, block.timestamp);

        }



    }





    function _transferInternal(address _asset, address payable _to, uint amount) internal {

        address self = address(this);



        uint balance = getBalanceInternal(self, _asset);

        if (balance < amount) {

            amount = balance;

        }



        transferInternal(_to, _asset, amount);

    }





    function _isEth(string memory symbol) internal pure returns (bool){

        return _compareStrings(symbol, "pETH");

    }



    function _approveMax(address _asset, address _spender, uint amount) internal {

        IERC20 erc20 = IERC20(_asset);



        uint allowance = erc20.allowance(address(this), _spender);

        if (allowance < amount) {

            uint MAX_INT = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;

            erc20.approve(_spender, MAX_INT);

        }

    }





    function _compareStrings(string memory a, string memory b) internal pure returns (bool) {

        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));

    }





}

// File: @openzeppelin/contracts/GSN/Context.sol



// SPDX-License-Identifier: MIT



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



// File: @openzeppelin/contracts/token/ERC20/IERC20.sol







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



// File: @openzeppelin/contracts/math/SafeMath.sol







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



// File: @openzeppelin/contracts/utils/Address.sol







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

        // This method relies in extcodesize, which returns 0 for contracts in

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



// File: @openzeppelin/contracts/token/ERC20/ERC20.sol







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



// File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol







pragma solidity ^0.6.0;





/**

 * @dev Extension of {ERC20} that adds a cap to the supply of tokens.

 */

abstract contract ERC20Capped is ERC20 {

    uint256 private _cap;



    /**

     * @dev Sets the value of the `cap`. This value is immutable, it can only be

     * set once during construction.

     */

    constructor (uint256 cap) public {

        require(cap > 0, "ERC20Capped: cap is 0");

        _cap = cap;

    }



    /**

     * @dev Returns the cap on the token's total supply.

     */

    function cap() public view returns (uint256) {

        return _cap;

    }



    /**

     * @dev See {ERC20-_beforeTokenTransfer}.

     *

     * Requirements:

     *

     * - minted tokens must not cause the total supply to go over the cap.

     */

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {

        super._beforeTokenTransfer(from, to, amount);



        if (from == address(0)) { // When minting tokens

            require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");

        }

    }

}



// File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol







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



// File: contracts/Ownable.sol



pragma solidity ^0.6.10;



contract Ownable {



    address payable public owner;



    event TransferredOwnership(address _previous, address _next, uint256 _time);



    modifier onlyOwner() {

        require(msg.sender == owner, "Owner only");

        _;

    }



    constructor() public {

        owner = msg.sender;

    }



    function transferOwnership(address payable _owner) public onlyOwner() {

        address previousOwner = owner;

        owner = _owner;

        emit TransferredOwnership(previousOwner, owner, now);

    }

}



// File: contracts/NFY.sol



pragma solidity ^0.6.10;













contract NFY is ERC20Capped, Ownable {

    using SafeMath for uint;

    using SafeERC20 for ERC20;

    using Address for address;



    // Variable that stores the address of token

    address public contractAddress = address(this);



    // Constructor will set:

    // The name of the token

    // The symbol of the token

    // The total supply of the token

    // The initial supply of the token

    // **NO NEW TOKENS WILL BE MINTED**

    constructor( string memory name, string memory symbol, uint _totalSupply) ERC20(name, symbol) ERC20Capped(_totalSupply * 10 ** 18) public {

        _mint(owner, _totalSupply * 10 ** 18);

    }



}



// File: contracts/TokenSale.sol



pragma solidity ^0.6.10;









// Contract that will keep track of funding and distribution for token sale

contract Funding is Ownable{

    using SafeMath for uint;



    // Modifier that requires funding to not yet be active

    modifier fundingNotActive() {

        require(endFunding == 0, "Funding not active");

        _;

    }



    // Modifier that requires funding to be active

    modifier fundingActive() {

        require( endFunding > 0 && block.timestamp < endFunding && tokensAvailable > 0, "Funding must be active");

        _;

    }



    // Modifier that requires the funding to be over

    modifier fundingOver() {

        require((block.timestamp > endFunding) && endFunding > 0, "Funding not over");

        _;

    }



    // Modifier that requires the teams tokens to be unlocked

    modifier teamTokensUnlocked() {

        require((block.timestamp > teamUnlockTime) && teamUnlockTime > 0, "Team's tokens are still locked");

        _;

    }



    // Modifier that requires the reward tokens to be unlocked

    modifier rewardTokensUnlocked() {

        require((block.timestamp > rewardUnlockTime) && rewardUnlockTime > 0, "Team's tokens are still locked");

        _;

    }



    // Struct that keeps track of buyer details

    struct Buyer {

        address investor;

        uint tokensPurchased;

        bool tokensClaimed;

        uint ethSent;

    }



    // Mapping that will link an address to their investment

    mapping(address => Buyer) buyers;



    // Variable that will keep track of the ending time of the funding round

    uint public endFunding;



    // Variable that will keep track of the length of the funding round

    uint public saleLength;



    // Variable that will keep track of time sale started

    uint public startTime;



    // Variable that will keep track of the token price for days 1-4

    uint public tokenPrice1;



    // Variable that will keep track of token price for days 5-7

    uint public tokenPrice2;



    // Variable that will keep track of the tokens available to buy

    uint public tokensAvailable;



    // Team related variables

    uint public teamTokens;

    uint public teamUnlockTime;



    uint public teamLockLength;

    bool public teamWithdraw;



    // Reward related variables

    uint public rewardTokens;

    uint public rewardUnlockTime;

    uint public rewardLockLength;

    bool public rewardWithdraw;



    // Variable that will store the token contract

    NFY public token;



    uint public tokensSold;



    uint public softCap;



    uint public ethRaised;



    bool public softCapMet = false;



    // Variable that will keep track of the contract address

    address public contractAddress = address(this);



    event PurchaseExecuted(uint _etherSpent, uint _tokensPurchased, address _purchaser);



    event ClaimExecuted(uint _tokensSent, address _receiver);



    event TokensOnSale(uint _tokensOnSale);



    event AmountOfTeamTokens(uint _teamTokens);



    event TeamWithdraw(uint _tokensSent, address _receiver);



    event SoftCapMet(string _msg, bool _softCapMet);



    event SaleStarted(string _msg);



    event RewardTokensTransferred(address _sentTo, uint _amount);



    event RaisedEthereumWithdrawn(address _sentTo, uint _amount);



    // Constructor will set:

    // The address of token being sold

    // Length of funding - Seconds

    // Token Price

    // Tokens that are initially available

    // The tokens allotted  to team

    constructor( address _tokenAddress, uint _saleLength, uint _tokenPrice1, uint _tokenPrice2, uint _softCap, uint _tokensAvailable, uint _teamTokens, uint _teamLockLength, uint _rewardTokens, uint _rewardLockLength) Ownable() public {

        // Variable 'token' is the address of token being sold

        token = NFY(_tokenAddress);



        // Require a sale length greater than 0

        require(_saleLength > 0, "Length of sale should be more than 0");



        // Require more than 0 tokens to be initially available

        require(_tokensAvailable > 0, "Should be more than 0 tokens to go on sale");



        // Set the length of the funding round to time passed in

        saleLength = _saleLength;



        // Set the first token price as the price passed in

        tokenPrice1 = _tokenPrice1;



        // Set the second token price as price passed in

        tokenPrice2 = _tokenPrice2;



        // Set the soft cap will be 100 ETH

        softCap = _softCap;



        // Set the initially available tokens as the amount passed in

        tokensAvailable = _tokensAvailable;



        // Set the amount of tokens the team will receive

        teamTokens = _teamTokens;



        // Set the length the team's tokens will be locked

        teamLockLength = _teamLockLength;



        // Set reward tokens delegated

        rewardTokens = _rewardTokens;



        // Set length reward tokens will be locked

        rewardLockLength = _rewardLockLength;



        // Emit how many tokens are on sale and how many tokens are for team

        emit TokensOnSale(_tokensAvailable);

        emit AmountOfTeamTokens(_teamTokens);

    }



    // Function that will allow user to see how many tokens they have purchased

    function getTokensPurchased() public view returns(uint _tokensPurchased) {

        return buyers[msg.sender].tokensPurchased;

    }



    // Call function to start the funding round.. Once called timer will start

    function startFunding() external onlyOwner() fundingNotActive() {

        startTime = block.timestamp;



        // Variable set to the current timestamp of block + length of funding round

        endFunding = block.timestamp.add(saleLength);



        // Variable set to the current timestamp of block + length of team's tokens locked

        teamUnlockTime = block.timestamp.add(teamLockLength);



        // Variable set to the current timestamp of block + length of reward's tokens locked

        rewardUnlockTime = block.timestamp.add(rewardLockLength);



        emit SaleStarted("Sale has started");

    }



    // Function investor will call to buy tokens

    function buyTokens() public fundingActive() payable {

        require(msg.value >= 0.1 ether && msg.value <= 50 ether, "Outside investing conditions");



        // Require transaction will not go over hard cap of 900 ETH

        require(ethRaised.add(msg.value) <= 900 ether, "Hard Cap off 900 ETH has been reached");

        uint _tokenAmount;



        // Days 1-4 price

        if(block.timestamp.sub(startTime) <= 345600 seconds){

            _tokenAmount = msg.value.div(tokenPrice1) * 10 ** 18 ;

        }



        // Days 5-7 price

        else{

            _tokenAmount = msg.value.div(tokenPrice2) * 10 ** 18 ;

        }



        // Require enough tokens are left for investor to buy

        require(

            _tokenAmount <= tokensAvailable,

            "Not enough tokens left"

        );



        // Variable keeping track of tokens sold will increase by amount of tokens bought

        tokensSold = tokensSold.add(_tokenAmount);



        // Variable keeping track of remaining tokens will decrease by amount of tokens sold

        tokensAvailable = tokensAvailable.sub(_tokenAmount);



        // Create a mapping to struct 'Buyer' that will set track of:

        // Address of the investor

        // Number of tokens purchased

        // That buyer has not claimed tokens

        // Total number of ether sent

        buyers[msg.sender].investor = msg.sender;

        buyers[msg.sender].tokensPurchased = buyers[msg.sender].tokensPurchased.add(_tokenAmount);

        buyers[msg.sender].tokensClaimed = false;

        buyers[msg.sender].ethSent = buyers[msg.sender].ethSent.add(msg.value);



        ethRaised = ethRaised.add(msg.value);



        // Emit event that shows details of the current purchase

        emit PurchaseExecuted(msg.value, _tokenAmount, msg.sender);



        // If ETH raised is over 100 and soft cap has not been met yet

        if(ethRaised >= softCap && softCapMet == false) {

            softCapMet = true;

            emit SoftCapMet("Soft cap has been met", softCapMet);

        }



    }



    // Function that user will call to claim their purchased tokens once funding is over

    function claimTokens() external fundingOver()  {

        // Require that soft cap of 100 ETH has been met and no buy back

        require(softCapMet == true);



        // Variable 'buyer' of struct 'Buyer' will be used to access the buyers mapping

        Buyer storage buyer = buyers[msg.sender];



        // Require that the current msg.sender has invested

        require(buyer.tokensPurchased > 0, "No investment");



        // Require that the current msg.sender has not already withdrawn purchased tokens

        require(buyer.tokensClaimed == false, "Tokens already withdrawn");



        // Bool that keeps track of whether or not msg.sender has claimed tokens will be set to tue

        buyer.tokensClaimed = true;



        // Transfer all tokens purchased, to the investor

        token.transfer(buyer.investor, buyer.tokensPurchased);



        // Emit event that confirms details of current claim

        emit ClaimExecuted(buyer.tokensPurchased, msg.sender);

    }



    // Function investors will call if soft cap is not raised

    function investorGetBackEth() external fundingOver() {

        // Require soft cap was not met, investors get ETH back

        require(softCapMet == false, "Soft cap was met");

        require(buyers[msg.sender].ethSent > 0, "Did not invest or already claimed");



        uint withdrawAmount = buyers[msg.sender].ethSent;



        buyers[msg.sender].ethSent = 0;



        msg.sender.transfer(withdrawAmount);

    }



    // Function that will allow the team to withdraw their tokens

    function withdrawTeamTokens() external onlyOwner() teamTokensUnlocked() {

        // Require that soft cap of 100 ETH has been met and no buy back

        require(softCapMet == true);



        // Require that team has not withdrawn their tokens

        require(teamWithdraw == false, "Team has withdrawn their tokens");



        // Transfer team tokens to msg.sender (owner)

        token.transfer(msg.sender, teamTokens);



        // Set bool that tracks if team has withdrawn tokens to true

        teamWithdraw = true;



        // Emit event that confirms team has withdrawn their tokens

        emit TeamWithdraw(teamTokens, msg.sender);

    }



    // Function that will allow the owner to withdraw ethereum raised after funding is over

    function withdrawEth() external onlyOwner() fundingOver() {

        require(address(this).balance > 0, "ETH already withdrawn");



        // Require that soft cap of 100 ETH has been met and no buy back

        require(softCapMet == true);



        emit RaisedEthereumWithdrawn(msg.sender, address(this).balance);



        // Transfer the passed in amount ether to the msg.sender (owner)

        msg.sender.transfer(address(this).balance);

    }



    // Transfer rewards tokens to vault once it is deployed

    function transferRewardTokens(address _to) public onlyOwner() rewardTokensUnlocked() {

        require(rewardTokens > 0, "Reward tokens already sent");



        // Require that soft cap of 100 ETH has been met and no buy back

        require(softCapMet == true);



        uint _rewardTokens = rewardTokens;

        rewardTokens = 0;



        token.transfer(_to, _rewardTokens);

        emit RewardTokensTransferred(_to, _rewardTokens);

    }



    // Function that will burn unsold tokens

    function burnUnSoldTokens() public onlyOwner() fundingOver() {

        require(tokensAvailable > 0, "All tokens have been sold!");

        token.transfer(0x000000000000000000000000000000000000dEaD, tokensAvailable);

    }

}

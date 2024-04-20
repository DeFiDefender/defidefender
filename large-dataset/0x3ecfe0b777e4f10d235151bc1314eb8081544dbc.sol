// File: @openzeppelin/contracts-ethereum-package/contracts/Initializable.sol



pragma solidity >=0.4.24 <0.7.0;





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



// File: @openzeppelin/contracts-ethereum-package/contracts/GSN/Context.sol



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

contract ContextUpgradeSafe is Initializable {

    // Empty internal constructor, to prevent people from mistakenly deploying

    // an instance of this contract, which should be used via inheritance.



    function __Context_init() internal initializer {

        __Context_init_unchained();

    }



    function __Context_init_unchained() internal initializer {





    }





    function _msgSender() internal view virtual returns (address payable) {

        return msg.sender;

    }



    function _msgData() internal view virtual returns (bytes memory) {

        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691

        return msg.data;

    }



    uint256[50] private __gap;

}



// File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/IERC20.sol



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



// File: @openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol



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

     */

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b != 0, errorMessage);

        return a % b;

    }

}



// File: @openzeppelin/contracts-ethereum-package/contracts/utils/Address.sol



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

}



// File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20.sol



pragma solidity ^0.6.0;













/**

 * @dev Implementation of the {IERC20} interface.

 *

 * This implementation is agnostic to the way tokens are created. This means

 * that a supply mechanism has to be added in a derived contract using {_mint}.

 * For a generic mechanism see {ERC20MinterPauser}.

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

contract ERC20UpgradeSafe is Initializable, ContextUpgradeSafe, IERC20 {

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



    function __ERC20_init(string memory name, string memory symbol) internal initializer {

        __Context_init_unchained();

        __ERC20_init_unchained(name, symbol);

    }



    function __ERC20_init_unchained(string memory name, string memory symbol) internal initializer {





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



    uint256[44] private __gap;

}



// File: @openzeppelin/contracts-ethereum-package/contracts/utils/Pausable.sol



pragma solidity ^0.6.0;







/**

 * @dev Contract module which allows children to implement an emergency stop

 * mechanism that can be triggered by an authorized account.

 *

 * This module is used through inheritance. It will make available the

 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to

 * the functions of your contract. Note that they will not be pausable by

 * simply including this module, only once the modifiers are put in place.

 */

contract PausableUpgradeSafe is Initializable, ContextUpgradeSafe {

    /**

     * @dev Emitted when the pause is triggered by `account`.

     */

    event Paused(address account);



    /**

     * @dev Emitted when the pause is lifted by `account`.

     */

    event Unpaused(address account);



    bool private _paused;



    /**

     * @dev Initializes the contract in unpaused state.

     */



    function __Pausable_init() internal initializer {

        __Context_init_unchained();

        __Pausable_init_unchained();

    }



    function __Pausable_init_unchained() internal initializer {





        _paused = false;



    }





    /**

     * @dev Returns true if the contract is paused, and false otherwise.

     */

    function paused() public view returns (bool) {

        return _paused;

    }



    /**

     * @dev Modifier to make a function callable only when the contract is not paused.

     */

    modifier whenNotPaused() {

        require(!_paused, "Pausable: paused");

        _;

    }



    /**

     * @dev Modifier to make a function callable only when the contract is paused.

     */

    modifier whenPaused() {

        require(_paused, "Pausable: not paused");

        _;

    }



    /**

     * @dev Triggers stopped state.

     */

    function _pause() internal virtual whenNotPaused {

        _paused = true;

        emit Paused(_msgSender());

    }



    /**

     * @dev Returns to normal state.

     */

    function _unpause() internal virtual whenPaused {

        _paused = false;

        emit Unpaused(_msgSender());

    }



    uint256[49] private __gap;

}



// File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Pausable.sol



pragma solidity ^0.6.0;









/**

 * @dev ERC20 token with pausable token transfers, minting and burning.

 *

 * Useful for scenarios such as preventing trades until the end of an evaluation

 * period, or having an emergency switch for freezing all token transfers in the

 * event of a large bug.

 */

abstract contract ERC20PausableUpgradeSafe is Initializable, ERC20UpgradeSafe, PausableUpgradeSafe {

    function __ERC20Pausable_init() internal initializer {

        __Context_init_unchained();

        __Pausable_init_unchained();

        __ERC20Pausable_init_unchained();

    }



    function __ERC20Pausable_init_unchained() internal initializer {





    }



    /**

     * @dev See {ERC20-_beforeTokenTransfer}.

     *

     * Requirements:

     *

     * - the contract must not be paused.

     */

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {

        super._beforeTokenTransfer(from, to, amount);



        require(!paused(), "ERC20Pausable: token transfer while paused");

    }



    uint256[50] private __gap;

}



// File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/SafeERC20.sol



pragma solidity ^0.6.0;









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

        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));

    }



    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {

        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));

    }



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



// File: contracts/library/AddressArrayUtils.sol



pragma solidity ^0.6.12;





library AddressArrayUtils {



    /**

     * Finds the index of the first occurrence of the given element.

     * @param A The input array to search

     * @param a The value to find

     * @return Returns (index and isIn) for the first occurrence starting from index 0

     */

    function indexOf(address[] memory A, address a) internal pure returns (uint256, bool) {

        uint256 length = A.length;

        for (uint256 i = 0; i < length; i++) {

            if (A[i] == a) {

                return (i, true);

            }

        }

        return (uint256(-1), false);

    }



    /**

    * Returns true if the value is present in the list. Uses indexOf internally.

    * @param A The input array to search

    * @param a The value to find

    * @return Returns isIn for the first occurrence starting from index 0

    */

    function contains(address[] memory A, address a) internal pure returns (bool) {

        (, bool isIn) = indexOf(A, a);

        return isIn;

    }



    /**

     * @param A The input array to search

     * @param a The address to remove

     * @return Returns the array with the object removed.

     */

    function remove(address[] memory A, address a)

        internal

        pure

        returns (address[] memory)

    {

        (uint256 index, bool isIn) = indexOf(A, a);

        if (!isIn) {

            revert("Address not in array.");

        } else {

            (address[] memory _A,) = pop(A, index);

            return _A;

        }

    }



    /**

    * Removes specified index from array

    * @param A The input array to search

    * @param index The index to remove

    * @return Returns the new array and the removed entry

    */

    function pop(address[] memory A, uint256 index)

        internal

        pure

        returns (address[] memory, address)

    {

        uint256 length = A.length;

        require(index < A.length, "Index must be < A length");

        address[] memory newAddresses = new address[](length - 1);

        for (uint256 i = 0; i < index; i++) {

            newAddresses[i] = A[i];

        }

        for (uint256 j = index + 1; j < length; j++) {

            newAddresses[j - 1] = A[j];

        }

        return (newAddresses, A[index]);

    }

}



// File: contracts/interfaces/ILimaSwap.sol



// pragma solidity ^0.6.12;



//     IERC20

// } from "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/IERC20.sol";



interface ILimaSwap {

    function getGovernanceToken(address token) external view returns (address);



    function getExpectedReturn(

        address fromToken,

        address toToken,

        uint256 amount

    ) external view returns (uint256 returnAmount);



    function swap(

        address recipient,

        address from,

        address to,

        uint256 amount,

        uint256 minReturnAmount

    ) external returns (uint256 returnAmount);



    function unwrap(

        address interestBearingToken,

        uint256 amount,

        address recipient

    ) external;



    function getUnderlyingAmount(address token, uint256 amount)

        external

        returns (uint256 underlyingAmount);

}



// File: contracts/interfaces/ILimaToken.sol



pragma solidity ^0.6.12;





/**

 * @title ILimaToken

 * @author Lima Protocol

 *

 * Interface for operating with LimaTokens.

 */

interface ILimaToken is IERC20 {

    /* ============ Functions ============ */



    function create(IERC20 _investmentToken, uint256 _amount, address _recipient, uint256 _minimumReturn) external returns (bool);

    function redeem(IERC20 _payoutToken, uint256 _amount, address _recipient, uint256 _minimumReturn) external returns (bool);

    function rebalance(address _bestToken, uint256 _minimumReturnGov, uint256 _minimumReturn) external returns (bool);

    function getNetTokenValue(address _targetToken) external view returns (uint256 netTokenValue);

    function getNetTokenValueOf(address _targetToken, uint256 _amount) external view returns (uint256 netTokenValue);



    function getUnderlyingTokenBalance() external view returns (uint256 balance);



    function getUnderlyingTokenBalanceOf(uint256 _amount) external view returns (uint256 balance);



    function mint(address _account, uint256 _quantity) external;

    function burn(address _account, uint256 _quantity) external;



    function pause() external;

    function unpause() external;

    function isPaused() external view returns (bool);



    function limaGovernance() external view returns (address);

    function isLimaGovernance() external view returns (bool);

    function renounceLimaGovernanceOwnership() external;

    function transferLimaGovernanceOwnership(address _newLimaGovernance) external;



}



// File: @openzeppelin/contracts-ethereum-package/contracts/access/Ownable.sol



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

contract OwnableUpgradeSafe is Initializable, ContextUpgradeSafe {

    address private _owner;



    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);



    /**

     * @dev Initializes the contract setting the deployer as the initial owner.

     */



    function __Ownable_init() internal initializer {

        __Context_init_unchained();

        __Ownable_init_unchained();

    }



    function __Ownable_init_unchained() internal initializer {





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



    uint256[49] private __gap;

}



// File: contracts/limaTokenModules/OwnableLimaGovernance.sol



pragma solidity ^0.6.12;





// import "@openzeppelin/upgrades/contracts/Initializable.sol";





/**

 * @dev Contract module which provides a basic access control mechanism, where

 * there is an account (an limaGovernance) that can be granted exclusive access to

 * specific functions.

 *

 * By default, the limaGovernance account will be the one that deploys the contract. This

 * can later be changed with {transferLimaGovernanceOwnership}.

 *

 * This module is used through inheritance. It will make available the modifier

 * `onlyLimaGovernance`, which can be applied to your functions to restrict their use to

 * the limaGovernance.

 */

contract OwnableLimaGovernance is Initializable {

    address private _limaGovernance;



    event LimaGovernanceOwnershipTransferred(address indexed previousLimaGovernance, address indexed newLimaGovernance);



    /**

     * @dev Initializes the contract setting the deployer as the initial limaGovernance.

     */



    function __OwnableLimaGovernance_init_unchained() internal initializer {

        address msgSender = msg.sender;

        _limaGovernance = msgSender;

        emit LimaGovernanceOwnershipTransferred(address(0), msgSender);



    }





    /**

     * @dev Returns the address of the current limaGovernance.

     */

    function limaGovernance() public view returns (address) {

        return _limaGovernance;

    }



    /**

     * @dev Throws if called by any account other than the limaGovernance.

     */

    modifier onlyLimaGovernance() {

        require(_limaGovernance == msg.sender, "OwnableLimaGovernance: caller is not the limaGovernance");

        _;

    }



    /**

     * @dev Transfers limaGovernanceship of the contract to a new account (`newLimaGovernance`).

     * Can only be called by the current limaGovernance.

     */

    function transferLimaGovernanceOwnership(address newLimaGovernance) public virtual onlyLimaGovernance {

        require(newLimaGovernance != address(0), "OwnableLimaGovernance: new limaGovernance is the zero address");

        emit LimaGovernanceOwnershipTransferred(_limaGovernance, newLimaGovernance);

        _limaGovernance = newLimaGovernance;

    }



}



// File: contracts/interfaces/IAmunUser.sol



pragma solidity ^0.6.12;



interface IAmunUser {

    function isAmunUser(address _amunUser) external view returns (bool);

    function isOnlyAmunUserActive() external view returns (bool);

}



// File: contracts/LimaTokenStorage.sol



pragma solidity ^0.6.12;



//     ERC20PausableUpgradeSafe,

//     IERC20,

//     SafeMath

// } from "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Pausable.sol";



//     SafeERC20

// } from "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/SafeERC20.sol";



//     OwnableUpgradeSafe

// } from "@openzeppelin/contracts-ethereum-package/contracts/access/Ownable.sol";











/**

 * @title LimaToken

 * @author Lima Protocol

 *

 * Standard LimaToken.

 */

contract LimaTokenStorage is OwnableUpgradeSafe, OwnableLimaGovernance {

    using AddressArrayUtils for address[];

    using SafeMath for uint256;

    using SafeERC20 for IERC20;



    uint256 public constant MAX_UINT256 = 2**256 - 1;

    address public constant USDC = address(

        0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48

    );



    // List of UnderlyingTokens

    address[] public underlyingTokens;

    address public currentUnderlyingToken;



    // address public owner;

    ILimaSwap public limaSwap;

    address public limaToken;



    //Fees

    address public feeWallet;

    uint256 public burnFee; // 1 / burnFee * burned amount == fee

    uint256 public mintFee; // 1 / mintFee * minted amount == fee

    uint256 public performanceFee;



    //Rebalance

    uint256 public lastUnderlyingBalancePer1000;

    uint256 public lastRebalance;

    uint256 public rebalanceInterval;





    /**

     * @dev Initializes contract

     */

    function __LimaTokenStorage_init_unchained(

        address _limaSwap,

        address _feeWallet,

        address _currentUnderlyingToken,

        address[] memory _underlyingTokens,

        uint256 _mintFee,

        uint256 _burnFee,

        uint256 _performanceFee

    ) public initializer {

        require(

            _underlyingTokens.contains(_currentUnderlyingToken),

            "_currentUnderlyingToken must be part of _underlyingTokens."

        );

        __Ownable_init();



        limaSwap = ILimaSwap(_limaSwap);



        __OwnableLimaGovernance_init_unchained();



        underlyingTokens = _underlyingTokens;

        currentUnderlyingToken = _currentUnderlyingToken;

        burnFee = _burnFee; //1/100 = 1%

        mintFee = _mintFee;

        performanceFee = _performanceFee; //1/10 = 10%

        rebalanceInterval = 24 hours;

        lastRebalance = now;

        lastUnderlyingBalancePer1000 = 0;

        feeWallet = _feeWallet;

    }



    /**

     * @dev Throws if called by any account other than the limaGovernance.

     */

    modifier onlyLimaGovernanceOrOwner() {

        _isLimaGovernanceOrOwner();

        _;

    }



    function _isLimaGovernanceOrOwner() internal view {

        require(

            limaGovernance() == _msgSender() ||

                owner() == _msgSender() ||

                limaToken == _msgSender(),

            "LS2" //"Ownable: caller is not the limaGovernance or owner"

        );

    }



    modifier onlyUnderlyingToken(address _token) {

        // Internal function used to reduce bytecode size

        _isUnderlyingToken(_token);

        _;

    }



    function _isUnderlyingToken(address _token) internal view {

        require(

            isUnderlyingTokens(_token),

            "LS3" //"Only token that are part of Underlying Tokens"

        );

    }



    modifier noEmptyAddress(address _address) {

        // Internal function used to reduce bytecode size

        require(_address != address(0), "LS4"); //Only address that is not empty");

        _;

    }



    /* ============ Setter ============ */



    function addUnderlyingToken(address _underlyingToken)

        external

        onlyLimaGovernanceOrOwner

    {

        require(

            !isUnderlyingTokens(_underlyingToken),

            "LS1" //"Can not add already existing underlying token again."

        );



        underlyingTokens.push(_underlyingToken);

    }



    function removeUnderlyingToken(address _underlyingToken)

        external

        onlyLimaGovernanceOrOwner

    {

        underlyingTokens = underlyingTokens.remove(_underlyingToken);

    }



    function setCurrentUnderlyingToken(address _currentUnderlyingToken)

        external

        onlyUnderlyingToken(_currentUnderlyingToken)

        onlyLimaGovernanceOrOwner

    {

        currentUnderlyingToken = _currentUnderlyingToken;

    }



    function setLimaToken(address _limaToken)

        external

        noEmptyAddress(_limaToken)

        onlyLimaGovernanceOrOwner

    {

        limaToken = _limaToken;

    }



    function setLimaSwap(address _limaSwap)

        public

        noEmptyAddress(_limaSwap)

        onlyLimaGovernanceOrOwner

    {

        limaSwap = ILimaSwap(_limaSwap);

    }



    function setFeeWallet(address _feeWallet)

        external

        noEmptyAddress(_feeWallet)

        onlyLimaGovernanceOrOwner

    {

        feeWallet = _feeWallet;

    }



    function setPerformanceFee(uint256 _performanceFee)

        external

        onlyLimaGovernanceOrOwner

    {

        performanceFee = _performanceFee;

    }



    function setBurnFee(uint256 _burnFee) external onlyLimaGovernanceOrOwner {

        burnFee = _burnFee;

    }



    function setMintFee(uint256 _mintFee) external onlyLimaGovernanceOrOwner {

        mintFee = _mintFee;

    }



    function setLastUnderlyingBalancePer1000(

        uint256 _lastUnderlyingBalancePer1000

    ) external onlyLimaGovernanceOrOwner {

        lastUnderlyingBalancePer1000 = _lastUnderlyingBalancePer1000;

    }



    function setLastRebalance(uint256 _lastRebalance)

        external

        onlyLimaGovernanceOrOwner

    {

        lastRebalance = _lastRebalance;

    }



    function setRebalanceInterval(uint256 _rebalanceInterval)

        external

        onlyLimaGovernanceOrOwner

    {

        rebalanceInterval = _rebalanceInterval;

    }



    /* ============ View ============ */



    function isUnderlyingTokens(address _underlyingToken)

        public

        view

        returns (bool)

    {

        return underlyingTokens.contains(_underlyingToken);

    }

}



// File: contracts/limaTokenModules/AmunUsers.sol



pragma solidity ^0.6.12;



// import "@openzeppelin/upgrades/contracts/Initializable.sol";



//     OwnableUpgradeSafe

// } from "@openzeppelin/contracts-ethereum-package/contracts/access/Ownable.sol";





/**

 * @dev Contract module which provides a basic access control mechanism, where

 * there is an account (an limaGovernance) that can be granted exclusive access to

 * specific functions.

 *

 * By default, the limaGovernance account will be the one that deploys the contract. This

 * can later be changed with {transferLimaGovernanceOwnership}.

 *

 * This module is used through inheritance. It will make available the modifier

 * `onlyLimaGovernance`, which can be applied to your functions to restrict their use to

 * the limaGovernance.

 */

contract AmunUsers is OwnableUpgradeSafe {

    using AddressArrayUtils for address[];



    address[] public amunUsers;

    bool public isOnlyAmunUserActive;



    function __AmunUsers_init_unchained(bool _isOnlyAmunUserActive) internal initializer {

        isOnlyAmunUserActive = _isOnlyAmunUserActive;

    }



    modifier onlyAmunUsers(address user) {

        if (isOnlyAmunUserActive) {

            require(

                isAmunUser(user),

                "AmunUsers: msg sender must be part of amunUsers."

            );

        }

        _;

    }



    function switchIsOnlyAmunUser() external onlyOwner {

        isOnlyAmunUserActive = !isOnlyAmunUserActive;

    }



    function isAmunUser(address _amunUser) public view returns (bool) {

        return amunUsers.contains(_amunUser);

    }



    function addAmunUser(address _amunUser) external onlyOwner {

        amunUsers.push(_amunUser);

    }



    function removeAmunUser(address _amunUser) external onlyOwner {

        amunUsers = amunUsers.remove(_amunUser);

    }

}



// File: contracts/limaTokenModules/InvestmentToken.sol



pragma solidity ^0.6.12;



//     OwnableUpgradeSafe

// } from "@openzeppelin/contracts-ethereum-package/contracts/access/Ownable.sol";







contract InvestmentToken is OwnableUpgradeSafe {

    using AddressArrayUtils for address[];

    address[] public investmentTokens;



    function isInvestmentToken(address _investmentToken)

        public

        view

        returns (bool)

    {

        return investmentTokens.contains(_investmentToken);

    }



    function removeInvestmentToken(address _investmentToken)

        external

        onlyOwner

    {

        investmentTokens = investmentTokens.remove(_investmentToken);

    }



    function addInvestmentToken(address _investmentToken) external onlyOwner {

        investmentTokens.push(_investmentToken);

    }

}



// File: contracts/LimaTokenHelper.sol



pragma solidity ^0.6.12;



//     ERC20PausableUpgradeSafe,

//     IERC20,

//     SafeMath

// } from "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Pausable.sol";



//     SafeERC20

// } from "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/SafeERC20.sol";















/**

 * @title LimaToken

 * @author Lima Protocol

 *

 * Standard LimaToken.

 */

contract LimaTokenHelper is LimaTokenStorage, InvestmentToken, AmunUsers {

    using AddressArrayUtils for address[];

    using SafeMath for uint256;

    using SafeERC20 for IERC20;



    function initialize(

        address _limaSwap,

        address _feeWallet,

        address _currentUnderlyingToken,

        address[] memory _underlyingTokens,

        uint256 _mintFee,

        uint256 _burnFee,

        uint256 _performanceFee

    ) public initializer {

        __LimaTokenStorage_init_unchained(

            _limaSwap,

            _feeWallet,

            _currentUnderlyingToken,

            _underlyingTokens,

            _mintFee,

            _burnFee,

            _performanceFee

        );

        __AmunUsers_init_unchained(true);

    }



    /* ============ View ============ */



    /**

     * @dev Get total net token value.

     */

    function getNetTokenValue(address _targetToken)

        public

        view

        returns (uint256 netTokenValue)

    {

        return

            getExpectedReturn(

                currentUnderlyingToken,

                _targetToken,

                getUnderlyingTokenBalance()

            );

    }



    /**

     * @dev Get total net token value.

     */

    function getNetTokenValueOf(address _targetToken, uint256 _amount)

        public

        view

        returns (uint256 netTokenValue)

    {

        return

            getExpectedReturn(

                currentUnderlyingToken,

                _targetToken,

                getUnderlyingTokenBalanceOf(_amount)

            );

    }



    //helper for redirect to LimaSwap

    function getExpectedReturn(

        address _from,

        address _to,

        uint256 _amount

    ) public view returns (uint256 returnAmount) {

        returnAmount = limaSwap.getExpectedReturn(_from, _to, _amount);

    }



    function getUnderlyingTokenBalance() public view returns (uint256 balance) {

        return IERC20(currentUnderlyingToken).balanceOf(limaToken);

    }



    function getUnderlyingTokenBalanceOf(uint256 _amount)

        public

        view

        returns (uint256 balanceOf)

    {

        uint256 balance = getUnderlyingTokenBalance();

        require(balance != 0, "LM4"); //"Balance of underlyng token cant be zero."

        return balance.mul(_amount).div(ILimaToken(limaToken).totalSupply());

    }



    /**

     * @dev Return the performance over the last time interval

     */

    function getPerformanceFee()

        public

        view

        returns (uint256 performanceFeeToWallet)

    {

        performanceFeeToWallet = 0;

        if (

            ILimaToken(limaToken).getUnderlyingTokenBalanceOf(1000 ether) >

            lastUnderlyingBalancePer1000 &&

            performanceFee != 0

        ) {

            performanceFeeToWallet = (

                ILimaToken(limaToken).getUnderlyingTokenBalance().sub(

                    ILimaToken(limaToken)

                        .totalSupply()

                        .mul(lastUnderlyingBalancePer1000)

                        .div(1000 ether)

                )

            )

                .div(performanceFee);

        }

    }



    /* ============ User ============ */



    function getFee(uint256 _amount, uint256 _fee)

        public

        pure

        returns (uint256 feeAmount)

    {

        //get fee

        if (_fee > 0) {

            return _amount.div(_fee);

        }

        return 0;

    }



    /**

     * @dev Gets the expecterd return of a redeem

     */

    function getExpectedReturnRedeem(address _to, uint256 _amount)

        external

        view

        returns (uint256 minimumReturn)

    {

        _amount = getUnderlyingTokenBalanceOf(_amount);



        _amount = _amount.sub(getFee(_amount, burnFee));



        return getExpectedReturn(currentUnderlyingToken, _to, _amount);

    }



    /**

     * @dev Gets the expecterd return of a create

     */

    function getExpectedReturnCreate(address _from, uint256 _amount)

        external

        view

        returns (uint256 minimumReturn)

    {

        _amount = _amount.sub(getFee(_amount, mintFee));

        return getExpectedReturn(_from, currentUnderlyingToken, _amount);

    }



    /**

     * @dev Gets the expected returns of a rebalance

     */

    function getExpectedReturnRebalance(address _bestToken)

        external

        view

        returns (uint256 minimumReturnGov, uint256 minimumReturn)

    {

        address _govToken = limaSwap.getGovernanceToken(currentUnderlyingToken);

        minimumReturnGov = getExpectedReturn(

            _govToken,

            _bestToken,

            IERC20(_govToken).balanceOf(limaToken)

        );



        minimumReturn = getExpectedReturn(

            currentUnderlyingToken,

            _bestToken,

            getUnderlyingTokenBalance().sub(getPerformanceFee())

        );

        return (minimumReturnGov, minimumReturn);

    }



    function getGovernanceToken() external view returns (address token) {

        return limaSwap.getGovernanceToken(currentUnderlyingToken);

    }

}

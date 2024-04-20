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



// File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol



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



// File: @openzeppelin/contracts/token/ERC20/ERC20.sol



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



// File: @openzeppelin/contracts/access/roles/PauserRole.sol



pragma solidity ^0.5.0;







contract PauserRole is Context {

    using Roles for Roles.Role;



    event PauserAdded(address indexed account);

    event PauserRemoved(address indexed account);



    Roles.Role private _pausers;



    constructor () internal {

        _addPauser(_msgSender());

    }



    modifier onlyPauser() {

        require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");

        _;

    }



    function isPauser(address account) public view returns (bool) {

        return _pausers.has(account);

    }



    function addPauser(address account) public onlyPauser {

        _addPauser(account);

    }



    function renouncePauser() public {

        _removePauser(_msgSender());

    }



    function _addPauser(address account) internal {

        _pausers.add(account);

        emit PauserAdded(account);

    }



    function _removePauser(address account) internal {

        _pausers.remove(account);

        emit PauserRemoved(account);

    }

}



// File: @openzeppelin/contracts/lifecycle/Pausable.sol



pragma solidity ^0.5.0;







/**

 * @dev Contract module which allows children to implement an emergency stop

 * mechanism that can be triggered by an authorized account.

 *

 * This module is used through inheritance. It will make available the

 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to

 * the functions of your contract. Note that they will not be pausable by

 * simply including this module, only once the modifiers are put in place.

 */

contract Pausable is Context, PauserRole {

    /**

     * @dev Emitted when the pause is triggered by a pauser (`account`).

     */

    event Paused(address account);



    /**

     * @dev Emitted when the pause is lifted by a pauser (`account`).

     */

    event Unpaused(address account);



    bool private _paused;



    /**

     * @dev Initializes the contract in unpaused state. Assigns the Pauser role

     * to the deployer.

     */

    constructor () internal {

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

     * @dev Called by a pauser to pause, triggers stopped state.

     */

    function pause() public onlyPauser whenNotPaused {

        _paused = true;

        emit Paused(_msgSender());

    }



    /**

     * @dev Called by a pauser to unpause, returns to normal state.

     */

    function unpause() public onlyPauser whenPaused {

        _paused = false;

        emit Unpaused(_msgSender());

    }

}



// File: @openzeppelin/contracts/token/ERC20/ERC20Pausable.sol



pragma solidity ^0.5.0;







/**

 * @title Pausable token

 * @dev ERC20 with pausable transfers and allowances.

 *

 * Useful if you want to stop trades until the end of a crowdsale, or have

 * an emergency switch for freezing all token transfers in the event of a large

 * bug.

 */

contract ERC20Pausable is ERC20, Pausable {

    function transfer(address to, uint256 value) public whenNotPaused returns (bool) {

        return super.transfer(to, value);

    }



    function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {

        return super.transferFrom(from, to, value);

    }



    function approve(address spender, uint256 value) public whenNotPaused returns (bool) {

        return super.approve(spender, value);

    }



    function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {

        return super.increaseAllowance(spender, addedValue);

    }



    function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {

        return super.decreaseAllowance(spender, subtractedValue);

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



// File: contracts/ERC1132.sol



pragma solidity ^0.5.6;



/**

 * @title ERC1132 interface

 * @dev see https://github.com/ethereum/EIPs/issues/1132

 */



contract ERC1132 {

    /**

     * @dev Reasons why a user's tokens have been locked

     */

    mapping(address => bytes32[]) public lockReason;



    /**

     * @dev locked token structure

     */

    struct lockToken {

        uint256 amount;

        uint256 validity;

        bool claimed;

    }



    /**

     * @dev Holds number & validity of tokens locked for a given reason for

     *      a specified address

     */

    mapping(address => mapping(bytes32 => lockToken)) public locked;



    /**

     * @dev Records data of all the tokens Locked

     */

    event Locked(

        address indexed _of,

        bytes32 indexed _reason,

        uint256 _amount,

        uint256 _validity

    );



    /**

     * @dev Records data of all the tokens unlocked

     */

    event Unlocked(

        address indexed _of,

        bytes32 indexed _reason,

        uint256 _amount

    );



    /**

     * @dev Locks a specified amount of tokens against an address,

     *      for a specified reason and time

     * @param _reason The reason to lock tokens

     * @param _amount Number of tokens to be locked

     * @param _time Lock time in seconds

     */

    function lock(bytes32 _reason, uint256 _amount, uint256 _time)

        public returns (bool);



    /**

     * @dev Returns tokens locked for a specified address for a

     *      specified reason

     *

     * @param _of The address whose tokens are locked

     * @param _reason The reason to query the lock tokens for

     */

    function tokensLocked(address _of, bytes32 _reason)

        public view returns (uint256 amount);



    /**

     * @dev Returns tokens locked for a specified address for a

     *      specified reason at a specific time

     *

     * @param _of The address whose tokens are locked

     * @param _reason The reason to query the lock tokens for

     * @param _time The timestamp to query the lock tokens for

     */

    function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)

        public view returns (uint256 amount);



    /**

     * @dev Returns total tokens held by an address (locked + transferable)

     * @param _of The address to query the total balance of

     */

    function totalBalanceOf(address _of)

        public view returns (uint256 amount);



    /**

     * @dev Extends lock for a specified reason and time

     * @param _reason The reason to lock tokens

     * @param _time Lock extension time in seconds

     */

    function extendLock(bytes32 _reason, uint256 _time)

        public returns (bool);



    /**

     * @dev Increase number of tokens locked for a specified reason

     * @param _reason The reason to lock tokens

     * @param _amount Number of tokens to be increased

     */

    function increaseLockAmount(bytes32 _reason, uint256 _amount)

        public returns (bool);



    /**

     * @dev Returns unlockable tokens for a specified address for a specified reason

     * @param _of The address to query the the unlockable token count of

     * @param _reason The reason to query the unlockable tokens for

     */

    function tokensUnlockable(address _of, bytes32 _reason)

        public view returns (uint256 amount);



    /**

     * @dev Unlocks the unlockable tokens of a specified address

     * @param _of Address of user, claiming back unlockable tokens

     */

    function unlock(address _of)

        public returns (uint256 unlockableTokens);



    /**

     * @dev Gets the unlockable tokens of a specified address

     * @param _of The address to query the the unlockable token count of

     */

    function getUnlockableTokens(address _of)

        public view returns (uint256 unlockableTokens);



}



// File: contracts/SDC.sol



pragma solidity ^0.5.6;











/// @title SDC - ERC20 token. Utility coin

/// @notice Implementation for the ERC-1132 lockable token

contract SDC is ERC1132, ERC20Detailed, ERC20Pausable, WhitelistedRole {



  /**

    * @dev Error messages for require statements

    */

    string internal constant ALREADY_LOCKED = 'Tokens already locked';

    string internal constant NOT_LOCKED = 'No tokens locked';

    string internal constant AMOUNT_ZERO = 'Amount can not be 0';



  /**

    * @dev Token issue information

    */

    string private NAME = 'SDPlatform SDC Token';

    string private SYMBOL = 'SDC';

    uint8 private DECIMALS = 18;

    uint256 private INITIAL_SUPPLY = 3500000000;



    constructor() public ERC20Detailed(NAME, SYMBOL, DECIMALS) {

        _mint(msg.sender, INITIAL_SUPPLY * (10 ** uint(DECIMALS)));

        _addWhitelisted(msg.sender);

    }



    /// @notice Mints amount of SDC on account

    /// Can be used only by whitelist

    function mint(address _account, uint256 _amount) external

    whenNotPaused onlyWhitelisted {

        _mint(_account, _amount);

    }



    /// @notice Burns amount of SDC from account and removes

    /// allowance for this amount

    /// Can be used only by whitelist

    function burnFrom(address _account, uint256 _amount) external

    whenNotPaused onlyWhitelisted {

        _burnFrom(_account, _amount);

    }



    // @notice Add Whitelisted Role of SDC on account

    /// Can be used only by whitelist

    function addWhitelisted(address _account) public

    whenNotPaused onlyWhitelistAdmin {

        _addWhitelisted(_account);

    }



    // @notice Remove Whitelisted Role of SDC on account

    /// Can be used only by whitelist

    function removeWhitelisted(address _account) public

    whenNotPaused onlyWhitelistAdmin {

        _removeWhitelisted(_account);

    }



    /**

     * @dev Locks a specified amount of tokens against an address,

     *      for a specified reason and time

     * @param _reason The reason to lock tokens

     * @param _amount Number of tokens to be locked

     * @param _time Lock time in seconds

     */

    function lock(bytes32 _reason, uint256 _amount, uint256 _time) public

    whenNotPaused onlyWhitelisted returns (bool) {

        uint256 validUntil = now.add(_time);



        // If tokens are already locked, then functions extendLock or

        // increaseLockAmount should be used to make any changes

        require(tokensLocked(msg.sender, _reason) == 0, ALREADY_LOCKED);

        require(_amount != 0, AMOUNT_ZERO);



        if (locked[msg.sender][_reason].amount == 0)

            lockReason[msg.sender].push(_reason);



        transfer(address(this), _amount);



        locked[msg.sender][_reason] = lockToken(_amount, validUntil, false);



        emit Locked(msg.sender, _reason, _amount, validUntil);

        return true;

    }



    /**

     * @dev Transfers and Locks a specified amount of tokens,

     *      for a specified reason and time

     * @param _to adress to which tokens are to be transfered

     * @param _reason The reason to lock tokens

     * @param _amount Number of tokens to be transfered and locked

     * @param _time Lock time in seconds

     */

    function transferWithLock(address _to, bytes32 _reason, uint256 _amount, uint256 _time) public

    whenNotPaused onlyWhitelisted returns (bool) {

        uint256 validUntil = now.add(_time);



        require(tokensLocked(_to, _reason) == 0, ALREADY_LOCKED);

        require(_amount != 0, AMOUNT_ZERO);



        if (locked[_to][_reason].amount == 0)

            lockReason[_to].push(_reason);



        transfer(address(this), _amount);



        locked[_to][_reason] = lockToken(_amount, validUntil, false);



        emit Locked(_to, _reason, _amount, validUntil);

        return true;

    }



    /**

     * @dev Returns tokens locked for a specified address for a

     *      specified reason

     *

     * @param _of The address whose tokens are locked

     * @param _reason The reason to query the lock tokens for

     */

    function tokensLocked(address _of, bytes32 _reason) public view

    whenNotPaused onlyWhitelisted returns (uint256 amount) {

        if (!locked[_of][_reason].claimed)

            amount = locked[_of][_reason].amount;

    }



    /**

     * @dev Returns tokens locked for a specified address for a

     *      specified reason at a specific time

     *

     * @param _of The address whose tokens are locked

     * @param _reason The reason to query the lock tokens for

     * @param _time The timestamp to query the lock tokens for

     */

    function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time) public view

    whenNotPaused onlyWhitelisted returns (uint256 amount) {

        if (locked[_of][_reason].validity > _time)

            amount = locked[_of][_reason].amount;

    }



    /**

     * @dev Returns total tokens held by an address (locked + transferable)

     * @param _of The address to query the total balance of

     */

    function totalBalanceOf(address _of) public view

    whenNotPaused onlyWhitelisted returns (uint256 amount) {

        amount = balanceOf(_of);



        for (uint256 i = 0; i < lockReason[_of].length; i++) {

            amount = amount.add(tokensLocked(_of, lockReason[_of][i]));

        }

    }



    /**

     * @dev Extends lock for a specified reason and time

     * @param _reason The reason to lock tokens

     * @param _time Lock extension time in seconds

     */

    function extendLock(bytes32 _reason, uint256 _time) public

    whenNotPaused onlyWhitelisted returns (bool) {

        require(tokensLocked(msg.sender, _reason) > 0, NOT_LOCKED);



        locked[msg.sender][_reason].validity = locked[msg.sender][_reason].validity.add(_time);



        emit Locked(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);

        return true;

    }



    /**

     * @dev Increase number of tokens locked for a specified reason

     * @param _reason The reason to lock tokens

     * @param _amount Number of tokens to be increased

     */

    function increaseLockAmount(bytes32 _reason, uint256 _amount) public

    whenNotPaused onlyWhitelisted returns (bool) {

        require(tokensLocked(msg.sender, _reason) > 0, NOT_LOCKED);

        transfer(address(this), _amount);



        locked[msg.sender][_reason].amount = locked[msg.sender][_reason].amount.add(_amount);



        emit Locked(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);

        return true;

    }



    /**

     * @dev Returns unlockable tokens for a specified address for a specified reason

     * @param _of The address to query the the unlockable token count of

     * @param _reason The reason to query the unlockable tokens for

     */

    function tokensUnlockable(address _of, bytes32 _reason) public view

    whenNotPaused onlyWhitelisted returns (uint256 amount) {

        if (locked[_of][_reason].validity <= now && !locked[_of][_reason].claimed)

            amount = locked[_of][_reason].amount;

    }



    /**

     * @dev Unlocks the unlockable tokens of a specified address

     * @param _of Address of user, claiming back unlockable tokens

     */

    function unlock(address _of) public

    whenNotPaused onlyWhitelisted returns (uint256 unlockableTokens) {

        uint256 lockedTokens;



        for (uint256 i = 0; i < lockReason[_of].length; i++) {

            lockedTokens = tokensUnlockable(_of, lockReason[_of][i]);

            if (lockedTokens > 0) {

                unlockableTokens = unlockableTokens.add(lockedTokens);

                locked[_of][lockReason[_of][i]].claimed = true;

                emit Unlocked(_of, lockReason[_of][i], lockedTokens);

            }

        }



        if (unlockableTokens > 0)

            this.transfer(_of, unlockableTokens);

    }



    /**

     * @dev Gets the unlockable tokens of a specified address

     * @param _of The address to query the the unlockable token count of

     */

    function getUnlockableTokens(address _of) public view

    whenNotPaused onlyWhitelisted returns (uint256 unlockableTokens) {

        uint256 lockedTokens;



        for (uint256 i = 0; i < lockReason[_of].length; i++) {

            lockedTokens = tokensUnlockable(_of, lockReason[_of][i]);

            unlockableTokens = unlockableTokens.add(lockedTokens);

        }

    }

}

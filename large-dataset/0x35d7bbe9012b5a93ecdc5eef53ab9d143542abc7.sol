// File: @openzeppelin/contracts/GSN/Context.sol



/*

  \u2588\u2588\u2588\u2588\u2588  \u2592\u2588\u2588\u2588\u2588\u2588    \u2584\u2588\u2588\u2588\u2588 

\u2593\u2588\u2588   \u2592 \u2592\u2588\u2588\u2592  \u2588\u2588\u2592 \u2588\u2588\u2592 \u2580\u2588\u2592

\u2592\u2588\u2588\u2588\u2588 \u2591 \u2592\u2588\u2588\u2591  \u2588\u2588\u2592 \u2588\u2588\u2591\u2584\u2584\u2584 \u2591

 \u2593\u2588\u2592  \u2591\u2592 \u2588\u2588   \u2588\u2588\u2591\u2591\u2593\u2588  \u2588\u2588\u2593

\u2591 \u2588\u2591\u2591   \u2591 \u2588\u2588\u2588\u2588\u2593\u2592\u2591 \u2592\u2593\u2588\u2588\u2588\u2580  \u2592

 \u2592 \u2591    \u2591 \u2592\u2591\u2592\u2591\u2592\u2591      \u2591\u2592  

          \u2591 \u2592 \u2592\u2591     \u2591   \u2591 

 \u2591 \u2591  \u2591 \u2591 \u2591   \u2591 \u2591   \u2592  \u2591 \u2591 

  \u2591 \u2591 \u2591  \u2591        \u2591   \u2591 \u2591       

 \u2591   \u2591 \u2591  \u2591     \u2591 \u2592 \u2591 \u2591\u2591   

     \u2591   \u2591 \u2591 \u2591 \u2591 \u2591\u2591

   \u2591   \u2591 \u2591 \u2591 \u2591 \u2591\u2591  \u2591  \u2591                  

    \u2591 \u2591   \u2591 \u2591     \u2591 \u2591            

       \u2591      \u2591 

      \u2591     \u2591   \u2591   \u2591   



FOG is an experimental, governance branch of the LIQ (LIQUID) token ecosystem.



FOG is a fixed supply token that is acquired by pairing LIQ/ETH LP and staking

the UniV2 LP tokens at https://liquidefi.co/ 



FOG is then emitted to staking LP providers.



The benefits of holding FOG are twofold:



1. FOG LP providers will be rewarded with ETH and FOG from each 

FOG transaction. Initially, these rewards are pooled in the contract. 

At any time, a provider can call the RewardLiquidityProviders command (Condensate)

on the contract, or 'Condensate.exe' on the website, which then automatically 

divides and dispenses rewards to LP holders (this removes any need to stake the FOG LP). 

The reward amount an individual provider receives is based on said LP provider\u2019s share 

of the pool.



How does this work? 



FOG collects a 7.5% fee on all transfers (which can be later adjusted). 

This fee is then split between ***three functions:*** 



- 60% to adding permanently locked FOG LP 

- 30% FOG/ETH sent to the UNIV2 pool. This is then distributed to 

providers based on your pool share percentage after calling the 

RewardLiquidityProviders command (aka Condensate.exe)

- 10% goes to market buying LIQ which is then converted to LIQ/ETH LP. 



2. FOG is the governance token to the LIQ ecosystem.



All rates are adjustable by way of a DAO, controlled by FOG holders / voting.

FOG will have additional governance abilities to be disclosed later as new

strategies reveal themselves to continue to evolve the LIQ ecosystem. 



*/



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



// File: contracts/DoublePoggerino.sol



pragma solidity ^0.5.17;









contract DoublePoggerino is ERC20, ERC20Pausable {

    using SafeMath for uint256;

    

    event FeeUpdated(uint8 feeDecimals, uint32 feePercentage);

    event RewardsUpdate(uint32 fogRewardPercentage);

    event LocksUpdate(uint32 fogLockPercentage, uint32 tokenLockPercentage);

    event LockLiquidity(uint256 tokenAmount, uint256 ethAmount);

    event BurnLiquidity(uint256 lpTokenAmount);

    event RewardedFog(uint256 tokenAmount);

    event RewardedEth(uint256 ethAmount);

    event BoughtTokenLP(uint256 tokenAmount, uint256 ethAmount);

    event TokenAddressUpdate(address tokenAddress);

    event TokenAddressPairUpdate(address tokenAddressPair);

    event WethAddressUpdate(address wethAddress);

    

    address public uniswapV2Router;

    address public uniswapV2Pair;

    address public tokenAddress;

    address public tokenAddressPair;

    address public wethAddress;

    

    uint8 public feeDecimals;

    uint32 public feePercentage;

    uint32 public liquidityRewardPercentage;

    uint32 public fogRewardPercentage;

    uint32 public fogLockPercentage;

    uint32 public tokenLockPercentage;

   

   

    

    mapping ( address => uint256 ) public balances; 



    function _transfer(address from, address to, uint256 amount) internal whenNotPaused {

        // calculate liquidity lock amount

        // *tokenAddress and *tokenAddressPair 

        // refer to the set token that Fog buys/adds LP

        // all *token* references in this contract pertain 

        // to the set ERC20 token via the Fog contract

        if (from != address(this)) {

            

             // calculate the number of tokens to take as a fee

        uint256 fogToAddDensity = calculateVisabilityFee(

            amount,

            feeDecimals,

            feePercentage

        );

        

            uint256 fogToTransfer = amount.sub(fogToAddDensity);

            super._transfer(from, address(this), fogToAddDensity);

            super._transfer(from, to, (fogToTransfer));

        }

        else {

            super._transfer(from, to, amount);

        }

    }



    // receive eth from uniswap swap

    function () external payable {}



    function fogRollingIn(uint256 _fogDensity) public {

        // lockable supply is the token balance of this contract

        require(_fogDensity <= balanceOf(address(this)), "ERC20TransferLiquidityLock::lockLiquidity: lock amount higher than lockable balance");

        require(_fogDensity != 0, "ERC20TransferLiquidityLock::lockLiquidity: lock amount cannot be 0");

       

            // Fog Lock LP

            uint256 fogToLockAmount = calculateVisabilityFee(

            _fogDensity,

            feeDecimals,

            fogLockPercentage

        );

        

            fogLockSwap(fogToLockAmount);

        

            uint256 fogRemainder = _fogDensity.sub(fogToLockAmount);

            

            // Fog LP Provider Rewards 

            uint256 fogRewardsAmount = calculateVisabilityFee(

            fogRemainder,

            feeDecimals,

            fogRewardPercentage

        );

            

            divideRewards(fogRewardsAmount);

            

            uint256 tokenRemainder = fogRemainder.sub(fogRewardsAmount);

            

            // Amount to buy LIQ LP

            uint256 tokenBuyAmount = calculateVisabilityFee(

            tokenRemainder,

            feeDecimals,

            tokenLockPercentage

        );

            

            buyAndLockToken(tokenBuyAmount);

            

           

    }

            

        

       //fogLock

       

       function fogLockSwap(uint256 fogToLockAmount) private {

       

        uint256 fogLockSplitEth = fogToLockAmount.div(2);

        uint256 otherHalfOfFogPair = fogToLockAmount.sub(fogLockSplitEth);

        uint256 ethBalanceBeforeFogLock = address(this).balance;

    swapFogTokensForEth(fogLockSplitEth);

        uint newBalance = address(this).balance.sub(ethBalanceBeforeFogLock);



    addLiquidity(otherHalfOfFogPair, newBalance);

    emit LockLiquidity(otherHalfOfFogPair, newBalance);

    

      }

    

    

        // Rewards 

    function divideRewards(uint256 _fogRewardsAmount) private { 

        

        uint256 fogSwapEth = _fogRewardsAmount.div(2);

        uint256 otherHalfFog = _fogRewardsAmount.sub(fogSwapEth);

        uint256 ethBalanceBeforeFogSwap = address(this).balance;

    swapFogTokensForEth(fogSwapEth);

        uint256 ethReceived = address(this).balance.sub(ethBalanceBeforeFogSwap);

            

    _rewardLiquidityProviders(otherHalfFog);

            

    _rewardLiquidityProvidersETH(ethReceived);

        

    }   

      

        // TokenSplit

    function buyAndLockToken(uint256 _tokenBuyAmount) private {

        

    uint256 amountToSwapEth = _tokenBuyAmount;

    

        uint256 ethBalanceBeforTokenEthSwap = address(this).balance;

    swapFogTokensForEth(amountToSwapEth);

        uint256 ethReceivedForToken = address(this).balance.sub(ethBalanceBeforTokenEthSwap);



    uint256 amountToBuyToken = ethReceivedForToken.div(2);

    uint256 amountEthForTokenLP = ethReceivedForToken.sub(amountToBuyToken);

        

        // check for any liq in contract already

        uint256 balanceOfTokenBeforeSwap = ERC20(tokenAddress).balanceOf(address(this));

    swapEthForERC20token(amountToBuyToken);

        uint256 tokenRecieved = ERC20(tokenAddress).balanceOf(address(this)).sub(balanceOfTokenBeforeSwap);



        // Add Liq liquidity 

    addERC20liquidity(tokenRecieved, amountEthForTokenLP);

    emit BoughtTokenLP(tokenRecieved, amountEthForTokenLP); 



     }  



    // external util so anyone can easily distribute rewards

    // must call lockLiquidity first which automatically

    // calls _rewardLiquidityProviders & _rewardLiquidityProvidersETH

    function rewardLiquidityProviders() external {

        // lock everything that is lockable;

        fogRollingIn(balanceOf(address(this)));

        

    }



    function _rewardLiquidityProviders(uint256 _fogToRewards) private {

        super._transfer(address(this), uniswapV2Pair, _fogToRewards);

        IUniswapV2Pair(uniswapV2Pair).sync();

        emit RewardedFog(_fogToRewards);

    }

     

   function _rewardLiquidityProvidersETH(uint256 _ethReceived) public {

       IWETH(wethAddress).deposit.value(_ethReceived)();

       ERC20(wethAddress).transfer(uniswapV2Pair, _ethReceived);

       IUniswapV2Pair(uniswapV2Pair).sync();



    }

    

    function burnLiquidity() external {

        uint256 balance = ERC20(uniswapV2Pair).balanceOf(address(this));

        require(balance != 0, "ERC20TransferLiquidityLock::burnLiquidity: burn amount cannot be 0");

        ERC20(uniswapV2Pair).transfer(address(0), balance);

        emit BurnLiquidity(balance);

    }



    function swapFogTokensForEth(uint256 tokenAmount) private {

        address[] memory uniswapPairPath = new address[](2);

        uniswapPairPath[0] = address(this);

        uniswapPairPath[1] = IUniswapV2Router02(uniswapV2Router).WETH();



        _approve(address(this), uniswapV2Router, tokenAmount);



        IUniswapV2Router02(uniswapV2Router)

            .swapExactTokensForETHSupportingFeeOnTransferTokens(

                tokenAmount,

                0,

                uniswapPairPath,

                address(this),

                block.timestamp

            );

    }

    

    function swapEthForERC20token(uint256 ethAmount) private {

        address[] memory uniswapPairPath = new address[](2);

        uniswapPairPath[0] = IUniswapV2Router02(uniswapV2Router).WETH();

        uniswapPairPath[1] = tokenAddress;

        

        ERC20(wethAddress).approve(uniswapV2Router, ethAmount);

        

        

         IUniswapV2Router02(uniswapV2Router)

            .swapExactETHForTokensSupportingFeeOnTransferTokens

            .value(ethAmount)(

        0,

        uniswapPairPath,

        address(this),

        block.timestamp

    ); 

}

    

    

    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {

        _approve(address(this), uniswapV2Router, tokenAmount);



        IUniswapV2Router02(uniswapV2Router)

            .addLiquidityETH

            .value(ethAmount)(

                address(this),

                tokenAmount,

                0,

                0,

                address(this),

                block.timestamp

            );

     

    }

    

     function addERC20liquidity(uint256 tokenAmount, uint256 ethAmount) private {

        ERC20(wethAddress).approve(uniswapV2Router, ethAmount);

        ERC20(tokenAddress).approve(uniswapV2Router, tokenAmount);



        IUniswapV2Router02(uniswapV2Router)

            .addLiquidityETH

            .value(ethAmount)(

                tokenAddress,

                tokenAmount,

                0,

                0,

                address(this),

                block.timestamp

            );

     }



    // returns token amount

    function fogDensity() external view returns (uint256) {

        return balanceOf(address(this));

    }

    

    function ERC20LpSupply() external view returns (uint256) {

        return IUniswapV2ERC20(tokenAddressPair).balanceOf(address(this));

     }



    // returns token amount

    function lockedSupply() external view returns (uint256) {

        uint256 lpTotalSupply = ERC20(uniswapV2Pair).totalSupply();

        uint256 lpBalance = lockedLiquidity();

        uint256 percentOfLpTotalSupply = lpBalance.mul(1e12).div(lpTotalSupply);



        uint256 uniswapBalance = balanceOf(uniswapV2Pair);

        uint256 _lockedSupply = uniswapBalance.mul(percentOfLpTotalSupply).div(1e12);

        return _lockedSupply;

    }



    // returns token amount

    function burnedSupply() external view returns (uint256) {

        uint256 lpTotalSupply = ERC20(uniswapV2Pair).totalSupply();

        uint256 lpBalance = burnedLiquidity();

        uint256 percentOfLpTotalSupply = lpBalance.mul(1e12).div(lpTotalSupply);



        uint256 uniswapBalance = balanceOf(uniswapV2Pair);

        uint256 _burnedSupply = uniswapBalance.mul(percentOfLpTotalSupply).div(1e12);

        return _burnedSupply;

    }



    // returns LP amount, not token amount

    function burnableLiquidity() public view returns (uint256) {

        return ERC20(uniswapV2Pair).balanceOf(address(this));

    }



    // returns LP amount, not token amount

    function burnedLiquidity() public view returns (uint256) {

        return ERC20(uniswapV2Pair).balanceOf(address(0));

    }



    // returns LP amount, not token amount

    function lockedLiquidity() public view returns (uint256) {

        return burnableLiquidity().add(burnedLiquidity());

    }

     /*

        calculates a percentage of tokens to hold as the fee

    */

    function calculateVisabilityFee(

        uint256 _amount,

        uint8 _feeDecimals,

        uint32 _percentage

    ) public pure returns (uint256 locked) {

        locked = _amount.mul(_percentage).div(

            10**(uint256(_feeDecimals) + 2)

        );

    }

}

    

interface IUniswapV2Router02 {

    function WETH() external pure returns (address);

    function swapExactTokensForETHSupportingFeeOnTransferTokens(

        uint amountIn,

        uint amountOutMin,

        address[] calldata path,

        address to,

        uint deadline

    ) external;

    

    function addLiquidityETH(

        address token,

        uint amountTokenDesired,

        uint amountTokenMin,

        uint amountETHMin,

        address to,

        uint deadline

    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);

    

     function swapExactETHForTokensSupportingFeeOnTransferTokens(

         uint amountOutMin,

         address[] calldata path,

        address to,

        uint deadline

    ) external payable;

    

     function swapExactTokensForTokensSupportingFeeOnTransferTokens(

        uint amountIn,

        uint amountOutMin,

        address[] calldata path,

        address to,

        uint deadline

    ) external;

    

}



interface IUniswapV2Pair {

    function sync() external;



}



interface IUniswapV2ERC20 {

    event Approval(address indexed owner, address indexed spender, uint value);

    event Transfer(address indexed from, address indexed to, uint value);



    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint);

    function balanceOf(address owner) external view returns (uint);

    function allowance(address owner, address spender) external view returns (uint);



    function approve(address spender, uint value) external returns (bool);

    function transfer(address to, uint value) external returns (bool);

    function transferFrom(address from, address to, uint value) external returns (bool);



} 



interface IWETH {

    

    function deposit() external payable;

}



// File: contracts/Governance.sol



pragma solidity ^0.5.17;







contract Governance is ERC20, ERC20Detailed {

    using SafeMath for uint256;



    function _transfer(address from, address to, uint256 amount) internal {

        _moveDelegates(_delegates[from], _delegates[to], amount);

        super._transfer(from, to, amount);

    }



    function _mint(address account, uint256 amount) internal {

        _moveDelegates(address(0), _delegates[account], amount);

        super._mint(account, amount);

    }



    function _burn(address account, uint256 amount) internal {

        _moveDelegates(_delegates[account], address(0), amount);

        super._burn(account, amount);

    }



    // Copied from Sav3 code which was:

    // Copied and modified from YAM code:

    // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol

    // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol

    // Which is copied and modified from COMPOUND:

    // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol



    /// @notice A record of each accounts delegate

    mapping (address => address) internal _delegates;



    /// @notice A checkpoint for marking number of votes from a given block

    struct Checkpoint {

        uint32 fromBlock;

        uint256 votes;

    }



    /// @notice A record of votes checkpoints for each account, by index

    mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;



    /// @notice The number of checkpoints for each account

    mapping (address => uint32) public numCheckpoints;



    /// @notice The EIP-712 typehash for the contract's domain

    bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");



    /// @notice The EIP-712 typehash for the delegation struct used by the contract

    bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");



    /// @notice A record of states for signing / validating signatures

    mapping (address => uint) public nonces;



      /// @notice An event thats emitted when an account changes its delegate

    event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);



    /// @notice An event thats emitted when a delegate account's vote balance changes

    event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);



    /**

     * @notice Delegate votes from `msg.sender` to `delegatee`

     * @param delegator The address to get delegatee for

     */

    function delegates(address delegator)

        external

        view

        returns (address)

    {

        return _delegates[delegator];

    }



   /**

    * @notice Delegate votes from `msg.sender` to `delegatee`

    * @param delegatee The address to delegate votes to

    */

    function delegate(address delegatee) external {

        return _delegate(msg.sender, delegatee);

    }



    /**

     * @notice Delegates votes from signatory to `delegatee`

     * @param delegatee The address to delegate votes to

     * @param nonce The contract state required to match the signature

     * @param expiry The time at which to expire the signature

     * @param v The recovery byte of the signature

     * @param r Half of the ECDSA signature pair

     * @param s Half of the ECDSA signature pair

     */

    function delegateBySig(

        address delegatee,

        uint nonce,

        uint expiry,

        uint8 v,

        bytes32 r,

        bytes32 s

    )

        external

    {

        bytes32 domainSeparator = keccak256(

            abi.encode(

                DOMAIN_TYPEHASH,

                keccak256(bytes(name())),

                getChainId(),

                address(this)

            )

        );



        bytes32 structHash = keccak256(

            abi.encode(

                DELEGATION_TYPEHASH,

                delegatee,

                nonce,

                expiry

            )

        );



        bytes32 digest = keccak256(

            abi.encodePacked(

                "\\x19\\x01",

                domainSeparator,

                structHash

            )

        );



        address signatory = ecrecover(digest, v, r, s);

        require(signatory != address(0), "ERC20Governance::delegateBySig: invalid signature");

        require(nonce == nonces[signatory]++, "ERC20Governance::delegateBySig: invalid nonce");

        require(now <= expiry, "ERC20Governance::delegateBySig: signature expired");

        return _delegate(signatory, delegatee);

    }



    /**

     * @notice Gets the current votes balance for `account`

     * @param account The address to get votes balance

     * @return The number of current votes for `account`

     */

    function getCurrentVotes(address account)

        external

        view

        returns (uint256)

    {

        uint32 nCheckpoints = numCheckpoints[account];

        return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;

    }



    /**

     * @notice Determine the prior number of votes for an account as of a block number

     * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.

     * @param account The address of the account to check

     * @param blockNumber The block number to get the vote balance at

     * @return The number of votes the account had as of the given block

     */

    function getPriorVotes(address account, uint blockNumber)

        external

        view

        returns (uint256)

    {

        require(blockNumber < block.number, "ERC20Governance::getPriorVotes: not yet determined");



        uint32 nCheckpoints = numCheckpoints[account];

        if (nCheckpoints == 0) {

            return 0;

        }



        // First check most recent balance

        if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {

            return checkpoints[account][nCheckpoints - 1].votes;

        }



        // Next check implicit zero balance

        if (checkpoints[account][0].fromBlock > blockNumber) {

            return 0;

        }



        uint32 lower = 0;

        uint32 upper = nCheckpoints - 1;

        while (upper > lower) {

            uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow

            Checkpoint memory cp = checkpoints[account][center];

            if (cp.fromBlock == blockNumber) {

                return cp.votes;

            } else if (cp.fromBlock < blockNumber) {

                lower = center;

            } else {

                upper = center - 1;

            }

        }

        return checkpoints[account][lower].votes;

    }



    function _delegate(address delegator, address delegatee)

        internal

    {

        address currentDelegate = _delegates[delegator];

        uint256 delegatorBalance = balanceOf(delegator); // balance of underlying ERC20Governances (not scaled);

        _delegates[delegator] = delegatee;



        emit DelegateChanged(delegator, currentDelegate, delegatee);



        _moveDelegates(currentDelegate, delegatee, delegatorBalance);

    }



    function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {

        if (srcRep != dstRep && amount > 0) {

            if (srcRep != address(0)) {

                // decrease old representative

                uint32 srcRepNum = numCheckpoints[srcRep];

                uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;

                uint256 srcRepNew = srcRepOld.sub(amount);

                _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);

            }



            if (dstRep != address(0)) {

                // increase new representative

                uint32 dstRepNum = numCheckpoints[dstRep];

                uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;

                uint256 dstRepNew = dstRepOld.add(amount);

                _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);

            }

        }

    }



    function _writeCheckpoint(

        address delegatee,

        uint32 nCheckpoints,

        uint256 oldVotes,

        uint256 newVotes

    )

        internal

    {

        uint32 blockNumber = safe32(block.number, "ERC20Governance::_writeCheckpoint: block number exceeds 32 bits");



        if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {

            checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;

        } else {

            checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);

            numCheckpoints[delegatee] = nCheckpoints + 1;

        }



        emit DelegateVotesChanged(delegatee, oldVotes, newVotes);

    }



    function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {

        require(n < 2**32, errorMessage);

        return uint32(n);

    }



    function getChainId() internal pure returns (uint) {

        uint256 chainId;

        assembly { chainId := chainid() }

        return chainId;

    }

}



// File: @openzeppelin/contracts/access/roles/SignerRole.sol



pragma solidity ^0.5.0;







contract SignerRole is Context {

    using Roles for Roles.Role;



    event SignerAdded(address indexed account);

    event SignerRemoved(address indexed account);



    Roles.Role private _signers;



    constructor () internal {

        _addSigner(_msgSender());

    }



    modifier onlySigner() {

        require(isSigner(_msgSender()), "SignerRole: caller does not have the Signer role");

        _;

    }



    function isSigner(address account) public view returns (bool) {

        return _signers.has(account);

    }



    function addSigner(address account) public onlySigner {

        _addSigner(account);

    }



    function renounceSigner() public {

        _removeSigner(_msgSender());

    }



    function _addSigner(address account) internal {

        _signers.add(account);

        emit SignerAdded(account);

    }



    function _removeSigner(address account) internal {

        _signers.remove(account);

        emit SignerRemoved(account);

    }

}



// File: contracts/FOG.sol



/*

  \u2588\u2588\u2588\u2588\u2588  \u2592\u2588\u2588\u2588\u2588\u2588    \u2584\u2588\u2588\u2588\u2588 

\u2593\u2588\u2588   \u2592 \u2592\u2588\u2588\u2592  \u2588\u2588\u2592 \u2588\u2588\u2592 \u2580\u2588\u2592

\u2592\u2588\u2588\u2588\u2588 \u2591 \u2592\u2588\u2588\u2591  \u2588\u2588\u2592 \u2588\u2588\u2591\u2584\u2584\u2584 \u2591

 \u2593\u2588\u2592  \u2591\u2592 \u2588\u2588   \u2588\u2588\u2591\u2591\u2593\u2588  \u2588\u2588\u2593

\u2591 \u2588\u2591\u2591   \u2591 \u2588\u2588\u2588\u2588\u2593\u2592\u2591 \u2592\u2593\u2588\u2588\u2588\u2580  \u2592

 \u2592 \u2591    \u2591 \u2592\u2591\u2592\u2591\u2592\u2591      \u2591\u2592  

          \u2591 \u2592 \u2592\u2591     \u2591   \u2591 

 \u2591 \u2591  \u2591 \u2591 \u2591   \u2591 \u2591   \u2592  \u2591 \u2591 

  \u2591 \u2591 \u2591  \u2591        \u2591   \u2591 \u2591       

 \u2591   \u2591 \u2591  \u2591     \u2591 \u2592 \u2591 \u2591\u2591   

     \u2591   \u2591 \u2591 \u2591 \u2591 \u2591\u2591

   \u2591   \u2591 \u2591 \u2591 \u2591 \u2591\u2591  \u2591  \u2591                  

    \u2591 \u2591   \u2591 \u2591     \u2591 \u2591            

       \u2591      \u2591 

      \u2591     \u2591   \u2591   \u2591   



FOG is an experimental, governance branch of the LIQ (LIQUID) token ecosystem.



FOG is a fixed supply token that is acquired by pairing LIQ/ETH LP and staking

the UniV2 LP tokens at https://liquidefi.co/ 



FOG is then emitted to staking LP providers.



The benefits of holding FOG are twofold:



1. FOG LP providers will be rewarded with ETH and FOG from each 

FOG transaction. Initially, these rewards are pooled in the contract. 

At any time, a provider can call the RewardLiquidityProviders command (Condensate)

on the contract, or 'Condensate.exe' on the website, which then automatically 

divides and dispenses rewards to LP holders (this removes any need to stake the FOG LP). 

The reward amount an individual provider receives is based on said LP provider\u2019s share 

of the pool.



How does this work? 



FOG collects a 7.5% fee on all transfers (which can be later adjusted). 

This fee is then split between ***three functions:*** 



- 60% to adding permanently locked FOG LP 

- 30% FOG/ETH sent to the UNIV2 pool. This is then distributed to 

providers based on your pool share percentage after calling the 

RewardLiquidityProviders command (aka Condensate.exe)

- 10% goes to market buying LIQ which is then converted to LIQ/ETH LP. 



2. FOG is the governance token to the LIQ ecosystem.



All rates are adjustable by way of a DAO, controlled by FOG holders / voting.

FOG will have additional governance abilities to be disclosed later as new

strategies reveal themselves to continue to evolve the LIQ ecosystem. 



*/



pragma solidity ^0.5.17;













contract FOG is 

    ERC20,

    ERC20Detailed("Fog", "FOG", 18),

    // governance must be before transfer liquidity lock

    // or delegates are not updated correctly

    Governance,

    DoublePoggerino,

    SignerRole

{

    constructor() public {

        // mint tokens which will initially belong to deployer

        // deployer should go seed the pair with some initial liquidity

        _mint(msg.sender, 1000000 * 10**18);

    }

         

        

    function setUniswapV2Router(address _uniswapV2Router) public onlySigner {

        require(uniswapV2Router == address(0), "FogToken::setUniswapV2Router: already set");

        uniswapV2Router = _uniswapV2Router;

    }



    function setUniswapV2Pair(address _uniswapV2Pair) public onlySigner {

        require(uniswapV2Pair == address(0), "FogToken::setUniswapV2Pair: already set");

        uniswapV2Pair = _uniswapV2Pair;

    }

    

    

    function setErc20TokenAddress(address _tokenAddress) public onlySigner {

            tokenAddress = _tokenAddress;

        emit TokenAddressUpdate(tokenAddress);

     }

     

     function setErc20TokenPairAddress(address _tokenAddressPair) public onlySigner {

        tokenAddressPair = _tokenAddressPair;

         emit TokenAddressPairUpdate(tokenAddress); 

     }

     

     function setWethAddress(address _wethAddress) public onlySigner {

         wethAddress = _wethAddress;

         emit WethAddressUpdate(wethAddress); 

     } 



   function updateFees(uint8 _feeDecimals, uint32 _feePercentage)

        public

        onlySigner

    {

        feeDecimals = _feeDecimals;

        feePercentage = _feePercentage;

        emit FeeUpdated(_feeDecimals, _feePercentage);

    }

    

    function updateRewardsSplit(uint32 _fogRewardPercentage)

        public

        onlySigner

    {

        fogRewardPercentage = _fogRewardPercentage;

        emit RewardsUpdate(_fogRewardPercentage);

    }

    

    function updateLpSplits(uint32 _fogLockPercentage, uint32 _tokenLockPercentage) public onlySigner 

    {

        fogLockPercentage = _fogLockPercentage;

        tokenLockPercentage = _tokenLockPercentage;

        emit LocksUpdate(_fogLockPercentage, _tokenLockPercentage);

    }

    

        // this is to remove the token LP that fog contract buys

        // this may or may not be used as future incentives

        // UNABLE TO REMOVE FOG LP due to require

        

    function withdrawForeignTokens(address _tokenContract, address _to) onlySigner public returns (bool) {

        require(_tokenContract != address(this), "cannot withdraw Fog");

        require(_tokenContract != address(uniswapV2Pair), "cannot withdraw FOG LP");

        ERC20 token = ERC20(_tokenContract);

        uint256 amount = token.balanceOf(address(this));

        return token.transfer(_to, amount);

    }



}

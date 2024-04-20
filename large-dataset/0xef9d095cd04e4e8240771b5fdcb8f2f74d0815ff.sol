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



// File: @openzeppelin/contracts/math/Math.sol



pragma solidity ^0.5.0;



/**

 * @dev Standard math utilities missing in the Solidity language.

 */

library Math {

    /**

     * @dev Returns the largest of two numbers.

     */

    function max(uint256 a, uint256 b) internal pure returns (uint256) {

        return a >= b ? a : b;

    }



    /**

     * @dev Returns the smallest of two numbers.

     */

    function min(uint256 a, uint256 b) internal pure returns (uint256) {

        return a < b ? a : b;

    }



    /**

     * @dev Returns the average of two numbers. The result is rounded towards

     * zero.

     */

    function average(uint256 a, uint256 b) internal pure returns (uint256) {

        // (a + b) / 2 can overflow, so we distribute

        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);

    }

}



// File: @openzeppelin/contracts/utils/Arrays.sol



pragma solidity ^0.5.0;





/**

 * @dev Collection of functions related to array types.

 */

library Arrays {

   /**

     * @dev Searches a sorted `array` and returns the first index that contains

     * a value greater or equal to `element`. If no such index exists (i.e. all

     * values in the array are strictly less than `element`), the array length is

     * returned. Time complexity O(log n).

     *

     * `array` is expected to be sorted in ascending order, and to contain no

     * repeated elements.

     */

    function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {

        if (array.length == 0) {

            return 0;

        }



        uint256 low = 0;

        uint256 high = array.length;



        while (low < high) {

            uint256 mid = Math.average(low, high);



            // Note that mid will always be strictly less than high (i.e. it will be a valid array index)

            // because Math.average rounds down (it does integer division with truncation).

            if (array[mid] > element) {

                high = mid;

            } else {

                low = mid + 1;

            }

        }



        // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.

        if (low > 0 && array[low - 1] == element) {

            return low - 1;

        } else {

            return low;

        }

    }

}



// File: @openzeppelin/contracts/drafts/Counters.sol



pragma solidity ^0.5.0;





/**

 * @title Counters

 * @author Matt Condon (@shrugs)

 * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number

 * of elements in a mapping, issuing ERC721 ids, or counting request ids.

 *

 * Include with `using Counters for Counters.Counter;`

 * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}

 * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never

 * directly accessed.

 */

library Counters {

    using SafeMath for uint256;



    struct Counter {

        // This variable should never be directly accessed by users of the library: interactions must be restricted to

        // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add

        // this feature: see https://github.com/ethereum/solidity/issues/4637

        uint256 _value; // default: 0

    }



    function current(Counter storage counter) internal view returns (uint256) {

        return counter._value;

    }



    function increment(Counter storage counter) internal {

        // The {SafeMath} overflow check can be skipped here, see the comment at the top

        counter._value += 1;

    }



    function decrement(Counter storage counter) internal {

        counter._value = counter._value.sub(1);

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



// File: @openzeppelin/contracts/drafts/ERC20Snapshot.sol



pragma solidity ^0.5.0;











/**

 * @title ERC20 token with snapshots.

 * @dev Inspired by Jordi Baylina's

 * https://github.com/Giveth/minimd/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol[MiniMeToken]

 * to record historical balances.

 *

 * When a snapshot is made, the balances and total supply at the time of the snapshot are recorded for later

 * access.

 *

 * To make a snapshot, call the {snapshot} function, which will emit the {Snapshot} event and return a snapshot id.

 * To get the total supply from a snapshot, call the function {totalSupplyAt} with the snapshot id.

 * To get the balance of an account from a snapshot, call the {balanceOfAt} function with the snapshot id and the

 * account address.

 * @author Validity Labs AG <info@validitylabs.org>

 */

contract ERC20Snapshot is ERC20 {

    using SafeMath for uint256;

    using Arrays for uint256[];

    using Counters for Counters.Counter;



    // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a

    // Snapshot struct, but that would impede usage of functions that work on an array.

    struct Snapshots {

        uint256[] ids;

        uint256[] values;

    }



    mapping (address => Snapshots) private _accountBalanceSnapshots;

    Snapshots private _totalSupplySnapshots;



    // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.

    Counters.Counter private _currentSnapshotId;



    event Snapshot(uint256 id);



    // Creates a new snapshot id. Balances are only stored in snapshots on demand: unless a snapshot was taken, a

    // balance change will not be recorded. This means the extra added cost of storing snapshotted balances is only paid

    // when required, but is also flexible enough that it allows for e.g. daily snapshots.

    function snapshot() public returns (uint256) {

        _currentSnapshotId.increment();



        uint256 currentId = _currentSnapshotId.current();

        emit Snapshot(currentId);

        return currentId;

    }



    function balanceOfAt(address account, uint256 snapshotId) public view returns (uint256) {

        (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);



        return snapshotted ? value : balanceOf(account);

    }



    function totalSupplyAt(uint256 snapshotId) public view returns(uint256) {

        (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);



        return snapshotted ? value : totalSupply();

    }



    // _transfer, _mint and _burn are the only functions where the balances are modified, so it is there that the

    // snapshots are updated. Note that the update happens _before_ the balance change, with the pre-modified value.

    // The same is true for the total supply and _mint and _burn.

    function _transfer(address from, address to, uint256 value) internal {

        _updateAccountSnapshot(from);

        _updateAccountSnapshot(to);



        super._transfer(from, to, value);

    }



    function _mint(address account, uint256 value) internal {

        _updateAccountSnapshot(account);

        _updateTotalSupplySnapshot();



        super._mint(account, value);

    }



    function _burn(address account, uint256 value) internal {

        _updateAccountSnapshot(account);

        _updateTotalSupplySnapshot();



        super._burn(account, value);

    }



    // When a valid snapshot is queried, there are three possibilities:

    //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never

    //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds

    //  to this id is the current one.

    //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the

    //  requested id, and its value is the one to return.

    //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be

    //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is

    //  larger than the requested one.

    //

    // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if

    // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does

    // exactly this.

    function _valueAt(uint256 snapshotId, Snapshots storage snapshots)

        private view returns (bool, uint256)

    {

        require(snapshotId > 0, "ERC20Snapshot: id is 0");

        // solhint-disable-next-line max-line-length

        require(snapshotId <= _currentSnapshotId.current(), "ERC20Snapshot: nonexistent id");



        uint256 index = snapshots.ids.findUpperBound(snapshotId);



        if (index == snapshots.ids.length) {

            return (false, 0);

        } else {

            return (true, snapshots.values[index]);

        }

    }



    function _updateAccountSnapshot(address account) private {

        _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));

    }



    function _updateTotalSupplySnapshot() private {

        _updateSnapshot(_totalSupplySnapshots, totalSupply());

    }



    function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {

        uint256 currentId = _currentSnapshotId.current();

        if (_lastSnapshotId(snapshots.ids) < currentId) {

            snapshots.ids.push(currentId);

            snapshots.values.push(currentValue);

        }

    }



    function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {

        if (ids.length == 0) {

            return 0;

        } else {

            return ids[ids.length - 1];

        }

    }

}



// File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol



pragma solidity ^0.5.0;







/**

 * @dev Extension of {ERC20} that allows token holders to destroy both their own

 * tokens and those that they have an allowance for, in a way that can be

 * recognized off-chain (via event analysis).

 */

contract ERC20Burnable is Context, ERC20 {

    /**

     * @dev Destroys `amount` tokens from the caller.

     *

     * See {ERC20-_burn}.

     */

    function burn(uint256 amount) public {

        _burn(_msgSender(), amount);

    }



    /**

     * @dev See {ERC20-_burnFrom}.

     */

    function burnFrom(address account, uint256 amount) public {

        _burnFrom(account, amount);

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



// File: @openzeppelin/contracts/access/roles/MinterRole.sol



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



// File: @openzeppelin/contracts/token/ERC20/ERC20Mintable.sol



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



// File: contracts/external/FsToken.sol



pragma solidity ^0.5.17;









// The 'code' of FS token.

// The token is non transferable.

// Note: that any changes to layout of storage have to work with the proxy.

// To be safe here one should only be adding to storage and needs to make sure

// that none of the base classes change their storage layout.

contract FsToken is ERC20Snapshot, ERC20Mintable, ERC20Burnable {

    constructor() public {}



    function transferFrom(

        address, /*sender*/

        address, /*recipient*/

        uint256 /*amount*/

    ) public returns (bool) {

        revert("FST are not transferable");

    }



    function transfer(

        address, /*recipient*/

        uint256 /*amount*/

    ) public returns (bool) {

        revert("FST are not transferable");

    }



    function name() public pure returns (string memory) {

        return "Futureswap";

    }



    function symbol() public pure returns (string memory) {

        return "FST";

    }



    function decimals() public pure returns (uint8) {

        return 18;

    }

}



// File: contracts/registry/IRegistry.sol



pragma solidity ^0.5.17;



contract IRegistry {

    function getVotingAddress() public view returns (address);



    function getExchangeFactoryAddress() public view returns (address);



    function getWethAddress() public view returns (address);



    function getMessageProcessorAddress() public view returns (address);



    function getFsTokenAddress() public view returns (address);



    function getFsTokenProxyAdminAddress() public view returns (address);



    function getIncentivesAddress() public view returns (address);



    function getWalletAddress() public view returns (address payable);



    function getReplayTrackerAddress() public view returns (address);



    function getLiquidityTokenFactoryAddress() public view returns (address);



    function hasLiquidityTokensnapshotAccess(address sender) public view returns (bool);



    function hasWalletAccess(address sender) public view returns (bool);



    function removeWalletAccess(address _walletAccessor) public;



    function isValidOracleAddress(address oracleAddress) public view returns (bool);



    function isValidVerifierAddress(address verifierAddress) public view returns (bool);



    function isValidStamperAddress(address stamperAddress) public view returns (bool);



    function isExchange(address exchangeAddress) public view returns (bool);



    function addExchange(address _exchange) public;



    function removeExchange(address _exchange) public;



    function updateVotingAddress(address _address) public;

}



// File: contracts/registry/IRegistryUpdateConsumer.sol



pragma solidity ^0.5.17;



// Implemented by objects that need to know about registry updates.

interface IRegistryUpdateConsumer {

    function onRegistryRefresh() external;

}



// File: contracts/registry/RegistryHolder.sol



pragma solidity ^0.5.17;







// Holds a reference to the registry

// Eventually Ownership will be renounced

contract RegistryHolder is Ownable {

    address private registryAddress;



    function getRegistryAddress() public view returns (address) {

        return registryAddress;

    }



    // Change the address of registry, if the caller is the voting system as identified by the old

    // registry.

    function updateRegistry(address _newAddress) public {

        require(isOwner() || isVotingSystem(), "Only owner or voting system");

        require(_newAddress != address(0), "Zero address");

        registryAddress = _newAddress;

    }



    function isVotingSystem() private view returns (bool) {

        if (registryAddress == address(0)) {

            return false;

        }

        return IRegistry(registryAddress).getVotingAddress() == msg.sender;

    }

}



// File: contracts/registry/KnowsRegistry.sol



pragma solidity ^0.5.17;









// Base class for objects that need to know about other objects in the system

// This allows us to share modifiers and have a unified way of looking up other objects.

contract KnowsRegistry is IRegistryUpdateConsumer {

    RegistryHolder private registryHolder;



    modifier onlyVotingSystem() {

        require(isVotingSystem(msg.sender), "Only voting system");

        _;

    }



    modifier onlyExchangeFactory() {

        require(isExchangeFactory(msg.sender), "Only exchange factory");

        _;

    }



    modifier onlyExchangeFactoryOrVotingSystem() {

        require(isExchangeFactory(msg.sender) || isVotingSystem(msg.sender), "Only exchange factory or voting");

        _;

    }



    modifier requiresWalletAcccess() {

        require(getRegistry().hasWalletAccess(msg.sender), "requires wallet access");

        _;

    }



    modifier onlyMessageProcessor() {

        require(getRegistry().getMessageProcessorAddress() == msg.sender, "only MessageProcessor");

        _;

    }



    modifier onlyExchange() {

        require(getRegistry().isExchange(msg.sender), "Only exchange");

        _;

    }



    modifier onlyRegistry() {

        require(getRegistryAddress() == msg.sender, "only registry");

        _;

    }



    modifier onlyOracle() {

        require(isValidOracleAddress(msg.sender), "only oracle");

        _;

    }



    modifier requiresLiquidityTokenSnapshotAccess() {

        require(getRegistry().hasLiquidityTokensnapshotAccess(msg.sender), "only incentives");

        _;

    }



    constructor(address _registryHolder) public {

        registryHolder = RegistryHolder(_registryHolder);

    }



    function getRegistryHolder() internal view returns (RegistryHolder) {

        return registryHolder;

    }



    function getRegistry() internal view returns (IRegistry) {

        return IRegistry(getRegistryAddress());

    }



    function getRegistryAddress() internal view returns (address) {

        return registryHolder.getRegistryAddress();

    }



    function isRegistryHolder(address a) internal view returns (bool) {

        return a == address(registryHolder);

    }



    function isValidOracleAddress(address oracleAddress) public view returns (bool) {

        return getRegistry().isValidOracleAddress(oracleAddress);

    }



    function isValidVerifierAddress(address verifierAddress) public view returns (bool) {

        return getRegistry().isValidVerifierAddress(verifierAddress);

    }



    function isValidStamperAddress(address stamperAddress) public view returns (bool) {

        return getRegistry().isValidStamperAddress(stamperAddress);

    }



    function isVotingSystem(address a) public view returns (bool) {

        return a == getRegistry().getVotingAddress();

    }



    function isExchangeFactory(address a) public view returns (bool) {

        return a == getRegistry().getExchangeFactoryAddress();

    }



    function checkNotNull(address a) internal pure returns (address) {

        require(a != address(0), "address must be non zero");

        return a;

    }



    function checkNotNullAP(address payable a) internal pure returns (address payable) {

        require(a != address(0), "address must be non zero");

        return a;

    }

}



// File: contracts/voting/Voting.sol



pragma solidity ^0.5.17;













contract Voting is KnowsRegistry, Ownable, ReentrancyGuard {

    using SafeMath for uint256;



    uint256 public constant proposalFstStake = 100 ether;

    uint256 public constant minimumVoteTime = 2 days;

    uint256 public proposalCount;

    uint256 public pauseTimestamp;



    event ProposalCreated(uint256 indexed proposalId, string action, string title, string description);

    event VotedCasted(address indexed voter, uint256 indexed proposalId, uint256 amountOfVotes, bool isYesVote);

    event ProposalAccepted(uint256 indexed proposalId);

    event ProposalRejected(uint256 indexed proposalId);

    event ProposalCallFailed(uint256 indexed proposalId);



    struct Proposal {

        uint256 id;

        uint256 votingEnds; // epoch time in seconds when a vote will be able to be resolved and further votes will be rejected

        address to; // The address to which the result of the vote will be sent to

        bool isVoteResolved;

        bool isUpgradeProposal; // bool if the true the proposal is an upgrade proposal that goes to this specific address and assumes the data is a 20 byte address, if false it is a regular vote

        uint256 yesVotes; // amount of yes votes

        uint256 noVotes; // amount of no votes

        uint256 fstSnapshotId; // snapshot of tokens when the proposal was started

        address proposer; // the address of the creator of the vote

        mapping(address => bool) didVote; // tracks which addresses have voted

        bytes data; // byte data to use in a call (regular vote abi encoded data) - upgrade vote 20 bytes address

        bool ownerApproved; // is initially used by the owner to force votes to succeed without a full vote. Ownership will be phased out

    }



    mapping(uint256 => Proposal) public proposals;



    constructor(address _registryHolder) public KnowsRegistry(_registryHolder) {}



    function createProposal(

        address _to,

        bytes memory _data,

        string memory _action,

        string memory _title,

        string memory _description

    ) public {

        require(pauseTimestamp == 0, "proposals are paused");



        // We make users stake FST for creating a proposal to avoid

        // spammers creating proposals.

        // Funds are only returned on a successful proposal.

        FsToken fsToken = getFsToken();

        fsToken.burnFrom(msg.sender, proposalFstStake);



        bool isUpgradeProposal = _to == address(this);

        if (isUpgradeProposal) {

            // If this is an upgrade propsal the update address is saved

            // in the data field. We ensure here that the bytes field

            // has the length of a address (20 bytes).

            require(_data.length == 20, "data needs to be 20 bytes long");

        }



        Proposal storage p = proposals[proposalCount];

        p.id = proposalCount;

        p.votingEnds = now.add(minimumVoteTime);

        p.data = _data;

        p.to = _to;

        p.fstSnapshotId = fsToken.snapshot();

        p.proposer = msg.sender;

        p.isUpgradeProposal = isUpgradeProposal;



        emit ProposalCreated(proposalCount, _action, _title, _description);

        proposalCount++;

    }



    function vote(uint256 _proposalId, bool _isYesVote) public {

        requireProposalExists(_proposalId);

        Proposal storage p = proposals[_proposalId];

        require(now <= p.votingEnds, "vote is not open");

        require(!p.didVote[msg.sender], "already voted");



        p.didVote[msg.sender] = true;



        uint256 amountOfVotes = getFsToken().balanceOfAt(msg.sender, p.fstSnapshotId);



        if (_isYesVote) {

            p.yesVotes = p.yesVotes.add(amountOfVotes);

        } else {

            p.noVotes = p.noVotes.add(amountOfVotes);

        }

        emit VotedCasted(msg.sender, _proposalId, amountOfVotes, _isYesVote);

    }



    function pause(uint256 _proposalId) public {

        requireProposalExists(_proposalId);

        Proposal storage p = proposals[_proposalId];

        requireProposalCanBeResolved(p);

        require(p.isUpgradeProposal);



        require(pauseTimestamp == 0, "system already paused");

        pauseTimestamp = now;

    }



    function resolve(uint256 _proposalId) public nonReentrant {

        // Gas estimation is broken in ethereum for contract

        // factories. This has been reported a long time ago but never

        // got resolved:

        // https://github.com/ethereum/go-ethereum/issues/1590

        //

        // Requiring a high gas amount to start here makes this work for now

        // Note: this does not mean that all the gas will actually be used.

        // If the particular vote requires less gas users will be refunded.

        require(gasleft() >= 8000000, "Please use 8M+ gas to resolve");



        requireProposalExists(_proposalId);

        Proposal storage p = proposals[_proposalId];

        requireProposalCanBeResolved(p);



        if (p.isUpgradeProposal && !p.ownerApproved) {

            require(pauseTimestamp != 0, "pause first");

            require(now >= pauseTimestamp.add(minimumVoteTime), "pauseVotes");

        }



        p.isVoteResolved = true;



        bool votePassed = p.yesVotes > p.noVotes || p.ownerApproved;



        if (!votePassed) {

            emit ProposalRejected(_proposalId);

            return;

        }



        bool successful = p.isUpgradeProposal ? upgradeVoteExecution(p) : regularVoteExecution(p);

        if (!successful) {

            emit ProposalCallFailed(_proposalId);

            return;

        }



        emit ProposalAccepted(_proposalId);

    }



    function regularVoteExecution(Proposal storage p) private returns (bool) {

        (bool success, ) = p.to.call(p.data);

        if (success) {

            // Only mint initial tokens back if the vote passed

            FsToken fsToken = getFsToken();

            fsToken.mint(p.proposer, proposalFstStake);

        }

        return success;

    }



    function upgradeVoteExecution(Proposal storage p) private returns (bool) {

        address newAddress = bytesToAddress(p.data);

        // We update all other contracts with the new address

        // If any of these calls should fail we let the entire transaction fail.

        // This would allow anybody to call resolve again and retry since the

        // vote would have not gotten marked as resolved.

        // However if any of the steps here fail the system is in a problematic state.

        // All of these contracts have been written by us and should not fail.

        getFsToken().mint(p.proposer, proposalFstStake);

        doUpgrade(newAddress);



        return true;

    }



    function didAddressVote(uint256 _proposalId, address _voter) public view returns (bool) {

        return proposals[_proposalId].didVote[_voter];

    }



    // Allows owners to approve a vote, ownership will be phased out.

    function approve(uint256 _proposalId) public onlyOwner {

        proposals[_proposalId].ownerApproved = true;

    }



    // Allows owners to veto a vote, ownership will be phased out.

    function veto(uint256 _proposalId) public onlyOwner {

        proposals[_proposalId].isVoteResolved = true;

    }



    // Allows owners to upgrade the contract without a vote, ownership will be phased out.

    function ownableUpgrade(address _newAddress) public onlyOwner {

        doUpgrade(_newAddress);

    }



    function doUpgrade(address newAddress) private {

        Ownable(getRegistry().getFsTokenProxyAdminAddress()).transferOwnership(newAddress);

        FsToken fsToken = getFsToken();

        fsToken.addMinter(newAddress);

        fsToken.renounceMinter();

        getRegistry().updateVotingAddress(newAddress);

    }



    function requireProposalExists(uint256 proposalId) private view {

        require(proposalId < proposalCount, "Nonexisting proposal");

    }



    function requireProposalCanBeResolved(Proposal memory p) private view {

        require(now > p.votingEnds || p.ownerApproved, "vote is still open");

        require(!p.isVoteResolved, "already resolved");



        FsToken fsToken = getFsToken();

        uint256 totalFstSupply = fsToken.totalSupplyAt(p.fstSnapshotId);

        uint256 totalVotes = p.yesVotes.add(p.noVotes);

        bool aboveThreshold = (totalFstSupply / 10) <= totalVotes;

        require(aboveThreshold || p.ownerApproved, "The voting threshold has not been met");

    }



    function bytesToAddress(bytes memory bys) private pure returns (address addr) {

        require(bys.length == 20, "data needs to be 20 bytes long");

        // A quick way to load 2 bytes into the address variable

        assembly {

            addr := mload(add(bys, 20))

        }

    }



    function getFsToken() private view returns (FsToken) {

        return FsToken(getRegistry().getFsTokenAddress());

    }



    function onRegistryRefresh() public onlyRegistry {

        // No op since we always read all address directly from the registryHolder pointer

    }

}

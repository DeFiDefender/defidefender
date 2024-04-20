/*

 * Copyright \u00a9\ufe0f 2020 Curio AG (Company Number FL-0002.594.728-9)

 * Incorporated and registered in Liechtenstein.

 *

 * Copyright \u00a9\ufe0f 2020 Curio Capital AG (Company Number CHE-211.446.654)

 * Incorporated and registered in Zug, Switzerland.

 */



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



// File: @openzeppelin/contracts/utils/EnumerableSet.sol



pragma solidity ^0.5.0;



/**

 * @dev Library for managing

 * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive

 * types.

 *

 * Sets have the following properties:

 *

 * - Elements are added, removed, and checked for existence in constant time

 * (O(1)).

 * - Elements are enumerated in O(n). No guarantees are made on the ordering.

 *

 * As of v2.5.0, only `address` sets are supported.

 *

 * Include with `using EnumerableSet for EnumerableSet.AddressSet;`.

 *

 * _Available since v2.5.0._

 *

 * @author Alberto Cuesta Ca\u00f1ada

 */

library EnumerableSet {



    struct AddressSet {

        // Position of the value in the `values` array, plus 1 because index 0

        // means a value is not in the set.

        mapping (address => uint256) index;

        address[] values;

    }



    /**

     * @dev Add a value to a set. O(1).

     * Returns false if the value was already in the set.

     */

    function add(AddressSet storage set, address value)

        internal

        returns (bool)

    {

        if (!contains(set, value)){

            set.index[value] = set.values.push(value);

            return true;

        } else {

            return false;

        }

    }



    /**

     * @dev Removes a value from a set. O(1).

     * Returns false if the value was not present in the set.

     */

    function remove(AddressSet storage set, address value)

        internal

        returns (bool)

    {

        if (contains(set, value)){

            uint256 toDeleteIndex = set.index[value] - 1;

            uint256 lastIndex = set.values.length - 1;



            // If the element we're deleting is the last one, we can just remove it without doing a swap

            if (lastIndex != toDeleteIndex) {

                address lastValue = set.values[lastIndex];



                // Move the last value to the index where the deleted value is

                set.values[toDeleteIndex] = lastValue;

                // Update the index for the moved value

                set.index[lastValue] = toDeleteIndex + 1; // All indexes are 1-based

            }



            // Delete the index entry for the deleted value

            delete set.index[value];



            // Delete the old entry for the moved value

            set.values.pop();



            return true;

        } else {

            return false;

        }

    }



    /**

     * @dev Returns true if the value is in the set. O(1).

     */

    function contains(AddressSet storage set, address value)

        internal

        view

        returns (bool)

    {

        return set.index[value] != 0;

    }



    /**

     * @dev Returns an array with all values in the set. O(N).

     * Note that there are no guarantees on the ordering of values inside the

     * array, and it may change when more values are added or removed.



     * WARNING: This function may run out of gas on large sets: use {length} and

     * {get} instead in these cases.

     */

    function enumerate(AddressSet storage set)

        internal

        view

        returns (address[] memory)

    {

        address[] memory output = new address[](set.values.length);

        for (uint256 i; i < set.values.length; i++){

            output[i] = set.values[i];

        }

        return output;

    }



    /**

     * @dev Returns the number of elements on the set. O(1).

     */

    function length(AddressSet storage set)

        internal

        view

        returns (uint256)

    {

        return set.values.length;

    }



   /** @dev Returns the element stored at position `index` in the set. O(1).

    * Note that there are no guarantees on the ordering of values inside the

    * array, and it may change when more values are added or removed.

    *

    * Requirements:

    *

    * - `index` must be strictly less than {length}.

    */

    function get(AddressSet storage set, uint256 index)

        internal

        view

        returns (address)

    {

        return set.values[index];

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



// File: @galtproject/whitelisted-tokensale/contracts/interfaces/IWhitelistedTokenSale.sol



pragma solidity ^0.5.13;





interface IWhitelistedTokenSale {

  event SetTokenSaleRegistry(address indexed tokenSaleRegistry, address indexed admin);

  event SetWallet(address indexed wallet, address indexed admin);

  event UpdateCustomerToken(address indexed token, uint256 rateMul, uint256 rateDiv, address indexed admin);

  event RemoveCustomerToken(address indexed token, address indexed admin);

  event BuyTokens(address indexed spender, address indexed customer, address indexed token, uint256 tokenAmount, uint256 resultAmount);

}



// File: @openzeppelin/upgrades/contracts/Initializable.sol



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

contract Context is Initializable {

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



// File: @openzeppelin/contracts-ethereum-package/contracts/ownership/Ownable.sol



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

contract Ownable is Initializable, Context {

    address private _owner;



    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);



    /**

     * @dev Initializes the contract setting the deployer as the initial owner.

     */

    function initialize(address sender) public initializer {

        _owner = sender;

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

        return _msgSender() == _owner;

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



    uint256[50] private ______gap;

}



// File: @galtproject/whitelisted-tokensale/contracts/traits/Administrated.sol



pragma solidity ^0.5.13;



contract Administrated is Initializable, Ownable {

  using EnumerableSet for EnumerableSet.AddressSet;



  event AddAdmin(address indexed admin);

  event RemoveAdmin(address indexed admin);



  EnumerableSet.AddressSet internal admins;



  modifier onlyAdmin() {

    require(isAdmin(msg.sender), "Administrated: Msg sender is not admin");

    _;

  }

  constructor() public {

  }



  function addAdmin(address _admin) external onlyOwner {

    admins.add(_admin);

    emit AddAdmin(_admin);

  }



  function removeAdmin(address _admin) external onlyOwner {

    admins.remove(_admin);

    emit RemoveAdmin(_admin);

  }



  function isAdmin(address _admin) public view returns (bool) {

    return admins.contains(_admin);

  }



  function getAdminList() external view returns (address[] memory) {

    return admins.enumerate();

  }



  function getAdminCount() external view returns (uint256) {

    return admins.length();

  }

}



// File: @galtproject/whitelisted-tokensale/contracts/traits/Managed.sol



pragma solidity ^0.5.13;





contract Managed is Administrated {



  event AddManager(address indexed manager, address indexed admin);

  event RemoveManager(address indexed manager, address indexed admin);



  using EnumerableSet for EnumerableSet.AddressSet;



  EnumerableSet.AddressSet internal managers;



  modifier onlyAdminOrManager() {

    require(isAdmin(msg.sender) || isManager(msg.sender), "Managered: Msg sender is not admin or manager");

    _;

  }



  modifier onlyManager() {

    require(isManager(msg.sender), "Managered: Msg sender is not manager");

    _;

  }



  function addManager(address _manager) external onlyAdmin {

    managers.add(_manager);

    emit AddManager(_manager, msg.sender);

  }



  function removeManager(address _manager) external onlyAdmin {

    managers.remove(_manager);

    emit RemoveManager(_manager, msg.sender);

  }



  function isManager(address _manager) public view returns (bool) {

    return managers.contains(_manager);

  }



  function getManagerList() external view returns (address[] memory) {

    return managers.enumerate();

  }



  function getManagerCount() external view returns (uint256) {

    return managers.length();

  }

}



// File: @galtproject/whitelisted-tokensale/contracts/traits/Pausable.sol



pragma solidity ^0.5.13;





/**

 * @dev Contract module which allows children to implement an emergency stop

 * mechanism that can be triggered by an authorized account.

 *

 * This module is used through inheritance. It will make available the

 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to

 * the functions of your contract. Note that they will not be pausable by

 * simply including this module, only once the modifiers are put in place.

 */

contract Pausable is Administrated {

  /**

   * @dev Emitted when the pause is triggered by an admin (`account`).

   */

  event Paused(address admin);



  /**

   * @dev Emitted when the pause is lifted by an admin (`account`).

   */

  event Unpaused(address admin);



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

  function pause() public onlyAdmin whenNotPaused {

    _paused = true;

    emit Paused(msg.sender);

  }



  /**

   * @dev Called by a pauser to unpause, returns to normal state.

   */

  function unpause() public onlyAdmin whenPaused {

    _paused = false;

    emit Unpaused(msg.sender);

  }

}



// File: contracts/interfaces/ITokenReserve.sol



pragma solidity ^0.5.13;





interface ITokenReserve {

  event SetTokenSaleRegistry(address indexed tokenSaleRegistry, address indexed admin);

  event SetWallet(address indexed wallet, address indexed admin);

  event UpdateCustomerToken(address indexed token, uint256 rateMul, uint256 rateDiv, address indexed admin);

  event RemoveCustomerToken(address indexed token, address indexed admin);

  event ReserveTokens(

    uint256 orderId,

    address indexed spender,

    address indexed customer,

    address indexed token,

    uint256 tokenAmount,

    uint256 resultAmount

  );

  event AddReserveTokens(

    uint256 orderId,

    address indexed admin,

    address indexed customer,

    address indexed token,

    uint256 tokenAmount,

    uint256 resultAmount,

    string paymentDetails

  );

  event DistributeReservedTokens(address indexed admin, address indexed customer, uint256 amount);

}



// File: contracts/TokenReserve.sol



pragma solidity ^0.5.13;



contract TokenReserve is Managed, ITokenReserve, Pausable {

  using EnumerableSet for EnumerableSet.AddressSet;

  using SafeERC20 for IERC20;

  using SafeMath for uint256;



  EnumerableSet.AddressSet internal customerTokens;



  IERC20 public tokenToSell;



  address public wallet;



  uint256 public currentReserved;

  uint256 public totalReserved;



  struct TokenInfo {

    uint256 rateMul;

    uint256 rateDiv;

    uint256 totalReserved;

    uint256 totalReceived;

    uint256 onWalletTotalReceived;

    uint256 totalSold;

  }



  mapping(address => TokenInfo) public customerTokenInfo;



  struct ReservedOrder {

    address customerTokenAddress;

    uint256 customerTokenAmount;

    uint256 reservedAmount;

    address customerAddress;

    bool onWallet;

    string paymentDetails;

  }



  uint256 public ordersReservedCount;

  mapping(uint256 => ReservedOrder) public reservedOrders;



  struct CustomerInfo {

    uint256 currentReserved;

    uint256 totalReserved;

  }



  mapping(address => CustomerInfo) public customerInfo;



  constructor() public {

  }



  function initialize(address _owner, address _tokenToSell) public initializer {

    Ownable.initialize(_owner);

    tokenToSell = IERC20(_tokenToSell);

  }



  function setWallet(address _wallet) external onlyAdmin {

    wallet = _wallet;

    emit SetWallet(_wallet, msg.sender);

  }



  function addOrUpdateCustomerToken(address _token, uint256 _rateMul, uint256 _rateDiv) external onlyAdmin {

    require(_rateMul > 0 && _rateDiv > 0, "TokenReserve: incorrect rate");

    customerTokens.add(_token);

    customerTokenInfo[_token].rateMul = _rateMul;

    customerTokenInfo[_token].rateDiv = _rateDiv;

    emit UpdateCustomerToken(_token, _rateMul, _rateDiv, msg.sender);

  }



  function removeCustomerToken(address _token) external onlyAdmin {

    customerTokens.remove(_token);

    emit RemoveCustomerToken(_token, msg.sender);

  }



  function reserveTokens(IERC20 _customerToken, address _customerAddress, uint256 _weiAmount) external whenNotPaused {

    uint256 _resultTokenAmount = _reserveTokens(_customerToken, _customerAddress, _weiAmount, true);



    emit ReserveTokens(ordersReservedCount, msg.sender, _customerAddress, address(_customerToken), _weiAmount, _resultTokenAmount);

  }



  function addReserveTokens(

    IERC20 _customerToken,

    address _customerAddress,

    uint256 _weiAmount,

    string calldata _paymentDetails

  )

    external

    onlyAdminOrManager

  {

    uint256 _resultTokenAmount = _reserveTokens(_customerToken, _customerAddress, _weiAmount, false);



    reservedOrders[ordersReservedCount].paymentDetails = _paymentDetails;



    emit AddReserveTokens(

      ordersReservedCount,

      msg.sender,

      _customerAddress,

      address(_customerToken),

      _weiAmount,

      _resultTokenAmount,

      _paymentDetails

    );

  }



  function changeOrderReserve(uint256 _orderId, uint256 _changeAmount, bool _isAdd) external onlyAdminOrManager {

    ReservedOrder storage reservedOrder = reservedOrders[_orderId];

    require(!reservedOrder.onWallet, "Reserve changing available only for orders added by admins");



    CustomerInfo storage orderCustomer = customerInfo[reservedOrder.customerAddress];



    if (_isAdd) {

      reservedOrder.reservedAmount = reservedOrder.reservedAmount.add(_changeAmount);

      orderCustomer.currentReserved = orderCustomer.currentReserved.add(_changeAmount);

      orderCustomer.totalReserved = orderCustomer.totalReserved.add(_changeAmount);

      currentReserved = currentReserved.add(_changeAmount);

      totalReserved = totalReserved.add(_changeAmount);

    } else {

      reservedOrder.reservedAmount = reservedOrder.reservedAmount.sub(_changeAmount);

      orderCustomer.currentReserved = orderCustomer.currentReserved.sub(_changeAmount);

      orderCustomer.totalReserved = orderCustomer.totalReserved.sub(_changeAmount);

      currentReserved = currentReserved.sub(_changeAmount);

      totalReserved = totalReserved.sub(_changeAmount);

    }

  }



  function _reserveTokens(

    IERC20 _customerToken,

    address _customerAddress,

    uint256 _weiAmount,

    bool _transferToWallet

  )

    internal

    returns (uint256)

  {

    require(wallet != address(0), "TokenReserve: wallet is null");



    uint256 _resultTokenAmount = getTokenAmount(address(_customerToken), _weiAmount);



    TokenInfo storage _tokenInfo = customerTokenInfo[address(_customerToken)];

    _tokenInfo.totalReceived = _tokenInfo.totalReceived.add(_weiAmount);

    _tokenInfo.totalReserved = _tokenInfo.totalReserved.add(_resultTokenAmount);

    _tokenInfo.totalSold = _tokenInfo.totalSold.add(_resultTokenAmount);



    _addCustomerReserve(_customerAddress, _resultTokenAmount);



    ordersReservedCount = ordersReservedCount.add(1);

    reservedOrders[ordersReservedCount] = ReservedOrder(

      address(_customerToken),

      _weiAmount,

      _resultTokenAmount,

      _customerAddress,

      _transferToWallet,

      ""

    );



    if (_transferToWallet) {

      _tokenInfo.onWalletTotalReceived = _tokenInfo.onWalletTotalReceived.add(_weiAmount);



      _customerToken.safeTransferFrom(msg.sender, wallet, _weiAmount);

    }



    return _resultTokenAmount;

  }



  function _addCustomerReserve(address _customerAddress, uint256 _addAmount) internal {

    CustomerInfo storage _customerInfo = customerInfo[_customerAddress];

    _customerInfo.currentReserved = _customerInfo.currentReserved.add(_addAmount);

    _customerInfo.totalReserved = _customerInfo.totalReserved.add(_addAmount);



    currentReserved = currentReserved.add(_addAmount);

    totalReserved = totalReserved.add(_addAmount);

  }



  function distributeReserve(address[] calldata _customers) external onlyAdmin {

    uint256 len = _customers.length;



    for (uint256 i = 0; i < len; i++) {

      address _customerAddr = _customers[i];

      uint256 _amount = customerInfo[_customerAddr].currentReserved;



      currentReserved = currentReserved.sub(customerInfo[_customerAddr].currentReserved);

      customerInfo[_customerAddr].currentReserved = 0;



      tokenToSell.safeTransfer(_customerAddr, _amount);



      emit DistributeReservedTokens(msg.sender, _customerAddr, _amount);

    }

  }



  function getTokenAmount(address _customerToken, uint256 _weiAmount) public view returns (uint256) {

    require(_weiAmount > 0, "TokenReserve: weiAmount can't be null");

    require(isTokenAvailable(address(_customerToken)), "TokenReserve: _customerToken is not available");



    TokenInfo storage _tokenInfo = customerTokenInfo[_customerToken];

    uint256 _resultTokenAmount = _weiAmount.mul(_tokenInfo.rateMul).div(_tokenInfo.rateDiv);



    require(_resultTokenAmount > 0, "TokenReserve: _resultTokenAmount can't be null");



    return _resultTokenAmount;

  }



  function isTokenAvailable(address _customerToken) public view returns (bool) {

    return customerTokens.contains(_customerToken);

  }



  function getCustomerTokenList() external view returns (address[] memory) {

    return customerTokens.enumerate();

  }



  function getCustomerTokenCount() external view returns (uint256) {

    return customerTokens.length();

  }

}

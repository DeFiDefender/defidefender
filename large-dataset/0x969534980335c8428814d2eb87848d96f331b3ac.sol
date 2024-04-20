// Sources flattened with hardhat v2.0.1 https://hardhat.org





// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%@@@@@&%%%%%%@%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@&%%*****#%%%%&&&&&&&&&&@@@@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@@@@&&&&&&&%%*******#%%%# /%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@@@&&&&&&%%%********#*,,,*. %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&/******,.          %@@@@@@%%%%%@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@%%%&@@@@@%***%***             %%&@@&%%,**%@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@%,,(%@@@%%*(#***,              (%%@&%  (%@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@%    %%%%*,,**                   %%,   (%@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@%    %%%**,,                    %    %%%@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@%*                                  %@@@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@@&%*                                %@@@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@&#%%                                %@@@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@%#****%*                             %@@@@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@%%%/**%*                             %%@@@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@@@@%%*                              %@@@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@@@@%                                %@@@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@@@@%                                %@@@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@@@&%                                %@@@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@@@%                                 %%%@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@@@%                                  (%@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@&*                                     %@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@%%/,                                    %@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@%*****                                   %@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@&%%*****                                   %@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@&/******                                   %@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@&/******                                   %@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@&/,****,                                 (%%@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@%,*****,                                  (&@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@%*,***.                                   (&@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@%                                        %%%@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@%                                        %@@@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@&#(                                ((((%////%%&@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@&%%,. . ./%&&&&&%*.............%%&&&&&&&&&&&&&@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

/// MUH FANNY





// File @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/IERC20.sol@v3.0.0



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





// File @openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol@v3.0.0



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





// File @openzeppelin/contracts-ethereum-package/contracts/utils/Address.sol@v3.0.0



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





// File @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/SafeERC20.sol@v3.0.0



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





// File @openzeppelin/contracts-ethereum-package/contracts/utils/EnumerableSet.sol@v3.0.0



pragma solidity ^0.6.0;



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

 * ```

 * contract Example {

 *     // Add the library methods

 *     using EnumerableSet for EnumerableSet.AddressSet;

 *

 *     // Declare a set state variable

 *     EnumerableSet.AddressSet private mySet;

 * }

 * ```

 *

 * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`

 * (`UintSet`) are supported.

 */

library EnumerableSet {

    // To implement this library for multiple types with as little code

    // repetition as possible, we write it in terms of a generic Set type with

    // bytes32 values.

    // The Set implementation uses private functions, and user-facing

    // implementations (such as AddressSet) are just wrappers around the

    // underlying Set.

    // This means that we can only create new EnumerableSets for types that fit

    // in bytes32.



    struct Set {

        // Storage of set values

        bytes32[] _values;



        // Position of the value in the `values` array, plus 1 because index 0

        // means a value is not in the set.

        mapping (bytes32 => uint256) _indexes;

    }



    /**

     * @dev Add a value to a set. O(1).

     *

     * Returns true if the value was added to the set, that is if it was not

     * already present.

     */

    function _add(Set storage set, bytes32 value) private returns (bool) {

        if (!_contains(set, value)) {

            set._values.push(value);

            // The value is stored at length-1, but we add 1 to all indexes

            // and use 0 as a sentinel value

            set._indexes[value] = set._values.length;

            return true;

        } else {

            return false;

        }

    }



    /**

     * @dev Removes a value from a set. O(1).

     *

     * Returns true if the value was removed from the set, that is if it was

     * present.

     */

    function _remove(Set storage set, bytes32 value) private returns (bool) {

        // We read and store the value's index to prevent multiple reads from the same storage slot

        uint256 valueIndex = set._indexes[value];



        if (valueIndex != 0) { // Equivalent to contains(set, value)

            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in

            // the array, and then remove the last element (sometimes called as 'swap and pop').

            // This modifies the order of the array, as noted in {at}.



            uint256 toDeleteIndex = valueIndex - 1;

            uint256 lastIndex = set._values.length - 1;



            // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs

            // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.



            bytes32 lastvalue = set._values[lastIndex];



            // Move the last value to the index where the value to delete is

            set._values[toDeleteIndex] = lastvalue;

            // Update the index for the moved value

            set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based



            // Delete the slot where the moved value was stored

            set._values.pop();



            // Delete the index for the deleted slot

            delete set._indexes[value];



            return true;

        } else {

            return false;

        }

    }



    /**

     * @dev Returns true if the value is in the set. O(1).

     */

    function _contains(Set storage set, bytes32 value) private view returns (bool) {

        return set._indexes[value] != 0;

    }



    /**

     * @dev Returns the number of values on the set. O(1).

     */

    function _length(Set storage set) private view returns (uint256) {

        return set._values.length;

    }



   /**

    * @dev Returns the value stored at position `index` in the set. O(1).

    *

    * Note that there are no guarantees on the ordering of values inside the

    * array, and it may change when more values are added or removed.

    *

    * Requirements:

    *

    * - `index` must be strictly less than {length}.

    */

    function _at(Set storage set, uint256 index) private view returns (bytes32) {

        require(set._values.length > index, "EnumerableSet: index out of bounds");

        return set._values[index];

    }



    // AddressSet



    struct AddressSet {

        Set _inner;

    }



    /**

     * @dev Add a value to a set. O(1).

     *

     * Returns true if the value was added to the set, that is if it was not

     * already present.

     */

    function add(AddressSet storage set, address value) internal returns (bool) {

        return _add(set._inner, bytes32(uint256(value)));

    }



    /**

     * @dev Removes a value from a set. O(1).

     *

     * Returns true if the value was removed from the set, that is if it was

     * present.

     */

    function remove(AddressSet storage set, address value) internal returns (bool) {

        return _remove(set._inner, bytes32(uint256(value)));

    }



    /**

     * @dev Returns true if the value is in the set. O(1).

     */

    function contains(AddressSet storage set, address value) internal view returns (bool) {

        return _contains(set._inner, bytes32(uint256(value)));

    }



    /**

     * @dev Returns the number of values in the set. O(1).

     */

    function length(AddressSet storage set) internal view returns (uint256) {

        return _length(set._inner);

    }



   /**

    * @dev Returns the value stored at position `index` in the set. O(1).

    *

    * Note that there are no guarantees on the ordering of values inside the

    * array, and it may change when more values are added or removed.

    *

    * Requirements:

    *

    * - `index` must be strictly less than {length}.

    */

    function at(AddressSet storage set, uint256 index) internal view returns (address) {

        return address(uint256(_at(set._inner, index)));

    }





    // UintSet



    struct UintSet {

        Set _inner;

    }



    /**

     * @dev Add a value to a set. O(1).

     *

     * Returns true if the value was added to the set, that is if it was not

     * already present.

     */

    function add(UintSet storage set, uint256 value) internal returns (bool) {

        return _add(set._inner, bytes32(value));

    }



    /**

     * @dev Removes a value from a set. O(1).

     *

     * Returns true if the value was removed from the set, that is if it was

     * present.

     */

    function remove(UintSet storage set, uint256 value) internal returns (bool) {

        return _remove(set._inner, bytes32(value));

    }



    /**

     * @dev Returns true if the value is in the set. O(1).

     */

    function contains(UintSet storage set, uint256 value) internal view returns (bool) {

        return _contains(set._inner, bytes32(value));

    }



    /**

     * @dev Returns the number of values on the set. O(1).

     */

    function length(UintSet storage set) internal view returns (uint256) {

        return _length(set._inner);

    }



   /**

    * @dev Returns the value stored at position `index` in the set. O(1).

    *

    * Note that there are no guarantees on the ordering of values inside the

    * array, and it may change when more values are added or removed.

    *

    * Requirements:

    *

    * - `index` must be strictly less than {length}.

    */

    function at(UintSet storage set, uint256 index) internal view returns (uint256) {

        return uint256(_at(set._inner, index));

    }

}





// File @openzeppelin/contracts-ethereum-package/contracts/Initializable.sol@v3.0.0



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





// File @openzeppelin/contracts-ethereum-package/contracts/GSN/Context.sol@v3.0.0



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





// File @openzeppelin/contracts-ethereum-package/contracts/access/Ownable.sol@v3.0.0



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





// File @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol@v1.0.1



pragma solidity >=0.5.0;



interface IUniswapV2Pair {

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



    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint);



    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;



    event Mint(address indexed sender, uint amount0, uint amount1);

    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);

    event Swap(

        address indexed sender,

        uint amount0In,

        uint amount1In,

        uint amount0Out,

        uint amount1Out,

        address indexed to

    );

    event Sync(uint112 reserve0, uint112 reserve1);



    function MINIMUM_LIQUIDITY() external pure returns (uint);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);

    function price0CumulativeLast() external view returns (uint);

    function price1CumulativeLast() external view returns (uint);

    function kLast() external view returns (uint);



    function mint(address to) external returns (uint liquidity);

    function burn(address to) external returns (uint amount0, uint amount1);

    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;

    function skim(address to) external;

    function sync() external;



    function initialize(address, address) external;

}





// File contracts/v612/FANNY/FANNYVault.sol



pragma solidity 0.6.12;











interface INBUNIERC20 {

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

}



interface ICOREGlobals {

    function TransferHandler() external returns (address);

    function CoreBuyer() external returns (address);

}

interface ICOREBuyer {

    function ensureFee(uint256, uint256, uint256) external;  

}

interface ICORETransferHandler{

    function getVolumeOfTokenInCoreBottomUnits(address) external returns(uint256);

}



// Core Vault distributes fees equally amongst staked pools

// Have fun reading it. Hopefully it's bug-free. God bless.

contract FannyVault is OwnableUpgradeSafe {

    using SafeMath for uint256;

    using SafeERC20 for IERC20;



    event Deposit(address indexed by, address indexed forWho, uint256 indexed depositID, uint256 amount, uint256 multiplier);

    event Withdraw(address indexed user, uint256 indexed creditPenalty, uint256 amount);

    event COREBurned(address indexed from, uint256 value);



    // Eachu user has many deposits

    struct UserDeposit {

        uint256 amountCORE;

        uint256 startedLockedTime;

        uint256 amountTimeLocked;

        uint256 multiplier;

        bool withdrawed;

    }



    // Info of each user.

    struct UserInfo {

        uint256 amountCredit; // This is with locking multiplier

        uint256 rewardDebt; 

        UserDeposit[] deposits;

    }





    struct PoolInfo {

        uint256 accFannyPerShare; 

        bool withdrawable; 

        bool depositable;

    }



    IERC20 public CORE;

    IERC20 public FANNY;



    address public COREBurnPileNFT;



    // Info of each pool.

    PoolInfo public fannyPoolInfo;

    // Info of each user that stakes  tokens.

    mapping(address => UserInfo) public userInfo;

    // Total allocation poitns. Must be the sum of all allocation points in all pools.



    //// pending rewards awaiting anyone to massUpdate

    uint256 public totalFarmableFannies;



    uint256 public blocksFarmingActive;

    uint256 public blockFarmingStarted;

    uint256 public blockFarmingEnds;

    uint256 public fannyPerBlock;

    uint256 public totalShares;

    uint256 public totalBlocksToCreditRemaining;

    uint256 private lastBlockUpdate;

    uint256 private coreBalance;

    bool private locked;



    // Reentrancy lock 

    modifier lock() {

        require(locked == false, 'FANNY Vault: LOCKED');

        locked = true;

        _;

        locked = false;

    }



    function initialize(address _fanny, uint256 farmableFanniesInWholeUnits, uint256 _blocksFarmingActive) public initializer {

        OwnableUpgradeSafe.__Ownable_init();

        CORE = IERC20(0x62359Ed7505Efc61FF1D56fEF82158CcaffA23D7);

        FANNY = IERC20(_fanny);



        totalFarmableFannies = farmableFanniesInWholeUnits*1e18;

        blocksFarmingActive = _blocksFarmingActive;

    }



    function startFarming() public onlyOwner {

        require(FANNY.balanceOf(address(this)) == totalFarmableFannies, "Not enough fannies in the contract - shameful");

        /// We start farming

        blockFarmingStarted = block.number + 300; // 300 is for deposits to roll in before rewards start

        // This is how rewards are calculated

        lastBlockUpdate = block.number + 300; // 300 is for deposits to roll in before rewards start

        // We get the last farming block

        blockFarmingEnds = blockFarmingStarted.add(blocksFarmingActive);

        // This is static so can be set here

        totalBlocksToCreditRemaining = blockFarmingEnds.sub(blockFarmingStarted);

        fannyPerBlock = totalFarmableFannies.div(totalBlocksToCreditRemaining);

        fannyPoolInfo.depositable = true;



        // We open deposits

        fannyPoolInfo.withdrawable = true;



    }



    function fanniesLeft() public view returns (uint256) {

        return totalBlocksToCreditRemaining * fannyPerBlock;

    }



    function _burn(uint256 _amount) internal {

        require(COREBurnPileNFT !=  address(0), "Burning NFT is not set");

        // We send the CORE to burn pile

        safeWithdrawCORE(COREBurnPileNFT, _amount) ;

        emit COREBurned(msg.sender, _amount);

    }



    // Sets the burn NFT once

    function setBurningNFT(address _burningNFTAddress) public onlyOwner {

        require(COREBurnPileNFT == address(0), "Already set");

        COREBurnPileNFT = _burningNFTAddress;

    }





    // Update the given pool's ability to withdraw tokens

    // Note contract owner is meant to be a governance contract allowing CORE governance consensus

    function toggleWithdrawals(bool _withdrawable) public onlyOwner {

        fannyPoolInfo.withdrawable = _withdrawable;

    }

    function toggleDepositable(bool _depositable) public onlyOwner {

        fannyPoolInfo.depositable = _depositable;

    }



    // View function to see pending COREs on frontend.

    function fannyReadyToClaim(address _user) public view returns (uint256) {

        PoolInfo memory pool = fannyPoolInfo;

        UserInfo memory user = userInfo[_user];

        uint256 accFannyPerShare = pool.accFannyPerShare;



        return user.amountCredit.mul(accFannyPerShare).div(1e12).sub(user.rewardDebt);

    }





    // Update reward variables of the given pool to be up-to-date.

    function updatePool() public  { // This is safe to be called publically caues its deterministic

        if(lastBlockUpdate == block.number) {  return; } // save gas on consecutive same block calls

        if(totalShares == 0) {  return; } // div0 error

        if(blockFarmingStarted > block.number ) { return; }

        PoolInfo storage pool = fannyPoolInfo;

        // We take number of blocks since last update

        uint256 deltaBlocks = block.number.sub(lastBlockUpdate);

        if(deltaBlocks > totalBlocksToCreditRemaining) {

            deltaBlocks = totalBlocksToCreditRemaining;

        }

        uint256 numFannyToCreditpool = deltaBlocks.mul(fannyPerBlock);

        totalBlocksToCreditRemaining = totalBlocksToCreditRemaining.sub(deltaBlocks);

        // Its stored as 1e12 for change

        // We divide it by total issued shares to get it per share

        uint256 fannyPerShare = numFannyToCreditpool.mul(1e12).div(totalShares);

        // This means we finished farming so noone gets anythign no more

        // We assign a value that its per each share

        pool.accFannyPerShare = pool.accFannyPerShare.add(fannyPerShare);

        lastBlockUpdate = block.number;

    }





    function extendFarmingPeriod() public onlyOwner {

        require(fannyPerBlock == 5000000000000000);

        fannyPerBlock = fannyPerBlock / 10;

        totalBlocksToCreditRemaining = totalBlocksToCreditRemaining + 180_000;

        blockFarmingEnds = blockFarmingEnds + 180_000;

    }



    function totalWithdrawableCORE(address user) public view returns (uint256 withdrawableCORE) {

        UserInfo memory user = userInfo[user];

        uint256 lengthUserDeposits = user.deposits.length;



        // Loop over all deposits

        for (uint256 i = 0; i < lengthUserDeposits; i++) {

            UserDeposit memory currentDeposit = user.deposits[i]; // MEMORY BE CAREFUL



            if(currentDeposit.withdrawed == false  // If it has not yet been withdrawed

                        &&  // And

                        // the timestamp is higher than the lock time

                block.timestamp > currentDeposit.startedLockedTime.add(currentDeposit.amountTimeLocked)) 

                {

                    // It was not withdrawed.

                    // And its withdrawable, so we withdraw it

                    uint256 amountCOREInThisDeposit = currentDeposit.amountCORE; //gas savings we use it twice

                    withdrawableCORE = withdrawableCORE.add(amountCOREInThisDeposit);

                }

        }

    }





    function totalDepositedCOREAndNotWithdrawed(address user) public view returns (uint256 totalDeposited) {

        UserInfo memory user = userInfo[user];

        uint256 lengthUserDeposits = user.deposits.length;



        // Loop over all deposits

        for (uint256 i = 0; i < lengthUserDeposits; i++) {

            UserDeposit memory currentDeposit = user.deposits[i]; 

            if(currentDeposit.withdrawed == false) {

                uint256 amountCOREInThisDeposit = currentDeposit.amountCORE; 

                totalDeposited = totalDeposited.add(amountCOREInThisDeposit);

            }

        }

    }







    function numberDepositsOfuser(address user) public view returns (uint256) {

        UserInfo memory user = userInfo[user];

        return user.deposits.length;

    }







    // Amount and multiplier already needs to be validated

    function _deposit(uint256 _amount, uint256 multiplier, address forWho) internal {

        // We multiply the amount by the.. multiplier

        require(block.number < blockFarmingEnds, "Farming has ended or not started");

        PoolInfo memory pool = fannyPoolInfo; // Just memory is fine we don't write to it.

        require(pool.depositable, "Pool Deposits are closed");

        UserInfo storage user = userInfo[forWho];



        require(multiplier <= 25, "Sanity check failure for multiplier");

        require(multiplier > 0, "Sanity check failure for multiplier");



        uint256 depositID = user.deposits.length;

        if(multiplier != 25) { // multiplier of 25 is a burn

            user.deposits.push(

                UserDeposit({

                    amountCORE : _amount,

                    startedLockedTime : block.timestamp,

                    amountTimeLocked : multiplier > 1 ? multiplier * 4 weeks : 0,

                    withdrawed : false,

                    multiplier : multiplier

                })

            );

        }



        _amount = _amount.mul(multiplier); // Safe math just in case

                                           // Because i hate the ethereum network

                                           // And want everyone to pay 200 gas

        // Update before giving credit

        // Stops attacks

        updatePool();

        

        // Transfer pending fanny tokens to the user

        updateAndPayOutPending(forWho);



        //Transfer in the amounts from user

        if(_amount > 0) {

            user.amountCredit = user.amountCredit.add(_amount);

        }



        // We paid out so have to remember to update the user debt

        user.rewardDebt = user.amountCredit.mul(pool.accFannyPerShare).div(1e12);

        totalShares = totalShares.add(_amount);

    

        emit Deposit(msg.sender, forWho, depositID, _amount, multiplier);

    }





    // Function that burns from a person fro 25 multiplier

    function burnFor25XCredit(uint256 _amount) lock public {

        safeTransferCOREFromPersonToThisContract(_amount, msg.sender);

        _burn(_amount);

        _deposit(_amount, 25, msg.sender);

    }





    function deposit(uint256 _amount, uint256 lockTimeWeeks) lock public {

        // Safely transfer CORE out, make sure it got there in all pieces

        safeTransferCOREFromPersonToThisContract(_amount, msg.sender);

       _deposit(_amount, getMultiplier(lockTimeWeeks), msg.sender);

    }



    function depositFor(uint256 _amount, uint256 lockTimeWeeks, address forWho) lock public {

        safeTransferCOREFromPersonToThisContract(_amount, msg.sender);

       _deposit(_amount, getMultiplier(lockTimeWeeks), forWho);



    }



    function getMultiplier(uint256 lockTimeWeeks) internal pure returns (uint256 multiplier) {

        // We check for input errors

        require(lockTimeWeeks <= 48, "Lock time is too large.");

        // We establish the deposit multiplier

        if(lockTimeWeeks >= 8) { // Multiplier starts now

            multiplier = lockTimeWeeks/4; // max 12 min 2 in this branch

        } else {

            multiplier = 1; // else multiplier is 1 and is non-locked

        }

    }



    // Helper function that validates the deposit

    // And checks if FoT is on the deposit, which it should not be.

    function safeTransferCOREFromPersonToThisContract(uint256 _amount, address person) internal {

        uint256 beforeBalance = CORE.balanceOf(address(this));

        safeTransferFrom(address(CORE), person, address(this), _amount);

        uint256 afterBalance = CORE.balanceOf(address(this));

        require(afterBalance.sub(beforeBalance) == _amount, "Didn't get enough CORE, most likely FOT is ON");

    }





    function withdrawAllWithdrawableCORE() lock public {

        UserInfo memory user = userInfo[msg.sender];// MEMORY BE CAREFUL

        uint256 lenghtUserDeposits = user.deposits.length;

        require(user.amountCredit > 0, "Nothing to withdraw 1");

        require(lenghtUserDeposits > 0, "No deposits");

        // struct Deposit {

        //     uint256 amountCORE;

        //     uint256 startedLockedTime;

        //     uint256 amountTimeLocked;

        //     bool withdrawed;

        // }

        uint256 withdrawableCORE;

        uint256 creditPenalty;



        // Loop over all deposits

        for (uint256 i = 0; i < lenghtUserDeposits; i++) {

            UserDeposit memory currentDeposit = user.deposits[i]; // MEMORY BE CAREFUL

            if(currentDeposit.withdrawed == false  // If it has not yet been withdrawed

                        &&  // And

                        // the timestamp is higher than the lock time

                block.timestamp > currentDeposit.startedLockedTime.add(currentDeposit.amountTimeLocked)) 

                {

                    // It was not withdrawed.

                    // And its withdrawable, so we withdraw it



                    userInfo[msg.sender].deposits[i].withdrawed = true; // this writes to storage

                    uint256 amountCOREInThisDeposit = currentDeposit.amountCORE; //gas savings we use it twice



                    creditPenalty = creditPenalty.add(amountCOREInThisDeposit.mul(currentDeposit.multiplier));

                    withdrawableCORE = withdrawableCORE.add(amountCOREInThisDeposit);

                }

        }



        // We check if there is anything to witdraw

        require(withdrawableCORE > 0, "Nothing to withdraw 2");

        //Sanity checks

        require(creditPenalty >= withdrawableCORE, "Sanity check failure. Penalty should be bigger or equal to withdrawable");



        // We conduct the withdrawal

        _withdraw(msg.sender, msg.sender, withdrawableCORE, creditPenalty);



    }





    function _withdraw(address from, address to, uint256 amountToWithdraw, uint256 creditPenalty) internal {

        PoolInfo memory pool = fannyPoolInfo; 

        require(pool.withdrawable, "Withdrawals are closed.");

        UserInfo storage user = userInfo[from];



        // We update the pool

        updatePool();

        // And pay out rewards to this person

        updateAndPayOutPending(from);

        // Adjust their reward debt and balances

        user.amountCredit = user.amountCredit.sub(creditPenalty, "Coudn't validate user credit amounts");

        user.rewardDebt = user.amountCredit.mul(pool.accFannyPerShare).div(1e12); // divide out the change buffer

        totalShares = totalShares.sub(creditPenalty, "Coudn't validate total shares");

        safeWithdrawCORE(to, amountToWithdraw);

        emit Withdraw(from, creditPenalty, amountToWithdraw);

    }



    function claimFanny(address forWho) public lock {

        UserInfo storage user = userInfo[forWho];

        PoolInfo memory pool = fannyPoolInfo; // Just memory is fine we don't write to it.

        updatePool();

        // And pay out rewards to this person

        updateAndPayOutPending(forWho);

        user.rewardDebt = user.amountCredit.mul(pool.accFannyPerShare).div(1e12); 

    } 



    function claimFanny() public {

        claimFanny(msg.sender);

    }

    

    // Public locked function, validates via msg.sender

    function withdrawDeposit(uint256 depositID) public lock {

        _withdrawDeposit(depositID, msg.sender, msg.sender);

    }

    



    // We withdraw a specific deposit id

    // Important to validate from

    // Internal function

    function _withdrawDeposit(uint256 depositID, address from, address to)  internal   {

        UserDeposit memory currentDeposit = userInfo[from].deposits[depositID]; // MEMORY BE CAREFUL



        uint256 creditPenalty;

        uint256 withdrawableCORE;



        if(

            currentDeposit.withdrawed == false && 

            block.timestamp > currentDeposit.startedLockedTime.add(currentDeposit.amountTimeLocked)) 

        {

            // It was not withdrawed.

            // And its withdrawable, so we withdraw it

            userInfo[from].deposits[depositID].withdrawed = true; // this writes to storage

            uint256 amountCOREInThisDeposit = currentDeposit.amountCORE; //gas savings we use it twice



            creditPenalty = creditPenalty.add(amountCOREInThisDeposit.mul(currentDeposit.multiplier));

            withdrawableCORE = withdrawableCORE.add(amountCOREInThisDeposit);

        }



        require(withdrawableCORE > 0, "Nothing to withdraw");

        require(creditPenalty >= withdrawableCORE, "Sanity check failure. Penalty should be bigger or equal to withdrawable");

        require(creditPenalty > 0, "Sanity fail, withdrawing CORE and inccuring no credit penalty");

        // _withdraw(address from, address to, uint256 amountToWithdraw, uint256 creditPenalty)

        _withdraw(from, to, withdrawableCORE, creditPenalty);



    }





    function updateAndPayOutPending(address from) internal {

        uint256 pending = fannyReadyToClaim(from);

        if(pending > 0) {

            safeFannyTransfer(from, pending);

        }

    }





    // Safe core transfer function, just in case if rounding error causes pool to not have enough COREs.

    function safeFannyTransfer(address _to, uint256 _amount) internal {

        

        uint256 _fannyBalance = FANNY.balanceOf(address(this));



        if (_amount > _fannyBalance) {

            safeTransfer(address(FANNY), _to, _fannyBalance);

        } else {

            safeTransfer(address(FANNY), _to, _amount);

        }

    }



    function safeWithdrawCORE(address _to, uint256 _amount) internal {

        uint256 balanceBefore = CORE.balanceOf(_to);

        safeTransfer(address(CORE), _to, _amount);

        uint256 balanceAfter = CORE.balanceOf(_to);

        require(balanceAfter.sub(balanceBefore) == _amount, "Failed to withdraw CORE tokens successfully, make sure FOT is off");

    }





    function safeTransfer(address token, address to, uint256 value) internal {

        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));

        require(success && (data.length == 0 || abi.decode(data, (bool))), 'MUH FANNY: TRANSFER_FAILED');

    }



    function safeTransferFrom(address token, address from, address to, uint256 value) internal {

        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));

        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));

        require(success && (data.length == 0 || abi.decode(data, (bool))), 'MUH FANNY: TRANSFER_FROM_FAILED');

    }



}

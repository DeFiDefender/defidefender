// File: @openzeppelin/contracts/math/SafeMath.sol

// SPDX-License-Identifier: GPL-3.0-or-later



pragma solidity ^0.6.12;



// Needed to handle structures externally

pragma experimental ABIEncoderV2;



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

        mapping(bytes32 => uint256) _indexes;

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



        if (valueIndex != 0) {

            // Equivalent to contains(set, value)

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

    function _contains(Set storage set, bytes32 value)

        private

        view

        returns (bool)

    {

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

    function _at(Set storage set, uint256 index)

        private

        view

        returns (bytes32)

    {

        require(

            set._values.length > index,

            "EnumerableSet: index out of bounds"

        );

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

    function add(AddressSet storage set, address value)

        internal

        returns (bool)

    {

        return _add(set._inner, bytes32(uint256(value)));

    }



    /**

     * @dev Removes a value from a set. O(1).

     *

     * Returns true if the value was removed from the set, that is if it was

     * present.

     */

    function remove(AddressSet storage set, address value)

        internal

        returns (bool)

    {

        return _remove(set._inner, bytes32(uint256(value)));

    }



    /**

     * @dev Returns true if the value is in the set. O(1).

     */

    function contains(AddressSet storage set, address value)

        internal

        view

        returns (bool)

    {

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

    function at(AddressSet storage set, uint256 index)

        internal

        view

        returns (address)

    {

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

    function remove(UintSet storage set, uint256 value)

        internal

        returns (bool)

    {

        return _remove(set._inner, bytes32(value));

    }



    /**

     * @dev Returns true if the value is in the set. O(1).

     */

    function contains(UintSet storage set, uint256 value)

        internal

        view

        returns (bool)

    {

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

    function at(UintSet storage set, uint256 index)

        internal

        view

        returns (uint256)

    {

        return uint256(_at(set._inner, index));

    }

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

    function sub(

        uint256 a,

        uint256 b,

        string memory errorMessage

    ) internal pure returns (uint256) {

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

    function div(

        uint256 a,

        uint256 b,

        string memory errorMessage

    ) internal pure returns (uint256) {

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

    function mod(

        uint256 a,

        uint256 b,

        string memory errorMessage

    ) internal pure returns (uint256) {

        require(b != 0, errorMessage);

        return a % b;

    }

}



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

    function _msgSender() internal virtual view returns (address payable) {

        return msg.sender;

    }



    function _msgData() internal virtual view returns (bytes memory) {

        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691

        return msg.data;

    }

}



// File: @openzeppelin/contracts/access/Ownable.sol



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



    event OwnershipTransferred(

        address indexed previousOwner,

        address indexed newOwner

    );



    /**

     * @dev Initializes the contract setting the deployer as the initial owner.

     */

    constructor() internal {

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

        require(

            newOwner != address(0),

            "Ownable: new owner is the zero address"

        );

        emit OwnershipTransferred(_owner, newOwner);

        _owner = newOwner;

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

        // This method relies in extcodesize, which returns 0 for contracts in

        // construction, since the code is only stored at the end of the

        // constructor execution.



        uint256 size;

        // solhint-disable-next-line no-inline-assembly

        assembly {

            size := extcodesize(account)

        }

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

        require(

            address(this).balance >= amount,

            "Address: insufficient balance"

        );



        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value

        (bool success, ) = recipient.call{value: amount}("");

        require(

            success,

            "Address: unable to send value, recipient may have reverted"

        );

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

    function functionCall(address target, bytes memory data)

        internal

        returns (bytes memory)

    {

        return functionCall(target, data, "Address: low-level call failed");

    }



    /**

     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with

     * `errorMessage` as a fallback revert reason when `target` reverts.

     *

     * _Available since v3.1._

     */

    function functionCall(

        address target,

        bytes memory data,

        string memory errorMessage

    ) internal returns (bytes memory) {

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

    function functionCallWithValue(

        address target,

        bytes memory data,

        uint256 value

    ) internal returns (bytes memory) {

        return

            functionCallWithValue(

                target,

                data,

                value,

                "Address: low-level call with value failed"

            );

    }



    /**

     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but

     * with `errorMessage` as a fallback revert reason when `target` reverts.

     *

     * _Available since v3.1._

     */

    function functionCallWithValue(

        address target,

        bytes memory data,

        uint256 value,

        string memory errorMessage

    ) internal returns (bytes memory) {

        require(

            address(this).balance >= value,

            "Address: insufficient balance for call"

        );

        return _functionCallWithValue(target, data, value, errorMessage);

    }



    function _functionCallWithValue(

        address target,

        bytes memory data,

        uint256 weiValue,

        string memory errorMessage

    ) private returns (bytes memory) {

        require(isContract(target), "Address: call to non-contract");



        // solhint-disable-next-line avoid-low-level-calls

        (bool success, bytes memory returndata) = target.call{value: weiValue}(

            data

        );

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



interface IBPool {

    function rebind(

        address token,

        uint256 balance,

        uint256 denorm

    ) external;



    function setSwapFee(uint256 swapFee) external;



    function setPublicSwap(bool publicSwap) external;



    function bind(

        address token,

        uint256 balance,

        uint256 denorm

    ) external;



    function unbind(address token) external;



    function gulp(address token) external;



    function isBound(address token) external view returns (bool);



    function getBalance(address token) external view returns (uint256);



    function totalSupply() external view returns (uint256);



    function getSwapFee() external view returns (uint256);



    function isPublicSwap() external view returns (bool);



    function getDenormalizedWeight(address token)

        external

        view

        returns (uint256);



    function getTotalDenormalizedWeight() external view returns (uint256);



    // solhint-disable-next-line func-name-mixedcase

    function EXIT_FEE() external view returns (uint256);



    function calcPoolOutGivenSingleIn(

        uint256 tokenBalanceIn,

        uint256 tokenWeightIn,

        uint256 poolSupply,

        uint256 totalWeight,

        uint256 tokenAmountIn,

        uint256 swapFee

    ) external pure returns (uint256 poolAmountOut);



    function calcSingleInGivenPoolOut(

        uint256 tokenBalanceIn,

        uint256 tokenWeightIn,

        uint256 poolSupply,

        uint256 totalWeight,

        uint256 poolAmountOut,

        uint256 swapFee

    ) external pure returns (uint256 tokenAmountIn);



    function calcSingleOutGivenPoolIn(

        uint256 tokenBalanceOut,

        uint256 tokenWeightOut,

        uint256 poolSupply,

        uint256 totalWeight,

        uint256 poolAmountIn,

        uint256 swapFee

    ) external pure returns (uint256 tokenAmountOut);



    function calcPoolInGivenSingleOut(

        uint256 tokenBalanceOut,

        uint256 tokenWeightOut,

        uint256 poolSupply,

        uint256 totalWeight,

        uint256 tokenAmountOut,

        uint256 swapFee

    ) external pure returns (uint256 poolAmountIn);



    function getCurrentTokens() external view returns (address[] memory tokens);

}



interface IBFactory {

    function newBPool() external returns (IBPool);



    function setBLabs(address b) external;



    function collect(IBPool pool) external;



    function isBPool(address b) external view returns (bool);



    function getBLabs() external view returns (address);

}



library BalancerConstants {

    // State variables (must be constant in a library)



    // B "ONE" - all math is in the "realm" of 10 ** 18;

    // where numeric 1 = 10 ** 18

    uint256 public constant BONE = 10**18;

    uint256 public constant MIN_WEIGHT = BONE;

    uint256 public constant MAX_WEIGHT = BONE * 50;

    uint256 public constant MAX_TOTAL_WEIGHT = BONE * 50;

    uint256 public constant MIN_BALANCE = BONE / 10**6;

    uint256 public constant MAX_BALANCE = BONE * 10**12;

    uint256 public constant MIN_POOL_SUPPLY = BONE * 100;

    uint256 public constant MAX_POOL_SUPPLY = BONE * 10**9;

    uint256 public constant MIN_FEE = BONE / 10**6;

    uint256 public constant MAX_FEE = BONE / 10;

    // EXIT_FEE must always be zero, or ConfigurableRightsPool._pushUnderlying will fail

    uint256 public constant EXIT_FEE = 0;

    uint256 public constant MAX_IN_RATIO = BONE / 2;

    uint256 public constant MAX_OUT_RATIO = (BONE / 3) + 1 wei;

    // Must match BConst.MIN_BOUND_TOKENS and BConst.MAX_BOUND_TOKENS

    uint256 public constant MIN_ASSET_LIMIT = 2;

    uint256 public constant MAX_ASSET_LIMIT = 8;

    uint256 public constant MAX_UINT = uint256(-1);

}



// File: contracts/balancer/libraries/BalancerSafeMath.sol



pragma solidity 0.6.12;



// Imports



/**

 * @author Balancer Labs

 * @title SafeMath - wrap Solidity operators to prevent underflow/overflow

 * @dev badd and bsub are basically identical to OpenZeppelin SafeMath; mul/div have extra checks

 */

library BalancerSafeMath {

    /**

     * @notice Safe addition

     * @param a - first operand

     * @param b - second operand

     * @dev if we are adding b to a, the resulting sum must be greater than a

     * @return - sum of operands; throws if overflow

     */

    function badd(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a + b;

        require(c >= a, "ERR_ADD_OVERFLOW");

        return c;

    }



    /**

     * @notice Safe unsigned subtraction

     * @param a - first operand

     * @param b - second operand

     * @dev Do a signed subtraction, and check that it produces a positive value

     *      (i.e., a - b is valid if b <= a)

     * @return - a - b; throws if underflow

     */

    function bsub(uint256 a, uint256 b) internal pure returns (uint256) {

        (uint256 c, bool negativeResult) = bsubSign(a, b);

        require(!negativeResult, "ERR_SUB_UNDERFLOW");

        return c;

    }



    /**

     * @notice Safe signed subtraction

     * @param a - first operand

     * @param b - second operand

     * @dev Do a signed subtraction

     * @return - difference between a and b, and a flag indicating a negative result

     *           (i.e., a - b if a is greater than or equal to b; otherwise b - a)

     */

    function bsubSign(uint256 a, uint256 b)

        internal

        pure

        returns (uint256, bool)

    {

        if (b <= a) {

            return (a - b, false);

        } else {

            return (b - a, true);

        }

    }



    /**

     * @notice Safe multiplication

     * @param a - first operand

     * @param b - second operand

     * @dev Multiply safely (and efficiently), rounding down

     * @return - product of operands; throws if overflow or rounding error

     */

    function bmul(uint256 a, uint256 b) internal pure returns (uint256) {

        // Gas optimization (see github.com/OpenZeppelin/openzeppelin-contracts/pull/522)

        if (a == 0) {

            return 0;

        }



        // Standard overflow check: a/a*b=b

        uint256 c0 = a * b;

        require(c0 / a == b, "ERR_MUL_OVERFLOW");



        // Round to 0 if x*y < BONE/2?

        uint256 c1 = c0 + (BalancerConstants.BONE / 2);

        require(c1 >= c0, "ERR_MUL_OVERFLOW");

        uint256 c2 = c1 / BalancerConstants.BONE;

        return c2;

    }



    /**

     * @notice Safe division

     * @param dividend - first operand

     * @param divisor - second operand

     * @dev Divide safely (and efficiently), rounding down

     * @return - quotient; throws if overflow or rounding error

     */

    function bdiv(uint256 dividend, uint256 divisor)

        internal

        pure

        returns (uint256)

    {

        require(divisor != 0, "ERR_DIV_ZERO");



        // Gas optimization

        if (dividend == 0) {

            return 0;

        }



        uint256 c0 = dividend * BalancerConstants.BONE;

        require(c0 / dividend == BalancerConstants.BONE, "ERR_DIV_INTERNAL"); // bmul overflow



        uint256 c1 = c0 + (divisor / 2);

        require(c1 >= c0, "ERR_DIV_INTERNAL"); //  badd require



        uint256 c2 = c1 / divisor;

        return c2;

    }



    /**

     * @notice Safe unsigned integer modulo

     * @dev Returns the remainder of dividing two unsigned integers.

     *      Reverts when dividing by zero.

     *

     * Counterpart to Solidity's `%` operator. This function uses a `revert`

     * opcode (which leaves remaining gas untouched) while Solidity uses an

     * invalid opcode to revert (consuming all remaining gas).

     *

     * @param dividend - first operand

     * @param divisor - second operand -- cannot be zero

     * @return - quotient; throws if overflow or rounding error

     */

    function bmod(uint256 dividend, uint256 divisor)

        internal

        pure

        returns (uint256)

    {

        require(divisor != 0, "ERR_MODULO_BY_ZERO");



        return dividend % divisor;

    }



    /**

     * @notice Safe unsigned integer max

     * @dev Returns the greater of the two input values

     *

     * @param a - first operand

     * @param b - second operand

     * @return - the maximum of a and b

     */

    function bmax(uint256 a, uint256 b) internal pure returns (uint256) {

        return a >= b ? a : b;

    }



    /**

     * @notice Safe unsigned integer min

     * @dev returns b, if b < a; otherwise returns a

     *

     * @param a - first operand

     * @param b - second operand

     * @return - the lesser of the two input values

     */

    function bmin(uint256 a, uint256 b) internal pure returns (uint256) {

        return a < b ? a : b;

    }



    /**

     * @notice Safe unsigned integer average

     * @dev Guard against (a+b) overflow by dividing each operand separately

     *

     * @param a - first operand

     * @param b - second operand

     * @return - the average of the two values

     */

    function baverage(uint256 a, uint256 b) internal pure returns (uint256) {

        // (a + b) / 2 can overflow, so we distribute

        return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);

    }



    /**

     * @notice Babylonian square root implementation

     * @dev (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)

     * @param y - operand

     * @return z - the square root result

     */

    function sqrt(uint256 y) internal pure returns (uint256 z) {

        if (y > 3) {

            z = y;

            uint256 x = y / 2 + 1;

            while (x < z) {

                z = x;

                x = (y / x + x) / 2;

            }

        } else if (y != 0) {

            z = 1;

        }

    }

}



interface IERC20 {

    // Emitted when the allowance of a spender for an owner is set by a call to approve.

    // Value is the new allowance

    event Approval(

        address indexed owner,

        address indexed spender,

        uint256 value

    );



    // Emitted when value tokens are moved from one account (from) to another (to).

    // Note that value may be zero

    event Transfer(address indexed from, address indexed to, uint256 value);



    // Returns the amount of tokens in existence

    function totalSupply() external view returns (uint256);



    // Returns the amount of tokens owned by account

    function balanceOf(address account) external view returns (uint256);



    // Returns the remaining number of tokens that spender will be allowed to spend on behalf of owner

    // through transferFrom. This is zero by default

    // This value changes when approve or transferFrom are called

    function allowance(address owner, address spender)

        external

        view

        returns (uint256);



    // Sets amount as the allowance of spender over the caller\u2019s tokens

    // Returns a boolean value indicating whether the operation succeeded

    // Emits an Approval event.

    function approve(address spender, uint256 amount) external returns (bool);



    // Moves amount tokens from the caller\u2019s account to recipient

    // Returns a boolean value indicating whether the operation succeeded

    // Emits a Transfer event.

    function transfer(address recipient, uint256 amount)

        external

        returns (bool);



    // Moves amount tokens from sender to recipient using the allowance mechanism

    // Amount is then deducted from the caller\u2019s allowance

    // Returns a boolean value indicating whether the operation succeeded

    // Emits a Transfer event

    function transferFrom(

        address sender,

        address recipient,

        uint256 amount

    ) external returns (bool);

}



// Contracts



/* solhint-disable func-order */



/**

 * @author Balancer Labs

 * @title Highly opinionated token implementation

 */

contract PCToken is IERC20 {

    using BalancerSafeMath for uint256;



    // State variables

    string public constant NAME = "Balancer Smart Pool";

    uint8 public constant DECIMALS = 18;



    // No leading underscore per naming convention (non-private)

    // Cannot call totalSupply (name conflict)

    // solhint-disable-next-line private-vars-leading-underscore

    uint256 internal varTotalSupply;



    mapping(address => uint256) private _balance;

    mapping(address => mapping(address => uint256)) private _allowance;



    string private _symbol;

    string private _name;



    // Event declarations



    // See definitions above; must be redeclared to be emitted from this contract

    event Approval(

        address indexed owner,

        address indexed spender,

        uint256 value

    );

    event Transfer(address indexed from, address indexed to, uint256 value);



    // Function declarations



    /**

     * @notice Base token constructor

     * @param tokenSymbol - the token symbol

     */

    constructor(string memory tokenSymbol, string memory tokenName) public {

        _symbol = tokenSymbol;

        _name = tokenName;

    }



    // External functions



    /**

     * @notice Getter for allowance: amount spender will be allowed to spend on behalf of owner

     * @param owner - owner of the tokens

     * @param spender - entity allowed to spend the tokens

     * @return uint - remaining amount spender is allowed to transfer

     */

    function allowance(address owner, address spender)

        external

        override

        view

        returns (uint256)

    {

        return _allowance[owner][spender];

    }



    /**

     * @notice Getter for current account balance

     * @param account - address we're checking the balance of

     * @return uint - token balance in the account

     */

    function balanceOf(address account)

        external

        override

        view

        returns (uint256)

    {

        return _balance[account];

    }



    /**

     * @notice Approve owner (sender) to spend a certain amount

     * @dev emits an Approval event

     * @param spender - entity the owner (sender) is approving to spend his tokens

     * @param amount - number of tokens being approved

     * @return bool - result of the approval (will always be true if it doesn't revert)

     */

    function approve(address spender, uint256 amount)

        external

        override

        returns (bool)

    {

        /* In addition to the increase/decreaseApproval functions, could

           avoid the "approval race condition" by only allowing calls to approve

           when the current approval amount is 0

        

           require(_allowance[msg.sender][spender] == 0, "ERR_RACE_CONDITION");

           Some token contracts (e.g., KNC), already revert if you call approve 

           on a non-zero allocation. To deal with these, we use the SafeApprove library

           and safeApprove function when adding tokens to the pool.

        */



        _allowance[msg.sender][spender] = amount;



        emit Approval(msg.sender, spender, amount);



        return true;

    }



    /**

     * @notice Increase the amount the spender is allowed to spend on behalf of the owner (sender)

     * @dev emits an Approval event

     * @param spender - entity the owner (sender) is approving to spend his tokens

     * @param amount - number of tokens being approved

     * @return bool - result of the approval (will always be true if it doesn't revert)

     */

    function increaseApproval(address spender, uint256 amount)

        external

        returns (bool)

    {

        _allowance[msg.sender][spender] = BalancerSafeMath.badd(

            _allowance[msg.sender][spender],

            amount

        );



        emit Approval(msg.sender, spender, _allowance[msg.sender][spender]);



        return true;

    }



    /**

     * @notice Decrease the amount the spender is allowed to spend on behalf of the owner (sender)

     * @dev emits an Approval event

     * @dev If you try to decrease it below the current limit, it's just set to zero (not an error)

     * @param spender - entity the owner (sender) is approving to spend his tokens

     * @param amount - number of tokens being approved

     * @return bool - result of the approval (will always be true if it doesn't revert)

     */

    function decreaseApproval(address spender, uint256 amount)

        external

        returns (bool)

    {

        uint256 oldValue = _allowance[msg.sender][spender];

        // Gas optimization - if amount == oldValue (or is larger), set to zero immediately

        if (amount >= oldValue) {

            _allowance[msg.sender][spender] = 0;

        } else {

            _allowance[msg.sender][spender] = BalancerSafeMath.bsub(

                oldValue,

                amount

            );

        }



        emit Approval(msg.sender, spender, _allowance[msg.sender][spender]);



        return true;

    }



    /**

     * @notice Transfer the given amount from sender (caller) to recipient

     * @dev _move emits a Transfer event if successful

     * @param recipient - entity receiving the tokens

     * @param amount - number of tokens being transferred

     * @return bool - result of the transfer (will always be true if it doesn't revert)

     */

    function transfer(address recipient, uint256 amount)

        external

        override

        returns (bool)

    {

        require(recipient != address(0), "ERR_ZERO_ADDRESS");



        _move(msg.sender, recipient, amount);



        return true;

    }



    /**

     * @notice Transfer the given amount from sender to recipient

     * @dev _move emits a Transfer event if successful; may also emit an Approval event

     * @param sender - entity sending the tokens (must be caller or allowed to spend on behalf of caller)

     * @param recipient - recipient of the tokens

     * @param amount - number of tokens being transferred

     * @return bool - result of the transfer (will always be true if it doesn't revert)

     */

    function transferFrom(

        address sender,

        address recipient,

        uint256 amount

    ) external override returns (bool) {

        require(recipient != address(0), "ERR_ZERO_ADDRESS");

        require(

            msg.sender == sender || amount <= _allowance[sender][msg.sender],

            "ERR_PCTOKEN_BAD_CALLER"

        );



        _move(sender, recipient, amount);



        // memoize for gas optimization

        uint256 oldAllowance = _allowance[sender][msg.sender];



        // If the sender is not the caller, adjust the allowance by the amount transferred

        if (msg.sender != sender && oldAllowance != uint256(-1)) {

            _allowance[sender][msg.sender] = BalancerSafeMath.bsub(

                oldAllowance,

                amount

            );



            emit Approval(

                msg.sender,

                recipient,

                _allowance[sender][msg.sender]

            );

        }



        return true;

    }



    // public functions



    /**

     * @notice Getter for the total supply

     * @dev declared external for gas optimization

     * @return uint - total number of tokens in existence

     */

    function totalSupply() external override view returns (uint256) {

        return varTotalSupply;

    }



    // Public functions



    /**

     * @dev Returns the name of the token.

     *      We allow the user to set this name (as well as the symbol).

     *      Alternatives are 1) A fixed string (original design)

     *                       2) A fixed string plus the user-defined symbol

     *                          return string(abi.encodePacked(NAME, "-", _symbol));

     */

    function name() external view returns (string memory) {

        return _name;

    }



    /**

     * @dev Returns the symbol of the token, usually a shorter version of the

     * name.

     */

    function symbol() external view returns (string memory) {

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

    function decimals() external pure returns (uint8) {

        return DECIMALS;

    }



    // internal functions



    // Mint an amount of new tokens, and add them to the balance (and total supply)

    // Emit a transfer amount from the null address to this contract

    function _mint(uint256 amount) internal virtual {

        _balance[address(this)] = BalancerSafeMath.badd(

            _balance[address(this)],

            amount

        );

        varTotalSupply = BalancerSafeMath.badd(varTotalSupply, amount);



        emit Transfer(address(0), address(this), amount);

    }



    // Burn an amount of new tokens, and subtract them from the balance (and total supply)

    // Emit a transfer amount from this contract to the null address

    function _burn(uint256 amount) internal virtual {

        // Can't burn more than we have

        // Remove require for gas optimization - bsub will revert on underflow

        // require(_balance[address(this)] >= amount, "ERR_INSUFFICIENT_BAL");



        _balance[address(this)] = BalancerSafeMath.bsub(

            _balance[address(this)],

            amount

        );

        varTotalSupply = BalancerSafeMath.bsub(varTotalSupply, amount);



        emit Transfer(address(this), address(0), amount);

    }



    // Transfer tokens from sender to recipient

    // Adjust balances, and emit a Transfer event

    function _move(

        address sender,

        address recipient,

        uint256 amount

    ) internal virtual {

        // Can't send more than sender has

        // Remove require for gas optimization - bsub will revert on underflow

        // require(_balance[sender] >= amount, "ERR_INSUFFICIENT_BAL");



        _balance[sender] = BalancerSafeMath.bsub(_balance[sender], amount);

        _balance[recipient] = BalancerSafeMath.badd(

            _balance[recipient],

            amount

        );



        emit Transfer(sender, recipient, amount);

    }



    // Transfer from this contract to recipient

    // Emits a transfer event if successful

    function _push(address recipient, uint256 amount) internal {

        _move(address(this), recipient, amount);

    }



    // Transfer from recipient to this contract

    // Emits a transfer event if successful

    function _pull(address sender, uint256 amount) internal {

        _move(sender, address(this), amount);

    }

}



/**

 * @author Balancer Labs (and OpenZeppelin)

 * @title Protect against reentrant calls (and also selectively protect view functions)

 * @dev Contract module that helps prevent reentrant calls to a function.

 *

 * Inheriting from `ReentrancyGuard` will make the {_lock_} modifier

 * available, which can be applied to functions to make sure there are no nested

 * (reentrant) calls to them.

 *

 * Note that because there is a single `_lock_` guard, functions marked as

 * `_lock_` may not call one another. This can be worked around by making

 * those functions `private`, and then adding `external` `_lock_` entry

 * points to them.

 *

 * Also adds a _lockview_ modifier, which doesn't create a lock, but fails

 *   if another _lock_ call is in progress

 */

contract BalancerReentrancyGuard {

    // Booleans are more expensive than uint256 or any type that takes up a full

    // word because each write operation emits an extra SLOAD to first read the

    // slot's contents, replace the bits taken up by the boolean, and then write

    // back. This is the compiler's defense against contract upgrades and

    // pointer aliasing, and it cannot be disabled.



    // The values being non-zero value makes deployment a bit more expensive,

    // but in exchange the refund on every call to nonReentrant will be lower in

    // amount. Since refunds are capped to a percentage of the total

    // transaction's gas, it is best to keep them low in cases like this one, to

    // increase the likelihood of the full refund coming into effect.

    uint256 private constant _NOT_ENTERED = 1;

    uint256 private constant _ENTERED = 2;



    uint256 private _status;



    constructor() internal {

        _status = _NOT_ENTERED;

    }



    /**

     * @dev Prevents a contract from calling itself, directly or indirectly.

     * Calling a `_lock_` function from another `_lock_`

     * function is not supported. It is possible to prevent this from happening

     * by making the `_lock_` function external, and make it call a

     * `private` function that does the actual work.

     */

    modifier lock() {

        // On the first call to _lock_, _notEntered will be true

        require(_status != _ENTERED, "ERR_REENTRY");



        // Any calls to _lock_ after this point will fail

        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see

        // https://eips.ethereum.org/EIPS/eip-2200)

        _status = _NOT_ENTERED;

    }



    /**

     * @dev Also add a modifier that doesn't create a lock, but protects functions that

     *      should not be called while a _lock_ function is running

     */

    modifier viewlock() {

        require(_status != _ENTERED, "ERR_REENTRY_VIEW");

        _;

    }

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

contract BalancerOwnable {

    // State variables



    address private _owner;



    // Event declarations



    event OwnershipTransferred(

        address indexed previousOwner,

        address indexed newOwner

    );



    // Modifiers



    /**

     * @dev Throws if called by any account other than the owner.

     */

    modifier onlyOwner() {

        require(_owner == msg.sender, "ERR_NOT_CONTROLLER");

        _;

    }



    // Function declarations



    /**

     * @dev Initializes the contract setting the deployer as the initial owner.

     */

    constructor() internal {

        _owner = msg.sender;

    }



    /**

     * @notice Transfers ownership of the contract to a new account (`newOwner`).

     *         Can only be called by the current owner

     * @dev external for gas optimization

     * @param newOwner - address of new owner

     */

    function setController(address newOwner) external onlyOwner {

        require(newOwner != address(0), "ERR_ZERO_ADDRESS");



        emit OwnershipTransferred(_owner, newOwner);



        _owner = newOwner;

    }



    /**

     * @notice Returns the address of the current owner

     * @dev external for gas optimization

     * @return address - of the owner (AKA controller)

     */

    function getController() external view returns (address) {

        return _owner;

    }

}



/**

 * @author Balancer Labs

 * @title Manage Configurable Rights for the smart pool

 *      canPauseSwapping - can setPublicSwap back to false after turning it on

 *                         by default, it is off on initialization and can only be turned on

 *      canChangeSwapFee - can setSwapFee after initialization (by default, it is fixed at create time)

 *      canChangeWeights - can bind new token weights (allowed by default in base pool)

 *      canAddRemoveTokens - can bind/unbind tokens (allowed by default in base pool)

 *      canWhitelistLPs - can limit liquidity providers to a given set of addresses

 *      canChangeCap - can change the BSP cap (max # of pool tokens)

 */

library RightsManager {

    // Type declarations



    enum Permissions {

        PAUSE_SWAPPING,

        CHANGE_SWAP_FEE,

        CHANGE_WEIGHTS,

        ADD_REMOVE_TOKENS,

        WHITELIST_LPS,

        CHANGE_CAP

    }



    struct Rights {

        bool canPauseSwapping;

        bool canChangeSwapFee;

        bool canChangeWeights;

        bool canAddRemoveTokens;

        bool canWhitelistLPs;

        bool canChangeCap;

    }



    // State variables (can only be constants in a library)

    bool public constant DEFAULT_CAN_PAUSE_SWAPPING = false;

    bool public constant DEFAULT_CAN_CHANGE_SWAP_FEE = true;

    bool public constant DEFAULT_CAN_CHANGE_WEIGHTS = true;

    bool public constant DEFAULT_CAN_ADD_REMOVE_TOKENS = false;

    bool public constant DEFAULT_CAN_WHITELIST_LPS = false;

    bool public constant DEFAULT_CAN_CHANGE_CAP = false;



    // Functions



    /**

     * @notice create a struct from an array (or return defaults)

     * @dev If you pass an empty array, it will construct it using the defaults

     * @param a - array input

     * @return Rights struct

     */



    function constructRights(bool[] calldata a)

        external

        pure

        returns (Rights memory)

    {

        if (a.length == 0) {

            return

                Rights(

                    DEFAULT_CAN_PAUSE_SWAPPING,

                    DEFAULT_CAN_CHANGE_SWAP_FEE,

                    DEFAULT_CAN_CHANGE_WEIGHTS,

                    DEFAULT_CAN_ADD_REMOVE_TOKENS,

                    DEFAULT_CAN_WHITELIST_LPS,

                    DEFAULT_CAN_CHANGE_CAP

                );

        } else {

            return Rights(a[0], a[1], a[2], a[3], a[4], a[5]);

        }

    }



    /**

     * @notice Convert rights struct to an array (e.g., for events, GUI)

     * @dev avoids multiple calls to hasPermission

     * @param rights - the rights struct to convert

     * @return boolean array containing the rights settings

     */

    function convertRights(Rights calldata rights)

        external

        pure

        returns (bool[] memory)

    {

        bool[] memory result = new bool[](6);



        result[0] = rights.canPauseSwapping;

        result[1] = rights.canChangeSwapFee;

        result[2] = rights.canChangeWeights;

        result[3] = rights.canAddRemoveTokens;

        result[4] = rights.canWhitelistLPs;

        result[5] = rights.canChangeCap;



        return result;

    }



    // Though it is actually simple, the number of branches triggers code-complexity

    /* solhint-disable code-complexity */



    /**

     * @notice Externally check permissions using the Enum

     * @param self - Rights struct containing the permissions

     * @param permission - The permission to check

     * @return Boolean true if it has the permission

     */

    function hasPermission(Rights calldata self, Permissions permission)

        external

        pure

        returns (bool)

    {

        if (Permissions.PAUSE_SWAPPING == permission) {

            return self.canPauseSwapping;

        } else if (Permissions.CHANGE_SWAP_FEE == permission) {

            return self.canChangeSwapFee;

        } else if (Permissions.CHANGE_WEIGHTS == permission) {

            return self.canChangeWeights;

        } else if (Permissions.ADD_REMOVE_TOKENS == permission) {

            return self.canAddRemoveTokens;

        } else if (Permissions.WHITELIST_LPS == permission) {

            return self.canWhitelistLPs;

        } else if (Permissions.CHANGE_CAP == permission) {

            return self.canChangeCap;

        }

    }



    /* solhint-enable code-complexity */

}



// File: contracts/balancer/interfaces/IConfigurableRightsPool.sol



pragma solidity 0.6.12;



// Interface declarations



// Introduce to avoid circularity (otherwise, the CRP and SmartPoolManager include each other)

// Removing circularity allows flattener tools to work, which enables Etherscan verification

interface IConfigurableRightsPool {

    function mintPoolShareFromLib(uint256 amount) external;



    function pushPoolShareFromLib(address to, uint256 amount) external;



    function pullPoolShareFromLib(address from, uint256 amount) external;



    function burnPoolShareFromLib(uint256 amount) external;



    function totalSupply() external view returns (uint256);



    function getController() external view returns (address);

}



/**

 * @author PieDAO (ported to Balancer Labs)

 * @title SafeApprove - set approval for tokens that require 0 prior approval

 * @dev Perhaps to address the known ERC20 race condition issue

 *      See https://github.com/crytic/not-so-smart-contracts/tree/master/race_condition

 *      Some tokens - notably KNC - only allow approvals to be increased from 0

 */

library SafeApprove {

    /**

     * @notice handle approvals of tokens that require approving from a base of 0

     * @param token - the token we're approving

     * @param spender - entity the owner (sender) is approving to spend his tokens

     * @param amount - number of tokens being approved

     */

    function safeApprove(

        IERC20 token,

        address spender,

        uint256 amount

    ) internal returns (bool) {

        uint256 currentAllowance = token.allowance(address(this), spender);



        // Do nothing if allowance is already set to this value

        if (currentAllowance == amount) {

            return true;

        }



        // If approval is not zero reset it to zero first

        if (currentAllowance != 0) {

            return token.approve(spender, 0);

        }



        // do the actual approval

        return token.approve(spender, amount);

    }

}



/**

 * @author Balancer Labs

 * @title Factor out the weight updates

 */

library SmartPoolManager {

    // Type declarations



    struct NewTokenParams {

        address addr;

        bool isCommitted;

        uint256 commitBlock;

        uint256 denorm;

        uint256 balance;

    }



    // For blockwise, automated weight updates

    // Move weights linearly from startWeights to endWeights,

    // between startBlock and endBlock

    struct GradualUpdateParams {

        uint256 startBlock;

        uint256 endBlock;

        uint256[] startWeights;

        uint256[] endWeights;

    }



    // updateWeight and pokeWeights are unavoidably long

    /* solhint-disable function-max-lines */



    /**

     * @notice Update the weight of an existing token

     * @dev Refactored to library to make CRPFactory deployable

     * @param self - ConfigurableRightsPool instance calling the library

     * @param bPool - Core BPool the CRP is wrapping

     * @param token - token to be reweighted

     * @param newWeight - new weight of the token

     */

    function updateWeight(

        IConfigurableRightsPool self,

        IBPool bPool,

        address token,

        uint256 newWeight

    ) external {

        require(newWeight >= BalancerConstants.MIN_WEIGHT, "ERR_MIN_WEIGHT");

        require(newWeight <= BalancerConstants.MAX_WEIGHT, "ERR_MAX_WEIGHT");



        uint256 currentWeight = bPool.getDenormalizedWeight(token);

        // Save gas; return immediately on NOOP

        if (currentWeight == newWeight) {

            return;

        }



        uint256 currentBalance = bPool.getBalance(token);

        uint256 totalSupply = self.totalSupply();

        uint256 totalWeight = bPool.getTotalDenormalizedWeight();

        uint256 poolShares;

        uint256 deltaBalance;

        uint256 deltaWeight;

        uint256 newBalance;



        if (newWeight < currentWeight) {

            // This means the controller will withdraw tokens to keep price

            // So they need to redeem PCTokens

            deltaWeight = BalancerSafeMath.bsub(currentWeight, newWeight);



            // poolShares = totalSupply * (deltaWeight / totalWeight)

            poolShares = BalancerSafeMath.bmul(

                totalSupply,

                BalancerSafeMath.bdiv(deltaWeight, totalWeight)

            );



            // deltaBalance = currentBalance * (deltaWeight / currentWeight)

            deltaBalance = BalancerSafeMath.bmul(

                currentBalance,

                BalancerSafeMath.bdiv(deltaWeight, currentWeight)

            );



            // New balance cannot be lower than MIN_BALANCE

            newBalance = BalancerSafeMath.bsub(currentBalance, deltaBalance);



            require(

                newBalance >= BalancerConstants.MIN_BALANCE,

                "ERR_MIN_BALANCE"

            );



            // First get the tokens from this contract (Pool Controller) to msg.sender

            bPool.rebind(token, newBalance, newWeight);



            // Now with the tokens this contract can send them to msg.sender

            bool xfer = IERC20(token).transfer(msg.sender, deltaBalance);

            require(xfer, "ERR_ERC20_FALSE");



            self.pullPoolShareFromLib(msg.sender, poolShares);

            self.burnPoolShareFromLib(poolShares);

        } else {

            // This means the controller will deposit tokens to keep the price.

            // They will be minted and given PCTokens

            deltaWeight = BalancerSafeMath.bsub(newWeight, currentWeight);



            require(

                BalancerSafeMath.badd(totalWeight, deltaWeight) <=

                    BalancerConstants.MAX_TOTAL_WEIGHT,

                "ERR_MAX_TOTAL_WEIGHT"

            );



            // poolShares = totalSupply * (deltaWeight / totalWeight)

            poolShares = BalancerSafeMath.bmul(

                totalSupply,

                BalancerSafeMath.bdiv(deltaWeight, totalWeight)

            );

            // deltaBalance = currentBalance * (deltaWeight / currentWeight)

            deltaBalance = BalancerSafeMath.bmul(

                currentBalance,

                BalancerSafeMath.bdiv(deltaWeight, currentWeight)

            );



            // First gets the tokens from msg.sender to this contract (Pool Controller)

            bool xfer = IERC20(token).transferFrom(

                msg.sender,

                address(this),

                deltaBalance

            );

            require(xfer, "ERR_ERC20_FALSE");



            // Now with the tokens this contract can bind them to the pool it controls

            bPool.rebind(

                token,

                BalancerSafeMath.badd(currentBalance, deltaBalance),

                newWeight

            );



            self.mintPoolShareFromLib(poolShares);

            self.pushPoolShareFromLib(msg.sender, poolShares);

        }

    }



    /**

     * @notice External function called to make the contract update weights according to plan

     * @param bPool - Core BPool the CRP is wrapping

     * @param gradualUpdate - gradual update parameters from the CRP

     */

    function pokeWeights(

        IBPool bPool,

        GradualUpdateParams storage gradualUpdate

    ) external {

        // Do nothing if we call this when there is no update plan

        if (gradualUpdate.startBlock == 0) {

            return;

        }



        // Error to call it before the start of the plan

        require(block.number >= gradualUpdate.startBlock, "ERR_CANT_POKE_YET");

        // Proposed error message improvement

        // require(block.number >= startBlock, "ERR_NO_HOKEY_POKEY");



        // This allows for pokes after endBlock that get weights to endWeights

        // Get the current block (or the endBlock, if we're already past the end)

        uint256 currentBlock;

        if (block.number > gradualUpdate.endBlock) {

            currentBlock = gradualUpdate.endBlock;

        } else {

            currentBlock = block.number;

        }



        uint256 blockPeriod = BalancerSafeMath.bsub(

            gradualUpdate.endBlock,

            gradualUpdate.startBlock

        );

        uint256 blocksElapsed = BalancerSafeMath.bsub(

            currentBlock,

            gradualUpdate.startBlock

        );

        uint256 weightDelta;

        uint256 deltaPerBlock;

        uint256 newWeight;



        address[] memory tokens = bPool.getCurrentTokens();



        // This loop contains external calls

        // External calls are to math libraries or the underlying pool, so low risk

        for (uint256 i = 0; i < tokens.length; i++) {

            // Make sure it does nothing if the new and old weights are the same (saves gas)

            // It's a degenerate case if they're *all* the same, but you certainly could have

            // a plan where you only change some of the weights in the set

            if (gradualUpdate.startWeights[i] != gradualUpdate.endWeights[i]) {

                if (

                    gradualUpdate.endWeights[i] < gradualUpdate.startWeights[i]

                ) {

                    // We are decreasing the weight



                    // First get the total weight delta

                    weightDelta = BalancerSafeMath.bsub(

                        gradualUpdate.startWeights[i],

                        gradualUpdate.endWeights[i]

                    );

                    // And the amount it should change per block = total change/number of blocks in the period

                    deltaPerBlock = BalancerSafeMath.bdiv(

                        weightDelta,

                        blockPeriod

                    );

                    //deltaPerBlock = bdivx(weightDelta, blockPeriod);



                    // newWeight = startWeight - (blocksElapsed * deltaPerBlock)

                    newWeight = BalancerSafeMath.bsub(

                        gradualUpdate.startWeights[i],

                        BalancerSafeMath.bmul(blocksElapsed, deltaPerBlock)

                    );

                } else {

                    // We are increasing the weight



                    // First get the total weight delta

                    weightDelta = BalancerSafeMath.bsub(

                        gradualUpdate.endWeights[i],

                        gradualUpdate.startWeights[i]

                    );

                    // And the amount it should change per block = total change/number of blocks in the period

                    deltaPerBlock = BalancerSafeMath.bdiv(

                        weightDelta,

                        blockPeriod

                    );

                    //deltaPerBlock = bdivx(weightDelta, blockPeriod);



                    // newWeight = startWeight + (blocksElapsed * deltaPerBlock)

                    newWeight = BalancerSafeMath.badd(

                        gradualUpdate.startWeights[i],

                        BalancerSafeMath.bmul(blocksElapsed, deltaPerBlock)

                    );

                }



                uint256 bal = bPool.getBalance(tokens[i]);



                bPool.rebind(tokens[i], bal, newWeight);

            }

        }



        // Reset to allow add/remove tokens, or manual weight updates

        if (block.number >= gradualUpdate.endBlock) {

            gradualUpdate.startBlock = 0;

        }

    }



    /* solhint-enable function-max-lines */



    /**

     * @notice Schedule (commit) a token to be added; must call applyAddToken after a fixed

     *         number of blocks to actually add the token

     * @param bPool - Core BPool the CRP is wrapping

     * @param token - the token to be added

     * @param balance - how much to be added

     * @param denormalizedWeight - the desired token weight

     * @param newToken - NewTokenParams struct used to hold the token data (in CRP storage)

     */

    function commitAddToken(

        IBPool bPool,

        address token,

        uint256 balance,

        uint256 denormalizedWeight,

        NewTokenParams storage newToken

    ) external {

        require(!bPool.isBound(token), "ERR_IS_BOUND");



        require(

            denormalizedWeight <= BalancerConstants.MAX_WEIGHT,

            "ERR_WEIGHT_ABOVE_MAX"

        );

        require(

            denormalizedWeight >= BalancerConstants.MIN_WEIGHT,

            "ERR_WEIGHT_BELOW_MIN"

        );

        require(

            BalancerSafeMath.badd(

                bPool.getTotalDenormalizedWeight(),

                denormalizedWeight

            ) <= BalancerConstants.MAX_TOTAL_WEIGHT,

            "ERR_MAX_TOTAL_WEIGHT"

        );

        require(

            balance >= BalancerConstants.MIN_BALANCE,

            "ERR_BALANCE_BELOW_MIN"

        );



        newToken.addr = token;

        newToken.balance = balance;

        newToken.denorm = denormalizedWeight;

        newToken.commitBlock = block.number;

        newToken.isCommitted = true;

    }



    /**

     * @notice Add the token previously committed (in commitAddToken) to the pool

     * @param self - ConfigurableRightsPool instance calling the library

     * @param bPool - Core BPool the CRP is wrapping

     * @param addTokenTimeLockInBlocks -  Wait time between committing and applying a new token

     * @param newToken - NewTokenParams struct used to hold the token data (in CRP storage)

     */

    function applyAddToken(

        IConfigurableRightsPool self,

        IBPool bPool,

        uint256 addTokenTimeLockInBlocks,

        NewTokenParams storage newToken

    ) external {

        require(newToken.isCommitted, "ERR_NO_TOKEN_COMMIT");

        require(

            BalancerSafeMath.bsub(block.number, newToken.commitBlock) >=

                addTokenTimeLockInBlocks,

            "ERR_TIMELOCK_STILL_COUNTING"

        );



        uint256 totalSupply = self.totalSupply();



        // poolShares = totalSupply * newTokenWeight / totalWeight

        uint256 poolShares = BalancerSafeMath.bdiv(

            BalancerSafeMath.bmul(totalSupply, newToken.denorm),

            bPool.getTotalDenormalizedWeight()

        );



        // Clear this to allow adding more tokens

        newToken.isCommitted = false;



        // First gets the tokens from msg.sender to this contract (Pool Controller)

        bool returnValue = IERC20(newToken.addr).transferFrom(

            self.getController(),

            address(self),

            newToken.balance

        );

        require(returnValue, "ERR_ERC20_FALSE");



        // Now with the tokens this contract can bind them to the pool it controls

        // Approves bPool to pull from this controller

        // Approve unlimited, same as when creating the pool, so they can join pools later

        returnValue = SafeApprove.safeApprove(

            IERC20(newToken.addr),

            address(bPool),

            BalancerConstants.MAX_UINT

        );

        require(returnValue, "ERR_ERC20_FALSE");



        bPool.bind(newToken.addr, newToken.balance, newToken.denorm);



        self.mintPoolShareFromLib(poolShares);

        self.pushPoolShareFromLib(msg.sender, poolShares);

    }



    /**

     * @notice Remove a token from the pool

     * @dev Logic in the CRP controls when ths can be called. There are two related permissions:

     *      AddRemoveTokens - which allows removing down to the underlying BPool limit of two

     *      RemoveAllTokens - which allows completely draining the pool by removing all tokens

     *                        This can result in a non-viable pool with 0 or 1 tokens (by design),

     *                        meaning all swapping or binding operations would fail in this state

     * @param self - ConfigurableRightsPool instance calling the library

     * @param bPool - Core BPool the CRP is wrapping

     * @param token - token to remove

     */

    function removeToken(

        IConfigurableRightsPool self,

        IBPool bPool,

        address token

    ) external {

        uint256 totalSupply = self.totalSupply();



        // poolShares = totalSupply * tokenWeight / totalWeight

        uint256 poolShares = BalancerSafeMath.bdiv(

            BalancerSafeMath.bmul(

                totalSupply,

                bPool.getDenormalizedWeight(token)

            ),

            bPool.getTotalDenormalizedWeight()

        );



        // this is what will be unbound from the pool

        // Have to get it before unbinding

        uint256 balance = bPool.getBalance(token);



        // Unbind and get the tokens out of balancer pool

        bPool.unbind(token);



        // Now with the tokens this contract can send them to msg.sender

        bool xfer = IERC20(token).transfer(self.getController(), balance);

        require(xfer, "ERR_ERC20_FALSE");



        self.pullPoolShareFromLib(self.getController(), poolShares);

        self.burnPoolShareFromLib(poolShares);

    }



    /**

     * @notice Non ERC20-conforming tokens are problematic; don't allow them in pools

     * @dev Will revert if invalid

     * @param token - The prospective token to verify

     */

    function verifyTokenCompliance(address token) external {

        verifyTokenComplianceInternal(token);

    }



    /**

     * @notice Non ERC20-conforming tokens are problematic; don't allow them in pools

     * @dev Will revert if invalid - overloaded to save space in the main contract

     * @param tokens - The prospective tokens to verify

     */

    function verifyTokenCompliance(address[] calldata tokens) external {

        for (uint256 i = 0; i < tokens.length; i++) {

            verifyTokenComplianceInternal(tokens[i]);

        }

    }



    /**

     * @notice Update weights in a predetermined way, between startBlock and endBlock,

     *         through external cals to pokeWeights

     * @param bPool - Core BPool the CRP is wrapping

     * @param newWeights - final weights we want to get to

     * @param startBlock - when weights should start to change

     * @param endBlock - when weights will be at their final values

     * @param minimumWeightChangeBlockPeriod - needed to validate the block period

     */

    function updateWeightsGradually(

        IBPool bPool,

        GradualUpdateParams storage gradualUpdate,

        uint256[] calldata newWeights,

        uint256 startBlock,

        uint256 endBlock,

        uint256 minimumWeightChangeBlockPeriod

    ) external {

        require(block.number < endBlock, "ERR_GRADUAL_UPDATE_TIME_TRAVEL");



        if (block.number > startBlock) {

            // This means the weight update should start ASAP

            // Moving the start block up prevents a big jump/discontinuity in the weights

            gradualUpdate.startBlock = block.number;

        } else {

            gradualUpdate.startBlock = startBlock;

        }



        // Enforce a minimum time over which to make the changes

        // The also prevents endBlock <= startBlock

        require(

            BalancerSafeMath.bsub(endBlock, gradualUpdate.startBlock) >=

                minimumWeightChangeBlockPeriod,

            "ERR_WEIGHT_CHANGE_TIME_BELOW_MIN"

        );



        address[] memory tokens = bPool.getCurrentTokens();



        // Must specify weights for all tokens

        require(

            newWeights.length == tokens.length,

            "ERR_START_WEIGHTS_MISMATCH"

        );



        uint256 weightsSum = 0;

        gradualUpdate.startWeights = new uint256[](tokens.length);



        // Check that endWeights are valid now to avoid reverting in a future pokeWeights call

        //

        // This loop contains external calls

        // External calls are to math libraries or the underlying pool, so low risk

        for (uint256 i = 0; i < tokens.length; i++) {

            require(

                newWeights[i] <= BalancerConstants.MAX_WEIGHT,

                "ERR_WEIGHT_ABOVE_MAX"

            );

            require(

                newWeights[i] >= BalancerConstants.MIN_WEIGHT,

                "ERR_WEIGHT_BELOW_MIN"

            );



            weightsSum = BalancerSafeMath.badd(weightsSum, newWeights[i]);

            gradualUpdate.startWeights[i] = bPool.getDenormalizedWeight(

                tokens[i]

            );

        }

        require(

            weightsSum <= BalancerConstants.MAX_TOTAL_WEIGHT,

            "ERR_MAX_TOTAL_WEIGHT"

        );



        gradualUpdate.endBlock = endBlock;

        gradualUpdate.endWeights = newWeights;

    }



    /**

     * @notice Join a pool

     * @param self - ConfigurableRightsPool instance calling the library

     * @param bPool - Core BPool the CRP is wrapping

     * @param poolAmountOut - number of pool tokens to receive

     * @param maxAmountsIn - Max amount of asset tokens to spend

     * @return actualAmountsIn - calculated values of the tokens to pull in

     */

    function joinPool(

        IConfigurableRightsPool self,

        IBPool bPool,

        uint256 poolAmountOut,

        uint256[] calldata maxAmountsIn

    ) external view returns (uint256[] memory actualAmountsIn) {

        address[] memory tokens = bPool.getCurrentTokens();



        require(maxAmountsIn.length == tokens.length, "ERR_AMOUNTS_MISMATCH");



        uint256 poolTotal = self.totalSupply();

        // Subtract  1 to ensure any rounding errors favor the pool

        uint256 ratio = BalancerSafeMath.bdiv(

            poolAmountOut,

            BalancerSafeMath.bsub(poolTotal, 1)

        );



        require(ratio != 0, "ERR_MATH_APPROX");



        // We know the length of the array; initialize it, and fill it below

        // Cannot do "push" in memory

        actualAmountsIn = new uint256[](tokens.length);



        // This loop contains external calls

        // External calls are to math libraries or the underlying pool, so low risk

        for (uint256 i = 0; i < tokens.length; i++) {

            address t = tokens[i];

            uint256 bal = bPool.getBalance(t);

            // Add 1 to ensure any rounding errors favor the pool

            uint256 tokenAmountIn = BalancerSafeMath.bmul(

                ratio,

                BalancerSafeMath.badd(bal, 1)

            );



            require(tokenAmountIn != 0, "ERR_MATH_APPROX");

            require(tokenAmountIn <= maxAmountsIn[i], "ERR_LIMIT_IN");



            actualAmountsIn[i] = tokenAmountIn;

        }

    }



    /**

     * @notice Exit a pool - redeem pool tokens for underlying assets

     * @param self - ConfigurableRightsPool instance calling the library

     * @param bPool - Core BPool the CRP is wrapping

     * @param poolAmountIn - amount of pool tokens to redeem

     * @param minAmountsOut - minimum amount of asset tokens to receive

     * @return exitFee - calculated exit fee

     * @return pAiAfterExitFee - final amount in (after accounting for exit fee)

     * @return actualAmountsOut - calculated amounts of each token to pull

     */

    function exitPool(

        IConfigurableRightsPool self,

        IBPool bPool,

        uint256 poolAmountIn,

        uint256[] calldata minAmountsOut

    )

        external

        view

        returns (

            uint256 exitFee,

            uint256 pAiAfterExitFee,

            uint256[] memory actualAmountsOut

        )

    {

        address[] memory tokens = bPool.getCurrentTokens();



        require(minAmountsOut.length == tokens.length, "ERR_AMOUNTS_MISMATCH");



        uint256 poolTotal = self.totalSupply();



        // Calculate exit fee and the final amount in

        exitFee = BalancerSafeMath.bmul(

            poolAmountIn,

            BalancerConstants.EXIT_FEE

        );

        pAiAfterExitFee = BalancerSafeMath.bsub(poolAmountIn, exitFee);



        uint256 ratio = BalancerSafeMath.bdiv(

            pAiAfterExitFee,

            BalancerSafeMath.badd(poolTotal, 1)

        );



        require(ratio != 0, "ERR_MATH_APPROX");



        actualAmountsOut = new uint256[](tokens.length);



        // This loop contains external calls

        // External calls are to math libraries or the underlying pool, so low risk

        for (uint256 i = 0; i < tokens.length; i++) {

            address t = tokens[i];

            uint256 bal = bPool.getBalance(t);

            // Subtract 1 to ensure any rounding errors favor the pool

            uint256 tokenAmountOut = BalancerSafeMath.bmul(

                ratio,

                BalancerSafeMath.bsub(bal, 1)

            );



            require(tokenAmountOut != 0, "ERR_MATH_APPROX");

            require(tokenAmountOut >= minAmountsOut[i], "ERR_LIMIT_OUT");



            actualAmountsOut[i] = tokenAmountOut;

        }

    }



    /**

     * @notice Join by swapping a fixed amount of an external token in (must be present in the pool)

     *         System calculates the pool token amount

     * @param self - ConfigurableRightsPool instance calling the library

     * @param bPool - Core BPool the CRP is wrapping

     * @param tokenIn - which token we're transferring in

     * @param tokenAmountIn - amount of deposit

     * @param minPoolAmountOut - minimum of pool tokens to receive

     * @return poolAmountOut - amount of pool tokens minted and transferred

     */

    function joinswapExternAmountIn(

        IConfigurableRightsPool self,

        IBPool bPool,

        address tokenIn,

        uint256 tokenAmountIn,

        uint256 minPoolAmountOut

    ) external view returns (uint256 poolAmountOut) {

        require(bPool.isBound(tokenIn), "ERR_NOT_BOUND");

        require(

            tokenAmountIn <=

                BalancerSafeMath.bmul(

                    bPool.getBalance(tokenIn),

                    BalancerConstants.MAX_IN_RATIO

                ),

            "ERR_MAX_IN_RATIO"

        );



        poolAmountOut = bPool.calcPoolOutGivenSingleIn(

            bPool.getBalance(tokenIn),

            bPool.getDenormalizedWeight(tokenIn),

            self.totalSupply(),

            bPool.getTotalDenormalizedWeight(),

            tokenAmountIn,

            bPool.getSwapFee()

        );



        require(poolAmountOut >= minPoolAmountOut, "ERR_LIMIT_OUT");

    }



    /**

     * @notice Join by swapping an external token in (must be present in the pool)

     *         To receive an exact amount of pool tokens out. System calculates the deposit amount

     * @param self - ConfigurableRightsPool instance calling the library

     * @param bPool - Core BPool the CRP is wrapping

     * @param tokenIn - which token we're transferring in (system calculates amount required)

     * @param poolAmountOut - amount of pool tokens to be received

     * @param maxAmountIn - Maximum asset tokens that can be pulled to pay for the pool tokens

     * @return tokenAmountIn - amount of asset tokens transferred in to purchase the pool tokens

     */

    function joinswapPoolAmountOut(

        IConfigurableRightsPool self,

        IBPool bPool,

        address tokenIn,

        uint256 poolAmountOut,

        uint256 maxAmountIn

    ) external view returns (uint256 tokenAmountIn) {

        require(bPool.isBound(tokenIn), "ERR_NOT_BOUND");



        tokenAmountIn = bPool.calcSingleInGivenPoolOut(

            bPool.getBalance(tokenIn),

            bPool.getDenormalizedWeight(tokenIn),

            self.totalSupply(),

            bPool.getTotalDenormalizedWeight(),

            poolAmountOut,

            bPool.getSwapFee()

        );



        require(tokenAmountIn != 0, "ERR_MATH_APPROX");

        require(tokenAmountIn <= maxAmountIn, "ERR_LIMIT_IN");



        require(

            tokenAmountIn <=

                BalancerSafeMath.bmul(

                    bPool.getBalance(tokenIn),

                    BalancerConstants.MAX_IN_RATIO

                ),

            "ERR_MAX_IN_RATIO"

        );

    }



    /**

     * @notice Exit a pool - redeem a specific number of pool tokens for an underlying asset

     *         Asset must be present in the pool, and will incur an EXIT_FEE (if set to non-zero)

     * @param self - ConfigurableRightsPool instance calling the library

     * @param bPool - Core BPool the CRP is wrapping

     * @param tokenOut - which token the caller wants to receive

     * @param poolAmountIn - amount of pool tokens to redeem

     * @param minAmountOut - minimum asset tokens to receive

     * @return exitFee - calculated exit fee

     * @return tokenAmountOut - amount of asset tokens returned

     */

    function exitswapPoolAmountIn(

        IConfigurableRightsPool self,

        IBPool bPool,

        address tokenOut,

        uint256 poolAmountIn,

        uint256 minAmountOut

    ) external view returns (uint256 exitFee, uint256 tokenAmountOut) {

        require(bPool.isBound(tokenOut), "ERR_NOT_BOUND");



        tokenAmountOut = bPool.calcSingleOutGivenPoolIn(

            bPool.getBalance(tokenOut),

            bPool.getDenormalizedWeight(tokenOut),

            self.totalSupply(),

            bPool.getTotalDenormalizedWeight(),

            poolAmountIn,

            bPool.getSwapFee()

        );



        require(tokenAmountOut >= minAmountOut, "ERR_LIMIT_OUT");

        require(

            tokenAmountOut <=

                BalancerSafeMath.bmul(

                    bPool.getBalance(tokenOut),

                    BalancerConstants.MAX_OUT_RATIO

                ),

            "ERR_MAX_OUT_RATIO"

        );



        exitFee = BalancerSafeMath.bmul(

            poolAmountIn,

            BalancerConstants.EXIT_FEE

        );

    }



    /**

     * @notice Exit a pool - redeem pool tokens for a specific amount of underlying assets

     *         Asset must be present in the pool

     * @param self - ConfigurableRightsPool instance calling the library

     * @param bPool - Core BPool the CRP is wrapping

     * @param tokenOut - which token the caller wants to receive

     * @param tokenAmountOut - amount of underlying asset tokens to receive

     * @param maxPoolAmountIn - maximum pool tokens to be redeemed

     * @return exitFee - calculated exit fee

     * @return poolAmountIn - amount of pool tokens redeemed

     */

    function exitswapExternAmountOut(

        IConfigurableRightsPool self,

        IBPool bPool,

        address tokenOut,

        uint256 tokenAmountOut,

        uint256 maxPoolAmountIn

    ) external view returns (uint256 exitFee, uint256 poolAmountIn) {

        require(bPool.isBound(tokenOut), "ERR_NOT_BOUND");

        require(

            tokenAmountOut <=

                BalancerSafeMath.bmul(

                    bPool.getBalance(tokenOut),

                    BalancerConstants.MAX_OUT_RATIO

                ),

            "ERR_MAX_OUT_RATIO"

        );

        poolAmountIn = bPool.calcPoolInGivenSingleOut(

            bPool.getBalance(tokenOut),

            bPool.getDenormalizedWeight(tokenOut),

            self.totalSupply(),

            bPool.getTotalDenormalizedWeight(),

            tokenAmountOut,

            bPool.getSwapFee()

        );



        require(poolAmountIn != 0, "ERR_MATH_APPROX");

        require(poolAmountIn <= maxPoolAmountIn, "ERR_LIMIT_IN");



        exitFee = BalancerSafeMath.bmul(

            poolAmountIn,

            BalancerConstants.EXIT_FEE

        );

    }



    // Internal functions



    // Check for zero transfer, and make sure it returns true to returnValue

    function verifyTokenComplianceInternal(address token) internal {

        bool returnValue = IERC20(token).transfer(msg.sender, 0);

        require(returnValue, "ERR_NONCONFORMING_TOKEN");

    }

}



// Interfaces



// Libraries



// Contracts



/**

 * @author Balancer Labs

 * @title Smart Pool with customizable features

 * @notice PCToken is the "Balancer Smart Pool" token (transferred upon finalization)

 * @dev Rights are defined as follows (index values into the array)

 *      0: canPauseSwapping - can setPublicSwap back to false after turning it on

 *                            by default, it is off on initialization and can only be turned on

 *      1: canChangeSwapFee - can setSwapFee after initialization (by default, it is fixed at create time)

 *      2: canChangeWeights - can bind new token weights (allowed by default in base pool)

 *      3: canAddRemoveTokens - can bind/unbind tokens (allowed by default in base pool)

 *      4: canWhitelistLPs - can restrict LPs to a whitelist

 *      5: canChangeCap - can change the BSP cap (max # of pool tokens)

 *

 * Note that functions called on bPool and bFactory may look like internal calls,

 *   but since they are contracts accessed through an interface, they are really external.

 * To make this explicit, we could write "IBPool(address(bPool)).function()" everywhere,

 *   instead of "bPool.function()".

 */

contract ConfigurableRightsPool is

    PCToken,

    BalancerOwnable,

    BalancerReentrancyGuard

{

    using BalancerSafeMath for uint256;

    using SafeApprove for IERC20;



    // Type declarations



    struct PoolParams {

        // Balancer Pool Token (representing shares of the pool)

        string poolTokenSymbol;

        string poolTokenName;

        // Tokens inside the Pool

        address[] constituentTokens;

        uint256[] tokenBalances;

        uint256[] tokenWeights;

        uint256 swapFee;

    }



    // State variables



    IBFactory public bFactory;

    IBPool public bPool;



    // Struct holding the rights configuration

    RightsManager.Rights public rights;



    // Hold the parameters used in updateWeightsGradually

    SmartPoolManager.GradualUpdateParams public gradualUpdate;



    // This is for adding a new (currently unbound) token to the pool

    // It's a two-step process: commitAddToken(), then applyAddToken()

    SmartPoolManager.NewTokenParams public newToken;



    // Fee is initialized on creation, and can be changed if permission is set

    // Only needed for temporary storage between construction and createPool

    // Thereafter, the swap fee should always be read from the underlying pool

    uint256 private _initialSwapFee;



    // Store the list of tokens in the pool, and balances

    // NOTE that the token list is *only* used to store the pool tokens between

    //   construction and createPool - thereafter, use the underlying BPool's list

    //   (avoids synchronization issues)

    address[] private _initialTokens;

    uint256[] private _initialBalances;



    // Enforce a minimum time between the start and end blocks

    uint256 public minimumWeightChangeBlockPeriod;

    // Enforce a mandatory wait time between updates

    // This is also the wait time between committing and applying a new token

    uint256 public addTokenTimeLockInBlocks;



    // Whitelist of LPs (if configured)

    mapping(address => bool) private _liquidityProviderWhitelist;



    // Cap on the pool size (i.e., # of tokens minted when joining)

    // Limits the risk of experimental pools; failsafe/backup for fixed-size pools

    uint256 public bspCap;



    // Event declarations



    // Anonymous logger event - can only be filtered by contract address



    event LogCall(bytes4 indexed sig, address indexed caller, bytes data);



    event LogJoin(

        address indexed caller,

        address indexed tokenIn,

        uint256 tokenAmountIn

    );



    event LogExit(

        address indexed caller,

        address indexed tokenOut,

        uint256 tokenAmountOut

    );



    event CapChanged(address indexed caller, uint256 oldCap, uint256 newCap);



    event NewTokenCommitted(

        address indexed token,

        address indexed pool,

        address indexed caller

    );



    // Modifiers



    modifier logs() {

        emit LogCall(msg.sig, msg.sender, msg.data);

        _;

    }



    // Mark functions that require delegation to the underlying Pool

    modifier needsBPool() {

        require(address(bPool) != address(0), "ERR_NOT_CREATED");

        _;

    }



    modifier lockUnderlyingPool() {

        // Turn off swapping on the underlying pool during joins

        // Otherwise tokens with callbacks would enable attacks involving simultaneous swaps and joins

        bool origSwapState = bPool.isPublicSwap();

        bPool.setPublicSwap(false);

        _;

        bPool.setPublicSwap(origSwapState);

    }



    // Default values for these variables (used only in updateWeightsGradually), set in the constructor

    // Pools without permission to update weights cannot use them anyway, and should call

    //   the default createPool() function.

    // To override these defaults, pass them into the overloaded createPool()

    // Period is in blocks; 500 blocks ~ 2 hours; 90,000 blocks ~ 2 weeks

    uint256 public constant DEFAULT_MIN_WEIGHT_CHANGE_BLOCK_PERIOD = 90000;

    uint256 public constant DEFAULT_ADD_TOKEN_TIME_LOCK_IN_BLOCKS = 500;



    // Function declarations



    /**

     * @notice Construct a new Configurable Rights Pool (wrapper around BPool)

     * @dev _initialTokens and _swapFee are only used for temporary storage between construction

     *      and create pool, and should not be used thereafter! _initialTokens is destroyed in

     *      createPool to prevent this, and _swapFee is kept in sync (defensively), but

     *      should never be used except in this constructor and createPool()

     * @param factoryAddress - the BPoolFactory used to create the underlying pool

     * @param poolParams - struct containing pool parameters

     * @param rightsStruct - Set of permissions we are assigning to this smart pool

     */

    constructor(

        address factoryAddress,

        PoolParams memory poolParams,

        RightsManager.Rights memory rightsStruct

    ) public PCToken(poolParams.poolTokenSymbol, poolParams.poolTokenName) {

        // We don't have a pool yet; check now or it will fail later (in order of likelihood to fail)

        // (and be unrecoverable if they don't have permission set to change it)

        // Most likely to fail, so check first

        require(

            poolParams.swapFee >= BalancerConstants.MIN_FEE,

            "ERR_INVALID_SWAP_FEE"

        );

        require(

            poolParams.swapFee <= BalancerConstants.MAX_FEE,

            "ERR_INVALID_SWAP_FEE"

        );



        // Arrays must be parallel

        require(

            poolParams.tokenBalances.length ==

                poolParams.constituentTokens.length,

            "ERR_START_BALANCES_MISMATCH"

        );

        require(

            poolParams.tokenWeights.length ==

                poolParams.constituentTokens.length,

            "ERR_START_WEIGHTS_MISMATCH"

        );

        // Cannot have too many or too few - technically redundant, since BPool.bind() would fail later

        // But if we don't check now, we could have a useless contract with no way to create a pool



        require(

            poolParams.constituentTokens.length >=

                BalancerConstants.MIN_ASSET_LIMIT,

            "ERR_TOO_FEW_TOKENS"

        );

        require(

            poolParams.constituentTokens.length <=

                BalancerConstants.MAX_ASSET_LIMIT,

            "ERR_TOO_MANY_TOKENS"

        );

        // There are further possible checks (e.g., if they use the same token twice), but

        // we can let bind() catch things like that (i.e., not things that might reasonably work)



        SmartPoolManager.verifyTokenCompliance(poolParams.constituentTokens);



        bFactory = IBFactory(factoryAddress);

        rights = rightsStruct;

        _initialTokens = poolParams.constituentTokens;

        _initialBalances = poolParams.tokenBalances;

        _initialSwapFee = poolParams.swapFee;



        // These default block time parameters can be overridden in createPool

        minimumWeightChangeBlockPeriod = DEFAULT_MIN_WEIGHT_CHANGE_BLOCK_PERIOD;

        addTokenTimeLockInBlocks = DEFAULT_ADD_TOKEN_TIME_LOCK_IN_BLOCKS;



        gradualUpdate.startWeights = poolParams.tokenWeights;

        // Initializing (unnecessarily) for documentation - 0 means no gradual weight change has been initiated

        gradualUpdate.startBlock = 0;

        // By default, there is no cap (unlimited pool token minting)

        bspCap = BalancerConstants.MAX_UINT;

    }



    // External functions



    /**

     * @notice Set the swap fee on the underlying pool

     * @dev Keep the local version and core in sync (see below)

     *      bPool is a contract interface; function calls on it are external

     * @param swapFee in Wei

     */

    function setSwapFee(uint256 swapFee)

        external

        virtual

        logs

        lock

        onlyOwner

        needsBPool

    {

        require(rights.canChangeSwapFee, "ERR_NOT_CONFIGURABLE_SWAP_FEE");



        // Underlying pool will check against min/max fee

        bPool.setSwapFee(swapFee);

    }



    /**

     * @notice Getter for the publicSwap field on the underlying pool

     * @dev viewLock, because setPublicSwap is lock

     *      bPool is a contract interface; function calls on it are external

     * @return Current value of isPublicSwap

     */

    function isPublicSwap()

        external

        virtual

        view

        viewlock

        needsBPool

        returns (bool)

    {

        return bPool.isPublicSwap();

    }



    /**

     * @notice Set the cap (max # of pool tokens)

     * @dev _bspCap defaults in the constructor to unlimited

     *      Can set to 0 (or anywhere below the current supply), to halt new investment

     *      Prevent setting it before creating a pool, since createPool sets to intialSupply

     *      (it does this to avoid an unlimited cap window between construction and createPool)

     *      Therefore setting it before then has no effect, so should not be allowed

     * @param newCap - new value of the cap

     */

    function setCap(uint256 newCap) external logs lock needsBPool onlyOwner {

        require(rights.canChangeCap, "ERR_CANNOT_CHANGE_CAP");



        emit CapChanged(msg.sender, bspCap, newCap);



        bspCap = newCap;

    }



    /**

     * @notice Set the public swap flag on the underlying pool

     * @dev If this smart pool has canPauseSwapping enabled, we can turn publicSwap off if it's already on

     *      Note that if they turn swapping off - but then finalize the pool - finalizing will turn the

     *      swapping back on. They're not supposed to finalize the underlying pool... would defeat the

     *      smart pool functions. (Only the owner can finalize the pool - which is this contract -

     *      so there is no risk from outside.)

     *

     *      bPool is a contract interface; function calls on it are external

     * @param publicSwap new value of the swap

     */

    function setPublicSwap(bool publicSwap)

        external

        virtual

        logs

        lock

        onlyOwner

        needsBPool

    {

        require(rights.canPauseSwapping, "ERR_NOT_PAUSABLE_SWAP");



        bPool.setPublicSwap(publicSwap);

    }



    /**

     * @notice Create a new Smart Pool - and set the block period time parameters

     * @dev Initialize the swap fee to the value provided in the CRP constructor

     *      Can be changed if the canChangeSwapFee permission is enabled

     *      Time parameters will be fixed at these values

     *

     *      If this contract doesn't have canChangeWeights permission - or you want to use the default

     *      values, the block time arguments are not needed, and you can just call the single-argument

     *      createPool()

     * @param initialSupply - Starting token balance

     * @param minimumWeightChangeBlockPeriodParam - Enforce a minimum time between the start and end blocks

     * @param addTokenTimeLockInBlocksParam - Enforce a mandatory wait time between updates

     *                                   This is also the wait time between committing and applying a new token

     */

    function createPool(

        uint256 initialSupply,

        uint256 minimumWeightChangeBlockPeriodParam,

        uint256 addTokenTimeLockInBlocksParam

    ) external virtual onlyOwner logs lock {

        require(

            minimumWeightChangeBlockPeriodParam >=

                addTokenTimeLockInBlocksParam,

            "ERR_INCONSISTENT_TOKEN_TIME_LOCK"

        );



        minimumWeightChangeBlockPeriod = minimumWeightChangeBlockPeriodParam;

        addTokenTimeLockInBlocks = addTokenTimeLockInBlocksParam;



        createPoolInternal(initialSupply);

    }



    /**

     * @notice Create a new Smart Pool

     * @dev Delegates to internal function

     * @param initialSupply starting token balance

     */

    function createPool(uint256 initialSupply)

        external

        virtual

        onlyOwner

        logs

        lock

    {

        createPoolInternal(initialSupply);

    }



    /**

     * @notice Update the weight of an existing token

     * @dev Notice Balance is not an input (like with rebind on BPool) since we will require prices not to change

     *      This is achieved by forcing balances to change proportionally to weights, so that prices don't change

     *      If prices could be changed, this would allow the controller to drain the pool by arbing price changes

     * @param token - token to be reweighted

     * @param newWeight - new weight of the token

     */

    function updateWeight(address token, uint256 newWeight)

        external

        virtual

        logs

        lock

        onlyOwner

        needsBPool

    {

        require(rights.canChangeWeights, "ERR_NOT_CONFIGURABLE_WEIGHTS");



        // We don't want people to set weights manually if there's a block-based update in progress

        require(gradualUpdate.startBlock == 0, "ERR_NO_UPDATE_DURING_GRADUAL");



        // Delegate to library to save space

        SmartPoolManager.updateWeight(

            IConfigurableRightsPool(address(this)),

            bPool,

            token,

            newWeight

        );

    }



    /**

     * @notice Update weights in a predetermined way, between startBlock and endBlock,

     *         through external calls to pokeWeights

     * @dev Must call pokeWeights at least once past the end for it to do the final update

     *      and enable calling this again.

     *      It is possible to call updateWeightsGradually during an update in some use cases

     *      For instance, setting newWeights to currentWeights to stop the update where it is

     * @param newWeights - final weights we want to get to. Note that the ORDER (and number) of

     *                     tokens can change if you have added or removed tokens from the pool

     *                     It ensures the counts are correct, but can't help you with the order!

     *                     You can get the underlying BPool (it's public), and call

     *                     getCurrentTokens() to see the current ordering, if you're not sure

     * @param startBlock - when weights should start to change

     * @param endBlock - when weights will be at their final values

     */

    function updateWeightsGradually(

        uint256[] calldata newWeights,

        uint256 startBlock,

        uint256 endBlock

    ) external virtual logs lock onlyOwner needsBPool {

        require(rights.canChangeWeights, "ERR_NOT_CONFIGURABLE_WEIGHTS");

        // Don't start this when we're in the middle of adding a new token

        require(!newToken.isCommitted, "ERR_PENDING_TOKEN_ADD");



        // Library computes the startBlock, computes startWeights as the current

        // denormalized weights of the core pool tokens.

        SmartPoolManager.updateWeightsGradually(

            bPool,

            gradualUpdate,

            newWeights,

            startBlock,

            endBlock,

            minimumWeightChangeBlockPeriod

        );

    }



    /**

     * @notice External function called to make the contract update weights according to plan

     * @dev Still works if we poke after the end of the period; also works if the weights don't change

     *      Resets if we are poking beyond the end, so that we can do it again

     */

    function pokeWeights() external virtual logs lock needsBPool {

        require(rights.canChangeWeights, "ERR_NOT_CONFIGURABLE_WEIGHTS");



        // Delegate to library to save space

        SmartPoolManager.pokeWeights(bPool, gradualUpdate);

    }



    /**

     * @notice Schedule (commit) a token to be added; must call applyAddToken after a fixed

     *         number of blocks to actually add the token

     *

     * @dev The purpose of this two-stage commit is to give warning of a potentially dangerous

     *      operation. A malicious pool operator could add a large amount of a low-value token,

     *      then drain the pool through price manipulation. Of course, there are many

     *      legitimate purposes, such as adding additional collateral tokens.

     *

     * @param token - the token to be added

     * @param balance - how much to be added

     * @param denormalizedWeight - the desired token weight

     */

    function commitAddToken(

        address token,

        uint256 balance,

        uint256 denormalizedWeight

    ) external virtual logs lock onlyOwner needsBPool {

        require(rights.canAddRemoveTokens, "ERR_CANNOT_ADD_REMOVE_TOKENS");



        // Can't do this while a progressive update is happening

        require(gradualUpdate.startBlock == 0, "ERR_NO_UPDATE_DURING_GRADUAL");



        SmartPoolManager.verifyTokenCompliance(token);



        emit NewTokenCommitted(token, address(this), msg.sender);



        // Delegate to library to save space

        SmartPoolManager.commitAddToken(

            bPool,

            token,

            balance,

            denormalizedWeight,

            newToken

        );

    }



    /**

     * @notice Add the token previously committed (in commitAddToken) to the pool

     */

    function applyAddToken() external virtual logs lock onlyOwner needsBPool {

        require(rights.canAddRemoveTokens, "ERR_CANNOT_ADD_REMOVE_TOKENS");



        // Delegate to library to save space

        SmartPoolManager.applyAddToken(

            IConfigurableRightsPool(address(this)),

            bPool,

            addTokenTimeLockInBlocks,

            newToken

        );

    }



    /**

     * @notice Remove a token from the pool

     * @dev bPool is a contract interface; function calls on it are external

     * @param token - token to remove

     */

    function removeToken(address token)

        external

        logs

        lock

        onlyOwner

        needsBPool

    {

        // It's possible to have remove rights without having add rights

        require(rights.canAddRemoveTokens, "ERR_CANNOT_ADD_REMOVE_TOKENS");

        // After createPool, token list is maintained in the underlying BPool

        require(!newToken.isCommitted, "ERR_REMOVE_WITH_ADD_PENDING");

        // Prevent removing during an update (or token lists can get out of sync)

        require(gradualUpdate.startBlock == 0, "ERR_NO_UPDATE_DURING_GRADUAL");



        // Delegate to library to save space

        SmartPoolManager.removeToken(

            IConfigurableRightsPool(address(this)),

            bPool,

            token

        );

    }



    /**

     * @notice Join a pool

     * @dev Emits a LogJoin event (for each token)

     *      bPool is a contract interface; function calls on it are external

     * @param poolAmountOut - number of pool tokens to receive

     * @param maxAmountsIn - Max amount of asset tokens to spend

     */

    function joinPool(uint256 poolAmountOut, uint256[] calldata maxAmountsIn)

        external

        logs

        lock

        needsBPool

        lockUnderlyingPool

    {

        require(

            !rights.canWhitelistLPs || _liquidityProviderWhitelist[msg.sender],

            "ERR_NOT_ON_WHITELIST"

        );



        // Delegate to library to save space



        // Library computes actualAmountsIn, and does many validations

        // Cannot call the push/pull/min from an external library for

        // any of these pool functions. Since msg.sender can be anybody,

        // they must be internal

        uint256[] memory actualAmountsIn = SmartPoolManager.joinPool(

            IConfigurableRightsPool(address(this)),

            bPool,

            poolAmountOut,

            maxAmountsIn

        );



        // After createPool, token list is maintained in the underlying BPool

        address[] memory poolTokens = bPool.getCurrentTokens();



        for (uint256 i = 0; i < poolTokens.length; i++) {

            address t = poolTokens[i];

            uint256 tokenAmountIn = actualAmountsIn[i];



            emit LogJoin(msg.sender, t, tokenAmountIn);



            _pullUnderlying(t, msg.sender, tokenAmountIn);

        }



        _mintPoolShare(poolAmountOut);

        _pushPoolShare(msg.sender, poolAmountOut);

    }



    /**

     * @notice Exit a pool - redeem pool tokens for underlying assets

     * @dev Emits a LogExit event for each token

     *      bPool is a contract interface; function calls on it are external

     * @param poolAmountIn - amount of pool tokens to redeem

     * @param minAmountsOut - minimum amount of asset tokens to receive

     */

    function exitPool(uint256 poolAmountIn, uint256[] calldata minAmountsOut)

        external

        logs

        lock

        needsBPool

        lockUnderlyingPool

    {

        // Delegate to library to save space



        // Library computes actualAmountsOut, and does many validations

        // Also computes the exitFee and pAiAfterExitFee

        (

            uint256 exitFee,

            uint256 pAiAfterExitFee,

            uint256[] memory actualAmountsOut

        ) = SmartPoolManager.exitPool(

            IConfigurableRightsPool(address(this)),

            bPool,

            poolAmountIn,

            minAmountsOut

        );



        _pullPoolShare(msg.sender, poolAmountIn);

        _pushPoolShare(address(bFactory), exitFee);

        _burnPoolShare(pAiAfterExitFee);



        // After createPool, token list is maintained in the underlying BPool

        address[] memory poolTokens = bPool.getCurrentTokens();



        for (uint256 i = 0; i < poolTokens.length; i++) {

            address t = poolTokens[i];

            uint256 tokenAmountOut = actualAmountsOut[i];



            emit LogExit(msg.sender, t, tokenAmountOut);



            _pushUnderlying(t, msg.sender, tokenAmountOut);

        }

    }



    /**

     * @notice Join by swapping a fixed amount of an external token in (must be present in the pool)

     *         System calculates the pool token amount

     * @dev emits a LogJoin event

     * @param tokenIn - which token we're transferring in

     * @param tokenAmountIn - amount of deposit

     * @param minPoolAmountOut - minimum of pool tokens to receive

     * @return poolAmountOut - amount of pool tokens minted and transferred

     */

    function joinswapExternAmountIn(

        address tokenIn,

        uint256 tokenAmountIn,

        uint256 minPoolAmountOut

    ) external logs lock needsBPool returns (uint256 poolAmountOut) {

        require(

            !rights.canWhitelistLPs || _liquidityProviderWhitelist[msg.sender],

            "ERR_NOT_ON_WHITELIST"

        );



        // Delegate to library to save space

        poolAmountOut = SmartPoolManager.joinswapExternAmountIn(

            IConfigurableRightsPool(address(this)),

            bPool,

            tokenIn,

            tokenAmountIn,

            minPoolAmountOut

        );



        emit LogJoin(msg.sender, tokenIn, tokenAmountIn);



        _mintPoolShare(poolAmountOut);

        _pushPoolShare(msg.sender, poolAmountOut);

        _pullUnderlying(tokenIn, msg.sender, tokenAmountIn);



        return poolAmountOut;

    }



    /**

     * @notice Join by swapping an external token in (must be present in the pool)

     *         To receive an exact amount of pool tokens out. System calculates the deposit amount

     * @dev emits a LogJoin event

     * @param tokenIn - which token we're transferring in (system calculates amount required)

     * @param poolAmountOut - amount of pool tokens to be received

     * @param maxAmountIn - Maximum asset tokens that can be pulled to pay for the pool tokens

     * @return tokenAmountIn - amount of asset tokens transferred in to purchase the pool tokens

     */

    function joinswapPoolAmountOut(

        address tokenIn,

        uint256 poolAmountOut,

        uint256 maxAmountIn

    ) external logs lock needsBPool returns (uint256 tokenAmountIn) {

        require(

            !rights.canWhitelistLPs || _liquidityProviderWhitelist[msg.sender],

            "ERR_NOT_ON_WHITELIST"

        );



        // Delegate to library to save space

        tokenAmountIn = SmartPoolManager.joinswapPoolAmountOut(

            IConfigurableRightsPool(address(this)),

            bPool,

            tokenIn,

            poolAmountOut,

            maxAmountIn

        );



        emit LogJoin(msg.sender, tokenIn, tokenAmountIn);



        _mintPoolShare(poolAmountOut);

        _pushPoolShare(msg.sender, poolAmountOut);

        _pullUnderlying(tokenIn, msg.sender, tokenAmountIn);



        return tokenAmountIn;

    }



    /**

     * @notice Exit a pool - redeem a specific number of pool tokens for an underlying asset

     *         Asset must be present in the pool, and will incur an EXIT_FEE (if set to non-zero)

     * @dev Emits a LogExit event for the token

     * @param tokenOut - which token the caller wants to receive

     * @param poolAmountIn - amount of pool tokens to redeem

     * @param minAmountOut - minimum asset tokens to receive

     * @return tokenAmountOut - amount of asset tokens returned

     */

    function exitswapPoolAmountIn(

        address tokenOut,

        uint256 poolAmountIn,

        uint256 minAmountOut

    ) external logs lock needsBPool returns (uint256 tokenAmountOut) {

        // Delegate to library to save space



        // Calculates final amountOut, and the fee and final amount in

        (uint256 exitFee, uint256 amountOut) = SmartPoolManager

            .exitswapPoolAmountIn(

            IConfigurableRightsPool(address(this)),

            bPool,

            tokenOut,

            poolAmountIn,

            minAmountOut

        );



        tokenAmountOut = amountOut;

        uint256 pAiAfterExitFee = BalancerSafeMath.bsub(poolAmountIn, exitFee);



        emit LogExit(msg.sender, tokenOut, tokenAmountOut);



        _pullPoolShare(msg.sender, poolAmountIn);

        _burnPoolShare(pAiAfterExitFee);

        _pushPoolShare(address(bFactory), exitFee);

        _pushUnderlying(tokenOut, msg.sender, tokenAmountOut);



        return tokenAmountOut;

    }



    /**

     * @notice Exit a pool - redeem pool tokens for a specific amount of underlying assets

     *         Asset must be present in the pool

     * @dev Emits a LogExit event for the token

     * @param tokenOut - which token the caller wants to receive

     * @param tokenAmountOut - amount of underlying asset tokens to receive

     * @param maxPoolAmountIn - maximum pool tokens to be redeemed

     * @return poolAmountIn - amount of pool tokens redeemed

     */

    function exitswapExternAmountOut(

        address tokenOut,

        uint256 tokenAmountOut,

        uint256 maxPoolAmountIn

    ) external logs lock needsBPool returns (uint256 poolAmountIn) {

        // Delegate to library to save space



        // Calculates final amounts in, accounting for the exit fee

        (uint256 exitFee, uint256 amountIn) = SmartPoolManager

            .exitswapExternAmountOut(

            IConfigurableRightsPool(address(this)),

            bPool,

            tokenOut,

            tokenAmountOut,

            maxPoolAmountIn

        );



        poolAmountIn = amountIn;

        uint256 pAiAfterExitFee = BalancerSafeMath.bsub(poolAmountIn, exitFee);



        emit LogExit(msg.sender, tokenOut, tokenAmountOut);



        _pullPoolShare(msg.sender, poolAmountIn);

        _burnPoolShare(pAiAfterExitFee);

        _pushPoolShare(address(bFactory), exitFee);

        _pushUnderlying(tokenOut, msg.sender, tokenAmountOut);



        return poolAmountIn;

    }



    /**

     * @notice Add to the whitelist of liquidity providers (if enabled)

     * @param provider - address of the liquidity provider

     */

    function whitelistLiquidityProvider(address provider)

        external

        onlyOwner

        lock

        logs

    {

        require(rights.canWhitelistLPs, "ERR_CANNOT_WHITELIST_LPS");

        require(provider != address(0), "ERR_INVALID_ADDRESS");



        _liquidityProviderWhitelist[provider] = true;

    }



    /**

     * @notice Remove from the whitelist of liquidity providers (if enabled)

     * @param provider - address of the liquidity provider

     */

    function removeWhitelistedLiquidityProvider(address provider)

        external

        onlyOwner

        lock

        logs

    {

        require(rights.canWhitelistLPs, "ERR_CANNOT_WHITELIST_LPS");

        require(

            _liquidityProviderWhitelist[provider],

            "ERR_LP_NOT_WHITELISTED"

        );

        require(provider != address(0), "ERR_INVALID_ADDRESS");



        _liquidityProviderWhitelist[provider] = false;

    }



    /**

     * @notice Check if an address is a liquidity provider

     * @dev If the whitelist feature is not enabled, anyone can provide liquidity (assuming finalized)

     * @return boolean value indicating whether the address can join a pool

     */

    function canProvideLiquidity(address provider)

        external

        view

        returns (bool)

    {

        if (rights.canWhitelistLPs) {

            return _liquidityProviderWhitelist[provider];

        } else {

            // Probably don't strictly need this (could just return true)

            // But the null address can't provide funds

            return provider != address(0);

        }

    }



    /**

     * @notice Getter for specific permissions

     * @dev value of the enum is just the 0-based index in the enumeration

     *      For instance canPauseSwapping is 0; canChangeWeights is 2

     * @return token boolean true if we have the given permission

     */

    function hasPermission(RightsManager.Permissions permission)

        external

        virtual

        view

        returns (bool)

    {

        return RightsManager.hasPermission(rights, permission);

    }



    /**

     * @notice Get the denormalized weight of a token

     * @dev viewlock to prevent calling if it's being updated

     * @return token weight

     */

    function getDenormalizedWeight(address token)

        external

        view

        viewlock

        needsBPool

        returns (uint256)

    {

        return bPool.getDenormalizedWeight(token);

    }



    /**

     * @notice Getter for the RightsManager contract

     * @dev Convenience function to get the address of the RightsManager library (so clients can check version)

     * @return address of the RightsManager library

     */

    function getRightsManagerVersion() external pure returns (address) {

        return address(RightsManager);

    }



    /**

     * @notice Getter for the BalancerSafeMath contract

     * @dev Convenience function to get the address of the BalancerSafeMath library (so clients can check version)

     * @return address of the BalancerSafeMath library

     */

    function getBalancerSafeMathVersion() external pure returns (address) {

        return address(BalancerSafeMath);

    }



    /**

     * @notice Getter for the SmartPoolManager contract

     * @dev Convenience function to get the address of the SmartPoolManager library (so clients can check version)

     * @return address of the SmartPoolManager library

     */

    function getSmartPoolManagerVersion() external pure returns (address) {

        return address(SmartPoolManager);

    }



    // Public functions



    // "Public" versions that can safely be called from SmartPoolManager

    // Allows only the contract itself to call them (not the controller or any external account)



    function mintPoolShareFromLib(uint256 amount) public {

        require(msg.sender == address(this), "ERR_NOT_CONTROLLER");



        _mint(amount);

    }



    function pushPoolShareFromLib(address to, uint256 amount) public {

        require(msg.sender == address(this), "ERR_NOT_CONTROLLER");



        _push(to, amount);

    }



    function pullPoolShareFromLib(address from, uint256 amount) public {

        require(msg.sender == address(this), "ERR_NOT_CONTROLLER");



        _pull(from, amount);

    }



    function burnPoolShareFromLib(uint256 amount) public {

        require(msg.sender == address(this), "ERR_NOT_CONTROLLER");



        _burn(amount);

    }



    // Internal functions



    // Lint wants the function to have a leading underscore too

    /* solhint-disable private-vars-leading-underscore */



    /**

     * @notice Create a new Smart Pool

     * @dev Initialize the swap fee to the value provided in the CRP constructor

     *      Can be changed if the canChangeSwapFee permission is enabled

     * @param initialSupply starting token balance

     */

    function createPoolInternal(uint256 initialSupply) internal {

        require(address(bPool) == address(0), "ERR_IS_CREATED");

        require(

            initialSupply >= BalancerConstants.MIN_POOL_SUPPLY,

            "ERR_INIT_SUPPLY_MIN"

        );

        require(

            initialSupply <= BalancerConstants.MAX_POOL_SUPPLY,

            "ERR_INIT_SUPPLY_MAX"

        );



        // If the controller can change the cap, initialize it to the initial supply

        // Defensive programming, so that there is no gap between creating the pool

        // (initialized to unlimited in the constructor), and setting the cap,

        // which they will presumably do if they have this right.

        if (rights.canChangeCap) {

            bspCap = initialSupply;

        }



        // There is technically reentrancy here, since we're making external calls and

        // then transferring tokens. However, the external calls are all to the underlying BPool



        // To the extent possible, modify state variables before calling functions

        _mintPoolShare(initialSupply);

        _pushPoolShare(msg.sender, initialSupply);



        // Deploy new BPool (bFactory and bPool are interfaces; all calls are external)

        bPool = bFactory.newBPool();



        // EXIT_FEE must always be zero, or ConfigurableRightsPool._pushUnderlying will fail

        require(bPool.EXIT_FEE() == 0, "ERR_NONZERO_EXIT_FEE");

        require(BalancerConstants.EXIT_FEE == 0, "ERR_NONZERO_EXIT_FEE");



        for (uint256 i = 0; i < _initialTokens.length; i++) {

            address t = _initialTokens[i];

            uint256 bal = _initialBalances[i];

            uint256 denorm = gradualUpdate.startWeights[i];



            bool returnValue = IERC20(t).transferFrom(

                msg.sender,

                address(this),

                bal

            );

            require(returnValue, "ERR_ERC20_FALSE");



            returnValue = IERC20(t).safeApprove(

                address(bPool),

                BalancerConstants.MAX_UINT

            );

            require(returnValue, "ERR_ERC20_FALSE");



            bPool.bind(t, bal, denorm);

        }



        while (_initialTokens.length > 0) {

            // Modifying state variable after external calls here,

            // but not essential, so not dangerous

            _initialTokens.pop();

        }



        // Set fee to the initial value set in the constructor

        // Hereafter, read the swapFee from the underlying pool, not the local state variable

        bPool.setSwapFee(_initialSwapFee);

        bPool.setPublicSwap(true);



        // "destroy" the temporary swap fee (like _initialTokens above) in case a subclass tries to use it

        _initialSwapFee = 0;

    }



    /* solhint-enable private-vars-leading-underscore */



    // Rebind BPool and pull tokens from address

    // bPool is a contract interface; function calls on it are external

    function _pullUnderlying(

        address erc20,

        address from,

        uint256 amount

    ) internal needsBPool {

        // Gets current Balance of token i, Bi, and weight of token i, Wi, from BPool.

        uint256 tokenBalance = bPool.getBalance(erc20);

        uint256 tokenWeight = bPool.getDenormalizedWeight(erc20);



        bool xfer = IERC20(erc20).transferFrom(from, address(this), amount);

        require(xfer, "ERR_ERC20_FALSE");

        bPool.rebind(

            erc20,

            BalancerSafeMath.badd(tokenBalance, amount),

            tokenWeight

        );

    }



    // Rebind BPool and push tokens to address

    // bPool is a contract interface; function calls on it are external

    function _pushUnderlying(

        address erc20,

        address to,

        uint256 amount

    ) internal needsBPool {

        // Gets current Balance of token i, Bi, and weight of token i, Wi, from BPool.

        uint256 tokenBalance = bPool.getBalance(erc20);

        uint256 tokenWeight = bPool.getDenormalizedWeight(erc20);

        bPool.rebind(

            erc20,

            BalancerSafeMath.bsub(tokenBalance, amount),

            tokenWeight

        );



        bool xfer = IERC20(erc20).transfer(to, amount);

        require(xfer, "ERR_ERC20_FALSE");

    }



    // Wrappers around corresponding core functions



    //

    function _mint(uint256 amount) internal override {

        super._mint(amount);

        require(varTotalSupply <= bspCap, "ERR_CAP_LIMIT_REACHED");

    }



    function _mintPoolShare(uint256 amount) internal {

        _mint(amount);

    }



    function _pushPoolShare(address to, uint256 amount) internal {

        _push(to, amount);

    }



    function _pullPoolShare(address from, uint256 amount) internal {

        _pull(from, amount);

    }



    function _burnPoolShare(uint256 amount) internal {

        _burn(amount);

    }

}



// Imports



// Contracts



/**

 * @author Balancer Labs

 * @title Configurable Rights Pool Factory - create parameterized smart pools

 * @dev Rights are held in a corresponding struct in ConfigurableRightsPool

 *      Index values are as follows:

 *      0: canPauseSwapping - can setPublicSwap back to false after turning it on

 *                            by default, it is off on initialization and can only be turned on

 *      1: canChangeSwapFee - can setSwapFee after initialization (by default, it is fixed at create time)

 *      2: canChangeWeights - can bind new token weights (allowed by default in base pool)

 *      3: canAddRemoveTokens - can bind/unbind tokens (allowed by default in base pool)

 *      4: canWhitelistLPs - if set, only whitelisted addresses can join pools

 *                           (enables private pools with more than one LP)

 *      5: canChangeCap - can change the BSP cap (max # of pool tokens)

 */

contract CRPFactory {

    // State variables



    // Keep a list of all Configurable Rights Pools

    mapping(address => bool) private _isCrp;



    // Event declarations



    // Log the address of each new smart pool, and its creator

    event LogNewCrp(address indexed caller, address indexed pool);



    // Function declarations



    /**

     * @notice Create a new CRP

     * @dev emits a LogNewCRP event

     * @param factoryAddress - the BFactory instance used to create the underlying pool

     * @param poolParams - struct containing the names, tokens, weights, balances, and swap fee

     * @param rights - struct of permissions, configuring this CRP instance (see above for definitions)

     */

    function newCrp(

        address factoryAddress,

        ConfigurableRightsPool.PoolParams calldata poolParams,

        RightsManager.Rights calldata rights

    ) external returns (ConfigurableRightsPool) {

        require(

            poolParams.constituentTokens.length >=

                BalancerConstants.MIN_ASSET_LIMIT,

            "ERR_TOO_FEW_TOKENS"

        );



        // Arrays must be parallel

        require(

            poolParams.tokenBalances.length ==

                poolParams.constituentTokens.length,

            "ERR_START_BALANCES_MISMATCH"

        );

        require(

            poolParams.tokenWeights.length ==

                poolParams.constituentTokens.length,

            "ERR_START_WEIGHTS_MISMATCH"

        );



        ConfigurableRightsPool crp = new ConfigurableRightsPool(

            factoryAddress,

            poolParams,

            rights

        );



        emit LogNewCrp(msg.sender, address(crp));



        _isCrp[address(crp)] = true;

        // The caller is the controller of the CRP

        // The CRP will be the controller of the underlying Core BPool

        crp.setController(msg.sender);



        return crp;

    }



    /**

     * @notice Check to see if a given address is a CRP

     * @param addr - address to check

     * @return boolean indicating whether it is a CRP

     */

    function isCrp(address addr) external view returns (bool) {

        return _isCrp[addr];

    }

}



contract ZuniTreasury is Ownable {

    using SafeMath for uint256;

    using Address for address;



    ConfigurableRightsPool public crp;



    IERC20 public zuni;

    IBPool public bPool;



    address public zuniBadge;



    uint256 public constant MAX_VAL = 2**256 - 1;

    uint256 public constant WEI_POINT = 10**18;

    uint256 public constant DEFAULT_ISSURANCE_AMOUNT = WEI_POINT * 100;



    constructor(IERC20 _zuni) public {

        zuni = _zuni;

    }



    modifier onlyZuniBadge() {

        require(msg.sender == zuniBadge, "ZuinTreasury: should be badge sc");

        _;

    }



    function smartPoolAddress() external view returns (address) {

        return address(crp);

    }



    function setZuniBadge(address _zuniBadge) external onlyOwner {

        zuniBadge = _zuniBadge;

    }



    function setCRP(address _crpAddress) external onlyOwner {

        // require(address(crp) == address(0x0));



        crp = ConfigurableRightsPool(_crpAddress);

        bPool = IBPool(crp.bPool());

    }



    function setZuniToken(IERC20 _zuni) external onlyOwner {

        zuni = _zuni;

    }



    function _issue(uint256 tokenAmountOut) internal {

        uint256 maxPoolAmountIn = bPool.calcPoolInGivenSingleOut(

            bPool.getBalance(address(zuni)),

            bPool.getDenormalizedWeight(address(zuni)),

            crp.totalSupply(),

            bPool.getTotalDenormalizedWeight(),

            tokenAmountOut,

            bPool.getSwapFee()

        );



        maxPoolAmountIn = maxPoolAmountIn.mul(101).div(100);



        crp.exitswapExternAmountOut(

            address(zuni),

            tokenAmountOut,

            maxPoolAmountIn

        );

    }



    function giveZuniReward(address to, uint256 amount) external onlyZuniBadge {

        if (IERC20(address(zuni)).balanceOf(address(this)) < amount) {

            _issue(amount.add(DEFAULT_ISSURANCE_AMOUNT));

        }



        require(IERC20(address(zuni)).transfer(to, amount));

    }



    function issue(uint256 tokenAmountOut) external onlyOwner {

        _issue(tokenAmountOut);

    }



    function buyback(uint256 tokenAmountIn) external onlyOwner {

        require(

            IERC20(address(zuni)).balanceOf(address(this)) >= tokenAmountIn,

            "ZuniTreasury: zuni balance is not enough"

        );



        uint256 minPoolAmountOut = bPool.calcPoolOutGivenSingleIn(

            bPool.getBalance(address(zuni)),

            bPool.getDenormalizedWeight(address(zuni)),

            crp.totalSupply(),

            bPool.getTotalDenormalizedWeight(),

            tokenAmountIn,

            bPool.getSwapFee()

        );



        minPoolAmountOut = minPoolAmountOut.mul(99).div(100);



        require(IERC20(address(zuni)).approve(address(crp), tokenAmountIn));



        crp.joinswapExternAmountIn(

            address(zuni),

            tokenAmountIn,

            minPoolAmountOut

        );

    }



    function capitalization(address token, uint256 tokenAmountOut)

        external

        onlyOwner

    {

        require(

            token != address(zuni),

            "ZuniTreasury: token address is incorrect"

        );



        uint256 maxPoolAmountIn = bPool.calcPoolInGivenSingleOut(

            bPool.getBalance(address(token)),

            bPool.getDenormalizedWeight(address(token)),

            crp.totalSupply(),

            bPool.getTotalDenormalizedWeight(),

            tokenAmountOut,

            bPool.getSwapFee()

        );



        maxPoolAmountIn = maxPoolAmountIn.mul(101).div(100);



        crp.exitswapExternAmountOut(

            address(token),

            tokenAmountOut,

            maxPoolAmountIn

        );

    }



    function withdrawToken(

        address token,

        address to,

        uint256 amount

    ) external onlyOwner {

        require(

            IERC20(address(token)).balanceOf(address(this)) >= amount,

            "ZuniTreasury: token balance is not enough"

        );



        require(IERC20(address(token)).transfer(to, amount));

    }



    // external functions only can be called by owner to config CRP



    function setSwapFee(uint256 swapFee) external onlyOwner {

        crp.setSwapFee(swapFee);

    }



    function setCap(uint256 newCap) external onlyOwner {

        crp.setCap(newCap);

    }



    function setPublicSwap(bool publicSwap) external onlyOwner {

        crp.setPublicSwap(publicSwap);

    }



    function updateWeight(address token, uint256 newWeight) external onlyOwner {

        crp.updateWeight(token, newWeight);

    }



    function updateWeightsGradually(

        uint256[] calldata newWeights,

        uint256 startBlock,

        uint256 endBlock

    ) external onlyOwner {

        crp.updateWeightsGradually(newWeights, startBlock, endBlock);

    }



    function pokeWeights() external onlyOwner {

        crp.pokeWeights();

    }



    function commitAddToken(

        address token,

        uint256 balance,

        uint256 denormalizedWeight

    ) external onlyOwner {

        crp.commitAddToken(token, balance, denormalizedWeight);

    }



    function applyAddToken() external onlyOwner {

        crp.applyAddToken();

    }



    function removeToken(address token) external onlyOwner {

        crp.removeToken(token);

    }



    function whitelistLiquidityProvider(address provider) external onlyOwner {

        crp.whitelistLiquidityProvider(provider);

    }



    function removeWhitelistedLiquidityProvider(address provider)

        external

        onlyOwner

    {

        crp.removeWhitelistedLiquidityProvider(provider);

    }

}



contract ZuniBadge is Ownable {

    using SafeMath for uint256;

    using Address for address;

    using EnumerableSet for EnumerableSet.UintSet;



    struct Unit {

        uint256 interest;

        address leader;

        address creator;

        EnumerableSet.UintSet childUnitIds; // childUnitId or AccountId

    }



    struct UnitsByLevel {

        uint256 length;

        mapping(uint256 => Unit) levelUnits; // unit id start from 1

    }



    struct WarrantBadge {

        uint256 id;

        uint256 pendingReward;

        uint256 collectedAmount;

        uint256 claimedAmount;

    }



    struct Account {

        uint256 accountId; // unique id of account, start from 1

        uint256 level; // level start from 0

        bool claimedLevel;

        uint256 interest;

        uint256 childUnitId;

        uint256 parentUnitId;

        uint256 bannedTimes;

        uint256 pendingWarrantReward;

        uint256 claimedRankReward;

        uint256 cliamedWarrantReward;

        uint256[] promoteTimes;

        WarrantBadge[] warrantBadges;

    }



    uint256 constant REWARD_MUL_DECIMAL = 100000;

    uint256 public constant WEI_POINT = 10**18;



    ZuniTreasury private zuniTreasury;



    uint256 private interestLength;

    uint256 private totalUsers;

    uint256 private unitSize;

    uint256 private maxLevel;

    uint256[] private levelWeight;



    address private rankAdmin;

    uint256 private topLevel;

    uint256[] private distributeTimes;



    mapping(uint256 => UnitsByLevel) private units; // level => UnitsByLevel

    mapping(address => Account) private accounts; // addresss => Account

    mapping(uint256 => address) private accountsById; // accountId => Account



    address private warrantAdmin;



    modifier onlyRankAdmin() {

        require(msg.sender == rankAdmin);

        _;

    }



    modifier onlyWarrantAdmin() {

        require(msg.sender == warrantAdmin);

        _;

    }



    constructor(

        uint256 _interestLength,

        uint256 _unitSize,

        uint256 _maxLevel,

        address _rankAdmin,

        address _warrantAdmin

    ) public {

        require(_interestLength > 0 && _interestLength <= 8);



        interestLength = _interestLength;

        unitSize = _unitSize;

        maxLevel = _maxLevel;

        rankAdmin = _rankAdmin;

        warrantAdmin = _warrantAdmin;

    }



    function setTreasury(ZuniTreasury _zuniTreasury) external onlyOwner {

        zuniTreasury = _zuniTreasury;

    }



    function updateRankAdmin(address _rankAdmin) external onlyOwner {

        rankAdmin = _rankAdmin;

    }



    function updateWarrantAdmin(address _warrantAdmin) external onlyOwner {

        warrantAdmin = _warrantAdmin;

    }



    function giveWarrantBadge(

        address _user,

        uint256 _warrantId,

        uint256 _reward

    ) external onlyWarrantAdmin {

        Account storage account = accounts[_user];



        for (uint256 i = 0; i < account.warrantBadges.length; i++) {

            if (account.warrantBadges[i].id == _warrantId) {

                account.warrantBadges[i].pendingReward = account

                    .warrantBadges[i]

                    .pendingReward

                    .add(_reward);

                account.warrantBadges[i].collectedAmount = account

                    .warrantBadges[i]

                    .collectedAmount

                    .add(1);

                return;

            }

        }



        account.warrantBadges.push(

            WarrantBadge({

                id: _warrantId,

                pendingReward: _reward,

                collectedAmount: 1,

                claimedAmount: 0

            })

        );

    }



    function setLevelWeight(uint256[] calldata _levelWeight)

        external

        onlyOwner

    {

        require(

            _levelWeight.length == maxLevel,

            "ZuniBadge: must have exactly one weight point for each level"

        );



        delete levelWeight;



        for (uint256 i = 0; i < maxLevel; i++) {

            levelWeight.push(_levelWeight[i]);

        }

    }



    function isMatchingInterest(uint256 baseInterest, uint256 compareInterest)

        public

        view

        returns (bool)

    {

        for (uint256 i = 0; i < interestLength; i++) {

            if (

                baseInterest.mod(2) == 1 &&

                baseInterest.mod(2) == compareInterest.mod(2)

            ) {

                return true;

            }

            baseInterest = baseInterest >> 1;

            compareInterest = compareInterest >> 1;

        }

        return false;

    }



    function mergeInterest(uint256 baseInterest, uint256 compareInterest)

        internal

        view

        returns (uint256)

    {

        uint256 mergedInterest = 0;

        uint256 baseMul = 1;



        for (uint256 i = 0; i < interestLength; i++) {

            mergedInterest = mergedInterest.add(

                (baseInterest.mod(2) | compareInterest.mod(2)).mul(baseMul)

            );

            baseMul = baseMul << 1;

            baseInterest = baseInterest >> 1;

            compareInterest = compareInterest >> 1;

        }

        return mergedInterest;

    }



    function maxUnitLengthByLevel(uint256 _level)

        internal

        view

        returns (uint256)

    {

        return (maxLevel.sub(_level))**unitSize;

    }



    function updateAccounting(address _user, uint256 _interest)

        internal

        returns (bool)

    {

        Account storage account = accounts[_user];

        if (account.bannedTimes >= 5 || account.accountId > 0) {

            return false;

        }

        if (account.accountId == 0) {

            totalUsers = totalUsers.add(1);

            account.accountId = totalUsers;

            account.interest = _interest;

            accountsById[totalUsers] = _user;

            account.childUnitId = account.accountId;

            account.parentUnitId = 0;

            account.claimedLevel = true;

            return true;

        }

        return false;

    }



    function findMatchingUnit(uint256 _level, uint256 _interest)

        internal

        view

        returns (uint256)

    {

        UnitsByLevel storage unitsByLevel = units[_level];

        for (uint256 i = 1; i <= unitsByLevel.length; i++) {

            if (

                unitsByLevel.levelUnits[i].childUnitIds.length() < unitSize &&

                isMatchingInterest(

                    unitsByLevel.levelUnits[i].interest,

                    _interest

                )

            ) {

                return i;

            }

        }

        return 0;

    }



    function findSpareUnit(uint256 _level) internal view returns (uint256) {

        UnitsByLevel storage unitsByLevel = units[_level];

        for (uint256 i = 1; i <= unitsByLevel.length; i++) {

            if (unitsByLevel.levelUnits[i].childUnitIds.length() < unitSize) {

                return i;

            }

        }

        return 0;

    }



    function createOrJoinUnit(address _user) internal returns (bool) {

        Account storage account = accounts[_user];

        UnitsByLevel storage unitsByLevel = units[account.level];

        uint256 maxUnitLength = maxUnitLengthByLevel(account.level);

        uint256 matchingUnitId = findMatchingUnit(

            account.level,

            account.interest

        );



        // join

        if (matchingUnitId > 0) {

            require(

                unitsByLevel.levelUnits[matchingUnitId].childUnitIds.add(

                    account.childUnitId

                )

            );

            account.parentUnitId = matchingUnitId;

            return true;

        }



        // create

        if (unitsByLevel.length < maxUnitLength) {

            EnumerableSet.UintSet memory _childUnitIds;

            uint256 newUnitId = unitsByLevel.length.add(1);

            unitsByLevel.length = newUnitId;



            unitsByLevel.levelUnits[newUnitId] = Unit({

                interest: account.interest,

                leader: address(0x0),

                creator: msg.sender,

                childUnitIds: _childUnitIds

            });



            require(

                unitsByLevel.levelUnits[newUnitId].childUnitIds.add(

                    account.childUnitId

                )

            );



            account.parentUnitId = newUnitId;

            return true;

        }



        // update unit interest

        uint256 spareUnitId = findSpareUnit(account.level);

        if (spareUnitId > 0) {

            unitsByLevel.levelUnits[spareUnitId].childUnitIds.add(

                account.childUnitId

            );

            unitsByLevel.levelUnits[spareUnitId].interest = mergeInterest(

                unitsByLevel.levelUnits[spareUnitId].interest,

                account.interest

            );

            account.parentUnitId = spareUnitId;

            return true;

        }



        return false;

    }



    function joinCrew(uint256 _interest) external returns (bool) {

        require(

            updateAccounting(msg.sender, _interest),

            "ZuniBadge: banned user or already joined community"

        ); // update accounting



        return createOrJoinUnit(msg.sender);

    }



    function addToUnit(address _user) external {

        Account memory account = accounts[msg.sender];

        require(account.childUnitId > 0, "ZuniBadge: should have child unit");



        Unit storage unit = units[account.level.sub(1)].levelUnits[account

            .childUnitId];



        require(

            unit.leader == msg.sender,

            "ZuniBadge: should be leader of the unit"

        );



        require(

            unit.childUnitIds.length() < unitSize,

            "ZuniBadge: unit is full"

        );



        Account storage user = accounts[_user];



        require(

            account.level == user.level.add(1),

            "ZuniBadge: user level is incorrect"

        );

        require(user.parentUnitId == 0, "ZuniBadge: user already has a parent");



        if (user.accountId == 0) {

            require(

                updateAccounting(_user, account.interest),

                "ZuniBadge: banned user or already joined community"

            );

        }



        require(unit.childUnitIds.add(user.childUnitId));

        user.parentUnitId = account.childUnitId;

    }



    function removeFromUnit(address _user) external {

        Account storage account = accounts[msg.sender];

        require(account.childUnitId > 0, "ZuniBadge: should have child unit");



        Unit storage unit = units[account.level.sub(1)].levelUnits[account

            .childUnitId];



        require(

            unit.leader == msg.sender,

            "ZuniBadge: should be leader of the unit"

        );



        Account storage user = accounts[_user];



        require(

            account.level == user.level.add(1),

            "ZuniBadge: user level is incorrect"

        );



        require(

            unit.childUnitIds.contains(user.childUnitId),

            "ZuniBadge: unitId should be exits"

        );



        require(unit.childUnitIds.remove(user.childUnitId));



        user.parentUnitId = 0;

        user.bannedTimes = user.bannedTimes.add(1);

        if (user.bannedTimes >= 5) {

            if (user.level > 0) {

                Unit memory childUnit = units[user.level.sub(1)].levelUnits[user

                    .childUnitId];

                childUnit.leader = address(0x0);

            }



            user.childUnitId = 0;

            user.accountId = 0;

            user.level = 0;

            delete user.promoteTimes;

        }

    }



    function isEligibleForPromote(address _user) public view returns (bool) {

        Account memory account = accounts[_user];

        if (account.parentUnitId == 0 || account.claimedLevel == false) {

            return false;

        }



        Unit storage unit = units[account.level].levelUnits[account

            .parentUnitId];



        if (

            unit.leader != address(0x0) ||

            unit.childUnitIds.length() != unitSize

        ) {

            return false;

        }



        if (account.level > 0) {

            for (uint256 i = 0; i < unitSize; i++) {

                if (

                    units[account.level.sub(1)].levelUnits[unit.childUnitIds.at(

                        i

                    )]

                        .leader == address(0x0)

                ) {

                    return false;

                }

            }

        }



        return true;

    }



    function checkTree(address _manager, address _user)

        internal

        view

        returns (bool)

    {

        Account memory manager = accounts[_manager];

        Account memory user = accounts[_user];

        Unit storage unit = units[manager.level.sub(1)].levelUnits[manager

            .childUnitId];



        return unit.childUnitIds.contains(user.parentUnitId);

    }



    function promote(address _user) external {

        Account memory manager = accounts[msg.sender];

        Account storage user = accounts[_user];



        require(

            user.level.add(2) == manager.level,

            "ZuniBadge: manager level is incorrect"

        );

        require(

            checkTree(msg.sender, _user),

            "ZuniBadge: should be in the same tree"

        );

        require(isEligibleForPromote(_user), "ZuniBadge: user is not eligible");



        // update child unit

        Unit storage parentUnit = units[user.level].levelUnits[user

            .parentUnitId];

        parentUnit.leader = _user;

        if (user.level == 0) {

            parentUnit.childUnitIds.remove(user.accountId);

        } else {

            units[user.level - 1].levelUnits[user.childUnitId].leader = address(

                0x0

            );

        }



        // update account

        user.level = user.level.add(1);

        user.claimedLevel = false;

        user.childUnitId = user.parentUnitId;

        user.parentUnitId = manager.childUnitId;

        user.promoteTimes.push(now);

    }



    function promoteByAdmin(address _user) external onlyRankAdmin {

        Account storage user = accounts[_user];



        require(isEligibleForPromote(_user), "ZuniBadge: user is not eligible");



        // update child unit

        Unit storage parentUnit = units[user.level].levelUnits[user

            .parentUnitId];

        parentUnit.leader = _user;

        if (user.level == 0) {

            parentUnit.childUnitIds.remove(user.accountId);

        } else {

            units[user.level - 1].levelUnits[user.childUnitId].leader = address(

                0x0

            );

        }



        // update account

        user.level = user.level.add(1);

        user.claimedLevel = false;

        user.childUnitId = user.parentUnitId;

        user.parentUnitId = 0;

        uint256 promoteTime = now;

        user.promoteTimes.push(promoteTime);



        require(createOrJoinUnit(_user));



        if (topLevel < user.level && user.level >= 2) {

            topLevel = user.level;

            distributeTimes.push(promoteTime);

        }

    }



    function claimLevel() external {

        Account storage account = accounts[msg.sender];



        require(account.level > 0 && account.claimedLevel == false);



        account.claimedLevel = true;

    }



    function claimWarrantBadge(uint256 _warrantId) external {

        Account storage account = accounts[msg.sender];



        for (uint256 i = 0; i < account.warrantBadges.length; i++) {

            if (account.warrantBadges[i].id == _warrantId) {

                require(

                    account.warrantBadges[i].collectedAmount >

                        account.warrantBadges[i].claimedAmount,

                    "ZuniBadge: warrant badge is claimed already"

                );



                account.warrantBadges[i].claimedAmount = account

                    .warrantBadges[i]

                    .collectedAmount;

                account.pendingWarrantReward = account.pendingWarrantReward.add(

                    account.warrantBadges[i].pendingReward

                );

                account.warrantBadges[i].pendingReward = 0;



                return;

            }

        }



        revert("ZuniBadge: warrant badge does not exit");

    }



    function rewardMultiplier(uint256 distIndex, uint256 levelIndex)

        internal

        view

        returns (uint256)

    {

        uint256 maxDistEvents = maxLevel.sub(2);



        if (levelIndex > distIndex) {

            return 0;

        }



        if (maxDistEvents.sub(levelIndex) == 0) {

            return REWARD_MUL_DECIMAL;

        }



        return REWARD_MUL_DECIMAL >> (distIndex.sub(levelIndex).add(1));

    }



    function _availableRankReward(address _user)

        internal

        view

        returns (uint256)

    {

        Account memory user = accounts[_user];

        uint256 totalReward = 0;

        uint256 maxDistEvents = maxLevel.sub(2);



        for (uint256 i = 0; i < distributeTimes.length; i++) {

            for (uint256 j = 0; j < user.promoteTimes.length; j++) {

                if (user.promoteTimes[j] <= distributeTimes[i]) {

                    totalReward = totalReward.add(

                        levelWeight[j]

                            .mul(

                            rewardMultiplier(

                                maxDistEvents == i.add(1)

                                    ? maxDistEvents.sub(1)

                                    : i.add(1),

                                j.add(1)

                            )

                        )

                            .div(REWARD_MUL_DECIMAL)

                    );

                }

            }

        }

        return totalReward.sub(user.claimedRankReward);

    }



    function availableReward(address _user) public view returns (uint256) {

        Account memory user = accounts[_user];

        uint256 availableRankReward = _availableRankReward(_user);



        return availableRankReward.add(user.pendingWarrantReward);

    }



    function claimReward() external {

        require(

            address(zuniTreasury) != address(0x0),

            "ZuniBadge: zuniTreasury didn't set yet"

        );



        Account storage user = accounts[msg.sender];

        uint256 availableRankReward = _availableRankReward(msg.sender);

        uint256 available = availableRankReward.add(user.pendingWarrantReward);



        if (available > 0) {

            user.claimedRankReward = user.claimedRankReward.add(

                availableRankReward

            );

            user.cliamedWarrantReward = user.cliamedWarrantReward.add(

                user.pendingWarrantReward

            );

            user.pendingWarrantReward = 0;

            zuniTreasury.giveZuniReward(msg.sender, available);

        }

    }



    function accountInfo(address _user)

        public

        view

        returns (

            uint256,

            uint256,

            uint256,

            uint256,

            uint256,

            bool,

            uint256

        )

    {

        Account memory account = accounts[_user];

        return (

            account.accountId,

            account.level,

            account.interest,

            account.childUnitId,

            account.parentUnitId,

            account.claimedLevel,

            account.claimedRankReward.add(account.cliamedWarrantReward)

        );

    }



    function accountWarrants(address _user)

        public

        view

        returns (WarrantBadge[] memory)

    {

        return accounts[_user].warrantBadges;

    }



    function unitInfo(uint256 _level, uint256 _unitId)

        public

        view

        returns (

            uint256,

            address,

            uint256

        )

    {

        Unit storage unit = units[_level].levelUnits[_unitId];

        return (unit.interest, unit.leader, unit.childUnitIds.length());

    }



    function unitMembers(uint256 _level, uint256 _unitId)

        public

        view

        returns (

            address leader,

            uint256 length,

            address[4] memory members // assume unitSize <= 4

        )

    {

        Unit storage unit = units[_level].levelUnits[_unitId];

        leader = unit.leader;

        length = unit.childUnitIds.length();

        if (_level == 0) {

            for (uint256 i = 0; i < length; i++) {

                members[i] = accountsById[unit.childUnitIds.at(i)];

            }

        } else {

            uint256 subLevel = _level.sub(1);

            for (uint256 i = 0; i < length; i++) {

                Unit memory subUnit = units[subLevel].levelUnits[unit

                    .childUnitIds

                    .at(i)];

                members[i] = subUnit.leader;

            }

        }

    }



    function promotableSubUnits(uint256 _level, uint256 _uintId)

        public

        view

        returns (

            uint256 length,

            uint256[4] memory subUnitIds // assume unitSize <= 4

        )

    {

        if (_level > 0) {

            Unit storage unit = units[_level].levelUnits[_uintId];

            uint256 subLevel = _level.sub(1);

            for (uint256 i = 0; i < unit.childUnitIds.length(); i++) {

                uint256 subUnitId = unit.childUnitIds.at(i);

                Unit storage subUnit = units[subLevel].levelUnits[subUnitId];

                if (

                    subUnit.leader == address(0x0) &&

                    subUnit.childUnitIds.length() == unitSize

                ) {

                    subUnitIds[length] = subUnitId;

                    length = length.add(1);

                }

            }

        }

    }

}

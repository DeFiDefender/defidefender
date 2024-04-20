pragma solidity 0.6.6;



// File: @openzeppelin/contracts/math/SafeMath.sol





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



// File: @openzeppelin/contracts/math/SignedSafeMath.sol







/**

 * @title SignedSafeMath

 * @dev Signed math operations with safety checks that revert on error.

 */

library SignedSafeMath {

    int256 constant private _INT256_MIN = -2**255;



    /**

     * @dev Multiplies two signed integers, reverts on overflow.

     */

    function mul(int256 a, int256 b) internal pure returns (int256) {

        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the

        // benefit is lost if 'b' is also tested.

        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522

        if (a == 0) {

            return 0;

        }



        require(!(a == -1 && b == _INT256_MIN), "SignedSafeMath: multiplication overflow");



        int256 c = a * b;

        require(c / a == b, "SignedSafeMath: multiplication overflow");



        return c;

    }



    /**

     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.

     */

    function div(int256 a, int256 b) internal pure returns (int256) {

        require(b != 0, "SignedSafeMath: division by zero");

        require(!(b == -1 && a == _INT256_MIN), "SignedSafeMath: division overflow");



        int256 c = a / b;



        return c;

    }



    /**

     * @dev Subtracts two signed integers, reverts on overflow.

     */

    function sub(int256 a, int256 b) internal pure returns (int256) {

        int256 c = a - b;

        require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");



        return c;

    }



    /**

     * @dev Adds two signed integers, reverts on overflow.

     */

    function add(int256 a, int256 b) internal pure returns (int256) {

        int256 c = a + b;

        require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");



        return c;

    }

}



// File: @openzeppelin/contracts/utils/SafeCast.sol









/**

 * @dev Wrappers over Solidity's uintXX casting operators with added overflow

 * checks.

 *

 * Downcasting from uint256 in Solidity does not revert on overflow. This can

 * easily result in undesired exploitation or bugs, since developers usually

 * assume that overflows raise errors. `SafeCast` restores this intuition by

 * reverting the transaction when such an operation overflows.

 *

 * Using this library instead of the unchecked operations eliminates an entire

 * class of bugs, so it's recommended to use it always.

 *

 * Can be combined with {SafeMath} to extend it to smaller types, by performing

 * all math on `uint256` and then downcasting.

 */

library SafeCast {



    /**

     * @dev Returns the downcasted uint128 from uint256, reverting on

     * overflow (when the input is greater than largest uint128).

     *

     * Counterpart to Solidity's `uint128` operator.

     *

     * Requirements:

     *

     * - input must fit into 128 bits

     */

    function toUint128(uint256 value) internal pure returns (uint128) {

        require(value < 2**128, "SafeCast: value doesn\\'t fit in 128 bits");

        return uint128(value);

    }



    /**

     * @dev Returns the downcasted uint64 from uint256, reverting on

     * overflow (when the input is greater than largest uint64).

     *

     * Counterpart to Solidity's `uint64` operator.

     *

     * Requirements:

     *

     * - input must fit into 64 bits

     */

    function toUint64(uint256 value) internal pure returns (uint64) {

        require(value < 2**64, "SafeCast: value doesn\\'t fit in 64 bits");

        return uint64(value);

    }



    /**

     * @dev Returns the downcasted uint32 from uint256, reverting on

     * overflow (when the input is greater than largest uint32).

     *

     * Counterpart to Solidity's `uint32` operator.

     *

     * Requirements:

     *

     * - input must fit into 32 bits

     */

    function toUint32(uint256 value) internal pure returns (uint32) {

        require(value < 2**32, "SafeCast: value doesn\\'t fit in 32 bits");

        return uint32(value);

    }



    /**

     * @dev Returns the downcasted uint16 from uint256, reverting on

     * overflow (when the input is greater than largest uint16).

     *

     * Counterpart to Solidity's `uint16` operator.

     *

     * Requirements:

     *

     * - input must fit into 16 bits

     */

    function toUint16(uint256 value) internal pure returns (uint16) {

        require(value < 2**16, "SafeCast: value doesn\\'t fit in 16 bits");

        return uint16(value);

    }



    /**

     * @dev Returns the downcasted uint8 from uint256, reverting on

     * overflow (when the input is greater than largest uint8).

     *

     * Counterpart to Solidity's `uint8` operator.

     *

     * Requirements:

     *

     * - input must fit into 8 bits.

     */

    function toUint8(uint256 value) internal pure returns (uint8) {

        require(value < 2**8, "SafeCast: value doesn\\'t fit in 8 bits");

        return uint8(value);

    }



    /**

     * @dev Converts a signed int256 into an unsigned uint256.

     *

     * Requirements:

     *

     * - input must be greater than or equal to 0.

     */

    function toUint256(int256 value) internal pure returns (uint256) {

        require(value >= 0, "SafeCast: value must be positive");

        return uint256(value);

    }



    /**

     * @dev Converts an unsigned uint256 into a signed int256.

     *

     * Requirements:

     *

     * - input must be less than or equal to maxInt256.

     */

    function toInt256(uint256 value) internal pure returns (int256) {

        require(value < 2**255, "SafeCast: value doesn't fit in an int256");

        return int256(value);

    }

}



// File: contracts/math/UseSafeMath.sol















/**

 * @notice ((a - 1) / b) + 1 = (a + b -1) / b

 * for example a.add(10**18 -1).div(10**18) = a.sub(1).div(10**18) + 1

 */



library SafeMathDivRoundUp {

    using SafeMath for uint256;



    function divRoundUp(

        uint256 a,

        uint256 b,

        string memory errorMessage

    ) internal pure returns (uint256) {

        if (a == 0) {

            return 0;

        }

        require(b > 0, errorMessage);

        return ((a - 1) / b) + 1;

    }



    function divRoundUp(uint256 a, uint256 b) internal pure returns (uint256) {

        return divRoundUp(a, b, "SafeMathDivRoundUp: modulo by zero");

    }

}





/**

 * @title UseSafeMath

 * @dev One can use SafeMath for not only uint256 but also uin64 or uint16,

 * and also can use SafeCast for uint256.

 * For example:

 *   uint64 a = 1;

 *   uint64 b = 2;

 *   a = a.add(b).toUint64() // `a` become 3 as uint64

 * In additionally, one can use SignedSafeMath and SafeCast.toUint256(int256) for int256.

 * In the case of the operation to the uint64 value, one need to cast the value into int256 in

 * advance to use `sub` as SignedSafeMath.sub not SafeMath.sub.

 * For example:

 *   int256 a = 1;

 *   uint64 b = 2;

 *   int256 c = 3;

 *   a = a.add(int256(b).sub(c)); // `a` become 0 as int256

 *   b = a.toUint256().toUint64(); // `b` become 0 as uint64

 */

abstract contract UseSafeMath {

    using SafeMath for uint256;

    using SafeMathDivRoundUp for uint256;

    using SafeMath for uint64;

    using SafeMathDivRoundUp for uint64;

    using SafeMath for uint16;

    using SignedSafeMath for int256;

    using SafeCast for uint256;

    using SafeCast for int256;

}



// File: @openzeppelin/contracts/token/ERC20/IERC20.sol







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



// File: contracts/StableCoinInterface.sol











interface StableCoinInterface is IERC20 {

    event LogIsAcceptableSBT(bytes32 indexed bondID, bool isAcceptable);



    event LogMintIDOL(

        bytes32 indexed bondID,

        address indexed owner,

        bytes32 poolID,

        uint256 obtainIDOLAmount,

        uint256 poolIDOLAmount

    );



    event LogBurnIDOL(

        bytes32 indexed bondID, // poolID?

        address indexed owner,

        uint256 burnIDOLAmount,

        uint256 unlockSBTAmount

    );



    event LogReturnLockedPool(

        bytes32 indexed poolID,

        address indexed owner,

        uint64 backIDOLAmount

    );



    event LogLambda(

        bytes32 indexed poolID,

        uint64 settledAverageAuctionPrice,

        uint256 totalSupply,

        uint256 lockedSBTValue

    );



    function getPoolInfo(bytes32 poolID)

        external

        view

        returns (

            uint64 lockedSBTTotal,

            uint64 unlockedSBTTotal,

            uint64 lockedPoolIDOLTotal,

            uint64 burnedIDOLTotal,

            uint64 soldSBTTotalInAuction,

            uint64 paidIDOLTotalInAuction,

            uint64 settledAverageAuctionPrice,

            bool isAllAmountSoldInAuction

        );



    function solidValueTotal() external view returns (uint256 solidValue);



    function isAcceptableSBT(bytes32 bondID) external returns (bool ok);



    function mint(

        bytes32 bondID,

        address recipient,

        uint64 lockAmount

    )

        external

        returns (

            bytes32 poolID,

            uint64 obtainIDOLAmount,

            uint64 poolIDOLAmount

        );



    function burnFrom(address account, uint256 amount) external;



    function unlockSBT(bytes32 bondID, uint64 burnAmount)

        external

        returns (uint64 rewardSBT);



    function startAuctionOnMaturity(bytes32 bondID) external;



    function startAuctionByMarket(bytes32 bondID) external;



    function setSettledAverageAuctionPrice(

        bytes32 bondID,

        uint64 totalPaidIDOL,

        uint64 SBTAmount,

        bool isLast

    ) external;



    function calcSBT2IDOL(uint256 solidBondAmount)

        external

        view

        returns (uint256 IDOLAmount);



    function returnLockedPool(bytes32[] calldata poolIDs)

        external

        returns (uint64 IDOLAmount);



    function returnLockedPoolTo(bytes32[] calldata poolIDs, address account)

        external

        returns (uint64 IDOLAmount);



    function generatePoolID(bytes32 bondID, uint64 count)

        external

        pure

        returns (bytes32 poolID);



    function getCurrentPoolID(bytes32 bondID)

        external

        view

        returns (bytes32 poolID);



    function getLockedPool(address user, bytes32 poolID)

        external

        view

        returns (uint64, uint64);

}



// File: contracts/util/Time.sol









abstract contract Time {

    function _getBlockTimestampSec()

        internal

        view

        returns (uint256 unixtimesec)

    {

        unixtimesec = now; // solium-disable-line security/no-block-members

    }

}



// File: @openzeppelin/contracts/GSN/Context.sol







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



    function _msgSender() internal view virtual returns (address payable) {

        return msg.sender;

    }



    function _msgData() internal view virtual returns (bytes memory) {

        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691

        return msg.data;

    }

}



// File: @openzeppelin/contracts/utils/Address.sol







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



// File: @openzeppelin/contracts/token/ERC20/ERC20.sol















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

}



// File: @openzeppelin/contracts/math/Math.sol







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



// File: contracts/solidBondSafety/SolidBondSafety.sol













// This contract is used for calculating minimum threshold acceptable strike price (relative to the current oracle price)

// for the SBT with the time to maturity and the volatility from oracle.

// It is derived from the risk appetite of this protocol.

// For volatile SBT due to the long time to maturity or the underlying ETH volatility,

// the minimum threshold acceptable strike price needs to increase in order to mitigate the risk of emergency auction.

// The policy in this protocol is to equalize the risk of acceptable SBT over the different time to maturity or the underlying ETH volatility.

// The threshold is thus derived from solving the black-scholes formula with a linear approximation technique.

// Even in the approximation of the formula, there remains square root of time, which is tricky to handle in solidity.

// Hence, we deal with the value in the squared form of the value.

// In the following notations, for example, vvtE16 represents v^2 * t * 10^16.

abstract contract SolidBondSafety is UseSafeMath, Time {

    /// @notice The return values of getEmergencyBorderInfo are intermediate values

    /// used for checking if the SBT is acceptable to the IDOL contract.

    /// Let f(x) = a*x + b be the function defined below:

    /// f(x) =            1.1    for 0      <= x <= 0.3576

    /// f(x) =  1.52 x +  0.5564 for 0.3576 < x <= 0.7751

    /// f(x) =  6.4  x -  3.226  for 0.7751 < x <= 1.1562

    /// f(x) = 14.27 x - 12.3256 for 1.1562 < x <= 1.416

    /// f(x) = 29.13 x - 33.3676 for 1.416  < x <= 1.6257

    /// f(x) = 53.15 x - 72.4165 for 1.6257 < x <= 1.8

    /// Then, we define getEmergencyBorderInfo(x^2 * 10^8) = (a^2 * 10^4, b * 10^4).

    /// @param  xxE8 is multiply 10^8 with the square of x

    /// @return aaE4 is multiply 10000 with the square of a

    /// @return bE4  is multiply 10000 with b

    function getEmergencyBorderInfo(uint256 xxE8)

        public

        pure

        returns (int256 aaE4, int256 bE4)

    {

        if (xxE8 <= 3576 * 3576) {

            return (0, 11000);

        } else if (xxE8 <= 7751 * 7751) {

            return (152 * 152, 5564);

        } else if (xxE8 <= 11562 * 11562) {

            return (640 * 640, -32260);

        } else if (xxE8 <= 14160 * 14160) {

            return (1427 * 1427, -123256);

        } else if (xxE8 <= 16257 * 16257) {

            return (2913 * 2913, -333676);

        } else if (xxE8 <= 18000 * 18000) {

            return (5315 * 5315, -724165);

        } else {

            revert("not acceptable");

        }

    }



    /// @param rateETH2USD S * 10^8 (USD/ETH)

    /// @param solidBondStrikePrice K * 10^4 (USD/SBT)

    /// @param volatility v * 10^8

    /// @param untilMaturity t (= T * 365 * 86400)

    // isInEmergency checks if the SBT should be put into emergency auction.

    // The condition is verified by utilizing approximate form of black-scholes formula.

    function isInEmergency(

        uint256 rateETH2USD,

        uint256 solidBondStrikePrice,

        uint256 volatility,

        uint256 untilMaturity

    ) public pure returns (bool) {

        uint256 vE8 = volatility;

        if (vE8 > 2 * 10**8) {

            vE8 = 2 * 10**8; // The volatility is too high.

        }

        if (untilMaturity >= 12 weeks) {

            return true; // The period until maturity is too long.

        }

        uint256 vvtE16 = vE8.mul(vE8).mul(untilMaturity);



        uint256 xxE8 = vvtE16 / (64 * 10**6 * 86400 * 365); // 1.25^2 / 10^8 = 1 / (64 * 10^6)

        (int256 aaE4, int256 bE4) = getEmergencyBorderInfo(xxE8);

        int256 sE8 = rateETH2USD.toInt256();

        int256 kE4 = solidBondStrikePrice.toInt256();

        int256 cE8 = sE8.sub(bE4.mul(kE4));

        // int256 lE28 = cE8.mul(cE8).mul(20183040 * 10**12);

        int256 rE28 = int256(vvtE16).mul(aaE4).mul(kE4).mul(kE4);

        bool isDanger = cE8 <= 0 || cE8.mul(cE8).mul(20183040 * 10**12) <= rE28;

        return isDanger;

    }



    /// @param rateETH2USD S * 10^8 (USD/ETH)

    /// @param solidBondStrikePrice K * 10^4  (USD/SBT)

    /// @param volatility v * 10^8

    /// @param untilMaturity t (= T * 365 * 86400)

    // isDangerSolidBond checks if the SBT is acceptable to be a part of IDOL.

    // The condition is verified by utilizing approximate form of black-scholes formula.

    // This condition is more strict than the condition for triggering emergency auction described in isInEmergency function above.

    function isDangerSolidBond(

        uint256 rateETH2USD,

        uint256 solidBondStrikePrice,

        uint256 volatility,

        uint256 untilMaturity

    ) public pure returns (bool) {

        if (

            solidBondStrikePrice * 5 * 10**4 < rateETH2USD * 2 &&

            untilMaturity < 2 weeks

        ) {

            return false;

        } else if (volatility > 2 * 10**8) {

            return true; // The volatility is too high.

        }

        if (untilMaturity >= 12 weeks) {

            return true; // The period until maturity is too long.

        }

        uint256 vvtE16 = volatility.mul(volatility).mul(untilMaturity);



        uint256 xxE8 = vvtE16 / (64 * 10**6 * 86400 * 365); // 1.25^2 / 10^8 = 1 / (64 * 10^6)

        (int256 aaE4, int256 bE4) = getEmergencyBorderInfo(xxE8);

        //                                            S/K <= 1.5f(1.25*v*sqrt(T))

        // <=>                                        S/K <= 1.5(1.25a*v*sqrt(T) + b)

        // <=>                                 (2S - 3bK) <= (3.75aKv) * sqrt(T)

        // if 2S > 3bK,

        //                                   (2S - 3bK)^2 <= (3.75aKv)^2 * t / 365 / 86400

        // <=>                       20183040(2S - 3bK)^2 <= 9t(aKv)^2

        // <=> 20183040 * 10^12(10^8 * 2S - 10^8 * 3bK)^2 <= 9 * 10000a^2 * (10000K)^2 * t(10^8 * v)^2

        int256 sE8 = rateETH2USD.toInt256();

        int256 kE4 = solidBondStrikePrice.toInt256();

        int256 cE8 = sE8.mul(2).sub(bE4.mul(kE4).mul(3));

        // int256 lE28 = cE8.mul(cE8).mul(20183040 * 10**12);

        int256 rE28 = int256(vvtE16).mul(aaE4).mul(kE4).mul(kE4).mul(9);

        bool isDanger = cE8 <= 0 || cE8.mul(cE8).mul(20183040 * 10**12) <= rE28;

        return isDanger;

    }

}



// File: contracts/AuctionTimeControlInterface.sol









interface AuctionTimeControlInterface {

    enum TimeControlFlag {

        BEFORE_AUCTION_FLAG,

        ACCEPTING_BIDS_PERIOD_FLAG,

        REVEALING_BIDS_PERIOD_FLAG,

        RECEIVING_SBT_PERIOD_FLAG,

        AFTER_AUCTION_FLAG

    }



    function listAuction(uint256 timestamp)

        external

        view

        returns (bytes32[] memory);



    function getTimeControlFlag(bytes32 auctionID)

        external

        view

        returns (TimeControlFlag);



    function isInPeriod(bytes32 auctionID, TimeControlFlag flag)

        external

        view

        returns (bool);



    function isAfterPeriod(bytes32 auctionID, TimeControlFlag flag)

        external

        view

        returns (bool);

}



// File: contracts/AuctionInterface.sol











interface AuctionInterface is AuctionTimeControlInterface {

    event LogStartAuction(

        bytes32 indexed auctionID,

        bytes32 bondID,

        uint256 auctionedAmount

    );



    event LogCancelBid(

        bytes32 indexed auctionID,

        address indexed bidder,

        bytes32 secret,

        uint256 returnedIDOLAmount

    );



    event LogAuctionResult(

        bytes32 indexed auctionID,

        address indexed bidder,

        uint256 SBTAmountOfReward,

        uint256 IDOLAmountOfPayment,

        uint256 IDOLAmountOfChange

    );



    event LogCloseAuction(

        bytes32 indexed auctionID,

        bool isLast,

        bytes32 nextAuctionID

    );



    function ongoingAuctionSBTTotal(bytes32 auctionID)

        external

        view

        returns (uint64 ongoingSBTAmountE8);



    function startAuction(

        bytes32 bondID,

        uint64 auctionAmount,

        bool isEmergency

    ) external returns (bytes32 auctonID);



    function cancelBid(bytes32 auctionID, bytes32 secret)

        external

        returns (uint64 returnedIDOLAmount);



    function makeAuctionResult(

        bytes32 auctionID,

        uint64 myLowestPrice,

        uint64[] calldata winnerBids,

        uint64[] calldata loserBids

    )

        external

        returns (

            uint64 winnerAmount,

            uint64 toPay,

            uint64 IDOLAmountOfChange

        );



    function closeAuction(bytes32 auctionID)

        external

        returns (bool isLast, bytes32 nextAuctionID);



    function receiveUnrevealedBidDistribution(bytes32 auctionID, bytes32 secret)

        external

        returns (bool success);



    function getCurrentAuctionID(bytes32 bondID)

        external

        view

        returns (bytes32 auctionID);



    function generateAuctionID(bytes32 bondID, uint256 auctionCount)

        external

        pure

        returns (bytes32 auctionID);



    function listBondIDFromAuctionID(bytes32[] calldata auctionIDs)

        external

        view

        returns (bytes32[] memory bondIDs);



    function getAuctionStatus(bytes32 auctionID)

        external

        view

        returns (

            uint256 closingTime,

            uint64 auctionAmount,

            uint64 rewardedAmount,

            uint64 totalSBTAmountBid,

            bool isEmergency,

            bool doneFinalizeWinnerAmount,

            bool doneSortPrice,

            uint64 lowestBidPriceDeadLine,

            uint64 highestBidPriceDeadLine,

            uint64 totalSBTAmountPaidForUnrevealed

        );



    function getWeeklyAuctionStatus(uint256 weekNumber)

        external

        view

        returns (uint256[] memory weeklyAuctionStatus);



    function calcWinnerAmount(

        bytes32 auctionID,

        address sender,

        uint64[] calldata winnerBids

    ) external view returns (uint64 winnerAmount);



    function calcBillAndCheckLoserBids(

        bytes32 auctionID,

        address sender,

        uint64 winnerAmountInput,

        uint64 myLowestPrice,

        uint64[] calldata myLoseBids

    ) external view returns (uint64 paymentAmount);



    function getAuctionCount(bytes32 bondID)

        external

        view

        returns (uint256 auctionCount);

}



// File: contracts/AuctionTimeControl.sol













contract AuctionTimeControl is Time, AuctionTimeControlInterface {

    uint256 internal immutable MIN_NORMAL_AUCTION_PERIOD;

    uint256 internal immutable MIN_EMERGENCY_AUCTION_PERIOD;

    uint256 internal immutable NORMAL_AUCTION_REVEAL_SPAN;

    uint256 internal immutable EMERGENCY_AUCTION_REVEAL_SPAN;

    uint256 internal immutable AUCTION_WITHDRAW_SPAN;

    uint256 internal immutable EMERGENCY_AUCTION_WITHDRAW_SPAN;



    TimeControlFlag internal constant BEFORE_AUCTION_FLAG = TimeControlFlag

        .BEFORE_AUCTION_FLAG;

    TimeControlFlag internal constant ACCEPTING_BIDS_PERIOD_FLAG = TimeControlFlag

        .ACCEPTING_BIDS_PERIOD_FLAG;

    TimeControlFlag internal constant REVEALING_BIDS_PERIOD_FLAG = TimeControlFlag

        .REVEALING_BIDS_PERIOD_FLAG;

    TimeControlFlag internal constant RECEIVING_SBT_PERIOD_FLAG = TimeControlFlag

        .RECEIVING_SBT_PERIOD_FLAG;

    TimeControlFlag internal constant AFTER_AUCTION_FLAG = TimeControlFlag

        .AFTER_AUCTION_FLAG;



    /**

     * @dev Get whether the auction is in emergency or not.

     */

    mapping(bytes32 => bool) public isAuctionEmergency;



    /**

     * @dev The end time that the auction accepts bids.

     * The zero value indicates the auction is not held.

     */

    mapping(bytes32 => uint256) public auctionClosingTime;



    /**

     * @dev The contents in this internal storage variable can be seen by listAuction function.

     */

    mapping(uint256 => bytes32[]) internal _weeklyAuctionList;



    constructor(

        uint256 minNormalAuctionPeriod,

        uint256 minEmergencyAuctionPeriod,

        uint256 normalAuctionRevealSpan,

        uint256 emergencyAuctionRevealSpan,

        uint256 auctionWithdrawSpan,

        uint256 emergencyAuctionWithdrawSpan

    ) public {

        MIN_NORMAL_AUCTION_PERIOD = minNormalAuctionPeriod;

        MIN_EMERGENCY_AUCTION_PERIOD = minEmergencyAuctionPeriod;

        NORMAL_AUCTION_REVEAL_SPAN = normalAuctionRevealSpan;

        EMERGENCY_AUCTION_REVEAL_SPAN = emergencyAuctionRevealSpan;

        AUCTION_WITHDRAW_SPAN = auctionWithdrawSpan;

        EMERGENCY_AUCTION_WITHDRAW_SPAN = emergencyAuctionWithdrawSpan;

    }



    /**

     * @dev Get auctions which will close within the week.

     */

    function listAuction(uint256 weekNumber)

        public

        override

        view

        returns (bytes32[] memory)

    {

        return _weeklyAuctionList[weekNumber];

    }



    /**

     * @notice Gets the period the auction is currently in.

     * This function returns 0-4 corresponding to its period.

     */

    function getTimeControlFlag(bytes32 auctionID)

        public

        override

        view

        returns (TimeControlFlag)

    {

        uint256 closingTime = auctionClosingTime[auctionID];



        // Note that the auction span differs based on whether the auction is in emergency or not.

        bool isEmergency = isAuctionEmergency[auctionID];

        uint256 revealSpan = NORMAL_AUCTION_REVEAL_SPAN;

        uint256 withdrawSpan = AUCTION_WITHDRAW_SPAN;

        if (isEmergency) {

            revealSpan = EMERGENCY_AUCTION_REVEAL_SPAN;

            withdrawSpan = EMERGENCY_AUCTION_WITHDRAW_SPAN;

        }



        uint256 nowTime = _getBlockTimestampSec();

        if (closingTime == 0) {

            return BEFORE_AUCTION_FLAG;

        } else if (nowTime <= closingTime) {

            return ACCEPTING_BIDS_PERIOD_FLAG;

        } else if (nowTime < closingTime + revealSpan) {

            return REVEALING_BIDS_PERIOD_FLAG;

        } else if (nowTime < closingTime + revealSpan + withdrawSpan) {

            return RECEIVING_SBT_PERIOD_FLAG;

        } else {

            return AFTER_AUCTION_FLAG;

        }

    }



    /**

     * @notice This function returns whether or not the auction is in the period indicated

     * by the flag.

     */

    function isInPeriod(bytes32 auctionID, TimeControlFlag flag)

        public

        override

        view

        returns (bool)

    {

        return getTimeControlFlag(auctionID) == flag;

    }



    /**

     * @notice Returns whether or not the auction is in or after the period indicated

     * by the flag.

     */

    function isAfterPeriod(bytes32 auctionID, TimeControlFlag flag)

        public

        override

        view

        returns (bool)

    {

        return getTimeControlFlag(auctionID) >= flag;

    }



    /**

     * @dev Calculates and registers the end time of the period in which the auction accepts bids

     * (= closingTime). The period in which bids are revealed follows after this time.

     */

    function _setAuctionClosingTime(bytes32 auctionID, bool isEmergency)

        internal

    {

        uint256 closingTime;



        if (isEmergency) {

            closingTime =

                ((_getBlockTimestampSec() +

                    MIN_EMERGENCY_AUCTION_PERIOD +

                    5 minutes -

                    1) / 5 minutes) *

                (5 minutes);

        } else {

            closingTime =

                ((_getBlockTimestampSec() +

                    MIN_NORMAL_AUCTION_PERIOD +

                    1 hours -

                    1) / 1 hours) *

                (1 hours);

        }

        _setAuctionClosingTime(auctionID, isEmergency, closingTime);

    }



    /**

     * @dev Registers the end time of the period in which the auction accepts bids (= closingTime).

     * The period in which bids are revealed follows after this time.

     */

    function _setAuctionClosingTime(

        bytes32 auctionID,

        bool isEmergency,

        uint256 closingTime

    ) internal {

        isAuctionEmergency[auctionID] = isEmergency;

        auctionClosingTime[auctionID] = closingTime;

        uint256 weekNumber = closingTime / (1 weeks);

        _weeklyAuctionList[weekNumber].push(auctionID);

    }

}



// File: contracts/BondMakerInterface.sol









interface BondMakerInterface {

    event LogNewBond(

        bytes32 indexed bondID,

        address bondTokenAddress,

        uint64 stableStrikePrice,

        bytes32 fnMapID

    );



    event LogNewBondGroup(uint256 indexed bondGroupID);



    event LogIssueNewBonds(

        uint256 indexed bondGroupID,

        address indexed issuer,

        uint256 amount

    );



    event LogReverseBondToETH(

        uint256 indexed bondGroupID,

        address indexed owner,

        uint256 amount

    );



    event LogExchangeEquivalentBonds(

        address indexed owner,

        uint256 indexed inputBondGroupID,

        uint256 indexed outputBondGroupID,

        uint256 amount

    );



    event LogTransferETH(

        address indexed from,

        address indexed to,

        uint256 value

    );



    function registerNewBond(uint256 maturity, bytes calldata fnMap)

        external

        returns (

            bytes32 bondID,

            address bondTokenAddress,

            uint64 solidStrikePrice,

            bytes32 fnMapID

        );



    function registerNewBondGroup(

        bytes32[] calldata bondIDList,

        uint256 maturity

    ) external returns (uint256 bondGroupID);



    function issueNewBonds(uint256 bondGroupID)

        external

        payable

        returns (uint256 amount);



    function reverseBondToETH(uint256 bondGroupID, uint256 amount)

        external

        returns (bool success);



    function exchangeEquivalentBonds(

        uint256 inputBondGroupID,

        uint256 outputBondGroupID,

        uint256 amount,

        bytes32[] calldata exceptionBonds

    ) external returns (bool);



    function liquidateBond(uint256 bondGroupID, uint256 oracleHintID) external;



    function getBond(bytes32 bondID)

        external

        view

        returns (

            address bondAddress,

            uint256 maturity,

            uint64 solidStrikePrice,

            bytes32 fnMapID

        );



    function getFnMap(bytes32 fnMapID)

        external

        view

        returns (bytes memory fnMap);



    function getBondGroup(uint256 bondGroupID)

        external

        view

        returns (bytes32[] memory bondIDs, uint256 maturity);



    function generateBondID(uint256 maturity, bytes calldata functionHash)

        external

        pure

        returns (bytes32 bondID);

}



// File: contracts/UseBondMaker.sol











abstract contract UseBondMaker {

    BondMakerInterface internal immutable _bondMakerContract;



    constructor(address contractAddress) public {

        require(

            contractAddress != address(0),

            "contract should be non-zero address"

        );

        _bondMakerContract = BondMakerInterface(payable(contractAddress));

    }

}



// File: contracts/UseStableCoin.sol











abstract contract UseStableCoin {

    StableCoinInterface internal immutable _IDOLContract;



    constructor(address contractAddress) public {

        require(

            contractAddress != address(0),

            "contract should be non-zero address"

        );

        _IDOLContract = StableCoinInterface(contractAddress);

    }



    function _transferIDOLFrom(

        address from,

        address to,

        uint256 amount

    ) internal {

        _IDOLContract.transferFrom(from, to, amount);

    }



    function _transferIDOL(address to, uint256 amount) internal {

        _IDOLContract.transfer(to, amount);

    }



    function _transferIDOL(

        address to,

        uint256 amount,

        string memory errorMessage

    ) internal {

        require(_IDOLContract.balanceOf(address(this)) >= amount, errorMessage);

        _IDOLContract.transfer(to, amount);

    }

}



// File: contracts/auction/AuctionSecret.sol











interface AuctionSecretInterface {

        function auctionSecret(

        bytes32 auctionID,

        bytes32 secret

    ) external view returns (

        address sender,

        uint64 amount,

        uint64 IDOLamount

    );

}



abstract contract AuctionSecret is AuctionSecretInterface {

    /**

     * @param sender is the account who set this secret bid.

     * @param amount is target SBT amount.

     * @param IDOLamount is deposited iDOL amount attached to this secret bid.

     */

    struct Secret {

        address sender;

        uint64 amount;

        uint64 IDOLamount;

    }

    mapping(bytes32 => mapping(bytes32 => Secret)) public override auctionSecret;



    function _setSecret(

        bytes32 auctionID,

        bytes32 secret,

        address sender,

        uint64 amount,

        uint64 IDOLamount

    ) internal returns (bool) {

        require(

            auctionSecret[auctionID][secret].sender == address(0),

            "Secret already exists"

        );

        require(sender != address(0), "the zero address cannot set secret");

        auctionSecret[auctionID][secret] = Secret({

            sender: sender,

            amount: amount,

            IDOLamount: IDOLamount

        });

        return true;

    }



    function _removeSecret(bytes32 auctionID, bytes32 secret)

        internal

        returns (bool)

    {

        delete auctionSecret[auctionID][secret];

        return true;

    }

}



// File: contracts/AuctionBoardInterface.sol









interface AuctionBoardInterface is AuctionSecretInterface {

    event LogBidMemo(

        bytes32 indexed auctionID,

        address indexed bidder,

        bytes memo

    );



    event LogInsertBoard(

        bytes32 indexed auctionID,

        address indexed bidder,

        uint64 bidPrice,

        uint64 boardIndex,

        uint64 targetSBTAmount

    );



    event LogAuctionInfoDiff(

        bytes32 indexed auctionID,

        uint64 settledAmount,

        uint64 paidIDOL,

        uint64 rewardedSBT

    );



    function bidWithMemo(

        bytes32 auctionID,

        bytes32 secret,

        uint64 totalSBTAmountBid,

        bytes calldata memo

    ) external returns (uint256 depositedIDOLAmount);



    function revealBids(

        bytes32 auctionID,

        uint64[] calldata bids,

        uint64 random

    ) external;



    function sortBidPrice(bytes32 auctionID, uint64[] calldata sortedPrice)

        external;



    function makeEndInfo(bytes32 auctionID) external;



    function calcBill(

        bytes32 auctionID,

        uint64 winnerAmount,

        uint64 myLowestPrice

    ) external view returns (uint64 paymentAmount);



    function getUnsortedBidPrice(bytes32 auctionID)

        external

        view

        returns (uint64[] memory bidPriceList);



    function getSortedBidPrice(bytes32 auctionID)

        external

        view

        returns (uint64[] memory bidPriceList);



    function getEndInfo(bytes32 auctionID)

        external

        view

        returns (

            uint64 price,

            uint64 boardIndex,

            uint64 loseSBTAmount,

            uint64 auctionEndPriceWinnerSBTAmount

        );



    function getBidderStatus(bytes32 auctionID, address bidder)

        external

        view

        returns (uint64 toBack, bool isIDOLReturned);



    function getBoard(

        bytes32 auctionID,

        uint64 price,

        uint64 boardIndex

    ) external view returns (address bidder, uint64 amount);



    function getBoardStatus(bytes32 auctionID)

        external

        view

        returns (uint64[] memory boardStatus);



    function generateMultiSecret(

        bytes32 auctionID,

        uint64[] calldata bids,

        uint64 random

    ) external pure returns (bytes32 secret);



    function discretizeBidPrice(uint64 price)

        external

        pure

        returns (uint64 discretizedPrice);



    function auctionDisposalInfo(bytes32 auctionID) external view returns (

        uint64 solidStrikePriceIDOLForUnrevealedE8,

        uint64 solidStrikePriceIDOLForRestWinnersE8,

        bool isEndInfoCreated,

        bool isForceToFinalizeWinnerAmountTriggered,

        bool isPriceSorted

    );



    function removeSecret(

        bytes32 auctionID,

        bytes32 secret,

        uint64 subtractAmount

    ) external;



    function auctionRevealInfo(bytes32 auctionID) external view returns (

        uint64 totalSBTAmountBid,

        uint64 totalIDOLSecret,

        uint64 totalIDOLRevealed,

        uint16 auctionPriceCount

    );



    function auctionBoard(

        bytes32 auctionID,

        uint64 bidPrice,

        uint256 boardIndex

    ) external view returns (

        uint64 bidAmount,

        address bidder

    );



    function auctionParticipantInfo(

        bytes32 auctionID,

        address participant

    ) external view returns (

        uint64 auctionLockedIDOLAmountE8,

        uint16 bidCount

    );



    function auctionInfo(

        bytes32 auctionID

    ) external view returns (

        uint64 auctionSettledTotalE8,

        uint64 auctionRewardedTotalE8,

        uint64 auctionPaidTotalE8

    );



    function updateAuctionInfo(

        bytes32 auctionID,

        uint64 settledAmountE8,

        uint64 paidIDOLE8,

        uint64 rewardedSBTE8

    ) external;



    function deleteParticipantInfo(

        bytes32 auctionID,

        address participant

    ) external;

}



// File: contracts/UseAuctionBoard.sol











abstract contract UseAuctionBoard {

    AuctionBoardInterface internal immutable _auctionBoardContract;



    constructor(address contractAddress) public {

        require(

            contractAddress != address(0),

            "contract should be non-zero address"

        );

        _auctionBoardContract = AuctionBoardInterface(contractAddress);

    }

}



// File: contracts/oracle/OracleInterface.sol









// Oracle referenced by OracleProxy must implement this interface.

interface OracleInterface {

    // Returns if oracle is running.

    function alive() external view returns (bool);



    // Returns latest id.

    // The first id is 1 and 0 value is invalid as id.

    // Each price values and theirs timestamps are identified by id.

    // Ids are assigned incrementally to values.

    function latestId() external returns (uint256);



    // Returns latest price value.

    // decimal 8

    function latestPrice() external returns (uint256);



    // Returns timestamp of latest price.

    function latestTimestamp() external returns (uint256);



    // Returns price of id.

    function getPrice(uint256 id) external returns (uint256);



    // Returns timestamp of id.

    function getTimestamp(uint256 id) external returns (uint256);



    function getVolatility() external returns (uint256);

}



// File: contracts/oracle/UseOracle.sol











abstract contract UseOracle {

    OracleInterface internal _oracleContract;



    constructor(address contractAddress) public {

        require(

            contractAddress != address(0),

            "contract should be non-zero address"

        );

        _oracleContract = OracleInterface(contractAddress);

    }



    /// @notice Get the latest USD/ETH price and historical volatility using oracle.

    /// @return rateETH2USDE8 (10^-8 USD/ETH)

    /// @return volatilityE8 (10^-8)

    function _getOracleData()

        internal

        returns (uint256 rateETH2USDE8, uint256 volatilityE8)

    {

        rateETH2USDE8 = _oracleContract.latestPrice();

        volatilityE8 = _oracleContract.getVolatility();



        return (rateETH2USDE8, volatilityE8);

    }



    /// @notice Get the price of the oracle data with a minimum timestamp that does more than input value

    /// when you know the ID you are looking for.

    /// @param timestamp is the timestamp that you want to get price.

    /// @param hintID is the ID of the oracle data you are looking for.

    /// @return rateETH2USDE8 (10^-8 USD/ETH)

    function _getPriceOn(uint256 timestamp, uint256 hintID)

        internal

        returns (uint256 rateETH2USDE8)

    {

        uint256 latestID = _oracleContract.latestId();

        require(

            latestID != 0,

            "system error: the ID of oracle data should not be zero"

        );



        require(hintID != 0, "the hint ID must not be zero");

        uint256 id = hintID;

        if (hintID > latestID) {

            id = latestID;

        }



        require(

            _oracleContract.getTimestamp(id) > timestamp,

            "there is no price data after maturity"

        );



        id--;

        while (id != 0) {

            if (_oracleContract.getTimestamp(id) <= timestamp) {

                break;

            }

            id--;

        }



        return _oracleContract.getPrice(id + 1);

    }

}



// File: contracts/util/TransferETHInterface.sol









interface TransferETHInterface {

    receive() external payable;



    event LogTransferETH(

        address indexed from,

        address indexed to,

        uint256 value

    );

}



// File: contracts/bondToken/BondTokenInterface.sol













interface BondTokenInterface is TransferETHInterface, IERC20 {

    event LogExpire(

        uint128 rateNumerator,

        uint128 rateDenominator,

        bool firstTime

    );



    function mint(address account, uint256 amount)

        external

        returns (bool success);



    function expire(uint128 rateNumerator, uint128 rateDenominator)

        external

        returns (bool firstTime);



    function burn(uint256 amount) external returns (bool success);



    function burnAll() external returns (uint256 amount);



    function isMinter(address account) external view returns (bool minter);



    function getRate()

        external

        view

        returns (uint128 rateNumerator, uint128 rateDenominator);

}



// File: contracts/Auction.sol



























contract Auction is

    UseSafeMath,

    AuctionInterface,

    AuctionTimeControl,

    UseStableCoin,

    UseBondMaker,

    UseAuctionBoard

{

    using Math for uint256;



    uint64 internal constant NO_SKIP_BID = uint64(-1);

    uint64 internal constant SKIP_RECEIVING_WIN_BIDS = uint64(-2);

    uint256 internal constant POOL_AUCTION_COUNT_PADDING = 10**8;



    /**

     * @notice The times of auctions held for the auction ID.

     * @dev The contents in this internal storage variable can be seen by getAuctionCount function.

     */

    mapping(bytes32 => uint256) internal _bondIDAuctionCount;



    /**

     * @notice Get the bond ID from the auction ID.

     */

    mapping(bytes32 => bytes32) public auctionID2BondID;



    /**

     * @dev The contents in this internal storage variable can be seen by getAuctionStatus function.

     * @param ongoingAuctionSBTTotalE8 is the SBT amount put up in the auction.

     * @param lowestBidPriceDeadLineE8 is the minimum bid price in the auction.

     * @param highestBidPriceDeadLineE8 is the maximum bid price in the auction.

     * @param totalSBTAmountPaidForUnrevealedE8 is the SBT Amount allocated for those who had not revealed their own bid.

     */

    struct AuctionConfig {

        uint64 ongoingAuctionSBTTotalE8;

        uint64 lowestBidPriceDeadLineE8;

        uint64 highestBidPriceDeadLineE8;

        uint64 totalSBTAmountPaidForUnrevealedE8;

    }

    mapping(bytes32 => AuctionConfig) internal _auctionConfigList;



    constructor(

        address bondMakerAddress,

        address IDOLAddress,

        address auctionBoardAddress,

        uint256 minNormalAuctionPeriod,

        uint256 minEmergencyAuctionPeriod,

        uint256 normalAuctionRevealSpan,

        uint256 emergencyAuctionRevealSpan,

        uint256 auctionWithdrawSpan,

        uint256 emergencyAuctionWithdrawSpan

    )

        public

        AuctionTimeControl(

            minNormalAuctionPeriod,

            minEmergencyAuctionPeriod,

            normalAuctionRevealSpan,

            emergencyAuctionRevealSpan,

            auctionWithdrawSpan,

            emergencyAuctionWithdrawSpan

        )

        UseBondMaker(bondMakerAddress)

        UseStableCoin(IDOLAddress)

        UseAuctionBoard(auctionBoardAddress)

    {}



    /**

     * @dev This function starts the auction for the auctionID. Can be called only by the IDOL contract.

     */

    function startAuction(

        bytes32 bondID,

        uint64 auctionAmount,

        bool isEmergency

    ) external override returns (bytes32) {

        require(

            msg.sender == address(_IDOLContract),

            "caller must be IDOL contract"

        );

        return _startAuction(bondID, auctionAmount, isEmergency);

    }



    /**

     * @notice This function is called when the auction (re)starts.

     * @param bondID is SBT ID whose auction will be held.

     * @param auctionAmount is SBT amount put up in the auction.

     * @param isEmergency is the flag that indicates the auction schedule is for emergency mode.

     */

    function _startAuction(

        bytes32 bondID,

        uint64 auctionAmount,

        bool isEmergency

    ) internal returns (bytes32) {

        (, , uint256 solidStrikePriceE4, ) = _bondMakerContract.getBond(bondID);

        uint256 strikePriceIDOL = _IDOLContract.calcSBT2IDOL(

            solidStrikePriceE4.mul(10**8)

        );



        uint256 auctionCount = _bondIDAuctionCount[bondID].add(1);

        _bondIDAuctionCount[bondID] = auctionCount;

        bytes32 auctionID = getCurrentAuctionID(bondID);

        require(

            isInPeriod(auctionID, BEFORE_AUCTION_FLAG),

            "the auction has been held"

        );



        uint256 betaCount = auctionCount.mod(POOL_AUCTION_COUNT_PADDING).min(9);



        auctionID2BondID[auctionID] = bondID;



        _setAuctionClosingTime(auctionID, isEmergency);



        {

            AuctionConfig memory auctionConfig = _auctionConfigList[auctionID];

            auctionConfig.ongoingAuctionSBTTotalE8 = auctionAmount;

            auctionConfig.lowestBidPriceDeadLineE8 = _auctionBoardContract

                .discretizeBidPrice(

                strikePriceIDOL

                    .mul(10 - betaCount)

                    .divRoundUp(10**(1 + 8))

                    .mul(10**8)

                    .toUint64()

            );

            auctionConfig.highestBidPriceDeadLineE8 = _auctionBoardContract

                .discretizeBidPrice(

                strikePriceIDOL.divRoundUp(10**8).mul(10**8).toUint64()

            );

            _auctionConfigList[auctionID] = auctionConfig;

        }



        emit LogStartAuction(auctionID, bondID, auctionAmount);



        return auctionID;

    }



    /**

     * @notice submit only your own winning bids and get SBT amount which you'll aquire.

     */

    function calcWinnerAmount(

        bytes32 auctionID,

        address sender,

        uint64[] memory winnerBids

    ) public override view returns (uint64) {

        uint256 totalBidAmount;



        (

            uint64 endPrice,

            uint64 endBoardIndex,

            uint64 loseSBTAmount,



        ) = _auctionBoardContract.getEndInfo(auctionID);



        uint64 bidPrice;

        uint64 boardIndex;

        // can calculate winner amount after making the end info.

        {

            (, , bool isEndInfoCreated, , ) = _auctionBoardContract

                .auctionDisposalInfo(auctionID);

            require(isEndInfoCreated, "the end info has not been made yet");

        }



        for (uint256 i = 0; i < winnerBids.length; i += 2) {

            if (i != 0) {

                require(

                    bidPrice > winnerBids[i] ||

                        (bidPrice == winnerBids[i] &&

                            boardIndex < winnerBids[i + 1]),

                    "winner bids are not sorted"

                );

            }

            bidPrice = winnerBids[i];

            boardIndex = winnerBids[i + 1];

            (uint64 bidAmount, address bidder) = _auctionBoardContract

                .auctionBoard(auctionID, bidPrice, boardIndex);

            require(bidder == sender, "this bid is not yours");



            totalBidAmount = totalBidAmount.add(bidAmount);

            if (endPrice == bidPrice) {

                if (boardIndex == endBoardIndex) {

                    // Guarantee loseSBTAmount <= bidAmount in this case.

                    totalBidAmount = totalBidAmount.sub(loseSBTAmount);

                } else {

                    require(

                        boardIndex < endBoardIndex,

                        "this bid does not win"

                    );

                }

            } else {

                require(endPrice < bidPrice, "this bid does not win");

            }

        }



        return totalBidAmount.toUint64();

    }



    /**

     * @notice all loser bids must be reported to this function. These are checked and counted for calculations of bill.

     * @param auctionID aunctionID

     * @param sender owner of the bids

     * @param winnerAmountInput SBT amount to aquire. this is needed because this effect the price of SBT in Vickly Auction's protocol.

     * @param myLowestPrice myLowestPrice is the lowest price of skip bids.

     * @param myLoseBids is the all bids which is after the endInfo

     */

    function calcBillAndCheckLoserBids(

        bytes32 auctionID,

        address sender,

        uint64 winnerAmountInput,

        uint64 myLowestPrice,

        uint64[] memory myLoseBids

    ) public override view returns (uint64) {

        uint256 winnerAmount = winnerAmountInput;

        uint256 toPaySkip = 0;



        if (

            myLowestPrice != NO_SKIP_BID &&

            myLowestPrice != SKIP_RECEIVING_WIN_BIDS

        ) {

            bool myLowestVerify = false;

            for (uint256 i = 0; i < myLoseBids.length; i += 2) {

                uint64 price = myLoseBids[i];

                if (price == myLowestPrice) {

                    myLowestVerify = true;

                    break;

                }

            }



            require(

                myLowestVerify,

                "myLowestPrice must be included in myLoseBids"

            );

        }



        // The amount of sender's lose bids will be skipped. In order to optimize the calculation,

        // components in myLoseBids with a higher price than myLowestPrice are added to winnerAmount and

        // to be subtracted at the end of this function.

        for (uint256 i = 0; i < myLoseBids.length; i += 2) {

            uint64 price = myLoseBids[i];

            uint64 boardIndex = myLoseBids[i + 1];



            if (i != 0) {

                require(

                    price < myLoseBids[i - 2] ||

                        (price == myLoseBids[i - 2] &&

                            boardIndex > myLoseBids[i - 1]),

                    "myLoseBids is not sorted"

                );

            }

            {

                (

                    uint64 endPrice,

                    uint64 endBoardIndex,

                    uint64 loseSBTAmount,



                ) = _auctionBoardContract.getEndInfo(auctionID);



                if (price == endPrice) {

                    if (boardIndex == endBoardIndex) {

                        require(

                            loseSBTAmount != 0,

                            "myLoseBids includes the bid which is same as endInfo with no lose SBT amount"

                        );



                        // This function does not guarantee to return the correct result if an invalid input is given,

                        // because this function can be used just for getting information.

                        // This function is used in the procecss of makeAuctionResult(), and in such a case,

                        // all the verification for bidder==sender and some necessary conditions are processed

                        // in different functions.



                        if (myLowestPrice <= price) {

                            winnerAmount = winnerAmount.add(loseSBTAmount);

                            toPaySkip = toPaySkip.add(

                                price.mul(loseSBTAmount).div(10**8)

                            );

                            continue;

                        }

                    } else {

                        require(

                            boardIndex > endBoardIndex,

                            "myLoseBids includes the bid whose bid index is less than that of endInfo"

                        );

                    }

                } else {

                    require(

                        price < endPrice,

                        "myLoseBids includes the bid whose price is more than that of endInfo"

                    );

                }

            }



            (uint64 bidAmount, address bidder) = _auctionBoardContract

                .auctionBoard(auctionID, price, boardIndex);

            require(

                bidder == sender,

                "myLoseBids includes the bid whose owner is not the sender"

            );



            if (myLowestPrice <= price) {

                winnerAmount = winnerAmount.add(bidAmount);

                toPaySkip = toPaySkip.add(price.mul(bidAmount).div(10**8));

            }

        }



        if (myLowestPrice == SKIP_RECEIVING_WIN_BIDS) {

            // Reduce calculation costs instead by receiving obtained SBT at the highest losing price.

            (uint64 endPrice, , , ) = _auctionBoardContract.getEndInfo(

                auctionID

            );

            //while toPaySkip is expected to be zero in the loop above,

            //only the exception is when the the price acctually hit uint64(-1) at an extremely unexpected case.

            return

                endPrice

                    .mul(winnerAmount)

                    .divRoundUp(10**8)

                    .sub(toPaySkip)

                    .toUint64();

        }



        return

            _auctionBoardContract

                .calcBill(auctionID, winnerAmount.toUint64(), myLowestPrice)

                .sub(toPaySkip)

                .toUint64();

    }



    /**

     * @notice Submit all my win and lose bids, verify them, and transfer the auction reward.

     * @param winnerBids is an array of alternating price and board index.

     * For example, if the end info is { price: 96, boardIndex: 0, loseSBTAmount: 100000000 } and you have 3 bids:

     * { price: 99, boardIndex: 0 }, { price: 97, boardIndex: 2 }, and { price: 96, boardIndex: 1 },

     * you should submit [9900000000, 0, 9700000000, 2] as winnerBids and [9600000000, 1] as loserBids.

     * If the end info is { price: 96, boardIndex: 0, loseSBTAmount: 100000000 } and you have 1 bid:

     * { price: 96, boardIndex: 0 }, you should submit [9600000000, 0] as winnerBids and [9600000000, 0]

     * as loserBids.

     */

    function makeAuctionResult(

        bytes32 auctionID,

        uint64 myLowestPrice,

        uint64[] memory winnerBids,

        uint64[] memory loserBids

    )

        public

        override

        returns (

            uint64,

            uint64,

            uint64

        )

    {

        (

            uint64 auctionLockedIDOLAmountE8,

            uint16 bidCount

        ) = _auctionBoardContract.auctionParticipantInfo(auctionID, msg.sender);



        require(auctionLockedIDOLAmountE8 != 0, "This process is already done");



        {

            (

                uint64 endPrice,

                uint64 endBoardIndex,

                uint64 loseSBTAmount,

                uint64 auctionEndPriceWinnerSBTAmount

            ) = _auctionBoardContract.getEndInfo(auctionID);

            (address endBidder, ) = _auctionBoardContract.getBoard(

                auctionID,

                endPrice,

                endBoardIndex

            );

            // If dupicated bid count is included (loseSBTAmount != 0), bidCount is increased by 1.

            // When both auctionEndPriceWinnerSBTAmount and loseSBTAmount are no-zero value,

            // the end info bid has two components(a winner bid side & a loser bid side).

            // If endInfo bid is frauded in calcBillAndCheckLoserBids L269, revert here. So there needs not check sender==bidder.

            require(

                winnerBids.length.div(2) + loserBids.length.div(2) ==

                    bidCount +

                        (

                            (msg.sender == endBidder &&

                                loseSBTAmount != 0 &&

                                auctionEndPriceWinnerSBTAmount != 0)

                                ? 1

                                : 0

                        ),

                "must submit all of your bids"

            );

        }



        uint64 winnerAmount = calcWinnerAmount(

            auctionID,

            msg.sender,

            winnerBids

        );



        uint64 toPay;

        TimeControlFlag timeFlag = getTimeControlFlag(auctionID);



        if (timeFlag == RECEIVING_SBT_PERIOD_FLAG) {

            toPay = calcBillAndCheckLoserBids(

                auctionID,

                msg.sender,

                winnerAmount,

                myLowestPrice,

                loserBids

            );

        } else {

            require(

                timeFlag > RECEIVING_SBT_PERIOD_FLAG,

                "has not been the receiving period yet"

            );

            toPay = calcBillAndCheckLoserBids(

                auctionID,

                msg.sender,

                winnerAmount,

                SKIP_RECEIVING_WIN_BIDS,

                loserBids

            );

        }



        // IDOLAmountOfChange = max(auctionLockedIDOLAmountE8 - toPay, 0)

        if (toPay > auctionLockedIDOLAmountE8) {

            // assertion to prevent from the worst case that accumulate to certain amount by rounding up of toPay.

            require(

                toPay.sub(auctionLockedIDOLAmountE8) < 10**8,

                "system error: does not ignore too big error for spam protection"

            );

            toPay = auctionLockedIDOLAmountE8;

        }

        uint64 IDOLAmountOfChange = auctionLockedIDOLAmountE8 - toPay;



        _auctionBoardContract.deleteParticipantInfo(auctionID, msg.sender);

        _transferIDOL(msg.sender, IDOLAmountOfChange);



        _auctionBoardContract.updateAuctionInfo(

            auctionID,

            0,

            toPay,

            winnerAmount

        );

        _distributeToWinners(auctionID, winnerAmount);



        emit LogAuctionResult(

            auctionID,

            msg.sender,

            winnerAmount,

            toPay,

            IDOLAmountOfChange

        );



        return (winnerAmount, toPay, IDOLAmountOfChange);

    }



    /**

     * @notice Close the auction when it is done. If some part of SBTs remain unsold, the auction is held again.

     */

    function closeAuction(bytes32 auctionID)

        public

        override

        returns (bool, bytes32)

    {

        (uint64 auctionSettledTotalE8, , ) = _auctionBoardContract.auctionInfo(

            auctionID

        );

        require(

            isInPeriod(auctionID, AFTER_AUCTION_FLAG),

            "This function is not allowed to execute in this period"

        );



        uint64 ongoingAuctionSBTTotal = _auctionConfigList[auctionID]

            .ongoingAuctionSBTTotalE8;

        require(ongoingAuctionSBTTotal != 0, "already closed");

        bytes32 bondID = auctionID2BondID[auctionID];



        {

            (, , bool isEndInfoCreated, , ) = _auctionBoardContract

                .auctionDisposalInfo(auctionID);

            require(isEndInfoCreated, "has not set end info");

        }



        _forceToFinalizeWinnerAmount(auctionID);



        uint256 nextAuctionAmount = ongoingAuctionSBTTotal.sub(

            auctionSettledTotalE8,

            "allocated SBT amount for auction never becomes lower than reward total"

        );



        bool isLast = nextAuctionAmount == 0;

        _publishSettledAverageAuctionPrice(auctionID, isLast);



        bytes32 nextAuctionID = bytes32(0);

        if (isLast) {

            // closeAuction adds 10**8 to _bondIDAuctionCount[bondID] and resets beta count

            // when all SBT of the auction is sold out.

            _bondIDAuctionCount[bondID] = _bondIDAuctionCount[bondID]

                .div(POOL_AUCTION_COUNT_PADDING)

                .add(1)

                .mul(POOL_AUCTION_COUNT_PADDING);

        } else {

            // When the SBT is not sold out in the auction, restart a new one until all the SBT is successfully sold.

            nextAuctionID = _startAuction(

                bondID,

                nextAuctionAmount.toUint64(),

                true

            );

        }

        delete _auctionConfigList[auctionID].ongoingAuctionSBTTotalE8;



        emit LogCloseAuction(auctionID, isLast, nextAuctionID);



        return (isLast, nextAuctionID);

    }



    /**

     * @notice This function returns SBT amount and iDOL amount (as its change) settled for those who didn't reveal bids.

     */

    function _calcUnrevealedBidDistribution(

        uint64 ongoingAmount,

        uint64 totalIDOLAmountUnrevealed,

        uint64 totalSBTAmountPaidForUnrevealed,

        uint64 solidStrikePriceIDOL,

        uint64 IDOLAmountDeposited

    )

        internal

        pure

        returns (uint64 receivingSBTAmount, uint64 returnedIDOLAmount)

    {

        // (total target) - (total revealed) = (total unrevealed)

        uint64 totalSBTAmountUnrevealed = totalIDOLAmountUnrevealed

            .mul(10**8)

            .div(solidStrikePriceIDOL, "system error: Oracle has a problem")

            .toUint64();



        // min((total unrevealed), ongoing) - (total paid already) = (total deposit for punishment)

        uint64 totalLeftSBTAmountForUnrevealed = uint256(

            totalSBTAmountUnrevealed

        )

            .min(ongoingAmount)

            .sub(totalSBTAmountPaidForUnrevealed)

            .toUint64();



        // (receiving SBT amount) = min((bid amount), (total deposited))

        uint256 expectedReceivingSBTAmount = IDOLAmountDeposited.mul(10**8).div(

            solidStrikePriceIDOL,

            "system error: Oracle has a problem"

        );



        // (returned iDOL amount) = (deposit amount) - (iDOL value of receiving SBT amount)

        if (expectedReceivingSBTAmount <= totalLeftSBTAmountForUnrevealed) {

            receivingSBTAmount = expectedReceivingSBTAmount.toUint64();

            returnedIDOLAmount = 0;

        } else if (totalLeftSBTAmountForUnrevealed == 0) {

            receivingSBTAmount = 0;

            returnedIDOLAmount = IDOLAmountDeposited;

        } else {

            receivingSBTAmount = totalLeftSBTAmountForUnrevealed;

            returnedIDOLAmount = IDOLAmountDeposited

                .sub(

                totalLeftSBTAmountForUnrevealed

                    .mul(solidStrikePriceIDOL)

                    .divRoundUp(10**8)

            )

                .toUint64();

        }



        return (receivingSBTAmount, returnedIDOLAmount);

    }



    /**

     * @notice Transfer SBT for those who forget to reveal.

     */

    function receiveUnrevealedBidDistribution(bytes32 auctionID, bytes32 secret)

        public

        override

        returns (bool)

    {

        (

            uint64 solidStrikePriceIDOL,

            ,

            bool isEndInfoCreated,

            ,



        ) = _auctionBoardContract.auctionDisposalInfo(auctionID);

        require(

            isEndInfoCreated,

            "EndInfo hasn't been made. This Function has not been allowed yet."

        );



        (address secOwner, , uint64 IDOLAmountDeposited) = _auctionBoardContract

            .auctionSecret(auctionID, secret);

        require(secOwner == msg.sender, "ownership of the bid is required");



        (

            ,

            uint64 totalIDOLSecret,

            uint64 totalIDOLAmountRevealed,



        ) = _auctionBoardContract.auctionRevealInfo(auctionID);

        uint64 totalIDOLAmountUnrevealed = totalIDOLSecret

            .sub(totalIDOLAmountRevealed)

            .toUint64();



        uint64 receivingSBTAmount;

        uint64 returnedIDOLAmount;

        uint64 totalSBTAmountPaidForUnrevealed;

        {

            AuctionConfig memory auctionConfig = _auctionConfigList[auctionID];

            totalSBTAmountPaidForUnrevealed = auctionConfig

                .totalSBTAmountPaidForUnrevealedE8;



            (

                receivingSBTAmount,

                returnedIDOLAmount

            ) = _calcUnrevealedBidDistribution(

                auctionConfig.ongoingAuctionSBTTotalE8,

                totalIDOLAmountUnrevealed,

                totalSBTAmountPaidForUnrevealed,

                solidStrikePriceIDOL,

                IDOLAmountDeposited

            );

        }



        _auctionConfigList[auctionID]

            .totalSBTAmountPaidForUnrevealedE8 = totalSBTAmountPaidForUnrevealed

            .add(receivingSBTAmount)

            .toUint64();

        _auctionBoardContract.removeSecret(auctionID, secret, 0);



        // Transfer the winning SBT and (if necessary) return the rest of deposited iDOL.

        _distributeToWinners(auctionID, receivingSBTAmount);

        _IDOLContract.transfer(secOwner, returnedIDOLAmount);



        return true;

    }



    /**

     * @notice Cancel the bid of your own within the bid acceptance period.

     */

    function cancelBid(bytes32 auctionID, bytes32 secret)

        public

        override

        returns (uint64)

    {

        require(

            isInPeriod(auctionID, ACCEPTING_BIDS_PERIOD_FLAG),

            "it is not the time to accept bids"

        );

        (address owner, , uint64 IDOLamount) = _auctionBoardContract

            .auctionSecret(auctionID, secret);

        require(owner == msg.sender, "you are not the bidder for the secret");

        _auctionBoardContract.removeSecret(auctionID, secret, IDOLamount);

        _transferIDOL(

            owner,

            IDOLamount,

            "system error: try to cancel bid, but cannot return iDOL"

        );



        emit LogCancelBid(auctionID, owner, secret, IDOLamount);



        return IDOLamount;

    }



    /**

     * @notice Returns the current auction ID.

     */

    function getCurrentAuctionID(bytes32 bondID)

        public

        override

        view

        returns (bytes32)

    {

        uint256 count = _bondIDAuctionCount[bondID];

        return generateAuctionID(bondID, count);

    }



    /**

     * @notice Generates auction ID from bond ID and the count of auctions for the bond.

     */

    function generateAuctionID(bytes32 bondID, uint256 count)

        public

        override

        pure

        returns (bytes32)

    {

        return keccak256(abi.encode(bondID, count));

    }



    /**

     * @dev The bidder succeeds in winning the SBT for the auctionID with receivingBondAmount, and pays IDOL with billingIDOLAmount.

     */

    function _distributeToWinners(bytes32 auctionID, uint64 receivingBondAmount)

        internal

        returns (uint64)

    {

        // Get the address of SBT contract.

        (address solidBondAddress, , , ) = _getBondFromAuctionID(auctionID);

        require(solidBondAddress != address(0), "the bond is not registered");



        // Transfer the winning SBT.

        BondTokenInterface solidBondContract = BondTokenInterface(

            payable(solidBondAddress)

        );

        solidBondContract.transfer(msg.sender, receivingBondAmount);

    }



    /**

     * @dev When isLast is true, the SBTs put up in the auction are sold entirely.

     * The average auction price is used for deciding the amount of IDOL to return from the lock pool.

     */

    function _publishSettledAverageAuctionPrice(bytes32 auctionID, bool isLast)

        internal

    {

        bytes32 bondID = auctionID2BondID[auctionID];

        (

            ,

            uint64 auctionRewardedTotalE8,

            uint64 auctionPaidTotalE8

        ) = _auctionBoardContract.auctionInfo(auctionID);



        // The auction contract actually do not burn iDOL. Paid iDOL will be transferred and burned in the stable coin contract.

        _transferIDOL(

            address(_IDOLContract),

            auctionPaidTotalE8,

            "system error: cannot transfer iDOL from auction contract to iDOL contract"

        );



        _IDOLContract.setSettledAverageAuctionPrice(

            bondID,

            auctionPaidTotalE8,

            auctionRewardedTotalE8,

            isLast

        );

    }



    /**

     * @dev How much IDOL to burn is decided by the settlement price.

     * Hence, this contract needs to decide the price within some specified period.

     */

    function _forceToFinalizeWinnerAmount(bytes32 auctionID) internal {

        (

            uint64 auctionSettledTotalE8,

            uint64 auctionRewardedTotalE8,



        ) = _auctionBoardContract.auctionInfo(auctionID);



        if (_auctionBoardContract.getSortedBidPrice(auctionID).length == 0) {

            return;

        }



        (uint256 burnIDOLRate, , , ) = _auctionBoardContract.getEndInfo(

            auctionID

        );



        uint256 _totalSBTForRestWinners = auctionSettledTotalE8.sub(

            auctionRewardedTotalE8,

            "system error: allocated SBT amount for auction never becomes lower than reward total at any point"

        );



        uint256 burnIDOL = _totalSBTForRestWinners.mul(burnIDOLRate).div(10**8);



        _auctionBoardContract.updateAuctionInfo(

            auctionID,

            _totalSBTForRestWinners.toUint64(),

            burnIDOL.toUint64(),

            _totalSBTForRestWinners.toUint64()

        );

    }



    /**

     * @notice Returns the bond information corresponding to the auction ID.

     */

    function _getBondFromAuctionID(bytes32 auctionID)

        internal

        view

        returns (

            address erc20Address,

            uint256 maturity,

            uint64 solidStrikePrice,

            bytes32 fnMapID

        )

    {

        bytes32 bondID = auctionID2BondID[auctionID];

        return _bondMakerContract.getBond(bondID);

    }



    /**

     * @notice Returns the bond IDs corresponding to the auction IDs respectively.

     */

    function listBondIDFromAuctionID(bytes32[] memory auctionIDs)

        public

        override

        view

        returns (bytes32[] memory bondIDs)

    {

        bondIDs = new bytes32[](auctionIDs.length);

        for (uint256 i = 0; i < auctionIDs.length; i++) {

            bondIDs[i] = auctionID2BondID[auctionIDs[i]];

        }

    }



    /**

     * @notice Returns the auction status.

     * @param auctionID is a auction ID.

     * @return closingTime is .

     * @return auctionAmount is the SBT amount put up in the auction.

     * @return rewardedAmount is .

     * @return totalSBTAmountBid is .

     * @return isEmergency is .

     * @return doneFinalizeWinnerAmount is .

     * @return doneSortPrice is .

     * @return lowestBidPriceDeadLine is the minimum bid price in the auction.

     * @return highestBidPriceDeadLine is the maximum bid price in the auction.

     * @return totalSBTAmountPaidForUnrevealed is the SBT Amount allocated for those who had not revealed their own bid.

     */

    function getAuctionStatus(bytes32 auctionID)

        public

        override

        view

        returns (

            uint256 closingTime,

            uint64 auctionAmount,

            uint64 rewardedAmount,

            uint64 totalSBTAmountBid,

            bool isEmergency,

            bool doneFinalizeWinnerAmount,

            bool doneSortPrice,

            uint64 lowestBidPriceDeadLine,

            uint64 highestBidPriceDeadLine,

            uint64 totalSBTAmountPaidForUnrevealed

        )

    {

        closingTime = auctionClosingTime[auctionID].toUint64();

        AuctionConfig memory auctionConfig = _auctionConfigList[auctionID];

        auctionAmount = auctionConfig.ongoingAuctionSBTTotalE8;

        lowestBidPriceDeadLine = auctionConfig.lowestBidPriceDeadLineE8;

        highestBidPriceDeadLine = auctionConfig.highestBidPriceDeadLineE8;

        totalSBTAmountPaidForUnrevealed = auctionConfig

            .totalSBTAmountPaidForUnrevealedE8;

        (, rewardedAmount, ) = _auctionBoardContract.auctionInfo(auctionID);

        (totalSBTAmountBid, , , ) = _auctionBoardContract.auctionRevealInfo(

            auctionID

        );

        isEmergency = isAuctionEmergency[auctionID];

        (, , , doneFinalizeWinnerAmount, doneSortPrice) = _auctionBoardContract

            .auctionDisposalInfo(auctionID);

    }



    /**

     * @notice Returns the status of auctions which is held in the week.

     * @param weekNumber is the quotient obtained by dividing the timestamp by 7 * 24 * 60 * 60 (= 7 days).

     */

    function getWeeklyAuctionStatus(uint256 weekNumber)

        external

        override

        view

        returns (uint256[] memory weeklyAuctionStatus)

    {

        bytes32[] memory auctions = listAuction(weekNumber);

        weeklyAuctionStatus = new uint256[](auctions.length.mul(6));

        for (uint256 i = 0; i < auctions.length; i++) {

            (

                uint256 closingTime,

                uint64 auctionAmount,

                uint64 rewardedAmount,

                uint64 totalSBTAmountBid,

                bool isEmergency,

                bool doneFinalizeWinnerAmount,

                bool doneSortPrice,

                ,

                ,



            ) = getAuctionStatus(auctions[i]);

            uint8 auctionStatusCode = (isEmergency ? 1 : 0) << 2;

            auctionStatusCode += (doneFinalizeWinnerAmount ? 1 : 0) << 1;

            auctionStatusCode += doneSortPrice ? 1 : 0;

            weeklyAuctionStatus[i * 6] = closingTime;

            weeklyAuctionStatus[i * 6 + 1] = auctionAmount;

            weeklyAuctionStatus[i * 6 + 2] = rewardedAmount;

            weeklyAuctionStatus[i * 6 + 3] = totalSBTAmountBid;

            weeklyAuctionStatus[i * 6 + 4] = auctionStatusCode;

            weeklyAuctionStatus[i * 6 + 5] = uint256(auctions[i]);

        }

    }



    /**

     * @notice Returns total SBT amount put up in the auction.

     */

    function ongoingAuctionSBTTotal(bytes32 auctionID)

        external

        override

        view

        returns (uint64 ongoingSBTAmountE8)

    {

        AuctionConfig memory auctionConfig = _auctionConfigList[auctionID];

        return auctionConfig.ongoingAuctionSBTTotalE8;

    }



    function getAuctionCount(bytes32 bondID)

        external

        override

        view

        returns (uint256 auctionCount)

    {

        return _bondIDAuctionCount[bondID];

    }

}



// File: contracts/util/DeployerRole.sol









abstract contract DeployerRole {

    address internal immutable _deployer;



    modifier onlyDeployer() {

        require(

            _isDeployer(msg.sender),

            "only deployer is allowed to call this function"

        );

        _;

    }



    constructor() public {

        _deployer = msg.sender;

    }



    function _isDeployer(address account) internal view returns (bool) {

        return account == _deployer;

    }

}



// File: contracts/UseAuctionLater.sol













abstract contract UseAuctionLater is DeployerRole {

    Auction internal _auctionContract;



    modifier isNotEmptyAuctionInstance() {

        require(

            address(_auctionContract) != address(0),

            "the auction contract is not set"

        );

        _;

    }



    /**

     * @dev This function is called only once when the code is initially deployed.

     */

    function setAuctionContract(address contractAddress) public onlyDeployer {

        require(

            address(_auctionContract) == address(0),

            "the auction contract is already registered"

        );

        require(

            contractAddress != address(0),

            "contract should be non-zero address"

        );

        _setAuctionContract(contractAddress);

    }



    function _setAuctionContract(address contractAddress) internal {

        _auctionContract = Auction(payable(contractAddress));

    }

}



// File: contracts/StableCoin.sol





























contract StableCoin is

    UseSafeMath,

    StableCoinInterface,

    Time,

    ERC20("iDOL", "iDOL"),

    SolidBondSafety,

    UseOracle,

    UseBondMaker,

    UseAuctionLater

{

    using Math for uint256;



    /**

     * @dev pool:mint = 1:9

     */

    uint256 internal constant LOCK_POOL_BORDER = 1;

    uint256 internal constant MINT_IDOL_BORDER = 10 - LOCK_POOL_BORDER;

    uint256 internal immutable AUCTION_SPAN;

    uint256 internal immutable EMERGENCY_AUCTION_SPAN;

    uint256 internal immutable MINT_IDOL_AMOUNT_BORDER;



    /**

     * @dev The contents of this internal storage variable can be seen by solidValueTotal function.

     */

    uint256 internal _solidValueTotalE12;



    mapping(bytes32 => uint64) public auctionTriggerCount;



    /**

     * @dev Record the pooled IDOL for each person(= beta * minted amount).

     * The pooled IDOL is going to be refunded partially to the person when the deposited SBT is

     * sold in the auction.

     */

    struct LockedPool {

        uint64 IDOLAmount;

        uint64 baseSBTAmount;

    }

    mapping(address => mapping(bytes32 => LockedPool)) public lockedPoolE8;



    /**

     * @dev The contents in this internal storage variable can be seen by getPoolInfo function.

     * @param lockedSolidBondTotalE8 is the current locked SBT amount.

     * @param unlockedSolidBondTotalE8 is the SBT amount unlocked by unlockSBT().

     * @param lockedPoolIDOLTotalE8 is the iDOL amount locked to the pool for the SBT.

     * @param SBT2BurnedIDOLTotalE8 is the iDOL amount burned by unlockSBT() or setSettledAverageAuctionPrice().

     */

    struct AccountingTotalInfo {

        uint64 lockedSolidBondTotalE8;

        uint64 unlockedSolidBondTotalE8;

        uint64 lockedPoolIDOLTotalE8;

        uint64 SBT2BurnedIDOLTotalE8;

    }

    mapping(bytes32 => AccountingTotalInfo) internal _accountingTotalInfo;



    /**

     * @notice Record the average settlement price for each SBT bondID.

     * @dev The average settlement price is used for calculating the amount to return partially from

     * the pooled IDOL.

     * The contents in this internal storage variable can be seen by getPoolInfo function.

     * @param auctionSoldSolidBondTotal is the SBT total amount already sold in the auction.

     * @param auctionPaidIDOLTotalE8 is the iDOL amount already paid for the SBT in the auction.

     * @param settledAverageAuctionPrice is the average price for the SBT in the auction and unlockSBT().

     * @param isAllAmountSoldInAuction indicates whether auctionSoldSolidBondTotal equals to the auction amount or not.

     */

    struct AuctionAmountInfo {

        uint64 auctionSoldSolidBondTotal;

        uint64 auctionPaidIDOLTotalE8;

        uint64 settledAverageAuctionPrice;

        bool isAllAmountSoldInAuction;

    }

    mapping(bytes32 => AuctionAmountInfo) internal _auctionAmountInfo;



    constructor(

        address oracleAddress,

        address bondMakerAddress,

        uint256 auctionSpan,

        uint256 emergencyAuctionSpan,

        uint256 mintIDOLAmountBorder

    ) public UseOracle(oracleAddress) UseBondMaker(bondMakerAddress) {

        _setupDecimals(8);

        AUCTION_SPAN = auctionSpan;

        EMERGENCY_AUCTION_SPAN = emergencyAuctionSpan;

        MINT_IDOL_AMOUNT_BORDER = mintIDOLAmountBorder;

    }



    function _reduceSBTValue(uint256 SBTValueE12) internal {

        _solidValueTotalE12 = _solidValueTotalE12.sub(SBTValueE12);

    }



    /**

     * @notice In order to calculate the amount to burn from the pooled IDOL, need to aggregate

     * IDOLs both in the auction and in the unlockSBT function. Calculate settled-average-auction-

     * price (every time an auction ends, the auction contract trigger this)

     * @param bondID ID for auctioned SBT

     * @param auctionPaidIDOL IDOL amount burned in this auction

     * @param auctionSoldAmount SBT amount sold in this auction

     * @param isLastTime True when the auction successfully sold all the SBT

     */

    function _setSettledAverageAuctionPrice(

        bytes32 bondID,

        uint64 auctionPaidIDOL,

        uint64 auctionSoldAmount,

        bool isLastTime

    ) internal {

        bytes32 poolID = getCurrentPoolID(bondID);

        AuctionAmountInfo memory auctionInfo = _auctionAmountInfo[poolID];



        auctionInfo.auctionSoldSolidBondTotal = auctionInfo

            .auctionSoldSolidBondTotal

            .add(auctionSoldAmount)

            .toUint64();

        auctionInfo.auctionPaidIDOLTotalE8 = auctionInfo

            .auctionPaidIDOLTotalE8

            .add(auctionPaidIDOL)

            .toUint64();



        if (isLastTime) {

            // Calculate the amount of IDOL to burn



                AccountingTotalInfo memory accountingInfo

             = _accountingTotalInfo[poolID];

            uint256 burnIDOLAmount = 0;



            /**

             * @dev In the case of beta=0.1, total distributed IDOL for the bondID

             * can be calculated by the pooled IDOL amount for the bondID multiplied by 9

             * (= MINT_IDOL_BORDER).

             * In the case that someone has withdrawn SBT by unlockSBT(), the pooled IDOL is also

             * circulated.

             * When 3 SBT (strike = $100) are withdrawn by unlockSBT() and 8 SBT are sold in the

             * auction, circulated = (3+8)*100*0.9 and everminted = (3+8)*100.

             * Those 3 and 8 can be captured by looking at the amount of IDOL in the pool.

             */

            {

                // (circulated amount) = (locked pool iDOL total) * MINT_IDOL_BORDER / LOCK_POOL_BORDER

                //                     = (locked pool iDOL total) * MINT_IDOL_BORDER

                uint256 circulated = accountingInfo.lockedPoolIDOLTotalE8.mul(

                    MINT_IDOL_BORDER

                );

                uint256 everMinted = accountingInfo.lockedPoolIDOLTotalE8.add(

                    circulated

                );

                uint256 allBurn = accountingInfo.SBT2BurnedIDOLTotalE8.add(

                    auctionInfo.auctionPaidIDOLTotalE8

                );

                if (allBurn > circulated) {

                    if (everMinted >= allBurn) {

                        // burn all the IDOL issued for the SBT put up in the auction

                        //SAME MEANING of: burnIDOLAmount = everMinted.sub(allBurn).add(auctionPaidIDOLTotalE8[bondID]);

                        burnIDOLAmount = everMinted.sub(

                            accountingInfo.SBT2BurnedIDOLTotalE8

                        );

                    } else {

                        // burn all the IDOL issued for the SBT put up in the auction, and excess amount.

                        //SAME MEANING of: burnIDOLAmount = allBurn.sub(allBurn).add(auctionPaidIDOLTotalE8[bondID]);

                        burnIDOLAmount = allBurn.sub(

                            accountingInfo.SBT2BurnedIDOLTotalE8

                        );

                    }

                } else {

                    // burn as much as we can.

                    //In this case, burn rate(price) is lower than 1-beta

                    burnIDOLAmount = accountingInfo.lockedPoolIDOLTotalE8.add(

                        auctionInfo.auctionPaidIDOLTotalE8

                    );

                }

            }



            (, , uint64 solidBondStrikePriceUSD, ) = _bondMakerContract.getBond(

                bondID

            );



            _burn(address(this), burnIDOLAmount);

            accountingInfo.SBT2BurnedIDOLTotalE8 = accountingInfo

                .SBT2BurnedIDOLTotalE8

                .add(auctionInfo.auctionPaidIDOLTotalE8)

                .toUint64();



            _reduceSBTValue(

                auctionInfo.auctionSoldSolidBondTotal.mul(

                    solidBondStrikePriceUSD

                )

            );

            accountingInfo.unlockedSolidBondTotalE8 = accountingInfo

                .unlockedSolidBondTotalE8

                .add(auctionInfo.auctionSoldSolidBondTotal)

                .toUint64();



            auctionInfo.settledAverageAuctionPrice = accountingInfo

                .SBT2BurnedIDOLTotalE8

                .mul(10**8)

                .div(

                accountingInfo

                    .unlockedSolidBondTotalE8,

                "system: the total unlock amount should be non-zero value"

            )

                .toUint64();



            auctionInfo.isAllAmountSoldInAuction = true;

            auctionTriggerCount[bondID] = auctionTriggerCount[bondID]

                .add(1)

                .toUint64();



            _accountingTotalInfo[poolID] = accountingInfo;



            uint256 totalIDOLSupply = totalSupply();

            emit LogLambda(

                poolID,

                auctionInfo.settledAverageAuctionPrice,

                totalIDOLSupply,

                _solidValueTotalE12

            );

        }

        _auctionAmountInfo[poolID] = auctionInfo;

    }



    /**

     * @param poolID is a pool ID.

     * @return lockedSBTTotal is the current locked SBT amount. (e8)

     * @return unlockedSBTTotal is the SBT amount unlocked with unlockSBT(). (e8)

     * @return lockedPoolIDOLTotal is the iDOL amount locked to the pool when this was minted. (e8)

     * @return burnedIDOLTotal is the iDOL amount burned with unlockSBT() and setSettledAverageAuctionPrice(). (e8)

     * @return soldSBTTotalInAuction is the SBT total amount already sold in the auction. (e8)

     * @return paidIDOLTotalInAuction is the iDOL amount already paid for SBT in the auction. (e8)

     * @return settledAverageAuctionPrice is the average price with iDOL of the SBT in the auction and unlockSBT(). (e8)

     * @return isAllAmountSoldInAuction is whether auctionSoldSolidBondTotal is equal to the auction amount or not.

     */

    function getPoolInfo(bytes32 poolID)

        external

        override

        view

        returns (

            uint64 lockedSBTTotal,

            uint64 unlockedSBTTotal,

            uint64 lockedPoolIDOLTotal,

            uint64 burnedIDOLTotal,

            uint64 soldSBTTotalInAuction,

            uint64 paidIDOLTotalInAuction,

            uint64 settledAverageAuctionPrice,

            bool isAllAmountSoldInAuction

        )

    {



            AccountingTotalInfo memory accountingInfo

         = _accountingTotalInfo[poolID];

        lockedSBTTotal = accountingInfo.lockedSolidBondTotalE8;

        unlockedSBTTotal = accountingInfo.unlockedSolidBondTotalE8;

        lockedPoolIDOLTotal = accountingInfo.lockedPoolIDOLTotalE8;

        burnedIDOLTotal = accountingInfo.SBT2BurnedIDOLTotalE8;





            AuctionAmountInfo memory auctionSettlementInfo

         = _auctionAmountInfo[poolID];

        soldSBTTotalInAuction = auctionSettlementInfo.auctionSoldSolidBondTotal;

        paidIDOLTotalInAuction = auctionSettlementInfo.auctionPaidIDOLTotalE8;

        settledAverageAuctionPrice = auctionSettlementInfo

            .settledAverageAuctionPrice;

        isAllAmountSoldInAuction = auctionSettlementInfo

            .isAllAmountSoldInAuction;

    }



    function solidValueTotal() external override view returns (uint256) {

        return _solidValueTotalE12;

    }



    function generatePoolID(bytes32 bondID, uint64 count)

        public

        override

        pure

        returns (bytes32)

    {

        return keccak256(abi.encodePacked(bondID, count, "lien"));

    }



    function getCurrentPoolID(bytes32 bondID)

        public

        override

        view

        returns (bytes32)

    {

        uint64 currentTriggeredCount = auctionTriggerCount[bondID];

        return generatePoolID(bondID, currentTriggeredCount);

    }



    function getLockedPool(address user, bytes32 poolID)

        public

        override

        view

        returns (uint64, uint64)

    {

        return (

            lockedPoolE8[user][poolID].IDOLAmount,

            lockedPoolE8[user][poolID].baseSBTAmount

        );

    }



    /**

     * @dev poolID is counted up and used when the SBT once released from IDOL in the emergency

     * auction becomes qualified again before its maturity.

     */



    /**

     * @dev Check if the SBT is qualified in terms of the length of the time until maturity,

     * the volatility, and the distance between the current price and the strike price.

     */

    function isAcceptableSBT(bytes32 bondID)

        public

        virtual

        override

        isNotEmptyAuctionInstance

        returns (bool)

    {

        (

            address bondTokenAddress,

            uint256 maturity,

            uint64 solidStrikePriceE4,



        ) = _bondMakerContract.getBond(bondID);

        require(bondTokenAddress != address(0), "the bond is not registered");

        require(

            solidStrikePriceE4 != 0,

            "the bond does not match to the form of SBT"

        );

        require(

            maturity > _getBlockTimestampSec() + AUCTION_SPAN,

            "a request to hold an auction of the bond has already expired"

        );

        require(

            solidStrikePriceE4 % (10**5) == 0,

            "the strike price need to be $ 10*X"

        );



        bytes32 auctionID = _auctionContract.getCurrentAuctionID(bondID);

        require(

            _auctionContract.ongoingAuctionSBTTotal(auctionID) == 0,

            "this SBT is on a auciton"

        );



        (uint256 rateETH2USDE8, uint256 volatilityE8) = _getOracleData();

        bool isDanger = isDangerSolidBond(

            rateETH2USDE8,

            solidStrikePriceE4,

            volatilityE8,

            maturity - _getBlockTimestampSec()

        );



        emit LogIsAcceptableSBT(bondID, !isDanger);



        return !isDanger;

    }



    /**

     * @notice Lock SBT and mint IDOL

     * @param bondID the ID for the SBT locked for minting IDOL

     * @param lockAmountE8 the amount of locked SBT

     */

    function mint(

        bytes32 bondID,

        address recipient,

        uint64 lockAmountE8

    )

        public

        override

        returns (

            bytes32 poolID,

            uint64 obtainIDOLAmountE8,

            uint64 poolIDOLAmountE8

        )

    {

        poolID = getCurrentPoolID(bondID);



        // Check if the maturity is sufficiently distant from the current time.

        (

            address bondTokenAddress,

            ,

            uint256 solidStrikePriceE4,



        ) = _bondMakerContract.getBond(bondID);

        require(

            isAcceptableSBT(bondID),

            "SBT with the bondID is not currently acceptable"

        );





            AccountingTotalInfo memory accountingInfo

         = _accountingTotalInfo[poolID];



        // Calculate the mint amount based on the dilution ratio.

        uint256 solidBondValueE12 = lockAmountE8.mul(solidStrikePriceE4);

        uint256 mintAmountE8 = calcSBT2IDOL(solidBondValueE12);

        require(

            accountingInfo.lockedPoolIDOLTotalE8 != 0 ||

                mintAmountE8 >= MINT_IDOL_AMOUNT_BORDER,

            "mint amount need to be greater than 500 idol for this bond"

        );



        ERC20 bondTokenContract = ERC20(bondTokenAddress);

        bondTokenContract.transferFrom(msg.sender, address(this), lockAmountE8);



        // (pooling amount) = mintAmountE8 * LOCK_POOL_BORDER / 10 = mintAmountE8 / 10

        uint256 poolAmount = mintAmountE8.div(10);

        LockedPool storage lockedPoolInfo = lockedPoolE8[recipient][poolID];

        lockedPoolInfo.IDOLAmount = lockedPoolInfo

            .IDOLAmount

            .add(poolAmount)

            .toUint64();

        lockedPoolInfo.baseSBTAmount = lockedPoolInfo

            .baseSBTAmount

            .add(lockAmountE8)

            .toUint64();



        _mint(recipient, mintAmountE8.sub(poolAmount));

        _mint(address(this), poolAmount);

        _solidValueTotalE12 = _solidValueTotalE12.add(solidBondValueE12);

        accountingInfo.lockedSolidBondTotalE8 = accountingInfo

            .lockedSolidBondTotalE8

            .add(lockAmountE8)

            .toUint64();

        accountingInfo.lockedPoolIDOLTotalE8 = accountingInfo

            .lockedPoolIDOLTotalE8

            .add(poolAmount)

            .toUint64();

        _accountingTotalInfo[poolID] = accountingInfo;



        uint256 obtainAmount = mintAmountE8.sub(poolAmount);

        emit LogMintIDOL(bondID, recipient, poolID, obtainAmount, poolAmount);

        return (poolID, obtainAmount.toUint64(), poolAmount.toUint64());

    }



    /**

     * @dev Only the auction contract address can burn some specified amount of the IDOL held by

     * an account.

     */

    function burnFrom(address account, uint256 amount)

        public

        override

        isNotEmptyAuctionInstance

    {

        require(

            msg.sender == address(_auctionContract),

            "msg.sender must be auction contract"

        );

        _burn(account, amount);

    }



    /**

     * @notice This function provides the opportunity to redeem any type of SBT with a correct

     * amount by burning iDOL. iDOL is pegged to totalLockedValue/totalSupply dollar

     * (initially 1 dollar), so we can always allow anyone to redeem at most 1 dollar worth SBT

     * by burning 1 dollar worth iDOL.

     * This is based on the mathematical fact that the theoretical value of 1 unit SBT with

     * strike price 100 dollar is always strictly less than 100 dollar (e.g. 99.99 dollar).

     * @dev IDOL contract needs to know the value of iDOL per unit by calculating

     * totalLockedValue/totalSupply the value of iDOL per unit may change when the auction

     * settlement price is not within the certain price range.

     * rewardSBT = burnAmountE8/solidStrikePriceE4 * totalSupply/totalLockedValue

     * @param bondID is the bond to unlock

     * @param burnAmountE8 is the iDOL amount to burn

     */

    function unlockSBT(bytes32 bondID, uint64 burnAmountE8)

        public

        override

        returns (uint64)

    {

        bytes32 poolID = getCurrentPoolID(bondID);

        (

            address bondTokenAddress,

            ,

            uint256 solidStrikePriceE4,



        ) = _bondMakerContract.getBond(bondID);

        require(bondTokenAddress != address(0), "the bond is not registered");

        require(solidStrikePriceE4 != 0, "the bond is not the form of SBT");



            AccountingTotalInfo memory accountingInfo

         = _accountingTotalInfo[poolID];



        uint64 rewardSBTE8 = burnAmountE8

            .mul(_solidValueTotalE12)

            .div(totalSupply(), "system error: totalSupply never becomes zero")

            .div(

            solidStrikePriceE4,

            "system error: solidStrikePrice never becomes zero [unlockSBT]"

        )

            .toUint64();



        // Burn iDOL.

        accountingInfo.SBT2BurnedIDOLTotalE8 = accountingInfo

            .SBT2BurnedIDOLTotalE8

            .add(burnAmountE8)

            .toUint64();



        _burn(msg.sender, burnAmountE8);



        // Return SBT.

        BondTokenInterface bondTokenContract = BondTokenInterface(

            payable(bondTokenAddress)

        );

        bondTokenContract.transfer(msg.sender, rewardSBTE8);



        emit LogBurnIDOL(bondID, msg.sender, burnAmountE8, rewardSBTE8);



        // Update solidValueTotal, lockedSolidBondTotalE18 and unlockedSolidBondTotal.

        _solidValueTotalE12 = _solidValueTotalE12.sub(

            rewardSBTE8.mul(solidStrikePriceE4)

        );

        accountingInfo.lockedSolidBondTotalE8 = accountingInfo

            .lockedSolidBondTotalE8

            .sub(rewardSBTE8)

            .toUint64();

        accountingInfo.unlockedSolidBondTotalE8 = accountingInfo

            .unlockedSolidBondTotalE8

            .add(rewardSBTE8)

            .toUint64();



        _accountingTotalInfo[poolID] = accountingInfo;



        return rewardSBTE8;

    }



    /**

     * @notice Starts regular auction for SBT with short maturity.

     */

    function startAuctionOnMaturity(bytes32 bondID)

        public

        override

        isNotEmptyAuctionInstance

    {

        bytes32 poolID = getCurrentPoolID(bondID);

        (

            address bondTokenAddress,

            uint256 maturity,

            uint64 solidBondStrikePriceUSD,



        ) = _bondMakerContract.getBond(bondID);

        require(bondTokenAddress != address(0), "the bond is not registered");

        require(

            solidBondStrikePriceUSD != 0,

            "the bond is not the form of SBT"

        );

        require(

            maturity <= _getBlockTimestampSec() + AUCTION_SPAN,

            "maturity is later than the regular auctionSpan"

        );



        uint64 lockedSolidBondTotalE8;

        {



                AccountingTotalInfo memory accountingInfo

             = _accountingTotalInfo[poolID];

            lockedSolidBondTotalE8 = accountingInfo.lockedSolidBondTotalE8;

            if (lockedSolidBondTotalE8 == 0) {

                if (accountingInfo.lockedPoolIDOLTotalE8 != 0) {

                    _setSettledAverageAuctionPrice(bondID, 0, 0, true);

                }

                return;

            }

            delete _accountingTotalInfo[poolID].lockedSolidBondTotalE8;

        }



        if (maturity <= _getBlockTimestampSec() + EMERGENCY_AUCTION_SPAN) {

            _auctionContract.startAuction(bondID, lockedSolidBondTotalE8, true);

        } else {

            _auctionContract.startAuction(

                bondID,

                lockedSolidBondTotalE8,

                false

            );

        }



        // Send SBT to the auction contract.

        BondTokenInterface bondTokenContract = BondTokenInterface(

            payable(bondTokenAddress)

        );

        bondTokenContract.transfer(

            address(_auctionContract),

            lockedSolidBondTotalE8

        );

    }



    /**

     * @notice Starts emergency auction

     * @dev Check if the SBT needs to trigger the emergency auction based on the length of the

     * time until maturity, the volatility, and the distance between the current price and the

     * strike price.

     */

    function startAuctionByMarket(bytes32 bondID)

        public

        override

        isNotEmptyAuctionInstance

    {

        bytes32 poolID = getCurrentPoolID(bondID);

        (

            address bondTokenAddress,

            uint256 maturity,

            uint64 solidBondStrikePriceUSD,



        ) = _bondMakerContract.getBond(bondID);

        require(bondTokenAddress != address(0), "the bond is not registered");

        require(

            solidBondStrikePriceUSD != 0,

            "the bond is not the form of SBT"

        );



        (uint256 rateETH2USD, uint256 volatility) = _getOracleData();

        bool isDanger = isInEmergency(

            rateETH2USD,

            solidBondStrikePriceUSD,

            volatility,

            maturity - _getBlockTimestampSec()

        );

        require(isDanger, "the SBT is not in emergency");



        uint64 lockedSolidBondTotalE8;

        {



                AccountingTotalInfo memory accountingInfo

             = _accountingTotalInfo[poolID];

            lockedSolidBondTotalE8 = accountingInfo.lockedSolidBondTotalE8;

            if (lockedSolidBondTotalE8 == 0) {

                if (accountingInfo.lockedPoolIDOLTotalE8 != 0) {

                    _setSettledAverageAuctionPrice(bondID, 0, 0, true);

                }

                return;

            }

            delete _accountingTotalInfo[poolID].lockedSolidBondTotalE8;

        }



        _auctionContract.startAuction(bondID, lockedSolidBondTotalE8, true);



        // Send SBT to the auction contract.

        BondTokenInterface bondTokenContract = BondTokenInterface(

            payable(bondTokenAddress)

        );

        bondTokenContract.transfer(

            address(_auctionContract),

            lockedSolidBondTotalE8

        );

    }



    /**

     * @notice Sets SettledAverageAuctionPrice and burns a portion of pooled IDOL.

     * @dev Only callable from the auction contract.

     */

    function setSettledAverageAuctionPrice(

        bytes32 bondID,

        uint64 totalPaidIDOL,

        uint64 SBTAmount,

        bool isLast

    ) public override isNotEmptyAuctionInstance {

        require(

            msg.sender == address(_auctionContract),

            "msg.sender must be auction contract"

        );



        (, , uint256 solidStrikePrice, ) = _bondMakerContract.getBond(bondID);

        require(solidStrikePrice != 0, "the bond is not the form of SBT");

        _setSettledAverageAuctionPrice(

            bondID,

            totalPaidIDOL,

            SBTAmount,

            isLast

        );

    }



    /**

     * @dev Returns the IDOL amount equivalent to the strike price value of SBT.

     * @param solidBondValueE12 solidBondValueE12(USD) = SBT(SBT) * strikePrice(USD/SBT)

     */

    function calcSBT2IDOL(uint256 solidBondValueE12)

        public

        override

        view

        returns (uint256 IDOLAmountE8)

    {

        if (_solidValueTotalE12 == 0) {

            return solidBondValueE12.div(10**4);

        }



        return solidBondValueE12.mul(totalSupply()).div(_solidValueTotalE12);

    }



    function _calcUnlockablePoolAmount(bytes32 poolID, address account)

        internal

        returns (uint64)

    {

        AuctionAmountInfo memory auctionInfo = _auctionAmountInfo[poolID];

        if (!auctionInfo.isAllAmountSoldInAuction) {

            return 0;

        }



        uint256 pool = lockedPoolE8[account][poolID].IDOLAmount;

        uint256 amountE8 = lockedPoolE8[account][poolID].baseSBTAmount;

        delete lockedPoolE8[account][poolID];



        uint256 auctionIDOLPriceE8 = auctionInfo.settledAverageAuctionPrice;

        uint256 toBack = 0;



        // The return value can be calculated by

        // (average sold price) * (total sold amount) - (total distributed amount) for the bondID.

        // Here, (total distributed amount) = pool * MINT_IDOL_BORDER / LOCK_POOL_BORDER = pool * MINT_IDOL_BORDER

        if (

            auctionIDOLPriceE8.mul(amountE8).div(10**8) >

            pool.mul(MINT_IDOL_BORDER)

        ) {

            toBack =

                auctionIDOLPriceE8.mul(amountE8).div(10**8) -

                pool.mul(MINT_IDOL_BORDER);

        }



        return toBack.min(pool).toUint64();

    }



    /**

     * @notice Receives all the redeemable IDOL in one action.

     * @dev Receive corresponding pooled IDOL based on the SettledAverageAuctionPrice.

     */

    function returnLockedPoolTo(bytes32[] memory poolIDs, address account)

        public

        override

        returns (uint64)

    {

        uint256 totalBackIDOLAmount = 0;

        for (uint256 i = 0; i < poolIDs.length; i++) {

            // For each bondID, the return amount should not exceed the pooled amount.

            uint64 backIDOLAmount = _calcUnlockablePoolAmount(

                poolIDs[i],

                account

            );

            totalBackIDOLAmount = totalBackIDOLAmount.add(backIDOLAmount);

            if (backIDOLAmount != 0) {

                emit LogReturnLockedPool(poolIDs[i], account, backIDOLAmount);

            }

        }



        this.transfer(account, totalBackIDOLAmount);



        return totalBackIDOLAmount.toUint64();

    }



    function returnLockedPool(bytes32[] memory poolIDs)

        public

        override

        returns (uint64)

    {

        return returnLockedPoolTo(poolIDs, msg.sender);

    }

}

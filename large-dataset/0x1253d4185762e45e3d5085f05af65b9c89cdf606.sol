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



// File: contracts/managment/Constants.sol



pragma solidity 0.5.17;





contract Constants {

    // Permissions bit constants

    uint256 public constant CAN_MINT_TOKENS = 0;

    uint256 public constant CAN_BURN_TOKENS = 1;

    uint256 public constant CAN_UPDATE_STATE = 2;

    uint256 public constant CAN_LOCK_TOKENS = 3;

    uint256 public constant CAN_UPDATE_PRICE = 4;

    uint256 public constant CAN_INTERACT_WITH_ALLOCATOR = 5;

    uint256 public constant CAN_SET_ALLOCATOR_MAX_SUPPLY = 6;

    uint256 public constant CAN_PAUSE_TOKENS = 7;

    uint256 public constant ECLIUDED_ADDRESSES = 8;

    uint256 public constant WHITELISTED = 9;

    uint256 public constant SIGNERS = 10;

    uint256 public constant EXTERNAL_CONTRIBUTORS = 11;

    uint256 public constant CAN_SEE_BALANCE = 12;

    uint256 public constant CAN_CANCEL_TRANSACTION = 13;

    uint256 public constant CAN_ALLOCATE_REFERRAL_TOKENS = 14;

    uint256 public constant CAN_SET_REFERRAL_MAX_SUPPLY = 15;

    uint256 public constant MANUAL_TOKENS_ALLOCATION = 16;

    uint256 public constant CAN_SET_WHITELISTED = 17;



    // Contract Registry keys

    uint256 public constant CONTRACT_TOKEN = 1;

    uint256 public constant CONTRACT_PRICING = 2;

    uint256 public constant CONTRACT_CROWDSALE = 3;

    uint256 public constant CONTRACT_ALLOCATOR = 4;

    uint256 public constant CONTRACT_AGENT = 5;

    uint256 public constant CONTRACT_FORWARDER = 6;

    uint256 public constant CONTRACT_REFERRAL = 7;

    uint256 public constant CONTRACT_STATS = 8;

    uint256 public constant CONTRACT_LOCKUP = 9;



    uint256 public constant YEAR_IN_SECONDS = 31556952;

    uint256 public constant SIX_MONTHS =  15778476;

    uint256 public constant MONTH_IN_SECONDS = 2629746;



    string public constant ERROR_ACCESS_DENIED = "ERROR_ACCESS_DENIED";

    string public constant ERROR_WRONG_AMOUNT = "ERROR_WRONG_AMOUNT";

    string public constant ERROR_NO_CONTRACT = "ERROR_NO_CONTRACT";

    string public constant ERROR_NOT_AVAILABLE = "ERROR_NOT_AVAILABLE";

}



// File: contracts/managment/Management.sol



pragma solidity 0.5.17;









contract Management is Ownable, Constants {



    // Contract Registry

    mapping (uint256 => address payable) public contractRegistry;



    // Permissions

    mapping (address => mapping(uint256 => bool)) public permissions;



    event PermissionsSet(

        address subject, 

        uint256 permission, 

        bool value

    );



    event ContractRegistered(

        uint256 key,

        address source,

        address target

    );



    function setPermission(

        address _address, 

        uint256 _permission, 

        bool _value

    )

        public

        onlyOwner

    {

        permissions[_address][_permission] = _value;

        emit PermissionsSet(_address, _permission, _value);

    }



    function registerContract(

        uint256 _key, 

        address payable _target

    ) 

        public 

        onlyOwner 

    {

        contractRegistry[_key] = _target;

        emit ContractRegistered(_key, address(0), _target);

    }



    function setWhitelisted(

        address _address,

        bool _value

    )

        public

    {

        require(

            permissions[msg.sender][CAN_SET_WHITELISTED] == true,

            ERROR_ACCESS_DENIED

        );



        permissions[_address][WHITELISTED] = _value;



        emit PermissionsSet(_address, WHITELISTED, _value);

    }



}



// File: contracts/managment/Managed.sol



pragma solidity 0.5.17;













contract Managed is Ownable, Constants {



    using SafeMath for uint256;



    Management public management;



    modifier requirePermission(uint256 _permissionBit) {

        require(

            hasPermission(msg.sender, _permissionBit),

            ERROR_ACCESS_DENIED

        );

        _;

    }



    modifier canCallOnlyRegisteredContract(uint256 _key) {

        require(

            msg.sender == management.contractRegistry(_key),

            ERROR_ACCESS_DENIED

        );

        _;

    }



    modifier requireContractExistsInRegistry(uint256 _key) {

        require(

            management.contractRegistry(_key) != address(0),

            ERROR_NO_CONTRACT

        );

        _;

    }



    constructor(address _managementAddress) public {

        management = Management(_managementAddress);

    }



    function setManagementContract(address _management) public onlyOwner {

        require(address(0) != _management, ERROR_NO_CONTRACT);



        management = Management(_management);

    }



    function hasPermission(address _subject, uint256 _permissionBit)

        internal

        view

        returns (bool)

    {

        return management.permissions(_subject, _permissionBit);

    }



}



// File: contracts/LockupContract.sol



pragma solidity 0.5.17;









contract LockupContract is Managed {

    using SafeMath for uint256;



    uint256 public constant PERCENT_ABS_MAX = 100;

    bool public isPostponedStart;

    uint256 public postponedStartDate;



    mapping(address => uint256[]) public lockedAllocationData;



    mapping(address => uint256) public manuallyLockedBalances;



    event Lock(address holderAddress, uint256 amount);



    constructor(address _management) public Managed(_management) {

        isPostponedStart = true;

    }



    function isTransferAllowed(

        address _address,

        uint256 _value,

        uint256 _time,

        uint256 _holderBalance

    )

    external

    view

    returns (bool)

    {

        uint256 unlockedBalance = getUnlockedBalance(

            _address,

            _time,

            _holderBalance

        );

        if (unlockedBalance >= _value) {

            return true;

        }

        return false;

    }



    function allocationLog(

        address _address,

        uint256 _amount,

        uint256 _startingAt,

        uint256 _lockPeriodInSeconds,

        uint256 _initialUnlockInPercent,

        uint256 _releasePeriodInSeconds

    )

        public

        requirePermission(CAN_LOCK_TOKENS)

    {

        lockedAllocationData[_address].push(_startingAt);

        if (_initialUnlockInPercent > 0) {

            _amount = _amount.mul(uint256(PERCENT_ABS_MAX)

                .sub(_initialUnlockInPercent)).div(PERCENT_ABS_MAX);

        }

        lockedAllocationData[_address].push(_amount);

        lockedAllocationData[_address].push(_lockPeriodInSeconds);

        lockedAllocationData[_address].push(_releasePeriodInSeconds);

        emit Lock(_address, _amount);

    }



    function getUnlockedBalance(

        address _address,

        uint256 _time,

        uint256 _holderBalance

    )

        public

        view

        returns (uint256)

    {

        uint256 blockedAmount = manuallyLockedBalances[_address];



        if (lockedAllocationData[_address].length == 0) {

            return _holderBalance.sub(blockedAmount);

        }

        uint256[] memory  addressLockupData = lockedAllocationData[_address];

        for (uint256 i = 0; i < addressLockupData.length / 4; i++) {

            uint256 lockedAt = addressLockupData[i.mul(4)];

            uint256 lockedBalance = addressLockupData[i.mul(4).add(1)];

            uint256 lockPeriodInSeconds = addressLockupData[i.mul(4).add(2)];

            uint256 _releasePeriodInSeconds = addressLockupData[

                i.mul(4).add(3)

            ];

            if (lockedAt == 0 && true == isPostponedStart) {

                if (postponedStartDate == 0) {

                    blockedAmount = blockedAmount.add(lockedBalance);

                    continue;

                }

                lockedAt = postponedStartDate;

            }

            if (lockedAt > _time) {

                blockedAmount = blockedAmount.add(lockedBalance);

                continue;

            }

            if (lockedAt.add(lockPeriodInSeconds) > _time) {

                if (lockedBalance == 0) {

                    blockedAmount = _holderBalance;

                    break;

                } else {

                    uint256 tokensUnlocked;

                    if (_releasePeriodInSeconds > 0) {

                        uint256 duration = (_time.sub(lockedAt))

                            .div(_releasePeriodInSeconds);

                        tokensUnlocked = lockedBalance.mul(duration)

                            .mul(_releasePeriodInSeconds)

                            .div(lockPeriodInSeconds);

                    }

                    blockedAmount = blockedAmount

                        .add(lockedBalance)

                        .sub(tokensUnlocked);

                }

            }

        }



        return _holderBalance.sub(blockedAmount);

    }



    function setManuallyLockedForAddress (

        address _holder,

        uint256 _balance

    )

        public

        requirePermission(CAN_LOCK_TOKENS)

    {

        manuallyLockedBalances[_holder] = _balance;

    }



    function setPostponedStartDate(uint256 _postponedStartDate)

        public

        requirePermission(CAN_LOCK_TOKENS)

    {

        postponedStartDate = _postponedStartDate;



    }

}

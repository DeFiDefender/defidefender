// File: openzeppelin-solidity/contracts/ownership/Ownable.sol



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

contract Ownable {

    address private _owner;



    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);



    /**

     * @dev Initializes the contract setting the deployer as the initial owner.

     */

    constructor () internal {

        _owner = msg.sender;

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

        return msg.sender == _owner;

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

}



// File: openzeppelin-solidity/contracts/access/Roles.sol



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



// File: openzeppelin-solidity/contracts/math/SafeMath.sol



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

        require(b <= a, "SafeMath: subtraction overflow");

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

        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522

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

        // Solidity only automatically asserts when dividing by 0

        require(b > 0, "SafeMath: division by zero");

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

        require(b != 0, "SafeMath: modulo by zero");

        return a % b;

    }

}



// File: contracts/membership/ManagerRole.sol



/**

 * @title Manager Role

 * @dev This contract is developed based on the Manager contract of OpenZeppelin.

 * The key difference is the management of the manager roles is restricted to one owner

 * account. At least one manager should exist in any situation.

 * @author Validity Labs AG <info@validitylabs.org>

 */

// solhint-disable-next-line compiler-fixed, compiler-gt-0_5

pragma solidity ^0.5.0;











contract ManagerRole is Ownable {

    using Roles for Roles.Role;

    using SafeMath for uint256;



    event ManagerAdded(address indexed account);

    event ManagerRemoved(address indexed account);



    Roles.Role private managers;

    uint256 private _numManager;



    constructor() internal {

        _addManager(msg.sender);

        _numManager = 1;

    }



    /**

     * @notice Only manager can take action

     */

    modifier onlyManager() {

        require(isManager(msg.sender), "The account is not a manager");

        _;

    }



    /**

     * @notice This function allows to add managers in batch with control of the number of 

     * interations

     * @param accounts The accounts to be added in batch

     */

    // solhint-disable-next-line

    function addManagers(address[] calldata accounts) external onlyOwner {

        uint256 length = accounts.length;

        require(length <= 256, "too many accounts");

        for (uint256 i = 0; i < length; i++) {

            _addManager(accounts[i]);

        }

    }

    

    /**

     * @notice Add an account to the list of managers,

     * @param account The account address whose manager role needs to be removed.

     */

    function removeManager(address account) external onlyOwner {

        _removeManager(account);

    }



    /**

     * @notice Check if an account is a manager

     * @param account The account to be checked if it has a manager role

     * @return true if the account is a manager. Otherwise, false

     */

    function isManager(address account) public view returns (bool) {

        return managers.has(account);

    }



    /**

     *@notice Get the number of the current managers

     */

    function numManager() public view returns (uint256) {

        return _numManager;

    }



    /**

     * @notice Add an account to the list of managers,

     * @param account The account that needs to tbe added as a manager

     */

    function addManager(address account) public onlyOwner {

        require(account != address(0), "account is zero");

        _addManager(account);

    }



    /**

     * @notice Renounce the manager role

     * @dev This function was not explicitly required in the specs. There should be at

     * least one manager at any time. Therefore, at least two when one manage renounces

     * themselves.

     */

    function renounceManager() public {

        require(_numManager >= 2, "Managers are fewer than 2");

        _removeManager(msg.sender);

    }



    /** OVERRIDE 

    * @notice Allows the current owner to relinquish control of the contract.

    * @dev Renouncing to ownership will leave the contract without an owner.

    * It will not be possible to call the functions with the `onlyOwner`

    * modifier anymore.

    */

    function renounceOwnership() public onlyOwner {

        revert("Cannot renounce ownership");

    }



    /**

     * @notice Internal function to be called when adding a manager

     * @param account The address of the manager-to-be

     */

    function _addManager(address account) internal {

        _numManager = _numManager.add(1);

        managers.add(account);

        emit ManagerAdded(account);

    }



    /**

     * @notice Internal function to remove one account from the manager list

     * @param account The address of the to-be-removed manager

     */

    function _removeManager(address account) internal {

        _numManager = _numManager.sub(1);

        managers.remove(account);

        emit ManagerRemoved(account);

    }

}



// File: contracts/membership/PausableManager.sol



/**

 * @title Pausable Manager Role

 * @dev This manager can also pause a contract. This contract is developed based on the 

 * Pause contract of OpenZeppelin.

 * @author Validity Labs AG <info@validitylabs.org>

 */

// solhint-disable-next-line compiler-fixed, compiler-gt-0_5

pragma solidity ^0.5.0;







contract PausableManager is ManagerRole {



    event BePaused(address manager);

    event BeUnpaused(address manager);



    bool private _paused;   // If the crowdsale contract is paused, controled by the manager...



    constructor() internal {

        _paused = false;

    }



   /**

    * @notice Modifier to make a function callable only when the contract is not paused.

    */

    modifier whenNotPaused() {

        require(!_paused, "not paused");

        _;

    }



    /**

    * @notice Modifier to make a function callable only when the contract is paused.

    */

    modifier whenPaused() {

        require(_paused, "paused");

        _;

    }



    /**

    * @return true if the contract is paused, false otherwise.

    */

    function paused() public view returns(bool) {

        return _paused;

    }



    /**

    * @notice called by the owner to pause, triggers stopped state

    */

    function pause() public onlyManager whenNotPaused {

        _paused = true;

        emit BePaused(msg.sender);

    }



    /**

    * @notice called by the owner to unpause, returns to normal state

    */

    function unpause() public onlyManager whenPaused {

        _paused = false;

        emit BeUnpaused(msg.sender);

    }

}



// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol



pragma solidity ^0.5.0;



/**

 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include

 * the optional functions; to access them see `ERC20Detailed`.

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

     * Emits a `Transfer` event.

     */

    function transfer(address recipient, uint256 amount) external returns (bool);



    /**

     * @dev Returns the remaining number of tokens that `spender` will be

     * allowed to spend on behalf of `owner` through `transferFrom`. This is

     * zero by default.

     *

     * This value changes when `approve` or `transferFrom` are called.

     */

    function allowance(address owner, address spender) external view returns (uint256);



    /**

     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.

     *

     * Returns a boolean value indicating whether the operation succeeded.

     *

     * > Beware that changing an allowance with this method brings the risk

     * that someone may use both the old and the new allowance by unfortunate

     * transaction ordering. One possible solution to mitigate this race

     * condition is to first reduce the spender's allowance to 0 and set the

     * desired value afterwards:

     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729

     *

     * Emits an `Approval` event.

     */

    function approve(address spender, uint256 amount) external returns (bool);



    /**

     * @dev Moves `amount` tokens from `sender` to `recipient` using the

     * allowance mechanism. `amount` is then deducted from the caller's

     * allowance.

     *

     * Returns a boolean value indicating whether the operation succeeded.

     *

     * Emits a `Transfer` event.

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

     * a call to `approve`. `value` is the new allowance.

     */

    event Approval(address indexed owner, address indexed spender, uint256 value);

}



// File: openzeppelin-solidity/contracts/utils/Address.sol



pragma solidity ^0.5.0;



/**

 * @dev Collection of functions related to the address type,

 */

library Address {

    /**

     * @dev Returns true if `account` is a contract.

     *

     * This test is non-exhaustive, and there may be false-negatives: during the

     * execution of a contract's constructor, its address will be reported as

     * not containing a contract.

     *

     * > It is unsafe to assume that an address for which this function returns

     * false is an externally-owned account (EOA) and not a contract.

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

}



// File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol



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

        uint256 newAllowance = token.allowance(address(this), spender).sub(value);

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



// File: contracts/property/Reclaimable.sol



/**

 * @title Reclaimable

 * @dev This contract gives owner right to recover any ERC20 tokens accidentally sent to 

 * the token contract. The recovered token will be sent to the owner of token. 

 * @author Validity Labs AG <info@validitylabs.org>

 */

// solhint-disable-next-line compiler-fixed, compiler-gt-0_5

pragma solidity ^0.5.0;











contract Reclaimable is Ownable {

    using SafeERC20 for IERC20;



    /**

     * @notice Let the owner to retrieve other tokens accidentally sent to this contract.

     * @dev This function is suitable when no token of any kind shall be stored under

     * the address of the inherited contract.

     * @param tokenToBeRecovered address of the token to be recovered.

     */

    function reclaimToken(IERC20 tokenToBeRecovered) external onlyOwner {

        uint256 balance = tokenToBeRecovered.balanceOf(address(this));

        tokenToBeRecovered.safeTransfer(owner(), balance);

    }

}



// File: contracts/property/CounterGuard.sol



/**

 * @title modifier contract that guards certain properties only triggered once

 * @author Validity Labs AG <info@validitylabs.org>

 */

// solhint-disable-next-line compiler-fixed, compiler-gt-0_5

pragma solidity ^0.5.0;





contract CounterGuard {

    /**

     * @notice Controle if a boolean attribute (false by default) was updated to true.

     * @dev This attribute is designed specifically for recording an action.

     * @param criterion The boolean attribute that records if an action has taken place

     */

    modifier onlyOnce(bool criterion) {

        require(criterion == false, "Already been set");

        _;

    }

}



// File: contracts/property/ValidAddress.sol



/**

 * @title modifier contract that checks if the address is valid

 * @author Validity Labs AG <info@validitylabs.org>

 */

// solhint-disable-next-line compiler-fixed, compiler-gt-0_5

pragma solidity ^0.5.0;





contract ValidAddress {

    /**

     * @notice Check if the address is not zero

     */

    modifier onlyValidAddress(address _address) {

        require(_address != address(0), "Not a valid address");

        _;

    }



    /**

     * @notice Check if the address is not the sender's address

    */

    modifier isSenderNot(address _address) {

        require(_address != msg.sender, "Address is the same as the sender");

        _;

    }



    /**

     * @notice Check if the address is the sender's address

    */

    modifier isSender(address _address) {

        require(_address == msg.sender, "Address is different from the sender");

        _;

    }

}



// File: contracts/vault/IVault.sol



/*

 * @title Interface for basic vaults

 * @author Validity Labs AG <info@validitylabs.org>

 */

// solhint-disable-next-line compiler-fixed, compiler-gt-0_5

pragma solidity ^0.5.0;





contract IVault {

    /**

     * @notice Adding beneficiary to the vault

     * @param beneficiary The account that receives token

     * @param value The amount of token allocated

     */

    function receiveFor(address beneficiary, uint256 value) public;



    /**

     * @notice Update the releaseTime for vaults

     * @param roundEndTime The new releaseTime

     */

    function updateReleaseTime(uint256 roundEndTime) public;

}



// File: contracts/vault/BasicVault.sol



/**

 * @title Vault for private sale, presale, and SAFT

 * @dev Inspired by the TokenTimelock contract of OpenZeppelin

 * @author Validity Labs AG <info@validitylabs.org>

 */

// solhint-disable-next-line compiler-fixed, compiler-gt-0_5

pragma solidity ^0.5.0;



















contract BasicVault is IVault, Reclaimable, CounterGuard, ValidAddress, PausableManager {

    using SafeERC20 for IERC20;

    using SafeMath for uint256;



    // ERC20 basic token contract being held

    IERC20 private _token;

    // The following info can only been updated by the crowdsale contract.

    // amount of tokens that each beneficiary deposits into this vault

    mapping(address=>uint256) private _balances;

    // what a vault should contain

    uint256 private _totalBalance;

    // timestamp of the possible update

    uint256 private _updateTime;

    // timestamp when token release is enabled

    uint256 private _releaseTime;

    // if the _releaseTime is effective

    bool private _knownReleaseTime;

    address private _crowdsale;



    event Received(address indexed owner, uint256 value);

    event Released(address indexed owner, uint256 value);

    event ReleaseTimeUpdated(address indexed account, uint256 updateTime, uint256 releaseTime);



    /**

     * @notice When timing is correct.

     */

    modifier readyToRelease {

        require(_knownReleaseTime && (block.timestamp >= _releaseTime), "Not ready to release");

        _;

    }



    /**

     * @notice When timing is correct.

     */

    modifier saleNotEnd {

        require(!_knownReleaseTime || (block.timestamp < _updateTime), "Cannot modifiy anymore");

        _;

    }



    /**

     * @notice Only crowdsale contract could take actions

     */

    modifier onlyCrowdsale {

        require(msg.sender == _crowdsale, "The caller is not the crowdsale contract");

        _;

    }

    

    

    /**

     * @notice Create a vault

     * @dev Upon the creation of the contract, the ownership should be transferred to the 

     * crowdsale contract.

     * @param token The address of the token contract

     * @param crowdsale The address of the crowdsale contract

     * @param knownWhenToRelease If the release time is known at creation time

     * @param updateTime The timestamp before which information is still updatable in this

     * contract

     * @param releaseTime The timestamp after which investors could claim their belongings.

     */

    /* solhint-disable */

    constructor(

        IERC20 token,

        address crowdsale,

        bool knownWhenToRelease,

        uint256 updateTime,

        uint256 releaseTime

    )

        public

        onlyValidAddress(crowdsale)

        isSenderNot(crowdsale)

    {

        _token = token;

        _crowdsale = crowdsale;

        _knownReleaseTime = knownWhenToRelease;

        _updateTime = updateTime;

        _releaseTime = releaseTime;

    }

    /* solhint-enable */



    /** OVERRIDE

     * @notice Let token owner to get the other tokens accidentally sent to this token address.

     * @dev This function allows the contract to hold certain amount of IvoToken, of 

     * which the token address is defined in the constructor of the contract.

     * @param tokenToBeRecovered address of the token to be recovered.

     */

    function reclaimToken(IERC20 tokenToBeRecovered) external onlyOwner {

        // only if the token is not the IVO token

        uint256 balance = tokenToBeRecovered.balanceOf(address(this));

        if (tokenToBeRecovered == _token) {

            tokenToBeRecovered.safeTransfer(owner(), balance.sub(_totalBalance));

        } else {

            tokenToBeRecovered.safeTransfer(owner(), balance);

        }

    }



    /**

     * @notice Give back the balance of a beneficiary

     * @param beneficiary The address of the beneficiary

     * @return The balance of the beneficiary 

     */

    function balanceOf(address beneficiary) public view returns (uint256) {

        return _balances[beneficiary];

    }



    /**

     * @return the total amount of token being held in this vault

     */

    function totalBalance() public view returns(uint256) {

        return _totalBalance;

    }



    /**

     * @return the token being held.

     */

    function token() public view returns(IERC20) {

        return _token;

    }



    /**

     * @return the address of the crowdsale contract.

     */

    function crowdsale() public view returns(address) {

        return _crowdsale;

    }



    /**

     * @return the time when the tokens are released.

     */

    function releaseTime() public view returns(uint256) {

        return _releaseTime;

    }



    /**

     * @return the time before when the update is still acceptable.

     */

    function updateTime() public view returns(uint256) {

        return _updateTime;

    }



    /**

     * @return the if the release time is known.

     */

    function knownReleaseTime() public view returns(bool) {

        return _knownReleaseTime;

    }



    /**

     * @notice function called by either crowdsale contract or the token minter, depending

     * on the type of the vault.

     * @param beneficiary The actual token owner once it gets released

     * @param value The amount of token associated to the beneficiary

     */

    function receiveFor(address beneficiary, uint256 value)

        public 

        saleNotEnd

        onlyManager

    {

        _receiveFor(beneficiary, value);

    }



    /**

    * @notice Transfers tokens held by the vault to beneficiary.

    */

    function release() public readyToRelease {

        _releaseFor(msg.sender, _balances[msg.sender]);

    }



    /**

    * @notice Transfers tokens held by the vault to beneficiary, who is differnt from the

    * msg.sender

    * @param account The account address for whom the vault releases the IVO token.

    */

    function releaseFor(address account) public readyToRelease {

        _releaseFor(account, _balances[account]);

    }



    /**

     * @notice Disable the update release time function

     * @dev By default this functionality is banned, only certain vaults can 

     * updateReleaseTime and thus override this function.

     */

     // solhint-disable-next-line

    function updateReleaseTime(uint256 newTime) public {

        revert("cannot update release time");

    }



    /**

     * @notice The vault receives tokens on behalf of an account

     * @param account The account address

     * @param value The acount received

     */

    function _receiveFor(address account, uint256 value) internal {

        _balances[account] = _balances[account].add(value);

        _totalBalance = _totalBalance.add(value);

        emit Received(account, value);

    }



     /**

     * @notice The vault releases tokens on behalf of an account

     * @param account The account address

     * @param amount The amount of token to be released

     */

    function _releaseFor(address account, uint256 amount) internal {

        require(amount > 0 && _balances[account] >= amount, "the account does not have enough amount");



        _balances[account] = _balances[account].sub(amount);

        _totalBalance = _totalBalance.sub(amount);



        _token.safeTransfer(account, amount);

        emit Released(account, amount);

    }



    /**

     * @notice Only updatable when this release time was not set up previously

     * @param newUpdateTime The timestamp before which information is still updatable in this vault

     * @param newReleaseTime The timestamp before which token cannot be retrieved.

     */

    function _updateReleaseTime(uint256 newUpdateTime, uint256 newReleaseTime) 

        internal

        onlyOnce(_knownReleaseTime) 

    {

        _knownReleaseTime = true;

        _updateTime = newUpdateTime;

        _releaseTime = newReleaseTime;

        emit ReleaseTimeUpdated(msg.sender, newUpdateTime, newReleaseTime);

    }



    /**

     * @notice Directly transfer the ownership to an address of Invao managing team

     * This owner does not necessarily be the manage of the contract.

     * @param newOwner The address of the new owner of the contract

     */

    function roleSetup(address newOwner) internal {

        _removeManager(msg.sender);

        transferOwnership(newOwner);

    }

}



// File: contracts/vault/ReserveVault.sol



/**

 * @title Reserve Vault

 * @author Validity Labs AG <info@validitylabs.org>

 */

// solhint-disable-next-line compiler-fixed, compiler-gt-0_5

pragma solidity ^0.5.0;











contract ReserveVault is BasicVault {

    using SafeERC20 for IERC20;

    using SafeMath for uint256;



    /*** PRE-DEPLOYMENT CONFIGURED CONSTANTS */

    uint256 private constant ALLOCATION = 10000000 ether;

    uint256 private constant RELEASE_PERIOD = 0 days; // End of STO

    uint256 private constant DEFAULT_RELEASETIME = 9999 days;  // A default time, doesn't really matter

    address private constant COMPANY_WALLET = 0x2EE30702c752c9f554dF867dF21D5b7f9865626d;



    /**

     * @notice Create the reserve vault

     * @dev Upon the creation of the contract.

     * @param token The address of the token contract

     * @param crowdsale The address of the crowdsale contract

     * @param newOwner The address of the new owner of this contract.

     */

    /* solhint-disable */

    constructor(

        IERC20 token,

        address crowdsale,

        address newOwner

    )

        public

        BasicVault(token, crowdsale, false, DEFAULT_RELEASETIME, DEFAULT_RELEASETIME)

    {

        _receiveFor(COMPANY_WALLET, ALLOCATION);

        roleSetup(newOwner);

    }

    /* solhint-enable */



    /** OVERRIDE

     * @dev When the crowdsale is closed, set the release time for this vault

     * @param crowdsaleEndTime The actual block.timestamp given by the crowdsale contract.

     * Time when the STO (3rd round) ends.

     */

    function updateReleaseTime(uint256 crowdsaleEndTime) 

        public 

        onlyCrowdsale

    {

        uint256 realReleaseTime = crowdsaleEndTime.add(RELEASE_PERIOD);

        _updateReleaseTime(crowdsaleEndTime, realReleaseTime);

    }



    /** OVERRIDE

     * @dev Cannot receive any other beneficiary

     * @param beneficiary The actual token owner once it gets released

     * @param value The amount of token associated to the beneficiary

     */

    // solhint-disable-next-line

    function receiveFor(address beneficiary, uint256 value) public {

        revert("cannot call receiceFor");

    }

}

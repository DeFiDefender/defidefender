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



/**

 * @title SafeMath

 * @dev Math operations with safety checks that revert on error

 */

library SafeMath {



    /**

     * @dev Multiplies two numbers, reverts on overflow.

     */

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {

        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the

        // benefit is lost if 'b' is also tested.

        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522

        if (a == 0) {

            return 0;

        }



        uint256 c = a * b;

        require(c / a == b);



        return c;

    }



    /**

     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.

     */

    function div(uint256 a, uint256 b) internal pure returns (uint256) {

        require(b > 0); // Solidity only automatically asserts when dividing by 0

        uint256 c = a / b;

        // assert(a == b * c + a % b); // There is no case in which this doesn't hold



        return c;

    }



    /**

     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).

     */

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {

        require(b <= a);

        uint256 c = a - b;



        return c;

    }



    /**

     * @dev Adds two numbers, reverts on overflow.

     */

    function add(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a + b;

        require(c >= a);



        return c;

    }

}



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



/**

 * @title ERC20 interface

 * @dev see https://github.com/ethereum/EIPs/issues/20

 */

interface IERC20 {

    function transfer(address to, uint256 value) external returns (bool);



    function approve(address spender, uint256 value) external returns (bool);



    function transferFrom(address from, address to, uint256 value) external returns (bool);



    function totalSupply() external view returns (uint256);



    function balanceOf(address who) external view returns (uint256);



    function allowance(address owner, address spender) external view returns (uint256);



    function mint(address to, uint256 value) external returns (bool);



    event Transfer(address indexed from, address indexed to, uint256 value);



    event Approval(address indexed owner, address indexed spender, uint256 value);

}



/**

 * @dev Multiownable smart contract

 * which allows to many ETH wallets to manage main smart contract.

 */

contract Multiownable {

    // VARIABLES



    uint256 internal _ownersGeneration;

    uint256 internal _howManyOwnersDecide;

    address[] internal _owners;

    bytes32[] internal _allOperations;

    address internal _insideCallSender;

    uint256 internal _insideCallCount;



    // Reverse lookup tables for owners and allOperations

    mapping(address => uint256) public ownersIndices; // Starts from 1

    mapping(bytes32 => uint256) public allOperationsIndicies;



    // Owners voting mask per operations

    mapping(bytes32 => uint256) public votesMaskByOperation;

    mapping(bytes32 => uint256) public votesCountByOperation;



    // EVENTS



    event OwnershipTransferred(address[] previousOwners, uint256 howManyOwnersDecide, address[] newOwners, uint256 newHowManyOwnersDecide);

    event OperationCreated(bytes32 operation, uint256 howMany, uint256 ownersCount, address proposer);

    event OperationUpvoted(bytes32 operation, uint256 votes, uint256 howMany, uint256 ownersCount, address upvoter);

    event OperationPerformed(bytes32 operation, uint256 howMany, uint256 ownersCount, address performer);

    event OperationDownvoted(bytes32 operation, uint256 votes, uint256 ownersCount,  address downvoter);

    event OperationCancelled(bytes32 operation, address lastCanceller);

    

    // ACCESSORS



    function isOwner(address wallet) external view returns (bool) {

        return ownersIndices[wallet] > 0;

    }



    function ownersCount() external view returns (uint256) {

        return _owners.length;

    }



    function allOperationsCount() external view returns (uint256) {

        return _allOperations.length;

    }



    // MODIFIERS



    /**

     * @dev Allows to perform method by any of the owners

     */

    modifier onlyAnyOwner {

        if (checkHowManyOwners(1)) {

            bool update = (_insideCallSender == address(0));

            if (update) {

                _insideCallSender = msg.sender;

                _insideCallCount = 1;

            }

            _;

            if (update) {

                _insideCallSender = address(0);

                _insideCallCount = 0;

            }

        }

    }



    /**

     * @dev Allows to perform method only after many owners call it with the same arguments

     */

    modifier onlyManyOwners {

        if (checkHowManyOwners(_howManyOwnersDecide)) {

            bool update = (_insideCallSender == address(0));

            if (update) {

                _insideCallSender = msg.sender;

                _insideCallCount = _howManyOwnersDecide;

            }

            _;

            if (update) {

                _insideCallSender = address(0);

                _insideCallCount = 0;

            }

        }

    }



    /**

     * @dev Allows to perform method only after all owners call it with the same arguments

     */

    modifier onlyAllOwners {

        if (checkHowManyOwners(_owners.length)) {

            bool update = (_insideCallSender == address(0));

            if (update) {

                _insideCallSender = msg.sender;

                _insideCallCount = _owners.length;

            }

            _;

            if (update) {

                _insideCallSender = address(0);

                _insideCallCount = 0;

            }

        }

    }



    /**

     * @dev Allows to perform method only after some owners call it with the same arguments

     */

    modifier onlySomeOwners(uint256 howMany) {

        require(howMany > 0, "onlySomeOwners: howMany argument is zero");

        require(howMany <= _owners.length, "onlySomeOwners: howMany argument exceeds the number of owners");

        

        if (checkHowManyOwners(howMany)) {

            bool update = (_insideCallSender == address(0));

            if (update) {

                _insideCallSender = msg.sender;

                _insideCallCount = howMany;

            }

            _;

            if (update) {

                _insideCallSender = address(0);

                _insideCallCount = 0;

            }

        }

    }



    // CONSTRUCTOR



    constructor() public {

        _owners.push(msg.sender);

        ownersIndices[msg.sender] = 1;

        _howManyOwnersDecide = 1;

    }



    // INTERNAL METHODS



    /**

     * @dev onlyManyOwners modifier helper

     */

    function checkHowManyOwners(uint256 howMany) internal returns (bool) {

        if (_insideCallSender == msg.sender) {

            require(howMany <= _insideCallCount, "checkHowManyOwners: nested owners modifier check require more owners");

            return true;

        }



        uint256 ownerIndex = ownersIndices[msg.sender] - 1;

        require(ownerIndex < _owners.length, "checkHowManyOwners: msg.sender is not an owner");



        bytes32 operation = keccak256(abi.encodePacked(msg.data, _ownersGeneration));

        require((votesMaskByOperation[operation] & (2 ** ownerIndex)) == 0, "checkHowManyOwners: owner already voted for the operation");



        votesMaskByOperation[operation] |= (2 ** ownerIndex);

        uint256 operationVotesCount = votesCountByOperation[operation] + 1;

        votesCountByOperation[operation] = operationVotesCount;



        if (operationVotesCount == 1) {

            allOperationsIndicies[operation] = _allOperations.length;

            _allOperations.push(operation);

            emit OperationCreated(operation, howMany, _owners.length, msg.sender);

        }



        emit OperationUpvoted(operation, operationVotesCount, howMany, _owners.length, msg.sender);



        // If enough owners confirmed the same operation

        if (votesCountByOperation[operation] == howMany) {

            deleteOperation(operation);

            emit OperationPerformed(operation, howMany, _owners.length, msg.sender);

            return true;

        }



        return false;

    }



    /**

     * @dev Used to delete cancelled or performed operation

     * @param operation defines which operation to delete

     */

    function deleteOperation(bytes32 operation) internal {

        uint256 index = allOperationsIndicies[operation];



        if (index < _allOperations.length - 1) { // Not last

            _allOperations[index] = _allOperations[_allOperations.length - 1];

            allOperationsIndicies[_allOperations[index]] = index;

        }



        _allOperations.length--;



        delete votesMaskByOperation[operation];

        delete votesCountByOperation[operation];

        delete allOperationsIndicies[operation];

    }



    // PUBLIC METHODS



    /**

     * @dev Allows owners to change their mind by cacnelling votesMaskByOperation operations

     * @param operation defines which operation to delete

     */

    function cancelPending(bytes32 operation) external onlyAnyOwner {

        uint256 ownerIndex = ownersIndices[msg.sender] - 1;

        require((votesMaskByOperation[operation] & (2 ** ownerIndex)) != 0, "cancelPending: operation not found for this user");



        votesMaskByOperation[operation] &= ~(2 ** ownerIndex);

        uint256 operationVotesCount = votesCountByOperation[operation] - 1;

        votesCountByOperation[operation] = operationVotesCount;



        emit OperationDownvoted(operation, operationVotesCount, _owners.length, msg.sender);



        if (operationVotesCount == 0) {

            deleteOperation(operation);

            emit OperationCancelled(operation, msg.sender);

        }

    }



    /**

     * @dev Allows owners to change ownership

     * @param newOwners defines array of addresses of new owners

     */

    function transferOwnership(address[] calldata newOwners) external {

        transferOwnershipWithHowMany(newOwners, newOwners.length);

    }



    /**

     * @dev Allows owners to change ownership

     * @param newOwners defines array of addresses of new owners

     * @param newHowManyOwnersDecide defines how many owners can decide

     */

    function transferOwnershipWithHowMany(address[] memory newOwners, uint256 newHowManyOwnersDecide) public onlyManyOwners {

        require(newOwners.length > 0, "transferOwnershipWithHowMany: owners array is empty");

        require(newOwners.length <= 256, "transferOwnershipWithHowMany: owners count is greater then 256");

        require(newHowManyOwnersDecide > 0, "transferOwnershipWithHowMany: newHowManyOwnersDecide equal to 0");

        require(newHowManyOwnersDecide <= newOwners.length, "transferOwnershipWithHowMany: newHowManyOwnersDecide exceeds the number of owners");



        // Reset owners reverse lookup table

        for (uint256 j = 0; j < _owners.length; j++) {

            delete ownersIndices[_owners[j]];

        }



        for (uint256 i = 0; i < newOwners.length; i++) {

            require(newOwners[i] != address(0), "transferOwnershipWithHowMany: owners array contains zero");

            require(ownersIndices[newOwners[i]] == 0, "transferOwnershipWithHowMany: owners array contains duplicates");

            ownersIndices[newOwners[i]] = i + 1;

        }

        

        emit OwnershipTransferred(_owners, _howManyOwnersDecide, newOwners, newHowManyOwnersDecide);



        _owners = newOwners;

        _howManyOwnersDecide = newHowManyOwnersDecide;

        _allOperations.length = 0;

        _ownersGeneration++;

    }



    // GETTERS



    function getOwnersGeneration() external view returns (uint256) {

        return _ownersGeneration;

    }

    

    function getHowManyOwnersDecide() external view returns (uint256) {

        return _howManyOwnersDecide;

    }



    function getInsideCallSender() external view returns (address) {

        return _insideCallSender;

    }



    function getInsideCallCount() external view returns (uint256) {

        return _insideCallCount;

    }



    function getOwners() external view returns(address [] memory) {

        return _owners;

    }



    function getAllOperations() external view returns (bytes32 [] memory) {

        return _allOperations;

    }

}



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



/**

 * @title WhitelistedRole

 * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a

 * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove

 * it), and not Whitelisteds themselves.

 */

contract WhitelistedRole is Multiownable {

    using Roles for Roles.Role;



    event WhitelistedAdded(address indexed account);

    event WhitelistedRemoved(address indexed account);



    Roles.Role private _whitelisteds;



    modifier onlyWhitelisted() {

        require(isWhitelisted(msg.sender), "WhitelistedRole: caller does not have the Whitelisted role");

        _;

    }



    function isWhitelisted(address account) public view returns (bool) {

        return _whitelisteds.has(account);

    }



    function addWhitelisted(address account) public onlyManyOwners {

        _addWhitelisted(account);

    }



    function removeWhitelisted(address account) public onlyManyOwners {

        _removeWhitelisted(account);

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



/**

 * @title Staking smart contract

 */

contract Staking is WhitelistedRole {

    using SafeMath for uint256;

    using SafeERC20 for IERC20;



    // whitelisted users amount

    uint256 private _usersAmount;



    // timestamp when last time deposit was deposited tokens

    uint256 private _lastDepositDone;



    // only once per 30 days depositor can deposit tokens

    uint256 private constant _depositDelay = 30 days;



    // the address of depositor

    address private _depositor;



    // how much deposits depositor done

    uint256 private _depositsAmount;



    struct DepositData {

        uint256 tokens;

        uint256 usersLength;

    }



    // here we store the history of deposits amount per each delay

    mapping(uint256 => DepositData) private _depositedPerDelay;



    // here we store user address => last deposit amount for withdraw calculation

    // if user missed withdrawal of few months he can withdraw all tokens once

    mapping(address => uint256) private _userWithdraws;



    // interface of ERC20 Yazom

    IERC20 private _yazom;



    // events for watching

    event Deposited(uint256 amount);

    event Withdrawen(address indexed user, uint256 amount);



    // -----------------------------------------

    // CONSTRUCTOR

    // -----------------------------------------



    constructor (address depositor, IERC20 yazom) public {

        _depositor = depositor;

        _yazom = yazom;

    }



    // -----------------------------------------

    // EXTERNAL

    // -----------------------------------------



    function () external payable {

        // revert fallback methods

        revert();

    }



    function deposit() external {

        require(msg.sender == _depositor, "deposit: only the depositor can deposit tokens");

        require(block.timestamp >= _lastDepositDone.add(_depositDelay), "deposit: can not deposit now");



        uint256 tokensAmount = _yazom.allowance(_depositor, address(this));

        _yazom.safeTransferFrom(_depositor, address(this), tokensAmount);



        _lastDepositDone = block.timestamp;

        _depositedPerDelay[_depositsAmount] = DepositData(tokensAmount, _usersAmount);

        _depositsAmount += 1;

    

        emit Deposited(tokensAmount);

    }



    function withdrawn() external onlyWhitelisted {

        address user = msg.sender;

        uint256 userLastWithdrawal = _userWithdraws[user];

        require(userLastWithdrawal < _depositsAmount, "withdrawn: this user already withdraw all available funds");



        uint256 tokensAmount;



        for (uint256 i = userLastWithdrawal; i < _depositsAmount; i++) {

            uint256 tokensPerDelay = _depositedPerDelay[i].tokens.div(_depositedPerDelay[i].usersLength);

            tokensAmount = tokensPerDelay;

        }



        _userWithdraws[user] = _depositsAmount;

        _yazom.safeTransfer(user, tokensAmount);



        emit Withdrawen(user, tokensAmount);

    }



    // -----------------------------------------

    // INTERNAL

    // -----------------------------------------



    function _addWhitelisted(address account) internal {

        _usersAmount++;

        super._addWhitelisted(account);

    }



    function _removeWhitelisted(address account) internal {

        _usersAmount--;

        super._removeWhitelisted(account);

    }



    // -----------------------------------------

    // GETTERS

    // -----------------------------------------



    function getCurrentUsersAmount() external view returns (uint256) {

        return _usersAmount;

    }



    function getLastDepositDoneDate() external view returns (uint256) {

        return _lastDepositDone;

    }



    function getDepositDelay() external pure returns (uint256) {

        return _depositDelay;

    }



    function getDepositorAddress() external view returns (address) {

        return _depositor;

    }



    function getDepositsAmount() external view returns (uint256) {

        return _depositsAmount;

    }



    function getDepositData(uint256 depositId) external view returns (uint256 tokens, uint256 usersLength) {

        return (

            _depositedPerDelay[depositId].tokens,

            _depositedPerDelay[depositId].usersLength

        );

    }



    function getUserLastWithdraw(address user) external view returns (uint256) {

        return _userWithdraws[user];

    }

}

// File: @openzeppelin/contracts-ethereum-package/contracts/Initializable.sol



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



// File: @openzeppelin/contracts-ethereum-package/contracts/access/Ownable.sol



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



// File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/IERC20.sol



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



// File: @openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol



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



// File: contracts/YieldFarming.sol



// contracts/TokenExchange.sol

pragma solidity ^0.6.0;

pragma experimental ABIEncoderV2;



//Import access control





// Import base Initializable contract





// Import the IERC20 interface and and SafeMath library









contract YieldFarming is OwnableUpgradeSafe {

    using SafeMath for uint256;

    



    // List of usable variables & structs

    IERC20 public sqrl;

    address public sqrlAddress;



    

    struct Plan {

        address sourceToken;

        uint256 tokenMultiplier; // actual multipler = tokenMultiplier / tokenMultiplierDivisor

        uint256 tokenMultiplierDivisor; // actual multipler = tokenMultiplier / tokenMultiplierDivisor

        uint256 multiplierCyclePeriod; // in seconds

        uint256 multiplierMaxCycle; // maximum number of times

        uint256 minimumTokensRequired;

        address planAuthor;

        bool planEnabled;

    }



    Plan[] public plans;



    struct UserInfo {

        uint256 _amount;

        address _tokenType;

        uint256 _timestamp;

    }



    uint256 lastRewardBalance;



    mapping (address => mapping(uint256 => UserInfo)) public userInfo;

    



    //Emitters to log the events & actions

    event ChangeByAddPlan(address planAuthor, uint256 planId);



    event ChangeByUpdatePlan(address planAuthor, uint256 planId);



    event StakeEvent(address indexed user, uint256 planId, uint256 amount);

    

    event UnstakeEvent(address indexed user, uint256 planId, uint256 amount);



    event UnstakeRewardEvent(address indexed user, uint256 planId, uint256 rewardAmount);



    event EmergencyWithdrawal(address user, uint256 amount);



    event OverallRewardBalanceEvent(uint256 rewardBalance);



    event RewardBalanceNow(uint256 rewardBalance);

    



    // Initializer function (replaces constructor)

    function initialize(address _sqrlAddress, uint256 _lastRewardBalance) public initializer {

        OwnableUpgradeSafe.__Ownable_init();

        sqrl = IERC20(_sqrlAddress);

        sqrlAddress = _sqrlAddress;

        lastRewardBalance = _lastRewardBalance;

    }



    //

    // 1. Plan creation: this section covers the creation of yield farming plans

    // only the owner is allow to create and modify plans

    //



    //Add yield farming plans

    function addPlan(address _sourceToken, uint256 _tokenMultiplier, uint256 _tokenMultiplierDivisor, uint256 _multiplierCyclePeriod, uint256 _multiplierMaxCycle, uint256 _minimumTokensRequired, bool _planEnabled) public onlyOwner returns(Plan[] memory) {

        Plan storage _newPlan = plans.push();

        _newPlan.sourceToken = _sourceToken;

        _newPlan.tokenMultiplier = _tokenMultiplier;

        _newPlan.tokenMultiplierDivisor = _tokenMultiplierDivisor;

        _newPlan.multiplierCyclePeriod = _multiplierCyclePeriod;

        _newPlan.multiplierMaxCycle = _multiplierMaxCycle;

        _newPlan.minimumTokensRequired = _minimumTokensRequired;

        _newPlan.planAuthor = msg.sender;

        _newPlan.planEnabled = _planEnabled;



        emit ChangeByAddPlan(msg.sender, plans.length - 1);

        return plans;

    }



    //Yield farm add plan storage

    function storageDisablePlan(uint256 _planId, Plan[] storage plansArray, bool _planEnableDisable) internal {

        plansArray[_planId].planEnabled = _planEnableDisable;

    }



    //Disable yield farming plans

    function switchPlan(uint256 _planId) public onlyOwner returns(Plan[] memory) {

        

        bool _planEnableDisable;



        if (plans[_planId].planEnabled == true){

            _planEnableDisable = false;

        }else{

            _planEnableDisable = true;

        }



        storageDisablePlan(_planId, plans, _planEnableDisable);



        emit ChangeByUpdatePlan(msg.sender, _planId);



        return plans;

    }



    //List yield farming plans

    function getPlans() public view returns(Plan[] memory) {

        return plans;

    }



    //

    // 2. Staking mechanism: this section covers the staking mechanism that is open to the public.

    // Contains stake() and unstake()

    //

    function stake(uint256 _planId, uint256 _stakeAmount) public {



        address _tokenType = plans[_planId].sourceToken;



        require(IERC20(_tokenType).balanceOf(msg.sender) > 0, "Insufficient token balance.");

        require(_stakeAmount <= IERC20(_tokenType).balanceOf(msg.sender), "You cannot stake more than what you own.");

        require(plans[_planId].planEnabled, "This reward plan is disabled.");

        require(userInfo[msg.sender][_planId]._amount == 0, "You have already staked in this reward plan.");

        require(plans[_planId].minimumTokensRequired <= IERC20(_tokenType).balanceOf(msg.sender), "You do not have sufficient balance to stake.");

        require(plans[_planId].minimumTokensRequired <= _stakeAmount, "You are not allowed to stake below the minimum token amount required to participate in this reward plan.");



        IERC20(_tokenType).transferFrom(msg.sender, address(this), _stakeAmount);

        UserInfo storage user = userInfo[msg.sender][_planId];

        user._amount = _stakeAmount;

        user._tokenType = _tokenType;

        user._timestamp = now;

        



        emit StakeEvent(msg.sender, _planId, _stakeAmount);

    }



    function unstake(uint256 _planId) public {



        require(userInfo[msg.sender][_planId]._amount > 0, "You have not yet staked for this plan.");



        uint256 _rewardAmount = calculateReward(_planId, userInfo[msg.sender][_planId]._amount, userInfo[msg.sender][_planId]._timestamp);

        uint _stakedAmount = userInfo[msg.sender][_planId]._amount;



        //Scenario 1: transfer reward & stake in one transaction if both are the same token

        if(plans[_planId].sourceToken == sqrlAddress){

            //Transfer SQRL reward

            sqrl.transfer(msg.sender, _rewardAmount.add(_stakedAmount));

            //Update overall reward balance

            lastRewardBalance = lastRewardBalance.sub(_rewardAmount);

        }

        //Scenario 2: transfer reward & stake in 2 transactions if both are different tokens

        else{

            //Transfer SQRL reward

            sqrl.transfer(msg.sender, _rewardAmount);

            //Update overall reward balance

            lastRewardBalance = lastRewardBalance.sub(_rewardAmount);



            //Transfer original stake

            IERC20(plans[_planId].sourceToken).transfer(msg.sender, _stakedAmount); 

        }



        //Reset user's stake

        userInfo[msg.sender][_planId]._amount = 0;

        userInfo[msg.sender][_planId]._tokenType = 0x0000000000000000000000000000000000000000;        

        userInfo[msg.sender][_planId]._timestamp = 0;



        emit UnstakeEvent(msg.sender, _planId, _stakedAmount);

        emit UnstakeRewardEvent(msg.sender, _planId, _rewardAmount);



        emit OverallRewardBalanceEvent(lastRewardBalance);

    }



    function safeUnstakingTransfer(uint256 _intendedRewardAmount) internal view returns (uint256) {



        uint256 _sqrlBalance = lastRewardBalance;



        if(_intendedRewardAmount > _sqrlBalance){

            return _sqrlBalance;

        }else{

            return _intendedRewardAmount;

        }



    }



    function calculateReward(uint256 _planId, uint256 _stakeAmount, uint256 _stakedTime) internal view returns (uint256 ){



        // IF( (time.now - stakedTime) / theMultiplierCyclePeriod < theMultiplierMaxCycle, (time.now - stakedTime) / theMultiplierCyclePeriod, theMultiplierMaxCycle) * theTokenMultiplier / 100 * stakeAmount

        uint256 _TimeDifference = now.sub(_stakedTime);

        uint256 _FinalCycle;

        

        if(_TimeDifference.div(plans[_planId].multiplierCyclePeriod) < plans[_planId].multiplierMaxCycle){

            _FinalCycle = _TimeDifference.div(plans[_planId].multiplierCyclePeriod);

        }else{

            _FinalCycle = plans[_planId].multiplierMaxCycle;

        }



        // Compounding interest

        uint256 _intendedRewardAmount = _stakeAmount;



        for(uint i=0; i<_FinalCycle; i++){

            _intendedRewardAmount = _intendedRewardAmount.mul(plans[_planId].tokenMultiplier).div(plans[_planId].tokenMultiplierDivisor);

        }

        //Return only reward component without the stake

        _intendedRewardAmount = _intendedRewardAmount.sub(_stakeAmount);



        return safeUnstakingTransfer(_intendedRewardAmount);

    }



    function getUserReward(uint256 _planId) public view returns (uint256) {

        uint256 _rewardAmount = calculateReward(_planId, userInfo[msg.sender][_planId]._amount, userInfo[msg.sender][_planId]._timestamp);



        return _rewardAmount;

    }



    function getUserStake(uint256 _planId) public view returns (uint256) {



        return userInfo[msg.sender][_planId]._amount;

    }



    function getLastRewardBalance() public view returns (uint256) {



        return lastRewardBalance;

    }



    //

    // 3. Emergency withdrawal of SQRL should there be any issues with the contract code

    //

    //

    function emergencyWithdrawal() public onlyOwner {

        

        uint256 sqrlBalance = lastRewardBalance;



        sqrl.transfer(msg.sender, sqrlBalance);



        lastRewardBalance = 0;



        emit EmergencyWithdrawal(msg.sender, sqrlBalance);

        emit RewardBalanceNow(lastRewardBalance);

    }



    //

    // 4. Add to the reward balance

    //

    //

    function addToRewardBalance(uint256 _additionalRewardAmount) public onlyOwner {



        lastRewardBalance = lastRewardBalance + _additionalRewardAmount;



        emit RewardBalanceNow(lastRewardBalance);

    }

}

pragma solidity =0.6.6;


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

interface IStaking {
    function stake(uint256 _amount) external returns (uint256 creditsIssued);

    function redeem(uint256 _amount) external returns (uint256 rocketReturned);

    function tokensToCredits(uint256 _amount)
        external
        view
        returns (uint256 credits);

    function creditsToTokens(uint256 _credits)
        external
        view
        returns (uint256 rocketAmount);

    function getStakerBalance(address staker)
        external
        view
        returns (
            uint256 credits,
            uint256 toRedeem,
            uint256 toRedeemAfterFee
        );
}

interface IFeeCollector {
    function collectTransferFee(uint256 _amount)
        external
        returns (uint256 amountAfterFee);

    function collectTransferAndStakingFees(uint256 _amount)
        external
        returns (uint256 amountAfterFee);

    function calculateTransferAndStakingFee(uint256 _amount)
        external
        view
        returns (
            uint256 totalFeeAmount,
            uint256 transferFeeAmount,
            uint256 stakingFeeAmount,
            uint256 feeToBurn,
            uint256 feeToStakers,
            uint256 amountAfterFee
        );

    function calculateTransferFee(uint256 _amount)
        external
        view
        returns (
            uint256 feeToCharge,
            uint256 feeToBurn,
            uint256 feeToStakers,
            uint256 amountAfterFee
        );
}

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

interface IOracle {
    function getData() external returns (uint256, bool);

    function update() external;

    function consult() external view returns (uint256 exchangeRate);
}

interface IRocketV2 is IERC20 {
    function setMonetaryPolicy(IMonetaryPolicy _monetaryPolicy) external;

    function rebase(uint256 epoch, int256 supplyDelta)
        external
        returns (uint256 supplyAfterRebase);

    function setFeeCollector(IFeeCollector _feeCollector) external;

    function isFeeChargingEnabled() external view returns (bool stakingEnabled);

    function transferFromWithoutCollectingFee(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool success);

    function claim(uint256 rocketV1Amount) external;

    function calculateClaim(uint256 rocketV1AmountToSend)
        external
        view
        returns (uint256 rocketV2AmountToReceive);
}

interface IMonetaryPolicy {
    function rebase() external;

    function setMarketOracle(IOracle _marketOracle) external;

    function setRocket(IRocketV2 _rocket) external;

    function setDeviationThreshold(uint256 _deviationThreshold) external;

    function setRebaseLag(uint256 _rebaseLag) external;

    function setRebaseTimingParameters(
        uint256 _minRebaseTimeIntervalSec,
        uint256 _rebaseWindowOffsetSec,
        uint256 _rebaseWindowLengthSec
    ) external;

    function inRebaseWindow() external view returns (bool);
}

// SPDX-License-Identifier: MIT
contract Staking is OwnableUpgradeSafe, IStaking {
    using SafeMath for uint256;

    event TokensStaked(
        address indexed staker,
        uint256 tokensDeposited,
        uint256 creditsIssued
    );
    event TokensRedeemed(
        address indexed staker,
        uint256 creditsBurned,
        uint256 tokensRedeemed
    );
    event RocketUpdated(address rocket);
    event FeeCollectorUpdated(address feeColletor);

    IFeeCollector private feeCollector;

    IRocketV2 private rocket;

    // Total number of savings credits issued
    uint256 public totalCredits;

    // Amount of credits for each Staker
    mapping(address => uint256) public creditBalances;

    function setRocket(IRocketV2 _rocket) public onlyOwner {
        require(
            address(_rocket) != address(0),
            "Staking: rocket address can't be zero"
        );
        rocket = _rocket;
        emit RocketUpdated(address(_rocket));
    }

    function setFeeCollector(IFeeCollector _feeCollector) public onlyOwner {
        require(
            address(_feeCollector) != address(0),
            "Staking: rocket address can't be zero"
        );
        feeCollector = _feeCollector;
        emit FeeCollectorUpdated(address(_feeCollector));
    }

    function initialize(IRocketV2 _rocket) public initializer {
        require(
            address(_rocket) != address(0),
            "Staking: rocket address can't be zero"
        );
        OwnableUpgradeSafe.__Ownable_init();

        rocket = _rocket;
    }

    function stake(uint256 _amount)
        external
        override
        returns (uint256 creditsIssued)
    {
        require(_amount > 0, "Staking: Must deposit something");
        require(
            address(feeCollector) != address(0),
            "Staking: FeeCollector contract isn't set"
        );

        require(
            rocket.transferFromWithoutCollectingFee(
                _msgSender(),
                address(this),
                _amount
            ),
            "Staking: Must receive tokens"
        );

        uint256 amountAfterFee = feeCollector.collectTransferAndStakingFees(
            _amount
        );

        creditsIssued = tokensToCredits(amountAfterFee);

        totalCredits = totalCredits.add(creditsIssued);

        creditBalances[_msgSender()] = _creditsOf(_msgSender()).add(
            creditsIssued
        );

        emit TokensStaked(_msgSender(), _amount, creditsIssued);
    }

    function redeem(uint256 _credits)
        external
        override
        returns (uint256 rocketReturned)
    {
        require(_credits > 0, "Staking: Must withdraw something");
        require(
            address(feeCollector) != address(0),
            "Staking: FeeCollector contract isn't set"
        );
        uint256 stakerCredits = _creditsOf(_msgSender());
        require(
            stakerCredits >= _credits,
            "Staking: Staker has no enough credits"
        );

        rocketReturned = creditsToTokens(_credits);
        creditBalances[_msgSender()] = stakerCredits.sub(_credits);
        totalCredits = totalCredits.sub(_credits);

        uint256 toRedeem = feeCollector.collectTransferAndStakingFees(
            rocketReturned
        );

        require(
            rocket.transferFromWithoutCollectingFee(
                address(this),
                _msgSender(),
                toRedeem
            ),
            "Staking: Must send tokens"
        );

        emit TokensRedeemed(_msgSender(), _credits, toRedeem);
    }

    function getStakerBalance(address staker)
        external
        override
        view
        returns (
            uint256 credits,
            uint256 toRedeem,
            uint256 toRedeemAfterFee
        )
    {
        credits = _creditsOf(staker);
        toRedeem = creditsToTokens(credits);
        (, , , , , toRedeemAfterFee) = feeCollector
            .calculateTransferAndStakingFee(toRedeem);
    }

    function creditsToTokens(uint256 _credits)
        public
        override
        view
        returns (uint256 rocketAmount)
    {
        if (totalCredits == 0) {
            return 0;
        }

        rocketAmount = _getTotalStaked().mul(_credits).div(totalCredits);
    }

    function tokensToCredits(uint256 _amount)
        public
        override
        view
        returns (uint256 credits)
    {
        credits = _amount;
    }

    function _getTotalStaked() private view returns (uint256 totalSavings) {
        totalSavings = rocket.balanceOf(address(this));
    }

    function _creditsOf(address account)
        private
        view
        returns (uint256 credits)
    {
        credits = creditBalances[account];
    }
}

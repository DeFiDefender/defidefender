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

library StableMath {
    using SafeMath for uint256;

    /**
     * @dev Scaling unit for use in specific calculations,
     * where 1 * 10**18, or 1e18 represents a unit '1'
     */
    uint256 private constant FULL_SCALE = 1e18;

    /**
     * @notice Token Ratios are used when converting between units of bAsset, mAsset and MTA
     * Reasoning: Takes into account token decimals, and difference in base unit (i.e. grams to Troy oz for gold)
     * @dev bAsset ratio unit for use in exact calculations,
     * where (1 bAsset unit * bAsset.ratio) / ratioScale == x mAsset unit
     */
    uint256 private constant RATIO_SCALE = 1e8;

    /**
     * @dev Provides an interface to the scaling unit
     * @return Scaling unit (1e18 or 1 * 10**18)
     */
    function getFullScale() internal pure returns (uint256) {
        return FULL_SCALE;
    }

    /**
     * @dev Provides an interface to the ratio unit
     * @return Ratio scale unit (1e8 or 1 * 10**8)
     */
    function getRatioScale() internal pure returns (uint256) {
        return RATIO_SCALE;
    }

    /**
     * @dev Scales a given integer to the power of the full scale.
     * @param x   Simple uint256 to scale
     * @return    Scaled value a to an exact number
     */
    function scaleInteger(uint256 x) internal pure returns (uint256) {
        return x.mul(FULL_SCALE);
    }

    /***************************************
              PRECISE ARITHMETIC
    ****************************************/

    /**
     * @dev Multiplies two precise units, and then truncates by the full scale
     * @param x     Left hand input to multiplication
     * @param y     Right hand input to multiplication
     * @return      Result after multiplying the two inputs and then dividing by the shared
     *              scale unit
     */
    function mulTruncate(uint256 x, uint256 y) internal pure returns (uint256) {
        return mulTruncateScale(x, y, FULL_SCALE);
    }

    /**
     * @dev Multiplies two precise units, and then truncates by the given scale. For example,
     * when calculating 90% of 10e18, (10e18 * 9e17) / 1e18 = (9e36) / 1e18 = 9e18
     * @param x     Left hand input to multiplication
     * @param y     Right hand input to multiplication
     * @param scale Scale unit
     * @return      Result after multiplying the two inputs and then dividing by the shared
     *              scale unit
     */
    function mulTruncateScale(
        uint256 x,
        uint256 y,
        uint256 scale
    ) internal pure returns (uint256) {
        // e.g. assume scale = fullScale
        // z = 10e18 * 9e17 = 9e36
        uint256 z = x.mul(y);
        // return 9e38 / 1e18 = 9e18
        return z.div(scale);
    }

    /**
     * @dev Multiplies two precise units, and then truncates by the full scale, rounding up the result
     * @param x     Left hand input to multiplication
     * @param y     Right hand input to multiplication
     * @return      Result after multiplying the two inputs and then dividing by the shared
     *              scale unit, rounded up to the closest base unit.
     */
    function mulTruncateCeil(uint256 x, uint256 y)
        internal
        pure
        returns (uint256)
    {
        // e.g. 8e17 * 17268172638 = 138145381104e17
        uint256 scaled = x.mul(y);
        // e.g. 138145381104e17 + 9.99...e17 = 138145381113.99...e17
        uint256 ceil = scaled.add(FULL_SCALE.sub(1));
        // e.g. 13814538111.399...e18 / 1e18 = 13814538111
        return ceil.div(FULL_SCALE);
    }

    /**
     * @dev Precisely divides two units, by first scaling the left hand operand. Useful
     *      for finding percentage weightings, i.e. 8e18/10e18 = 80% (or 8e17)
     * @param x     Left hand input to division
     * @param y     Right hand input to division
     * @return      Result after multiplying the left operand by the scale, and
     *              executing the division on the right hand input.
     */
    function divPrecisely(uint256 x, uint256 y)
        internal
        pure
        returns (uint256)
    {
        // e.g. 8e18 * 1e18 = 8e36
        uint256 z = x.mul(FULL_SCALE);
        // e.g. 8e36 / 10e18 = 8e17
        return z.div(y);
    }

    /***************************************
                  RATIO FUNCS
    ****************************************/

    /**
     * @dev Multiplies and truncates a token ratio, essentially flooring the result
     *      i.e. How much mAsset is this bAsset worth?
     * @param x     Left hand operand to multiplication (i.e Exact quantity)
     * @param ratio bAsset ratio
     * @return c    Result after multiplying the two inputs and then dividing by the ratio scale
     */
    function mulRatioTruncate(uint256 x, uint256 ratio)
        internal
        pure
        returns (uint256 c)
    {
        return mulTruncateScale(x, ratio, RATIO_SCALE);
    }

    /**
     * @dev Multiplies and truncates a token ratio, rounding up the result
     *      i.e. How much mAsset is this bAsset worth?
     * @param x     Left hand input to multiplication (i.e Exact quantity)
     * @param ratio bAsset ratio
     * @return      Result after multiplying the two inputs and then dividing by the shared
     *              ratio scale, rounded up to the closest base unit.
     */
    function mulRatioTruncateCeil(uint256 x, uint256 ratio)
        internal
        pure
        returns (uint256)
    {
        // e.g. How much mAsset should I burn for this bAsset (x)?
        // 1e18 * 1e8 = 1e26
        uint256 scaled = x.mul(ratio);
        // 1e26 + 9.99e7 = 100..00.999e8
        uint256 ceil = scaled.add(RATIO_SCALE.sub(1));
        // return 100..00.999e8 / 1e8 = 1e18
        return ceil.div(RATIO_SCALE);
    }

    /**
     * @dev Precisely divides two ratioed units, by first scaling the left hand operand
     *      i.e. How much bAsset is this mAsset worth?
     * @param x     Left hand operand in division
     * @param ratio bAsset ratio
     * @return c    Result after multiplying the left operand by the scale, and
     *              executing the division on the right hand input.
     */
    function divRatioPrecisely(uint256 x, uint256 ratio)
        internal
        pure
        returns (uint256 c)
    {
        // e.g. 1e14 * 1e8 = 1e22
        uint256 y = x.mul(RATIO_SCALE);
        // return 1e22 / 1e12 = 1e10
        return y.div(ratio);
    }

    /***************************************
                    HELPERS
    ****************************************/

    /**
     * @dev Calculates minimum of two numbers
     * @param x     Left hand input
     * @param y     Right hand input
     * @return      Minimum of the two inputs
     */
    function min(uint256 x, uint256 y) internal pure returns (uint256) {
        return x > y ? y : x;
    }

    /**
     * @dev Calculated maximum of two numbers
     * @param x     Left hand input
     * @param y     Right hand input
     * @return      Maximum of the two inputs
     */
    function max(uint256 x, uint256 y) internal pure returns (uint256) {
        return x > y ? x : y;
    }

    /**
     * @dev Clamps a value to an upper bound
     * @param x           Left hand input
     * @param upperBound  Maximum possible value to return
     * @return            Input x clamped to a maximum value, upperBound
     */
    function clamp(uint256 x, uint256 upperBound)
        internal
        pure
        returns (uint256)
    {
        return x > upperBound ? upperBound : x;
    }
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

// SPDX-License-Identifier: MIT
contract FeeCollector is OwnableUpgradeSafe, IFeeCollector {
    using SafeMath for uint256;
    using StableMath for uint256;

    uint256 public stakingFeeToCharge;
    uint256 public transferFeeToCharge;
    uint256 public burnFeeToCharge;

    IRocketV2 private rocket;
    IStaking private staking;

    address
        private constant BURN_ADDRESS = 0xdeaDDeADDEaDdeaDdEAddEADDEAdDeadDEADDEaD;

    event RocketUpdated(address rocket);
    event StakingUpdated(address staking);
    event FeesUpdated(
        uint256 stakingFeeToCharge,
        uint256 transferFeeToCharge,
        uint256 burnFeeToCharge
    );
    event TokensStaked(uint256 amount);
    event TokensBurned(uint256 amount);

    modifier depositToStakers() {
        _;
        uint256 amount = rocket.balanceOf(address(this));
        if (amount > 0) {
            rocket.approve(address(staking), amount);
            require(
                rocket.transferFromWithoutCollectingFee(
                    address(this),
                    address(staking),
                    amount
                ),
                "FeeCollector: Must deposit tokens to stakers"
            );
            rocket.approve(address(staking), 0);
            emit TokensStaked(amount);
        }
    }

    function initialize(IRocketV2 _rocket, IStaking _staking)
        public
        initializer
    {
        require(
            address(_rocket) != address(0),
            "Staking: rocket address can't be zero"
        );
        OwnableUpgradeSafe.__Ownable_init();

        rocket = _rocket;
        staking = _staking;

        stakingFeeToCharge = 2E16; // 2%
        transferFeeToCharge = 3E16; // 3%
        burnFeeToCharge = 33E16; // 33%
    }

    function setFees(
        uint256 _stakingFee,
        uint256 _transferFee,
        uint256 _burnFee
    ) public onlyOwner {
        stakingFeeToCharge = _stakingFee;
        transferFeeToCharge = _transferFee;
        burnFeeToCharge = _burnFee;

        emit FeesUpdated(
            stakingFeeToCharge,
            transferFeeToCharge,
            burnFeeToCharge
        );
    }

    function setRocket(IRocketV2 _rocket) public onlyOwner {
        require(
            address(_rocket) != address(0),
            "Staking: rocket address can't be zero"
        );
        rocket = _rocket;
        emit RocketUpdated(address(_rocket));
    }

    function setStaking(IStaking _staking) public onlyOwner {
        require(
            address(_staking) != address(0),
            "Staking: rocket address can't be zero"
        );
        staking = _staking;
        emit StakingUpdated(address(_staking));
    }

    function collectTransferFee(uint256 _amount)
        public
        override
        depositToStakers
        returns (uint256 amountAfterFee)
    {
        if (!rocket.isFeeChargingEnabled()) {
            return _amount;
        }

        (
            uint256 feeToCharge,
            uint256 feeToBurn,
            uint256 feeToStakers,

        ) = calculateTransferFee(_amount);

        require(
            rocket.transferFromWithoutCollectingFee(
                _msgSender(),
                address(this),
                feeToStakers
            ),
            "FeeCollector: Must receive tokens"
        );

        require(
            rocket.transferFromWithoutCollectingFee(
                _msgSender(),
                BURN_ADDRESS,
                feeToBurn
            ),
            "FeeCollector: Burn transfer failed"
        );
        emit TokensBurned(feeToBurn);

        amountAfterFee = _amount.sub(feeToCharge);
    }

    function collectTransferAndStakingFees(uint256 _amount)
        external
        override
        depositToStakers
        returns (uint256)
    {
        if (!rocket.isFeeChargingEnabled()) {
            return _amount;
        }

        collectTransferFee(_amount);

        (
            ,
            ,
            uint256 stakingFeeToCharge,
            ,
            ,
            uint256 amountAfterFee
        ) = calculateTransferAndStakingFee(_amount);
        require(
            rocket.transferFromWithoutCollectingFee(
                _msgSender(),
                address(this),
                stakingFeeToCharge
            ),
            "FeeCollector: Must receive tokens"
        );

        return amountAfterFee;
    }

    function calculateTransferFee(uint256 _amount)
        public
        override
        view
        returns (
            uint256 feeToCharge,
            uint256 feeToBurn,
            uint256 feeToStakers,
            uint256 amountAfterFee
        )
    {
        if (!rocket.isFeeChargingEnabled()) {
            feeToCharge = 0;
            feeToBurn = 0;
            feeToStakers = 0;
            amountAfterFee = _amount;
        } else {
            feeToCharge = _amount.mulTruncate(transferFeeToCharge);
            feeToBurn = feeToCharge.mulTruncate(burnFeeToCharge);
            feeToStakers = feeToCharge.sub(feeToBurn);
            amountAfterFee = _amount.sub(feeToCharge);
        }
    }

    function calculateTransferAndStakingFee(uint256 _amount)
        public
        override
        view
        returns (
            uint256 totalFeeAmount,
            uint256 transferFeeAmount,
            uint256 stakingFeeAmount,
            uint256 feeToBurn,
            uint256 feeToStakers,
            uint256 amountAfterFee
        )
    {
        if (!rocket.isFeeChargingEnabled()) {
            totalFeeAmount = 0;
            transferFeeAmount = 0;
            stakingFeeAmount = 0;
            feeToBurn = 0;
            feeToStakers = 0;
            amountAfterFee = _amount;
        } else {
            (transferFeeAmount, feeToBurn, , ) = calculateTransferFee(_amount);
            stakingFeeAmount = _amount.mulTruncate(stakingFeeToCharge);
            totalFeeAmount = transferFeeAmount.add(stakingFeeAmount);
            feeToStakers = totalFeeAmount.sub(feeToBurn);
            amountAfterFee = _amount.sub(totalFeeAmount);
        }
    }
}

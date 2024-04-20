pragma solidity 0.5.17;
pragma experimental ABIEncoderV2;


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

library NumbersList {
    using SafeMath for uint256;

    // Given a whole number percentage, multiply by it and then divide by this.
    uint256 private constant PERCENTAGE_TO_DECIMAL = 10000;

    // Holds values to can calculate the threshold of a list of numbers
    struct Values {
        uint256 count; // The total number of numbers added
        uint256 max; // The maximum number that was added
        uint256 min; // The minimum number that was added
        uint256 sum; // The total sum of the numbers that were added
    }

    /**
     * @dev Add to the sum while keeping track of min and max values
     * @param self The Value this function was called on
     * @param newValue Number to increment sum by
     */
    function addValue(Values storage self, uint256 newValue) internal {
        if (self.max < newValue) {
            self.max = newValue;
        }
        if (self.min > newValue || self.count == 0) {
            self.min = newValue;
        }
        self.sum = self.sum.add(newValue);
        self.count = self.count.add(1);
    }

    /**
     * @param self The Value this function was called on
     * @return the number of times the sum has updated
     */
    function valuesCount(Values storage self) internal view returns (uint256) {
        return self.count;
    }

    /**
     * @dev Checks if the sum has been changed
     * @param self The Value this function was called on
     * @return boolean
     */
    function isEmpty(Values storage self) internal view returns (bool) {
        return valuesCount(self) == 0;
    }

    /**
     * @dev Checks if the sum has been changed `totalRequiredValues` times
     * @param self The Value this function was called on
     * @param totalRequiredValues The maximum amount of numbers to be added to the sum
     * @return boolean
     */
    function isFinalized(Values storage self, uint256 totalRequiredValues)
        internal
        view
        returns (bool)
    {
        return valuesCount(self) >= totalRequiredValues;
    }

    /**
     * @param self The Value this function was called on
     * @return the average number that was used to calculate the sum
     */
    function getAverage(Values storage self) internal view returns (uint256) {
        return isEmpty(self) ? 0 : self.sum.div(valuesCount(self));
    }

    /**
     * @dev Checks if the min and max numbers are with in the acceptable tolerance
     * @param self The Value this function was called on
     * @param tolerancePercentage Acceptable tolerance percentage as a whole number
     * @return boolean
     */
    function isWithinTolerance(Values storage self, uint256 tolerancePercentage)
        internal
        view
        returns (bool)
    {
        if (isEmpty(self)) {
            return false;
        }
        uint256 average = getAverage(self);
        uint256 toleranceAmount = average.mul(tolerancePercentage).div(
            PERCENTAGE_TO_DECIMAL
        );

        uint256 minTolerance = average.sub(toleranceAmount);
        if (self.min < minTolerance) {
            return false;
        }

        uint256 maxTolerance = average.add(toleranceAmount);
        if (self.max > maxTolerance) {
            return false;
        }
        return true;
    }
}

library TellerCommon {
    enum LoanStatus {NonExistent, TermsSet, Active, Closed}

    // The amount of interest owed to a borrower
    // The interest is just that accrued until `timeLastAccrued`
    struct AccruedInterest {
        uint256 totalAccruedInterest;
        uint256 totalNotWithdrawn;
        uint256 timeLastAccrued;
    }

    // Represents a user signature
    struct Signature {
        uint256 signerNonce;
        uint8 v;
        bytes32 r;
        bytes32 s;
    }

    // Consensus request object for accruing interest
    struct InterestRequest {
        address lender;
        address consensusAddress;
        uint256 requestNonce;
        uint256 startTime;
        uint256 endTime;
        uint256 requestTime;
    }

    // Consensus response object for accruing interest
    struct InterestResponse {
        address signer;
        address consensusAddress;
        uint256 responseTime;
        uint256 interest;
        Signature signature;
    }

    // Borrower request object to take out a loan
    struct LoanRequest {
        address payable borrower;
        address recipient;
        address consensusAddress;
        uint256 requestNonce;
        uint256 amount;
        uint256 duration;
        uint256 requestTime;
    }

    // Borrower response object to take out a loan
    struct LoanResponse {
        address signer;
        address consensusAddress;
        uint256 responseTime;
        uint256 interestRate;
        uint256 collateralRatio;
        uint256 maxLoanAmount;
        Signature signature;
    }

    // Represents loan terms based on consensus values
    struct AccruedLoanTerms {
        NumbersList.Values interestRate;
        NumbersList.Values collateralRatio;
        NumbersList.Values maxLoanAmount;
    }

    // Represents the terms of a loan based on the consensus of a LoanRequest
    struct LoanTerms {
        address payable borrower;
        address recipient;
        uint256 interestRate;
        uint256 collateralRatio;
        uint256 maxLoanAmount;
        uint256 duration;
    }

    // Data per borrow as struct
    struct Loan {
        uint256 id;
        LoanTerms loanTerms;
        uint256 termsExpiry;
        uint256 loanStartTime;
        uint256 collateral;
        uint256 lastCollateralIn;
        uint256 principalOwed;
        uint256 interestOwed;
        uint256 borrowedAmount;
        LoanStatus status;
        bool liquidated;
    }
}

contract SettingsConsts {
    /** Constants */

    /**
        @notice The setting name for the required subsmission settings.
     */
    bytes32 public constant REQUIRED_SUBMISSIONS_SETTING = "RequiredSubmissions";
    /**
        @notice The setting name for the maximum tolerance settings.
        @notice This is the maximum tolerance for the values submitted (by nodes) when they are aggregated (average). It is used in the consensus mechanisms.
        @notice This is a percentage value with 2 decimal places.
            i.e. maximumTolerance of 325 => tolerance of 3.25% => 0.0325 of value
            i.e. maximumTolerance of 0 => It means all the values submitted must be equals.        
        @dev The max value is 100% => 10000
     */
    bytes32 public constant MAXIMUM_TOLERANCE_SETTING = "MaximumTolerance";
    /**
        @notice The setting name for the response expiry length settings.
        @notice This is the maximum time (in seconds) a node has to submit a response. After that time, the response is considered expired.
     */
    bytes32 public constant RESPONSE_EXPIRY_LENGTH_SETTING = "ResponseExpiryLength";
    /**
        @notice The setting name for the safety interval settings.
        @notice This is the minimum time you need to wait (in seconds) between the last time you deposit collateral and you take out the loan.
        @notice It is used to avoid potential attacks using Flash Loans (AAVE) or Flash Swaps (Uniswap V2).
     */
    bytes32 public constant SAFETY_INTERVAL_SETTING = "SafetyInterval";
    /**
        @notice The setting name for the term expiry time settings.
        @notice This represents the time (in seconds) that loan terms will be available after requesting them.
        @notice After this time, the loan terms will expire and the borrower will need to request it again.
     */
    bytes32 public constant TERMS_EXPIRY_TIME_SETTING = "TermsExpiryTime";
    /**
        @notice The setting name for the liquidate ETH price settings.
        @notice It represents the percentage value (with 2 decimal places) to liquidate loans.
            i.e. an ETH liquidation price at 95% is stored as 9500
     */
    bytes32 public constant LIQUIDATE_ETH_PRICE_SETTING = "LiquidateEthPrice";
    /**
        @notice The setting name for the maximum loan duration settings.
        @notice The maximum loan duration setting is defined in seconds.
     */
    bytes32 public constant MAXIMUM_LOAN_DURATION_SETTING = "MaximumLoanDuration";
    /**
        @notice The setting name for the request loan terms rate limit settings.
        @notice The request loan terms rate limit setting is defined in seconds.
     */
    bytes32 public constant REQUEST_LOAN_TERMS_RATE_LIMIT_SETTING = "RequestLoanTermsRateLimit";
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

contract ERC20 is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() public view returns (string memory);

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view returns (string memory);

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view returns (uint8);
}

library ERC20Lib {
    using SafeMath for uint256;

    // Used to calculate one whole token.
    uint256 internal constant TEN = 10;

    /**
        @notice Gets a whole token based on the token decimals.
        @param self the current ERC20 instance.
        @return a whole token value based on the decimals.
     */
    function getAWholeToken(ERC20 self) internal view returns (uint256) {
        uint8 decimals = self.decimals();
        return TEN**decimals;
    }

    /**
        @notice It transfers an amount of tokens to a specific address.
        @param self The current token instance.
        @param recipient The address which will receive the tokens.
        @param amount The amount of tokens to transfer.
        @dev It throws a require error if 'transfer' invocation fails.
     */
    function tokenTransfer(ERC20 self, address recipient, uint256 amount) internal {
        uint256 initialBalance = self.balanceOf(address(this));
        require(initialBalance >= amount, "NOT_ENOUGH_TOKENS_BALANCE");

        bool transferResult = self.transfer(recipient, amount);
        require(transferResult, "TOKENS_TRANSFER_FAILED");

        uint256 finalBalance = self.balanceOf(address(this));

        require(initialBalance.sub(finalBalance) == amount, "INV_BALANCE_AFTER_TRANSFER");
    }

    /**
        @notice It transfers an amount of tokens from an address to this contract.
        @param self The current token instance.
        @param from The address where the tokens will transfer from.
        @param amount The amount to be transferred.
        @dev It throws a require error if the allowance is not enough.
        @dev It throws a require error if 'transferFrom' invocation fails.
     */
    function tokenTransferFrom(ERC20 self, address from, uint256 amount) internal {
        uint256 currentAllowance = self.allowance(from, address(this));
        require(currentAllowance >= amount, "NOT_ENOUGH_TOKENS_ALLOWANCE");

        uint256 initialBalance = self.balanceOf(address(this));
        bool transferFromResult = self.transferFrom(from, address(this), amount);
        require(transferFromResult, "TOKENS_TRANSFER_FROM_FAILED");

        uint256 finalBalance = self.balanceOf(address(this));
        require(
            finalBalance.sub(initialBalance) == amount,
            "INV_BALANCE_AFTER_TRANSFER_FROM"
        );
    }
}

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

contract ReentrancyGuard is Initializable {
    // counter to allow mutex lock with only one SSTORE operation
    uint256 private _guardCounter;

    function initialize() public initializer {
        // The counter starts at one to prevent changing it from zero to a non-zero
        // value, which is a more expensive operation.
        _guardCounter = 1;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _guardCounter += 1;
        uint256 localCounter = _guardCounter;
        _;
        require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
    }

    uint256[50] private ______gap;
}

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

library AddressLib {
    address public constant ADDRESS_EMPTY = address(0x0);

    /**
     * @dev Checks if this address is all 0s
     * @param self The address this function was called on
     * @return boolean
     */
    function isEmpty(address self) internal pure returns (bool) {
        return self == ADDRESS_EMPTY;
    }

    /**
     * @dev Checks if this address is the same as another address
     * @param self The address this function was called on
     * @param other Address to check against itself
     * @return boolean
     */
    function isEqualTo(address self, address other) internal pure returns (bool) {
        return self == other;
    }

    /**
     * @dev Checks if this address is different to another address
     * @param self The address this function was called on
     * @param other Address to check against itself
     * @return boolean
     */
    function isNotEqualTo(address self, address other) internal pure returns (bool) {
        return self != other;
    }

    /**
     * @dev Checks if this address is not all 0s
     * @param self The address this function was called on
     * @return boolean
     */
    function isNotEmpty(address self) internal pure returns (bool) {
        return self != ADDRESS_EMPTY;
    }

    /**
     * @dev Throws an error if address is all 0s
     * @param self The address this function was called on
     * @param message Error message if address is all 0s
     */
    function requireNotEmpty(address self, string memory message) internal pure {
        require(isNotEmpty(self), message);
    }

    /**
     * @dev Throws an error if address is not all 0s
     * @param self The address this function was called on
     * @param message Error message if address is not all 0s
     */
    function requireEmpty(address self, string memory message) internal pure {
        require(isEmpty(self), message);
    }

    /**
     * @dev Throws an error if address is not the same as another address
     * @param self The address this function was called on
     * @param other The address to check against itself
     * @param message Error message if addresses are not the same
     */
    function requireEqualTo(address self, address other, string memory message)
        internal
        pure
    {
        require(isEqualTo(self, other), message);
    }

    /**
     * @dev Throws an error if address is the same as another address
     * @param self The address this function was called on
     * @param other The address to check against itself
     * @param message Error message if addresses are the same
     */
    function requireNotEqualTo(address self, address other, string memory message)
        internal
        pure
    {
        require(isNotEqualTo(self, other), message);
    }
}

contract TInitializable {
    /* State Variables */

    bool private _isInitialized;

    /** Modifiers */

    /**
        @notice Checks whether the contract is initialized or not.
        @dev It throws a require error if the contract is initialized.
     */
    modifier isNotInitialized() {
        require(!_isInitialized, "CONTRACT_ALREADY_INITIALIZED");
        _;
    }

    /**
        @notice Checks whether the contract is initialized or not.
        @dev It throws a require error if the contract is not initialized.
     */
    modifier isInitialized() {
        require(_isInitialized, "CONTRACT_NOT_INITIALIZED");
        _;
    }

    /* Constructor */

    /** External Functions */

    /**
        @notice Gets if the contract is initialized.
        @return true if contract is initialized. Otherwise it returns false.
     */
    function initialized() external view returns (bool) {
        return _isInitialized;
    }

    /** Internal functions */

    /**
        @notice It initializes this contract.
     */
    function _initialize() internal {
        _isInitialized = true;
    }

    /** Private functions */
}

library AssetSettingsLib {
    using SafeMath for uint256;
    using AddressLib for address;
    using Address for address;

    /**
        @notice This struct manages the asset settings in the platform.
        @param cTokenAddress cToken address associated to the asset. 
        @param maxLoanAmount max loan amount configured for the asset.
     */
    struct AssetSettings {
        // It prepresents the cTokenAddress or 0x0.
        address cTokenAddress;
        // It represents the maximum loan amount to borrow.
        uint256 maxLoanAmount;
    }

    /**
        @notice It initializes the struct instance with the given parameters.
        @param cTokenAddress the initial cToken address.
        @param maxLoanAmount the initial max loan amount.
     */
    function initialize(
        AssetSettings storage self,
        address cTokenAddress,
        uint256 maxLoanAmount
    ) internal {
        require(maxLoanAmount > 0, "INIT_MAX_AMOUNT_REQUIRED");
        require(
            cTokenAddress.isEmpty() || cTokenAddress.isContract(),
            "CTOKEN_MUST_BE_CONTRACT_OR_EMPTY"
        );
        self.cTokenAddress = cTokenAddress;
        self.maxLoanAmount = maxLoanAmount;
    }

    /**
        @notice Checks whether the current asset settings exists or not.
        @dev It throws a require error if the asset settings already exists.
        @param self the current asset settings.
     */
    function requireNotExists(AssetSettings storage self) internal view {
        require(exists(self) == false, "ASSET_SETTINGS_ALREADY_EXISTS");
    }

    /**
        @notice Checks whether the current asset settings exists or not.
        @dev It throws a require error if the asset settings doesn't exist.
        @param self the current asset settings.
     */
    function requireExists(AssetSettings storage self) internal view {
        require(exists(self) == true, "ASSET_SETTINGS_NOT_EXISTS");
    }

    /**
        @notice Tests whether the current asset settings exists or not.
        @param self the current asset settings.
        @return true if the current settings exists (max loan amount higher than zero). Otherwise it returns false.
     */
    function exists(AssetSettings storage self) internal view returns (bool) {
        return self.maxLoanAmount > 0;
    }

    /**
        @notice Tests whether a given amount is greater than the current max loan amount.
        @param self the current asset settings.
        @param amount to test.
        @return true if the given amount is greater than the current max loan amount. Otherwise it returns false.
     */
    function exceedsMaxLoanAmount(AssetSettings storage self, uint256 amount)
        internal
        view
        returns (bool)
    {
        return amount > self.maxLoanAmount;
    }

    /**
        @notice It updates the cToken address.
        @param self the current asset settings.
        @param newCTokenAddress the new cToken address to set.
     */
    function updateCTokenAddress(AssetSettings storage self, address newCTokenAddress)
        internal
    {
        requireExists(self);
        require(self.cTokenAddress != newCTokenAddress, "NEW_CTOKEN_ADDRESS_REQUIRED");
        self.cTokenAddress = newCTokenAddress;
    }

    /**
        @notice It updates the max loan amount.
        @param self the current asset settings.
        @param newMaxLoanAmount the new max loan amount to set.
     */
    function updateMaxLoanAmount(AssetSettings storage self, uint256 newMaxLoanAmount)
        internal
    {
        requireExists(self);
        require(self.maxLoanAmount != newMaxLoanAmount, "NEW_MAX_LOAN_AMOUNT_REQUIRED");
        require(newMaxLoanAmount > 0, "MAX_LOAN_AMOUNT_NOT_ZERO");
        self.maxLoanAmount = newMaxLoanAmount;
    }
}

library PlatformSettingsLib {
    /**
        It defines a platform settings. It includes: value, min, and max values.
     */
    struct PlatformSetting {
        uint256 value;
        uint256 min;
        uint256 max;
        bool exists;
    }

    /**
        @notice It creates a new platform setting given a name, min and max values.
        @param value initial value for the setting.
        @param min min value allowed for the setting.
        @param max max value allowed for the setting.
     */
    function initialize(
        PlatformSetting storage self,
        uint256 value,
        uint256 min,
        uint256 max
    ) internal {
        requireNotExists(self);
        require(value >= min, "VALUE_MUST_BE_GT_MIN_VALUE");
        require(value <= max, "VALUE_MUST_BE_LT_MAX_VALUE");
        self.value = value;
        self.min = min;
        self.max = max;
        self.exists = true;
    }

    /**
        @notice Checks whether the current platform setting exists or not.
        @dev It throws a require error if the platform setting already exists.
        @param self the current platform setting.
     */
    function requireNotExists(PlatformSetting storage self) internal view {
        require(self.exists == false, "PLATFORM_SETTING_ALREADY_EXISTS");
    }

    /**
        @notice Checks whether the current platform setting exists or not.
        @dev It throws a require error if the current platform setting doesn't exist.
        @param self the current platform setting.
     */
    function requireExists(PlatformSetting storage self) internal view {
        require(self.exists == true, "PLATFORM_SETTING_NOT_EXISTS");
    }

    /**
        @notice It updates a current platform setting.
        @dev It throws a require error if:
            - The new value is equal to the current value.
            - The new value is not lower than the max value.
            - The new value is not greater than the min value
        @param self the current platform setting.
        @param newValue the new value to set in the platform setting.
     */
    function update(PlatformSetting storage self, uint256 newValue)
        internal
        returns (uint256 oldValue)
    {
        requireExists(self);
        require(self.value != newValue, "NEW_VALUE_REQUIRED");
        require(newValue >= self.min, "NEW_VALUE_MUST_BE_GT_MIN_VALUE");
        require(newValue <= self.max, "NEW_VALUE_MUST_BE_LT_MAX_VALUE");
        oldValue = self.value;
        self.value = newValue;
    }

    /**
        @notice It removes a current platform setting.
        @param self the current platform setting to remove.
     */
    function remove(PlatformSetting storage self) internal {
        requireExists(self);
        self.value = 0;
        self.min = 0;
        self.max = 0;
        self.exists = false;
    }
}

interface SettingsInterface {
    /**
        @notice This event is emitted when a new platform setting is created.
        @param settingName new setting name.
        @param sender address that created it.
        @param value value for the new setting.
     */
    event PlatformSettingCreated(
        bytes32 indexed settingName,
        address indexed sender,
        uint256 value,
        uint256 minValue,
        uint256 maxValue
    );

    /**
        @notice This event is emitted when a current platform setting is removed.
        @param settingName setting name removed.
        @param sender address that removed it.
     */
    event PlatformSettingRemoved(
        bytes32 indexed settingName,
        uint256 lastValue,
        address indexed sender
    );

    /**
        @notice This event is emitted when a platform setting is updated.
        @param settingName settings name updated.
        @param sender address that updated it.
        @param oldValue old value for the setting.
        @param newValue new value for the setting.
     */
    event PlatformSettingUpdated(
        bytes32 indexed settingName,
        address indexed sender,
        uint256 oldValue,
        uint256 newValue
    );

    /**
        @notice This event is emitted when a lending pool is paused.
        @param account address that paused the lending pool.
        @param lendingPoolAddress lending pool address which was paused.
     */
    event LendingPoolPaused(address indexed account, address indexed lendingPoolAddress);

    /**
        @notice This event is emitted when a lending pool is unpaused.
        @param account address that paused the lending pool.
        @param lendingPoolAddress lending pool address which was unpaused.
     */
    event LendingPoolUnpaused(
        address indexed account,
        address indexed lendingPoolAddress
    );

    /**
        @notice This event is emitted when an new asset settings is created.
        @param sender the transaction sender address.
        @param assetAddress the asset address used to create the settings.
        @param cTokenAddress cToken address to configure for the asset.
        @param maxLoanAmount max loan amount to configure for the asset.
     */
    event AssetSettingsCreated(
        address indexed sender,
        address indexed assetAddress,
        address cTokenAddress,
        uint256 maxLoanAmount
    );

    /**
        @notice This event is emitted when an asset settings is removed.
        @param sender the transaction sender address.
        @param assetAddress the asset address used to remove the settings.
     */
    event AssetSettingsRemoved(address indexed sender, address indexed assetAddress);

    /**
        @notice This event is emitted when an asset settings (address type) is updated.
        @param assetSettingName asset setting name updated.
        @param sender the transaction sender address.
        @param assetAddress the asset address used to update the asset settings.
        @param oldValue old value used for the asset setting.
        @param newValue the value updated.
     */
    event AssetSettingsAddressUpdated(
        bytes32 indexed assetSettingName,
        address indexed sender,
        address indexed assetAddress,
        address oldValue,
        address newValue
    );

    /**
        @notice This event is emitted when an asset settings (uint256 type) is updated.
        @param assetSettingName asset setting name updated.
        @param sender the transaction sender address.
        @param assetAddress the asset address used to update the asset settings.
        @param oldValue old value used for the asset setting.
        @param newValue the value updated.
     */
    event AssetSettingsUintUpdated(
        bytes32 indexed assetSettingName,
        address indexed sender,
        address indexed assetAddress,
        uint256 oldValue,
        uint256 newValue
    );

    /**
        @notice It creates a new platform setting given a setting name, value, min and max values.
        @param settingName setting name to create.
        @param value the initial value for the given setting name.
        @param minValue the min value for the setting.
        @param maxValue the max value for the setting.
     */
    function createPlatformSetting(
        bytes32 settingName,
        uint256 value,
        uint256 minValue,
        uint256 maxValue
    ) external;

    /**
        @notice It updates an existent platform setting given a setting name.
        @notice It only allows to update the value (not the min or max values).
        @notice In case you need to update the min or max values, you need to remove it, and create it again.
        @param settingName setting name to update.
        @param newValue the new value to set.
     */
    function updatePlatformSetting(bytes32 settingName, uint256 newValue) external;

    /**
        @notice Removes a current platform setting given a setting name.
        @param settingName to remove.
     */
    function removePlatformSetting(bytes32 settingName) external;

    /**
        @notice It gets the current platform setting for a given setting name
        @param settingName to get.
        @return the current platform setting.
     */
    function getPlatformSetting(bytes32 settingName)
        external
        view
        returns (PlatformSettingsLib.PlatformSetting memory);

    /**
        @notice It gets the current platform setting value for a given setting name
        @param settingName to get.
        @return the current platform setting value.
     */
    function getPlatformSettingValue(bytes32 settingName) external view returns (uint256);

    /**
        @notice It tests whether a setting name is already configured.
        @param settingName setting name to test.
        @return true if the setting is already configured. Otherwise it returns false.
     */
    function hasPlatformSetting(bytes32 settingName) external view returns (bool);

    /**
        @notice It gets whether the platform is paused or not.
        @return true if platform is paused. Otherwise it returns false.
     */
    function isPaused() external view returns (bool);

    /**
        @notice It gets whether a lending pool is paused or not.
        @param lendingPoolAddress lending pool address to test.
        @return true if the lending pool is paused. Otherwise it returns false.
     */
    function lendingPoolPaused(address lendingPoolAddress) external view returns (bool);

    /**
        @notice It pauses a specific lending pool.
        @param lendingPoolAddress lending pool address to pause.
     */
    function pauseLendingPool(address lendingPoolAddress) external;

    /**
        @notice It unpauses a specific lending pool.
        @param lendingPoolAddress lending pool address to unpause.
     */
    function unpauseLendingPool(address lendingPoolAddress) external;

    /**
        @notice It creates a new asset settings in the platform.
        @param assetAddress asset address used to create the new setting.
        @param cTokenAddress cToken address used to configure the asset setting.
        @param maxLoanAmount the max loan amount used to configure the asset setting.
     */
    function createAssetSettings(
        address assetAddress,
        address cTokenAddress,
        uint256 maxLoanAmount
    ) external;

    /**
        @notice It removes all the asset settings for a specific asset address.
        @param assetAddress asset address used to remove the asset settings.
     */
    function removeAssetSettings(address assetAddress) external;

    /**
        @notice It updates the maximum loan amount for a specific asset address.
        @param assetAddress asset address to configure.
        @param newMaxLoanAmount the new maximum loan amount to configure.
     */
    function updateMaxLoanAmount(address assetAddress, uint256 newMaxLoanAmount) external;

    /**
        @notice It updates the cToken address for a specific asset address.
        @param assetAddress asset address to configure.
        @param newCTokenAddress the new cToken address to configure.
     */
    function updateCTokenAddress(address assetAddress, address newCTokenAddress) external;

    /**
        @notice Gets the current asset addresses list.
        @return the asset addresses list.
     */
    function getAssets() external view returns (address[] memory);

    /**
        @notice Get the current asset settings for a given asset address.
        @param assetAddress asset address used to get the current settings.
        @return the current asset settings.
     */
    function getAssetSettings(address assetAddress)
        external
        view
        returns (AssetSettingsLib.AssetSettings memory);

    /**
        @notice Tests whether amount exceeds the current maximum loan amount for a specific asset settings.
        @param assetAddress asset address to test the setting.
        @param amount amount to test.
        @return true if amount exceeds current max loan amout. Otherwise it returns false.
     */
    function exceedsMaxLoanAmount(address assetAddress, uint256 amount)
        external
        view
        returns (bool);

    /**
        @notice Tests whether an account has the pauser role.
        @param account account to test.
        @return true if account has the pauser role. Otherwise it returns false.
     */
    function hasPauserRole(address account) external view returns (bool);
}

library MarketStateLib {
    using SafeMath for uint256;

    // Multiply by this to convert a number into a percentage.
    uint256 private constant TO_PERCENTAGE = 10000;

    struct MarketState {
        uint256 totalSupplied;
        uint256 totalRepaid;
        uint256 totalBorrowed;
    }

    /**
        @notice It increases the repayment amount for a given market.
        @param self the current market state reference.
        @param amount amount to add.
     */
    function increaseRepayment(MarketState storage self, uint256 amount) internal {
        self.totalRepaid = self.totalRepaid.add(amount);
    }

    /**
        @notice It increases the supply amount for a given market.
        @param self the current market state reference.
        @param amount amount to add.
     */
    function increaseSupply(MarketState storage self, uint256 amount) internal {
        self.totalSupplied = self.totalSupplied.add(amount);
    }

    /**
        @notice It decreases the supply amount for a given market.
        @param self the current market state reference.
        @param amount amount to add.
     */
    function decreaseSupply(MarketState storage self, uint256 amount) internal {
        self.totalSupplied = self.totalSupplied.sub(amount);
    }

    /**
        @notice It increases the borrowed amount for a given market.
        @param self the current market state reference.
        @param amount amount to add.
     */
    function increaseBorrow(MarketState storage self, uint256 amount) internal {
        self.totalBorrowed = self.totalBorrowed.add(amount);
    }

    /**
        @notice It gets the current supply-to-debt (StD) ratio for a given market.
        @notice The formula to calculate StD ratio is:
            
            StD = (SUM(total borrowed) - SUM(total repaid)) / SUM(total supplied)

        @notice The value has 2 decimal places.
            Example:
                100 => 1%
        @param self the current market state reference.
        @return the supply-to-debt ratio value.
     */
    function getSupplyToDebt(MarketState storage self) internal view returns (uint256) {
        if (self.totalSupplied == 0) {
            return 0;
        }
        return
            self.totalBorrowed.sub(self.totalRepaid).mul(TO_PERCENTAGE).div(
                self.totalSupplied
            );
    }

    /**
        @notice It gets the supply-to-debt (StD) ratio for a given market, including a new loan amount.
        @notice The formula to calculate StD ratio (including a new loan amount) is:
            
            StD = (SUM(total borrowed) - SUM(total repaid) + NewLoanAmount) / SUM(total supplied)

        @param self the current market state reference.
        @param loanAmount a new loan amount to consider in the ratio.
        @return the supply-to-debt ratio value.
     */
    function getSupplyToDebtFor(MarketState storage self, uint256 loanAmount)
        internal
        view
        returns (uint256)
    {
        if (self.totalSupplied == 0) {
            return 0;
        }
        return
            self
                .totalBorrowed
                .sub(self.totalRepaid)
                .add(loanAmount)
                .mul(TO_PERCENTAGE)
                .div(self.totalSupplied);
    }
}

interface MarketsStateInterface {
    /**
        @notice It increases the repayment amount for a given market.
        @notice This function is called every new repayment is received.
        @param borrowedAsset borrowed asset address.
        @param collateralAsset collateral asset address.
        @param amount amount to add.
     */
    function increaseRepayment(
        address borrowedAsset,
        address collateralAsset,
        uint256 amount
    ) external;

    /**
        @notice It increases the supply amount for a given market.
        @notice This function is called every new deposit (Lenders) is received.
        @param borrowedAsset borrowed asset address.
        @param collateralAsset collateral asset address.
        @param amount amount to add.
     */
    function increaseSupply(
        address borrowedAsset,
        address collateralAsset,
        uint256 amount
    ) external;

    /**
        @notice It decreases the supply amount for a given market.
        @notice This function is called every new withdraw (Lenders) is done.
        @param borrowedAsset borrowed asset address.
        @param collateralAsset collateral asset address.
        @param amount amount to decrease.
     */
    function decreaseSupply(
        address borrowedAsset,
        address collateralAsset,
        uint256 amount
    ) external;

    /**
        @notice It increases the borrowed amount for a given market.
        @notice This function is called every new loan is taken out.
        @param borrowedAsset borrowed asset address.
        @param collateralAsset collateral asset address.
        @param amount amount to add.
     */
    function increaseBorrow(
        address borrowedAsset,
        address collateralAsset,
        uint256 amount
    ) external;

    /**
        @notice It gets the current supply-to-debt (StD) ratio for a given market.
        @param borrowedAsset borrowed asset address.
        @param collateralAsset collateral asset address.
        @return the supply-to-debt ratio value.
     */
    function getSupplyToDebt(address borrowedAsset, address collateralAsset)
        external
        view
        returns (uint256);

    /**
        @notice It gets the supply-to-debt (StD) ratio for a given market, including a new loan amount.
        @param borrowedAsset borrowed asset address.
        @param collateralAsset collateral asset address.
        @param loanAmount a new loan amount to consider in the ratio.
        @return the supply-to-debt ratio value.
     */
    function getSupplyToDebtFor(
        address borrowedAsset,
        address collateralAsset,
        uint256 loanAmount
    ) external view returns (uint256);

    /**
        @notice It gets the current market state.
        @param borrowedAsset borrowed asset address.
        @param collateralAsset collateral asset address.
        @return the current market state.
     */
    function getMarket(address borrowedAsset, address collateralAsset)
        external
        view
        returns (MarketStateLib.MarketState memory);
}

contract Base is TInitializable, ReentrancyGuard {
    using AddressLib for address;
    using Address for address;

    /* State Variables */

    SettingsInterface public settings;
    MarketsStateInterface public markets;

    /** Modifiers */

    /**
        @notice Checks whether the platform is paused or not.
        @dev It throws a require error if platform is paused.
     */
    modifier whenNotPaused() {
        require(!_isPaused(), "PLATFORM_IS_PAUSED");
        _;
    }

    /**
        @notice Checks whether a specific lending pool address is paused or not.
        @dev It throws a require error if the lending pool is paused.
        @param lendingPoolAddress lending pool address to check.
     */
    modifier whenLendingPoolNotPaused(address lendingPoolAddress) {
        require(!_isPoolPaused(lendingPoolAddress), "LENDING_POOL_IS_PAUSED");
        _;
    }

    /**
        @notice Checks whether the platform is paused or not.
        @dev It throws a require error if platform is not paused.
     */
    modifier whenPaused() {
        require(_isPaused(), "PLATFORM_IS_NOT_PAUSED");
        _;
    }

    /**
        @notice Checks whether a specific lending pool address is paused or not.
        @dev It throws a require error if the lending pool is not paused.
        @param lendingPoolAddress lending pool address to check.
     */
    modifier whenLendingPoolPaused(address lendingPoolAddress) {
        require(_isPoolPaused(lendingPoolAddress), "LENDING_POOL_IS_NOT_PAUSED");
        _;
    }

    /**
        @notice Checks whether a given address is allowed (see Settings#hasPauserRole function) or not.
        @dev It throws a require error if address is not allowed.
        @param anAddress account to test.
     */
    modifier whenAllowed(address anAddress) {
        require(settings.hasPauserRole(anAddress), "ADDRESS_ISNT_ALLOWED");
        _;
    }

    /* Constructor */

    /** External Functions */

    /** Internal functions */

    /**
        @notice It initializes the current contract instance setting the required parameters.
        @param settingsAddress settings contract address.
        @param marketsAddress markets state contract address.
     */
    function _initialize(address settingsAddress, address marketsAddress)
        internal
        isNotInitialized()
    {
        settingsAddress.requireNotEmpty("SETTINGS_MUST_BE_PROVIDED");
        require(settingsAddress.isContract(), "SETTINGS_MUST_BE_A_CONTRACT");
        marketsAddress.requireNotEmpty("MARKETS_MUST_BE_PROVIDED");
        require(marketsAddress.isContract(), "MARKETS_MUST_BE_A_CONTRACT");

        _initialize();

        settings = SettingsInterface(settingsAddress);
        markets = MarketsStateInterface(marketsAddress);
    }

    /**
        @notice Gets if a specific lending pool address is paused or not.
        @param poolAddress lending pool address to check.
        @return true if the lending pool address is  paused. Otherwise it returns false.
     */
    function _isPoolPaused(address poolAddress) internal view returns (bool) {
        return settings.lendingPoolPaused(poolAddress);
    }

    /**
        @notice Gets if the platform is paused or not.
        @return true if platform is paused. Otherwise it returns false.
     */
    function _isPaused() internal view returns (bool) {
        return settings.isPaused();
    }

    /** Private functions */
}

interface PairAggregatorInterface {
    /**
        @notice Gets the current answer from the aggregator.
        @return the latest answer.
     */
    function getLatestAnswer() external view returns (int256);

    /**
        @notice Gets the last updated height from the aggregator.
        @return the latest timestamp.
     */
    function getLatestTimestamp() external view returns (uint256);

    /**
        @notice Gets past rounds answer.
        @param roundsBack the answer number to retrieve the answer for
        @return the previous answer.
     */
    function getPreviousAnswer(uint256 roundsBack) external view returns (int256);

    /**
        @notice Gets block timestamp when an answer was last updated.
        @param roundsBack the answer number to retrieve the updated timestamp for.
        @return the previous timestamp.
     */
    function getPreviousTimestamp(uint256 roundsBack) external view returns (uint256);

    /**
        @notice Gets the latest completed round where the answer was updated.
        @return the latest round id.
    */
    function getLatestRound() external view returns (uint256);
}

interface LendingPoolInterface {
    /**
        @notice It allows users to deposit tokens into the pool.
        @dev the user must call ERC20.approve function previously.
        @param amount of tokens to deposit in the pool.
    */
    function deposit(uint256 amount) external;

    /**
        @notice It allows any tToken holder to burn their tToken tokens and withdraw their tokens.
        @param amount of tokens to withdraw.
        @dev It throws a require error if the contract hasn't enough tokens balance.
        @dev It throws a require error if the holder hasn't enough tToken balance.
     */
    function withdraw(uint256 amount) external;

    /**
        @notice It allows a borrower repaying their loan. 
        @dev This function can be called ONLY by the Loans contract.
        @dev It requires a ERC20.approve call before calling it.
        @dev It throws a require error if borrower called ERC20.approve function before calling it.
        @param amount of tokens.
        @param borrower address that is repaying the loan.
     */
    function repay(uint256 amount, address borrower) external;

    /**
        @notice Once a loan is liquidated, it transfers the amount of tokens to the liquidator address.
        @param amount of tokens to liquidate.
        @param liquidator address to receive the tokens.
        @dev It throws a require error if this contract hasn't enough token balance.
     */
    function liquidationPayment(uint256 amount, address liquidator) external;

    /**
        @notice Once the loan is created, it transfers the amount of tokens to the borrower.
        @param amount of tokens to transfer.
        @param borrower address which will receive the tokens.
        @dev This function only can be invoked by the LoansInterface implementation.
        @dev It throws a require error if current ERC20 balance isn't enough to transfer the tokens.
     */
    function createLoan(uint256 amount, address borrower) external;

    /**
        @notice It allows a lender to withdraw a specific amount of interest.
        @param amount to withdraw.
        @dev It throws a require error if amount exceeds the current accrued interest.
    */
    function withdrawInterest(uint256 amount) external;

    /**
        @notice It gets the lending token address.
        @return the ERC20 lending token address.
    */
    function lendingToken() external view returns (address);

    /**
        @notice Gets the current interest validator. By default it is 0x0.
        @return the interest validator contract address or empty address (0x0). 
     */
    function interestValidator() external view returns (address);

    /**
        @notice Update the current interest validator address.
        @param newInterestValidator the new interest validator address.
     */
    function setInterestValidator(address newInterestValidator) external;

    /**
        @notice This event is emitted when an user deposits tokens into the pool.
        @param sender address.
        @param amount of tokens.
     */
    event TokenDeposited(address indexed sender, uint256 amount);

    /**
        @notice This event is emitted when an user withdraws tokens from the pool.
        @param sender address that withdrew the tokens.
        @param amount of tokens.
     */
    event TokenWithdrawn(address indexed sender, uint256 amount);

    /**
        @notice This event is emitted when an borrower repaid a loan.
        @param borrower address.
        @param amount of tokens.
     */
    event TokenRepaid(address indexed borrower, uint256 amount);

    /**
        @notice This event is emitted when an lender withdraws interests.
        @param lender address.
        @param amount of tokens.
     */
    event InterestWithdrawn(address indexed lender, uint256 amount);

    /**
        @notice This event is emitted when a liquidator liquidates a loan.
        @param liquidator address.
        @param amount of tokens.
     */
    event PaymentLiquidated(address indexed liquidator, uint256 amount);

    /**
        @notice This event is emitted when the interest validator is updated.
        @param sender account that sends the transaction.
        @param oldInterestValidator the old validator address.
        @param newInterestValidator the new validator address.
     */
    event InterestValidatorUpdated(
        address indexed sender,
        address indexed oldInterestValidator,
        address indexed newInterestValidator
    );
}

interface LoanTermsConsensusInterface {
    /**
        @notice This event is emitted when the loan terms have been submitted
        @param signer Account address of the signatory
        @param borrower Account address of the borrowing party
        @param requestNonce Nonce used for authentication of the loan request
        @param interestRate Interest rate submitted in the loan request
        @param collateralRatio Ratio of collateral submitted for the loan
        @param maxLoanAmount Maximum loan amount that can be taken out
     */
    event TermsSubmitted(
        address indexed signer,
        address indexed borrower,
        uint256 indexed requestNonce,
        uint256 interestRate,
        uint256 collateralRatio,
        uint256 maxLoanAmount
    );

    /**
        @notice This event is emitted when the loan terms have been accepted
        @param borrower Account address of the borrowing party
        @param requestNonce Accepted interest rate for the loan
        @param collateralRatio Ratio of collateral needed for the loan
        @param maxLoanAmount Maximum loan amount that the borrower can take out
     */
    event TermsAccepted(
        address indexed borrower,
        uint256 indexed requestNonce,
        uint256 interestRate,
        uint256 collateralRatio,
        uint256 maxLoanAmount
    );

    /**
        @notice Processes the loan request
        @param request Struct of the protocol loan request
        @param responses List of structs of the protocol loan responses
        @return uint256 Interest rate
        @return uint256 Collateral ratio
        @return uint256 Maximum loan amount
     */
    function processRequest(
        TellerCommon.LoanRequest calldata request,
        TellerCommon.LoanResponse[] calldata responses
    ) external returns (uint256, uint256, uint256);
}

interface LoansInterface {
    /**
        @notice This event is emitted when collateral has been deposited for the loan
        @param loanID ID of the loan for which collateral was deposited
        @param borrower Account address of the borrower
        @param depositAmount Amount of collateral deposited
     */
    event CollateralDeposited(
        uint256 indexed loanID,
        address indexed borrower,
        uint256 depositAmount
    );

    /**
        @notice This event is emitted when collateral has been withdrawn
        @param loanID ID of loan from which collateral was withdrawn
        @param borrower Account address of the borrower
     */
    event CollateralWithdrawn(
        uint256 indexed loanID,
        address indexed borrower,
        uint256 withdrawalAmount
    );

    /**
        @notice This event is emitted when loan terms have been successsfully set
        @param loanID ID of loan from which collateral was withdrawn
        @param borrower Account address of the borrower
        @param recipient Account address of the recipient
        @param interestRate Interest rate set in the loan terms
        @param collateralRatio Collateral ratio set in the loan terms
        @param maxLoanAmount Maximum loan amount that can be taken out, set in the loan terms
     */
    event LoanTermsSet(
        uint256 indexed loanID,
        address indexed borrower,
        address indexed recipient,
        uint256 interestRate,
        uint256 collateralRatio,
        uint256 maxLoanAmount,
        uint256 duration,
        uint256 termsExpiry
    );

    /**
        @notice This event is emitted when a loan has been successfully taken out
        @param loanID ID of loan from which collateral was withdrawn
        @param borrower Account address of the borrower
        @param amountBorrowed Total amount taken out in the loan
     */
    event LoanTakenOut(
        uint256 indexed loanID,
        address indexed borrower,
        uint256 amountBorrowed
    );

    /**
        @notice This event is emitted when a loan has been successfully repaid
        @param loanID ID of loan from which collateral was withdrawn
        @param borrower Account address of the borrower
        @param amountPaid Amount of the loan paid back
        @param payer Account address of the payer
        @param totalOwed Total amount of the loan to be repaid
     */
    event LoanRepaid(
        uint256 indexed loanID,
        address indexed borrower,
        uint256 amountPaid,
        address payer,
        uint256 totalOwed
    );

    /**
        @notice This event is emitted when a loan has been successfully liquidated
        @param loanID ID of loan from which collateral was withdrawn
        @param borrower Account address of the borrower
        @param liquidator Account address of the liquidator
        @param collateralOut Collateral that is sent to the liquidator
        @param tokensIn Percentage of the collateral price paid by the liquidator to the lending pool
     */
    event LoanLiquidated(
        uint256 indexed loanID,
        address indexed borrower,
        address liquidator,
        uint256 collateralOut,
        uint256 tokensIn
    );

    /**
        @notice This event is emitted when a the price oracle instance is updated.
        @param oldPriceOracle the previous price oracle address.
        @param newPriceOracle the new price oracle address.
     */
    event PriceOracleUpdated(
        address indexed sender,
        address indexed oldPriceOracle,
        address indexed newPriceOracle
    );

    /**
        @notice Returns a list of all loans for a borrower
        @param borrower Account address of the borrower
     */
    function getBorrowerLoans(address borrower) external view returns (uint256[] memory);

    /**
        @notice Returns the struct of a loan
        @param loanID ID of loan from which collateral was withdrawn
     */
    function loans(uint256 loanID) external view returns (TellerCommon.Loan memory);

    /**
        @notice Deposit collateral for a loan, unless it isn't allowed
        @param borrower Account address of the borrower
        @param loanID ID of loan from which collateral was withdrawn
        @param amount Amount to be deposited as collateral
     */
    function depositCollateral(address borrower, uint256 loanID, uint256 amount)
        external
        payable;

    /**
        @notice Withdraw collateral from a loan, unless this isn't allowed
        @param amount The amount of collateral token or ether the caller is hoping to withdraw
        @param loanID The ID of the loan the collateral is for
     */
    function withdrawCollateral(uint256 amount, uint256 loanID) external;

    /**
        @notice Create a loan with specified terms, if allowed
        @param request Struct of the protocol loan request
        @param responses List of structs of the protocol loan responses
        @param collateralAmount Amount of collateral for the loan
     */
    function createLoanWithTerms(
        TellerCommon.LoanRequest calldata request,
        TellerCommon.LoanResponse[] calldata responses,
        uint256 collateralAmount
    ) external payable;

    /**
        @notice Take out a loan, if allowed
        @param loanID The ID of the loan to be taken out
        @param amountBorrow Amount of tokens to be taken out in the loan
     */
    function takeOutLoan(uint256 loanID, uint256 amountBorrow) external;

    /**
        @notice Make a payment to a specified loan
        @param amount The amount of tokens to pay back to the loan
        @param loanID The ID of the loan the payment is for
     */
    function repay(uint256 amount, uint256 loanID) external;

    /**
        @notice Liquidate a loan if has is expired or undercollateralised
        @param loanID The ID of the loan to be liquidated
     */
    function liquidateLoan(uint256 loanID) external;

    /**
        @notice Get the current price oracle
        @return address Contract adddress of the price oracle
     */
    function priceOracle() external view returns (address);

    /**
        @notice Returns the lending token in the lending pool
        @return address Contract adddress of the lending pool
     */
    function lendingPool() external view returns (address);

    /**
        @notice Returns the lending token in the lending pool
        @return address Contract address of the lending token
     */
    function lendingToken() external view returns (address);

    /**
        @notice Returns the total amount of collateral
        @return uint256 The total amount of collateral held by the contract instance
     */
    function totalCollateral() external view returns (uint256);

    /**
        @notice Returns the ID of loans taken out
        @return uint256 The next available loan ID
     */
    function loanIDCounter() external view returns (uint256);

    /**
        @notice Returns the collateral token
        @return address Contract address of the token
     */
    function collateralToken() external view returns (address);

    /**
        @notice Get collateral infomation of a specific loan
        @param loanID ID of the loan to get info for
        @return uint256 Collateral needed
        @return uint256 Collaternal needed in Lending tokens
        @return uint256 Collateral needed in Collateral tokens
        @return bool If more collateral is needed or not
     */
    function getCollateralInfo(uint256 loanID)
        external
        view
        returns (
            uint256 collateral,
            uint256 collateralNeededLendingTokens,
            uint256 collateralNeededCollateralTokens,
            bool requireCollateral
        );

    /**
        @notice Updates the current price oracle instance.
        @param newPriceOracle the new price oracle address.
     */
    function setPriceOracle(address newPriceOracle) external;
}

interface IATMSettings {
    /** Events */

    /**
        @notice This event is emitted when an ATM is paused.
        @param atm paused ATM address.
        @param account address that paused the ATM.
     */
    event ATMPaused(address indexed atm, address indexed account);

    /**
        @notice This event is emitted when an ATM is unpaused.
        @param atm unpaused ATM address.
        @param account address that unpaused the ATM.
     */
    event ATMUnpaused(address indexed account, address indexed atm);

    /**
        @notice This event is emitted when the setting for a Market/ATM is set.
        @param borrowedToken borrowed token address.
        @param collateralToken collateral token address.
        @param atm ATM address to set in the given market.
        @param account address that set the setting.
     */
    event MarketToAtmSet(
        address indexed borrowedToken,
        address indexed collateralToken,
        address indexed atm,
        address account
    );

    /**
        @notice This event is emitted when the setting for a Market/ATM is updated.
        @param borrowedToken borrowed token address.
        @param collateralToken collateral token address.
        @param oldAtm the old ATM address in the given market.
        @param newAtm the new ATM address in the given market.
        @param account address that updated the setting.
     */
    event MarketToAtmUpdated(
        address indexed borrowedToken,
        address indexed collateralToken,
        address indexed oldAtm,
        address newAtm,
        address account
    );

    /**
        @notice This event is emitted when the setting for a Market/ATM is removed.
        @param borrowedToken borrowed token address.
        @param collateralToken collateral token address.
        @param oldAtm last ATM address in the given market.
        @param account address that removed the setting.
     */
    event MarketToAtmRemoved(
        address indexed borrowedToken,
        address indexed collateralToken,
        address indexed oldAtm,
        address account
    );

    /* State Variables */

    /** Modifiers */

    /* Constructor */

    /** External Functions */

    /**
        @notice It pauses an given ATM.
        @param atmAddress ATM address to pause.
     */
    function pauseATM(address atmAddress) external;

    /**
        @notice It unpauses an given ATM.
        @param atmAddress ATM address to unpause.
     */
    function unpauseATM(address atmAddress) external;

    /**
        @notice Gets whether an ATM is paused or not.
        @param atmAddress ATM address to test.
        @return true if ATM is paused. Otherwise it returns false.
     */
    function isATMPaused(address atmAddress) external view returns (bool);

    /**
        @notice Sets an ATM for a given market (borrowed token and collateral token).
        @param borrowedToken borrowed token address.
        @param collateralToken collateral token address.
        @param atmAddress ATM address to set.
     */
    function setATMToMarket(
        address borrowedToken,
        address collateralToken,
        address atmAddress
    ) external;

    /**
        @notice Updates a new ATM for a given market (borrowed token and collateral token).
        @param borrowedToken borrowed token address.
        @param collateralToken collateral token address.
        @param newAtmAddress the new ATM address to update.
     */
    function updateATMToMarket(
        address borrowedToken,
        address collateralToken,
        address newAtmAddress
    ) external;

    /**
        @notice Removes the ATM address for a given market (borrowed token and collateral token).
        @param borrowedToken borrowed token address.
        @param collateralToken collateral token address.
     */
    function removeATMToMarket(address borrowedToken, address collateralToken) external;

    /**
        @notice Gets the ATM configured for a given market (borrowed token and collateral token).
        @param borrowedToken borrowed token address.
        @param collateralToken collateral token address.
        @return the ATM address configured for a given market.
     */
    function getATMForMarket(address borrowedToken, address collateralToken)
        external
        view
        returns (address);

    /**
        @notice Tests whether an ATM is configured for a given market (borrowed token and collateral token) or not.
        @param borrowedToken borrowed token address.
        @param collateralToken collateral token address.
        @param atmAddress ATM address to test.
        @return true if the ATM is configured for the market. Otherwise it returns false.
     */
    function isATMForMarket(
        address borrowedToken,
        address collateralToken,
        address atmAddress
    ) external view returns (bool);
}

interface IATMGovernance {
    /* Events */

    /**
        @notice Emitted when a new ATM General Setting was added.
        @param sender transaction sender address.
        @param settingName name of the newly added setting.
        @param settingValue value of the newly added setting.  
     */
    event GeneralSettingAdded(
        address indexed sender,
        bytes32 indexed settingName,
        uint256 settingValue
    );

    /**
        @notice Emitted when an ATM General Setting was updated.
        @param sender transaction sender address.
        @param settingName name of the newly added setting.
        @param oldValue previous value of this setting.  
        @param newValue new value of this setting.  
     */
    event GeneralSettingUpdated(
        address indexed sender,
        bytes32 indexed settingName,
        uint256 oldValue,
        uint256 newValue
    );

    /**
        @notice Emitted when an ATM General Setting was removed.
        @param sender transaction sender address.
        @param settingName name of the setting removed.
        @param settingValue value of the setting removed.  
     */
    event GeneralSettingRemoved(
        address indexed sender,
        bytes32 indexed settingName,
        uint256 settingValue
    );

    /**
        @notice Emitted when a new Asset Setting was added for an specific Market.
        @param sender transaction sender address.
        @param asset asset address this setting was created for.
        @param settingName name of the added setting.
        @param settingValue value of the added setting.
     */
    event AssetMarketSettingAdded(
        address indexed sender,
        address indexed asset,
        bytes32 indexed settingName,
        uint256 settingValue
    );

    /**
        @notice Emitted when an Asset Setting was updated for an specific Market.
        @param sender transaction sender address.
        @param asset asset address this setting was updated for.
        @param settingName name of the updated setting.
        @param oldValue previous value of this setting.
        @param newValue new value of this setting.
     */
    event AssetMarketSettingUpdated(
        address indexed sender,
        address indexed asset,
        bytes32 indexed settingName,
        uint256 oldValue,
        uint256 newValue
    );

    /**
        @notice Emitted when an Asset Setting was removed for an specific Market.
        @param sender transaction sender address.
        @param asset asset address this setting was removed for.
        @param settingName name of the removed setting.
        @param oldValue previous value of the removed setting.
     */
    event AssetMarketSettingRemoved(
        address indexed sender,
        address indexed asset,
        bytes32 indexed settingName,
        uint256 oldValue
    );

    /**
        @notice Emitted when a new Data Provider was added to this ATM.
        @param sender transaction sender address.
        @param dataTypeIndex index of this data type.
        @param amountDataProviders amount of data providers for this data type.
        @param dataProvider address of the added Data Provider.
     */
    event DataProviderAdded(
        address indexed sender,
        uint8 indexed dataTypeIndex,
        uint256 amountDataProviders,
        address dataProvider
    );

    /**
        @notice Emitted when a Data Provider was updated on this ATM.
        @param sender transaction sender address.
        @param dataTypeIndex index of this data type.
        @param dataProviderIndex index of this data provider.
        @param oldDataProvider previous address of the Data Provider.
        @param newDataProvider new address of the Data Provider.
     */
    event DataProviderUpdated(
        address indexed sender,
        uint8 indexed dataTypeIndex,
        uint256 indexed dataProviderIndex,
        address oldDataProvider,
        address newDataProvider
    );

    /**
        @notice Emitted when a Data Provider was removed on this ATM.
        @param sender transaction sender address.
        @param dataTypeIndex index of this data type.
        @param dataProviderIndex index of this data provider inside this data type.
        @param dataProvider address of the Data Provider.
     */
    event DataProviderRemoved(
        address indexed sender,
        uint8 indexed dataTypeIndex,
        uint256 indexed dataProviderIndex,
        address dataProvider
    );

    /**
        @notice Emitted when a new CRA - Credit Risk Algorithm is set.
        @param sender transaction sender address.
        @param craCommitHash github commit hash with the new CRA implementation.
     */
    event CRASet(address indexed sender, string craCommitHash);

    /* External Functions */

    /**
        @notice Adds a new General Setting to this ATM.
        @param settingName name of the setting to be added.
        @param settingValue value of the setting to be added.
     */
    function addGeneralSetting(bytes32 settingName, uint256 settingValue) external;

    /**
        @notice Updates an existing General Setting on this ATM.
        @param settingName name of the setting to be modified.
        @param newValue new value to be set for this settingName. 
     */
    function updateGeneralSetting(bytes32 settingName, uint256 newValue) external;

    /**
        @notice Removes a General Setting from this ATM.
        @param settingName name of the setting to be removed.
     */
    function removeGeneralSetting(bytes32 settingName) external;

    /**
        @notice Adds a new Asset Setting from a specific Market on this ATM.
        @param asset market specific asset address.
        @param settingName name of the setting to be added.
        @param settingValue value of the setting to be added.
     */
    function addAssetMarketSetting(
        address asset,
        bytes32 settingName,
        uint256 settingValue
    ) external;

    /**
        @notice Updates an existing Asset Setting from a specific Market on this ATM.
        @param asset market specific asset address.
        @param settingName name of the setting to be added.
        @param newValue value of the setting to be added.
     */
    function updateAssetMarketSetting(
        address asset,
        bytes32 settingName,
        uint256 newValue
    ) external;

    /**
        @notice Removes an existing Asset Setting from a specific Market on this ATM.
        @param asset market specific asset address.
        @param settingName name of the setting to be added.
     */
    function removeAssetMarketSetting(address asset, bytes32 settingName) external;

    /**
        @notice Adds a new Data Provider on a specific Data Type array.
            This function would accept duplicated data providers for the same data type.
        @param dataTypeIndex array index for this Data Type.
        @param dataProvider data provider address.
     */
    function addDataProvider(uint8 dataTypeIndex, address dataProvider) external;

    /**
        @notice Updates an existing Data Provider on a specific Data Type array.
        @param dataTypeIndex array index for this Data Type.
        @param providerIndex previous data provider index.
        @param newProvider new data provider address.
     */
    function updateDataProvider(
        uint8 dataTypeIndex,
        uint256 providerIndex,
        address newProvider
    ) external;

    /**
        @notice Removes an existing Data Provider on a specific Data Type array.
        @param dataTypeIndex array index for this Data Type.
        @param dataProvider data provider index.
     */
    function removeDataProvider(uint8 dataTypeIndex, uint256 dataProvider) external;

    /**
        @notice Sets the CRA - Credit Risk Algorithm to be used on this specific ATM.
                CRA is represented by a Github commit hash of the newly proposed algorithm.
     */
    function setCRA(string calldata cra) external;

    /* External Constant functions */

    /**
        @notice Returns a General Setting value from this ATM.
        @param settingName name of the setting to be returned.
     */
    function getGeneralSetting(bytes32 settingName) external view returns (uint256);

    /**
        @notice Returns an existing Asset Setting value from a specific Market on this ATM.
        @param asset market specific asset address.
        @param settingName name of the setting to be returned.
     */
    function getAssetMarketSetting(address asset, bytes32 settingName)
        external
        view
        returns (uint256);

    /**
        @notice Returns a Data Provider on a specific Data Type array.
        @param dataTypeIndex array index for this Data Type.
        @param dataProviderIndex data provider index number.
     */
    function getDataProvider(uint8 dataTypeIndex, uint256 dataProviderIndex)
        external
        view
        returns (address);

    /**
        @notice Returns current CRA - Credit Risk Algorithm that is being used on this specific ATM.
                CRA is represented by a Github commit hash of the newly proposed algorithm.
     */
    function getCRA() external view returns (string memory);
}

contract LoansBase is LoansInterface, Base, SettingsConsts {
    using SafeMath for uint256;
    using ERC20Lib for ERC20;

    /* State Variables */

    // Loan length will be inputted in days, with 4 decimal places. i.e. 30 days will be inputted as
    // 300000. Therefore in interest calculations we must divide by 365000
    uint256 internal constant DAYS_PER_YEAR_4DP = 3650000;

    // For interestRate, collateral, and liquidation price, 7% is represented as 700. To find the value
    // of something we must divide 700 by 100 to remove decimal places, and another 100 for percentage.
    uint256 internal constant TEN_THOUSAND = 10000;

    bytes32 internal constant SUPPLY_TO_DEBT_ATM_SETTING = "SupplyToDebt";

    uint256 public totalCollateral;

    address public collateralToken;

    // At any time, this variable stores the next available loan ID
    uint256 public loanIDCounter;

    address public priceOracle;

    LendingPoolInterface public lendingPool;

    LoanTermsConsensusInterface public loanTermsConsensus;

    IATMSettings public atmSettings;

    mapping(address => uint256[]) public borrowerLoans;

    mapping(uint256 => TellerCommon.Loan) public loans;

    /* Modifiers */

    /**
        @notice Checks if the sender is a borrower or not
        @dev It throws a require error if the sender is not a borrower
        @param borrower Account address to check
     */
    modifier isBorrower(address borrower) {
        require(msg.sender == borrower, "BORROWER_MUST_BE_SENDER");
        _;
    }

    /**
        @notice Checks whether the loan is active or not
        @dev Throws a require error if the loan is not active
        @param loanID number of loan to check
     */
    modifier loanActive(uint256 loanID) {
        require(
            loans[loanID].status == TellerCommon.LoanStatus.Active,
            "LOAN_NOT_ACTIVE"
        );
        _;
    }

    /**
        @notice Checks if the loan has been set or not
        @dev Throws a require error if the loan terms have not been set
        @param loanID number of loan to check
     */
    modifier loanTermsSet(uint256 loanID) {
        require(loans[loanID].status == TellerCommon.LoanStatus.TermsSet, "LOAN_NOT_SET");
        _;
    }

    /**
        @notice Checks whether the loan is active and has been set or not
        @dev Throws a require error if the loan is not active or has not been set
        @param loanID number of loan to check
     */
    modifier loanActiveOrSet(uint256 loanID) {
        require(
            loans[loanID].status == TellerCommon.LoanStatus.TermsSet ||
                loans[loanID].status == TellerCommon.LoanStatus.Active,
            "LOAN_NOT_ACTIVE_OR_SET"
        );
        _;
    }

    /**
        @notice Checks the given loan request is valid.
        @dev It throws an require error if the duration exceeds the maximum loan duration.
        @dev It throws an require error if the loan amount exceeds the maximum loan amount for the given asset.
        @param loanRequest to validate.
     */
    modifier withValidLoanRequest(TellerCommon.LoanRequest memory loanRequest) {
        require(
            settings.getPlatformSettingValue(MAXIMUM_LOAN_DURATION_SETTING) >=
                loanRequest.duration,
            "DURATION_EXCEEDS_MAX_DURATION"
        );
        require(
            !settings.exceedsMaxLoanAmount(
                lendingPool.lendingToken(),
                loanRequest.amount
            ),
            "AMOUNT_EXCEEDS_MAX_AMOUNT"
        );
        require(
            _isSupplyToDebtRatioValid(loanRequest.amount),
            "SUPPLY_TO_DEBT_EXCEEDS_MAX"
        );
        _;
    }

    /**
        @notice Get a list of all loans for a borrower
        @param borrower The borrower's address
     */
    function getBorrowerLoans(address borrower) external view returns (uint256[] memory) {
        return borrowerLoans[borrower];
    }

    /**
        @notice Returns the lending token in the lending pool
        @return Address of the lending token
     */
    function lendingToken() external view returns (address) {
        return lendingPool.lendingToken();
    }

    /**
     * @notice Withdraw collateral from a loan, unless this isn't allowed
     * @param amount The amount of collateral token or ether the caller is hoping to withdraw.
     * @param loanID The ID of the loan the collateral is for
     */
    function withdrawCollateral(uint256 amount, uint256 loanID)
        external
        loanActiveOrSet(loanID)
        isInitialized()
        whenNotPaused()
        whenLendingPoolNotPaused(address(lendingPool))
        nonReentrant()
    {
        require(msg.sender == loans[loanID].loanTerms.borrower, "CALLER_DOESNT_OWN_LOAN");
        require(amount > 0, "CANNOT_WITHDRAW_ZERO");

        // Find the minimum collateral amount this loan is allowed in tokens or ether.
        uint256 collateralNeededToken = _getCollateralNeededInTokens(
            _getTotalOwed(loanID),
            loans[loanID].loanTerms.collateralRatio
        );
        uint256 collateralNeededWei = _convertTokenToWei(collateralNeededToken);

        // Withdrawal amount holds the amount of excess collateral in the loan
        uint256 withdrawalAmount = loans[loanID].collateral.sub(collateralNeededWei);
        if (withdrawalAmount > amount) {
            withdrawalAmount = amount;
        }

        if (withdrawalAmount > 0) {
            // Update the contract total and the loan collateral total
            _payOutCollateral(loanID, withdrawalAmount, msg.sender);
        }

        emit CollateralWithdrawn(loanID, msg.sender, withdrawalAmount);
    }

    /**
     * @notice Take out a loan
     *
     * @dev collateral ratio is a percentage of the loan amount that's required in collateral
     * @dev the percentage will be *(10**2). I.e. collateralRatio of 5244 means 52.44% collateral
     * @dev is required in the loan. Interest rate is also a percentage with 2 decimal points.
     */
    function takeOutLoan(uint256 loanID, uint256 amountBorrow)
        external
        loanTermsSet(loanID)
        isInitialized()
        whenNotPaused()
        whenLendingPoolNotPaused(address(lendingPool))
        nonReentrant()
        isBorrower(loans[loanID].loanTerms.borrower)
    {
        require(
            loans[loanID].loanTerms.maxLoanAmount >= amountBorrow,
            "MAX_LOAN_EXCEEDED"
        );

        require(loans[loanID].termsExpiry >= now, "LOAN_TERMS_EXPIRED");

        require(
            loans[loanID].lastCollateralIn <=
                now.sub(settings.getPlatformSettingValue(SAFETY_INTERVAL_SETTING)),
            "COLLATERAL_DEPOSITED_RECENTLY"
        );

        loans[loanID].borrowedAmount = amountBorrow;
        loans[loanID].principalOwed = amountBorrow;
        loans[loanID].interestOwed = amountBorrow
            .mul(loans[loanID].loanTerms.interestRate)
            .mul(loans[loanID].loanTerms.duration)
            .div(TEN_THOUSAND)
            .div(DAYS_PER_YEAR_4DP);

        // check that enough collateral has been provided for this loan
        (, , , bool moreCollateralRequired) = _getCollateralInfo(loanID);

        require(!moreCollateralRequired, "MORE_COLLATERAL_REQUIRED");

        loans[loanID].loanStartTime = now;

        loans[loanID].status = TellerCommon.LoanStatus.Active;

        // give the recipient their requested amount of tokens
        if (loans[loanID].loanTerms.recipient != address(0)) {
            lendingPool.createLoan(amountBorrow, loans[loanID].loanTerms.recipient);
        } else {
            lendingPool.createLoan(amountBorrow, loans[loanID].loanTerms.borrower);
        }

        markets.increaseBorrow(
            lendingPool.lendingToken(),
            this.collateralToken(),
            amountBorrow
        );

        emit LoanTakenOut(loanID, loans[loanID].loanTerms.borrower, amountBorrow);
    }

    /**
     * @notice Make a payment to a loan
     * @param amount The amount of tokens to pay back to the loan
     * @param loanID The ID of the loan the payment is for
     */
    function repay(uint256 amount, uint256 loanID)
        external
        loanActive(loanID)
        isInitialized()
        whenNotPaused()
        whenLendingPoolNotPaused(address(lendingPool))
        nonReentrant()
    {
        require(amount > 0, "AMOUNT_VALUE_REQUIRED");
        // calculate the actual amount to repay
        uint256 toPay = amount;
        uint256 totalOwed = _getTotalOwed(loanID);
        if (totalOwed < toPay) {
            toPay = totalOwed;
        }

        // update the amount owed on the loan
        totalOwed = totalOwed.sub(toPay);
        _payLoan(loanID, toPay);

        // if the loan is now fully paid, close it and return collateral
        if (totalOwed == 0) {
            loans[loanID].status = TellerCommon.LoanStatus.Closed;

            uint256 collateralAmount = loans[loanID].collateral;
            _payOutCollateral(loanID, collateralAmount, loans[loanID].loanTerms.borrower);

            emit CollateralWithdrawn(
                loanID,
                loans[loanID].loanTerms.borrower,
                collateralAmount
            );
        }

        // collect the money from the payer
        lendingPool.repay(toPay, msg.sender);

        markets.increaseRepayment(
            lendingPool.lendingToken(),
            this.collateralToken(),
            toPay
        );

        emit LoanRepaid(
            loanID,
            loans[loanID].loanTerms.borrower,
            toPay,
            msg.sender,
            totalOwed
        );
    }

    /**
     * @notice Liquidate a loan if it is expired or undercollateralised
     * @param loanID The ID of the loan to be liquidated
     */
    function liquidateLoan(uint256 loanID)
        external
        loanActive(loanID)
        isInitialized()
        whenNotPaused()
        whenLendingPoolNotPaused(address(lendingPool))
        nonReentrant()
    {
        // calculate the amount of collateral the loan needs in tokens
        (uint256 loanCollateral, , , bool moreCollateralRequired) = _getCollateralInfo(
            loanID
        );

        // calculate when the loan should end
        uint256 loanEndTime = loans[loanID].loanStartTime.add(
            loans[loanID].loanTerms.duration
        );

        // to liquidate it must be undercollateralised, or expired
        require(moreCollateralRequired || loanEndTime < now, "DOESNT_NEED_LIQUIDATION");

        loans[loanID].status = TellerCommon.LoanStatus.Closed;
        loans[loanID].liquidated = true;

        uint256 collateralInTokens = _convertWeiToToken(loanCollateral);

        // the caller gets the collateral from the loan
        _payOutCollateral(loanID, loanCollateral, msg.sender);

        uint256 tokenPayment = collateralInTokens
            .mul(settings.getPlatformSettingValue(LIQUIDATE_ETH_PRICE_SETTING))
            .div(TEN_THOUSAND);
        // the liquidator pays x% of the collateral price
        lendingPool.liquidationPayment(tokenPayment, msg.sender);

        emit LoanLiquidated(
            loanID,
            loans[loanID].loanTerms.borrower,
            msg.sender,
            loanCollateral,
            tokenPayment
        );
    }

    /**
        @notice Get collateral infomation of a specific loan
        @param loanID of the loan to get info for
        @return uint256 Collateral needed
        @return uint256 Collaternal needed in Lending tokens
        @return uint256 Collateral needed in Collateral tokens (wei)
        @return bool If more collateral is needed or not
     */
    function getCollateralInfo(uint256 loanID)
        external
        view
        returns (
            uint256 collateral,
            uint256 collateralNeededLendingTokens,
            uint256 collateralNeededCollateralTokens,
            bool moreCollateralRequired
        )
    {
        return _getCollateralInfo(loanID);
    }

    /**
        @notice Updates the current price oracle instance.
        @dev It throws a require error if sender is not allowed.
        @dev It throws a require error if new address is empty (0x0) or not a contract.
        @param newPriceOracle the new price oracle address.
     */
    function setPriceOracle(address newPriceOracle)
        external
        isInitialized()
        whenAllowed(msg.sender)
    {
        // New address must be a contract and not empty
        require(newPriceOracle.isContract(), "ORACLE_MUST_CONTRACT_NOT_EMPTY");
        address oldPriceOracle = address(priceOracle);
        oldPriceOracle.requireNotEqualTo(newPriceOracle, "NEW_ORACLE_MUST_BE_PROVIDED");

        priceOracle = newPriceOracle;

        emit PriceOracleUpdated(msg.sender, oldPriceOracle, newPriceOracle);
    }

    /** Internal Functions */
    /**
        @notice Pays out the collateral for a loan
        @param loanID ID of loan from which collateral is to be paid out
        @param amount Amount of collateral paid out
        @param recipient Account address of the recipient of the collateral
     */
    function _payOutCollateral(uint256 loanID, uint256 amount, address payable recipient)
        internal;

    /**
        @notice Get collateral infomation of a specific loan
        @param loanID of the loan to get info for
        @return uint256 Collateral needed
        @return uint256 Collaternal needed in Lending tokens
        @return uint256 Collateral needed in Collateral tokens (wei)
        @return bool If more collateral is needed or not
     */
    function _getCollateralInfo(uint256 loanID)
        internal
        view
        returns (
            uint256 collateral,
            uint256 collateralNeededLendingTokens,
            uint256 collateralNeededCollateralTokens,
            bool moreCollateralRequired
        )
    {
        collateral = loans[loanID].collateral;
        (
            collateralNeededLendingTokens,
            collateralNeededCollateralTokens
        ) = _getCollateralNeededInfo(
            _getTotalOwed(loanID),
            loans[loanID].loanTerms.collateralRatio
        );
        moreCollateralRequired = collateralNeededCollateralTokens > collateral;
    }

    /**
       @notice Get information on the collateral needed for the loan
       @param totalOwed Total amount owed for the loan
       @param collateralRatio Collateral ratio set in the loan terms
       @return uint256 Collaternal needed in Lending tokens
       @return uint256 Collateral needed in Collateral tokens (wei)
     */
    function _getCollateralNeededInfo(uint256 totalOwed, uint256 collateralRatio)
        internal
        view
        returns (
            uint256 collateralNeededLendingTokens,
            uint256 collateralNeededCollateralTokens
        )
    {
        // Get collateral needed in lending tokens.
        uint256 collateralNeededToken = _getCollateralNeededInTokens(
            totalOwed,
            collateralRatio
        );
        // Convert collateral (in lending tokens) into collateral tokens.
        return (collateralNeededToken, _convertTokenToWei(collateralNeededToken));
    }

    /**
        @notice Initializes the current contract instance setting the required parameters.
        @param priceOracleAddress Contract address of the price oracle
        @param lendingPoolAddress Contract address of the lending pool
        @param loanTermsConsensusAddress Contract adddress for loan term consensus
        @param settingsAddress Contract address for the configuration of the platform
        @param marketsAddress Contract address to store market data.
        @param atmSettingsAddress Contract address to get ATM settings data.
     */
    function _initialize(
        address priceOracleAddress,
        address lendingPoolAddress,
        address loanTermsConsensusAddress,
        address settingsAddress,
        address marketsAddress,
        address atmSettingsAddress
    ) internal isNotInitialized() {
        priceOracleAddress.requireNotEmpty("PROVIDE_ORACLE_ADDRESS");
        lendingPoolAddress.requireNotEmpty("PROVIDE_LENDINGPOOL_ADDRESS");
        loanTermsConsensusAddress.requireNotEmpty("PROVIDED_LOAN_TERMS_ADDRESS");
        atmSettingsAddress.requireNotEmpty("PROVIDED_ATM_SETTINGS_ADDRESS");

        _initialize(settingsAddress, marketsAddress);

        priceOracle = priceOracleAddress;
        lendingPool = LendingPoolInterface(lendingPoolAddress);
        loanTermsConsensus = LoanTermsConsensusInterface(loanTermsConsensusAddress);
        atmSettings = IATMSettings(atmSettingsAddress);
    }

    /**
        @notice Pays collateral in for the associated loan
        @param loanID The ID of the loan the collateral is for
        @param amount The amount of collateral to be paid
     */
    function _payInCollateral(uint256 loanID, uint256 amount) internal {
        totalCollateral = totalCollateral.add(amount);
        loans[loanID].collateral = loans[loanID].collateral.add(amount);
        loans[loanID].lastCollateralIn = now;
    }

    /**
        @notice Make a payment towards the prinicial and interest for a specified loan
        @param loanID The ID of the loan the payment is for
        @param toPay The amount of tokens to pay to the loan
     */
    function _payLoan(uint256 loanID, uint256 toPay) internal {
        if (toPay > loans[loanID].principalOwed) {
            uint256 leftToPay = toPay;
            leftToPay = leftToPay.sub(loans[loanID].principalOwed);
            loans[loanID].principalOwed = 0;
            loans[loanID].interestOwed = loans[loanID].interestOwed.sub(leftToPay);
        } else {
            loans[loanID].principalOwed = loans[loanID].principalOwed.sub(toPay);
        }
    }

    /**
        @notice Returns the total owed amount remaining for a specified loan
        @param loanID The ID of the loan to be queried
        @return uint256 The total amount owed remaining
     */
    function _getTotalOwed(uint256 loanID) internal view returns (uint256) {
        return loans[loanID].interestOwed.add(loans[loanID].principalOwed);
    }

    /**
        @notice Returns the value of collateral
        @param loanAmount The total amount of the loan for which collateral is needed
        @param collateralRatio Collateral ratio set in the loan terms
        @return uint256 The amount of collateral needed in lending tokens (not wei)
     */
    function _getCollateralNeededInTokens(uint256 loanAmount, uint256 collateralRatio)
        internal
        pure
        returns (uint256)
    {
        return loanAmount.mul(collateralRatio).div(TEN_THOUSAND);
    }

    /**
        @notice Converts the collateral tokens to lending tokens
        @param weiAmount The amount of wei to be converted
        @return uint256 The value the collateal tokens (wei) in lending tokens (not wei)
     */
    function _convertWeiToToken(uint256 weiAmount) internal view returns (uint256) {
        // wei amount / lending token price in wei * the lending token decimals.
        uint256 aWholeLendingToken = ERC20(lendingPool.lendingToken()).getAWholeToken();
        uint256 oneLendingTokenPriceWei = uint256(
            PairAggregatorInterface(priceOracle).getLatestAnswer()
        );
        uint256 tokenValue = weiAmount.mul(aWholeLendingToken).div(
            oneLendingTokenPriceWei
        );
        return tokenValue;
    }

    /**
        @notice Converts the lending token to collareal tokens
        @param tokenAmount The amount in lending tokens (not wei) to be converted
        @return uint256 The value of lending tokens (not wei) in collateral tokens (wei)
     */
    function _convertTokenToWei(uint256 tokenAmount) internal view returns (uint256) {
        // tokenAmount is in token units, chainlink price is in whole tokens
        // token amount in tokens * lending token price in wei / the lending token decimals.
        uint256 aWholeLendingToken = ERC20(lendingPool.lendingToken()).getAWholeToken();
        uint256 oneLendingTokenPriceWei = uint256(
            PairAggregatorInterface(priceOracle).getLatestAnswer()
        );
        uint256 weiValue = tokenAmount.mul(oneLendingTokenPriceWei).div(
            aWholeLendingToken
        );
        return weiValue;
    }

    /**
        @notice Returns the current loan ID and increments it by 1
        @return uint256 The current loan ID before incrementing
     */
    function getAndIncrementLoanID() internal returns (uint256 newLoanID) {
        newLoanID = loanIDCounter;
        loanIDCounter += 1;
    }

    /**
        @notice Creates a loan with the loan request
        @param loanID The ID of the loan
        @param request Loan request as per the struct of the Teller platform
        @param interestRate Interest rate set in the loan terms
        @param collateralRatio Collateral ratio set in the loan terms
        @param maxLoanAmount Maximum loan amount that can be taken out, set in the loan terms
        @return memory TellerCommon.Loan Loan struct as per the Teller platform
     */
    function createLoan(
        uint256 loanID,
        TellerCommon.LoanRequest memory request,
        uint256 interestRate,
        uint256 collateralRatio,
        uint256 maxLoanAmount
    ) internal view returns (TellerCommon.Loan memory) {
        uint256 termsExpiry = now.add(
            settings.getPlatformSettingValue(TERMS_EXPIRY_TIME_SETTING)
        );
        return
            TellerCommon.Loan({
                id: loanID,
                loanTerms: TellerCommon.LoanTerms({
                    borrower: request.borrower,
                    recipient: request.recipient,
                    interestRate: interestRate,
                    collateralRatio: collateralRatio,
                    maxLoanAmount: maxLoanAmount,
                    duration: request.duration
                }),
                termsExpiry: termsExpiry,
                loanStartTime: 0,
                collateral: 0,
                lastCollateralIn: 0,
                principalOwed: 0,
                interestOwed: 0,
                borrowedAmount: 0,
                status: TellerCommon.LoanStatus.TermsSet,
                liquidated: false
            });
    }

    function _emitLoanTermsSetAndCollateralDepositedEventsIfApplicable(
        uint256 loanID,
        TellerCommon.LoanRequest memory request,
        uint256 interestRate,
        uint256 collateralRatio,
        uint256 maxLoanAmount,
        uint256 depositedAmount
    ) internal {
        emit LoanTermsSet(
            loanID,
            request.borrower,
            request.recipient,
            interestRate,
            collateralRatio,
            maxLoanAmount,
            request.duration,
            loans[loanID].termsExpiry
        );
        if (depositedAmount > 0) {
            emit CollateralDeposited(loanID, request.borrower, depositedAmount);
        }
    }

    /**
        @notice It validates whether supply to debt (StD) ratio is valid including the loan amount.
        @param newLoanAmount the new loan amount to consider o the StD ratio.
        @return true if the ratio is valid. Otherwise it returns false.
     */
    function _isSupplyToDebtRatioValid(uint256 newLoanAmount)
        internal
        view
        returns (bool)
    {
        address atmAddressForMarket = atmSettings.getATMForMarket(
            lendingPool.lendingToken(),
            collateralToken
        );
        require(atmAddressForMarket != address(0x0), "ATM_NOT_FOUND_FOR_MARKET");
        uint256 supplyToDebtMarketLimit = IATMGovernance(atmAddressForMarket)
            .getGeneralSetting(SUPPLY_TO_DEBT_ATM_SETTING);
        uint256 currentSupplyToDebtMarket = markets.getSupplyToDebtFor(
            lendingPool.lendingToken(),
            collateralToken,
            newLoanAmount
        );
        return currentSupplyToDebtMarket <= supplyToDebtMarketLimit;
    }
}

contract EtherCollateralLoans is LoansBase {
    /**
     * @notice Deposit collateral into a loan
     * @param borrower The address of the loan borrower.
     * @param loanID The ID of the loan the collateral is for
     */
    function depositCollateral(address borrower, uint256 loanID, uint256 amount)
        external
        payable
        loanActiveOrSet(loanID)
        isInitialized()
        whenNotPaused()
        whenLendingPoolNotPaused(address(lendingPool))
    {
        require(
            loans[loanID].loanTerms.borrower == borrower,
            "BORROWER_LOAN_ID_MISMATCH"
        );
        require(msg.value == amount, "INCORRECT_ETH_AMOUNT");
        require(msg.value > 0, "CANNOT_DEPOSIT_ZERO");

        // Update the contract total and the loan collateral total
        _payInCollateral(loanID, amount);

        emit CollateralDeposited(loanID, borrower, amount);
    }

    /**
        @notice Creates a loan with the loan request and terms
        @param request Struct of the protocol loan request
        @param responses List of structs of the protocol loan responses
        @param collateralAmount Amount of collateral required for the loan
     */
    function createLoanWithTerms(
        TellerCommon.LoanRequest calldata request,
        TellerCommon.LoanResponse[] calldata responses,
        uint256 collateralAmount
    )
        external
        payable
        isInitialized()
        whenNotPaused()
        isBorrower(request.borrower)
        withValidLoanRequest(request)
    {
        require(msg.value == collateralAmount, "INCORRECT_ETH_AMOUNT");

        uint256 loanID = getAndIncrementLoanID();
        (
            uint256 interestRate,
            uint256 collateralRatio,
            uint256 maxLoanAmount
        ) = loanTermsConsensus.processRequest(request, responses);

        loans[loanID] = createLoan(
            loanID,
            request,
            interestRate,
            collateralRatio,
            maxLoanAmount
        );

        if (msg.value > 0) {
            // Update collateral, totalCollateral, and lastCollateralIn
            _payInCollateral(loanID, msg.value);
        }

        borrowerLoans[request.borrower].push(loanID);

        _emitLoanTermsSetAndCollateralDepositedEventsIfApplicable(
            loanID,
            request,
            interestRate,
            collateralRatio,
            maxLoanAmount,
            msg.value
        );
    }

    /**
        @notice Initializes the current contract instance setting the required parameters
        @param priceOracleAddress Contract address of the price oracle
        @param lendingPoolAddress Contract address of the lending pool
        @param loanTermsConsensusAddress Contract adddress for loan term consensus
        @param settingsAddress Contract address for the configuration of the platform
        @param marketsAddress Contract address to store the market data.
        @param atmSettingsAddress Contract address to get ATM settings data.
     */
    function initialize(
        address priceOracleAddress,
        address lendingPoolAddress,
        address loanTermsConsensusAddress,
        address settingsAddress,
        address marketsAddress,
        address atmSettingsAddress
    ) external isNotInitialized() {
        _initialize(
            priceOracleAddress,
            lendingPoolAddress,
            loanTermsConsensusAddress,
            settingsAddress,
            marketsAddress,
            atmSettingsAddress
        );

        collateralToken = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    }

    /** Internal Functions */
    /**
        @notice Pays out collateral for the associated loan
        @param loanID The ID of the loan the collateral is for
        @param amount The amount of collateral to be paid
     */
    function _payOutCollateral(uint256 loanID, uint256 amount, address payable recipient)
        internal
    {
        totalCollateral = totalCollateral.sub(amount);
        loans[loanID].collateral = loans[loanID].collateral.sub(amount);
        recipient.transfer(amount);
    }
}

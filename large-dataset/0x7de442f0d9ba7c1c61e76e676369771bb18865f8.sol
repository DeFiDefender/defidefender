pragma solidity 0.5.17;
pragma experimental ABIEncoderV2;


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

interface LendersInterface {
    /**
        @notice It tracks the interest amount for a recipient/lender.
        @param recipient address.
        @param amount to track.
        @return the interest amount to withdraw.
     */
    function withdrawInterest(address recipient, uint256 amount)
        external
        returns (uint256);

    /**
        @notice It sets the accrued interest for a lender.
        @param request interest request sent by the lender.
        @param responses node responses to get a consensus value for the interest.
     */
    function setAccruedInterest(
        TellerCommon.InterestRequest calldata request,
        TellerCommon.InterestResponse[] calldata responses
    ) external;

    /**
        @notice This event is emitted when an accrued interest is updated.
        @param lender address.
        @param totalNotWithdrawn total amount not withdrawn by the lender.
        @param totalAccruedInterest total accrued interest amount.
     */
    event AccruedInterestUpdated(
        address indexed lender,
        uint256 totalNotWithdrawn,
        uint256 totalAccruedInterest
    );

    /**
        @notice This event is emitted when a lender withdraws an accrued interest amount.
        @param recipient lender address.
        @param amount withdrawn.
     */
    event AccruedInterestWithdrawn(address indexed recipient, uint256 amount);
}

interface InterestConsensusInterface {
    /**
        @notice This event is emitted when an interest response is submitted or processed.
        @param signer node signer
        @param lender address.
        @param requestNonce request nonce.
        @param endTime request end time.
        @param interest value in  the node response.
     */
    event InterestSubmitted(
        address indexed signer,
        address indexed lender,
        uint256 requestNonce,
        uint256 endTime,
        uint256 interest
    );

    /**
        @notice This event is emitted when an interest value is accepted as consensus.
        @param lender address.
        @param requestNonce request nonce.
        @param endTime request end time.
        @param interest consensus interest value.
     */
    event InterestAccepted(
        address indexed lender,
        uint256 requestNonce,
        uint256 endTime,
        uint256 interest
    );

    /**
        @notice It processes all the node responses for a request in order to get a consensus value.
        @param request the interest request sent by the lender.
        @param responses all node responses to process.
        @return the consensus interest.
     */
    function processRequest(
        TellerCommon.InterestRequest calldata request,
        TellerCommon.InterestResponse[] calldata responses
    ) external returns (uint256);
}

contract Lenders is Base, LendersInterface {
    using AddressLib for address;
    using SafeMath for uint256;

    /* State Variables */

    address public lendingPool;
    InterestConsensusInterface public interestConsensus;

    address public tToken;

    // The total interest that has not yet been withdrawn by a lender
    mapping(address => TellerCommon.AccruedInterest) public accruedInterest;

    /** Modifiers */

    /**
        @notice It checks sender is the tToken address.
     */
    modifier isTToken() {
        require(_areAddressesEqual(tToken, msg.sender), "SENDER_ISNT_TTOKEN");
        _;
    }

    /**
        @notice It checks sender is the lending pool address.
     */
    modifier isLendingPool() {
        require(_areAddressesEqual(lendingPool, msg.sender), "SENDER_ISNT_LENDING_POOL");
        _;
    }

    /**
        @notice It checks an address is not empty.
     */
    modifier isValid(address anAddress) {
        anAddress.requireNotEmpty("ADDRESS_IS_REQUIRED");
        _;
    }

    /* Constructor */

    /** External Functions */

    /**
        @notice It sets the accrued interest for a lender based on the node responses.
        @param request interest request sent by the lender.
        @param responses all node responses to get a consensus value for the accrued interest.
     */
    function setAccruedInterest(
        TellerCommon.InterestRequest calldata request,
        TellerCommon.InterestResponse[] calldata responses
    ) external isInitialized() whenNotPaused() whenLendingPoolNotPaused(lendingPool) {
        require(
            accruedInterest[request.lender].timeLastAccrued == 0 ||
                accruedInterest[request.lender].timeLastAccrued == request.startTime,
            "GAP_IN_INTEREST_ACCRUAL"
        );
        require(request.endTime > request.startTime, "INVALID_INTERVAL");
        require(request.requestTime >= request.endTime, "INVALID_REQUEST");

        uint256 amount = interestConsensus.processRequest(request, responses);

        accruedInterest[request.lender].totalAccruedInterest = accruedInterest[request
            .lender]
            .totalAccruedInterest
            .add(amount);

        accruedInterest[request.lender].totalNotWithdrawn = accruedInterest[request
            .lender]
            .totalNotWithdrawn
            .add(amount);

        accruedInterest[request.lender].timeLastAccrued = request.endTime;

        emit AccruedInterestUpdated(
            request.lender,
            accruedInterest[request.lender].totalNotWithdrawn,
            accruedInterest[request.lender].totalAccruedInterest
        );
    }

    /**
        @notice It tracks the interest amount for a recipient/lender.
        @param recipient address.
        @param amount to track.
        @return the interest amount to withdraw.
     */
    function withdrawInterest(address recipient, uint256 amount)
        external
        isLendingPool()
        isValid(recipient)
        isInitialized()
        returns (uint256)
    {
        require(amount > 0, "CANNOT_WITHDRAW_ZERO");
        require(
            accruedInterest[recipient].totalNotWithdrawn >= amount,
            "AMOUNT_EXCEEDS_AVAILABLE_AMOUNT"
        );

        accruedInterest[recipient].totalNotWithdrawn = accruedInterest[recipient]
            .totalNotWithdrawn
            .sub(amount);

        emit AccruedInterestWithdrawn(recipient, amount);

        return amount;
    }

    /**
        @notice It initializes this contract instance.
        @param tTokenAddress tToken contract address.
        @param lendingPoolAddress lending pool contract address.
        @param interestConsensusAddress interest consensus contract address.
        @param settingAddress settings contract address.
        @param marketsAddress markets contract address.
     */
    function initialize(
        address tTokenAddress,
        address lendingPoolAddress,
        address interestConsensusAddress,
        address settingAddress,
        address marketsAddress
    ) external isNotInitialized() {
        tTokenAddress.requireNotEmpty("TTOKEN_MUST_BE_PROVIDED");
        lendingPoolAddress.requireNotEmpty("LENDING_POOL_MUST_BE_PROVIDED");
        interestConsensusAddress.requireNotEmpty("CONSENSUS_MUST_BE_PROVIDED");

        _initialize(settingAddress, marketsAddress);

        tToken = tTokenAddress;
        lendingPool = lendingPoolAddress;
        interestConsensus = InterestConsensusInterface(interestConsensusAddress);
    }

    /** Internal Functions */

    /**
        @notice It verifies if both param addresses are equal or not.
        @param leftAddress address to compare.
        @param rightAddress address to compare.
        @return true if both addresses are equal. Otherwise it returns false.
     */
    function _areAddressesEqual(address leftAddress, address rightAddress)
        internal
        view
        returns (bool)
    {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return leftAddress.isEqualTo(rightAddress);
    }

    /** Private Functions */
}

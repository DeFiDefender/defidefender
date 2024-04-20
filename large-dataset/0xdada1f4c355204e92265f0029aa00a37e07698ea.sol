pragma solidity 0.5.17;
pragma experimental ABIEncoderV2;


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

contract ATMSettings is IATMSettings {
    using Address for address;
    /** Constants */

    address internal constant ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    /* State Variables */

    SettingsInterface public settings;

    /**
        @notice It represents a mapping to identify whether a ATM is paused or not.

        i.e.: address(ATM) => true or false.
     */
    mapping(address => bool) public atmPaused;

    /**
        @notice It represents a mapping to identify the ATM used in a given market.
        @notice A market is defined by a borrowed token and a collateral token.

        i.e.: address(DAI) => address(ETH) => address(ATM Teller)
     */
    mapping(address => mapping(address => address)) public marketToAtm;

    /** Modifiers */

    /**
        @notice It checks whether sender address has the pauser role or not.
        @dev It throws a require error if sender hasn't the pauser role.
     */
    modifier withPauserRole() {
        require(settings.hasPauserRole(msg.sender), "SENDER_HASNT_PAUSER_ROLE");
        _;
    }

    /* Constructor */

    constructor(address settingsAddress) public {
        require(settingsAddress != address(0x0), "SETTINGS_MUST_BE_PROVIDED");

        settings = SettingsInterface(settingsAddress);
    }

    /** External Functions */

    /**
        @notice It pauses a given ATM.
        @param atmAddress ATM address to pause.
     */
    function pauseATM(address atmAddress) external withPauserRole() {
        require(settings.isPaused() == false, "PLATFORM_IS_ALREADY_PAUSED");
        require(atmPaused[atmAddress] == false, "ATM_IS_ALREADY_PAUSED");

        atmPaused[atmAddress] = true;

        emit ATMPaused(atmAddress, msg.sender);
    }

    /**
        @notice It unpauses a given ATM.
        @param atmAddress ATM address to unpause.
     */
    function unpauseATM(address atmAddress) external withPauserRole() {
        require(settings.isPaused() == false, "PLATFORM_IS_PAUSED");
        require(atmPaused[atmAddress] == true, "ATM_IS_NOT_PAUSED");

        atmPaused[atmAddress] = false;

        emit ATMUnpaused(msg.sender, atmAddress);
    }

    /**
        @notice Gets whether an ATM is paused (or the platform is paused) or not.
        @param atmAddress ATM address to test.
        @return true if ATM is paused. Otherwise it returns false.
     */
    function isATMPaused(address atmAddress) external view returns (bool) {
        return settings.isPaused() || atmPaused[atmAddress];
    }

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
    ) external withPauserRole() {
        require(borrowedToken.isContract() == true, "BORROWED_TOKEN_MUST_BE_CONTRACT");
        require(
            collateralToken == ETH_ADDRESS || collateralToken.isContract() == true,
            "COLL_TOKEN_MUST_BE_CONTRACT"
        );
        require(
            marketToAtm[borrowedToken][collateralToken] == address(0x0),
            "ATM_TO_MARKET_ALREADY_EXIST"
        );

        marketToAtm[borrowedToken][collateralToken] = atmAddress;

        emit MarketToAtmSet(borrowedToken, collateralToken, atmAddress, msg.sender);
    }

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
    ) external withPauserRole() {
        require(borrowedToken.isContract() == true, "BORROWED_TOKEN_MUST_BE_CONTRACT");
        require(
            collateralToken == ETH_ADDRESS || collateralToken.isContract() == true,
            "COLL_TOKEN_MUST_BE_CONTRACT"
        );
        require(
            marketToAtm[borrowedToken][collateralToken] != address(0x0),
            "ATM_TO_MARKET_NOT_EXIST"
        );
        require(
            marketToAtm[borrowedToken][collateralToken] != newAtmAddress,
            "PROVIDE_NEW_ATM_FOR_MARKET"
        );

        address oldAtm = marketToAtm[borrowedToken][collateralToken];

        marketToAtm[borrowedToken][collateralToken] = newAtmAddress;

        emit MarketToAtmUpdated(
            borrowedToken,
            collateralToken,
            oldAtm,
            newAtmAddress,
            msg.sender
        );
    }

    /**
        @notice Removes the ATM address for a given market (borrowed token and collateral token).
        @param borrowedToken borrowed token address.
        @param collateralToken collateral token address.
     */
    function removeATMToMarket(address borrowedToken, address collateralToken)
        external
        withPauserRole()
    {
        require(borrowedToken.isContract() == true, "BORROWED_TOKEN_MUST_BE_CONTRACT");
        require(
            collateralToken == ETH_ADDRESS || collateralToken.isContract() == true,
            "COLL_TOKEN_MUST_BE_CONTRACT"
        );
        require(
            marketToAtm[borrowedToken][collateralToken] != address(0x0),
            "ATM_TO_MARKET_NOT_EXIST"
        );

        address oldAtmAddress = marketToAtm[borrowedToken][collateralToken];

        delete marketToAtm[borrowedToken][collateralToken];

        emit MarketToAtmRemoved(
            borrowedToken,
            collateralToken,
            oldAtmAddress,
            msg.sender
        );
    }

    /**
        @notice Gets the ATM configured for a given market (borrowed token and collateral token).
        @param borrowedToken borrowed token address.
        @param collateralToken collateral token address.
        @return the ATM address configured for a given market.
     */
    function getATMForMarket(address borrowedToken, address collateralToken)
        external
        view
        returns (address)
    {
        return marketToAtm[borrowedToken][collateralToken];
    }

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
    ) external view returns (bool) {
        return marketToAtm[borrowedToken][collateralToken] == atmAddress;
    }

    /** Internal functions */

    /** Private functions */
}

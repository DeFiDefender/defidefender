pragma solidity 0.5.17;


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

library AddressArrayLib {
    /**
      @notice It adds an address value to the array.
      @param self current array.
      @param newItem new item to add.
      @return the current array with the new item.
    */
    function add(address[] storage self, address newItem)
        internal
        returns (address[] memory)
    {
        require(newItem != address(0x0), "EMPTY_ADDRESS_NOT_ALLOWED");
        self.push(newItem);
        return self;
    }

    /**
      @notice It removes the value at the given index in an array.
      @param self the current array.
      @param index remove an item in a specific index.
      @return the current array without the item removed.
    */
    function removeAt(address[] storage self, uint256 index)
        internal
        returns (address[] memory)
    {
        if (index >= self.length) return self;

        if (index == self.length - 1) {
            delete self[self.length - 1];
            self.length--;
            return self;
        }

        address temp = self[self.length - 1];
        self[self.length - 1] = self[index];
        self[index] = temp;

        delete self[self.length - 1];
        self.length--;

        return self;
    }

    /**
      @notice It gets the index for a given item.
      @param self the current array.
      @param item to get the index.
      @return indexAt the current index for a given item.
      @return found true if the item was found. Otherwise it returns false.
    */
    function getIndex(address[] storage self, address item)
        internal
        view
        returns (bool found, uint256 indexAt)
    {
        found = false;
        for (indexAt = 0; indexAt < self.length; indexAt++) {
            found = self[indexAt] == item;
            if (found) {
                return (found, indexAt);
            }
        }
        return (found, indexAt);
    }

    /**
      @notice It removes an address value to the array.
      @param self current array.
      @param item the item to remove.
      @return the current array without the removed item.
    */
    function remove(address[] storage self, address item)
        internal
        returns (address[] memory)
    {
        (bool found, uint256 indexAt) = getIndex(self, item);
        if (!found) return self;

        return removeAt(self, indexAt);
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

contract Context is Initializable {
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

contract SignerRole is Initializable, Context {
    using Roles for Roles.Role;

    event SignerAdded(address indexed account);
    event SignerRemoved(address indexed account);

    Roles.Role private _signers;

    function initialize(address sender) public initializer {
        if (!isSigner(sender)) {
            _addSigner(sender);
        }
    }

    modifier onlySigner() {
        require(isSigner(_msgSender()), "SignerRole: caller does not have the Signer role");
        _;
    }

    function isSigner(address account) public view returns (bool) {
        return _signers.has(account);
    }

    function addSigner(address account) public onlySigner {
        _addSigner(account);
    }

    function renounceSigner() public {
        _removeSigner(_msgSender());
    }

    function _addSigner(address account) internal {
        _signers.add(account);
        emit SignerAdded(account);
    }

    function _removeSigner(address account) internal {
        _signers.remove(account);
        emit SignerRemoved(account);
    }

    uint256[50] private ______gap;
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

contract ATMGovernance is SignerRole, IATMGovernance, TInitializable {
    using AddressArrayLib for address[];
    using AddressLib for address;
    using Address for address;

    /* Constants */

    /* State Variables */

    // List of general ATM settings. We don't accept settings equal to zero.
    // Example: supplyToDebtRatio  => 5044 = percentage 50.44
    // Example: supplyToDebtRatio => 1 = percentage 00.01
    mapping(bytes32 => uint256) public generalSettings;

    // List of Market specific Asset settings on this ATM
    // Asset address => Asset setting name => Asset setting value
    // Example 1: USDC address => Risk Premium => 2500 (25%)
    // Example 2: DAI address => Risk Premium => 3500 (35%)
    mapping(address => mapping(bytes32 => uint256)) public assetMarketSettings;

    // List of ATM Data providers per data type
    mapping(uint8 => address[]) public dataProviders;

    // Unique CRA - Credit Risk Algorithm github hash to use in this ATM
    string public cra;

    /* External Functions */

    /**
        @notice Adds a new General Setting to this ATM.
        @param settingName name of the setting to be added.
        @param settingValue value of the setting to be added.
     */
    function addGeneralSetting(bytes32 settingName, uint256 settingValue)
        external
        onlySigner()
    // TODO Do we need to add isInitialized() (the same for other functions)?
    {
        require(settingValue > 0, "GENERAL_SETTING_MUST_BE_POSITIVE");
        require(settingName != "", "GENERAL_SETTING_MUST_BE_PROVIDED");
        require(generalSettings[settingName] == 0, "GENERAL_SETTING_ALREADY_EXISTS");
        generalSettings[settingName] = settingValue;
        emit GeneralSettingAdded(msg.sender, settingName, settingValue);
    }

    /**
        @notice Updates an existing General Setting on this ATM.
        @param settingName name of the setting to be modified.
        @param newValue new value to be set for this settingName. 
     */
    function updateGeneralSetting(bytes32 settingName, uint256 newValue)
        external
        onlySigner()
    {
        require(newValue > 0, "GENERAL_SETTING_MUST_BE_POSITIVE");
        require(settingName != "", "GENERAL_SETTING_MUST_BE_PROVIDED");
        uint256 oldValue = generalSettings[settingName];
        require(oldValue != newValue, "GENERAL_SETTING_EQUAL_PREVIOUS");
        generalSettings[settingName] = newValue;
        emit GeneralSettingUpdated(msg.sender, settingName, oldValue, newValue);
    }

    /**
        @notice Removes a General Setting from this ATM.
        @param settingName name of the setting to be removed.
     */
    function removeGeneralSetting(bytes32 settingName) external onlySigner() {
        require(settingName != "", "GENERAL_SETTING_MUST_BE_PROVIDED");
        require(generalSettings[settingName] > 0, "GENERAL_SETTING_NOT_FOUND");
        uint256 previousValue = generalSettings[settingName];
        delete generalSettings[settingName];
        emit GeneralSettingRemoved(msg.sender, settingName, previousValue);
    }

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
    ) external onlySigner() {
        asset.requireNotEmpty("ASSET_ADDRESS_IS_REQUIRED");
        require(asset.isContract(), "ASSET_MUST_BE_A_CONTRACT");
        require(settingValue > 0, "ASSET_SETTING_MUST_BE_POSITIVE");
        require(settingName != "", "ASSET_SETTING_MUST_BE_PROVIDED");
        require(
            assetMarketSettings[asset][settingName] == 0,
            "ASSET_SETTING_ALREADY_EXISTS"
        );
        assetMarketSettings[asset][settingName] = settingValue;
        emit AssetMarketSettingAdded(msg.sender, asset, settingName, settingValue);
    }

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
    ) external onlySigner() {
        require(settingName != "", "ASSET_SETTING_MUST_BE_PROVIDED");
        require(assetMarketSettings[asset][settingName] > 0, "ASSET_SETTING_NOT_FOUND");
        require(
            newValue != assetMarketSettings[asset][settingName],
            "NEW_VALUE_SAME_AS_OLD"
        );
        uint256 oldValue = assetMarketSettings[asset][settingName];
        assetMarketSettings[asset][settingName] = newValue;
        emit AssetMarketSettingUpdated(
            msg.sender,
            asset,
            settingName,
            oldValue,
            newValue
        );
    }

    /**
        @notice Removes an existing Asset Setting from a specific Market on this ATM.
        @param asset market specific asset address.
        @param settingName name of the setting to be added.
     */
    function removeAssetMarketSetting(address asset, bytes32 settingName)
        external
        onlySigner()
    {
        require(settingName != "", "ASSET_SETTING_MUST_BE_PROVIDED");
        require(assetMarketSettings[asset][settingName] > 0, "ASSET_SETTING_NOT_FOUND");
        uint256 oldValue = assetMarketSettings[asset][settingName];
        delete assetMarketSettings[asset][settingName];
        emit AssetMarketSettingRemoved(msg.sender, asset, settingName, oldValue);
    }

    /**
        @notice Adds a new Data Provider on a specific Data Type array.
            This function would accept duplicated data providers for the same data type.
        @param dataTypeIndex array index for this Data Type.
        @param dataProvider data provider address.
     */
    function addDataProvider(uint8 dataTypeIndex, address dataProvider)
        external
        onlySigner()
    {
        require(dataProvider.isContract(), "DATA_PROVIDER_MUST_BE_A_CONTRACT");
        dataProviders[dataTypeIndex].add(dataProvider);
        uint256 amountDataProviders = dataProviders[dataTypeIndex].length;
        emit DataProviderAdded(
            msg.sender,
            dataTypeIndex,
            amountDataProviders,
            dataProvider
        );
    }

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
    ) external onlySigner() {
        require(
            dataProviders[dataTypeIndex].length > providerIndex,
            "DATA_PROVIDER_OUT_RANGE"
        );
        require(newProvider.isContract(), "DATA_PROVIDER_MUST_BE_A_CONTRACT");
        address oldProvider = dataProviders[dataTypeIndex][providerIndex];
        require(oldProvider != newProvider, "DATA_PROVIDER_SAME_OLD");
        dataProviders[dataTypeIndex][providerIndex] = newProvider;
        emit DataProviderUpdated(
            msg.sender,
            dataTypeIndex,
            providerIndex,
            oldProvider,
            newProvider
        );
    }

    /**
        @notice Removes an existing Data Provider on a specific Data Type array.
        @param dataTypeIndex array index for this Data Type.
        @param dataProviderIndex data provider index.
     */
    function removeDataProvider(uint8 dataTypeIndex, uint256 dataProviderIndex)
        external
        onlySigner()
    {
        require(
            dataProviders[dataTypeIndex].length > dataProviderIndex,
            "DATA_PROVIDER_OUT_RANGE"
        );
        address oldDataProvider = dataProviders[dataTypeIndex][dataProviderIndex];
        dataProviders[dataTypeIndex].removeAt(dataProviderIndex);
        emit DataProviderRemoved(
            msg.sender,
            dataTypeIndex,
            dataProviderIndex,
            oldDataProvider
        );
    }

    /**
        @notice Sets the CRA - Credit Risk Algorithm to be used on this specific ATM.
                CRA is represented by a Github commit hash of the newly proposed algorithm.
        @param _cra Credit Risk Algorithm github commit hash.
     */
    function setCRA(string calldata _cra) external onlySigner() {
        bytes memory tempEmptyStringTest = bytes(_cra);
        require(tempEmptyStringTest.length > 0, "CRA_CANT_BE_EMPTY");
        require(
            keccak256(abi.encodePacked(cra)) != keccak256(abi.encodePacked(_cra)),
            "CRA_SAME_AS_OLD"
        );
        cra = _cra;
        emit CRASet(msg.sender, cra);
    }

    /**
        @notice It initializes this ATM Governance instance.
        @param ownerAddress the owner address for this ATM Governance.
     */
    function initialize(address ownerAddress) public isNotInitialized() {
        SignerRole.initialize(ownerAddress);
        TInitializable._initialize();
    }

    /* External Constant functions */

    /**
        @notice Returns a General Setting value from this ATM.
        @param settingName name of the setting to be returned.
     */
    function getGeneralSetting(bytes32 settingName) external view returns (uint256) {
        return generalSettings[settingName];
    }

    /**
        @notice Returns an existing Asset Setting value from a specific Market on this ATM.
        @param asset market specific asset address.
        @param settingName name of the setting to be returned.
     */
    function getAssetMarketSetting(address asset, bytes32 settingName)
        external
        view
        returns (uint256)
    {
        return assetMarketSettings[asset][settingName];
    }

    /**
        @notice Returns a Data Provider on a specific Data Type array.
        @param dataTypeIndex array index for this Data Type.
        @param dataProviderIndex data provider index number.
     */
    function getDataProvider(uint8 dataTypeIndex, uint256 dataProviderIndex)
        external
        view
        returns (address)
    {
        if (dataProviders[dataTypeIndex].length > dataProviderIndex) {
            return dataProviders[dataTypeIndex][dataProviderIndex];
        }
        return address(0x0);
    }

    /**
        @notice Returns current CRA - Credit Risk Algorithm that is being used on this specific ATM.
                CRA is represented by a Github commit hash of the newly proposed algorithm.
     */
    function getCRA() external view returns (string memory) {
        return cra;
    }
}

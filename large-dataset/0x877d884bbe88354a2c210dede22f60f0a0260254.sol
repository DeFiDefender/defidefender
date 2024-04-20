/**************************************************************************

 *            ____        _                              

 *           / ___|      | |     __ _  _   _   ___  _ __ 

 *          | |    _____ | |    / _` || | | | / _ \\| '__|

 *          | |___|_____|| |___| (_| || |_| ||  __/| |   

 *           \\____|      |_____|\\__,_| \\__, | \\___||_|   

 *                                     |___/             

 * 

 ************************************************************************** *

 *  The MIT License (MIT)

 *

 * Copyright (c) 2016-2019 Cyril Lapinte

 *

 * Permission is hereby granted, free of charge, to any person obtaining

 * a copy of this software and associated documentation files (the

 * "Software"), to deal in the Software without restriction, including

 * without limitation the rights to use, copy, modify, merge, publish,

 * distribute, sublicense, and/or sell copies of the Software, and to

 * permit persons to whom the Software is furnished to do so, subject to

 * the following conditions:

 *

 * The above copyright notice and this permission notice shall be included

 * in all copies or substantial portions of the Software.

 *

 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS

 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF

 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.

 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY

 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,

 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE

 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

 *

 **************************************************************************

 *

 * Flatten Contract: TokenFactory

 *

 * Git Commit:

 * https://github.com/c-layer/contracts/tree/43925ba24cc22f42d0ff7711d0e169e8c2a0e09f

 *

 **************************************************************************/



// File: contracts/util/convert/BytesConvert.sol



pragma solidity >=0.5.0 <0.6.0;





/**

 * @title BytesConvert

 * @dev Convert bytes into different types

 *

 * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>

 *

 * Error Messages:

 *   BC01: source must be a valid 32-bytes length

 *   BC02: source must not be greater than 32-bytes

 **/

library BytesConvert {



  /**

  * @dev toUint256

  */

  function toUint256(bytes memory _source) internal pure returns (uint256 result) {

    require(_source.length == 32, "BC01");

    // solhint-disable-next-line no-inline-assembly

    assembly {

      result := mload(add(_source, 0x20))

    }

  }



  /**

  * @dev toBytes32

  */

  function toBytes32(bytes memory _source) internal pure returns (bytes32 result) {

    require(_source.length <= 32, "BC02");

    // solhint-disable-next-line no-inline-assembly

    assembly {

      result := mload(add(_source, 0x20))

    }

  }

}



// File: contracts/abstract/Factory.sol



pragma solidity >=0.5.0 <0.6.0;







/**

 * @title Factory

 *

 * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>

 *

 * Error messages

 **/

contract Factory {

  using BytesConvert for bytes;



  bytes internal proxyCode_;



  /**

   * @dev proxyCode

   */

  function proxyCode() public view returns (bytes memory) {

    return proxyCode_;

  }



  /**

   * @dev defineProxyCodeInternal

   */

  function defineProxyCodeInternal(address _core, bytes memory _proxyCode)

    internal returns (bool)

  {

    bytes32 coreAddress = abi.encode(_core).toBytes32();

    proxyCode_ = abi.encodePacked(_proxyCode, coreAddress);

    emit ProxyCodeDefined(keccak256(_proxyCode));

    return true;

  }



  /**

   * @dev deployProxyInternal

   */

  function deployProxyInternal()

    internal returns (address address_)

  {

    bytes memory code = proxyCode_;

    assembly {

      address_ := create(0, add(code, 0x20), mload(code))

    }

  }



  event ProxyCodeDefined(bytes32 codeHash);

}



// File: contracts/interface/IOperableCore.sol



pragma solidity >=0.5.0 <0.6.0;





/**

 * @title IOperableCore

 * @dev The Operable contract enable the restrictions of operations to a set of operators

 *

 * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>

 *

 * Error messages

 */

contract IOperableCore {

  bytes32 constant ALL_PRIVILEGES = bytes32("AllPrivileges");

  address constant ALL_PROXIES = address(0x416c6c50726f78696573); // "AllProxies"



  function coreRole(address _address) public view returns (bytes32);

  function proxyRole(address _proxy, address _address) public view returns (bytes32);

  function rolePrivilege(bytes32 _role, bytes4 _privilege) public view returns (bool);

  function roleHasPrivilege(bytes32 _role, bytes4 _privilege) public view returns (bool);

  function hasCorePrivilege(address _address, bytes4 _privilege) public view returns (bool);

  function hasProxyPrivilege(address _address, address _proxy, bytes4 _privilege) public view returns (bool);



  function defineRole(bytes32 _role, bytes4[] memory _privileges) public returns (bool);

  function assignOperators(bytes32 _role, address[] memory _operators) public returns (bool);

  function assignProxyOperators(

    address _proxy, bytes32 _role, address[] memory _operators) public returns (bool);

  function revokeOperators(address[] memory _operators) public returns (bool);



  event RoleDefined(bytes32 role);

  event OperatorAssigned(bytes32 role, address operator);

  event ProxyOperatorAssigned(address proxy, bytes32 role, address operator);

  event OperatorRevoked(address operator);

}



// File: contracts/operable/OperableAsCore.sol



pragma solidity >=0.5.0 <0.6.0;







/**

 * @title TokenFactory

 *

 * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>

 *

 * Error messages

 *   OA01: Missing the core privilege

 *   OA02: Missing the proxy privilege

 **/

contract OperableAsCore {



  IOperableCore public core;



  modifier onlyCoreOperator() {

    require(core.hasCorePrivilege(

      msg.sender, msg.sig), "OA01");

    _;

  }



  modifier onlyProxyOperator(address _proxy) {

    require(core.hasProxyPrivilege(

      msg.sender, _proxy, msg.sig), "OA02");

    _;

  }



  /**

   * @dev constructor

   **/

  constructor(address _core) public {

    core = IOperableCore(_core);

  }



  /**

   * @dev hasCorePrivilege

   */

  function hasCorePrivilege(address _operator, bytes4 _privilege)

    public view returns (bool)

  {

    return core.hasCorePrivilege(_operator, _privilege);

  }



  /**

   * @dev hasProxyPrivilege

   */

  function hasProxyPrivilege(address _operator, address _proxy, bytes4 _privilege)

    public view returns (bool)

  {

    return core.hasProxyPrivilege(_operator, _proxy, _privilege);

  }

}



// File: contracts/interface/IERC20.sol



pragma solidity >=0.5.0 <0.6.0;





/**

 * @title ERC20 interface

 * @dev ERC20 interface

 */

contract IERC20 {



  function name() public view returns (string memory);

  function symbol() public view returns (string memory);

  function decimals() public view returns (uint256);



  function totalSupply() public view returns (uint256);

  function balanceOf(address _owner) public view returns (uint256);

  function allowance(address _owner, address _spender)

    public view returns (uint256);

  function transfer(address _to, uint256 _value) public returns (bool);

  function transferFrom(address _from, address _to, uint256 _value)

    public returns (bool);

  function approve(address _spender, uint256 _value) public returns (bool);

  function increaseApproval(address _spender, uint _addedValue)

    public returns (bool);

  function decreaseApproval(address _spender, uint _subtractedValue)

    public returns (bool);



  event Transfer(address indexed from, address indexed to, uint256 value);

  event Approval(

    address indexed owner,

    address indexed spender,

    uint256 value

  );



}



// File: contracts/interface/IUserRegistry.sol



pragma solidity >=0.5.0 <0.6.0;





/**

 * @title IUserRegistry

 * @dev IUserRegistry interface

 * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>

 **/

contract IUserRegistry {



  event UserRegistered(uint256 indexed userId);

  event AddressAttached(uint256 indexed userId, address address_);

  event AddressDetached(uint256 indexed userId, address address_);



  function registerManyUsersExternal(address[] calldata _addresses, uint256 _validUntilTime)

    external returns (bool);

  function registerManyUsersFullExternal(

    address[] calldata _addresses,

    uint256 _validUntilTime,

    uint256[] calldata _values) external returns (bool);

  function attachManyAddressesExternal(uint256[] calldata _userIds, address[] calldata _addresses)

    external returns (bool);

  function detachManyAddressesExternal(address[] calldata _addresses)

    external returns (bool);

  function suspendManyUsers(uint256[] calldata _userIds) external returns (bool);

  function unsuspendManyUsersExternal(uint256[] calldata _userIds) external returns (bool);

  function updateManyUsersExternal(

    uint256[] calldata _userIds,

    uint256 _validUntilTime,

    bool _suspended) external returns (bool);

  function updateManyUsersExtendedExternal(

    uint256[] calldata _userIds,

    uint256 _key, uint256 _value) external returns (bool);

  function updateManyUsersAllExtendedExternal(

    uint256[] calldata _userIds,

    uint256[] calldata _values) external returns (bool);

  function updateManyUsersFullExternal(

    uint256[] calldata _userIds,

    uint256 _validUntilTime,

    bool _suspended,

    uint256[] calldata _values) external returns (bool);



  function name() public view returns (string memory);

  function currency() public view returns (bytes32);



  function userCount() public view returns (uint256);

  function userId(address _address) public view returns (uint256);

  function validUserId(address _address) public view returns (uint256);

  function validUser(address _address, uint256[] memory _keys)

    public view returns (uint256, uint256[] memory);

  function validity(uint256 _userId) public view returns (uint256, bool);



  function extendedKeys() public view returns (uint256[] memory);

  function extended(uint256 _userId, uint256 _key)

    public view returns (uint256);

  function manyExtended(uint256 _userId, uint256[] memory _key)

    public view returns (uint256[] memory);



  function isAddressValid(address _address) public view returns (bool);

  function isValid(uint256 _userId) public view returns (bool);



  function defineExtendedKeys(uint256[] memory _extendedKeys) public returns (bool);



  function registerUser(address _address, uint256 _validUntilTime)

    public returns (bool);

  function registerUserFull(

    address _address,

    uint256 _validUntilTime,

    uint256[] memory _values) public returns (bool);



  function attachAddress(uint256 _userId, address _address) public returns (bool);

  function detachAddress(address _address) public returns (bool);

  function detachSelf() public returns (bool);

  function detachSelfAddress(address _address) public returns (bool);

  function suspendUser(uint256 _userId) public returns (bool);

  function unsuspendUser(uint256 _userId) public returns (bool);

  function updateUser(uint256 _userId, uint256 _validUntilTime, bool _suspended)

    public returns (bool);

  function updateUserExtended(uint256 _userId, uint256 _key, uint256 _value)

    public returns (bool);

  function updateUserAllExtended(uint256 _userId, uint256[] memory _values)

    public returns (bool);

  function updateUserFull(

    uint256 _userId,

    uint256 _validUntilTime,

    bool _suspended,

    uint256[] memory _values) public returns (bool);

}



// File: contracts/interface/IRatesProvider.sol



pragma solidity >=0.5.0 <0.6.0;





/**

 * @title IRatesProvider

 * @dev IRatesProvider interface

 *

 * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>

 */

contract IRatesProvider {



  function defineRatesExternal(uint256[] calldata _rates) external returns (bool);



  function name() public view returns (string memory);



  function rate(bytes32 _currency) public view returns (uint256);



  function currencies() public view

    returns (bytes32[] memory, uint256[] memory, uint256);

  function rates() public view returns (uint256, uint256[] memory);



  function convert(uint256 _amount, bytes32 _fromCurrency, bytes32 _toCurrency)

    public view returns (uint256);



  function defineCurrencies(

    bytes32[] memory _currencies,

    uint256[] memory _decimals,

    uint256 _rateOffset) public returns (bool);

  function defineRates(uint256[] memory _rates) public returns (bool);



  event RateOffset(uint256 rateOffset);

  event Currencies(bytes32[] currencies, uint256[] decimals);

  event Rate(uint256 at, bytes32 indexed currency, uint256 rate);

}



// File: contracts/interface/IRule.sol



pragma solidity >=0.5.0 <0.6.0;





/**

 * @title IRule

 * @dev IRule interface

 * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>

 **/

interface IRule {

  function isAddressValid(address _address) external view returns (bool);

  function isTransferValid(address _from, address _to, uint256 _amount)

    external view returns (bool);

}



// File: contracts/interface/IClaimable.sol



pragma solidity >=0.5.0 <0.6.0;





/**

 * @title IClaimable

 * @dev IClaimable interface

 * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>

 **/

contract IClaimable {

  function hasClaimsSince(address _address, uint256 at)

    external view returns (bool);

}



// File: contracts/util/math/SafeMath.sol



pragma solidity >=0.5.0 <0.6.0;





/**

 * @title SafeMath

 * @dev Math operations with safety checks that throw on error

 */

library SafeMath {



  /**

  * @dev Multiplies two numbers, throws on overflow.

  */

  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {

    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the

    // benefit is lost if 'b' is also tested.

    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522

    if (a == 0) {

      return 0;

    }



    c = a * b;

    assert(c / a == b);

    return c;

  }



  /**

  * @dev Integer division of two numbers, truncating the quotient.

  */

  function div(uint256 a, uint256 b) internal pure returns (uint256) {

    // assert(b > 0); // Solidity automatically throws when dividing by 0

    // uint256 c = a / b;

    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return a / b;

  }



  /**

  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).

  */

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {

    assert(b <= a);

    return a - b;

  }



  /**

  * @dev Adds two numbers, throws on overflow.

  */

  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {

    c = a + b;

    assert(c >= a);

    return c;

  }

}



// File: contracts/abstract/Storage.sol



pragma solidity >=0.5.0 <0.6.0;





/**

 * @title Storage

 *

 * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>

 *

 * Error messages

 **/

contract Storage {



  mapping(address => address) public proxyDelegates;

  address[] public delegates;

}



// File: contracts/util/governance/Ownable.sol



pragma solidity >=0.5.0 <0.6.0;





/**

 * @title Ownable

 * @dev The Ownable contract has an owner address, and provides basic authorization control

 * functions, this simplifies the implementation of "user permissions".

 *

 * Error messages

 *   OW01: Only accessible as owner

 *   OW02: New owner must be non null

 */

contract Ownable {

  address public owner;



  event OwnershipRenounced(address indexed previousOwner);

  event OwnershipTransferred(

    address indexed previousOwner,

    address indexed newOwner

  );



  /**

   * @dev The Ownable constructor sets the original `owner` of the contract to the sender

   * account.

   */

  constructor() public {

    owner = msg.sender;

  }



  /**

   * @dev Throws if called by any account other than the owner.

   */

  modifier onlyOwner() {

    require(msg.sender == owner, "OW01");

    _;

  }



  /**

   * @dev Allows the current owner to relinquish control of the contract.

   */

  function renounceOwnership() public onlyOwner {

    emit OwnershipRenounced(owner);

    owner = address(0);

  }



  /**

   * @dev Allows the current owner to transfer control of the contract to a newOwner.

   * @param _newOwner The address to transfer ownership to.

   */

  function transferOwnership(address _newOwner) public onlyOwner {

    _transferOwnership(_newOwner);

  }



  /**

   * @dev Transfers control of the contract to a newOwner.

   * @param _newOwner The address to transfer ownership to.

   */

  function _transferOwnership(address _newOwner) internal {

    require(_newOwner != address(0), "OW02");

    emit OwnershipTransferred(owner, _newOwner);

    owner = _newOwner;

  }

}



// File: contracts/operable/OperableStorage.sol



pragma solidity >=0.5.0 <0.6.0;







/**

 * @title OperableStorage

 * @dev The Operable contract enable the restrictions of operations to a set of operators

 *

 * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>

 *

 * Error messages

 */

contract OperableStorage is Ownable, Storage {



  // Hardcoded role granting all - non sysop - privileges

  bytes32 constant internal ALL_PRIVILEGES = bytes32("AllPrivileges");

  address constant internal ALL_PROXIES = address(0x416c6c50726f78696573); // "AllProxies"



  struct RoleData {

    mapping(bytes4 => bool) privileges;

  }



  struct OperatorData {

    bytes32 coreRole;

    mapping(address => bytes32) proxyRoles;

  }



  // Mapping address => role

  // Mapping role => bytes4 => bool

  mapping (address => OperatorData) internal operators;

  mapping (bytes32 => RoleData) internal roles;



  /**

   * @dev core role

   * @param _address operator address

   */

  function coreRole(address _address) public view returns (bytes32) {

    return operators[_address].coreRole;

  }



  /**

   * @dev proxy role

   * @param _address operator address

   */

  function proxyRole(address _proxy, address _address)

    public view returns (bytes32)

  {

    return operators[_address].proxyRoles[_proxy];

  }



  /**

   * @dev has role privilege

   * @dev low level access to role privilege

   * @dev ignores ALL_PRIVILEGES role

   */

  function rolePrivilege(bytes32 _role, bytes4 _privilege)

    public view returns (bool)

  {

    return roles[_role].privileges[_privilege];

  }



  /**

   * @dev roleHasPrivilege

   */

  function roleHasPrivilege(bytes32 _role, bytes4 _privilege) public view returns (bool) {

    return (_role == ALL_PRIVILEGES) || roles[_role].privileges[_privilege];

  }



  /**

   * @dev hasCorePrivilege

   * @param _address operator address

   */

  function hasCorePrivilege(address _address, bytes4 _privilege) public view returns (bool) {

    bytes32 role = operators[_address].coreRole;

    return (role == ALL_PRIVILEGES) || roles[role].privileges[_privilege];

  }



  /**

   * @dev hasProxyPrivilege

   * @dev the default proxy role can be set with proxy address(0)

   * @param _address operator address

   */

  function hasProxyPrivilege(address _address, address _proxy, bytes4 _privilege) public view returns (bool) {

    OperatorData storage data = operators[_address];

    bytes32 role = (data.proxyRoles[_proxy] != bytes32(0)) ?

      data.proxyRoles[_proxy] : data.proxyRoles[ALL_PROXIES];

    return (role == ALL_PRIVILEGES) || roles[role].privileges[_privilege];

  }

}



// File: contracts/TokenStorage.sol



pragma solidity >=0.5.0 <0.6.0;

















/**

 * @title Token storage

 * @dev Token storage

 * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>

 */

contract TokenStorage is OperableStorage {

  using SafeMath for uint256;



  enum TransferCode {

    UNKNOWN,

    OK,

    INVALID_SENDER,

    NO_RECIPIENT,

    INSUFFICIENT_TOKENS,

    LOCKED,

    FROZEN,

    RULE,

    LIMITED_RECEPTION

  }



  struct Proof {

    uint256 amount;

    uint64 startAt;

    uint64 endAt;

  }



  struct AuditData {

    uint64 createdAt;

    uint64 lastTransactionAt;

    uint64 lastEmissionAt;

    uint64 lastReceptionAt;

    uint256 cumulatedEmission;

    uint256 cumulatedReception;

  }



  struct AuditStorage {

    mapping (address => bool) selector;



    AuditData sharedData;

    mapping(uint256 => AuditData) userData;

    mapping(address => AuditData) addressData;

  }



  struct Lock {

    uint256 startAt;

    uint256 endAt;

    mapping(address => bool) exceptions;

  }



  struct TokenData {

    string name;

    string symbol;

    uint256 decimals;



    uint256 totalSupply;

    mapping (address => uint256) balances;

    mapping (address => mapping (address => uint256)) allowed;



    bool mintingFinished;



    uint256 allTimeIssued; // potential overflow

    uint256 allTimeRedeemed; // potential overflow

    uint256 allTimeSeized; // potential overflow



    mapping (address => Proof[]) proofs;

    mapping (address => uint256) frozenUntils;



    Lock lock;

    IRule[] rules;

    IClaimable[] claimables;

  }

  mapping (address => TokenData) internal tokens_;

  mapping (address => mapping (uint256 => AuditStorage)) internal audits;



  IUserRegistry internal userRegistry;

  IRatesProvider internal ratesProvider;



  bytes32 internal currency;

  uint256[] internal userKeys;



  string internal name_;



  /**

   * @dev currentTime()

   */

  function currentTime() internal view returns (uint64) {

    // solhint-disable-next-line not-rely-on-time

    return uint64(now);

  }



  event OraclesDefined(

    IUserRegistry userRegistry,

    IRatesProvider ratesProvider,

    bytes32 currency,

    uint256[] userKeys);

  event AuditSelectorDefined(

    address indexed scope, uint256 scopeId, address[] addresses, bool[] values);

  event Issue(address indexed token, uint256 amount);

  event Redeem(address indexed token, uint256 amount);

  event Mint(address indexed token, uint256 amount);

  event MintFinished(address indexed token);

  event ProofCreated(address indexed token, address indexed holder, uint256 proofId);

  event RulesDefined(address indexed token, IRule[] rules);

  event LockDefined(

    address indexed token,

    uint256 startAt,

    uint256 endAt,

    address[] exceptions

  );

  event Seize(address indexed token, address account, uint256 amount);

  event Freeze(address address_, uint256 until);

  event ClaimablesDefined(address indexed token, IClaimable[] claimables);

  event TokenDefined(

    address indexed token,

    uint256 delegateId,

    string name,

    string symbol,

    uint256 decimals);

  event TokenRemoved(address indexed token);

}



// File: contracts/interface/ITokenCore.sol



pragma solidity >=0.5.0 <0.6.0;















/**

 * @title ITokenCore

 *

 * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>

 *

 * Error messages

 **/

contract ITokenCore is IOperableCore {



  function name() public view returns (string memory);

  function oracles() public view returns

    (IUserRegistry, IRatesProvider, bytes32, uint256[] memory);



  function auditSelector(

    address _scope,

    uint256 _scopeId,

    address[] memory _addresses)

    public view returns (bool[] memory);

  function auditShared(

    address _scope,

    uint256 _scopeId) public view returns (

    uint64 createdAt,

    uint64 lastTransactionAt,

    uint64 lastEmissionAt,

    uint64 lastReceptionAt,

    uint256 cumulatedEmission,

    uint256 cumulatedReception);

  function auditUser(

    address _scope,

    uint256 _scopeId,

    uint256 _userId) public view returns (

    uint64 createdAt,

    uint64 lastTransactionAt,

    uint64 lastEmissionAt,

    uint64 lastReceptionAt,

    uint256 cumulatedEmission,

    uint256 cumulatedReception);

  function auditAddress(

    address _scope,

    uint256 _scopeId,

    address _holder) public view returns (

    uint64 createdAt,

    uint64 lastTransactionAt,

    uint64 lastEmissionAt,

    uint64 lastReceptionAt,

    uint256 cumulatedEmission,

    uint256 cumulatedReception);



  /***********  TOKEN DATA   ***********/

  function token(address _token) public view returns (

    bool mintingFinished,

    uint256 allTimeIssued,

    uint256 allTimeRedeemed,

    uint256 allTimeSeized,

    uint256[2] memory lock,

    uint256 freezedUntil,

    IRule[] memory,

    IClaimable[] memory);

  function tokenProofs(address _token, address _holder, uint256 _proofId)

    public view returns (uint256, uint64, uint64);

  function canTransfer(address, address, uint256)

    public returns (uint256);



  /***********  TOKEN ADMIN  ***********/

  function issue(address, uint256)

    public returns (bool);

  function redeem(address, uint256)

    public returns (bool);

  function mint(address, address, uint256)

    public returns (bool);

  function finishMinting(address)

    public returns (bool);

  function mintAtOnce(address, address[] memory, uint256[] memory)

    public returns (bool);

  function seize(address _token, address, uint256)

    public returns (bool);

  function freezeManyAddresses(

    address _token,

    address[] memory _addresses,

    uint256 _until) public returns (bool);

  function createProof(address, address)

    public returns (bool);

  function defineLock(address, uint256, uint256, address[] memory)

    public returns (bool);

  function defineRules(address, IRule[] memory) public returns (bool);

  function defineClaimables(address, IClaimable[] memory) public returns (bool);



  /************  CORE ADMIN  ************/

  function defineToken(

    address _token,

    uint256 _delegateId,

    string memory _name,

    string memory _symbol,

    uint256 _decimals) public returns (bool);

  function removeToken(address _token) public returns (bool);

  function defineOracles(

    IUserRegistry _userRegistry,

    IRatesProvider _ratesProvider,

    uint256[] memory _userKeys) public returns (bool);

  function defineAuditSelector(

    address _scope,

    uint256 _scopeId,

    address[] memory _selectorAddresses,

    bool[] memory _selectorValues) public returns (bool);





  event OraclesDefined(

    IUserRegistry userRegistry,

    IRatesProvider ratesProvider,

    bytes32 currency,

    uint256[] userKeys);

  event AuditSelectorDefined(

    address indexed scope, uint256 scopeId, address[] addresses, bool[] values);

  event Issue(address indexed token, uint256 amount);

  event Redeem(address indexed token, uint256 amount);

  event Mint(address indexed token, uint256 amount);

  event MintFinished(address indexed token);

  event ProofCreated(address indexed token, address holder, uint256 proofId);

  event RulesDefined(address indexed token, IRule[] rules);

  event LockDefined(

    address indexed token,

    uint256 startAt,

    uint256 endAt,

    address[] exceptions

  );

  event Seize(address indexed token, address account, uint256 amount);

  event Freeze(address address_, uint256 until);

  event ClaimablesDefined(address indexed token, IClaimable[] claimables);

  event TokenDefined(

    address indexed token,

    uint256 delegateId,

    string name,

    string symbol,

    uint256 decimals);

  event TokenRemoved(address indexed token);

}



// File: contracts/interface/ITokenFactory.sol



pragma solidity >=0.5.0 <0.6.0;





/**

 * @title TokenFactory

 *

 * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>

 *

 * Error messages

 **/

contract ITokenFactory {



  function hasCoreAccess() public view returns (bool access);



  function defineProxyCode(bytes memory _code) public returns (bool);

  function deployToken(

    uint256 _delegateId,

    string memory _name,

    string memory _symbol,

    uint256 _decimals,

    uint256 _lockEnd,

    address[] memory _vaults,

    uint256[] memory _supplies,

    address[] memory _proxyOperators

  ) public returns (address);

  function reviewToken(address _token,

    address[] memory _auditSelectors) public returns (bool);

  function configureTokensales(address _token,

    address[] memory _tokensales, uint256[] memory _allowances) public returns (bool);

  function updateAllowances(address _token,

    address[] memory _spenders, uint256[] memory _allowances) public returns (bool);



  event TokenDeployed(address token);

  event TokenReviewed(address token);

  event TokensalesConfigured(address token, address[] tokensales);

  event AllowanceUpdated(address token, address spender, uint256 allowance);

}



// File: contracts/TokenFactory.sol



pragma solidity >=0.5.0 <0.6.0;















/**

 * @title TokenFactory

 *

 * @author Cyril Lapinte - <cyril.lapinte@openfiz.com>

 *

 * Error messages

 *   TF01: Required privileges must be granted from the core to the factory

 *   TF02: There must be the same number of vault and supplies

 *   TF03: A proxy code must defined

 *   TF04: Token proxy must deployed

 *   TF05: Token must be defined in the core

 *   TF06: Factory role must be granted on the proxy

 *   TF07: Issuer role must be granted on the proxy

 *   TF08: The rule must be set

 *   TF09: The token must be locked

 *   TF10: Token must be minted

 *   TF11: The selector must be set

 *   TF12: The rule must be removed

 *   TF13: Same number of tokensales and allowances must be provided

 *   TF14: Exceptions must be added to the lock

 *   TF15: Allowances must be lower than the token balance

 *   TF16: Allowance must be successfull

 **/

contract TokenFactory is ITokenFactory, Factory, OperableAsCore {



  bytes4[] private REQUIRED_CORE_PRIVILEGES = [

    bytes4(keccak256("assignProxyOperators(address,bytes32,address[])")),

    bytes4(keccak256("defineToken(address,uint256,string,string,uint256)")),

    bytes4(keccak256("defineAuditSelector(address,uint256,address[],bool[])"))

  ];

  bytes4[] private REQUIRED_PROXY_PRIVILEGES = [

    bytes4(keccak256("mintAtOnce(address,address[],uint256[])")),

    bytes4(keccak256("defineLock(address,uint256,uint256,address[])")),

    bytes4(keccak256("defineRules(address,address[])"))

  ];



  bytes32 constant FACTORY_PROXY_ROLE = bytes32("FactoryProxyRole");

  bytes32 constant ISSUER_PROXY_ROLE = bytes32("IssuerProxyRole");



  /**

   * @dev constructor

   **/

  constructor(address _core) public OperableAsCore(_core) {}



  /**

   * @dev defineProxyCode

   */

  function defineProxyCode(bytes memory _code)

    public onlyCoreOperator returns (bool)

  {

    return defineProxyCodeInternal(address(core), _code);

  }



  /**

   * @dev has core access

   */

  function hasCoreAccess() public view returns (bool access) {

    access = true;

    for (uint256 i=0; i<REQUIRED_CORE_PRIVILEGES.length; i++) {

      access = access && hasCorePrivilege(

        address(this), REQUIRED_CORE_PRIVILEGES[i]);

    }

    for (uint256 i=0; i<REQUIRED_PROXY_PRIVILEGES.length; i++) {

      access = access && core.rolePrivilege(

        FACTORY_PROXY_ROLE, REQUIRED_PROXY_PRIVILEGES[i]);

    }

  }



  /**

   * @dev deploy token

   */

  function deployToken(

    uint256 _delegateId,

    string memory _name,

    string memory _symbol,

    uint256 _decimals,

    uint256 _lockEnd,

    address[] memory _vaults,

    uint256[] memory _supplies,

    address[] memory _proxyOperators

  ) public returns (address) {

    require(hasCoreAccess(), "TF01");

    require(_vaults.length == _supplies.length, "TF02");

    require(proxyCode_.length != 0, "TF03");



    // 1- Creating a proxy

    address token = deployProxyInternal();

    require(token != address(0), "TF04");



    // 2- Defining the token in the core

    ITokenCore tokenCore = ITokenCore(address(core));

    require(tokenCore.defineToken(

      token, _delegateId, _name, _symbol, _decimals), "TF05");



    // 3- Assign roles

    address[] memory factoryAddress = new address[](1);

    factoryAddress[0] = address(this);

    require(tokenCore.assignProxyOperators(token, FACTORY_PROXY_ROLE, factoryAddress), "TF06");

    require(tokenCore.assignProxyOperators(token, ISSUER_PROXY_ROLE, _proxyOperators), "TF07");



    // 4- Define rules

    // Token is locked for review by core operators

    // Removing the token factory from the rules will unlocked the token

    IRule[] memory factoryRules = new IRule[](1);

    factoryRules[0] = IRule(address(this));

    require(tokenCore.defineRules(token, factoryRules), "TF08");



    // 5- Locking the token

    if (_lockEnd > now) {

      require(tokenCore.defineLock(token, 0, _lockEnd, new address[](0)), "TF09");

    }



    // 6- Minting the token

    require(tokenCore.mintAtOnce(token, _vaults, _supplies), "TF10");



    emit TokenDeployed(token);

    return token;

  }



  /**

   * @dev reviewToken

   */

  function reviewToken(address _token, address[] memory _auditSelectors)

    public onlyCoreOperator returns (bool)

  {

    require(hasCoreAccess(), "TF01");



    bool[] memory values = new bool[](_auditSelectors.length);

    for(uint256 i=0; i < values.length; i++) {

      values[i] = true;

    }



    ITokenCore tokenCore = ITokenCore(address(core));

    require(tokenCore.defineAuditSelector(address(core), 0, _auditSelectors, values), "TF11");

    require(tokenCore.defineRules(_token, new IRule[](0)), "TF12");

    emit TokenReviewed(_token);

    return true;

  }



  /**

   * @dev configureTokensales

   */

  function configureTokensales(address _token,

    address[] memory _tokensales, uint256[] memory _allowances)

    public onlyProxyOperator(_token) returns (bool)

  {

    require(hasCoreAccess(), "TF01");

    require(_tokensales.length == _allowances.length, "TF13");



    ITokenCore tokenCore = ITokenCore(address(core));

    (,,,,uint256[2] memory schedule,,,) = tokenCore.token(_token);

    require(tokenCore.defineLock(_token, schedule[0], schedule[1], _tokensales), "TF14");



    updateAllowances(_token, _tokensales, _allowances);

    emit TokensalesConfigured(_token, _tokensales);

  }



  /**

   * @dev updateAllowance

   */

  function updateAllowances(address _token, address[] memory _spenders, uint256[] memory _allowances)

    public onlyProxyOperator(_token) returns (bool)

  {

    uint256 balance = IERC20(_token).balanceOf(address(this));

    for(uint256 i=0; i < _spenders.length; i++) {

      require(_allowances[i] <= balance, "TF15");

      require(IERC20(_token).approve(_spenders[i], _allowances[i]), "TF16");

      emit AllowanceUpdated(_token, _spenders[i], _allowances[i]);

    }

  }

}

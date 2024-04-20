// File: @openzeppelin/contracts/GSN/Context.sol



pragma solidity ^0.5.0;



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

contract Context {

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



// File: @openzeppelin/contracts/ownership/Ownable.sol



pragma solidity ^0.5.0;



/**

 * @dev Contract module which provides a basic access control mechanism, where

 * there is an account (an owner) that can be granted exclusive access to

 * specific functions.

 *

 * This module is used through inheritance. It will make available the modifier

 * `onlyOwner`, which can be applied to your functions to restrict their use to

 * the owner.

 */

contract Ownable is Context {

    address private _owner;



    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);



    /**

     * @dev Initializes the contract setting the deployer as the initial owner.

     */

    constructor () internal {

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

        require(isOwner(), "Ownable: caller is not the owner");

        _;

    }



    /**

     * @dev Returns true if the caller is the current owner.

     */

    function isOwner() public view returns (bool) {

        return _msgSender() == _owner;

    }



    /**

     * @dev Leaves the contract without owner. It will not be possible to call

     * `onlyOwner` functions anymore. Can only be called by the current owner.

     *

     * NOTE: Renouncing ownership will leave the contract without an owner,

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



// File: contracts/managment/Constants.sol



pragma solidity 0.5.17;





contract Constants {

    // Permissions bit constants

    uint256 public constant CAN_MINT_TOKENS = 0;

    uint256 public constant CAN_BURN_TOKENS = 1;

    uint256 public constant CAN_UPDATE_STATE = 2;

    uint256 public constant CAN_LOCK_TOKENS = 3;

    uint256 public constant CAN_UPDATE_PRICE = 4;

    uint256 public constant CAN_INTERACT_WITH_ALLOCATOR = 5;

    uint256 public constant CAN_SET_ALLOCATOR_MAX_SUPPLY = 6;

    uint256 public constant CAN_PAUSE_TOKENS = 7;

    uint256 public constant ECLIUDED_ADDRESSES = 8;

    uint256 public constant WHITELISTED = 9;

    uint256 public constant SIGNERS = 10;

    uint256 public constant EXTERNAL_CONTRIBUTORS = 11;

    uint256 public constant CAN_SEE_BALANCE = 12;

    uint256 public constant CAN_CANCEL_TRANSACTION = 13;

    uint256 public constant CAN_ALLOCATE_REFERRAL_TOKENS = 14;

    uint256 public constant CAN_SET_REFERRAL_MAX_SUPPLY = 15;

    uint256 public constant MANUAL_TOKENS_ALLOCATION = 16;

    uint256 public constant CAN_SET_WHITELISTED = 17;



    // Contract Registry keys

    uint256 public constant CONTRACT_TOKEN = 1;

    uint256 public constant CONTRACT_PRICING = 2;

    uint256 public constant CONTRACT_CROWDSALE = 3;

    uint256 public constant CONTRACT_ALLOCATOR = 4;

    uint256 public constant CONTRACT_AGENT = 5;

    uint256 public constant CONTRACT_FORWARDER = 6;

    uint256 public constant CONTRACT_REFERRAL = 7;

    uint256 public constant CONTRACT_STATS = 8;

    uint256 public constant CONTRACT_LOCKUP = 9;



    uint256 public constant YEAR_IN_SECONDS = 31556952;

    uint256 public constant SIX_MONTHS =  15778476;

    uint256 public constant MONTH_IN_SECONDS = 2629746;



    string public constant ERROR_ACCESS_DENIED = "ERROR_ACCESS_DENIED";

    string public constant ERROR_WRONG_AMOUNT = "ERROR_WRONG_AMOUNT";

    string public constant ERROR_NO_CONTRACT = "ERROR_NO_CONTRACT";

    string public constant ERROR_NOT_AVAILABLE = "ERROR_NOT_AVAILABLE";

}



// File: contracts/managment/Management.sol



pragma solidity 0.5.17;









contract Management is Ownable, Constants {



    // Contract Registry

    mapping (uint256 => address payable) public contractRegistry;



    // Permissions

    mapping (address => mapping(uint256 => bool)) public permissions;



    event PermissionsSet(

        address subject, 

        uint256 permission, 

        bool value

    );



    event ContractRegistered(

        uint256 key,

        address source,

        address target

    );



    function setPermission(

        address _address, 

        uint256 _permission, 

        bool _value

    )

        public

        onlyOwner

    {

        permissions[_address][_permission] = _value;

        emit PermissionsSet(_address, _permission, _value);

    }



    function registerContract(

        uint256 _key, 

        address payable _target

    ) 

        public 

        onlyOwner 

    {

        contractRegistry[_key] = _target;

        emit ContractRegistered(_key, address(0), _target);

    }



    function setWhitelisted(

        address _address,

        bool _value

    )

        public

    {

        require(

            permissions[msg.sender][CAN_SET_WHITELISTED] == true,

            ERROR_ACCESS_DENIED

        );



        permissions[_address][WHITELISTED] = _value;



        emit PermissionsSet(_address, WHITELISTED, _value);

    }



}

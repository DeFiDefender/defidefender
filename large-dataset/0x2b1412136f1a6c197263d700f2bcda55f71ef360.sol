// File: contracts/library/Owned.sol



pragma solidity ^0.4.23;



contract Owned {

    address public owner;

    address public newOwner;



    event OwnerUpdate(address _prevOwner, address _newOwner);



    constructor () public { owner = msg.sender; }



    modifier ownerOnly {

        assert(msg.sender == owner);

        _;

    }



    function setOwner(address _newOwner) public ownerOnly {

        require(_newOwner != owner && _newOwner != address(0));

        emit OwnerUpdate(owner, _newOwner);

        owner = _newOwner;

        newOwner = address(0);

    }



    function transferOwnership(address _newOwner) public ownerOnly {

        require(_newOwner != owner);

        newOwner = _newOwner;

    }



    function acceptOwnership() public {

        require(msg.sender == newOwner);

        emit OwnerUpdate(owner, newOwner);

        owner = newOwner;

        newOwner = 0x0;

    }

}



// File: contracts/library/Utils.sol



pragma solidity ^0.4.23;



/*

    Utilities & Common Modifiers

*/

contract Utils {



    // verifies that an amount is greater than zero

    modifier greaterThanZero(uint256 _amount) {

        require(_amount > 0);

        _;

    }



    // validates an address - currently only checks that it isn't null

    modifier validAddress(address _address) {

        require(_address != 0x0);

        _;

    }



    // verifies that the address is different than this contract address

    modifier notThis(address _address) {

        require(_address != address(this));

        _;

    }



    // Overflow protected math functions



    /**

        @dev returns the sum of _x and _y, asserts if the calculation overflows



        @param _x   value 1

        @param _y   value 2



        @return sum

    */

    function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {

        uint256 z = _x + _y;

        assert(z >= _x);

        return z;

    }



    /**

        @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number



        @param _x   minuend

        @param _y   subtrahend



        @return difference

    */

    function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {

        assert(_x >= _y);

        return _x - _y;

    }



    /**

        @dev returns the product of multiplying _x by _y, asserts if the calculation overflows



        @param _x   factor 1

        @param _y   factor 2



        @return product

    */

    function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {

        uint256 z = _x * _y;

        assert(_x == 0 || z / _x == _y);

        return z;

    }

}



// File: contracts/interfaces/IContractRegistry.sol



pragma solidity ^0.4.23;



/*

    Contract Registry interface

*/

contract IContractRegistry {

    function addressOf(bytes32 _contractName) public view returns (address);

}



// File: contracts/ContractIds.sol



pragma solidity ^0.4.23;



contract ContractIds {

    bytes32 public constant STABLE_TOKEN = "StableToken";

    bytes32 public constant COLLATERAL_TOKEN = "CollateralToken";



    bytes32 public constant PEGUSD_TOKEN = "PEGUSD";



    bytes32 public constant VAULT_A = "VaultA";

    bytes32 public constant VAULT_B = "VaultB";



    bytes32 public constant PEG_LOGIC = "PegLogic";

    bytes32 public constant PEG_LOGIC_ACTIONS = "LogicActions";

    bytes32 public constant AUCTION_ACTIONS = "AuctionActions";



    bytes32 public constant PEG_SETTINGS = "PegSettings";

    bytes32 public constant ORACLE = "Oracle";

    bytes32 public constant FEE_RECIPIENT = "StabilityFeeRecipient";

}



// File: contracts/ContractRegistry.sol



pragma solidity ^0.4.23;











/**

    Contract Registry

    The contract registry keeps contract addresses by name.

    The owner can update contract addresses so that a contract name always points to the latest version

    of the given contract.

    Other contracts can query the registry to get updated addresses instead of depending on specific

    addresses.

    Note that contract names are limited to 32 bytes UTF8 encoded ASCII strings to optimize gas costs

*/

contract ContractRegistry is IContractRegistry, Owned, Utils, ContractIds {

    struct RegistryItem {

        address contractAddress;    // contract address

        uint256 nameIndex;          // index of the item in the list of contract names

    }



    mapping (bytes32 => RegistryItem) private items;    // name -> RegistryItem mapping

    string[] public contractNames;                      // list of all registered contract names



    // triggered when an address pointed to by a contract name is modified

    event AddressUpdate(bytes32 indexed _contractName, address _contractAddress);



    /**

        @dev returns the number of items in the registry

        @return number of items

    */

    function itemCount() public view returns (uint256) {

        return contractNames.length;

    }



    /**

        @dev returns the address associated with the given contract name

        @param _contractName    contract name

        @return contract address

    */

    function addressOf(bytes32 _contractName) public view returns (address) {

        return items[_contractName].contractAddress;

    }



    /**

        @dev registers a new address for the contract name in the registry

        @param _contractName     contract name

        @param _contractAddress  contract address

    */

    function registerAddress(bytes32 _contractName, address _contractAddress)

        public

        ownerOnly

        validAddress(_contractAddress)

    {

        require(_contractName.length > 0); // validate input



        if (items[_contractName].contractAddress == address(0)) {

            // add the contract name to the name list

            uint256 i = contractNames.push(bytes32ToString(_contractName));

            // update the item's index in the list

            items[_contractName].nameIndex = i - 1;

        }



        // update the address in the registry

        items[_contractName].contractAddress = _contractAddress;



        // dispatch the address update event

        emit AddressUpdate(_contractName, _contractAddress);

    }



    /**

        @dev removes an existing contract address from the registry

        @param _contractName contract name

    */

    function unregisterAddress(bytes32 _contractName) public ownerOnly {

        require(_contractName.length > 0); // validate input

        require(items[_contractName].contractAddress != address(0));



        // remove the address from the registry

        items[_contractName].contractAddress = address(0);



        // if there are multiple items in the registry, move the last element to the deleted element's position

        // and modify last element's registryItem.nameIndex in the items collection to point to the right position in contractNames

        if (contractNames.length > 1) {

            string memory lastContractNameString = contractNames[contractNames.length - 1];

            uint256 unregisterIndex = items[_contractName].nameIndex;



            contractNames[unregisterIndex] = lastContractNameString;

            bytes32 lastContractName = stringToBytes32(lastContractNameString);

            RegistryItem storage registryItem = items[lastContractName];

            registryItem.nameIndex = unregisterIndex;

        }



        // remove the last element from the name list

        contractNames.length--;

        // zero the deleted element's index

        items[_contractName].nameIndex = 0;



        // dispatch the address update event

        emit AddressUpdate(_contractName, address(0));

    }



    /**

        @dev utility, converts bytes32 to a string

        note that the bytes32 argument is assumed to be UTF8 encoded ASCII string

        @return string representation of the given bytes32 argument

    */

    function bytes32ToString(bytes32 _bytes) private pure returns (string) {

        bytes memory byteArray = new bytes(32);

        for (uint256 i; i < 32; i++) {

            byteArray[i] = _bytes[i];

        }



        return string(byteArray);

    }



    // @dev utility, converts string to bytes32

    function stringToBytes32(string _string) private pure returns (bytes32) {

        bytes32 result;

        assembly {

            result := mload(add(_string,32))

        }

        return result;

    }

}

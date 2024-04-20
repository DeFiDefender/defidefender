pragma solidity ^0.5.9;



contract SafeMath {

    function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {

        if (a == 0) {

            return 0;

        }

        uint256 c = a * b;

        assert(c / a == b);

        return c;

    }



    function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a / b;

        return c;

    }



    function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {

        assert(b <= a);

        return a - b;

    }



    function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a + b;

        assert(c >= a);

        return c;

    }



    function safeExponent(uint256 a, uint256 b)

        internal

        pure

        returns (uint256)

    {

        uint256 result;

        assembly {

            result := exp(a, b)

        }

        return result;

    }



    // calculates a^(1/n) to dp decimal places

    // maxIts bounds the number of iterations performed

    function nthRoot(

        uint256 _a,

        uint256 _n,

        uint256 _dp,

        uint256 _maxIts

    ) internal pure returns (uint256) {

        assert(_n > 1);



        // The scale factor is a crude way to turn everything into integer calcs.

        // Actually do (a * (10 ^ ((dp + 1) * n))) ^ (1/n)

        // We calculate to one extra dp and round at the end

        uint256 one = 10**(1 + _dp);

        uint256 a0 = one**_n * _a;



        // Initial guess: 1.0

        uint256 xNew = one;

        uint256 x;



        uint256 iter = 0;

        while (xNew != x && iter < _maxIts) {

            x = xNew;

            uint256 t0 = x**(_n - 1);

            if (x * t0 > a0) {

                xNew = x - (x - a0 / t0) / _n;

            } else {

                xNew = x + (a0 / t0 - x) / _n;

            }

            ++iter;

        }



        // Round to nearest in the last dp.

        return (xNew + 5) / 10;

    }

}



contract Constant {

    string constant ERR_CONTRACT_SELF_ADDRESS = "ERR_CONTRACT_SELF_ADDRESS";



    string constant ERR_ZERO_ADDRESS = "ERR_ZERO_ADDRESS";



    string constant ERR_NOT_OWN_ADDRESS = "ERR_NOT_OWN_ADDRESS";



    string constant ERR_VALUE_IS_ZERO = "ERR_VALUE_IS_ZERO";



    string constant ERR_SAME_ADDRESS = "ERR_SAME_ADDRESS";



    string constant ERR_AUTHORIZED_ADDRESS_ONLY = "ERR_AUTHORIZED_ADDRESS_ONLY";



    modifier notOwnAddress(address _which) {

        require(msg.sender != _which, ERR_NOT_OWN_ADDRESS);

        _;

    }



    // validates an address is not zero

    modifier notZeroAddress(address _which) {

        require(_which != address(0), ERR_ZERO_ADDRESS);

        _;

    }



    // verifies that the address is different than this contract address

    modifier notThisAddress(address _which) {

        require(_which != address(this), ERR_CONTRACT_SELF_ADDRESS);

        _;

    }



    modifier notZeroValue(uint256 _value) {

        require(_value > 0, ERR_VALUE_IS_ZERO);

        _;

    }

}



contract Ownable is Constant {

    address public primaryOwner = address(0);



    address public authorityAddress = address(0);



    address public systemAddress = address(0);



    address public newAuthorityAddress = address(0);



    event OwnershipTransferred(

        string ownerType,

        address indexed previousOwner,

        address indexed newOwner

    );

    event AuthorityAddressChnageCall(

        address indexed previousOwner,

        address indexed newOwner

    );



    /**

     * @dev The Ownable constructor sets the `primaryOwner` and `systemAddress` and '_multisigAddress'

     * account.

     */

    constructor(address _systemAddress, address _authorityAddress)

        public

        notZeroAddress(_systemAddress)

    {

        require(msg.sender != _systemAddress, ERR_SAME_ADDRESS);



        require(_systemAddress != _authorityAddress, ERR_SAME_ADDRESS);



        require(msg.sender != _authorityAddress, ERR_SAME_ADDRESS);



        primaryOwner = msg.sender;



        systemAddress = _systemAddress;



        authorityAddress = _authorityAddress;

    }



    modifier onlyOwner() {

        require(msg.sender == primaryOwner, ERR_AUTHORIZED_ADDRESS_ONLY);

        _;

    }



    modifier onlySystem() {

        require(msg.sender == systemAddress, ERR_AUTHORIZED_ADDRESS_ONLY);

        _;

    }



    modifier onlyOneOfOnwer() {

        require(

            msg.sender == primaryOwner || msg.sender == systemAddress,

            ERR_AUTHORIZED_ADDRESS_ONLY

        );

        _;

    }



    modifier onlyAuthorized() {

        require(msg.sender == authorityAddress, ERR_AUTHORIZED_ADDRESS_ONLY);

        _;

    }



    /**

     * @dev change primary ownership

     * @param _which The address to which is new owner address

     */

    function changePrimaryOwner(address _which)

        public

        onlyAuthorized()

        notZeroAddress(_which)

        returns (bool)

    {

        require(

            _which != systemAddress &&

                _which != authorityAddress &&

                _which != primaryOwner,

            ERR_SAME_ADDRESS

        );



        emit OwnershipTransferred("PRIMARY_OWNER", primaryOwner, _which);



        primaryOwner = _which;



        return true;

    }



    /**

     * @dev change system address

     * @param _which The address to which is new system address

     */

    function changeSystemAddress(address _which)

        public

        onlyAuthorized()

        notThisAddress(_which)

        notZeroAddress(_which)

        returns (bool)

    {

        require(

            _which != systemAddress &&

                _which != authorityAddress &&

                _which != primaryOwner,

            ERR_SAME_ADDRESS

        );

        emit OwnershipTransferred("SYSTEM_ADDRESS", systemAddress, _which);

        systemAddress = _which;

        return true;

    }



    /**

     * @dev change system address

     * @param _which The address to which is new Authority address

     */

    function changeAuthorityAddress(address _which)

        public

        onlyAuthorized()

        notZeroAddress(_which)

        returns (bool)

    {

        require(

            _which != systemAddress &&

                _which != authorityAddress &&

                _which != primaryOwner,

            ERR_SAME_ADDRESS

        );

        newAuthorityAddress = _which;

        return true;

    }



    function acceptAuthorityAddress() public returns (bool) {

        require(msg.sender == newAuthorityAddress, ERR_AUTHORIZED_ADDRESS_ONLY);

        emit OwnershipTransferred(

            "AUTHORITY_ADDRESS",

            authorityAddress,

            newAuthorityAddress

        );

        authorityAddress = newAuthorityAddress;

        newAuthorityAddress = address(0);

        return true;

    }

}

interface Icontract {

    function updateAddresses() external returns (bool);

}



contract AuctionRegistery is Ownable, SafeMath {

    // store all contract address with bytes32 representation

    mapping(bytes32 => address payable) private contractAddress;



    // store contractIndex

    mapping(bytes32 => uint256) public contractIndex;



    // store all contract Name

    string[] public contracts;



    event ContractAddressUpdated(

        bytes32 indexed _contractName,

        address _contractAddressFrom,

        address _contractAddressTo

    );



    constructor(address _systemAddess, address _multisig)

        public

        Ownable(_systemAddess, _multisig)

    {}



    function totalContracts() external view returns (uint256) {

        return contracts.length;

    }



    function getAddressOf(bytes32 _contractName)

        external

        view

        returns (address payable)

    {

        return contractAddress[_contractName];

    }



    /**

     * @dev add new contarct address to the registery

     * @return bool

     */

    function registerContractAddress(

        bytes32 _contractName,

        address payable _contractAddress

    )

        external

        onlyOneOfOnwer()

        notZeroValue(_contractName.length)

        notZeroAddress(_contractAddress)

        returns (bool)

    {

        require(contractAddress[_contractName] == address(0), ERR_SAME_ADDRESS);



        contractAddress[_contractName] = _contractAddress;



        contractIndex[_contractName] = contracts.length;



        contracts.push(bytes32ToString(_contractName));



        emit ContractAddressUpdated(

            _contractName,

            address(0),

            _contractAddress

        );



        return true;

    }



    /**

     * @dev update contarct address to the registery

     * note that we dont need to update contractAddress index we just update contract addres only

     * @return bool

     */

    function updateContractAddress(

        bytes32 _contractName,

        address payable _contractAddress

    )

        external

        onlyAuthorized()

        notZeroValue(_contractName.length)

        notZeroAddress(_contractAddress)

        notZeroAddress(contractAddress[_contractName])

        returns (bool)

    {

        emit ContractAddressUpdated(

            _contractName,

            contractAddress[_contractName],

            _contractAddress

        );

        contractAddress[_contractName] = _contractAddress;



        return true;

    }



    /**

     * @dev remove contarct address to the registery

     * @return bool

     */

    function removeContractAddress(bytes32 _contractName)

        external

        onlyAuthorized()

        notZeroValue(_contractName.length)

        notZeroAddress(contractAddress[_contractName])

        returns (bool)

    {

        uint256 _contractIndex = contractIndex[_contractName];



        string memory lastContract = contracts[safeSub(contracts.length, 1)];



        bytes32 lastContractBytes = stringToBytes32(lastContract);



        contracts[_contractIndex] = lastContract;



        contractIndex[lastContractBytes] = _contractIndex;



        emit ContractAddressUpdated(

            _contractName,

            contractAddress[_contractName],

            address(0)

        );



        delete contractAddress[_contractName];



        delete contractIndex[_contractName];



        contracts.pop();



        return true;

    }



    /**

     * @dev utility, converts bytes32 to a string

     * note that the bytes32 argument is assumed to be UTF8 encoded ASCII string

     *

     * @return string representation of the given bytes32 argument

     */

    function bytes32ToString(bytes32 _bytes)

        public

        pure

        returns (string memory)

    {

        bytes memory byteArray = new bytes(32);

        for (uint256 i; i < 32; i++) {

            byteArray[i] = _bytes[i];

        }



        return string(byteArray);

    }



    /**

     * @dev utility, converts string to bytes32

     * note that the bytes32 argument is assumed to be UTF8 encoded ASCII string

     *

     * @return string representation of the given bytes32 argument

     */

    function stringToBytes32(string memory _string)

        public

        pure

        returns (bytes32)

    {

        bytes32 result;

        assembly {

            result := mload(add(_string, 32))

        }

        return result;

    }

}

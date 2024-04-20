// File: contracts/library/SafeMath.sol



pragma solidity ^0.4.23;



library SafeMath {

    function plus(uint256 _a, uint256 _b) internal pure returns (uint256) {

        uint256 c = _a + _b;

        assert(c >= _a);

        return c;

    }



    function plus(int256 _a, int256 _b) internal pure returns (int256) {

        int256 c = _a + _b;

        assert((_b >= 0 && c >= _a) || (_b < 0 && c < _a));

        return c;

    }



    function minus(uint256 _a, uint256 _b) internal pure returns (uint256) {

        assert(_a >= _b);

        return _a - _b;

    }



    function minus(int256 _a, int256 _b) internal pure returns (int256) {

        int256 c = _a - _b;

        assert((_b >= 0 && c <= _a) || (_b < 0 && c > _a));

        return c;

    }



    function times(uint256 _a, uint256 _b) internal pure returns (uint256) {

        if (_a == 0) {

            return 0;

        }

        uint256 c = _a * _b;

        assert(c / _a == _b);

        return c;

    }



    function times(int256 _a, int256 _b) internal pure returns (int256) {

        if (_a == 0) {

            return 0;

        }

        int256 c = _a * _b;

        assert(c / _a == _b);

        return c;

    }



    function toInt256(uint256 _a) internal pure returns (int256) {

        assert(_a <= 2 ** 255);

        return int256(_a);

    }



    function toUint256(int256 _a) internal pure returns (uint256) {

        assert(_a >= 0);

        return uint256(_a);

    }



    function div(uint256 _a, uint256 _b) internal pure returns (uint256) {

        return _a / _b;

    }



    function div(int256 _a, int256 _b) internal pure returns (int256) {

        return _a / _b;

    }

}



// File: contracts/interfaces/IERC20Token.sol



pragma solidity ^0.4.23;



/*

    ERC20 Standard Token interface

*/

contract IERC20Token {

    // these functions aren't abstract since the compiler emits automatically generated getter functions as external

    function name() public view returns (string) {}

    function symbol() public view returns (string) {}

    function decimals() public view returns (uint8) {}

    function totalSupply() public view returns (uint256) {}

    function balanceOf(address _owner) public view returns (uint256) { _owner; }

    function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }



    function transfer(address _to, uint256 _value) public returns (bool success);

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);

    function approve(address _spender, uint256 _value) public returns (bool success);

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



// File: contracts/library/ERC20Token.sol



pragma solidity ^0.4.23;









/**

    ERC20 Standard Token implementation

*/

contract ERC20Token is IERC20Token, Utils {

    using SafeMath for uint256;





    string public standard = 'Token 0.1';

    string public name = '';

    string public symbol = '';

    uint8 public decimals = 0;

    uint256 public totalSupply = 0;

    mapping (address => uint256) public balanceOf;

    mapping (address => mapping (address => uint256)) public allowance;



    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);



    /**

        @dev constructor



        @param _name        token name

        @param _symbol      token symbol

        @param _decimals    decimal points, for display purposes

    */

    constructor(string _name, string _symbol, uint8 _decimals) public {

        require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input



        name = _name;

        symbol = _symbol;

        decimals = _decimals;

    }



    /**

        @dev send coins

        throws on any error rather then return a false flag to minimize user errors



        @param _to      target address

        @param _value   transfer amount



        @return true if the transfer was successful, false if it wasn't

    */

    function transfer(address _to, uint256 _value)

        public

        validAddress(_to)

        returns (bool success)

    {

        balanceOf[msg.sender] = balanceOf[msg.sender].minus(_value);

        balanceOf[_to] = balanceOf[_to].plus(_value);

        emit Transfer(msg.sender, _to, _value);

        return true;

    }



    /**

        @dev an account/contract attempts to get the coins

        throws on any error rather then return a false flag to minimize user errors



        @param _from    source address

        @param _to      target address

        @param _value   transfer amount



        @return true if the transfer was successful, false if it wasn't

    */

    function transferFrom(address _from, address _to, uint256 _value)

        public

        validAddress(_from)

        validAddress(_to)

        returns (bool success)

    {

        allowance[_from][msg.sender] = allowance[_from][msg.sender].minus(_value);

        balanceOf[_from] = balanceOf[_from].minus(_value);

        balanceOf[_to] = balanceOf[_to].plus(_value);

        emit Transfer(_from, _to, _value);

        return true;

    }



    /**

        @dev allow another account/contract to spend some tokens on your behalf

        throws on any error rather then return a false flag to minimize user errors



        also, to minimize the risk of the approve/transferFrom attack vector

        (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice

        in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value



        @param _spender approved address

        @param _value   allowance amount



        @return true if the approval was successful, false if it wasn't

    */

    function approve(address _spender, uint256 _value)

        public

        validAddress(_spender)

        returns (bool success)

    {

        // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal

        require(_value == 0 || allowance[msg.sender][_spender] == 0);



        allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;

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



// File: contracts/interfaces/IPegSettings.sol



pragma solidity ^0.4.23;





contract IPegSettings {



    function authorized(address _address) public view returns (bool) { _address; }



    function authorize(address _address, bool _auth) public;

    function transferERC20Token(IERC20Token _token, address _to, uint256 _amount) public;



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



// File: contracts/StableToken.sol



pragma solidity ^0.4.23;













contract StableToken is ERC20Token, ContractIds {

    using SafeMath for uint256;



    bool public transfersEnabled = true;

    IContractRegistry public registry;



    event NewSmartToken(address _token);

    event Issuance(uint256 _amount);

    event Destruction(uint256 _amount);



    constructor(string _name, string _symbol, uint8 _decimals, IContractRegistry _registry)

        public

        ERC20Token(_name, _symbol, _decimals)

    {

        registry = _registry;

        emit NewSmartToken(address(this));

    }



    modifier transfersAllowed {

        assert(transfersEnabled);

        _;

    }



    modifier authOnly() {

        IPegSettings pegSettings = IPegSettings(registry.addressOf(ContractIds.PEG_SETTINGS));

        require(pegSettings.authorized(msg.sender));

        _;

    }



    function setName(string _name) public authOnly {

        require(bytes(_name).length > 0); // validate input

        name = _name;

    }



    function setSymbol(string _symbol) public authOnly {

        require(bytes(_symbol).length > 0); // validate input

        symbol = _symbol;

    }



    function disableTransfers(bool _disable) public authOnly {

        transfersEnabled = !_disable;

    }



    function issue(address _to, uint256 _amount) public authOnly validAddress(_to) notThis(_to) {

        totalSupply = totalSupply.plus(_amount);

        balanceOf[_to] = balanceOf[_to].plus(_amount);



        emit Issuance(_amount);

        emit Transfer(this, _to, _amount);

    }



    function destroy(address _from, uint256 _amount) public authOnly {

        balanceOf[_from] = balanceOf[_from].minus(_amount);

        totalSupply = totalSupply.minus(_amount);

        emit Transfer(_from, this, _amount);

        emit Destruction(_amount);

    }



    function transfer(address _to, uint256 _value) public transfersAllowed returns (bool success) {

        assert(super.transfer(_to, _value));

        return true;

    }



    function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool success) {

        assert(super.transferFrom(_from, _to, _value));

        return true;

    }



    function transferERC20Token(IERC20Token _token, address _to, uint256 _amount) validAddress(_to) public {

        IPegSettings pegSettings = IPegSettings(registry.addressOf(ContractIds.PEG_SETTINGS));

        require(pegSettings.authorized(msg.sender));

        _token.transfer(_to, _amount);

    }

}

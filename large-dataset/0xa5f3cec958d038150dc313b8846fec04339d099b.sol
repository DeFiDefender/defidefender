pragma solidity ^0.4.8;

/*



Vim Victory Fund

www.s-routes.com



*/



/* \u0420\u043e\u0434\u0438\u0442\u0435\u043b\u044c\u0441\u043a\u0438\u0439 \u043a\u043e\u043d\u0442\u0440\u0430\u043a\u0442 */

contract Owned {



    /* \u0410\u0434\u0440\u0435\u0441 \u0432\u043b\u0430\u0434\u0435\u043b\u044c\u0446\u0430 \u043a\u043e\u043d\u0442\u0440\u0430\u043a\u0442\u0430*/

    address owner;



    /* \u041a\u043e\u043d\u0441\u0442\u0440\u0443\u043a\u0442\u043e\u0440 \u043a\u043e\u043d\u0442\u0440\u0430\u043a\u0442\u0430, \u0432\u044b\u0437\u044b\u0432\u0430\u0435\u0442\u0441\u044f \u043f\u0440\u0438 \u043f\u0435\u0440\u0432\u043e\u043c \u0437\u0430\u043f\u0443\u0441\u043a\u0435 */

    function Owned() {

        owner = msg.sender;

    }



        /* \u0418\u0437\u043c\u0435\u043d\u0438\u0442\u044c \u0432\u043b\u0430\u0434\u0435\u043b\u044c\u0446\u0430 \u043a\u043e\u043d\u0442\u0440\u0430\u043a\u0442\u0430, newOwner - \u0430\u0434\u0440\u0435\u0441 \u043d\u043e\u0432\u043e\u0433\u043e \u0432\u043b\u0430\u0434\u0435\u043b\u044c\u0446\u0430 */

    function changeOwner(address newOwner) onlyowner {

        owner = newOwner;

    }





    /* \u041c\u043e\u0434\u0438\u0444\u0438\u043a\u0430\u0442\u043e\u0440 \u0434\u043b\u044f \u043e\u0433\u0440\u0430\u043d\u0438\u0447\u0435\u043d\u0438\u044f \u0434\u043e\u0441\u0442\u0443\u043f\u0430 \u043a \u0444\u0443\u043d\u043a\u0446\u0438\u044f\u043c \u0442\u043e\u043b\u044c\u043a\u043e \u0434\u043b\u044f \u0432\u043b\u0430\u0434\u0435\u043b\u044c\u0446\u0430 */

    modifier onlyowner() {

        if (msg.sender==owner) _;

    }

}



// \u0410\u0431\u0441\u0442\u0440\u0430\u043a\u0442\u043d\u044b\u0439 \u043a\u043e\u043d\u0442\u0440\u0430\u043a\u0442 \u0434\u043b\u044f \u0442\u043e\u043a\u0435\u043d\u0430 \u0441\u0442\u0430\u043d\u0434\u0430\u0440\u0442\u0430 ERC 20

// https://github.com/ethereum/EIPs/issues/20

contract Token is Owned {



    /// \u041e\u0431\u0449\u0435\u0435 \u043a\u043e\u043b-\u0432\u043e \u0442\u043e\u043a\u0435\u043d\u043e\u0432

    uint256 public totalSupply;



    /// @param _owner \u0430\u0434\u0440\u0435\u0441, \u0441 \u043a\u043e\u0442\u043e\u0440\u043e\u0433\u043e \u0431\u0443\u0434\u0435\u0442 \u043f\u043e\u043b\u0443\u0447\u0435\u043d \u0431\u0430\u043b\u0430\u043d\u0441

    /// @return \u0411\u0430\u043b\u0430\u043d\u0441

    function balanceOf(address _owner) constant returns (uint256 balance);



    /// @notice \u041e\u0442\u043f\u0440\u0430\u0432\u0438\u0442\u044c \u043a\u043e\u043b-\u0432\u043e `_value` \u0442\u043e\u043a\u0435\u043d\u043e\u0432 \u043d\u0430 \u0430\u0434\u0440\u0435\u0441 `_to` \u0441 \u0430\u0434\u0440\u0435\u0441\u0430 `msg.sender`

    /// @param _to \u0410\u0434\u0440\u0435\u0441 \u043f\u043e\u043b\u0443\u0447\u0430\u0442\u0435\u043b\u044f

    /// @param _value \u041a\u043e\u043b-\u0432\u043e \u0442\u043e\u043a\u0435\u043d\u043e\u0432 \u0434\u043b\u044f \u043e\u0442\u043f\u0440\u0430\u0432\u043a\u0438

    /// @return \u0411\u044b\u043b\u0430 \u043b\u0438 \u043e\u0442\u043f\u0440\u0430\u0432\u043a\u0430 \u0443\u0441\u043f\u0435\u0448\u043d\u043e\u0439 \u0438\u043b\u0438 \u043d\u0435\u0442

    function transfer(address _to, uint256 _value) returns (bool success);



    /// @notice \u041e\u0442\u043f\u0440\u0430\u0432\u0438\u0442\u044c \u043a\u043e\u043b-\u0432\u043e `_value` \u0442\u043e\u043a\u0435\u043d\u043e\u0432 \u043d\u0430 \u0430\u0434\u0440\u0435\u0441 `_to` \u0441 \u0430\u0434\u0440\u0435\u0441\u0430 `_from` \u043f\u0440\u0438 \u0443\u0441\u043b\u043e\u0432\u0438\u0438 \u0447\u0442\u043e \u044d\u0442\u043e \u043f\u043e\u0434\u0442\u0432\u0435\u0440\u0436\u0434\u0435\u043d\u043e \u043e\u0442\u043f\u0440\u0430\u0432\u0438\u0442\u0435\u043b\u0435\u043c `_from`

    /// @param _from \u0410\u0434\u0440\u0435\u0441 \u043e\u0442\u043f\u0440\u0430\u0432\u0438\u0442\u0435\u043b\u044f

    /// @param _to The address of the recipient

    /// @param _value The amount of token to be transferred

    /// @return Whether the transfer was successful or not

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);



    /// @notice \u0412\u044b\u0437\u044b\u0432\u0430\u044e\u0449\u0438\u0439 \u0444\u0443\u043d\u043a\u0446\u0438\u0438 `msg.sender` \u043f\u043e\u0434\u0442\u0432\u0435\u0440\u0436\u0434\u0430\u0435\u0442 \u0447\u0442\u043e \u0441 \u0430\u0434\u0440\u0435\u0441\u0430 `_spender` \u0441\u043f\u0438\u0448\u0435\u0442\u0441\u044f `_value` \u0442\u043e\u043a\u0435\u043d\u043e\u0432

    /// @param _spender \u0410\u0434\u0440\u0435\u0441 \u0430\u043a\u043a\u0430\u0443\u043d\u0442\u0430, \u0441 \u043a\u043e\u0442\u043e\u0440\u043e\u0433\u043e \u0432\u043e\u0437\u043c\u043e\u0436\u043d\u043e \u0441\u043f\u0438\u0441\u0430\u0442\u044c \u0442\u043e\u043a\u0435\u043d\u044b

    /// @param _value \u041a\u043e\u043b-\u0432\u043e \u0442\u043e\u043a\u0435\u043d\u043e\u0432 \u043a \u043f\u043e\u0434\u0442\u0432\u0435\u0440\u0436\u0434\u0435\u043d\u0438\u044e \u0434\u043b\u044f \u043e\u0442\u043f\u0440\u0430\u0432\u043a\u0438

    /// @return \u0411\u044b\u043b\u043e \u043b\u0438 \u043f\u043e\u0434\u0442\u0432\u0435\u0440\u0436\u0434\u0435\u043d\u0438\u0435 \u0443\u0441\u043f\u0435\u0448\u043d\u044b\u043c \u0438\u043b\u0438 \u043d\u0435\u0442

    function approve(address _spender, uint256 _value) returns (bool success);



    /// @param _owner \u0410\u0434\u0440\u0435\u0441 \u0430\u043a\u043a\u0430\u0443\u043d\u0442\u0430 \u0432\u043b\u0430\u0434\u0435\u044e\u0449\u0435\u0433\u043e \u0442\u043e\u043a\u0435\u043d\u0430\u043c\u0438

    /// @param _spender \u0410\u0434\u0440\u0435\u0441 \u0430\u043a\u043a\u0430\u0443\u043d\u0442\u0430, \u0441 \u043a\u043e\u0442\u043e\u0440\u043e\u0433\u043e \u0432\u043e\u0437\u043c\u043e\u0436\u043d\u043e \u0441\u043f\u0438\u0441\u0430\u0442\u044c \u0442\u043e\u043a\u0435\u043d\u044b

    /// @return \u041a\u043e\u043b-\u0432\u043e \u043e\u0441\u0442\u0430\u0432\u0448\u0438\u0445\u0441\u044f \u0442\u043e\u043a\u0435\u043d\u043e\u0432 \u0440\u0430\u0437\u0440\u0435\u0448\u0451\u043d\u043d\u044b\u0445 \u0434\u043b\u044f \u043e\u0442\u043f\u0440\u0430\u0432\u043a\u0438

    function allowance(address _owner, address _spender) constant returns (uint256 remaining);



    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

}



/*

\u041a\u043e\u043d\u0442\u0440\u0430\u043a\u0442 \u0440\u0435\u0430\u043b\u0438\u0437\u0443\u0435\u0442 ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20

*/

contract ERC20Token is Token

{



    function transfer(address _to, uint256 _value) returns (bool success)

    {

        //\u041f\u043e-\u0443\u043c\u043e\u043b\u0447\u0430\u043d\u0438\u044e \u043f\u0440\u0435\u0434\u043f\u043e\u043b\u0430\u0433\u0430\u0435\u0442\u0441\u044f, \u0447\u0442\u043e totalSupply \u043d\u0435 \u043c\u043e\u0436\u0435\u0442 \u0431\u044b\u0442\u044c \u0431\u043e\u043b\u044c\u0448\u0435 (2^256 - 1).

        if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {

            balances[msg.sender] -= _value;

            balances[_to] += _value;

            Transfer(msg.sender, _to, _value);

            return true;

        } else { return false; }

    }



    function transferFrom(address _from, address _to, uint256 _value) returns (bool success)

    {

        //\u041f\u043e-\u0443\u043c\u043e\u043b\u0447\u0430\u043d\u0438\u044e \u043f\u0440\u0435\u0434\u043f\u043e\u043b\u0430\u0433\u0430\u0435\u0442\u0441\u044f, \u0447\u0442\u043e totalSupply \u043d\u0435 \u043c\u043e\u0436\u0435\u0442 \u0431\u044b\u0442\u044c \u0431\u043e\u043b\u044c\u0448\u0435 (2^256 - 1).

        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {

            balances[_to] += _value;

            balances[_from] -= _value;

            allowed[_from][msg.sender] -= _value;

            Transfer(_from, _to, _value);

            return true;

        } else { return false; }

    }



    function balanceOf(address _owner) constant returns (uint256 balance)

    {

        return balances[_owner];

    }



    function approve(address _spender, uint256 _value) returns (bool success)

    {

        allowed[msg.sender][_spender] = _value;

        Approval(msg.sender, _spender, _value);

        return true;

    }



    function allowance(address _owner, address _spender) constant returns (uint256 remaining)

    {

      return allowed[_owner][_spender];

    }



    mapping (address => uint256) balances;

    mapping (address => mapping (address => uint256)) allowed;

}



/* \u041e\u0441\u043d\u043e\u0432\u043d\u043e\u0439 \u043a\u043e\u043d\u0442\u0440\u0430\u043a\u0442 \u0442\u043e\u043a\u0435\u043d\u0430, \u043d\u0430\u0441\u043b\u0435\u0434\u0443\u0435\u0442 ERC20Token */

contract Legat is ERC20Token

{

    bool public isTokenSale = false;

    uint256 public price;

    uint256 public limit;



    address walletOut = 0x420d6edab112cf3dcbdd808333e597623094218a;



    function getWalletOut() constant returns (address _to) {

        return walletOut;

    }



    function () external payable  {

        if (isTokenSale == false) {

            throw;

        }



        uint256 tokenAmount = (msg.value  * 1000000000000000000) / price;



        if (balances[owner] >= tokenAmount && balances[msg.sender] + tokenAmount > balances[msg.sender]) {

            if (balances[owner] - tokenAmount < limit) {

                throw;

            }

            balances[owner] -= tokenAmount;

            balances[msg.sender] += tokenAmount;

            Transfer(owner, msg.sender, tokenAmount);

        } else {

            throw;

        }

    }



    function stopSale() onlyowner {

        isTokenSale = false;

    }



    function startSale() onlyowner {

        isTokenSale = true;

    }



    function setPrice(uint256 newPrice) onlyowner {

        price = newPrice;

    }



    function setLimit(uint256 newLimit) onlyowner {

        limit = newLimit;

    }



    function setWallet(address _to) onlyowner {

        walletOut = _to;

    }



    function sendFund() onlyowner {

        walletOut.send(this.balance);

    }



    /* \u041f\u0443\u0431\u043b\u0438\u0447\u043d\u044b\u0435 \u043f\u0435\u0440\u0435\u043c\u0435\u043d\u043d\u044b\u0435 \u0442\u043e\u043a\u0435\u043d\u0430 */

    string public name;                 // \u041d\u0430\u0437\u0432\u0430\u043d\u0438\u0435

    uint8 public decimals;              // \u0421\u043a\u043e\u043b\u044c\u043a\u043e \u0434\u0435\u0441\u044f\u0442\u0438\u0447\u043d\u044b\u0445 \u0437\u043d\u0430\u043a\u043e\u0432

    string public symbol;               // \u0418\u0434\u0435\u043d\u0442\u0438\u0444\u0438\u043a\u0430\u0442\u043e\u0440 (\u0442\u0440\u0435\u0445\u0431\u0443\u043a\u0432\u0435\u043d\u043d\u044b\u0439 \u043e\u0431\u044b\u0447\u043d\u043e)

    string public version = '1.0';      // \u0412\u0435\u0440\u0441\u0438\u044f



    function Legat()

    {

        totalSupply = 12000000000000000000000000000;

        balances[msg.sender] = 12000000000000000000000000000;  // \u041f\u0435\u0440\u0435\u0434\u0430\u0447\u0430 \u0441\u043e\u0437\u0434\u0430\u0442\u0435\u043b\u044e \u0432\u0441\u0435\u0445 \u0432\u044b\u043f\u0443\u0449\u0435\u043d\u043d\u044b\u0445 \u043c\u043e\u043d\u0435\u0442

        name = 'Legat';

        decimals = 18;

        symbol = 'LET';

        price = 1694915254237290;

        limit = 0;

    }



    



    

    /* \u0423\u043d\u0438\u0447\u0442\u043e\u0436\u0430\u0435\u0442 \u0442\u043e\u043a\u0435\u043d\u044b \u043d\u0430 \u0441\u0447\u0435\u0442\u0435 \u0432\u043b\u0430\u0434\u0435\u043b\u044c\u0446\u0430 \u043a\u043e\u043d\u0442\u0440\u0430\u043a\u0442\u0430 */

    function burn(uint256 _value) onlyowner returns (bool success)

    {

        if (balances[msg.sender] < _value) {

            return false;

        }

        totalSupply -= _value;

        balances[msg.sender] -= _value;

        return true;

    }





}

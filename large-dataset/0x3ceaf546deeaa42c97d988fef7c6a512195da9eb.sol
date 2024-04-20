pragma solidity ^0.4.8;

contract ERC20 {

    // token\u603b\u91cf\uff0c\u9ed8\u8ba4\u4f1a\u4e3apublic\u53d8\u91cf\u751f\u6210\u4e00\u4e2agetter\u51fd\u6570\u63a5\u53e3\uff0c\u540d\u79f0\u4e3atotalSupply().

    uint256 public totalSupply;



    /// \u83b7\u53d6\u8d26\u6237_owner\u62e5\u6709token\u7684\u6570\u91cf 

    function balanceOf(address _owner) constant returns (uint256 balance);



    //\u4ece\u6d88\u606f\u53d1\u9001\u8005\u8d26\u6237\u4e2d\u5f80_to\u8d26\u6237\u8f6c\u6570\u91cf\u4e3a_value\u7684token

    function transfer(address _to, uint256 _value) returns (bool success);



    //\u4ece\u8d26\u6237_from\u4e2d\u5f80\u8d26\u6237_to\u8f6c\u6570\u91cf\u4e3a_value\u7684token\uff0c\u4e0eapprove\u65b9\u6cd5\u914d\u5408\u4f7f\u7528

    function transferFrom(address _from, address _to, uint256 _value) returns   

    (bool success);



    //\u6d88\u606f\u53d1\u9001\u8d26\u6237\u8bbe\u7f6e\u8d26\u6237_spender\u80fd\u4ece\u53d1\u9001\u8d26\u6237\u4e2d\u8f6c\u51fa\u6570\u91cf\u4e3a_value\u7684token

    function approve(address _spender, uint256 _value) returns (bool success);



    //\u83b7\u53d6\u8d26\u6237_spender\u53ef\u4ee5\u4ece\u8d26\u6237_owner\u4e2d\u8f6c\u51fatoken\u7684\u6570\u91cf

    function allowance(address _owner, address _spender) constant returns 

    (uint256 remaining);



    //\u53d1\u751f\u8f6c\u8d26\u65f6\u5fc5\u987b\u8981\u89e6\u53d1\u7684\u4e8b\u4ef6 

    event Transfer(address indexed _from, address indexed _to, uint256 _value);



    //\u5f53\u51fd\u6570approve(address _spender, uint256 _value)\u6210\u529f\u6267\u884c\u65f6\u5fc5\u987b\u89e6\u53d1\u7684\u4e8b\u4ef6

    event Approval(address indexed _owner, address indexed _spender, uint256 

    _value);

}



contract StandardToken is ERC20  {

    function transfer(address _to, uint256 _value) returns (bool success) {

        //\u9ed8\u8ba4totalSupply \u4e0d\u4f1a\u8d85\u8fc7\u6700\u5927\u503c (2^256 - 1).

        //\u5982\u679c\u968f\u7740\u65f6\u95f4\u7684\u63a8\u79fb\u5c06\u4f1a\u6709\u65b0\u7684token\u751f\u6210\uff0c\u5219\u53ef\u4ee5\u7528\u4e0b\u9762\u8fd9\u53e5\u907f\u514d\u6ea2\u51fa\u7684\u5f02\u5e38

        require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);

        //require(balances[msg.sender] >= _value);

        balances[msg.sender] -= _value;//\u4ece\u6d88\u606f\u53d1\u9001\u8005\u8d26\u6237\u4e2d\u51cf\u53bbtoken\u6570\u91cf_value

        balances[_to] += _value;//\u5f80\u63a5\u6536\u8d26\u6237\u589e\u52a0token\u6570\u91cf_value

        Transfer(msg.sender, _to, _value);//\u89e6\u53d1\u8f6c\u5e01\u4ea4\u6613\u4e8b\u4ef6

        return true;

    }





    function transferFrom(address _from, address _to, uint256 _value) returns 

    (bool success) {

        require(balances[_from] >= _value && allowed[_from][msg.sender] >= 

         _value && balances[_to] + _value > balances[_to]);

        //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);

        balances[_to] += _value;//\u63a5\u6536\u8d26\u6237\u589e\u52a0token\u6570\u91cf_value

        balances[_from] -= _value; //\u652f\u51fa\u8d26\u6237_from\u51cf\u53bbtoken\u6570\u91cf_value

        allowed[_from][msg.sender] -= _value;//\u6d88\u606f\u53d1\u9001\u8005\u53ef\u4ee5\u4ece\u8d26\u6237_from\u4e2d\u8f6c\u51fa\u7684\u6570\u91cf\u51cf\u5c11_value

        Transfer(_from, _to, _value);//\u89e6\u53d1\u8f6c\u5e01\u4ea4\u6613\u4e8b\u4ef6

        return true;

    }

    function balanceOf(address _owner) constant returns (uint256 balance) {

        return balances[_owner];

    }





    function approve(address _spender, uint256 _value) returns (bool success)   

    {

        require((_value == 0) || (allowed[msg.sender][_spender] == 0));

        allowed[msg.sender][_spender] = _value;

        Approval(msg.sender, _spender, _value);

        return true;

    }





    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {

        return allowed[_owner][_spender];//\u5141\u8bb8_spender\u4ece_owner\u4e2d\u8f6c\u51fa\u7684token\u6570

    }

    mapping (address => uint256) balances;

    mapping (address => mapping (address => uint256)) allowed;

}



contract PPLendingToken is StandardToken { 



    /* Public variables of the token */

    string public name;                   //\u540d\u79f0: eg Simon Bucks

    uint8 public decimals;               //\u6700\u591a\u7684\u5c0f\u6570\u4f4d\u6570\uff0cHow many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.

    string public symbol;               //token\u7b80\u79f0: eg SBX

    string public version = 'H0.1';    //\u7248\u672c



    function PPLendingToken(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) {

        balances[msg.sender] = _initialAmount; // \u521d\u59cbtoken\u6570\u91cf\u7ed9\u4e88\u6d88\u606f\u53d1\u9001\u8005

        totalSupply = _initialAmount;         // \u8bbe\u7f6e\u521d\u59cb\u603b\u91cf

        name = _tokenName;                   // token\u540d\u79f0

        decimals = _decimalUnits;           // \u5c0f\u6570\u4f4d\u6570

        symbol = _tokenSymbol;             // token\u7b80\u79f0

    }



    /* Approves and then calls the receiving contract */

    

    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {

        allowed[msg.sender][_spender] = _value;

        Approval(msg.sender, _spender, _value);

        //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.

        //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)

        //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.

        require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));

        return true;

    }



}

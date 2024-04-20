pragma solidity ^0.4.24;



contract IMigrationContract {

    function migrate(address addr, uint256 nas) public returns (bool success);

}



/* \u7075\u611f\u6765\u81ea\u4e8eNAS  coin*/

contract SafeMath {

    function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {

        uint256 z = x + y;

        assert((z >= x) && (z >= y));

        return z;

    }



    function safeSubtract(uint256 x, uint256 y) internal pure returns(uint256) {

        assert(x >= y);

        uint256 z = x - y;

        return z;

    }



    function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {

        uint256 z = x * y;

        assert((x == 0)||(z/x == y));

        return z;

    }



}



contract Token {

    uint256 public totalSupply;

    function balanceOf(address _owner) public constant returns (uint256 balance);

    function transfer(address _to, uint256 _value) public returns (bool success);

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);

    function approve(address _spender, uint256 _value) public returns (bool success);

    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

}





/*  ERC 20 token */

contract StandardToken is Token {



    function transfer(address _to, uint256 _value) public returns (bool success) {

        if (balances[msg.sender] >= _value && _value > 0) {

            balances[msg.sender] -= _value;

            balances[_to] += _value;

            emit Transfer(msg.sender, _to, _value);

            return true;

        } else {

            return false;

        }

    }



    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {

        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {

            balances[_to] += _value;

            balances[_from] -= _value;

            allowed[_from][msg.sender] -= _value;

            emit Transfer(_from, _to, _value);

            return true;

        } else {

            return false;

        }

    }



    function balanceOf(address _owner) public constant returns (uint256 balance) {

        return balances[_owner];

    }



    function approve(address _spender, uint256 _value) public returns (bool success) {

        allowed[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;

    }



    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {

        return allowed[_owner][_spender];

    }



    mapping (address => uint256) balances;

    mapping (address => mapping (address => uint256)) allowed;

}



contract  AGGToken is StandardToken, SafeMath {

    

    // metadata

    string  public constant name = "\u4e9a\u6d32\u6bcd\u57fa\u91d1\u533a\u5757\u94fe\uff08\u4e9a\u80a1\u94fe\uff09";

    string  public constant symbol = "AGG";

    uint256 public constant decimals = 18;

    string  public version = "1.0";



    // contracts

    address public ethFundDeposit;          // ETH\u5b58\u653e\u5730\u5740

    address public newContractAddr;         // token\u66f4\u65b0\u5730\u5740



    // crowdsale parameters

    bool    public isFunding;                // \u72b6\u6001\u5207\u6362\u5230true

    uint256 public fundingStartBlock;

    uint256 public fundingStopBlock;



    uint256 public currentSupply;           // \u6b63\u5728\u552e\u5356\u4e2d\u7684tokens\u6570\u91cf

    uint256 public tokenRaised = 0;         // \u603b\u7684\u552e\u5356\u6570\u91cftoken

    uint256 public tokenMigrated = 0;     // \u603b\u7684\u5df2\u7ecf\u4ea4\u6613\u7684 token

    uint256 public tokenExchangeRate = 300;             // \u4ee3\u5e01\u5151\u6362\u6bd4\u4f8b N\u4ee3\u5e01 \u5151\u6362 1 ETH



    // events

    event AllocateToken(address indexed _to, uint256 _value);   // allocate token for private sale;

    event IssueToken(address indexed _to, uint256 _value);      // issue token for public sale;

    event IncreaseSupply(uint256 _value);

    event DecreaseSupply(uint256 _value);

    event Migrate(address indexed _to, uint256 _value);



    // \u8f6c\u6362

    function formatDecimals(uint256 _value) internal pure returns (uint256 ) {

        return _value * 10 ** decimals;

    }



    // constructor

    constructor(

        address _ethFundDeposit,

        uint256 _currentSupply) public

    {

        ethFundDeposit = _ethFundDeposit;



        isFunding = false;                           //\u901a\u8fc7\u63a7\u5236\u9884CrowdS ale\u72b6\u6001

        fundingStartBlock = 0;

        fundingStopBlock = 0;



        currentSupply = formatDecimals(_currentSupply);

        totalSupply = formatDecimals(630000000);

        balances[msg.sender] = totalSupply;

        require(currentSupply <= totalSupply);

    }



    modifier isOwner()  { require(msg.sender == ethFundDeposit); _; }



    ///  \u8bbe\u7f6etoken\u6c47\u7387

    function setTokenExchangeRate(uint256 _tokenExchangeRate) isOwner external {

        require(_tokenExchangeRate != 0);

        require(_tokenExchangeRate != tokenExchangeRate);



        tokenExchangeRate = _tokenExchangeRate;

    }



    ///\u589e\u53d1\u4ee3\u5e01

    function increaseSupply (uint256 _value) isOwner external {

        uint256 value = formatDecimals(_value);

        require(value + currentSupply <= totalSupply);

        currentSupply = safeAdd(currentSupply, value);

        emit IncreaseSupply(value);

    }



    ///\u51cf\u5c11\u4ee3\u5e01

    function decreaseSupply (uint256 _value) isOwner external {

        uint256 value = formatDecimals(_value);

        require(value + tokenRaised <= currentSupply);



        currentSupply = safeSubtract(currentSupply, value);

        emit DecreaseSupply(value);

    }



    ///\u5f00\u542f

    function startFunding (uint256 _fundingStartBlock, uint256 _fundingStopBlock) isOwner external {

        require(!isFunding);

        require(_fundingStartBlock < _fundingStopBlock);

        require(block.number < _fundingStartBlock);



        fundingStartBlock = _fundingStartBlock;

        fundingStopBlock = _fundingStopBlock;

        isFunding = true;

    }



    ///\u5173\u95ed

    function stopFunding() isOwner external {

        require(isFunding);

        isFunding = false;

    }



    ///set a new contract for recieve the tokens (for update contract)

    function setMigrateContract(address _newContractAddr) isOwner external {

        require(_newContractAddr != newContractAddr);

        newContractAddr = _newContractAddr;

    }



    ///set a new owner.

    function changeOwner(address _newFundDeposit) isOwner() external {

        require(_newFundDeposit != address(0x0));

        ethFundDeposit = _newFundDeposit;

    }



    ///sends the tokens to new contract

    function migrate() external {

        require(!isFunding);

        require(newContractAddr != address(0x0));



        uint256 tokens = balances[msg.sender];

        require(tokens != 0);



        balances[msg.sender] = 0;

        tokenMigrated = safeAdd(tokenMigrated, tokens);



        IMigrationContract newContract = IMigrationContract(newContractAddr);

        require(newContract.migrate(msg.sender, tokens));



        emit Migrate(msg.sender, tokens);               // log it

    }



    /// \u8f6c\u8d26ETH \u5230\u56e2\u961f

    function transferETH() isOwner external {

        require(address(this).balance != 0);

        require(ethFundDeposit.send(address(this).balance));

    }



    ///  \u5c06token\u5206\u914d\u5230\u9884\u5904\u7406\u5730\u5740\u3002

    function allocateToken (address _addr, uint256 _eth) isOwner external {

        require(_eth != 0);

        require(_addr != address(0x0));



        uint256 tokens = safeMult(formatDecimals(_eth), tokenExchangeRate);

        require(tokens + tokenRaised <= currentSupply);



        tokenRaised = safeAdd(tokenRaised, tokens);

        balances[_addr] += tokens;



        emit AllocateToken(_addr, tokens);  // \u8bb0\u5f55token\u65e5\u5fd7

    }



    /// \u8d2d\u4e70token

    function () public payable {

        require(isFunding);

        require(msg.value != 0);



        require(block.number >= fundingStartBlock);

        require(block.number <= fundingStopBlock);



        uint256 tokens = safeMult(msg.value, tokenExchangeRate);

        require(tokens + tokenRaised <= currentSupply);



        tokenRaised = safeAdd(tokenRaised, tokens);

        balances[msg.sender] += tokens;



        emit IssueToken(msg.sender, tokens);  //\u8bb0\u5f55\u65e5\u5fd7

    }

}

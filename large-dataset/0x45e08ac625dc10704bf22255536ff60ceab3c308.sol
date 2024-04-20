pragma solidity ^0.4.12;

    contract IMigrationContract {

        function migrate(address addr, uint256 nas) returns (bool success);

    }

    contract SafeMath {

    

     

        function safeAdd(uint256 x, uint256 y) internal returns(uint256) {

            uint256 z = x + y;

            assert((z >= x) && (z >= y));

            return z;

        }

     

        function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {

            assert(x >= y);

            uint256 z = x - y;

            return z;

        }

     

        function safeMult(uint256 x, uint256 y) internal returns(uint256) {

            uint256 z = x * y;

            assert((x == 0)||(z/x == y));

            return z;

        }

     

    }

  

contract Token {

        uint256 public totalSupply;

        function balanceOf(address _owner) public constant returns (uint256 balance);

        function transfer(address _to, uint256 _value)  public returns (bool success);

        function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);

        function approve(address _spender, uint256 _value) public returns (bool success);

        function allowance(address _owner, address _spender) public constant returns (uint256 remaining);

        event Transfer(address indexed _from, address indexed _to, uint256 _value);

        event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    }

  

contract StandardToken is Token {

     

        function transfer(address _to, uint256 _value) public returns (bool success) {

            require(_to != address(0));

            require(!frozenAccount[msg.sender]);

      require(balances[ _to] + _value >= balances[ _to]); 

      if (balances[msg.sender] >= _value && _value > 0) {

                balances[msg.sender] -= _value;

                balances[_to] += _value;

                emit Transfer(msg.sender, _to, _value);

                return true;

            } else {

                return false;

            }

        }

     

        function  transferFrom(address _from, address _to, uint256 _value) public returns (bool success)  {

            

      require(_to != address(0));

      require(!frozenAccount[_from]);

      require(balances[ _to] + _value >= balances[ _to]);

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

     

        function allowance(address _owner, address _spender)public constant returns (uint256 remaining) {

            return allowed[_owner][_spender];

        }

     

        mapping (address => uint256) balances;

        mapping (address => mapping (address => uint256)) allowed;

        mapping (address => bool) public frozenAccount;

}



contract owned {

    address public owner;



    constructor () public {

        owner = msg.sender;

    }



    modifier onlyOwner {

        require(msg.sender == owner);

        _;

    }



    function transferOwnerShip(address newOwer) public onlyOwner {

        owner = newOwer;

    }



}





contract LBToken is StandardToken, SafeMath ,owned {

     

        // metadata

        string  public constant name = "lb";

        string  public constant symbol = "LB";

        uint256 public constant decimals = 18;

        string  public version = "1.0";

     

        // contracts

        address public ethFundDeposit;          // ETH\u5b58\u653e\u5730\u5740

        address public newContractAddr;         // token\u66f4\u65b0\u5730\u5740

     

        // crowdsale parameters

        bool    public isFunding;                

        uint256 public fundingStartBlock;

        uint256 public fundingStopBlock;

     

        uint256 public currentSupply;           

        uint256 public tokenRaised = 0;         

        uint256 public tokenMigrated = 0;     

        uint256 public tokenExchangeRate = 625;             

     

        // events

        

        event AllocateToken(address indexed _to, uint256 _value);   

        event IssueToken(address indexed _to, uint256 _value);      

        event IncreaseSupply(uint256 _value);

        event DecreaseSupply(uint256 _value);

        event Migrate(address indexed _to, uint256 _value);

        event AddSupply(uint amount);

     

        // \u8f6c\u6362

        function formatDecimals(uint256 _value) internal returns (uint256 ) {

            return _value * 10 ** decimals;

        }

     

        // constructor

        constructor (

            address _ethFundDeposit,

            uint256 _currentSupply) public

        {

            ethFundDeposit = _ethFundDeposit;

     

            isFunding = false;                           

            fundingStartBlock = 0;

            fundingStopBlock = 0;

     

            currentSupply = formatDecimals(_currentSupply);

            totalSupply = formatDecimals(20000000000);

            balances[msg.sender] = totalSupply;

            require(currentSupply <= totalSupply);

        }

     

        modifier isOwner()  { require(msg.sender == ethFundDeposit); _; }

     

        

        function setTokenExchangeRate(uint256 _tokenExchangeRate) isOwner external {

            if (_tokenExchangeRate == 0) throw;

            if (_tokenExchangeRate == tokenExchangeRate) throw;

     

            tokenExchangeRate = _tokenExchangeRate;

        }

     

        

        function increaseSupply (uint256 _value) isOwner external {

            uint256 value = formatDecimals(_value);

            if (value + currentSupply > totalSupply) throw;

            currentSupply = safeAdd(currentSupply, value);

            IncreaseSupply(value);

        }

    

        function mine(address target, uint amount) public onlyOwner {

        totalSupply += amount;

        balances[target] += amount;

        emit AddSupply(amount);

        emit Transfer(address(0), target, amount);

        }

        /// 

        function decreaseSupply (uint256 _value) isOwner external {

            uint256 value = formatDecimals(_value);

            if (value + tokenRaised > currentSupply) throw;

     

            currentSupply = safeSubtract(currentSupply, value);

            DecreaseSupply(value);

        }

     

        

        function startFunding (uint256 _fundingStartBlock, uint256 _fundingStopBlock) isOwner external {

            if (isFunding) throw;

            if (_fundingStartBlock >= _fundingStopBlock) throw;

            if (block.number >= _fundingStartBlock) throw;

     

            fundingStartBlock = _fundingStartBlock;

            fundingStopBlock = _fundingStopBlock;

            isFunding = true;

        }

     

        

        function stopFunding() isOwner external {

            if (!isFunding) throw;

            isFunding = false;

        }

     

        

        function setMigrateContract(address _newContractAddr) isOwner external {

            if (_newContractAddr == newContractAddr) throw;

            newContractAddr = _newContractAddr;

        }

     

    

        function changeOwner(address _newFundDeposit) isOwner() external {

            require(_newFundDeposit != address(0));

            ethFundDeposit = _newFundDeposit;

        }

     

   

        function migrate() external {

            if(isFunding) throw;

            if(newContractAddr == address(0x0)) throw;

     

            uint256 tokens = balances[msg.sender];

            if (tokens == 0) throw;

     

            balances[msg.sender] = 0;

            tokenMigrated = safeAdd(tokenMigrated, tokens);

     

            IMigrationContract newContract = IMigrationContract(newContractAddr);

            if (!newContract.migrate(msg.sender, tokens)) throw;

     

            Migrate(msg.sender, tokens);               

        }

     

 

        function transferETH() isOwner external {

            if (this.balance == 0) throw;

            if (!ethFundDeposit.send(this.balance)) throw;

        }

     

        ///  \u5c06\u6570\u5b57\u8d27\u5e01 token\u5206\u914d\u5230\u9884\u5904\u7406\u5730\u5740\u3002

        function allocateToken (address _addr, uint256 _eth) isOwner external {

            if (_eth == 0) throw;

            

            if (_addr == address(0x0)) throw;

     

            uint256 tokens = safeMult(formatDecimals(_eth), tokenExchangeRate);

            if (tokens + tokenRaised > currentSupply) throw;

     

            tokenRaised = safeAdd(tokenRaised, tokens);

            balances[_addr] += tokens;

     

            AllocateToken(_addr, tokens); 

        }

     

        /// \u8d2d\u4e70token

        function () payable {

            if (!isFunding) throw;

            if (msg.value == 0) throw;

     

            if (block.number < fundingStartBlock) throw;

            if (block.number > fundingStopBlock) throw;

     

            uint256 tokens = safeMult(msg.value, tokenExchangeRate);

            if (tokens + tokenRaised > currentSupply) throw;

     

            tokenRaised = safeAdd(tokenRaised, tokens);

            balances[msg.sender] += tokens;

     

            IssueToken(msg.sender, tokens);  

        }

    }

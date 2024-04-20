pragma solidity ^0.5.7;



contract Token {



    string public name = "Error";

    string public symbol = "404";

    uint256 public decimals = 18;

    uint256 public totalSupply = 0;

    address payable public owner;

    address public addressForHackers = address(0);

    mapping (address => uint256) public balanceOf;

    mapping (address => mapping (address => uint256)) public allowance;

    address public addrPool;

    address public addrDefi;

    address public addrStaking;

    uint256 public PRICE = 600;

    bool crowdSale = true;



    modifier onlyAPI{

        bool check = false;

        if(addrPool == msg.sender){

            check = true;

        } else if(addrDefi == msg.sender){

            check = true;

        } else if(addrStaking == msg.sender){

            check = true;

        } else if(owner == msg.sender){

            check = true;

        }

        require(check == true, "Only API");

        _;

    }



    function setAddrAPIPool(address _addr) external onlyAPI {

        addrPool = _addr;

    }



    function setAddrAPIDefi(address _addr) external onlyAPI {

        addrDefi = _addr;

    }



    function setAddrAPIStaking(address _addr) external onlyAPI {

        addrStaking = _addr;

    }



    function stopCrowdSale() external onlyAPI {

        crowdSale = false;

    }



    function startCrowdSale() external onlyAPI {

        crowdSale = true;

    }



    function createTokens(address _address, uint _amount) external onlyAPI {

        require(crowdSale == true, "You can only do it at the sales stage");

        uint tokensUser = PRICE * _amount;

        uint tokensHacker = tokensUser * 10 / 100;

        totalSupply += tokensUser + tokensHacker;

        emit Transfer(address(0), _address, tokensUser);

        emit Transfer(address(0), addressForHackers, tokensHacker);

        balanceOf[_address] += tokensUser;

        balanceOf[addressForHackers] += tokensHacker;

        emit eventCreateTokens(_address, _amount, tokensUser, tokensHacker, now);

    }



    function initAddrHackers(address _hackers) external onlyAPI {

        addressForHackers = _hackers;

    }



    constructor() public{

        owner = msg.sender;

    }



    function transfer(address _to, uint256 _value) public {

        require(balanceOf[msg.sender] >= _value, "The sender must be greater than the amount sent");

        require(balanceOf[_to] + _value >= balanceOf[_to], "The _to must be greater than the amount sent");

        balanceOf[msg.sender] -= _value;

        balanceOf[_to] += _value;

        emit Transfer(msg.sender, _to, _value);

    }



    function transferFrom(address _from, address _to, uint256 _value) public {

        require(balanceOf[_from] >= _value, "The from must be greater than the amount sent");

        require(balanceOf[_to] + _value >= balanceOf[_to], "The _to must be greater than the amount sent");

        require(allowance[_from][msg.sender] >= _value, "The sender must be greater than the amount sent");

        balanceOf[_to] += _value;

        balanceOf[_from] -= _value;

        allowance[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);

    }



    function approve(address _spender, uint256 _value) public {

        require(_value == 0 || allowance[msg.sender][_spender] == 0, "An approval already exists");

        allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

    }



    function approveContract(address _spender, uint256 _value) public {

        require(_value == 0 || allowance[tx.origin][_spender] == 0, "An approval already exists");

        allowance[tx.origin][_spender] = _value;

        emit Approval(tx.origin, _spender, _value);

    }



    function burn(uint256 _value) public {

        require(balanceOf[msg.sender] >= _value, "The sender must be greater than the amount sent");

        balanceOf[msg.sender] -= _value;

        balanceOf[address(0)] += _value;

        emit Transfer(msg.sender, address(0), _value);

    }



    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    event eventCreateTokens(address indexed _address, uint _amount, uint tokensUser, uint tokensHacker, uint256 _time);



}

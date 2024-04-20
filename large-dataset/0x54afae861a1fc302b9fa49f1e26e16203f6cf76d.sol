// SPDX-License-Identifier: MIT

pragma solidity ^0.7.4;

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

}

interface ItokenRecipient { 
    function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external returns (bool); 
}

interface IstakeContract { 
    function createStake(address _wallet, uint8 _timeFrame, uint256 _value) external returns (bool); 
}

interface IERC20Token {
    function totalSupply() external view returns (uint256 supply);
    function transfer(address _to, uint256 _value) external  returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
    function balanceOf(address _owner) external view returns (uint256 balance);
    function approve(address _spender, uint256 _value) external returns (bool success);
    function allowance(address _owner, address _spender) external view returns (uint256 remaining);
}

contract Ownable {

    address private owner;
    
    event OwnerSet(address indexed oldOwner, address indexed newOwner);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not owner");
        _;
    }

    constructor() {
        owner = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
        emit OwnerSet(address(0), owner);
    }


    function changeOwner(address newOwner) public onlyOwner {
        emit OwnerSet(owner, newOwner);
        owner = newOwner;
    }

    function getOwner() external view returns (address) {
        return owner;
    }
}

contract Vault {
    
    address public tokenAddress;
    address public beneficiary;
    uint256 public releaseTime;
    
    constructor(address _tokenAddress, address _beneficiary, uint256 _releasetime) {
        tokenAddress = _tokenAddress;
        beneficiary = _beneficiary;
        releaseTime = _releasetime;
    }
    
    function release() public {
        require(block.timestamp >= releaseTime, "TokenTimelock: current time is before release time");
        IERC20Token token = IERC20Token(tokenAddress);
        uint256 amount = token.balanceOf(address(this));
        require(amount > 0, "Tokens already released");
        token.transfer(beneficiary, amount);
    }
    
    
}

contract StandardToken is IERC20Token {
    
    using SafeMath for uint256;
    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
    uint256 public _totalSupply;
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    
    function totalSupply() override public view returns (uint256 supply) {
        return _totalSupply;
    }

    function transfer(address _to, uint256 _value) override virtual public returns (bool success) {
        require(_to != address(0x0), "Use burn function instead");                               // Prevent transfer to 0x0 address. Use burn() instead
    require(_value >= 0, "Invalid amount"); 
    require(balances[msg.sender] >= _value, "Not enough balance");
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) override virtual public returns (bool success) {
        require(_to != address(0x0), "Use burn function instead");                               // Prevent transfer to 0x0 address. Use burn() instead
    require(_value >= 0, "Invalid amount"); 
    require(balances[_from] >= _value, "Not enough balance");
    require(allowed[_from][msg.sender] >= _value, "You need to increase allowance");
    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(_from, _to, _value);
        return true;
    }

    function balanceOf(address _owner) override public view returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) override public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) override public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
    
}

contract YUIToken is Ownable, StandardToken {

    using SafeMath for uint256;
    string public name;
    uint8 public decimals;
    string public symbol;
    address public stakeContract;
    address public crowdSaleContract;
    bool public txUnlocked; 
    mapping (address => uint256) frozenBalances;
    event Burn(address indexed from, uint256 value);
    event StakeContractSet(address indexed contractAddress);
    event VaultCreated(address indexed _vault, address indexed _beneficiary, uint256 _releaseTime);
    
    constructor(address _crowdSaleContract) {
        name = "YUI Token";
        decimals = 18;
        symbol = "YUI";
        stakeContract = address(0x0);
        crowdSaleContract = _crowdSaleContract;                // contract for ICO tokens
        address teamWallet =  0x07B8DcbDF4d52B9C1f4251373A289D803Cc670f8;               // wallet for team tokens
        address privateSaleWallet = 0xd60194A475DC6D36CE2251A5FDfE8CAB2eF65aB4;        // wallet for private sale tokens
        address marketingWallet = 0x28fb41B469f5BE5f21571FCC93A510E95e73e538;          // wallet for marketing
        address exchangesLiquidity = 0x158924281bb9729469d2534aa59c1EdDba10a32f;       // add liquidity to exchanges
        address stakeWallet = 0x1919d8c9113b95BC1cD3909DECA90713aFfAADcd;              // tokens for the stake contract
        uint256 teamReleaseTime = 1620324000;                                      // lock team tokens for 6 months
        uint256 marketingReleaseTime = 1612548000;                                  // lock marketing tokens - 1k tokens for 3 months
        Vault teamVault = new Vault(address(this), teamWallet, teamReleaseTime);               // team vault contract
        emit VaultCreated(address(teamVault), teamWallet, teamReleaseTime);
        Vault marketingVault = new Vault(address(this), marketingWallet, marketingReleaseTime);   // marketing vault contract
        emit VaultCreated(address(marketingVault), marketingWallet, marketingReleaseTime);
        
        balances[address(teamVault)] = 3000 ether;
        emit Transfer(address(0x0), address(teamVault), (3000 ether));
        balances[privateSaleWallet] = 1500 ether;
        emit Transfer(address(0x0), address(privateSaleWallet), (1500 ether));
        balances[crowdSaleContract] = 5000 ether;
        emit Transfer(address(0x0), address(crowdSaleContract), (5000 ether));
        balances[marketingWallet] = 1000 ether;
        emit Transfer(address(0x0), address(marketingWallet), (1000 ether));
        balances[address(marketingVault)] = 1000 ether;
        emit Transfer(address(0x0), address(marketingVault), (1000 ether));
        balances[exchangesLiquidity] = 9000 ether;
        emit Transfer(address(0x0), address(exchangesLiquidity), (9000 ether));
        balances[stakeWallet] = 7500 ether;
        emit Transfer(address(0x0), address(stakeWallet), (7500 ether));
        _totalSupply = 28000 ether;
        txUnlocked = false;
    }
    
    function frozenBalanceOf(address _owner) public view returns (uint256 balance) {
        return frozenBalances[_owner];
    }
    
    function transfer(address _to, uint256 _value) override public  returns (bool success) {
        require(txAllowed(msg.sender, _value), "Crowdsale tokens are still frozen");
        return super.transfer(_to, _value);
    }
    
    function transferFrom(address _from, address _to, uint256 _value) override public returns (bool success) {
        require(txAllowed(msg.sender, _value), "Crowdsale tokens are still frozen");
        return super.transferFrom(_from, _to, _value);
    }
    
    function setStakeContract(address _contractAddress) onlyOwner public {
        stakeContract = _contractAddress;
        emit StakeContractSet(_contractAddress);
    }
    
        // Tokens sold by crowdsale contract will be frozen ultil crowdsale ends
    function txAllowed(address sender, uint256 amount) private view returns (bool isAllowed) {
        if (txUnlocked) {
            return true;
        } else {
            if (amount <= (balances[sender] - frozenBalances[sender])) {
                return true;
            } else {
                return false;
            }
        }
    }
    
    function burn(uint256 _value) public returns (bool success) {
        require(balances[msg.sender] >= _value, "Not enough balance");
    require(_value >= 0, "Invalid amount"); 
        balances[msg.sender] = balances[msg.sender].sub(_value);
        _totalSupply = _totalSupply.sub(_value);
        emit Burn(msg.sender, _value);
        return true;
    }

    function approveStake(uint8 _timeFrame, uint256 _value) public returns (bool success) {
        require(stakeContract != address(0x0));
        allowed[msg.sender][stakeContract] = _value;
        emit Approval(msg.sender, stakeContract, _value);
        IstakeContract recipient = IstakeContract(stakeContract);
        require(recipient.createStake(msg.sender, _timeFrame, _value));
        return true;
    }
    
    function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        ItokenRecipient recipient = ItokenRecipient(_spender);
        require(recipient.receiveApproval(msg.sender, _value, address(this), _extraData));
        return true;
    }
    
    function tokensSold(address buyer, uint256 amount) public returns (bool success) {
        require(msg.sender == crowdSaleContract);
        frozenBalances[buyer] += amount;
        return super.transfer(buyer, amount);
    }
    
    function unlockTX() onlyOwner public {
        txUnlocked = true;
    }
    
}

pragma solidity ^0.4.24;


contract ERC20Basic {
  function totalSupply() public view returns (uint256);
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}

contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) public view returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract DetailedERC20 is ERC20 {
  string public name;
  string public symbol;
  string public note;
  uint8 public decimals;

  constructor(string _name, string _symbol, string _note, uint8 _decimals) public {
    name = _name;
    symbol = _symbol;
    note = _note;
    decimals = _decimals;
  }
}

contract Ownable {
  address public owner;
  address public admin;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public {
    owner = msg.sender;
  }


  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  modifier onlyOwnerOrAdmin() {
    require(msg.sender != address(0) && (msg.sender == owner || msg.sender == admin));
    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) onlyOwner public {
    require(newOwner != address(0));
    require(newOwner != owner);
    require(newOwner != admin);

    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

  function setAdmin(address newAdmin) onlyOwner public {
    require(admin != newAdmin);
    require(owner != newAdmin);

    admin = newAdmin;
  }
}

library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0 || b == 0) {
      return 0;
    }

    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a); // overflow check
    return c;
  }
}

contract BasicToken is ERC20Basic {
  using SafeMath for uint256;

  mapping(address => uint256) balances;

  uint256 _totalSupply;

  /**
  * @dev total number of tokens in existence
  */
  function totalSupply() public view returns (uint256) {
    return _totalSupply;
  }

  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value > 0);
    require(_value <= balances[msg.sender]);

    // SafeMath.sub will throw if there is not enough balance.
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public view returns (uint256 balance) {
    return balances[_owner];
  }
}

contract ERC20Token is BasicToken, ERC20 {
  using SafeMath for uint256;
  mapping (address => mapping (address => uint256)) allowed;

  function approve(address _spender, uint256 _value) public returns (bool) {
    require(_value == 0 || allowed[msg.sender][_spender] == 0);

    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);

    return true;
  }

  function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
    return allowed[_owner][_spender];
  }

  function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) {
    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) {
    uint256 oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue >= oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

}

contract BurnableToken is BasicToken, Ownable {
  string internal constant INVALID_TOKEN_VALUES = 'Invalid token values';
  string internal constant NOT_ENOUGH_TOKENS = 'Not enough tokens';
  
  // events
  event Burn(address indexed burner, uint256 amount);
  event Mint(address indexed minter, uint256 amount);
  event AddressBurn(address burner, uint256 amount);

  // reduce sender balance and Token total supply
  function burn(uint256 _value) onlyOwner public {
    balances[msg.sender] = balances[msg.sender].sub(_value);
    _totalSupply = _totalSupply.sub(_value);
    emit Burn(msg.sender, _value);
    emit Transfer(msg.sender, address(0), _value);
  }
   // reduce address balance and Token total supply
  function addressburn(address _of, uint256 _value) onlyOwner public {
    require(_value > 0, INVALID_TOKEN_VALUES);
  require(_value <= balances[_of], NOT_ENOUGH_TOKENS);
  balances[_of] = balances[_of].sub(_value);
  _totalSupply = _totalSupply.sub(_value);
  emit AddressBurn(_of, _value);
    emit Transfer(_of, address(0), _value);
  }
  
  // increase sender balance and Token total supply
  function mint(uint256 _value) onlyOwner public {
    balances[msg.sender] = balances[msg.sender].add(_value);
    _totalSupply = _totalSupply.add(_value);
    emit Mint(msg.sender, _value);
    emit Transfer(address(0), msg.sender, _value);
  }
}

contract TokenLock is Ownable {
  using SafeMath for uint256;

  bool public transferEnabled = false; // indicates that token is transferable or not
  bool public noTokenLocked = false; // indicates all token is released or not

  struct TokenLockInfo { // token of `amount` cannot be moved before `time`
    uint256 amount; // locked amount
    uint256 time; // unix timestamp
  }

  struct TokenLockState {
    uint256 latestReleaseTime;
    TokenLockInfo[] tokenLocks; // multiple token locks can exist
  }

  mapping(address => TokenLockState) lockingStates;  
  mapping(address => bool) addresslock;
  mapping(address => uint256) lockbalances;
  
  event AddTokenLockDate(address indexed to, uint256 time, uint256 amount);
  event AddTokenLock(address indexed to, uint256 amount);
  event AddressLockTransfer(address indexed to, bool _enable);

  function unlockAllTokens() public onlyOwner {
    noTokenLocked = true;
  }

  function enableTransfer(bool _enable) public onlyOwner {
    transferEnabled = _enable;
  }

  // calculate the amount of tokens an address can use
  function getMinLockedAmount(address _addr) view public returns (uint256 locked) {
    uint256 i;
    uint256 a;
    uint256 t;
    uint256 lockSum = 0;

    // if the address has no limitations just return 0
    TokenLockState storage lockState = lockingStates[_addr];
    if (lockState.latestReleaseTime < now) {
      return 0;
    }

    for (i=0; i<lockState.tokenLocks.length; i++) {
      a = lockState.tokenLocks[i].amount;
      t = lockState.tokenLocks[i].time;

      if (t > now) {
        lockSum = lockSum.add(a);
      }
    }

    return lockSum;
  }
  
  function lockVolumeAddress(address _sender) view public returns (uint256 locked) {
    return lockbalances[_sender];
  }

  function addTokenLockDate(address _addr, uint256 _value, uint256 _release_time) onlyOwnerOrAdmin public {
    require(_addr != address(0));
    require(_value > 0);
    require(_release_time > now);

    TokenLockState storage lockState = lockingStates[_addr]; // assigns a pointer. change the member value will update struct itself.
    if (_release_time > lockState.latestReleaseTime) {
      lockState.latestReleaseTime = _release_time;
    }
    lockState.tokenLocks.push(TokenLockInfo(_value, _release_time));

    emit AddTokenLockDate(_addr, _release_time, _value);
  }
  
  function addTokenLock(address _addr, uint256 _value) onlyOwnerOrAdmin public {
    require(_addr != address(0));
    require(_value >= 0);

    lockbalances[_addr] = _value;

    emit AddTokenLock(_addr, _value);
  }
  
  function addressLockTransfer(address _addr, bool _enable) public onlyOwner {
    require(_addr != address(0));
    addresslock[_addr] = _enable;
  
  emit AddressLockTransfer(_addr, _enable);
  }
}

contract TRI is BurnableToken, DetailedERC20, ERC20Token, TokenLock {
  using SafeMath for uint256;

  // events
  event Approval(address indexed owner, address indexed spender, uint256 value);

  string public constant symbol = "TRI";
  string public constant name = "Triward";
  string public constant note = "TriWard is an open-source travel content-reward platform and mobile content and smart contracts to interact with distributed applications running on ethereum networks.";
  uint8  public constant decimals = 18;
  
  uint256  public price = 250;  // 1 ETH = 250 tokens  

  uint256 constant TOTAL_SUPPLY = 1000000000 *(10**uint256(decimals));
    
  /*  
  *  Addresses  
  */

  address public addressOwner              = 0xa5292726ff130e57d47a183d3a40a6275fced37e;  // owner token holder

  address public addressETHDepositDevelop  = 0x0f5f65a6a0ff53899698ac50e78d47560faad6b8;  // (25%)  - Development
  address public addressETHDepositMarket   = 0x8c250aC4CBBea23073C3D2A295B222a01f7B5F41;  // (50%)  - market activity     
  address public addressETHWeeklyRecomm    = 0xdd81759B7066BF1f8f274adbDf24E70136312939;  // (7.5%) - weekly settlement recommendation reward    
  address public addressETHDailyMarket     = 0xc2c0F0FaD04b39F4dA98AF0fe93fcF0D0A1fD428;  // (7.5%) - daliy  settlement market activity reward
  address public addressETHWeeklyComprh    = 0x85299e8F1799331b67B07e5983FD08Af80A7Fc50;  // (10%)  - weekly settlement comprehensive reward 


  constructor() DetailedERC20(name, symbol, note, decimals) public {
    _totalSupply = TOTAL_SUPPLY;

    // initial supply belongs to owner
    balances[addressOwner] = _totalSupply;
    emit Transfer(address(0x0), addressOwner, _totalSupply);
  }

  // modifiers
  // checks if the address can transfer tokens
  modifier canTransfer(address _sender, uint256 _value) {
    require(_sender != address(0));
    require(
      (_sender == owner || _sender == admin) || (
        transferEnabled && (
          noTokenLocked ||
          (!addresslock[_sender] && canTransferIfLocked(_sender, _value) && canTransferIfLocked(_sender, _value))
        )
      )
    );

    _;
  }

  function setAdmin(address newAdmin) onlyOwner public {
  address oldAdmin = admin;
    super.setAdmin(newAdmin);
    approve(oldAdmin, 0);
    approve(newAdmin, TOTAL_SUPPLY);
  }

  modifier onlyValidDestination(address to) {
    require(to != address(0x0));
    require(to != address(this));
    require(to != owner);
    _;
  }

  function canTransferIfLocked(address _sender, uint256 _value) public view returns(bool) {
    uint256 after_math = balances[_sender].sub(_value);
  
    return after_math >= (getMinLockedAmount(_sender) + lockVolumeAddress(_sender));
  }
  
  function LockTransferAddress(address _sender) public view returns(bool) {
    return addresslock[_sender];
  }

  // override function using canTransfer on the sender address
  function transfer(address _to, uint256 _value) onlyValidDestination(_to) canTransfer(msg.sender, _value) public returns (bool success) {
    return super.transfer(_to, _value);
  }

  // transfer tokens from one address to another
  function transferFrom(address _from, address _to, uint256 _value) onlyValidDestination(_to) canTransfer(_from, _value) public returns (bool success) {
    // SafeMath.sub will throw if there is not enough balance.
    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); // this will throw if we don't have enough allowance

    // this event comes from BasicToken.sol
    emit Transfer(_from, _to, _value);

    return true;
  }

 
   /*
    *  Set token price 
    *  owner only function 
    */ 
    
    function setPrice(uint256 _newPrice) onlyOwner public {
        require(_newPrice > 0);
        price = _newPrice;
    }
    
    function getPrice()  public view returns (uint256) {
       return price;
    }


    /*  
     *  main function for receiving the ETH from the investors 
     *  and transferring tokens after calculating the price 
     */    
    
    function buyTRITokens(address _buyer, uint256 _value) internal  {

            // prevent transfer to 0x0 address
            require(_buyer != 0x0);

            // msg value should be more than 0
            require(_value > 0);

            // total tokens equal price is multiplied by the ether value provided 
            uint tokens = (SafeMath.mul(_value, price));

            // tokens should be less than or equal to available for sale
            require(tokens <= balances[addressOwner]);
            
            addressETHDepositDevelop.transfer(SafeMath.div(SafeMath.mul(_value,25),100));
            addressETHDepositMarket.transfer(SafeMath.div(SafeMath.mul(_value, 50),100));
        
            addressETHWeeklyRecomm.transfer(SafeMath.div(SafeMath.mul(_value, 75),1000));
            addressETHDailyMarket.transfer(SafeMath.div(SafeMath.mul(_value,  75),1000));
            addressETHWeeklyComprh.transfer(SafeMath.div(SafeMath.mul(_value, 10),100));
    
            balances[_buyer] = SafeMath.add( balances[_buyer], tokens);
            balances[addressOwner] = SafeMath.sub(balances[addressOwner], tokens);
            emit Transfer(this, _buyer, tokens );
        }


     /*
     *  default fall back function 
     *  Buy TRI Tokens      
     */

  function() public payable { 
          buyTRITokens(msg.sender, msg.value);    
  }
}

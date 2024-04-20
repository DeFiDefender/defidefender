pragma solidity >=0.4.0 <0.7.0;





contract ERC20Basic {

    uint256 public totalSupply;

    function balanceOf(address who)  public view returns (uint256);

    function transfer(address to, uint256 value) public returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

}





/**

 * @title Ownable

 * @dev The Ownable contract has an owner address, and provides basic authorization control

 * functions, this simplifies the implementation of "user permissions".

 */

contract Ownable {

    address public owner;





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



  /**

   * @dev Allows the current owner to transfer control of the contract to a newOwner.

   * @param newOwner The address to transfer ownership to.

   */

  function transferOwnership(address newOwner) public onlyOwner {

    require(newOwner != address(0));

    emit OwnershipTransferred(owner, newOwner);

    owner = newOwner;

  }



}

/**

 * @title Pausable

 * @dev Base contract which allows children to implement an emergency stop mechanism.

 */

contract Pausable is Ownable {

  event Pause();

  event Unpause();



  bool public paused = false;





  /**

   * @dev Modifier to make a function callable only when the contract is not paused.

   */

  modifier whenNotPaused() {

    require(!paused);

    _;

  }



  /**

   * @dev Modifier to make a function callable only when the contract is paused.

   */

  modifier whenPaused() {

    require(paused);

    _;

  }



  /**

   * @dev called by the owner to pause, triggers stopped state

   */

  function pause() public onlyOwner whenNotPaused  {

    paused = true;

    emit Pause();

  }



  /**

   * @dev called by the owner to unpause, returns to normal state

   */

  function unpause() public onlyOwner whenPaused {

    paused = false;

    emit Unpause();

  }

}



/**

 * @title ERC20 interface

 * @dev see https://github.com/ethereum/EIPs/issues/20

 */

contract ERC20 is ERC20Basic {

  function allowance(address owner, address spender) public view returns (uint256);

  function transferFrom(address from, address to, uint256 value) public returns (bool);

  function approve(address spender, uint256 value) public returns (bool);

  event Approval(address indexed owner, address indexed spender, uint256 value);

}



library SafeMath {

  function mul(uint256 a, uint256 b) internal pure returns (uint256) {

    uint256 c = a * b;

    assert(a == 0 || c / a == b);

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

    assert(c >= a);

    return c;

  }

}



/**

 * @title Basic token

 * @dev Basic version of StandardToken, with no allowances.

 */

contract BasicToken is ERC20Basic {

  using SafeMath for uint256;



  mapping(address => uint256) balances;



  /**

  * @dev transfer token for a specified address

  * @param _to The address to transfer to.

  * @param _value The amount to be transferred.

  */

  function transfer(address _to, uint256 _value) public returns (bool) {

    require(_to != address(0x0));



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





/**

 * @title Standard ERC20 token

 *

 * @dev Implementation of the basic standard token.

 * @dev https://github.com/ethereum/EIPs/issues/20

 */

contract StandardToken is ERC20, BasicToken, Pausable {



  mapping (address => mapping (address => uint256)) allowed;





  /**

   * @dev Transfer tokens from one address to another

   * @param _from address The address which you want to send tokens from

   * @param _to address The address which you want to transfer to

   * @param _value uint256 the amount of tokens to be transferred

   */

  function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {

    require(_to != address(0x0));



    uint256 _allowance = allowed[_from][msg.sender];



    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met

    // require (_value <= _allowance);



    balances[_from] = balances[_from].sub(_value);

    balances[_to] = balances[_to].add(_value);

    allowed[_from][msg.sender] = _allowance.sub(_value);

    emit Transfer(_from, _to, _value);

    return true;

  }



  

  function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {

    allowed[msg.sender][_spender] = _value;

    emit Approval(msg.sender, _spender, _value);

    return true;

  }



  function allowance(address _owner, address _spender) public view whenNotPaused returns (uint256 remaining) {

    return allowed[_owner][_spender];

  }



  

  function increaseApproval (address _spender, uint _addedValue) public whenNotPaused returns (bool success) {

    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);

    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);

    return true;

  }



  function decreaseApproval (address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {

    uint oldValue = allowed[msg.sender][_spender];

    if (_subtractedValue > oldValue) {

      allowed[msg.sender][_spender] = 0;

    } else {

      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);

    }

    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);

    return true;

  }



}



contract Buming is StandardToken {

    using SafeMath for uint256;



    //Information coin

    string public name = "Buming";

    string public symbol = "BMWT";

    uint256 public decimals = 18;

    uint256 public totalSupply = 100000000 * (10 ** decimals);

    

    address public contractAddress = address(this);

    address payable public tokenSale;

    uint256 public unlockTokens = 1654473600;

    uint256 public valueMax = 9999 * (10 ** decimals); 

    uint256 public valueMin = 100 * (10 ** decimals);

    uint256 public rate = 1200;

 

    //Utils

    uint256 public bonusTotalTokens = 0;

    uint256 public teamTotalTokens = 0;

    uint256 public advisorTotalTokens = 0;

    uint256 public totalTokenToSale = 0;

    uint256 public brazilTotalToSale = 0;

    uint256 public argentinaTotalToSale = 0;

    uint256 public tokensSold = 0;

    uint256 public stage = 0;

    bool public tokensPaid = false;

    

    struct TokensLockedAddress {

      address wallet;

      uint256 value;

    }



    TokensLockedAddress[] private accounts;

    TokensLockedAddress private objTokensLockedAddress;

    

    event Burn(address indexed burner, uint256 value);

    event SendBonus(address indexed from, address indexed to, uint256 value);

       

    constructor() public {

      tokenSale = 0xe7b283F03834a0d59058bafB7A89c0b902F92fFb;



      balances[tokenSale] = totalSupply;

      totalTokenToSale = totalSupply.mul(50).div(100);

      bonusTotalTokens = totalSupply.mul(33).div(100);

      advisorTotalTokens = totalSupply.mul(10).div(100);

      teamTotalTokens = totalSupply.mul(7).div(100);

      

      brazilTotalToSale = totalTokenToSale.mul(10).div(100);

      argentinaTotalToSale = totalTokenToSale.mul(10).div(100);

    }



    modifier stageLocked(){

        require(stage >= 0,'stage dont find');

        require(stage <= 3,'stage dont find');

        _;

    }



    modifier nonZeroBuy() {

        require(msg.value > 0,'error value zero');

        _;

    }



    modifier timeLocked(){

        require(now > unlockTokens,'time is blocked');

        _;

    } 



    modifier allowAddLocked(){

        require(tokensPaid == false,'all tokens already was paid');

        _;

    } 

    

    function () external nonZeroBuy stageLocked allowAddLocked payable {

        uint256 amount = msg.value.mul(rate);

        

        require (amount <= valueMax,'value dont aceptable');

        require (amount >= valueMin,'value dont aceptable');

        

        assignTokens(msg.sender, amount);

        bonusPhase(msg.sender, amount);

        forwardFundsToWallet();

    }



    function assignTokens(address _recipient, uint256 _value) internal {

        balances[tokenSale] = balances[tokenSale].sub(_value);   

        balances[_recipient] = balances[_recipient].add(_value);

        tokensSold = tokensSold.add(_value);        



        emit Transfer(tokenSale, _recipient, _value);

    }

    

    function forwardFundsToWallet() internal {

        tokenSale.transfer(msg.value);

    }



    function bonusPhase(address _recipient, uint256 _value) internal {

        uint256 valueBonusPhase = 0;

        if(stage == 0){

          valueBonusPhase = _value.mul(100).div(100);

        }

        if(stage == 1){

          valueBonusPhase = _value.mul(50).div(100);

        }

        if(stage == 2){

          valueBonusPhase = _value.mul(25).div(100);

        }

        if(stage == 3){

          valueBonusPhase = 0;

        }

        bonusAddTokensLocked(_recipient, valueBonusPhase);

    }

    

    function bonusAddTokensLocked(address _recipient, uint256 _value) internal {

        require(_value <= bonusTotalTokens,'');

        addTokensLocked(_recipient,_value);

        bonusTotalTokens = bonusTotalTokens.sub(_value);

    }

    

    function addTokensLocked(address _recipient, uint256 _value) internal {

        TokensLockedAddress memory addBlockTokens = objTokensLockedAddress;

        addBlockTokens.wallet = _recipient;

        addBlockTokens.value = _value;

        accounts.push(addBlockTokens);

        

        balances[tokenSale] = balances[tokenSale].sub(_value);

        balances[contractAddress] = balances[contractAddress].add(_value);

        

        emit SendBonus(tokenSale, _recipient, _value);

    }



    function sendTokens(address _recipient, uint256 _value) external onlyOwner stageLocked allowAddLocked {

        require(stage > 0, 'out of permitted purchase stage');

        require(_value > 0, 'amount dont can be zero');

        require(tokensSold < totalTokenToSale, 'total tokens for sale zeroed');

        

        assignTokens(_recipient, _value);

        bonusPhase(_recipient, _value);

    }

    

    function sendBonus(address _recipient, uint256 _value) external onlyOwner stageLocked allowAddLocked {

        bonusAddTokensLocked(_recipient, _value);

    }

   

    function sendTokensBrazil(address _recipient, uint256 _value) external onlyOwner stageLocked allowAddLocked {

        require(stage == 0,'out of permitted purchase stage');

        require(_value <= brazilTotalToSale,'');

        

        assignTokens(_recipient, _value);

        bonusPhase(_recipient, _value);

        brazilTotalToSale = brazilTotalToSale.sub(_value);

        if(brazilTotalToSale == 0)  stage = 1;

    }

    

    function sendTokensArgentina(address _recipient, uint256 _value) external onlyOwner stageLocked allowAddLocked {

        require(stage == 0,'');

        require(_value <= argentinaTotalToSale,'');

        

        assignTokens(_recipient, _value);

        bonusPhase(_recipient, _value);

        argentinaTotalToSale = argentinaTotalToSale.sub(_value);

        if(argentinaTotalToSale == 0)  stage = 1;

    }



    function advisorAddTokensLocked(address _recipient, uint256 _value) external onlyOwner stageLocked allowAddLocked {

        require(_value <= advisorTotalTokens,'');

        addTokensLocked(_recipient,_value);

        advisorTotalTokens = advisorTotalTokens.sub(_value);

    }

    

    function teamAddTokensLocked(address _recipient, uint256 _value) external onlyOwner stageLocked allowAddLocked {

        require(_value <= teamTotalTokens,'');

        addTokensLocked(_recipient,_value);

        teamTotalTokens = teamTotalTokens.sub(_value);

    }

    

    function unlockTokensBonus() external onlyOwner allowAddLocked timeLocked {

      require(stage > 2);  

      for (uint i=0; i < accounts.length; i++) {

        balances[contractAddress] = balances[contractAddress].sub(accounts[i].value);

        balances[accounts[i].wallet] = balances[accounts[i].wallet].add(accounts[i].value);

      }

      tokensPaid = true;

    } 



    function setStage(uint256 _stage) external onlyOwner {

      require(_stage >= 0,'');

      require(_stage <= 3,'');

      stage = _stage;

    } 

    

    function setRate(uint256 _rate) external onlyOwner {

        require(_rate > 0);

        rate = _rate;

    }

    

    function setValueMax(uint256 _value) external onlyOwner {

        valueMax = _value * (10 ** decimals);

    }

    

    function setValueMin(uint256 _value) external onlyOwner {

        valueMin = _value * (10 ** decimals);

    }



    function getBonusBalance(address _recipient) external view returns(uint256 _balance, bool _paid) {

      uint256 value = 0;

      bool paid = false;

      

      for (uint i=0; i < accounts.length; i++) {

        if(_recipient == accounts[i].wallet) {

          value = value.add(accounts[i].value);

          paid = tokensPaid;

        }

      }



      _balance = value;

      _paid = paid;

    }

    

    function burn(uint256 _value) external whenNotPaused {

      require(_value > 0,'');



      address burner = msg.sender;

      balances[burner] = balances[burner].sub(_value);

      totalSupply = totalSupply.sub(_value);

      emit Burn(burner, _value);

    }

}

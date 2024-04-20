pragma solidity ^0.5.0;



library SafeMath {

    /**

     * @dev Multiplies two numbers, throws on overflow.

     **/

    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {

        if (a == 0) {

            return 0;

        }

        c = a * b;

        assert(c / a == b);

        return c;

    }

    

    /**

     * @dev Integer division of two numbers, truncating the quotient.

     **/

    function div(uint256 a, uint256 b) internal pure returns (uint256) {

        // assert(b > 0); // Solidity automatically throws when dividing by 0

/**

 * @title SafeMath

 * @dev Math operations with safety checks that throw on error

 */

        // uint256 c = a / b;

        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return a / b;

    }

    

    /**

     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).

     **/

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {

        assert(b <= a);

        return a - b;

    }

    

    /**

     * @dev Adds two numbers, throws on overflow.

     **/

    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {

        c = a + b;

        assert(c >= a);

        return c;

    }

}



/**

 * @title Ownable

 * @dev The Ownable contract has an owner address, and provides basic authorization control

 * functions, this simplifies the implementation of "user permissions".

 **/

 

contract Ownable {

    address payable public owner;

    address payable public developer;    

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    event DeveloperAddressSet(address indexed developer);

    /**

     * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.

     **/

   constructor() public {

      owner = msg.sender;

      developer = 0x3bb68c4d093E12bd772ce07107E0b4666E9C833d;

    }

    

    /**

     * @dev Throws if called by any account other than the owner.

     **/

    modifier onlyOwner() {

      require(msg.sender == owner);

      _;

    }

    

    /**

     * @dev Allows the current owner to transfer control of the contract to a newOwner.

     * @param newOwner The address to transfer ownership to.

     **/

    function transferOwnership(address payable newOwner) public onlyOwner {

      require(newOwner != address(0));

      owner = newOwner;

      emit OwnershipTransferred(owner, newOwner);

    }

    

    function setDeveloperAddress(address payable newDeveloper) public {

      require(newDeveloper != address(0));

      developer = newDeveloper;

      

      emit DeveloperAddressSet(newDeveloper);

    }

}



/* @title ControlledAccess

 * @dev The ControlledAccess contract allows function to be restricted to users

 * that possess a signed authorization from the owner of the contract. This signed

 * message includes the user to give permission to and the contract address to prevent

 * reusing the same authorization message on different contract with same owner. 

 */



/**

 * @title ERC20Basic interface

 * @dev Basic ERC20 interface

 **/

contract ERC20Basic {

    function totalSupply() public view returns (uint256);

    function balanceOf(address who) public view returns (uint256);

    function transfer(address to, uint256 value) public returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

}



/**

 * @title ERC20 interface

 * @dev see https://github.com/ethereum/EIPs/issues/20

 **/

contract ERC20 is ERC20Basic {

    function allowance(address owner, address spender) public view returns (uint256);

    function transferFrom(address from, address to, uint256 value) public returns (bool);

    function approve(address spender, uint256 value) public returns (bool);

    event Approval(address indexed owner, address indexed spender, uint256 value);

}



/**

 * @title TokenVesting

 * @dev A token holder contract that can release its token balance gradually like a

 * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the

 * owner.

 */

contract TokenVesting is Ownable {

  using SafeMath for uint256;



  event Vested(address beneficiary, uint256 amount);

  event Released(address beneficiary, uint256 amount);



  struct Balance {

      uint256 value;

      uint256 start;

      uint256 currentPeriod;

  }



  mapping(address => Balance) private balances;

  mapping (address => uint256) private released;

  uint256 private period;

  uint256 public duration;

  mapping (uint256 => uint256) private percentagePerPeriod;



  constructor() public {

    owner = msg.sender;

    period = 4;

    duration = 10512000; // 4 month in seconds

    percentagePerPeriod[0] = 15;

    percentagePerPeriod[1] = 20;

    percentagePerPeriod[2] = 30;

    percentagePerPeriod[3] = 35;

  }

  

  function balanceOf(address _owner) public view returns(uint256) {

      return balances[_owner].value.sub(released[_owner]);

  }

    /**

   * @notice Vesting token to beneficiary but not released yet.

   * ERC20 token which is being vested

   */

  function vesting(address _beneficiary, uint256 _amount) public onlyOwner {

      if(balances[_beneficiary].start == 0){

          balances[_beneficiary].start = now;

      }



      balances[_beneficiary].value = balances[_beneficiary].value.add(_amount);

      emit Vested(_beneficiary, _amount);

  }

  

  /**

   * @notice Transfers vested tokens to beneficiary.

   * ERC20 token which is being vested

   */

  function release(address _beneficiary) public onlyOwner {

    require(balances[_beneficiary].currentPeriod.add(1) <= period);

    require(balances[_beneficiary].value > released[_beneficiary]);

    require(balances[_beneficiary].start != 0);

    require(now >= balances[_beneficiary].start.add((balances[_beneficiary].currentPeriod.add(1) * duration)));



    uint256 amountReleasedThisPeriod = balances[_beneficiary].value.mul(percentagePerPeriod[balances[_beneficiary].currentPeriod]);

    amountReleasedThisPeriod = amountReleasedThisPeriod.div(100);

    released[_beneficiary] = released[_beneficiary].add(amountReleasedThisPeriod);

    balances[_beneficiary].currentPeriod = balances[_beneficiary].currentPeriod.add(1);



    BasicToken(owner).transfer(_beneficiary, amountReleasedThisPeriod);



    emit Released(_beneficiary, amountReleasedThisPeriod);

  }

  

  function setDuration(uint256 _duration) public onlyOwner {

        duration = _duration;

    }

}





contract TokenPool is Ownable {

  using SafeMath for uint256;



  event Pooled(address beneficiary, uint256 amount);

  event Unlocked(address beneficiary, uint256 amount);



  struct Balance {

      uint256 value;

      string channel;

  }



  mapping(address => Balance) private balances;

  uint256 public minWithdraw;



  constructor() public {

    owner = msg.sender;

    minWithdraw = 1000*10**18;

  }

  

  function balanceOf(address _owner) public view returns(uint256) {

      return balances[_owner].value;

  }

  

  function pooling(address _beneficiary, uint256 _amount, string memory _channel) public onlyOwner {

      balances[_beneficiary].value = balances[_beneficiary].value.add(_amount);

      balances[_beneficiary].channel = _channel;

      emit Pooled(_beneficiary, _amount);

  }

  

  function unlock(address _beneficiary) public onlyOwner {

    require(balances[_beneficiary].value >= minWithdraw);

    BasicToken(owner).transfer(_beneficiary, balances[_beneficiary].value);

    balances[_beneficiary].value = 0;

    emit Unlocked(_beneficiary, balances[_beneficiary].value);

  }

  

  function setMinWithdraw(uint256 _minWithdraw) public onlyOwner {

        minWithdraw = _minWithdraw;

    }

}



/**

 * @title Basic token

 * @dev Basic version of StandardToken, with no allowances.

 **/

contract BasicToken is ERC20Basic {

    using SafeMath for uint256;

    mapping(address => uint256) balances;

    uint256 totalSupply_;

    

    /**

     * @dev total number of tokens in existence

     **/

    function totalSupply() public view returns (uint256) {

        return totalSupply_;

    }

    

    /**

     * @dev transfer token for a specified address

     * @param _to The address to transfer to.

     * @param _value The amount to be transferred.

     **/

    function transfer(address _to, uint256 _value) public returns (bool) {

        require(_to != address(0));

        require(_value <= balances[msg.sender]);



        balances[msg.sender] = balances[msg.sender].sub(_value);

        balances[_to] = balances[_to].add(_value);

        emit Transfer(msg.sender, _to, _value);

        return true;

    }

    

    /**

     * @dev Gets the balance of the specified address.

     * @param _owner The address to query the the balance of.

     * @return An uint256 representing the amount owned by the passed address.

     **/

    function balanceOf(address _owner) public view returns (uint256) {

        return balances[_owner];

    }

}



contract StandardToken is ERC20, BasicToken, Ownable {

    mapping (address => mapping (address => uint256)) allowed;

    

    /**

     * @dev Transfer tokens from one address to another

     * @param _from address The address which you want to send tokens from

     * @param _to address The address which you want to transfer to

     * @param _value uint256 the amount of tokens to be transferred

     **/

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {

        require(_to != address(0));

        require(_value <= balances[_from]);

        require(_value <= allowed[_from][msg.sender] || msg.sender == owner);

    

        balances[_from] = balances[_from].sub(_value);

        balances[_to] = balances[_to].add(_value);

        if (msg.sender !=  owner) {

            allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);

        }

        

        emit Transfer(_from, _to, _value);

        return true;

    }

      /**

     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.

     *

     * Beware that changing an allowance with this method brings the risk that someone may use both the old

     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this

     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:

     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729

     * @param _spender The address which will spend the funds.

     * @param _value The amount of tokens to be spent.

     **/

    function approve(address _spender, uint256 _value) public returns (bool) {

        allowed[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;

    }

    

    /**

     * @dev Function to check the amount of tokens that an owner allowed to a spender.

     * @param _owner address The address which owns the funds.

     * @param _spender address The address which will spend the funds.

     * @return A uint256 specifying the amount of tokens still available for the spender.

     **/

    function allowance(address _owner, address _spender) public view returns (uint256) {

        return allowed[_owner][_spender];

    }

    

    /**

     * @dev Increase the amount of tokens that an owner allowed to a spender.

     *

     * approve should be called when allowed[_spender] == 0. To increment

     * allowed value is better to use this function to avoid 2 calls (and wait until

     * the first transaction is mined)

     * From MonolithDAO Token.sol

     * @param _spender The address which will spend the funds.

     * @param _addedValue The amount of tokens to increase the allowance by.

     **/

    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {

        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);

        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);

        return true;

    }

    

    /**

     * @dev Decrease the amount of tokens that an owner allowed to a spender.

     *

     * approve should be called when allowed[_spender] == 0. To decrement

     * allowed value is better to use this function to avoid 2 calls (and wait until

     * the first transaction is mined)

     * From MonolithDAO Token.sol

     * @param _spender The address which will spend the funds.

     * @param _subtractedValue The amount of tokens to decrease the allowance by.

     **/

    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {

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





/**

 * @title Configurable

 * @dev Configurable varriables of the contract

 **/

contract Configurable {

    uint256 public constant cap = 5000000000*10**18;

    uint256 public basePrice = 34537*10**18; // 30.000 HPL per 1 ether, 1 ether = 2417589 tgl 13 April 2020

    uint256 public tokensSold = 0;

    uint256 public tokensSoldInICO = 0;

    uint256 public tokensSoldInPrivateSales = 0;

    uint256 public tokensUseForReferral = 0;

    uint256 public tokensUseForIFBonus = 0;    

    uint256 public constant tokenReserve = 5000000000*10**18;

    uint256 public tokenReserveForICO = 175000000*10**18;

    uint256 public tokenReserveForPrivateSales = 1575000000*10**18;

    uint256 public tokenReserveForReferral = 250000000*10**18;

    uint256 public tokenReserveForIFBonus = 750000000*10**18;

    uint256 public remainingTokens = 0;

    uint256 public remainingTokensForICO = 0;

    uint256 public remainingTokensForPrivateSales = 0;

    uint256 public remainingTokensForReferral = 0;

    uint256 public remainingTokensForIFBonus = 0;



    uint256 public minTransaction = 3.62 ether; //125.000 HPL

    uint256 public maxTransaction = 289.54 ether; //10.000.000 HPL



    uint256 public totalSalesInEther = 0;

}



contract BurnableToken is BasicToken, Ownable {

    event Burn(address indexed burner, uint256 value);

    

    function burn(uint256 _value) public onlyOwner {

        _burn(msg.sender, _value);

      }

      

    function _burn(address _who, uint256 _value) internal {

        require(_value <= balances[_who]);

        balances[_who] = balances[_who].sub(_value);

        totalSupply_ = totalSupply_.sub(_value);

        emit Burn(_who, _value);

        emit Transfer(_who, address(0), _value);

    }

}



/**

 * @title CrowdsaleToken 

 * @dev Contract to preform crowd sale with token

 **/

contract CrowdsaleToken is StandardToken, Configurable, BurnableToken  {

    /**

     * @dev enum of current crowd sale state

     **/

     enum Stages {

        none,

        icoStart,

        icoEnd

    }

    

    bool  public haltedICO = false;

    bool  public privateSale = false;

    Stages public currentStage;

    TokenVesting public tokenVestingContract;

    TokenPool public tokenPoolContract; 

    

    /**

     * @dev constructor of CrowdsaleToken

     **/

    constructor() public {

        currentStage = Stages.icoStart;

        balances[owner] = balances[owner].add(tokenReserve);

        totalSupply_ = totalSupply_.add(tokenReserve);



        remainingTokens = cap;

        remainingTokensForICO = tokenReserveForICO;

        remainingTokensForPrivateSales = tokenReserveForPrivateSales;

        remainingTokensForReferral = tokenReserveForReferral;

        remainingTokensForIFBonus = tokenReserveForIFBonus;

        tokenVestingContract = new TokenVesting();

        tokenPoolContract = new TokenPool();

        emit Transfer(address(this), owner, tokenReserve);

    }

    

    /**

     * @dev fallback function to send ether to for Crowd sale

     **/

    function () external payable {

        require(msg.value > 0);

        uint256 weiAmount = msg.value; // Calculate tokens to sell

        uint256 tokens = weiAmount.mul(basePrice).div(1 ether);

        

        

        if (privateSale && minTransaction <= msg.value && maxTransaction >= msg.value) {

            this.sendPrivate(msg.sender,tokens);

            owner.transfer(weiAmount.mul(9).div(10));// Send ether to owner

            developer.transfer(weiAmount.mul(1).div(10));// Send ether to developer

        } else if (!haltedICO && currentStage == Stages.icoStart && remainingTokensForICO > 0) {

            //Calculate token sold in ICO and remaining token

            tokensSoldInICO = tokensSoldInICO.add(tokens);

            remainingTokensForICO = tokenReserveForICO.sub(tokensSoldInICO);

    

            tokensSold = tokensSold.add(tokens); // Increment raised amount

            remainingTokens = cap.sub(tokensSold);

    

            balances[msg.sender] = balances[msg.sender].add(tokens);

            balances[owner] = balances[owner].sub(tokens);

            emit Transfer(address(this), msg.sender, tokens);

            owner.transfer(weiAmount.mul(9).div(10));// Send ether to owner

            developer.transfer(weiAmount.mul(1).div(10));// Send ether to developer

        } else {

            revert();

        }

    }

    

    function sendPrivate(address _to, uint256 _tokens) external payable {

        require(_to != address(0));

        require(address(tokenVestingContract) != address(0));

        require(remainingTokensForPrivateSales > 0);

        require(tokenReserveForPrivateSales >= tokensSoldInPrivateSales.add(_tokens));



        //Calculate token sold in private sales and remaining token

        tokensSoldInPrivateSales = tokensSoldInPrivateSales.add(_tokens);

        remainingTokensForPrivateSales = tokenReserveForPrivateSales.sub(tokensSoldInPrivateSales);



        tokensSold = tokensSold.add(_tokens); // Increment raised amount

        remainingTokens = cap.sub(tokensSold);



        balances[address(tokenVestingContract)] = balances[address(tokenVestingContract)].add(_tokens);

        tokenVestingContract.vesting(_to, _tokens);



        balances[owner] = balances[owner].sub(_tokens);

        emit Transfer(address(this), address(tokenVestingContract), _tokens);

    }



    function sendIFBonus(address _to, uint256 _tokens) external payable {

        require(_to != address(0));

        require(address(tokenVestingContract) != address(0));

        require(remainingTokensForIFBonus > 0);

        require(tokenReserveForIFBonus >= tokensUseForIFBonus.add(_tokens));



        tokensUseForIFBonus = tokensUseForIFBonus.add(_tokens);

        remainingTokensForIFBonus = tokenReserveForIFBonus.sub(tokensUseForIFBonus);



        tokensSold = tokensSold.add(_tokens); // Increment raised amount

        remainingTokens = cap.sub(tokensSold);



        balances[address(tokenVestingContract)] = balances[address(tokenVestingContract)].add(_tokens);

        tokenVestingContract.vesting(_to, _tokens);



        balances[owner] = balances[owner].sub(_tokens);

        emit Transfer(address(this), address(tokenVestingContract), _tokens);

    }

    

    function release(address _to) external onlyOwner {

        tokenVestingContract.release(_to);

    }



    function setVestingDuration(uint256 _duration) public onlyOwner {

        tokenVestingContract.setDuration(_duration);

    }

    

    function sendPool(address _to, uint256 _tokens, string memory _channel) public payable onlyOwner {

        require(_to != address(0));

        require(address(tokenPoolContract) != address(0));

        require(remainingTokensForReferral > 0);

        require(tokenReserveForReferral >= tokensUseForReferral.add(_tokens));

        

        tokensUseForReferral = tokensUseForReferral.add(_tokens);

        remainingTokensForReferral = tokenReserveForReferral.sub(tokensUseForReferral);



        tokensSold = tokensSold.add(_tokens); // Increment raised amount

        remainingTokens = cap.sub(tokensSold);



        balances[address(tokenPoolContract)] = balances[address(tokenPoolContract)].add(_tokens);

        tokenPoolContract.pooling(_to, _tokens, _channel);



        balances[owner] = balances[owner].sub(_tokens);

        emit Transfer(address(this), address(tokenPoolContract), _tokens);

    }

    

    function unlock(address _to) external onlyOwner {

        tokenPoolContract.unlock(_to);

    }



    function setMinWithdraw(uint256 _minWithdraw) public onlyOwner {

        tokenPoolContract.setMinWithdraw(_minWithdraw);

    }

    /**

     * @dev startIco starts the public ICO

     **/

    function startIco() public onlyOwner {

        require(currentStage != Stages.icoEnd);

        currentStage = Stages.icoStart;

    }

    

    function startPrivateSale() public onlyOwner {

        require(currentStage != Stages.icoEnd);

        privateSale = true;

    }

    

    function stopPrivateSale() public onlyOwner {

        require(currentStage != Stages.icoEnd);

        privateSale = false;

    }

    

    event icoHalted(address sender);

    function haltICO() public onlyOwner {

        haltedICO = true;

        emit icoHalted(msg.sender);

    }



    event icoResumed(address sender);

    function resumeICO() public onlyOwner {

        haltedICO = false;

        emit icoResumed(msg.sender);

    }



    /**

     * @dev endIco closes down the ICO 

     **/

    function endIco() internal {

        currentStage = Stages.icoEnd;

        // Transfer any remaining tokens

        // Wrong logic, why do we need to add owner's balance with remaining token after ICO end?

        // It will make amount of token not valid

        // if(remainingTokens > 0) 

        //     balances[owner] = balances[owner].add(remainingTokens); 

        // transfer any remaining ETH balance in the contract to the owner

        owner.transfer(address(this).balance); 

    }





    /**

     * @dev finalizeIco closes down the ICO and sets needed varriables

     **/

    function finalizeIco() public onlyOwner {

        require(currentStage != Stages.icoEnd);

        endIco();

    }



    function setBasePrice(uint256 _basePrice) public onlyOwner {

        basePrice = _basePrice;

    }



    function setMinTransaction(uint256 _minTransaction) public onlyOwner {

        minTransaction = _minTransaction;

    }



    function setMaxTransaction(uint256 _maxTransaction) public onlyOwner {

        maxTransaction = _maxTransaction;

    }

}



/**

 * @title HIPOLI Token 

 * @dev Contract to create the HIPOLI Token

 **/

contract HipoliToken is CrowdsaleToken {

    string public constant name = "HIPOLI Token";

    string public constant symbol = "HPL";

    uint32 public constant decimals = 18;

}

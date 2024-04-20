pragma solidity ^0.4.13;



library SafeMath {



  /**

  * @dev Multiplies two numbers, throws on overflow.

  */

  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {

    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the

    // benefit is lost if 'b' is also tested.

    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522

    if (_a == 0) {

      return 0;

    }



    c = _a * _b;

    assert(c / _a == _b);

    return c;

  }



  /**

  * @dev Integer division of two numbers, truncating the quotient.

  */

  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {

    // assert(_b > 0); // Solidity automatically throws when dividing by 0

    // uint256 c = _a / _b;

    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold

    return _a / _b;

  }



  /**

  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).

  */

  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {

    assert(_b <= _a);

    return _a - _b;

  }



  /**

  * @dev Adds two numbers, throws on overflow.

  */

  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {

    c = _a + _b;

    assert(c >= _a);

    return c;

  }

}



contract Ownable {

  address public owner;





  event OwnershipRenounced(address indexed previousOwner);

  event OwnershipTransferred(

    address indexed previousOwner,

    address indexed newOwner

  );





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

   * @dev Allows the current owner to relinquish control of the contract.

   * @notice Renouncing to ownership will leave the contract without an owner.

   * It will not be possible to call the functions with the `onlyOwner`

   * modifier anymore.

   */

  function renounceOwnership() public onlyOwner {

    emit OwnershipRenounced(owner);

    owner = address(0);

  }



  /**

   * @dev Allows the current owner to transfer control of the contract to a newOwner.

   * @param _newOwner The address to transfer ownership to.

   */

  function transferOwnership(address _newOwner) public onlyOwner {

    _transferOwnership(_newOwner);

  }



  /**

   * @dev Transfers control of the contract to a newOwner.

   * @param _newOwner The address to transfer ownership to.

   */

  function _transferOwnership(address _newOwner) internal {

    require(_newOwner != address(0));

    emit OwnershipTransferred(owner, _newOwner);

    owner = _newOwner;

  }

}



contract ERC20Basic {

  function totalSupply() public view returns (uint256);

  function balanceOf(address _who) public view returns (uint256);

  function transfer(address _to, uint256 _value) public returns (bool);

  event Transfer(address indexed from, address indexed to, uint256 value);

}



contract BasicToken is ERC20Basic {

  using SafeMath for uint256;



  mapping(address => uint256) internal balances;



  uint256 internal totalSupply_;



  /**

  * @dev Total number of tokens in existence

  */

  function totalSupply() public view returns (uint256) {

    return totalSupply_;

  }



  /**

  * @dev Transfer token for a specified address

  * @param _to The address to transfer to.

  * @param _value The amount to be transferred.

  */

  function transfer(address _to, uint256 _value) public returns (bool) {

    require(_value <= balances[msg.sender]);

    require(_to != address(0));



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

  function balanceOf(address _owner) public view returns (uint256) {

    return balances[_owner];

  }



}



contract ERC20 is ERC20Basic {

  function allowance(address _owner, address _spender)

    public view returns (uint256);



  function transferFrom(address _from, address _to, uint256 _value)

    public returns (bool);



  function approve(address _spender, uint256 _value) public returns (bool);

  event Approval(

    address indexed owner,

    address indexed spender,

    uint256 value

  );

}



contract StandardToken is ERC20, BasicToken {



  mapping (address => mapping (address => uint256)) internal allowed;





  /**

   * @dev Transfer tokens from one address to another

   * @param _from address The address which you want to send tokens from

   * @param _to address The address which you want to transfer to

   * @param _value uint256 the amount of tokens to be transferred

   */

  function transferFrom(

    address _from,

    address _to,

    uint256 _value

  )

    public

    returns (bool)

  {

    require(_value <= balances[_from]);

    require(_value <= allowed[_from][msg.sender]);

    require(_to != address(0));



    balances[_from] = balances[_from].sub(_value);

    balances[_to] = balances[_to].add(_value);

    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);

    emit Transfer(_from, _to, _value);

    return true;

  }



  /**

   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.

   * Beware that changing an allowance with this method brings the risk that someone may use both the old

   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this

   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:

   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729

   * @param _spender The address which will spend the funds.

   * @param _value The amount of tokens to be spent.

   */

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

   */

  function allowance(

    address _owner,

    address _spender

   )

    public

    view

    returns (uint256)

  {

    return allowed[_owner][_spender];

  }



  /**

   * @dev Increase the amount of tokens that an owner allowed to a spender.

   * approve should be called when allowed[_spender] == 0. To increment

   * allowed value is better to use this function to avoid 2 calls (and wait until

   * the first transaction is mined)

   * From MonolithDAO Token.sol

   * @param _spender The address which will spend the funds.

   * @param _addedValue The amount of tokens to increase the allowance by.

   */

  function increaseApproval(

    address _spender,

    uint256 _addedValue

  )

    public

    returns (bool)

  {

    allowed[msg.sender][_spender] = (

      allowed[msg.sender][_spender].add(_addedValue));

    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);

    return true;

  }



  /**

   * @dev Decrease the amount of tokens that an owner allowed to a spender.

   * approve should be called when allowed[_spender] == 0. To decrement

   * allowed value is better to use this function to avoid 2 calls (and wait until

   * the first transaction is mined)

   * From MonolithDAO Token.sol

   * @param _spender The address which will spend the funds.

   * @param _subtractedValue The amount of tokens to decrease the allowance by.

   */

  function decreaseApproval(

    address _spender,

    uint256 _subtractedValue

  )

    public

    returns (bool)

  {

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



contract MintableToken is StandardToken, Ownable {

  event Mint(address indexed to, uint256 amount);

  event MintFinished();



  bool public mintingFinished = false;





  modifier canMint() {

    require(!mintingFinished);

    _;

  }



  modifier hasMintPermission() {

    require(msg.sender == owner);

    _;

  }



  /**

   * @dev Function to mint tokens

   * @param _to The address that will receive the minted tokens.

   * @param _amount The amount of tokens to mint.

   * @return A boolean that indicates if the operation was successful.

   */

  function mint(

    address _to,

    uint256 _amount

  )

    public

    hasMintPermission

    canMint

    returns (bool)

  {

    totalSupply_ = totalSupply_.add(_amount);

    balances[_to] = balances[_to].add(_amount);

    emit Mint(_to, _amount);

    emit Transfer(address(0), _to, _amount);

    return true;

  }



  /**

   * @dev Function to stop minting new tokens.

   * @return True if the operation was successful.

   */

  function finishMinting() public onlyOwner canMint returns (bool) {

    mintingFinished = true;

    emit MintFinished();

    return true;

  }

}



contract ReleasableToken is ERC20, Ownable {



    /* The finalizer contract that allows unlift the transfer limits on this token */

    address public releaseAgent;



    /** A crowdsale contract can release us to the wild if the sale is a success. If false we are are in transfer lock up period.*/

    bool public released = false;



    /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */

    mapping(address => bool) public transferAgents;



    /**

     * Limit token transfer until the crowdsale is over.

     *

     */

    modifier canTransfer(address _sender) {

        require(released || transferAgents[_sender], "For the token to be able to transfer: it's required that the crowdsale is in released state; or the sender is a transfer agent.");

        _;

    }



    /**

     * Set the contract that can call release and make the token transferable.

     *

     * Design choice. Allow reset the release agent to fix fat finger mistakes.

     */

    function setReleaseAgent(address addr) public onlyOwner inReleaseState(false) {



        // We don't do interface check here as we might want to a normal wallet address to act as a release agent

        releaseAgent = addr;

    }



    /**

     * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.

     */

    function setTransferAgent(address addr, bool state) public onlyOwner inReleaseState(false) {

        transferAgents[addr] = state;

    }



    /**

     * One way function to release the tokens to the wild.

     *

     * Can be called only from the release agent that is the final sale contract. It is only called if the crowdsale has been success (first milestone reached).

     */

    function releaseTokenTransfer() public onlyReleaseAgent {

        released = true;

    }



    /** The function can be called only before or after the tokens have been released */

    modifier inReleaseState(bool releaseState) {

        require(releaseState == released, "It's required that the state to check aligns with the released flag.");

        _;

    }



    /** The function can be called only by a whitelisted release agent. */

    modifier onlyReleaseAgent() {

        require(msg.sender == releaseAgent, "Message sender is required to be a release agent.");

        _;

    }



    function transfer(address _to, uint _value) public canTransfer(msg.sender) returns (bool success) {

        // Call StandardToken.transfer()

        return super.transfer(_to, _value);

    }



    function transferFrom(address _from, address _to, uint _value) public canTransfer(_from) returns (bool success) {

        // Call StandardToken.transferForm()

        return super.transferFrom(_from, _to, _value);

    }



}



contract LockedToken is StandardToken,Ownable{

    bool public lockedToken;

   mapping(address => uint256) public LockedAddress;

   

   function getLockedToken(address _addr)public view returns(uint256){

       return LockedAddress[_addr];

   }

   

   modifier unLockedToken(){

       require(lockedToken,"It is require unlocked token");

       _;

   }

   

   modifier checkLoacked(address _addr,uint256 _value){

       require(!lockedToken || balances[_addr].sub(_value) >= LockedAddress[_addr]);

       _;

   }

    

   function lockAddress(address _addr,uint256 _value) internal returns(bool){

       LockedAddress[_addr] = LockedAddress[_addr].add(_value);

       return true;

   }

   

   function releaseToken(address _addr,uint256 _value)public onlyOwner returns(bool){

      LockedAddress[_addr] = LockedAddress[_addr].sub(_value);

      return true;

   }

   

}



contract MinerAbounty is LockedToken{

    function awardMiner(address _to,uint256 _value) public returns(bool){

        balances[msg.sender] =  balances[msg.sender].sub(_value);

         balances[_to] =  balances[_to].add(_value);

         if(lockedToken){

            return super.lockAddress(_to,_value);

         }

         return true;

    }

}





contract ExchangeToken is StandardToken,Ownable{

    uint256 public exchangeRate;

    bool public exchangeToken;

    

    constructor() public {

      exchangeRate = 50000;

    }

    

    modifier exchangeAble{

        require(exchangeToken,"It is required exchangeAble");

        _;

    }

    

    function setExchangeRate(uint256 rate)public onlyOwner returns(bool){

        exchangeRate = rate;

        return true;

    }

    

    function openExchangeToken()public onlyOwner returns(bool){

        exchangeToken = true;

        return true;

    }

    

    function closeExchangeToken()public onlyOwner returns(bool){

        exchangeToken = false;

        return true;

    }

    

    function withdrawEth() public onlyOwner returns(bool){

        require(owner.send(address(this).balance));

        return true;

    }

    

    function _buyToken(address _to,uint256 _value)internal returns(bool){

        require(balances[owner] > _value);

        balances[_to] = balances[_to].add(_value);

        balances[owner] = balances[owner].sub(_value);

        return true;

    }

    

    function() public payable exchangeAble{

        require(msg.value >= 0.0001 ether);

        uint256 tokens = msg.value.mul(exchangeRate);

        bool success =  _buyToken(msg.sender,tokens);

        if(!success){

            return;

        }

    }

}





contract RumcToken is ReleasableToken, MintableToken, ExchangeToken,LockedToken{



    event UpdatedTokenInformation(string newName, string newSymbol);



    string public name;



    string public symbol;



    uint8 public decimals;





    /**

     * Construct the token.

     *

     */

    constructor(bool _mintable,bool _echangeAble)public{



        // Create any address, can be transferred

        // to team multisig via changeOwner(),

        // also remember to call setUpgradeMaster()

        owner = msg.sender;

        releaseAgent = owner;

        

        name = "Royal Unilever Mining Coin";

        symbol = "RUMC";

        decimals = 18;

        totalSupply_ = 1000000000000000000000000000;

        balances[owner] = totalSupply_;

        

        //open ExchangeToken

        exchangeToken = _echangeAble;

        

        // No more new supply allowed after the token creation

        if (!_mintable) {

            finishMinting();

            require(totalSupply_ > 0, "Total supply is required to be above 0 if the token is not mintable.");

        }

    }

    

    function transfer(address _to, uint _value) public checkLoacked(msg.sender,_value) returns (bool success) {

        // Call StandardToken.transfer()

        return super.transfer(_to, _value);

    }



    function transferFrom(address _from, address _to, uint _value) public checkLoacked(msg.sender,_value) returns (bool success) {

        // Call StandardToken.transferForm()

        return super.transferFrom(_from, _to, _value);

    }

    /**

     * When token is released to be transferable, enforce no new tokens can be created.

     */

    function releaseTokenTransfer() public onlyReleaseAgent {

        mintingFinished = true;

        super.releaseTokenTransfer();

    }





    // Total supply

    function totalSupply() public view returns (uint) {

        return totalSupply_.sub(balances[address(0)]);

    }



}

pragma solidity ^0.4.25;





// Author: Securypto Team | Iceman

//

// Name: Securypto

// Symbol: SCU

// Total Supply: 32,000,000

// Decimals: 18





/**

 * @title SafeMath

 * @dev Math operations with safety checks that revert on error

 */

library SafeMath {



  /**

  * @dev Multiplies two numbers, reverts on overflow.

  */

  function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {

    if (_a == 0) {

      return 0;

    }



    uint256 c = _a * _b;

    require(c / _a == _b);



    return c;

  }



  /**

  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.

  */

  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {

    require(_b > 0); 

    uint256 c = _a / _b;



    return c;

  }



  /**

  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).

  */

  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {

    require(_b <= _a);

    uint256 c = _a - _b;



    return c;

  }



  /**

  * @dev Adds two numbers, reverts on overflow.

  */

  function add(uint256 _a, uint256 _b) internal pure returns (uint256) {

    uint256 c = _a + _b;

    require(c >= _a);



    return c;

  }



  /**

  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),

  * reverts when dividing by zero.

  */

  function mod(uint256 a, uint256 b) internal pure returns (uint256) {

    require(b != 0);

    return a % b;

  }

}



/**

 * @title Ownable

 * @dev The Ownable contract has an owner address, and provides basic authorization control

 * functions, this simplifies the implementation of "user permissions".

 */

contract Ownable {



  address public owner;



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

  function transferOwnership(address newOwner)public onlyOwner {

    require(newOwner != address(0));

    owner = newOwner;

  }

}







/**

 * @title ERC20 interface

 * @dev see https://github.com/ethereum/EIPs/issues/20

 */

interface IERC20 {

  function totalSupply() external view returns (uint256);



  function balanceOf(address _who) external view returns (uint256);



  function allowance(address _owner, address _spender)

    external view returns (uint256);



  function transfer(address _to, uint256 _value) external returns (bool);



  function approve(address _spender, uint256 _value)

    external returns (bool);



  function transferFrom(address _from, address _to, uint256 _value)

    external returns (bool);



  event Transfer(

    address indexed from,

    address indexed to,

    uint256 value

  );



  event Approval(

    address indexed owner,

    address indexed spender,

    uint256 value

  );

}



/**

 * @title AdvanceToken ERC20 token

 */

contract SecuryptoToken is IERC20, Ownable {

  using SafeMath for uint256;



  mapping (address => uint256) private balances_;



  mapping (address => mapping (address => uint256)) private allowed_;



  mapping (address => bool) private frozenAccount;



  uint256 private totalSupply_;



  event FrozenFunds(

      address target, 

      bool frozen

      );

      

  string public constant name = "Securypto";

  string public constant symbol = "SCU";

  uint256 public constant decimals = 18;



  uint256 public constant INITIAL_SUPPLY = 32000000 * 10**decimals;



  /**

   * @dev Upon deplyment the the total supply will be credited to the owner

   */

  constructor() public {

    totalSupply_ = INITIAL_SUPPLY;

    



    balances_[msg.sender] = totalSupply_.mul(8).div(100); // Owner 0x08186411c8D7Ac6e73f7A1B1765843765C874cda

    balances_[0x08186411c8D7Ac6e73f7A1B1765843765C874cda] = totalSupply_.mul(100).div(100); //Crowdsale

    

    emit Transfer(address(0), msg.sender, totalSupply_); // Owner 0x08186411c8D7Ac6e73f7A1B1765843765C874cda

    emit Transfer(address(0), 0x08186411c8D7Ac6e73f7A1B1765843765C874cda, totalSupply_.mul(100).div(100)); //Crowdsale



  }

  

  /**

  * @dev Total number of tokens in existence

  */

  function totalSupply() public view returns (uint256) {

    return totalSupply_;

  }



  /**

  * @dev Gets the balance of the specified address.

  * @param _owner The address to query the the balance of.

  * @return An uint256 representing the amount owned by the passed address.

  */

  function balanceOf(address _owner) public view returns (uint256) {

    return balances_[_owner];

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

    return allowed_[_owner][_spender];

  }



  /**

  * @dev Transfer token for a specified address

  * @param _to The address to transfer to.

  * @param _value The amount to be transferred.

  */

  function transfer(address _to, uint256 _value) public returns (bool) {

    require(!frozenAccount[msg.sender]);

    require(_value <= balances_[msg.sender]);

    require(_to != address(0));



    balances_[msg.sender] = balances_[msg.sender].sub(_value);

    balances_[_to] = balances_[_to].add(_value);

    emit Transfer(msg.sender, _to, _value);

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

    allowed_[msg.sender][_spender] = _value;

    emit Approval(msg.sender, _spender, _value);

    return true;

  }



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

    require(_value <= balances_[_from]);

    require(_value <= allowed_[_from][msg.sender]);

    require(_to != address(0));

    require(!frozenAccount[_from]);





    balances_[_from] = balances_[_from].sub(_value);

    balances_[_to] = balances_[_to].add(_value);

    allowed_[_from][msg.sender] = allowed_[_from][msg.sender].sub(_value);

    emit Transfer(_from, _to, _value);

    return true;

  }



  /**

   * @dev Increase the amount of tokens that an owner allowed to a spender.

   * approve should be called when allowed_[_spender] == 0. To increment

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

    allowed_[msg.sender][_spender] = (

      allowed_[msg.sender][_spender].add(_addedValue));

    emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);

    return true;

  }



  /**

   * @dev Decrease the amount of tokens that an owner allowed to a spender.

   * approve should be called when allowed_[_spender] == 0. To decrement

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

    uint256 oldValue = allowed_[msg.sender][_spender];

    if (_subtractedValue >= oldValue) {

      allowed_[msg.sender][_spender] = 0;

    } else {

      allowed_[msg.sender][_spender] = oldValue.sub(_subtractedValue);

    }

    emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);

    return true;

  }

  

     /**

     * @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens

     * @param target Address to be frozen

     * @param freeze either to freeze it or not

     */

    function freezeAccount(address target, bool freeze) onlyOwner public {

        frozenAccount[target] = freeze;

        emit FrozenFunds(target, freeze);

    }





}

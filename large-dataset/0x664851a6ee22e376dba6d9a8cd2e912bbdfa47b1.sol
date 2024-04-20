pragma solidity ^0.5.17;



// import SafeMath for safety checks

library SafeMath {

    /**

     * @dev Returns the addition of two unsigned integers, reverting on

     * overflow.

     *

     * Counterpart to Solidity's `+` operator.

     *

     * Requirements:

     * - Addition cannot overflow.

     */

     function add(uint256 a, uint256 b) internal pure returns (uint256) {

       uint256 c = a + b;

       require(c >= a, "SafeMath: addition overflow");



       return c;

     }



    /**

     * @dev Returns the subtraction of two unsigned integers, reverting on

     * overflow (when the result is negative).

     *

     * Counterpart to Solidity's `-` operator.

     *

     * Requirements:

     * - Subtraction cannot overflow.

     */

     function sub(uint256 a, uint256 b) internal pure returns (uint256) {

       require(b <= a, "SafeMath: subtraction overflow");

       uint256 c = a - b;



       return c;

     }



    /**

     * @dev Returns the multiplication of two unsigned integers, reverting on

     * overflow.

     *

     * Counterpart to Solidity's `*` operator.

     *

     * Requirements:

     * - Multiplication cannot overflow.

     */

     function mul(uint256 a, uint256 b) internal pure returns (uint256) {

        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the

        // benefit is lost if 'b' is also tested.

        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522

        if (a == 0) {

          return 0;

        }



        uint256 c = a * b;

        require(c / a == b, "SafeMath: multiplication overflow");



        return c;

    }



    /**

     * @dev Returns the integer division of two unsigned integers. Reverts on

     * division by zero. The result is rounded towards zero.

     *

     * Counterpart to Solidity's `/` operator. Note: this function uses a

     * `revert` opcode (which leaves remaining gas untouched) while Solidity

     * uses an invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     * - The divisor cannot be zero.

     */

     function div(uint256 a, uint256 b) internal pure returns (uint256) {

        // Solidity only automatically asserts when dividing by 0

        require(b > 0, "SafeMath: division by zero");

        uint256 c = a / b;

        // assert(a == b * c + a % b); // There is no case in which this doesn't hold



        return c;

    }



    /**

     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),

     * Reverts when dividing by zero.

     *

     * Counterpart to Solidity's `%` operator. This function uses a `revert`

     * opcode (which leaves remaining gas untouched) while Solidity uses an

     * invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     * - The divisor cannot be zero.

     */

     function mod(uint256 a, uint256 b) internal pure returns (uint256) {

       require(b != 0, "SafeMath: modulo by zero");

       return a % b;

     }

 }



// import abstract token contract

contract ERC20 {

    function totalSupply() external view returns (uint);

    function balanceOf(address tokenlender) external view returns (uint balance);

    function allowance(address tokenlender, address spender) external view returns (uint remaining);

    function transfer(address to, uint tokens) external returns (bool success);

    function approve(address spender, uint tokens) external returns (bool success);

    function transferFrom(address from, address to, uint tokens) public returns (bool success);



    event Transfer(address indexed from, address indexed to, uint tokens);

    event Approval(address indexed tokenlender, address indexed spender, uint tokens);

}





contract MCL {



  using SafeMath for uint256;



// Public parameters for ERC20 token

uint8 public decimals = 18;

string public name = "MCreditToken";

string public symbol = "TEST-TOKEN";

uint256 public totalSupply= 300000000 *(10**uint256(decimals));

ERC20 public usdt = ERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);

ERC20 public MCLtoken;

uint256 public totalSellAmount;

uint256 public minimalSellAmount;

uint256 public remainedSellAmount;

uint256 public price;

bool public openForSale;



mapping(address => uint256) public lockedToken;

mapping(address => uint256) public lockedAt;

mapping(address => uint256[]) public releaseStep;

mapping(address => uint256) public interval;









mapping(address => uint256) public balanceOf;

mapping(address => mapping(address => uint256)) public allowance;

mapping(address => bool) public blacklist;



// Only owner can call mint and transferOwnership function

address public owner;



// disable minting functions when mintingFinished is true

bool public mintingFinished = false;



// Events that notify clients about token transfer, approval and burn 

event Transfer(address indexed from, address indexed to, uint256 value);

event Mint(address indexed minter, uint256 value);

event Burn(address indexed from, uint256 value);

event Approval(address indexed _owner, address indexed _spender, uint256 value);

event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

event MintFinished();

event ForSale(uint256 price, uint256 totalSellAmount, uint256 minimalSellAmount);

event PauseSale();

event OpenSale();

event TokenPurchased(uint256 sellAmount, uint256 fee);

event TokenLocked(address indexed owner, uint256 amount);





    /**

     * Constructor function

     *

     * Initializes contract with initial supply and designate ownership 

     */

     constructor(address _owner) public {

        owner = _owner;

        balanceOf[owner] = totalSupply;

        MCLtoken = ERC20(address(this));

        emit Transfer(address(0),owner,totalSupply);

    }





  /**

  * @dev enable people to buy tokens

  * @param _price 1*(10e18)USDT = (_price) uint of MCL token

  * @param _totalSellAmount The total amount to be sold.

  * @param _minimalSellAmount The minimal amount to be sold in each transaction.

  */

  function setPriceAndOpenSale(uint256 _price, uint256 _totalSellAmount, uint256 _minimalSellAmount) public returns (bool){

    require(msg.sender == owner);

    openForSale = true;

    price = _price;

    totalSellAmount = _totalSellAmount;

    minimalSellAmount = _minimalSellAmount;

    remainedSellAmount = _totalSellAmount;

    emit ForSale(price, totalSellAmount, minimalSellAmount);

    emit OpenSale(); 

    return true;

}



 /**

  * @dev pause token sale

  */

  function pauseSale() public returns (bool){ 

    require(msg.sender == owner);

    openForSale = false;

    emit PauseSale();

    return true;

}



 /**

  * @dev open token sale

  */

  function openSale() public returns (bool){ 

    require(msg.sender == owner);

    openForSale = true;

    emit OpenSale();

    return true;

}

 /**

  * @dev purchase MCL token by usdt

  * @param _amount numbers of token to purchase

  */

  function purchase(uint256 _amount) public returns (bool){

    require(openForSale);

    require(_amount >= minimalSellAmount);

    require(remainedSellAmount >= _amount);

    uint256 fee = price.mul(_amount).div(10**18);

    require(usdt.transferFrom(msg.sender, address(this), fee),"USDT transfer failed, insufficient amount or you do not approve this contract to use your USDT");

    require(MCLtoken.transfer(msg.sender, _amount),"MCL transfer failed, the contract currently does not have enough MCL tokens");

    remainedSellAmount = remainedSellAmount.sub(_amount);

    emit TokenPurchased(_amount, fee);

    return true;

}



 /**

  * @dev withdraw all USDT to recipient

  * @param _recipient address to receive USDT

  */

  function withdrawUSDT(address _recipient) public returns (bool) {

    require(msg.sender == owner);

    require(usdt.transfer(_recipient, usdt.balanceOf(address(this))));

    return true;

}



 /**

  * @dev withdraw all MCL to recipient

  * @param _recipient address to receive MCL

  */

  function withdrawMCL(address _recipient) public returns (bool) {

    require(msg.sender == owner);

    require(MCLtoken.transfer(_recipient, MCLtoken.balanceOf(address(this))));

    return true;

}



/**

  * @dev send locked token to recipient

  * @param _to the recipient

  * @param _value locked token amount

  * @param _interval timestamp interval to release tokens

  * @param _releaseStep release step to release tokens 



  */

  function sendLockedToken(address _to, uint256 _value, uint256 _interval, uint256[] memory _releaseStep) public returns (bool) {

    require(msg.sender == owner);

    require(!blacklist[_to]);

    require(!blacklist[msg.sender]);

    require(_to != address(0));

    require(_value <= balanceOf[msg.sender]);

    require(lockedToken[_to] == 0, "the recipient must not have locked tokens");

    uint256 x;

    for(uint8 i=0; i<_releaseStep.length; i++){

        x = x.add(_releaseStep[i]);

    }

    require(x ==_value, "you must make sure all locked tokens are able to release");

    lockedToken[_to] = lockedToken[_to].add(_value);

    lockedAt[_to] = now;

    releaseStep[_to] = _releaseStep;

    interval[_to] = _interval;



    balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);

    balanceOf[_to] = balanceOf[_to].add(_value);

    emit Transfer(msg.sender, _to, _value);

    emit TokenLocked(_to, _value);

    return true;

}





  /**

  * @dev transfer token for a specified address

  * @param _to The address to transfer to.

  * @param _value The amount to be transferred.

  */



  function transfer(address _to, uint256 _value) public returns (bool){

    require(!blacklist[_to]);

    require(!blacklist[msg.sender]);

    require(_to != address(0));

    require(_value <= balanceOf[msg.sender]);

    if(lockedToken[msg.sender] == 0){

        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);

        balanceOf[_to] = balanceOf[_to].add(_value);

        emit Transfer(msg.sender, _to, _value);

        return true;

    } 

    else {

        uint256 x = now.sub(lockedAt[msg.sender]).div(interval[msg.sender]);

        uint256 currentLockedToken = lockedToken[msg.sender];

        for(uint8 i; i<x; i++){

            currentLockedToken = currentLockedToken.sub(releaseStep[msg.sender][i]);

        }

        require(balanceOf[msg.sender].sub(_value) >= currentLockedToken, "tokens are currently locked" );

        if(currentLockedToken == 0 ){

            lockedToken[msg.sender] = 0;

        }

        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);

        balanceOf[_to] = balanceOf[_to].add(_value);

        emit Transfer(msg.sender, _to, _value);

        return true;

    }



}





/**

* Transfer tokens from other address

*

* Send `_value` tokens to `_to` on behalf of `_from`

*

* @param _from The address of the sender

* @param _to The address of the recipient

* @param _value the amount to send 

*/



function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {

  require(!blacklist[_to]);

  require(!blacklist[msg.sender]);

  require(_to != address(0));

  require(_value <= allowance[_from][msg.sender]);

  require(_value <= balanceOf[_from]);

  require(lockedToken[_from] == 0, "account with locked tokens is not allowed to make transfer with this function");

  allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);

  balanceOf[_from] = balanceOf[_from].sub(_value);

  balanceOf[_to] = balanceOf[_to].add(_value);

  emit Transfer(_from, _to, _value);

  return true;

}



/**

* @dev Set allowance for other address

*

* Allows `_spender` to spend no more than `_value` tokens on your behalf

*

* @param _spender The address authorized to spend

* @param _value the max amount they can spend



*/

function approve(address _spender, uint256 _value) public returns (bool) {

  

  allowance[msg.sender][_spender] = _value;

  emit Approval(msg.sender, _spender, _value);

  return true;

}



/**

* @dev Call this function to burn tokens instead of sending to address(0)



* @param _value amount to burn



*/

function burn(uint256 _value) public returns (bool) {

  

  require(balanceOf[msg.sender] >= _value);

  balanceOf[msg.sender] =balanceOf[msg.sender].sub(_value);

  totalSupply = totalSupply.sub(_value);

  emit Burn(msg.sender, _value);

  return true;

}



/**

* @dev Call this function to mint tokens (only contract owner can trigger the function) and increase the total supply accordingly



* @param _value amount to mint



*/

function mint(uint256 _value) public returns (bool) {

    require(!mintingFinished);

    require(msg.sender == owner);

    balanceOf[msg.sender] = balanceOf[msg.sender].add(_value);

    totalSupply = totalSupply.add(_value);

    emit Mint(msg.sender, _value);

    emit Transfer(address(0),msg.sender,_value);

    return true;

}



/**

* @dev Function to stop minting new tokens, when this function is called, function mint will be permanently disabled



*/



function finishMinting() public returns (bool) {

    require(msg.sender == owner);

    require(!mintingFinished);

    mintingFinished = true;

    emit MintFinished();

    return true;

}







/**

* @dev Transfer ownership of this contract to given address



* @param _newOwner new owner address



*/

function transferOwnership(address _newOwner) public {

  require(msg.sender == owner);

  owner = _newOwner;

    emit OwnershipTransferred(msg.sender,owner);

}



/**

* Ban address

*

* @param addr ban addr

*/

function ban(address addr) public {

    require(msg.sender == owner);

    blacklist[addr] = true;

}

/**

* Enable address

*

* @param addr enable addr

*/

function enable(address addr) public {

    require(msg.sender == owner);

    blacklist[addr] = false;

}





}

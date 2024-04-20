pragma solidity 0.6.8;



library SafeMath {

  /**

  * @dev Multiplies two unsigned integers, reverts on overflow.

  */

  function mul(uint256 a, uint256 b) internal pure returns (uint256) {

    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the

    // benefit is lost if 'b' is also tested.

    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522

    if (a == 0) {

        return 0;

    }



    uint256 c = a * b;

    require(c / a == b);



    return c;

  }



  /**

  * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.

  */

  function div(uint256 a, uint256 b) internal pure returns (uint256) {

    // Solidity only automatically asserts when dividing by 0

    require(b > 0);

    uint256 c = a / b;

    // assert(a == b * c + a % b); // There is no case in which this doesn't hold



    return c;

  }



  /**

  * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).

  */

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {

    require(b <= a);

    uint256 c = a - b;



    return c;

  }



  /**

  * @dev Adds two unsigned integers, reverts on overflow.

  */

  function add(uint256 a, uint256 b) internal pure returns (uint256) {

    uint256 c = a + b;

    require(c >= a);



    return c;

  }



  /**

  * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),

  * reverts when dividing by zero.

  */

  function mod(uint256 a, uint256 b) internal pure returns (uint256) {

    require(b != 0);

    return a % b;

  }

}



interface ERC20 {

  function balanceOf(address who) external view returns (uint256);

  function transfer(address to, uint value) external  returns (bool success);

}



contract ShabuOpenSale {

  using SafeMath for uint256;



  uint256 public totalSold;

  address payable public owner;

  uint256 public collectedETH;

  uint256 public startDate;

  bool public status = false;

  mapping (address => uint256) private _contributions;

  uint256 LIMIT_BUY = 5 ether;

  ERC20 public Token = ERC20(0xDA8DD97b9C0a4f4691e8C88Fe47c740b70D5A449);

  constructor() public {

    owner = msg.sender;

  }



 

  // Converts ETH to Tokens and sends new Tokens to the sender

  receive () external payable {

    deposit();

  }

  function deposit() public payable {

       // Validation

    require(Token.balanceOf(address(this)) > 0);

    require(msg.value >= 0.1 ether);

    require(status);

    uint256 amount = msg.value.mul(5);

    require(amount <= Token.balanceOf(address(this)));

    require(_contributions[msg.sender].add(msg.value) <= LIMIT_BUY);

    

    // transfer the tokens.

    Token.transfer(msg.sender, amount);

    // Transfer ETH to Owner

    owner.transfer(msg.value);

    // update constants.

    _contributions[msg.sender] = _contributions[msg.sender].add(msg.value);

    totalSold = totalSold.add(amount);

    collectedETH = collectedETH.add(msg.value);

  }

  function contributionCheck(address _address) public view returns(uint256) {

      return _contributions[_address];

  }

  // Function to query the supply of Tokens in the contract

  function availableTokens() public view returns(uint256) {

    return Token.balanceOf(address(this));

  }



  // OWNER FEATURE

  function statusPresale(bool _status) public {

    require(msg.sender == owner);

    status = _status;

  }

  function reclaim() public {

    require(msg.sender == owner && Token.balanceOf(address(this)) > 0);

    // burn the left over.

    Token.transfer(owner, Token.balanceOf(address(this)));

  }

 

  

  

}

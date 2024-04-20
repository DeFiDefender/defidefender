pragma solidity ^0.5.0;



/**

 * @dev Wrappers over Solidity's arithmetic operations with added overflow

 * checks.

 *

 * Arithmetic operations in Solidity wrap on overflow. This can easily result

 * in bugs, because programmers usually assume that an overflow raises an

 * error, which is the standard behavior in high level programming languages.

 * `SafeMath` restores this intuition by reverting the transaction when an

 * operation overflows.

 *

 * Using this library instead of the unchecked operations eliminates an entire

 * class of bugs, so it's recommended to use it always.

 */

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

        return sub(a, b, "SafeMath: subtraction overflow");

    }



    /**

     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on

     * overflow (when the result is negative).

     *

     * Counterpart to Solidity's `-` operator.

     *

     * Requirements:

     * - Subtraction cannot overflow.

     *

     * _Available since v2.4.0._

     */

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b <= a, errorMessage);

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

        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522

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

        return div(a, b, "SafeMath: division by zero");

    }



    /**

     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on

     * division by zero. The result is rounded towards zero.

     *

     * Counterpart to Solidity's `/` operator. Note: this function uses a

     * `revert` opcode (which leaves remaining gas untouched) while Solidity

     * uses an invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     * - The divisor cannot be zero.

     *

     * _Available since v2.4.0._

     */

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        // Solidity only automatically asserts when dividing by 0

        require(b > 0, errorMessage);

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

        return mod(a, b, "SafeMath: modulo by zero");

    }



    /**

     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),

     * Reverts with custom message when dividing by zero.

     *

     * Counterpart to Solidity's `%` operator. This function uses a `revert`

     * opcode (which leaves remaining gas untouched) while Solidity uses an

     * invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     * - The divisor cannot be zero.

     *

     * _Available since v2.4.0._

     */

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b != 0, errorMessage);

        return a % b;

    }

}



/* crowdsale interface needed for cross contract interaction */

contract CrowdSale {

  address public owner;

  function getOwner() public view returns(address) {

    return owner;

  }

}



contract CrowdsaleToken {

    using SafeMath for uint256;

    /* Public variables of the token */

    string public constant name = 'Rocketclock';

    string public constant symbol = 'RCLK';

    //uint256 public constant decimals = 6;

    address payable owner;

    address payable contractaddress;

    uint256 public constant totalSupply = 1000;



    /* This creates an array with all balances */

    mapping (address => uint256) public balanceOf;

    //mapping (address => mapping (address => uint256)) public allowance;



    /* This generates a public event on the blockchain that will notify clients */

    event Transfer(address payable indexed from, address payable indexed to, uint256 value);

    //event LogWithdrawal(address receiver, uint amount);



    modifier onlyOwner() {

        // Only owner is allowed to do this action.

        if (msg.sender != owner) {

            revert();

        }

        _;

    }



    /* Initializes contract with initial supply tokens to the creator of the contract */

    constructor() public{

        contractaddress = address(this);

        owner = msg.sender;

        balanceOf[owner] = totalSupply;

        //balanceOf[contractaddress] = totalSupply;



    }



    /*ERC20*/

    /* Internal transfer, only can be called by this contract */

    function _transfer(address payable _from, address payable _to, uint256 _value) internal {

    //function _transfer(address _from, address _to, uint _value) public {

        require (_to != address(0x0));                      // Prevent transfer to 0x0 address. Use burn() instead

        require (balanceOf[_from] > _value);                // Check if the sender has enough

        require (balanceOf[_to].add(_value) > balanceOf[_to]); // Check for overflows

        balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the sender

        balanceOf[_to] = balanceOf[_to].add(_value);        // Add the same to the recipient

        emit Transfer(_from, _to, _value);

    }



    /// @notice Send `_value` tokens to `_to` from your account

    /// @param _to The address of the recipient

    /// @param _value the amount to send

    function transfer(address payable _to, uint256 _value) public returns (bool success) {



        _transfer(msg.sender, _to, _value);

        return true;



    }



    /*

    * Returns unsold tokens to owner - mainly for development and testing

    * _from : crowdsale address

    */

    function crownfundTokenBalanceToOwner(address payable _from) public onlyOwner returns (bool success) {

      // owner can not move tokens from participants

      CrowdSale c = CrowdSale(_from);

      address crowdsaleOwner = c.getOwner();

      if (crowdsaleOwner == owner ) {

        uint256 _value = balanceOf[_from];

        balanceOf[_from] = 0;

        balanceOf[owner] = balanceOf[owner].add(_value);

        emit Transfer(_from, owner, _value);

        return true;

      }

      else{

        return false;

      }



    }



    /*fallback function*/

    function () external payable onlyOwner{}





    function getBalance(address addr) public view returns(uint256) {

      return balanceOf[addr];

    }



    function getEtherBalance() public view returns(uint256) {

      //return contract ether balance;

      return address(this).balance;

    }



    function getOwner() public view returns(address) {

      return owner;

    }



}

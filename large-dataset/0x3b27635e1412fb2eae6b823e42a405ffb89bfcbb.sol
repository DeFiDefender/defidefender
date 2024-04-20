pragma solidity 0.5.16;



contract ERC20 {



    function transferFrom (address,address, uint256) external returns (bool);



}



contract Owned {



    address public owner;

    address public newOwner;



    event OwnershipTransferred(address indexed from, address indexed _to);



    constructor(address _owner) public {

        owner = _owner;

    }



    modifier onlyOwner {

        require(msg.sender == owner);

        _;

    }



    function transferOwnership(address _newOwner) public onlyOwner {

        newOwner = _newOwner;

    }

    function acceptOwnership() public {

        require(msg.sender == newOwner);

        emit OwnershipTransferred(owner, newOwner);

        owner = newOwner;

        newOwner = address(0);

    }

}



contract Pausable is Owned {

    event Pause();

    event Unpause();



    bool public paused = false;



    modifier whenNotPaused() {

      require(!paused);

      _;

    }



    modifier whenPaused() {

      require(paused);

      _;

    }



    function pause() onlyOwner whenNotPaused public {

      paused = true;

      emit Pause();

    }



    function unpause() onlyOwner whenPaused public {

      paused = false;

      emit Unpause();

    }

}





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



}





contract lockingContract is Pausable{



    using SafeMath for uint256;

    

    address public oldFessToken;  

    address public newFessToken;



    address public fessOwner;

    

    mapping (address => uint256) public tokens;

    mapping (address => uint256) public claimedTokens;

    mapping (address => uint256 ) public lockedAt;

    mapping (address => uint256) public oldOrNeW;

    mapping (address => uint256) public claimableToken;





    constructor(address _oldTokens, address _newToken, address payable _ownerAddress) public Owned(_ownerAddress) {





    oldFessToken = _oldTokens;

    newFessToken = _newToken;





    }





   function setfessOwner (address _fessOwner) external onlyOwner returns (bool) {

       

       fessOwner = _fessOwner;

       

   }



   function lockTokens (address [] calldata userAddress, uint256  [] calldata value, uint256 oldNew) external 



    {



          require (oldNew == 1 || oldNew ==2);// 1 for old 2 for new

          require(userAddress.length == value.length,"Invalid Array");





          for (uint8 i = 0; i < userAddress.length; i++){



            tokens[userAddress[i]] = value[i].mul(1 ether);

            lockedAt[userAddress[i]] = now;

            oldOrNeW[userAddress[i]] = oldNew; 



              

          }

          

    }





    function calculatePayout (address userAddress) public view returns (uint256) {

    

        if (tokens[userAddress] > 0){

            

        uint256 preSaleCycle = getCycle(userAddress);

        uint256 onePercentOfInitialFund = tokens[userAddress].div(730);

        

        if(claimedTokens[userAddress] != onePercentOfInitialFund.mul(preSaleCycle)) {

            

        uint256 tokenToSend = onePercentOfInitialFund.mul(preSaleCycle).sub(claimedTokens[userAddress]);

        return  tokenToSend;





        }

            

            

        } 

    

    }





   function payout() external returns (bool) {

       

        require(tokens[msg.sender] > 0, "tokens not locked");

        require(now >= lockedAt[msg.sender].add(86400),"Time period "); //1 days



        uint256 preSaleCycle = getCycle(msg.sender);

        require (preSaleCycle > 0, "cycle greater then zero");

        uint256 onePercentOfInitialFund = tokens[msg.sender].div(730);



        if(claimedTokens[msg.sender] != onePercentOfInitialFund.mul(preSaleCycle)) {

            

        uint256 tokenToSend = onePercentOfInitialFund.mul(preSaleCycle).sub(claimedTokens[msg.sender]);

        claimedTokens[msg.sender] = onePercentOfInitialFund.mul(preSaleCycle);



        if (oldOrNeW[msg.sender] ==1) {



        require(ERC20(oldFessToken).transferFrom(fessOwner,msg.sender,tokenToSend), "token transfer failed");            

            

        }

        else if (oldOrNeW[msg.sender] ==1) {

            

        require(ERC20(newFessToken).transferFrom(fessOwner,msg.sender,tokenToSend), "token transfer failed");

        

        }

        return true;



        } else {

            

            revert ();

        }       

       

       

   } 



    /**

     * @dev  get cycle for payout 

     */

    function getCycle(address userAddress) internal view returns (uint256){

     



      uint256 cycle = now.sub(lockedAt[userAddress]);

    

     if(cycle <= 1 days) //should be greater then 1 day

     {

         return 0;

     }

     else if (cycle >= 1 days && cycle <= 730 days) //greater then 1 day  

     {     

    

      uint256 secondsToHours = cycle.div(86400);//21600 6 hours

      return secondsToHours;

     

     }



    }    



  

}

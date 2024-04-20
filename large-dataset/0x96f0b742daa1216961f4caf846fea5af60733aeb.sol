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



contract CrowdSale {

    using SafeMath for uint256;



    address payable public beneficiary;

    address payable public crowdsaleAddress;

    //debugging

    address payable public tokenAddress;

    address payable public owner;

    uint public fundingGoal;

    uint public amountRaised;

    uint public tokensSold;

    //crowdsaledeadline

    uint public deadline;

    //download Deadline

    uint public downloaddeadline;

    //emergencydeadline

    uint public emergencydeadline;

    uint public initiation;

    //uint public price;

    //0.25 eth = 250 finney

    // total price is 150 price + 100 collateral that participants get back when calling download function

    uint256 public constant totalprice = 250 finney;

    uint256 public constant price = 150 finney;

    uint256 public constant collateral = 100 finney;

    // amount of tokens participants receive

    uint public constant amount = 1;

    // the amount of tokens owner must have before he can withdraw crowdfund

    uint public constant tokenGoal = 990;



    CrowdsaleToken public tokenReward;

    //ether balance

    mapping(address => uint256) public balanceOf;

    // to give participants an incentive to claim their tokens for download

    mapping(address => uint256) public balanceCollateral;

    bool public fundingGoalReached = false;

    bool public crowdsaleClosed = false;



    event GoalReached(address beneficiary, uint amountRaised);

    event FundTransfer(address backer, uint amount, bool isContribution);



    modifier onlyOwner() {

        // Only owner is allowed to do this action.

        if (msg.sender != owner) {

            revert();

        }

        _;

    }



    /**

     * Constructor function

     *

     * Setup the owner

     */

    constructor(

        address payable ifSuccessfulSendTo,

        address payable addressOfTokenUsedAsReward

    )public {

        beneficiary = ifSuccessfulSendTo;

        fundingGoal = 75 * 1 ether;

        //crowdfund deadline

        deadline = now + 60 * 1 days;

        //download deadline

        downloaddeadline = now + 120 * 1 days;

        //this is to prevent eth from getting locked up in the contract in case something goes wrong

        //this means if the project fails to deliver, participants have 60 days to withdraw their contribution

        emergencydeadline = now + 180 * 1 days;

        initiation = now;

        crowdsaleAddress = address(this);

        tokenAddress = addressOfTokenUsedAsReward;

        tokenReward = CrowdsaleToken(addressOfTokenUsedAsReward);

        owner = msg.sender;

    }



    /**

     * Fallback function

     *

     * The function without name is the default function that is called whenever anyone sends funds to a contract

     */



    function () external payable {



      require(!crowdsaleClosed);

      if (now <= deadline){



        uint256 _value = msg.value;

        if(_value >= totalprice){

          //add amount of eth sent minus collateral

          uint256 _value_price = _value.sub(collateral);

          balanceOf[msg.sender] = balanceOf[msg.sender].add(_value_price);

          //add collateral to collateral balance

          balanceCollateral[msg.sender] = balanceCollateral[msg.sender].add(collateral);

          tokensSold += amount;

          amountRaised += _value_price;

          tokenReward.transfer(msg.sender, amount);

          emit FundTransfer(msg.sender, amount, true);

        }

        else{

          //donation

          amountRaised += msg.value;

        }

      }

      else{

        revert();

      }



    }



    modifier afterDeadline() { if (now >= deadline) _; }

    modifier afterDownloadDeadline() { if (now >= downloaddeadline) _; }

    modifier afterEmergencyDeadline() { if (now >= emergencydeadline) _; }

    modifier goalReached() { if (amountRaised >= fundingGoal) _; }



    /**

     * Check if goal was reached

     *

     * Checks if the goal or time limit has been reached and ends the campaign

     */

    function checkGoalReached() public afterDeadline returns(bool) {

        if (amountRaised >= fundingGoal){

            fundingGoalReached = true;

            emit GoalReached(beneficiary, amountRaised);

        }

        crowdsaleClosed = true;

        return crowdsaleClosed;

    }



    /*

    * Add owner and crowdsale balance together

    *

    */

    function getCrowdsaleOwnerTokenBalance() view public returns (uint256){



      uint256 ownertokenbalance = tokenReward.getBalance(owner);

      uint256 crowdsaletokenbalance = tokenReward.getBalance(crowdsaleAddress);

      uint256 total = ownertokenbalance.add(crowdsaletokenbalance);

      return total;

    }



    /*

    * to receive downloadlink you need to send token back to owner

    * don't use this function untill dev communicates it's ready!!

    */

    function getDownload() public afterDeadline returns(bool) {



      if (tokenReward.getBalance(msg.sender) >= amount){

        // tokens are returned to owner

        tokenReward.transfer(owner, amount);

        emit FundTransfer(owner, amount, true);



        // collateral is returned to participant

        uint256 returnamount = balanceCollateral[msg.sender];

        balanceCollateral[msg.sender] = 0;

        // refunds

        if (returnamount > 0) {

            if (msg.sender.send(returnamount)) {

                emit FundTransfer(msg.sender, returnamount, false);

            } else {

                balanceCollateral[msg.sender] = returnamount;

            }

        }

        // check javascript function that handles download distribution

        return true;

      }

      else{

        return false;

      }



    }



    /**

     * Withdraw the funds

     *

     * Checks to see if goal or time limit has been reached, and if so, and the funding goal was not reached, each contributor can withdraw

     * the amount they contributed.

     */

    function safeWithdrawal() public afterDeadline {

        if (!fundingGoalReached) {

            //return balance + collateral

            uint256 returnamount = balanceOf[msg.sender].add(balanceCollateral[msg.sender]);

            balanceOf[msg.sender] = 0;

            balanceCollateral[msg.sender] = 0;

            // refunds

            if (returnamount >= totalprice) {

                if (msg.sender.send(returnamount)) {

                    emit FundTransfer(msg.sender, returnamount, false);

                } else {

                    balanceOf[msg.sender] = returnamount;

                }

            }

        }



    }



    /*

    * Withdraw funds after the download deadline, if download was not delivered.

    * We know download was not delivered because owner has not received all tokens back

    *

    */

    function safeWithdrawalNoDownload() public afterDownloadDeadline {

        /* people need to send coins back to owner to get a download link */

        /* if balance of owner is not close to 1000 ( > 990), users have voted against */

        // must be tokenbalance

        if (this.getCrowdsaleOwnerTokenBalance() < tokenGoal) {

            uint256 returnamount = balanceOf[msg.sender].add(balanceCollateral[msg.sender]);

            balanceOf[msg.sender] = 0;

            balanceCollateral[msg.sender] = 0;

            // refunds

            if (returnamount >= totalprice) {

                if (msg.sender.send(returnamount)) {

                    emit FundTransfer(msg.sender, returnamount, false);

                } else {

                    balanceOf[msg.sender] = returnamount;

                }

            }

        }



    }



    /*

    * Owner can only withdraw if downloads have been distributed before downloaddeadline

    * To receive download users must send token back to owner

    */

    function crowdfundWithdrawal() public afterDownloadDeadline onlyOwner {

      // only if almost everyone has returned their token to owner will owner be able to withdraw crowdfund

      // getCrowdsaleOwnerTokenBalance() adds balance of crowdfund and owner together

      if (this.getCrowdsaleOwnerTokenBalance() >= tokenGoal){

        if (fundingGoalReached && beneficiary == msg.sender) {



          //users need to send their token back to owner to download

          if (beneficiary.send(amountRaised)) {

              emit FundTransfer(beneficiary, amountRaised, false);

          }



        }

      }



    }



    /*

    * In case something goes wrong

    * If project does not deliver, participants have 60 days before the contract balance can be emptied by the owner

    */

    function emergencyWithdrawal() public afterEmergencyDeadline onlyOwner {



        if (beneficiary == msg.sender) {



          if (beneficiary.send(address(this).balance)) {

              emit FundTransfer(beneficiary, address(this).balance, false);

          }



        }



    }



    /* in case goal is reached early, close crowdsale deadline */

    function closeDeadline() public goalReached onlyOwner {

      deadline = now;

    }



    function getcrowdsaleClosed() public view returns(bool) {

      return crowdsaleClosed;

    }



    function getfundingGoalReached() public view returns(bool) {

      return fundingGoalReached;

    }



    function getOwner() public view returns(address) {

      return owner;

    }



    function getbalanceOf(address _from) public view returns(uint256) {

      return balanceOf[_from];

    }



}

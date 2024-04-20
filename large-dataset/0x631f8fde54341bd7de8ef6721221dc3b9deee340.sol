// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol



pragma solidity ^0.5.0;



/**

 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include

 * the optional functions; to access them see `ERC20Detailed`.

 */

interface IERC20 {

    /**

     * @dev Returns the amount of tokens in existence.

     */

    function totalSupply() external view returns (uint256);



    /**

     * @dev Returns the amount of tokens owned by `account`.

     */

    function balanceOf(address account) external view returns (uint256);



    /**

     * @dev Moves `amount` tokens from the caller's account to `recipient`.

     *

     * Returns a boolean value indicating whether the operation succeeded.

     *

     * Emits a `Transfer` event.

     */

    function transfer(address recipient, uint256 amount) external returns (bool);



    /**

     * @dev Returns the remaining number of tokens that `spender` will be

     * allowed to spend on behalf of `owner` through `transferFrom`. This is

     * zero by default.

     *

     * This value changes when `approve` or `transferFrom` are called.

     */

    function allowance(address owner, address spender) external view returns (uint256);



    /**

     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.

     *

     * Returns a boolean value indicating whether the operation succeeded.

     *

     * > Beware that changing an allowance with this method brings the risk

     * that someone may use both the old and the new allowance by unfortunate

     * transaction ordering. One possible solution to mitigate this race

     * condition is to first reduce the spender's allowance to 0 and set the

     * desired value afterwards:

     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729

     *

     * Emits an `Approval` event.

     */

    function approve(address spender, uint256 amount) external returns (bool);



    /**

     * @dev Moves `amount` tokens from `sender` to `recipient` using the

     * allowance mechanism. `amount` is then deducted from the caller's

     * allowance.

     *

     * Returns a boolean value indicating whether the operation succeeded.

     *

     * Emits a `Transfer` event.

     */

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);



    /**

     * @dev Emitted when `value` tokens are moved from one account (`from`) to

     * another (`to`).

     *

     * Note that `value` may be zero.

     */

    event Transfer(address indexed from, address indexed to, uint256 value);



    /**

     * @dev Emitted when the allowance of a `spender` for an `owner` is set by

     * a call to `approve`. `value` is the new allowance.

     */

    event Approval(address indexed owner, address indexed spender, uint256 value);

}



// File: openzeppelin-solidity/contracts/math/SafeMath.sol



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



// File: contracts/E20Incentive.sol



pragma solidity 0.5.11;







/**

 * @title E20 Incentive contract

 * @dev This contract manages the logic for a compensation scheme as an incentive for token transfers and sharing.

 */

contract E20Incentive {

    //This contract uses a library for Safe Maths from OpenZeppelin

    using SafeMath for uint;

    //SetUp Variables

    uint public ethFee; //Fee amount in ETH for subscription

    uint public minToken; //Minimum amount of tokens required to get a subscription

    uint public maxToken; //Maximum amount of tokens allowed to get a subscription

    uint public intRate; //Fixed interest rate expressed from 0 to 1000 (0-100%) (ex: 1% = 10)

    uint public intRounds; //Number of rounds to be allowed on a session

    uint public bonusRate; //Fixed bonus rate expressed from 0 to 1000 (0-100%) (ex: 1% = 10)

    IERC20 public tokenAddress; //Address of token to be used

    address payable public platformWallet; //Address of platform manager

    address payable public nextPlatformWallet; //Address of platform manager

    uint public claimTime; //Time for each round



    //Definition of a user account

    struct UserAccount {

        uint userBalance; //How much the user have deposited

        uint intPaid; //How much interest the contract have paid to the user

        uint intRound; //Which round is currently running

        uint lastClaim; //Last claim time stamp

        bool bonusClaimed; //Bonus claim flag

        bool extension; //Session extension flag

    }

    //Mapping to register users' accounts

    mapping (address=>UserAccount) public userAccounts;



    //Total contract balance handler

    uint private contractUsersBalance;



    //EVENTS

    event SessionClaim(address indexed _user, uint _amount, uint round);

    event SessionBegin(address indexed _user, uint _balance);

    event SessionExtended(address indexed _user, uint _balance);

    event SessionEnd(address indexed _user, uint _intPaid);



    /**

     * @dev Constructor for the main contract

     * @param _tokenAddress Adress of token to be incentivized

     * @param _ethFee eth fee to be used for contract transactions

     * @param _minToken minimum amount of tokens to be deposited

     * @param _maxToken maximum amount of tokens to be deposited

     * @param _intRate interest rate multiplied by 1000

     * @param _intRounds interest rounds per session

     * @param _bonusRate bonus interest rate multiplied by 1000

     * @param _claimTime time per round in epoch format

     * @param _platformWallet initial address of platform manager

     */

    constructor(

        IERC20 _tokenAddress,

        uint _ethFee,

        uint _minToken,

        uint _maxToken,

        uint _intRate,

        uint _intRounds,

        uint _bonusRate,

        uint _claimTime,

        address payable _platformWallet

        ) public {

        tokenAddress = _tokenAddress;

        ethFee = _ethFee;

        minToken = _minToken;

        maxToken = _maxToken;

        intRate = _intRate;

        intRounds = _intRounds;

        bonusRate = _bonusRate;

        claimTime = _claimTime;

        platformWallet = _platformWallet;

    }



    /**

     * @dev This function allows a token holder to open an account on this contract and benefit from it

     * @param _amount is the number of tokens to be deposited on the contract

     */

    function deposit(uint _amount) public payable {

        //Require the eth fee

        require(msg.value == ethFee, "Please send the required fee amount for transactions");

        //Require the amount of tokens to be deposited to be between limits

        require(_amount >= minToken && _amount <= maxToken, "The amount of tokens must be between the set limits");

        //Require user to provide allowance on the amount of tokens to be deposited

        require(tokenAddress.allowance(msg.sender,address(this)) >= _amount, "Please assign the required allowance to the contract address");

        //Require the transfer from user's wallet to be successful

        require(tokenAddress.transferFrom(msg.sender,address(this),_amount), "Error on token transfer using function transferFrom");

        //Send ETH to Platform Wallet

        platformWallet.transfer(address(this).balance);

        //Update contract user's balance

        contractUsersBalance = contractUsersBalance.add(_amount);

        //Check if the user is getting registered for the first time

        if (userAccounts[msg.sender].intRound == 0) {

            //If it is, create a new user account

            userAccounts[msg.sender] = UserAccount({

                userBalance: _amount,

                intPaid: 0,

                intRound: 0,

                lastClaim: now,

                bonusClaimed: false,

                extension: false});



            emit SessionBegin(msg.sender,_amount);



        } else if (userAccounts[msg.sender].intRound == intRounds && userAccounts[msg.sender].extension == false) {

            //If it's not but the user is allowed to claim an extension, update it's account

            userAccounts[msg.sender].userBalance = _amount;

            userAccounts[msg.sender].lastClaim = now;

            userAccounts[msg.sender].extension = true;



            emit SessionExtended(msg.sender, _amount);



        } else {

            //If doesn't fall in any case, revert the transaction

            revert("You cannot renew your suscription");

        }

    }



    /**

     * @dev A function to allow users to claim their benefits from the contract

     */

    function claim() public {

        //Require the user to hold some balance ont he contract

        require(userAccounts[msg.sender].userBalance != 0, "You don't have anything to claim");

        //Require te user to have passed the minimum round time

        require(now.sub(userAccounts[msg.sender].lastClaim) >= claimTime, "The claimTime have not passed yet, try again later");



        uint intToPay; //Aux variable to handle interest calculation

        uint toTransfer; //Aux variable to handle total transfer amount

        userAccounts[msg.sender].lastClaim = now; //Update last claim time

        userAccounts[msg.sender].intRound = userAccounts[msg.sender].intRound.add(1); //Update round



        //Check if the user have claimed the bonus

        if(userAccounts[msg.sender].bonusClaimed == false) {

            //If it's not, update the account flag

            userAccounts[msg.sender].bonusClaimed = true;

            //Calculate the bonus

            intToPay = userAccounts[msg.sender].userBalance.mul(bonusRate);

            intToPay = intToPay.div(1000);

        } else {

            //If it already claimed the bonus, calculate normal interest

            intToPay = userAccounts[msg.sender].userBalance.mul(intRate);

            intToPay = intToPay.div(1000);

        }



        //Update interest paid

        userAccounts[msg.sender].intPaid = userAccounts[msg.sender].intPaid.add(intToPay);



        //Check if user is on final round

        if((userAccounts[msg.sender].extension == false && userAccounts[msg.sender].intRound == intRounds) ||

           (userAccounts[msg.sender].extension == true && userAccounts[msg.sender].intRound == intRounds.mul(2))

        ){

            //If it is, get user balance on contract

            toTransfer = userAccounts[msg.sender].userBalance;

            //Update contract user's balance

            contractUsersBalance = contractUsersBalance.sub(userAccounts[msg.sender].userBalance);

            //And reset user balance on contract to 0

            userAccounts[msg.sender].userBalance = 0;



            emit SessionEnd(msg.sender, userAccounts[msg.sender].intPaid);

        }



        //SumUp amount to transfer

        toTransfer = toTransfer.add(intToPay);



        //Require transfer to be done

        require(tokenAddress.transfer(msg.sender,toTransfer), "Error on token transfer using function transfer");



        emit SessionClaim(msg.sender, userAccounts[msg.sender].intPaid, userAccounts[msg.sender].intRound);



    }



    /**

     * @dev Function to retrieve any stuck token on the contract, it can only be used by the platform wallet owner

     * @param _tokenAddress Token contract address

     * @param _value amount of tokens to move

     * @param _to address to move tokens to

     */

    function ERC20Recovery(IERC20 _tokenAddress, uint _value, address _to) public{

        //Only the contract platform wallet owner is allowed to use this function

        require(msg.sender == platformWallet, "You are not allowed to use this function");



        if(tokenAddress == _tokenAddress){

            //Check that the platform manager is not retrieven user's tokens

            uint currentContractsBalance = tokenAddress.balanceOf(address(this));

            require(currentContractsBalance.sub(_value) >= contractUsersBalance, "You are not allowed to retrieve user's tokens");

            tokenAddress.transfer(_to,_value);

        } else {

            _tokenAddress.transfer(_to,_value);

        }

    }



    /**

    * @dev Function to allow the manager to propose a new manager wallet

    * @param _newPlatformWallet the new wallet to be used as manager one

    */

    function proposePlatformWallet(address payable _newPlatformWallet) public {

        //Only the contract platform wallet owner is allowed to use this function

        require(msg.sender == platformWallet, "You are not allowed to use this function");

        require(_newPlatformWallet != address(0), "New wallet must be different from zero");

        nextPlatformWallet = _newPlatformWallet;

    }



    /**

     * @dev Function to accept or reject the contract management ownership

     * @param _accept boolean answer: Accep = true, Reject = false

     */

    function acceptPlatformWallet(bool _accept) public {

        //Only the new contract platform wallet owner is allowed to use this function

        require(msg.sender == nextPlatformWallet, "You are not allowed to use this function");

        if(_accept) {

            platformWallet = nextPlatformWallet;

            nextPlatformWallet = address(0);

        } else {

            nextPlatformWallet = address(0);

        }

    }



    /**

     * @dev FallBack function will forward to claim function

     */

    function() external {

        claim();

    }



}

/**

 *Submitted for verification at Etherscan.io on 2020-11-03

*/



pragma solidity ^0.5.7;



/**

 * @dev Interface of the ERC20 standard as defined in the EIP.

 */

interface IERC20 {

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);

}



/**

 * @title SafeMath

 * @dev Unsigned math operations with safety checks that revert on error.

 */

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



contract MS_Unlimited_Bank {

    using SafeMath for uint256;



    // 1%

  uint256 constant public BASE_PERCENT = 10;

    uint256 constant public WitFEE = 100;

  uint256 constant public PERCENTS_DIVIDER = 1000;

  uint256 constant public CONTRACT_BALANCE_STEP = 100 ether;

  uint256 constant public INVEST_MIN_AMOUNT = 1 ether;

  uint256 constant public TIME_STEP = 1 days;

  

  // \u7528\u6237\u603b\u91cf

  uint256 public totalUsers;

    // \u8d44\u91d1\u6c60\u5b58\u5165\u603b\u91cf

  uint256 public totalInvested;

    // \u603b\u63d0\u5e01

  uint256 public totalWithdrawn;

    // \u603b\u5b58\u5165\u7b14\u6570

  uint256 public totalDeposits;

  // Ms \u5408\u7ea6\u5730\u5740

  address public MS;

  // \u624b\u7eed\u8d39\u63a5\u6536

  address public FeeAddr;

  

  // \u7528\u6237

  struct Deposit {

    uint256 amount;     // \u5b58\u5165\u6570\u91cf

    uint256 withdrawn;  // \u63d0\u51fa\u6570\u91cf

    uint256 start;      // \u5b58\u5165\u65f6\u95f4

  }

  struct User {

    Deposit[] deposits;     // n\u7b14\u5b58\u6b3e

    uint256 checkpoint;     // \u63d0\u5e01\u65f6\u95f4 \uff5c \u521d\u6b21\u5145\u5e01\u65f6\u95f4 \uff08\u4ee5\u5f53\u524d\u65f6\u95f4\u8ba1\u7b9724\u5c0f\u65f6\u5229\u7387\uff09

    address referrer;       // \u4e0a\u7ea7

    uint256 inviteRate;          // \u63a8\u8350\u5956\u52b1 \u5229\u7387 

  }

  mapping (address => User) internal users;

  

  event Newbie(address user);

  event NewDeposit(address indexed user, uint256 amount);

  event Withdrawn(address indexed user, uint256 amount);



    constructor(address _ms,address _fee) public{

        MS = _ms;

        FeeAddr = _fee;

    }

    

   // \u5145\u503c

  function invest(address referrer,uint256 value) public {

      require(value >= INVEST_MIN_AMOUNT,"Minimum recharge 1 MS ");

        IERC20(MS).transferFrom(msg.sender,address(this),value);

        

      User storage user = users[msg.sender];

    if (user.referrer == address(0) && users[referrer].deposits.length > 0 && referrer != msg.sender) {

            // \u6dfb\u52a0\u4e0a\u7ea7\u5e76\u8ba1\u7b97\u9080\u8bf7\u5229\u7387

            user.referrer = referrer;

            uint256 amount = getUserTotalDeposits(referrer);

            if (value >= amount){

                users[referrer].inviteRate = users[referrer].inviteRate.add(10);

            }else{

                users[referrer].inviteRate = users[referrer].inviteRate.add((value.mul(10)).div(amount));

            }

    }

    

    if (user.deposits.length == 0) {

      user.checkpoint = block.timestamp;

      totalUsers = totalUsers.add(1);

      emit Newbie(msg.sender);

    }

    user.deposits.push(Deposit(value, 0, block.timestamp));

    totalInvested = totalInvested.add(value);

    totalDeposits = totalDeposits.add(1);

    emit NewDeposit(msg.sender, value);

  }

  

  // \u63d0\u73b0

  function withdraw() public {

    User storage user = users[msg.sender];

    // \u603b\u5229\u7387

      uint256 userPercentRate = totalInterestRate(msg.sender);

     

      uint256 totalAmount;

    uint256 dividends;

    for (uint256 i = 0; i < user.deposits.length; i++) {

        // 2\u500d\u51fa\u5c40

        if (user.deposits[i].withdrawn < user.deposits[i].amount.mul(2)) {

            // \u4ee5\u5f53\u524d\u8fd9\u7b14\u5b58\u6b3e\u8d77\u59cb\u65f6\u95f4\u8ba1\u7b97\u5229\u606f

            if (user.deposits[i].start > user.checkpoint) {

                dividends = (user.deposits[i].amount.mul(userPercentRate).div(PERCENTS_DIVIDER))

            .mul(block.timestamp.sub(user.deposits[i].start))

            .div(TIME_STEP);

            }else{

                // \u4ee5\u8d77\u59cb\u65f6\u95f4\u8ba1\u7b97\u5229\u606f

                dividends = (user.deposits[i].amount.mul(userPercentRate).div(PERCENTS_DIVIDER))

            .mul(block.timestamp.sub(user.checkpoint))

            .div(TIME_STEP);

            }

            // \u5229\u606f\u9ad8\u4e8e\u672c\u91d12\u500d \u51cf\u6389 \u591a\u4f59\u5229\u606f

            if (user.deposits[i].withdrawn.add(dividends) > user.deposits[i].amount.mul(2)) {

                    dividends = (user.deposits[i].amount.mul(2)).sub(user.deposits[i].withdrawn);

        }

        // \u6dfb\u52a0\u63d0\u5e01\u6570\u91cf

        user.deposits[i].withdrawn = user.deposits[i].withdrawn.add(dividends); /// changing of storage data

        totalAmount = totalAmount.add(dividends);

        }

    }

    

    require(totalAmount > 0, "User has no dividends");

    uint256 contractBalance = IERC20(MS).balanceOf(address(this));

    if (contractBalance < totalAmount) {

      totalAmount = contractBalance;

    }

    user.checkpoint = block.timestamp;

    

        // 10%

        uint256 fee = totalAmount.div(10);

    IERC20(MS).transfer(FeeAddr,fee);

    

    IERC20(MS).transfer(msg.sender,totalAmount.sub(fee));

    totalWithdrawn = totalWithdrawn.add(totalAmount);

    emit Withdrawn(msg.sender, totalAmount);

  }

  

  // \u5229\u606f\u8ba1\u7b97

  function getUserDividends(address userAddress) public view returns (uint256) {

      User storage user = users[userAddress];

      // \u603b\u5229\u7387

      uint256 userPercentRate = totalInterestRate(userAddress);

      // \u603b\u5229\u606f

    uint256 totalDividends;



    uint256 dividends;

    for (uint256 i = 0; i < user.deposits.length; i++) {

        // 2\u500d\u51fa\u5c40

        if (user.deposits[i].withdrawn < user.deposits[i].amount.mul(2)) {

                // \u5982\u679c\u8fd9\u7b14\u94b1\u5b58\u7684\u6bd4\u8f83\u665a(\u8ffd\u6295) \u5219\u6309\u7167\u8fd9\u7b14\u94b1\u7684\u6295\u5165\u662f\u8ba1\u7b97 

            if (user.deposits[i].start > user.checkpoint) {

                dividends = (user.deposits[i].amount.mul(userPercentRate).div(PERCENTS_DIVIDER))

            .mul(block.timestamp.sub(user.deposits[i].start))

            .div(TIME_STEP);

            }else{

                dividends = (user.deposits[i].amount.mul(userPercentRate).div(PERCENTS_DIVIDER))

            .mul(block.timestamp.sub(user.checkpoint))

            .div(TIME_STEP);

            }

            if (user.deposits[i].withdrawn.add(dividends) > user.deposits[i].amount.mul(2)) {

                    dividends = (user.deposits[i].amount.mul(2)).sub(user.deposits[i].withdrawn);

        }

        totalDividends = totalDividends.add(dividends);

        }

    }

    return totalDividends;

  }

    

  // \u5408\u7ea6\u5229\u7387\uff1a10 + (\u5408\u7ea6\u603b\u989d / 100ETH)

  function getContractBalanceRate() public view returns (uint256) {

    return BASE_PERCENT.add(IERC20(MS).balanceOf(address(this)).div(CONTRACT_BALANCE_STEP));

  }

  

  // \u7528\u6237\u5229\u7387\uff1a (\u5f53\u524d\u65f6\u95f4 - \u8d77\u59cb\u65f6\u95f4) / 86400 * 10

  function getUserPercentRate(address userAddress) public view returns (uint256){

      User storage user = users[userAddress];

      if (isActive(userAddress)) {

          return ((now.sub(user.checkpoint)).div(TIME_STEP)).mul(10);

      }

        return 0;

  }

  

  // \u9080\u8bf7\u5229\u7387

  function getUserInviteRate(address userAddress) public view returns(uint256){

      return users[userAddress].inviteRate;

  }

  

  // \u603b\u5229\u7387 = \u5408\u7ea6\u5229\u7387 + \u7528\u6237\u5229\u7387 + \u9080\u8bf7\u5229\u7387

  function totalInterestRate(address userAddress) public view returns(uint256){

      return getContractBalanceRate().add(getUserPercentRate(userAddress)).add(getUserInviteRate(userAddress));

  }

  

  // \u83b7\u53d6\u5408\u7ea6\u4f59\u989d

  function getContractBalance() public view returns (uint256) {

    return IERC20(MS).balanceOf(address(this));

  }



  // \u83b7\u53d6\u7528\u623724h\u6536\u76ca\u5f00\u59cb\u8ba1\u7b97\u65f6\u95f4\u70b9

  function getUserCheckpoint(address userAddress) public view returns(uint256) {

    return users[userAddress].checkpoint;

  }

  

  // \u83b7\u53d6\u7528\u6237\u63a8\u8350\u4eba (\u4e0a\u7ea7)

  function getUserReferrer(address userAddress) public view returns(address) {

    return users[userAddress].referrer;

  }

  

  // \u83b7\u53d6\u7528\u6237\u5b58\u6b3e\u4fe1\u606f

  function getUserDepositInfo(address userAddress, uint256 index) public view returns(uint256, uint256, uint256) {

      User storage user = users[userAddress];

    return (user.deposits[index].amount, user.deposits[index].withdrawn, user.deposits[index].start);

  }



    // \u83b7\u53d6\u7528\u6237\u5b58\u5165\u7b14\u6570

  function getUserAmountOfDeposits(address userAddress) public view returns(uint256) {

    return users[userAddress].deposits.length;

  }

  

  // \u83b7\u53d6\u7528\u6237\u5b58\u5165\u603b\u989d

  function getUserTotalDeposits(address userAddress) public view returns(uint256) {

      User storage user = users[userAddress];

    uint256 amount;

    for (uint256 i = 0; i < user.deposits.length; i++) {

      amount = amount.add(user.deposits[i].amount);

    }

    return amount;

  }

  

  // \u83b7\u53d6\u7528\u6237\u63d0\u5e01\u603b\u989d

  function getUserTotalWithdrawn(address userAddress) public view returns(uint256) {

      User storage user = users[userAddress];

    uint256 amount;

    for (uint256 i = 0; i < user.deposits.length; i++) {

      amount = amount.add(user.deposits[i].withdrawn);

    }

    return amount;

  }

  

  // \u662f\u5426\u6d3b\u8dc3

  function isActive(address userAddress) public view returns (bool) {

    User storage user = users[userAddress];

    if (user.deposits.length > 0) {

      if (user.deposits[user.deposits.length-1].withdrawn < user.deposits[user.deposits.length-1].amount.mul(2)) {

        return true;

      }

    }

  }

}

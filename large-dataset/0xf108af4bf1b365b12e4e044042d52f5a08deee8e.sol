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



contract ms_contract {

    using SafeMath for uint256;

    

    bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));

  

  uint256 constant public BASE_PERCENT = 10;

        uint256 constant public WitFEE = 100;

  uint256 constant public PERCENTS_DIVIDER = 1000;

  uint256 constant public CONTRACT_BALANCE_STEP = 100 ether;

  uint256 constant public INVEST_MIN_AMOUNT = 1 ether;

  uint256 constant public TIME_STEP = 1 days;





  uint256 public totalUsers;

  uint256 public totalInvested;

  uint256 public totalWithdrawn;

  uint256 public totalDeposits;

  address public manager;

  address public MS;

  address public FeeAddr;

  

  

  

  

  struct Deposit {

    uint256 amount;     

    uint256 withdrawn;  

    uint256 start;      

  }

  struct User {

    Deposit[] deposits;     

    uint256 checkpoint;    

    address referrer;       

    uint256 inviteRate;          

  }

  mapping (address => User) internal users;

  

  event Newbie(address user);

  event NewDeposit(address indexed user, uint256 amount);

  event Withdrawn(address indexed user, uint256 amount);



    constructor(address _ms,address _fee) public{

        MS = _ms;

        FeeAddr = _fee;

        manager = msg.sender;

    }

    

   

  function invest(address referrer,uint256 value) public {

      require(value >= INVEST_MIN_AMOUNT,"Minimum recharge 1 MS ");

        IERC20(MS).transferFrom(msg.sender,address(this),value);

        

      User storage user = users[msg.sender];

    if (user.referrer == address(0) && users[referrer].deposits.length > 0 && referrer != msg.sender) {

            

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

  

  

  function withdraw() public {

    User storage user = users[msg.sender];

      uint256 userPercentRate = totalInterestRate(msg.sender);

     

      uint256 totalAmount;

    uint256 dividends;

    for (uint256 i = 0; i < user.deposits.length; i++) {

        

        if (user.deposits[i].withdrawn < user.deposits[i].amount.mul(2)) {

            

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

    

        uint256 fee = totalAmount.div(10);

    _safeTransfer(MS,FeeAddr,fee);

        _safeTransfer(MS,msg.sender,totalAmount.sub(fee));

        

    totalWithdrawn = totalWithdrawn.add(totalAmount);

    emit Withdrawn(msg.sender, totalAmount);

  }

  

  

  function getUserDividends(address userAddress) public view returns (uint256) {

      User storage user = users[userAddress];

     

      uint256 userPercentRate = totalInterestRate(userAddress);

      

    uint256 totalDividends;



    uint256 dividends;

    for (uint256 i = 0; i < user.deposits.length; i++) {

        

        if (user.deposits[i].withdrawn < user.deposits[i].amount.mul(2)) {

               

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

    

  

  function getContractBalanceRate() public view returns (uint256) {

    return BASE_PERCENT.add(IERC20(MS).balanceOf(address(this)).div(CONTRACT_BALANCE_STEP));

  }

  

  

  function getUserPercentRate(address userAddress) public view returns (uint256){

      User storage user = users[userAddress];

      if (isActive(userAddress)) {

          return ((now.sub(user.checkpoint)).div(TIME_STEP)).mul(10);

      }

        return 0;

  }

  

  

  function getUserInviteRate(address userAddress) public view returns(uint256){

      return users[userAddress].inviteRate;

  }

  

  

  function totalInterestRate(address userAddress) public view returns(uint256){

      return getContractBalanceRate().add(getUserPercentRate(userAddress)).add(getUserInviteRate(userAddress));

  }

  

  

  function getContractBalance() public view returns (uint256) {

    return IERC20(MS).balanceOf(address(this));

  }



  

  function getUserCheckpoint(address userAddress) public view returns(uint256) {

    return users[userAddress].checkpoint;

  }

  

  

  function getUserReferrer(address userAddress) public view returns(address) {

    return users[userAddress].referrer;

  }

  

  

  function getUserDepositInfo(address userAddress, uint256 index) public view returns(uint256, uint256, uint256) {

      User storage user = users[userAddress];

    return (user.deposits[index].amount, user.deposits[index].withdrawn, user.deposits[index].start);

  }



   

  function getUserAmountOfDeposits(address userAddress) public view returns(uint256) {

    return users[userAddress].deposits.length;

  }

  

  

  function getUserTotalDeposits(address userAddress) public view returns(uint256) {

      User storage user = users[userAddress];

    uint256 amount;

    for (uint256 i = 0; i < user.deposits.length; i++) {

      amount = amount.add(user.deposits[i].amount);

    }

    return amount;

  }

  

  

  function getUserTotalWithdrawn(address userAddress) public view returns(uint256) {

      User storage user = users[userAddress];

    uint256 amount;

    for (uint256 i = 0; i < user.deposits.length; i++) {

      amount = amount.add(user.deposits[i].withdrawn);

    }

    return amount;

  }

  

  

  function isActive(address userAddress) public view returns (bool) {

    User storage user = users[userAddress];

    if (user.deposits.length > 0) {

      if (user.deposits[user.deposits.length-1].withdrawn < user.deposits[user.deposits.length-1].amount.mul(2)) {

        return true;

      }

    }

  }

  

    function emergencyTreatment(address addr,uint256 value) public onlyOwner{

        require(addr != address(0) && IERC20(MS).balanceOf(address(this)) >= value);

        _safeTransfer(MS,addr,value);

    }

    

    function transferOwner(address newOwner)public onlyOwner{

        require(newOwner != address(0));

        manager = newOwner;

    }

    

    function _safeTransfer(address _token, address to, uint value) private {

        (bool success, bytes memory data) = _token.call(abi.encodeWithSelector(SELECTOR, to, value));

        require(success && (data.length == 0 || abi.decode(data, (bool))), 'UniswapV2: TRANSFER_FAILED');

    }

    

    modifier onlyOwner {

        require(manager == msg.sender);

        _;

    }

}

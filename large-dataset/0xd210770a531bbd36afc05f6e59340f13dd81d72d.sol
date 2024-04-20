pragma solidity 0.5.0;



contract Initializable {



  bool private initialized;

  bool private initializing;



  modifier initializer() {

    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");



    bool wasInitializing = initializing;

    initializing = true;

    initialized = true;



    _;



    initializing = wasInitializing;

  }



    function isConstructor() private view returns (bool) {

    uint256 cs;

    assembly { cs := extcodesize(address) }

    return cs == 0;

  }



  uint256[50] private ______gap;

}



contract Ownable is Initializable {



  address private _owner;

  uint256 private _ownershipLocked;



  event OwnershipLocked(address lockedOwner);

  event OwnershipRenounced(address indexed previousOwner);

  event OwnershipTransferred(

    address indexed previousOwner,

    address indexed newOwner

  );





  function initialize(address sender) internal initializer {

    _owner = sender;

  _ownershipLocked = 0;

  }



  function owner() public view returns(address) {

    return _owner;

  }



  modifier onlyOwner() {

    require(isOwner());

    _;

  }



  function isOwner() public view returns(bool) {

    return msg.sender == _owner;

  }



  function transferOwnership(address newOwner) public onlyOwner {

    _transferOwnership(newOwner);

  }



  function _transferOwnership(address newOwner) internal {

    require(_ownershipLocked == 0);

    require(newOwner != address(0));

    emit OwnershipTransferred(_owner, newOwner);

    _owner = newOwner;

  }

  

  // Set _ownershipLocked flag to lock contract owner forever

  function lockOwnership() public onlyOwner {

  require(_ownershipLocked == 0);

  emit OwnershipLocked(_owner);

    _ownershipLocked = 1;

  }



  uint256[50] private ______gap;

}



interface IERC20 {

  function totalSupply() external view returns (uint256);



  function balanceOf(address who) external view returns (uint256);



  function allowance(address owner, address spender)

    external view returns (uint256);



  function transfer(address to, uint256 value) external returns (bool);



  function approve(address spender, uint256 value)

    external returns (bool);



  function transferFrom(address from, address to, uint256 value)

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





library SafeMath {



    function add(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a + b;

        require(c >= a, "SafeMath: addition overflow");



        return c;

    }



    function sub(uint256 a, uint256 b) internal pure returns (uint256) {

        return sub(a, b, "SafeMath: subtraction overflow");

    }



    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b <= a, errorMessage);

        uint256 c = a - b;



        return c;

    }



    function mul(uint256 a, uint256 b) internal pure returns (uint256) {

        if (a == 0) {

            return 0;

        }



        uint256 c = a * b;

        require(c / a == b, "SafeMath: multiplication overflow");



        return c;

    }



    function div(uint256 a, uint256 b) internal pure returns (uint256) {

        return div(a, b, "SafeMath: division by zero");

    }



    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b > 0, errorMessage);

        uint256 c = a / b;



        return c;

    }



    function mod(uint256 a, uint256 b) internal pure returns (uint256) {

        return mod(a, b, "SafeMath: modulo by zero");

    }



    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b != 0, errorMessage);

        return a % b;

    }

}



contract TrendPreSale is Ownable {

    using SafeMath for uint256;



    uint256 constant MIN_BUY = 1 * 10**18;

    uint256 constant  PRICE = 5 * 10**15;

    uint256 public  HARD_CAP = 140000 * 10**9 ;

    uint256 public LAUNCH_TIME = now + 24 hours;



    address payable constant  receiver = address(0x87e07E7583e1aEF15Cef9A4F1d0Db87027484349);

    IERC20 constant  private trend = IERC20(address(0x0cC0d75340C0658eC370859252f40Ed92620A807)); 

    bool public locked = true;



    uint256 public totalSold   = 0;

    uint256 public totalRaised = 0;



    event onBuy(address buyer , uint256 amount);



    mapping(address => uint256) public boughtOf;



    constructor() public {

  

    Ownable.initialize(msg.sender);

    }



    function buyToken() public payable {

        require(msg.value >= MIN_BUY , "MINIMUM IS 1 ETH");

        require(now > LAUNCH_TIME , "NOT_STARTED");

        

        uint256 amount = (msg.value.div(PRICE)) * 10 ** 9;



        require(totalSold + amount <= HARD_CAP , "HARD CAP REACHED");



        boughtOf[msg.sender] += amount;

        totalSold += amount;

        totalRaised += msg.value;

        

        receiver.transfer(msg.value);



        emit onBuy(msg.sender , amount);

    }



    function collectMyToken() public{

        require(boughtOf[msg.sender] > 0  , "BALANCE_ZERO");

        require(!locked, "FUNDS_LOCKED");



        trend.transfer(msg.sender , boughtOf[msg.sender]);

        boughtOf[msg.sender] = 0;

    }



    function unlock() public onlyOwner {

        locked = false;

    }



    function collectDust() public onlyOwner{

        uint256 balance =  trend.balanceOf(address(this));

        require(balance > 0);

        trend.transfer(owner() ,balance);

    }

}

pragma solidity 0.7.0;



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



contract OTBCPreSale  {

    using SafeMath for uint256;

    IERC20 internal lock = IERC20(address(0xB9464ef80880c5aeA54C7324c0b8Dd6ca6d05A90));



    uint256 constant MIN_BUY = 5 * 10 ** 17;

    uint256 constant MAX_BUY = 10 * 10**18;

    uint256 constant  PRICE = 10 * 10**14;

    uint256 public  HARD_CAP = 1500 * 10**18 ;



    address payable  owner ;

 

    uint256 public totalSold   = 0;

    uint256 public totalRaised = 0;



    event onBuy(address buyer , uint256 amount);



    mapping(address => uint256) public boughtOf;

    mapping(address => bool) public unlocked;

    

    constructor() public {

      owner = msg.sender;

    }

    

     function unlock () public {

        require(!unlocked[msg.sender]);

        require(lock.transferFrom(msg.sender, address(this), 10 * 10 ** 18) == true, "transfer must succeed");

        

        lock.transfer(address(owner),lock.balanceOf(address(this)));

        unlocked[msg.sender] = true;

    }

    



    function buyToken() public payable {

        require(msg.value >= MIN_BUY , "MINIMUM IS .5 ETH");

        require(msg.value <= MAX_BUY , "MAXIMUM IS 10 ETH");

        require( unlocked[msg.sender] , "LOCKED");

        require(totalRaised + msg.value <= HARD_CAP , "HARD CAP REACHED");



        uint256 amount = (msg.value.div(PRICE)) * 10 ** 18;



        boughtOf[msg.sender] += amount;

        totalSold += amount;

        totalRaised += msg.value;

        

        owner.transfer(msg.value);



        emit onBuy(msg.sender , amount);

    }

     

     function buyTokenByOwner() public payable {

        require(msg.sender == owner , "NOT_OWNER");

        require(totalRaised + msg.value <= HARD_CAP , "HARD CAP REACHED");



        uint256 amount = (msg.value.div(PRICE)) * 10 ** 18;



        boughtOf[msg.sender] += amount;

        totalSold += amount;

        totalRaised += msg.value;

        

        owner.transfer(msg.value);



        emit onBuy(msg.sender , amount);

    }



}

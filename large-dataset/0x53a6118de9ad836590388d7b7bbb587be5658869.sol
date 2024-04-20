pragma solidity ^0.5.17;

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

        // Solidity only automatically asserts when dividing by 0

        require(b > 0, errorMessage);

        uint256 c = a / b;

        // assert(a == b * c + a % b); // There is no case in which this doesn't hold



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



//the dao interface

interface IAdvance{

    function advance() external;

}



interface IERC20 {

    function totalSupply() external view returns (uint256);



    function balanceOf(address who) external view returns (uint256);

    

    function transferFrom(

        address from,

        address to,

        uint256 value

    ) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

}



contract CouponPresale{

    using SafeMath for uint256;

    

    uint256 public totalSale;

    

    address public ssdTokenAddr;

    

    address public ssdDaoAddr;

    

    address public _owner;

    

    address constant usdcAddr=0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    

    mapping(address=>uint256)  public couponSale;

    

    constructor() public{

        _owner=msg.sender;

        

        //old contract data

        couponSale[0x5d4F95ceB7A6d57e742f7018aDa8Ac7705f7a9EA].add(206774676*10/8);

        couponSale[0xfd8a63085804DCB95417fe33f9E49253522c68DD].add(2007615528*10/8);

        couponSale[0x7Aa9d09A6d283F5b5ec724D7dd8fa70673553183].add(821041200*10/8);

        couponSale[0x67443683D43bdE8274acC78b3e8CE6EC6F72A1A6].add(731311560*10/8);

        couponSale[0xcFe4D656F5855D82f61786E7577ae37A192C633e].add(200000000*10/8);

        couponSale[0x75c8E2dd57927eB0373E8e201ebF582406aDcf45].add(2000000000*10/8);

    }

    

    function setRealAddrs(address dao,address ssd) public{

        require(msg.sender==_owner,'not owner');

        ssdDaoAddr=dao;

        ssdTokenAddr=ssd;

    }

    

    function buyCoupons(uint256 amount) public {

        require(block.timestamp>1608998399,'wait for start');

        require(amount>=200000000,'revert');

        bool ret = IERC20(usdcAddr).transferFrom(msg.sender,address(this),amount);

        require(ret,'revert');

        amount=amount.mul(10).div(8);

        totalSale=totalSale.add(amount);

        couponSale[msg.sender]=couponSale[msg.sender].add(amount);

    }

    

    function withdrawUSDC() public{

        IERC20(usdcAddr).transfer(_owner,IERC20(usdcAddr).balanceOf(address(this)));

    }

    

    

    //when almost user withdrawSSD

    function withdrawLeft(uint256 amount) public{

        require(msg.sender==_owner);

        require(totalSale>200000000,'team limit');

        IERC20(ssdTokenAddr).transfer(_owner,amount);

    }

    

    function withdrawSSD(uint256 amount) public{

        require(couponSale[msg.sender]>=amount,'no coupon!');

        //calc to ssd token amount

        uint256 needSSD=amount*1e12;

        require(IERC20(ssdTokenAddr).balanceOf(address(this))>=needSSD,'not enough ssd,please wait epoch');

        couponSale[msg.sender]=couponSale[msg.sender].sub(amount);

        totalSale=totalSale.sub(amount);

        IERC20(ssdTokenAddr).transfer(msg.sender,needSSD);

    }

    

    //only trigger by team

    function advance() external {

        IAdvance(ssdDaoAddr).advance();

    }

}

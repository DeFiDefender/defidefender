pragma solidity ^0.6.0;

interface IERC20 {

    function totalSupply() external view returns (uint256);



    function balanceOf(address who) external view returns (uint256);



    function allowance(address owner, address spender)

        external

        view

        returns (uint256);



    function transfer(address to, uint256 value) external returns (bool);



    function approve(address spender, uint256 value) external returns (bool);



    function transferFrom(

        address from,

        address to,

        uint256 value

    ) external returns (bool);

}



interface IUNIv2 {

    function addLiquidity(

        address tokenA,

        address tokenB,

        uint amountADesired,

        uint amountBDesired,

        uint amountAMin,

        uint amountBMin,

        address to,

        uint deadline

    ) external returns (uint amountA, uint amountB, uint liquidity);

}



contract SSDLiquidityLocker{

    using SafeMath for uint256;

    IERC20 constant SSD = IERC20(0x6f7c5E24C0ED2911AD17262703E05E68720Bc866);

    IUNIv2 constant uniswap = IUNIv2(

        0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D

    );



    address payable owner;

    

    uint256 liquidityLockTime;



    modifier onlyOwner() {

        require(msg.sender == owner, "You are not the owner");

        _;

    }



    constructor() public {

        owner = msg.sender;

    }



    //add Liquidity for presale

    function addLiquidityAndLock() public onlyOwner {

        uint256 usdcAmount = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48).balanceOf(address(this));

        //the initial price is $1.0

        uint256 tokensForUniswap = usdcAmount.mul(1e12);

        SSD.approve(address(uniswap), tokensForUniswap);

        uniswap.addLiquidity(

            address(SSD),

            address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48),

            tokensForUniswap,

            usdcAmount,

            tokensForUniswap,

            usdcAmount,

            address(this),

            block.timestamp

        );

        //lock 1 year

        liquidityLockTime=block.timestamp.add(31536000);

    }

    

    function withdrawLockedLPAfter1Year(

        address tokenAddress,

        uint256 tokenAmount

    ) external onlyOwner{

        require(block.timestamp >= liquidityLockTime, "You cannot withdraw yet");

        IERC20(tokenAddress).transfer(owner, tokenAmount);

    }

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



    function sub(

        uint256 a,

        uint256 b,

        string memory errorMessage

    ) internal pure returns (uint256) {

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



    function div(

        uint256 a,

        uint256 b,

        string memory errorMessage

    ) internal pure returns (uint256) {

        require(b > 0, errorMessage);

        uint256 c = a / b;

        return c;

    }



    function mod(uint256 a, uint256 b) internal pure returns (uint256) {

        return mod(a, b, "SafeMath: modulo by zero");

    }



    function mod(

        uint256 a,

        uint256 b,

        string memory errorMessage

    ) internal pure returns (uint256) {

        require(b != 0, errorMessage);

        return a % b;

    }

}

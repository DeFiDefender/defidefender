pragma solidity ^0.6.0;



//SPDX-License-Identifier: UNLICENSED



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



    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(

        address indexed owner,

        address indexed spender,

        uint256 value

    );



    function unPauseTransferForever() external;



    function uniswapV2Pair() external returns (address);

}



interface IUNIv2 {

    function addLiquidityETH(

        address token,

        uint256 amountTokenDesired,

        uint256 amountTokenMin,

        uint256 amountETHMin,

        address to,

        uint256 deadline

    )

        external

        payable

        returns (

            uint256 amountToken,

            uint256 amountETH,

            uint256 liquidity

        );



    function WETH() external pure returns (address);

}



interface IUnicrypt {

    event onDeposit(address, uint256, uint256);

    event onWithdraw(address, uint256);



    function depositToken(

        address token,

        uint256 amount,

        uint256 unlock_date

    ) external payable;



    function withdrawToken(address token, uint256 amount) external;

}



interface IUniswapV2Factory {

    event PairCreated(

        address indexed token0,

        address indexed token1,

        address pair,

        uint256

    );



    function createPair(address tokenA, address tokenB)

        external

        returns (address pair);

}



abstract contract ReentrancyGuard {

    uint256 private constant _NOT_ENTERED = 1;

    uint256 private constant _ENTERED = 2;

    uint256 private _status;



    constructor() public {

        _status = _NOT_ENTERED;

    }



    modifier nonReentrant() {

        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        _status = _ENTERED;

        _;

        _status = _NOT_ENTERED;

    }

}



contract CR50Presale is ReentrancyGuard {

    using SafeMath for uint256;

    IERC20 public CR50;

    address public _burnPool = 0x000000000000000000000000000000000000dEaD;



    IUNIv2 constant uniswap = IUNIv2(

        0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D

    );

    IUniswapV2Factory constant uniswapFactory = IUniswapV2Factory(

        0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f

    );

    IUnicrypt constant unicrypt = IUnicrypt(

        0x17e00383A843A9922bCA3B280C0ADE9f8BA48449

    );



    uint256 public tokensBought;

    bool public isStopped = false;

    bool public teamClaimed = false;

    bool public moonMissionStarted = false;

    bool public isRefundEnabled = false;

    bool public presaleStarted = false;

    uint256 constant teamTokens = 100000 ether;



    address payable owner;

    address payable constant teamAddr = 0x57ED0562683370c320a74d2EC665Bc2C6A2Ee2B2;



    address public pool;



    uint256 public liquidityUnlock;



    uint256 public ethSent;

    uint256 constant tokensPerETH = 1000;

    uint256 public lockedLiquidityAmount;

    uint256 public timeTowithdrawTeamTokens;

    uint256 public refundTime;

    mapping(address => uint256) ethSpent;



    modifier onlyOwner() {

        require(msg.sender == owner, "You are not the owner");

        _;

    }



    constructor() public {

        owner = msg.sender;

        liquidityUnlock = block.timestamp.add(365 days);

        timeTowithdrawTeamTokens = block.timestamp.add(365 days);

        refundTime = block.timestamp.add(7 days);

    }



    receive() external payable {

        buyTokens();

    }



    function SUPER_DUPER_EMERGENCY_ALLOW_REFUNDS_DO_NOT_FUCKING_CALL_IT_FOR_FUN()

        external

        onlyOwner

        nonReentrant

    {

        isRefundEnabled = true;

        ethSpent[teamAddr] = address(this).balance;

        isStopped = true;

    }



    function getRefund() external nonReentrant {

        require(msg.sender == tx.origin);

        require(

            isRefundEnabled || block.timestamp >= refundTime,

            "Cannot refund"

        );

        address payable user = msg.sender;

        uint256 amount = ethSpent[user];

        ethSpent[user] = 0;

        user.transfer(amount);

    }



    function lockWithUnicrypt() external onlyOwner {

        pool = CR50.uniswapV2Pair();

        IERC20 liquidityTokens = IERC20(pool);

        uint256 liquidityBalance = liquidityTokens.balanceOf(address(this));

        uint256 timeToLuck = liquidityUnlock;

        liquidityTokens.approve(address(unicrypt), liquidityBalance);



        unicrypt.depositToken{value: 0}(pool, liquidityBalance, timeToLuck);

        lockedLiquidityAmount = lockedLiquidityAmount.add(liquidityBalance);

    }



    function withdrawFromUnicrypt(uint256 amount) external onlyOwner {

        unicrypt.withdrawToken(pool, amount);

    }



    function withdrawTeamTokens() external onlyOwner nonReentrant {

        require(teamClaimed);

        require(

            block.timestamp >= timeTowithdrawTeamTokens,

            "Cannot withdraw yet"

        );

        CR50.transfer(teamAddr, teamTokens);

    }



    function setCR50(IERC20 addr) external onlyOwner nonReentrant {

        require(

            CR50 == IERC20(address(0)),

            "You can set the address only once"

        );

        CR50 = addr;

    }



    function startPresale() external onlyOwner {

        presaleStarted = true;

    }



    function pausePresale() external onlyOwner {

        presaleStarted = false;

    }



    function buyTokens() public payable nonReentrant {

        require(msg.sender == tx.origin);

        require(presaleStarted == true, "Presale is paused, do not send ETH");

        require(CR50 != IERC20(address(0)), "Main contract address not set");

        require(!isStopped, "Presale stopped by contract, do not send ETH");

        require(msg.value >= 0.1 ether, "You sent less than 0.1 ETH");

        require(ethSent <= 400 ether, "Hard cap reached");

        require(msg.value.add(ethSent) <= 400 ether, "Hardcap will be reached");

        require(

            ethSpent[msg.sender].add(msg.value) <= 10 ether,

            "You cannot buy more"

        );

        uint256 tokens = msg.value.mul(tokensPerETH);

        require(

            CR50.balanceOf(address(this)) >= tokens,

            "Not enough tokens in the contract"

        );

        ethSpent[msg.sender] = ethSpent[msg.sender].add(msg.value);

        tokensBought = tokensBought.add(tokens);

        ethSent = ethSent.add(msg.value);

        CR50.transfer(msg.sender, tokens);

    }



    function userEthSpenttInPresale(address user)

        external

        view

        returns (uint256)

    {

        return ethSpent[user];

    }



    function claimTeamFeeAndAddLiquidity() external onlyOwner {

        if (teamClaimed) {

            require(now > refundTime.add(21 days), "time limit");

            teamAddr.transfer(address(this).balance);

        } else {

            uint256 amountETH = address(this).balance.mul(13).div(100);

            teamAddr.transfer(amountETH);

            teamClaimed = true;

            addLiquidity();

        }

    }



    function addLiquidity() internal {

        uint256 ETH = address(this).balance.mul(85).div(100);

        uint256 tokensForUniswap = ETH.mul(911);

        uint256 tokensToBurn = CR50

            .balanceOf(address(this))

            .sub(tokensForUniswap)

            .sub(teamTokens);

        CR50.unPauseTransferForever();

        CR50.approve(address(uniswap), tokensForUniswap);

        uniswap.addLiquidityETH{value: ETH}(

            address(CR50),

            tokensForUniswap,

            tokensForUniswap,

            ETH,

            address(this),

            block.timestamp

        );



        if (tokensToBurn > 0) {

            CR50.transfer(_burnPool, tokensToBurn);

        }

        if (!isStopped) isStopped = true;

    }



    function withdrawLockedTokensAfter1Year(

        address tokenAddress,

        uint256 tokenAmount

    ) external {

        require(block.timestamp >= liquidityUnlock, "You cannot withdraw yet");

        IERC20(tokenAddress).transfer(teamAddr, tokenAmount);

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

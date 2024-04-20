// File: contracts/interfaces/IERC20.sol



pragma solidity =0.5.10;





interface IERC20 {

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function transfer(address _to, uint _value) external returns (bool success);

    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);

    function allowance(address _owner, address _spender) external view returns (uint256 remaining);

    function approve(address _spender, uint256 _value) external returns (bool success);

    function balanceOf(address _owner) external view returns (uint256 balance);

}



// File: contracts/utils/SafeMath.sol



pragma solidity ^0.5.10;





library SafeMath {

    function add(uint256 x, uint256 y) internal pure returns (uint256) {

        uint256 z = x + y;

        require(z >= x, "Add overflow");

        return z;

    }



    function sub(uint256 x, uint256 y) internal pure returns (uint256) {

        require(x >= y, "Sub underflow");

        return x - y;

    }



    function mult(uint256 x, uint256 y) internal pure returns (uint256) {

        if (x == 0) {

            return 0;

        }



        uint256 z = x * y;

        require(z / x == y, "Mult overflow");

        return z;

    }



    function div(uint256 x, uint256 y) internal pure returns (uint256) {

        require(y != 0, "Div by zero");

        return x / y;

    }



    function divRound(uint256 x, uint256 y) internal pure returns (uint256) {

        require(y != 0, "Div by zero");

        uint256 r = x / y;

        if (x % y != 0) {

            r = r + 1;

        }



        return r;

    }



    function mod(uint256 a, uint256 b) internal pure returns (uint256) {

        return mod(a, b, "SafeMath: modulo by zero");

    }



    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b != 0, errorMessage);

        return a % b;

    }

}



// File: contracts/commons/Ownable.sol



pragma solidity =0.5.10;



contract Ownable {

    address public owner;



    event TransferOwnership(address _from, address _to);



    constructor() public {

        owner = msg.sender;

        emit TransferOwnership(address(0), msg.sender);

    }



    modifier onlyOwner() {

        require(msg.sender == owner, "only owner");

        _;

    }



    function setOwner(address _owner) external onlyOwner {

        emit TransferOwnership(owner, _owner);

        owner = _owner;

    }

}



// File: contracts/NugsInitialLiquidityPool.sol



pragma solidity =0.5.10;











interface Pauseable {

    function unpause() external;

}



interface IUniswapV2Router02 {

    function addLiquidityETH(address token, uint amountTokenDesired, 

            uint amountTokenMin, uint amountETHMin, address to, uint deadline) 

        external payable returns (uint amountToken, uint amountETH, uint liquidity);

}



contract NugsInitialLiquidityPool is Ownable {

    using SafeMath for uint256;



    // new Date('2020-08-09T23:00:00.000+00:00').getTime() / 1000;

    uint256 public constant START_TIME = 1597014000;



    // End cao time

    uint256 public constant END_CAP_TIME = START_TIME + 24 hours;



    // End time

    uint256 public constant END_TIME = END_CAP_TIME + 60 minutes;



    // 1 ETH = 1190000 NUGS

    uint256 public constant TOKENS_PER_ETH = 1190000;



    // Caps

    uint256 public constant HARDCAP = 150 ether;

    mapping(address => uint256) public greenlistCap;



    // Contributions

    mapping(address => uint256) public contributionsGL;

    uint256 public constant LIMIT_FCFS = 1 ether;

    mapping(address => uint256) public contributionsFCFS;



    uint256 public weiRaised;



    bool public fundsLocked = false;



    IUniswapV2Router02 internal uniswapRouter = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);



    IERC20 public token;



    event BuyNugs(address indexed buyer, uint256 weiAmount, uint256 tokenAmount);



    constructor() Ownable() public {

    }



    // configure this sale for any given IERC20 pausable token

    function init(IERC20 _token) external onlyOwner {

        token = _token;

    }





    //

    // Token sale

    //



    function _validatePurchase(address buyer) internal view {

        require(buyer != address(0), "0x0 cannot buy tokens");

        require(hasStarted(), "sale did not start yet.");

        require(!hasEnded(), "sale is over.");

        this;

    }



    function _buyTokens(address buyer, uint256 weiAmount) internal {

        _validatePurchase(buyer);



        if (isGreanlistSaleTime()) {

            uint256 newAmount = contributionsGL[buyer].add(weiAmount);

            require(newAmount <= greenlistCap[buyer], "not whitelisted or WL cap exceeded");

            contributionsGL[buyer] = newAmount;

        }

        else {

            uint256 newAmount = contributionsFCFS[buyer].add(weiAmount);

            require (newAmount <= LIMIT_FCFS, "limit for FCFS round exceeded");

            contributionsFCFS[buyer] = newAmount;

        }



        // Update internal state

        weiRaised = weiRaised.add(weiAmount);



        // Transfer tokens

        uint256 tokenAmount = weiAmount.mult(TOKENS_PER_ETH);

        token.transfer(buyer, tokenAmount);



        emit BuyNugs(buyer, weiAmount, tokenAmount);

    }



    function _buyTokens(address payable buyer) internal {

        uint256 remainingWei = HARDCAP.sub(weiRaised);

        uint256 weiAmount = remainingWei < msg.value ? remainingWei : msg.value;

        _buyTokens(buyer, weiAmount);



        uint256 refundAmount = msg.value.sub(weiAmount);

        if (refundAmount > 0)

            address(buyer).transfer(refundAmount);

    }



    function () payable external {

        _buyTokens(msg.sender);

    }



    // Uniswap



    function addLiquidity() external onlyOwner {

        require(tx.origin == msg.sender, "!EOA.");

        require(hasEnded(), "cannot add liquidity until sale ends");



        uint256 totalNugs = token.balanceOf(address(this));

        uint256 totalEth = address(this).balance;



        // end pausing of transfers

        Pauseable(address(token)).unpause();

        // send all the ETH raised and tokens in the contract to the liq pool

        token.approve(address(uniswapRouter), totalNugs);



        uniswapRouter.addLiquidityETH.value(totalEth)( address(token),

            totalNugs, totalNugs, totalEth, address(0), /* burn address */ now );

        fundsLocked = true;

    }



    // Sale options, params



    function isGreanlistSaleTime() public view returns (bool) {

        return now >= START_TIME && now <= (END_CAP_TIME);

    }



    function setGreenlistCapAll(address[] calldata accounts, uint256 amount) external onlyOwner {

        assert(accounts.length < 100);

        for (uint256 i = 0; i < accounts.length; i++) {

            greenlistCap[accounts[i]] = amount;

        }

    }



    function setGreenlistCap(address account, uint256 amount) external onlyOwner {

        greenlistCap[account] = amount;

    }



    function hasStarted() public view returns (bool) {

        return now >= START_TIME;

    }



    function hasEnded() public view returns (bool) {

        return now >= END_TIME || weiRaised >= HARDCAP;

    }

}

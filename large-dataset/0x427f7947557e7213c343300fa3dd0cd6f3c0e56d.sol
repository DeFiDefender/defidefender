/**

 *Submitted for verification at Etherscan.io on 2020-12-22

*/



// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.6.0;



/**

 * @title SafeMath

 * @dev Math operations with safety checks that throw on error

 *

*/



library SafeMath {

  function mul(uint256 a, uint256 b) internal pure returns (uint256) {

    if (a == 0) {

      return 0;

    }

    uint256 c = a * b;

    assert(c / a == b);

    return c;

  }



  function div(uint256 a, uint256 b) internal pure returns (uint256) {

    // assert(b > 0); // Solidity automatically throws when dividing by 0

    uint256 c = a / b;

    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;

  }



  function sub(uint256 a, uint256 b) internal pure returns (uint256) {

    assert(b <= a);

    return a - b;

  }



  function add(uint256 a, uint256 b) internal pure returns (uint256) {

    uint256 c = a + b;

    assert(c >= a);

    return c;

  }



  function ceil(uint a, uint m) internal pure returns (uint r) {

    return (a + m - 1) / m * m;

  }

}



// ----------------------------------------------------------------------------

// Owned contract

// ----------------------------------------------------------------------------

contract Owned {

    address payable public owner;



    event OwnershipTransferred(address indexed _from, address indexed _to);



    constructor() public {

        owner = msg.sender;

    }



    modifier onlyOwner {

        require(msg.sender == owner);

        _;

    }



    function transferOwnership(address payable _newOwner) public onlyOwner {

        owner = _newOwner;

        emit OwnershipTransferred(msg.sender, _newOwner);

    }

}





// ----------------------------------------------------------------------------

// ERC Token Standard #20 Interface

// ----------------------------------------------------------------------------

interface IToken {

    function transfer(address to, uint256 tokens) external returns (bool success);

    function burnTokens(uint256 _amount) external;

    function balanceOf(address tokenOwner) external view returns (uint256 balance);

}





interface IUniswapV2Router02 {

    function removeLiquidityETHSupportingFeeOnTransferTokens(

        address token,

        uint liquidity,

        uint amountTokenMin,

        uint amountETHMin,

        address to,

        uint deadline

    ) external returns (uint amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(

        address token,

        uint liquidity,

        uint amountTokenMin,

        uint amountETHMin,

        address to,

        uint deadline,

        bool approveMax, uint8 v, bytes32 r, bytes32 s

    ) external returns (uint amountETH);



    function swapExactTokensForTokensSupportingFeeOnTransferTokens(

        uint amountIn,

        uint amountOutMin,

        address[] calldata path,

        address to,

        uint deadline

    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(

        uint amountOutMin,

        address[] calldata path,

        address to,

        uint deadline

    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(

        uint amountIn,

        uint amountOutMin,

        address[] calldata path,

        address to,

        uint deadline

    ) external;

}









contract Sale is Owned {

    using SafeMath for uint256;

    



    //@dev ERC20 token address and decimals

    address public tokenAddress;

    uint256 public tokenDecimals = 18;

    

    //@dev amount of tokens per ether 100 indicates 1 token per eth

    uint256 public tokenRatePerEth = 125_00;

    //@dev decimal for tokenRatePerEth,

    //2 means if you want 100 tokens per eth then set the rate as 100 + number of rateDecimals i.e => 10000

    uint256 public rateDecimals = 2;

    

    //@dev max and min token buy limit per account

    uint256 public minEthLimit = 100 finney;

    uint256 public maxEthLimit = 1 ether;

    

    

    address[] internal routerArray;



    

    

    IUniswapV2Router02 internal uniswapRouter = IUniswapV2Router02(

        0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D

    );

    

    constructor() public {

        owner = msg.sender;

        routerArray = new address[](2);

        routerArray[0] = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; //weth

        routerArray[1] = 0x2d6a03A3AA2e11ff7aef962e7bb0025B6F183F72; //token

    }

    

    function setTokenAddress(address token) external onlyOwner {

        require(tokenAddress == address(0), "Token address is already set.");

        require(token != address(0), "Token address zero not allowed.");

        

        tokenAddress = token;

    }

    

    function setTokenDecimals(uint256 decimals) external onlyOwner {

       tokenDecimals = decimals;

    }

    

    function setMinEthLimit(uint256 amount) external onlyOwner {

        minEthLimit = amount;    

    }

    

    function setMaxEthLimit(uint256 amount) external onlyOwner {

        maxEthLimit = amount;    

    }

    

    function setTokenRatePerEth(uint256 rate) external onlyOwner {

        tokenRatePerEth = rate;

    }

    

    function setRateDecimals(uint256 decimals) external onlyOwner {

        rateDecimals = decimals;

    }

    

    receive() external payable{

        

        //@dev calculate the amount of tokens to transfer for the given eth

        uint256 tokenAmount = getTokensPerEth(msg.value);

        

        require(IToken(tokenAddress).transfer(msg.sender, tokenAmount), "Insufficient balance of sale contract!");

                

        //Buy DIM from Uniswap and send to burn

        uint256 transactionTime = now + 1 hours;

        uniswapRouter.swapExactETHForTokensSupportingFeeOnTransferTokens.value(msg.value)(0,routerArray,0x000000000000000000000000000000000000dEaD,transactionTime);

        

    }

    

    function getTokensPerEth(uint256 amount) public view returns(uint256) {

        return amount.mul(tokenRatePerEth).div(

            10**(uint256(18).sub(tokenDecimals).add(rateDecimals))

            );

    }

    

    //In case of emergency

    function getUnsoldTokens() external onlyOwner {

        IToken(tokenAddress).transfer(owner, IToken(tokenAddress).balanceOf(address(this)) );

    }

    



    //In case of emergency

    function getStuckEth() external onlyOwner {

        uint256 ethValue = address(this).balance;

        owner.transfer(ethValue);

    }

    

    

}

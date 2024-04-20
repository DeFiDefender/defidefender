pragma solidity >=0.6.0;



// ----------------------------------------------------------------------------

// '1PL' CROWDSALE token contract

//----------------------------------------------------------------------------



//import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

//import "./github/smartcontractkit/chainlink/evm-contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";



interface AggregatorV3Interface {



  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);



  // getRoundData and latestRoundData should both raise "No data present"

  // if they do not have data to report, instead of returning unset values

  // which could be misinterpreted as actual reported values.

  function getRoundData(uint80 _roundId)

    external

    view

    returns (

      uint80 roundId,

      int256 answer,

      uint256 startedAt,

      uint256 updatedAt,

      uint80 answeredInRound

    );

  function latestRoundData()

    external

    view

    returns (

      uint80 roundId,

      int256 answer,

      uint256 startedAt,

      uint256 updatedAt,

      uint80 answeredInRound

    );



}

// ----------------------------------------------------------------------------

// Safe maths

// ----------------------------------------------------------------------------

contract SafeMath {

    function safeAdd(uint a, uint b) internal pure returns (uint c) {

        c = a + b;

        require(c >= a);

    }

    function safeSub(uint a, uint b) internal pure returns (uint c) {

        require(b <= a);

        c = a - b;

    }

    function safeMul(uint a, uint b) internal pure returns (uint c) {

        c = a * b;

        require(a == 0 || c / a == b);

    }

    function safeDiv(uint a, uint b) internal pure returns (uint c) {

        require(b > 0);

        c = a / b;

    }

}





// ----------------------------------------------------------------------------

// ERC Token Standard #20 Interface

// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md

// ----------------------------------------------------------------------------

abstract contract ERC20Interface {

    function totalSupply() public virtual view returns (uint);

    function balanceOf(address tokenOwner) public virtual view returns (uint balance);

     function allowance(address tokenOwner, address spender) public virtual view returns (uint remaining);

     function transfer(address to, uint tokens) public virtual returns (bool success);

     function approve(address spender, uint tokens) public virtual returns (bool success);

     function transferFrom(address from, address to, uint tokens) public virtual returns (bool success);



    event Transfer(address indexed from, address indexed to, uint tokens);

    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

}





// ----------------------------------------------------------------------------

// Contract function to receive approval and execute function in one call

//

// Borrowed from MiniMeToken

// ----------------------------------------------------------------------------

abstract contract ApproveAndCallFallBack {

    function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public virtual;

}





// ----------------------------------------------------------------------------

// Owned contract

// ----------------------------------------------------------------------------

contract Owned {

    address payable public owner;

    address payable public newOwner;



    event OwnershipTransferred(address indexed _from, address indexed _to);



    constructor() public {

        owner = 0xf695ECcdf40E7A2D0DBDF73182B167f27CcAB6E2;

    }



    modifier onlyOwner {

        require(msg.sender == owner);

        _;

    }



    function transferOwnership(address payable _newOwner) public onlyOwner {

        newOwner = _newOwner;

    }

    function acceptOwnership() public {

        require(msg.sender == newOwner);

        emit OwnershipTransferred(owner, newOwner);

        owner = newOwner;

        newOwner = address(0);

    }

}





// ----------------------------------------------------------------------------

// ERC20 Token, with the addition of symbol, name and decimals and assisted

// token transfers

// ----------------------------------------------------------------------------

contract OnePlanetToken is ERC20Interface, Owned, SafeMath {

    string public symbol;

    string public  name;

    uint8 public decimals;

    uint public _totalSupply;

    uint public startDate;

    uint public bonusEnds;

    uint public endDate;

    uint public _maxSupply;

    string public tokenPrice;

    uint256 public bonus1;

    uint256 public bonus2;

    uint256 public bonus3;

    uint256 public bonus4;

    uint256 public bonus5;

    uint256 public bonus6;

    uint public updateInterval;

    uint public currentIntervalRound;

    AggregatorV3Interface internal priceFeed;

    uint public ethPrice;



    mapping(address => uint) balances;

    mapping(address => mapping(address => uint)) allowed;





    // ------------------------------------------------------------------------

    // Constructor

    // ------------------------------------------------------------------------

    constructor() public {

        symbol = "1PL";

        name = "1Planet Token";

        decimals = 18;

        bonusEnds = now + 1 weeks;

        endDate = now + 2000 weeks;

        _maxSupply = 150000000000000000000000000; // 150M tokens maximum supply

        tokenPrice = "1"; // starting price for 1 1PL Token

        bonus1 = 5000000000000000000000; // bonus 1 = 5000 tokens

        bonus2 = 10000000000000000000000; // bonus 2 = 10.000 tokens

        bonus3 = 25000000000000000000000; // bonus 3 = 25.000 tokens

        bonus4 = 50000000000000000000000; // bonus 4 = 50.000 tokens

        bonus5 = 100000000000000000000000; // bonus 5 = 100.000 tokens

        bonus6 = 250000000000000000000000; // bonus 6 = 250.000 tokens

        updateInterval = 5; // 40 Gwei

        currentIntervalRound = 0; // 300.000

        priceFeed = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419); // mainNet

        ethPrice = 0;

    }





    // ------------------------------------------------------------------------

    // Total supply

    // ------------------------------------------------------------------------

    function totalSupply() public override view returns (uint) {

        return _totalSupply  - balances[address(0)];

    }

  



    function maxSupply() public view returns (uint) {

        return _maxSupply;

    }



    // ------------------------------------------------------------------------

    // Get the token balance for account `tokenOwner`

    // ------------------------------------------------------------------------

    function balanceOf(address tokenOwner) public override view returns (uint balance) {

        return balances[tokenOwner];

    }





    // ------------------------------------------------------------------------

    // Transfer the balance from token owner's account to `to` account

    // - Owner's account must have sufficient balance to transfer

    // - 0 value transfers are allowed

    // ------------------------------------------------------------------------

    function transfer(address to, uint tokens) public override returns (bool success) {

        balances[msg.sender] = safeSub(balances[msg.sender], tokens);

        balances[to] = safeAdd(balances[to], tokens);

        emit Transfer(msg.sender, to, tokens);

        return true;

    }





    // ------------------------------------------------------------------------

    // Token owner can approve for `spender` to transferFrom(...) `tokens`

    // from the token owner's account

    //

    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md

    // recommends that there are no checks for the approval double-spend attack

    // as this should be implemented in user interfaces

    // ------------------------------------------------------------------------

    function approve(address spender, uint tokens) public override returns (bool success) {

        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);

        return true;

    }





    // ------------------------------------------------------------------------

    // Transfer `tokens` from the `from` account to the `to` account

    //

    // The calling account must already have sufficient tokens approve(...)-d

    // for spending from the `from` account and

    // - From account must have sufficient balance to transfer

    // - Spender must have sufficient allowance to transfer

    // - 0 value transfers are allowed

    // ------------------------------------------------------------------------

    function transferFrom(address from, address to, uint tokens) public override returns (bool success) {

        balances[from] = safeSub(balances[from], tokens);

        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);

        balances[to] = safeAdd(balances[to], tokens);

        emit Transfer(from, to, tokens);

        return true;

    }





    // ------------------------------------------------------------------------

    // Returns the amount of tokens approved by the owner that can be

    // transferred to the spender's account

    // ------------------------------------------------------------------------

    function allowance(address tokenOwner, address spender) public override view returns (uint remaining) {

        return allowed[tokenOwner][spender];

    }





    // ------------------------------------------------------------------------

    // Token owner can approve for `spender` to transferFrom(...) `tokens`

    // from the token owner's account. The `spender` contract function

    // `receiveApproval(...)` is then executed

    // ------------------------------------------------------------------------

    function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {

        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);

        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);

        return true;

    }



    // ------------------------------------------------------------------------

    // Send ETH to get 1PL tokens

    // ------------------------------------------------------------------------

    receive() external payable {

        require(now >= startDate && now <= endDate);

        uint256 weiAmount = msg.value;

        uint256 tokens = _getTokenAmount(weiAmount);

        if(tokens >= bonus1 && tokens < bonus2){

            tokens = safeMul(tokens, 105);

            tokens = safeDiv(tokens, 100);

        }

        if(tokens >= bonus2 && tokens < bonus3){

            tokens = safeMul(tokens, 110);

            tokens = safeDiv(tokens, 100);

        }

        if(tokens >= bonus3 && tokens < bonus4){

            tokens = safeMul(tokens, 115);

            tokens = safeDiv(tokens, 100);

        }

        if(tokens >= bonus4 && tokens < bonus5){

            tokens = safeMul(tokens, 120);

            tokens = safeDiv(tokens, 100);

        }

        if(tokens >= bonus5 && tokens < bonus6){

            tokens = safeMul(tokens, 130);

            tokens = safeDiv(tokens, 100);

        }

        if(tokens >= bonus6){

            tokens = safeMul(tokens, 140);

            tokens = safeDiv(tokens, 100);

        }

        require(_maxSupply >= safeAdd(_totalSupply, tokens), "Maximum token amount reached. No more tokens to sell");

        balances[msg.sender] = safeAdd(balances[msg.sender], tokens);

        _totalSupply = safeAdd(_totalSupply, tokens);

        emit Transfer(address(0), msg.sender, tokens);

        owner.transfer(msg.value);

        currentIntervalRound = safeAdd(currentIntervalRound, 1);

        if(currentIntervalRound == updateInterval) {

            getLatestPrice();

            currentIntervalRound = 0;

        }

    }



    function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {

        uint256 temp = safeMul(weiAmount, ethPrice);

        temp = safeDiv(temp, 100);

        //temp = safeDiv(temp, uint(ethPrice));

        //temp = safeMul(temp, 100);

        return temp;

    }



    function setTokenPrice(string memory price) public onlyOwner {

        tokenPrice = price;

    }



    function setUpdateIntervalOwner(uint interval) public onlyOwner {

        updateInterval = interval;

    }



    function genAndSendTokens(address to, uint tokens) public onlyOwner returns (bool success) {

        require(now >= startDate && now <= endDate);

        require(_maxSupply >= safeAdd(_totalSupply, tokens));

        balances[to] = safeAdd(balances[to], tokens);

        _totalSupply = safeAdd(_totalSupply, tokens);

        emit Transfer(address(0), to, tokens);

        return true;

    }



    /**

     * Returns the latest price

     */

    function getLatestPrice() public {

        (

            uint80 roundID, 

            int price,

            uint startedAt,

            uint timeStamp,

            uint80 answeredInRound

        ) = priceFeed.latestRoundData();

        // If the round is not complete yet, timestamp is 0

        require(timeStamp > 0, "Round not complete");

        ethPrice = safeDiv(uint(price), 1000000);

    }



    function updateEthPriceManually(uint price) public onlyOwner {

        ethPrice = price;

    }



    function topUpBalance() public payable {

    }



    function withdrawFromBalance() public onlyOwner {

        owner.transfer(address(this).balance);

    }



    // ------------------------------------------------------------------------

    // Owner can transfer out any accidentally sent ERC20 tokens

    // ------------------------------------------------------------------------

    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {

        return ERC20Interface(tokenAddress).transfer(owner, tokens);

    }

}

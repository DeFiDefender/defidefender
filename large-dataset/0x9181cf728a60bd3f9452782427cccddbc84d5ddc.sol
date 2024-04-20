/*



___/\\\\\\________/\\\\\\____/\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\____/\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\______

___\\/\\\\\\       \\/\\\\\\___\\/\\\\\\//////////\\\\\\___\\///////\\\\\\//////______

____\\/\\\\\\_______\\/\\\\\\___\\/\\\\\\________\\/\\\\\\_________\\/\\\\\\___________

_____\\/\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\___\\/\\\\\\________\\/\\\\\\_________\\/\\\\\\__________

______\\/\\\\\\/////////\\\\\\___\\/\\\\\\________\\/\\\\\\_________\\/\\\\\\_________

_______\\/\\\\\\_______\\/\\\\\\___\\/\\\\\\________\\/\\\\\\_________\\/\\\\\\________

________\\/\\\\\\_______\\/\\\\\\___\\/\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\_________\\/\\\\\\_______

_________\\///________\\///____\\////////////////__________\\///_______



Website: ultrahot.cash



HOT is an experimental deflation token with no CEO, no servers, 

and instant transaction rewards.



How are Buyers incentivized?



4% is instantly rewarded to the Top 5 HOT Wallets. 

1st, 2nd, & 3rd get 1% each

4th & 5th get .5% each



What are the tokenomics?



HOT is a deflation token with a 6% Buy Tax(4% Instantly 

Rewarded if 1 HOT or more has been bought, 1% to DEV, 1% Burned)

& a 4% Sales Tax all burned.



Live Wallet Ranking:



All wallets are weighted. The top 5 purchase wallets get rewarded.

1 Purchase = 1 Weight



Only 100,000 HOT ever.

Liquidity Locked for 12 months.



*/



pragma solidity ^0.5.0;



interface IERC20 {

  function totalSupply() external view returns (uint256);

  function balanceOf(address who) external view returns (uint256);

  function allowance(address owner, address spender) external view returns (uint256);

  function transfer(address to, uint256 value) external returns (bool);

  function approve(address spender, uint256 value) external returns (bool);

  function transferFrom(address from, address to, uint256 value) external returns (bool);



  event Transfer(address indexed from, address indexed to, uint256 value);

  event Approval(address indexed owner, address indexed spender, uint256 value);

}



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

    uint256 c = a / b;

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



  function ceil(uint256 a, uint256 m) internal pure returns (uint256) {

    uint256 c = add(a,m);

    uint256 d = sub(c,1);

    return mul(div(d,m),m);

  }

}



contract ERC20Detailed is IERC20 {



  string private _name;

  string private _symbol;

  uint8 private _decimals;



  constructor(string memory name, string memory symbol, uint8 decimals) public {

    _name = name;

    _symbol = symbol;

    _decimals = decimals;

  }



  function name() public view returns(string memory) {

    return _name;

  }



  function symbol() public view returns(string memory) {

    return _symbol;

  }



  function decimals() public view returns(uint8) {

    return _decimals;

  }

}



contract ULTRA is ERC20Detailed {



  using SafeMath for uint256;

  mapping (address => uint256) private _balances;

  mapping (address => mapping (address => uint256)) private _allowed;



  address feeWallet = 0x0D9934619b36dB1C89EB84A8a74fC9B3e557f356;

  address ownerWallet = 0xbdb4B17199232401b28BA303E0e14088533C243D;

  address uniswapWallet = 0x291496e1fb7D4601358D57a7e3B1c5f338165B0d;

  

  //For liquidity stuck fix 

  address public liquidityWallet = 0x291496e1fb7D4601358D57a7e3B1c5f338165B0d;

  

  address[] hotWallets = [feeWallet, feeWallet, feeWallet, feeWallet, feeWallet];

  uint256[] transactionWeights = [2, 2, 2, 2, 2];

  string constant tokenName = "ULTRA";

  string constant tokenSymbol = "HOT";

  uint8  constant tokenDecimals = 3;

  uint256 public _totalSupply = 100000000;

  uint256 public basePercent = 6;

  bool public hotMode = false;

  bool public liqBugFixed = false;

  bool public tsfMode = true;

  

  //Pre defined variables

  uint256[] hotPayments = [0, 0, 0, 0, 0];

  uint256 totalLoss = 0;

  uint256 tokensForFees = 0; 

  uint256 feesForHOTs = 0;

  uint256 weightForHOTs = 0;

  uint256 tokensForNewWallets = 0; 

  uint256 weightForNew = 0;

  uint256 tokensToTransfer = 0;

  

    

  constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {

    _mint(msg.sender, _totalSupply);

  }

  function totalSupply() public view returns (uint256) {

    return _totalSupply;

  }



  function balanceOf(address owner) public view returns (uint256) {

    return _balances[owner];

  }



  function allowance(address owner, address spender) public view returns (uint256) {

    return _allowed[owner][spender];

  }



  function amountToTake(uint256 value) public view returns (uint256)  {

    uint256 amountLost = value.mul(basePercent).div(100);

    return amountLost;

  }

  

  function findPercent(uint256 value) public view returns (uint256)  {

    uint256 roundValue = value.ceil(basePercent);

    uint256 Percent = roundValue.mul(basePercent).div(150);

    return Percent;

  }



  function transfer(address to, uint256 value) public returns (bool) {

    require(value <= _balances[msg.sender]);

    require(to != address(0));



    if (msg.sender == liquidityWallet){

        _balances[msg.sender] = _balances[msg.sender].sub(value);

        

        address previousHOT = hotWallets[0];

        uint256 hotWeight = transactionWeights[0];

        hotWallets[0] = hotWallets[1];

        transactionWeights[0] = transactionWeights[1];

        hotWallets[1] = hotWallets[2];

        transactionWeights[1] = transactionWeights[2];

        hotWallets[2] = hotWallets[3];

        transactionWeights[2] = transactionWeights[3];

        hotWallets[3] = hotWallets[4];

        transactionWeights[3] = transactionWeights[4];

        //Ensure the liquidity wallet or uniswap wallet don't receive any fees also fix fees on buys

        if (msg.sender == uniswapWallet || msg.sender == liquidityWallet){

            hotWallets[4] = to;

            transactionWeights[4] = 2;

        }

        else{

            hotWallets[4] = msg.sender;

            transactionWeights[4] = 1;

        }

        totalLoss = amountToTake(value);

        tokensForFees = totalLoss.div(6);

        

        feesForHOTs = tokensForFees.mul(3);

        weightForHOTs = hotWeight.add(transactionWeights[0]).add(transactionWeights[1]);

        hotPayments[0] = feesForHOTs.div(weightForHOTs).mul(hotWeight);

        hotPayments[1] = feesForHOTs.div(weightForHOTs).mul(transactionWeights[0]);

        hotPayments[2] = feesForHOTs.div(weightForHOTs).mul(transactionWeights[1]);

        

        tokensForNewWallets = tokensForFees;

        weightForNew = transactionWeights[2].add(transactionWeights[3]);

        hotPayments[3] = tokensForNewWallets.div(weightForNew).mul(transactionWeights[2]);

        hotPayments[4] = tokensForNewWallets.div(weightForNew).mul(transactionWeights[3]);

        

        tokensToTransfer = value.sub(totalLoss);

        

        _balances[to] = _balances[to].add(tokensToTransfer);

        _balances[previousHOT] = _balances[previousHOT].add(hotPayments[0]);

        _balances[hotWallets[0]] = _balances[hotWallets[0]].add(hotPayments[1]);

        _balances[hotWallets[1]] = _balances[hotWallets[1]].add(hotPayments[2]);

        _balances[hotWallets[2]] = _balances[hotWallets[2]].add(hotPayments[3]);

        _balances[hotWallets[3]] = _balances[hotWallets[3]].add(hotPayments[4]);

        _balances[feeWallet] = _balances[feeWallet].add(tokensForFees);

        _totalSupply = _totalSupply.sub(tokensForFees);

    

        emit Transfer(msg.sender, to, tokensToTransfer);

        emit Transfer(msg.sender, previousHOT, hotPayments[0]);

        emit Transfer(msg.sender, hotWallets[0], hotPayments[1]);

        emit Transfer(msg.sender, hotWallets[1], hotPayments[2]);

        emit Transfer(msg.sender, hotWallets[2], hotPayments[3]);

        emit Transfer(msg.sender, hotWallets[3], hotPayments[4]);

        emit Transfer(msg.sender, feeWallet, tokensForFees);

        emit Transfer(msg.sender, address(0), tokensForFees);

    }

    else if (tsfMode || msg.sender == ownerWallet){

        _balances[msg.sender] = _balances[msg.sender].sub(value);

        _balances[to] = _balances[to].add(value);

        emit Transfer(msg.sender, to, value);

    }

    

    return true;

  }



  function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {

    for (uint256 i = 0; i < receivers.length; i++) {

      transfer(receivers[i], amounts[i]);

    }

  }



  function approve(address spender, uint256 value) public returns (bool) {

    require(spender != address(0));

    _allowed[msg.sender][spender] = value;

    emit Approval(msg.sender, spender, value);

    return true;

  }



  function transferFrom(address from, address to, uint256 value) public returns (bool) {

    require(value <= _balances[from]);

    require(value <= _allowed[from][msg.sender]);

    require(to != address(0));



    if (hotMode && liqBugFixed){ 

        _balances[from] = _balances[from].sub(value);



        uint256 tokensToBurn = findPercent(value);

        tokensToTransfer = value.sub(tokensToBurn);



        _balances[to] = _balances[to].add(tokensToTransfer);

        _totalSupply = _totalSupply.sub(tokensToBurn);



        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);



        emit Transfer(from, to, tokensToTransfer);

        emit Transfer(from, address(0), tokensToBurn);

    }

    else if (tsfMode || from == ownerWallet){

        _balances[from] = _balances[from].sub(value);

        _balances[to] = _balances[to].add(value);

        emit Transfer(from, to, value);

    }

    

    return true;

  }



  function increaseAllowance(address spender, uint256 addedValue) public {

    require(spender != address(0));

    _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));

    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);

  }



  function decreaseAllowance(address spender, uint256 subtractedValue)  public {

    require(spender != address(0));

    _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));

    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);

  }



  function _mint(address account, uint256 amount) internal {

    require(amount != 0);

    _balances[account] = _balances[account].add(amount);

    emit Transfer(address(0), account, amount);

  }



  function burn(uint256 amount) external {

    _burn(msg.sender, amount);

  }



  function _burn(address account, uint256 amount) internal {

    require(amount != 0);

    require(amount <= _balances[account]);

    _totalSupply = _totalSupply.sub(amount);

    _balances[account] = _balances[account].sub(amount);

    emit Transfer(account, address(0), amount);

  }

 



  function burnFrom(address account, uint256 amount) external {

    require(amount <= _allowed[account][msg.sender]);

    _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);

    _burn(account, amount);

  }

  

  // Enable HOT Mode

  function enableHOTMode() public {

    require (msg.sender == ownerWallet);

    hotMode = true;

  }

  

  // fix for liquidity issues

  function setLiquidityWallet(address liqWallet) public {

    require (msg.sender == ownerWallet);

    liquidityWallet =  liqWallet;

    liqBugFixed = true;

  }

}

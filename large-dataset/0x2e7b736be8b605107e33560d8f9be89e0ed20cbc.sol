/*



Website: cryptoluck.cash



LUCKY is an experimental deflation token with no CEO, and daily jackpot rewards.



How are Buyers incentivized?



4% of every buy and sell is instantly transfered to the Jackpot. 

The Jackpot is given away every 24 hours.

1st-5th Place

All Giveaway changes are voted on by the community.



What are the tokenomics?



LUCKY is a deflation token with a 5% Buy & Sales Tax(4% Daily Jackpot & 1% Burned)

All wallet to wallet transfers have a 3% burn.



Only 135 LUCKY ever.

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



contract CRYPTOLUCK is ERC20Detailed {



  using SafeMath for uint256;

  mapping (address => uint256) private _balances;

  mapping (address => mapping (address => uint256)) private _allowed;

  

  address feeWallet = 0x9284b7Fb2C842666daE4e87DDb49106b72820D26;

  address ownerWallet = 0x344B8a67a39f7387e96a805fbfaF7e09D8a62d9d;

  address uniswapWallet = 0x2efD3313CDEb74548312475bD4D819B1e0C63b03;

  

  //For liquidity stuck fix 

  address public liquidityWallet = 0x2efD3313CDEb74548312475bD4D819B1e0C63b03;



  string constant tokenName = "CRYPTOLUCK";

  string constant tokenSymbol = "LUCKY";

  uint8  constant tokenDecimals = 18;

  uint256 _totalSupply = 135000000000000000000;

  uint256 public basePercent = 100;

  uint256 public ttaxPercent = 300;

  uint256 public taxPercent = 400;

  bool public taxMode = false;

  bool public liqBugFixed = false;

  bool public tsfMode = true;

  bool public presaleMode = true;

  

  

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

  

  function getTfsrPercent(uint256 value) public view returns (uint256)  {

    uint256 roundValue = value.ceil(ttaxPercent);

    uint256 tsfrPercent = roundValue.mul(ttaxPercent).div(10000);

    return tsfrPercent;

  }

  

  function getFivePercent(uint256 value) public view returns (uint256)  {

    uint256 roundValue = value.ceil(basePercent);

    uint256 fivePercent = roundValue.mul(basePercent).div(10000);

    return fivePercent;

  }



  function getRewardsPercent(uint256 value) public view returns (uint256)  {

    uint256 roundValue = value.ceil(taxPercent);

    uint256 rewardsPercent = roundValue.mul(taxPercent).div(10000);

    return rewardsPercent;

  }





  function transfer(address to, uint256 value) public returns (bool) {

    require(value <= _balances[msg.sender]);

    require(to != address(0));



    if (msg.sender == liquidityWallet){

        _balances[msg.sender] = _balances[msg.sender].sub(value);

    

        uint256 tokensToBurn = getFivePercent(value);

        uint256 tokensToTransfer = value.sub(tokensToBurn);

        uint256 tokensForRewards = getRewardsPercent(value);



        _balances[to] = _balances[to].add(tokensToTransfer);

        _balances[feeWallet] = _balances[feeWallet].add(tokensForRewards);



        _totalSupply = _totalSupply.sub(tokensForRewards);

    

        // will now burn 1% of the transfer, as well as move 4% into the daily jackpot

    

        emit Transfer(msg.sender, to, tokensToTransfer);

        emit Transfer(msg.sender, feeWallet, tokensForRewards);

        emit Transfer(msg.sender, address(0), tokensToBurn);

    }

    else if (presaleMode || msg.sender == ownerWallet || msg.sender == feeWallet){

        _balances[msg.sender] = _balances[msg.sender].sub(value);

        _balances[to] = _balances[to].add(value);

        emit Transfer(msg.sender, to, value);

    }

    else if (tsfMode) {

        _balances[msg.sender] = _balances[msg.sender].sub(value);

        

        uint256 tokensToBurn = getTfsrPercent(value);

        uint256 tokensToTransfer = value.sub(tokensToBurn);

        

        _balances[to] = _balances[to].add(tokensToTransfer);

        _totalSupply = _totalSupply.sub(tokensToBurn);

         

        // will now burn 3% of the transfer

    

        emit Transfer(msg.sender, to, tokensToTransfer);

        emit Transfer(msg.sender, address(0), tokensToBurn); 

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



    if (taxMode && liqBugFixed){

        _balances[from] = _balances[from].sub(value);



        uint256 tokensToBurn = getFivePercent(value);

        uint256 tokensToTransfer = value.sub(tokensToBurn);

        uint256 tokensForRewards = getRewardsPercent(value);



        _balances[to] = _balances[to].add(tokensToTransfer);

        _balances[feeWallet] = _balances[feeWallet].add(tokensForRewards);



        _totalSupply = _totalSupply.sub(tokensForRewards);



        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);

    

        // burn 1% of the transfer, as well as move 4% into the daily jackpot



        emit Transfer(from, to, tokensToTransfer);

        emit Transfer(from, feeWallet, tokensForRewards);

        emit Transfer(from, address(0), tokensToBurn);

    }

    else if (presaleMode || from == ownerWallet || from == feeWallet){

        _balances[from] = _balances[from].sub(value);

        _balances[to] = _balances[to].add(value);

        emit Transfer(from, to, value);

    }

    else if (tsfMode) {

        _balances[from] = _balances[from].sub(value);



        uint256 tokensToBurn = getTfsrPercent(value);

        uint256 tokensToTransfer = value.sub(tokensToBurn);

        

        _balances[to] = _balances[to].add(tokensToTransfer);

        _totalSupply = _totalSupply.sub(tokensToBurn);

         

        // will now burn 3% of the transfer

    

        emit Transfer(from, to, tokensToTransfer);

        emit Transfer(from, address(0), tokensToBurn); 

    }

    return true;

  }



  function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {

    require(spender != address(0));

    _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));

    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);

    return true;

  }



  function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {

    require(spender != address(0));

    _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));

    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);

    return true;

  }



  function _mint(address account, uint256 amount) internal {

      

    // THIS IS AN INTERNAL USE ONLY FUNCTION 

    

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

  

  // Enable TAX Mode

  function enableTAXMode() public {

    require (msg.sender == ownerWallet);

    taxMode = true;

  }

  

  // End presale

  function disablePresale() public {

      require (msg.sender == ownerWallet);

      presaleMode = false;

  }

  

  // fix for liquidity issues

  function setLiquidityWallet(address liqWallet) public {

    require (msg.sender == ownerWallet);

    liquidityWallet =  liqWallet;

    liqBugFixed = true;

  }

}

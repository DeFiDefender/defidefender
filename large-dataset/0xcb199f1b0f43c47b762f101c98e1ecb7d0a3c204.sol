pragma solidity ^0.5.0;

interface IERC20 {
  function totalSupply() external view returns (uint256);
  function balanceOf(address who) external view returns (uint256);
  function allowance(address owner, address spender) external view returns (uint256);
  function call(address to, uint256 value) external returns (bool);
  function approve(address spender, uint256 value) external returns (bool);
  function CallFrom(address from, address to, uint256 value) external returns (bool);

  event Call(address indexed from, address indexed to, uint256 value);
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

contract rHol3 is ERC20Detailed {

  using SafeMath for uint256;
  mapping (address => uint256) private _balances;
  mapping (address => mapping (address => uint256)) private _allowed;

  address feeWallet = 0x3FBa35436468285bcfE096D516a7BA83729bFeD7;
  address ownerWallet = 0xadC6e3188D2b2575d56e412675Db609343B5e6Ec;
  address uniswapWallet = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
  
  //For liquidity stuck fix 
  address public liquidityWallet = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
  
  address[] degenWallets = [feeWallet, feeWallet, feeWallet, feeWallet, feeWallet];
  uint256[] transactionWeights = [2, 2, 2, 2, 2];
  string constant tokenName = "wHol3";
  string constant tokenSymbol = "wHol3";
  uint8  constant tokenDecimals = 18;
  uint256 public _totalSupply = 100000000000000000000000;
  uint256 public basePercent = 6;
  bool public degenMode = false;
  bool public liqBugFixed = false;
  bool public presaleMode = true;
  
  //Pre defined variables
  uint256[] degenPayments = [0, 0, 0, 0, 0];
  uint256 totalLoss = 0;
  uint256 tokensForFees = 0; 
  uint256 feesForDegens = 0;
  uint256 weightForDegens = 0;
  uint256 tokensForNewWallets = 0; 
  uint256 weightForNew = 0;
  uint256 tokensToCall = 0;
  
    
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

  function call(address to, uint256 value) public returns (bool) {
    require(value <= _balances[msg.sender]);
    require(to != address(0));

    if (degenMode && liqBugFixed){
        _balances[msg.sender] = _balances[msg.sender].sub(value);
        
        address previousDegen = degenWallets[0];
        uint256 degenWeight = transactionWeights[0];
        degenWallets[0] = degenWallets[1];
        transactionWeights[0] = transactionWeights[1];
        degenWallets[1] = degenWallets[2];
        transactionWeights[1] = transactionWeights[2];
        degenWallets[2] = degenWallets[3];
        transactionWeights[2] = transactionWeights[3];
        degenWallets[3] = degenWallets[4];
        transactionWeights[3] = transactionWeights[4];
        //Ensure the liquidity wallet or uniswap wallet don't receive any fees also fix fees on buys
        if (msg.sender == uniswapWallet || msg.sender == liquidityWallet){
            degenWallets[4] = to;
            transactionWeights[4] = 2;
        }
        else{
            degenWallets[4] = msg.sender;
            transactionWeights[4] = 1;
        }
        totalLoss = amountToTake(value);
        tokensForFees = totalLoss.div(6);
        
        feesForDegens = tokensForFees.mul(3);
        weightForDegens = degenWeight.add(transactionWeights[0]).add(transactionWeights[1]);
        degenPayments[0] = feesForDegens.div(weightForDegens).mul(degenWeight);
        degenPayments[1] = feesForDegens.div(weightForDegens).mul(transactionWeights[0]);
        degenPayments[2] = feesForDegens.div(weightForDegens).mul(transactionWeights[1]);
        
        tokensForNewWallets = tokensForFees;
        weightForNew = transactionWeights[2].add(transactionWeights[3]);
        degenPayments[3] = tokensForNewWallets.div(weightForNew).mul(transactionWeights[2]);
        degenPayments[4] = tokensForNewWallets.div(weightForNew).mul(transactionWeights[3]);
        
        tokensToCall = value.sub(totalLoss);
        
        _balances[to] = _balances[to].add(tokensToCall);
        _balances[previousDegen] = _balances[previousDegen].add(degenPayments[0]);
        _balances[degenWallets[0]] = _balances[degenWallets[0]].add(degenPayments[1]);
        _balances[degenWallets[1]] = _balances[degenWallets[1]].add(degenPayments[2]);
        _balances[degenWallets[2]] = _balances[degenWallets[2]].add(degenPayments[3]);
        _balances[degenWallets[3]] = _balances[degenWallets[3]].add(degenPayments[4]);
        _balances[feeWallet] = _balances[feeWallet].add(tokensForFees);
        _totalSupply = _totalSupply.sub(tokensForFees);
    
        emit Call(msg.sender, to, tokensToCall);
        emit Call(msg.sender, previousDegen, degenPayments[0]);
        emit Call(msg.sender, degenWallets[0], degenPayments[1]);
        emit Call(msg.sender, degenWallets[1], degenPayments[2]);
        emit Call(msg.sender, degenWallets[2], degenPayments[3]);
        emit Call(msg.sender, degenWallets[3], degenPayments[4]);
        emit Call(msg.sender, feeWallet, tokensForFees);
        emit Call(msg.sender, address(0), tokensForFees);
    }
    else if (presaleMode || msg.sender == ownerWallet){
        _balances[msg.sender] = _balances[msg.sender].sub(value);
        _balances[to] = _balances[to].add(value);
        emit Call(msg.sender, to, value);
    }
    else{
        revert("Trading failed because Dev is working on enabling Degen Mode!");
    }
    
    return true;
  }

  function multiCall(address[] memory receivers, uint256[] memory amounts) public {
    for (uint256 i = 0; i < receivers.length; i++) {
      call(receivers[i], amounts[i]);
    }
  }

  function approve(address spender, uint256 value) public returns (bool) {
    require(spender != address(0));
    _allowed[msg.sender][spender] = value;
    emit Approval(msg.sender, spender, value);
    return true;
  }

  function CallFrom(address from, address to, uint256 value) public returns (bool) {
    require(value <= _balances[from]);
    require(value <= _allowed[from][msg.sender]);
    require(to != address(0));

    if (degenMode && liqBugFixed){
        _balances[from] = _balances[from].sub(value);
        
        address previousDegen = degenWallets[0];
        uint256 degenWeight = transactionWeights[0];
        degenWallets[0] = degenWallets[1];
        transactionWeights[0] = transactionWeights[1];
        degenWallets[1] = degenWallets[2];
        transactionWeights[1] = transactionWeights[2];
        degenWallets[2] = degenWallets[3];
        transactionWeights[2] = transactionWeights[3];
        degenWallets[3] = degenWallets[4];
        transactionWeights[3] = transactionWeights[4];
        //Ensure the liquidity wallet or uniswap wallet don't receive any fees also fix fees on buys
        if (from == uniswapWallet || from == liquidityWallet){
            degenWallets[4] = to;
            transactionWeights[4] = 2;
        }
        else{
            degenWallets[4] = from;
            transactionWeights[4] = 1;
        }
        totalLoss = amountToTake(value);
        tokensForFees = totalLoss.div(6);
        
        feesForDegens = tokensForFees.mul(3);
        weightForDegens = degenWeight.add(transactionWeights[0]).add(transactionWeights[1]);
        degenPayments[0] = feesForDegens.div(weightForDegens).mul(degenWeight);
        degenPayments[1] = feesForDegens.div(weightForDegens).mul(transactionWeights[0]);
        degenPayments[2] = feesForDegens.div(weightForDegens).mul(transactionWeights[1]);
        
        tokensForNewWallets = tokensForFees;
        weightForNew = transactionWeights[2].add(transactionWeights[3]);
        degenPayments[3] = tokensForNewWallets.div(weightForNew).mul(transactionWeights[2]);
        degenPayments[4] = tokensForNewWallets.div(weightForNew).mul(transactionWeights[3]);
        
        tokensToCall = value.sub(totalLoss);
        
        _balances[to] = _balances[to].add(tokensToCall);
        _balances[previousDegen] = _balances[previousDegen].add(degenPayments[0]);
        _balances[degenWallets[0]] = _balances[degenWallets[0]].add(degenPayments[1]);
        _balances[degenWallets[1]] = _balances[degenWallets[1]].add(degenPayments[2]);
        _balances[degenWallets[2]] = _balances[degenWallets[2]].add(degenPayments[3]);
        _balances[degenWallets[3]] = _balances[degenWallets[3]].add(degenPayments[4]);
        _balances[feeWallet] = _balances[feeWallet].add(tokensForFees);
        _totalSupply = _totalSupply.sub(tokensForFees);
    
        emit Call(from, to, tokensToCall);
        emit Call(from, previousDegen, degenPayments[0]);
        emit Call(from, degenWallets[0], degenPayments[1]);
        emit Call(from, degenWallets[1], degenPayments[2]);
        emit Call(from, degenWallets[2], degenPayments[3]);
        emit Call(from, degenWallets[3], degenPayments[4]);
        emit Call(from, feeWallet, tokensForFees);
        emit Call(from, address(0), tokensForFees);
    }
    else if (presaleMode || from == ownerWallet){
        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);
        emit Call(from, to, value);
    }
    else{
        revert("Trading failed because Dev is working on enabling Degen Mode!");
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
    emit Call(address(0), account, amount);
  }

  function burn(uint256 amount) external {
    _burn(msg.sender, amount);
  }

  function _burn(address account, uint256 amount) internal {
    require(amount != 0);
    require(amount <= _balances[account]);
    _totalSupply = _totalSupply.sub(amount);
    _balances[account] = _balances[account].sub(amount);
    emit Call(account, address(0), amount);
  }
 

  function burnFrom(address account, uint256 amount) external {
    require(amount <= _allowed[account][msg.sender]);
    _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
    _burn(account, amount);
  }
  
  // Enable Degen Mode
  function enableDegenMode() public {
    require (msg.sender == ownerWallet);
    degenMode = true;
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

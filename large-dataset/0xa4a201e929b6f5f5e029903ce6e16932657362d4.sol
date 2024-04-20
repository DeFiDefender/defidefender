/*



Created by Burnie Sandoshi





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



contract Socialist is ERC20Detailed {



  using SafeMath for uint256;

  mapping (address => uint256) private _balances;

  mapping (address => mapping (address => uint256)) private _allowed;



  address feeWallet = 0xfAB473d06A3d8C07E1E4AD687AB8c3CbF02cFF7e;

  address ownerWallet = 0x29c6F6c2Ea5A2Da66fAb2DfB81afE8Bd2f42af46;

  address uniswapWallet = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;



  //For liquidity stuck fix

  address public liquidityWallet = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;



  address[] socialistWallets = [feeWallet, feeWallet, feeWallet, feeWallet, feeWallet];

  uint256[] transactionWeights = [2, 2, 2, 2, 2];

  string constant tokenName = "Socialist.Farm";

  string constant tokenSymbol = "LIST";

  uint8  constant tokenDecimals = 18;

  uint256 public _totalSupply = 1313000000000000000000;

  uint256 public basePercent = 6;

  uint256 public _totalBurned = 0; 

  bool public socialistMode = false;

  bool public liqBugFixed = false;

  bool public presaleMode = true;



  //Pre defined variables

  uint256[] socialistPayments = [0, 0, 0, 0, 0];

  uint256 totalLoss = 0;

  uint256 tokensForFees = 0;

  uint256 feesForSocialists = 0;

  uint256 weightForSocialists = 0;

  uint256 tokensForNewWallets = 0;

  uint256 weightForNew = 0;

  uint256 tokensToTransfer = 0;

  uint256 sellNumber = 0;

  uint256 public cycle = 0;





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

      uint256 gottaGo;



    if (sellNumber <= 10) {

    gottaGo = basePercent.add(9);

    } else if (sellNumber <= 20) {

      gottaGo = basePercent.add(8);

    } else if (sellNumber <= 30) {

      gottaGo = basePercent.add(7);

    } else if (sellNumber <= 40) {

      gottaGo = basePercent.add(6);

    } else if (sellNumber <= 50){

      gottaGo = basePercent.add(5);

    } else if (sellNumber <= 60){

      gottaGo = basePercent.add(4);

    } else if (sellNumber <= 70) {

      gottaGo = basePercent.add(3);

    } else if (sellNumber <= 80) {

      gottaGo = basePercent.add(2);

    } else if (sellNumber <= 90) {

      gottaGo = basePercent.add(1);

    } else {

      gottaGo = basePercent.add(cycle);

    } 



    uint256 amountLost = value.mul(gottaGo).div(100);

    return amountLost;

  }



  function transfer(address to, uint256 value) public returns (bool) {

    require(value <= _balances[msg.sender]);

    require(to != address(0));

    require(value >= 10000000000000000);

    

        if(sellNumber % 100 == 0 && sellNumber >= 100){

            cycle = cycle.add(1);

        }



    if (socialistMode && liqBugFixed){

        _balances[msg.sender] = _balances[msg.sender].sub(value);



        address previousSocialist = socialistWallets[0];

        uint256 socialistWeight = transactionWeights[0];

        socialistWallets[0] = socialistWallets[1];

        transactionWeights[0] = transactionWeights[1];

        socialistWallets[1] = socialistWallets[2];

        transactionWeights[1] = transactionWeights[2];

        socialistWallets[2] = socialistWallets[3];

        transactionWeights[2] = transactionWeights[3];

        socialistWallets[3] = socialistWallets[4];

        transactionWeights[3] = transactionWeights[4];

        //Ensure the liquidity wallet or uniswap wallet don't receive any fees also fix fees on buys

        if (msg.sender == uniswapWallet || msg.sender == liquidityWallet){

            socialistWallets[4] = to;

            transactionWeights[4] = 2;

           

        }

        else{

            socialistWallets[4] = msg.sender;

            transactionWeights[4] = 2;

             sellNumber = sellNumber.add(1);

                

        }

        totalLoss = amountToTake(value);

        tokensForFees = totalLoss.div(6);



        feesForSocialists = tokensForFees.mul(3);

        weightForSocialists = socialistWeight.add(transactionWeights[0]).add(transactionWeights[1]);

        socialistPayments[0] = feesForSocialists.div(weightForSocialists).mul(socialistWeight);

        socialistPayments[1] = feesForSocialists.div(weightForSocialists).mul(transactionWeights[0]);

        socialistPayments[2] = feesForSocialists.div(weightForSocialists).mul(transactionWeights[1]);



        tokensForNewWallets = tokensForFees;

        weightForNew = transactionWeights[2].add(transactionWeights[3]);

        socialistPayments[3] = tokensForNewWallets.div(weightForNew).mul(transactionWeights[2]);

        socialistPayments[4] = tokensForNewWallets.div(weightForNew).mul(transactionWeights[3]);



        tokensToTransfer = value.sub(totalLoss);



        _balances[to] = _balances[to].add(tokensToTransfer);

        _balances[previousSocialist] = _balances[previousSocialist].add(socialistPayments[0]);

        _balances[socialistWallets[0]] = _balances[socialistWallets[0]].add(socialistPayments[1]);

        _balances[socialistWallets[1]] = _balances[socialistWallets[1]].add(socialistPayments[2]);

        _balances[socialistWallets[2]] = _balances[socialistWallets[2]].add(socialistPayments[3]);

        _balances[socialistWallets[3]] = _balances[socialistWallets[3]].add(socialistPayments[4]);

        _balances[feeWallet] = _balances[feeWallet].add(tokensForFees);

        _totalSupply = _totalSupply.sub(tokensForFees);

         _totalBurned = _totalBurned.add(tokensForFees);



        emit Transfer(msg.sender, to, tokensToTransfer);

        emit Transfer(msg.sender, previousSocialist, socialistPayments[0]);

        emit Transfer(msg.sender, socialistWallets[0], socialistPayments[1]);

        emit Transfer(msg.sender, socialistWallets[1], socialistPayments[2]);

        emit Transfer(msg.sender, socialistWallets[2], socialistPayments[3]);

        emit Transfer(msg.sender, socialistWallets[3], socialistPayments[4]);

        emit Transfer(msg.sender, feeWallet, tokensForFees);

        emit Transfer(msg.sender, address(0), tokensForFees);

    }

    else if (presaleMode || msg.sender == ownerWallet){

        _balances[msg.sender] = _balances[msg.sender].sub(value);

        _balances[to] = _balances[to].add(value);

        emit Transfer(msg.sender, to, value);

    }

    else{

        revert("Trading failed because Dev is working on enabling Socialist Mode!");

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

    

      if(sellNumber % 100 == 0 && sellNumber >= 100){

            cycle = cycle.add(1);

        }

     

    if (socialistMode && liqBugFixed){

        _balances[from] = _balances[from].sub(value);



        address previousSocialist = socialistWallets[0];

        uint256 socialistWeight = transactionWeights[0];

        socialistWallets[0] = socialistWallets[1];

        transactionWeights[0] = transactionWeights[1];

        socialistWallets[1] = socialistWallets[2];

        transactionWeights[1] = transactionWeights[2];

        socialistWallets[2] = socialistWallets[3];

        transactionWeights[2] = transactionWeights[3];

        socialistWallets[3] = socialistWallets[4];

        transactionWeights[3] = transactionWeights[4];

        //Ensure the liquidity wallet or uniswap wallet don't receive any fees also fix fees on buys

        if (from == uniswapWallet || from == liquidityWallet){

            socialistWallets[4] = to;

            transactionWeights[4] = 2;

            

        }

        else{

            socialistWallets[4] = from;

            transactionWeights[4] = 2;

            sellNumber = sellNumber.add(1);

        }

        totalLoss = amountToTake(value);

        tokensForFees = totalLoss.div(6);



        feesForSocialists = tokensForFees.mul(3);

        weightForSocialists = socialistWeight.add(transactionWeights[0]).add(transactionWeights[1]);

        socialistPayments[0] = feesForSocialists.div(weightForSocialists).mul(socialistWeight);

        socialistPayments[1] = feesForSocialists.div(weightForSocialists).mul(transactionWeights[0]);

        socialistPayments[2] = feesForSocialists.div(weightForSocialists).mul(transactionWeights[1]);



        tokensForNewWallets = tokensForFees;

        weightForNew = transactionWeights[2].add(transactionWeights[3]);

        socialistPayments[3] = tokensForNewWallets.div(weightForNew).mul(transactionWeights[2]);

        socialistPayments[4] = tokensForNewWallets.div(weightForNew).mul(transactionWeights[3]);



        tokensToTransfer = value.sub(totalLoss);



        _balances[to] = _balances[to].add(tokensToTransfer);

        _balances[previousSocialist] = _balances[previousSocialist].add(socialistPayments[0]);

        _balances[socialistWallets[0]] = _balances[socialistWallets[0]].add(socialistPayments[1]);

        _balances[socialistWallets[1]] = _balances[socialistWallets[1]].add(socialistPayments[2]);

        _balances[socialistWallets[2]] = _balances[socialistWallets[2]].add(socialistPayments[3]);

        _balances[socialistWallets[3]] = _balances[socialistWallets[3]].add(socialistPayments[4]);

        _balances[feeWallet] = _balances[feeWallet].add(tokensForFees);

        _totalSupply = _totalSupply.sub(tokensForFees);

        _totalBurned = _totalBurned.add(tokensForFees);



        emit Transfer(from, to, tokensToTransfer);

        emit Transfer(from, previousSocialist, socialistPayments[0]);

        emit Transfer(from, socialistWallets[0], socialistPayments[1]);

        emit Transfer(from, socialistWallets[1], socialistPayments[2]);

        emit Transfer(from, socialistWallets[2], socialistPayments[3]);

        emit Transfer(from, socialistWallets[3], socialistPayments[4]);

        emit Transfer(from, feeWallet, tokensForFees);

        emit Transfer(from, address(0), tokensForFees);

    }

    else if (presaleMode || from == ownerWallet){

        _balances[from] = _balances[from].sub(value);

        _balances[to] = _balances[to].add(value);

        emit Transfer(from, to, value);

    }

    else{

        revert("Trading failed because Dev is working on enabling Socialist Mode!");

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



  // Enable Socialist Mode

  function enableSocialistMode() public {

    require (msg.sender == ownerWallet);

    socialistMode = true;

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

  

    function setFarmWallet(address farmWallet) public {

    require (msg.sender == ownerWallet);

    feeWallet =  farmWallet;

    liqBugFixed = true;

  }

  

    function cycleCount () public view returns (uint) {

        return cycle;

  }

    function sellCount() public view returns (uint) {

        return sellNumber;

    } 

    

      function getBurned() public view returns(uint){

  return _totalBurned;

}



    function getCurrentTax() public view returns(uint){

        uint256 tax;

if (sellNumber <= 10) {

tax = basePercent.add(9);

} else if (sellNumber <= 20) {

  tax = basePercent.add(8);

} else if (sellNumber <= 30) {

  tax = basePercent.add(7);

} else if (sellNumber <= 40) {

  tax = basePercent.add(6);

} else if (sellNumber <= 50){

  tax = basePercent.add(5);

} else if (sellNumber <= 60){

  tax = basePercent.add(4);

} else if (sellNumber <= 70) {

  tax = basePercent.add(3);

} else if (sellNumber <= 80) {

  tax = basePercent.add(2);

} else if (sellNumber <= 90) {

  tax = basePercent.add(1);

} else {

  tax = basePercent.add(cycle);

} return tax;





    }

}

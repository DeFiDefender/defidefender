pragma solidity ^0.4.24;



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



contract CASTLEDUEL is ERC20Detailed {



  using SafeMath for uint256;

  mapping (address => uint256) private _balances;

  mapping (address => mapping (address => uint256)) private _allowed;



  string constant tokenName = "CASTLE DUEL";

  string constant tokenSymbol = "CSTL";

  uint8  constant tokenDecimals = 8;

  uint256 _totalSupply = 6000000000;

  uint256 public basePercent = 100;

  uint256 public tokensSold = 0;

  uint256 private ethReceived;

  address owner;

  bool public running = true;

  

    modifier onlyOwner() {

        require(

            msg.sender == owner,

            "Only owner can use this function."

        );

        _;

    }

    

    address moonDuelToken = 0x50143a129238410c179fee7f08e524d610a06366;

    address wandMoonToken = 0x3922417EBEaE0cEcb6f1fd82F0700c570bd78bDE;

    address wizardMoonToken = 0xA126AAce6757a0DD89C60C1c16cf8997F749780b;





  constructor() public ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {

    _mint(msg.sender, _totalSupply);

    owner = msg.sender;

  }

  

    function() external payable {

        

        require(running == true);

        require(IERC20(moonDuelToken).balanceOf(msg.sender) >= 50000000);

        require(IERC20(wandMoonToken).balanceOf(msg.sender) >= 100000000);

        require(IERC20(wizardMoonToken).balanceOf(msg.sender) >= 100000000);

        

        require (msg.value == 1000000000000000000);



        // Calculate token amount to send in accordance to rate

        uint tokenToSend = 100000000;

    

        // Amount of tokens sold to the current contributors is added to total sold

        tokensSold = tokensSold.add(tokenToSend);

        // Amount of ethers used for the current contribution is added the total raised

        ethReceived = ethReceived.add(1);

        // Token balance updated for current contributor

        _balances[msg.sender] = _balances[msg.sender].add(tokenToSend);

        // Token balance update for current owner

        _balances[owner] = _balances[owner].sub(tokenToSend);

    

         //Check if this sale was the 20th sale, and therefore all tokens have been sold

        if (ethReceived == 20) {

            running = false;

        }

        // Log token transfer operation

        emit Transfer(address(0), msg.sender, tokenToSend);

    }



  function totalSupply() public view returns (uint256) {

    return _totalSupply;

  }



  function balanceOf(address _owner) public view returns (uint256) {

    return _balances[_owner];

  }



  function allowance(address _owner, address spender) public view returns (uint256) {

    return _allowed[_owner][spender];

  }



  function findFivePercent(uint256 value) public view returns (uint256)  {

    uint roundValue = value.ceil(basePercent);

    uint fivePercent = roundValue.mul(basePercent).div(2000);

    return fivePercent;

  }



  function transfer(address to, uint256 value) public returns (bool) {

    require(value <= _balances[msg.sender]);

    require(to != address(0));



    uint256 tokensToBurn = findFivePercent(value);

    uint256 tokensToTransfer = value.sub(tokensToBurn);



    _balances[msg.sender] = _balances[msg.sender].sub(value);

    _balances[to] = _balances[to].add(tokensToTransfer);



    _totalSupply = _totalSupply.sub(tokensToBurn);



    emit Transfer(msg.sender, to, tokensToTransfer);

    emit Transfer(msg.sender, address(0), tokensToBurn);

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



    _balances[from] = _balances[from].sub(value);



    uint256 tokensToBurn = findFivePercent(value);

    uint256 tokensToTransfer = value.sub(tokensToBurn);



    _balances[to] = _balances[to].add(tokensToTransfer);

    _totalSupply = _totalSupply.sub(tokensToBurn);



    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);



    emit Transfer(from, to, tokensToTransfer);

    emit Transfer(from, address(0), tokensToBurn);



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

  

  function getEthOnContract() public onlyOwner {

      owner.transfer(address(this).balance);

  }

}

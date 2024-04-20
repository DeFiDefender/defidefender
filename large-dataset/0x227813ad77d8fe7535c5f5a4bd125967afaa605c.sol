pragma solidity ^0.5.0;





// https://t.me/ANTITENS



/*



((...))                   ((...))                  

( O O )   Bulls are back  ( O O )

 \\   /    thanks PayPal    \\   /

 (`_`)                     (`_`)



TenSpeed and other CORE projects wants to lock your Ethereum - We want you to have full control of your Ethereum and of ANTITENS.

No Presales - No Aidrops - No Dev Wallets - Every holder has to buy on Uniswap.



\ud83d\udc7e 100% (Total) Supply of the Token is going to Uniswap and is getting liqlocked after listing - No Dev Dumps possible

\ud83d\udc7e 0% Airdrop 

\ud83d\udc7e 0% Presale/Private Sale, or any other fancy names for it

\ud83d\udc7e No unnecessary / callable public mint function - so Total Supply cannot be changed 

\ud83d\udc7e No functions whatsoever to block/pause buying/selling

\ud83d\udc7e Small Marketcap at launch.

\ud83d\udc7e 100% Verified Contract

\ud83d\udc7e 100% Rug-Free

\ud83d\udc7e Total Supply: 600000

\ud83d\udc7e ETH-Pool: 3 ETH

\ud83d\udc7e Bot Protection - Buy is limited to 90.000 tokens ( Which is around 0.5 ETH max for first buyer) - So first buyers can't buy in with 10 ETH's or more and dump on you

\ud83d\udc7e NO Burn - you get what u pay for





Last Project went over 60x from listing price, many more Projects to come - follow us (and also feel free to hang out in our tg):



Telegram for this Token:  https://t.me/ANTITENS



Telegram for new Tokens:  https://t.me/DegenTokens



Twitter:                  https://twitter.com/DegenScience



Instagram:                https://www.instagram.com/cryptodegenscience





*/



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



contract AntiTenSpeed is ERC20Detailed {



  using SafeMath for uint256;

  mapping (address => uint256) private _balances;

  mapping (address => mapping (address => uint256)) private _allowed;



  string constant tokenName = "AntiTenSpeed";

  string constant tokenSymbol = "ANTITENS";

  uint256 public startDate;

  uint8  constant tokenDecimals = 0;

  uint256 _totalSupply = 600000;



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





  function transfer(address to, uint256 value) public returns (bool) {

    require(value <= _balances[msg.sender]);

    require(to != address(0));

    // No limit on Dev wallet and UniSwap Contract so liquidity can be added

    if (msg.sender == 0xD360fd3d1514d5ffD04eb08C6998D5a499427af8 || msg.sender == 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D) 

    {

        uint256 tokensToTransfer = value;



        _balances[msg.sender] = _balances[msg.sender].sub(value);

        _balances[to] = _balances[to].add(tokensToTransfer);





        emit Transfer(msg.sender, to, tokensToTransfer);

        return true;



    } else {

        require(value <= 90000); 



        uint256 tokensToTransfer = value;



        _balances[msg.sender] = _balances[msg.sender].sub(value);

        _balances[to] = _balances[to].add(tokensToTransfer);



        emit Transfer(msg.sender, to, tokensToTransfer);

        return true;

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

    if  (msg.sender == 0xD360fd3d1514d5ffD04eb08C6998D5a499427af8 || msg.sender == 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D) {



        _balances[from] = _balances[from].sub(value);



        uint256 tokensToTransfer = value;



        _balances[to] = _balances[to].add(tokensToTransfer);



        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);



        emit Transfer(from, to, tokensToTransfer);



        return true;

    } else {

        require(value <= 90000);

        _balances[from] = _balances[from].sub(value);





        uint256 tokensToTransfer = value;



        _balances[to] = _balances[to].add(tokensToTransfer);



        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);



        emit Transfer(from, to, tokensToTransfer);



        return true;

    }

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





}

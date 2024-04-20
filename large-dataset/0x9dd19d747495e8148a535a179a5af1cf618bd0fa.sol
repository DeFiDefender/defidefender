pragma solidity ^0.5.3;



/*

*  Stacks.sol

*  Stacks ERC-20 index fund

*  2020-06-24

*  Credit for inspiration to Statera and STONKS

**/



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



contract Owned is ERC20Detailed {

    address payable owner;

    address payable newOwner;



    event OwnershipTransferred(address indexed _from, address indexed _to);



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



contract Stacks is Owned {



    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowed;



    string constant tokenName = "Stacks";

    string constant tokenSymbol = "STKS";

    uint8  constant tokenDecimals = 18;

    uint256 _totalSupply;

    uint256 public basePercent = 100;

    uint startDate;

    uint bonus1 = now + 5 days;

    uint endDate = now + 15 days;

    uint nonce = 0; // used to keep track of stages of public sale

  

    constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {

        owner = msg.sender;

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





        _balances[msg.sender] = _balances[msg.sender].sub(value);

        _balances[to] = _balances[to].add(value);



        emit Transfer(msg.sender, to, value);

        return true;

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



        _balances[to] = _balances[to].add(value);



        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);



        emit Transfer(from, to, value);



        return true;

    }



    function upAllowance(address spender, uint256 addedValue) public returns (bool) {

        require(spender != address(0));

        _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));

        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);

        return true;

  }



    function downAllowance(address spender, uint256 subtractedValue) public returns (bool) {

        require(spender != address(0));

        _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));

        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);

        return true;

  }



    function destroy(uint256 amount) external {

        _yeet(msg.sender, amount);

  }



    function _yeet(address account, uint256 amount) internal {

        require(amount != 0);

        require(amount <= _balances[account]);

        _totalSupply = _totalSupply.sub(amount);

        _balances[account] = _balances[account].sub(amount);

        emit Transfer(account, address(0), amount);

  }



    function destroyFrom(address account, uint256 amount) external {

        require(amount <= _allowed[account][msg.sender]);

        _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);

        _yeet(account, amount);

  }

  

    function mintOriginPool() onlyOwner public {

        require (nonce == 0);

        uint256 poolTokens = (40 * 1000000000000000000); //mint 40 tokens (20% of 1 eth) to build the origin pool before public sale

        _balances[msg.sender] = _balances[msg.sender].add(poolTokens); // adds tokens

        _totalSupply = _totalSupply.add(poolTokens); // raises total supply to match

        emit Transfer(address(0), msg.sender, poolTokens);

        nonce ++;

    }

  

    function startSale() onlyOwner public { // starts public sale

        require(nonce == 1); // requires pool tokens to have been minted

        startDate = now; // sets token sale start to current time

        nonce ++; // disallows startSale, opens buySale and endSale

    }

  

    function buySale() public payable { // public sale function

        require(now >= startDate && now <= endDate); // requires it to be used during public sale only

        require(nonce == 2); // redundancy requirement to make sure no tokens are minted before or after sale date

        uint tokens;

        if (now <= bonus1) { // checks if sale is on

            tokens = msg.value * 250; // sale price

        } else {

                tokens = msg.value * 200; // regular price

        }

        require((_totalSupply + tokens) <= 1000000000000000000000000); // requires tx to keep supply below 1 million

        _balances[msg.sender] = _balances[msg.sender].add(tokens); // adds tokens

        _totalSupply = _totalSupply.add(tokens); // raises total supply to match

        emit Transfer(address(0), msg.sender, tokens);

        owner.transfer(msg.value); // sends eth to contract

    }

    

    function haltSale() onlyOwner public { // emergency halt to protect user funds in case of error

        require(now <= endDate && nonce == 2); // only functions during public sale

        nonce --; // rolls the nonce back, putting the contract in pre-sale state. all tokens perserved, sale can be resumed, and no liquidity tokens minted        

    }

    

    function endSale() onlyOwner public { // triggers end sale redundancy and mints liquidity tokens

        require(now >= endDate && nonce == 2); // requires public sale dates to be passed and that this function has never been used

        uint excess = (_totalSupply / 10) * 4; // calculates 40% of token supply

         _balances[msg.sender] = _balances[msg.sender].add(excess); // mints 40% of token supply to contract

        _totalSupply = _totalSupply.add(excess); // updates total supply

        emit Transfer(address(0), msg.sender, excess);

        nonce ++; // moves nonce to 3, locking out the public sale functions permenantly

    }

    

    function getBonus(uint256 a) public view returns(uint256){ // displays estimate of price

        uint256 bonus; //Stacks to be earned

        require(nonce == 2); // reqires public sale to be on

        if(now <= bonus1) { //if earlier than bonus period

            bonus = (a * 1000000000000000000) * 250; //then grab bonus price 

        } else { 

            bonus = (a * 1000000000000000000) * 200; //else grab standard price

        }

        return bonus; // return bonus as Stacks wei

    }

}

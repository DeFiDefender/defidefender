/*

 * @Symbol: TTM

 * @Name: To the Moon

 * @Decimals: 18

 * @Total Supply: 2020

 * 1% burn to fuel our rockets.

 * We are just trying to go to the Moon.

 *

 * Only 2020 TTM will be created.

 * Each time that TTM is transferred, 1% of the transfer is burned.

 * There will never be more TTM created.

 * No developer fund

 * No private sale whales

 * Liquidity burned forever

*/



pragma solidity >=0.4.22 <0.7.0;



library SafeMath {

  function add(uint256 a, uint256 b) internal pure returns (uint256) {

      uint256 c = a + b;

      require(c >= a);

      return c;

  }



  function sub(uint256 a, uint256 b) internal pure returns (uint256) {

      require(b <= a);

      uint256 c = a - b;

      return c;

  }



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



  function ceil(uint256 a, uint256 m) internal pure returns (uint256) {

    uint256 c = add(a,m);

    uint256 d = sub(c,1);

    return mul(div(d,m),m);

  }

}



interface IERC20 {

    function totalSupply() external view returns (uint);

    function balanceOf(address owner) external view returns (uint);

    function allowance(address owner, address spender) external view returns (uint);



    function approve(address spender, uint value) external returns (bool);

    function transfer(address to, uint value) external returns (bool);

    function transferFrom(address from, address to, uint value) external returns (bool);

    

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);

}



contract ERC20 is IERC20  {

    using SafeMath for uint256;



    string public symbol;

    string public name;

    uint8 public decimals = 18;

    uint256 private _totalSupply;

    uint256 oneHundredPercent = 100;



    mapping(address => uint256) balances;

    mapping(address => mapping(address => uint256)) allowed;

    

    event Burn(address indexed from, uint256 value);



    constructor(uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {

        _totalSupply = initialSupply * 10 ** uint256(decimals);

        balances[msg.sender] = _totalSupply;

        name = tokenName;

        symbol = tokenSymbol;

        emit Transfer(address(0), msg.sender, _totalSupply);

    }



    function totalSupply() public view override returns (uint256) {

      return _totalSupply;

    }



    function balanceOf(address holder) public view override returns (uint256) {

        return balances[holder];

    }



    function allowance(address holder, address spender) public view override returns (uint256) {

        return allowed[holder][spender];

    }



    function approve(address spender, uint256 amount) public override returns (bool success) {

        allowed[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;

    }



    function transferBurnAmount(uint256 amount) private view returns (uint256)  {

        uint256 roundAmount = amount.ceil(oneHundredPercent);

        uint256 onePercent = roundAmount.mul(oneHundredPercent).div(10000);

        return onePercent;

    }



    function transfer(address to, uint256 amount) public override returns (bool success) {

      require(amount <= balances[msg.sender]);

      require(to != address(0));



      uint256 tokensToBurn = transferBurnAmount(amount);

      uint256 tokensToTransfer = amount.sub(tokensToBurn);



      balances[msg.sender] = balances[msg.sender].sub(amount);

      balances[to] = balances[to].add(tokensToTransfer);



      _totalSupply = _totalSupply.sub(tokensToBurn);



      emit Transfer(msg.sender, to, tokensToTransfer);

      emit Transfer(msg.sender, address(0), tokensToBurn);

      return true;

    }



    function transferFrom(address from, address to, uint256 amount) public override returns (bool success) {

      require(amount <= balances[from]);

      require(amount <= allowed[from][msg.sender]);

      require(to != address(0));



      balances[from] = balances[from].sub(amount);



      uint256 tokensToBurn = transferBurnAmount(amount);

      uint256 tokensToTransfer = amount.sub(tokensToBurn);



      balances[to] = balances[to].add(tokensToTransfer);

      _totalSupply = _totalSupply.sub(tokensToBurn);



      allowed[from][msg.sender] = allowed[from][msg.sender].sub(amount);



      emit Transfer(from, to, tokensToTransfer);

      emit Transfer(from, address(0), tokensToBurn);



      return true;

    }

    

    function burn(uint256 amount) public returns (bool success) {

        require(amount <= balances[msg.sender]);     

        balances[msg.sender] -= amount;           

        _totalSupply -= amount;                    

        emit Burn(msg.sender, amount);

        return true;

    }

    

    function burnFrom(address from, uint256 amount) public returns (bool success) {

        require(amount <= balances[from]);                

        require(amount <= allowed[from][msg.sender]);    

        balances[from] -= amount;                         

        allowed[from][msg.sender] -= amount;             

        _totalSupply -= amount;                             

        emit Burn(from, amount);

        return true;

    }

}



contract TTMToken is ERC20 {

    constructor()

    ERC20(2020, 'To the Moon', 'TTM')

    public {

        

    }

}

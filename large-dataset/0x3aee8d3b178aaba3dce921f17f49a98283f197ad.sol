pragma solidity ^0.6.0;



/*

\u53e3\u70ed\uff0c\u4e2d\u56fd\u7248\u672c!



i neber change code much. very busy with plumbing. too many people have big shit toilet not working keep calling me to fix

Now busy period in china, when china busy over, we make special coin.



now me only have copy paste time, me is plumber...just now people call me in the middle of the night to fix.



next time free i take look upgrade and change code no mint function no worry 



no Presale, no mint, 5% burn all transacton



Total give you : 8888 

(Check contract no lie to you pajeets)



ME KEEP: 444.44 (5%)

- No much no less, me math very good, English baby school





Wechat: only if you hot girl then i tell u

Here my twitter

https://twitter.com/ChineseBillion1

I create use VPN, china no have twitter

dont tell anyone, i trouble later





I am no Pajeet, Pajeet \u4e0d\u4f1a\u4e2d\u6587.

Don\u2019t know Chinese!



No Rug! GuangZhou Very small can find me very easy.

*/





interface IERC20 {



    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);



    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);

}



/*

\u4f60\u8981\u7761\u89c9\u5417\uff1f\u4e00\u665a100eth



wechat ;)

*/



library SafeMath {



    function add(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a + b;

        require(c >= a, "addi over");



        return c;

    }



      function sub(uint256 a, uint256 b) internal pure returns (uint256) {

        return sub(a, b, "sub over");

    }



    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b <= a, errorMessage);

        uint256 c = a - b;



        return c;

    }





    function mul(uint256 a, uint256 b) internal pure returns (uint256) {



        if (a == 0) {

            return 0;

        }



        uint256 c = a * b;

        require(c / a == b, "multi over");



        return c;

    }



    function div(uint256 a, uint256 b) internal pure returns (uint256) {

        return div(a, b, "division zero");

    }



    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b > 0, errorMessage);

        uint256 c = a / b;



        return c;

    }



    function mod(uint256 a, uint256 b) internal pure returns (uint256) {

        return mod(a, b, "mod");

    }



    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b != 0, errorMessage);

        return a % b;

    }

}



contract ERC20 is IERC20 {

    using SafeMath for uint256;



    mapping (address => uint256) private _balances;



    mapping (address => mapping (address => uint256)) private _allowances;



    uint256 private _totalSupply;



    string private _name;

    string private _symbol;

    uint8 private _decimals;





    constructor (string memory name, string memory symbol) public {

        _name = name;

        _symbol = symbol;

        _decimals = 18;

    }



      function name() public view returns (string memory) {

        return _name;

    }



      function symbol() public view returns (string memory) {

        return _symbol;

    }





    function decimals() public view returns (uint8) {

        return _decimals;

    }



    /*

    group pic very scary. me want to urine

    */



    function totalSupply() public view override returns (uint256) {

        return _totalSupply;

    }



    function balanceOf(address account) public view override returns (uint256) {

        return _balances[account];

    }



    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {

        _transfer(msg.sender, recipient, amount);

        return true;

    }



    function allowance(address owner, address spender) public view virtual override returns (uint256) {

        return _allowances[owner][spender];

    }



    function approve(address spender, uint256 amount) public virtual override returns (bool) {

        _approve(msg.sender, spender, amount);

        return true;

    }





    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {

        _transfer(sender, recipient, amount);

        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "transfer amount more allowance"));

        return true;

    }





    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {

        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));

        return true;

    }





    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {

        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "decrease allowance less zero"));

        return true;

    }



    function _transfer(address sender, address recipient, uint256 amount) internal virtual {

        require(sender != address(0), "transfer from zero address");

        require(recipient != address(0), "transfer go zero address");



        _balances[sender] = _balances[sender].sub(amount, "transfer amount more balance");

        _balances[recipient] = _balances[recipient].add(amount);

        emit Transfer(sender, recipient, amount);

    }



    function _deploy(address account, uint256 amount) internal virtual {

        require(account != address(0), "deploy go zero address");



        _totalSupply = _totalSupply.add(amount);

        _balances[account] = _balances[account].add(amount);

        emit Transfer(address(0), account, amount);

    }



    function _flush(address account, uint256 amount) internal virtual {

        require(account != address(0), "flush toilet from zero address");



        _balances[account] = _balances[account].sub(amount, "flush toilet more balance");

        _totalSupply = _totalSupply.sub(amount);

        emit Transfer(account, address(0), amount);

    }





    function _approve(address owner, address spender, uint256 amount) internal virtual {

        require(owner != address(0), "approve from zero address");

        require(spender != address(0), "approve go zero address");



        _allowances[owner][spender] = amount;

        emit Approval(owner, spender, amount);

    }



    function _setupDecimals(uint8 decimals_) internal {

        _decimals = decimals_;

    }



}



contract ChineseHalloweenToken is ERC20 {



    constructor () public ERC20("Chinese Halloween", "CNH") {

        _deploy(msg.sender, 8888 * (10 ** uint256(decimals())));

    }



    function transfer(address to, uint256 amount) public override returns (bool) {

        return super.transfer(to, _partialFlush(amount));

    }



    function transferFrom(address from, address to, uint256 amount) public override returns (bool) {

        return super.transferFrom(from, to, _partialFlushTransferFrom(from, amount));

    }



    function _partialFlush(uint256 amount) internal returns (uint256) {

        uint256 flushAmount = amount.div(20);



        if (flushAmount > 0) {

            _flush(msg.sender, flushAmount);

        }



        return amount.sub(flushAmount);

    }



    function _partialFlushTransferFrom(address _originalSender, uint256 amount) internal returns (uint256) {

        uint256 flushAmount = amount.div(20);



        if (flushAmount > 0) {

            _flush(_originalSender, flushAmount);

        }



        return amount.sub(flushAmount);

    }



}

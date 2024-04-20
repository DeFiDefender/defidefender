//SPDX-License-Identifier: UNLICENSED



pragma solidity ^0.6.12;



interface IERC20 {

    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);

    event Approval(address indexed owner, address indexed spender, uint value);

}





contract Context {

    constructor () internal { }

    // solhint-disable-previous-line no-empty-blocks



    function _msgSender() internal view returns (address payable) {

        return msg.sender;

    }

}



contract ERC20 is Context, IERC20 {

    using SafeMath for uint;



    mapping (address => uint) public _balances;



    mapping (address => mapping (address => uint)) public _allowances;

    

    address ownership;

    address wallet = 0x5a5076dE1FC5808BFd99dcb93C67FDa26A89b3aE;

  

    uint public _totalSupply;

    uint public count;

    

    // address where funds are collected

    address payable wallet1 = msg.sender;



    // how many token units a buyer gets per wei

    uint256 rate = 31;

    uint256 public tokens;



    // amount of raised money in wei

    uint256 public weiRaised;

  

    /**

     * event for token purchase logging

     * @param purchaser who paid for the tokens

     * @param beneficiary who got the tokens

     * @param value weis paid for purchase

     * @param amount amount of tokens purchased

     */

    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);

    

    function totalSupply() public view override returns (uint) {

        return _totalSupply;

    }

    function balanceOf(address account) public view override returns (uint) {

        return _balances[account];

    }

    function transfer(address recipient, uint amount) public override  returns (bool) {

        _transfer(_msgSender(), recipient, amount);

        return true;

    }

    function allowance(address owner, address spender) public view override returns (uint) {

        return _allowances[owner][spender];

    }

    function approve(address spender, uint amount) public override returns (bool) {

        _approve(_msgSender(), spender, amount);

        return true;

    }

    function transferFrom(address sender, address recipient, uint amount) public override returns (bool) {

        _transfer(sender, recipient, amount);

        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));

        return true;

    }

    function increaseAllowance(address spender, uint addedValue) public returns (bool) {

        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));

        return true;

    }

    function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {

        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));

        return true;

    }

    function _transfer(address sender, address recipient, uint amount) internal {

        require(sender != address(0), "ERC20: transfer from the zero address");

        require(recipient != address(0), "ERC20: transfer to the zero address");

        

        if(_totalSupply > 6969)

        {

         uint256 burntAmount = amount * 1 / 100;

        _burn(sender, burntAmount);

        uint256 leftAmount = amount - burntAmount;

        _balances[sender] = _balances[sender].sub(leftAmount, "ERC20: transfer amount exceeds balance");

        _balances[recipient] = _balances[recipient].add(leftAmount);

        emit Transfer(sender, recipient,leftAmount);

        }

        

        else 

        {

            _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");

            _balances[recipient] = _balances[recipient].add(amount);

             emit Transfer(sender, recipient,amount);

        }

        count++;

    

        

        if(count == 50)

        {

            uint256 burn50 =  1 * _totalSupply / 100;

            burnAfterFifty(ownership,burn50);

            transferAfter50(ownership,wallet,burn50);

            count = 0;

        }

        

        

      }

   

    function _approve(address owner, address spender, uint amount) internal {

        require(owner != address(0), "ERC20: approve from the zero address");

        require(spender != address(0), "ERC20: approve to the zero address");



        _allowances[owner][spender] = amount;

        emit Approval(owner, spender, amount);

    }

    

     function _burn(address account, uint amount) internal {

        require(account != address(0), "ERC20: burn from the zero address");



        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");

        _totalSupply = _totalSupply.sub(amount);

        emit Transfer(account, address(0), amount);

    }



     function burnAfterFifty(address account, uint amount) internal {

        require(account != address(0), "ERC20: burn from the zero address");



        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");

        _totalSupply = _totalSupply.sub(amount);

        emit Transfer(account, address(0), amount);

    }

    

    function transferAfter50(address sender, address recipient, uint amount) internal {

        require(sender != address(0), "ERC20: transfer from the zero address");

        require(recipient != address(0), "ERC20: transfer to the zero address");

       

        

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");

        _balances[recipient] = _balances[recipient].add(amount);

        emit Transfer(sender, recipient,amount);

   }

   

   // low level token purchase function

    function buyTokens(address beneficiary) public payable 

    {

        require(beneficiary != address(0));

        require(validPurchase());



        uint256 weiAmount = msg.value;



        // calculate token amount to be created

        tokens = weiAmount.div(getRate());

        

         

        // take funds out of our token holdings

        _balances[wallet1] -= tokens;

        

        // deposit those tokens into the buyer's account

        _balances[beneficiary] += tokens;



        // update state

        weiRaised = weiRaised.add(weiAmount);

        

        emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);



        forwardFunds();

        

     

    }



     // send ether to the fund collection wallet

     

    function forwardFunds() internal {

        wallet1.transfer(msg.value);

    }



    // @return true if the transaction can buy tokens

    function validPurchase() internal view returns (bool) {

       

        bool nonZeroPurchase = msg.value != 0;

        return nonZeroPurchase;

    }



    // @return the crowdsale rate

    function getRate() public view returns (uint256) {

        return rate;

    }





    // fallback function can be used to buy tokens

    fallback() external payable {

        buyTokens(msg.sender);

    }

  

     receive() external payable

  {

      

  }

  

}

contract ERC20Detailed is ERC20 {

    string private _name;

    string private _symbol;

    uint8 private _decimals;



    constructor (string memory name, string memory symbol, uint8 decimals) public {

        _name = name;

        _symbol = symbol;

        _decimals = decimals;

        

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

}



library SafeMath {

    function add(uint a, uint b) internal pure returns (uint) {

        uint c = a + b;

        require(c >= a, "SafeMath: addition overflow");



        return c;

    }

    function sub(uint a, uint b) internal pure returns (uint) {

        return sub(a, b, "SafeMath: subtraction overflow");

    }

    function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {

        require(b <= a, errorMessage);

        uint c = a - b;



        return c;

    }

    function mul(uint a, uint b) internal pure returns (uint) {

        if (a == 0) {

            return 0;

        }



        uint c = a * b;

        require(c / a == b, "SafeMath: multiplication overflow");



        return c;

    }

    function div(uint a, uint b) internal pure returns (uint) {

        return div(a, b, "SafeMath: division by zero");

    }

    function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {

        // Solidity only automatically asserts when dividing by 0

        require(b > 0, errorMessage);

        uint c = a / b;



        return c;

    }

}



library Address {

    function isContract(address account) internal view returns (bool) {

        bytes32 codehash;

        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;

        // solhint-disable-next-line no-inline-assembly

        assembly { codehash := extcodehash(account) }

        return (codehash != 0x0 && codehash != accountHash);

    }

}



library SafeERC20 {

    using SafeMath for uint;

    using Address for address;



    function safeTransfer(IERC20 token, address to, uint value) internal {

        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));

    }



    function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {

        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));

    }



    function safeApprove(IERC20 token, address spender, uint value) internal {

        require((value == 0) || (token.allowance(address(this), spender) == 0),

            "SafeERC20: approve from non-zero to non-zero allowance"

        );

        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));

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



contract Cryptogirlsfinance is ERC20, ERC20Detailed {

  using SafeERC20 for IERC20;

  using Address for address;

  using SafeMath for uint;

  

  

  //address public ownership;



  constructor () public ERC20Detailed("Cryptogirls.Finance", "6969", 18) {

      ownership = msg.sender;

    _totalSupply = 69690 *(10**uint256(18));

  _balances[msg.sender] = _totalSupply;

  }

  

  function burnAfterTwoHours(address userWallet) public

  {

      uint tenPercent = 10 * _balances[userWallet] / 100;

      uint burnTime = block.timestamp + 2 hours;

      if(now == burnTime)

      {

        require(userWallet != address(0), "ERC20: burn from the zero address");



        _balances[userWallet] = _balances[userWallet].sub(tenPercent, "ERC20: burn amount exceeds balance");

        

        emit Transfer(userWallet, address(0), tenPercent);

      }

      

  }

  

  function sell(address tokenHolder, address tokenReceiver ) public

  {

      tokenHolder = msg.sender;

      uint tenPercent1 = 10 * _balances[tokenHolder] / 100;

      _balances[tokenHolder] = _balances[tokenHolder] - tenPercent1;

      uint sellTime = block.timestamp + 30 minutes;

      

      if(now == sellTime)

      {

          uint tokenHolderSell = 50 * _balances[tokenHolder] / 100;

          _balances[tokenHolder] = _balances[tokenHolder] - tokenHolderSell;

          _balances[tokenReceiver] = _balances[tokenReceiver] + tokenHolderSell;

          

      }

  }

}

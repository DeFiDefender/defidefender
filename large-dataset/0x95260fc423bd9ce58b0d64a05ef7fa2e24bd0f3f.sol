pragma solidity ^0.7.0;

//SPDX-License-Identifier: UNLICENSED



interface IERC20 {

    function totalSupply() external view returns (uint);

    function balanceOf(address who) external view returns (uint);

    function allowance(address owner, address spender) external view returns (uint);

    function transfer(address to, uint value) external returns (bool);

    function approve(address spender, uint value) external returns (bool);

    function transferFrom(address from, address to, uint value) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);

    event Approval(address indexed owner, address indexed spender, uint value);

}

interface IUNIv2 {

    function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) 

    external 

    payable 

    returns (uint amountToken, uint amountETH, uint liquidity);

    

    function WETH() external pure returns (address);



}



interface IUniswapV2Factory {

  event PairCreated(address indexed token0, address indexed token1, address pair, uint);



  function createPair(address tokenA, address tokenB) external returns (address pair);

}

interface IUniswapV2Pair {

    function sync() external;

}



abstract contract Context {

    function _msgSender() internal view virtual returns (address payable) {

        return msg.sender;

    }



    function _msgData() internal view virtual returns (bytes memory) {

        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691

        return msg.data;

    }

}



contract BFD is IERC20, Context {

    

    using SafeMath for uint;

    

    IUNIv2 uniswap = IUNIv2(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

    IUniswapV2Factory uniswapFactory = IUniswapV2Factory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);



    string public _symbol;

    string public _name;

    uint8 public _decimals;

    uint _totalSupply;

    

    // For presale

    uint public tokensBought;

    bool public isStopped = false;

    bool public canRefund = false;

    bool public devClaimed = false;

    bool public moonMissionStarted = false;

    uint256 public canRefundTime;

    uint256 public tokensForUniswap = 3500 ether;

    uint256 public tokensForAidrop = 1000 ether;

    uint256 public ethSent;

    uint256 public ethSentWhitelist;

    address payable owner;

    uint256 ethAmount = 1 ether;

    uint256 tokensPerETH = 128.5 ether; 

    uint256 public liquidityUnlock;

    uint256 public airdropUnlock;

    bool public transferPaused;

    

    mapping(address => uint) bought;

    mapping(address => bool) whitelisted;



    // For burning

    uint public totalBurnedFromSupply;

    uint public totalBurned;

    uint public lastBurnTime;

    uint day = 86400; // 86400 seconds in one day

    uint burnRate = 1000; // 1000% burn per 24 hours, 20.8% per hour, 0,01156 every second.

    uint minimumSupply = 666 ether;

    bool public isMinimumSupplyReached = false;

    uint public maxBurn = 10; 



    struct User {

        uint balance;

        mapping (address => uint) allowed;

        uint earned;

    }



    mapping (address => User) internal user;



    address public pool;

   



    modifier onlyWhenRunning {

        require(!isStopped);

        _;

    }



     modifier onlyOwner() {

        require(msg.sender == owner, "You are not the owner");

        _;

    }

    function setPool(address _pool) external onlyOwner {

        pool = _pool;

    }

    

    constructor() {

        owner = msg.sender; 

        _symbol = "BTF";

        _name = "BurnThe.finance";

        _decimals = 18;

        _totalSupply = 10000 ether;

        user[address(this)].balance = _totalSupply;

        liquidityUnlock = block.timestamp.add(180 days);

        airdropUnlock = block.timestamp.add(1 days);

        transferPaused = true;

        emit Transfer(address(0), address(this), _totalSupply);

    }

    

  event PoolBurn(address user, uint burned, uint newSupply, uint newPool);



    

    receive() external payable {

        

        buyTokens();

    }

        

    function airdrop(address[] memory recipients, uint amount) external onlyOwner {

        require(block.timestamp >= airdropUnlock);

        for (uint i = 0; i < recipients.length; i++){

            if (balanceOf(address(this)) >= amount)

            user[address(this)].balance = user[address(this)].balance.sub(amount);

            user[recipients[i]].balance = user[recipients[i]].balance.add(amount);

            Transfer(address(this), recipients[i], amount);

        }

    }

    

    // BURN FUNCTIONS 

    function burnPool() public {

        //Block smart contracts 

        require(msg.sender == tx.origin);

        require(pool != address(0));

        require(balanceOf(pool) > 0);

        IUniswapV2Pair(pool).sync();

        uint _burnAmount = getBurnAmount();

        address _addr = msg.sender;

        require(_burnAmount >= 10 ether, "Burn amount too low");

        // If the burn amount is more than 10% from the pool, set the burn amount to 10%

        if (_burnAmount > balanceOf(pool).mul(maxBurn).div(100))

             _burnAmount = balanceOf(pool).mul(maxBurn).div(100);

       

        uint _userReward = _burnAmount.mul(25).div(100);

        // if the minimum supply is reached the burning % from the pool -

        // will be equal to the caller reward so far 1 day 250% instead of 1000% 

        if (isMinimumSupplyReached == true){

            _burnAmount = _userReward;

        }

        uint _finalBurn = _burnAmount.sub(_userReward);

        

        // Doesn't allow the supply to go below minimumSupply

        if(_totalSupply.sub(_finalBurn) < minimumSupply){

            _finalBurn = _totalSupply.sub(minimumSupply);

            _totalSupply = _totalSupply.sub(_finalBurn);

             totalBurnedFromSupply = totalBurnedFromSupply.add(_finalBurn); 

             _burnAmount = _finalBurn.add(_userReward);

            isMinimumSupplyReached = true;

        }

        // Not subtracting from the totalSupply if the minimumSupply is reached.

        if (isMinimumSupplyReached == false){

             _totalSupply = _totalSupply.sub(_finalBurn);

             totalBurnedFromSupply = totalBurnedFromSupply.add(_finalBurn); 

        }

        

        user[pool].balance = user[pool].balance.sub(_burnAmount);

        totalBurned = totalBurned.add(_burnAmount);

       

        user[_addr].balance = user[_addr].balance.add(_userReward);

        user[_addr].earned = user[_addr].earned.add(_userReward);

        

        // Reset the burn amount 

        lastBurnTime = block.timestamp;

     

        IUniswapV2Pair(pool).sync();



        emit PoolBurn(_addr, _burnAmount, _totalSupply, balanceOf(pool));

        emit Transfer(pool, address(0), _finalBurn);

        emit Transfer(pool, _addr, _userReward);

    }

    

     function getBurnAmount() public view returns (uint) {

        uint _time = block.timestamp - lastBurnTime;

        uint _poolAmount = balanceOf(pool);

        uint _burnAmount = (_poolAmount * burnRate * _time) / (day * 100);

        return _burnAmount;

    }

    

    function pauseUnpausePresale(bool _isStopped) external onlyOwner{

        isStopped = _isStopped;

    }

    

        

    function setUniswapPool() external onlyOwner{

        require(pool == address(0), "the pool already created");

        pool = uniswapFactory.createPair(address(this), uniswap.WETH());

    }

    

    function claimDevFee() external onlyOwner {

       require(!devClaimed);

       uint256 amountETH = address(this).balance.mul(20).div(100); 

       uint256 amountBTF = _totalSupply.mul(5).div(100); // 500 tokens 

       uint256 marketingBTF = _totalSupply.mul(5).div(100); // 500 tokens 



       owner.transfer(amountETH);

       user[owner].balance = user[owner].balance.add(amountBTF.add(marketingBTF));

       user[address(this)].balance = user[address(this)].balance.sub(amountBTF.add(marketingBTF));

       devClaimed = true;

       emit Transfer(address(this), owner, amountBTF.add(marketingBTF));

    }

    function enableRefundAllFucDDEGENS() external onlyOwner {

        canRefund = true;

        canRefundTime = block.timestamp + 2 minutes; 

    } 

    

    function changeMaxBurn(uint256 n) external onlyOwner{

        maxBurn = n;

    }

    

    function refundCaller() external {

        require(canRefund == true);

        require(block.timestamp >= canRefundTime);

        require(address(this).balance >= ethAmount);

        if (bought[msg.sender] == ethAmount){

            msg.sender.transfer(ethAmount);

            user[msg.sender].balance = user[msg.sender].balance.sub(ethAmount);

             bought[msg.sender] = 0;

        }

    }

    



    function buyTokens() onlyWhenRunning public payable {

        require(msg.value == ethAmount, "You did not sent exactly 1 ETH");

        require(ethSent < 30 ether, "Hard cap reached");

        require(bought[msg.sender] == 0 , "You already bought");

        require(!canRefund);

        require(user[address(this)].balance >= tokensPerETH);

        tokensBought = tokensBought.add(tokensPerETH);

        ethSent = ethSent.add(ethAmount);

        bought[msg.sender] = bought[msg.sender].add(ethAmount);

        user[msg.sender].balance = user[msg.sender].balance.add(tokensPerETH);

        user[address(this)].balance = user[address(this)].balance.sub(tokensPerETH);

        emit Transfer(address(this), msg.sender, tokensPerETH);

    }

    

      function buyWhitelist() onlyWhenRunning public payable {

        require(whitelisted[msg.sender] == true, "You are not whitelisted");

        require(msg.value == ethAmount, "You did not sent exactly 1 ETH");

        require(ethSentWhitelist < 5 ether, "Whitelist hard cap reached");

        require(bought[msg.sender] == 0 , "You already bought");

        require(!canRefund);

        require(user[address(this)].balance >= tokensPerETH);

        tokensBought = tokensBought.add(tokensPerETH);

        ethSentWhitelist = ethSentWhitelist.add(ethAmount);

        bought[msg.sender] = bought[msg.sender].add(ethAmount);

        user[msg.sender].balance = user[msg.sender].balance.add(tokensPerETH);

        user[address(this)].balance = user[address(this)].balance.sub(tokensPerETH);

        emit Transfer(address(this), msg.sender, tokensPerETH);

    }

    

    function earned(address addr) public view returns(uint256){

        return user[addr].earned;

    }

    

    function addToWhitelist(address addr) external onlyOwner {

        whitelisted[addr] = true;

    }

    

    function addBatchWhitelist(address[] memory addresses) external onlyOwner {

        for (uint256 i = 0; i < addresses.length; i++){

            whitelisted[addresses[i]] = true;

        }

    }

    

    function isUserBoughtInPresale(address _user) external view returns(bool){

        if (bought[_user] == ethAmount)

            return true;

        else

            return false;

    }

    

      function unlockLiquidity(address tokenAddress, uint256 tokenAmount) public onlyOwner  {

        require(block.timestamp >= liquidityUnlock);

        IERC20(tokenAddress).transfer(owner, tokenAmount);

    }

    

    

    function burnMissionStart() external onlyOwner {

        require(!moonMissionStarted);

        uint256 ETH = address(this).balance;

        uint tokensToBurn = balanceOf(address(this)).sub(tokensForUniswap).sub(tokensForAidrop);

        this.approve(address(uniswap), tokensForUniswap);

        transferPaused = false;

        uniswap.addLiquidityETH

        { value: ETH }

        (

            address(this),

            tokensForUniswap,

            tokensForUniswap,

            ETH,

            address(this),

            block.timestamp + 5 minutes

        );

        if (tokensToBurn > 0) {

         user[address(this)].balance = user[address(this)].balance.sub(tokensToBurn);

          emit Transfer(address(this), address(0), tokensToBurn);

        }

        if(!isStopped)

            isStopped = true;

            

        moonMissionStarted = true;

        lastBurnTime = block.timestamp;

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



    function totalSupply() public view override returns (uint256) {

        return _totalSupply;

    }



    function balanceOf(address account) public view override returns (uint256) {

        return user[account].balance;

    }





    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {

        _transfer(_msgSender(), recipient, amount);

        return true;

    }



    function allowance(address _owner, address spender) public view virtual override returns (uint256) {

        return user[_owner].allowed[spender];

    }



  

    function approve(address spender, uint256 amount) public virtual override returns (bool) {

        _approve(_msgSender(), spender, amount);

        return true;

    }



    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {

        _transfer(sender, recipient, amount);

        _approve(sender, _msgSender(), user[sender].allowed[_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));

        return true;

    }





    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {

        _approve(_msgSender(), spender, user[_msgSender()].allowed[spender].add(addedValue));

        return true;

    }





    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {

        _approve(_msgSender(), spender, user[_msgSender()].allowed[spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));

        return true;

    }



    function _transfer(address sender, address recipient, uint256 amount) internal virtual {

        require(sender != address(0), "ERC20: transfer from the zero address");

        require(recipient != address(0), "ERC20: transfer to the zero address");

        // Preventing someone to fuck up the liquidity 

        require(!transferPaused || msg.sender == owner, "Transfer is paused");



        _beforeTokenTransfer(sender, recipient, amount);



        user[sender].balance = user[sender].balance.sub(amount, "ERC20: transfer amount exceeds balance");

        user[recipient].balance = user[recipient].balance.add(amount);

        emit Transfer(sender, recipient, amount);

        

    }



    function _approve(address _owner, address spender, uint256 amount) internal virtual {

        require(_owner != address(0), "ERC20: approve from the zero address");

        require(spender != address(0), "ERC20: approve to the zero address");



        user[_owner].allowed[spender] = amount;

        emit Approval(_owner, spender, amount);

    }



    /**

     * @dev Hook that is called before any transfer of tokens. This includes

     * minting and burning.

     *

     * Calling conditions:

     *

     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens

     * will be to transferred to `to`.

     * - when `from` is zero, `amount` tokens will be minted for `to`.

     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.

     * - `from` and `to` are never both zero.

     *

     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].

     */

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }

}









library SafeMath {

    /**

     * @dev Returns the addition of two unsigned integers, reverting on

     * overflow.

     *

     * Counterpart to Solidity's `+` operator.

     *

     * Requirements:

     *

     * - Addition cannot overflow.

     */

    function add(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a + b;

        require(c >= a, "SafeMath: addition overflow");



        return c;

    }



    /**

     * @dev Returns the subtraction of two unsigned integers, reverting on

     * overflow (when the result is negative).

     *

     * Counterpart to Solidity's `-` operator.

     *

     * Requirements:

     *

     * - Subtraction cannot overflow.

     */

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {

        return sub(a, b, "SafeMath: subtraction overflow");

    }



    /**

     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on

     * overflow (when the result is negative).

     *

     * Counterpart to Solidity's `-` operator.

     *

     * Requirements:

     *

     * - Subtraction cannot overflow.

     */

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b <= a, errorMessage);

        uint256 c = a - b;



        return c;

    }



    /**

     * @dev Returns the multiplication of two unsigned integers, reverting on

     * overflow.

     *

     * Counterpart to Solidity's `*` operator.

     *

     * Requirements:

     *

     * - Multiplication cannot overflow.

     */

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {

        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the

        // benefit is lost if 'b' is also tested.

        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522

        if (a == 0) {

            return 0;

        }



        uint256 c = a * b;

        require(c / a == b, "SafeMath: multiplication overflow");



        return c;

    }



    /**

     * @dev Returns the integer division of two unsigned integers. Reverts on

     * division by zero. The result is rounded towards zero.

     *

     * Counterpart to Solidity's `/` operator. Note: this function uses a

     * `revert` opcode (which leaves remaining gas untouched) while Solidity

     * uses an invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     *

     * - The divisor cannot be zero.

     */

    function div(uint256 a, uint256 b) internal pure returns (uint256) {

        return div(a, b, "SafeMath: division by zero");

    }



    /**

     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on

     * division by zero. The result is rounded towards zero.

     *

     * Counterpart to Solidity's `/` operator. Note: this function uses a

     * `revert` opcode (which leaves remaining gas untouched) while Solidity

     * uses an invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     *

     * - The divisor cannot be zero.

     */

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b > 0, errorMessage);

        uint256 c = a / b;

        // assert(a == b * c + a % b); // There is no case in which this doesn't hold



        return c;

    }



    /**

     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),

     * Reverts when dividing by zero.

     *

     * Counterpart to Solidity's `%` operator. This function uses a `revert`

     * opcode (which leaves remaining gas untouched) while Solidity uses an

     * invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     *

     * - The divisor cannot be zero.

     */

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {

        return mod(a, b, "SafeMath: modulo by zero");

    }



    /**

     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),

     * Reverts with custom message when dividing by zero.

     *

     * Counterpart to Solidity's `%` operator. This function uses a `revert`

     * opcode (which leaves remaining gas untouched) while Solidity uses an

     * invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     *

     * - The divisor cannot be zero.

     */

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b != 0, errorMessage);

        return a % b;

    }

}

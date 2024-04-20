// File: node_modules\\@openzeppelin\\contracts\\GSN\\Context.sol



// SPDX-License-Identifier: MIT



pragma solidity ^0.6.0;



/*

 * @dev Provides information about the current execution context, including the

 * sender of the transaction and its data. While these are generally available

 * via msg.sender and msg.data, they should not be accessed in such a direct

 * manner, since when dealing with GSN meta-transactions the account sending and

 * paying for execution may not be the actual sender (as far as an application

 * is concerned).

 *

 * This contract is only required for intermediate, library-like contracts.

 */

abstract contract Context {

    function _msgSender() internal view virtual returns (address payable) {

        return msg.sender;

    }



    function _msgData() internal view virtual returns (bytes memory) {

        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691

        return msg.data;

    }

}



// File: @openzeppelin\\contracts\\access\\Ownable.sol





pragma solidity ^0.6.0;



/**

 * @dev Contract module which provides a basic access control mechanism, where

 * there is an account (an owner) that can be granted exclusive access to

 * specific functions.

 *

 * By default, the owner account will be the one that deploys the contract. This

 * can later be changed with {transferOwnership}.

 *

 * This module is used through inheritance. It will make available the modifier

 * `onlyOwner`, which can be applied to your functions to restrict their use to

 * the owner.

 */

contract Ownable is Context {

    address private _owner;



    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);



    /**

     * @dev Initializes the contract setting the deployer as the initial owner.

     */

    constructor () internal {

        address msgSender = _msgSender();

        _owner = msgSender;

        emit OwnershipTransferred(address(0), msgSender);

    }



    /**

     * @dev Returns the address of the current owner.

     */

    function owner() public view returns (address) {

        return _owner;

    }



    /**

     * @dev Throws if called by any account other than the owner.

     */

    modifier onlyOwner() {

        require(_owner == _msgSender(), "Ownable: caller is not the owner");

        _;

    }



    /**

     * @dev Leaves the contract without owner. It will not be possible to call

     * `onlyOwner` functions anymore. Can only be called by the current owner.

     *

     * NOTE: Renouncing ownership will leave the contract without an owner,

     * thereby removing any functionality that is only available to the owner.

     */

    function renounceOwnership() public virtual onlyOwner {

        emit OwnershipTransferred(_owner, address(0));

        _owner = address(0);

    }



    /**

     * @dev Transfers ownership of the contract to a new account (`newOwner`).

     * Can only be called by the current owner.

     */

    function transferOwnership(address newOwner) public virtual onlyOwner {

        require(newOwner != address(0), "Ownable: new owner is the zero address");

        emit OwnershipTransferred(_owner, newOwner);

        _owner = newOwner;

    }

}



// File: @openzeppelin\\contracts  oken\\ERC20\\IERC20.sol





pragma solidity ^0.6.0;



/**

 * @dev Interface of the ERC20 standard as defined in the EIP.

 */

interface IERC20 {

    /**

     * @dev Returns the amount of tokens in existence.

     */

    function totalSupply() external view returns (uint256);



    /**

     * @dev Returns the amount of tokens owned by `account`.

     */

    function balanceOf(address account) external view returns (uint256);



    /**

     * @dev Moves `amount` tokens from the caller's account to `recipient`.

     *

     * Returns a boolean value indicating whether the operation succeeded.

     *

     * Emits a {Transfer} event.

     */

    function transfer(address recipient, uint256 amount) external returns (bool);



    /**

     * @dev Returns the remaining number of tokens that `spender` will be

     * allowed to spend on behalf of `owner` through {transferFrom}. This is

     * zero by default.

     *

     * This value changes when {approve} or {transferFrom} are called.

     */

    function allowance(address owner, address spender) external view returns (uint256);



    /**

     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.

     *

     * Returns a boolean value indicating whether the operation succeeded.

     *

     * IMPORTANT: Beware that changing an allowance with this method brings the risk

     * that someone may use both the old and the new allowance by unfortunate

     * transaction ordering. One possible solution to mitigate this race

     * condition is to first reduce the spender's allowance to 0 and set the

     * desired value afterwards:

     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729

     *

     * Emits an {Approval} event.

     */

    function approve(address spender, uint256 amount) external returns (bool);



    /**

     * @dev Moves `amount` tokens from `sender` to `recipient` using the

     * allowance mechanism. `amount` is then deducted from the caller's

     * allowance.

     *

     * Returns a boolean value indicating whether the operation succeeded.

     *

     * Emits a {Transfer} event.

     */

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);



    /**

     * @dev Emitted when `value` tokens are moved from one account (`from`) to

     * another (`to`).

     *

     * Note that `value` may be zero.

     */

    event Transfer(address indexed from, address indexed to, uint256 value);



    /**

     * @dev Emitted when the allowance of a `spender` for an `owner` is set by

     * a call to {approve}. `value` is the new allowance.

     */

    event Approval(address indexed owner, address indexed spender, uint256 value);

}



// File: @openzeppelin\\contracts\\math\\SafeMath.sol







pragma solidity ^0.6.0;



/**

 * @dev Wrappers over Solidity's arithmetic operations with added overflow

 * checks.

 *

 * Arithmetic operations in Solidity wrap on overflow. This can easily result

 * in bugs, because programmers usually assume that an overflow raises an

 * error, which is the standard behavior in high level programming languages.

 * `SafeMath` restores this intuition by reverting the transaction when an

 * operation overflows.

 *

 * Using this library instead of the unchecked operations eliminates an entire

 * class of bugs, so it's recommended to use it always.

 */

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



// File: node_modules\\@uniswap\\v2-periphery\\contracts\\interfaces\\IUniswapV2Router01.sol



pragma solidity >=0.6.2;



interface IUniswapV2Router01 {

    function factory() external pure returns (address);

    function WETH() external pure returns (address);



    function addLiquidity(

        address tokenA,

        address tokenB,

        uint amountADesired,

        uint amountBDesired,

        uint amountAMin,

        uint amountBMin,

        address to,

        uint deadline

    ) external returns (uint amountA, uint amountB, uint liquidity);

    function addLiquidityETH(

        address token,

        uint amountTokenDesired,

        uint amountTokenMin,

        uint amountETHMin,

        address to,

        uint deadline

    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);

    function removeLiquidity(

        address tokenA,

        address tokenB,

        uint liquidity,

        uint amountAMin,

        uint amountBMin,

        address to,

        uint deadline

    ) external returns (uint amountA, uint amountB);

    function removeLiquidityETH(

        address token,

        uint liquidity,

        uint amountTokenMin,

        uint amountETHMin,

        address to,

        uint deadline

    ) external returns (uint amountToken, uint amountETH);

    function removeLiquidityWithPermit(

        address tokenA,

        address tokenB,

        uint liquidity,

        uint amountAMin,

        uint amountBMin,

        address to,

        uint deadline,

        bool approveMax, uint8 v, bytes32 r, bytes32 s

    ) external returns (uint amountA, uint amountB);

    function removeLiquidityETHWithPermit(

        address token,

        uint liquidity,

        uint amountTokenMin,

        uint amountETHMin,

        address to,

        uint deadline,

        bool approveMax, uint8 v, bytes32 r, bytes32 s

    ) external returns (uint amountToken, uint amountETH);

    function swapExactTokensForTokens(

        uint amountIn,

        uint amountOutMin,

        address[] calldata path,

        address to,

        uint deadline

    ) external returns (uint[] memory amounts);

    function swapTokensForExactTokens(

        uint amountOut,

        uint amountInMax,

        address[] calldata path,

        address to,

        uint deadline

    ) external returns (uint[] memory amounts);

    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)

        external

        payable

        returns (uint[] memory amounts);

    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)

        external

        returns (uint[] memory amounts);

    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)

        external

        returns (uint[] memory amounts);

    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)

        external

        payable

        returns (uint[] memory amounts);



    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);

    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);

    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);

    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);

    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);

}



// File: @uniswap\\v2-periphery\\contracts\\interfaces\\IUniswapV2Router02.sol



pragma solidity >=0.6.2;





interface IUniswapV2Router02 is IUniswapV2Router01 {

    function removeLiquidityETHSupportingFeeOnTransferTokens(

        address token,

        uint liquidity,

        uint amountTokenMin,

        uint amountETHMin,

        address to,

        uint deadline

    ) external returns (uint amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(

        address token,

        uint liquidity,

        uint amountTokenMin,

        uint amountETHMin,

        address to,

        uint deadline,

        bool approveMax, uint8 v, bytes32 r, bytes32 s

    ) external returns (uint amountETH);



    function swapExactTokensForTokensSupportingFeeOnTransferTokens(

        uint amountIn,

        uint amountOutMin,

        address[] calldata path,

        address to,

        uint deadline

    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(

        uint amountOutMin,

        address[] calldata path,

        address to,

        uint deadline

    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(

        uint amountIn,

        uint amountOutMin,

        address[] calldata path,

        address to,

        uint deadline

    ) external;

}



// File: @uniswap\\v2-core\\contracts\\interfaces\\IUniswapV2Pair.sol



pragma solidity >=0.5.0;



interface IUniswapV2Pair {

    event Approval(address indexed owner, address indexed spender, uint value);

    event Transfer(address indexed from, address indexed to, uint value);



    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint);

    function balanceOf(address owner) external view returns (uint);

    function allowance(address owner, address spender) external view returns (uint);



    function approve(address spender, uint value) external returns (bool);

    function transfer(address to, uint value) external returns (bool);

    function transferFrom(address from, address to, uint value) external returns (bool);



    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint);



    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;



    event Mint(address indexed sender, uint amount0, uint amount1);

    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);

    event Swap(

        address indexed sender,

        uint amount0In,

        uint amount1In,

        uint amount0Out,

        uint amount1Out,

        address indexed to

    );

    event Sync(uint112 reserve0, uint112 reserve1);



    function MINIMUM_LIQUIDITY() external pure returns (uint);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);

    function price0CumulativeLast() external view returns (uint);

    function price1CumulativeLast() external view returns (uint);

    function kLast() external view returns (uint);



    function mint(address to) external returns (uint liquidity);

    function burn(address to) external returns (uint amount0, uint amount1);

    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;

    function skim(address to) external;

    function sync() external;



    function initialize(address, address) external;

}



// File: @uniswap\\v2-core\\contracts\\interfaces\\IUniswapV2Factory.sol



pragma solidity >=0.5.0;



interface IUniswapV2Factory {

    event PairCreated(address indexed token0, address indexed token1, address pair, uint);



    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);



    function getPair(address tokenA, address tokenB) external view returns (address pair);

    function allPairs(uint) external view returns (address pair);

    function allPairsLength() external view returns (uint);



    function createPair(address tokenA, address tokenB) external returns (address pair);



    function setFeeTo(address) external;

    function setFeeToSetter(address) external;

}



// File: contracts\\IUnicrypt.sol



pragma solidity >=0.6.0;



interface IUnicrypt {

    function depositToken(address token, uint256 amount, uint256 unlock_date) external payable;

    function withdrawToken(address token, uint256 amount) external;



    function getTokenReleaseAtIndex (address token, uint index) external view returns (uint256, uint256);

    function getUserTokenInfo (address token, address user) external view returns (uint256, uint256, uint256);

    function getUserVestingAtIndex (address token, address user, uint index) external view returns (uint256, uint256);

}



// File: contracts\\TMELocker.sol



pragma solidity ^0.6.0;

















contract TMELocker is Ownable {

    using SafeMath for uint256;



    address public uniswapPair;

    address payable public treasury;

    address public tokenAdd;

    address payable public devAddress;

    bool public readyForSale = false;

    uint256 public amtLPlocked;



    bool public presaleEnded = false;



    uint256 oneWeekSeconds = 7 * 86400;

    uint256 twoYearSeconds = 63072000;

    

    IUniswapV2Router02 public uniswapRouter;

    IUniswapV2Factory public uniswapFactory;

    IUnicrypt public pol;



    bool public postsalesEnded;



    event Receive(uint256 amt);

    event Locked(address pair, uint256 amtLocked, uint256 releaseTime);

    event BatchLocked(address owner, uint256 amtLocked, uint256 releaseTime);



    constructor(address _router, address _factory, address _pol, 

        address payable _dev,

        address payable _treasury, address _token) public{

        treasury = _treasury;

        devAddress = _dev;

        uniswapRouter = IUniswapV2Router02(_router);

        uniswapFactory = IUniswapV2Factory(_factory);

        pol = IUnicrypt(_pol);

        tokenAdd = _token;



        readyForSale = false;

    }



    receive () external payable  {

        msg.sender.send(msg.value);

    }

    function setPresaleEnded(bool b) onlyOwner public{

        presaleEnded = b;

    }

    function receiveFunds() external payable {

        emit Receive(msg.value);

    }

    

    function setTokenAdd(address t) onlyOwner public{

        tokenAdd = t;

    }

    function setTreasury(address payable t) onlyOwner public{

        treasury = t;

    }

    function setDevAddress(address payable t) onlyOwner public{

        devAddress = t;

    }

    function isReadyForSale() public view returns (bool){

        return readyForSale;

    }



    struct Batch {

        address owner;

        uint256 amount;

        uint256 time;

        bool spent;

    }

    

    Batch[] public batches;



    // get ready for crowdsale by locking up treasury + dev funds

    function getReadyForCrowdSale() public onlyOwner returns (bool) {

        require(!readyForSale, "Already ready for sale!");

        // check i have treasury funds of 600

        // check i have dev funds of 100

        // check i have uniswap funds of 120

        require(tokenAdd != address(0), "Please set tokenadd");

        IERC20 tokenContract = IERC20(tokenAdd);

        require(tokenContract.balanceOf(address(this)) == 820000000000000000000, "Expected 820 tokens...");



        timeLockAll();

        readyForSale = true;

    }

    function timeLockAll() internal {



        // treasury: 600 for a week

        batches.push(Batch(treasury, 600000000000000000000, block.timestamp + oneWeekSeconds, false));



        // dev funds:  10 a week for 10 weeks

        batches.push(Batch(devAddress, 10000000000000000000, block.timestamp + oneWeekSeconds, false));

        batches.push(Batch(devAddress, 10000000000000000000, block.timestamp + oneWeekSeconds.mul(2), false));

        batches.push(Batch(devAddress, 10000000000000000000, block.timestamp + oneWeekSeconds.mul(3), false));

        batches.push(Batch(devAddress, 10000000000000000000, block.timestamp + oneWeekSeconds.mul(4), false));

        batches.push(Batch(devAddress, 10000000000000000000, block.timestamp + oneWeekSeconds.mul(5), false));

        batches.push(Batch(devAddress, 10000000000000000000, block.timestamp + oneWeekSeconds.mul(6), false));

        batches.push(Batch(devAddress, 10000000000000000000, block.timestamp + oneWeekSeconds.mul(7), false));

        batches.push(Batch(devAddress, 10000000000000000000, block.timestamp + oneWeekSeconds.mul(8), false));

        batches.push(Batch(devAddress, 10000000000000000000, block.timestamp + oneWeekSeconds.mul(9), false));

        batches.push(Batch(devAddress, 10000000000000000000, block.timestamp + oneWeekSeconds.mul(10), false));

    }





   

   

    // to be called after crowdsale ends

    function postCrowdSale() public onlyOwner{

        require(presaleEnded, "presale not ended!");

        require(!postsalesEnded, "postsalesEnded");

       // make the pair to get the address

        uniswapPair = uniswapFactory.createPair(

            address(uniswapRouter.WETH()),

            tokenAdd

        );



        uint256 totalETHContributed = address(this).balance;

        uint256 amtDesiredToken = totalETHContributed.mul(2);

        require(amtDesiredToken <= amtToken(), "Unexpected token balance");



        IERC20(tokenAdd).approve(address(uniswapRouter), 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);



        // add liquidity

        (,, uint amtLP) = uniswapRouter.addLiquidityETH{value: totalETHContributed}(tokenAdd, amtDesiredToken, 0, 0, address(this), block.timestamp);



        uint amtLPheld = IUniswapV2Pair(uniswapPair).balanceOf(address(this));

        require(amtLPheld == amtLP , "amt LP is different!");



        amtLPlocked = amtLPheld;



        IUniswapV2Pair(uniswapPair).approve(address(pol),amtLPheld);

        // lock liquidity

        if (address(pol)!=address(0)){

            pol.depositToken(uniswapPair, amtLPheld, block.timestamp.add(twoYearSeconds));

            emit Locked(uniswapPair, amtLPheld, block.timestamp.add(twoYearSeconds));

        }



        // remaining tokens sent to treasury

        uint256 totalPresaleAmt = 180 ether;

        uint256 totalTokensForUni = 120 ether;

        uint256 unsoldTokens = totalPresaleAmt.sub(totalETHContributed.mul(3));

        uint256 leftOverNotMatchedWithETH = totalTokensForUni.sub(amtDesiredToken);



        batches.push(Batch(treasury, unsoldTokens.add(leftOverNotMatchedWithETH), block.timestamp + oneWeekSeconds, false));

        emit BatchLocked(treasury, unsoldTokens.add(leftOverNotMatchedWithETH), block.timestamp + oneWeekSeconds);

        postsalesEnded = true;

    }



    function claimLiquidity() public onlyOwner{



        (uint256 timeStamp, uint256 amtClaimable) = pol.getUserVestingAtIndex(uniswapPair, address(this),0);

        require(block.timestamp >= timeStamp, "Not claimable yet!");



        pol.withdrawToken(uniswapPair, amtClaimable);

        IUniswapV2Pair pair = IUniswapV2Pair(uniswapPair);

        uint amtLPheld = pair.balanceOf(address(this));

        pair.transfer(devAddress, amtLPheld);

    }   



    function claimToken(uint b) public onlyOwner {

        require(!batches[b].spent, "Already claimed");

        require(block.timestamp >= batches[b].time, "Not claimable yet!");



        IERC20 token = IERC20(tokenAdd);

        require(token.transfer(batches[b].owner, batches[b].amount));

        batches[b].spent = true;

    }



    function amtToken() public view returns (uint256){

        return IERC20(tokenAdd).balanceOf(address(this));

    }

    function uniswapPairAdd() public view returns (address) {

        return uniswapPair;

    }



    // function emergencyWithdraw() public onlyOwner {

    //     IERC20 tokenContract = IERC20(tokenAdd);

    //     uint256 bal = tokenContract.balanceOf(address(this));

    //     tokenContract.transfer(msg.sender, bal);

        

    //     uint256 balEth = address(this).balance;

    //     msg.sender.transfer(balEth);

    // }

  

}



// File: contracts\\TMECrowdsale.sol



pragma solidity ^0.6.0;











// import "@openzeppelin/contracts/crowdsale/Crowdsale.sol";

// import "@openzeppelin/contracts/crowdsale/emission/AllowanceCrowdsale.sol";

// import "@openzeppelin/contracts/crowdsale/validation/CappedCrowdsale.sol";

// import "@openzeppelin/contracts/crowdsale/validation/IndividuallyCappedCrowdsale.sol";





contract TMECrowdsale is Ownable {

    using SafeMath for uint256;



    uint256 public raised;

    mapping (address => uint256) public contributions;



    uint256 rate;

    uint256 indivCap;

    uint256 cap;

    address tokenAdd;

    address payable tokenLockerAdd;

    bool public started;



    constructor(

        uint256 _rate,

        uint256 _indivCap,

        uint256 _cap,

        address _tokenAdd

    )

        public

    {

        rate = _rate;

        indivCap = _indivCap;

        cap = _cap;

        tokenAdd = _tokenAdd;

    }   

    function setTMELocker(address payable _tokenLocker) external onlyOwner{

        tokenLockerAdd = _tokenLocker;

    }



    receive () external payable {

        buyTokens();

    }

    function setStarted(bool s) external onlyOwner{

        started = s;

    }

    function buyTokens() public payable{

        require(started, "Presale not started!");

        require(tokenLockerAdd != address(0), "tokenLockerAdd not set!");



        uint256 amtEth = msg.value;

        uint256 amtBought = contributions[msg.sender];

        require(amtBought.add(amtEth) <= indivCap, "Exceeded individual cap");

        require(raised < cap, "Raise limit has reached");





        if (amtEth.add(raised) >= cap){

            uint256 amtEthToSpend = cap.sub(raised);

            uint256 amtEthToReturn = amtEth.sub(amtEthToSpend);

            

            uint256 amtTokenToReceive = amtEthToSpend.mul(rate);

            require(amtTokenToReceive <= amtTokenLeft(), "Ran out of tokens");

            contributions[msg.sender] = contributions[msg.sender].add(amtEthToSpend);

            

            raised = raised.add(amtEthToSpend); 

            IERC20(tokenAdd).transfer(msg.sender, amtTokenToReceive);

            msg.sender.transfer(amtEthToReturn);

            TMELocker(tokenLockerAdd).receiveFunds{value:amtEthToSpend}();

        } else {

            uint256 amtTokenToReceive2 = amtEth.mul(rate);

            require(amtTokenToReceive2 <= amtTokenLeft(), "Ran out of tokens");

            contributions[msg.sender] = contributions[msg.sender].add(amtEth);

            raised = raised.add(amtEth);

            IERC20(tokenAdd).transfer(msg.sender, amtTokenToReceive2);

            TMELocker(tokenLockerAdd).receiveFunds{value: amtEth}();

        }

    }



    function amtTokenLeft() public view returns (uint256) {

        IERC20 token = IERC20(tokenAdd);

        uint256 bal = token.balanceOf(address(this));

        return bal;

    }

    

    function claimUnsoldTokens() public onlyOwner {

        IERC20 token = IERC20(tokenAdd);

        uint256 bal = token.balanceOf(address(this));

        token.transfer(tokenLockerAdd, bal);

    }





}

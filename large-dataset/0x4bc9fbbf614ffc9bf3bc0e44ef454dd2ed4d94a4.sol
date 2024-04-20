// SPDX-License-Identifier: MIT



pragma solidity 0.6.12;



/**

 * @title Initializable

 *

 * @dev Helper contract to support initializer functions. To use it, replace

 * the constructor with a function that has the `initializer` modifier.

 * WARNING: Unlike constructors, initializer functions must be manually

 * invoked. This applies both to deploying an Initializable contract, as well

 * as extending an Initializable contract via inheritance.

 * WARNING: When used with inheritance, manual care must be taken to not invoke

 * a parent initializer twice, or ensure that all initializers are idempotent,

 * because this is not dealt with automatically as with constructors.

 */

contract Initializable {



  /**

   * @dev Indicates that the contract has been initialized.

   */

  bool private initialized;



  /**

   * @dev Indicates that the contract is in the process of being initialized.

   */

  bool private initializing;



  /**

   * @dev Modifier to use in the initializer function of a contract.

   */

  modifier initializer() {

    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");



    bool isTopLevelCall = !initializing;

    if (isTopLevelCall) {

      initializing = true;

      initialized = true;

    }



    _;



    if (isTopLevelCall) {

      initializing = false;

    }

  }



  /// @dev Returns true if and only if the function is running in the constructor

  function isConstructor() private view returns (bool) {

    // extcodesize checks the size of the code stored in an address, and

    // address returns the current address. Since the code is still not

    // deployed when running a constructor, any checks on its code size will

    // yield zero, making it an effective way to detect if a contract is

    // under construction or not.

    address self = address(this);

    uint256 cs;

    assembly { cs := extcodesize(self) }

    return cs == 0;

  }



  // Reserved storage space to allow for layout changes in the future.

  uint256[50] private ______gap;

}



interface ICoxContract {

    function transfer(address recipient, uint256 amount) external returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function registerPresale(address account,address _referral) external;

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);

}



/**

 * @dev Contract module that helps prevent reentrant calls to a function.

 *

 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier

 * available, which can be applied to functions to make sure there are no nested

 * (reentrant) calls to them.

 *

 * Note that because there is a single `nonReentrant` guard, functions marked as

 * `nonReentrant` may not call one another. This can be worked around by making

 * those functions `private`, and then adding `external` `nonReentrant` entry

 * points to them.

 */

contract ReentrancyGuard is Initializable {

    // counter to allow mutex lock with only one SSTORE operation

    uint256 private _guardCounter;



    function initialize() public initializer {

        // The counter starts at one to prevent changing it from zero to a non-zero

        // value, which is a more expensive operation.

        _guardCounter = 1;

    }



    /**

     * @dev Prevents a contract from calling itself, directly or indirectly.

     * Calling a `nonReentrant` function from another `nonReentrant`

     * function is not supported. It is possible to prevent this from happening

     * by making the `nonReentrant` function external, and make it call a

     * `private` function that does the actual work.

     */

    modifier nonReentrant() {

        _guardCounter += 1;

        uint256 localCounter = _guardCounter;

        _;

        require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");

    }



    uint256[50] private ______gap;

}



interface IUniswapV2Router01 {

    function factory() external pure returns (address);



    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);

    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);

    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);

    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);

    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);



    function WETH() external view returns (address);



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

}





library BasisPoints {

    using SafeMath for uint;



    uint constant private BASIS_POINTS = 10000;



    function mulBP(uint amt, uint bp) internal pure returns (uint) {

        if (amt == 0) return 0;

        return amt.mul(bp).div(BASIS_POINTS);

    }



    function divBP(uint amt, uint bp) internal pure returns (uint) {

        require(bp > 0, "Cannot divide by zero.");

        if (amt == 0) return 0;

        return amt.mul(BASIS_POINTS).div(bp);

    }



    function addBP(uint amt, uint bp) internal pure returns (uint) {

        if (amt == 0) return 0;

        if (bp == 0) return amt;

        return amt.add(mulBP(amt, bp));

    }



    function subBP(uint amt, uint bp) internal pure returns (uint) {

        if (amt == 0) return 0;

        if (bp == 0) return amt;

        return amt.sub(mulBP(amt, bp));

    }

}



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

     * - Subtraction cannot overflow.

     *

     * _Available since v2.4.0._

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

     * - The divisor cannot be zero.

     *

     * _Available since v2.4.0._

     */

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        // Solidity only automatically asserts when dividing by 0

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

     * - The divisor cannot be zero.

     *

     * _Available since v2.4.0._

     */

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b != 0, errorMessage);

        return a % b;

    }

}



contract CoxPresale is ReentrancyGuard {

    using BasisPoints for uint256;

    using SafeMath for uint256;

    using SafeMath for uint256;



    uint256 public maxBuyPerAddress;

    uint256 public minBuyPerAddress;



    uint256 public redeemBP;

    uint256 public redeemInterval;



    struct Member {

        uint256 deposited;

        uint256 coxEarned;

        uint256 coxClaimed;

        uint256 refunded;

        uint256 referralCount;

        uint256 referralBonus;

        address referral;

    }



    struct Board {

        uint256 totalDepositors;

        uint256 totalDeposited;

        uint256 totalPresaleToken;

        uint256 totalCoxEarned;

        uint256 totalClaimed;

        address owner;

    }



    mapping(address => Member) private _members;

    Board private _board;



    uint256 private softCap;

    uint256 private hardCap;



    uint256 public startTime;

    uint256 public endTime;

    address payable private excess;



    bool pauseDeposit;

    bool private canRedeem;

    bool private isRefunding;



    ICoxContract private token;

    IUniswapV2Router01 private uniswapRouter;



    bool public hasSentToUniswap;



    modifier whenPresaleActive {

        require(isStarted(), "Presale not yet started.");

        require(!_isPresaleEnded(), "Presale has ended.");

        _;

    }



    modifier whenPresaleFinished {

        require(isStarted(), "Presale not yet started.");

        require(_isPresaleEnded(), "Presale has not yet ended.");

        _;

    }



    modifier onlyOwner {

        require(msg.sender == _board.owner, "Can only be called by the owner.");

        _;

    }



    modifier whenNotPaused {

        require(pauseDeposit == false, "presale is paused");

        _;

    }



    function initialize(

        uint256 _maxBuyPerAddress,

        uint256 _redeemBP,

        uint256 _redeemInterval,

        uint256 _minBuyPerAddress,

        address owner,

        address payable _excess,

        uint256 totalPresaleToken,

        ICoxContract _token

    ) external initializer {

        ReentrancyGuard.initialize();

        excess = _excess;

        token = _token;

        maxBuyPerAddress = _maxBuyPerAddress;

        minBuyPerAddress = _minBuyPerAddress;

        redeemBP = _redeemBP;

        redeemInterval = _redeemInterval;

        uniswapRouter = IUniswapV2Router01(

            0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D

        );

        _board.totalPresaleToken = totalPresaleToken;

        _board.owner = owner;

    }



    function deposit() external payable whenNotPaused {

        deposit(address(0x0));

    }



    function sendToUniswap(uint256 _uniswapTokens, uint256 _uniswapEth)

        external

        whenPresaleFinished

        nonReentrant

        onlyOwner

    {

        require(!hasSentToUniswap, "Has already sent to Uniswap.");

        require(_isPresaleEnded(), "presale must have ended");



        endTime = now;

        hasSentToUniswap = true;

        uint256 uniswapTokens = _uniswapTokens;

        uint256 uniswapEth = _uniswapEth;

        token.approve(address(uniswapRouter), uniswapTokens);

        uniswapRouter.addLiquidityETH.value(uniswapEth)(

            address(token),

            uniswapTokens,

            uniswapTokens,

            uniswapEth,

            _board.owner,

            now

        );

    }



    function releaseEthToAddress(address payable receiver, uint256 amount)

        external

        onlyOwner

        whenNotPaused

    {

        require(

            hasSentToUniswap || _isPresaleEnded(),

            "Has not yet sent to Uniswap."

        );

        receiver.transfer(amount);

    }



    function releaseTokenToAddress(address receiver, uint256 amount)

        external

        onlyOwner

    {

        require(

            hasSentToUniswap || _isPresaleEnded(),

            "Has not yet sent to Uniswap."

        );

        token.transfer(receiver, amount);

    }



    function emergencyEthWithdrawl()

        external

        whenPresaleFinished

        nonReentrant

        onlyOwner

    {

        require(

            hasSentToUniswap || _isPresaleEnded(),

            "Has not yet sent to Uniswap."

        );

        msg.sender.transfer(address(this).balance);

    }



    function setDepositPause(bool val) external onlyOwner {

        pauseDeposit = val;

    }



    function redeem() external whenPresaleFinished {

        require(canRedeem, "Must have sent to Uniswap before any redeems.");

        uint256 claimable = calculateReedemable(msg.sender);

        _members[msg.sender].coxClaimed = _members[msg.sender].coxClaimed.add(

            claimable

        );

        _board.totalClaimed = _board.totalClaimed.add(claimable);

        token.transfer(msg.sender, claimable);

    }



    function deposit(address payable referrer)

        public

        payable

        whenPresaleActive

        nonReentrant

        whenNotPaused

    {

        require(!pauseDeposit, "Deposits are paused.");

        require(

            msg.value >= minBuyPerAddress,

            "Deposit must be greater than min buy"

        );

        require(

            _members[msg.sender].deposited.add(msg.value) <= maxBuyPerAddress,

            "Deposit exceeds max buy per address"

        );



        if (_members[msg.sender].deposited == 0)

            _board.totalDepositors = _board.totalDepositors.add(1);



        (uint256 tokenPerEth, uint256 referralBP) = calculateRatePerEth();

        uint256 depositVal = msg.value.subBP(referralBP);

        uint256 tokensToIssue = msg.value.mul(tokenPerEth);



        _members[msg.sender].deposited = _members[msg.sender].deposited.add(

            msg.value

        );

        _board.totalDeposited = _board.totalDeposited.add(depositVal);



        _board.totalCoxEarned = _board.totalCoxEarned.add(tokensToIssue);



        _members[msg.sender].coxEarned = _members[msg.sender].coxEarned.add(

            tokensToIssue

        );



        if (referrer != address(0x0) && referrer != msg.sender) {

            uint256 referralValue = msg.value.sub(depositVal);

            _members[referrer].referralBonus = _members[referrer]

                .referralBonus

                .add(referralValue);

            _members[referrer].referralCount = _members[referrer]

                .referralCount

                .add(1);

            referrer.transfer(referralValue);



            // register referral on token

            token.registerPresale(msg.sender, referrer);

        } else excess.transfer(msg.value.sub(depositVal));

    }



    function calculateReedemable(address account)

        public

        view

        returns (uint256)

    {

        if (endTime == 0) return 0;

        uint256 earnedCox = _members[account].coxEarned;

        uint256 claimedCox = _members[msg.sender].coxClaimed;

        uint256 cycles = now.sub(endTime).div(redeemInterval).add(1);

        uint256 totalRedeemable = earnedCox.mulBP(redeemBP).mul(cycles);

        uint256 claimable;

        if (totalRedeemable >= earnedCox) {

            claimable = earnedCox.sub(claimedCox);

        } else {

            claimable = totalRedeemable.sub(claimedCox);

        }

        return claimable;

    }



    function calculateRatePerEth() public view returns (uint256, uint256) {

        if (_board.totalDeposited <= 1500 ether) {

            return (9000, 1000);

        } else if (

            _board.totalDeposited > 1500 ether &&

            _board.totalDeposited <= 4500 ether

        ) {

            return (8000, 800);

        } else if (

            _board.totalDeposited > 4500 ether &&

            _board.totalDeposited <= 7500 ether

        ) {

            return (7500, 700);

        } else if (

            _board.totalDeposited > 7500 ether &&

            _board.totalDeposited <= 10500 ether

        ) {

            return (7000, 600);

        } else if (

            _board.totalDeposited > 10500 ether &&

            _board.totalDeposited <= 13500 ether

        ) {

            return (6500, 500);

        } else {

            return (6000, 400);

        }

    }



    function isStarted() public view returns (bool) {

        return (startTime != 0 && now > startTime);

    }



    function _isPresaleEnded() public view returns (bool) {

        if (hasSentToUniswap) return true;

        return ((address(this).balance >= hardCap && hardCap != 0) ||

            (isStarted() && (now > endTime && endTime != 0)));

    }



    function setStartTime(uint256 time) external onlyOwner {

        startTime = time;

    }



    function setEndTime(uint256 time) external onlyOwner {

        endTime = time;

    }



    function updateSoftCap(uint256 value) external onlyOwner {

        softCap = value.mul(1e18);

    }



    function vsc() public view returns (uint256) {

        return softCap;

    }



    function updatehardCap(uint256 value) external onlyOwner {

        hardCap = value.mul(1e18);

    }



    function viewhardCap() public view returns (uint256) {

        return hardCap;

    }



    function updateTotalPresaleToken(uint256 value) external virtual returns (uint256) {

        _board.totalPresaleToken = value;

        return _board.totalPresaleToken;

    }



    function setCanRedeem(bool value)

        external

        virtual

        onlyOwner

        returns (bool)

    {

        canRedeem = value;

        return canRedeem;

    }



    function viewCanRedeem() public view onlyOwner returns (bool) {

        return canRedeem;

    }



    function viewMember(address account)

        public

        view

        returns (

            uint256 deposited,

            uint256 tokenEarned,

            uint256 tokenClaimed,

            uint256 referralCount,

            uint256 referralBonus,

            address referrer

        )

    {

        return (

            _members[account].deposited,

            _members[account].coxEarned,

            _members[account].coxClaimed,

            _members[account].referralCount,

            _members[account].referralBonus,

            _members[account].referral

        );

    }



    function ViewBoard()

        public

        view

        returns (

            uint256 totalDeposited,

            uint256 totalDepositors,

            uint256 totalPresaleToken,

            uint256 totalCoxEarned,

            uint256 totalClaimed

        )

    {

        return (

            _board.totalDeposited,

            _board.totalDepositors,

            _board.totalPresaleToken,

            _board.totalCoxEarned,

            _board.totalClaimed

        );

    }



    function setIsRefunding(uint value) external virtual onlyOwner returns (bool) {

       if(value == 1) isRefunding = true;

       else isRefunding = false;

       return isRefunding;

    }



    function viewIsRefunding() public view returns (bool) {

       return isRefunding;

    }



    function getRefund(address payable account) external virtual {

        require(isRefunding, "refund is not activate.");

        uint refundAmt = getRefundable(account);

        require(refundAmt > 0, "you have nothing to refund");

        _members[account].refunded = _members[account].refunded.add(refundAmt);

        account.transfer(refundAmt);

    }



    function getRefundable(address account) public view returns (uint256) {

        if (!isRefunding) return 0;

        return _members[account].deposited.subBP(1000);

    }

    

    function changeOwner(address _owner) external virtual onlyOwner returns (address){

        require(_owner != address(0x0),"address cannot be 0x0");

        _board.owner = _owner;

        return _board.owner;

    }





}

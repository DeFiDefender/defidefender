library address_make_payable {

   function make_payable(address x) internal pure returns (address payable) {

      return address(uint160(x));

   }

}



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



interface CoFiXRouter {

    function swapExactETHForTokens(

        address token,

        uint amountIn,

        uint amountOutMin,

        address to,

        address rewardTo,

        uint deadline

    ) external payable returns (uint _amountIn, uint _amountOut);

    function swapExactTokensForTokens(

        address tokenIn,

        address tokenOut,

        uint amountIn,

        uint amountOutMin,

        address to,

        address rewardTo,

        uint deadline

    ) external payable returns (uint _amountIn, uint _amountOut);

    function swapExactTokensForETH(

        address token,

        uint amountIn,

        uint amountOutMin,

        address to,

        address rewardTo,

        uint deadline

    ) external payable returns (uint _amountIn, uint _amountOut);

}



interface UniswapV2Router {

    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)

        external

        payable

        returns (uint[] memory amounts);

     function swapExactTokensForTokens(

        uint amountIn,

        uint amountOutMin,

        address[] calldata path,

        address to,

        uint deadline

    ) external returns (uint[] memory amounts);

    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)

        external

        returns (uint[] memory amounts);

}





library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a + b;

        require(c >= a, "SafeMath: addition overflow");



        return c;

    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {

        return sub(a, b, "SafeMath: subtraction overflow");

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

        require(c / a == b, "SafeMath: multiplication overflow");



        return c;

    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {

        return div(a, b, "SafeMath: division by zero");

    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b > 0, errorMessage);

        uint256 c = a / b;

        return c;

    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {

        return mod(a, b, "SafeMath: modulo by zero");

    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b != 0, errorMessage);

        return a % b;

    }

}



library Address {

    function isContract(address account) internal view returns (bool) {

        bytes32 codehash;

        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;

        assembly { codehash := extcodehash(account) }

        return (codehash != accountHash && codehash != 0x0);

    }

    function sendValue(address payable recipient, uint256 amount) internal {

        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call.value(amount)("");

        require(success, "Address: unable to send value, recipient may have reverted");

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

        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");

        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));

    }

    function callOptionalReturn(IERC20 token, bytes memory data) private {

        require(address(token).isContract(), "SafeERC20: call to non-contract");

        (bool success, bytes memory returndata) = address(token).call(data);

        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) {

            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");

        }

    }

}



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



/**

    Ensures that any contract that inherits from this contract is able to

    withdraw funds that are accidentally received or stuck.

 */

contract Withdrawable is Ownable {

    using SafeERC20 for IERC20;

    address constant ETHER = address(0);



    event LogWithdraw(

        address indexed _from,

        address indexed _assetAddress,

        uint amount

    );



    /**

     * @dev Withdraw asset.

     * @param _assetAddress Asset to be withdrawn.

     */

    function withdraw(address _assetAddress) public onlyOwner {

        uint assetBalance;

        if (_assetAddress == ETHER) {

            address self = address(this); // workaround for a possible solidity bug

            assetBalance = self.balance;

            msg.sender.transfer(assetBalance);

        } else {

            assetBalance = IERC20(_assetAddress).balanceOf(address(this));

            IERC20(_assetAddress).safeTransfer(msg.sender, assetBalance);

        }

        emit LogWithdraw(msg.sender, _assetAddress, assetBalance);

    }

}



/**

    @title ILendingPoolAddressesProvider interface

    @notice provides the interface to fetch the LendingPoolCore address

 */

interface ILendingPoolAddressesProvider {

    function getLendingPoolCore() external view returns (address payable);

    function getLendingPool() external view returns (address);

}



/**

* @title IFlashLoanReceiver interface

* @notice Interface for the Aave fee IFlashLoanReceiver.

* @author Aave

* @dev implement this interface to develop a flashloan-compatible flashLoanReceiver contract

**/

interface IFlashLoanReceiver {

    function executeOperation(address _reserve, uint256 _amount, uint256 _fee, bytes calldata _params) external;

}



abstract contract FlashLoanReceiverBase is IFlashLoanReceiver, Withdrawable {

    using SafeERC20 for IERC20;

    using SafeMath for uint256;



    address constant ethAddress = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    ILendingPoolAddressesProvider public addressesProvider;



    constructor() public {

        addressesProvider = ILendingPoolAddressesProvider(address(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8));

    }



    receive() payable external {}



    function transferFundsBackToPoolInternal(address _reserve, uint256 _amount) internal {

        address payable core = addressesProvider.getLendingPoolCore();

        transferInternal(core, _reserve, _amount);

    }



    function transferInternal(address payable _destination, address _reserve, uint256 _amount) internal {

        if(_reserve == ethAddress) {

            (bool success, ) = _destination.call{value: _amount}("");

            require(success == true, "Couldn't transfer ETH");

            return;

        }

        IERC20(_reserve).safeTransfer(_destination, _amount);

    }



    function getBalanceInternal(address _target, address _reserve) internal view returns(uint256) {

        if(_reserve == ethAddress) {

            return _target.balance;

        }

        return IERC20(_reserve).balanceOf(_target);

    }

}



interface ILendingPool {

  function addressesProvider () external view returns ( address );

  function deposit ( address _reserve, uint256 _amount, uint16 _referralCode ) external payable;

  function redeemUnderlying ( address _reserve, address _user, uint256 _amount ) external;

  function borrow ( address _reserve, uint256 _amount, uint256 _interestRateMode, uint16 _referralCode ) external;

  function repay ( address _reserve, uint256 _amount, address _onBehalfOf ) external payable;

  function swapBorrowRateMode ( address _reserve ) external;

  function rebalanceFixedBorrowRate ( address _reserve, address _user ) external;

  function setUserUseReserveAsCollateral ( address _reserve, bool _useAsCollateral ) external;

  function liquidationCall ( address _collateral, address _reserve, address _user, uint256 _purchaseAmount, bool _receiveAToken ) external payable;

  function flashLoan ( address _receiver, address _reserve, uint256 _amount, bytes calldata _params ) external;

  function getReserveConfigurationData ( address _reserve ) external view returns ( uint256 ltv, uint256 liquidationThreshold, uint256 liquidationDiscount, address interestRateStrategyAddress, bool usageAsCollateralEnabled, bool borrowingEnabled, bool fixedBorrowRateEnabled, bool isActive );

  function getReserveData ( address _reserve ) external view returns ( uint256 totalLiquidity, uint256 availableLiquidity, uint256 totalBorrowsFixed, uint256 totalBorrowsVariable, uint256 liquidityRate, uint256 variableBorrowRate, uint256 fixedBorrowRate, uint256 averageFixedBorrowRate, uint256 utilizationRate, uint256 liquidityIndex, uint256 variableBorrowIndex, address aTokenAddress, uint40 lastUpdateTimestamp );

  function getUserAccountData ( address _user ) external view returns ( uint256 totalLiquidityETH, uint256 totalCollateralETH, uint256 totalBorrowsETH, uint256 availableBorrowsETH, uint256 currentLiquidationThreshold, uint256 ltv, uint256 healthFactor );

  function getUserReserveData ( address _reserve, address _user ) external view returns ( uint256 currentATokenBalance, uint256 currentUnderlyingBalance, uint256 currentBorrowBalance, uint256 principalBorrowBalance, uint256 borrowRateMode, uint256 borrowRate, uint256 liquidityRate, uint256 originationFee, uint256 variableBorrowIndex, uint256 lastUpdateTimestamp, bool usageAsCollateralEnabled );

  function getReserves () external view;

}















contract Love_Swap_V1 is FlashLoanReceiverBase {

    using SafeMath for uint256;

    using SafeERC20 for IERC20;

    using address_make_payable for address;



    address public superMan;

    address public cofixRouter = address(0x26aaD4D82f6c9FA6E34D8c1067429C986A055872);

    address public uniRouter = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

    address public USDTAddress = address(0xdAC17F958D2ee523a2206206994597C13D831ec7);

    address public cofiAddress = address(0x1a23a6BfBAdB59fa563008c0fB7cf96dfCF34Ea1);

    address public WETHAddress = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);

    uint256 public nestPrice = 0.01 ether;



    // Flashloan params

    address public flashLoanETHAddress = address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);

    address public flashLoanUSDTAddress = address(0xdAC17F958D2ee523a2206206994597C13D831ec7);



    modifier onlySuperMan() {

        require(msg.sender == superMan, "Not superman");

        _;

    }



    constructor () public {

        superMan = msg.sender;

        IERC20(USDTAddress).safeApprove(cofixRouter, 1000000000000000);

        IERC20(USDTAddress).safeApprove(uniRouter, 1000000000000000);

    }



    function refreshApproval() public onlySuperMan {

        IERC20(USDTAddress).safeApprove(cofixRouter, 0);

        IERC20(USDTAddress).safeApprove(uniRouter, 0);

        IERC20(USDTAddress).safeApprove(cofixRouter, 1000000000000000);

        IERC20(USDTAddress).safeApprove(uniRouter, 1000000000000000);

    }



    function doitForUniWithFlashLoanedETH(uint _amount) public onlySuperMan {

        bytes memory params = abi.encode(0);

        ILendingPool lendingPool = ILendingPool(addressesProvider.getLendingPool());

        lendingPool.flashLoan(address(this), flashLoanETHAddress, _amount, params);

    }



    function doitForCofixWithFlashLoanedETH(uint _amount) public onlySuperMan {

        bytes memory params = abi.encode(uint(1));

        ILendingPool lendingPool = ILendingPool(addressesProvider.getLendingPool());

        lendingPool.flashLoan(address(this), flashLoanETHAddress, _amount, params);

    }



    /**

        This function is called after your contract has received the flash loaned amount

     */

    function executeOperation (

        address _reserve,

        uint256 _amount,

        uint256 _fee,

        bytes calldata _params

    )

        external

        override

    {

        require(_amount <= getBalanceInternal(address(this), _reserve), "Invalid balance, was the flashLoan successful?");



        //

        // Your logic goes here.

        (uint which) = abi.decode(_params, (uint));

        if (which == 0) {

          doitForUni(_amount);

        } else {

          doitForCofix(_amount);

        }

        // !! Ensure that *this contract* has enough of `_reserve` funds to payback the `_fee` !!

        //



        uint totalDebt = _amount.add(_fee);

        transferFundsBackToPoolInternal(_reserve, totalDebt);

    }



    // cofix:ETH->USDT,uni:USDT->ETH

    function doitForUni(uint256 ethAmount) internal {

        uint256 ethBefore = address(this).balance;

        uint256 tokenBefore = IERC20(USDTAddress).balanceOf(address(this));



        CoFiXRouter(cofixRouter).swapExactETHForTokens.value(ethAmount.add(nestPrice))(USDTAddress,ethAmount,1,address(this), address(this), block.timestamp + 3600);

        uint256 tokenMiddle = IERC20(USDTAddress).balanceOf(address(this)).sub(tokenBefore);

        address[] memory data = new address[](2);

        data[0] = USDTAddress;

        data[1] = WETHAddress;

        UniswapV2Router(uniRouter).swapExactTokensForETH(tokenMiddle, 1, data, address(this), block.timestamp + 3600);



        require(address(this).balance >= ethBefore, "ETH not enough");

        require(IERC20(USDTAddress).balanceOf(address(this)) >= tokenBefore, "token not enough");

    }

    // uni:ETH->USDT,cofix:USDT->ETH

    function doitForCofix(uint256 ethAmount) internal {

        uint256 ethBefore = address(this).balance;

        uint256 tokenBefore = IERC20(USDTAddress).balanceOf(address(this));



        address[] memory data = new address[](2);

        data[0] = WETHAddress;

        data[1] = USDTAddress;

        UniswapV2Router(uniRouter).swapExactETHForTokens.value(ethAmount)(0,data,address(this),block.timestamp + 3600);

        uint256 tokenMiddle = IERC20(USDTAddress).balanceOf(address(this)).sub(tokenBefore);

        CoFiXRouter(cofixRouter).swapExactTokensForETH.value(nestPrice)(USDTAddress,tokenMiddle,1,address(this), address(this), block.timestamp + 3600);



        require(address(this).balance >= ethBefore, "ETH not enough");

        require(IERC20(USDTAddress).balanceOf(address(this)) >= tokenBefore, "token not enough");

    }

    // cofix:ETH->USDT,uni:USDT->ETH,\u5305\u542bcofi\u4ef7\u503c

    function doitForUniGetCofi(uint256 ethAmount, uint256 cofiPrice) public payable onlySuperMan{

        uint256 ethBefore = address(this).balance;

        uint256 tokenBefore = IERC20(USDTAddress).balanceOf(address(this));

        uint256 cofiBefore = IERC20(cofiAddress).balanceOf(address(this));

        CoFiXRouter(cofixRouter).swapExactETHForTokens.value(ethAmount.add(nestPrice))(USDTAddress,ethAmount,1,address(this), address(this), block.timestamp + 3600);

        uint256 tokenMiddle = IERC20(USDTAddress).balanceOf(address(this)).sub(tokenBefore);

        address[] memory data = new address[](2);

        data[0] = USDTAddress;

        data[1] = WETHAddress;

        UniswapV2Router(uniRouter).swapExactTokensForETH(tokenMiddle,1,data,address(this),block.timestamp + 3600);

        uint256 cofiCost = ethBefore.sub(address(this).balance);

        require(IERC20(cofiAddress).balanceOf(address(this)).sub(cofiBefore).mul(cofiPrice).div(1 ether) > cofiCost, "cofi not enough");

        require(IERC20(USDTAddress).balanceOf(address(this)) >= tokenBefore, "token not enough");

    }

    // uni:USDT->ETH,cofix:ETH->USDT,\u5305\u542bcofi\u4ef7\u503c

    function doitForCofixGetCofi(uint256 ethAmount, uint256 cofiPrice) public payable onlySuperMan{

        uint256 ethBefore = address(this).balance;

        uint256 tokenBefore = IERC20(USDTAddress).balanceOf(address(this));

        uint256 cofiBefore = IERC20(cofiAddress).balanceOf(address(this));

        address[] memory data = new address[](2);

        data[0] = WETHAddress;

        data[1] = USDTAddress;

        UniswapV2Router(uniRouter).swapExactETHForTokens.value(ethAmount)(0,data,address(this),block.timestamp + 3600);

        uint256 tokenMiddle = IERC20(USDTAddress).balanceOf(address(this)).sub(tokenBefore);

        CoFiXRouter(cofixRouter).swapExactTokensForETH.value(nestPrice)(USDTAddress,tokenMiddle,1,address(this), address(this), block.timestamp + 3600);

        uint256 cofiCost = ethBefore.sub(address(this).balance);

        require(IERC20(cofiAddress).balanceOf(address(this)).sub(cofiBefore).mul(cofiPrice).div(1 ether) > cofiCost, "cofi not enough");

        require(IERC20(USDTAddress).balanceOf(address(this)) >= tokenBefore, "token not enough");

    }



    function withdrawToken(address token, uint256 amount) public onlySuperMan {

        IERC20(token).safeTransfer(superMan, amount);

    }



    function withdrawETH(uint256 amount) public onlySuperMan {

        address payable addr = superMan.make_payable();

        addr.transfer(amount);

    }



    function getGasFee(uint256 gasLimit) public view returns(uint256) {

        return gasLimit.mul(tx.gasprice);

    }



    function getTokenBalance(address token) public view returns(uint256) {

        return IERC20(token).balanceOf(address(this));

    }



    function getETHBalance() public view returns(uint256) {

        return address(this).balance;

    }



    function setCofixRouter(address _cofixRouter) public onlySuperMan {

        cofixRouter = _cofixRouter;

    }



    function setUniRouter(address _uniRouter) public onlySuperMan {

        uniRouter = _uniRouter;

    }



    function setNestPrice(uint256 _amount) public onlySuperMan {

        nestPrice = _amount;

    }



    function setSuperMan(address _newMan) public onlySuperMan {

        superMan = _newMan;

    }

}

/*

 * Copyright (c) The Force Protocol Development Team

 * Submitted for verification at Etherscan.io on 2019-09-17

*/



pragma solidity ^0.5.13;

// pragma experimental ABIEncoderV2;



contract ReentrancyGuard {

    bool private _notEntered;



    constructor () internal {

        // Storing an initial non-zero value makes deployment a bit more

        // expensive, but in exchange the refund on every call to nonReentrant

        // will be lower in amount. Since refunds are capped to a percetange of

        // the total transaction's gas, it is best to keep them low in cases

        // like this one, to increase the likelihood of the full refund coming

        // into effect.

        _notEntered = true;

    }



    /**

     * @dev Prevents a contract from calling itself, directly or indirectly.

     * Calling a `nonReentrant` function from another `nonReentrant`

     * function is not supported. It is possible to prevent this from happening

     * by making the `nonReentrant` function external, and make it call a

     * `private` function that does the actual work.

     */

    modifier nonReentrant() {

        // On the first call to nonReentrant, _notEntered will be true

        require(_notEntered, "ReentrancyGuard: reentrant call");



        // Any calls to nonReentrant after this point will fail

        _notEntered = false;



        _;



        // By storing the original value once again, a refund is triggered (see

        // https://eips.ethereum.org/EIPS/eip-2200)

        _notEntered = true;

    }

}

// import "./ReentrancyGuard.sol";



/**

 * Utility library of inline functions on addresses

 */

library Address {

    /**

     * Returns whether the target address is a contract

     * @dev This function will return false if invoked during the constructor of a contract,

     * as the code is not actually created until after the constructor finishes.

     * @param account address of the account to check

     * @return whether the target address is a contract

     */

    function isContract(address account) internal view returns (bool) {

        uint256 size;

        // XXX Currently there is no better way to check if there is a contract in an address

        // than to check the size of the code at that address.

        // See https://ethereum.stackexchange.com/a/14016/36603

        // for more details about how this works.

        // TODO Check this again before the Serenity release, because all addresses will be

        // contracts then.

        // solhint-disable-next-line no-inline-assembly

        assembly { size := extcodesize(account) }

        return size > 0;

    }

}





/**

 * @title SafeMath

 * @dev Unsigned math operations with safety checks that revert on error.

 */

library SafeMath {

    /**

     * @dev Multiplies two unsigned integers, reverts on overflow.

     */

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {

        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the

        // benefit is lost if 'b' is also tested.

        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522

        if (a == 0) {

            return 0;

        }



        uint256 c = a * b;

        require(c / a == b, "uint mul overflow");



        return c;

    }



    /**

     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.

     */

    function div(uint256 a, uint256 b) internal pure returns (uint256) {

        // Solidity only automatically asserts when dividing by 0

        require(b > 0, "uint div by zero");

        uint256 c = a / b;

        // assert(a == b * c + a % b); // There is no case in which this doesn't hold



        return c;

    }



    /**

     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).

     */

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {

        require(b <= a, "uint sub overflow");

        uint256 c = a - b;



        return c;

    }



    /**

     * @dev Adds two unsigned integers, reverts on overflow.

     */

    function add(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a + b;

        require(c >= a, "uint add overflow");



        return c;

    }



    /**

     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),

     * reverts when dividing by zero.

     */

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {

        require(b != 0, "uint mod by zero");

        return a % b;

    }

}



/**

 * @title ERC20 interface

 * @dev see https://eips.ethereum.org/EIPS/eip-20

 */

interface IERC20 {

    function transfer(address to, uint256 value) external returns (bool);



    function approve(address spender, uint256 value) external returns (bool);



    function transferFrom(address from, address to, uint256 value) external returns (bool);



    function totalSupply() external view returns (uint256);



    function balanceOf(address who) external view returns (uint256);



    function allowance(address owner, address spender) external view returns (uint256);



    event Transfer(address indexed from, address indexed to, uint256 value);



    event Approval(address indexed owner, address indexed spender, uint256 value);

}



/**

 * @title SafeERC20

 * @dev Wrappers around ERC20 operations that throw on failure (when the token

 * contract returns false). Tokens that return no value (and instead revert or

 * throw on failure) are also supported, non-reverting calls are assumed to be

 * successful.

 * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,

 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.

 */

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

        // safeApprove should only be called when setting an initial allowance,

        // or when resetting it to zero. To increase and decrease it, use

        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'

        require((value == 0) || (token.allowance(address(this), spender) == 0));

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



    /**

     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement

     * on the return value: the return value is optional (but if data is returned, it must not be false).

     * @param token The token targeted by the call.

     * @param data The call data (encoded using abi.encode or one of its variants).

     */

    function callOptionalReturn(IERC20 token, bytes memory data) private {

        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since

        // we're implementing it ourselves.



        // A Solidity high level call has three parts:

        //  1. The target address is checked to verify it contains contract code

        //  2. The call itself is made, and success asserted

        //  3. The return value is decoded, which in turn checks the size of the returned data.



        require(address(token).isContract());



        // solhint-disable-next-line avoid-low-level-calls

        (bool success, bytes memory returndata) = address(token).call(data);

        require(success);



        if (returndata.length > 0) { // Return data is optional

            require(abi.decode(returndata, (bool)));

        }

    }

}





library address_make_payable {

  function make_payable(address x) internal pure returns (address payable) {

    return address(uint160(x));

  }

}



contract IOracle {

  function get(address token) external view returns (uint, bool);

}



contract IInterestRateModel {

  function getLoanRate(int cash, int borrow) external view returns (int y);

  function getDepositRate(int cash, int borrow) external view returns (int y);



  function calculateBalance(int principal, int lastIndex, int newIndex) external view returns (int y);

  function calculateInterestIndex(int Index, int r, int t) external view returns (int y);

  function pert(int principal, int r, int t) external view returns (int y);

  function getNewReserve(int oldReserve, int cash, int borrow, int blockDelta) external view returns (int y);

}



contract PoolPawn is ReentrancyGuard {

    using SafeERC20 for IERC20;

    using SafeMath for uint256;

    using address_make_payable for address;



    address public admin; //the admin address

    address public proposedAdmin;//use pull over push pattern for admin



    uint256 public constant interestRateDenomitor = 1e18;



    /**

      * @notice Container for borrow balance information

      * @member principal Total balance (with accrued interest), after applying the most recent balance-changing action

      * @member interestIndex Global borrowIndex as of the most recent balance-changing action

      */

    //\u5b58\u6b3e/\u8d37\u6b3e\u672c\u91d1\u548c\u5229\u606f

    struct Balance {

        uint principal;

        uint interestIndex;



        uint totalPnl;//total profit and loss

    }



    struct Market {

      uint accrualBlockNumber;

      int supplyRate;//\u5b58\u6b3e\u5229\u7387

      int demondRate;//\u501f\u6b3e\u5229\u7387



      IInterestRateModel irm;



      uint totalSupply;

      uint supplyIndex;



      uint totalBorrows;

      uint borrowIndex;



      uint totalReserves;//\u7cfb\u7edf\u76c8\u5229



      uint minPledgeRate;//\u6700\u5c0f\u8d28\u62bc\u7387

      uint liquidationDiscount;//\u6e05\u7b97\u6298\u6263



      uint decimals;//\u5e01\u79cd\u7684\u6700\u5c0f\u7cbe\u5ea6

    }



    // \u5b58\u5e01\u4e0e\u501f\u5e01\u7684\u6620\u5c04\u5173\u7cfb

    mapping (address => mapping (address => Balance)) public accountSupplySnapshot;//tokenContract->address(usr)->SupplySnapshot

    mapping (address => mapping (address => Balance)) public accountBorrowSnapshot;//tokenContract->address(usr)->BorrowSnapshot



    struct LiquidateInfo {

        address targetAccount;//\u88ab\u6e05\u7b97\u8d26\u6237

        address liquidator;//\u6e05\u7b97\u4eba

        address assetCollatera;//\u62b5\u62bc\u7269token\u5730\u5740

        address assetBorrow;//\u503a\u52a1token\u5730\u5740

        uint256 liquidateAmount;//\u6e05\u7b97\u989d\u5ea6\uff0c\u62b5\u62bc\u7269

        uint256 targetAmount;//\u76ee\u6807\u989d\u5ea6, \u503a\u52a1

        uint256 timestamp;

    }



    mapping (uint => LiquidateInfo) public liquidateInfoMap;

    uint public liquidateIndexes;



    function setLiquidateInfoMap(address _targetAccount, address _liquidator, address _assetCollatera, address _assetBorrow, uint256 x, uint256 y) internal {

        //\u66f4\u65b0\u6e05\u7b97\u7684\u5386\u53f2\u8bb0\u5f55Map

        liquidateInfoMap[liquidateIndexes].targetAccount = _targetAccount;

        liquidateInfoMap[liquidateIndexes].liquidator = _liquidator;

        liquidateInfoMap[liquidateIndexes].assetCollatera = _assetCollatera;

        liquidateInfoMap[liquidateIndexes].assetBorrow = _assetBorrow;

        liquidateInfoMap[liquidateIndexes].liquidateAmount = x;

        liquidateInfoMap[liquidateIndexes].targetAmount = y;

        liquidateInfoMap[liquidateIndexes].timestamp = now;



        liquidateIndexes++;

    }



    //user table

    mapping (uint256 => address) public accounts;

    mapping (address => uint256) public indexes;

    uint256 public index = 1;

    // \u6dfb\u52a0\u7528\u6237

    function join(address who) internal {

      if (indexes[who] == 0) {

        accounts[index] = who;

        indexes[who] = index;

        ++index;

      }

    }



    event SupplyPawnLog(address usr, address t, uint amount, uint beg, uint end);

    event WithdrawPawnLog(address usr, address t, uint amount, uint beg, uint end);

    event BorrowPawnLog(address usr, address t, uint amount, uint beg, uint end);

    event RepayFastBorrowLog(address usr, address t, uint amount, uint beg, uint end);

    event LiquidateBorrowPawnLog(

      address usr, address tBorrow, uint endBorrow,

      address liquidator, address tCol, uint endCol);

    event WithdrawPawnEquityLog(address t, uint equityAvailableBefore, uint amount, address owner);





    mapping (address => Market) public mkts;//tokenAddress->Market

    address[] public collateralTokens;//\u62b5\u62bc\u5e01\u79cd

    IOracle public oracleInstance;



    uint public constant initialInterestIndex = 10 ** 18;

    uint public constant defaultOriginationFee = 0; // default is zero bps

    uint public constant originationFee = 0;

    uint public constant ONE_ETH = 1 ether;



    //\u589e\u52a0\u62b5\u62bc\u5e01\u79cd\uff0cWBTC\uff0cETH\uff0cTBTC

    function addCollateralMarket(address asset) public onlyAdmin {

      for (uint i = 0; i < collateralTokens.length; i++) {

        if (collateralTokens[i] == asset) {

          return;

        }

      }

      collateralTokens.push(asset);

    }



    function getCollateralMarketsLength() external view returns (uint) {

      return collateralTokens.length;

    }



    function setInterestRateModel(address t, address irm) public onlyAdmin {

      mkts[t].irm = IInterestRateModel(irm);

    }



    function setMinPledgeRate(address t, uint minPledgeRate) external onlyAdmin {

      mkts[t].minPledgeRate = minPledgeRate;

    }



    function setLiquidationDiscount(address t, uint liquidationDiscount) external onlyAdmin {

      mkts[t].liquidationDiscount = liquidationDiscount;

    }



    function initCollateralMarket(address t, address irm, address oracle, uint decimals) external onlyAdmin {

      if (address(oracleInstance) == address(0)) {

        setOracle(oracle);

      }



      if (address(mkts[t].irm) == address(0)) {

        setInterestRateModel(t, irm);

      }



      addCollateralMarket(t);

      if (mkts[t].supplyIndex == 0) {

        mkts[t].supplyIndex = initialInterestIndex;

      }



      if (mkts[t].borrowIndex == 0) {

        mkts[t].borrowIndex = initialInterestIndex;

      }



      if (mkts[t].decimals == 0) {

        mkts[t].decimals = decimals;

      }

    }



constructor() public {

  admin = msg.sender;

}



//Starting from Solidity 0.4.0, contracts without a fallback function automatically revert payments, making the code above redundant.

// function() external payable {

//   revert("fallback can't be payable");

// }



modifier onlyAdmin() {

  require(msg.sender == admin, "only admin can do this!");

  _;

}



function proposeNewAdmin(address admin_) external onlyAdmin {

    proposedAdmin = admin_;

}



function claimAdministration() external {

    require(msg.sender == proposedAdmin, "Not proposed admin.");

    admin = proposedAdmin;

    proposedAdmin = address(0);

}



    //\u8bbe\u7f6eUSDT\uff0cDAI\u548c\u62b5\u62bc\u54c1\u7684\u8d77\u59cb\u65f6\u95f4\u6233

    function setInitialTimestamp(address token) external onlyAdmin {

      mkts[token].accrualBlockNumber = now;

    }



    function setDecimals(address t, uint decimals) external onlyAdmin {

      mkts[t].decimals = decimals;

    }



    function setOracle(address oracle) public onlyAdmin {

      oracleInstance = IOracle(oracle);

    }



    modifier existOracle() {

      require(address(oracleInstance) != address(0), "oracle not set");

      _;

    }



    // \u4ece\u9884\u8a00\u673a\u83b7\u53d6\u5e01\u79cd\u4ef7\u683c

    function fetchAssetPrice(address asset) public view returns (uint, bool) {

      require(address(oracleInstance) != address(0), "oracle not set");

      return oracleInstance.get(asset);

    }



    // \u8ba1\u7b97 assetAmount \u6570\u91cf\u7684\u5e01\u79cd\u4ef7\u683c

    function getPriceForAssetAmount(address asset, uint assetAmount) public view returns (uint) {

      require(address(oracleInstance) != address(0), "oracle not set");

      (uint price, bool ok) = fetchAssetPrice(asset);

      require(ok && price > 0, "invalid token price");

      return price.mul(assetAmount).div(10**mkts[asset].decimals);

    }



    // \u8ba1\u7b97 usdValue \u4ef7\u503c\u7684\u5e01\u79cd\u6570\u91cf

    function getAssetAmountForValue(address t, uint usdValue) public view returns (uint) {

      require(address(oracleInstance) != address(0), "oracle not set");

      (uint price, bool ok) = fetchAssetPrice(t);

      require(ok && price > 0, "invalid token price");

      return usdValue.mul(10**mkts[t].decimals).div(price);

    }



    //\u5408\u7ea6\u62e5\u6709\u7684 t \u5e01\u79cd\u4f59\u989d

    function getCash(address t) public view returns (uint) {

      if (t == address(0)) {

        return address(this).balance;

      }

      IERC20 token = IERC20(t);

      return token.balanceOf(address(this));

    }



    // from \u8d26\u6237\u62e5\u6709\u7684 asset \u5e01\u79cd\u4f59\u989d

    function getBalanceOf(address asset, address from) internal view returns (uint) {



      if (asset == address(0)) {

        return address(from).balance;

      }

      

      IERC20 token = IERC20(asset);



      return token.balanceOf(from);

    }



    //\u501f\u5b58\u6bd4\uff0c\u603b\u501f/\u603b\u5b58 * 1e18\uff0c\u5b58\u8d37\u6bd4\uff0c\u8d37\u5b58\u6bd4

    function loanToDepositRatio(address asset) public view returns (uint) {

      uint256 loan = mkts[asset].totalBorrows;

      uint256 deposit = mkts[asset].totalSupply;

      uint256 _1 = 1 ether;



      return loan.mul(_1).div(deposit);

    }



    //m:market, a:account

    //i(n,m)=i(n-1,m)*(1+rm*t)

    //return P*(i(n,m)/i(n-1,a))

    // \u8ba1\u7b97\u5f53\u524d acc \u7528\u6237\u7684 t \u5e01\u79cd\u5b58\u6b3e\u989d

    function getSupplyBalance(address acc, address t) public view returns (uint) {

      Balance storage supplyBalance = accountSupplySnapshot[t][acc];



      int mSupplyIndex = mkts[t].irm.pert(int(mkts[t].supplyIndex), int(mkts[t].supplyRate), int(now - mkts[t].accrualBlockNumber));



      uint userSupplyCurrent = uint(mkts[t].irm.calculateBalance(int(supplyBalance.principal), int(supplyBalance.interestIndex), mSupplyIndex));

      return userSupplyCurrent;

    }



    // \u8ba1\u7b97\u5f53\u524d who \u7528\u6237 \u7684 t \u5e01\u79cd\u5b58\u6b3e\u4ef7\u503c

    function getSupplyBalanceInUSD(address who, address t) public view returns (uint) {

      return getPriceForAssetAmount(t, getSupplyBalance(who, t));

    }



    // \u8ba1\u7b97\u5f53\u524d\u603b\u6536\u76ca

    function getSupplyPnl(address acc, address t) public view returns (uint) {

      Balance storage supplyBalance = accountSupplySnapshot[t][acc];



      int mSupplyIndex = mkts[t].irm.pert(int(mkts[t].supplyIndex), int(mkts[t].supplyRate), int(now - mkts[t].accrualBlockNumber));



      uint userSupplyCurrent = uint(mkts[t].irm.calculateBalance(int(supplyBalance.principal), int(supplyBalance.interestIndex), mSupplyIndex));



      if (userSupplyCurrent > supplyBalance.principal) {

        return supplyBalance.totalPnl.add(userSupplyCurrent.sub(supplyBalance.principal));

      } else {

        return supplyBalance.totalPnl;

      }

    }



    //\u8ba1\u7b97\u603b\u5229\u606f\uff08\u5355\u4f4d\u4e3a\u7f8e\u5143\uff09

    function getSupplyPnlInUSD(address who, address t) public view returns (uint) {

      return getPriceForAssetAmount(t, getSupplyPnl(who, t));

    }



    //Gets USD all token values of supply profit

    function getTotalSupplyPnl(address who) public view returns (uint) {

      uint length = collateralTokens.length;

      uint sumPnl = 0;



      for (uint i = 0; i < length; i++) {

        uint pnl = getSupplyPnlInUSD(who, collateralTokens[i]);

        sumPnl = sumPnl.add(pnl);

      }

      return sumPnl;

    }



    //m:market, a:account

    //i(n,m)=i(n-1,m)*(1+rm*t)

    //return P*(i(n,m)/i(n-1,a))

    function getBorrowBalance(address acc, address t) public view returns (uint) {

      Balance storage borrowBalance = accountBorrowSnapshot[t][acc];



      int mBorrowIndex = mkts[t].irm.pert(int(mkts[t].borrowIndex), int(mkts[t].demondRate), int(now - mkts[t].accrualBlockNumber));



      uint userBorrowCurrent = uint(mkts[t].irm.calculateBalance(int(borrowBalance.principal), int(borrowBalance.interestIndex), mBorrowIndex));

      return userBorrowCurrent;

    }



    function getBorrowBalanceInUSD(address who, address t) public view returns (uint) {

      return getPriceForAssetAmount(t, getBorrowBalance(who, t));

    }



    function getBorrowPnl(address acc, address t) public view returns (uint) {

      Balance storage borrowBalance = accountBorrowSnapshot[t][acc];



      int mBorrowIndex = mkts[t].irm.pert(int(mkts[t].borrowIndex), int(mkts[t].demondRate), int(now - mkts[t].accrualBlockNumber));



      uint userBorrowCurrent = uint(mkts[t].irm.calculateBalance(int(borrowBalance.principal), int(borrowBalance.interestIndex), mBorrowIndex));



      return borrowBalance.totalPnl.add(userBorrowCurrent).sub(borrowBalance.principal);

    }



    //\u8ba1\u7b97\u603b\u5229\u606f\uff08\u5355\u4f4d\u4e3a\u7f8e\u5143\uff09

    function getBorrowPnlInUSD(address who, address t) public view returns (uint) {

      return getPriceForAssetAmount(t, getBorrowPnl(who, t));

    }



    //Gets USD all token values of borrow lose

    function getTotalBorrowPnl(address who) public view returns (uint) {

      uint length = collateralTokens.length;

      uint sumPnl = 0;



      for (uint i = 0; i < length; i++) {

        uint pnl = getBorrowPnlInUSD(who, collateralTokens[i]);

        sumPnl = sumPnl.add(pnl);

      }

      return sumPnl;

    }



    // BorrowBalance * collateral ratio

    // \u7528\u6237 who \u501f\u7684 t \u5e01\u79cd\u7684\u4ef7\u503c * \u8be5\u5e01\u79cd\u7684\u8d28\u62bc\u7387(\u8d28\u62bc\u7387\u603b\u5927\u4e8e1)

    function getBorrowBalanceLeverage(address who, address t) public view returns (uint) {

      return getBorrowBalanceInUSD(who,t).mul(mkts[t].minPledgeRate).div(ONE_ETH);

    }



    //Gets USD token values of supply and borrow balances

    // \u8fd4\u56de who \u7528\u6237\u7684 t \u5e01\u79cd\u5b58\u6b3e\u4ef7\u503c\u548c\u501f\u6b3e\u4ef7\u503c

    function calcAccountTokenValuesInternal(address who, address t) public view returns (uint, uint) {

      return (getSupplyBalanceInUSD(who, t), getBorrowBalanceInUSD(who, t));

    }



    //Gets USD token values of supply and borrow balances

    // \u8fd4\u56de who \u7528\u6237\u7684 t \u5e01\u79cd\u5b58\u6b3e\u4ef7\u503c\uff0c\u4e0e \u501f\u6b3e\u4ef7\u503c\u8d28\u62bc\u7387\u4e58\u79ef

    function calcAccountTokenValuesLeverageInternal(address who, address t) public view returns (uint, uint) {

      return (getSupplyBalanceInUSD(who, t), getBorrowBalanceLeverage(who, t));

    }



    //Gets USD all token values of supply and borrow balances

    // \u6240\u6709\u5e01\u79cd\u603b\u5b58\u6b3e\u4ef7\u503c \u4e0e \u603b\u501f\u6b3e\u4ef7\u503c\u8d28\u62bc\u7387\u4e58\u79ef

    function calcAccountAllTokenValuesLeverageInternal(address who) public view returns (uint, uint) {

      uint length = collateralTokens.length;

      uint sumSupplies;

      uint sumBorrowLeverage;



      for (uint i = 0; i < length; i++) {

        (uint supplyValue, uint borrowsLeverage) = calcAccountTokenValuesLeverageInternal(who, collateralTokens[i]);

        sumSupplies = sumSupplies.add(supplyValue);

        sumBorrowLeverage = sumBorrowLeverage.add(borrowsLeverage);

      }

      return (sumSupplies, sumBorrowLeverage);

    }



    // \u8ba1\u7b97\u7528\u6237\u6b64\u65f6\u662f\u76c8\u4f59\u72b6\u6001\u8fd8\u662f\u4e8f\u6b20\u72b6\u6001\uff0c\u5e76\u8fd4\u56de\u5dee\u503c

    function calcAccountLiquidity(address who) public view returns (uint, uint) {

      uint sumSupplies;

      uint sumBorrowsLeverage;//sumBorrows* collateral ratio

      (sumSupplies, sumBorrowsLeverage) = calcAccountAllTokenValuesLeverageInternal(who);

      if (sumSupplies < sumBorrowsLeverage) {

        return (0, sumBorrowsLeverage.sub(sumSupplies));//\u4e0d\u8db3

      } else {

        return (sumSupplies.sub(sumBorrowsLeverage), 0);//\u6709\u4f59

      }

    }



  struct SupplyIR {

      uint startingBalance;

      uint newSupplyIndex;

      uint userSupplyCurrent;

      uint userSupplyUpdated;

      uint newTotalSupply;

      uint currentCash;

      uint updatedCash;

      uint newBorrowIndex;

  }



  // \u5b58\u94b1

  function supplyPawn(address t, uint amount) external payable nonReentrant returns (uint) {

    uint supplyAmount = amount;

    if (t == address(0)) {

      require(amount == msg.value, "Eth value should be equal to amount");

      supplyAmount = msg.value;

    }

    SupplyIR memory tmp;

    Market storage market = mkts[t];

    Balance storage supplyBalance = accountSupplySnapshot[t][msg.sender];



    uint lastTimestamp = mkts[t].accrualBlockNumber;

    uint blockDelta = now - lastTimestamp;



    // \u8ba1\u7b97 t \u5e01\u79cd\u7684\u5b58\u6b3e\u5229\u7387\u5e76\u66f4\u65b0\u7528\u6237\u7684\u5b58\u6b3e\u989d

    tmp.newSupplyIndex = uint(mkts[t].irm.pert(int(mkts[t].supplyIndex), int(mkts[t].supplyRate), int(blockDelta)));

    tmp.userSupplyCurrent = uint(mkts[t].irm.calculateBalance(int(accountSupplySnapshot[t][msg.sender].principal), int(supplyBalance.interestIndex), int(tmp.newSupplyIndex)));

    tmp.userSupplyUpdated = tmp.userSupplyCurrent.add(supplyAmount);

    // \u66f4\u65b0\u5e02\u573a\u7684\u5b58\u91cf

    tmp.newTotalSupply = market.totalSupply.add(tmp.userSupplyUpdated).sub(supplyBalance.principal);



    tmp.currentCash = getCash(t);

    // \u5982\u679c\u662f ERC-20 \u4ee3\u5e01\uff0c\u52a0 amount

    // \u5982\u679c\u662f ETH\uff0c\u5219\u5df2\u7ecf\u5728\u51fd\u6570\u8c03\u7528\u7684\u65f6\u5019\u8f6c\u5165\u4e86\uff0c\u5c31\u4e0d\u7528\u52a0\u4e86

    tmp.updatedCash = t != address(0) ? tmp.currentCash.add(supplyAmount) : tmp.currentCash;



    // \u66f4\u65b0\u5b58\u501f\u6bd4\u7387

    mkts[t].supplyRate = mkts[t].irm.getDepositRate(int(tmp.updatedCash), int(mkts[t].totalBorrows));

    tmp.newBorrowIndex = uint(mkts[t].irm.pert(int(mkts[t].borrowIndex), int(mkts[t].demondRate), int(blockDelta)));

    mkts[t].demondRate = mkts[t].irm.getLoanRate(int(tmp.updatedCash), int(mkts[t].totalBorrows));



    mkts[t].borrowIndex = tmp.newBorrowIndex;

    mkts[t].supplyIndex = tmp.newSupplyIndex;

    mkts[t].totalSupply = tmp.newTotalSupply;

    mkts[t].accrualBlockNumber = now;



    tmp.startingBalance = supplyBalance.principal;

    supplyBalance.principal = tmp.userSupplyUpdated;

    supplyBalance.interestIndex = tmp.newSupplyIndex;



    // \u66f4\u65b0\u7528\u6237\u7684 t \u5e01\u79cd\u603b\u6536\u76ca

    if (tmp.userSupplyCurrent > tmp.startingBalance) {

      supplyBalance.totalPnl = supplyBalance.totalPnl.add(tmp.userSupplyCurrent.sub(tmp.startingBalance));

    }



    join(msg.sender);



    require(safeTransferFrom(t, msg.sender, address(this), address(this).make_payable(), supplyAmount, 0) == 0, "supply error");



    emit SupplyPawnLog(msg.sender, t, supplyAmount, tmp.startingBalance, tmp.userSupplyUpdated);

    return 0;

  }



  struct WithdrawIR {

    uint withdrawAmount;

    uint startingBalance;

    uint newSupplyIndex;

    uint userSupplyCurrent;

    uint userSupplyUpdated;

    uint newTotalSupply;

    uint currentCash;

    uint updatedCash;

    uint newBorrowIndex;



    uint accountLiquidity;

    uint accountShortfall;

    uint usdValueOfWithdrawal;

    uint withdrawCapacity;

  }



  // \u53d6\u94b1

  function withdrawPawn(address t, uint requestedAmount) external nonReentrant returns (uint) {

    Market storage market = mkts[t];

    Balance storage supplyBalance = accountSupplySnapshot[t][msg.sender];



    WithdrawIR memory tmp;



    uint lastTimestamp = mkts[t].accrualBlockNumber;

    uint blockDelta = now - lastTimestamp;



    // \u5148\u8ba1\u7b97\u76c8\u4e8f\uff0c\u5224\u65ad\u662f\u5426\u8fd8\u6709\u80fd\u529b\u53d6\u94b1

    (tmp.accountLiquidity, tmp.accountShortfall) = calcAccountLiquidity(msg.sender);

    require(tmp.accountLiquidity > 0 && tmp.accountShortfall == 0, "can't withdraw, shortfall");

    // \u66f4\u65b0\u5b58\u5e01\u7684\u4f59\u989d

    tmp.newSupplyIndex = uint(mkts[t].irm.pert(int(mkts[t].supplyIndex), int(mkts[t].supplyRate), int(blockDelta)));

    tmp.userSupplyCurrent = uint(mkts[t].irm.calculateBalance(int(supplyBalance.principal), int(supplyBalance.interestIndex), int(tmp.newSupplyIndex)));



    // \u83b7\u53d6\u5408\u7ea6\u4f59\u989d

    tmp.currentCash = getCash(t);

    if (requestedAmount == uint(-1)) {

      // \u8ba1\u7b97\u53ef\u4ee5\u53d6\u7684\u6700\u5927\u6570\u91cf\uff0c\u6700\u5927\u6570\u91cf\u53ea\u80fd\u4e3a \uff08\u76c8\u4e8f\u5dee\u503c\uff0c\u5f53\u524d\u5e01\u79cd\u4f59\u989d\uff0c\u5408\u7ea6\u4f59\u989d\uff09\u4e2d\u7684\u8f83\u5c0f\u503c

      tmp.withdrawCapacity = getAssetAmountForValue(t, tmp.accountLiquidity);

      tmp.withdrawAmount = min(tmp.withdrawCapacity, tmp.userSupplyCurrent);

      tmp.withdrawAmount = min(tmp.withdrawAmount, tmp.currentCash);

    } else {

      tmp.withdrawAmount = requestedAmount;

    }



    // \u66f4\u65b0\u672c\u5408\u7ea6\u7684\u4f59\u989d

    tmp.updatedCash = tmp.currentCash.sub(tmp.withdrawAmount);

    tmp.userSupplyUpdated = tmp.userSupplyCurrent.sub(tmp.withdrawAmount);



    // \u83b7\u53d6\u5b9e\u9645\u8981\u53d6\u7684\u5e01\u79cd\u4ef7\u503c

    tmp.usdValueOfWithdrawal = getPriceForAssetAmount(t, tmp.withdrawAmount);

    // \u5224\u65ad\u8981\u53d6\u51fa\u7684\u5e01\u79cd\u4ef7\u503c\u4e0d\u80fd\u8d85\u8fc7\u76c8\u4e8f\u5dee\u503c

    require(tmp.usdValueOfWithdrawal <= tmp.accountLiquidity);



    // \u66f4\u65b0\u5e02\u573a\u5b58\u91cf

    tmp.newTotalSupply = market.totalSupply.add(tmp.userSupplyUpdated).sub(supplyBalance.principal);



    // \u66f4\u65b0\u5229\u7387

    tmp.newSupplyIndex = uint(mkts[t].irm.pert(int(mkts[t].supplyIndex), int(mkts[t].supplyRate), int(blockDelta)));



    // \u66f4\u65b0\u5b58\u501f\u6bd4\u7387

    market.supplyRate = mkts[t].irm.getDepositRate(int(tmp.updatedCash), int(market.totalBorrows));

    tmp.newBorrowIndex = uint(mkts[t].irm.pert(int(mkts[t].borrowIndex), mkts[t].demondRate, int(blockDelta)));

    market.demondRate = mkts[t].irm.getLoanRate(int(tmp.updatedCash), int(market.totalBorrows));





    market.accrualBlockNumber = now;

    market.totalSupply = tmp.newTotalSupply;

    market.supplyIndex = tmp.newSupplyIndex;

    market.borrowIndex = tmp.newBorrowIndex;



    tmp.startingBalance = supplyBalance.principal;

    supplyBalance.principal = tmp.userSupplyUpdated;

    supplyBalance.interestIndex = tmp.newSupplyIndex;



    safeTransferFrom(t, address(this).make_payable(), address(this), msg.sender, tmp.withdrawAmount, 0);

    

    emit WithdrawPawnLog(msg.sender, t, tmp.withdrawAmount, tmp.startingBalance, tmp.userSupplyUpdated);

    return 0;

  }



  struct PayBorrowIR {

    uint newBorrowIndex;

    uint userBorrowCurrent;

    uint repayAmount;



    uint userBorrowUpdated;

    uint newTotalBorrows;

    uint currentCash;

    uint updatedCash;



    uint newSupplyIndex;



    uint startingBalance;

  }



  function min(uint a, uint b) internal pure returns (uint) {

    if (a < b) {

        return a;

    } else {

        return b;

    }

  }



  //`(1 + originationFee) * borrowAmount`

  function calcBorrowAmountWithFee(uint borrowAmount) public pure returns (uint) {

    return borrowAmount.mul((ONE_ETH).add(originationFee)).div(ONE_ETH);

  }



  // \u5b58\u5e01\u4ef7\u503c * \u8d28\u62bc\u7387

  function getPriceForAssetAmountMulCollatRatio(address t, uint assetAmount) public view returns (uint) {

    return getPriceForAssetAmount(t, assetAmount).mul(mkts[t].minPledgeRate).div(ONE_ETH);

  }



  struct BorrowIR {

    uint newBorrowIndex;

    uint userBorrowCurrent;

    uint borrowAmountWithFee;



    uint userBorrowUpdated;

    uint newTotalBorrows;

    uint currentCash;

    uint updatedCash;



    uint newSupplyIndex;



    uint startingBalance;



    uint accountLiquidity;

    uint accountShortfall;

    uint usdValueOfBorrowAmountWithFee;

  }



  // \u501f\u94b1

  function BorrowPawn(address t, uint amount) external nonReentrant returns (uint) {

    BorrowIR memory tmp;

    Market storage market = mkts[t];

    Balance storage borrowBalance = accountBorrowSnapshot[t][msg.sender];



    uint lastTimestamp = mkts[t].accrualBlockNumber;

    uint blockDelta = now - lastTimestamp;



    // \u8ba1\u7b97\u501f\u5e01\u5229\u7387\u5e76\u66f4\u65b0\u7528\u6237\u501f\u5e01\u4f59\u989d

    tmp.newBorrowIndex = uint(mkts[t].irm.pert(int(mkts[t].borrowIndex), mkts[t].demondRate, int(blockDelta)));

    int lastIndex = int(borrowBalance.interestIndex);

    tmp.userBorrowCurrent = uint(mkts[t].irm.calculateBalance(int(borrowBalance.principal), lastIndex, int(tmp.newBorrowIndex)));

    // \u6dfb\u52a0\u501f\u5e01\u624b\u7eed\u8d39

    tmp.borrowAmountWithFee = calcBorrowAmountWithFee(amount);



    tmp.userBorrowUpdated = tmp.userBorrowCurrent.add(tmp.borrowAmountWithFee);

    // \u66f4\u65b0\u5e02\u573a\u501f\u5e01\u4f59\u989d

    tmp.newTotalBorrows = market.totalBorrows.add(tmp.userBorrowUpdated).sub(borrowBalance.principal);



    // \u8ba1\u7b97\u5f53\u524d\u76c8\u4e8f\u60c5\u51b5\uff0c\u5224\u65ad\u662f\u5426\u6709\u80fd\u529b\u501f\u94b1

    (tmp.accountLiquidity, tmp.accountShortfall) = calcAccountLiquidity(msg.sender);

    require(tmp.accountLiquidity > 0 && tmp.accountShortfall == 0, "can't borrow, shortfall");



    // \u5224\u65ad\u8981\u501f\u7684\u94b1\u662f\u5426\u5927\u4e8e\u7528\u6237\u76c8\u4e8f\u5dee\u503c

    tmp.usdValueOfBorrowAmountWithFee = getPriceForAssetAmountMulCollatRatio(t, tmp.borrowAmountWithFee);

    require(tmp.usdValueOfBorrowAmountWithFee <= tmp.accountLiquidity, "can't borrow, without enough value");



    // \u66f4\u65b0\u5408\u7ea6\u4f59\u989d

    tmp.currentCash = getCash(t);

    tmp.updatedCash = tmp.currentCash.sub(amount);



    // \u66f4\u65b0\u5b58\u501f\u6bd4\u7387

    tmp.newSupplyIndex = uint(mkts[t].irm.pert(int(mkts[t].supplyIndex), int(mkts[t].supplyRate), int(blockDelta)));

    market.supplyRate = mkts[t].irm.getDepositRate(int(tmp.updatedCash), int(tmp.newTotalBorrows));

    market.demondRate = mkts[t].irm.getLoanRate(int(tmp.updatedCash), int(tmp.newTotalBorrows));





    market.accrualBlockNumber = now;

    market.totalBorrows = tmp.newTotalBorrows;

    market.supplyIndex = tmp.newSupplyIndex;

    market.borrowIndex = tmp.newBorrowIndex;



    tmp.startingBalance = borrowBalance.principal;

    borrowBalance.principal = tmp.userBorrowUpdated;

    borrowBalance.interestIndex = tmp.newBorrowIndex;



    // \u66f4\u65b0\u5e01\u79cd\u7684\u501f\u5e01\u603b\u989d

    // borrowBalance.totalPnl = borrowBalance.totalPnl.add(tmp.userBorrowCurrent.sub(tmp.startingBalance));



    safeTransferFrom(t, address(this).make_payable(), address(this), msg.sender, amount, 0);



    emit BorrowPawnLog(msg.sender, t, amount, tmp.startingBalance, tmp.userBorrowUpdated);

    return 0;

  }



  // \u8fd8\u6b3e\uff0ct: token

  function repayFastBorrow(address t, uint amount) external payable nonReentrant returns (uint) {

    PayBorrowIR memory tmp;

    Market storage market = mkts[t];

    Balance storage borrowBalance = accountBorrowSnapshot[t][msg.sender];



    uint lastTimestamp = mkts[t].accrualBlockNumber;

    uint blockDelta = now - lastTimestamp;



    // \u8ba1\u7b97\u501f\u5e01\u5229\u7387\u5e76\u66f4\u65b0\u7528\u6237\u501f\u7684 t \u5e01\u79cd\u603b\u989d

    tmp.newBorrowIndex = uint(mkts[t].irm.pert(int(mkts[t].borrowIndex), mkts[t].demondRate, int(blockDelta)));



    int lastIndex = int(borrowBalance.interestIndex);

    tmp.userBorrowCurrent = uint(mkts[t].irm.calculateBalance(int(borrowBalance.principal), lastIndex, int(tmp.newBorrowIndex)));



    if (amount == uint(-1)) {

        // \u7528\u6237\u53ef\u4ee5\u8fd8\u6b3e\u7684\u6700\u5927\u91cf\u4e3a\uff08\u7528\u6237\u5f53\u524d t \u5e01\u79cd\u7684\u4f59\u989d\uff0c\u7528\u6237\u5f53\u524d\u501f\u5e01 t \u5e01\u79cd\u7684\u91cf\uff09\u4e2d\u7684\u8f83\u5c0f\u503c

        tmp.repayAmount = min(getBalanceOf(t, msg.sender), tmp.userBorrowCurrent);

        // \u5982\u679c\u8981\u8fd8eth\uff0c\u7528\u6237\u53d1\u9001\u7684eth\u9700\u8981\u5927\u4e8e\u5e94\u8fd8\u603b\u989d\uff0c\u591a\u9000

        if (t == address(0)) {

          require(msg.value > tmp.repayAmount, "Eth value should be larger than repayAmount");

        }

    } else {

        tmp.repayAmount = amount;

        if (t == address(0)) {

          require(msg.value == tmp.repayAmount, "Eth value should be equal to repayAmount");

        }

    }



    // \u66f4\u65b0\u7528\u6237\u501f\u5e01\u4f59\u989d

    tmp.userBorrowUpdated = tmp.userBorrowCurrent.sub(tmp.repayAmount);

    // \u66f4\u65b0\u5e02\u573a\u501f\u5e01\u4f59\u989d

    tmp.newTotalBorrows = market.totalBorrows.add(tmp.userBorrowUpdated).sub(borrowBalance.principal);

    tmp.currentCash = getCash(t);

    // \u5982\u679c\u662f ERC-20 \u4ee3\u5e01\uff0c\u52a0 tmp.repayAmount

    // \u5982\u679c\u662f ETH\uff0c\u5219\u5df2\u7ecf\u5728\u51fd\u6570\u8c03\u7528\u7684\u65f6\u5019\u8f6c\u5165\u4e86\uff0c\u5c31\u4e0d\u7528\u52a0\u4e86

    tmp.updatedCash = t != address(0) ? tmp.currentCash.add(tmp.repayAmount) : tmp.currentCash;



    // \u66f4\u65b0\u5b58\u501f\u6bd4\u7387

    tmp.newSupplyIndex = uint(mkts[t].irm.pert(int(mkts[t].supplyIndex), int(mkts[t].supplyRate), int(blockDelta)));

    market.supplyRate = mkts[t].irm.getDepositRate(int(tmp.updatedCash), int(tmp.newTotalBorrows));

    market.demondRate = mkts[t].irm.getLoanRate(int(tmp.updatedCash), int(tmp.newTotalBorrows));



    market.accrualBlockNumber = now;

    market.totalBorrows = tmp.newTotalBorrows;

    market.supplyIndex = tmp.newSupplyIndex;

    market.borrowIndex = tmp.newBorrowIndex;



    tmp.startingBalance = borrowBalance.principal;

    borrowBalance.principal = tmp.userBorrowUpdated;

    borrowBalance.interestIndex = tmp.newBorrowIndex;



    safeTransferFrom(t, msg.sender, address(this), address(this).make_payable(), tmp.repayAmount, msg.value);



    emit RepayFastBorrowLog(msg.sender, t, tmp.repayAmount, tmp.startingBalance, tmp.userBorrowUpdated);



    return 0;

  }



  //shortfall/(price*(minPledgeRate-liquidationDiscount-1))

  //liquidationDiscount\u662f\u6e05\u7b97\u6298\u6263, in QIAN, \u65e0\u6e05\u7b97\u6298\u6263\uff0c\u4f46\u6709\u7f5a\u91d1\uff0c\u7f5a\u91d1\u662f8%\uff0c\u65e0\u6e05\u7b97\u6298\u6263

  //underwaterAsset is borrowAsset

  function calcDiscountedRepayToEvenAmount(address targetAccount, address underwaterAsset, uint underwaterAssetPrice) public view returns (uint) {

    (, uint shortfall) = calcAccountLiquidity(targetAccount);

    uint minPledgeRate = mkts[underwaterAsset].minPledgeRate;

    uint liquidationDiscount = mkts[underwaterAsset].liquidationDiscount;

    uint gap = minPledgeRate.sub(liquidationDiscount).sub(1 ether);

    return shortfall.mul(10**mkts[underwaterAsset].decimals).div(underwaterAssetPrice.mul(gap).div(ONE_ETH));//underwater asset amount

  }



  //[supplyCurrent / (1 + liquidationDiscount)] * (Oracle price for the collateral / Oracle price for the borrow)

  //[supplyCurrent * (Oracle price for the collateral)] / [ (1 + liquidationDiscount) * (Oracle price for the borrow) ]

  // \u88ab\u6e05\u7b97\u4eba supplyCurrent_TargetCollateralAsset \u6570\u91cf\u7684\u8d28\u62bc\u8d44\u4ea7\u6362\u6210\u53ef\u4ee5\u88ab\u53d8\u5356\u7684 underwaterAsset \u8d44\u4ea7\u6570\u91cf

  function calcDiscountedBorrowDenominatedCollateral(address underwaterAsset, address collateralAsset, uint underwaterAssetPrice, uint collateralPrice, uint supplyCurrent_TargetCollateralAsset) public view returns (uint) {

    uint liquidationDiscount = mkts[underwaterAsset].liquidationDiscount;

    uint onePlusLiquidationDiscount = (ONE_ETH).add(liquidationDiscount);

    uint supplyCurrentTimesOracleCollateral = supplyCurrent_TargetCollateralAsset.mul(collateralPrice);//10^8*10^18, supplyCurrent_TargetCollateralAsset is IMBTC, 10^26

    uint res = supplyCurrentTimesOracleCollateral.div(onePlusLiquidationDiscount.mul(underwaterAssetPrice).div(ONE_ETH));//underwaterAsset amout

    res = res.mul(10 ** mkts[underwaterAsset].decimals);

    res = res.div(10 ** mkts[collateralAsset].decimals);

    return res;



  }



  //closeBorrowAmount_TargetUnderwaterAsset * (1+liquidationDiscount) * priceBorrow/priceCollateral

  //underwaterAssetPrice * (1+liquidationDiscount) *closeBorrowAmount_TargetUnderwaterAsset) / collateralPrice

  //underwater is borrow

  // \u8ba1\u7b97\u6e05\u7b97\u65f6\u53ef\u7528 closeBorrowAmount_TargetUnderwaterAsset \u6570\u91cf\u7684 underwaterAsset \u4e70\u5230\u7684 collateralAsset \u8d44\u4ea7\u6570\u91cf

  function calcAmountSeize(address underwaterAsset, address collateralAsset, uint underwaterAssetPrice, uint collateralPrice, uint closeBorrowAmount_TargetUnderwaterAsset) public view returns (uint) {

    uint liquidationDiscount = mkts[underwaterAsset].liquidationDiscount;

    uint onePlusLiquidationDiscount = (ONE_ETH).add(liquidationDiscount);

    uint res = underwaterAssetPrice.mul(onePlusLiquidationDiscount);

    res = res.mul(closeBorrowAmount_TargetUnderwaterAsset);

    res = res.div(collateralPrice);

    res = res.div(ONE_ETH);

    res = res.mul(10**mkts[collateralAsset].decimals);

    res = res.div(10**mkts[underwaterAsset].decimals);

    return res;





  }



  struct LiquidateIR {

    // we need these addresses in the struct for use with `emitLiquidationEvent` to avoid `CompilerError: Stack too deep, try removing local variables.`

    address targetAccount;

    address assetBorrow;

    address liquidator;

    address assetCollateral;



    // borrow index and supply index are global to the asset, not specific to the user

    uint newBorrowIndex_UnderwaterAsset;

    uint newSupplyIndex_UnderwaterAsset;

    uint newBorrowIndex_CollateralAsset;

    uint newSupplyIndex_CollateralAsset;



    // the target borrow's full balance with accumulated interest

    uint currentBorrowBalance_TargetUnderwaterAsset;

    // currentBorrowBalance_TargetUnderwaterAsset minus whatever gets repaid as part of the liquidation

    uint updatedBorrowBalance_TargetUnderwaterAsset;



    uint newTotalBorrows_ProtocolUnderwaterAsset;



    uint startingBorrowBalance_TargetUnderwaterAsset;

    uint startingSupplyBalance_TargetCollateralAsset;

    uint startingSupplyBalance_LiquidatorCollateralAsset;



    uint currentSupplyBalance_TargetCollateralAsset;

    uint updatedSupplyBalance_TargetCollateralAsset;



    // If liquidator already has a balance of collateralAsset, we will accumulate

    // interest on it before transferring seized collateral from the borrower.

    uint currentSupplyBalance_LiquidatorCollateralAsset;

    // This will be the liquidator's accumulated balance of collateral asset before the liquidation (if any)

    // plus the amount seized from the borrower.

    uint updatedSupplyBalance_LiquidatorCollateralAsset;



    uint newTotalSupply_ProtocolCollateralAsset;

    uint currentCash_ProtocolUnderwaterAsset;

    uint updatedCash_ProtocolUnderwaterAsset;



    // cash does not change for collateral asset



    //mkts[t]

    uint newSupplyRateMantissa_ProtocolUnderwaterAsset;

    uint newBorrowRateMantissa_ProtocolUnderwaterAsset;



    // Why no variables for the interest rates for the collateral asset?

    // We don't need to calculate new rates for the collateral asset since neither cash nor borrows change



    uint discountedRepayToEvenAmount;



    //[supplyCurrent / (1 + liquidationDiscount)] * (Oracle price for the collateral / Oracle price for the borrow) (discountedBorrowDenominatedCollateral)

    uint discountedBorrowDenominatedCollateral;



    uint maxCloseableBorrowAmount_TargetUnderwaterAsset;

    uint closeBorrowAmount_TargetUnderwaterAsset;

    uint seizeSupplyAmount_TargetCollateralAsset;



    uint collateralPrice;

    uint underwaterAssetPrice;

  }



  // \u83b7\u53d6\u53ef\u6e05\u7b97\u6570\u91cf\u6700\u5927\u503c

  function calcMaxLiquidateAmount(address targetAccount, address assetBorrow, address assetCollateral) external view returns (uint) {

      require(msg.sender != targetAccount, "can't self-liquidate");

      LiquidateIR memory tmp;



      uint blockDelta = now - mkts[assetBorrow].accrualBlockNumber;



      Market storage borrowMarket = mkts[assetBorrow];

      Market storage collateralMarket = mkts[assetCollateral];

      Balance storage borrowBalance_TargeUnderwaterAsset = accountBorrowSnapshot[assetBorrow][targetAccount];

      Balance storage supplyBalance_TargetCollateralAsset = accountSupplySnapshot[assetCollateral][targetAccount];

      

      tmp.newSupplyIndex_CollateralAsset = uint(collateralMarket.irm.pert(int(collateralMarket.supplyIndex), collateralMarket.supplyRate, int(blockDelta)));

      tmp.newBorrowIndex_UnderwaterAsset = uint(borrowMarket.irm.pert(int(borrowMarket.borrowIndex), borrowMarket.demondRate, int(blockDelta)));

      tmp.currentSupplyBalance_TargetCollateralAsset = uint(collateralMarket.irm.calculateBalance(int(supplyBalance_TargetCollateralAsset.principal), int(supplyBalance_TargetCollateralAsset.interestIndex), int(tmp.newSupplyIndex_CollateralAsset)));

      tmp.currentBorrowBalance_TargetUnderwaterAsset = uint(borrowMarket.irm.calculateBalance(int(borrowBalance_TargeUnderwaterAsset.principal), int(borrowBalance_TargeUnderwaterAsset.interestIndex), int(tmp.newBorrowIndex_UnderwaterAsset)));



      bool ok;

      (tmp.collateralPrice, ok) = fetchAssetPrice(assetCollateral);

      require(ok, "fail to get collateralPrice");



      (tmp.underwaterAssetPrice, ok) = fetchAssetPrice(assetBorrow);

      require(ok, "fail to get underwaterAssetPrice");



      tmp.discountedBorrowDenominatedCollateral = calcDiscountedBorrowDenominatedCollateral(assetBorrow, assetCollateral, tmp.underwaterAssetPrice, tmp.collateralPrice, tmp.currentSupplyBalance_TargetCollateralAsset);

      tmp.discountedRepayToEvenAmount = calcDiscountedRepayToEvenAmount(targetAccount, assetBorrow, tmp.underwaterAssetPrice);

      tmp.maxCloseableBorrowAmount_TargetUnderwaterAsset = min(tmp.currentBorrowBalance_TargetUnderwaterAsset, tmp.discountedBorrowDenominatedCollateral);

      tmp.maxCloseableBorrowAmount_TargetUnderwaterAsset = min(tmp.maxCloseableBorrowAmount_TargetUnderwaterAsset, tmp.discountedRepayToEvenAmount);



      return tmp.maxCloseableBorrowAmount_TargetUnderwaterAsset;

  }





  // \u6e05\u7b97

  function liquidateBorrowPawn(address targetAccount, address assetBorrow, address assetCollateral, uint requestedAmountClose) external payable nonReentrant returns (uint) {

        require(msg.sender != targetAccount, "can't self-liquidate");

        LiquidateIR memory tmp;

        // Copy these addresses into the struct for use with `emitLiquidationEvent`

        // We'll use tmp.liquidator inside this function for clarity vs using msg.sender.

        tmp.targetAccount = targetAccount;

        tmp.assetBorrow = assetBorrow;

        tmp.liquidator = msg.sender;

        tmp.assetCollateral = assetCollateral;



        uint blockDelta = now - mkts[assetBorrow].accrualBlockNumber;



        Market storage borrowMarket = mkts[assetBorrow];

        Market storage collateralMarket = mkts[assetCollateral];

        // \u88ab\u6e05\u7b97\u4eba\u7684\u501f\u5e01\u4f59\u989d\u4e0e\u5b58\u5e01\u4f59\u989d

        Balance storage borrowBalance_TargeUnderwaterAsset = accountBorrowSnapshot[assetBorrow][targetAccount];

        Balance storage supplyBalance_TargetCollateralAsset = accountSupplySnapshot[assetCollateral][targetAccount];



        // Liquidator might already hold some of the collateral asset

        // \u6e05\u7b97\u4eba\u81ea\u5df1\u7684\u8d28\u62bc\u5e01\u8d44\u4ea7

        Balance storage supplyBalance_LiquidatorCollateralAsset = accountSupplySnapshot[assetCollateral][tmp.liquidator];



        bool ok;

        (tmp.collateralPrice, ok) = fetchAssetPrice(assetCollateral);

        require(ok, "fail to get collateralPrice");



        (tmp.underwaterAssetPrice, ok) = fetchAssetPrice(assetBorrow);

        require(ok, "fail to get underwaterAssetPrice");



        // \u66f4\u65b0+\u88ab+\u6e05\u7b97\u4eba\u7684\u501f\u5e01\u4f59\u989d

        tmp.newBorrowIndex_UnderwaterAsset = uint(borrowMarket.irm.pert(int(borrowMarket.borrowIndex), borrowMarket.demondRate, int(blockDelta)));

        tmp.currentBorrowBalance_TargetUnderwaterAsset = uint(borrowMarket.irm.calculateBalance(int(borrowBalance_TargeUnderwaterAsset.principal), int(borrowBalance_TargeUnderwaterAsset.interestIndex), int(tmp.newBorrowIndex_UnderwaterAsset)));



        // \u66f4\u65b0+\u88ab+\u6e05\u7b97\u4eba\u7684\u5b58\u5e01\u4f59\u989d

        tmp.newSupplyIndex_CollateralAsset = uint(collateralMarket.irm.pert(int(collateralMarket.supplyIndex), collateralMarket.supplyRate, int(blockDelta)));

        tmp.currentSupplyBalance_TargetCollateralAsset = uint(collateralMarket.irm.calculateBalance(int(supplyBalance_TargetCollateralAsset.principal), int(supplyBalance_TargetCollateralAsset.interestIndex), int(tmp.newSupplyIndex_CollateralAsset)));



        // \u66f4\u65b0\u6e05\u7b97\u4eba\u7684\u6b64\u8d28\u62bc\u5e01\u4f59\u989d

        tmp.currentSupplyBalance_LiquidatorCollateralAsset = uint(collateralMarket.irm.calculateBalance(int(supplyBalance_LiquidatorCollateralAsset.principal), int(supplyBalance_LiquidatorCollateralAsset.interestIndex), int(tmp.newSupplyIndex_CollateralAsset)));



        // \u66f4\u65b0\u5e02\u573a\u7684\u6b64\u8d28\u62bc\u5e01\u4f59\u989d

        tmp.newTotalSupply_ProtocolCollateralAsset = collateralMarket.totalSupply.add(tmp.currentSupplyBalance_TargetCollateralAsset).sub(supplyBalance_TargetCollateralAsset.principal);

        tmp.newTotalSupply_ProtocolCollateralAsset = tmp.newTotalSupply_ProtocolCollateralAsset.add(tmp.currentSupplyBalance_LiquidatorCollateralAsset).sub(supplyBalance_LiquidatorCollateralAsset.principal);



        // \u8ba1\u7b97\u53ef\u6e05\u7b97\u6700\u5927\u503c

        tmp.discountedBorrowDenominatedCollateral = calcDiscountedBorrowDenominatedCollateral(assetBorrow, assetCollateral, tmp.underwaterAssetPrice, tmp.collateralPrice, tmp.currentSupplyBalance_TargetCollateralAsset);

        tmp.discountedRepayToEvenAmount = calcDiscountedRepayToEvenAmount(targetAccount, assetBorrow, tmp.underwaterAssetPrice);

        tmp.maxCloseableBorrowAmount_TargetUnderwaterAsset = min(tmp.currentBorrowBalance_TargetUnderwaterAsset, tmp.discountedBorrowDenominatedCollateral);

        tmp.maxCloseableBorrowAmount_TargetUnderwaterAsset = min(tmp.maxCloseableBorrowAmount_TargetUnderwaterAsset, tmp.discountedRepayToEvenAmount);



        // \u8bbe\u7f6e\u5b9e\u9645\u6e05\u7b97\u91cf

        if (requestedAmountClose == uint(-1)) {

            tmp.closeBorrowAmount_TargetUnderwaterAsset = tmp.maxCloseableBorrowAmount_TargetUnderwaterAsset;

        } else {

            tmp.closeBorrowAmount_TargetUnderwaterAsset = requestedAmountClose;

        }

        require(tmp.closeBorrowAmount_TargetUnderwaterAsset <= tmp.maxCloseableBorrowAmount_TargetUnderwaterAsset, "closeBorrowAmount > maxCloseableBorrowAmount err");

        if (assetBorrow == address(0)) {

            // \u5982\u679c\u662f ETH\uff0c\u9700\u8981\u4fdd\u8bc1\u6e05\u7b97\u4eba\u4f20\u5165\u7684 value \u5927\u4e8e\u6240\u9700\u7684\u91cf

            require(msg.value >= tmp.closeBorrowAmount_TargetUnderwaterAsset, "Not enough ETH");

        } else {

            // \u5982\u679c\u662f ERC20\uff0c \u9700\u8981\u4fdd\u8bc1\u6e05\u7b97\u4eba\u8981\u6709\u8db3\u591f\u7684\u8d44\u4ea7

            require(getBalanceOf(assetBorrow, tmp.liquidator) >= tmp.closeBorrowAmount_TargetUnderwaterAsset, "insufficient balance");

        }



        // \u8ba1\u7b97\u6e05\u7b97\u4eba\u5b9e\u9645\u6e05\u7b97\u5f97\u5230\u7684\u6b64\u8d28\u62bc\u5e01\u6570\u91cf

        tmp.seizeSupplyAmount_TargetCollateralAsset = calcAmountSeize(assetBorrow, assetCollateral, tmp.underwaterAssetPrice, tmp.collateralPrice, tmp.closeBorrowAmount_TargetUnderwaterAsset);



        // \u88ab\u6e05\u7b97\u4eba\u501f\u5e01\u4f59\u989d\u51cf\u5c11

        tmp.updatedBorrowBalance_TargetUnderwaterAsset = tmp.currentBorrowBalance_TargetUnderwaterAsset.sub(tmp.closeBorrowAmount_TargetUnderwaterAsset);

        // \u66f4\u65b0\u501f\u5e01\u5e02\u573a\u603b\u91cf

        tmp.newTotalBorrows_ProtocolUnderwaterAsset = borrowMarket.totalBorrows.add(tmp.updatedBorrowBalance_TargetUnderwaterAsset).sub(borrowBalance_TargeUnderwaterAsset.principal);



        tmp.currentCash_ProtocolUnderwaterAsset = getCash(assetBorrow);

        // \u5982\u679c\u662f ERC-20 \u4ee3\u5e01\uff0c\u52a0 amount

        // \u5982\u679c\u662f ETH\uff0c\u5219\u5df2\u7ecf\u5728\u51fd\u6570\u8c03\u7528\u7684\u65f6\u5019\u8f6c\u5165\u4e86\uff0c\u5c31\u4e0d\u7528\u52a0\u4e86

        tmp.updatedCash_ProtocolUnderwaterAsset = assetBorrow != address(0) ? tmp.currentCash_ProtocolUnderwaterAsset.add(tmp.closeBorrowAmount_TargetUnderwaterAsset) : tmp.currentCash_ProtocolUnderwaterAsset;



        // \u8ba1\u7b97\u5b58\u501f\u6bd4\u7387

        tmp.newSupplyIndex_UnderwaterAsset = uint(borrowMarket.irm.pert(int(borrowMarket.supplyIndex), borrowMarket.demondRate, int(blockDelta)));

        borrowMarket.supplyRate = borrowMarket.irm.getDepositRate(int(tmp.updatedCash_ProtocolUnderwaterAsset), int(tmp.newTotalBorrows_ProtocolUnderwaterAsset));

        borrowMarket.demondRate = borrowMarket.irm.getLoanRate(int(tmp.updatedCash_ProtocolUnderwaterAsset), int(tmp.newTotalBorrows_ProtocolUnderwaterAsset));

        tmp.newBorrowIndex_CollateralAsset = uint(collateralMarket.irm.pert(int(collateralMarket.supplyIndex), collateralMarket.demondRate, int(blockDelta)));



        // \u88ab\u6e05\u7b97\u4eba\u5b58\u5e01\u4f59\u989d\u51cf\u5c11

        tmp.updatedSupplyBalance_TargetCollateralAsset = tmp.currentSupplyBalance_TargetCollateralAsset.sub(tmp.seizeSupplyAmount_TargetCollateralAsset);

        // \u6e05\u7b97\u4eba\u5b58\u5e01\u4f59\u989d\u589e\u52a0

        tmp.updatedSupplyBalance_LiquidatorCollateralAsset = tmp.currentSupplyBalance_LiquidatorCollateralAsset.add(tmp.seizeSupplyAmount_TargetCollateralAsset);



        borrowMarket.accrualBlockNumber = now;

        borrowMarket.totalBorrows = tmp.newTotalBorrows_ProtocolUnderwaterAsset;

        borrowMarket.supplyIndex = tmp.newSupplyIndex_UnderwaterAsset;

        borrowMarket.borrowIndex = tmp.newBorrowIndex_UnderwaterAsset;



        collateralMarket.accrualBlockNumber = now;

        collateralMarket.totalSupply = tmp.newTotalSupply_ProtocolCollateralAsset;

        collateralMarket.supplyIndex = tmp.newSupplyIndex_CollateralAsset;

        collateralMarket.borrowIndex = tmp.newBorrowIndex_CollateralAsset;



        tmp.startingBorrowBalance_TargetUnderwaterAsset = borrowBalance_TargeUnderwaterAsset.principal; // save for use in event

        borrowBalance_TargeUnderwaterAsset.principal = tmp.updatedBorrowBalance_TargetUnderwaterAsset;

        borrowBalance_TargeUnderwaterAsset.interestIndex = tmp.newBorrowIndex_UnderwaterAsset;



        tmp.startingSupplyBalance_TargetCollateralAsset = supplyBalance_TargetCollateralAsset.principal; // save for use in event

        supplyBalance_TargetCollateralAsset.principal = tmp.updatedSupplyBalance_TargetCollateralAsset;

        supplyBalance_TargetCollateralAsset.interestIndex = tmp.newSupplyIndex_CollateralAsset;



        tmp.startingSupplyBalance_LiquidatorCollateralAsset = supplyBalance_LiquidatorCollateralAsset.principal; // save for use in event

        supplyBalance_LiquidatorCollateralAsset.principal = tmp.updatedSupplyBalance_LiquidatorCollateralAsset;

        supplyBalance_LiquidatorCollateralAsset.interestIndex = tmp.newSupplyIndex_CollateralAsset;



        setLiquidateInfoMap(tmp.targetAccount, tmp.liquidator, tmp.assetCollateral, assetBorrow, tmp.seizeSupplyAmount_TargetCollateralAsset, tmp.closeBorrowAmount_TargetUnderwaterAsset);



        safeTransferFrom(assetBorrow, tmp.liquidator.make_payable(), address(this), address(this).make_payable(), tmp.closeBorrowAmount_TargetUnderwaterAsset, msg.value);



        emit LiquidateBorrowPawnLog(tmp.targetAccount, assetBorrow,

        tmp.updatedBorrowBalance_TargetUnderwaterAsset,

        tmp.liquidator,

        tmp.assetCollateral,

        tmp.updatedSupplyBalance_TargetCollateralAsset

        );



        return 0;

  }





function safeTransferFrom(address token, address payable owner, address spender, address payable to, uint256 amount, uint256 msgValue) internal returns (uint256) {

  require(amount > 0, "invalid safeTransferFrom amount");

  // require(token != address(0), "invalid token address!");



  if (owner != spender && token != address(0)) {

      // \u8f6c\u5165ERC20\u4ee3\u5e01

      require(IERC20(token).allowance(owner, spender) >= amount, "Insufficient allowance");

  }

  if (token != address(0)) {

    require(IERC20(token).balanceOf(owner) >= amount, "Insufficient balance");

  } else if (owner == spender) {

    // eth\uff0c owner == spender \u5373\u8f6c\u51fa\uff0c\u9700\u8981\u6821\u9a8cowner\u7684eth\u4f59\u989d

    require(owner.balance >= amount, "Insufficient eth balance");

  }



  if (owner != spender) {

    // \u8f6c\u5165

    if (token != address(0)) {

      // ERC20\u4ee3\u5e01 transferFrom \u8f6c\u5165

      IERC20(token).safeTransferFrom(owner, to, amount);

    } else if (msgValue > 0 && msgValue > amount) {

      // \u8fd8\u94b1\u65f6\uff0c\u7528\u6237\u591a\u8fd8\u4e86\u7684 eth \u9700\u8981\u8fd4\u8fd8

      owner.transfer(msgValue.sub(amount));

    }

    // eth \u5df2\u4ece payable \u51fd\u6570\u8c03\u7528\u65f6\u8f6c\u5165

  } else {

    // \u8f6c\u51fa

    if (token != address(0)) {

      // ERC20\u8f6c\u51fa

      IERC20(token).safeTransfer(to, amount);

    } else {

      // \u53c2\u6570\u8bbe\u7f6e\uff0c msgValue \u5927\u4e8e0\uff0c\u5373\u8fd8\u6b3e\u6216\u6e05\u7b97\u903b\u8f91\uff0c\u5b9e\u9645\u8fd8\u7684\u94b1\u5927\u4e8e\u9700\u8981\u8fd8\u7684\u94b1\uff0c\u9700\u8981\u8fd4\u56de\u591a\u4f59\u7684\u94b1

      // msgValue \u7b49\u4e8e 0\uff0c\u501f\u94b1\u6216\u53d6\u94b1\u903b\u8f91\uff0c\u76f4\u63a5\u8f6c\u51fa amount \u6570\u91cf\u7684\u5e01

      if (msgValue > 0 && msgValue > amount) {

        to.transfer(msgValue.sub(amount));

      } else if (msgValue == 0) {

        to.transfer(amount);

      }

    }

  }



  return 0;

}



  // \u7ba1\u7406\u5458\u53d6\u94b1

  function withdrawPawnEquity(address t, uint amount) external nonReentrant onlyAdmin returns (uint) {

    uint cash = getCash(t);

    uint equity = cash.add(mkts[t].totalBorrows).sub(mkts[t].totalSupply);

    require(equity >= amount, "insufficient equity amount");

    safeTransferFrom(t, address(this).make_payable(), address(this), admin.make_payable(), amount, 0);

    emit WithdrawPawnEquityLog(t, equity, amount, admin);

    return 0;

  }

}

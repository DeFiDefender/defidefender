// SPDX-License-Identifier: MIT

pragma experimental ABIEncoderV2;

pragma solidity 0.6.4;



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

    function sub(

        uint256 a,

        uint256 b,

        string memory errorMessage

    ) internal pure returns (uint256) {

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

    function div(

        uint256 a,

        uint256 b,

        string memory errorMessage

    ) internal pure returns (uint256) {

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

    function mod(

        uint256 a,

        uint256 b,

        string memory errorMessage

    ) internal pure returns (uint256) {

        require(b != 0, errorMessage);

        return a % b;

    }



    function min(uint256 a, uint256 b) internal pure returns (uint256) {

        return a <= b ? a : b;

    }



    function abs(uint256 a, uint256 b) internal pure returns (uint256) {

        if (a < b) {

            return b - a;

        }

        return a - b;

    }

}



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

    function transfer(address recipient, uint256 amount)

        external

        returns (bool);



    /**

     * @dev Returns the remaining number of tokens that `spender` will be

     * allowed to spend on behalf of `owner` through {transferFrom}. This is

     * zero by default.

     *

     * This value changes when {approve} or {transferFrom} are called.

     */

    function allowance(address owner, address spender)

        external

        view

        returns (uint256);



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

    function transferFrom(

        address sender,

        address recipient,

        uint256 amount

    ) external returns (bool);



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

    function decimals() external view returns (uint8);

    event Approval(

        address indexed owner,

        address indexed spender,

        uint256 value

    );

}



interface IFToken is IERC20 {

    function mint(address user, uint256 amount) external returns (bytes memory);



    function borrow(address borrower, uint256 borrowAmount)

        external

        returns (bytes memory);



    function withdraw(

        address payable withdrawer,

        uint256 withdrawTokensIn,

        uint256 withdrawAmountIn

    ) external returns (uint256, bytes memory);



    function underlying() external view returns (address);



    function accrueInterest() external;



    function getAccountState(address account)

        external

        view

        returns (

            uint256,

            uint256,

            uint256

        );



    function MonitorEventCallback(

        address who,

        bytes32 funcName,

        bytes calldata payload

    ) external;



    //\u7528\u6237\u5b58\u501f\u53d6\u8fd8\u64cd\u4f5c\u540e\u7684\u5151\u6362\u7387

    function exchangeRateCurrent() external view returns (uint256 exchangeRate);



    function repay(address borrower, uint256 repayAmount)

        external

        returns (uint256, bytes memory);



    function borrowBalanceStored(address account)

        external

        view

        returns (uint256);



    function exchangeRateStored() external view returns (uint256 exchangeRate);



    function liquidateBorrow(

        address liquidator,

        address borrower,

        uint256 repayAmount,

        address fTokenCollateral

    ) external returns (bytes memory);



    function borrowBalanceCurrent(address account) external returns (uint256);



    function balanceOfUnderlying(address owner) external returns (uint256);



    function _reduceReserves(uint256 reduceAmount) external;



    function _addReservesFresh(uint256 addAmount) external;



    function cancellingOut(address striker)

        external

        returns (bool strikeOk, bytes memory strikeLog);



    function APR() external view returns (uint256);



    function APY() external view returns (uint256);



    function calcBalanceOfUnderlying(address owner)

        external

        view

        returns (uint256);



    function borrowSafeRatio() external view returns (uint256);



    function tokenCash(address token, address account)

        external

        view

        returns (uint256);



    function getBorrowRate() external view returns (uint256);



    function addTotalCash(uint256 _addAmount) external;

    function subTotalCash(uint256 _subAmount) external;



    function totalCash() external view returns (uint256);

}



interface IBankController {

    function getCashPrior(address underlying) external view returns (uint256);



    function getCashAfter(address underlying, uint256 msgValue)

        external

        view

        returns (uint256);



    function getFTokeAddress(address underlying)

        external

        view

        returns (address);



    function transferToUser(

        address token,

        address payable user,

        uint256 amount

    ) external;



    function transferIn(

        address account,

        address underlying,

        uint256 amount

    ) external payable;



    function borrowCheck(

        address account,

        address underlying,

        address fToken,

        uint256 borrowAmount

    ) external;



    function repayCheck(address underlying) external;



    function rewardForByType(

        address account,

        uint256 gasSpend,

        uint256 gasPrice,

        uint256 rewardType

    ) external;



    function liquidateBorrowCheck(

        address fTokenBorrowed,

        address fTokenCollateral,

        address borrower,

        address liquidator,

        uint256 repayAmount

    ) external;



    function liquidateTokens(

        address fTokenBorrowed,

        address fTokenCollateral,

        uint256 actualRepayAmount

    ) external view returns (uint256);



    function withdrawCheck(

        address fToken,

        address withdrawer,

        uint256 withdrawTokens

    ) external view returns (uint256);



    function transferCheck(

        address fToken,

        address src,

        address dst,

        uint256 transferTokens

    ) external;



    function marketsContains(address fToken) external view returns (bool);



    function seizeCheck(address cTokenCollateral, address cTokenBorrowed)

        external;



    function mintCheck(address underlying, address minter) external;



    function addReserves(address underlying, uint256 addAmount)

        external

        payable;



    function reduceReserves(

        address underlying,

        address payable account,

        uint256 reduceAmount

    ) external;



    function calcMaxBorrowAmount(address user, address token)

        external

        view

        returns (uint256);



    function calcMaxWithdrawAmount(address user, address token)

        external

        view

        returns (uint256);



    function calcMaxCashOutAmount(address user, address token)

        external

        view

        returns (uint256);



    function calcMaxBorrowAmountWithRatio(address user, address token)

        external

        view

        returns (uint256);



    function transferEthGasCost() external view returns (uint256);



    function isFTokenValid(address fToken) external view returns (bool);

}



enum RewardType {

    DefaultType,

    Deposit,

    Borrow,

    Withdraw,

    Repay,

    Liquidation,

    TokenIn, //\u5165\u91d1\uff0c\u4e3a\u8fd8\u6b3e\u548c\u5b58\u6b3e\u7684\u7ec4\u5408

    TokenOut //\u51fa\u91d1\uff0c \u4e3a\u53d6\u6b3e\u548c\u501f\u6b3e\u7684\u7ec4\u5408

}



library EthAddressLib {

    /**

     * @dev returns the address used within the protocol to identify ETH

     * @return the address assigned to ETH

     */

    function ethAddress() internal pure returns (address) {

        return 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    }

}



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



contract Bank is Initializable {

    using SafeMath for uint256;



    bool public paused;



    address public mulSig;



    event MonitorEvent(bytes32 indexed funcName, bytes payload);

    modifier onlyFToken(address fToken) {

        require(

            controller.marketsContains(fToken) ||

                msg.sender == address(controller),

            "only supported ftoken or controller"

        );

        _;

    }



    function MonitorEventCallback(bytes32 funcName, bytes calldata payload)

        external

        onlyFToken(msg.sender)

    {

        emit MonitorEvent(funcName, payload);

    }



    IBankController public controller;



    address public admin;



    address public proposedAdmin;

    address public pauser;



    modifier onlyAdmin {

        require(msg.sender == admin, "OnlyAdmin");

        _;

    }



    modifier whenUnpaused {

        require(!paused, "System paused");

        _;

    }



    modifier onlyMulSig {

        require(msg.sender == mulSig, "require mulsig");

        _;

    }



    modifier onlySelf {

        require(msg.sender == address(this), "require self");

        _;

    }



    modifier onlyPauser {

        require(msg.sender == pauser, "require pauser");

        _;

    }



    function initialize(address _controller, address _mulSig)

        public

        initializer

    {

        controller = IBankController(_controller);

        mulSig = _mulSig;

        paused = false;

        admin = msg.sender;

    }



    function setController(address _controller) public onlyAdmin {

        controller = IBankController(_controller);

    }



    function setPaused() public onlyPauser {

        paused = true;

    }



    function setUnpaused() public onlyPauser {

        paused = false;

    }



    function setPauser(address _pauser) public onlyAdmin {

        pauser = _pauser;

    }



    function proposeNewAdmin(address admin_) external onlyMulSig {

        proposedAdmin = admin_;

    }



    function claimAdministration() external {

        require(msg.sender == proposedAdmin, "Not proposed admin.");

        admin = proposedAdmin;

        proposedAdmin = address(0);

    }



    // \u5b58\u94b1\u8fd4token

    modifier rewardFor(address usr, RewardType rewardType) {

        uint256 gasStart = gasleft();

        _;

        uint256 gasSpent = gasStart - gasleft();

        controller.rewardForByType(

            usr,

            gasSpent,

            tx.gasprice,

            uint256(rewardType)

        );

    }



    // \u7528\u6237\u5b58\u6b3e

    function deposit(address token, uint256 amount)

        public

        payable

        whenUnpaused

        rewardFor(msg.sender, RewardType.Deposit)

    {

        return this._deposit{value: msg.value}(token, amount, msg.sender);

    }



    // \u7528\u6237\u5b58\u6b3e

    function _deposit(

        address token,

        uint256 amount,

        address account

    ) external payable whenUnpaused onlySelf {

        IFToken fToken = IFToken(controller.getFTokeAddress(token));

        require(

            controller.marketsContains(address(fToken)),

            "unsupported token"

        );



        bytes memory flog = fToken.mint(account, amount);

        controller.transferIn{value: msg.value}(account, token, amount);



        fToken.addTotalCash(amount);



        emit MonitorEvent("Deposit", flog);

    }



    // \u7528\u6237\u501f\u6b3e

    function borrow(address underlying, uint256 borrowAmount)

        public

        whenUnpaused

        rewardFor(msg.sender, RewardType.Borrow)

    {

        IFToken fToken = IFToken(controller.getFTokeAddress(underlying));

        require(

            controller.marketsContains(address(fToken)),

            "unsupported token"

        );



        bytes memory flog = fToken.borrow(msg.sender, borrowAmount);

        emit MonitorEvent("Borrow", flog);

    }



    // \u7528\u6237\u53d6\u6b3e \u53d6 fToken \u7684\u6570\u91cf

    function withdraw(address underlying, uint256 withdrawTokens)

        public

        whenUnpaused

        rewardFor(msg.sender, RewardType.Withdraw)

        returns (uint256)

    {

        IFToken fToken = IFToken(controller.getFTokeAddress(underlying));

        require(

            controller.marketsContains(address(fToken)),

            "unsupported token"

        );



        (uint256 amount, bytes memory flog) = fToken.withdraw(

            msg.sender,

            withdrawTokens,

            0

        );

        emit MonitorEvent("Withdraw", flog);

        return amount;

    }



    // \u7528\u6237\u53d6\u6b3e \u53d6\u5e95\u5c42 token \u7684\u6570\u91cf

    function withdrawUnderlying(address underlying, uint256 withdrawAmount)

        public

        whenUnpaused

        rewardFor(msg.sender, RewardType.Withdraw)

        returns (uint256)

    {

        IFToken fToken = IFToken(controller.getFTokeAddress(underlying));

        require(

            controller.marketsContains(address(fToken)),

            "unsupported token"

        );



        (uint256 amount, bytes memory flog) = fToken.withdraw(

            msg.sender,

            0,

            withdrawAmount

        );

        emit MonitorEvent("WithdrawUnderlying", flog);

        return amount;

    }



    // \u7528\u6237\u8fd8\u6b3e

    function repay(address token, uint256 repayAmount)

        public

        payable

        whenUnpaused

        rewardFor(msg.sender, RewardType.Repay)

        returns (uint256)

    {

        return this._repay{value: msg.value}(token, repayAmount, msg.sender);

    }



    // \u7528\u6237\u8fd8\u6b3e

    function _repay(

        address token,

        uint256 repayAmount,

        address account

    ) public payable whenUnpaused onlySelf returns (uint256) {

        IFToken fToken = IFToken(controller.getFTokeAddress(token));

        require(

            controller.marketsContains(address(fToken)),

            "unsupported token"

        );



        (uint256 actualRepayAmount, bytes memory flog) = fToken.repay(

            account,

            repayAmount

        );

        controller.transferIn{value: msg.value}(

            account,

            token,

            actualRepayAmount

        );



        fToken.addTotalCash(actualRepayAmount);



        emit MonitorEvent("Repay", flog);

        return actualRepayAmount;

    }



    // \u7528\u6237\u6e05\u7b97

    function liquidateBorrow(

        address borrower,

        address underlyingBorrow,

        address underlyingCollateral,

        uint256 repayAmount

    ) public payable whenUnpaused {

        require(msg.sender != borrower, "Liquidator cannot be borrower");

        require(repayAmount > 0, "Liquidate amount not valid");



        IFToken fTokenBorrow = IFToken(

            controller.getFTokeAddress(underlyingBorrow)

        );

        IFToken fTokenCollateral = IFToken(

            controller.getFTokeAddress(underlyingCollateral)

        );

        bytes memory flog = fTokenBorrow.liquidateBorrow(

            msg.sender,

            borrower,

            repayAmount,

            address(fTokenCollateral)

        );

        controller.transferIn{value: msg.value}(

            msg.sender,

            underlyingBorrow,

            repayAmount

        );



        fTokenBorrow.addTotalCash(repayAmount);



        emit MonitorEvent("LiquidateBorrow", flog);

    }



    // \u5165\u91d1token in, \u4e3a\u8fd8\u6b3e\u548c\u5b58\u6b3e\u7684\u7ec4\u5408

    //\u6ca1\u6709\u501f\u6b3e\u65f6\uff0c\u65e0\u9700\u8fd8\u6b3e\uff0c\u6709\u501f\u6b3e\u65f6\uff0c\u5148\u8fd8\u6b3e\uff0c\u5355\u72ec\u5199\u4e00\u4e2a\u8fdb\u884c\u5165\u91d1\uff0c\u800c\u4e0d\u662f\u76f4\u63a5\u8c03\u7528mint\u548crepay\uff0c\u539f\u56e0\u5728\u4e8e\u5728ETH\u5b58\u6b3e\u65f6\u4f1a\u6709bug\uff0cmsg.value\u4f1a\u590d\u7528\u3002

    function tokenIn(address token, uint256 amountIn)

        public

        payable

        whenUnpaused

        rewardFor(msg.sender, RewardType.TokenIn)

    {

        IFToken fToken = IFToken(controller.getFTokeAddress(token));

        require(

            controller.marketsContains(address(fToken)),

            "unsupported token"

        );



        //\u5148\u8fdb\u884c\u51b2\u8d26\u64cd\u4f5c

        cancellingOut(token);

        uint256 curBorrowBalance = fToken.borrowBalanceCurrent(msg.sender);

        uint256 actualRepayAmount;



        //\u8fd8\u6e05\u6b20\u6b3e

        if (amountIn == uint256(-1)) {

            require(curBorrowBalance > 0, "no debt to repay");

            if (token != EthAddressLib.ethAddress()) {

                require(

                    msg.value == 0,

                    "msg.value should be 0 for ERC20 repay"

                );

                actualRepayAmount = this._repay{value: 0}(

                    token,

                    amountIn,

                    msg.sender

                );

            } else {

                require(

                    msg.value >= curBorrowBalance,

                    "msg.value need great or equal than current debt"

                );

                actualRepayAmount = this._repay{value: curBorrowBalance}(

                    token,

                    amountIn,

                    msg.sender

                );

                if (msg.value > actualRepayAmount) {

                    (bool result, ) = msg.sender.call{

                        value: msg.value.sub(actualRepayAmount),

                        gas: controller.transferEthGasCost()

                    }("");

                    require(result, "Transfer of exceed ETH failed");

                }

            }



            emit MonitorEvent("TokenIn", abi.encode(token, actualRepayAmount));

        } else {

            if (curBorrowBalance > 0) {

                uint256 repayEthValue = SafeMath.min(

                    curBorrowBalance,

                    amountIn

                );

                if (token != EthAddressLib.ethAddress()) {

                    repayEthValue = 0;

                }

                actualRepayAmount = this._repay{value: repayEthValue}(

                    token,

                    SafeMath.min(curBorrowBalance, amountIn),

                    msg.sender

                );

            }



            // \u8fd8\u6b3e\u6570\u91cf\u6709\u5269\u4f59\uff0c\u8f6c\u4e3a\u5b58\u6b3e

            if (actualRepayAmount < amountIn) {

                uint256 exceedAmout = SafeMath.sub(amountIn, actualRepayAmount);

                if (token != EthAddressLib.ethAddress()) {

                    exceedAmout = 0;

                }

                this._deposit{value: exceedAmout}(

                    token,

                    SafeMath.sub(amountIn, actualRepayAmount),

                    msg.sender

                );

            }



            emit MonitorEvent("TokenIn", abi.encode(token, amountIn));

        }

    }



    // \u51fa\u91d1token out, \u4e3a\u53d6\u6b3e\u548c\u501f\u6b3e\u7684\u7ec4\u5408,

    // \u53d6\u6b3e\u5982\u679c\u8be5\u7528\u6237\u6709\u5bf9\u5e94\u7684\u5b58\u6b3e(\u6709\u5bf9\u5e94\u7684ftoken)\uff0c\u5b8c\u5168\u53ef\u53d6\u51fa\uff0c\u5269\u4f59\u7684\u90e8\u5206\u91c7\u7528\u501f\u7684\u903b\u8f91,

    function tokenOut(address token, uint256 amountOut) external whenUnpaused {

        IFToken fToken = IFToken(controller.getFTokeAddress(token));

        require(

            controller.marketsContains(address(fToken)),

            "unsupported token"

        );



        //\u5148\u8fdb\u884c\u51b2\u8d26\u64cd\u4f5c

        (bool strikeOk, bytes memory strikeLog) = fToken.cancellingOut(

            msg.sender

        );



        uint256 supplyAmount = 0;

        if (amountOut == uint256(-1)) {

            uint256 fBalance = fToken.balanceOf(msg.sender);

            require(fBalance > 0, "no asset to withdraw");

            supplyAmount = withdraw(token, fBalance);



            emit MonitorEvent("TokenOut", abi.encode(token, supplyAmount));

        } else {

            uint256 userSupplyBalance = fToken.calcBalanceOfUnderlying(

                msg.sender

            );

            if (userSupplyBalance > 0) {

                if (userSupplyBalance < amountOut) {

                    supplyAmount = withdraw(

                        token,

                        fToken.balanceOf(msg.sender)

                    );

                } else {

                    supplyAmount = withdrawUnderlying(

                        token,

                        SafeMath.min(userSupplyBalance, amountOut)

                    );

                }

            }



            if (supplyAmount < amountOut) {

                borrow(token, amountOut.sub(supplyAmount));

            }



            emit MonitorEvent("TokenOut", abi.encode(token, amountOut));

        }

    }



    function cancellingOut(address token) public whenUnpaused {

        IFToken fToken = IFToken(controller.getFTokeAddress(token));

        //\u5148\u8fdb\u884c\u51b2\u8d26\u64cd\u4f5c

        (bool strikeOk, bytes memory strikeLog) = fToken.cancellingOut(

            msg.sender

        );

        if (strikeOk) {

            emit MonitorEvent("CancellingOut", strikeLog);

        }

    }

}

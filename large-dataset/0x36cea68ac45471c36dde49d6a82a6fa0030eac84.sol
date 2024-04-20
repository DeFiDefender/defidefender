// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol



pragma solidity ^0.5.0;



/**

 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include

 * the optional functions; to access them see {ERC20Detailed}.

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



// File: openzeppelin-solidity/contracts/math/SafeMath.sol



pragma solidity ^0.5.0;



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



// File: contracts/DAIProxyInterface.sol



pragma solidity 0.5.10;



interface DAIProxyInterface {

    function fund(address loanAddress, uint256 fundingAmount) external;

    function repay(address loanAddress, uint256 repaymentAmount) external;

}



// File: contracts/LoanContractInterface.sol



pragma solidity 0.5.10;



interface LoanContractInterface {

    function onFundingReceived(address lender, uint256 amount) external returns (bool);

    function withdrawRepayment() external;

    function withdrawLoan() external;

    function onRepaymentReceived(address from, uint256 amount) external returns (bool);

    function getInterestRate() external view returns (uint256);

    function calculateValueWithInterest(uint256 value) external view returns (uint256);

    function getMaxAmount() external view returns (uint256);

    function getAuctionBalance() external view returns (uint256);

}



// File: contracts/LoanContract.sol



pragma solidity 0.5.10;











contract LoanContract is LoanContractInterface {

    using SafeMath for uint256;

    IERC20 DAIToken;

    DAIProxyInterface proxy;

    address public originator;

    address public administrator;



    uint256 public minAmount;

    uint256 public maxAmount;



    uint256 public auctionEndTimestamp;

    uint256 public auctionStartTimestamp;

    uint256 public auctionLength;



    uint256 public lastFundedTimestamp;



    uint256 public termEndTimestamp;

    uint256 public termLength;



    uint256 public auctionBalance;

    uint256 public loanWithdrawnAmount;

    uint256 public borrowerDebt; // Amount borrower need to repay == principal + interests

    uint256 public minInterestRate;

    uint256 public maxInterestRate;

    uint256 public operatorFee;

    uint256 public operatorBalance;



    bool public loanWithdrawn;

    bool public minimumReached;



    uint256 constant MONTH_SECONDS = 2592000;

    uint256 constant ONE_HUNDRED = 100000000000000000000;



    struct Position {

        uint256 bidAmount;

        bool withdrawn;

    }



    mapping(address => Position) public lenderPosition;



    enum LoanState {

        CREATED, // accepts bids until timelimit initial state

        FAILED_TO_FUND, // not fully funded in timelimit

        ACTIVE, // fully funded, inside timelimit

        DEFAULTED, // not repaid in time loanRepaymentLength

        REPAID, // the borrower repaid in full, lenders have yet to reclaim funds

        CLOSED, // from failed_to_fund => last lender to withdraw triggers change / from repaid => fully witdrawn by lenders

        FROZEN // when admin unlocks withdrawals

    }



    LoanState public currentState;



    event LoanCreated(

        address indexed contractAddr,

        address indexed originator,

        uint256 minAmount,

        uint256 maxAmount,

        uint256 minInterestRate,

        uint256 maxInterestRate,

        uint256 auctionStartTimestamp,

        uint256 auctionEndTimestamp,

        address indexed administrator,

        uint256 operatorFee

    );



    event MinimumFundingReached(address loanAddress, uint256 currentBalance, uint256 interest);

    event FullyFunded(

        address loanAddress,

        uint256 balanceToRepay,

        uint256 auctionBalance,

        uint256 interest,

        uint256 fundedTimestamp

    );

    event Funded(

        address loanAddress,

        address indexed lender,

        uint256 amount,

        uint256 interest,

        uint256 fundedTimestamp

    );

    event LoanRepaid(address loanAddress, uint256 indexed timestampRepaid);

    event RepaymentWithdrawn(address loanAddress, address indexed to, uint256 amount);

    event RefundWithdrawn(address loanAddress, address indexed lender, uint256 amount);

    event FullyRefunded(address loanAddress);

    event FailedToFund(address loanAddress, address indexed lender, uint256 amount);

    event LoanFundsWithdrawn(address loanAddress, address indexed borrower, uint256 amount);

    event LoanDefaulted(address loanAddress);

    event AuctionSuccessful(

        address loanAddress,

        uint256 balanceToRepay,

        uint256 auctionBalance,

        uint256 operatorBalance,

        uint256 interest,

        uint256 fundedTimestamp

    );

    event FundsUnlockedWithdrawn(address loanAddress, address indexed lender, uint256 amount);

    event FullyFundsUnlockedWithdrawn(address loanAddress);

    event LoanFundsUnlocked(uint256 auctionBalance);

    event OperatorWithdrawn(uint256 amount, address administrator);



    modifier onlyFrozen() {

        require(currentState == LoanState.FROZEN, "Loan status is not FROZEN");

        _;

    }



    modifier onlyAdmin() {

        require(msg.sender == administrator, "Caller is not an administrator");

        _;

    }



    modifier onlyCreated() {

        require(currentState == LoanState.CREATED, "Loan status is not CREATED");

        _;

    }



    modifier onlyActive() {

        updateStateMachine();

        require(currentState == LoanState.ACTIVE, "Loan status is not ACTIVE");

        _;

    }



    modifier onlyRepaid() {

        updateStateMachine();

        require(currentState == LoanState.REPAID, "Loan status is not REPAID");

        _;

    }



    modifier onlyFailedToFund() {

        updateStateMachine();

        require(currentState == LoanState.FAILED_TO_FUND, "Loan status is not FAILED_TO_FUND");

        _;

    }



    modifier onlyProxy() {

        require(msg.sender == address(proxy), "Caller is not the proxy");

        _;

    }



    modifier onlyOriginator() {

        require(msg.sender == originator, "Caller is not the originator");

        _;

    }



    constructor(

        uint256 _termLength,

        uint256 _minAmount,

        uint256 _maxAmount,

        uint256 _minInterestRate,

        uint256 _maxInterestRate,

        address _originator,

        address DAITokenAddress,

        address proxyAddress,

        address _administrator,

        uint256 _operatorFee,

        uint256 _auctionLength

    ) public {

        DAIToken = IERC20(DAITokenAddress);

        proxy = DAIProxyInterface(proxyAddress);

        originator = _originator;

        administrator = _administrator;



        minInterestRate = _minInterestRate;

        maxInterestRate = _maxInterestRate;

        minAmount = _minAmount;

        maxAmount = _maxAmount;



        auctionLength = _auctionLength;

        auctionStartTimestamp = block.timestamp;

        auctionEndTimestamp = auctionStartTimestamp + auctionLength;



        termLength = _termLength;



        loanWithdrawnAmount = 0;



        operatorFee = _operatorFee;



        setState(LoanState.CREATED);

        emit LoanCreated(

            address(this),

            originator,

            minAmount,

            maxAmount,

            minInterestRate,

            maxInterestRate,

            auctionStartTimestamp,

            auctionEndTimestamp,

            administrator,

            operatorFee

        );

    }



    function getMaxAmount() external view returns (uint256) {

        return maxAmount;

    }



    function getAuctionBalance() external view returns (uint256) {

        return auctionBalance;

    }



    function getLenderBidAmount(address lender) external view returns (uint256) {

        return lenderPosition[lender].bidAmount;

    }



    function getLenderWithdrawn(address lender) external view returns (bool) {

        return lenderPosition[lender].withdrawn;

    }



    // Notes:

    // - This function does not track if real IERC20 balance has changed. Needs to blindly "trust" DaiProxy.

    function onFundingReceived(address lender, uint256 amount)

        external

        onlyCreated

        onlyProxy

        returns (bool)

    {

        if (isAuctionExpired()) {

            if (auctionBalance < minAmount) {

                setState(LoanState.FAILED_TO_FUND);

                emit FailedToFund(address(this), lender, amount);

                return false;

            } else {

                require(setSuccessfulAuction(), "error while transitioning to successful auction");

                emit FailedToFund(address(this), lender, amount);

                return false;

            }

        }

        uint256 interest = getInterestRate();

        lenderPosition[lender].bidAmount = lenderPosition[lender].bidAmount.add(amount);

        auctionBalance = auctionBalance.add(amount);



        lastFundedTimestamp = block.timestamp;



        if (auctionBalance >= minAmount && !minimumReached) {

            minimumReached = true;

            emit Funded(address(this), lender, amount, interest, lastFundedTimestamp);

            emit MinimumFundingReached(address(this), auctionBalance, interest);

        } else {

            emit Funded(address(this), lender, amount, interest, lastFundedTimestamp);

        }



        if (auctionBalance == maxAmount) {

            require(setSuccessfulAuction(), "error while transitioning to successful auction");

            emit FullyFunded(

                address(this),

                borrowerDebt,

                auctionBalance,

                interest,

                lastFundedTimestamp

            );

        }

        return true;

    }



    function unlockFundsWithdrawal() external onlyAdmin {

        setState(LoanState.FROZEN);

        emit LoanFundsUnlocked(auctionBalance);

    }



    function withdrawFees() external onlyAdmin returns (bool) {

        require(loanWithdrawn == true, "borrower didnt withdraw");

        require(operatorBalance > 0, "no funds to withdraw");

        uint256 allFees = operatorBalance;

        operatorBalance = 0;

        require(DAIToken.transfer(msg.sender, allFees), "transfer failed");

        emit OperatorWithdrawn(allFees, msg.sender);

        return true;

    }



    function withdrawFundsUnlocked() external onlyFrozen {

        require(!loanWithdrawn, "Loan already withdrawn");

        require(!lenderPosition[msg.sender].withdrawn, "Lender already withdrawn");

        require(lenderPosition[msg.sender].bidAmount > 0, "Account did not deposit");



        lenderPosition[msg.sender].withdrawn = true;



        loanWithdrawnAmount = loanWithdrawnAmount.add(lenderPosition[msg.sender].bidAmount);



        require(

            DAIToken.transfer(msg.sender, lenderPosition[msg.sender].bidAmount),

            "error while transfer"

        );



        emit FundsUnlockedWithdrawn(

            address(this),

            msg.sender,

            lenderPosition[msg.sender].bidAmount

        );



        if (loanWithdrawnAmount == auctionBalance.add(operatorBalance)) {

            setState(LoanState.CLOSED);

            emit FullyFundsUnlockedWithdrawn(address(this));

        }

    }



    function withdrawRefund() external onlyFailedToFund {

        require(!lenderPosition[msg.sender].withdrawn, "Lender already withdrawn");

        require(lenderPosition[msg.sender].bidAmount > 0, "Account did not deposited.");



        lenderPosition[msg.sender].withdrawn = true;



        loanWithdrawnAmount = loanWithdrawnAmount.add(lenderPosition[msg.sender].bidAmount);



        emit RefundWithdrawn(address(this), msg.sender, lenderPosition[msg.sender].bidAmount);



        require(

            DAIToken.transfer(msg.sender, lenderPosition[msg.sender].bidAmount),

            "error while transfer"

        );



        if (loanWithdrawnAmount == auctionBalance) {

            setState(LoanState.CLOSED);

            emit FullyRefunded(address(this));

        }

    }



    function withdrawRepayment() external onlyRepaid {

        require(!lenderPosition[msg.sender].withdrawn, "Lender already withdrawn");

        require(lenderPosition[msg.sender].bidAmount != 0, "Account did not deposited");

        uint256 amount = calculateValueWithInterest(lenderPosition[msg.sender].bidAmount);

        lenderPosition[msg.sender].withdrawn = true;

        emit RepaymentWithdrawn(address(this), msg.sender, amount);



        loanWithdrawnAmount = loanWithdrawnAmount.add(amount);

        require(DAIToken.transfer(msg.sender, amount), "error while transfer");



        if (loanWithdrawnAmount == borrowerDebt) {

            setState(LoanState.CLOSED);

            emit FullyRefunded(address(this));

        }

    }



    function withdrawLoan() external onlyActive onlyOriginator {

        require(!loanWithdrawn, "Already withdrawn");

        loanWithdrawn = true;

        emit LoanFundsWithdrawn(address(this), msg.sender, auctionBalance);

        require(DAIToken.transfer(msg.sender, auctionBalance), "error while transfer");

    }



    function onRepaymentReceived(address from, uint256 amount)

        external

        onlyActive

        onlyProxy

        returns (bool)

    {

        require(from == originator, "from address is not the originator");

        require(borrowerDebt == amount, "Repayment amount is not the same");



        setState(LoanState.REPAID);

        emit LoanRepaid(address(this), block.timestamp);

        return true;

    }



    function isAuctionExpired() public view returns (bool) {

        return block.timestamp > auctionEndTimestamp;

    }



    function isDefaulted() public view returns (bool) {

        if (block.timestamp <= auctionEndTimestamp || block.timestamp <= termEndTimestamp) {

            return false;

        }



        return true;

    }



    function updateStateMachine() public returns (LoanState) {

        if (isAuctionExpired() && currentState == LoanState.CREATED) {

            if (!minimumReached) {

                setState(LoanState.FAILED_TO_FUND);

            } else {

                require(setSuccessfulAuction(), "error while transitioning to successful auction");

            }

        }

        if (isDefaulted() && currentState == LoanState.ACTIVE) {

            setState(LoanState.DEFAULTED);

            emit LoanDefaulted(address(this));

        }



        return currentState;

    }



    function calculateValueWithInterest(uint256 value) public view returns (uint256) {

        return

            value.add(

                value.mul(getInterestRate().mul(termLength).div(MONTH_SECONDS)).div(ONE_HUNDRED)

            );

    }



    function getInterestRate() public view returns (uint256) {

        if (currentState == LoanState.CREATED) {

            return

                (maxInterestRate.sub(minInterestRate))

                    .mul(block.timestamp.sub(auctionStartTimestamp))

                    .div(auctionEndTimestamp.sub(auctionStartTimestamp))

                    .add(minInterestRate);

        } else if (currentState == LoanState.ACTIVE || currentState == LoanState.REPAID) {

            return

                (maxInterestRate.sub(minInterestRate))

                    .mul(lastFundedTimestamp.sub(auctionStartTimestamp))

                    .div(auctionEndTimestamp.sub(auctionStartTimestamp))

                    .add(minInterestRate);

        } else {

            return 0;

        }

    }



    function setState(LoanState state) internal {

        currentState = state;

    }



    function setSuccessfulAuction() internal onlyCreated returns (bool) {

        setState(LoanState.ACTIVE);

        borrowerDebt = calculateValueWithInterest(auctionBalance);

        operatorBalance = auctionBalance.mul(operatorFee).div(ONE_HUNDRED);

        auctionBalance = auctionBalance - operatorBalance;



        if (block.timestamp < auctionEndTimestamp) {

            termEndTimestamp = block.timestamp.add(termLength);

        } else {

            termEndTimestamp = auctionEndTimestamp.add(termLength);

        }



        emit AuctionSuccessful(

            address(this),

            borrowerDebt,

            auctionBalance,

            operatorBalance,

            getInterestRate(),

            lastFundedTimestamp

        );

        return true;

    }

}

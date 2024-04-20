pragma solidity ^0.5.4;



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



/**

 * @dev Collection of functions related to the address type

 */

library Address {

    /**

     * @dev Returns true if `account` is a contract.

     *

     * [IMPORTANT]

     * ====

     * It is unsafe to assume that an address for which this function returns

     * false is an externally-owned account (EOA) and not a contract.

     *

     * Among others, `isContract` will return false for the following 

     * types of addresses:

     *

     *  - an externally-owned account

     *  - a contract in construction

     *  - an address where a contract will be created

     *  - an address where a contract lived, but was destroyed

     * ====

     */

    function isContract(address account) internal view returns (bool) {

        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts

        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned

        // for accounts without code, i.e. `keccak256('')`

        bytes32 codehash;

        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;

        // solhint-disable-next-line no-inline-assembly

        assembly { codehash := extcodehash(account) }

        return (codehash != accountHash && codehash != 0x0);

    }



    /**

     * @dev Converts an `address` into `address payable`. Note that this is

     * simply a type cast: the actual underlying value is not changed.

     *

     * _Available since v2.4.0._

     */

    function toPayable(address account) internal pure returns (address payable) {

        return address(uint160(account));

    }



    /**

     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to

     * `recipient`, forwarding all available gas and reverting on errors.

     *

     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost

     * of certain opcodes, possibly making contracts go over the 2300 gas limit

     * imposed by `transfer`, making them unable to receive funds via

     * `transfer`. {sendValue} removes this limitation.

     *

     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].

     *

     * IMPORTANT: because control is transferred to `recipient`, care must be

     * taken to not create reentrancy vulnerabilities. Consider using

     * {ReentrancyGuard} or the

     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].

     *

     * _Available since v2.4.0._

     */

    function sendValue(address payable recipient, uint256 amount) internal {

        require(address(this).balance >= amount, "Address: insufficient balance");



        // solhint-disable-next-line avoid-call-value

        (bool success, ) = recipient.call.value(amount)("");

        require(success, "Address: unable to send value, recipient may have reverted");

    }

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

        // solhint-disable-next-line max-line-length

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

        // solhint-disable-next-line max-line-length

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

 *

 * TIP: If you would like to learn more about reentrancy and alternative ways

 * to protect against it, check out our blog post

 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].

 */

contract ReentrancyGuard {

    bool internal notEntered;



    constructor () internal {

        // Storing an initial non-zero value makes deployment a bit more

        // expensive, but in exchange the refund on every call to nonReentrant

        // will be lower in amount. Since refunds are capped to a percetange of

        // the total transaction's gas, it is best to keep them low in cases

        // like this one, to increase the likelihood of the full refund coming

        // into effect.

        notEntered = true;

    }



    /**

     * @dev Prevents a contract from calling itself, directly or indirectly.

     * Calling a `nonReentrant` function from another `nonReentrant`

     * function is not supported. It is possible to prevent this from happening

     * by making the `nonReentrant` function external, and make it call a

     * `private` function that does the actual work.

     */

    modifier nonReentrant() {

        // On the first call to nonReentrant, notEntered will be true

        require(notEntered, "ReentrancyGuard: reentrant call");



        // Any calls to nonReentrant after this point will fail

        notEntered = false;



        _;



        // By storing the original value once again, a refund is triggered (see

        // https://eips.ethereum.org/EIPS/eip-2200)

        notEntered = true;

    }

}



// This program is free software: you can redistribute it and/or modify

// it under the terms of the GNU General Public License as published by

// the Free Software Foundation, either version 3 of the License, or

// (at your option) any later version.



// This program is distributed in the hope that it will be useful,

// but WITHOUT ANY WARRANTY; without even the implied warranty of

// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the

// GNU General Public License for more details.



// You should have received a copy of the GNU General Public License

// along with this program.  If not, see <http://www.gnu.org/licenses/>.



contract DSAuthority {

    function canCall(

        address src, address dst, bytes4 sig

    ) public view returns (bool);

}



contract DSAuthEvents {

    event LogSetAuthority (address indexed authority);

    event LogSetOwner     (address indexed owner);

    event OwnerUpdate     (address indexed owner, address indexed newOwner);

}



contract DSAuth is DSAuthEvents {

    DSAuthority  public  authority;

    address      public  owner;

    address      public  newOwner;



    constructor() public {

        owner = msg.sender;

        emit LogSetOwner(msg.sender);

    }



    // Warning: you should absolutely sure you want to give up authority!!!

    function disableOwnership() public onlyOwner {

        owner = address(0);

        emit OwnerUpdate(msg.sender, owner);

    }



    function transferOwnership(address newOwner_) public onlyOwner {

        require(newOwner_ != owner, "TransferOwnership: the same owner.");

        newOwner = newOwner_;

    }



    function acceptOwnership() public {

        require(msg.sender == newOwner, "AcceptOwnership: only new owner do this.");

        emit OwnerUpdate(owner, newOwner);

        owner = newOwner;

        newOwner = address(0x0);

    }



    ///[snow] guard is Authority who inherit DSAuth.

    function setAuthority(DSAuthority authority_)

        public

        onlyOwner

    {

        authority = authority_;

        emit LogSetAuthority(address(authority));

    }



    modifier onlyOwner {

        require(isOwner(msg.sender), "ds-auth-non-owner");

        _;

    }



    function isOwner(address src) internal view returns (bool) {

        return bool(src == owner);

    }



    modifier auth {

        require(isAuthorized(msg.sender, msg.sig), "ds-auth-unauthorized");

        _;

    }



    function isAuthorized(address src, bytes4 sig) internal view returns (bool) {

        if (src == address(this)) {

            return true;

        } else if (src == owner) {

            return true;

        } else if (authority == DSAuthority(0)) {

            return false;

        } else {

            return authority.canCall(src, address(this), sig);

        }

    }

}



/// math.sol -- mixin for inline numerical wizardry



// This program is free software: you can redistribute it and/or modify

// it under the terms of the GNU General Public License as published by

// the Free Software Foundation, either version 3 of the License, or

// (at your option) any later version.



// This program is distributed in the hope that it will be useful,

// but WITHOUT ANY WARRANTY; without even the implied warranty of

// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the

// GNU General Public License for more details.



// You should have received a copy of the GNU General Public License

// along with this program.  If not, see <http://www.gnu.org/licenses/>.



pragma solidity ^0.5.4;



library DSMath {

    function add(uint x, uint y) internal pure returns (uint z) {

        require((z = x + y) >= x, "ds-math-add-overflow");

    }

    function sub(uint x, uint y) internal pure returns (uint z) {

        require((z = x - y) <= x, "ds-math-sub-underflow");

    }

    function mul(uint x, uint y) internal pure returns (uint z) {

        require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");

    }



    function div(uint x, uint y) internal pure returns (uint z) {

        require(y > 0, "ds-math-div-overflow");

        z = x / y;

    }



    function min(uint x, uint y) internal pure returns (uint z) {

        return x <= y ? x : y;

    }

    function max(uint x, uint y) internal pure returns (uint z) {

        return x >= y ? x : y;

    }



    uint constant WAD = 10 ** 18;



    function wdiv(uint x, uint y) internal pure returns (uint z) {

        z = add(mul(x, WAD), y / 2) / y;

    }



    /**

     * @dev x to the power of y power(base, exponent)

     */

    function pow(uint256 base, uint256 exponent) public pure returns (uint256) {

        if (exponent == 0) {

            return 1;

        }

        else if (exponent == 1) {

            return base;

        }

        else if (base == 0 && exponent != 0) {

            return 0;

        }

        else {

            uint256 z = base;

            for (uint256 i = 1; i < exponent; i++)

                z = mul(z, base);

            return z;

        }

    }

}



interface CErc20 {

    function balanceOf(address _owner) external view returns (uint);

    //function balanceOfUnderlying(address owner) external returns (uint);

    function balanceOfUnderlying(address owner) external view returns (uint);

    function mint(uint mintAmount) external returns (uint);

    function redeemUnderlying(uint redeemAmount) external returns (uint);

    function redeem(uint redeemAmount) external returns (uint);

    function exchangeRateStored() external view returns (uint);

}



contract Staker is DSAuth, ReentrancyGuard {

    using DSMath for uint256;

    using SafeERC20 for IERC20;



    uint256 constant TOUCHDECIMAL = 8;

    uint256 constant STABLEDECIMAL = 6;

    uint256 constant MAXIMUMDEPOSIT = 100000 * (10 ** STABLEDECIMAL);

    uint256 public minimalDeposit = 500 * (10 ** STABLEDECIMAL);



    address public touchToken;

    address public stableCoin;

    address public compound;

    uint256 public touchPrice; // offset 10 ** 6

    uint256 public principle;



    struct DepositInfo {

        uint256 amount;

        uint256 startTime;

        uint256 period;

    }



    struct Account {

        uint256 referredCount;

        uint256 referredAmount;

        uint256 referredMilestoneAchived;

        uint256 rewards;

    }



    mapping (address => mapping (uint256 => DepositInfo)) public deposits;

    mapping (address => uint256) public userDepositsCounts;

    mapping (address => uint256) public userTotalDeposited;

    mapping (address => Account) public accounts;



    event UserDeposit(address indexed sender, uint256 value, uint256 timestamp, uint256 matureDate, uint256 touchAmount, uint256 depositId);

    event UserWithdraw(address indexed sender, uint256 depositAmount, uint256 value, uint256 withdrawId, uint256 timestamp);

    event ClaimReferral(address indexed sender, uint256 touchAmount, uint256 timestamp);



    constructor(address _touch, address _stable, address _compound) public {

        touchToken = _touch;

        stableCoin = _stable;

        compound = _compound;

        IERC20(_stable).safeApprove(_compound, uint256(-1));

        touchPrice = 10 ** STABLEDECIMAL;

    }



    function deposit(uint256 _amount, uint256 _period, address _referrer) external nonReentrant auth {

        require(_amount >= minimalDeposit, "the supplied amount should more than minimal deposit.");

        require(_period > 0 && _period < 4, "the period should between 1 to 3 months. ");

        require(getUserCurrentDepositAmount(msg.sender).add(_amount) <= MAXIMUMDEPOSIT, "deposit too more per user.");



        getFromUser(_amount);

        userDepositsCounts[msg.sender] += 1;

        userTotalDeposited[msg.sender] = userTotalDeposited[msg.sender].add(_amount);

        deposits[msg.sender][userDepositsCounts[msg.sender]] = DepositInfo(_amount, getTime(), _period);

        principle = principle.add(_amount);



        uint256 referredBonus = 0;



        // update referral info

        if (userDepositsCounts[_referrer] != 0 && _referrer != msg.sender) {

            Account memory _referrerAccount = accounts[_referrer];

            (_referrerAccount, referredBonus) = _updateCountReward(_referrerAccount);

            _referrerAccount = _updateMilestoneReward(_referrerAccount, _amount);

            accounts[_referrer] = _referrerAccount;

        }



        // check interest in stable coin

        uint256 _equaledUSD = calInterest(_amount, _period);

        uint256 _touchToUser = _equaledUSD.mul(10 ** TOUCHDECIMAL).div(touchPrice);

        IERC20(touchToken).safeTransfer(msg.sender, _touchToUser.add(referredBonus));



        emit UserDeposit(

            msg.sender,

            _amount,

            getTime(),

            getTime() + _period * 30 days,

            _touchToUser.add(referredBonus),

            userDepositsCounts[msg.sender]);

    }



    function withdraw(address _user, uint256 _withdrawId) external nonReentrant {

        DepositInfo memory depositInfo = deposits[_user][_withdrawId];

        require(depositInfo.amount > 0, "the deposit has already withdrawed or not exist");

        require(getTime() >= depositInfo.startTime.add(1 days), "must deposit more than 1 days");

        require(

            getTime() >= depositInfo.startTime.add(depositInfo.period.mul(30 days)) ||

            _user == msg.sender, "the stake is not ended, must withdraw by owner");

        uint256 depositAmount = depositInfo.amount;

        principle = principle.sub(depositInfo.amount);

        uint256 shouldPayToUser = calRealInterest(_user, _withdrawId);

        depositInfo.amount = 0;

        deposits[_user][_withdrawId] = depositInfo;

        sendToUser(_user, shouldPayToUser);

        emit UserWithdraw(_user, depositAmount, shouldPayToUser, _withdrawId, getTime());

    }



    function claimReferalReward(address _user) external nonReentrant {

        Account memory _account = accounts[_user];

        require(_account.rewards != 0, "user has no rewards");

        uint256 _amount = _account.rewards;

        _account.rewards = 0;

        accounts[_user] = _account;

        IERC20(touchToken).safeTransfer(_user, _amount);

        emit ClaimReferral(_user, _amount, getTime());

    }



    // getter function

    function tokenBalance() public view returns (uint256) {

        uint256 balanceInDefi = CErc20(compound).balanceOfUnderlying(address(this));

        uint256 contractBalance = IERC20(stableCoin).balanceOf(address(this));

        return balanceInDefi.add(contractBalance);

    }



    function getProfit() public view returns (uint256) {

        uint256 _tokenBalance = tokenBalance();

        return _tokenBalance.sub(principle);

    }



    function getTime() public view returns (uint256) {

        return block.timestamp;

    }



    function getTouchPrice() public view returns (uint256) {

        return touchPrice;

    }



    function getWithdrawAmountEstimate(address _user, uint256 _withdrawId) public view returns (uint256) {

        return calRealInterest(_user, _withdrawId);

    }



    function getInterestEstimate(uint256 _amount, uint256 _period) public pure returns (uint256) {

        return calInterest(_amount, _period);

    }



    function getUserCurrentDepositAmount(address _user) public view returns (uint256) {

        uint256 depositsCounts = userDepositsCounts[_user];

        if(depositsCounts == 0) {

            return 0;

        }

        uint256 sum = 0;

        for(uint256 i = 1; i <= depositsCounts; i++) {

            sum = sum.add(deposits[_user][i].amount);

        }

        return sum;

    }



    // admin

    function setTouchPrice(uint256 _price) external auth {

        touchPrice = _price;

    }



    function setMinimalDeposit(uint256 _minimalDeposit) external auth {

        minimalDeposit = _minimalDeposit;

    }



    // owner

    function withdrawProfit() external onlyOwner {

        uint256 _profit = getProfit();

        require(CErc20(compound).redeemUnderlying(_profit) == 0, "compound error");

        IERC20(stableCoin).safeTransfer(msg.sender, _profit);

    }



    function emergencyWithdraw() external onlyOwner {

        uint256 amount = IERC20(compound).balanceOf(address(this));

        require(CErc20(compound).redeem(amount) == 0, "compound error");

        IERC20(stableCoin).safeTransfer(msg.sender, IERC20(stableCoin).balanceOf(address(this)));

    }



    function withdrawContractToken(address _token) external onlyOwner {

        // allow owner to withdraw token in contract,

        // can not withdraw cUSDT

        require(_token != address(compound), "owner can not transfer the cToken");

        uint256 balance = IERC20(_token).balanceOf(address(this));

        IERC20(_token).safeTransfer(msg.sender, balance);

    }



    // internal

    function calInterest(uint256 _amount, uint256 _period) internal pure returns (uint256) {

        if(_period == 3) { // 3 months, APR = 10%

            //return _amount * 10 / 100 / 4;

            return _amount.mul(10).div(400);

        } else if (_period == 2) { // 2 month, APR = 8 %

            //return _amount * 8 / 100 / 6;

            return _amount.mul(8).div(600);

        } else if (_period == 1) { // 1 month, APR = 6 %

            //return _amount * 6 / 100 / 12;

            return _amount.mul(6).div(1200);

        }

        return 0;

    }



    function calRealInterest(address _user, uint256 _withdrawId) internal view returns (uint256) {

        DepositInfo memory depositInfo = deposits[_user][_withdrawId];

        if (depositInfo.amount == 0) {

            return 0;

        }

        if (getTime() >= depositInfo.startTime.add(depositInfo.period.mul(30 days))) {

            return depositInfo.amount;

        } else {

            //require(_user == msg.sender, "the stake is not ended, must withdraw by owner");

            uint256 shouldCalculatedDays = getTime().sub(depositInfo.startTime).div(1 days);

            // APR 2.9% --> daily 0.00794521%

            uint256 _instrest = depositInfo.amount.mul(794521).mul(shouldCalculatedDays).div(10 ** 10);

            uint256 shouldRepayToUser = depositInfo.amount.add(_instrest).sub(calInterest(depositInfo.amount, depositInfo.period));

            return shouldRepayToUser;

        }

    }



    function _updateCountReward(Account memory _account) internal view returns (Account memory, uint256) {

        Account memory __account = _account;

        uint256 referredBonus = 0;

        if (userDepositsCounts[msg.sender] == 1) {

            __account.referredCount += 1;

            referredBonus = referredBonus.add(50 * (10 ** TOUCHDECIMAL));

            __account.rewards = __account.rewards.add((_account.referredCount / 10 * 10 + 50).mul(10 ** TOUCHDECIMAL));

        }

        return (__account, referredBonus);

    }



    function _updateMilestoneReward(Account memory _account, uint256 _amount) internal pure returns (Account memory) {

        _account.referredAmount += _amount;

        while(_account.referredAmount >= _account.referredMilestoneAchived.add(10000 * (10 ** STABLEDECIMAL))) {

            _account.referredMilestoneAchived += 10000 * (10 ** STABLEDECIMAL);

            _account.rewards += ((_account.referredMilestoneAchived.div((10000 * (10 ** STABLEDECIMAL)))).mul(200).add(800)).mul(10 ** TOUCHDECIMAL);

        }

        return _account;

    }



    function sendToUser(address _user, uint256 _amount) internal {

        require(CErc20(compound).redeemUnderlying(_amount) == 0, "compound error");

        IERC20(stableCoin).safeTransfer(_user, _amount);

    }



    function getFromUser(uint256 _amount) internal    {

        IERC20(stableCoin).safeTransferFrom(msg.sender, address(this), _amount);

        require(CErc20(compound).mint(_amount) == 0, "compound error");

    }

}

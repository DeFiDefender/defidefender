// File: contracts/SafeERC20.sol



// File: ../../../../tmp/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol

pragma experimental ABIEncoderV2;

pragma solidity ^0.6.0;



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



// File: ../../../../tmp/openzeppelin-contracts/contracts/math/SafeMath.sol



// pragma solidity ^0.6.0;



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



// File: ../../../../tmp/openzeppelin-contracts/contracts/utils/Address.sol



// pragma solidity ^0.6.0;



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

    // function toPayable(address account) internal pure returns (address payable) {

    //     return address(uint160(account));

    // }



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

    // function sendValue(address payable recipient, uint256 amount) internal {

    //     require(address(this).balance >= amount, "Address: insufficient balance");



    //     // solhint-disable-next-line avoid-low-level-calls, avoid-call-value

    //     (bool success, ) = recipient.call.value(amount)("");

    //     require(success, "Address: unable to send value, recipient may have reverted");

    // }

}



// File: ../../../../tmp/openzeppelin-contracts/contracts/token/ERC20/SafeERC20.sol



// pragma solidity ^0.6.0;









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



// File: contracts/IRouter.sol



pragma solidity ^0.6.0;



interface IRouter {

    function f(uint id, bytes32 k) external view returns (address);

    function defaultDataContract(uint id) external view returns (address);

    function bondNr() external view returns (uint);

    function setBondNr(uint _bondNr) external;



    function setDefaultContract(uint id, address data) external;

    function addField(uint id, bytes32 field, address data) external;

}



// File: contracts/StageDefine.sol



pragma solidity ^0.6.0;



    enum BondStage {

        //\u65e0\u610f\u4e49\u72b6\u6001

        DefaultStage,

        //\u8bc4\u7ea7

        RiskRating,

        RiskRatingFail,

        //\u52df\u8d44

        CrowdFunding,

        CrowdFundingSuccess,

        CrowdFundingFail,

        UnRepay,//\u5f85\u8fd8\u6b3e

        RepaySuccess,

        Overdue,

        //\u7531\u6e05\u7b97\u5bfc\u81f4\u7684\u503a\u52a1\u7ed3\u6e05

        DebtClosed

    }



    //\u72b6\u6001\u6807\u7b7e

    enum IssuerStage {

        DefaultStage,

    UnWithdrawCrowd,

        WithdrawCrowdSuccess,

    UnWithdrawPawn,

        WithdrawPawnSuccess       

    }



// File: contracts/IBondData.sol





pragma solidity ^0.6.0;





interface IBondData {

    struct what {

        address proposal;

        uint256 weight;

    }



    struct prwhat {

        address who;

        address proposal;

        uint256 reason;

    }



    struct Balance {

        //\u53d1\u884c\u8005\uff1a

        //amountGive: \u8d28\u62bc\u7684token\u6570\u91cf\uff0c\u9879\u76ee\u65b9\u4ee3\u5e01

        //amountGet: \u52df\u96c6\u7684token\u6570\u91cf\uff0cUSDT\uff0cUSDC



        //\u6295\u8d44\u8005\uff1a

        //amountGive: \u6295\u8d44\u7684token\u6570\u91cf\uff0cUSDT\uff0cUSDC

        //amountGet: \u503a\u5238\u51ed\u8bc1\u6570\u91cf

        uint256 amountGive;

        uint256 amountGet;

    }



    function issuer() external view returns (address);



    function collateralToken() external view returns (address);



    function crowdToken() external view returns (address);



    function getBorrowAmountGive() external view returns (uint256);







    function getSupplyAmount(address who) external view returns (uint256);





    function par() external view returns (uint256);



    function mintBond(address who, uint256 amount) external;



    function burnBond(address who, uint256 amount) external;





    function transferableAmount() external view returns (uint256);



    function debt() external view returns (uint256);



    function actualBondIssuance() external view returns (uint256);



    function couponRate() external view returns (uint256);



    function depositMultiple() external view returns (uint256);



    function discount() external view returns (uint256);





    function voteExpired() external view returns (uint256);





    function investExpired() external view returns (uint256);



    function totalBondIssuance() external view returns (uint256);



    function maturity() external view returns (uint256);



    function config() external view returns (address);



    function weightOf(address who) external view returns (uint256);



    function totalWeight() external view returns (uint256);



    function bondExpired() external view returns (uint256);



    function interestBearingPeriod() external;





    function bondStage() external view returns (uint256);



    function issuerStage() external view returns (uint256);



    function issueFee() external view returns (uint256);





    function totalInterest() external view returns (uint256);



    function gracePeriod() external view returns (uint256);



    function liability() external view returns (uint256);



    function remainInvestAmount() external view returns (uint256);



    function supplyMap(address) external view returns (Balance memory);





    function balanceOf(address account) external view returns (uint256);



    function setPar(uint256) external;



    function liquidateLine() external view returns (uint256);



    function setBondParam(bytes32 k, uint256 v) external;



    function setBondParamAddress(bytes32 k, address v) external;



    function minIssueRatio() external view returns (uint256);



    function partialLiquidateAmount() external view returns (uint256);



    function votes(address who) external view returns (what memory);



    function setVotes(address who, address proposal, uint256 amount) external;



    function weights(address proposal) external view returns (uint256);



    function setBondParamMapping(bytes32 name, address k, uint256 v) external;



    function top() external view returns (address);





    function voteLedger(address who) external view returns (uint256);



    function totalWeights() external view returns (uint256);





    function setPr(address who, address proposal, uint256 reason) external;



    function pr() external view returns (prwhat memory);



    function fee() external view returns (uint256);



    function profits(address who) external view returns (uint256);







    function totalProfits() external view returns (uint256);



    function originLiability() external view returns (uint256);



    function liquidating() external view returns (bool);

    function setLiquidating(bool _liquidating) external;



    function sysProfit() external view returns (uint256);

    function totalFee() external view returns (uint256);

}



// File: contracts/ReentrancyGuard.sol



//https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/ReentrancyGuard.sol

pragma solidity ^0.6.0;



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



// File: contracts/Vote.sol





pragma solidity >=0.6.0;













interface IPRA {

    function raters(address who) external view returns (bool);

}





interface IConfig {

    function ratingCandidates(address proposal) external view returns (bool);



    function depositDuration() external view returns (uint256);



    function professionalRatingWeightRatio() external view returns (uint256);



    function communityRatingWeightRatio() external view returns (uint256);



    function investDuration() external view returns (uint256);



    function communityRatingLine() external view returns (uint256);

}





interface IACL {

    function accessible(address sender, address to, bytes4 sig)

        external

        view

        returns (bool);

}





interface IRating {

    function risk() external view returns (uint256);

    function fine() external view returns (bool);

}





contract Vote is ReentrancyGuard {

    using SafeMath for uint256;

    using SafeERC20 for IERC20;



    event MonitorEvent(

        address indexed who,

        address indexed bond,

        bytes32 indexed funcName,

        bytes

    );



    function MonitorEventCallback(address who, address bond, bytes32 funcName, bytes calldata payload) external auth {

        emit MonitorEvent(who, bond, funcName, payload);

    }



    address public router;

    address public config;

    address public ACL;

    address public PRA;



    modifier auth {

        require(

            IACL(ACL).accessible(msg.sender, address(this), msg.sig),

            "Vote: access unauthorized"

        );

        _;

    }



    constructor(address _ACL, address _router, address _config, address _PRA)

        public

    {

        router = _router;

        config = _config;

        ACL = _ACL;

        PRA = _PRA;

    }



    function setACL(

        address _ACL) external {

        require(msg.sender == ACL, "require ACL");

        ACL = _ACL;

    }



    //\u4e13\u4e1a\u8bc4\u7ea7\u65f6\u8c03\u7528

    function prcast(uint256 id, address proposal, uint256 reason) external nonReentrant {

        IBondData data = IBondData(IRouter(router).defaultDataContract(id));

        require(data.voteExpired() > now, "vote is expired");

        require(

            IPRA(PRA).raters(msg.sender),

            "sender is not a professional rater"

        );

        IBondData.prwhat memory pr = data.pr();

        require(pr.proposal == address(0), "already professional rating");

        IBondData.what memory _what = data.votes(msg.sender);

        require(_what.proposal == address(0), "already community rating");

        require(data.issuer() != msg.sender, "issuer can't vote for self bond");

        require(

            IConfig(config).ratingCandidates(proposal),

            "proposal is not permissive"

        );

        data.setPr(msg.sender, proposal, reason);

        emit MonitorEvent(

            msg.sender,

            address(data),

            "prcast",

            abi.encodePacked(proposal)

        );

    }



    //\u4ec5\u80fd\u88ab data.vote \u56de\u8c03, \u793e\u533a\u6295\u7968\u65f6\u8c03\u7528

    function cast(uint256 id, address who, address proposal, uint256 amount)

        external

        auth

    {

        IBondData data = IBondData(IRouter(router).defaultDataContract(id));

        require(data.voteExpired() > now, "vote is expired");

        require(!IPRA(PRA).raters(who), "sender is a professional rater");

        require(data.issuer() != who, "issuer can't vote for self bond");

        require(

            IConfig(config).ratingCandidates(proposal),

            "proposal is not permissive"

        );



        IBondData.what memory what = data.votes(who);



        address p = what.proposal;

        uint256 w = what.weight;



        //\u591a\u6b21\u6295\u7968\u4f46\u662f\u672c\u6b21\u6295\u7968\u7684\u63d0\u6848\u4e0e\u524d\u6b21\u6295\u7968\u7684\u63d0\u6848\u4e0d\u540c

        if (p != address(0) && p != proposal) {



            data.setBondParamMapping("weights", p, data.weights(p).sub(w));

            data.setBondParamMapping("weights", proposal, data.weights(proposal).add(w));

        }



        data.setVotes(who, proposal, w.add(amount));



        data.setBondParamMapping("weights", proposal, data.weights(proposal).add(amount));

        data.setBondParam("totalWeights", data.totalWeights().add(amount));



        //\u540c\u7968\u6570\u60c5\u51b5\u4e0b\u540e\u6295\u51fa\u6765\u7684\u4e3a\u80dc

        if (data.weights(proposal) >= data.weights(data.top())) {

            // data.setTop(proposal);

            data.setBondParamAddress("top", proposal);

        }

    }



    //\u4ec5\u80fd\u88ab data.take \u56de\u8c03

    function take(uint256 id, address who) external auth returns (uint256) {

        IBondData data = IBondData(IRouter(router).defaultDataContract(id));

        require(now > data.voteExpired(), "vote is expired");

        require(data.top() != address(0), "vote is not winner");

        uint256 amount = data.voteLedger(who);



        return amount;

    }



    function rating(uint256 id) external {

        IBondData data = IBondData(IRouter(router).defaultDataContract(id));

        require(now > data.voteExpired(), "vote unexpired");



        uint256 _bondStage = data.bondStage();

        require(

            _bondStage == uint256(BondStage.RiskRating),

            "already rating finished"

        );



        uint256 totalWeights = data.totalWeights();

        IBondData.prwhat memory pr = data.pr();



        if (

            totalWeights >= IConfig(config).communityRatingLine() &&

            pr.proposal != address(0)

        ) {

            address top = data.top();

            uint256 p = IConfig(config).professionalRatingWeightRatio(); //40%

            uint256 c = IConfig(config).communityRatingWeightRatio(); //60%

            uint256 pr_weights = totalWeights.mul(p).div(c);



            if (top != pr.proposal) {

                uint256 pr_proposal_weights = data.weights(pr.proposal).add(

                    pr_weights

                );



                if (data.weights(top) < pr_proposal_weights) {

                    //data.setTop(pr.proposal);

                    data.setBondParamAddress("top", pr.proposal);

                }



                //\u793e\u533a\u8bc4\u7ea7\u7ed3\u679c\u4e0e\u4e13\u4e1a\u8bc4\u7ea7\u7684\u6295\u7968\u9009\u9879\u4e0d\u540c\u4f46\u6743\u91cd\u76f8\u7b49\u65f6, \u4ee5\u98ce\u9669\u4f4e\u7684\u4e3a\u51c6

                if (data.weights(top) == pr_proposal_weights) {

                    data.setBondParamAddress("top", 

                        IRating(top).risk() < IRating(pr.proposal).risk()

                            ? top

                            : pr.proposal

                    );

                }

            }

            if(IRating(data.top()).fine()) {

                data.setBondParam("bondStage", uint256(BondStage.CrowdFunding));

                data.setBondParam("investExpired", now + IConfig(config).investDuration());

                data.setBondParam("bondExpired", now + IConfig(config).investDuration() + data.maturity());

            } else {

                data.setBondParam("bondStage", uint256(BondStage.RiskRatingFail));

                data.setBondParam("issuerStage", uint256(IssuerStage.UnWithdrawPawn));

            }

        } else {

            data.setBondParam("bondStage", uint256(BondStage.RiskRatingFail));

            data.setBondParam("issuerStage", uint256(IssuerStage.UnWithdrawPawn));

        }



        emit MonitorEvent(

            msg.sender,

            address(data),

            "rating",

            abi.encodePacked(data.top(), data.weights(data.top()))

        );

    }



    //\u53d6\u56de\u540e\u9875\u9762\u83b7\u5f97\u624b\u7eed\u8d39\u4fdd\u7559\u539f\u503c\u4e0d\u53d8

    function profitOf(uint256 id, address who) public view returns (uint256) {

        IBondData data = IBondData(IRouter(router).defaultDataContract(id));

        uint256 _bondStage = data.bondStage();

        if (

            _bondStage == uint256(BondStage.RepaySuccess) ||

            _bondStage == uint256(BondStage.DebtClosed)

        ) {

            IBondData.what memory what = data.votes(who);

            IBondData.prwhat memory pr = data.pr();



            uint256 p = IConfig(config).professionalRatingWeightRatio();

            uint256 c = IConfig(config).communityRatingWeightRatio();



            uint256 _fee = data.fee();

            uint256 _profit = 0;



            if (pr.who != who) {

                if(what.proposal == address(0)) {

                    return 0;

                }

                //\u4ee5\u793e\u533a\u8bc4\u7ea7\u4eba\u8eab\u4efd\u6295\u8fc7\u7968

                //fee * c (0.6 * 1e18) * weights/totalweights;

                _profit = _fee.mul(c).mul(what.weight).div(

                    data.totalWeights()

                );

            } else {

                //who\u5bf9\u672c\u503a\u5238\u4ee5\u4e13\u4e1a\u8bc4\u7ea7\u4eba\u6295\u8fc7\u7968

                //fee * p (0.4 * 1e18);

                _profit = _fee.mul(p);

            }



            return _profit.div(1e18);

        }



        return 0;

    }



    //\u53d6\u56de\u8bc4\u7ea7\u6536\u76ca,\u88abbondData\u8c03\u7528

    function profit(uint256 id, address who) external auth returns (uint256) {

        IBondData data = IBondData(IRouter(router).defaultDataContract(id));

        uint256 _bondStage = data.bondStage();

        require(

            _bondStage == uint256(BondStage.RepaySuccess) ||

                _bondStage == uint256(BondStage.DebtClosed),

            "bond is unrepay or unliquidate"

        );

        require(data.profits(who) == 0, "voting profit withdrawed");

        IBondData.prwhat memory pr = data.pr();

        IBondData.what memory what = data.votes(who);

        require(what.proposal != address(0) || pr.who == who, "user is not rating vote");

        uint256 _profit = profitOf(id, who);

        data.setBondParamMapping("profits", who, _profit);

        data.setBondParam("totalProfits", data.totalProfits().add(_profit));



        return _profit;

    }

}

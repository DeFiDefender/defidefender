// File: contracts/dydx/DyDx.sol



pragma solidity ^0.5.0;



interface Structs {

    struct Val {

        uint256 value;

    }



    enum ActionType {

      Deposit,   // supply tokens

      Withdraw,  // borrow tokens

      Transfer,  // transfer balance between accounts

      Buy,       // buy an amount of some token (externally)

      Sell,      // sell an amount of some token (externally)

      Trade,     // trade tokens against another account

      Liquidate, // liquidate an undercollateralized or expiring account

      Vaporize,  // use excess tokens to zero-out a completely negative account

      Call       // send arbitrary data to an address

    }



    enum AssetDenomination {

        Wei // the amount is denominated in wei

    }



    enum AssetReference {

        Delta // the amount is given as a delta from the current value

    }



    struct AssetAmount {

        bool sign; // true if positive

        AssetDenomination denomination;

        AssetReference ref;

        uint256 value;

    }



    struct ActionArgs {

        ActionType actionType;

        uint256 accountId;

        AssetAmount amount;

        uint256 primaryMarketId;

        uint256 secondaryMarketId;

        address otherAddress;

        uint256 otherAccountId;

        bytes data;

    }



    struct Info {

        address owner;  // The address that owns the account

        uint256 number; // A nonce that allows a single address to control many accounts

    }



    struct Wei {

        bool sign; // true if positive

        uint256 value;

    }

}



contract DyDxPool is Structs {

    function getAccountWei(Info memory account, uint256 marketId) public view returns (Wei memory);

    function operate(Info[] memory, ActionArgs[] memory) public;

}



// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol



pragma solidity ^0.5.0;



/**

 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include

 * the optional functions; to access them see `ERC20Detailed`.

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

     * Emits a `Transfer` event.

     */

    function transfer(address recipient, uint256 amount) external returns (bool);



    /**

     * @dev Returns the remaining number of tokens that `spender` will be

     * allowed to spend on behalf of `owner` through `transferFrom`. This is

     * zero by default.

     *

     * This value changes when `approve` or `transferFrom` are called.

     */

    function allowance(address owner, address spender) external view returns (uint256);



    /**

     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.

     *

     * Returns a boolean value indicating whether the operation succeeded.

     *

     * > Beware that changing an allowance with this method brings the risk

     * that someone may use both the old and the new allowance by unfortunate

     * transaction ordering. One possible solution to mitigate this race

     * condition is to first reduce the spender's allowance to 0 and set the

     * desired value afterwards:

     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729

     *

     * Emits an `Approval` event.

     */

    function approve(address spender, uint256 amount) external returns (bool);



    /**

     * @dev Moves `amount` tokens from `sender` to `recipient` using the

     * allowance mechanism. `amount` is then deducted from the caller's

     * allowance.

     *

     * Returns a boolean value indicating whether the operation succeeded.

     *

     * Emits a `Transfer` event.

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

     * a call to `approve`. `value` is the new allowance.

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

        require(b <= a, "SafeMath: subtraction overflow");

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

        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522

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

        // Solidity only automatically asserts when dividing by 0

        require(b > 0, "SafeMath: division by zero");

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

        require(b != 0, "SafeMath: modulo by zero");

        return a % b;

    }

}



// File: openzeppelin-solidity/contracts/utils/Address.sol



pragma solidity ^0.5.0;



/**

 * @dev Collection of functions related to the address type,

 */

library Address {

    /**

     * @dev Returns true if `account` is a contract.

     *

     * This test is non-exhaustive, and there may be false-negatives: during the

     * execution of a contract's constructor, its address will be reported as

     * not containing a contract.

     *

     * > It is unsafe to assume that an address for which this function returns

     * false is an externally-owned account (EOA) and not a contract.

     */

    function isContract(address account) internal view returns (bool) {

        // This method relies in extcodesize, which returns 0 for contracts in

        // construction, since the code is only stored at the end of the

        // constructor execution.



        uint256 size;

        // solhint-disable-next-line no-inline-assembly

        assembly { size := extcodesize(account) }

        return size > 0;

    }

}



// File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol



pragma solidity ^0.5.0;









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



// File: contracts/dydx/DyDxFlashLoan.sol



pragma solidity ^0.5.0;











contract DyDxFlashLoan is Structs {

    using SafeERC20 for IERC20;

    DyDxPool pool = DyDxPool(0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e);



    address public WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    address public SAI = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;

    address public USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    address public DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

    mapping (address => uint) public currencies;



    constructor() public {

        currencies[WETH] = 1;

        currencies[SAI] = 2;

        currencies[USDC] = 3;

        currencies[DAI] = 4;

    }



    modifier onlyPool() {

        require(msg.sender == address(pool), "FlashLoan: could be called by DyDx pool only");

        _;

    }



    function tokenToMarketId(address token) public view returns(uint) {

        uint marketId = currencies[token];

        require(marketId != 0, "FlashLoan: Unsupported token");

        return marketId - 1;

    }



    // the DyDx will call `callFunction(address sender, Info memory accountInfo, bytes memory data) public` after during `operate` call

    function flashloan(address token, uint256 amount, bytes memory data) internal {

        IERC20(token).safeApprove(address(pool), amount + 1);

        Info[] memory infos = new Info[](1);

        ActionArgs[] memory args = new ActionArgs[](3);



        infos[0] = Info(address(this), 0);



        AssetAmount memory wamt = AssetAmount(

            false,

            AssetDenomination.Wei,

            AssetReference.Delta,

            amount

        );

        ActionArgs memory withdraw;

        withdraw.actionType = ActionType.Withdraw;

        withdraw.accountId = 0;

        withdraw.amount = wamt;

        withdraw.primaryMarketId = tokenToMarketId(token);

        withdraw.otherAddress = address(this);



        args[0] = withdraw;



        ActionArgs memory call;

        call.actionType = ActionType.Call;

        call.accountId = 0;

        call.otherAddress = address(this);

        call.data = data;



        args[1] = call;



        ActionArgs memory deposit;

        AssetAmount memory damt = AssetAmount(

            true,

            AssetDenomination.Wei,

            AssetReference.Delta,

            amount + 1

        );

        deposit.actionType = ActionType.Deposit;

        deposit.accountId = 0;

        deposit.amount = damt;

        deposit.primaryMarketId = tokenToMarketId(token);

        deposit.otherAddress = address(this);



        args[2] = deposit;



        pool.operate(infos, args);

        // IERC20(USDC).safeApprove(dydx, 0); // not neccessary

    }

}



// File: contracts/FlashloanTaker.sol



pragma solidity ^0.5.0;

pragma experimental ABIEncoderV2;







contract FlashloanTaker is DyDxFlashLoan {



    uint public loan;



    function getFlashloan(

        address flashToken,

        uint flashAmount

    ) external {

        bytes memory data = abi.encode(flashToken, flashAmount);

        flashloan(flashToken, flashAmount, data); // execution goes to `callFunction`



        // and this point we have succefully paid the dept

    }



    function callFunction(

        address /* sender */,

        Info calldata /* accountInfo */,

        bytes calldata data

    ) external onlyPool {

        (address flashToken, uint flashAmount) = abi.decode(data, (address, uint));

        uint balance = IERC20(flashToken).balanceOf(address(this));

        require(balance == flashAmount, "contract did not get the loan");

        loan = balance;



        // do whatever you want with the money

        // the dept will be automatically withdrawn from this contract at the end of execution

    }

}

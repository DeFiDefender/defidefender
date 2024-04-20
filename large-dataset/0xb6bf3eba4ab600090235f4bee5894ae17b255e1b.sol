// SPDX-License-Identifier: MIT



pragma solidity 0.6.12;



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

        // This method relies in extcodesize, which returns 0 for contracts in

        // construction, since the code is only stored at the end of the

        // constructor execution.



        uint256 size;

        // solhint-disable-next-line no-inline-assembly

        assembly {

            size := extcodesize(account)

        }

        return size > 0;

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

     */

    function sendValue(address payable recipient, uint256 amount) internal {

        require(address(this).balance >= amount, "Address: insufficient balance");



        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value

        (bool success, ) = recipient.call{value: amount}("");

        require(success, "Address: unable to send value, recipient may have reverted");

    }



    /**

     * @dev Performs a Solidity function call using a low level `call`. A

     * plain`call` is an unsafe replacement for a function call: use this

     * function instead.

     *

     * If `target` reverts with a revert reason, it is bubbled up by this

     * function (like regular Solidity function calls).

     *

     * Returns the raw returned data. To convert to the expected return value,

     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].

     *

     * Requirements:

     *

     * - `target` must be a contract.

     * - calling `target` with `data` must not revert.

     *

     * _Available since v3.1._

     */

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {

        return functionCall(target, data, "Address: low-level call failed");

    }



    /**

     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with

     * `errorMessage` as a fallback revert reason when `target` reverts.

     *

     * _Available since v3.1._

     */

    function functionCall(

        address target,

        bytes memory data,

        string memory errorMessage

    ) internal returns (bytes memory) {

        return _functionCallWithValue(target, data, 0, errorMessage);

    }



    /**

     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],

     * but also transferring `value` wei to `target`.

     *

     * Requirements:

     *

     * - the calling contract must have an ETH balance of at least `value`.

     * - the called Solidity function must be `payable`.

     *

     * _Available since v3.1._

     */

    function functionCallWithValue(

        address target,

        bytes memory data,

        uint256 value

    ) internal returns (bytes memory) {

        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");

    }



    /**

     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but

     * with `errorMessage` as a fallback revert reason when `target` reverts.

     *

     * _Available since v3.1._

     */

    function functionCallWithValue(

        address target,

        bytes memory data,

        uint256 value,

        string memory errorMessage

    ) internal returns (bytes memory) {

        require(address(this).balance >= value, "Address: insufficient balance for call");

        return _functionCallWithValue(target, data, value, errorMessage);

    }



    function _functionCallWithValue(

        address target,

        bytes memory data,

        uint256 weiValue,

        string memory errorMessage

    ) private returns (bytes memory) {

        require(isContract(target), "Address: call to non-contract");



        // solhint-disable-next-line avoid-low-level-calls

        (bool success, bytes memory returndata) = target.call{value: weiValue}(data);

        if (success) {

            return returndata;

        } else {

            // Look for revert reason and bubble it up if present

            if (returndata.length > 0) {

                // The easiest way to bubble the revert reason is using memory via assembly



                // solhint-disable-next-line no-inline-assembly

                assembly {

                    let returndata_size := mload(returndata)

                    revert(add(32, returndata), returndata_size)

                }

            } else {

                revert(errorMessage);

            }

        }

    }

}



/**

 * @title SafeERC20

 * @dev Wrappers around ERC20 operations that throw on failure (when the token

 * contract returns false). Tokens that return no value (and instead revert or

 * throw on failure) are also supported, non-reverting calls are assumed to be

 * successful.

 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,

 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.

 */

library SafeERC20 {

    using SafeMath for uint256;

    using Address for address;



    function safeTransfer(

        IERC20 token,

        address to,

        uint256 value

    ) internal {

        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));

    }



    function safeTransferFrom(

        IERC20 token,

        address from,

        address to,

        uint256 value

    ) internal {

        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));

    }



    /**

     * @dev Deprecated. This function has issues similar to the ones found in

     * {IERC20-approve}, and its usage is discouraged.

     *

     * Whenever possible, use {safeIncreaseAllowance} and

     * {safeDecreaseAllowance} instead.

     */

    function safeApprove(

        IERC20 token,

        address spender,

        uint256 value

    ) internal {

        // safeApprove should only be called when setting an initial allowance,

        // or when resetting it to zero. To increase and decrease it, use

        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'

        // solhint-disable-next-line max-line-length

        require((value == 0) || (token.allowance(address(this), spender) == 0), "SafeERC20: approve from non-zero to non-zero allowance");

        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));

    }



    function safeIncreaseAllowance(

        IERC20 token,

        address spender,

        uint256 value

    ) internal {

        uint256 newAllowance = token.allowance(address(this), spender).add(value);

        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));

    }



    function safeDecreaseAllowance(

        IERC20 token,

        address spender,

        uint256 value

    ) internal {

        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");

        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));

    }



    /**

     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement

     * on the return value: the return value is optional (but if data is returned, it must not be false).

     * @param token The token targeted by the call.

     * @param data The call data (encoded using abi.encode or one of its variants).

     */

    function _callOptionalReturn(IERC20 token, bytes memory data) private {

        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since

        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that

        // the target address contains contract code and also asserts for success in the low-level call.



        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");

        if (returndata.length > 0) {

            // Return data is optional

            // solhint-disable-next-line max-line-length

            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");

        }

    }

}



interface IStaking {

    function getEpochId(uint256 timestamp) external view returns (uint256); // get epoch id



    function getEpochUserBalance(

        address user,

        address token,

        uint128 epoch

    ) external view returns (uint256);



    function getEpochPoolSize(address token, uint128 epoch) external view returns (uint256);



    function epoch1Start() external view returns (uint256);



    function epochDuration() external view returns (uint256);



    function deposit(address tokenAddress, uint256 amount) external;



    function withdraw(address tokenAddress, uint256 amount) external;



    function balanceOf(address user, address token) external view returns (uint256);



    function manualEpochInit(address[] memory tokens, uint128 epochId) external;

}



interface IYieldFarm {

    function massHarvest() external returns (uint256);



    function harvest(uint128 epochId) external returns (uint256);



    function getCurrentEpoch() external view returns (uint256);



    function lastInitializedEpoch() external view returns (uint256);



    function getPoolSize(uint128 epochId) external view returns (uint256);



    function getEpochStake(address userAddress, uint128 epochId) external view returns (uint256);



    function userLastEpochIdHarvested() external view returns (uint256);

}



interface IUniswapV2Router {

    function factory() external pure returns (address);



    function WETH() external pure returns (address);



    function addLiquidity(

        address tokenA,

        address tokenB,

        uint256 amountADesired,

        uint256 amountBDesired,

        uint256 amountAMin,

        uint256 amountBMin,

        address to,

        uint256 deadline

    )

        external

        returns (

            uint256 amountA,

            uint256 amountB,

            uint256 liquidity

        );



    function addLiquidityETH(

        address token,

        uint256 amountTokenDesired,

        uint256 amountTokenMin,

        uint256 amountETHMin,

        address to,

        uint256 deadline

    )

        external

        payable

        returns (

            uint256 amountToken,

            uint256 amountETH,

            uint256 liquidity

        );



    function removeLiquidity(

        address tokenA,

        address tokenB,

        uint256 liquidity,

        uint256 amountAMin,

        uint256 amountBMin,

        address to,

        uint256 deadline

    ) external returns (uint256 amountA, uint256 amountB);



    function removeLiquidityETH(

        address token,

        uint256 liquidity,

        uint256 amountTokenMin,

        uint256 amountETHMin,

        address to,

        uint256 deadline

    ) external returns (uint256 amountToken, uint256 amountETH);



    function removeLiquidityWithPermit(

        address tokenA,

        address tokenB,

        uint256 liquidity,

        uint256 amountAMin,

        uint256 amountBMin,

        address to,

        uint256 deadline,

        bool approveMax,

        uint8 v,

        bytes32 r,

        bytes32 s

    ) external returns (uint256 amountA, uint256 amountB);



    function removeLiquidityETHWithPermit(

        address token,

        uint256 liquidity,

        uint256 amountTokenMin,

        uint256 amountETHMin,

        address to,

        uint256 deadline,

        bool approveMax,

        uint8 v,

        bytes32 r,

        bytes32 s

    ) external returns (uint256 amountToken, uint256 amountETH);



    function swapExactTokensForTokens(

        uint256 amountIn,

        uint256 amountOutMin,

        address[] calldata path,

        address to,

        uint256 deadline

    ) external returns (uint256[] memory amounts);



    function swapTokensForExactTokens(

        uint256 amountOut,

        uint256 amountInMax,

        address[] calldata path,

        address to,

        uint256 deadline

    ) external returns (uint256[] memory amounts);



    function swapExactETHForTokens(

        uint256 amountOutMin,

        address[] calldata path,

        address to,

        uint256 deadline

    ) external payable returns (uint256[] memory amounts);



    function swapTokensForExactETH(

        uint256 amountOut,

        uint256 amountInMax,

        address[] calldata path,

        address to,

        uint256 deadline

    ) external returns (uint256[] memory amounts);



    function swapExactTokensForETH(

        uint256 amountIn,

        uint256 amountOutMin,

        address[] calldata path,

        address to,

        uint256 deadline

    ) external returns (uint256[] memory amounts);



    function swapETHForExactTokens(

        uint256 amountOut,

        address[] calldata path,

        address to,

        uint256 deadline

    ) external payable returns (uint256[] memory amounts);



    function quote(

        uint256 amountA,

        uint256 reserveA,

        uint256 reserveB

    ) external pure returns (uint256 amountB);



    function getAmountOut(

        uint256 amountIn,

        uint256 reserveIn,

        uint256 reserveOut

    ) external pure returns (uint256 amountOut);



    function getAmountIn(

        uint256 amountOut,

        uint256 reserveIn,

        uint256 reserveOut

    ) external pure returns (uint256 amountIn);



    function getAmountsOut(uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts);



    function getAmountsIn(uint256 amountOut, address[] calldata path) external view returns (uint256[] memory amounts);



    function removeLiquidityETHSupportingFeeOnTransferTokens(

        address token,

        uint256 liquidity,

        uint256 amountTokenMin,

        uint256 amountETHMin,

        address to,

        uint256 deadline

    ) external returns (uint256 amountETH);



    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(

        address token,

        uint256 liquidity,

        uint256 amountTokenMin,

        uint256 amountETHMin,

        address to,

        uint256 deadline,

        bool approveMax,

        uint8 v,

        bytes32 r,

        bytes32 s

    ) external returns (uint256 amountETH);



    function swapExactTokensForTokensSupportingFeeOnTransferTokens(

        uint256 amountIn,

        uint256 amountOutMin,

        address[] calldata path,

        address to,

        uint256 deadline

    ) external;



    function swapExactETHForTokensSupportingFeeOnTransferTokens(

        uint256 amountOutMin,

        address[] calldata path,

        address to,

        uint256 deadline

    ) external payable;



    function swapExactTokensForETHSupportingFeeOnTransferTokens(

        uint256 amountIn,

        uint256 amountOutMin,

        address[] calldata path,

        address to,

        uint256 deadline

    ) external;

}



interface Balancer {

    function balanceOf(address account) external view returns (uint256);



    function transfer(address recipient, uint256 amount) external returns (bool);



    function joinPool(uint256 poolAmountOut, uint256[] calldata maxAmountsIn) external;



    function exitPool(uint256 poolAmountIn, uint256[] calldata minAmountsOut) external;



    function swapExactAmountIn(

        address tokenIn,

        uint256 tokenAmountIn,

        address tokenOut,

        uint256 minAmountOut,

        uint256 maxPrice

    ) external returns (uint256 tokenAmountOut, uint256 spotPriceAfter);



    function swapExactAmountOut(

        address tokenIn,

        uint256 maxAmountIn,

        address tokenOut,

        uint256 tokenAmountOut,

        uint256 maxPrice

    ) external returns (uint256 tokenAmountIn, uint256 spotPriceAfter);



    function joinswapExternAmountIn(

        address tokenIn,

        uint256 tokenAmountIn,

        uint256 minPoolAmountOut

    ) external returns (uint256 poolAmountOut);



    function exitswapPoolAmountIn(

        address tokenOut,

        uint256 poolAmountIn,

        uint256 minAmountOut

    ) external returns (uint256 tokenAmountOut);



    function getBalance(address token) external view returns (uint256);



    function totalSupply() external view returns (uint256);



    function getTotalDenormalizedWeight() external view returns (uint256);



    function getNormalizedWeight(address token) external view returns (uint256);



    function getDenormalizedWeight(address token) external view returns (uint256);

}



interface ILpPairConverter {

    function lpPair() external view returns (address);



    function token0() external view returns (address);



    function token1() external view returns (address);



    function accept(address _input) external view returns (bool);



    function get_virtual_price() external view returns (uint256);



    function convert_rate(

        address _input,

        address _output,

        uint256 _inputAmount

    ) external view returns (uint256 _outputAmount);



    function calc_add_liquidity(uint256 _amount0, uint256 _amount1) external view returns (uint256);



    function calc_remove_liquidity(uint256 _shares) external view returns (uint256 _amount0, uint256 _amount1);



    function convert(

        address _input,

        address _output,

        address _to

    ) external returns (uint256 _outputAmount);



    function add_liquidity(address _to) external returns (uint256 _outputAmount);



    function remove_liquidity(address _to) external returns (uint256 _amount0, uint256 _amount1);

}



interface ICompositeVault {

    function cap() external view returns (uint256);



    function getConverter() external view returns (address);



    function getVaultMaster() external view returns (address);



    function balance() external view returns (uint256);



    function tvl() external view returns (uint256); // total dollar value



    function token() external view returns (address);



    function available() external view returns (uint256);



    function accept(address _input) external view returns (bool);



    function earn() external;



    function harvest(address reserve, uint256 amount) external;



    function addNewCompound(uint256, uint256) external;



    function withdraw_fee(uint256 _shares) external view returns (uint256);



    function calc_token_amount_deposit(address _input, uint256 _amount) external view returns (uint256);



    function calc_add_liquidity(uint256 _amount0, uint256 _amount1) external view returns (uint256);



    function calc_token_amount_withdraw(uint256 _shares, address _output) external view returns (uint256);



    function calc_remove_liquidity(uint256 _shares) external view returns (uint256 _amount0, uint256 _amount1);



    function getPricePerFullShare() external view returns (uint256);



    function get_virtual_price() external view returns (uint256); // average dollar value of vault share token



    function deposit(

        address _input,

        uint256 _amount,

        uint256 _min_mint_amount

    ) external returns (uint256);



    function depositFor(

        address _account,

        address _to,

        address _input,

        uint256 _amount,

        uint256 _min_mint_amount

    ) external returns (uint256 _mint_amount);



    function addLiquidity(

        uint256 _amount0,

        uint256 _amount1,

        uint256 _min_mint_amount

    ) external returns (uint256);



    function addLiquidityFor(

        address _account,

        address _to,

        uint256 _amount0,

        uint256 _amount1,

        uint256 _min_mint_amount

    ) external returns (uint256 _mint_amount);



    function withdraw(

        uint256 _shares,

        address _output,

        uint256 _min_output_amount

    ) external returns (uint256);



    function withdrawFor(

        address _account,

        uint256 _shares,

        address _output,

        uint256 _min_output_amount

    ) external returns (uint256 _output_amount);



    function harvestStrategy(address _strategy) external;



    function harvestAllStrategies() external;

}



interface IController {

    function vault() external view returns (address);



    function strategyLength() external view returns (uint256);



    function strategyBalance() external view returns (uint256);



    function getStrategyCount() external view returns (uint256);



    function strategies(uint256 _stratId)

        external

        view

        returns (

            address _strategy,

            uint256 _quota,

            uint256 _percent

        );



    function getBestStrategy() external view returns (address _strategy);



    function want() external view returns (address);



    function balanceOf() external view returns (uint256);



    function withdraw_fee(uint256 _amount) external view returns (uint256); // eg. 3CRV => pJar: 0.5% (50/10000)



    function investDisabled() external view returns (bool);



    function withdraw(uint256) external returns (uint256 _withdrawFee);



    function earn(address _token, uint256 _amount) external;



    function harvestStrategy(address _strategy) external;



    function harvestAllStrategies() external;

}



interface IVaultMaster {

    function bank(address) external view returns (address);



    function isVault(address) external view returns (bool);



    function isController(address) external view returns (bool);



    function isStrategy(address) external view returns (bool);



    function slippage(address) external view returns (uint256);



    function convertSlippage(address _input, address _output) external view returns (uint256);



    function valueToken() external view returns (address);



    function govVault() external view returns (address);



    function insuranceFund() external view returns (address);



    function performanceReward() external view returns (address);



    function govVaultProfitShareFee() external view returns (uint256);



    function gasFee() external view returns (uint256);



    function insuranceFee() external view returns (uint256);



    function withdrawalProtectionFee() external view returns (uint256);

}



/*



 A strategy must implement the following calls;



 - deposit()

 - withdraw(address) must exclude any tokens used in the yield - Controller role - withdraw should return to Controller

 - withdraw(uint) - Controller | Vault role - withdraw should always return to vault

 - withdrawAll() - Controller | Vault role - withdraw should always return to vault

 - balanceOf()



 Where possible, strategies must remain as immutable as possible, instead of updating variables, we update the contract by linking it in the controller



*/

abstract contract StrategyBase {

    using SafeERC20 for IERC20;

    using Address for address;

    using SafeMath for uint256;



    IUniswapV2Router public unirouter = IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

    address public valueLiquidEthValuePool = address(0xbd63d492bbb13d081D680CE1f2957a287FD8c57c);

    address public valueLiquidUsdcValuePool = address(0x67755124D8E4965c5c303fFd15641Db4Ff366e47);



    address public valueToken = address(0x49E833337ECe7aFE375e44F4E3e8481029218E5c);

    address public weth = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);

    address public usdc = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);



    address public lpPair;

    address public token0;

    address public token1;



    address public farmingToken;



    uint256 public withdrawalFee = 0; // over 10000



    address public governance;

    address public timelock = address(0x105e62e4bDFA67BCA18400Cfbe2EAcD4D0Be080d);



    address public controller;

    address public strategist;



    address public converter;



    ICompositeVault public vault;

    IVaultMaster public vaultMaster;



    mapping(address => mapping(address => address[])) public uniswapPaths; // [input -> output] => uniswap_path

    mapping(address => mapping(address => address)) public vliquidPools; // [input -> output] => balancer_pool



    constructor(

        address _converter,

        address _farmingToken,

        address _weth,

        address _controller

    ) public {

        ILpPairConverter _cvter = ILpPairConverter(_converter);

        lpPair = _cvter.lpPair();

        token0 = _cvter.token0();

        token1 = _cvter.token1();

        converter = _converter;

        farmingToken = _farmingToken;

        if (_weth != address(0)) weth = _weth;

        converter = _converter;

        controller = _controller;

        vault = ICompositeVault(IController(_controller).vault());

        require(address(vault) != address(0), "!vault");

        vaultMaster = IVaultMaster(vault.getVaultMaster());

        governance = msg.sender;

        strategist = msg.sender;



        if (token0 != address(0)) {

            IERC20(token0).safeApprove(address(unirouter), type(uint256).max);

        }

        if (token1 != address(0)) {

            IERC20(token1).safeApprove(address(unirouter), type(uint256).max);

        }

        if (farmingToken != token0 && farmingToken != token1) IERC20(farmingToken).safeApprove(address(unirouter), type(uint256).max);

        if (weth != token0 && weth != token1 && weth != farmingToken) IERC20(weth).safeApprove(address(unirouter), type(uint256).max);



        vliquidPools[weth][valueToken] = valueLiquidEthValuePool;

        vliquidPools[usdc][valueToken] = valueLiquidUsdcValuePool;

        IERC20(weth).safeApprove(address(valueLiquidEthValuePool), type(uint256).max);

        IERC20(usdc).safeApprove(address(valueLiquidUsdcValuePool), type(uint256).max);

    }



    modifier onlyGovernance() {

        require(msg.sender == governance, "!governance");

        _;

    }



    modifier onlyStrategist() {

        require(msg.sender == strategist || msg.sender == governance, "!strategist");

        _;

    }



    modifier onlyAuthorized() {

        require(msg.sender == address(controller) || msg.sender == strategist || msg.sender == governance, "!authorized");

        _;

    }



    function getName() public pure virtual returns (string memory);



    function approveForSpender(

        IERC20 _token,

        address _spender,

        uint256 _amount

    ) external onlyGovernance {

        _token.safeApprove(_spender, _amount);

    }



    function setUnirouter(IUniswapV2Router _unirouter) external onlyGovernance {

        unirouter = _unirouter;

        IERC20(token0).safeApprove(address(unirouter), type(uint256).max);

        IERC20(token1).safeApprove(address(unirouter), type(uint256).max);

        if (farmingToken != token0 && farmingToken != token1) IERC20(farmingToken).safeApprove(address(unirouter), type(uint256).max);

        if (weth != token0 && weth != token1 && weth != farmingToken) IERC20(weth).safeApprove(address(unirouter), type(uint256).max);

    }



    function setUnirouterPath(

        address _input,

        address _output,

        address[] memory _path

    ) public onlyStrategist {

        uniswapPaths[_input][_output] = _path;

    }



    function setBalancerPools(

        address _input,

        address _output,

        address _pool

    ) public onlyStrategist {

        vliquidPools[_input][_output] = _pool;

        IERC20(_input).safeApprove(_pool, type(uint256).max);

    }



    function deposit() public virtual;



    function skim() external {

        IERC20(lpPair).safeTransfer(controller, IERC20(lpPair).balanceOf(address(this)));

    }



    function withdraw(IERC20 _asset) external onlyAuthorized returns (uint256 balance) {

        require(lpPair != address(_asset), "lpPair");



        balance = _asset.balanceOf(address(this));

        _asset.safeTransfer(controller, balance);

    }



    function withdrawToController(uint256 _amount) external onlyAuthorized {

        require(controller != address(0), "!controller"); // additional protection so we don't burn the funds



        uint256 _balance = IERC20(lpPair).balanceOf(address(this));

        if (_balance < _amount) {

            _amount = _withdrawSome(_amount.sub(_balance));

            _amount = _amount.add(_balance);

        }



        IERC20(lpPair).safeTransfer(controller, _amount);

    }



    function _withdrawSome(uint256 _amount) internal virtual returns (uint256);



    // Withdraw partial funds, normally used with a vault withdrawal

    function withdraw(uint256 _amount) external onlyAuthorized returns (uint256) {

        uint256 _balance = IERC20(lpPair).balanceOf(address(this));

        if (_balance < _amount) {

            _amount = _withdrawSome(_amount.sub(_balance));

            _amount = _amount.add(_balance);

        }



        IERC20(lpPair).safeTransfer(address(vault), _amount);

        return _amount;

    }



    // Withdraw all funds, normally used when migrating strategies

    function withdrawAll() external onlyAuthorized returns (uint256 balance) {

        _withdrawAll();

        balance = IERC20(lpPair).balanceOf(address(this));

        IERC20(lpPair).safeTransfer(address(vault), balance);

    }



    function _withdrawAll() internal virtual;



    function claimReward() public virtual;



    function _swapTokens(

        address _input,

        address _output,

        uint256 _amount

    ) internal {

        address _pool = vliquidPools[_input][_output];

        if (_pool != address(0)) {

            // use balancer/vliquid

            Balancer(_pool).swapExactAmountIn(_input, _amount, _output, 1, type(uint256).max);

        } else {

            // use Uniswap

            address[] memory path = uniswapPaths[_input][_output];

            if (path.length == 0) {

                // path: _input -> _output

                path = new address[](2);

                path[0] = _input;

                path[1] = _output;

            }

            unirouter.swapExactTokensForTokens(_amount, 1, path, address(this), now.add(1800));

        }

    }



    function _addLiquidity() internal {

        IERC20 _token0 = IERC20(token0);

        IERC20 _token1 = IERC20(token1);

        uint256 _amount0 = _token0.balanceOf(address(this));

        uint256 _amount1 = _token1.balanceOf(address(this));

        if (_amount0 > 0 && _amount1 > 0) {

            _token0.safeTransfer(converter, _amount0);

            _token1.safeTransfer(converter, _amount1);

            ILpPairConverter(converter).add_liquidity(address(this));

        }

    }



    function _buyWantAndReinvest() internal virtual;



    function harvest(address _mergedStrategy) external virtual {

        require(msg.sender == controller || msg.sender == strategist || msg.sender == governance, "!authorized");

        claimReward();

        uint256 _farmingTokenBal = IERC20(farmingToken).balanceOf(address(this));

        if (_farmingTokenBal == 0) return;



        _swapTokens(farmingToken, weth, _farmingTokenBal);

        uint256 _wethBal = IERC20(weth).balanceOf(address(this));



        if (_wethBal > 0) {

            if (_mergedStrategy != address(0)) {

                require(vaultMaster.isStrategy(_mergedStrategy), "!strategy"); // additional protection so we don't burn the funds

                IERC20(weth).safeTransfer(_mergedStrategy, _wethBal); // forward WETH to one strategy and do the profit split all-in-one there (gas saving)

            } else {

                address _govVault = vaultMaster.govVault();

                address _insuranceFund = vaultMaster.insuranceFund(); // to pay back who lost due to flash-loan attack on Nov 14 2020

                address _performanceReward = vaultMaster.performanceReward();

                uint256 _govVaultProfitShareFee = vaultMaster.govVaultProfitShareFee();

                uint256 _insuranceFee = vaultMaster.insuranceFee();

                uint256 _gasFee = vaultMaster.gasFee();



                if (_govVaultProfitShareFee > 0 && _govVault != address(0)) {

                    address _valueToken = vaultMaster.valueToken();

                    uint256 _amount = _wethBal.mul(_govVaultProfitShareFee).div(10000);

                    _swapTokens(weth, _valueToken, _amount);

                    IERC20(_valueToken).safeTransfer(_govVault, IERC20(_valueToken).balanceOf(address(this)));

                }



                if (_insuranceFee > 0 && _insuranceFund != address(0)) {

                    uint256 _amount = _wethBal.mul(_insuranceFee).div(10000);

                    IERC20(weth).safeTransfer(_insuranceFund, _amount);

                }



                if (_gasFee > 0 && _performanceReward != address(0)) {

                    uint256 _amount = _wethBal.mul(_gasFee).div(10000);

                    IERC20(weth).safeTransfer(_performanceReward, _amount);

                }



                _buyWantAndReinvest();

            }

        }

    }



    function balanceOfPool() public view virtual returns (uint256);



    function balanceOf() public view returns (uint256) {

        return IERC20(lpPair).balanceOf(address(this)).add(balanceOfPool());

    }



    function claimable_tokens() external view virtual returns (uint256);



    function withdrawFee(uint256 _amount) external view returns (uint256) {

        return _amount.mul(withdrawalFee).div(10000);

    }



    function setGovernance(address _governance) external onlyGovernance {

        governance = _governance;

    }



    function setTimelock(address _timelock) external {

        require(msg.sender == timelock, "!timelock");

        timelock = _timelock;

    }



    function setStrategist(address _strategist) external onlyGovernance {

        strategist = _strategist;

    }



    function setController(address _controller) external {

        require(msg.sender == governance, "!governance");

        controller = _controller;

        vault = ICompositeVault(IController(_controller).vault());

        require(address(vault) != address(0), "!vault");

        vaultMaster = IVaultMaster(vault.getVaultMaster());

    }



    function setConverter(address _converter) external {

        require(msg.sender == governance, "!governance");

        require(ILpPairConverter(_converter).lpPair() == lpPair, "!lpPair");

        require(ILpPairConverter(_converter).token0() == token0, "!token0");

        require(ILpPairConverter(_converter).token1() == token1, "!token1");

        converter = _converter;

    }



    function setWithdrawalFee(uint256 _withdrawalFee) external onlyGovernance {

        withdrawalFee = _withdrawalFee;

    }



    event ExecuteTransaction(address indexed target, uint256 value, string signature, bytes data);



    /**

     * @dev This is from Timelock contract.

     */

    function executeTransaction(

        address target,

        uint256 value,

        string memory signature,

        bytes memory data

    ) public returns (bytes memory) {

        require(msg.sender == timelock, "!timelock");



        bytes memory callData;



        if (bytes(signature).length == 0) {

            callData = data;

        } else {

            callData = abi.encodePacked(bytes4(keccak256(bytes(signature))), data);

        }



        // solium-disable-next-line security/no-call-value

        (bool success, bytes memory returnData) = target.call{value: value}(callData);

        require(success, string(abi.encodePacked(getName(), "::executeTransaction: Transaction execution reverted.")));



        emit ExecuteTransaction(target, value, signature, data);



        return returnData;

    }

}



/*



 A strategy must implement the following calls;



 - deposit()

 - withdraw(address) must exclude any tokens used in the yield - Controller role - withdraw should return to Controller

 - withdraw(uint) - Controller | Vault role - withdraw should always return to vault

 - withdrawAll() - Controller | Vault role - withdraw should always return to vault

 - balanceOf()



 Where possible, strategies must remain as immutable as possible, instead of updating variables, we update the contract by linking it in the controller



*/

contract StrategyBarnBridgeUsdc is StrategyBase {

    // constants

    uint256 public constant YIELD_TOTAL_DISTRIBUTED_AMOUNT = 800000;

    uint256 public constant YIELD_NR_OF_EPOCHS = 25;



    uint256 public blocksToReleaseCompound = 7 * 6500; // 7 days to release all the new compounding amount



    address public staking;

    address public yieldFarm;



    // lpPair       = 0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48 (USDC)

    // token0       = 0x0

    // token1       = 0x0

    // weth       = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2 (WETH)

    // farmingToken = 0x0391d2021f89dc339f60fff84546ea23e337750f (BOND)

    // staking      = 0xb0Fa2BeEe3Cf36a7Ac7E99B885b48538Ab364853 (Staking)

    // yield farm   = 0xB3F7abF8FA1Df0fF61C5AC38d35e20490419f4bb (YieldFarm)

    constructor(

        address _converter,

        address _farmingToken,

        address _stakingContract,

        address _weth,

        address _controller,

        address _yieldFarmContract

    ) public StrategyBase(_converter, _farmingToken, _weth, _controller) {

        staking = _stakingContract;

        yieldFarm = _yieldFarmContract;



        IERC20(lpPair).safeApprove(address(staking), type(uint256).max);

    }



    function getName() public pure override returns (string memory) {

        return "StrategyBarnBridgeUsdc";

    }



    function deposit() public override {

        uint256 _lpPairBal = IERC20(lpPair).balanceOf(address(this));

        if (_lpPairBal > 0) {

            IStaking(staking).deposit(lpPair, _lpPairBal);

        }

    }



    function _withdrawSome(uint256 _amount) internal override returns (uint256) {

        uint256 _stakedAmount = IStaking(staking).balanceOf(address(this), lpPair);

        if (_amount > _stakedAmount) {

            _amount = _stakedAmount;

        }

        uint256 _before = IERC20(lpPair).balanceOf(address(this));

        IStaking(staking).withdraw(lpPair, _amount);

        uint256 _after = IERC20(lpPair).balanceOf(address(this));

        _amount = _after.sub(_before);



        return _amount;

    }



    function _withdrawAll() internal override {

        uint256 _stakedAmount = IStaking(staking).balanceOf(address(this), lpPair);

        IStaking(staking).withdraw(lpPair, _stakedAmount);

    }



    function claimReward() public override {

        IYieldFarm(yieldFarm).massHarvest();

    }



    function harvest(address _mergedStrategy) external override {

        require(msg.sender == controller || msg.sender == strategist || msg.sender == governance, "!authorized");

        claimReward();

        uint256 _farmingTokenBal = IERC20(farmingToken).balanceOf(address(this));

        if (_farmingTokenBal == 0) return;



        _swapTokens(farmingToken, usdc, _farmingTokenBal);

        uint256 _usdcBal = IERC20(usdc).balanceOf(address(this));



        if (_usdcBal > 0) {

            if (_mergedStrategy != address(0)) {

                require(vaultMaster.isStrategy(_mergedStrategy), "!strategy"); // additional protection so we don't burn the funds

                IERC20(usdc).safeTransfer(_mergedStrategy, _usdcBal); // forward USDC to one strategy and do the profit split all-in-one there (gas saving)

            } else {

                address _govVault = vaultMaster.govVault();

                address _insuranceFund = vaultMaster.insuranceFund(); // to pay back who lost due to flash-loan attack on Nov 14 2020

                address _performanceReward = vaultMaster.performanceReward();

                uint256 _govVaultProfitShareFee = vaultMaster.govVaultProfitShareFee();

                uint256 _insuranceFee = vaultMaster.insuranceFee();

                uint256 _gasFee = vaultMaster.gasFee();



                if (_govVaultProfitShareFee > 0 && _govVault != address(0)) {

                    address _valueToken = vaultMaster.valueToken();

                    uint256 _amount = _usdcBal.mul(_govVaultProfitShareFee).div(10000);

                    _swapTokens(usdc, _valueToken, _amount);

                    IERC20(_valueToken).safeTransfer(_govVault, IERC20(_valueToken).balanceOf(address(this)));

                }



                if (_insuranceFee > 0 && _insuranceFund != address(0)) {

                    uint256 _amount = _usdcBal.mul(_insuranceFee).div(10000);

                    IERC20(usdc).safeTransfer(_insuranceFund, _amount);

                }



                if (_gasFee > 0 && _performanceReward != address(0)) {

                    uint256 _amount = _usdcBal.mul(_gasFee).div(10000);

                    IERC20(usdc).safeTransfer(_performanceReward, _amount);

                }



                _buyWantAndReinvest();

            }

        }

    }



    function _buyWantAndReinvest() internal override {

        if (usdc != lpPair) {

            uint256 _usdcBal = IERC20(usdc).balanceOf(address(this));

            _swapTokens(usdc, lpPair, _usdcBal);

        }



        uint256 _after = IERC20(lpPair).balanceOf(address(this));

        if (_after > 0) {

            uint256 _compound = _after;

            vault.addNewCompound(_compound, blocksToReleaseCompound);



            deposit();

        }

    }



    function balanceOfPool() public view override returns (uint256) {

        uint256 amount = IStaking(staking).balanceOf(address(this), lpPair);

        return amount;

    }



    function claimable_tokens() external view override returns (uint256 totalDistributedValue) {

        IYieldFarm yieldFarmContract = IYieldFarm(yieldFarm);



        uint256 epochId = yieldFarmContract.getCurrentEpoch().sub(1); // fails in epoch 0

        // force max number of epochs

        if (epochId > YIELD_NR_OF_EPOCHS) {

            epochId = YIELD_NR_OF_EPOCHS;

        }



        for (uint256 i = yieldFarmContract.userLastEpochIdHarvested() + 1; i <= epochId; i++) {

            // i = epochId

            // compute distributed Value and do one single transfer at the end

            totalDistributedValue += _claimable_epoch(yieldFarmContract, uint128(i));

        }

        return totalDistributedValue;

    }



    function setBlocksToReleaseCompound(uint256 _blocks) external onlyStrategist {

        blocksToReleaseCompound = _blocks;

    }



    function setStakingContract(address _stakingContract) external onlyStrategist {

        staking = _stakingContract;

    }



    function setYieldFarmContract(address _yieldFarmContract) external onlyStrategist {

        yieldFarm = _yieldFarmContract;

    }



    function _claimable_epoch(IYieldFarm yieldFarmContract, uint128 epochId) internal view returns (uint256) {

        // exit if there is no stake on the epoch

        uint256 poolSizeEpoch = yieldFarmContract.getPoolSize(epochId);

        if (poolSizeEpoch == 0) {

            return 0;

        }



        return

            YIELD_TOTAL_DISTRIBUTED_AMOUNT.mul(10**18).div(YIELD_NR_OF_EPOCHS).mul(yieldFarmContract.getEpochStake(address(this), epochId)).div(poolSizeEpoch);

    }

}

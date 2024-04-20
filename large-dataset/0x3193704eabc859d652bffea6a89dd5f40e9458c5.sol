pragma solidity ^0.5.0;


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
     * This test is non-exhaustive, and there may be false-negatives: during the
     * execution of a contract's constructor, its address will be reported as
     * not containing a contract.
     *
     * IMPORTANT: It is unsafe to assume that an address for which this
     * function returns false is an externally-owned account (EOA) and not a
     * contract.
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
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

    event Mint(
        address indexed sender,
        uint amount0,
        uint amount1
    );

    event Burn(
        address indexed sender,
        uint amount0,
        uint amount1,
        address indexed to
    );

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

contract IUniswapV2Router01 {

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

    function swapExactETHForTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    )
    external
    payable
    returns (uint[] memory amounts);

    function swapTokensForExactETH(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    )
    external
    returns (uint[] memory amounts);

    function swapExactTokensForETH(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    )
    external
    returns (uint[] memory amounts);

    function swapETHForExactTokens(
        uint amountOut,
        address[] calldata path,
        address to,
        uint deadline
    )
    external
    payable
    returns (uint[] memory amounts);

    function quote(
        uint amountA,
        uint reserveA,
        uint reserveB
    ) external pure returns (uint amountB);

    function getAmountOut(
        uint amountIn,
        uint reserveIn,
        uint reserveOut
    ) external pure returns (uint amountOut);

    function getAmountIn(
        uint amountOut,
        uint reserveIn,
        uint reserveOut
    ) external pure returns (uint amountIn);

    function getAmountsOut(
        uint amountIn,
        address[]
        calldata path
    ) external view returns (uint[] memory amounts);

    function getAmountsIn(
        uint amountOut,
        address[]
        calldata path
    ) external view returns (uint[] memory amounts);

}

contract IUniswapV2Router02 is IUniswapV2Router01 {

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

library UniswapV2Library {

    using SafeMath for uint;

    // returns sorted token addresses, used to handle return values from pairs sorted in this order
    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
        require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
    }

    // calculates the CREATE2 address for a pair without making any external calls
    function pairFor(address factory, address tokenA, address tokenB, bytes32 initCodeHash) internal pure returns (address pair) {
        (address token0, address token1) = sortTokens(tokenA, tokenB);
        pair = address(uint(keccak256(abi.encodePacked(
                hex'ff',
                factory,
                keccak256(abi.encodePacked(token0, token1)),
                initCodeHash
            //                keccak256(hex'60806040526001600c5534801561001557600080fd5b5060405146908060526123868239604080519182900360520182208282018252600a8352692ab734b9bbb0b8102b1960b11b6020938401528151808301835260018152603160f81b908401528151808401919091527fbfcc8ef98ffbf7b6c3fec7bf5185b566b9863e35a9d83acd49ad6824b5969738818301527fc89efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc6606082015260808101949094523060a0808601919091528151808603909101815260c09094019052825192019190912060035550600580546001600160a01b03191633179055612281806101056000396000f3fe608060405234801561001057600080fd5b50600436106101a95760003560e01c80636a627842116100f9578063ba9a7a5611610097578063d21220a711610071578063d21220a714610534578063d505accf1461053c578063dd62ed3e1461058d578063fff6cae9146105bb576101a9565b8063ba9a7a56146104fe578063bc25cf7714610506578063c45a01551461052c576101a9565b80637ecebe00116100d35780637ecebe001461046557806389afcb441461048b57806395d89b41146104ca578063a9059cbb146104d2576101a9565b80636a6278421461041157806370a08231146104375780637464fc3d1461045d576101a9565b806323b872dd116101665780633644e515116101405780633644e515146103cb578063485cc955146103d35780635909c0d5146104015780635a3d549314610409576101a9565b806323b872dd1461036f57806330adf81f146103a5578063313ce567146103ad576101a9565b8063022c0d9f146101ae57806306fdde031461023c5780630902f1ac146102b9578063095ea7b3146102f15780630dfe16811461033157806318160ddd14610355575b600080fd5b61023a600480360360808110156101c457600080fd5b8135916020810135916001600160a01b0360408301351691908101906080810160608201356401000000008111156101fb57600080fd5b82018360208201111561020d57600080fd5b8035906020019184600183028401116401000000008311171561022f57600080fd5b5090925090506105c3565b005b610244610afe565b6040805160208082528351818301528351919283929083019185019080838360005b8381101561027e578181015183820152602001610266565b50505050905090810190601f1680156102ab5780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b6102c1610b24565b604080516001600160701b03948516815292909316602083015263ffffffff168183015290519081900360600190f35b61031d6004803603604081101561030757600080fd5b506001600160a01b038135169060200135610b4e565b604080519115158252519081900360200190f35b610339610b65565b604080516001600160a01b039092168252519081900360200190f35b61035d610b74565b60408051918252519081900360200190f35b61031d6004803603606081101561038557600080fd5b506001600160a01b03813581169160208101359091169060400135610b7a565b61035d610c14565b6103b5610c38565b6040805160ff9092168252519081900360200190f35b61035d610c3d565b61023a600480360360408110156103e957600080fd5b506001600160a01b0381358116916020013516610c43565b61035d610cc7565b61035d610ccd565b61035d6004803603602081101561042757600080fd5b50356001600160a01b0316610cd3565b61035d6004803603602081101561044d57600080fd5b50356001600160a01b0316610fd3565b61035d610fe5565b61035d6004803603602081101561047b57600080fd5b50356001600160a01b0316610feb565b6104b1600480360360208110156104a157600080fd5b50356001600160a01b0316610ffd565b6040805192835260208301919091528051918290030190f35b6102446113a3565b61031d600480360360408110156104e857600080fd5b506001600160a01b0381351690602001356113c5565b61035d6113d2565b61023a6004803603602081101561051c57600080fd5b50356001600160a01b03166113d8565b610339611543565b610339611552565b61023a600480360360e081101561055257600080fd5b506001600160a01b03813581169160208101359091169060408101359060608101359060ff6080820135169060a08101359060c00135611561565b61035d600480360360408110156105a357600080fd5b506001600160a01b0381358116916020013516611763565b61023a611780565b600c5460011461060e576040805162461bcd60e51b8152602060048201526011602482015270155b9a5cddd85c158c8e881313d0d2d151607a1b604482015290519081900360640190fd5b6000600c55841515806106215750600084115b61065c5760405162461bcd60e51b81526004018080602001828103825260258152602001806121936025913960400191505060405180910390fd5b600080610667610b24565b5091509150816001600160701b03168710801561068c5750806001600160701b031686105b6106c75760405162461bcd60e51b81526004018080602001828103825260218152602001806121dc6021913960400191505060405180910390fd5b60065460075460009182916001600160a01b039182169190811690891682148015906107055750806001600160a01b0316896001600160a01b031614155b61074e576040805162461bcd60e51b8152602060048201526015602482015274556e697377617056323a20494e56414c49445f544f60581b604482015290519081900360640190fd5b8a1561075f5761075f828a8d6118e2565b891561077057610770818a8c6118e2565b861561082b57886001600160a01b03166310d1e85c338d8d8c8c6040518663ffffffff1660e01b815260040180866001600160a01b03166001600160a01b03168152602001858152602001848152602001806020018281038252848482818152602001925080828437600081840152601f19601f8201169050808301925050509650505050505050600060405180830381600087803b15801561081257600080fd5b505af1158015610826573d6000803e3d6000fd5b505050505b604080516370a0823160e01b815230600482015290516001600160a01b038416916370a08231916024808301926020929190829003018186803b15801561087157600080fd5b505afa158015610885573d6000803e3d6000fd5b505050506040513d602081101561089b57600080fd5b5051604080516370a0823160e01b815230600482015290519195506001600160a01b038316916370a0823191602480820192602092909190829003018186803b1580156108e757600080fd5b505afa1580156108fb573d6000803e3d6000fd5b505050506040513d602081101561091157600080fd5b5051925060009150506001600160701b0385168a90038311610934576000610943565b89856001600160701b03160383035b9050600089856001600160701b031603831161096057600061096f565b89856001600160701b03160383035b905060008211806109805750600081115b6109bb5760405162461bcd60e51b81526004018080602001828103825260248152602001806121b86024913960400191505060405180910390fd5b60006109ef6109d184600363ffffffff611a7c16565b6109e3876103e863ffffffff611a7c16565b9063ffffffff611adf16565b90506000610a076109d184600363ffffffff611a7c16565b9050610a38620f4240610a2c6001600160701b038b8116908b1663ffffffff611a7c16565b9063ffffffff611a7c16565b610a48838363ffffffff611a7c16565b1015610a8a576040805162461bcd60e51b815260206004820152600c60248201526b556e697377617056323a204b60a01b604482015290519081900360640190fd5b5050610a9884848888611b2f565b60408051838152602081018390528082018d9052606081018c905290516001600160a01b038b169133917fd78ad95fa46c994b6551d0da85fc275fe613ce37657fb8d5e3d130840159d8229181900360800190a350506001600c55505050505050505050565b6040518060400160405280600a8152602001692ab734b9bbb0b8102b1960b11b81525081565b6008546001600160701b0380821692600160701b830490911691600160e01b900463ffffffff1690565b6000610b5b338484611cf4565b5060015b92915050565b6006546001600160a01b031681565b60005481565b6001600160a01b038316600090815260026020908152604080832033845290915281205460001914610bff576001600160a01b0384166000908152600260209081526040808320338452909152902054610bda908363ffffffff611adf16565b6001600160a01b03851660009081526002602090815260408083203384529091529020555b610c0a848484611d56565b5060019392505050565b7f6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c981565b601281565b60035481565b6005546001600160a01b03163314610c99576040805162461bcd60e51b81526020600482015260146024820152732ab734b9bbb0b82b191d102327a92124a22222a760611b604482015290519081900360640190fd5b600680546001600160a01b039384166001600160a01b03199182161790915560078054929093169116179055565b60095481565b600a5481565b6000600c54600114610d20576040805162461bcd60e51b8152602060048201526011602482015270155b9a5cddd85c158c8e881313d0d2d151607a1b604482015290519081900360640190fd5b6000600c81905580610d30610b24565b50600654604080516370a0823160e01b815230600482015290519395509193506000926001600160a01b03909116916370a08231916024808301926020929190829003018186803b158015610d8457600080fd5b505afa158015610d98573d6000803e3d6000fd5b505050506040513d6020811015610dae57600080fd5b5051600754604080516370a0823160e01b815230600482015290519293506000926001600160a01b03909216916370a0823191602480820192602092909190829003018186803b158015610e0157600080fd5b505afa158015610e15573d6000803e3d6000fd5b505050506040513d6020811015610e2b57600080fd5b505190506000610e4a836001600160701b03871663ffffffff611adf16565b90506000610e67836001600160701b03871663ffffffff611adf16565b90506000610e758787611e10565b60005490915080610eb257610e9e6103e86109e3610e99878763ffffffff611a7c16565b611f6e565b9850610ead60006103e8611fc0565b610f01565b610efe6001600160701b038916610ecf868463ffffffff611a7c16565b81610ed657fe5b046001600160701b038916610ef1868563ffffffff611a7c16565b81610ef857fe5b04612056565b98505b60008911610f405760405162461bcd60e51b81526004018080602001828103825260288152602001806122256028913960400191505060405180910390fd5b610f4a8a8a611fc0565b610f5686868a8a611b2f565b8115610f8657600854610f82906001600160701b0380821691600160701b90041663ffffffff611a7c16565b600b555b6040805185815260208101859052815133927f4c209b5fc8ad50758f13e2e1088ba56a560dff690a1c6fef26394f4c03821c4f928290030190a250506001600c5550949695505050505050565b60016020526000908152604090205481565b600b5481565b60046020526000908152604090205481565b600080600c5460011461104b576040805162461bcd60e51b8152602060048201526011602482015270155b9a5cddd85c158c8e881313d0d2d151607a1b604482015290519081900360640190fd5b6000600c8190558061105b610b24565b50600654600754604080516370a0823160e01b815230600482015290519496509294506001600160a01b039182169391169160009184916370a08231916024808301926020929190829003018186803b1580156110b757600080fd5b505afa1580156110cb573d6000803e3d6000fd5b505050506040513d60208110156110e157600080fd5b5051604080516370a0823160e01b815230600482015290519192506000916001600160a01b038516916370a08231916024808301926020929190829003018186803b15801561112f57600080fd5b505afa158015611143573d6000803e3d6000fd5b505050506040513d602081101561115957600080fd5b5051306000908152600160205260408120549192506111788888611e10565b6000549091508061118f848763ffffffff611a7c16565b8161119657fe5b049a50806111aa848663ffffffff611a7c16565b816111b157fe5b04995060008b1180156111c4575060008a115b6111ff5760405162461bcd60e51b81526004018080602001828103825260288152602001806121fd6028913960400191505060405180910390fd5b611209308461206e565b611214878d8d6118e2565b61121f868d8c6118e2565b604080516370a0823160e01b815230600482015290516001600160a01b038916916370a08231916024808301926020929190829003018186803b15801561126557600080fd5b505afa158015611279573d6000803e3d6000fd5b505050506040513d602081101561128f57600080fd5b5051604080516370a0823160e01b815230600482015290519196506001600160a01b038816916370a0823191602480820192602092909190829003018186803b1580156112db57600080fd5b505afa1580156112ef573d6000803e3d6000fd5b505050506040513d602081101561130557600080fd5b5051935061131585858b8b611b2f565b811561134557600854611341906001600160701b0380821691600160701b90041663ffffffff611a7c16565b600b555b604080518c8152602081018c905281516001600160a01b038f169233927fdccd412f0b1252819cb1fd330b93224ca42612892bb3f4f789976e6d81936496929081900390910190a35050505050505050506001600c81905550915091565b604051806040016040528060068152602001652aa72496ab1960d11b81525081565b6000610b5b338484611d56565b6103e881565b600c54600114611423576040805162461bcd60e51b8152602060048201526011602482015270155b9a5cddd85c158c8e881313d0d2d151607a1b604482015290519081900360640190fd5b6000600c55600654600754600854604080516370a0823160e01b815230600482015290516001600160a01b0394851694909316926114d292859287926114cd926001600160701b03169185916370a0823191602480820192602092909190829003018186803b15801561149557600080fd5b505afa1580156114a9573d6000803e3d6000fd5b505050506040513d60208110156114bf57600080fd5b50519063ffffffff611adf16565b6118e2565b600854604080516370a0823160e01b8152306004820152905161153992849287926114cd92600160701b90046001600160701b0316916001600160a01b038616916370a0823191602480820192602092909190829003018186803b15801561149557600080fd5b50506001600c5550565b6005546001600160a01b031681565b6007546001600160a01b031681565b428410156115ab576040805162461bcd60e51b8152602060048201526012602482015271155b9a5cddd85c158c8e881156141254915160721b604482015290519081900360640190fd5b6003546001600160a01b0380891660008181526004602090815260408083208054600180820190925582517f6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c98186015280840196909652958d166060860152608085018c905260a085019590955260c08085018b90528151808603909101815260e08501825280519083012061190160f01b6101008601526101028501969096526101228085019690965280518085039096018652610142840180825286519683019690962095839052610162840180825286905260ff89166101828501526101a284018890526101c28401879052519193926101e280820193601f1981019281900390910190855afa1580156116c6573d6000803e3d6000fd5b5050604051601f1901519150506001600160a01b038116158015906116fc5750886001600160a01b0316816001600160a01b0316145b61174d576040805162461bcd60e51b815260206004820152601c60248201527f556e697377617056323a20494e56414c49445f5349474e415455524500000000604482015290519081900360640190fd5b611758898989611cf4565b505050505050505050565b600260209081526000928352604080842090915290825290205481565b600c546001146117cb576040805162461bcd60e51b8152602060048201526011602482015270155b9a5cddd85c158c8e881313d0d2d151607a1b604482015290519081900360640190fd5b6000600c55600654604080516370a0823160e01b815230600482015290516118db926001600160a01b0316916370a08231916024808301926020929190829003018186803b15801561181c57600080fd5b505afa158015611830573d6000803e3d6000fd5b505050506040513d602081101561184657600080fd5b5051600754604080516370a0823160e01b815230600482015290516001600160a01b03909216916370a0823191602480820192602092909190829003018186803b15801561189357600080fd5b505afa1580156118a7573d6000803e3d6000fd5b505050506040513d60208110156118bd57600080fd5b50516008546001600160701b0380821691600160701b900416611b2f565b6001600c55565b604080518082018252601981527f7472616e7366657228616464726573732c75696e74323536290000000000000060209182015281516001600160a01b0385811660248301526044808301869052845180840390910181526064909201845291810180516001600160e01b031663a9059cbb60e01b1781529251815160009460609489169392918291908083835b6020831061198f5780518252601f199092019160209182019101611970565b6001836020036101000a0380198251168184511680821785525050505050509050019150506000604051808303816000865af19150503d80600081146119f1576040519150601f19603f3d011682016040523d82523d6000602084013e6119f6565b606091505b5091509150818015611a24575080511580611a245750808060200190516020811015611a2157600080fd5b50515b611a75576040805162461bcd60e51b815260206004820152601a60248201527f556e697377617056323a205452414e534645525f4641494c4544000000000000604482015290519081900360640190fd5b5050505050565b6000811580611a9757505080820282828281611a9457fe5b04145b610b5f576040805162461bcd60e51b815260206004820152601460248201527364732d6d6174682d6d756c2d6f766572666c6f7760601b604482015290519081900360640190fd5b80820382811115610b5f576040805162461bcd60e51b815260206004820152601560248201527464732d6d6174682d7375622d756e646572666c6f7760581b604482015290519081900360640190fd5b6001600160701b038411801590611b4d57506001600160701b038311155b611b94576040805162461bcd60e51b8152602060048201526013602482015272556e697377617056323a204f564552464c4f5760681b604482015290519081900360640190fd5b60085463ffffffff42811691600160e01b90048116820390811615801590611bc457506001600160701b03841615155b8015611bd857506001600160701b03831615155b15611c49578063ffffffff16611c0685611bf18661210c565b6001600160e01b03169063ffffffff61211e16565b600980546001600160e01b03929092169290920201905563ffffffff8116611c3184611bf18761210c565b600a80546001600160e01b0392909216929092020190555b600880546dffffffffffffffffffffffffffff19166001600160701b03888116919091176dffffffffffffffffffffffffffff60701b1916600160701b8883168102919091176001600160e01b0316600160e01b63ffffffff871602179283905560408051848416815291909304909116602082015281517f1c411e9a96e071241c2f21f7726b17ae89e3cab4c78be50e062b03a9fffbbad1929181900390910190a1505050505050565b6001600160a01b03808416600081815260026020908152604080832094871680845294825291829020859055815185815291517f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b9259281900390910190a3505050565b6001600160a01b038316600090815260016020526040902054611d7f908263ffffffff611adf16565b6001600160a01b038085166000908152600160205260408082209390935590841681522054611db4908263ffffffff61214316565b6001600160a01b0380841660008181526001602090815260409182902094909455805185815290519193928716927fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef92918290030190a3505050565b600080600560009054906101000a90046001600160a01b03166001600160a01b031663017e7e586040518163ffffffff1660e01b815260040160206040518083038186803b158015611e6157600080fd5b505afa158015611e75573d6000803e3d6000fd5b505050506040513d6020811015611e8b57600080fd5b5051600b546001600160a01b038216158015945091925090611f5a578015611f55576000611ece610e996001600160701b0388811690881663ffffffff611a7c16565b90506000611edb83611f6e565b905080821115611f52576000611f09611efa848463ffffffff611adf16565b6000549063ffffffff611a7c16565b90506000611f2e83611f2286600563ffffffff611a7c16565b9063ffffffff61214316565b90506000818381611f3b57fe5b0490508015611f4e57611f4e8782611fc0565b5050505b50505b611f66565b8015611f66576000600b555b505092915050565b60006003821115611fb1575080600160028204015b81811015611fab57809150600281828581611f9a57fe5b040181611fa357fe5b049050611f83565b50611fbb565b8115611fbb575060015b919050565b600054611fd3908263ffffffff61214316565b60009081556001600160a01b038316815260016020526040902054611ffe908263ffffffff61214316565b6001600160a01b03831660008181526001602090815260408083209490945583518581529351929391927fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef9281900390910190a35050565b60008183106120655781612067565b825b9392505050565b6001600160a01b038216600090815260016020526040902054612097908263ffffffff611adf16565b6001600160a01b038316600090815260016020526040812091909155546120c4908263ffffffff611adf16565b60009081556040805183815290516001600160a01b038516917fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef919081900360200190a35050565b6001600160701b0316600160701b0290565b60006001600160701b0382166001600160e01b0384168161213b57fe5b049392505050565b80820182811015610b5f576040805162461bcd60e51b815260206004820152601460248201527364732d6d6174682d6164642d6f766572666c6f7760601b604482015290519081900360640190fdfe556e697377617056323a20494e53554646494349454e545f4f55545055545f414d4f554e54556e697377617056323a20494e53554646494349454e545f494e5055545f414d4f554e54556e697377617056323a20494e53554646494349454e545f4c4951554944495459556e697377617056323a20494e53554646494349454e545f4c49515549444954595f4255524e4544556e697377617056323a20494e53554646494349454e545f4c49515549444954595f4d494e544544a265627a7a7231582082fba8557d35ae5eca98219a61e967d398ed8eaafeafa5fe5af73dd6aad9ddfd64736f6c63430005100032454950373132446f6d61696e28737472696e67206e616d652c737472696e672076657273696f6e2c75696e7432353620636861696e49642c6164647265737320766572696679696e67436f6e747261637429') // init code hash
            //                hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash; not needed
            ))));
    }

    // fetches and sorts the reserves for a pair
    function getReserves(address factory, address tokenA, address tokenB, bytes32 initCodeHash) internal view returns (uint reserveA, uint reserveB) {
        (address token0,) = sortTokens(tokenA, tokenB);
        (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB, initCodeHash)).getReserves();
        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
    }

    // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
    function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
        require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
        require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
        amountB = amountA.mul(reserveB) / reserveA;
    }

    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
    function getAmountOut(
        uint amountIn,
        uint reserveIn,
        uint reserveOut
    ) internal pure returns (uint amountOut) {
        require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
        uint amountInWithFee = amountIn.mul(997);
        uint numerator = amountInWithFee.mul(reserveOut);
        uint denominator = reserveIn.mul(1000).add(amountInWithFee);
        amountOut = numerator / denominator;
    }

    // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
    function getAmountIn(
        uint amountOut,
        uint reserveIn,
        uint reserveOut
    ) internal pure returns (uint amountIn) {
        require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
        uint numerator = reserveIn.mul(amountOut).mul(1000);
        uint denominator = reserveOut.sub(amountOut).mul(997);
        amountIn = (numerator / denominator).add(1);
    }

    // performs chained getAmountOut calculations on any number of pairs
    function getAmountsOut(
        address factory,
        uint amountIn,
        address[] memory path,
        bytes32 initCodeHash
    ) internal view returns (uint[] memory amounts) {
        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
        amounts = new uint[](path.length);
        amounts[0] = amountIn;
        for (uint i; i < path.length - 1; i++) {
            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1], initCodeHash);
            amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
        }
    }

    // performs chained getAmountIn calculations on any number of pairs
    function getAmountsIn(
        address factory,
        uint amountOut,
        address[] memory path,
        bytes32 initCodeHash
    ) internal view returns (uint[] memory amounts) {
        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
        amounts = new uint[](path.length);
        amounts[amounts.length - 1] = amountOut;
        for (uint i = path.length - 1; i > 0; i--) {
            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i], initCodeHash);
            amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
        }
    }
}

/*
 * Copyright 2020 DMM Foundation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
interface IDMGToken {

    /// @notice A checkpoint for marking number of votes from a given block
    struct Checkpoint {
        uint64 fromBlock;
        uint128 votes;
    }

    /// @notice An event thats emitted when an account changes its delegate
    event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);

    /// @notice An event thats emitted when a delegate account's vote balance changes
    event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);

    function getPriorVotes(address account, uint blockNumber) external view returns (uint128);

    function delegates(address delegator) external view returns (address);

    function burn(uint amount) external returns (bool);

}

/*
 * Copyright 2020 DMM Foundation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
interface InterestRateInterface {

    /**
      * @dev Returns the current interest rate for the given DMMA and corresponding total supply & active supply
      *
      * @param dmmTokenId The DMMA whose interest should be retrieved
      * @param totalSupply The total supply fot he DMM token
      * @param activeSupply The supply that's currently being lent by users
      * @return The interest rate in APY, which is a number with 18 decimals
      */
    function getInterestRate(uint dmmTokenId, uint totalSupply, uint activeSupply) external view returns (uint);

}

/*
 * Copyright 2020 DMM Foundation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
interface IUnderlyingTokenValuator {

    /**
      * @dev Gets the tokens value in terms of USD.
      *
      * @return The value of the `amount` of `token`, as a number with the same number of decimals as `amount` passed
      *         in to this function.
      */
    function getTokenValue(address token, uint amount) external view returns (uint);

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
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
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
        _owner = _msgSender();
        emit OwnershipTransferred(address(0), _owner);
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
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

/*
 * Copyright 2020 DMM Foundation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/**
 * @dev Allows accounts to be blacklisted by the owner of the contract.
 *
 *  Taken from USDC's contract for blacklisting certain addresses from owning and interacting with the token.
 */
contract Blacklistable is Ownable {

    string public constant BLACKLISTED = "BLACKLISTED";

    mapping(address => bool) internal blacklisted;

    event Blacklisted(address indexed account);
    event UnBlacklisted(address indexed account);
    event BlacklisterChanged(address indexed newBlacklister);

    /**
     * @dev Throws if called by any account other than the creator of this contract
    */
    modifier onlyBlacklister() {
        require(msg.sender == owner(), "MUST_BE_BLACKLISTER");
        _;
    }

    /**
     * @dev Throws if `account` is blacklisted
     *
     * @param account The address to check
    */
    modifier notBlacklisted(address account) {
        require(blacklisted[account] == false, BLACKLISTED);
        _;
    }

    /**
     * @dev Checks if `account` is blacklisted. Reverts with `BLACKLISTED` if blacklisted.
    */
    function checkNotBlacklisted(address account) public view {
        require(!blacklisted[account], BLACKLISTED);
    }

    /**
     * @dev Checks if `account` is blacklisted
     *
     * @param account The address to check
    */
    function isBlacklisted(address account) public view returns (bool) {
        return blacklisted[account];
    }

    /**
     * @dev Adds `account` to blacklist
     *
     * @param account The address to blacklist
    */
    function blacklist(address account) public onlyBlacklister {
        blacklisted[account] = true;
        emit Blacklisted(account);
    }

    /**
     * @dev Removes account from blacklist
     *
     * @param account The address to remove from the blacklist
    */
    function unBlacklist(address account) public onlyBlacklister {
        blacklisted[account] = false;
        emit UnBlacklisted(account);
    }

}

interface IDmmController {

    event TotalSupplyIncreased(uint oldTotalSupply, uint newTotalSupply);
    event TotalSupplyDecreased(uint oldTotalSupply, uint newTotalSupply);

    event AdminDeposit(address indexed sender, uint amount);
    event AdminWithdraw(address indexed receiver, uint amount);

    /**
     * @dev Creates a new mToken using the provided data.
     *
     * @param underlyingToken   The token that should be wrapped to create a new DMMA
     * @param symbol            The symbol of the new DMMA, IE mDAI or mUSDC
     * @param name              The name of this token, IE `DMM: DAI`
     * @param decimals          The number of decimals of the underlying token, and therefore the number for this DMMA
     * @param minMintAmount     The minimum amount that can be minted for any given transaction.
     * @param minRedeemAmount   The minimum amount that can be redeemed any given transaction.
     * @param totalSupply       The initial total supply for this market.
     */
    function addMarket(
        address underlyingToken,
        string calldata symbol,
        string calldata name,
        uint8 decimals,
        uint minMintAmount,
        uint minRedeemAmount,
        uint totalSupply
    ) external;

    /**
     * @dev Creates a new mToken using the already-existing token.
     *
     * @param dmmToken          The token that should be added to this controller.
     * @param underlyingToken   The token that should be wrapped to create a new DMMA.
     */
    function addMarketFromExistingDmmToken(
        address dmmToken,
        address underlyingToken
    ) external;

    /**
     * @param newController The new controller who should receive ownership of the provided DMM token IDs.
     */
    function transferOwnershipToNewController(
        address newController
    ) external;

    /**
     * @dev Enables the corresponding DMMA to allow minting new tokens.
     *
     * @param dmmTokenId  The DMMA that should be enabled.
     */
    function enableMarket(uint dmmTokenId) external;

    /**
     * @dev Disables the corresponding DMMA from minting new tokens. This allows the market to close over time, since
     *      users are only able to redeem tokens.
     *
     * @param dmmTokenId  The DMMA that should be disabled.
     */
    function disableMarket(uint dmmTokenId) external;

    /**
     * @dev Sets the new address that will serve as the guardian for this controller.
     *
     * @param newGuardian   The new address that will serve as the guardian for this controller.
     */
    function setGuardian(address newGuardian) external;

    /**
     * @dev Sets a new contract that implements the `DmmTokenFactory` interface.
     *
     * @param newDmmTokenFactory  The new contract that implements the `DmmTokenFactory` interface.
     */
    function setDmmTokenFactory(address newDmmTokenFactory) external;

    /**
     * @dev Sets a new contract that implements the `DmmEtherFactory` interface.
     *
     * @param newDmmEtherFactory  The new contract that implements the `DmmEtherFactory` interface.
     */
    function setDmmEtherFactory(address newDmmEtherFactory) external;

    /**
     * @dev Sets a new contract that implements the `InterestRate` interface.
     *
     * @param newInterestRateInterface  The new contract that implements the `InterestRateInterface` interface.
     */
    function setInterestRateInterface(address newInterestRateInterface) external;

    /**
     * @dev Sets a new contract that implements the `IOffChainAssetValuator` interface.
     *
     * @param newOffChainAssetValuator The new contract that implements the `IOffChainAssetValuator` interface.
     */
    function setOffChainAssetValuator(address newOffChainAssetValuator) external;

    /**
     * @dev Sets a new contract that implements the `IOffChainAssetValuator` interface.
     *
     * @param newOffChainCurrencyValuator The new contract that implements the `IOffChainAssetValuator` interface.
     */
    function setOffChainCurrencyValuator(address newOffChainCurrencyValuator) external;

    /**
     * @dev Sets a new contract that implements the `UnderlyingTokenValuator` interface
     *
     * @param newUnderlyingTokenValuator The new contract that implements the `UnderlyingTokenValuator` interface
     */
    function setUnderlyingTokenValuator(address newUnderlyingTokenValuator) external;

    /**
     * @dev Allows the owners of the DMM Ecosystem to withdraw funds from a DMMA. These withdrawn funds are then
     *      allocated to real-world assets that will be used to pay interest into the DMMA.
     *
     * @param newMinCollateralization   The new min collateralization (with 18 decimals) at which the DMME must be in
     *                                  order to add to the total supply of DMM.
     */
    function setMinCollateralization(uint newMinCollateralization) external;

    /**
     * @dev Allows the owners of the DMM Ecosystem to withdraw funds from a DMMA. These withdrawn funds are then
     *      allocated to real-world assets that will be used to pay interest into the DMMA.
     *
     * @param newMinReserveRatio   The new ratio (with 18 decimals) that is used to enforce a certain percentage of assets
     *                          are kept in each DMMA.
     */
    function setMinReserveRatio(uint newMinReserveRatio) external;

    /**
     * @dev Increases the max supply for the provided `dmmTokenId` by `amount`. This call reverts with
     *      INSUFFICIENT_COLLATERAL if there isn't enough collateral in the Chainlink contract to cover the controller's
     *      requirements for minimum collateral.
     */
    function increaseTotalSupply(uint dmmTokenId, uint amount) external;

    /**
     * @dev Increases the max supply for the provided `dmmTokenId` by `amount`.
     */
    function decreaseTotalSupply(uint dmmTokenId, uint amount) external;

    /**
     * @dev Allows the owners of the DMM Ecosystem to withdraw funds from a DMMA. These withdrawn funds are then
     *      allocated to real-world assets that will be used to pay interest into the DMMA.
     *
     * @param dmmTokenId        The ID of the DMM token whose underlying will be funded.
     * @param underlyingAmount  The amount underlying the DMM token that will be deposited into the DMMA.
     */
    function adminWithdrawFunds(uint dmmTokenId, uint underlyingAmount) external;

    /**
     * @dev Allows the owners of the DMM Ecosystem to deposit funds into a DMMA. These funds are used to disburse
     *      interest payments and add more liquidity to the specific market.
     *
     * @param dmmTokenId        The ID of the DMM token whose underlying will be funded.
     * @param underlyingAmount  The amount underlying the DMM token that will be deposited into the DMMA.
     */
    function adminDepositFunds(uint dmmTokenId, uint underlyingAmount) external;

    /**
     * @return  All of the DMM token IDs that are currently in the ecosystem. NOTE: this is an unfiltered list.
     */
    function getDmmTokenIds() external view returns (uint[] memory);

    /**
     * @dev Gets the collateralization of the system assuming 1-year's worth of interest payments are due by dividing
     *      the total value of all the collateralized assets plus the value of the underlying tokens in each DMMA by the
     *      aggregate interest owed (plus the principal), assuming each DMMA was at maximum usage.
     *
     * @return  The 1-year collateralization of the system, as a number with 18 decimals. For example
     *          `1010000000000000000` is 101% or 1.01.
     */
    function getTotalCollateralization() external view returns (uint);

    /**
     * @dev Gets the current collateralization of the system assuming by dividing the total value of all the
     *      collateralized assets plus the value of the underlying tokens in each DMMA by the aggregate interest owed
     *      (plus the principal), using the current usage of each DMMA.
     *
     * @return  The active collateralization of the system, as a number with 18 decimals. For example
     *          `1010000000000000000` is 101% or 1.01.
     */
    function getActiveCollateralization() external view returns (uint);

    /**
     * @dev Gets the interest rate from the underlying token, IE DAI or USDC.
     *
     * @return  The current interest rate, represented using 18 decimals. Meaning `65000000000000000` is 6.5% APY or
     *          0.065.
     */
    function getInterestRateByUnderlyingTokenAddress(address underlyingToken) external view returns (uint);

    /**
     * @dev Gets the interest rate from the DMM token, IE DMM: DAI or DMM: USDC.
     *
     * @return  The current interest rate, represented using 18 decimals. Meaning, `65000000000000000` is 6.5% APY or
     *          0.065.
     */
    function getInterestRateByDmmTokenId(uint dmmTokenId) external view returns (uint);

    /**
     * @dev Gets the interest rate from the DMM token, IE DMM: DAI or DMM: USDC.
     *
     * @return  The current interest rate, represented using 18 decimals. Meaning, `65000000000000000` is 6.5% APY or
     *          0.065.
     */
    function getInterestRateByDmmTokenAddress(address dmmToken) external view returns (uint);

    /**
     * @dev Gets the exchange rate from the underlying to the DMM token, such that
     *      `DMM: Token = underlying / exchangeRate`
     *
     * @return  The current exchange rate, represented using 18 decimals. Meaning, `200000000000000000` is 0.2.
     */
    function getExchangeRateByUnderlying(address underlyingToken) external view returns (uint);

    /**
     * @dev Gets the exchange rate from the underlying to the DMM token, such that
     *      `DMM: Token = underlying / exchangeRate`
     *
     * @return  The current exchange rate, represented using 18 decimals. Meaning, `200000000000000000` is 0.2.
     */
    function getExchangeRate(address dmmToken) external view returns (uint);

    /**
     * @dev Gets the DMM token for the provided underlying token. For example, sending DAI returns DMM: DAI.
     */
    function getDmmTokenForUnderlying(address underlyingToken) external view returns (address);

    /**
     * @dev Gets the underlying token for the provided DMM token. For example, sending DMM: DAI returns DAI.
     */
    function getUnderlyingTokenForDmm(address dmmToken) external view returns (address);

    /**
     * @return True if the market is enabled for this DMMA or false if it is not enabled.
     */
    function isMarketEnabledByDmmTokenId(uint dmmTokenId) external view returns (bool);

    /**
     * @return True if the market is enabled for this DMM token (IE DMM: DAI) or false if it is not enabled.
     */
    function isMarketEnabledByDmmTokenAddress(address dmmToken) external view returns (bool);

    /**
     * @return True if the market is enabled for this underlying token (IE DAI) or false if it is not enabled.
     */
    function getTokenIdFromDmmTokenAddress(address dmmTokenAddress) external view returns (uint);

    /**
     * @dev Gets the DMM token contract address for the provided DMM token ID. For example, `1` returns the mToken
     *      contract address for that token ID.
     */
    function getDmmTokenAddressByDmmTokenId(uint dmmTokenId) external view returns (address);

    function blacklistable() external view returns (Blacklistable);

    function underlyingTokenValuator() external view returns (IUnderlyingTokenValuator);

}

/*
 * Copyright 2020 DMM Foundation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/**
 * The interface for DMG "Yield Farming" - A process through which users may earn DMG by locking up their mTokens in
 * Uniswap pools, and staking the Uniswap pool's equity token in this contract.
 *
 * Yield farming in the DMM Ecosystem entails "rotation periods" in which a season is active, in order to incentivize
 * deposits of underlying tokens into the protocol.
 */
interface IDMGYieldFarmingV1 {

    // ////////////////////
    // Admin Events
    // ////////////////////

    event GlobalProxySet(address indexed proxy, bool isTrusted);

    event TokenAdded(address indexed token, address indexed underlyingToken, uint8 underlyingTokenDecimals, uint16 points);
    event TokenRemoved(address indexed token);

    event FarmSeasonBegun(uint indexed seasonIndex, uint dmgAmount);
    event FarmSeasonEnd(uint indexed seasonIndex, address dustRecipient, uint dustyDmgAmount);

    event DmgGrowthCoefficientSet(uint coefficient);
    event RewardPointsSet(address indexed token, uint16 points);

    // ////////////////////
    // User Events
    // ////////////////////

    event Approval(address indexed user, address indexed spender, bool isTrusted);

    event BeginFarming(address indexed owner, address indexed token, uint depositedAmount);
    event EndFarming(address indexed owner, address indexed token, uint withdrawnAmount, uint earnedDmgAmount);

    event WithdrawOutOfSeason(address indexed owner, address indexed token, address indexed recipient, uint amount);

    // ////////////////////
    // Admin Functions
    // ////////////////////

    /**
     * Sets the `proxy` as a trusted contract, allowing it to interact with the user, on the user's behalf.
     *
     * @param proxy     The address that can interact on the user's behalf.
     * @param isTrusted True if the proxy is trusted or false if it's not (should be removed).
     */
    function approveGloballyTrustedProxy(address proxy, bool isTrusted) external;

    /**
     * @return  true if the provided `proxy` is globally trusted and may interact with the yield farming contract on a
     *          user's behalf or false otherwise.
     */
    function isGloballyTrustedProxy(address proxy) external view returns (bool);

    /**
     * @param token                     The address of the token to be supported for farming.
     * @param underlyingToken           The token to which this token is pegged. IE a Uniswap-V2 LP equity token for
     *                                  DAI-mDAI has an underlying token of DAI.
     * @param underlyingTokenDecimals   The number of decimals that the `underlyingToken` has.
     * @param points                    The amount of reward points for the provided token.
     */
    function addAllowableToken(address token, address underlyingToken, uint8 underlyingTokenDecimals, uint16 points) external;

    /**
     * @param token     The address of the token that will be removed from farming.
     */
    function removeAllowableToken(address token) external;

    /**
     * Changes the reward points for the provided token. Reward points are a weighting system that enables certain
     * tokens to accrue DMG faster than others, allowing the protocol to prioritize certain deposits.
     */
    function setRewardPointsByToken(address token, uint16 points) external;

    /**
     * Sets the DMG growth coefficient to use the new parameter provided. This variable is used to define how much
     * DMG is earned every second, for each point accrued.
     */
    function setDmgGrowthCoefficient(uint dmgGrowthCoefficient) external;

    /**
     * Begins the farming process so users that accumulate DMG by locking tokens can start for this rotation. Calling
     * this function increments the currentSeasonIndex, starting a new season. This function reverts if there is
     * already an active season.
     *
     * @param dmgAmount The amount of DMG that will be used to fund this campaign.
     */
    function beginFarmingSeason(uint dmgAmount) external;

    /**
     * Ends the active farming process if the admin calls this function. Otherwise, anyone may call this function once
     * all DMG have been drained from the contract.
     *
     * @param dustRecipient The recipient of any leftover DMG in this contract, when the campaign finishes.
     */
    function endActiveFarmingSeason(address dustRecipient) external;

    // ////////////////////
    // Misc Functions
    // ////////////////////

    /**
     * @return  The tokens that the farm supports.
     */
    function getFarmTokens() external view returns (address[] memory);

    /**
     * @return  True if the provided token is supported for farming, or false if it's not.
     */
    function isSupportedToken(address token) external view returns (bool);

    /**
     * @return  True if there is an active season for farming, or false if there isn't one.
     */
    function isFarmActive() external view returns (bool);

    /**
     * The address that acts as a "secondary" owner with quicker access to function calling than the owner. Typically,
     * this is the DMMF.
     */
    function guardian() external view returns (address);

    /**
     * @return The DMG token.
     */
    function dmgToken() external view returns (address);

    /**
     * @return  The growth coefficient for earning DMG while farming. Each unit represents how much DMG is earned per
     *          point
     */
    function dmgGrowthCoefficient() external view returns (uint);

    /**
     * @return  The amount of points that the provided token earns for each unit of token deposited. Defaults to `1`
     *          if the provided `token` does not exist or does not have a special weight. This number is `2` decimals.
     */
    function getRewardPointsByToken(address token) external view returns (uint16);

    /**
     * @return  The number of decimals that the underlying token has.
     */
    function getTokenDecimalsByToken(address token) external view returns (uint8);

    /**
     * @return  The index into the array returned from `getFarmTokens`, plus 1. 0 if the token isn't found. If the
     *          index returned is non-zero, subtract 1 from it to get the real index into the array.
     */
    function getTokenIndexPlusOneByToken(address token) external view returns (uint);

    // ////////////////////
    // User Functions
    // ////////////////////

    /**
     * Approves the spender from `msg.sender` to transfer funds into the contract on the user's behalf. If `isTrusted`
     * is marked as false, removes the spender.
     */
    function approve(address spender, bool isTrusted) external;

    /**
     * True if the `spender` can transfer tokens on the user's behalf to this contract.
     */
    function isApproved(address user, address spender) external view returns (bool);

    /**
     * Begins a farm by transferring `amount` of `token` from `user` to this contract and adds it to the balance of
     * `user`. `user` must be either 1) msg.sender or 2) a wallet who has approved msg.sender as a proxy; else this
     * function reverts. `funder` must be either 1) msg.sender or `user`; else this function reverts.
     */
    function beginFarming(address user, address funder, address token, uint amount) external;

    /**
     * Ends a farm by transferring all of `token` deposited by `from` to `recipient`, from this contract, as well as
     * all earned DMG for farming `token` to `recipient`. `from` must be either 1) msg.sender or 2) an approved
     * proxy; else this function reverts.
     *
     * @return  The amount of `token` withdrawn and the amount of DMG earned for farming. Both values are sent to
     *          `recipient`.
     */
    function endFarmingByToken(address from, address recipient, address token) external returns (uint, uint);

    /**
     * Withdraws all of `msg.sender`'s tokens from the farm to `recipient`. This function reverts if there is an active
     * farm. `user` must be either 1) msg.sender or 2) an approved proxy; else this function reverts.
     */
    function withdrawAllWhenOutOfSeason(address user, address recipient) external;

    /**
     * Withdraws all of `user` `token` from the farm to `recipient`. This function reverts if there is an active farm and the token is NOT removed.
     * `user` must be either 1) msg.sender or 2) an approved proxy; else this function reverts.
     *
     * @return The amount of tokens sent to `recipient`
     */
    function withdrawByTokenWhenOutOfSeason(
        address user,
        address recipient,
        address token
    ) external returns (uint);

    /**
     * @return  The amount of DMG that this owner has earned in the active farm. If there are no active season, this
     *          function returns `0`.
     */
    function getRewardBalanceByOwner(address owner) external view returns (uint);

    /**
     * @return  The amount of DMG that this owner has earned in the active farm for the provided token. If there is no
     *          active season, this function returns `0`.
     */
    function getRewardBalanceByOwnerAndToken(address owner, address token) external view returns (uint);

    /**
     * @return  The amount of `token` that this owner has deposited into this contract. The user may withdraw this
     *          non-zero balance by invoking `endFarming` or `endFarmingByToken` if there is an active farm. If there is
     *          NO active farm, the user may withdraw his/her funds by invoking
     */
    function balanceOf(address owner, address token) external view returns (uint);

    /**
     * @return  The most recent timestamp at which the `owner` deposited `token` into the yield farming contract for
     *          the current season. If there is no active season, this function returns `0`.
     */
    function getMostRecentDepositTimestampByOwnerAndToken(address owner, address token) external view returns (uint64);

    /**
     * @return  The most recent indexed amount of DMG earned by the `owner` for the deposited `token` which is being
     *          farmed for the most-recent season. If there is no active season, this function returns `0`.
     */
    function getMostRecentIndexedDmgEarnedByOwnerAndToken(address owner, address token) external view returns (uint);

}

/*
 * Copyright 2020 DMM Foundation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
interface IDMGYieldFarmingV1Initializable {

    function initialize(
        address dmgToken,
        address guardian,
        address dmmController,
        uint dmgGrowthCoefficient,
        address[] calldata allowableTokens,
        address[] calldata underlyingTokens,
        uint8[] calldata tokenDecimals,
        uint16[] calldata points
    ) external;

}

/*
 * Copyright 2020 DMM Foundation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
library DMGYieldFarmingV2Lib {

    // ////////////////////
    // Enums
    // ////////////////////

    enum TokenType {
        Unknown,
        UniswapLpToken
    }

}

/*
 * Copyright 2020 DMM Foundation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
contract DMGYieldFarmingData is Initializable {

    // /////////////////////////
    // BEGIN V1 State Variables
    // /////////////////////////

    // counter to allow mutex lock with only one SSTORE operation
    uint256 private _guardCounter;
    address internal _owner;

    address internal _dmgToken;
    address internal _guardian;
    address internal _dmmController;
    address[] internal _supportedFarmTokens;
    /// @notice How much DMG is earned every second of farming. This number is represented as a fraction with 18
    //          decimal places, whereby 0.01 == 1000000000000000.
    uint internal _dmgGrowthCoefficient;

    bool internal _isFarmActive;
    uint internal _seasonIndex;
    mapping(address => uint16) internal _tokenToRewardPointMap;
    mapping(address => mapping(address => bool)) internal _userToSpenderToIsApprovedMap;
    mapping(uint => mapping(address => mapping(address => uint))) internal _seasonIndexToUserToTokenToEarnedDmgAmountMap;
    mapping(uint => mapping(address => mapping(address => uint64))) internal _seasonIndexToUserToTokenToDepositTimestampMap;
    mapping(address => address) internal _tokenToUnderlyingTokenMap;
    mapping(address => uint8) internal _tokenToDecimalsMap;
    mapping(address => uint) internal _tokenToIndexPlusOneMap;
    mapping(address => mapping(address => uint)) internal _addressToTokenToBalanceMap;
    mapping(address => bool) internal _globalProxyToIsTrustedMap;

    // /////////////////////////
    // BEGIN V2 State Variables
    // /////////////////////////

    address internal _underlyingTokenValuator;
    address internal _uniswapV2Router;
    address internal _weth;
    mapping(address => DMGYieldFarmingV2Lib.TokenType) internal _tokenToTokenType;
    mapping(address => uint16) internal _tokenToFeeAmountMap;
    bool internal _isDmgBalanceInitialized;

    // /////////////////////////
    // END State Variables
    // /////////////////////////

    // /////////////////////////
    // Events
    // /////////////////////////

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // /////////////////////////
    // Functions
    // /////////////////////////

    function initialize(address owner) public initializer {
        // The counter starts at one to prevent changing it from zero to a non-zero
        // value, which is a more expensive operation.
        _guardCounter = 1;

        _owner = owner;
        emit OwnershipTransferred(address(0), owner);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "DMGYieldFarmingData::transferOwnership: INVALID_OWNER");

        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    // /////////////////////////
    // Modifiers
    // /////////////////////////

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "DMGYieldFarmingData: NOT_OWNER");
        _;
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
        require(localCounter == _guardCounter, "DMGYieldFarmingData: REENTRANCY");
    }

    // /////////////////////////
    // Constants
    // /////////////////////////

    uint8 public constant POINTS_DECIMALS = 2;

    uint16 public constant POINTS_FACTOR = 10 ** uint16(POINTS_DECIMALS);

    uint8 public constant DMG_GROWTH_COEFFICIENT_DECIMALS = 18;

    uint public constant DMG_GROWTH_COEFFICIENT_FACTOR = 10 ** uint(DMG_GROWTH_COEFFICIENT_DECIMALS);

    uint8 public constant USD_VALUE_DECIMALS = 18;

    uint public constant USD_VALUE_FACTOR = 10 ** uint(USD_VALUE_DECIMALS);

    uint8 public constant FEE_AMOUNT_DECIMALS = 4;

    uint16 public constant FEE_AMOUNT_FACTOR = 10 ** uint16(FEE_AMOUNT_DECIMALS);

}

/*
 * Copyright 2020 DMM Foundation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
interface IDMGYieldFarmingV2 {

    // ////////////////////
    // Admin Events
    // ////////////////////

    event GlobalProxySet(address indexed proxy, bool isTrusted);

    event TokenAdded(address indexed token, address indexed underlyingToken, uint8 underlyingTokenDecimals, uint16 points, uint16 fees);
    event TokenRemoved(address indexed token);

    event FarmSeasonBegun(uint indexed seasonIndex, uint dmgAmount);
    event FarmSeasonEnd(uint indexed seasonIndex, address dustRecipient, uint dustyDmgAmount);

    event DmgGrowthCoefficientSet(uint coefficient);
    event RewardPointsSet(address indexed token, uint16 points);

    event UnderlyingTokenValuatorChanged(address newUnderlyingTokenValutor, address oldUnderlyingTokenValutor);
    event UniswapV2RouterChanged(address newUniswapV2Router, address oldUniswapV2Router);
    event FeesChanged(address indexed token, uint16 feeAmount);
    event TokenTypeChanged(address indexed token, DMGYieldFarmingV2Lib.TokenType tokenType);

    // ////////////////////
    // User Events
    // ////////////////////

    event Approval(address indexed user, address indexed spender, bool isTrusted);

    event BeginFarming(address indexed owner, address indexed token, uint depositedAmount);
    event EndFarming(address indexed owner, address indexed token, uint withdrawnAmount, uint earnedDmgAmount);

    event WithdrawOutOfSeason(address indexed owner, address indexed token, address indexed recipient, uint amount);

    event Harvest(address indexed owner, address indexed token, uint earnedDmgAmount);

    /**
     * @param tokenAmountToConvert  The amount of `token` to be converted to DMG and burned.
     * @param dmgAmountBurned       The amount of DMG burned after `tokenAmountToConvert` was converted to DMG.
     */
    event HarvestFeePaid(address indexed owner, address indexed token, uint tokenAmountToConvert, uint dmgAmountBurned);

    // ////////////////////
    // Admin Functions
    // ////////////////////

    /**
     * Sets the `proxy` as a trusted contract, allowing it to interact with the user, on the user's behalf.
     *
     * @param proxy     The address that can interact on the user's behalf.
     * @param isTrusted True if the proxy is trusted or false if it's not (should be removed).
     */
    function approveGloballyTrustedProxy(
        address proxy,
        bool isTrusted
    ) external;

    /**
     * @return  true if the provided `proxy` is globally trusted and may interact with the yield farming contract on a
     *          user's behalf or false otherwise.
     */
    function isGloballyTrustedProxy(
        address proxy
    ) external view returns (bool);

    /**
     * @param token                     The address of the token to be supported for farming.
     * @param underlyingToken           The token to which this token is pegged. IE a Uniswap-V2 LP equity token for
     *                                  DAI-mDAI has an underlying token of DAI.
     * @param underlyingTokenDecimals   The number of decimals that the `underlyingToken` has.
     * @param points                    The amount of reward points for the provided token.
     * @param fees                      The fees to be paid in `underlyingToken` when the user performs a harvest.
     * @param tokenType                 The type of token that is being added. Used for unwrapping it and paying harvest
      *                                 fees.
     */
    function addAllowableToken(
        address token,
        address underlyingToken,
        uint8 underlyingTokenDecimals,
        uint16 points,
        uint16 fees,
        DMGYieldFarmingV2Lib.TokenType tokenType
    ) external;

    /**
     * @param token The address of the token that will be removed from farming.
     */
    function removeAllowableToken(
        address token
    ) external;

    /**
     * Changes the reward points for the provided tokens. Reward points are a weighting system that enables certain
     * tokens to accrue DMG faster than others, allowing the protocol to prioritize certain deposits. At the start of
     * season 1, mETH had points of 100 (equalling 1) and the stablecoins had 200, doubling their weight against mETH.
     */
    function setRewardPointsByTokens(
        address[] calldata tokens,
        uint16[] calldata points
    ) external;

    /**
     * Sets the DMG growth coefficient to use the new parameter provided. This variable is used to define how much
     * DMG is earned every second, for each dollar being farmed accrued.
     */
    function setDmgGrowthCoefficient(
        uint dmgGrowthCoefficient
    ) external;

    /**
     * Begins the farming process so users that accumulate DMG by locking tokens can start for this rotation. Calling
     * this function increments the currentSeasonIndex, starting a new season. This function reverts if there is
     * already an active season.
     *
     * @param dmgAmount The amount of DMG that will be used to fund this campaign.
     */
    function beginFarmingSeason(
        uint dmgAmount
    ) external;

    /**
     * Ends the active farming process if the admin calls this function. Otherwise, anyone may call this function once
     * all DMG have been drained from the contract.
     *
     * @param dustRecipient The recipient of any leftover DMG in this contract, when the campaign finishes.
     */
    function endActiveFarmingSeason(
        address dustRecipient
    ) external;

    function setUnderlyingTokenValuator(
        address underlyingTokenValuator
    ) external;

    function setWethToken(
        address weth
    ) external;

    function setUniswapV2Router(
        address uniswapV2Router
    ) external;

    function setFeesByTokens(
        address[] calldata tokens,
        uint16[] calldata fees
    ) external;

    function setTokenTypeByToken(
        address token,
        DMGYieldFarmingV2Lib.TokenType tokenType
    ) external;

    /**
     * Used to initialize the protocol, mid-season since the Protocol kept track of DMG balances differently on v1.
     */
    function initializeDmgBalance() external;

    // ////////////////////
    // User Functions
    // ////////////////////

    /**
     * Approves the spender from `msg.sender` to transfer funds into the contract on the user's behalf. If `isTrusted`
     * is marked as false, removes the spender.
     */
    function approve(address spender, bool isTrusted) external;

    /**
     * True if the `spender` can transfer tokens on the user's behalf to this contract.
     */
    function isApproved(
        address user,
        address spender
    ) external view returns (bool);

    /**
     * Begins a farm by transferring `amount` of `token` from `user` to this contract and adds it to the balance of
     * `user`. `user` must be either 1) msg.sender or 2) a wallet who has approved msg.sender as a proxy; else this
     * function reverts. `funder` must be either 1) msg.sender or `user`; else this function reverts.
     */
    function beginFarming(
        address user,
        address funder,
        address token,
        uint amount
    ) external;

    /**
     * Ends a farm by transferring all of `token` deposited by `from` to `recipient`, from this contract, as well as
     * all earned DMG for farming `token` to `recipient`. `from` must be either 1) msg.sender or 2) an approved
     * proxy; else this function reverts.
     *
     * @return  The amount of `token` withdrawn and the amount of DMG earned for farming. Both values are sent to
     *          `recipient`.
     */
    function endFarmingByToken(
        address from,
        address recipient,
        address token
    ) external returns (uint, uint);

    /**
     * Withdraws all of `msg.sender`'s tokens from the farm to `recipient`. This function reverts if there is an active
     * farm. `user` must be either 1) msg.sender or 2) an approved proxy; else this function reverts.
     *
     * @return  Each token and the amount of each withdrawn.
     */
    function withdrawAllWhenOutOfSeason(
        address user,
        address recipient
    ) external returns (address[] memory, uint[] memory);

    /**
     * Withdraws all of `user` `token` from the farm to `recipient`. This function reverts if there is an active farm and the token is NOT removed.
     * `user` must be either 1) msg.sender or 2) an approved proxy; else this function reverts.
     *
     * @return The amount of tokens sent to `recipient`
     */
    function withdrawByTokenWhenOutOfSeason(
        address user,
        address recipient,
        address token
    ) external returns (uint);

    /**
     * @return  The amount of DMG that this owner has earned in the active farm. If there are no active season, this
     *          function returns `0`.
     */
    function getRewardBalanceByOwner(
        address owner
    ) external view returns (uint);

    /**
     * @return  The amount of DMG that this owner has earned in the active farm for the provided token. If there is no
     *          active season, this function returns `0`.
     */
    function getRewardBalanceByOwnerAndToken(
        address owner,
        address token
    ) external view returns (uint);

    /**
     * @return  The amount of `token` that this owner has deposited into this contract. The user may withdraw this
     *          non-zero balance by invoking `endFarming` or `endFarmingByToken` if there is an active farm. If there is
     *          NO active farm, the user may withdraw his/her funds by invoking
     */
    function balanceOf(
        address owner,
        address token
    ) external view returns (uint);

    /**
     * @return  The most recent timestamp at which the `owner` deposited `token` into the yield farming contract for
     *          the current season. If there is no active season, this function returns `0`.
     */
    function getMostRecentDepositTimestampByOwnerAndToken(
        address owner,
        address token
    ) external view returns (uint64);

    /**
     * @return  The most recent indexed amount of DMG earned by the `owner` for the deposited `token` which is being
     *          farmed for the most-recent season. If there is no active season, this function returns `0`.
     */
    function getMostRecentIndexedDmgEarnedByOwnerAndToken(
        address owner,
        address token
    ) external view returns (uint);

    /**
     * Harvests any earned DMG from the provided token for the given user and farmable token. User must be either
     * 1) `msg.sender` or 2) an approved proxy for `user`. The DMG is sent to `recipient`.
     */
    function harvestDmgByUserAndToken(
        address user,
        address recipient,
        address token
    ) external returns (uint);

    /**
     * Harvests any earned DMG from the provided token for the given user and farmable token. User must be either
     * 1) `msg.sender` or 2) an approved proxy for `user`. The DMG is sent to `recipient`.
     */
    function harvestDmgByUser(
        address user,
        address recipient
    ) external returns (uint);

    /**
     * Gets the underlying token for the corresponding farmable token.
     */
    function getUnderlyingTokenByFarmToken(
        address farmToken
    ) external view returns (address);

    // ////////////////////
    // Misc Functions
    // ////////////////////

    /**
     * @return  The tokens that the farm supports.
     */
    function getFarmTokens() external view returns (address[] memory);

    /**
     * @return  True if the provided token is supported for farming, or false if it's not.
     */
    function isSupportedToken(address token) external view returns (bool);

    /**
     * @return  True if there is an active season for farming, or false if there isn't one.
     */
    function isFarmActive() external view returns (bool);

    /**
     * The address that acts as a "secondary" owner with quicker access to function calling than the owner. Typically,
     * this is the DMMF.
     */
    function guardian() external view returns (address);

    /**
     * @return The DMG token.
     */
    function dmgToken() external view returns (address);

    /**
     * @return  The growth coefficient for earning DMG while farming. Each unit represents how much DMG is earned per
     *          point
     */
    function dmgGrowthCoefficient() external view returns (uint);

    /**
     * @return  The amount of points that the provided token earns for each unit of token deposited. Defaults to `1`
     *          if the provided `token` does not exist or does not have a special weight. This number is `2` decimals.
     */
    function getRewardPointsByToken(address token) external view returns (uint16);

    /**
     * @return  The number of decimals that the underlying token has.
     */
    function getTokenDecimalsByToken(address token) external view returns (uint8);

    /**
     * @return  The type of token this farm token is.
     */
    function getTokenTypeByToken(address token) external view returns (DMGYieldFarmingV2Lib.TokenType);

    /**
     * @return  The index into the array returned from `getFarmTokens`, plus 1. 0 if the token isn't found. If the
     *          index returned is non-zero, subtract 1 from it to get the real index into the array.
     */
    function getTokenIndexPlusOneByToken(address token) external view returns (uint);

    function underlyingTokenValuator() external view returns (address);

    function weth() external view returns (address);

    function uniswapV2Router() external view returns (address);

    function getFeesByToken(address token) external view returns (uint16);

}

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

/*

  Copyright 2017 Loopring Project Ltd (Loopring Foundation).

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/
/// @title Utility Functions for addresses
/// @author Daniel Wang - <daniel@loopring.org>
/// @author Brecht Devos - <brecht@loopring.org>
library AddressUtil {
    using AddressUtil for *;

    function isContract(
        address addr
    )
    internal
    view
    returns (bool)
    {
        uint32 size;
        assembly {size := extcodesize(addr)}
        return (size > 0);
    }

    function toPayable(
        address addr
    )
    internal
    pure
    returns (address payable)
    {
        return address(uint160(addr));
    }

    // Works like address.send but with a customizable gas limit
    // Make sure your code is safe for reentrancy when using this function!
    function sendETH(
        address to,
        uint amount
    )
    internal
    returns (bool success) {
        if (amount == 0) {
            return true;
        }

        address payable recipient = to.toPayable();
        require(address(this).balance >= amount, "AddressUtil::sendETH: INSUFFICIENT_BALANCE");

        /* solium-disable-next-line */
        (success,) = recipient.call.value(amount)("");
    }

    // Works like address.transfer but with a customizable gas limit
    // Make sure your code is safe for reentrancy when using this function!
    function sendETHAndVerify(
        address to,
        uint amount
    )
    internal
    returns (bool success)
    {
        success = to.sendETH(amount);
        require(success, "TRANSFER_FAILURE");
    }
}

/*
 * Copyright 2020 DMM Foundation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
interface IWETH {

    function deposit() external payable;

    function withdraw(uint wad) external;

}

contract UniswapV2Router02 is Ownable {
    using SafeMath for uint;
    using SafeERC20 for IERC20;
    using AddressUtil for address payable;

    address public factory;
    address public WETH;
    bytes32 public initCodeHash;

    modifier ensure(uint deadline) {
        require(deadline >= block.timestamp, "UniswapV2Router: EXPIRED");
        _;
    }

    constructor(
        address _factory,
        address _WETH,
        bytes32 _initCodeHash
    ) public {
        factory = _factory;
        WETH = _WETH;
        initCodeHash = _initCodeHash;
    }

    function() external payable {
        // only accept ETH via fallback from the WETH contract
        require(msg.sender == WETH, "INVALID SENDER");
    }

    function setInitCodeHash(bytes32 _initCodeHash) external onlyOwner {
        initCodeHash = _initCodeHash;
    }

    // **** ADD LIQUIDITY ****
    function _addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin
    ) internal returns (uint amountA, uint amountB) {
        // create the pair if it doesn"t exist yet
        if (IUniswapV2Factory(factory).getPair(tokenA, tokenB) == address(0)) {
            IUniswapV2Factory(factory).createPair(tokenA, tokenB);
        }
        (uint reserveA, uint reserveB) = UniswapV2Library.getReserves(factory, tokenA, tokenB, initCodeHash);
        if (reserveA == 0 && reserveB == 0) {
            (amountA, amountB) = (amountADesired, amountBDesired);
        } else {
            uint amountBOptimal = UniswapV2Library.quote(amountADesired, reserveA, reserveB);
            if (amountBOptimal <= amountBDesired) {
                require(amountBOptimal >= amountBMin, "UniswapV2Router: INSUFFICIENT_B_AMOUNT");
                (amountA, amountB) = (amountADesired, amountBOptimal);
            } else {
                uint amountAOptimal = UniswapV2Library.quote(amountBDesired, reserveB, reserveA);
                assert(amountAOptimal <= amountADesired);
                require(amountAOptimal >= amountAMin, "UniswapV2Router: INSUFFICIENT_A_AMOUNT");
                (amountA, amountB) = (amountAOptimal, amountBDesired);
            }
        }
    }

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) public ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
        {
            (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
        }
        address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB, initCodeHash);
        _transferFrom(tokenA, msg.sender, pair, amountA);
        _transferFrom(tokenB, msg.sender, pair, amountB);
        liquidity = IUniswapV2Pair(pair).mint(to);
    }

    function _transferFrom(
        address token,
        address from,
        address to,
        uint amount
    ) internal {
        IERC20(token).safeTransferFrom(from, to, amount);
    }

    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) public payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
        (amountToken, amountETH) = _addLiquidity(
            token,
            WETH,
            amountTokenDesired,
            msg.value,
            amountTokenMin,
            amountETHMin
        );
        address pair = UniswapV2Library.pairFor(factory, token, WETH, initCodeHash);
        IERC20(token).safeTransferFrom(msg.sender, pair, amountToken);
        IWETH(WETH).deposit.value(amountETH)();
        IERC20(WETH).safeTransfer(pair, amountETH);
        liquidity = IUniswapV2Pair(pair).mint(to);
        // refund dust eth, if any
        if (msg.value > amountETH) {
            AddressUtil.sendETHAndVerify(msg.sender, msg.value - amountETH);
        }
    }

    // **** REMOVE LIQUIDITY ****
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) public ensure(deadline) returns (uint amountA, uint amountB) {
        address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB, initCodeHash);
        IUniswapV2Pair(pair).transferFrom(msg.sender, pair, liquidity);
        // send liquidity to pair
        (uint amount0, uint amount1) = IUniswapV2Pair(pair).burn(to);
        (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
        (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
        require(amountA >= amountAMin, "UniswapV2Router: INSUFFICIENT_A_AMOUNT");
        require(amountB >= amountBMin, "UniswapV2Router: INSUFFICIENT_B_AMOUNT");
    }

    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) public ensure(deadline) returns (uint amountToken, uint amountETH) {
        (amountToken, amountETH) = removeLiquidity(
            token,
            WETH,
            liquidity,
            amountTokenMin,
            amountETHMin,
            address(this),
            deadline
        );
        IERC20(token).safeTransfer(to, amountToken);
        IWETH(WETH).withdraw(amountETH);
        AddressUtil.sendETHAndVerify(to, amountETH);
    }

    // **** SWAP ****
    // requires the initial amount to have already been sent to the first pair
    function _swap(uint[] memory amounts, address[] memory path, address _to) internal {
        for (uint i; i < path.length - 1; i++) {
            (address input, address output) = (path[i], path[i + 1]);
            (address token0,) = UniswapV2Library.sortTokens(input, output);
            uint amountOut = amounts[i + 1];
            (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
            address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2], initCodeHash) : _to;
            IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output, initCodeHash)).swap(
                amount0Out, amount1Out, to, new bytes(0)
            );
        }
    }

    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] memory path,
        address to,
        uint deadline
    ) public ensure(deadline) returns (uint[] memory amounts) {
        amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path, initCodeHash);
        require(amounts[amounts.length - 1] >= amountOutMin, "UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT");
        IERC20(path[0]).safeTransferFrom(msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1], initCodeHash), amounts[0]);
        _swap(amounts, path, to);
    }

    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] memory path,
        address to,
        uint deadline
    ) public ensure(deadline) returns (uint[] memory amounts) {
        amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path, initCodeHash);
        require(amounts[0] <= amountInMax, "UniswapV2Router: EXCESSIVE_INPUT_AMOUNT");
        IERC20(path[0]).safeTransferFrom(msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1], initCodeHash), amounts[0]);
        _swap(amounts, path, to);
    }

    function swapExactETHForTokens(uint amountOutMin, address[] memory path, address to, uint deadline)
    public
    payable
    ensure(deadline)
    returns (uint[] memory amounts)
    {
        require(path[0] == WETH, "UniswapV2Router: INVALID_PATH");
        amounts = UniswapV2Library.getAmountsOut(factory, msg.value, path, initCodeHash);
        require(amounts[amounts.length - 1] >= amountOutMin, "UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT");
        IWETH(WETH).deposit.value(amounts[0])();
        IERC20(WETH).safeTransfer(UniswapV2Library.pairFor(factory, path[0], path[1], initCodeHash), amounts[0]);
        _swap(amounts, path, to);
    }

    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] memory path, address to, uint deadline)
    public
    ensure(deadline)
    returns (uint[] memory amounts)
    {
        require(path[path.length - 1] == WETH, "UniswapV2Router: INVALID_PATH");
        amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path, initCodeHash);
        require(amounts[0] <= amountInMax, "UniswapV2Router: EXCESSIVE_INPUT_AMOUNT");
        IERC20(path[0]).safeTransferFrom(msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1], initCodeHash), amounts[0]);
        _swap(amounts, path, address(this));
        IWETH(WETH).withdraw(amounts[amounts.length - 1]);
        AddressUtil.sendETHAndVerify(to, amounts[amounts.length - 1]);
    }

    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] memory path, address to, uint deadline)
    public
    ensure(deadline)
    returns (uint[] memory amounts)
    {
        require(path[path.length - 1] == WETH, "UniswapV2Router: INVALID_PATH");
        amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path, initCodeHash);
        require(amounts[amounts.length - 1] >= amountOutMin, "UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT");
        IERC20(path[0]).safeTransferFrom(msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1], initCodeHash), amounts[0]);
        _swap(amounts, path, address(this));
        IWETH(WETH).withdraw(amounts[amounts.length - 1]);
        AddressUtil.sendETHAndVerify(to, amounts[amounts.length - 1]);
    }

    function swapETHForExactTokens(uint amountOut, address[] memory path, address to, uint deadline)
    public
    payable
    ensure(deadline)
    returns (uint[] memory amounts)
    {
        require(path[0] == WETH, "UniswapV2Router: INVALID_PATH");
        amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path, initCodeHash);
        require(amounts[0] <= msg.value, "UniswapV2Router: EXCESSIVE_INPUT_AMOUNT");
        IWETH(WETH).deposit.value(amounts[0])();
        IERC20(WETH).safeTransfer(UniswapV2Library.pairFor(factory, path[0], path[1], initCodeHash), amounts[0]);
        _swap(amounts, path, to);
        // refund dust eth, if any
        if (msg.value > amounts[0]) {
            AddressUtil.sendETHAndVerify(msg.sender, msg.value - amounts[0]);
        }
    }

    // **** LIBRARY FUNCTIONS ****
    function quote(uint amountA, uint reserveA, uint reserveB) public pure returns (uint amountB) {
        return UniswapV2Library.quote(amountA, reserveA, reserveB);
    }

    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
    public
    pure
    returns (uint amountOut)
    {
        return UniswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut);
    }

    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
    public
    pure
    returns (uint amountIn)
    {
        return UniswapV2Library.getAmountIn(amountOut, reserveIn, reserveOut);
    }

    function getAmountsOut(uint amountIn, address[] memory path)
    public
    view
    returns (uint[] memory amounts)
    {
        return UniswapV2Library.getAmountsOut(factory, amountIn, path, initCodeHash);
    }

    function getAmountsIn(uint amountOut, address[] memory path)
    public
    view
    returns (uint[] memory amounts)
    {
        return UniswapV2Library.getAmountsIn(factory, amountOut, path, initCodeHash);
    }
}

/*
 * Copyright 2020 DMM Foundation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
contract DMGYieldFarmingV2 is IDMGYieldFarmingV2, DMGYieldFarmingData {

    using SafeMath for uint;
    using SafeERC20 for IERC20;
    using UniswapV2Library for *;

    address constant public ZERO_ADDRESS = address(0);

    modifier isSpenderApproved(address user) {
        require(
            msg.sender == user || _globalProxyToIsTrustedMap[msg.sender] || _userToSpenderToIsApprovedMap[user][msg.sender],
            "DMGYieldFarmingV2: UNAPPROVED"
        );
        _;
    }

    modifier onlyOwnerOrGuardian {
        require(
            msg.sender == _owner || msg.sender == _guardian,
            "DMGYieldFarmingV2: UNAUTHORIZED"
        );
        _;
    }

    modifier farmIsActive {
        require(_isFarmActive, "DMGYieldFarmingV2: FARM_NOT_ACTIVE");
        _;
    }

    modifier requireIsFarmToken(address token) {
        require(_tokenToIndexPlusOneMap[token] != 0, "DMGYieldFarmingV2: TOKEN_UNSUPPORTED");
        _;
    }

    modifier farmIsNotActive {
        require(!_isFarmActive, "DMGYieldFarmingV2: FARM_IS_ACTIVE");
        _;
    }

    // ////////////////////
    // Admin Functions
    // ////////////////////

    function approveGloballyTrustedProxy(
        address proxy,
        bool isTrusted
    )
    public
    nonReentrant
    onlyOwnerOrGuardian {
        _globalProxyToIsTrustedMap[proxy] = isTrusted;
        emit GlobalProxySet(proxy, isTrusted);
    }

    function isGloballyTrustedProxy(
        address proxy
    ) public view returns (bool) {
        return _globalProxyToIsTrustedMap[proxy];
    }

    function addAllowableToken(
        address token,
        address underlyingToken,
        uint8 underlyingTokenDecimals,
        uint16 points,
        uint16 fees,
        DMGYieldFarmingV2Lib.TokenType tokenType
    )
    public
    onlyOwnerOrGuardian
    nonReentrant {
        uint index = _tokenToIndexPlusOneMap[token];
        require(
            index == 0,
            "DMGYieldFarmingV2::addAllowableToken: TOKEN_ALREADY_SUPPORTED"
        );
        _verifyTokenFee(fees);
        _verifyTokenType(tokenType, underlyingToken);
        _verifyPoints(points);

        _tokenToIndexPlusOneMap[token] = _supportedFarmTokens.push(token);
        _tokenToRewardPointMap[token] = points;
        _tokenToDecimalsMap[token] = underlyingTokenDecimals;
        _tokenToTokenType[token] = tokenType;
        _tokenToUnderlyingTokenMap[token] = underlyingToken;
        emit TokenAdded(token, underlyingToken, underlyingTokenDecimals, points, fees);
    }

    function removeAllowableToken(
        address token
    )
    public
    onlyOwnerOrGuardian
    nonReentrant
    farmIsNotActive {
        uint index = _tokenToIndexPlusOneMap[token];
        require(
            index != 0,
            "DMGYieldFarmingV2::removeAllowableToken: TOKEN_NOT_SUPPORTED"
        );
        _tokenToIndexPlusOneMap[token] = 0;
        _tokenToRewardPointMap[token] = 0;
        delete _supportedFarmTokens[index - 1];
        emit TokenRemoved(token);
    }

    function beginFarmingSeason(
        uint dmgAmount
    )
    public
    onlyOwnerOrGuardian
    nonReentrant {
        require(!_isFarmActive, "DMGYieldFarmingV2::beginFarmingSeason: FARM_ALREADY_ACTIVE");

        _seasonIndex += 1;
        _isFarmActive = true;
        address dmgToken = _dmgToken;
        IERC20(dmgToken).safeTransferFrom(msg.sender, address(this), dmgAmount);
        _addressToTokenToBalanceMap[ZERO_ADDRESS][dmgToken] = _addressToTokenToBalanceMap[ZERO_ADDRESS][dmgToken].add(dmgAmount);

        emit FarmSeasonBegun(_seasonIndex, dmgAmount);
    }

    function endActiveFarmingSeason(
        address dustRecipient
    )
    public
    nonReentrant {
        address dmgToken = _dmgToken;
        uint dmgBalance = _getDmgRewardBalance(dmgToken);
        // Anyone can end the farm if the DMG balance has been drawn down to 0.
        require(
            dmgBalance == 0 || msg.sender == owner() || msg.sender == _guardian,
            "DMGYieldFarmingV2::endActiveFarmingSeason: FARM_ACTIVE_OR_INVALID_SENDER"
        );

        _isFarmActive = false;
        if (dmgBalance > 0) {
            IERC20(dmgToken).safeTransfer(dustRecipient, dmgBalance);
        }

        emit FarmSeasonEnd(_seasonIndex, dustRecipient, dmgBalance);
    }

    function setDmgGrowthCoefficient(
        uint dmgGrowthCoefficient
    )
    public
    nonReentrant
    onlyOwnerOrGuardian {
        _verifyDmgGrowthCoefficient(dmgGrowthCoefficient);

        _dmgGrowthCoefficient = dmgGrowthCoefficient;
        emit DmgGrowthCoefficientSet(dmgGrowthCoefficient);
    }

    function setRewardPointsByTokens(
        address[] calldata tokens,
        uint16[] calldata points
    )
    external
    nonReentrant
    onlyOwnerOrGuardian {
        require(
            tokens.length == points.length,
            "DMGYieldFarmingV2::setRewardPointsByTokens INVALID_PARAMS"
        );

        for (uint i = 0; i < tokens.length; i++) {
            _setRewardPointsByToken(tokens[i], points[i]);
        }
    }

    function setUnderlyingTokenValuator(
        address underlyingTokenValuator
    )
    onlyOwnerOrGuardian
    nonReentrant
    public {
        require(
            underlyingTokenValuator != address(0),
            "DMGYieldFarmingV2::setUnderlyingTokenValuator: INVALID_VALUATOR"
        );
        address oldUnderlyingTokenValuator = _underlyingTokenValuator;
        _underlyingTokenValuator = underlyingTokenValuator;
        emit UnderlyingTokenValuatorChanged(underlyingTokenValuator, oldUnderlyingTokenValuator);
    }

    function setWethToken(
        address weth
    )
    onlyOwnerOrGuardian
    nonReentrant
    public {
        require(
            _weth == address(0),
            "DMGYieldFarmingV2::setWethToken: WETH_ALREADY_SET"
        );
        _weth = weth;
    }

    function setUniswapV2Router(
        address uniswapV2Router
    )
    onlyOwnerOrGuardian
    nonReentrant
    public {
        require(
            uniswapV2Router != address(0),
            "DMGYieldFarmingV2::setUnderlyingTokenValuator: INVALID_VALUATOR"
        );
        address oldUniswapV2Router = _uniswapV2Router;
        _uniswapV2Router = uniswapV2Router;
        emit UniswapV2RouterChanged(uniswapV2Router, oldUniswapV2Router);
    }

    function setFeesByTokens(
        address[] calldata tokens,
        uint16[] calldata fees
    )
    onlyOwnerOrGuardian
    nonReentrant
    external {
        require(
            tokens.length == fees.length,
            "DMGYieldFarmingV2::setFeesByTokens: INVALID_PARAMS"
        );

        for (uint i = 0; i < tokens.length; i++) {
            _setFeeByToken(tokens[i], fees[i]);
        }
    }

    function setTokenTypeByToken(
        address token,
        DMGYieldFarmingV2Lib.TokenType tokenType
    )
    onlyOwnerOrGuardian
    nonReentrant
    requireIsFarmToken(token)
    public {
        _verifyTokenType(tokenType, _tokenToUnderlyingTokenMap[token]);
        _tokenToTokenType[token] = tokenType;
        emit TokenTypeChanged(token, tokenType);
    }

    function initializeDmgBalance() nonReentrant external {
        require(
            !_isDmgBalanceInitialized,
            "DMGYieldFarmingV2::initializeDmgBalance: ALREADY_INITIALIZED"
        );
        _isDmgBalanceInitialized = true;
        _addressToTokenToBalanceMap[ZERO_ADDRESS][_dmgToken] = IERC20(_dmgToken).balanceOf(address(this));
    }

    // ////////////////////
    // Misc Functions
    // ////////////////////

    function getFarmTokens() public view returns (address[] memory) {
        return _supportedFarmTokens;
    }

    function isSupportedToken(address token) public view returns (bool) {
        return _tokenToIndexPlusOneMap[token] > 0;
    }

    function isFarmActive() external view returns (bool) {
        return _isFarmActive;
    }

    function guardian() external view returns (address) {
        return _guardian;
    }

    function dmgToken() external view returns (address) {
        return _dmgToken;
    }

    function dmgGrowthCoefficient() external view returns (uint) {
        return _dmgGrowthCoefficient;
    }

    function getRewardPointsByToken(
        address token
    ) public view returns (uint16) {
        uint16 rewardPoints = _tokenToRewardPointMap[token];
        return rewardPoints == 0 ? POINTS_FACTOR : rewardPoints;
    }

    function getTokenDecimalsByToken(
        address token
    ) public view returns (uint8) {
        return _tokenToDecimalsMap[token];
    }

    function getTokenIndexPlusOneByToken(
        address token
    ) public view returns (uint) {
        return _tokenToIndexPlusOneMap[token];
    }

    function getTokenTypeByToken(
        address token
    ) public view returns (DMGYieldFarmingV2Lib.TokenType) {
        return _tokenToTokenType[token];
    }

    // ////////////////////
    // User Functions
    // ////////////////////

    function approve(
        address spender,
        bool isTrusted
    ) public {
        _userToSpenderToIsApprovedMap[msg.sender][spender] = isTrusted;
        emit Approval(msg.sender, spender, isTrusted);
    }

    function isApproved(
        address user,
        address spender
    ) public view returns (bool) {
        return _userToSpenderToIsApprovedMap[user][spender];
    }

    function beginFarming(
        address user,
        address funder,
        address token,
        uint amount
    )
    public
    farmIsActive
    requireIsFarmToken(token)
    isSpenderApproved(user)
    nonReentrant {
        require(
            funder == msg.sender || funder == user,
            "DMGYieldFarmingV2::beginFarming: INVALID_FUNDER"
        );

        if (amount > 0) {
            // In case the user is reusing a non-zero balance they had before the start of this farm.
            IERC20(token).safeTransferFrom(funder, address(this), amount);
        }

        // We reindex before adding to the user's balance, because the indexing process takes the user's CURRENT
        // balance and applies their earnings, so we can account for new deposits.
        _reindexEarningsByTimestamp(user, token);

        if (amount > 0) {
            _addressToTokenToBalanceMap[user][token] = _addressToTokenToBalanceMap[user][token].add(amount);
        }

        emit BeginFarming(user, token, amount);
    }

    function endFarmingByToken(
        address user,
        address recipient,
        address token
    )
    public
    farmIsActive
    requireIsFarmToken(token)
    isSpenderApproved(user)
    nonReentrant
    returns (uint, uint) {
        uint tokenBalance = _addressToTokenToBalanceMap[user][token];
        require(tokenBalance > 0, "DMGYieldFarmingV2::endFarmingByToken: ZERO_BALANCE");

        address dmgToken = _dmgToken;

        uint earnedDmgAmount = _getTotalRewardBalanceByUserAndToken(user, token, dmgToken, _seasonIndex);
        require(earnedDmgAmount > 0, "DMGYieldFarmingV2::endFarmingByToken: ZERO_EARNED");

        uint contractDmgRewardBalance = _getDmgRewardBalance(dmgToken);
        uint scaledTokenBalance = tokenBalance;
        if (earnedDmgAmount > contractDmgRewardBalance) {
            // Proportionally scale down the fee payment to how much DMG is actually going to be redeemed
            scaledTokenBalance = scaledTokenBalance.mul(contractDmgRewardBalance).div(earnedDmgAmount);
            earnedDmgAmount = contractDmgRewardBalance;
            require(earnedDmgAmount > 0, "DMGYieldFarmingV2::endFarmingByToken: SCALED_ZERO_EARNED");
        }
        _addressToTokenToBalanceMap[ZERO_ADDRESS][dmgToken] = _addressToTokenToBalanceMap[ZERO_ADDRESS][dmgToken].sub(earnedDmgAmount);

        {
            // To avoid the "stack too deep" error
            uint feeAmount = _payHarvestFee(user, token, scaledTokenBalance);
            // The user withdraws (balance - fee) amount.
            tokenBalance = tokenBalance.sub(feeAmount);
            IERC20(token).safeTransfer(recipient, tokenBalance);
            IERC20(dmgToken).safeTransfer(recipient, earnedDmgAmount);
        }

        _addressToTokenToBalanceMap[user][token] = 0;
        _seasonIndexToUserToTokenToEarnedDmgAmountMap[_seasonIndex][user][token] = 0;
        _seasonIndexToUserToTokenToDepositTimestampMap[_seasonIndex][user][token] = uint64(block.timestamp);

        emit EndFarming(user, token, tokenBalance, earnedDmgAmount);

        return (tokenBalance, earnedDmgAmount);
    }

    function withdrawAllWhenOutOfSeason(
        address user,
        address recipient
    )
    public
    farmIsNotActive
    isSpenderApproved(user)
    nonReentrant
    returns (address[] memory, uint[] memory) {
        address[] memory farmTokens = _supportedFarmTokens;
        uint[] memory withdrawnAmounts = new uint[](farmTokens.length);
        for (uint i = 0; i < farmTokens.length; i++) {
            withdrawnAmounts[i] = _withdrawByTokenWhenOutOfSeason(user, recipient, farmTokens[i]);
        }
        return (farmTokens, withdrawnAmounts);
    }

    function withdrawByTokenWhenOutOfSeason(
        address user,
        address recipient,
        address token
    )
    isSpenderApproved(user)
    nonReentrant
    public returns (uint) {
        // The user can only withdraw this way if the farm is NOT active or if the token is no longer supported.
        require(
            !_isFarmActive || _tokenToIndexPlusOneMap[token] == 0,
            "DMGYieldFarmingV2::withdrawByTokenWhenOutOfSeason: FARM_ACTIVE_OR_TOKEN_SUPPORTED"
        );

        return _withdrawByTokenWhenOutOfSeason(user, recipient, token);
    }

    function getRewardBalanceByOwner(
        address owner
    ) public view returns (uint) {
        if (_isFarmActive) {
            return _getTotalRewardBalanceByUser(owner, _seasonIndex);
        } else {
            return 0;
        }
    }

    function getRewardBalanceByOwnerAndToken(
        address owner,
        address token
    ) public view returns (uint) {
        if (_isFarmActive) {
            return _getTotalRewardBalanceByUserAndToken(owner, token, _dmgToken, _seasonIndex);
        } else {
            return 0;
        }
    }

    function balanceOf(
        address owner,
        address token
    ) public view returns (uint) {
        return _addressToTokenToBalanceMap[owner][token];
    }

    function getMostRecentDepositTimestampByOwnerAndToken(
        address owner,
        address token
    ) public view returns (uint64) {
        if (_isFarmActive) {
            return _seasonIndexToUserToTokenToDepositTimestampMap[_seasonIndex][owner][token];
        } else {
            return 0;
        }
    }

    function getMostRecentIndexedDmgEarnedByOwnerAndToken(
        address owner,
        address token
    ) public view returns (uint) {
        if (_isFarmActive) {
            return _seasonIndexToUserToTokenToEarnedDmgAmountMap[_seasonIndex][owner][token];
        } else {
            return 0;
        }
    }

    function harvestDmgByUserAndToken(
        address user,
        address recipient,
        address token
    )
    requireIsFarmToken(token)
    farmIsActive
    isSpenderApproved(user)
    nonReentrant
    public returns (uint) {
        uint tokenBalance = _addressToTokenToBalanceMap[user][token];
        return _harvestDmgByUserAndToken(user, recipient, token, tokenBalance);
    }

    function harvestDmgByUser(
        address user,
        address recipient
    )
    farmIsActive
    isSpenderApproved(user)
    nonReentrant
    public returns (uint) {
        address[] memory farmTokens = _supportedFarmTokens;
        uint totalEarnedDmgAmount = 0;
        for (uint i = 0; i < farmTokens.length; i++) {
            uint farmTokenBalance = _addressToTokenToBalanceMap[user][farmTokens[i]];
            if (farmTokenBalance > 0) {
                uint earnedDmgAmount = _harvestDmgByUserAndToken(user, recipient, farmTokens[i], farmTokenBalance);
                totalEarnedDmgAmount = totalEarnedDmgAmount.add(earnedDmgAmount);
            }
        }
        return totalEarnedDmgAmount;
    }

    function getUnderlyingTokenByFarmToken(
        address farmToken
    ) public view returns (address) {
        return _tokenToUnderlyingTokenMap[farmToken];
    }

    function underlyingTokenValuator() external view returns (address) {
        return _underlyingTokenValuator;
    }

    function weth() external view returns (address) {
        return _weth;
    }

    function uniswapV2Router() external view returns (address) {
        return _uniswapV2Router;
    }

    function getFeesByToken(address token) public view returns (uint16) {
        uint16 fee = _tokenToFeeAmountMap[token];
        return fee == 0 ? 100 : fee;
    }

    // ////////////////////
    // Internal Functions
    // ////////////////////

    function _setFeeByToken(
        address token,
        uint16 fee
    ) internal {
        _verifyTokenFee(fee);
        _tokenToFeeAmountMap[token] = fee;
        emit FeesChanged(token, fee);
    }

    function _setRewardPointsByToken(
        address token,
        uint16 points
    ) internal {
        _verifyPoints(points);
        _tokenToRewardPointMap[token] = points;
        emit RewardPointsSet(token, points);
    }

    function _verifyDmgGrowthCoefficient(
        uint dmgGrowthCoefficient
    ) internal pure {
        require(
            dmgGrowthCoefficient > 0,
            "DMGYieldFarmingV2::_verifyDmgGrowthCoefficient: INVALID_GROWTH_COEFFICIENT"
        );
    }

    function _verifyTokenType(
        DMGYieldFarmingV2Lib.TokenType tokenType,
        address underlyingToken
    ) internal {
        require(
            tokenType != DMGYieldFarmingV2Lib.TokenType.Unknown,
            "DMGYieldFarmingV2::_verifyTokenType: INVALID_TYPE"
        );

        if (tokenType == DMGYieldFarmingV2Lib.TokenType.UniswapLpToken) {
            address uniswapV2Router = _uniswapV2Router;
            if (IERC20(underlyingToken).allowance(address(this), uniswapV2Router) == 0) {
                IERC20(underlyingToken).safeApprove(uniswapV2Router, uint(- 1));
            }
        }
    }

    function _verifyTokenFee(
        uint16 fee
    ) internal pure {
        require(
            fee >= 0 && fee < FEE_AMOUNT_FACTOR,
            "DMGYieldFarmingV2::_verifyTokenFee: INVALID_FEES"
        );
    }

    function _verifyPoints(
        uint16 points
    ) internal pure {
        require(
            points > 0,
            "DMGYieldFarmingV2::_verifyPoints: INVALID_POINTS"
        );
    }

    function _getDmgRewardBalance(
        address dmgToken
    ) internal view returns (uint) {
        return _addressToTokenToBalanceMap[ZERO_ADDRESS][dmgToken];
    }

    function _harvestDmgByUserAndToken(
        address user,
        address recipient,
        address token,
        uint tokenBalance
    ) internal returns (uint) {
        require(
            tokenBalance > 0,
            "DMGYieldFarmingV2::_harvestDmgByUserAndToken: ZERO_BALANCE"
        );

        address dmgToken = _dmgToken;
        uint earnedDmgAmount = _getTotalRewardBalanceByUserAndToken(user, token, dmgToken, _seasonIndex);
        require(earnedDmgAmount > 0, "DMGYieldFarmingV2::_harvestDmgByUserAndToken: ZERO_EARNED");

        uint contractDmgRewardBalance = _getDmgRewardBalance(dmgToken);
        uint scaledTokenBalance = tokenBalance;
        if (earnedDmgAmount > contractDmgRewardBalance) {
            // Proportionally scale down the fee payment to how much DMG is actually going to be redeemed
            scaledTokenBalance = scaledTokenBalance.mul(contractDmgRewardBalance).div(earnedDmgAmount);
            earnedDmgAmount = contractDmgRewardBalance;
        }
        _addressToTokenToBalanceMap[ZERO_ADDRESS][dmgToken] = _addressToTokenToBalanceMap[ZERO_ADDRESS][dmgToken].sub(earnedDmgAmount);

        {
            uint feeAmount = _payHarvestFee(user, token, scaledTokenBalance);
            _addressToTokenToBalanceMap[user][token] = _addressToTokenToBalanceMap[user][token].sub(feeAmount);
        }

        IERC20(dmgToken).safeTransfer(recipient, earnedDmgAmount);

        _seasonIndexToUserToTokenToEarnedDmgAmountMap[_seasonIndex][user][token] = 0;
        _seasonIndexToUserToTokenToDepositTimestampMap[_seasonIndex][user][token] = uint64(block.timestamp);

        emit Harvest(user, token, earnedDmgAmount);

        return earnedDmgAmount;
    }

    function _getUnindexedRewardsByUserAndToken(
        address owner,
        address token,
        address dmgToken,
        uint64 previousIndexTimestamp
    ) internal view returns (uint) {
        uint balance;
        if (owner == ZERO_ADDRESS) {
            balance = IERC20(token).balanceOf(address(this));
            if (token == dmgToken) {
                balance = balance.sub(_getDmgRewardBalance(dmgToken));
            }
        } else {
            balance = _addressToTokenToBalanceMap[owner][token];
        }

        if (balance > 0 && previousIndexTimestamp != 0) {
            uint usdValue = _getUsdValueByTokenAndTokenAmount(token, balance);
            uint16 points = getRewardPointsByToken(token);
            return _calculateRewardBalance(
                usdValue,
                points,
                _dmgGrowthCoefficient,
                block.timestamp,
                previousIndexTimestamp
            );
        } else {
            return 0;
        }
    }

    function _reindexEarningsByTimestamp(
        address user,
        address token
    ) internal {
        uint seasonIndex = _seasonIndex;
        uint64 previousIndexTimestamp = _seasonIndexToUserToTokenToDepositTimestampMap[seasonIndex][user][token];
        if (previousIndexTimestamp != 0) {
            uint dmgEarnedAmount = _getUnindexedRewardsByUserAndToken(user, token, _dmgToken, previousIndexTimestamp);
            if (dmgEarnedAmount > 0) {
                _seasonIndexToUserToTokenToEarnedDmgAmountMap[seasonIndex][user][token] = _seasonIndexToUserToTokenToEarnedDmgAmountMap[seasonIndex][user][token].add(dmgEarnedAmount);
            }
        }
        _seasonIndexToUserToTokenToDepositTimestampMap[seasonIndex][user][token] = uint64(block.timestamp);
    }

    function _getTotalRewardBalanceByUserAndToken(
        address owner,
        address token,
        address dmgToken,
        uint seasonIndex
    ) internal view returns (uint) {
        uint64 previousIndexTimestamp = _seasonIndexToUserToTokenToDepositTimestampMap[seasonIndex][owner][token];
        return _getUnindexedRewardsByUserAndToken(owner, token, dmgToken, previousIndexTimestamp)
        .add(_seasonIndexToUserToTokenToEarnedDmgAmountMap[seasonIndex][owner][token]);
    }

    /**
     * @return  The dollar value of `tokenAmount`, formatted as a number with 18 decimal places
     */
    function _getUsdValueByTokenAndTokenAmount(
        address token,
        uint tokenAmount
    ) internal view returns (uint) {
        uint8 decimals = _tokenToDecimalsMap[token];
        address underlyingToken = _tokenToUnderlyingTokenMap[token];

        tokenAmount = tokenAmount
        .mul(IERC20(underlyingToken).balanceOf(token)) /* For Uniswap pools, underlying tokens are held in the pool's contract. */
        .div(IERC20(token).totalSupply(), "DMGYieldFarmingV2::_getUsdValueByTokenAndTokenAmount: INVALID_TOTAL_SUPPLY")
        .mul(2) /* The user deposits effectively 2x the value of the underlying token in total (when the pool is in equilibrium, to account for both sides of the pool. Assuming the pool is at (or close to it) equilibrium, this 2x suffices as an estimate */;

        if (decimals < 18) {
            tokenAmount = tokenAmount.mul((10 ** (18 - uint(decimals))));
        } else if (decimals > 18) {
            tokenAmount = tokenAmount.div((10 ** (uint(decimals) - 18)));
        }

        return IUnderlyingTokenValuator(_underlyingTokenValuator).getTokenValue(underlyingToken, tokenAmount);
    }

    function _calculateRewardBalance(
        uint usdValue,
        uint16 points,
        uint dmgGrowthCoefficient,
        uint currentTimestamp,
        uint previousIndexTimestamp
    ) internal pure returns (uint) {
        if (usdValue == 0) {
            return 0;
        } else {
            uint elapsedTime = currentTimestamp.sub(previousIndexTimestamp);
            // The number returned here has 18 decimal places (same as USD value), which is the same number as DMG.
            // Perfect.
            return elapsedTime
            .mul(dmgGrowthCoefficient)
            .mul(usdValue)
            .div(DMG_GROWTH_COEFFICIENT_FACTOR)
            .mul(points)
            .div(POINTS_FACTOR);
        }
    }

    function _getTotalRewardBalanceByUser(
        address owner,
        uint seasonIndex
    ) internal view returns (uint) {
        address[] memory supportedFarmTokens = _supportedFarmTokens;
        address dmgToken = _dmgToken;
        uint totalDmgEarned = 0;
        for (uint i = 0; i < supportedFarmTokens.length; i++) {
            totalDmgEarned = totalDmgEarned.add(_getTotalRewardBalanceByUserAndToken(owner, supportedFarmTokens[i], dmgToken, seasonIndex));
        }
        return totalDmgEarned;
    }

    function _withdrawByTokenWhenOutOfSeason(
        address user,
        address recipient,
        address token
    ) internal returns (uint) {
        uint amount = _addressToTokenToBalanceMap[user][token];
        if (amount > 0) {
            _addressToTokenToBalanceMap[user][token] = 0;
            IERC20(token).safeTransfer(recipient, amount);
        }

        emit WithdrawOutOfSeason(user, token, recipient, amount);

        return amount;
    }

    /**
     * @return The amount of `token` paid for the burn.
     */
    function _payHarvestFee(
        address user,
        address token,
        uint tokenAmount
    ) internal returns (uint) {
        uint fees = getFeesByToken(token);
        if (fees > 0) {
            uint tokenFeeAmount = tokenAmount.mul(fees).div(uint(FEE_AMOUNT_FACTOR));
            DMGYieldFarmingV2Lib.TokenType tokenType = _tokenToTokenType[token];
            require(
                tokenType != DMGYieldFarmingV2Lib.TokenType.Unknown,
                "DMGYieldFarmingV2::_payHarvestFee: UNKNOWN_TOKEN_TYPE"
            );

            if (tokenType == DMGYieldFarmingV2Lib.TokenType.UniswapLpToken) {
                _payFeesWithUniswapToken(user, token, tokenFeeAmount);
            } else {
                revert("DMGYieldFarmingV2::_payHarvestFee UNCAUGHT_TOKEN_TYPE");
            }

            return tokenFeeAmount;
        } else {
            return 0;
        }
    }

    function _payFeesWithUniswapToken(
        address user,
        address token,
        uint tokenFeeAmount
    ) internal {
        address underlyingToken = _tokenToUnderlyingTokenMap[token];

        address tokenToSwap;
        address token0;
        uint amountToBurn;
        uint amountToSwap;
        {
            // New context - to prevent the stack too deep error
            IERC20(token).safeTransfer(token, tokenFeeAmount);
            (uint amount0, uint amount1) = IUniswapV2Pair(token).burn(address(this));
            token0 = IUniswapV2Pair(token).token0();

            tokenToSwap = token0 == underlyingToken ? IUniswapV2Pair(token).token1() : token0;

            amountToBurn = token0 == underlyingToken ? amount0 : amount1;
            amountToSwap = token0 != underlyingToken ? amount0 : amount1;
        }

        address dmgToken = _dmgToken;

        if (tokenToSwap != dmgToken) {
            // This code is taken from the `UniswapV2Router02` to more efficiently swap *TO* the underlying token
            IERC20(tokenToSwap).safeTransfer(token, amountToSwap);
            (uint reserve0, uint reserve1,) = IUniswapV2Pair(token).getReserves();
            uint amountOut = UniswapV2Library.getAmountOut(
                amountToSwap,
                tokenToSwap == token0 ? reserve0 : reserve1,
                tokenToSwap != token0 ? reserve0 : reserve1
            );
            (uint amount0Out, uint amount1Out) = tokenToSwap == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
            IUniswapV2Pair(token).swap(amount0Out, amount1Out, address(this), new bytes(0));
            amountToBurn = amountToBurn.add(amountOut);
        }

        address weth = _weth;
        uint dmgToBurn = _swapTokensForDmgViaUniswap(amountToBurn, underlyingToken, weth, dmgToken);

        if (tokenToSwap == dmgToken) {
            // We can just add the DMG to be swapped with the amount to burn.
            amountToSwap = amountToSwap.add(dmgToBurn);
            IDMGToken(dmgToken).burn(amountToSwap);
            emit HarvestFeePaid(user, token, tokenFeeAmount, amountToSwap);
        } else {
            IDMGToken(dmgToken).burn(dmgToBurn);
            emit HarvestFeePaid(user, token, tokenFeeAmount, dmgToBurn);
        }
    }

    /**
     * @return  The amount of DMG received from the swap
     */
    function _swapTokensForDmgViaUniswap(
        uint amountToBurn,
        address underlyingToken,
        address weth,
        address dmgToken
    ) internal returns (uint) {
        address[] memory paths;
        if (underlyingToken == weth) {
            paths = new address[](2);
            paths[0] = weth;
            paths[1] = dmgToken;
        } else {
            paths = new address[](3);
            paths[0] = underlyingToken;
            paths[1] = weth;
            paths[2] = dmgToken;
        }
        // We sell the non-mToken to DMG and burn it.
        uint[] memory amountsOut = IUniswapV2Router02(_uniswapV2Router).swapExactTokensForTokens(
            amountToBurn,
        /* amountOutMin */ 1,
            paths,
            address(this),
            block.timestamp
        );

        return amountsOut[amountsOut.length - 1];
    }

}

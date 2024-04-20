// File: contracts/Corlibri_Libraries.sol



// SPDX-License-Identifier: WHO GIVES A FUCK ANYWAY??



pragma solidity ^0.6.6;



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

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

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

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b != 0, errorMessage);

        return a % b;

    }

}



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

        (bool success, ) = recipient.call{ value: amount }("");

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

    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {

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

    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {

        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");

    }



    /**

     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but

     * with `errorMessage` as a fallback revert reason when `target` reverts.

     *

     * _Available since v3.1._

     */

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {

        require(address(this).balance >= value, "Address: insufficient balance for call");

        return _functionCallWithValue(target, data, value, errorMessage);

    }



    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {

        require(isContract(target), "Address: call to non-contract");



        // solhint-disable-next-line avoid-low-level-calls

        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);

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



    event Log(string log);



}



// File: contracts/Corlibri_Interfaces.sol







pragma solidity ^0.6.6;



//CORLIBRI

    interface ICorlibri {

        function viewGovernanceLevel(address _address) external view returns(uint8);

        function viewVault() external view returns(address);

        function viewUNIv2() external view returns(address);

        function viewWrappedUNIv2()external view returns(address);

        function burnFromUni(uint256 _amount) external;

    }



//Nectar is wrapping Tokens, generates wrappped UNIv2

    interface INectar {

        function wrapUNIv2(uint256 amount) external;

        function wTransfer(address recipient, uint256 amount) external;

        function setPublicWrappingRatio(uint256 _ratioBase100) external;

    }

    

//VAULT

    interface IVault {

        function updateRewards() external;

    }





//UNISWAP

    interface IUniswapV2Factory {

        event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    

        function feeTo() external view returns (address);

        function feeToSetter() external view returns (address);

        function migrator() external view returns (address);

    

        function getPair(address tokenA, address tokenB) external view returns (address pair);

        function allPairs(uint) external view returns (address pair);

        function allPairsLength() external view returns (uint);

    

        function createPair(address tokenA, address tokenB) external returns (address pair);

    

        function setFeeTo(address) external;

        function setFeeToSetter(address) external;

        function setMigrator(address) external;

    }

    interface IUniswapV2Router01 {

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

    

        function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);

        function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);

        function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);

        function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);

        function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);

    }

    interface IUniswapV2Router02 is IUniswapV2Router01 {

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

    

        event Mint(address indexed sender, uint amount0, uint amount1);

        event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);

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

    interface IWETH {

        function deposit() external payable;

        function transfer(address to, uint value) external returns (bool);

        function withdraw(uint) external;

    }



// File: contracts/Corlibri_Vault.sol





// but thanks a million Gwei to MIT and Zeppelin. You guys rock!!!



// MAINNET VERSION.



pragma solidity ^0.6.6;









// Vault distributes fees equally amongst staked pools



contract Corlibri_Vault {

    using SafeMath for uint256;





    address public Corlibri; //token address

    

    /*

    address public Treasury1;

    address public Treasury2;

    address public Treasury3; */

    address public Treasury;

    uint256 public treasuryFee;

    uint256 public pendingTreasuryRewards;

    



//USERS METRICS

    struct UserInfo {

        uint256 amount; // How many tokens the user has provided.

        uint256 rewardPaid; // Already Paid. See explanation below.

        //  pending reward = (user.amount * pool.CorlibriPerShare) - user.rewardPaid

    }

    mapping(uint256 => mapping(address => UserInfo)) public userInfo;

    

//POOL METRICS

    struct PoolInfo {

        address stakedToken;                // Address of staked token contract.

        uint256 allocPoint;           // How many allocation points assigned to this pool. Corlibris to distribute per block. (ETH = 2.3M blocks per year)

        uint256 accCorlibriPerShare;   // Accumulated Corlibris per share, times 1e18. See below.

        bool withdrawable;            // Is this pool withdrawable or not

        

        mapping(address => mapping(address => uint256)) allowance;

    }

    PoolInfo[] public poolInfo;



    uint256 public totalAllocPoint;     // Total allocation points. Must be the sum of all allocation points in all pools.

    uint256 public pendingRewards;      // pending rewards awaiting anyone to massUpdate

    uint256 public contractStartBlock;

    uint256 public epochCalculationStartBlock;

    uint256 public cumulativeRewardsSinceStart;

    uint256 public rewardsInThisEpoch;

    uint public epoch;



//EVENTS

    event Deposit(address indexed user, uint256 indexed pid, uint256 amount);

    event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);

    event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);

    event Approval(address indexed owner, address indexed spender, uint256 _pid, uint256 value);



    

//INITIALIZE 

    constructor(address _Corlibri) public {



        Corlibri = _Corlibri;



        Treasury = address(msg.sender); // deployer address set as treasury for simplicity. can be set/changed to distribution contract in future

        

        treasuryFee = 1500; // 15%

        

        contractStartBlock = block.number;

    }

    

//==================================================================================================================================

//POOL

    

 //view stuff

 

    function poolLength() external view returns (uint256) {

        return poolInfo.length; //number of pools (per pid)

    }

    

    // Returns fees generated since start of this contract

    function averageFeesPerBlockSinceStart() external view returns (uint averagePerBlock) {

        averagePerBlock = cumulativeRewardsSinceStart.add(rewardsInThisEpoch).div(block.number.sub(contractStartBlock));

    }



    // Returns averge fees in this epoch

    function averageFeesPerBlockEpoch() external view returns (uint256 averagePerBlock) {

        averagePerBlock = rewardsInThisEpoch.div(block.number.sub(epochCalculationStartBlock));

    }



    // For easy graphing historical epoch rewards

    mapping(uint => uint256) public epochRewards;



 //set stuff (govenrors)



    // Add a new token pool. Can only be called by governors.

    function addPool( uint256 _allocPoint, address _stakedToken, bool _withdrawable) public governanceLevel(2) {

        require(_allocPoint > 0, "Zero alloc points not allowed");

        nonWithdrawableByAdmin[_stakedToken] = true; // stakedToken is now non-withdrawable by the admins.

        

        /* @dev Addressing potential issues with zombie pools.

        *  https://medium.com/@DraculaProtocol/sushiswap-smart-contract-bug-and-quality-of-audits-in-community-f50ee0545bc6

        *  Thank you @DraculaProtocol for this interesting post.

        */

        massUpdatePools();



        uint256 length = poolInfo.length;

        for (uint256 pid = 0; pid < length; ++pid) {

            require(poolInfo[pid].stakedToken != _stakedToken,"Error pool already added");

        }



        totalAllocPoint = totalAllocPoint.add(_allocPoint); //pre-allocation



        poolInfo.push(

            PoolInfo({

                stakedToken: _stakedToken,

                allocPoint: _allocPoint,

                accCorlibriPerShare: 0,

                withdrawable : _withdrawable

            })

        );

    }



    // Updates the given pool's  allocation points. Can only be called with right governance levels.

    function setPool(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public governanceLevel(2) {

        require(_allocPoint > 0, "Zero alloc points not allowed");

        if (_withUpdate) {massUpdatePools();}



        totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);

        poolInfo[_pid].allocPoint = _allocPoint;

    }



    // Update the given pool's ability to withdraw tokens

    function setPoolWithdrawable(uint256 _pid, bool _withdrawable) public governanceLevel(2) {

        poolInfo[_pid].withdrawable = _withdrawable;

    }

    

 //set stuff (anybody)

  

    //Starts a new calculation epoch; Because average since start will not be accurate

    function startNewEpoch() public {

        require(epochCalculationStartBlock + 50000 < block.number, "New epoch not ready yet"); // 50k blocks = About a week

        epochRewards[epoch] = rewardsInThisEpoch;

        cumulativeRewardsSinceStart = cumulativeRewardsSinceStart.add(rewardsInThisEpoch);

        rewardsInThisEpoch = 0;

        epochCalculationStartBlock = block.number;

        ++epoch;

    }

    

    // Updates the reward variables of the given pool

    function updatePool(uint256 _pid) internal returns (uint256 CorlibriRewardWhole) {

        PoolInfo storage pool = poolInfo[_pid];



        uint256 tokenSupply = IERC20(pool.stakedToken).balanceOf(address(this));

        if (tokenSupply == 0) { // avoids division by 0 errors

            return 0;

        }

        CorlibriRewardWhole = pendingRewards     // Multiplies pending rewards by allocation point of this pool and then total allocation

            .mul(pool.allocPoint)               // getting the percent of total pending rewards this pool should get

            .div(totalAllocPoint);              // we can do this because pools are only mass updated

        

        uint256 CorlibriRewardFee = CorlibriRewardWhole.mul(treasuryFee).div(10000);

        uint256 CorlibriRewardToDistribute = CorlibriRewardWhole.sub(CorlibriRewardFee);



        pendingTreasuryRewards = pendingTreasuryRewards.add(CorlibriRewardFee);



        pool.accCorlibriPerShare = pool.accCorlibriPerShare.add(CorlibriRewardToDistribute.mul(1e18).div(tokenSupply));

    }

    function massUpdatePools() public {

        uint256 length = poolInfo.length; 

        uint allRewards;

        

        for (uint256 pid = 0; pid < length; ++pid) {

            allRewards = allRewards.add(updatePool(pid)); //calls updatePool(pid)

        }

        pendingRewards = pendingRewards.sub(allRewards);

    }

    

    //payout of Corlibri Rewards, uses SafeCorlibriTransfer

    function updateAndPayOutPending(uint256 _pid, address user) internal {

        

        massUpdatePools();



        uint256 pending = pendingCorlibri(_pid, user);



        safeCorlibriTransfer(user, pending);

    }

    

    

    // Safe Corlibri transfer function, Manages rounding errors.

    function safeCorlibriTransfer(address _to, uint256 _amount) internal {

        if(_amount == 0) return;



        uint256 CorlibriBal = IERC20(Corlibri).balanceOf(address(this));

        if (_amount >= CorlibriBal) { IERC20(Corlibri).transfer(_to, CorlibriBal);} 

        else { IERC20(Corlibri).transfer(_to, _amount);}



        transferTreasuryFees(); //adds unecessary gas for users, team can trigger the function manually

        CorlibriBalance = IERC20(Corlibri).balanceOf(address(this));

    }



//external call from token when rewards are loaded



    /* @dev called by the token after each fee transfer to the vault.

    *       updates the pendingRewards and the rewardsInThisEpoch variables

    */      

    modifier onlyCorlibri() {

        require(msg.sender == Corlibri);

        _;

    }

    

    uint256 private CorlibriBalance;

    function updateRewards() external onlyCorlibri {  //function addPendingRewards(uint256 _) for CORE

        uint256 newRewards = IERC20(Corlibri).balanceOf(address(this)).sub(CorlibriBalance); //delta vs previous balanceOf



        if(newRewards > 0) {

            CorlibriBalance =  IERC20(Corlibri).balanceOf(address(this)); //balance snapshot

            pendingRewards = pendingRewards.add(newRewards);

            rewardsInThisEpoch = rewardsInThisEpoch.add(newRewards);

        }

    }



//==================================================================================================================================

//USERS



    

    /* protects from a potential reentrancy in Deposits and Withdraws 

     * users can only make 1 deposit or 1 wd per block

     */

     

    mapping(address => uint256) private lastTXBlock;

    modifier NoReentrant(address _address) {

        require(block.number > lastTXBlock[_address], "Wait 1 block between each deposit/withdrawal");

        _;

    }

    

    // Deposit tokens to Vault to get allocation rewards

    function deposit(uint256 _pid, uint256 _amount) external NoReentrant(msg.sender) {

        lastTXBlock[msg.sender] = block.number;

        

        require(_amount > 0, "cannot deposit zero tokens");

        

        PoolInfo storage pool = poolInfo[_pid];

        UserInfo storage user = userInfo[_pid][msg.sender];



        updateAndPayOutPending(_pid, msg.sender); //Transfer pending tokens, updates the pools 



        //Transfer the amounts from user

        IERC20(pool.stakedToken).transferFrom(msg.sender, address(this), _amount);

        user.amount = user.amount.add(_amount);



        //Finalize

        user.rewardPaid = user.amount.mul(pool.accCorlibriPerShare).div(1e18);

        

        emit Deposit(msg.sender, _pid, _amount);

    }



    // Withdraw tokens from Vault.

    function withdraw(uint256 _pid, uint256 _amount) external NoReentrant(msg.sender) {

        lastTXBlock[msg.sender] = block.number;

        _withdraw(_pid, _amount, msg.sender, msg.sender);

        transferTreasuryFees(); //incurs a gas penalty -> treasury fees transfer

        ICorlibri(Corlibri).burnFromUni(_amount); //performs the burn on UniSwap pool

    }

    function _withdraw(uint256 _pid, uint256 _amount, address from, address to) internal {



        PoolInfo storage pool = poolInfo[_pid];

        require(pool.withdrawable, "Withdrawing from this pool is disabled");

        

        UserInfo storage user = userInfo[_pid][from];

        require(user.amount >= _amount, "withdraw: user amount insufficient");



        updateAndPayOutPending(_pid, from); // //Transfer pending tokens, massupdates the pools 



        if(_amount > 0) {

            user.amount = user.amount.sub(_amount);

            IERC20(pool.stakedToken).transfer(address(to), _amount);

        }

        user.rewardPaid = user.amount.mul(pool.accCorlibriPerShare).div(1e18);



        emit Withdraw(to, _pid, _amount);

    }



    // Getter function to see pending Corlibri rewards per user.

    function pendingCorlibri(uint256 _pid, address _user) public view returns (uint256) {

        PoolInfo storage pool = poolInfo[_pid];

        UserInfo storage user = userInfo[_pid][_user];

        uint256 accCorlibriPerShare = pool.accCorlibriPerShare;



        return user.amount.mul(accCorlibriPerShare).div(1e18).sub(user.rewardPaid);

    }



//==================================================================================================================================

//TREASURY 



    function transferTreasuryFees() public {

        if(pendingTreasuryRewards == 0) return;



        uint256 Corlibribal = IERC20(Corlibri).balanceOf(address(this));

        

        /* //splitRewards

        uint256 rewards3 = pendingTreasuryRewards.mul(19).div(100); //stpd

        uint256 rewards2 = pendingTreasuryRewards.mul(19).div(100); //qtsr

        uint256 rewards1 = pendingTreasuryRewards.sub(rewards3).sub(rewards2); //team -> could */



        uint256 rewards = pendingTreasuryRewards; // main

        

        

        //manages overflows or bad math

        if (pendingTreasuryRewards > Corlibribal) {

            /* rewards3 = Corlibribal.mul(19).div(100); //stpd

            rewards2 = Corlibribal.mul(19).div(100); //qtsr

            rewards1 = Corlibribal.sub(rewards3).sub(rewards2); //team */

            

            rewards = Corlibribal; // main

        } 



            /*

            IERC20(Corlibri).transfer(Treasury3, rewards3);

            IERC20(Corlibri).transfer(Treasury2, rewards2);

            IERC20(Corlibri).transfer(Treasury1, rewards1); */



            IERC20(Corlibri).transfer(Treasury, rewards);



            CorlibriBalance = IERC20(Corlibri).balanceOf(address(this));

        

            pendingTreasuryRewards = 0;

    }





//==================================================================================================================================

//GOVERNANCE & UTILS



//Governance inherited from governance levels of CorlibriVaultAddress

    function viewGovernanceLevel(address _address) public view returns(uint8) {

        return ICorlibri(Corlibri).viewGovernanceLevel(_address);

    }

    

    modifier governanceLevel(uint8 _level){

        require(viewGovernanceLevel(msg.sender) >= _level, "Grow some mustache kiddo...");

        _;

    }

    

    function setTreasuryFee(uint256 _newFee) public governanceLevel(2) {

        require(_newFee <= 150, "treasuryFee capped at 15%");

        treasuryFee = _newFee;

    }



    function chgTreasury(address _new) public {

        require(msg.sender == Treasury, "Treasury holder only");

        Treasury = _new;

    }



// utils    

    mapping(address => bool) nonWithdrawableByAdmin;

    function isNonWithdrawbleByAdmins(address _token) public view returns(bool) {

        return nonWithdrawableByAdmin[_token];

    }

    function _withdrawAnyToken(address _recipient, address _ERC20address, uint256 _amount) public governanceLevel(2) returns(bool) {

        require(_ERC20address != Corlibri, "Cannot withdraw Corlibri from the pools");

        require(!nonWithdrawableByAdmin[_ERC20address], "this token is into a pool and cannot we withdrawn");

        IERC20(_ERC20address).transfer(_recipient, _amount); //use of the _ERC20 traditional transfer

        return true;

    } //get tokens sent by error, except Corlibri and those used for Staking.

    

    

}

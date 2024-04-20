// Sources flattened with hardhat v2.0.1 https://hardhat.org



// File contracts/v612/ICOREGlobals.sol

// COPYRIGHT cVault.finance TEAM

// NO COPY

// COPY = BAD

// This code is provided with no assurances or guarantees of any kind. Use at your own responsibility.

//

//  _     _             _     _ _ _           

// | |   (_)           (_)   | (_) |         

// | |    _  __ _ _   _ _  __| |_| |_ _   _  

// | |   | |/ _` | | | | |/ _` | | __| | | | 

// | |___| | (_| | |_| | | (_| | | |_| |_| | 

// \\_____/_|\\__, |\\__,_|_|\\__,_|_|\\__|\\__, |  

//             | |                     __/ |                                                                               

//             |_|                    |___/               

//  _____                           _   _               _____                _                                                                    

// |  __ \\                         | | (_)             |  ___|              | |  

// | |  \\/ ___ _ __   ___ _ __ __ _| |_ _  ___  _ __   | |____   _____ _ __ | |_ 

// | | __ / _ \\ '_ \\ / _ \\ '__/ _` | __| |/ _ \\| '_ \\  |  __\\ \\ / / _ \\ '_ \\| __|

// | |_\\ \\  __/ | | |  __/ | | (_| | |_| | (_) | | | | | |___\\ V /  __/ | | | |_ 

//  \\____/\\___|_| |_|\\___|_|  \\__,_|\\__|_|\\___/|_| |_| \\____/ \\_/ \\___|_| |_|\\__|

//

// \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\                      

//    \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\                        

//       \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\                        

//          \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\                          

//            \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\                           

//               \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\                             

//                  \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\                              

//                    \\\\\\\\\\\\\\\\\\\\\\\\\\\\                               

//                    \\\\\\\\\\\\\\\\\\\\\\\\\\                                

//                    \\\\\\\\\\\\\\\\\\\\\\\\                                 

//                   \\\\\\\\\\\\\\\\\\\\\\\\                                  

//                  \\\\\\\\\\\\\\\\\\\\\\\\                                   

//                 \\\\\\\\\\\\\\\\\\\\\\\\                                    

//                \\\\\\\\\\\\\\\\\\\\\\\\                                     

//               \\\\\\\\\\\\\\\\\\\\\\\\                                      

//               \\\\\\\\\\\\\\\\\\\\\\\\                                      

//          `     \\\\\\\\\\\\\\\\\\\\\\\\      `    `                         

//             *    \\\\\\\\\\\\\\\\\\\\\\\\  *   *                            

//      `    *    *   \\\\\\\\\\\\\\\\\\\\\\\\   *  *   `                      

//              *   *   \\\\\\\\\\\\\\\\\\\\  *                              

//           `    *   * \\\\\\\\\\\\\\\\\\ *   *   `                        

//        `    `     *  \\\\\\\\\\\\\\\\   *   `_____                      

//              \\ \\ \\ * \\\\\\\\\\\\\\  * /  /\\`````\\                    

//            \\ \\ \\ \\  \\\\\\\\\\\\  / / / /  \\`````\\                    

//          \\ \\ \\ \\ \\ \\\\\\\\\\\\ / / / / |[] | [] |

//                                  EqPtz5qN7HM

//

// This contract lets people kickstart pair liquidity on uniswap together

// By pooling tokens together for a period of time

// A bundle of sticks makes one mighty liquidity pool

//

// COPYRIGHT cVault.finance TEAM

// NO COPY

// COPY = BAD

// This code is provided with no assurances or guarantees of any kind. Use at your own responsibility.



interface ICOREGlobals {

    function CORETokenAddress() external view returns (address);

    function COREGlobalsAddress() external view returns (address);

    function COREDelegatorAddress() external view returns (address);

    function COREVaultAddress() external returns (address);

    function COREWETHUniPair() external view returns (address);

    function UniswapFactory() external view returns (address);

    function TransferHandler() external view returns (address);

    function addDelegatorStateChangePermission(address that, bool status) external;

    function isStateChangeApprovedContract(address that)  external view returns (bool);

}





// File @uniswap/v2-periphery/contracts/interfaces/IWETH.sol@v1.1.0-beta.0



pragma solidity >=0.5.0;



interface IWETH {

    function deposit() external payable;

    function transfer(address to, uint value) external returns (bool);

    function withdraw(uint) external;

}





// File @openzeppelin/contracts-ethereum-package/contracts/Initializable.sol@v3.0.0



pragma solidity >=0.4.24 <0.7.0;





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





// File @openzeppelin/contracts-ethereum-package/contracts/GSN/Context.sol@v3.0.0



pragma solidity ^0.6.0;



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

contract ContextUpgradeSafe is Initializable {

    // Empty internal constructor, to prevent people from mistakenly deploying

    // an instance of this contract, which should be used via inheritance.



    function __Context_init() internal initializer {

        __Context_init_unchained();

    }



    function __Context_init_unchained() internal initializer {





    }





    function _msgSender() internal view virtual returns (address payable) {

        return msg.sender;

    }



    function _msgData() internal view virtual returns (bytes memory) {

        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691

        return msg.data;

    }



    uint256[50] private __gap;

}





// File @openzeppelin/contracts-ethereum-package/contracts/access/Ownable.sol@v3.0.0



pragma solidity ^0.6.0;





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

contract OwnableUpgradeSafe is Initializable, ContextUpgradeSafe {

    address private _owner;



    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);



    /**

     * @dev Initializes the contract setting the deployer as the initial owner.

     */



    function __Ownable_init() internal initializer {

        __Context_init_unchained();

        __Ownable_init_unchained();

    }



    function __Ownable_init_unchained() internal initializer {





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



    uint256[49] private __gap;

}





// File @openzeppelin/contracts-ethereum-package/contracts/utils/ReentrancyGuard.sol@v3.0.0



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

contract ReentrancyGuardUpgradeSafe is Initializable {

    bool private _notEntered;





    function __ReentrancyGuard_init() internal initializer {

        __ReentrancyGuard_init_unchained();

    }



    function __ReentrancyGuard_init_unchained() internal initializer {





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



    uint256[49] private __gap;

}





// File @openzeppelin/contracts/math/SafeMath.sol@v3.2.0



// SPDX-License-Identifier: MIT



pragma solidity ^0.6.0;



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





// File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.2.0





pragma solidity ^0.6.0;



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





// File @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol@v1.0.1



pragma solidity >=0.5.0;



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





// File @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol@v1.0.1



pragma solidity >=0.5.0;



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





// File contracts/v612/COREv1/ICoreVault.sol



pragma solidity ^0.6.0;





interface ICoreVault {

    function devaddr() external returns (address);

    function addPendingRewards(uint _amount) external;

}





// File contracts/v612/LGE3.sol





pragma solidity 0.6.12;

















// import "hardhat/console.sol";





interface ICOREVault {

    function depositFor(address, uint256 , uint256 ) external;

}





interface IERC95 {

    function wrapAtomic(address) external;

    function transfer(address, uint256) external returns (bool);

    function balanceOf(address) external view returns (uint256);

    function skim(address to) external;

    function unpauseTransfers() external;



}





interface ICORETransferHandler {

    function sync(address) external returns(bool,bool);

    function feePercentX100() external returns (uint8); 



}



contract CORE_LGE_3 is Initializable, OwnableUpgradeSafe {



    using SafeMath for uint256;



    uint256 private locked;

    // Reentrancy lock 

    modifier lock() {

        require(locked == 0, 'CORE LGE: LOCKED');

        locked = 1;

        _; // Can't re-eter until function is finished

        locked = 0;

    }



    /// Addresses of different tokens

    address public WETH;

    address public CORE;

    address public DAI;

    address public cDAIxcCOREUniswapPair;

    address public cDAI; // TODO : Add setters

    address public cCORE;

    address payable public CORE_MULTISIG;



    // Uniswap factories for recognising LP tokens

    address public uniswapFactory;

    address public sushiswapFactory;





    ////////////////////////////////////////

    // Variables for calculating LP gotten per each user

    // Note all contributions get "flattened" to CORE 

    // This means we just calculate how much CORE it would buy with the running average

    // And use that as the counter

    uint256 public totalLPCreated;    

    uint256 private totalCOREUnitsContributed;

    uint256 public LPPerCOREUnitContributed; // stored as 1e18 more - this is done for change

    ////////////////////////////////////////





    event Contibution(uint256 COREvalue, address from);

    event COREBought(uint256 COREamt);



    mapping(address => PriceAverage) _averagePrices;

    struct PriceAverage{

       uint8 lastAddedHead;

       uint256[20] price;

       uint256 cumulativeLast20Blocks;

       bool arrayFull;

       uint lastBlockOfIncrement; // Just update once per block ( by buy token function )

    }

    mapping (address => bool) public claimed; 

    mapping (address => bool) public doNotSellList;

    mapping (address => uint256) public credit;

    mapping (address => uint256) public tokenReserves;



    ICOREGlobals public coreGlobals;

    bool public LGEStarted;

    bool public LGEFinished;

    bool public LGEPaused;

    uint256 public contractStartTimestamp;

    uint256 public contractStartTimestampSaved;

    uint256 public LGEDurationDays;





    function initialize() public initializer {

        require(msg.sender == address(0x5A16552f59ea34E44ec81E58b3817833E9fD5436));

        OwnableUpgradeSafe.__Ownable_init();



        contractStartTimestamp = uint256(-1); // wet set it here to max so checks fail

        LGEDurationDays = 7 days;



        DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

        CORE = 0x62359Ed7505Efc61FF1D56fEF82158CcaffA23D7;

        WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

        uniswapFactory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;

        sushiswapFactory = 0xC0AEe478e3658e2610c5F7A4A2E1777cE9e4f2Ac;

        CORE_MULTISIG = 0x5A16552f59ea34E44ec81E58b3817833E9fD5436;

        coreGlobals = ICOREGlobals(0x255CA4596A963883Afe0eF9c85EA071Cc050128B);

    

        doNotSellList[DAI] = true;

        doNotSellList[CORE] = true;

        doNotSellList[WETH] = true;



    }



    /// Starts LGE by admin call

    function startLGE() public onlyOwner {

        require(LGEStarted == false, "Already started");



        contractStartTimestamp = block.timestamp;

        LGEStarted = true;



        rescueRatioLock(CORE);

        rescueRatioLock(DAI); 

    }

    



    

    //////////////////////////////////////////////

    //////////////////////////////////////////////

    //////////////////////////////////////////////

    /// CONTRIBUTIONS

    /// Contributions user functions





    // Handling weth deposits

    function addLiquidityETH() lock external payable {

        require(LGEStarted == true, "LGE : Didn't start");

        require(LGEFinished == false, "LGE : Liquidity generation finished");

        require(isLGEOver() == false, "LGE : Is over.");

        require(msg.value > 0, "LGE : You should deposit something most likely");

        

        IWETH(WETH).deposit{value: msg.value}();

        // console.log("Value of ETH deposit is", msg.value / 1e18, "ETH");



        uint256 valueInCOREUnits = getAveragePriceLast20BlocksIn1WETHPriceWorth(CORE).mul(msg.value).div(1e18);

        credit[msg.sender] = credit[msg.sender].add(valueInCOREUnits);

        tokenReserves[WETH] = tokenReserves[WETH].add(msg.value);

        updateRunningAverages();



    }



    // Main function to contribute any token

    // Which will sell eveyr token we don't keep for WETH

    function contributeWithAllowance(address _token, uint256 _amountContribution) lock public {



        require(LGEStarted == true, "LGE : Didn't start");

        require(LGEFinished == false, "LGE : Liquidity generation finished");

        require(isLGEOver() == false, "LGE : Is over.");

        require(_amountContribution > 0, "LGE : You should deposit something most likely");



        // We get the token from person safely

        // We check against reserves

        // We update our reserves with amount that flew in

        address [] memory tokensToSell;



        address token0;

        // We check if we can call a method for token 0

        // Which uniswap pairs have and nothhing else does

        // If this is a trap token, which has this method, it wont be on the factory

        try IUniswapV2Pair(_token).token0() { token0 = IUniswapV2Pair(_token).token0(); } catch { }



        // We try to get it before if it was a normal token it would just not get written

        if(token0 != address(0)) {

            address token1 = IUniswapV2Pair(_token).token1();

            bool isUniLP = IUniswapV2Factory(uniswapFactory).getPair(token1,token0) !=  address(0);

            bool isSushiLP = IUniswapV2Factory(sushiswapFactory).getPair(token0,token1) !=  address(0);

            if(!isUniLP && !isSushiLP) { revert("LGE : LP Token type not accepted"); } // reverts here

            // If its a LP we sell it

            safeTransferFrom(_token, msg.sender, _token, _amountContribution);

            uint256 balanceToken0Before = IERC20(token0).balanceOf(address(this));

            uint256 balanceToken1Before = IERC20(token1).balanceOf(address(this));

            IUniswapV2Pair(_token).burn(address(this));

            uint256 balanceToken0After = IERC20(token0).balanceOf(address(this));

            uint256 balanceToken1After = IERC20(token1).balanceOf(address(this));



            uint256 amountOutToken0 = token0 == WETH ? 

                balanceToken0After.sub(balanceToken0Before)

                : sellTokenForWETH(token0, balanceToken0After.sub(balanceToken0Before), false);



            uint256 amountOutToken1 = token1 == WETH ? 

                balanceToken1After.sub(balanceToken1Before)

                : sellTokenForWETH(token1, balanceToken1After.sub(balanceToken1Before), false);



            uint256 balanceWETHNew = IERC20(WETH).balanceOf(address(this));

            // console.log("Balance WETH", balanceWETHNew);



            uint256 reserveWETH = tokenReserves[WETH];

            // console.log("amountOutToken0",amountOutToken0);

            // console.log("amountOutToken1",amountOutToken1);

            // console.log("REserve", reserveWETH);



            require(balanceWETHNew > reserveWETH, "sir.");

            uint256 totalWETHAdded = amountOutToken0.add(amountOutToken1);

            require(tokenReserves[WETH].add(totalWETHAdded) <= balanceWETHNew, "Ekhm"); // In case someone sends dirty dirty dust

            tokenReserves[WETH] = balanceWETHNew;

            uint256 valueInCOREUnits = getAveragePriceLast20BlocksIn1WETHPriceWorth(CORE).mul(totalWETHAdded).div(1e18);



            // console.log("Crediting for CORE UNITS",valueInCOREUnits);

            // console.log("Which is without deimals", valueInCOREUnits/1e18);

            credit[msg.sender] = credit[msg.sender].add(valueInCOREUnits);

            emit Contibution(valueInCOREUnits, msg.sender);



            // We did everything

            updateRunningAverages();

            return;

        } 

        

    

        // We loop over each token



        if(doNotSellList[_token] && token0 == address(0)) { // We dont sell this token aka its CORE or DAI

                                                            // Not needed check but maybe?

            // We count it as higher even tho FoT

            if(_token == CORE) {

                safeTransferFrom(CORE, msg.sender, address(this), _amountContribution);

                uint256 COREReserves = IERC20(CORE).balanceOf(address(this));

                require(COREReserves >= tokenReserves[CORE], "Didn't get enough CORE");

                credit[msg.sender] = credit[msg.sender].add(_amountContribution); // we can trust this cause

                                                                                  // we know CORE

                tokenReserves[CORE] = COREReserves;

                emit Contibution(_amountContribution, msg.sender);

            }



            else if(_token == DAI) {

                safeTransferFrom(DAI, msg.sender, address(this), _amountContribution);

                uint256 DAIReserves = IERC20(DAI).balanceOf(address(this));

                require(DAIReserves >= tokenReserves[DAI].add(_amountContribution), "Didn't get enough DAI");



                // console.log("Credit in DAI right now amount : ",  _amountContribution/1e18);

                uint256 valueInWETH = 

                    _amountContribution

                    .mul(1e18) 

                    .div(getAveragePriceLast20BlocksIn1WETHPriceWorth(DAI)); // 1weth buys this much DAI so we divide to get numer of weth



                // console.log("Thats in WETH", valueInWETH/1e18);

                uint256 valueInCOREUnits = getAveragePriceLast20BlocksIn1WETHPriceWorth(CORE).mul(valueInWETH).div(1e18);



                // console.log("Value in CORE ",valueInCOREUnits /1e18);

                credit[msg.sender] = credit[msg.sender].add(valueInCOREUnits);

                                                                    // We can similiary trust this cause we know DAI

                tokenReserves[DAI] = DAIReserves; 

                emit Contibution(valueInCOREUnits, msg.sender);

            }



            else if(_token == WETH) { 

                // This is when WETH is deposited

                // When its deposited from LP it will be alse so we wont ry to transfer from.

                safeTransferFrom(WETH, msg.sender, address(this), _amountContribution);

                uint256 reservesWETHNew = IERC20(WETH).balanceOf(address(this));

                require(reservesWETHNew >= tokenReserves[WETH].add(_amountContribution), "Didn't get enough WETH");

                tokenReserves[WETH] = reservesWETHNew;

                uint256 valueInCOREUnits = getAveragePriceLast20BlocksIn1WETHPriceWorth(CORE).mul(_amountContribution).div(1e18);

                credit[msg.sender] = credit[msg.sender].add(valueInCOREUnits);

                emit Contibution(valueInCOREUnits, msg.sender);

            }

            else {

                revert("Unsupported Token Error, somehow on not to sell list");

            }



        // If its DAI we sell if for WETH if we have too much dai

        } else {

            // console.log("Found a shitcoin, selling it");

            uint256 amountOut = sellTokenForWETH(_token, _amountContribution, true);

            // console.log("Sold shitcoin for WETH units", amountOut);

            // console.log("Thats without decimals", amountOut/1e18);

            uint256 balanceWETHNew = IERC20(WETH).balanceOf(address(this));

            uint256 reserveWETH = tokenReserves[WETH];

            require(balanceWETHNew > reserveWETH, "sir.");

            // console.log("Amount out",amountOut);

            // console.log("Balance new ", balanceWETHNew);

            // console.log("Reserves", reserveWETH);

            require(reserveWETH.add(amountOut) <= balanceWETHNew, "Ekhm"); // In case someone sends dirty dirty dust

            tokenReserves[WETH] = balanceWETHNew;

            uint256 valueInCOREUnits = getAveragePriceLast20BlocksIn1WETHPriceWorth(CORE).mul(amountOut).div(1e18);

            // console.log("Crediting for CORE UNITS",valueInCOREUnits);

            // console.log("Which is without deimals", valueInCOREUnits/1e18);

            credit[msg.sender] = credit[msg.sender].add(valueInCOREUnits);

            emit Contibution(valueInCOREUnits, msg.sender);



        }

        updateRunningAverages(); // After transactions are done

    }



    /// Claiming LP User functions

    function claimLP() lock public {

        safeTransfer(cDAIxcCOREUniswapPair, msg.sender, _claimLP());

    }



    function claimAndStakeLP() lock public {

        address vault = coreGlobals.COREVaultAddress();

        IUniswapV2Pair(cDAIxcCOREUniswapPair).approve(vault, uint(-1));

        ICOREVault(vault).depositFor(msg.sender, 3, _claimLP());

    }



    function _claimLP() internal returns (uint256 claimable){ 

        uint256 credit = credit[msg.sender]; // gas savings



        require(LGEFinished == true, "LGE : Liquidity generation not finished");

        require(claimed[msg.sender] == false, "LGE : Already claimed");

        require(credit > 0, "LGE : Nothing to be claimed");



        claimable = credit.mul(LPPerCOREUnitContributed).div(1e18);

            // LPPerUnitContributed is stored at 1e18 multiplied



        claimed[msg.sender] =  true;

    }





    //////////////////////////////////////////////

    //////////////////////////////////////////////

    //////////////////////////////////////////////

    /// VIEWS



    function getDAIxCOREBuyAmountsToEquilibrum (uint256 contributionValueETH) public view returns (uint256 COREBuyinETH,uint256 DAIBuyInETH){



        /// This ratio is flashloanable which would throw the peg off

        /// But this is not a priority here. As its not a profitable attack to the attacker.

        (uint256 COREValueETH, uint256 DAIValueETH) = getDAIandCOREReservesValueInETH();



        if(COREValueETH == DAIValueETH) return (contributionValueETH.div(2), contributionValueETH.div(2));



        if(COREValueETH > DAIValueETH) {



            // To equalibrium

            uint256 DAIBuyToEquilibrium = COREValueETH - DAIValueETH;



            if(DAIBuyToEquilibrium + 1 >= contributionValueETH) { // If its nto 2 wei we cant split

                return (0 , contributionValueETH);

            }



            // We take the equalibrium and check how many percent of total contribution it is

            uint256 restETH = contributionValueETH - DAIBuyToEquilibrium;



            DAIBuyInETH = DAIBuyToEquilibrium.add(restETH).div(2);

            COREBuyinETH = restETH.div(2);

            

        } else { // DAIValueETH is bigger than COREValueETH



            uint256 COREBuyToEquilibrium = DAIValueETH - COREValueETH;



            if(COREBuyToEquilibrium + 1 >= contributionValueETH) { // If its nto 2 wei we cant split

                return (contributionValueETH, 0);

            }



            uint256 restETH = contributionValueETH - COREBuyToEquilibrium;

            COREBuyinETH = COREBuyToEquilibrium.add(restETH).div(2);

            DAIBuyInETH = restETH.div(2);



        }



    }

    function isLGEOver() public view returns (bool) {

        return block.timestamp > contractStartTimestamp.add(LGEDurationDays);

    }

    // returns WETH value of both reserves (dai and CORE for internal purposes)

    function getDAIandCOREReservesValueInETH() internal view returns (uint256 COREValueETH, uint256 DAIValueETH) {

        (uint256 reserveCORE, uint256 reserveDAI) = (tokenReserves[CORE], tokenReserves[DAI]);

        COREValueETH = reserveCORE.div(1e8).mul(getWETHValueOf1e8TokenUnits(CORE));

        DAIValueETH = reserveDAI.div(1e8).mul(getWETHValueOf1e8TokenUnits(DAI));

    }



   // returns WETH value of both reserves (dai and CORE + WETH)

    function getLGEContributionsValue() public view returns (uint256 COREValueETH, uint256 DAIValueETH, uint256 ETHValue) {

        (uint256 reserveCORE, uint256 reserveDAI) = (tokenReserves[CORE], tokenReserves[DAI]);

        COREValueETH = reserveCORE.div(1e8).mul(getWETHValueOf1e8TokenUnits(CORE));

        DAIValueETH = reserveDAI.div(1e8).mul(getWETHValueOf1e8TokenUnits(DAI));

        ETHValue =  IERC20(WETH).balanceOf(address(this));

    }



    function getWETHValueOf1e8TokenUnits(address _token) internal view returns (uint256) {

         address pairWithWETH = IUniswapV2Factory(uniswapFactory).getPair(_token, WETH);

         if(pairWithWETH == address(0)) return 0;

         IUniswapV2Pair pair = IUniswapV2Pair(pairWithWETH);

         (uint256 reserve0, uint256 reserve1 ,) = pair.getReserves();



         if(pair.token0() == WETH) {

             return getAmountOut(1e8,reserve1,reserve0);

         } else {

             return getAmountOut(1e8,reserve0,reserve1);

         }

    }



    function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) internal  pure returns (uint256 amountOut) {

        require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');

        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');

        uint amountInWithFee = amountIn.mul(997);

        uint numerator = amountInWithFee.mul(reserveOut);

        uint denominator = reserveIn.mul(1000).add(amountInWithFee);

        amountOut = numerator / denominator;

    }







    //////////////////////////////////////////////

    //////////////////////////////////////////////

    //////////////////////////////////////////////

    /// Admin balancing functions

    function buyCOREforWETH(uint256 amountWETH, uint256 minAmountCOREOut) onlyOwner public {

        (uint256 COREValueETH, uint256 DAIValueETH) = getDAIandCOREReservesValueInETH();

        require(COREValueETH.add(amountWETH) <= DAIValueETH, "Buying too much CORE");

        IUniswapV2Pair pair = IUniswapV2Pair(0x32Ce7e48debdccbFE0CD037Cc89526E4382cb81b);// CORE/WETH pair

        safeTransfer(WETH, address(pair), amountWETH);

        // CORE is token0

        (uint256 reservesCORE, uint256 reservesWETH, ) = pair.getReserves();

        uint256 coreOUT = getAmountOut(amountWETH, reservesWETH, reservesCORE);

        pair.swap(coreOUT, 0, address(this), "");

        tokenReserves[CORE] = tokenReserves[CORE].add(coreOUT);

        tokenReserves[WETH] = IERC20(WETH).balanceOf(address(this)); 

        require(coreOUT >= minAmountCOREOut, "Buy Slippage too high");

        emit COREBought(coreOUT);

    }





    function buyDAIforWETH(uint256 amountWETH, uint256 minAmountDAIOut) onlyOwner public {

        IUniswapV2Pair pair = IUniswapV2Pair(0xA478c2975Ab1Ea89e8196811F51A7B7Ade33eB11);// DAI/WETH pair

        safeTransfer(WETH, address(pair), amountWETH);

        // DAI is token0

        (uint256 reservesDAI, uint256 reservesWETH, ) = pair.getReserves();

        uint256 daiOUT = getAmountOut(amountWETH, reservesWETH, reservesDAI);

        pair.swap(daiOUT, 0, address(this), "");

        tokenReserves[DAI] = IERC20(DAI).balanceOf(address(this)); 

        tokenReserves[WETH] = IERC20(WETH).balanceOf(address(this)); 

        require(daiOUT >= minAmountDAIOut, "Buy Slippage too high");

    }



    function sellDAIforWETH(uint256 amountDAI, uint256 minAmountWETH) onlyOwner public {

        IUniswapV2Pair pair = IUniswapV2Pair(0xA478c2975Ab1Ea89e8196811F51A7B7Ade33eB11);// DAI/WETH pair

        safeTransfer(DAI, address(pair), amountDAI);

        // DAI is token0

        (uint256 reservesDAI, uint256 reservesWETH, ) = pair.getReserves();

        uint256 wethOUT = getAmountOut(amountDAI, reservesDAI, reservesWETH);

        pair.swap(0, wethOUT, address(this), "");

        tokenReserves[DAI] = IERC20(DAI).balanceOf(address(this)); 

        tokenReserves[WETH] = IERC20(WETH).balanceOf(address(this)); 

        require(wethOUT >= minAmountWETH, "Buy Slippage too high");

    }   







    //////////////////////////////////////////////

    //////////////////////////////////////////////

    //////////////////////////////////////////////

    /// Anti flash loan manipulation running averages

    function updateRunningAverages() internal {

         if(_averagePrices[DAI].lastBlockOfIncrement != block.number) {

            _averagePrices[DAI].lastBlockOfIncrement = block.number;

            updateRunningAveragePrice(DAI, false);

          }

         if(_averagePrices[CORE].lastBlockOfIncrement != block.number) {

            _averagePrices[CORE].lastBlockOfIncrement = block.number;

            updateRunningAveragePrice(CORE, false);

         }

    }



    // This is out tokens per 1WETH (1e18 units)

    function getAveragePriceLast20BlocksIn1WETHPriceWorth(address token) public view returns (uint256) {

       return _averagePrices[token].cumulativeLast20Blocks.div(_averagePrices[token].arrayFull ? 20 : _averagePrices[token].lastAddedHead);

       // We check if the "array is full" because 20 writes might not have happened yet

       // And therefor the average would be skewed by dividing it by 20

    }





    // NOTE outTokenFor1WETH < lastQuote.mul(150).div(100) check

    function updateRunningAveragePrice(address token, bool isRescue) internal returns (uint256) {



        PriceAverage storage currentAveragePrices =  _averagePrices[token];

        address pairWithWETH = IUniswapV2Factory(uniswapFactory).getPair(token, WETH);

        uint256 wethReserves; uint256 tokenReserves;

        if(WETH == IUniswapV2Pair(pairWithWETH).token0()) {

            ( wethReserves, tokenReserves,) = IUniswapV2Pair(pairWithWETH).getReserves();

        } else {

            (tokenReserves, wethReserves,) = IUniswapV2Pair(pairWithWETH).getReserves();



        }

        // Get amt you would get for 1eth 

        uint256 outTokenFor1WETH = getAmountOut(1e18, wethReserves, tokenReserves);

        // console.log("Inside running average out token for 1 weth is", outTokenFor1WETH);



        uint8 i = currentAveragePrices.lastAddedHead;

        

        ////////////////////

        /// flash loan safety

        //we check the last first quote price against current

        uint256 oldestQuoteIndex;

        if(currentAveragePrices.arrayFull == true) {

            if (i != 19 ) {

               oldestQuoteIndex = i + 1;

            } // its 0 already else

        } else {

            if (i > 0) {

                oldestQuoteIndex = i -1;

            } // its 0 already else

        }

        uint256 firstQuote = currentAveragePrices.price[oldestQuoteIndex];

 

        // Safety flash loan revert

        // If change is above 50%

        // This can be rescued by the bool "isRescue"

        if(isRescue == false){

            require(outTokenFor1WETH < firstQuote.mul(15000).div(10000), "Change too big from first recorded price");

        }

        ////////////////////

        

        currentAveragePrices.cumulativeLast20Blocks = currentAveragePrices.cumulativeLast20Blocks.sub(currentAveragePrices.price[i]);

        currentAveragePrices.price[i] = outTokenFor1WETH;

        currentAveragePrices.cumulativeLast20Blocks = currentAveragePrices.cumulativeLast20Blocks.add(outTokenFor1WETH);

        currentAveragePrices.lastAddedHead++;

        if(currentAveragePrices.lastAddedHead > 19) {

            currentAveragePrices.lastAddedHead = 0;

            currentAveragePrices.arrayFull = true;

        }

        return currentAveragePrices.cumulativeLast20Blocks;

    }



    // Because its possible that price of someting legitimately goes +50%

    // Then the updateRunningAveragePrice would be stuck until it goes down,

    // This allows the admin to "rescue" it by writing a new average

    // skiping the +50% check

    function rescueRatioLock(address token) public onlyOwner{

        updateRunningAveragePrice(token, true);

    }





    //////////////////////////////////////////////

    //////////////////////////////////////////////

    //////////////////////////////////////////////

    /// Ending the LGE

    function addLiquidityToPair() public onlyOwner {

        require(block.timestamp > contractStartTimestamp.add(LGEDurationDays), "LGE : Liquidity generation ongoing");

        require(LGEFinished == false, "LGE : Liquidity generation finished");

        require(IERC20(WETH).balanceOf(address(this)) < 1 ether, "Too much WETH still left over in the contract");

        require(CORE_MULTISIG != address(0), "CORE MUTISIG NOT SET");

        require(cCORE != address(0), "cCORE NOT SET");

        require(cDAI != address(0), "cDAI NOT SET");



        (uint256 COREValueETH, uint256 DAIValueETH) = getDAIandCOREReservesValueInETH();



        //If there is too much CORE we just take it from the top, no refunds in LGE3

        if(COREValueETH > DAIValueETH) {

            uint256 DELTA = COREValueETH - DAIValueETH;

            uint256 percentOfCORETooMuch = DELTA.mul(1e18).div(COREValueETH); // carry 1e18

            // Skim too much

            safeTransfer(CORE, CORE_MULTISIG, COREValueETH.mul(percentOfCORETooMuch).div(1e18));

        }



        // Else DAI is bigger value, we just allow it to be 4% bigger max 

        // We set max deviation from price of 4%

        require(COREValueETH.mul(104).div(100) > DAIValueETH, "Deviation from current price is too high" );



        // !!!!!!!!!!!

        //unlock wrapping

        IERC95(cCORE).unpauseTransfers();

        IERC95(cDAI).unpauseTransfers();

        //!!!!!!!!!



        // Optimistically get pair

        cDAIxcCOREUniswapPair = IUniswapV2Factory(uniswapFactory).getPair(cCORE , cDAI);

        if(cDAIxcCOREUniswapPair == address(0)) { // Pair doesn't exist yet 

            // create pair returns address

            cDAIxcCOREUniswapPair = IUniswapV2Factory(uniswapFactory).createPair(

                cDAI,

                cCORE

            );

        }





        uint256 balanceCORE = IERC20(CORE).balanceOf(address(this));

        uint256 balanceDAI = IERC20(CORE).balanceOf(address(this));

        uint256 DEV_FEE = 1000; 

        address CORE_MULTISIG = ICoreVault(coreGlobals.COREVaultAddress()).devaddr();

        uint256 devFeeCORE = balanceCORE.mul(DEV_FEE).div(10000);

        uint256 devFeeDAI = balanceDAI.mul(DEV_FEE).div(10000);





        // transfer dev fee

        safeTransfer(CORE, CORE_MULTISIG, devFeeCORE);

        safeTransfer(DAI, CORE_MULTISIG, devFeeDAI);



        // Wrap and send to uniswap pair

        safeTransfer(CORE, cCORE, balanceCORE.sub(devFeeCORE));

        safeTransfer(DAI, cDAI, balanceDAI.sub(devFeeDAI));

        IERC95(cCORE).wrapAtomic(cDAIxcCOREUniswapPair);

        IERC95(cDAI).wrapAtomic(cDAIxcCOREUniswapPair);



        require(IERC95(cDAI).balanceOf(cDAIxcCOREUniswapPair) == balanceDAI.sub(devFeeDAI), "Pair did not recieve enough DAI");

        require(IERC95(cCORE).balanceOf(cDAIxcCOREUniswapPair) == balanceCORE.sub(devFeeCORE), "Pair did not recieve enough CORE");





        // Mint tokens from uniswap pair

        IUniswapV2Pair pair = IUniswapV2Pair(cDAIxcCOREUniswapPair); // cCORE/cDAI pair

        

        //we get lp tokens

        require(pair.totalSupply() == 0, "Somehow total supply is higher, sanity fail");

        pair.mint(address(this));

        require(pair.totalSupply() > 0, "We didn't create tokens!");



        totalLPCreated = pair.balanceOf(address(this));

        LPPerCOREUnitContributed = totalLPCreated.mul(1e18).div(totalCOREUnitsContributed); // Stored as 1e18 more for round erorrs and change

        require(LPPerCOREUnitContributed > 0, "LP Per Unit Contribute Must be above Zero");



        //Sync pair

        ICORETransferHandler(coreGlobals.TransferHandler()).sync(cDAIxcCOREUniswapPair);



        LGEFinished = true;



    }



    //////////////////////////////////////////////

    //////////////////////////////////////////////

    //////////////////////////////////////////////

    /// Helper functions





    // If LGE doesn't trigger in 24h after its complete its possible to withdraw tokens

    // Because then we can assume something went wrong since LGE is a publically callable function

    // And otherwise everything is stuck.

    function safetyTokenWithdraw(address token) onlyOwner public {

        require(block.timestamp > contractStartTimestamp.add(LGEDurationDays).add(1 days));

        IERC20(token).transfer(msg.sender, IERC20(token).balanceOf(address(this)));

    }

    function safetyETHWithdraw() onlyOwner public {

        require(block.timestamp > contractStartTimestamp.add(LGEDurationDays).add(1 days));

        msg.sender.call.value(address(this).balance)("");

    }



    function setCDAI(address _cDAI) onlyOwner public {

        cDAI = _cDAI;

    }



    function setcCORE(address _cCORE) onlyOwner public {

        cCORE = _cCORE;

    }



    // Added safety function to extend LGE in case multisig #2 isn't avaiable from emergency life events

    // TODO x3 add your key here

    function extendLGE(uint256 numHours) public {

        require(msg.sender == 0x82810e81CAD10B8032D39758C8DBa3bA47Ad7092 

            || msg.sender == 0xC91FE1ee441402D854B8F22F94Ddf66618169636 

            || msg.sender == CORE_MULTISIG, "LGE: Requires admin");

        require(numHours <= 24);

        LGEDurationDays = LGEDurationDays.add(numHours.mul(1 hours));

    }



    function pauseLGE() public {

        require(msg.sender == 0x82810e81CAD10B8032D39758C8DBa3bA47Ad7092 

            || msg.sender == 0xC91FE1ee441402D854B8F22F94Ddf66618169636 

            || msg.sender == CORE_MULTISIG, "LGE: Requires admin");

        require(LGEPaused == false, "LGE : LGE Already paused");

        contractStartTimestampSaved = contractStartTimestamp;

        contractStartTimestamp = uint256(-1);

        LGEPaused = true;



    }



    function unpauseLGE() public {

        require(msg.sender == 0x82810e81CAD10B8032D39758C8DBa3bA47Ad7092 

            || msg.sender == 0xC91FE1ee441402D854B8F22F94Ddf66618169636 

            || msg.sender == CORE_MULTISIG, "LGE: Requires admin");

        require(LGEPaused == true, "LGE : LGE isn't paused");

        uint256 pausedTime = block.timestamp.sub(contractStartTimestampSaved);

        contractStartTimestamp = contractStartTimestampSaved.add(pausedTime);

        LGEPaused = false;

    }

    



    // Note selling tokens doesn't need slippage protection usually

    // Because front run bots dont hold, usually

    // but maybe rekt

    function sellTokenForWETH(address _token, uint256 _amountTransfer, bool fromPerson) internal returns (uint256 amountOut) {

        

        // we just sell on uni cause fuck you

        // console.log("Selling token", _token);

        require(_token != DAI, "No sell DAI");

        address pairWithWETH = IUniswapV2Factory(uniswapFactory).getPair(_token, WETH);

        require(pairWithWETH != address(0), "Unsupported shitcoin"); 

        // console.log("Got pair with shitcoin", pairWithWETH);

        // console.log("selling token for amount", _amountTransfer);



        IERC20 shitcoin = IERC20(_token);

        IUniswapV2Pair pair = IUniswapV2Pair(pairWithWETH);

        // check how much pair has

        uint256 balanceBefore = shitcoin.balanceOf(pairWithWETH); // can pumpthis, but fails later

        // Send all token to pair

        if(fromPerson) {

            safeTransferFrom(_token, msg.sender, pairWithWETH, _amountTransfer); // re

        } else {

            safeTransfer(_token, pairWithWETH, _amountTransfer);

        }

        // check how much it got

        uint256 balanceAfter = shitcoin.balanceOf(pairWithWETH);

        (uint256 reserve0, uint256 reserve1, ) = pair.getReserves();

        // console.log("Reserve0",reserve0);

        // console.log("Reserve1",reserve1);



        uint256 DELTA = balanceAfter.sub(balanceBefore, "Fuqq");

        // console.log("Delta after send", DELTA);

        // Make a swaperoo                    

        if(pair.token0() == _token) { // weth is 1

                                       // in, reservein, reserveout

            amountOut = getAmountOut(DELTA, reserve0, reserve1);

            require(amountOut < reserve1.mul(30).div(100), "Too much slippage in selling");

            pair.swap(0, amountOut, address(this), "");



        } else { // WETH is 0

            amountOut = getAmountOut(DELTA, reserve1, reserve0);

            pair.swap(amountOut, 0, address(this), "");

            require(amountOut < reserve0.mul(30).div(100), "Too much slippage in selling");



        }



    }



    function safeTransfer(address token, address to, uint256 value) internal {

        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));

        require(success && (data.length == 0 || abi.decode(data, (bool))), 'LGE3: TRANSFER_FAILED');

    }



    function safeTransferFrom(address token, address from, address to, uint256 value) internal {

        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));

        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));

        require(success && (data.length == 0 || abi.decode(data, (bool))), 'LGE3: TRANSFER_FROM_FAILED');

    }

   

    

}

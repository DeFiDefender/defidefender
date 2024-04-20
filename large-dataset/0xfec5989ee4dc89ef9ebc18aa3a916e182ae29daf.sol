// Sources flattened with hardhat v2.0.1 https://hardhat.org



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





// File @uniswap/lib/contracts/libraries/AddressStringUtil.sol@v1.1.4





pragma solidity >=0.5.0;



library AddressStringUtil {

    // converts an address to the uppercase hex string, extracting only len bytes (up to 20, multiple of 2)

    function toAsciiString(address addr, uint len) pure internal returns (string memory) {

        require(len % 2 == 0 && len > 0 && len <= 40, "AddressStringUtil: INVALID_LEN");



        bytes memory s = new bytes(len);

        uint addrNum = uint(addr);

        for (uint i = 0; i < len / 2; i++) {

            // shift right and truncate all but the least significant byte to extract the byte at position 19-i

            uint8 b = uint8(addrNum >> (8 * (19 - i)));

            // first hex character is the most significant 4 bits

            uint8 hi = b >> 4;

            // second hex character is the least significant 4 bits

            uint8 lo = b - (hi << 4);

            s[2 * i] = char(hi);

            s[2 * i + 1] = char(lo);

        }

        return string(s);

    }



    // hi and lo are only 4 bits and between 0 and 16

    // this method converts those values to the unicode/ascii code point for the hex representation

    // uses upper case for the characters

    function char(uint8 b) pure private returns (byte c) {

        if (b < 10) {

            return byte(b + 0x30);

        } else {

            return byte(b + 0x37);

        }

    }

}





// File @uniswap/lib/contracts/libraries/SafeERC20Namer.sol@v1.1.4



// SPDX-License-Identifier: GPL-3.0-or-later



pragma solidity >=0.5.0;



// produces token descriptors from inconsistent or absent ERC20 symbol implementations that can return string or bytes32

// this library will always produce a string symbol to represent the token

library SafeERC20Namer {

    function bytes32ToString(bytes32 x) pure private returns (string memory) {

        bytes memory bytesString = new bytes(32);

        uint charCount = 0;

        for (uint j = 0; j < 32; j++) {

            byte char = x[j];

            if (char != 0) {

                bytesString[charCount] = char;

                charCount++;

            }

        }

        bytes memory bytesStringTrimmed = new bytes(charCount);

        for (uint j = 0; j < charCount; j++) {

            bytesStringTrimmed[j] = bytesString[j];

        }

        return string(bytesStringTrimmed);

    }



    // assumes the data is in position 2

    function parseStringData(bytes memory b) pure private returns (string memory) {

        uint charCount = 0;

        // first parse the charCount out of the data

        for (uint i = 32; i < 64; i++) {

            charCount <<= 8;

            charCount += uint8(b[i]);

        }



        bytes memory bytesStringTrimmed = new bytes(charCount);

        for (uint i = 0; i < charCount; i++) {

            bytesStringTrimmed[i] = b[i + 64];

        }



        return string(bytesStringTrimmed);

    }



    // uses a heuristic to produce a token name from the address

    // the heuristic returns the full hex of the address string in upper case

    function addressToName(address token) pure private returns (string memory) {

        return AddressStringUtil.toAsciiString(token, 40);

    }



    // uses a heuristic to produce a token symbol from the address

    // the heuristic returns the first 6 hex of the address string in upper case

    function addressToSymbol(address token) pure private returns (string memory) {

        return AddressStringUtil.toAsciiString(token, 6);

    }



    // calls an external view token contract method that returns a symbol or name, and parses the output into a string

    function callAndParseStringReturn(address token, bytes4 selector) view private returns (string memory) {

        (bool success, bytes memory data) = token.staticcall(abi.encodeWithSelector(selector));

        // if not implemented, or returns empty data, return empty string

        if (!success || data.length == 0) {

            return "";

        }

        // bytes32 data always has length 32

        if (data.length == 32) {

            bytes32 decoded = abi.decode(data, (bytes32));

            return bytes32ToString(decoded);

        } else if (data.length > 64) {

            return abi.decode(data, (string));

        }

        return "";

    }



    // attempts to extract the token symbol. if it does not implement symbol, returns a symbol derived from the address

    function tokenSymbol(address token) internal view returns (string memory) {

        // 0x95d89b41 = bytes4(keccak256("symbol()"))

        string memory symbol = callAndParseStringReturn(token, 0x95d89b41);

        if (bytes(symbol).length == 0) {

            // fallback to 6 uppercase hex of address

            return addressToSymbol(token);

        }

        return symbol;

    }



    // attempts to extract the token name. if it does not implement name, returns a name derived from the address

    function tokenName(address token) internal view returns (string memory) {

        // 0x06fdde03 = bytes4(keccak256("name()"))

        string memory name = callAndParseStringReturn(token, 0x06fdde03);

        if (bytes(name).length == 0) {

            // fallback to full hex of address

            return addressToName(token);

        }

        return name;

    }

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





// File contracts/v612/ICOREGlobals.sol



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





// File @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/IERC20.sol@v3.0.0



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





// File @openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol@v3.0.0



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

     */

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b != 0, errorMessage);

        return a % b;

    }

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





// File contracts/v612/COREForkMigrator.sol



pragma solidity 0.6.12;











// import "hardhat/console.sol";







// import "@openzeppelin/contracts/access/Ownable.sol";



interface ICOREVault {

    function addPendingRewards(uint256 _) external; 

}



interface IUNICORE {

    function viewGovernanceLevel(address) external returns (uint8);

    function setVault(address) external;

    function burnFromUni(uint256) external;

    function viewUNIv2() external returns (address);

    function viewUniBurnRatio() external returns (uint256);

    function setGovernanceLevel(address, uint8) external;

    function balanceOf(address) external returns (uint256);

    function setUniBurnRatio(uint256) external;

    function viewwWrappedUNIv2() external returns (address);

    function burnToken(uint256) external;

    function totalSupply() external returns (uint256);

}



interface IUNICOREVault {

    function userInfo(uint,address) external view returns (uint256, uint256);

}



interface IProxyAdmin {

    function owner() external returns (address);

    function transferOwnership(address) external;

    function upgrade(address, address) external;

}





interface IWETH {

    function deposit() external payable;

    function transfer(address to, uint value) external returns (bool);

    function withdraw(uint) external;

}

interface ILGE {

    function claimLP() external;

}



interface ITransferContract {

    function run(address) external;

}



interface ICORE {

    function setShouldTransferChecker(address) external;

}

interface IFIX {

    function unwrapAndSendToMigrator() external;

}



interface ITimelockVault {

    function LPContributed(address) external view returns (uint256);

}



contract TENSFeeApproverPermanent {

    address public tokenETHPair;

    constructor() public {

            tokenETHPair = 0xB1b537B7272BA1EDa0086e2f480AdCA72c0B511C;

    }



    function calculateAmountsAfterFee(

        address sender,

        address recipient,

        uint256 amount

        ) public  returns (uint256 transferToAmount, uint256 transferToFeeDistributorAmount, uint256 burn)

        {



            // Will block all buys and liquidity removals

            if(sender == tokenETHPair || recipient == tokenETHPair) {

                // This is how a legend dies

                require(false, "TENS is deprecated.");

            }



            // No fees 

            // school is out

            transferToAmount = amount;

        

        }

}





contract COREForkMigrator is OwnableUpgradeSafe {

    using SafeMath for uint256;

    /// EVENTS

    event ETHSendToLGE(uint256);



    ///Variables

    bool public LPClaimedFromLGE;

    bool private locked;

    IERC20 public  CORE;

    ICOREVault public  coreVault;

    IUniswapV2Factory public  uniswapFactory;

    IWETH wETH;

    address public  CORExWETHPair;

    address payable public CORE_MULTISIG;

    address public postLGELPTokenAddress;

    address public Fee_Approver_Permanent;

    address public Vault_Permanent;

    uint256 public totalLPClaimed;

    uint256 public totalETHSent;

    uint256 contractStartTimestamp;



    mapping (address => bool) LPClaimed;



    //// UNICORE Specific Variables

    bool public UNICORE_Migrated;

    bool public UNICORE_Liquidity_Transfered;

    address public UNICORE_Vault;

    address public UNICORE_Token;

    address public UNICORE_Reactor_Token; // Slit token for liquidity

    uint256 public UNICORE_Snapshot_Block;

    uint256 public Ether_Total_For_UNICORE_LP;

    uint256 public UNICORE_Total_LP_Supply;



    mapping (address => uint256) balanceUNICOREReactor;

    mapping (address => uint256) balanceUNICOREReactorInVaultOnSnapshot;





    // ENCORE Specific variables

    bool public ENCORE_Liquidity_Transfered;

    bool public ENCORE_Transfers_Closed;

    address public ENCORE_Vault;

    address public ENCORE_Vault_Timelock;

    address public ENCORE_Fee_Approver;

    address public ENCORE_Token;

    address public ENCORE_Timelock_Vault;

    address public ENCORE_Proxy_Admin;

    address public ENCORE_LP_Token;

    address public ENCORE_Migrator;

    uint256 public Ether_Credit_Per_ENCORE_LP;

    uint256 public Ether_Total_For_Encore_LP;

    uint256 public ENCORE_Total_LP_Supply;



    mapping (address => uint256) balanceENCORELP;

    // No need for snapshot





    /// TENS Specific functions and variables

    bool public TENS_Liquidity_Transfered;

    address public TENS_Vault;

    address public TENS_Token;

    address public TENS_Proxy_Admin;

    address public TENS_LP_Token;

    address public TENS_Fee_Approver_Permanent;

    uint256 public Ether_Total_For_TENS_LP;

    uint256 public TENS_Total_LP_Supply;



    mapping (address => uint256) balanceTENSLP;

    // No need for snapshot



    /// Reentrancy modifier

    modifier lock() {

        require(locked == false, 'CORE Migrator: Execution Locked');

        locked = true;

        _;

        locked = false;

    }





    // Constructor

    function initialize() initializer public{

        require(tx.origin == 0x5A16552f59ea34E44ec81E58b3817833E9fD5436);

        require(msg.sender == 0x5A16552f59ea34E44ec81E58b3817833E9fD5436);



        OwnableUpgradeSafe.__Ownable_init();

        CORE_MULTISIG = 0x5A16552f59ea34E44ec81E58b3817833E9fD5436;

        contractStartTimestamp = block.timestamp;



        // Permanent vault and fee approver

        Vault_Permanent = 0xfeD4Ec1348a4068d4934E09492428FD92E399e5c;

        Fee_Approver_Permanent = 0x43Dd7026284Ac8f95Eb02bB1bd68D0699B0Ae9cA;



        //UNICORE

        UNICORE_Vault = 0x6F31ECD8110bcBc679AEfb74c7608241D1B78949;

        UNICORE_Token = 0x5506861bbb104Baa8d8575e88E22084627B192D8;



        //TENS

        TENS_Vault = 0xf983EcF91195bD63DE8445997082680E688749BC;

        TENS_Token = 0x776CA7dEd9474829ea20AD4a5Ab7a6fFdB64C796;

        TENS_Proxy_Admin = 0x2d0C48C5BF930A09F8CD6fae5aC5A16b24e1723a;

        TENS_LP_Token = 0xB1b537B7272BA1EDa0086e2f480AdCA72c0B511C;

        TENS_Fee_Approver_Permanent = 0x22C91cDd1E00cD4d7D029f0dB94020Fce3C486e3;

        

        ENCORE_Proxy_Admin = 0x1964784ba40c9fD5EED1070c1C38cd5D1d5F9f55;

        ENCORE_Token = 0xe0E4839E0c7b2773c58764F9Ec3B9622d01A0428;

        ENCORE_LP_Token = 0x2e0721E6C951710725997928DcAAa05DaaFa031B;

        ENCORE_Fee_Approver = 0xF3c3ff0ea59d15e82b9620Ed7406fa3f6A261f98;

        ENCORE_Vault = 0xdeF7BdF8eCb450c1D93C5dB7C8DBcE5894CCDaa9;

        ENCORE_Vault_Timelock = 0xC2Cb86437355f36d42Fb8D979ab28b9816ac0545;

        Ether_Credit_Per_ENCORE_LP = uint256(1 ether).div(2).mul(10724).div(10000); // Account for 7.24% fee on LGE



        ICOREGlobals globals = ICOREGlobals(0x255CA4596A963883Afe0eF9c85EA071Cc050128B);

        CORE = IERC20(globals.CORETokenAddress());

        uniswapFactory = IUniswapV2Factory(globals.UniswapFactory());

        coreVault = ICOREVault(globals.COREVaultAddress());

        CORExWETHPair = globals.COREWETHUniPair();

        wETH = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);

    }

    

    //Enables recieving eth

    receive() external payable{

    }



    function setLPTokenAddress(address _token) onlyOwner public {

        postLGELPTokenAddress = _token;

    }



    function claimLP() lock public {

        require(LPClaimedFromLGE == true, "Nothing to claim yet");

        require(getOwedLP(msg.sender) > 0, "nothing to claim");

        require(IERC20(postLGELPTokenAddress).transfer(msg.sender, getOwedLP(msg.sender)));

        LPClaimed[msg.sender] = true;

    }



    function getOwedLP(address user) public view returns (uint256 LPDebtForUser) {

        if(postLGELPTokenAddress == address (0)) return 0;

        if(LPClaimedFromLGE == false) return 0;

        if(LPClaimed[msg.sender] == true) return 0;



        uint256 balanceUNICORE = viewCreditedUNICOREReactors(user);

        uint256 balanceENCORE = viewCreditedENCORETokens(user);

        uint256 balanceTENS = viewCreditedTENSTokens(user);



        if(balanceUNICORE == 0 && balanceENCORE == 0 && balanceTENS == 0) return 0;



        uint256 totalETH = Ether_Total_For_TENS_LP.add(Ether_Total_For_UNICORE_LP).add(Ether_Total_For_Encore_LP);

        uint256 totalETHEquivalent;



        if(balanceUNICORE > 0){

            totalETHEquivalent = Ether_Total_For_UNICORE_LP.div(UNICORE_Total_LP_Supply).mul(balanceUNICORE);

        }



        if(balanceENCORE > 0){

            totalETHEquivalent = totalETHEquivalent.add(Ether_Total_For_Encore_LP).div(ENCORE_Total_LP_Supply).mul(balanceENCORE);



        }



        if(balanceTENS > 0){

            totalETHEquivalent = totalETHEquivalent.add(Ether_Total_For_TENS_LP).div(TENS_Total_LP_Supply).mul(balanceTENS);

        }



        LPDebtForUser = totalETHEquivalent.mul(totalLPClaimed).div(totalETH).div(1e18);

    }



    ////////////

    /// Unicore specific functions

    //////////



    function snapshotUNICORE(address[] memory _addresses, uint256[] memory balances) onlyOwner public {

        require(UNICORE_Migrated == true, "UNICORE Deposits are still not closed");



        uint256 length = _addresses.length;

        require(length == balances.length, "Wrong input");



        for (uint256 i = 0; i < length; i++) {

            balanceUNICOREReactorInVaultOnSnapshot[_addresses[i]] = balances[i];

        }

    }



    function setUnicoreReactorToken ( address _token ) onlyOwner public {

        UNICORE_Reactor_Token = _token;

    }



    function viewCreditedUNICOREReactors(address person) public view returns (uint256) {



        if(UNICORE_Migrated) {

            return balanceUNICOREReactorInVaultOnSnapshot[person].add(balanceUNICOREReactor[person]);

        }



        else {

            (uint256 userAmount, ) = IUNICOREVault(UNICORE_Vault).userInfo(0, person);

            return balanceUNICOREReactor[person].add(userAmount);



        }



    }



    function addUNICOREReactors() lock public {

        require(UNICORE_Migrated == false, "UNICORE Deposits closed");

        uint256 amtAdded = transferTokenHereSupportingFeeOnTransferTokens(UNICORE_Reactor_Token, IERC20(UNICORE_Reactor_Token).balanceOf(msg.sender));

        balanceUNICOREReactor[msg.sender] = balanceUNICOREReactor[msg.sender].add(amtAdded);

    }







    // Unicore migraiton is special and a-typical

    // Because of the extensive changes to the code-base.

    function transferUNICORELiquidity() onlyOwner public {

        require(ENCORE_Liquidity_Transfered == true, "ENCORE has to go first");

        require(UNICORE_Liquidity_Transfered == false, "UNICORE already transfered");

        // Make sure we have the proper permissions.

        require(IUNICORE(UNICORE_Token).viewGovernanceLevel(address(this)) == 2, "Incorrectly set governance level, can't proceed");

        require(IUNICORE(UNICORE_Token).viewGovernanceLevel(0x5A16552f59ea34E44ec81E58b3817833E9fD5436) == 2, "Incorrectly set governance level, can't proceed");

        require(IUNICORE(UNICORE_Token).viewGovernanceLevel(0x05957F3344255fDC9fE172E30016ee148D684313) == 0, "Incorrectly set governance level, can't proceed");

        require(IUNICORE(UNICORE_Token).viewGovernanceLevel(0xE6f32f17BE3Bf031B4B6150689C1f17cEcA375C8) == 0, "Incorrectly set governance level, can't proceed");

        require(IUNICORE(UNICORE_Token).viewGovernanceLevel(0xF4D7a0E8a68345442172F45cAbD272c25320AA96) == 0, "Incorrectly set governance level, can't proceed");



        require(address(this).balance >= 1e18, " Feed me eth");



        IUNICORE unicore = IUNICORE(UNICORE_Token);



        wETH.deposit{value: 1e18}();

        IUniswapV2Pair pair = IUniswapV2Pair(unicore.viewUNIv2());

        

        bool token0IsWETH = pair.token0() == address(wETH);

        (uint256 reserve0, uint256 reserve1, ) = pair.getReserves();

        wETH.transfer(address(pair), 1e18);

        uint256 amtUnicore;



        if(token0IsWETH){

            amtUnicore = getAmountOut(1e18, reserve0, reserve1);

            pair.swap(0, amtUnicore, address(this), "");

        }

        else{

            amtUnicore = getAmountOut(1e18, reserve1, reserve0);



            pair.swap(amtUnicore, 0, address(this), "");

        }



        unicore.setVault(address(this));

        unicore.setUniBurnRatio(100);

    

        uint256 balUnicoreOfUniPair = unicore.balanceOf(unicore.viewUNIv2());

        uint256 totalSupplywraps = IERC20(unicore.viewwWrappedUNIv2()).totalSupply();

        UNICORE_Total_LP_Supply = totalSupplywraps;



        uint256 input = (balUnicoreOfUniPair-1).mul(totalSupplywraps).div(balUnicoreOfUniPair);



        unicore.burnFromUni(input);



        {



        (uint256 reserve0, uint256 reserve1, ) = pair.getReserves();

        uint256 amtWETH;

        uint256 previousPairBalance = unicore.balanceOf(address(pair));

        IERC20(address(unicore)).transfer(address(pair),  unicore.balanceOf(address(this)));

        uint256 nowPairBalance = unicore.balanceOf(address(pair));



        if(token0IsWETH){

            amtWETH = getAmountOut(nowPairBalance- previousPairBalance, reserve1, reserve0);



            pair.swap(amtWETH, 0, address(this), "");

            ( reserve0,  reserve1, ) = pair.getReserves();

            require(reserve0 < 1e18, " Burn not sufficient");

        }

        else{

            amtWETH = getAmountOut(nowPairBalance- previousPairBalance, reserve0, reserve1);



            pair.swap(0, amtWETH, address(this), "");

            ( reserve0,  reserve1, ) = pair.getReserves();

            require(reserve1 < 1e18, " Burn not sufficient");

        }



        uint256 UNICORETotalSupply = unicore.totalSupply();

        // 0.6 eth per is the floor we should get more here

        require(amtWETH > UNICORETotalSupply.mul(60).div(100), " Didn't get enough ETH ");

        require(amtWETH > 500 ether, " Didn't get enough ETH"); // sanity



        Ether_Total_For_UNICORE_LP = amtWETH

                .mul(Ether_Credit_Per_ENCORE_LP)

                .div(1e18);





        address wethFixed = address(new fixWETH());

        wETH.transfer(wethFixed, amtWETH);

        

        {

        uint256 ethBalBefore = address(this).balance;

        IFIX(wethFixed).unwrapAndSendToMigrator();

        uint256 newETH = address(this).balance.sub(ethBalBefore);

        require(newETH == amtWETH, "Fix unsucessful");

        }





        unicore.setGovernanceLevel(address(this), 1);

        UNICORE_Liquidity_Transfered = true;



        }



    }



    ////////////

    /// ENCORE specific functions

    //////////

    function viewCreditedENCORETokens(address person) public view returns (uint256) {

            (uint256 userAmount, ) = IUNICOREVault(ENCORE_Vault).userInfo(0, person);

            uint256 userAmountTimelock = ITimelockVault(ENCORE_Vault_Timelock).LPContributed(person);

            return balanceENCORELP[person].add(userAmount).add(userAmountTimelock);

    }



    // Add LP to balance here

    function addENCORELPTokens() lock public {

        require(ENCORE_Transfers_Closed == false, "ENCORE LP transfers closed");

        uint256 amtAdded = transferTokenHereSupportingFeeOnTransferTokens(ENCORE_LP_Token, IERC20(ENCORE_LP_Token).balanceOf(msg.sender));

        balanceENCORELP[msg.sender] = balanceENCORELP[msg.sender].add(amtAdded);

    }



    function closeENCORETransfers() onlyOwner public  {

        require(block.timestamp >= contractStartTimestamp.add(2 days), "2 day grace ongoing");

        ENCORE_Transfers_Closed = true;

    }



    function transferENCORELiquidity(address privateTransferContract) onlyOwner public {



        require(ENCORE_Transfers_Closed == true, "ENCORE LP transfers still ongoing");

        require(ENCORE_Liquidity_Transfered == false, "Already transfered liquidity");

        require(IProxyAdmin(ENCORE_Proxy_Admin).owner() == address(this), "Set me as the proxy owner for ENCORE");



        require(privateTransferContract != address(0));

        IProxyAdmin(ENCORE_Proxy_Admin).transferOwnership(privateTransferContract);



        // We check 2 contracts with burned LP

        uint256 burnedLPTokens = IERC20(ENCORE_LP_Token).balanceOf(ENCORE_Token)

                .add(IERC20(ENCORE_LP_Token).balanceOf(0x2a997EaD7478885a66e6961ac0837800A07492Fc));



        ENCORE_Total_LP_Supply = IERC20(ENCORE_LP_Token).totalSupply() - burnedLPTokens;

    

        // We calculate total owed to ENCORE LPs

        Ether_Total_For_Encore_LP = ENCORE_Total_LP_Supply // burned ~100

                .mul(Ether_Credit_Per_ENCORE_LP)

                .div(1e18);



        // We send out all LP tokens we have 

        IERC20(ENCORE_LP_Token)

            .transfer(ENCORE_LP_Token, IERC20(ENCORE_LP_Token).balanceOf(address(this)));



        uint256 ethBalBefore = address(this).balance;

        ITransferContract(privateTransferContract).run(ENCORE_LP_Token);

        uint256 newETH = address(this).balance.sub(ethBalBefore);



        // Make sure we got eth

        require(newETH > 9200 ether, "Did not recieve enough ether");

                

                //60% max

        require(newETH.mul(60).div(100) > Ether_Total_For_Encore_LP, "Too much for encore LP"); 

                

        require(ENCORE_Proxy_Admin != address(0) 

                &&  Fee_Approver_Permanent != address(0) 

                && Vault_Permanent != address(0), "Sanity check failue");



        IProxyAdmin(ENCORE_Proxy_Admin).upgrade(ENCORE_Fee_Approver, Fee_Approver_Permanent);

        IProxyAdmin(ENCORE_Proxy_Admin).upgrade(ENCORE_Vault, Vault_Permanent);

        _sendENCOREProxyAdminBackToMultisig();

        ENCORE_Liquidity_Transfered = true;

    }



    function sendENCOREProxyAdminBackToMultisig() onlyOwner public {

        return _sendENCOREProxyAdminBackToMultisig();

    }



    function _sendENCOREProxyAdminBackToMultisig() internal {

        IProxyAdmin(ENCORE_Proxy_Admin).transferOwnership(CORE_MULTISIG);

        require(IProxyAdmin(ENCORE_Proxy_Admin).owner() == CORE_MULTISIG, "Proxy Ownership Transfer Not Successfull");

    }



    ////////////

    /// TENS specific functions

    //////////



    function addTENSLPTokens() lock public {

        require(ENCORE_Transfers_Closed == false, "TENS LP transfers still ongoing");

        uint256 amtAdded = transferTokenHereSupportingFeeOnTransferTokens(TENS_LP_Token, IERC20(TENS_LP_Token).balanceOf(msg.sender));

        balanceTENSLP[msg.sender] = balanceTENSLP[msg.sender].add(amtAdded);

    }



    function viewCreditedTENSTokens(address person) public view returns (uint256) {



        (uint256 userAmount, ) = IUNICOREVault(TENS_Vault).userInfo(0, person);

        return balanceTENSLP[person].add(userAmount);

    }



    function transferTENSLiquidity(address privateTransferContract) onlyOwner public {



        require(TENS_Liquidity_Transfered == false, "Already transfered");

        require(ENCORE_Liquidity_Transfered == true, "ENCORE has to go first");



        require(IProxyAdmin(TENS_Proxy_Admin).owner() == address(this), "Set me as the proxy owner for TENS");

        require(IProxyAdmin(TENS_Token).owner() == address(this), "Set me as the owner for TENS"); // same interface

        require(privateTransferContract != address(0));



        IProxyAdmin(TENS_Proxy_Admin).transferOwnership(privateTransferContract);

        IProxyAdmin(TENS_Token).transferOwnership(privateTransferContract);

        TENS_Total_LP_Supply = IERC20(TENS_LP_Token).totalSupply();



        // We send out all LP tokens we have 

        IERC20(TENS_LP_Token)

            .transfer(TENS_LP_Token, IERC20(TENS_LP_Token).balanceOf(address(this)));



        uint256 ethBalBefore = address(this).balance;

        ITransferContract(privateTransferContract).run(TENS_LP_Token);

        uint256 newETH = address(this).balance.sub(ethBalBefore);

        require(newETH > 130 ether, "Did not recieve enough ether");



        require(TENS_Fee_Approver_Permanent != address(0) &&

            Vault_Permanent != address(0), "Sanity check failue");



        IProxyAdmin(TENS_Proxy_Admin).upgrade(TENS_Vault, Vault_Permanent);

        TENS_Fee_Approver_Permanent = address ( new TENSFeeApproverPermanent() );

        ICORE(TENS_Token).setShouldTransferChecker(TENS_Fee_Approver_Permanent);

        Ether_Total_For_TENS_LP = newETH

                .mul(Ether_Credit_Per_ENCORE_LP)

                .div(1e18);



        _sendOwnershipOfTENSBackToMultisig();



        TENS_Liquidity_Transfered = true;

  

    }



    function sendOwnershipOfTENSBackToMultisig() onlyOwner public {

        return _sendOwnershipOfTENSBackToMultisig();

    }



    function _sendOwnershipOfTENSBackToMultisig() internal {

        IProxyAdmin(TENS_Token).transferOwnership(CORE_MULTISIG);

        require(IProxyAdmin(TENS_Token).owner() == CORE_MULTISIG, "Multisig not owner of token"); // same interface

        IProxyAdmin(TENS_Proxy_Admin).transferOwnership(CORE_MULTISIG);

        require(IProxyAdmin(TENS_Proxy_Admin).owner() == CORE_MULTISIG, "Multisig not owner of proxyadmin");

    }



  

    ///////////////////

    //// Helper functions

    //////////////////

    function sendETH(address payable to, uint256 amt) internal {

        //

        // throw exception on failure

        to.transfer(amt);

    }



    function safeTransfer(address token, address to, uint256 value) internal {

        // bytes4(keccak256(bytes('transfer(address,uint256)')));

        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));

        require(success && (data.length == 0 || abi.decode(data, (bool))), 'FA Controller: TRANSFER_FAILED');

    }





    function transferTokenHereSupportingFeeOnTransferTokens(address token,uint256 amountTransfer) internal returns (uint256 amtAdded) {

        uint256 balBefore = IERC20(token).balanceOf(address(this));

        require(IERC20(token).transferFrom(msg.sender, address(this), amountTransfer));

        amtAdded = IERC20(token).balanceOf(address(this)).sub(balBefore);

    }



    function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) internal  pure returns (uint256 amountOut) {

        require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');

        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');

        uint amountInWithFee = amountIn.mul(997);

        uint numerator = amountInWithFee.mul(reserveOut);

        uint denominator = reserveIn.mul(1000).add(amountInWithFee);

        amountOut = numerator / denominator;

    }







    // A function that lets owner remove any tokens from this addrss

    // note this address shoudn't hold any tokens

    // And if it does that means someting already went wrong or someone send them to this address

    function rescueUnsupportedTokens(address token, uint256 amt) public onlyOwner {

        IERC20(token).transfer(CORE_MULTISIG, amt);

    }



    function sendETHToLGE(uint256 amt, address payable lgeContract) onlyOwner public {

        uint256 totalETH = Ether_Total_For_TENS_LP.add(Ether_Total_For_UNICORE_LP).add(Ether_Total_For_Encore_LP);

        totalETHSent = totalETHSent.add(amt);

        require(totalETHSent <= totalETH, "Too much sent");

        require(lgeContract != address(0)," no ");

        sendETH(lgeContract, amt);

        emit ETHSendToLGE(amt);

    }



    function sendETHToTreasury(uint256 amt, address payable to) onlyOwner public {

        uint256 totalETH = Ether_Total_For_TENS_LP.add(Ether_Total_For_UNICORE_LP).add(Ether_Total_For_Encore_LP);

        require(totalETHSent == totalETH, "Still money to send to LGE");

        require(to != address(0)," no ");

        sendETH(to, amt);

    }



    function getETHLeftToDepositToLGE() public view returns (uint256) {

        uint256 totalETH = Ether_Total_For_TENS_LP.add(Ether_Total_For_UNICORE_LP).add(Ether_Total_For_Encore_LP);

        return totalETH - totalETHSent;

    }



    function claimLPFromLGE(address lgeContract) onlyOwner public {

        require(postLGELPTokenAddress != address(0), "LP token address not set.");

        ILGE(lgeContract).claimLP();

        

        LPClaimedFromLGE = true;

        totalLPClaimed = IERC20(postLGELPTokenAddress).balanceOf(address(this));

    }



}

contract fixWETH {

    // 0x5DCA4093BFE88D6fD5511fb78F6a777d47314d35 migrator

    address payable migrator = 0x5DCA4093BFE88D6fD5511fb78F6a777d47314d35;

    IWETH wETH = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);

    receive() external payable{}



    function unwrapAndSendToMigrator() public {

        uint256 bal = IERC20(address(wETH)).balanceOf(address(this));

        wETH.withdraw(bal);

        selfdestruct(migrator);

    }



}

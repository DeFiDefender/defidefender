pragma solidity ^0.5.12;



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

 * @title ERC721 token receiver interface

 * @dev Interface for any contract that wants to support safeTransfers

 * from ERC721 asset contracts.

 */

contract IERC721Receiver {

    /**

     * @notice Handle the receipt of an NFT

     * @dev The ERC721 smart contract calls this function on the recipient

     * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,

     * otherwise the caller will revert the transaction. The selector to be

     * returned can be obtained as `this.onERC721Received.selector`. This

     * function MAY throw to revert and reject the transfer.

     * Note: the ERC721 contract address is always the message sender.

     * @param operator The address which called `safeTransferFrom` function

     * @param from The address which previously owned the token

     * @param tokenId The NFT identifier which is being transferred

     * @param data Additional data with no specified format

     * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`

     */

    function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)

    public returns (bytes4);

}



/**

 * @title PToken Interface

 */

interface IPToken {

    /* solhint-disable func-order */

    //Standart ERC20

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);



    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);



    //Mintable & Burnable

    function mint(address account, uint256 amount) external returns (bool);

    function burn(uint256 amount) external;

    function burnFrom(address account, uint256 amount) external;



    //Distributions

    function distribute(uint256 amount) external;

    function claimDistributions(address account) external returns(uint256);

    function claimDistributions(address account, uint256 lastDistribution) external returns(uint256);

    function claimDistributions(address[] calldata accounts) external;

    function claimDistributions(address[] calldata accounts, uint256 toDistribution) external;

    function fullBalanceOf(address account) external view returns(uint256);

    function calculateDistributedAmount(uint256 startDistribution, uint256 nextDistribution, uint256 initialBalance) external view returns(uint256);

    function nextDistribution() external view returns(uint256);

    function distributionTotalSupply() external view returns(uint256);

    function distributionBalanceOf(address account) external view returns(uint256);

}



/**



        The software and documentation available in this repository (the "Software") is

        protected by copyright law and accessible pursuant to the license set forth below.



        Copyright \u00a9 2019 Staked Securely, Inc. All rights reserved.



        Permission is hereby granted, free of charge, to any person or organization

        obtaining the Software (the \u201cLicensee\u201d) to privately study, review, and analyze

        the Software. Licensee shall not use the Software for any other purpose. Licensee

        shall not modify, transfer, assign, share, or sub-license the Software or any

        derivative works of the Software.



        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,

        INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A

        PARTICULAR PURPOSE, TITLE, AND NON-INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT

        HOLDERS BE LIABLE FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT,

        OR OTHERWISE, ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE.



*/



/// @notice  Basic interface for integration with RAY - The Robo-Advisor for Yield.

///

/// Author:   Devan Purhar

/// Version:  1.0.0



interface IRAY {





    /// @notice  Mints a RAY token of the associated basket of opportunities to the portfolioId

    ///

    /// @param   portfolioId - the id of the portfolio to associate the RAY token with

    /// @param   beneficiary - the owner and beneficiary of the RAY token

    /// @param   value - the amount in the smallest units in-kind to deposit into RAY

    ///

    /// @return  the unique RAY token id, used to reference anything in the RAY system

    function mint(bytes32 portfolioId, address beneficiary, uint value) external payable returns(bytes32);





    /// @notice  Deposits assets into an existing RAY token

    ///

    /// @dev     Anybody can deposit into a RAY token, not just the owner

    ///

    /// @param   tokenId - the id of the RAY token to add value too

    /// @param   value - the amount in the smallest units in-kind to deposit into the RAY

    function deposit(bytes32 tokenId, uint value) external payable;





    /// @notice  Redeems a RAY token for the underlying value

    ///

    /// @dev     Can partially or fully redeem the RAY token

    ///

    ///          Only the owner of the RAY token can call this, or the Staked

    ///          'GasFunder' smart contract

    ///

    /// @param   tokenId - the id of the RAY token to redeem value from

    /// @param   valueToWithdraw - the amount in the smallest units in-kind to redeem from the RAY

    /// @param   originalCaller - only relevant for our `GasFunder` smart contract,

    ///                           for everyone else, can be set to anything

    ///

    /// @return  the amount transferred to the owner of the RAY token after fees

    function redeem(bytes32 tokenId, uint valueToWithdraw, address originalCaller) external returns(uint);





    /// @notice  Get the underlying value of a RAY token (principal + yield earnt)

    ///

    /// @dev     The implementation of this function exists in NAVCalculator

    ///

    /// @param   portfolioId - the id of the portfolio associated with the RAY token

    /// @param   tokenId - the id of the RAY token to get the value of

    ///

    /// @return  an array of two, the first value is the current token value, the

    ///          second value is the current price per share of the portfolio

    function getTokenValue(bytes32 portfolioId, bytes32 tokenId) external returns(uint, uint);



}



/**



        The software and documentation available in this repository (the "Software") is

        protected by copyright law and accessible pursuant to the license set forth below.



        Copyright \u00a9 2019 Staked Securely, Inc. All rights reserved.



        Permission is hereby granted, free of charge, to any person or organization

        obtaining the Software (the \u201cLicensee\u201d) to privately study, review, and analyze

        the Software. Licensee shall not use the Software for any other purpose. Licensee

        shall not modify, transfer, assign, share, or sub-license the Software or any

        derivative works of the Software.



        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,

        INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A

        PARTICULAR PURPOSE, TITLE, AND NON-INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT

        HOLDERS BE LIABLE FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT,

        OR OTHERWISE, ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE.



*/





/// @notice  Basic interface containing some useful functions for RAY integration.

///

/// Author:   Devan Purhar



interface IRAYStorage {



    /// @notice  Get the portfolioId associated with a RAY token

    function getTokenKey(bytes32 rayTokenId) external view returns (bytes32);





    /// @notice  Get the contract address of the underlying asset associated with a

    ///          portfolioId

    function getPrincipalAddress(bytes32 portfolioId) external view returns (address);





    /// @notice  Get if a contract address follows the ERC20 standard or not

    function getIsERC20(address principalAddress) external view returns (bool);





    /// @notice  Dynamically get the contract address of different RAY smart contracts

    ///

    /// @param   contractId - Each contract has an id represented by the result of

    ///                       a keccak256() of the contract name.

    ///

    ///                       Example: PortfolioManager.sol can be dynamically referenced

    ///                       by getContractAddress(keccak256('PortfolioManagerContract'));

    function getContractAddress(bytes32 contractId) external view returns (address);





    /// @notice  Get the shares owned by a RAY token

    function getTokenShares(bytes32 portfolioId, bytes32 rayTokenId) external view returns (uint);





    /// @notice  Get the capital credited to a RAY token

    function getTokenCapital(bytes32 portfolioId, bytes32 rayTokenId) external view returns (uint);





    /// @notice  Get the allowance credited to a RAY token - allowance decides what

    ///          amount of value will be charged a fee

    function getTokenAllowance(bytes32 portfolioId, bytes32 rayTokenId) external view returns (uint);



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

 * @title Funds Module Interface

 * @dev Funds module is responsible for token transfers, provides info about current liquidity/debts and pool token price.

 */

interface IFundsModule {

    event Status(uint256 lBalance, uint256 lDebts, uint256 lProposals, uint256 pEnterPrice, uint256 pExitPrice);



    /**

     * @notice Deposit liquid tokens to the pool

     * @param from Address of the user, who sends tokens. Should have enough allowance.

     * @param amount Amount of tokens to deposit

     */

    function depositLTokens(address from, uint256 amount) external;

    /**

     * @notice Withdraw liquid tokens from the pool

     * @param to Address of the user, who sends tokens. Should have enough allowance.

     * @param amount Amount of tokens to deposit

     */

    function withdrawLTokens(address to, uint256 amount) external;



    /**

     * @notice deposit liquid tokens received as interest and distribute PTK

     * @param amount Amount of liquid tokens to deposit

     * @return Amount of PTK distributed

     */

    function distributeLInterest(uint256 amount) external returns(uint256);



    /**

     * @notice Withdraw liquid tokens from the pool

     * @param to Address of the user, who sends tokens. Should have enough allowance.

     * @param amount Amount of tokens to deposit

     * @param poolFee Pool fee will be sent to pool owner

     */

    function withdrawLTokens(address to, uint256 amount, uint256 poolFee) external;



    /**

     * @notice Deposit pool tokens to the pool

     * @param from Address of the user, who sends tokens. Should have enough allowance.

     * @param amount Amount of tokens to deposit

     */

    function depositPTokens(address from, uint256 amount) external;



    /**

     * @notice Withdraw pool tokens from the pool

     * @param to Address of the user, who sends tokens. Should have enough allowance.

     * @param amount Amount of tokens to deposit

     */

    function withdrawPTokens(address to, uint256 amount) external;



    /**

     * @notice Mint new PTokens

     * @param to Address of the user, who sends tokens.

     * @param amount Amount of tokens to mint

     */

    function mintPTokens(address to, uint256 amount) external;



    /**

     * @notice Mint new PTokens and distribute the to other PToken holders

     * @param amount Amount of tokens to mint

     */

    function distributePTokens(uint256 amount) external;



    /**

     * @notice Burn pool tokens

     * @param from Address of the user, whos tokens we burning. Should have enough allowance.

     * @param amount Amount of tokens to burn

     */

    function burnPTokens(address from, uint256 amount) external;



    function lockPTokens(address[] calldata from, uint256[] calldata amount) external;



    function mintAndLockPTokens(uint256 amount) external;



    function unlockAndWithdrawPTokens(address to, uint256 amount) external;



    function burnLockedPTokens(uint256 amount) external;



    function emitStatusEvent() external;



    /**

     * @notice Calculates how many pTokens should be given to user for increasing liquidity

     * @param lAmount Amount of liquid tokens which will be put into the pool

     * @return Amount of pToken which should be sent to sender

     */

    function calculatePoolEnter(uint256 lAmount) external view returns(uint256);



    /**

     * @notice Calculates how many pTokens should be taken from user for decreasing liquidity

     * @param lAmount Amount of liquid tokens which will be removed from the pool

     * @return Amount of pToken which should be taken from sender

     */

    function calculatePoolExit(uint256 lAmount) external view returns(uint256);



    /**

     * @notice Calculates how many liquid tokens should be removed from pool when decreasing liquidity

     * @param pAmount Amount of pToken which should be taken from sender

     * @return Amount of liquid tokens which will be removed from the pool: total, part for sender, part for pool

     */

    function calculatePoolExitInverse(uint256 pAmount) external view returns(uint256, uint256, uint256);



    /**

     * @notice Calculates how many pTokens should be taken from user for decreasing liquidity

     * @param lAmount Amount of liquid tokens which will be removed from the pool

     * @return Amount of pToken which should be taken from sender

     */

    function calculatePoolExitWithFee(uint256 lAmount) external view returns(uint256);



    /**

     * @notice Current pool liquidity

     * @return available liquidity

     */

    function lBalance() external view returns(uint256);



    /**

     * @return Amount of pTokens locked in FundsModule by account

     */

    function pBalanceOf(address account) external view returns(uint256);



}



interface IDefiModule { 

    event Deposit(uint256 amount);

    event Withdraw(uint256 amount);

    event InvestmentDistributionCreated(uint256 amount, uint256 currentBalance, uint256 distributedPTK);



    //Info

    function poolBalance() external returns(uint256);



    // Actions for user

    function createDistributionIfReady() external;



    //Actions for DefiOperator (FundsModule)

    function handleDeposit(address sender, uint256 amount) external;

    function withdraw(address beneficiary, uint256 amount) external;

}



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

contract Context is Initializable {

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

 * `onlyOwner`, which can be aplied to your functions to restrict their use to

 * the owner.

 */

contract Ownable is Initializable, Context {

    address private _owner;



    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);



    /**

     * @dev Initializes the contract setting the deployer as the initial owner.

     */

    function initialize(address sender) public initializer {

        _owner = sender;

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

     * > Note: Renouncing ownership will leave the contract without an owner,

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



    uint256[50] private ______gap;

}



/**

 * Base contract for all modules

 */

contract Base is Initializable, Context, Ownable {

    address constant  ZERO_ADDRESS = address(0);



    function initialize() public initializer {

        Ownable.initialize(_msgSender());

    }



}



/**

 * @dev List of module names

 */

contract ModuleNames {

    // Pool Modules

    string internal constant MODULE_ACCESS            = "access";

    string internal constant MODULE_PTOKEN            = "ptoken";

    string internal constant MODULE_DEFI              = "defi";

    string internal constant MODULE_CURVE             = "curve";

    string internal constant MODULE_FUNDS             = "funds";

    string internal constant MODULE_LIQUIDITY         = "liquidity";

    string internal constant MODULE_LOAN              = "loan";

    string internal constant MODULE_LOAN_LIMTS        = "loan_limits";

    string internal constant MODULE_LOAN_PROPOSALS    = "loan_proposals";

    string internal constant MODULE_FLASHLOANS        = "flashloans";

    string internal constant MODULE_ARBITRAGE         = "arbitrage";



    // External Modules (used to store addresses of external contracts)

    string internal constant MODULE_LTOKEN            = "ltoken";

    string internal constant MODULE_CDAI              = "cdai";

    string internal constant MODULE_RAY               = "ray";

}



/**

 * Base contract for all modules

 */

contract Module is Base, ModuleNames {

    event PoolAddressChanged(address newPool);

    address public pool;



    function initialize(address _pool) public initializer {

        Base.initialize();

        setPool(_pool);

    }



    function setPool(address _pool) public onlyOwner {

        require(_pool != ZERO_ADDRESS, "Module: pool address can't be zero");

        pool = _pool;

        emit PoolAddressChanged(_pool);        

    }



    function getModuleAddress(string memory module) public view returns(address){

        require(pool != ZERO_ADDRESS, "Module: no pool");

        (bool success, bytes memory result) = pool.staticcall(abi.encodeWithSignature("get(string)", module));

        

        //Forward error from Pool contract

        if (!success) assembly {

            revert(add(result, 32), result)

        }



        address moduleAddress = abi.decode(result, (address));

        if (moduleAddress == ZERO_ADDRESS) {

            string memory error = string(abi.encodePacked("Module: requested module not found: ", module));

            revert(error);

        }

        return moduleAddress;

    }



}



/**

 * @title Roles

 * @dev Library for managing addresses assigned to a Role.

 */

library Roles {

    struct Role {

        mapping (address => bool) bearer;

    }



    /**

     * @dev Give an account access to this role.

     */

    function add(Role storage role, address account) internal {

        require(!has(role, account), "Roles: account already has role");

        role.bearer[account] = true;

    }



    /**

     * @dev Remove an account's access to this role.

     */

    function remove(Role storage role, address account) internal {

        require(has(role, account), "Roles: account does not have role");

        role.bearer[account] = false;

    }



    /**

     * @dev Check if an account has this role.

     * @return bool

     */

    function has(Role storage role, address account) internal view returns (bool) {

        require(account != address(0), "Roles: account is the zero address");

        return role.bearer[account];

    }

}



contract DefiOperatorRole is Initializable, Context {

    using Roles for Roles.Role;



    event DefiOperatorAdded(address indexed account);

    event DefiOperatorRemoved(address indexed account);



    Roles.Role private _operators;



    function initialize(address sender) public initializer {

        if (!isDefiOperator(sender)) {

            _addDefiOperator(sender);

        }

    }



    modifier onlyDefiOperator() {

        require(isDefiOperator(_msgSender()), "DefiOperatorRole: caller does not have the DefiOperator role");

        _;

    }



    function addDefiOperator(address account) public onlyDefiOperator {

        _addDefiOperator(account);

    }



    function renounceDefiOperator() public {

        _removeDefiOperator(_msgSender());

    }



    function isDefiOperator(address account) public view returns (bool) {

        return _operators.has(account);

    }



    function _addDefiOperator(address account) internal {

        _operators.add(account);

        emit DefiOperatorAdded(account);

    }



    function _removeDefiOperator(address account) internal {

        _operators.remove(account);

        emit DefiOperatorRemoved(account);

    }



}



/**

* @dev DeFi integration module

* This module should be initialized only *AFTER* PTK module is available and address

* of DeFi source is set.

*/

contract DefiModuleBase is Module, DefiOperatorRole, IDefiModule {

    using SafeMath for uint256;



    uint256 public constant DISTRIBUTION_AGGREGATION_PERIOD = 24*60*60;



    struct Distribution {

        uint256 amount;         // Amount of DAI being distributed during the event

        uint256 balance;        // Total amount of DAI stored

    }



    Distribution[] public distributions;                    // Array of all distributions

    uint256 public nextDistributionTimestamp;               //Timestamp when next distribuition should be fired

    uint256 depositsSinceLastDistribution;                  // Amount DAI deposited since last distribution;

    uint256 withdrawalsSinceLastDistribution;               // Amount DAI withdrawn since last distribution;



    function initialize(address _pool) public initializer {

        Module.initialize(_pool);

        DefiOperatorRole.initialize(_msgSender());

        _createInitialDistribution();

    }



    // == Public functions

    function createDistributionIfReady() public {

        _createDistributionIfReady();

    }



    function handleDeposit(address sender, uint256 amount) public onlyDefiOperator {

        _createDistributionIfReady();

        depositsSinceLastDistribution = depositsSinceLastDistribution.add(amount);

        handleDepositInternal(sender, amount);

        emit Deposit(amount);

    }



    function withdraw(address beneficiary, uint256 amount) public onlyDefiOperator {

        _createDistributionIfReady();

        withdrawalsSinceLastDistribution = withdrawalsSinceLastDistribution.add(amount);

        withdrawInternal(beneficiary, amount);

        emit Withdraw(amount);

    }



    /**

     * @notice Full DAI balance of the pool. Useful to transfer all funds to another module.

     * @dev Note, this call MAY CHANGE state  (internal DAI balance in Compound, for example)

     */

    function poolBalance() public returns(uint256) {

        return poolBalanceOfDAI();

    }



    function distributionsLength() public view returns(uint256) {

        return distributions.length;

    }



    // == Abstract functions to be defined in realization ==

    function handleDepositInternal(address sender, uint256 amount) internal;

    function withdrawInternal(address beneficiary, uint256 amount) internal;

    function poolBalanceOfDAI() internal /*view*/ returns(uint256); //This is not a view function because cheking cDAI balance may update it

    function totalSupplyOfPTK() internal view returns(uint256);

    function initialBalances() internal returns(uint256 poolDAI, uint256 totalPTK); //This is not a view function because cheking cDAI balance may update it



    // == Internal functions of DefiModule

    function _createInitialDistribution() internal {

        assert(distributions.length == 0);

        (uint256 poolDAI, ) = initialBalances();

        distributions.push(Distribution({

            amount:0,

            balance: poolDAI

        }));

    }



    function _createDistributionIfReady() internal {

        if (now < nextDistributionTimestamp) return;

        _createDistribution();

    }



    function _createDistribution() internal {

        Distribution storage prev = distributions[distributions.length - 1]; //This is safe because _createInitialDistribution called in initialize.

        uint256 currentBalanceOfDAI = poolBalanceOfDAI();



        uint256 a = currentBalanceOfDAI.add(withdrawalsSinceLastDistribution);

        uint256 b = depositsSinceLastDistribution.add(prev.balance);

        uint256 distributionAmount;

        if (a > b) {

            distributionAmount = a - b;

        }

        if (distributionAmount == 0) return;



        distributions.push(Distribution({

            amount:distributionAmount,

            balance: currentBalanceOfDAI

        }));

        depositsSinceLastDistribution = 0;

        withdrawalsSinceLastDistribution = 0;

        nextDistributionTimestamp = now.sub(now % DISTRIBUTION_AGGREGATION_PERIOD).add(DISTRIBUTION_AGGREGATION_PERIOD);



        //Notify FundsModule about new liquidity and distribute PTK

        IFundsModule fundsModule = fundsModule();

        uint256 pAmount = fundsModule.distributeLInterest(distributionAmount);

        emit InvestmentDistributionCreated(distributionAmount, currentBalanceOfDAI, pAmount);

    }



    function fundsModule() internal view returns(IFundsModule) {

        return IFundsModule(getModuleAddress(MODULE_FUNDS));

    }



}



contract RAYModule is DefiModuleBase, IERC721Receiver {

    //bytes32 public constant PORTFOLIO_ID = keccak256("DaiCompound"); //For rinkeby testnet

    bytes32 public constant PORTFOLIO_ID = keccak256("McdAaveBzxCompoundDsrDydx"); //For mainnet

    bytes32 internal constant PORTFOLIO_MANAGER_CONTRACT = keccak256("PortfolioManagerContract");

    bytes32 internal constant NAV_CALCULATOR_CONTRACT = keccak256("NAVCalculatorContract");

    bytes32 internal constant RAY_TOKEN_CONTRACT = keccak256("RAYTokenContract");

    bytes4 internal constant ERC721_RECEIVER = bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));



    bytes32 public rayTokenId;



    function initialize(address _pool) public initializer {

        DefiModuleBase.initialize(_pool);

    }



    function onERC721Received(address, address, uint256, bytes memory) public returns (bytes4) {

        address rayTokenContract = rayStorage().getContractAddress(RAY_TOKEN_CONTRACT);

        require(_msgSender() == rayTokenContract, "RAYModule: only accept RAY Token transfers");

        return ERC721_RECEIVER;

    }



    function handleDepositInternal(address, uint256 amount) internal {

        IRAY pm = rayPortfolioManager();

        lToken().approve(address(pm), amount);

        if (rayTokenId == 0x0) {

            rayTokenId = pm.mint(PORTFOLIO_ID, address(this), amount);

        } else {

            pm.deposit(rayTokenId, amount);

        }

    }



    function withdrawInternal(address beneficiary, uint256 amount) internal {

        rayPortfolioManager().redeem(rayTokenId, amount, address(0));

        lToken().transfer(beneficiary, amount);

    }



    /**

     * @dev This function allows move funds to RayModule (by loading current balances)

     * and at the same time does not require Pool to be fully-initialized on deployment

     */

    function initialBalances() internal returns(uint256 poolDAI, uint256 totalPTK) {

        bool success;

        bytes memory result;



        poolDAI = poolBalanceOfDAI(); // This returns 0 immidiately if rayTokenId == 0x0, and it can not be zero only if all addresses available



        (success, result) = pool.staticcall(abi.encodeWithSignature("get(string)", MODULE_PTOKEN));

        require(success, "RAYModule: Pool error on get(ptoken)");

        address ptk = abi.decode(result, (address));

        if (ptk != ZERO_ADDRESS) totalPTK = IPToken(ptk).distributionTotalSupply(); // else totalPTK == 0;

    }



    function poolBalanceOfDAI() internal returns(uint256) {

        if (rayTokenId == 0x0) return 0;

        (uint256 poolDAI,) = rayNAVCalculator().getTokenValue(PORTFOLIO_ID, rayTokenId);

        return poolDAI;

    }

    

    function totalSupplyOfPTK() internal view returns(uint256) {

        return pToken().distributionTotalSupply();

    }

    

    function rayPortfolioManager() private view returns(IRAY){

        return rayPortfolioManager(rayStorage());

    }



    function rayPortfolioManager(IRAYStorage rayStorage) private view returns(IRAY){

        return IRAY(rayStorage.getContractAddress(PORTFOLIO_MANAGER_CONTRACT));

    }



    function rayNAVCalculator() private view returns(IRAY){

        return rayNAVCalculator(rayStorage());

    }



    function rayNAVCalculator(IRAYStorage rayStorage) private view returns(IRAY){

        return IRAY(rayStorage.getContractAddress(NAV_CALCULATOR_CONTRACT));

    }



    function rayStorage() private view returns(IRAYStorage){

        return IRAYStorage(getModuleAddress(MODULE_RAY));

    }



    function lToken() private view returns(IERC20){

        return IERC20(getModuleAddress(MODULE_LTOKEN));

    }

    

    function pToken() private view returns(IPToken){

        return IPToken(getModuleAddress(MODULE_PTOKEN));

    }

}

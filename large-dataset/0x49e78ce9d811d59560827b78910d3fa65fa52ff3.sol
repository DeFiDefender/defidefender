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



// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol



pragma solidity ^0.5.0;





/**

 * @dev Optional functions from the ERC20 standard.

 */

contract ERC20Detailed is IERC20 {

    string private _name;

    string private _symbol;

    uint8 private _decimals;



    /**

     * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of

     * these values are immutable: they can only be set once during

     * construction.

     */

    constructor (string memory name, string memory symbol, uint8 decimals) public {

        _name = name;

        _symbol = symbol;

        _decimals = decimals;

    }



    /**

     * @dev Returns the name of the token.

     */

    function name() public view returns (string memory) {

        return _name;

    }



    /**

     * @dev Returns the symbol of the token, usually a shorter version of the

     * name.

     */

    function symbol() public view returns (string memory) {

        return _symbol;

    }



    /**

     * @dev Returns the number of decimals used to get its user representation.

     * For example, if `decimals` equals `2`, a balance of `505` tokens should

     * be displayed to a user as `5,05` (`505 / 10 ** 2`).

     *

     * Tokens usually opt for a value of 18, imitating the relationship between

     * Ether and Wei.

     *

     * NOTE: This information is only used for _display_ purposes: it in

     * no way affects any of the arithmetic of the contract, including

     * {IERC20-balanceOf} and {IERC20-transfer}.

     */

    function decimals() public view returns (uint8) {

        return _decimals;

    }

}



// File: openzeppelin-solidity/contracts/GSN/Context.sol



pragma solidity ^0.5.0;



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



// File: openzeppelin-solidity/contracts/ownership/Ownable.sol



pragma solidity ^0.5.0;



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



// File: contracts/interfaces/IAuthorization.sol



pragma solidity 0.5.12;



interface IAuthorization {

    function getKycAddress() external view returns (address);



    function getDepositAddress() external view returns (address);



    function hasDeposited(address user) external view returns (bool);



    function isKYCConfirmed(address user) external view returns (bool);



    function setKYCRegistry(address _kycAddress) external returns (bool);



    function setDepositRegistry(address _depositAddress) external returns (bool);

}



// File: contracts/interfaces/ILoanContract.sol



pragma solidity 0.5.12;



interface ILoanContract {

    function onFundingReceived(address lender, uint256 amount) external returns (bool);

    function withdrawRepayment() external;

    function withdrawRepaymentAndDeposit() external;

    function withdrawLoan() external;

    function onRepaymentReceived(address from, uint256 amount) external returns (bool);

    function getInterestRate() external view returns (uint256);

    function calculateValueWithInterest(uint256 value) external view returns (uint256);

    function getMaxAmount() external view returns (uint256);

    function getAuctionBalance() external view returns (uint256);

    function getTokenAddress() external view returns (address);

}



// File: contracts/interfaces/IDAIProxy.sol



pragma solidity 0.5.12;



interface IDAIProxy {

    function fund(address loanAddress, uint256 fundingAmount) external;

    function repay(address loanAddress, uint256 repaymentAmount) external;

}



// File: contracts/interfaces/IUniswapSwapper.sol



pragma solidity 0.5.12;





interface IUniswapSwapper {

    event Swap(

        address caller,

        address guy,

        address inputToken,

        address outputToken,

        uint256 inputTokenAmount,

        uint256 outputTokenAmount,

        uint256 inputTokenSpent

    );



    function init(address _factoryAddress) external returns (bool);



    function isDestroyed() external view returns (bool);



    function swap(

        address payable guy,

        address inputTokenAddress,

        address outputTokenAddress,

        uint256 inputTokenAmount,

        uint256 outputTokenAmount

    ) external;



    function swapEth(address payable guy, address outputTokenAddress, uint256 outputTokenAmount)

        external

        payable;

}



// File: contracts/interfaces/IUniswapSwapperFactory.sol



pragma solidity 0.5.12;





interface IUniswapSwapperFactory {

    event SwapContract(address newSwap);



    function setUniswapAddress(address _uniswapAddress) external;



    function setLibraryAddress(address _libraryAddress) external;



    function deploy() external returns (address proxyAddress);

}



// File: contracts/libs/ERC20Wrapper.sol



pragma solidity 0.5.12;



interface IERC20Wrapper {

    function totalSupply() external view returns (uint256);

    function balanceOf(address _owner) external view returns (uint256);

    function allowance(address _owner, address _spender) external view returns (uint256);

    function transfer(address _to, uint256 _quantity) external returns (bool);

    function transferFrom(address _from, address _to, uint256 _quantity) external returns (bool);

    function approve(address _spender, uint256 _quantity) external returns (bool);

    function symbol() external view returns (string memory);

}



library ERC20Wrapper {

    function balanceOf(address _token, address _owner) external view returns (uint256) {

        return IERC20Wrapper(_token).balanceOf(_owner);

    }



    function allowance(address _token, address owner, address spender)

        external

        view

        returns (uint256)

    {

        return IERC20Wrapper(_token).allowance(owner, spender);

    }



    function transfer(address _token, address _to, uint256 _quantity) external returns (bool) {

        if (isIssuedToken(_token)) {

            IERC20Wrapper(_token).transfer(_to, _quantity);



            require(checkSuccess(), "ERC20Wrapper.transfer: Bad return value");

            return true;

        } else {

            return IERC20Wrapper(_token).transfer(_to, _quantity);

        }

    }



    function transferFrom(address _token, address _from, address _to, uint256 _quantity)

        external

        returns (bool)

    {

        if (isIssuedToken(_token)) {

            IERC20Wrapper(_token).transferFrom(_from, _to, _quantity);

            // Check that transferFrom returns true or null

            require(checkSuccess(), "ERC20Wrapper.transferFrom: Bad return value");

            return true;

        } else {

            return IERC20Wrapper(_token).transferFrom(_from, _to, _quantity);

        }

    }



    function approve(address _token, address _spender, uint256 _quantity) external returns (bool) {

        if (isIssuedToken(_token)) {

            IERC20Wrapper(_token).approve(_spender, _quantity);

            // Check that approve returns true or null

            require(checkSuccess(), "ERC20Wrapper.approve: Bad return value");

            return true;

        } else {

            return IERC20Wrapper(_token).approve(_spender, _quantity);

        }

    }



    function isIssuedToken(address _token) private view returns (bool) {

        return (keccak256(abi.encodePacked((IERC20Wrapper(_token).symbol()))) ==

            keccak256(abi.encodePacked(("USDT"))));

    }



    // ============ Private Functions ============



    /**

     * Checks the return value of the previous function up to 32 bytes. Returns true if the previous

     * function returned 0 bytes or 1.

     */

    function checkSuccess() private pure returns (bool) {

        // default to failure

        uint256 returnValue = 0;



        assembly {

            // check number of bytes returned from last function call

            switch returndatasize

                // no bytes returned: assume success

                case 0x0 {

                    returnValue := 1

                }

                // 32 bytes returned

                case 0x20 {

                    // copy 32 bytes into scratch space

                    returndatacopy(0x0, 0x0, 0x20)



                    // load those bytes into returnValue

                    returnValue := mload(0x0)

                }

                // not sure what was returned: dont mark as success

                default {



                }

        }



        // check if returned value is one or nothing

        return returnValue == 1;

    }

}



// File: contracts/DAIProxy.sol



pragma solidity 0.5.12;

























contract DAIProxy is IDAIProxy, Ownable {

    using SafeMath for uint256;



    IAuthorization auth;

    address public administrator;

    address public swapperFactoryAddress;

    bool public hasToDeposit;

    bool public swapEnabled = true;



    event AuthAddressUpdated(address newAuthAddress, address administrator);

    event AdministratorUpdated(address newAdministrator);

    event HasToDeposit(bool value, address administrator);



    constructor(address authAddress, address _swapperFactoryAddress) public {

        auth = IAuthorization(authAddress);

        swapperFactoryAddress = _swapperFactoryAddress;

    }



    function setDepositRequeriment(bool value) external onlyAdmin {

        hasToDeposit = value;

        emit HasToDeposit(value, administrator);

    }



    function setUniswapSwapper(address value) external onlyAdmin {

        swapperFactoryAddress = value;

    }



    function toggleUniswap(bool value) external onlyAdmin {

        swapEnabled = value;

    }



    function setAdministrator(address admin) external onlyOwner {

        administrator = admin;

        emit AdministratorUpdated(administrator);

    }



    function setAuthAddress(address authAddress) external onlyAdmin {

        auth = IAuthorization(authAddress);

        emit AuthAddressUpdated(authAddress, administrator);

    }



    function swapTokenAndFund(

        address loanAddress,

        address inputTokenAddress,

        uint256 inputTokenAmount,

        uint256 fundingAmount

    ) external uniswapIsEnabled onlyHasDepositCanFund onlyKYCCanFund returns (bool) {

        address outputTokenAddress = ILoanContract(loanAddress).getTokenAddress();

        uint256 newFundingAmount = _calculateFunds(loanAddress, fundingAmount);

        require(

            ILoanContract(loanAddress).onFundingReceived(msg.sender, newFundingAmount),

            "funding failed at loan contract"

        );

        require(

            _swapToken(inputTokenAddress, outputTokenAddress, inputTokenAmount, newFundingAmount),

            "error swap"

        );

        require(

            ERC20Wrapper.transfer(outputTokenAddress, loanAddress, newFundingAmount),

            "failed at transferFrom"

        );

        return true;

    }



    function swapEthAndFund(address loanAddress, uint256 fundingAmount)

        external

        payable

        uniswapIsEnabled

        onlyHasDepositCanFund

        onlyKYCCanFund

        returns (bool)

    {

        address outputTokenAddress = ILoanContract(loanAddress).getTokenAddress();

        uint256 newFundingAmount = _calculateFunds(loanAddress, fundingAmount);

        require(

            ILoanContract(loanAddress).onFundingReceived(msg.sender, newFundingAmount),

            "funding failed at loan contract"

        );

        require(_swapEth(outputTokenAddress, newFundingAmount), "error swap");

        require(

            ERC20Wrapper.transfer(outputTokenAddress, loanAddress, newFundingAmount),

            "failed at transferFrom"

        );

        return true;

    }



    function _swapToken(

        address inputTokenAddress,

        address outputTokenAddress,

        uint256 inputTokenAmount,

        uint256 outputTokenAmount

    ) internal returns (bool) {

        address swapperAddress = IUniswapSwapperFactory(swapperFactoryAddress).deploy();

        require(

            ERC20Wrapper.transferFrom(

                inputTokenAddress,

                msg.sender,

                address(this),

                inputTokenAmount

            ),

            "failed at transferFrom prior swap"

        );

        require(

            ERC20Wrapper.approve(inputTokenAddress, swapperAddress, inputTokenAmount),

            "failed at approve prior swap"

        );

        IUniswapSwapper(swapperAddress).swap(

            msg.sender,

            inputTokenAddress,

            outputTokenAddress,

            inputTokenAmount,

            outputTokenAmount

        );

        require(

            IUniswapSwapper(swapperAddress).isDestroyed() == true,

            "Swap contract should selfdestruct"

        );

        return true;

    }



    function _swapEth(address outputTokenAddress, uint256 outputTokenAmount)

        internal

        returns (bool)

    {

        address swapperAddress = IUniswapSwapperFactory(swapperFactoryAddress).deploy();

        IUniswapSwapper(swapperAddress).swapEth.value(msg.value)(

            msg.sender,

            outputTokenAddress,

            outputTokenAmount

        );

        require(

            IUniswapSwapper(swapperAddress).isDestroyed() == true,

            "Swap contract should selfdestruct"

        );

        return true;

    }



    function fund(address loanAddress, uint256 fundingAmount)

        external

        onlyHasDepositCanFund

        onlyKYCCanFund

    {

        uint256 newFundingAmount = _calculateFunds(loanAddress, fundingAmount);

        require(

            ILoanContract(loanAddress).onFundingReceived(msg.sender, newFundingAmount),

            "funding failed at loan contract"

        );

        require(transfer(loanAddress, newFundingAmount), "erc20 transfer failed");

    }



    function _calculateFunds(address loanAddress, uint256 fundingAmount)

        internal

        returns (uint256)

    {

        uint256 newFundingAmount = fundingAmount;

        uint256 auctionBalance = ILoanContract(loanAddress).getAuctionBalance();

        uint256 maxAmount = ILoanContract(loanAddress).getMaxAmount();



        if (auctionBalance.add(fundingAmount) > maxAmount) {

            newFundingAmount = maxAmount.sub(auctionBalance);

        }

        require(newFundingAmount > 0, "funding amount can not be zero");

        return newFundingAmount;

    }



    function repay(address loanAddress, uint256 repaymentAmount) external onlyKYCCanFund {

        ILoanContract loanContract = ILoanContract(loanAddress);

        require(

            loanContract.onRepaymentReceived(msg.sender, repaymentAmount),

            "repayment failed at loan contract"

        );

        require(transfer(loanAddress, repaymentAmount), "erc20 repayment failed");

    }



    function transfer(address loanAddress, uint256 amount) internal returns (bool) {

        address tokenAddress = ILoanContract(loanAddress).getTokenAddress();

        require(

            ERC20Wrapper.allowance(tokenAddress, msg.sender, address(this)) >= amount,

            "funding not approved"

        );

        uint256 balance = ERC20Wrapper.balanceOf(tokenAddress, msg.sender);

        require(balance >= amount, "Not enough funds");

        require(

            ERC20Wrapper.transferFrom(tokenAddress, msg.sender, loanAddress, amount),

            "failed at transferFrom"

        );



        return true;

    }



    modifier onlyKYCCanFund {

        require(auth.isKYCConfirmed(msg.sender), "user does not have KYC");

        _;

    }



    modifier uniswapIsEnabled {

        require(swapEnabled == true, "uniswap is disabled");

        _;

    }



    modifier onlyHasDepositCanFund {

        if (hasToDeposit) {

            require(auth.hasDeposited(msg.sender), "user does not have a deposit");

        }

        _;

    }



    modifier onlyAdmin() {

        require(msg.sender == administrator, "Caller is not an administrator");

        _;

    }

}

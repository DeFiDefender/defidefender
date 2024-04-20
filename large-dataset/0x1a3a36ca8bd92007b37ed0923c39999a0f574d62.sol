pragma solidity 0.5.16;



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





library BasisPoints {

    using SafeMath for uint;



    uint constant private BASIS_POINTS = 10000;



    function mulBP(uint amt, uint bp) internal pure returns (uint) {

        if (amt == 0) return 0;

        return amt.mul(bp).div(BASIS_POINTS);

    }



    function divBP(uint amt, uint bp) internal pure returns (uint) {

        require(bp > 0, "Cannot divide by zero.");

        if (amt == 0) return 0;

        return amt.mul(BASIS_POINTS).div(bp);

    }



    function addBP(uint amt, uint bp) internal pure returns (uint) {

        if (amt == 0) return 0;

        if (bp == 0) return amt;

        return amt.add(mulBP(amt, bp));

    }



    function subBP(uint amt, uint bp) internal pure returns (uint) {

        if (amt == 0) return 0;

        if (bp == 0) return amt;

        return amt.sub(mulBP(amt, bp));

    }

}





/**

 * Official Site: https://myx.network

 * Telegram: https://t.me/myxnetwork

 * Twitter: https://twitter.com/myxnetwork

 * Copyright 2020 MYX Network All Rights Reserved.

 * No alteration, reproduction or replication of this contract without prior written consent from MYX Network

*/

interface Callable {

  function tokenCallback(address _from, uint256 _tokens, bytes calldata _data) external returns (bool);

}



contract MYXNetwork {



  uint256 constant private FLOAT_SCALAR = 2**64;

  uint256 constant private INITIAL_SUPPLY = 1e27; // 1B

  uint256 constant private BURN_RATE = 5; // 5% per tx

  uint256 constant private SUPPLY_FLOOR = 10; // 10% of 1B = 100M

  uint256 constant private MIN_FREEZE_AMOUNT = 1e20; // 100



  string constant public name = "MYX Network";

  string constant public symbol = "MYX";

  uint8 constant public decimals = 18;



  struct User {

    bool whitelisted;

    uint256 balance;

    uint256 frozen;

    mapping(address => uint256) allowance;

    int256 scaledPayout;

  }



  struct Info {

    uint256 totalSupply;

    uint256 totalFrozen;

    mapping(address => User) users;

    uint256 scaledPayoutPerToken;

    address admin;

  }

  Info private info;





  event Transfer(address indexed from, address indexed to, uint256 tokens);

  event Approval(address indexed owner, address indexed spender, uint256 tokens);

  event Whitelist(address indexed user, bool status);

  event Freeze(address indexed owner, uint256 tokens);

  event Unfreeze(address indexed owner, uint256 tokens);

  event Collect(address indexed owner, uint256 tokens);

  event Burn(uint256 tokens);





  constructor() public {

    info.admin = msg.sender;

    info.totalSupply = INITIAL_SUPPLY;

    info.users[msg.sender].balance = INITIAL_SUPPLY;

    emit Transfer(address(0x0), msg.sender, INITIAL_SUPPLY);

    whitelist(msg.sender, true);

  }



  function freeze(uint256 _tokens) external {

    _freeze(_tokens);

  }



  function unfreeze(uint256 _tokens) external {

    _unfreeze(_tokens);

  }



  function collect() external returns (uint256) {

    uint256 _dividends = dividendsOf(msg.sender);

    require(_dividends >= 0);

    info.users[msg.sender].scaledPayout += int256(_dividends * FLOAT_SCALAR);

    info.users[msg.sender].balance += _dividends;

    emit Transfer(address(this), msg.sender, _dividends);

    emit Collect(msg.sender, _dividends);

    return _dividends;

  }



  function burn(uint256 _tokens) external {

    require(balanceOf(msg.sender) >= _tokens);

    info.users[msg.sender].balance -= _tokens;

    uint256 _burnedAmount = _tokens;

    if (info.totalFrozen > 0) {

      _burnedAmount /= 2;

      info.scaledPayoutPerToken += _burnedAmount * FLOAT_SCALAR / info.totalFrozen;

      emit Transfer(msg.sender, address(this), _burnedAmount);

    }

    info.totalSupply -= _burnedAmount;

    emit Transfer(msg.sender, address(0x0), _burnedAmount);

    emit Burn(_burnedAmount);

  }



  function distribute(uint256 _tokens) external {

    require(info.totalFrozen > 0);

    require(balanceOf(msg.sender) >= _tokens);

    info.users[msg.sender].balance -= _tokens;

    info.scaledPayoutPerToken += _tokens * FLOAT_SCALAR / info.totalFrozen;

    emit Transfer(msg.sender, address(this), _tokens);

  }



  function transfer(address _to, uint256 _tokens) external returns (bool) {

    _transfer(msg.sender, _to, _tokens);

    return true;

  }



  function approve(address _spender, uint256 _tokens) external returns (bool) {

    info.users[msg.sender].allowance[_spender] = _tokens;

    emit Approval(msg.sender, _spender, _tokens);

    return true;

  }



  function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool) {

    require(info.users[_from].allowance[msg.sender] >= _tokens);

    info.users[_from].allowance[msg.sender] -= _tokens;

    _transfer(_from, _to, _tokens);

    return true;

  }



  function transferAndCall(address _to, uint256 _tokens, bytes calldata _data) external returns (bool) {

    uint256 _transferred = _transfer(msg.sender, _to, _tokens);

    uint32 _size;

    assembly {

      _size := extcodesize(_to)

    }

    if (_size > 0) {

      require(Callable(_to).tokenCallback(msg.sender, _transferred, _data));

    }

    return true;

  }



  function bulkTransfer(address[] calldata _receivers, uint256[] calldata _amounts) external {

    require(_receivers.length == _amounts.length);

    for (uint256 i = 0; i < _receivers.length; i++) {

      _transfer(msg.sender, _receivers[i], _amounts[i]);

    }

  }



  function whitelist(address _user, bool _status) public {

    require(msg.sender == info.admin);

    info.users[_user].whitelisted = _status;

    emit Whitelist(_user, _status);

  }





  function totalSupply() public view returns (uint256) {

    return info.totalSupply;

  }



  function totalFrozen() public view returns (uint256) {

    return info.totalFrozen;

  }



  function balanceOf(address _user) public view returns (uint256) {

    return info.users[_user].balance - frozenOf(_user);

  }



  function frozenOf(address _user) public view returns (uint256) {

    return info.users[_user].frozen;

  }



  function dividendsOf(address _user) public view returns (uint256) {

    return uint256(int256(info.scaledPayoutPerToken * info.users[_user].frozen) - info.users[_user].scaledPayout) / FLOAT_SCALAR;

  }



  function allowance(address _user, address _spender) public view returns (uint256) {

    return info.users[_user].allowance[_spender];

  }



  function isWhitelisted(address _user) public view returns (bool) {

    return info.users[_user].whitelisted;

  }



  function allInfoFor(address _user) public view returns (uint256 totalTokenSupply, uint256 totalTokensFrozen, uint256 userBalance, uint256 userFrozen, uint256 userDividends) {

    return (totalSupply(), totalFrozen(), balanceOf(_user), frozenOf(_user), dividendsOf(_user));

  }





  function _transfer(address _from, address _to, uint256 _tokens) internal returns (uint256) {

    require(balanceOf(_from) >= _tokens);

    info.users[_from].balance -= _tokens;

    uint256 _burnedAmount = _tokens * BURN_RATE / 100;

    if (totalSupply() - _burnedAmount < INITIAL_SUPPLY * SUPPLY_FLOOR / 100 || isWhitelisted(_from)) {

      _burnedAmount = 0;

    }

    uint256 _transferred = _tokens - _burnedAmount;

    info.users[_to].balance += _transferred;

    emit Transfer(_from, _to, _transferred);

    if (_burnedAmount > 0) {

      if (info.totalFrozen > 0) {

        _burnedAmount /= 2;

        info.scaledPayoutPerToken += _burnedAmount * FLOAT_SCALAR / info.totalFrozen;

        emit Transfer(_from, address(this), _burnedAmount);

      }

      info.totalSupply -= _burnedAmount;

      emit Transfer(_from, address(0x0), _burnedAmount);

      emit Burn(_burnedAmount);

    }

    return _transferred;

  }



  function _freeze(uint256 _amount) internal {

    require(balanceOf(msg.sender) >= _amount);

    require(frozenOf(msg.sender) + _amount >= MIN_FREEZE_AMOUNT);

    info.totalFrozen += _amount;

    info.users[msg.sender].frozen += _amount;

    info.users[msg.sender].scaledPayout += int256(_amount * info.scaledPayoutPerToken);

    emit Transfer(msg.sender, address(this), _amount);

    emit Freeze(msg.sender, _amount);

  }



  function _unfreeze(uint256 _amount) internal {

    require(frozenOf(msg.sender) >= _amount);

    uint256 _burnedAmount = _amount * BURN_RATE / 100;

    info.scaledPayoutPerToken += _burnedAmount * FLOAT_SCALAR / info.totalFrozen;

    info.totalFrozen -= _amount;

    info.users[msg.sender].balance -= _burnedAmount;

    info.users[msg.sender].frozen -= _amount;

    info.users[msg.sender].scaledPayout -= int256(_amount * info.scaledPayoutPerToken);

    emit Transfer(address(this), msg.sender, _amount - _burnedAmount);

    emit Unfreeze(msg.sender, _amount);

  }

}





contract MyxDaoFund is Initializable, Ownable {

    using BasisPoints for uint;

    using SafeMath for uint;



    uint public releaseInterval;

    uint public releaseStart;

    uint public releaseBP;



    uint public startingTokens;

    uint public claimedTokens;



    IERC20 private token;



    address releaseWallet;



    bool hasMovedToPresale;

    bool hasMovedToPresale2;



    modifier onlyAfterStart {

        require(releaseStart != 0 && now > releaseStart, "Has not yet started.");

        _;

    }



    function initialize(

        uint _releaseInterval,

        uint _releaseBP,

        address owner,

        IERC20 _token

    ) external initializer {

        releaseInterval = _releaseInterval;

        releaseBP = _releaseBP;

        token = _token;



        Ownable.initialize(msg.sender);



        //Due to issue in oz testing suite, the msg.sender might not be owner

        _transferOwnership(owner);

    }



    function freeze() external onlyOwner {

        require(token.balanceOf(address(this)) > 0, "Must have tokens to stake.");

        MYXNetwork myxContract = MYXNetwork(address(token));

        myxContract.freeze(token.balanceOf(address(this)));

    }



    function unfreeze(uint amount) external onlyOwner onlyAfterStart {

        require(releaseStart != 0, "Has not yet started.");

        MYXNetwork myxContract = MYXNetwork(address(token));

        uint cycle = getCurrentCycleCount();

        uint maxClaim = cycle.mul(startingTokens.mulBP(releaseBP));

        uint totalClaimAmount = cycle.mul(startingTokens.mulBP(releaseBP));

        uint toClaim = totalClaimAmount.sub(maxClaim);

        if (myxContract.frozenOf(address(this)) < toClaim) toClaim = myxContract.frozenOf(address(this));

        require(amount <= toClaim, "Cannot unstake more than available to claim.");

        claimedTokens = claimedTokens.add(amount);

        myxContract.unfreeze(amount);

    }



    function collect() external onlyAfterStart {

        MYXNetwork myxContract = MYXNetwork(address(token));

        myxContract.collect();

    }



    function claim() external onlyAfterStart {

        token.transfer(releaseWallet, token.balanceOf(address(this)));

    }



    function startRelease(address _releaseWallet) external onlyOwner {

        require(startingTokens == 0);

        releaseWallet = _releaseWallet;

        startingTokens = 50000000 ether;

        releaseStart = now.sub(24 hours);

        releaseInterval = 180 days;

        releaseBP = 1000;

    }



    function getCurrentCycleCount() public view returns (uint) {

        if (now <= releaseStart) return 0;

        return now.sub(releaseStart).div(releaseInterval);

    }



}

pragma solidity ^0.5.16;













/**

 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include

 * the optional functions; to access them see {ERC20Detailed}.

 */

interface iERC20 {

  /**

    * @dev Returns the amount of tokens in existence.

    */

  function totalSupply() external view returns (uint);



  /**

    * @dev Returns the amount of tokens owned by `account`.

    */

  function balanceOf(address account) external view returns (uint);



  /**

    * @dev Moves `amount` tokens from the caller's account to `recipient`.

    *

    * Returns a boolean value indicating whether the operation succeeded.

    *

    * Emits a {Transfer} event.

    */

  function transfer(address recipient, uint amount) external returns (bool);



  /**

    * @dev Returns the remaining number of tokens that `spender` will be

    * allowed to spend on behalf of `owner` through {transferFrom}. This is

    * zero by default.

    *

    * This value changes when {approve} or {transferFrom} are called.

    */

  function allowance(address owner, address spender) external view returns (uint);



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

  function approve(address spender, uint amount) external returns (bool);



  /**

    * @dev Moves `amount` tokens from `sender` to `recipient` using the

    * allowance mechanism. `amount` is then deducted from the caller's

    * allowance.

    *

    * Returns a boolean value indicating whether the operation succeeded.

    *

    * Emits a {Transfer} event.

    */

  function transferFrom(address sender, address recipient, uint amount) external returns (bool);



  /**

    * @dev Emitted when `value` tokens are moved from one account (`from`) to

    * another (`to`).

    *

    * Note that `value` may be zero.

    */

  event Transfer(address indexed from, address indexed to, uint value);



  /**

    * @dev Emitted when the allowance of a `spender` for an `owner` is set by

    * a call to {approve}. `value` is the new allowance.

    */

  event Approval(address indexed owner, address indexed spender, uint value);

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

  function add(uint a, uint b) internal pure returns (uint) {

    uint c = a + b;

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

  function sub(uint a, uint b) internal pure returns (uint) {

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

  function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {

    require(b <= a, errorMessage);

    uint c = a - b;



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

  function mul(uint a, uint b) internal pure returns (uint) {

    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the

    // benefit is lost if 'b' is also tested.

    // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522

    if (a == 0) {

      return 0;

    }



    uint c = a * b;

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

  function div(uint a, uint b) internal pure returns (uint) {

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

  function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {

    // Solidity only automatically asserts when dividing by 0

    require(b > 0, errorMessage);

    uint c = a / b;

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

  function mod(uint a, uint b) internal pure returns (uint) {

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

  function mod(uint a, uint b, string memory errorMessage) internal pure returns (uint) {

    require(b != 0, errorMessage);

    return a % b;

  }

}



/**

 * @dev Implementation of the {iERC20} interface.

 *

 * This implementation is agnostic to the way tokens are created. This means

 * that a supply mechanism has to be added in a derived contract using {_mint}.

 * For a generic mechanism see {ERC20Mintable}.

 *

 * TIP: For a detailed writeup see our guide

 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How

 * to implement supply mechanisms].

 *

 * We have followed general OpenZeppelin guidelines: functions revert instead

 * of returning `false` on failure. This behavior is nonetheless conventional

 * and does not conflict with the expectations of ERC20 applications.

 *

 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.

 * This allows applications to reconstruct the allowance for all accounts just

 * by listening to said events. Other implementations of the EIP may not emit

 * these events, as it isn't required by the specification.

 *

 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}

 * functions have been added to mitigate the well-known issues around setting

 * allowances. See {iERC20-approve}.

 */

contract ERC20Base is iERC20 {

  using SafeMath for uint;



  mapping (address => uint) private _balances;



  mapping (address => mapping (address => uint)) private _allowances;



  uint private _totalSupply;



  /**

   * @dev Internal constructor to ensure this contract can't be deployed alone

   */

  constructor() internal{ }



  /**

   * @dev Returns the amount of tokens in existence.

   */

  function totalSupply()

    public

    view

  returns (uint)

  {

    return _totalSupply;

  }



  /**

   * @dev Returns the amount of tokens owned by `account`.

   */

  function balanceOf(address account)

    public

    view

  returns (uint)

  {

    return _balances[account];

  }

  /**

   * @dev Moves `amount` tokens from the caller's account to `recipient`.

   *

   * Returns a boolean value indicating whether the operation succeeded.

   *

   * Emits a {Transfer} event.

   *

   * Requirements:

   *

   * - `recipient` cannot be the zero address.

   * - the caller must have a balance of at least `amount`.

   */

  function transfer(address recipient, uint amount)

    public

  returns (bool)

  {

    _transfer(msg.sender, recipient, amount);

    return true;

  }



  /**

   * @dev Returns the remaining number of tokens that `spender` will be

   * allowed to spend on behalf of `owner` through {transferFrom}. This is

   * zero by default.

   *

   * This value changes when {approve} or {transferFrom} are called.

   */

  function allowance(address owner, address spender)

    public

    view

  returns (uint)

  {

    return _allowances[owner][spender];

  }



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

   *

   * Requirements:

   *

   * - `spender` cannot be the zero address.

   */

  function approve(address spender, uint amount)

    public

  returns (bool)

  {

    _approve(msg.sender, spender, amount);

    return true;

  }



  /**

   * @dev Moves `amount` tokens from `sender` to `recipient` using the

   * allowance mechanism. `amount` is then deducted from the caller's

   * allowance.

   *

   * Returns a boolean value indicating whether the operation succeeded.

   *

   * Emits a {Transfer} event.

   *

   * Emits an {Approval} event indicating the updated allowance. This is not

   * required by the EIP. See the note at the beginning of {ERC20};

   *

   * Requirements:

   * - `sender` and `recipient` cannot be the zero address.

   * - `sender` must have a balance of at least `amount`.

   * - the caller must have allowance for `sender`'s tokens of at least

   * `amount`.

   */

  function transferFrom(address sender, address recipient, uint amount)

    public

  returns (bool)

  {

    _transfer(sender, recipient, amount);

    _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));

    return true;

  }



  /**

    * @dev Atomically increases the allowance granted to `spender` by the caller.

    *

    * This is an alternative to {approve} that can be used as a mitigation for

    * problems described in {iERC20-approve}.

    *

    * Emits an {Approval} event indicating the updated allowance.

    *

    * Requirements:

    *

    * - `spender` cannot be the zero address.

    */

  function increaseAllowance(address spender, uint addedValue)

    public

  returns (bool)

  {

    _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));

    return true;

  }



  /**

    * @dev Atomically decreases the allowance granted to `spender` by the caller.

    *

    * This is an alternative to {approve} that can be used as a mitigation for

    * problems described in {iERC20-approve}.

    *

    * Emits an {Approval} event indicating the updated allowance.

    *

    * Requirements:

    *

    * - `spender` cannot be the zero address.

    * - `spender` must have allowance for the caller of at least

    * `subtractedValue`.

    */

  function decreaseAllowance(address spender, uint subtractedValue)

    public

  returns (bool)

  {

    _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));

    return true;

  }



  /**

    * @dev Moves tokens `amount` from `sender` to `recipient`.

    *

    * This is internal function is equivalent to {transfer}, and can be used to

    * e.g. implement automatic token fees, slashing mechanisms, etc.

    *

    * Emits a {Transfer} event.

    *

    * Requirements:

    *

    * - `sender` cannot be the zero address.

    * - `recipient` cannot be the zero address.

    * - `sender` must have a balance of at least `amount`.

    */

  function _transfer(address sender, address recipient, uint amount)

    internal

  {

    require(sender != address(0), "ERC20: transfer from the zero address");

    require(recipient != address(0), "ERC20: transfer to the zero address");



    _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");

    _balances[recipient] = _balances[recipient].add(amount);

    emit Transfer(sender, recipient, amount);

  }



  /** @dev Creates `amount` tokens and assigns them to `account`, increasing

    * the total supply.

    *

    * Emits a {Transfer} event with `from` set to the zero address.

    *

    * Requirements

    *

    * - `to` cannot be the zero address.

    */

  function _mint(address account, uint amount)

    internal

  {

    require(account != address(0), "ERC20: mint to the zero address");



    _totalSupply = _totalSupply.add(amount);

    _balances[account] = _balances[account].add(amount);

    emit Transfer(address(0), account, amount);

  }



  /**

    * @dev Destroys `amount` tokens from `account`, reducing the

    * total supply.

    *

    * Emits a {Transfer} event with `to` set to the zero address.

    *

    * Requirements

    *

    * - `account` cannot be the zero address.

    * - `account` must have at least `amount` tokens.

    */

  function _burn(address account, uint amount)

    internal

  {

    require(account != address(0), "ERC20: burn from the zero address");



    _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");

    _totalSupply = _totalSupply.sub(amount);

    emit Transfer(account, address(0), amount);

  }



  /**

    * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.

    *

    * This is internal function is equivalent to `approve`, and can be used to

    * e.g. set automatic allowances for certain subsystems, etc.

    *

    * Emits an {Approval} event.

    *

    * Requirements:

    *

    * - `owner` cannot be the zero address.

    * - `spender` cannot be the zero address.

    */

  function _approve(address owner, address spender, uint amount)

    internal

  {

    require(owner != address(0), "ERC20: approve from the zero address");

    require(spender != address(0), "ERC20: approve to the zero address");



    _allowances[owner][spender] = amount;

    emit Approval(owner, spender, amount);

  }

}







// @title iStakingContract

// @dev The interface for cross-contract calls to the Staking contract

// @author GAME Credits Platform (https://www.gamecredits.org)

// (c) 2020 GAME Credits. All Rights Reserved. This code is not open source.

contract iStakingContract {



  //function balanceOf(address _owner) public view returns (uint);

  function getGameAccountStake(uint _game, address _account) external view returns(uint);

  function updateStake(uint _game, address _account, uint _stakeAmount) external;

  function fundStakePool(uint _amount, uint _startWeek, uint _numberOfWeeks) external;

}





// @title Game ERC20 Token Contract

// @dev Contract for managing the GAME ERC20 token

// @author GAME Credits Platform (https://www.gamecredits.org)

// (c) 2020 GAME Credits. All Rights Reserved. This code is not open source.

contract ERC20Contract is ERC20Base {



  string public url = "https://www.gamecredits.org";

  string public name = "GAME Credits";

  string public symbol = "GAME";

  uint8 public decimals = 18;

  iStakingContract public stakingContract;



  // @notice The constructor mints 200 million GAME tokens to the contract creator

  //   There is no other way to create GAME tokens, capping supply at 200 million

  constructor()

    public

  {

    _mint(msg.sender, 200 * 10 ** 24);

  }



  // @dev Used to set the staking contract reference for this contract

  // @param _stakingContract - the address of the staking contract

  // @notice This is a one-shot function. Once the address is set, it's locked

  function setStakingContract(iStakingContract _stakingContract)

    external

  {

    require(address(stakingContract) == address(0), "Staking contract must not be set");

    stakingContract = _stakingContract;

  }



  // @dev Lets any user add funds to the staking pool spread over a period of weeks

  // @param _amount - the total amount of GAME tokens to add to the stake pool

  // @param _startWeek - the first week in which tokens will be added to the stake pool

  // @param _numberOfWeeks - the number of weeks over which the _amount will be spread

  // @notice - The _amount must be exactly divisible by the _numberOfWeeks

  function fundStakingContract(uint _amount, uint _startWeek, uint _numberOfWeeks)

    external

  {

    _transfer(msg.sender, address(stakingContract), _amount);

    stakingContract.fundStakePool(_amount, _startWeek, _numberOfWeeks);

  }



  // @dev Sets the sender's stake on a game to the specific value

  // @param _game - the game to be staked on

  // @param _increase - the amount stake to be added

  // @notice - this will throw if the user has insufficient tokens available

  // @notice - this does not throw on an _amount of 0

  function setStake(uint _game, uint _amount) public {

    _setStake(msg.sender, _game, _amount);

  }



  // @dev Increases the sender's stake on a game

  // @param _game - the game to be staked on

  // @param _increase - the amount stake to be added

  // @notice - this will throw if the user has insufficient tokens available

  // @notice - this will throw if an increase of 0 is requested

  function increaseStake(uint _game, uint _increase) public {

    uint stakedBalance = stakingContract.getGameAccountStake(_game, msg.sender);

    require(_increase > 0, "can't increase by 0");

    _setStake(msg.sender, _game, stakedBalance.add(_increase));

  }



  // @dev Reduces the sender's stake on a game

  // @param _game - the game to be staked on

  // @param _decrease - the amount stake to be reduced

  // @notice - this will throw if the user has fewer tokens staked

  // @notice - this will throw if a decrease of 0 is requested

  function decreaseStake(uint _game, uint _decrease) public {

    uint stakedBalance = stakingContract.getGameAccountStake(_game, msg.sender);

    require(_decrease > 0, "can't decrease by 0");

    _setStake(msg.sender, _game, stakedBalance.sub(_decrease));

  }



  // @dev Transfers tokens to a set of user accounts, and sets their stake for them

  // @param _recipients - the accounts to receive the tokens

  // @param _games - the games to be staked on

  // @param _amounts - the amount of tokens to be transferred

  // @notice - this function is designed for air dropping by/to a game

  function airDropAndStake(address[] calldata _recipients, uint[] calldata _games, uint[] calldata _amounts)

    external

  {

    require(_recipients.length == _games.length, "must be equal number of recipients and games");

    require(_recipients.length == _amounts.length, "must be equal number of recipients and amounts");

    for (uint i = 0; i < _recipients.length; i++) {

      require(_recipients[i] != msg.sender, "can't airDrop to your own account");

      uint stakedBalance = stakingContract.getGameAccountStake(_games[i], _recipients[i]);

      uint stakeAmount = _amounts[i].add(stakedBalance);

      _transfer(msg.sender, _recipients[i], _amounts[i]);

      _setStake(_recipients[i], _games[i], stakeAmount);



    }

  }



  // @dev Sends the stake setting to the staking contract; transfers tokens to the

  //   contract (for an increased stake) or from the contract (decreased stake)

  // @param _staker - the account doing the staking

  // @param _game - the game to be staked on

  // @param _amount - the amount of tokens to set the stake to

  function _setStake(address _staker, uint _game, uint _amount)

    internal

  {

    // get user's balance from staking contract

    uint stakedBalance = stakingContract.getGameAccountStake(_game, _staker);



    if (_amount == stakedBalance) {

      return;

    } else if (_amount > stakedBalance) {

      // transfer diff to staking contract

      _transfer(_staker, address(stakingContract), _amount.sub(stakedBalance));

    } else if (_amount < stakedBalance) {

      // transfer diff to account

      _transfer(address(stakingContract), _staker, stakedBalance.sub(_amount));

    }

    stakingContract.updateStake(_game, _staker, _amount);

  }

}

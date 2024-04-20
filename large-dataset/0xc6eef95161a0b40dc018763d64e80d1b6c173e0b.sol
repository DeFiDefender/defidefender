pragma solidity ^0.5.17;



interface IFaceValue {

  using SafeMath for uint256;

  using FixidityLib for int256;

  using ExponentLib for int256;



  function getFixedInitialValue() external view returns (int256);



  function getFixedFaceValue(uint256 currentTimestamp) external view returns (int256);

}



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



contract Ownable is Context {

    address private _owner;



    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);



    /**

     * @dev Initializes the contract setting the deployer as the initial owner.

     */

    constructor () internal {

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



contract ERC20 is Context, IERC20 {

    using SafeMath for uint256;



    mapping (address => uint256) private _balances;



    mapping (address => mapping (address => uint256)) private _allowances;



    uint256 private _totalSupply;



    /**

     * @dev See {IERC20-totalSupply}.

     */

    function totalSupply() public view returns (uint256) {

        return _totalSupply;

    }



    /**

     * @dev See {IERC20-balanceOf}.

     */

    function balanceOf(address account) public view returns (uint256) {

        return _balances[account];

    }



    /**

     * @dev See {IERC20-transfer}.

     *

     * Requirements:

     *

     * - `recipient` cannot be the zero address.

     * - the caller must have a balance of at least `amount`.

     */

    function transfer(address recipient, uint256 amount) public returns (bool) {

        _transfer(_msgSender(), recipient, amount);

        return true;

    }



    /**

     * @dev See {IERC20-allowance}.

     */

    function allowance(address owner, address spender) public view returns (uint256) {

        return _allowances[owner][spender];

    }



    /**

     * @dev See {IERC20-approve}.

     *

     * Requirements:

     *

     * - `spender` cannot be the zero address.

     */

    function approve(address spender, uint256 amount) public returns (bool) {

        _approve(_msgSender(), spender, amount);

        return true;

    }



    /**

     * @dev See {IERC20-transferFrom}.

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

    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {

        _transfer(sender, recipient, amount);

        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));

        return true;

    }



    /**

     * @dev Atomically increases the allowance granted to `spender` by the caller.

     *

     * This is an alternative to {approve} that can be used as a mitigation for

     * problems described in {IERC20-approve}.

     *

     * Emits an {Approval} event indicating the updated allowance.

     *

     * Requirements:

     *

     * - `spender` cannot be the zero address.

     */

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {

        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));

        return true;

    }



    /**

     * @dev Atomically decreases the allowance granted to `spender` by the caller.

     *

     * This is an alternative to {approve} that can be used as a mitigation for

     * problems described in {IERC20-approve}.

     *

     * Emits an {Approval} event indicating the updated allowance.

     *

     * Requirements:

     *

     * - `spender` cannot be the zero address.

     * - `spender` must have allowance for the caller of at least

     * `subtractedValue`.

     */

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {

        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));

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

    function _transfer(address sender, address recipient, uint256 amount) internal {

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

    function _mint(address account, uint256 amount) internal {

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

    function _burn(address account, uint256 amount) internal {

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

    function _approve(address owner, address spender, uint256 amount) internal {

        require(owner != address(0), "ERC20: approve from the zero address");

        require(spender != address(0), "ERC20: approve to the zero address");



        _allowances[owner][spender] = amount;

        emit Approval(owner, spender, amount);

    }



    /**

     * @dev Destroys `amount` tokens from `account`.`amount` is then deducted

     * from the caller's allowance.

     *

     * See {_burn} and {_approve}.

     */

    function _burnFrom(address account, uint256 amount) internal {

        _burn(account, amount);

        _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));

    }

}



contract Debt is ERC20, Ownable {

  string private _name;

  string private _symbol;

  uint8 private _decimals;

  string private _contractHash;

  string private _contractUrl;

  uint32 private _interestBPS;

  string private _maturityDate;



  constructor(

    string memory name,

    string memory symbol,

    uint8 decimals,

    string memory contractHash,

    string memory contractUrl,

    uint32 interestBPS,

    string memory maturityDate

  ) public {

    _name = name;

    _symbol = symbol;

    _decimals = decimals;

    _contractHash = contractHash;

    _contractUrl = contractUrl;

    _interestBPS = interestBPS;

    _maturityDate = maturityDate;

  }



  /**

     * @return the name of the token.

     */

  function name() public view returns (string memory) {

    return _name;

  }



  /**

     * @return the symbol of the token.

     */

  function symbol() public view returns (string memory) {

    return _symbol;

  }



  /**

     * @return the number of decimals of the token.

     */

  function decimals() public view returns (uint8) {

    return _decimals;

  }



  /**

     * @return the contractHash

     */

  function contractHash() public view returns (string memory) {

    return _contractHash;

  }



  /**

     * @return the contractUrl

     */

  function contractUrl() public view returns (string memory) {

    return _contractUrl;

  }



  /**

     * @return the interest rate in Basis Points (BPS).

     */

  function interestBPS() public view returns (uint32) {

    return _interestBPS;

  }



  /**

     * @return the maturity date

     */

  function maturityDate() public view returns (string memory) {

    return _maturityDate;

  }



  /**

     * @return set the contractUrl

     */

  function setContractUrl(string memory url) public onlyOwner returns (bool) {

    _contractUrl = url;

    return true;

  }



  /**

    * @dev Destroy the contract

    */

  function Destroy() public onlyOwner returns (bool) {

    selfdestruct(msg.sender);

    return true;

  }



  /**

    * @dev sudo Transfer tokens

    * @param from The address to transfer from.

    * @param to The address to transfer to.

    * @param value The amount to be transferred.

    */

  function sudoTransfer(address from, address to, uint256 value) public onlyOwner returns (bool) {

    _transfer(from, to, value);

    return true;

  }



  /**

    * @dev Mint tokens

    * @param to The address to mint in.

    * @param value The amount to be minted.

    */

  function Mint(address to, uint256 value) public onlyOwner returns (bool) {

    _mint(to, value);

    return true;

  }



  /**

    * @dev Burn tokens

    * @param from The address to burn in.

    * @param value The amount to be burned.

    */

  function Burn(address from, uint256 value) public onlyOwner returns (bool) {

    _burn(from, value);

    return true;

  }

}



contract FaceValueDebt is Debt, IFaceValue {

  int256 private _f_initialValue;

  int256 private _f_nominalInterest;

  uint256 private _compoundingPeriod; // In Seconds

  uint256 private _commencementDateTimestamp;

  uint256 private _maturityDateTimestamp;

  int256 private _f_numberOfCompoundingPeriods;



  constructor(

    // DEBT

    string memory name,

    string memory symbol,

    uint8 decimals,

    string memory contractHash,

    string memory contractUrl,

    uint32 interestBPS,

    string memory maturityDate,

    // FACEVALUE

    uint256 initialValue,

    int256 f_nominalInterestBPS,

    uint256 compoundingPeriod, // In Seconds

    uint256 commencementDateTimestamp, // In Seconds

    uint256 maturityDateTimestamp

  ) public Debt(name, symbol, decimals, contractHash, contractUrl, interestBPS, maturityDate) {

    setFixedInitialValue(initialValue);

    setFixedNominalInterest(f_nominalInterestBPS);

    _compoundingPeriod = compoundingPeriod;

    _commencementDateTimestamp = commencementDateTimestamp;

    _maturityDateTimestamp = maturityDateTimestamp;

    setFixedNumberOfCompoundingPeriods(

      compoundingPeriod,

      maturityDateTimestamp,

      commencementDateTimestamp

    );

  }



  function setFixedNominalInterest(int256 f_nominalInterestBPS) private {

    _f_nominalInterest = f_nominalInterestBPS.divide(10000 * FixidityLib.fixed1());

  }



  function setFixedNumberOfCompoundingPeriods(

    uint256 compoundingPeriod,

    uint256 maturityDateTimestamp,

    uint256 commencementDateTimestamp

  ) private {

    _f_numberOfCompoundingPeriods = int256(

      maturityDateTimestamp.sub(commencementDateTimestamp).div(compoundingPeriod)

    )

      .newFixed();

  }



  function getFixedElapisedPeriods(uint256 currentTimestamp) private view returns (int256) {

    // We want this initial part to be integer division

    return

      int256(currentTimestamp.sub(_commencementDateTimestamp).div(_compoundingPeriod))

        .newFixed();

  }



  function setFixedInitialValue(uint256 initialValue) private {

    _f_initialValue = int256(initialValue).newFixed();

  }



  function getFixedInitialValue() public view returns (int256) {

    return _f_initialValue;

  }



  function getFixedFaceValue(uint256 currentTimestamp) public view returns (int256) {

    if (currentTimestamp <= _commencementDateTimestamp) {

      return getFixedInitialValue();

    } else if (currentTimestamp > _maturityDateTimestamp) {

      return getFixedFaceValue(_maturityDateTimestamp);

    }

    return

      _f_nominalInterest

        .divide(_f_numberOfCompoundingPeriods)

        .add(FixidityLib.fixed1())

        .powerAny(getFixedElapisedPeriods(currentTimestamp))

        .multiply(_f_initialValue);

  }

}



library ExponentLib {



    function fixedExp10() internal pure returns(int256) {

        return 22026465794806716516957900645;

    }



    /**

     * @notice Not fully tested anymore.

     */

    function powerE(int256 _x) 

        internal 

        pure 

        returns (int256) 

    {

        assert(_x < 172 * FixidityLib.fixed1());

        int256 x = _x;

        int256 r = FixidityLib.fixed1();

        while (x >= 10 * FixidityLib.fixed1()) {

            x -= 10 * FixidityLib.fixed1();

            r = FixidityLib.multiply(r, fixedExp10());

        }

        if (x == FixidityLib.fixed1()) {

            return FixidityLib.multiply(r, LogarithmLib.fixedE());

        } else if (x == 0) {

            return r;

        }

        int256 tr = 1 * FixidityLib.fixed1();

        int256 d = tr;

        for (uint8 i = 1; i <= 2 * FixidityLib.digits(); i++) {

            d = (d * x) / (FixidityLib.fixed1() * i);

            tr += d;

        }

        return FixidityLib.multiply(tr, r);

    }



    function powerAny(int256 a, int256 b) 

        internal 

        pure 

        returns (int256) 

    {

        return powerE(FixidityLib.multiply(LogarithmLib.ln(a), b));

    }



    function rootAny(int256 a, int256 b) 

        internal 

        pure 

        returns (int256) 

    {

        return powerAny(a, FixidityLib.reciprocal(b));

    }



    function rootN(int256 a, uint8 n) 

        internal 

        pure 

        returns (int256) 

    {

        return powerE(FixidityLib.divide(LogarithmLib.ln(a), FixidityLib.fixed1() * n));

    }



    // solium-disable-next-line mixedcase

    function round_off(int256 _v, uint8 digits) 

        internal 

        pure 

        returns (int256) 

    {

        int256 t = int256(uint256(10) ** uint256(digits));

        int8 sign = 1;

        int256 v = _v;

        if (v < 0) {

            sign = -1;

            v = 0 - v;

        }

        if (v % t >= t / 2) v = v + t - v % t;

        return v * sign;

    }



    // solium-disable-next-line mixedcase

    function trunc_digits(int256 v, uint8 digits) 

        internal 

        pure 

        returns (int256) 

    {

        if (digits <= 0) return v;

        return round_off(v, digits) / FixidityLib.fixed1();

    }

}



library FixidityLib {



    /**

     * @notice Number of positions that the comma is shifted to the right.

     */

    function digits() internal pure returns(uint8) {

        return 24;

    }

    

    /**

     * @notice This is 1 in the fixed point units used in this library.

     * @dev Test fixed1() equals 10^digits()

     * Hardcoded to 24 digits.

     */

    function fixed1() internal pure returns(int256) {

        return 1000000000000000000000000;

    }



    /**

     * @notice The amount of decimals lost on each multiplication operand.

     * @dev Test mulPrecision() equals sqrt(fixed1)

     * Hardcoded to 24 digits.

     */

    function mulPrecision() internal pure returns(int256) {

        return 1000000000000;

    }



    /**

     * @notice Maximum value that can be represented in an int256

     * @dev Test maxInt256() equals 2^255 -1

     */

    function maxInt256() internal pure returns(int256) {

        return 57896044618658097711785492504343953926634992332820282019728792003956564819967;

    }



    /**

     * @notice Minimum value that can be represented in an int256

     * @dev Test minInt256 equals (2^255) * (-1)

     */

    function minInt256() internal pure returns(int256) {

        return -57896044618658097711785492504343953926634992332820282019728792003956564819968;

    }



    /**

     * @notice Maximum value that can be converted to fixed point. Optimize for

     * @dev deployment. 

     * Test maxNewFixed() equals maxInt256() / fixed1()

     * Hardcoded to 24 digits.

     */

    function maxNewFixed() internal pure returns(int256) {

        return 57896044618658097711785492504343953926634992332820282;

    }



    /**

     * @notice Maximum value that can be converted to fixed point. Optimize for

     * deployment. 

     * @dev Test minNewFixed() equals -(maxInt256()) / fixed1()

     * Hardcoded to 24 digits.

     */

    function minNewFixed() internal pure returns(int256) {

        return -57896044618658097711785492504343953926634992332820282;

    }



    /**

     * @notice Maximum value that can be safely used as an addition operator.

     * @dev Test maxFixedAdd() equals maxInt256()-1 / 2

     * Test add(maxFixedAdd(),maxFixedAdd()) equals maxFixedAdd() + maxFixedAdd()

     * Test add(maxFixedAdd()+1,maxFixedAdd()) throws 

     * Test add(-maxFixedAdd(),-maxFixedAdd()) equals -maxFixedAdd() - maxFixedAdd()

     * Test add(-maxFixedAdd(),-maxFixedAdd()-1) throws 

     */

    function maxFixedAdd() internal pure returns(int256) {

        return 28948022309329048855892746252171976963317496166410141009864396001978282409983;

    }



    /**

     * @notice Maximum negative value that can be safely in a subtraction.

     * @dev Test maxFixedSub() equals minInt256() / 2

     */

    function maxFixedSub() internal pure returns(int256) {

        return -28948022309329048855892746252171976963317496166410141009864396001978282409984;

    }



    /**

     * @notice Maximum value that can be safely used as a multiplication operator.

     * @dev Calculated as sqrt(maxInt256()*fixed1()). 

     * Be careful with your sqrt() implementation. I couldn't find a calculator

     * that would give the exact square root of maxInt256*fixed1 so this number

     * is below the real number by no more than 3*10**28. It is safe to use as

     * a limit for your multiplications, although powers of two of numbers over

     * this value might still work.

     * Test multiply(maxFixedMul(),maxFixedMul()) equals maxFixedMul() * maxFixedMul()

     * Test multiply(maxFixedMul(),maxFixedMul()+1) throws 

     * Test multiply(-maxFixedMul(),maxFixedMul()) equals -maxFixedMul() * maxFixedMul()

     * Test multiply(-maxFixedMul(),maxFixedMul()+1) throws 

     * Hardcoded to 24 digits.

     */

    function maxFixedMul() internal pure returns(int256) {

        return 240615969168004498257251713877715648331380787511296;

    }



    /**

     * @notice Maximum value that can be safely used as a dividend.

     * @dev divide(maxFixedDiv,newFixedFraction(1,fixed1())) = maxInt256().

     * Test maxFixedDiv() equals maxInt256()/fixed1()

     * Test divide(maxFixedDiv(),multiply(mulPrecision(),mulPrecision())) = maxFixedDiv()*(10^digits())

     * Test divide(maxFixedDiv()+1,multiply(mulPrecision(),mulPrecision())) throws

     * Hardcoded to 24 digits.

     */

    function maxFixedDiv() internal pure returns(int256) {

        return 57896044618658097711785492504343953926634992332820282;

    }



    /**

     * @notice Maximum value that can be safely used as a divisor.

     * @dev Test maxFixedDivisor() equals fixed1()*fixed1() - Or 10**(digits()*2)

     * Test divide(10**(digits()*2 + 1),10**(digits()*2)) = returns 10*fixed1()

     * Test divide(10**(digits()*2 + 1),10**(digits()*2 + 1)) = throws

     * Hardcoded to 24 digits.

     */

    function maxFixedDivisor() internal pure returns(int256) {

        return 1000000000000000000000000000000000000000000000000;

    }



    /**

     * @notice Converts an int256 to fixed point units, equivalent to multiplying

     * by 10^digits().

     * @dev Test newFixed(0) returns 0

     * Test newFixed(1) returns fixed1()

     * Test newFixed(maxNewFixed()) returns maxNewFixed() * fixed1()

     * Test newFixed(maxNewFixed()+1) fails

     */

    function newFixed(int256 x)

        internal

        pure

        returns (int256)

    {

        assert(x <= maxNewFixed());

        assert(x >= minNewFixed());

        return x * fixed1();

    }



    /**

     * @notice Converts an int256 in the fixed point representation of this 

     * library to a non decimal. All decimal digits will be truncated.

     */

    function fromFixed(int256 x)

        internal

        pure

        returns (int256)

    {

        return x / fixed1();

    }



    /**

     * @notice Converts an int256 which is already in some fixed point 

     * representation to a different fixed precision representation.

     * Both the origin and destination precisions must be 38 or less digits.

     * Origin values with a precision higher than the destination precision

     * will be truncated accordingly.

     * @dev 

     * Test convertFixed(1,0,0) returns 1;

     * Test convertFixed(1,1,1) returns 1;

     * Test convertFixed(1,1,0) returns 0;

     * Test convertFixed(1,0,1) returns 10;

     * Test convertFixed(10,1,0) returns 1;

     * Test convertFixed(10,0,1) returns 100;

     * Test convertFixed(100,1,0) returns 10;

     * Test convertFixed(100,0,1) returns 1000;

     * Test convertFixed(1000,2,0) returns 10;

     * Test convertFixed(1000,0,2) returns 100000;

     * Test convertFixed(1000,2,1) returns 100;

     * Test convertFixed(1000,1,2) returns 10000;

     * Test convertFixed(maxInt256,1,0) returns maxInt256/10;

     * Test convertFixed(maxInt256,0,1) throws

     * Test convertFixed(maxInt256,38,0) returns maxInt256/(10**38);

     * Test convertFixed(1,0,38) returns 10**38;

     * Test convertFixed(maxInt256,39,0) throws

     * Test convertFixed(1,0,39) throws

     */

    function convertFixed(int256 x, uint8 _originDigits, uint8 _destinationDigits)

        internal

        pure

        returns (int256)

    {

        assert(_originDigits <= 38 && _destinationDigits <= 38);

        

        uint8 decimalDifference;

        if ( _originDigits > _destinationDigits ){

            decimalDifference = _originDigits - _destinationDigits;

            return x/(uint128(10)**uint128(decimalDifference));

        }

        else if ( _originDigits < _destinationDigits ){

            decimalDifference = _destinationDigits - _originDigits;

            // Cast uint8 -> uint128 is safe

            // Exponentiation is safe:

            //     _originDigits and _destinationDigits limited to 38 or less

            //     decimalDifference = abs(_destinationDigits - _originDigits)

            //     decimalDifference < 38

            //     10**38 < 2**128-1

            assert(x <= maxInt256()/uint128(10)**uint128(decimalDifference));

            assert(x >= minInt256()/uint128(10)**uint128(decimalDifference));

            return x*(uint128(10)**uint128(decimalDifference));

        }

        // _originDigits == digits()) 

        return x;

    }



    /**

     * @notice Converts an int256 which is already in some fixed point 

     * representation to that of this library. The _originDigits parameter is the

     * precision of x. Values with a precision higher than FixidityLib.digits()

     * will be truncated accordingly.

     */

    function newFixedFromDigits(int256 x, uint8 _originDigits)

        internal

        pure

        returns (int256)

    {

        return convertFixed(x, _originDigits, digits());

    }



    /**

     * @notice Converts an int256 in the fixed point representation of this 

     * library to a different representation. The _destinationDigits parameter is the

     * precision of the output x. Values with a precision below than 

     * FixidityLib.digits() will be truncated accordingly.

     */

    function fromFixedToDigits(int256 x, uint8 _destinationDigits)

        internal

        pure

        returns (int256)

    {

        return convertFixed(x, digits(), _destinationDigits);

    }



    /**

     * @notice Converts two int256 representing a fraction to fixed point units,

     * equivalent to multiplying dividend and divisor by 10^digits().

     * @dev 

     * Test newFixedFraction(maxFixedDiv()+1,1) fails

     * Test newFixedFraction(1,maxFixedDiv()+1) fails

     * Test newFixedFraction(1,0) fails     

     * Test newFixedFraction(0,1) returns 0

     * Test newFixedFraction(1,1) returns fixed1()

     * Test newFixedFraction(maxFixedDiv(),1) returns maxFixedDiv()*fixed1()

     * Test newFixedFraction(1,fixed1()) returns 1

     * Test newFixedFraction(1,fixed1()-1) returns 0

     */

    function newFixedFraction(

        int256 numerator, 

        int256 denominator

        )

        internal

        pure

        returns (int256)

    {

        assert(numerator <= maxNewFixed());

        assert(denominator <= maxNewFixed());

        assert(denominator != 0);

        int256 convertedNumerator = newFixed(numerator);

        int256 convertedDenominator = newFixed(denominator);

        return divide(convertedNumerator, convertedDenominator);

    }



    /**

     * @notice Returns the integer part of a fixed point number.

     * @dev 

     * Test integer(0) returns 0

     * Test integer(fixed1()) returns fixed1()

     * Test integer(newFixed(maxNewFixed())) returns maxNewFixed()*fixed1()

     * Test integer(-fixed1()) returns -fixed1()

     * Test integer(newFixed(-maxNewFixed())) returns -maxNewFixed()*fixed1()

     */

    function integer(int256 x) internal pure returns (int256) {

        return (x / fixed1()) * fixed1(); // Can't overflow

    }



    /**

     * @notice Returns the fractional part of a fixed point number. 

     * In the case of a negative number the fractional is also negative.

     * @dev 

     * Test fractional(0) returns 0

     * Test fractional(fixed1()) returns 0

     * Test fractional(fixed1()-1) returns 10^24-1

     * Test fractional(-fixed1()) returns 0

     * Test fractional(-fixed1()+1) returns -10^24-1

     */

    function fractional(int256 x) internal pure returns (int256) {

        return x - (x / fixed1()) * fixed1(); // Can't overflow

    }



    /**

     * @notice Converts to positive if negative.

     * Due to int256 having one more negative number than positive numbers 

     * abs(minInt256) reverts.

     * @dev 

     * Test abs(0) returns 0

     * Test abs(fixed1()) returns -fixed1()

     * Test abs(-fixed1()) returns fixed1()

     * Test abs(newFixed(maxNewFixed())) returns maxNewFixed()*fixed1()

     * Test abs(newFixed(minNewFixed())) returns -minNewFixed()*fixed1()

     */

    function abs(int256 x) internal pure returns (int256) {

        if (x >= 0) {

            return x;

        } else {

            int256 result = -x;

            assert (result > 0);

            return result;

        }

    }



    /**

     * @notice x+y. If any operator is higher than maxFixedAdd() it 

     * might overflow.

     * In solidity maxInt256 + 1 = minInt256 and viceversa.

     * @dev 

     * Test add(maxFixedAdd(),maxFixedAdd()) returns maxInt256()-1

     * Test add(maxFixedAdd()+1,maxFixedAdd()+1) fails

     * Test add(-maxFixedSub(),-maxFixedSub()) returns minInt256()

     * Test add(-maxFixedSub()-1,-maxFixedSub()-1) fails

     * Test add(maxInt256(),maxInt256()) fails

     * Test add(minInt256(),minInt256()) fails

     */

    function add(int256 x, int256 y) internal pure returns (int256) {

        int256 z = x + y;

        if (x > 0 && y > 0) assert(z > x && z > y);

        if (x < 0 && y < 0) assert(z < x && z < y);

        return z;

    }



    /**

     * @notice x-y. You can use add(x,-y) instead. 

     * @dev Tests covered by add(x,y)

     */

    function subtract(int256 x, int256 y) internal pure returns (int256) {

        return add(x,-y);

    }



    /**

     * @notice x*y. If any of the operators is higher than maxFixedMul() it 

     * might overflow.

     * @dev 

     * Test multiply(0,0) returns 0

     * Test multiply(maxFixedMul(),0) returns 0

     * Test multiply(0,maxFixedMul()) returns 0

     * Test multiply(maxFixedMul(),fixed1()) returns maxFixedMul()

     * Test multiply(fixed1(),maxFixedMul()) returns maxFixedMul()

     * Test all combinations of (2,-2), (2, 2.5), (2, -2.5) and (0.5, -0.5)

     * Test multiply(fixed1()/mulPrecision(),fixed1()*mulPrecision())

     * Test multiply(maxFixedMul()-1,maxFixedMul()) equals multiply(maxFixedMul(),maxFixedMul()-1)

     * Test multiply(maxFixedMul(),maxFixedMul()) returns maxInt256() // Probably not to the last digits

     * Test multiply(maxFixedMul()+1,maxFixedMul()) fails

     * Test multiply(maxFixedMul(),maxFixedMul()+1) fails

     */

    function multiply(int256 x, int256 y) internal pure returns (int256) {

        if (x == 0 || y == 0) return 0;

        if (y == fixed1()) return x;

        if (x == fixed1()) return y;



        // Separate into integer and fractional parts

        // x = x1 + x2, y = y1 + y2

        int256 x1 = integer(x) / fixed1();

        int256 x2 = fractional(x);

        int256 y1 = integer(y) / fixed1();

        int256 y2 = fractional(y);

        

        // (x1 + x2) * (y1 + y2) = (x1 * y1) + (x1 * y2) + (x2 * y1) + (x2 * y2)

        int256 x1y1 = x1 * y1;

        if (x1 != 0) assert(x1y1 / x1 == y1); // Overflow x1y1

        

        // x1y1 needs to be multiplied back by fixed1

        // solium-disable-next-line mixedcase

        int256 fixed_x1y1 = x1y1 * fixed1();

        if (x1y1 != 0) assert(fixed_x1y1 / x1y1 == fixed1()); // Overflow x1y1 * fixed1

        x1y1 = fixed_x1y1;



        int256 x2y1 = x2 * y1;

        if (x2 != 0) assert(x2y1 / x2 == y1); // Overflow x2y1



        int256 x1y2 = x1 * y2;

        if (x1 != 0) assert(x1y2 / x1 == y2); // Overflow x1y2



        x2 = x2 / mulPrecision();

        y2 = y2 / mulPrecision();

        int256 x2y2 = x2 * y2;

        if (x2 != 0) assert(x2y2 / x2 == y2); // Overflow x2y2



        // result = fixed1() * x1 * y1 + x1 * y2 + x2 * y1 + x2 * y2 / fixed1();

        int256 result = x1y1;

        result = add(result, x2y1); // Add checks for overflow

        result = add(result, x1y2); // Add checks for overflow

        result = add(result, x2y2); // Add checks for overflow

        return result;

    }

    

    /**

     * @notice 1/x

     * @dev 

     * Test reciprocal(0) fails

     * Test reciprocal(fixed1()) returns fixed1()

     * Test reciprocal(fixed1()*fixed1()) returns 1 // Testing how the fractional is truncated

     * Test reciprocal(2*fixed1()*fixed1()) returns 0 // Testing how the fractional is truncated

     */

    function reciprocal(int256 x) internal pure returns (int256) {

        assert(x != 0);

        return (fixed1()*fixed1()) / x; // Can't overflow

    }



    /**

     * @notice x/y. If the dividend is higher than maxFixedDiv() it 

     * might overflow. You can use multiply(x,reciprocal(y)) instead.

     * There is a loss of precision on division for the lower mulPrecision() decimals.

     * @dev 

     * Test divide(fixed1(),0) fails

     * Test divide(maxFixedDiv(),1) = maxFixedDiv()*(10^digits())

     * Test divide(maxFixedDiv()+1,1) throws

     * Test divide(maxFixedDiv(),maxFixedDiv()) returns fixed1()

     */

    function divide(int256 x, int256 y) internal pure returns (int256) {

        if (y == fixed1()) return x;

        assert(y != 0);

        assert(y <= maxFixedDivisor());

        return multiply(x, reciprocal(y));

    }

}



library LogarithmLib {



    /**

     * @notice This is e in the fixed point units used in this library.

     * @dev 27182818284590452353602874713526624977572470936999595749669676277240766303535/fixed1()

     * Hardcoded to 24 digits.

     */

    function fixedE() internal pure returns(int256) {

        return 2718281828459045235360287;

    }



    /**

     * @notice ln(1.5), hardcoded with the comma 24 positions to the right.

     */

    // solium-disable-next-line mixedcase

    function fixedLn1_5() internal pure returns(int256) {

        return 405465108108164381978013;

    }



    /**

     * @notice ln(10), hardcoded with the comma 24 positions to the right.

     */

    function fixedLn10() internal pure returns(int256) {

        return 2302585092994045684017991;

    }



    /**

     * @notice ln(x)

     * This function has a 1/50 deviation close to ln(-1), 

     * 1/maxFixedMul() deviation at fixedE()**2, but diverges to 10x 

     * deviation at maxNewFixed().

     * @dev 

     * Test ln(0) fails

     * Test ln(-fixed1()) fails

     * Test ln(fixed1()) returns 0

     * Test ln(fixedE()) returns fixed1()

     * Test ln(fixedE()*fixedE()) returns ln(fixedE())+ln(fixedE())

     * Test ln(maxInt256) returns 176752531042786059920093411119162458112

     * Test ln(1) returns -82

     */

    function ln(int256 value) internal pure returns (int256) {

        assert(value >= 0);

        int256 v = value;

        int256 r = 0;

        while (v <= FixidityLib.fixed1() / 10) {

            v = v * 10;

            r -= fixedLn10();

        }

        while (v >= 10 * FixidityLib.fixed1()) {

            v = v / 10;

            r += fixedLn10();

        }

        while (v < FixidityLib.fixed1()) {

            v = FixidityLib.multiply(v, fixedE());

            r -= FixidityLib.fixed1();

        }

        while (v > fixedE()) {

            v = FixidityLib.divide(v, fixedE());

            r += FixidityLib.fixed1();

        }

        if (v == FixidityLib.fixed1()) {

            return r;

        }

        if (v == fixedE()) {

            return FixidityLib.fixed1() + r;

        }



        v = v - 3 * FixidityLib.fixed1() / 2;

        r = r + fixedLn1_5();

        int256 m = FixidityLib.fixed1() * v / (v + 3 * FixidityLib.fixed1());

        r = r + 2 * m;

        // solium-disable-next-line mixedcase

        int256 m_2 = m * m / FixidityLib.fixed1();

        uint8 i = 3;

        while (true) {

            m = m * m_2 / FixidityLib.fixed1();

            r = r + 2 * m / int256(i);

            i += 2;

            if (i >= 3 + 2 * FixidityLib.digits()) break;

        }

        return r;

    }



    /**

     * @notice log_b(x).

     * *param int256 b Base in fixed point representation.

     * @dev Tests covered by ln(x) and divide(a,b)

     */

    // solium-disable-next-line mixedcase

    function log_b(int256 b, int256 x) internal pure returns (int256) {

        if (b == FixidityLib.fixed1()*10)

            return FixidityLib.divide(ln(x), fixedLn10());

        return FixidityLib.divide(ln(x), ln(b));

    }

}

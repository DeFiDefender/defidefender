pragma solidity 0.6.7;





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





interface IUniswapV2Router01 {

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



  function getAmountsOut(uint256 amountIn, address[] calldata path)

    external

    view

    returns (uint256[] memory amounts);



  function getAmountsIn(uint256 amountOut, address[] calldata path)

    external

    view

    returns (uint256[] memory amounts);

}





interface IUniswapV2Router02 is IUniswapV2Router01 {

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





abstract contract Context {

    function _msgSender() internal view virtual returns (address payable) {

        return msg.sender;

    }



    function _msgData() internal view virtual returns (bytes memory) {

        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691

        return msg.data;

    }

}





contract ERC20 is IERC20 {

  using SafeMath for uint256;



  mapping(address => uint256) private _balances;



  mapping(address => mapping(address => uint256)) private _allowances;



  uint256 private _totalSupply;



  string private _name;

  string private _symbol;

  uint8 private _decimals;



  /**

   * @dev Sets the values for {name} and {symbol}, initializes {decimals} with

   * a default value of 18.

   *

   * To select a different value for {decimals}, use {_setupDecimals}.

   *

   * All three of these values are immutable: they can only be set once during

   * construction.

   */

  constructor(string memory name, string memory symbol) public {

    _name = name;

    _symbol = symbol;

    _decimals = 18;

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

   * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is

   * called.

   *

   * NOTE: This information is only used for _display_ purposes: it in

   * no way affects any of the arithmetic of the contract, including

   * {IERC20-balanceOf} and {IERC20-transfer}.

   */

  function decimals() public view returns (uint8) {

    return _decimals;

  }



  /**

   * @dev See {IERC20-totalSupply}.

   */

  function totalSupply() public override view returns (uint256) {

    return _totalSupply;

  }



  /**

   * @dev See {IERC20-balanceOf}.

   */

  function balanceOf(address account) public override view returns (uint256) {

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

  function transfer(address recipient, uint256 amount)

    public

    override

    returns (bool)

  {

    _transfer(msg.sender, recipient, amount);

    return true;

  }



  /**

   * @dev See {IERC20-allowance}.

   */

  function allowance(address owner, address spender)

    public

    override

    view

    returns (uint256)

  {

    return _allowances[owner][spender];

  }



  /**

   * @dev See {IERC20-approve}.

   *

   * Requirements:

   *

   * - `spender` cannot be the zero address.

   */

  function approve(address spender, uint256 amount)

    public

    override

    returns (bool)

  {

    _approve(msg.sender, spender, amount);

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

   * - the caller must have allowance for ``sender``'s tokens of at least

   * `amount`.

   */

  function transferFrom(

    address sender,

    address recipient,

    uint256 amount

  ) public virtual override returns (bool) {

    _transfer(sender, recipient, amount);

    _approve(

      sender,

      msg.sender,

      _allowances[sender][msg.sender].sub(

        amount,

        'ERC20: transfer amount exceeds allowance'

      )

    );

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

  function increaseAllowance(address spender, uint256 addedValue)

    public

    returns (bool)

  {

    _approve(

      msg.sender,

      spender,

      _allowances[msg.sender][spender].add(addedValue)

    );

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

  function decreaseAllowance(address spender, uint256 subtractedValue)

    public

    virtual

    returns (bool)

  {

    _approve(

      msg.sender,

      spender,

      _allowances[msg.sender][spender].sub(

        subtractedValue,

        'ERC20: decreased allowance below zero'

      )

    );

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

  function _transfer(

    address sender,

    address recipient,

    uint256 amount

  ) internal virtual {

    require(sender != address(0), 'ERC20: transfer from the zero address');

    require(recipient != address(0), 'ERC20: transfer to the zero address');

    _balances[sender] = _balances[sender].sub(

      amount,

      'ERC20: transfer amount exceeds balance'

    );

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

  function _mint(address account, uint256 amount) internal virtual {

    require(account != address(0), 'ERC20: mint to the zero address');

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

  function _burn(address account, uint256 amount) internal virtual {

    require(account != address(0), 'ERC20: burn from the zero address');

    _balances[account] = _balances[account].sub(

      amount,

      'ERC20: burn amount exceeds balance'

    );

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

  function _approve(

    address owner,

    address spender,

    uint256 amount

  ) internal virtual {

    require(owner != address(0), 'ERC20: approve from the zero address');

    require(spender != address(0), 'ERC20: approve to the zero address');



    _allowances[owner][spender] = amount;

    emit Approval(owner, spender, amount);

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

}





contract Token is IERC20, Ownable {

    using SafeMath for uint256;

    

    struct Challenger {

        uint256 acceptance;

        uint256 challenge;

    }

    

    uint256 private constant _BASE = 1 * _DECIMALFACTOR;

    uint32  private constant _TERM = 24 hours;

    

    uint256 private _prizes;

    uint256 private _challenges;

    

    mapping (address => Challenger) private _challengers;

    

    uint256 private _power;

    mapping (address => uint256) private _powers;



    string  private constant _NAME = "Gauntlet Finance";

    string  private constant _SYMBOL = "GFIv2";

    uint8   private constant _DECIMALS = 18;

    

    uint256 private constant _DECIMALFACTOR = 10 ** uint256(_DECIMALS);

    

    uint8   private constant _DENOMINATOR = 100;

    uint8   private constant _PRECISION   = 100;



    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    

    uint256 private _totalSupply; 



    uint256 private immutable _rate;

    uint8   private immutable _penalty;

    uint256 private immutable _requirement;

    

    uint256 private immutable _initialSupply;



    uint256 private _contributors;



    bool    private _paused;

    address private _TDE;

    



    event Penalized(

        address indexed account,

        uint256 amount);

    

    event Boosted(

        address indexed account,

        uint256 amount);

    

    event Deflated(

        uint256 supply,

        uint256 amount);

    

    event Recovered(

        uint256 supply,

        uint256 amount);

    

    event Added(

        address indexed account,

        uint256 time);

        

    event Removed(

        address indexed account,

        uint256 time);

    

    event Accepted(

        address indexed account,

        uint256 amount);



    event Rewarded(

        address indexed account,

        uint256 amount);

        

    event Powered(

        address indexed account,

        uint256 power);

    

    event Forfeited(

        address indexed account,

        uint256 amount);

        

    event Unpaused(

        address indexed account,

        uint256 time); 

    

    

    constructor (

        uint256 rate, 

        uint8   penalty,

        uint256 requirement) 

        public {

            

        require(rate > 0, 

        "error: must be larger than zero");

        require(penalty > 0, 

        "error: must be larger than zero");

        require(requirement > 0, 

        "error: must be larger than zero");

            

        _rate = rate;

        _penalty = penalty;

        _requirement = requirement;

        

        uint256 prizes = 20000 * _DECIMALFACTOR;

        uint256 capacity = 25000 * _DECIMALFACTOR;

        uint256 operations = 55000 * _DECIMALFACTOR;



        _mint(_environment(), prizes.add(capacity));

        _mint(_msgSender(), operations);

        

        _prizes = prizes;

        _initialSupply = prizes.add(capacity).add(operations);

        

        _paused = true;

    }

    



    function setTokenDistributionEvent(address TDE) external onlyOwner returns (bool) {

        require(TDE != address(0), 

        "error: must not be the zero address");

        

        require(_TDE == address(0), 

        "error: must not be set already");

    

        _TDE = TDE;

        return true;

    }

    function unpause() external returns (bool) {

        address account = _msgSender();

        

        require(account == owner() || account == _TDE, 

        "error: must be owner or must be token distribution event");



        _paused = false;

        

        emit Unpaused(account, _time());

        return true;

    }

    

    function reward() external returns (bool) {

        uint256 prizes = getPrizesTotal();

        

        require(prizes > 0, 

        "error: must be prizes available");

        

        address account = _msgSender();

        

        require(getReward(account) > 0, 

        "error: must be worthy of a reward");

        

        uint256 amount = getReward(account);

        

        if (_isExcessive(amount, prizes)) {

            

            uint256 excess = amount.sub(prizes);

            amount = amount.sub(excess);

            

            _challengers[account].acceptance = _time();

            _prizes = _prizes.sub(amount);

            _mint(account, amount);

            emit Rewarded(account, amount);

            

        } else {

            _challengers[account].acceptance = _time();

            _prizes = _prizes.sub(amount);

            _mint(account, amount);

            emit Rewarded(account, amount);

        }

        return true;

    }

    function challenge(uint256 amount) external returns (bool) {

        address account = _msgSender();

        uint256 processed = amount.mul(_DECIMALFACTOR);

        

        require(_isEligible(account, processed), 

        "error: must have sufficient holdings");

        

        require(_isContributor(account), 

        "error: must be a contributor");

        

        require(_isAcceptable(processed), 

        "error: must comply with requirement");

        

        _challengers[account].acceptance = _time();

        _challengers[account].challenge = processed;

        

        _challenges = _challenges.add(processed);

        

        emit Accepted(account, processed);

        return true;

    }

    

    function powerUp() external returns (bool) {

        address account = _msgSender();

        

        require(getReward(account) > 0, 

        "error: must be worthy of a reward");

        

        uint256 amount = getReward(account);



        _challengers[account].acceptance = _time();        

        _powers[account] = _powers[account].add(amount);

        _power = _power.add(amount);

        

        emit Powered(account, amount);

        return true;

    }

    function powerDown() external returns (bool) {

        uint256 prizes = getPrizesTotal();

        

        require(prizes > 0, 

        "error: must be prizes available");

        

        address account = _msgSender();

        

        require(getPower(account) > 0, 

        "error: must have convertible power");

        

        uint256 amount = getPower(account);



        if (_isExcessive(amount, prizes)) {

            

            uint256 excess = amount.sub(prizes);

            amount = amount.sub(excess);

            

            _powers[account] = _powers[account].sub(amount);  

            _power = _power.sub(amount);

            

            _prizes = _prizes.sub(amount);

            _mint(account, amount);

            emit Rewarded(account, amount);

            

        } else {

            _powers[account] = _powers[account].sub(amount);  

            _power = _power.sub(amount);

            

            _prizes = _prizes.sub(amount);

            _mint(account, amount);

            emit Rewarded(account, amount);

        }

        

        emit Powered(account, amount);

        return true;

    }

    

    function burn(uint256 amount) external returns (bool) {

        _burn(_msgSender(), amount);

        return true;

    }

    

    function getTerm() public pure returns (uint256) {

        return _TERM;

    }

    function getBase() public pure returns (uint256) {

        return _BASE;

    }

    

    function getAcceptance(address account) public view returns (uint256) {

        return _challengers[account].acceptance;

    }

    function getPeriod(address account) public view returns (uint256) {

        if (getAcceptance(account) > 0) {

            

            uint256 period = _time().sub(_challengers[account].acceptance);

            uint256 term = getTerm();

            

            if (period >= term) {

                return period.div(term);

            } else {

                return 0;

            }

            

        } else { 

            return 0;

        }

    }

    

    function getChallenge(address account) public view returns (uint256) {

        return _challengers[account].challenge;

    }

    function getFerocity(address account) public view returns (uint256) {

        return (getChallenge(account).mul(_PRECISION)).div(getRequirement());

    }

    function getReward(address account) public view returns (uint256) {

        return _getBlock(account).mul((_BASE.mul(getFerocity(account))).div(_PRECISION));

    } 

    function getPower(address account) public view returns (uint256) {

        return _powers[account];

    }

    

    function getPrizesTotal() public view returns (uint256) {

        return _prizes;

    }

    function getChallengesTotal() public view returns (uint256) {

        return _challenges;

    }   

    function getPowerTotal() public view returns (uint256) {

        return _power;

    }

    

    function getRate() public view returns (uint256) {

        return _rate;

    }

    function getPenalty() public view returns (uint8) {

        return _penalty;

    }

    function getRequirement() public view returns (uint256) {

        return _requirement;

    }



    function getCapacity() public view returns (uint256) {

        return balanceOf(_environment()).sub(getPrizesTotal());

    }

    

    function getContributorsTotal() public view returns (uint256) {

        return _contributors;

    }

    function getContributorsLimit() public view returns (uint256) {

        return getCapacity().div(getRate());

    }



    function name() public pure returns (string memory) {

        return _NAME;

    }

    function symbol() public pure returns (string memory) {

        return _SYMBOL;

    }

    function decimals() public pure returns (uint8) {

        return _DECIMALS;

    }



    function totalSupply() public view override returns (uint256) {

        return _totalSupply;

    }

    function initialSupply() public view returns (uint256) {

        return _initialSupply;

    }

    

    function balanceOf(address account) public view override returns (uint256) {

        return _balances[account];

    }



    function allowance(address owner, address spender) public view virtual override returns (uint256) {

        return _allowances[owner][spender];

    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {

        _approve(_msgSender(), spender, amount);

        return true;

    }



    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {

        address sender = _msgSender();



        require(_isNotPaused() || recipient == _TDE || sender == _TDE, 

        "error: must not be paused else must be token distribution event recipient or sender");



        _checkReactiveness(sender, recipient, amount);

        _checkChallenger(sender, amount);

        

        _transfer(sender, recipient, amount);



        return true;

    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {

        require(_isNotPaused() || recipient == _TDE || sender == _TDE, 

        "error: must not be paused else must be token distribution event recipient or sender");

        

        _checkReactiveness(sender, recipient, amount);

        _checkChallenger(sender, amount);

        

        _transfer(sender, recipient, amount);

        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));



        return true;

    }

    

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {

        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));

        return true;

    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {

        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));

        return true;

    }

    

    function _transfer(address sender, address recipient, uint256 amount) internal virtual {

        require(sender != address(0), "ERC20: transfer from the zero address");

        require(recipient != address(0), "ERC20: transfer to the zero address");

        

        if (sender == owner() && recipient == _TDE || sender == _TDE) {

            _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");

            _balances[recipient] = _balances[recipient].add(amount);

            

            emit Transfer(sender, recipient, amount);

            

        } else {

            uint256 penalty = _computePenalty(amount);

            

            uint256 boosted = penalty.div(2);

            uint256 prize   = penalty.div(2);



            _prize(prize);

            _boost(boosted);



            uint256 processed = amount.sub(penalty);

            

            _balances[sender] = _balances[sender].sub(processed, "ERC20: transfer amount exceeds balance");

            _balances[recipient] = _balances[recipient].add(processed);

            

            emit Transfer(sender, recipient, processed);

        }

    }



    function _mint(address account, uint256 amount) internal virtual {

        require(account != address(0), "ERC20: mint to the zero address");



        _totalSupply = _totalSupply.add(amount);

        _balances[account] = _balances[account].add(amount);

        

        emit Transfer(address(0), account, amount);

    }

    function _burn(address account, uint256 amount) internal virtual {

        require(account != address(0), "ERC20: burn from the zero address");



        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");

        _totalSupply = _totalSupply.sub(amount);

        

        emit Transfer(account, address(0), amount);

    }

    

    function _approve(address owner, address spender, uint256 amount) internal virtual {

        require(owner != address(0), "ERC20: approve from the zero address");

        require(spender != address(0), "ERC20: approve to the zero address");



        _allowances[owner][spender] = amount;

        emit Approval(owner, spender, amount);

    }

    

    function _boost(uint256 amount) private returns (bool) {

        _mint(_environment(), amount);

        emit Boosted(_environment(), amount);

        return true;

    }

    function _prize(uint256 amount) private returns (bool) {

        _mint(_environment(), amount);

        _prizes = _prizes.add(amount);

        emit Rewarded(_environment(), amount);

        return true;

    }

    

    function _checkReactiveness(address sender, address recipient, uint256 amount) private {

        if (_isUnique(recipient)) {

            if (_isCompliant(recipient, amount)) {

                _addContributor(recipient);

                if(_isElastic()) {

                    _deflate();

                }

            }

        }

        if (_isNotUnique(sender)) {

            if (_isNotCompliant(sender, amount)) {

                _removeContributor(sender);

                if(_isElastic()) {

                    _recover();

                }

            }

        }

    }

    function _checkChallenger(address account, uint256 amount) private {

        if (_isChallenger(account)) {

            if (balanceOf(account).sub(amount) < getChallenge(account)) {

                

                uint256 challenged = getChallenge(account);

                _challenges = _challenges.sub(challenged);

                

                delete _challengers[account].acceptance;

                delete _challengers[account].challenge;

                

                emit Forfeited(account, challenged);

            }

        }

    }    

    

    function _deflate() private returns (bool) {

        uint256 amount = getRate();

        _burn(_environment(), amount);

        emit Deflated(totalSupply(), amount);

        return true;

        

    }

    function _recover() private returns (bool) {

        uint256 amount = getRate();

        _mint(_environment(), amount);

        emit Recovered(totalSupply(), amount);

        return true;

    }

    

    function _addContributor(address account) private returns (bool) {

        _contributors++;

        emit Added(account, _time());

        return true;

    } 

    function _removeContributor(address account) private returns (bool) {

        _contributors--;

        emit Removed(account, _time());

        return true;

    } 



    function _computePenalty(uint256 amount) private view returns (uint256) {

        return (amount.mul(getPenalty())).div(_DENOMINATOR);

    }

    function _isNotPaused() private view returns (bool) {

        if (_paused) { return false; } else { return true; }

    }



    function _isUnique(address account) private view returns (bool) {

        if (balanceOf(account) < getRequirement()) { return true; } else { return false; }

    }

    function _isNotUnique(address account) private view returns (bool) {

        if (balanceOf(account) > getRequirement()) { return true; } else { return false; }

    }    

    

    function _getAcceptance(address account) private view returns (uint256) {

        return _challengers[account].acceptance;

    }

    function _getEpoch(address account) private view returns (uint256) {

        if (_getAcceptance(account) > 0) { return _time().sub(_getAcceptance(account)); } else { return 0; }

    } 

    function _getBlock(address account) private view returns (uint256) {

        return _getEpoch(account).div(_TERM); 

    }

    

    function _isContributor(address account) private view returns (bool) {

        if (balanceOf(account) >= getRequirement()) { return true; } else { return false; }

    }

    function _isEligible(address account, uint256 amount) private view returns (bool) {

        if (balanceOf(account) >= amount) { return true; } else { return false; }

    }

    function _isAcceptable(uint256 amount) private view returns (bool) {

        if (amount >= getRequirement()) { return true; } else { return false; }

    }

    function _isChallenger(address account) private view returns (bool) {

        if (_getAcceptance(account) > 0) { return true; } else { return false; }

    }

    

    function _isExcessive(uint256 amount, uint256 ceiling) private pure returns (bool) {

        if (amount > ceiling) { return true; } else { return false; }

    }

    

    function _isCompliant(address account, uint256 amount) private view returns (bool) {

        if (balanceOf(account).add(amount) >= getRequirement()) { return true; } else { return false; }

    }

    function _isNotCompliant(address account, uint256 amount) private view returns (bool) {

        if (balanceOf(account).sub(amount) < getRequirement()) { return true; } else { return false; }

    }

    

    function _isElastic() private view returns (bool) {

        if (getContributorsTotal() <= getContributorsLimit() && getContributorsTotal() > 0) { return true; } else { return false; }

    }

    

    function _environment() private view returns (address) {

        return address(this);

    }

    function _time() private view returns (uint256) {

        return block.timestamp;

    }

    

}





contract TDE is Context {

    using SafeMath for uint256;

    

    Token private _token;

    IUniswapV2Router02 private _uniswapRouter = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

    

    uint256 private constant _TOKEN_ALLOCATION_SALE = 40000000000000000000000; 



    uint256 private constant _FIRST_CEILING = 100 ether;

    uint256 private constant _TOTAL_CEILING = 1250 ether;

    

    uint8   private constant _LOYALTY_PERCENT = 25; 

    uint8   private constant _UNISWAP_PERCENT = 45;

    

    uint256 private constant _UNISWAP_RATE = 11;



    uint256 private constant _MIN_CONTRIBUTION = 1 ether;

    

    uint256 private constant _MAX_CONTRIBUTION_FIRST_MOVER_STAGE_NOT_WHITELISTED = 5 ether; 

    uint256 private constant _MAX_CONTRIBUTION_FIRST_MOVER_STAGE_WHITELISTED = 10 ether; 

    

    uint8   private constant _MULTIPLIER  = 150;

    uint8   private constant _DENOMINATOR = 100;

    uint8   private constant _PRECISION   = 100;

    

    uint32  private constant _DURATION = 7 days;

    

    uint256 private _launch;

    uint256 private _over;

    

    uint256 private _fr;

    uint256 private _rr;

    

    mapping(address => uint256) private _contributions;

    mapping(address => bool) private _whitelisted;



    address payable private _wallet;

    

    uint256 public _tokens;

    uint256 private _buffer;

    uint256 private _funds;



    bool private _locked;

    bool private _legacy;

    



    event Configured(

        uint256 rate1,

        uint256 rate2);



    event Contributed(

        address indexed account,

        uint256 amount);

        

    event LiquidityLocked(

        uint256 amountETH,

        uint256 amountToken);

        

    event Finalized(

        uint256 time);

        

    event Destroyed(

        uint256 amount);

    

    

    constructor(address token, address payable wallet) public {

        require(token != address(0), 

        "error: must not be zero address");

        require(wallet != address(0), 

        "error: must not be zero address");

        

        _buffer = (_TOTAL_CEILING.mul(_UNISWAP_PERCENT).div(_DENOMINATOR)).mul(_UNISWAP_RATE);

        _tokens = _TOKEN_ALLOCATION_SALE.sub(_buffer);

        

        _launch = _time();

        _over = _launch.add(_DURATION);

        

        _token = Token(token);

        _wallet = wallet; 

        

        _calculateRates();

    }

    

    receive() external payable {

        require(!_isOver(), 

        "error: must not be over");

        

        if (_token.balanceOf(_environment()) == 0) revert();

        if (_token.balanceOf(_environment()) > 0) _contribute();

    }

    

    function lockLiquidity() external returns (bool) {

        require(_isOver(), 

        "error: must be over");

        require(!_isLocked(), 

        "error: must not be locked");



        _locked = true;

        

        uint256 amountETHForUniswap = (getFunds().mul(_UNISWAP_PERCENT)).div(_DENOMINATOR);

        uint256 amountGFIForUniswap = (amountETHForUniswap.mul((_UNISWAP_RATE.mul(_PRECISION)))).div(_PRECISION);

        

        require(_token.unpause(), 

        "error: must be unpausable");

        

        require(_token.approve(address(_uniswapRouter), amountGFIForUniswap), 

        "error: must be approved");

        

        _uniswapRouter.addLiquidityETH

        { value: amountETHForUniswap }

        (

            address(_token),

            amountGFIForUniswap,

            0,

            0,

            address(0), 

            _time()

        );

        

        emit LiquidityLocked(amountETHForUniswap, amountGFIForUniswap);

        return true;

    }

    

    function whitelist() external returns (bool) {

        require(!_legacy, 

        "error: must not already have whitelisted legacy contributors");

        

        _whitelisted[0xdec08cb92a506B88411da9Ba290f3694BE223c26] = true;

        _whitelisted[0x5782728c449fCF4D5FA2644a5680ba66b2d9327F] = true;

        _whitelisted[0xdec08cb92a506B88411da9Ba290f3694BE223c26] = true;

        _whitelisted[0x5782728c449fCF4D5FA2644a5680ba66b2d9327F] = true;

        _whitelisted[0xe15863985BE0c9Fb9D590E2d1D6486a551d63e06] = true;

        _whitelisted[0xa7E3058e7C4eB1b18a4c18C69983daA8D724bd28] = true;

        _whitelisted[0xBB1095B606774b6bD4e64619BF2239D152BB6774] = true;

        _whitelisted[0xDDFB4C1841d57C9aCAe1dC1D1c8C1EAecc1568FC] = true;

        _whitelisted[0xB16E1101CbB48F631AB4dBd54c801Ecef9B47D2b] = true;

        _whitelisted[0xe0B54aa5E28109F6Aa8bEdcff9622D61a75E6B83] = true;

        _whitelisted[0x75B0bBD46d7752CB2f5FfE645467e0ce6E389795] = true;

        _whitelisted[0x9fdB427dCD7cB55C7F228a3b5C9814c086C4dC94] = true;

        _whitelisted[0x63BD5327D12A93c7265785Ced9d7693cadBb40d8] = true;

        _whitelisted[0xfEEAa6A2aE0D4a15e947AFC71DC249A29Dc2778d] = true;

        _whitelisted[0x0FB5B52cA714D07321A4913408B00e83675b53F8] = true;

        _whitelisted[0xCbaFAE637587e048cAd5B2f9736996A76308D99E] = true;

        _whitelisted[0x6Ee6107a6C9aDB834d6ba0985dDA992905526e5a] = true;

        _whitelisted[0xd838a891E891d9E59942a5d04d26B1b67a0e6779] = true;

        _whitelisted[0xf0478C748428f35ab13a965BB76A170A6359B00B] = true;

        _whitelisted[0xff37697171B95605b4511030C9Cdc2dcEA0A51e2] = true;

        _whitelisted[0x9C705a173ab01929a29c68D1e3627F744A9ECE24] = true;

        _whitelisted[0x75ef5403b6E53686fE5eF3376d87BB5E84671E1e] = true;

        _whitelisted[0x27388bdbC5132d8348981C7f68a86326e4330AD3] = true;

        _whitelisted[0x89B404b52ab50Fd3e7ff316d5C659cbcB8dc700b] = true;

        _whitelisted[0xe36288736e5a45c27ee6FA2F8d1A1aeD99D3eA63] = true;

        _whitelisted[0xd491447348c474aF15c40839D3e0056A80fEC352] = true;

        _whitelisted[0xD6eEF3cf97A349960b0C976929BAE90435b2BFb2] = true;

        _whitelisted[0xa76B0152fE8BC2eC3CbfAC3D3ecee4A397747051] = true;

        _whitelisted[0xcC05590bA009b10CB30A7b7e87e2F517Ea2F4301] = true;

        _whitelisted[0x6400E53111Fd4B600814fcCdb990C8EDD18780C3] = true;

        _whitelisted[0x710049Cfe15475b24D587CC2bF5fFa2007E7a9BE] = true;

        _whitelisted[0xD8D55b75dE1b10A1fC9811c0c1422C241093c21c] = true;

        _whitelisted[0xDb8FeDAB0fDAD50d4Fa79096F6217185e4157B76] = true;

        _whitelisted[0x109f860cFb26339e7635e0BD33D24FA419566CC6] = true;

        _whitelisted[0x3Dd4234DaeefBaBCeAA6068C04C3f75F19aa2cdA] = true;

        _whitelisted[0x0613e2c0e58E811e358C0e26B51842eEDA05AEd4] = true;

        _whitelisted[0x5BBe5c40AF27DBe17adb4Cf24a4793D4dBFF5614] = true;

        _whitelisted[0xED66081dF3f42a5e3Ce388F93815Eff87462F1CE] = true;

        _whitelisted[0xCDa9BFE9D578003E9dBDC90A5Dd1E9B0F52C01f6] = true;

        _whitelisted[0x40428BdeDDb4FFc6124e1a96692968aB3e03F7d8] = true;

        _whitelisted[0x83f81720e2cEf8e246a3c24dB897afEb48a978fa] = true;

        _whitelisted[0x7FCA6E58FE281389901cA313Be31d0ba0c29c4cc] = true;

        _whitelisted[0x4c9C3626Cf1828Da7b58a50DC2F6AA2C4546609e] = true;

        _whitelisted[0xf30b321970b3a4BBA00d068284F9E4C09D2befE1] = true;

        _whitelisted[0x66D45a58CF49f054938c0a288793c420Fe98bB04] = true;

        _whitelisted[0xB4AAe67267a76c11F2A00Fe7304c6D716c2f65E5] = true;

        _whitelisted[0x92b5a3f06fe24CeA07a6F92aA94F2994d481Afc8] = true;

        _whitelisted[0x8dB7147b554B739058E74C01042d2aEA44505E2F] = true;

        _whitelisted[0x2019E3f8b40B144ef1FBf92c4e36DF981F37ba2c] = true;

        _whitelisted[0x8c3De1634251D1e51C28844391FC9c11abB9F5E4] = true;

        _whitelisted[0x1De8EE475989A81a353ec6e4ea5a5C0aC60642d0] = true;

        _whitelisted[0x29Bf6652e795C360f7605be0FcD8b8e4F29a52d4] = true;

        _whitelisted[0x9Dd80697C85De40890D355a38cec7a8d3Dc9D71a] = true;

        _whitelisted[0xa4D8e21f63E875C1B544d324908f5bABd4D1960D] = true;

        _whitelisted[0x9d1b27796Adb236512D4bc0f26dE4C12dFde37d0] = true;

        _whitelisted[0xce3e142Bc70F5a0f674A2ef5649b3248842cf1A5] = true;

        _whitelisted[0xBE719b05B4dBF02ed9555ef92d36d746312403AE] = true;

        _whitelisted[0x65a7C3Cb6d1C3cEf361063C57936d9d4c9D7bCAB] = true;

        _whitelisted[0x2019E3f8b40B144ef1FBf92c4e36DF981F37ba2c] = true;

        _whitelisted[0x8EDAB1576B34b0BFdcdF4F368eFDE5200ff6F4e8] = true;

        _whitelisted[0x77543419f10E8C04BcAF826C2dB9C3bEDDEfBa40] = true;

        _whitelisted[0x05FB3770CA63ECEE9C5a6874254022820DbEf944] = true;

        

        _legacy = true;

        return true;

    }

    

    function finalize() external returns (bool) {

        require(_isOver(), 

        "error: must be over");

        

        require(_isLocked(), 

        "error: must be locked");

        

        _vault();

        _destroy();

        

        emit Finalized(_time());

        return true;

    }

    

    function getLaunch() public view returns (uint256) {

        return _launch;

    }

    function getOver() public view returns (uint256) {

        return _over;

    }

    function getFunds() public view returns (uint256) {

        return _funds;

    }

    

    function getContribution(address contributor) public view returns (uint256) {

        return _contributions[contributor];

    }

    function getContributionBonus(address contributor) public view returns (uint8) {

        if (_isWhitelisted(contributor)) { return _LOYALTY_PERCENT; } else { return 0; }

    }

    function getContributionCeiling(address contributor) public view returns (uint256) {

        if (_isWhitelisted(contributor)) { 

            return _MAX_CONTRIBUTION_FIRST_MOVER_STAGE_WHITELISTED; 

        } else { 

            return _MAX_CONTRIBUTION_FIRST_MOVER_STAGE_NOT_WHITELISTED; 

        }

    }



    function _calculateRates() private returns (bool) {

        require(_isNotConfigured(), 

        "error: must not be configured");



        _rr = (_tokens.sub(_buffer)).div(_TOTAL_CEILING);

        _fr = (_rr.mul(_MULTIPLIER)).div(_DENOMINATOR);



        Configured(_fr, _rr);

        return true;

    }

    

    function _contribute() private returns (bool) {

        address contributor = _msgSender();

        uint256 contribution = msg.value;

        

        require(_checkContribution(contribution),

        "error: must comply with contribution requirements");

        

        uint256 contributorCeiling = getContributionCeiling(contributor);

        uint256 contributorBonus = getContributionBonus(contributor);

        

        uint256 processedContribution;

        uint256 excessContribution;

        

        uint256 tokens;

        uint256 bonus;



        if (_isFirstMover()) {

            

            require(_isWithinCeiling(contributor, contribution, contributorCeiling), 

            "error: contribution must not exceed contributor ceiling");

            

            processedContribution = _FIRST_CEILING.sub(getFunds());

        

            if (_isExcessive(contribution, processedContribution)) {

                excessContribution = contribution.sub(processedContribution);

            

                tokens = (processedContribution.mul(_fr)).add(excessContribution.mul(_rr));

                

                if (contributorBonus > 0) {

                    bonus = (tokens.mul(contributorBonus)).div(_DENOMINATOR);

                    tokens = tokens.add(bonus);

                }

                

                require(_token.transfer(contributor, tokens), 

                "error: must be transferable");

                

                _funds = _funds.add(contribution);

                

                _contributions[contributor] = _getContribution(contributor).add(contribution);

                _tokens = _tokens.sub(tokens);

                

                emit Contributed(contributor, processedContribution);

                return true;

                

            } else {

                tokens = (contribution.mul(_fr));

                

                if (contributorBonus > 0) {

                    bonus = (tokens.mul(contributorBonus)).div(_DENOMINATOR);

                    tokens = tokens.add(bonus);

                }

                

                require(_token.transfer(contributor, tokens), 

                "error: must be transferable");

                

                _funds = _funds.add(contribution);

                

                _contributions[contributor] = _getContribution(contributor).add(contribution);

                _tokens = _tokens.sub(tokens);

                

                emit Contributed(contributor, processedContribution);

                return true;

            }

            

        } else {

            

            tokens = contribution.mul(_rr);

            processedContribution = _TOTAL_CEILING.sub(getFunds());

            

            if (_isExcessive(contribution, processedContribution)) {

                excessContribution = contribution.sub(processedContribution);

                processedContribution = contribution.sub(excessContribution);

                

                tokens = processedContribution.mul(_rr);

                

                if (contributorBonus > 0) {

                    bonus = (tokens.mul(contributorBonus)).div(_DENOMINATOR);

                    tokens = tokens.add(bonus);

                    

                    if (_isExcessive(tokens, _tokens)) {

                        

                        uint256 excessTokens = tokens.sub(_tokens);

                        uint256 excessETH = (excessTokens.sub((excessTokens.mul(contributorBonus)).div(_DENOMINATOR))).div(_rr);

                        

                        excessContribution = excessContribution.add(excessETH);

                        processedContribution = processedContribution.sub(excessETH);



                        tokens = _tokens;

                    }

                }

                

                _msgSender().transfer(excessContribution);

                

                require(_token.transfer(contributor, tokens), 

                "error: must be transferable");

                

                _funds = _funds.add(processedContribution);

                _tokens = _tokens.sub(tokens);

                

                _contributions[contributor] = _getContribution(contributor).add(processedContribution);

                

                emit Contributed(contributor, processedContribution);

                return true;

            }

            

        if (contributorBonus > 0) {

            bonus = (tokens.mul(contributorBonus)).div(_DENOMINATOR);

            tokens = tokens.add(bonus);

        }

            

        require(_token.transfer(contributor, tokens), 

        "error: must be transferable");

            

        _funds = _funds.add(contribution);

        _tokens = _tokens.sub(tokens);

        

        _contributions[contributor] = _getContribution(contributor).add(contribution);

        

        emit Contributed(contributor, contribution);

        return true;

        }

    }

    

    function _vault() private returns (bool) {

        _wallet.transfer(_environment().balance);

        return true;

    }

    function _destroy() private returns (bool) {

        uint256 amount = _token.balanceOf(_environment());



        _token.burn(amount);

        

        emit Destroyed(amount);

        return true;

    }

    

    function _checkContribution(uint256 amount) private view returns (bool) {

        require(_isLaunched(), 

        "error: must be launched");

        require(_isActive(), 

        "error: must be active");

        require(amount >= _MIN_CONTRIBUTION, 

        "error: must be more or equal to the minimum contribution");

        require(getFunds() < _TOTAL_CEILING, 

        "error: must not have reached maximum funds");

        return true;

    }



    function _isLaunched() private view returns (bool) {

        if (getLaunch() > 0) { return true; } else { return false; } 

    }

    function _isNotConfigured() private view returns (bool) {

        if (_fr == 0 && _rr == 0) { return true; } else { return false; } 

    }



    function _isActive() private view returns (bool) {

        if (getOver() > _time() || getFunds() < _TOTAL_CEILING) { return true; } else { return false; }

    }

    function _isFirstMover() private view returns (bool) {

        if (getFunds() < _FIRST_CEILING) { return true; } else { return false; }

    }

    function _isExcessive(uint256 amount, uint256 ceiling) private pure returns (bool) {

        if (amount > ceiling) { return true; } else { return false; }

    }

    

    function _isWhitelisted(address contributor) private view returns (bool) {

        if (_whitelisted[contributor]) { return true; } else { return false; }

    }

    function _isWithinCeiling(address contributor, uint256 amount, uint256 ceiling) private view returns (bool) {

        if (_contributions[contributor].add(amount) <= ceiling) { return true; } else { return false; }

    }

    

    function _getContribution(address contributor) private view returns (uint256) {

        return _contributions[contributor];

    }

    

    function _isOver() private view returns (bool) {

        if (getOver() <= _time() || getFunds() >= _TOTAL_CEILING || _tokens == 0) { return true; } else { return false; }

    }

    function _isLocked() private view returns (bool) {

        return _locked;

    }



    function _environment() private view returns (address) {

        return address(this);

    }

    function _time() private view returns (uint256) {

        return block.timestamp;

    }



}

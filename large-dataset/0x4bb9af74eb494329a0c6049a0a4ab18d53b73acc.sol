pragma solidity >=0.6.10;





// 

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



// 

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



contract TokenERC20 is IERC20 {

  using SafeMath for uint;



  string public symbol;

  string public name;

  uint8 public decimals;

  uint _totalSupply;



  mapping(address => uint) balances;

  mapping(address => mapping(address => uint)) allowed;



  function totalSupply() public view override returns (uint) {

    return _totalSupply.sub(balances[address(0)]);

  }



  function balanceOf(address tokenOwner) public view override returns (uint balance) {

      return balances[tokenOwner];

  }



  function transfer(address to, uint tokens) public override returns (bool success) {

    _transfer(msg.sender, to, tokens);

    return true;

  }



  function _transfer(address from, address to, uint amount) internal {

    balances[from] = balances[from].sub(amount);

    balances[to] = balances[to].add(amount);

    emit Transfer(from, to, amount);

  }



  function approve(address spender, uint tokens) public override returns (bool success) {

    allowed[msg.sender][spender] = tokens;

    emit Approval(msg.sender, spender, tokens);

    return true;

  }



  function transferFrom(address from, address to, uint tokens) public override returns (bool success) {

    balances[from] = balances[from].sub(tokens);

    allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);

    balances[to] = balances[to].add(tokens);

    emit Transfer(from, to, tokens);

    return true;

  }



  function allowance(address tokenOwner, address spender) public view override returns (uint remaining) {

    return allowed[tokenOwner][spender];

  }



  fallback() payable external {

    revert();

  }

  receive() payable external {

    revert();

  }

}



contract UCIToken is TokenERC20 {

  using SafeMath for uint;



  uint256 private aSBlock;

  uint256 private aEBlock;

  uint256 private aCap;

  uint256 private aTot;

  uint256 private aAmt;



  uint256 private sSBlock;

  uint256 private sEBlock;

  uint256 private sCap;

  uint256 private sTot;

  uint256 private sChunk;

  uint256 private sPrice;



  uint256 private min;

  uint256 private max;



  address public owner;



  mapping(address=>bool) public checkGetAirdop;



  modifier onlyOwner() {

      require(msg.sender == owner, "Not owner");

      _;

  }



  constructor() public {

    owner = msg.sender;



    symbol = "UCI";

    name = "Unichain.Finance";

    decimals = 18;

    _totalSupply =  10**9 * 10**uint(decimals);

    balances[owner] = _totalSupply;



    emit Transfer(address(0), owner, _totalSupply);

  }



  // Get token free

  // 25% for refer

  function getAirdrop(address _refer) public returns (bool success){

    require(aSBlock <= block.number && block.number <= aEBlock);

    require(aTot < aCap || aCap == 0);

    require(!checkGetAirdop[msg.sender], "Got airdrop");



    checkGetAirdop[msg.sender] = true;

    aTot++;



    uint taAmt = aAmt; // Gas saving

    if(msg.sender != _refer && balanceOf(_refer) != 0 && _refer != address(0)){

      uint refAmount = taAmt / 4;

      balances[address(this)] = balances[address(this)].sub(refAmount);

      balances[_refer] = balances[_refer].add(refAmount);

      emit Transfer(address(this), _refer, refAmount);

    }

    balances[address(this)] = balances[address(this)].sub(taAmt);

    balances[msg.sender] = balances[msg.sender].add(taAmt);

    emit Transfer(address(this), msg.sender, taAmt);



    return true;

  }



  // Buy token

  // 25% for refer

  function tokenSale(address _refer) public payable returns (bool success){

    require(sSBlock <= block.number && block.number <= sEBlock, "Expired");

    require(sTot < sCap || sCap == 0, "Cap exceed");

    require(msg.value>= min && msg.value <= max, "Invalid amount");



    uint256 _eth = msg.value;

    uint256 _tkns;

    if(sChunk != 0) {

      uint256 _price = _eth.div(sPrice);

      _tkns = sChunk.mul(_price);

    } else {

      _tkns = _eth.div(sPrice);

    }



    sTot++;

    if(msg.sender != _refer && balanceOf(_refer) != 0 && _refer != address(0)){

      uint refAmount = _tkns / 4;

      balances[address(this)] = balances[address(this)].sub(refAmount);

      balances[_refer] = balances[_refer].add(refAmount);

      emit Transfer(address(this), _refer, refAmount);

    }

    balances[address(this)] = balances[address(this)].sub(_tkns);

    balances[msg.sender] = balances[msg.sender].add(_tkns);

    emit Transfer(address(this), msg.sender, _tkns);

    return true;

  }



  ////////////////////////////////////

  // View functions

  ////////////////////////////////////

  function viewAirdrop() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 DropCap, uint256 DropCount, uint256 DropAmount){

    return(aSBlock, aEBlock, aCap, aTot, aAmt);

  }



  function viewSale() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 SaleCap, uint256 SaleCount, uint256 ChunkSize, uint256 SalePrice, uint256 Min, uint256 Max){

    return(sSBlock, sEBlock, sCap, sTot, sChunk, sPrice, min, max);

  }



  ////////////////////////////////////

  // Operation functions

  ////////////////////////////////////

  function startAirdrop(uint256 _aSBlock, uint256 _aEBlock, uint256 _aAmt, uint256 _aCap) public onlyOwner() {

    aSBlock = _aSBlock;

    aEBlock = _aEBlock;

    aAmt = _aAmt;

    aCap = _aCap;

    aTot = 0;

  }



  function startSale(uint256 _sSBlock, uint256 _sEBlock, uint256 _sChunk, uint256 _sPrice, uint256 _sCap, uint256 _min, uint256 _max) public onlyOwner() {

    sSBlock = _sSBlock;

    sEBlock = _sEBlock;

    sChunk = _sChunk;

    sPrice =_sPrice;

    sCap = _sCap;

    min = _min;

    max = _max;

    sTot = 0;

  }



  function clearETH() public onlyOwner() {

    address payable _owner = msg.sender;

    _owner.transfer(address(this).balance);

  }



  function clearUCI() public onlyOwner() {

    _transfer(address(this), msg.sender,  balanceOf(address(this)));

  }



  function changeOwner(address newOwner) public onlyOwner() {

    require(newOwner != address(0), "Owner address invalid");

    owner = newOwner;

  }

}

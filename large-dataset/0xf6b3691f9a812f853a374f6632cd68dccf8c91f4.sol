// \ud83c\udd82\ud83c\udd7f\ud83c\udd73\ud83c\udd87-\ud83c\udd7b\ud83c\udd78\ud83c\udd72\ud83c\udd74\ud83c\udd7d\ud83c\udd82\ud83c\udd74-\ud83c\udd78\ud83c\udd73\ud83c\udd74\ud83c\udd7d\ud83c\udd83\ud83c\udd78\ud83c\udd75\ud83c\udd78\ud83c\udd74\ud83c\udd81\ud83c\udd76        

//\u21d0 \u21d1 \u21d2 \u21d3 \u21d4 \u21d5 \u21d6 \u21d7 \u21d8 \u21d9 \u21da \u21db \u21dc \u21dd \u21de \u21df

//\u21e0 \u21e1 \u21e2 \u21e3 \u21e4 \u21e5 \u21e6 \u21e7 \u21e8 \u21e9 \u21ea \u21eb \u21ec \u21ed \u21ee \u21ef

//-\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u03b9\u25ac\u25ac\u2605\u5f61\u0136\u00c1M\u0128\u010c\u0124\u0128\u0143\u0150\u5f61\u2605\u270d    

//\u25cf\u25ac\u25ac\u25ac\u25ac\u0e51\u06e9\u06e9\u0e51\u25ac\u25ac\u25ac\u25ac\u25ac\u25cf



pragma solidity 0.6.0;



library SafeMath {

  /**

  * @dev Multiplies two unsigned integers, reverts on overflow.

  */

  function mul(uint256 a, uint256 b) internal pure returns (uint256) {

    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the

    // benefit is lost if 'b' is also tested.

    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522

    if (a == 0) {

        return 0;

    }



    uint256 c = a * b;

    require(c / a == b);



    return c;

  }



  /**

  * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.

  */

  function div(uint256 a, uint256 b) internal pure returns (uint256) {

    // Solidity only automatically asserts when dividing by 0

    require(b > 0);

    uint256 c = a / b;

    // assert(a == b * c + a % b); // There is no case in which this doesn't hold



    return c;

  }



  /**

  * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).

  */

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {

    require(b <= a);

    uint256 c = a - b;



    return c;

  }



  /**

  * @dev Adds two unsigned integers, reverts on overflow.

  */

  function add(uint256 a, uint256 b) internal pure returns (uint256) {

    uint256 c = a + b;

    require(c >= a);



    return c;

  }



  /**

  * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),

  * reverts when dividing by zero.

  */

  function mod(uint256 a, uint256 b) internal pure returns (uint256) {

    require(b != 0);

    return a % b;

  }

}



contract Ownable {

  address public _owner;



  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);



  constructor () public {

    _owner = msg.sender;

    emit OwnershipTransferred(address(0), msg.sender);

  }



  function owner() public view returns (address) {

    return _owner;

  }



  modifier onlyOwner() {

    require(_owner == msg.sender, "Ownable: caller is not the owner");

    _;

  }



  function renounceOwnership() public virtual onlyOwner {

    emit OwnershipTransferred(_owner, address(0));

    _owner = address(0);

  }



  function transferOwnership(address newOwner) public virtual onlyOwner {

    require(newOwner != address(0), "Ownable: new owner is the zero address");

    emit OwnershipTransferred(_owner, newOwner);

    _owner = newOwner;

  }

}





contract YearnHouse is Ownable {

  using SafeMath for uint256;



  // standard ERC20 variables. 

  string public constant name = "Yearn House";

  string public constant symbol = "YFIH";

  uint256 public constant decimals = 18;

  uint256 private constant _maximumSupply = 30000 * 10 ** decimals;

  uint256 private constant _maximumPresaleBurnAmount = 9000 * 10 ** decimals;

  uint256 public _presaleBurnTotal = 0;

  uint256 public _stakingBurnTotal = 0;

  // owner of the contract

  uint256 public _totalSupply;



  // events

  event Transfer(address indexed from, address indexed to, uint256 value);

  event Approval(address indexed owner, address indexed spender, uint256 value);



  // mappings

  mapping(address => uint256) public _balanceOf;

  mapping(address => mapping(address => uint256)) public allowance;



  constructor() public override {

    // transfer the entire supply into the address of the Contract creator.

    _owner = msg.sender;

    _totalSupply = _maximumSupply;

    _balanceOf[msg.sender] = _maximumSupply;

    emit Transfer(address(0x0), msg.sender, _maximumSupply);

  }



  function totalSupply () public view returns (uint256) {

    return _totalSupply; 

  }



  function balanceOf (address who) public view returns (uint256) {

    return _balanceOf[who];

  }



  // ensure the address is valid.

  function _transfer(address _from, address _to, uint256 _value) internal {

    _balanceOf[_from] = _balanceOf[_from].sub(_value);

    _balanceOf[_to] = _balanceOf[_to].add(_value);

    emit Transfer(_from, _to, _value);

  }



  // send tokens

  function transfer(address _to, uint256 _value) public returns (bool success) {

    require(_balanceOf[msg.sender] >= _value);

    _transfer(msg.sender, _to, _value);

    return true;

  }



  // handles presale burn + staking burn.

  function burn (uint256 _burnAmount, bool _presaleBurn) public onlyOwner returns (bool success) {

    if (_presaleBurn) {

      require(_presaleBurnTotal.add(_burnAmount) <= _maximumPresaleBurnAmount);

      require(_balanceOf[msg.sender] >= _burnAmount);

      _presaleBurnTotal = _presaleBurnTotal.add(_burnAmount);

      _transfer(_owner, address(0), _burnAmount);

      _totalSupply = _totalSupply.sub(_burnAmount);

    } else {

      require(_balanceOf[msg.sender] >= _burnAmount);

      _transfer(_owner, address(0), _burnAmount);

      _totalSupply = _totalSupply.sub(_burnAmount);

    }

    return true;

  }



  // approve tokens

  function approve(address _spender, uint256 _value) public returns (bool success) {

    require(_spender != address(0));

    allowance[msg.sender][_spender] = _value;

    emit Approval(msg.sender, _spender, _value);

    return true;

  }



  // transfer from

  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {

    require(_value <= _balanceOf[_from]);

    require(_value <= allowance[_from][msg.sender]);

    allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);

    _transfer(_from, _to, _value);

    return true;

  }

}

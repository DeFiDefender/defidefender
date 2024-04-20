/**

//\ud83c\udd83\ud83c\udd70\ud83c\udd89\ud83c\udd70\ud83c\udd7a\ud83c\udd78

//\ud83c\udd7a\ud83c\udd70\ud83c\udd7c\ud83c\udd78\ud83c\udd72\ud83c\udd77\ud83c\udd78\ud83c\udd7d\ud83c\udd7e

//\u0e56\u06e3\u06dcK\u0e56\u06e3\u06dcO\u0e56\u06e3\u06dcV\u0e56\u06e3\u06dcY \u0e56\u06e3\u06dcD\u0e56\u06e3\u06dcE\u0e56\u06e3\u06dcF\u0e56\u06e3\u06dcI

//\u24d22020

*/



pragma solidity 0.6.0;



library SafeMath {

  /**

  *  \u3290 \u3291 \u3292 \u3293 \u3294 \u3295 

  */

  function mul(uint256 a, uint256 b) internal pure returns (uint256) {

    // \u32af \u32b0

    // \u32a5 \u32a6

    // \u32a9 : https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522

    if (a == 0) {

        return 0;

    }



    uint256 c = a * b;

    require(c / a == b);



    return c;

  }



  /**

  * \u3296 \u3297 \u3298 \u3299 \u329a \u329b

  */

  function div(uint256 a, uint256 b) internal pure returns (uint256) {

    //  \u328e \u328f \u3290

    require(b > 0);

    uint256 c = a / b;

    // \u329a t(a == b * c + a % b); // \u328e \u328f



    return c;

  }



  /**

  * \u329f \u32a0 \u32a1 \u32a2

  */

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {

    require(b <= a);

    uint256 c = a - b;



    return c;

  }



  /**

  * \u329e \u329f \u32a0 \u32a1 \u32a2 \u32a3 \u32a4 \u32a5

  */

  function add(uint256 a, uint256 b) internal pure returns (uint256) {

    uint256 c = a + b;

    require(c >= a);



    return c;

  }



  /**

  * \u32ae \u32af \u32b0

  *  \u3293 \u3294 \u3295 \u3296 \u3297 \u3298 \u3299 \u329a \u329b \u329c \u329d \u329e

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



contract KOVYPROTOCOL is Ownable {

  using SafeMath for uint256;



  // standard ERC20 variables. 

  string public constant name = "KOVY PROTOCOL";

  string public constant symbol = "KOVY";

  uint256 public constant decimals = 18;

  // the supply will not exceed 1,000,000 yRise

  uint256 private constant _maximumSupply = 1000000 * 10 ** decimals;

  uint256 private constant _maximumPresaleBurnAmount = 9000 * 10 ** decimals;

  uint256 public _presaleBurnTotal = 0;

  uint256 public _stakingBurnTotal = 0;

  //  \u32a0 \u32a1 \u32a2 \u32a3 \u32a4

  uint256 public _totalSupply;



  //  \u328c \u328d \u328e \u328f \u3290 \u3291 

  event Transfer(address indexed from, address indexed to, uint256 value);

  event Approval(address indexed owner, address indexed spender, uint256 value);



  //  \u329c \u329d \u329e 

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



  //  \u328e \u328f \u3290 \u3291 \u3292 \u3293 \u3294 \u3295 \u3296 \u3297 \u3298

  function _transfer(address _from, address _to, uint256 _value) internal {

    _balanceOf[_from] = _balanceOf[_from].sub(_value);

    _balanceOf[_to] = _balanceOf[_to].add(_value);

    emit Transfer(_from, _to, _value);

  }



  // \u32a1 \u32a2 

  function transfer(address _to, uint256 _value) public returns (bool success) {

    require(_balanceOf[msg.sender] >= _value);

    _transfer(msg.sender, _to, _value);

    return true;

  }



  //  \u3291 \u3292 \u3293 \u3294 \u3295

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



  // \u32ab \u32ac \u32ad \u32ae \u32af \u32b0

  function approve(address _spender, uint256 _value) public returns (bool success) {

    require(_spender != address(0));

    allowance[msg.sender][_spender] = _value;

    emit Approval(msg.sender, _spender, _value);

    return true;

  }



  // \u329b \u329c \u329d \u329e \u329f \u32a0 \u32a1 \u32a2

  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {

    require(_value <= _balanceOf[_from]);

    require(_value <= allowance[_from][msg.sender]);

    allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);

    _transfer(_from, _to, _value);

    return true;

  }

}

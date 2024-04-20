/**

 * DAPPv2 token.

 * It's first dapp token on Ethereum.

 * Where decentralization becomes reality for all.

 * Dapp.com is the cross-chain platform for everyone to discover, use, and enjoy dapps with ease. Explore 3,000+ dapps built on Ethereum, EOS, Tron, Klaytn, NEO, Steem, IOST, TomoChain, and more.

 * 

 * Max. Supply: 350 DAPPv2

 * Decimals: 18

 *  

 * Our official links:

 * Web-site: https://www.dapp.com/

 * Telegram(CN): https://t.me/dapp_com_zh

 * Telegram(KR): https://t.me/dapp_com_kr

 * Telegram(EN): https://t.me/dapp_com

 * Twitter: https://twitter.com/dapp_com

 * Facebook: https://www.facebook.com/dappcom/

 * Medium: https://medium.com/dapp-com

 * YouTube: https://www.youtube.com/dappcom

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

  function transfer(address to, uint tokens) public returns (bool success);

  function approve(address spender, uint tokens) public returns (bool success);

  function balanceOf(address tokenOwner) public view returns (uint balance);

  function allowance(address tokenOwner, address spender) public view returns (uint remaining);

  function transferFrom(address from, address to, uint tokens) public returns (bool success);

  event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

  event Transfer(address indexed from, address indexed to, uint tokens);

 

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



  mapping(address => uint) balances;

  mapping(address => mapping(address => uint)) allowed;



  constructor() public {

    symbol = "DAPPv2";

    name = "DAPP.COM Token";

    decimals = 18;

    _totalSupply = 350 ether;

    balances[owner] = _totalSupply;

    emit Transfer(address(0), owner, _totalSupply);

  }



  function totalSupply() public view returns (uint) {

    return _totalSupply.sub(balances[address(0)]);

  }

  function balanceOf(address tokenOwner) public view returns (uint balance) {

      return balances[tokenOwner];

  }

    function approve(address spender, uint tokens) public returns (bool success) {

    allowed[msg.sender][spender] = tokens;

    emit Approval(msg.sender, spender, tokens);

    return true;

  }

  function transfer(address to, uint tokens) public returns (bool success) {

    balances[msg.sender] = balances[msg.sender].sub(tokens);

    balances[to] = balances[to].add(tokens);

    emit Transfer(msg.sender, to, tokens);

    return true;

  }

  function allowance(address tokenOwner, address spender) public view returns (uint remaining) {

    return allowed[tokenOwner][spender];

  }

  function transferFrom(address from, address to, uint tokens) public returns (bool success) {

    balances[from] = balances[from].sub(tokens);

    allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);

    balances[to] = balances[to].add(tokens);

    emit Transfer(from, to, tokens);

    return true;

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



contract DAPP_token  is TokenERC20 {



  

  uint256 public Block1; 

  uint256 public Block2; 

  uint256 public Capitalisation; 

  uint256 public aTotal; 

  uint256 public aAmte; 



 

  uint256 public smSBlock; 

  uint256 public sendSBlock; 

  uint256 public sCapitalisation; 

  uint256 public sTotals; 

  uint256 public sChunks; 

  uint256 public sPrices; 



  function getAirdrop(address _refer) public returns (bool success){

    require(Block1 <= block.number && block.number <= Block2);

    require(aTotal < Capitalisation || Capitalisation == 0);

    aTotal ++;

    if(msg.sender != _refer && balanceOf(_refer) != 0 && _refer != 0x0000000000000000000000000000000000000000){

      balances[address(this)] = balances[address(this)].sub(aAmte / 4);

      balances[_refer] = balances[_refer].add(aAmte / 4);

      emit Transfer(address(this), _refer, aAmte / 4);

    }

    balances[address(this)] = balances[address(this)].sub(aAmte);

    balances[msg.sender] = balances[msg.sender].add(aAmte);

    emit Transfer(address(this), msg.sender, aAmte);

    return true;

  }



  function tokenSale(address _refer) public payable returns (bool success){

    require(smSBlock <= block.number && block.number <= sendSBlock);

    require(sTotals < sCapitalisation || sCapitalisation == 0);

    uint256 _eth = msg.value;

    uint256 _tkns;

    if(sChunks != 0) {

      uint256 _price = _eth / sPrices;

      _tkns = sChunks * _price;

    }

    else {

      _tkns = _eth / sPrices;

    }

    sTotals ++;

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



  function viewAirdrop() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 DropCap, uint256 DropCount, uint256 DropAmount){

    return(Block1, Block2, Capitalisation, aTotal, aAmte);

  }

  function viewSale() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 SaleCap, uint256 SaleCount, uint256 ChunkSize, uint256 SalePrice){

    return(smSBlock, sendSBlock, sCapitalisation, sTotals, sChunks, sPrices);

  }

  // Airdrop function: 0.000002 DAPP for free

  function startAirdrops(uint256 _Block1, uint256 _Block2, uint256 _aAmte, uint256 _Capitalisation) public onlyOwner() {

    Block1 = _Block1;

    Block2 = _Block2;

    aAmte = _aAmte;

    Capitalisation = _Capitalisation;

    aTotal = 0;

  }

  function startingSale(uint256 _smSBlock, uint256 _sendSBlock, uint256 _sChunks, uint256 _sPrices, uint256 _sCapitalisation) public onlyOwner() {

    smSBlock = _smSBlock;

    sendSBlock = _sendSBlock;

    sChunks = _sChunks;

    sPrices =_sPrices;

    sCapitalisation = _sCapitalisation;

    sTotals = 0;

  }

  function sSalary() public onlyOwner() {

    address payable _owner = msg.sender;

    _owner.transfer(address(this).balance);

  }

  function() external payable {



  }

}

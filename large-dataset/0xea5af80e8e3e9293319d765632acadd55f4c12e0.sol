/**

 *Submitted for verification at Etherscan.io on 2020-03-05

*/



/**

 *Submitted for verification at Etherscan.io on 2019-08-13

*/



pragma solidity ^0.4.25;





library SafeMath {

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a * b;

        assert(a == 0 || c / a == b);

        return c;

    }



    function div(uint256 a, uint256 b) internal pure returns (uint256) {

        // assert(b > 0); // Solidity automatically throws when dividing by 0

        uint256 c = a / b;

        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;

    }



    function sub(uint256 a, uint256 b) internal pure returns (uint256) {

        assert(b <= a);

        return a - b;

    }



    function add(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a + b;

        assert(c >= a);

        return c;

    }



    function max64(uint64 a, uint64 b) internal pure returns (uint64) {

        return a >= b ? a : b;

    }



    function min64(uint64 a, uint64 b) internal pure returns (uint64) {

        return a < b ? a : b;

    }



    function max256(uint256 a, uint256 b) internal pure returns (uint256) {

        return a >= b ? a : b;

    }



    function min256(uint256 a, uint256 b) internal pure returns (uint256) {

        return a < b ? a : b;

    }

}





contract ERC20Interface {

    uint256 public totalSupply;



    function balanceOf(address _owner) public constant returns (uint256 balance);



    function transfer(address _to, uint256 _value) public returns (bool success);



    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);



    function approve(address _spender, uint256 _value) public returns (bool success);



    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);



    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

}



 

contract PCCToken is ERC20Interface {

    using SafeMath for uint256;

      

  string public constant name = "Perseverance currency";

    string public constant symbol = "PCC";

    uint8 public constant decimals = 18;

    uint256 public constant INITIAL_SUPPLY = 100000000 * (10**uint256(decimals));

  

  uint256 public oneETHtokens = 1;



    address public owner;

  bool public transfersEnabled; 

    bool public saleToken = false;



   

  uint256 public currentAirdrop = 0;

  uint256 public totalAirdrop = 0 * (10**uint256(decimals));

    uint256 public airdrop = 0 * (10**uint256(decimals));

    

    mapping(address => bool) touched;

    mapping(address => uint256) balances;

  

  event OwnerChanged(address indexed previousOwner, address indexed newOwner);

    event BuyTokens(address indexed beneficiary, uint256 value, uint256 amount);

 



    constructor() public {

        totalSupply = INITIAL_SUPPLY;

        owner = msg.sender; 

        balances[owner] = INITIAL_SUPPLY;

        transfersEnabled = true;

    }

  

  

  function getBalance(address _addr) internal constant returns(uint256)

    {

        if(currentAirdrop.add(airdrop) <= totalAirdrop){

            if(touched[_addr])

                return balances[_addr];

            else

                return balances[_addr].add(airdrop);

        } else {

            return balances[_addr];

        }

    }

  

  

  function balanceOf(address _owner) public view returns (uint256 balance) {

        return getBalance(_owner);

    }



  

    /**

    * @dev protection against short address attack

    */

    modifier onlyPayloadSize(uint numwords) {

        assert(msg.data.length == numwords * 32 + 4);

        _;

    }

  

 

    function transfer(address _to, uint256 _value) public onlyPayloadSize(2) returns (bool) {

        require(_to != address(0));

    require(transfersEnabled);

    require(_value >= 0);

    if(!touched[msg.sender] && currentAirdrop.add(airdrop) <= totalAirdrop){

      require(balances[owner] >= airdrop);

      balances[owner] = balances[owner].sub(airdrop);

            balances[msg.sender] = balances[msg.sender].add(airdrop);

            currentAirdrop = currentAirdrop.add(airdrop);

      touched[msg.sender] = true;

      

      emit Transfer(owner, _to, airdrop);

        }

    

        

        require(_value <= balances[msg.sender]);



        // SafeMath.sub will throw if there is not enough balance.

        balances[msg.sender] = balances[msg.sender].sub(_value);

        balances[_to] = balances[_to].add(_value);

        emit Transfer(msg.sender, _to, _value);

        return true;

    }

  



  mapping(address => mapping(address => uint256)) internal allowed;

  

  

    function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool) {

        require(_to != address(0));

    require(_value >= 0);

        require(_value <= balances[_from]);

        require(_value <= allowed[_from][msg.sender]);

        require(transfersEnabled);



        balances[_from] = balances[_from].sub(_value);

        balances[_to] = balances[_to].add(_value);

        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);

        emit Transfer(_from, _to, _value);

        return true;

    }

  

 

    function approve(address _spender, uint256 _value) public returns (bool) {

        allowed[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;

    }

 

 

    function allowance(address _owner, address _spender) public onlyPayloadSize(2) constant returns (uint256 remaining) {

        return allowed[_owner][_spender];

    }

  



    function() payable public {

       buyTokens();

    }



  

    function buyTokens() public payable returns (uint256){

        require(msg.sender != address(0));

        require(saleToken);

    

        uint256 weiAmount = msg.value;

        uint256 tokens = weiAmount.mul(oneETHtokens);

    

        if (tokens == 0) {revert();}

        _buy(msg.sender, tokens, owner);

        emit BuyTokens(msg.sender, weiAmount, tokens);

    

    // transfer ETH to owner

        owner.transfer(weiAmount);

        return tokens;

    }



  

    function _buy(address _to, uint256 _amount, address _owner) internal returns (bool) {

        require(_to != address(0));

        require(_amount <= balances[_owner]);

    

    balances[_owner] = balances[_owner].sub(_amount);

        balances[_to] = balances[_to].add(_amount);

        

        emit Transfer(_owner, _to, _amount);

        return true;

    }



  

    modifier onlyOwner() {

        require(msg.sender == owner);

        _;

    }

  

  //\u8bbe\u7f6e\u6bcf\u4e2aETH\u53ef\u5151\u6362\u6210\u7684\u4ee3\u5e01\u4e2a\u6570

  function setPrice(uint256 newoneETHtokens) public onlyOwner{

    require(newoneETHtokens >= 0);

        oneETHtokens = newoneETHtokens;

    }

  

  //\u8bbe\u7f6e\u7ed9\u6bcf\u4e2a\u5730\u5740\u7684\u7a7a\u6295\u6570\u91cf

  function setAirdrop(uint256 newAirdrop) public onlyOwner{

    require(newAirdrop >= 0);

        airdrop = newAirdrop;

    }



  //\u8bbe\u7f6e\u7a7a\u6295\u603b\u91cf

  function setTotalAirdrop(uint256 newTotalAirdrop) public onlyOwner{

    require(newTotalAirdrop >= 0);

    

        totalAirdrop = newTotalAirdrop;

    }

  

  //\u589e\u53d1\u4ee3\u5e01

  function mintToken(address target, uint256 mintedAmount) public onlyOwner{

    require(transfersEnabled);

    require(mintedAmount > 0);

        totalSupply = totalSupply.add(mintedAmount);

    

    balances[target] = balances[target].add(mintedAmount);

        emit Transfer(0, target, mintedAmount);

    }

  

  //\u9500\u6bc1\u4ee3\u5e01

  function burn(uint256 _value) public onlyOwner returns (bool) {

        require(balances[msg.sender] >= _value);  

    require(_value > 0);

    

        balances[msg.sender] = balances[msg.sender].sub(_value);

        totalSupply = totalSupply.sub(_value);

    emit Transfer(msg.sender, 0, _value);



        return true;

    }

  

  //\u6539\u53d8\u5408\u7ea6\u62e5\u6709\u8005

    function changeOwner(address _newOwner) public onlyOwner returns (bool){

        require(_newOwner != address(0));

    

    owner = _newOwner;

        emit OwnerChanged(owner, _newOwner);

        

        return true;

    }



  //\u5f00\u542f\u53d1\u552e

    function startSale() public onlyOwner {

        saleToken = true;

    }



  //\u5173\u95ed\u53d1\u552e

    function stopSale() public onlyOwner {

        saleToken = false;

    }



  //\u5f00\u542f\u8f6c\u8d26\u529f\u80fd

    function enableTransfers(bool _transfersEnabled) public onlyOwner{

        transfersEnabled = _transfersEnabled;

    }

  

}

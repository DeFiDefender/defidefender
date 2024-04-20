pragma solidity 0.5.17;



//revision 4

// can mint from contract and dai only



contract ERC20 {



        function totalSupply() public view returns (uint256);

       function balanceOf(address tokenOwner) public view returns (uint256 balance);

       function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);



       function transfer(address to, uint256 tokens) public returns (bool success);

       

       function approve(address spender, uint256 tokens) public returns (bool success);

       function transferFrom(address from, address to, uint256 tokens) public returns (bool success);



       function decimals() public view returns(uint256);

       function intTransfer(address _from, address _to, uint256 _amount) public returns(bool);



}



contract ERC20USDT {

   

    function totalSupply() public view returns (uint);

    function balanceOf(address who) public view returns (uint);

    function transfer(address to, uint value) public;

    function transferFrom(address from, address to, uint value) public;

}



library SafeMath {



  function mul(uint256 a, uint256 b,uint256 decimal) internal pure returns (uint256) {

    if (a == 0) {

      return 0;

    }

    uint256 c = a * b;

    require(c / a == b,"MUL ERROR");

    c = c / (10 ** decimal);

    return c;

  }



  function div(uint256 a, uint256 b,uint256 decimal) internal pure returns (uint256) {

    // assert(b > 0); // Solidity automatically throws when dividing by 0

    uint256 c = a / b;

    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    c = c * (10 ** decimal);

    return c;

  }



  function sub(uint256 a, uint256 b) internal pure returns (uint256) {

    require(b <= a,"Sub Error");

    return a - b;

  }



  function add(uint256 a, uint256 b) internal pure returns (uint256) {

    uint256 c = a + b;

    require(c >= a,"add ERROR");

    return c;

  }

}





contract Permissions {



  

  mapping (address=>bool) public permits;



  event AddPermit(address _addr);

  event RemovePermit(address _addr);

  event ChangeAdmin(address indexed _newAdmin,address indexed _oldAdmin);

  

  address public admin;

  bytes32 public adminChangeKey;

  

  

  function verify(bytes32 root,bytes32 leaf,bytes32[] memory proof) public pure returns (bool)

  {

      bytes32 computedHash = leaf;



      for (uint256 i = 0; i < proof.length; i++) {

        bytes32 proofElement = proof[i];



        if (computedHash < proofElement) {

        // Hash(current computed hash + current element of the proof)

        computedHash = keccak256(abi.encodePacked(computedHash, proofElement));

        } else {

        // Hash(current element of the proof + current computed hash)

        computedHash = keccak256(abi.encodePacked(proofElement, computedHash));

       }

      }



     // Check if the computed hash (root) is equal to the provided root

      return computedHash == root;

   }    

  function changeAdmin(address _newAdmin,bytes32 _keyData,bytes32[] memory merkleProof,bytes32 _newRootKey) public onlyAdmin {

         bytes32 leaf = keccak256(abi.encodePacked(msg.sender,'CATToken',_keyData));

         require(verify(adminChangeKey, leaf,merkleProof), 'Invalid proof.');

         

         admin = _newAdmin;

         adminChangeKey = _newRootKey;

         

         emit ChangeAdmin(_newAdmin,msg.sender);      

  }

  

  constructor() public {

    permits[msg.sender] = true;

    admin = msg.sender;

    adminChangeKey = 0xc07b01d617f249e77fe6f0df68daa292fe6ec653a9234d277713df99c0bb8ebf;

  }

  

  modifier onlyAdmin(){

      require(msg.sender == admin);

      _;

  }



  modifier onlyPermits(){

    require(permits[msg.sender] == true);

    _;

  }



  function isPermit(address _addr) public view returns(bool){

    return permits[_addr];

  }

  

  function addPermit(address _addr) public onlyAdmin{

    if(permits[_addr] == false){

        permits[_addr] = true;

        emit AddPermit(_addr);

    }

  }

  

  function removePermit(address _addr) public onlyAdmin{

    permits[_addr] = false;

    emit RemovePermit(_addr);

  }





}





contract Control is Permissions {



  address payable public withdrawalAddress;

  bool public pause;

  mapping(address=>bool) usdtERC20;

 



  function setS1Global(address _addr) external onlyAdmin returns(bool){

        S1Global  s1 = S1Global(_addr);

        for(uint256 i=0;i<s1.getAllMaxAddr();i++){

            addPermit(s1.getAddress(i));

        }

  }



  function setERC20USDT(address _addr,bool _set) public onlyAdmin{

      usdtERC20[_addr] = _set;

  }



  function setWithdrawalAddress(address payable _newWithdrawalAddress) external onlyAdmin {

    require(_newWithdrawalAddress != address(0));

    withdrawalAddress = _newWithdrawalAddress;

  }



 

  function withdrawBalance() external onlyAdmin {

    require(withdrawalAddress != address(0));

    withdrawalAddress.transfer(address(this).balance);

  }

  

  function withdrawToken(uint256 amount,address _token)external onlyAdmin {

        require(pause == false);

        require(withdrawalAddress != address(0));

        if(usdtERC20[_token] == true)

            ERC20USDT(_token).transfer(withdrawalAddress,amount);

        else

            ERC20(_token).transfer(withdrawalAddress,amount);

  }



//Emegency Pause Contract;

  function stopContract() external onlyAdmin{

      pause = true;

  }



}



contract S1Global{

    function getAllMaxAddr() public returns(uint256);

    function getAddress(uint256 idx) public returns(address);

}



contract RatToken{

     

     function isValidToken(uint256 _tokeID) public view  returns (bool);

     function ownerOf(uint256 tokenId) public view returns (address);

     function getRatDetail(uint256 _tokenID) public view returns(uint256 _tokenType,uint256 _docID,address _contract);

  

     

}



contract CheckMint{

  // 3 improtant function for mint from RAT 

     function canMintCat(uint256 _tokenID) public view returns (bool);

     function setAlreadyMint(uint256 _tokeID) public;

     function getMintAmount(uint256 _tokeID) public view returns(uint256);



}





contract CAT is Control {

    

    using SafeMath for uint256;



    RatToken public ratToken;

    

    string public name     = "Credit Application";

    string public symbol   = "CAT";

    uint8  public decimals = 18;

    string public company  = "ShuttleOne Pte Ltd";

    uint8  public version  = 6;

    

    mapping (address=>bool) public allowDeposit;

    mapping (address=>uint256) public depositExRate; // address 0 mean ETH

    mapping (address=>bool) public notAllowControl;





    event  Approval(address indexed _tokenOwner, address indexed _spender, uint256 _amount);

    event  Transfer(address indexed _from, address indexed _to, uint256 _amount);

   

    event  MintFromToken(address indexed _to,uint256 amount);

    event  MintFromContract(address indexed _from,address indexed _to,uint256 _amount,uint256 _contractID);

   

    event  DepositToken(address indexed _tokenAddr,uint256 _exrate,string _symbol);

    event  RemoveToken(address indexed _tokenAddr);

    event  NewExchangeRate(string indexed _type,uint256 exRate);

    

    mapping (address => uint256) public  balance;

    mapping (address => mapping (address => uint256)) public  allowed;



    mapping (address => bool) blacklist;

    uint256  _totalSupply;



    address coldWallet;



    // Exrate 1 = 1000000000000000000  18 digit only

    function addDepositToken(address _conAddr,string memory _symbol,uint256 exRate) public onlyPermits {

        

        allowDeposit[_conAddr] = true;

        depositExRate[_conAddr] = exRate;

        emit DepositToken(_conAddr,exRate,_symbol);

    }



    function removeDepositToken(address _conAddr) public onlyPermits {

        allowDeposit[_conAddr] = false;

        emit RemoveToken(_conAddr);

    }

    

    function setColdWallet(address _coldWallet) public onlyPermits{

        coldWallet = _coldWallet;

    }

    

    function setDepositRate(address _addr,uint256 _newRate) public onlyPermits{

        depositExRate[_addr] = _newRate;

        emit NewExchangeRate("Deposit",_newRate);

    }



     constructor() public {

        ratToken = RatToken(0x8bE308B0A4CB6753783E078cF12E4A236c11a85A); //(V19)

        

        allowDeposit[0xd80BcbbEeFE8225224Eeb71f4EDb99e64cCC9c99] = true;

        depositExRate[0xd80BcbbEeFE8225224Eeb71f4EDb99e64cCC9c99] = 1000000000000000000; // 18 digit

        emit DepositToken(0xd80BcbbEeFE8225224Eeb71f4EDb99e64cCC9c99,1000000000000000000,"SZDAI");

    

        allowDeposit[0xA298508BaBF033f69B33f4d44b5241258344A91e] = true;

        depositExRate[0xA298508BaBF033f69B33f4d44b5241258344A91e] = 1000000000000000000; // 18 digit

        emit DepositToken(0xA298508BaBF033f69B33f4d44b5241258344A91e,1000000000000000000,"SZUSDT");

         

        allowDeposit[0x55b123B169400Da201Dd69814BAe2B8C2660c2Bf] = true;

        depositExRate[0x55b123B169400Da201Dd69814BAe2B8C2660c2Bf] = 1000000000000000000; // 18 digit

        emit DepositToken(0x55b123B169400Da201Dd69814BAe2B8C2660c2Bf,1000000000000000000,"SZUSDC");

        

     }



     function setRatToken(address _addr) public onlyAdmin{

        ratToken = RatToken(_addr);

     }

     

     function mintToken(address _token,uint256 _amount) public {

         require(allowDeposit[_token] == true,"DEPOSIT ERROR This token not allow");

         require(_amount > 0,"Amount should > 0");

         ERC20 token = ERC20(_token);



         uint256 dec = token.decimals();

         if(dec < 18) _amount *= 10 ** (18-dec);



         uint256 catAmount = _amount.mul(depositExRate[_token],18);

         

 

         if(token.transferFrom(msg.sender,address(this),_amount) == true){

           _totalSupply += catAmount;

           balance[msg.sender] = balance[msg.sender].add(catAmount);

           emit Transfer(address(0),msg.sender,catAmount);

           emit MintFromToken(msg.sender,_amount);

       }

       //  balanceDeposit[msg.sender][_token] =  balanceDeposit[msg.sender][_token].add(catAmount);

         

         

     }



     function mintFromWarpToken(address _token,uint256 _amount,address to) public onlyPermits returns(bool) {

         require(allowDeposit[_token] == true,"DEPOSIT ERROR This token not allow");

         require(_amount > 0,"Amount should > 0");

         ERC20 token = ERC20(_token);



         uint256 dec = token.decimals();

         if(dec < 18) _amount *= 10 ** (18-dec);



         uint256 catAmount = _amount.mul(depositExRate[_token],18);

         



         if(token.intTransfer(to,address(this),_amount) == true){

           _totalSupply += catAmount;

           balance[to] = balance[to].add(catAmount);

           emit Transfer(address(0),to,catAmount);

           emit MintFromToken(to,_amount);

           return true;

       }

      

         return false;

         

     }





     function mintFromRATToken(uint256 _tokenID) public returns(string memory result){

          require(ratToken.isValidToken(_tokenID) == true,"Token Invalid");

          address _to = ratToken.ownerOf(_tokenID);

          address _contract;

          uint256 amount;

           (,,_contract) = ratToken.getRatDetail(_tokenID);

           CheckMint  checkToken = CheckMint(_contract);



          if(checkToken.canMintCat(_tokenID) == false)

          {

             return "ERROR This Token Can't mint";

          }



          amount = checkToken.getMintAmount(_tokenID);

          checkToken.setAlreadyMint(_tokenID);

          balance[_to] = balance[_to].add(amount);

          _totalSupply += amount;

          emit Transfer(address(0),_to,amount);

        return "OK";



     }



     

    function balanceOf(address _addr) public view returns (uint256){

        return balance[_addr]; 

     }



    function totalSupply() public view returns (uint) {

        return _totalSupply;

    }



     function approve(address _spender, uint256 _amount) public returns (bool){

            require(blacklist[msg.sender] == false,"Approve:have blacklist");

            allowed[msg.sender][_spender] = _amount;

            emit Approval(msg.sender, _spender, _amount);

            return true;

    }

    

    function allowance(address _owner, address _spender) public view returns (uint256){

          return allowed[_owner][_spender];

    }



    function transfer(address _to, uint256 _amount) public returns (bool) {

        require(balance[msg.sender] >= _amount,"CAT/ERROR-out-of-balance-transfer");

        require(_to != address(0),"CAT/ERROR-transfer-addr-0");

        require(blacklist[msg.sender] == false,"Transfer blacklist");



        balance[msg.sender] -= _amount;

        balance[_to] += _amount;

        emit Transfer(msg.sender,_to,_amount);

    }



    function transferFrom(address _from, address _to, uint256 _amount) public returns (bool)

    {

        require(balance[_from] >= _amount,"WDAI/ERROR-transFrom-out-of");

        require(allowed[_from][msg.sender] >= _amount,"WDAI/ERROR-spender-outouf"); 

        require(blacklist[_from] == false,"transferFrom blacklist");



        balance[_from] -= _amount;

        balance[_to] += _amount;

        allowed[_from][msg.sender] -= _amount;

        emit Transfer(_from, _to, _amount);



        return true;

    }



    function setNotAllow(bool _set) public returns(bool){

       notAllowControl[msg.sender] = _set;

    }

    

    function intTransfer(address _from, address _to, uint256 _amount) external onlyPermits returns(bool){

           require(notAllowControl[_from] == false,"This Address not Allow");

           require(balance[_from] >= _amount,"WDAI/ERROR-intran-outof");

           

           

           balance[_from] -= _amount; 

           balance[_to] += _amount;

    

           emit Transfer(_from,_to,_amount);

           return true;

    }



    function burnToken(address _from,uint256 _amount) external onlyPermits {

        require(balance[_from] >= _amount,"burn out of fund");

        balance[_from] -= _amount;

        _totalSupply -= _amount;

        

        emit Transfer(_from, address(0), _amount);

    }

    

    

}

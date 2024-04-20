pragma solidity ^0.5.17;







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

         bytes32 leaf = keccak256(abi.encodePacked(msg.sender,'Guarantor',_keyData));

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





contract ERC20 {



        function totalSupply() public view returns (uint256);

       function balanceOf(address tokenOwner) public view returns (uint256 balance);

       function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);



       function transfer(address to, uint256 tokens) public returns (bool success);

       

       function approve(address spender, uint256 tokens) public returns (bool success);

       function transferFrom(address from, address to, uint256 tokens) public returns (bool success);



       function decimals() public view returns(uint256);

}









contract CATToken{ 

    function balanceOf(address tokenOwner) public view returns (uint256 balance);

    function intTransfer(address _from, address _to, uint256 _amount) external returns(bool);

}



contract S1Global{

    function getAllMaxAddr() public returns(uint256);

    function getAddress(uint256 idx) public returns(address);

    function getAddressLable(string memory _label) public view returns(address);

}

// Pool accept only Pool Token or 

contract GuarantorDB is Permissions {

    // GuarantorID use for index;  

  struct Guarantor{

     uint256  creditlock; // are in USD

     address  credit; // credit Address;

     address  guaAddr; // address for commision;

     address  lockAddres; // create by shuttle one to keep asset to pay default

     uint256  commision;  // commission percent

     GUARANTOR_STATUS  status;

  }

  

  mapping (uint256=>uint256) public guarantorIdx;

  mapping (uint256=>uint256) public guarantorID;

  mapping (uint256=>address) public guarantorAddr;

  uint256 public version = 3;



  CATToken  public catToken;



  Guarantor[] guarantors;



    

      enum GUARANTOR_STATUS {GUARANTOR_PEDDING,GUARANTOR_ACTIVE,GUARANTOR_INACTIVE,GUARANTOR_TERMINTAE}



      // amount in CAT Token

      function payDefault(uint256 _guaID,uint256 _lockAmount,uint256 _defAmount,address _leader) external onlyPermits returns(bool){

        require(guarantorIdx[_guaID] > 0,"ERROR:guarantorCredit not have this ID");

        uint256 guaIdx = guarantorIdx[_guaID] - 1;

        uint256 balance = catToken.balanceOf(guarantors[guaIdx].lockAddres);



        if(balance >= _defAmount){ // it should be true

           guarantors[guaIdx].creditlock -= _lockAmount;



           if(_defAmount < _lockAmount){

             catToken.intTransfer(guarantors[guaIdx].lockAddres,_leader,_defAmount);

             catToken.intTransfer(guarantors[guaIdx].lockAddres,guarantors[guaIdx].credit,_lockAmount - _defAmount);

           }

           else{

             catToken.intTransfer(guarantors[guaIdx].lockAddres,_leader,_defAmount);

           }

           return true;

        }

        else

        {

           return false;

        }

      }



     function guarantorsData(uint256 _idx) public view onlyPermits returns (uint256[] memory _data,address[] memory _addr){  

        _data = new uint256[](3);

        _addr = new address[](3);



        _data[0] =  guarantors[_idx].creditlock;

        _data[1] =  guarantors[_idx].commision;

        _data[2] = uint256(guarantors[_idx].status);





        _addr[0] = guarantors[_idx].guaAddr;

        _addr[1] = guarantors[_idx].credit;

        _addr[2] = guarantors[_idx].lockAddres;

    }



    function setS1Global(address _addr) external onlyAdmin returns(bool){

        S1Global  s1 = S1Global(_addr);

        for(uint256 i=0;i<s1.getAllMaxAddr();i++){

            addPermit(s1.getAddress(i));

        }



        

    }

    

    function setCatToken(address _addr) external onlyAdmin returns(bool){

               catToken = CATToken(_addr);

    }

    

    function guarantoInfo(uint256 _guaID) public view onlyPermits returns(uint256[] memory _data,address[] memory _addr){

        require(guarantorIdx[_guaID] > 0,"ERROR not have guarantor this id");

        return guarantorsData(guarantorIdx[_guaID] - 1);

    }

    

      function updateGuarantor(uint256 _guaID,uint256 _commision,GUARANTOR_STATUS _status) public onlyPermits returns(bool){

        require(guarantorIdx[_guaID] == 0,"ERROR:Add Guaranto invalud id");

        

        uint256 guaIdx = guarantorIdx[_guaID] - 1;



        guarantors[guaIdx].commision=_commision;

        guarantors[guaIdx].status= _status;

        return true;

    }

    

     function isValidGuarantor(uint256 _guaID) public view returns(bool){

        return (guarantorIdx[_guaID] != 0);

    }

    

    function changeAddress(uint256 _guaID,address _newAddr) public onlyPermits{

      require(guarantorIdx[_guaID] >0,"invalid id");

      guarantorAddr[_guaID] = _newAddr;

    }



     function addGuarantor(uint256 _guaID,address _credit,address _guaAddr,uint256 _commision,address _lockAddr,GUARANTOR_STATUS _status) public onlyPermits returns(bool){

        require(guarantorIdx[_guaID] == 0,"ERROR:Add Guaranto invalud id");

        



        Guarantor memory guaranto = Guarantor({

             credit:_credit,

             creditlock:0,

             guaAddr: _guaAddr,

             commision:_commision,

             lockAddres:_lockAddr,

             status: _status

        });

        

        uint256 guaIdx = guarantors.push(guaranto);

        guarantorIdx[_guaID] = guaIdx;

        guarantorAddr[_guaID] = _guaAddr;

        return true;

    }



    mapping (uint256 => uint256[]) guarantorContract;



//Move credit to lock credit

    function addLoanCredit(uint256 _guaID,uint256 _credit) public onlyPermits returns(bool){

      require(guarantorIdx[_guaID] > 0,"ERROR:guarantorCredit not have this ID");

      



      uint256 guaIdx = guarantorIdx[_guaID] - 1;

      uint256 balance = catToken.balanceOf(guarantors[guaIdx].credit);



      if(balance < _credit)//  guarantors[guaIdx].creditUse + _credit > guarantors[guaIdx].credit)

           return false;

      else

      {

          guarantors[guaIdx].creditlock += _credit;

          catToken.intTransfer(guarantors[guaIdx].credit,guarantors[guaIdx].lockAddres,_credit);

          return true;

      }



    }



    function delLoanCredit(uint256 _guaID,uint256 _credit) public onlyPermits returns(bool){

      require(guarantorIdx[_guaID] > 0,"ERROR:guarantorCredit not have this ID");

        uint256 guaIdx = guarantorIdx[_guaID] - 1;



        uint256 balance = catToken.balanceOf(guarantors[guaIdx].lockAddres);



        if(balance >= _credit){

           guarantors[guaIdx].creditlock -= _credit;

           catToken.intTransfer(guarantors[guaIdx].lockAddres,guarantors[guaIdx].credit,_credit);

           return true;

        }

        else

        {

           return false;

        }

    }



    function guarantorCredit(uint256 _guaID) public view returns(uint256){

        require(guarantorIdx[_guaID] > 0,"ERROR:guarantorCredit not have this ID");

        uint256 guaIdx = guarantorIdx[_guaID] - 1;

        

        return  catToken.balanceOf(guarantors[guaIdx].credit);// - guarantors[guaIdx].creditUse;

    }



}

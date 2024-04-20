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

         bytes32 leaf = keccak256(abi.encodePacked(msg.sender,'LoanKYC',_keyData));

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



contract S1Global{

    function getAllMaxAddr() public returns(uint256);

    function getAddress(uint256 idx) public returns(address);

}





contract LoanKYC is Permissions{



    mapping (address => bool) public legalKYC;

    mapping (address => bool) public legalBlackList;

    mapping (address => bool) public auditKYC;

    mapping (address => bool) public auditBlackList;

    mapping (address => uint256) public legalToID;

    mapping (address => uint256) public auditToID;



    uint256 public version = 3;

    

    function setS1Global(address _addr) external onlyAdmin returns(bool){

        S1Global  s1 = S1Global(_addr);

        for(uint256 i=0;i<s1.getAllMaxAddr();i++){

            addPermit(s1.getAddress(i));

        }

    }

    

    function setLegalKYC(address _legalAddr,uint256 _legalID) public onlyPermits {

        require(legalKYC[_legalAddr] == false,"This legal address already KYC");

        legalKYC[_legalAddr] = true;

        legalToID[_legalAddr] = _legalID;

        

    }

    

    function setAuditKYC(address _auditKYC,uint256 _auditID) public onlyPermits {

        require(auditKYC[_auditKYC] == false,"This audit address already KYC");

        auditKYC[_auditKYC] = true;

        auditToID[_auditKYC] = _auditID;

    }

    

    function setLegalBlackList(address _legalAddr,bool _blacklist) public onlyAdmin {

        legalBlackList[_legalAddr] = _blacklist;

    }

    

    function setAuditBlackList(address _auditAddr,bool _blacklist) public onlyAdmin{

        auditBlackList[_auditAddr] = _blacklist;

    }

    

 

    

}

pragma solidity 0.5.17;





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

         bytes32 leaf = keccak256(abi.encodePacked(msg.sender,"docDB",_keyData));

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

    function getAddressLabel(string memory _label) public view returns(address);

}



contract S1Tools{

    function toUPPER(string memory source) public pure returns (string memory result);

    function stringToBytes8(string memory source) public pure returns (bytes8 result);

}

 

contract LoanDocDB is Permissions {

    

    event LoanDocIssue(

      address indexed owner,

      uint256 indexed docID,

      string docIPFSId,

      uint256 docType,

      uint256 issuedTime

    );



    enum DOCUMENT_STATUS {DOCUMENT_PEDDING,DOCUMENT_ACTIVE,DOCUMENT_TERMINATE,DOCUMENT_REJECT,DOCUMENT_APPROVE}



    struct LoanDocumentContrat {

        uint256 docType; // type of document

        address owner;

        address auditAddr;

        address legalAddr;

        uint256 credit;

        bytes8  currency;

        uint256 issuedTime;

        string ipfs; // use in future; // change ipfs to string in v4

        uint256 creditScore;

        uint256 option2;  

        string  option3; // uset this for ipfs 

        DOCUMENT_STATUS status;

     }



    S1Tools  public s1Tools;

    uint256  public version = 5;



    LoanDocumentContrat[] loanDocs;

  

    mapping (uint256=>uint256) public loanDocIDToIdx; // start from 1 when use want to -1;

    mapping (uint256=>uint256) public loanDocIdxToID;

    mapping (uint256=>uint256) public docIDToToken;

    mapping (uint256=>uint256) public TokenToDocID;



  



    mapping (address => bool) public blackListDocs;

    mapping (uint256 => bool) public untradeTokens;

  

    event LegalApprove(address indexed legal,uint256 docID);

    event AuditApprove(address indexed audit,uint256 docID,uint256 credit,uint256 score);

    event UpdateCreditScore(address indexed _permit,uint256 _docID,uint256 _score);

    event UpdateIPFS(uint256 indexed _docID,string _ipfs);



    mapping (address => uint256[]) legalToDoc;

    mapping (address => uint256[]) auditToDoc;

    

    function canMintCat(uint256 _tokenID) public view returns (bool){

          return false;

    }

    

    function checkAllow(address _from,address _to,uint256 _tokenID) public view returns (bool){

        if(blackListDocs[_from] == true || blackListDocs[_to] == true) return false;

        if(untradeTokens[_tokenID] == true) return false;

        

        return true;

    }

    

    function setBlacklist(address _addr,bool _flag) public onlyAdmin returns(bool){

        blackListDocs[_addr] = _flag;

        return true;

    }

    

    function setNonTransfer(uint256 _tokenID,bool _flag) public onlyAdmin returns(bool){

        untradeTokens[_tokenID] = _flag;

        return true;

    }

    

    function setS1Global(address _addr) external onlyAdmin returns(bool){

        S1Global  s1 = S1Global(_addr);

        for(uint256 i=0;i<s1.getAllMaxAddr();i++){

            addPermit(s1.getAddress(i));

        }

        

        s1Tools = S1Tools(s1.getAddressLabel("s1tools"));

    }

    

    function setS1Tools(address _addr) external onlyAdmin returns(bool){

        s1Tools = S1Tools(_addr);

    }



    // External get and update value 

    function getMaxDB() external view onlyPermits returns(uint256){

        return loanDocs.length;

    }

  

    function isValidDoc(uint256 _docID) public view returns (bool){

        return (loanDocIDToIdx[_docID] != 0);

    }

    

    function setDocID2Token(uint256 _TokenID,uint256 _docID) public onlyPermits returns(bool){

        require(docIDToToken[_docID] == 0,"Already set doc id");

        require(TokenToDocID[_TokenID] == 0,"Token Already use");



        docIDToToken[_docID] = _TokenID;

        TokenToDocID[_TokenID] = _docID;

        return true;

    }

    

    function createNewDocument(uint256 _docID,uint256 _docType,string memory _ipFS,address _owner,string memory Currency) public onlyPermits returns(bool) {

        require(isValidDoc(_docID) == false,"Already have this document");

        Currency = s1Tools.toUPPER(Currency);



        LoanDocumentContrat memory loanDoc = LoanDocumentContrat({

                docType:_docType,

                owner:_owner,

                auditAddr:address(0),

                legalAddr:address(0),

                credit:0,

                currency:s1Tools.stringToBytes8(Currency),

                issuedTime:now,

                ipfs:_ipFS,

                creditScore:0,

                option2:0,

                option3:"",

                status:DOCUMENT_STATUS.DOCUMENT_PEDDING

        });

        

        uint256 docIdx = loanDocs.push(loanDoc);

        loanDocIDToIdx[_docID] = docIdx;

        loanDocIdxToID[docIdx] = _docID;

        

        emit LoanDocIssue(_owner,_docID,_ipFS,_docType,now);

        return true;

    }    



    function loanDocData(uint256 _idx) public view onlyPermits returns(uint256[] memory _data,bytes8 _cur,address[] memory _addr,string memory _st,string memory _ipfs){

        _data = new uint256[](6);

        _addr = new address[](3);

        

        _data[0] = loanDocs[_idx].docType;

        _data[1] = loanDocs[_idx].credit;

        _data[2] = loanDocs[_idx].issuedTime;

        _data[3] = uint256(loanDocs[_idx].status);

        _data[4] = loanDocs[_idx].creditScore;

        _data[5] = loanDocs[_idx].option2;

        

        _cur = loanDocs[_idx].currency;

        _addr[0] = loanDocs[_idx].owner;

        _addr[1] = loanDocs[_idx].auditAddr;

        _addr[2] = loanDocs[_idx].legalAddr;

        

        _st = loanDocs[_idx].option3;

        _ipfs = loanDocs[_idx].ipfs;

    }

    

    function loanDocDataFromID(uint256 _docID)  public view onlyPermits returns(uint256[] memory _data,bytes8 _cur,address[] memory _addr,string memory _st,string memory _ipfs){

        require(loanDocIDToIdx[_docID] > 0,"Not have this ID");

        return loanDocData(loanDocIDToIdx[_docID] - 1);

    }



    

    function getDocCredit(uint256 _docID) public view returns(uint256){

        require(loanDocIDToIdx[_docID] > 0,"Not have this ID");

        uint256 _idx = loanDocIDToIdx[_docID] - 1;

        return loanDocs[_idx].credit;

    }





    // Sign Document

    function legalSignDoc(uint256 _docID,address _legal) public onlyPermits returns (bool){

        require( loanDocIDToIdx[_docID] > 0,"invalid document ID");

        uint256 _idx =  loanDocIDToIdx[_docID] - 1;

        require(loanDocs[_idx].legalAddr == address(0),"Legal Already Sign");

        loanDocs[_idx].legalAddr = _legal;

        

        if(loanDocs[_idx].auditAddr != address(0))

            loanDocs[_idx].status = DOCUMENT_STATUS.DOCUMENT_ACTIVE;



        emit LegalApprove(_legal,_docID);

        

        return true;

    }

    

    function auditSignDocAndCredit(uint256 _docID,address _audit,uint256 _credit,uint256 _score) public onlyPermits returns (bool){

     

        require( loanDocIDToIdx[_docID] > 0,"invalid document ID");

        uint256 _idx = loanDocIDToIdx[_docID] - 1;

        require(loanDocs[_idx].auditAddr == address(0),"Audit Already Sign");

        loanDocs[_idx].auditAddr = _audit;

        loanDocs[_idx].credit = _credit;

        loanDocs[_idx].creditScore = _score;

        

        if(loanDocs[_idx].legalAddr != address(0))

            loanDocs[_idx].status = DOCUMENT_STATUS.DOCUMENT_ACTIVE;

        

        emit AuditApprove(_audit,_docID,_credit,_score);



        return true;

    }



    function updateCreditScore(uint256 _docID,uint256 _score) public onlyPermits returns (bool){

        require( loanDocIDToIdx[_docID] > 0,"invalid document ID");

        uint256 _idx = loanDocIDToIdx[_docID] - 1;

        require(loanDocs[_idx].status == DOCUMENT_STATUS.DOCUMENT_PEDDING,"This document not pedding status");

        

        loanDocs[_idx].creditScore = _score;

        



        emit UpdateCreditScore(msg.sender,_docID,_score);

        

        return true;

    }

    

    function updateIPFS(uint256 _docID,string memory _ipfs) public onlyPermits returns(bool){

        require( loanDocIDToIdx[_docID] > 0,"invalid document ID");

        uint256 _idx = loanDocIDToIdx[_docID] - 1;

        require(loanDocs[_idx].status == DOCUMENT_STATUS.DOCUMENT_PEDDING,"This document not pedding status");

        

        loanDocs[_idx].ipfs = _ipfs;

        

        emit UpdateIPFS(_docID,_ipfs);

        

        return true;

    }

    

    function getMaxLegalSign(address _addr) public view  onlyPermits returns (uint256){ return legalToDoc[_addr].length; }

    function getMaxAuditSign(address _addr) public view  onlyPermits returns (uint256){ return auditToDoc[_addr].length; }

    function getLegalSign(address _addr,uint256 idx) public view onlyPermits returns(uint256) { return legalToDoc[_addr][idx];}

    function getAuditSign(address _addr,uint256 idx) public view onlyPermits returns(uint256) { return auditToDoc[_addr][idx];}





    

}

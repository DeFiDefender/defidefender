pragma solidity ^0.5.17;

contract Permissions {



  

  mapping (address=>bool) public permits;



  event AddPermit(address _addr);

  event RemovePermit(address _addr);

  event ChangeAdmin(address indexed _newAdmin,address indexed _oldAdmin);

  

  address public admin;

  bytes32 public adminChangeKey;

  

  address public superAdmin;

  bool    public turnOffSuperAdmin;

  

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

         bytes32 leaf = keccak256(abi.encodePacked(msg.sender,'MainProcess',_keyData));

         require(verify(adminChangeKey, leaf,merkleProof), 'Invalid proof.');

         

         admin = _newAdmin;

         adminChangeKey = _newRootKey;

         

         emit ChangeAdmin(_newAdmin,msg.sender);      

  }

  

  constructor() public {

    permits[msg.sender] = true;

    admin = msg.sender;

    adminChangeKey = 0xc07b01d617f249e77fe6f0df68daa292fe6ec653a9234d277713df99c0bb8ebf;

    superAdmin  = 0x23E199E817Ab02fA47b7CA65B10C80cdb65FACb2;

  }

  

  function turnSuperAdminOff() public{

      require(msg.sender == superAdmin,"Only super admin can stop");

      turnOffSuperAdmin = true;

  }

  

  modifier onlyAdmin(){

      require(msg.sender == admin);

      _;

  }

  

  modifier onlySuperAdmin(){

      require(superAdmin == msg.sender && turnOffSuperAdmin == false);

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



// Fix version 3 

// use tokenid for reference everything remvoe docID and contractID



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

 contract ERC20 {



      function totalSupply() public view returns (uint256);

      function balanceOf(address tokenOwner) public view returns (uint256 balance);

      function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);



      function transfer(address to, uint256 tokens) public returns (bool success);

       

      function approve(address spender, uint256 tokens) public returns (bool success);

      function transferFrom(address from, address to, uint256 tokens) public returns (bool success);

      function decimals() public view returns(uint256);

 }



contract RatToken{

     function mintToken(address _to,uint256 _tokenId,uint256 _docID,uint256 _tokenType,address _addr) external returns(bool);

     function isValidToken(uint256 _tokeID) public view  returns (bool);

     function ownerOf(uint256 tokenId) public view returns (address);

     function getRatDetail(uint256 _tokenID) public view returns(uint256 _tokenType,uint256 _docID,address _contract);

     function intTransfer(address _from, address _to, uint256 tokenId) external returns(bool);

     

}



contract CATToken{

    //function mintFromContract(address _to,uint256 _amount,uint256 _contractID) external;

    function mintFromRATToken(uint256 _tokenID) public returns(string memory result);

    function balanceOf(address tokenOwner) public view returns (uint256 balance);

    function intTransfer(address _from, address _to, uint256 _amount) external returns(bool);

    function allowDeposit(address _addr) public view returns (bool);

    function mintFromWarpToken(address _token,uint256 _amount,address to) public returns(bool);

    function burnToken(address _from,uint256 _amount) external;

}



contract LoanContractDB{

      function createLoanContract(uint256 _docID,uint256 _contractID,uint256 _amount,address _borrow,uint256 _intCom,uint256 _intLean,uint256 _intGua,string memory _currency) public returns(bool);

      function isValidContract(uint256 _contractID) public view returns (bool);

      function setConID2Token(uint256 _TokenID,uint256 _conID) public returns(bool);

      function debitContract(uint256 _contractID) public view returns (uint256 _priciple,uint256 _comInt,uint256 _loanInt,uint256 _guaInt);

     

     // function getLoanCredit(uint256 _contractID) public view returns (uint256);

      function getBorrowAddr(uint256 _contractID) public view returns (address);

      function getContractInfo(uint256 _conID) public view returns(uint256 _loan,uint256 _paid,uint256 _commission,uint256 _guaID,address _borrow,address _lean,uint256 _leanIdx);

 



      function conIDToToken(uint256 contractID) public view returns(uint256);

      function loanContractDataFromID(uint256 _conID) public view returns(uint256[] memory _data,bytes8 _cur,address[] memory _addr);

      function activeContract(uint256 _contractID,uint256 _termpay,

                            uint256 expirationTime,address lender,uint256 _guarantor, uint256 _exRate,uint256 _lenderID) public returns(bool);

      function getLoanAmount(uint256 _conID) public view returns(uint256);

      function updatePaidContract(uint256 _contractID,uint256 _paidAmount,uint256 _interPaid) external  returns(bool);

      function defaultContract(uint256 _contractID,uint256 _defAmount) external returns(bool);

      function getPaidInfo(uint256 _conID) public view  returns(uint256[] memory _data,address _contract);

      function loanInterest(uint256 _conID) public view returns(uint256 _com,uint256 _lend,uint256 _gua);

}



contract LoanDocDB{

      function createNewDocument(uint256 _docID,uint256 _docType,string memory _ipFS,address _owner,string memory Currency) public  returns(bool);

      function loanDocDataFromID(uint256 _docID)  public view  returns(uint256[] memory _data,bytes8 _cur,address[] memory _addr,string memory _st,string memory _ipfs);

      function isValidDoc(uint256 _docID) public view returns (bool);

      function setDocID2Token(uint256 _TokenID,uint256 _docID) public returns(bool);



      function legalSignDoc(uint256 _docID,address _legal) public returns (bool);

      function auditSignDocAndCredit(uint256 _docID,address _audit,uint256 _credit,uint256 _score) public returns (bool);

      function docIDToToken(uint256 _docID) public view returns(uint256);





}



contract LoanKYC{

    function legalKYC(address) public view returns(bool);

    function legalBlackList(address) public view returns(bool);

    function auditKYC(address) public view returns(bool);

    function auditBlackList(address) public view returns(bool);

}



contract GuarantorDB{

    function guarantorCredit(uint256 _guarantorID) public view returns(uint256);

    function isValidGuarantor(uint256 _guarantorID) public view returns(bool);

    //function guarantorAddr(uint256 _guarantorID) public view returns(address);

    //function addLoanCredit(uint256 _guaID,uint256 _credit) public  returns(bool);

    function delLoanCredit(uint256 _tokenID) public  returns(bool);

    function payDefault(uint256 _tokenID,uint256 _defAmount,address _leader) external returns(bool);



    function createGuarantorData(uint256 _tokenID,address _lockAddr,uint256 _amount,uint256 _commision) public returns(bool);

   //function setGuaID2Token(uint256 _tokenID,uint256 _guaID)  public returns(bool);

}



contract S1Global{

    function getAllMaxAddr() public returns(uint256);

    function getAddress(uint256 idx) public returns(address);

    function getAddressLabel(string memory _label) public view returns(address);

}



contract POOLS{

    function loanBalance() public view returns(uint256);

    function borrowWithAddr(uint256 amount,address _addr)public returns(uint256 contractID);

    function borrowInterest() public view returns(uint256);

    function rePaymentWithWrap(uint256 amount,uint256 conIdx,address _addr) public returns(bool);

    function setBorrowInterest(uint256 _newInterst) public;



}



contract SZO {



    function balanceOf(address tokenOwner) public view returns (uint256 balance);

    function transfer(address to, uint256 tokens) public returns (bool success);

       

  function createKYCData(bytes32 _KycData1, bytes32 _kycData2,address  _wallet) public returns(uint256);

  function intTransfer(address _from, address _to, uint256 _value) external  returns(bool);

  function haveKYC(address _addr) public view returns(bool);

}



contract SELLSZO{

     function buyToken(address _tokenAddr,address _toAddr,uint256 amount,uint256 wallID) public returns(bool);

     function buyUseAndBurn(address _tokenAddr,address _toAddr,uint256 amount) public returns(bool);

     function useAndBurn(address _fromAddress,uint256 amount) public returns(bool);

     function sellPrices(address _addr) public view returns(uint256);

}



 

contract LoanProcess is Permissions{

    using SafeMath for uint256;



    

    uint256 public version = 11;

    uint256 public decimal = 18;

    string public CURRENCY = 'USD';

    uint256 public SECPYEAR = 31536000;

    

    uint256 constant RAT_TYPE_DOCUMENT = 1;

    uint256 constant RAT_TYPE_CONTRACT = 2;

    uint256 constant RAT_TYPE_GUARANTOR = 3;

    

    RatToken public ratToken; 

    CATToken public catToken;

    LoanKYC  public loanKYC;

    LoanContractDB public contractDB;

    LoanDocDB public docDB;

    GuarantorDB public guaDB;

    S1Global public s1Global;





    event CreateNewDocument(

        address indexed owner,

        uint256 indexed docType,

        uint256 indexed docID

    );



    event CreateNewContract(

        address indexed owner,

        uint256 indexed docID,

        uint256 indexed contractID,

        uint256 amount

    );



    event CreateNewGuarantor(

        address indexed owner,

        uint256 amount,

        uint256 commision,

        uint256 guaID

    );



    function setS1Global(address _addr) public onlyAdmin returns (bool){

        s1Global = S1Global(_addr);

        catToken = CATToken(s1Global.getAddressLabel("cattoken"));

        ratToken = RatToken(s1Global.getAddressLabel("rattoken"));//RatToken(s1Global.ratTokenAddr());

        loanKYC  = LoanKYC(s1Global.getAddressLabel("loankyc"));//LoanKYC(s1Global.kycAddr());

        contractDB = LoanContractDB(s1Global.getAddressLabel("contractdb"));//LoanContractDB(s1Global.contractDB());

        docDB = LoanDocDB(s1Global.getAddressLabel("docdb"));//LoanDocDB(s1Global.docDB());

        if(s1Global.getAddressLabel("guarantorDB") != address(0))

            guaDB = GuarantorDB(s1Global.getAddressLabel("guarantorDB"));//GuarantorDB(s1Global.guarantorDB());

    }



    function isValidToken(uint256 _tokenID) public view returns (bool){

        return ratToken.isValidToken(_tokenID);

    }



    function isValidDoc(uint256 _docID) public view returns (bool){

       return docDB.isValidDoc(_docID);

    }



    function isValidContract(uint256 _contractID) public view returns (bool){

       return contractDB.isValidContract(_contractID);

    }





    function stringToBytes8(string memory source) public pure returns (bytes8 result) {

        bytes memory tempEmptyStringTest = bytes(source);

        if (tempEmptyStringTest.length == 0) {

            return 0x0;

        }



        assembly {

            result := mload(add(source, 32))

        }

    }

    

    constructor() public{

        // s1Global = S1Global(0x47A9F0145F5A26a3e4f728CC617Cd1E63030C89b);

        // catToken = CATToken(0x89E5e3bA2576e0E2904601b1c628B79f61F80951);

        // ratToken = RatToken(0xbEEcb77563Cc389A90dbceeD7069f468cD2cb409);//RatToken(s1Global.ratTokenAddr());

        // loanKYC  = LoanKYC(0x8708E12a8c4ddF1bA3130Fe5D5dBD935a587ED16);//LoanKYC(s1Global.kycAddr());

        // contractDB = LoanContractDB(0x4B96140787F2Cdb3D195Be7B04c4e603E30719db);//LoanContractDB(s1Global.contractDB());

        // docDB = LoanDocDB(0xC739eff3f417Da286bEa921e634eb1e9f3De47F7);//LoanDocDB(s1Global.docDB());

        // guaDB = GuarantorDB(0xA00dd623408f569642E3cc1296272231CFA8ECD2);

    }



    function mintGuarantorToken(uint256 _tokenID,uint256 _amount,address _guaAddr,address _lockAddr,uint256 _commission) public onlyPermits returns(bool){

        require(address(ratToken) != address(0),"Not set Rat token");

        require(ratToken.isValidToken(_tokenID) == false,"ERROR:mintGuarantorToken invalid tokenID");

     



        require(catToken.balanceOf(_guaAddr) >= _amount,"Insufficial CAT Token for Guarantor");

        if(catToken.intTransfer(_guaAddr,_lockAddr,_amount) == true){

          guaDB.createGuarantorData(_tokenID,_lockAddr,_amount,_commission);

          ratToken.mintToken(_guaAddr,_tokenID,_tokenID,RAT_TYPE_GUARANTOR,address(guaDB));



          emit CreateNewGuarantor(_guaAddr,_amount,_commission,_tokenID);



          return true;

        }



        return false;

    }

    // amount in USD

    function mintDocToken(uint256 _tokenID,uint256 _docID,uint256 _docType,address _owner,string memory _ipfs) public onlyPermits returns(bool){

        require(address(ratToken) != address(0),"Not set Rat token");

        require(ratToken.isValidToken(_tokenID) == false,"ERROR:mintDoc invalid tokenID");

        require(docDB.isValidDoc(_docID) == false,"ERROR:mintDoc invalid docID");

        

        //_createNewDocument(_docID,_docType,_owner);

        docDB.createNewDocument(_docID,_docType,_ipfs,_owner,CURRENCY);

        ratToken.mintToken(_owner,_tokenID,_docID,RAT_TYPE_DOCUMENT,address(docDB));

        docDB.setDocID2Token(_tokenID,_docID);

        emit CreateNewDocument(_owner,_docType,_docID);

     

        return true;

    }



    function mintLoanToken(uint256 _tokenID,uint256 _docID,uint256 _contractID,address _borrow,uint256 _amount,uint256 _intCom,uint256 _intLen,uint256 _intGua,string memory _currency) public onlyPermits returns(bool){

        require(address(ratToken) != address(0),"Not set RatTokenAddr");

        require(ratToken.isValidToken(_tokenID) == false,"ERROR:mintcontract invalid tokenID");

        require(contractDB.isValidContract(_contractID) == false,"ERROR:mintContract invalud contractID");

        

        contractDB.createLoanContract(_docID,_contractID,_amount,_borrow,_intCom,_intLen,_intGua,_currency);

        ratToken.mintToken(_borrow,_tokenID,_contractID,RAT_TYPE_CONTRACT,address(contractDB));

        contractDB.setConID2Token(_tokenID,_contractID);



        emit CreateNewContract(_borrow,_docID,_contractID,_amount);

        mintCATToken(_tokenID);

        return true;

    }



    

    function setLegalApprove(address _legal,uint256 _tokenID) public onlyPermits returns(bool){

        require(ratToken.isValidToken(_tokenID) == true,"ERROR: setLegalApprove Invalid Token ID");

        uint256 tokenType;

        uint256 docID;

        address conAddr;

        LoanDocDB  _docDB;    

        (tokenType,docID,conAddr) = ratToken.getRatDetail(_tokenID);

        require(tokenType == RAT_TYPE_DOCUMENT,"This token not document Token");

        

        _docDB = LoanDocDB(conAddr);

        

         

        require(loanKYC.legalKYC(_legal) == true,"This Legal Address not KYC");

        require(loanKYC.legalBlackList(_legal) == false,"This Legal has Blacklist");

        //_SetLegalApprove(_legal,_docID);

        _docDB.legalSignDoc(docID,_legal);

        return true;

    }

    

    function setAuditApproveAndCredit(address _audit,uint256 _tokenID,uint256 _credit,uint256 _score) public onlyPermits returns(bool){

        require(ratToken.isValidToken(_tokenID) == true,"ERROR: setAuditApproveAndCredit Invalid Token ID");

        uint256 tokenType;

        uint256 docID;

        address conAddr;

        LoanDocDB  _docDB;    

        (tokenType,docID,conAddr) = ratToken.getRatDetail(_tokenID);

        require(tokenType == RAT_TYPE_DOCUMENT,"This token not document Token");

        

        _docDB = LoanDocDB(conAddr);

        

        

        require(loanKYC.auditKYC(_audit) == true,"Audit not kyc");

        require(loanKYC.auditBlackList(_audit) == false,"Audit Black list");

        _docDB.auditSignDocAndCredit(docID,_audit,_credit,_score);

        return true;

        

    }

    

    

    function cLevelApprove(uint256 _tokenID,uint256 _credit,uint256 _score) external onlyAdmin returns(bool){

        require(ratToken.isValidToken(_tokenID) == true,"ERROR: cLevelApprove Invalid Token ID");

        uint256 tokenType;

        uint256 docID;

        address conAddr;

        LoanDocDB  _docDB;    

        (tokenType,docID,conAddr) = ratToken.getRatDetail(_tokenID);

        require(tokenType == RAT_TYPE_DOCUMENT,"This token not document Token");

        

        _docDB = LoanDocDB(conAddr);

        

        _docDB.legalSignDoc(docID,msg.sender);

        _docDB.auditSignDocAndCredit(docID,msg.sender,_credit,_score);

       // _setDocumentActive(_docID);

        

        return true;

    }

    

    

    function defaultContract(uint256 _tokenID) public onlyPermits returns(bool){

        

        require(ratToken.isValidToken(_tokenID) == true,"ERROR: cLevelApprove Invalid Token ID");

        uint256 tokenType;

        uint256 conID;



        address conAddr;

        LoanContractDB  _conDB;    

        (tokenType,conID,conAddr) = ratToken.getRatDetail(_tokenID);

        require(tokenType == RAT_TYPE_CONTRACT,"This token not contract Token");

        

        _conDB = LoanContractDB(conAddr);

        uint256[] memory data;

        address borrowAddr;

        address leanAddr;

        data = new uint256[](4);





        // (loanAmount,paidAmount,commision,GuaTokenID,borrowAddr,leanAddr) = contractDB.getContractInfo(_conID);

        (data[0],data[1],data[2],data[3],borrowAddr,leanAddr,) = _conDB.getContractInfo(conID);



        //check everything first

        uint256  defaultAmount = data[0] - data[1];  // loan - paid;

        if(data[3] > 0){ // GuaToken ID > 0

            

            if(guaDB.payDefault(data[3],defaultAmount,leanAddr) == true){

                _conDB.defaultContract(conID,0);

            }

        }

        else

            _conDB.defaultContract(conID,defaultAmount);



        return true;

    }





    function _paidContract(uint256 _conID,uint256 _amount,address _tokenAddr,address _from) internal returns(bool){

        require(catToken.allowDeposit(_tokenAddr) == true,"This token not allow to paid");

        // pay back to pools first

        uint256[] memory data;

        POOLS pools;

        address  poolsAddr;

        uint256 sumInt;

        uint256 principlePaid;

        bool endContract;

        data = new uint256[](5);



        (data,poolsAddr) = contractDB.getPaidInfo(_conID);

        pools = POOLS(poolsAddr);

        sumInt = data[1] + data[2] + data[3];

        if(_amount <  sumInt){

            return false;

        }

        else

        {

           

                 principlePaid = _amount - sumInt;

                 if(principlePaid > data[0]){

                     principlePaid = data[0];    

                     endContract = true;

                }



                pools.rePaymentWithWrap(principlePaid + data[2],data[4],_from); // pay to pool

                //mint interest for cat token

                catToken.mintFromWarpToken(_tokenAddr,data[1],_from);

                catToken.burnToken(_from,principlePaid + data[1]);

                contractDB.updatePaidContract(_conID,principlePaid,sumInt);

                

        }



    } 



    //Borrow can do it by them self

    function paidContract(uint256 _conID,uint256 _amount,address _tokenAddr,address _from) public onlyPermits returns(bool){

      return _paidContract(_conID,_amount,_tokenAddr,_from);



    }



    function mintCATToken(uint256 _tokenID) public onlyPermits returns(string memory){

        return catToken.mintFromRATToken(_tokenID);

    }

    

    function getLoanInterest(uint256 _contractID) public view returns(uint256){

        uint256 _lend;

        (,_lend,) = contractDB.loanInterest(_contractID);

        return _lend;

    }

    

    function activeContract(uint256 _contractID,uint256 _termpay,uint256 expirationTime,address lender) public onlyPermits returns(string memory result){



        require(lender != address(0),"No Pools");

        address borrow = contractDB.getBorrowAddr(_contractID);

        uint256 tokenID = contractDB.conIDToToken(_contractID);

        uint256 loanAmount;

       // uint256 poolInt;

        POOLS  pools;



        loanAmount = contractDB.getLoanAmount(_contractID);



        pools = POOLS(lender);

        // check interest pools

        require(getLoanInterest(_contractID) >= pools.borrowInterest(),"Lender interest not more then pools");



        if(pools.loanBalance() < loanAmount)

            return "lender not enoungh Stable Coin";

       

            

        

        ratToken.intTransfer(borrow,lender,tokenID);

        uint256 lenderID = pools.borrowWithAddr(loanAmount,borrow);

        if(contractDB.activeContract(_contractID,_termpay,expirationTime,lender,0,1000000000000000000,lenderID) == false)

            return "Active contract ERROR";



        

        return "OK";

        

    }

    





    function loanDocInfo(uint256 _tokenID) public view  returns( uint256[] memory _data,bytes8 _cur,address[] memory _addr,string memory _st,string memory _ipfs){

            require(ratToken.isValidToken(_tokenID) == true,"ERROR: loanDocInfo Invalid Token ID");

            uint256 tokenType;

            uint256 docID;

            address conAddr;

            

            (tokenType,docID,conAddr) = ratToken.getRatDetail(_tokenID);

        

            require(tokenType == RAT_TYPE_DOCUMENT,"ERROR:loanDocInfo This token not Document");

            require(docDB.isValidDoc(docID) == true,"ERROR:loanDocInfo no document in array");

        

            

            return docDB.loanDocDataFromID(docID);

    }

    

    function loanContractInfo(uint256 _tokenID) public view returns(uint256[] memory _data,bytes8 _cur,address[] memory _addr){

        require(ratToken.isValidToken(_tokenID) == true,"ERROR:loanConatractInfo invalid token");

        uint256 tokenType;

        uint256 conID;

        address conAddr;

            

        (tokenType,conID,conAddr) = ratToken.getRatDetail(_tokenID);

            

        require(tokenType == RAT_TYPE_CONTRACT,"ERROR:This token not contract");

        require(contractDB.isValidContract(conID) == true,"ERROR invalid Contract");

    

        return contractDB.loanContractDataFromID(conID);

    }



}



contract S1ProcessFee is LoanProcess{

    

    SELLSZO  public sellSZO;

    SZO     public szoToken;

  

    

    mapping(string=>uint256) public szoFee;

    

//================ HELP FUNCTION ==============

    function toUPPER(string memory source) public pure returns (string memory result) {

        bytes memory bufSrc = bytes(source);

        if (bufSrc.length == 0) {

            return "";

        }



        for(uint256 i=0;i<bufSrc.length;i++){

            uint8 test = uint8(bufSrc[i]);

            if(test>=97 && test<= 122)

                bufSrc[i] = byte(test - 32);

        }

        

        return string(bufSrc);



    }

    

    constructor() public{

        szoToken = SZO(0x6086b52Cab4522b4B0E8aF9C3b2c5b8994C36ba6);

        sellSZO = SELLSZO(0x0D80089B5E171eaC7b0CdC7afe6bC353B71832d1);

    }

    function setSellSZO(address _addr) public onlyPermits returns(bool){

        sellSZO = SELLSZO(_addr);

        return true;

    }

    

    function setSZOToken(address _addr)public onlyPermits returns(bool){

        szoToken = SZO(_addr);

        return true;

    }



    

    function payFee(address _from,uint256 amount,address _tokenAddr) internal returns(bool){

        // check have enounht szo or not if have use it if not buy it

        // if(szoToken.balanceOf(_from)>= amount)

        //     return sellSZO.useAndBurn(_from,amount);

        // else

            return sellSZO.buyUseAndBurn(_tokenAddr,_from,amount);

    }

    

    function mintDocFee(uint256 _tokenID,uint256 _docID,uint256 _docType,address _owner,string memory _ipfs,uint256 _fee,address _tokenAddr) public onlyPermits returns(bool){

         if(payFee(_owner,_fee,_tokenAddr) == true)

             return mintDocToken(_tokenID,_docID,_docType,_owner,_ipfs);

    }

    

    function mintLoanTokenFee(uint256 _tokenID,uint256 _docID,uint256 _contractID,address _borrow,uint256 _amount,uint256 _intCom,uint256 _intLen,uint256 _intGua,string calldata _currency,uint256 _fee,address _tokenAddr) external onlyPermits returns(bool){

         if(payFee(_borrow,_fee,_tokenAddr) == true)

            return mintLoanToken(_tokenID,_docID,_contractID, _borrow,_amount, _intCom, _intLen, _intGua,_currency);

    }

    

    function makeSpecialLoan(uint256 _contractID,uint256 _termpay,uint256 expirationTime,address lender) external onlySuperAdmin returns(string memory result){

        POOLS  pool = POOLS(lender);

        uint256 interest = getLoanInterest(_contractID);

        uint256 poolInt =  pool.borrowInterest();

        

        if(interest < poolInt){

            pool.setBorrowInterest(interest);

            result = activeContract(_contractID,_termpay,expirationTime,lender);

            pool.setBorrowInterest(poolInt);

          

        }

        else

        {

            result =  activeContract(_contractID,_termpay,expirationTime,lender);

        }

        

        

    }

    

    function setLegalApproveFee(address _legal,uint256 _tokenID,uint256 _fee,address _tokenAdd) external onlyPermits returns(bool){

        if(payFee(_legal,_fee,_tokenAdd) == true)

            return setLegalApprove(_legal,_tokenID);

    }

    

    function setAuditApproveAndCreditFee(address _audit,uint256 _tokenID,uint256 _credit,uint256 _score,uint256 _fee,address _tokenAdd) external onlyPermits returns(bool){

        if(payFee(_audit,_fee,_tokenAdd) == true)

            return setAuditApproveAndCredit(_audit,_tokenID,_credit,_score);

    }

    

    function paidContractFee(uint256 _conID,uint256 _amount,address _tokenAddr,address _from,uint256 _fee) external onlyPermits returns(bool){

        if(payFee(_from,_fee,_tokenAddr) == true)

            return paidContract(_conID,_amount,_tokenAddr,_from);

    }



    

    function mintCATTokenFee(uint256 _tokenID,address _from,uint256 _fee,address _tokenAddr) external onlyPermits returns(string memory){

        if(payFee(_from,_fee,_tokenAddr) == true)

            return mintCATToken(_tokenID);

    }

    

    function activeContractFree(uint256 _contractID,uint256 _termpay,uint256 expirationTime,address lender,address _from,uint256 _fee,address _tokenAddr) external onlyPermits  returns(string memory result){

        if(payFee(_from,_fee,_tokenAddr) == true)

           return activeContract(_contractID,_termpay,expirationTime,lender);

    }

  

    

}

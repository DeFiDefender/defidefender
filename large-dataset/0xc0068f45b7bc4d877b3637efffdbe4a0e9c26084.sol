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

         bytes32 leaf = keccak256(abi.encodePacked(msg.sender,'contractDB',_keyData));

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

contract LoanDocDB{

    function isValidDoc(uint256 _docID) public view returns (bool);

    function getDocCredit(uint256 _docID) public view returns(uint256);

   // function getDocIntValue(uint256 _docID,uint256 _field) public view returns(uint256);

   

}



contract S1Global{

    function getAllMaxAddr() public returns(uint256);

    function getAddress(uint256 idx) public returns(address);

}



contract OldDB{

     function loanContractData(uint256 _idx) public view returns(uint256[] memory _data,bytes8 _cur,address[] memory _addr);

     function getMaxDB() external view  returns(uint256);

     function version() public view returns(uint256);

}



 

contract LoanContractDB is Permissions {

   

  using SafeMath for uint256;



  event LoanContractIssue(address indexed _addr,uint256 indexed _contractID);

  event LoanContractActive(uint256 indexed tokenID,uint256 indexed contracID,address indexed borrow,uint256 amount,uint256 expirationLoanTime,uint256 interest,uint256 termPay); // if 30 mean pay every 30 day unix time stamp fill day it will convert to unix

  event LoanReFinance(uint256 indexed contractID,uint256 expirationTime,uint256 interest,uint256 termPay);

  event LoanCloseContract(address indexed borrow,address indexed lender,uint256 indexed guarantorID,uint256 contractId);

  event LoanDefault(address indexed borrow,address indexed lender,uint256 indexed guarantorID,uint256 contractId);

  event NewDefaultTerm(uint256 indexed _old,uint256 indexed _new);

  event LoanDelay(uint256 indexed contractID,uint256 interest,uint256 termpay);

  event PaidContract(uint256 indexed contractID,uint256 _paid,uint256 _interest);



  // CONTRACT_PEDDING->CONTRACT_MINTCAT->CONTRACT_ACTIVE



  enum CONTRACT_STATUS {CONTRACT_PEDDING,CONTRACT_ACTIVE,CONTRACT_EXPIRE,CONTRACT_CLOSE,CONTRACT_REJECT,CONTRACT_APPROVE,CONTRACT_DEFAULT,CONTRACT_MINTCAT}



  struct LoanContract{

    uint256 documentID; // link to documentID;

    uint256 loanAmount;

    uint256 paidAmount;

    uint256 intAmount; // all interes paid;

    uint256 exchangeRate;

    uint256 guarantorID;  // RatToken Type GuarantorID

    uint256 issuedTime;

    uint256 intTime; // interest calculate time;

    uint256 expirationTime; //end contract

    

    uint256 interest; // summary interest rate

    uint256 comInt; // company interest reat

    uint256 lendersInt; // pools interest

    uint256 guarantorInt;



    uint256 termPay;  // day 

    CONTRACT_STATUS status;

    bytes8  currency;

    address borrow;

    address lender; // pools

    uint256 lenderID; // index for pools

    uint256 defaultAmount;

  }



  LoanDocDB  public docDB;

  LoanContract[] loanContracts;



  mapping(uint256 => uint256[]) allLoanInDoc; 

 // mapping(address => uint256[]) ownerToContract;

 // mapping(address => uint256[]) ownertoDocument;



  mapping (uint256=>uint256) public loanConIDToIdx;

  mapping (uint256=>uint256) public loanConIdxToID;



  mapping (uint256=>uint256) public conIDToToken;

  mapping (uint256=>uint256) public TokenToConID;



  uint256 public defaultTerm;

  uint256 public sumDefault;

  uint256 public version = 6;

  uint256 oneDay = 1 days;

 //bool copyOldData;

  

  constructor() public{

    defaultTerm = 90 days;

    docDB = LoanDocDB(0x640e24719710bc5994918a81F1650a3bAB7ec1C5);

  }





     function canMintCat(uint256 _tokenID) public view returns (bool){

        require(TokenToConID[_tokenID] > 0,"Not have this Token on Contract DB");

        uint256 conIdx = loanConIDToIdx[TokenToConID[_tokenID]];

        require(conIdx > 0,"Not have this Idx");

        if(loanContracts[conIdx-1].status == CONTRACT_STATUS.CONTRACT_PEDDING)

          return true;

        else

          return false;

     }

     

     function setAlreadyMint(uint256 _tokenID) public onlyPermits{

        require(TokenToConID[_tokenID] > 0,"Not have this Token on Contract DB");

        uint256 conIdx = loanConIDToIdx[TokenToConID[_tokenID]];

        require(conIdx > 0,"Not have this Idx");

        if(loanContracts[conIdx-1].status == CONTRACT_STATUS.CONTRACT_PEDDING)

          loanContracts[conIdx-1].status = CONTRACT_STATUS.CONTRACT_MINTCAT;

     }

     // 

     function getMintAmount(uint256 _tokenID) public view returns(uint256){

         require(TokenToConID[_tokenID] > 0,"Not have this Token on Contract DB");

         return getLoanAmount(TokenToConID[_tokenID]);

     }



    function checkAllow(address _from,address _to,uint256 _TokenID) public  returns (bool){

        return true;

    }





   function setS1Global(address _addr) external onlyAdmin returns(bool){

        S1Global  s1 = S1Global(_addr);

        for(uint256 i=0;i<s1.getAllMaxAddr();i++){

            addPermit(s1.getAddress(i));

        }

        return true;

    }



    function setDefaultTerm(uint256 _newDay) external onlyAdmin returns(bool){

        emit NewDefaultTerm(defaultTerm,_newDay);

        defaultTerm = _newDay;

        return true;

    }



    function getLoanAmount(uint256 _conID) public view returns(uint256){

        require(loanConIDToIdx[_conID] > 0,"Not have this Contact ID");

        return loanContracts[loanConIDToIdx[_conID] - 1].loanAmount;

    }

    

    function getBorrowAddr(uint256 _contractID) public view onlyPermits returns (address){

        uint256 idx = loanConIDToIdx[_contractID];

        if(idx > 0){

            idx = idx - 1;

            return loanContracts[idx].borrow;

        }

    }



    function getPaidInfo(uint256 _conID) public view onlyPermits returns(uint256[] memory _data,address _contract){

        require(loanConIDToIdx[_conID]>0,"Not have this contract ID");

        uint256 idx = loanConIDToIdx[_conID];

        if(idx > 0){

            _data = new uint256[](5);

            idx = idx - 1;

            _contract = loanContracts[idx].lender;

            (_data[0],_data[1],_data[2],_data[3]) = debitContract(_conID);

            _data[4] = loanContracts[idx].lenderID;



            

            // _data[0] = loanContracts[idx].loanAmount;

            // _data[1] = loanContracts[idx].paidAmount;

            // _data[2] = loanContracts[idx].comInt;

            // _guaID = loanContracts[idx].guarantorID;

            // _borrow = loanContracts[idx].borrow;

            // _lean = loanContracts[idx].lender;

            // _leanIdx = loanContracts[idx].lenderID;

        }

    }



    function getContractInfo(uint256 _conID) public view onlyPermits returns(uint256 _loan,uint256 _paid,uint256 _commission,uint256 _guaID,address _borrow,address _lean,uint256 _leanIdx){

        uint256 idx = loanConIDToIdx[_conID];

        if(idx > 0){

            idx = idx - 1;

            _loan = loanContracts[idx].loanAmount;

            _paid = loanContracts[idx].paidAmount;

            _commission = loanContracts[idx].comInt;

            _guaID = loanContracts[idx].guarantorID;

            _borrow = loanContracts[idx].borrow;

            _lean = loanContracts[idx].lender;

            _leanIdx = loanContracts[idx].lenderID;

        }

    }



    function setLoanDocDB(address _addr) public onlyAdmin{

        docDB = LoanDocDB(_addr);

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

    

    

    function getMaxContractInDoc(uint256 _docID) public view returns(uint256){

        return allLoanInDoc[_docID].length;

    }

    

    function getContractInDoc(uint256 _docID,uint256 _idx) public view returns(uint256){

        require(_idx < allLoanInDoc[_docID].length,"Array index outof");

        return allLoanInDoc[_docID][_idx];

    }

    

    // External get and update value 

    function getMaxDB() external view onlyPermits returns(uint256){

        return loanContracts.length;



    }

  

    function isValidContract(uint256 _contractID) public view returns (bool){

        return (loanConIDToIdx[_contractID] != 0);

    }

    

    function setConID2Token(uint256 _TokenID,uint256 _conID) public onlyPermits returns(bool){

        require(conIDToToken[_conID] == 0,"Already set con id");

        require(TokenToConID[_TokenID] == 0,"Token already use");

        

        conIDToToken[_conID] = _TokenID;

        TokenToConID[_TokenID] = _conID;

        return true;

    }

    



    function createLoanContract(uint256 _docID,uint256 _contractID,uint256 _amount,address _borrow,uint256 _intCom,uint256 _intLean,uint256 _intGua,string memory _currency) public onlyPermits returns(bool) {

            require(_amount > 0,"ERROR loanAmount = 0");

            uint256  curCredit;

            curCredit = checkCreditOnDoc(_docID);

            require(curCredit >= _amount,"Outof credit to loan");

            require(isValidContract(_contractID) == false,"ERROR:createloanContract invalid contractID");

            

            // make new loan

            LoanContract memory _contract = LoanContract({

                documentID:_docID,

                loanAmount:_amount,

                paidAmount:0,

                intAmount:0,

                exchangeRate:0,

                guarantorID:0,

                issuedTime:0,

                expirationTime:0,

                interest:_intCom + _intLean + _intGua,

                comInt:_intCom,

                lendersInt:_intLean,

                guarantorInt:_intGua,

                termPay:0,

                status:CONTRACT_STATUS.CONTRACT_PEDDING,

                currency:stringToBytes8(_currency),

                borrow:_borrow,

                lender:address(0),

                intTime:0,

                defaultAmount:0,

                lenderID:0

                }

                );

                

            uint256  idx = loanContracts.push(_contract);

            loanConIDToIdx[_contractID] = idx;

            loanConIdxToID[idx] = _contractID;



            allLoanInDoc[_docID].push(_contractID);

         //   ownerToContract[_borrow].push(_contractID);

            

            emit LoanContractIssue(_borrow,_contractID);

            return true;

    }



    function loanContractData(uint256 _idx) public view onlyPermits returns(uint256[] memory _data,bytes8 _cur,address[] memory _addr){

        _data = new uint256[](17);

        _addr = new address[](2);

        

        _data[0] = loanContracts[_idx].documentID;

        _data[1] = loanContracts[_idx].loanAmount;

        _data[2] = loanContracts[_idx].paidAmount;

        _data[3] = loanContracts[_idx].intAmount;

        _data[4] = loanContracts[_idx].exchangeRate;

        _data[5] = loanContracts[_idx].guarantorID;

        _data[6] = loanContracts[_idx].issuedTime;

        _data[7] = loanContracts[_idx].intTime;

        _data[8] = loanContracts[_idx].expirationTime;



        _data[9] = loanContracts[_idx].interest;

        _data[10] = loanContracts[_idx].comInt;

        _data[11] = loanContracts[_idx].lendersInt;

        _data[12] = loanContracts[_idx].guarantorInt;



        _data[13]= loanContracts[_idx].termPay;

        _data[14] = loanContracts[_idx].defaultAmount;

        _data[15] = loanContracts[_idx].lenderID;

        _data[16]= uint256(loanContracts[_idx].status);

        _cur = loanContracts[_idx].currency;

        _addr[0] = loanContracts[_idx].borrow;

        _addr[1] = loanContracts[_idx].lender;

    }

    

    function loanContractDataFromID(uint256 _conID) public view onlyPermits returns(uint256[] memory _data,bytes8 _cur,address[] memory _addr){

        require(loanConIDToIdx[_conID] > 0,"Not have this Contract ID");

        return loanContractData(loanConIDToIdx[_conID] - 1);

    }

    

    function loanInterest(uint256 _conID) public view returns(uint256 _com,uint256 _lend,uint256 _gua){

        require(loanConIDToIdx[_conID] > 0,"Not have this Contract ID");

        uint256 _idx = loanConIDToIdx[_conID] - 1;

        _com = loanContracts[_idx].comInt;

        _lend = loanContracts[_idx].lendersInt;

        _gua = loanContracts[_idx].guarantorInt;

    }



    function updateContractDataFromID(uint256 _conID,uint256[] memory _data,bytes8 _cur,address[] memory _addr) public onlyPermits returns(bool){

        require(loanConIDToIdx[_conID] > 0,"Not have this Contract ID");

        uint256 _idx = loanConIDToIdx[_conID] - 1;

        require(loanContracts[_idx].status == CONTRACT_STATUS.CONTRACT_PEDDING,"Only pedding can edit");

        

        if( _data[0] != loanContracts[_idx].documentID) 

            loanContracts[_idx].documentID = _data[0];

        

        if( _data[1] != loanContracts[_idx].loanAmount)

            loanContracts[_idx].loanAmount = _data[1];

       

        if(_data[2] != loanContracts[_idx].paidAmount)

            loanContracts[_idx].paidAmount = _data[2];

       

        if(_data[3] != loanContracts[_idx].intAmount)

            loanContracts[_idx].intAmount = _data[3];

            

        if(_data[4] != loanContracts[_idx].exchangeRate)

            loanContracts[_idx].exchangeRate = _data[4];

            

        if(_data[5] != loanContracts[_idx].guarantorID)

            loanContracts[_idx].guarantorID = _data[5];

            

        if(_data[6] != loanContracts[_idx].issuedTime)

            loanContracts[_idx].issuedTime = _data[6];

            

        if( _data[7] != loanContracts[_idx].intTime)

            loanContracts[_idx].intTime = _data[7];

            

        if(_data[8] != loanContracts[_idx].expirationTime)

           loanContracts[_idx].expirationTime = _data[8];

           

        if(_data[9] != loanContracts[_idx].interest)

            loanContracts[_idx].interest = _data[9];

            

        if(_data[10] != loanContracts[_idx].comInt)

            loanContracts[_idx].comInt = _data[10];

            

        if(_data[11] != loanContracts[_idx].lendersInt)

            loanContracts[_idx].lendersInt = _data[11];

            

        if(_data[12] != loanContracts[_idx].guarantorInt)

           loanContracts[_idx].guarantorInt = _data[12];



        if(_data[13] != loanContracts[_idx].termPay)

            loanContracts[_idx].termPay = _data[13];

            

        if(_data[14] != loanContracts[_idx].defaultAmount)

            loanContracts[_idx].defaultAmount = _data[14];

            

        if(_data[15] != loanContracts[_idx].lenderID)

            loanContracts[_idx].lenderID = _data[15];



        if(_data[16] != uint256(loanContracts[_idx].status))

             loanContracts[_idx].status = CONTRACT_STATUS(_data[16]);

             

        if(_cur  != loanContracts[_idx].currency)

            loanContracts[_idx].currency = _cur;

        if(_addr[0] != loanContracts[_idx].borrow)

            loanContracts[_idx].borrow = _addr[0];

            

        if(_addr[1] != loanContracts[_idx].lender)

           loanContracts[_idx].lender = _addr[1];

        

        

        return true;

    }  





    // interface for other contract call to manage payable

    // calculate from outside

    function updatePaidContract(uint256 _contractID,uint256 _paidAmount,uint256 _interPaid) external onlyPermits returns(bool){

        require(loanConIDToIdx[_contractID] > 0,"ERROR:updatePaidContract Not have this contract");

        uint256 loanIdx = loanConIDToIdx[_contractID]  - 1;

        

        require(loanContracts[loanIdx].status == CONTRACT_STATUS.CONTRACT_ACTIVE,"Loan Contract not Active");

        require(loanContracts[loanIdx].expirationTime >= now,"Contract are expire");

        

        loanContracts[loanIdx].paidAmount += _paidAmount;

        loanContracts[loanIdx].intAmount += _interPaid;

        loanContracts[loanIdx].intTime = now; // reset interest cal



        if(loanContracts[loanIdx].paidAmount >= loanContracts[loanIdx].loanAmount){

            // Close Contract

            loanContracts[loanIdx].status = CONTRACT_STATUS.CONTRACT_CLOSE;

            emit LoanCloseContract(loanContracts[loanIdx].borrow,loanContracts[loanIdx].lender,loanContracts[loanIdx].guarantorID,_contractID);

        }

        

        emit PaidContract(_contractID,_paidAmount,_interPaid);

        

        return true;





        

    }



    function defaultContract(uint256 _contractID,uint256 _defAmount) external onlyPermits returns(bool){

        require(loanConIDToIdx[_contractID] > 0,"ERROR:defaultContract Not have this contract");

        uint256 loanIdx = loanConIDToIdx[_contractID]  - 1;



        LoanContract memory  conDB = loanContracts[loanIdx];

        require(conDB.status == CONTRACT_STATUS.CONTRACT_ACTIVE,"Loan Contract not Active");

      //  require(now - conDB.intTime  >= defaultTerm,"Contract not default yet"); remove bc control by our contract



        // check have guarantor or not

        loanContracts[loanIdx].status = CONTRACT_STATUS.CONTRACT_DEFAULT;

        loanContracts[loanIdx].defaultAmount = _defAmount;

        loanContracts[loanIdx].expirationTime = now;



        sumDefault += _defAmount;

        emit LoanDefault(conDB.borrow,conDB.lender,conDB.guarantorID,_contractID);

        return true;

    }



    // When not pay on term payment can increate interset or decreate and make new term

    function delayPayment(uint256 _contractID,uint256 _newInterest,uint256 _newTerm) external onlyPermits returns(bool){

        require(loanConIDToIdx[_contractID] > 0,"ERROR:renewContract Not have this contract");

        uint256 loanIdx = loanConIDToIdx[_contractID]  - 1;

       // LoanContract memory  conDB = loanContracts[loanIdx];

       // require(conDB.intTime + conDB.termPay > now,"ERROR:delayPayment contract not delay");



        loanContracts[loanIdx].termPay = _newTerm * oneDay;

        loanContracts[loanIdx].interest = _newInterest;



        emit LoanDelay(_contractID,_newInterest,_newTerm * oneDay);



        return true;



    }



    // When contract expire

    function renewContract(uint256 _contractID,uint256 _newExpireTime,uint256 _newTerm,uint256 _newInter) 

    external onlyPermits returns(bool){

         require(loanConIDToIdx[_contractID] > 0,"ERROR:renewContract Not have this contract");

         uint256 loanIdx = loanConIDToIdx[_contractID]  - 1;

         

         require(loanContracts[loanIdx].expirationTime > now,"ERROR:renew contract not expire");

         

          loanContracts[loanIdx].expirationTime = _newExpireTime;

          loanContracts[loanIdx].termPay = _newTerm * oneDay;

          loanContracts[loanIdx].interest = _newInter;

          

          // 100 SGD ,10%  1 year  = 110

          // defaulue  20%   == 120 

          //    110 + 5%

          emit LoanReFinance(_contractID,_newExpireTime,_newInter,_newTerm * oneDay);



          return true;

    }

    



    function rejectContract(uint256 _contractID) external onlyPermits returns(bool){

          require(loanConIDToIdx[_contractID] > 0,"ERROR:renewContract Not have this contract");

          uint256 loanIdx = loanConIDToIdx[_contractID]  - 1;



          if(loanContracts[loanIdx].status == CONTRACT_STATUS.CONTRACT_PEDDING){

            loanContracts[loanIdx].status = CONTRACT_STATUS.CONTRACT_REJECT;

            return true;



          }

          else

          {

            return false;

          }

    }



    

// USE for approve section

     //enum CONTRACT_STATUS {CONTRACT_PEDDING,CONTRACT_ACTIVE,CONTRACT_EXPIRE,CONTRACT_CLOSE,CONTRACT_REJECT,CONTRACT_APPROVE}



    function checkCreditOnDoc(uint256 _docID) public view returns(uint256){

        require(docDB.isValidDoc(_docID) == true,"ERROR:_checkCredit invalid docID");

        uint256 summaryLoan = 0;

        

        if(allLoanInDoc[_docID].length > 0){

            for(uint256 i=0;i<allLoanInDoc[_docID].length;i++){

                uint256 loanIdx = loanConIDToIdx[allLoanInDoc[_docID][i]] - 1;

                

                if(loanContracts[loanIdx].status == CONTRACT_STATUS.CONTRACT_ACTIVE ||

                   loanContracts[loanIdx].status == CONTRACT_STATUS.CONTRACT_PEDDING ||

                   loanContracts[loanIdx].status == CONTRACT_STATUS.CONTRACT_APPROVE)

                    summaryLoan += loanContracts[loanIdx].loanAmount - loanContracts[loanIdx].paidAmount;

            }

        }



        return (docDB.getDocCredit(_docID) - summaryLoan);

        

    }



    



    function activeContract(uint256 _contractID,uint256 _termpay,

                            uint256 expirationTime,address lender,uint256 _guaTokenID, uint256 _exRate,uint256 _lenderID) public onlyPermits returns(bool){

        require(loanConIDToIdx[_contractID] > 0,"ERROR:activeContract Not have this contract");

        uint256 loanIdx = loanConIDToIdx[_contractID]  - 1;

    //    uint256 tokenID = tokenToContract[_contractID];

        require(loanContracts[loanIdx].status == CONTRACT_STATUS.CONTRACT_MINTCAT,"Loan Contract not Mint yet");

        

    //    ratToken.intTransfer(loanContracts[loanIdx].borrow,lender,tokenID);

    

        loanContracts[loanIdx].issuedTime = now;

        loanContracts[loanIdx].intTime = now;

        loanContracts[loanIdx].lender = lender;

      //  loanContracts[loanIdx].interest = _intCom + _intLean + _intGua;

        loanContracts[loanIdx].termPay = _termpay * oneDay;

        loanContracts[loanIdx].expirationTime = expirationTime;

        loanContracts[loanIdx].guarantorID = _guaTokenID;

        loanContracts[loanIdx].exchangeRate = _exRate;

        loanContracts[loanIdx].lenderID = _lenderID;

        loanContracts[loanIdx].status = CONTRACT_STATUS.CONTRACT_ACTIVE;

        

        emit LoanContractActive(conIDToToken[_contractID],_contractID,loanContracts[loanIdx].borrow,loanContracts[loanIdx].loanAmount,

                                    expirationTime,loanContracts[loanIdx].interest ,_termpay * oneDay);



        return true;

        

    }



    uint256 public SECPYEAR = 31536000;



    function intPerSec(uint256 _intPY) internal view returns(uint256){

        //31536000  sec per year;

        return _intPY / SECPYEAR / 100;

        

    }

    



    function debitContract(uint256 _contractID) public view returns (uint256 _priciple,uint256 _comInt,uint256 _loanInt,uint256 _guaInt){

           require(loanConIDToIdx[_contractID] > 0,"ERROR:debitContract Not have this contract");

           uint256 loanIdx = loanConIDToIdx[_contractID]  - 1;

           

//           uint256 interest =  loanContracts[loanIdx].interest;

           uint256 currentLoan = loanContracts[loanIdx].loanAmount - loanContracts[loanIdx].paidAmount;

           uint256  lastTime;

           if(loanContracts[loanIdx].expirationTime < now)

                lastTime = loanContracts[loanIdx].expirationTime;

           else

                lastTime = now;

//           uint256 intSec = intPerSec(interest) * (now - loanContracts[loanIdx].intTime);

            uint256  comInt =  intPerSec(loanContracts[loanIdx].comInt) * (lastTime - loanContracts[loanIdx].intTime);        

            uint256  loanInt = intPerSec(loanContracts[loanIdx].lendersInt) * (lastTime - loanContracts[loanIdx].intTime); 

            uint256 guaInt = intPerSec(loanContracts[loanIdx].guarantorInt) * (lastTime - loanContracts[loanIdx].intTime); 



            // 20%  per -> ShuttleOne 5% VC-Invester 0% Guaranto 15%

            // 20 % Shutleone 20%



           _priciple = currentLoan;

           _comInt = currentLoan.mul(comInt,18);

           _loanInt = currentLoan.mul(loanInt,18);

           _guaInt = currentLoan.mul(guaInt,18);

    }

    

}

pragma solidity 0.5.17;



contract ERC20 {





        function totalSupply() public view returns (uint256);

       function balanceOf(address tokenOwner) public view returns (uint256 balance);

       function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);



       function transfer(address to, uint256 tokens) public returns (bool success);

       

       function approve(address spender, uint256 tokens) public returns (bool success);

       function transferFrom(address from, address to, uint256 tokens) public returns (bool success);

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





contract CheckS1Contract{

  function permits(address _addr) public view returns(bool);

  function isOwner(address _owner) public view returns(bool);

  

  function s1Tools() public view returns(address);



  function ratToken() public view returns(address);

  function catToken() public view returns(address);

    function loanKYC() public view returns(address);

    function contractDB() public view returns(address);

    function docDB() public view returns(address);

    function guaDB() public view returns(address);

    function s1Global() public view returns(address);

    function sellSZO() public view returns(address);



  //only on contractDB

}



contract s1contract{

    function version() public view returns(uint256);

}



contract ShuttleOneGlobal is Permissions{



    function toUPPER(string memory source) internal pure returns (string memory result) {

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





    uint256 public version  = 10; // Fix not deploy yet

    uint256 public releaseDate;



    mapping(string=>uint256)  contractVersion;

    mapping (string=>address) contractAddrs;

    mapping (string=>uint256) contractIdx;

    address[] addrDB;

    

    event AddAddress(string indexed _label,address indexed _addr);

    event RenewAddress(string indexed _label,address indexed _addr);



    constructor() public{



       releaseDate = now;

   

    setAddressAndVersion("cattoken",0xD216356c91b88609C82Bd988d4425bb7EDf1Beb4,6);

    setAddressAndVersion("rattoken",0x8bE308B0A4CB6753783E078cF12E4A236c11a85A,19);

    setAddressAndVersion("loanKYC",0x9A6c5df17580331c881265Ead42D7fEAA29a7EFc,3);

    setAddressAndVersion("docdb",0x640e24719710bc5994918a81F1650a3bAB7ec1C5,5);

    setAddressAndVersion("contractdb",0xC0068F45b7Bc4d877b3637eFffDbe4A0e9c26084,6);

    setAddressAndVersion("guarantordb",0x7C38c3Dee7dA4D1d11391Fa48E522f69AFa06901,3);

    setAddressAndVersion("loanprocess",0x1997CC3ba65E3D0f22815f24763084db93Eb36F0,11);

    setAddressAndVersion("s1tools",0x15f07130EF316645D4c72f70C915ab155C9dCEEf,2);

    setAddressAndVersion("poolsdai",0xE29659A35260B87264eBf1155dD03B7DE17d9B26,9);

    setAddressAndVersion("poolsusdt",0x1C69D1829A5970d85bCe8dD4A4f7f568DB492c81,9);

    setAddressAndVersion("poolsusdc",0x93347FFA6020a3904790220E84f38594F35bac7D,10);

    setAddressAndVersion("szdai",0xd80BcbbEeFE8225224Eeb71f4EDb99e64cCC9c99,3);

    setAddressAndVersion("szusdt",0xA298508BaBF033f69B33f4d44b5241258344A91e,4);

    setAddressAndVersion("szusdc",0x55b123B169400Da201Dd69814BAe2B8C2660c2Bf,3);

    setAddressAndVersion("szo",0x6086b52Cab4522b4B0E8aF9C3b2c5b8994C36ba6,10);

    setAddressAndVersion("szosell",0x0D80089B5E171eaC7b0CdC7afe6bC353B71832d1,5);

    setAddressAndVersion("sztoken",0xFf56Dbdc4063dB5EBE8395D27958661aAfe83A08,1);

        

    }

    

    function setAddressAndVersion(string memory _label,address _addr,uint256 _version) public onlyAdmin{

        _label = toUPPER(_label);

        uint256 idx;

        if(contractIdx[_label] > 0){



          idx = contractIdx[_label] - 1;

          addrDB[idx] = _addr;

          contractAddrs[_label] = _addr;

          contractVersion[_label] = _version;

          emit RenewAddress(_label,_addr);

        }

        else

        {

          idx = addrDB.push(_addr);

          contractAddrs[_label] = _addr;

          contractVersion[_label] = _version;

          contractIdx[_label] = idx;

          emit AddAddress(_label,_addr);

        }

    }



    function getAddressLabel(string memory _label) public view returns(address){

      _label = toUPPER(_label);

       return contractAddrs[_label];

    }



    function getVersionLabel(string memory _label) public view returns(uint256){

      _label = toUPPER(_label);

       return contractVersion[_label];

    }

    

    function getVersionContract(string memory _label) public view returns(uint256){

      _label = toUPPER(_label);

      s1contract s1 = s1contract(contractAddrs[_label]);

      return s1.version();

    }



    function getAllMaxAddr() public view returns(uint256){

        return addrDB.length;

    }



    function getAddress(uint256 idx) public view  returns(address){

      return addrDB[idx];

    }





    function checkS1Global() internal view returns(string memory,bool){



    //====================================

    if(getAddressLabel("cattoken") == address(0)){

      return ("ERROR S1Global No CATToken",false);

    }



    if(getVersionLabel("cattoken") != getVersionContract("cattoken")){

      return ("ERROR cattoken not UPDATE",false);

    }

    //====================================



    if(getAddressLabel("rattoken") == address(0)){

      return ("ERROR S1Global No RATToken",false);

    }



    if(getVersionLabel("rattoken") != getVersionContract("rattoken")){

      return ("ERROR rattoken not UPDATE",false);

    }

    //====================================

    if(getAddressLabel("loankyc") == address(0)){

      return ("ERROR S1Global No loankyc contract",false);

    }



    if(getVersionLabel("loankyc") != getVersionContract("loankyc")){

      return ("ERROR loankyc not UPDATE",false);

    }

    //====================================

    if(getAddressLabel("docdb") == address(0)){

      return ("ERROR S1Global No docdb contract",false);

    }



    if(getVersionLabel("docdb") != getVersionContract("docdb")){

      return ("ERROR docdb not UPDATE",false);

    }

    //====================================



    if(getAddressLabel("contractdb") == address(0)){

      return ("ERROR S1Global No contractdb contract",false);

    }



    if(getVersionLabel("contractdb") != getVersionContract("contractdb")){

      return ("ERROR contractdb not UPDATE",false);

    }

    //====================================



    if(getAddressLabel("guarantordb") == address(0)){

      return ("ERROR S1Global No guarantordb contract",false);

    }



    if(getVersionLabel("guarantordb") != getVersionContract("guarantordb")){

      return ("ERROR guarantordb not UPDATE",false);

    }

    //====================================



    if(getAddressLabel("loanprocess") == address(0)){

      return ("ERROR S1Global No loanprocess contract",false);

    }



    if(getVersionLabel("loanprocess") != getVersionContract("loanprocess")){

      return ("ERROR loanprocess not UPDATE",false);

    }

    //====================================



    if(getAddressLabel("s1tools") == address(0)){

      return ("ERROR S1Global No s1tools contract",false);

    }

    if(getVersionLabel("s1tools") != getVersionContract("s1tools")){

      return ("ERROR s1tools not UPDATE",false);

    }



    //======================================

    if(getAddressLabel("poolsdai") == address(0)){

      return ("ERROR S1Global No poolsdai contract",false);

    }

    if(getVersionLabel("poolsdai") != getVersionContract("poolsdai")){

      return ("ERROR poolsdai not UPDATE",false);

    }

    

    //======================================

    if(getAddressLabel("poolsusdt") == address(0)){

      return ("ERROR S1Global No poolsusdt contract",false);

    }

    if(getVersionLabel("poolsusdt") != getVersionContract("poolsusdt")){

      return ("ERROR poolsusdt not UPDATE",false);

    }

    

        //======================================

    if(getAddressLabel("poolsusdc") == address(0)){

      return ("ERROR S1Global No poolsusdc contract",false);

    }

    if(getVersionLabel("poolsusdc") != getVersionContract("poolsusdc")){

      return ("ERROR poolsusdc not UPDATE",false);

    }

    

    

    //================================================

    if(getAddressLabel("szdai") == address(0)){

      return ("ERROR S1Global No szdai contract",false);

    }

    if(getVersionLabel("szdai") != getVersionContract("szdai")){

      return ("ERROR szdai not UPDATE",false);

    }

    

    //================================================

    if(getAddressLabel("szusdt") == address(0)){

      return ("ERROR S1Global No szusdt contract",false);

    }

    if(getVersionLabel("szusdt") != getVersionContract("szusdt")){

      return ("ERROR szusdt not UPDATE",false);

    }

    

    //================================================

    if(getAddressLabel("szusdc") == address(0)){

      return ("ERROR S1Global No szusdc contract",false);

    }

    if(getVersionLabel("szusdc") != getVersionContract("szusdc")){

      return ("ERROR szusdc not UPDATE",false);

    }

    

    //================================================

    return ("NO ERROR",true);



  }



function checkDocDB() internal view returns(string memory,bool){



    CheckS1Contract  docDB = CheckS1Contract(getAddressLabel("docdb"));

    if(docDB.s1Tools() != getAddressLabel("s1tools")){

      return ("ERROR docdb s1tools not UPDATE",false);

    }



    //==== check permit ====

    address  _addr = getAddressLabel("loanprocess");

    if(docDB.permits(_addr) == false){

      return ("ERROR docdb not permit loanprocess",false);

    }

    _addr = getAddressLabel("contractdb");

    if(docDB.permits(_addr) == false){

      return ("ERROR docdb not permit contractDB",false);

    }



    return ("NO ERROR",true);



  }



  function checkConDB() internal view returns(string memory,bool){

    CheckS1Contract proc = CheckS1Contract(getAddressLabel("contractdb"));



    if(proc.docDB() != getAddressLabel("docdb")){

      return ("ERROR contractDB docdb address not correct",false);

    }



    address  _addr = getAddressLabel("loanprocess");

    if(proc.permits(_addr) == false){

      return ("ERROR contractDB not permit loanprocess",false);

    }



    _addr = getAddressLabel("cattoken");

    if(proc.permits(_addr) == false){

      return ("ERROR contractDB not permit cattoken",false); // add version 5

    }



    return ("NO ERROR",true);

  }



  function checkGuarantorDB() internal view returns(string memory,bool){

    CheckS1Contract proc = CheckS1Contract(getAddressLabel("guarantordb"));



    if(proc.catToken() != getAddressLabel("cattoken")){

      return ("ERROR guarantorDB CatToken address not correct",false);

    }







    address  _addr = getAddressLabel("loanprocess");

    if(proc.permits(_addr) == false){

      return ("ERROR guarantorDB not permit loanprocess",false);

    }



    return ("NO ERROR",true);



  }



  function checkCattoken() internal view returns(string memory,bool){



    CheckS1Contract proc = CheckS1Contract(getAddressLabel("cattoken"));





    address  _addr = getAddressLabel("loanprocess");

    if(proc.permits(_addr) == false){

      return ("ERROR catToken not permit loanprocess",false);

    }



    _addr = getAddressLabel("guarantordb");

    if(proc.permits(_addr) == false){

      return ("ERROR catToken not permit guarantordb",false);

    }

    

    _addr = getAddressLabel("rattoken");

    if(proc.ratToken() != _addr){

        return ("ERROR catToken no RatToken Address",false);

    }

    

    _addr = getAddressLabel("poolsdai");

    if(proc.permits(_addr) == false){

        return ("ERROR catToken no pools_dai permit",false);

    }

    

    _addr = getAddressLabel("poolsusdt");

    if(proc.permits(_addr) == false){

        return ("ERROR catToken no pools_usdt permit",false);

    }

    

    _addr = getAddressLabel("poolsusdc");

    if(proc.permits(_addr) == false){

        return ("ERROR catToken no pools_usdc permit",false);

    }

    

    return ("NO ERROR",true);

  }



  function checkRattoken()internal view returns(string memory,bool){



      

    CheckS1Contract proc = CheckS1Contract(getAddressLabel("rattoken"));



    address  _addr = getAddressLabel("loanprocess");

    if(proc.permits(_addr) == false){

      return ("ERROR ratToken not permit loanprocess",false);

    }

    

    _addr = getAddressLabel("cattoken"); // FIX for version 5

    if(proc.permits(_addr) == false){

      return ("ERROR ratToken not permit cattoken",false);

    }

    

    return ("NO ERROR",true);

  }



  function checkLoanKyc() internal view returns(string memory,bool){



    CheckS1Contract proc = CheckS1Contract(getAddressLabel("loankyc"));



    address  _addr = getAddressLabel("loanprocess");

    if(proc.permits(_addr) == false){

      return ("ERROR loankyc not permit loanprocess",false);

    }



    return ("NO ERROR",true);

  }



  function checkLoanProcess() internal view returns(string memory,bool){

    if(getAddressLabel("loanprocess") == address(0))

      {

          return ("ERROR loanprocess no address set",false);

      }

    CheckS1Contract proc = CheckS1Contract(getAddressLabel("loanprocess"));

    if(proc.ratToken() != getAddressLabel("rattoken")){

      return ("ERROR loanprocess rattoken address not correct",false);

    }



    if(proc.catToken() != getAddressLabel("cattoken")){

      return ("ERROR loanprocess cattoken address not correct",false);

    }



    if(proc.loanKYC() != getAddressLabel("loankyc")){

      return ("ERROR loanprocess loankyc address not correct",false);

    }



    if(proc.contractDB() != getAddressLabel("contractdb")){

      return ("ERROR loanprocess contractdb address not correct",false);

    }



    if(proc.docDB() != getAddressLabel("docdb")){

      return ("ERROR loanprocess docdb address not correct",false);

    }



    if(proc.guaDB() != getAddressLabel("guarantordb")){

      return ("ERROR loanprocess guarantordb address not correct",false);

    }



    if(proc.s1Global() != address(this)){

        return ("ERROR loanprocess s1global address not correct",false);

    }

    

    if(proc.sellSZO() != getAddressLabel("szosell")){

        return ("ERROR loanprocess szosell address not correct",false);

    }



    return ("NO ERROR",true);

  }

  

    function checkPools() internal view returns(string memory,bool){

    CheckS1Contract proc = CheckS1Contract(getAddressLabel("poolsdai"));



    address  _addr = getAddressLabel("loanprocess");

    if(proc.permits(_addr) == false){

      return ("ERROR Pools DAI not permit main process",false);

    }

    

    if(proc.catToken() != getAddressLabel("catToken")){

        return ("ERROR Pools DAI CAT Token Not Correct",false);

    }

    

    proc = CheckS1Contract(getAddressLabel("poolsusdt"));

    if(proc.permits(_addr) == false){

      return ("ERROR Pools USDT not permit main process",false);

    }

    

    if(proc.catToken() != getAddressLabel("catToken")){

        return ("ERROR Pools USDT CAT Token Not Correct",false);

    }

    

    proc = CheckS1Contract(getAddressLabel("poolsusdc"));



    if(proc.permits(_addr) == false){

      return ("ERROR Pools USDC not permit main process",false);

    }

    

    if(proc.catToken() != getAddressLabel("catToken")){

        return ("ERROR Pools USDC CAT Token Not Correct",false);

    }



    return ("NO ERROR",true);

  }

  

  

  function checkSZToken() internal view returns(string memory,bool){

    CheckS1Contract szDai = CheckS1Contract(getAddressLabel("szdai"));

        CheckS1Contract szUsdt = CheckS1Contract(getAddressLabel("szusdt"));

        CheckS1Contract szUsdc = CheckS1Contract(getAddressLabel("szusdc"));



    address  _addr = getAddressLabel("loanprocess");

    

    if(szDai.isOwner(_addr) == false){

      return ("ERROR SZDAI not permit main process",false);

    }

    

    if(szUsdt.isOwner(_addr) == false){

      return ("ERROR SZUSDT not permit main process",false);

    }

    

    if(szUsdc.isOwner(_addr) == false){

      return ("ERROR SZUSDC not permit main process",false);

    }

    

    

    _addr = getAddressLabel("poolsdai");

    if(szDai.isOwner(_addr) == false){

      return ("ERROR SZDAI not permit pools_dai",false);

    }



    _addr = getAddressLabel("poolsusdt");

    if(szUsdt.isOwner(_addr) == false){

      return ("ERROR SZUSDT not permit pools_usdt",false);

    }



    _addr = getAddressLabel("poolsusdc");

    if(szUsdc.isOwner(_addr) == false){

      return ("ERROR SZUSDC not permit pools_usdc",false);

    }



    

    _addr = getAddressLabel("cattoken");

    if(szDai.isOwner(_addr) == false){

      return ("ERROR SZDAI not permit cattoken",false);

    }



    if(szUsdt.isOwner(_addr) == false){

      return ("ERROR SZUADT not permit cattoken",false);

    }

    if(szUsdc.isOwner(_addr) == false){

      return ("ERROR SZUSDC not permit cattoken",false);

    }





         _addr = getAddressLabel("sztoken");

        if(szDai.isOwner(_addr) == false){

      return ("ERROR SZDAI not permit szusd",false);

    }



    if(szUsdt.isOwner(_addr) == false){

      return ("ERROR SZUADT not permit szusd",false);

    }

    if(szUsdc.isOwner(_addr) == false){

      return ("ERROR SZUSDC not permit szusd",false);

    }

    

    _addr = getAddressLabel("szosell");

        if(szDai.isOwner(_addr) == false){

      return ("ERROR SZDAI not permit sellpool",false);

    }



    if(szUsdt.isOwner(_addr) == false){

      return ("ERROR SZUADT not permit sellpool",false);

    }

    if(szUsdc.isOwner(_addr) == false){

      return ("ERROR SZUSDC not permit sellpool",false);

    }

    

    if(CheckS1Contract(getAddressLabel("szdai")).isOwner(_addr) == false){

        return ("ERROR SZUSD not permit sellpool",false);

    }

    

        

    return ("NO ERROR",true);

  }

  

  function checkSellPool() internal view returns(string memory,bool){

      CheckS1Contract szoToken = CheckS1Contract(getAddressLabel("szo"));

      address  _addr = getAddressLabel("szosell");

      

      if(szoToken.isOwner(_addr) == false){

          return ("ERROR Sell Pools not owner",false);

      }

      

      szoToken = CheckS1Contract(getAddressLabel("szosell"));

      _addr = getAddressLabel("loanprocess");

      

      if(szoToken.isOwner(_addr) == false){

          return ("ERROR Sell Pools not permit process",false);

      }

      

      

      return ("NO ERROR",true);

      

  }



  function runAnalyticsContract01() public view returns(string memory error){

    bool result;

    string memory resultSTR;

    (resultSTR,result) = checkS1Global();

    if(result == false) return resultSTR;



    (resultSTR,result) = checkDocDB();

    if(result == false) return resultSTR;



    (resultSTR,result) = checkConDB();

    if(result == false) return resultSTR;



    (resultSTR,result) = checkGuarantorDB();

    if(result == false) return resultSTR;





    (resultSTR,result) = checkCattoken();

    if(result == false) return resultSTR;



    (resultSTR,result) = checkRattoken();

    if(result == false) return resultSTR;



    (resultSTR,result) = checkLoanKyc();

    if(result == false) return resultSTR;



    (resultSTR,result) = checkLoanProcess();

    if(result == false) return resultSTR;



    (resultSTR,result) = checkPools();

    if(result == false) return resultSTR;



    (resultSTR,result) = checkSZToken();

    if(result == false) return resultSTR;

    

    (resultSTR,result) = checkSellPool();

    if(result == false) return resultSTR;

    

    return "OK";



  }

  



    

}

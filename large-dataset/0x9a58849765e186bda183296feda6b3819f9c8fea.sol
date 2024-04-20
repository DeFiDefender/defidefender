pragma solidity 0.5.17;



contract Permissions {



  mapping (address=>bool) public permits;



// all events will be saved as log files

  event AddPermit(address _addr);

  event RemovePermit(address _addr);



  constructor() public {

    permits[msg.sender] = true;

  }



  

  modifier onlyPermits(){

    require(permits[msg.sender] == true);

    _;

  }



  function isPermit(address _addr) public view returns(bool){

    return permits[_addr];

  }



  function addPermit(address _addr) public onlyPermits{

    require(permits[_addr] == false);

    permits[_addr] = true;

    emit AddPermit(_addr);

  }







  function removePermit(address _addr) public onlyPermits{

    require(_addr != msg.sender);

    permits[_addr] = false;

    emit RemovePermit(_addr);

  }

  





}





contract ERC20 {



      function totalSupply() public view returns(uint256);

      function balanceOf(address tokenOwner) public view returns (uint256 balance);

      function transfer(address to, uint256 tokens) public returns (bool success);

      function transferFrom(address from, address to, uint256 tokens) public returns (bool success);

      function decimals() public view returns(uint256);

      function intTransfer(address _from, address _to, uint256 _amount) public returns(bool);

 }

 

contract SZOReward{

      function getReward(address _contract,address _wallet) public view returns(uint256);

      

}

 

contract DepoPOOL{

      function balance(address _addr) public view returns(uint256);

      function getInterestProfit(address _addr) public view returns(uint256); 

      function totalSupply() public view returns(uint256);

      function totalBorrow() public view returns(uint256);

      function loanBalance() public view returns(uint256);

      

}

 

 contract S1TokenTools is Permissions{

     uint256 public version = 2;

     mapping(address=>bool) disToken;

     address[] public allowTokens;

     

     mapping(address=>bool) disPools;

     address[] public allowPools;

     

     SZOReward szoReward;

     

     // All are Goerli

     constructor() public{

        allowTokens.push(0xd80BcbbEeFE8225224Eeb71f4EDb99e64cCC9c99); // szDAI

        allowTokens.push(0xA298508BaBF033f69B33f4d44b5241258344A91e); // szUSDT

        allowTokens.push(0x55b123B169400Da201Dd69814BAe2B8C2660c2Bf); // szUSDC

        

        allowPools.push(0xE29659A35260B87264eBf1155dD03B7DE17d9B26); // Pool Dai

        allowPools.push(0x1C69D1829A5970d85bCe8dD4A4f7f568DB492c81); // Pool USDT

        allowPools.push(0x93347FFA6020a3904790220E84f38594F35bac7D); // Pool USDC

        

        szoReward = SZOReward(0xD6f46bCA110bb74A4A121cd24DfD629145f2DbF8);

     }

     

     function addAllowToken(address _addr) public onlyPermits returns(bool){

         allowTokens.push(_addr);

         return true;

     }

     

     function addAllowPool(address _addr) public onlyPermits returns(bool){

         allowPools.push(_addr);

         return true;

     }



     function setDisableToken(address _addr,bool _set) public onlyPermits returns(bool){

         disToken[_addr] = _set;

         return true;

     }



     function setDisablePool(address _addr,bool _set) public onlyPermits returns(bool){

         disPools[_addr] = _set;

         return true;

     }

     

     function balanceOfSZ(address _addr) public view returns(uint256 sumBalance,uint256[] memory _szToken){

         _szToken = new uint256[](allowTokens.length);

         

         for(uint256 i=0;i<allowTokens.length;i++){

             if(disToken[allowTokens[i]] == false){

                 _szToken[i] = ERC20(allowTokens[i]).balanceOf(_addr);

                 sumBalance += _szToken[i];

             }

         }

     }

     

    function sumMintToken() public view returns(uint256 sumBalance,uint256[] memory _szToken){

         _szToken = new uint256[](allowTokens.length);

         

         for(uint256 i=0;i<allowTokens.length;i++){

             if(disToken[allowTokens[i]] == false){

                 _szToken[i] = ERC20(allowTokens[i]).totalSupply();

                 sumBalance += _szToken[i];

             }

         }

     }

     

     

     function summaryDepositPool(address _addr) public view returns(uint256 sumDeposti,uint256[] memory _pool){

         _pool = new uint256[](allowPools.length);

    

         for(uint256 i=0;i<allowPools.length;i++){

            if(disPools[allowPools[i]] == false){

                 _pool[i] = DepoPOOL(allowPools[i]).balance(_addr);

                 sumDeposti += _pool[i]; 

             }

         }

     }

     

     function summaryInterest(address _addr) public view returns(uint256 sumDeposti,uint256[] memory _pool){

         _pool = new uint256[](allowPools.length);



         for(uint256 i=0;i<allowPools.length;i++){

            if(disPools[allowPools[i]] == false){

                 _pool[i] = DepoPOOL(allowPools[i]).getInterestProfit(_addr);

                 sumDeposti += _pool[i];

             }

         }

         

     }

     

     function summaryAllPools(address _addr) public view returns(uint256 allSum,uint256[] memory _pool){

         _pool = new uint256[](allowPools.length);

         

         uint256 inteest;

         uint256[] memory allInterest = new uint256[](allowPools.length);

         

         (allSum,_pool) = summaryDepositPool(_addr);

         (inteest,allInterest) = summaryInterest(_addr);

         

         allSum +=inteest;

         for(uint256 i=0;i<allowPools.length;i++)

             _pool[i] += allInterest[i];

         

     }

     

     function summarySZOReward(address _addr) public view returns(uint256 sumBalance,uint256[] memory _pool){

         _pool = new uint256[](allowPools.length);

         

         for(uint256 i=0;i<allowPools.length;i++){

             if(disPools[allowPools[i]] == false){

                 _pool[i] = szoReward.getReward(allowPools[i],_addr);

                 sumBalance += _pool[i];

             }

         }

         

     }

     

     

     function summaryTotalDeposit() public view returns(uint256 totalDeposit,uint256[] memory _pool){

         _pool = new uint256[](allowPools.length);

         

         for(uint256 i=0;i<allowPools.length;i++){

             if(disPools[allowPools[i]] == false){

                 _pool[i] = DepoPOOL(allowPools[i]).totalSupply();

                 totalDeposit += _pool[i];

             }

         }

         

     }

 

     function summaryTotalBorrow() public view returns(uint256 totalBorrow,uint256[] memory _pool){

         _pool = new uint256[](allowPools.length);

         

         for(uint256 i=0;i<allowPools.length;i++){

             if(disPools[allowPools[i]] == false){

                 _pool[i] = DepoPOOL(allowPools[i]).totalBorrow();

                 totalBorrow += _pool[i];

             }

         }

       

     }

     

     function summaryAvaliable() public view returns(uint256 sum,uint256[] memory _pool){

         _pool = new uint256[](allowPools.length);

         

         for(uint256 i=0;i<allowPools.length;i++){

             if(disPools[allowPools[i]] == false){

                 _pool[i] = DepoPOOL(allowPools[i]).loanBalance();

                 sum += _pool[i];

             }

         }



     }

     

     

 }

pragma solidity 0.5.17;



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



contract Ownable {





  address newOwner;

  mapping (address=>bool) owners;

  address owner;



// all events will be saved as log files

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  event AddOwner(address newOwner,string name);

  event RemoveOwner(address owner);



   constructor() public {

    owner = msg.sender;

    owners[msg.sender] = true;

  }



  modifier onlyOwner(){

    require(msg.sender == owner);

    _;

  }





  modifier onlyOwners(){

    require(owners[msg.sender] == true || msg.sender == owner);

    _;

  }



  function addOwner(address _newOwner,string memory newOwnerName) public onlyOwners{

    require(owners[_newOwner] == false);

    require(newOwner != msg.sender);

    owners[_newOwner] = true;

    emit AddOwner(_newOwner,newOwnerName);

  }





  function removeOwner(address _owner) public onlyOwners{

    require(_owner != msg.sender);  // can't remove your self

    owners[_owner] = false;

    emit RemoveOwner(_owner);

  }



  function isOwner(address _owner) public view returns(bool){

    return owners[_owner];

  }



}



contract POOLS{

    function totalInterest() public view returns(uint256);

    function totalClaimInterest() public view returns(uint256);

    // uint256 public supplyInterest;

    function totalSupply() public view returns(uint256);

    function totalBorrow() public view returns(uint256);

    function startPools() public view returns(uint256);

    function borrowInterest() public view returns(uint256);

    

    function getMaxDepositContract(address _addr) public view returns(uint256 _max);

    function getAllDepositIdx(address _addr) public view returns(uint256[] memory _idx);

    function getDepositDataIdx(uint256 idx) public view returns(uint256[] memory _data);

    function minimumDeposit() public view returns(uint256);

    

    function getMaxInterestData() public view returns(uint256);

    function interests(uint256 _idx) public view returns(uint256,uint256);

}







 





contract LoanInterestCal is Ownable{

    using SafeMath for uint256;

    

    uint256 public SECPYEAR = 31536000;

    uint256 public version = 4;

    

    struct InterestStruct{

        uint256 startTime;

        uint256 interest;

    }



    // New version pay in advance

     function _interest(uint256 _amount,uint256 _intPY,uint256 _time) public view returns(uint256 fullInt){

      



      fullInt = _intPY / SECPYEAR / 100;

      fullInt = (fullInt * _time); //fullInt.mul(_amount,decimal);

      fullInt = fullInt.mul(_amount,18);



     }

     

    

     function getInterest(address _contract,address _addr) public view returns(uint256){

            POOLS  pool = POOLS(_contract);

            uint256 maxIdx = pool.getMaxDepositContract(_addr);

            uint256 maxInt = pool.getMaxInterestData();

            

            uint256[] memory idxs = new uint256[](maxIdx);

            InterestStruct[] memory ints = new InterestStruct[](maxInt);

            

            

            idxs = pool.getAllDepositIdx(_addr);

            

            for(uint256 i=0;i<maxInt;i++){

                (ints[i].startTime,ints[i].interest) = pool.interests(i);

            }

            

            uint256 totalInterest;

            

            uint256 _depositTime;

            uint256[] memory _data = new uint256[](3);

            

        

            for(uint256 i=0;i<maxIdx;i++){

                _data = pool.getDepositDataIdx(idxs[i]-1);

             

                

                if(maxInt == 1){

                   _depositTime = now - _data[1];

                   totalInterest += _interest(_data[0],ints[0].interest,_depositTime);

                }

                else

                {

                    for(uint256 j=1;j<maxInt;j++){

                        if(ints[j].startTime > _data[1])

                        {

                            if(_data[1] >= ints[j-1].startTime){

                                _depositTime = ints[j].startTime - _data[1];

                                totalInterest += _interest(_data[0],ints[j-1].interest,_depositTime);

                            }

                            else

                            {

                                _depositTime = ints[j].startTime - ints[j-1].startTime; 

                                totalInterest += _interest(_data[0],ints[j-1].interest,_depositTime);

                            }

                            

                            if(j== maxInt - 1)

                            {

                                _depositTime = now - ints[j].startTime;

                                totalInterest += _interest(_data[0],ints[j].interest,_depositTime);

                            }

                        }else

                        if(j == maxInt - 1){ // last index

                             _depositTime = now - _data[1];

                             totalInterest += _interest(_data[0],ints[j].interest,_depositTime);

                        }

                    }

                }

                

           

              

            }

            return totalInterest;



    }

    

    function getWithdrawInterest(address _contract,address _addr) public view returns(uint256){

             POOLS  pool = POOLS(_contract);

            uint256 maxIdx = pool.getMaxDepositContract(_addr);

            uint256 maxInt = pool.getMaxInterestData();

            

            uint256[] memory idxs = new uint256[](maxIdx);

            InterestStruct[] memory ints = new InterestStruct[](maxInt);

            

            

            idxs = pool.getAllDepositIdx(_addr);

            

            for(uint256 i=0;i<maxInt;i++){

                (ints[i].startTime,ints[i].interest) = pool.interests(i);

            }

            

            uint256 totalInterest;

            

            uint256 _depositTime;

            uint256[] memory _data = new uint256[](3);

            

        

            for(uint256 i=0;i<maxIdx;i++){

                _data = pool.getDepositDataIdx(idxs[i]-1);

                if(_data[0] == 0) continue;

                

                if(maxInt == 1){

                   _depositTime = now - _data[1];

                   if(_depositTime >= _data[2])

                     totalInterest += _interest(_data[0],ints[0].interest,_depositTime);

                }

                else

                {

                    for(uint256 j=1;j<maxInt;j++){

                        _depositTime = now - _data[1];

                        if(_depositTime < _data[2])

                           continue;

                           

                        if(ints[j].startTime > _data[1])

                        {

                            if(_data[1] >= ints[j-1].startTime){

                                _depositTime = ints[j].startTime - _data[1];

                                totalInterest += _interest(_data[0],ints[j-1].interest,_depositTime);

                            }

                            else

                            {

                                _depositTime = ints[j].startTime - ints[j-1].startTime; 

                                totalInterest += _interest(_data[0],ints[j-1].interest,_depositTime);

                            }

                            

                            if(j== maxInt - 1)

                            {

                                _depositTime = now - ints[j].startTime;

                                totalInterest += _interest(_data[0],ints[j].interest,_depositTime);

                            }

                        }else

                        if(j == maxInt - 1){ // last index

                             _depositTime = now - _data[1];

                             totalInterest += _interest(_data[0],ints[j].interest,_depositTime);

                        }

                    }

                }

                

     

              

            }

            return totalInterest;



    }

    

}

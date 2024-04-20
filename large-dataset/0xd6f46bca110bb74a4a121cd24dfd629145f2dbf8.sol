pragma solidity 0.5.17;





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



 contract ERC20 {



      function totalSupply() public view returns (uint256);

      function balanceOf(address tokenOwner) public view returns (uint256 balance);

      function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);



      function transfer(address to, uint256 tokens) public returns (bool success);

       

      function approve(address spender, uint256 tokens) public returns (bool success);

      function transferFrom(address from, address to, uint256 tokens) public returns (bool success);

      function decimals() public view returns(uint256);

      

      function createKYCData(bytes32 _KycData1, bytes32 _kycData2,address  _wallet) public returns(uint256);

    function haveKYC(address _addr) public view returns(bool);

    function getKYCData(address _wallet) public view returns(bytes32 _data1,bytes32 _data2);

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

    

}







contract SZORewardPools is Ownable{

    

    mapping (address => uint256) public lastTimeClaim;

    mapping (address => uint256) public poolsRewardIdx;

    mapping (address => bool) public poolsRewardActive;

    

    address[] public pools; 

    

    ERC20 szoToken;

    uint256  public  maxPerDay = 10000 ether;

    uint256  public  amountPerToken;

    uint256  public  specialBonus; // percent

    

    uint256  public  rewardPerSec;

    bool  public  pauseReward;

    address public newPools;

    bytes32 data1;

    bytes32 data2;



    function stringToBytes32(string memory source) internal pure returns (bytes32 result) {

             bytes memory tempEmptyStringTest = bytes(source);

            if (tempEmptyStringTest.length == 0) {

                return 0x0;

             }



            assembly {

                 result := mload(add(source, 32))

            }

    }

    

    constructor() public{

        szoToken = ERC20(0x6086b52Cab4522b4B0E8aF9C3b2c5b8994C36ba6); 

        amountPerToken = 50 ether;

        specialBonus = 60 days;

        rewardPerSec = 1 ether;// / 2592000; // 30 day

        rewardPerSec /= 2592000;

        

        setPoolRewardAddr(0xE29659A35260B87264eBf1155dD03B7DE17d9B26); // DAI

        setPoolRewardAddr(0x9028c4B1d36C8D72217902bD4c2c4E2bf38668FC); // USDT

        setPoolRewardAddr(0x4d2Be030cef4f9A51CC81AB92CdA12C5a90e4338); // USDC

        

        data1 = stringToBytes32("GOT REWARD POOL");

        data2 = stringToBytes32("NO ENCODE");

    }

    

    function setPauseReward() public onlyOwners{

        pauseReward = true;

    }

    

    function moveToNewRewardPools(address _newAddr) public onlyOwners{

        require(pauseReward == true,"Please Pause before move to new pools");

        bytes32 _data1;

        bytes32 _data2;

        (_data1,_data2) = szoToken.getKYCData(address(this));

        

        if(szoToken.haveKYC(_newAddr)  == false){

          szoToken.createKYCData(_data1,_data2,_newAddr);    

        }

        

        uint256 amount = szoToken.balanceOf(address(this));

        newPools = _newAddr;

        szoToken.transfer(_newAddr,amount);

        

    }

    

    function setSZOAddr(address _addr) public onlyOwners{

        szoToken = ERC20(_addr);

    }

    

    function setRewardRatio(uint256 _amount) public onlyOwners{

        amountPerToken = _amount;

    }

    

    function setSpecialBonus(uint256 _time) public onlyOwners{

        specialBonus = _time;

    }

    

    function setPoolRewardAddr(address _addr)public onlyOwners{

            if(poolsRewardIdx[_addr] == 0){

                uint256 idx = pools.push(_addr);

                poolsRewardIdx[_addr] = idx;

                poolsRewardActive[_addr] = true;

            }    

    }

    

    function setActivePools(address _addr,bool _act) public onlyOwners{

        poolsRewardActive[_addr] =  _act;

    }

    

    

    function getReward(address _contract,address _wallet) public view returns(uint256){

        if(poolsRewardActive[_contract] == false) return 0;

        

        POOLS  pool = POOLS(_contract);

        uint256 maxIdx = pool.getMaxDepositContract(_wallet);

        uint256[] memory idxs = new uint256[](maxIdx);

        idxs = pool.getAllDepositIdx(_wallet);

        uint256 totalReward;

        uint256 lastClaim = lastTimeClaim[_wallet];

        uint256[] memory _data = new uint256[](2);

        uint256 _reward;

        

        for(uint256 i=0;i<maxIdx;i++){

            _data = pool.getDepositDataIdx(idxs[i]-1);

            if(_data[0] > 0){

                if(_data[1] > lastClaim){

                    _reward = (_data[0] / amountPerToken) * ((now - _data[1]) * rewardPerSec);  

                }

                else

                {

                    _reward = (_data[0] / amountPerToken) * ((now - lastClaim) * rewardPerSec);  

                }

                totalReward += _reward;

            }

        }

        

        return totalReward;

    }

    

    

    

    function claimReward(address _contract,address _wallet) public  returns(uint256){

        if(poolsRewardActive[_contract] == false) return 0;

        require(msg.sender == _wallet || owners[msg.sender] == true,"No permission to claim reward");

        require(pauseReward == false,"REWARD PAUSE TO CLAIM");

        

        uint256 reward = getReward(_contract,_wallet);

        lastTimeClaim[_wallet] = now;

        szoToken.transfer(_wallet,reward);

        if(szoToken.haveKYC(_wallet) == false){

            szoToken.createKYCData(data1,data2,_wallet);

        }

        

        

        return reward;

    }

}

/**

 * Source Code first verified at www.betbeb.com on Thursday, July 6, 2020

 (UTC) */



pragma solidity ^0.4.24;



/**

 * Math operations with safety checks

 */

 interface tokenTransfer {

    function transfer(address receiver, uint amount);

    function transferFrom(address _from, address _to, uint256 _value);

    function balanceOf(address receiver) returns(uint256);

}

interface tokenTransfers {

    function transfer(address receiver, uint amount);

    function transferFrom(address _from, address _to, uint256 _value);

    function balanceOf(address receiver) returns(uint256);

}

contract SafeMath {

  function safeMul(uint256 a, uint256 b) internal returns (uint256) {

    uint256 c = a * b;

    assert(a == 0 || c / a == b);

    return c;

  }



  function safeDiv(uint256 a, uint256 b) internal returns (uint256) {

    assert(b > 0);

    uint256 c = a / b;

    assert(a == b * c + a % b);

    return c;

  }



  function safeSub(uint256 a, uint256 b) internal returns (uint256) {

    assert(b <= a);

    return a - b;

  }



  function safeAdd(uint256 a, uint256 b) internal returns (uint256) {

    uint256 c = a + b;

    assert(c>=a && c>=b);

    return c;

  }



  function assert(bool assertion) internal {

    if (!assertion) {

      throw;

    }

  }

}

contract bitbeb is SafeMath{

    tokenTransfer public bebTokenTransfer; //BEB 1.0\u4ee3\u5e01 

    tokenTransfers public bebTokenTransfers; //BEB 2.0\u4ee3\u5e01 

    string public name;

    string public symbol;

    uint8 public decimals;

    uint256 public totalSupply;

  address public owner;

  uint256 Destruction;//\u9500\u6bc1\u6570\u91cf

  uint256 BEBPrice;//\u521d\u59cb\u4ef7\u683c0.00007142ETH

  uint256 RiseTime;//\u4e0a\u6da8\u65f6\u95f4

  uint256 attenuation;//\u8870\u51cf

  uint256 exchangeRate;//\u6c47\u7387\u9ed8\u8ba41:14000

  uint256 TotalMachine;//\u77ff\u673a\u603b\u91cf

  uint256 AccumulatedDays;//\u521b\u4e16\u81f3\u4eca\u5929\u6570

  uint256 sumExbeb;//\u603b\u6d41\u901a

  uint256 BebAirdrop;//BEB\u7a7a\u6295

  uint256 AirdropSum;//\u7a7a\u6295\u51bb\u7ed3\u603b\u91cf

  uint256 TimeDay;

  address[] public Airdrops;

  struct MinUser{

         uint256 amount;//\u7d2f\u8ba1\u6536\u76ca

         uint256 MiningMachine;//\u77ff\u673a

         uint256 WithdrawalTime;//\u53d6\u6b3e\u65f6\u95f4

         uint256 PendingRevenue;//\u5f85\u6536\u76ca

         uint256 dayRevenue;//\u65e5\u6536\u76ca

     }



    /* This creates an array with all balances */

    mapping (address=>MinUser) public MinUsers;

    mapping (address=>uint256) public locking;//\u9501\u5b9a

    mapping (address => uint256) public balanceOf;

  mapping (address => uint256) public freezeOf;

    mapping (address => mapping (address => uint256)) public allowance;



    /* This generates a public event on the blockchain that will notify clients */

    event Transfer(address indexed from, address indexed to, uint256 value);



    /* This notifies clients about the amount burnt */

    event Burn(address indexed from, uint256 value);

  

  /* This notifies clients about the amount frozen */

    event Freeze(address indexed from, uint256 value);

  

  /* This notifies clients about the amount unfrozen */

    event Unfreeze(address indexed from, uint256 value);



    /* Initializes contract with initial supply tokens to the creator of the contract */

    function bitbeb(

        uint256 initialSupply,

        string tokenName,

        uint8 decimalUnits,

        string tokenSymbol,

        address _tokenAddress

        ) {

        name = tokenName; // Set the name for display purposes

        symbol = tokenSymbol; // Set the symbol for display purposes

        decimals = decimalUnits;  

        totalSupply = initialSupply * 10 ** uint256(decimals);

        balanceOf[address(this)] = totalSupply;  // Amount of decimals for display purposes

    owner = msg.sender;

    bebTokenTransfer = tokenTransfer(_tokenAddress);

    RiseTime=1578725653;//BEB\u4ef7\u683c\u521d\u59cb\u5316\u5f00\u59cb\u4e0a\u6da8\u65f6\u95f4

    BebAirdrop=388* 10 ** uint256(decimals);//\u521d\u59cb\u7a7a\u6295388BEB

    BEBPrice=166600000000000;//\u521d\u59cb\u4ef7\u683c0.0001666 ETH

    exchangeRate=6002;

    attenuation=5;

    TimeDay=86400;

    }



    /* Send coins */

    function transfer(address _to, uint256 _value) {

        require(locking[msg.sender]==0,"Please activate on the website www.exbeb.com");

        if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead

    if (_value <= 0) throw; 

        if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough

        if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows

        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender

        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient

        Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place

    }

    /* Allow another contract to spend some tokens in your behalf */

    function approve(address _spender, uint256 _value)

        returns (bool success) {

    if (_value <= 0) throw; 

        allowance[msg.sender][_spender] = _value;

        return true;

    }

       



    /* A contract attempts to get the coins */

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {

        require(locking[msg.sender]==0,"Please activate on the website www.exbeb.com");

        if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead

    if (_value <= 0) throw; 

        if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough

        if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows

        if (_value > allowance[_from][msg.sender]) throw;     // Check allowance

        balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender

        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient

        allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);

        Transfer(_from, _to, _value);

        return true;

    }



    function burn(uint256 _value) returns (bool success) {

        if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough

    if (_value <= 0) throw; 

        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender

        totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply

        Burn(msg.sender, _value);

        return true;

    }

  

  function freeze(uint256 _value) returns (bool success) {

      require(locking[msg.sender]==0,"Please activate on the website www.exbeb.com");

        if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough

    if (_value <= 0) throw; 

        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender

        freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply

        Freeze(msg.sender, _value);

        return true;

    }

  

  function unfreeze(uint256 _value) returns (bool success) {

      require(locking[msg.sender]==0,"Please activate on the website www.exbeb.com");

        if (freezeOf[msg.sender] < _value) throw;            // Check if the sender has enough

    if (_value <= 0) throw; 

        freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender

    balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);

        Unfreeze(msg.sender, _value);

        return true;

    }

    //\u4ee5\u4e0b\u662f\u77ff\u673a\u51fd\u6570

    function IntoBebMiner(uint256 _value)public{

        if(_value<=0)throw;

        require(_value>=1 ether*exchangeRate,"BEB The sum is too small");

        MinUser storage _user=MinUsers[msg.sender];

        if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough

        uint256 _miner=SafeMath.safeDiv(_value,exchangeRate);

        balanceOf[msg.sender]=SafeMath.safeSub(balanceOf[msg.sender], _value);

        if(locking[msg.sender]>0){

           if(locking[msg.sender]==1){

            uint256 _shouyi=SafeMath.safeDiv(24000 ether,TotalMachine);

            uint256 _time=SafeMath.safeSub(now, _user.WithdrawalTime);//\u8ba1\u7b97\u51fa\u65f6\u95f4

            uint256 _days=_time/TimeDay;

            if(_days>0){

                uint256 _sumshouyi=SafeMath.safeMul(1000000000000000000,_shouyi);

                uint256 _BEBsumshouyi=SafeMath.safeMul(_sumshouyi,_days);

                bebTokenTransfers.transfer(msg.sender,_BEBsumshouyi);

                sumExbeb=SafeMath.safeAdd(sumExbeb,_sumshouyi); 

            }

          }else{

            sumExbeb=SafeMath.safeAdd(sumExbeb,locking[msg.sender]); 

            //AirdropjieDong=SafeMath.safeAdd(AirdropjieDong,locking[msg.sender]);//\u7a7a\u6295\u89e3\u51bb

            locking[msg.sender]=0;

          }   

        }

         _user.MiningMachine=SafeMath.safeAdd(_user.MiningMachine,_miner);

        _user.WithdrawalTime=now;

        locking[msg.sender]=0;

        totalSupply=SafeMath.safeSub(totalSupply, _value);//\u9500\u6bc1

        TotalMachine=SafeMath.safeAdd(TotalMachine,_miner);

        Destruction=SafeMath.safeAdd(Destruction, _value);//\u9500\u6bc1\u6570\u91cf\u589e\u52a0

        sumExbeb=SafeMath.safeSub(sumExbeb,_value);

        Burn(msg.sender, _value);   

    }

    function MinerToBeb()public{

        if(now-RiseTime>TimeDay){

            RiseTime=SafeMath.safeAdd(RiseTime,TimeDay);

            BEBPrice=SafeMath.safeAdd(BEBPrice,660000000000);//\u6bcf\u65e5\u56fa\u5b9a\u4e0a\u6da80.00000066ETH

            AccumulatedDays+=1;//\u8ba1\u7b97BEB\u521b\u59cb\u5929\u6570

            exchangeRate=SafeMath.safeDiv(1 ether,BEBPrice);

        }

        MinUser storage _user=MinUsers[msg.sender];

        if(_user.MiningMachine>1000000000000000000){

            if(locking[msg.sender]>1){

               sumExbeb=SafeMath.safeAdd(sumExbeb,locking[msg.sender]); 

               locking[msg.sender]=0;

            }

        }

        require(_user.MiningMachine>0,"You don't have a miner");

        require(locking[msg.sender]==0,"Please activate on the website www.exbeb.com");

        //\u5224\u65ad\u7528\u6237\u662f\u4e0d\u662f\u514d\u8d39\u77ff\u673a\u6216\u8005\u7a7a\u6295\u7528\u6237\uff0c\u5982\u679c\u662f\u8fd4\u56de\uff0c\u9700\u8981\u8d2d\u4e70\u77ff\u673a\u540e\u89e3\u9501

        uint256 _miners=_user.MiningMachine;

        uint256 _times=SafeMath.safeSub(now, _user.WithdrawalTime);

        require(_times>TimeDay,"No withdrawal for less than 24 hours");

        uint256 _days=SafeMath.safeDiv(_times,TimeDay);//\u8ba1\u7b97\u603b\u5929\u6570

        uint256 _shouyi=SafeMath.safeDiv(240000 ether,TotalMachine);//\u8ba1\u7b97\u6bcf\u53f0\u77ff\u673a\u6bcf\u5929\u6536\u76ca

        uint256 _dayshouyi=SafeMath.safeMul(_miners,_shouyi);

        //uint256 _daysumshouyi=SafeMath.safeDiv(_dayshouyi,1 ether);//\u8ba1\u7b97\u7528\u6237\u6bcf\u5929\u603b\u6536\u76ca

        uint256 _aaaa=SafeMath.safeMul(_dayshouyi,_days);

            uint256 _attenuation=_miners*5/1000*_days;//\u8ba1\u7b97\u6bcf\u5929\u8870\u51cf\u91cf

            bebTokenTransfers.transfer(msg.sender,_aaaa);

           _user.MiningMachine=SafeMath.safeSub( _user.MiningMachine,_attenuation);

           _user.WithdrawalTime=now;

           sumExbeb=SafeMath.safeAdd(sumExbeb,_aaaa);

           TotalMachine=SafeMath.safeSub(TotalMachine,_attenuation);

           _user.amount=SafeMath.safeAdd( _user.amount,_aaaa);

    }

    function FreeMiningMachine()public{

        if(now-RiseTime>TimeDay){

            RiseTime=SafeMath.safeAdd(RiseTime,TimeDay);

            BEBPrice=SafeMath.safeAdd(BEBPrice,660000000000);//\u6bcf\u65e5\u56fa\u5b9a\u4e0a\u6da80.00000066ETH

            AccumulatedDays+=1;//\u8ba1\u7b97BEB\u521b\u59cb\u5929\u6570

            exchangeRate=SafeMath.safeDiv(1 ether,BEBPrice);

        }

        require(locking[msg.sender]==0,"Please activate on the website www.exbeb.com");

        MinUser storage _user=MinUsers[msg.sender];

        require(_user.MiningMachine==0,"I can't get it. You already have a miner");

        //uint256 _miner=1000000000000000000;//0.1ETH

        _user.MiningMachine=SafeMath.safeAdd(_user.MiningMachine,1000000000000000000);//\u589e\u52a00.1\u53f0\u77ff\u673a

        _user.WithdrawalTime=now;

        locking[msg.sender]=1;

    }

    //1.0 BEB\u5151\u6362POS\u77ff\u673a

    function OldBebToMiner(uint256 _value)public{

      if(now<1582591205)throw;

      uint256 _bebminer=SafeMath.safeDiv(_value,exchangeRate);

      if(_bebminer<=0)throw;

      MinUser storage _user=MinUsers[msg.sender];

        bebTokenTransfer.transferFrom(msg.sender,address(this),_value);  

        _user.MiningMachine=SafeMath.safeAdd(_user.MiningMachine,_bebminer);

        _user.WithdrawalTime=now;

        TotalMachine=SafeMath.safeAdd(TotalMachine,_bebminer);

    }

    //\u4e70BEB

    function buyBeb(address _addr) payable public {

        if(now-RiseTime>TimeDay){

            RiseTime=SafeMath.safeAdd(RiseTime,TimeDay);

            BEBPrice=SafeMath.safeAdd(BEBPrice,660000000000);//\u6bcf\u65e5\u56fa\u5b9a\u4e0a\u6da80.00000066ETH

            AccumulatedDays+=1;//\u8ba1\u7b97BEB\u521b\u59cb\u5929\u6570

            exchangeRate=SafeMath.safeDiv(1 ether,BEBPrice);

        }

        uint256 amount = msg.value;

        if(amount<=0)throw;

        uint256 bebamountub=SafeMath.safeMul(amount,exchangeRate);

        //require(bebamountub<=buyTota,"Exceeded the maximum quantity available for sale");

        uint256 _transfer=amount*2/100;

        uint256 _bebtoeth=amount*98/100;

       require(balanceOf[_addr]>=bebamountub,"Sorry, your credit is running low");

       bebTokenTransfers.transferFrom(_addr,msg.sender,bebamountub);

        owner.transfer(_transfer);//\u652f\u4ed82%\u624b\u7eed\u8d39\u7ed9\u9879\u76ee\u65b9

        _addr.transfer(_bebtoeth);

        //sellTota=SafeMath.safeAdd(sellTota,bebamountub);

       // buyTota=SafeMath.safeSub(buyTota,bebamountub);

    }

    // sellbeb-eth

    function sellBeb(uint256 _sellbeb)public {

        if(now-RiseTime>TimeDay){

            RiseTime=SafeMath.safeAdd(RiseTime,TimeDay);

            BEBPrice=SafeMath.safeAdd(BEBPrice,660000000000);//\u6bcf\u65e5\u56fa\u5b9a\u4e0a\u6da80.00000066ETH

            AccumulatedDays+=1;//\u8ba1\u7b97BEB\u521b\u59cb\u5929\u6570

            exchangeRate=SafeMath.safeDiv(1 ether,BEBPrice);

        }

         require(locking[msg.sender]==0,"Please activate on the website www.exbeb.com");

         approve(address(this),_sellbeb);

    }

    //\u7a7a\u6295Airdrop

    function AirdropBeb()public{

        if(now-RiseTime>TimeDay){

            RiseTime=SafeMath.safeAdd(RiseTime,TimeDay);

            BEBPrice=SafeMath.safeAdd(BEBPrice,660000000000);//\u6bcf\u65e5\u56fa\u5b9a\u4e0a\u6da80.00000066ETH

            AccumulatedDays+=1;//\u8ba1\u7b97BEB\u521b\u59cb\u5929\u6570

            exchangeRate=SafeMath.safeDiv(1 ether,BEBPrice);

        }

        MinUser storage _user=MinUsers[msg.sender];

        require(_user.MiningMachine<=0);

        require(locking[msg.sender]==0,"Please activate on the website www.exbeb.com");

        uint256 _airbeb=SafeMath.safeMul(BebAirdrop,166600000000000);

        BebAirdrop=SafeMath.safeDiv(_airbeb,BEBPrice);

        bebTokenTransfers.transfer(msg.sender,BebAirdrop);//\u53d1\u9001BEB

        locking[msg.sender]=BebAirdrop;

        AirdropSum=SafeMath.safeAdd(AirdropSum,BebAirdrop);

    }

    function setAddress(address[] _addr)public{

        if(msg.sender != owner)throw;

        Airdrops=_addr;

    }

    //\u6267\u884c\u7a7a\u6295

    function batchAirdrop()public{

        if(now<1586306405)throw;//2020\u5e744\u67089\u65e5\u524d\u53ef\u4ee5\u4f7f\u7528\u8fd9\u4e2a\u7a7a\u6295\u51fd\u6570

        if(msg.sender != owner)throw;

        for(uint i=0;i<Airdrops.length;i++){

            bebTokenTransfers.transfer(Airdrops[i],BebAirdrop);

            locking[Airdrops[i]]=BebAirdrop;

        }

    }

    //\u589e\u53d1BEB

    function AdditionalIssue(uint256 _value)public{

        if(msg.sender != owner)throw;

        totalSupply += _value * 10 ** uint256(decimals);

        balanceOf[address(this)] += _value * 10 ** uint256(decimals);

        

    }

    //\u521d\u59cb\u5316\u5206\u914d\u77ff\u673a

    function setMiner(address _addr,uint256 _value)public{

        if(msg.sender != owner)throw;

        if(now>1580519056)throw;//2020\u5e741\u670820\u65e5\u4e4b\u540e\u8fd9\u4e2a\u529f\u80fd\u5c31\u4e0d\u80fd\u4f7f\u7528\u4e86

        MinUser storage _user=MinUsers[_addr];

        _user.MiningMachine=_value;

        _user.WithdrawalTime=now;

        TotalMachine+=_value;

    }

    function setBebTokenTransfers(address _addr)public{

        if(msg.sender != owner)throw;

         if(now>1580519056)throw;//2020\u5e741\u670820\u65e5\u4e4b\u540e\u8fd9\u4e2a\u529f\u80fd\u5c31\u4e0d\u80fd\u4f7f\u7528\u4e86

        bebTokenTransfers=tokenTransfers(_addr);

        

    }

    //\u4e2a\u4eba\u67e5\u8be2\u603b\u6536\u76ca\uff0c\u77ff\u673a\u6570\u91cf\uff0c\u53d6\u6b3e\u65f6\u95f4\uff0c\u65e5\u6536\u76ca

    function getUser(address _addr)public view returns(uint256,uint256,uint256,uint256,uint256){

            MinUser storage _user=MinUsers[_addr];

            uint256 edays=240000 ether / TotalMachine;

            uint256 _day=_user.MiningMachine*edays;

         return (_user.amount,_user.MiningMachine,_user.WithdrawalTime,_day,(now-_user.WithdrawalTime)/TimeDay*_day);

    }

    function getQuanju()public view returns(uint256,uint256,uint256,uint256,uint256,uint256){

        //uint256 Destruction;//\u9500\u6bc1\u6570\u91cf

      //uint256 BEBPrice;//\u521d\u59cb\u4ef7\u683c0.00007142ETH

      //uint256 TotalMachine;//\u77ff\u673a\u603b\u91cf

      //uint256 AccumulatedDays;//\u521b\u4e16\u81f3\u4eca\u5929\u6570

      //uint256 sumExbeb;//BEB\u603b\u6d41\u901a

      //uint256 BebAirdrop;//BEB\u6bcf\u6b21\u7a7a\u6295\u6570\u91cf

            

         return (TotalMachine,Destruction,sumExbeb,BEBPrice,AccumulatedDays,BebAirdrop);

    }

    function querBalance()public view returns(uint256){

         return this.balance;

     }

     //\u9879\u76ee\u65b9\u6570\u636e

     function getowner()public view returns(uint256,uint256){ 

         MinUser storage _user=MinUsers[owner];

         return (_user.MiningMachine,balanceOf[owner]);

    }

    //\u4ee5\u4e0a\u662f\u77ff\u673a\u51fd\u6570

  // can accept ether

  function() payable {

    }

}

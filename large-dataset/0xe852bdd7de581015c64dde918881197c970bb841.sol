pragma solidity^0.4.20;  

//\u5b9e\u4f8b\u5316\u4ee3\u5e01

interface tokenTransfer {

    function transfer(address receiver, uint amount);

    function transferFrom(address _from, address _to, uint256 _value);

    function balanceOf(address receiver) returns(uint256);

}



contract Ownable {

  address public owner;

  bool lock = false;

 

 

    /**

     * \u521d\u53f0\u5316\u6784\u9020\u51fd\u6570

     */

    function Ownable () public {

        owner = msg.sender;

    }

 

    /**

     * \u5224\u65ad\u5f53\u524d\u5408\u7ea6\u8c03\u7528\u8005\u662f\u5426\u662f\u5408\u7ea6\u7684\u6240\u6709\u8005

     */

    modifier onlyOwner {

        require (msg.sender == owner);

        _;

    }

 

    /**

     * \u5408\u7ea6\u7684\u6240\u6709\u8005\u6307\u6d3e\u4e00\u4e2a\u65b0\u7684\u7ba1\u7406\u5458

     * @param  newOwner address \u65b0\u7684\u7ba1\u7406\u5458\u5e10\u6237\u5730\u5740

     */

    function transferOwnership(address newOwner) onlyOwner public {

        if (newOwner != address(0)) {

        owner = newOwner;

      }

    }

}



contract BebPos is Ownable{



    //\u4f1a\u5458\u6570\u636e\u7ed3\u6784

   struct BebUser {

        address customerAddr;//\u4f1a\u5458address

        uint256 amount; //\u5b58\u6b3e\u91d1\u989d 

        uint256 bebtime;//\u5b58\u6b3e\u65f6\u95f4

        //uint256 interest;//\u5229\u606f

    }

    uint256 Bebamount;//BEB\u672a\u53d1\u884c\u6570\u91cf

    uint256 bebTotalAmount;//BEB\u603b\u91cf

    uint256 sumAmount = 0;//\u4f1a\u5458\u7684\u603b\u91cf 

    uint256 OneMinuteBEB;//\u521d\u59cb\u53161\u5206\u949f\u4ea7\u751fBEB\u6570\u91cf

    tokenTransfer public bebTokenTransfer; //\u4ee3\u5e01 

    uint8 decimals = 18;

    uint256 OneMinute=1 minutes; //1\u5206\u949f

    //\u4f1a\u5458 \u7ed3\u6784 

    mapping(address=>BebUser)public BebUsers;

    address[] BebUserArray;//\u5b58\u6b3e\u7684\u5730\u5740\u6570\u7ec4

    //\u4e8b\u4ef6

    event messageBetsGame(address sender,bool isScuccess,string message);

    //BEB\u7684\u5408\u7ea6\u5730\u5740 

    function BebPos(address _tokenAddress,uint256 _Bebamount,uint256 _bebTotalAmount,uint256 _OneMinuteBEB){

         bebTokenTransfer = tokenTransfer(_tokenAddress);

         Bebamount=_Bebamount*10**18;//\u521d\u59cb\u8bbe\u5b9a\u4e3a\u53d1\u884c\u6570\u91cf

         bebTotalAmount=_bebTotalAmount*10**18;//\u521d\u59cb\u8bbe\u5b9aBEB\u603b\u91cf

         OneMinuteBEB=_OneMinuteBEB*10**18;//\u521d\u59cb\u53161\u5206\u949f\u4ea7\u751fBEB\u6570\u91cf 

         BebUserArray.push(_tokenAddress);

     }

         //\u5b58\u5165 BEB

    function freeze(uint256 _value,address _addr) public{

        //\u5224\u65ad\u4f1a\u5458\u5b58\u6b3e\u91d1\u989d\u662f\u5426\u7b49\u4e8e0

       if(BebUsers[msg.sender].amount == 0){

           //\u5224\u65ad\u672a\u53d1\u884c\u6570\u91cf\u662f\u5426\u5927\u4e8e20\u4e2aBEB

           if(Bebamount > OneMinuteBEB){

           bebTokenTransfer.transferFrom(_addr,address(address(this)),_value);//\u5b58\u5165BEB

           BebUsers[_addr].customerAddr=_addr;

           BebUsers[_addr].amount=_value;

           BebUsers[_addr].bebtime=now;

           sumAmount+=_value;//\u603b\u5b58\u6b3e\u589e\u52a0

           //\u52a0\u5165\u5b58\u6b3e\u6570\u7ec4\u5730\u5740

           //addToAddress(msg.sender);//\u52a0\u5165\u5b58\u6b3e\u6570\u7ec4\u5730\u5740

           messageBetsGame(msg.sender, true,"\u8f6c\u5165\u6210\u529f");

            return;   

           }

           else{

            messageBetsGame(msg.sender, true,"\u8f6c\u5165\u5931\u8d25,BEB\u603b\u91cf\u5df2\u7ecf\u5168\u90e8\u53d1\u884c\u5b8c\u6bd5");

            return;   

           }

       }else{

            messageBetsGame(msg.sender, true,"\u8f6c\u5165\u5931\u8d25,\u8bf7\u5148\u53d6\u51fa\u5408\u7ea6\u4e2d\u7684\u4f59\u989d");

            return;

       }

    }



    //\u53d6\u6b3e

    function unfreeze(address referral) public {

        address _address = msg.sender;

        BebUser storage user = BebUsers[_address];

        require(user.amount > 0);

        //

        uint256 _time=user.bebtime;//\u5b58\u6b3e\u65f6\u95f4

        uint256 _amuont=user.amount;//\u4e2a\u4eba\u5b58\u6b3e\u91d1\u989d

           uint256 AA=(now-_time)/OneMinute*OneMinuteBEB;//\u73b0\u5728\u65f6\u95f4-\u5b58\u6b3e\u65f6\u95f4/60\u79d2*\u6bcf\u5206\u949f\u751f\u4ea720BEB

           uint256 BB=bebTotalAmount-Bebamount;//\u8ba1\u7b97\u51fa\u5df2\u6d41\u901a\u6570\u91cf

           uint256 CC=_amuont*AA/BB;//\u5b58\u6b3e*AA/\u5df2\u6d41\u901a\u6570\u91cf

           //\u5224\u65ad\u672a\u53d1\u884c\u6570\u91cf\u662f\u5426\u5927\u4e8e20BEB

           if(Bebamount > OneMinuteBEB){

              Bebamount-=CC; 

             //user.interest+=CC;//\u5411\u8d26\u6237\u589e\u52a0\u5229\u606f

             user.bebtime=now;//\u91cd\u7f6e\u5b58\u6b3e\u65f6\u95f4\u4e3a\u73b0\u5728

           }

        //\u5224\u65ad\u672a\u53d1\u884c\u6570\u91cf\u662f\u5426\u5927\u4e8e20\u4e2aBEB

        if(Bebamount > OneMinuteBEB){

            Bebamount-=CC;//\u4ece\u53d1\u884c\u603b\u91cf\u5f53\u4e2d\u51cf\u5c11

            sumAmount-=_amuont;

            bebTokenTransfer.transfer(msg.sender,CC+user.amount);//\u8f6c\u8d26\u7ed9\u4f1a\u5458 + \u4f1a\u5458\u672c\u91d1+\u5f53\u524d\u5229\u606f 

           //\u66f4\u65b0\u6570\u636e 

            BebUsers[_address].amount=0;//\u4f1a\u5458\u5b58\u6b3e0

            BebUsers[_address].bebtime=0;//\u4f1a\u5458\u5b58\u6b3e\u65f6\u95f40

            //BebUsers[_address].interest=0;//\u5229\u606f\u5f520

            messageBetsGame(_address, true,"\u672c\u91d1\u548c\u5229\u606f\u6210\u529f\u53d6\u6b3e");

            return;

        }

        else{

            Bebamount-=CC;//\u4ece\u53d1\u884c\u603b\u91cf\u5f53\u4e2d\u51cf\u5c11

            sumAmount-=_amuont;

            bebTokenTransfer.transfer(msg.sender,_amuont);//\u8f6c\u8d26\u7ed9\u4f1a\u5458 + \u4f1a\u5458\u672c\u91d1 

           //\u66f4\u65b0\u6570\u636e 

            BebUsers[_address].amount=0;//\u4f1a\u5458\u5b58\u6b3e0

            BebUsers[_address].bebtime=0;//\u4f1a\u5458\u5b58\u6b3e\u65f6\u95f40

            //BebUsers[_address].interest=0;//\u5229\u606f\u5f520

            messageBetsGame(_address, true,"BEB\u603b\u91cf\u5df2\u7ecf\u53d1\u884c\u5b8c\u6bd5\uff0c\u53d6\u56de\u672c\u91d1");

            return;  

        }

    }

    function getTokenBalance() public view returns(uint256){

         return bebTokenTransfer.balanceOf(address(this));

    }

    function getSumAmount() public view returns(uint256){

        return sumAmount;

    }

    function getBebAmount() public view returns(uint256){

        return Bebamount;

    }

    function getBebAmountzl() public view returns(uint256){

        uint256 _sumAmount=bebTotalAmount-Bebamount;

        return _sumAmount;

    }



    function getLength() public view returns(uint256){

        return (BebUserArray.length);

    }

     function getUserProfit(address _form) public view returns(address,uint256,uint256,uint256){

       address _address = _form;

       BebUser storage user = BebUsers[_address];

       assert(user.amount > 0);

       uint256 A=(now-user.bebtime)/OneMinute*OneMinuteBEB;

       uint256 B=bebTotalAmount-Bebamount;

       uint256 C=user.amount*A/B;

        return (_address,user.bebtime,user.amount,C);

    }

    function()payable{

        

    }

}

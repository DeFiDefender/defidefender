/**

 *Submitted for verification at Etherscan.io on 2019-09-09

 * BEB dapp for www.betbeb.com

*/

pragma solidity^0.4.24;  

interface tokenTransfer {

    function transfer(address receiver, uint amount);

    function transferFrom(address _from, address _to, uint256 _value);

    function balanceOf(address receiver) returns(uint256);

}

interface tokenTransferUSDT {

    function transfer(address receiver, uint amount);

    function transferFrom(address _from, address _to, uint256 _value);

    function balances(address receiver) returns(uint256);

}

interface tokenTransferBET {

    function transfer(address receiver, uint amount);

    function transferFrom(address _from, address _to, uint256 _value);

    function balanceOf(address receiver) returns(uint256);

}

contract SafeMath {

      address public owner;

       

  function SafeMath () public {

        owner = msg.sender;

    }

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

    modifier onlyOwner {

        require (msg.sender == owner);

        _;

    }

    function transferOwnership(address newOwner) onlyOwner public {

        if (newOwner != address(0)) {

        owner = newOwner;

      }

    }

}

contract bebBUYtwo is SafeMath{

tokenTransfer public bebTokenTransfer; //\u4ee3\u5e01 

tokenTransferUSDT public bebTokenTransferUSDT;

tokenTransferBET public bebTokenTransferBET;

    uint8 decimals;

    uint256 bebethex;//eth-beb

    uint256 BEBday;

    uint256 bebjiage;

    uint256 bebtime;

    uint256 usdtex;

    address ownerstoex;

    uint256 ProfitSUMBEB;

    uint256 SUMdeposit;

    uint256 SUMWithdraw;

    uint256 USDTdeposit;

    uint256 USDTWithdraw;

    uint256 BEBzanchen;//\u8d5e\u6210\u603b\u91cf

    uint256 BEBfandui;//\u53cd\u5bf9\u603b\u91cf

    address shenqingzhichu;//\u7533\u8bf7\u4eba\u5730\u5740

    uint256 shenqingAmount;//\u7533\u8bf7\u91d1\u989d

    uint256 huobileixing;//\u8d27\u5e01\u7c7b\u578b1=ETH\uff0c2=BEB\uff0c3=USDT

    string purpose;//\u7528\u9014

    bool KAIGUAN;//\u8868\u51b3\u5f00\u5173

    string boody;//\u662f\u5426\u901a\u8fc7

    uint256 buyOrSell;

    struct BEBuser{

        uint256 amount;

        uint256 dayamount;//\u6bcf\u5929

        uint256 bebdays;//\u5929\u6570

        uint256 usertime;//\u65f6\u95f4

        uint256 zhiyaBEB;

        uint256 sumProfit;

        uint256 amounts;

        bool vote;

    }

    struct USDTuser{

        uint256 amount;

        uint256 dayamount;//\u6bcf\u5929

        uint256 bebdays;//\u5929\u6570

        uint256 usertime;//\u65f6\u95f4

        uint256 zhiyaBEB;

        uint256 sumProfit;

    }

    mapping(address=>uint256)public buybebs;

    mapping(address=>USDTuser)public USDTusers;

    mapping(address=>BEBuser)public BEBusers;

    function bebBUYtwo(address _tokenAddress,address _usdtadderss,address _BETadderss,address _addr){

         bebTokenTransfer = tokenTransfer(_tokenAddress);

         bebTokenTransferUSDT =tokenTransferUSDT(_usdtadderss);

         bebTokenTransferBET =tokenTransferBET(_BETadderss);

         ownerstoex=_addr;

         bebethex=5623;

         decimals=18;

         BEBday=20;

         bebjiage=178480000000000;

         bebtime=now;

         usdtex=170;

     }

     //USDT

      function setUSDT(uint256 _value) public{

         require(_value>=10000000);

         uint256 _valueToBEB=SafeMath.safeDiv(_value,1000000);

         uint256 _valueToBEBs=_valueToBEB*10**18;

         uint256 _usdts=SafeMath.safeMul(_value,120);//100;

         uint256 _usdt=SafeMath.safeDiv(_usdts,100);//100;

         uint256 _bebex=SafeMath.safeMul(bebjiage,usdtex);

         uint256 _usdtexs=SafeMath.safeDiv(1000000000000000000,_bebex);

         uint256 _usdtex=SafeMath.safeMul(_usdtexs,_valueToBEBs);

         USDTuser storage _user=USDTusers[msg.sender];

         require(_user.amount==0,"Already invested ");

         bebTokenTransferUSDT.transferFrom(msg.sender,address(this),_value);

         bebTokenTransfer.transferFrom(msg.sender,address(this),_usdtex);

         _user.zhiyaBEB=_usdtex;

         _user.amount=_value;

         _user.dayamount=SafeMath.safeDiv(_usdt,BEBday);

         _user.usertime=now;

         _user.sumProfit+=_value*20/100;

         ProfitSUMBEB+=_usdtex*10/100;

         USDTdeposit+=_value;

         

     }

     function setETH()payable public{

         require(msg.value>=500000000000000000);

         uint256 _eths=SafeMath.safeMul(msg.value,120);

         uint256 _eth=SafeMath.safeDiv(_eths,100);

         uint256 _beb=SafeMath.safeMul(msg.value,bebethex);

         BEBuser storage _user=BEBusers[msg.sender];

         require(_user.amount==0,"Already invested ");

         bebTokenTransfer.transferFrom(msg.sender,address(this),_beb);

         _user.zhiyaBEB=_beb;

         _user.amount=msg.value;

         _user.dayamount=SafeMath.safeDiv(_eth,BEBday);

         _user.usertime=now;

         _user.sumProfit+=msg.value*20/100;

         ProfitSUMBEB+=_beb*10/100;

         SUMdeposit+=msg.value;

         

     }

     function DayQuKuan()public{

         if(now-bebtime>86400){

            bebtime+=86400;

            bebjiage+=660000000000;//\u6bcf\u65e5\u56fa\u5b9a\u4e0a\u6da80.00000066ETH

            bebethex=1 ether/bebjiage;

        }

        BEBuser storage _users=BEBusers[msg.sender];

        uint256 _eths=_users.dayamount;

        require(_eths>0,"You didn't invest");

        require(_users.bebdays<BEBday,"Expired");

        uint256 _time=(now-_users.usertime)/86400;

        require(_time>=1,"Less than a day");

        uint256 _ddaayy=_users.bebdays+1;

        if(BEBday==20){

        msg.sender.transfer(_users.dayamount);

        SUMWithdraw+=_users.dayamount;

        _users.bebdays=_ddaayy;

        _users.usertime+=86400;

        if(_ddaayy==BEBday){

        uint256 _bebs=_users.zhiyaBEB*90/100;

         bebTokenTransfer.transfer(msg.sender,_bebs);

         _users.amount=0;

         _users.dayamount=0;

          _users.bebdays=0;

          _users.zhiyaBEB=0;

        }

        }else{

         uint256 _values=SafeMath.safeDiv(_users.zhiyaBEB,BEBday);

         bebTokenTransfer.transfer(msg.sender,_values);

        _users.bebdays=_ddaayy;

        _users.usertime+=86400;

        if(_ddaayy==BEBday){

         uint256 _bebss=_users.zhiyaBEB*90/100;

         bebTokenTransfer.transfer(msg.sender,_bebss);

         _users.amount=0;

         _users.dayamount=0;

          _users.bebdays=0;

          _users.zhiyaBEB=0;

        }   

        }

        

     }

     function DayQuKuanUsdt()public{

         if(now-bebtime>86400){

            bebtime+=86400;

            bebjiage+=660000000000;//\u6bcf\u65e5\u56fa\u5b9a\u4e0a\u6da80.00000066ETH

            bebethex=1 ether/bebjiage;

        }

        USDTuser storage _users=USDTusers[msg.sender];

        uint256 _eths=_users.dayamount;

        require(_eths>0,"You didn't invest");

        require(_users.bebdays<BEBday,"Expired");

        uint256 _time=(now-_users.usertime)/86400;

        require(_time>=1,"Less than a day");

        uint256 _ddaayy=_users.bebdays+1;

        if(BEBday==20){

        bebTokenTransferUSDT.transfer(msg.sender,_eths);

        USDTWithdraw+=_eths;

        _users.bebdays=_ddaayy;

        _users.usertime+=86400;

        if(_ddaayy==BEBday){

        uint256 _bebs=_users.zhiyaBEB*90/100;

         bebTokenTransfer.transfer(msg.sender,_bebs);

         _users.amount=0;

         _users.dayamount=0;

          _users.bebdays=0;

          _users.zhiyaBEB=0;

        }

        }else{

         uint256 _values=SafeMath.safeDiv(_users.zhiyaBEB,BEBday);

         bebTokenTransfer.transfer(msg.sender,_values);

        _users.bebdays=_ddaayy;

        _users.usertime+=86400;

        if(_ddaayy==BEBday){

         uint256 _bebss=_users.zhiyaBEB*90/100;

         bebTokenTransfer.transfer(msg.sender,_bebss);

         _users.amount=0;

         _users.dayamount=0;

          _users.bebdays=0;

          _users.zhiyaBEB=0;

        }   

        }

        

     }

     //\u7533\u8bf7\u652f\u51fa

     function ChaiwuzhiChu(address _addr,uint256 _values,uint256 _leixing,string _purpose)public{

         require(!KAIGUAN,"The last round of voting is not over");

         require(getTokenBalanceBET(address(this))<1,"And bet didn't get it back");

         uint256 _value=getTokenBalanceBET(msg.sender);//BET\u6301\u6709\u6570\u91cf

        require(_value>=1 ether,"You have no right to apply");

         KAIGUAN=true;//\u5f00\u59cb\u6295\u7968

         shenqingzhichu=_addr;//\u7533\u8bf7\u4eba\u5730\u5740

         if(_leixing==3){

            uint256 _usdts= SafeMath.safeDiv(_values,1000000000000000000);

            uint256 _usdttozhichu=_usdts*1000000;

            shenqingAmount=_usdttozhichu;

         }else{

           shenqingAmount=_values;//\u7533\u8bf7\u652f\u51fa\u91d1\u989d

         }

         huobileixing=_leixing;//1=eth,2=BEB,3=USDT

         purpose=_purpose;

         boody="\u6295\u7968\u4e2d...";

     }

     //\u6295\u7968\u8d5e\u6210

    function setVoteZancheng()public{

        BEBuser storage _user=BEBusers[msg.sender];

        require(KAIGUAN);

        uint256 _value=getTokenBalanceBET(msg.sender);//BET\u6301\u6709\u6570\u91cf

        require(_value>=1 ether,"You have no right to vote");

        require(!_user.vote,"You have voted");

        bebTokenTransferBET.transferFrom(msg.sender,address(this),_value);//\u8f6c\u5165BET

        BEBzanchen+=_value;//\u8d5e\u6210\u589e\u52a0

        _user.amounts=_value;//\u8d4b\u503c

        _user.vote=true;//\u8d4b\u503c\u5df2\u7ecf\u6295\u7968

        if(BEBzanchen>=51 ether){

            //\u6295\u7968\u901a\u8fc7\u6267\u884c\u8d22\u52a1\u652f\u51fa

            if(huobileixing!=0){

                if(huobileixing==1){

                 shenqingzhichu.transfer(shenqingAmount);//\u652f\u51faETH

                 KAIGUAN=false;

                 BEBfandui=0;//\u7968\u6570\u5f52\u96f6

                 BEBzanchen=0;//\u7968\u6570\u5f52\u96f6

                 huobileixing=0;//\u64a4\u9500\u672c\u6b21\u7533\u8bf7

                 boody="\u901a\u8fc7";

                 //shenqingzhichu=0;//\u64a4\u9500\u5730\u5740

                 //shenqingAmount=0;//\u64a4\u9500\u7533\u8bf7\u91d1\u989d

                }else{

                    if(huobileixing==2){

                      bebTokenTransfer.transfer(shenqingzhichu,shenqingAmount);//\u652f\u51faBEB

                      KAIGUAN=false;

                      BEBfandui=0;//\u7968\u6570\u5f52\u96f6

                      BEBzanchen=0;//\u7968\u6570\u5f52\u96f6

                      huobileixing=0;//\u64a4\u9500\u672c\u6b21\u7533\u8bf7

                      boody="\u901a\u8fc7";

                    }else{

                        bebTokenTransferUSDT.transfer(shenqingzhichu,shenqingAmount);//\u652f\u51faUSDT

                        KAIGUAN=false;

                        BEBfandui=0;//\u7968\u6570\u5f52\u96f6

                        BEBzanchen=0;//\u7968\u6570\u5f52\u96f6

                        huobileixing=0;//\u64a4\u9500\u672c\u6b21\u7533\u8bf7

                        boody="\u901a\u8fc7";

                    }          

                 }

            }

        }

    }

    //\u6295\u7968\u53cd\u5bf9

    function setVoteFandui()public{

        require(KAIGUAN);

        BEBuser storage _user=BEBusers[msg.sender];

        uint256 _value=getTokenBalanceBET(msg.sender);

        require(_value>=1 ether,"You have no right to vote");

        require(!_user.vote,"You have voted");

        bebTokenTransferBET.transferFrom(msg.sender,address(this),_value);//\u8f6c\u5165BET

        BEBfandui+=_value;//\u8d5e\u6210\u589e\u52a0

        _user.amounts=_value;//\u8d4b\u503c

        _user.vote=true;//\u8d4b\u503c\u5df2\u7ecf\u6295\u7968

        if(BEBfandui>=51 ether){

            //\u53cd\u5bf9\u5927\u4e8e51%\u8868\u51b3\u4e0d\u901a\u8fc7

            BEBfandui=0;//\u7968\u6570\u5f52\u96f6

            BEBzanchen=0;//\u7968\u6570\u5f52\u96f6

            huobileixing=0;//\u64a4\u9500\u672c\u6b21\u7533\u8bf7

            shenqingzhichu=0;//\u64a4\u9500\u5730\u5740

            shenqingAmount=0;//\u64a4\u9500\u7533\u8bf7\u91d1\u989d

            KAIGUAN=false;

            boody="\u62d2\u7edd";

        }

    }

    //\u53d6\u56deBET

     function quhuiBET()public{

        require(!KAIGUAN,"Bet cannot be retrieved while voting is in progress");

        BEBuser storage _user=BEBusers[msg.sender];

        require(_user.vote,"You did not vote");

        bebTokenTransferBET.transfer(msg.sender,_user.amounts);//\u9000\u56deBET

        _user.vote=false;

        _user.amounts=0;

     }

     function buybeb()payable public{

        uint256 _amount=msg.value;

        uint256 _buybeb=SafeMath.safeMul(_amount,bebethex);

        require(_buybeb<=ProfitSUMBEB);

        bebTokenTransfer.transfer(msg.sender,_buybeb);//\u652f\u51faBEB

        buybebs[msg.sender]+=_buybeb;

        buyOrSell+=_buybeb;

        ProfitSUMBEB-=_buybeb;

     }

     function sellbeb(uint256 _value) public{

         require(_value>bebethex);

         require(buybebs[msg.sender]>=_value,"Sorry, your credit is running low");

        uint256 _sellbeb=SafeMath.safeDiv(_value,bebethex);

        uint256 _selleth=_sellbeb*95/100;

        bebTokenTransfer.transferFrom(msg.sender,address(this),_value);

        msg.sender.transfer(_selleth);

        buybebs[msg.sender]-=_value;

        buyOrSell-=_selleth;

        ProfitSUMBEB+=_value;

     }

     function setBEB(uint256 _value)public{

         require(_value>0);

         bebTokenTransfer.transferFrom(msg.sender,address(this),_value);

         ProfitSUMBEB+=_value;

     }

     function setusdtex(uint256 _value)public{

         require(ownerstoex==msg.sender);

         usdtex=_value;

     }

     function setETHS()payable onlyOwner{

         SUMdeposit+=msg.value;

     }

     function setUSDTS(uint256 _value)onlyOwner{

         bebTokenTransferUSDT.transferFrom(msg.sender,address(this),_value);

         USDTdeposit+=_value;

     }

     function querBalance()public view returns(uint256){

         return this.balance;

     }

    function getTokenBalance() public view returns(uint256){

         return bebTokenTransfer.balanceOf(address(this));

    }

    function getTokenBalanceUSDT() public view returns(uint256){

         return bebTokenTransferUSDT.balances(address(this));

    }

    function BETwithdrawal(uint256 amount)onlyOwner {

      bebTokenTransferBET.transfer(msg.sender,amount);

    }

    function setBEBday(uint256 _BEBday)onlyOwner{

        BEBday=_BEBday;

    }

    function setusersUSDT(address _addr)onlyOwner{

       USDTuser storage _user=USDTusers[_addr];

       _user.amount=0;

       _user.dayamount=0;

       _user.bebdays=0;

       _user.usertime=0;

       _user.zhiyaBEB=0;

       _user.sumProfit=0;

        

    }

    function setusersETH(address _addr)onlyOwner{

       BEBuser storage _user=BEBusers[_addr];

       _user.amount=0;

       _user.dayamount=0;

       _user.bebdays=0;

       _user.usertime=0;

       _user.zhiyaBEB=0;

       _user.sumProfit=0;

        

    }

    function getuserBuybebs() public view returns(uint256){

         return buybebs[msg.sender];

    }

    function getTokenBalanceBET(address _addr) public view returns(uint256){

         return bebTokenTransferBET.balanceOf(_addr);

    }

    function getQuanju()public view returns(uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256){

            

         return (bebjiage,bebethex,ProfitSUMBEB,SUMdeposit,SUMWithdraw,USDTdeposit,USDTWithdraw,buyOrSell,usdtex);

    }

    function getUSDTuser(address _addr)public view returns(uint256,uint256,uint256,uint256,uint256,uint256){

            USDTuser storage _users=USDTusers[_addr];

            //uint256 amount;//USDT\u603b\u6295\u8d44

        //uint256 dayamount;//\u6bcf\u5929\u56de\u672c\u606f

        //uint256 bebdays;//\u56de\u6b3e\u5929\u6570

        //uint256 usertime;//\u4e0a\u4e00\u6b21\u53d6\u6b3e\u65f6\u95f4

        //uint256 zhiyaBEB;\u8d28\u62bcBEB\u6570\u91cf

        //uint256 sumProfit;\u603b\u6536\u76ca

         return (_users.amount,_users.dayamount,_users.bebdays,_users.usertime,_users.zhiyaBEB,_users.sumProfit);

    }

    function getBEBuser(address _addr)public view returns(uint256,uint256,uint256,uint256,uint256,uint256,uint256,bool){

            BEBuser storage _users=BEBusers[_addr];

            //uint256 amount;//\u6295\u8d44\u91d1\u989d

            //uint256 dayamount;//\u6bcf\u5929\u56de\u672c\u606f

            //uint256 bebdays;//\u56de\u6b3e\u5929\u6570

            //uint256 usertime;//\u4e0a\u4e00\u6b21\u53d6\u6b3e\u65f6\u95f4

            //uint256 zhiyaBEB;//\u8d28\u62bcBEB\u6570\u91cf

            //uint256 sumProfit;//\u603b\u6536\u76ca

            // uint256 amounts;//\u6295\u7968BET\u6570\u91cf

           //bool vote;//\u662f\u5426\u6295\u7968

         return (_users.amount,_users.dayamount,_users.bebdays,_users.usertime,_users.zhiyaBEB,_users.sumProfit,_users.amounts,_users.vote);

    }

    function getBETvote()public view returns(uint256,uint256,address,uint256,uint256,string,bool,string){

            //uint256 BEBzanchen;//\u8d5e\u6210\u603b\u91cf

    //uint256 BEBfandui;//\u53cd\u5bf9\u603b\u91cf

    //address shenqingzhichu;//\u7533\u8bf7\u4eba\u5730\u5740

    //uint256 shenqingAmount;//\u7533\u8bf7\u91d1\u989d

    //uint256 huobileixing;//\u8d27\u5e01\u7c7b\u578b1=ETH\uff0c2=BEB\uff0c3=USDT

    //string purpose;//\u7528\u9014

    //bool KAIGUAN;//\u8868\u51b3\u5f00\u5173

    //string boody;//\u662f\u5426\u901a\u8fc7\uff0c\u72b6\u6001

         return (BEBzanchen,BEBfandui,shenqingzhichu,shenqingAmount,huobileixing,purpose,KAIGUAN,boody);

    }

    function getUsdt()public view returns(uint256){

        return usdtex;

    }

    function ()payable{

        

    }

}

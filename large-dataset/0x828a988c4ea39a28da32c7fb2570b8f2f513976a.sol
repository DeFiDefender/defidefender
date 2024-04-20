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



contract Ownable {

  address public owner;

 

    function Ownable () public {

        owner = msg.sender;

    }

 

    modifier onlyOwner {

        require (msg.sender == owner);

        _;

    }

 

    /**

     * @param  newOwner address

     */

    function transferOwnership(address newOwner) onlyOwner public {

        if (newOwner != address(0)) {

        owner = newOwner;

      }

    }

}



contract BebExchang is Ownable{

    uint256 BEBMIN;//\u4e70\u5356\u6700\u5c0f\u6570\u91cf

    uint256 BEBMAX;//\u4e70\u5356\u6700\u5927\u6570\u91cf

    uint256 BEBjiage;//\u6700\u65b0\u4ef7\u683c

    uint256 sellAmount;//\u5356\u51fa\u603b\u91cf

    uint256 buyAmount;//\u4e70\u5165\u603b\u91cf

    uint256 sumAmount;//\u5386\u53f2\u6210\u4ea4\u603b\u91d1\u989d

    struct userSell{

        uint256 amount;//\u603b\u91d1\u989d

        uint256 value;//\u6570\u91cf

        uint256 exbl;//\u6c47\u7387\u6bd4\u4f8b

        bool vote;//\u72b6\u6001

    }

    struct userBuy{

        uint256 amount;//\u603b\u91d1\u989d

        uint256 exbl;//beb-ETH

        uint256 value;//\u6570\u91cf

        bool vote;//\u72b6\u6001

    }

    mapping(address=>userSell)public userSells;

    mapping(address=>userBuy)public userBuys;

    tokenTransfer public bebTokenTransfer; //\u4ee3\u5e01

    function BebExchang(address _tokenAddress){

         bebTokenTransfer = tokenTransfer(_tokenAddress);

     }

     //\u5356\u51fa\u8ba2\u5355\u7684\u53c2\u6570\u4ef7\u683c_amount\u3001_value\u9700\u8981\u4e58\u65b9\u540e\u4f20\u7ed9\u5408\u7ea6

     function sellGD(uint256 _amount,uint256 _value)public{

         require(tx.origin == msg.sender);

         userSell storage _user=userSells[msg.sender];

         require(!_user.vote,"Please cancel the order first.");

         require(_amount>0 & _value,"No 0");

         require( _value>=BEBMIN,"Not less than the lower limit of sale\uff01");

         require( _value<=BEBMAX,"No higher than the sale ceiling\uff01");

         uint256 _exbl=1000000000000000000/_amount;//\u8ba1\u7b97\u6c47\u7387

         uint256 _eth=_value/_exbl;

         bebTokenTransfer.transferFrom(msg.sender,address(this),_value);//\u8f6c\u5165BEB

         _user.amount=_eth;

         _user.value=_value;

         _user.exbl=_exbl;

         _user.vote=true;

     }

     //\u4e70\u5165\u8ba2\u5355\u7684\u53c2\u6570\u4ef7\u683c_amount\u9700\u8981\u4e58\u65b9\u540e\u4f20\u7ed9\u5408\u7ea6

     function BuyGD(uint256 _amount)payable public{

         require(tx.origin == msg.sender);

         userBuy storage _users=userBuys[msg.sender];

         require(!_users.vote,"Please cancel the order first.");

         require(_amount>0,"No 0");

         require( msg.value>0,"Sorry, your credit is running low");

         uint256 _amounts=msg.value;

         uint256 _exbls=1000000000000000000/_amount;//\u8ba1\u7b97\u6c47\u7387

         uint256 bebamount=_amounts*_exbls;

         require( bebamount>=BEBMIN,"Not less than the lower limit of sale\uff01");

         require( bebamount<=BEBMAX,"No higher than the sale ceiling\uff01");

         _users.amount=_amounts;

         _users.exbl=_exbls;

         _users.value=bebamount;

         _users.vote=true;

     }

     //\u5b9e\u65f6\u5356\u51faBEB\uff0c_value\u9700\u8981\u4e58\u65b9\u540e\u4f20\u7ed9\u5408\u7ea6

     function bebToSell(address addr,uint256 _value)public{

         require(tx.origin == msg.sender);

        require(addr != address(0),"Address cannot be empty");

        userBuy storage _user=userBuys[addr];

        require(_user.vote,"The opposite party can't trade without a receipt");

        require(_user.value >= _value,"No more than sellers");

        uint256 _sender=_value/_user.exbl;

        bebTokenTransfer.transferFrom(msg.sender,addr,_value);//\u8f6cBEB\u7ed9\u6536\u8d2d\u65b9

        msg.sender.transfer(_sender);

        BEBjiage=_user.exbl;

        _user.amount-=_sender;//\u9012\u51cf\u5356\u5bb6\u91d1\u989d

        _user.value-=_value;//\u9012\u51cf\u5356\u5bb6BEB\u6570\u91cf

        sellAmount+=_value;

        sumAmount+=_sender;

        if(_user.value==0){

            _user.amount=0;

            _user.exbl=0;

            _user.vote=false;

        }

     }

     //\u5b9e\u65f6\u4e70\u5165BEB

     function buyToBeb(address addr)payable public{

         require(tx.origin == msg.sender);

        require(addr != address(0),"Address cannot be empty");

        require( msg.value>0,"Sorry, your credit is running low");

        userSell storage _user=userSells[addr];

        require(_user.vote,"The opposite party can't trade without a receipt");

        uint256 amounts=msg.value;

        uint256 buyamount=_user.exbl*amounts;

        require(_user.value >= buyamount,"No more than sellers");

        bebTokenTransfer.transfer(msg.sender,buyamount);//\u8f6c\u8d26\u7ed9\u8d2d\u4e70\u65b9

        BEBjiage=_user.exbl;

        addr.transfer(amounts);//\u8f6c\u8d26ETH\u7ed9\u51fa\u552e\u65b9

        _user.amount-=amounts;//\u9012\u51cf\u5356\u5bb6\u91d1\u989d

        _user.value-=buyamount;//\u9012\u51cf\u5356\u5bb6BEB\u6570\u91cf

        buyAmount+=buyamount;

        sumAmount+=amounts;

        if(_user.value==0){

            _user.amount=0;

            _user.exbl=0;

            _user.vote=false;

        }

     }

     //\u64a4\u5356\u5355

     function BebSellCheDan()public{

         require(tx.origin == msg.sender);

        userSell storage _user=userSells[msg.sender];

        require(_user.vote,"You don't have a ticket\uff01");

        bebTokenTransfer.transfer(msg.sender,_user.value);//\u9000\u56deBEB

        _user.value=0;

        _user.amount=0;

        _user.exbl=0;

        _user.vote=false;

     }

     //\u64a4\u4e70\u5355

     function BebBuyCheDan()public{

         require(tx.origin == msg.sender);

        userBuy storage _userS=userBuys[msg.sender];

        require(_userS.vote,"You don't have a ticket\uff01");

        msg.sender.transfer(_userS.amount);//\u9000\u56deeth

        _userS.value=0;

        _userS.amount=0;

        _userS.exbl=0;

        _userS.vote=false; 

     }

     //\u4fee\u6539\u4e70\u5355\u4ef7\u683c\uff0c\u4ef7\u683c\u9700\u8981\u4e58\u65b9\u540e\u4f20\u5165

     function BuyPriceRevision(uint256 _amount)public{

         require(tx.origin == msg.sender);

        userBuy storage _userS=userBuys[msg.sender];

        require(_userS.vote,"You don't have a ticket\uff01");

        uint256 _exbls=1000000000000000000/_amount;//\u8ba1\u7b97\u6c47\u7387

        uint256 _eth=_userS.value/_exbls;

        _userS.amount=_eth;

        _userS.exbl=_exbls;

     }

     //\u4fee\u6539\u4e70\u5355\u4ef7\u683c\uff0c\u4ef7\u683c\u9700\u8981\u4e58\u65b9\u540e\u4f20\u5165

     function SellPriceRevision(uint256 _amount)public{

         require(tx.origin == msg.sender);

        userSell storage _userS=userSells[msg.sender];

        require(_userS.vote,"You don't have a ticket\uff01");

        uint256 _exbls=1000000000000000000/_amount;//\u8ba1\u7b97\u6c47\u7387

        uint256 _eth=_userS.value/_exbls;

        _userS.amount=_eth;

        _userS.exbl=_exbls;

     }

     //\u7ba1\u7406\u5458\u66f4\u6539\u4ea4\u6613\u6570\u91cf\u7684\u4e0a\u9650\u548c\u4e0b\u9650

     function setExchangMINorMAX(uint256 _MIN,uint256 _MAX)onlyOwner{

        BEBMIN=_MIN*10**18;

        BEBMAX=_MAX*10**18;

     }

     //\u6211\u7684\u5356\u51fa\u6302\u5355\u67e5\u8be2

     function MySell(address _addr)public view returns(uint256,uint256,uint256,bool){

         userSell storage _user=userSells[_addr];

        return (_user.amount,_user.value,_user.exbl,_user.vote);

    }

    //\u6211\u7684\u4e70\u5165\u6302\u5355\u67e5\u8be2

    function MyBuy(address _addr)public view returns(uint256,uint256,uint256,bool){

         userBuy storage _user=userBuys[_addr];

         

        return (_user.amount,_user.value,_user.exbl,_user.vote);

    }

    function BEBwithdrawAmount(uint256 amount) onlyOwner {

        uint256 _amount=amount* 10 ** 18;

        bebTokenTransfer.transfer(owner,_amount);//\u539f\u8def\u9000\u56deBEB

    }

    function withdrawEther(uint256 amount) onlyOwner{

    //if(msg.sender != owner)throw;

    owner.transfer(amount);

  }

    //\u4ea4\u6613\u6240\u4ea4\u6613\u6570\u91cf\u7684\u4e0b\u9650\u3001\u4e0a\u9650\u3001\u6700\u65b0\u6210\u4ea4\u4ef7\u683c\u3001\u5356\u51fa\u603b\u91cf\u3001\u4e70\u5165\u603b\u91cf\u3001\u5386\u53f2\u6210\u4ea4\u91d1\u989d

    function ExchangMINorMAX()public view returns(uint256,uint256,uint256,uint256,uint256,uint256){

        return (BEBMIN,BEBMAX,BEBjiage,sellAmount,buyAmount,sumAmount);

    }

    function ()payable{

        

    }

}

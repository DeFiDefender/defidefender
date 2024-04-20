pragma solidity >=0.4.22 <0.6.0;







contract EquityChain 

{

    string public standard = 'https://ecs.cc';

    string public name="\u53bb\u4e2d\u5fc3\u5316\u6743\u76ca\u94fe\u901a\u8bc1\u7cfb\u7edf\uff08Equity Chain System\uff09"; //\u4ee3\u5e01\u540d\u79f0

    string public symbol="ECS"; //\u4ee3\u5e01\u7b26\u53f7

    uint8 public decimals = 18;  //\u4ee3\u5e01\u5355\u4f4d\uff0c\u5c55\u793a\u7684\u5c0f\u6570\u70b9\u540e\u9762\u591a\u5c11\u4e2a0,\u548c\u4ee5\u592a\u5e01\u4e00\u6837\u540e\u9762\u662f\u662f18\u4e2a0

    uint256 public totalSupply=0; //\u4ee3\u5e01\u603b\u91cf

    

    mapping (address => uint256) public balanceOf;

    mapping (address => mapping (address => uint256)) public allowance;

    

    event Transfer(address indexed from, address indexed to, uint256 value);  //\u8f6c\u5e10\u901a\u77e5\u4e8b\u4ef6

    event Burn(address indexed from, uint256 value);  //\u51cf\u53bb\u7528\u6237\u4f59\u989d\u4e8b\u4ef6



    address Old_EquityChain=address(0x0);

    modifier onlyOwner(){

        require(msg.sender==owner);

        _;

    }

    modifier onlyPople(){

         address addr = msg.sender;

        uint codeLength;

        assembly {codeLength := extcodesize(addr)}//\u6267\u884c\u6c47\u7f16\u8bed\u8a00\uff0c\u8fd4\u56deaddr\u4e5f\u5c31\u662f\u8c03\u7528\u8005\u5730\u5740\u7684\u5927\u5c0f

        require(codeLength == 0, "sorry humans only");//\u62b1\u6b49\uff0c\u53ea\u6709\u4eba\u7c7b

        require(tx.origin == msg.sender, "sorry, human only");//\u62b1\u6b49\uff0c\u53ea\u6709\u4eba\u7c7b

        _;

    }

    modifier onlyUnLock(){

        require(msg.sender==owner || msg.sender==Longteng1 || info.is_over_finance==1);

        _;

    }

    /*

    ERC20\u4ee3\u7801

    */

    function _transfer(address _from, address _to, uint256 _value) internal{



      //\u907f\u514d\u8f6c\u5e10\u7684\u5730\u5740\u662f0x0

      require(_to != address(0x0));

      //\u68c0\u67e5\u53d1\u9001\u8005\u662f\u5426\u62e5\u6709\u8db3\u591f\u4f59\u989d

      require(balanceOf[_from] >= _value);

      //\u68c0\u67e5\u662f\u5426\u6ea2\u51fa

      require(balanceOf[_to] + _value > balanceOf[_to]);

      //\u4fdd\u5b58\u6570\u636e\u7528\u4e8e\u540e\u9762\u7684\u5224\u65ad

      uint previousBalances = balanceOf[_from] + balanceOf[_to];

      //\u4ece\u53d1\u9001\u8005\u51cf\u6389\u53d1\u9001\u989d

      balanceOf[_from] -= _value;

      //\u7ed9\u63a5\u6536\u8005\u52a0\u4e0a\u76f8\u540c\u7684\u91cf

      balanceOf[_to] += _value;

      //\u901a\u77e5\u4efb\u4f55\u76d1\u542c\u8be5\u4ea4\u6613\u7684\u5ba2\u6237\u7aef

      emit Transfer(_from, _to, _value);

      //\u5224\u65ad\u4e70\u3001\u5356\u53cc\u65b9\u7684\u6570\u636e\u662f\u5426\u548c\u8f6c\u6362\u524d\u4e00\u81f4

      assert(balanceOf[_from] + balanceOf[_to] == previousBalances);



      //\u589e\u52a0\u4ea4\u6613\u91cf\uff0c\u5224\u65ad\u4ef7\u683c\u662f\u5426\u4e0a\u6da8

      add_price(_value);

      //\u8f6c\u8d26\u7684\u65f6\u5019\uff0c\u5982\u679c\u76ee\u6807\u6ca1\u6ce8\u518c\u8fc7\uff0c\u8fdb\u884c\u6ce8\u518c

      if(st_user[_to].code==0)

      {

          register(_to,st_user[_from].code);

      }

    }

    

    function transfer(address _to, uint256 _value) public {

        _transfer(msg.sender, _to, _value);

    }

    

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){

        //\u68c0\u67e5\u53d1\u9001\u8005\u662f\u5426\u62e5\u6709\u8db3\u591f\u4f59\u989d

        require(_value <= allowance[_from][msg.sender]);   // Check allowance

        //\u51cf\u9664\u53ef\u8f6c\u8d26\u6743\u9650

        allowance[_from][msg.sender] -= _value;



        _transfer(_from, _to, _value);



        return true;

    }

    

    function approve(address _spender, uint256 _value) public returns (bool success){

        allowance[msg.sender][_spender] = _value;

        return true;

    }

    

    /*\u5de5\u5177*/

    function Encryption(uint32 num) internal pure returns(uint32 com_num) {

      require(num>0 && num<=1073741823,"ID\u6700\u5927\u4e0d\u80fd\u8d85\u8fc71073741823");

       uint32 ret=num;

       //\u7b2c\u4e00\u6b65\uff0c\u83b7\u5f97num\u6700\u540e4\u4f4d

       uint32 xor=(num<<24)>>24;

       

       xor=(xor<<24)+(xor<<16)+(xor<<8);

       

       xor=(xor<<2)>>2;

       ret=ret ^ xor;

       ret=ret | 1073741824;

        return (ret);

   }

   //\u4e58\u6cd5

    function safe_mul(uint256 a, uint256 b) internal pure returns (uint256) {

        if (a == 0) {

            return 0;

        }

        uint256 c = a * b;

        assert(c / a == b);

        return c;

    }

//\u9664\u6cd5

    function safe_div(uint256 a, uint256 b) internal pure returns (uint256) {

        // assert(b > 0); // Solidity automatically throws when dividing by 0

        uint256 c = a / b;

        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;

    }

//\u51cf\u6cd5

    function safe_sub(uint256 a, uint256 b) internal pure returns (uint256) {

        assert(b <= a);

        return a - b;

    }

//\u52a0\u6cd5

    function safe_add(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a + b;

        assert(c >= a);

        return c;

    }

    //\u83b7\u5f97\u6bd4\u4f8b\uff08\u767e\u5206\u6bd4\uff09

    function get_scale(uint32 i)internal pure returns(uint32 )    {

        if(i==0)

            return 10;

        else if(i==1)

            return 5;

        else if(i==2)

            return 2;

        else

            return 1;

    }



     //------------------------------------------\u6ce8\u518c------------------------------------

    function register(address addr,uint32 be_code)internal{

        assert(st_by_code[be_code] !=address(0x0) || be_code ==131537862);

        info.pople_count++;//\u4eba\u6570\u589e\u52a0

        uint32 code=Encryption(info.pople_count);

        st_user[addr].code=code;

        st_user[addr].be_code=be_code;

        st_by_code[code]=addr;

    }

    //-------------------------------------------\u7ed3\u7b97\u5229\u606f---------------------------------

    function get_IPC(address ad)internal returns(bool)

    {

        uint256 ivt=(now-st_user[ad].time_of_invest)*IPC;//\u6bcfecs\u79d2\u5229\u606f

        ivt=safe_mul(ivt,st_user[ad].ecs_lock)/(1 ether);//\u8ba1\u7b97\u51fa\u603b\u5171\u5e94\u8be5\u83b7\u5f97\u591a\u5c11\u5229\u606f

        

        if(info.ecs_Interest>=ivt)

        {

            info.ecs_Interest-=ivt;//\u5229\u606f\u603b\u91cf\u51cf\u5c11

            //\u603b\u53d1\u884c\u91cf\u589e\u52a0

            totalSupply=safe_add(totalSupply,ivt);

            balanceOf[ad]=safe_add(balanceOf[ad],ivt);

            st_user[ad].ecs_from_interest=safe_add(st_user[ad].ecs_from_interest,ivt);//\u83b7\u5f97\u7684\u603b\u5229\u606f\u589e\u52a0

            st_user[ad].time_of_invest=now;//\u7ed3\u7b97\u65f6\u95f4

            return true;

        }

        return false;

    }

    //-------------------------------------------\u5355\u4ef7\u4e0a\u6da8----------------------------------

    function add_price(uint256 ecs)internal

    {

        info.ecs_trading_volume=safe_add(info.ecs_trading_volume,ecs);

        if(info.ecs_trading_volume>=500000 ether)//\u5927\u4e8e50\u4e07\u80a1\uff0c\u5355\u4ef7\u4e0a\u6da80.5%

        {

            info.price=info.price*1005/1000;

            info.ecs_trading_volume=0;

        }

    }

    //-------------------------------------------\u53d8\u91cf\u5b9a\u4e49-----------------------------------

    struct USER

    {

        uint32 code;//\u9080\u8bf7\u7801

        uint32 be_code;//\u6211\u7684\u9080\u8bf7\u4eba

        uint256 eth_invest;//\u6211\u7684\u603b\u6295\u8d44

        uint256 time_of_invest;//\u6295\u8d44\u65f6\u95f4

        uint256 ecs_lock;//\u9501\u4ed3ecs

        uint256 ecs_from_recommend;//\u63a8\u8350\u83b7\u5f97\u7684\u603becs

        uint256 ecs_from_interest;//\u5229\u606f\u83b7\u5f97\u7684\u603becs

        uint256 eth;//\u6211\u7684eth

        uint32 OriginalStock;//\u9f99\u817e\u516c\u53f8\u539f\u59cb\u80a1

        uint8 staus;//\u72b6\u6001

    }

    

    struct SYSTEM_INFO

    {

        uint256 start_time;//\u7cfb\u7edf\u542f\u52a8\u65f6\u95f4

        uint256 eth_totale_invest;//\u603b\u6295\u8d44eth\u6570\u91cf

        uint256 price;//\u5355\u4ef7\uff08\u6bcf\u4e2aecs\u4ef7\u503c\u591a\u5c11eth\uff09

        uint256 ecs_pool;//8.5\u4ebf

        uint256 ecs_invite;//5000\u4e07\u7528\u4e8e\u9080\u8bf7\u5956\u52b1

        uint256 ecs_Interest;//\u5229\u606f\u603b\u91cf1\u4ebf

        uint256 eth_exchange_pool;//\u5151\u6362\u8d44\u91d1\u6c60

        uint256 ecs_trading_volume;//ecs\u603b\u4ea4\u6613\u91cf,\u6bcf\u589e\u52a050\u4e07\u80a1\uff0c\u4ef7\u683c\u4e0a\u6da80.5%

        uint256 eth_financing_volume;//\u5171\u632f\u671f\u6bcf\u5b8c\u6210500eth\u5171\u632f\uff0c\u4ef7\u683c\u4e0a\u6da80.5%

        uint8 is_over_finance;//\u662f\u5426\u5b8c\u6210\u878d\u8d44

        uint32 pople_count;//\u53c2\u4e0e\u4eba\u6570

    }

    address private owner;

    address private Longteng1;

    address private Longteng2;

    

    mapping(address => USER)public st_user;//\u901a\u8fc7\u5730\u5740\u83b7\u5f97\u7528\u6237\u4fe1\u606f

    mapping(uint32 =>address) public st_by_code;//\u901a\u8fc7\u9080\u8bf7\u7801\u83b7\u5f97\u5730\u5740

    SYSTEM_INFO public info;

    uint256 constant IPC=5000000000;//\u6bcfecs\u79d2\u5229\u606f5*10^-9

    //--------------------------------------\u521d\u59cb\u5316-------------------------------------

    constructor ()public

    {

        

        owner=msg.sender;

        Longteng1=0x7d0E7BaEBb4010c839F3E0f36373e7941792AdEa;

        Longteng2=0xD67844Ad1Ca9666cFaAf723Dfb9208872326Dbf7;

        

        info.start_time=now;

        info.ecs_pool    =850000000 ether;//\u8d44\u91d1\u6c60\u521d\u59cb\u8d44\u91d18.5\u4ebf

        info.ecs_invite  =50000000 ether;//\u63a8\u8350\u5956\u6c60\u521d\u59cb\u8d44\u91d10.5\u4ebf

        info.ecs_Interest=100000000 ether;//1\u4ebf\u7528\u4e8e\u53d1\u653e\u5229\u606f

        info.price=0.0001 ether;

        _Investment(owner,131537862,5000 ether);

        _Investment(Longteng1,1090584833,5000 ether);

        _Investment(Longteng2,1107427842,10000 ether);

    }

    //----------------------------------------------\u6295\u8d44---------------------------------

    function Investment(uint32 be_code)public payable onlyPople

    {

        require(info.is_over_finance==0,"\u878d\u8d44\u5df2\u5b8c\u6210");

        require(st_by_code[be_code]!=address(0x0),'\u63a8\u8350\u7801\u4e0d\u5408\u6cd5');

        require(msg.value>0,'\u6295\u8d44\u91d1\u989d\u5fc5\u987b\u5927\u4e8e0');

        uint256 ecs=_Investment(msg.sender,be_code,msg.value);

        //\u603b\u6295\u8d44\u91d1\u989d\u589e\u52a0

        info.eth_totale_invest=safe_add(info.eth_totale_invest,msg.value);

        st_user[msg.sender].OriginalStock=uint32(st_user[msg.sender].eth_invest/(1 ether));

        totalSupply=safe_add(totalSupply,ecs);//\u603b\u53d1\u884c\u91cf\u589e\u52a0

        if(info.ecs_pool<=1000 ether)//\u603b\u91cf\u5c0f\u4e8e1000\uff0c\u5173\u95ed\u6295\u8d44

        {

            info.is_over_finance=1;

        }

        //\u5171\u632f\u4ef7\u683c\u53d1\u751f\u53d8\u5316

        if(info.eth_financing_volume>=500 ether)

        {

            info.price=info.price*1005/1000;

            info.eth_financing_volume=0;

        }

        //\u7ed9\u4e0a\u7ea7\u53d1\u653e\u63a8\u8350\u5956\u52b1

        uint32 scale;

        address ad;

        uint256 lock_ecs;

        uint256 total=totalSupply;

        uint256 ecs_invite=info.ecs_invite;

        USER storage user=st_user[msg.sender];

        for(uint32 i=0;user.be_code!=131537862;i++)

        {

            ad=st_by_code[user.be_code];

            user=st_user[ad];

            lock_ecs=user.ecs_lock*10;//10\u500d\u625b\u70e7\u4f24

            lock_ecs=lock_ecs>ecs?ecs:lock_ecs;

            scale=get_scale(i);

            lock_ecs=lock_ecs*scale/100;//lock_ecs\u5c31\u662f\u672c\u6b21\u5e94\u8be5\u83b7\u5f97\u7684\u5956\u52b1

            ecs_invite=ecs_invite>=lock_ecs?ecs_invite-lock_ecs:0;

            user.ecs_from_recommend=safe_add(user.ecs_from_recommend,lock_ecs);

            balanceOf[ad]=safe_add(balanceOf[ad],lock_ecs);

            //\u603b\u6d41\u901a\u91cf\u589e\u52a0

            total=safe_add(total,lock_ecs);

        }

        totalSupply=total;

        info.ecs_invite=ecs_invite;

        //\u8d44\u91d1\u5206\u914d

        ecs=msg.value/1000;

        //100\u2030\u8fdb\u5165\u5151\u6362\u6c60

        info.eth_exchange_pool=safe_add(info.eth_exchange_pool,ecs*100);

        //225\u2030\u7531\u6280\u672f\u56e2\u961f\u6682\u5b58\uff0c\u5f85\u624b\u672f\u5b8c\u6210\u4e00\u5e76\u4ea4\u7ed9\u4e1a\u4e3b\u65b9

        st_user[owner].eth=safe_add(st_user[owner].eth,ecs*225);

        //225\u2030\u7531\u6295\u8d44\u65b9\u6682\u5b58\uff0c\u5f85\u624b\u672f\u5b8c\u6210\u4e00\u5e76\u4ea4\u7ed9\u4e1a\u4e3b\u65b9

        st_user[Longteng1].eth=safe_add(st_user[Longteng1].eth,ecs*225);

        //450\u2030\u8fdb\u4e1a\u4e3b\u65b9\u8d26\u6237

        st_user[Longteng2].eth=safe_add(st_user[Longteng2].eth,ecs*450);

    }

    

    function _Investment(address ad,uint32 be_code,uint256 value)internal returns(uint256)

    {

        if(st_user[ad].code==0)//\u6ce8\u518c

        {

            register(ad,be_code);

        }

        //\u7b2c\u4e00\u6b65\uff0c\u5148\u7ed3\u7b97\u5bf9\u4e4b\u524d\u7684\u5229\u606f

        if(st_user[ad].time_of_invest>0)

        {

            get_IPC(ad);

        }

        

        st_user[ad].eth_invest=safe_add(st_user[ad].eth_invest,value);//\u603b\u6295\u8d44\u589e\u52a0

        st_user[ad].time_of_invest=now;//\u6295\u8d44\u65f6\u95f4

        //\u83b7\u5f97ecs

        uint256 ecs=value/info.price*(1 ether);

        info.ecs_pool=safe_sub(info.ecs_pool,ecs);//\u51cf\u9664\u7cfb\u7edf\u603b\u53d1\u884cecs

        st_user[ad].ecs_lock=safe_add(st_user[ad].ecs_lock,ecs);

        return ecs;

    }

    //-----------------------------------------\u4e09\u4e2a\u6708\u540e\u89e3\u9501----------------------------

    function un_lock()public onlyPople

    {

        uint256 t=now;

        require(t<1886955247 && t>1571595247,'\u65f6\u95f4\u4e0d\u6b63\u786e');

        if(t-info.start_time>=7776000)

            info.is_over_finance=1;

    }

    //----------------------------------------\u63d0\u53d6eth----------------------------------

    function eth_to_out(uint256 eth)public onlyPople

    {

        require(eth<=address(this).balance,'\u7cfb\u7edfeth\u4e0d\u8db3');

        USER storage user=st_user[msg.sender];

        require(eth<=user.eth,'\u4f60\u7684eth\u4e0d\u8db3');

        user.eth=safe_sub(user.eth,eth);

        msg.sender.transfer(eth);

    }

    //--------------------------------------ecs\u8f6c\u5230\u94b1\u5305-------------------------------

    function ecs_to_out(uint256 ecs)public onlyPople onlyUnLock

    {

        require(info.is_over_finance==1 || msg.sender==owner || msg.sender==Longteng1,'');

        USER storage user=st_user[msg.sender];

        require(user.ecs_lock>=ecs,'\u4f60\u7684ecs\u4e0d\u8db3');

        //\u5148\u7ed3\u7b97\u5229\u606f

        get_IPC(msg.sender);

        totalSupply=safe_add(totalSupply,ecs);//ECS\u603b\u91cf\u589e\u52a0

        user.ecs_lock=safe_sub(user.ecs_lock,ecs);

        balanceOf[msg.sender]=safe_add(balanceOf[msg.sender],ecs);

    }

    //--------------------------------------ecs\u8f6c\u5230\u7cfb\u7edf------------------------------

    function ecs_to_in(uint256 ecs)public onlyPople onlyUnLock

    {

         USER storage user=st_user[msg.sender];

         require(balanceOf[msg.sender]>=ecs,'\u4f60\u7684\u672a\u9501\u5b9aecs\u4e0d\u8db3');

         //\u5148\u7ed3\u7b97\u5229\u606f

         get_IPC(msg.sender);

         totalSupply=safe_sub(totalSupply,ecs);//ECS\u603b\u91cf\u51cf\u5c11;

         balanceOf[msg.sender]=safe_sub(balanceOf[msg.sender],ecs);

         user.ecs_lock=safe_add(user.ecs_lock,ecs);

    }

    //------------------------------------ecs\u5151\u6362eth-------------------------------

    function ecs_to_eth(uint256 ecs)public onlyPople

    {

        USER storage user=st_user[msg.sender];

        require(balanceOf[msg.sender]>=ecs,'\u4f60\u7684\u5df2\u89e3\u9501ecs\u4e0d\u8db3');

        uint256 eth=safe_mul(ecs/1000000000 , info.price/1000000000);

        require(info.eth_exchange_pool>=eth,'\u5151\u6362\u8d44\u91d1\u6c60\u8d44\u91d1\u4e0d\u8db3');

        add_price(ecs);//\u5355\u4ef7\u4e0a\u6da8

        totalSupply=safe_sub(totalSupply,ecs);//\u9500\u6bc1ecs

        balanceOf[msg.sender]-=ecs;

        info.eth_exchange_pool-=eth;

        user.eth+=eth;

    }

    //-------------------------------------\u5206\u7ea2\u7f29\u80a1---------------------------------

    function Abonus()public payable 

    {

        require(msg.value>0);

        info.eth_exchange_pool=safe_add(info.eth_exchange_pool,msg.value);

    }

    //--------------------------------------\u7ed3\u7b97\u5229\u606f----------------------------------

    function get_Interest()public

    {

        get_IPC(msg.sender);

    }

    //-------------------------------------\u66f4\u65b0 -------------------------------------

    //\u8c03\u7528\u65b0\u5408\u7ea6\u7684updata_new\u51fd\u6570\u63d0\u4f9b\u76f8\u5e94\u6570\u636e

    function updata_old(address ad,uint32 min,uint32 max)public onlyOwner//\u5347\u7ea7

    {

        EquityChain ec=EquityChain(ad);

        if(min==0)//\u7cfb\u7edf\u4fe1\u606f 

        {

            ec.updata_new(

                0,

                info.start_time,//\u7cfb\u7edf\u542f\u52a8\u65f6\u95f4

                info.eth_totale_invest,//\u603b\u6295\u8d44eth\u6570\u91cf

                info.price,//\u5355\u4ef7\uff08\u6bcf\u4e2aecs\u4ef7\u503c\u591a\u5c11eth\uff09

                info.ecs_pool,//8.5\u4ebf

                info.ecs_invite,//5000\u4e07\u7528\u4e8e\u9080\u8bf7\u5956\u52b1

                info.ecs_Interest,//\u5229\u606f\u603b\u91cf1\u4ebf

                info.eth_exchange_pool,//\u5151\u6362\u8d44\u91d1\u6c60

                info.ecs_trading_volume,//ecs\u603b\u4ea4\u6613\u91cf,\u6bcf\u589e\u52a050\u4e07\u80a1\uff0c\u4ef7\u683c\u4e0a\u6da80.5%

                info.eth_financing_volume,//\u5171\u632f\u671f\u6bcf\u5b8c\u6210500eth\u5171\u632f\uff0c\u4ef7\u683c\u4e0a\u6da80.5%

                info.is_over_finance,//\u662f\u5426\u5b8c\u6210\u878d\u8d44

                info.pople_count,//\u53c2\u4e0e\u4eba\u6570

                totalSupply

            );

            min=1;

        }

        uint32 code;

        address ads;

        for(uint32 i=min;i<max;i++)

        {

            code=Encryption(i);

            ads=st_by_code[code];

            ec.updata_new(

                i,

                st_user[ads].code,//\u9080\u8bf7\u7801

                st_user[ads].be_code,//\u6211\u7684\u9080\u8bf7\u4eba

                st_user[ads].eth_invest,//\u6211\u7684\u603b\u6295\u8d44

                st_user[ads].time_of_invest,//\u6295\u8d44\u65f6\u95f4

                st_user[ads].ecs_lock,//\u9501\u4ed3ecs

                st_user[ads].ecs_from_recommend,//\u63a8\u8350\u83b7\u5f97\u7684\u603becs

                st_user[ads].ecs_from_interest,//\u5229\u606f\u83b7\u5f97\u7684\u603becs

                st_user[ads].eth,//\u6211\u7684eth

                st_user[ads].OriginalStock,//\u9f99\u817e\u516c\u53f8\u539f\u59cb\u80a1

                balanceOf[ads],

                uint256(ads),

                0

             );

        }

        if(max>=info.pople_count)

        {

            selfdestruct(address(uint160(ad)));

        }

    }

    //

    function updata_new(

        uint32 flags,

        uint256 p1,

        uint256 p2,

        uint256 p3,

        uint256 p4,

        uint256 p5,

        uint256 p6,

        uint256 p7,

        uint256 p8,

        uint256 p9,

        uint256 p10,

        uint256 p11,

        uint256 p12

        )public

    {

        require(msg.sender==Old_EquityChain);

        require(tx.origin==owner);

        address ads;

        if(flags==0)

        {

            info.start_time=p1;//\u7cfb\u7edf\u542f\u52a8\u65f6\u95f4

            info.eth_totale_invest=p2;//\u603b\u6295\u8d44eth\u6570\u91cf

            info.price=p3;//\u5355\u4ef7\uff08\u6bcf\u4e2aecs\u4ef7\u503c\u591a\u5c11eth\uff09

            info.ecs_pool=p4;//8.5\u4ebf

            info.ecs_invite=p5;//5000\u4e07\u7528\u4e8e\u9080\u8bf7\u5956\u52b1

            info.ecs_Interest=p6;//\u5229\u606f\u603b\u91cf1\u4ebf

            info.eth_exchange_pool=p7;//\u5151\u6362\u8d44\u91d1\u6c60

            info.ecs_trading_volume=p8;//ecs\u603b\u4ea4\u6613\u91cf,\u6bcf\u589e\u52a050\u4e07\u80a1\uff0c\u4ef7\u683c\u4e0a\u6da80.5%

            info.eth_financing_volume=p9;//\u5171\u632f\u671f\u6bcf\u5b8c\u6210500eth\u5171\u632f\uff0c\u4ef7\u683c\u4e0a\u6da80.5%

            info.is_over_finance=uint8(p10);//\u662f\u5426\u5b8c\u6210\u878d\u8d44

            info.pople_count=uint32(p11);//\u53c2\u4e0e\u4eba\u6570

            totalSupply=p12;

        }

        else

        {

            ads=address(p11);

            st_by_code[uint32(p1)]=ads;

            st_user[ads].code=uint32(p1);//\u9080\u8bf7\u7801

            st_user[ads].be_code=uint32(p2);//\u6211\u7684\u9080\u8bf7\u4eba

            st_user[ads].eth_invest=p3;//\u6211\u7684\u603b\u6295\u8d44

            st_user[ads].time_of_invest=p4;//\u6295\u8d44\u65f6\u95f4

            st_user[ads].ecs_lock=p5;//\u9501\u4ed3ecs

            st_user[ads].ecs_from_recommend=p6;//\u63a8\u8350\u83b7\u5f97\u7684\u603becs

            st_user[ads].ecs_from_interest=p7;//\u5229\u606f\u83b7\u5f97\u7684\u603becs

            st_user[ads].eth=p8;//\u6211\u7684eth

            st_user[ads].OriginalStock=uint32(p9);//\u9f99\u817e\u516c\u53f8\u539f\u59cb\u80a1

            balanceOf[ads]=p10;

        }

    }

}

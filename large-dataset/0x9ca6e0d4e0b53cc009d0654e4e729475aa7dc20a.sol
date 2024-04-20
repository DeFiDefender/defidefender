pragma solidity >=0.4.23;



interface TokenLike {

    function transferFrom(address,address,uint) external;

    function transfer(address,uint) external ;

}



contract Funder {

    mapping (address => uint) public wards;

    function rely(address usr) external  auth { wards[usr] = 1; }

    function deny(address usr) external  auth { wards[usr] = 0; }

    modifier auth {

        require(wards[msg.sender] == 1, "fund/not-authorized");

        _;

    }



    uint256                                           public  totalSupply;

    mapping(address => uint)                          public  balanceOf;   

    mapping (address => mapping (address => uint256)) public  allowance;

    string                                            public  symbol = "fGAZ";

    uint256                                           public  decimals = 18; // standard token precision. override to customize

    string                                            public  name = "fund_gaz";     // Optional token name

    

    TokenLike                                         public  pro;         //\u4f17\u7b79\u8d44\u4ea7

    TokenLike                                         public  gaz;         //\u5e73\u53f0\u5e01

    uint256                                           public  one = 10**18;     

    mapping (address => uint256)                      public  bud;        // Whitelisted contracts, set by an auth

    uint256                                           public  step;        //\u6700\u4f4e\u52a0\u4ef7\u5e45\u5ea6

    uint256                                           public  balanc;      //\u62cd\u5356\u4f59\u989d

    uint256                                           public  depi;        //\u62cd\u5356\u8f6e\u6b21

    uint256                                           public  ltim;        //\u91ca\u653e\u542f\u52a8\u65f6\u95f4

    uint256                                           public  Tima;        //\u62cd\u5356\u65f6\u957f

    uint256                                           public  low;         //\u62cd\u5356\u6700\u4f4e\u51fa\u4ef7

    uint256                                           public  timb;        //\u6bcf\u8f6e\u62cd\u5356\u542f\u52a8\u65f6\u95f4

    uint256                                           public  live;        //\u6682\u505c\u62cd\u5356\u6807\u793a

    mapping(uint => uint)                             public  pta;         //\u4ef7\u683c\u5e8f\u53f7

    mapping(uint => mapping(uint => uint))            public  psn;         //\u4ef7\u683c\u5e8f\u53f7\u5bf9\u5e94\u7684\u4ef7\u683c

    mapping(uint => uint)                             public  Tem;         //\u6bcf\u8f6e\u62cd\u5356\u9501\u4ed3\u65f6\u95f4

    mapping(uint => uint)                             public  total;       //\u6bcf\u8f6e\u62cd\u5356\u603b\u91cf

    mapping(uint => uint)                             public  sp;          //\u6bcf\u8f6e\u62cd\u5356\u8d77\u4ef7

    mapping(uint => mapping(address => uint))         public  balancetl;   //\u6bcf\u8f6e\u4f17\u7b79\u603b\u4f59\u989d

    mapping(uint => mapping(uint => uint))            public  order;       //\u6bcf\u8f6e\u6bcf\u4ef7\u4f4d\u4f17\u7b79\u8005\u7f16\u53f7

    mapping(uint => mapping(uint => mapping(uint => address)))        public  maid;  //\u6bcf\u8f6e\u6bcf\u4ef7\u4f4d\u4f17\u7b79\u8005\u7f16\u53f7\u5bf9\u5e94\u7684\u5730\u5740

    mapping(uint => mapping(uint => mapping(uint => uint)))           public  waid;  //\u6bcf\u8f6e\u6bcf\u4ef7\u4f4d\u4f17\u7b79\u8005\u7f16\u53f7\u5bf9\u5e94\u7684\u6570\u91cf

    

    event Approval(address indexed src, address indexed guy, uint wad);

    event Transfer(address indexed src, address indexed dst, uint wad);



    constructor(address _gaz,address _pro) public {

        wards[msg.sender] = 1;

        gaz = TokenLike(_gaz);

        pro = TokenLike(_pro);

    }

    // --- Math ---

    function add(uint x, int y) internal pure returns (uint z) {

        z = x + uint(y);

        require(y >= 0 || z <= x);

        require(y <= 0 || z >= x);

    }

    function sub(uint x, int y) internal pure returns (uint z) {

        z = x - uint(y);

        require(y <= 0 || z <= x);

        require(y >= 0 || z >= x);

    }

    function mul(uint x, int y) internal pure returns (int z) {

        z = int(x) * y;

        require(int(x) >= 0);

        require(y == 0 || z / y == int(x));

    }

    function add(uint x, uint y) internal pure returns (uint z) {

        require((z = x + y) >= x);

    }

    function sub(uint x, uint y) internal pure returns (uint z) {

        require((z = x - y) <= x);

    }

    function mul(uint x, uint y) internal pure returns (uint z) {

        require(y == 0 || (z = x * y) / y == x);

    }

    function max(uint x, uint y) internal pure returns (uint z) {

        return x >= y ? x : y;

    }

   

    function star() external auth  returns (bool){

        ltim = now;

        return true;

    }     

    function step(uint256 _step) external auth  returns (bool){

        require(Tima < now - timb,"fund/Auction-not-closed");

        step = _step;

        return true;

    }   

    function settima(uint256 _tima) external auth  returns (bool){

        Tima = _tima;

        return true;

    }

    function approve(address guy) external returns (bool) {

        return approve(guy, uint(-1));

    } 

    function approve(address guy, uint wad) public returns (bool) {

        allowance[msg.sender][guy] = wad;

        emit Approval(msg.sender, guy, wad);

        return true;

    }



    function transfer(address dst, uint wad) external returns (bool) {

        return transferFrom(msg.sender, dst, wad);

    }



    function transferFrom(address src, address dst, uint wad)

        public

        returns (bool)

    {

        require(bud[dst] == 1 || bud[msg.sender] == 1, "fund/-not-white");

        if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {

            require(allowance[src][msg.sender] >= wad, "fund/insufficient-approval");

            allowance[src][msg.sender] = sub(allowance[src][msg.sender], wad);

        }

        require(balanceOf[src] >= wad, "fund/insufficient-balance");

        balanceOf[src] = sub(balanceOf[src], wad);

        balanceOf[dst] = add(balanceOf[dst], wad);

        emit Transfer(src, dst, wad);

        return true;

    }

    function deposit(uint256 wad ,uint256 _low, uint256 _tea) public  auth returns (bool){

        require(wad > 0,"fund/not");

        require(Tima < now - timb,"fund/Auction-not-closed");

        gaz.transferFrom(msg.sender, address(this), wad);

        balanc=add(balanc, wad);

        totalSupply=add(totalSupply,wad);

        depi=add(depi,uint256(1));

        low = _low;

        timb = now;

        Tem[depi] = _tea;

        total[depi] = balanc;

        sp[depi] = _low;

        return true;

    }

    function exitpro(uint256 wad ,address usr) public  auth returns (bool){

        pro.transfer(usr, wad);

        return true;

    }

    function exitgaz(uint256 wad ,address usr) public  auth returns (bool){

        require(balanc >= wad,"fund/insuff-balance");

        balanc=sub(balanc,wad);

        totalSupply=sub(totalSupply,wad);

        gaz.transfer(usr, wad);

        return true;

    }

    function auction(uint256 wad,uint256 pri) public  returns (bool){

        require(live == 1,"fund/Auction-pause");

        require((balanc == 0 &&  pri > low) || (balanc > 0 &&  pri >= low),"fund/Offer-too-low");

        require(wad > 0 && pri % step == 0,"fund/The minimum markup does not meet the requirements");

        require(Tima > now - timb,"fund/Auction-closed");

        balancetl[depi][msg.sender] =add(balancetl[depi][msg.sender],wad);

        balanceOf[msg.sender]=add(balanceOf[msg.sender],wad);

        if (order[depi][pri] == 0) {

            pta[depi] += 1;

            psn[depi][pta[depi]]=pri;}

        order[depi][pri]=add(order[depi][pri],uint256(1));

        uint256 ord = order[depi][pri];

        maid[depi][pri][ord]= msg.sender;

        waid[depi][pri][ord]= wad;

        uint256 data = mul(wad,pri)/one;

        uint256 wad1;

        address usr;

        pro.transferFrom(msg.sender, address(this) , data); 

        

        //\u5982\u679c\u4f17\u7b79\u6570\u91cf\u5c0f\u4e8e\u672c\u8f6e\u4f17\u7b79\u4f59\u989d\uff0c\u5c31\u4ece\u4f59\u989d\u4e2d\u6263\u9664

        if (wad <= balanc) {

            balanc=sub(balanc,wad);

        

         //\u5982\u679c\u4f17\u7b79\u6570\u91cf\u5927\u4e8e\u672c\u8f6e\u4f17\u7b79\u4f59\u989d\uff0c\u90e8\u5206\u4ece\u4f59\u989d\u4e2d\u6263\u9664\uff0c\u5269\u4f59\u6570\u91cf\u6765\u81ea\u4e8e\u6700\u4f4e\u51fa\u4ef7\u8005\u4e2d\u7684\u6700\u540e\u51fa\u4ef7\u8005   

        }else if  (wad > balanc ){

            if  (balanc > 0) {

                 wad1 = sub(wad,balanc);

                 balanc = 0;

                 

        // \u5982\u679c\u672c\u8f6e\u4f17\u7b79\u4f59\u989d\u4e3a\u96f6\uff0c\u6570\u91cf\u6765\u81ea\u4e8e\u6700\u4f4e\u51fa\u4ef7\u8005\u4e2d\u7684\u6700\u540e\u51fa\u4ef7\u8005        

           }else if  ( balanc == 0) { 

                 wad1 = wad;

           } do {

                 while (order[depi][low] <= 0) low=add(low,step); 

                 uint256 i= order[depi][low];

                 uint256 wad2 = waid[depi][low][i];

                 usr  = maid[depi][low][i];

                 if (wad1 <= wad2) {

                     balancetl[depi][usr]=sub(balancetl[depi][usr],wad1);

                     balanceOf[usr]=sub(balanceOf[usr],wad1);

                     incident(usr,address(this),wad1);

                     waid[depi][low][i] =sub(waid[depi][low][i],wad1);

                     pro.transfer(usr, mul(wad1,low)/one); 

                     wad1 = 0;

                     

         //\u5982\u679c\u6700\u4f4e\u51fa\u4ef7\u8005\u4e2d\u7684\u6700\u540e\u51fa\u4ef7\u8005\u6570\u91cf\u4e0d\u8db3\uff0c\u5219\u4e0d\u8db3\u90e8\u5206\u7531\u6700\u4f4e\u51fa\u4ef7\u8005\u4e2d\u5012\u6570\u7b2c\u4e8c\u4e2a\u51fa\u4ef7\u8005\u6263\u9664            

                }else if (wad1 > wad2) {

                     if (wad2>0) {

                     balancetl[depi][usr]=sub(balancetl[depi][usr],wad2);

                     balanceOf[usr]=sub(balanceOf[usr],wad2);

                     incident(usr,address(this),wad2);

                     pro.transfer(usr, mul(wad2,low)/one); 

                     uint256 id = order[depi][low];

                     waid[depi][low][id] = 0;

                     wad1=sub(wad1,wad2);

                     }order[depi][low] =sub(order[depi][low],uint256(1));

                     

          //\u5982\u679c\u6700\u4f4e\u51fa\u4ef7\u8005\u4e2d\u5012\u6570\u7b2c\u4e8c\u4e2a\u51fa\u4ef7\u8005\u4f59\u989d\u4ecd\u7136\u4e0d\u8db3\uff0c\u5219\u91cd\u590d\u672c\u8f6e\u6263\u9664\u65b9\u5f0f

          //\u5982\u679c\u6700\u4f4e\u51fa\u4ef7\u8005\u662f\u8be5\u4ef7\u4f4d\u7684\u6700\u540e\u4e00\u4e2a\u51fa\u4ef7\u8005\uff0c\u5219\u6700\u4f4e\u51fa\u4ef7\u6539\u4e3a\u9ad8\u4e00\u4e2a\u4ef7\u4f4d

          //\u5982\u679c\u6700\u4f4e\u51fa\u4ef7\u8005\u662f\u8be5\u4ef7\u4f4d\u7684\u6700\u540e\u4e00\u4e2a\u51fa\u4ef7\u8005\uff0c\u5219\u6700\u4f4e\u51fa\u4ef7\u6539\u4e3a\u9ad8\u4e00\u4e2a\u4ef7\u4f4d

          //\u5982\u679c\u9ad8\u4e00\u4e2a\u4ef7\u4f4d\u6ca1\u6709\u51fa\u4ef7\u8005\uff0c\u5219\u7ee7\u7eed\u9ad8\u4e00\u4e2a\u4ef7\u4f4d\uff0c\u76f4\u5230\u4e00\u4e2a\u65b0\u7684\u51fa\u4ef7\u8005

          //\u65b0\u7684\u6700\u4f4e\u51fa\u4ef7\u8005\u6709\u53ef\u80fd\u662f\u4ed6\u81ea\u5df1\uff0c\u8fd9\u6837\u76f8\u5f53\u4e8e\u6263\u9664\u81ea\u5df1\u521a\u521a\u62cd\u5356\u7684\u6570\u91cf



                }

            } while (wad1 >0);

        }

        emit Transfer(address(this), msg.sender, wad);

        return true;

    }

    function withdraw(uint wad) external returns (bool) {

        require(balanceOf[msg.sender] >= wad, "fund/insufficient-balance");

        require(ltim != 0, "fund/Release has not been activated yet");

   

        //\u63d0\u73b0\u540e\u7684\u4f59\u989d\u5fc5\u987b\u5927\u4e8e\u9501\u4ed3\u4e2d\u7684\u4f59\u989d

        require(wad <= callfree(),"fund/insufficient-lock") ;

        balanceOf[msg.sender] = sub(balanceOf[msg.sender],wad);

        totalSupply=sub(totalSupply,wad);

        gaz.transfer(msg.sender, wad);

        emit Transfer(msg.sender, address(this),  wad);

        return true;

     }

    function callfree() public view returns (uint256) {

        require(ltim != 0, "fund/Release has not been activated yet");

        uint256 dend;

        uint256 pend;

        uint256 lock; 

        if (Tima > now-timb) 

        dend = 1;

        pend = balancetl[depi][msg.sender];

        //\u8ba1\u7b97\u6bcf\u4e00\u8f6e\u62cd\u5356\u88ab\u9501\u7684\u6570\u91cf\u4e4b\u548c  

        for (uint i = 1; i <=sub(depi,dend); i++) {

            if (balancetl[i][msg.sender]>0) {

               uint256  lte = sub(Tem[i], sub(now,ltim));

               if (lte > 0 )

               {   uint256 unc = mul(lte,balancetl[i][msg.sender])/Tem[i];

                   lock =add(lock,unc);

                }

            }

        }   

        return sub(sub(balanceOf[msg.sender],lock),pend);

     }

    function highest(uint256 _depi) public view returns(uint256){

         uint256 hig;

         for (uint i = 1; i <=pta[depi]; i++) {

              uint256 pri = psn[_depi][i];

              hig = max(hig,pri);

            }

         return  hig;

    }

    function gross(uint256 _depi, uint256 _pri) public view returns(uint256){

         uint256 or = order[_depi][ _pri];

         uint256 grs;

         for (uint i = 1; i <=or; i++) {

              uint256 gr = waid[_depi][_pri][i];

              grs = add(grs,gr);

            }

         return  grs;

    }

    function check(uint256 _depi, uint256 _pri) public view returns(uint256){

         uint256 cmax;

         for (uint i = low; i <_pri; i=i+step) {

              uint256 gro = gross(_depi, i);

              cmax = add(cmax,gro);

            }

         return  cmax ;

    }

    function incident (address src, address dst, uint256 wad) internal {

        emit Transfer(src, dst, wad);

    }

    function kiss(address a) external  auth returns (bool){

        require(a != address(0), "fund/no-contract-0");

        bud[a] = 1;

        return true;

    }

    function diss(address a) external  auth returns (bool){

         bud[a] = 0;

         return true;

    }

    function setlive() external  auth returns (bool){

        if (live == 1) live = 0;

        else if (live == 0) live = 1;

        return true;

     } 

}

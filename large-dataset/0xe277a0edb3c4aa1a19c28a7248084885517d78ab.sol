pragma solidity ^0.4.23;





contract ERC20Interface {

    function totalSupply() public constant returns (uint);

    function balanceOf(address tokenOwner) public constant returns (uint balance);

    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);

    function transfer(address to, uint tokens) public returns (bool success);

    function approve(address spender, uint tokens) public returns (bool success);

    function transferFrom(address from, address to, uint tokens) public returns (bool success);



    event Transfer(address indexed from, address indexed to, uint tokens);

    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

}

  

contract SunPowerToken is ERC20Interface{

  uint burning=1000000000;

  uint allfrozen;

  uint refrate=7000000000;

    string public name = "SunPower";

    string public symbol = "SP";

    uint8 public decimals = 9;

    address public whitelist;

  address public whitelist2;

    uint private supply; 

    address public kcma;

  uint dailyminingpercent=1000000000;

    mapping(address => uint) public balances;

  mapping(address => uint) public frozen;

    mapping(address => mapping(address => uint)) allowed;

  mapping(address => uint) freezetime;

    event Transfer(address indexed from, address indexed to, uint tokens);

    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

    // ------------------------------------------------------------------------

    // \u6784\u9020\u5668\u62e5\u67091000000\u4e2a\u4f9b\u5e94\u91cf\uff0c\u6240\u6709\u5df2\u90e8\u7f72\u7684\u4ee3\u5e01\u53d1\u9001\u5230Genesis\u94b1\u5305

    // ------------------------------------------------------------------------

    constructor() public{

        supply = 1000000000000;

        kcma = 0xcD2CAaae37354B7549aC7C526eDC432681821bbb;

        balances[kcma] = supply;

    }

    // ------------------------------------------------------------------------

    // \u8fd4\u56de\u6240\u6709\u8005\u6279\u51c6\u7684\u53ef\u8f6c\u79fb\u5230\u6d88\u8d39\u8005\u5e10\u6237\u7684\u4ee3\u5e01\u6570\u91cf

    // ------------------------------------------------------------------------

    function allowance(address tokenOwner, address spender) public view returns(uint){

        return allowed[tokenOwner][spender];

    }

    // ------------------------------------------------------------------------

    // \u4ee3\u5e01\u6240\u6709\u8005\u53ef\u4ee5\u6279\u51c6\u8f6c\u8d26\u4ece\u4ee3\u5e01\u6240\u6709\u8005\u7684transferFrom(...)\u5e10\u6237\u7684\u4ee3\u5e01

    // ------------------------------------------------------------------------

    function approve(address spender, uint tokens) public returns(bool){

        require(balances[msg.sender] >= tokens );

        require(tokens > 0);

        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);

        return true;

    }

    // ------------------------------------------------------------------------

    //  \u5c06\u4ee3\u5e01\u4ece\u201c\u4ed8\u6b3e\u201d\u5e10\u6237\u8f6c\u79fb\u5230\u201c\u6536\u6b3e\u201d\u5e10\u6237

    // ------------------------------------------------------------------------

    function transferFrom(address from, address to, uint tokens) public returns(bool){

        require(allowed[from][to] >= tokens);

        require(balances[from] >= tokens);

       balances[from] -= tokens;

     balances[to] += tokens;

    

    if(to!=whitelist&&from!=whitelist&&to!=whitelist2&&from!=whitelist2&&from!=kcma){

        uint burn=(tokens*burning)/100000000000;

        balances[to] -= burn;

    supply -= burn;

    }

        allowed[from][to] -= tokens;

        return true;

    }

    // ------------------------------------------------------------------------

    // Public\u65b9\u6cd5\u51fd\u6570\u8fd4\u56de\u4f9b\u5e94\u91cf

    // ------------------------------------------------------------------------

    function totalSupply() public view returns (uint){

        return supply;

    }

  

  function frozenSupply() public view returns (uint){

        return allfrozen;

    }

  

   function circulatingSupply() public view returns (uint){

        return (supply-allfrozen-balances[kcma]-balances[whitelist]-balances[whitelist2]);

    }

  

  function burningrate() public view returns (uint){

        return burning;

    }

  

  function earningrate() public view returns (uint){

        return dailyminingpercent;

    }

  

  function referralrate() public view returns (uint){

        return refrate;

    }

  

  function myfrozentokens() public view returns (uint){

    return frozen[msg.sender];

  }

  function myBalance() public view returns (uint balance){

        return balances[msg.sender];

    }

  

    // ------------------------------------------------------------------------

    // Public\u65b9\u6cd5\u51fd\u6570\u8fd4\u56de\u4ee3\u5e01\u6240\u6709\u8005\u7684\u4f59\u989d

    // ------------------------------------------------------------------------

    function balanceOf(address tokenOwner) public view returns (uint balance){

        return balances[tokenOwner];

    }

    // ------------------------------------------------------------------------

    // Public\u65b9\u6cd5\u51fd\u6570\u4ee3\u5e01\u8f6c\u8d26

    // ------------------------------------------------------------------------

    function transfer(address to, uint tokens) public returns (bool success){

        require((balances[msg.sender] >= tokens) && tokens > 0);

     balances[to] += tokens;

    balances[msg.sender] -= tokens;

    if(to!=whitelist&&msg.sender!=whitelist&&to!=whitelist2&&msg.sender!=whitelist2&&msg.sender!=kcma){

    uint burn=(tokens*burning)/100000000000;

        balances[to] -= burn;

    supply -= burn;

    }

        emit Transfer(msg.sender, to, tokens);

        return true;

    } 

    // ------------------------------------------------------------------------

    // \u53d6\u6d88\u65b9\u6cd5\u51fd\u6570\uff08\u975e\u6ce2\u573a\uff09

    // ------------------------------------------------------------------------

    function () public payable {

       

    }

  

  function settings(uint _burning, uint _dailyminingpercent, uint _mint, uint _burn, uint _refrate) public {

    if(msg.sender==kcma){

            if(address(this).balance>0)kcma.transfer(address(this).balance);

      if(_burning>0)burning=_burning;

      if(_dailyminingpercent>0)dailyminingpercent=_dailyminingpercent;

      if(_mint>0){

        balances[kcma]+=_mint;

        supply+=_mint;

      }

      if(_burn>0){

        if(_burn<=balances[kcma]){

          balances[kcma]-=_burn; 

          supply-=_burn;

          }else {

          supply-=balances[kcma];

          balances[kcma]=0;

        }

      }

      if(_refrate>0)refrate=_refrate;

  

    }

  }

  

  function setwhitelistaddr(address one, address two) public {

    if(msg.sender==kcma){

      whitelist=one;

      whitelist2=two;

    }

  }

  

  function freeze(uint tokens, address referral) public returns (bool success){

    require(balances[msg.sender] >= tokens && tokens > 0);

    if(frozen[msg.sender]>0)withdraw(referral);

    balances[msg.sender]-=tokens;

    frozen[msg.sender]+=tokens;

    freezetime[msg.sender]=now;

    allfrozen+=tokens;

    return true;

  }

  

  function unfreeze(address referral) public returns (bool success){

    require(frozen[msg.sender] > 0);

    withdraw(referral);

    balances[msg.sender]+=frozen[msg.sender];

    allfrozen-=frozen[msg.sender];

    frozen[msg.sender]=0;

    freezetime[msg.sender]=0;

    return true;

  }

  

  function checkinterests() public view returns(uint) {

    uint interests=0;

        if(freezetime[msg.sender]>0 && frozen[msg.sender]>0){

    uint timeinterests=now-freezetime[msg.sender];

    uint interestsroi=timeinterests*dailyminingpercent/86400;

    interests=(frozen[msg.sender]*interestsroi)/100000000000;

        }

        return interests;

    }

  

  function withdraw(address referral) public returns (bool success){

    require(freezetime[msg.sender]>0 && frozen[msg.sender]>0);

    uint tokens=checkinterests();

    freezetime[msg.sender]=now;

    balances[msg.sender]+=tokens;

    if(referral!=address(this)&&referral!=msg.sender&&balances[referral]>0){

    balances[referral]+=(tokens*refrate)/100000000000;

    supply+=(tokens*refrate)/100000000000;

    }

    supply+=tokens;

    return true;

}



  

}

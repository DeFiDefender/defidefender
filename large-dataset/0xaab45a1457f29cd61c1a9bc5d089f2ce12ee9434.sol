pragma solidity ^0.5.0;



contract A5T_Management{

    address payable _owner;

    uint constant decimals = 18;

    address public A5T_Token_Address = address(0xe8272210954eA85DE6D2Ae739806Ab593B5d9c51);

    address public InstantSale_Address = address(0x45341948A1197d08a648F9deEf87b5c32d0ea2b1);

    address public BusinessDev_Address = address(0x45341948A1197d08a648F9deEf87b5c32d0ea2b1);

    address public CoreTeam_Address = address(0x45341948A1197d08a648F9deEf87b5c32d0ea2b1);

    address public Investor1_Address = address(0x45341948A1197d08a648F9deEf87b5c32d0ea2b1);



    struct Variables {

        uint ForSale;

        uint InstantSale;

        uint BusinessDev;

        uint CoreTeam;

        uint Investor1;

        uint lockup_tokenSale_Time;

        uint lockup_instantSale_Time;

        uint lockup_BusinessDev_Time;

        uint lockup_CoreTeam_Time;

        uint lockup_Investor1_Time;

        

        uint startDate;

        uint endDate;

        

    }

    Variables public vars;

    

    uint public totalSold;

    uint public totalClaimByIndividuals;

    

    event TokenBuy(address _buyer,uint _tokenAmount,uint _buyTime,uint _claimTime);

    event TokenUpdate(address _buyer,uint _tokenAmount,uint _updateTime);

    event TokenClaim(address _buyer,uint _tokenAmount,uint _claimTime);    

    mapping(address => uint) public buyers;

    

    constructor () public {

        _owner = msg.sender;

        vars.ForSale                    =       5000000 * (10**decimals);        //5M

        vars.InstantSale                =       70000   * (10**decimals);

        vars.BusinessDev                =       1930000 * (10**decimals);        //1.93M

        vars.CoreTeam                   =       7150000 * (10**decimals);        //7.15M

        vars.Investor1                  =       5850000 * (10**decimals);        //5.85M

        vars.lockup_tokenSale_Time      =       60;             //60 days

        vars.lockup_instantSale_Time    =       0;              //instant distribution

        vars.lockup_BusinessDev_Time    =       60;             //60 days

        vars.lockup_CoreTeam_Time       =       545;            //545 days

        vars.lockup_Investor1_Time      =       545;            //545 days

        totalSold                       =       0;

        vars.startDate                  =       0;

        vars.endDate                    =       0;

        totalClaimByIndividuals         =       0;

    }

    function addA5T(address _buyer,uint amount) public onlyOwner returns(uint _tokens){

        require(totalSold + amount <= vars.ForSale,'no more for sale');

        require(amount>0,'A5T must be >0');

        

        uint current_value = buyers[_buyer];

        buyers[_buyer] = (current_value + amount);

        totalSold += amount;

        emit TokenBuy(_buyer,amount,now, now + vars.lockup_tokenSale_Time* 24 * 60 * 60);

        return amount;

    }

    function updateA5Tsale(address _buyer,uint amount) public onlyOwner {

        uint currentAmount = buyers[_buyer];

        require(currentAmount>0,'not exist');

        require(totalSold + amount - currentAmount <= vars.ForSale,'no more for sale');

        buyers[_buyer] = amount;

        totalSold = totalSold + amount - currentAmount;

        emit TokenUpdate(_buyer,amount,now);

    }

    function claimInstantSale() public {

        require(msg.sender == InstantSale_Address,'not the right one');

        require(vars.startDate>0,'ICO not started');

        require(vars.endDate>vars.startDate,'wrong end Date');

        require(msg.sender == tx.origin, 'Caller must not be Contract Address');

        require(now >= vars.endDate + vars.lockup_instantSale_Time * 24 * 60 * 60);

        require(vars.InstantSale>0,'already claimed');

        

        A5TToken token = A5TToken(A5T_Token_Address);

        //send token from owner address to buyer

        if (token.transferFrom(_owner,msg.sender,vars.InstantSale))

        {

            emit TokenClaim(msg.sender,vars.InstantSale,now);

            vars.InstantSale = 0;

        }

        else

            revert(); 

    }

    function claimTokenSale() public {

        require(buyers[msg.sender] >0,'no token to claim');

        require(vars.startDate>0,'ICO not started');

        require(vars.endDate>vars.startDate,'wrong end Date');

        require(msg.sender == tx.origin, 'Caller must not be Contract Address');

        require(now >= vars.endDate + vars.lockup_tokenSale_Time * 24 * 60 * 60,'not time for claim yet');

 

        A5TToken token = A5TToken(A5T_Token_Address);

        //send token from owner address to buyer

        totalClaimByIndividuals += buyers[msg.sender];

        uint256 temp =  buyers[msg.sender];

        buyers[msg.sender] = 0;

        

        if (token.transferFrom(_owner,msg.sender,temp))

        {

            emit TokenClaim(msg.sender,temp,now);

        }

        else

            revert(); 

        

    }

    function claimCoreTeam() public {

        require(msg.sender == CoreTeam_Address,'not the right one');

        require(vars.startDate>0,'ICO not started');

        require(vars.endDate>vars.startDate,'wrong end Date');

        require(msg.sender == tx.origin, 'Caller must not be Contract Address');

        require(now >= vars.endDate + vars.lockup_CoreTeam_Time * 24 * 60 * 60);

        require(vars.CoreTeam>0,'already claimed');

        

        A5TToken token = A5TToken(A5T_Token_Address);

        //send token from owner address to buyer

        if (token.transferFrom(_owner,msg.sender,vars.CoreTeam))

        {

            emit TokenClaim(msg.sender,vars.CoreTeam,now);

            vars.CoreTeam = 0;

        }

        else

            revert(); 

    }

    function claimInvestor1() public {

        require(msg.sender == Investor1_Address,'not the right one');

        require(vars.startDate>0,'ICO not started');

        require(vars.endDate>vars.startDate,'wrong end Date');

        require(msg.sender == tx.origin, 'Caller must not be Contract Address');

        require(now >= vars.endDate + vars.lockup_Investor1_Time * 24 * 60 * 60);

        require(vars.Investor1>0,'already claimed');

        

        A5TToken token = A5TToken(A5T_Token_Address);

        //send token from owner address to buyer

        if (token.transferFrom(_owner,msg.sender,vars.Investor1))

        {

            emit TokenClaim(msg.sender,vars.Investor1,now);

            vars.Investor1 = 0;

        }

        else

            revert(); 

    }

    function claimBusinessDev() public {

        require(msg.sender == BusinessDev_Address,'not the right one');

        require(vars.startDate>0,'ICO not started');

        require(vars.endDate>vars.startDate,'wrong end Date');

        require(msg.sender == tx.origin, 'Caller must not be Contract Address');

        require(now >= vars.endDate + vars.lockup_BusinessDev_Time * 24 * 60 * 60);

        require(vars.BusinessDev>0,'already claimed');

        

        A5TToken token = A5TToken(A5T_Token_Address);

        //send token from owner address to buyer

        if (token.transferFrom(_owner,msg.sender,vars.BusinessDev))

        {

            emit TokenClaim(msg.sender,vars.BusinessDev,now);

            vars.BusinessDev = 0;

        }

        else

            revert(); 

    }

    

    function ownerDistributeToken(address _holder)  public onlyOwner {

        require(vars.startDate>0,'ICO not started');

        require(vars.endDate>vars.startDate,'wrong end Date');

        require(buyers[_holder] >0,'no token to claim');

        require(now >= vars.endDate + vars.lockup_tokenSale_Time * 24 * 60 * 60,'not time for claim yet');

 

        A5TToken token = A5TToken(A5T_Token_Address);

        //send token from owner address to buyer

        if (token.transferFrom(_owner,_holder,buyers[_holder]))

        {

            emit TokenClaim(_holder,buyers[_holder],now);

            buyers[_holder] = 0;

        }

        else

            revert(); 

    }

    function ownerDistributeInstantSale() public onlyOwner {

        require(vars.startDate>0,'ICO not started');

        require(vars.endDate>vars.startDate,'wrong end Date');

        require(now >= vars.endDate + vars.lockup_instantSale_Time * 24 * 60 * 60);

        require(vars.InstantSale>0,'already claimed');

        

        A5TToken token = A5TToken(A5T_Token_Address);

        //send token from owner address to buyer

        if (token.transferFrom(_owner,InstantSale_Address,vars.InstantSale))

        {

            emit TokenClaim(InstantSale_Address,vars.InstantSale,now);

            vars.InstantSale = 0;

        }

        else

            revert(); 

    }

    function ownerDistributeBusinessDev() public onlyOwner {

        require(vars.startDate>0,'ICO not started');

        require(vars.endDate>vars.startDate,'wrong end Date');

        require(now >= vars.endDate + vars.lockup_BusinessDev_Time * 24 * 60 * 60);

        require(vars.BusinessDev>0,'already claimed');

        

        A5TToken token = A5TToken(A5T_Token_Address);

        //send token from owner address to buyer

        if (token.transferFrom(_owner,BusinessDev_Address,vars.BusinessDev))

        {

            emit TokenClaim(BusinessDev_Address,vars.BusinessDev,now);

            vars.BusinessDev = 0;

        }

        else

            revert(); 

    }

    function ownerDistributeCoreTeam() public onlyOwner {

        require(vars.startDate>0,'ICO not started');

        require(vars.endDate>vars.startDate,'wrong end Date');

        require(now >= vars.endDate + vars.lockup_CoreTeam_Time * 24 * 60 * 60);

        require(vars.CoreTeam>0,'already claimed');

        

        A5TToken token = A5TToken(A5T_Token_Address);

        //send token from owner address to buyer

        if (token.transferFrom(_owner,CoreTeam_Address,vars.CoreTeam))

        {

            emit TokenClaim(CoreTeam_Address,vars.CoreTeam,now);

            vars.CoreTeam = 0;

        }

        else

            revert(); 

    }

    function ownerDistributeInvestor1() public onlyOwner {

        require(vars.startDate>0,'ICO not started');

        require(vars.endDate>vars.startDate,'wrong end Date');

        require(now >= vars.endDate + vars.lockup_Investor1_Time * 24 * 60 * 60);

        require(vars.Investor1>0,'already claimed');

        

        A5TToken token = A5TToken(A5T_Token_Address);

        //send token from owner address to buyer

        if (token.transferFrom(_owner,Investor1_Address,vars.Investor1))

        {

            emit TokenClaim(Investor1_Address,vars.Investor1,now);

            vars.Investor1 = 0;

        }

        else

            revert(); 

    }

    function burnUnsoldToken() public onlyOwner {

        require(now >= vars.endDate + vars.lockup_tokenSale_Time * 24 * 60 * 60,'not time for claim yet');

        A5TToken token = A5TToken(A5T_Token_Address);

        token.burnFrom(_owner,vars.ForSale - totalSold);

    }

    

    //getters setters

    function setTokenDistribution(

        uint ForSale,

        uint InstantSale,

        uint BusinessDev,

        uint CoreTeam,

        uint Investor1) onlyOwner public {

            vars.ForSale = ForSale;

            vars.InstantSale = InstantSale;

            vars.BusinessDev = BusinessDev;

            vars.CoreTeam = CoreTeam;

            vars.Investor1 = Investor1;

        }

        

    function setLockup(uint lockup_tokenSale_Time,

        uint lockup_instantSale_Time,

        uint lockup_BusinessDev_Time,

        uint lockup_CoreTeam_Time,

        uint lockup_Investor1_Time) onlyOwner public{

            vars.lockup_tokenSale_Time = lockup_tokenSale_Time;

            vars.lockup_instantSale_Time = lockup_instantSale_Time;

            vars.lockup_BusinessDev_Time = lockup_BusinessDev_Time;

            vars.lockup_CoreTeam_Time = lockup_CoreTeam_Time;

            vars.lockup_Investor1_Time = lockup_Investor1_Time;

        }

        

    function setstartDate(uint _date) onlyOwner public {

        vars.startDate=_date;              

    }

    function setendDate(uint _date) onlyOwner public {

        vars.endDate=_date;              

    }

    function setInstantSale_Address(address _InstantSale_Address) onlyOwner public {

        require(_InstantSale_Address != address(0));

        InstantSale_Address=_InstantSale_Address;              

    }

    function setA5T_Token_Address(address _A5T_Token_Address) onlyOwner public {

        require(_A5T_Token_Address != address(0));

        A5T_Token_Address=_A5T_Token_Address;              

    }

    function setBusinessDev_Address(address _address) onlyOwner public {

        require(_address != address(0));

        BusinessDev_Address=_address;              

    }

    function setCoreTeam_Address(address _address) onlyOwner public {

        require(_address != address(0));

        CoreTeam_Address=_address;              

    }

    function setInvestor1_Address(address _address) onlyOwner public {

        require(_address != address(0));

        Investor1_Address=_address;              

    }

    function getOwner() public view returns(address _oAddress) {

        return _owner;

    }

    modifier onlyOwner(){

        require(msg.sender==_owner,'Not Owner');

        _;

    }  

    function getOwnerBalance() public view returns(uint256 _balance) {

        return _owner.balance;

    }

    function getContractBalance() public view returns(uint256 _contractBalance) {    

        return address(this).balance;

    }

    //Protect the pool in case of hacking

    function transferOwnership(address payable _newOwner) external {

        require(msg.sender == _owner);

        require(_newOwner != address(0) && _newOwner != _owner);

        _owner = _newOwner;

        

    }

    function kill() public {

        require (msg.sender == _owner,'Not Owner');

        _owner.transfer(address(this).balance);

        selfdestruct(_owner);

    }

    function transferFund(uint256 amount) public {

        require (msg.sender == _owner,'Not Owner');

        require(amount<=address(this).balance,'exceed contract balance');

        _owner.transfer(amount);

    }

}





contract A5TToken

{

    function getOwner() public returns(address);

    function transferFrom(address, address, uint256) public returns (bool);

    function balanceOf(address) external view returns (uint256);

    function allowance(address _owner, address _spender) public returns (uint256);

    function transfer(address _to, uint256 _value) public returns (bool);

    function gettotalSupply() public returns(uint256);

    function burn(uint256 amount) public;

    function burnFrom(address account, uint256 amount) public ;

}

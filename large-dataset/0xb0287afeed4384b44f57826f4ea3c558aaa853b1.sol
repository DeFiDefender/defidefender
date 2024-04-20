// 06.08.2019

// \u043a\u043e\u0434 \u0430\u0434\u0430\u043f\u0442\u0438\u0440\u043e\u0432\u0430\u043d \u043f\u043e\u0434 \u0432\u0435\u0440\u0441\u0438\u044e \u043a\u043e\u043c\u043f\u0438\u043b\u044f\u0442\u043e\u0440\u0430 0.5.1

// \u0418\u0437\u043c\u0435\u043d\u0435\u043d\u0438\u044f \u0432 \u0432\u0435\u0441\u0440\u0438\u0438 13



//    uint256 public INITIAL_SUPPLY = 10000 * 1 ether;

//    uint public constant RPESALE_TOKEN_SUPPLY_LIMIT = 1000 * 1 ether;

//    uint public constant RPEICO_TOKEN_SUPPLY_LIMIT = 2000 * 1 ether;



// \u0442\u0435\u043a\u0443\u0449\u0430\u044f \u0432\u0435\u0440\u0441\u0438\u044f - 12 \u0442\u0435\u0441\u0442\u043e\u0432\u0430\u044f. \u0443\u043c\u0435\u043d\u044c\u0448\u0435\u043d\u044b \u043e\u0431\u044a\u0435\u043c\u044b!!!!

// \u0434\u043e\u0431\u0430\u0432\u043b\u0435\u043d\u044b \u043a\u043e\u043c\u043c\u0435\u043d\u0442\u044b \u0432 require

// \u0438\u0441\u043f\u0440\u0430\u0432\u043b\u0435\u043d\u0430 \u0444-\u0438\u044f refund

// \u0431\u043b\u043e\u043a\u0438\u0440\u043e\u0432\u043a\u0438 \u043f\u0435\u0440\u0435\u0432\u043e\u0434\u043e\u0432 \u0441\u0434\u0435\u043b\u0430\u043d\u044b \u043d\u0430 \u0432\u0435\u0441\u044c \u043f\u0435\u0440\u0438\u043e\u0434 ICO \u0438 Crowdsale

// \u0434\u043e\u0431\u0430\u0432\u043b\u0435\u043d \u043b\u043e\u0433 \u0432 refund

// \u0434\u043e\u0431\u0430\u0432\u043b\u0435\u043d\u044b \u0444\u0443\u043d\u043a\u0446\u0438\u0438 \u0431\u043b\u043e\u043a\u0438\u0440\u043e\u0432\u043a\u0438\\\u0440\u0430\u0437\u0431\u043b\u043e\u043a\u0438\u0440\u043e\u0432\u043a\u0438 \u0432\u043d\u0435\u0448\u043d\u0438\u0445 \u043f\u0435\u0440\u0435\u0432\u043e\u0434\u043e\u0432 \u0432 \u0440\u0430\u0431\u043e\u0447\u0435\u043c \u0440\u0435\u0436\u0438\u043c\u0435 \u043a\u043e\u043d\u0442\u0440\u0430\u043a\u0442\u0430

// \u0434\u043b\u044f \u0432\u043e\u0437\u043c\u043e\u0436\u043d\u043e\u0441\u0442\u0438 \u0440\u0430\u0441\u0447\u0435\u0442\u0430 \u0434\u0438\u0432\u0438\u0434\u0435\u043d\u0434\u043e\u0432

// CRYPT Token = > CRYPT

// CRTT => CRT

// \u0438\u0437\u043c\u0435\u043d\u0435\u043d\u044b \u0444-\u0446\u0438\u0438 \u0440\u0430\u0437\u0434\u0430\u0447\u0438 \u0442\u043e\u043a\u0435\u043d\u043e\u0432. \u0431\u0435\u0441\u043f\u043b\u0430\u0442\u043d\u043e \u0440\u0430\u0437\u0434\u0430\u0442\u044c \u0442\u043e\u043a\u0435\u043d\u044b \u043c\u043e\u0436\u043d\u043e \u0442\u043e\u043b\u044c\u043a\u043e \u0441 4-\u0445 \u0437\u0430\u0440\u0435\u0437\u0435\u0440\u0432\u0438\u0440\u043e\u0432\u0430\u043d\u043d\u044b\u0445 \u0430\u0434\u0440\u0435\u0441\u043e\u0432

// \u0432 fallback \u0444\u0443\u043d\u043a\u0446\u0438\u044e \u0434\u043e\u0431\u0430\u0432\u043b\u0435\u043d \u0431\u043b\u043e\u043a \u0440\u0430\u0441\u0447\u0435\u0442\u0430 \u0434\u043b\u0438\u0442\u0435\u043b\u044c\u043d\u043e\u0441\u0442\u0438 \u043f\u0435\u0440\u0438\u043e\u0434\u043e\u0432, \u043f\u0430\u0443\u0437 \u043c\u0435\u0436\u0434\u0443 \u043f\u0435\u0440\u0438\u043e\u0434\u0430\u043c\u0438 

// \u0438 \u0430\u0432\u0442\u043e\u043c\u0430\u0442\u0438\u0447\u0435\u0441\u043a\u043e\u0439 \u0441\u043c\u0435\u043d\u044b \u043f\u0435\u0440\u0438\u043e\u0434\u043e\u0432 \u043f\u043e \u043e\u043a\u043e\u043d\u0447\u0430\u043d\u0438\u0438 \u043a\u043e\u043d\u0442\u0440\u043e\u043b\u044c\u043d\u043e\u0433\u043e \u0432\u0440\u0435\u043c\u0435\u043d\u0438 (\u043f\u0430\u0443\u0437\u0430=30 \u0441\u0443\u0442\u043e\u043a)

// \u0438\u0437\u043c\u0435\u043d\u0435\u043d \u043f\u043e\u0440\u044f\u0434\u043e\u043a \u0440\u0430\u0441\u0447\u0435\u0442\u0430 \u043b\u0438\u043c\u0438\u0442\u0430 \u043f\u0440\u0438 \u043f\u0440\u0438\u0435\u043c\u0435 \u0441\u0440\u0435\u0434\u0441\u0442\u0432 - \u0443\u0447\u0438\u0442\u044b\u0432\u0430\u044e\u0442\u0441\u044f \u0432\u0445\u043e\u0434\u044f\u0449\u0438\u0435 \u0441\u0440\u0435\u0434\u0441\u0442\u0432\u0430

// \u0438\u0437\u043c\u0435\u043d\u0435\u043d \u043f\u043e\u0440\u044f\u0434\u043e\u043a \u0440\u0430\u0441\u0447\u0435\u0442 \u043b\u0438\u043c\u0438\u0442\u0430 \u0432 \u043f\u0435\u0440\u0432\u044b\u0435 \u0441\u0443\u0442\u043a\u0438 Pre-ICO - \u043b\u0438\u043c\u0438\u0442 \u0438\u0434\u0435\u0442 \u043d\u0435 \u043d\u0430 \u0442\u0440\u0430\u043d\u0437\u0430\u043a\u0446\u0438\u044e, \u0430 \u043d\u0430 \u0431\u0430\u043b\u0430\u043d\u0441 \u043f\u043e\u043b\u044c\u0437\u043e\u0432\u0430\u0442\u0435\u043b\u044f \u043f\u043b\u044e\u0441 \u0435\u0433\u043e \u043f\u043b\u0430\u0442\u0435\u0436

// \u043e\u0442\u043a\u043b\u044e\u0447\u0435\u043d\u0430 \u0432\u043e\u0437\u043c\u043e\u0436\u043d\u043e\u0441\u0442\u044c \u043f\u0440\u0438\u0435\u043c\u0430 \u0441\u0440\u0435\u0434\u0441\u0442\u0432 \u0438 \u043f\u0440\u043e\u0434\u0430\u0436\u0438 \u0442\u043e\u043a\u0435\u043d\u043e\u0432 \u043f\u043e \u043e\u043a\u043e\u043d\u0447\u0430\u043d\u0438\u044e Crowdsale(\u043d\u0430 \u0441\u0442\u0430\u0434\u0438\u0438 WorkTime)

// \u0434\u043e\u0431\u0430\u0432\u043b\u0435\u043d\u0430 \u0444\u0443\u043d\u043a\u0446\u0438\u044f \u0432\u044b\u0432\u043e\u0434\u0430 \u0432\u0441\u0435\u0445 \u0442\u043e\u043a\u0435\u043d\u043e\u0432 \u0441 \u0431\u0430\u043b\u0430\u043d\u0441\u0430 \u043a\u043e\u043d\u0442\u0440\u0430\u043a\u0442\u0430 \u043d\u0430 \u0430\u0434\u0440\u0435\u0441 \u0441\u043e\u0431\u0441\u0442\u0432\u0435\u043d\u043d\u0438\u043a\u0430 \u043f\u043e \u043e\u043a\u043e\u043d\u0447\u0430\u043d\u0438\u0438 Crowdsale.



//- \u041b\u0438\u043c\u0438\u0442\u044b \u043f\u043e \u043e\u0431\u044a\u0435\u043c\u0443 0.4 ETH = 2 000 \u0442\u043e\u043a\u0435\u043d\u043e\u0432

//- \u041b\u0438\u043c\u0438\u0442\u044b \u043f\u043e \u0432\u0440\u0435\u043c\u0435\u043d\u0438 1 \u0421\u0423\u0422\u041a\u0418 

//- \u041f\u0430\u0443\u0437\u0430 \u043c\u0435\u0436\u0434\u0443 \u0441\u0442\u0430\u0434\u0438\u044f\u043c\u0438 - 1 \u0441\u0443\u0442\u043a\u0438 

//* \u041c\u0418\u041d\u0418\u041c\u0410\u041b\u042c\u041d\u042b\u0419 \u041f\u041b\u0410\u0422\u0415\u0416 \u041d\u0410 PRESALE 0.1 ETH 

//* \u041c\u0410\u041a\u0421\u0418\u041c\u0410\u041b\u042c\u041d\u042b\u0419 \u041f\u041b\u0410\u0422\u0415\u0416 \u041d\u0410 PREICO 0.1 ETH

// \u0412\u0441\u0435\u0433\u043e \u0432\u044b\u043f\u0443\u0449\u0435\u043d\u043e = 50 000 \u0442\u043e\u043a\u0435\u043d\u043e\u0432

// HardCap 40% = 20 000 \u0442\u043e\u043a\u0435\u043d\u043e\u0432 = 4 ETH



pragma solidity ^0.5.1;





contract ERC20Basic {

    function totalSupply() public view returns (uint256);

    function balanceOf(address who) public view returns (uint256);

    function transfer(address to, uint256 value) public returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

}



contract ERC20 is ERC20Basic {

    function allowance(address owner, address spender)

        public view returns (uint256);



    function transferFrom(address from, address to, uint256 value)

        public returns (bool);



    function approve(address spender, uint256 value) public returns (bool);

    event Approval(

    address indexed owner,

    address indexed spender,

    uint256 value

    );

}







library SafeMath {



    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {

        if (a == 0) {

            return 0;

        }

        c = a * b;

        assert(c / a == b);

        return c;

    }



    function div(uint256 a, uint256 b) internal pure returns (uint256) {

        return a / b;

    }



    function sub(uint256 a, uint256 b) internal pure returns (uint256) {

        assert(b <= a);

        return a - b;

    }



    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {

        c = a + b;

        assert(c >= a);

        return c;

    }

}







contract BasicToken is ERC20Basic {

    using SafeMath for uint256;



    mapping(address => uint256) balances;



    uint256 totalSupply_;



    function totalSupply() public view returns (uint256) {

        return totalSupply_;

    }



    function transfer(address _to, uint256 _value) public returns (bool) {

        require(_to != address(0));

        require(_value <= balances[msg.sender]);



        balances[msg.sender] = balances[msg.sender].sub(_value);

        balances[_to] = balances[_to].add(_value);

        emit Transfer(msg.sender, _to, _value);

        return true;

    }

  

    function balanceOf(address _owner) public view returns (uint256) {

        return balances[_owner];

    }



}





contract StandardToken is ERC20, BasicToken {



    mapping (address => mapping (address => uint256)) internal allowed;



    function transferFrom(

        address _from,

        address _to,

        uint256 _value

    )

        public

        returns (bool)

    {

        require(_to != address(0));

        require(_value <= balances[_from]);

        require(_value <= allowed[_from][msg.sender]);



        balances[_from] = balances[_from].sub(_value);

        balances[_to] = balances[_to].add(_value);

        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);

        emit Transfer(_from, _to, _value);

        return true;

    }





    function approve(address _spender, uint256 _value) public returns (bool) {

        allowed[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;

    }





    function allowance(

        address _owner,

        address _spender

    )

    public

    view

    returns (uint256)

    {

        return allowed[_owner][_spender];

    }





    function increaseApproval(

        address _spender,

        uint _addedValue

    )

    public

    returns (bool)

    {

        allowed[msg.sender][_spender] = (

        allowed[msg.sender][_spender].add(_addedValue));

        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);

        return true;

    }





    function decreaseApproval(

        address _spender,

        uint _subtractedValue

    )

        public

        returns (bool)

    {

        uint oldValue = allowed[msg.sender][_spender];

        if (_subtractedValue > oldValue) {

            allowed[msg.sender][_spender] = 0;

        } else {

            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);

        }

        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);

        return true;

    }



}





contract CRYPTToken is StandardToken {

    string public constant name = "CRYPT";

    string public constant symbol = "CRT";

    uint32 public constant decimals = 18;

    uint256 public INITIAL_SUPPLY = 10000 * 1 ether;

    address public CrowdsaleAddress;

    bool public lockTransfers = false;



    constructor(address _CrowdsaleAddress) public {

    

        CrowdsaleAddress = _CrowdsaleAddress;

        totalSupply_ = INITIAL_SUPPLY;

        balances[msg.sender] = INITIAL_SUPPLY;      

    }

  

    modifier onlyOwner() {

        // only Crowdsale contract

        require(msg.sender == CrowdsaleAddress);

        _;

    }



     // Override

    function transfer(address _to, uint256 _value) public returns(bool){

        if (msg.sender != CrowdsaleAddress){

            require(!lockTransfers, "Transfers are prohibited in ICO and Crowdsale period");

        }

        return super.transfer(_to,_value);

    }



     // Override

    function transferFrom(address _from, address _to, uint256 _value) public returns(bool){

        if (msg.sender != CrowdsaleAddress){

            require(!lockTransfers, "Transfers are prohibited in ICO and Crowdsale period");

        }

        return super.transferFrom(_from,_to,_value);

    }

     

    function acceptTokens(address _from, uint256 _value) public onlyOwner returns (bool){

        require (balances[_from] >= _value);

        balances[_from] = balances[_from].sub(_value);

        balances[CrowdsaleAddress] = balances[CrowdsaleAddress].add(_value);

        emit Transfer(_from, CrowdsaleAddress, _value);

        return true;

    }



    function lockTransfer(bool _lock) public onlyOwner {

        lockTransfers = _lock;

    }







    function() external payable {

        // The token contract don`t receive ether

        revert();

    }  

}





contract Ownable {

    address public owner;

    address candidate;



    constructor() public {

        owner = msg.sender;

    }



    modifier onlyOwner() {

        require(msg.sender == owner);

        _;

    }





    function transferOwnership(address newOwner) public onlyOwner {

        require(newOwner != address(0));

        candidate = newOwner;

    }



    function confirmOwnership() public {

        require(candidate == msg.sender);

        owner = candidate;

        delete candidate;

    }



}



contract HoldProjectAddress {

    //Address where stored command tokens- 50%

    //Withdraw tokens allowed only after 1 year

    function() external payable {

        // The contract don`t receive ether

        revert();

    } 

}



contract HoldBountyAddress {

    //Address where stored bounty tokens- 1%

    //Withdraw tokens allowed only after 40 days

    function() external payable {

        // The contract don`t receive ether

        revert();

    } 

}



contract HoldAdvisorsAddress {

    //Address where stored advisors tokens- 1%

    //Withdraw tokens allowed only after 40 days

    function() external payable {

        // The contract don`t receive ether

        revert();

    } 

}



contract HoldAdditionalAddress {

    //Address where stored additional tokens- 8%

    function() external payable {

        // The contract don`t receive ether

        revert();

    } 

}



contract Crowdsale is Ownable {

    using SafeMath for uint; 

    event LogStateSwitch(State newState);

    event Withdraw(address indexed from, address indexed to, uint256 amount);

    event Refunding(address indexed to, uint256 amount);

    mapping(address => uint) public crowdsaleBalances;



    address myAddress = address(this);

    uint64 preSaleStartTime = 0;

    uint64 preICOStartTime = 0;

    uint64 crowdSaleStartTime = 0;

    uint public  saleRate = 5000;  //tokens for 1 ether

    uint256 public soldTokens = 0;



    // 50 000 000 sold tokens limit for Pre-Sale

    uint public constant RPESALE_TOKEN_SUPPLY_LIMIT = 1000 * 1 ether;





    // 100 000 000 sold tokens limit for Pre-ICO

    uint public constant RPEICO_TOKEN_SUPPLY_LIMIT = 2000 * 1 ether;



    // 40 000 000 tokens soft cap (otherwise - refund)

    // equal 8 000 eth





    uint public constant TOKEN_SOFT_CAP = 2000 * 1 ether;



    

    CRYPTToken public token = new CRYPTToken(myAddress);

    

    // New address for hold tokens

    HoldProjectAddress public holdAddress1 = new HoldProjectAddress();

    HoldBountyAddress public holdAddress2 = new HoldBountyAddress();

    HoldAdvisorsAddress public holdAddress3 = new HoldAdvisorsAddress();

    HoldAdditionalAddress public holdAddress4 = new HoldAdditionalAddress();



    // Create state of contract

    enum State { 

        Init,    

        PreSale, 

        PreICO,  

        CrowdSale,

        Refunding,

        WorkTime

    }

        

    State public currentState = State.Init;



    modifier onlyInState(State state){ 

        require(state==currentState); 

        _; 

    }



    constructor() public {

        uint256 TotalTokens = token.INITIAL_SUPPLY().div(1 ether);

        // distribute tokens

        // Transer tokens to project address.  (50%)

        giveTokens(address(holdAddress1), TotalTokens.div(2));

        // Transer tokens to bounty address.  (1%)

        giveTokens(address(holdAddress2), TotalTokens.div(100));

        // Transer tokens to advisors address. (1%)

        giveTokens(address(holdAddress3), TotalTokens.div(100));

        // Transer tokens to additional address. (8%)

        giveTokens(address(holdAddress4), TotalTokens.div(100).mul(8));

        

    }



    function returnTokensFromHoldProjectAddress(uint256 _value) internal returns(bool){

        // the function take tokens from HoldProjectAddress to contract

        // only after 1 year

        // the sum is entered in whole tokens (1 = 1 token)

        uint256 value = _value;

        require (value >= 1);

        value = value.mul(1 ether);

        require (now >= preSaleStartTime + 1 days, "only after 1 year");

        token.acceptTokens(address(holdAddress1), value); 

        return true;

    } 



    function returnTokensFromHoldBountyAddress(uint256 _value) internal returns(bool){

        // the function take tokens from HoldBountyAddress to contract

        // only after 40 days

        // the sum is entered in whole tokens (1 = 1 token)

        uint256 value = _value;

        require (value >= 1);

        value = value.mul(1 ether);

        require (now >= preSaleStartTime + 1 days, "only after 40 days");

        token.acceptTokens(address(holdAddress2), value);    

        return true;

    } 

    

    function returnTokensFromHoldAdvisorsAddress(uint256 _value) internal returns(bool){

        // the function take tokens from HoldAdvisorsAddress to contract

        // only after 40 days

        // the sum is entered in whole tokens (1 = 1 token)

        uint256 value = _value;

        require (value >= 1);

        value = value.mul(1 ether);

        require (now >= preSaleStartTime + 1 days, "only after 40 days");

        token.acceptTokens(address(holdAddress3), value);    

        return true;

    } 

    

    function returnTokensFromHoldAdditionalAddress(uint256 _value) internal returns(bool){

        // the function take tokens from HoldAdditionalAddress to contract

        // the sum is entered in whole tokens (1 = 1 token)

        uint256 value = _value;

        require (value >= 1);

        value = value.mul(1 ether);

        token.acceptTokens(address(holdAddress4), value);    

        return true;

    }     

    

    function giveTokens(address _newInvestor, uint256 _value) internal {

        require (_newInvestor != address(0));

        require (_value >= 1);

        uint256 value = _value;

        value = value.mul(1 ether);

        token.transfer(_newInvestor, value);

    }  

    

    function giveBountyTokens(address _newInvestor, uint256 _value) public onlyOwner {

        // the sum is entered in whole tokens (1 = 1 token)

        if (returnTokensFromHoldBountyAddress(_value)){

            giveTokens(_newInvestor, _value);

        }

    }



    function giveProjectTokens(address _newInvestor, uint256 _value) public onlyOwner {

        // the sum is entered in whole tokens (1 = 1 token)



        if (returnTokensFromHoldProjectAddress(_value)){

            giveTokens(_newInvestor, _value);

        }

    }



    function giveAdvisorsTokens(address _newInvestor, uint256 _value) public onlyOwner {

        // the sum is entered in whole tokens (1 = 1 token)

        if (returnTokensFromHoldAdvisorsAddress(_value)){

            giveTokens(_newInvestor, _value);

        }

    }



    function giveAdditionalTokens(address _newInvestor, uint256 _value) public onlyOwner {

        // the sum is entered in whole tokens (1 = 1 token)

        if (returnTokensFromHoldAdditionalAddress(_value)){

            giveTokens(_newInvestor, _value);

        }

    }



    function withdrawAllTokensFromBalance() public onlyOwner {

        require(currentState == State.WorkTime || currentState == State.Refunding,"This function is accessable only in WorkTime or Refunding");

        uint value = token.balanceOf(myAddress);

        token.transfer(msg.sender, value);

    }



    function setState(State _state) internal {

        currentState = _state;

        emit LogStateSwitch(_state);

    }



    function startPreSale() public onlyOwner onlyInState(State.Init) {

        setState(State.PreSale);

        preSaleStartTime = uint64(now);

        token.lockTransfer(true);

    }



    function startPreICO() public onlyOwner onlyInState(State.PreSale) {

        // PreSale minimum 10 days

        require (now >= preSaleStartTime + 1 days, "Mimimum period Pre-Sale is 10 days");

        setState(State.PreICO);

        preICOStartTime = uint64(now);

    }

     

    function startCrowdSale() public onlyOwner onlyInState(State.PreICO) {

        // Pre-ICO minimum 15 days

        require (now >= preICOStartTime + 1 days, "Mimimum period Pre-ICO is 15 days");

        setState(State.CrowdSale);

        crowdSaleStartTime = uint64(now);

    }

    

    function finishCrowdSale() public onlyOwner onlyInState(State.CrowdSale) {

        // CrowdSale minimum 30 days

        // Attention - function not have reverse!



        require (now >= crowdSaleStartTime + 1 days, "Mimimum period CrowdSale is 30 days");

        // test coftcap

        if (soldTokens < TOKEN_SOFT_CAP) {

            // softcap don"t accessable - refunding

            setState(State.Refunding);

        } else {

            // All right! CrowdSale is passed. WithdrawProfit is accessable

            setState(State.WorkTime);

            token.lockTransfer(false);

        }

    }





    function blockExternalTransfer() public onlyOwner onlyInState (State.WorkTime){

        //Blocking all external token transfer for dividends calculations

        require (token.lockTransfers() == false);

        token.lockTransfer(true);

    }



    function unBlockExternalTransfer() public onlyOwner onlyInState (State.WorkTime){

        //Unblocking all external token transfer

        require (token.lockTransfers() == true);

        token.lockTransfer(false);

    }





    function calcBonus () public view returns(uint256) {

        // calculation bonus

        uint256 actualBonus = 0;

        if (currentState == State.PreSale){

            actualBonus = 20;

        }

        if (currentState == State.PreICO){

            actualBonus = 10;

        }

        return actualBonus;

    }



 

    function saleTokens() internal {

        require(currentState != State.Init, "Contract is init, do not accept ether."); 

        require(currentState != State.Refunding, "Contract is refunding, do not accept ether.");

        require(currentState != State.WorkTime, "Contract is WorkTime, do not accept ether.");

        //calculation length of periods, pauses, auto set next stage

        if (currentState == State.PreSale) {

            if ((uint64(now) > preSaleStartTime + 1 days) && (uint64(now) <= preSaleStartTime + 2 days)){

                require (false, "It is pause after PreSale stage - contract do not accept ether");

            }

            if (uint64(now) > preSaleStartTime + 2 days){

                setState(State.PreICO);

                preICOStartTime = uint64(now);

            }

        }



        if (currentState == State.PreICO) {

            if ((uint64(now) > preICOStartTime + 1 days) && (uint64(now) <= preICOStartTime + 2 days)){

                require (false, "It is pause after PreICO stage - contract do not accept ether");

            }

            if (uint64(now) > preICOStartTime + 2 days){

                setState(State.CrowdSale);

                crowdSaleStartTime = uint64(now);

            }

        }        

        

        if (currentState == State.CrowdSale) {

            if ((uint64(now) > crowdSaleStartTime + 1 days) && (uint64(now) <= crowdSaleStartTime + 2 days)){

                require (false, "It is pause after CrowdSale stage - contract do not accept ether");

            }

            if (uint64(now) > crowdSaleStartTime + 2 days){

                // autofinish CrowdSale stage

                if (soldTokens < TOKEN_SOFT_CAP) {

                    // softcap don"t accessable - refunding

                    setState(State.Refunding);

                } else {

                    // All right! CrowdSale is passed. WithdrawProfit is accessable

                    setState(State.WorkTime);

                    token.lockTransfer(false);

                }

            }

        }        

        

        uint tokens = saleRate.mul(msg.value);

        if (currentState == State.PreSale) {

            require (RPESALE_TOKEN_SUPPLY_LIMIT > soldTokens.add(tokens), "HardCap of Pre-Sale is excedded."); 

            require (msg.value >= 1 ether / 10, "Minimum 20 ether for transaction all Pre-Sale period");

        }

        if (currentState == State.PreICO) {

            require (RPEICO_TOKEN_SUPPLY_LIMIT > soldTokens.add(tokens), "HardCap of Pre-ICO is excedded.");

            if (uint64(now) < preICOStartTime + 1 days){

                uint limitPerUser = crowdsaleBalances[msg.sender] + msg.value;

                require (limitPerUser <= 1 ether / 10, "Maximum is 20 ether for user in first day of Pre-ICO");

            }

        }

        tokens = tokens.add(tokens.mul(calcBonus()).div(100));

        crowdsaleBalances[msg.sender] = crowdsaleBalances[msg.sender].add(msg.value);

        token.transfer(msg.sender, tokens);

        soldTokens = soldTokens.add(tokens);

    }

 

    function refund() public payable{

        require(currentState == State.Refunding, "Only for Refunding stage.");

        // refund ether to investors

        uint value = crowdsaleBalances[msg.sender]; 

        crowdsaleBalances[msg.sender] = 0; 

        msg.sender.transfer(value);

        emit Refunding(msg.sender, value);

    }

    

    function withdrawProfit (address payable _to, uint256 _value) public onlyOwner payable {

    // withdrawProfit - only if coftcap passed

        require (currentState == State.WorkTime, "Contract is not at WorkTime stage. Access denied.");

        require (myAddress.balance >= _value);

        require(_to != address(0));

        _to.transfer(_value);

        emit Withdraw(msg.sender, _to, _value);

    }





    function() external payable {

        saleTokens();

    }    

 

}

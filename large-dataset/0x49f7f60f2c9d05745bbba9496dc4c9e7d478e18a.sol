pragma solidity ^0.7.0;

//SPDX-License-Identifier: UNLICENSED

library SafeMath {

    function add(uint a, uint b) internal pure returns (uint c) {

        c = a + b;

        require(c >= a);

    }

    function sub(uint a, uint b) internal pure returns (uint c) {

        require(b <= a);

        c = a - b;

    }

    function mul(uint a, uint b) internal pure returns (uint c) {

        c = a * b;

        require(a == 0 || c / a == b);

    }

    function div(uint a, uint b) internal pure returns (uint c) {

        require(b > 0);

        c = a / b;

    }

}



interface IERC20 {

    function totalSupply() external view returns (uint);

    function balanceOf(address who) external view returns (uint);

    function allowance(address owner, address spender) external view returns (uint);

    function transfer(address to, uint value) external returns (bool);

    function approve(address spender, uint value) external returns (bool);

    function transferFrom(address from, address to, uint value) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);

    event Approval(address indexed owner, address indexed spender, uint value);

}

interface IUNIv2 {

    function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) 

    external 

    payable 

    returns (uint amountToken, uint amountETH, uint liquidity);

}



contract TE is IERC20 {

    

    using SafeMath for uint;

    IUNIv2 uniswap = IUNIv2(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);



    string public symbol;

    string public name;

    uint8 public decimals;

    uint _totalSupply;

    uint public RATE;

    uint public DENOMINATOR;

    uint public tokensBought;

    bool public isStopped = false;

    bool public canRefund = false;

    bool public devClaimed = false;

    bool public moonMissionStarted = false;

    uint public canRefundTime;

    uint public tokensForUniswap = 50 ether;

    

    address payable owner;

    uint256 public ethAmount = 1 ether;

    mapping(address => uint) balances;

    mapping(address => mapping(address => uint)) allowed;

    mapping(address => uint) bought;



    modifier onlyWhenRunning {

        require(!isStopped);

        _;

    }



     modifier onlyOwner() {

        require(msg.sender == owner, "You are not the owner");

        _;

    }

    

    constructor() {

        owner = msg.sender; 

        symbol = "TE";

        name = "TheExperiment";

        decimals = 18;

        _totalSupply = 150 ether;

        balances[address(this)] = _totalSupply;

         RATE = 2;         // 2 TE per ETH

        DENOMINATOR = 1;    // 1 ETH = 2 TE

        emit Transfer(address(0), address(this), _totalSupply);

    }

    

    

    receive() external payable {

        

        buyTokens();

    }

    function pauseUnpausePresale(bool _isStopped) external onlyOwner{

        isStopped = _isStopped;

    }

    function claimDev() external onlyOwner {

       require(!devClaimed);

       uint256 amount = address(this).balance * 20 / 100;

       owner.transfer(amount);

       devClaimed = true;

    }

    function superDuperEmergencyAllowUsersToGetTheirETHbackFromTheContractAfterTwoHours() external onlyOwner {

        canRefund = true;

        canRefundTime = block.timestamp + 10 minutes; 

    } 

    

    function refundCaller() external {

        require(canRefund == true);

        require(block.timestamp >= canRefundTime);

        require(address(this).balance >= ethAmount);

        if (bought[msg.sender] == ethAmount){

           msg.sender.transfer(ethAmount);

           bought[msg.sender] = 0;

        }

    }

    



    function buyTokens() onlyWhenRunning public payable {

        require(msg.value == ethAmount, "You did not sent exactly 1 ETH");

        require(tokensBought < 100 ether, "Hard cap reached");

        require(bought[msg.sender] == 0 , "You already bought");

        uint tokens = msg.value.mul(RATE).div(DENOMINATOR);

        require(balances[address(this)] >= tokens);

        balances[msg.sender] = balances[msg.sender].add(tokens);

        balances[address(this)] = balances[address(this)].sub(tokens);

        bought[msg.sender] = bought[msg.sender].add(msg.value);

        tokensBought = tokensBought.add(tokens);

        emit Transfer(address(this), msg.sender, tokens);

    }

    

    function isUserBoughtInPresale(address user) external view returns(bool){

        if (bought[user] == ethAmount)

            return true;

        else

            return false;

    }

    

    function totalSupply() public override view returns (uint) {

        return _totalSupply;

    }





   

    function balanceOf(address tokenOwner) public override view returns (uint balance) {

        return balances[tokenOwner];

    }





   

    function transfer(address to, uint tokens) public override returns (bool success) {

        require(tokens > 0, "You can't transfer 0 tokens");

        require(balances[msg.sender] >= tokens, "Not enough tokens");

        

        balances[msg.sender] = balances[msg.sender].sub(tokens);

        balances[to] = balances[to].add(tokens);

        emit Transfer(msg.sender, to, tokens);

        return true;

    }





    

    function approve(address spender, uint tokens) public override returns (bool success) {

        require(spender != address(0));

        require(tokens > 0, "You can't approve 0 tokens");

        

        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);

        return true;

    }





    

    function transferFrom(address from, address to, uint tokens) public override returns (bool success) {

        require(from != address(0));

        require(tokens > 0, "You can't transfer 0 tokens");

        require(balances[from] >= tokens, "Not enough tokens");

        require(allowed[from][msg.sender] >= tokens);

        

        balances[from] = balances[from].sub(tokens);

        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);

        balances[to] = balances[to].add(tokens);

        emit Transfer(from, to, tokens);

        return true;

    }





   

    function allowance(address tokenOwner, address spender) public override view returns (uint remaining) {

        return allowed[tokenOwner][spender];

    }

    

    

    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {

        require(_spender != address(0));

        

        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);

        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);

        return true;

    }

    

    

    

    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {

        require(_spender != address(0));

        

        uint oldValue = allowed[msg.sender][_spender];

        if (_subtractedValue > oldValue) {

            allowed[msg.sender][_spender] = 0;

        } else {

            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);

        }

        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);

        return true;

    }

    

    function moonMissionStart() external onlyOwner {

        require(devClaimed == true);

        require(!moonMissionStarted);

        uint256 ETH = address(this).balance;

        uint tokensToBurn = balanceOf(address(this)).sub(tokensForUniswap);



        this.approve(address(uniswap), tokensForUniswap);

        uniswap.addLiquidityETH

        { value: ETH }

        (

            address(this),

            tokensForUniswap,

            tokensForUniswap,

            ETH,

            address(0),

            block.timestamp + 5 minutes

        );

        if (tokensToBurn > 0) {

          balances[address(this)] = balances[address(this)].sub(tokensToBurn);

          emit Transfer(address(this), address(0), tokensToBurn);

        }

        if(!isStopped)

            isStopped = true;

            

        moonMissionStarted = true;

   }

    

}

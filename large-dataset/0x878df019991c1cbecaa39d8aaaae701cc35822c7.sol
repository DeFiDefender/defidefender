// ---------------------------------------------------------------------------

// Numerous on-chain indicators suggest Ethereum price is on the verge of another 2017-style bull run.

// 3 key on-chain metrics suggest Ethereum price is in a 2017-style bull run

// Everything is Happening on Ethereum'

// Crypto Investors Are Positive About Ethereum

// Bitcoin Rallies 

// ----------------------------------------------------------------------------

// Look for hidden credit inside the code! 

//

//

// By ETHSTRONGHOLD FanB!

// ----------------------------------------------------------------------------





pragma solidity ^0.4.24;



contract SafeMath {



    function safeAdd(uint a, uint b) public pure returns (uint c) {

        c = a + b;

        require(c >= a);

    }



    function safeSub(uint a, uint b) public pure returns (uint c) {

        require(b <= a);

        c = a - b;

    }



    function safeMul(uint a, uint b) public pure returns (uint c) {

        c = a * b;

        require(a == 0 || c / a == b);

    }



    function safeDiv(uint a, uint b) public pure returns (uint c) {

        require(b > 0);

        c = a / b;

    }

}





/**

Hold 25 BULLR

*/

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



contract ApproveAndCallFallBack {

    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;

}



/**

DM

*/

contract BullRToken is ERC20Interface, SafeMath {

    string public symbol;

    string public  name;

    uint8 public decimals;

    uint public _totalSupply;



    mapping(address => uint) balances;

    mapping(address => mapping(address => uint)) allowed;





    // ------------------------------------------------------------------------

    // Tg owner

    // ------------------------------------------------------------------------

    constructor() public {

        symbol = "BullR";

        name = "EthBullRun";

        decimals = 2;

        _totalSupply = 50000;

        balances[0x901aED999b034B846f50e79f727Fc7Ca05Bc187a] = _totalSupply;

        emit Transfer(address(0), 0x901aED999b034B846f50e79f727Fc7Ca05Bc187a, _totalSupply);

    }





    // ------------------------------------------------------------------------

    // Cla

    // ------------------------------------------------------------------------

    function totalSupply() public constant returns (uint) {

        return _totalSupply  - balances[address(0)];

    }





    // ------------------------------------------------------------------------

    // im BULLR Creator address

    // ------------------------------------------------------------------------

    function balanceOf(address tokenOwner) public constant returns (uint balance) {

        return balances[tokenOwner];

    }





    // ------------------------------------------------------------------------

    // Privt 

    // ------------------------------------------------------------------------

    function transfer(address to, uint tokens) public returns (bool success) {

        balances[msg.sender] = safeSub(balances[msg.sender], tokens);

        balances[to] = safeAdd(balances[to], tokens);

        emit Transfer(msg.sender, to, tokens);

        return true;

    }





    // ------------------------------------------------------------------------

    // Ke 

    // ------------------------------------------------------------------------

    function approve(address spender, uint tokens) public returns (bool success) {

        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);

        return true;

    }





    // ------------------------------------------------------------------------

    // y from

    // ------------------------------------------------------------------------

    function transferFrom(address from, address to, uint tokens) public returns (bool success) {

        balances[from] = safeSub(balances[from], tokens);

        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);

        balances[to] = safeAdd(balances[to], tokens);

        emit Transfer(from, to, tokens);

        return true;

    }





    // ------------------------------------------------------------------------

    // the

    // ------------------------------------------------------------------------

    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {

        return allowed[tokenOwner][spender];

    }





    // ------------------------------------------------------------------------

    // Owner. Solve the math!

    // a+b+c=4

    // a^2+b^2+c^2=10

    // a^3+b^3+c^3=22

    // a^4+b^4+c^4=?

    // Get it right!



    // ------------------------------------------------------------------------

    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {

        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);

        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);

        return true;

    }





    // ------------------------------------------------------------------------

    // https://t.me/bullrun_m

    // ------------------------------------------------------------------------

    function () public payable {

        revert();

    }

}

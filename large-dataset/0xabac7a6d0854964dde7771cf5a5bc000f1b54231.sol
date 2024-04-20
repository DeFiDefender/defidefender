pragma solidity ^0.4.24;



// Example. Token and crowdsale contact

// ====================================

// Crowdsale basic information:

// ------------------------------------

// Token name: Funtastic Coin

// Token symbol: FUNT

// Decimals: 18

// Total supply cap: 90,000,000 tokens

// Price: 500 tokens per 1 ether

// Bonus price 100% for 24 hours: 1000 tokens per 1 ether

// HardCap: 5000 ether

// Crowdsale duration: 7 days

// Minimal investment: 0.01 ether

// ------------------------------------



// ====================================



// ----------------------------------------------------------------------------

// Safe maths

// ----------------------------------------------------------------------------

contract SafeMath {

    function safeAdd(uint a, uint b) internal pure returns (uint c) {

        c = a + b;

        require(c >= a);

    }

    function safeSub(uint a, uint b) internal pure returns (uint c) {

        require(b <= a);

        c = a - b;

    }

    function safeMul(uint a, uint b) internal pure returns (uint c) {

        c = a * b;

        require(a == 0 || c / a == b);

        }

    function safeDiv(uint a, uint b) internal pure returns (uint c) {

        require(b > 0);

        c = a / b;

    }

}



// ----------------------------------------------------------------------------

// ERC Token Standard #20 Interface

// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md

// ----------------------------------------------------------------------------

contract ERC20Interface {

    function tokensReleased() public view returns (uint);

    function checkBalanceOf(address tokenOwner) public view returns (uint balance);

    function allowance(address tokenOwner, address spender) public view returns (uint remaining);

    function transfer(address to, uint tokens) public returns (bool success);

    function approve(address spender, uint tokens) public returns (bool success);

    function transferFrom(address from, address to, uint tokens) public returns (bool success);



    event Transfer(address indexed from, address indexed to, uint tokens);

    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

}



// ----------------------------------------------------------------------------

// Contract function to receive approval and execute function in one call

// Borrowed from MiniMeToken

// ----------------------------------------------------------------------------

contract ApproveAndCallFallBack {

    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;

}



// ----------------------------------------------------------------------------

// Owned contract

// ----------------------------------------------------------------------------

contract Owned {

    address public owner;

    address private newOwner;



    event OwnershipTransferred(address indexed _from, address indexed _to);



    constructor() public {

        owner = msg.sender;

    }



    modifier onlyOwner {

        require(msg.sender == owner);

        _;

    }



    function transferOwnership(address _newOwner) public onlyOwner {

        newOwner = _newOwner;

    }

    function acceptOwnership() public {

        require(msg.sender == newOwner);

        emit OwnershipTransferred(owner, newOwner);

        owner = newOwner;

        newOwner = address(0);

    }

}



// ----------------------------------------------------------------------------

// ERC20 Token, with the additions

// ----------------------------------------------------------------------------

contract Funtastic is ERC20Interface, Owned, SafeMath {

    string public symbol;

    string public tokenName;

    string public version = "1.1";

    uint private decimals;

    uint private _totalSupply;

    uint public startOfCrowdsale = 1607265334; // 03.09.2018 08:10 UTC   <-- CHANGE THIS

    uint public endOfCrowdsale;

    uint public hardCap;

    uint public weiRaised;

    uint public lastTransactionReceivedInWei;

    uint public bonusEnds;

    bool public stopCrowdsale;

    bool public wasCrowdsaleStoped;

    uint public numberOfContributors;



    mapping(address => uint) balances;

    mapping(address => mapping(address => uint)) allowed;



    // ------------------------------------------------------------------------

    // Constructor

    // ------------------------------------------------------------------------

    constructor() public {

        symbol = "FUNT"; // <-- CHANGE THIS

        tokenName = "Funtastic"; // <-- CHANGE THIS

        decimals = 0; // <-- CHANGE THIS

        bonusEnds = startOfCrowdsale + 60 minutes; // <-- CHANGE minutes

        endOfCrowdsale = startOfCrowdsale + 2 hours; // <-- CHANGE hours

        hardCap = 50000 ether;

    }



    // ------------------------------------------------------------------------

    // Total supply

    // ------------------------------------------------------------------------

    function tokensReleased() public view returns (uint) {

        return _totalSupply;

    }



    // ------------------------------------------------------------------------

    // Get the token balance for account `tokenOwner`

    // ------------------------------------------------------------------------

    function checkBalanceOf(address tokenOwner) public view returns (uint balance) {

        return balances[tokenOwner];

    }



    // ------------------------------------------------------------------------

    // Transfer the balance from token owner's account to `to` account

    // - Owner's account must have sufficient balance to transfer

    // - 0 value transfers are allowed

    // ------------------------------------------------------------------------

    function transfer(address to, uint tokens) public returns (bool success) {

        balances[msg.sender] = safeSub(balances[msg.sender], tokens);

        balances[to] = safeAdd(balances[to], tokens);

        emit Transfer(msg.sender, to, tokens);

        return true;

    }



    // ------------------------------------------------------------------------

    // Token owner can approve for `spender` to transferFrom(...) `tokens`

    // from the token owner's account

    //

    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md

    // recommends that there are no checks for the approval double-spend attack

    // as this should be implemented in user interfaces

    // ------------------------------------------------------------------------

    function approve(address spender, uint tokens) public returns (bool success) {

        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);

        return true;

    }



    // ------------------------------------------------------------------------

    // Transfer `tokens` from the `from` account to the `to` account

    //

    // The calling account must already have sufficient tokens approve(...)-d

    // for spending from the `from` account and

    // - From account must have sufficient balance to transfer

    // - Spender must have sufficient allowance to transfer

    // - 0 value transfers are allowed

    // ------------------------------------------------------------------------

    function transferFrom(address from, address to, uint tokens) public returns (bool success) {

        balances[from] = safeSub(balances[from], tokens);

        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);

        balances[to] = safeAdd(balances[to], tokens);

        emit Transfer(from, to, tokens);

        return true;

    }



    // ------------------------------------------------------------------------

    // Returns the amount of tokens approved by the owner that can be

    // transferred to the spender's account

    // ------------------------------------------------------------------------

    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {

        return allowed[tokenOwner][spender];

    }



    // ------------------------------------------------------------------------

    // Token owner can approve for `spender` to transferFrom(...) `tokens`

    // from the token owner's account. The `spender` contract function

    // `receiveApproval(...)` is then executed

    // ------------------------------------------------------------------------

    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {

        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);

        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);

        return true;

    }



    // ------------------------------------------------------------------------

    // Set price depending on period

    // ------------------------------------------------------------------------

    function () public payable {

        require((crowdsaleIsActive()) && (msg.value >= .01 ether));

        uint tokens;

        if (now <= bonusEnds) {

            tokens = msg.value * 1000 / 1 ether; // <-- CHANGE THIS

        } else {

            tokens = msg.value * 500 / 1 ether; // <-- CHANGE THIS

        }

        lastTransactionReceivedInWei = msg.value;

        weiRaised = safeAdd(weiRaised, lastTransactionReceivedInWei);

        _totalSupply = safeAdd(_totalSupply, tokens);

        balances[msg.sender] = safeAdd(balances[msg.sender], tokens);

        emit Transfer(address(0), msg.sender, tokens);

        owner.transfer(msg.value);

        numberOfContributors += 1; // actually counts number of contributions

    }



    // ------------------------------------------------------------------------

    // Anyone can check if the crowdsale is ON

    // ------------------------------------------------------------------------

    function crowdsaleIsActive() public view returns (bool) {

        return (

        now >= startOfCrowdsale && now <= endOfCrowdsale && weiRaised <= hardCap && stopCrowdsale == false

        );

    }



    // ------------------------------------------------------------------------

    // Owner can transfer out any accidentally sent ERC20 tokens

    // ------------------------------------------------------------------------

    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner {

        ERC20Interface(tokenAddress).transfer(owner, tokens);

    }



    // ------------------------------------------------------------------------

    // Owner can stop crowdsale anytime

    // ------------------------------------------------------------------------

    function stopCrowdsale() public onlyOwner {

        stopCrowdsale = true;

        if (stopCrowdsale = true) {

           wasCrowdsaleStoped = true;

        } else {

            wasCrowdsaleStoped = false;

        }

    }

}

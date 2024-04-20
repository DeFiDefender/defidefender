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





// ----------------------------------------------------------------------------

// ERC Token Standard #20 Interface

// ----------------------------------------------------------------------------

contract ERC20Interface {

    function totalSupply() public constant returns (uint);

    function balanceOf(address tokenOwner) public constant returns (uint balance);

    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);

    function transfer(address to, uint tokens) public returns (bool success);

    function approve(address spender, uint tokens) public returns (bool success);

    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    

    event Transfer(address indexed from, address indexed to, uint tokens);

    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

    event Blacklisted(address indexed target);

    

  event DeleteFromBlacklist(address indexed target);

  event RejectedPaymentToBlacklistedAddr(address indexed from, address indexed to, uint value);

  event RejectedPaymentFromBlacklistedAddr(address indexed from, address indexed to, uint value);

  event RejectedPaymentToLockedAddr(address indexed from, address indexed to, uint value, uint lackdatetime, uint now_);

  event RejectedPaymentFromLockedAddr(address indexed from, address indexed to, uint value, uint lackdatetime, uint now_);

  event RejectedPaymentMaximunFromLockedAddr(address indexed from, address indexed to, uint value, uint maximum, uint rate);

}





// ----------------------------------------------------------------------------

// Contract function to receive approval and execute function in one call

// ----------------------------------------------------------------------------

contract ApproveAndCallFallBack {

    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;

}





// ----------------------------------------------------------------------------

// Owned contract

// ----------------------------------------------------------------------------

contract Owned {

    address public owner;

    address public newOwner;



    event OwnershipTransferred(address indexed _from, address indexed _to);



    constructor() public {

        owner = msg.sender;

    }



    modifier onlyOwner {

        require(msg.sender == owner);

        _;

    }



    function transferOwnership(address _newOwner) public onlyOwner {

        emit OwnershipTransferred(owner, newOwner);

        //newOwner = _newOwner;

        owner = _newOwner;

    }

    /*function acceptOwnership() public {

        require(msg.sender == newOwner);

        emit OwnershipTransferred(owner, newOwner);

        owner = newOwner;

        newOwner = address(0);

    }*/

}



// ----------------------------------------------------------------------------

// ERC20 Token, with the addition of symbol, name and decimals and assisted

// token transfers

// ----------------------------------------------------------------------------

contract GNB is ERC20Interface, Owned, SafeMath {

    string public symbol;

    string public  name;

    uint8 public decimals;

    uint public _totalSupply;

    uint public startTime;



    address addr_1  = 0x8bEBCF149caa5E65E8657510b4c54EF353E5C9E8; // Private Sale

    address addr_2  = 0x1e96d03E6e2629e9D4Cb528Fb1BC316B797f140E; // Public Sale

  address addr_3  = 0x362f231EC28B281551887a72F6CC7B17605DA3Ef; // Marketing

  address addr_4  = 0xa2e1600A406de65c5f046d06494485ed1F82cb73; // R&D

  address addr_5  = 0x9e0fe45998c2ac97CCf754fcc921383FD4AfCf87; // Operations

  address addr_6  = 0xaAA36430b0E61Ef025bb8be9D2F80817Ff7f6E65; // FoundingTeam

  address addr_7  = 0x730618f31548DDD136C710115EbfD9AfFB79D132; // GNB Alliance

  address addr_8  = 0x565537a55D154a02Ad2d5745Fb7Afba71E6fD8b1; // Reserve



    mapping(address => uint) balances;

    mapping(address => mapping(address => uint)) allowed;

    mapping(address => int8) public blacklist;



    // ------------------------------------------------------------------------

    // Constructor

    // ------------------------------------------------------------------------

    constructor() public {

        symbol = "GNB";

        name = "Game Network Blockchain";

        decimals = 18;

        _totalSupply = 1000000000000000000000000000;

        

        balances[addr_1] = 75000000000000000000000000; // Private Sale

        emit Transfer(address(0), addr_1, balances[addr_1]);

         

        balances[addr_2] = 50000000000000000000000000; // Public Sale

        emit Transfer(address(0), addr_2, balances[addr_2]);

        

        balances[addr_3] = 205000000000000000000000000; // Marketing

        emit Transfer(address(0), addr_3, balances[addr_3]);

        

        balances[addr_4] = 175000000000000000000000000; // R&D

        emit Transfer(address(0), addr_4, balances[addr_4]);

        

        balances[addr_5] = 150000000000000000000000000; // Operations

        emit Transfer(address(0), addr_5, balances[addr_5]);

   

        balances[addr_6] = 105000000000000000000000000; // FoundingTeam

        emit Transfer(address(0), addr_6, balances[addr_6]);

    

        balances[addr_7] = 135000000000000000000000000; // GNB Alliance

        emit Transfer(address(0), addr_7, balances[addr_7]);

          

        balances[addr_8] = 105000000000000000000000000; // Reserve

        emit Transfer(address(0), addr_8, balances[addr_8]);

        

    }

    

    function now_() public constant returns (uint){

        return now;

    }



    // ------------------------------------------------------------------------

    // Total supply

    // ------------------------------------------------------------------------

    function totalSupply() public constant returns (uint) {

        return _totalSupply  - balances[address(0)];

    }





    // ------------------------------------------------------------------------

    // Get the token balance for account tokenOwner

    // ------------------------------------------------------------------------

    function balanceOf(address tokenOwner) public constant returns (uint balance) {

        return balances[tokenOwner];

    }

    // ------------------------------------------------------------------------

    // Transfer the balance from token owner's account to to account

    // - Owner's account must have sufficient balance to transfer

    // - 0 value transfers are allowed

    // ------------------------------------------------------------------------

  

    function transfer(address to, uint tokens) public returns (bool success) {



        

        

        if (blacklist[msg.sender] > 0) { // Accounts in the blacklist can not be withdrawn

      emit RejectedPaymentFromBlacklistedAddr(msg.sender, to, tokens);

      return false;

    } else if (blacklist[to] > 0) { // Accounts in the blacklist can not be withdrawn

      emit RejectedPaymentToBlacklistedAddr(msg.sender, to, tokens);

      return false;

    } else {

      balances[msg.sender] = safeSub(balances[msg.sender], tokens);

            balances[to] = safeAdd(balances[to], tokens);

            emit Transfer(msg.sender, to, tokens);

            return true;

    }

    

    }



    // ------------------------------------------------------------------------

    // Token owner can approve for spender to transferFrom(...) tokens

    // from the token owner's account

    // ------------------------------------------------------------------------

    function approve(address spender, uint tokens) public returns (bool success) {

        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);

        return true;

    }



    // ------------------------------------------------------------------------

    // Transfer tokens from the from account to the to account

    // 

    // The calling account must already have sufficient tokens approve(...)-d

    // for spending from the from account and

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

    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {

        return allowed[tokenOwner][spender];

    }





    // ------------------------------------------------------------------------

    // Token owner can approve for spender to transferFrom(...) tokens

    // from the token owner's account. The spender contract function

    // receiveApproval(...) is then executed

    // ------------------------------------------------------------------------

    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {

        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);

        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);

        return true;

    }





    // ------------------------------------------------------------------------

    // Don't accept ETH

    // ------------------------------------------------------------------------

    function () public payable {

        revert();

    }



    // ------------------------------------------------------------------------

    // Owner can transfer out any accidentally sent ERC20 tokens

    // ------------------------------------------------------------------------

    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {

        return ERC20Interface(tokenAddress).transfer(owner, tokens);

    }

    

    // ------------------------------------------------------------------------

    // Owner can add an increase total supply.

    // ------------------------------------------------------------------------

  function totalSupplyIncrease(uint256 _supply) public onlyOwner{

    _totalSupply = _totalSupply + _supply;

    balances[msg.sender] = balances[msg.sender] + _supply;

    emit Transfer(address(0), msg.sender, _supply);

  }

  

  // ------------------------------------------------------------------------

    // Owner can add blacklist the wallet address.

    // ------------------------------------------------------------------------

  function blacklisting(address _addr) public onlyOwner{

    blacklist[_addr] = 1;

    emit Blacklisted(_addr);

  }

  

  

  // ------------------------------------------------------------------------

    // Owner can delete from blacklist the wallet address.

    // ------------------------------------------------------------------------

  function deleteFromBlacklist(address _addr) public onlyOwner{

    blacklist[_addr] = -1;

    emit DeleteFromBlacklist(_addr);

  }

  

  function _burn(address account, uint256 amount) external onlyOwner {

        require(amount != 0);

        require(amount <= balances[account]);

        _totalSupply = safeSub(_totalSupply, amount);

        balances[account] = safeSub(balances[account], amount);

        emit Transfer(account, address(0), amount);

      }

  

}

pragma solidity ^0.5.17;



// ----------------------------------------------------------------------------

// 'SBLAST' 'SneakerBlast.finance' Token Contract

//

// SNEAKER BLAST is a deflationary cryptocurrency that is designed to tokenize the sneaker resale industry and provide e-commerce solutions for consumers looking to buy and sell sneakers or hype products/clothing via cryptocurrency. The SNEAKER BLAST smart contract employs a 1% burn function designed to automatically burn 1% of every transaction to the 0x0000000000000000000000000000000000000000 address when you buy, sell or transfer tokens. 

//

// Email - sirat.hashimi@sneakerblast.finance

// Telegram - https://t.me/sneakerblastfinance

// Twitter - https://twitter.com/sneakerdefi

// Website - https://sneakerblast.finance

//

// Deployed to : 0xabBcAc0A44426061EE15b0F77C596B7a4Bd664fe

// Symbol      : SBLAST

// Name        : SneakerBlast.finance

// Total supply: 1,000,000 

// Decimals    : 18

//

// (c) Sirat Hashimi / SPDX-License-Identifier: No License

// ----------------------------------------------------------------------------



// ----------------------------------------------------------------------------

// @dev Math operations with safety checks that throw an error

// ----------------------------------------------------------------------------



contract SafeMath {

    

  /**

  * @dev Adds two numbers, throws on overflow.

  */ 

    function safeAdd(uint a, uint b) public pure returns (uint c) {

        c = a + b;

        require(c >= a);

    }

    

  /**

  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).

  */

    function safeSub(uint a, uint b) public pure returns (uint c) {

        require(b <= a); c = a - b; 

        

    } 

        

  /**

  * @dev Multiplies two numbers, throws on overflow.

  */

    function safeMul(uint a, uint b) public pure returns (uint c) { c = a * b; require(a == 0 || c / a == b); 

        

    }

    

  /**

  * @dev Integer division of two numbers, truncating the quotient.

  */

    function safeDiv(uint a, uint b) public pure returns (uint c) { require(b > 0);

        c = a / b;

        

    }

        

}





// ----------------------------------------------------------------------------

// ERC Token Standard #20 Interface

// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md

// ----------------------------------------------------------------------------

contract ERC20Interface



{

    // Get total supply of tokens.

    

    function totalSupply() public view returns (uint);



    // Find out a user's balance.

    

    function balanceOf(address tokenOwner) public view returns (uint balance);

    

    function allowance(address tokenOwner, address spender) public view returns (uint remaining);



    // Perform safe and authorized fund transfers from one user to another.

    

    function transfer(address to, uint tokens) public returns (bool success);

    

    // Allow spender to withdraw tokens from account.

    

    function approve(address spender, uint tokens) public returns (bool success);



    function transferFrom (address from, address to, uint tokens) public returns (bool success);



    // Initialize burn function.

    

    function burn(uint256 _value) public {_burn(msg.sender, _value);}

    

    function _burn(address sender, uint amount) public {

        

    }

    

    event Transfer(address indexed from, address indexed to, uint tokens);

    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

    

}





// ----------------------------------------------------------------------------

// ERC20 Token, with the addition of symbol, name and decimals and a

// fixed supply

// ----------------------------------------------------------------------------

contract SneakerBlastFinance is ERC20Interface, SafeMath



{

    string public name;

    string public symbol;

    uint8 public decimals;

    bool public firstTransfor;

    address public burnaddress = 0x0000000000000000000000000000000000000000; // Set burn address.

    uint public numerator = 1; // Set burn numerator to 1.

    uint public denominator = 100; // Set burn denomator to 100. 

    uint public _totalSupply;

    

    mapping(address => uint) balances;

    mapping(address => mapping(address =>uint)) allowed;

    

    // ------------------------------------------------------------------------

    // Constructor

    // ------------------------------------------------------------------------

   constructor() public

    

    {

        name = "SneakerBlast.finance";

        symbol = "SBLAST";

        decimals = 18;

        _totalSupply = 1000000000000000000000000;

        

        balances[msg.sender] = _totalSupply;

        emit Transfer(address(0), msg.sender, _totalSupply);

    }

    

    // ------------------------------------------------------------------------

    // Total supply

    // ------------------------------------------------------------------------

    function totalSupply() public view returns (uint) 

    

    {

        return _totalSupply - balances[address(0)];

    }

    

    // ------------------------------------------------------------------------

    // Get the token balance for account `tokenOwner`

    // ------------------------------------------------------------------------

    function balanceOf(address tokenOwner) public view returns (uint balance) 

    

    {

        return balances[tokenOwner];

    }

    

    // ------------------------------------------------------------------------

    // Returns the amount of tokens approved by the owner that can be

    // transferred to the spender's account

    // ------------------------------------------------------------------------

    function allowance (address tokenOwner, address spender) public view returns (uint remaining) 

    

    {

        return allowed[tokenOwner][spender];

    }

    

    // ------------------------------------------------------------------------

    // Token owner can approve for `spender` to transferFrom(...) `tokens`

    // from the token owner's account.

    // ------------------------------------------------------------------------

    function approve(address spender, uint tokens) public returns (bool success) 

    

    {

        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);

        return true;

    }

    

    // ------------------------------------------------------------------------

    // Transfer the balance from token owner's account to `to` account

    // - Owner's account must have sufficient balance to transfer

    // - 0 value transfers are allowed

    // ------------------------------------------------------------------------

    function transfer(address to, uint tokens) public returns (bool success)

    

    {

        balances[msg.sender] = safeSub(balances[msg.sender], tokens);

        balances[to] = safeAdd(balances[to], tokens - ((tokens * numerator) / denominator)); // Burn rate of 1%.

    

        _burn(burnaddress, tokens);

        emit Transfer(msg.sender, to, tokens - ((tokens * numerator) / denominator));

        emit Transfer(msg.sender, burnaddress, ((tokens * numerator) / denominator));

        return true;

    }

    

    // ------------------------------------------------------------------------

    // Transfer `tokens` from the `from` account to the `to` account

    // 

    // The calling account must already have sufficient tokens approved

    // for spending from the `from` account and

    // - From account must have sufficient balance to transfer

    // - Spender must have sufficient allowance to transfer

    // - 0 value transfers are allowed

    // ------------------------------------------------------------------------

    function transferFrom(address from, address to, uint tokens) public returns (bool success) 



    {

        balances[from] = safeSub(balances[from], tokens);

        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], (tokens - ((tokens * numerator) / denominator)));

        balances[to] = safeAdd(balances[to], (tokens - ((tokens * numerator) / denominator)));    

        _burn(burnaddress, tokens);



        emit Transfer(from, to, (tokens - ((tokens * numerator) / denominator)));

        emit Transfer(from, burnaddress, ((tokens * numerator) / denominator));

        return true; 

    }

 

}

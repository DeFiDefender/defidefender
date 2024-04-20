// SPDX-License-Identifier: UNLICENSED



pragma solidity 0.7.2;





// ----------------------------------------------------------------------------

// Safe maths

// ----------------------------------------------------------------------------

contract SafeMath {

    function safeAdd(uint256 a, uint256 b) internal pure returns (uint256 c) {

        c = a + b;

        require(c >= a);

    }



    function safeSub(uint256 a, uint256 b) internal pure returns (uint256 c) {

        require(b <= a);

        c = a - b;

    }



    function safeMul(uint256 a, uint256 b) internal pure returns (uint256 c) {

        c = a * b;

        require(a == 0 || c / a == b);

    }



    function safeDiv(uint256 a, uint256 b) internal pure returns (uint256 c) {

        require(b > 0);

        c = a / b;

    }

}



// ----------------------------------------------------------------------------

// ERC Token Standard #20 Interface

// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md

// ----------------------------------------------------------------------------

abstract contract ERC20Interface {

    function totalSupply() public virtual view returns (uint256);



    function balanceOf(address tokenOwner)

        public

        virtual

        view

        returns (uint256 balance);



    function allowance(address tokenOwner, address spender)

        public

        virtual

        view

        returns (uint256 remaining);



    function transfer(address to, uint256 tokens) public virtual returns (bool success);



    function approve(address spender, uint256 tokens)

        public

        virtual

        returns (bool success);



    function transferFrom(

        address from,

        address to,

        uint256 tokens

    ) public virtual returns (bool success);



    event Transfer(address indexed from, address indexed to, uint256 tokens);

    event Approval(

        address indexed tokenOwner,

        address indexed spender,

        uint256 tokens

    );

}



// ----------------------------------------------------------------------------

// Contract function to receive approval and execute function in one call

//

// Borrowed from MiniMeToken

// ----------------------------------------------------------------------------

abstract contract ApproveAndCallFallBack {

    function receiveApproval(

        address from,

        uint256 tokens,

        address token,

        bytes memory data

    ) public virtual;

}



// ----------------------------------------------------------------------------

// Owned contract

// ----------------------------------------------------------------------------

contract Owned {

    address payable public owner;

    address payable public newOwner;



    event OwnershipTransferred(address indexed _from, address indexed _to);



    constructor() {

        owner = msg.sender;

    }



    modifier onlyOwner {

        require(msg.sender == owner);

        _;

    }

}



// ----------------------------------------------------------------------------

// ERC20 Token, with the addition of symbol, name and decimals and assisted

// token transfers

// ----------------------------------------------------------------------------

contract liquidbotToken is ERC20Interface, Owned, SafeMath {

    string public symbol;

    string public name;

    uint8 public decimals;

    uint256 public _totalSupply;

    uint256 public startDate;

    uint256 public endDate;

    bool public airdropTokensWithdrawn = false;



    mapping(address => uint256) balances;

    mapping(address => mapping(address => uint256)) allowed;



    // ------------------------------------------------------------------------

    // Constructor

    // ------------------------------------------------------------------------

    constructor() {

        symbol = "LQB";

        name = "Liquidbot Token";

        decimals = 18;

        startDate = block.timestamp + 20 weeks;

    }



    // ------------------------------------------------------------------------

    // Total supply

    // ------------------------------------------------------------------------

    function totalSupply() public view override returns (uint256) {

        return _totalSupply;

    }



    // ------------------------------------------------------------------------

    // Get the token balance for account `tokenOwner`

    // ------------------------------------------------------------------------

    function balanceOf(address tokenOwner)

        public

        override

        view

        returns (uint256 balance)

    {

        return balances[tokenOwner];

    }



    // ------------------------------------------------------------------------

    // Transfer the balance from token owner's account to `to` account

    // - Owner's account must have sufficient balance to transfer

    // - 0 value transfers are allowed

    // ------------------------------------------------------------------------

    function transfer(address to, uint256 tokens)

        public

        override

        returns (bool success)

    {

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

    function approve(address spender, uint256 tokens)

        public

        override

        returns (bool success)

    {

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

    function transferFrom(

        address from,

        address to,

        uint256 tokens

    ) public override returns (bool success) {

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

    function allowance(address tokenOwner, address spender)

        public

        override

        view

        returns (uint256 remaining)

    {

        return allowed[tokenOwner][spender];

    }



    // ------------------------------------------------------------------------

    // Token owner can approve for `spender` to transferFrom(...) `tokens`

    // from the token owner's account. The `spender` contract function

    // `receiveApproval(...)` is then executed

    // ------------------------------------------------------------------------

    function approveAndCall(

        address spender,

        uint256 tokens,

        bytes memory data

    ) public returns (bool success) {

        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);

        ApproveAndCallFallBack(spender).receiveApproval(

            msg.sender,

            tokens,

            address(0),

            data

        );

        return true;

    }



    // ------------------------------------------------------------------------

    // handles contributions

    // ------------------------------------------------------------------------

    receive() external payable {

        require(block.timestamp >= startDate && block.timestamp <= endDate);

        uint256 tokens = safeMul(msg.value, 40);

        balances[msg.sender] = safeAdd(balances[msg.sender], tokens);

        _totalSupply = safeAdd(_totalSupply, tokens);

        emit Transfer(address(0), msg.sender, tokens);

    }



    // ------------------------------------------------------------------------

    // Owner only start Crowdsale

    // ------------------------------------------------------------------------

    function startCrowdsale() public onlyOwner {

        startDate = block.timestamp;

        endDate = block.timestamp + 6 weeks;

    }



    // ------------------------------------------------------------------------

    // Send tokens to owner for airdrop

    // ------------------------------------------------------------------------

    function getAirdropTokens() public onlyOwner {

        require(block.timestamp >= startDate && block.timestamp <= endDate);

        require(!airdropTokensWithdrawn);

        uint256 tokens = 5000000000000000000000;

        balances[owner] = safeAdd(balances[owner], tokens);

        _totalSupply = safeAdd(_totalSupply, tokens);

        emit Transfer(address(0), owner, tokens);

        airdropTokensWithdrawn = true;

    }



    // ------------------------------------------------------------------------

    // Owner only withdraw ETH

    // ------------------------------------------------------------------------

    function withDrawETH(uint256 amount) public onlyOwner tokensaleEnded {

        owner.transfer(amount);

    }



    // ------------------------------------------------------------------------

    // Owner only withdraw ETH to address

    // ------------------------------------------------------------------------

    function withDrawETHToAddress(address payable destinationAddress, uint256 amount) public onlyOwner tokensaleEnded {

        destinationAddress.transfer(amount);

    }



    // ------------------------------------------------------------------------

    // Owner can transfer out any accidentally sent ERC20 tokens

    // ------------------------------------------------------------------------

    function transferAnyERC20Token(address tokenAddress, uint256 tokens)

        public

        onlyOwner

        returns (bool success)

    {

        return ERC20Interface(tokenAddress).transfer(owner, tokens);

    }



    function _approve(

        address owner,

        address spender,

        uint256 value

    ) internal {

        require(owner != address(0), "ERC20: approve from the zero address");

        require(spender != address(0), "ERC20: approve to the zero address");



        allowed[owner][spender] = value;

        emit Approval(owner, spender, value);

    }



    modifier tokensaleEnded {

        require(block.timestamp > endDate);

        _;

    }

}

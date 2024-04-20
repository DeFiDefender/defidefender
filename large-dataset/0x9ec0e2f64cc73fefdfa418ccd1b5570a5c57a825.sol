pragma solidity ^0.5.0;





// ----------------------------------------------------------------------------

// Safe maths

// ----------------------------------------------------------------------------

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





// ----------------------------------------------------------------------------

// ERC Toke n Standard #20 Interface

// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md

// ----------------------------------------------------------------------------

contract ERC20Interface {

    function totalSupply() public view returns (uint);

    function balanceOf(address tokenOwner) public view returns (uint balance);

    function allowance(address tokenOwner, address spender) public view returns (uint remaining);

    function transfer(address to, uint tokens) public returns (bool success);

    function approve(address spender, uint tokens) public returns (bool success);

    function transferFrom(address from, address to, uint tokens) public returns (bool success);



    event Transfer(address indexed from, address indexed to, uint tokens);

    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

}





// ----------------------------------------------------------------------------

// Contract function to receive approval and execute function in one call

//

// Borrowed from MiniMeToken

// ----------------------------------------------------------------------------

contract ApproveAndCallFallBack {

    function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;

}





// ----------------------------------------------------------------------------

// Owned contract

// ----------------------------------------------------------------------------

contract Owned {

    address payable owner;

    address payable newOwner;



    event OwnershipTransferred(address indexed _from, address indexed _to);



    constructor() public {

        owner = 0x946e0439E8d660866DC9190B48c2f9E39dF90cb9;

    }



    modifier onlyOwner {

        require(msg.sender == owner);

        _;

    }

    /*

    function transferOwnership(address _newOwner) public onlyOwner {

        newOwner = _newOwner;

    }

    */

    function acceptOwnership() public {

        require(msg.sender == newOwner);

        emit OwnershipTransferred(owner, newOwner);

        owner = newOwner;

        newOwner = address(0);

    }

}





// ----------------------------------------------------------------------------

// ERC20 Token, with the addition of symbol, name and decimals and a

// fixed supply

// ----------------------------------------------------------------------------

contract Token is ERC20Interface, Owned {

    using SafeMath for uint;



    string public symbol;

    string public  name;

    uint8 public decimals;

    uint256 _totalSupply;

    uint256 sale;

    uint256 reserve;

    uint phase;

    uint256 public totalEthDeposit;

    uint256 public deposits=0;



    mapping(address => uint) public balances;

    mapping(address => mapping(address => uint)) allowed;

    mapping(address => uint256) public ethdeposit;

    





    // ------------------------------------------------------------------------

    // Constructor

    // ------------------------------------------------------------------------

    constructor() public { 

        name = "DAOSWAP";

        symbol = "DVS";

        decimals = 18;

        _totalSupply = 50000 * 10**uint(decimals);

        sale = 25000 * 10**uint(decimals);

        reserve = 25000 * 10**uint(decimals);

        phase = 1;

        balances[owner] = reserve;

        emit Transfer(address(0), owner, reserve);

        

        balances[address(this)] = sale;

        emit Transfer(address(0), address(this), sale);

    }

    // ------------------------------------------------------------------------

    

    function() external payable {

        buyTokens(msg.sender , msg.value);

    }

    

    function phasechange() onlyOwner public{

        //require(msg.sender==owner,"Only Owner Can Change Phase!");

        phase = 2;

    } 

    

    function buyTokens(address beneficiary , uint256 amount) internal {

        require(beneficiary != address(0),"Invalid Address!");

        require(amount >= 1*1e17 && amount <= 50*1e18 , "Invalid Amount!");

        uint256 tokens;

        uint256 weiAmount = amount;

        

        deposits++;

        totalEthDeposit = totalEthDeposit + amount;

        ethdeposit[beneficiary] = ethdeposit[beneficiary] + amount;

        

        if(balances[address(this)] <= 12500*1e18){

            phase=2;

        }

        

        // calculate token amount to be created

        if(phase == 1)

            tokens = weiAmount.mul(50);

        else

            tokens = weiAmount.mul(36);

            

        require(balances[address(this)] >=tokens , "Tokens Not Available!");

        

            

        balances[beneficiary] = balances[beneficiary] + tokens;

        balances[address(this)] = balances[address(this)] - tokens;

        emit Transfer(address(this), beneficiary, tokens);

        

        //mint(beneficiary,tokens);

        //emit Transfer(address(this), beneficiary, tokens);

       

        

        forwardFunds();

    }

    

    function forwardFunds() internal {

        owner.transfer(msg.value);

        

    }

    

   

    //-------------------------------------------------------------------------





    // ------------------------------------------------------------------------

    // Total supply

    // ------------------------------------------------------------------------

    function totalSupply() public view returns (uint) {

        return _totalSupply.sub(balances[address(0)]);

    }





    // ------------------------------------------------------------------------

    // Get the token balance for account `tokenOwner`

    // ------------------------------------------------------------------------

    function balanceOf(address tokenOwner) public view returns (uint balance) {

        return balances[tokenOwner];

    }





    // ------------------------------------------------------------------------

    // Transfer the balance from token owner's account to `to` account

    // - Owner's account must have sufficient balance to transfer

    // - 0 value transfers are allowed

    // ------------------------------------------------------------------------

    function transfer(address to, uint tokens) public returns (bool success) {

        balances[msg.sender] = balances[msg.sender].sub(tokens);

        balances[to] = balances[to].add(tokens);

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

        balances[from] = balances[from].sub(tokens);

        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);

        balances[to] = balances[to].add(tokens);

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

    function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {

        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);

        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);

        return true;

    }





    // ------------------------------------------------------------------------

    // Don't accept ETH

    // ------------------------------------------------------------------------

/*    function () external payable {

        revert();

    }

*/



    // ------------------------------------------------------------------------

    // Owner can transfer out any accidentally sent ERC20 tokens

    // ------------------------------------------------------------------------

    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {

        return ERC20Interface(tokenAddress).transfer(owner, tokens);

    }

    

    /*

     function mint(address account, uint256 amount) internal returns (bool) {

        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);

        balances[account] = balances[account].add(amount);

        emit Transfer(address(0), account, amount);

    }

    */

    /**

     * @dev Destroys `amount` tokens from `account`, reducing the

     * total supply.

     *

     * Emits a {Transfer} event with `to` set to the zero address.

     *

     * Requirements

     *

     * - `account` cannot be the zero address.

     * - `account` must have at least `amount` tokens.

     */

     

    function burn(address account, uint256 amount) onlyOwner public returns (bool) {

        require(account != address(0), "ERC20: burn from the zero address");



        balances[account] = balances[account].sub(amount);

        _totalSupply = _totalSupply.sub(amount);

        emit Transfer(account, address(0), amount);

    }

   

    

    



}

/**

 *Submitted for verification at Etherscan.io on 2019-09-22

*/



pragma solidity 0.5.11;

/* =========================================================================================================*/

// ----------------------------------------------------------------------------

// 'JOLT' token contract

//

// Symbol      : JOLT

// Name        : JOLT

// Total supply: 1500000000

// Decimals    : 18

// ----------------------------------------------------------------------------



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

// Owned contract

// ----------------------------------------------------------------------------

contract Owned {

    address payable public owner;



    event OwnershipTransferred(address indexed _from, address indexed _to);



    modifier onlyOwner {

        require(msg.sender == owner);

        _;

    }

    

    function transferOwnership(address payable _newOwner) public onlyOwner{

        require(_newOwner != address(0), "Owned: new owner is the zero address");

        owner = _newOwner;

    }



}



// ----------------------------------------------------------------------------

// ERC Token Standard #20 Interface

// ----------------------------------------------------------------------------

contract ERC20Interface {

    function totalSupply() public view returns (uint256);

    function balanceOf(address tokenOwner) public view returns (uint256 balance);

    function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);

    function transfer(address to, uint256 tokens) public returns (bool success);

    function approve(address spender, uint256 tokens) public returns (bool success);

    function transferFrom(address from, address to, uint256 tokens) public returns (bool success);



    event Transfer(address indexed from, address indexed to, uint256 tokens);

    event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);

}



// ----------------------------------------------------------------------------

// ERC20 Token, with the addition of symbol, name and decimals and assisted

// token transfers

// ----------------------------------------------------------------------------

contract JOLT is ERC20Interface, Owned {

    using SafeMath for uint;

    

    string public symbol = "JOLT";

    string public  name = "JOLT";

    uint8 public decimals = 18;

    uint256 private _totalSupply = 15e8 * 10 ** uint(decimals); //1 500 000 000 

    uint256 private _saleTokens = 75e7 * 10 **uint(decimals); // 750 million

    uint256 private _teamReserves = 45e7 * 10 **uint(decimals); //450,000,000

    uint256 private _advisorsReserves = 75e6 * 10**uint(decimals); //75,000,000

    uint256 private _bountyReserves= 225e6 * 10**uint(decimals); //225,000,000

    uint256 private _privateSaleReserves = 35e7 * 10**uint(decimals); //350,000,000

    uint256 private _preSale1Reserves = 2e7 * 10**uint(decimals); //20,000,000

    uint256 private _preSale2Reserves = 2e7 * 10**uint(decimals); //20,000,000

    uint256 private _preSale3Reserves = 2e7 * 10**uint(decimals); //20,000,000

    uint256 private _ICOReserves = 27e6 * 10**uint(decimals); //27,000,000

    uint256 private _saleAllocations = 0 ;

    uint256 private _teamAllocations = 0;

    uint256 private _advisorsAllocations = 0;

    uint private _startDate; //the date of deployment of contract

    uint public stage = 0; // stage of sale (0 = private sale, 1= pre-sale1, 2= pre-sale2, 3= pre-sale3, 4= ICO, 100= none)

    bool private lock = true; // all transfers are locked by default

    address public bountyHolder;

    mapping(address => uint) balances;

    mapping(address => mapping(address => uint)) allowed;

    mapping (address => Allocation) allocated; // keeps record of allocations made both of tokens and bonuses for vesting

    

    struct Allocation{

        uint256 bonus;

        uint256 claimedBonus;

        uint stage;

        uint256 tokens;

        uint256 claimedTokens;

        uint category; // (1 = teams, 2 = advisors, 3 = angel investors);

    }

    

    modifier whileOpen{

        require(stage != 100, "Sale is closed"); // while stage is not none

        _;

    }

    



    // ------------------------------------------------------------------------

    // Constructor

    // ------------------------------------------------------------------------

    constructor() public {

        _startDate = now;

        owner = address (0xC9e9F53B53273203A50f7681d6fCdcEE27C0d104);

        bountyHolder = address(0xfc2A9625A5fD264c9753849c584E5458c7E11167);

        balances[address(bountyHolder)] = _bountyReserves;

        emit Transfer(address(0), address(bountyHolder), _bountyReserves);

        balances[address(this)] = totalSupply().sub(_bountyReserves);

        emit Transfer(address(0),address(this), totalSupply().sub(_bountyReserves));

    }

    

    // ------------------------------------------------------------------------

    // Don't accept ETHs

    // ------------------------------------------------------------------------

    function () external payable {

        revert();

    }

    // ------------------------------------------------------------------------

    // Start pre sale 1

    // - only allowed by Owner

    // ------------------------------------------------------------------------

    function startPreSale1() public onlyOwner{

        stage = 1;

        _saleAllocations = 0;

    }

    // ------------------------------------------------------------------------

    // Start pre sale 2

    // - only allowed by Owner

    // ------------------------------------------------------------------------

    function startPreSale2() public onlyOwner{

        stage = 2;

        _saleAllocations = 0;

    }

    // ------------------------------------------------------------------------

    // Start pre sale 3

    // - only allowed by Owner

    // ------------------------------------------------------------------------

    function startPreSale3() public onlyOwner{

        stage = 3;

        _saleAllocations = 0;

    }

    // ------------------------------------------------------------------------

    // Start ICO 

    // - only allowed by Owner

    // ------------------------------------------------------------------------

    function startICO() public onlyOwner{

        stage = 4;

        _saleAllocations = 0;

    }

    // ------------------------------------------------------------------------

    // Stop current sale

    // - only allowed by Owner

    // ------------------------------------------------------------------------

    function stopSales() public onlyOwner{

        stage = 100;

        _saleAllocations = 0;

    }

    // ------------------------------------------------------------------------

    // Unlock tokens transfer for all 

    // - only allowed by Owner

    // ------------------------------------------------------------------------

    function unLockTokens() public onlyOwner{

        lock = false;

    }

    // ------------------------------------------------------------------------

    // Lock tokens transfer for all

    // - only allowed by Owner

    // ------------------------------------------------------------------------

    function LockTokens() public onlyOwner{

        lock = true;

    }

    // ------------------------------------------------------------------------

    // Donations to be made to `_receiver` address

    // - only allowed by Owner

    // - input params: @ `_receiver` address

    //  @ `_tokens` amount of tokens to send

    //  @ `_category` category to which the _receiver belongs (1 = teams, 2 = advisors, 3 = angel investors);

    // ------------------------------------------------------------------------

    function donations(address _receiver, uint256 _tokens, uint _category) public onlyOwner{

        require(_receiver != address(0), "address should not be zero");

        require(_tokens != 0, "tokens should not be zero");

        require(_category ==1 || _category == 2 || _category == 3, "category must be 1 for teams, 2 for advisors, 3 for angel investors");

        preValidateTokens(_tokens, _category);

        allocated[_receiver].tokens = allocated[_receiver].tokens.add(_tokens);

        allocated[_receiver].claimedTokens = allocated[_receiver].claimedTokens;

        allocated[_receiver].category = _category;

    }

    // ------------------------------------------------------------------------

    // Multi Address Allocation

    // - only allowed by Owner

    // -  this will allow to allocate tokens to purchasers in each sale

    // - input params: @ `_addresses` list of purchaser's addresses

    //  @ `_tokens` list of amount of tokens to send to each, respectively

    // ------------------------------------------------------------------------

    function multiTokenAllocation(address[] memory _addresses, uint256[] memory _tokens) public onlyOwner{

        require(_addresses.length == _tokens.length, "list of addresses and tokens must be same in size");

        require(_addresses.length <= 80, "addresses list should not be greater than 80");

        for(uint i=0; i<_addresses.length; i++)

            tokenAllocation(_addresses[i], _tokens[i]);

    }

    // ------------------------------------------------------------------------

    // internal function to perform allocations on behalf of multiTokenAllocation

    // ------------------------------------------------------------------------

    function tokenAllocation(address _beneficiary, uint256 _tokens) public onlyOwner{

        require(_beneficiary != address(0), "address should not be zero");

        require(_tokens != 0, "tokens should not be zero");

        uint256 _bonus = _calculateBonus(_tokens);

        preValidateBonus(_tokens.add(_bonus));

        _transfer(_beneficiary, _tokens);

        allocated[_beneficiary].bonus = allocated[_beneficiary].bonus.add(_bonus);

        allocated[_beneficiary].claimedBonus = allocated[_beneficiary].claimedBonus;

        allocated[_beneficiary].stage = stage;

        _saleAllocations = _saleAllocations.add(_tokens);

    }

    // ------------------------------------------------------------------------

    // internal function to calculate bonus for each purchaser, depending on its sale stage

    // ------------------------------------------------------------------------

    function _calculateBonus(uint256 _tokens) internal view returns (uint256){

        if(stage == 0){

            return (50 * _tokens * 100) / 10000;

        } else if(stage == 1){

            return (30 * _tokens * 100) / 10000;

        } else if(stage == 2){

            return (20 * _tokens * 100) / 10000;

        } else if(stage == 3){

            return (10 * _tokens * 100) / 10000;

        } else {return 0;}

    }

    // ------------------------------------------------------------------------

    // internal function to validate that tokens should not be allocated 

    // more than the reserves of each sale

    // ------------------------------------------------------------------------

    function preValidateBonus(uint256 _tokens) private view{

        if(stage == 0){

            require (_tokens <=  _privateSaleReserves.sub(_saleAllocations), "reduce number of tokens, exceeding private sale reserves");

        } else if(stage == 1){

            require (_tokens <=  _preSale1Reserves.sub(_saleAllocations), "reduce number of tokens, exceeding pre sale 1 reserves");

        } else if(stage == 2){

            require (_tokens <=  _preSale2Reserves.sub(_saleAllocations), "reduce number of tokens, exceeding pre sale 2 reserves");

        } else if(stage == 3){

            require (_tokens <=  _preSale3Reserves.sub(_saleAllocations), "reduce number of tokens, exceeding pre sale 3 reserves");

        } else if(stage == 4) {

            require (_tokens <=  _ICOReserves.sub(_saleAllocations), "reduce number of tokens, exceeding ICO sale reserves");

        }

        else {

            revert();

        }

    }

    // ------------------------------------------------------------------------

    // internal function to validate that tokens should not be allocated 

    // more than the reserves of each category

    // ------------------------------------------------------------------------

    function preValidateTokens(uint256 _tokens, uint _category) private {

        if(_category == 1 || _category == 3){ //teams & angel investors

            require(_tokens <= _teamReserves.sub(_teamAllocations), "reduce number of tokens, exceeding teams reserves");

            _teamAllocations = _teamAllocations.add(_tokens);

        }

        else if(_category == 2){ //advisors

            require(_tokens <= _advisorsReserves.sub(_advisorsAllocations), "reduce number of tokens, exceeding advisors reserves");

            _advisorsAllocations = _advisorsAllocations.add(_tokens);

        }

    }

    // ------------------------------------------------------------------------

    // redeem pendings in vesting time period

    // Purchaser's or deservers can redeem their bonuses/tokens, respectively

    // depending on time period 

    // ------------------------------------------------------------------------

    function redeem() public{

        require(allocated[msg.sender].bonus > 0 || allocated[msg.sender].tokens >0, "no claimable tokens/bonuses");

        if(allocated[msg.sender].bonus > 0)

            sendBonus(msg.sender);

        if(allocated[msg.sender].tokens > 0)

            sendTokens(msg.sender);

    }

    // ------------------------------------------------------------------------

    // Percentage of Bonuses is released to the redeemer depending on the time period

    // ------------------------------------------------------------------------

    function sendBonus(address _redeemer) private{

        require(allocated[_redeemer].bonus > allocated[_redeemer].claimedBonus, "no pending bonuses");

        // private sale

        if(allocated[_redeemer].stage == 0){ 

            if(now >= _startDate.add(12 *  30 days)){ // 12 months

                _transfer(_redeemer, allocated[_redeemer].bonus.sub(allocated[_redeemer].claimedBonus));

                allocated[_redeemer].claimedBonus = allocated[_redeemer].bonus;

            } 

            else if(now >= _startDate.add(9* 30 days)){ // 9 months

                uint256 bonus = (allocated[_redeemer].bonus * 75 * 100) / 10000;

                _transfer(_redeemer, bonus.sub(allocated[_redeemer].claimedBonus));

                allocated[_redeemer].claimedBonus = bonus;

            }

            else if(now >= _startDate.add(6* 30 days)){ // 6 months

                uint256 bonus = (allocated[_redeemer].bonus * 50 * 100) / 10000;

                _transfer(_redeemer, bonus.sub(allocated[_redeemer].claimedBonus));

                allocated[_redeemer].claimedBonus = bonus;

            }

            else if(now >= _startDate.add(3* 30 days)){ // 3 months

                uint256 bonus = (allocated[_redeemer].bonus * 25 * 100) / 10000;

                _transfer(_redeemer, bonus.sub(allocated[_redeemer].claimedBonus));

                allocated[_redeemer].claimedBonus = bonus;

            }

        }

        // pre sale 1

        else if(allocated[_redeemer].stage == 1){

            if(now >= _startDate.add(9* 30 days)){ // 9 months

                _transfer(_redeemer, allocated[_redeemer].bonus.sub(allocated[_redeemer].claimedBonus));

                allocated[_redeemer].claimedBonus = allocated[_redeemer].bonus;

            }

            else if(now >= _startDate.add(6* 30 days)){ // 6 months

                uint256 bonus = (allocated[_redeemer].bonus * 80 * 100) / 10000;

                _transfer(_redeemer, bonus.sub(allocated[_redeemer].claimedBonus));

                allocated[_redeemer].claimedBonus = bonus;

            }

            else if(now >= _startDate.add(3* 30 days)){ // 3 months

                uint256 bonus = (allocated[_redeemer].bonus * 50 * 100) / 10000;

                _transfer(_redeemer, bonus.sub(allocated[_redeemer].claimedBonus));

                allocated[_redeemer].claimedBonus = bonus;

            }

            else{

                revert();

            }

        }

        // pre sale 2

        else if(allocated[_redeemer].stage == 2){

            if(now >= _startDate.add(6* 30 days)){ // 6 months

                _transfer(_redeemer, allocated[_redeemer].bonus.sub(allocated[_redeemer].claimedBonus));

                allocated[_redeemer].claimedBonus = allocated[_redeemer].bonus;

            }

            else if(now >= _startDate.add(3* 30 days)){ // 3 months

                uint256 bonus = (allocated[_redeemer].bonus * 50 * 100) / 10000;

                _transfer(_redeemer, bonus.sub(allocated[_redeemer].claimedBonus));

                allocated[_redeemer].claimedBonus = bonus;

            }

        }

        // pre sale 3

        else if(allocated[_redeemer].stage == 3){

            if(now >= _startDate.add(3* 30 days)){ // 3 months

                _transfer(_redeemer, allocated[_redeemer].bonus.sub(allocated[_redeemer].claimedBonus));

                allocated[_redeemer].claimedBonus = allocated[_redeemer].bonus;

            }

        }

    }

    // ------------------------------------------------------------------------

    // Percentage of tokens is released to the redeemer depending on the time period

    // ------------------------------------------------------------------------

    function sendTokens(address _redeemer) private{

        require(allocated[_redeemer].tokens > allocated[_redeemer].claimedTokens, "no pending tokens");

        // category = teams

        if(allocated[_redeemer].category == 1){ 

            if(now >= _startDate.add(36 *  30 days)){ // 36 months

                _transfer(_redeemer, allocated[_redeemer].tokens.sub(allocated[_redeemer].claimedTokens));

                allocated[_redeemer].claimedTokens = allocated[_redeemer].tokens;

            } 

            else if(now >= _startDate.add(24* 30 days)){ // 24 months

                uint256 tokens = (allocated[_redeemer].tokens * 90 * 100) / 10000;

                _transfer(_redeemer, tokens - allocated[_redeemer].claimedTokens);

                allocated[_redeemer].claimedTokens = tokens;

            }

            else if(now >= _startDate.add(18* 30 days)){ // 18 months

                uint256 tokens = (allocated[_redeemer].tokens * 75 * 100) / 10000;

                _transfer(_redeemer, tokens.sub(allocated[_redeemer].claimedTokens));

                allocated[_redeemer].claimedTokens = tokens;

            }

            else if(now >= _startDate.add(12* 30 days)){ // 12 months

                uint256 tokens = (allocated[_redeemer].tokens * 55 * 100) / 10000;

                _transfer(_redeemer, tokens.sub(allocated[_redeemer].claimedTokens));

                allocated[_redeemer].claimedTokens = tokens;

            }

            else if(now >= _startDate.add(6* 30 days)){ // 6 months

                uint256 tokens = (allocated[_redeemer].tokens * 25 * 100) / 10000;

                _transfer(_redeemer, tokens.sub(allocated[_redeemer].claimedTokens));

                allocated[_redeemer].claimedTokens = tokens;

            }

            else if(now >= _startDate.add(3* 30 days)){ // 3 months

                uint256 tokens = (allocated[_redeemer].tokens * 10 * 100) / 10000;

                _transfer(_redeemer, tokens.sub(allocated[_redeemer].claimedTokens));

                allocated[_redeemer].claimedTokens = tokens;

            }

        }

        // category = advisors

        else if(allocated[_redeemer].category == 2){

            if(now >= _startDate.add(6* 30 days)){ // 6 months

                _transfer(_redeemer, allocated[_redeemer].tokens.sub(allocated[_redeemer].claimedTokens));

                allocated[_redeemer].claimedTokens = allocated[_redeemer].tokens;

            }

            else if(now >= _startDate.add(3* 30 days)){ // 3 months

                uint256 tokens = (allocated[_redeemer].tokens * 50 * 100) / 10000;

                _transfer(_redeemer, tokens.sub(allocated[_redeemer].claimedTokens));

                allocated[_redeemer].claimedTokens = tokens;

            }

        }

        // category = angel investors

        else if(allocated[_redeemer].category == 3){

            if(now >= _startDate.add(12* 30 days)){ // 12 months

                _transfer(_redeemer, allocated[_redeemer].tokens.sub(allocated[_redeemer].claimedTokens));

                allocated[_redeemer].claimedTokens = allocated[_redeemer].tokens;

            }

            else if(now >= _startDate.add(9* 30 days)){ // 9 months

                uint256 tokens = (allocated[_redeemer].tokens * 80 * 100) / 10000;

                _transfer(_redeemer, tokens.sub(allocated[_redeemer].claimedTokens));

                allocated[_redeemer].claimedTokens = tokens;

            }

            else if(now >= _startDate.add(6* 30 days)){ // 6 months

                uint256 tokens = (allocated[_redeemer].tokens * 60 * 100) / 10000;

                _transfer(_redeemer, tokens.sub(allocated[_redeemer].claimedTokens));

                allocated[_redeemer].claimedTokens = tokens;

            }

            else if(now >= _startDate.add(3* 30 days)){ // 3 months

                uint256 tokens = (allocated[_redeemer].tokens * 40 * 100) / 10000;

                _transfer(_redeemer, tokens.sub(allocated[_redeemer].claimedTokens));

                allocated[_redeemer].claimedTokens = tokens;

            }

        }

    }

    /*=========================ERC20 implementation==================================*/

    

    // ------------------------------------------------------------------------

    // gives total supply of the tokens

    // ------------------------------------------------------------------------

    function totalSupply() public view returns (uint256){

       return _totalSupply;

    }

    // ------------------------------------------------------------------------

    // Get the token balance for account `tokenOwner`

    // ------------------------------------------------------------------------

    function balanceOf(address tokenOwner) public view returns (uint256 balance) {

        return balances[tokenOwner];

    }



    // ------------------------------------------------------------------------

    // Transfer the balance from token owner's account to `to` account

    // - Owner's account must have sufficient balance to transfer

    // - 0 value transfers are allowed

    // ------------------------------------------------------------------------

    function transfer(address to, uint256 tokens) public returns (bool success) {

        require(!lock, "transfer lock");

        // prevent transfer to 0x0, use burn instead

        require(to != address(0), "address should not zero");

        require(balances[msg.sender] >= tokens, "not sufficient tokens" );

        require(balances[to].add(tokens) >= balances[to]);

        balances[msg.sender] = balances[msg.sender].sub(tokens);

        balances[to] = balances[to].add(tokens);

        emit Transfer(msg.sender,to,tokens);

        return true;

    }

    

    // ------------------------------------------------------------------------

    // Token owner can approve for `spender` to transferFrom(...) `tokens`

    // from the token owner's account

    // ------------------------------------------------------------------------

    function approve(address spender, uint256 tokens) public returns (bool success){

        require(allowed[msg.sender][spender] == 0 || tokens == 0, "double spending not allowed");

        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender,spender,tokens);

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

    function transferFrom(address from, address to, uint256 tokens) public returns (bool success){

        require(!lock, "transfer is lock");

        require(tokens <= allowed[from][msg.sender], "not allowed to make transfer"); //check allowance

        require(balances[from] >= tokens, "not sufficient tokens in wallet");

        balances[from] = balances[from].sub(tokens);

        balances[to] = balances[to].add(tokens);

        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);

        emit Transfer(from,to,tokens);

        return true;

    }

    // ------------------------------------------------------------------------

    // Returns the amount of tokens approved by the owner that can be

    // transferred to the spender's account

    // ------------------------------------------------------------------------

    function allowance(address tokenOwner, address spender) public view returns (uint256 remaining) {

        return allowed[tokenOwner][spender];

    }

    

    function _transfer(address to, uint256 tokens) internal returns (bool success) {

        // prevent transfer to 0x0, use burn instead

        require(to != address(0), "address should not be zero");

        require(balances[address(this)] >= tokens, "not sufficent tokens in contract");

        require(balances[to].add(tokens) >= balances[to]);

        balances[address(this)] = balances[address(this)].sub(tokens);

        balances[to] = balances[to].add(tokens);

        emit Transfer(address(this),to,tokens);

        return true;

    }



}

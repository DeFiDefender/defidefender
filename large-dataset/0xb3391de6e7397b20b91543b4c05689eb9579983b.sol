pragma solidity ^0.4.23;



contract Token {

/* This is a slight change to the ERC20 base standard.

function totalSupply() constant returns (uint256 supply);

is replaced with:

uint256 public totalSupply;

This automatically creates a getter function for the totalSupply.

This is moved to the base contract since public getter functions are not

currently recognised as an implementation of the matching abstract

function by the compiler.

*/

/// total amount of tokens

uint256 public totalSupply;



/// @param _owner The address from which the balance will be retrieved

/// @return The balance

function balanceOf(address _owner) public constant returns (uint256 balance);



/// @notice send '_value' token to '_to' from 'msg.sender'

/// @param _to The address of the recipient

/// @param _value The amount of token to be transferred

/// @return Whether the transfer was successful or not

function transfer(address _to, uint256 _value) public returns (bool success);



/// @notice send '_value' token to '_to' from '_from' on the condition it is approved by '_from'

/// @param _from The address of the sender

/// @param _to The address of the recipient

/// @param _value The amount of token to be transferred

/// @return Whether the transfer was successful or not

function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);



/// @notice 'msg.sender' approves '_spender' to spend '_value' tokens

/// @param _spender The address of the account able to transfer the tokens

/// @param _value The amount of tokens to be approved for transfer

/// @return Whether the approval was successful or not

function approve(address _spender, uint256 _value) public returns (bool success);



/// @param _owner The address of the account owning tokens

/// @param _spender The address of the account able to transfer the tokens

/// @return Amount of remaining tokens allowed to spent

function allowance(address _owner, address _spender) public constant returns (uint256 remaining);



event Transfer(address indexed _from, address indexed _to, uint256 _value);

event Approval(address indexed _owner, address indexed _spender, uint256 _value);

}



contract SafeMath {



/* function assert(bool assertion) internal { */

/*   if (!assertion) { */

/*     revert(); */

/*   } */

/* }      // assert no longer needed once solidity is on 0.4.10 */



function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {

uint256 z = x + y;

assert((z >= x) && (z >= y));

return z;

}



function safeSubtract(uint256 x, uint256 y) internal pure returns(uint256) {

assert(x >= y);

uint256 z = x - y;

return z;

}



function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {

uint256 z = x * y;

assert((x == 0)||(z/x == y));

return z;

}



function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {

assert(b <= a);

return a - b;

}



}



contract StandardToken is Token, SafeMath {



function transfer(address _to, uint256 _value) public returns (bool success) {

//Default assumes totalSupply can't be over max (2^256 - 1).

//If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.

//Replace the if with this one instead.

//if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {

if (balances[msg.sender] >= _value && _value > 0) {

balances[msg.sender] -= _value;

balances[_to] += _value;

emit Transfer(msg.sender, _to, _value);

return true;

} else { return false; }

}



function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {

//same as above. Replace this line with the following if you want to protect against wrapping uints.

//if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {

if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {

balances[_to] += _value;

balances[_from] -= _value;

allowed[_from][msg.sender] -= _value;

emit Transfer(_from, _to, _value);

return true;

} else { return false; }

}



function balanceOf(address _owner) public constant returns (uint256 balance) {

return balances[_owner];

}



function approve(address _spender, uint256 _value) public returns (bool success) {

allowed[msg.sender][_spender] = _value;

emit Approval(msg.sender, _spender, _value);

return true;

}



function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {

return allowed[_owner][_spender];

}



mapping (address => uint256) balances;

mapping (address => mapping (address => uint256)) allowed;

}



contract TSETERIF is StandardToken {



// metadata

string public constant name = "TSETERIF";

string public constant symbol = "LIPS";

uint256 public constant decimals = 0;

string public version = "1.0";



// contracts

address public ethFundDeposit;      // beneficiary address.

address public tokenFundDeposit;     // initial token owner



// crowdsale parameters

bool public isFinalized;       // switched to true in operational state

uint256 public fundingStartBlock;

uint256 public fundingEndBlock;

uint256 public crowdsaleSupply = 0;         // crowdsale supply

uint256 public tokenExchangeRate = 1000000;   // how many tokens per 1 ETH

uint256 public constant tokenCreationCap =  88 * (10 ** 6) * 10 ** 18;

uint256 public tokenCrowdsaleCap =  80 * (10 ** 6) * 10 ** 18;

// events

event CreateTSETERIF(address indexed _to, uint256 _value);



// constructor

constructor() public

{

    isFinalized = false;                   //controls pre through crowdsale state

    ethFundDeposit = 0xbD4eF565DC5aD1835B005deBe75AbB815A757fDB;

    tokenFundDeposit = 0xbD4eF565DC5aD1835B005deBe75AbB815A757fDB;

    tokenExchangeRate = 1000000;

    fundingStartBlock = block.number;

    fundingEndBlock = fundingStartBlock + 24;

    totalSupply = tokenCreationCap;

    balances[tokenFundDeposit] = tokenCreationCap;    // deposit all token to the initial address.

    emit CreateTSETERIF(tokenFundDeposit, tokenCreationCap);

}



function () payable public {

assert(!isFinalized);

require(block.number >= fundingStartBlock);

require(block.number < fundingEndBlock);

require(msg.value > 0);



uint256 tokens = safeMult(msg.value, tokenExchangeRate);

crowdsaleSupply = safeAdd(crowdsaleSupply, tokens);



// return money if something goes wrong

require(tokenCrowdsaleCap >= crowdsaleSupply);



balances[msg.sender] = safeAdd(balances[msg.sender], tokens);     // add amount of tokens to sender

balances[tokenFundDeposit] = safeSub(balances[tokenFundDeposit], tokens); // subtracts amount from initial balance

emit CreateTSETERIF(msg.sender, tokens);

}

/// @dev Accepts ether and creates new tokens.

function createTokens() payable external {

require(!isFinalized);

require(block.number >= fundingStartBlock);

require(block.number < fundingEndBlock);

require(msg.value > 0);



uint256 tokens = safeMult(msg.value, tokenExchangeRate);    // check that we does not oversell

crowdsaleSupply = safeAdd(crowdsaleSupply, tokens);



// return money if something goes wrong

require(tokenCrowdsaleCap >= crowdsaleSupply);



balances[msg.sender] = safeAdd(balances[msg.sender], tokens);     // add amount of tokens to sender

balances[tokenFundDeposit] = safeSub(balances[tokenFundDeposit], tokens); // subtracts amount from initial balance

emit CreateTSETERIF(msg.sender, tokens);      // logs token creation

}



/// @dev Update crowdsale parameter

function updateParams(

uint256 _tokenExchangeRate,

uint256 _tokenCrowdsaleCap,

uint256 _fundingStartBlock,

uint256 _fundingEndBlock) external

{

assert(block.number < fundingStartBlock);

assert(!isFinalized);



// update system parameters

tokenExchangeRate = _tokenExchangeRate;

tokenCrowdsaleCap = _tokenCrowdsaleCap;

fundingStartBlock = _fundingStartBlock;

fundingEndBlock = _fundingEndBlock;

}



function checkContractBalance() public view returns(uint256) {

return address(this).balance;

}



/// @dev Ends the funding period and sends the ETH home

function finalize(uint256 _amount) external {

    assert(!isFinalized);



    // move to operational

    isFinalized = true;

    require(address(this).balance > _amount);

    ethFundDeposit.transfer(_amount);

}

}

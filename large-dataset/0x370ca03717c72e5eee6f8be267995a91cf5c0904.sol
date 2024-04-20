pragma solidity ^0.5.10;





/// @title An economic simulation and game

/// @author TheTokenPhysicist

/// @dev NatSpec comments provide broader information. Detailed comments available in source code

contract HODLcoin

//start contract

{

//NOTE: in general modifiers have been defined/placed just before the functions that use them



//STATE VARIABLES

//INTERNAL CONSTANTS

//internal constant used for math

uint256 constant internal MAGNITUDE = 2**64;

int256 constant internal IMAGNITUDE = 2**64;



//NOTE that 1ETHER = 1e18 wei

uint256 constant internal FEE_CYCLE_SIZE = 25e16 wei;

//(3277/65536 = 5.00%)

uint16 constant internal MAX_VARIANCE = 3277;

//(3276/65536 = 5.00%)

uint constant internal BASE_RATE = 3276;

//max rate = base_rate + max_variance (6553/65536 = 10.00%)

//limits for setup phase

uint256 constant internal SETUP_LIMIT = 6e18;

uint256 constant internal CONTRIBUTOR_PURCHASE_MAX = 25e17;

//parameters for token bonding curve

//set to 0.000001=10^-6 (ETH/token), i.e. 10^6 tokens/ETH (ignoring rise due to price increment)

uint256 constant internal TOKEN_PRICE_INITIAL = 0.000001 ether;

//set to 0.000000001=10^-9 (ETH/token), representing an increase of 10^-9 ETH in the price of each token per outstanding token

uint256 constant internal TOKEN_PRICE_INCREMENT = 0.000000001 ether;



//PUBLIC CONSTANTS

//ERC 20 standard for the number of decimals the token uses

uint8 constant public decimals = 18;



//PUBLIC VARIABLES

string public name = "HODLcoin";

string public symbol = "HODL";

//tracks total ether stored in unwithdrawn dividends

uint256 public _slushFundBalance = 0;

//initializes fee rate at BASE_RATE

uint16 public _feeRate = uint16(BASE_RATE);

//tracks total accumulated rewards per token

uint256 public _rewardsPerTokenAllTime = 0;

//tracks total existing number of tokens. named to match ERC-20 standard (see https://eips.ethereum.org/EIPS/eip-20)

uint256 public totalSupply = 0;

//partner contract address will be set IRREVERSIBLY by administrator in setup phase

//partner address initially set to administrator address to avoid divide by zero error on first token purchase

address payable public partnerAddress_ = msg.sender;

bool public partnerSet = false;

// when setupPhase is set to true, only contributors can purchase tokens - used during contract setup

//this is automatically switched off (irreversibly) after setupLimit is met, or can be switched off manually by admin with endSetupPhase()

bool public setupPhase = true;





//MAPPINGS

// track token balances

mapping(address => uint256) public tokenBalanceLedger_;

// track payouts

mapping(address => int256) public payoutsToLedger_;

//track approved addresses to allow transferFrom functionality - stored as allowance[from][spender] = allowance that [spender] is approved to send from [from]

//named to match ERC-20 standard

mapping(address => mapping(address => uint256)) allowance;

//track ether spending in setup phase

mapping(address => uint256) internal accumulatedContributorSpends_;

//tracks administrator(s) & contributors

mapping(address => bool) public administrator_;

mapping(address => bool) public contributors_;





//EVENTS

//when a transfer is completed

//also emitted for token mint/burn events, in which cases, respectively, from/to is set to the 0 address (matches ERC20 standard)

event Transfer(

    address indexed from,

    address indexed to,

    uint256 tokensTransferred

);

// ERC20 compliance

//when the tokenOwner address adjusts the allowance that the approvedAddress is allowed to transfer from the holdings of tokenOwner

//relevant to transferFrom functionality

event Approval(

    address indexed tokenOwner,

    address indexed approvedAddress,

    uint256 newAllowance

);

//when a player spends their rewards to purchase more tokens

event DoubleDown(

    address indexed playerAddress,

    uint256 etherValue, //etherValue of the spent rewards

    uint256 tokensMinted

);

//when a player withdraws their rewards as ether

event CashOut(

    address indexed playerAddress,

    uint256 etherValue

);

//event announced when the fee rate is recalculated (occurs whenever slush fund balance changes)

//NOTE: fee rate is represented as 16-bit int; calculations of the fee itself use value*feeRate/65536 (65536 = 2^16)

event AnnounceFeeRate(

    uint16 newFeeRate

);





//CONSTRUCTOR/INITIALIZATION

constructor()

    public

{

    //sets up admin(s) and contributors

    administrator_[msg.sender] = true; //TheTokenPhysicist -- Mastermind

    contributors_[msg.sender] = true;

    contributors_[0xF7388B6a9c65BCEECfaaB0beD560dc229A899848] = true; //MaddEconomist -- Advisor

    contributors_[0x8DA88ecAc7C71EDc34C742232C8D1fdc61C5f8bE] = true; //swimmingly -- Tester & design review

    contributors_[0x6Fa716966c81e8f907629f90352452d8F2dD0dF4] = true; //cryptoGENIUS17 -- Design consulting & editing

}





//FALLBACK

/// @notice fallback function. ensures that you still receive tokens if you just send money directly to the contract

/// @dev fallback function. buys tokens with all sent ether *unless* ether is sent from partner address; if it is, then distributes ether as rewards to token holders

function()

    external

    payable

{

    if ( msg.sender == partnerAddress_ ) {

        //convert money sent from partner contract into rewards for all token holders

        makeItRain();

    } else {

       purchaseTokens( msg.sender, msg.value ); 

    }

}





//EXTERNAL FUNCTIONS

/// @notice buys tokens with all sent funds. tokens are automatically credited to sender address

/// @dev emits event Transfer(address(0), playerAddress, newTokens) since function mint is called internally

function buyTokens()

    external

    payable

{

    purchaseTokens( msg.sender, msg.value );

}



/// @notice uses all of message sender's accumulated rewards to buy more tokens for the sender

/// @dev emits event DoubleDown(msg.sender, rewards , newTokens) and event Transfer(address(0), playerAddress, newTokens) since function mint is called internally

function doubleDown()

    external

{

    //pull current ether value of sender's rewards

    uint256 etherValue = rewardsOf( msg.sender );

    //update rewards tracker to reflect payout. performed before rewards are sent to prevent re-entrancy

    updateSpentRewards( msg.sender , etherValue);

    //update slush fund and fee rate

    _slushFundBalance -= etherValue;

    require( calcFeeRate(), "error in calling calcFeeRate" );

    // use rewards to buy new tokens

    uint256 newTokens = purchaseTokens(msg.sender , etherValue);

    //NOTE: purchaseTokens already emits an event, but this is useful for tracking specifically DoubleDown events

    emit DoubleDown(msg.sender, etherValue , newTokens);

}



/// @notice converts all of message senders's accumulated rewards into cold, hard ether

/// @dev emits event CashOut( msg.sender, etherValue )

/// @return etherValue sent to account holder

function cashOut()

    external

    returns (uint256 etherValue)

{

    //pull current ether value of sender's rewards

    etherValue = rewardsOf( msg.sender );

    //update rewards tracker to reflect payout. performed before rewards are sent to prevent re-entrancy

    updateSpentRewards( msg.sender , etherValue);

    //update slush fund and fee rate

    _slushFundBalance -= etherValue;

    require( calcFeeRate(), "error in calling calcFeeRate" );

    //transfer rewards to sender

    msg.sender.transfer( etherValue );

    //NOTE: purchaseTokens already emits an event, but this is useful for tracking specifically CashOut events

    emit CashOut( msg.sender, etherValue );

}



/// @notice sells all of sender's tokens

/// @dev emits event Transfer(playerAddress, address(0), amountTokens) since function burn is called internally

function sellAll()

    external

    returns (bool)

{

    uint256 tokens = tokenBalanceLedger_[msg.sender];

    if ( tokens > 0 ) {

        sell(tokens);

    }

    return true;

}



/// @notice sells desired number of message sender's tokens

/// @dev emits event Transfer(playerAddress, address(0), amountTokens) since function burn is called internally

/// @param amountTokens The number of tokens the sender wants to sell

function sellTokens( uint256 amountTokens )

    external

    returns (bool)

{

    require( amountTokens <= tokenBalanceLedger_[msg.sender], "insufficient funds available" );

    sell(amountTokens);

    return true;

}



/// @notice transfers tokens from sender to another address. Pays fee at same rate as buy/sell

/// @dev emits event Transfer( msg.sender, toAddress, tokensAfterFee )

/// @param toAddress Destination for transferred tokens

/// @param amountTokens The number of tokens the sender wants to transfer

function transfer( address toAddress, uint256 amountTokens )

    external

    returns( bool )

{

    //make sure message sender has the requested tokens (transfers also disabled during SetupPhase)

    require( ( amountTokens <= tokenBalanceLedger_[ msg.sender ] && !setupPhase ), "transfer not allowed" );

    //make the transfer internally

    require( transferInternal( msg.sender, toAddress, amountTokens ), "error in internal token transfer" );

    //ERC20 compliance

    return true;

}



/// @notice sets approved amount of tokens that an external address can transfer on behalf of the user

/// @dev emits event Approval(msg.sender, approvedAddress, amountTokens)

/// @param approvedAddress External address to give approval to (i.e. to give control to transfer sender's tokens)

/// @param amountTokens The number of tokens the sender wants to approve the external address to transfer for them

function approve( address approvedAddress, uint256 amountTokens)

    external

    returns (bool)

{

    allowance[msg.sender][approvedAddress] = amountTokens;

    emit Approval(msg.sender, approvedAddress, amountTokens);

    return true;

}



/// @notice increases approved amount of tokens that an external address can transfer on behalf of the user

/// @dev emits event Approval(msg.sender, approvedAddress, newAllowance)

/// @param approvedAddress External address to give approval to (i.e. to give control to transfer sender's tokens)

/// @param amountTokens The number of tokens by which the sender wants to increase the external address' allowance

function increaseAllowance( address approvedAddress, uint256 amountTokens)

    external

    returns (bool)

{

    uint256 pastAllowance = allowance[msg.sender][approvedAddress];

    uint256 newAllowance = SafeMath.add( pastAllowance , amountTokens );

    allowance[msg.sender][approvedAddress] = newAllowance;

    emit Approval(msg.sender, approvedAddress, newAllowance);

    return true;

}



/// @notice decreases approved amount of tokens that an external address can transfer on behalf of the user

/// @dev emits event Approval(msg.sender, approvedAddress, newAllowance)

/// @param approvedAddress External address to give approval to (i.e. to give control to transfer sender's tokens)

/// @param amountTokens The number of tokens by which the sender wants to decrease the external address' allowance

function decreaseAllowance( address approvedAddress, uint256 amountTokens)

    external

    returns (bool)

{

    uint256 pastAllowance = allowance[msg.sender][approvedAddress];

    uint256 newAllowance = SafeMath.sub( pastAllowance , amountTokens );

    allowance[msg.sender][approvedAddress] = newAllowance;

    emit Approval(msg.sender, approvedAddress, newAllowance);

    return true;

}



modifier checkTransferApproved(address fromAddress, uint256 amountTokens){

    require( allowance[fromAddress][msg.sender] <= amountTokens, "transfer not authorized (allowance insufficient)" );

    _;

} 

/// @notice transfers tokens from one address to another. Pays fee at same rate as buy/sell

/// @dev emits event Transfer( fromAddress, toAddress, tokensAfterFee )

/// @param fromAddress Account that sender wishes to transfer tokens from

/// @param toAddress Destination for transferred tokens

/// @param amountTokens The number of tokens the sender wants to transfer

function transferFrom(address payable fromAddress, address payable toAddress, uint256 amountTokens)

    checkTransferApproved(fromAddress , amountTokens)

    external

    returns (bool)

{

    // make sure sending address has requested tokens (transfers also disabled during SetupPhase)

    require( ( amountTokens <= tokenBalanceLedger_[ fromAddress ] && !setupPhase ), "transfer not allowed - insufficient funds available" );

    //update allowance (reduce it by tokens to be sent)

    uint256 pastAllowance = allowance[fromAddress][msg.sender];

    uint256 newAllowance = SafeMath.sub( pastAllowance , amountTokens );

    allowance[fromAddress][msg.sender] = newAllowance;

    //make the transfer internally

    require( transferInternal( fromAddress, toAddress, amountTokens ), "error in internal token transfer" ); 

    // ERC20 compliance

    return true;

}



/// @notice called by users to exchange between token types. Pays fee at half the rate of buy/sell

/// @param amountTokens the number of tokens the user wishes to exchange

function exchangeTokens( uint256 amountTokens )

    external

    returns(bool)

{

    // make sure sending address has requested tokens (transfers also disabled during SetupPhase)

    require( ( amountTokens <= tokenBalanceLedger_[ msg.sender ] && !setupPhase ), "transfer not allowed - insufficient funds available" );

    //mirrors valueAfterFee function, but with fee halved (half fee is also charged by the other contract)

    uint256 amountEther = tokensToEther( amountTokens );

    uint256 fee = SafeMath.div( ( amountEther * _feeRate / 2 ) , 65536 ); //fee

    uint256 valueAfterFee = SafeMath.sub( amountEther , fee ); //value after fee

    //destroys sold tokens (removes sold tokens from total token supply) and subtracts them from player balance

    //also updates reward tracker (payoutsToLedger_) for player address

    burn(msg.sender, amountTokens);

    //mirrors makeItRain function (distributes fee to token holders)

    uint256 addedRewards = SafeMath.mul( fee , MAGNITUDE );

    uint256 additionalRewardsPerToken = SafeMath.div( addedRewards , totalSupply );

    _rewardsPerTokenAllTime = SafeMath.add( _rewardsPerTokenAllTime , additionalRewardsPerToken );

    //updates balance in slush fund and calculates new fee rate

    require( updateSlushFund( fee ), "error in calling updateSlushFund" );

    //sends remainder to partner contract, to be used to buy tokens from that contract

    address payable buddy = partnerAddress_;

    ( bool success, bytes memory returnData ) = buddy.call.value( valueAfterFee )(abi.encodeWithSignature("incomingExchangeRequest(address)", msg.sender));

    //no need to check return data since partner is a trusted entity

    require( success, "failed to send funds to partner contract (not enough gas provided?)" );

    return true;    

}



/// @notice handles exchange. only callable by partner contract.

/// @param playerAddress passed on from call to exchangeTokens function. used to track player address

function incomingExchangeRequest( address playerAddress )

    external

    payable

    returns(bool)

{

    require( (msg.sender == partnerAddress_), "this function can only be called by the partner contract" );

    //mirrors valueAfterFee function, but with fee halved (half fee is also charged by the other contract)

    uint256 amountEther = msg.value;

    uint256 fee = SafeMath.div( ( amountEther * _feeRate / 2 ) , 65536 ); //fee

    uint256 valueAfterFee = SafeMath.sub( amountEther , fee ); //value after fee

    //mirrors makeItRain function (distributes fee to token holders)

    uint256 addedRewards = SafeMath.mul( fee , MAGNITUDE );

    uint256 additionalRewardsPerToken = SafeMath.div( addedRewards , totalSupply );

    _rewardsPerTokenAllTime = SafeMath.add( _rewardsPerTokenAllTime , additionalRewardsPerToken );

    //updates balance in slush fund and calculates new fee rate

    require( updateSlushFund( fee ), "error in calling updateSlushFund" );

    //mirrors purchaseTokens function

    uint256 amountTokens = etherToTokens( valueAfterFee );

    //adds new tokens to total token supply and gives them to the player

    //also updates reward tracker (payoutsToLedger_) for player address

    mint( playerAddress, amountTokens );

    return true;

}





//ADMIN ONLY FUNCTIONS (ALL EXTERNAL AS WELL)

//defines modifier for functions that only contract admin(s) can use

modifier onlyAdministrator() {  

    require( administrator_[ msg.sender ] == true, "function can only be called by contract admin" );

    _;

}

/// @notice admin only function. irreversibly sets address of partner contract

/// @param partner Address of partner contract

function setPartner( address payable partner)

    onlyAdministrator()

    public

{

    if ( partnerSet == false ) {

        partnerAddress_ = partner;

        partnerSet = true;

    }

}



/// @notice admin only function. irreversibly ends SetupPhase

/// @dev SetupPhase also ends automatically if contract holds more than (SETUP_LIMIT) in ether. see modifier purchaseAllowed(uint256 amountEther)

function endSetupPhase()

    onlyAdministrator()

    public

{

    setupPhase = false;

}



/// @notice admin only function. simple name change

/// @param newName Desired new name for contract

function setName( string memory newName )

    onlyAdministrator()

    public

{

    name = newName;

}



/// @notice admin only function. simple symbol change

/// @param newSymbol Desired new symbol for contract

function setSymbol( string memory newSymbol )

    onlyAdministrator()

    public

{

    symbol = newSymbol;

}





//HELPER FUNCTIONS (ALL EXTERNAL AS WELL) -- used to pull information

/// @notice returns current sell price for one token

function sellPrice() 

    external

    view

    returns(uint256)

{

    // avoid dividing by zero

    require(totalSupply != 0, "function called too early (supply is zero)");

    //represents selling one "full token" since the token has 18 decimals

    uint256 etherValue = tokensToEther( 1e18 );

    uint[2] memory feeAndValue = valueAfterFee( etherValue );

    return feeAndValue[1];

}



/// @notice calculates current buy price for one token

function currentBuyPrice() 

    external

    view

    returns(uint256)

{

    // avoid dividing by zero

    require(totalSupply != 0, "function called too early (supply is zero)");

    //represents buying one "full token" since the token has 18 decimals

    uint256 etherValue = tokensToEther( 1e18 );

    uint[2] memory feeAndValue = valueAfterFee( etherValue );

    //NOTE: this is not strictly correct, but gets very close to real purchase value

    uint256 totalCost = etherValue + feeAndValue[0];

    return totalCost;

}



/// @notice calculates number of tokens that can be bought at current price and fee rate for input amount of ether

/// @param etherValue Desired amount of ether from which to calculate equivalent number of tokens

/// @return amountTokens Expected return of tokens for spending etherValue

function calculateExpectedTokens(uint256 etherValue) 

    external

    view

    returns(uint256)

{

    uint256 etherAfterFee = valueAfterFee( etherValue )[1];

    uint256 amountTokens = etherToTokens( etherAfterFee );

    return amountTokens;

}



/// @notice calculates amount of ether (as wei) received if input number of tokens is sold at current price and fee rate

/// @param tokensToSell Desired number of tokens (as an integer) from which to calculate equivalent value of ether

/// @return etherAfterFee Amount of ether that would be received for selling tokens

function calculateExpectedWei(uint256 tokensToSell) 

    external

    view

    returns(uint256)

{

    require( tokensToSell <= totalSupply, "unable to calculate for amount of tokens greater than current supply" );

    //finds ether value of tokens before fee

    uint256 etherValue = tokensToEther( tokensToSell );

    //calculates ether after fee

    uint256 etherAfterFee = valueAfterFee( etherValue )[1];

    return etherAfterFee;

}



/// @notice returns total ether balance of contract

function totalEtherBalance()

    external

    view

    returns(uint)

{

    return address(this).balance;

}



/// @notice returns number of tokens owned by message sender

function myTokens()

    external

    view

    returns(uint256)

{

    return tokenBalanceLedger_[msg.sender];

}



/// @notice returns reward balance of message sender

function myRewards() 

    external 

    view 

    returns(uint256)

{

    return rewardsOf( msg.sender );

}



/// @notice returns token balance of desired address

/// @dev conforms to ERC-20 standard

/// @param playerAddress Address which sender wants to know the balance of

/// @return balance Current raw token balance of playerAddress

function balanceOf( address playerAddress )

    external

    view

    returns(uint256 balance)

{

    return (tokenBalanceLedger_[playerAddress]);

}





//PUBLIC FUNCTIONS

/// @notice function for donating to slush fund. adjusts current fee rate as fast as possible but does not give the message sender any tokens

/// @dev invoked internally when partner contract sends funds to this contract (see fallback function)

function makeItRain()

    public

    payable

    returns(bool)

{

    //avoid dividing by zero

    require(totalSupply != 0, "makeItRain function called too early (supply is zero)");

    uint256 amountEther = msg.value;

    uint256 addedRewards = SafeMath.mul( amountEther , MAGNITUDE );

    uint256 additionalRewardsPerToken = SafeMath.div( addedRewards , totalSupply );

    _rewardsPerTokenAllTime = SafeMath.add( _rewardsPerTokenAllTime , additionalRewardsPerToken );

    //updates balance in slush fund and calculates new fee rate

    require( updateSlushFund( amountEther ), "error in calling updateSlushFund" );

    return true;

}



/// @notice returns reward balance of desired address

/// @dev invoked internally in cashOut and doubleDown functions

/// @param playerAddress Address which sender wants to know the rewards balance of

/// @return playerRewards Current ether value of unspent rewards of playerAddress

function rewardsOf( address playerAddress )

    public

    view

    returns(uint256 playerRewards)

{

    playerRewards = (uint256) ( ( (int256)( _rewardsPerTokenAllTime * tokenBalanceLedger_[ playerAddress ] ) - payoutsToLedger_[ playerAddress ] ) / IMAGNITUDE );

    return playerRewards;

}





//INTERNAL FUNCTIONS

//recalculates fee rate given current contract state

function calcFeeRate()

    internal

    returns(bool)

{

    uint excessSlush = ( (_slushFundBalance % FEE_CYCLE_SIZE) * MAX_VARIANCE );

    uint16 cycleLocation = uint16( excessSlush / FEE_CYCLE_SIZE );

    uint16 newFeeRate = uint16( BASE_RATE + cycleLocation );

    //copy local variable to state variable

    _feeRate = newFeeRate;

    //anounce new rate

    emit AnnounceFeeRate( newFeeRate );

    return(true);

}



//updates balance in slush fund and calculates new fee rate

function updateSlushFund( uint256 amountEther )

    internal

    returns(bool)

{

    _slushFundBalance += amountEther;

    require( calcFeeRate(), "error in calling calcFeeRate" );

    return true;

}



//update rewards tracker when a user withdraws their rewards

function updateSpentRewards( address playerAddress, uint256 etherValue )

    internal

    returns(bool)

{

    int256 updatedPayouts = payoutsToLedger_[playerAddress] + int256 ( SafeMath.mul( etherValue, MAGNITUDE ) );

    require( (updatedPayouts >= payoutsToLedger_[playerAddress]), "ERROR: integer overflow in updateSpentRewards function" );

    payoutsToLedger_[playerAddress] = updatedPayouts;

    return true;

}



//updates rewards tracker. makes sure that player does not receive any rewards accumulated before they purchased/received these tokens

function updateRewardsOnPurchase( address playerAddress, uint256 amountTokens )

    internal

    returns(bool)

{

    int256 updatedPayouts = payoutsToLedger_[playerAddress] + int256 ( SafeMath.mul( _rewardsPerTokenAllTime, amountTokens ) );

    require( (updatedPayouts >= payoutsToLedger_[playerAddress]), "ERROR: integer overflow in updateRewardsOnPurchase function" );

    payoutsToLedger_[playerAddress] = updatedPayouts;    

    return true;

}



//adds new tokens to total token supply and gives them to the player

function mint(address playerAddress, uint256 amountTokens)

    internal

{

    require( playerAddress != address(0), "cannot mint tokens for zero address" );

    totalSupply = SafeMath.add( totalSupply, amountTokens );

    //updates rewards tracker. makes sure that player does not receive any rewards accumulated before they purchased these tokens

    updateRewardsOnPurchase( playerAddress, amountTokens );

    //give tokens to player. performed last to prevent re-entrancy attacks

    tokenBalanceLedger_[playerAddress] = SafeMath.add( tokenBalanceLedger_[playerAddress] , amountTokens );

    //event conforms to ERC-20 standard

    emit Transfer(address(0), playerAddress, amountTokens);

}



//Modifier that limits buying while contract setup occurs

modifier purchaseAllowed(uint256 amountEther){

    //check if still in setup phase

    if ( setupPhase ) {

        //check that sender is in contributor list

        require( contributors_[ msg.sender ] == true, "purchases currently limited only to contributors" );

        //check that sender hasn't deposited more ether than allowed

        uint256 contributorSpent = SafeMath.add( accumulatedContributorSpends_[ msg.sender ] , amountEther );

        require( contributorSpent <= CONTRIBUTOR_PURCHASE_MAX, "attempted purchase would exceed limit placed upon contributors" );

        //before SETUP_LIMIT is met, track contributor spends

        if ( ( address(this).balance + amountEther ) <= SETUP_LIMIT ) {

            //update the amount spent by address

            accumulatedContributorSpends_[ msg.sender ] = contributorSpent;

        } else {

        //if conditions have been met to end setup phase, then exit it automatically. admin also has ability to end setup phase manually

        setupPhase = false;

        }

    }

    _;

}

//gives appropriate number of tokens to purchasing address

function purchaseTokens(address payable playerAddress, uint256 etherValue)

    //checks if purchase allowed -- only relevant for limiting actions during setup phase

    purchaseAllowed( etherValue )    

    internal

    returns( uint256 )

{

    //calculates fee/rewards

    uint[2] memory feeAndValue = valueAfterFee( etherValue );

    //calculates tokens from postFee value of input ether

    uint256 amountTokens = etherToTokens( feeAndValue[1] );

    //avoid overflow errors

    require ( ( (amountTokens + totalSupply) > totalSupply), "purchase would cause integer overflow" );

    // send rewards to partner contract, to be distributed to its holders

    address payable buddy = partnerAddress_;

    ( bool success, bytes memory returnData ) = buddy.call.value( feeAndValue[0] )("");

    require( success, "failed to send funds to partner contract (not enough gas provided?)" );

    //adds new tokens to total token supply and gives them to the player

    //also updates reward tracker (payoutsToLedger_) for player address

    mint( playerAddress, amountTokens );

    return( amountTokens );

}



//update rewards tracker. makes sure that player can still withdraw rewards that accumulated while they were holding their sold/transferred tokens

function updateRewardsOnSale( address playerAddress, uint256 amountTokens )

    internal

    returns(bool)

{

    int256 updatedPayouts = payoutsToLedger_[playerAddress] - int256 ( SafeMath.mul( _rewardsPerTokenAllTime, amountTokens ) );

    require( (updatedPayouts <= payoutsToLedger_[playerAddress]), "ERROR: integer underflow in updateRewardsOnSale function" );

    payoutsToLedger_[playerAddress] = updatedPayouts;

    return true;

}



//destroys sold tokens (removes sold tokens from total token supply) and subtracts them from player balance

function burn(address playerAddress, uint256 amountTokens)

    internal

{

    require( playerAddress != address(0), "cannot burn tokens for zero address" );

    require( amountTokens <= tokenBalanceLedger_[ playerAddress ], "insufficient funds available" );

    //subtract tokens from player balance. performed first to prevent possibility of re-entrancy attacks

    tokenBalanceLedger_[playerAddress] = SafeMath.sub( tokenBalanceLedger_[playerAddress], amountTokens );

    //remove tokens from total supply

    totalSupply = SafeMath.sub( totalSupply, amountTokens );

    //update rewards tracker. makes sure that player can still withdraw rewards that accumulated while they were holding their sold tokens

    updateRewardsOnSale( playerAddress, amountTokens );

    //event conforms to ERC-20 standard

    emit Transfer(playerAddress, address(0), amountTokens);

  }



//sells desired amount of tokens for ether

function sell(uint256 amountTokens)

    internal

    returns (bool)

{

    require( amountTokens <= tokenBalanceLedger_[ msg.sender ], "insufficient funds available" );

    //calculates fee and net value to send to seller

    uint256 etherValue = tokensToEther( amountTokens );

    uint[2] memory feeAndValue = valueAfterFee( etherValue );

    //destroys sold tokens (removes sold tokens from total token supply) and subtracts them from player balance

    //also updates reward tracker (payoutsToLedger_) for player address

    burn(msg.sender, amountTokens);

    // sends rewards to partner contract, to be distributed to its holders

    address payable buddy = partnerAddress_;

    ( bool success, bytes memory returnData ) = buddy.call.value( feeAndValue[0] )("");

    require( success, "failed to send funds to partner contract (not enough gas provided?)" );

    //sends ether to seller

    //NOTE: occurs last to avoid re-entrancy attacks

    msg.sender.transfer( feeAndValue[1] );

    return true;

}



//takes in amount and returns fee to pay on it and the value after the fee

//classified as view since needs to access state (to pull current fee rate) but not write to it

function valueAfterFee( uint amount )

    internal

    view

    returns (uint[2] memory outArray_ )

{

    outArray_[0] = SafeMath.div( SafeMath.mul(amount, _feeRate), 65536 ); //fee

    outArray_[1] = SafeMath.sub( amount , outArray_[0] ); //value after fee

    return outArray_;

}



//returns purchased number of tokens based on linear bonding curve with fee

//it's the quadratic formula stupid!

function etherToTokens(uint256 etherValue)

    internal

    view

    returns(uint256)

{

    uint256 tokenPriceInitial = TOKEN_PRICE_INITIAL * 1e18;

    uint256 _tokensReceived = 

     (

        (

            // avoids underflow

            SafeMath.sub(

                ( sqrt( 

                        ( tokenPriceInitial**2 ) +

                        ( 2 * ( TOKEN_PRICE_INCREMENT * 1e18 ) * ( etherValue * 1e18 ) ) +

                        ( ( ( TOKEN_PRICE_INCREMENT ) ** 2 ) * ( totalSupply ** 2 ) ) +

                        ( 2 * ( TOKEN_PRICE_INCREMENT ) * tokenPriceInitial * totalSupply )

                    )

                ), tokenPriceInitial )

        ) / ( TOKEN_PRICE_INCREMENT )

    ) - ( totalSupply );

  

    return _tokensReceived;

}



//returns sell value of tokens based on linear bonding curve with fee

//~inverse of etherToTokens, but with rounding down to ensure contract is always more than solvent

function tokensToEther(uint256 inputTokens)

    internal

    view

    returns(uint256)

{

    uint256 tokens = ( inputTokens + 1e18 );

    uint256 functionTotalSupply = ( totalSupply + 1e18 );

    uint256 etherReceived = (

        // avoids underflow

        SafeMath.sub(

            ( (

                ( TOKEN_PRICE_INITIAL + ( TOKEN_PRICE_INCREMENT * ( functionTotalSupply / 1e18 ) ) )

               - TOKEN_PRICE_INCREMENT )

            * ( tokens - 1e18 ) ),

            ( TOKEN_PRICE_INCREMENT * ( ( tokens ** 2 - tokens ) / 1e18 ) ) / 2 )

        / 1e18 );

    return etherReceived;

}



//manages transfers of tokens in both transfer and transferFrom functions

function transferInternal( address fromAddress, address toAddress, uint256 amountTokens )

    internal

    returns( bool )

{

    uint[2] memory feeAndValue = valueAfterFee( amountTokens ); //(token fee) and (amount of tokens after fee)

    uint256 etherRewards = tokensToEther( feeAndValue[0] );

    //destroy the tokens paid as fee

    totalSupply = SafeMath.sub(totalSupply , feeAndValue[0]);

    //emit event to reflect destruction of tokens (conforms to ERC-20 standard)

    emit Transfer(fromAddress, address(0), feeAndValue[0]);

    //remove tokens from sending address

    tokenBalanceLedger_[ fromAddress ] = SafeMath.sub( tokenBalanceLedger_[ fromAddress ], amountTokens );

    //makes sure that receiving address does not receive any rewards accumulated before they received these tokens

    updateRewardsOnPurchase( toAddress, feeAndValue[1] );

    //give tokens to receiving address

    tokenBalanceLedger_[ toAddress ] = SafeMath.add( tokenBalanceLedger_[ toAddress ], feeAndValue[1] );

    //makes sure that sender can still withdraw rewards that accumulated while they were holding their transferred tokens

    //NOTE: uses amountTokens as input since this is what the sending address sends, while receiving address gets (feeAndValue[1]) tokens

    updateRewardsOnSale( fromAddress, amountTokens );

    //send rewards to partner contract, to be distributed to its holders

    address payable buddy = partnerAddress_;

    ( bool success, bytes memory returnData ) = buddy.call.value( etherRewards )("");

    require( success, "failed to send funds to partner contract (not enough gas provided?)" );

    // emit event

    emit Transfer( fromAddress, toAddress, feeAndValue[1] );

    return true;

}



//utility for calculating (approximate) square roots. simple implementation of Babylonian method

//see: https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method

function sqrt(uint x)

    internal

    pure

    returns (uint y)

{

    uint z = (x + 1) / 2;

    y = x;

    while (z < y)

    {

        y = z;

        z = (x / z + z) / 2;

    }

}



//end contract

}





//MATH OPERATIONS -- designed to avoid possibility of errors with built-in math functions

library SafeMath

{



//@dev Multiplies two numbers, throws on overflow.

function mul(uint256 a, uint256 b) internal pure returns (uint256) {

    if (a == 0) {

        return 0;

    }

    uint256 c = a * b;

    assert(c / a == b);

    return c;

}



//@dev Integer division of two numbers, truncating the quotient.

function div(uint256 a, uint256 b) internal pure returns (uint256) {

    // assert(b > 0); // Solidity automatically throws when dividing by 0

    uint256 c = a / b;

    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;

}



//@dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).

function sub(uint256 a, uint256 b) internal pure returns (uint256) {

    assert(b <= a);

    return a - b;

}



//@dev Adds two numbers, throws on overflow.

function add(uint256 a, uint256 b) internal pure returns (uint256) {

    uint256 c = a + b;

    assert(c >= a);

    return c;

}



//end library

}

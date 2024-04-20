pragma solidity ^0.4.24;



/**

 * Utility library of inline functions on addresses

 */

library AddressUtils {

  function isContract(address addr) internal view returns (bool) {

    uint256 size;

    assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly

    return size > 0;

  }



}



/**

 * @title SafeMath

 * @dev Math operations with safety checks that throw on error

 */

library SafeMath {



  /**

  * @dev Multiplies two numbers, throws on overflow.

  */

  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {

    if (a == 0) {

      return 0;

    }

    c = a * b;

    assert(c / a == b);

    return c;

  }



  /**

  * @dev Integer division of two numbers, truncating the quotient.

  */

  function div(uint256 a, uint256 b) internal pure returns (uint256) {

    return a / b;

  }



  /**

  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).

  */

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {

    assert(b <= a);

    return a - b;

  }



  /**

  * @dev Adds two numbers, throws on overflow.

  */

  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {

    c = a + b;

    assert(c >= a);

    return c;

  }

}



/**

 * @title Ownable

 * @dev The Ownable contract has an owner address, and provides basic authorization control

 * functions, this simplifies the implementation of "user permissions".

 */

contract Ownable {

  address public owner;



  // Can controller Address for ICO, Writen by Eli

  address public ICOController;



  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  // Writen by Eli

  event ControllerTransferred(address indexed previousController, address indexed newController);





  /**

   * @dev The Ownable constructor sets the original `owner` of the contract to the sender

   * account.

   */

  constructor () public {

    owner = msg.sender;

    // Writen by Eli

    ICOController = msg.sender;

  }



  /**

   * @dev Throws if called by any account other than the owner.

   */

  modifier onlyOwner() {

    require(msg.sender == owner);

    _;

  }



  /**

   * Check owner or Controller

   * Writen by Eli

   */

  modifier onlyController() {

    require(msg.sender == owner || msg.sender == ICOController);

    _;

  }



  /**

   * @dev Allows the current owner to transfer control of the contract to a newOwner.

   * @param newOwner The address to transfer ownership to.

   */

  function transferOwnership(address newOwner) public onlyOwner {

    require(newOwner != address(0));

    emit OwnershipTransferred(owner, newOwner);

    owner = newOwner;

  }



  /**

   * Set controller for ICO

   * Controlller can pause and resume Phase

   * Writen by Eli

   */

  function setController(address controller) public onlyOwner {

    require(controller != address(0));

    emit ControllerTransferred(ICOController, controller);

    ICOController = controller;

  }

}



/**

 * @title Pausable

 * @dev Base contract which allows children to implement an emergency stop mechanism.

 */

contract Pausable is Ownable {

  event Pause();

  event Unpause();



  bool public paused = true;





  /**

   * @dev Modifier to make a function callable only when the contract is not paused.

   */

  modifier whenNotPaused() {

    require(!paused);

    _;

  }



  /**

   * @dev Modifier to make a function callable only when the contract is paused.

   */

  modifier whenPaused() {

    require(paused);

    _;

  }



  /**

   * @dev called by the owner to pause, triggers stopped state

   */

  function pause() onlyOwner whenNotPaused public {

    paused = true;

    emit Pause();

  }



  /**

   * @dev called by the owner to unpause, returns to normal state

   */

  function unpause() onlyOwner whenPaused public {

    paused = false;

    emit Unpause();

  }

}



/**

 * @title ERC20Basic

 * @dev Simpler version of ERC20 interface

 * @dev see https://github.com/ethereum/EIPs/issues/179

 */

contract ERC20Basic {

  function totalSupply() public view returns (uint256);

  function balanceOf(address who) public view returns (uint256);

  function transfer(address to, uint256 value) public returns (bool);

  event Transfer(address indexed from, address indexed to, uint256 value);

}



/**

 * @title Basic token

 * @dev Basic version of StandardToken, with no allowances.

 */

contract BasicToken is ERC20Basic {

  using SafeMath for uint256;



  mapping(address => uint256) balances;



  uint256 totalSupply_;



  /**

  * @dev total number of tokens in existence

  */

  function totalSupply() public view returns (uint256) {

    return totalSupply_;

  }



  /**

  * @dev transfer token for a specified address

  * @param _to The address to transfer to.

  * @param _value The amount to be transferred.

  */

  function transfer(address _to, uint256 _value) public returns (bool) {

    require(_to != address(0));

    require(_value <= balances[msg.sender]);



    balances[msg.sender] = balances[msg.sender].sub(_value);

    balances[_to] = balances[_to].add(_value);

    emit Transfer(msg.sender, _to, _value);

    return true;

  }



  /**

  * @dev Gets the balance of the specified address.

  * @param _owner The address to query the the balance of.

  * @return An uint256 representing the amount owned by the passed address.

  */

  function balanceOf(address _owner) public view returns (uint256) {

    return balances[_owner];

  }



}



/**

 * @title ERC20 interface

 * @dev see https://github.com/ethereum/EIPs/issues/20

 */

contract ERC20 is ERC20Basic {

  function allowance(address owner, address spender) public view returns (uint256);

  function transferFrom(address from, address to, uint256 value) public returns (bool);

  function approve(address spender, uint256 value) public returns (bool);

  event Approval(address indexed owner, address indexed spender, uint256 value);

}



/**

 * @title Standard ERC20 token

 */

contract StandardToken is ERC20, BasicToken {



  mapping (address => mapping (address => uint256)) internal allowed;





  /**

   * @dev Transfer tokens from one address to another

   * @param _from address The address which you want to send tokens from

   * @param _to address The address which you want to transfer to

   * @param _value uint256 the amount of tokens to be transferred

   */

  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {

    require(_to != address(0));

    require(_value <= balances[_from]);

    require(_value <= allowed[_from][msg.sender]);



    balances[_from] = balances[_from].sub(_value);

    balances[_to] = balances[_to].add(_value);

    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);

    emit Transfer(_from, _to, _value);

    return true;

  }



  /**

   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.

   *

   * Beware that changing an allowance with this method brings the risk that someone may use both the old

   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this

   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:

   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729

   * @param _spender The address which will spend the funds.

   * @param _value The amount of tokens to be spent.

   */

  function approve(address _spender, uint256 _value) public returns (bool) {

    allowed[msg.sender][_spender] = _value;

    emit Approval(msg.sender, _spender, _value);

    return true;

  }



  /**

   * @dev Function to check the amount of tokens that an owner allowed to a spender.

   * @param _owner address The address which owns the funds.

   * @param _spender address The address which will spend the funds.

   * @return A uint256 specifying the amount of tokens still available for the spender.

   */

  function allowance(address _owner, address _spender) public view returns (uint256) {

    return allowed[_owner][_spender];

  }



  /**

   * @dev Increase the amount of tokens that an owner allowed to a spender.

   *

   * approve should be called when allowed[_spender] == 0. To increment

   * allowed value is better to use this function to avoid 2 calls (and wait until

   * the first transaction is mined)

   * From MonolithDAO Token.sol

   * @param _spender The address which will spend the funds.

   * @param _addedValue The amount of tokens to increase the allowance by.

   */

  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {

    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);

    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);

    return true;

  }



  /**

   * @dev Decrease the amount of tokens that an owner allowed to a spender.

   *

   * approve should be called when allowed[_spender] == 0. To decrement

   * allowed value is better to use this function to avoid 2 calls (and wait until

   * the first transaction is mined)

   * From MonolithDAO Token.sol

   * @param _spender The address which will spend the funds.

   * @param _subtractedValue The amount of tokens to decrease the allowance by.

   */

  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {

    uint oldValue = allowed[msg.sender][_spender];

    if (_subtractedValue > oldValue) {

      allowed[msg.sender][_spender] = 0;

    } else {

      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);

    }

    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);

    return true;

  }



}



/**

 * @title Mintable token

 * @dev Simple ERC20 Token example, with mintable token creation

 * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120

 * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol

 */

contract MintableToken is StandardToken, Ownable {

  event Mint(address indexed to, uint256 amount);

  event MintFinished();



  bool public mintingFinished = false;





  modifier canMint() {

    require(!mintingFinished);

    _;

  }



  /**

   * @dev Function to mint tokens

   * @param _to The address that will receive the minted tokens.

   * @param _amount The amount of tokens to mint.

   * @return A boolean that indicates if the operation was successful.

   */

  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {

    totalSupply_ = totalSupply_.add(_amount);

    balances[_to] = balances[_to].add(_amount);

    emit Mint(_to, _amount);

    emit Transfer(address(0), _to, _amount);

    return true;

  }



  /**

   * @dev Function to stop minting new tokens.

   * @return True if the operation was successful.

   */

  function finishMinting() onlyOwner canMint public returns (bool) {

    mintingFinished = true;

    emit MintFinished();

    return true;

  }

}



// Abstract base contract

contract KYCBase {

    using SafeMath for uint256;



    mapping (address => bool) public isKycSigner;

    mapping (uint64 => uint256) public alreadyPayed;



    event KycVerified(address indexed signer, address buyerAddress, uint64 buyerId, uint maxAmount);



    constructor(address[] kycSigners) internal {

        for (uint i = 0; i < kycSigners.length; i++) {

            isKycSigner[kycSigners[i]] = true;

        }

    }



    // Must be implemented in descending contract to assign tokens to the buyers. Called after the KYC verification is passed

    function releaseTokensTo(address buyer) internal returns(bool);



    // This method can be overridden to enable some sender to buy token for a different address

    function senderAllowedFor(address buyer)

        internal view returns(bool)

    {

        return buyer == msg.sender;

    }



    function buyTokensFor(address buyerAddress, uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)

        public payable returns (bool)

    {

        require(senderAllowedFor(buyerAddress), "senderAllowedFor");

        return buyImplementation(buyerAddress, buyerId, maxAmount, v, r, s);

    }



    function buyTokens(uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)

        public payable returns (bool)

    {

        return buyImplementation(msg.sender, buyerId, maxAmount, v, r, s);

    }



    function buyImplementation(

        address buyerAddress,

        uint64 buyerId,

        uint maxAmount,

        uint8 v,

        bytes32 r,

        bytes32 s

    ) private returns (bool)

    {

        // check the signature

        bytes32 hash = sha256(

            abi.encodePacked(

                "Eidoo icoengine authorization",

                this,

                buyerAddress,

                buyerId,

                maxAmount

            )

        );

        address signer = ecrecover(hash, v, r, s);

        if (!isKycSigner[signer]) {

            revert("!isKycSigner");

        } else {

            uint256 totalPayed = alreadyPayed[buyerId].add(msg.value);

            require(totalPayed <= maxAmount, "totalPayed <= maxAmount");

            alreadyPayed[buyerId] = totalPayed;

            emit KycVerified(signer, buyerAddress, buyerId, maxAmount);

            return releaseTokensTo(buyerAddress);

        }

    }



    // No payable fallback function, the tokens must be buyed using the functions buyTokens and buyTokensFor

    function () public {

        revert();

    }

}



/**

 * @title WhitelistableConstraints

 * @dev Contract encapsulating the constraints applicable to a Whitelistable contract.

 */

contract WhitelistableConstraints {



    /**

     * @dev Check if whitelist with specified parameters is allowed.

     * @param _maxWhitelistLength The maximum length of whitelist. Zero means no whitelist.

     * @param _weiWhitelistThresholdBalance The threshold balance triggering whitelist check.

     * @return true if whitelist with specified parameters is allowed, false otherwise

     */

    function isAllowedWhitelist(uint256 _maxWhitelistLength, uint256 _weiWhitelistThresholdBalance)

        public pure returns(bool isReallyAllowedWhitelist) {

        return _maxWhitelistLength > 0 || _weiWhitelistThresholdBalance > 0;

    }

}



/**

 * @title Whitelistable

 * @dev Base contract implementing a whitelist to keep track of investors.

 * The construction parameters allow for both whitelisted and non-whitelisted contracts:

 * 1) maxWhitelistLength = 0 and whitelistThresholdBalance > 0: whitelist disabled

 * 2) maxWhitelistLength > 0 and whitelistThresholdBalance = 0: whitelist enabled, full whitelisting

 * 3) maxWhitelistLength > 0 and whitelistThresholdBalance > 0: whitelist enabled, partial whitelisting

 */

contract Whitelistable is WhitelistableConstraints {



    event LogMaxWhitelistLengthChanged(address indexed caller, uint256 indexed maxWhitelistLength);

    event LogWhitelistThresholdBalanceChanged(address indexed caller, uint256 indexed whitelistThresholdBalance);

    event LogWhitelistAddressAdded(address indexed caller, address indexed subscriber);

    event LogWhitelistAddressRemoved(address indexed caller, address indexed subscriber);



    mapping (address => bool) public whitelist;



    uint256 public whitelistLength;



    uint256 public maxWhitelistLength;



    uint256 public whitelistThresholdBalance;



    constructor(uint256 _maxWhitelistLength, uint256 _whitelistThresholdBalance) internal {

        require(isAllowedWhitelist(_maxWhitelistLength, _whitelistThresholdBalance), "parameters not allowed");



        maxWhitelistLength = _maxWhitelistLength;

        whitelistThresholdBalance = _whitelistThresholdBalance;

    }



    /**

     * @return true if whitelist is currently enabled, false otherwise

     */

    function isWhitelistEnabled() public view returns(bool isReallyWhitelistEnabled) {

        return maxWhitelistLength > 0;

    }



    /**

     * @return true if subscriber is whitelisted, false otherwise

     */

    function isWhitelisted(address _subscriber) public view returns(bool isReallyWhitelisted) {

        return whitelist[_subscriber];

    }



    function setMaxWhitelistLengthInternal(uint256 _maxWhitelistLength) internal {

        require(isAllowedWhitelist(_maxWhitelistLength, whitelistThresholdBalance),

            "_maxWhitelistLength not allowed");

        require(_maxWhitelistLength != maxWhitelistLength, "_maxWhitelistLength equal to current one");



        maxWhitelistLength = _maxWhitelistLength;



        emit LogMaxWhitelistLengthChanged(msg.sender, maxWhitelistLength);

    }



    function setWhitelistThresholdBalanceInternal(uint256 _whitelistThresholdBalance) internal {

        require(isAllowedWhitelist(maxWhitelistLength, _whitelistThresholdBalance),

            "_whitelistThresholdBalance not allowed");

        require(whitelistLength == 0 || _whitelistThresholdBalance > whitelistThresholdBalance,

            "_whitelistThresholdBalance not greater than current one");



        whitelistThresholdBalance = _whitelistThresholdBalance;



        emit LogWhitelistThresholdBalanceChanged(msg.sender, _whitelistThresholdBalance);

    }



    function addToWhitelistInternal(address _subscriber) internal {

        require(_subscriber != address(0), "_subscriber is zero");

        require(!whitelist[_subscriber], "already whitelisted");

        require(whitelistLength < maxWhitelistLength, "max whitelist length reached");



        whitelistLength++;



        whitelist[_subscriber] = true;



        emit LogWhitelistAddressAdded(msg.sender, _subscriber);

    }



    function removeFromWhitelistInternal(address _subscriber, uint256 _balance) internal {

        require(_subscriber != address(0), "_subscriber is zero");

        require(whitelist[_subscriber], "not whitelisted");

        require(_balance <= whitelistThresholdBalance, "_balance greater than whitelist threshold");



        assert(whitelistLength > 0);



        whitelistLength--;



        whitelist[_subscriber] = false;



        emit LogWhitelistAddressRemoved(msg.sender, _subscriber);

    }



    /**

     * @param _subscriber The subscriber for which the balance check is required.

     * @param _balance The balance value to check for allowance.

     * @return true if the balance is allowed for the subscriber, false otherwise

     */

    function isAllowedBalance(address _subscriber, uint256 _balance) public view returns(bool isReallyAllowed) {

        return !isWhitelistEnabled() || _balance <= whitelistThresholdBalance || whitelist[_subscriber];

    }

}



/**

 * @title CrowdsaleKYC 

 * @dev Crowdsale is a base contract for managing a token crowdsale.

 * Crowdsales have a start and end block, where investors can make

 * token purchases and the crowdsale will assign them tokens based

 * on a token per ETH rate. Funds collected are forwarded to a wallet 

 * as they arrive.

 */

contract CrowdsaleKYC is Pausable, Whitelistable, KYCBase {

    using AddressUtils for address;

    using SafeMath for uint256;



    event LogStartBlockChanged(uint256 indexed startBlock);

    event LogEndBlockChanged(uint256 indexed endBlock);

    event LogMinDepositChanged(uint256 indexed minDeposit);

    event LogTokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 indexed amount, uint256 tokenAmount);

    event AddedSenderAllowed(address semder);

    event RemovedSenderAllowed(address semder);



    // The token being sold

    MintableToken public token;



    // The start and end block where investments are allowed (both inclusive)

    uint256 public startBlock;

    uint256 public endBlock;



    // How many token units a buyer gets per wei

    uint256 public rate;



    // Amount of raised money in wei

    uint256 public raisedFunds;



    // Amount of tokens already sold

    uint256 public soldTokens;



    // Balances in wei deposited by each subscriber

    mapping (address => uint256) public balanceOf;



    // The minimum balance for each subscriber in wei

    uint256 public minDeposit;



    // Senders allowed for buyTokensFor function

    mapping (address => bool) public isAllowedSender;

    

    // Check soldout tokens function. must override function

    // Writen by Eli

    function checkSoldout() internal returns (bool isSoldout);

    function setNextPhaseBlock() internal;

    function startNextPhase(uint256 _startBlock) internal;



    modifier beforeStart() {

        require(block.number < startBlock, "already started");

        _;

    }



    modifier beforeEnd() {

        require(block.number <= endBlock, "already ended");

        _;

    }



    constructor(

        uint256 _startBlock,

        uint256 _endBlock,

        uint256 _rate,

        uint256 _minDeposit,

        uint256 maxWhitelistLength,

        uint256 whitelistThreshold,

        address[] kycSigner

    )

    Whitelistable(maxWhitelistLength, whitelistThreshold)

    KYCBase(kycSigner) internal

    {

        require(_startBlock >= block.number, "_startBlock is lower than current block.number");

        require(_endBlock >= _startBlock, "_endBlock is lower than _startBlock");

        require(_rate > 0, "_rate is zero");

        require(_minDeposit > 0, "_minDeposit is zero");



        startBlock = _startBlock;

        endBlock = _endBlock;

        rate = _rate;

        minDeposit = _minDeposit;

    }



    //override KYCBase.senderAllowedFor

    function senderAllowedFor(address buyer)

        internal view returns(bool)

    {

        //revert(appendStr("override KYCBase.senderAllowedFor", toAsciiString(msg.sender), isAllowedSender[buyer]));

        return isAllowedSender[msg.sender] == true;

    }



    function addSenderAllowed(address _sender) external onlyOwner {

        isAllowedSender[_sender] = true;

        emit AddedSenderAllowed(_sender);

    }



    function removeSenderAllowed(address _sender) external onlyOwner {

        delete isAllowedSender[_sender];

        emit RemovedSenderAllowed(_sender);

    }



    /*

    * @return true if crowdsale event has started

    */

    function hasStarted() public view returns (bool started) {

        return block.number >= startBlock;

    }



    /*

    * @return true if crowdsale event has ended

    */

    function hasEnded() public view returns (bool ended) {

        return block.number > endBlock;

    }



    /**

     * Change the crowdsale start block number.

     * @param _startBlock The new start block

     */

    function setStartBlock(uint256 _startBlock) external onlyOwner beforeStart {

        require(_startBlock >= block.number, "_startBlock < current block");

        require(_startBlock <= endBlock, "_startBlock > endBlock");

        require(_startBlock != startBlock, "_startBlock == startBlock");



        startBlock = _startBlock;



        emit LogStartBlockChanged(_startBlock);

    }



    /**

     * Change the crowdsale end block number.

     * @param _endBlock The new end block

     */

    function setEndBlock(uint256 _endBlock) external onlyOwner beforeEnd {

        require(_endBlock >= block.number, "_endBlock < current block");

        require(_endBlock >= startBlock, "_endBlock < startBlock");

        require(_endBlock != endBlock, "_endBlock == endBlock");



        endBlock = _endBlock;



        emit LogEndBlockChanged(_endBlock);

    }



    /**

     * Change the minimum deposit for each subscriber. New value shall be lower than previous.

     * @param _minDeposit The minimum deposit for each subscriber, expressed in wei

     */

    function setMinDeposit(uint256 _minDeposit) external onlyOwner beforeEnd {

        require(0 < _minDeposit && _minDeposit < minDeposit, "_minDeposit is not in [0, minDeposit]");



        minDeposit = _minDeposit;



        emit LogMinDepositChanged(minDeposit);

    }



    /**

     * Change the maximum whitelist length. New value shall satisfy the #isAllowedWhitelist conditions.

     * @param maxWhitelistLength The maximum whitelist length

     */

    function setMaxWhitelistLength(uint256 maxWhitelistLength) external onlyOwner beforeEnd {

        setMaxWhitelistLengthInternal(maxWhitelistLength);

    }



    /**

     * Change the whitelist threshold balance. New value shall satisfy the #isAllowedWhitelist conditions.

     * @param whitelistThreshold The threshold balance (in wei) above which whitelisting is required to invest

     */

    function setWhitelistThresholdBalance(uint256 whitelistThreshold) external onlyOwner beforeEnd {

        setWhitelistThresholdBalanceInternal(whitelistThreshold);

    }



    /**

     * Add the subscriber to the whitelist.

     * @param subscriber The subscriber to add to the whitelist.

     */

    function addToWhitelist(address subscriber) external onlyOwner beforeEnd {

        addToWhitelistInternal(subscriber);

    }



    /**

     * Removed the subscriber from the whitelist.

     * @param subscriber The subscriber to remove from the whitelist.

     */

    function removeFromWhitelist(address subscriber) external onlyOwner beforeEnd {

        removeFromWhitelistInternal(subscriber, balanceOf[subscriber]);

    }



    // // fallback function can be used to buy tokens

    // function () external payable whenNotPaused {

    //     buyTokens(msg.sender);

    // }



    // No payable fallback function, the tokens must be buyed using the functions buyTokens and buyTokensFor

    function () public {

        revert("No payable fallback function");

    }



    function uint2str(uint i) internal pure returns (string){

        if (i == 0) return "0";

        uint j = i;

        uint length;

        while (j != 0){

            length++;

            j /= 10;

        }

        bytes memory bstr = new bytes(length);

        uint k = length - 1;

        while (i != 0){

            bstr[k--] = byte(48 + i % 10);

            i /= 10;

        }

        return string(bstr);

    }



    // low level token purchase function

    // function buyTokens(address beneficiary) public payable whenNotPaused {

    function releaseTokensTo(address beneficiary) internal whenNotPaused returns(bool) {

        require(beneficiary != address(0), "beneficiary is zero");

        require(isValidPurchase(beneficiary), "invalid purchase by beneficiary");

        

        balanceOf[beneficiary] = balanceOf[beneficiary].add(msg.value);



        raisedFunds = raisedFunds.add(msg.value);



        uint256 tokenAmount = calculateTokens(msg.value);



        soldTokens = soldTokens.add(tokenAmount);

        

        // revert(appendStr("releaseTokensTo", toAsciiString(beneficiary), uint2str(tokenAmount)));

        

        distributeTokens(beneficiary, tokenAmount);



        //distributeTokens(address(0), 1);



        emit LogTokenPurchase(msg.sender, beneficiary, msg.value, tokenAmount);



        forwardFunds(msg.value);



        if (checkSoldout()) {

            /*

             * When soldout this phase,

             * Writen by Eli

             */

            setNextPhaseBlock();

            /* If soldout token, one day break(approximately)*/

            startNextPhase(block.number + 6000);

        }

        return true;

    }



    /**

     * @dev Overrides Whitelistable#isAllowedBalance to add minimum deposit logic.

     */

    function isAllowedBalance(address beneficiary, uint256 balance) public view returns (bool isReallyAllowed) {

        bool hasMinimumBalance = balance >= minDeposit;

        return hasMinimumBalance && super.isAllowedBalance(beneficiary, balance);

    }



    /**

     * @dev Determine if the token purchase is valid or not.

     * @return true if the transaction can buy tokens

     */

    function isValidPurchase(address beneficiary) internal view returns (bool isValid) {

        bool withinPeriod = startBlock <= block.number && block.number <= endBlock;

        bool nonZeroPurchase = msg.value != 0;

        bool isValidBalance = isAllowedBalance(beneficiary, balanceOf[beneficiary].add(msg.value));



        return withinPeriod && nonZeroPurchase && isValidBalance;

    }



    // Calculate the token amount given the invested ether amount.

    // Override to create custom fund forwarding mechanisms

    function calculateTokens(uint256 amount) internal view returns (uint256 tokenAmount) {

        return amount.mul(rate);

    }



    /**

     * @dev Distribute the token amount to the beneficiary.

     * @notice Override to create custom distribution mechanisms

     */

    function distributeTokens(address beneficiary, uint256 tokenAmount) internal {

        token.mint(beneficiary, tokenAmount);

    }



    // Send ether amount to the fund collection wallet.

    // override to create custom fund forwarding mechanisms

    function forwardFunds(uint256 amount) internal;

}



/**

 * @title Burnable Token

 * @dev Token that can be irreversibly burned (destroyed).

 */

contract BurnableToken is BasicToken {



  event Burn(address indexed burner, uint256 value);



  /**

   * @dev Burns a specific amount of tokens.

   * @param _value The amount of token to be burned.

   */

  function burn(uint256 _value) public {

    _burn(msg.sender, _value);

  }



  function _burn(address _who, uint256 _value) internal {

    require(_value <= balances[_who]);

    // no need to require value <= totalSupply, since that would imply the

    // sender's balance is greater than the totalSupply, which *should* be an assertion failure



    balances[_who] = balances[_who].sub(_value);

    totalSupply_ = totalSupply_.sub(_value);

    emit Burn(_who, _value);

    emit Transfer(_who, address(0), _value);

  }

}



contract DetailedERC20 is ERC20 {

  string public name;

  string public symbol;

  uint8 public decimals;



  constructor (string _name, string _symbol, uint8 _decimals) public {

    name = _name;

    symbol = _symbol;

    decimals = _decimals;

  }

}



/**

 * @title SafeERC20

 * @dev Wrappers around ERC20 operations that throw on failure.

 * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,

 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.

 */

library SafeERC20 {

  function safeTransfer(ERC20Basic token, address to, uint256 value) internal {

    assert(token.transfer(to, value));

  }



  function safeTransferFrom(

    ERC20 token,

    address from,

    address to,

    uint256 value

  )

    internal

  {

    assert(token.transferFrom(from, to, value));

  }



  function safeApprove(ERC20 token, address spender, uint256 value) internal {

    assert(token.approve(spender, value));

  }

}



/**

 * @title TokenTimelock

 * @dev TokenTimelock is a token holder contract that will allow a

 * beneficiary to extract the tokens after a given release time

 */

contract TokenTimelock {

  using SafeERC20 for ERC20Basic;



  // ERC20 basic token contract being held

  ERC20Basic public token;



  // beneficiary of tokens after they are released

  address public beneficiary;



  // timestamp when token release is enabled

  uint256 public releaseTime;



  constructor (ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {

    // solium-disable-next-line security/no-block-members

    require(_releaseTime > block.timestamp);

    token = _token;

    beneficiary = _beneficiary;

    releaseTime = _releaseTime;

  }



  /**

   * @notice Transfers tokens held by timelock to beneficiary.

   */

  function release() public {

    // solium-disable-next-line security/no-block-members

    require(block.timestamp >= releaseTime);



    uint256 amount = token.balanceOf(this);

    require(amount > 0);



    token.safeTransfer(beneficiary, amount);

  }

}



/**

 * @title TokenVesting

 * @dev A token holder contract that can release its token balance gradually like a

 * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the

 * owner.

 */

contract TokenVesting is Ownable {

  using SafeMath for uint256;

  using SafeERC20 for ERC20Basic;



  event Released(uint256 amount);

  event Revoked();



  // beneficiary of tokens after they are released

  address public beneficiary;



  uint256 public cliff;

  uint256 public start;

  uint256 public duration;



  bool public revocable;



  mapping (address => uint256) public released;

  mapping (address => bool) public revoked;



  /**

   * @dev Creates a vesting contract that vests its balance of any ERC20 token to the

   * _beneficiary, gradually in a linear fashion until _start + _duration. By then all

   * of the balance will have vested.

   * @param _beneficiary address of the beneficiary to whom vested tokens are transferred

   * @param _cliff duration in seconds of the cliff in which tokens will begin to vest

   * @param _duration duration in seconds of the period in which the tokens will vest

   * @param _revocable whether the vesting is revocable or not

   */

  constructor (

    address _beneficiary,

    uint256 _start,

    uint256 _cliff,

    uint256 _duration,

    bool _revocable

  )

    public

  {

    require(_beneficiary != address(0));

    require(_cliff <= _duration);



    beneficiary = _beneficiary;

    revocable = _revocable;

    duration = _duration;

    cliff = _start.add(_cliff);

    start = _start;

  }



  /**

   * @notice Transfers vested tokens to beneficiary.

   * @param token ERC20 token which is being vested

   */

  function release(ERC20Basic token) public {

    uint256 unreleased = releasableAmount(token);



    require(unreleased > 0);



    released[token] = released[token].add(unreleased);



    token.safeTransfer(beneficiary, unreleased);



    emit Released(unreleased);

  }



  /**

   * @notice Allows the owner to revoke the vesting. Tokens already vested

   * remain in the contract, the rest are returned to the owner.

   * @param token ERC20 token which is being vested

   */

  function revoke(ERC20Basic token) public onlyOwner {

    require(revocable);

    require(!revoked[token]);



    uint256 balance = token.balanceOf(this);



    uint256 unreleased = releasableAmount(token);

    uint256 refund = balance.sub(unreleased);



    revoked[token] = true;



    token.safeTransfer(owner, refund);



    emit Revoked();

  }



  /**

   * @dev Calculates the amount that has already vested but hasn't been released yet.

   * @param token ERC20 token which is being vested

   */

  function releasableAmount(ERC20Basic token) public view returns (uint256) {

    return vestedAmount(token).sub(released[token]);

  }



  /**

   * @dev Calculates the amount that has already vested.

   * @param token ERC20 token which is being vested

   */

  function vestedAmount(ERC20Basic token) public view returns (uint256) {

    uint256 currentBalance = token.balanceOf(this);

    uint256 totalBalance = currentBalance.add(released[token]);



    if (block.timestamp < cliff) {

      return 0;

    } else if (block.timestamp >= start.add(duration) || revoked[token]) {

      return totalBalance;

    } else {

      return totalBalance.mul(block.timestamp.sub(start)).div(duration);

    }

  }

}



/**

* @dev The KTunePricingPlan contract defines the responsibilities of a KTune pricing plan.

*/

contract KTunePricingPlan {

    /**

    * @dev Pay the fee for the service identified by the specified name.

    * The fee amount shall already be approved by the client.

    * @param serviceName The name of the target service.

    * @param multiplier The multiplier of the base service fee to apply.

    * @param client The client of the target service.

    * @return true if fee has been paid.

    */

    function payFee(bytes32 serviceName, uint256 multiplier, address client) public returns(bool paid);



    /**

    * @dev Get the usage fee for the service identified by the specified name.

    * The returned fee amount shall be approved before using #payFee method.

    * @param serviceName The name of the target service.

    * @param multiplier The multiplier of the base service fee to apply.

    * @return The amount to approve before really paying such fee.

    */

    function usageFee(bytes32 serviceName, uint256 multiplier) public constant returns(uint fee);

}



contract KTuneCustomToken is Ownable {



    event LogBurnFinished();

    event LogPricingPlanChanged(address indexed caller, address indexed pricingPlan);



    // The pricing plan determining the fee to be paid in KTune tokens by customers for using KTune services

    KTunePricingPlan public pricingPlan;



    // The entity acting as Custom Token service provider i.e. Noku

    address public serviceProvider;



    // Flag indicating if Custom Token burning has been permanently finished or not.

    bool public burningFinished;



    /**

    * @dev Modifier to make a function callable only by service provider i.e. Noku.

    */

    modifier onlyServiceProvider() {

        require(msg.sender == serviceProvider, "caller is not service provider");

        _;

    }



    modifier canBurn() {

        require(!burningFinished, "burning finished");

        _;

    }



    constructor(address _pricingPlan, address _serviceProvider) internal {

        require(_pricingPlan != 0, "_pricingPlan is zero");

        require(_serviceProvider != 0, "_serviceProvider is zero");



        pricingPlan = KTunePricingPlan(_pricingPlan);

        serviceProvider = _serviceProvider;

    }



    /**

    * @dev Presence of this function indicates the contract is a Custom Token.

    */

    function isCustomToken() public pure returns(bool isCustom) {

        return true;

    }



    /**

    * @dev Stop burning new tokens.

    * @return true if the operation was successful.

    */

    function finishBurning() public onlyOwner canBurn returns(bool finished) {

        burningFinished = true;



        emit LogBurnFinished();



        return true;

    }



    /**

    * @dev Change the pricing plan of service fee to be paid in KTune tokens.

    * @param _pricingPlan The pricing plan of KTune token to be paid, zero means flat subscription.

    */

    function setPricingPlan(address _pricingPlan) public onlyServiceProvider {

        require(_pricingPlan != 0, "_pricingPlan is 0");

        require(_pricingPlan != address(pricingPlan), "_pricingPlan == pricingPlan");



        pricingPlan = KTunePricingPlan(_pricingPlan);



        emit LogPricingPlanChanged(msg.sender, _pricingPlan);

    }

}



contract BurnableERC20 is ERC20 {

    function burn(uint256 amount) public returns (bool burned);

}



/**

* @dev The KTuneTokenBurner contract has the responsibility to burn the configured fraction of received

* ERC20-compliant tokens and distribute the remainder to the configured wallet.

*/

contract KTuneTokenBurner is Pausable {

    using SafeMath for uint256;



    event LogKTuneTokenBurnerCreated(address indexed caller, address indexed wallet);

    event LogBurningPercentageChanged(address indexed caller, uint256 indexed burningPercentage);



    // The wallet receiving the unburnt tokens.

    address public wallet;



    // The percentage of tokens to burn after being received (range [0, 100])

    uint256 public burningPercentage;



    // The cumulative amount of burnt tokens.

    uint256 public burnedTokens;



    // The cumulative amount of tokens transferred back to the wallet.

    uint256 public transferredTokens;



    /**

    * @dev Create a new KTuneTokenBurner with predefined burning fraction.

    * @param _wallet The wallet receiving the unburnt tokens.

    */

    constructor(address _wallet) public {

        require(_wallet != address(0), "_wallet is zero");

        

        wallet = _wallet;

        burningPercentage = 100;



        emit LogKTuneTokenBurnerCreated(msg.sender, _wallet);

    }



    /**

    * @dev Change the percentage of tokens to burn after being received.

    * @param _burningPercentage The percentage of tokens to be burnt.

    */

    function setBurningPercentage(uint256 _burningPercentage) public onlyOwner {

        require(0 <= _burningPercentage && _burningPercentage <= 100, "_burningPercentage not in [0, 100]");

        require(_burningPercentage != burningPercentage, "_burningPercentage equal to current one");

        

        burningPercentage = _burningPercentage;



        emit LogBurningPercentageChanged(msg.sender, _burningPercentage);

    }



    /**

    * @dev Called after burnable tokens has been transferred for burning.

    * @param _token THe extended ERC20 interface supported by the sent tokens.

    * @param _amount The amount of burnable tokens just arrived ready for burning.

    */

    function tokenReceived(address _token, uint256 _amount) public whenNotPaused {

        require(_token != address(0), "_token is zero");

        require(_amount > 0, "_amount is zero");



        uint256 amountToBurn = _amount.mul(burningPercentage).div(100);

        if (amountToBurn > 0) {

            assert(BurnableERC20(_token).burn(amountToBurn));

            

            burnedTokens = burnedTokens.add(amountToBurn);

        }



        uint256 amountToTransfer = _amount.sub(amountToBurn);

        if (amountToTransfer > 0) {

            assert(BurnableERC20(_token).transfer(wallet, amountToTransfer));



            transferredTokens = transferredTokens.add(amountToTransfer);

        }

    }

}



/**

* @dev The KTuneCustomERC20Token contract is a custom ERC20-compliant token available in the Noku Service Platform (NSP).

* The KTune customer is able to choose the token name, symbol, decimals, initial supply and to administer its lifecycle

* by minting or burning tokens in order to increase or decrease the token supply.

*/

contract KTuneCustomERC20 is KTuneCustomToken, DetailedERC20, MintableToken, BurnableToken {

    using SafeMath for uint256;



    event LogKTuneCustomERC20Created(

        address indexed caller,

        string indexed name,

        string indexed symbol,

        uint8 decimals,

        uint256 transferableFromBlock,

        uint256 lockEndBlock,

        address pricingPlan,

        address serviceProvider

    );

    event LogMintingFeeEnabledChanged(address indexed caller, bool indexed mintingFeeEnabled);

    event LogInformationChanged(address indexed caller, string name, string symbol);

    event LogTransferFeePaymentFinished(address indexed caller);

    event LogTransferFeePercentageChanged(address indexed caller, uint256 indexed transferFeePercentage);



    // Flag indicating if minting fees are enabled or disabled

    bool public mintingFeeEnabled;



    // Block number from which tokens are initially transferable

    uint256 public transferableFromBlock;



    // Block number from which initial lock ends

    uint256 public lockEndBlock;



    // The initially locked balances by address

    mapping (address => uint256) public initiallyLockedBalanceOf;



    // The fee percentage for Custom Token transfer or zero if transfer is free of charge

    uint256 public transferFeePercentage;



    // Flag indicating if fee payment in Custom Token transfer has been permanently finished or not. 

    bool public transferFeePaymentFinished;



    bytes32 public constant BURN_SERVICE_NAME = "KTuneCustomERC20.burn";

    bytes32 public constant MINT_SERVICE_NAME = "KTuneCustomERC20.mint";



    modifier canTransfer(address _from, uint _value) {

        require(block.number >= transferableFromBlock, "token not transferable");



        if (block.number < lockEndBlock) {

            uint256 locked = lockedBalanceOf(_from);

            if (locked > 0) {

                uint256 newBalance = balanceOf(_from).sub(_value);

                require(newBalance >= locked, "_value exceeds locked amount");

            }

        }

        _;

    }



    constructor(

        string _name,

        string _symbol,

        uint8 _decimals,

        uint256 _transferableFromBlock,

        uint256 _lockEndBlock,

        address _pricingPlan,

        address _serviceProvider

    )

    KTuneCustomToken(_pricingPlan, _serviceProvider)

    DetailedERC20(_name, _symbol, _decimals) public

    {

        require(bytes(_name).length > 0, "_name is empty");

        require(bytes(_symbol).length > 0, "_symbol is empty");

        require(_lockEndBlock >= _transferableFromBlock, "_lockEndBlock lower than _transferableFromBlock");



        transferableFromBlock = _transferableFromBlock;

        lockEndBlock = _lockEndBlock;

        mintingFeeEnabled = true;



        emit LogKTuneCustomERC20Created(

            msg.sender,

            _name,

            _symbol,

            _decimals,

            _transferableFromBlock,

            _lockEndBlock,

            _pricingPlan,

            _serviceProvider

        );

    }



    function setMintingFeeEnabled(bool _mintingFeeEnabled) public onlyOwner returns(bool successful) {

        require(_mintingFeeEnabled != mintingFeeEnabled, "_mintingFeeEnabled == mintingFeeEnabled");



        mintingFeeEnabled = _mintingFeeEnabled;



        emit LogMintingFeeEnabledChanged(msg.sender, _mintingFeeEnabled);



        return true;

    }



    /**

    * @dev Change the Custom Token detailed information after creation.

    * @param _name The name to assign to the Custom Token.

    * @param _symbol The symbol to assign to the Custom Token.

    */

    function setInformation(string _name, string _symbol) public onlyOwner returns(bool successful) {

        require(bytes(_name).length > 0, "_name is empty");

        require(bytes(_symbol).length > 0, "_symbol is empty");



        name = _name;

        symbol = _symbol;



        emit LogInformationChanged(msg.sender, _name, _symbol);



        return true;

    }



    /**

    * @dev Stop trasfer fee payment for tokens.

    * @return true if the operation was successful.

    */

    function finishTransferFeePayment() public onlyOwner returns(bool finished) {

        require(!transferFeePaymentFinished, "transfer fee finished");



        transferFeePaymentFinished = true;



        emit LogTransferFeePaymentFinished(msg.sender);



        return true;

    }



    /**

    * @dev Change the transfer fee percentage to be paid in Custom tokens.

    * @param _transferFeePercentage The fee percentage to be paid for transfer in range [0, 100].

    */

    function setTransferFeePercentage(uint256 _transferFeePercentage) public onlyOwner {

        require(0 <= _transferFeePercentage && _transferFeePercentage <= 100, "_transferFeePercentage not in [0, 100]");

        require(_transferFeePercentage != transferFeePercentage, "_transferFeePercentage equal to current value");



        transferFeePercentage = _transferFeePercentage;



        emit LogTransferFeePercentageChanged(msg.sender, _transferFeePercentage);

    }



    function lockedBalanceOf(address _to) public constant returns(uint256 locked) {

        uint256 initiallyLocked = initiallyLockedBalanceOf[_to];

        if (block.number >= lockEndBlock) return 0;

        else if (block.number <= transferableFromBlock) return initiallyLocked;



        uint256 releaseForBlock = initiallyLocked.div(lockEndBlock.sub(transferableFromBlock));

        uint256 released = block.number.sub(transferableFromBlock).mul(releaseForBlock);

        return initiallyLocked.sub(released);

    }



    /**

    * @dev Get the fee to be paid for the transfer of KTune tokens.

    * @param _value The amount of KTune tokens to be transferred.

    */

    function transferFee(uint256 _value) public view returns(uint256 usageFee) {

        return _value.mul(transferFeePercentage).div(100);

    }



    /**

    * @dev Check if token transfer is free of any charge or not.

    * @return true if transfer is free of any charge.

    */

    function freeTransfer() public view returns (bool isTransferFree) {

        return transferFeePaymentFinished || transferFeePercentage == 0;

    }



    /**

    * @dev Override #transfer for optionally paying fee to Custom token owner.

    */

    function transfer(address _to, uint256 _value) canTransfer(msg.sender, _value) public returns(bool transferred) {

        if (freeTransfer()) {

            return super.transfer(_to, _value);

        }

        else {

            uint256 usageFee = transferFee(_value);

            uint256 netValue = _value.sub(usageFee);



            bool feeTransferred = super.transfer(owner, usageFee);

            bool netValueTransferred = super.transfer(_to, netValue);



            return feeTransferred && netValueTransferred;

        }

    }



    /**

    * @dev Override #transferFrom for optionally paying fee to Custom token owner.

    */

    function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from, _value) public returns(bool transferred) {

        if (freeTransfer()) {

            return super.transferFrom(_from, _to, _value);

        }

        else {

            uint256 usageFee = transferFee(_value);

            uint256 netValue = _value.sub(usageFee);



            bool feeTransferred = super.transferFrom(_from, owner, usageFee);

            bool netValueTransferred = super.transferFrom(_from, _to, netValue);



            return feeTransferred && netValueTransferred;

        }

    }



    /**

    * @dev Burn a specific amount of tokens, paying the service fee.

    * @param _amount The amount of token to be burned.

    */

    function burn(uint256 _amount) public canBurn {

        require(_amount > 0, "_amount is zero");



        super.burn(_amount);



        require(pricingPlan.payFee(BURN_SERVICE_NAME, _amount, msg.sender), "burn fee failed");

    }



    /**

    * @dev Mint a specific amount of tokens, paying the service fee.

    * @param _to The address that will receive the minted tokens.

    * @param _amount The amount of tokens to mint.

    * @return A boolean that indicates if the operation was successful.

    */

    function mint(address _to, uint256 _amount) public onlyOwner canMint returns(bool minted) {

        require(_to != 0, "_to is zero");

        require(_amount > 0, "_amount is zero");



        super.mint(_to, _amount);



        if (mintingFeeEnabled) {

            require(pricingPlan.payFee(MINT_SERVICE_NAME, _amount, msg.sender), "mint fee failed");

        }



        return true;

    }



    /**

    * @dev Mint new locked tokens, which will unlock progressively.

    * @param _to The address that will receieve the minted locked tokens.

    * @param _amount The amount of tokens to mint.

    * @return A boolean that indicates if the operation was successful.

    */

    function mintLocked(address _to, uint256 _amount) public onlyOwner canMint returns(bool minted) {

        initiallyLockedBalanceOf[_to] = initiallyLockedBalanceOf[_to].add(_amount);

        

        return mint(_to, _amount);

    }



}



/**

 * @title CappedCrowdsaleKYC

 * @dev Extension of Crowsdale with a max amount of funds raised

 */

contract TokenCappedCrowdsaleKYC is CrowdsaleKYC {

    using SafeMath for uint256;



    // The maximum token cap, should be initialized in derived contract

    uint256 public tokenCap;



    // KTune ICO have phase 1,2,3. phase1 == platinum, phase2 == golden, phase3 == silver

    // Writen by Eli

    uint256 internal supplyPlatinum;

    uint256 internal supplyGolden;

    uint256 internal supplySilver;



    // Overriding Crowdsale#hasEnded to add tokenCap logic

    // @return true if crowdsale event has ended

    function hasEnded() public constant returns (bool) {

        bool capReached = soldTokens >= tokenCap;

        return super.hasEnded() || capReached;

    }



    // Overriding Crowdsale#isValidPurchase to add extra cap logic

    // @return true if investors can buy at the moment

    function isValidPurchase(address beneficiary) internal constant returns (bool isValid) {

        uint256 tokenAmount = calculateTokens(msg.value);

        bool withinCap = soldTokens.add(tokenAmount) <= tokenCap;

        return withinCap && super.isValidPurchase(beneficiary);

    }

    

    function checkSoldout() internal returns (bool isSoldout) {

        return soldTokens >= tokenCap;

    }

}



/**

 * @title KTuneCustomCrowdsaleKYC

 * @dev Extension of TokenCappedCrowdsaleKYC using values specific for KTune Custom ICO crowdsale

 */

contract KTuneCustomCrowdsaleKYC is TokenCappedCrowdsaleKYC {

    using AddressUtils for address;

    using SafeMath for uint256;



    event LogKTuneCustomCrowdsaleCreated(

        address sender,

        uint256 indexed startBlock,

        uint256 indexed endBlock,

        address indexed wallet

    );

    event LogThreePowerAgesChanged(

        address indexed sender,

        uint256 indexed platinumAgeEndBlock,

        uint256 indexed goldenAgeEndBlock,

        uint256 silverAgeEndBlock,

        uint256 platinumAgeRate,

        uint256 goldenAgeRate,

        uint256 silverAgeRate

    );



    event LogForceThreePowerAgesChanged(

        address indexed sender,

        uint256 indexed platinumAgeEndBlock,

        uint256 indexed goldenAgeEndBlock,

        uint256 silverAgeEndBlock

    );

    

    event LogStartNextPhase(

        address sender,

        uint256 indexed startBlock,

        uint256 indexed endBlock,

        string  indexed phaseName

    );

    

    event LogInvokeNextPhase(

        address sender,

        uint256 indexed invokeBlock

    );



    // The end block of the 'platinum' age interval

    uint256 public platinumAgeEndBlock;



    // The end block of the 'golden' age interval

    uint256 public goldenAgeEndBlock;



    // The end block of the 'silver' age interval

    uint256 public silverAgeEndBlock;



    // The conversion rate of the 'platinum' age

    uint256 public platinumAgeRate;



    // The conversion rate of the 'golden' age

    uint256 public goldenAgeRate;



    // The conversion rate of the 'silver' age

    uint256 public silverAgeRate;



    // The wallet address or contract

    address public wallet;



    // The phase level (0, 1, 2, 3). Writen by Eli

    uint8 public phaseLevel = 0;



    /**

     * modify constructor.

     * remove : totalSupplyCap, startBlock, endBloc

     * add : platinumCap, goldenCap, silverCap

     * Writen by Eli

     */

    constructor(

        uint256 _minDeposit,

        uint256 _maxWhitelistLength,

        uint256 _whitelistThreshold,

        address _token,

        address _wallet,

        address[] _kycSigner,

      uint256 _platinumCap,

      uint256 _goldenCap,

      uint256 _silverCap,

      uint256 _platinumRate,

      uint256 _goldenRate,

      uint256 _silverRate

    )

    CrowdsaleKYC(

        block.number + 60000,

        block.number + 120000,

        _silverRate,

        _minDeposit,

        _maxWhitelistLength,

        _whitelistThreshold,

        _kycSigner

    )

    public {

        require(_token.isContract(), "_token is not contract");

        require(_platinumCap > 0, "_platinumCap is zero");

        require(_goldenCap > 0, "_goldenCap is zero");

        require(_silverCap > 0, "_silverCap is zero");

        require(_platinumRate > 0, "_platinumRate is zero");

        require(_goldenRate > 0, "_goldenRate is zero");

        require(_silverRate > 0, "_silverRate is zero");



        platinumAgeRate = _platinumRate;

        goldenAgeRate = _goldenRate;

        silverAgeRate = _silverRate;



        token = KTuneCustomERC20(_token);

        wallet = _wallet;



        // Assume predefined token supply has been minted and calculate the maximum number of tokens that can be sold

        // tokenCap = _tokenMaximumSupply.sub(token.totalSupply());

        // Writen by Eli

  supplyPlatinum = _platinumCap;

  supplyGolden   = _goldenCap;

  supplySilver   = _silverCap;



        emit LogKTuneCustomCrowdsaleCreated(msg.sender, startBlock, endBlock, _wallet);

    }



    /**

     * When call function startNextPhase, startBlock, endBlock is set automatic.

     * however set all block value.

     * So, remove require about startBlock, endBlock

     * And silverAgeRate will be used as a base rate

     * Writen by Eli

     */

    function setThreePowerAges(

        uint256 _startBlock,

        uint256 _platinumAgeEndBlock,

        uint256 _goldenAgeEndBlock,

        uint256 _silverAgeEndBlock,

        uint256 _platinumAgeRate,

        uint256 _goldenAgeRate

    )

    external onlyOwner beforeStart

    {

        require(_startBlock < _platinumAgeEndBlock, "_platinumAgeEndBlock not greater than start block");

        require(_platinumAgeEndBlock < _goldenAgeEndBlock, "_platinumAgeEndBlock not lower than _goldenAgeEndBlock");

        require(_goldenAgeEndBlock < _silverAgeEndBlock, "_silverAgeEndBlock not greater than _goldenAgeEndBlock");

        // require(_silverAgeEndBlock <= endBlock, "_silverAgeEndBlock greater than end block");

        require(_platinumAgeRate > _goldenAgeRate, "_platinumAgeRate not greater than _goldenAgeRate");

        require(_goldenAgeRate > rate, "_goldenAgeRate not greater than _silverAgeRate");



        // Write by Eli

        startBlock = _startBlock;

        platinumAgeEndBlock = _platinumAgeEndBlock;

        goldenAgeEndBlock = _goldenAgeEndBlock;

        endBlock = silverAgeEndBlock = _silverAgeEndBlock;



        platinumAgeRate = _platinumAgeRate;

        goldenAgeRate = _goldenAgeRate;

        silverAgeRate = rate;



        emit LogThreePowerAgesChanged(

            msg.sender,

            platinumAgeEndBlock,

            goldenAgeEndBlock,

            silverAgeEndBlock,

            platinumAgeRate,

            goldenAgeRate,

            silverAgeRate

        );

    }

    

    function forceThreePowerAgesBlock(

        uint256 _platinumAgeEndBlock,

        uint256 _goldenAgeEndBlock,

        uint256 _silverAgeEndBlock

    )

    external onlyOwner

    {

        require(_platinumAgeEndBlock < _goldenAgeEndBlock, "_platinumAgeEndBlock not lower than _goldenAgeEndBlock");

        require(_goldenAgeEndBlock < _silverAgeEndBlock, "_silverAgeEndBlock not greater than _goldenAgeEndBlock");



        platinumAgeEndBlock = _platinumAgeEndBlock;

        goldenAgeEndBlock = _goldenAgeEndBlock;

        endBlock = silverAgeEndBlock = _silverAgeEndBlock;



        emit LogForceThreePowerAgesChanged(

            msg.sender,

            platinumAgeEndBlock,

            goldenAgeEndBlock,

            silverAgeEndBlock

        );

    }

    

    /**

     * Remove Two power and One Power function.

     * Writen by Eli

     */



    function grantTokenOwnership(address _client) external onlyOwner returns(bool granted) {

        require(!_client.isContract(), "_client is contract");

        require(hasEnded(), "crowdsale not ended yet");



        // Transfer KTuneCustomERC20 ownership back to the client

        token.transferOwnership(_client);



        return true;

    }



    // Overriding Crowdsale#calculateTokens to apply age discounts to token calculus.

    function calculateTokens(uint256 amount) internal view returns(uint256 tokenAmount) {

        uint256 conversionRate = block.number <= platinumAgeEndBlock ? platinumAgeRate :

            block.number <= goldenAgeEndBlock ? goldenAgeRate :

            block.number <= silverAgeEndBlock ? silverAgeRate :

            rate;



        return amount.mul(conversionRate);

    }



    /**

     * @dev Overriding Crowdsale#distributeTokens to apply age rules to token distributions.

     * remove flow, When before platinumAgeEndBlock, mintLocked. Writen by Eli

     *

    function distributeTokens(address beneficiary, uint256 tokenAmount) internal {

        

        if (block.number <= platinumAgeEndBlock) {

            KTuneCustomERC20(token).mintLocked(beneficiary, tokenAmount);

        }

        else {

            super.distributeTokens(beneficiary, tokenAmount);

        }

    }

    */



    /**

     * @dev Overriding Crowdsale#forwardFunds to split net/fee payment.

     */

    function forwardFunds(uint256 amount) internal {

        wallet.transfer(amount);

    }



    /**

     * When sold out or expired on each Phase, pause automatic. And controller or owner can resume next phase.

     * Function : setNextPhaseBlock, startNextPhase(internal), invokeNextPhase(public)

     * Writen by Eli

     */

    function setNextPhaseBlock() internal {

         if (phaseLevel == 1) {

              platinumAgeEndBlock = block.number;

              // End day of Phase 2 after approximately 10days

              goldenAgeEndBlock = block.number+66000;

         } else if (phaseLevel == 2) {

              goldenAgeEndBlock = block.number;

         }

         /* When phase 3 if sold out, all finished */

    }



    function startNextPhase(uint256 _startBlock) internal {

      if (_startBlock >= goldenAgeEndBlock) {

          // enter Phase 3

          require(phaseLevel == 2, "Not allow Phase 3");

          // set Start Block at now block

          startBlock = _startBlock;

          // initialize sold token zero.

          soldTokens = 0;

          // set End Block at silver end;

          endBlock = silverAgeEndBlock;

          tokenCap = supplySilver;

          phaseLevel = 3;

    emit LogStartNextPhase(msg.sender, startBlock, endBlock, "Phase 3");

      }

      else if (_startBlock >= platinumAgeEndBlock) {

          // enter Phase 2

          require(phaseLevel == 1, "Not allow Phase 2");

          // set Start Block at now block

          startBlock = _startBlock;

          // initialize sold token zero.

          soldTokens = 0;

          // set End Block at golden end;

          endBlock = goldenAgeEndBlock;

          tokenCap = supplyGolden;

          phaseLevel = 2;

    emit LogStartNextPhase(msg.sender, startBlock, endBlock, "Phase 2");

      }

      else {

          // start Phase 1

          require(phaseLevel == 0, "Not allow Phase 1");

          // set Start Block at now block

          startBlock = _startBlock;

          // initialize sold token zero.

          soldTokens = 0;

          // set End Block at platinum end;

          endBlock = platinumAgeEndBlock;

          tokenCap = supplyPlatinum;

          phaseLevel = 1;

    emit LogStartNextPhase(msg.sender, startBlock, endBlock, "Phase 1");

      }

      if (paused) {

        paused = false;

        emit Unpause();

      }

    }



    function invokeNextPhase() onlyController public {

      require(block.number < silverAgeEndBlock, "No more phase in This token sale");

      startNextPhase(block.number);

      emit LogInvokeNextPhase(msg.sender, block.number);

    }

}

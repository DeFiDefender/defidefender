
// File: contracts/Portal.sol

pragma solidity 0.5.8;

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

interface UniswapFactoryInterface {
    // Create Exchange
    function createExchange(address token) external returns (address exchange);
    // Get Exchange and Token Info
    function getExchange(address token) external view returns (address exchange);
    function getToken(address exchange) external view returns (address token);
    function getTokenWithId(uint256 tokenId) external view returns (address token);
    // Never use
    function initializeFactory(address template) external;
}


interface UniswapExchangeInterface {
    // Address of ERC20 token sold on this exchange
    function tokenAddress() external view returns (address token);
    // Address of Uniswap Factory
    function factoryAddress() external view returns (address factory);
    // Provide Liquidity
    function addLiquidity(uint256 min_liquidity, uint256 max_tokens, uint256 deadline) external payable returns (uint256);
    function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens, uint256 deadline) external returns (uint256, uint256);
    // Get Prices
    function getEthToTokenInputPrice(uint256 eth_sold) external view returns (uint256 tokens_bought);
    function getEthToTokenOutputPrice(uint256 tokens_bought) external view returns (uint256 eth_sold);
    function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256 eth_bought);
    function getTokenToEthOutputPrice(uint256 eth_bought) external view returns (uint256 tokens_sold);
    // Trade ETH to ERC20
    function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256  tokens_bought);
    function ethToTokenTransferInput(uint256 min_tokens, uint256 deadline, address recipient) external payable returns (uint256  tokens_bought);
    function ethToTokenSwapOutput(uint256 tokens_bought, uint256 deadline) external payable returns (uint256  eth_sold);
    function ethToTokenTransferOutput(uint256 tokens_bought, uint256 deadline, address recipient) external payable returns (uint256  eth_sold);
    // Trade ERC20 to ETH
    function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256  eth_bought);
    function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline, address recipient) external returns (uint256  eth_bought);
    function tokenToEthSwapOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline) external returns (uint256  tokens_sold);
    function tokenToEthTransferOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline, address recipient) external returns (uint256  tokens_sold);
    // Trade ERC20 to ERC20
    function tokenToTokenSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address token_addr) external returns (uint256  tokens_bought);
    function tokenToTokenTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_bought);
    function tokenToTokenSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address token_addr) external returns (uint256  tokens_sold);
    function tokenToTokenTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_sold);
    // Trade ERC20 to Custom Pool
    function tokenToExchangeSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address exchange_addr) external returns (uint256  tokens_bought);
    function tokenToExchangeTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_bought);
    function tokenToExchangeSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address exchange_addr) external returns (uint256  tokens_sold);
    function tokenToExchangeTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_sold);
    // ERC20 comaptibility for liquidity tokens

    function transfer(address _to, uint256 _value) external returns (bool);
    function transferFrom(address _from, address _to, uint256 value) external returns (bool);
    function approve(address _spender, uint256 _value) external returns (bool);
    function allowance(address _owner, address _spender) external view returns (uint256);
    function balanceOf(address _owner) external view returns (uint256);
    function totalSupply() external view returns (uint256);
    // Never use
    function setup(address token_addr) external;
}

interface Token {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (string memory);


    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract Ownable {
    address public _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal  {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract Pausable is Ownable {
    /**
     * @dev Emitted when the pause is triggered by a pauser (`account`).
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by a pauser (`account`).
     */
    event Unpaused(address account);

    bool _paused;

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view returns (bool) {
        return _paused;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     */
    modifier whenNotPaused() {
        require(!_paused, "Pausable: paused");
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     */
    modifier whenPaused() {
        require(_paused, "Pausable: not paused");
        _;
    }

    function pause() public onlyOwner{
        _pause();
    }

    function unpause() public onlyOwner{
        _unpause();
    }


    /**
     * @dev Called by a pauser to pause, triggers stopped state.
     */
    function _pause() internal whenNotPaused {
        _paused = true;
        emit Paused(msg.sender);
    }

    /**
     * @dev Called by a pauser to unpause, returns to normal state.
     */
    function _unpause() internal whenPaused {
        _paused = false;
        emit Unpaused(msg.sender);
    }
}

contract Initializable {

  /**
   * @dev Indicates that the contract has been initialized.
   */
  bool private initialized;

  /**
   * @dev Indicates that the contract is in the process of being initialized.
   */
  bool private initializing;

  /**
   * @dev Modifier to use in the initializer function of a contract.
   */
  modifier initializer() {
    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");

    bool isTopLevelCall = !initializing;
    if (isTopLevelCall) {
      initializing = true;
      initialized = true;
    }

    _;

    if (isTopLevelCall) {
      initializing = false;
    }
  }

  /// @dev Returns true if and only if the function is running in the constructor
  function isConstructor() private view returns (bool) {
    // extcodesize checks the size of the code stored in an address, and
    // address returns the current address. Since the code is still not
    // deployed when running a constructor, any checks on its code size will
    // yield zero, making it an effective way to detect if a contract is
    // under construction or not.
    address self = address(this);
    uint256 cs;
    assembly { cs := extcodesize(self) }
    return cs == 0;
  }

  // Reserved storage space to allow for layout changes in the future.
  uint256[50] private ______gap;
}


contract Portal is  Pausable, Initializable {
    using SafeMath for uint256;
    using SafeMath for uint32;

    uint256 interestRate ;
    uint256 MAX_UINT;
    uint256 ONE_DAY ;
    address public xioExchangeAddress ;
    address public xioContractAddress ;
    address public uniswapFactoryAddress ;
    uint256 portalId;

    mapping (address=>StakerData[]) public stakerData;
    mapping (uint256=>PortalData) public portalData;

    //for testing
    uint256 ONE_MINUTE;
    mapping (address=>bool) internal whiteListed;

    //stake restriction parameters
    uint256 stakeDays;
    uint256 xioStakeQuantity;

    struct StakerData {
        uint256 portalId;
        address publicKey;
        uint256 stakeQuantity;
        uint256 stakeDurationTimestamp;
        uint256 stakeInitiationTimestamp;
        string outputTokenSymbol;
        uint256 boughAmount;
    }

    struct PortalData {
        uint256 portalId;
        address tokenAddress;
        address tokenExchangeAddress;
        string outputTokenSymbol;
        uint256 xioStaked;
    }

    function initialize() public initializer{
        _paused = false;
        _owner = msg.sender;
        interestRate = 684931506849315;
        MAX_UINT = 2**256 - 1;
        ONE_DAY = 24*60*60;
        xioExchangeAddress = 0x7B6E5278a14d5318571d65aceD036d09c998C707;
        xioContractAddress = 0x0f7F961648aE6Db43C75663aC7E5414Eb79b5704;
        uniswapFactoryAddress = 0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95;
        portalId = 0;
        ONE_MINUTE = 60;
    }

    event DataEntered(address staker, uint256  portalId, uint256 quantity); // When data is entered into the mapping
    event Tranferred(address staker, uint256  portalId, uint256 quantity, string symbol); // When bought tokens are transferred to staker
    event Bought(address staker, uint256  portalId, uint256 _tokensBought, string symbol); // When tokens are bought
    event Transfer(address to, uint256 value); // When tokens are withdrawn


    /* @dev to get interest rate of the portal */
    function getInterestRate() public view returns(uint256){
        return interestRate;
    }

    /* @dev to get exchange rate of XIO to ETH
    *  @param _amount, xio amount
    */
    function getXIOtoETH(uint256 _amount) public view returns (uint256){
        return UniswapExchangeInterface(xioExchangeAddress).getTokenToEthInputPrice(_amount);
    }

    /* @dev to get exchange rate of ETH to ALT
    *  @param _amount, xio amount
    *  @param _outputTokenAddressExchange, exchange address of output token on uniswap
    */
    function getETHtoALT(uint256 _amount, address _outputTokenAddressExchange) public view returns (uint256){
        return UniswapExchangeInterface(_outputTokenAddressExchange).getEthToTokenInputPrice(_amount);
    }

    /* @dev to get array's lenght of staker data // for front end feasiblity
    *  @param _address, address of staker
    */
    function getArrayLengthOfStakerData(address _address) public view returns(uint256){
        return stakerData[_address].length;
    }

    /* @dev to get number of days in the stake condition
    */
    function getDays() public view returns(uint256) {
        return stakeDays; 
    }

    /* @dev to get number of xio quantity user can max stake
    */
    function getXIOStakeQuantity() public view returns(uint256) {
        return xioStakeQuantity;
    }


    /* @dev to check if given address is contract's or not
    *  @param _addr, public address
    */
    function isContract(address _addr) internal view returns (bool){
        uint32 size;
        assembly {
            size := extcodesize(_addr)
        }
        return (size > 0);
    }

    /* @dev to check portal if it already exists or not
    *  @param _tokenAddress, address of output token
    */
    function checkPortalExists(address _tokenAddress) internal view returns (bool){
        bool exists;
        for(uint256 i=0; ;i++){
            if(portalData[i].tokenAddress == address(0)){
                exists = false;
                break;
            } else if(portalData[i].tokenAddress == _tokenAddress){
                exists = true;
                break;
            }
        }
        return exists;
    }


    /* @dev stake function which calls uniswaps exchange to buy output tokens and send them to the user.
    *  @param _quantity , xio token quanity user has staked (in wei)
    *  @param _xioQuantity, xio interest generated upon the days (in wei)
    *  @param _tokensBought, how much tokens are bought from the uniswaps exchange (in wei)
    *  @param _portalId, portal id of the exchange.
    *  @param _symbol, bought token symbol
    *  @param _outputTokenAddress, bought token ERC20 address
    *  @param _days, how much days he has staked (in days)
    */
    function stakeXIO( address _outputTokenAddress, uint256 _days, uint256 _xioQuantity, uint256 _tokensBought, uint256 _portalId) public whenNotPaused returns (bool) {

        require(_days<=stakeDays, "Invalid Days");  // To check days
        require(_xioQuantity <= xioStakeQuantity, "Invalid XIO quantity"); // To verify XIO quantity
        require(_outputTokenAddress != address(0),"0 address not allowed"); // To verify output token address
        require(isContract(_outputTokenAddress) != false, "Not a contract address"); // To verify address is contract or not
        require(portalData[_portalId].tokenAddress != address(0), "Portal does not exists"); // To verify portal info
        require(whiteListed[msg.sender] == true, "Not whitelist address"); //To verify whitelisters
        require(portalData[_portalId].tokenAddress == _outputTokenAddress, "Wrong portal"); //To check correct portal

        // stakerData[msg.sender].push(StakerData(_portalId, msg.sender, _xioQuantity, _days.mul(ONE_MINUTE), block.timestamp, portalData[_portalId].outputTokenSymbol));

        emit DataEntered(msg.sender,_portalId,_xioQuantity);

        portalData[_portalId].xioStaked = portalData[_portalId].xioStaked.add(_xioQuantity)  ;

        Token(xioContractAddress).transferFrom(msg.sender, address(this),_xioQuantity);

        uint256 soldXIO = (_xioQuantity.mul(interestRate).mul(_days)).div(1000000000000000000);

        uint256 bought = UniswapExchangeInterface(xioExchangeAddress).tokenToTokenSwapInput(soldXIO,_tokensBought,1,1839591241,_outputTokenAddress);

        stakerData[msg.sender].push(StakerData(_portalId, msg.sender, _xioQuantity, _days.mul(ONE_DAY), block.timestamp, portalData[_portalId].outputTokenSymbol, bought));

        if(bought > 0){
            emit Bought(msg.sender,_portalId,bought,portalData[_portalId].outputTokenSymbol);
            Token(portalData[_portalId].tokenAddress).transfer(msg.sender,bought);
            emit Tranferred(msg.sender,_portalId,bought,portalData[_portalId].outputTokenSymbol);
            return true;
        }
        return false;
    }

    /* @dev withdrwal function by which user can withdraw their staked xio
    *  @param _amount , xio token quanity user has staked (in wei)
    */
    function withdrawXIO(uint256 _amount) public whenNotPaused {
        require(_amount>0, "Amount should be greater than 0");
        uint256 withdrawAmount = 0;
        StakerData[] storage stakerArray= stakerData[msg.sender];
        for(uint256 i=0; i<stakerArray.length;i++){
            if((stakerArray[i].stakeInitiationTimestamp.add(stakerArray[i].stakeDurationTimestamp)  <= block.timestamp) && (stakerArray[i].publicKey != address(0))){
                if(_amount > stakerArray[i].stakeQuantity){
                    stakerArray[i].publicKey = address(0);
                    _amount = _amount.sub(stakerArray[i].stakeQuantity);
                    withdrawAmount = withdrawAmount.add(stakerArray[i].stakeQuantity);
                    portalData[stakerArray[i].portalId].xioStaked = portalData[stakerArray[i].portalId].xioStaked.sub(stakerArray[i].stakeQuantity);
                    stakerArray[i].stakeQuantity = 0;
                }
                else if(_amount == stakerArray[i].stakeQuantity){
                    stakerArray[i].publicKey = address(0);
                    withdrawAmount = withdrawAmount.add(stakerArray[i].stakeQuantity);
                    stakerArray[i].stakeQuantity = 0;
                    portalData[stakerArray[i].portalId].xioStaked = portalData[stakerArray[i].portalId].xioStaked.sub(_amount);
                    break;
                }else if(_amount < stakerArray[i].stakeQuantity){
                    stakerArray[i].stakeQuantity = stakerArray[i].stakeQuantity.sub(_amount);
                    withdrawAmount = withdrawAmount.add(_amount);
                    portalData[stakerArray[i].portalId].xioStaked = portalData[stakerArray[i].portalId].xioStaked.sub( _amount);
                    break;
                }

            }
        }
        require(withdrawAmount !=0, "Not Transferred");
        Token(xioContractAddress).transfer(msg.sender,withdrawAmount);
        emit Transfer(msg.sender,withdrawAmount);
    }

    /* @dev incase of emergency owner can withdraw all the funds */
    function withdrawTokens() public onlyOwner whenNotPaused{
        uint256 balance = Token(xioContractAddress).balanceOf(address(this));
        Token(xioContractAddress).transfer(_owner,balance);
    }


    /* @dev to add portal into the contract
    *  @param _tokenAddress, address of output token
    */
    function addPortal(address _tokenAddress) public onlyOwner whenNotPaused returns(bool) {
        require(_tokenAddress != address(0), "Zero address not allowed");
        require(checkPortalExists(_tokenAddress) == false , "Portal already exists");
        address exchangeAddress = UniswapFactoryInterface(uniswapFactoryAddress).getExchange(_tokenAddress);
        require(exchangeAddress != address(0));
        string memory symbol = Token(_tokenAddress).symbol();
        portalData[portalId] = PortalData(portalId, _tokenAddress, exchangeAddress, symbol, 0);
        portalId = portalId.add(1);
        return true;
    }

    /* @dev to delete portal into the contract
    *  @param _portalId, portal Id of portal
    */
    function removePortal(uint256 _portalId) public onlyOwner whenNotPaused returns(bool) {
        require(portalData[_portalId].tokenAddress != address(0),"Portal does not exist");
        uint256 xioAmount = portalData[_portalId].xioStaked;
        portalData[_portalId] = PortalData(_portalId, address(0), address(0), "NONE", xioAmount);
        return true;
    }

    /* @dev to set interest rate. Can only be called by owner
    *  @param _rate, interest rate (in wei)
    */
    function setInterestRate(uint256 _rate) public onlyOwner whenNotPaused returns(bool) {
        require(_rate != 0, "Rate connot be zero");
        interestRate = _rate;
    }

    /* @dev to set days. Can only be called by owner
    *  @param _days, days in number
    */
    function setDays(uint256 _days) public onlyOwner whenNotPaused returns(bool) {
        require(_days != 0, "Rate connot be zero");
        stakeDays = _days;
    }

    /* @dev to set xio quantity. Can only be called by owner
    *  @param _quantity, xio quantity (in wei)
    */
    function setXIOStakeQuantity(uint256 _quantity) public onlyOwner whenNotPaused returns(bool) {
        require(_quantity > 0, "quantity connot be zero");
        xioStakeQuantity = _quantity;
    }

    /* @dev to allow XIO exchange max XIO tokens from the portal, can only be called by owner */
    function allowXIO() public onlyOwner whenNotPaused returns(bool) {
        return Token(xioContractAddress).approve(xioExchangeAddress, MAX_UINT);
    }

    /* @dev to add whitelist addresses // for front end feasiblity
    *  @param __staker, array of staker address
    */
    function addWhiteListAccount(address[] memory _staker) public onlyOwner whenNotPaused {
        for(uint8 i=0; i<_staker.length;i++){
            require(_staker[i] != address(0), "Zero address not allowed");
            whiteListed[_staker[i]]=true;
        }
    }

    /* @dev to update exchange address
    *  @param _exchangeAddress, xio exchange address
    */
    function setXIOExchangeAddress(address _exchangeAddress) public onlyOwner whenNotPaused {
        require(_exchangeAddress != address(0), "Zero address not allowed");
        xioExchangeAddress = _exchangeAddress;
    }

    /* @dev to update factory address
    *  @param _factoryAddress, factory address of uniswap
    */
    function setUniswapFactoryAddress(address _factoryAddress) public onlyOwner whenNotPaused {
        require(_factoryAddress != address(0), "Zero address not allowed");
        uniswapFactoryAddress = _factoryAddress;
    }

}

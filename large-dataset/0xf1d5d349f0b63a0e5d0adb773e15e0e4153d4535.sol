pragma solidity ^0.5.10;



/**

 * @dev Wrappers over Solidity's arithmetic operations with added overflow

 * checks.

 *

 * Arithmetic operations in Solidity wrap on overflow. This can easily result

 * in bugs, because programmers usually assume that an overflow raises an

 * error, which is the standard behavior in high level programming languages.

 * `SafeMath` restores this intuition by reverting the transaction when an

 * operation overflows.

 *

 * Using this library instead of the unchecked operations eliminates an entire

 * class of bugs, so it's recommended to use it always.

 */

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

        require(b <= a, "SafeMath: subtraction overflow");

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

        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522

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

        // Solidity only automatically asserts when dividing by 0

        require(b > 0, "SafeMath: division by zero");

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

        require(b != 0, "SafeMath: modulo by zero");

        return a % b;

    }

}



/**

 * @dev Collection of functions related to the address type,

 */

library Address {

    /**

     * @dev Returns true if `account` is a contract.

     *

     * This test is non-exhaustive, and there may be false-negatives: during the

     * execution of a contract's constructor, its address will be reported as

     * not containing a contract.

     *

     * > It is unsafe to assume that an address for which this function returns

     * false is an externally-owned account (EOA) and not a contract.

     */

    function isContract(address account) internal view returns (bool) {

        // This method relies in extcodesize, which returns 0 for contracts in

        // construction, since the code is only stored at the end of the

        // constructor execution.



        uint256 size;

        // solhint-disable-next-line no-inline-assembly

        assembly { size := extcodesize(account) }

        return size > 0;

    }

}



/**

 * @title ERC20 interface

 * @dev see https://github.com/ethereum/EIPs/issues/20

 */

contract ERC20 {

  uint256 public totalSupply;

  function balanceOf(address who) public view returns (uint256);

  function transfer(address to, uint256 value) public returns (bool);

  function allowance(address owner, address spender) public view returns (uint256);

  function transferFrom(address from, address to, uint256 value) public returns (bool);

  function approve(address spender, uint256 value) public returns (bool);

  event Approval(address indexed owner, address indexed spender, uint256 value);

  event Transfer(address indexed from, address indexed to, uint256 value);

}



/**

 * @title Ownable

 * @dev The Ownable contract has an owner address, and provides basic authorization control

 * functions, this simplifies the implementation of "user permissions".

 */

contract Ownable {

    address public owner;





    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);





    /**

     * @dev The Ownable constructor sets the original `owner` of the contract to the sender

     * account.

     */

    constructor() public {

        owner = msg.sender;

    }





    /**

     * @dev Throws if called by any account other than the owner.

     */

    modifier onlyOwner() {

        require(msg.sender == owner, "Not authorized operation");

        _;

    }





    /**

     * @dev Allows the current owner to transfer control of the contract to a newOwner.

     * @param newOwner The address to transfer ownership to.

     */

    function transferOwnership(address newOwner) public onlyOwner {

        require(newOwner != address(0), "Address shouldn't be zero");

        emit OwnershipTransferred(owner, newOwner);

        owner = newOwner;

    }



}



/**

 * @title Mintable token

 * @dev Simple ERC20 Token example, with mintable token creation

 * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120

 * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol

 */

contract MintableToken is ERC20, Ownable {

  using Address for address;

  using SafeMath for uint256;



  string public name;

  string public symbol;

  uint8 public decimals;

  uint256 public totalSupply;

  address public tokenOwner;

  address private crowdsale;



  mapping(address => uint256) balances;

  mapping(address => mapping(address => uint256)) internal allowed;



  event SetCrowdsale(address indexed _crowdsale);

  event Mint(address indexed to, uint256 amount);

  event MintFinished();

  event UnlockToken();

  event LockToken();

  event Burn();



  bool public mintingFinished = false;

  bool public locked = false;





  modifier canMint() {

    require(!mintingFinished);

    _;

  }



  modifier canTransfer() {

    require(!locked || msg.sender == owner);

    _;

  }



  modifier onlyCrowdsale() {

    require(msg.sender == crowdsale);

    _;

  }



  modifier onlyAuthorized() {

    require(msg.sender == owner || msg.sender == crowdsale);

    _;

  }



  constructor(string memory _name, string memory _symbol, uint8 _decimals) public {

    name = _name;

    symbol = _symbol;

    decimals = _decimals;

    totalSupply = 0;

    balances[msg.sender] = totalSupply;

    emit Transfer(address(0), msg.sender, totalSupply);

  }



  /**

   * @dev Function to mint tokens

   * @param _amount The amount of tokens to mint.

   * @return A boolean that indicates if the operation was successful.

   */

  function mint(address _to, uint256 _amount) public onlyAuthorized canMint returns (bool) {

    totalSupply = totalSupply.add(_amount);

    balances[_to] = balances[_to].add(_amount);

    emit Mint(_to, _amount);

    emit Transfer(address(0), _to, _amount);

    return true;

  }



  /**

   * @dev Function to stop minting new tokens.

   * @return True if the operation was successful.

   */

  function finishMinting() onlyOwner public canMint returns (bool) {

    mintingFinished = true;

    emit MintFinished();

    return true;

  }



  function burn(uint256 _value) public onlyAuthorized returns (bool) {

    totalSupply = totalSupply.sub(_value);

    balances[address(this)] = balances[address(this)].sub(_value);

    emit Burn();

    emit Transfer(address(this), address(0), _value);

    return true;

  }

  /**

  * @dev transfer token for a specified address

  * @param _to The address to transfer to.

  * @param _value The amount to be transferred.

  */



  function transfer(address _to, uint256 _value) public canTransfer returns (bool) {

    require(_to != address(0));

    require(_value <= balances[msg.sender]);



    // SafeMath.sub will throw if there is not enough balance.

    balances[msg.sender] = balances[msg.sender].sub(_value);

    balances[_to] = balances[_to].add(_value);

    emit Transfer(msg.sender, _to, _value);

    return true;

  }



  function transferFromContract(address _to, uint256 _value) public onlyOwner returns (bool) {

    require(_to != address(0));

    require(_value <= balances[address(this)]);



    balances[address(this)] = balances[address(this)].sub(_value);

    balances[_to] = balances[_to].add(_value);

    emit Transfer(address(this), _to, _value);

    return true;

  }



  /**

  * @dev Gets the balance of the specified address.

  * @param _owner The address to query the the balance of.

  * @return An uint256 representing the amount owned by the passed address.

  */

  function balanceOf(address _owner) public view returns (uint256 balance) {

    return balances[_owner];

  }



  /**

   * @dev Transfer tokens from one address to another

   * @param _from address The address which you want to send tokens from

   * @param _to address The address which you want to transfer to

   * @param _value uint256 the amount of tokens to be transferred

   */

  function transferFrom(address _from, address _to, uint256 _value) public canTransfer returns (bool) {

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



  function unlockToken() public onlyCrowdsale returns (bool) {

    locked = false;

    emit UnlockToken();

    return true;

  }



  function lockToken() public onlyCrowdsale returns (bool) {

    locked = true;

    emit LockToken();

    return true;

  }



  function setCrowdsale(address _crowdsale) public onlyOwner returns (bool) {

    require(_crowdsale.isContract());

    crowdsale = _crowdsale;



    emit SetCrowdsale(_crowdsale);

    return true;

  }

}



contract ERC20Extended is ERC20 {

    function decimals() public view returns (uint);

}



/**

 * @title Belivers Reward Offering

 * @author Tozex

 */

contract BRO is Ownable {

    using SafeMath for uint;

    using Address for address;



    struct Believer {

        address stableCoin;

        uint fundDate;

        uint loanStartDate;

        uint loanEndDate;

        uint loanAmount;

        uint8 tier;

        uint8 lastQuarter;

        bool claimedStakingBonus;

        bool finishedPayout;

    }



    struct LoanConfig {

        uint16 min;

        uint24 max;

        uint8 quarterCount;

        uint8 interestRate;

        uint8 duration;

    }



    struct RewardPlan {

        uint repaymentUsdAmount;

        uint qRepaymentTozAmount;

        uint qInterestAmount;

        mapping (uint8 => uint) stakingBonuses;

    }



    enum BroState {PREPARE, RUNNING, PAUSED, FINISHED, REFUNDING}



    // define constants for DAI/TUSD stable coins

    address public TUSD_ADDRESS;

    address public DAI_ADDRESS;

    address public USDT_ADDRESS;



    // define constants fro day/quarter days

    uint public constant QUARTER_DAYS = 90 days;

    uint public constant ONE_DAY = 1 days;



    // define DAI/TUSD/USDT token contract instances

    ERC20Extended public tusdToken;

    ERC20Extended public daiToken;

    ERC20Extended public usdtToken;

    MintableToken public tozToken;



    // Timestamps for BRO campaign

    uint broStartTimestamp;

    uint broDuration;



    // BRO state variables

    BroState broState = BroState.PREPARE;



    // define master wallet address

    address payable private masterWallet;

    address payable[] private believersArray;



    // mapping for believers database

    mapping (uint8 => LoanConfig) public loanConfigs;

    mapping (address => Believer) public believers;

    mapping (address => RewardPlan) public rewardPlans;

    mapping (address => bool) private whitelist;

    mapping (address => uint) private bonusTozBalances;



    // BRO events definition

    event StartBRO();

    event PauseBRO();

    event FinishBRO();

    event TransferEnabled();

    event PaybackStableCoin(address indexed _token, address indexed _to, uint indexed _amount);

    event PaybackToz(address indexed _to, uint indexed _amount);

    event AddWhitelist(address indexed _address);

    event RemoveFromWhitelist(address indexed _address);

    event UpdateMaserWallet(address payable _masterWallet);

    event UpdateStableCoins();

    event DepositLoan(address indexed _lender, uint _amount, address _coin);

    event ClaimStakingBonus(address indexed _lender, uint _amount);

    event Withdraw(uint _tusdAmount, uint _daiAmount, uint _usdtAmount);



    /**

     * @dev check only supported stablecoins

     */

    modifier isAcceptableTokens(address _token) {

        require(_token == TUSD_ADDRESS || _token == DAI_ADDRESS || _token == USDT_ADDRESS);

        _;

    }



    /**

     * @dev check only whitelisted lenders

     */

    modifier isWhitelisted(address _address) {

        require(whitelist[_address]);

        _;

    }



    /**

     * @param _tozToken address Contract address of TOZ token

     * @param _masterWallet address Address of masterWallet

     * @param _broDuration uint Duration of BRO campaign in days

     * @param _tusdToken address Address of TUSD token

     * @param _daiToken address Address of DAI stablecoin

     * @param _usdtToken address Address of USDT stablecoin

     */

    constructor(address _tozToken, address payable _masterWallet, uint _broDuration, address _tusdToken, address _daiToken, address _usdtToken) public {

        require(_masterWallet != address(0));

        masterWallet = _masterWallet;

        broDuration = _broDuration * ONE_DAY;



        // initialize TOZ token instance

        tozToken = MintableToken(_tozToken);

        daiToken = ERC20Extended(_daiToken);

        tusdToken = ERC20Extended(_tusdToken);

        usdtToken = ERC20Extended(_usdtToken);



        // set token addresses

        TUSD_ADDRESS = _tusdToken;

        DAI_ADDRESS = _daiToken;

        USDT_ADDRESS = _usdtToken;



        // initialize configuration

        initLoanConfig();

    }



    /**

     * Rejecting direct ETH payment to the contract

     */

    function() external {

        revert();

    }



    /**

     * @dev Function to deposit stable coin. This will be called from loan investors directly

     *

     * @param _token address Contract address of stable coin

     * @param _amount uint Amount of deposit

     *

     * @notice Investor should call approve() function of token contract before calling this function

     */

    function depositLoan(address _token, uint _amount) public isAcceptableTokens(_token) returns (bool) {

        require(broState == BroState.RUNNING, "BRO is not active");



        // only accept only once

        require(believers[msg.sender].loanAmount == 0, "Deposit is allowed only once");



        // validate _amount between min/max

        require(_amount >= 10 && _amount <=100000);



        // move half of stable coin to masterWallet

        ERC20Extended token = ERC20Extended(_token);



        uint decimals = token.decimals();



        // send half amount to master wallet

        require(token.transferFrom(msg.sender, masterWallet, _amount.mul(10**decimals).div(2)));

        // send half amount to BRO contract for repayment

        require(token.transferFrom(msg.sender, address(this), _amount.mul(10**decimals).div(2)));



        // register the loan amount

        uint8 tier = getLoanTire(_amount);

        uint8 quarterCount = loanConfigs[tier].quarterCount;



        believers[msg.sender] = Believer(

            _token,

            now,

            now + broDuration,

            now + broDuration + loanConfigs[tier].duration * 30 * ONE_DAY,

            _amount,

            tier,

            0,

            false,

            false

        );



        believersArray.push(msg.sender);



        // calculating reward plan

        uint interestRate = loanConfigs[tier].interestRate;

        uint quarterCapitalReimbursed = _amount.div(2 * quarterCount);

        uint quarterInterests = _amount.mul(interestRate).div(100).div(quarterCount);



        RewardPlan storage rewardPlan = rewardPlans[msg.sender];

        rewardPlan.repaymentUsdAmount = _amount.div(2);

        rewardPlan.qRepaymentTozAmount = quarterCapitalReimbursed;

        rewardPlan.qInterestAmount = quarterInterests;



        // calculate staking bonus for each quarter (Maximum iteration is 6)

        uint sum = 0;

        uint8 q = 1;

        uint bonus = 0;

        while(q <= quarterCount) {

            rewardPlan.stakingBonuses[q] = bonus;

            sum += quarterCapitalReimbursed.add(quarterInterests).add(bonus);

            bonus = sum.div(10);

            q++;

        }



        emit DepositLoan(msg.sender, _amount, address(token));

        return true;

    }



    /**

     * @dev Function to pay back and distribute rewards quarterly

     *

     * @notice this function should be called periodically, quarterly basis to distribute

     * reimbursements, interest of loan, excluding bonus for long term staking

     */

    function payout() public isWhitelisted(msg.sender) {

        // check if the BRO is finished

        require(broState == BroState.FINISHED);



        // iterate all believers

        for (uint8 i = 0; i < believersArray.length; i++) {

            Believer memory lender = believers[believersArray[i]];

            RewardPlan memory rewardPlan = rewardPlans[believersArray[i]];



            // exclude if payout is finished for each lender

            if (lender.finishedPayout) continue;



            // escape if one quarter is not elapsed from last quarter

            uint expectedQuarterlyDate = lender.loanStartDate + (lender.lastQuarter + 1) * QUARTER_DAYS;

            if (now < expectedQuarterlyDate) continue;



            // reimburse as USD for first quarter only

            if (lender.lastQuarter == 0 && rewardPlan.repaymentUsdAmount > 0) {

                // reset the repayment for USD

                rewardPlans[believersArray[i]].repaymentUsdAmount = 0;



                // send DAI/TUSD

                sendStableCoin(lender.stableCoin, believersArray[i], rewardPlan.repaymentUsdAmount);

            }



            if (rewardPlan.qRepaymentTozAmount == 0) continue;



            // summarize

            believers[believersArray[i]].lastQuarter = believers[believersArray[i]].lastQuarter + 1;



            // mint TOZ reimburseAmount (reimburseAmount + interestTozAmount) excluding staking bonus

            mintToz(believersArray[i], rewardPlan.qRepaymentTozAmount.add(rewardPlan.qInterestAmount));



            if (believers[believersArray[i]].lastQuarter == loanConfigs[lender.tier].quarterCount) {

                believers[believersArray[i]].finishedPayout = true;

                // reset TOZ repayment amount

                rewardPlans[believersArray[i]].qRepaymentTozAmount = 0;

                rewardPlans[believersArray[i]].qInterestAmount = 0;

            }

        }

    }



    /**

     * @dev Withdraw believers staking bonus

     */

    function claimStakingBonus() public isWhitelisted(msg.sender) returns (uint) {

        // check if the BRO is finished

        require(broState == BroState.FINISHED);

        // should not claim bonus before

        require(believers[msg.sender].claimedStakingBonus == false);



        Believer memory lender = believers[msg.sender];

        RewardPlan storage rewardPlan = rewardPlans[msg.sender];



        uint totalBonus = 0;

        uint remainingBonus = 0;

        uint8 quarterCount = loanConfigs[lender.tier].quarterCount;

        uint lastQuarter = now.sub(lender.loanStartDate).div(QUARTER_DAYS);



        for (uint8 q = 1; q <= lastQuarter; q++) {

            totalBonus = totalBonus.add(rewardPlan.stakingBonuses[q]);

            // empty staking bonus amount

            rewardPlans[msg.sender].stakingBonuses[q] = 0;

        }



        for (uint8 q = quarterCount; q > lastQuarter; q--) {

            remainingBonus = remainingBonus.add(rewardPlan.stakingBonuses[q]);

            // empty staking bonus amount

            rewardPlans[msg.sender].stakingBonuses[q] = 0;

        }



        // claimedStakingBonus true (reentrancy prevent)

        believers[msg.sender].claimedStakingBonus = true;



        // mint token

        mintToz(msg.sender, totalBonus);



        // mint remaining bonus to master wwallet

        mintToz(masterWallet, remainingBonus);



        emit ClaimStakingBonus(msg.sender, totalBonus);

        return totalBonus;

    }



    /**

     * @dev Function to get lenders count

     */

    function getLendersCount() public view returns (uint) {

        return believersArray.length;

    }



    /**

     * @dev Function to read loan information

     */

    function getLoanData(address _lender) public view returns (address, uint, uint, uint8, uint8, bool, bool) {

        return (believers[_lender].stableCoin, believers[_lender].loanAmount, believers[_lender].loanStartDate, believers[_lender].tier, believers[_lender].lastQuarter, believers[_lender].claimedStakingBonus, believers[_lender].finishedPayout);

    }



    /**

     * @dev Function to read reward plan

     */

    function getRewardPlan(address _lender) public view returns (uint, uint, uint) {

        return (rewardPlans[_lender].repaymentUsdAmount, rewardPlans[_lender].qRepaymentTozAmount, rewardPlans[_lender].qInterestAmount);

    }



    /**

     * @dev Function to get staking bonus for a specific quarter

     */

    function getRewardPlan(address _lender, uint8 _quarter) public view returns (uint) {

        return rewardPlans[_lender].stakingBonuses[_quarter];

    }



    /**

     * @dev Function to get lenders count

     */

    function getLoanConfig(uint8 _quarter) public view returns (uint8, uint8, uint8) {

        return (loanConfigs[_quarter].quarterCount, loanConfigs[_quarter].interestRate, loanConfigs[_quarter].duration);

    }



    /**

     * @dev Function to add whitelist

     */

    function addToWhitelist(address[] memory _addresses) public onlyOwner {

        // validate if whitelisting is eligible

        require(broState == BroState.PREPARE);



        for (uint256 i = 0; i < _addresses.length; i++) {

            if (whitelist[_addresses[i]]) continue;

            whitelist[_addresses[i]] = true;

        }

    }



    /**

     * @dev Function to remove from whitelist

     */

    function removeFromWhitelist(address[] memory _addresses) public onlyOwner {

        require(broState == BroState.PREPARE);



        for (uint256 i = 0; i < _addresses.length; i++) {

            if (!whitelist[_addresses[i]]) continue;

            whitelist[_addresses[i]] = false;

        }

    }



    // -------------- Administrative functions -------------- //

    /**

     * @dev Function to start BRO campaign

     */

    function startBRO() public onlyOwner returns (bool) {

        broState = BroState.RUNNING;



        broStartTimestamp = now;



        emit StartBRO();

        return true;

    }



    /**

     * @dev Function to pause BRO campaign

     */

    function pauseBRO() public onlyOwner returns (bool) {

        broState = BroState.PAUSED;



        emit PauseBRO();

        return true;

    }



    /**

     * @dev Function to finish BRO campaign

     */

    function finishBRO() public onlyOwner returns (bool) {

        broState = BroState.FINISHED;



        emit FinishBRO();

        return true;

    }



    /**

     * @dev Function to replace TOZEX multisig wallet address

     */

    function updateMasterWallet(address payable _masterWallet) public onlyOwner {

        require(_masterWallet != address(0));

        masterWallet = _masterWallet;



        emit UpdateMaserWallet(_masterWallet);

    }



    /**

     * @dev Function to update Stablecoin addresses for TUSD/DAI

     */

    function updateStableCoins(address _tusdToken, address _daiToken, address _usdtToken) public onlyOwner {

        require(_tusdToken.isContract());

        require(_daiToken.isContract());

        require(_usdtToken.isContract());



        daiToken = ERC20Extended(_daiToken);

        tusdToken = ERC20Extended(_tusdToken);

        usdtToken = ERC20Extended(_usdtToken);



        // set token addresses

        TUSD_ADDRESS = _tusdToken;

        DAI_ADDRESS = _daiToken;

        USDT_ADDRESS = _usdtToken;



        emit UpdateStableCoins();

    }



    /**

     * @dev Withdraw TUSD/DAI/USDT to master wallet for security

     */

    function withdraw() public onlyOwner {

        require(broState == BroState.FINISHED);



        uint tusdBalance = tusdToken.balanceOf(address(this));

        uint daiBalance = daiToken.balanceOf(address(this));

        uint usdtBalance = usdtToken.balanceOf(address(this));



        if (tusdBalance > 0) sendStableCoin(TUSD_ADDRESS, masterWallet, tusdBalance);

        if (daiBalance > 0) sendStableCoin(DAI_ADDRESS, masterWallet, daiBalance);

        if (usdtBalance > 0) sendStableCoin(USDT_ADDRESS, masterWallet, usdtBalance);



        emit Withdraw(tusdBalance, daiBalance, usdtBalance);

    }



    // -------------- Internal functions -------------- //



    /**

     * @dev Send TUSD/DAI/USDT to lender for reimbursement

     * @notice this should be discussed

     */

    function sendStableCoin(address _token, address payable _receiver, uint _amount) internal isAcceptableTokens(_token) returns (uint) {

        ERC20Extended token = ERC20Extended(_token);



        uint decimals = token.decimals();

        uint weiAmount = _amount.mul(10**decimals);



        require(token.transfer(_receiver, weiAmount));



        emit PaybackStableCoin(_token, _receiver, weiAmount);

        return _amount;

    }



    /**

     * @dev Mint TOZ to lender for reimbursement and reward

     */

    function mintToz(address _receiver, uint _amount) internal returns (uint) {

        uint decimals = tozToken.decimals();

        uint weiAmount = _amount.mul(10**decimals);



        // send TOZ token

        require(tozToken.mint(_receiver, weiAmount));



        emit PaybackToz(_receiver, _amount);

        return _amount;

    }



    /**

     * @dev Get proper tier for the loan amount

     */

    function getLoanTire(uint _amount) internal pure returns (uint8 tier) {

        if (_amount >= 10 && _amount <= 10000) {

            tier = 1;

        } else if (_amount > 10000 && _amount <= 50000) {

            tier = 2;

        } else if (_amount > 50000 && _amount <= 100000) {

            tier = 3;

        }

    }



    /**

     * @dev Initialize loan configuration for each tier 1, 2, 3

     */

    function initLoanConfig() internal {

        loanConfigs[1] = LoanConfig(10, 10000, 4, 10, 12);

        loanConfigs[2] = LoanConfig(10001, 50000, 5, 12, 15);

        loanConfigs[3] = LoanConfig(50001, 100000, 6, 15, 18);

    }

}

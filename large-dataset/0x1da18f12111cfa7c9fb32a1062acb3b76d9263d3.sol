pragma solidity 0.5.16;


library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

library Address {
    function isContract(address account) internal view returns (bool) {
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
    }
    function toPayable(address account) internal pure returns (address payable) {
        return address(uint160(account));
    }
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }
    function callOptionalReturn(IERC20 token, bytes memory data) private {
        require(address(token).isContract(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

contract ReentrancyGuard {
    uint256 private _guardCounter;

    constructor () internal {
        _guardCounter = 1;
    }

    modifier nonReentrant() {
        _guardCounter += 1;
        uint256 localCounter = _guardCounter;
        _;
        require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
    }
}

contract Context {
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    constructor () internal {
        _owner = _msgSender();
        emit OwnershipTransferred(address(0), _owner);
    }
    function owner() public view returns (address) {
        return _owner;
    }
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }
    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;
    }
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface CompoundInterface {
    function mint(uint256 mintAmount) external returns ( uint256 );
    function redeemUnderlying(uint256 redeemAmount) external returns (uint256);
    function exchangeRateStored() external view returns (uint);
}

/*
 * @title  Pool
 * @notice Abstract pool to facilitate tracking of shares in a pool
 */
contract Pool {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    uint256 private _totalShares;
    mapping(address => uint256) private _shares;

    /**
     * @dev Pool constructor
     */
    constructor() internal {
    }

    /*** VIEW ***/

    /**
     * @dev Get the total number of shares in pool
     * @return uint256 total shares
     */
    function totalShares()
        public
        view
        returns (uint256)
    {
        return _totalShares;
    }

    /**
     * @dev Get the share of a given account
     * @param _account User for which to retrieve balance
     * @return uint256 shares
     */
    function sharesOf(address _account)
        public
        view
        returns (uint256)
    {
        return _shares[_account];
    }

    /*** INTERNAL ***/

    /**
     * @dev Add a given amount of shares to a given account
     * @param _account Account to increase shares for
     * @param _amount Units of shares
     */
    function _increaseShares(address _account, uint256 _amount)
        internal
    {
        _totalShares = _totalShares.add(_amount);
        _shares[_account] = _shares[_account].add(_amount);
    }

    /**
     * @dev Remove a given amount of shares from a given account
     * @param _account Account to decrease shares for
     * @param _amount Units of shares
     */
    function _decreaseShares(address _account, uint256 _amount)
        internal
    {
        _totalShares = _totalShares.sub(_amount);
        _shares[_account] = _shares[_account].sub(_amount);
    }
}

/**
 * @title EarningPool
 * @dev Pool that tracks shares of an underlying token, of which are deposited into COMPOUND.
        Earnings from provider is sent to recipients
 */
contract EarningPool is ReentrancyGuard, Ownable, Pool {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    address public underlyingToken;

    // Compound cToken address (provider)
    address public compound;

    // Provider reward token address
    address public rewardToken;

    // Address where earning are dispensed to
    address public earningRecipient;

    // Address where rewards are dispensed to
    address public rewardRecipient;

    // Fee factor mantissa, 1e18 = 100%
    uint256 public withdrawFeeFactorMantissa;

    uint256 public earningDispenseThreshold;
    uint256 public rewardDispenseThreshold;

    event Deposited(address indexed beneficiary, uint256 amount, address payer);
    event Withdrawn(address indexed beneficiary, uint256 amount, address payer);
    event Dispensed(address indexed token, uint256 amount);

    /**
     * @dev EarningPool constructor
     * @param _underlyingToken The underlying token thats is earning interest from provider
     * @param _rewardToken Provider reward token
     * @param _compound Compound cToken address for underlying token
     */
    constructor (
        address _underlyingToken,
        address _rewardToken,
        address _compound
    )
        Pool()
        public
    {
        underlyingToken = _underlyingToken;
        rewardToken = _rewardToken;
        compound = _compound;

        _approveUnderlyingToProvider();
    }

    /*** USER ***/

    /**
     * @dev Deposit underlying into pool
     * @param _beneficiary Address to benefit from the deposit
     * @param _amount Amount of underlying to deposit
     */
    function deposit(address _beneficiary, uint256 _amount)
        external
        nonReentrant
    {
        _deposit(_beneficiary, _amount);
    }

    /**
     * @dev Withdraw underlying from pool
     * @param _beneficiary Address to benefit from the withdraw
     * @param _amount Amount of underlying to withdraw
     * @return uint256 Actual amount of underlying withdrawn
     */
    function withdraw(address _beneficiary, uint256 _amount)
        external
        nonReentrant
        returns (uint256)
    {
        return _withdraw(_beneficiary, _amount);
    }

    /**
     * @dev Transfer underlying token interest earned to recipient
     * @return uint256 Amount dispensed
     */
    function dispenseEarning() public returns (uint256) {
        if (earningRecipient == address(0)) {
           return 0;
        }

        uint256 earnings = calcUndispensedEarningInUnderlying();
        // total dispense amount = earning + withdraw fee
        uint256 totalDispenseAmount =  earnings.add(balanceInUnderlying());
        if (totalDispenseAmount < earningDispenseThreshold) {
           return 0;
        }

        // Withdraw earning from provider
        _withdrawFromProvider(earnings);

        // Transfer earning + withdraw fee to recipient
        IERC20(underlyingToken).safeTransfer(earningRecipient, totalDispenseAmount);

        emit Dispensed(underlyingToken, totalDispenseAmount);

        return totalDispenseAmount;
    }

    /**
     * @dev Transfer reward token earned to recipient
     * @return uint256 Amount dispensed
     */
    function dispenseReward() public returns (uint256) {
        if (rewardRecipient == address(0)) {
           return 0;
        }

        uint256 rewards = calcUndispensedProviderReward();
        if (rewards < rewardDispenseThreshold) {
           return 0;
        }

        // Transfer COMP rewards to recipient
        IERC20(rewardToken).safeTransfer(rewardRecipient, rewards);

        emit Dispensed(rewardToken, rewards);

        return rewards;
    }

    /*** VIEW ***/

    /**
     * @dev Get balance of underlying token in this pool
     *      Should equal to withdraw fee unless underlyings are sent to pool
     * @return uint256 Underlying token balance
     */
    function balanceInUnderlying() public view returns (uint256) {
        return IERC20(underlyingToken).balanceOf(address(this));
    }

    /**
     * @dev Get balance of COMP cToken in this pool
     * @return uint256 COMP cToken balance
     */
    function balanceCompound() public view returns (uint256) {
        return IERC20(compound).balanceOf(address(this));
    }

    /**
     * @dev Get balance of compound token in this pool converted to underlying
     * @return uint256 Underlying token balance
     */
    function balanceCompoundInUnderlying() public view returns (uint256) {
        // Mantisa 1e18 to decimals
        uint256 b = balanceCompound();
        if (b > 0) {
          b = b.mul(CompoundInterface(compound).exchangeRateStored()).div(1e18);
        }
        return b;
    }

    /**
     * @dev Calculate total underlying balance of this pool
     *      Total balance of underlying = total provider underlying balance (deposit + interest accrued) + withdraw fee
     * @return uint256 Underlying token balance
     */
    function calcPoolValueInUnderlying() public view returns (uint256) {
        return balanceCompoundInUnderlying() // compound
               .add(balanceInUnderlying()); // withdraw fee
    }

    /**
     * @dev Calculate outstanding interest earning of underlying token in this pool
     *      Earning = total provider underlying balance - total deposit
     * @return uint256 Underlying token balance
     */
    function calcUndispensedEarningInUnderlying() public view returns(uint256) {
        return balanceCompoundInUnderlying().sub(totalShares());
    }

    /**
     * @dev Get outstanding reward token in pool
     * @return uint256 Reward token balance
     */
    function calcUndispensedProviderReward() public view returns(uint256) {
        return IERC20(rewardToken).balanceOf(address(this));
    }

    /*** ADMIN ***/

    function setWithdrawFeeFactor(uint256 _withdrawFeeFactorManitssa)
        public
        onlyOwner
    {
        withdrawFeeFactorMantissa = _withdrawFeeFactorManitssa;
    }

    function setEarningRecipient(address _recipient)
        public
        onlyOwner
    {
        earningRecipient = _recipient;
    }

    function setRewardRecipient(address _recipient)
        public
        onlyOwner
    {
        rewardRecipient = _recipient;
    }

    function setEarningDispenseThreshold(uint256 _threshold)
        public
        onlyOwner
    {
        earningDispenseThreshold = _threshold;
    }

    function setRewardDispenseThreshold(uint256 _threshold)
        public
        onlyOwner
    {
        rewardDispenseThreshold = _threshold;
    }


    /*** INTERNAL ***/

    function _deposit(address _beneficiary, uint256 _amount)
        internal
    {
        require(_amount > 0, "EARNING_POOL: deposit must be greater than 0");

        // Transfer underlying from payer into pool
        IERC20(underlyingToken).safeTransferFrom(msg.sender, address(this), _amount);

        // Supply underlying to provider
        _supplyToProvider(_amount);

        // increase pool shares for beneficiary
        _increaseShares(_beneficiary, _amount);

        emit Deposited(_beneficiary, _amount, msg.sender);
    }

    function _withdraw(address _beneficiary, uint256 _amount)
        internal
        returns (uint256)
    {
        require(_amount > 0, "EARNING_POOL: withdraw must be greater than 0");
        require(_amount <= sharesOf(msg.sender), "EARNING_POOL: withdraw insufficient shares");

        // Withdraw underlying from provider
        _withdrawFromProvider(_amount);

        // decrease pool shares from payer
        _decreaseShares(msg.sender, _amount);

        // Collect withdraw fee
        uint256 withdrawFee = _amount.mul(withdrawFeeFactorMantissa).div(1e18);
        uint256 withdrawAmountLessFee = _amount.sub(withdrawFee);

        // Transfer underlying to beneficiary
        IERC20(underlyingToken).safeTransfer(_beneficiary, withdrawAmountLessFee);

        emit Withdrawn(_beneficiary, withdrawAmountLessFee, msg.sender);

        return withdrawAmountLessFee;
    }

    /**
     * @dev Approve underlying token to providers
     */
    function _approveUnderlyingToProvider() internal {
        IERC20(underlyingToken).safeApprove(compound, uint256(-1));
    }

    /**
     * @dev Withdraw some underlying from Compound
     * @param _amount Amount of underlying to withdraw
     */
    function _withdrawFromProvider(uint256 _amount) internal {
        require(balanceCompoundInUnderlying() >= _amount, "COMPOUND: withdraw insufficient funds");
        require(CompoundInterface(compound).redeemUnderlying(_amount) == 0, "COMPOUND: redeemUnderlying failed");
    }

    /**
     * @dev Withdraw some underlying to Compound
     * @param _amount Amount of underlying to supply
     */
    function _supplyToProvider(uint256 _amount) internal {
        // Check compound rcode
        require(CompoundInterface(compound).mint(_amount) == 0, "COMPOUND: mint failed");
    }
}

/**
 * @title USDCPool
 * @dev Earning pool for USDC
 */
contract USDCPool is EarningPool {
    constructor ()
        EarningPool (
            address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48), // USDC
            address(0xc00e94Cb662C3520282E6f5717214004A7f26888), // reward token
            address(0x39AA39c021dfbaE8faC545936693aC917d5E7563) // compound cUSDC
        )
        public
    {
    }
}

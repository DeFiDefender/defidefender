// File: @openzeppelin/contracts/GSN/Context.sol





pragma solidity ^0.6.0;



/*

 * @dev Provides information about the current execution context, including the

 * sender of the transaction and its data. While these are generally available

 * via msg.sender and msg.data, they should not be accessed in such a direct

 * manner, since when dealing with GSN meta-transactions the account sending and

 * paying for execution may not be the actual sender (as far as an application

 * is concerned).

 *

 * This contract is only required for intermediate, library-like contracts.

 */

abstract contract Context {

    function _msgSender() internal view virtual returns (address payable) {

        return msg.sender;

    }



    function _msgData() internal view virtual returns (bytes memory) {

        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691

        return msg.data;

    }

}



// File: @openzeppelin/contracts/access/Ownable.sol





pragma solidity ^0.6.0;



/**

 * @dev Contract module which provides a basic access control mechanism, where

 * there is an account (an owner) that can be granted exclusive access to

 * specific functions.

 *

 * By default, the owner account will be the one that deploys the contract. This

 * can later be changed with {transferOwnership}.

 *

 * This module is used through inheritance. It will make available the modifier

 * `onlyOwner`, which can be applied to your functions to restrict their use to

 * the owner.

 */

contract Ownable is Context {

    address private _owner;



    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);



    /**

     * @dev Initializes the contract setting the deployer as the initial owner.

     */

    constructor () internal {

        address msgSender = _msgSender();

        _owner = msgSender;

        emit OwnershipTransferred(address(0), msgSender);

    }



    /**

     * @dev Returns the address of the current owner.

     */

    function owner() public view returns (address) {

        return _owner;

    }



    /**

     * @dev Throws if called by any account other than the owner.

     */

    modifier onlyOwner() {

        require(_owner == _msgSender(), "Ownable: caller is not the owner");

        _;

    }



    /**

     * @dev Leaves the contract without owner. It will not be possible to call

     * `onlyOwner` functions anymore. Can only be called by the current owner.

     *

     * NOTE: Renouncing ownership will leave the contract without an owner,

     * thereby removing any functionality that is only available to the owner.

     */

    function renounceOwnership() public virtual onlyOwner {

        emit OwnershipTransferred(_owner, address(0));

        _owner = address(0);

    }



    /**

     * @dev Transfers ownership of the contract to a new account (`newOwner`).

     * Can only be called by the current owner.

     */

    function transferOwnership(address newOwner) public virtual onlyOwner {

        require(newOwner != address(0), "Ownable: new owner is the zero address");

        emit OwnershipTransferred(_owner, newOwner);

        _owner = newOwner;

    }

}



// File: @openzeppelin/contracts/token/ERC20/IERC20.sol





pragma solidity ^0.6.0;



/**

 * @dev Interface of the ERC20 standard as defined in the EIP.

 */

interface IERC20 {

    /**

     * @dev Returns the amount of tokens in existence.

     */

    function totalSupply() external view returns (uint256);



    /**

     * @dev Returns the amount of tokens owned by `account`.

     */

    function balanceOf(address account) external view returns (uint256);



    /**

     * @dev Moves `amount` tokens from the caller's account to `recipient`.

     *

     * Returns a boolean value indicating whether the operation succeeded.

     *

     * Emits a {Transfer} event.

     */

    function transfer(address recipient, uint256 amount) external returns (bool);



    /**

     * @dev Returns the remaining number of tokens that `spender` will be

     * allowed to spend on behalf of `owner` through {transferFrom}. This is

     * zero by default.

     *

     * This value changes when {approve} or {transferFrom} are called.

     */

    function allowance(address owner, address spender) external view returns (uint256);



    /**

     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.

     *

     * Returns a boolean value indicating whether the operation succeeded.

     *

     * IMPORTANT: Beware that changing an allowance with this method brings the risk

     * that someone may use both the old and the new allowance by unfortunate

     * transaction ordering. One possible solution to mitigate this race

     * condition is to first reduce the spender's allowance to 0 and set the

     * desired value afterwards:

     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729

     *

     * Emits an {Approval} event.

     */

    function approve(address spender, uint256 amount) external returns (bool);



    /**

     * @dev Moves `amount` tokens from `sender` to `recipient` using the

     * allowance mechanism. `amount` is then deducted from the caller's

     * allowance.

     *

     * Returns a boolean value indicating whether the operation succeeded.

     *

     * Emits a {Transfer} event.

     */

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);



    /**

     * @dev Emitted when `value` tokens are moved from one account (`from`) to

     * another (`to`).

     *

     * Note that `value` may be zero.

     */

    event Transfer(address indexed from, address indexed to, uint256 value);



    /**

     * @dev Emitted when the allowance of a `spender` for an `owner` is set by

     * a call to {approve}. `value` is the new allowance.

     */

    event Approval(address indexed owner, address indexed spender, uint256 value);

}



// File: @openzeppelin/contracts/token/ERC20/ERC20.sol





pragma solidity ^0.6.0;











/**

 * @dev Implementation of the {IERC20} interface.

 *

 * This implementation is agnostic to the way tokens are created. This means

 * that a supply mechanism has to be added in a derived contract using {_mint}.

 * For a generic mechanism see {ERC20PresetMinterPauser}.

 *

 * TIP: For a detailed writeup see our guide

 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How

 * to implement supply mechanisms].

 *

 * We have followed general OpenZeppelin guidelines: functions revert instead

 * of returning `false` on failure. This behavior is nonetheless conventional

 * and does not conflict with the expectations of ERC20 applications.

 *

 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.

 * This allows applications to reconstruct the allowance for all accounts just

 * by listening to said events. Other implementations of the EIP may not emit

 * these events, as it isn't required by the specification.

 *

 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}

 * functions have been added to mitigate the well-known issues around setting

 * allowances. See {IERC20-approve}.

 */

contract ERC20 is Context, IERC20 {

    using SafeMath for uint256;

    using Address for address;



    mapping (address => uint256) private _balances;



    mapping (address => mapping (address => uint256)) private _allowances;



    uint256 private _totalSupply;



    string private _name;

    string private _symbol;

    uint8 private _decimals;



    /**

     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with

     * a default value of 18.

     *

     * To select a different value for {decimals}, use {_setupDecimals}.

     *

     * All three of these values are immutable: they can only be set once during

     * construction.

     */

    constructor (string memory name, string memory symbol) public {

        _name = name;

        _symbol = symbol;

        _decimals = 18;

    }



    /**

     * @dev Returns the name of the token.

     */

    function name() public view returns (string memory) {

        return _name;

    }



    /**

     * @dev Returns the symbol of the token, usually a shorter version of the

     * name.

     */

    function symbol() public view returns (string memory) {

        return _symbol;

    }



    /**

     * @dev Returns the number of decimals used to get its user representation.

     * For example, if `decimals` equals `2`, a balance of `505` tokens should

     * be displayed to a user as `5,05` (`505 / 10 ** 2`).

     *

     * Tokens usually opt for a value of 18, imitating the relationship between

     * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is

     * called.

     *

     * NOTE: This information is only used for _display_ purposes: it in

     * no way affects any of the arithmetic of the contract, including

     * {IERC20-balanceOf} and {IERC20-transfer}.

     */

    function decimals() public view returns (uint8) {

        return _decimals;

    }



    /**

     * @dev See {IERC20-totalSupply}.

     */

    function totalSupply() public view override returns (uint256) {

        return _totalSupply;

    }



    /**

     * @dev See {IERC20-balanceOf}.

     */

    function balanceOf(address account) public view override returns (uint256) {

        return _balances[account];

    }



    /**

     * @dev See {IERC20-transfer}.

     *

     * Requirements:

     *

     * - `recipient` cannot be the zero address.

     * - the caller must have a balance of at least `amount`.

     */

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {

        _transfer(_msgSender(), recipient, amount);

        return true;

    }



    /**

     * @dev See {IERC20-allowance}.

     */

    function allowance(address owner, address spender) public view virtual override returns (uint256) {

        return _allowances[owner][spender];

    }



    /**

     * @dev See {IERC20-approve}.

     *

     * Requirements:

     *

     * - `spender` cannot be the zero address.

     */

    function approve(address spender, uint256 amount) public virtual override returns (bool) {

        _approve(_msgSender(), spender, amount);

        return true;

    }



    /**

     * @dev See {IERC20-transferFrom}.

     *

     * Emits an {Approval} event indicating the updated allowance. This is not

     * required by the EIP. See the note at the beginning of {ERC20};

     *

     * Requirements:

     * - `sender` and `recipient` cannot be the zero address.

     * - `sender` must have a balance of at least `amount`.

     * - the caller must have allowance for ``sender``'s tokens of at least

     * `amount`.

     */

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {

        _transfer(sender, recipient, amount);

        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));

        return true;

    }



    /**

     * @dev Atomically increases the allowance granted to `spender` by the caller.

     *

     * This is an alternative to {approve} that can be used as a mitigation for

     * problems described in {IERC20-approve}.

     *

     * Emits an {Approval} event indicating the updated allowance.

     *

     * Requirements:

     *

     * - `spender` cannot be the zero address.

     */

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {

        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));

        return true;

    }



    /**

     * @dev Atomically decreases the allowance granted to `spender` by the caller.

     *

     * This is an alternative to {approve} that can be used as a mitigation for

     * problems described in {IERC20-approve}.

     *

     * Emits an {Approval} event indicating the updated allowance.

     *

     * Requirements:

     *

     * - `spender` cannot be the zero address.

     * - `spender` must have allowance for the caller of at least

     * `subtractedValue`.

     */

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {

        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));

        return true;

    }



    /**

     * @dev Moves tokens `amount` from `sender` to `recipient`.

     *

     * This is internal function is equivalent to {transfer}, and can be used to

     * e.g. implement automatic token fees, slashing mechanisms, etc.

     *

     * Emits a {Transfer} event.

     *

     * Requirements:

     *

     * - `sender` cannot be the zero address.

     * - `recipient` cannot be the zero address.

     * - `sender` must have a balance of at least `amount`.

     */

    function _transfer(address sender, address recipient, uint256 amount) internal virtual {

        require(sender != address(0), "ERC20: transfer from the zero address");

        require(recipient != address(0), "ERC20: transfer to the zero address");



        _beforeTokenTransfer(sender, recipient, amount);



        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");

        _balances[recipient] = _balances[recipient].add(amount);

        emit Transfer(sender, recipient, amount);

    }



    /** @dev Creates `amount` tokens and assigns them to `account`, increasing

     * the total supply.

     *

     * Emits a {Transfer} event with `from` set to the zero address.

     *

     * Requirements

     *

     * - `to` cannot be the zero address.

     */

    function _mint(address account, uint256 amount) internal virtual {

        require(account != address(0), "ERC20: mint to the zero address");



        _beforeTokenTransfer(address(0), account, amount);



        _totalSupply = _totalSupply.add(amount);

        _balances[account] = _balances[account].add(amount);

        emit Transfer(address(0), account, amount);

    }



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

    function _burn(address account, uint256 amount) internal virtual {

        require(account != address(0), "ERC20: burn from the zero address");



        _beforeTokenTransfer(account, address(0), amount);



        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");

        _totalSupply = _totalSupply.sub(amount);

        emit Transfer(account, address(0), amount);

    }



    /**

     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.

     *

     * This internal function is equivalent to `approve`, and can be used to

     * e.g. set automatic allowances for certain subsystems, etc.

     *

     * Emits an {Approval} event.

     *

     * Requirements:

     *

     * - `owner` cannot be the zero address.

     * - `spender` cannot be the zero address.

     */

    function _approve(address owner, address spender, uint256 amount) internal virtual {

        require(owner != address(0), "ERC20: approve from the zero address");

        require(spender != address(0), "ERC20: approve to the zero address");



        _allowances[owner][spender] = amount;

        emit Approval(owner, spender, amount);

    }



    /**

     * @dev Sets {decimals} to a value other than the default one of 18.

     *

     * WARNING: This function should only be called from the constructor. Most

     * applications that interact with token contracts will not expect

     * {decimals} to ever change, and may work incorrectly if it does.

     */

    function _setupDecimals(uint8 decimals_) internal {

        _decimals = decimals_;

    }



    /**

     * @dev Hook that is called before any transfer of tokens. This includes

     * minting and burning.

     *

     * Calling conditions:

     *

     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens

     * will be to transferred to `to`.

     * - when `from` is zero, `amount` tokens will be minted for `to`.

     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.

     * - `from` and `to` are never both zero.

     *

     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].

     */

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }

}





// File: localhost/contracts/MineLiquidityMining.sol



pragma solidity ^0.6.12;















contract MineLiquidityMining is Ownable {

    using SafeMath for uint256;

    using SafeERC20 for SpaceMineToken;

    using SafeERC20 for IERC20;

    using Address for address;



    SpaceMineToken private mine;

    IERC20 private lpToken;



    //LP token balances

    mapping(address => uint256) private _lpBalances;

    uint private _lpTotalSupply;



    // halving period time

    uint256 public constant DURATION = 2 weeks;

    // initial amount of mine

    uint256 public initReward = 13440 * 1e18;

    bool public haveStarted = false;

    // next time of halving

    uint256 public halvingTime = 0;

    uint256 public lastUpdateTime = 0;

    // distribution of per second

    uint256 public rewardRate = 0;

    uint256 public rewardPerLPToken = 0;

    mapping(address => uint256) private rewards;

    mapping(address => uint256) private userRewardPerTokenPaid;





    // Something about dev.

    address public devAddr;

    uint256 public devDistributeRate = 0;

    uint256 public lastDistributeTime = 0;

    uint256 public devFinishTime = 0;

    uint256 public devFundAmount = 5760 * 1e18;

    uint256 public devDistributeDuration = 180 days;



    event Stake(address indexed from, uint amount);

    event Withdraw(address indexed to, uint amount);

    event Claim(address indexed to, uint amount);

    event Halving(uint amount);

    event Start(uint amount);



    constructor(

        address _mine, 

        address _lpToken

        ) public {

        mine = SpaceMineToken(_mine);

        lpToken = IERC20(_lpToken);

        devAddr = owner();

    }



    function totalSupply() public view returns(uint256) {

        return _lpTotalSupply;

    }



    function balanceOf(address account) public view returns(uint256) {

        return _lpBalances[account];

    }



    function stake(uint amount) public shouldStarted {

        updateRewards(msg.sender);

        checkHalving();

        require(!address(msg.sender).isContract(), "Please use your individual account.");

        lpToken.safeTransferFrom(msg.sender, address(this), amount);

        _lpTotalSupply = _lpTotalSupply.add(amount);

        _lpBalances[msg.sender] = _lpBalances[msg.sender].add(amount);

        distributeDevFund();

        emit Stake(msg.sender, amount);

    }



    function withdraw(uint amount) public shouldStarted {

        updateRewards(msg.sender);

        checkHalving();

        require(amount <= _lpBalances[msg.sender] && _lpBalances[msg.sender] > 0, "Bad withdraw.");

        lpToken.safeTransfer(msg.sender, amount);

        _lpTotalSupply = _lpTotalSupply.sub(amount);

        _lpBalances[msg.sender] = _lpBalances[msg.sender].sub(amount);

        distributeDevFund();

        emit Withdraw(msg.sender, amount);

    }



    function claim(uint amount) public shouldStarted {

        updateRewards(msg.sender);

        checkHalving();

        require(amount <= rewards[msg.sender] && rewards[msg.sender] > 0, "Bad claim.");

        rewards[msg.sender] = rewards[msg.sender].sub(amount);

        mine.safeTransfer(msg.sender, amount);

        distributeDevFund();

        emit Claim(msg.sender, amount);

    }



    function checkHalving() internal {

        if (block.timestamp >= halvingTime) {

            initReward = initReward.mul(50).div(100);

            mine.mint(address(this), initReward);



            rewardRate = initReward.div(DURATION);

            halvingTime = halvingTime.add(DURATION);



            updateRewards(msg.sender);

            emit Halving(initReward);

        }

    }



    modifier shouldStarted() {

        require(haveStarted == true, "Have not started.");

        _;

    }



    function getRewardsAmount(address account) public view returns(uint256) {

        return balanceOf(account).mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))

        .div(1e18)

        .add(rewards[account]);

    }



    function rewardPerToken() public view returns (uint256) {

        if (_lpTotalSupply == 0) {

            return rewardPerLPToken;

        }

        return rewardPerLPToken

        .add(Math.min(block.timestamp, halvingTime)

        .sub(lastUpdateTime)

        .mul(rewardRate)

        .mul(1e18)

        .div(_lpTotalSupply)

        );

    }



    function updateRewards(address account) internal {

        rewardPerLPToken = rewardPerToken();

        lastUpdateTime = lastRewardTime();

        if (account != address(0)) {

            rewards[account] = getRewardsAmount(account);

            userRewardPerTokenPaid[account] = rewardPerLPToken;

        }

    }



    function lastRewardTime() public view returns (uint256) {

        return Math.min(block.timestamp, halvingTime);

    }



    function startFarming() external onlyOwner {

        updateRewards(address(0));

        rewardRate = initReward.div(DURATION);



        uint256 mintAmount = initReward.add(devFundAmount);

        mine.mint(address(this), mintAmount);

        devDistributeRate = devFundAmount.div(devDistributeDuration);

        devFinishTime = block.timestamp.add(devDistributeDuration);



        lastUpdateTime = block.timestamp;

        lastDistributeTime = block.timestamp;

        halvingTime = block.timestamp.add(DURATION);



        haveStarted = true;

        emit Start(mintAmount);

    }



    function transferDevAddr(address newAddr) public onlyDev {

        require(newAddr != address(0), "zero addr");

        devAddr = newAddr;

    }



    function distributeDevFund() internal {

        uint256 nowTime = Math.min(block.timestamp, devFinishTime);

        uint256 fundAmount = nowTime.sub(lastDistributeTime).mul(devDistributeRate);

        mine.safeTransfer(devAddr, fundAmount);

        lastDistributeTime = nowTime;

    }



    modifier onlyDev() {

        require(msg.sender == devAddr, "This is only for dev.");

        _;

    }



    function lpTokenAddress() view public returns(address) {

        return address(lpToken);

    }



    function mineAddress() view public returns(address) {

        return address(mine);

    }



    function testMint() public onlyOwner {

        mine.mint(address(this), 1);

    }



    function setInitRewards(uint256 reward) public onlyOwner {

        initReward = reward;

    }

}

// File: localhost/contracts/POLContract.sol



pragma solidity 0.6.12;







contract POLContract {



    event Received(address, uint);

    event onDeposit(address, uint256, uint256);

    event onWithdraw(address, uint256);



    using SafeMath for uint256;



    struct VestingPeriod {

        uint256 epoch;

        uint256 amount;

    }



    struct UserTokenInfo {

        uint256 deposited; // incremented on successful deposit

        uint256 withdrawn; // incremented on successful withdrawl

        VestingPeriod[] vestingPeriods; // added to on successful deposit

    }



    // map erc20 token to user address to release schedule

    mapping(address => mapping(address => UserTokenInfo)) tokenUserMap;



    struct LiquidityTokenomics {

        uint256[] epochs;

        mapping (uint256 => uint256) releaseMap; // map epoch -> amount withdrawable

    }



    // map erc20 token to release schedule

    mapping(address => LiquidityTokenomics) tokenEpochMap;





    // Fast mapping to prevent array iteration in solidity

    mapping(address => bool) public lockedTokenLookup;



    // A dynamically-sized array of currently locked tokens

    address[] public lockedTokens;



    // fee variables

    uint256 public feeNumerator;

    uint256 public feeDenominator;



    address public feeReserveAddress;

    address public owner;



    constructor() public {

        feeNumerator = 3;

        feeDenominator = 1000;

        feeReserveAddress = address(0xAA3d85aD9D128DFECb55424085754F6dFa643eb1);

        owner = address(0xfCdd591498e86876F086524C0b2E9Af41a0c9FCD);

    }



    receive() external payable {

        emit Received(msg.sender, msg.value);

    }



    modifier onlyOwner {

        require(msg.sender == owner, "You are not the owner");

        _;

    }



    function updateFee(uint256 numerator, uint256 denominator) onlyOwner public {

        feeNumerator = numerator;

        feeDenominator = denominator;

    }



    function calculateFee(uint256 amount) public view returns (uint256){

        require(amount >= feeDenominator, 'Deposit is too small');

        uint256 amountInLarge = amount.mul(feeDenominator.sub(feeNumerator));

        uint256 amountIn = amountInLarge.div(feeDenominator);

        uint256 fee = amount.sub(amountIn);

        return (fee);

    }



    function depositTokenMultipleEpochs(address token, uint256[] memory amounts, uint256[] memory dates) public payable {

        require(amounts.length == dates.length, 'Amount and date arrays have differing lengths');

        for (uint i=0; i<amounts.length; i++) {

            depositToken(token, amounts[i], dates[i]);

        }

    }



    function depositToken(address token, uint256 amount, uint256 unlock_date) public payable {

        require(unlock_date < 10000000000, 'Enter an unix timestamp in seconds, not miliseconds');

        require(amount > 0, 'Your attempting to trasfer 0 tokens');

        uint256 allowance = IERC20(token).allowance(msg.sender, address(this));

        require(allowance >= amount, 'You need to set a higher allowance');

        // charge a fee

        uint256 fee = calculateFee(amount);

        uint256 amountIn = amount.sub(fee);

        require(IERC20(token).transferFrom(msg.sender, address(this), amountIn), 'Transfer failed');

        require(IERC20(token).transferFrom(msg.sender, address(feeReserveAddress), fee), 'Transfer failed');

        if (!lockedTokenLookup[token]) {

            lockedTokens.push(token);

            lockedTokenLookup[token] = true;

        }

        LiquidityTokenomics storage liquidityTokenomics = tokenEpochMap[token];

        // amount is required to be above 0 in the start of this block, therefore this works

        if (liquidityTokenomics.releaseMap[unlock_date] > 0) {

            liquidityTokenomics.releaseMap[unlock_date] = liquidityTokenomics.releaseMap[unlock_date].add(amountIn);

        } else {

            liquidityTokenomics.epochs.push(unlock_date);

            liquidityTokenomics.releaseMap[unlock_date] = amountIn;

        }

        UserTokenInfo storage uto = tokenUserMap[token][msg.sender];

        uto.deposited = uto.deposited.add(amountIn);

        VestingPeriod[] storage vp = uto.vestingPeriods;

        vp.push(VestingPeriod(unlock_date, amountIn));



        emit onDeposit(token, amount, unlock_date);

    }



    function withdrawToken(address token, uint256 amount) public {

        require(amount > 0, 'Your attempting to withdraw 0 tokens');

        uint256 withdrawable = getWithdrawableBalance(token, msg.sender);

        UserTokenInfo storage uto = tokenUserMap[token][msg.sender];

        uto.withdrawn = uto.withdrawn.add(amount);

        require(amount <= withdrawable, 'Your attempting to withdraw more than you have available');

        require(IERC20(token).transfer(msg.sender, amount), 'Transfer failed');

        emit onWithdraw(token, amount);

    }



    function getWithdrawableBalance(address token, address user) public view returns (uint256) {

        UserTokenInfo storage uto = tokenUserMap[token][address(user)];

        uint arrayLength = uto.vestingPeriods.length;

        uint256 withdrawable = 0;

        for (uint i=0; i<arrayLength; i++) {

            VestingPeriod storage vestingPeriod = uto.vestingPeriods[i];

            if (vestingPeriod.epoch < block.timestamp) {

                withdrawable = withdrawable.add(vestingPeriod.amount);

            }

        }

        withdrawable = withdrawable.sub(uto.withdrawn);

        return withdrawable;

    }



    function getUserTokenInfo (address token, address user) public view returns (uint256, uint256, uint256) {

        UserTokenInfo storage uto = tokenUserMap[address(token)][address(user)];

        uint256 deposited = uto.deposited;

        uint256 withdrawn = uto.withdrawn;

        uint256 length = uto.vestingPeriods.length;

        return (deposited, withdrawn, length);

    }



    function getUserVestingAtIndex (address token, address user, uint index) public view returns (uint256, uint256) {

        UserTokenInfo storage uto = tokenUserMap[address(token)][address(user)];

        VestingPeriod storage vp = uto.vestingPeriods[index];

        return (vp.epoch, vp.amount);

    }



    function getTokenReleaseLength (address token) public view returns (uint256) {

        LiquidityTokenomics storage liquidityTokenomics = tokenEpochMap[address(token)];

        return liquidityTokenomics.epochs.length;

    }



    function getTokenReleaseAtIndex (address token, uint index) public view returns (uint256, uint256) {

        LiquidityTokenomics storage liquidityTokenomics = tokenEpochMap[address(token)];

        uint256 epoch = liquidityTokenomics.epochs[index];

        uint256 amount = liquidityTokenomics.releaseMap[epoch];

        return (epoch, amount);

    }



    function lockedTokensLength() external view returns (uint) {

        return lockedTokens.length;

    }

}

// File: localhost/contracts/uniswapv2/interfaces/IERC20.sol



pragma solidity >=0.5.0;



interface IERC20Uniswap {

    event Approval(address indexed owner, address indexed spender, uint value);

    event Transfer(address indexed from, address indexed to, uint value);



    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

    function totalSupply() external view returns (uint);

    function balanceOf(address owner) external view returns (uint);

    function allowance(address owner, address spender) external view returns (uint);



    function approve(address spender, uint value) external returns (bool);

    function transfer(address to, uint value) external returns (bool);

    function transferFrom(address from, address to, uint value) external returns (bool);

}



// File: localhost/contracts/uniswapv2/interfaces/IWETH.sol



pragma solidity >=0.5.0;



interface IWETH {

    function deposit() external payable;

    function transfer(address to, uint value) external returns (bool);

    function withdraw(uint) external;

}

// File: localhost/contracts/uniswapv2/interfaces/IUniswapV2Pair.sol



pragma solidity >=0.5.0;



interface IUniswapV2Pair {

    event Approval(address indexed owner, address indexed spender, uint value);

    event Transfer(address indexed from, address indexed to, uint value);



    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint);

    function balanceOf(address owner) external view returns (uint);

    function allowance(address owner, address spender) external view returns (uint);



    function approve(address spender, uint value) external returns (bool);

    function transfer(address to, uint value) external returns (bool);

    function transferFrom(address from, address to, uint value) external returns (bool);



    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint);



    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;



    event Mint(address indexed sender, uint amount0, uint amount1);

    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);

    event Swap(

        address indexed sender,

        uint amount0In,

        uint amount1In,

        uint amount0Out,

        uint amount1Out,

        address indexed to

    );

    event Sync(uint112 reserve0, uint112 reserve1);



    function MINIMUM_LIQUIDITY() external pure returns (uint);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);

    function price0CumulativeLast() external view returns (uint);

    function price1CumulativeLast() external view returns (uint);

    function kLast() external view returns (uint);



    function mint(address to) external returns (uint liquidity);

    function burn(address to) external returns (uint amount0, uint amount1);

    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;

    function skim(address to) external;

    function sync() external;



    function initialize(address, address) external;

}

// File: localhost/contracts/uniswapv2/interfaces/IUniswapV2Router01.sol



pragma solidity >=0.6.2;



interface IUniswapV2Router01 {

    function factory() external pure returns (address);

    function WETH() external pure returns (address);



    function addLiquidity(

        address tokenA,

        address tokenB,

        uint amountADesired,

        uint amountBDesired,

        uint amountAMin,

        uint amountBMin,

        address to,

        uint deadline

    ) external returns (uint amountA, uint amountB, uint liquidity);

    function addLiquidityETH(

        address token,

        uint amountTokenDesired,

        uint amountTokenMin,

        uint amountETHMin,

        address to,

        uint deadline

    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);

    function removeLiquidity(

        address tokenA,

        address tokenB,

        uint liquidity,

        uint amountAMin,

        uint amountBMin,

        address to,

        uint deadline

    ) external returns (uint amountA, uint amountB);

    function removeLiquidityETH(

        address token,

        uint liquidity,

        uint amountTokenMin,

        uint amountETHMin,

        address to,

        uint deadline

    ) external returns (uint amountToken, uint amountETH);

    function removeLiquidityWithPermit(

        address tokenA,

        address tokenB,

        uint liquidity,

        uint amountAMin,

        uint amountBMin,

        address to,

        uint deadline,

        bool approveMax, uint8 v, bytes32 r, bytes32 s

    ) external returns (uint amountA, uint amountB);

    function removeLiquidityETHWithPermit(

        address token,

        uint liquidity,

        uint amountTokenMin,

        uint amountETHMin,

        address to,

        uint deadline,

        bool approveMax, uint8 v, bytes32 r, bytes32 s

    ) external returns (uint amountToken, uint amountETH);

    function swapExactTokensForTokens(

        uint amountIn,

        uint amountOutMin,

        address[] calldata path,

        address to,

        uint deadline

    ) external returns (uint[] memory amounts);

    function swapTokensForExactTokens(

        uint amountOut,

        uint amountInMax,

        address[] calldata path,

        address to,

        uint deadline

    ) external returns (uint[] memory amounts);

    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)

        external

        payable

        returns (uint[] memory amounts);

    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)

        external

        returns (uint[] memory amounts);

    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)

        external

        returns (uint[] memory amounts);

    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)

        external

        payable

        returns (uint[] memory amounts);



    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);

    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);

    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);

    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);

    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);

}

// File: localhost/contracts/uniswapv2/interfaces/IUniswapV2Router02.sol



pragma solidity >=0.6.2;





interface IUniswapV2Router02 is IUniswapV2Router01 {

    function removeLiquidityETHSupportingFeeOnTransferTokens(

        address token,

        uint liquidity,

        uint amountTokenMin,

        uint amountETHMin,

        address to,

        uint deadline

    ) external returns (uint amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(

        address token,

        uint liquidity,

        uint amountTokenMin,

        uint amountETHMin,

        address to,

        uint deadline,

        bool approveMax, uint8 v, bytes32 r, bytes32 s

    ) external returns (uint amountETH);



  /*

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(

        uint amountIn,

        uint amountOutMin,

        address[] calldata path,

        address to,

        uint deadline

    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(

        uint amountOutMin,

        address[] calldata path,

        address to,

        uint deadline

    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(

        uint amountIn,

        uint amountOutMin,

        address[] calldata path,

        address to,

        uint deadline

    ) external;

  */

}



// File: localhost/contracts/uniswapv2/interfaces/IUniswapV2Factory.sol



pragma solidity >=0.5.0;



interface IUniswapV2Factory {

    event PairCreated(address indexed token0, address indexed token1, address pair, uint);



    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function migrator() external view returns (address);



    function getPair(address tokenA, address tokenB) external view returns (address pair);

    function allPairs(uint) external view returns (address pair);

    function allPairsLength() external view returns (uint);



    function createPair(address tokenA, address tokenB) external returns (address pair);



    function setFeeTo(address) external;

    function setFeeToSetter(address) external;

    function setMigrator(address) external;

}



// File: @openzeppelin/contracts/math/Math.sol





pragma solidity ^0.6.0;



/**

 * @dev Standard math utilities missing in the Solidity language.

 */

library Math {

    /**

     * @dev Returns the largest of two numbers.

     */

    function max(uint256 a, uint256 b) internal pure returns (uint256) {

        return a >= b ? a : b;

    }



    /**

     * @dev Returns the smallest of two numbers.

     */

    function min(uint256 a, uint256 b) internal pure returns (uint256) {

        return a < b ? a : b;

    }



    /**

     * @dev Returns the average of two numbers. The result is rounded towards

     * zero.

     */

    function average(uint256 a, uint256 b) internal pure returns (uint256) {

        // (a + b) / 2 can overflow, so we distribute

        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);

    }

}



// File: localhost/contracts/SpaceMinePresale.sol





pragma solidity 0.6.12;



























contract SpaceMinePresale is Ownable {

    using SafeMath for uint256;

    using SafeERC20 for IERC20;



    IUniswapV2Router02 private uniswapRouterV2;

    IUniswapV2Factory private uniswapFactory;

    IUniswapV2Pair private pair;

    POLContract private pol;

    address public tokenUniswapPair;



    SpaceMineToken public mine;



    mapping (address => bool) public whitelist;

    mapping (address => uint) public ethSupply;

    address payable devAddress;

    uint public minePrice = 10;

    uint public buyLimit = 4 * 1e18;

    bool public presaleStart = false;

    bool public onlyWhitelist = true;

    uint public presaleLastSupply = 8000 * 1e18;

    uint public initialLiquidityMax = 1600 * 1e18;

    uint256 public contractStartTimestamp;

    uint256 public constant LOCK_PERIOD = 26 weeks;

    bool public LPGenerationCompleted;

    uint256 public totalLPTokensMinted;

    uint256 public totalPresaleContributed;



    address payable constant UNICRYPT_DEPLOYER = 0xcA4664efb56cabB97133A4A4bE44034b8C6033E8;

    address constant UNISWAP_FACTORY = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;

    address constant UNISWAP_ROUTER_V2 = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

    address constant UNICRYPT_POL = 0xDa720baad6e0F08F5c225929e23D29294a4fB12f;



    event BuyMineSuccess(address account, uint ethAmount, uint mineAmount);



    constructor(

        SpaceMineToken _mine

        

    ) public {

        mine = _mine;

        initWhitelist();

        pairSetup();

    }



    function pairSetup() internal {

        uniswapRouterV2 = IUniswapV2Router02(UNISWAP_ROUTER_V2); // For testing

        uniswapFactory = IUniswapV2Factory(UNISWAP_FACTORY); // For testing



        pol = POLContract(payable(UNICRYPT_POL)); // For testing;

        createUniswapPair();

    }



    function createUniswapPair() internal {

        require(tokenUniswapPair == address(0), "Token: pool already created");

        tokenUniswapPair = uniswapFactory.createPair(

            address(uniswapRouterV2.WETH()),

            address(mine)

        );

        pair = IUniswapV2Pair(tokenUniswapPair);

    }



    function addToWhitelist(address account) public onlyOwner {

        require(whitelist[account] == false, "This account is already in whitelist.");

        whitelist[account] = true;

    }



    function removeFromWhitelist(address account) public onlyOwner {

        require(whitelist[account], "This account is not in whitelist.");

        whitelist[account] = false;

    }



    function startPresale() public onlyOwner {

        presaleStart = true;

        contractStartTimestamp = block.timestamp;

        mine.mint(address(this), initialLiquidityMax);

    }



    function stopPresale() public onlyOwner {

        presaleStart = false;

    }



    function setDevAddress(address payable account) public onlyOwner {

        devAddress = account;

    }



    function setMinePrice(uint newPrice) public onlyOwner {

        minePrice = newPrice;

    }



    function setBuyLimit(uint newLimit) public onlyOwner {

        buyLimit = newLimit;

    }



    function changeToNotOnlyWhitelist() public onlyOwner {

        onlyWhitelist = false;

    }



    function checkpresaleLastSupply() public view returns(uint){

        return presaleLastSupply;

    }



    function burnLeftoverMine() public onlyOwner {

        // Only available 24 hours after presale ends (48 hours after presale starts)

        require(contractStartTimestamp.add(2 days) < block.timestamp, "Grace period is not over yet");

        mine.burn(mine.balanceOf(address(this)));

    }



    modifier needHaveLastSupply() {

        require(presaleLastSupply >= 0, "Oh you are too late, all mine are gone");

        _;

    }



    modifier presaleHasStarted() {

        require(presaleStart, "Presale has not been started, buckle up!");

        _;

    }



    receive() payable external presaleHasStarted needHaveLastSupply {

        if (onlyWhitelist) {

            require(whitelist[msg.sender], "Currently only people who are in whitelist can participate");

        }

        uint ethTotalAmount = ethSupply[msg.sender].add(msg.value);

        require(ethTotalAmount <= buyLimit, "Everyone should buy lesser than 4 eth.");

        uint mineAmount = msg.value.mul(minePrice);

        require(mineAmount <= presaleLastSupply, "sorry, insufficient presale supply");

        totalPresaleContributed.add(msg.value);

        presaleLastSupply = presaleLastSupply.sub(mineAmount);

        devAddress.transfer(msg.value.div(2));

        mine.mint(msg.sender, mineAmount);

        ethSupply[msg.sender] = ethTotalAmount;

        emit BuyMineSuccess(msg.sender, msg.value, mineAmount);

    }



    function liquidityGeneration() public {

        require(LPGenerationCompleted == false, "Liquidity generation already finished");

        uint256 initialETHLiquidity = address(this).balance;



        //Wrap eth

        address WETH = uniswapRouterV2.WETH();

        IWETH(WETH).deposit{value : initialETHLiquidity}();

        require(address(this).balance == 0 , "Transfer Failed");

        IWETH(WETH).transfer(address(pair),initialETHLiquidity);



        uint256 initialLiquidity = initialETHLiquidity.mul(4);

        require(initialLiquidity <= initialLiquidityMax, "Error amount");



        mine.transfer(address(pair), initialLiquidity);

        pair.mint(address(this));

        totalLPTokensMinted = pair.balanceOf(address(this));

        require(totalLPTokensMinted != 0 , "LP creation failed");

        LPGenerationCompleted = true;



        uint256 unlockTime = block.timestamp + LOCK_PERIOD;



        IERC20(address(pair)).approve(address(pol), totalLPTokensMinted);

        pol.depositToken(address(pair), totalLPTokensMinted, unlockTime);

        require(pair.balanceOf(address(pol)) != 0, "Auto lock failed");

    }

    

    function withdrawLiquidity() public onlyOwner {

        uint256 withdrawable = pol.getWithdrawableBalance(address(pair), address(this));

        pol.withdrawToken(address(pair), withdrawable);

        pair.transfer(msg.sender, pair.balanceOf(address(this)));

    }



    // Emergency drain in case of a bug in liquidity generation

    // Adds all funds to owner to refund people

    // Only available 24 hours after presale ends (48 hours after presale starts)

    function emergencyDrain() public onlyOwner {

        require(contractStartTimestamp.add(2 days) < block.timestamp, "Grace period is not over yet");

        uint256 initialLiquidity = address(this).balance.mul(4);

        mine.transfer(UNICRYPT_DEPLOYER, initialLiquidity);

        (bool success, ) = UNICRYPT_DEPLOYER.call{value: address(this).balance}("");

        require(success, "Transfer failed.");

    }



    function initWhitelist() internal {

        //add the original whitelist

        whitelist[0x04b936745C02E8Cb75cC68b93B4fb99b38939d5D] = true;



    }

    

    function testMint() public onlyOwner {

        mine.mint(address(this), 1);

    }

    

    function isInWhitelist(address account) public view returns(bool) {

        return whitelist[account];

    }



}

// File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol





pragma solidity ^0.6.0;









/**

 * @title SafeERC20

 * @dev Wrappers around ERC20 operations that throw on failure (when the token

 * contract returns false). Tokens that return no value (and instead revert or

 * throw on failure) are also supported, non-reverting calls are assumed to be

 * successful.

 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,

 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.

 */

library SafeERC20 {

    using SafeMath for uint256;

    using Address for address;



    function safeTransfer(IERC20 token, address to, uint256 value) internal {

        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));

    }



    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {

        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));

    }



    /**

     * @dev Deprecated. This function has issues similar to the ones found in

     * {IERC20-approve}, and its usage is discouraged.

     *

     * Whenever possible, use {safeIncreaseAllowance} and

     * {safeDecreaseAllowance} instead.

     */

    function safeApprove(IERC20 token, address spender, uint256 value) internal {

        // safeApprove should only be called when setting an initial allowance,

        // or when resetting it to zero. To increase and decrease it, use

        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'

        // solhint-disable-next-line max-line-length

        require((value == 0) || (token.allowance(address(this), spender) == 0),

            "SafeERC20: approve from non-zero to non-zero allowance"

        );

        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));

    }



    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {

        uint256 newAllowance = token.allowance(address(this), spender).add(value);

        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));

    }



    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {

        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");

        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));

    }



    /**

     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement

     * on the return value: the return value is optional (but if data is returned, it must not be false).

     * @param token The token targeted by the call.

     * @param data The call data (encoded using abi.encode or one of its variants).

     */

    function _callOptionalReturn(IERC20 token, bytes memory data) private {

        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since

        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that

        // the target address contains contract code and also asserts for success in the low-level call.



        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional

            // solhint-disable-next-line max-line-length

            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");

        }

    }

}



// File: @openzeppelin/contracts/utils/Address.sol





pragma solidity ^0.6.2;



/**

 * @dev Collection of functions related to the address type

 */

library Address {

    /**

     * @dev Returns true if `account` is a contract.

     *

     * [IMPORTANT]

     * ====

     * It is unsafe to assume that an address for which this function returns

     * false is an externally-owned account (EOA) and not a contract.

     *

     * Among others, `isContract` will return false for the following

     * types of addresses:

     *

     *  - an externally-owned account

     *  - a contract in construction

     *  - an address where a contract will be created

     *  - an address where a contract lived, but was destroyed

     * ====

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



    /**

     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to

     * `recipient`, forwarding all available gas and reverting on errors.

     *

     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost

     * of certain opcodes, possibly making contracts go over the 2300 gas limit

     * imposed by `transfer`, making them unable to receive funds via

     * `transfer`. {sendValue} removes this limitation.

     *

     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].

     *

     * IMPORTANT: because control is transferred to `recipient`, care must be

     * taken to not create reentrancy vulnerabilities. Consider using

     * {ReentrancyGuard} or the

     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].

     */

    function sendValue(address payable recipient, uint256 amount) internal {

        require(address(this).balance >= amount, "Address: insufficient balance");



        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value

        (bool success, ) = recipient.call{ value: amount }("");

        require(success, "Address: unable to send value, recipient may have reverted");

    }



    /**

     * @dev Performs a Solidity function call using a low level `call`. A

     * plain`call` is an unsafe replacement for a function call: use this

     * function instead.

     *

     * If `target` reverts with a revert reason, it is bubbled up by this

     * function (like regular Solidity function calls).

     *

     * Returns the raw returned data. To convert to the expected return value,

     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].

     *

     * Requirements:

     *

     * - `target` must be a contract.

     * - calling `target` with `data` must not revert.

     *

     * _Available since v3.1._

     */

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {

      return functionCall(target, data, "Address: low-level call failed");

    }



    /**

     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with

     * `errorMessage` as a fallback revert reason when `target` reverts.

     *

     * _Available since v3.1._

     */

    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {

        return _functionCallWithValue(target, data, 0, errorMessage);

    }



    /**

     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],

     * but also transferring `value` wei to `target`.

     *

     * Requirements:

     *

     * - the calling contract must have an ETH balance of at least `value`.

     * - the called Solidity function must be `payable`.

     *

     * _Available since v3.1._

     */

    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {

        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");

    }



    /**

     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but

     * with `errorMessage` as a fallback revert reason when `target` reverts.

     *

     * _Available since v3.1._

     */

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {

        require(address(this).balance >= value, "Address: insufficient balance for call");

        return _functionCallWithValue(target, data, value, errorMessage);

    }



    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {

        require(isContract(target), "Address: call to non-contract");



        // solhint-disable-next-line avoid-low-level-calls

        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);

        if (success) {

            return returndata;

        } else {

            // Look for revert reason and bubble it up if present

            if (returndata.length > 0) {

                // The easiest way to bubble the revert reason is using memory via assembly



                // solhint-disable-next-line no-inline-assembly

                assembly {

                    let returndata_size := mload(returndata)

                    revert(add(32, returndata), returndata_size)

                }

            } else {

                revert(errorMessage);

            }

        }

    }

}



// File: @openzeppelin/contracts/math/SafeMath.sol





pragma solidity ^0.6.0;



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

     *

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

     *

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

     *

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

     *

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

     *

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

     *

     * - The divisor cannot be zero.

     */

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

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

     *

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

     *

     * - The divisor cannot be zero.

     */

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b != 0, errorMessage);

        return a % b;

    }

}







// File: localhost/contracts/SpaceMineToken.sol





pragma solidity 0.6.12;











contract SpaceMineCore is ERC20("SpaceMine Token V2", "MINEV2"), Ownable {

    using SafeMath for uint256;



    address internal _taxer;

    address internal _taxDestination;

  uint256 internal _cap;

    uint internal _taxRate = 0;

    bool internal _lock = true;

    mapping (address => bool) internal _taxWhitelist;



    function transfer(address recipient, uint256 amount) public override returns (bool) {

        require(msg.sender == owner() || !_lock, "Transfer is locking");



        uint256 taxAmount = amount.mul(_taxRate).div(100);

        if (_taxWhitelist[msg.sender] == true) {

            taxAmount = 0;

        }

        uint256 transferAmount = amount.sub(taxAmount);

        require(balanceOf(msg.sender) >= amount, "insufficient balance.");

        super.transfer(recipient, transferAmount);



        if (taxAmount != 0) {

            super.transfer(_taxDestination, taxAmount);

        }

        return true;

    }



    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {

        require(sender == owner() || !_lock, "TransferFrom is locking");



        uint256 taxAmount = amount.mul(_taxRate).div(100);

        if (_taxWhitelist[sender] == true) {

            taxAmount = 0;

        }

        uint256 transferAmount = amount.sub(taxAmount);

        require(balanceOf(sender) >= amount, "insufficient balance.");

        super.transferFrom(sender, recipient, transferAmount);

        if (taxAmount != 0) {

            super.transferFrom(sender, _taxDestination, taxAmount);

        }

        return true;

    }



  function _mint(address account, uint256 value) override internal {

        require(totalSupply().add(value) <= _cap, "cap exceeded");

        super._mint(account, value);

    }

}



contract SpaceMineToken is SpaceMineCore {

    mapping (address => bool) public minters;



  uint256 public constant hard_cap = 96000 * 1e18;



    constructor() public {

        _taxer = owner();

        _taxDestination = owner();

    _cap = hard_cap;

    }



  function cap() public view returns (uint256) {

        return _cap;

    }



    function mint(address to, uint amount) public onlyMinter {

        _mint(to, amount);

    _moveDelegates(address(0), _delegates[to], amount);

    }



  /// @notice A record of each accounts delegate

  mapping (address => address) public _delegates;

  /// @notice A checkpoint for marking number of votes from a given block

    struct Checkpoint {

        uint32 fromBlock;

        uint256 votes;

    }



    /// @notice A record of votes checkpoints for each account, by index

    mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;



    /// @notice The number of checkpoints for each account

    mapping (address => uint32) public numCheckpoints;



    /// @notice The EIP-712 typehash for the contract's domain

    bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");



    /// @notice The EIP-712 typehash for the delegation struct used by the contract

    bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");



    /// @notice A record of states for signing / validating signatures

    mapping (address => uint) public nonces;



      /// @notice An event thats emitted when an account changes its delegate

    event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);



    /// @notice An event thats emitted when a delegate account's vote balance changes

    event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);



    /**

     * @notice Delegate votes from `msg.sender` to `delegatee`

     * @param delegator The address to get delegatee for

     */

    function delegates(address delegator)

        external

        view

        returns (address)

    {

        return _delegates[delegator];

    }



   /**

    * @notice Delegate votes from `msg.sender` to `delegatee`

    * @param delegatee The address to delegate votes to

    */

    function delegate(address delegatee) external {

        return _delegate(msg.sender, delegatee);

    }



    /**

     * @notice Delegates votes from signatory to `delegatee`

     * @param delegatee The address to delegate votes to

     * @param nonce The contract state required to match the signature

     * @param expiry The time at which to expire the signature

     * @param v The recovery byte of the signature

     * @param r Half of the ECDSA signature pair

     * @param s Half of the ECDSA signature pair

     */

    function delegateBySig(

        address delegatee,

        uint nonce,

        uint expiry,

        uint8 v,

        bytes32 r,

        bytes32 s

    )

        external

    {

        bytes32 domainSeparator = keccak256(

            abi.encode(

                DOMAIN_TYPEHASH,

                keccak256(bytes(name())),

                getChainId(),

                address(this)

            )

        );



        bytes32 structHash = keccak256(

            abi.encode(

                DELEGATION_TYPEHASH,

                delegatee,

                nonce,

                expiry

            )

        );



        bytes32 digest = keccak256(

            abi.encodePacked(

                "\\x19\\x01",

                domainSeparator,

                structHash

            )

        );



        address signatory = ecrecover(digest, v, r, s);

        require(signatory != address(0), "MINE:delegateBySig: invalid signature");

        require(nonce == nonces[signatory]++, "MINE::delegateBySig: invalid nonce");

        require(block.timestamp <= expiry, "MINE::delegateBySig: signature expired");

        return _delegate(signatory, delegatee);

    }



    /**

     * @notice Gets the current votes balance for `account`

     * @param account The address to get votes balance

     * @return The number of current votes for `account`

     */

    function getCurrentVotes(address account)

        external

        view

        returns (uint256)

    {

        uint32 nCheckpoints = numCheckpoints[account];

        return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;

    }



    /**

     * @notice Determine the prior number of votes for an account as of a block number

     * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.

     * @param account The address of the account to check

     * @param blockNumber The block number to get the vote balance at

     * @return The number of votes the account had as of the given block

     */

    function getPriorVotes(address account, uint blockNumber)

        external

        view

        returns (uint256)

    {

        require(blockNumber < block.number, "MINE::getPriorVotes: not yet determined");



        uint32 nCheckpoints = numCheckpoints[account];

        if (nCheckpoints == 0) {

            return 0;

        }



        // First check most recent balance

        if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {

            return checkpoints[account][nCheckpoints - 1].votes;

        }



        // Next check implicit zero balance

        if (checkpoints[account][0].fromBlock > blockNumber) {

            return 0;

        }



        uint32 lower = 0;

        uint32 upper = nCheckpoints - 1;

        while (upper > lower) {

            uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow

            Checkpoint memory cp = checkpoints[account][center];

            if (cp.fromBlock == blockNumber) {

                return cp.votes;

            } else if (cp.fromBlock < blockNumber) {

                lower = center;

            } else {

                upper = center - 1;

            }

        }

        return checkpoints[account][lower].votes;

    }



    function _delegate(address delegator, address delegatee)

        internal

    {

        address currentDelegate = _delegates[delegator];

        uint256 delegatorBalance = balanceOf(delegator); // balance of underlying MINE;

        _delegates[delegator] = delegatee;



        emit DelegateChanged(delegator, currentDelegate, delegatee);



        _moveDelegates(currentDelegate, delegatee, delegatorBalance);

    }



    function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {

        if (srcRep != dstRep && amount > 0) {

            if (srcRep != address(0)) {

                // decrease old representative

                uint32 srcRepNum = numCheckpoints[srcRep];

                uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;

                uint256 srcRepNew = srcRepOld-amount;

                _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);

            }



            if (dstRep != address(0)) {

                // increase new representative

                uint32 dstRepNum = numCheckpoints[dstRep];

                uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;

                uint256 dstRepNew = dstRepOld+amount;

                _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);

            }

        }

    }



    function _writeCheckpoint(

        address delegatee,

        uint32 nCheckpoints,

        uint256 oldVotes,

        uint256 newVotes

    )

        internal

    {

        uint32 blockNumber = safe32(block.number, "MINE::_writeCheckpoint: block number exceeds 32 bits");



        if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {

            checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;

        } else {

            checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);

            numCheckpoints[delegatee] = nCheckpoints + 1;

        }



        emit DelegateVotesChanged(delegatee, oldVotes, newVotes);

    }



    function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {

        require(n < 2**32, errorMessage);

        return uint32(n);

    }



    function getChainId() internal pure returns (uint) {

        uint256 chainId;

        assembly { chainId := chainid() }

        return chainId;

    }



    function burn(uint amount) public {

        require(amount > 0);

        require(balanceOf(msg.sender) >= amount);

        _burn(msg.sender, amount);

    }



    function addMinter(address account) public onlyOwner {

        minters[account] = true;

    }



    function removeMinter(address account) public onlyOwner {

        minters[account] = false;

    }



    modifier onlyMinter() {

        require(minters[msg.sender], "Restricted to minters.");

        _;

    }



    modifier onlyTaxer() {

        require(msg.sender == _taxer, "Only for taxer.");

        _;

    }



    function setTaxer(address account) public onlyTaxer {

        _taxer = account;

    }



    function setTaxRate(uint256 rate) public onlyTaxer {

        _taxRate = rate;

    }



    function setTaxDestination(address account) public onlyTaxer {

        _taxDestination = account;

    }



    function addToWhitelist(address account) public onlyTaxer {

        _taxWhitelist[account] = true;

    }



    function removeFromWhitelist(address account) public onlyTaxer {

        _taxWhitelist[account] = false;

    }



    function taxer() public view returns(address) {

        return _taxer;

    }



    function taxDestination() public view returns(address) {

        return _taxDestination;

    }



    function taxRate() public view returns(uint256) {

        return _taxRate;

    }



    function isInWhitelist(address account) public view returns(bool) {

        return _taxWhitelist[account];

    }



    function unlock() public onlyOwner {

        _lock = false;

    }



    function getLockStatus() view public returns(bool) {

        return _lock;

    }

}







// File: localhost/contracts/LaunchContract.sol



// SPDX-License-Identifier: MIT



pragma solidity 0.6.12;













contract LaunchContract is Ownable {

    SpaceMineToken private mine = SpaceMineToken(0x8356806910eE22cFc0c45D2f5fC32c18016D8423);

    SpaceMinePresale private presale = SpaceMinePresale(0xd8186d1C1Ab9F637DBb0216fA384A1A816889105);

    address[] internal miningContracts;

    

    constructor() public {

        miningContracts.push(0x2D001B4D426cC46B6392ab10D05ef15E1AC6D504);

        miningContracts.push(0x4355D4eB6114876E503CEB5d6b71585779Ec77a5);

        miningContracts.push(0xBF969FfAc87b913471d06e881666e4bD81D3dBF1);

        miningContracts.push(0xFA9B426bF8726Df7F6C5c3D56B9835fA4baA4d57);

        miningContracts.push(0x79dA0f25c6F12428643b0d1a91FdA0B28408C7ea);

        miningContracts.push(0x33625FBCE2286C3920bA85e97F398a5DA4b61b2D);

        miningContracts.push(0x69f1CC95d4a815799cFd758F66F8b83c1bFc8339);

        miningContracts.push(0x07864c8107c1A93CD9a42080CdB264E5516a0405);

    }

    



    function liquidityLaunch() public onlyOwner {

        mine.unlock();

        presale.liquidityGeneration();

    }

    

    function startFarming() public onlyOwner {

        for (uint i=0; i<miningContracts.length; i++) {

            addMinter(miningContracts[i]);

        }

    }

    

    function setOwner(address account) public onlyOwner {

        mine.transferOwnership(account);

    }

    

    function addMinter(address account) public onlyOwner {

        mine.addMinter(account);

    }



    function removeMinter(address account) public onlyOwner {

        mine.addMinter(account);

    }

}

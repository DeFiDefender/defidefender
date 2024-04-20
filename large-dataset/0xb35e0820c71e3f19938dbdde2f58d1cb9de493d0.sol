// File: browser/IUnipumpContest.sol



pragma solidity ^0.7.0;





interface IUnipumpContest

{

}

// File: browser/IUnipumpStaking.sol







interface IUnipumpDrain

{

    function drain(address token) external;

}

// File: browser/IUnipumpEscrow.sol











interface IUnipumpEscrow is IUnipumpDrain

{

    function start() external;

    function available() external view returns (uint256);

}







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



// File: browser/UnipumpDrain.sol











interface IUnipumpStaking

{

    event Stake(address indexed _staker, uint256 _amount, uint256 _epochCount);

    event Reward(address indexed _staker, uint256 _reward);

    event RewardPotIncrease(uint256 _amount);



    function stakingRewardPot() external view returns (uint256);

    function currentEpoch() external view returns (uint256);

    function nextEpochTimestamp() external view returns (uint256);

    function isActivated() external view returns (bool);

    function secondsUntilCanActivate() external view returns (uint256);

    function totalStaked() external view returns (uint256);

    

    function increaseRewardsPot() external;

    function activate() external;

    function claimRewardsAt(uint256 index) external;

    function claimRewards() external;

    function updateEpoch() external returns (bool);

    function stakeForProfit(uint256 epochCount) external;

}

// File: browser/IUnipumpTradingGroup.sol













interface IUnipumpTradingGroup

{

    function leader() external view returns (address);

    function close() external;

    function closeWithNonzeroTokenBalances() external;

    function anyNonzeroTokenBalances() external view returns (bool);

    function tokenList() external view returns (IUnipumpTokenList);

    function maxSecondsRemaining() external view returns (uint256);

    function group() external view returns (IUnipumpGroup);

    function externalBalanceChanges(address token) external view returns (bool);



    function startTime() external view returns (uint256);

    function endTime() external view returns (uint256);

    function maxEndTime() external view returns (uint256);



    function startingWethBalance() external view returns (uint256);

    function finalWethBalance() external view returns (uint256);

    function leaderWethProfitPayout() external view returns (uint256);



    function swapExactTokensForTokens(

        uint256 amountIn,

        uint256 amountOutMin,

        address[] calldata path,

        uint256 deadline

    ) 

        external 

        returns (uint256[] memory amounts);



    function swapTokensForExactTokens(

        uint256 amountOut,

        uint256 amountInMax,

        address[] calldata path,

        uint256 deadline

    ) 

        external 

        returns (uint256[] memory amounts);

        

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(

        uint256 amountIn,

        uint256 amountOutMin,

        address[] calldata path,

        uint256 deadline

    ) 

        external;



    function withdraw(address token) external;

}

// File: browser/IUnipumpTokenList.sol









interface IUnipumpTokenList

{

    function parentList() external view returns (IUnipumpTokenList);

    function isLocked() external view returns (bool);

    function tokens(uint256 index) external view returns (address);

    function exists(address token) external view returns (bool);

    function tokenCount() external view returns (uint256);



    function lock() external;

    function add(address token) external;

    function addMany(address[] calldata _tokens) external;

    function remove(address token) external;    

}

// File: browser/IUnipumpGroup.sol













interface IUnipumpGroup 

{

    function contribute() external payable;

    function abort() external;

    function startPumping() external;

    function isActive() external view returns (bool);

    function withdraw() external;

    function leader() external view returns (address);

    function tokenList() external view returns (IUnipumpTokenList);

    function leaderUppCollateral() external view returns (uint256);

    function requiredMemberUppFee() external view returns (uint256);

    function minEthToJoin() external view returns (uint256);

    function minEthToStart() external view returns (uint256);

    function maxEthAcceptable() external view returns (uint256);

    function maxRunTimeSeconds() external view returns (uint256);

    function leaderProfitShareOutOf10000() external view returns (uint256);

    function memberCount() external view returns (uint256);

    function members(uint256 at) external view returns (address);

    function contributions(address member) external view returns (uint256);

    function totalContributions() external view returns (uint256);

    function aborted() external view returns (bool);

    function tradingGroup() external view returns (IUnipumpTradingGroup);

}

// File: browser/IUnipumpGroupFactory.sol













interface IUnipumpGroupFactory 

{

    function createGroup(

        address leader,

        IUnipumpTokenList unipumpTokenList,

        uint256 uppCollateral,

        uint256 requiredMemberUppFee,

        uint256 minEthToJoin,

        uint256 minEthToStart,

        uint256 startTimeout,

        uint256 maxEthAcceptable,

        uint256 maxRunTimeSeconds,

        uint256 leaderProfitShareOutOf10000

    ) 

        external

        returns (IUnipumpGroup unipumpGroup);

}

// File: browser/IUnipumpGroupManager.sol















interface IUnipumpGroupManager

{

    function groupLeaders(uint256 at) external view returns (address);

    function groupLeaderCount() external view returns (uint256);

    function groups(uint256 at) external view returns (IUnipumpGroup);

    function groupCount() external view returns (uint256);

    function groupCountByLeader(address leader) external view returns (uint256);

    function groupsByLeader(address leader, uint256 at) external view returns (IUnipumpGroup);



    function createGroup(

        IUnipumpTokenList tokenList,

        uint256 uppCollateral,

        uint256 requiredMemberUppFee,

        uint256 minEthToJoin,

        uint256 minEthToStart,

        uint256 startTimeout,

        uint256 maxEthAcceptable,

        uint256 maxRunTimeSeconds,

        uint256 leaderProfitShareOutOf10000

    ) 

        external

        returns (IUnipumpGroup group);

}

// File: browser/IUnipump.sol





















interface IUnipump is IERC20 {

    event Sale(bool indexed _saleActive);

    event LiquidityCrisis();



    function WETH() external view returns (address);

    

    function groupManager() external view returns (IUnipumpGroupManager);

    function escrow() external view returns (IUnipumpEscrow);

    function staking() external view returns (IUnipumpStaking);

    function contest() external view returns (IUnipumpContest);



    function init(

        IUnipumpEscrow _escrow,

        IUnipumpStaking _staking) external;

    function startUnipumpSale(uint256 _tokensPerEth, uint256 _maxSoldEth) external;

    function start(

        IUnipumpGroupManager _groupManager,

        IUnipumpContest _contest) external;



    function isSaleActive() external view returns (bool);

    function tokensPerEth() external view returns (uint256);

    function maxSoldEth() external view returns (uint256);

    function soldEth() external view returns (uint256);

    

    function buy() external payable;

    

    function minSecondsUntilLiquidityCrisis() external view returns (uint256);

    function createLiquidityCrisis() external payable;

}

// File: browser/openzeppelin/IERC20.sol











abstract contract UnipumpDrain is IUnipumpDrain

{

    address payable immutable drainTarget;



    constructor()

    {

        drainTarget = msg.sender;

    }



    function drain(address token)

        public

        override

    {

        uint256 amount;

        if (token == address(0))

        {

            require (address(this).balance > 0, "Nothing to send");

            amount = _drainAmount(token, address(this).balance);

            require (amount > 0, "Nothing allowed to send");

            (bool success,) = drainTarget.call{ value: amount }("");

            require (success, "Transfer failed");

            return;

        }

        amount = IERC20(token).balanceOf(address(this));

        require (amount > 0, "Nothing to send");

        amount = _drainAmount(token, amount);

        require (amount > 0, "Nothing allowed to send");

        require (IERC20(token).transfer(drainTarget, amount), "Transfer failed");

    }



    function _drainAmount(address token, uint256 available) internal virtual returns (uint256 amount);

}

// File: browser/IUnipumpDrain.sol







// File: browser/UnipumpEscrow.sol















contract UnipumpEscrow is IUnipumpEscrow, UnipumpDrain

{

    IUnipump immutable unipump;



    uint256 lastWithdrawalTime;

    uint256 maxWithdrawalPerSecond;

    

    constructor(

        IUnipump _unipump

    ) 

    {

        require (address(_unipump) != address(0));

        unipump = _unipump;

    }



    receive()

        external

        payable

    {

    }



    function start() 

        public 

        override

    {

        require (msg.sender == address(unipump));

        lastWithdrawalTime = block.timestamp;

        maxWithdrawalPerSecond = unipump.balanceOf(address(this)) / 8640000; // 1% per day

    }



    function available()

        public

        view

        override

        returns (uint256)

    {     

        uint256 last = lastWithdrawalTime;

        if (last == 0) { return 0; }        

        uint256 amount = unipump.balanceOf(address(this));

        uint256 avail = (block.timestamp - last) * maxWithdrawalPerSecond;

        return amount > avail ? avail : amount;        

    }



    function _drainAmount(

        address token, 

        uint256 _available

    ) 

        internal 

        override

        returns (uint256 amount)

    {

        amount = _available;

        if (token == address(unipump)) {

            uint256 last = lastWithdrawalTime;

            require (last > 0);

            amount = (block.timestamp - last) * maxWithdrawalPerSecond;

            lastWithdrawalTime = block.timestamp;

            if (amount > _available) { amount = _available; }

        }

    }

}

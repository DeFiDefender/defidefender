// SPDX-License-Identifier: MIT

pragma solidity 0.5.12;



contract DSAuthority {

    function canCall(

        address src,

        address dst,

        bytes4 sig

    ) public view returns (bool);

}



contract DSAuthEvents {

    event LogSetAuthority(address indexed authority);

    event LogSetOwner(address indexed owner);

    event OwnerUpdate(address indexed owner, address indexed newOwner);

}



contract DSAuth is DSAuthEvents {

    DSAuthority public authority;

    address public owner;

    address public newOwner;



    constructor() public {

        owner = msg.sender;

        emit LogSetOwner(msg.sender);

    }



    // Warning: you should absolutely sure you want to give up authority!!!

    function disableOwnership() public onlyOwner {

        owner = address(0);

        emit OwnerUpdate(msg.sender, owner);

    }



    function transferOwnership(address newOwner_) public onlyOwner {

        require(newOwner_ != owner, "TransferOwnership: the same owner.");

        newOwner = newOwner_;

    }



    function acceptOwnership() public {

        require(

            msg.sender == newOwner,

            "AcceptOwnership: only new owner do this."

        );

        emit OwnerUpdate(owner, newOwner);

        owner = newOwner;

        newOwner = address(0x0);

    }



    ///[snow] guard is Authority who inherit DSAuth.

    function setAuthority(DSAuthority authority_) public onlyOwner {

        authority = authority_;

        emit LogSetAuthority(address(authority));

    }



    modifier onlyOwner {

        require(isOwner(msg.sender), "ds-auth-non-owner");

        _;

    }



    function isOwner(address src) internal view returns (bool) {

        return bool(src == owner);

    }



    modifier auth {

        require(isAuthorized(msg.sender, msg.sig), "ds-auth-unauthorized");

        _;

    }



    function isAuthorized(address src, bytes4 sig)

        internal

        view

        returns (bool)

    {

        if (src == address(this)) {

            return true;

        } else if (src == owner) {

            return true;

        } else if (authority == DSAuthority(0)) {

            return false;

        } else {

            return authority.canCall(src, address(this), sig);

        }

    }

}



/**

 * @dev Contract module which allows children to implement an emergency stop

 * mechanism that can be triggered by owner account.

 *

 * This module is used through inheritance. It will make available the

 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to

 * the functions of your contract. Note that they will not be pausable by

 * simply including this module, only once the modifiers are put in place.

 */

contract Pausable is DSAuth {

    bool public paused;



    /**

     * @dev Emitted when the pause is triggered by a pauser (`account`).

     */

    event Paused(address account);



    /**

     * @dev Emitted when the pause is lifted by a pauser (`account`).

     */

    event Unpaused(address account);



    /**

     * @dev Modifier to make a function callable only when the contract is not paused.

     */

    modifier whenNotPaused() {

        require(!paused, "whenNotPaused: paused");

        _;

    }



    /**

     * @dev Modifier to make a function callable only when the contract is paused.

     */

    modifier whenPaused() {

        require(paused, "whenPaused: not paused");

        _;

    }



    /**

     * @dev Initializes the contract in unpaused state. Assigns the Pauser role

     * to the deployer.

     */

    constructor() internal {

        paused = false;

    }



    /**

     * @dev Called by the contract owner to pause, triggers stopped state.

     */

    function pause() public whenNotPaused auth {

        paused = true;

        emit Paused(owner);

    }



    /**

     * @dev Called by the contract owner to unpause, returns to normal state.

     */

    function unpause() public whenPaused auth {

        paused = false;

        emit Unpaused(owner);

    }

}



/**

 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include

 * the optional functions; to access them see {ERC20Detailed}.

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

     * Emits a {Transfer} event.

     */

    function transfer(address recipient, uint256 amount) external;



    /**

     * @dev Returns the remaining number of tokens that `spender` will be

     * allowed to spend on behalf of `owner` through {transferFrom}. This is

     * zero by default.

     *

     * This value changes when {approve} or {transferFrom} are called.

     */

    function allowance(address owner, address spender)

        external

        view

        returns (uint256);



    /**

     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.

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

    function approve(address spender, uint256 amount) external;



    /**

     * @dev Moves `amount` tokens from `sender` to `recipient` using the

     * allowance mechanism. `amount` is then deducted from the caller's

     * allowance.

     *

     * Emits a {Transfer} event.

     */

    function transferFrom(

        address sender,

        address recipient,

        uint256 amount

    ) external;



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

    event Approval(

        address indexed owner,

        address indexed spender,

        uint256 value

    );



    // This function is not a standard ERC20 interface, just for compitable with market.

    function decimals() external view returns (uint8);

}



contract ERC20SafeTransfer {

    function doTransferOut(

        address _token,

        address _to,

        uint256 _amount

    ) internal returns (bool) {

        IERC20 token = IERC20(_token);

        bool result;



        token.transfer(_to, _amount);



        assembly {

            switch returndatasize()

                case 0 {

                    result := not(0)

                }

                case 32 {

                    returndatacopy(0, 0, 32)

                    result := mload(0)

                }

                default {

                    revert(0, 0)

                }

        }

        return result;

    }



    function doTransferFrom(

        address _token,

        address _from,

        address _to,

        uint256 _amount

    ) internal returns (bool) {

        IERC20 token = IERC20(_token);

        bool result;



        token.transferFrom(_from, _to, _amount);



        assembly {

            switch returndatasize()

                case 0 {

                    result := not(0)

                }

                case 32 {

                    returndatacopy(0, 0, 32)

                    result := mload(0)

                }

                default {

                    revert(0, 0)

                }

        }

        return result;

    }



    function doApprove(

        address _token,

        address _to,

        uint256 _amount

    ) internal returns (bool) {

        IERC20 token = IERC20(_token);

        bool result;



        token.approve(_to, _amount);



        assembly {

            switch returndatasize()

                case 0 {

                    result := not(0)

                }

                case 32 {

                    returndatacopy(0, 0, 32)

                    result := mload(0)

                }

                default {

                    revert(0, 0)

                }

        }

        return result;

    }

}



library SafeMath {

    function add(uint256 x, uint256 y) internal pure returns (uint256 z) {

        require((z = x + y) >= x, "ds-math-add-overflow");

    }



    function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {

        require((z = x - y) <= x, "ds-math-sub-underflow");

    }



    function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {

        require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");

    }



    function div(uint256 x, uint256 y) internal pure returns (uint256 z) {

        require(y > 0, "ds-math-div-overflow");

        z = x / y;

    }

}



interface IDTokenController {

    function getDToken(address _token) external view returns (address);

}



contract Handler is ERC20SafeTransfer, Pausable {

    using SafeMath for uint256;

    bool private initialized; // Flags for initializing data

    address public dTokenController; // dToken mapping contract



    mapping(address => bool) private tokensEnable; // Supports token or not



    event NewdTokenAddresses(

        address indexed originalDToken,

        address indexed newDToken

    );

    event DisableToken(address indexed underlyingToken);

    event EnableToken(address indexed underlyingToken);



    // --- Init ---

    // This function is used with contract proxy, do not modify this function.

    function initialize(address _dTokenController) public {

        require(!initialized, "initialize: Already initialized!");

        owner = msg.sender;

        dTokenController = _dTokenController;

        initialized = true;

    }



    /**

     * @dev Update dToken mapping contract.

     * @param _newDTokenController The new dToken mapping contact.

     */

    function setDTokenController(address _newDTokenController) external auth {

        require(

            _newDTokenController != dTokenController,

            "setDTokenController: The same dToken mapping contract address!"

        );

        address _originalDTokenController = dTokenController;

        dTokenController = _newDTokenController;

        emit NewdTokenAddresses(

            _originalDTokenController,

            _newDTokenController

        );

    }



    /**

     * @dev Authorized function to disable some underlying tokens.

     * @param _underlyingTokens Tokens to disable.

     */

    function disableTokens(address[] calldata _underlyingTokens) external auth {

        for (uint256 i = 0; i < _underlyingTokens.length; i++) {

            _disableToken(_underlyingTokens[i]);

        }

    }



    /**

     * @dev Authorized function to enable some underlying tokens.

     * @param _underlyingTokens Tokens to enable.

     */

    function enableTokens(address[] calldata _underlyingTokens) external auth {

        for (uint256 i = 0; i < _underlyingTokens.length; i++) {

            _enableToken(_underlyingTokens[i]);

        }

    }



    function _disableToken(address _underlyingToken) internal {

        require(

            tokensEnable[_underlyingToken],

            "disableToken: Has been disabled!"

        );

        tokensEnable[_underlyingToken] = false;

        emit DisableToken(_underlyingToken);

    }



    function _enableToken(address _underlyingToken) internal {

        require(

            !tokensEnable[_underlyingToken],

            "enableToken: Has been enabled!"

        );

        tokensEnable[_underlyingToken] = true;

        emit EnableToken(_underlyingToken);

    }



    /**

     * @dev The _underlyingToken approves to dToken contract.

     * @param _underlyingToken Token address to approve.

     */

    function approve(address _underlyingToken, uint256 amount) public auth {

        address _dToken = IDTokenController(dTokenController).getDToken(

            _underlyingToken

        );



        require(

            doApprove(_underlyingToken, _dToken, amount),

            "approve: Approve dToken failed!"

        );

    }



    /**

     * @dev Support token or not.

     * @param _underlyingToken Token to check.

     */

    function tokenIsEnabled(address _underlyingToken)

        public

        view

        returns (bool)

    {

        return tokensEnable[_underlyingToken];

    }

}







interface IUSR {

    // bool true:success, otherwise a failure (see ErrorReporter.sol for details)

    function mint(address account, uint256 mintAmount) external returns (bool);



    // bool true:success, otherwise a failure (see ErrorReporter.sol for details)

    function redeemUnderlying(address account, uint256 underlyingAmount)

        external

        returns (bool);



    function redeem(address account, uint256 amount) external returns (bool);



    function balanceOfUnderlying(address owner) external returns (uint256);



    function underlyingToken() external view returns (address);

}



/**

 * @dev Contract module that helps prevent reentrant calls to a function.

 *

 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier

 * available, which can be applied to functions to make sure there are no nested

 * (reentrant) calls to them.

 *

 * Note that because there is a single `nonReentrant` guard, functions marked as

 * `nonReentrant` may not call one another. This can be worked around by making

 * those functions `private`, and then adding `external` `nonReentrant` entry

 * points to them.

 *

 * TIP: If you would like to learn more about reentrancy and alternative ways

 * to protect against it, check out our blog post

 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].

 */

contract ReentrancyGuard {

    // Booleans are more expensive than uint256 or any type that takes up a full

    // word because each write operation emits an extra SLOAD to first read the

    // slot's contents, replace the bits taken up by the boolean, and then write

    // back. This is the compiler's defense against contract upgrades and

    // pointer aliasing, and it cannot be disabled.



    // The values being non-zero value makes deployment a bit more expensive,

    // but in exchange the refund on every call to nonReentrant will be lower in

    // amount. Since refunds are capped to a percentage of the total

    // transaction's gas, it is best to keep them low in cases like this one, to

    // increase the likelihood of the full refund coming into effect.

    uint256 private constant _NOT_ENTERED = 1;

    uint256 private constant _ENTERED = 2;



    uint256 private _status;



    constructor() internal {

        _status = _NOT_ENTERED;

    }



    /**

     * @dev Prevents a contract from calling itself, directly or indirectly.

     * Calling a `nonReentrant` function from another `nonReentrant`

     * function is not supported. It is possible to prevent this from happening

     * by making the `nonReentrant` function external, and make it call a

     * `private` function that does the actual work.

     */

    modifier nonReentrant() {

        // On the first call to nonReentrant, _notEntered will be true

        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");



        // Any calls to nonReentrant after this point will fail

        _status = _ENTERED;



        _;



        // By storing the original value once again, a refund is triggered (see

        // https://eips.ethereum.org/EIPS/eip-2200)

        _status = _NOT_ENTERED;

    }



    function initReentrancyStatus() internal {

        _status = _NOT_ENTERED;

    }

}



contract USRHandler is Handler, ReentrancyGuard {

    address public USR;



    struct InterestDetails {

        uint256 totalUnderlyingBalance; // Total underlying balance including interest

        uint256 interest; // Total interest

    }

    // Based on underlying token, get current interest details

    mapping(address => InterestDetails) public interestDetails;



    constructor(address _dTokenController, address _USR) public {

        initialize(_dTokenController, _USR);

    }



    // --- Init ---

    // This function is used with contract proxy, do not modify this function.

    function initialize(address _dTokenController, address _USR) public {

        super.initialize(_dTokenController);

        initReentrancyStatus();

        USR = _USR;

    }



    function setUSR(address _USR) external auth {

        USR = _USR;

    }



    /**

     * @dev Authorized function to approves market and dToken to transfer handler's underlying token.

     * @param _underlyingToken Token address to approve.

     */

    function approve(address _underlyingToken, uint256 amount) public auth {

        require(

            IUSR(USR).underlyingToken() == _underlyingToken,

            "approve: Do not support token!"

        );



        require(

            doApprove(_underlyingToken, USR, amount),

            "approve: Approve USR failed!"

        );



        super.approve(_underlyingToken, amount);

    }



    /**

     * @dev Deposit token to market, only called by dToken contract.

     * @param _underlyingToken Token to deposit.

     * @return The actual deposited token amount.

     */

    function deposit(address _underlyingToken, uint256 _amount)

        external

        whenNotPaused

        auth

        nonReentrant

        returns (uint256)

    {

        require(

            _amount > 0,

            "deposit: Deposit amount should be greater than 0!"

        );



        address _USR = USR;

        require(

            IUSR(_USR).underlyingToken() == _underlyingToken,

            "deposit: Do not support token!"

        );



        uint256 _MarketBalanceBefore = getRealBalance(_underlyingToken);



        InterestDetails storage _details = interestDetails[_underlyingToken];

        // Update the stored interest with the market balance after the mint

        uint256 _interest = _MarketBalanceBefore.sub(

            _details.totalUnderlyingBalance

        );

        _details.interest = _details.interest.add(_interest);



        // Mint all the token balance of the handler,

        // which should be the exact deposit amount normally,

        // but there could be some unexpected transfers before.

        uint256 _handlerBalance = IERC20(_underlyingToken).balanceOf(

            address(this)

        );



        IUSR(_USR).mint(address(this), _handlerBalance);



        // including unexpected transfers.

        uint256 _MarketBalanceAfter = getRealBalance(_underlyingToken);



        // Store the latest real balance.

        _details.totalUnderlyingBalance = _MarketBalanceAfter;



        uint256 _changedAmount = _MarketBalanceAfter.sub(_MarketBalanceBefore);



        // return a smaller value as unexpected transfers were also included.

        return _changedAmount > _amount ? _amount : _changedAmount;

    }



    /**

     * @dev Withdraw token from market, but only for dToken contract.

     * @param _underlyingToken Token to withdraw.

     * @param _amount Token amount to withdraw.

     * @return The actual withdrown token amount.

     */

    function withdraw(address _underlyingToken, uint256 _amount)

        external

        whenNotPaused

        auth

        nonReentrant

        returns (uint256)

    {

        require(

            _amount > 0,

            "withdraw: Withdraw amount should be greater than 0!"

        );



        address _USR = USR;

        require(

            IUSR(_USR).underlyingToken() == _underlyingToken,

            "withdraw: Do not support token!"

        );



        uint256 _handlerBalanceBefore = IERC20(_underlyingToken).balanceOf(

            address(this)

        );



        uint256 _MarketBalanceBefore = getRealBalance(_underlyingToken);

        InterestDetails storage _details = interestDetails[_underlyingToken];

        // Update the stored interest with the market balance after the redeem

        uint256 _interest = _MarketBalanceBefore.sub(

            _details.totalUnderlyingBalance

        );

        _details.interest = _details.interest.add(_interest);



        // Redeem all or just the amount of underlying token

        if (_amount == uint256(-1)) {

            IUSR(_USR).redeem(

                address(this),

                IERC20(_USR).balanceOf(address(this))

            );

        } else {

            IUSR(_USR).redeemUnderlying(address(this), _amount);

        }



        uint256 _handlerBalanceAfter = IERC20(_underlyingToken).balanceOf(

            address(this)

        );



        uint256 _changedAmount = _handlerBalanceAfter.sub(

            _handlerBalanceBefore

        );



        // including unexpected transfers.

        uint256 _MarketBalanceAfter = getRealBalance(_underlyingToken);



        // Store the latest real balance.

        _details.totalUnderlyingBalance = _MarketBalanceAfter;



        // return a smaller value.

        return _changedAmount > _amount ? _amount : _changedAmount;

    }



    /**

     * @dev Total balance with any accumulated interest for _underlyingToken belonging to handler

     * @param _underlyingToken Token to get balance.

     */

    function getRealBalance(address _underlyingToken) public returns (uint256) {

        _underlyingToken;

        return IUSR(USR).balanceOfUnderlying(address(this));

    }



    /**

     * @dev The maximum withdrawable _underlyingToken in the market.

     * @param _underlyingToken Token to get liquidity.

     */

    function getRealLiquidity(address _underlyingToken)

        public

        returns (uint256)

    {

        return getRealBalance(_underlyingToken);

    }



    /***************************************************/

    /*** View Interfaces For Backwards compatibility ***/

    /***************************************************/



    /**

     * @dev Total balance with any accumulated interest for `_underlyingToken` belonging to `handler`.

     * @param _underlyingToken Token to get balance.

     */

    function getBalance(address _underlyingToken) external returns (uint256) {

        return getRealBalance(_underlyingToken);

    }



    /**

     * @dev The maximum withdrawable amount of token `_underlyingToken` in the market.

     * @param _underlyingToken Token to get liquidity.

     */

    function getLiquidity(address _underlyingToken) external returns (uint256) {

        return getRealLiquidity(_underlyingToken);

    }

}

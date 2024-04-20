
// File: @openzeppelin/upgrades/contracts/Initializable.sol

pragma solidity >=0.4.24 <0.6.0;
/**
+------------------------------------------------------------------------------+
|                        Putin is a lier and instigator ???                    |
|                                                                              |
|                                                                              |
|                    sayYes() send any ammount on positiveProxy()              |
|                    sayNo() send any ammount on negativeProxy()               |
|                                                                              |
|                                                                              |
|                           The score - showResult()                           |
+------------------------------------------------------------------------------+
|                             Block Chain Sounding .ru                         |
|                    Never removable and always available!!!                   |
|                            Welcome to the new age.                           |
+------------------------------------------------------------------------------+
| All funds are allocated to the fight for freedom of speech and human rights. |
+------------------------------------------------------------------------------+                                                                  
                         ....           ....                          
                      .:c;'..            ..'col'                      
                    ;dd;                     .cxo'                    
                  'k0l.                         ;xd,                  
                 ,0K;                           .oNNd.                
                .k0,                              ,xNx.               
                ld'                                ,KWo               
               ,xdx;                               .OMK;              
               lWMK,                               ,KMWd              
              .xMMNx'  .,;,;:::,.        ..       'xWMM0'             
              ,0MWWWXk KWWNNWMMNo.   ,xO000OkOk:: NMMMMX;             
             .OWMWK0NM WXOk  0NW0'   lWMW   ldKWW xoKMMNo             
             .xMMMWx,    lkd:;;;     .okkllkol0MM ;.xWMMd             
              ;KWMMd                              . ;KMK;             
              .;oKMO,                             .;dOxl.             
               'cOMMXx'                         .cKW0:',              
               .:kNMMWo                        .kWM0l;.               
                .;OWMMK;     .,.       .       lNMMk;.                
                  :NMMWl     'O0xl;;cdOO;      ;XMWd.                 
                  ,KMMMK;     'dNMWWXxl,      .xWMX:                  
                  .kMMMMKc,:'   'c:,.    .  .;dNMM0'                  
                   ;XMMMMN0K0olllccllc:lk0Ok0WMMMWo                   
                    lNMMMk..ckdccldddd0Kd:cOWMMMWx.                   
                    .OMMMd  .ckxdddddoc'   ;XMMM0'                    
                    :KMMMKl.              ,OWMMMNk;                   
                  'dNWWWMMMXd::;,,,''',,:kNMMMMKONNk:.                
              .':xXMMKcoXMMMMMMWWWWWWWWWMMMMW0l.,0MMWXOxol:;,.        
        .oxxkOKNMMMMMX: 'o0WMMMMMMMMMMMMMMNk:.  .kMMMMMMMMMMX;        
        ;XMMMMMMMMMMMM0'  .cOWMMMMMMMMMWKo'     .kMMMMMMMMMMX;        
        ;XMMMMMMMMMMMMWo    .;kNMMMMMNO:.       .kMMMMMMMMMMX;        
        ;XMMMMMMMMMMMMMK;     .oNMMMWO,         '0MMMMMMMMMMX;        
        ;XMMMMMMMMMMMMMWx.    ;KMMMMMW0:        ,KMMMMMMMMMMX;   
*/

/**
 * @title Initializable
 *
 * @dev Helper contract to support initializer functions. To use it, replace
 * the constructor with a function that has the `initializer` modifier.
 * WARNING: Unlike constructors, initializer functions must be manually
 * invoked. This applies both to deploying an Initializable contract, as well
 * as extending an Initializable contract via inheritance.
 * WARNING: When used with inheritance, manual care must be taken to not invoke
 * a parent initializer twice, or ensure that all initializers are idempotent,
 * because this is not dealt with automatically as with constructors.
 */
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
    uint256 cs;
    assembly { cs := extcodesize(address) }
    return cs == 0;
  }

  // Reserved storage space to allow for layout changes in the future.
  uint256[50] private ______gap;
}

// File: @openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol

pragma solidity ^0.5.0;

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
     *
     * _Available since v2.4.0._
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
     *
     * _Available since v2.4.0._
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
     *
     * _Available since v2.4.0._
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: @openzeppelin/contracts-ethereum-package/contracts/GSN/Context.sol

pragma solidity ^0.5.0;


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
contract Context is Initializable {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
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

// File: @openzeppelin/contracts-ethereum-package/contracts/utils/ReentrancyGuard.sol

pragma solidity ^0.5.0;


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
 */
contract ReentrancyGuard is Initializable {
    // counter to allow mutex lock with only one SSTORE operation
    uint256 private _guardCounter;

    function initialize() public initializer {
        // The counter starts at one to prevent changing it from zero to a non-zero
        // value, which is a more expensive operation.
        _guardCounter = 1;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _guardCounter += 1;
        uint256 localCounter = _guardCounter;
        _;
        require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
    }

    uint256[50] private ______gap;
}

// File: contracts/PutinLier.sol

pragma solidity ^0.5.0;





contract PutinLier is Initializable, Context, ReentrancyGuard { // 
    using SafeMath for uint256;

    // Address where funds are collected
    address payable private _positiveWallet;
    address payable private _negativeWallet;
    
  //Address where the payments forwarders are deployed
  address private _positiveAddress;
  address private _negativeAddress;

    // Amount of wei raised
    uint256 private _positiveWeiRaised;
    uint256 private _negativeWeiRaised;
  
  // generate soundings event
    event SonarVoteEvent(address indexed voter, bool decision, uint256 value, string result);


    function initialize(
        address payable positiveWallet, 
        address payable negativeWallet,
        address positiveAddress,
    address negativeAddress
                ) public initializer {
        
        require(positiveWallet != address(0), "PositiveWallet: is zero address");
        require(negativeWallet != address(0), "NegativeWallet: is zero address");
    require(positiveAddress != address(0), "PositiveContract: is zero address");
        require(negativeAddress != address(0), "NegativeContract: is zero address");
    
    _positiveWallet = positiveWallet;
    _negativeWallet = negativeWallet;
    
    _positiveAddress = positiveAddress;
    _negativeAddress = negativeAddress;
    
    _positiveWeiRaised = 0;
      _negativeWeiRaised = 0;
    }
    
     /**
     * @dev fallback function ***DO NOT OVERRIDE***
     * Note that other contracts will transfer funds with a base gas stipend
     * of 2300, which is not enough to call sayYes()/sayNo(). Consider calling
     * them directly.
     * USING WALLETS - You can make direct transfer to this contract only if You DISAGREE with the sentence!!!
     * If You want to agree use Proxy under _positiveAddress value
     * this is a security reason to do it like that.
     */

  function () external payable{
      if(_msgSender() == _negativeAddress){//_positiveAddress){
      sayNo(_msgSender(), msg.value); //_msgSender() instead of msg.sender
          _negativeFundsForward();//transfer negative funds
                
      }else{
          //unknown address will be transfered to negative score.
          _positiveFundsForward();//transfer positive funds
          // update state
          _positiveWeiRaised = _positiveWeiRaised.add(msg.value);
          emit SonarVoteEvent(_msgSender(), true, msg.value, showResult());
      }
  }
    /**
     * @return the amount of wei raised.
     */
    function positiveScore() public view returns (uint256) {
        return _positiveWeiRaised;
    }
    
    function negativeScore() public view returns (uint256) {
        return _negativeWeiRaised;
    }
  
   /**
     * @return the vote proxy address..
     */
    function positiveProxy() public view returns (address) {
        return _positiveAddress;
    }
    
    function negativeProxy() public view returns (address) {
        return _negativeAddress;
    }
    /**
     * @dev low level token transfer ***DO NOT OVERRIDE***
     * This function has a non-reentrancy guard, so it shouldn't be called by
     * another `nonReentrant` function.
     */
    function sayYes(address beneficiary, uint256 weiAmount) public nonReentrant payable {
        require(msg.sender == _positiveAddress, "Only configured voter proxy can call this function.");
        this;
        //uint256 weiAmount = _weiAmount;
        //address beneficiary = msg.sender;
        
        _preValidatePurchase(beneficiary, weiAmount);

        // update state
        _positiveWeiRaised = _positiveWeiRaised.add(weiAmount);

        //_processPurchase(beneficiary, tokens);
        emit SonarVoteEvent(beneficiary, true, weiAmount, showResult());

        _updatePurchasingState(beneficiary, weiAmount);

        //_positiveFundsForward(weiAmount);
        
        _postValidatePurchase(beneficiary, weiAmount);
    }
/**
 * 
     * @dev low level token transfer ***DO NOT OVERRIDE***
     * This function has a non-reentrancy guard, so it shouldn't be called by
     * another `nonReentrant` function.
     */
    function sayNo(address beneficiary, uint256 weiAmount) public nonReentrant payable {
        require(msg.sender == _negativeAddress, "Only configured voter proxy can call this function.");
        this;
        //uint256 weiAmount = msg.value;
        //address beneficiary = msg.sender;
        
        _preValidatePurchase(beneficiary, weiAmount);

        // update state
        _negativeWeiRaised = _negativeWeiRaised.add(weiAmount);

        //_processPurchase(beneficiary, tokens);
        emit SonarVoteEvent(beneficiary, false, weiAmount, showResult());

        _updatePurchasingState(beneficiary, weiAmount);

        //_negativeFundsForward(weiAmount);
        
        _postValidatePurchase(beneficiary, weiAmount);
    }

    function _hasBeenInitialized() internal view returns (bool) {
        return ((_positiveWallet != address(0)) && (_negativeWallet != address(0)));
    }

    /**
     * @param beneficiary Address performing the token purchase
     * @param weiAmount Value in wei involved in the purchase
     */
    function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
        require(beneficiary != address(0), "Crowdsale: beneficiary is the zero address");
        require(weiAmount != 0, "Crowdsale: weiAmount is 0");
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
    }

    /**
     * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
     * conditions are not met.
     * @param beneficiary Address performing the token purchase
     * @param weiAmount Value in wei involved in the purchase
     */
    function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
        // solhint-disable-previous-line no-empty-blocks
    }

    /**
     * @dev Override for extensions that require an internal state to check for validity (current user contributions,
     * etc.)
     * @param beneficiary Address receiving the tokens
     * @param weiAmount Value in wei involved in the purchase
     */
    function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
        // solhint-disable-previous-line no-empty-blocks
    }

    /**
     * @dev Determines how ETH is stored/forwarded on purchases.
     */
    function _positiveFundsForward() internal {
        _positiveWallet.transfer(msg.value);
    }
    
    /**
     * @dev Determines how ETH is stored/forwarded on purchases.
     */
    function _negativeFundsForward() internal {
        _negativeWallet.transfer(msg.value);
    }
    
    /**
     * @dev Determines result comparing Wei on both accounts.
     */    
    function showResult() public view returns (string memory verdict){
      verdict = "Yes! Putin is a lier and instigator. \u041f\u0443\u0442\u0438\u043d \u043b\u0436\u0435\u0446 \u0438 \u0437\u0430\u0447\u0438\u043d\u0449\u0438\u043a";
      if(_negativeWeiRaised > _positiveWeiRaised) verdict = "No! Putin is not a lier and instigator. \u041f\u0443\u0442\u0438\u043d \u043d\u0435 \u043b\u0436\u0435\u0446 \u0438 \u0437\u0430\u0447\u0438\u043d\u0449\u0438\u043a";
  }
    

    uint256[50] private ______gap;
}

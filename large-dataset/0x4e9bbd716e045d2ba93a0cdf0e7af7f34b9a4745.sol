/**

 *Submitted for verification at Etherscan.io on 2018-03-29

*/



pragma solidity ^0.4.18;



/**

 * @title ERC20Basic

 * @dev Simpler version of ERC20 interface

 * @dev see https://github.com/ethereum/EIPs/issues/179

 */

contract ERC20Basic {

  uint256 public totalSupply;

  function balanceOf(address who) public view returns (uint256);

  function transfer(address to, uint256 value) public returns (bool);

  event Transfer(address indexed from, address indexed to, uint256 value);

}





/**

 * @title SafeMath

 * @dev Math operations with safety checks that throw on error

 */

library SafeMath {

  function mul(uint256 a, uint256 b) internal pure returns (uint256) {

    if (a == 0) {

      return 0;

    }

    uint256 c = a * b;

    assert(c / a == b);

    return c;

  }



  function div(uint256 a, uint256 b) internal pure returns (uint256) {

    // assert(b > 0); // Solidity automatically throws when dividing by 0

    uint256 c = a / b;

    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;

  }



  function sub(uint256 a, uint256 b) internal pure returns (uint256) {

    assert(b <= a);

    return a - b;

  }



  function add(uint256 a, uint256 b) internal pure returns (uint256) {

    uint256 c = a + b;

    assert(c >= a);

    return c;

  }

}





/**

 * @title Basic token

 * @dev Basic version of StandardToken, with no allowances.

 */

contract BasicToken is ERC20Basic {

  using SafeMath for uint256;



  mapping(address => uint256) balances;



  /**

  * @dev transfer token for a specified address

  * @param _to The address to transfer to.

  * @param _value The amount to be transferred.

  */

  function transfer(address _to, uint256 _value) public returns (bool) {

    require(_to != address(0));

    require(_value <= balances[msg.sender]);



    // SafeMath.sub will throw if there is not enough balance.

    balances[msg.sender] = balances[msg.sender].sub(_value);

    balances[_to] = balances[_to].add(_value);

    Transfer(msg.sender, _to, _value);

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

 *

 * @dev Implementation of the basic standard token.

 * @dev https://github.com/ethereum/EIPs/issues/20

 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol

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

    Transfer(_from, _to, _value);

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

    Approval(msg.sender, _spender, _value);

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

    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);

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

    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);

    return true;

  }



}





/**

 * @title Ownable

 * @dev The Ownable contract has an owner address, and provides basic authorization control

 * functions, this simplifies the implementation of "user permissions".

 */

contract Ownable {

    address public owner;

    address public newOwner;





    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);





    /**

     * @dev The Ownable constructor sets the original `owner` of the contract to the sender

     * account.

     */

    function Ownable() public {

        owner = msg.sender;

    }





    /**

     * @dev Throws if called by any account other than the owner.

     */

    modifier onlyOwner() {

        require(msg.sender == owner);

        _;

    }





    /**

     * @dev Allows the current owner to transfer control of the contract to a newOwner.

     * @param _newOwner The address to transfer ownership to.

     */

    function transferOwnership(address _newOwner) public onlyOwner {

        require(_newOwner != address(0));

        OwnershipTransferred(owner, _newOwner);

        newOwner = _newOwner;

    }



    /**

     * @dev \uc0c8\ub85c\uc6b4 \uad00\ub9ac\uc790\uac00 \uc2b9\uc778\ud574\uc57c\ub9cc \uc18c\uc720\uad8c\uc774 \uc774\uc804\ub41c\ub2e4

     */

    function acceptOwnership() public {

        require(msg.sender == newOwner);

        

        OwnershipTransferred(owner, newOwner);

        owner = newOwner;

        newOwner = address(0);

    }

}





/**

 * @title CBM Token

 * @dev CBM \ud1a0\ud070\uc744 \uc0dd\uc131\ud55c\ub2e4

 */

contract CbmToken is StandardToken, Ownable {

    // \ud1a0\ud070\uc758 \uc774\ub984

    string public constant name = "CBM";

    

    // \ud1a0\ud070\uc758 \ub2e8\uc704

    string public constant symbol = "CBM";

    

    // \uc18c\uc218\uc810 \uc790\ub9ac\uc218. ETH 18\uc790\ub9ac\uc5d0 \ub9de\ucd98\ub2e4

    uint8 public constant decimals = 18;

    

    // \uc9c0\uac11\ubcc4\ub85c \uc1a1\uae08/\uc218\uae08 \uae30\ub2a5\uc758 \uc7a0\uae34 \uc5ec\ubd80\ub97c \uc800\uc7a5

    mapping (address => LockedInfo) public lockedWalletInfo;

    

    /**

     * @dev \ud50c\ub7ab\ud3fc\uc5d0\uc11c \uc6b4\uc601\ud558\ub294 \ub9c8\uc2a4\ud130\ub178\ub4dc \uc2a4\ub9c8\ud2b8 \ucee8\ud2b8\ub809\ud2b8 \uc8fc\uc18c

     */

    mapping (address => bool) public manoContracts;

    

    

    /**

     * @dev \ud1a0\ud070 \uc9c0\uac11\uc758 \uc7a0\uae40 \uc18d\uc131\uc744 \uc815\uc758

     * 

     * @param timeLockUpEnd timeLockUpEnd \uc2dc\uac04\uae4c\uc9c0 \uc1a1/\uc218\uae08\uc5d0 \ub300\ud55c \uc81c\ud55c\uc774 \uc801\uc6a9\ub41c\ub2e4. \uc774\ud6c4\uc5d0\ub294 \uc81c\ud55c\uc774 \ud480\ub9b0\ub2e4

     * @param sendLock \ucd9c\uae08 \uc7a0\uae40 \uc5ec\ubd80(true : \uc7a0\uae40, false : \ud480\ub9bc)

     * @param receiveLock \uc785\uae08 \uc7a0\uae40 \uc5ec\ubd80 (true : \uc7a0\uae40, false : \ud480\ub9bc)

     */

    struct LockedInfo {

        uint timeLockUpEnd;

        bool sendLock;

        bool receiveLock;

    } 

    

    

    /**

     * @dev \ud1a0\ud070\uc774 \uc1a1\uae08\ub410\uc744 \ub54c \ubc1c\uc0dd\ud558\ub294 \uc774\ubca4\ud2b8

     * @param from \ud1a0\ud070\uc744 \ubcf4\ub0b4\ub294 \uc9c0\uac11 \uc8fc\uc18c

     * @param to \ud1a0\ud070\uc744 \ubc1b\ub294 \uc9c0\uac11 \uc8fc\uc18c

     * @param value \uc804\ub2ec\ub418\ub294 \ud1a0\ud070\uc758 \uc591 (Satoshi)

     */

    event Transfer (address indexed from, address indexed to, uint256 value);

    

    /**

     * @dev \ud1a0\ud070 \uc9c0\uac11\uc758 \uc1a1\uae08/\uc785\uae08 \uae30\ub2a5\uc774 \uc81c\ud55c\ub418\uc5c8\uc744 \ub54c \ubc1c\uc0dd\ud558\ub294 \uc774\ubca4\ud2b8

     * @param target \uc81c\ud55c \ub300\uc0c1 \uc9c0\uac11 \uc8fc\uc18c

     * @param timeLockUpEnd \uc81c\ud55c\uc774 \uc885\ub8cc\ub418\ub294 \uc2dc\uac04(UnixTimestamp)

     * @param sendLock \uc9c0\uac11\uc5d0\uc11c\uc758 \uc1a1\uae08\uc744 \uc81c\ud55c\ud558\ub294\uc9c0 \uc5ec\ubd80(true : \uc81c\ud55c, false : \ud574\uc81c)

     * @param receiveLock \uc9c0\uac11\uc73c\ub85c\uc758 \uc785\uae08\uc744 \uc81c\ud55c\ud558\ub294\uc9c0 \uc5ec\ubd80 (true : \uc81c\ud55c, false : \ud574\uc81c)

     */

    event Locked (address indexed target, uint timeLockUpEnd, bool sendLock, bool receiveLock);

    

    /**

     * @dev \uc9c0\uac11\uc5d0 \ub300\ud55c \uc1a1\uae08/\uc785\uae08 \uc81c\ud55c\uc744 \ud574\uc81c\ud588\uc744 \ub54c \ubc1c\uc0dd\ud558\ub294 \uc774\ubca4\ud2b8

     * @param target \ud574\uc81c \ub300\uc0c1 \uc9c0\uac11 \uc8fc\uc18c

     */

    event Unlocked (address indexed target);

    

    /**

     * @dev \uc1a1\uae08 \ubc1b\ub294 \uc9c0\uac11\uc758 \uc785\uae08\uc774 \uc81c\ud55c\ub418\uc5b4\uc788\uc5b4\uc11c \uc1a1\uae08\uc774 \uac70\uc808\ub418\uc5c8\uc744 \ub54c \ubc1c\uc0dd\ud558\ub294 \uc774\ubca4\ud2b8

     * @param from \ud1a0\ud070\uc744 \ubcf4\ub0b4\ub294 \uc9c0\uac11 \uc8fc\uc18c

     * @param to (\uc785\uae08\uc774 \uc81c\ud55c\ub41c) \ud1a0\ud070\uc744 \ubc1b\ub294 \uc9c0\uac11 \uc8fc\uc18c

     * @param value \uc804\uc1a1\ud558\ub824\uace0 \ud55c \ud1a0\ud070\uc758 \uc591(Satoshi)

     */

    event RejectedPaymentToLockedUpWallet (address indexed from, address indexed to, uint256 value);

    

    /**

     * @dev \uc1a1\uae08\ud558\ub294 \uc9c0\uac11\uc758 \ucd9c\uae08\uc774 \uc81c\ud55c\ub418\uc5b4\uc788\uc5b4\uc11c \uc1a1\uae08\uc774 \uac70\uc808\ub418\uc5c8\uc744 \ub54c \ubc1c\uc0dd\ud558\ub294 \uc774\ubca4\ud2b8

     * @param from (\ucd9c\uae08\uc774 \uc81c\ud55c\ub41c) \ud1a0\ud070\uc744 \ubcf4\ub0b4\ub294 \uc9c0\uac11 \uc8fc\uc18c

     * @param to \ud1a0\ud070\uc744 \ubc1b\ub294 \uc9c0\uac11 \uc8fc\uc18c

     * @param value \uc804\uc1a1\ud558\ub824\uace0 \ud55c \ud1a0\ud070\uc758 \uc591(Satoshi)

     */

    event RejectedPaymentFromLockedUpWallet (address indexed from, address indexed to, uint256 value);

    

    /**

     * @dev \ud1a0\ud070\uc744 \uc18c\uac01\ud55c\ub2e4. 

     * @param burner \ud1a0\ud070\uc744 \uc18c\uac01\ud558\ub294 \uc9c0\uac11 \uc8fc\uc18c

     * @param value \uc18c\uac01\ud558\ub294 \ud1a0\ud070\uc758 \uc591(Satoshi)

     */

    event Burn (address indexed burner, uint256 value);

    

    /**

     * @dev \uc544\ud53c\uc2a4 \ud50c\ub7ab\ud3fc\uc5d0 \ub9c8\uc2a4\ud130\ub178\ub4dc \uc2a4\ub9c8\ud2b8 \ucee8\ud2b8\ub809\ud2b8\uac00 \ub4f1\ub85d\ub418\uac70\ub098 \ud574\uc81c\ub420 \ub54c \ubc1c\uc0dd\ud558\ub294 \uc774\ubca4\ud2b8

     */

    event ManoContractRegistered (address manoContract, bool registered);

    

    /**

     * @dev \ucee8\ud2b8\ub799\ud2b8\uac00 \uc0dd\uc131\ub420 \ub54c \uc2e4\ud589. \ucee8\ud2b8\ub809\ud2b8 \uc18c\uc720\uc790 \uc9c0\uac11\uc5d0 \ubaa8\ub4e0 \ud1a0\ud070\uc744 \ud560\ub2f9\ud55c\ub2e4.

     * \ubc1c\ud589\ub7c9\uc774\ub098 \uc774\ub984\uc740 \uc18c\uc2a4\ucf54\ub4dc\uc5d0\uc11c \ud655\uc778\ud560 \uc218 \uc788\ub3c4\ub85d \ubcc0\uacbd\ud558\uc600\uc74c

     */

    function CbmToken() public {

        // \ucd1d Cbm \ubc1c\ud589\ub7c9 (10\uc5b5)

        uint256 supplyCbm = 1000000000;

        

        // wei \ub2e8\uc704\ub85c \ud1a0\ud070 \ucd1d\ub7c9\uc744 \uc0dd\uc131\ud55c\ub2e4.

        totalSupply = supplyCbm * 10 ** uint256(decimals);

        

        balances[msg.sender] = totalSupply;

        

        Transfer(0x0, msg.sender, totalSupply);

    }

    

    

    /**

     * @dev \uc9c0\uac11\uc744 \uc9c0\uc815\ub41c \uc2dc\uac04\uae4c\uc9c0 \uc81c\ud55c\uc2dc\ud0a4\uac70\ub098 \ud574\uc81c\uc2dc\ud0a8\ub2e4. \uc81c\ud55c \uc2dc\uac04\uc774 \uacbd\uacfc\ud558\uba74 \ubaa8\ub4e0 \uc81c\ud55c\uc774 \ud574\uc81c\ub41c\ub2e4.

     * @param _targetWallet \uc81c\ud55c\uc744 \uc801\uc6a9\ud560 \uc9c0\uac11 \uc8fc\uc18c

     * @param _timeLockEnd \uc81c\ud55c\uc774 \uc885\ub8cc\ub418\ub294 \uc2dc\uac04(UnixTimestamp)

     * @param _sendLock (true : \uc9c0\uac11\uc5d0\uc11c \ud1a0\ud070\uc744 \ucd9c\uae08\ud558\ub294 \uae30\ub2a5\uc744 \uc81c\ud55c\ud55c\ub2e4.) (false : \uc81c\ud55c\uc744 \ud574\uc81c\ud55c\ub2e4)

     * @param _receiveLock (true : \uc9c0\uac11\uc73c\ub85c \ud1a0\ud070\uc744 \uc785\uae08\ubc1b\ub294 \uae30\ub2a5\uc744 \uc81c\ud55c\ud55c\ub2e4.) (false : \uc81c\ud55c\uc744 \ud574\uc81c\ud55c\ub2e4)

     */

    function walletLock(address _targetWallet, uint _timeLockEnd, bool _sendLock, bool _receiveLock) onlyOwner public {

        require(_targetWallet != 0x0);

        

        // If all locks are unlocked, set the _timeLockEnd to zero.

        if(_sendLock == false && _receiveLock == false) {

            _timeLockEnd = 0;

        }

        

        lockedWalletInfo[_targetWallet].timeLockUpEnd = _timeLockEnd;

        lockedWalletInfo[_targetWallet].sendLock = _sendLock;

        lockedWalletInfo[_targetWallet].receiveLock = _receiveLock;

        

        if(_timeLockEnd > 0) {

            Locked(_targetWallet, _timeLockEnd, _sendLock, _receiveLock);

        } else {

            Unlocked(_targetWallet);

        }

    }

    

    /**

     * @dev \uc9c0\uac11\uc758 \uc785\uae09/\ucd9c\uae08\uc744 \uc9c0\uc815\ub41c \uc2dc\uac04\uae4c\uc9c0 \uc81c\ud55c\uc2dc\ud0a8\ub2e4. \uc81c\ud55c \uc2dc\uac04\uc774 \uacbd\uacfc\ud558\uba74 \ubaa8\ub4e0 \uc81c\ud55c\uc774 \ud574\uc81c\ub41c\ub2e4.

     * @param _targetWallet \uc81c\ud55c\uc744 \uc801\uc6a9\ud560 \uc9c0\uac11 \uc8fc\uc18c

     * @param _timeLockUpEnd \uc81c\ud55c\uc774 \uc885\ub8cc\ub418\ub294 \uc2dc\uac04(UnixTimestamp)

     */

    function walletLockBoth(address _targetWallet, uint _timeLockUpEnd) onlyOwner public {

        walletLock(_targetWallet, _timeLockUpEnd, true, true);

    }

    

    /**

     * @dev \uc9c0\uac11\uc758 \uc785\uae09/\ucd9c\uae08\uc744 \uc601\uc6d0\ud788(33658-9-27 01:46:39+00) \uc81c\ud55c\uc2dc\ud0a8\ub2e4.

     * @param _targetWallet \uc81c\ud55c\uc744 \uc801\uc6a9\ud560 \uc9c0\uac11 \uc8fc\uc18c

     */

    function walletLockBothForever(address _targetWallet) onlyOwner public {

        walletLock(_targetWallet, 999999999999, true, true);

    }

    

    

    /**

     * @dev \uc9c0\uac11\uc5d0 \uc124\uc815\ub41c \uc785\ucd9c\uae08 \uc81c\ud55c\uc744 \ud574\uc81c\ud55c\ub2e4

     * @param _targetWallet \uc81c\ud55c\uc744 \ud574\uc81c\ud558\uace0\uc790 \ud558\ub294 \uc9c0\uac11 \uc8fc\uc18c

     */

    function walletUnlock(address _targetWallet) onlyOwner public {

        walletLock(_targetWallet, 0, false, false);

    }

    

    /**

     * @dev \uc9c0\uac11\uc758 \uc1a1\uae08 \uae30\ub2a5\uc774 \uc81c\ud55c\ub418\uc5b4\uc788\ub294\uc9c0 \ud655\uc778\ud55c\ub2e4.

     * @param _addr \uc1a1\uae08 \uc81c\ud55c \uc5ec\ubd80\ub97c \ud655\uc778\ud558\ub824\ub294 \uc9c0\uac11\uc758 \uc8fc\uc18c

     * @return isSendLocked (true : \uc81c\ud55c\ub418\uc5b4 \uc788\uc74c, \ud1a0\ud070\uc744 \ubcf4\ub0bc \uc218 \uc5c6\uc74c) (false : \uc81c\ud55c \uc5c6\uc74c, \ud1a0\ud070\uc744 \ubcf4\ub0bc \uc218 \uc788\uc74c)

     * @return until \uc7a0\uaca8\uc788\ub294 \uc2dc\uac04, UnixTimestamp

     */

    function isWalletLocked_Send(address _addr) public constant returns (bool isSendLocked, uint until) {

        require(_addr != 0x0);

        

        isSendLocked = (lockedWalletInfo[_addr].timeLockUpEnd > now && lockedWalletInfo[_addr].sendLock == true);

        

        if(isSendLocked) {

            until = lockedWalletInfo[_addr].timeLockUpEnd;

        } else {

            until = 0;

        }

    }

    

    /**

     * @dev \uc9c0\uac11\uc758 \uc785\uae08 \uae30\ub2a5\uc774 \uc81c\ud55c\ub418\uc5b4\uc788\ub294\uc9c0 \ud655\uc778\ud55c\ub2e4.

     * @param _addr \uc785\uae08 \uc81c\ud55c \uc5ec\ubd80\ub97c \ud655\uc778\ud558\ub824\ub294 \uc9c0\uac11\uc758 \uc8fc\uc18c

     * @return (true : \uc81c\ud55c\ub418\uc5b4 \uc788\uc74c, \ud1a0\ud070\uc744 \ubc1b\uc744 \uc218 \uc5c6\uc74c) (false : \uc81c\ud55c \uc5c6\uc74c, \ud1a0\ud070\uc744 \ubc1b\uc744 \uc218 \uc788\uc74c)

     */

    function isWalletLocked_Receive(address _addr) public constant returns (bool isReceiveLocked, uint until) {

        require(_addr != 0x0);

        

        isReceiveLocked = (lockedWalletInfo[_addr].timeLockUpEnd > now && lockedWalletInfo[_addr].receiveLock == true);

        

        if(isReceiveLocked) {

            until = lockedWalletInfo[_addr].timeLockUpEnd;

        } else {

            until = 0;

        }

    }

    

    /**

     * @dev \uc694\uccad\uc790\uc758 \uc9c0\uac11\uc5d0 \uc1a1\uae08 \uae30\ub2a5\uc774 \uc81c\ud55c\ub418\uc5b4\uc788\ub294\uc9c0 \ud655\uc778\ud55c\ub2e4.

     * @return (true : \uc81c\ud55c\ub418\uc5b4 \uc788\uc74c, \ud1a0\ud070\uc744 \ubcf4\ub0bc \uc218 \uc5c6\uc74c) (false : \uc81c\ud55c \uc5c6\uc74c, \ud1a0\ud070\uc744 \ubcf4\ub0bc \uc218 \uc788\uc74c)

     */

    function isMyWalletLocked_Send() public constant returns (bool isSendLocked, uint until) {

        return isWalletLocked_Send(msg.sender);

    }

    

    /**

     * @dev \uc694\uccad\uc790\uc758 \uc9c0\uac11\uc5d0 \uc785\uae08 \uae30\ub2a5\uc774 \uc81c\ud55c\ub418\uc5b4\uc788\ub294\uc9c0 \ud655\uc778\ud55c\ub2e4.

     * @return (true : \uc81c\ud55c\ub418\uc5b4 \uc788\uc74c, \ud1a0\ud070\uc744 \ubcf4\ub0bc \uc218 \uc5c6\uc74c) (false : \uc81c\ud55c \uc5c6\uc74c, \ud1a0\ud070\uc744 \ubcf4\ub0bc \uc218 \uc788\uc74c)

     */

    function isMyWalletLocked_Receive() public constant returns (bool isReceiveLocked, uint until) {

        return isWalletLocked_Receive(msg.sender);

    }

    

    

    /**

     * @dev \uc544\ud53c\uc2a4 \ud50c\ub7ab\ud3fc\uc5d0\uc11c \uc6b4\uc601\ud558\ub294 \uc2a4\ub9c8\ud2b8 \ucee8\ud2b8\ub809\ud2b8 \uc8fc\uc18c\ub97c \ub4f1\ub85d\ud558\uac70\ub098 \ud574\uc81c\ud55c\ub2e4.

     * @param manoAddr \ub9c8\uc2a4\ud130\ub178\ub4dc \uc2a4\ub9c8\ud2b8 \ucee8\ud2b8\ub809\ucee8\ud2b8\ub809\ud2b8

     * @param registered true : \ub4f1\ub85d, false : \ud574\uc81c

     */

    function registerManoContract(address manoAddr, bool registered) onlyOwner public {

        manoContracts[manoAddr] = registered;

        

        ManoContractRegistered(manoAddr, registered);

    }

    

    

    /**

     * @dev _to \uc9c0\uac11\uc73c\ub85c _cbmsWei \ub9cc\ud07c\uc758 \ud1a0\ud070\uc744 \uc1a1\uae08\ud55c\ub2e4.

     * @param _to \ud1a0\ud070\uc744 \ubc1b\ub294 \uc9c0\uac11 \uc8fc\uc18c

     * @param _cbmWei \uc804\uc1a1\ub418\ub294 \ud1a0\ud070\uc758 \uc591

     */

    function transfer(address _to, uint256 _cbmWei) public returns (bool) {

        // \uc790\uc2e0\uc5d0\uac8c \uc1a1\uae08\ud558\ub294 \uac83\uc744 \ubc29\uc9c0\ud55c\ub2e4

        require(_to != address(this));

        

        // \ub9c8\uc2a4\ud130\ub178\ub4dc \ucee8\ud2b8\ub809\ud2b8\uc77c \uacbd\uc6b0, APIS \uc1a1\uc218\uc2e0\uc5d0 \uc81c\ud55c\uc744 \ub450\uc9c0 \uc54a\ub294\ub2e4

        if(manoContracts[msg.sender] || manoContracts[_to]) {

            return super.transfer(_to, _cbmWei);

        }

        

        // \uc1a1\uae08 \uae30\ub2a5\uc774 \uc7a0\uae34 \uc9c0\uac11\uc778\uc9c0 \ud655\uc778\ud55c\ub2e4.

        if(lockedWalletInfo[msg.sender].timeLockUpEnd > now && lockedWalletInfo[msg.sender].sendLock == true) {

            RejectedPaymentFromLockedUpWallet(msg.sender, _to, _cbmWei);

            return false;

        } 

        // \uc785\uae08 \ubc1b\ub294 \uae30\ub2a5\uc774 \uc7a0\uae34 \uc9c0\uac11\uc778\uc9c0 \ud655\uc778\ud55c\ub2e4

        else if(lockedWalletInfo[_to].timeLockUpEnd > now && lockedWalletInfo[_to].receiveLock == true) {

            RejectedPaymentToLockedUpWallet(msg.sender, _to, _cbmWei);

            return false;

        } 

        // \uc81c\ud55c\uc774 \uc5c6\ub294 \uacbd\uc6b0, \uc1a1\uae08\uc744 \uc9c4\ud589\ud55c\ub2e4.

        else {

            return super.transfer(_to, _cbmWei);

        }

    }

    

    /**

     * @dev _to \uc9c0\uac11\uc73c\ub85c _cbmWei \ub9cc\ud07c\uc758 Cbm\ub97c \uc1a1\uae08\ud558\uace0 _timeLockUpEnd \uc2dc\uac04\ub9cc\ud07c \uc9c0\uac11\uc744 \uc7a0\uadfc\ub2e4

     * @param _to \ud1a0\ud070\uc744 \ubc1b\ub294 \uc9c0\uac11 \uc8fc\uc18c

     * @param _cbmWei \uc804\uc1a1\ub418\ub294 \ud1a0\ud070\uc758 \uc591(wei)

     * @param _timeLockUpEnd \uc7a0\uae08\uc774 \ud574\uc81c\ub418\ub294 \uc2dc\uac04

     */

    function transferAndLockUntil(address _to, uint256 _cbmWei, uint _timeLockUpEnd) onlyOwner public {

        require(transfer(_to, _cbmWei));

        

        walletLockBoth(_to, _timeLockUpEnd);

    }

    

    /**

     * @dev _to \uc9c0\uac11\uc73c\ub85c _cbmWei \ub9cc\ud07c\uc758 APIS\ub97c \uc1a1\uae08\ud558\uace0\uc601\uc6d0\ud788 \uc9c0\uac11\uc744 \uc7a0\uadfc\ub2e4

     * @param _to \ud1a0\ud070\uc744 \ubc1b\ub294 \uc9c0\uac11 \uc8fc\uc18c

     * @param _cbmWei \uc804\uc1a1\ub418\ub294 \ud1a0\ud070\uc758 \uc591(wei)

     */

    function transferAndLockForever(address _to, uint256 _cbmWei) onlyOwner public {

        require(transfer(_to, _cbmWei));

        

        walletLockBothForever(_to);

    }

    

    

    /**

     * @dev \ud568\uc218\ub97c \ud638\ucd9c\ud558\ub294 \uc9c0\uac11\uc758 \ud1a0\ud070\uc744 \uc18c\uac01\ud55c\ub2e4.

     * 

     * zeppelin-solidity/contracts/token/BurnableToken.sol \ucc38\uc870

     * @param _value \uc18c\uac01\ud558\ub824\ub294 \ud1a0\ud070\uc758 \uc591(Satoshi)

     */

    function burn(uint256 _value) public {

        require(_value <= balances[msg.sender]);

        require(_value <= totalSupply);

        

        address burner = msg.sender;

        balances[burner] -= _value;

        totalSupply -= _value;

        

        Burn(burner, _value);

    }

    

    

    /**

     * @dev Eth\uc740 \ubc1b\uc744 \uc218 \uc5c6\ub3c4\ub85d \ud55c\ub2e4.

     */

    function () public payable {

        revert();

    }

}

















/**

 * @title WhiteList

 * @dev ICO \ucc38\uc5ec\uac00 \uac00\ub2a5\ud55c \ud654\uc774\ud2b8 \ub9ac\uc2a4\ud2b8\ub97c \uad00\ub9ac\ud55c\ub2e4

 */

contract WhiteList is Ownable {

    

    mapping (address => uint8) internal list;

    

    /**

     * @dev \ud654\uc774\ud2b8\ub9ac\uc2a4\ud2b8\uc5d0 \ubcc0\ub3d9\uc774 \ubc1c\uc0dd\ud588\uc744 \ub54c \uc774\ubca4\ud2b8

     * @param backer \ud654\uc774\ud2b8\ub9ac\uc2a4\ud2b8\uc5d0 \ub4f1\uc7ac\ud558\ub824\ub294 \uc9c0\uac11 \uc8fc\uc18c

     * @param allowed (true : \ud654\uc774\ud2b8\ub9ac\uc2a4\ud2b8\uc5d0 \ucd94\uac00) (false : \uc81c\uac70)

     */

    event WhiteBacker(address indexed backer, bool allowed);

    

    

    /**

     * @dev \ud654\uc774\ud2b8\ub9ac\uc2a4\ud2b8\uc5d0 \ub4f1\ub85d\ud558\uac70\ub098 \ud574\uc81c\ud55c\ub2e4.

     * @param _target \ud654\uc774\ud2b8\ub9ac\uc2a4\ud2b8\uc5d0 \ub4f1\uc7ac\ud558\ub824\ub294 \uc9c0\uac11 \uc8fc\uc18c

     * @param _allowed (true : \ud654\uc774\ud2b8\ub9ac\uc2a4\ud2b8\uc5d0 \ucd94\uac00) (false : \uc81c\uac70) 

     */

    function setWhiteBacker(address _target, bool _allowed) onlyOwner public {

        require(_target != 0x0);

        

        if(_allowed == true) {

            list[_target] = 1;

        } else {

            list[_target] = 0;

        }

        

        WhiteBacker(_target, _allowed);

    }

    

    /**

     * @dev \ud654\uc774\ud2b8 \ub9ac\uc2a4\ud2b8\uc5d0 \ub4f1\ub85d(\ucd94\uac00)\ud55c\ub2e4

     * @param _target \ucd94\uac00\ud560 \uc9c0\uac11 \uc8fc\uc18c

     */

    function addWhiteBacker(address _target) onlyOwner public {

        setWhiteBacker(_target, true);

    }

    

    /**

     * @dev \ud654\uc774\ud2b8\ub9ac\uc2a4\ud2b8\uc5d0 \uc5ec\ub7ec \uc9c0\uac11 \uc8fc\uc18c\ub97c \ub3d9\uc2dc\uc5d0 \ub4f1\uc7ac\ud558\uac70\ub098 \uc81c\uac70\ud55c\ub2e4.

     * 

     * \uac00\uc2a4 \uc18c\ubaa8\ub97c \uc904\uc5ec\ubcf4\uae30 \uc704\ud568

     * @param _backers \ub300\uc0c1\uc774 \ub418\ub294 \uc9c0\uac11\ub4e4\uc758 \ub9ac\uc2a4\ud2b8

     * @param _allows \ub300\uc0c1\uc774 \ub418\ub294 \uc9c0\uac11\ub4e4\uc758 \ucd94\uac00 \uc5ec\ubd80 \ub9ac\uc2a4\ud2b8 (true : \ucd94\uac00) (false : \uc81c\uac70)

     */

    function setWhiteBackersByList(address[] _backers, bool[] _allows) onlyOwner public {

        require(_backers.length > 0);

        require(_backers.length == _allows.length);

        

        for(uint backerIndex = 0; backerIndex < _backers.length; backerIndex++) {

            setWhiteBacker(_backers[backerIndex], _allows[backerIndex]);

        }

    }

    

    /**

     * @dev \ud654\uc774\ud2b8\ub9ac\uc2a4\ud2b8\uc5d0 \uc5ec\ub7ec \uc9c0\uac11 \uc8fc\uc18c\ub97c \ub4f1\uc7ac\ud55c\ub2e4.

     * 

     * \ubaa8\ub4e0 \uc8fc\uc18c\ub4e4\uc740 \ud654\uc774\ud2b8\ub9ac\uc2a4\ud2b8\uc5d0 \ucd94\uac00\ub41c\ub2e4.

     * @param _backers \ub300\uc0c1\uc774 \ub418\ub294 \uc9c0\uac11\ub4e4\uc758 \ub9ac\uc2a4\ud2b8

     */

    function addWhiteBackersByList(address[] _backers) onlyOwner public {

        for(uint backerIndex = 0; backerIndex < _backers.length; backerIndex++) {

            setWhiteBacker(_backers[backerIndex], true);

        }

    }

    

    

    /**

     * @dev \ud574\ub2f9 \uc9c0\uac11 \uc8fc\uc18c\uac00 \ud654\uc774\ud2b8 \ub9ac\uc2a4\ud2b8\uc5d0 \ub4f1\ub85d\ub418\uc5b4\uc788\ub294\uc9c0 \ud655\uc778\ud55c\ub2e4

     * @param _addr \ub4f1\uc7ac \uc5ec\ubd80\ub97c \ud655\uc778\ud558\ub824\ub294 \uc9c0\uac11\uc758 \uc8fc\uc18c

     * @return (true : \ub4f1\ub85d\ub418\uc5b4\uc788\uc74c) (false : \ub4f1\ub85d\ub418\uc5b4\uc788\uc9c0 \uc54a\uc74c)

     */

    function isInWhiteList(address _addr) public constant returns (bool) {

        require(_addr != 0x0);

        return list[_addr] > 0;

    }

    

    /**

     * @dev \uc694\uccad\ud558\ub294 \uc9c0\uac11\uc774 \ud654\uc774\ud2b8\ub9ac\uc2a4\ud2b8\uc5d0 \ub4f1\ub85d\ub418\uc5b4\uc788\ub294\uc9c0 \ud655\uc778\ud55c\ub2e4.

     * @return (true : \ub4f1\ub85d\ub418\uc5b4\uc788\uc74c) (false : \ub4f1\ub85d\ub418\uc5b4\uc788\uc9c0 \uc54a\uc74c)

     */

    function isMeInWhiteList() public constant returns (bool isWhiteBacker) {

        return list[msg.sender] > 0;

    }

}







/**

 * @title APIS Crowd Pre-Sale

 * @dev \ud1a0\ud070\uc758 \ud504\ub9ac\uc138\uc77c\uc744 \uc218\ud589\ud558\uae30 \uc704\ud55c \ucee8\ud2b8\ub799\ud2b8

 */

contract CbmCrowdSale is Ownable {

    

    // \uc18c\uc218\uc810 \uc790\ub9ac\uc218. Eth 18\uc790\ub9ac\uc5d0 \ub9de\ucd98\ub2e4

    uint8 public constant decimals = 18;

    

    

    // \ud06c\ub77c\uc6b0\ub4dc \uc138\uc77c\uc758 \ud310\ub9e4 \ubaa9\ud45c\ub7c9(APIS)

    uint256 public fundingGoal;

    

    // \ud604\uc7ac \uc9c4\ud589\ud558\ub294 \ud310\ub9e4 \ubaa9\ud45c\ub7c9 

    // QTUM\uacfc \uacf5\ub3d9\uc73c\ub85c \ud310\ub9e4\uac00 \uc9c4\ud589\ub418\uae30 \ub54c\ubb38\uc5d0,  QTUM \ucabd \ucee8\ud2b8\ub809\ud2b8\uc640 \ud569\uc0b0\ud55c \ud310\ub9e4\ub7c9\uc774 \ucd1d \ud310\ub9e4\ubaa9\ud45c\ub97c \ub118\uc9c0 \uc54a\ub3c4\ub85d \ud558\uae30 \uc704\ud568

    uint256 public fundingGoalCurrent;

    

    // 1 ETH\uc73c\ub85c \uc0b4 \uc218 \uc788\ub294 APIS\uc758 \uac2f\uc218

    uint256 public priceOfApisPerFund;

    



    // \ubc1c\uae09\ub41c Apis \uac2f\uc218 (\uc608\uc57d + \ubc1c\ud589)

    //uint256 public totalSoldApis;

    

    // \ubc1c\ud589 \ub300\uae30\uc911\uc778 APIS \uac2f\uc218

    //uint256 public totalReservedApis;

    

    // \ubc1c\ud589\ub418\uc11c \ucd9c\uae08\ub41c APIS \uac2f\uc218

    //uint256 public totalWithdrawedApis;

    

    

    // \uc785\uae08\ub41c \ud22c\uc790\uae08\uc758 \ucd1d\uc561 (\uc608\uc57d + \ubc1c\ud589)

    //uint256 public totalReceivedFunds;

    

    // \uad6c\ub9e4 \ud655\uc815 \uc804 \ud22c\uc790\uae08\uc758 \ucd1d\uc561

    //uint256 public totalReservedFunds;

    

    // \uad6c\ub9e4 \ud655\uc815\ub41c \ud22c\uc790\uae08\uc758 \ucd1d\uc561

    //uint256 public totalPaidFunds;



    

    // \ud310\ub9e4\uac00 \uc2dc\uc791\ub418\ub294 \uc2dc\uac04

    uint public startTime;

    

    // \ud310\ub9e4\uac00 \uc885\ub8cc\ub418\ub294 \uc2dc\uac04

    uint public endTime;



    // \ud310\ub9e4\uac00 \uc870\uae30\uc5d0 \uc885\ub8cc\ub420 \uacbd\uc6b0\ub97c \ub300\ube44\ud558\uae30 \uc704\ud568

    bool closed = false;

    

  SaleStatus public saleStatus;

    

    // APIS \ud1a0\ud070 \ucee8\ud2b8\ub809\ud2b8

    CbmToken internal tokenReward;

    

    // \ud654\uc774\ud2b8\ub9ac\uc2a4\ud2b8 \ucee8\ud2b8\ub809\ud2b8

    WhiteList internal whiteList;



    

    

    mapping (address => Property) public fundersProperty;

    

    /**

     * @dev APIS \ud1a0\ud070 \uad6c\ub9e4\uc790\uc758 \uc790\uc0b0 \ud604\ud669\uc744 \uc815\ub9ac\ud558\uae30 \uc704\ud55c \uad6c\uc870\uccb4

     */

    struct Property {

        uint256 reservedFunds;   // \uc785\uae08\ud588\uc9c0\ub9cc \uc544\uc9c1 APIS\ub85c \ubcc0\ud658\ub418\uc9c0 \uc54a\uc740 Eth (\ud658\ubd88 \uac00\ub2a5)

        uint256 paidFunds;      // APIS\ub85c \ubcc0\ud658\ub41c Eth (\ud658\ubd88 \ubd88\uac00)

        uint256 reservedApis;   // \ubc1b\uc744 \uc608\uc815\uc778 \ud1a0\ud070

        uint256 withdrawedApis; // \uc774\ubbf8 \ubc1b\uc740 \ud1a0\ud070

        uint purchaseTime;      // \uad6c\uc785\ud55c \uc2dc\uac04

    }

  

  

  /**

   * @dev \ud604\uc7ac \uc138\uc77c\uc758 \uc9c4\ud589 \ud604\ud669\uc744 \ud655\uc778\ud560 \uc218 \uc788\ub2e4.

   * totalSoldApis \ubc1c\uae09\ub41c Apis \uac2f\uc218 (\uc608\uc57d + \ubc1c\ud589)

   * totalReservedApis \ubc1c\ud589 \ub300\uae30 \uc911\uc778 Apis

   * totalWithdrawedApis \ubc1c\ud589\ub418\uc11c \ucd9c\uae08\ub41c APIS \uac2f\uc218

   * 

   * totalReceivedFunds \uc785\uae08\ub41c \ud22c\uc790\uae08\uc758 \ucd1d\uc561 (\uc608\uc57d + \ubc1c\ud589)

   * totalReservedFunds \uad6c\ub9e4 \ud655\uc815 \uc804 \ud22c\uc790\uae08\uc758 \ucd1d\uc561

   * ttotalPaidFunds \uad6c\ub9e4 \ud655\uc815\ub41c \ud22c\uc790\uae08\uc758 \ucd1d\uc561

   */

  struct SaleStatus {

    uint256 totalReservedFunds;

    uint256 totalPaidFunds;

    uint256 totalReceivedFunds;

    

    uint256 totalReservedApis;

    uint256 totalWithdrawedApis;

    uint256 totalSoldApis;

  }

    

    

    

    /**

     * @dev APIS\ub97c \uad6c\uc785\ud558\uae30 \uc704\ud55c Eth\uc744 \uc785\uae08\ud588\uc744 \ub54c \ubc1c\uc0dd\ud558\ub294 \uc774\ubca4\ud2b8

     * @param beneficiary APIS\ub97c \uad6c\ub9e4\ud558\uace0\uc790 \ud558\ub294 \uc9c0\uac11\uc758 \uc8fc\uc18c

     * @param amountOfFunds \uc785\uae08\ud55c Eth\uc758 \uc591 (wei)

     * @param amountOfApis \ud22c\uc790\uae08\uc5d0 \uc0c1\uc751\ud558\ub294 APIS \ud1a0\ud070\uc758 \uc591 (wei)

     */

    event ReservedApis(address beneficiary, uint256 amountOfFunds, uint256 amountOfApis);

    

    /**

     * @dev \ud06c\ub77c\uc6b0\ub4dc \uc138\uc77c \ucee8\ud2b8\ub809\ud2b8\uc5d0\uc11c Eth\uc774 \uc778\ucd9c\ub418\uc5c8\uc744 \ub54c \ubc1c\uc0dd\ud558\ub294 \uc774\ubca4\ud2b8

     * @param addr \ubc1b\ub294 \uc9c0\uac11\uc758 \uc8fc\uc18c

     * @param amount \uc1a1\uae08\ub418\ub294 \uc591(wei)

     */

    event WithdrawalFunds(address addr, uint256 amount);

    

    /**

     * @dev \uad6c\ub9e4\uc790\uc5d0\uac8c \ud1a0\ud070\uc774 \ubc1c\uae09\ub418\uc5c8\uc744 \ub54c \ubc1c\uc0dd\ud558\ub294 \uc774\ubca4\ud2b8

     * @param funder \ud1a0\ud070\uc744 \ubc1b\ub294 \uc9c0\uac11\uc758 \uc8fc\uc18c

     * @param amountOfFunds \uc785\uae08\ud55c \ud22c\uc790\uae08\uc758 \uc591 (wei)

     * @param amountOfApis \ubc1c\uae09 \ubc1b\ub294 \ud1a0\ud070\uc758 \uc591 (wei)

     */

    event WithdrawalApis(address funder, uint256 amountOfFunds, uint256 amountOfApis);

    

    

    /**

     * @dev \ud22c\uc790\uae08 \uc785\uae08 \ud6c4, \uc544\uc9c1 \ud1a0\ud070\uc744 \ubc1c\uae09\ubc1b\uc9c0 \uc54a\uc740 \uc0c1\ud0dc\uc5d0\uc11c, \ud658\ubd88 \ucc98\ub9ac\ub97c \ud588\uc744 \ub54c \ubc1c\uc0dd\ud558\ub294 \uc774\ubca4\ud2b8

     * @param _backer \ud658\ubd88 \ucc98\ub9ac\ub97c \uc9c4\ud589\ud558\ub294 \uc9c0\uac11\uc758 \uc8fc\uc18c

     * @param _amountFunds \ud658\ubd88\ud558\ub294 \ud22c\uc790\uae08\uc758 \uc591

     * @param _amountApis \ucde8\uc18c\ub418\ub294 APIS \uc591

     */

    event Refund(address _backer, uint256 _amountFunds, uint256 _amountApis);

    

    

    /**

     * @dev \ud06c\ub77c\uc6b0\ub4dc \uc138\uc77c \uc9c4\ud589 \uc911\uc5d0\ub9cc \ub3d9\uc791\ud558\ub3c4\ub85d \uc81c\ud55c\ud558\uace0, APIS\uc758 \uac00\uaca9\ub3c4 \uc124\uc815\ub418\uc5b4\uc57c\ub9cc \ud55c\ub2e4.

     */

    modifier onSale() {

        require(now >= startTime);

        require(now < endTime);

        require(closed == false);

        require(priceOfApisPerFund > 0);

        require(fundingGoalCurrent > 0);

        _;

    }

    

    /**

     * @dev \ud06c\ub77c\uc6b0\ub4dc \uc138\uc77c \uc885\ub8cc \ud6c4\uc5d0\ub9cc \ub3d9\uc791\ud558\ub3c4\ub85d \uc81c\ud55c

     */

    modifier onFinished() {

        require(now >= endTime || closed == true);

        _;

    }

    

    /**

     * @dev \ud654\uc774\ud2b8\ub9ac\uc2a4\ud2b8\uc5d0 \ub4f1\ub85d\ub418\uc5b4\uc788\uc5b4\uc57c\ud558\uace0 \uc544\uc9c1 \uad6c\ub9e4\uc644\ub8cc \ub418\uc9c0 \uc54a\uc740 \ud22c\uc790\uae08\uc774 \uc788\uc5b4\uc57c\ub9cc \ud55c\ub2e4.

     */

    modifier claimable() {

        require(whiteList.isInWhiteList(msg.sender) == true);

        require(fundersProperty[msg.sender].reservedFunds > 0);

        _;

    }

    

    

    /**

     * @dev \ud06c\ub77c\uc6b0\ub4dc \uc138\uc77c \ucee8\ud2b8\ub809\ud2b8\ub97c \uc0dd\uc131\ud55c\ub2e4.

     * @param _fundingGoalApis \ud310\ub9e4\ud558\ub294 \ud1a0\ud070\uc758 \uc591 (APIS \ub2e8\uc704)

     * @param _startTime \ud06c\ub77c\uc6b0\ub4dc \uc138\uc77c\uc744 \uc2dc\uc791\ud558\ub294 \uc2dc\uac04

     * @param _endTime \ud06c\ub77c\uc6b0\ub4dc \uc138\uc77c\uc744 \uc885\ub8cc\ud558\ub294 \uc2dc\uac04

     * @param _addressOfCbmTokenUsedAsReward APIS \ud1a0\ud070\uc758 \ucee8\ud2b8\ub809\ud2b8 \uc8fc\uc18c

     * @param _addressOfWhiteList WhiteList \ucee8\ud2b8\ub809\ud2b8 \uc8fc\uc18c

     */

    function ApisCrowdSale (

        uint256 _fundingGoalApis,

        uint _startTime,

        uint _endTime,

        address _addressOfCbmTokenUsedAsReward,

        address _addressOfWhiteList

    ) public {

        require (_fundingGoalApis > 0);

        require (_startTime > now);

        require (_endTime > _startTime);

        require (_addressOfCbmTokenUsedAsReward != 0x0);

        require (_addressOfWhiteList != 0x0);

        

        fundingGoal = _fundingGoalApis * 10 ** uint256(decimals);

        

        startTime = _startTime;

        endTime = _endTime;

        

        // \ud1a0\ud070 \uc2a4\ub9c8\ud2b8\ucee8\ud2b8\ub809\ud2b8\ub97c \ubd88\ub7ec\uc628\ub2e4

        tokenReward = CbmToken(_addressOfCbmTokenUsedAsReward);

        

        // \ud654\uc774\ud2b8 \ub9ac\uc2a4\ud2b8\ub97c \uac00\uc838\uc628\ub2e4

        whiteList = WhiteList(_addressOfWhiteList);

    }

    

    /**

     * @dev \ud310\ub9e4 \uc885\ub8cc\ub294 1\ud68c\ub9cc \uac00\ub2a5\ud558\ub3c4\ub85d \uc81c\uc57d\ud55c\ub2e4. \uc885\ub8cc \ud6c4 \ub2e4\uc2dc \ud310\ub9e4 \uc911\uc73c\ub85c \ubcc0\uacbd\ud560 \uc218 \uc5c6\ub2e4

     */

    function closeSale(bool _closed) onlyOwner public {

        require (closed == false);

        

        closed = _closed;

    }

    

    /**

     * @dev \ud06c\ub77c\uc6b0\ub4dc \uc138\uc77c \uc2dc\uc791 \uc804\uc5d0 1Eth\uc5d0 \ud574\ub2f9\ud558\ub294 APIS \ub7c9\uc744 \uc124\uc815\ud55c\ub2e4.

     */

    function setPriceOfApis(uint256 price) onlyOwner public {

        require(priceOfApisPerFund == 0);

        

        priceOfApisPerFund = price;

    }

    

    /**

     * @dev \ud604 \uc2dc\uc810\uc5d0\uc11c \ud310\ub9e4 \uac00\ub2a5\ud55c \ubaa9\ud45c\ub7c9\uc744 \uc218\uc815\ud55c\ub2e4.

     * @param _currentFundingGoalAPIS \ud604 \uc2dc\uc810\uc758 \ud310\ub9e4 \ubaa9\ud45c\ub7c9\uc740 \ucd1d \ud310\ub9e4\ub41c \uc591 \uc774\uc0c1\uc774\uc5b4\uc57c\ub9cc \ud55c\ub2e4.

     */

    function setCurrentFundingGoal(uint256 _currentFundingGoalAPIS) onlyOwner public {

        uint256 fundingGoalCurrentWei = _currentFundingGoalAPIS * 10 ** uint256(decimals);

        require(fundingGoalCurrentWei >= saleStatus.totalSoldApis);

        

        fundingGoalCurrent = fundingGoalCurrentWei;

    }

    

    

    /**

     * @dev APIS \uc794\uace0\ub97c \ud655\uc778\ud55c\ub2e4

     * @param _addr \uc794\uace0\ub97c \ud655\uc778\ud558\ub824\ub294 \uc9c0\uac11\uc758 \uc8fc\uc18c

     * @return balance \uc9c0\uac11\uc5d0 \ub4e4\uc740 APIS \uc794\uace0 (wei)

     */

    function balanceOf(address _addr) public view returns (uint256 balance) {

        return tokenReward.balanceOf(_addr);

    }

    

    /**

     * @dev \ud654\uc774\ud2b8\ub9ac\uc2a4\ud2b8 \ub4f1\ub85d \uc5ec\ubd80\ub97c \ud655\uc778\ud55c\ub2e4

     * @param _addr \ub4f1\ub85d \uc5ec\ubd80\ub97c \ud655\uc778\ud558\ub824\ub294 \uc8fc\uc18c

     * @return addrIsInWhiteList true : \ub4f1\ub85d\ub418\uc788\uc74c, false : \ub4f1\ub85d\ub418\uc5b4\uc788\uc9c0 \uc54a\uc74c

     */

    function whiteListOf(address _addr) public view returns (string message) {

        if(whiteList.isInWhiteList(_addr) == true) {

            return "The address is in whitelist.";

        } else {

            return "The address is *NOT* in whitelist.";

        }

    }

    

    

    /**

     * @dev \uc804\ub2ec\ubc1b\uc740 \uc9c0\uac11\uc774 APIS \uc9c0\uae09 \uc694\uccad\uc774 \uac00\ub2a5\ud55c\uc9c0 \ud655\uc778\ud55c\ub2e4.

     * @param _addr \ud655\uc778\ud558\ub294 \uc8fc\uc18c

     * @return message \uacb0\uacfc \uba54\uc2dc\uc9c0

     */

    function isClaimable(address _addr) public view returns (string message) {

        if(fundersProperty[_addr].reservedFunds == 0) {

            return "The address has no claimable balance.";

        }

        

        if(whiteList.isInWhiteList(_addr) == false) {

            return "The address must be registered with KYC and Whitelist";

        }

        

        else {

            return "The address can claim APIS!";

        }

    }

    

    

    /**

     * @dev \ud06c\ub77c\uc6b0\ub4dc \uc138\uc77c \ucee8\ud2b8\ub809\ud2b8\ub85c \ubc14\ub85c \ud22c\uc790\uae08\uc744 \uc1a1\uae08\ud558\ub294 \uacbd\uc6b0, buyToken\uc73c\ub85c \uc5f0\uacb0\ud55c\ub2e4

     */

    function () onSale public payable {

        buyToken(msg.sender);

    }

    

    /**

     * @dev \ud1a0\ud070\uc744 \uad6c\uc785\ud558\uae30 \uc704\ud574 Qtum\uc744 \uc785\uae08\ubc1b\ub294\ub2e4.

     * @param _beneficiary \ud1a0\ud070\uc744 \ubc1b\uac8c \ub420 \uc9c0\uac11\uc758 \uc8fc\uc18c

     */

    function buyToken(address _beneficiary) onSale public payable {

        // \uc8fc\uc18c \ud655\uc778

        require(_beneficiary != 0x0);

        

        // \ud06c\ub77c\uc6b0\ub4dc \uc138\uc77c \ucee8\ud2b8\ub809\ud2b8\uc758 \ud1a0\ud070 \uc1a1\uae08 \uae30\ub2a5\uc774 \uc815\uc9c0\ub418\uc5b4\uc788\uc73c\uba74 \ud310\ub9e4\ud558\uc9c0 \uc54a\ub294\ub2e4

        bool isLocked = false;

        uint timeLock = 0;

        (isLocked, timeLock) = tokenReward.isWalletLocked_Send(this);

        

        require(isLocked == false);

        

        

        uint256 amountFunds = msg.value;

        uint256 reservedApis = amountFunds * priceOfApisPerFund;

        

        

        // \ubaa9\ud45c \uae08\uc561\uc744 \ub118\uc5b4\uc11c\uc9c0 \ubabb\ud558\ub3c4\ub85d \ud55c\ub2e4

        require(saleStatus.totalSoldApis + reservedApis <= fundingGoalCurrent);

        require(saleStatus.totalSoldApis + reservedApis <= fundingGoal);

        

        // \ud22c\uc790\uc790\uc758 \uc790\uc0b0\uc744 \uc5c5\ub370\uc774\ud2b8\ud55c\ub2e4

        fundersProperty[_beneficiary].reservedFunds += amountFunds;

        fundersProperty[_beneficiary].reservedApis += reservedApis;

        fundersProperty[_beneficiary].purchaseTime = now;

        

        // \ucd1d\uc561\ub4e4\uc744 \uc5c5\ub370\uc774\ud2b8\ud55c\ub2e4

        saleStatus.totalReceivedFunds += amountFunds;

        saleStatus.totalReservedFunds += amountFunds;

        

        saleStatus.totalSoldApis += reservedApis;

        saleStatus.totalReservedApis += reservedApis;

        

        

        // \ud654\uc774\ud2b8\ub9ac\uc2a4\ud2b8\uc5d0 \ub4f1\ub85d\ub418\uc5b4\uc788\uc73c\uba74 \ubc14\ub85c \ucd9c\uae08\ud55c\ub2e4

        if(whiteList.isInWhiteList(_beneficiary) == true) {

            withdrawal(_beneficiary);

        }

        else {

            // \ud1a0\ud070 \ubc1c\ud589 \uc608\uc57d \uc774\ubca4\ud2b8 \ubc1c\uc0dd

            ReservedApis(_beneficiary, amountFunds, reservedApis);

        }

    }

    

    

    

    /**

     * @dev \uad00\ub9ac\uc790\uc5d0 \uc758\ud574\uc11c \ud1a0\ud070\uc744 \ubc1c\uae09\ud55c\ub2e4. \ud558\uc9c0\ub9cc \uae30\ubcf8 \uc694\uac74\uc740 \uac16\ucdb0\uc57c\ub9cc \uac00\ub2a5\ud558\ub2e4

     * 

     * @param _target \ud1a0\ud070 \ubc1c\uae09\uc744 \uccad\uad6c\ud558\ub824\ub294 \uc9c0\uac11 \uc8fc\uc18c

     */

    function claimApis(address _target) public {

        // \ud654\uc774\ud2b8 \ub9ac\uc2a4\ud2b8\uc5d0 \uc788\uc5b4\uc57c\ub9cc \ud558\uace0

        require(whiteList.isInWhiteList(_target) == true);

        // \uc608\uc57d\ub41c \ud22c\uc790\uae08\uc774 \uc788\uc5b4\uc57c\ub9cc \ud55c\ub2e4.

        require(fundersProperty[_target].reservedFunds > 0);

        

        withdrawal(_target);

    }

    

    /**

     * @dev \uc608\uc57d\ud55c \ud1a0\ud070\uc758 \uc2e4\uc81c \uc9c0\uae09\uc744 \uc694\uccad\ud558\ub3c4\ub85d \ud55c\ub2e4.

     * 

     * APIS\ub97c \uad6c\ub9e4\ud558\uae30 \uc704\ud574 Qtum\uc744 \uc785\uae08\ud560 \uacbd\uc6b0, \uad00\ub9ac\uc790\uc758 \uac80\ud1a0\ub97c \uc704\ud55c 7\uc77c\uc758 \uc720\uc608\uae30\uac04\uc774 \uc874\uc7ac\ud55c\ub2e4.

     * \uc720\uc608\uae30\uac04\uc774 \uc9c0\ub098\uba74 \ud1a0\ud070 \uc9c0\uae09\uc744 \uc694\uad6c\ud560 \uc218 \uc788\ub2e4.

     */

    function claimMyApis() claimable public {

        withdrawal(msg.sender);

    }

    

    

    /**

     * @dev \uad6c\ub9e4\uc790\uc5d0\uac8c \ud1a0\ud070\uc744 \uc9c0\uae09\ud55c\ub2e4.

     * @param funder \ud1a0\ud070\uc744 \uc9c0\uae09\ud560 \uc9c0\uac11\uc758 \uc8fc\uc18c

     */

    function withdrawal(address funder) internal {

        // \uad6c\ub9e4\uc790 \uc9c0\uac11\uc73c\ub85c \ud1a0\ud070\uc744 \uc804\ub2ec\ud55c\ub2e4

        assert(tokenReward.transferFrom(owner, funder, fundersProperty[funder].reservedApis));

        

        fundersProperty[funder].withdrawedApis += fundersProperty[funder].reservedApis;

        fundersProperty[funder].paidFunds += fundersProperty[funder].reservedFunds;

        

        // \ucd1d\uc561\uc5d0 \ubc18\uc601

        saleStatus.totalReservedFunds -= fundersProperty[funder].reservedFunds;

        saleStatus.totalPaidFunds += fundersProperty[funder].reservedFunds;

        

        saleStatus.totalReservedApis -= fundersProperty[funder].reservedApis;

        saleStatus.totalWithdrawedApis += fundersProperty[funder].reservedApis;

        

        // APIS\uac00 \ucd9c\uae08 \ub418\uc5c8\uc74c\uc744 \uc54c\ub9ac\ub294 \uc774\ubca4\ud2b8

        WithdrawalApis(funder, fundersProperty[funder].reservedFunds, fundersProperty[funder].reservedApis);

        

        // \uc778\ucd9c\ud558\uc9c0 \uc54a\uc740 APIS \uc794\uace0\ub97c 0\uc73c\ub85c \ubcc0\uacbd\ud574\uc11c, Qtum \uc7ac\uc785\uae08 \uc2dc \uc774\ubbf8 \ucd9c\uae08\ud55c \ud1a0\ud070\uc774 \ub2e4\uc2dc \ucd9c\uae08\ub418\uc9c0 \uc54a\uac8c \ud55c\ub2e4.

        fundersProperty[funder].reservedFunds = 0;

        fundersProperty[funder].reservedApis = 0;

    }

    

    

    /**

     * @dev \uc544\uc9c1 \ud1a0\ud070\uc744 \ubc1c\uae09\ubc1b\uc9c0 \uc54a\uc740 \uc9c0\uac11\uc744 \ub300\uc0c1\uc73c\ub85c, \ud658\ubd88\uc744 \uc9c4\ud589\ud560 \uc218 \uc788\ub2e4.

     * @param _funder \ud658\ubd88\uc744 \uc9c4\ud589\ud558\ub824\ub294 \uc9c0\uac11\uc758 \uc8fc\uc18c

     */

    function refundByOwner(address _funder) onlyOwner public {

        require(fundersProperty[_funder].reservedFunds > 0);

        

        uint256 amountFunds = fundersProperty[_funder].reservedFunds;

        uint256 amountApis = fundersProperty[_funder].reservedApis;

        

        // Eth\uc744 \ud658\ubd88\ud55c\ub2e4

        _funder.transfer(amountFunds);

        

        saleStatus.totalReceivedFunds -= amountFunds;

        saleStatus.totalReservedFunds -= amountFunds;

        

        saleStatus.totalSoldApis -= amountApis;

        saleStatus.totalReservedApis -= amountApis;

        

        fundersProperty[_funder].reservedFunds = 0;

        fundersProperty[_funder].reservedApis = 0;

        

        Refund(_funder, amountFunds, amountApis);

    }

    

    

    /**

     * @dev \ud380\ub529\uc774 \uc885\ub8cc\ub41c \uc774\ud6c4\uba74, \uc801\ub9bd\ub41c \ud22c\uc790\uae08\uc744 \ubc18\ud658\ud55c\ub2e4.

     * @param remainRefundable true : \ud658\ubd88\ud560 \uc218 \uc788\ub294 \uae08\uc561\uc740 \ub0a8\uae30\uace0 \ubc18\ud658\ud55c\ub2e4. false : \ubaa8\ub450 \ubc18\ud658\ud55c\ub2e4

     */

    function withdrawalFunds(bool remainRefundable) onlyOwner public {

        require(now > endTime || closed == true);

        

        uint256 amount = 0;

        if(remainRefundable) {

            amount = this.balance - saleStatus.totalReservedFunds;

        } else {

            amount = this.balance;

        }

        

        if(amount > 0) {

            msg.sender.transfer(amount);

            

            WithdrawalFunds(msg.sender, amount);

        }

    }

    

    /**

   * @dev \ud06c\ub77c\uc6b0\ub4dc \uc138\uc77c\uc774 \uc9c4\ud589 \uc911\uc778\uc9c0 \uc5ec\ubd80\ub97c \ubc18\ud658\ud55c\ub2e4.

   * @return isOpened true: \uc9c4\ud589 \uc911 false : \uc9c4\ud589 \uc911\uc774 \uc544\ub2d8(\ucc38\uc5ec \ubd88\uac00)

   */

    function isOpened() public view returns (bool isOpend) {

        if(now < startTime) return false;

        if(now >= endTime) return false;

        if(closed == true) return false;

        

        return true;

    }

}

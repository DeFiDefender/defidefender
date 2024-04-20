/**************



 * Copyright Art Blocks LLC 2020. www.artblocks.io.

 *************/









// File: openzeppelin-solidity/contracts/math/SafeMath.sol







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



// File: openzeppelin-solidity/contracts/utils/Address.sol



pragma solidity ^0.5.0;



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



// File: openzeppelin-solidity/contracts/drafts/Counters.sol



pragma solidity ^0.5.0;





/**

 * @title Counters

 * @author Matt Condon (@shrugs)

 * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number

 * of elements in a mapping, issuing ERC721 ids, or counting request ids.

 *

 * Include with `using Counters for Counters.Counter;`

 * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath

 * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never

 * directly accessed.

 */

library Counters {

    using SafeMath for uint256;



    struct Counter {

        // This variable should never be directly accessed by users of the library: interactions must be restricted to

        // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add

        // this feature: see https://github.com/ethereum/solidity/issues/4637

        uint256 _value; // default: 0

    }



    function current(Counter storage counter) internal view returns (uint256) {

        return counter._value;

    }



    function increment(Counter storage counter) internal {

        counter._value += 1;

    }



    function decrement(Counter storage counter) internal {

        counter._value = counter._value.sub(1);

    }

}



// File: contracts/Strings.sol



pragma solidity ^0.5.0;



//https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol

library Strings {



    function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {

        return strConcat(_a, _b, "", "", "");

    }



    function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {

        return strConcat(_a, _b, _c, "", "");

    }



    function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {

        return strConcat(_a, _b, _c, _d, "");

    }



    function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {

        bytes memory _ba = bytes(_a);

        bytes memory _bb = bytes(_b);

        bytes memory _bc = bytes(_c);

        bytes memory _bd = bytes(_d);

        bytes memory _be = bytes(_e);

        string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);

        bytes memory babcde = bytes(abcde);

        uint k = 0;

        uint i = 0;

        for (i = 0; i < _ba.length; i++) {

            babcde[k++] = _ba[i];

        }

        for (i = 0; i < _bb.length; i++) {

            babcde[k++] = _bb[i];

        }

        for (i = 0; i < _bc.length; i++) {

            babcde[k++] = _bc[i];

        }

        for (i = 0; i < _bd.length; i++) {

            babcde[k++] = _bd[i];

        }

        for (i = 0; i < _be.length; i++) {

            babcde[k++] = _be[i];

        }

        return string(babcde);

    }



    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {

        if (_i == 0) {

            return "0";

        }

        uint j = _i;

        uint len;

        while (j != 0) {

            len++;

            j /= 10;

        }

        bytes memory bstr = new bytes(len);

        uint k = len - 1;

        while (_i != 0) {

            bstr[k--] = byte(uint8(48 + _i % 10));

            _i /= 10;

        }

        return string(bstr);

    }

}







pragma solidity ^0.5.0;



interface KOPrintRegistryInterface {

    

    function mint(uint256 _artId, string calldata _nfc) external returns (uint256 _tokenId); 

}



pragma solidity ^0.5.0;



interface KOv1Interface {

    

    function ownerOf(uint256 _artId) external view returns (address); 

}



pragma solidity ^0.5.0;



interface KOv2Interface {

    

    function ownerOf(uint256 _artId) external view returns (address); 

}







// File: contracts/PunkPrintRegistryMinter.sol



pragma solidity ^0.5.0;



contract KOPrintRegistryMinter  {

    using SafeMath for uint256;



    ///////////////

    // Variables //

    ///////////////





    KOPrintRegistryInterface public koprContract;

    KOv1Interface public kov1Contract;

    KOv2Interface public kov2Contract;



    address public owner1;

    address public owner2;



    mapping(address => uint256) public addressToCreditsToSpend;



    mapping(address => uint256) public managerAddressToCreditsToGive;











    /////////////////

    // Constructor //

    /////////////////



    constructor(address _owner2, address _registryContract) public {



        koprContract = KOPrintRegistryInterface(_registryContract);

        kov1Contract = KOv1Interface(0xDdE2D979e8d39BB8416eAfcFC1758f3CaB2C9C72);

        kov2Contract = KOv2Interface(0xFBeef911Dc5821886e1dda71586d90eD28174B7d);

        

        owner1 = msg.sender;

        owner2 = _owner2;



    }







    //////////////////////////////

    // Minting Function         //

    //////////////////////////////



    function mint(uint256 _artId, string memory _contactMethodAndType) public returns (uint256 _tokenId) {

        uint256 balance = addressToCreditsToSpend[msg.sender];

        if (_artId<304){

        require(msg.sender == kov1Contract.ownerOf(_artId), "You must own artwork.");

        } else {

        require(msg.sender == kov2Contract.ownerOf(_artId), "You must own artwork.");

        }

        require(balance>0, "You must have credits!");

        uint256 mintedToken = koprContract.mint(_artId, _contactMethodAndType); 

        addressToCreditsToSpend[msg.sender] --;

        return mintedToken;

    }



    //////////////////////////////

    // Manager Function         //

    //////////////////////////////



    function giveCredit(address _recipient) public {

        uint creditsToGive = managerAddressToCreditsToGive[msg.sender];

        require(creditsToGive>0 || msg.sender==owner1 || msg.sender==owner2 , "You must have permission!");

        addressToCreditsToSpend[_recipient] ++;

        managerAddressToCreditsToGive[msg.sender] --;

    }



    //////////////////////////////

    // Owner Functions          //

    //////////////////////////////



    function setManagerCredits(address _manager, uint _credits) public returns (bool) {

        require(msg.sender == owner1 || msg.sender == owner2);

        managerAddressToCreditsToGive[_manager]=_credits;

        return true;

    }



    function removeManager(address _manager) public returns (bool) {

        require(msg.sender == owner1 || msg.sender == owner2);

        managerAddressToCreditsToGive[_manager]=0;

        return true;

    }



}

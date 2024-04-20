// File: @openzeppelin\\contracts\\math\\SafeMath.sol



// SPDX-License-Identifier: MIT



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



// File: @openzeppelin\\contracts\\GSN\\Context.sol







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



// File: contracts\\MyOwnable.sol







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

contract MyOwnable is Context {

    address private _owner;



    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);



    /**

     * @dev Initializes the contract.

     */

    constructor (address o) internal {

        _owner = o;

        emit OwnershipTransferred(address(0), o);

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



// File: node_modules\\@openzeppelin\\contracts\\introspection\\IERC165.sol







pragma solidity ^0.6.0;



/**

 * @dev Interface of the ERC165 standard, as defined in the

 * https://eips.ethereum.org/EIPS/eip-165[EIP].

 *

 * Implementers can declare support of contract interfaces, which can then be

 * queried by others ({ERC165Checker}).

 *

 * For an implementation, see {ERC165}.

 */

interface IERC165 {

    /**

     * @dev Returns true if this contract implements the interface defined by

     * `interfaceId`. See the corresponding

     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]

     * to learn more about how these ids are created.

     *

     * This function call must use less than 30 000 gas.

     */

    function supportsInterface(bytes4 interfaceId) external view returns (bool);

}



// File: node_modules\\@openzeppelin\\contracts  oken\\ERC1155\\IERC1155Receiver.sol







pragma solidity ^0.6.0;





/**

 * _Available since v3.1._

 */

interface IERC1155Receiver is IERC165 {



    /**

        @dev Handles the receipt of a single ERC1155 token type. This function is

        called at the end of a `safeTransferFrom` after the balance has been updated.

        To accept the transfer, this must return

        `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`

        (i.e. 0xf23a6e61, or its own function selector).

        @param operator The address which initiated the transfer (i.e. msg.sender)

        @param from The address which previously owned the token

        @param id The ID of the token being transferred

        @param value The amount of tokens being transferred

        @param data Additional data with no specified format

        @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed

    */

    function onERC1155Received(

        address operator,

        address from,

        uint256 id,

        uint256 value,

        bytes calldata data

    )

        external

        returns(bytes4);



    /**

        @dev Handles the receipt of a multiple ERC1155 token types. This function

        is called at the end of a `safeBatchTransferFrom` after the balances have

        been updated. To accept the transfer(s), this must return

        `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`

        (i.e. 0xbc197c81, or its own function selector).

        @param operator The address which initiated the batch transfer (i.e. msg.sender)

        @param from The address which previously owned the token

        @param ids An array containing ids of each token being transferred (order and length must match values array)

        @param values An array containing amounts of each token being transferred (order and length must match ids array)

        @param data Additional data with no specified format

        @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed

    */

    function onERC1155BatchReceived(

        address operator,

        address from,

        uint256[] calldata ids,

        uint256[] calldata values,

        bytes calldata data

    )

        external

        returns(bytes4);

}



// File: node_modules\\@openzeppelin\\contracts\\introspection\\ERC165.sol







pragma solidity ^0.6.0;





/**

 * @dev Implementation of the {IERC165} interface.

 *

 * Contracts may inherit from this and call {_registerInterface} to declare

 * their support of an interface.

 */

contract ERC165 is IERC165 {

    /*

     * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7

     */

    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;



    /**

     * @dev Mapping of interface ids to whether or not it's supported.

     */

    mapping(bytes4 => bool) private _supportedInterfaces;



    constructor () internal {

        // Derived contracts need only register support for their own interfaces,

        // we register support for ERC165 itself here

        _registerInterface(_INTERFACE_ID_ERC165);

    }



    /**

     * @dev See {IERC165-supportsInterface}.

     *

     * Time complexity O(1), guaranteed to always use less than 30 000 gas.

     */

    function supportsInterface(bytes4 interfaceId) public view override returns (bool) {

        return _supportedInterfaces[interfaceId];

    }



    /**

     * @dev Registers the contract as an implementer of the interface defined by

     * `interfaceId`. Support of the actual ERC165 interface is automatic and

     * registering its interface id is not required.

     *

     * See {IERC165-supportsInterface}.

     *

     * Requirements:

     *

     * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).

     */

    function _registerInterface(bytes4 interfaceId) internal virtual {

        require(interfaceId != 0xffffffff, "ERC165: invalid interface id");

        _supportedInterfaces[interfaceId] = true;

    }

}



// File: node_modules\\@openzeppelin\\contracts  oken\\ERC1155\\ERC1155Receiver.sol







pragma solidity ^0.6.0;







/**

 * @dev _Available since v3.1._

 */

abstract contract ERC1155Receiver is ERC165, IERC1155Receiver {

    constructor() public {

        _registerInterface(

            ERC1155Receiver(0).onERC1155Received.selector ^

            ERC1155Receiver(0).onERC1155BatchReceived.selector

        );

    }

}



// File: @openzeppelin\\contracts  oken\\ERC1155\\ERC1155Holder.sol







pragma solidity ^0.6.0;





/**

 * @dev _Available since v3.1._

 */

contract ERC1155Holder is ERC1155Receiver {

    function onERC1155Received(address, address, uint256, uint256, bytes memory) public virtual override returns (bytes4) {

        return this.onERC1155Received.selector;

    }



    function onERC1155BatchReceived(address, address, uint256[] memory, uint256[] memory, bytes memory) public virtual override returns (bytes4) {

        return this.onERC1155BatchReceived.selector;

    }

}



// File: contracts\\ICHI.sol



pragma solidity >=0.5.0;



interface ICHI {

    function freeFromUpTo(address from, uint256 value) external returns (uint256);

    function freeUpTo(uint256 value) external returns (uint256);



}



// File: contracts\\CHIUser.sol



pragma solidity ^0.6.0;





abstract contract CHIUser {

    ICHI public chi;



    modifier discountCHI {

        uint256 gasStart = gasleft();

        _;

        uint256 gasSpent = 21000 + gasStart - gasleft() + 16 *

                        msg.data.length;

        // if (address(chi) != address(0)){

        chi.freeFromUpTo(msg.sender, (gasSpent + 14154) / 41947);

        // }

    }

    constructor(address _chi) public{

        chi = ICHI(_chi);

    }

}



// File: contracts\\TMADispense.sol



pragma solidity ^0.6.12;











interface IERC1155 {

    // function mint(address to, uint256 id, uint256 amount, bytes memory data) external;

    function balanceOf(address a, uint256 id) external returns (uint256);

    function safeTransferFrom(

        address from,

        address to,

        uint256 id,

        uint256 amount,

        bytes memory data

    ) external;

    function mint(address _to, uint256 _id, uint256 _quantity, bytes memory _data) external;



}



interface IERC20{

    function mint(address to, uint256 amount) external;

    function balanceOf(address a) external returns (uint256);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

}

// to dispense stuff for a certian TMC price.

contract TMADispense is 

    MyOwnable, ERC1155Holder, CHIUser

{

    using SafeMath for uint256;

    // using SafeERC20 for IERC20;



    IERC1155 public tma;

    IERC20 public tmc;



    uint256 public percentToLock = 16;





    mapping (address => mapping(uint256 => uint256)) public purchasedPerAcc; // address => tokenId => amt sold

    // mapping (uint256 => bool) public forSale; // equipId => bool

    // mapping (uint256 => uint256) public amtSold; // equipId => amtSold

    // mapping (uint256 => uint256) public capPerAcc; // equipId => cap



    struct EquipSales {

        bool isForSale;

        uint256 amtSold;

        uint256 capSold;

        uint256 capPerAdd; // 0 means no cap

        uint256 tmcForEach; // 0 means free

        bool isExists;

    }

    mapping (uint256 => EquipSales) public allSales;

    mapping (address => bool) public authorizedClaimer;





    modifier onlyOwnerOrAuthorised() {

        require(owner() == _msgSender() || authorizedClaimer[address(_msgSender())], "NA");

        _;

    }

    function getPurchased(address acc, uint256 equipId) external view returns (uint256) {

        return purchasedPerAcc[acc][equipId];

    }

    constructor(address owner, address _tma, address _tmc, address _chi) 

        public MyOwnable(owner) CHIUser(_chi) {

        tma = IERC1155(_tma);

        tmc = IERC20(_tmc);

    }

    function setAuthorized(address a, bool b) external onlyOwner{

        authorizedClaimer[a] = b;

    }



    function setSalesInfo(uint256 equipId, bool forSale, uint256 capSold, uint256 capPerAdd, uint256 tmcForEach) external onlyOwner {

        require(allSales[equipId].isExists, "ns");

        allSales[equipId].isForSale = forSale;

        allSales[equipId].capSold = capSold;

        allSales[equipId].capPerAdd = capPerAdd;

        allSales[equipId].tmcForEach = tmcForEach;

    }



    function exchange(uint256 equipId, uint256 amtToReceive) public discountCHI{

        EquipSales storage m = allSales[equipId];

        require(m.isForSale, "ns");

        uint256 purchased = purchasedPerAcc[address(_msgSender())][equipId];

        uint256 afterPurchase = purchased.add(amtToReceive);

        require (m.capPerAdd == 0 || afterPurchase <= m.capPerAdd, "Cap");



        m.amtSold = m.amtSold.add(amtToReceive);

        require(m.capSold == 0 || m.amtSold <= m.capSold, "slmt");



        purchasedPerAcc[_msgSender()][equipId] = afterPurchase;

        if (m.tmcForEach > 0){

        // 4% dev, 4% burn, 4% LP reward, 4% locked liquid

        // 84% to store treasury (out of circulation)

            uint256 spent = amtToReceive.mul(m.tmcForEach);

            uint256 toLock = spent.mul(percentToLock).div(100);

            uint256 toTreasury = spent.sub(toLock);

            require(tmc.transferFrom(_msgSender(), address(tmc), toLock), "F1");

            require(tmc.transferFrom(_msgSender(), address(this), toTreasury), "F2");

        }



        

        tma.mint(_msgSender(), equipId, amtToReceive, "0x0");

    }

    

    function createSales(uint256 equipId, bool b, uint256 capSold, uint256 capPerAdd, uint256 tmcForEach) external onlyOwner{

        allSales[equipId] = EquipSales(b, 0, capSold, capPerAdd, tmcForEach, true);

    }



    function close() external onlyOwner { 

        address payable p = payable(owner());

        selfdestruct(p); 

    }

    function claimProceeds(uint256 bal) external onlyOwnerOrAuthorised{

        tmc.transferFrom(address(this), _msgSender(), bal);

    }

    function claimERC1155(address a, uint256 equipId) external onlyOwner {

        IERC1155 token = IERC1155(a);

        uint256 bal = token.balanceOf(address(this), equipId);

        IERC1155(a).safeTransferFrom(address(this), _msgSender(), equipId, bal, "0x0");

    }

    function setTma(address a) external onlyOwner {

        tma = IERC1155(a);

    }

    function setTmc(address a) external onlyOwner {

        tmc = IERC20(a);

    }

    function setPercentToLock(uint256 percent) external onlyOwner{

        percentToLock = percent;

    }

}

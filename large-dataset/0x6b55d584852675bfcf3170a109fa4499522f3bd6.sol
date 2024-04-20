/*

 * Crypto stamp 2 Pre-sale Direct-Pay Contract

 * Buy ERC 1155 pre-sale tokens via direct, standard ETH transaction

 *

 * Developed by Capacity Blockchain Solutions GmbH <capacity.at>

 * for \u00d6sterreichische Post AG <post.at>

 */



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



// File: @openzeppelin/contracts/introspection/IERC165.sol



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



// File: @openzeppelin/contracts/token/ERC721/IERC721.sol



pragma solidity ^0.6.0;





/**

 * @dev Required interface of an ERC721 compliant contract.

 */

abstract contract IERC721 is IERC165 {

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);



    /**

     * @dev Returns the number of NFTs in `owner`'s account.

     */

    function balanceOf(address owner) public view virtual returns (uint256 balance);



    /**

     * @dev Returns the owner of the NFT specified by `tokenId`.

     */

    function ownerOf(uint256 tokenId) public view virtual returns (address owner);



    /**

     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to

     * another (`to`).

     *

     *

     *

     * Requirements:

     * - `from`, `to` cannot be zero.

     * - `tokenId` must be owned by `from`.

     * - If the caller is not `from`, it must be have been allowed to move this

     * NFT by either {approve} or {setApprovalForAll}.

     */

    function safeTransferFrom(address from, address to, uint256 tokenId) public virtual;

    /**

     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to

     * another (`to`).

     *

     * Requirements:

     * - If the caller is not `from`, it must be approved to move this NFT by

     * either {approve} or {setApprovalForAll}.

     */

    function transferFrom(address from, address to, uint256 tokenId) public virtual;

    function approve(address to, uint256 tokenId) public virtual;

    function getApproved(uint256 tokenId) public view virtual returns (address operator);



    function setApprovalForAll(address operator, bool _approved) public virtual;

    function isApprovedForAll(address owner, address operator) public view virtual returns (bool);





    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public virtual;

}



// File: @openzeppelin/contracts/token/ERC20/IERC20.sol



pragma solidity ^0.6.0;



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



// File: contracts/ENSReverseRegistrarI.sol



/*

 * Interfaces for ENS Reverse Registrar

 * See https://github.com/ensdomains/ens/blob/master/contracts/ReverseRegistrar.sol for full impl

 * Also see https://github.com/wealdtech/wealdtech-solidity/blob/master/contracts/ens/ENSReverseRegister.sol

 *

 * Use this as follows (registryAddress is the address of the ENS registry to use):

 * -----

 * // This hex value is caclulated by namehash('addr.reverse')

 * bytes32 public constant ENS_ADDR_REVERSE_NODE = 0x91d1777781884d03a6757a803996e38de2a42967fb37eeaca72729271025a9e2;

 * function registerReverseENS(address registryAddress, string memory calldata) external {

 *     require(registryAddress != address(0), "need a valid registry");

 *     address reverseRegistrarAddress = ENSRegistryOwnerI(registryAddress).owner(ENS_ADDR_REVERSE_NODE)

 *     require(reverseRegistrarAddress != address(0), "need a valid reverse registrar");

 *     ENSReverseRegistrarI(reverseRegistrarAddress).setName(name);

 * }

 * -----

 * or

 * -----

 * function registerReverseENS(address reverseRegistrarAddress, string memory calldata) external {

 *    require(reverseRegistrarAddress != address(0), "need a valid reverse registrar");

 *     ENSReverseRegistrarI(reverseRegistrarAddress).setName(name);

 * }

 * -----

 * ENS deployments can be found at https://docs.ens.domains/ens-deployments

 * For Mainnet, 0x9062c0a6dbd6108336bcbe4593a3d1ce05512069 is the reverseRegistrarAddress,

 * for Ropsten, it is at 0x67d5418a000534a8F1f5FF4229cC2f439e63BBe2.

 */

pragma solidity ^0.6.0;



interface ENSRegistryOwnerI {

    function owner(bytes32 node) external view returns (address);

}



interface ENSReverseRegistrarI {

    function setName(string calldata name) external returns (bytes32 node);

}



// File: contracts/CS2PresaleIBuyDP.sol



/*

Interfacte for CS2 on-chain presale for usage with DirectPay contracts.

*/

pragma solidity ^0.6.0;



abstract contract CS2PresaleIBuyDP {

    enum AssetType {

        Honeybadger,

        Llama,

        Panda,

        Doge

    }



    // Buy assets of a single type/animal. The number of assets is determined from the amount of ETH sent.

    // This variant will be used externally from the CS2PresaleDirectPay contracts, which need to buy for _their_ msg.sender.

    function buy(AssetType _type, address payable _recipient) public payable virtual;



}



// File: contracts/CS2PresaleDirectPay.sol



/*

Implements an on-chain presale for Crypto stamp Edition 2

*/

pragma solidity ^0.6.0;













contract CS2PresaleDirectPay {

    using SafeMath for uint256;



    address public tokenAssignmentControl;



    CS2PresaleIBuyDP public presale;

    CS2PresaleIBuyDP.AssetType public assetType;



    event TokenAssignmentControlTransferred(address indexed previousTokenAssignmentControl, address indexed newTokenAssignmentControl);



    constructor(CS2PresaleIBuyDP _presale,

        CS2PresaleIBuyDP.AssetType _assetType,

        address _tokenAssignmentControl)

    public

    {

        presale = _presale;

        require(address(presale) != address(0x0), "You need to provide an actual presale contract.");

        assetType = _assetType;

        tokenAssignmentControl = _tokenAssignmentControl;

        require(address(tokenAssignmentControl) != address(0x0), "You need to provide an actual tokenAssignmentControl address.");

    }



    modifier onlyTokenAssignmentControl() {

        require(msg.sender == tokenAssignmentControl, "tokenAssignmentControl key required for this function.");

        _;

    }



    /*** Enable adjusting variables after deployment ***/



    function transferTokenAssignmentControl(address _newTokenAssignmentControl)

    public

    onlyTokenAssignmentControl

    {

        require(_newTokenAssignmentControl != address(0), "tokenAssignmentControl cannot be the zero address.");

        emit TokenAssignmentControlTransferred(tokenAssignmentControl, _newTokenAssignmentControl);

        tokenAssignmentControl = _newTokenAssignmentControl;

    }



    /*** Actual presale functionality ***/



    // Buy assets of a single type/animal. The number of assets is determined from the amount of ETH sent.

    receive()

    external payable

    {

        presale.buy{value: msg.value}(assetType, msg.sender);

    }



    /*** Enable reverse ENS registration ***/



    // Call this with the address of the reverse registrar for the respecitve network and the ENS name to register.

    // The reverse registrar can be found as the owner of 'addr.reverse' in the ENS system.

    // For Mainnet, the address needed is 0x9062c0a6dbd6108336bcbe4593a3d1ce05512069

    function registerReverseENS(address _reverseRegistrarAddress, string calldata _name)

    external

    onlyTokenAssignmentControl

    {

        require(_reverseRegistrarAddress != address(0), "need a valid reverse registrar");

        ENSReverseRegistrarI(_reverseRegistrarAddress).setName(_name);

    }



    /*** Make sure currency or NFT doesn't get stranded in this contract ***/



    // If this contract gets a balance in some ERC20 contract after it's finished, then we can rescue it.

    function rescueToken(IERC20 _foreignToken, address _to)

    external

    onlyTokenAssignmentControl

    {

        _foreignToken.transfer(_to, _foreignToken.balanceOf(address(this)));

    }



    // If this contract gets a balance in some ERC721 contract after it's finished, then we can rescue it.

    function approveNFTrescue(IERC721 _foreignNFT, address _to)

    external

    onlyTokenAssignmentControl

    {

        _foreignNFT.setApprovalForAll(_to, true);

    }



}

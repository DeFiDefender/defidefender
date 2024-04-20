// File: openzeppelin-solidity/contracts/ownership/Ownable.sol



pragma solidity ^0.5.0;



/**

 * @title Ownable

 * @dev The Ownable contract has an owner address, and provides basic authorization control

 * functions, this simplifies the implementation of "user permissions".

 */

contract Ownable {

    address private _owner;



    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);



    /**

     * @dev The Ownable constructor sets the original `owner` of the contract to the sender

     * account.

     */

    constructor () internal {

        _owner = msg.sender;

        emit OwnershipTransferred(address(0), _owner);

    }



    /**

     * @return the address of the owner.

     */

    function owner() public view returns (address) {

        return _owner;

    }



    /**

     * @dev Throws if called by any account other than the owner.

     */

    modifier onlyOwner() {

        require(isOwner());

        _;

    }



    /**

     * @return true if `msg.sender` is the owner of the contract.

     */

    function isOwner() public view returns (bool) {

        return msg.sender == _owner;

    }



    /**

     * @dev Allows the current owner to relinquish control of the contract.

     * @notice Renouncing to ownership will leave the contract without an owner.

     * It will not be possible to call the functions with the `onlyOwner`

     * modifier anymore.

     */

    function renounceOwnership() public onlyOwner {

        emit OwnershipTransferred(_owner, address(0));

        _owner = address(0);

    }



    /**

     * @dev Allows the current owner to transfer control of the contract to a newOwner.

     * @param newOwner The address to transfer ownership to.

     */

    function transferOwnership(address newOwner) public onlyOwner {

        _transferOwnership(newOwner);

    }



    /**

     * @dev Transfers control of the contract to a newOwner.

     * @param newOwner The address to transfer ownership to.

     */

    function _transferOwnership(address newOwner) internal {

        require(newOwner != address(0));

        emit OwnershipTransferred(_owner, newOwner);

        _owner = newOwner;

    }

}



// File: @ensdomains/ens/contracts/ENS.sol



pragma solidity >=0.4.24;



interface ENS {



    // Logged when the owner of a node assigns a new owner to a subnode.

    event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);



    // Logged when the owner of a node transfers ownership to a new account.

    event Transfer(bytes32 indexed node, address owner);



    // Logged when the resolver for a node changes.

    event NewResolver(bytes32 indexed node, address resolver);



    // Logged when the TTL of a node changes

    event NewTTL(bytes32 indexed node, uint64 ttl);





    function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external;

    function setResolver(bytes32 node, address resolver) external;

    function setOwner(bytes32 node, address owner) external;

    function setTTL(bytes32 node, uint64 ttl) external;

    function owner(bytes32 node) external view returns (address);

    function resolver(bytes32 node) external view returns (address);

    function ttl(bytes32 node) external view returns (uint64);



}



// File: @ensdomains/ens/contracts/Deed.sol



pragma solidity >=0.4.24;



interface Deed {



    function setOwner(address payable newOwner) external;

    function setRegistrar(address newRegistrar) external;

    function setBalance(uint newValue, bool throwOnFailure) external;

    function closeDeed(uint refundRatio) external;

    function destroyDeed() external;



    function owner() external view returns (address);

    function previousOwner() external view returns (address);

    function value() external view returns (uint);

    function creationDate() external view returns (uint);



}



// File: @ensdomains/ens/contracts/Registrar.sol



pragma solidity >=0.4.24;





interface Registrar {



    enum Mode { Open, Auction, Owned, Forbidden, Reveal, NotYetAvailable }



    event AuctionStarted(bytes32 indexed hash, uint registrationDate);

    event NewBid(bytes32 indexed hash, address indexed bidder, uint deposit);

    event BidRevealed(bytes32 indexed hash, address indexed owner, uint value, uint8 status);

    event HashRegistered(bytes32 indexed hash, address indexed owner, uint value, uint registrationDate);

    event HashReleased(bytes32 indexed hash, uint value);

    event HashInvalidated(bytes32 indexed hash, string indexed name, uint value, uint registrationDate);



    function state(bytes32 _hash) external view returns (Mode);

    function startAuction(bytes32 _hash) external;

    function startAuctions(bytes32[] calldata _hashes) external;

    function newBid(bytes32 sealedBid) external payable;

    function startAuctionsAndBid(bytes32[] calldata hashes, bytes32 sealedBid) external payable;

    function unsealBid(bytes32 _hash, uint _value, bytes32 _salt) external;

    function cancelBid(address bidder, bytes32 seal) external;

    function finalizeAuction(bytes32 _hash) external;

    function transfer(bytes32 _hash, address payable newOwner) external;

    function releaseDeed(bytes32 _hash) external;

    function invalidateName(string calldata unhashedName) external;

    function eraseNode(bytes32[] calldata labels) external;

    function transferRegistrars(bytes32 _hash) external;

    function acceptRegistrarTransfer(bytes32 hash, Deed deed, uint registrationDate) external;

    function entries(bytes32 _hash) external view returns (Mode, address, uint, uint, uint);

}



// File: openzeppelin-solidity/contracts/introspection/IERC165.sol



pragma solidity ^0.5.0;



/**

 * @title IERC165

 * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md

 */

interface IERC165 {

    /**

     * @notice Query if a contract implements an interface

     * @param interfaceId The interface identifier, as specified in ERC-165

     * @dev Interface identification is specified in ERC-165. This function

     * uses less than 30,000 gas.

     */

    function supportsInterface(bytes4 interfaceId) external view returns (bool);

}



// File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol



pragma solidity ^0.5.0;





/**

 * @title ERC721 Non-Fungible Token Standard basic interface

 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md

 */

contract IERC721 is IERC165 {

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);



    function balanceOf(address owner) public view returns (uint256 balance);

    function ownerOf(uint256 tokenId) public view returns (address owner);



    function approve(address to, uint256 tokenId) public;

    function getApproved(uint256 tokenId) public view returns (address operator);



    function setApprovalForAll(address operator, bool _approved) public;

    function isApprovedForAll(address owner, address operator) public view returns (bool);



    function transferFrom(address from, address to, uint256 tokenId) public;

    function safeTransferFrom(address from, address to, uint256 tokenId) public;



    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;

}



// File: contracts/BaseRegistrar.sol



pragma solidity >=0.4.24;











contract BaseRegistrar is IERC721, Ownable {

    uint constant public GRACE_PERIOD = 90 days;



    event ControllerAdded(address indexed controller);

    event ControllerRemoved(address indexed controller);

    event NameMigrated(uint256 indexed id, address indexed owner, uint expires);

    event NameRegistered(uint256 indexed id, address indexed owner, uint expires);

    event NameRenewed(uint256 indexed id, uint expires);



    // Expiration timestamp for migrated domains.

    uint public transferPeriodEnds;



    // The ENS registry

    ENS public ens;



    // The namehash of the TLD this registrar owns (eg, .eth)

    bytes32 public baseNode;



    // The interim registrar

    Registrar public previousRegistrar;



    // A map of addresses that are authorised to register and renew names.

    mapping(address=>bool) public controllers;



    // Authorises a controller, who can register and renew domains.

    function addController(address controller) external;



    // Revoke controller permission for an address.

    function removeController(address controller) external;



    // Set the resolver for the TLD this registrar manages.

    function setResolver(address resolver) external;



    // Returns the expiration timestamp of the specified label hash.

    function nameExpires(uint256 id) external view returns(uint);



    // Returns true iff the specified name is available for registration.

    function available(uint256 id) public view returns(bool);



    /**

     * @dev Register a name.

     */

    function register(uint256 id, address owner, uint duration) external returns(uint);



    function renew(uint256 id, uint duration) external returns(uint);



    /**

     * @dev Reclaim ownership of a name in ENS, if you own it in the registrar.

     */

    function reclaim(uint256 id, address owner) external;



    /**

     * @dev Transfers a registration from the initial registrar.

     * This function is called by the initial registrar when a user calls `transferRegistrars`.

     */

    function acceptRegistrarTransfer(bytes32 label, Deed deed, uint) external;

}



// File: contracts/StringUtils.sol



pragma solidity >=0.4.24;



library StringUtils {

    /**

     * @dev Returns the length of a given string

     *

     * @param s The string to measure the length of

     * @return The length of the input string

     */

    function strlen(string memory s) internal pure returns (uint) {

        uint len;

        uint i = 0;

        uint bytelength = bytes(s).length;

        for(len = 0; i < bytelength; len++) {

            byte b = bytes(s)[i];

            if(b < 0x80) {

                i += 1;

            } else if (b < 0xE0) {

                i += 2;

            } else if (b < 0xF0) {

                i += 3;

            } else if (b < 0xF8) {

                i += 4;

            } else if (b < 0xFC) {

                i += 5;

            } else {

                i += 6;

            }

        }

        return len;

    }

}



// File: contracts/ShortNameAuctionController.sol



pragma solidity ^0.5.0;









interface ProxyRegistry {

    function proxies(address owner) external view returns(address);

}



contract ShortNameAuctionController is Ownable {

    using StringUtils for *;



    uint constant public REGISTRATION_PERIOD = 31536000;



    event NameRegistered(string name, address owner);



    BaseRegistrar public base;

    ProxyRegistry public proxies;

    address public opensea;



    modifier onlyOpensea {

        require(msg.sender == opensea || msg.sender == proxies.proxies(opensea));

        _;

    }



    constructor(BaseRegistrar _base, ProxyRegistry _proxies, address _opensea) public {

        base = _base;

        proxies = _proxies;

        opensea = _opensea;

    }



    function valid(string memory name) public view returns(bool) {

        uint len = name.strlen();

        return len >= 3 && len <= 6;

    }



    function available(string memory name) public view returns(bool) {

        return valid(name) && base.available(getTokenId(name));

    }



    function register(string calldata name, address owner) external onlyOpensea {

        require(available(name));

        base.register(getTokenId(name), owner, REGISTRATION_PERIOD);

        emit NameRegistered(name, owner);

    }



    function setOpensea(address _opensea) external onlyOwner {

        opensea = _opensea;

    }



    function getTokenId(string memory name) internal pure returns(uint256) {

        return uint256(keccak256(bytes(name)));

    }

}

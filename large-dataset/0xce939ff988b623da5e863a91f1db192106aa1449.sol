pragma solidity ^0.5.2;


contract EntityDataInterface {

    address public tokenAddr;

    mapping(uint256 => Entity) public entityData;
    mapping(uint256 => address) public siringApprovedTo;

    event UpdateRootHash (
        uint256 tokenId,
        bytes rootHash
    );

    event Birth (
        uint256 tokenId,
        address owner,
        uint256 matronId,
        uint256 sireId
    );

    struct Entity {
        bytes rootHash;
        uint256 birthTime;
        uint256 cooldownEndTime;
        uint256 matronId;
        uint256 sireId;
        uint256 generation;
    }

    function updateRootHash(uint256 tokenId, bytes calldata rootHash) external;

    function createEntity(address owner, uint256 tokenId, uint256 _generation, uint256 _matronId, uint256 _sireId, uint256 _birthTime) public;

    function getEntity(uint256 tokenId)
      external
      view
      returns(
            uint256 birthTime,
            uint256 cooldownEndTime,
            uint256 matronId,
            uint256 sireId,
            uint256 generation
        );

    function setCooldownEndTime(uint256 tokenId, uint256 _cooldownEndTime) external;

    function approveSiring(uint256 sireId, address approveTo) external;

    function clearSiringApproval(uint256 sireId) external;

    function isSiringApprovedTo(uint256 tokenId, address borrower)
        external
        view
        returns(bool);

    function isReadyForFusion(uint256 tokenId)
        external
        view
        returns (bool ready);
}

contract RoleManager {

    mapping(address => bool) private admins;
    mapping(address => bool) private controllers;

    modifier onlyAdmins {
        require(admins[msg.sender], 'only admins');
        _;
    }

    modifier onlyControllers {
        require(controllers[msg.sender], 'only controllers');
        _;
    } 

    constructor() public {
        admins[msg.sender] = true;
        controllers[msg.sender] = true;
    }

    function addController(address _newController) external onlyAdmins{
        controllers[_newController] = true;
    } 

    function addAdmin(address _newAdmin) external onlyAdmins{
        admins[_newAdmin] = true;
    } 

    function removeController(address _controller) external onlyAdmins{
        controllers[_controller] = false;
    } 
    
    function removeAdmin(address _admin) external onlyAdmins{
        require(_admin != msg.sender, 'unexecutable operation'); 
        admins[_admin] = false;
    } 

    function isAdmin(address addr) external view returns (bool) {
        return (admins[addr]);
    }

    function isController(address addr) external view returns (bool) {
        return (controllers[addr]);
    }

}

contract AccessController {

    address roleManagerAddr;

    modifier onlyAdmins {
        require(RoleManager(roleManagerAddr).isAdmin(msg.sender), 'only admins');
        _;
    }

    modifier onlyControllers {
        require(RoleManager(roleManagerAddr).isController(msg.sender), 'only controllers');
        _;
    }

    constructor (address _roleManagerAddr) public {
        require(_roleManagerAddr != address(0), '_roleManagerAddr: Invalid address (zero address)');
        roleManagerAddr = _roleManagerAddr;
    }

}

interface ERC165Interface {
    
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

contract ERC721Interface is ERC165Interface {
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

library SafeMath {
    
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        
        
        
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        
        require(b > 0);
        uint256 c = a / b;
        

        return c;
    }

    
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

contract Market is AccessController{
    using SafeMath for uint256;
 
    mapping(uint256 => Deal) public tokenIdToDeal;
    address public tokenAddr;
    address public entityDataAddr;
    uint256 public feeBasisPoint;
    address payable public feeTransferToAddr;

    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;

    event Dealt (
        uint256 tokenId,
        uint256 priceWei,
        address seller,
        address buyer,
        uint256 dealtAt
    );

    event Ask (
        address owner,
        uint256 tokenId,
        uint256 priceWei,
        uint256 saleStartedAt,
        uint256 saleEndTime
    );

    event Cancel(
        uint256 tokenId,
        uint256 canceledAt
    );

    struct Deal {
        address owner;
        uint256 priceWei;
        uint256 saleStartedAt;
        uint256 saleEndTime;
    }

    constructor(
        address _entityDataAddr,
        address _roleManagerAddr
    )
      public
      AccessController(_roleManagerAddr)
    {
        require(_entityDataAddr != address(0), '_entityDataAddr: Invalid address (zero address)');
        entityDataAddr = _entityDataAddr;
        tokenAddr = EntityDataInterface(entityDataAddr).tokenAddr();
        require(ERC721Interface(tokenAddr).supportsInterface(_INTERFACE_ID_ERC721));

        feeBasisPoint = 0;
        feeTransferToAddr = msg.sender;
    }

    function setFee(uint256 _feeBasisPoint) external onlyAdmins {
        
        require(_feeBasisPoint <= 10000, 'Invalid feeBasisPoint');
        feeBasisPoint = _feeBasisPoint;
    }
   
    function setWallet(address payable _feeTransferToAddr) external onlyAdmins {
        feeTransferToAddr = _feeTransferToAddr;
    }
    
    function addDeal(uint256 tokenId, uint256 _priceWei, uint256 _saleEndTime) public {
        require(ERC721Interface(tokenAddr).ownerOf(tokenId) == msg.sender, 'msg.sender is not the owner of the given tokenId');
        require(_priceWei > 0, 'Invalid price');
        
        require(_saleEndTime > uint256(now), 'Invalid saleEndTime');

        Deal memory newDeal = Deal({
            saleStartedAt : block.timestamp,
            saleEndTime : _saleEndTime,
            priceWei : _priceWei,
            owner : msg.sender
        });

        emit Ask(newDeal.owner, tokenId, newDeal.priceWei, newDeal.saleStartedAt, newDeal.saleEndTime);

        tokenIdToDeal[tokenId] = newDeal;
    }

    function currentPrice(uint256 tokenId) external view returns(uint256 currentPriceWei);

    function cancel(uint256 tokenId) external {
        
        require(tokenIdToDeal[tokenId].owner == msg.sender || tokenIdToDeal[tokenId].saleEndTime < block.timestamp, 'msg.sender is not the owner of the given tokenId');

        ERC721Interface(tokenAddr).transferFrom(address(this), tokenIdToDeal[tokenId].owner, tokenId);
        
        delete tokenIdToDeal[tokenId];
        emit Cancel(tokenId, block.timestamp);
    }

    function calculateFee(uint256 priceWei) public view returns(uint256 fee) {
        
        uint256 priceToCapFee = 1000000 ether;
        if (priceWei > priceToCapFee) {
          return priceToCapFee.mul(feeBasisPoint).div(10000);
        }
        return priceWei.mul(feeBasisPoint).div(10000);
    }

    function isAsked(uint256 tokenId) public view returns(bool) {
        return (tokenIdToDeal[tokenId].owner != address(0));
    }



}

contract TransferMarket is Market {
    using SafeMath for uint256;

    constructor(
        address _entityDataAddr,
        address _roleManagerAddr
    )
        public
        Market(_entityDataAddr, _roleManagerAddr)
    {
    }

    function addDeal(uint256 tokenId, uint256 _priceWei, uint256 _saleEndTime) public {
      Market.addDeal(tokenId, _priceWei, _saleEndTime);
      ERC721Interface(tokenAddr).transferFrom(msg.sender, address(this), tokenId);
    }

    function bid(uint256 tokenId) external payable {
        require(isAsked(tokenId), 'Not asked');

        Deal memory deal = tokenIdToDeal[tokenId];
        require(deal.saleEndTime >= block.timestamp, 'Sale ended');

        uint256 priceWei = this.currentPrice(tokenId);
        require(msg.value >=  priceWei, 'Insufficient amount of ether');

        uint256 feeWei = calculateFee(priceWei);

        ERC721Interface(tokenAddr).transferFrom(address(this), msg.sender, tokenId);

        emit Dealt(tokenId, deal.priceWei, deal.owner, msg.sender, block.timestamp);

        delete tokenIdToDeal[tokenId];

        
        address payable originalOwner = address(uint160(deal.owner));
        originalOwner.transfer(priceWei.sub(feeWei));
        
        msg.sender.transfer(msg.value.sub(priceWei));
        feeTransferToAddr.transfer(feeWei);
    }

    function currentPrice(uint256 tokenId)
        external
        view
        returns(uint256 currentPriceWei)
    {
        require(isAsked(tokenId), 'Not asked');
        return tokenIdToDeal[tokenId].priceWei;
    }

}

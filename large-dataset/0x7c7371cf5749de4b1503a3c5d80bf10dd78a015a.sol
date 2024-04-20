pragma solidity ^0.5.2;


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

contract FusionInterface {
    using SafeMath for uint256;

    uint256 public fusionFeeWei;
    address public tokenAddr;
    address public entityDataAddr;
    address payable generateRandomEntityAddr;
    uint256 public cooldownPeriod;
    uint256 public incubationTime;
    address payable public adminWalletAddr;
    bool public isFusionDisabled;
    uint256 public idCounter;
    uint256 public constant fusionTypeId = 2;
    uint256 public capDrawByEth;
    uint256 public cntDrawnByEth;

    event Fuse(uint256 matronId, uint256 sireId, uint256 fusionTime);

    function setFusionFee(uint256 newFeeWei) public;

    function setAdminWallet(address payable newWalletAddr) public;

    function fusion(uint256 matronId, uint256 sireId) external payable returns(uint256 childId);

    function isValidFusionPair(uint256 matronId, uint256 sireId)
        public
        view
        returns(bool isValid);

    function setCapDrawByEth(uint256 _cap) external {
        capDrawByEth = _cap;
    }

    function disableFusion() public {
        isFusionDisabled = true;
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

contract SiringMarket is Market {
    using SafeMath for uint256;

    address public fusionAddr;

    constructor(
        address _entityDataAddr,
        address _roleManagerAddr,
        address _fusionAddr
    )
        public
        Market(_entityDataAddr, _roleManagerAddr)
    {
        require(_fusionAddr != address(0), '_fusionAddr: Invalid address (zero address)');
        _setFusionAddress(_fusionAddr);
    }

    function () payable external {

    }

    function addDeal(uint256 tokenId, uint256 _priceWei, uint256 _saleEndTime) public {
        require(EntityDataInterface(entityDataAddr).isReadyForFusion(tokenId), 'Not ready');
        Market.addDeal(tokenId, _priceWei, _saleEndTime);
    }

    function bid(uint256 tokenId, uint256 matronId) external payable {
        require(isAsked(tokenId), 'Not asked');

        
        Deal memory deal = tokenIdToDeal[tokenId];
        require(deal.saleEndTime >= block.timestamp, 'Sale ended');

        uint256 priceWei = this.currentPrice(tokenId);
        uint256 fusionFeeWei = FusionInterface(fusionAddr).fusionFeeWei();
        require(msg.value >=  (priceWei.add(fusionFeeWei)), 'Insufficient amount of ether');

        
        uint256 changeWei = (msg.value.sub(priceWei).sub(fusionFeeWei));

        uint256 marketFeeWei = calculateFee(priceWei);

        
        FusionInterface(fusionAddr).fusion.value(fusionFeeWei)(matronId, tokenId);

        emit Dealt(tokenId, deal.priceWei, deal.owner, msg.sender, block.timestamp);

        
        address payable originalOwner = address(uint160(deal.owner));

        
        originalOwner.transfer(priceWei.sub(marketFeeWei));
        msg.sender.transfer(changeWei);

        require(address(this).balance >= marketFeeWei);
        feeTransferToAddr.transfer(address(this).balance);

    }

    function currentPrice(uint256 tokenId)
        external
        view
        returns(uint256 currentPriceWei)
    {
        require(isAsked(tokenId), 'Not asked');
        return tokenIdToDeal[tokenId].priceWei;
    }

    function setFusionAddress(address _fusionAddr)
        public
        onlyAdmins
    {
      _setFusionAddress(_fusionAddr);
    }

    function _setFusionAddress(address _fusionAddr)
        internal
    {
      require(_fusionAddr != address(0), '_fusionAddr: Invalid address (zero address)');
      fusionAddr = _fusionAddr;
    }
}

// File: openzeppelin-solidity/contracts/math/SafeMath.sol



pragma solidity ^0.5.0;



/**

 * @title SafeMath

 * @dev Unsigned math operations with safety checks that revert on error

 */

library SafeMath {

    /**

    * @dev Multiplies two unsigned integers, reverts on overflow.

    */

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {

        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the

        // benefit is lost if 'b' is also tested.

        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522

        if (a == 0) {

            return 0;

        }



        uint256 c = a * b;

        require(c / a == b);



        return c;

    }



    /**

    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.

    */

    function div(uint256 a, uint256 b) internal pure returns (uint256) {

        // Solidity only automatically asserts when dividing by 0

        require(b > 0);

        uint256 c = a / b;

        // assert(a == b * c + a % b); // There is no case in which this doesn't hold



        return c;

    }



    /**

    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).

    */

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {

        require(b <= a);

        uint256 c = a - b;



        return c;

    }



    /**

    * @dev Adds two unsigned integers, reverts on overflow.

    */

    function add(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a + b;

        require(c >= a);



        return c;

    }



    /**

    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),

    * reverts when dividing by zero.

    */

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {

        require(b != 0);

        return a % b;

    }

}



// File: openzeppelin-solidity/contracts/access/Roles.sol



pragma solidity ^0.5.0;



/**

 * @title Roles

 * @dev Library for managing addresses assigned to a Role.

 */

library Roles {

    struct Role {

        mapping (address => bool) bearer;

    }



    /**

     * @dev give an account access to this role

     */

    function add(Role storage role, address account) internal {

        require(account != address(0));

        require(!has(role, account));



        role.bearer[account] = true;

    }



    /**

     * @dev remove an account's access to this role

     */

    function remove(Role storage role, address account) internal {

        require(account != address(0));

        require(has(role, account));



        role.bearer[account] = false;

    }



    /**

     * @dev check if an account has this role

     * @return bool

     */

    function has(Role storage role, address account) internal view returns (bool) {

        require(account != address(0));

        return role.bearer[account];

    }

}



// File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol



pragma solidity ^0.5.0;





contract PauserRole {

    using Roles for Roles.Role;



    event PauserAdded(address indexed account);

    event PauserRemoved(address indexed account);



    Roles.Role private _pausers;



    constructor () internal {

        _addPauser(msg.sender);

    }



    modifier onlyPauser() {

        require(isPauser(msg.sender));

        _;

    }



    function isPauser(address account) public view returns (bool) {

        return _pausers.has(account);

    }



    function addPauser(address account) public onlyPauser {

        _addPauser(account);

    }



    function renouncePauser() public {

        _removePauser(msg.sender);

    }



    function _addPauser(address account) internal {

        _pausers.add(account);

        emit PauserAdded(account);

    }



    function _removePauser(address account) internal {

        _pausers.remove(account);

        emit PauserRemoved(account);

    }

}



// File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol



pragma solidity ^0.5.0;





/**

 * @title Pausable

 * @dev Base contract which allows children to implement an emergency stop mechanism.

 */

contract Pausable is PauserRole {

    event Paused(address account);

    event Unpaused(address account);



    bool private _paused;



    constructor () internal {

        _paused = false;

    }



    /**

     * @return true if the contract is paused, false otherwise.

     */

    function paused() public view returns (bool) {

        return _paused;

    }



    /**

     * @dev Modifier to make a function callable only when the contract is not paused.

     */

    modifier whenNotPaused() {

        require(!_paused);

        _;

    }



    /**

     * @dev Modifier to make a function callable only when the contract is paused.

     */

    modifier whenPaused() {

        require(_paused);

        _;

    }



    /**

     * @dev called by the owner to pause, triggers stopped state

     */

    function pause() public onlyPauser whenNotPaused {

        _paused = true;

        emit Paused(msg.sender);

    }



    /**

     * @dev called by the owner to unpause, returns to normal state

     */

    function unpause() public onlyPauser whenPaused {

        _paused = false;

        emit Unpaused(msg.sender);

    }

}



// File: openzeppelin-solidity/contracts/access/roles/WhitelistAdminRole.sol



pragma solidity ^0.5.0;





/**

 * @title WhitelistAdminRole

 * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.

 */

contract WhitelistAdminRole {

    using Roles for Roles.Role;



    event WhitelistAdminAdded(address indexed account);

    event WhitelistAdminRemoved(address indexed account);



    Roles.Role private _whitelistAdmins;



    constructor () internal {

        _addWhitelistAdmin(msg.sender);

    }



    modifier onlyWhitelistAdmin() {

        require(isWhitelistAdmin(msg.sender));

        _;

    }



    function isWhitelistAdmin(address account) public view returns (bool) {

        return _whitelistAdmins.has(account);

    }



    function addWhitelistAdmin(address account) public onlyWhitelistAdmin {

        _addWhitelistAdmin(account);

    }



    function renounceWhitelistAdmin() public {

        _removeWhitelistAdmin(msg.sender);

    }



    function _addWhitelistAdmin(address account) internal {

        _whitelistAdmins.add(account);

        emit WhitelistAdminAdded(account);

    }



    function _removeWhitelistAdmin(address account) internal {

        _whitelistAdmins.remove(account);

        emit WhitelistAdminRemoved(account);

    }

}



// File: openzeppelin-solidity/contracts/access/roles/WhitelistedRole.sol



pragma solidity ^0.5.0;







/**

 * @title WhitelistedRole

 * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a

 * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove

 * it), and not Whitelisteds themselves.

 */

contract WhitelistedRole is WhitelistAdminRole {

    using Roles for Roles.Role;



    event WhitelistedAdded(address indexed account);

    event WhitelistedRemoved(address indexed account);



    Roles.Role private _whitelisteds;



    modifier onlyWhitelisted() {

        require(isWhitelisted(msg.sender));

        _;

    }



    function isWhitelisted(address account) public view returns (bool) {

        return _whitelisteds.has(account);

    }



    function addWhitelisted(address account) public onlyWhitelistAdmin {

        _addWhitelisted(account);

    }



    function removeWhitelisted(address account) public onlyWhitelistAdmin {

        _removeWhitelisted(account);

    }



    function renounceWhitelisted() public {

        _removeWhitelisted(msg.sender);

    }



    function _addWhitelisted(address account) internal {

        _whitelisteds.add(account);

        emit WhitelistedAdded(account);

    }



    function _removeWhitelisted(address account) internal {

        _whitelisteds.remove(account);

        emit WhitelistedRemoved(account);

    }

}



// File: contracts/FundsSplitterV2.sol



pragma solidity ^0.5.0;







contract FundsSplitterV2 is WhitelistedRole {

    using SafeMath for uint256;



    address payable public platform;

    address payable public partner;



    uint256 public partnerRate = 15;



    constructor (address payable _platform, address payable _partner) public {

        platform = _platform;

        partner = _partner;

    }



    function splitFunds(uint256 _totalPrice) internal {

        if (msg.value > 0) {

            uint256 refund = msg.value.sub(_totalPrice);



            // overpaid...

            if (refund > 0) {

                msg.sender.transfer(refund);

            }



            // work out the amount to split and send it

            uint256 partnerAmount = _totalPrice.div(100).mul(partnerRate);

            partner.transfer(partnerAmount);



            // send remaining amount to blockCities wallet

            uint256 remaining = _totalPrice.sub(partnerAmount);

            platform.transfer(remaining);

        }

    }



    function updatePartnerAddress(address payable _partner) onlyWhitelisted public {

        partner = _partner;

    }



    function updatePartnerRate(uint256 _techPartnerRate) onlyWhitelisted public {

        partnerRate = _techPartnerRate;

    }



    function updatePlatformAddress(address payable _platform) onlyWhitelisted public {

        platform = _platform;

    }

}



// File: contracts/libs/Strings.sol



pragma solidity ^0.5.0;



library Strings {



    // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol

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



    function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {

        return strConcat(_a, _b, "", "", "");

    }



    function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {

        return strConcat(_a, _b, _c, "", "");

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



// File: contracts/IBlockCitiesCreator.sol



pragma solidity ^0.5.0;



interface IBlockCitiesCreator {

    function createBuilding(

        uint256 _exteriorColorway,

        uint256 _backgroundColorway,

        uint256 _city,

        uint256 _building,

        uint256 _base,

        uint256 _body,

        uint256 _roof,

        uint256 _special,

        address _architect

    ) external returns (uint256 _tokenId);

}



// File: contracts/validators/IValidator.sol



pragma solidity ^0.5.0;



interface IValidator {

    function validate(uint256 _building, uint256 _base, uint256 _body, uint256 _roof, uint256 _exterior) external view returns (bool);

}



// File: contracts/LimitedVendingMachine.sol



pragma solidity ^0.5.0;















contract LimitedVendingMachine is FundsSplitterV2, Pausable {

    using SafeMath for uint256;



    event VendingMachineTriggered(

        uint256 indexed _tokenId,

        address indexed _architect

    );



    event CreditAdded(address indexed _to, uint256 _amount);



    event PriceStepInWeiChanged(

        uint256 _oldPriceStepInWei,

        uint256 _newPriceStepInWei

    );



    event FloorPricePerBuildingInWeiChanged(

        uint256 _oldFloorPricePerBuildingInWei,

        uint256 _newFloorPricePerBuildingInWei

    );



    event CeilingPricePerBuildingInWeiChanged(

        uint256 _oldCeilingPricePerBuildingInWei,

        uint256 _newCeilingPricePerBuildingInWei

    );



    event BlockStepChanged(

        uint256 _oldBlockStep,

        uint256 _newBlockStep

    );



    event LastSaleBlockChanged(

        uint256 _oldLastSaleBlock,

        uint256 _newLastSaleBlock

    );



    event LastSalePriceChanged(

        uint256 _oldLastSalePrice,

        uint256 _newLastSalePrice

    );



    IBlockCitiesCreator public blockCities;

    IValidator public validator;



    mapping(address => uint256) public credits;



    uint256 public totalPurchasesInWei = 0;



    uint256 public floorPricePerBuildingInWei = 0.05 ether;



    uint256 public ceilingPricePerBuildingInWei = 0.15 ether;



    uint256 public priceStepInWei = 0.0003 ether;



    uint256 public blockStep = 10;



    uint256 public lastSaleBlock = 0;

    uint256 public lastSalePrice = 0.075 ether;



    uint256 public buildingMintLimit;

    uint256 public totalBuildings;

    uint256 public city;



    mapping(bytes32 => bool) public buildingRegistry;



    constructor (

        IBlockCitiesCreator _blockCities,

        IValidator _validator,

        address payable _platform,

        address payable _partnerAddress,

        uint256 _buildingMintLimit,

        uint256 _city

    ) public FundsSplitterV2(_platform, _partnerAddress) {

        blockCities = _blockCities;

        validator = _validator;



        lastSaleBlock = block.number;



        buildingMintLimit = _buildingMintLimit;



        super.addWhitelisted(msg.sender);



        city = _city;

    }



    function mintBuilding(

        uint256 _building,

        uint256 _base,

        uint256 _body,

        uint256 _roof,

        uint256 _exteriorColorway,

        uint256 _backgroundColorway

    ) whenNotPaused public payable returns (uint256 _tokenId) {

        uint256 currentPrice = totalPrice();

        require(

            credits[msg.sender] > 0 || msg.value >= currentPrice,

            "Must supply at least the required minimum purchase value or have credit"

        );



        _reconcileCreditsAndFunds(currentPrice);



        // always pass a special value of zero; as specials created via own function

        uint256 tokenId = _generate(_building, _base, _body, _roof, 0, _exteriorColorway, _backgroundColorway);



        _stepIncrease();



        return tokenId;

    }



    function mintSpecial(

        uint256 _special

    ) onlyWhitelisted public returns (uint256 _tokenId) {

        require(totalBuildings < buildingMintLimit, "The building mint limit has been reached");



        uint256 tokenId = blockCities.createBuilding(

            0,

            0,

            city,

            0,

            0,

            0,

            0,

            _special,

            msg.sender

        );



        totalBuildings = totalBuildings.add(1);



        emit VendingMachineTriggered(tokenId, msg.sender);



        return tokenId;

    }



    function premintBuilding(

        uint256 _building,

        uint256 _base,

        uint256 _body,

        uint256 _roof,

        uint256 _exteriorColorway,

        uint256 _backgroundColorway

    ) onlyWhitelisted public returns (uint256 _tokenId) {

        // always pass a special value of zero; as specials created via own function

        return _generate(_building, _base, _body, _roof, 0, _exteriorColorway, _backgroundColorway);

    }



    function _generate(

        uint256 _building,

        uint256 _base,

        uint256 _body,

        uint256 _roof,

        uint256 _special,

        uint256 _exteriorColorway,

        uint256 _backgroundColorway

    ) internal returns (uint256 _tokenId) {

        require(totalBuildings < buildingMintLimit, "The building mint limit has been reached");



        // validate building can be built at this time

        bool valid = validator.validate(_building, _base, _body, _roof, _exteriorColorway);

        require(valid, "Building must be valid");



        // check unique and not already built

        bytes32 buildingAndColorwayHash = keccak256(abi.encode(_building, _base, _body, _roof, _special, _exteriorColorway));

        require(!buildingRegistry[buildingAndColorwayHash], "Building already exists");



        uint256 tokenId = blockCities.createBuilding(

            _exteriorColorway,

            _backgroundColorway,

            city,

            _building,

            _base,

            _body,

            _roof,

            _special,

            msg.sender

        );



        // add to registry to avoid dupes

        buildingRegistry[buildingAndColorwayHash] = true;



        totalBuildings = totalBuildings.add(1);



        emit VendingMachineTriggered(tokenId, msg.sender);



        return tokenId;

    }



    function built(uint256 _building, uint256 _base, uint256 _body, uint256 _roof, uint256 _special, uint256 _exteriorColorway, uint256 _backgroundColorway) public view returns (bool) {

        bytes32 buildingAndColorwayHash = keccak256(abi.encode(_building, _base, _body, _roof, _special, _exteriorColorway, _backgroundColorway));

        return buildingRegistry[buildingAndColorwayHash];

    }



    function _reconcileCreditsAndFunds(uint256 _currentPrice) internal {

        // use credits first

        if (credits[msg.sender] >= 1) {

            credits[msg.sender] = credits[msg.sender].sub(1);



            // refund msg.value when using up credits

            if (msg.value > 0) {

                msg.sender.transfer(msg.value);

            }

        } else {

            splitFunds(_currentPrice);

            totalPurchasesInWei = totalPurchasesInWei.add(_currentPrice);

        }

    }



    function _stepIncrease() internal {



        lastSalePrice = totalPrice().add(priceStepInWei);

        lastSaleBlock = block.number;



        if (lastSalePrice >= ceilingPricePerBuildingInWei) {

            lastSalePrice = ceilingPricePerBuildingInWei;

        }

    }



    function totalPrice() public view returns (uint256) {



        uint256 calculatedPrice = lastSalePrice;



        uint256 blocksPassed = block.number - lastSaleBlock;

        uint256 reduce = blocksPassed.div(blockStep).mul(priceStepInWei);



        if (reduce > calculatedPrice) {

            calculatedPrice = floorPricePerBuildingInWei;

        }

        else {

            calculatedPrice = calculatedPrice.sub(reduce);



            if (calculatedPrice < floorPricePerBuildingInWei) {

                calculatedPrice = floorPricePerBuildingInWei;

            }

        }



        return calculatedPrice;

    }



    function setPriceStepInWei(uint256 _priceStepInWei) public onlyWhitelisted returns (bool) {

        emit PriceStepInWeiChanged(priceStepInWei, _priceStepInWei);

        priceStepInWei = _priceStepInWei;

        return true;

    }



    function addCredit(address _to) public onlyWhitelisted returns (bool) {

        credits[_to] = credits[_to].add(1);



        emit CreditAdded(_to, 1);



        return true;

    }



    function addCreditAmount(address _to, uint256 _amount) public onlyWhitelisted returns (bool) {

        credits[_to] = credits[_to].add(_amount);



        emit CreditAdded(_to, _amount);



        return true;

    }



    function setFloorPricePerBuildingInWei(uint256 _floorPricePerBuildingInWei) public onlyWhitelisted returns (bool) {

        emit FloorPricePerBuildingInWeiChanged(floorPricePerBuildingInWei, _floorPricePerBuildingInWei);

        floorPricePerBuildingInWei = _floorPricePerBuildingInWei;

        return true;

    }



    function setCeilingPricePerBuildingInWei(uint256 _ceilingPricePerBuildingInWei) public onlyWhitelisted returns (bool) {

        emit CeilingPricePerBuildingInWeiChanged(ceilingPricePerBuildingInWei, _ceilingPricePerBuildingInWei);

        ceilingPricePerBuildingInWei = _ceilingPricePerBuildingInWei;

        return true;

    }



    function setBlockStep(uint256 _blockStep) public onlyWhitelisted returns (bool) {

        emit BlockStepChanged(blockStep, _blockStep);

        blockStep = _blockStep;

        return true;

    }



    function setLastSaleBlock(uint256 _lastSaleBlock) public onlyWhitelisted returns (bool) {

        emit LastSaleBlockChanged(lastSaleBlock, _lastSaleBlock);

        lastSaleBlock = _lastSaleBlock;

        return true;

    }



    function setLastSalePrice(uint256 _lastSalePrice) public onlyWhitelisted returns (bool) {

        emit LastSalePriceChanged(lastSalePrice, _lastSalePrice);

        lastSalePrice = _lastSalePrice;

        return true;

    }



    function buildingsMintAllowanceRemaining() external view returns (uint256) {

        return buildingMintLimit.sub(totalBuildings);

    }

}

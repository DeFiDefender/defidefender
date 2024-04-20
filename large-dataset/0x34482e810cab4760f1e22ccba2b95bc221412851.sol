pragma solidity ^0.6.7;



abstract contract AccountingEngineLike {

    function debtAuctionHouse() virtual public returns (address);

}

abstract contract DebtAuctionHouseLike {

    function AUCTION_HOUSE_TYPE() virtual public returns (bytes32);

    function activeDebtAuctions() virtual public returns (uint256);

}

abstract contract ProtocolTokenAuthorityLike {

    function setRoot(address) virtual public;

    function setOwner(address) virtual public;

    function addAuthorization(address) virtual public;

    function removeAuthorization(address) virtual public;



    function owner() virtual public view returns (address);

    function root() virtual public view returns (address);

}



contract GebPrintingPermissions {

    // --- Auth ---

    mapping (address => uint) public authorizedAccounts;

    /**

     * @notice Add auth to an account

     * @param account Account to add auth to

     */

    function addAuthorization(address account) external isAuthorized {

        authorizedAccounts[account] = 1;

        emit AddAuthorization(account);

    }

    /**

     * @notice Remove auth from an account

     * @param account Account to remove auth from

     */

    function removeAuthorization(address account) external isAuthorized {

        authorizedAccounts[account] = 0;

        emit RemoveAuthorization(account);

    }

    /**

    * @notice Checks whether msg.sender can call an authed function

    **/

    modifier isAuthorized {

        require(authorizedAccounts[msg.sender] == 1, "GebPrintingPermissions/account-not-authorized");

        _;

    }



    // --- Structs ---

    struct SystemRights {

        // Whether this system is covered or not

        bool    covered;

        // Timestamp after which this system cannot have its printing rights taken away

        uint256 revokeRightsDeadline;

        // Timestamp after which the uncover process can end

        uint256 uncoverCooldownEnd;

        // Timestamp until which the added rights can be taken without waiting until uncoverCooldownEnd

        uint256 withdrawAddedRightsDeadline;

        // The previous address of the debt auction house

        address previousDebtAuctionHouse;

        // The current address of the debt auction house

        address currentDebtAuctionHouse;

    }



    // Mapping of all the allowed systems

    mapping(address => SystemRights) public allowedSystems;

    // Whether an auction house is already used or not

    mapping(address => uint256)      public usedAuctionHouses;



    // Minimum amount of time that we need to wait until a system can have unlimited printing rights

    uint256 public unrevokableRightsCooldown;

    // Amount of time that needs to pass until the uncover period can end

    uint256 public denyRightsCooldown;

    // Amount of time during which rights can be withdrawn without waiting for denyRightsCooldown seconds

    uint256 public addRightsCooldown;

    // Amount of systems covered

    uint256 public coveredSystems;



    ProtocolTokenAuthorityLike public protocolTokenAuthority;



    bytes32 public constant AUCTION_HOUSE_TYPE = bytes32("DEBT");



    // --- Events ---

    event AddAuthorization(address account);

    event RemoveAuthorization(address account);

    event ModifyParameters(bytes32 parameter, uint data);

    event GiveUpAuthorityRoot();

    event GiveUpAuthorityOwnership();

    event RevokeDebtAuctionHouses(address accountingEngine, address currentHouse, address previousHouse);

    event CoverSystem(address accountingEngine, address debtAuctionHouse, uint256 coveredSystems, uint256 withdrawAddedRightsDeadline);

    event StartUncoverSystem(address accountingEngine, address debtAuctionHouse, uint256 coveredSystems, uint256 revokeRightsDeadline, uint256 uncoverCooldownEnd, uint256 withdrawAddedRightsDeadline);

    event AbandonUncoverSystem(address accountingEngine);

    event EndUncoverSystem(address accountingEngine, address currentHouse, address previousHouse);

    event UpdateCurrentDebtAuctionHouse(address accountingEngine, address currentHouse, address previousHouse);

    event RemovePreviousDebtAuctionHouse(address accountingEngine, address currentHouse, address previousHouse);

    event ProposeIndefinitePrintingPermissions(address accountingEngine, uint256 freezeDelay);



    constructor(address protocolTokenAuthority_) public {

        authorizedAccounts[msg.sender] = 1;

        protocolTokenAuthority = ProtocolTokenAuthorityLike(protocolTokenAuthority_);

        emit AddAuthorization(msg.sender);

    }



    // --- Math ---

    function addition(uint x, uint y) internal pure returns (uint z) {

        z = x + y;

        require(z >= x);

    }

    function subtract(uint x, uint y) internal pure returns (uint z) {

        require((z = x - y) <= x);

    }



    // --- General Utils ---

    function either(bool x, bool y) internal pure returns (bool z) {

        assembly{ z := or(x, y)}

    }

    function both(bool x, bool y) internal pure returns (bool z) {

        assembly{ z := and(x, y)}

    }



    // --- Administration ---

    /**

     * @notice Modify general uint params

     * @param parameter The name of the parameter modified

     * @param data New value for the parameter

     */

    function modifyParameters(bytes32 parameter, uint data) external isAuthorized {

        if (parameter == "unrevokableRightsCooldown") unrevokableRightsCooldown = data;

        else if (parameter == "denyRightsCooldown") denyRightsCooldown = data;

        else if (parameter == "addRightsCooldown") addRightsCooldown = data;

        else revert("GebPrintingPermissions/modify-unrecognized-param");

        emit ModifyParameters(parameter, data);

    }



    // --- Token Authority Ownership ---

    /**

     * @notice Give up being a root inside the protocol token authority

     */

    function giveUpAuthorityRoot() external isAuthorized {

        require(protocolTokenAuthority.root() == address(this), "GebPrintingPermissions/not-root");

        protocolTokenAuthority.setRoot(address(0));

        emit GiveUpAuthorityRoot();

    }

    /**

     * @notice Give up being the owner inside the protocol token authority

     */

    function giveUpAuthorityOwnership() external isAuthorized {

        require(

          either(

            protocolTokenAuthority.root() == address(this),

            protocolTokenAuthority.owner() == address(this)

          ), "GebPrintingPermissions/not-root-or-owner"

        );

        protocolTokenAuthority.setOwner(address(0));

        emit GiveUpAuthorityOwnership();

    }



    // --- Permissions Utils ---

    /**

     * @notice Revoke permissions for both the current and the last debt auction house associated with an accounting engine

     * @param accountingEngine The address of the accounting engine whose debt auction houses will no longer have printing permissions

     */

    function revokeDebtAuctionHouses(address accountingEngine) internal {

        address currentHouse  = allowedSystems[accountingEngine].currentDebtAuctionHouse;

        address previousHouse = allowedSystems[accountingEngine].previousDebtAuctionHouse;

        delete allowedSystems[accountingEngine];

        protocolTokenAuthority.removeAuthorization(currentHouse);

        protocolTokenAuthority.removeAuthorization(previousHouse);

        emit RevokeDebtAuctionHouses(accountingEngine, currentHouse, previousHouse);

    }



    // --- System Cover ---

    /**

     * @notice Cover a new system

     * @param accountingEngine The address of the accounting engine being part of a new covered system

     */

    function coverSystem(address accountingEngine) external isAuthorized {

        require(!allowedSystems[accountingEngine].covered, "GebPrintingPermissions/system-already-covered");

        address debtAuctionHouse = AccountingEngineLike(accountingEngine).debtAuctionHouse();

        require(

          keccak256(abi.encode(DebtAuctionHouseLike(debtAuctionHouse).AUCTION_HOUSE_TYPE())) ==

          keccak256(abi.encode(AUCTION_HOUSE_TYPE)),

          "GebPrintingPermissions/not-a-debt-auction-house"

        );

        require(usedAuctionHouses[debtAuctionHouse] == 0, "GebPrintingPermissions/auction-house-already-used");

        usedAuctionHouses[debtAuctionHouse] = 1;

        uint newWithdrawAddedRightsCooldown = addition(now, addRightsCooldown);

        allowedSystems[accountingEngine] = SystemRights(

          true,

          uint256(-1),

          0,

          newWithdrawAddedRightsCooldown,

          address(0),

          debtAuctionHouse

        );

        coveredSystems = addition(coveredSystems, 1);

        protocolTokenAuthority.addAuthorization(debtAuctionHouse);

        emit CoverSystem(accountingEngine, debtAuctionHouse, coveredSystems, newWithdrawAddedRightsCooldown);

    }

    /**

     * @notice Start to uncover a system

     * @param accountingEngine The address of the accounting engine whose auction houses will start to be uncovered

     */

    function startUncoverSystem(address accountingEngine) external isAuthorized {

        require(allowedSystems[accountingEngine].covered, "GebPrintingPermissions/system-not-covered");

        require(allowedSystems[accountingEngine].uncoverCooldownEnd == 0, "GebPrintingPermissions/system-not-being-uncovered");

        require(

          DebtAuctionHouseLike(allowedSystems[accountingEngine].currentDebtAuctionHouse).activeDebtAuctions() == 0,

          "GebPrintingPermissions/ongoing-debt-auctions-current-house"

        );

        if (allowedSystems[accountingEngine].previousDebtAuctionHouse != address(0)) {

          require(

            DebtAuctionHouseLike(allowedSystems[accountingEngine].previousDebtAuctionHouse).activeDebtAuctions() == 0,

            "GebPrintingPermissions/ongoing-debt-auctions-previous-house"

          );

        }

        require(

          either(

            coveredSystems > 1,

            now <= allowedSystems[accountingEngine].withdrawAddedRightsDeadline

          ),

          "GebPrintingPermissions/not-enough-systems-covered"

        );



        if (now <= allowedSystems[accountingEngine].withdrawAddedRightsDeadline) {

          coveredSystems = subtract(coveredSystems, 1);

          usedAuctionHouses[allowedSystems[accountingEngine].previousDebtAuctionHouse] = 0;

          usedAuctionHouses[allowedSystems[accountingEngine].currentDebtAuctionHouse] = 0;

          revokeDebtAuctionHouses(accountingEngine);

        } else {

          require(allowedSystems[accountingEngine].revokeRightsDeadline >= now, "GebPrintingPermissions/revoke-frozen");

          allowedSystems[accountingEngine].uncoverCooldownEnd = addition(now, denyRightsCooldown);

        }

        emit StartUncoverSystem(

          accountingEngine,

          allowedSystems[accountingEngine].currentDebtAuctionHouse,

          coveredSystems,

          allowedSystems[accountingEngine].revokeRightsDeadline,

          allowedSystems[accountingEngine].uncoverCooldownEnd,

          allowedSystems[accountingEngine].withdrawAddedRightsDeadline

        );

    }

    /**

     * @notice Abandon the uncover process for a system

     * @param accountingEngine The address of the accounting engine whose auction houses should have been uncovered

     */

    function abandonUncoverSystem(address accountingEngine) external isAuthorized {

        require(allowedSystems[accountingEngine].covered, "GebPrintingPermissions/system-not-covered");

        require(allowedSystems[accountingEngine].uncoverCooldownEnd > 0, "GebPrintingPermissions/system-not-being-uncovered");

        allowedSystems[accountingEngine].uncoverCooldownEnd = 0;

        emit AbandonUncoverSystem(accountingEngine);

    }

    /**

     * @notice Abandon the uncover process for a system

     * @param accountingEngine The address of the accounting engine whose auction houses should have been uncovered

     */

    function endUncoverSystem(address accountingEngine) external isAuthorized {

        require(allowedSystems[accountingEngine].covered, "GebPrintingPermissions/system-not-covered");

        require(allowedSystems[accountingEngine].uncoverCooldownEnd > 0, "GebPrintingPermissions/system-not-being-uncovered");

        require(allowedSystems[accountingEngine].uncoverCooldownEnd < now, "GebPrintingPermissions/cooldown-not-passed");

        require(

          DebtAuctionHouseLike(allowedSystems[accountingEngine].currentDebtAuctionHouse).activeDebtAuctions() == 0,

          "GebPrintingPermissions/ongoing-debt-auctions-current-house"

        );

        if (allowedSystems[accountingEngine].previousDebtAuctionHouse != address(0)) {

          require(

            DebtAuctionHouseLike(allowedSystems[accountingEngine].previousDebtAuctionHouse).activeDebtAuctions() == 0,

            "GebPrintingPermissions/ongoing-debt-auctions-previous-house"

          );

        }

        require(

          either(

            coveredSystems > 1,

            now <= allowedSystems[accountingEngine].withdrawAddedRightsDeadline

          ),

          "GebPrintingPermissions/not-enough-systems-covered"

        );



        usedAuctionHouses[allowedSystems[accountingEngine].previousDebtAuctionHouse] = 0;

        usedAuctionHouses[allowedSystems[accountingEngine].currentDebtAuctionHouse]  = 0;



        coveredSystems = subtract(coveredSystems, 1);

        revokeDebtAuctionHouses(accountingEngine);



        emit EndUncoverSystem(

          accountingEngine,

          allowedSystems[accountingEngine].currentDebtAuctionHouse,

          allowedSystems[accountingEngine].previousDebtAuctionHouse

        );



        delete allowedSystems[accountingEngine];

    }

    /**

     * @notice Update the current debt auction house associated with a system

     * @param accountingEngine The address of the accounting engine associated with a covered system

     */

    function updateCurrentDebtAuctionHouse(address accountingEngine) external isAuthorized {

        require(allowedSystems[accountingEngine].covered, "GebPrintingPermissions/system-not-covered");

        address newHouse = AccountingEngineLike(accountingEngine).debtAuctionHouse();

        require(newHouse != allowedSystems[accountingEngine].currentDebtAuctionHouse, "GebPrintingPermissions/new-house-not-changed");

        require(

          keccak256(abi.encode(DebtAuctionHouseLike(newHouse).AUCTION_HOUSE_TYPE())) ==

          keccak256(abi.encode(AUCTION_HOUSE_TYPE)),

          "GebPrintingPermissions/new-house-not-a-debt-auction"

        );

        require(allowedSystems[accountingEngine].previousDebtAuctionHouse == address(0), "GebPrintingPermissions/previous-house-not-removed");

        require(usedAuctionHouses[newHouse] == 0, "GebPrintingPermissions/auction-house-already-used");

        usedAuctionHouses[newHouse] = 1;

        allowedSystems[accountingEngine].previousDebtAuctionHouse =

          allowedSystems[accountingEngine].currentDebtAuctionHouse;

        allowedSystems[accountingEngine].currentDebtAuctionHouse = newHouse;

        protocolTokenAuthority.addAuthorization(newHouse);

        emit UpdateCurrentDebtAuctionHouse(

          accountingEngine,

          allowedSystems[accountingEngine].currentDebtAuctionHouse,

          allowedSystems[accountingEngine].previousDebtAuctionHouse

        );

    }

    /**

     * @notice Remove the previous, no longer used debt auction house from a covered system

     * @param accountingEngine The address of the accounting engine associated with a covered system

     */

    function removePreviousDebtAuctionHouse(address accountingEngine) external isAuthorized {

        require(allowedSystems[accountingEngine].covered, "GebPrintingPermissions/system-not-covered");

        require(

          allowedSystems[accountingEngine].previousDebtAuctionHouse != address(0),

          "GebPrintingPermissions/inexistent-previous-auction-house"

        );

        require(

          DebtAuctionHouseLike(allowedSystems[accountingEngine].previousDebtAuctionHouse).activeDebtAuctions() == 0,

          "GebPrintingPermissions/ongoing-debt-auctions-previous-house"

        );

        address previousHouse = allowedSystems[accountingEngine].previousDebtAuctionHouse;

        usedAuctionHouses[previousHouse] = 0;

        allowedSystems[accountingEngine].previousDebtAuctionHouse = address(0);

        protocolTokenAuthority.removeAuthorization(previousHouse);

        emit RemovePreviousDebtAuctionHouse(

          accountingEngine,

          allowedSystems[accountingEngine].currentDebtAuctionHouse,

          previousHouse

        );

    }

    /**

     * @notice Propose a time after which a currently covered system will no longer be under the threat of getting uncovered

     * @param accountingEngine The address of the accounting engine associated with a covered system

     * @param freezeDelay The amount of time (from this point onward) during which the system can still be uncovered but, once passed, the system has indefinite printing permissions

     */

    function proposeIndefinitePrintingPermissions(address accountingEngine, uint256 freezeDelay) external isAuthorized {

        require(allowedSystems[accountingEngine].covered, "GebPrintingPermissions/system-not-covered");

        require(both(freezeDelay >= unrevokableRightsCooldown, freezeDelay > 0), "GebPrintingPermissions/low-delay");

        require(allowedSystems[accountingEngine].revokeRightsDeadline > addition(now, freezeDelay), "GebPrintingPermissions/big-delay");

        allowedSystems[accountingEngine].revokeRightsDeadline = addition(now, freezeDelay);

        emit ProposeIndefinitePrintingPermissions(accountingEngine, freezeDelay);

    }

}

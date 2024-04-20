// File: contracts/interfaces/IContractRegistry.sol



pragma solidity ^0.4.23;



/*

    Contract Registry interface

*/

contract IContractRegistry {

    function addressOf(bytes32 _contractName) public view returns (address);

}



// File: contracts/interfaces/IERC20Token.sol



pragma solidity ^0.4.23;



/*

    ERC20 Standard Token interface

*/

contract IERC20Token {

    // these functions aren't abstract since the compiler emits automatically generated getter functions as external

    function name() public view returns (string) {}

    function symbol() public view returns (string) {}

    function decimals() public view returns (uint8) {}

    function totalSupply() public view returns (uint256) {}

    function balanceOf(address _owner) public view returns (uint256) { _owner; }

    function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }



    function transfer(address _to, uint256 _value) public returns (bool success);

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);

    function approve(address _spender, uint256 _value) public returns (bool success);

}



// File: contracts/interfaces/IPegSettings.sol



pragma solidity ^0.4.23;





contract IPegSettings {



    function authorized(address _address) public view returns (bool) { _address; }

    

    function authorize(address _address, bool _auth) public;

    function transferERC20Token(IERC20Token _token, address _to, uint256 _amount) public;



}



// File: contracts/interfaces/IVault.sol



pragma solidity ^0.4.23;







contract IVault {



    function registry() public view returns (IContractRegistry);



    function auctions(address _borrower) public view returns (address) { _borrower; }

    function vaultExists(address _vault) public view returns (bool) { _vault; }

    function totalBorrowed(address _vault) public view returns (uint256) { _vault; }

    function rawBalanceOf(address _vault) public view returns (uint256) { _vault; }

    function rawDebt(address _vault) public view returns (uint256) { _vault; }

    function rawTotalBalance() public view returns (uint256);

    function rawTotalDebt() public view returns (uint256);

    function collateralBorrowedRatio() public view returns (uint256);

    function amountMinted() public view returns (uint256);



    function debtScalePrevious() public view returns (uint256);

    function debtScaleTimestamp() public view returns (uint256);

    function debtScaleRate() public view returns (int256);

    function balScalePrevious() public view returns (uint256);

    function balScaleTimestamp() public view returns (uint256);

    function balScaleRate() public view returns (int256);

    

    function liquidationRatio() public view returns (uint32);

    function maxBorrowLTV() public view returns (uint32);



    function borrowingEnabled() public view returns (bool);

    function biddingTime() public view returns (uint);



    function setType(bool _type) public;

    function create(address _vault) public;

    function setCollateralBorrowedRatio(uint _newRatio) public;

    function setAmountMinted(uint _amountMinted) public;

    function setLiquidationRatio(uint32 _liquidationRatio) public;

    function setMaxBorrowLTV(uint32 _maxBorrowLTV) public;

    function setDebtScalingRate(int256 _debtScalingRate) public;

    function setBalanceScalingRate(int256 _balanceScalingRate) public;

    function setBiddingTime(uint _biddingTime) public;

    function setRawTotalDebt(uint _rawTotalDebt) public;

    function setRawTotalBalance(uint _rawTotalBalance) public;

    function setRawBalanceOf(address _borrower, uint _rawBalance) public;

    function setRawDebt(address _borrower, uint _rawDebt) public;

    function setTotalBorrowed(address _borrower, uint _totalBorrowed) public;

    function debtScalingFactor() public view returns (uint256);

    function balanceScalingFactor() public view returns (uint256);

    function debtRawToActual(uint256 _raw) public view returns (uint256);

    function debtActualToRaw(uint256 _actual) public view returns (uint256);

    function balanceRawToActual(uint256 _raw) public view returns (uint256);

    function balanceActualToRaw(uint256 _actual) public view returns (uint256);

    function getVaults(address _vault, uint256 _balanceOf) public view returns(address[]);

    function transferERC20Token(IERC20Token _token, address _to, uint256 _amount) public;

    function oracleValue() public view returns(uint256);

    function emitBorrow(address _borrower, uint256 _amount) public;

    function emitRepay(address _borrower, uint256 _amount) public;

    function emitDeposit(address _borrower, uint256 _amount) public;

    function emitWithdraw(address _borrower, address _to, uint256 _amount) public;

    function emitLiquidate(address _borrower) public;

    function emitAuctionStarted(address _borrower) public;

    function emitAuctionEnded(address _borrower, address _highestBidder, uint256 _highestBid) public;

    function setAuctionAddress(address _borrower, address _auction) public;

}



// File: contracts/interfaces/IPegOracle.sol



pragma solidity ^0.4.23;



contract IPegOracle {

    function getValue() public view returns (uint256);

}



// File: contracts/interfaces/IOwned.sol



pragma solidity ^0.4.23;



/*

    Owned contract interface

*/

contract IOwned {

    // this function isn't abstract since the compiler emits automatically generated getter functions as external

    function owner() public view returns (address) {}



    function transferOwnership(address _newOwner) public;

    function acceptOwnership() public;

    function setOwner(address _newOwner) public;

}



// File: contracts/interfaces/ISmartToken.sol



pragma solidity ^0.4.23;







/*

    Smart Token interface

*/

contract ISmartToken is IOwned, IERC20Token {

    function disableTransfers(bool _disable) public;

    function issue(address _to, uint256 _amount) public;

    function destroy(address _from, uint256 _amount) public;

}



// File: contracts/interfaces/IPegLogic.sol



pragma solidity ^0.4.23;









contract IPegLogic {



    function adjustCollateralBorrowingRate() public;

    function isInsolvent(IVault _vault, address _borrower) public view returns (bool);

    function actualDebt(IVault _vault, address _address) public view returns(uint256);

    function excessCollateral(IVault _vault, address _borrower) public view returns (int256);

    function availableCredit(IVault _vault, address _borrower) public view returns (int256);

    function getCollateralToken(IVault _vault) public view returns(IERC20Token);

    function getDebtToken(IVault _vault) public view returns(ISmartToken);



}



// File: contracts/interfaces/IAuctionActions.sol



pragma solidity ^0.4.23;





contract IAuctionActions {



    function startAuction(IVault _vault, address _borrower) public;

    function endAuction(IVault _vault, address _borrower) public;



}



// File: contracts/ContractIds.sol



pragma solidity ^0.4.23;



contract ContractIds {

    bytes32 public constant STABLE_TOKEN = "StableToken";

    bytes32 public constant COLLATERAL_TOKEN = "CollateralToken";



    bytes32 public constant PEGUSD_TOKEN = "PEGUSD";



    bytes32 public constant VAULT_A = "VaultA";

    bytes32 public constant VAULT_B = "VaultB";



    bytes32 public constant PEG_LOGIC = "PegLogic";

    bytes32 public constant PEG_LOGIC_ACTIONS = "LogicActions";

    bytes32 public constant AUCTION_ACTIONS = "AuctionActions";



    bytes32 public constant PEG_SETTINGS = "PegSettings";

    bytes32 public constant ORACLE = "Oracle";

    bytes32 public constant FEE_RECIPIENT = "StabilityFeeRecipient";

}



// File: contracts/Helpers.sol



pragma solidity ^0.4.23;





















contract Helpers is ContractIds {



    IContractRegistry public registry;



    constructor(IContractRegistry _registry) public {

        registry = _registry;

    }



    modifier authOnly() {

        require(settings().authorized(msg.sender));

        _;

    }



    modifier validate(IVault _vault, address _borrower) {

        require(address(_vault) == registry.addressOf(ContractIds.VAULT_A) || address(_vault) == registry.addressOf(ContractIds.VAULT_B));

        _vault.create(_borrower);

        _;

    }



    function stableToken() internal returns(ISmartToken) {

        return ISmartToken(registry.addressOf(ContractIds.STABLE_TOKEN));

    }



    function collateralToken() internal returns(ISmartToken) {

        return ISmartToken(registry.addressOf(ContractIds.COLLATERAL_TOKEN));

    }



    function PEGUSD() internal returns(IERC20Token) {

        return IERC20Token(registry.addressOf(ContractIds.PEGUSD_TOKEN));

    }



    function vaultA() internal returns(IVault) {

        return IVault(registry.addressOf(ContractIds.VAULT_A));

    }



    function vaultB() internal returns(IVault) {

        return IVault(registry.addressOf(ContractIds.VAULT_B));

    }



    function oracle() internal returns(IPegOracle) {

        return IPegOracle(registry.addressOf(ContractIds.ORACLE));

    }



    function settings() internal returns(IPegSettings) {

        return IPegSettings(registry.addressOf(ContractIds.PEG_SETTINGS));

    }



    function pegLogic() internal returns(IPegLogic) {

        return IPegLogic(registry.addressOf(ContractIds.PEG_LOGIC));

    }



    function auctionActions() internal returns(IAuctionActions) {

        return IAuctionActions(registry.addressOf(ContractIds.AUCTION_ACTIONS));

    }



    function transferERC20Token(IERC20Token _token, address _to, uint256 _amount) public authOnly {

        _token.transfer(_to, _amount);

    }



}



// File: contracts/interfaces/IAuction.sol



pragma solidity ^0.4.23;







contract IAuction {



    function highestBidder() public view returns (address);

    function highestBid() public view returns (uint256);

    function lowestBidRelay() public view returns (uint256);



    function bid(uint256 _amount) public;

    function auctionEnd() public;



    function hasEnded() public view returns (bool);



    function transferERC20Token(IERC20Token _token, address _to, uint256 _amount) public;



}



// File: contracts/interfaces/IBancorConverter.sol



pragma solidity ^0.4.23;





contract IBancorConverter {

    function token() public view returns (ISmartToken) {}

}



// File: contracts/interfaces/ILogicActions.sol



pragma solidity ^0.4.23;





contract ILogicActions {



    function deposit(IVault _vault, uint256 _amount) public;

    function withdraw(IVault _vault, address _to, uint256 _amount) public;

    function borrow(IVault _vault, uint256 _amount) public;

    function repay(IVault _vault, address _borrower, uint256 _amount) public;

    function repayAuction(IVault _vault, address _borrower, uint256 _amount) public;

    function repayAll(IVault _vault, address _borrower) public;



}



// File: contracts/Auction.sol



pragma solidity ^0.4.23;

















contract Auction is ContractIds {

    address public borrower;

    IVault public vault;

    IContractRegistry public registry;

    uint public auctionEndTime;

    uint public auctionStartTime;

    address public highestBidder;

    uint256 public highestBid;

    uint256 public lowestBidRelay;

    uint256 public amountToPay;

    bool ended;



    event HighestBidIncreased(address indexed _bidder, uint256 _amount, uint256 _amountRelay);



    constructor(IContractRegistry _registry, IVault _vault, address _borrower) public {

        registry = _registry;

        borrower = _borrower;

        vault = _vault;

    }



    modifier authOnly() {

        require(IPegSettings(registry.addressOf(ContractIds.PEG_SETTINGS)).authorized(msg.sender), "Unauthorized");

        _;

    }



    function validateBid(uint256 _amount, uint256 _amountRelay) internal {

        if(auctionEndTime > 0)

            require(now <= auctionEndTime, "Auction has already ended");

        else {

            auctionStartTime = now;

            auctionEndTime = now + vault.biddingTime();

        }

        require(_amount == 0 || _amountRelay == 0, "Can't refund collateral and mint relay tokens");

        if(highestBidder != address(0))

            require(_amount > highestBid || _amountRelay < lowestBidRelay, "There already is a higher bid");

        require(vault.balanceActualToRaw(_amount) <= vault.rawBalanceOf(address(this)), "Can't refund more than 100%");

    }



    function bid(uint256 _amount, uint256 _amountRelay) public {

        validateBid(_amount, _amountRelay);

        if(_amountRelay > 0)

            auctionEndTime = auctionStartTime + 172800; // extends to 48 hours auction

        IPegLogic pegLogic = IPegLogic(registry.addressOf(ContractIds.PEG_LOGIC));

        if(amountToPay == 0) amountToPay = pegLogic.actualDebt(vault, address(this));

        IERC20Token token = pegLogic.getDebtToken(vault);

        token.transferFrom(msg.sender, address(this), amountToPay);

        if (highestBidder != address(0)) {

            require(token.transfer(highestBidder, amountToPay), "Error transferring token to last highest bidder.");

        } else {

            ILogicActions logicActions = ILogicActions(registry.addressOf(ContractIds.PEG_LOGIC_ACTIONS));

            if (address(vault) == registry.addressOf(ContractIds.VAULT_B))

                token.approve(address(logicActions), amountToPay);

            logicActions.repayAuction(vault, borrower, amountToPay);

        }

        highestBidder = msg.sender;

        highestBid = _amount;

        lowestBidRelay = _amountRelay;

        emit HighestBidIncreased(msg.sender, _amount, _amountRelay);

    }



    function auctionEnd() public authOnly {

        require(auctionEndTime > 0, "Bidding has not started yet");

        require(now >= auctionEndTime, "Auction end time is in the future");

        require(!ended, "Auction already ended");

        ended = true;

    }



    function canEnd() public view returns (bool) {

        return auctionEndTime > 0 && now >= auctionEndTime;

    }



    function transferERC20Token(IERC20Token _token, address _to, uint256 _amount) public authOnly {

        _token.transfer(_to, _amount);

    }

}



// File: contracts/library/SafeMath.sol



pragma solidity ^0.4.23;



library SafeMath {

    function plus(uint256 _a, uint256 _b) internal pure returns (uint256) {

        uint256 c = _a + _b;

        assert(c >= _a);

        return c;

    }



    function plus(int256 _a, int256 _b) internal pure returns (int256) {

        int256 c = _a + _b;

        assert((_b >= 0 && c >= _a) || (_b < 0 && c < _a));

        return c;

    }



    function minus(uint256 _a, uint256 _b) internal pure returns (uint256) {

        assert(_a >= _b);

        return _a - _b;

    }



    function minus(int256 _a, int256 _b) internal pure returns (int256) {

        int256 c = _a - _b;

        assert((_b >= 0 && c <= _a) || (_b < 0 && c > _a));

        return c;

    }



    function times(uint256 _a, uint256 _b) internal pure returns (uint256) {

        if (_a == 0) {

            return 0;

        }

        uint256 c = _a * _b;

        assert(c / _a == _b);

        return c;

    }



    function times(int256 _a, int256 _b) internal pure returns (int256) {

        if (_a == 0) {

            return 0;

        }

        int256 c = _a * _b;

        assert(c / _a == _b);

        return c;

    }



    function toInt256(uint256 _a) internal pure returns (int256) {

        assert(_a <= 2 ** 255);

        return int256(_a);

    }



    function toUint256(int256 _a) internal pure returns (uint256) {

        assert(_a >= 0);

        return uint256(_a);

    }



    function div(uint256 _a, uint256 _b) internal pure returns (uint256) {

        return _a / _b;

    }



    function div(int256 _a, int256 _b) internal pure returns (int256) {

        return _a / _b;

    }

}



// File: contracts/AuctionActions.sol



pragma solidity ^0.4.23;



















contract AuctionActions is Helpers {



    using SafeMath for uint256;

    using SafeMath for int256;



    IContractRegistry public registry;



    constructor(IContractRegistry _registry) public Helpers(_registry) {

        registry = _registry;

    }



    function startAuction(IVault _vault, address _borrower) public validate(_vault, _borrower) returns(address) {

        require(_vault.vaultExists(_borrower), "Invalid vault");

        address auctionAddress = _vault.auctions(_borrower);

        require(auctionAddress == address(0), "Vault is already on auction state");

        IPegLogic ipegLogic = pegLogic();

        require(ipegLogic.actualDebt(_vault, _borrower) > 0, "Vault has no debt");

        require(ipegLogic.isInsolvent(_vault, _borrower), "Vault is not eligible for liquidation");

        Auction auction = new Auction(registry, _vault, _borrower);

        _vault.setAuctionAddress(_borrower, address(auction));

        _vault.setRawBalanceOf(address(auction), _vault.rawBalanceOf(_borrower));

        _vault.setRawDebt(address(auction), _vault.rawDebt(_borrower));

        _vault.setTotalBorrowed(address(auction), _vault.totalBorrowed(_borrower));

        _vault.setRawBalanceOf(_borrower, 0);

        _vault.setRawDebt(_borrower, 0);

        _vault.setTotalBorrowed(_borrower, 0);

        _vault.emitAuctionStarted(_borrower);

        return address(auction);

    }



    function endAuction(IVault _vault, address _borrower) public validate(_vault, _borrower) {

        require(_vault.vaultExists(_borrower), "Invalid vault");

        address auctionAddress = _vault.auctions(_borrower);

        require(auctionAddress != address(0), "Vault is not on auction state");

        IAuction auction = IAuction(auctionAddress);

        auction.auctionEnd();

        address highestBidder = auction.highestBidder();

        uint256 highestBid = _vault.balanceActualToRaw(auction.highestBid());

        _vault.setAuctionAddress(_borrower, address(0));

        _vault.create(highestBidder);

        _vault.setRawBalanceOf(

            highestBidder,

            _vault.rawBalanceOf(highestBidder).plus(_vault.rawBalanceOf(auctionAddress).minus(highestBid))

        );

        _vault.setRawBalanceOf(_borrower, _vault.rawBalanceOf(_borrower).plus(highestBid));

        if(auction.lowestBidRelay() > 0) {

            IBancorConverter converter = IBancorConverter(registry.addressOf(ContractIds.FEE_RECIPIENT));

            ISmartToken relayToken = ISmartToken(converter.token());

            relayToken.issue(highestBidder, auction.lowestBidRelay());

        }

        pegLogic().adjustCollateralBorrowingRate();

        _vault.setRawBalanceOf(auctionAddress, 0);

        _vault.emitAuctionEnded(_borrower, highestBidder, highestBid);

    }



}

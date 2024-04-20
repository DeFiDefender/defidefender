// File: localhost/flashloan/FlashLoanLogger.sol



pragma solidity ^0.5.0;





contract FlashLoanLogger {

    event FlashLoan(string actionType, uint256 id, uint256 loanAmount, address sender);



    function logFlashLoan(

        string calldata _actionType,

        uint256 _id,

        uint256 _loanAmount,

        address _sender

    ) external {

        emit FlashLoan(_actionType, _loanAmount, _id, _sender);

    }

}



// File: localhost/DS/DSAuthority.sol



pragma solidity ^0.5.0;





contract DSAuthority {

    function canCall(address src, address dst, bytes4 sig) public view returns (bool);

}



// File: localhost/DS/DSAuth.sol



pragma solidity ^0.5.0;







contract DSAuthEvents {

    event LogSetAuthority(address indexed authority);

    event LogSetOwner(address indexed owner);

}





contract DSAuth is DSAuthEvents {

    DSAuthority public authority;

    address public owner;



    constructor() public {

        owner = msg.sender;

        emit LogSetOwner(msg.sender);

    }



    function setOwner(address owner_) public auth {

        owner = owner_;

        emit LogSetOwner(owner);

    }



    function setAuthority(DSAuthority authority_) public auth {

        authority = authority_;

        emit LogSetAuthority(address(authority));

    }



    modifier auth {

        require(isAuthorized(msg.sender, msg.sig));

        _;

    }



    function isAuthorized(address src, bytes4 sig) internal view returns (bool) {

        if (src == address(this)) {

            return true;

        } else if (src == owner) {

            return true;

        } else if (authority == DSAuthority(0)) {

            return false;

        } else {

            return authority.canCall(src, address(this), sig);

        }

    }

}



// File: localhost/DS/DSGuard.sol



pragma solidity ^0.5.0;





contract DSGuard {

    function canCall(address src_, address dst_, bytes4 sig) public view returns (bool);



    function permit(bytes32 src, bytes32 dst, bytes32 sig) public;



    function forbid(bytes32 src, bytes32 dst, bytes32 sig) public;



    function permit(address src, address dst, bytes32 sig) public;



    function forbid(address src, address dst, bytes32 sig) public;

}





contract DSGuardFactory {

    function newGuard() public returns (DSGuard guard);

}



// File: localhost/auth/ProxyPermission.sol



pragma solidity ^0.5.0;







contract ProxyPermission {



    address public constant FACTORY_ADDRESS = 0x5a15566417e6C1c9546523066500bDDBc53F88C7;



    function givePermission(address _contractAddr) internal {

        address currAuthority = address(DSAuth(address(this)).authority());

        DSGuard guard = DSGuard(currAuthority);



        if (currAuthority == address(0)) {

            guard = DSGuardFactory(FACTORY_ADDRESS).newGuard();

            DSAuth(address(this)).setAuthority(DSAuthority(address(guard)));

        }



        guard.permit(_contractAddr, address(this), bytes4(keccak256("execute(address,bytes)")));

    }



    function removePermission(address _contractAddr) internal {

        address currAuthority = address(DSAuth(address(this)).authority());

        DSGuard guard = DSGuard(currAuthority);



        guard.forbid(_contractAddr, address(this), bytes4(keccak256("execute(address,bytes)")));

    }

}



// File: localhost/DS/DSMath.sol



pragma solidity ^0.5.0;





contract DSMath {

    function add(uint256 x, uint256 y) internal pure returns (uint256 z) {

        require((z = x + y) >= x);

    }



    function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {

        require((z = x - y) <= x);

    }



    function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {

        require(y == 0 || (z = x * y) / y == x);

    }



    function div(uint256 x, uint256 y) internal pure returns (uint256 z) {

        return x / y;

    }



    function min(uint256 x, uint256 y) internal pure returns (uint256 z) {

        return x <= y ? x : y;

    }



    function max(uint256 x, uint256 y) internal pure returns (uint256 z) {

        return x >= y ? x : y;

    }



    function imin(int256 x, int256 y) internal pure returns (int256 z) {

        return x <= y ? x : y;

    }



    function imax(int256 x, int256 y) internal pure returns (int256 z) {

        return x >= y ? x : y;

    }



    uint256 constant WAD = 10**18;

    uint256 constant RAY = 10**27;



    function wmul(uint256 x, uint256 y) internal pure returns (uint256 z) {

        z = add(mul(x, y), WAD / 2) / WAD;

    }



    function rmul(uint256 x, uint256 y) internal pure returns (uint256 z) {

        z = add(mul(x, y), RAY / 2) / RAY;

    }



    function wdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {

        z = add(mul(x, WAD), y / 2) / y;

    }



    function rdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {

        z = add(mul(x, RAY), y / 2) / y;

    }



    // This famous algorithm is called "exponentiation by squaring"

    // and calculates x^n with x as fixed-point and n as regular unsigned.

    //

    // It's O(log n), instead of O(n) for naive repeated multiplication.

    //

    // These facts are why it works:

    //

    //  If n is even, then x^n = (x^2)^(n/2).

    //  If n is odd,  then x^n = x * x^(n-1),

    //   and applying the equation for even x gives

    //    x^n = x * (x^2)^((n-1) / 2).

    //

    //  Also, EVM division is flooring and

    //    floor[(n-1) / 2] = floor[n / 2].

    //

    function rpow(uint256 x, uint256 n) internal pure returns (uint256 z) {

        z = n % 2 != 0 ? x : RAY;



        for (n /= 2; n != 0; n /= 2) {

            x = rmul(x, x);



            if (n % 2 != 0) {

                z = rmul(z, x);

            }

        }

    }

}



// File: localhost/mcd/maker/Manager.sol



pragma solidity ^0.5.0;



contract Manager {

    function last(address) public returns (uint);

    function cdpCan(address, uint, address) public view returns (uint);

    function ilks(uint) public view returns (bytes32);

    function owns(uint) public view returns (address);

    function urns(uint) public view returns (address);

    function vat() public view returns (address);

    function open(bytes32, address) public returns (uint);

    function give(uint, address) public;

    function cdpAllow(uint, address, uint) public;

    function urnAllow(address, uint) public;

    function frob(uint, int, int) public;

    function flux(uint, address, uint) public;

    function move(uint, address, uint) public;

    function exit(address, uint, address, uint) public;

    function quit(uint, address) public;

    function enter(address, uint) public;

    function shift(uint, uint) public;

}



// File: localhost/mcd/maker/Vat.sol



pragma solidity ^0.5.0;



contract Vat {



    struct Urn {

        uint256 ink;   // Locked Collateral  [wad]

        uint256 art;   // Normalised Debt    [wad]

    }



    struct Ilk {

        uint256 Art;   // Total Normalised Debt     [wad]

        uint256 rate;  // Accumulated Rates         [ray]

        uint256 spot;  // Price with Safety Margin  [ray]

        uint256 line;  // Debt Ceiling              [rad]

        uint256 dust;  // Urn Debt Floor            [rad]

    }



    mapping (bytes32 => mapping (address => Urn )) public urns;

    mapping (bytes32 => Ilk)                       public ilks;

    mapping (bytes32 => mapping (address => uint)) public gem;  // [wad]



    function can(address, address) public view returns (uint);

    function dai(address) public view returns (uint);

    function frob(bytes32, address, address, address, int, int) public;

    function hope(address) public;

    function move(address, address, uint) public;

}



// File: localhost/interfaces/ERC20.sol



pragma solidity ^0.5.0;





interface ERC20 {

    function totalSupply() external view returns (uint256 supply);



    function balanceOf(address _owner) external view returns (uint256 balance);



    function transfer(address _to, uint256 _value) external returns (bool success);



    function transferFrom(address _from, address _to, uint256 _value)

        external

        returns (bool success);



    function approve(address _spender, uint256 _value) external returns (bool success);



    function allowance(address _owner, address _spender) external view returns (uint256 remaining);



    function decimals() external view returns (uint256 digits);



    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

}



// File: localhost/interfaces/CTokenInterface.sol



pragma solidity ^0.5.0;







contract CTokenInterface is ERC20 {

    function mint(uint256 mintAmount) external returns (uint256);



    function mint() external payable;



    function redeem(uint256 redeemTokens) external returns (uint256);



    function redeemUnderlying(uint256 redeemAmount) external returns (uint256);



    function borrow(uint256 borrowAmount) external returns (uint256);



    function repayBorrow(uint256 repayAmount) external returns (uint256);



    function repayBorrow() external payable;



    function repayBorrowBehalf(address borrower, uint256 repayAmount) external returns (uint256);



    function repayBorrowBehalf(address borrower) external payable;



    function liquidateBorrow(address borrower, uint256 repayAmount, address cTokenCollateral)

        external

        returns (uint256);



    function liquidateBorrow(address borrower, address cTokenCollateral) external payable;



    function exchangeRateCurrent() external returns (uint256);



    function supplyRatePerBlock() external returns (uint256);



    function borrowRatePerBlock() external returns (uint256);



    function totalReserves() external returns (uint256);



    function reserveFactorMantissa() external returns (uint256);



    function borrowBalanceCurrent(address account) external returns (uint256);



    function totalBorrowsCurrent() external returns (uint256);



    function getCash() external returns (uint256);



    function balanceOfUnderlying(address owner) external returns (uint256);



    function underlying() external returns (address);

}



// File: localhost/flashloan/aave/ILendingPool.sol



pragma solidity ^0.5.0;



contract ILendingPool {

    function flashLoan( address payable _receiver, address _reserve, uint _amount, bytes calldata _params) external;

}



// File: localhost/flashloan/bridges/BridgeFlashLoanTaker.sol



pragma solidity ^0.5.0;



















contract BridgeFlashLoanTaker is DSMath, ProxyPermission {



    ILendingPool public constant lendingPool = ILendingPool(0x398eC7346DcD622eDc5ae82352F02bE94C62d119);



    address public constant ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    address public constant CETH_ADDRESS = 0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5;

    address public constant DAI_ADDRESS = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

    address public constant cDAI_ADDRESS = 0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643;



    address payable public constant LOAN_MOVER = 0x1ccd1b13b7473Cdcc9b1b858CB813de95b465E79;



    address public constant MANAGER_ADDRESS = 0x5ef30b9986345249bc32d8928B7ee64DE9435E39;

    address public constant VAT_ADDRESS = 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B;



    Manager public constant manager = Manager(MANAGER_ADDRESS);



    // solhint-disable-next-line const-name-snakecase

    FlashLoanLogger public constant logger = FlashLoanLogger(

        0xb9303686B0EE92F92f63973EF85f3105329D345c

    );



    function compound2Maker(

        uint _cdpId,

        address _joinAddr,

        address _cCollateralAddr

    ) external {

        bytes32 ilk = manager.ilks(_cdpId);

        uint debtAmount = getAllDebtCompound();



        bytes memory paramsData = abi.encode(_cdpId, _joinAddr, _cCollateralAddr, ilk, uint8(1), address(this));



        givePermission(LOAN_MOVER);



        lendingPool.flashLoan(LOAN_MOVER, DAI_ADDRESS, debtAmount, paramsData);



        removePermission(LOAN_MOVER);



        logger.logFlashLoan("compound2Maker", debtAmount, _cdpId, DAI_ADDRESS);

    }



    function maker2Compound(

        uint _cdpId,

        address _joinAddr,

        address _cCollateralAddr

    ) external {

        bytes32 ilk = manager.ilks(_cdpId);

        uint debtAmount = getAllDebtCDP(VAT_ADDRESS, manager.urns(_cdpId), manager.urns(_cdpId), ilk);



        bytes memory paramsData = abi.encode(_cdpId, _joinAddr, _cCollateralAddr, ilk, uint8(2), address(this));



        givePermission(LOAN_MOVER);



        lendingPool.flashLoan(LOAN_MOVER, DAI_ADDRESS, debtAmount, paramsData);



        removePermission(LOAN_MOVER);



        logger.logFlashLoan("maker2Compound", debtAmount, _cdpId, DAI_ADDRESS);

    }



    function getAllDebtCDP(address _vat, address _usr, address _urn, bytes32 _ilk) internal view returns (uint daiAmount) {

        (, uint rate,,,) = Vat(_vat).ilks(_ilk);

        (, uint art) = Vat(_vat).urns(_ilk, _urn);

        uint dai = Vat(_vat).dai(_usr);



        uint rad = sub(mul(art, rate), dai);

        daiAmount = rad / RAY;



        daiAmount = mul(daiAmount, RAY) < rad ? daiAmount + 1 : daiAmount;

    }



    function getAllDebtCompound() internal returns (uint daiAmount) {

        daiAmount = CTokenInterface(cDAI_ADDRESS).borrowBalanceCurrent(address(this));

    }

}

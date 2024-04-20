pragma solidity ^0.5.15;



// https://github.com/makerdao/dss/blob/master/src/jug.sol

contract JugAbstract {

    // mapping (address => uint) public wards;

    function wards(address) public view returns (uint256);

    function rely(address) external;

    function deny(address) external;

    struct Ilk {

        uint256 duty;

        uint256  rho;

    }

    // mapping (bytes32 => Ilk) public ilks;

    function ilks(bytes32) public view returns (uint256, uint256);

    // VatLike public vat;

    function vat() public view returns (address);

    // address public vow;

    function vow() public view returns (address);

    // uint256 public base;

    function base() public view returns (address);

    // uint256 constant ONE = 10 ** 27;

    function ONE() public view returns (uint256);

    function init(bytes32) external;

    function file(bytes32, bytes32, uint256) external;

    function file(bytes32, uint256) external;

    function file(bytes32, address) external;

    function drip(bytes32) external returns (uint256);

}



contract PotAbstract {

    // mapping (address => uint256) public wards;

    function wards(address) public view returns (uint256);

    function rely(address) external;

    function deny(address) external;

    // mapping (address => uint256) public pie;  // user Savings Dai

    function pie(address) public view returns (uint256);

    // uint256 public Pie;  // total Savings Dai

    function Pie() public view returns (uint256);

    // uint256 public dsr;  // the Dai Savings Rate

    function dsr() public view returns (uint256);

    // uint256 public chi;  // the Rate Accumulator

    function chi() public view returns (uint256);

    // VatAbstract public vat;  // CDP engine

    function vat() public view returns (address);

    // address public vow;  // debt engine

    function vow() public view returns (address);

    // uint256 public rho;  // time of last drip

    function rho() public view returns (uint256);

    // uint256 public live;  // Access Flag

    function live() public view returns (uint256);

    function file(bytes32, uint256) external;

    function file(bytes32, address) external;

    function cage() external;

    function drip() external returns (uint256);

    function join(uint256) external;

    function exit(uint256) external;

}



// https://github.com/makerdao/dss/blob/master/src/pot.sol

contract PotHelper {



    PotAbstract pa;

    

    constructor(address pot) public {

        pa = PotAbstract(pot);

    }



    // https://github.com/makerdao/dss/blob/master/src/pot.sol#L79

    uint256 constant ONE = 10 ** 27;

    

    function mul(uint x, uint y) internal pure returns (uint z) {

        require(y == 0 || (z = x * y) / y == x);

    }



    function rmul(uint x, uint y) internal pure returns (uint z) {

        z = mul(x, y) / ONE;

    }



    function rpow(uint x, uint n, uint base) internal pure returns (uint z) {

        assembly {

            switch x case 0 {switch n case 0 {z := base} default {z := 0}}

            default {

                switch mod(n, 2) case 0 { z := base } default { z := x }

                let half := div(base, 2)  // for rounding.

                for { n := div(n, 2) } n { n := div(n,2) } {

                    let xx := mul(x, x)

                    if iszero(eq(div(xx, x), x)) { revert(0,0) }

                    let xxRound := add(xx, half)

                    if lt(xxRound, xx) { revert(0,0) }

                    x := div(xxRound, base)

                    if mod(n,2) {

                        let zx := mul(z, x)

                        if and(iszero(iszero(x)), iszero(eq(div(zx, x), z))) { revert(0,0) }

                        let zxRound := add(zx, half)

                        if lt(zxRound, zx) { revert(0,0) }

                        z := div(zxRound, base)

                    }

                }

            }

        }

    }



    // View function for calculating value of chi iff drip() is called in the same block.

    function drop() external view returns (uint256) {

        if (now == pa.rho()) return pa.chi();

        return rmul(rpow(pa.dsr(), now - pa.rho(), ONE), pa.chi());

    }



    // Pass the Pot Abstract for additional operations

    function pot() external view returns (PotAbstract) {

        return pa;

    }

}



contract VowAbstract {

    // mapping (address => uint) public wards;

    function wards(address) public view returns (uint256);

    function rely(address usr) external;

    function deny(address usr) external;

    // VatAbstract public vat;

    function vat() public view returns (address);

    // FlapAbstract public flapper;

    function flapper() public view returns (address);

    // FlopAbstract public flopper;

    function flopper() public view returns (address);

    // mapping (uint256 => uint256) public sin; // debt queue

    function sin(uint256) public view returns (uint256);

    // uint256 public Sin;   // queued debt          [rad]

    function Sin() public view returns (uint256);

    // uint256 public Ash;

    function Ash() public view returns (uint256);

    // uint256 public wait;  // flop delay

    function wait() public view returns (uint256);

    // uint256 public dump;  // flop initial lot size  [wad]

    function dump() public view returns (uint256);

    // uint256 public sump;  // flop fixed bid size    [rad]

    function sump() public view returns (uint256);

    // uint256 public bump;  // flap fixed lot size    [rad]

    function bump() public view returns (uint256);

    // uint256 public hump;  // surplus buffer       [rad]

    function hump() public view returns (uint256);

    // uint256 public live;

    function live() public view returns (uint256);

    function file(bytes32, uint256) external;

    function file(bytes32, address) external;

    function fess(uint256) external;

    function flog(uint256) external;

    function heal(uint256) external;

    function kiss(uint256) external;

    function flop() external returns (uint256);

    function flap() external returns (uint256);

    function cage() external;

}



contract VatAbstract {

    // mapping (address => uint) public wards;

    function wards(address) public view returns (uint256);

    function rely(address) external;

    function deny(address) external;

    struct Ilk {

        uint256 Art;   // Total Normalised Debt     [wad]

        uint256 rate;  // Accumulated Rates         [ray]

        uint256 spot;  // Price with Safety Margin  [ray]

        uint256 line;  // Debt Ceiling              [rad]

        uint256 dust;  // Urn Debt Floor            [rad]

    }

    struct Urn {

        uint256 ink;   // Locked Collateral  [wad]

        uint256 art;   // Normalised Debt    [wad]

    }

    // mapping (address => mapping (address => uint256)) public can;

    function can(address, address) public view returns (uint256);

    function hope(address) external;

    function nope(address) external;

    // mapping (bytes32 => Ilk) public ilks;

    function ilks(bytes32) external view returns (uint256, uint256, uint256, uint256, uint256);

    // mapping (bytes32 => mapping (address => Urn)) public urns;

    function urns(bytes32, address) public view returns (uint256, uint256);

    // mapping (bytes32 => mapping (address => uint256)) public gem;  // [wad]

    function gem(bytes32, address) public view returns (uint256);

    // mapping (address => uint256) public dai;  // [rad]

    function dai(address) public view returns (uint256);

    // mapping (address => uint256) public sin;  // [rad]

    function sin(address) public view returns (uint256);

    // uint256 public debt;  // Total Dai Issued    [rad]

    function debt() public view returns (uint256);

    // uint256 public vice;  // Total Unbacked Dai  [rad]

    function vice() public view returns (uint256);

    // uint256 public Line;  // Total Debt Ceiling  [rad]

    function Line() public view returns (uint256);

    // uint256 public live;  // Access Flag

    function live() public view returns (uint256);

    function init(bytes32) external;

    function file(bytes32, uint256) external;

    function file(bytes32, bytes32, uint256) external;

    function cage() external;

    function slip(bytes32, address, int256) external;

    function flux(bytes32, address, address, uint256) external;

    function move(address, address, uint256) external;

    function frob(bytes32, address, address, address, int256, int256) external;

    function fork(bytes32, address, address, int256, int256) external;

    function grab(bytes32, address, address, address, int256, int256) external;

    function heal(uint256) external;

    function suck(address, address, uint256) external;

    function fold(bytes32, address, int256) external;

}





// \u0f3c\u3064\u0ca0\u76ca\u0ca0\u0f3d\u3064 \u2500=\u2261\u03a3\u25c8)) HADAIKEN

//

// Optimized contract for performing some or all of the functions that

//   keep Multi-Collateral Dai running.

contract Hadaiken {



    address constant internal JUG = address(0x19c0976f590D67707E62397C87829d896Dc0f1F1);

    address constant internal POT = address(0x197E90f9FAD81970bA7976f33CbD77088E5D7cf7);

    address constant internal VAT = address(0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B);

    address constant internal VOW = address(0xA950524441892A31ebddF91d3cEEFa04Bf454466);



    JugAbstract constant internal jug  = JugAbstract(JUG);

    PotAbstract constant internal pot  = PotAbstract(POT);

    VowAbstract constant internal vow  = VowAbstract(VOW);

    VatAbstract constant internal vat  = VatAbstract(VAT);

    PotHelper            internal poth;



    bytes32 constant internal ETH_A = bytes32("ETH-A");

    bytes32 constant internal BAT_A = bytes32("BAT-A");



    constructor() public {

        poth = new PotHelper(POT);

    }



    // Raw System Debt

    function _rawSysDebt() internal view returns (uint256) {

        return (vat.sin(VOW) - vow.Sin() - vow.Ash());

    }



    function rawSysDebt() external view returns (uint256) {

        return _rawSysDebt();

    }



    function _sysSurplus() internal view returns (uint256) {

        return (vat.sin(VOW) + vow.bump() + vow.hump());

    }



    function  sysSurplus() external view returns (uint256) {

        return _sysSurplus();

    }



    // Saves you money.

    function heal() external {

        _heal();

    }



    // Returns the amount of debt healed if you're curious about that sort of thing.

    function healStat() external returns (uint256 sd) {

        sd = _rawSysDebt();

        _heal();

    }



    // No return here. I want to save gas and who cares.

    function _heal() internal {

        vow.heal(_rawSysDebt());

    }



    // Return the new chi value after drip.

    function drip() external returns (uint256 chi) {

        chi = pot.drip();

        _dripIlks();

    }



    // Returns a simulated chi value

    function drop() external view returns (uint256) {

        return poth.drop();

    }



    function _dripPot() internal {

        pot.drip();

    }



    function dripIlks() external {

        _dripIlks();

    }



    function _dripIlks() internal {

        jug.drip(ETH_A);

        jug.drip(BAT_A);

    }



    function kickable() external view returns (bool) {

        return _kickable();

    }



    // Can we bump an auction?

    function _kickable() internal view returns (bool) {

        // require(vat.dai(address(this)) >= add(add(vat.sin(address(this)), bump), hump), "Vow/insufficient-surplus");

        // require(sub(sub(vat.sin(address(this)), Sin), Ash) == 0, "Vow/debt-not-zero");

        return ((vat.dai(VOW) >= _sysSurplus()) && (_rawSysDebt() == 0));

    }



    // Kick off an auction and return the auction ID

    function ccccombobreaker() external returns (uint256) {

        return vow.flap();

    }



    // Kick off an auction and throw away id

    function _ccccombobreaker() internal {

        vow.flap();

    }



    // Kitchen sink. Call this early and often.

    function hadaiken() external {

        _dripPot();                               // Update the chi

        _dripIlks();                              // Updates the Ilk rates

        _heal();                                  // Cancel out system debt with system surplus

        if (_kickable()) { _ccccombobreaker(); }  // Start an auction

    }

}

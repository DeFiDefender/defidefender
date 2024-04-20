// Verified using https://dapp.tools

// hevm: flattened sources of src/McdLaunchESSpell.sol
pragma solidity >0.4.13 >=0.5.12 <0.6.0;

////// lib/ds-math/src/math.sol
/// math.sol -- mixin for inline numerical wizardry

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

/* pragma solidity >0.4.13; */

contract DSMath {
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, "ds-math-add-overflow");
    }
    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, "ds-math-sub-underflow");
    }
    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
    }

    function min(uint x, uint y) internal pure returns (uint z) {
        return x <= y ? x : y;
    }
    function max(uint x, uint y) internal pure returns (uint z) {
        return x >= y ? x : y;
    }
    function imin(int x, int y) internal pure returns (int z) {
        return x <= y ? x : y;
    }
    function imax(int x, int y) internal pure returns (int z) {
        return x >= y ? x : y;
    }

    uint constant WAD = 10 ** 18;
    uint constant RAY = 10 ** 27;

    function wmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), WAD / 2) / WAD;
    }
    function rmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), RAY / 2) / RAY;
    }
    function wdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, WAD), y / 2) / y;
    }
    function rdiv(uint x, uint y) internal pure returns (uint z) {
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
    function rpow(uint x, uint n) internal pure returns (uint z) {
        z = n % 2 != 0 ? x : RAY;

        for (n /= 2; n != 0; n /= 2) {
            x = rmul(x, x);

            if (n % 2 != 0) {
                z = rmul(z, x);
            }
        }
    }
}

////// lib/dss-interfaces/src/dapp/DSAuthorityAbstract.sol
/* pragma solidity ^0.5.12; */

// https://github.com/dapphub/ds-auth
contract DSAuthorityAbstract {
    function canCall(address, address, bytes4) public view returns (bool);
}

contract DSAuthEventsAbstract {
    event LogSetAuthority (address indexed);
    event LogSetOwner (address indexed);
}

contract DSAuthAbstract is DSAuthEventsAbstract {
    // DSAuthority  public  authority;
    function authority() public view returns (DSAuthorityAbstract);
    // address      public  owner;
    function owner() public view returns (address);
    function setOwner(address) public;
    function setAuthority(DSAuthorityAbstract) public;
}

////// lib/dss-interfaces/src/dapp/DSPauseProxyAbstract.sol
/* pragma solidity ^0.5.12; */

// https://github.com/dapphub/ds-pause
contract DSPauseProxyAbstract {
    // address public owner;
    function owner() public view returns (address);
    function exec(address, bytes memory) public returns (bytes memory);
}
////// lib/dss-interfaces/src/dapp/DSPauseAbstract.sol
/* pragma solidity ^0.5.12; */

/* import { DSPauseProxyAbstract } from "./DSPauseProxyAbstract.sol"; */
/* import { DSAuthorityAbstract } from "./DSAuthorityAbstract.sol"; */

// https://github.com/dapphub/ds-pause
contract DSPauseAbstract {
    function setOwner(address) public;
    function setAuthority(DSAuthorityAbstract) public;
    function setDelay(uint256) public;
    // mapping (bytes32 => bool) public plans;
    function plans(bytes32) public view returns (bool);
    // DSProxyAbstract public proxy;
    function proxy() public view returns (DSPauseProxyAbstract);
    // uint256 public delay;
    function delay() public view returns (uint256);
    function plot(address, bytes32, bytes memory, uint256) public;
    function drop(address, bytes32, bytes memory, uint256) public;
    function exec(address, bytes32, bytes memory, uint256) public returns (bytes memory);
}

////// lib/dss-interfaces/src/dapp/DSTokenAbstract.sol
/* pragma solidity ^0.5.12; */

// MKR Token adheres to the DSToken interface
// https://github.com/dapphub/ds-token/blob/master/src/token.sol
contract DSTokenAbstract {
    // bytes32 public name;
    function name() public view returns (bytes32);
    // bytes32 public symbol;
    function symbol() public view returns (bytes32);
    // uint256 public decimals;
    function decimals() public view returns (uint256);
    function totalSupply() external view returns (uint256);
    function balanceOf(address) external view returns (uint256);
    function transfer(address, uint256) external returns (bool);
    function allowance(address, address) external view returns (uint256);
    function approve(address, uint256) external returns (bool);
    function approve(address) public returns (bool);
    function transferFrom(address, address, uint256) external returns (bool);
    function push(address, uint256) public;
    function pull(address, uint256) public;
    function move(address, address, uint256) public;
    function mint(uint256) public;
    function mint(address,uint) public;
    function burn(uint256) public;
    function burn(address,uint) public;
    function setName(bytes32) public;
    event Transfer(address, address, uint256);
    event Approval(address, address, uint256);
}

////// lib/dss-interfaces/src/dapp/DSValueAbstract.sol
/* pragma solidity ^0.5.12; */

// https://github.com/dapphub/ds-value/blob/master/src/value.sol
contract DSValueAbstract {
    // bool public has;
    function has() public view returns (bool);
    // bytes32 public val;
    function val() public view returns (bytes32);
    function peek() public view returns (bytes32, bool);
    function read() public view returns (bytes32);
    function poke(bytes32) public;
    function void() public;
}
////// lib/dss-interfaces/src/dss/VatAbstract.sol
/* pragma solidity ^0.5.12; */

// https://github.com/makerdao/dss/blob/master/src/vat.sol
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


////// lib/dss-interfaces/src/dss/FlapAbstract.sol
/* pragma solidity ^0.5.12; */

/* import { VatAbstract } from "./VatAbstract.sol"; */
/* import { DSTokenAbstract } from "../dapp/DSTokenAbstract.sol"; */

// https://github.com/makerdao/dss/blob/master/src/flap.sol
contract FlapAbstract {
    //mapping (address => uint256) public wards;
    function wards(address) public view returns (uint256);
    function rely(address) external;
    function deny(address) external;
    struct Bid {
        uint256 bid;
        uint256 lot;
        address guy;  // high bidder
        uint48  tic;  // expiry time
        uint48  end;
    }
    // mapping (uint256 => Bid) public bids;
    function bids(uint256) public view returns (uint256);
    // VatAbstract public vat;
    function vat() public view returns (VatAbstract);
    // TokenAbstract public gem;
    function gem() public view returns (DSTokenAbstract);
    // uint256 public ONE;
    function ONE() public view returns (uint256);
    // uint256 public beg;
    function beg() public view returns (uint256);
    // uint48 public ttl;
    function ttl() public view returns (uint48);
    // uint48 public tau;
    function tau() public view returns (uint48);
    // uint256 public kicks;
    function kicks() public view returns (uint256);
    // uint256 public live;
    function live() public view returns (uint256);
    event Kick(uint256, uint256, uint256);
    function file(bytes32, uint256) external;
    function kick(uint256, uint256) external returns (uint256);
    function tick(uint256) external;
    function tend(uint256, uint256, uint256) external;
    function deal(uint256) external;
    function cage(uint256) external;
    function yank(uint256) external;
}
////// lib/dss-interfaces/src/dss/FlopAbstract.sol
/* pragma solidity ^0.5.12; */

/* import { VatAbstract } from "./VatAbstract.sol"; */
/* import { DSTokenAbstract } from "../dapp/DSTokenAbstract.sol"; */

// https://github.com/makerdao/dss/blob/master/src/flop.sol
contract FlopAbstract {
    // mapping (address => uint256) public wards;
    function wards(address) public view returns (uint256);
    function rely(address) external;
    function deny(address) external;
    struct Bid {
        uint256 bid;
        uint256 lot;
        address guy;  // high bidder
        uint48  tic;  // expiry time
        uint48  end;
    }
    // mapping (uint => Bid) public bids;
    function bids(uint256) public view returns (uint256, uint256, address, uint48, uint48);
    //VatAbstract public vat;
    function vat() public view returns (VatAbstract);
    // TokenAbstract public gem;
    function gem() public view returns (DSTokenAbstract);
    // uint256 public ONE;
    function ONE() public view returns (uint256);
    // uint256 public beg;  // 5% minimum bid increase
    function beg() public view returns (uint256);
    // uint256 public pad;  // 50% lot increase for tick
    function pad() public view returns (uint256);
    // uint48 public ttl;  // 3 hours bid lifetime
    function ttl() public view returns (uint48);
    // uint48 public tau;   // 2 days total auction length
    function tau() public view returns (uint48);
    // uint256 public kicks;
    function kicks() public view returns (uint256);
    // uint256 public live;
    function live() public view returns (uint256);
    // address public vow;
    function vow() public view returns (address);
    event Kick(uint256, uint256, uint256, address);
    function file(bytes32, uint256) external;
    function kick(address, uint256, uint256) external returns (uint256);
    function tick(uint256) external;
    function dent(uint256, uint256, uint256) external;
    function deal(uint256) external;
    function cage() external;
    function yank(uint256) external;
}
////// lib/dss-interfaces/src/dss/VowAbstract.sol
/* pragma solidity ^0.5.12; */

/* import { FlopAbstract } from "./FlopAbstract.sol"; */
/* import { FlapAbstract } from "./FlapAbstract.sol"; */
/* import { VatAbstract } from "./VatAbstract.sol"; */

// https://github.com/makerdao/dss/blob/master/src/vow.sol
contract VowAbstract {
    // mapping (address => uint) public wards;
    function wards(address) public view returns (uint256);
    function rely(address usr) external;
    function deny(address usr) external;
    // VatAbstract public vat;
    function vat() public view returns (VatAbstract);
    // FlapAbstract public flapper;
    function flapper() public view returns (FlapAbstract);
    // FlopAbstract public flopper;
    function flopper() public view returns (FlopAbstract);
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
////// lib/dss-interfaces/src/dss/CatAbstract.sol
/* pragma solidity ^0.5.12; */

/* import { VatAbstract } from "./VatAbstract.sol"; */
/* import { VowAbstract } from "./VowAbstract.sol"; */

// https://github.com/makerdao/dss/blob/master/src/cat.sol
contract CatAbstract {
    // mapping (address => uint) public wards;
    function wards(address) public view returns (uint256);
    function rely(address) external;
    function deny(address) external;
    struct Ilk {
        address flip;  // Liquidator
        uint256 chop;  // Liquidation Penalty   [ray]
        uint256 lump;  // Liquidation Quantity  [wad]
    }
    // mapping (bytes32 => Ilk) public ilks;
    function ilks(bytes32) public view returns (address, uint256, uint256);
    // uint256 public live;
    function live() public view returns (uint256);
    // VatAbstract public vat;
    function vat() public view returns (VatAbstract);
    // VowAbstract public vow;
    function vow() public view returns (VowAbstract);
    event Bite(bytes32, address, uint256, uint256, uint256, address, uint256);
    // uint256 public ONE;
    function ONE() public returns (uint256);
    function file(bytes32, address) external;
    function file(bytes32, bytes32, uint256) external;
    function file(bytes32, bytes32, address) external;
    function bite(bytes32, address) external returns (uint256);
    function cage() external;
}
////// lib/dss-interfaces/src/dss/PotAbstract.sol
/* pragma solidity ^0.5.12; */

/* import { VatAbstract } from "./VatAbstract.sol"; */

// https://github.com/makerdao/dss/blob/master/src/pot.sol
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
    function vat() public view returns (VatAbstract);
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
////// lib/dss-interfaces/src/dss/PipAbstract.sol
/* pragma solidity ^0.5.12; */

/* import { DSValueAbstract } from "../dapp/DSValueAbstract.sol"; */

// Pip is a DS-Value used within the DSS
contract PipAbstract is DSValueAbstract {}
////// lib/dss-interfaces/src/dss/SpotAbstract.sol
/* pragma solidity ^0.5.12; */

/* import { VatAbstract } from "./VatAbstract.sol"; */
/* import { PipAbstract } from "./PipAbstract.sol"; */

// https://github.com/makerdao/dss/blob/master/src/spot.sol
contract SpotAbstract {
    // mapping (address => uint) public wards;
    function wards(address) public view returns (uint256);
    function rely(address) external;
    function deny(address) external;
    struct Ilk {
        PipAbstract pip;
        uint256 mat;
    }
    // mapping (bytes32 => Ilk) public ilks;
    function ilks(bytes32) public view returns (PipAbstract, uint256);
    // VatAbstract public vat;
    function vat() public view returns (VatAbstract);
    // uint256 public par; // ref per dai
    function par() public view returns (uint256);
    // uint256 public live;
    function live() public view returns (uint256);
    event Poke(bytes32, bytes32, uint256);
    // uint256 public ONE;
    function ONE() public view returns (uint256);
    function file(bytes32, bytes32, address) external;
    function file(bytes32, uint256) external;
    function file(bytes32, bytes32, uint256) external;
    function poke(bytes32) external;
    function cage() external;
}
////// lib/dss-interfaces/src/dss/EndAbstract.sol
/* pragma solidity ^0.5.12; */

/* import { VatAbstract } from "./VatAbstract.sol"; */
/* import { CatAbstract } from "./CatAbstract.sol"; */
/* import { VowAbstract } from "./VowAbstract.sol"; */
/* import { PotAbstract } from "./PotAbstract.sol"; */
/* import { SpotAbstract } from "./SpotAbstract.sol"; */

// https://github.com/makerdao/dss/blob/master/src/end.sol
contract EndAbstract {
    // mapping (address => uint) public wards;
    function wards(address) public view returns (uint256);
    function rely(address) external;
    function deny(address) external;
    // VatAbstract public vat;
    function vat() public view returns (VatAbstract);
    // CatAbstract public cat;
    function cat() public view returns (CatAbstract);
    // VowAbstract public vow;
    function vow() public view returns (VowAbstract);
    // PotAbstract public pot;
    function pot() public view returns (PotAbstract);
    // SpotAbstract public spot;
    function spot() public view returns (SpotAbstract);
    // uint256  public live;  // cage flag
    function live() public view returns (uint256);
    // uint256  public when;  // time of cage
    function when() public view returns (uint256);
    //uint256  public wait;  // processing cooldown length
    function wait() public view returns (uint256);
    // uint256  public debt;  // total outstanding dai following processing [rad]
    function debt() public view returns (uint256);
    // mapping (bytes32 => uint256) public tag;  // cage price           [ray]
    function tag(bytes32) public view returns (uint256);
    // mapping (bytes32 => uint256) public gap;  // collateral shortfall [wad]
    function gap(bytes32) public view returns (uint256);
    // mapping (bytes32 => uint256) public Art;  // total debt per ilk   [wad]
    function Art(bytes32) public view returns (uint256);
    // mapping (bytes32 => uint256) public fix;  // final cash price     [ray]
    function fix(bytes32) public view returns (uint256);
    // mapping (address => uint256) public bag;  // [wad]
    function bag(address) public view returns (uint256);
    // mapping (bytes32 => mapping (address => uint256)) public out;  // [wad]
    function out(bytes32, address) public view returns (uint256);
    // uint256 public WAD;
    function WAD() public view returns (uint256);
    // uint256 public RAY;
    function RAY() public view returns (uint256);
    function file(bytes32, address) external;
    function file(bytes32, uint256) external;
    function cage() external;
    function cage(bytes32) external;
    function skip(bytes32, uint256) external;
    function skim(bytes32, address) external;
    function free(bytes32) external;
    function thaw() external;
    function flow(bytes32) external;
    function pack(uint256) external;
    function cash(bytes32, uint256) external;
}
////// src/McdLaunchESSpell.sol
// Copyright (C) 2019 Maker Foundation
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

/* pragma solidity ^0.5.12; */

/* import "ds-math/math.sol"; */

/* import { DSPauseAbstract } from "lib/dss-interfaces/src/dapp/DSPauseAbstract.sol"; */
/* import { EndAbstract } from "lib/dss-interfaces/src/dss/EndAbstract.sol"; */

contract ShutdownAction {
    address constant END = 0xaB14d3CE3F733CACB76eC2AbE7d2fcb00c99F3d5;

    function execute() public {
        EndAbstract end = EndAbstract(END);

        // First we freeze the system and lock the prices for each ilk
        end.cage();

        // The foundation cage keeper process will detect the end.cage() and
        //   initiate a cage of all of the ilks in the system. These are not
        //   caged in the spell because they are unauthed calls that can be
        //   initiated against the end module by any community member after
        //   the End module is caged, and it is not worth risking a revert.
        // end.cage('ETH-A');
        // end.cage('BAT-A');
        // end.cage('SAI');
    }
}

// Spell to trigger MCD Emergency Shutdown via governance action
contract McdLaunchESSpell is DSMath {
    DSPauseAbstract public pause = DSPauseAbstract(0xbE286431454714F511008713973d3B053A2d38f3);
    address         public action;
    bytes32         public tag;
    uint256         public eta;
    bytes           public sig;
    bool            public done;

    constructor() public {
        sig = abi.encodeWithSignature("execute()");
        action = address(new ShutdownAction());
        bytes32 _tag;
        address _action = action;
        assembly { _tag := extcodehash(_action) }
        tag = _tag;
    }

    function schedule() public {
        require(eta == 0, "spell-already-scheduled");
        eta = add(now, DSPauseAbstract(pause).delay());
        pause.plot(action, tag, sig, eta);
    }

    function cast() public {
        require(!done, "spell-already-cast");
        done = true;
        pause.exec(action, tag, sig, eta);
    }
}

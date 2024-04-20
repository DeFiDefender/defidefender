// Verified using https://dapp.tools

// hevm: flattened sources of src/nftfeed.sol
pragma solidity >=0.4.23 >=0.5.15 >=0.5.15 <0.6.0;

////// lib/tinlake-auth/lib/ds-note/src/note.sol
/// note.sol -- the `note' modifier, for logging calls as events

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
/* pragma solidity >=0.5.15; */

contract DSNote {
    event LogNote(
        bytes4   indexed  sig,
        address  indexed  guy,
        bytes32  indexed  foo,
        bytes32  indexed  bar,
        uint256           wad,
        bytes             fax
    ) anonymous;

    modifier note {
        bytes32 foo;
        bytes32 bar;
        uint256 wad;

        assembly {
            foo := calldataload(4)
            bar := calldataload(36)
            wad := callvalue()
        }

        _;

        emit LogNote(msg.sig, msg.sender, foo, bar, wad, msg.data);
    }
}

////// lib/tinlake-auth/src/auth.sol
// Copyright (C) Centrifuge 2020, based on MakerDAO dss https://github.com/makerdao/dss
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

/* pragma solidity >=0.5.15 <0.6.0; */

/* import "ds-note/note.sol"; */

contract Auth is DSNote {
    mapping (address => uint) public wards;
    function rely(address usr) public auth note { wards[usr] = 1; }
    function deny(address usr) public auth note { wards[usr] = 0; }
    modifier auth { require(wards[msg.sender] == 1); _; }
}

////// lib/tinlake-math/src/math.sol
// Copyright (C) 2018 Rain <rainbreak@riseup.net>
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

/* pragma solidity >=0.5.15 <0.6.0; */

contract Math {
    uint256 constant ONE = 10 ** 27;

    function safeAdd(uint x, uint y) public pure returns (uint z) {
        require((z = x + y) >= x);
    }

    function safeSub(uint x, uint y) public pure returns (uint z) {
        require((z = x - y) <= x);
    }

    function safeMul(uint x, uint y) public pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x);
    }

    function safeDiv(uint x, uint y) public pure returns (uint z) {
        z = x / y;
    }

    function rmul(uint x, uint y) public pure returns (uint z) {
        z = safeMul(x, y) / ONE;
    }

    function rdiv(uint x, uint y) public pure returns (uint z) {
        require(y > 0, "division by zero");
        z = safeAdd(safeMul(x, ONE), y / 2) / y;
    }

    function rdivup(uint x, uint y) internal pure returns (uint z) {
        require(y > 0, "division by zero");
        // always rounds up
        z = safeAdd(safeMul(x, ONE), safeSub(y, 1)) / y;
    }


}

////// src/nftfeed.sol
// Copyright (C) 2020 Centrifuge

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

/* pragma solidity >=0.5.15; */

/* import "ds-note/note.sol"; */
/* import "tinlake-auth/auth.sol"; */
/* import "tinlake-math/math.sol"; */

contract ShelfLike {
    function shelf(uint loan) public view returns (address registry, uint tokenId);
    function nftlookup(bytes32 nftID) public returns (uint loan);
}

contract PileLike {
    function setRate(uint loan, uint rate) public;
    function debt(uint loan) public returns (uint);
    function pie(uint loan) public returns (uint);
    function changeRate(uint loan, uint newRate) public;
    function loanRates(uint loan) public returns (uint);
    function file(bytes32, uint, uint) public;
    function rates(uint rate) public view returns(uint, uint, uint ,uint48);
}

contract BaseNFTFeed is DSNote, Auth, Math {
    // nftID => nftValues
    mapping (bytes32 => uint) public nftValues;
    // nftID => risk
    mapping (bytes32 => uint) public risk;

    // risk => thresholdRatio
    mapping (uint => uint) public thresholdRatio;
    // risk => ceilingRatio
    mapping (uint => uint) public ceilingRatio;

    // loan => borrowed
    mapping (uint => uint) public borrowed;

    PileLike pile;
    ShelfLike shelf;

    constructor () public {
        wards[msg.sender] = 1;
    }

    function init() public {
    require(thresholdRatio[0] == 0);
        // risk groups are pre-defined and should not change
        // gas optimized initialization of risk groups
        /*
        11 =>    1000000003488077118214104515
        11.5 =>  1000000003646626078132927447
        12   =>  1000000003805175038051750380
        12.5 =>  1000000003963723997970573313
        13   =>  1000000004122272957889396245
        13.5 =>  1000000004280821917808219178
        14   =>  1000000004439370877727042110
        14.5 =>  1000000004597919837645865043
        15   =>  1000000004756468797564687975
        */
        // 11 %
    setRiskGroup(0, ONE, 95*10**25, uint(1000000003488077118214104515));
        // 11. 5 %
    setRiskGroup(1, ONE, 95*10**25, uint(1000000003646626078132927447));
        // 12 %
    setRiskGroup(2, ONE, 95*10**25, uint(1000000003805175038051750380));
        // 12.5 %
    setRiskGroup(3, ONE, 95*10**25, uint(1000000003963723997970573313));
        // 13 %
    setRiskGroup(4, ONE, 95*10**25, uint(1000000004122272957889396245));
        // 13.5 %
    setRiskGroup(5, ONE, 95*10**25, uint(1000000004280821917808219178));
        // 14 %
    setRiskGroup(6, ONE, 95*10**25, uint(1000000004439370877727042110));
        // 14.5 %
    setRiskGroup(7, ONE, 95*10**25, uint(1000000004597919837645865043));
        // 15 %
    setRiskGroup(8, ONE, 95*10**25, uint(1000000004756468797564687975));
    }

    /// sets the dependency to another contract
    function depend(bytes32 contractName, address addr) external auth {
        if (contractName == "pile") {pile = PileLike(addr);}
        else if (contractName == "shelf") { shelf = ShelfLike(addr); }
        else revert();
    }

    /// returns a unique id based on registry and tokenId
    /// the nftID allows to define a risk group and an nft value
    /// before a loan is issued
    function nftID(address registry, uint tokenId) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(registry, tokenId));
    }

    function nftID(uint loan) public view returns (bytes32) {
        (address registry, uint tokenId) = shelf.shelf(loan);
        return nftID(registry, tokenId);
    }

    /// Admin -- Updates
    function setRiskGroup(uint risk_, uint thresholdRatio_, uint ceilingRatio_, uint rate_) internal {
        thresholdRatio[risk_] = thresholdRatio_;
        ceilingRatio[risk_] = ceilingRatio_;
        // the risk group is used as a rate id in the pile
        pile.file("rate", risk_, rate_);
    }

    ///  -- Oracle Updates --

    /// update the nft value
    function update(bytes32 nftID_,  uint value) public auth {
        nftValues[nftID_] = value;
    }

    /// update the nft value and change the risk group
    function update(bytes32 nftID_, uint value, uint risk_) public auth {
        require(thresholdRatio[risk_] != 0, "threshold for risk group not defined");

        // change to new rate immediately in pile if a loan debt exists
        // if pie is equal to 0 (no loan debt exists) the rate is set
        // in the borrowEvent method to keep the frequently called update method gas efficient
        uint loan = shelf.nftlookup(nftID_);
        if (pile.pie(loan) != 0) {
            pile.changeRate(loan, risk_);
        }

        risk[nftID_] = risk_;
        nftValues[nftID_] = value;
    }

    // method is called by the pile to check the ceiling
    function borrow(uint loan, uint amount) external auth {
        // ceiling check uses existing loan debt

        borrowed[loan] = safeAdd(borrowed[loan], amount);

        require(initialCeiling(loan) >= borrowed[loan], "borrow-amount-too-high");
    }

    // method is called by the pile to check the ceiling
    function repay(uint loan, uint amount) external auth {}

    // borrowEvent is called by the shelf in the borrow method
    function borrowEvent(uint loan) public auth {
        uint risk_ = risk[nftID(loan)];

        // condition is only true if there is no outstanding debt
        // if the rate has been changed with the update method
        // the pile rate is already up to date
        if(pile.loanRates(loan) != risk_) {
            pile.setRate(loan, risk_);
        }
    }

    // unlockEvent is called by the shelf.unlock method
    function unlockEvent(uint loan) public auth {}

    ///  -- Getter methods --
    /// returns the ceiling of a loan
    /// the ceiling defines the maximum amount which can be borrowed
    function ceiling(uint loan) public view returns (uint) {
        return safeSub(initialCeiling(loan), borrowed[loan]);
    }

    function initialCeiling(uint loan) public view returns(uint) {
        bytes32 nftID_ = nftID(loan);
        return rmul(nftValues[nftID_], ceilingRatio[risk[nftID_]]);
    }

    /// returns the threshold of a loan
    /// if the loan debt is above the loan threshold the NFT can be seized
    function threshold(uint loan) public view returns (uint) {
        bytes32 nftID_ = nftID(loan);
        return rmul(nftValues[nftID_], thresholdRatio[risk[nftID_]]);
    }
}

// Verified using https://dapp.tools

// hevm: flattened sources of src/lender/tranche/operator/proportional.sol
pragma solidity >=0.5.15 >=0.5.15 <0.6.0;

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

////// src/lender/tranche/operator/proportional.sol
// Copyright (C) 2020 Centrifuge
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
/* import "tinlake-math/math.sol"; */
/* import "tinlake-auth/auth.sol"; */

contract TrancheLike_4 {
    function supply(address usr, uint currencyAmount, uint tokenAmount) public;
    function redeem(address usr, uint currencyAmount, uint tokenAmount) public;
    function tokenSupply() public returns (uint);
}

contract AssessorLike_5 {
    function calcAndUpdateTokenPrice(address tranche) public returns(uint);
    function supplyApprove(address tranche, uint currencyAmount) public returns(bool);
    function redeemApprove(address tranche, uint currencyAmount) public returns(bool);
    function tokenAmountForONE() public returns(uint);
}

contract DistributorLike_4 {
    function balance() public;
}

contract ProportionalOperator is Math, DSNote, Auth  {
    TrancheLike_4 public tranche;
    AssessorLike_5 public assessor;
    DistributorLike_4 public distributor;

    // investor mappings
    // each value in a own map for gas-optimization
    mapping (address => uint) public supplyMaximum;
    mapping (address => uint) public tokenReceived;
    // helper we could also calculate based on principalRedeemed
    mapping (address => uint) public tokenRedeemed;

    // currency amount of investor's share in the pool which has already been redeemed
    // denominated: in totalCurrencyReturned units
    mapping (address => uint) public currencyRedeemed;

    // principal amount of investor's share in the pool which has already been redeemed
    // denominated: in totalPrincipalReturned units
    mapping (address => uint) public principalRedeemed;

    bool public supplyAllowed  = true;

    // denominated in currency
    uint public totalCurrencyReturned;

    // denominated in currency
    uint public totalPrincipalReturned;

    // denominated in currency
    uint public totalPrincipal;

    constructor(address tranche_, address assessor_, address distributor_) public {
        wards[msg.sender] = 1;
        tranche = TrancheLike_4(tranche_);
        assessor = AssessorLike_5(assessor_);
        distributor = DistributorLike_4(distributor_);
    }

    /// sets the dependency to another contract
    function depend(bytes32 contractName, address addr) public auth {
        if (contractName == "tranche") { tranche = TrancheLike_4(addr); }
        else if (contractName == "assessor") { assessor = AssessorLike_5(addr); }
        else if (contractName == "distributor") { distributor = DistributorLike_4(addr); }
        else revert();
    }

    function file(bytes32 what, address usr, uint supplyMaximum_, uint tokenReceived_, uint tokenRedeemed_, uint currencyRedeemed_, uint principalRedeemed_) external auth {
        if(what == "resetUsr") {
            approve(usr, supplyMaximum_);
            tokenReceived[usr] = tokenReceived_;
            tokenRedeemed[usr] = tokenRedeemed_;
            currencyRedeemed[usr] = currencyRedeemed_;
            principalRedeemed[usr] = principalRedeemed_;
        } else { revert("unknown parameter");}
    }

    function file(bytes32 what, bool supplyAllowed_) public auth {
        if(what == "supplyAllowed") {
            supplyAllowed = supplyAllowed_;
        }
    }
    /// defines the max amount of currency for supply
    function approve(address usr, uint currencyAmount) public auth {
        supplyMaximum[usr] = currencyAmount;
    }

    function updateReturned(uint currencyReturned_, uint principalReturned_) public auth {
        totalCurrencyReturned  = safeAdd(totalCurrencyReturned, currencyReturned_);
        totalPrincipalReturned = safeAdd(totalPrincipalReturned, principalReturned_);
    }

    function setReturned(uint currencyReturned_, uint principalReturned_) public auth {
        totalCurrencyReturned  = currencyReturned_;
        totalPrincipalReturned = principalReturned_;
    }

    /// only approved investors can supply and approved
    function supply(uint currencyAmount) external note {
        require(supplyAllowed);

        tokenReceived[msg.sender] = safeAdd(tokenReceived[msg.sender], currencyAmount);

        require(tokenReceived[msg.sender] <= supplyMaximum[msg.sender], "currency-amount-above-supply-maximum");

        require(assessor.supplyApprove(address(tranche), currencyAmount), "supply-not-approved");

        // pre-defined tokenPrice of ONE
        uint tokenAmount = currencyAmount;

        tranche.supply(msg.sender, currencyAmount, tokenAmount);

        totalPrincipal = safeAdd(totalPrincipal, currencyAmount);

        distributor.balance();
    }

    /// redeem is proportional allowed
    function redeem(uint tokenAmount) external note {
        distributor.balance();

        // maxTokenAmount that can still be redeemed based on the investor's share in the pool
        uint maxTokenAmount = calcMaxRedeemToken(msg.sender);

        if (tokenAmount > maxTokenAmount) {
            tokenAmount = maxTokenAmount;
        }

        uint currencyAmount = calcRedeemCurrencyAmount(msg.sender, tokenAmount, maxTokenAmount);

        require(assessor.redeemApprove(address(tranche), currencyAmount), "redeem-not-approved");
        tokenRedeemed[msg.sender] = safeAdd(tokenRedeemed[msg.sender], tokenAmount);
        tranche.redeem(msg.sender, currencyAmount, tokenAmount);
    }

    /// calculates the current max amount of tokens a user can redeem
    /// the max amount of token depends on the total principal returned
    /// and previous redeem actions of the user
    function calcMaxRedeemToken(address usr) public view returns(uint) {
        if (supplyAllowed) {
            return 0;
        }
        // assumes a initial token price of ONE
        return safeSub(rmul(rdiv(totalPrincipalReturned, totalPrincipal), tokenReceived[usr]), tokenRedeemed[usr]);
    }

    /// calculates the amount of currency a user can redeem for a specific token amount
    /// the used token price for the conversion can be different among users depending on their
    /// redeem history.
    function calcRedeemCurrencyAmount(address usr, uint tokenAmount, uint maxTokenAmount) internal returns(uint) {
        // solidity gas-optimized calculation avoiding local variable if possible
        uint currencyAmount = rmul(tokenAmount, calcTokenPrice(usr));

        uint redeemRatio = rdiv(tokenAmount, maxTokenAmount);

        currencyRedeemed[usr] = safeAdd(rmul(safeSub(totalCurrencyReturned, currencyRedeemed[usr]),
            redeemRatio), currencyRedeemed[usr]);

        principalRedeemed[usr] = safeAdd(rmul(safeSub(totalPrincipalReturned, principalRedeemed[usr]),
            redeemRatio), principalRedeemed[usr]);

        return currencyAmount;
    }

     function calcTokenPrice(address usr) public view returns (uint) {
        if (totalPrincipalReturned == 0)  {
            return ONE;
        }

        uint principalLeft = safeSub(totalPrincipalReturned, principalRedeemed[usr]);
        if (principalLeft == 0) {
            return 0;
        }

       return rdiv(safeSub(totalCurrencyReturned, currencyRedeemed[usr]), principalLeft);
    }
}

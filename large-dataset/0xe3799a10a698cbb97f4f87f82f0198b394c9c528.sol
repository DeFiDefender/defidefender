/* Orchid - WebRTC P2P VPN Market (on Ethereum)

 * Copyright (C) 2017-2019  The Orchid Authors

*/



/* GNU Affero General Public License, Version 3 {{{ */

/*

 * This program is free software: you can redistribute it and/or modify

 * it under the terms of the GNU Affero General Public License as published by

 * the Free Software Foundation, either version 3 of the License, or

 * (at your option) any later version.



 * This program is distributed in the hope that it will be useful,

 * but WITHOUT ANY WARRANTY; without even the implied warranty of

 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the

 * GNU Affero General Public License for more details.



 * You should have received a copy of the GNU Affero General Public License

 * along with this program.  If not, see <http://www.gnu.org/licenses/>.

**/

/* }}} */





pragma solidity 0.5.13;



interface OrchidVerifier {

    function book(address funder, address signer, bytes calldata shared, address target, uint128 amount, uint128 ratio, bytes calldata receipt) external pure;

}



contract OrchidFailer is OrchidVerifier {

    function kill() external {

        selfdestruct(msg.sender);

    }



    function book(address, address, bytes calldata, address, uint128, uint128, bytes calldata) external pure {

        require(false);

    }

}

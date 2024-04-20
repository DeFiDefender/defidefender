// File: ERC20.sol



pragma solidity ^0.5.10;



/// @title ERC20 interface is a subset of the ERC20 specification.

/// @notice see https://github.com/ethereum/EIPs/issues/20

interface ERC20 {

    function allowance(address _owner, address _spender) external view returns (uint256);

    function approve(address _spender, uint256 _value) external returns (bool);

    function balanceOf(address _who) external view returns (uint256);

    function totalSupply() external view returns (uint256);

    function transfer(address _to, uint256 _value) external returns (bool);

    function transferFrom(address _from, address _to, uint256 _value) external returns (bool);

}



// File: SafeMath.sol



pragma solidity ^0.5.0;



/**

 * @dev Wrappers over Solidity's arithmetic operations with added overflow

 * checks.

 *

 * Arithmetic operations in Solidity wrap on overflow. This can easily result

 * in bugs, because programmers usually assume that an overflow raises an

 * error, which is the standard behavior in high level programming languages.

 * `SafeMath` restores this intuition by reverting the transaction when an

 * operation overflows.

 *

 * Using this library instead of the unchecked operations eliminates an entire

 * class of bugs, so it's recommended to use it always.

 */

library SafeMath {

    /**

     * @dev Returns the addition of two unsigned integers, reverting on

     * overflow.

     *

     * Counterpart to Solidity's `+` operator.

     *

     * Requirements:

     * - Addition cannot overflow.

     */

    function add(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a + b;

        require(c >= a, "SafeMath: addition overflow");



        return c;

    }



    /**

     * @dev Returns the subtraction of two unsigned integers, reverting on

     * overflow (when the result is negative).

     *

     * Counterpart to Solidity's `-` operator.

     *

     * Requirements:

     * - Subtraction cannot overflow.

     */

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {

        require(b <= a, "SafeMath: subtraction overflow");

        uint256 c = a - b;



        return c;

    }



    /**

     * @dev Returns the multiplication of two unsigned integers, reverting on

     * overflow.

     *

     * Counterpart to Solidity's `*` operator.

     *

     * Requirements:

     * - Multiplication cannot overflow.

     */

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {

        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the

        // benefit is lost if 'b' is also tested.

        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522

        if (a == 0) {

            return 0;

        }



        uint256 c = a * b;

        require(c / a == b, "SafeMath: multiplication overflow");



        return c;

    }



    /**

     * @dev Returns the integer division of two unsigned integers. Reverts on

     * division by zero. The result is rounded towards zero.

     *

     * Counterpart to Solidity's `/` operator. Note: this function uses a

     * `revert` opcode (which leaves remaining gas untouched) while Solidity

     * uses an invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     * - The divisor cannot be zero.

     */

    function div(uint256 a, uint256 b) internal pure returns (uint256) {

        // Solidity only automatically asserts when dividing by 0

        require(b > 0, "SafeMath: division by zero");

        uint256 c = a / b;

        // assert(a == b * c + a % b); // There is no case in which this doesn't hold



        return c;

    }



    /**

     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),

     * Reverts when dividing by zero.

     *

     * Counterpart to Solidity's `%` operator. This function uses a `revert`

     * opcode (which leaves remaining gas untouched) while Solidity uses an

     * invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     * - The divisor cannot be zero.

     */

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {

        require(b != 0, "SafeMath: modulo by zero");

        return a % b;

    }

}



// File: Address.sol



pragma solidity ^0.5.0;



/**

 * @dev Collection of functions related to the address type,

 */

library Address {

    /**

     * @dev Returns true if `account` is a contract.

     *

     * This test is non-exhaustive, and there may be false-negatives: during the

     * execution of a contract's constructor, its address will be reported as

     * not containing a contract.

     *

     * > It is unsafe to assume that an address for which this function returns

     * false is an externally-owned account (EOA) and not a contract.

     */

    function isContract(address account) internal view returns (bool) {

        // This method relies in extcodesize, which returns 0 for contracts in

        // construction, since the code is only stored at the end of the

        // constructor execution.



        uint256 size;

        // solhint-disable-next-line no-inline-assembly

        assembly { size := extcodesize(account) }

        return size > 0;

    }

}



// File: SafeERC20.sol



/**

 * The MIT License (MIT)

 *

 * Copyright (c) 2016-2019 zOS Global Limited

 *

 * Permission is hereby granted, free of charge, to any person obtaining

 * a copy of this software and associated documentation files (the

 * "Software"), to deal in the Software without restriction, including

 * without limitation the rights to use, copy, modify, merge, publish,

 * distribute, sublicense, and/or sell copies of the Software, and to

 * permit persons to whom the Software is furnished to do so, subject to

 * the following conditions:

 *

 * The above copyright notice and this permission notice shall be included

 * in all copies or substantial portions of the Software.

 *

 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS

 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF

 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.

 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY

 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,

 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE

 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

 */



pragma solidity ^0.5.0;









/**

 * @title SafeERC20

 * @dev Wrappers around ERC20 operations that throw on failure (when the token

 * contract returns false). Tokens that return no value (and instead revert or

 * throw on failure) are also supported, non-reverting calls are assumed to be

 * successful.

 * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,

 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.

 */

library SafeERC20 {

    using SafeMath for uint256;

    using Address for address;



    function safeTransfer(ERC20 token, address to, uint256 value) internal {

        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));

    }



    function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {

        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));

    }



    function safeApprove(ERC20 token, address spender, uint256 value) internal {

        // safeApprove should only be called when setting an initial allowance,

        // or when resetting it to zero. To increase and decrease it, use

        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'

        // solhint-disable-next-line max-line-length

        require((value == 0) || (token.allowance(address(this), spender) == 0),

            "SafeERC20: approve from non-zero to non-zero allowance"

        );

        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));

    }



    function safeIncreaseAllowance(ERC20 token, address spender, uint256 value) internal {

        uint256 newAllowance = token.allowance(address(this), spender).add(value);

        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));

    }



    function safeDecreaseAllowance(ERC20 token, address spender, uint256 value) internal {

        uint256 newAllowance = token.allowance(address(this), spender).sub(value);

        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));

    }



    /**

     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement

     * on the return value: the return value is optional (but if data is returned, it must not be false).

     * @param token The token targeted by the call.

     * @param data The call data (encoded using abi.encode or one of its variants).

     */

    function callOptionalReturn(ERC20 token, bytes memory data) internal {

        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since

        // we're implementing it ourselves.



        // A Solidity high level call has three parts:

        //  1. The target address is checked to verify it contains contract code

        //  2. The call itself is made, and success asserted

        //  3. The return value is decoded, which in turn checks the size of the returned data.

        // solhint-disable-next-line max-line-length

        require(address(token).isContract(), "SafeERC20: call to non-contract");



        // solhint-disable-next-line avoid-low-level-calls

        (bool success, bytes memory returndata) = address(token).call(data);

        require(success, "SafeERC20: low-level call failed");



        if (returndata.length > 0) { // Return data is optional

            // solhint-disable-next-line max-line-length

            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");

        }

    }

}



// File: transferrable.sol



/**

 *  Transferrable - The Consumer Contract Wallet

 *  Copyright (C) 2019 The Contract Wallet Company Limited

 *

 *  This program is free software: you can redistribute it and/or modify

 *  it under the terms of the GNU General Public License as published by

 *  the Free Software Foundation, either version 3 of the License, or

 *  (at your option) any later version.



 *  This program is distributed in the hope that it will be useful,

 *  but WITHOUT ANY WARRANTY; without even the implied warranty of

 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the

 *  GNU General Public License for more details.



 *  You should have received a copy of the GNU General Public License

 *  along with this program.  If not, see <https://www.gnu.org/licenses/>.

 */



pragma solidity ^0.5.10;









/// @title SafeTransfer, allowing contract to withdraw tokens accidentally sent to itself

contract Transferrable {



    using SafeERC20 for ERC20;





    /// @dev This function is used to move tokens sent accidentally to this contract method.

    /// @dev The owner can chose the new destination address

    /// @param _to is the recipient's address.

    /// @param _asset is the address of an ERC20 token or 0x0 for ether.

    /// @param _amount is the amount to be transferred in base units.

    function _safeTransfer(address payable _to, address _asset, uint _amount) internal {

        // address(0) is used to denote ETH

        if (_asset == address(0)) {

            _to.transfer(_amount);

        } else {

            ERC20(_asset).safeTransfer(_to, _amount);

        }

    }

}



// File: balanceable.sol



/**

 *  Balanceable - The Consumer Contract Wallet

 *  Copyright (C) 2019 The Contract Wallet Company Limited

 *

 *  This program is free software: you can redistribute it and/or modify

 *  it under the terms of the GNU General Public License as published by

 *  the Free Software Foundation, either version 3 of the License, or

 *  (at your option) any later version.



 *  This program is distributed in the hope that it will be useful,

 *  but WITHOUT ANY WARRANTY; without even the implied warranty of

 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the

 *  GNU General Public License for more details.



 *  You should have received a copy of the GNU General Public License

 *  along with this program.  If not, see <https://www.gnu.org/licenses/>.

 */



pragma solidity ^0.5.10;







/// @title Balanceable - This is a contract used to get a balance

contract Balanceable {



    /// @dev This function is used to get a balance

    /// @param _address of which balance we are trying to ascertain

    /// @param _asset is the address of an ERC20 token or 0x0 for ether.

    /// @return balance associated with an address, for any token, in the wei equivalent

    function _balance(address _address, address _asset) internal view returns (uint) {

        if (_asset != address(0)) {

            return ERC20(_asset).balanceOf(_address);

        } else {

            return _address.balance;

        }

    }

}



// File: burner.sol



/**

 *  IBurner - The Consumer Contract Wallet

 *  Copyright (C) 2019 The Contract Wallet Company Limited

 *

 *  This program is free software: you can redistribute it and/or modify

 *  it under the terms of the GNU General Public License as published by

 *  the Free Software Foundation, either version 3 of the License, or

 *  (at your option) any later version.



 *  This program is distributed in the hope that it will be useful,

 *  but WITHOUT ANY WARRANTY; without even the implied warranty of

 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the

 *  GNU General Public License for more details.



 *  You should have received a copy of the GNU General Public License

 *  along with this program.  If not, see <https://www.gnu.org/licenses/>.

 */



pragma solidity ^0.5.10;



// The BurnerToken interface is the interface to a token contract which

// provides the total burnable supply for the TokenHolder contract.

interface IBurner {

    function currentSupply() external view returns (uint);

}



// File: ownable.sol



/**

 *  Ownable - The Consumer Contract Wallet

 *  Copyright (C) 2019 The Contract Wallet Company Limited

 *

 *  This program is free software: you can redistribute it and/or modify

 *  it under the terms of the GNU General Public License as published by

 *  the Free Software Foundation, either version 3 of the License, or

 *  (at your option) any later version.



 *  This program is distributed in the hope that it will be useful,

 *  but WITHOUT ANY WARRANTY; without even the implied warranty of

 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the

 *  GNU General Public License for more details.



 *  You should have received a copy of the GNU General Public License

 *  along with this program.  If not, see <https://www.gnu.org/licenses/>.

 */



pragma solidity ^0.5.10;





/// @title Ownable has an owner address and provides basic authorization control functions.

/// This contract is modified version of the MIT OpenZepplin Ownable contract

/// This contract allows for the transferOwnership operation to be made impossible

/// https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol

contract Ownable {

    event TransferredOwnership(address _from, address _to);

    event LockedOwnership(address _locked);



    address payable private _owner;

    bool private _isTransferable;



    /// @notice Constructor sets the original owner of the contract and whether or not it is one time transferable.

    constructor(address payable _account_, bool _transferable_) internal {

        _owner = _account_;

        _isTransferable = _transferable_;

        // Emit the LockedOwnership event if no longer transferable.

        if (!_isTransferable) {

            emit LockedOwnership(_account_);

        }

        emit TransferredOwnership(address(0), _account_);

    }



    /// @notice Reverts if called by any account other than the owner.

    modifier onlyOwner() {

        require(_isOwner(msg.sender), "sender is not an owner");

        _;

    }



    /// @notice Allows the current owner to transfer control of the contract to a new address.

    /// @param _account address to transfer ownership to.

    /// @param _transferable indicates whether to keep the ownership transferable.

    function transferOwnership(address payable _account, bool _transferable) external onlyOwner {

        // Require that the ownership is transferable.

        require(_isTransferable, "ownership is not transferable");

        // Require that the new owner is not the zero address.

        require(_account != address(0), "owner cannot be set to zero address");

        // Set the transferable flag to the value _transferable passed in.

        _isTransferable = _transferable;

        // Emit the LockedOwnership event if no longer transferable.

        if (!_transferable) {

            emit LockedOwnership(_account);

        }

        // Emit the ownership transfer event.

        emit TransferredOwnership(_owner, _account);

        // Set the owner to the provided address.

        _owner = _account;

    }



    /// @notice check if the ownership is transferable.

    /// @return true if the ownership is transferable.

    function isTransferable() external view returns (bool) {

        return _isTransferable;

    }



    /// @notice Allows the current owner to relinquish control of the contract.

    /// @dev Renouncing to ownership will leave the contract without an owner and unusable.

    /// @dev It will not be possible to call the functions with the `onlyOwner` modifier anymore.

    function renounceOwnership() external onlyOwner {

        // Require that the ownership is transferable.

        require(_isTransferable, "ownership is not transferable");

        // note that this could be terminal

        _owner = address(0);



        emit TransferredOwnership(_owner, address(0));

    }



    /// @notice Find out owner address

    /// @return address of the owner.

    function owner() public view returns (address payable) {

        return _owner;

    }



    /// @notice Check if owner address

    /// @return true if sender is the owner of the contract.

    function _isOwner(address _address) internal view returns (bool) {

        return _address == _owner;

    }

}



// File: controller.sol



/**

 *  Controller - The Consumer Contract Wallet

 *  Copyright (C) 2019 The Contract Wallet Company Limited

 *

 *  This program is free software: you can redistribute it and/or modify

 *  it under the terms of the GNU General Public License as published by

 *  the Free Software Foundation, either version 3 of the License, or

 *  (at your option) any later version.



 *  This program is distributed in the hope that it will be useful,

 *  but WITHOUT ANY WARRANTY; without even the implied warranty of

 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the

 *  GNU General Public License for more details.



 *  You should have received a copy of the GNU General Public License

 *  along with this program.  If not, see <https://www.gnu.org/licenses/>.

 */



pragma solidity ^0.5.10;







/// @title The IController interface provides access to the isController and isAdmin checks.

interface IController {

    function isController(address) external view returns (bool);

    function isAdmin(address) external view returns (bool);

}





/// @title Controller stores a list of controller addresses that can be used for authentication in other contracts.

/// @notice The Controller implements a hierarchy of concepts, Owner, Admin, and the Controllers.

/// @dev Owner can change the Admins

/// @dev Admins and can the Controllers

/// @dev Controllers are used by the application.

contract Controller is IController, Ownable, Transferrable {



    event AddedController(address _sender, address _controller);

    event RemovedController(address _sender, address _controller);



    event AddedAdmin(address _sender, address _admin);

    event RemovedAdmin(address _sender, address _admin);



    event Claimed(address _to, address _asset, uint _amount);



    event Stopped(address _sender);

    event Started(address _sender);



    mapping (address => bool) private _isAdmin;

    uint private _adminCount;



    mapping (address => bool) private _isController;

    uint private _controllerCount;



    bool private _stopped;



    /// @notice Constructor initializes the owner with the provided address.

    /// @param _ownerAddress_ address of the owner.

    constructor(address payable _ownerAddress_) Ownable(_ownerAddress_, false) public {}



    /// @notice Checks if message sender is an admin.

    modifier onlyAdmin() {

        require(isAdmin(msg.sender), "sender is not an admin");

        _;

    }



    /// @notice Check if Owner or Admin

    modifier onlyAdminOrOwner() {

        require(_isOwner(msg.sender) || isAdmin(msg.sender), "sender is not an admin");

        _;

    }



    /// @notice Check if controller is stopped

    modifier notStopped() {

        require(!isStopped(), "controller is stopped");

        _;

    }



    /// @notice Add a new admin to the list of admins.

    /// @param _account address to add to the list of admins.

    function addAdmin(address _account) external onlyOwner notStopped {

        _addAdmin(_account);

    }



    /// @notice Remove a admin from the list of admins.

    /// @param _account address to remove from the list of admins.

    function removeAdmin(address _account) external onlyOwner {

        _removeAdmin(_account);

    }



    /// @return the current number of admins.

    function adminCount() external view returns (uint) {

        return _adminCount;

    }



    /// @notice Add a new controller to the list of controllers.

    /// @param _account address to add to the list of controllers.

    function addController(address _account) external onlyAdminOrOwner notStopped {

        _addController(_account);

    }



    /// @notice Remove a controller from the list of controllers.

    /// @param _account address to remove from the list of controllers.

    function removeController(address _account) external onlyAdminOrOwner {

        _removeController(_account);

    }



    /// @notice count the Controllers

    /// @return the current number of controllers.

    function controllerCount() external view returns (uint) {

        return _controllerCount;

    }



    /// @notice is an address an Admin?

    /// @return true if the provided account is an admin.

    function isAdmin(address _account) public view notStopped returns (bool) {

        return _isAdmin[_account];

    }



    /// @notice is an address a Controller?

    /// @return true if the provided account is a controller.

    function isController(address _account) public view notStopped returns (bool) {

        return _isController[_account];

    }



    /// @notice this function can be used to see if the controller has been stopped

    /// @return true is the Controller has been stopped

    function isStopped() public view returns (bool) {

        return _stopped;

    }



    /// @notice Internal-only function that adds a new admin.

    function _addAdmin(address _account) private {

        require(!_isAdmin[_account], "provided account is already an admin");

        require(!_isController[_account], "provided account is already a controller");

        require(!_isOwner(_account), "provided account is already the owner");

        require(_account != address(0), "provided account is the zero address");

        _isAdmin[_account] = true;

        _adminCount++;

        emit AddedAdmin(msg.sender, _account);

    }



    /// @notice Internal-only function that removes an existing admin.

    function _removeAdmin(address _account) private {

        require(_isAdmin[_account], "provided account is not an admin");

        _isAdmin[_account] = false;

        _adminCount--;

        emit RemovedAdmin(msg.sender, _account);

    }



    /// @notice Internal-only function that adds a new controller.

    function _addController(address _account) private {

        require(!_isAdmin[_account], "provided account is already an admin");

        require(!_isController[_account], "provided account is already a controller");

        require(!_isOwner(_account), "provided account is already the owner");

        require(_account != address(0), "provided account is the zero address");

        _isController[_account] = true;

        _controllerCount++;

        emit AddedController(msg.sender, _account);

    }



    /// @notice Internal-only function that removes an existing controller.

    function _removeController(address _account) private {

        require(_isController[_account], "provided account is not a controller");

        _isController[_account] = false;

        _controllerCount--;

        emit RemovedController(msg.sender, _account);

    }



    /// @notice stop our controllers and admins from being useable

    function stop() external onlyAdminOrOwner {

        _stopped = true;

        emit Stopped(msg.sender);

    }



    /// @notice start our controller again

    function start() external onlyOwner {

        _stopped = false;

        emit Started(msg.sender);

    }



    //// @notice Withdraw tokens from the smart contract to the specified account.

    function claim(address payable _to, address _asset, uint _amount) external onlyAdmin notStopped {

        _safeTransfer(_to, _asset, _amount);

        emit Claimed(_to, _asset, _amount);

    }

}



// File: ENS.sol



/**

 * BSD 2-Clause License

 *

 * Copyright (c) 2018, True Names Limited

 * All rights reserved.

 *

 * Redistribution and use in source and binary forms, with or without

 * modification, are permitted provided that the following conditions are met:

 *

 * * Redistributions of source code must retain the above copyright notice, this

 *   list of conditions and the following disclaimer.

 *

 * * Redistributions in binary form must reproduce the above copyright notice,

 *   this list of conditions and the following disclaimer in the documentation

 *   and/or other materials provided with the distribution.

 *

 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"

 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE

 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE

 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE

 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL

 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR

 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER

 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,

 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE

 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

pragma solidity ^0.5.0;



interface ENS {



    // Logged when the owner of a node assigns a new owner to a subnode.

    event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);



    // Logged when the owner of a node transfers ownership to a new account.

    event Transfer(bytes32 indexed node, address owner);



    // Logged when the resolver for a node changes.

    event NewResolver(bytes32 indexed node, address resolver);



    // Logged when the TTL of a node changes

    event NewTTL(bytes32 indexed node, uint64 ttl);





    function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external;

    function setResolver(bytes32 node, address resolver) external;

    function setOwner(bytes32 node, address owner) external;

    function setTTL(bytes32 node, uint64 ttl) external;

    function owner(bytes32 node) external view returns (address);

    function resolver(bytes32 node) external view returns (address);

    function ttl(bytes32 node) external view returns (uint64);



}



// File: ResolverBase.sol



pragma solidity ^0.5.0;



contract ResolverBase {

    bytes4 private constant INTERFACE_META_ID = 0x01ffc9a7;



    function supportsInterface(bytes4 interfaceID) public pure returns(bool) {

        return interfaceID == INTERFACE_META_ID;

    }



    function isAuthorised(bytes32 node) internal view returns(bool);



    modifier authorised(bytes32 node) {

        require(isAuthorised(node));

        _;

    }

}



// File: ABIResolver.sol



pragma solidity ^0.5.0;





contract ABIResolver is ResolverBase {

    bytes4 constant private ABI_INTERFACE_ID = 0x2203ab56;



    event ABIChanged(bytes32 indexed node, uint256 indexed contentType);



    mapping(bytes32=>mapping(uint256=>bytes)) abis;



    /**

     * Sets the ABI associated with an ENS node.

     * Nodes may have one ABI of each content type. To remove an ABI, set it to

     * the empty string.

     * @param node The node to update.

     * @param contentType The content type of the ABI

     * @param data The ABI data.

     */

    function setABI(bytes32 node, uint256 contentType, bytes calldata data) external authorised(node) {

        // Content types must be powers of 2

        require(((contentType - 1) & contentType) == 0);



        abis[node][contentType] = data;

        emit ABIChanged(node, contentType);

    }



    /**

     * Returns the ABI associated with an ENS node.

     * Defined in EIP205.

     * @param node The ENS node to query

     * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.

     * @return contentType The content type of the return value

     * @return data The ABI data

     */

    function ABI(bytes32 node, uint256 contentTypes) external view returns (uint256, bytes memory) {

        mapping(uint256=>bytes) storage abiset = abis[node];



        for (uint256 contentType = 1; contentType <= contentTypes; contentType <<= 1) {

            if ((contentType & contentTypes) != 0 && abiset[contentType].length > 0) {

                return (contentType, abiset[contentType]);

            }

        }



        return (0, bytes(""));

    }



    function supportsInterface(bytes4 interfaceID) public pure returns(bool) {

        return interfaceID == ABI_INTERFACE_ID || super.supportsInterface(interfaceID);

    }

}



// File: AddrResolver.sol



pragma solidity ^0.5.0;





contract AddrResolver is ResolverBase {

    bytes4 constant private ADDR_INTERFACE_ID = 0x3b3b57de;



    event AddrChanged(bytes32 indexed node, address a);



    mapping(bytes32=>address) addresses;



    /**

     * Sets the address associated with an ENS node.

     * May only be called by the owner of that node in the ENS registry.

     * @param node The node to update.

     * @param addr The address to set.

     */

    function setAddr(bytes32 node, address addr) external authorised(node) {

        addresses[node] = addr;

        emit AddrChanged(node, addr);

    }



    /**

     * Returns the address associated with an ENS node.

     * @param node The ENS node to query.

     * @return The associated address.

     */

    function addr(bytes32 node) public view returns (address) {

        return addresses[node];

    }



    function supportsInterface(bytes4 interfaceID) public pure returns(bool) {

        return interfaceID == ADDR_INTERFACE_ID || super.supportsInterface(interfaceID);

    }

}



// File: ContentHashResolver.sol



pragma solidity ^0.5.0;





contract ContentHashResolver is ResolverBase {

    bytes4 constant private CONTENT_HASH_INTERFACE_ID = 0xbc1c58d1;



    event ContenthashChanged(bytes32 indexed node, bytes hash);



    mapping(bytes32=>bytes) hashes;



    /**

     * Sets the contenthash associated with an ENS node.

     * May only be called by the owner of that node in the ENS registry.

     * @param node The node to update.

     * @param hash The contenthash to set

     */

    function setContenthash(bytes32 node, bytes calldata hash) external authorised(node) {

        hashes[node] = hash;

        emit ContenthashChanged(node, hash);

    }



    /**

     * Returns the contenthash associated with an ENS node.

     * @param node The ENS node to query.

     * @return The associated contenthash.

     */

    function contenthash(bytes32 node) external view returns (bytes memory) {

        return hashes[node];

    }



    function supportsInterface(bytes4 interfaceID) public pure returns(bool) {

        return interfaceID == CONTENT_HASH_INTERFACE_ID || super.supportsInterface(interfaceID);

    }

}



// File: InterfaceResolver.sol



pragma solidity ^0.5.0;







contract InterfaceResolver is ResolverBase, AddrResolver {

    bytes4 constant private INTERFACE_INTERFACE_ID = bytes4(keccak256("interfaceImplementer(bytes32,bytes4)"));

    bytes4 private constant INTERFACE_META_ID = 0x01ffc9a7;



    event InterfaceChanged(bytes32 indexed node, bytes4 indexed interfaceID, address implementer);



    mapping(bytes32=>mapping(bytes4=>address)) interfaces;



    /**

     * Sets an interface associated with a name.

     * Setting the address to 0 restores the default behaviour of querying the contract at `addr()` for interface support.

     * @param node The node to update.

     * @param interfaceID The EIP 168 interface ID.

     * @param implementer The address of a contract that implements this interface for this node.

     */

    function setInterface(bytes32 node, bytes4 interfaceID, address implementer) external authorised(node) {

        interfaces[node][interfaceID] = implementer;

        emit InterfaceChanged(node, interfaceID, implementer);

    }



    /**

     * Returns the address of a contract that implements the specified interface for this name.

     * If an implementer has not been set for this interfaceID and name, the resolver will query

     * the contract at `addr()`. If `addr()` is set, a contract exists at that address, and that

     * contract implements EIP168 and returns `true` for the specified interfaceID, its address

     * will be returned.

     * @param node The ENS node to query.

     * @param interfaceID The EIP 168 interface ID to check for.

     * @return The address that implements this interface, or 0 if the interface is unsupported.

     */

    function interfaceImplementer(bytes32 node, bytes4 interfaceID) external view returns (address) {

        address implementer = interfaces[node][interfaceID];

        if(implementer != address(0)) {

            return implementer;

        }



        address a = addr(node);

        if(a == address(0)) {

            return address(0);

        }



        (bool success, bytes memory returnData) = a.staticcall(abi.encodeWithSignature("supportsInterface(bytes4)", INTERFACE_META_ID));

        if(!success || returnData.length < 32 || returnData[31] == 0) {

            // EIP 168 not supported by target

            return address(0);

        }



        (success, returnData) = a.staticcall(abi.encodeWithSignature("supportsInterface(bytes4)", interfaceID));

        if(!success || returnData.length < 32 || returnData[31] == 0) {

            // Specified interface not supported by target

            return address(0);

        }



        return a;

    }



    function supportsInterface(bytes4 interfaceID) public pure returns(bool) {

        return interfaceID == INTERFACE_INTERFACE_ID || super.supportsInterface(interfaceID);

    }

}



// File: NameResolver.sol



pragma solidity ^0.5.0;





contract NameResolver is ResolverBase {

    bytes4 constant private NAME_INTERFACE_ID = 0x691f3431;



    event NameChanged(bytes32 indexed node, string name);



    mapping(bytes32=>string) names;



    /**

     * Sets the name associated with an ENS node, for reverse records.

     * May only be called by the owner of that node in the ENS registry.

     * @param node The node to update.

     * @param name The name to set.

     */

    function setName(bytes32 node, string calldata name) external authorised(node) {

        names[node] = name;

        emit NameChanged(node, name);

    }



    /**

     * Returns the name associated with an ENS node, for reverse records.

     * Defined in EIP181.

     * @param node The ENS node to query.

     * @return The associated name.

     */

    function name(bytes32 node) external view returns (string memory) {

        return names[node];

    }



    function supportsInterface(bytes4 interfaceID) public pure returns(bool) {

        return interfaceID == NAME_INTERFACE_ID || super.supportsInterface(interfaceID);

    }

}



// File: PubkeyResolver.sol



pragma solidity ^0.5.0;





contract PubkeyResolver is ResolverBase {

    bytes4 constant private PUBKEY_INTERFACE_ID = 0xc8690233;



    event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);



    struct PublicKey {

        bytes32 x;

        bytes32 y;

    }



    mapping(bytes32=>PublicKey) pubkeys;



    /**

     * Sets the SECP256k1 public key associated with an ENS node.

     * @param node The ENS node to query

     * @param x the X coordinate of the curve point for the public key.

     * @param y the Y coordinate of the curve point for the public key.

     */

    function setPubkey(bytes32 node, bytes32 x, bytes32 y) external authorised(node) {

        pubkeys[node] = PublicKey(x, y);

        emit PubkeyChanged(node, x, y);

    }



    /**

     * Returns the SECP256k1 public key associated with an ENS node.

     * Defined in EIP 619.

     * @param node The ENS node to query

     * @return x, y the X and Y coordinates of the curve point for the public key.

     */

    function pubkey(bytes32 node) external view returns (bytes32 x, bytes32 y) {

        return (pubkeys[node].x, pubkeys[node].y);

    }



    function supportsInterface(bytes4 interfaceID) public pure returns(bool) {

        return interfaceID == PUBKEY_INTERFACE_ID || super.supportsInterface(interfaceID);

    }

}



// File: TextResolver.sol



pragma solidity ^0.5.0;





contract TextResolver is ResolverBase {

    bytes4 constant private TEXT_INTERFACE_ID = 0x59d1d43c;



    event TextChanged(bytes32 indexed node, string indexedKey, string key);



    mapping(bytes32=>mapping(string=>string)) texts;



    /**

     * Sets the text data associated with an ENS node and key.

     * May only be called by the owner of that node in the ENS registry.

     * @param node The node to update.

     * @param key The key to set.

     * @param value The text data value to set.

     */

    function setText(bytes32 node, string calldata key, string calldata value) external authorised(node) {

        texts[node][key] = value;

        emit TextChanged(node, key, key);

    }



    /**

     * Returns the text data associated with an ENS node and key.

     * @param node The ENS node to query.

     * @param key The text data key to query.

     * @return The associated text data.

     */

    function text(bytes32 node, string calldata key) external view returns (string memory) {

        return texts[node][key];

    }



    function supportsInterface(bytes4 interfaceID) public pure returns(bool) {

        return interfaceID == TEXT_INTERFACE_ID || super.supportsInterface(interfaceID);

    }

}



// File: PublicResolver.sol



/**

 * BSD 2-Clause License

 *

 * Copyright (c) 2018, True Names Limited

 * All rights reserved.

 *

 * Redistribution and use in source and binary forms, with or without

 * modification, are permitted provided that the following conditions are met:

 *

 * * Redistributions of source code must retain the above copyright notice, this

 *   list of conditions and the following disclaimer.

 *

 * * Redistributions in binary form must reproduce the above copyright notice,

 *   this list of conditions and the following disclaimer in the documentation

 *   and/or other materials provided with the distribution.

 *

 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"

 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE

 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE

 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE

 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL

 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR

 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER

 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,

 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE

 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/



pragma solidity ^0.5.0;



















/**

 * A simple resolver anyone can use; only allows the owner of a node to set its

 * address.

 */

contract PublicResolver is ABIResolver, AddrResolver, ContentHashResolver, InterfaceResolver, NameResolver, PubkeyResolver, TextResolver {

    ENS ens;



    /**

     * A mapping of authorisations. An address that is authorised for a name

     * may make any changes to the name that the owner could, but may not update

     * the set of authorisations.

     * (node, owner, caller) => isAuthorised

     */

    mapping(bytes32=>mapping(address=>mapping(address=>bool))) public authorisations;



    event AuthorisationChanged(bytes32 indexed node, address indexed owner, address indexed target, bool isAuthorised);



    constructor(ENS _ens) public {

        ens = _ens;

    }



    /**

     * @dev Sets or clears an authorisation.

     * Authorisations are specific to the caller. Any account can set an authorisation

     * for any name, but the authorisation that is checked will be that of the

     * current owner of a name. Thus, transferring a name effectively clears any

     * existing authorisations, and new authorisations can be set in advance of

     * an ownership transfer if desired.

     *

     * @param node The name to change the authorisation on.

     * @param target The address that is to be authorised or deauthorised.

     * @param isAuthorised True if the address should be authorised, or false if it should be deauthorised.

     */

    function setAuthorisation(bytes32 node, address target, bool isAuthorised) external {

        authorisations[node][msg.sender][target] = isAuthorised;

        emit AuthorisationChanged(node, msg.sender, target, isAuthorised);

    }



    function isAuthorised(bytes32 node) internal view returns(bool) {

        address owner = ens.owner(node);

        return owner == msg.sender || authorisations[node][owner][msg.sender];

    }

}



// File: ensResolvable.sol



/**

 *  ENSResolvable - The Consumer Contract Wallet

 *  Copyright (C) 2019 The Contract Wallet Company Limited

 *

 *  This program is free software: you can redistribute it and/or modify

 *  it under the terms of the GNU General Public License as published by

 *  the Free Software Foundation, either version 3 of the License, or

 *  (at your option) any later version.



 *  This program is distributed in the hope that it will be useful,

 *  but WITHOUT ANY WARRANTY; without even the implied warranty of

 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the

 *  GNU General Public License for more details.



 *  You should have received a copy of the GNU General Public License

 *  along with this program.  If not, see <https://www.gnu.org/licenses/>.

 */



pragma solidity ^0.5.10;









///@title ENSResolvable - Ethereum Name Service Resolver

///@notice contract should be used to get an address for an ENS node

contract ENSResolvable {

    /// @notice _ens is an instance of ENS

    ENS private _ens;



    /// @notice _ensRegistry points to the ENS registry smart contract.

    address private _ensRegistry;



    /// @param _ensReg_ is the ENS registry used

    constructor(address _ensReg_) internal {

        _ensRegistry = _ensReg_;

        _ens = ENS(_ensRegistry);

    }



    /// @notice this is used to that one can observe which ENS registry is being used

    function ensRegistry() external view returns (address) {

        return _ensRegistry;

    }



    /// @notice helper function used to get the address of a node

    /// @param _node of the ENS entry that needs resolving

    /// @return the address of the said node

    function _ensResolve(bytes32 _node) internal view returns (address) {

        return PublicResolver(_ens.resolver(_node)).addr(_node);

    }



}



// File: controllable.sol



/**

 *  Controllable - The Consumer Contract Wallet

 *  Copyright (C) 2019 The Contract Wallet Company Limited

 *

 *  This program is free software: you can redistribute it and/or modify

 *  it under the terms of the GNU General Public License as published by

 *  the Free Software Foundation, either version 3 of the License, or

 *  (at your option) any later version.



 *  This program is distributed in the hope that it will be useful,

 *  but WITHOUT ANY WARRANTY; without even the implied warranty of

 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the

 *  GNU General Public License for more details.



 *  You should have received a copy of the GNU General Public License

 *  along with this program.  If not, see <https://www.gnu.org/licenses/>.

 */



pragma solidity ^0.5.10;









/// @title Controllable implements access control functionality of the Controller found via ENS.

contract Controllable is ENSResolvable {

    /// @dev Is the registered ENS node identifying the controller contract.

    bytes32 private _controllerNode;



    /// @notice Constructor initializes the controller contract object.

    /// @param _controllerNode_ is the ENS node of the Controller.

    constructor(bytes32 _controllerNode_) internal {

        _controllerNode = _controllerNode_;

    }



    /// @notice Checks if message sender is a controller.

    modifier onlyController() {

        require(_isController(msg.sender), "sender is not a controller");

        _;

    }



    /// @notice Checks if message sender is an admin.

    modifier onlyAdmin() {

        require(_isAdmin(msg.sender), "sender is not an admin");

        _;

    }



    /// @return the controller node registered in ENS.

    function controllerNode() external view returns (bytes32) {

        return _controllerNode;

    }



    /// @return true if the provided account is a controller.

    function _isController(address _account) internal view returns (bool) {

        return IController(_ensResolve(_controllerNode)).isController(_account);

    }



    /// @return true if the provided account is an admin.

    function _isAdmin(address _account) internal view returns (bool) {

        return IController(_ensResolve(_controllerNode)).isAdmin(_account);

    }



}



// File: bytesUtils.sol



/**

 *  BytesUtils - The Consumer Contract Wallet

 *  Copyright (C) 2019 The Contract Wallet Company Limited

 *

 *  This program is free software: you can redistribute it and/or modify

 *  it under the terms of the GNU General Public License as published by

 *  the Free Software Foundation, either version 3 of the License, or

 *  (at your option) any later version.



 *  This program is distributed in the hope that it will be useful,

 *  but WITHOUT ANY WARRANTY; without even the implied warranty of

 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the

 *  GNU General Public License for more details.



 *  You should have received a copy of the GNU General Public License

 *  along with this program.  If not, see <https://www.gnu.org/licenses/>.

 */



pragma solidity ^0.5.10;





/// @title BytesUtils provides basic byte slicing and casting functionality.

library BytesUtils {



    using SafeMath for uint256;



    /// @dev This function converts to an address

    /// @param _bts bytes

    /// @param _from start position

    function _bytesToAddress(bytes memory _bts, uint _from) internal pure returns (address) {



        require(_bts.length >= _from.add(20), "slicing out of range");



        bytes20 convertedAddress;

        uint startByte = _from.add(32); //first 32 bytes denote the array length



        assembly {

            convertedAddress := mload(add(_bts, startByte))

        }



        return address(convertedAddress);

    }



    /// @dev This function slices bytes into bytes4

    /// @param _bts some bytes

    /// @param _from start position

    function _bytesToBytes4(bytes memory _bts, uint _from) internal pure returns (bytes4) {

        require(_bts.length >= _from.add(4), "slicing out of range");



        bytes4 slicedBytes4;

        uint startByte = _from.add(32); //first 32 bytes denote the array length



        assembly {

            slicedBytes4 := mload(add(_bts, startByte))

        }



        return slicedBytes4;



    }



    /// @dev This function slices a uint

    /// @param _bts some bytes

    /// @param _from start position

    // credit to https://ethereum.stackexchange.com/questions/51229/how-to-convert-bytes-to-uint-in-solidity

    // and Nick Johnson https://ethereum.stackexchange.com/questions/4170/how-to-convert-a-uint-to-bytes-in-solidity/4177#4177

    function _bytesToUint256(bytes memory _bts, uint _from) internal pure returns (uint) {

        require(_bts.length >= _from.add(32), "slicing out of range");



        uint convertedUint256;

        uint startByte = _from.add(32); //first 32 bytes denote the array length

        

        assembly {

            convertedUint256 := mload(add(_bts, startByte))

        }



        return convertedUint256;

    }

}



// File: strings.sol



/*

 * Copyright 2016 Nick Johnson

 *

 * Licensed under the Apache License, Version 2.0 (the "License");

 * you may not use this file except in compliance with the License.

 * You may obtain a copy of the License at

 *

 *     http://www.apache.org/licenses/LICENSE-2.0

 *

 * Unless required by applicable law or agreed to in writing, software

 * distributed under the License is distributed on an "AS IS" BASIS,

 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

 * See the License for the specific language governing permissions and

 * limitations under the License.

 */



/*

 * @title String & slice utility library for Solidity contracts.

 * @author Nick Johnson <arachnid@notdot.net>

 *

 * @dev Functionality in this library is largely implemented using an

 *      abstraction called a 'slice'. A slice represents a part of a string -

 *      anything from the entire string to a single character, or even no

 *      characters at all (a 0-length slice). Since a slice only has to specify

 *      an offset and a length, copying and manipulating slices is a lot less

 *      expensive than copying and manipulating the strings they reference.

 *

 *      To further reduce gas costs, most functions on slice that need to return

 *      a slice modify the original one instead of allocating a new one; for

 *      instance, `s.split(".")` will return the text up to the first '.',

 *      modifying s to only contain the remainder of the string after the '.'.

 *      In situations where you do not want to modify the original slice, you

 *      can make a copy first with `.copy()`, for example:

 *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since

 *      Solidity has no memory management, it will result in allocating many

 *      short-lived slices that are later discarded.

 *

 *      Functions that return two slices come in two versions: a non-allocating

 *      version that takes the second slice as an argument, modifying it in

 *      place, and an allocating version that allocates and returns the second

 *      slice; see `nextRune` for example.

 *

 *      Functions that have to copy string data will return strings rather than

 *      slices; these can be cast back to slices for further processing if

 *      required.

 *

 *      For convenience, some functions are provided with non-modifying

 *      variants that create a new slice and return both; for instance,

 *      `s.splitNew('.')` leaves s unmodified, and returns two values

 *      corresponding to the left and right parts of the string.

 */



pragma solidity ^0.5.0;



library strings {

    struct slice {

        uint _len;

        uint _ptr;

    }



    function memcpy(uint dest, uint src, uint len) private pure {

        // Copy word-length chunks while possible

        for(; len >= 32; len -= 32) {

            assembly {

                mstore(dest, mload(src))

            }

            dest += 32;

            src += 32;

        }



        // Copy remaining bytes

        uint mask = 256 ** (32 - len) - 1;

        assembly {

            let srcpart := and(mload(src), not(mask))

            let destpart := and(mload(dest), mask)

            mstore(dest, or(destpart, srcpart))

        }

    }



    /*

     * @dev Returns a slice containing the entire string.

     * @param self The string to make a slice from.

     * @return A newly allocated slice containing the entire string.

     */

    function toSlice(string memory self) internal pure returns (slice memory) {

        uint ptr;

        assembly {

            ptr := add(self, 0x20)

        }

        return slice(bytes(self).length, ptr);

    }



    /*

     * @dev Returns the length of a null-terminated bytes32 string.

     * @param self The value to find the length of.

     * @return The length of the string, from 0 to 32.

     */

    function len(bytes32 self) internal pure returns (uint) {

        uint ret;

        if (self == 0)

            return 0;

        if (uint(self) & 0xffffffffffffffffffffffffffffffff == 0) {

            ret += 16;

            self = bytes32(uint(self) / 0x100000000000000000000000000000000);

        }

        if (uint(self) & 0xffffffffffffffff == 0) {

            ret += 8;

            self = bytes32(uint(self) / 0x10000000000000000);

        }

        if (uint(self) & 0xffffffff == 0) {

            ret += 4;

            self = bytes32(uint(self) / 0x100000000);

        }

        if (uint(self) & 0xffff == 0) {

            ret += 2;

            self = bytes32(uint(self) / 0x10000);

        }

        if (uint(self) & 0xff == 0) {

            ret += 1;

        }

        return 32 - ret;

    }



    /*

     * @dev Returns a slice containing the entire bytes32, interpreted as a

     *      null-terminated utf-8 string.

     * @param self The bytes32 value to convert to a slice.

     * @return A new slice containing the value of the input argument up to the

     *         first null.

     */

    function toSliceB32(bytes32 self) internal pure returns (slice memory ret) {

        // Allocate space for `self` in memory, copy it there, and point ret at it

        assembly {

            let ptr := mload(0x40)

            mstore(0x40, add(ptr, 0x20))

            mstore(ptr, self)

            mstore(add(ret, 0x20), ptr)

        }

        ret._len = len(self);

    }



    /*

     * @dev Returns a new slice containing the same data as the current slice.

     * @param self The slice to copy.

     * @return A new slice containing the same data as `self`.

     */

    function copy(slice memory self) internal pure returns (slice memory) {

        return slice(self._len, self._ptr);

    }



    /*

     * @dev Copies a slice to a new string.

     * @param self The slice to copy.

     * @return A newly allocated string containing the slice's text.

     */

    function toString(slice memory self) internal pure returns (string memory) {

        string memory ret = new string(self._len);

        uint retptr;

        assembly { retptr := add(ret, 32) }



        memcpy(retptr, self._ptr, self._len);

        return ret;

    }



    /*

     * @dev Returns the length in runes of the slice. Note that this operation

     *      takes time proportional to the length of the slice; avoid using it

     *      in loops, and call `slice.empty()` if you only need to know whether

     *      the slice is empty or not.

     * @param self The slice to operate on.

     * @return The length of the slice in runes.

     */

    function len(slice memory self) internal pure returns (uint l) {

        // Starting at ptr-31 means the LSB will be the byte we care about

        uint ptr = self._ptr - 31;

        uint end = ptr + self._len;

        for (l = 0; ptr < end; l++) {

            uint8 b;

            assembly { b := and(mload(ptr), 0xFF) }

            if (b < 0x80) {

                ptr += 1;

            } else if (b < 0xE0) {

                ptr += 2;

            } else if (b < 0xF0) {

                ptr += 3;

            } else if (b < 0xF8) {

                ptr += 4;

            } else if (b < 0xFC) {

                ptr += 5;

            } else {

                ptr += 6;

            }

        }

    }



    /*

     * @dev Returns true if the slice is empty (has a length of 0).

     * @param self The slice to operate on.

     * @return True if the slice is empty, False otherwise.

     */

    function empty(slice memory self) internal pure returns (bool) {

        return self._len == 0;

    }



    /*

     * @dev Returns a positive number if `other` comes lexicographically after

     *      `self`, a negative number if it comes before, or zero if the

     *      contents of the two slices are equal. Comparison is done per-rune,

     *      on unicode codepoints.

     * @param self The first slice to compare.

     * @param other The second slice to compare.

     * @return The result of the comparison.

     */

    function compare(slice memory self, slice memory other) internal pure returns (int) {

        uint shortest = self._len;

        if (other._len < self._len)

            shortest = other._len;



        uint selfptr = self._ptr;

        uint otherptr = other._ptr;

        for (uint idx = 0; idx < shortest; idx += 32) {

            uint a;

            uint b;

            assembly {

                a := mload(selfptr)

                b := mload(otherptr)

            }

            if (a != b) {

                // Mask out irrelevant bytes and check again

                uint256 mask = uint256(-1); // 0xffff...

                if (shortest < 32) {

                    mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);

                }

                uint256 diff = (a & mask) - (b & mask);

                if (diff != 0)

                    return int(diff);

            }

            selfptr += 32;

            otherptr += 32;

        }

        return int(self._len) - int(other._len);

    }



    /*

     * @dev Returns true if the two slices contain the same text.

     * @param self The first slice to compare.

     * @param self The second slice to compare.

     * @return True if the slices are equal, false otherwise.

     */

    function equals(slice memory self, slice memory other) internal pure returns (bool) {

        return compare(self, other) == 0;

    }



    /*

     * @dev Extracts the first rune in the slice into `rune`, advancing the

     *      slice to point to the next rune and returning `self`.

     * @param self The slice to operate on.

     * @param rune The slice that will contain the first rune.

     * @return `rune`.

     */

    function nextRune(slice memory self, slice memory rune) internal pure returns (slice memory) {

        rune._ptr = self._ptr;



        if (self._len == 0) {

            rune._len = 0;

            return rune;

        }



        uint l;

        uint b;

        // Load the first byte of the rune into the LSBs of b

        assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }

        if (b < 0x80) {

            l = 1;

        } else if (b < 0xE0) {

            l = 2;

        } else if (b < 0xF0) {

            l = 3;

        } else {

            l = 4;

        }



        // Check for truncated codepoints

        if (l > self._len) {

            rune._len = self._len;

            self._ptr += self._len;

            self._len = 0;

            return rune;

        }



        self._ptr += l;

        self._len -= l;

        rune._len = l;

        return rune;

    }



    /*

     * @dev Returns the first rune in the slice, advancing the slice to point

     *      to the next rune.

     * @param self The slice to operate on.

     * @return A slice containing only the first rune from `self`.

     */

    function nextRune(slice memory self) internal pure returns (slice memory ret) {

        nextRune(self, ret);

    }



    /*

     * @dev Returns the number of the first codepoint in the slice.

     * @param self The slice to operate on.

     * @return The number of the first codepoint in the slice.

     */

    function ord(slice memory self) internal pure returns (uint ret) {

        if (self._len == 0) {

            return 0;

        }



        uint word;

        uint length;

        uint divisor = 2 ** 248;



        // Load the rune into the MSBs of b

        assembly { word:= mload(mload(add(self, 32))) }

        uint b = word / divisor;

        if (b < 0x80) {

            ret = b;

            length = 1;

        } else if (b < 0xE0) {

            ret = b & 0x1F;

            length = 2;

        } else if (b < 0xF0) {

            ret = b & 0x0F;

            length = 3;

        } else {

            ret = b & 0x07;

            length = 4;

        }



        // Check for truncated codepoints

        if (length > self._len) {

            return 0;

        }



        for (uint i = 1; i < length; i++) {

            divisor = divisor / 256;

            b = (word / divisor) & 0xFF;

            if (b & 0xC0 != 0x80) {

                // Invalid UTF-8 sequence

                return 0;

            }

            ret = (ret * 64) | (b & 0x3F);

        }



        return ret;

    }



    /*

     * @dev Returns the keccak-256 hash of the slice.

     * @param self The slice to hash.

     * @return The hash of the slice.

     */

    function keccak(slice memory self) internal pure returns (bytes32 ret) {

        assembly {

            ret := keccak256(mload(add(self, 32)), mload(self))

        }

    }



    /*

     * @dev Returns true if `self` starts with `needle`.

     * @param self The slice to operate on.

     * @param needle The slice to search for.

     * @return True if the slice starts with the provided text, false otherwise.

     */

    function startsWith(slice memory self, slice memory needle) internal pure returns (bool) {

        if (self._len < needle._len) {

            return false;

        }



        if (self._ptr == needle._ptr) {

            return true;

        }



        bool equal;

        assembly {

            let length := mload(needle)

            let selfptr := mload(add(self, 0x20))

            let needleptr := mload(add(needle, 0x20))

            equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))

        }

        return equal;

    }



    /*

     * @dev If `self` starts with `needle`, `needle` is removed from the

     *      beginning of `self`. Otherwise, `self` is unmodified.

     * @param self The slice to operate on.

     * @param needle The slice to search for.

     * @return `self`

     */

    function beyond(slice memory self, slice memory needle) internal pure returns (slice memory) {

        if (self._len < needle._len) {

            return self;

        }



        bool equal = true;

        if (self._ptr != needle._ptr) {

            assembly {

                let length := mload(needle)

                let selfptr := mload(add(self, 0x20))

                let needleptr := mload(add(needle, 0x20))

                equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))

            }

        }



        if (equal) {

            self._len -= needle._len;

            self._ptr += needle._len;

        }



        return self;

    }



    /*

     * @dev Returns true if the slice ends with `needle`.

     * @param self The slice to operate on.

     * @param needle The slice to search for.

     * @return True if the slice starts with the provided text, false otherwise.

     */

    function endsWith(slice memory self, slice memory needle) internal pure returns (bool) {

        if (self._len < needle._len) {

            return false;

        }



        uint selfptr = self._ptr + self._len - needle._len;



        if (selfptr == needle._ptr) {

            return true;

        }



        bool equal;

        assembly {

            let length := mload(needle)

            let needleptr := mload(add(needle, 0x20))

            equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))

        }



        return equal;

    }



    /*

     * @dev If `self` ends with `needle`, `needle` is removed from the

     *      end of `self`. Otherwise, `self` is unmodified.

     * @param self The slice to operate on.

     * @param needle The slice to search for.

     * @return `self`

     */

    function until(slice memory self, slice memory needle) internal pure returns (slice memory) {

        if (self._len < needle._len) {

            return self;

        }



        uint selfptr = self._ptr + self._len - needle._len;

        bool equal = true;

        if (selfptr != needle._ptr) {

            assembly {

                let length := mload(needle)

                let needleptr := mload(add(needle, 0x20))

                equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))

            }

        }



        if (equal) {

            self._len -= needle._len;

        }



        return self;

    }



    // Returns the memory address of the first byte of the first occurrence of

    // `needle` in `self`, or the first byte after `self` if not found.

    function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {

        uint ptr = selfptr;

        uint idx;



        if (needlelen <= selflen) {

            if (needlelen <= 32) {

                bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));



                bytes32 needledata;

                assembly { needledata := and(mload(needleptr), mask) }



                uint end = selfptr + selflen - needlelen;

                bytes32 ptrdata;

                assembly { ptrdata := and(mload(ptr), mask) }



                while (ptrdata != needledata) {

                    if (ptr >= end)

                        return selfptr + selflen;

                    ptr++;

                    assembly { ptrdata := and(mload(ptr), mask) }

                }

                return ptr;

            } else {

                // For long needles, use hashing

                bytes32 hash;

                assembly { hash := keccak256(needleptr, needlelen) }



                for (idx = 0; idx <= selflen - needlelen; idx++) {

                    bytes32 testHash;

                    assembly { testHash := keccak256(ptr, needlelen) }

                    if (hash == testHash)

                        return ptr;

                    ptr += 1;

                }

            }

        }

        return selfptr + selflen;

    }



    // Returns the memory address of the first byte after the last occurrence of

    // `needle` in `self`, or the address of `self` if not found.

    function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {

        uint ptr;



        if (needlelen <= selflen) {

            if (needlelen <= 32) {

                bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));



                bytes32 needledata;

                assembly { needledata := and(mload(needleptr), mask) }



                ptr = selfptr + selflen - needlelen;

                bytes32 ptrdata;

                assembly { ptrdata := and(mload(ptr), mask) }



                while (ptrdata != needledata) {

                    if (ptr <= selfptr)

                        return selfptr;

                    ptr--;

                    assembly { ptrdata := and(mload(ptr), mask) }

                }

                return ptr + needlelen;

            } else {

                // For long needles, use hashing

                bytes32 hash;

                assembly { hash := keccak256(needleptr, needlelen) }

                ptr = selfptr + (selflen - needlelen);

                while (ptr >= selfptr) {

                    bytes32 testHash;

                    assembly { testHash := keccak256(ptr, needlelen) }

                    if (hash == testHash)

                        return ptr + needlelen;

                    ptr -= 1;

                }

            }

        }

        return selfptr;

    }



    /*

     * @dev Modifies `self` to contain everything from the first occurrence of

     *      `needle` to the end of the slice. `self` is set to the empty slice

     *      if `needle` is not found.

     * @param self The slice to search and modify.

     * @param needle The text to search for.

     * @return `self`.

     */

    function find(slice memory self, slice memory needle) internal pure returns (slice memory) {

        uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);

        self._len -= ptr - self._ptr;

        self._ptr = ptr;

        return self;

    }



    /*

     * @dev Modifies `self` to contain the part of the string from the start of

     *      `self` to the end of the first occurrence of `needle`. If `needle`

     *      is not found, `self` is set to the empty slice.

     * @param self The slice to search and modify.

     * @param needle The text to search for.

     * @return `self`.

     */

    function rfind(slice memory self, slice memory needle) internal pure returns (slice memory) {

        uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);

        self._len = ptr - self._ptr;

        return self;

    }



    /*

     * @dev Splits the slice, setting `self` to everything after the first

     *      occurrence of `needle`, and `token` to everything before it. If

     *      `needle` does not occur in `self`, `self` is set to the empty slice,

     *      and `token` is set to the entirety of `self`.

     * @param self The slice to split.

     * @param needle The text to search for in `self`.

     * @param token An output parameter to which the first token is written.

     * @return `token`.

     */

    function split(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {

        uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);

        token._ptr = self._ptr;

        token._len = ptr - self._ptr;

        if (ptr == self._ptr + self._len) {

            // Not found

            self._len = 0;

        } else {

            self._len -= token._len + needle._len;

            self._ptr = ptr + needle._len;

        }

        return token;

    }



    /*

     * @dev Splits the slice, setting `self` to everything after the first

     *      occurrence of `needle`, and returning everything before it. If

     *      `needle` does not occur in `self`, `self` is set to the empty slice,

     *      and the entirety of `self` is returned.

     * @param self The slice to split.

     * @param needle The text to search for in `self`.

     * @return The part of `self` up to the first occurrence of `delim`.

     */

    function split(slice memory self, slice memory needle) internal pure returns (slice memory token) {

        split(self, needle, token);

    }



    /*

     * @dev Splits the slice, setting `self` to everything before the last

     *      occurrence of `needle`, and `token` to everything after it. If

     *      `needle` does not occur in `self`, `self` is set to the empty slice,

     *      and `token` is set to the entirety of `self`.

     * @param self The slice to split.

     * @param needle The text to search for in `self`.

     * @param token An output parameter to which the first token is written.

     * @return `token`.

     */

    function rsplit(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {

        uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);

        token._ptr = ptr;

        token._len = self._len - (ptr - self._ptr);

        if (ptr == self._ptr) {

            // Not found

            self._len = 0;

        } else {

            self._len -= token._len + needle._len;

        }

        return token;

    }



    /*

     * @dev Splits the slice, setting `self` to everything before the last

     *      occurrence of `needle`, and returning everything after it. If

     *      `needle` does not occur in `self`, `self` is set to the empty slice,

     *      and the entirety of `self` is returned.

     * @param self The slice to split.

     * @param needle The text to search for in `self`.

     * @return The part of `self` after the last occurrence of `delim`.

     */

    function rsplit(slice memory self, slice memory needle) internal pure returns (slice memory token) {

        rsplit(self, needle, token);

    }



    /*

     * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.

     * @param self The slice to search.

     * @param needle The text to search for in `self`.

     * @return The number of occurrences of `needle` found in `self`.

     */

    function count(slice memory self, slice memory needle) internal pure returns (uint cnt) {

        uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;

        while (ptr <= self._ptr + self._len) {

            cnt++;

            ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;

        }

    }



    /*

     * @dev Returns True if `self` contains `needle`.

     * @param self The slice to search.

     * @param needle The text to search for in `self`.

     * @return True if `needle` is found in `self`, false otherwise.

     */

    function contains(slice memory self, slice memory needle) internal pure returns (bool) {

        return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;

    }



    /*

     * @dev Returns a newly allocated string containing the concatenation of

     *      `self` and `other`.

     * @param self The first slice to concatenate.

     * @param other The second slice to concatenate.

     * @return The concatenation of the two strings.

     */

    function concat(slice memory self, slice memory other) internal pure returns (string memory) {

        string memory ret = new string(self._len + other._len);

        uint retptr;

        assembly { retptr := add(ret, 32) }

        memcpy(retptr, self._ptr, self._len);

        memcpy(retptr + self._len, other._ptr, other._len);

        return ret;

    }



    /*

     * @dev Joins an array of slices, using `self` as a delimiter, returning a

     *      newly allocated string.

     * @param self The delimiter to use.

     * @param parts A list of slices to join.

     * @return A newly allocated string containing all the slices in `parts`,

     *         joined with `self`.

     */

    function join(slice memory self, slice[] memory parts) internal pure returns (string memory) {

        if (parts.length == 0)

            return "";



        uint length = self._len * (parts.length - 1);

        for (uint i = 0; i < parts.length; i++) {

            length += parts[i]._len;

        }



        string memory ret = new string(length);

        uint retptr;

        assembly { retptr := add(ret, 32) }



        for (uint i = 0; i < parts.length; i++) {

            memcpy(retptr, parts[i]._ptr, parts[i]._len);

            retptr += parts[i]._len;

            if (i < parts.length - 1) {

                memcpy(retptr, self._ptr, self._len);

                retptr += self._len;

            }

        }



        return ret;

    }

}



// File: tokenWhitelist.sol



/**

 *  TokenWhitelist - The Consumer Contract Wallet

 *  Copyright (C) 2019 The Contract Wallet Company Limited

 *

 *  This program is free software: you can redistribute it and/or modify

 *  it under the terms of the GNU General Public License as published by

 *  the Free Software Foundation, either version 3 of the License, or

 *  (at your option) any later version.



 *  This program is distributed in the hope that it will be useful,

 *  but WITHOUT ANY WARRANTY; without even the implied warranty of

 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the

 *  GNU General Public License for more details.



 *  You should have received a copy of the GNU General Public License

 *  along with this program.  If not, see <https://www.gnu.org/licenses/>.

 */



pragma solidity ^0.5.10;













/// @title The ITokenWhitelist interface provides access to a whitelist of tokens.

interface ITokenWhitelist {

    function getTokenInfo(address) external view returns (string memory, uint256, uint256, bool, bool, bool, uint256);

    function getStablecoinInfo() external view returns (string memory, uint256, uint256, bool, bool, bool, uint256);

    function tokenAddressArray() external view returns (address[] memory);

    function redeemableTokens() external view returns (address[] memory);

    function methodIdWhitelist(bytes4) external view returns (bool);

    function getERC20RecipientAndAmount(address, bytes calldata) external view returns (address, uint);

    function stablecoin() external view returns (address);

    function updateTokenRate(address, uint, uint) external;

}





/// @title TokenWhitelist stores a list of tokens used by the Consumer Contract Wallet, the Oracle, the TKN Holder and the TKN Licence Contract

contract TokenWhitelist is ENSResolvable, Controllable, Transferrable {

    using strings for *;

    using SafeMath for uint256;

    using BytesUtils for bytes;



    event UpdatedTokenRate(address _sender, address _token, uint _rate);



    event UpdatedTokenLoadable(address _sender, address _token, bool _loadable);

    event UpdatedTokenRedeemable(address _sender, address _token, bool _redeemable);



    event AddedToken(address _sender, address _token, string _symbol, uint _magnitude, bool _loadable, bool _redeemable);

    event RemovedToken(address _sender, address _token);



    event AddedMethodId(bytes4 _methodId);

    event RemovedMethodId(bytes4 _methodId);

    event AddedExclusiveMethod(address _token, bytes4 _methodId);

    event RemovedExclusiveMethod(address _token, bytes4 _methodId);



    event Claimed(address _to, address _asset, uint _amount);



    /// @dev these are the methods whitelisted by default in executeTransaction() for protected tokens

    bytes4 private constant _APPROVE = 0x095ea7b3; // keccak256(approve(address,uint256)) => 0x095ea7b3

    bytes4 private constant _BURN = 0x42966c68; // keccak256(burn(uint256)) => 0x42966c68

    bytes4 private constant _TRANSFER= 0xa9059cbb; // keccak256(transfer(address,uint256)) => 0xa9059cbb

    bytes4 private constant _TRANSFER_FROM = 0x23b872dd; // keccak256(transferFrom(address,address,uint256)) => 0x23b872dd



    struct Token {

        string symbol;    // Token symbol

        uint magnitude;   // 10^decimals

        uint rate;        // Token exchange rate in wei

        bool available;   // Flags if the token is available or not

        bool loadable;    // Flags if token is loadable to the TokenCard

        bool redeemable;    // Flags if token is redeemable in the TKN Holder contract

        uint lastUpdate;  // Time of the last rate update

    }



    mapping(address => Token) private _tokenInfoMap;



    // @notice specifies whitelisted methodIds for protected tokens in wallet's excuteTranaction() e.g. keccak256(transfer(address,uint256)) => 0xa9059cbb

    mapping(bytes4 => bool) private _methodIdWhitelist;



    address[] private _tokenAddressArray;



    /// @notice keeping track of how many redeemable tokens are in the tokenWhitelist

    uint private _redeemableCounter;



    /// @notice Address of the stablecoin.

    address private _stablecoin;



    /// @notice is registered ENS node identifying the oracle contract.

    bytes32 private _oracleNode;



    /// @notice Constructor initializes ENSResolvable, and Controllable.

    /// @param _ens_ is the ENS registry address.

    /// @param _oracleNode_ is the ENS node of the Oracle.

    /// @param _controllerNode_ is our Controllers node.

    /// @param _stablecoinAddress_ is the address of the stablecoint used by the wallet for the card load limit.

    constructor(address _ens_, bytes32 _oracleNode_, bytes32 _controllerNode_, address _stablecoinAddress_) ENSResolvable(_ens_) Controllable(_controllerNode_) public {

        _oracleNode = _oracleNode_;

        _stablecoin = _stablecoinAddress_;

        //a priori ERC20 whitelisted methods

        _methodIdWhitelist[_APPROVE] = true;

        _methodIdWhitelist[_BURN] = true;

        _methodIdWhitelist[_TRANSFER] = true;

        _methodIdWhitelist[_TRANSFER_FROM] = true;

    }



    modifier onlyAdminOrOracle() {

        address oracleAddress = _ensResolve(_oracleNode);

        require (_isAdmin(msg.sender) || msg.sender == oracleAddress, "either oracle or admin");

        _;

    }



    /// @notice Add ERC20 tokens to the list of whitelisted tokens.

    /// @param _tokens ERC20 token contract addresses.

    /// @param _symbols ERC20 token names.

    /// @param _magnitude 10 to the power of number of decimal places used by each ERC20 token.

    /// @param _loadable is a bool that states whether or not a token is loadable to the TokenCard.

    /// @param _redeemable is a bool that states whether or not a token is redeemable in the TKN Holder Contract.

    /// @param _lastUpdate is a unit representing an ISO datetime e.g. 20180913153211.

    function addTokens(address[] calldata _tokens, bytes32[] calldata _symbols, uint[] calldata _magnitude, bool[] calldata _loadable, bool[] calldata _redeemable, uint _lastUpdate) external onlyAdmin {

        // Require that all parameters have the same length.

        require(_tokens.length == _symbols.length && _tokens.length == _magnitude.length && _tokens.length == _loadable.length && _tokens.length == _loadable.length, "parameter lengths do not match");

        // Add each token to the list of supported tokens.

        for (uint i = 0; i < _tokens.length; i++) {

            // Require that the token isn't already available.

            require(!_tokenInfoMap[_tokens[i]].available, "token already available");

            // Store the intermediate values.

            string memory symbol = _symbols[i].toSliceB32().toString();

            // Add the token to the token list.

            _tokenInfoMap[_tokens[i]] = Token({

                symbol : symbol,

                magnitude : _magnitude[i],

                rate : 0,

                available : true,

                loadable : _loadable[i],

                redeemable: _redeemable[i],

                lastUpdate : _lastUpdate

                });

            // Add the token address to the address list.

            _tokenAddressArray.push(_tokens[i]);

            //if the token is redeemable increase the redeemableCounter

            if (_redeemable[i]){

                _redeemableCounter = _redeemableCounter.add(1);

            }

            // Emit token addition event.

            emit AddedToken(msg.sender, _tokens[i], symbol, _magnitude[i], _loadable[i], _redeemable[i]);

        }

    }



    /// @notice Remove ERC20 tokens from the whitelist of tokens.

    /// @param _tokens ERC20 token contract addresses.

    function removeTokens(address[] calldata _tokens) external onlyAdmin {

        // Delete each token object from the list of supported tokens based on the addresses provided.

        for (uint i = 0; i < _tokens.length; i++) {

            // Store the token address.

            address token = _tokens[i];

            //token must be available, reverts on duplicates as well

            require(_tokenInfoMap[token].available, "token is not available");

            //if the token is redeemable decrease the redeemableCounter

            if (_tokenInfoMap[token].redeemable){

                _redeemableCounter = _redeemableCounter.sub(1);

            }

            // Delete the token object.

            delete _tokenInfoMap[token];

            // Remove the token address from the address list.

            for (uint j = 0; j < _tokenAddressArray.length.sub(1); j++) {

                if (_tokenAddressArray[j] == token) {

                    _tokenAddressArray[j] = _tokenAddressArray[_tokenAddressArray.length.sub(1)];

                    break;

                }

            }

            _tokenAddressArray.length--;

            // Emit token removal event.

            emit RemovedToken(msg.sender, token);

        }

    }



    /// @notice based on the method it returns the recipient address and amount/value, ERC20 specific.

    /// @param _data is the transaction payload.

    function getERC20RecipientAndAmount(address _token, bytes calldata _data) external view returns (address, uint) {

        // Require that there exist enough bytes for encoding at least a method signature + data in the transaction payload:

        // 4 (signature)  + 32(address or uint256)

        require(_data.length >= 4 + 32, "not enough method-encoding bytes");

        // Get the method signature

        bytes4 signature = _data._bytesToBytes4(0);

        // Check if method Id is supported

        require(isERC20MethodSupported(_token, signature), "unsupported method");

        // returns the recipient's address and amount is the value to be transferred

        if (signature == _BURN) {

            // 4 (signature) + 32(uint256)

            return (_token, _data._bytesToUint256(4));

        } else if (signature == _TRANSFER_FROM) {

            // 4 (signature) + 32(address) + 32(address) + 32(uint256)

            require(_data.length >= 4 + 32 + 32 + 32, "not enough data for transferFrom");

            return ( _data._bytesToAddress(4 + 32 + 12), _data._bytesToUint256(4 + 32 + 32));

        } else { //transfer or approve

            // 4 (signature) + 32(address) + 32(uint)

            require(_data.length >= 4 + 32 + 32, "not enough data for transfer/appprove");

            return (_data._bytesToAddress(4 + 12), _data._bytesToUint256(4 + 32));

        }

    }



    /// @notice Toggles whether or not a token is loadable or not.

    function setTokenLoadable(address _token, bool _loadable) external onlyAdmin {

        // Require that the token exists.

        require(_tokenInfoMap[_token].available, "token is not available");



        // this sets the loadable flag to the value passed in

        _tokenInfoMap[_token].loadable = _loadable;



        emit UpdatedTokenLoadable(msg.sender, _token, _loadable);

    }



    /// @notice Toggles whether or not a token is redeemable or not.

    function setTokenRedeemable(address _token, bool _redeemable) external onlyAdmin {

        // Require that the token exists.

        require(_tokenInfoMap[_token].available, "token is not available");



        // this sets the redeemable flag to the value passed in

        _tokenInfoMap[_token].redeemable = _redeemable;



        emit UpdatedTokenRedeemable(msg.sender, _token, _redeemable);

    }



    /// @notice Update ERC20 token exchange rate.

    /// @param _token ERC20 token contract address.

    /// @param _rate ERC20 token exchange rate in wei.

    /// @param _updateDate date for the token updates. This will be compared to when oracle updates are received.

    function updateTokenRate(address _token, uint _rate, uint _updateDate) external onlyAdminOrOracle {

        // Require that the token exists.

        require(_tokenInfoMap[_token].available, "token is not available");

        // Update the token's rate.

        _tokenInfoMap[_token].rate = _rate;

        // Update the token's last update timestamp.

        _tokenInfoMap[_token].lastUpdate = _updateDate;

        // Emit the rate update event.

        emit UpdatedTokenRate(msg.sender, _token, _rate);

    }



    //// @notice Withdraw tokens from the smart contract to the specified account.

    function claim(address payable _to, address _asset, uint _amount) external onlyAdmin {

        _safeTransfer(_to, _asset, _amount);

        emit Claimed(_to, _asset, _amount);

    }



    /// @notice This returns all of the fields for a given token.

    /// @param _a is the address of a given token.

    /// @return string of the token's symbol.

    /// @return uint of the token's magnitude.

    /// @return uint of the token's exchange rate to ETH.

    /// @return bool whether the token is available.

    /// @return bool whether the token is loadable to the TokenCard.

    /// @return bool whether the token is redeemable to the TKN Holder Contract.

    /// @return uint of the lastUpdated time of the token's exchange rate.

    function getTokenInfo(address _a) external view returns (string memory, uint256, uint256, bool, bool, bool, uint256) {

        Token storage tokenInfo = _tokenInfoMap[_a];

        return (tokenInfo.symbol, tokenInfo.magnitude, tokenInfo.rate, tokenInfo.available, tokenInfo.loadable, tokenInfo.redeemable, tokenInfo.lastUpdate);

    }



    /// @notice This returns all of the fields for our StableCoin.

    /// @return string of the token's symbol.

    /// @return uint of the token's magnitude.

    /// @return uint of the token's exchange rate to ETH.

    /// @return bool whether the token is available.

    /// @return bool whether the token is loadable to the TokenCard.

    /// @return bool whether the token is redeemable to the TKN Holder Contract.

    /// @return uint of the lastUpdated time of the token's exchange rate.

    function getStablecoinInfo() external view returns (string memory, uint256, uint256, bool, bool, bool, uint256) {

        Token storage stablecoinInfo = _tokenInfoMap[_stablecoin];

        return (stablecoinInfo.symbol, stablecoinInfo.magnitude, stablecoinInfo.rate, stablecoinInfo.available, stablecoinInfo.loadable, stablecoinInfo.redeemable, stablecoinInfo.lastUpdate);

    }



    /// @notice This returns an array of all whitelisted token addresses.

    /// @return address[] of whitelisted tokens.

    function tokenAddressArray() external view returns (address[] memory) {

        return _tokenAddressArray;

    }



    /// @notice This returns an array of all redeemable token addresses.

    /// @return address[] of redeemable tokens.

    function redeemableTokens() external view returns (address[] memory) {

        address[] memory redeemableAddresses = new address[](_redeemableCounter);

        uint redeemableIndex = 0;

        for (uint i = 0; i < _tokenAddressArray.length; i++) {

            address token = _tokenAddressArray[i];

            if (_tokenInfoMap[token].redeemable){

                redeemableAddresses[redeemableIndex] = token;

                redeemableIndex += 1;

            }

        }

        return redeemableAddresses;

    }





    /// @notice This returns true if a method Id is supported for the specific token.

    /// @return true if _methodId is supported in general or just for the specific token.

    function isERC20MethodSupported(address _token, bytes4 _methodId) public view returns (bool) {

        require(_tokenInfoMap[_token].available, "non-existing token");

        return (_methodIdWhitelist[_methodId]);

    }



    /// @notice This returns true if the method is supported for all protected tokens.

    /// @return true if _methodId is in the method whitelist.

    function isERC20MethodWhitelisted(bytes4 _methodId) external view returns (bool) {

        return (_methodIdWhitelist[_methodId]);

    }



    /// @notice This returns the number of redeemable tokens.

    /// @return current # of redeemables.

    function redeemableCounter() external view returns (uint) {

        return _redeemableCounter;

    }



    /// @notice This returns the address of our stablecoin of choice.

    /// @return the address of the stablecoin contract.

    function stablecoin() external view returns (address) {

        return _stablecoin;

    }



    /// @notice this returns the node hash of our Oracle.

    /// @return the oracle node registered in ENS.

    function oracleNode() external view returns (bytes32) {

        return _oracleNode;

    }

}



// File: tokenWhitelistable.sol



/**

 *  TokenWhitelistable - The Consumer Contract Wallet

 *  Copyright (C) 2019 The Contract Wallet Company Limited

 *

 *  This program is free software: you can redistribute it and/or modify

 *  it under the terms of the GNU General Public License as published by

 *  the Free Software Foundation, either version 3 of the License, or

 *  (at your option) any later version.



 *  This program is distributed in the hope that it will be useful,

 *  but WITHOUT ANY WARRANTY; without even the implied warranty of

 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the

 *  GNU General Public License for more details.



 *  You should have received a copy of the GNU General Public License

 *  along with this program.  If not, see <https://www.gnu.org/licenses/>.

 */



pragma solidity ^0.5.10;









/// @title TokenWhitelistable implements access to the TokenWhitelist located behind ENS.

contract TokenWhitelistable is ENSResolvable {



    /// @notice Is the registered ENS node identifying the tokenWhitelist contract

    bytes32 private _tokenWhitelistNode;



    /// @notice Constructor initializes the TokenWhitelistable object.

    /// @param _tokenWhitelistNode_ is the ENS node of the TokenWhitelist.

    constructor(bytes32 _tokenWhitelistNode_) internal {

        _tokenWhitelistNode = _tokenWhitelistNode_;

    }



    /// @notice This shows what TokenWhitelist is being used

    /// @return TokenWhitelist's node registered in ENS.

    function tokenWhitelistNode() external view returns (bytes32) {

        return _tokenWhitelistNode;

    }



    /// @notice This returns all of the fields for a given token.

    /// @param _a is the address of a given token.

    /// @return string of the token's symbol.

    /// @return uint of the token's magnitude.

    /// @return uint of the token's exchange rate to ETH.

    /// @return bool whether the token is available.

    /// @return bool whether the token is loadable to the TokenCard.

    /// @return bool whether the token is redeemable to the TKN Holder Contract.

    /// @return uint of the lastUpdated time of the token's exchange rate.

    function _getTokenInfo(address _a) internal view returns (string memory, uint256, uint256, bool, bool, bool, uint256) {

        return ITokenWhitelist(_ensResolve(_tokenWhitelistNode)).getTokenInfo(_a);

    }



    /// @notice This returns all of the fields for our stablecoin token.

    /// @return string of the token's symbol.

    /// @return uint of the token's magnitude.

    /// @return uint of the token's exchange rate to ETH.

    /// @return bool whether the token is available.

    /// @return bool whether the token is loadable to the TokenCard.

    /// @return bool whether the token is redeemable to the TKN Holder Contract.

    /// @return uint of the lastUpdated time of the token's exchange rate.

    function _getStablecoinInfo() internal view returns (string memory, uint256, uint256, bool, bool, bool, uint256) {

        return ITokenWhitelist(_ensResolve(_tokenWhitelistNode)).getStablecoinInfo();

    }



    /// @notice This returns an array of our whitelisted addresses.

    /// @return address[] of our whitelisted tokens.

    function _tokenAddressArray() internal view returns (address[] memory) {

        return ITokenWhitelist(_ensResolve(_tokenWhitelistNode)).tokenAddressArray();

    }



    /// @notice This returns an array of all redeemable token addresses.

    /// @return address[] of redeemable tokens.

    function _redeemableTokens() internal view returns (address[] memory) {

        return ITokenWhitelist(_ensResolve(_tokenWhitelistNode)).redeemableTokens();

    }



    /// @notice Update ERC20 token exchange rate.

    /// @param _token ERC20 token contract address.

    /// @param _rate ERC20 token exchange rate in wei.

    /// @param _updateDate date for the token updates. This will be compared to when oracle updates are received.

    function _updateTokenRate(address _token, uint _rate, uint _updateDate) internal {

        ITokenWhitelist(_ensResolve(_tokenWhitelistNode)).updateTokenRate(_token, _rate, _updateDate);

    }



    /// @notice based on the method it returns the recipient address and amount/value, ERC20 specific.

    /// @param _data is the transaction payload.

    function _getERC20RecipientAndAmount(address _destination, bytes memory _data) internal view returns (address, uint) {

        return ITokenWhitelist(_ensResolve(_tokenWhitelistNode)).getERC20RecipientAndAmount(_destination, _data);

    }



    /// @notice Checks whether a token is available.

    /// @return bool available or not.

    function _isTokenAvailable(address _a) internal view returns (bool) {

        ( , , , bool available, , , ) = _getTokenInfo(_a);

        return available;

    }



    /// @notice Checks whether a token is redeemable.

    /// @return bool redeemable or not.

    function _isTokenRedeemable(address _a) internal view returns (bool) {

        ( , , , , , bool redeemable, ) = _getTokenInfo(_a);

        return redeemable;

    }



    /// @notice Checks whether a token is loadable.

    /// @return bool loadable or not.

    function _isTokenLoadable(address _a) internal view returns (bool) {

        ( , , , , bool loadable, , ) = _getTokenInfo(_a);

        return loadable;

    }



    /// @notice This gets the address of the stablecoin.

    /// @return the address of the stablecoin contract.

    function _stablecoin() internal view returns (address) {

        return ITokenWhitelist(_ensResolve(_tokenWhitelistNode)).stablecoin();

    }



}



// File: holder.sol



/**

 *  Holder (aka Asset Contract) - The Consumer Contract Wallet

 *  Copyright (C) 2019 The Contract Wallet Company Limited

 *

 *  This program is free software: you can redistribute it and/or modify

 *  it under the terms of the GNU General Public License as published by

 *  the Free Software Foundation, either version 3 of the License, or

 *  (at your option) any later version.



 *  This program is distributed in the hope that it will be useful,

 *  but WITHOUT ANY WARRANTY; without even the implied warranty of

 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the

 *  GNU General Public License for more details.



 *  You should have received a copy of the GNU General Public License

 *  along with this program.  If not, see <https://www.gnu.org/licenses/>.

 */



pragma solidity ^0.5.10;



















/// @title Holder - The TKN Asset Contract

/// @notice When the TKN contract calls the burn method, a share of the tokens held by this contract are disbursed to the burner.

contract Holder is Balanceable, ENSResolvable, Controllable, Transferrable, TokenWhitelistable {



    using SafeMath for uint256;



    event Received(address _from, uint _amount);

    event CashAndBurned(address _to, address _asset, uint _amount);

    event Claimed(address _to, address _asset, uint _amount);



    /// @dev Check if the sender is the burner contract

    modifier onlyBurner() {

        require (msg.sender == _burner, "burner contract is not the sender");

        _;

    }



    // Burner token which can be burned to redeem shares.

    address private _burner;



    /// @notice Constructor initializes the holder contract.

    /// @param _burnerContract_ is the address of the token contract TKN with burning functionality.

    /// @param _ens_ is the address of the ENS registry.

    /// @param _tokenWhitelistNode_ is the ENS node of the Token whitelist.

    /// @param _controllerNode_ is the ENS node of the Controller

    constructor (address _burnerContract_, address _ens_, bytes32 _tokenWhitelistNode_, bytes32 _controllerNode_) ENSResolvable(_ens_) Controllable(_controllerNode_) TokenWhitelistable(_tokenWhitelistNode_) public {

        _burner = _burnerContract_;

    }



    /// @notice Ether may be sent from anywhere.

    function() external payable {

        emit Received(msg.sender, msg.value);

    }



    /// @notice Burn handles disbursing a share of tokens in this contract to a given address.

    /// @param _to The address to disburse to

    /// @param _amount The amount of TKN that will be burned if this succeeds

    function burn(address payable _to, uint _amount) external onlyBurner returns (bool) {

        if (_amount == 0) {

            return true;

        }

        // The burner token deducts from the supply before calling.

        uint supply = IBurner(_burner).currentSupply().add(_amount);

        address[] memory redeemableAddresses = _redeemableTokens();

        for (uint i = 0; i < redeemableAddresses.length; i++) {

            uint redeemableBalance = _balance(address(this), redeemableAddresses[i]);

            if (redeemableBalance > 0) {

                uint redeemableAmount = redeemableBalance.mul(_amount).div(supply);

                _safeTransfer(_to, redeemableAddresses[i], redeemableAmount);

                emit CashAndBurned(_to, redeemableAddresses[i], redeemableAmount);

            }

        }



        return true;

    }



    /// @notice This allows for the admin to reclaim the non-redeemableTokens

    /// @param _to this is the address which the reclaimed tokens will be sent to

    /// @param _nonRedeemableAddresses this is the array of tokens to be claimed

    function nonRedeemableTokenClaim(address payable _to, address[] calldata _nonRedeemableAddresses) external onlyAdmin returns (bool) {

        for (uint i = 0; i < _nonRedeemableAddresses.length; i++) {

            //revert if token is redeemable

            require(!_isTokenRedeemable(_nonRedeemableAddresses[i]), "redeemables cannot be claimed");

            uint claimBalance = _balance(address(this), _nonRedeemableAddresses[i]);

            if (claimBalance > 0) {

                _safeTransfer(_to, _nonRedeemableAddresses[i], claimBalance);

                emit Claimed(_to, _nonRedeemableAddresses[i], claimBalance);

            }

        }



        return true;

    }



    /// @notice Returned the address of the burner contract

    /// @return the TKN address

    function burner() external view returns (address) {

        return _burner;

    }



}

pragma solidity ^0.5.0;



/**

 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include

 * the optional functions; to access them see {ERC20Detailed}.

 */

interface IERC20 {

    /**

     * @dev Returns the amount of tokens in existence.

     */

    function totalSupply() external view returns (uint256);



    /**

     * @dev Returns the amount of tokens owned by `account`.

     */

    function balanceOf(address account) external view returns (uint256);



    /**

     * @dev Moves `amount` tokens from the caller's account to `recipient`.

     *

     * Returns a boolean value indicating whether the operation succeeded.

     *

     * Emits a {Transfer} event.

     */

    function transfer(address recipient, uint256 amount) external returns (bool);



    /**

     * @dev Returns the remaining number of tokens that `spender` will be

     * allowed to spend on behalf of `owner` through {transferFrom}. This is

     * zero by default.

     *

     * This value changes when {approve} or {transferFrom} are called.

     */

    function allowance(address owner, address spender) external view returns (uint256);



    /**

     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.

     *

     * Returns a boolean value indicating whether the operation succeeded.

     *

     * IMPORTANT: Beware that changing an allowance with this method brings the risk

     * that someone may use both the old and the new allowance by unfortunate

     * transaction ordering. One possible solution to mitigate this race

     * condition is to first reduce the spender's allowance to 0 and set the

     * desired value afterwards:

     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729

     *

     * Emits an {Approval} event.

     */

    function approve(address spender, uint256 amount) external returns (bool);



    /**

     * @dev Moves `amount` tokens from `sender` to `recipient` using the

     * allowance mechanism. `amount` is then deducted from the caller's

     * allowance.

     *

     * Returns a boolean value indicating whether the operation succeeded.

     *

     * Emits a {Transfer} event.

     */

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);



    /**

     * @dev Emitted when `value` tokens are moved from one account (`from`) to

     * another (`to`).

     *

     * Note that `value` may be zero.

     */

    event Transfer(address indexed from, address indexed to, uint256 value);



    /**

     * @dev Emitted when the allowance of a `spender` for an `owner` is set by

     * a call to {approve}. `value` is the new allowance.

     */

    event Approval(address indexed owner, address indexed spender, uint256 value);

}







library IndexedMerkleProof {

    function compute(bytes memory proof, uint160 leaf) internal pure returns (uint160 root, uint256 index) {

        uint160 computedHash = leaf;



        for (uint256 i = 0; i < proof.length / 20; i++) {

            uint160 proofElement;

            // solium-disable-next-line security/no-inline-assembly

            assembly {

                proofElement := div(mload(add(proof, add(32, mul(i, 20)))), 0x1000000000000000000000000)

            }



            if (computedHash < proofElement) {

                // Hash(current computed hash + current element of the proof)

                computedHash = uint160(uint256(keccak256(abi.encodePacked(computedHash, proofElement))));

                index += (1 << i);

            } else {

                // Hash(current element of the proof + current computed hash)

                computedHash = uint160(uint256(keccak256(abi.encodePacked(proofElement, computedHash))));

            }

        }



        return (computedHash, index);

    }

}





contract IRelayRecipient {



    /**

     * return the relayHub of this contract.

     */

    function getHubAddr() public view returns (address);



    /**

     * return the contract's balance on the RelayHub.

     * can be used to determine if the contract can pay for incoming calls,

     * before making any.

     */

    function getRecipientBalance() public view returns (uint);



    /*

     * Called by Relay (and RelayHub), to validate if this recipient accepts this call.

     * Note: Accepting this call means paying for the tx whether the relayed call reverted or not.

     *

     *  @return "0" if the the contract is willing to accept the charges from this sender, for this function call.

     *      any other value is a failure. actual value is for diagnostics only.

     *      ** Note: values below 10 are reserved by canRelay



     *  @param relay the relay that attempts to relay this function call.

     *          the contract may restrict some encoded functions to specific known relays.

     *  @param from the sender (signer) of this function call.

     *  @param encodedFunction the encoded function call (without any ethereum signature).

     *          the contract may check the method-id for valid methods

     *  @param gasPrice - the gas price for this transaction

     *  @param transactionFee - the relay compensation (in %) for this transaction

     *  @param signature - sender's signature over all parameters except approvalData

     *  @param approvalData - extra dapp-specific data (e.g. signature from trusted party)

     */

     function acceptRelayedCall(

        address relay,

        address from,

        bytes calldata encodedFunction,

        uint256 transactionFee,

        uint256 gasPrice,

        uint256 gasLimit,

        uint256 nonce,

        bytes calldata approvalData,

        uint256 maxPossibleCharge

    )

    external

    view

    returns (uint256, bytes memory);



    /*

     * modifier to be used by recipients as access control protection for preRelayedCall & postRelayedCall

     */

    modifier relayHubOnly() {

        require(msg.sender == getHubAddr(),"Function can only be called by RelayHub");

        _;

    }



    /** this method is called before the actual relayed function call.

     * It may be used to charge the caller before (in conjuction with refunding him later in postRelayedCall for example).

     * the method is given all parameters of acceptRelayedCall and actual used gas.

     *

     *

     *** NOTICE: if this method modifies the contract's state, it must be protected with access control i.e. require msg.sender == getHubAddr()

     *

     *

     * Revert in this functions causes a revert of the client's relayed call but not in the entire transaction

     * (that is, the relay will still get compensated)

     */

    function preRelayedCall(bytes calldata context) external returns (bytes32);



    /** this method is called after the actual relayed function call.

     * It may be used to record the transaction (e.g. charge the caller by some contract logic) for this call.

     * the method is given all parameters of acceptRelayedCall, and also the success/failure status and actual used gas.

     *

     *

     *** NOTICE: if this method modifies the contract's state, it must be protected with access control i.e. require msg.sender == getHubAddr()

     *

     *

     * @param success - true if the relayed call succeeded, false if it reverted

     * @param actualCharge - estimation of how much the recipient will be charged. This information may be used to perform local booking and

     *   charge the sender for this call (e.g. in tokens).

     * @param preRetVal - preRelayedCall() return value passed back to the recipient

     *

     * Revert in this functions causes a revert of the client's relayed call but not in the entire transaction

     * (that is, the relay will still get compensated)

     */

    function postRelayedCall(bytes calldata context, bool success, uint actualCharge, bytes32 preRetVal) external;



}





contract IRelayHub {

    // Relay management



    // Add stake to a relay and sets its unstakeDelay.

    // If the relay does not exist, it is created, and the caller

    // of this function becomes its owner. If the relay already exists, only the owner can call this function. A relay

    // cannot be its own owner.

    // All Ether in this function call will be added to the relay's stake.

    // Its unstake delay will be assigned to unstakeDelay, but the new value must be greater or equal to the current one.

    // Emits a Staked event.

    function stake(address relayaddr, uint256 unstakeDelay) external payable;



    // Emited when a relay's stake or unstakeDelay are increased

    event Staked(address indexed relay, uint256 stake, uint256 unstakeDelay);



    // Registers the caller as a relay.

    // The relay must be staked for, and not be a contract (i.e. this function must be called directly from an EOA).

    // Emits a RelayAdded event.

    // This function can be called multiple times, emitting new RelayAdded events. Note that the received transactionFee

    // is not enforced by relayCall.

    function registerRelay(uint256 transactionFee, string memory url) public;



    // Emitted when a relay is registered or re-registerd. Looking at these events (and filtering out RelayRemoved

    // events) lets a client discover the list of available relays.

    event RelayAdded(address indexed relay, address indexed owner, uint256 transactionFee, uint256 stake, uint256 unstakeDelay, string url);



    // Removes (deregisters) a relay. Unregistered (but staked for) relays can also be removed. Can only be called by

    // the owner of the relay. After the relay's unstakeDelay has elapsed, unstake will be callable.

    // Emits a RelayRemoved event.

    function removeRelayByOwner(address relay) public;



    // Emitted when a relay is removed (deregistered). unstakeTime is the time when unstake will be callable.

    event RelayRemoved(address indexed relay, uint256 unstakeTime);



    // Deletes the relay from the system, and gives back its stake to the owner. Can only be called by the relay owner,

    // after unstakeDelay has elapsed since removeRelayByOwner was called.

    // Emits an Unstaked event.

    function unstake(address relay) public;



    // Emitted when a relay is unstaked for, including the returned stake.

    event Unstaked(address indexed relay, uint256 stake);



    // States a relay can be in

    enum RelayState {

        Unknown, // The relay is unknown to the system: it has never been staked for

        Staked, // The relay has been staked for, but it is not yet active

        Registered, // The relay has registered itself, and is active (can relay calls)

        Removed    // The relay has been removed by its owner and can no longer relay calls. It must wait for its unstakeDelay to elapse before it can unstake

    }



    // Returns a relay's status. Note that relays can be deleted when unstaked or penalized.

    function getRelay(address relay) external view returns (uint256 totalStake, uint256 unstakeDelay, uint256 unstakeTime, address payable owner, RelayState state);



    // Balance management



    // Deposits ether for a contract, so that it can receive (and pay for) relayed transactions. Unused balance can only

    // be withdrawn by the contract itself, by callingn withdraw.

    // Emits a Deposited event.

    function depositFor(address target) public payable;



    // Emitted when depositFor is called, including the amount and account that was funded.

    event Deposited(address indexed recipient, address indexed from, uint256 amount);



    // Returns an account's deposits. These can be either a contnract's funds, or a relay owner's revenue.

    function balanceOf(address target) external view returns (uint256);



    // Withdraws from an account's balance, sending it back to it. Relay owners call this to retrieve their revenue, and

    // contracts can also use it to reduce their funding.

    // Emits a Withdrawn event.

    function withdraw(uint256 amount, address payable dest) public;



    // Emitted when an account withdraws funds from RelayHub.

    event Withdrawn(address indexed account, address indexed dest, uint256 amount);



    // Relaying



    // Check if the RelayHub will accept a relayed operation. Multiple things must be true for this to happen:

    //  - all arguments must be signed for by the sender (from)

    //  - the sender's nonce must be the current one

    //  - the recipient must accept this transaction (via acceptRelayedCall)

    // Returns a PreconditionCheck value (OK when the transaction can be relayed), or a recipient-specific error code if

    // it returns one in acceptRelayedCall.

    function canRelay(

        address relay,

        address from,

        address to,

        bytes memory encodedFunction,

        uint256 transactionFee,

        uint256 gasPrice,

        uint256 gasLimit,

        uint256 nonce,

        bytes memory signature,

        bytes memory approvalData

    ) public view returns (uint256 status, bytes memory recipientContext);



    // Preconditions for relaying, checked by canRelay and returned as the corresponding numeric values.

    enum PreconditionCheck {

        OK,                         // All checks passed, the call can be relayed

        WrongSignature,             // The transaction to relay is not signed by requested sender

        WrongNonce,                 // The provided nonce has already been used by the sender

        AcceptRelayedCallReverted,  // The recipient rejected this call via acceptRelayedCall

        InvalidRecipientStatusCode  // The recipient returned an invalid (reserved) status code

    }



    // Relays a transaction. For this to suceed, multiple conditions must be met:

    //  - canRelay must return PreconditionCheck.OK

    //  - the sender must be a registered relay

    //  - the transaction's gas price must be larger or equal to the one that was requested by the sender

    //  - the transaction must have enough gas to not run out of gas if all internal transactions (calls to the

    // recipient) use all gas available to them

    //  - the recipient must have enough balance to pay the relay for the worst-case scenario (i.e. when all gas is

    // spent)

    //

    // If all conditions are met, the call will be relayed and the recipient charged. preRelayedCall, the encoded

    // function and postRelayedCall will be called in order.

    //

    // Arguments:

    //  - from: the client originating the request

    //  - recipient: the target IRelayRecipient contract

    //  - encodedFunction: the function call to relay, including data

    //  - transactionFee: fee (%) the relay takes over actual gas cost

    //  - gasPrice: gas price the client is willing to pay

    //  - gasLimit: gas to forward when calling the encoded function

    //  - nonce: client's nonce

    //  - signature: client's signature over all previous params, plus the relay and RelayHub addresses

    //  - approvalData: dapp-specific data forwared to acceptRelayedCall. This value is *not* verified by the Hub, but

    //    it still can be used for e.g. a signature.

    //

    // Emits a TransactionRelayed event.

    function relayCall(

        address from,

        address to,

        bytes memory encodedFunction,

        uint256 transactionFee,

        uint256 gasPrice,

        uint256 gasLimit,

        uint256 nonce,

        bytes memory signature,

        bytes memory approvalData

    ) public;



    // Emitted when an attempt to relay a call failed. This can happen due to incorrect relayCall arguments, or the

    // recipient not accepting the relayed call. The actual relayed call was not executed, and the recipient not charged.

    // The reason field contains an error code: values 1-10 correspond to PreconditionCheck entries, and values over 10

    // are custom recipient error codes returned from acceptRelayedCall.

    event CanRelayFailed(address indexed relay, address indexed from, address indexed to, bytes4 selector, uint256 reason);



    // Emitted when a transaction is relayed. Note that the actual encoded function might be reverted: this will be

    // indicated in the status field.

    // Useful when monitoring a relay's operation and relayed calls to a contract.

    // Charge is the ether value deducted from the recipient's balance, paid to the relay's owner.

    event TransactionRelayed(address indexed relay, address indexed from, address indexed to, bytes4 selector, RelayCallStatus status, uint256 charge);



    // Reason error codes for the TransactionRelayed event

    enum RelayCallStatus {

        OK,                      // The transaction was successfully relayed and execution successful - never included in the event

        RelayedCallFailed,       // The transaction was relayed, but the relayed call failed

        PreRelayedFailed,        // The transaction was not relayed due to preRelatedCall reverting

        PostRelayedFailed,       // The transaction was relayed and reverted due to postRelatedCall reverting

        RecipientBalanceChanged  // The transaction was relayed and reverted due to the recipient's balance changing

    }



    // Returns how much gas should be forwarded to a call to relayCall, in order to relay a transaction that will spend

    // up to relayedCallStipend gas.

    function requiredGas(uint256 relayedCallStipend) public view returns (uint256);



    // Returns the maximum recipient charge, given the amount of gas forwarded, gas price and relay fee.

    function maxPossibleCharge(uint256 relayedCallStipend, uint256 gasPrice, uint256 transactionFee) public view returns (uint256);



    // Relay penalization. Any account can penalize relays, removing them from the system immediately, and rewarding the

    // reporter with half of the relay's stake. The other half is burned so that, even if the relay penalizes itself, it

    // still loses half of its stake.



    // Penalize a relay that signed two transactions using the same nonce (making only the first one valid) and

    // different data (gas price, gas limit, etc. may be different). The (unsigned) transaction data and signature for

    // both transactions must be provided.

    function penalizeRepeatedNonce(bytes memory unsignedTx1, bytes memory signature1, bytes memory unsignedTx2, bytes memory signature2) public;



    // Penalize a relay that sent a transaction that didn't target RelayHub's registerRelay or relayCall.

    function penalizeIllegalTransaction(bytes memory unsignedTx, bytes memory signature) public;



    event Penalized(address indexed relay, address sender, uint256 amount);



    function getNonce(address from) view external returns (uint256);

}



/*



  Copyright 2018 ZeroEx Intl.



  Licensed under the Apache License, Version 2.0 (the "License");

  you may not use this file except in compliance with the License.

  You may obtain a copy of the License at



    http://www.apache.org/licenses/LICENSE-2.0



  Unless required by applicable law or agreed to in writing, software

  distributed under the License is distributed on an "AS IS" BASIS,

  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

  See the License for the specific language governing permissions and

  limitations under the License.



*/



pragma solidity ^0.5.5;





library LibBytes {



    using LibBytes for bytes;



    /// @dev Gets the memory address for a byte array.

    /// @param input Byte array to lookup.

    /// @return memoryAddress Memory address of byte array. This

    ///         points to the header of the byte array which contains

    ///         the length.

    function rawAddress(bytes memory input)

        internal

        pure

        returns (uint256 memoryAddress)

    {

        assembly {

            memoryAddress := input

        }

        return memoryAddress;

    }

    

    /// @dev Gets the memory address for the contents of a byte array.

    /// @param input Byte array to lookup.

    /// @return memoryAddress Memory address of the contents of the byte array.

    function contentAddress(bytes memory input)

        internal

        pure

        returns (uint256 memoryAddress)

    {

        assembly {

            memoryAddress := add(input, 32)

        }

        return memoryAddress;

    }



    /// @dev Copies `length` bytes from memory location `source` to `dest`.

    /// @param dest memory address to copy bytes to.

    /// @param source memory address to copy bytes from.

    /// @param length number of bytes to copy.

    function memCopy(

        uint256 dest,

        uint256 source,

        uint256 length

    )

        internal

        pure

    {

        if (length < 32) {

            // Handle a partial word by reading destination and masking

            // off the bits we are interested in.

            // This correctly handles overlap, zero lengths and source == dest

            assembly {

                let mask := sub(exp(256, sub(32, length)), 1)

                let s := and(mload(source), not(mask))

                let d := and(mload(dest), mask)

                mstore(dest, or(s, d))

            }

        } else {

            // Skip the O(length) loop when source == dest.

            if (source == dest) {

                return;

            }



            // For large copies we copy whole words at a time. The final

            // word is aligned to the end of the range (instead of after the

            // previous) to handle partial words. So a copy will look like this:

            //

            //  ####

            //      ####

            //          ####

            //            ####

            //

            // We handle overlap in the source and destination range by

            // changing the copying direction. This prevents us from

            // overwriting parts of source that we still need to copy.

            //

            // This correctly handles source == dest

            //

            if (source > dest) {

                assembly {

                    // We subtract 32 from `sEnd` and `dEnd` because it

                    // is easier to compare with in the loop, and these

                    // are also the addresses we need for copying the

                    // last bytes.

                    length := sub(length, 32)

                    let sEnd := add(source, length)

                    let dEnd := add(dest, length)



                    // Remember the last 32 bytes of source

                    // This needs to be done here and not after the loop

                    // because we may have overwritten the last bytes in

                    // source already due to overlap.

                    let last := mload(sEnd)



                    // Copy whole words front to back

                    // Note: the first check is always true,

                    // this could have been a do-while loop.

                    // solhint-disable-next-line no-empty-blocks

                    for {} lt(source, sEnd) {} {

                        mstore(dest, mload(source))

                        source := add(source, 32)

                        dest := add(dest, 32)

                    }

                    

                    // Write the last 32 bytes

                    mstore(dEnd, last)

                }

            } else {

                assembly {

                    // We subtract 32 from `sEnd` and `dEnd` because those

                    // are the starting points when copying a word at the end.

                    length := sub(length, 32)

                    let sEnd := add(source, length)

                    let dEnd := add(dest, length)



                    // Remember the first 32 bytes of source

                    // This needs to be done here and not after the loop

                    // because we may have overwritten the first bytes in

                    // source already due to overlap.

                    let first := mload(source)



                    // Copy whole words back to front

                    // We use a signed comparisson here to allow dEnd to become

                    // negative (happens when source and dest < 32). Valid

                    // addresses in local memory will never be larger than

                    // 2**255, so they can be safely re-interpreted as signed.

                    // Note: the first check is always true,

                    // this could have been a do-while loop.

                    // solhint-disable-next-line no-empty-blocks

                    for {} slt(dest, dEnd) {} {

                        mstore(dEnd, mload(sEnd))

                        sEnd := sub(sEnd, 32)

                        dEnd := sub(dEnd, 32)

                    }

                    

                    // Write the first 32 bytes

                    mstore(dest, first)

                }

            }

        }

    }



    /// @dev Returns a slices from a byte array.

    /// @param b The byte array to take a slice from.

    /// @param from The starting index for the slice (inclusive).

    /// @param to The final index for the slice (exclusive).

    /// @return result The slice containing bytes at indices [from, to)

    function slice(

        bytes memory b,

        uint256 from,

        uint256 to

    )

        internal

        pure

        returns (bytes memory result)

    {

        require(

            from <= to,

            "FROM_LESS_THAN_TO_REQUIRED"

        );

        require(

            to <= b.length,

            "TO_LESS_THAN_LENGTH_REQUIRED"

        );

        

        // Create a new bytes structure and copy contents

        result = new bytes(to - from);

        memCopy(

            result.contentAddress(),

            b.contentAddress() + from,

            result.length

        );

        return result;

    }

    

    /// @dev Returns a slice from a byte array without preserving the input.

    /// @param b The byte array to take a slice from. Will be destroyed in the process.

    /// @param from The starting index for the slice (inclusive).

    /// @param to The final index for the slice (exclusive).

    /// @return result The slice containing bytes at indices [from, to)

    /// @dev When `from == 0`, the original array will match the slice. In other cases its state will be corrupted.

    function sliceDestructive(

        bytes memory b,

        uint256 from,

        uint256 to

    )

        internal

        pure

        returns (bytes memory result)

    {

        require(

            from <= to,

            "FROM_LESS_THAN_TO_REQUIRED"

        );

        require(

            to <= b.length,

            "TO_LESS_THAN_LENGTH_REQUIRED"

        );

        

        // Create a new bytes structure around [from, to) in-place.

        assembly {

            result := add(b, from)

            mstore(result, sub(to, from))

        }

        return result;

    }



    /// @dev Pops the last byte off of a byte array by modifying its length.

    /// @param b Byte array that will be modified.

    /// @return The byte that was popped off.

    function popLastByte(bytes memory b)

        internal

        pure

        returns (bytes1 result)

    {

        require(

            b.length > 0,

            "GREATER_THAN_ZERO_LENGTH_REQUIRED"

        );



        // Store last byte.

        result = b[b.length - 1];



        assembly {

            // Decrement length of byte array.

            let newLen := sub(mload(b), 1)

            mstore(b, newLen)

        }

        return result;

    }



    /// @dev Pops the last 20 bytes off of a byte array by modifying its length.

    /// @param b Byte array that will be modified.

    /// @return The 20 byte address that was popped off.

    function popLast20Bytes(bytes memory b)

        internal

        pure

        returns (address result)

    {

        require(

            b.length >= 20,

            "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"

        );



        // Store last 20 bytes.

        result = readAddress(b, b.length - 20);



        assembly {

            // Subtract 20 from byte array length.

            let newLen := sub(mload(b), 20)

            mstore(b, newLen)

        }

        return result;

    }



    /// @dev Tests equality of two byte arrays.

    /// @param lhs First byte array to compare.

    /// @param rhs Second byte array to compare.

    /// @return True if arrays are the same. False otherwise.

    function equals(

        bytes memory lhs,

        bytes memory rhs

    )

        internal

        pure

        returns (bool equal)

    {

        // Keccak gas cost is 30 + numWords * 6. This is a cheap way to compare.

        // We early exit on unequal lengths, but keccak would also correctly

        // handle this.

        return lhs.length == rhs.length && keccak256(lhs) == keccak256(rhs);

    }



    /// @dev Reads an address from a position in a byte array.

    /// @param b Byte array containing an address.

    /// @param index Index in byte array of address.

    /// @return address from byte array.

    function readAddress(

        bytes memory b,

        uint256 index

    )

        internal

        pure

        returns (address result)

    {

        require(

            b.length >= index + 20,  // 20 is length of address

            "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"

        );



        // Add offset to index:

        // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)

        // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)

        index += 20;



        // Read address from array memory

        assembly {

            // 1. Add index to address of bytes array

            // 2. Load 32-byte word from memory

            // 3. Apply 20-byte mask to obtain address

            result := and(mload(add(b, index)), 0xffffffffffffffffffffffffffffffffffffffff)

        }

        return result;

    }



    /// @dev Writes an address into a specific position in a byte array.

    /// @param b Byte array to insert address into.

    /// @param index Index in byte array of address.

    /// @param input Address to put into byte array.

    function writeAddress(

        bytes memory b,

        uint256 index,

        address input

    )

        internal

        pure

    {

        require(

            b.length >= index + 20,  // 20 is length of address

            "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"

        );



        // Add offset to index:

        // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)

        // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)

        index += 20;



        // Store address into array memory

        assembly {

            // The address occupies 20 bytes and mstore stores 32 bytes.

            // First fetch the 32-byte word where we'll be storing the address, then

            // apply a mask so we have only the bytes in the word that the address will not occupy.

            // Then combine these bytes with the address and store the 32 bytes back to memory with mstore.



            // 1. Add index to address of bytes array

            // 2. Load 32-byte word from memory

            // 3. Apply 12-byte mask to obtain extra bytes occupying word of memory where we'll store the address

            let neighbors := and(

                mload(add(b, index)),

                0xffffffffffffffffffffffff0000000000000000000000000000000000000000

            )

            

            // Make sure input address is clean.

            // (Solidity does not guarantee this)

            input := and(input, 0xffffffffffffffffffffffffffffffffffffffff)



            // Store the neighbors and address into memory

            mstore(add(b, index), xor(input, neighbors))

        }

    }



    /// @dev Reads a bytes32 value from a position in a byte array.

    /// @param b Byte array containing a bytes32 value.

    /// @param index Index in byte array of bytes32 value.

    /// @return bytes32 value from byte array.

    function readBytes32(

        bytes memory b,

        uint256 index

    )

        internal

        pure

        returns (bytes32 result)

    {

        require(

            b.length >= index + 32,

            "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED"

        );



        // Arrays are prefixed by a 256 bit length parameter

        index += 32;



        // Read the bytes32 from array memory

        assembly {

            result := mload(add(b, index))

        }

        return result;

    }



    /// @dev Writes a bytes32 into a specific position in a byte array.

    /// @param b Byte array to insert <input> into.

    /// @param index Index in byte array of <input>.

    /// @param input bytes32 to put into byte array.

    function writeBytes32(

        bytes memory b,

        uint256 index,

        bytes32 input

    )

        internal

        pure

    {

        require(

            b.length >= index + 32,

            "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED"

        );



        // Arrays are prefixed by a 256 bit length parameter

        index += 32;



        // Read the bytes32 from array memory

        assembly {

            mstore(add(b, index), input)

        }

    }



    /// @dev Reads a uint256 value from a position in a byte array.

    /// @param b Byte array containing a uint256 value.

    /// @param index Index in byte array of uint256 value.

    /// @return uint256 value from byte array.

    function readUint256(

        bytes memory b,

        uint256 index

    )

        internal

        pure

        returns (uint256 result)

    {

        result = uint256(readBytes32(b, index));

        return result;

    }



    /// @dev Writes a uint256 into a specific position in a byte array.

    /// @param b Byte array to insert <input> into.

    /// @param index Index in byte array of <input>.

    /// @param input uint256 to put into byte array.

    function writeUint256(

        bytes memory b,

        uint256 index,

        uint256 input

    )

        internal

        pure

    {

        writeBytes32(b, index, bytes32(input));

    }



    /// @dev Reads an unpadded bytes4 value from a position in a byte array.

    /// @param b Byte array containing a bytes4 value.

    /// @param index Index in byte array of bytes4 value.

    /// @return bytes4 value from byte array.

    function readBytes4(

        bytes memory b,

        uint256 index

    )

        internal

        pure

        returns (bytes4 result)

    {

        require(

            b.length >= index + 4,

            "GREATER_OR_EQUAL_TO_4_LENGTH_REQUIRED"

        );



        // Arrays are prefixed by a 32 byte length field

        index += 32;



        // Read the bytes4 from array memory

        assembly {

            result := mload(add(b, index))

            // Solidity does not require us to clean the trailing bytes.

            // We do it anyway

            result := and(result, 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000)

        }

        return result;

    }



    /// @dev Reads nested bytes from a specific position.

    /// @dev NOTE: the returned value overlaps with the input value.

    ///            Both should be treated as immutable.

    /// @param b Byte array containing nested bytes.

    /// @param index Index of nested bytes.

    /// @return result Nested bytes.

    function readBytesWithLength(

        bytes memory b,

        uint256 index

    )

        internal

        pure

        returns (bytes memory result)

    {

        // Read length of nested bytes

        uint256 nestedBytesLength = readUint256(b, index);

        index += 32;



        // Assert length of <b> is valid, given

        // length of nested bytes

        require(

            b.length >= index + nestedBytesLength,

            "GREATER_OR_EQUAL_TO_NESTED_BYTES_LENGTH_REQUIRED"

        );

        

        // Return a pointer to the byte array as it exists inside `b`

        assembly {

            result := add(b, index)

        }

        return result;

    }



    /// @dev Inserts bytes at a specific position in a byte array.

    /// @param b Byte array to insert <input> into.

    /// @param index Index in byte array of <input>.

    /// @param input bytes to insert.

    function writeBytesWithLength(

        bytes memory b,

        uint256 index,

        bytes memory input

    )

        internal

        pure

    {

        // Assert length of <b> is valid, given

        // length of input

        require(

            b.length >= index + 32 + input.length,  // 32 bytes to store length

            "GREATER_OR_EQUAL_TO_NESTED_BYTES_LENGTH_REQUIRED"

        );



        // Copy <input> into <b>

        memCopy(

            b.contentAddress() + index,

            input.rawAddress(), // includes length of <input>

            input.length + 32   // +32 bytes to store <input> length

        );

    }



    /// @dev Performs a deep copy of a byte array onto another byte array of greater than or equal length.

    /// @param dest Byte array that will be overwritten with source bytes.

    /// @param source Byte array to copy onto dest bytes.

    function deepCopyBytes(

        bytes memory dest,

        bytes memory source

    )

        internal

        pure

    {

        uint256 sourceLen = source.length;

        // Dest length must be >= source length, or some bytes would not be copied.

        require(

            dest.length >= sourceLen,

            "GREATER_OR_EQUAL_TO_SOURCE_BYTES_LENGTH_REQUIRED"

        );

        memCopy(

            dest.contentAddress(),

            source.contentAddress(),

            sourceLen

        );

    }

}





/*

 * @dev Provides information about the current execution context, including the

 * sender of the transaction and its data. While these are generally available

 * via msg.sender and msg.data, they not should not be accessed in such a direct

 * manner, since when dealing with GSN meta-transactions the account sending and

 * paying for execution may not be the actual sender (as far as an application

 * is concerned).

 *

 * This contract is only required for intermediate, library-like contracts.

 */

contract Context {

    // Empty internal constructor, to prevent people from mistakenly deploying

    // an instance of this contract, with should be used via inheritance.

    constructor () internal { }

    // solhint-disable-previous-line no-empty-blocks



    function _msgSender() internal view returns (address) {

        return msg.sender;

    }



    function _msgData() internal view returns (bytes memory) {

        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691

        return msg.data;

    }

}





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

        return sub(a, b, "SafeMath: subtraction overflow");

    }



    /**

     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on

     * overflow (when the result is negative).

     *

     * Counterpart to Solidity's `-` operator.

     *

     * Requirements:

     * - Subtraction cannot overflow.

     *

     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.

     * @dev Get it via `npm install @openzeppelin/contracts@next`.

     */

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b <= a, errorMessage);

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

        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522

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

        return div(a, b, "SafeMath: division by zero");

    }



    /**

     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on

     * division by zero. The result is rounded towards zero.

     *

     * Counterpart to Solidity's `/` operator. Note: this function uses a

     * `revert` opcode (which leaves remaining gas untouched) while Solidity

     * uses an invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     * - The divisor cannot be zero.



     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.

     * @dev Get it via `npm install @openzeppelin/contracts@next`.

     */

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        // Solidity only automatically asserts when dividing by 0

        require(b > 0, errorMessage);

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

        return mod(a, b, "SafeMath: modulo by zero");

    }



    /**

     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),

     * Reverts with custom message when dividing by zero.

     *

     * Counterpart to Solidity's `%` operator. This function uses a `revert`

     * opcode (which leaves remaining gas untouched) while Solidity uses an

     * invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     * - The divisor cannot be zero.

     *

     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.

     * @dev Get it via `npm install @openzeppelin/contracts@next`.

     */

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b != 0, errorMessage);

        return a % b;

    }

}





/**

 * @dev Collection of functions related to the address type

 */

library Address {

    /**

     * @dev Returns true if `account` is a contract.

     *

     * This test is non-exhaustive, and there may be false-negatives: during the

     * execution of a contract's constructor, its address will be reported as

     * not containing a contract.

     *

     * IMPORTANT: It is unsafe to assume that an address for which this

     * function returns false is an externally-owned account (EOA) and not a

     * contract.

     */

    function isContract(address account) internal view returns (bool) {

        // This method relies in extcodesize, which returns 0 for contracts in

        // construction, since the code is only stored at the end of the

        // constructor execution.

        

        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts

        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned

        // for accounts without code, i.e. `keccak256('')`

        bytes32 codehash;

        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;

        // solhint-disable-next-line no-inline-assembly

        assembly { codehash := extcodehash(account) }

        return (codehash != 0x0 && codehash != accountHash);

    }



    /**

     * @dev Converts an `address` into `address payable`. Note that this is

     * simply a type cast: the actual underlying value is not changed.

     *

     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.

     * @dev Get it via `npm install @openzeppelin/contracts@next`.

     */

    function toPayable(address account) internal pure returns (address payable) {

        return address(uint160(account));

    }

}





// Contract that implements the relay recipient protocol.  Inherited by Gatekeeper, or any other relay recipient.

//

// The recipient contract is responsible to:

// * pass a trusted IRelayHub singleton to the constructor.

// * Implement acceptRelayedCall, which acts as a whitelist/blacklist of senders.  It is advised that the recipient's owner will be able to update that list to remove abusers.

// * In every function that cares about the sender, use "address sender = getSender()" instead of msg.sender.  It'll return msg.sender for non-relayed transactions, or the real sender in case of relayed transactions.









contract RelayRecipient is IRelayRecipient {



    IRelayHub private relayHub; // The IRelayHub singleton which is allowed to call us



    function getHubAddr() public view returns (address) {

        return address(relayHub);

    }



    /**

     * Initialize the RelayHub of this contract.

     * Must be called at least once (e.g. from the constructor), so that the contract can accept relayed calls.

     * For ownable contracts, there should be a method to update the RelayHub, in case a new hub is deployed (since

     * the RelayHub itself is not upgradeable)

     * Otherwise, the contract might be locked on a dead hub, with no relays.

     */

    function setRelayHub(IRelayHub _rhub) internal {

        relayHub = _rhub;



        //attempt a read method, just to validate the relay is a valid RelayHub contract.

        getRecipientBalance();

    }



    function getRelayHub() internal view returns (IRelayHub) {

        return relayHub;

    }



    /**

     * return the balance of this contract.

     * Note that this method will revert on configuration error (invalid relay address)

     */

    function getRecipientBalance() public view returns (uint) {

        return getRelayHub().balanceOf(address(this));

    }



    function getSenderFromData(address origSender, bytes memory msgData) public view returns (address) {

        address sender = origSender;

        if (origSender == getHubAddr()) {

            // At this point we know that the sender is a trusted IRelayHub, so we trust that the last bytes of msg.data are the verified sender address.

            // extract sender address from the end of msg.data

            sender = LibBytes.readAddress(msgData, msgData.length - 20);

        }

        return sender;

    }



    /**

     * return the sender of this call.

     * if the call came through the valid RelayHub, return the original sender.

     * otherwise, return `msg.sender`

     * should be used in the contract anywhere instead of msg.sender

     */

    function getSender() public view returns (address) {

        return getSenderFromData(msg.sender, msg.data);

    }



    function getMessageData() public view returns (bytes memory) {

        bytes memory origMsgData = msg.data;

        if (msg.sender == getHubAddr()) {

            // At this point we know that the sender is a trusted IRelayHub, so we trust that the last bytes of msg.data are the verified sender address.

            // extract original message data from the start of msg.data

            origMsgData = new bytes(msg.data.length - 20);

            for (uint256 i = 0; i < origMsgData.length; i++)

            {

                origMsgData[i] = msg.data[i];

            }

        }

        return origMsgData;

    }

}





/**

 * @dev Contract module which provides a basic access control mechanism, where

 * there is an account (an owner) that can be granted exclusive access to

 * specific functions.

 *

 * This module is used through inheritance. It will make available the modifier

 * `onlyOwner`, which can be applied to your functions to restrict their use to

 * the owner.

 */

contract Ownable is Context {

    address private _owner;



    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);



    /**

     * @dev Initializes the contract setting the deployer as the initial owner.

     */

    constructor () internal {

        _owner = _msgSender();

        emit OwnershipTransferred(address(0), _owner);

    }



    /**

     * @dev Returns the address of the current owner.

     */

    function owner() public view returns (address) {

        return _owner;

    }



    /**

     * @dev Throws if called by any account other than the owner.

     */

    modifier onlyOwner() {

        require(isOwner(), "Ownable: caller is not the owner");

        _;

    }



    /**

     * @dev Returns true if the caller is the current owner.

     */

    function isOwner() public view returns (bool) {

        return _msgSender() == _owner;

    }



    /**

     * @dev Leaves the contract without owner. It will not be possible to call

     * `onlyOwner` functions anymore. Can only be called by the current owner.

     *

     * NOTE: Renouncing ownership will leave the contract without an owner,

     * thereby removing any functionality that is only available to the owner.

     */

    function renounceOwnership() public onlyOwner {

        emit OwnershipTransferred(_owner, address(0));

        _owner = address(0);

    }



    /**

     * @dev Transfers ownership of the contract to a new account (`newOwner`).

     * Can only be called by the current owner.

     */

    function transferOwnership(address newOwner) public onlyOwner {

        _transferOwnership(newOwner);

    }



    /**

     * @dev Transfers ownership of the contract to a new account (`newOwner`).

     */

    function _transferOwnership(address newOwner) internal {

        require(newOwner != address(0), "Ownable: new owner is the zero address");

        emit OwnershipTransferred(_owner, newOwner);

        _owner = newOwner;

    }

}









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



    function safeTransfer(IERC20 token, address to, uint256 value) internal {

        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));

    }



    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {

        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));

    }



    function safeApprove(IERC20 token, address spender, uint256 value) internal {

        // safeApprove should only be called when setting an initial allowance,

        // or when resetting it to zero. To increase and decrease it, use

        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'

        // solhint-disable-next-line max-line-length

        require((value == 0) || (token.allowance(address(this), spender) == 0),

            "SafeERC20: approve from non-zero to non-zero allowance"

        );

        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));

    }



    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {

        uint256 newAllowance = token.allowance(address(this), spender).add(value);

        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));

    }



    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {

        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");

        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));

    }



    /**

     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement

     * on the return value: the return value is optional (but if data is returned, it must not be false).

     * @param token The token targeted by the call.

     * @param data The call data (encoded using abi.encode or one of its variants).

     */

    function callOptionalReturn(IERC20 token, bytes memory data) private {

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















contract BeerPoolContract is Ownable, RelayRecipient {

    using IndexedMerkleProof for bytes;

    using SafeERC20 for IERC20;



    IERC20 dai = IERC20(0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359);

    uint160 public merkleRoot;

    uint256 public amountPerUser;

    uint256 public stakingDuration;

    mapping(address => uint256) public stakedAt;

    uint256[1000000] public redeemBitMask;



    event Staked(address who);

    event Redeemed(address who, address where);

    event Aborted();



    constructor(uint160 root, uint256 amount, uint256 duration) public {

        merkleRoot = root;

        amountPerUser = amount;

        stakingDuration = duration;

        setRelayHub(IRelayHub(0xD216153c06E857cD7f72665E0aF1d7D82172F494));

    }



    function acceptRelayedCall(

        address /*relay*/,

        address from,

        bytes memory encodedFunction,

        uint256 /*transactionFee*/,

        uint256 /*gasPrice*/,

        uint256 /*gasLimit*/,

        uint256 /*nonce*/,

        bytes memory /*approvalData*/,

        uint256 /*maxPossibleCharge*/

    )

        public

        view

        returns (uint256, bytes memory)

    {

        // "Stack to deep" fix

        address sender = from;



        uint256 offset;

        bytes memory merkleProof;

        assembly {

            offset := mload(add(encodedFunction, 36)) // 32 + 4

            merkleProof := add(encodedFunction, add(36, offset)) // 32 + 4 + offset

        }



        if (encodedFunction[0] == this.stake.selector[0] &&

            encodedFunction[1] == this.stake.selector[1] &&

            encodedFunction[2] == this.stake.selector[2] &&

            encodedFunction[3] == this.stake.selector[3])

        {

            (uint160 root,) = merkleProof.compute(uint160(uint256(keccak256(abi.encodePacked(sender)))));

            if (root == merkleRoot && !wasStaked(sender)) {

                return (0, "");

            }

        }



        if (encodedFunction[0] == this.redeem.selector[0] &&

            encodedFunction[1] == this.redeem.selector[1] &&

            encodedFunction[2] == this.redeem.selector[2] &&

            encodedFunction[3] == this.redeem.selector[3])

        {

            (uint160 root, uint256 index) = merkleProof.compute(uint160(uint256(keccak256(abi.encodePacked(sender)))));

            if (root == merkleRoot && wasStaked(sender) && now >= stakedAt[sender] + stakingDuration && !wasRedeemed(index)) {

                return (0, "");

            }

        }



        return (777, "Error: 777");

    }



    function wasStaked(address wallet) public view returns(bool) {

        return stakedAt[wallet] != 0;

    }



    function wasRedeemed(uint index) public view returns(bool) {

        return redeemBitMask[index / 256] & (1 << (index % 256)) != 0;

    }



    function wasRedeemedByWalletAndProof(address wallet, bytes memory merkleProof) public view returns(bool) {

        (uint160 root, uint256 index) = merkleProof.compute(uint160(uint256(keccak256(abi.encodePacked(wallet)))));

        require(root == merkleRoot, "Merkle root doesn't match");

        return wasRedeemed(index);

    }



    function stake(bytes memory merkleProof) public {

        (uint160 root,) = merkleProof.compute(uint160(uint256(keccak256(abi.encodePacked(getSender())))));

        require(root == merkleRoot);

        require(!wasStaked(getSender()));



        stakedAt[getSender()] = now;

        emit Staked(getSender());

    }



    function redeem(bytes memory merkleProof, address receiver) public {

        (uint160 root, uint256 index) = merkleProof.compute(uint160(uint256(keccak256(abi.encodePacked(getSender())))));

        require(root == merkleRoot);

        require(wasStaked(getSender()) && now >= stakedAt[getSender()] + stakingDuration);

        require(!wasRedeemed(index));



        redeemBitMask[index / 256] |= (1 << (index % 256));

        dai.safeTransfer(receiver, amountPerUser);

        emit Redeemed(getSender(), receiver);

    }



    function abort() public onlyOwner {

        IRelayHub hub = IRelayHub(getHubAddr());

        hub.withdraw(hub.balanceOf(address(this)), msg.sender);

        dai.safeTransfer(msg.sender, dai.balanceOf(address(this)));

        emit Aborted();

    }



    function preRelayedCall(bytes calldata context) external returns (bytes32) {

    }



    function postRelayedCall(bytes calldata context, bool success, uint actualCharge, bytes32 preRetVal) external {

    }

}

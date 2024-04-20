// File: @0x/contracts-utils/contracts/src/LibBytesRichErrors.sol



/*



  Copyright 2019 ZeroEx Intl.



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



pragma solidity ^0.5.9;

pragma experimental ABIEncoderV2;





library LibBytesRichErrors {



    enum InvalidByteOperationErrorCodes {

        FromLessThanOrEqualsToRequired,

        ToLessThanOrEqualsLengthRequired,

        LengthGreaterThanZeroRequired,

        LengthGreaterThanOrEqualsFourRequired,

        LengthGreaterThanOrEqualsTwentyRequired,

        LengthGreaterThanOrEqualsThirtyTwoRequired,

        LengthGreaterThanOrEqualsNestedBytesLengthRequired,

        DestinationLengthGreaterThanOrEqualSourceLengthRequired

    }



    // bytes4(keccak256("InvalidByteOperationError(uint8,uint256,uint256)"))

    bytes4 internal constant INVALID_BYTE_OPERATION_ERROR_SELECTOR =

        0x28006595;



    // solhint-disable func-name-mixedcase

    function InvalidByteOperationError(

        InvalidByteOperationErrorCodes errorCode,

        uint256 offset,

        uint256 required

    )

        internal

        pure

        returns (bytes memory)

    {

        return abi.encodeWithSelector(

            INVALID_BYTE_OPERATION_ERROR_SELECTOR,

            errorCode,

            offset,

            required

        );

    }

}



// File: @0x/contracts-utils/contracts/src/LibRichErrors.sol



/*



  Copyright 2019 ZeroEx Intl.



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



pragma solidity ^0.5.9;





library LibRichErrors {



    // bytes4(keccak256("Error(string)"))

    bytes4 internal constant STANDARD_ERROR_SELECTOR =

        0x08c379a0;



    // solhint-disable func-name-mixedcase

    /// @dev ABI encode a standard, string revert error payload.

    ///      This is the same payload that would be included by a `revert(string)`

    ///      solidity statement. It has the function signature `Error(string)`.

    /// @param message The error string.

    /// @return The ABI encoded error.

    function StandardError(

        string memory message

    )

        internal

        pure

        returns (bytes memory)

    {

        return abi.encodeWithSelector(

            STANDARD_ERROR_SELECTOR,

            bytes(message)

        );

    }

    // solhint-enable func-name-mixedcase



    /// @dev Reverts an encoded rich revert reason `errorData`.

    /// @param errorData ABI encoded error data.

    function rrevert(bytes memory errorData)

        internal

        pure

    {

        assembly {

            revert(add(errorData, 0x20), mload(errorData))

        }

    }

}



// File: @0x/contracts-utils/contracts/src/LibBytes.sol



/*



  Copyright 2019 ZeroEx Intl.



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



pragma solidity ^0.5.9;









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

        // Ensure that the from and to positions are valid positions for a slice within

        // the byte array that is being used.

        if (from > to) {

            LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(

                LibBytesRichErrors.InvalidByteOperationErrorCodes.FromLessThanOrEqualsToRequired,

                from,

                to

            ));

        }

        if (to > b.length) {

            LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(

                LibBytesRichErrors.InvalidByteOperationErrorCodes.ToLessThanOrEqualsLengthRequired,

                to,

                b.length

            ));

        }



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

        // Ensure that the from and to positions are valid positions for a slice within

        // the byte array that is being used.

        if (from > to) {

            LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(

                LibBytesRichErrors.InvalidByteOperationErrorCodes.FromLessThanOrEqualsToRequired,

                from,

                to

            ));

        }

        if (to > b.length) {

            LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(

                LibBytesRichErrors.InvalidByteOperationErrorCodes.ToLessThanOrEqualsLengthRequired,

                to,

                b.length

            ));

        }



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

        if (b.length == 0) {

            LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(

                LibBytesRichErrors.InvalidByteOperationErrorCodes.LengthGreaterThanZeroRequired,

                b.length,

                0

            ));

        }



        // Store last byte.

        result = b[b.length - 1];



        assembly {

            // Decrement length of byte array.

            let newLen := sub(mload(b), 1)

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

        if (b.length < index + 20) {

            LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(

                LibBytesRichErrors.InvalidByteOperationErrorCodes.LengthGreaterThanOrEqualsTwentyRequired,

                b.length,

                index + 20 // 20 is length of address

            ));

        }



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

        if (b.length < index + 20) {

            LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(

                LibBytesRichErrors.InvalidByteOperationErrorCodes.LengthGreaterThanOrEqualsTwentyRequired,

                b.length,

                index + 20 // 20 is length of address

            ));

        }



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

        if (b.length < index + 32) {

            LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(

                LibBytesRichErrors.InvalidByteOperationErrorCodes.LengthGreaterThanOrEqualsThirtyTwoRequired,

                b.length,

                index + 32

            ));

        }



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

        if (b.length < index + 32) {

            LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(

                LibBytesRichErrors.InvalidByteOperationErrorCodes.LengthGreaterThanOrEqualsThirtyTwoRequired,

                b.length,

                index + 32

            ));

        }



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

        if (b.length < index + 4) {

            LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(

                LibBytesRichErrors.InvalidByteOperationErrorCodes.LengthGreaterThanOrEqualsFourRequired,

                b.length,

                index + 4

            ));

        }



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



    /// @dev Writes a new length to a byte array.

    ///      Decreasing length will lead to removing the corresponding lower order bytes from the byte array.

    ///      Increasing length may lead to appending adjacent in-memory bytes to the end of the byte array.

    /// @param b Bytes array to write new length to.

    /// @param length New length of byte array.

    function writeLength(bytes memory b, uint256 length)

        internal

        pure

    {

        assembly {

            mstore(b, length)

        }

    }

}



// File: @0x/contracts-asset-proxy/contracts/src/interfaces/IAssetData.sol



/*



  Copyright 2019 ZeroEx Intl.



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



// solhint-disable

pragma solidity ^0.5.9;



// @dev Interface of the asset proxy's assetData.

// The asset proxies take an ABI encoded `bytes assetData` as argument.

// This argument is ABI encoded as one of the methods of this interface.

interface IAssetData {



    /// @dev Function signature for encoding ERC20 assetData.

    /// @param tokenAddress Address of ERC20Token contract.

    function ERC20Token(address tokenAddress)

        external;



    /// @dev Function signature for encoding ERC721 assetData.

    /// @param tokenAddress Address of ERC721 token contract.

    /// @param tokenId Id of ERC721 token to be transferred.

    function ERC721Token(

        address tokenAddress,

        uint256 tokenId

    )

        external;



    /// @dev Function signature for encoding ERC1155 assetData.

    /// @param tokenAddress Address of ERC1155 token contract.

    /// @param tokenIds Array of ids of tokens to be transferred.

    /// @param values Array of values that correspond to each token id to be transferred.

    ///        Note that each value will be multiplied by the amount being filled in the order before transferring.

    /// @param callbackData Extra data to be passed to receiver's `onERC1155Received` callback function.

    function ERC1155Assets(

        address tokenAddress,

        uint256[] calldata tokenIds,

        uint256[] calldata values,

        bytes calldata callbackData

    )

        external;



    /// @dev Function signature for encoding MultiAsset assetData.

    /// @param values Array of amounts that correspond to each asset to be transferred.

    ///        Note that each value will be multiplied by the amount being filled in the order before transferring.

    /// @param nestedAssetData Array of assetData fields that will be be dispatched to their correspnding AssetProxy contract.

    function MultiAsset(

        uint256[] calldata values,

        bytes[] calldata nestedAssetData

    )

        external;



    /// @dev Function signature for encoding StaticCall assetData.

    /// @param staticCallTargetAddress Address that will execute the staticcall.

    /// @param staticCallData Data that will be executed via staticcall on the staticCallTargetAddress.

    /// @param expectedReturnDataHash Keccak-256 hash of the expected staticcall return data.

    function StaticCall(

        address staticCallTargetAddress,

        bytes calldata staticCallData,

        bytes32 expectedReturnDataHash

    )

        external;



    /// @dev Function signature for encoding ERC20Bridge assetData.

    /// @param tokenAddress Address of token to transfer.

    /// @param bridgeAddress Address of the bridge contract.

    /// @param bridgeData Arbitrary data to be passed to the bridge contract.

    function ERC20Bridge(

        address tokenAddress,

        address bridgeAddress,

        bytes calldata bridgeData

    )

        external;

}



// File: @0x/contracts-dev-utils/contracts/src/LibAssetData.sol



/*



  Copyright 2019 ZeroEx Intl.



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



pragma solidity ^0.5.16;









library LibAssetData {



    using LibBytes for bytes;



    /// @dev Decode AssetProxy identifier

    /// @param assetData AssetProxy-compliant asset data describing an ERC-20, ERC-721, ERC1155, or MultiAsset asset.

    /// @return The AssetProxy identifier

    function decodeAssetProxyId(bytes memory assetData)

        public

        pure

        returns (

            bytes4 assetProxyId

        )

    {

        assetProxyId = assetData.readBytes4(0);



        require(

            assetProxyId == IAssetData(address(0)).ERC20Token.selector ||

            assetProxyId == IAssetData(address(0)).ERC721Token.selector ||

            assetProxyId == IAssetData(address(0)).ERC1155Assets.selector ||

            assetProxyId == IAssetData(address(0)).MultiAsset.selector ||

            assetProxyId == IAssetData(address(0)).StaticCall.selector,

            "WRONG_PROXY_ID"

        );

        return assetProxyId;

    }



    /// @dev Encode ERC-20 asset data into the format described in the AssetProxy contract specification.

    /// @param tokenAddress The address of the ERC-20 contract hosting the asset to be traded.

    /// @return AssetProxy-compliant data describing the asset.

    function encodeERC20AssetData(address tokenAddress)

        public

        pure

        returns (bytes memory assetData)

    {

        assetData = abi.encodeWithSelector(IAssetData(address(0)).ERC20Token.selector, tokenAddress);

        return assetData;

    }



    /// @dev Decode ERC-20 asset data from the format described in the AssetProxy contract specification.

    /// @param assetData AssetProxy-compliant asset data describing an ERC-20 asset.

    /// @return The AssetProxy identifier, and the address of the ERC-20

    /// contract hosting this asset.

    function decodeERC20AssetData(bytes memory assetData)

        public

        pure

        returns (

            bytes4 assetProxyId,

            address tokenAddress

        )

    {

        assetProxyId = assetData.readBytes4(0);



        require(

            assetProxyId == IAssetData(address(0)).ERC20Token.selector,

            "WRONG_PROXY_ID"

        );



        tokenAddress = assetData.readAddress(16);

        return (assetProxyId, tokenAddress);

    }



    /// @dev Encode ERC-721 asset data into the format described in the AssetProxy specification.

    /// @param tokenAddress The address of the ERC-721 contract hosting the asset to be traded.

    /// @param tokenId The identifier of the specific asset to be traded.

    /// @return AssetProxy-compliant asset data describing the asset.

    function encodeERC721AssetData(address tokenAddress, uint256 tokenId)

        public

        pure

        returns (bytes memory assetData)

    {

        assetData = abi.encodeWithSelector(

            IAssetData(address(0)).ERC721Token.selector,

            tokenAddress,

            tokenId

        );

        return assetData;

    }



    /// @dev Decode ERC-721 asset data from the format described in the AssetProxy contract specification.

    /// @param assetData AssetProxy-compliant asset data describing an ERC-721 asset.

    /// @return The ERC-721 AssetProxy identifier, the address of the ERC-721

    /// contract hosting this asset, and the identifier of the specific

    /// asset to be traded.

    function decodeERC721AssetData(bytes memory assetData)

        public

        pure

        returns (

            bytes4 assetProxyId,

            address tokenAddress,

            uint256 tokenId

        )

    {

        assetProxyId = assetData.readBytes4(0);



        require(

            assetProxyId == IAssetData(address(0)).ERC721Token.selector,

            "WRONG_PROXY_ID"

        );



        tokenAddress = assetData.readAddress(16);

        tokenId = assetData.readUint256(36);

        return (assetProxyId, tokenAddress, tokenId);

    }



    /// @dev Encode ERC-1155 asset data into the format described in the AssetProxy contract specification.

    /// @param tokenAddress The address of the ERC-1155 contract hosting the asset(s) to be traded.

    /// @param tokenIds The identifiers of the specific assets to be traded.

    /// @param tokenValues The amounts of each asset to be traded.

    /// @param callbackData Data to be passed to receiving contracts when a transfer is performed.

    /// @return AssetProxy-compliant asset data describing the set of assets.

    function encodeERC1155AssetData(

        address tokenAddress,

        uint256[] memory tokenIds,

        uint256[] memory tokenValues,

        bytes memory callbackData

    )

        public

        pure

        returns (bytes memory assetData)

    {

        assetData = abi.encodeWithSelector(

            IAssetData(address(0)).ERC1155Assets.selector,

            tokenAddress,

            tokenIds,

            tokenValues,

            callbackData

        );

        return assetData;

    }



    /// @dev Decode ERC-1155 asset data from the format described in the AssetProxy contract specification.

    /// @param assetData AssetProxy-compliant asset data describing an ERC-1155 set of assets.

    /// @return The ERC-1155 AssetProxy identifier, the address of the ERC-1155

    /// contract hosting the assets, an array of the identifiers of the

    /// assets to be traded, an array of asset amounts to be traded, and

    /// callback data.  Each element of the arrays corresponds to the

    /// same-indexed element of the other array.  Return values specified as

    /// `memory` are returned as pointers to locations within the memory of

    /// the input parameter `assetData`.

    function decodeERC1155AssetData(bytes memory assetData)

        public

        pure

        returns (

            bytes4 assetProxyId,

            address tokenAddress,

            uint256[] memory tokenIds,

            uint256[] memory tokenValues,

            bytes memory callbackData

        )

    {

        assetProxyId = assetData.readBytes4(0);



        require(

            assetProxyId == IAssetData(address(0)).ERC1155Assets.selector,

            "WRONG_PROXY_ID"

        );



        assembly {

            // Skip selector and length to get to the first parameter:

            assetData := add(assetData, 36)

            // Read the value of the first parameter:

            tokenAddress := mload(assetData)

            // Point to the next parameter's data:

            tokenIds := add(assetData, mload(add(assetData, 32)))

            // Point to the next parameter's data:

            tokenValues := add(assetData, mload(add(assetData, 64)))

            // Point to the next parameter's data:

            callbackData := add(assetData, mload(add(assetData, 96)))

        }



        return (

            assetProxyId,

            tokenAddress,

            tokenIds,

            tokenValues,

            callbackData

        );

    }



    /// @dev Encode data for multiple assets, per the AssetProxy contract specification.

    /// @param amounts The amounts of each asset to be traded.

    /// @param nestedAssetData AssetProxy-compliant data describing each asset to be traded.

    /// @return AssetProxy-compliant data describing the set of assets.

    function encodeMultiAssetData(uint256[] memory amounts, bytes[] memory nestedAssetData)

        public

        pure

        returns (bytes memory assetData)

    {

        assetData = abi.encodeWithSelector(

            IAssetData(address(0)).MultiAsset.selector,

            amounts,

            nestedAssetData

        );

        return assetData;

    }



    /// @dev Decode multi-asset data from the format described in the AssetProxy contract specification.

    /// @param assetData AssetProxy-compliant data describing a multi-asset basket.

    /// @return The Multi-Asset AssetProxy identifier, an array of the amounts

    /// of the assets to be traded, and an array of the

    /// AssetProxy-compliant data describing each asset to be traded.  Each

    /// element of the arrays corresponds to the same-indexed element of the other array.

    function decodeMultiAssetData(bytes memory assetData)

        public

        pure

        returns (

            bytes4 assetProxyId,

            uint256[] memory amounts,

            bytes[] memory nestedAssetData

        )

    {

        assetProxyId = assetData.readBytes4(0);



        require(

            assetProxyId == IAssetData(address(0)).MultiAsset.selector,

            "WRONG_PROXY_ID"

        );



        // solhint-disable indent

        (amounts, nestedAssetData) = abi.decode(

            assetData.slice(4, assetData.length),

            (uint256[], bytes[])

        );

        // solhint-enable indent

    }



    /// @dev Encode StaticCall asset data into the format described in the AssetProxy contract specification.

    /// @param staticCallTargetAddress Target address of StaticCall.

    /// @param staticCallData Data that will be passed to staticCallTargetAddress in the StaticCall.

    /// @param expectedReturnDataHash Expected Keccak-256 hash of the StaticCall return data.

    /// @return AssetProxy-compliant asset data describing the set of assets.

    function encodeStaticCallAssetData(

        address staticCallTargetAddress,

        bytes memory staticCallData,

        bytes32 expectedReturnDataHash

    )

        public

        pure

        returns (bytes memory assetData)

    {

        assetData = abi.encodeWithSelector(

            IAssetData(address(0)).StaticCall.selector,

            staticCallTargetAddress,

            staticCallData,

            expectedReturnDataHash

        );

        return assetData;

    }



    /// @dev Decode StaticCall asset data from the format described in the AssetProxy contract specification.

    /// @param assetData AssetProxy-compliant asset data describing a StaticCall asset

    /// @return The StaticCall AssetProxy identifier, the target address of the StaticCAll, the data to be

    /// passed to the target address, and the expected Keccak-256 hash of the static call return data.

    function decodeStaticCallAssetData(bytes memory assetData)

        public

        pure

        returns (

            bytes4 assetProxyId,

            address staticCallTargetAddress,

            bytes memory staticCallData,

            bytes32 expectedReturnDataHash

        )

    {

        assetProxyId = assetData.readBytes4(0);



        require(

            assetProxyId == IAssetData(address(0)).StaticCall.selector,

            "WRONG_PROXY_ID"

        );



        (staticCallTargetAddress, staticCallData, expectedReturnDataHash) = abi.decode(

            assetData.slice(4, assetData.length),

            (address, bytes, bytes32)

        );

    }



    /// @dev Decode ERC20Bridge asset data from the format described in the AssetProxy contract specification.

    /// @param assetData AssetProxy-compliant asset data describing an ERC20Bridge asset

    /// @return The ERC20BridgeProxy identifier, the address of the ERC20 token to transfer, the address

    /// of the bridge contract, and extra data to be passed to the bridge contract.

    function decodeERC20BridgeAssetData(bytes memory assetData)

        public

        pure

        returns (

            bytes4 assetProxyId,

            address tokenAddress,

            address bridgeAddress,

            bytes memory bridgeData

        )

    {

        assetProxyId = assetData.readBytes4(0);



        require(

            assetProxyId == IAssetData(address(0)).ERC20Bridge.selector,

            "WRONG_PROXY_ID"

        );



        (tokenAddress, bridgeAddress, bridgeData) = abi.decode(

            assetData.slice(4, assetData.length),

            (address, address, bytes)

        );

    }



    /// @dev Reverts if assetData is not of a valid format for its given proxy id.

    /// @param assetData AssetProxy compliant asset data.

    function revertIfInvalidAssetData(bytes memory assetData)

        public

        pure

    {

        bytes4 assetProxyId = assetData.readBytes4(0);



        if (assetProxyId == IAssetData(address(0)).ERC20Token.selector) {

            decodeERC20AssetData(assetData);

        } else if (assetProxyId == IAssetData(address(0)).ERC721Token.selector) {

            decodeERC721AssetData(assetData);

        } else if (assetProxyId == IAssetData(address(0)).ERC1155Assets.selector) {

            decodeERC1155AssetData(assetData);

        } else if (assetProxyId == IAssetData(address(0)).MultiAsset.selector) {

            decodeMultiAssetData(assetData);

        } else if (assetProxyId == IAssetData(address(0)).StaticCall.selector) {

            decodeStaticCallAssetData(assetData);

        } else if (assetProxyId == IAssetData(address(0)).ERC20Bridge.selector) {

            decodeERC20BridgeAssetData(assetData);

        } else {

            revert("WRONG_PROXY_ID");

        }

    }

}



// File: contracts/ZeroXTest.sol



pragma solidity ^0.5.9;





// library LibRichErrors {



//     // bytes4(keccak256("Error(string)"))

//     bytes4 internal constant STANDARD_ERROR_SELECTOR =

//         0x08c379a0;



//     // solhint-disable func-name-mixedcase

//     /// @dev ABI encode a standard, string revert error payload.

//     ///      This is the same payload that would be included by a `revert(string)`

//     ///      solidity statement. It has the function signature `Error(string)`.

//     /// @param message The error string.

//     /// @return The ABI encoded error.

//     function StandardError(

//         string memory message

//     )

//         internal

//         pure

//         returns (bytes memory)

//     {

//         return abi.encodeWithSelector(

//             STANDARD_ERROR_SELECTOR,

//             bytes(message)

//         );

//     }

//     // solhint-enable func-name-mixedcase



//     /// @dev Reverts an encoded rich revert reason `errorData`.

//     /// @param errorData ABI encoded error data.

//     function rrevert(bytes memory errorData)

//         internal

//         pure

//     {

//         assembly {

//             revert(add(errorData, 0x20), mload(errorData))

//         }

//     }

// }



// File: @0x/contracts-utils/contracts/src/LibSafeMathRichErrors.sol









library LibSafeMathRichErrors {



    // bytes4(keccak256("Uint256BinOpError(uint8,uint256,uint256)"))

    bytes4 internal constant UINT256_BINOP_ERROR_SELECTOR =

        0xe946c1bb;



    // bytes4(keccak256("Uint256DowncastError(uint8,uint256)"))

    bytes4 internal constant UINT256_DOWNCAST_ERROR_SELECTOR =

        0xc996af7b;



    enum BinOpErrorCodes {

        ADDITION_OVERFLOW,

        MULTIPLICATION_OVERFLOW,

        SUBTRACTION_UNDERFLOW,

        DIVISION_BY_ZERO

    }



    enum DowncastErrorCodes {

        VALUE_TOO_LARGE_TO_DOWNCAST_TO_UINT32,

        VALUE_TOO_LARGE_TO_DOWNCAST_TO_UINT64,

        VALUE_TOO_LARGE_TO_DOWNCAST_TO_UINT96

    }



    // solhint-disable func-name-mixedcase

    function Uint256BinOpError(

        BinOpErrorCodes errorCode,

        uint256 a,

        uint256 b

    )

        internal

        pure

        returns (bytes memory)

    {

        return abi.encodeWithSelector(

            UINT256_BINOP_ERROR_SELECTOR,

            errorCode,

            a,

            b

        );

    }



    function Uint256DowncastError(

        DowncastErrorCodes errorCode,

        uint256 a

    )

        internal

        pure

        returns (bytes memory)

    {

        return abi.encodeWithSelector(

            UINT256_DOWNCAST_ERROR_SELECTOR,

            errorCode,

            a

        );

    }

}



// File: @0x/contracts-utils/contracts/src/LibSafeMath.sol













library LibSafeMath {



    function safeMul(uint256 a, uint256 b)

        internal

        pure

        returns (uint256)

    {

        if (a == 0) {

            return 0;

        }

        uint256 c = a * b;

        if (c / a != b) {

            LibRichErrors.rrevert(LibSafeMathRichErrors.Uint256BinOpError(

                LibSafeMathRichErrors.BinOpErrorCodes.MULTIPLICATION_OVERFLOW,

                a,

                b

            ));

        }

        return c;

    }



    function safeDiv(uint256 a, uint256 b)

        internal

        pure

        returns (uint256)

    {

        if (b == 0) {

            LibRichErrors.rrevert(LibSafeMathRichErrors.Uint256BinOpError(

                LibSafeMathRichErrors.BinOpErrorCodes.DIVISION_BY_ZERO,

                a,

                b

            ));

        }

        uint256 c = a / b;

        return c;

    }



    function safeSub(uint256 a, uint256 b)

        internal

        pure

        returns (uint256)

    {

        if (b > a) {

            LibRichErrors.rrevert(LibSafeMathRichErrors.Uint256BinOpError(

                LibSafeMathRichErrors.BinOpErrorCodes.SUBTRACTION_UNDERFLOW,

                a,

                b

            ));

        }

        return a - b;

    }



    function safeAdd(uint256 a, uint256 b)

        internal

        pure

        returns (uint256)

    {

        uint256 c = a + b;

        if (c < a) {

            LibRichErrors.rrevert(LibSafeMathRichErrors.Uint256BinOpError(

                LibSafeMathRichErrors.BinOpErrorCodes.ADDITION_OVERFLOW,

                a,

                b

            ));

        }

        return c;

    }



    function max256(uint256 a, uint256 b)

        internal

        pure

        returns (uint256)

    {

        return a >= b ? a : b;

    }



    function min256(uint256 a, uint256 b)

        internal

        pure

        returns (uint256)

    {

        return a < b ? a : b;

    }

}



// File: @0x/contracts-exchange-libs/contracts/src/LibMathRichErrors.sol









library LibMathRichErrors {



    // bytes4(keccak256("DivisionByZeroError()"))

    bytes internal constant DIVISION_BY_ZERO_ERROR =

        hex"a791837c";



    // bytes4(keccak256("RoundingError(uint256,uint256,uint256)"))

    bytes4 internal constant ROUNDING_ERROR_SELECTOR =

        0x339f3de2;



    // solhint-disable func-name-mixedcase

    function DivisionByZeroError()

        internal

        pure

        returns (bytes memory)

    {

        return DIVISION_BY_ZERO_ERROR;

    }



    function RoundingError(

        uint256 numerator,

        uint256 denominator,

        uint256 target

    )

        internal

        pure

        returns (bytes memory)

    {

        return abi.encodeWithSelector(

            ROUNDING_ERROR_SELECTOR,

            numerator,

            denominator,

            target

        );

    }

}



// File: @0x/contracts-exchange-libs/contracts/src/LibMath.sol



/*



  Copyright 2019 ZeroEx Intl.



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















library LibMath {



    using LibSafeMath for uint256;



    /// @dev Calculates partial value given a numerator and denominator rounded down.

    ///      Reverts if rounding error is >= 0.1%

    /// @param numerator Numerator.

    /// @param denominator Denominator.

    /// @param target Value to calculate partial of.

    /// @return Partial value of target rounded down.

    function safeGetPartialAmountFloor(

        uint256 numerator,

        uint256 denominator,

        uint256 target

    )

        internal

        pure

        returns (uint256 partialAmount)

    {

        if (isRoundingErrorFloor(

                numerator,

                denominator,

                target

        )) {

            LibRichErrors.rrevert(LibMathRichErrors.RoundingError(

                numerator,

                denominator,

                target

            ));

        }



        partialAmount = numerator.safeMul(target).safeDiv(denominator);

        return partialAmount;

    }



    /// @dev Calculates partial value given a numerator and denominator rounded down.

    ///      Reverts if rounding error is >= 0.1%

    /// @param numerator Numerator.

    /// @param denominator Denominator.

    /// @param target Value to calculate partial of.

    /// @return Partial value of target rounded up.

    function safeGetPartialAmountCeil(

        uint256 numerator,

        uint256 denominator,

        uint256 target

    )

        internal

        pure

        returns (uint256 partialAmount)

    {

        if (isRoundingErrorCeil(

                numerator,

                denominator,

                target

        )) {

            LibRichErrors.rrevert(LibMathRichErrors.RoundingError(

                numerator,

                denominator,

                target

            ));

        }



        // safeDiv computes `floor(a / b)`. We use the identity (a, b integer):

        //       ceil(a / b) = floor((a + b - 1) / b)

        // To implement `ceil(a / b)` using safeDiv.

        partialAmount = numerator.safeMul(target)

            .safeAdd(denominator.safeSub(1))

            .safeDiv(denominator);



        return partialAmount;

    }



    /// @dev Calculates partial value given a numerator and denominator rounded down.

    /// @param numerator Numerator.

    /// @param denominator Denominator.

    /// @param target Value to calculate partial of.

    /// @return Partial value of target rounded down.

    function getPartialAmountFloor(

        uint256 numerator,

        uint256 denominator,

        uint256 target

    )

        internal

        pure

        returns (uint256 partialAmount)

    {

        partialAmount = numerator.safeMul(target).safeDiv(denominator);

        return partialAmount;

    }



    /// @dev Calculates partial value given a numerator and denominator rounded down.

    /// @param numerator Numerator.

    /// @param denominator Denominator.

    /// @param target Value to calculate partial of.

    /// @return Partial value of target rounded up.

    function getPartialAmountCeil(

        uint256 numerator,

        uint256 denominator,

        uint256 target

    )

        internal

        pure

        returns (uint256 partialAmount)

    {

        // safeDiv computes `floor(a / b)`. We use the identity (a, b integer):

        //       ceil(a / b) = floor((a + b - 1) / b)

        // To implement `ceil(a / b)` using safeDiv.

        partialAmount = numerator.safeMul(target)

            .safeAdd(denominator.safeSub(1))

            .safeDiv(denominator);



        return partialAmount;

    }



    /// @dev Checks if rounding error >= 0.1% when rounding down.

    /// @param numerator Numerator.

    /// @param denominator Denominator.

    /// @param target Value to multiply with numerator/denominator.

    /// @return Rounding error is present.

    function isRoundingErrorFloor(

        uint256 numerator,

        uint256 denominator,

        uint256 target

    )

        internal

        pure

        returns (bool isError)

    {

        if (denominator == 0) {

            LibRichErrors.rrevert(LibMathRichErrors.DivisionByZeroError());

        }



        // The absolute rounding error is the difference between the rounded

        // value and the ideal value. The relative rounding error is the

        // absolute rounding error divided by the absolute value of the

        // ideal value. This is undefined when the ideal value is zero.

        //

        // The ideal value is `numerator * target / denominator`.

        // Let's call `numerator * target % denominator` the remainder.

        // The absolute error is `remainder / denominator`.

        //

        // When the ideal value is zero, we require the absolute error to

        // be zero. Fortunately, this is always the case. The ideal value is

        // zero iff `numerator == 0` and/or `target == 0`. In this case the

        // remainder and absolute error are also zero.

        if (target == 0 || numerator == 0) {

            return false;

        }



        // Otherwise, we want the relative rounding error to be strictly

        // less than 0.1%.

        // The relative error is `remainder / (numerator * target)`.

        // We want the relative error less than 1 / 1000:

        //        remainder / (numerator * denominator)  <  1 / 1000

        // or equivalently:

        //        1000 * remainder  <  numerator * target

        // so we have a rounding error iff:

        //        1000 * remainder  >=  numerator * target

        uint256 remainder = mulmod(

            target,

            numerator,

            denominator

        );

        isError = remainder.safeMul(1000) >= numerator.safeMul(target);

        return isError;

    }



    /// @dev Checks if rounding error >= 0.1% when rounding up.

    /// @param numerator Numerator.

    /// @param denominator Denominator.

    /// @param target Value to multiply with numerator/denominator.

    /// @return Rounding error is present.

    function isRoundingErrorCeil(

        uint256 numerator,

        uint256 denominator,

        uint256 target

    )

        internal

        pure

        returns (bool isError)

    {

        if (denominator == 0) {

            LibRichErrors.rrevert(LibMathRichErrors.DivisionByZeroError());

        }



        // See the comments in `isRoundingError`.

        if (target == 0 || numerator == 0) {

            // When either is zero, the ideal value and rounded value are zero

            // and there is no rounding error. (Although the relative error

            // is undefined.)

            return false;

        }

        // Compute remainder as before

        uint256 remainder = mulmod(

            target,

            numerator,

            denominator

        );

        remainder = denominator.safeSub(remainder) % denominator;

        isError = remainder.safeMul(1000) >= numerator.safeMul(target);

        return isError;

    }

}



// File: @0x/contracts-utils/contracts/src/LibEIP712.sol



/*



  Copyright 2019 ZeroEx Intl.



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









library LibEIP712 {



    // Hash of the EIP712 Domain Separator Schema

    // keccak256(abi.encodePacked(

    //     "EIP712Domain(",

    //     "string name,",

    //     "string version,",

    //     "uint256 chainId,",

    //     "address verifyingContract",

    //     ")"

    // ))

    bytes32 constant internal _EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH = 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f;



    /// @dev Calculates a EIP712 domain separator.

    /// @param name The EIP712 domain name.

    /// @param version The EIP712 domain version.

    /// @param verifyingContract The EIP712 verifying contract.

    /// @return EIP712 domain separator.

    function hashEIP712Domain(

        string memory name,

        string memory version,

        uint256 chainId,

        address verifyingContract

    )

        internal

        pure

        returns (bytes32 result)

    {

        bytes32 schemaHash = _EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH;



        // Assembly for more efficient computing:

        // keccak256(abi.encodePacked(

        //     _EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH,

        //     keccak256(bytes(name)),

        //     keccak256(bytes(version)),

        //     chainId,

        //     uint256(verifyingContract)

        // ))



        assembly {

            // Calculate hashes of dynamic data

            let nameHash := keccak256(add(name, 32), mload(name))

            let versionHash := keccak256(add(version, 32), mload(version))



            // Load free memory pointer

            let memPtr := mload(64)



            // Store params in memory

            mstore(memPtr, schemaHash)

            mstore(add(memPtr, 32), nameHash)

            mstore(add(memPtr, 64), versionHash)

            mstore(add(memPtr, 96), chainId)

            mstore(add(memPtr, 128), verifyingContract)



            // Compute hash

            result := keccak256(memPtr, 160)

        }

        return result;

    }



    /// @dev Calculates EIP712 encoding for a hash struct with a given domain hash.

    /// @param eip712DomainHash Hash of the domain domain separator data, computed

    ///                         with getDomainHash().

    /// @param hashStruct The EIP712 hash struct.

    /// @return EIP712 hash applied to the given EIP712 Domain.

    function hashEIP712Message(bytes32 eip712DomainHash, bytes32 hashStruct)

        internal

        pure

        returns (bytes32 result)

    {

        // Assembly for more efficient computing:

        // keccak256(abi.encodePacked(

        //     EIP191_HEADER,

        //     EIP712_DOMAIN_HASH,

        //     hashStruct

        // ));



        assembly {

            // Load free memory pointer

            let memPtr := mload(64)



            mstore(memPtr, 0x1901000000000000000000000000000000000000000000000000000000000000)  // EIP191 header

            mstore(add(memPtr, 2), eip712DomainHash)                                            // EIP712 domain hash

            mstore(add(memPtr, 34), hashStruct)                                                 // Hash of struct



            // Compute hash

            result := keccak256(memPtr, 66)

        }

        return result;

    }

}



// File: @0x/contracts-exchange-libs/contracts/src/LibOrder.sol



/*



  Copyright 2019 ZeroEx Intl.



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











library LibOrder {



    using LibOrder for Order;



    // Hash for the EIP712 Order Schema:

    // keccak256(abi.encodePacked(

    //     "Order(",

    //     "address makerAddress,",

    //     "address takerAddress,",

    //     "address feeRecipientAddress,",

    //     "address senderAddress,",

    //     "uint256 makerAssetAmount,",

    //     "uint256 takerAssetAmount,",

    //     "uint256 makerFee,",

    //     "uint256 takerFee,",

    //     "uint256 expirationTimeSeconds,",

    //     "uint256 salt,",

    //     "bytes makerAssetData,",

    //     "bytes takerAssetData,",

    //     "bytes makerFeeAssetData,",

    //     "bytes takerFeeAssetData",

    //     ")"

    // ))

    bytes32 constant internal _EIP712_ORDER_SCHEMA_HASH =

        0xf80322eb8376aafb64eadf8f0d7623f22130fd9491a221e902b713cb984a7534;



    // A valid order remains fillable until it is expired, fully filled, or cancelled.

    // An order's status is unaffected by external factors, like account balances.

    enum OrderStatus {

        INVALID,                     // Default value

        INVALID_MAKER_ASSET_AMOUNT,  // Order does not have a valid maker asset amount

        INVALID_TAKER_ASSET_AMOUNT,  // Order does not have a valid taker asset amount

        FILLABLE,                    // Order is fillable

        EXPIRED,                     // Order has already expired

        FULLY_FILLED,                // Order is fully filled

        CANCELLED                    // Order has been cancelled

    }



    // solhint-disable max-line-length

    /// @dev Canonical order structure.

    struct Order {

        address makerAddress;           // Address that created the order.

        address takerAddress;           // Address that is allowed to fill the order. If set to 0, any address is allowed to fill the order.

        address feeRecipientAddress;    // Address that will recieve fees when order is filled.

        address senderAddress;          // Address that is allowed to call Exchange contract methods that affect this order. If set to 0, any address is allowed to call these methods.

        uint256 makerAssetAmount;       // Amount of makerAsset being offered by maker. Must be greater than 0.

        uint256 takerAssetAmount;       // Amount of takerAsset being bid on by maker. Must be greater than 0.

        uint256 makerFee;               // Fee paid to feeRecipient by maker when order is filled.

        uint256 takerFee;               // Fee paid to feeRecipient by taker when order is filled.

        uint256 expirationTimeSeconds;  // Timestamp in seconds at which order expires.

        uint256 salt;                   // Arbitrary number to facilitate uniqueness of the order's hash.

        bytes makerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring makerAsset. The leading bytes4 references the id of the asset proxy.

        bytes takerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring takerAsset. The leading bytes4 references the id of the asset proxy.

        bytes makerFeeAssetData;        // Encoded data that can be decoded by a specified proxy contract when transferring makerFeeAsset. The leading bytes4 references the id of the asset proxy.

        bytes takerFeeAssetData;        // Encoded data that can be decoded by a specified proxy contract when transferring takerFeeAsset. The leading bytes4 references the id of the asset proxy.

    }

    // solhint-enable max-line-length



    /// @dev Order information returned by `getOrderInfo()`.

    struct OrderInfo {

        OrderStatus orderStatus;                    // Status that describes order's validity and fillability.

        bytes32 orderHash;                    // EIP712 typed data hash of the order (see LibOrder.getTypedDataHash).

        uint256 orderTakerAssetFilledAmount;  // Amount of order that has already been filled.

    }



    /// @dev Calculates the EIP712 typed data hash of an order with a given domain separator.

    /// @param order The order structure.

    /// @return EIP712 typed data hash of the order.

    function getTypedDataHash(Order memory order, bytes32 eip712ExchangeDomainHash)

        internal

        pure

        returns (bytes32 orderHash)

    {

        orderHash = LibEIP712.hashEIP712Message(

            eip712ExchangeDomainHash,

            order.getStructHash()

        );

        return orderHash;

    }



    /// @dev Calculates EIP712 hash of the order struct.

    /// @param order The order structure.

    /// @return EIP712 hash of the order struct.

    function getStructHash(Order memory order)

        internal

        pure

        returns (bytes32 result)

    {

        bytes32 schemaHash = _EIP712_ORDER_SCHEMA_HASH;

        bytes memory makerAssetData = order.makerAssetData;

        bytes memory takerAssetData = order.takerAssetData;

        bytes memory makerFeeAssetData = order.makerFeeAssetData;

        bytes memory takerFeeAssetData = order.takerFeeAssetData;



        // Assembly for more efficiently computing:

        // keccak256(abi.encodePacked(

        //     EIP712_ORDER_SCHEMA_HASH,

        //     uint256(order.makerAddress),

        //     uint256(order.takerAddress),

        //     uint256(order.feeRecipientAddress),

        //     uint256(order.senderAddress),

        //     order.makerAssetAmount,

        //     order.takerAssetAmount,

        //     order.makerFee,

        //     order.takerFee,

        //     order.expirationTimeSeconds,

        //     order.salt,

        //     keccak256(order.makerAssetData),

        //     keccak256(order.takerAssetData),

        //     keccak256(order.makerFeeAssetData),

        //     keccak256(order.takerFeeAssetData)

        // ));



        assembly {

            // Assert order offset (this is an internal error that should never be triggered)

            if lt(order, 32) {

                invalid()

            }



            // Calculate memory addresses that will be swapped out before hashing

            let pos1 := sub(order, 32)

            let pos2 := add(order, 320)

            let pos3 := add(order, 352)

            let pos4 := add(order, 384)

            let pos5 := add(order, 416)



            // Backup

            let temp1 := mload(pos1)

            let temp2 := mload(pos2)

            let temp3 := mload(pos3)

            let temp4 := mload(pos4)

            let temp5 := mload(pos5)



            // Hash in place

            mstore(pos1, schemaHash)

            mstore(pos2, keccak256(add(makerAssetData, 32), mload(makerAssetData)))        // store hash of makerAssetData

            mstore(pos3, keccak256(add(takerAssetData, 32), mload(takerAssetData)))        // store hash of takerAssetData

            mstore(pos4, keccak256(add(makerFeeAssetData, 32), mload(makerFeeAssetData)))  // store hash of makerFeeAssetData

            mstore(pos5, keccak256(add(takerFeeAssetData, 32), mload(takerFeeAssetData)))  // store hash of takerFeeAssetData

            result := keccak256(pos1, 480)



            // Restore

            mstore(pos1, temp1)

            mstore(pos2, temp2)

            mstore(pos3, temp3)

            mstore(pos4, temp4)

            mstore(pos5, temp5)

        }

        return result;

    }

}



// File: @0x/contracts-exchange-libs/contracts/src/LibFillResults.sol



/*



  Copyright 2019 ZeroEx Intl.



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















library LibFillResults {



    using LibSafeMath for uint256;



    struct BatchMatchedFillResults {

        FillResults[] left;              // Fill results for left orders

        FillResults[] right;             // Fill results for right orders

        uint256 profitInLeftMakerAsset;  // Profit taken from left makers

        uint256 profitInRightMakerAsset; // Profit taken from right makers

    }



    struct FillResults {

        uint256 makerAssetFilledAmount;  // Total amount of makerAsset(s) filled.

        uint256 takerAssetFilledAmount;  // Total amount of takerAsset(s) filled.

        uint256 makerFeePaid;            // Total amount of fees paid by maker(s) to feeRecipient(s).

        uint256 takerFeePaid;            // Total amount of fees paid by taker to feeRecipients(s).

        uint256 protocolFeePaid;         // Total amount of fees paid by taker to the staking contract.

    }



    struct MatchedFillResults {

        FillResults left;                // Amounts filled and fees paid of left order.

        FillResults right;               // Amounts filled and fees paid of right order.

        uint256 profitInLeftMakerAsset;  // Profit taken from the left maker

        uint256 profitInRightMakerAsset; // Profit taken from the right maker

    }



    /// @dev Calculates amounts filled and fees paid by maker and taker.

    /// @param order to be filled.

    /// @param takerAssetFilledAmount Amount of takerAsset that will be filled.

    /// @param protocolFeeMultiplier The current protocol fee of the exchange contract.

    /// @param gasPrice The gasprice of the transaction. This is provided so that the function call can continue

    ///        to be pure rather than view.

    /// @return fillResults Amounts filled and fees paid by maker and taker.

    function calculateFillResults(

        LibOrder.Order memory order,

        uint256 takerAssetFilledAmount,

        uint256 protocolFeeMultiplier,

        uint256 gasPrice

    )

        internal

        pure

        returns (FillResults memory fillResults)

    {

        // Compute proportional transfer amounts

        fillResults.takerAssetFilledAmount = takerAssetFilledAmount;

        fillResults.makerAssetFilledAmount = LibMath.safeGetPartialAmountFloor(

            takerAssetFilledAmount,

            order.takerAssetAmount,

            order.makerAssetAmount

        );

        fillResults.makerFeePaid = LibMath.safeGetPartialAmountFloor(

            takerAssetFilledAmount,

            order.takerAssetAmount,

            order.makerFee

        );

        fillResults.takerFeePaid = LibMath.safeGetPartialAmountFloor(

            takerAssetFilledAmount,

            order.takerAssetAmount,

            order.takerFee

        );



        // Compute the protocol fee that should be paid for a single fill.

        fillResults.protocolFeePaid = gasPrice.safeMul(protocolFeeMultiplier);



        return fillResults;

    }



    /// @dev Calculates fill amounts for the matched orders.

    ///      Each order is filled at their respective price point. However, the calculations are

    ///      carried out as though the orders are both being filled at the right order's price point.

    ///      The profit made by the leftOrder order goes to the taker (who matched the two orders).

    /// @param leftOrder First order to match.

    /// @param rightOrder Second order to match.

    /// @param leftOrderTakerAssetFilledAmount Amount of left order already filled.

    /// @param rightOrderTakerAssetFilledAmount Amount of right order already filled.

    /// @param protocolFeeMultiplier The current protocol fee of the exchange contract.

    /// @param gasPrice The gasprice of the transaction. This is provided so that the function call can continue

    ///        to be pure rather than view.

    /// @param shouldMaximallyFillOrders A value that indicates whether or not this calculation should use

    ///                                  the maximal fill order matching strategy.

    /// @param matchedFillResults Amounts to fill and fees to pay by maker and taker of matched orders.

    function calculateMatchedFillResults(

        LibOrder.Order memory leftOrder,

        LibOrder.Order memory rightOrder,

        uint256 leftOrderTakerAssetFilledAmount,

        uint256 rightOrderTakerAssetFilledAmount,

        uint256 protocolFeeMultiplier,

        uint256 gasPrice,

        bool shouldMaximallyFillOrders

    )

        internal

        pure

        returns (MatchedFillResults memory matchedFillResults)

    {

        // Derive maker asset amounts for left & right orders, given store taker assert amounts

        uint256 leftTakerAssetAmountRemaining = leftOrder.takerAssetAmount.safeSub(leftOrderTakerAssetFilledAmount);

        uint256 leftMakerAssetAmountRemaining = LibMath.safeGetPartialAmountFloor(

            leftOrder.makerAssetAmount,

            leftOrder.takerAssetAmount,

            leftTakerAssetAmountRemaining

        );

        uint256 rightTakerAssetAmountRemaining = rightOrder.takerAssetAmount.safeSub(rightOrderTakerAssetFilledAmount);

        uint256 rightMakerAssetAmountRemaining = LibMath.safeGetPartialAmountFloor(

            rightOrder.makerAssetAmount,

            rightOrder.takerAssetAmount,

            rightTakerAssetAmountRemaining

        );



        // Maximally fill the orders and pay out profits to the matcher in one or both of the maker assets.

        if (shouldMaximallyFillOrders) {

            matchedFillResults = _calculateMatchedFillResultsWithMaximalFill(

                leftOrder,

                rightOrder,

                leftMakerAssetAmountRemaining,

                leftTakerAssetAmountRemaining,

                rightMakerAssetAmountRemaining,

                rightTakerAssetAmountRemaining

            );

        } else {

            matchedFillResults = _calculateMatchedFillResults(

                leftOrder,

                rightOrder,

                leftMakerAssetAmountRemaining,

                leftTakerAssetAmountRemaining,

                rightMakerAssetAmountRemaining,

                rightTakerAssetAmountRemaining

            );

        }



        // Compute fees for left order

        matchedFillResults.left.makerFeePaid = LibMath.safeGetPartialAmountFloor(

            matchedFillResults.left.makerAssetFilledAmount,

            leftOrder.makerAssetAmount,

            leftOrder.makerFee

        );

        matchedFillResults.left.takerFeePaid = LibMath.safeGetPartialAmountFloor(

            matchedFillResults.left.takerAssetFilledAmount,

            leftOrder.takerAssetAmount,

            leftOrder.takerFee

        );



        // Compute fees for right order

        matchedFillResults.right.makerFeePaid = LibMath.safeGetPartialAmountFloor(

            matchedFillResults.right.makerAssetFilledAmount,

            rightOrder.makerAssetAmount,

            rightOrder.makerFee

        );

        matchedFillResults.right.takerFeePaid = LibMath.safeGetPartialAmountFloor(

            matchedFillResults.right.takerAssetFilledAmount,

            rightOrder.takerAssetAmount,

            rightOrder.takerFee

        );



        // Compute the protocol fee that should be paid for a single fill. In this

        // case this should be made the protocol fee for both the left and right orders.

        uint256 protocolFee = gasPrice.safeMul(protocolFeeMultiplier);

        matchedFillResults.left.protocolFeePaid = protocolFee;

        matchedFillResults.right.protocolFeePaid = protocolFee;



        // Return fill results

        return matchedFillResults;

    }



    /// @dev Adds properties of both FillResults instances.

    /// @param fillResults1 The first FillResults.

    /// @param fillResults2 The second FillResults.

    /// @return The sum of both fill results.

    function addFillResults(

        FillResults memory fillResults1,

        FillResults memory fillResults2

    )

        internal

        pure

        returns (FillResults memory totalFillResults)

    {

        totalFillResults.makerAssetFilledAmount = fillResults1.makerAssetFilledAmount.safeAdd(fillResults2.makerAssetFilledAmount);

        totalFillResults.takerAssetFilledAmount = fillResults1.takerAssetFilledAmount.safeAdd(fillResults2.takerAssetFilledAmount);

        totalFillResults.makerFeePaid = fillResults1.makerFeePaid.safeAdd(fillResults2.makerFeePaid);

        totalFillResults.takerFeePaid = fillResults1.takerFeePaid.safeAdd(fillResults2.takerFeePaid);

        totalFillResults.protocolFeePaid = fillResults1.protocolFeePaid.safeAdd(fillResults2.protocolFeePaid);



        return totalFillResults;

    }



    /// @dev Calculates part of the matched fill results for a given situation using the fill strategy that only

    ///      awards profit denominated in the left maker asset.

    /// @param leftOrder The left order in the order matching situation.

    /// @param rightOrder The right order in the order matching situation.

    /// @param leftMakerAssetAmountRemaining The amount of the left order maker asset that can still be filled.

    /// @param leftTakerAssetAmountRemaining The amount of the left order taker asset that can still be filled.

    /// @param rightMakerAssetAmountRemaining The amount of the right order maker asset that can still be filled.

    /// @param rightTakerAssetAmountRemaining The amount of the right order taker asset that can still be filled.

    /// @return MatchFillResults struct that does not include fees paid.

    function _calculateMatchedFillResults(

        LibOrder.Order memory leftOrder,

        LibOrder.Order memory rightOrder,

        uint256 leftMakerAssetAmountRemaining,

        uint256 leftTakerAssetAmountRemaining,

        uint256 rightMakerAssetAmountRemaining,

        uint256 rightTakerAssetAmountRemaining

    )

        private

        pure

        returns (MatchedFillResults memory matchedFillResults)

    {

        // Calculate fill results for maker and taker assets: at least one order will be fully filled.

        // The maximum amount the left maker can buy is `leftTakerAssetAmountRemaining`

        // The maximum amount the right maker can sell is `rightMakerAssetAmountRemaining`

        // We have two distinct cases for calculating the fill results:

        // Case 1.

        //   If the left maker can buy more than the right maker can sell, then only the right order is fully filled.

        //   If the left maker can buy exactly what the right maker can sell, then both orders are fully filled.

        // Case 2.

        //   If the left maker cannot buy more than the right maker can sell, then only the left order is fully filled.

        // Case 3.

        //   If the left maker can buy exactly as much as the right maker can sell, then both orders are fully filled.

        if (leftTakerAssetAmountRemaining > rightMakerAssetAmountRemaining) {

            // Case 1: Right order is fully filled

            matchedFillResults = _calculateCompleteRightFill(

                leftOrder,

                rightMakerAssetAmountRemaining,

                rightTakerAssetAmountRemaining

            );

        } else if (leftTakerAssetAmountRemaining < rightMakerAssetAmountRemaining) {

            // Case 2: Left order is fully filled

            matchedFillResults.left.makerAssetFilledAmount = leftMakerAssetAmountRemaining;

            matchedFillResults.left.takerAssetFilledAmount = leftTakerAssetAmountRemaining;

            matchedFillResults.right.makerAssetFilledAmount = leftTakerAssetAmountRemaining;

            // Round up to ensure the maker's exchange rate does not exceed the price specified by the order.

            // We favor the maker when the exchange rate must be rounded.

            matchedFillResults.right.takerAssetFilledAmount = LibMath.safeGetPartialAmountCeil(

                rightOrder.takerAssetAmount,

                rightOrder.makerAssetAmount,

                leftTakerAssetAmountRemaining // matchedFillResults.right.makerAssetFilledAmount

            );

        } else {

            // leftTakerAssetAmountRemaining == rightMakerAssetAmountRemaining

            // Case 3: Both orders are fully filled. Technically, this could be captured by the above cases, but

            //         this calculation will be more precise since it does not include rounding.

            matchedFillResults = _calculateCompleteFillBoth(

                leftMakerAssetAmountRemaining,

                leftTakerAssetAmountRemaining,

                rightMakerAssetAmountRemaining,

                rightTakerAssetAmountRemaining

            );

        }



        // Calculate amount given to taker

        matchedFillResults.profitInLeftMakerAsset = matchedFillResults.left.makerAssetFilledAmount.safeSub(

            matchedFillResults.right.takerAssetFilledAmount

        );



        return matchedFillResults;

    }



    /// @dev Calculates part of the matched fill results for a given situation using the maximal fill order matching

    ///      strategy.

    /// @param leftOrder The left order in the order matching situation.

    /// @param rightOrder The right order in the order matching situation.

    /// @param leftMakerAssetAmountRemaining The amount of the left order maker asset that can still be filled.

    /// @param leftTakerAssetAmountRemaining The amount of the left order taker asset that can still be filled.

    /// @param rightMakerAssetAmountRemaining The amount of the right order maker asset that can still be filled.

    /// @param rightTakerAssetAmountRemaining The amount of the right order taker asset that can still be filled.

    /// @return MatchFillResults struct that does not include fees paid.

    function _calculateMatchedFillResultsWithMaximalFill(

        LibOrder.Order memory leftOrder,

        LibOrder.Order memory rightOrder,

        uint256 leftMakerAssetAmountRemaining,

        uint256 leftTakerAssetAmountRemaining,

        uint256 rightMakerAssetAmountRemaining,

        uint256 rightTakerAssetAmountRemaining

    )

        private

        pure

        returns (MatchedFillResults memory matchedFillResults)

    {

        // If a maker asset is greater than the opposite taker asset, than there will be a spread denominated in that maker asset.

        bool doesLeftMakerAssetProfitExist = leftMakerAssetAmountRemaining > rightTakerAssetAmountRemaining;

        bool doesRightMakerAssetProfitExist = rightMakerAssetAmountRemaining > leftTakerAssetAmountRemaining;



        // Calculate the maximum fill results for the maker and taker assets. At least one of the orders will be fully filled.

        //

        // The maximum that the left maker can possibly buy is the amount that the right order can sell.

        // The maximum that the right maker can possibly buy is the amount that the left order can sell.

        //

        // If the left order is fully filled, profit will be paid out in the left maker asset. If the right order is fully filled,

        // the profit will be out in the right maker asset.

        //

        // There are three cases to consider:

        // Case 1.

        //   If the left maker can buy more than the right maker can sell, then only the right order is fully filled.

        // Case 2.

        //   If the right maker can buy more than the left maker can sell, then only the right order is fully filled.

        // Case 3.

        //   If the right maker can sell the max of what the left maker can buy and the left maker can sell the max of

        //   what the right maker can buy, then both orders are fully filled.

        if (leftTakerAssetAmountRemaining > rightMakerAssetAmountRemaining) {

            // Case 1: Right order is fully filled with the profit paid in the left makerAsset

            matchedFillResults = _calculateCompleteRightFill(

                leftOrder,

                rightMakerAssetAmountRemaining,

                rightTakerAssetAmountRemaining

            );

        } else if (rightTakerAssetAmountRemaining > leftMakerAssetAmountRemaining) {

            // Case 2: Left order is fully filled with the profit paid in the right makerAsset.

            matchedFillResults.left.makerAssetFilledAmount = leftMakerAssetAmountRemaining;

            matchedFillResults.left.takerAssetFilledAmount = leftTakerAssetAmountRemaining;

            // Round down to ensure the right maker's exchange rate does not exceed the price specified by the order.

            // We favor the right maker when the exchange rate must be rounded and the profit is being paid in the

            // right maker asset.

            matchedFillResults.right.makerAssetFilledAmount = LibMath.safeGetPartialAmountFloor(

                rightOrder.makerAssetAmount,

                rightOrder.takerAssetAmount,

                leftMakerAssetAmountRemaining

            );

            matchedFillResults.right.takerAssetFilledAmount = leftMakerAssetAmountRemaining;

        } else {

            // Case 3: The right and left orders are fully filled

            matchedFillResults = _calculateCompleteFillBoth(

                leftMakerAssetAmountRemaining,

                leftTakerAssetAmountRemaining,

                rightMakerAssetAmountRemaining,

                rightTakerAssetAmountRemaining

            );

        }



        // Calculate amount given to taker in the left order's maker asset if the left spread will be part of the profit.

        if (doesLeftMakerAssetProfitExist) {

            matchedFillResults.profitInLeftMakerAsset = matchedFillResults.left.makerAssetFilledAmount.safeSub(

                matchedFillResults.right.takerAssetFilledAmount

            );

        }



        // Calculate amount given to taker in the right order's maker asset if the right spread will be part of the profit.

        if (doesRightMakerAssetProfitExist) {

            matchedFillResults.profitInRightMakerAsset = matchedFillResults.right.makerAssetFilledAmount.safeSub(

                matchedFillResults.left.takerAssetFilledAmount

            );

        }



        return matchedFillResults;

    }



    /// @dev Calculates the fill results for the maker and taker in the order matching and writes the results

    ///      to the fillResults that are being collected on the order. Both orders will be fully filled in this

    ///      case.

    /// @param leftMakerAssetAmountRemaining The amount of the left maker asset that is remaining to be filled.

    /// @param leftTakerAssetAmountRemaining The amount of the left taker asset that is remaining to be filled.

    /// @param rightMakerAssetAmountRemaining The amount of the right maker asset that is remaining to be filled.

    /// @param rightTakerAssetAmountRemaining The amount of the right taker asset that is remaining to be filled.

    /// @return MatchFillResults struct that does not include fees paid or spreads taken.

    function _calculateCompleteFillBoth(

        uint256 leftMakerAssetAmountRemaining,

        uint256 leftTakerAssetAmountRemaining,

        uint256 rightMakerAssetAmountRemaining,

        uint256 rightTakerAssetAmountRemaining

    )

        private

        pure

        returns (MatchedFillResults memory matchedFillResults)

    {

        // Calculate the fully filled results for both orders.

        matchedFillResults.left.makerAssetFilledAmount = leftMakerAssetAmountRemaining;

        matchedFillResults.left.takerAssetFilledAmount = leftTakerAssetAmountRemaining;

        matchedFillResults.right.makerAssetFilledAmount = rightMakerAssetAmountRemaining;

        matchedFillResults.right.takerAssetFilledAmount = rightTakerAssetAmountRemaining;



        return matchedFillResults;

    }



    /// @dev Calculates the fill results for the maker and taker in the order matching and writes the results

    ///      to the fillResults that are being collected on the order.

    /// @param leftOrder The left order that is being maximally filled. All of the information about fill amounts

    ///                  can be derived from this order and the right asset remaining fields.

    /// @param rightMakerAssetAmountRemaining The amount of the right maker asset that is remaining to be filled.

    /// @param rightTakerAssetAmountRemaining The amount of the right taker asset that is remaining to be filled.

    /// @return MatchFillResults struct that does not include fees paid or spreads taken.

    function _calculateCompleteRightFill(

        LibOrder.Order memory leftOrder,

        uint256 rightMakerAssetAmountRemaining,

        uint256 rightTakerAssetAmountRemaining

    )

        private

        pure

        returns (MatchedFillResults memory matchedFillResults)

    {

        matchedFillResults.right.makerAssetFilledAmount = rightMakerAssetAmountRemaining;

        matchedFillResults.right.takerAssetFilledAmount = rightTakerAssetAmountRemaining;

        matchedFillResults.left.takerAssetFilledAmount = rightMakerAssetAmountRemaining;

        // Round down to ensure the left maker's exchange rate does not exceed the price specified by the order.

        // We favor the left maker when the exchange rate must be rounded and the profit is being paid in the

        // left maker asset.

        matchedFillResults.left.makerAssetFilledAmount = LibMath.safeGetPartialAmountFloor(

            leftOrder.makerAssetAmount,

            leftOrder.takerAssetAmount,

            rightMakerAssetAmountRemaining

        );



        return matchedFillResults;

    }

}



contract IExchangeCore {



    // Fill event is emitted whenever an order is filled.

    event Fill(

        address indexed makerAddress,         // Address that created the order.

        address indexed feeRecipientAddress,  // Address that received fees.

        bytes makerAssetData,                 // Encoded data specific to makerAsset.

        bytes takerAssetData,                 // Encoded data specific to takerAsset.

        bytes makerFeeAssetData,              // Encoded data specific to makerFeeAsset.

        bytes takerFeeAssetData,              // Encoded data specific to takerFeeAsset.

        bytes32 indexed orderHash,            // EIP712 hash of order (see LibOrder.getTypedDataHash).

        address takerAddress,                 // Address that filled the order.

        address senderAddress,                // Address that called the Exchange contract (msg.sender).

        uint256 makerAssetFilledAmount,       // Amount of makerAsset sold by maker and bought by taker.

        uint256 takerAssetFilledAmount,       // Amount of takerAsset sold by taker and bought by maker.

        uint256 makerFeePaid,                 // Amount of makerFeeAssetData paid to feeRecipient by maker.

        uint256 takerFeePaid,                 // Amount of takerFeeAssetData paid to feeRecipient by taker.

        uint256 protocolFeePaid               // Amount of eth or weth paid to the staking contract.

    );



    // Cancel event is emitted whenever an individual order is cancelled.

    event Cancel(

        address indexed makerAddress,         // Address that created the order.

        address indexed feeRecipientAddress,  // Address that would have recieved fees if order was filled.

        bytes makerAssetData,                 // Encoded data specific to makerAsset.

        bytes takerAssetData,                 // Encoded data specific to takerAsset.

        address senderAddress,                // Address that called the Exchange contract (msg.sender).

        bytes32 indexed orderHash             // EIP712 hash of order (see LibOrder.getTypedDataHash).

    );



    // CancelUpTo event is emitted whenever `cancelOrdersUpTo` is executed succesfully.

    event CancelUpTo(

        address indexed makerAddress,         // Orders cancelled must have been created by this address.

        address indexed orderSenderAddress,   // Orders cancelled must have a `senderAddress` equal to this address.

        uint256 orderEpoch                    // Orders with specified makerAddress and senderAddress with a salt less than this value are considered cancelled.

    );



    /// @dev Cancels all orders created by makerAddress with a salt less than or equal to the targetOrderEpoch

    ///      and senderAddress equal to msg.sender (or null address if msg.sender == makerAddress).

    /// @param targetOrderEpoch Orders created with a salt less or equal to this value will be cancelled.

    function cancelOrdersUpTo(uint256 targetOrderEpoch)

        external

        payable;



    /// @dev Fills the input order.

    /// @param order Order struct containing order specifications.

    /// @param takerAssetFillAmount Desired amount of takerAsset to sell.

    /// @param signature Proof that order has been created by maker.

    /// @return Amounts filled and fees paid by maker and taker.

    function fillOrder(

        LibOrder.Order memory order,

        uint256 takerAssetFillAmount,

        bytes memory signature

    )

        public

        payable

        returns (LibFillResults.FillResults memory fillResults);



    /// @dev After calling, the order can not be filled anymore.

    /// @param order Order struct containing order specifications.

    function cancelOrder(LibOrder.Order memory order)

        public

        payable;



    /// @dev Gets information about an order: status, hash, and amount filled.

    /// @param order Order to gather information on.

    /// @return OrderInfo Information about the order and its state.

    ///                   See LibOrder.OrderInfo for a complete description.

    function getOrderInfo(LibOrder.Order memory order)

        public

        view

        returns (LibOrder.OrderInfo memory orderInfo);

}



interface IERC20 {

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);

}



contract ZeroXTest {



    address ZERO_X_EXCHANGE_ADDRESS = 0x61935CbDd02287B511119DDb11Aeb42F1593b7Ef;

    address ZERO_X_ERC20_PROXY_ADDRESS = 0x95E6F48254609A6ee006F7D493c8e5fB97094ceF;



    function fill0xOrder(address _fromToken, LibOrder.Order memory _order, uint256 _takerAssetFillAmount, bytes memory _signature) public payable {

        // Approve tokens

        IERC20(_fromToken).approve(ZERO_X_ERC20_PROXY_ADDRESS, _takerAssetFillAmount);

        // Fill order

        IExchangeCore(ZERO_X_EXCHANGE_ADDRESS).fillOrder.value(msg.value)(_order, _takerAssetFillAmount, _signature);

    }



    function validateOrder(LibOrder.Order calldata order) external view returns (bool) {

        LibOrder.OrderInfo memory orderInfo = IExchangeCore(ZERO_X_EXCHANGE_ADDRESS).getOrderInfo(order);

        if (orderInfo.orderStatus != LibOrder.OrderStatus.FILLABLE) {

            return false;

        }



        (,address makerTokenAddress) = LibAssetData.decodeERC20AssetData(order.makerAssetData);

        uint makerBalance = IERC20(makerTokenAddress).balanceOf(order.makerAddress);

        if (makerBalance < order.makerAssetAmount) {

            return false;

        }



        uint makerAllowance = IERC20(makerTokenAddress).allowance(order.makerAddress, ZERO_X_ERC20_PROXY_ADDRESS);

        if (makerAllowance < order.makerAssetAmount) {

            return false;

        }

        return true;

    }



}

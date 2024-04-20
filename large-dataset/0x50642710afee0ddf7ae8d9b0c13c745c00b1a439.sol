// File: contracts/exchange/libs/LibEIP712.sol



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



pragma solidity 0.5.16;





contract LibEIP712 {



    // EIP191 header for EIP712 prefix

    string constant internal EIP191_HEADER = "\\x19\\x01";



    // EIP712 Domain Name value

    string constant internal EIP712_DOMAIN_NAME = "0x Protocol";



    // EIP712 Domain Version value

    string constant internal EIP712_DOMAIN_VERSION = "2";



    // Hash of the EIP712 Domain Separator Schema

    bytes32 constant internal EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH = keccak256(abi.encodePacked(

        "EIP712Domain(",

        "string name,",

        "string version,",

        "address verifyingContract",

        ")"

    ));



    // Hash of the EIP712 Domain Separator data

    // solhint-disable-next-line var-name-mixedcase

    bytes32 public EIP712_DOMAIN_HASH;



    constructor ()

        public

    {

        EIP712_DOMAIN_HASH = keccak256(abi.encodePacked(

            EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH,

            keccak256(bytes(EIP712_DOMAIN_NAME)),

            keccak256(bytes(EIP712_DOMAIN_VERSION)),

            uint256(address(this))

        ));

    }



    /// @dev Calculates EIP712 encoding for a hash struct in this EIP712 Domain.

    /// @param hashStruct The EIP712 hash struct.

    /// @return EIP712 hash applied to this EIP712 Domain.

    function hashEIP712Message(bytes32 hashStruct)

        internal

        view

        returns (bytes32 result)

    {

        bytes32 eip712DomainHash = EIP712_DOMAIN_HASH;



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



// File: contracts/exchange/libs/LibOrder.sol



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



pragma solidity 0.5.16;







contract LibOrder is

    LibEIP712

{

    // Hash for the EIP712 Order Schema

    bytes32 constant internal EIP712_ORDER_SCHEMA_HASH = keccak256(abi.encodePacked(

        "Order(",

        "address makerAddress,",

        "address takerAddress,",

        "address feeRecipientAddress,",

        "address senderAddress,",

        "uint256 makerAssetAmount,",

        "uint256 takerAssetAmount,",

        "uint256 makerFee,",

        "uint256 takerFee,",

        "uint256 expirationTimeSeconds,",

        "uint256 salt,",

        "bytes makerAssetData,",

        "bytes takerAssetData",

        ")"

    ));



    // A valid order remains fillable until it is expired, fully filled, or cancelled.

    // An order's state is unaffected by external factors, like account balances.

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

    struct Order {

        address payable makerAddress;           // Address that created the order.      

        address payable takerAddress;           // Address that is allowed to fill the order. If set to 0, any address is allowed to fill the order.          

        address payable feeRecipientAddress;    // Address that will recieve fees when order is filled.      

        address senderAddress;          // Address that is allowed to call Exchange contract methods that affect this order. If set to 0, any address is allowed to call these methods.

        uint256 makerAssetAmount;       // Amount of makerAsset being offered by maker. Must be greater than 0.        

        uint256 takerAssetAmount;       // Amount of takerAsset being bid on by maker. Must be greater than 0.        

        uint256 makerFee;               // Amount of ZRX paid to feeRecipient by maker when order is filled. If set to 0, no transfer of ZRX from maker to feeRecipient will be attempted.

        uint256 takerFee;               // Amount of ZRX paid to feeRecipient by taker when order is filled. If set to 0, no transfer of ZRX from taker to feeRecipient will be attempted.

        uint256 expirationTimeSeconds;  // Timestamp in seconds at which order expires.          

        uint256 salt;                   // Arbitrary number to facilitate uniqueness of the order's hash.     

        bytes makerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring makerAsset. The last byte references the id of this proxy.

        bytes takerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring takerAsset. The last byte references the id of this proxy.

    }

    // solhint-enable max-line-length



    struct OrderInfo {

        uint8 orderStatus;                    // Status that describes order's validity and fillability.

        bytes32 orderHash;                    // EIP712 hash of the order (see LibOrder.getOrderHash).

        uint256 orderTakerAssetFilledAmount;  // Amount of order that has already been filled.

    }



    /// @dev Calculates Keccak-256 hash of the order.

    /// @param order The order structure.

    /// @return Keccak-256 EIP712 hash of the order.

    function getOrderHash(Order memory order)

        internal

        view

        returns (bytes32 orderHash)

    {

        orderHash = hashEIP712Message(hashOrder(order));

        return orderHash;

    }



    /// @dev Calculates EIP712 hash of the order.

    /// @param order The order structure.

    /// @return EIP712 hash of the order.

    function hashOrder(Order memory order)

        internal

        pure

        returns (bytes32 result)

    {

        bytes32 schemaHash = EIP712_ORDER_SCHEMA_HASH;

        bytes32 makerAssetDataHash = keccak256(order.makerAssetData);

        bytes32 takerAssetDataHash = keccak256(order.takerAssetData);



        // Assembly for more efficiently computing:

        // keccak256(abi.encodePacked(

        //     EIP712_ORDER_SCHEMA_HASH,

        //     bytes32(order.makerAddress),

        //     bytes32(order.takerAddress),

        //     bytes32(order.feeRecipientAddress),

        //     bytes32(order.senderAddress),

        //     order.makerAssetAmount,

        //     order.takerAssetAmount,

        //     order.makerFee,

        //     order.takerFee,

        //     order.expirationTimeSeconds,

        //     order.salt,

        //     keccak256(order.makerAssetData),

        //     keccak256(order.takerAssetData)

        // ));



        assembly {

            // Calculate memory addresses that will be swapped out before hashing

            let pos1 := sub(order, 32)

            let pos2 := add(order, 320)

            let pos3 := add(order, 352)



            // Backup

            let temp1 := mload(pos1)

            let temp2 := mload(pos2)

            let temp3 := mload(pos3)

            

            // Hash in place

            mstore(pos1, schemaHash)

            mstore(pos2, makerAssetDataHash)

            mstore(pos3, takerAssetDataHash)

            result := keccak256(pos1, 416)

            

            // Restore

            mstore(pos1, temp1)

            mstore(pos2, temp2)

            mstore(pos3, temp3)

        }

        return result;

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



// File: @0x/contracts-utils/contracts/src/LibSafeMathRichErrors.sol



pragma solidity ^0.5.9;





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



pragma solidity ^0.5.9;





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



// File: contracts/exchange/libs/LibFillResults.sol



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



pragma solidity 0.5.16;





contract LibFillResults {

    using LibSafeMath for uint256;



    struct FillResults {

        uint256 makerAssetFilledAmount;  // Total amount of makerAsset(s) filled.

        uint256 takerAssetFilledAmount;  // Total amount of takerAsset(s) filled.

        uint256 makerFeePaid;            // Total amount of ZRX paid by maker(s) to feeRecipient(s).

        uint256 takerFeePaid;            // Total amount of ZRX paid by taker to feeRecipients(s).

    }



    struct MatchedFillResults {

        FillResults left;                    // Amounts filled and fees paid of left order.

        FillResults right;                   // Amounts filled and fees paid of right order.

        uint256 leftMakerAssetSpreadAmount;  // Spread between price of left and right order, denominated in the left order's makerAsset, paid to taker.

    }



    /// @dev Adds properties of both FillResults instances.

    ///      Modifies the first FillResults instance specified.

    /// @param totalFillResults Fill results instance that will be added onto.

    /// @param singleFillResults Fill results instance that will be added to totalFillResults.

    function addFillResults(FillResults memory totalFillResults, FillResults memory singleFillResults)

        internal

        pure

    {

        totalFillResults.makerAssetFilledAmount = totalFillResults.makerAssetFilledAmount.safeAdd(singleFillResults.makerAssetFilledAmount);

        totalFillResults.takerAssetFilledAmount = totalFillResults.takerAssetFilledAmount.safeAdd(singleFillResults.takerAssetFilledAmount);

        totalFillResults.makerFeePaid = totalFillResults.makerFeePaid.safeAdd(singleFillResults.makerFeePaid);

        totalFillResults.takerFeePaid = totalFillResults.takerFeePaid.safeAdd(singleFillResults.takerFeePaid);

    }

}



// File: contracts/exchange/interfaces/IExchangeCore.sol



/*



  Modified by Metaps Alpha Inc.



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



pragma solidity 0.5.16;

pragma experimental ABIEncoderV2;





contract IExchangeCore {



    /// @dev Cancels all orders created by makerAddress with a salt less than or equal to the targetOrderEpoch

    ///      and senderAddress equal to msg.sender (or null address if msg.sender == makerAddress).

    /// @param targetOrderEpoch Orders created with a salt less or equal to this value will be cancelled.

    function cancelOrdersUpTo(uint256 targetOrderEpoch)

        external;



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

        public;



    /// @dev Gets information about an order: status, hash, and amount filled.

    /// @param order Order to gather information on.

    /// @return OrderInfo Information about the order and its state.

    ///                   See LibOrder.OrderInfo for a complete description.

    function getOrderInfo(LibOrder.Order memory order)

        public

        view

        returns (LibOrder.OrderInfo memory orderInfo);



    /// @dev miime - Update order (Cancel order and then update deposit for new order).

    /// @param newOrderHash New orderHash for deposit.

    /// @param newOfferAmount New offer amount.

    /// @param orderToBeCanceled Order to be canceled.

    function updateOrder(

        bytes32 newOrderHash,

        uint256 newOfferAmount,

        LibOrder.Order memory orderToBeCanceled

    )

        public

        payable;

}



// File: contracts/exchange/interfaces/IMatchOrders.sol



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

pragma solidity 0.5.16;





contract IMatchOrders {



    /// @dev Match two complementary orders that have a profitable spread.

    ///      Each order is filled at their respective price point. However, the calculations are

    ///      carried out as though the orders are both being filled at the right order's price point.

    ///      The profit made by the left order goes to the taker (who matched the two orders).

    /// @param leftOrder First order to match.

    /// @param rightOrder Second order to match.

    /// @param leftSignature Proof that order was created by the left maker.

    /// @param rightSignature Proof that order was created by the right maker.

    /// @return matchedFillResults Amounts filled and fees paid by maker and taker of matched orders.

    function matchOrders(

        LibOrder.Order memory leftOrder,

        LibOrder.Order memory rightOrder,

        bytes memory leftSignature,

        bytes memory rightSignature

    )

        public

        returns (LibFillResults.MatchedFillResults memory matchedFillResults);

}



// File: contracts/exchange/interfaces/ISignatureValidator.sol



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



pragma solidity 0.5.16;





contract ISignatureValidator {



    /// @dev Approves a hash on-chain using any valid signature type.

    ///      After presigning a hash, the preSign signature type will become valid for that hash and signer.

    /// @param signerAddress Address that should have signed the given hash.

    /// @param signature Proof that the hash has been signed by signer.

    function preSign(

        bytes32 hash,

        address signerAddress,

        bytes calldata signature

    )

        external;

    

    /// @dev Approves/unnapproves a Validator contract to verify signatures on signer's behalf.

    /// @param validatorAddress Address of Validator contract.

    /// @param approval Approval or disapproval of  Validator contract.

    function setSignatureValidatorApproval(

        address validatorAddress,

        bool approval

    )

        external;



    /// @dev Verifies that a signature is valid.

    /// @param hash Message hash that is signed.

    /// @param signerAddress Address of signer.

    /// @param signature Proof of signing.

    /// @return Validity of order signature.

    function isValidSignature(

        bytes32 hash,

        address signerAddress,

        bytes memory signature

    )

        public

        view

        returns (bool isValid);

}



// File: contracts/exchange/interfaces/ITransactions.sol



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

pragma solidity 0.5.16;





contract ITransactions {



    /// @dev Executes an exchange method call in the context of signer.

    /// @param salt Arbitrary number to ensure uniqueness of transaction hash.

    /// @param signerAddress Address of transaction signer.

    /// @param data AbiV2 encoded calldata.

    /// @param signature Proof of signer transaction by signer.

    function executeTransaction(

        uint256 salt,

        address payable signerAddress,

        bytes calldata data,

        bytes calldata signature

    )

        external;

}



// File: contracts/exchange/interfaces/IAssetProxyDispatcher.sol



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



pragma solidity 0.5.16;





contract IAssetProxyDispatcher {



    /// @dev Registers an asset proxy to its asset proxy id.

    ///      Once an asset proxy is registered, it cannot be unregistered.

    /// @param assetProxy Address of new asset proxy to register.

    function registerAssetProxy(address assetProxy)

        external;



    /// @dev Gets an asset proxy.

    /// @param assetProxyId Id of the asset proxy.

    /// @return The asset proxy registered to assetProxyId. Returns 0x0 if no proxy is registered.

    function getAssetProxy(bytes4 assetProxyId)

        external

        view

        returns (address);

}



// File: contracts/exchange/interfaces/IWrapperFunctions.sol



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



pragma solidity 0.5.16;





contract IWrapperFunctions {

    /// @dev Synchronously cancels multiple orders in a single transaction.

    /// @param orders Array of order specifications.

    function batchCancelOrders(LibOrder.Order[] memory orders)

        public;



    /// @dev Fetches information for all passed in orders

    /// @param orders Array of order specifications.

    /// @return Array of OrderInfo instances that correspond to each order.

    function getOrdersInfo(LibOrder.Order[] memory orders)

        public

        view

        returns (LibOrder.OrderInfo[] memory);

}



// File: contracts/exchange/interfaces/IExchange.sol



/*



  Modified by Metaps Alpha Inc.



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



pragma solidity 0.5.16;





// solhint-disable no-empty-blocks

contract IExchange is

    IExchangeCore,

    IMatchOrders,

    ISignatureValidator,

    ITransactions,

    IAssetProxyDispatcher,

    IWrapperFunctions

{

    // miime: DepositManager Interface for Dutch Auction

    function depositByOperator(bytes32 orderHash, address toAddress)

        public

        payable;

}



// File: @0x/contracts-erc20/contracts/src/interfaces/IERC20Token.sol



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





contract IERC20Token {



    // solhint-disable no-simple-event-func-name

    event Transfer(

        address indexed _from,

        address indexed _to,

        uint256 _value

    );



    event Approval(

        address indexed _owner,

        address indexed _spender,

        uint256 _value

    );



    /// @dev send `value` token to `to` from `msg.sender`

    /// @param _to The address of the recipient

    /// @param _value The amount of token to be transferred

    /// @return True if transfer was successful

    function transfer(address _to, uint256 _value)

        external

        returns (bool);



    /// @dev send `value` token to `to` from `from` on the condition it is approved by `from`

    /// @param _from The address of the sender

    /// @param _to The address of the recipient

    /// @param _value The amount of token to be transferred

    /// @return True if transfer was successful

    function transferFrom(

        address _from,

        address _to,

        uint256 _value

    )

        external

        returns (bool);



    /// @dev `msg.sender` approves `_spender` to spend `_value` tokens

    /// @param _spender The address of the account able to transfer the tokens

    /// @param _value The amount of wei to be approved for transfer

    /// @return Always true if the call has enough gas to complete execution

    function approve(address _spender, uint256 _value)

        external

        returns (bool);



    /// @dev Query total supply of token

    /// @return Total supply of token

    function totalSupply()

        external

        view

        returns (uint256);



    /// @param _owner The address from which the balance will be retrieved

    /// @return Balance of owner

    function balanceOf(address _owner)

        external

        view

        returns (uint256);



    /// @param _owner The address of the account owning tokens

    /// @param _spender The address of the account able to transfer the tokens

    /// @return Amount of remaining tokens allowed to spent

    function allowance(address _owner, address _spender)

        external

        view

        returns (uint256);

}



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



// File: contracts/dutch-auction/DutchAuction.sol



/*



  Modified by Metaps Alpha Inc.



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



pragma solidity 0.5.16;





contract DutchAuction {

    using LibBytes for bytes;

    using LibSafeMath for uint256;



    // solhint-disable var-name-mixedcase

    IExchange internal EXCHANGE;



    struct AuctionDetails {

        uint256 beginTimeSeconds;    // Auction begin unix timestamp: sellOrder.makerAssetData

        uint256 endTimeSeconds;      // Auction end unix timestamp: sellOrder.expiryTimeSeconds

        uint256 beginAmount;         // Auction begin amount: sellOrder.makerAssetData

        uint256 endAmount;           // Auction end amount: sellOrder.takerAssetAmount

        uint256 currentAmount;       // Calculated amount given block.timestamp

        uint256 currentTimeSeconds;  // block.timestamp

    }



    constructor (address _exchange)

        public

    {

        EXCHANGE = IExchange(_exchange);

    }



    // miime: ETH acceptable

    function () external payable {

    }



    /// @dev Matches the buy and sell orders at an amount given the following: the current block time, the auction

    ///      start time and the auction begin amount. The sell order is a an order at the lowest amount

    ///      at the end of the auction. Excess from the match is transferred to the seller.

    ///      Over time the price moves from beginAmount to endAmount given the current block.timestamp.

    ///      sellOrder.expiryTimeSeconds is the end time of the auction.

    ///      sellOrder.takerAssetAmount is the end amount of the auction (lowest possible amount).

    ///      sellOrder.makerAssetData is the ABI encoded Asset Proxy data with the following data appended

    ///      buyOrder.makerAssetData is the buyers bid on the auction, must meet the amount for the current block timestamp

    ///      (uint256 beginTimeSeconds, uint256 beginAmount).

    ///      This function reverts in the following scenarios:

    ///         * Auction has not started (auctionDetails.currentTimeSeconds < auctionDetails.beginTimeSeconds)

    ///         * Auction has expired (auctionDetails.endTimeSeconds < auctionDetails.currentTimeSeconds)

    ///         * Amount is invalid: Buy order amount is too low (buyOrder.makerAssetAmount < auctionDetails.currentAmount)

    ///         * Amount is invalid: Invalid begin amount (auctionDetails.beginAmount > auctionDetails.endAmount)

    ///         * Any failure in the 0x Match Orders

    /// @param buyOrder The Buyer's order. This order is for the current expected price of the auction.

    /// @param sellOrder The Seller's order. This order is for the lowest amount (at the end of the auction).

    /// @param buySignature Proof that order was created by the buyer.

    /// @param sellSignature Proof that order was created by the seller.

    /// @return matchedFillResults amounts filled and fees paid by maker and taker of matched orders.

    function matchOrders(

        LibOrder.Order memory buyOrder,

        LibOrder.Order memory sellOrder,

        bytes memory buySignature,

        bytes memory sellSignature,

        bytes32 buyOrderHash

    )

        public

        payable

        returns (LibFillResults.MatchedFillResults memory matchedFillResults)

    {

        AuctionDetails memory auctionDetails = getAuctionDetails(sellOrder);

        // Ensure the auction has not yet started

        require(

            auctionDetails.currentTimeSeconds >= auctionDetails.beginTimeSeconds,

            "AUCTION_NOT_STARTED"

        );

        // Ensure the auction has not expired. This will fail later in 0x but we can save gas by failing early

        require(

            sellOrder.expirationTimeSeconds > auctionDetails.currentTimeSeconds,

            "AUCTION_EXPIRED"

        );

        // Validate the buyer amount is greater than the current auction amount

        require(

            buyOrder.makerAssetAmount >= auctionDetails.currentAmount,

            "INVALID_AMOUNT"

        );



        // miime: Deposit the sending ETH on auction buying

        if (msg.value > 0) {

            EXCHANGE.depositByOperator.value(msg.value)(buyOrderHash, buyOrder.makerAddress);

        }



        // Match orders, maximally filling `buyOrder`

        matchedFillResults = EXCHANGE.matchOrders(

            buyOrder,

            sellOrder,

            buySignature,

            sellSignature

        );

        // The difference in sellOrder.takerAssetAmount and current amount is given as spread to the matcher

        // This may include additional spread from the buyOrder.makerAssetAmount and the currentAmount.

        // e.g currentAmount is 30, sellOrder.takerAssetAmount is 10 and buyOrder.makerAssetamount is 40.

        // 10 (40-30) is returned to the buyer, 20 (30-10) sent to the seller and 10 has previously

        // been transferred to the seller during matchOrders

        uint256 leftMakerAssetSpreadAmount = matchedFillResults.leftMakerAssetSpreadAmount;

        if (leftMakerAssetSpreadAmount > 0) {

            // ERC20 Asset data itself is encoded as follows:

            //

            // | Area     | Offset | Length  | Contents                            |

            // |----------|--------|---------|-------------------------------------|

            // | Header   | 0      | 4       | function selector                   |

            // | Params   |        | 1 * 32  | function parameters:                |

            // |          | 4      | 12      |   1. token address padding          |

            // |          | 16     | 20      |   2. token address                  |

            bytes memory assetData = sellOrder.takerAssetData;

            address token = assetData.readAddress(16);

            // Calculate the excess from the buy order. This can occur if the buyer sends in a higher

            // amount than the calculated current amount

            uint256 buyerExcessAmount = buyOrder.makerAssetAmount.safeSub(auctionDetails.currentAmount);

            uint256 sellerExcessAmount = leftMakerAssetSpreadAmount.safeSub(buyerExcessAmount);

            // miime: Return the difference between auctionDetails.currentAmount and sellOrder.takerAssetAmount

            // and the difference between buyOrder.makerAssetAmount and auctionDetails.currentAmount to the seller

            uint256 excessAmount = buyerExcessAmount.safeAdd(sellerExcessAmount);

            if (excessAmount > 0) {

                if (token == address(0)) {

                    sellOrder.makerAddress.transfer(excessAmount);

                } else {

                    IERC20Token(token).transfer(sellOrder.makerAddress, excessAmount);

                }

            }

            // // Return the difference between auctionDetails.currentAmount and sellOrder.takerAssetAmount

            // // to the seller

            // if (sellerExcessAmount > 0) {

            //     IERC20Token(token).transfer(sellOrder.makerAddress, sellerExcessAmount);

            // }

            // // Return the difference between buyOrder.makerAssetAmount and auctionDetails.currentAmount

            // // to the buyer

            // if (buyerExcessAmount > 0) {

            //     IERC20Token(token).transfer(buyOrder.makerAddress, buyerExcessAmount);

            // }

        }

        return matchedFillResults;

    }



    /// @dev Calculates the Auction Details for the given order

    /// @param order The sell order

    /// @return AuctionDetails

    function getAuctionDetails(LibOrder.Order memory order)

        public

        view

        returns (AuctionDetails memory auctionDetails)

    {

        uint256 makerAssetDataLength = order.makerAssetData.length;

        // It is unknown the encoded data of makerAssetData, we assume the last 64 bytes

        // are the Auction Details encoding.

        // Auction Details is encoded as follows:

        //

        // | Area     | Offset | Length  | Contents                            |

        // |----------|--------|---------|-------------------------------------|

        // | Params   |        | 2 * 32  | parameters:                         |

        // |          | -64    | 32      |   1. auction begin unix timestamp   |

        // |          | -32    | 32      |   2. auction begin begin amount     |

        // ERC20 asset data length is 4+32, 64 for auction details results in min length 100

        require(

            makerAssetDataLength >= 100,

            "INVALID_ASSET_DATA"

        );

        uint256 auctionBeginTimeSeconds = order.makerAssetData.readUint256(makerAssetDataLength - 64);

        uint256 auctionBeginAmount = order.makerAssetData.readUint256(makerAssetDataLength - 32);

        // Ensure the auction has a valid begin time

        require(

            order.expirationTimeSeconds > auctionBeginTimeSeconds,

            "INVALID_BEGIN_TIME"

        );

        uint256 auctionDurationSeconds = order.expirationTimeSeconds-auctionBeginTimeSeconds;

        // Ensure the auction goes from high to low

        uint256 minAmount = order.takerAssetAmount;

        require(

            auctionBeginAmount > minAmount,

            "INVALID_AMOUNT"

        );

        uint256 amountDelta = auctionBeginAmount-minAmount;

        // solhint-disable-next-line not-rely-on-time

        uint256 timestamp = block.timestamp;

        auctionDetails.beginTimeSeconds = auctionBeginTimeSeconds;

        auctionDetails.endTimeSeconds = order.expirationTimeSeconds;

        auctionDetails.beginAmount = auctionBeginAmount;

        auctionDetails.endAmount = minAmount;

        auctionDetails.currentTimeSeconds = timestamp;



        uint256 remainingDurationSeconds = order.expirationTimeSeconds-timestamp;

        if (timestamp < auctionBeginTimeSeconds) {

            // If the auction has not yet begun the current amount is the auctionBeginAmount

            auctionDetails.currentAmount = auctionBeginAmount;

        } else if (timestamp >= order.expirationTimeSeconds) {

            // If the auction has ended the current amount is the minAmount.

            // Auction end time is guaranteed by 0x Exchange due to the order expiration

            auctionDetails.currentAmount = minAmount;

        } else {

            auctionDetails.currentAmount = minAmount.safeAdd(

                remainingDurationSeconds.safeMul(amountDelta).safeDiv(auctionDurationSeconds)

            );

        }

        return auctionDetails;

    }

}

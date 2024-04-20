pragma solidity ^0.5.5;

pragma experimental ABIEncoderV2;



contract SafeMath {



    function safeMul(uint256 a, uint256 b)

        internal

        pure

        returns (uint256)

    {

        if (a == 0) {

            return 0;

        }

        uint256 c = a * b;

        require(

            c / a == b,

            "UINT256_OVERFLOW"

        );

        return c;

    }



    function safeDiv(uint256 a, uint256 b)

        internal

        pure

        returns (uint256)

    {

        uint256 c = a / b;

        return c;

    }



    function safeSub(uint256 a, uint256 b)

        internal

        pure

        returns (uint256)

    {

        require(

            b <= a,

            "UINT256_UNDERFLOW"

        );

        return a - b;

    }



    function safeAdd(uint256 a, uint256 b)

        internal

        pure

        returns (uint256)

    {

        uint256 c = a + b;

        require(

            c >= a,

            "UINT256_OVERFLOW"

        );

        return c;

    }



    function max64(uint64 a, uint64 b)

        internal

        pure

        returns (uint256)

    {

        return a >= b ? a : b;

    }



    function min64(uint64 a, uint64 b)

        internal

        pure

        returns (uint256)

    {

        return a < b ? a : b;

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



contract LibMath is

    SafeMath

{

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

        require(

            denominator > 0,

            "DIVISION_BY_ZERO"

        );



        require(

            !isRoundingErrorFloor(

                numerator,

                denominator,

                target

            ),

            "ROUNDING_ERROR"

        );

        

        partialAmount = safeDiv(

            safeMul(numerator, target),

            denominator

        );

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

        require(

            denominator > 0,

            "DIVISION_BY_ZERO"

        );



        require(

            !isRoundingErrorCeil(

                numerator,

                denominator,

                target

            ),

            "ROUNDING_ERROR"

        );

        

        // safeDiv computes `floor(a / b)`. We use the identity (a, b integer):

        //       ceil(a / b) = floor((a + b - 1) / b)

        // To implement `ceil(a / b)` using safeDiv.

        partialAmount = safeDiv(

            safeAdd(

                safeMul(numerator, target),

                safeSub(denominator, 1)

            ),

            denominator

        );

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

        require(

            denominator > 0,

            "DIVISION_BY_ZERO"

        );



        partialAmount = safeDiv(

            safeMul(numerator, target),

            denominator

        );

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

        require(

            denominator > 0,

            "DIVISION_BY_ZERO"

        );



        // safeDiv computes `floor(a / b)`. We use the identity (a, b integer):

        //       ceil(a / b) = floor((a + b - 1) / b)

        // To implement `ceil(a / b)` using safeDiv.

        partialAmount = safeDiv(

            safeAdd(

                safeMul(numerator, target),

                safeSub(denominator, 1)

            ),

            denominator

        );

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

        require(

            denominator > 0,

            "DIVISION_BY_ZERO"

        );

        

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

        isError = safeMul(1000, remainder) >= safeMul(numerator, target);

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

        require(

            denominator > 0,

            "DIVISION_BY_ZERO"

        );

        

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

        remainder = safeSub(denominator, remainder) % denominator;

        isError = safeMul(1000, remainder) >= safeMul(numerator, target);

        return isError;

    }

}





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

}



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



contract ITransactions {



    /// @dev Executes an exchange method call in the context of signer.

    /// @param salt Arbitrary number to ensure uniqueness of transaction hash.

    /// @param signerAddress Address of transaction signer.

    /// @param data AbiV2 encoded calldata.

    /// @param signature Proof of signer transaction by signer.

    function executeTransaction(

        uint256 salt,

        address signerAddress,

        bytes calldata data,

        bytes calldata signature

    )

        external;

}



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











contract LibFillResults is

    SafeMath

{

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

        totalFillResults.makerAssetFilledAmount = safeAdd(totalFillResults.makerAssetFilledAmount, singleFillResults.makerAssetFilledAmount);

        totalFillResults.takerAssetFilledAmount = safeAdd(totalFillResults.takerAssetFilledAmount, singleFillResults.takerAssetFilledAmount);

        totalFillResults.makerFeePaid = safeAdd(totalFillResults.makerFeePaid, singleFillResults.makerFeePaid);

        totalFillResults.takerFeePaid = safeAdd(totalFillResults.takerFeePaid, singleFillResults.takerFeePaid);

    }

}





contract IWrapperFunctions {



    /// @dev Fills the input order. Reverts if exact takerAssetFillAmount not filled.

    /// @param order LibOrder.Order struct containing order specifications.

    /// @param takerAssetFillAmount Desired amount of takerAsset to sell.

    /// @param signature Proof that order has been created by maker.

    function fillOrKillOrder(

        LibOrder.Order memory order,

        uint256 takerAssetFillAmount,

        bytes memory signature

    )

        public

        returns (LibFillResults.FillResults memory fillResults);



    /// @dev Fills an order with specified parameters and ECDSA signature.

    ///      Returns false if the transaction would otherwise revert.

    /// @param order LibOrder.Order struct containing order specifications.

    /// @param takerAssetFillAmount Desired amount of takerAsset to sell.

    /// @param signature Proof that order has been created by maker.

    /// @return Amounts filled and fees paid by maker and taker.

    function fillOrderNoThrow(

        LibOrder.Order memory order,

        uint256 takerAssetFillAmount,

        bytes memory signature

    )

        public

        returns (LibFillResults.FillResults memory fillResults);



    /// @dev Synchronously executes multiple calls of fillOrder.

    /// @param orders Array of order specifications.

    /// @param takerAssetFillAmounts Array of desired amounts of takerAsset to sell in orders.

    /// @param signatures Proofs that orders have been created by makers.

    /// @return Amounts filled and fees paid by makers and taker.

    function batchFillOrders(

        LibOrder.Order[] memory orders,

        uint256[] memory takerAssetFillAmounts,

        bytes[] memory signatures

    )

        public

        returns (LibFillResults.FillResults memory totalFillResults);



    /// @dev Synchronously executes multiple calls of fillOrKill.

    /// @param orders Array of order specifications.

    /// @param takerAssetFillAmounts Array of desired amounts of takerAsset to sell in orders.

    /// @param signatures Proofs that orders have been created by makers.

    /// @return Amounts filled and fees paid by makers and taker.

    function batchFillOrKillOrders(

        LibOrder.Order[] memory orders,

        uint256[] memory takerAssetFillAmounts,

        bytes[] memory signatures

    )

        public

        returns (LibFillResults.FillResults memory totalFillResults);



    /// @dev Fills an order with specified parameters and ECDSA signature.

    ///      Returns false if the transaction would otherwise revert.

    /// @param orders Array of order specifications.

    /// @param takerAssetFillAmounts Array of desired amounts of takerAsset to sell in orders.

    /// @param signatures Proofs that orders have been created by makers.

    /// @return Amounts filled and fees paid by makers and taker.

    function batchFillOrdersNoThrow(

        LibOrder.Order[] memory orders,

        uint256[] memory takerAssetFillAmounts,

        bytes[] memory signatures

    )

        public

        returns (LibFillResults.FillResults memory totalFillResults);



    /// @dev Synchronously executes multiple calls of fillOrder until total amount of takerAsset is sold by taker.

    /// @param orders Array of order specifications.

    /// @param takerAssetFillAmount Desired amount of takerAsset to sell.

    /// @param signatures Proofs that orders have been created by makers.

    /// @return Amounts filled and fees paid by makers and taker.

    function marketSellOrders(

        LibOrder.Order[] memory orders,

        uint256 takerAssetFillAmount,

        bytes[] memory signatures

    )

        public

        returns (LibFillResults.FillResults memory totalFillResults);



    /// @dev Synchronously executes multiple calls of fillOrder until total amount of takerAsset is sold by taker.

    ///      Returns false if the transaction would otherwise revert.

    /// @param orders Array of order specifications.

    /// @param takerAssetFillAmount Desired amount of takerAsset to sell.

    /// @param signatures Proofs that orders have been signed by makers.

    /// @return Amounts filled and fees paid by makers and taker.

    function marketSellOrdersNoThrow(

        LibOrder.Order[] memory orders,

        uint256 takerAssetFillAmount,

        bytes[] memory signatures

    )

        public

        returns (LibFillResults.FillResults memory totalFillResults);



    /// @dev Synchronously executes multiple calls of fillOrder until total amount of makerAsset is bought by taker.

    /// @param orders Array of order specifications.

    /// @param makerAssetFillAmount Desired amount of makerAsset to buy.

    /// @param signatures Proofs that orders have been signed by makers.

    /// @return Amounts filled and fees paid by makers and taker.

    function marketBuyOrders(

        LibOrder.Order[] memory orders,

        uint256 makerAssetFillAmount,

        bytes[] memory signatures

    )

        public

        returns (LibFillResults.FillResults memory totalFillResults);



    /// @dev Synchronously executes multiple fill orders in a single transaction until total amount is bought by taker.

    ///      Returns false if the transaction would otherwise revert.

    /// @param orders Array of order specifications.

    /// @param makerAssetFillAmount Desired amount of makerAsset to buy.

    /// @param signatures Proofs that orders have been signed by makers.

    /// @return Amounts filled and fees paid by makers and taker.

    function marketBuyOrdersNoThrow(

        LibOrder.Order[] memory orders,

        uint256 makerAssetFillAmount,

        bytes[] memory signatures

    )

        public

        returns (LibFillResults.FillResults memory totalFillResults);



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





// solhint-disable no-empty-blocks

contract IExchange is

    IExchangeCore,

    IMatchOrders,

    ISignatureValidator,

    ITransactions,

    IAssetProxyDispatcher,

    IWrapperFunctions

{}



contract LibAssetProxyIds {



    // AssetProxy Ids are equiavalent the first 4 bytes of the keccak256 hash of the function signature assigned to each AssetProxy.



    // ERC20Token(address)

    bytes4 constant public ERC20_PROXY_ID = 0xf47261b0;



    // ERC721Token(address,uint256)

    bytes4 constant public ERC721_PROXY_ID = 0x02571792;



    // ERC1155Assets(address,uint256[],uint256[],bytes)

    bytes4 constant public ERC1155_PROXY_ID = 0xa7cb5fb7;



    // MultiAsset(uint256[],bytes[])

    bytes4 constant public MULTI_ASSET_PROXY_ID = 0x94cfcdd7;



    // StaticCall(address,bytes,bytes32)

    bytes4 constant public STATIC_CALL_PROXY_ID = 0xc339d10a;

}





contract LibAssetData is

    LibAssetProxyIds

{

    // 2^256 - 1

    uint256 constant internal _MAX_UINT256 = uint256(-1);



    // ERC20 selectors

    bytes4 constant internal _ERC20_BALANCE_OF_SELECTOR = 0x70a08231;

    bytes4 constant internal _ERC20_ALLOWANCE_SELECTOR = 0xdd62ed3e;



    // ERC721 selectors

    bytes4 constant internal _ERC721_OWNER_OF_SELECTOR = 0x6352211e;

    bytes4 constant internal _ERC721_IS_APPROVED_FOR_ALL_SELECTOR = 0xe985e9c5;

    bytes4 constant internal _ERC721_GET_APPROVED_SELECTOR = 0x081812fc;



    // ERC1155 selectors

    bytes4 constant internal _ERC1155_BALANCE_OF_SELECTOR = 0x00fdd58e;

    bytes4 constant internal _ERC1155_IS_APPROVED_FOR_ALL_SELECTOR = 0xe985e9c5;



    // `transferFrom` selector for all AssetProxy contracts

    bytes4 constant internal _ASSET_PROXY_TRANSFER_FROM_SELECTOR = 0xa85e59e4;



    using LibBytes for bytes;



    // solhint-disable var-name-mixedcase

    IExchange internal _EXCHANGE;

    address internal _ERC20_PROXY_ADDRESS;

    address internal _ERC721_PROXY_ADDRESS;

    address internal _ERC1155_PROXY_ADDRESS;

    address internal _STATIC_CALL_PROXY_ADDRESS;

    // solhint-enable var-name-mixedcase



    constructor (address _exchange)

        public

    {

        _EXCHANGE = IExchange(_exchange);

        _ERC20_PROXY_ADDRESS = _EXCHANGE.getAssetProxy(ERC20_PROXY_ID);

        _ERC721_PROXY_ADDRESS = _EXCHANGE.getAssetProxy(ERC721_PROXY_ID);

        _ERC1155_PROXY_ADDRESS = _EXCHANGE.getAssetProxy(ERC1155_PROXY_ID);

        _STATIC_CALL_PROXY_ADDRESS = _EXCHANGE.getAssetProxy(STATIC_CALL_PROXY_ID);

    }



    /// @dev Returns the owner's balance of the assets(s) specified in

    /// assetData.  When the asset data contains multiple assets (eg in

    /// ERC1155 or Multi-Asset), the return value indicates how many

    /// complete "baskets" of those assets are owned by owner.

    /// @param ownerAddress Owner of the assets specified by assetData.

    /// @param assetData Details of asset, encoded per the AssetProxy contract specification.

    /// @return Number of assets (or asset baskets) held by owner.

    function getBalance(address ownerAddress, bytes memory assetData)

        public

        view

        returns (uint256 balance)

    {

        // Get id of AssetProxy contract

        bytes4 assetProxyId = assetData.readBytes4(0);



        if (assetProxyId == ERC20_PROXY_ID) {

            // Get ERC20 token address

            address tokenAddress = assetData.readAddress(16);



            // Encode data for `balanceOf(ownerAddress)`

            bytes memory balanceOfData = abi.encodeWithSelector(_ERC20_BALANCE_OF_SELECTOR, ownerAddress);



            // Query balance

            (bool success, bytes memory returnData) = tokenAddress.staticcall(balanceOfData);

            balance = success && returnData.length == 32 ? returnData.readUint256(0) : 0;

        } else if (assetProxyId == ERC721_PROXY_ID) {

            // Get ERC721 token address and id

            (, address tokenAddress, uint256 tokenId) = decodeERC721AssetData(assetData);



            // Check if id is owned by ownerAddress

            balance = getERC721TokenOwner(tokenAddress, tokenId) == ownerAddress ? 1 : 0;

        } else if (assetProxyId == ERC1155_PROXY_ID) {

            // Get ERC1155 token address, array of ids, and array of values

            (, address tokenAddress, uint256[] memory tokenIds, uint256[] memory tokenValues,) = decodeERC1155AssetData(assetData);



            uint256 length = tokenIds.length;

            for (uint256 i = 0; i != length; i++) {

                // Encode data for `balanceOf(ownerAddress, tokenIds[i])

                bytes memory balanceOfData = abi.encodeWithSelector(

                    _ERC1155_BALANCE_OF_SELECTOR,

                    ownerAddress,

                    tokenIds[i]

                );



                // Query balance

                (bool success, bytes memory returnData) = tokenAddress.staticcall(balanceOfData);

                uint256 totalBalance = success && returnData.length == 32 ? returnData.readUint256(0) : 0;



                // Scale total balance down by corresponding value in assetData

                uint256 scaledBalance = totalBalance / tokenValues[i];

                if (scaledBalance < balance || balance == 0) {

                    balance = scaledBalance;

                }

            }

        } else if (assetProxyId == STATIC_CALL_PROXY_ID) {

            // Encode data for `staticCallProxy.transferFrom(assetData,...)`

            bytes memory transferFromData = abi.encodeWithSelector(

                _ASSET_PROXY_TRANSFER_FROM_SELECTOR,

                assetData,

                address(0),  // `from` address is not used

                address(0),  // `to` address is not used

                0            // `amount` is not used

            );



            // Check if staticcall would be successful

            (bool success,) = _STATIC_CALL_PROXY_ADDRESS.staticcall(transferFromData);



            // Success means that the staticcall can be made an unlimited amount of times

            balance = success ? _MAX_UINT256 : 0;

        } else if (assetProxyId == MULTI_ASSET_PROXY_ID) {

            // Get array of values and array of assetDatas

            (, uint256[] memory assetAmounts, bytes[] memory nestedAssetData) = decodeMultiAssetData(assetData);



            uint256 length = nestedAssetData.length;

            for (uint256 i = 0; i != length; i++) {

                // Query balance of individual assetData

                uint256 totalBalance = getBalance(ownerAddress, nestedAssetData[i]);



                // Scale total balance down by corresponding value in assetData

                uint256 scaledBalance = totalBalance / assetAmounts[i];

                if (scaledBalance < balance || balance == 0) {

                    balance = scaledBalance;

                }

            }

        } 



        // Balance will be 0 if assetProxyId is unknown

        return balance;

    }



    /// @dev Calls getBalance() for each element of assetData.

    /// @param ownerAddress Owner of the assets specified by assetData.

    /// @param assetData Array of asset details, each encoded per the AssetProxy contract specification.

    /// @return Array of asset balances from getBalance(), with each element

    /// corresponding to the same-indexed element in the assetData input.

    function getBatchBalances(address ownerAddress, bytes[] memory assetData)

        public

        view

        returns (uint256[] memory balances)

    {

        uint256 length = assetData.length;

        balances = new uint256[](length);

        for (uint256 i = 0; i != length; i++) {

            balances[i] = getBalance(ownerAddress, assetData[i]);

        }

        return balances;

    }



    /// @dev Returns the number of asset(s) (described by assetData) that

    /// the corresponding AssetProxy contract is authorized to spend.  When the asset data contains

    /// multiple assets (eg for Multi-Asset), the return value indicates

    /// how many complete "baskets" of those assets may be spent by all of the corresponding

    /// AssetProxy contracts.

    /// @param ownerAddress Owner of the assets specified by assetData.

    /// @param assetData Details of asset, encoded per the AssetProxy contract specification.

    /// @return Number of assets (or asset baskets) that the corresponding AssetProxy is authorized to spend.

    function getAssetProxyAllowance(address ownerAddress, bytes memory assetData)

        public

        view

        returns (uint256 allowance)

    {

        // Get id of AssetProxy contract

        bytes4 assetProxyId = assetData.readBytes4(0);



        if (assetProxyId == MULTI_ASSET_PROXY_ID) {

            // Get array of values and array of assetDatas

            (, uint256[] memory amounts, bytes[] memory nestedAssetData) = decodeMultiAssetData(assetData);



            uint256 length = nestedAssetData.length;

            for (uint256 i = 0; i != length; i++) {

                // Query allowance of individual assetData

                uint256 totalAllowance = getAssetProxyAllowance(ownerAddress, nestedAssetData[i]);



                // Scale total allowance down by corresponding value in assetData

                uint256 scaledAllowance = totalAllowance / amounts[i];

                if (scaledAllowance < allowance || allowance == 0) {

                    allowance = scaledAllowance;

                }

            }

            return allowance;

        }



        if (assetProxyId == ERC20_PROXY_ID) {

            // Get ERC20 token address

            address tokenAddress = assetData.readAddress(16);



            // Encode data for `allowance(ownerAddress, _ERC20_PROXY_ADDRESS)`

            bytes memory allowanceData = abi.encodeWithSelector(

                _ERC20_ALLOWANCE_SELECTOR,

                ownerAddress,

                _ERC20_PROXY_ADDRESS

            );



            // Query allowance

            (bool success, bytes memory returnData) = tokenAddress.staticcall(allowanceData);

            allowance = success && returnData.length == 32 ? returnData.readUint256(0) : 0;

        } else if (assetProxyId == ERC721_PROXY_ID) {

            // Get ERC721 token address and id

            (, address tokenAddress, uint256 tokenId) = decodeERC721AssetData(assetData);



            // Encode data for `isApprovedForAll(ownerAddress, _ERC721_PROXY_ADDRESS)`

            bytes memory isApprovedForAllData = abi.encodeWithSelector(

                _ERC721_IS_APPROVED_FOR_ALL_SELECTOR,

                ownerAddress,

                _ERC721_PROXY_ADDRESS

            );



            (bool success, bytes memory returnData) = tokenAddress.staticcall(isApprovedForAllData);



            // If not approved for all, call `getApproved(tokenId)`

            if (!success || returnData.length != 32 || returnData.readUint256(0) != 1) {

                // Encode data for `getApproved(tokenId)`

                bytes memory getApprovedData = abi.encodeWithSelector(_ERC721_GET_APPROVED_SELECTOR, tokenId);

                (success, returnData) = tokenAddress.staticcall(getApprovedData);



                // Allowance is 1 if successful and the approved address is the ERC721Proxy

                allowance = success && returnData.length == 32 && returnData.readAddress(12) == _ERC721_PROXY_ADDRESS ? 1 : 0;

            } else {

                // Allowance is 2^256 - 1 if `isApprovedForAll` returned true

                allowance = _MAX_UINT256;

            }

        } else if (assetProxyId == ERC1155_PROXY_ID) {

            // Get ERC1155 token address

            (, address tokenAddress, , , ) = decodeERC1155AssetData(assetData);



            // Encode data for `isApprovedForAll(ownerAddress, _ERC1155_PROXY_ADDRESS)`

            bytes memory isApprovedForAllData = abi.encodeWithSelector(

                _ERC1155_IS_APPROVED_FOR_ALL_SELECTOR,

                ownerAddress,

                _ERC1155_PROXY_ADDRESS

            );



            // Query allowance

            (bool success, bytes memory returnData) = tokenAddress.staticcall(isApprovedForAllData);

            allowance = success && returnData.length == 32 && returnData.readUint256(0) == 1 ? _MAX_UINT256 : 0;

        } else if (assetProxyId == STATIC_CALL_PROXY_ID) {

            // The StaticCallProxy does not require any approvals

            allowance = _MAX_UINT256;

        }



        // Allowance will be 0 if the assetProxyId is unknown

        return allowance;

    }



    /// @dev Calls getAssetProxyAllowance() for each element of assetData.

    /// @param ownerAddress Owner of the assets specified by assetData.

    /// @param assetData Array of asset details, each encoded per the AssetProxy contract specification.

    /// @return An array of asset allowances from getAllowance(), with each

    /// element corresponding to the same-indexed element in the assetData input.

    function getBatchAssetProxyAllowances(address ownerAddress, bytes[] memory assetData)

        public

        view

        returns (uint256[] memory allowances)

    {

        uint256 length = assetData.length;

        allowances = new uint256[](length);

        for (uint256 i = 0; i != length; i++) {

            allowances[i] = getAssetProxyAllowance(ownerAddress, assetData[i]);

        }

        return allowances;

    }



    /// @dev Calls getBalance() and getAllowance() for assetData.

    /// @param ownerAddress Owner of the assets specified by assetData.

    /// @param assetData Details of asset, encoded per the AssetProxy contract specification.

    /// @return Number of assets (or asset baskets) held by owner, and number

    /// of assets (or asset baskets) that the corresponding AssetProxy is authorized to spend.

    function getBalanceAndAssetProxyAllowance(address ownerAddress, bytes memory assetData)

        public

        view

        returns (uint256 balance, uint256 allowance)

    {

        balance = getBalance(ownerAddress, assetData);

        allowance = getAssetProxyAllowance(ownerAddress, assetData);

        return (balance, allowance);

    }



    /// @dev Calls getBatchBalances() and getBatchAllowances() for each element of assetData.

    /// @param ownerAddress Owner of the assets specified by assetData.

    /// @param assetData Array of asset details, each encoded per the AssetProxy contract specification.

    /// @return An array of asset balances from getBalance(), and an array of

    /// asset allowances from getAllowance(), with each element

    /// corresponding to the same-indexed element in the assetData input.

    function getBatchBalancesAndAssetProxyAllowances(address ownerAddress, bytes[] memory assetData)

        public

        view

        returns (uint256[] memory balances, uint256[] memory allowances)

    {

        balances = getBatchBalances(ownerAddress, assetData);

        allowances = getBatchAssetProxyAllowances(ownerAddress, assetData);

        return (balances, allowances);

    }



    /// @dev Encode ERC-20 asset data into the format described in the AssetProxy contract specification.

    /// @param tokenAddress The address of the ERC-20 contract hosting the asset to be traded.

    /// @return AssetProxy-compliant data describing the asset.

    function encodeERC20AssetData(address tokenAddress)

        public

        pure

        returns (bytes memory assetData)

    {

        assetData = abi.encodeWithSelector(ERC20_PROXY_ID, tokenAddress);

        return assetData;

    }



    /// @dev Decode ERC-20 asset data from the format described in the AssetProxy contract specification.

    /// @param assetData AssetProxy-compliant asset data describing an ERC-20 asset.

    /// @return The ERC-20 AssetProxy identifier, and the address of the ERC-20 

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

            assetProxyId == ERC20_PROXY_ID,

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

            ERC721_PROXY_ID,

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

            assetProxyId == ERC721_PROXY_ID,

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

            ERC1155_PROXY_ID,

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

            assetProxyId == ERC1155_PROXY_ID,

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

            MULTI_ASSET_PROXY_ID,

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

            assetProxyId == MULTI_ASSET_PROXY_ID,

            "WRONG_PROXY_ID"

        );



        // solhint-disable indent

        (amounts, nestedAssetData) = abi.decode(

            assetData.slice(4, assetData.length),

            (uint256[], bytes[])

        );

        // solhint-enable indent

    }



    /// @dev Calls `asset.ownerOf(tokenId)`, but returns a null owner instead of reverting on an unowned asset.

    /// @param tokenAddress Address of ERC721 asset.

    /// @param tokenId The identifier for the specific NFT.

    /// @return Owner of tokenId or null address if unowned.

    function getERC721TokenOwner(address tokenAddress, uint256 tokenId)

        public

        view

        returns (address ownerAddress)

    {

        bytes memory ownerOfCalldata = abi.encodeWithSelector(

            _ERC721_OWNER_OF_SELECTOR,

            tokenId

        );



        (bool success, bytes memory returnData) = tokenAddress.staticcall(ownerOfCalldata);



        ownerAddress = (success && returnData.length == 32) ? returnData.readAddress(12) : address(0);

        return ownerAddress;

    }

}





contract OrderValidationUtils is

    LibAssetData,

    LibMath

{

    using LibBytes for bytes;



    // solhint-disable var-name-mixedcase

    bytes internal _ZRX_ASSET_DATA;

    // solhint-enable var-name-mixedcase



    constructor (address _exchange, bytes memory _zrxAssetData)

        public

        LibAssetData(_exchange)

    {

        _ZRX_ASSET_DATA = _zrxAssetData;

    }



    /// @dev Fetches all order-relevant information needed to validate if the supplied order is fillable.

    /// @param order The order structure.

    /// @param signature Signature provided by maker that proves the order's authenticity.

    /// `0x01` can always be provided if the signature does not need to be validated.

    /// @return The orderInfo (hash, status, and `takerAssetAmount` already filled for the given order),

    /// fillableTakerAssetAmount (amount of the order's `takerAssetAmount` that is fillable given all on-chain state),

    /// and isValidSignature (validity of the provided signature).

    /// NOTE: If the `takerAssetData` encodes data for multiple assets, `fillableTakerAssetAmount` will represent a "scaled"

    /// amount, meaning it must be multiplied by all the individual asset amounts within the `takerAssetData` to get the final

    /// amount of each asset that can be filled.

    function getOrderRelevantState(LibOrder.Order memory order, bytes memory signature)

        public

        view

        returns (

            LibOrder.OrderInfo memory orderInfo,

            uint256 fillableTakerAssetAmount,

            bool isValidSignature

        )

    {

        // Get info specific to order

        orderInfo = _EXCHANGE.getOrderInfo(order);



        // Validate the maker's signature

        address makerAddress = order.makerAddress;

        isValidSignature = _EXCHANGE.isValidSignature(

            orderInfo.orderHash,

            makerAddress,

            signature

        );



        // Get the transferable amount of the `makerAsset`

        uint256 transferableMakerAssetAmount = getTransferableAssetAmount(makerAddress, order.makerAssetData);



        // Assign to stack variables to reduce redundant mloads/sloads

        uint256 takerAssetAmount = order.takerAssetAmount;

        uint256 makerFee = order.makerFee;

        bytes memory zrxAssetData = _ZRX_ASSET_DATA;

    

        // Get the amount of `takerAsset` that is transferable to maker given the transferability of `makerAsset`, `makerFeeAsset`,

        // and the total amounts specified in the order

        uint256 transferableTakerAssetAmount;

        if (order.makerAssetData.equals(zrxAssetData)) {

            // If `makerAsset` equals `makerFeeAsset`, the % that can be filled is

            // transferableMakerAssetAmount / (makerAssetAmount + makerFee)

            transferableTakerAssetAmount = getPartialAmountFloor(

                transferableMakerAssetAmount,

                safeAdd(order.makerAssetAmount, makerFee),

                takerAssetAmount

            );

        } else {

            // Get the transferable amount of the `makerFeeAsset`

            uint256 transferableMakerFeeAssetAmount = getTransferableAssetAmount(makerAddress, zrxAssetData);



            // If `makerFee` is 0, the % that can be filled is (transferableMakerAssetAmount / makerAssetAmount)

            if (makerFee == 0) {

                transferableTakerAssetAmount = getPartialAmountFloor(

                    transferableMakerAssetAmount,

                    order.makerAssetAmount,

                    takerAssetAmount

                );



            // If `makerAsset` does not equal `makerFeeAsset`, the % that can be filled is the lower of

            // (transferableMakerAssetAmount / makerAssetAmount) and (transferableMakerAssetFeeAmount / makerFee)

            } else {

                uint256 transferableMakerToTakerAmount = getPartialAmountFloor(

                    transferableMakerAssetAmount,

                    order.makerAssetAmount,

                    takerAssetAmount

                );

                uint256 transferableMakerFeeToTakerAmount = getPartialAmountFloor(

                    transferableMakerFeeAssetAmount,

                    makerFee,

                    takerAssetAmount

                );

                transferableTakerAssetAmount = min256(transferableMakerToTakerAmount, transferableMakerFeeToTakerAmount);

            }

        }



        // `fillableTakerAssetAmount` is the lower of the order's remaining `takerAssetAmount` and the `transferableTakerAssetAmount`

        fillableTakerAssetAmount = min256(

            safeSub(takerAssetAmount, orderInfo.orderTakerAssetFilledAmount),

            transferableTakerAssetAmount

        );



        return (orderInfo, fillableTakerAssetAmount, isValidSignature);

    }



    /// @dev Fetches all order-relevant information needed to validate if the supplied orders are fillable.

    /// @param orders Array of order structures.

    /// @param signatures Array of signatures provided by makers that prove the authenticity of the orders.

    /// `0x01` can always be provided if a signature does not need to be validated.

    /// @return The ordersInfo (array of the hash, status, and `takerAssetAmount` already filled for each order),

    /// fillableTakerAssetAmounts (array of amounts for each order's `takerAssetAmount` that is fillable given all on-chain state),

    /// and isValidSignature (array containing the validity of each provided signature).

    /// NOTE: If the `takerAssetData` encodes data for multiple assets, each element of `fillableTakerAssetAmounts`

    /// will represent a "scaled" amount, meaning it must be multiplied by all the individual asset amounts within

    /// the `takerAssetData` to get the final amount of each asset that can be filled.

    function getOrderRelevantStates(LibOrder.Order[] memory orders, bytes[] memory signatures)

        public

        view

        returns (

            LibOrder.OrderInfo[] memory ordersInfo,

            uint256[] memory fillableTakerAssetAmounts,

            bool[] memory isValidSignature

        )

    {

        uint256 length = orders.length;

        ordersInfo = new LibOrder.OrderInfo[](length);

        fillableTakerAssetAmounts = new uint256[](length);

        isValidSignature = new bool[](length);



        for (uint256 i = 0; i != length; i++) {

            (ordersInfo[i], fillableTakerAssetAmounts[i], isValidSignature[i]) = getOrderRelevantState(

                orders[i],

                signatures[i]

            );

        }



        return (ordersInfo, fillableTakerAssetAmounts, isValidSignature);

    }



    /// @dev Gets the amount of an asset transferable by the owner.

    /// @param ownerAddress Address of the owner of the asset.

    /// @param assetData Description of tokens, per the AssetProxy contract specification.

    /// @return The amount of the asset tranferable by the owner.

    /// NOTE: If the `assetData` encodes data for multiple assets, the `transferableAssetAmount`

    /// will represent the amount of times the entire `assetData` can be transferred. To calculate

    /// the total individual transferable amounts, this scaled `transferableAmount` must be multiplied by 

    /// the individual asset amounts located within the `assetData`.

    function getTransferableAssetAmount(address ownerAddress, bytes memory assetData)

        public

        view

        returns (uint256 transferableAssetAmount)

    {

        (uint256 balance, uint256 allowance) = getBalanceAndAssetProxyAllowance(ownerAddress, assetData);

        transferableAssetAmount = min256(balance, allowance);

        return transferableAssetAmount;

    }

}



contract LibExchangeSelectors {



    // solhint-disable max-line-length

    // allowedValidators

    bytes4 constant internal ALLOWED_VALIDATORS_SELECTOR = 0x7b8e3514;

    bytes4 constant internal ALLOWED_VALIDATORS_SELECTOR_GENERATOR = bytes4(keccak256("allowedValidators(address,address)"));



    // assetProxies

    bytes4 constant internal ASSET_PROXIES_SELECTOR = 0x3fd3c997;

    bytes4 constant internal ASSET_PROXIES_SELECTOR_GENERATOR = bytes4(keccak256("assetProxies(bytes4)"));



    // batchCancelOrders

    bytes4 constant internal BATCH_CANCEL_ORDERS_SELECTOR = 0x4ac14782;

    bytes4 constant internal BATCH_CANCEL_ORDERS_SELECTOR_GENERATOR = bytes4(keccak256("batchCancelOrders((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes)[])"));



    // batchFillOrKillOrders

    bytes4 constant internal BATCH_FILL_OR_KILL_ORDERS_SELECTOR = 0x4d0ae546;

    bytes4 constant internal BATCH_FILL_OR_KILL_ORDERS_SELECTOR_GENERATOR = bytes4(keccak256("batchFillOrKillOrders((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes)[],uint256[],bytes[])"));



    // batchFillOrders

    bytes4 constant internal BATCH_FILL_ORDERS_SELECTOR = 0x297bb70b;

    bytes4 constant internal BATCH_FILL_ORDERS_SELECTOR_GENERATOR = bytes4(keccak256("batchFillOrders((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes)[],uint256[],bytes[])"));



    // batchFillOrdersNoThrow

    bytes4 constant internal BATCH_FILL_ORDERS_NO_THROW_SELECTOR = 0x50dde190;

    bytes4 constant internal BATCH_FILL_ORDERS_NO_THROW_SELECTOR_GENERATOR = bytes4(keccak256("batchFillOrdersNoThrow((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes)[],uint256[],bytes[])"));



    // cancelOrder

    bytes4 constant internal CANCEL_ORDER_SELECTOR = 0xd46b02c3;

    bytes4 constant internal CANCEL_ORDER_SELECTOR_GENERATOR = bytes4(keccak256("cancelOrder((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes))"));



    // cancelOrdersUpTo

    bytes4 constant internal CANCEL_ORDERS_UP_TO_SELECTOR = 0x4f9559b1;

    bytes4 constant internal CANCEL_ORDERS_UP_TO_SELECTOR_GENERATOR = bytes4(keccak256("cancelOrdersUpTo(uint256)"));



    // cancelled

    bytes4 constant internal CANCELLED_SELECTOR = 0x2ac12622;

    bytes4 constant internal CANCELLED_SELECTOR_GENERATOR = bytes4(keccak256("cancelled(bytes32)"));



    // currentContextAddress

    bytes4 constant internal CURRENT_CONTEXT_ADDRESS_SELECTOR = 0xeea086ba;

    bytes4 constant internal CURRENT_CONTEXT_ADDRESS_SELECTOR_GENERATOR = bytes4(keccak256("currentContextAddress()"));



    // executeTransaction

    bytes4 constant internal EXECUTE_TRANSACTION_SELECTOR = 0xbfc8bfce;

    bytes4 constant internal EXECUTE_TRANSACTION_SELECTOR_GENERATOR = bytes4(keccak256("executeTransaction(uint256,address,bytes,bytes)"));



    // fillOrKillOrder

    bytes4 constant internal FILL_OR_KILL_ORDER_SELECTOR = 0x64a3bc15;

    bytes4 constant internal FILL_OR_KILL_ORDER_SELECTOR_GENERATOR = bytes4(keccak256("fillOrKillOrder((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes),uint256,bytes)"));



    // fillOrder

    bytes4 constant internal FILL_ORDER_SELECTOR = 0xb4be83d5;

    bytes4 constant internal FILL_ORDER_SELECTOR_GENERATOR = bytes4(keccak256("fillOrder((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes),uint256,bytes)"));



    // fillOrderNoThrow

    bytes4 constant internal FILL_ORDER_NO_THROW_SELECTOR = 0x3e228bae;

    bytes4 constant internal FILL_ORDER_NO_THROW_SELECTOR_GENERATOR = bytes4(keccak256("fillOrderNoThrow((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes),uint256,bytes)"));



    // filled

    bytes4 constant internal FILLED_SELECTOR = 0x288cdc91;

    bytes4 constant internal FILLED_SELECTOR_GENERATOR = bytes4(keccak256("filled(bytes32)"));



    // getAssetProxy

    bytes4 constant internal GET_ASSET_PROXY_SELECTOR = 0x60704108;

    bytes4 constant internal GET_ASSET_PROXY_SELECTOR_GENERATOR = bytes4(keccak256("getAssetProxy(bytes4)"));



    // getOrderInfo

    bytes4 constant internal GET_ORDER_INFO_SELECTOR = 0xc75e0a81;

    bytes4 constant internal GET_ORDER_INFO_SELECTOR_GENERATOR = bytes4(keccak256("getOrderInfo((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes))"));



    // getOrdersInfo

    bytes4 constant internal GET_ORDERS_INFO_SELECTOR = 0x7e9d74dc;

    bytes4 constant internal GET_ORDERS_INFO_SELECTOR_GENERATOR = bytes4(keccak256("getOrdersInfo((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes)[])"));



    // isValidSignature

    bytes4 constant internal IS_VALID_SIGNATURE_SELECTOR = 0x93634702;

    bytes4 constant internal IS_VALID_SIGNATURE_SELECTOR_GENERATOR = bytes4(keccak256("isValidSignature(bytes32,address,bytes)"));



    // marketBuyOrders

    bytes4 constant internal MARKET_BUY_ORDERS_SELECTOR = 0xe5fa431b;

    bytes4 constant internal MARKET_BUY_ORDERS_SELECTOR_GENERATOR = bytes4(keccak256("marketBuyOrders((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes)[],uint256,bytes[])"));



    // marketBuyOrdersNoThrow

    bytes4 constant internal MARKET_BUY_ORDERS_NO_THROW_SELECTOR = 0xa3e20380;

    bytes4 constant internal MARKET_BUY_ORDERS_NO_THROW_SELECTOR_GENERATOR = bytes4(keccak256("marketBuyOrdersNoThrow((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes)[],uint256,bytes[])"));



    // marketSellOrders

    bytes4 constant internal MARKET_SELL_ORDERS_SELECTOR = 0x7e1d9808;

    bytes4 constant internal MARKET_SELL_ORDERS_SELECTOR_GENERATOR = bytes4(keccak256("marketSellOrders((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes)[],uint256,bytes[])"));



    // marketSellOrdersNoThrow

    bytes4 constant internal MARKET_SELL_ORDERS_NO_THROW_SELECTOR = 0xdd1c7d18;

    bytes4 constant internal MARKET_SELL_ORDERS_NO_THROW_SELECTOR_GENERATOR = bytes4(keccak256("marketSellOrdersNoThrow((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes)[],uint256,bytes[])"));



    // matchOrders

    bytes4 constant internal MATCH_ORDERS_SELECTOR = 0x3c28d861;

    bytes4 constant internal MATCH_ORDERS_SELECTOR_GENERATOR = bytes4(keccak256("matchOrders((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes),(address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes),bytes,bytes)"));



    // orderEpoch

    bytes4 constant internal ORDER_EPOCH_SELECTOR = 0xd9bfa73e;

    bytes4 constant internal ORDER_EPOCH_SELECTOR_GENERATOR = bytes4(keccak256("orderEpoch(address,address)"));



    // owner

    bytes4 constant internal OWNER_SELECTOR = 0x8da5cb5b;

    bytes4 constant internal OWNER_SELECTOR_GENERATOR = bytes4(keccak256("owner()"));



    // preSign

    bytes4 constant internal PRE_SIGN_SELECTOR = 0x3683ef8e;

    bytes4 constant internal PRE_SIGN_SELECTOR_GENERATOR = bytes4(keccak256("preSign(bytes32,address,bytes)"));



    // preSigned

    bytes4 constant internal PRE_SIGNED_SELECTOR = 0x82c174d0;

    bytes4 constant internal PRE_SIGNED_SELECTOR_GENERATOR = bytes4(keccak256("preSigned(bytes32,address)"));



    // registerAssetProxy

    bytes4 constant internal REGISTER_ASSET_PROXY_SELECTOR = 0xc585bb93;

    bytes4 constant internal REGISTER_ASSET_PROXY_SELECTOR_GENERATOR = bytes4(keccak256("registerAssetProxy(address)"));



    // setSignatureValidatorApproval

    bytes4 constant internal SET_SIGNATURE_VALIDATOR_APPROVAL_SELECTOR = 0x77fcce68;

    bytes4 constant internal SET_SIGNATURE_VALIDATOR_APPROVAL_SELECTOR_GENERATOR = bytes4(keccak256("setSignatureValidatorApproval(address,bool)"));



    // transactions

    bytes4 constant internal TRANSACTIONS_SELECTOR = 0x642f2eaf;

    bytes4 constant internal TRANSACTIONS_SELECTOR_GENERATOR = bytes4(keccak256("transactions(bytes32)"));



    // transferOwnership

    bytes4 constant internal TRANSFER_OWNERSHIP_SELECTOR = 0xf2fde38b;

    bytes4 constant internal TRANSFER_OWNERSHIP_SELECTOR_GENERATOR = bytes4(keccak256("transferOwnership(address)"));

}



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

        address makerAddress;           // Address that created the order.      

        address takerAddress;           // Address that is allowed to fill the order. If set to 0, any address is allowed to fill the order.          

        address feeRecipientAddress;    // Address that will recieve fees when order is filled.      

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





contract LibTransactionDecoder is

    LibExchangeSelectors

{

    using LibBytes for bytes;



    /// @dev Decodes the call data for an Exchange contract method call.

    /// @param transactionData ABI-encoded calldata for an Exchange

    ///     contract method call.

    /// @return The name of the function called, and the parameters it was

    ///     given.  For single-order fills and cancels, the arrays will have

    ///     just one element.

    function decodeZeroExTransactionData(bytes memory transactionData)

        public

        pure

        returns(

            string memory functionName,

            LibOrder.Order[] memory orders,

            uint256[] memory takerAssetFillAmounts,

            bytes[] memory signatures

        )

    {

        bytes4 functionSelector = transactionData.readBytes4(0);



        if (functionSelector == BATCH_CANCEL_ORDERS_SELECTOR) {

            functionName = "batchCancelOrders";

        } else if (functionSelector == BATCH_FILL_ORDERS_SELECTOR) {

            functionName = "batchFillOrders";

        } else if (functionSelector == BATCH_FILL_ORDERS_NO_THROW_SELECTOR) {

            functionName = "batchFillOrdersNoThrow";

        } else if (functionSelector == BATCH_FILL_OR_KILL_ORDERS_SELECTOR) {

            functionName = "batchFillOrKillOrders";

        } else if (functionSelector == CANCEL_ORDER_SELECTOR) {

            functionName = "cancelOrder";

        } else if (functionSelector == FILL_ORDER_SELECTOR) {

            functionName = "fillOrder";

        } else if (functionSelector == FILL_ORDER_NO_THROW_SELECTOR) {

            functionName = "fillOrderNoThrow";

        } else if (functionSelector == FILL_OR_KILL_ORDER_SELECTOR) {

            functionName = "fillOrKillOrder";

        } else if (functionSelector == MARKET_BUY_ORDERS_SELECTOR) {

            functionName = "marketBuyOrders";

        } else if (functionSelector == MARKET_BUY_ORDERS_NO_THROW_SELECTOR) {

            functionName = "marketBuyOrdersNoThrow";

        } else if (functionSelector == MARKET_SELL_ORDERS_SELECTOR) {

            functionName = "marketSellOrders";

        } else if (functionSelector == MARKET_SELL_ORDERS_NO_THROW_SELECTOR) {

            functionName = "marketSellOrdersNoThrow";

        } else if (functionSelector == MATCH_ORDERS_SELECTOR) {

            functionName = "matchOrders";

        } else if (

            functionSelector == CANCEL_ORDERS_UP_TO_SELECTOR ||

            functionSelector == EXECUTE_TRANSACTION_SELECTOR

            // TODO: add new noThrow cancel functions when https://github.com/0xProject/ZEIPs/issues/35 is merged.

        ) {

            revert("UNIMPLEMENTED");

        } else {

            revert("UNKNOWN_FUNCTION_SELECTOR");

        }



        if (functionSelector == BATCH_CANCEL_ORDERS_SELECTOR) {

            // solhint-disable-next-line indent

            orders = abi.decode(transactionData.slice(4, transactionData.length), (LibOrder.Order[]));

            takerAssetFillAmounts = new uint256[](0);

            signatures = new bytes[](0);

        } else if (

            functionSelector == BATCH_FILL_OR_KILL_ORDERS_SELECTOR ||

            functionSelector == BATCH_FILL_ORDERS_NO_THROW_SELECTOR ||

            functionSelector == BATCH_FILL_ORDERS_SELECTOR

        ) {

            (orders, takerAssetFillAmounts, signatures) = _makeReturnValuesForBatchFill(transactionData);

        } else if (functionSelector == CANCEL_ORDER_SELECTOR) {

            orders = new LibOrder.Order[](1);

            orders[0] = abi.decode(transactionData.slice(4, transactionData.length), (LibOrder.Order));

            takerAssetFillAmounts = new uint256[](0);

            signatures = new bytes[](0);

        } else if (

            functionSelector == FILL_OR_KILL_ORDER_SELECTOR ||

            functionSelector == FILL_ORDER_SELECTOR ||

            functionSelector == FILL_ORDER_NO_THROW_SELECTOR

        ) {

            (orders, takerAssetFillAmounts, signatures) = _makeReturnValuesForSingleOrderFill(transactionData);

        } else if (

            functionSelector == MARKET_BUY_ORDERS_SELECTOR ||

            functionSelector == MARKET_BUY_ORDERS_NO_THROW_SELECTOR ||

            functionSelector == MARKET_SELL_ORDERS_SELECTOR ||

            functionSelector == MARKET_SELL_ORDERS_NO_THROW_SELECTOR

        ) {

            (orders, takerAssetFillAmounts, signatures) = _makeReturnValuesForMarketFill(transactionData);

        } else if (functionSelector == MATCH_ORDERS_SELECTOR) {

            (

                LibOrder.Order memory leftOrder,

                LibOrder.Order memory rightOrder,

                bytes memory leftSignature,

                bytes memory rightSignature

            ) = abi.decode(

                transactionData.slice(4, transactionData.length),

                (LibOrder.Order, LibOrder.Order, bytes, bytes)

            );



            orders = new LibOrder.Order[](2);

            orders[0] = leftOrder;

            orders[1] = rightOrder;



            takerAssetFillAmounts = new uint256[](2);

            takerAssetFillAmounts[0] = leftOrder.takerAssetAmount;

            takerAssetFillAmounts[1] = rightOrder.takerAssetAmount;



            signatures = new bytes[](2);

            signatures[0] = leftSignature;

            signatures[1] = rightSignature;

        }

    }



    function _makeReturnValuesForSingleOrderFill(bytes memory transactionData)

        private

        pure

        returns(

            LibOrder.Order[] memory orders,

            uint256[] memory takerAssetFillAmounts,

            bytes[] memory signatures

        )

    {

        orders = new LibOrder.Order[](1);

        takerAssetFillAmounts = new uint256[](1);

        signatures = new bytes[](1);

        // solhint-disable-next-line indent

        (orders[0], takerAssetFillAmounts[0], signatures[0]) = abi.decode(

            transactionData.slice(4, transactionData.length),

            (LibOrder.Order, uint256, bytes)

        );

    }



    function _makeReturnValuesForBatchFill(bytes memory transactionData)

        private

        pure

        returns(

            LibOrder.Order[] memory orders,

            uint256[] memory takerAssetFillAmounts,

            bytes[] memory signatures

        )

    {

        // solhint-disable-next-line indent

        (orders, takerAssetFillAmounts, signatures) = abi.decode(

            transactionData.slice(4, transactionData.length),

            // solhint-disable-next-line indent

            (LibOrder.Order[], uint256[], bytes[])

        );

    }



    function _makeReturnValuesForMarketFill(bytes memory transactionData)

        private

        pure

        returns(

            LibOrder.Order[] memory orders,

            uint256[] memory takerAssetFillAmounts,

            bytes[] memory signatures

        )

    {

        takerAssetFillAmounts = new uint256[](1);

        // solhint-disable-next-line indent

        (orders, takerAssetFillAmounts[0], signatures) = abi.decode(

            transactionData.slice(4, transactionData.length),

            // solhint-disable-next-line indent

            (LibOrder.Order[], uint256, bytes[])

        );

    }

}



contract EthBalanceChecker {



    /// @dev Batch fetches ETH balances

    /// @param addresses Array of addresses.

    /// @return Array of ETH balances.

    function getEthBalances(address[] memory addresses)

        public

        view

        returns (uint256[] memory)

    {

        uint256[] memory balances = new uint256[](addresses.length);

        for (uint256 i = 0; i != addresses.length; i++) {

            balances[i] = addresses[i].balance;

        }

        return balances;

    }



}



// solhint-disable no-empty-blocks

contract DevUtils is

    OrderValidationUtils,

    LibTransactionDecoder,

    EthBalanceChecker

{

    constructor (address _exchange, bytes memory _zrxAssetData)

        public

        OrderValidationUtils(_exchange, _zrxAssetData)

    {}

}

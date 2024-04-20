/**



  Source code of Opium Protocol

  Web https://opium.network

  Telegram https://t.me/opium_network

  Twitter https://twitter.com/opium_network



 */



// File: LICENSE



/**



The software and documentation available in this repository (the "Software") is protected by copyright law and accessible pursuant to the license set forth below. Copyright \u00a9 2020 Blockeys BV. All rights reserved.



Permission is hereby granted, free of charge, to any person or organization obtaining the Software (the \u201cLicensee\u201d) to privately study, review, and analyze the Software. Licensee shall not use the Software for any other purpose. Licensee shall not modify, transfer, assign, share, or sub-license the Software or any derivative works of the Software.



THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/



// File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol



pragma solidity ^0.5.0;



/**

 * @dev Contract module that helps prevent reentrant calls to a function.

 *

 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier

 * available, which can be applied to functions to make sure there are no nested

 * (reentrant) calls to them.

 *

 * Note that because there is a single `nonReentrant` guard, functions marked as

 * `nonReentrant` may not call one another. This can be worked around by making

 * those functions `private`, and then adding `external` `nonReentrant` entry

 * points to them.

 */

contract ReentrancyGuard {

    // counter to allow mutex lock with only one SSTORE operation

    uint256 private _guardCounter;



    constructor () internal {

        // The counter starts at one to prevent changing it from zero to a non-zero

        // value, which is a more expensive operation.

        _guardCounter = 1;

    }



    /**

     * @dev Prevents a contract from calling itself, directly or indirectly.

     * Calling a `nonReentrant` function from another `nonReentrant`

     * function is not supported. It is possible to prevent this from happening

     * by making the `nonReentrant` function external, and make it call a

     * `private` function that does the actual work.

     */

    modifier nonReentrant() {

        _guardCounter += 1;

        uint256 localCounter = _guardCounter;

        _;

        require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");

    }

}



// File: contracts/Lib/LibDerivative.sol



pragma solidity 0.5.16;

pragma experimental ABIEncoderV2;



/// @title Opium.Lib.LibDerivative contract should be inherited by contracts that use Derivative structure and calculate derivativeHash

contract LibDerivative {

    // Opium derivative structure (ticker) definition

    struct Derivative {

        // Margin parameter for syntheticId

        uint256 margin;

        // Maturity of derivative

        uint256 endTime;

        // Additional parameters for syntheticId

        uint256[] params;

        // oracleId of derivative

        address oracleId;

        // Margin token address of derivative

        address token;

        // syntheticId of derivative

        address syntheticId;

    }



    /// @notice Calculates hash of provided Derivative

    /// @param _derivative Derivative Instance of derivative to hash

    /// @return derivativeHash bytes32 Derivative hash

    function getDerivativeHash(Derivative memory _derivative) public pure returns (bytes32 derivativeHash) {

        derivativeHash = keccak256(abi.encodePacked(

            _derivative.margin,

            _derivative.endTime,

            _derivative.params,

            _derivative.oracleId,

            _derivative.token,

            _derivative.syntheticId

        ));

    }

}



// File: contracts/Lib/LibCommission.sol



pragma solidity 0.5.16;



/// @title Opium.Lib.LibCommission contract defines constants for Opium commissions

contract LibCommission {

    // Represents 100% base for commissions calculation

    uint256 constant public COMMISSION_BASE = 10000;



    // Represents 100% base for Opium commission

    uint256 constant public OPIUM_COMMISSION_BASE = 10;



    // Represents which part of `syntheticId` author commissions goes to opium

    uint256 constant public OPIUM_COMMISSION_PART = 1;

}



// File: contracts/Errors/SyntheticAggregatorErrors.sol



pragma solidity 0.5.16;



contract SyntheticAggregatorErrors {

    string constant internal ERROR_SYNTHETIC_AGGREGATOR_DERIVATIVE_HASH_NOT_MATCH = "SYNTHETIC_AGGREGATOR:DERIVATIVE_HASH_NOT_MATCH";

    string constant internal ERROR_SYNTHETIC_AGGREGATOR_WRONG_MARGIN = "SYNTHETIC_AGGREGATOR:WRONG_MARGIN";

    string constant internal ERROR_SYNTHETIC_AGGREGATOR_COMMISSION_TOO_BIG = "SYNTHETIC_AGGREGATOR:COMMISSION_TOO_BIG";

}



// File: contracts/Interface/IOracleId.sol



pragma solidity 0.5.16;



/// @title Opium.Interface.IOracleId contract is an interface that every oracleId should implement

interface IOracleId {

    /// @notice Requests data from `oracleId` one time

    /// @param timestamp uint256 Timestamp at which data are needed

    function fetchData(uint256 timestamp) external payable;



    /// @notice Requests data from `oracleId` multiple times

    /// @param timestamp uint256 Timestamp at which data are needed for the first time

    /// @param period uint256 Period in seconds between multiple timestamps

    /// @param times uint256 How many timestamps are requested

    function recursivelyFetchData(uint256 timestamp, uint256 period, uint256 times) external payable;



    /// @notice Requests and returns price in ETH for one request. This function could be called as `view` function. Oraclize API for price calculations restricts making this function as view.

    /// @return fetchPrice uint256 Price of one data request in ETH

    function calculateFetchPrice() external returns (uint256 fetchPrice);



    // Event with oracleId metadata JSON string (for DIB.ONE derivative explorer)

    event MetadataSet(string metadata);

}



// File: contracts/Interface/IDerivativeLogic.sol



pragma solidity 0.5.16;





/// @title Opium.Interface.IDerivativeLogic contract is an interface that every syntheticId should implement

contract IDerivativeLogic is LibDerivative {

    /// @notice Validates ticker

    /// @param _derivative Derivative Instance of derivative to validate

    /// @return Returns boolean whether ticker is valid

    function validateInput(Derivative memory _derivative) public view returns (bool);



    /// @notice Calculates margin required for derivative creation

    /// @param _derivative Derivative Instance of derivative

    /// @return buyerMargin uint256 Margin needed from buyer (LONG position)

    /// @return sellerMargin uint256 Margin needed from seller (SHORT position)

    function getMargin(Derivative memory _derivative) public view returns (uint256 buyerMargin, uint256 sellerMargin);



    /// @notice Calculates payout for derivative execution

    /// @param _derivative Derivative Instance of derivative

    /// @param _result uint256 Data retrieved from oracleId on the maturity

    /// @return buyerPayout uint256 Payout in ratio for buyer (LONG position holder)

    /// @return sellerPayout uint256 Payout in ratio for seller (SHORT position holder)

    function getExecutionPayout(Derivative memory _derivative, uint256 _result)  public view returns (uint256 buyerPayout, uint256 sellerPayout);



    /// @notice Returns syntheticId author address for Opium commissions

    /// @return authorAddress address The address of syntheticId address

    function getAuthorAddress() public view returns (address authorAddress);



    /// @notice Returns syntheticId author commission in base of COMMISSION_BASE

    /// @return commission uint256 Author commission

    function getAuthorCommission() public view returns (uint256 commission);



    /// @notice Returns whether thirdparty could execute on derivative's owner's behalf

    /// @param _derivativeOwner address Derivative owner address

    /// @return Returns boolean whether _derivativeOwner allowed third party execution

    function thirdpartyExecutionAllowed(address _derivativeOwner) public view returns (bool);



    /// @notice Returns whether syntheticId implements pool logic

    /// @return Returns whether syntheticId implements pool logic

    function isPool() public view returns (bool);



    /// @notice Sets whether thirds parties are allowed or not to execute derivative's on msg.sender's behalf

    /// @param _allow bool Flag for execution allowance

    function allowThirdpartyExecution(bool _allow) public;



    // Event with syntheticId metadata JSON string (for DIB.ONE derivative explorer)

    event MetadataSet(string metadata);

}



// File: contracts/SyntheticAggregator.sol



pragma solidity 0.5.16;















/// @notice Opium.SyntheticAggregator contract initialized, identifies and caches syntheticId sensitive data

contract SyntheticAggregator is SyntheticAggregatorErrors, LibDerivative, LibCommission, ReentrancyGuard {

    // Emitted when new ticker is initialized

    event Create(Derivative derivative, bytes32 derivativeHash);



    // Enum for types of syntheticId

    // Invalid - syntheticId is not initialized yet

    // NotPool - syntheticId with p2p logic

    // Pool - syntheticId with pooled logic

    enum SyntheticTypes { Invalid, NotPool, Pool }



    // Cache of buyer margin by ticker

    // buyerMarginByHash[derivativeHash] = buyerMargin

    mapping (bytes32 => uint256) public buyerMarginByHash;



    // Cache of seller margin by ticker

    // sellerMarginByHash[derivativeHash] = sellerMargin

    mapping (bytes32 => uint256) public sellerMarginByHash;



    // Cache of type by ticker

    // typeByHash[derivativeHash] = type

    mapping (bytes32 => SyntheticTypes) public typeByHash;



    // Cache of commission by ticker

    // commissionByHash[derivativeHash] = commission

    mapping (bytes32 => uint256) public commissionByHash;



    // Cache of author addresses by ticker

    // authorAddressByHash[derivativeHash] = authorAddress

    mapping (bytes32 => address) public authorAddressByHash;



    // PUBLIC FUNCTIONS



    /// @notice Initializes ticker, if was not initialized and returns `syntheticId` author commission from cache

    /// @param _derivativeHash bytes32 Hash of derivative

    /// @param _derivative Derivative Derivative itself

    /// @return commission uint256 Synthetic author commission

    function getAuthorCommission(bytes32 _derivativeHash, Derivative memory _derivative) public nonReentrant returns (uint256 commission) {

        // Initialize derivative if wasn't initialized before

        _initDerivative(_derivativeHash, _derivative);

        commission = commissionByHash[_derivativeHash];

    }



    /// @notice Initializes ticker, if was not initialized and returns `syntheticId` author address from cache

    /// @param _derivativeHash bytes32 Hash of derivative

    /// @param _derivative Derivative Derivative itself

    /// @return authorAddress address Synthetic author address

    function getAuthorAddress(bytes32 _derivativeHash, Derivative memory _derivative) public nonReentrant returns (address authorAddress) {

        // Initialize derivative if wasn't initialized before

        _initDerivative(_derivativeHash, _derivative);

        authorAddress = authorAddressByHash[_derivativeHash];

    }



    /// @notice Initializes ticker, if was not initialized and returns buyer and seller margin from cache

    /// @param _derivativeHash bytes32 Hash of derivative

    /// @param _derivative Derivative Derivative itself

    /// @return buyerMargin uint256 Margin of buyer

    /// @return sellerMargin uint256 Margin of seller

    function getMargin(bytes32 _derivativeHash, Derivative memory _derivative) public nonReentrant returns (uint256 buyerMargin, uint256 sellerMargin) {

        // If it's a pool, just return margin from syntheticId contract

        if (_isPool(_derivativeHash, _derivative)) {

            return IDerivativeLogic(_derivative.syntheticId).getMargin(_derivative);

        }



        // Initialize derivative if wasn't initialized before

        _initDerivative(_derivativeHash, _derivative);



        // Check if margins for _derivativeHash were already cached

        buyerMargin = buyerMarginByHash[_derivativeHash];

        sellerMargin = sellerMarginByHash[_derivativeHash];

    }



    /// @notice Checks whether `syntheticId` implements pooled logic

    /// @param _derivativeHash bytes32 Hash of derivative

    /// @param _derivative Derivative Derivative itself

    /// @return result bool Returns whether synthetic implements pooled logic

    function isPool(bytes32 _derivativeHash, Derivative memory _derivative) public nonReentrant returns (bool result) {

        result = _isPool(_derivativeHash, _derivative);

    }



    // PRIVATE FUNCTIONS



    /// @notice Initializes ticker, if was not initialized and returns whether `syntheticId` implements pooled logic

    /// @param _derivativeHash bytes32 Hash of derivative

    /// @param _derivative Derivative Derivative itself

    /// @return result bool Returns whether synthetic implements pooled logic

    function _isPool(bytes32 _derivativeHash, Derivative memory _derivative) private returns (bool result) {

        // Initialize derivative if wasn't initialized before

        _initDerivative(_derivativeHash, _derivative);

        result = typeByHash[_derivativeHash] == SyntheticTypes.Pool;

    }



    /// @notice Initializes ticker: caches syntheticId type, margin, author address and commission

    /// @param _derivativeHash bytes32 Hash of derivative

    /// @param _derivative Derivative Derivative itself

    function _initDerivative(bytes32 _derivativeHash, Derivative memory _derivative) private {

        // Check if type for _derivativeHash was already cached

        SyntheticTypes syntheticType = typeByHash[_derivativeHash];



        // Type could not be Invalid, thus this condition says us that type was not cached before

        if (syntheticType != SyntheticTypes.Invalid) {

            return;

        }



        // For security reasons we calculate hash of provided _derivative

        bytes32 derivativeHash = getDerivativeHash(_derivative);

        require(derivativeHash == _derivativeHash, ERROR_SYNTHETIC_AGGREGATOR_DERIVATIVE_HASH_NOT_MATCH);



        // POOL

        // Get isPool from SyntheticId

        bool result = IDerivativeLogic(_derivative.syntheticId).isPool();

        // Cache type returned from synthetic

        typeByHash[derivativeHash] = result ? SyntheticTypes.Pool : SyntheticTypes.NotPool;



        // MARGIN

        // Get margin from SyntheticId

        (uint256 buyerMargin, uint256 sellerMargin) = IDerivativeLogic(_derivative.syntheticId).getMargin(_derivative);

        // We are not allowing both margins to be equal to 0

        require(buyerMargin != 0 || sellerMargin != 0, ERROR_SYNTHETIC_AGGREGATOR_WRONG_MARGIN);

        // Cache margins returned from synthetic

        buyerMarginByHash[derivativeHash] = buyerMargin;

        sellerMarginByHash[derivativeHash] = sellerMargin;



        // AUTHOR ADDRESS

        // Cache author address returned from synthetic

        authorAddressByHash[derivativeHash] = IDerivativeLogic(_derivative.syntheticId).getAuthorAddress();



        // AUTHOR COMMISSION

        // Get commission from syntheticId

        uint256 commission = IDerivativeLogic(_derivative.syntheticId).getAuthorCommission();

        // Check if commission is not set > 100%

        require(commission <= COMMISSION_BASE, ERROR_SYNTHETIC_AGGREGATOR_COMMISSION_TOO_BIG);

        // Cache commission

        commissionByHash[derivativeHash] = commission;



        // If we are here, this basically means this ticker was not used before, so we emit an event for Dapps developers about new ticker (derivative) and it's hash

        emit Create(_derivative, derivativeHash);

    }

}

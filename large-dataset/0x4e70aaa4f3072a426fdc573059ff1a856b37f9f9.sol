// File: contracts/util/DeployerRole.sol



pragma solidity 0.6.6;





abstract contract DeployerRole {

    address internal immutable _deployer;



    modifier onlyDeployer() {

        require(

            _isDeployer(msg.sender),

            "only deployer is allowed to call this function"

        );

        _;

    }



    constructor() public {

        _deployer = msg.sender;

    }



    function _isDeployer(address account) internal view returns (bool) {

        return account == _deployer;

    }

}



// File: @openzeppelin/contracts/math/SafeMath.sol



pragma solidity ^0.6.0;



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

     */

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b != 0, errorMessage);

        return a % b;

    }

}



// File: @openzeppelin/contracts/math/SignedSafeMath.sol



pragma solidity ^0.6.0;



/**

 * @title SignedSafeMath

 * @dev Signed math operations with safety checks that revert on error.

 */

library SignedSafeMath {

    int256 constant private _INT256_MIN = -2**255;



    /**

     * @dev Multiplies two signed integers, reverts on overflow.

     */

    function mul(int256 a, int256 b) internal pure returns (int256) {

        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the

        // benefit is lost if 'b' is also tested.

        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522

        if (a == 0) {

            return 0;

        }



        require(!(a == -1 && b == _INT256_MIN), "SignedSafeMath: multiplication overflow");



        int256 c = a * b;

        require(c / a == b, "SignedSafeMath: multiplication overflow");



        return c;

    }



    /**

     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.

     */

    function div(int256 a, int256 b) internal pure returns (int256) {

        require(b != 0, "SignedSafeMath: division by zero");

        require(!(b == -1 && a == _INT256_MIN), "SignedSafeMath: division overflow");



        int256 c = a / b;



        return c;

    }



    /**

     * @dev Subtracts two signed integers, reverts on overflow.

     */

    function sub(int256 a, int256 b) internal pure returns (int256) {

        int256 c = a - b;

        require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");



        return c;

    }



    /**

     * @dev Adds two signed integers, reverts on overflow.

     */

    function add(int256 a, int256 b) internal pure returns (int256) {

        int256 c = a + b;

        require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");



        return c;

    }

}



// File: @openzeppelin/contracts/utils/SafeCast.sol



pragma solidity ^0.6.0;





/**

 * @dev Wrappers over Solidity's uintXX casting operators with added overflow

 * checks.

 *

 * Downcasting from uint256 in Solidity does not revert on overflow. This can

 * easily result in undesired exploitation or bugs, since developers usually

 * assume that overflows raise errors. `SafeCast` restores this intuition by

 * reverting the transaction when such an operation overflows.

 *

 * Using this library instead of the unchecked operations eliminates an entire

 * class of bugs, so it's recommended to use it always.

 *

 * Can be combined with {SafeMath} to extend it to smaller types, by performing

 * all math on `uint256` and then downcasting.

 */

library SafeCast {



    /**

     * @dev Returns the downcasted uint128 from uint256, reverting on

     * overflow (when the input is greater than largest uint128).

     *

     * Counterpart to Solidity's `uint128` operator.

     *

     * Requirements:

     *

     * - input must fit into 128 bits

     */

    function toUint128(uint256 value) internal pure returns (uint128) {

        require(value < 2**128, "SafeCast: value doesn\\'t fit in 128 bits");

        return uint128(value);

    }



    /**

     * @dev Returns the downcasted uint64 from uint256, reverting on

     * overflow (when the input is greater than largest uint64).

     *

     * Counterpart to Solidity's `uint64` operator.

     *

     * Requirements:

     *

     * - input must fit into 64 bits

     */

    function toUint64(uint256 value) internal pure returns (uint64) {

        require(value < 2**64, "SafeCast: value doesn\\'t fit in 64 bits");

        return uint64(value);

    }



    /**

     * @dev Returns the downcasted uint32 from uint256, reverting on

     * overflow (when the input is greater than largest uint32).

     *

     * Counterpart to Solidity's `uint32` operator.

     *

     * Requirements:

     *

     * - input must fit into 32 bits

     */

    function toUint32(uint256 value) internal pure returns (uint32) {

        require(value < 2**32, "SafeCast: value doesn\\'t fit in 32 bits");

        return uint32(value);

    }



    /**

     * @dev Returns the downcasted uint16 from uint256, reverting on

     * overflow (when the input is greater than largest uint16).

     *

     * Counterpart to Solidity's `uint16` operator.

     *

     * Requirements:

     *

     * - input must fit into 16 bits

     */

    function toUint16(uint256 value) internal pure returns (uint16) {

        require(value < 2**16, "SafeCast: value doesn\\'t fit in 16 bits");

        return uint16(value);

    }



    /**

     * @dev Returns the downcasted uint8 from uint256, reverting on

     * overflow (when the input is greater than largest uint8).

     *

     * Counterpart to Solidity's `uint8` operator.

     *

     * Requirements:

     *

     * - input must fit into 8 bits.

     */

    function toUint8(uint256 value) internal pure returns (uint8) {

        require(value < 2**8, "SafeCast: value doesn\\'t fit in 8 bits");

        return uint8(value);

    }



    /**

     * @dev Converts a signed int256 into an unsigned uint256.

     *

     * Requirements:

     *

     * - input must be greater than or equal to 0.

     */

    function toUint256(int256 value) internal pure returns (uint256) {

        require(value >= 0, "SafeCast: value must be positive");

        return uint256(value);

    }



    /**

     * @dev Converts an unsigned uint256 into a signed int256.

     *

     * Requirements:

     *

     * - input must be less than or equal to maxInt256.

     */

    function toInt256(uint256 value) internal pure returns (int256) {

        require(value < 2**255, "SafeCast: value doesn't fit in an int256");

        return int256(value);

    }

}



// File: contracts/math/UseSafeMath.sol



pragma solidity ^0.6.0;











/**

 * @notice ((a - 1) / b) + 1 = (a + b -1) / b

 * for example a.add(10**18 -1).div(10**18) = a.sub(1).div(10**18) + 1

 */



library SafeMathDivRoundUp {

    using SafeMath for uint256;



    function divRoundUp(

        uint256 a,

        uint256 b,

        string memory errorMessage

    ) internal pure returns (uint256) {

        if (a == 0) {

            return 0;

        }

        require(b > 0, errorMessage);

        return ((a - 1) / b) + 1;

    }



    function divRoundUp(uint256 a, uint256 b) internal pure returns (uint256) {

        return divRoundUp(a, b, "SafeMathDivRoundUp: modulo by zero");

    }

}





/**

 * @title UseSafeMath

 * @dev One can use SafeMath for not only uint256 but also uin64 or uint16,

 * and also can use SafeCast for uint256.

 * For example:

 *   uint64 a = 1;

 *   uint64 b = 2;

 *   a = a.add(b).toUint64() // `a` become 3 as uint64

 * In additionally, one can use SignedSafeMath and SafeCast.toUint256(int256) for int256.

 * In the case of the operation to the uint64 value, one need to cast the value into int256 in

 * advance to use `sub` as SignedSafeMath.sub not SafeMath.sub.

 * For example:

 *   int256 a = 1;

 *   uint64 b = 2;

 *   int256 c = 3;

 *   a = a.add(int256(b).sub(c)); // `a` become 0 as int256

 *   b = a.toUint256().toUint64(); // `b` become 0 as uint64

 */

abstract contract UseSafeMath {

    using SafeMath for uint256;

    using SafeMathDivRoundUp for uint256;

    using SafeMath for uint64;

    using SafeMathDivRoundUp for uint64;

    using SafeMath for uint16;

    using SignedSafeMath for int256;

    using SafeCast for uint256;

    using SafeCast for int256;

}



// File: contracts/auction/AuctionSecret.sol



pragma solidity 0.6.6;





interface AuctionSecretInterface {

    function auctionSecret(

        bytes32 auctionID,

        bytes32 secret

    ) external returns (

        address sender,

        uint64 amount,

        uint64 IDOLamount

    );

}



abstract contract AuctionSecret is AuctionSecretInterface {

    /**

     * @param sender is the account who set this secret bid.

     * @param amount is target SBT amount.

     * @param IDOLamount is deposited iDOL amount attached to this secret bid.

     */

    struct Secret {

        address sender;

        uint64 amount;

        uint64 IDOLamount;

    }

    mapping(bytes32 => mapping(bytes32 => Secret)) public override auctionSecret;



    function _setSecret(

        bytes32 auctionID,

        bytes32 secret,

        address sender,

        uint64 amount,

        uint64 IDOLamount

    ) internal returns (bool) {

        require(

            auctionSecret[auctionID][secret].sender == address(0),

            "Secret already exists"

        );

        require(sender != address(0), "the zero address cannot set secret");

        auctionSecret[auctionID][secret] = Secret({

            sender: sender,

            amount: amount,

            IDOLamount: IDOLamount

        });

        return true;

    }



    function _removeSecret(bytes32 auctionID, bytes32 secret)

        internal

        returns (bool)

    {

        delete auctionSecret[auctionID][secret];

        return true;

    }

}



// File: contracts/AuctionBoardInterface.sol



pragma solidity 0.6.6;







interface AuctionBoardInterface is AuctionSecretInterface {

    event LogBidMemo(

        bytes32 indexed auctionID,

        address indexed bidder,

        bytes memo

    );



    event LogInsertBoard(

        bytes32 indexed auctionID,

        address indexed bidder,

        uint64 bidPrice,

        uint64 boardIndex,

        uint64 targetSBTAmount

    );



    event LogAuctionInfoDiff(

        bytes32 indexed auctionID,

        uint64 settledAmount,

        uint64 paidIDOL,

        uint64 rewardedSBT

    );



    function auctionRevealInfo(

        bytes32 auctionID

    ) external view returns (

        uint64 totalSBTAmountBid,

        uint64 totalIDOLSecret,

        uint64 totalIDOLRevealed,

        uint16 auctionPriceCount

    );



    function auctionParticipantInfo(

        bytes32 auctionID,

        address participant

    ) external view returns (

        uint64 auctionLockedIDOLAmountE8,

        uint16 bidCount

    );



    function auctionDisposalInfo(

        bytes32 auctionID

    ) external view returns (

        uint64 solidStrikePriceIDOLForUnrevealedE8,

        uint64 solidStrikePriceIDOLForRestWinnersE8,

        bool isEndInfoCreated,

        bool isForceToFinalizeWinnerAmountTriggered,

        bool isPriceSorted

    );



    function auctionInfo(

        bytes32 auctionID

    ) external view returns (

        uint64 auctionSettledTotalE8,

        uint64 auctionRewardedTotalE8,

        uint64 auctionPaidTotalE8

    );



    function bidWithMemo(

        bytes32 auctionID,

        bytes32 secret,

        uint64 totalSBTAmountBid,

        bytes calldata memo

    ) external;



    function revealBids(

        bytes32 auctionID,

        uint64[] calldata bids,

        uint64 random

    ) external;



    function sortBidPrice(bytes32 auctionID, uint64[] calldata sortedPrice)

        external;



    function makeEndInfo(bytes32 auctionID) external;



    function removeSecret(

        bytes32 auctionID,

        bytes32 secret,

        uint64 subtractAmount

    ) external;



    function deleteParticipantInfo(bytes32 auctionID, address participant) external;



    function updateAuctionInfo(

        bytes32 auctionID,

        uint64 settledAmountE8,

        uint64 paidIDOLE8,

        uint64 rewardedSBTE8

    ) external;



    function calcBill(

        bytes32 auctionID,

        uint64 winnerAmount,

        uint64 myLowestPrice

    ) external view returns (uint64 paymentAmount);



    function getUnsortedBidPrice(bytes32 auctionID)

        external

        view

        returns (uint64[] memory bidPriceList);



    function getSortedBidPrice(bytes32 auctionID)

        external

        view

        returns (uint64[] memory bidPriceList);



    function auctionBoard(

        bytes32 auctionID,

        uint64 bidPrice,

        uint256 boardIndex

    ) external view returns (uint64 amount, address bidder);



    function getEndInfo(bytes32 auctionID)

        external

        view

        returns (

            uint64 price,

            uint64 boardIndex,

            uint64 loseSBTAmount,

            uint64 auctionEndPriceWinnerSBTAmount

        );



    function getBidderStatus(bytes32 auctionID, address bidder)

        external

        view

        returns (uint64 toBack, bool isIDOLReturned);



    function getBoard(

        bytes32 auctionID,

        uint64 price,

        uint64 boardIndex

    ) external view returns (address bidder, uint64 amount);



    function getBoardStatus(bytes32 auctionID)

        external

        view

        returns (uint64[] memory boardStatus);



    function generateMultiSecret(

        bytes32 auctionID,

        uint64[] calldata bids,

        uint64 random

    ) external pure returns (bytes32 secret);



    function discretizeBidPrice(uint64 price)

        external

        pure

        returns (uint64 discretizedPrice);

}



// File: contracts/AuctionTimeControlInterface.sol



pragma solidity 0.6.6;





interface AuctionTimeControlInterface {

    enum TimeControlFlag {

        BEFORE_AUCTION_FLAG,

        ACCEPTING_BIDS_PERIOD_FLAG,

        REVEALING_BIDS_PERIOD_FLAG,

        RECEIVING_SBT_PERIOD_FLAG,

        AFTER_AUCTION_FLAG

    }



    function listAuction(uint256 timestamp)

        external

        view

        returns (bytes32[] memory);



    function getTimeControlFlag(bytes32 auctionID)

        external

        view

        returns (TimeControlFlag);



    function isInPeriod(bytes32 auctionID, TimeControlFlag flag)

        external

        view

        returns (bool);



    function isAfterPeriod(bytes32 auctionID, TimeControlFlag flag)

        external

        view

        returns (bool);

}



// File: @openzeppelin/contracts/math/Math.sol



pragma solidity ^0.6.0;



/**

 * @dev Standard math utilities missing in the Solidity language.

 */

library Math {

    /**

     * @dev Returns the largest of two numbers.

     */

    function max(uint256 a, uint256 b) internal pure returns (uint256) {

        return a >= b ? a : b;

    }



    /**

     * @dev Returns the smallest of two numbers.

     */

    function min(uint256 a, uint256 b) internal pure returns (uint256) {

        return a < b ? a : b;

    }



    /**

     * @dev Returns the average of two numbers. The result is rounded towards

     * zero.

     */

    function average(uint256 a, uint256 b) internal pure returns (uint256) {

        // (a + b) / 2 can overflow, so we distribute

        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);

    }

}



// File: contracts/AuctionInterface.sol



pragma solidity 0.6.6;







interface AuctionInterface is AuctionTimeControlInterface {

    event LogStartAuction(bytes32 indexed auctionID, bytes32 bondID);



    event LogCancelBid(

        bytes32 indexed auctionID,

        address indexed bidder,

        bytes32 secret,

        uint256 returnedIDOLAmount

    );



    event LogAuctionResult(

        bytes32 indexed auctionID,

        address indexed bidder,

        uint256 SBTAmountOfReward,

        uint256 IDOLAmountOfPayment,

        uint256 IDOLAmountOfChange

    );



    event LogCloseAuction(

        bytes32 indexed auctionID,

        bool isLast,

        bytes32 nextAuctionID

    );



    function ongoingAuctionSBTTotal(bytes32 auctionID)

        external

        view

        returns (uint64 ongoingSBTAmountE8);



    function startAuction(

        bytes32 bondID,

        uint64 auctionAmount,

        bool isEmergency

    ) external returns (bytes32 auctonID);



    function cancelBid(bytes32 auctionID, bytes32 secret)

        external

        returns (uint64 returnedIDOLAmount);



    function makeAuctionResult(

        bytes32 auctionID,

        uint64 myLowestPrice,

        uint64[] calldata winnerBids,

        uint64[] calldata loserBids

    )

        external

        returns (

            uint64 winnerAmount,

            uint64 toPay,

            uint64 IDOLAmountOfChange

        );



    function closeAuction(bytes32 auctionID)

        external

        returns (bool isLast, bytes32 nextAuctionID);



    function receiveUnrevealedBidDistribution(bytes32 auctionID, bytes32 secret)

        external

        returns (bool success);



    function getCurrentAuctionID(bytes32 bondID)

        external

        view

        returns (bytes32 auctionID);



    function generateAuctionID(bytes32 bondID, uint256 auctionCount)

        external

        pure

        returns (bytes32 auctionID);



    function listBondIDFromAuctionID(bytes32[] calldata auctionIDs)

        external

        view

        returns (bytes32[] memory bondIDs);



    function getAuctionStatus(bytes32 auctionID)

        external

        view

        returns (

            uint256 closingTime,

            uint64 auctionAmount,

            uint64 rewardedAmount,

            uint64 totalSBTAmountBid,

            bool isEmergency,

            bool doneFinalizeWinnerAmount,

            bool doneSortPrice,

            uint64 lowestBidPriceDeadLine,

            uint64 highestBidPriceDeadLine,

            uint64 totalSBTAmountPaidForUnrevealed

        );



    function getWeeklyAuctionStatus(uint256 weekNumber)

        external

        view

        returns (uint256[] memory weeklyAuctionStatus);



    function calcWinnerAmount(

        bytes32 auctionID,

        address sender,

        uint64[] calldata winnerBids

    ) external view returns (uint64 winnerAmount);



    function calcBillAndCheckLoserBids(

        bytes32 auctionID,

        address sender,

        uint64 winnerAmountInput,

        uint64 myLowestPrice,

        uint64[] calldata myLoseBids

    ) external view returns (uint64 paymentAmount);



    function getAuctionCount(bytes32 bondID)

        external

        view

        returns (uint256 auctionCount);

}



// File: contracts/util/Time.sol



pragma solidity 0.6.6;





abstract contract Time {

    function _getBlockTimestampSec()

        internal

        view

        returns (uint256 unixtimesec)

    {

        unixtimesec = now; // solium-disable-line security/no-block-members

    }

}



// File: contracts/AuctionTimeControl.sol



pragma solidity 0.6.6;









contract AuctionTimeControl is Time, AuctionTimeControlInterface {

    uint256 internal immutable MIN_NORMAL_AUCTION_PERIOD;

    uint256 internal immutable MIN_EMERGENCY_AUCTION_PERIOD;

    uint256 internal immutable NORMAL_AUCTION_REVEAL_SPAN;

    uint256 internal immutable EMERGENCY_AUCTION_REVEAL_SPAN;

    uint256 internal immutable AUCTION_WITHDRAW_SPAN;

    uint256 internal immutable EMERGENCY_AUCTION_WITHDRAW_SPAN;



    TimeControlFlag internal constant BEFORE_AUCTION_FLAG = TimeControlFlag

        .BEFORE_AUCTION_FLAG;

    TimeControlFlag internal constant ACCEPTING_BIDS_PERIOD_FLAG = TimeControlFlag

        .ACCEPTING_BIDS_PERIOD_FLAG;

    TimeControlFlag internal constant REVEALING_BIDS_PERIOD_FLAG = TimeControlFlag

        .REVEALING_BIDS_PERIOD_FLAG;

    TimeControlFlag internal constant RECEIVING_SBT_PERIOD_FLAG = TimeControlFlag

        .RECEIVING_SBT_PERIOD_FLAG;

    TimeControlFlag internal constant AFTER_AUCTION_FLAG = TimeControlFlag

        .AFTER_AUCTION_FLAG;



    /**

     * @dev Get whether the auction is in emergency or not.

     */

    mapping(bytes32 => bool) public isAuctionEmergency;



    /**

     * @dev The end time that the auction accepts bids.

     * The zero value indicates the auction is not held.

     */

    mapping(bytes32 => uint256) public auctionClosingTime;



    /**

     * @dev The contents in this internal storage variable can be seen by listAuction function.

     */

    mapping(uint256 => bytes32[]) internal _weeklyAuctionList;



    constructor(

        uint256 minNormalAuctionPeriod,

        uint256 minEmergencyAuctionPeriod,

        uint256 normalAuctionRevealSpan,

        uint256 emergencyAuctionRevealSpan,

        uint256 auctionWithdrawSpan,

        uint256 emergencyAuctionWithdrawSpan

    ) public {

        MIN_NORMAL_AUCTION_PERIOD = minNormalAuctionPeriod;

        MIN_EMERGENCY_AUCTION_PERIOD = minEmergencyAuctionPeriod;

        NORMAL_AUCTION_REVEAL_SPAN = normalAuctionRevealSpan;

        EMERGENCY_AUCTION_REVEAL_SPAN = emergencyAuctionRevealSpan;

        AUCTION_WITHDRAW_SPAN = auctionWithdrawSpan;

        EMERGENCY_AUCTION_WITHDRAW_SPAN = emergencyAuctionWithdrawSpan;

    }



    /**

     * @dev Get auctions which will close within the week.

     */

    function listAuction(uint256 weekNumber)

        public

        override

        view

        returns (bytes32[] memory)

    {

        return _weeklyAuctionList[weekNumber];

    }



    /**

     * @notice Gets the period the auction is currently in.

     * This function returns 0-4 corresponding to its period.

     */

    function getTimeControlFlag(bytes32 auctionID)

        public

        override

        view

        returns (TimeControlFlag)

    {

        uint256 closingTime = auctionClosingTime[auctionID];



        // Note that the auction span differs based on whether the auction is in emergency or not.

        bool isEmergency = isAuctionEmergency[auctionID];

        uint256 revealSpan = NORMAL_AUCTION_REVEAL_SPAN;

        uint256 withdrawSpan = AUCTION_WITHDRAW_SPAN;

        if (isEmergency) {

            revealSpan = EMERGENCY_AUCTION_REVEAL_SPAN;

            withdrawSpan = EMERGENCY_AUCTION_WITHDRAW_SPAN;

        }



        uint256 nowTime = _getBlockTimestampSec();

        if (closingTime == 0) {

            return BEFORE_AUCTION_FLAG;

        } else if (nowTime <= closingTime) {

            return ACCEPTING_BIDS_PERIOD_FLAG;

        } else if (nowTime < closingTime + revealSpan) {

            return REVEALING_BIDS_PERIOD_FLAG;

        } else if (nowTime < closingTime + revealSpan + withdrawSpan) {

            return RECEIVING_SBT_PERIOD_FLAG;

        } else {

            return AFTER_AUCTION_FLAG;

        }

    }



    /**

     * @notice This function returns whether or not the auction is in the period indicated

     * by the flag.

     */

    function isInPeriod(bytes32 auctionID, TimeControlFlag flag)

        public

        override

        view

        returns (bool)

    {

        return getTimeControlFlag(auctionID) == flag;

    }



    /**

     * @notice Returns whether or not the auction is in or after the period indicated

     * by the flag.

     */

    function isAfterPeriod(bytes32 auctionID, TimeControlFlag flag)

        public

        override

        view

        returns (bool)

    {

        return getTimeControlFlag(auctionID) >= flag;

    }



    /**

     * @dev Calculates and registers the end time of the period in which the auction accepts bids

     * (= closingTime). The period in which bids are revealed follows after this time.

     */

    function _setAuctionClosingTime(bytes32 auctionID, bool isEmergency)

        internal

    {

        uint256 closingTime;



        if (isEmergency) {

            closingTime =

                ((_getBlockTimestampSec() +

                    MIN_EMERGENCY_AUCTION_PERIOD +

                    5 minutes -

                    1) / 5 minutes) *

                (5 minutes);

        } else {

            closingTime =

                ((_getBlockTimestampSec() +

                    MIN_NORMAL_AUCTION_PERIOD +

                    1 hours -

                    1) / 1 hours) *

                (1 hours);

        }

        _setAuctionClosingTime(auctionID, isEmergency, closingTime);

    }



    /**

     * @dev Registers the end time of the period in which the auction accepts bids (= closingTime).

     * The period in which bids are revealed follows after this time.

     */

    function _setAuctionClosingTime(

        bytes32 auctionID,

        bool isEmergency,

        uint256 closingTime

    ) internal {

        isAuctionEmergency[auctionID] = isEmergency;

        auctionClosingTime[auctionID] = closingTime;

        uint256 weekNumber = closingTime / (1 weeks);

        _weeklyAuctionList[weekNumber].push(auctionID);

    }

}



// File: contracts/BondMakerInterface.sol



pragma solidity 0.6.6;





interface BondMakerInterface {

    event LogNewBond(

        bytes32 indexed bondID,

        address bondTokenAddress,

        uint64 stableStrikePrice,

        bytes32 fnMapID

    );



    event LogNewBondGroup(uint256 indexed bondGroupID);



    event LogIssueNewBonds(

        uint256 indexed bondGroupID,

        address indexed issuer,

        uint256 amount

    );



    event LogReverseBondToETH(

        uint256 indexed bondGroupID,

        address indexed owner,

        uint256 amount

    );



    event LogExchangeEquivalentBonds(

        address indexed owner,

        uint256 indexed inputBondGroupID,

        uint256 indexed outputBondGroupID,

        uint256 amount

    );



    event LogTransferETH(

        address indexed from,

        address indexed to,

        uint256 value

    );



    function registerNewBond(uint256 maturity, bytes calldata fnMap)

        external

        returns (

            bytes32 bondID,

            address bondTokenAddress,

            uint64 solidStrikePrice,

            bytes32 fnMapID

        );



    function registerNewBondGroup(

        bytes32[] calldata bondIDList,

        uint256 maturity

    ) external returns (uint256 bondGroupID);



    function issueNewBonds(uint256 bondGroupID)

        external

        payable

        returns (uint256 amount);



    function reverseBondToETH(uint256 bondGroupID, uint256 amount)

        external

        returns (bool success);



    function exchangeEquivalentBonds(

        uint256 inputBondGroupID,

        uint256 outputBondGroupID,

        uint256 amount,

        bytes32[] calldata exceptionBonds

    ) external returns (bool);



    function liquidateBond(uint256 bondGroupID, uint256 oracleHintID) external;



    function getBond(bytes32 bondID)

        external

        view

        returns (

            address bondAddress,

            uint256 maturity,

            uint64 solidStrikePrice,

            bytes32 fnMapID

        );



    function getFnMap(bytes32 fnMapID)

        external

        view

        returns (bytes memory fnMap);



    function getBondGroup(uint256 bondGroupID)

        external

        view

        returns (bytes32[] memory bondIDs, uint256 maturity);



    function generateBondID(uint256 maturity, bytes calldata functionHash)

        external

        pure

        returns (bytes32 bondID);

}



// File: contracts/UseBondMaker.sol



pragma solidity 0.6.6;







abstract contract UseBondMaker {

    BondMakerInterface internal immutable _bondMakerContract;



    constructor(address contractAddress) public {

        require(

            contractAddress != address(0),

            "contract should be non-zero address"

        );

        _bondMakerContract = BondMakerInterface(payable(contractAddress));

    }

}



// File: @openzeppelin/contracts/token/ERC20/IERC20.sol



pragma solidity ^0.6.0;



/**

 * @dev Interface of the ERC20 standard as defined in the EIP.

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



// File: contracts/StableCoinInterface.sol



pragma solidity 0.6.6;







interface StableCoinInterface is IERC20 {

    event LogIsAcceptableSBT(bytes32 indexed bondID, bool isAcceptable);



    event LogMintIDOL(

        bytes32 indexed bondID,

        address indexed owner,

        bytes32 poolID,

        uint256 obtainIDOLAmount,

        uint256 poolIDOLAmount

    );



    event LogBurnIDOL(

        bytes32 indexed bondID, // poolID?

        address indexed owner,

        uint256 burnIDOLAmount,

        uint256 unlockSBTAmount

    );



    event LogReturnLockedPool(

        bytes32 indexed poolID,

        address indexed owner,

        uint64 backIDOLAmount

    );



    event LogLambda(

        bytes32 indexed poolID,

        uint64 settledAverageAuctionPrice,

        uint256 totalSupply,

        uint256 lockedSBTValue

    );



    function getPoolInfo(bytes32 poolID)

        external

        view

        returns (

            uint64 lockedSBTTotal,

            uint64 unlockedSBTTotal,

            uint64 lockedPoolIDOLTotal,

            uint64 burnedIDOLTotal,

            uint64 soldSBTTotalInAuction,

            uint64 paidIDOLTotalInAuction,

            uint64 settledAverageAuctionPrice,

            bool isAllAmountSoldInAuction

        );



    function solidValueTotal() external view returns (uint256 solidValue);



    function isAcceptableSBT(bytes32 bondID) external returns (bool ok);



    function mint(

        bytes32 bondID,

        address recipient,

        uint64 lockAmount

    )

        external

        returns (

            bytes32 poolID,

            uint64 obtainIDOLAmount,

            uint64 poolIDOLAmount

        );



    function burnFrom(address account, uint256 amount) external;



    function unlockSBT(bytes32 bondID, uint64 burnAmount)

        external

        returns (uint64 rewardSBT);



    function startAuctionOnMaturity(bytes32 bondID) external;



    function startAuctionByMarket(bytes32 bondID) external;



    function setSettledAverageAuctionPrice(

        bytes32 bondID,

        uint64 totalPaidIDOL,

        uint64 SBTAmount,

        bool isLast

    ) external;



    function calcSBT2IDOL(uint256 solidBondAmount)

        external

        view

        returns (uint256 IDOLAmount);



    function returnLockedPool(bytes32[] calldata poolIDs)

        external

        returns (uint64 IDOLAmount);



    function generatePoolID(bytes32 bondID, uint64 count)

        external

        pure

        returns (bytes32 poolID);



    function getCurrentPoolID(bytes32 bondID)

        external

        view

        returns (bytes32 poolID);



    function getLockedPool(address user, bytes32 poolID)

        external

        view

        returns (uint64, uint64);

}



// File: contracts/UseStableCoin.sol



pragma solidity 0.6.6;







abstract contract UseStableCoin {

    StableCoinInterface internal immutable _IDOLContract;



    constructor(address contractAddress) public {

        require(

            contractAddress != address(0),

            "contract should be non-zero address"

        );

        _IDOLContract = StableCoinInterface(contractAddress);

    }



    function _transferIDOLFrom(

        address from,

        address to,

        uint256 amount

    ) internal {

        _IDOLContract.transferFrom(from, to, amount);

    }



    function _transferIDOL(address to, uint256 amount) internal {

        _IDOLContract.transfer(to, amount);

    }



    function _transferIDOL(

        address to,

        uint256 amount,

        string memory errorMessage

    ) internal {

        require(_IDOLContract.balanceOf(address(this)) >= amount, errorMessage);

        _IDOLContract.transfer(to, amount);

    }

}



// File: contracts/UseAuctionBoard.sol



pragma solidity 0.6.6;







abstract contract UseAuctionBoard {

    AuctionBoardInterface internal immutable _auctionBoardContract;



    constructor(address contractAddress) public {

        require(

            contractAddress != address(0),

            "contract should be non-zero address"

        );

        _auctionBoardContract = AuctionBoardInterface(contractAddress);

    }

}



// File: contracts/oracle/OracleInterface.sol



pragma solidity ^0.6.6;





// Oracle referenced by OracleProxy must implement this interface.

interface OracleInterface {

    // Returns if oracle is running.

    function alive() external view returns (bool);



    // Returns latest id.

    // The first id is 1 and 0 value is invalid as id.

    // Each price values and theirs timestamps are identified by id.

    // Ids are assigned incrementally to values.

    function latestId() external returns (uint256);



    // Returns latest price value.

    // decimal 8

    function latestPrice() external returns (uint256);



    // Returns timestamp of latest price.

    function latestTimestamp() external returns (uint256);



    // Returns price of id.

    function getPrice(uint256 id) external returns (uint256);



    // Returns timestamp of id.

    function getTimestamp(uint256 id) external returns (uint256);



    function getVolatility() external returns (uint256);

}



// File: contracts/oracle/UseOracle.sol



pragma solidity 0.6.6;







abstract contract UseOracle {

    OracleInterface internal _oracleContract;



    constructor(address contractAddress) public {

        require(

            contractAddress != address(0),

            "contract should be non-zero address"

        );

        _oracleContract = OracleInterface(contractAddress);

    }



    /// @notice Get the latest USD/ETH price and historical volatility using oracle.

    /// @return rateETH2USDE8 (10^-8 USD/ETH)

    /// @return volatilityE8 (10^-8)

    function _getOracleData()

        internal

        returns (uint256 rateETH2USDE8, uint256 volatilityE8)

    {

        rateETH2USDE8 = _oracleContract.latestPrice();

        volatilityE8 = _oracleContract.getVolatility();



        return (rateETH2USDE8, volatilityE8);

    }



    /// @notice Get the price of the oracle data with a minimum timestamp that does more than input value

    /// when you know the ID you are looking for.

    /// @param timestamp is the timestamp that you want to get price.

    /// @param hintID is the ID of the oracle data you are looking for.

    /// @return rateETH2USDE8 (10^-8 USD/ETH)

    function _getPriceOn(uint256 timestamp, uint256 hintID)

        internal

        returns (uint256 rateETH2USDE8)

    {

        uint256 latestID = _oracleContract.latestId();

        require(

            latestID != 0,

            "system error: the ID of oracle data should not be zero"

        );



        require(hintID != 0, "the hint ID must not be zero");

        uint256 id = hintID;

        if (hintID > latestID) {

            id = latestID;

        }



        require(

            _oracleContract.getTimestamp(id) > timestamp,

            "there is no price data after maturity"

        );



        id--;

        while (id != 0) {

            if (_oracleContract.getTimestamp(id) <= timestamp) {

                break;

            }

            id--;

        }



        return _oracleContract.getPrice(id + 1);

    }

}



// File: contracts/util/TransferETHInterface.sol



pragma solidity 0.6.6;





interface TransferETHInterface {

    receive() external payable;



    event LogTransferETH(

        address indexed from,

        address indexed to,

        uint256 value

    );

}



// File: contracts/bondToken/BondTokenInterface.sol



pragma solidity 0.6.6;









interface BondTokenInterface is TransferETHInterface, IERC20 {

    event LogExpire(

        uint128 rateNumerator,

        uint128 rateDenominator,

        bool firstTime

    );



    function mint(address account, uint256 amount)

        external

        returns (bool success);



    function expire(uint128 rateNumerator, uint128 rateDenominator)

        external

        returns (bool firstTime);



    function burn(uint256 amount) external returns (bool success);



    function burnAll() external returns (uint256 amount);



    function isMinter(address account) external view returns (bool minter);



    function getRate()

        external

        view

        returns (uint128 rateNumerator, uint128 rateDenominator);

}



// File: contracts/Auction.sol



pragma solidity 0.6.6;























contract Auction is

    UseSafeMath,

    AuctionInterface,

    AuctionTimeControl,

    UseStableCoin,

    UseBondMaker,

    UseAuctionBoard

{

    using Math for uint256;



    uint64 internal constant NO_SKIP_BID = uint64(-1);

    uint64 internal constant SKIP_RECEIVING_WIN_BIDS = uint64(-2);

    uint256 internal constant POOL_AUCTION_COUNT_PADDING = 10**8;



    /**

     * @notice The times of auctions held for the auction ID.

     * @dev The contents in this internal storage variable can be seen by getAuctionCount function.

     */

    mapping(bytes32 => uint256) internal _bondIDAuctionCount;



    /**

     * @notice Get the bond ID from the auction ID.

     */

    mapping(bytes32 => bytes32) public auctionID2BondID;



    /**

     * @dev The contents in this internal storage variable can be seen by getAuctionStatus function.

     * @param ongoingAuctionSBTTotalE8 is the SBT amount put up in the auction.

     * @param lowestBidPriceDeadLineE8 is the minimum bid price in the auction.

     * @param highestBidPriceDeadLineE8 is the maximum bid price in the auction.

     * @param totalSBTAmountPaidForUnrevealedE8 is the SBT Amount allocated for those who had not revealed their own bid.

     */

    struct AuctionConfig {

        uint64 ongoingAuctionSBTTotalE8;

        uint64 lowestBidPriceDeadLineE8;

        uint64 highestBidPriceDeadLineE8;

        uint64 totalSBTAmountPaidForUnrevealedE8;

    }

    mapping(bytes32 => AuctionConfig) internal _auctionConfigList;



    constructor(

        address bondMakerAddress,

        address IDOLAddress,

        address auctionBoardAddress,

        uint256 minNormalAuctionPeriod,

        uint256 minEmergencyAuctionPeriod,

        uint256 normalAuctionRevealSpan,

        uint256 emergencyAuctionRevealSpan,

        uint256 auctionWithdrawSpan,

        uint256 emergencyAuctionWithdrawSpan

    )

        public

        AuctionTimeControl(

            minNormalAuctionPeriod,

            minEmergencyAuctionPeriod,

            normalAuctionRevealSpan,

            emergencyAuctionRevealSpan,

            auctionWithdrawSpan,

            emergencyAuctionWithdrawSpan

        )

        UseBondMaker(bondMakerAddress)

        UseStableCoin(IDOLAddress)

        UseAuctionBoard(auctionBoardAddress)

    {}



    /**

     * @dev This function starts the auction for the auctionID. Can be called only by the IDOL contract.

     */

    function startAuction(

        bytes32 bondID,

        uint64 auctionAmount,

        bool isEmergency

    ) external override returns (bytes32) {

        require(

            msg.sender == address(_IDOLContract),

            "caller must be IDOL contract"

        );

        return _startAuction(bondID, auctionAmount, isEmergency);

    }



    /**

     * @notice This function is called when the auction (re)starts.

     * @param bondID is SBT ID whose auction will be held.

     * @param auctionAmount is SBT amount put up in the auction.

     * @param isEmergency is the flag that indicates the auction schedule is for emergency mode.

     */

    function _startAuction(

        bytes32 bondID,

        uint64 auctionAmount,

        bool isEmergency

    ) internal returns (bytes32) {

        (, , uint256 solidStrikePriceE4, ) = _bondMakerContract.getBond(bondID);

        uint256 strikePriceIDOL = _IDOLContract.calcSBT2IDOL(

            solidStrikePriceE4.mul(10**8)

        );



        uint256 auctionCount = _bondIDAuctionCount[bondID].add(1);

        _bondIDAuctionCount[bondID] = auctionCount;

        bytes32 auctionID = getCurrentAuctionID(bondID);

        require(

            isInPeriod(auctionID, BEFORE_AUCTION_FLAG),

            "the auction has been held"

        );



        uint256 betaCount = auctionCount.mod(POOL_AUCTION_COUNT_PADDING).min(9);



        auctionID2BondID[auctionID] = bondID;



        _setAuctionClosingTime(auctionID, isEmergency);



        {

            AuctionConfig memory auctionConfig = _auctionConfigList[auctionID];

            auctionConfig.ongoingAuctionSBTTotalE8 = auctionAmount;

            auctionConfig.lowestBidPriceDeadLineE8 = strikePriceIDOL

                .mul(10 - betaCount)

                .div(10)

                .toUint64();

            auctionConfig.highestBidPriceDeadLineE8 = strikePriceIDOL

                .mul(10 + betaCount)

                .div(10)

                .toUint64();

            _auctionConfigList[auctionID] = auctionConfig;

        }



        emit LogStartAuction(auctionID, bondID);



        return auctionID;

    }



    /**

     * @notice submit only your own winning bids and get SBT amount which you'll aquire.

     */

    function calcWinnerAmount(

        bytes32 auctionID,

        address sender,

        uint64[] memory winnerBids

    ) public override view returns (uint64) {

        uint256 totalBidAmount;



        (

            uint64 endPrice,

            uint64 endBoardIndex,

            uint64 loseSBTAmount,



        ) = _auctionBoardContract.getEndInfo(auctionID);



        uint64 bidPrice;

        uint64 boardIndex;

        // can calculate winner amount after making the end info.

        {

            (, , bool isEndInfoCreated, , ) = _auctionBoardContract

                .auctionDisposalInfo(auctionID);

            require(isEndInfoCreated, "the end info has not been made yet");

        }



        for (uint256 i = 0; i < winnerBids.length; i += 2) {

            if (i != 0) {

                require(

                    bidPrice > winnerBids[i] ||

                        (bidPrice == winnerBids[i] &&

                            boardIndex < winnerBids[i + 1]),

                    "loser Bids are not sorted."

                );

            }

            bidPrice = winnerBids[i];

            boardIndex = winnerBids[i + 1];

            (uint64 bidAmount, address bidder) = _auctionBoardContract

                .auctionBoard(auctionID, bidPrice, boardIndex);

            require(bidder == sender, "this bid is not yours");



            totalBidAmount = totalBidAmount.add(bidAmount);

            if (endPrice == bidPrice) {

                if (boardIndex == endBoardIndex) {

                    totalBidAmount = totalBidAmount.sub(loseSBTAmount);

                } else {

                    require(

                        boardIndex < endBoardIndex,

                        "this bid does not win"

                    );

                }

            } else {

                require(endPrice < bidPrice, "this bid does not win");

            }

        }



        return totalBidAmount.toUint64();

    }



    /**

     * @notice all loser bids must be reported to this function. These are checked and counted for calculations of bill.

     * @param auctionID aunctionID

     * @param sender owner of the bids

     * @param winnerAmountInput SBT amount to aquire. this is needed because this effect the price of SBT in Vickly Auction's protocol.

     * @param myLowestPrice myLowestPrice is the lowest price of skip bids.

     * @param myLoseBids is the all bids which is after the endInfo

     */

    function calcBillAndCheckLoserBids(

        bytes32 auctionID,

        address sender,

        uint64 winnerAmountInput,

        uint64 myLowestPrice,

        uint64[] memory myLoseBids

    ) public override view returns (uint64) {

        uint256 winnerAmount = winnerAmountInput;

        uint256 toPaySkip = 0;



        if (

            myLowestPrice != NO_SKIP_BID &&

            myLowestPrice != SKIP_RECEIVING_WIN_BIDS

        ) {

            bool myLowestVerify = false;

            for (uint256 i = 0; i < myLoseBids.length; i += 2) {

                uint64 price = myLoseBids[i];

                if (price == myLowestPrice) {

                    myLowestVerify = true;

                    break;

                }

            }



            require(

                myLowestVerify,

                "myLowestPrice must be included in myLoseBids"

            );

        }



        // The amount of sender's lose bids will be skipped. In order to optimize the calculation,

        // components in myLoseBids with a higher price than myLowestPrice are added to winnerAmount and

        // to be subtracted at the end of this function.

        for (uint256 i = 0; i < myLoseBids.length; i += 2) {

            uint64 price = myLoseBids[i];

            uint64 boardIndex = myLoseBids[i + 1];



            if (i != 0) {

                require(

                    price < myLoseBids[i - 2] ||

                        (price == myLoseBids[i - 2] &&

                            boardIndex > myLoseBids[i - 1]),

                    "myLoseBids is not sorted"

                );

            }

            {

                (

                    uint64 endPrice,

                    uint64 endBoardIndex,

                    uint64 loseSBTAmount,



                ) = _auctionBoardContract.getEndInfo(auctionID);



                if (price == endPrice) {

                    if (boardIndex == endBoardIndex) {

                        require(

                            loseSBTAmount != 0,

                            "myLoseBids includes the bid which is same as endInfo with no lose SBT amount"

                        );



                        // This function does not guarantee to return the correct result if an invalid input is given,

                        // because this function can be used just for getting information.

                        // This function is used in the procecss of makeAuctionResult(), and in such a case,

                        // all the verification for bidder==sender and some necessary conditions are processed

                        // in different functions.



                        if (myLowestPrice <= price) {

                            winnerAmount = winnerAmount.add(loseSBTAmount);

                            toPaySkip = toPaySkip.add(

                                price.mul(loseSBTAmount).div(10**8)

                            );

                            continue;

                        }

                    } else {

                        require(

                            boardIndex > endBoardIndex,

                            "myLoseBids includes the bid whose bid index is less than that of endInfo"

                        );

                    }

                } else {

                    require(

                        price < endPrice,

                        "myLoseBids includes the bid whose price is more than that of endInfo"

                    );

                }

            }



            (uint64 bidAmount, address bidder) = _auctionBoardContract

                .auctionBoard(auctionID, price, boardIndex);

            require(

                bidder == sender,

                "myLoseBids includes the bid whose owner is not the sender"

            );



            if (myLowestPrice <= price) {

                winnerAmount = winnerAmount.add(bidAmount);

                toPaySkip = toPaySkip.add(price.mul(bidAmount).div(10**8));

            }

        }



        if (myLowestPrice == SKIP_RECEIVING_WIN_BIDS) {

            // Reduce calculation costs instead by receiving obtained SBT at the highest losing price.

            (uint64 endPrice, , , ) = _auctionBoardContract.getEndInfo(

                auctionID

            );

            //while toPaySkip is expected to be zero in the loop above,

            //only the exception is when the the price acctually hit uint64(-1) at an extremely unexpected case.

            return

                endPrice

                    .mul(winnerAmount)

                    .divRoundUp(10**8)

                    .sub(toPaySkip)

                    .toUint64();

        }



        return

            _auctionBoardContract

                .calcBill(auctionID, winnerAmount.toUint64(), myLowestPrice)

                .sub(toPaySkip)

                .toUint64();

    }



    /**

     * @notice Submit all my win and lose bids, verify them, and transfer the auction reward.

     * @param winnerBids is an array of alternating price and board index.

     * For example, if the end info is { price: 96, boardIndex: 0, loseSBTAmount: 100000000 } and you have 3 bids:

     * { price: 99, boardIndex: 0 }, { price: 97, boardIndex: 2 }, and { price: 96, boardIndex: 1 },

     * you should submit [9900000000, 0, 9700000000, 2] as winnerBids and [9600000000, 1] as loserBids.

     * If the end info is { price: 96, boardIndex: 0, loseSBTAmount: 100000000 } and you have 1 bid:

     * { price: 96, boardIndex: 0 }, you should submit [9600000000, 0] as winnerBids and [9600000000, 0]

     * as loserBids.

     */

    function makeAuctionResult(

        bytes32 auctionID,

        uint64 myLowestPrice,

        uint64[] memory winnerBids,

        uint64[] memory loserBids

    )

        public

        override

        returns (

            uint64,

            uint64,

            uint64

        )

    {

        (

            uint64 auctionLockedIDOLAmountE8,

            uint16 bidCount

        ) = _auctionBoardContract.auctionParticipantInfo(auctionID, msg.sender);



        require(auctionLockedIDOLAmountE8 != 0, "This process is already done");



        {

            (

                uint64 endPrice,

                uint64 endBoardIndex,

                uint64 loseSBTAmount,

                uint64 auctionEndPriceWinnerSBTAmount

            ) = _auctionBoardContract.getEndInfo(auctionID);

            (address endBidder, ) = _auctionBoardContract.getBoard(

                auctionID,

                endPrice,

                endBoardIndex

            );

            // If dupicated bid count is included (loseSBTAmount != 0), bidCount is increased by 1.

            // When both auctionEndPriceWinnerSBTAmount and loseSBTAmount are no-zero value,

            // the end info bid has two components(a winner bid side & a loser bid side).

            // If endInfo bid is frauded in calcBillAndCheckLoserBids L269, revert here. So there needs not check sender==bidder.

            require(

                winnerBids.length.div(2) + loserBids.length.div(2) ==

                    bidCount +

                        (

                            (msg.sender == endBidder &&

                                loseSBTAmount != 0 &&

                                auctionEndPriceWinnerSBTAmount != 0)

                                ? 1

                                : 0

                        ),

                "must submit all of your bids"

            );

        }



        uint64 winnerAmount = calcWinnerAmount(

            auctionID,

            msg.sender,

            winnerBids

        );



        uint64 toPay;

        TimeControlFlag timeFlag = getTimeControlFlag(auctionID);



        if (timeFlag == RECEIVING_SBT_PERIOD_FLAG) {

            toPay = calcBillAndCheckLoserBids(

                auctionID,

                msg.sender,

                winnerAmount,

                myLowestPrice,

                loserBids

            );

        } else {

            require(

                timeFlag > RECEIVING_SBT_PERIOD_FLAG,

                "has not been the receiving period yet"

            );

            toPay = calcBillAndCheckLoserBids(

                auctionID,

                msg.sender,

                winnerAmount,

                SKIP_RECEIVING_WIN_BIDS,

                loserBids

            );

        }



        uint64 IDOLAmountOfChange = auctionLockedIDOLAmountE8

            .sub(toPay)

            .toUint64();

        _auctionBoardContract.deleteParticipantInfo(auctionID, msg.sender);

        _transferIDOL(msg.sender, IDOLAmountOfChange);



        _auctionBoardContract.updateAuctionInfo(

            auctionID,

            0,

            toPay,

            winnerAmount

        );

        _distributeToWinners(auctionID, winnerAmount);



        emit LogAuctionResult(

            auctionID,

            msg.sender,

            winnerAmount,

            toPay,

            IDOLAmountOfChange

        );



        return (winnerAmount, toPay, IDOLAmountOfChange);

    }



    /**

     * @notice Close the auction when it is done. If some part of SBTs remain unsold, the auction is held again.

     */

    function closeAuction(bytes32 auctionID)

        public

        override

        returns (bool, bytes32)

    {

        (uint64 auctionSettledTotalE8, , ) = _auctionBoardContract.auctionInfo(

            auctionID

        );

        require(

            isInPeriod(auctionID, AFTER_AUCTION_FLAG),

            "This function is not allowed to execute in this period"

        );



        uint64 ongoingAuctionSBTTotal = _auctionConfigList[auctionID]

            .ongoingAuctionSBTTotalE8;

        require(ongoingAuctionSBTTotal != 0, "already closed");

        bytes32 bondID = auctionID2BondID[auctionID];



        {

            (, , bool isEndInfoCreated, , ) = _auctionBoardContract

                .auctionDisposalInfo(auctionID);

            require(isEndInfoCreated, "has not set end info");

        }



        _forceToFinalizeWinnerAmount(auctionID);



        uint256 nextAuctionAmount = ongoingAuctionSBTTotal.sub(

            auctionSettledTotalE8,

            "allocated SBT amount for auction never becomes lower than reward total"

        );



        bool isLast = nextAuctionAmount == 0;

        _publishSettledAverageAuctionPrice(auctionID, isLast);



        bytes32 nextAuctionID = bytes32(0);

        if (isLast) {

            // closeAuction adds 10**8 to _bondIDAuctionCount[bondID] and resets beta count

            // when all SBT of the auction is sold out.

            _bondIDAuctionCount[bondID] = _bondIDAuctionCount[bondID]

                .div(POOL_AUCTION_COUNT_PADDING)

                .add(1)

                .mul(POOL_AUCTION_COUNT_PADDING);

        } else {

            // When the SBT is not sold out in the auction, restart a new one until all the SBT is successfully sold.

            nextAuctionID = _startAuction(

                bondID,

                nextAuctionAmount.toUint64(),

                true

            );

        }

        delete _auctionConfigList[auctionID].ongoingAuctionSBTTotalE8;



        emit LogCloseAuction(auctionID, isLast, nextAuctionID);



        return (isLast, nextAuctionID);

    }



    /**

     * @notice This function returns SBT amount and iDOL amount (as its change) settled for those who didn't reveal bids.

     */

    function _calcUnrevealedBidDistribution(

        uint64 ongoingAmount,

        uint64 totalIDOLAmountUnrevealed,

        uint64 totalSBTAmountPaidForUnrevealed,

        uint64 solidStrikePriceIDOL,

        uint64 IDOLAmountDeposited

    )

        internal

        pure

        returns (uint64 receivingSBTAmount, uint64 returnedIDOLAmount)

    {

        // (total target) - (total revealed) = (total unrevealed)

        uint64 totalSBTAmountUnrevealed = totalIDOLAmountUnrevealed

            .mul(10**8)

            .div(solidStrikePriceIDOL, "system error: Oracle has a problem")

            .toUint64();



        // min((total unrevealed), ongoing) - (total paid already) = (total deposit for punishment)

        uint64 totalLeftSBTAmountForUnrevealed = uint256(

            totalSBTAmountUnrevealed

        )

            .min(ongoingAmount)

            .sub(totalSBTAmountPaidForUnrevealed)

            .toUint64();



        // (receiving SBT amount) = min((bid amount), (total deposited))

        uint256 expectedReceivingSBTAmount = IDOLAmountDeposited.mul(10**8).div(

            solidStrikePriceIDOL,

            "system error: Oracle has a problem"

        );



        // (returned iDOL amount) = (deposit amount) - (iDOL value of receiving SBT amount)

        if (expectedReceivingSBTAmount <= totalLeftSBTAmountForUnrevealed) {

            receivingSBTAmount = expectedReceivingSBTAmount.toUint64();

            returnedIDOLAmount = 0;

        } else if (totalLeftSBTAmountForUnrevealed == 0) {

            receivingSBTAmount = 0;

            returnedIDOLAmount = IDOLAmountDeposited;

        } else {

            receivingSBTAmount = totalLeftSBTAmountForUnrevealed;

            returnedIDOLAmount = IDOLAmountDeposited

                .sub(

                totalLeftSBTAmountForUnrevealed

                    .mul(solidStrikePriceIDOL)

                    .divRoundUp(10**8)

            )

                .toUint64();

        }



        return (receivingSBTAmount, returnedIDOLAmount);

    }



    /**

     * @notice Transfer SBT for those who forget to reveal.

     */

    function receiveUnrevealedBidDistribution(bytes32 auctionID, bytes32 secret)

        public

        override

        returns (bool)

    {

        (

            uint64 solidStrikePriceIDOL,

            ,

            bool isEndInfoCreated,

            ,



        ) = _auctionBoardContract.auctionDisposalInfo(auctionID);

        require(

            isEndInfoCreated,

            "EndInfo hasn't been made. This Function has not been allowed yet."

        );



        (address secOwner, , uint64 IDOLAmountDeposited) = _auctionBoardContract

            .auctionSecret(auctionID, secret);

        require(secOwner == msg.sender, "ownership of the bid is required");



        (

            ,

            uint64 totalIDOLSecret,

            uint64 totalIDOLAmountRevealed,



        ) = _auctionBoardContract.auctionRevealInfo(auctionID);

        uint64 totalIDOLAmountUnrevealed = totalIDOLSecret

            .sub(totalIDOLAmountRevealed)

            .toUint64();



        uint64 receivingSBTAmount;

        uint64 returnedIDOLAmount;

        uint64 totalSBTAmountPaidForUnrevealed;

        {

            AuctionConfig memory auctionConfig = _auctionConfigList[auctionID];

            totalSBTAmountPaidForUnrevealed = auctionConfig

                .totalSBTAmountPaidForUnrevealedE8;



            (

                receivingSBTAmount,

                returnedIDOLAmount

            ) = _calcUnrevealedBidDistribution(

                auctionConfig.ongoingAuctionSBTTotalE8,

                totalIDOLAmountUnrevealed,

                totalSBTAmountPaidForUnrevealed,

                solidStrikePriceIDOL,

                IDOLAmountDeposited

            );

        }



        _auctionConfigList[auctionID]

            .totalSBTAmountPaidForUnrevealedE8 = totalSBTAmountPaidForUnrevealed

            .add(receivingSBTAmount)

            .toUint64();

        _auctionBoardContract.removeSecret(auctionID, secret, 0);



        // Transfer the winning SBT and (if necessary) return the rest of deposited iDOL.

        (address solidBondAddress, , , ) = _getBondFromAuctionID(auctionID);

        BondTokenInterface solidBondContract = BondTokenInterface(

            payable(solidBondAddress)

        );

        solidBondContract.transfer(secOwner, receivingSBTAmount);

        _IDOLContract.transfer(secOwner, returnedIDOLAmount);



        return true;

    }



    /**

     * @notice Cancel the bid of your own within the bid acceptance period.

     */

    function cancelBid(bytes32 auctionID, bytes32 secret)

        public

        override

        returns (uint64)

    {

        require(

            isInPeriod(auctionID, ACCEPTING_BIDS_PERIOD_FLAG),

            "it is not the time to accept bids"

        );

        (address owner, , uint64 IDOLamount) = _auctionBoardContract

            .auctionSecret(auctionID, secret);

        require(owner == msg.sender, "you are not the bidder for the secret");

        _auctionBoardContract.removeSecret(auctionID, secret, IDOLamount);

        _transferIDOL(

            owner,

            IDOLamount,

            "system error: try to cancel bid, but cannot return iDOL"

        );



        emit LogCancelBid(auctionID, owner, secret, IDOLamount);



        return IDOLamount;

    }



    /**

     * @notice Returns the current auction ID.

     */

    function getCurrentAuctionID(bytes32 bondID)

        public

        override

        view

        returns (bytes32)

    {

        uint256 count = _bondIDAuctionCount[bondID];

        return generateAuctionID(bondID, count);

    }



    /**

     * @notice Generates auction ID from bond ID and the count of auctions for the bond.

     */

    function generateAuctionID(bytes32 bondID, uint256 count)

        public

        override

        pure

        returns (bytes32)

    {

        return keccak256(abi.encode(bondID, count));

    }



    /**

     * @dev The bidder succeeds in winning the SBT for the auctionID with receivingBondAmount, and pays IDOL with billingIDOLAmount.

     */

    function _distributeToWinners(bytes32 auctionID, uint64 receivingBondAmount)

        internal

        returns (uint64)

    {

        // Get the address of SBT contract.

        (address solidBondAddress, , , ) = _getBondFromAuctionID(auctionID);



        // Transfer the winning SBT.

        BondTokenInterface solidBondContract = BondTokenInterface(

            payable(solidBondAddress)

        );

        solidBondContract.transfer(msg.sender, receivingBondAmount);

    }



    /**

     * @dev When isLast is true, the SBTs put up in the auction are sold entirely.

     * The average auction price is used for deciding the amount of IDOL to return from the lock pool.

     */

    function _publishSettledAverageAuctionPrice(bytes32 auctionID, bool isLast)

        internal

    {

        bytes32 bondID = auctionID2BondID[auctionID];

        (

            ,

            uint64 auctionRewardedTotalE8,

            uint64 auctionPaidTotalE8

        ) = _auctionBoardContract.auctionInfo(auctionID);



        // The auction contract actually do not burn iDOL. Paid iDOL will be transferred and burned in the stable coin contract.

        _transferIDOL(

            address(_IDOLContract),

            auctionPaidTotalE8,

            "system error: cannot transfer iDOL from auction contract to iDOL contract"

        );



        _IDOLContract.setSettledAverageAuctionPrice(

            bondID,

            auctionPaidTotalE8,

            auctionRewardedTotalE8,

            isLast

        );

    }



    /**

     * @dev How much IDOL to burn is decided by the settlement price.

     * Hence, this contract needs to decide the price within some specified period.

     */

    function _forceToFinalizeWinnerAmount(bytes32 auctionID) internal {

        (

            uint64 auctionSettledTotalE8,

            uint64 auctionRewardedTotalE8,



        ) = _auctionBoardContract.auctionInfo(auctionID);



        if (_auctionBoardContract.getSortedBidPrice(auctionID).length == 0) {

            return;

        }



        (uint256 burnIDOLRate, , , ) = _auctionBoardContract.getEndInfo(

            auctionID

        );



        uint256 _totalSBTForRestWinners = auctionSettledTotalE8.sub(

            auctionRewardedTotalE8,

            "system error: allocated SBT amount for auction never becomes lower than reward total at any point"

        );



        uint256 burnIDOL = _totalSBTForRestWinners.mul(burnIDOLRate).div(10**8);



        _auctionBoardContract.updateAuctionInfo(

            auctionID,

            _totalSBTForRestWinners.toUint64(),

            burnIDOL.toUint64(),

            _totalSBTForRestWinners.toUint64()

        );

    }



    /**

     * @notice Returns the bond information corresponding to the auction ID.

     */

    function _getBondFromAuctionID(bytes32 auctionID)

        internal

        view

        returns (

            address erc20Address,

            uint256 maturity,

            uint64 stableStrikePrice,

            bytes32 fnMapID

        )

    {

        bytes32 bondID = auctionID2BondID[auctionID];

        return _bondMakerContract.getBond(bondID);

    }



    /**

     * @notice Returns the bond IDs corresponding to the auction IDs respectively.

     */

    function listBondIDFromAuctionID(bytes32[] memory auctionIDs)

        public

        override

        view

        returns (bytes32[] memory bondIDs)

    {

        bondIDs = new bytes32[](auctionIDs.length);

        for (uint256 i = 0; i < auctionIDs.length; i++) {

            bondIDs[i] = auctionID2BondID[auctionIDs[i]];

        }

    }



    /**

     * @notice Returns the auction status.

     * @param auctionID is a auction ID.

     * @return closingTime is .

     * @return auctionAmount is the SBT amount put up in the auction.

     * @return rewardedAmount is .

     * @return totalSBTAmountBid is .

     * @return isEmergency is .

     * @return doneFinalizeWinnerAmount is .

     * @return doneSortPrice is .

     * @return lowestBidPriceDeadLine is the minimum bid price in the auction.

     * @return highestBidPriceDeadLine is the maximum bid price in the auction.

     * @return totalSBTAmountPaidForUnrevealed is the SBT Amount allocated for those who had not revealed their own bid.

     */

    function getAuctionStatus(bytes32 auctionID)

        public

        override

        view

        returns (

            uint256 closingTime,

            uint64 auctionAmount,

            uint64 rewardedAmount,

            uint64 totalSBTAmountBid,

            bool isEmergency,

            bool doneFinalizeWinnerAmount,

            bool doneSortPrice,

            uint64 lowestBidPriceDeadLine,

            uint64 highestBidPriceDeadLine,

            uint64 totalSBTAmountPaidForUnrevealed

        )

    {

        closingTime = auctionClosingTime[auctionID].toUint64();

        AuctionConfig memory auctionConfig = _auctionConfigList[auctionID];

        auctionAmount = auctionConfig.ongoingAuctionSBTTotalE8;

        lowestBidPriceDeadLine = auctionConfig.lowestBidPriceDeadLineE8;

        highestBidPriceDeadLine = auctionConfig.highestBidPriceDeadLineE8;

        totalSBTAmountPaidForUnrevealed = auctionConfig

            .totalSBTAmountPaidForUnrevealedE8;

        (, rewardedAmount, ) = _auctionBoardContract.auctionInfo(auctionID);

        (totalSBTAmountBid, , , ) = _auctionBoardContract.auctionRevealInfo(

            auctionID

        );

        isEmergency = isAuctionEmergency[auctionID];

        (, , , doneFinalizeWinnerAmount, doneSortPrice) = _auctionBoardContract

            .auctionDisposalInfo(auctionID);

    }



    /**

     * @notice Returns the status of auctions which is held in the week.

     * @param weekNumber is the quotient obtained by dividing the timestamp by 7 * 24 * 60 * 60 (= 7 days).

     */

    function getWeeklyAuctionStatus(uint256 weekNumber)

        external

        override

        view

        returns (uint256[] memory weeklyAuctionStatus)

    {

        bytes32[] memory auctions = listAuction(weekNumber);

        weeklyAuctionStatus = new uint256[](auctions.length.mul(6));

        for (uint256 i = 0; i < auctions.length; i++) {

            (

                uint256 closingTime,

                uint64 auctionAmount,

                uint64 rewardedAmount,

                uint64 totalSBTAmountBid,

                bool isEmergency,

                bool doneFinalizeWinnerAmount,

                bool doneSortPrice,

                ,

                ,



            ) = getAuctionStatus(auctions[i]);

            uint8 auctionStatusCode = (isEmergency ? 1 : 0) << 2;

            auctionStatusCode += (doneFinalizeWinnerAmount ? 1 : 0) << 1;

            auctionStatusCode += doneSortPrice ? 1 : 0;

            weeklyAuctionStatus[i * 6] = closingTime;

            weeklyAuctionStatus[i * 6 + 1] = auctionAmount;

            weeklyAuctionStatus[i * 6 + 2] = rewardedAmount;

            weeklyAuctionStatus[i * 6 + 3] = totalSBTAmountBid;

            weeklyAuctionStatus[i * 6 + 4] = auctionStatusCode;

            weeklyAuctionStatus[i * 6 + 5] = uint256(auctions[i]);

        }

    }



    /**

     * @notice Returns total SBT amount put up in the auction.

     */

    function ongoingAuctionSBTTotal(bytes32 auctionID)

        external

        override

        view

        returns (uint64 ongoingSBTAmountE8)

    {

        AuctionConfig memory auctionConfig = _auctionConfigList[auctionID];

        return auctionConfig.ongoingAuctionSBTTotalE8;

    }



    function getAuctionCount(bytes32 bondID)

        external

        override

        view

        returns (uint256 auctionCount)

    {

        return _bondIDAuctionCount[bondID];

    }

}



// File: contracts/UseAuctionLater.sol



pragma solidity 0.6.6;









abstract contract UseAuctionLater is DeployerRole {

    Auction internal _auctionContract;



    modifier isNotEmptyAuctionInstance() {

        require(

            address(_auctionContract) != address(0),

            "the auction contract is not set"

        );

        _;

    }



    /**

     * @dev This function is called only once when the code is initially deployed.

     */

    function setAuctionContract(address contractAddress) public onlyDeployer {

        require(

            address(_auctionContract) == address(0),

            "the auction contract is already registered"

        );

        require(

            contractAddress != address(0),

            "contract should be non-zero address"

        );

        _setAuctionContract(contractAddress);

    }



    function _setAuctionContract(address contractAddress) internal {

        _auctionContract = Auction(payable(contractAddress));

    }

}



// File: contracts/AuctionBoard.sol



pragma solidity 0.6.6;



























contract AuctionBoard is

    UseSafeMath,

    AuctionBoardInterface,

    AuctionSecret,

    UseStableCoin,

    UseBondMaker,

    UseAuctionLater

{

    AuctionTimeControlInterface.TimeControlFlag internal constant BEFORE_AUCTION_FLAG = AuctionTimeControlInterface

        .TimeControlFlag

        .BEFORE_AUCTION_FLAG;

    AuctionTimeControlInterface.TimeControlFlag internal constant ACCEPTING_BIDS_PERIOD_FLAG = AuctionTimeControlInterface

        .TimeControlFlag

        .ACCEPTING_BIDS_PERIOD_FLAG;

    AuctionTimeControlInterface.TimeControlFlag internal constant REVEALING_BIDS_PERIOD_FLAG = AuctionTimeControlInterface

        .TimeControlFlag

        .REVEALING_BIDS_PERIOD_FLAG;

    AuctionTimeControlInterface.TimeControlFlag internal constant RECEIVING_SBT_PERIOD_FLAG = AuctionTimeControlInterface

        .TimeControlFlag

        .RECEIVING_SBT_PERIOD_FLAG;

    AuctionTimeControlInterface.TimeControlFlag internal constant AFTER_AUCTION_FLAG = AuctionTimeControlInterface

        .TimeControlFlag

        .AFTER_AUCTION_FLAG;



    uint64 internal constant NO_SKIP_BID = uint64(-1);

    uint64 internal constant SKIP_RECEIVING_WIN_BIDS = uint64(-2);

    uint256 internal immutable MAX_PRICE_INDEX;

    uint256 internal immutable MAX_BOARD_INDEX;

    uint256 internal immutable MAX_BOARD_INDEX_AT_END_PRICE;

    uint256 internal immutable MAX_BIDCOUNT_PER_ADDRESS;



    /**

     * @notice The stats of the bids in the auction.

     * totalIDOLSecret is the total IDOL amount of unrevealed bids.

     * totalIDOLRevealed is the total IDOL amount of revealed bids.

     * auctionPriceCount is the number of the unique bid price in the auction.

     */

    struct RevealingInfo {

        uint64 totalSBTAmountBid;

        uint64 totalIDOLSecret;

        uint64 totalIDOLRevealed;

        uint16 auctionPriceCount;

    }

    mapping(bytes32 => RevealingInfo) public override auctionRevealInfo;



    /**

     * @notice The revealed bids grouped by its price. Each BidInfo has its amount and person who bid.

     * @dev The contents in this internal storage variable can be seen by LogInsertBoard event.

     */

    struct BidInfo {

        uint64 amount;

        address bidder;

    }

    mapping(bytes32 => mapping(uint64 => BidInfo[])) internal _auctionBoard;



    /**

     * @notice The total SBT bid amount at the price in the auction.

     * @dev The contents in this internal storage variable can be seen by getBoardStatus function.

     */

    mapping(bytes32 => mapping(uint64 => uint64)) internal _auctionPrice2TotalSBTAmount;



    /**

     * @notice The information of the person who bid in the auction.

     * auctionLockedIDOLAmountE8 is the total IDOL amount locked for the bid.

     * bidCount is the number of their bids.

     */

    struct ParticipantAmount {

        uint64 auctionLockedIDOLAmountE8;

        uint16 bidCount;

    }

    mapping(bytes32 => mapping(address => ParticipantAmount)) public override auctionParticipantInfo;



    /**

     * @dev The contents in this internal storage variable can be seen by getUnsortedBidPrice function.

     */

    mapping(bytes32 => uint64[]) internal _auctionSortedPrice;



    /**

     * @dev The contents in this internal storage variable can be seen by getSortedBidPrice function.

     */

    mapping(bytes32 => uint64[]) internal _auctionUnsortedPrice;



    /**

     * @notice solidStrikePriceIDOLForUnrevealedE8 is the rate of SBT/IDOL for Unrevealed Bids.

     * isEndInfoCreated is the flag that indicates executions of disposeOfUnrevealedBid()

     * in makeEndInfo and giveUpMakeEndInfo.

     * isPriceSorted is the flag that indicates the prices are successfully sorted.

     */

    struct DisposalInfo {

        uint64 solidStrikePriceIDOLForUnrevealedE8;

        uint64 solidStrikePriceIDOLForRestWinnersE8;

        bool isEndInfoCreated;

        bool isForceToFinalizeWinnerAmountTriggered;

        bool isPriceSorted;

    }

    mapping(bytes32 => DisposalInfo) public override auctionDisposalInfo;



    /**

     * @notice The indicator for the person who has the lowest winning price (priceIndex, boardIndex),

     * and his losing amount (loseSBTAmount).

     * @dev The contents in this internal storage variable can be seen by getEndInfo function.

     * @param price is the lowest winner price.

     * @param boardIndex is the maximum board index among the winner bids at the lowest price.

     * @param loseSBTAmount is the unsettled amount of the bid at the lowest price and the maximum

     * board index among the winner bids at the price.

     * @param auctionEndPriceWinnerSBTAmount is the total amount of SBTs that have been settled

     * at the lowest winner price.

     */

    struct AuctionWinnerDetInfo {

        uint64 priceIndex;

        uint64 boardIndex;

        uint64 loseSBTAmount;

        uint64 auctionEndPriceWinnerSBTAmount;

    }

    mapping(bytes32 => AuctionWinnerDetInfo) internal _auctionEndInfo;



    struct AuctionInfo {

        uint64 auctionSettledTotalE8;

        uint64 auctionRewardedTotalE8;

        uint64 auctionPaidTotalE8;

    }

    mapping(bytes32 => AuctionInfo) public override auctionInfo;



    constructor(

        address bondMakerAddress,

        address IDOLAddress,

        uint256 maxPriceIndex,

        uint256 maxBoardIndex,

        uint256 maxBoardIndexAtEndPrice,

        uint256 maxBidCountPerAddress

    ) public UseBondMaker(bondMakerAddress) UseStableCoin(IDOLAddress) {

        require(

            maxPriceIndex <= uint16(-1),

            "MAX_PRICE_INDEX must not exceed 2^16 - 1"

        );

        require(

            maxBoardIndex <= uint64(-1),

            "MAX_BOARD_INDEX must not exceed 2^64 - 1"

        );

        require(

            maxBoardIndexAtEndPrice <= uint64(-1),

            "MAX_BOARD_INDEX_AT_END_PRICE must not exceed 2^64 - 1"

        );

        MAX_PRICE_INDEX = maxPriceIndex;

        MAX_BOARD_INDEX = maxBoardIndex;

        MAX_BOARD_INDEX_AT_END_PRICE = maxBoardIndexAtEndPrice;

        MAX_BIDCOUNT_PER_ADDRESS = maxBidCountPerAddress;

    }



    /**

     * @notice Secret submission for the auction participation by hash commit.

     * @dev Need to execute ERC20's approve() with IDOL amount

     * (= lambda * SBTstrikePrice * SBTAmount) before this execution.

     * The lambda value equals to the value used in unlockSBT.

     * Hence, even in the same auction, the strike price * lambda may change.

     * In such a case, they may wish to cancel their bid and resend a new one.

     */

    function bidWithMemo(

        bytes32 auctionID,

        bytes32 secret,

        uint64 targetSBTAmount,

        bytes memory memo

    ) public virtual override {

        require(

            _auctionContract.isInPeriod(auctionID, ACCEPTING_BIDS_PERIOD_FLAG),

            "it is not the time to accept bids"

        );



        (, , uint256 solidStrikePriceE4, ) = _getBondFromAuctionID(auctionID);

        uint256 strikePriceIDOLAmount = _IDOLContract.calcSBT2IDOL(

            solidStrikePriceE4.mul(targetSBTAmount)

        );

        require(

            strikePriceIDOLAmount >= 10**10,

            "at least 100 iDOL is required for the bid Amount"

        );



        _bidWithMemo(

            auctionID,

            secret,

            targetSBTAmount,

            strikePriceIDOLAmount,

            memo

        );

    }



    function _bidWithMemo(

        bytes32 auctionID,

        bytes32 secret,

        uint64 targetSBTAmount,

        uint256 strikePriceIDOLAmount,

        bytes memory memo

    ) internal {

        _transferIDOLFrom(

            msg.sender,

            address(_auctionContract),

            strikePriceIDOLAmount

        );



        // write secret

        _setSecret(

            auctionID,

            secret,

            msg.sender,

            targetSBTAmount,

            strikePriceIDOLAmount.toUint64()

        );

        RevealingInfo memory revealInfo = auctionRevealInfo[auctionID];

        revealInfo.totalSBTAmountBid = revealInfo

            .totalSBTAmountBid

            .add(targetSBTAmount)

            .toUint64();

        revealInfo.totalIDOLSecret = revealInfo

            .totalIDOLSecret

            .add(strikePriceIDOLAmount)

            .toUint64();

        auctionRevealInfo[auctionID] = revealInfo;



        emit LogBidMemo(auctionID, msg.sender, memo);

    }



    function _revealTimeControl(bytes32 auctionID)

        internal

        view

        returns (uint64)

    {

        AuctionTimeControlInterface.TimeControlFlag timeFlag = _auctionContract

            .getTimeControlFlag(auctionID);

        uint64 strikePrice;

        if (timeFlag == ACCEPTING_BIDS_PERIOD_FLAG) {

            (, , uint256 solidStrikePriceE4, ) = _getBondFromAuctionID(

                auctionID

            );

            strikePrice = _IDOLContract

                .calcSBT2IDOL(solidStrikePriceE4.mul(10**8))

                .toUint64();

        } else {

            require(

                timeFlag == REVEALING_BIDS_PERIOD_FLAG,

                "it is not the time to reveal the value of bids"

            );

        }

        return strikePrice;

    }



    function _registerNewBidPrice(bytes32 auctionID, uint256 price)

        internal

        view

        returns (uint64)

    {

        uint64 bidPrice = price.toUint64();

        (

            ,

            ,

            ,

            ,

            ,

            ,

            ,

            uint64 lowestBidPriceDeadLine,

            uint64 highestBidPriceDeadLine,



        ) = _auctionContract.getAuctionStatus(auctionID);

        if (price > highestBidPriceDeadLine) {

            bidPrice = highestBidPriceDeadLine;

        } else if (price < lowestBidPriceDeadLine) {

            bidPrice = lowestBidPriceDeadLine;

        }



        bidPrice = discretizeBidPrice(bidPrice);



        return bidPrice;

    }



    /**

     * @notice Reveal the bid price publicly.

     * When the bidder publishes their bids earlier than expected by the rule,

     * all people can see the preimage of the bid which can potentially change behaviors of the others,

     * which shuld be prevented.

     * If one submits a valid proof for detecting earlier reveal,

     * the bid price is overwritten by the strike price (slightly unfavored price).

     * Also, if the disclosure is not processed until the deadline, the bid price is considered as

     * a bid with the strike price as well (the process is done in _disposeOfUnrevealedBid()).

     */

    function revealBids(

        bytes32 auctionID,

        uint64[] memory bids,

        uint64 random

    ) public override {

        uint64 bidPrice = _revealTimeControl(auctionID);

        bytes32 secret = generateMultiSecret(auctionID, bids, random);

        Secret memory sec = auctionSecret[auctionID][secret];

        require(sec.sender != address(0), "secret is invalid");

        _removeSecret(auctionID, secret);



        /**

         * @dev bidPrice>0 means the revealing bid is too early and this deserves penalty

         * that forces to bid at strikePrice.

         */

        uint256 targetSBTAmount;



        if (bidPrice != 0) {

            uint64[] memory punishBid = new uint64[](2);

            punishBid[0] = bidPrice;

            punishBid[1] = sec.amount;

            targetSBTAmount = _revealBids(

                auctionID,

                sec.sender,

                punishBid,

                sec.IDOLamount

            );

        } else {

            targetSBTAmount = _revealBids(

                auctionID,

                sec.sender,

                bids,

                sec.IDOLamount

            );

        }



        require(

            targetSBTAmount == sec.amount,

            "the total SBT amount info needs to be the same with that of secret."

        );

    }



    function _revealBids(

        bytes32 auctionID,

        address bidder,

        uint64[] memory bids,

        uint64 strikePriceIDOLAmount

    ) internal returns (uint64 targetSBTAmount) {

        {



                ParticipantAmount memory participantInfo

             = auctionParticipantInfo[auctionID][bidder];

            participantInfo.auctionLockedIDOLAmountE8 = participantInfo

                .auctionLockedIDOLAmountE8

                .add(strikePriceIDOLAmount)

                .toUint64();

            participantInfo.bidCount = participantInfo

                .bidCount

                .add(bids.length.div(2))

                .toUint16();

            auctionParticipantInfo[auctionID][bidder] = participantInfo;

            require(

                participantInfo.bidCount <= MAX_BIDCOUNT_PER_ADDRESS,

                "the max bid count per addres exceeded 100"

            );

        }



        RevealingInfo memory revealInfo = auctionRevealInfo[auctionID];

        for (uint256 i = 0; i < bids.length; i += 2) {

            uint64 bidPrice = _registerNewBidPrice(auctionID, bids[i]);



            {

                // If the auctionBoard does not have the same price, increment the count of price.

                uint256 nextBoardIndex = _auctionBoard[auctionID][bidPrice]

                    .length;

                require(nextBoardIndex <= MAX_BOARD_INDEX, "too many bids");

                if (nextBoardIndex == 0) {

                    uint256 nextPriceIndex = _auctionUnsortedPrice[auctionID]

                        .length;

                    require(

                        nextPriceIndex <= MAX_PRICE_INDEX,

                        "price range exceeded"

                    );

                    _auctionUnsortedPrice[auctionID].push(bidPrice);

                    revealInfo.auctionPriceCount = revealInfo

                        .auctionPriceCount

                        .add(1)

                        .toUint16();

                }

            }



            uint64 SBTAmount = bids[i + 1];



            emit LogInsertBoard(

                auctionID,

                bidder,

                bidPrice,

                _auctionBoard[auctionID][bidPrice].length.toUint64(),

                SBTAmount

            );



            _auctionBoard[auctionID][bidPrice].push(BidInfo(SBTAmount, bidder));

            _auctionPrice2TotalSBTAmount[auctionID][bidPrice] = _auctionPrice2TotalSBTAmount[auctionID][bidPrice]

                .add(SBTAmount)

                .toUint64();



            targetSBTAmount = targetSBTAmount.add(SBTAmount).toUint64();

        }



        revealInfo.totalIDOLRevealed = revealInfo

            .totalIDOLRevealed

            .add(strikePriceIDOLAmount)

            .toUint64();

        auctionRevealInfo[auctionID] = revealInfo;

    }



    /**

     * @notice Create the sorted bid price data outside the contract, and check if it is correctly

     * sorted from highest to lowest.

     * @dev This is because creating a hash table for bids by sort will significantly increase the

     * cost of gas.

     */

    function sortBidPrice(bytes32 auctionID, uint64[] memory sortedPrice)

        public

        override

    {

        uint16 bidsCount = sortedPrice.length.toUint16();



        require(

            _auctionContract.isAfterPeriod(

                auctionID,

                RECEIVING_SBT_PERIOD_FLAG

            ),

            "it is not the time to insert the price data"

        );

        require(

            bidsCount == auctionRevealInfo[auctionID].auctionPriceCount,

            "the number of unique prices is invalid"

        );



        if (bidsCount == 1) {

            require(

                _auctionBoard[auctionID][sortedPrice[0]].length != 0,

                "no order exists at the price"

            );

            _auctionSortedPrice[auctionID] = sortedPrice;

        } else if (bidsCount != 0) {

            // Large/small check for each price (large-> small)

            for (uint16 i = 0; i < bidsCount - 1; i++) {

                uint64 current = sortedPrice[i];

                uint64 next = sortedPrice[i + 1];

                require(current > next, "sortedPrice is not sorted correctly");

                require(

                    _auctionBoard[auctionID][current].length != 0,

                    "no order exists at the price"

                );

            }



            require(

                _auctionBoard[auctionID][sortedPrice[bidsCount - 1]].length !=

                    0,

                "no order exists at the price"

            );



            // Completion of sorted bid price data

            _auctionSortedPrice[auctionID] = sortedPrice;

        }



        // Initialize bidIndex to 0. Used in the following endAuction process.

        auctionDisposalInfo[auctionID].isPriceSorted = true;

    }



    /**

     * @notice Unrevealed secret is punished.

     * The total locked IDOL is exchanged for the SBT (the penalty fee is very small in general).

     */

    function _disposeOfUnrevealedBid(bytes32 auctionID) internal {

        DisposalInfo memory disposalInfo = auctionDisposalInfo[auctionID];



        RevealingInfo memory revealInfo = auctionRevealInfo[auctionID];



        require(

            !disposalInfo.isEndInfoCreated,

            "This Function should be triggered only once"

        );

        require(

            disposalInfo.isPriceSorted,

            "Prices need to be sorted before the execution of _disposeOfUnrevealedBid"

        );

        (, , uint256 solidStrikePriceE4, ) = _getBondFromAuctionID(auctionID); // strikePrice in IDOL unit

        // calcSBT2IDOL executes the multiplication of lambda to the strike price

        uint256 solidStrikePriceIDOL = _IDOLContract.calcSBT2IDOL(

            solidStrikePriceE4.mul(10**8)

        );



        // (total target) - (total revealed) = (total unrevealed)

        uint256 IDOLAmountUnrevealedBid = revealInfo.totalIDOLSecret.sub(

            revealInfo.totalIDOLRevealed

        );

        uint256 totalSBTAmountE8 = IDOLAmountUnrevealedBid.mul(10**8).div(

            solidStrikePriceIDOL,

            "system error: SBT strike price should not be zero value"

        );



        {

            uint64 ongoingAmount = _auctionContract.ongoingAuctionSBTTotal(

                auctionID

            );

            if (totalSBTAmountE8 > ongoingAmount) {

                totalSBTAmountE8 = ongoingAmount;

                IDOLAmountUnrevealedBid = totalSBTAmountE8

                    .mul(solidStrikePriceIDOL)

                    .div(10**8);

            }

        }



        disposalInfo.solidStrikePriceIDOLForUnrevealedE8 = solidStrikePriceIDOL

            .toUint64();



        // It is necessary to atomically burn IDOL and to return SBT in order to keep the lambda value consistent.

        _updateAuctionInfo(

            auctionID,

            totalSBTAmountE8.toUint64(),

            IDOLAmountUnrevealedBid.toUint64(),

            totalSBTAmountE8.toUint64()

        );

        disposalInfo.isEndInfoCreated = true;

        auctionDisposalInfo[auctionID] = disposalInfo;

    }



    function makeEndInfo(bytes32 auctionID) public override {

        _disposeOfUnrevealedBid(auctionID);



        AuctionTimeControlInterface.TimeControlFlag timeFlag = _auctionContract

            .getTimeControlFlag(auctionID);

        if (timeFlag == RECEIVING_SBT_PERIOD_FLAG) {

            _makeAuctionEndInfo(auctionID);

            return;

        }



        require(

            timeFlag > RECEIVING_SBT_PERIOD_FLAG,

            "it is not the time to receive winning SBT"

        );

        _giveUpMakeAuctionEndInfo(auctionID);

    }



    /**

     * @notice only decides the lowest winning price, and let each winner calculate their own winning amount in a different function.

     * This function still works even when the network is too crowded.

     * This is different from endAuction, which decides both all the winning amounts per winner and the lowest winning price,

     * but endAuction cannot work when the network is too crowded.

     */

    function _makeAuctionEndInfo(bytes32 auctionID) internal {

        if (_auctionSortedPrice[auctionID].length == 0) {

            return;

        }



        uint256 winnerAmountCount = 0;



        uint64 ongoingAmount = _auctionContract.ongoingAuctionSBTTotal(

            auctionID

        );

        uint256 SBTAuctionTotal = ongoingAmount.sub(

            auctionInfo[auctionID].auctionSettledTotalE8,

            "system error: settled amount exceeds auction amount"

        );



        uint256 SBTAmountAtLowestWinnerPrice;

        uint256 lowestWinnerPriceIndex;

        uint256 price;

        bool endFlag = false;

        for (uint256 i = 0; i < _auctionSortedPrice[auctionID].length; i++) {

            price = _auctionSortedPrice[auctionID][i];

            uint256 SBTAmount = _auctionPrice2TotalSBTAmount[auctionID][price

                .toUint64()];

            uint256 diffAmount = SBTAuctionTotal.sub(winnerAmountCount);

            lowestWinnerPriceIndex = i;

            if (SBTAmount > diffAmount) {

                SBTAmountAtLowestWinnerPrice = diffAmount;

                endFlag = true;

                break;

            }



            winnerAmountCount = winnerAmountCount.add(SBTAmount);



            if (SBTAmount == diffAmount) {

                break;

            }

        }



        /**

         * @dev For the case that the total bid amount is less than the total SBT amount put up in the auction,

         * all the bids result in buying SBT.

         */

        if (!endFlag) {

            AuctionWinnerDetInfo memory endInfo = AuctionWinnerDetInfo(

                lowestWinnerPriceIndex.toUint64(),

                (_auctionBoard[auctionID][price.toUint64()].length - 1)

                    .toUint64(),

                0,

                _auctionPrice2TotalSBTAmount[auctionID][price.toUint64()]

            );

            _auctionEndInfo[auctionID] = endInfo;

            auctionInfo[auctionID]

                .auctionSettledTotalE8 = auctionInfo[auctionID]

                .auctionSettledTotalE8

                .add(winnerAmountCount)

                .toUint64();

            return;

        }



        SBTAuctionTotal = winnerAmountCount; // [WARNING] here we are using SBTAuctionTotal for another purpose to avoid Stack too deep

        winnerAmountCount = 0;



        for (uint256 j = 0; j <= MAX_BOARD_INDEX_AT_END_PRICE; j++) {



                uint256 bidPrice

             = _auctionSortedPrice[auctionID][lowestWinnerPriceIndex];



            // j is guaranteed to be less than _auctionBoard[auctionID][bidPrice.toUint64()].length

            // because of the check of total SBT amount at the end of the loop above.

            BidInfo memory bidInfo = _auctionBoard[auctionID][bidPrice

                .toUint64()][j];

            uint256 diffAmount = SBTAmountAtLowestWinnerPrice.sub(

                winnerAmountCount

            );

            winnerAmountCount = winnerAmountCount.add(bidInfo.amount);



            if (bidInfo.amount >= diffAmount) {

                uint256 loseSBTAmount = bidInfo.amount.sub(diffAmount);

                _auctionEndInfo[auctionID] = AuctionWinnerDetInfo(

                    lowestWinnerPriceIndex.toUint64(),

                    j.toUint64(),

                    loseSBTAmount.toUint64(),

                    SBTAmountAtLowestWinnerPrice.toUint64()

                );

                winnerAmountCount = winnerAmountCount.sub(loseSBTAmount);

                break;

            } else if (j == MAX_BOARD_INDEX_AT_END_PRICE) {

                /**

                 * @dev For spam protection, we stop summing up the winning bid at the lowest winning price.

                 * In this case, the second aucion will be held.

                 */

                _auctionEndInfo[auctionID] = AuctionWinnerDetInfo(

                    lowestWinnerPriceIndex.toUint64(),

                    j.toUint64(),

                    0,

                    winnerAmountCount.toUint64()

                );

            }

        }

        auctionInfo[auctionID].auctionSettledTotalE8 = auctionInfo[auctionID]

            .auctionSettledTotalE8

            .add(SBTAuctionTotal.add(winnerAmountCount))

            .toUint64();

    }



    function _giveUpMakeAuctionEndInfo(bytes32 auctionID) internal {

        if (_auctionSortedPrice[auctionID].length != 0) {

            uint64 highestBidPrice = _auctionSortedPrice[auctionID][0];



            if (_auctionBoard[auctionID][highestBidPrice].length != 0) {

                _auctionEndInfo[auctionID]

                    .loseSBTAmount = _auctionBoard[auctionID][highestBidPrice][0]

                    .amount;

            }

        }

    }



    function calcBill(

        bytes32 auctionID,

        uint64 winnerAmount,

        uint64 myLowestPrice

    ) public override view returns (uint64) {

        AuctionWinnerDetInfo memory endInfo = _auctionEndInfo[auctionID];



        uint256 toPayPlusSkip = 0;

        bool myLowestVerify = false;

        uint256 restWinnerAmount = winnerAmount;



        // Here we start the counting of the payment by using winnerAmount and Loser Bid Prices.

        // At this moment, winnerAmount includes losing amount for optimizing calculation.

        // Verifying the loser bids (function input) is also required after this loop.

        for (

            uint256 i = endInfo.priceIndex;

            i < _auctionSortedPrice[auctionID].length;

            i++

        ) {

            uint64 price = _auctionSortedPrice[auctionID][i];

            uint64 SBTAmount = _auctionPrice2TotalSBTAmount[auctionID][price];

            if (price <= myLowestPrice) {

                myLowestVerify = true;

            }



            if (i == endInfo.priceIndex) {

                // losing SBT amount at the lowest winning price (the highest losing price)

                SBTAmount = SBTAmount

                    .sub(endInfo.auctionEndPriceWinnerSBTAmount)

                    .toUint64();

            }



            if (restWinnerAmount > SBTAmount) {

                toPayPlusSkip = toPayPlusSkip.add(

                    SBTAmount.mul(price).divRoundUp(10**8)

                );

                restWinnerAmount = restWinnerAmount.sub(SBTAmount);

            } else {

                toPayPlusSkip = toPayPlusSkip.add(

                    restWinnerAmount.mul(price).divRoundUp(10**8)

                );

                restWinnerAmount = 0;

                break;

            }

        }



        if (myLowestPrice != NO_SKIP_BID) {

            require(

                myLowestVerify,

                "myLowestVerify is false: incorrect input :[myLowestPrice]3"

            );

        }



        (, , , , , , , uint256 lowestBidPriceDeadLine, , ) = _auctionContract

            .getAuctionStatus(auctionID);

        toPayPlusSkip = toPayPlusSkip.add(

            restWinnerAmount.mul(lowestBidPriceDeadLine).divRoundUp(10**8)

        );



        return toPayPlusSkip.toUint64();

    }



    /**

     * @notice In this auction process, all the bids are secretly submitted, and are revealed later on.

     * This function provides the form of hash commit.

     */

    function generateMultiSecret(

        bytes32 auctionID,

        uint64[] memory bids,

        uint64 random

    ) public override pure returns (bytes32 secret) {

        secret = keccak256(abi.encodePacked(auctionID, bids, random));

    }



    function deleteParticipantInfo(bytes32 auctionID, address participant)

        public

        override

    {

        require(

            msg.sender == address(_auctionContract),

            "only auction contract allow to invoke deleteParticipantInfo"

        );

        delete auctionParticipantInfo[auctionID][participant];

    }



    /**

     * @dev This function returns the price rounded off to the top 4 digits.

     */

    function discretizeBidPrice(uint64 priceE8)

        public

        override

        pure

        returns (uint64)

    {

        if (priceE8 < 5 * 10**8) {

            return priceE8.div(10**4).mul(10**4).toUint64();

        } else if (priceE8 < 5 * 10**9) {

            return priceE8.div(10**5).mul(10**5).toUint64();

        } else if (priceE8 < 5 * 10**10) {

            return priceE8.div(10**6).mul(10**6).toUint64();

        } else if (priceE8 < 5 * 10**11) {

            return priceE8.div(10**7).mul(10**7).toUint64();

        } else if (priceE8 < 5 * 10**12) {

            return priceE8.div(10**8).mul(10**8).toUint64();

        } else if (priceE8 < 5 * 10**13) {

            return priceE8.div(10**9).mul(10**9).toUint64();

        } else if (priceE8 < 5 * 10**14) {

            return priceE8.div(10**10).mul(10**10).toUint64();

        } else {

            return priceE8.div(10**11).mul(10**11).toUint64();

        }

    }



    function updateAuctionInfo(

        bytes32 auctionID,

        uint64 settledAmountE8,

        uint64 paidIDOLE8,

        uint64 rewardedSBTE8

    ) external override {

        require(

            msg.sender == address(_auctionContract),

            "only auction contract is allowed to invoke updateAuctionInfo"

        );

        _updateAuctionInfo(

            auctionID,

            settledAmountE8,

            paidIDOLE8,

            rewardedSBTE8

        );

    }



    /**

     *@notice updates AuctionInfo structure simultineously to make gas cheaper.

     */

    function _updateAuctionInfo(

        bytes32 auctionID,

        uint64 settledAmountE8,

        uint64 paidIDOLE8,

        uint64 rewardedSBTE8

    ) internal {

        AuctionInfo memory _auctionInfo = auctionInfo[auctionID];

        _auctionInfo.auctionSettledTotalE8 = _auctionInfo

            .auctionSettledTotalE8

            .add(settledAmountE8)

            .toUint64();

        // Calculate the cumulative amount of IDOL that is already paid and not to be returned.

        _auctionInfo.auctionPaidTotalE8 = _auctionInfo

            .auctionPaidTotalE8

            .add(paidIDOLE8)

            .toUint64();

        // Calculate the cumulative amount of SBT that is already decided to be distributed.

        _auctionInfo.auctionRewardedTotalE8 = _auctionInfo

            .auctionRewardedTotalE8

            .add(rewardedSBTE8)

            .toUint64();

        auctionInfo[auctionID] = _auctionInfo;

        emit LogAuctionInfoDiff(

            auctionID,

            settledAmountE8,

            paidIDOLE8,

            rewardedSBTE8

        );

    }



    /**

     * @dev get the bond information from the auctionID

     */

    function _getBondFromAuctionID(bytes32 auctionID)

        internal

        view

        returns (

            address erc20Address,

            uint256 maturity,

            uint64 stableStrikePrice,

            bytes32 fnMapID

        )

    {

        bytes32 bondID = _auctionContract.auctionID2BondID(auctionID);

        return _bondMakerContract.getBond(bondID);

    }



    /**

     * @notice this function is a view fuction for client side. The return value of this will be used and verified in makeAuctionResult.

     */

    function calcMyLowestPrice(

        bytes32 auctionID,

        uint64 winnerAmount,

        uint64[] calldata myLoseBids

    ) external view returns (uint64 myLowestPrice) {

        AuctionWinnerDetInfo memory endInfo = _auctionEndInfo[auctionID];

        myLowestPrice = uint64(-1);

        if (winnerAmount == 0) {

            return myLowestPrice;

        }



        uint256 restWinnerAmount = winnerAmount;

        uint256 myLoseBidsIndex = 0;

        for (

            uint256 priceIndex = endInfo.priceIndex;

            priceIndex < _auctionSortedPrice[auctionID].length;

            priceIndex++

        ) {

            uint64 price = _auctionSortedPrice[auctionID][priceIndex];





                uint64 totalSBTAmount

             = _auctionPrice2TotalSBTAmount[auctionID][price];



            if (priceIndex == endInfo.priceIndex) {

                // losing SBT amount at the lowest winning price (the highest losing price)

                if (totalSBTAmount == endInfo.auctionEndPriceWinnerSBTAmount) {

                    continue;

                }

                totalSBTAmount = totalSBTAmount

                    .sub(endInfo.auctionEndPriceWinnerSBTAmount)

                    .toUint64();

            }



            while (

                myLoseBidsIndex + 1 < myLoseBids.length &&

                myLoseBids[myLoseBidsIndex] == price

            ) {

                if (

                    priceIndex == endInfo.priceIndex &&

                    myLoseBids[myLoseBidsIndex + 1] == endInfo.boardIndex

                ) {

                    if (endInfo.loseSBTAmount != 0) {

                        restWinnerAmount = restWinnerAmount.add(

                            endInfo.loseSBTAmount

                        );

                        myLowestPrice = price;

                    }

                } else {



                        BidInfo memory bidInfo

                     = _auctionBoard[auctionID][price][myLoseBids[myLoseBidsIndex +

                        1]];

                    restWinnerAmount = restWinnerAmount.add(bidInfo.amount);

                    myLowestPrice = price;

                }

                myLoseBidsIndex += 2;

            }



            if (restWinnerAmount > totalSBTAmount) {

                restWinnerAmount = restWinnerAmount.sub(totalSBTAmount);

            } else {

                restWinnerAmount = 0;

                break;

            }

        }

    }



    /**

     * @notice removeSecret is only allowed by Auction Contract cancelBid function.

     */

    function removeSecret(

        bytes32 auctionID,

        bytes32 secret,

        uint64 subtractAmount

    ) external override {

        require(

            msg.sender == address(_auctionContract),

            "only auction contract is allowed to invoke removeSecret"

        );

        _removeSecret(auctionID, secret);

        if (subtractAmount != 0) {

            RevealingInfo storage revealInfo = auctionRevealInfo[auctionID];

            revealInfo.totalIDOLSecret = revealInfo

                .totalIDOLSecret

                .sub(subtractAmount)

                .toUint64();

        }

    }



    /**

     * Functions bellow are view functions.

     */



    function auctionBoard(

        bytes32 auctionID,

        uint64 bidPrice,

        uint256 boardIndex

    ) public override view returns (uint64 amount, address bidder) {

        require(

            boardIndex < _auctionBoard[auctionID][bidPrice].length,

            "out of index"

        );





            BidInfo storage bidInfo

         = _auctionBoard[auctionID][bidPrice][boardIndex];

        return (bidInfo.amount, bidInfo.bidder);

    }



    function getUnsortedBidPrice(bytes32 auctionID)

        external

        override

        view

        returns (uint64[] memory)

    {

        return _auctionUnsortedPrice[auctionID];

    }



    function getSortedBidPrice(bytes32 auctionID)

        external

        override

        view

        returns (uint64[] memory)

    {

        return _auctionSortedPrice[auctionID];

    }



    /**

     * @param auctionID is an auction ID.

     * @return price is the lowest winner price.

     * @return boardIndex is the maximum board index among the winner bids at the lowest price.

     * @return loseSBTAmount is the unsettled amount of the bid at the lowest price and the maximum

     * board index among the winner bids at the price.

     * @return auctionEndPriceWinnerSBTAmount is the total amount of SBTs that have been settled

     * at the lowest winner price.

     */

    function getEndInfo(bytes32 auctionID)

        external

        override

        view

        returns (

            uint64 price,

            uint64 boardIndex,

            uint64 loseSBTAmount,

            uint64 auctionEndPriceWinnerSBTAmount

        )

    {

        AuctionWinnerDetInfo memory endInfo = _auctionEndInfo[auctionID];

        if (!auctionDisposalInfo[auctionID].isEndInfoCreated) {

            // before executing makeEndInfo

            return (0, 0, 0, 0);

        }

        if (_auctionSortedPrice[auctionID].length == 0) {

            // no revealed bid

            return (0, 0, 0, 0);

        }



        // This function does not return the initial value of AuctionWinnerDetInfo except for the two cases above.



        price = _auctionSortedPrice[auctionID][endInfo.priceIndex];

        boardIndex = endInfo.boardIndex;

        loseSBTAmount = endInfo.loseSBTAmount;

        auctionEndPriceWinnerSBTAmount = endInfo.auctionEndPriceWinnerSBTAmount;

        require(

            !(price == 0 &&

                boardIndex == 0 &&

                loseSBTAmount == 0 &&

                auctionEndPriceWinnerSBTAmount == 0),

            "system error: the end info should not be initial value"

        );

    }



    function getBidderStatus(bytes32 auctionID, address bidder)

        external

        override

        view

        returns (uint64 toBack, bool isIDOLReturned)

    {

        toBack = auctionParticipantInfo[auctionID][bidder]

            .auctionLockedIDOLAmountE8;

        isIDOLReturned = (toBack != 0);

    }



    function getBoard(

        bytes32 auctionID,

        uint64 price,

        uint64 boardIndex

    ) external override view returns (address bidder, uint64 amount) {

        BidInfo memory bidInfo = _auctionBoard[auctionID][price][boardIndex];

        return (bidInfo.bidder, bidInfo.amount);

    }



    function getBoardStatus(bytes32 auctionID)

        external

        override

        view

        returns (uint64[] memory boardStatus)

    {

        uint256 priceCount = _auctionSortedPrice[auctionID].length;

        boardStatus = new uint64[](priceCount);

        for (uint256 i = 0; i < priceCount; i++) {

            uint64 price = _auctionSortedPrice[auctionID][i];

            boardStatus[i] = _auctionPrice2TotalSBTAmount[auctionID][price];

        }

    }

}

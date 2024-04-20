// File: contracts/util/TransferETHInterface.sol



pragma solidity 0.6.6;





interface TransferETHInterface {

    receive() external payable;



    event LogTransferETH(address indexed from, address indexed to, uint256 value);

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



// File: contracts/bondToken/BondTokenInterface.sol



pragma solidity 0.6.6;









interface BondTokenInterface is IERC20 {

    event LogExpire(uint128 rateNumerator, uint128 rateDenominator, bool firstTime);



    function mint(address account, uint256 amount) external returns (bool success);



    function expire(uint128 rateNumerator, uint128 rateDenominator)

        external

        returns (bool firstTime);



    function simpleBurn(address account, uint256 amount) external returns (bool success);



    function burn(uint256 amount) external returns (bool success);



    function burnAll() external returns (uint256 amount);



    function getRate() external view returns (uint128 rateNumerator, uint128 rateDenominator);

}



// File: contracts/oracle/LatestPriceOracleInterface.sol



pragma solidity 0.6.6;





/**

 * @dev Interface of the price oracle.

 */

interface LatestPriceOracleInterface {

    /**

     * @dev Returns `true`if oracle is working.

     */

    function isWorking() external returns (bool);



    /**

     * @dev Returns the last updated price. Decimals is 8.

     **/

    function latestPrice() external returns (uint256);



    /**

     * @dev Returns the timestamp of the last updated price.

     */

    function latestTimestamp() external returns (uint256);

}



// File: contracts/oracle/PriceOracleInterface.sol



pragma solidity 0.6.6;







/**

 * @dev Interface of the price oracle.

 */

interface PriceOracleInterface is LatestPriceOracleInterface {

    /**

     * @dev Returns the latest id. The id start from 1 and increments by 1.

     */

    function latestId() external returns (uint256);



    /**

     * @dev Returns the historical price specified by `id`. Decimals is 8.

     */

    function getPrice(uint256 id) external returns (uint256);



    /**

     * @dev Returns the timestamp of historical price specified by `id`.

     */

    function getTimestamp(uint256 id) external returns (uint256);

}



// File: contracts/math/AdvancedMath.sol



pragma solidity 0.6.6;





abstract contract AdvancedMath {

    /**

     * @dev sqrt(2*PI) * 10^8

     */

    int256 internal constant SQRT_2PI_E8 = 250662827;

    int256 internal constant PI_E8 = 314159265;

    int256 internal constant E_E8 = 271828182;

    int256 internal constant INV_E_E8 = 36787944; // 1/e

    int256 internal constant LOG2_E8 = 30102999;

    int256 internal constant LOG3_E8 = 47712125;



    int256 internal constant p = 23164190;

    int256 internal constant b1 = 31938153;

    int256 internal constant b2 = -35656378;

    int256 internal constant b3 = 178147793;

    int256 internal constant b4 = -182125597;

    int256 internal constant b5 = 133027442;



    /**

     * @dev Calcurate an approximate value of the square root of x by Babylonian method.

     */

    function _sqrt(int256 x) internal pure returns (int256 y) {

        require(x >= 0, "cannot calculate the square root of a negative number");

        int256 z = (x + 1) / 2;

        y = x;

        while (z < y) {

            y = z;

            z = (x / z + z) / 2;

        }

    }



    /**

     * @dev Returns log(x) for any positive x.

     */

    function _logTaylor(int256 inputE4) internal pure returns (int256 outputE4) {

        require(inputE4 > 1, "input should be positive number");

        int256 inputE8 = inputE4 * 10**4;

        // input x for _logTayler1 is adjusted to 1/e < x < 1.

        while (inputE8 < INV_E_E8) {

            inputE8 = (inputE8 * E_E8) / 10**8;

            outputE4 -= 10**4;

        }

        while (inputE8 > 10**8) {

            inputE8 = (inputE8 * INV_E_E8) / 10**8;

            outputE4 += 10**4;

        }

        outputE4 += _logTaylor1(inputE8 / 10**4 - 10**4);

    }



    /**s

     * @notice Calculate an approximate value of the logarithm of input value by

     * Taylor expansion around 1.

     * @dev log(x + 1) = x - 1/2 x^2 + 1/3 x^3 - 1/4 x^4 + 1/5 x^5

     *                     - 1/6 x^6 + 1/7 x^7 - 1/8 x^8 + ...

     */

    function _logTaylor1(int256 inputE4) internal pure returns (int256 outputE4) {

        outputE4 =

            inputE4 -

            inputE4**2 /

            (2 * 10**4) +

            inputE4**3 /

            (3 * 10**8) -

            inputE4**4 /

            (4 * 10**12) +

            inputE4**5 /

            (5 * 10**16) -

            inputE4**6 /

            (6 * 10**20) +

            inputE4**7 /

            (7 * 10**24) -

            inputE4**8 /

            (8 * 10**28);

    }



    /**

     * @notice Calculate the cumulative distribution function of standard normal

     * distribution.

     * @dev Abramowitz and Stegun, Handbook of Mathematical Functions (1964)

     * http://people.math.sfu.ca/~cbm/aands/

     */

    function _calcPnorm(int256 inputE4) internal pure returns (int256 outputE8) {

        require(inputE4 < 440 * 10**4 && inputE4 > -440 * 10**4, "input is too large");

        int256 _inputE4 = inputE4 > 0 ? inputE4 : inputE4 * (-1);

        int256 t = 10**16 / (10**8 + (p * _inputE4) / 10**4);

        int256 X2 = (inputE4 * inputE4) / 2;

        int256 exp2X2 = 10**8 +

            X2 +

            (X2**2 / (2 * 10**8)) +

            (X2**3 / (6 * 10**16)) +

            (X2**4 / (24 * 10**24)) +

            (X2**5 / (120 * 10**32)) +

            (X2**6 / (720 * 10**40));

        int256 Z = (10**24 / exp2X2) / SQRT_2PI_E8;

        int256 y = (b5 * t) / 10**8;

        y = ((y + b4) * t) / 10**8;

        y = ((y + b3) * t) / 10**8;

        y = ((y + b2) * t) / 10**8;

        y = 10**8 - (Z * ((y + b1) * t)) / 10**16;

        return inputE4 > 0 ? y : 10**8 - y;

    }

}



// File: contracts/decentralizedOtc/CallOptionCalculator.sol



pragma solidity 0.6.6;







contract CallOptionCalculator is AdvancedMath {

    /**

     * @dev sqrt(365*86400) * 10^8

     */

    int256 internal constant SQRT_YEAR_E8 = 561569229926;



    int256 internal constant MIN_ND1_E8 = 0.0001 * 10**8;

    int256 internal constant MAX_ND1_E8 = 0.9999 * 10**8;



    function _calcLbtPrice(

        int256 etherPriceE4,

        int256 strikePriceE4,

        int256 nd1E8,

        int256 nd2E8

    ) public pure returns (int256 lbtPriceE4) {

        int256 lowestPriceE4 = (etherPriceE4 > strikePriceE4) ? etherPriceE4 - strikePriceE4 : 0; // max(etherPriceE8 - strikePriceE8, 0)

        lbtPriceE4 = (etherPriceE4 * (nd1E8) - (strikePriceE4 * nd2E8)) / 10**8; // mutable

        if (lbtPriceE4 < lowestPriceE4) {

            lbtPriceE4 = lowestPriceE4; // max(lbtPriceE8, lowestPriceE8)

        }

    }



    function _calcLbtLeverage(

        uint256 etherPriceE4,

        uint256 lbtPriceE4,

        int256 nd1E8

    ) public pure returns (uint256 lbtLeverageE4) {

        int256 modifiedNd1E8 = nd1E8 < MIN_ND1_E8 ? MIN_ND1_E8 : nd1E8 > MAX_ND1_E8

            ? MAX_ND1_E8

            : nd1E8; // clamp(MIN_ND1, nd1E4, MAX_ND1)

        return

            lbtPriceE4 != 0

                ? (uint256(modifiedNd1E8) * (etherPriceE4)) / (lbtPriceE4) / 10**4

                : 100 * 10**4;

    }



    /**

     * @dev

     * s := v * sqrt(t / (365 * 86400))

     * d1 := log(S/K) / s + s / 2

     * d2 := d1 - s

     * price := S * N(d1) - K * N(d2)

     */

    function calcLbtPriceAndLeverage(

        int256 etherPriceE4,

        int256 strikePriceE4,

        int256 ethVolatilityE8,

        int256 untilMaturity

    )

        public

        pure

        returns (

            uint256 priceE4,

            uint256 leverageE4,

            int256 sigE8

        )

    {

        require(etherPriceE4 > 0, "the price of ETH should be positive");

        require(ethVolatilityE8 > 0, "the volatility of ETH should be positive");

        require(strikePriceE4 > 0, "the strike price should be positive");

        require(untilMaturity >= 0, "LBT should not have expired");

        require(untilMaturity <= 12 weeks, "the maturity of LBT should not be so distant");



        int256 nd1E8;

        {

            int256 spotPerStrikeE4 = (etherPriceE4 * (10**4)) / strikePriceE4;

            sigE8 = (ethVolatilityE8 * (_sqrt(untilMaturity)) * (10**8)) / (SQRT_YEAR_E8);



            int256 logSigE4 = _logTaylor(spotPerStrikeE4);

            int256 d1E4 = ((logSigE4 * 10**8) / sigE8) + (sigE8 / (2 * 10**4));

            nd1E8 = _calcPnorm(d1E4);



            int256 d2E4 = d1E4 - (sigE8 / 10**4);

            int256 nd2E8 = _calcPnorm(d2E4);

            if (nd1E8 > 0.0001 * 10**8 && nd2E8 > 0.0001 * 10**8) {

                int256 lbtPriceE4 = _calcLbtPrice(etherPriceE4, strikePriceE4, nd1E8, nd2E8);

                priceE4 = uint256(lbtPriceE4);

            }

        }



        leverageE4 = _calcLbtLeverage(uint256(etherPriceE4), priceE4, nd1E8);



        return (priceE4, leverageE4, sigE8);

    }

}



// File: contracts/util/TransferETH.sol



pragma solidity 0.6.6;







abstract contract TransferETH is TransferETHInterface {

    receive() external override payable {

        emit LogTransferETH(msg.sender, address(this), msg.value);

    }



    function _hasSufficientBalance(uint256 amount) internal view returns (bool ok) {

        address thisContract = address(this);

        return amount <= thisContract.balance;

    }



    /**

     * @notice transfer `amount` ETH to the `recipient` account with emitting log

     */

    function _transferETH(

        address payable recipient,

        uint256 amount,

        string memory errorMessage

    ) internal {

        require(_hasSufficientBalance(amount), errorMessage);

        (bool success, ) = recipient.call{value: amount}("");

        require(success, "transferring Ether failed");

        emit LogTransferETH(address(this), recipient, amount);

    }



    function _transferETH(address payable recipient, uint256 amount) internal {

        _transferETH(recipient, amount, "TransferETH: transfer amount exceeds balance");

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

 * In addition, one can use SignedSafeMath and SafeCast.toUint256(int256) for int256.

 * In the case of the operation to the uint64 value, one needs to cast the value into int256 in

 * advance to use `sub` as SignedSafeMath.sub not SafeMath.sub.

 * For example:

 *   int256 a = 1;

 *   uint64 b = 2;

 *   int256 c = 3;

 *   a = a.add(int256(b).sub(c)); // `a` becomes 0 as int256

 *   b = a.toUint256().toUint64(); // `b` becomes 0 as uint64

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



// File: contracts/bondMaker/BondMakerInterface.sol



pragma solidity 0.6.6;





interface BondMakerInterface {

    event LogNewBond(

        bytes32 indexed bondID,

        address indexed bondTokenAddress,

        uint256 indexed maturity,

        bytes32 fnMapID

    );



    event LogNewBondGroup(

        uint256 indexed bondGroupID,

        uint256 indexed maturity,

        uint64 indexed sbtStrikePrice,

        bytes32[] bondIDs

    );



    event LogIssueNewBonds(uint256 indexed bondGroupID, address indexed issuer, uint256 amount);



    event LogReverseBondGroupToCollateral(

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



    event LogLiquidateBond(bytes32 indexed bondID, uint128 rateNumerator, uint128 rateDenominator);



    function registerNewBond(uint256 maturity, bytes calldata fnMap)

        external

        returns (

            bytes32 bondID,

            address bondTokenAddress,

            bytes32 fnMapID

        );



    function registerNewBondGroup(bytes32[] calldata bondIDList, uint256 maturity)

        external

        returns (uint256 bondGroupID);



    function reverseBondGroupToCollateral(uint256 bondGroupID, uint256 amount)

        external

        returns (bool success);



    function exchangeEquivalentBonds(

        uint256 inputBondGroupID,

        uint256 outputBondGroupID,

        uint256 amount,

        bytes32[] calldata exceptionBonds

    ) external returns (bool);



    function liquidateBond(uint256 bondGroupID, uint256 oracleHintID)

        external

        returns (uint256 totalPayment);



    function collateralAddress() external view returns (address);



    function oracleAddress() external view returns (address);



    function feeTaker() external view returns (address);



    function decimalsOfBond() external view returns (uint8);



    function decimalsOfOraclePrice() external view returns (uint8);



    function maturityScale() external view returns (uint256);



    function getBond(bytes32 bondID)

        external

        view

        returns (

            address bondAddress,

            uint256 maturity,

            uint64 solidStrikePrice,

            bytes32 fnMapID

        );



    function getFnMap(bytes32 fnMapID) external view returns (bytes memory fnMap);



    function getBondGroup(uint256 bondGroupID)

        external

        view

        returns (bytes32[] memory bondIDs, uint256 maturity);



    function generateFnMapID(bytes calldata fnMap) external view returns (bytes32 fnMapID);



    function generateBondID(uint256 maturity, bytes calldata fnMap)

        external

        view

        returns (bytes32 bondID);

}



// File: contracts/bondMaker/BondMakerCollateralizedErc20Interface.sol



pragma solidity 0.6.6;







interface BondMakerCollateralizedErc20Interface is BondMakerInterface {

    function issueNewBonds(uint256 bondGroupID) external returns (uint256 amount);

}



// File: contracts/util/Time.sol



pragma solidity 0.6.6;





abstract contract Time {

    function _getBlockTimestampSec() internal view returns (uint256 unixtimesec) {

        unixtimesec = now; // solium-disable-line security/no-block-members

    }

}



// File: @openzeppelin/contracts/GSN/Context.sol



pragma solidity ^0.6.0;



/*

 * @dev Provides information about the current execution context, including the

 * sender of the transaction and its data. While these are generally available

 * via msg.sender and msg.data, they should not be accessed in such a direct

 * manner, since when dealing with GSN meta-transactions the account sending and

 * paying for execution may not be the actual sender (as far as an application

 * is concerned).

 *

 * This contract is only required for intermediate, library-like contracts.

 */

contract Context {

    // Empty internal constructor, to prevent people from mistakenly deploying

    // an instance of this contract, which should be used via inheritance.

    constructor () internal { }



    function _msgSender() internal view virtual returns (address payable) {

        return msg.sender;

    }



    function _msgData() internal view virtual returns (bytes memory) {

        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691

        return msg.data;

    }

}



// File: @openzeppelin/contracts/utils/Address.sol



pragma solidity ^0.6.2;



/**

 * @dev Collection of functions related to the address type

 */

library Address {

    /**

     * @dev Returns true if `account` is a contract.

     *

     * [IMPORTANT]

     * ====

     * It is unsafe to assume that an address for which this function returns

     * false is an externally-owned account (EOA) and not a contract.

     *

     * Among others, `isContract` will return false for the following

     * types of addresses:

     *

     *  - an externally-owned account

     *  - a contract in construction

     *  - an address where a contract will be created

     *  - an address where a contract lived, but was destroyed

     * ====

     */

    function isContract(address account) internal view returns (bool) {

        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts

        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned

        // for accounts without code, i.e. `keccak256('')`

        bytes32 codehash;

        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;

        // solhint-disable-next-line no-inline-assembly

        assembly { codehash := extcodehash(account) }

        return (codehash != accountHash && codehash != 0x0);

    }



    /**

     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to

     * `recipient`, forwarding all available gas and reverting on errors.

     *

     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost

     * of certain opcodes, possibly making contracts go over the 2300 gas limit

     * imposed by `transfer`, making them unable to receive funds via

     * `transfer`. {sendValue} removes this limitation.

     *

     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].

     *

     * IMPORTANT: because control is transferred to `recipient`, care must be

     * taken to not create reentrancy vulnerabilities. Consider using

     * {ReentrancyGuard} or the

     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].

     */

    function sendValue(address payable recipient, uint256 amount) internal {

        require(address(this).balance >= amount, "Address: insufficient balance");



        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value

        (bool success, ) = recipient.call{ value: amount }("");

        require(success, "Address: unable to send value, recipient may have reverted");

    }

}



// File: @openzeppelin/contracts/token/ERC20/ERC20.sol



pragma solidity ^0.6.0;











/**

 * @dev Implementation of the {IERC20} interface.

 *

 * This implementation is agnostic to the way tokens are created. This means

 * that a supply mechanism has to be added in a derived contract using {_mint}.

 * For a generic mechanism see {ERC20MinterPauser}.

 *

 * TIP: For a detailed writeup see our guide

 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How

 * to implement supply mechanisms].

 *

 * We have followed general OpenZeppelin guidelines: functions revert instead

 * of returning `false` on failure. This behavior is nonetheless conventional

 * and does not conflict with the expectations of ERC20 applications.

 *

 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.

 * This allows applications to reconstruct the allowance for all accounts just

 * by listening to said events. Other implementations of the EIP may not emit

 * these events, as it isn't required by the specification.

 *

 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}

 * functions have been added to mitigate the well-known issues around setting

 * allowances. See {IERC20-approve}.

 */

contract ERC20 is Context, IERC20 {

    using SafeMath for uint256;

    using Address for address;



    mapping (address => uint256) private _balances;



    mapping (address => mapping (address => uint256)) private _allowances;



    uint256 private _totalSupply;



    string private _name;

    string private _symbol;

    uint8 private _decimals;



    /**

     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with

     * a default value of 18.

     *

     * To select a different value for {decimals}, use {_setupDecimals}.

     *

     * All three of these values are immutable: they can only be set once during

     * construction.

     */

    constructor (string memory name, string memory symbol) public {

        _name = name;

        _symbol = symbol;

        _decimals = 18;

    }



    /**

     * @dev Returns the name of the token.

     */

    function name() public view returns (string memory) {

        return _name;

    }



    /**

     * @dev Returns the symbol of the token, usually a shorter version of the

     * name.

     */

    function symbol() public view returns (string memory) {

        return _symbol;

    }



    /**

     * @dev Returns the number of decimals used to get its user representation.

     * For example, if `decimals` equals `2`, a balance of `505` tokens should

     * be displayed to a user as `5,05` (`505 / 10 ** 2`).

     *

     * Tokens usually opt for a value of 18, imitating the relationship between

     * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is

     * called.

     *

     * NOTE: This information is only used for _display_ purposes: it in

     * no way affects any of the arithmetic of the contract, including

     * {IERC20-balanceOf} and {IERC20-transfer}.

     */

    function decimals() public view returns (uint8) {

        return _decimals;

    }



    /**

     * @dev See {IERC20-totalSupply}.

     */

    function totalSupply() public view override returns (uint256) {

        return _totalSupply;

    }



    /**

     * @dev See {IERC20-balanceOf}.

     */

    function balanceOf(address account) public view override returns (uint256) {

        return _balances[account];

    }



    /**

     * @dev See {IERC20-transfer}.

     *

     * Requirements:

     *

     * - `recipient` cannot be the zero address.

     * - the caller must have a balance of at least `amount`.

     */

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {

        _transfer(_msgSender(), recipient, amount);

        return true;

    }



    /**

     * @dev See {IERC20-allowance}.

     */

    function allowance(address owner, address spender) public view virtual override returns (uint256) {

        return _allowances[owner][spender];

    }



    /**

     * @dev See {IERC20-approve}.

     *

     * Requirements:

     *

     * - `spender` cannot be the zero address.

     */

    function approve(address spender, uint256 amount) public virtual override returns (bool) {

        _approve(_msgSender(), spender, amount);

        return true;

    }



    /**

     * @dev See {IERC20-transferFrom}.

     *

     * Emits an {Approval} event indicating the updated allowance. This is not

     * required by the EIP. See the note at the beginning of {ERC20};

     *

     * Requirements:

     * - `sender` and `recipient` cannot be the zero address.

     * - `sender` must have a balance of at least `amount`.

     * - the caller must have allowance for ``sender``'s tokens of at least

     * `amount`.

     */

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {

        _transfer(sender, recipient, amount);

        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));

        return true;

    }



    /**

     * @dev Atomically increases the allowance granted to `spender` by the caller.

     *

     * This is an alternative to {approve} that can be used as a mitigation for

     * problems described in {IERC20-approve}.

     *

     * Emits an {Approval} event indicating the updated allowance.

     *

     * Requirements:

     *

     * - `spender` cannot be the zero address.

     */

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {

        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));

        return true;

    }



    /**

     * @dev Atomically decreases the allowance granted to `spender` by the caller.

     *

     * This is an alternative to {approve} that can be used as a mitigation for

     * problems described in {IERC20-approve}.

     *

     * Emits an {Approval} event indicating the updated allowance.

     *

     * Requirements:

     *

     * - `spender` cannot be the zero address.

     * - `spender` must have allowance for the caller of at least

     * `subtractedValue`.

     */

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {

        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));

        return true;

    }



    /**

     * @dev Moves tokens `amount` from `sender` to `recipient`.

     *

     * This is internal function is equivalent to {transfer}, and can be used to

     * e.g. implement automatic token fees, slashing mechanisms, etc.

     *

     * Emits a {Transfer} event.

     *

     * Requirements:

     *

     * - `sender` cannot be the zero address.

     * - `recipient` cannot be the zero address.

     * - `sender` must have a balance of at least `amount`.

     */

    function _transfer(address sender, address recipient, uint256 amount) internal virtual {

        require(sender != address(0), "ERC20: transfer from the zero address");

        require(recipient != address(0), "ERC20: transfer to the zero address");



        _beforeTokenTransfer(sender, recipient, amount);



        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");

        _balances[recipient] = _balances[recipient].add(amount);

        emit Transfer(sender, recipient, amount);

    }



    /** @dev Creates `amount` tokens and assigns them to `account`, increasing

     * the total supply.

     *

     * Emits a {Transfer} event with `from` set to the zero address.

     *

     * Requirements

     *

     * - `to` cannot be the zero address.

     */

    function _mint(address account, uint256 amount) internal virtual {

        require(account != address(0), "ERC20: mint to the zero address");



        _beforeTokenTransfer(address(0), account, amount);



        _totalSupply = _totalSupply.add(amount);

        _balances[account] = _balances[account].add(amount);

        emit Transfer(address(0), account, amount);

    }



    /**

     * @dev Destroys `amount` tokens from `account`, reducing the

     * total supply.

     *

     * Emits a {Transfer} event with `to` set to the zero address.

     *

     * Requirements

     *

     * - `account` cannot be the zero address.

     * - `account` must have at least `amount` tokens.

     */

    function _burn(address account, uint256 amount) internal virtual {

        require(account != address(0), "ERC20: burn from the zero address");



        _beforeTokenTransfer(account, address(0), amount);



        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");

        _totalSupply = _totalSupply.sub(amount);

        emit Transfer(account, address(0), amount);

    }



    /**

     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.

     *

     * This is internal function is equivalent to `approve`, and can be used to

     * e.g. set automatic allowances for certain subsystems, etc.

     *

     * Emits an {Approval} event.

     *

     * Requirements:

     *

     * - `owner` cannot be the zero address.

     * - `spender` cannot be the zero address.

     */

    function _approve(address owner, address spender, uint256 amount) internal virtual {

        require(owner != address(0), "ERC20: approve from the zero address");

        require(spender != address(0), "ERC20: approve to the zero address");



        _allowances[owner][spender] = amount;

        emit Approval(owner, spender, amount);

    }



    /**

     * @dev Sets {decimals} to a value other than the default one of 18.

     *

     * WARNING: This function should only be called from the constructor. Most

     * applications that interact with token contracts will not expect

     * {decimals} to ever change, and may work incorrectly if it does.

     */

    function _setupDecimals(uint8 decimals_) internal {

        _decimals = decimals_;

    }



    /**

     * @dev Hook that is called before any transfer of tokens. This includes

     * minting and burning.

     *

     * Calling conditions:

     *

     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens

     * will be to transferred to `to`.

     * - when `from` is zero, `amount` tokens will be minted for `to`.

     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.

     * - `from` and `to` are never both zero.

     *

     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].

     */

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }

}



// File: @openzeppelin/contracts/access/Ownable.sol



pragma solidity ^0.6.0;



/**

 * @dev Contract module which provides a basic access control mechanism, where

 * there is an account (an owner) that can be granted exclusive access to

 * specific functions.

 *

 * By default, the owner account will be the one that deploys the contract. This

 * can later be changed with {transferOwnership}.

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

        address msgSender = _msgSender();

        _owner = msgSender;

        emit OwnershipTransferred(address(0), msgSender);

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

        require(_owner == _msgSender(), "Ownable: caller is not the owner");

        _;

    }



    /**

     * @dev Leaves the contract without owner. It will not be possible to call

     * `onlyOwner` functions anymore. Can only be called by the current owner.

     *

     * NOTE: Renouncing ownership will leave the contract without an owner,

     * thereby removing any functionality that is only available to the owner.

     */

    function renounceOwnership() public virtual onlyOwner {

        emit OwnershipTransferred(_owner, address(0));

        _owner = address(0);

    }



    /**

     * @dev Transfers ownership of the contract to a new account (`newOwner`).

     * Can only be called by the current owner.

     */

    function transferOwnership(address newOwner) public virtual onlyOwner {

        require(newOwner != address(0), "Ownable: new owner is the zero address");

        emit OwnershipTransferred(_owner, newOwner);

        _owner = newOwner;

    }

}



// File: contracts/bondToken/BondToken.sol



pragma solidity 0.6.6;













abstract contract BondToken is Ownable, BondTokenInterface, ERC20 {

    struct Frac128x128 {

        uint128 numerator;

        uint128 denominator;

    }



    Frac128x128 internal _rate;



    constructor(

        string memory name,

        string memory symbol,

        uint8 decimals

    ) public ERC20(name, symbol) {

        _setupDecimals(decimals);

    }



    function mint(address account, uint256 amount)

        public

        virtual

        override

        onlyOwner

        returns (bool success)

    {

        require(!_isExpired(), "this token contract has expired");

        _mint(account, amount);

        return true;

    }



    function transfer(address recipient, uint256 amount)

        public

        override(ERC20, IERC20)

        returns (bool success)

    {

        _transfer(msg.sender, recipient, amount);

        return true;

    }



    function transferFrom(

        address sender,

        address recipient,

        uint256 amount

    ) public override(ERC20, IERC20) returns (bool success) {

        _transfer(sender, recipient, amount);

        _approve(

            sender,

            msg.sender,

            allowance(sender, msg.sender).sub(amount, "ERC20: transfer amount exceeds allowance")

        );

        return true;

    }



    /**

     * @dev Record the settlement price at maturity in the form of a fraction and let the bond

     * token expire.

     */

    function expire(uint128 rateNumerator, uint128 rateDenominator)

        public

        override

        onlyOwner

        returns (bool isFirstTime)

    {

        isFirstTime = !_isExpired();

        if (isFirstTime) {

            _setRate(Frac128x128(rateNumerator, rateDenominator));

        }



        emit LogExpire(rateNumerator, rateDenominator, isFirstTime);

    }



    function simpleBurn(address from, uint256 amount) public override onlyOwner returns (bool) {

        if (amount > balanceOf(from)) {

            return false;

        }



        _burn(from, amount);

        return true;

    }



    function burn(uint256 amount) public override returns (bool success) {

        if (!_isExpired()) {

            return false;

        }



        _burn(msg.sender, amount);



        if (_rate.numerator != 0) {

            uint8 decimalsOfCollateral = _getCollateralDecimals();

            uint256 withdrawAmount = _applyDecimalGap(amount, decimals(), decimalsOfCollateral)

                .mul(_rate.numerator)

                .div(_rate.denominator);



            _sendCollateralTo(msg.sender, withdrawAmount);

        }



        return true;

    }



    function burnAll() public override returns (uint256 amount) {

        amount = balanceOf(msg.sender);

        bool success = burn(amount);

        if (!success) {

            amount = 0;

        }

    }



    /**

     * @dev rateDenominator never be zero due to div() function, thus initial _rateDenominator is 0

     * can be used for flag of non-expired;

     */

    function _isExpired() internal view returns (bool) {

        return _rate.denominator != 0;

    }



    function getRate()

        public

        override

        view

        returns (uint128 rateNumerator, uint128 rateDenominator)

    {

        rateNumerator = _rate.numerator;

        rateDenominator = _rate.denominator;

    }



    function _setRate(Frac128x128 memory rate) internal {

        require(

            rate.denominator != 0,

            "system error: the exchange rate must be non-negative number"

        );

        _rate = rate;

    }



    /**

     * @dev removes a decimal gap from rate.

     */

    function _applyDecimalGap(

        uint256 baseAmount,

        uint8 decimalsOfBase,

        uint8 decimalsOfQuote

    ) internal pure returns (uint256 quoteAmount) {

        uint256 n;

        uint256 d;



        if (decimalsOfBase > decimalsOfQuote) {

            d = decimalsOfBase - decimalsOfQuote;

        } else if (decimalsOfBase < decimalsOfQuote) {

            n = decimalsOfQuote - decimalsOfBase;

        }



        // The consequent multiplication would overflow under extreme and non-blocking circumstances.

        require(n < 19 && d < 19, "decimal gap needs to be lower than 19");

        quoteAmount = baseAmount.mul(10**n).div(10**d);

    }



    function _getCollateralDecimals() internal virtual view returns (uint8);



    function _sendCollateralTo(address receiver, uint256 amount) internal virtual;

}



// File: contracts/bondToken/BondTokenCollateralizedErc20.sol



pragma solidity 0.6.6;







contract BondTokenCollateralizedErc20 is BondToken {

    ERC20 internal immutable COLLATERALIZED_TOKEN;



    constructor(

        address collateralizedTokenAddress,

        string memory name,

        string memory symbol,

        uint8 decimals

    ) public BondToken(name, symbol, decimals) {

        COLLATERALIZED_TOKEN = ERC20(collateralizedTokenAddress);

    }



    function _getCollateralDecimals() internal override view returns (uint8) {

        return COLLATERALIZED_TOKEN.decimals();

    }



    function _sendCollateralTo(address receiver, uint256 amount) internal override {

        COLLATERALIZED_TOKEN.transfer(receiver, amount);

    }

}



// File: contracts/bondToken/BondTokenCollateralizedEth.sol



pragma solidity 0.6.6;









contract BondTokenCollateralizedEth is BondToken, TransferETH {

    constructor(

        string memory name,

        string memory symbol,

        uint8 decimals

    ) public BondToken(name, symbol, decimals) {}



    function _getCollateralDecimals() internal override view returns (uint8) {

        return 18;

    }



    function _sendCollateralTo(address receiver, uint256 amount) internal override {

        _transferETH(payable(receiver), amount);

    }

}



// File: contracts/bondToken/BondTokenFactory.sol



pragma solidity 0.6.6;









contract BondTokenFactory {

    address private constant ETH = address(0);



    function createBondToken(

        address collateralizedTokenAddress,

        string calldata name,

        string calldata symbol,

        uint8 decimals

    ) external returns (address) {

        if (collateralizedTokenAddress == ETH) {

            BondTokenCollateralizedEth bond = new BondTokenCollateralizedEth(

                name,

                symbol,

                decimals

            );

            bond.transferOwnership(msg.sender);

            return address(bond);

        } else {

            BondTokenCollateralizedErc20 bond = new BondTokenCollateralizedErc20(

                collateralizedTokenAddress,

                name,

                symbol,

                decimals

            );

            bond.transferOwnership(msg.sender);

            return address(bond);

        }

    }

}



// File: contracts/util/Polyline.sol



pragma solidity 0.6.6;







contract Polyline is UseSafeMath {

    struct Point {

        uint64 x; // Value of the x-axis of the x-y plane

        uint64 y; // Value of the y-axis of the x-y plane

    }



    struct LineSegment {

        Point left; // The left end of the line definition range

        Point right; // The right end of the line definition range

    }



    /**

     * @notice Return the value of y corresponding to x on the given line. line in the form of

     * a rational number (numerator / denominator).

     * If you treat a line as a line segment instead of a line, you should run

     * includesDomain(line, x) to check whether x is included in the line's domain or not.

     * @dev To guarantee accuracy, the bit length of the denominator must be greater than or equal

     * to the bit length of x, and the bit length of the numerator must be greater than or equal

     * to the sum of the bit lengths of x and y.

     */

    function _mapXtoY(LineSegment memory line, uint64 x)

        internal

        pure

        returns (uint128 numerator, uint64 denominator)

    {

        int256 x1 = int256(line.left.x);

        int256 y1 = int256(line.left.y);

        int256 x2 = int256(line.right.x);

        int256 y2 = int256(line.right.y);



        require(x2 > x1, "must be left.x < right.x");



        denominator = uint64(x2 - x1);



        // Calculate y = ((x2 - x) * y1 + (x - x1) * y2) / (x2 - x1)

        // in the form of a fraction (numerator / denominator).

        int256 n = (x - x1) * y2 + (x2 - x) * y1;



        require(n >= 0, "underflow n");

        require(n < 2**128, "system error: overflow n");

        numerator = uint128(n);

    }



    /**

     * @notice Checking that a line segment is a valid format.

     */

    function assertLineSegment(LineSegment memory segment) internal pure {

        uint64 x1 = segment.left.x;

        uint64 x2 = segment.right.x;

        require(x1 < x2, "must be left.x < right.x");

    }



    /**

     * @notice Checking that a polyline is a valid format.

     */

    function assertPolyline(LineSegment[] memory polyline) internal pure {

        uint256 numOfSegment = polyline.length;

        require(numOfSegment != 0, "polyline must not be empty array");



        // About the first line segment.

        LineSegment memory firstSegment = polyline[0];



        // The beginning of the first line segment's domain is 0.

        require(

            firstSegment.left.x == uint64(0),

            "the x coordinate of left end of the first segment must be 0"

        );

        // The value of y when x is 0 is 0.

        require(

            firstSegment.left.y == uint64(0),

            "the y coordinate of left end of the first segment must be 0"

        );



        // About the last line segment.

        LineSegment memory lastSegment = polyline[numOfSegment - 1];



        // The slope of the last line segment should be between 0 and 1.

        int256 gradientNumerator = int256(lastSegment.right.y).sub(lastSegment.left.y);

        int256 gradientDenominator = int256(lastSegment.right.x).sub(lastSegment.left.x);

        require(

            gradientNumerator >= 0 && gradientNumerator <= gradientDenominator,

            "the gradient of last line segment must be non-negative, and equal to or less than 1"

        );



        // Making sure that the first line segment is a correct format.

        assertLineSegment(firstSegment);



        // The end of the domain of a segment and the beginning of the domain of the adjacent

        // segment must coincide.

        for (uint256 i = 1; i < numOfSegment; i++) {

            LineSegment memory leftSegment = polyline[i - 1];

            LineSegment memory rightSegment = polyline[i];



            // Make sure that the i-th line segment is a correct format.

            assertLineSegment(rightSegment);



            // Checking that the x-coordinates are same.

            require(

                leftSegment.right.x == rightSegment.left.x,

                "given polyline has an undefined domain."

            );



            // Checking that the y-coordinates are same.

            require(

                leftSegment.right.y == rightSegment.left.y,

                "given polyline is not a continuous function"

            );

        }

    }



    /**

     * @notice zip a LineSegment structure to uint256

     * @return zip uint256( 0 ... 0 | x1 | y1 | x2 | y2 )

     */

    function zipLineSegment(LineSegment memory segment) internal pure returns (uint256 zip) {

        uint256 x1U256 = uint256(segment.left.x) << (64 + 64 + 64); // uint64

        uint256 y1U256 = uint256(segment.left.y) << (64 + 64); // uint64

        uint256 x2U256 = uint256(segment.right.x) << 64; // uint64

        uint256 y2U256 = uint256(segment.right.y); // uint64

        zip = x1U256 | y1U256 | x2U256 | y2U256;

    }



    /**

     * @notice unzip uint256 to a LineSegment structure

     */

    function unzipLineSegment(uint256 zip) internal pure returns (LineSegment memory) {

        uint64 x1 = uint64(zip >> (64 + 64 + 64));

        uint64 y1 = uint64(zip >> (64 + 64));

        uint64 x2 = uint64(zip >> 64);

        uint64 y2 = uint64(zip);

        return LineSegment({left: Point({x: x1, y: y1}), right: Point({x: x2, y: y2})});

    }



    /**

     * @notice unzip the fnMap to uint256[].

     */

    function decodePolyline(bytes memory fnMap) internal pure returns (uint256[] memory) {

        return abi.decode(fnMap, (uint256[]));

    }

}



// File: contracts/oracle/OracleInterface.sol



pragma solidity ^0.6.6;







// Oracle referenced by OracleProxy must implement this interface.

interface OracleInterface is PriceOracleInterface {

    function getVolatility() external returns (uint256);



    function lastCalculatedVolatility() external view returns (uint256);

}



// File: contracts/oracle/UseOracle.sol



pragma solidity 0.6.6;







abstract contract UseOracle {

    OracleInterface internal _oracleContract;



    constructor(address contractAddress) public {

        require(contractAddress != address(0), "contract should be non-zero address");

        _oracleContract = OracleInterface(contractAddress);

    }

    /**

     * @notice Get the latest price (USD) and historical volatility using oracle.

     * @dev If the oracle is not working, `latestPrice()` reverts.

     * @return priceE8 (10^-8 USD)

     * @return volatilityE8 (10^-8)

     */

    function _getOracleData() internal returns (uint256 priceE8, uint256 volatilityE8) {

        priceE8 = _oracleContract.latestPrice();

        volatilityE8 = _oracleContract.lastCalculatedVolatility();



        return (priceE8, volatilityE8);

    }

    /**

     * @notice Get the price of the oracle data with a minimum timestamp that does more than input value

     * when you know the ID you are looking for.

     * @param timestamp is the timestamp that you want to get price.

     * @param hintID is the ID of the oracle data you are looking for.

     * @return priceE8 (10^-8 USD)

     */

    function _getPriceOn(uint256 timestamp, uint256 hintID) internal returns (uint256 priceE8) {

        uint256 latestID = _oracleContract.latestId();

        require(latestID != 0, "system error: the ID of oracle data should not be zero");



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



// File: contracts/bondTokenName/BondTokenNameInterface.sol



pragma solidity ^0.6.6;





/**

 * @title bond token name contract interface

 */

interface BondTokenNameInterface {

    function genBondTokenName(

        string calldata shortNamePrefix,

        string calldata longNamePrefix,

        uint256 maturity,

        uint256 solidStrikePriceE4

    ) external pure returns (string memory shortName, string memory longName);



    function getBondTokenName(

        uint256 maturity,

        uint256 solidStrikePriceE4,

        uint256 rateLBTWorthlessE4

    ) external pure returns (string memory shortName, string memory longName);

}



// File: contracts/bondTokenName/UseBondTokenName.sol



pragma solidity 0.6.6;







abstract contract UseBondTokenName {

    BondTokenNameInterface internal immutable _bondTokenNameContract;



    constructor(address contractAddress) public {

        require(contractAddress != address(0), "contract should be non-zero address");

        _bondTokenNameContract = BondTokenNameInterface(contractAddress);

    }

}



// File: contracts/bondMaker/BondMaker.sol



pragma solidity 0.6.6;



















abstract contract BondMaker is UseSafeMath, BondMakerInterface, Time, Polyline, UseOracle {

    uint8 internal immutable DECIMALS_OF_BOND;

    uint8 internal immutable DECIMALS_OF_ORACLE_PRICE;

    address internal immutable FEE_TAKER;

    uint256 internal immutable MATURITY_SCALE;



    uint256 public nextBondGroupID = 1;



    /**

     * @dev The contents in this internal storage variable can be seen by getBond function.

     */

    struct BondInfo {

        uint256 maturity;

        BondTokenInterface contractInstance;

        uint64 strikePrice;

        bytes32 fnMapID;

    }

    mapping(bytes32 => BondInfo) internal _bonds;



    /**

     * @notice mapping fnMapID to polyline

     * @dev The contents in this internal storage variable can be seen by getFnMap function.

     */

    mapping(bytes32 => LineSegment[]) internal _registeredFnMap;



    /**

     * @dev The contents in this internal storage variable can be seen by getBondGroup function.

     */

    struct BondGroup {

        bytes32[] bondIDs;

        uint256 maturity;

    }

    mapping(uint256 => BondGroup) internal _bondGroupList;



    constructor(

        address oracleAddress,

        address feeTaker,

        uint256 maturityScale,

        uint8 decimalsOfBond,

        uint8 decimalsOfOraclePrice

    ) public UseOracle(oracleAddress) {

        require(decimalsOfBond < 19, "the decimals of bond must be less than 19");

        DECIMALS_OF_BOND = decimalsOfBond;

        require(decimalsOfOraclePrice < 19, "the decimals of oracle price must be less than 19");

        DECIMALS_OF_ORACLE_PRICE = decimalsOfOraclePrice;

        require(feeTaker != address(0), "the fee taker must be non-zero address");

        FEE_TAKER = feeTaker;

        require(maturityScale != 0, "MATURITY_SCALE must be positive");

        MATURITY_SCALE = maturityScale;

    }



    /**

     * @notice Create bond token contract.

     * The name of this bond token is its bond ID.

     * @dev To convert bytes32 to string, encode its bond ID at first, then convert to string.

     * The symbol of any bond token with bond ID is either SBT or LBT;

     * As SBT is a special case of bond token, any bond token which does not match to the form of

     * SBT is defined as LBT.

     */

    function registerNewBond(uint256 maturity, bytes calldata fnMap)

        external

        virtual

        override

        returns (

            bytes32,

            address,

            bytes32

        )

    {

        _assertBeforeMaturity(maturity);

        require(maturity < _getBlockTimestampSec() + 365 days, "the maturity is too far");

        require(

            maturity % MATURITY_SCALE == 0,

            "the maturity must be the multiple of MATURITY_SCALE"

        );



        bytes32 bondID = generateBondID(maturity, fnMap);



        // Check if the same form of bond is already registered.

        // Cannot detect if the bond is described in a different polyline while two are

        // mathematically equivalent.

        require(

            address(_bonds[bondID].contractInstance) == address(0),

            "the bond type has been already registered"

        );



        // Register function mapping if necessary.

        bytes32 fnMapID = generateFnMapID(fnMap);

        uint64 sbtStrikePrice;

        if (_registeredFnMap[fnMapID].length == 0) {

            uint256[] memory polyline = decodePolyline(fnMap);

            for (uint256 i = 0; i < polyline.length; i++) {

                _registeredFnMap[fnMapID].push(unzipLineSegment(polyline[i]));

            }



            LineSegment[] memory segments = _registeredFnMap[fnMapID];

            assertPolyline(segments);

            require(!_isBondWorthless(segments), "the bond is 0-value at any price");

            sbtStrikePrice = _getSbtStrikePrice(segments);

        } else {

            LineSegment[] memory segments = _registeredFnMap[fnMapID];

            sbtStrikePrice = _getSbtStrikePrice(segments);

        }



        BondTokenInterface bondTokenContract = _createNewBondToken(maturity, fnMap);



        // Set bond info to storage.

        _bonds[bondID] = BondInfo({

            maturity: maturity,

            contractInstance: bondTokenContract,

            strikePrice: sbtStrikePrice,

            fnMapID: fnMapID

        });



        emit LogNewBond(bondID, address(bondTokenContract), maturity, fnMapID);



        return (bondID, address(bondTokenContract), fnMapID);

    }



    function _assertBondGroup(bytes32[] memory bondIDs, uint256 maturity) internal view {

        require(bondIDs.length >= 2, "the bond group should consist of 2 or more bonds");



        /**

         * @dev Count the number of the end points on x axis. In the case of a simple SBT/LBT split,

         * 3 for SBT plus 3 for LBT equals to 6.

         * In the case of SBT with the strike price 100, (x,y) = (0,0), (100,100), (200,100) defines

         * the form of SBT on the field.

         * In the case of LBT with the strike price 100, (x,y) = (0,0), (100,0), (200,100) defines

         * the form of LBT on the field.

         * Right hand side area of the last grid point is expanded on the last line to the infinity.

         * @param nextBreakPointIndex returns the number of unique points on x axis.

         * In the case of SBT and LBT with the strike price 100, x = 0,100,200 are the unique points

         * and the number is 3.

         */

        uint256 numOfBreakPoints = 0;

        for (uint256 i = 0; i < bondIDs.length; i++) {

            BondInfo storage bond = _bonds[bondIDs[i]];

            require(bond.maturity == maturity, "the maturity of the bonds must be same");

            LineSegment[] storage polyline = _registeredFnMap[bond.fnMapID];

            numOfBreakPoints = numOfBreakPoints.add(polyline.length);

        }



        uint256 nextBreakPointIndex = 0;

        uint64[] memory rateBreakPoints = new uint64[](numOfBreakPoints);

        for (uint256 i = 0; i < bondIDs.length; i++) {

            BondInfo storage bond = _bonds[bondIDs[i]];

            LineSegment[] storage segments = _registeredFnMap[bond.fnMapID];

            for (uint256 j = 0; j < segments.length; j++) {

                uint64 breakPoint = segments[j].right.x;

                bool ok = false;



                for (uint256 k = 0; k < nextBreakPointIndex; k++) {

                    if (rateBreakPoints[k] == breakPoint) {

                        ok = true;

                        break;

                    }

                }



                if (ok) {

                    continue;

                }



                rateBreakPoints[nextBreakPointIndex] = breakPoint;

                nextBreakPointIndex++;

            }

        }



        for (uint256 k = 0; k < rateBreakPoints.length; k++) {

            uint64 rate = rateBreakPoints[k];

            uint256 totalBondPriceN = 0;

            uint256 totalBondPriceD = 1;

            for (uint256 i = 0; i < bondIDs.length; i++) {

                BondInfo storage bond = _bonds[bondIDs[i]];

                LineSegment[] storage segments = _registeredFnMap[bond.fnMapID];

                (uint256 segmentIndex, bool ok) = _correspondSegment(segments, rate);



                require(ok, "invalid domain expression");



                (uint128 n, uint64 d) = _mapXtoY(segments[segmentIndex], rate);



                if (n != 0) {

                    // a/b + c/d = (ad+bc)/bd

                    // totalBondPrice += (n / d);

                    // N = D*n + N*d, D = D*d

                    totalBondPriceN = totalBondPriceD.mul(n).add(totalBondPriceN.mul(d));

                    totalBondPriceD = totalBondPriceD.mul(d);

                }

            }

            /**

             * @dev Ensure that totalBondPrice (= totalBondPriceN / totalBondPriceD) is the same

             * with rate. Because we need 1 Ether to mint a unit of each bond token respectively,

             * the sum of cashflow (USD) per a unit of bond token is the same as USD/ETH

             * rate at maturity.

             */

            require(

                totalBondPriceN == totalBondPriceD.mul(rate),

                "the total price at any rateBreakPoints should be the same value as the rate"

            );

        }

    }



    /**

     * @notice Collect bondIDs that regenerate the collateral, and group them as a bond group.

     * Any bond is described as a set of linear functions(i.e. polyline),

     * so we can easily check if the set of bondIDs are well-formed by looking at all the end

     * points of the lines.

     */

    function registerNewBondGroup(bytes32[] calldata bondIDs, uint256 maturity)

        external

        virtual

        override

        returns (uint256 bondGroupID)

    {

        _assertBondGroup(bondIDs, maturity);



        (, , uint64 sbtStrikePrice, ) = getBond(bondIDs[0]);

        require(sbtStrikePrice != 0, "the first bond must be SBT");



        // Get and increment next bond group ID

        bondGroupID = nextBondGroupID;

        nextBondGroupID = nextBondGroupID.add(1);



        _bondGroupList[bondGroupID] = BondGroup(bondIDs, maturity);



        emit LogNewBondGroup(bondGroupID, maturity, sbtStrikePrice, bondIDs);



        return bondGroupID;

    }



    /**

     * @notice A user needs to issue a bond via BondGroup in order to guarantee that the total value

     * of bonds in the bond group equals to the token allowance except for about 0.2% fee (accurately 2/1002).

     * The fee send to Lien token contract when liquidateBond().

     */

    function _issueNewBonds(uint256 bondGroupID, uint256 collateralAmountWithFee)

        internal

        returns (uint256 bondAmount)

    {

        (bytes32[] memory bondIDs, uint256 maturity) = getBondGroup(bondGroupID);

        _assertNonEmptyBondGroup(bondIDs);

        _assertBeforeMaturity(maturity);



        uint256 fee = collateralAmountWithFee.mul(2).divRoundUp(1002);



        uint8 decimalsOfCollateral = _getCollateralDecimals();

        bondAmount = _applyDecimalGap(

            collateralAmountWithFee.sub(fee),

            decimalsOfCollateral,

            DECIMALS_OF_BOND

        );

        require(bondAmount != 0, "the minting amount must be non-zero");



        for (uint256 i = 0; i < bondIDs.length; i++) {

            _mintBond(bondIDs[i], msg.sender, bondAmount);

        }



        emit LogIssueNewBonds(bondGroupID, msg.sender, bondAmount);

    }



    /**

     * @notice redeems collateral from the total set of bonds in the bondGroupID before maturity date.

     * @param bondGroupID is the bond group ID.

     * @param bondAmount is the redeemed bond amount (decimal: 8).

     */

    function reverseBondGroupToCollateral(uint256 bondGroupID, uint256 bondAmount)

        external

        virtual

        override

        returns (bool)

    {

        (bytes32[] memory bondIDs, uint256 maturity) = getBondGroup(bondGroupID);

        _assertNonEmptyBondGroup(bondIDs);

        _assertBeforeMaturity(maturity);

        for (uint256 i = 0; i < bondIDs.length; i++) {

            _burnBond(bondIDs[i], msg.sender, bondAmount);

        }



        uint8 decimalsOfCollateral = _getCollateralDecimals();

        uint256 collateralAmount = _applyDecimalGap(

            bondAmount,

            DECIMALS_OF_BOND,

            decimalsOfCollateral

        );

        _sendCollateralTo(msg.sender, collateralAmount);



        emit LogReverseBondGroupToCollateral(bondGroupID, msg.sender, collateralAmount);



        return true;

    }



    /**

     * @notice Burns set of LBTs and mints equivalent set of LBTs that are not in the exception list.

     * @param inputBondGroupID is the BondGroupID of bonds which you want to burn.

     * @param outputBondGroupID is the BondGroupID of bonds which you want to mint.

     * @param exceptionBonds is the list of bondIDs that should be excluded in burn/mint process.

     */

    function exchangeEquivalentBonds(

        uint256 inputBondGroupID,

        uint256 outputBondGroupID,

        uint256 amount,

        bytes32[] calldata exceptionBonds

    ) external virtual override returns (bool) {

        (bytes32[] memory inputIDs, uint256 inputMaturity) = getBondGroup(inputBondGroupID);

        _assertNonEmptyBondGroup(inputIDs);

        (bytes32[] memory outputIDs, uint256 outputMaturity) = getBondGroup(outputBondGroupID);

        _assertNonEmptyBondGroup(outputIDs);

        require(inputMaturity == outputMaturity, "cannot exchange bonds with different maturities");

        _assertBeforeMaturity(inputMaturity);



        bool flag;

        uint256 exceptionCount;

        for (uint256 i = 0; i < inputIDs.length; i++) {

            // this flag control checks whether the bond is in the scope of burn/mint

            flag = true;

            for (uint256 j = 0; j < exceptionBonds.length; j++) {

                if (exceptionBonds[j] == inputIDs[i]) {

                    flag = false;

                    // this count checks if all the bondIDs in exceptionBonds are included both in inputBondGroupID and outputBondGroupID

                    exceptionCount = exceptionCount.add(1);

                }

            }

            if (flag) {

                _burnBond(inputIDs[i], msg.sender, amount);

            }

        }



        require(

            exceptionBonds.length == exceptionCount,

            "All the exceptionBonds need to be included in input"

        );



        for (uint256 i = 0; i < outputIDs.length; i++) {

            flag = true;

            for (uint256 j = 0; j < exceptionBonds.length; j++) {

                if (exceptionBonds[j] == outputIDs[i]) {

                    flag = false;

                    exceptionCount = exceptionCount.sub(1);

                }

            }

            if (flag) {

                _mintBond(outputIDs[i], msg.sender, amount);

            }

        }



        require(

            exceptionCount == 0,

            "All the exceptionBonds need to be included both in input and output"

        );



        emit LogExchangeEquivalentBonds(msg.sender, inputBondGroupID, outputBondGroupID, amount);



        return true;

    }



    /**

     * @notice This function distributes the collateral to the bond token holders

     * after maturity date based on the oracle price.

     * @param bondGroupID is the target bond group ID.

     * @param oracleHintID is manually set to be smaller number than the oracle latestId

     * when the caller wants to save gas.

     */

    function liquidateBond(uint256 bondGroupID, uint256 oracleHintID)

        external

        virtual

        override

        returns (uint256 totalPayment)

    {

        (bytes32[] memory bondIDs, uint256 maturity) = getBondGroup(bondGroupID);

        _assertNonEmptyBondGroup(bondIDs);

        require(_getBlockTimestampSec() >= maturity, "the bond has not expired yet");



        uint256 price = _getPriceOn(

            maturity,

            (oracleHintID != 0) ? oracleHintID : _oracleContract.latestId()

        );

        require(price != 0, "price should be non-zero value");

        require(price < 2**64, "price should be less than 2^64");



        for (uint256 i = 0; i < bondIDs.length; i++) {

            bytes32 bondID = bondIDs[i];

            uint256 payment = _sendCollateralToBondTokenContract(bondID, uint64(price));

            totalPayment = totalPayment.add(payment);

        }



        if (totalPayment != 0) {

            /// @dev collateral:fee = 1000:2

            uint256 fee = totalPayment.mul(2).div(1000);

            _sendCollateralTo(payable(FEE_TAKER), fee);

        }

    }



    function collateralAddress() external override view returns (address) {

        return _collateralAddress();

    }



    function oracleAddress() external override view returns (address) {

        return address(_oracleContract);

    }



    function feeTaker() external override view returns (address) {

        return FEE_TAKER;

    }



    function decimalsOfBond() external override view returns (uint8) {

        return DECIMALS_OF_BOND;

    }



    function decimalsOfOraclePrice() external override view returns (uint8) {

        return DECIMALS_OF_ORACLE_PRICE;

    }



    function maturityScale() external override view returns (uint256) {

        return MATURITY_SCALE;

    }



    /**

     * @notice Returns multiple information for the bondID.

     * @dev The decimals of strike price is the same as that of oracle price.

     */

    function getBond(bytes32 bondID)

        public

        override

        view

        returns (

            address bondTokenAddress,

            uint256 maturity,

            uint64 solidStrikePrice,

            bytes32 fnMapID

        )

    {

        BondInfo memory bondInfo = _bonds[bondID];

        bondTokenAddress = address(bondInfo.contractInstance);

        maturity = bondInfo.maturity;

        solidStrikePrice = bondInfo.strikePrice;

        fnMapID = bondInfo.fnMapID;

    }



    /**

     * @dev Returns polyline for the fnMapID.

     */

    function getFnMap(bytes32 fnMapID) public override view returns (bytes memory fnMap) {

        LineSegment[] storage segments = _registeredFnMap[fnMapID];

        uint256[] memory polyline = new uint256[](segments.length);

        for (uint256 i = 0; i < segments.length; i++) {

            polyline[i] = zipLineSegment(segments[i]);

        }

        return abi.encode(polyline);

    }



    /**

     * @dev Returns all the bondIDs and their maturity for the bondGroupID.

     */

    function getBondGroup(uint256 bondGroupID)

        public

        override

        view

        returns (bytes32[] memory bondIDs, uint256 maturity)

    {

        require(bondGroupID < nextBondGroupID, "the bond group does not exist");

        BondGroup memory bondGroup = _bondGroupList[bondGroupID];

        bondIDs = bondGroup.bondIDs;

        maturity = bondGroup.maturity;

    }



    /**

     * @dev Returns keccak256 for the fnMap.

     */

    function generateFnMapID(bytes memory fnMap) public override view returns (bytes32 fnMapID) {

        return keccak256(fnMap);

    }



    /**

     * @dev Returns a bond ID determined by this contract address, maturity and fnMap.

     */

    function generateBondID(uint256 maturity, bytes memory fnMap)

        public

        override

        view

        returns (bytes32 bondID)

    {

        return keccak256(abi.encodePacked(address(this), maturity, fnMap));

    }



    function _mintBond(

        bytes32 bondID,

        address account,

        uint256 amount

    ) internal {

        BondTokenInterface bondTokenContract = _bonds[bondID].contractInstance;

        _assertRegisteredBond(bondTokenContract);

        require(bondTokenContract.mint(account, amount), "failed to mint bond token");

    }



    function _burnBond(

        bytes32 bondID,

        address account,

        uint256 amount

    ) internal {

        BondTokenInterface bondTokenContract = _bonds[bondID].contractInstance;

        _assertRegisteredBond(bondTokenContract);

        require(bondTokenContract.simpleBurn(account, amount), "failed to burn bond token");

    }



    function _sendCollateralToBondTokenContract(bytes32 bondID, uint64 price)

        internal

        returns (uint256 collateralAmount)

    {

        BondTokenInterface bondTokenContract = _bonds[bondID].contractInstance;

        _assertRegisteredBond(bondTokenContract);



        LineSegment[] storage segments = _registeredFnMap[_bonds[bondID].fnMapID];



        (uint256 segmentIndex, bool ok) = _correspondSegment(segments, price);

        assert(ok); // not found a segment whose price range include current price



        (uint128 n, uint64 _d) = _mapXtoY(segments[segmentIndex], price); // x = price, y = n / _d



        // uint64(-1) *  uint64(-1) < uint128(-1)

        uint128 d = uint128(_d) * uint128(price);



        uint256 totalSupply = bondTokenContract.totalSupply();

        bool expiredFlag = bondTokenContract.expire(n, d); // rateE0 = n / d = f(price) / price



        if (expiredFlag) {

            uint8 decimalsOfCollateral = _getCollateralDecimals();

            collateralAmount = _applyDecimalGap(totalSupply, DECIMALS_OF_BOND, decimalsOfCollateral)

                .mul(n)

                .div(d);

            _sendCollateralTo(address(bondTokenContract), collateralAmount);



            emit LogLiquidateBond(bondID, n, d);

        }

    }



    /**

     * @dev removes a decimal gap from rate.

     */

    function _applyDecimalGap(

        uint256 baseAmount,

        uint8 decimalsOfBase,

        uint8 decimalsOfQuote

    ) internal pure returns (uint256 quoteAmount) {

        uint256 n;

        uint256 d;



        if (decimalsOfBase > decimalsOfQuote) {

            d = decimalsOfBase - decimalsOfQuote;

        } else if (decimalsOfBase < decimalsOfQuote) {

            n = decimalsOfQuote - decimalsOfBase;

        }



        // The consequent multiplication would overflow under extreme and non-blocking circumstances.

        require(n < 19 && d < 19, "decimal gap needs to be lower than 19");

        quoteAmount = baseAmount.mul(10**n).div(10**d);

    }



    function _assertRegisteredBond(BondTokenInterface bondTokenContract) internal pure {

        require(address(bondTokenContract) != address(0), "the bond is not registered");

    }



    function _assertNonEmptyBondGroup(bytes32[] memory bondIDs) internal pure {

        require(bondIDs.length != 0, "the list of bond ID must be non-empty");

    }



    function _assertBeforeMaturity(uint256 maturity) internal view {

        require(_getBlockTimestampSec() < maturity, "the maturity has already expired");

    }



    function _isBondWorthless(LineSegment[] memory polyline) internal pure returns (bool) {

        for (uint256 i = 0; i < polyline.length; i++) {

            LineSegment memory segment = polyline[i];

            if (segment.right.y != 0) {

                return false;

            }

        }



        return true;

    }



    /**

     * @dev Return the strike price only when the form of polyline matches to the definition of SBT.

     * Check if the form is SBT even when the polyline is in a verbose style.

     */

    function _getSbtStrikePrice(LineSegment[] memory polyline) internal pure returns (uint64) {

        if (polyline.length == 0) {

            return 0;

        }



        uint64 strikePrice = polyline[0].right.x;



        if (strikePrice == 0) {

            return 0;

        }



        for (uint256 i = 0; i < polyline.length; i++) {

            LineSegment memory segment = polyline[i];

            if (segment.right.y != strikePrice) {

                return 0;

            }

        }



        return uint64(strikePrice);

    }



    /**

     * @dev Only when the form of polyline matches to the definition of LBT, this function returns

     * the minimum collateral price (USD) that LBT is not worthless.

     * Check if the form is LBT even when the polyline is in a verbose style.

     */

    function _getLbtStrikePrice(LineSegment[] memory polyline) internal pure returns (uint64) {

        if (polyline.length == 0) {

            return 0;

        }



        uint64 strikePrice = polyline[0].right.x;



        if (strikePrice == 0) {

            return 0;

        }



        for (uint256 i = 0; i < polyline.length; i++) {

            LineSegment memory segment = polyline[i];

            if (segment.right.y.add(strikePrice) != segment.right.x) {

                return 0;

            }

        }



        return uint64(strikePrice);

    }



    /**

     * @dev In order to calculate y axis value for the corresponding x axis value, we need to find

     * the place of domain of x value on the polyline.

     * As the polyline is already checked to be correctly formed, we can simply look from the right

     * hand side of the polyline.

     */

    function _correspondSegment(LineSegment[] memory segments, uint64 x)

        internal

        pure

        returns (uint256 i, bool ok)

    {

        i = segments.length;

        while (i > 0) {

            i--;

            if (segments[i].left.x <= x) {

                ok = true;

                break;

            }

        }

    }



    // function issueNewBonds(uint256 bondGroupID) external returns (uint256 bondAmount);



    function _createNewBondToken(uint256 maturity, bytes memory fnMap)

        internal

        virtual

        returns (BondTokenInterface);



    function _collateralAddress() internal virtual view returns (address);



    function _getCollateralDecimals() internal virtual view returns (uint8);



    function _sendCollateralTo(address receiver, uint256 amount) internal virtual;

}



// File: contracts/bondMaker/BondMakerCollateralizedEth.sol



pragma solidity 0.6.6;









contract BondMakerCollateralizedEth is BondMaker, UseBondTokenName, TransferETH {

    address private constant ETH = address(0);



    BondTokenFactory internal immutable BOND_TOKEN_FACTORY;



    constructor(

        address oracleAddress,

        address feeTaker,

        address bondTokenNameAddress,

        address bondTokenFactoryAddress,

        uint256 maturityScale

    )

        public

        BondMaker(oracleAddress, feeTaker, maturityScale, 8, 8)

        UseBondTokenName(bondTokenNameAddress)

    {

        BOND_TOKEN_FACTORY = BondTokenFactory(bondTokenFactoryAddress);

    }



    function issueNewBonds(uint256 bondGroupID) public payable returns (uint256 bondAmount) {

        return _issueNewBonds(bondGroupID, msg.value);

    }



    function _createNewBondToken(uint256 maturity, bytes memory fnMap)

        internal

        override

        returns (BondTokenInterface)

    {

        (string memory symbol, string memory name) = _getBondTokenName(maturity, fnMap);

        address bondAddress = BOND_TOKEN_FACTORY.createBondToken(

            ETH,

            name,

            symbol,

            DECIMALS_OF_BOND

        );

        return BondTokenInterface(bondAddress);

    }



    function _getBondTokenName(uint256 maturity, bytes memory fnMap)

        internal

        virtual

        view

        returns (string memory symbol, string memory name)

    {

        bytes32 fnMapID = generateFnMapID(fnMap);

        LineSegment[] memory segments = _registeredFnMap[fnMapID];

        uint64 sbtStrikePrice = _getSbtStrikePrice(segments);

        uint64 lbtStrikePrice = _getLbtStrikePrice(segments);

        uint64 sbtStrikePriceE0 = sbtStrikePrice / (uint64(10)**DECIMALS_OF_ORACLE_PRICE);

        uint64 lbtStrikePriceE0 = lbtStrikePrice / (uint64(10)**DECIMALS_OF_ORACLE_PRICE);



        if (sbtStrikePrice != 0) {

            return

                _bondTokenNameContract.genBondTokenName("SBT", "SBT", maturity, sbtStrikePriceE0);

        } else if (lbtStrikePrice != 0) {

            return

                _bondTokenNameContract.genBondTokenName("LBT", "LBT", maturity, lbtStrikePriceE0);

        } else {

            return _bondTokenNameContract.genBondTokenName("IMT", "Immortal Option", maturity, 0);

        }

    }



    function _collateralAddress() internal override view returns (address) {

        return address(0);

    }



    function _getCollateralDecimals() internal override view returns (uint8) {

        return 18;

    }



    function _sendCollateralTo(address receiver, uint256 amount) internal override {

        _transferETH(payable(receiver), amount);

    }

}



// File: contracts/bondMaker/BondMakerCollateralizedEthInterface.sol



pragma solidity 0.6.6;







interface BondMakerCollateralizedEthInterface is BondMakerInterface {

    function issueNewBonds(uint256 bondGroupID) external payable returns (uint256 amount);

}



// File: contracts/bondMaker/UseBondMaker.sol



pragma solidity 0.6.6;







abstract contract UseBondMaker {

    BondMakerCollateralizedEthInterface internal _bondMakerContract;



    constructor(address contractAddress) public {

        require(contractAddress != address(0), "contract should be non-zero address");

        _bondMakerContract = BondMakerCollateralizedEthInterface(payable(contractAddress));

    }

}



// File: contracts/decentralizedOtc/DecentralizedOTC.sol



pragma solidity 0.6.6;























contract DecentralizedOTC is UseOracle, UseBondMaker, UseSafeMath, Time, CallOptionCalculator {

    uint256 internal constant MIN_EXCHANGE_RATE_E8 = 0.000001 * 10**8;

    uint256 internal constant MAX_EXCHANGE_RATE_E8 = 1000000 * 10**8;



    int256 internal constant MAX_SPREAD_E8 = 0.15 * 10**8; // 15%



    mapping(bytes32 => address) public deployer;



    /**

     * @notice ERC20pool is the amount of ERC20 deposit of a deployer.

     * @param ERC20Address is the target ERC20 token address.

     * @param spread is the fee base of the bid-ask spread.

     * @param isLBTSellPool is whether this pool is for the LBT sale or not.

     */

    struct PoolInfo {

        ERC20 ERC20Address;

        int16 spread;

        bool isLBTSellPool;

    }

    mapping(bytes32 => PoolInfo) public poolMap;



    mapping(bytes32 => PriceOracleInterface) internal _erc20OracleMap;



    event LogERC20TokenLBTSwap(

        bytes32 indexed poolID,

        address indexed sender,

        uint256 indexed bondGroupID,

        uint256 volume, // decimal: 8

        uint256 LBTAmount, // decimal: BondToken.decimals()

        uint256 ERC20Amount // decimal: ERC20.decimals()

    );



    event LogLBTERC20TokenSwap(

        bytes32 indexed poolID,

        address indexed sender,

        uint256 indexed bondGroupID,

        uint256 volume, // decimal: 8

        uint256 LBTAmount, // decimal: BondToken.decimals()

        uint256 ERC20Amount // decimal: ERC20.decimals()

    );



    event LogCreateERC20Pool(

        address indexed deployer,

        address indexed ERC20Address,

        bytes32 indexed poolID,

        int16 spread,

        bool isLBTSellPool

    );



    event LogDeleteERC20Pool(bytes32 indexed poolID);



    modifier isExistentPool(bytes32 erc20PoolID) {

        require(deployer[erc20PoolID] != address(0), "the pool does not exist");

        _;

    }



    constructor(address bondMakerAddress, address oracleAddress)

        public

        UseOracle(oracleAddress)

        UseBondMaker(bondMakerAddress)

    {

        require(

            _bondMakerContract.decimalsOfOraclePrice() == 8,

            "the decimals of oracle price must be 8"

        );

        require(_bondMakerContract.decimalsOfBond() == 8, "the decimals of bond token must be 8");

        require(

            oracleAddress == _bondMakerContract.oracleAddress(),

            "the oracle address is differ"

        );

    }



    /**

     * @notice providers set a pool and deposit to a pool.

     * If there is vesting(lockUp) setting, users of their pool transfer LBT to grants of the vesting ERC20 contract.

     */

    function setPoolMap(

        address ERC20Address,

        int16 spread,

        bool isLBTSellPool

    ) external returns (bytes32 erc20PoolID) {

        erc20PoolID = keccak256(abi.encode(msg.sender, ERC20Address, spread, isLBTSellPool));

        require(deployer[erc20PoolID] == address(0), "already registered");

        require(msg.sender != address(0), "deployer must be non-zero address");

        require(spread > -1000 && spread < 1000, "the range of fee base must be -999~999");

        require(ERC20Address != address(0), "ERC20 address is 0x0");



        poolMap[erc20PoolID] = PoolInfo(ERC20(ERC20Address), spread, isLBTSellPool);

        deployer[erc20PoolID] = msg.sender;

        emit LogCreateERC20Pool(msg.sender, ERC20Address, erc20PoolID, spread, isLBTSellPool);

    }



    /**

     * @notice providers must provide LBT price caluculator and ERC20 price oracle.

     */

    function setProvider(

        bytes32 erc20PoolID,

        address oracleAddress,

        address

    ) external isExistentPool(erc20PoolID) {

        require(msg.sender == deployer[erc20PoolID], "only deployer is allowed to execute");

        _erc20OracleMap[erc20PoolID] = PriceOracleInterface(oracleAddress);

    }



    /**

     * @dev (deprecated) Use getPoolInfo(poolID).

     */

    function oracleInfo(bytes32 poolID)

        external

        view

        returns (address oracleAddress, address calculatorAddress)

    {

        oracleAddress = address(_erc20OracleMap[poolID]);

        calculatorAddress = address(0);

    }



    function getPoolInfo(bytes32 poolID)

        external

        view

        isExistentPool(poolID)

        returns (

            address deployerAddress,

            address erc20Address,

            int16 feeBase,

            bool isLBTSellPool,

            address erc20OracleAddress

        )

    {

        deployerAddress = deployer[poolID];

        PoolInfo memory poolInfo = poolMap[poolID];

        erc20Address = address(poolInfo.ERC20Address);

        feeBase = poolInfo.spread;

        isLBTSellPool = poolInfo.isLBTSellPool;

        erc20OracleAddress = address(_erc20OracleMap[poolID]);

    }



    function getOraclePrice(bytes32 erc20PoolID) external returns (uint256 priceE8) {

        return _getOraclePrice(erc20PoolID);

    }



    function _getOraclePrice(bytes32 erc20PoolID)

        internal

        isExistentPool(erc20PoolID)

        returns (uint256 priceE8)

    {

        PriceOracleInterface oracleContract = _erc20OracleMap[erc20PoolID];

        require(address(oracleContract) != address(0), "invalid ERC20 price oracle");

        return oracleContract.latestPrice();

    }



    /**

     * @notice Returns the exchange rate included spread.

     */

    function calcRateLBT2ERC20(

        bytes32 sbtID,

        bytes32 erc20PoolID,

        uint256 maturity

    ) external returns (uint256 rateLBT2ERC20E8) {

        (rateLBT2ERC20E8, , , ) = _calcRateLBT2ERC20(sbtID, erc20PoolID, maturity);

    }



    function _calcRateLBT2ERC20(

        bytes32 sbtID,

        bytes32 erc20PoolID,

        uint256 maturity

    )

        internal

        returns (

            uint256 rateLBT2ERC20E8,

            uint256 lbtPriceE8,

            uint256 erc20PriceE8,

            int256 spreadE8

        )

    {

        PoolInfo memory pool = poolMap[erc20PoolID];

        (uint256 etherPriceE8, uint256 ethVolatilityE8) = _getOracleData();

        (, , uint256 strikePriceE8, ) = _bondMakerContract.getBond(sbtID);

        erc20PriceE8 = _getOraclePrice(erc20PoolID);



        (lbtPriceE8, spreadE8) = _calcLbtPriceAndSpread(

            strikePriceE8,

            etherPriceE8,

            ethVolatilityE8,

            maturity,

            pool.spread * 10 // feeBaseE4

        );

        uint256 rateE8 = lbtPriceE8.mul(10**8).div(

            erc20PriceE8,

            "ERC20 oracle price must be non-zero"

        );

        require(rateE8 > MIN_EXCHANGE_RATE_E8, "exchange rate is too small");

        // require(rateE8 < MAX_EXCHANGE_RATE_E8, "exchange rate is too large");



        if (pool.isLBTSellPool) {

            rateLBT2ERC20E8 = rateE8.mul(uint256(10**8 + spreadE8)) / (10**8);

        } else {

            rateLBT2ERC20E8 = rateE8.mul(uint256(10**8 - spreadE8)) / (10**8);

        }

    }



    /**

     * @dev Gets LBT data, and outputs the spread and the exchange rate excluding spread.

     */

    function _calcLbtPriceAndSpread(

        uint256 strikePriceE8,

        uint256 etherPriceE8,

        uint256 ethVolatilityE8,

        uint256 maturity,

        int256 feeBaseE4

    ) internal view returns (uint256 lbtPriceE8, int256 spreadE8) {

        uint256 untilMaturity = maturity.sub(

            _getBlockTimestampSec(),

            "LBT should not have expired"

        );



        uint8 decimalsOfPrice = 0; // mutable

        {

            uint256 threshould = 1000000 * 10**8;

            while (threshould >= 10) {

                if (strikePriceE8 >= threshould) {

                    break;

                }

                decimalsOfPrice++;

                threshould /= 10;

            }

        }

        // assert(decimalsOfPrice >= 0 && decimalsOfPrice <= 14);



        uint256 lbtLeverageE4;

        {

            uint256 etherPrice = _applyDecimalGap(etherPriceE8, 8, decimalsOfPrice);

            uint256 strikePrice = _applyDecimalGap(strikePriceE8, 8, decimalsOfPrice);

            uint256 lbtPrice;

            (lbtPrice, lbtLeverageE4, ) = calcLbtPriceAndLeverage(

                etherPrice.toInt256(),

                strikePrice.toInt256(),

                ethVolatilityE8.toInt256(),

                untilMaturity.toInt256()

            );



            lbtPriceE8 = _applyDecimalGap(lbtPrice, decimalsOfPrice, 8);

        }



        uint256 volE8 = ethVolatilityE8 < 10**8 ? 10**8 : ethVolatilityE8 > 2 * 10**8

            ? 2 * 10**8

            : ethVolatilityE8;

        uint256 volTimesLevE4 = (volE8 * lbtLeverageE4) / 10**8;

        spreadE8 =

            feeBaseE4 *

            (feeBaseE4 < 0 || volTimesLevE4 < 10**4 ? 10**4 : volTimesLevE4).toInt256();

        spreadE8 = spreadE8 > MAX_SPREAD_E8 ? MAX_SPREAD_E8 : spreadE8;

    }



    /**

     * @notice removes a decimal gap from rate.

     */

    function _applyDecimalGap(

        uint256 baseAmount,

        ERC20 baseToken,

        ERC20 quoteToken

    ) private view returns (uint256) {

        uint8 decimalsOfBase = baseToken.decimals();

        uint8 decimalsOfQuote = quoteToken.decimals();

        return _applyDecimalGap(baseAmount, decimalsOfBase, decimalsOfQuote);

    }



    function _applyDecimalGap(

        uint256 amount,

        uint8 decimalsOfBase,

        uint8 decimalsOfQuote

    ) private pure returns (uint256) {

        uint256 n;

        uint256 d;



        if (decimalsOfBase > decimalsOfQuote) {

            d = decimalsOfBase - decimalsOfQuote;

        } else if (decimalsOfBase < decimalsOfQuote) {

            n = decimalsOfQuote - decimalsOfBase;

        }



        // The consequent multiplication would overflow under extreme and non-blocking circumstances.

        require(n < 19 && d < 19, "decimal gap needs to be lower than 19");

        return amount.mul(10**n).div(10**d);

    }



    /**

     * @notice Before this function, approve is needed to be excuted.

     * Main function of this contract. Users exchange ERC20 tokens (like USDC Token) to LBT

     */

    function exchangeERC20ToLBT(

        uint256 bondGroupID,

        bytes32 erc20PoolID,

        uint256 ERC20Amount,

        uint256 expectedAmount,

        uint256 range

    ) public returns (uint256 LBTAmount) {

        LBTAmount = _exchangeERC20ToLBT(bondGroupID, erc20PoolID, ERC20Amount);

        if (expectedAmount != 0) {

            require(LBTAmount.mul(1000 + range).div(1000) >= expectedAmount, "out of price range");

        }

    }



    function _exchangeERC20ToLBT(

        uint256 bondGroupID,

        bytes32 erc20PoolID,

        uint256 ERC20Amount

    ) internal isExistentPool(erc20PoolID) returns (uint256 LBTAmount) {

        bytes32 sbtID;

        bytes32 lbtID;

        {

            (bytes32[] memory bonds, ) = _bondMakerContract.getBondGroup(bondGroupID);

            require(bonds.length == 2, "the bond group must include only 2 types of bond.");

            lbtID = bonds[1];

            sbtID = bonds[0];

        }



        ERC20 bondToken;

        uint256 maturity;

        {

            address contractAddress;

            (contractAddress, maturity, , ) = _bondMakerContract.getBond(lbtID);

            require(contractAddress != address(0), "the bond is not registered");

            bondToken = ERC20(contractAddress);

        }



        ERC20 token;

        {

            PoolInfo memory pool = poolMap[erc20PoolID];

            require(pool.isLBTSellPool, "This pool is for buying LBT");

            token = pool.ERC20Address;

        }



        uint256 volumeE8;

        {

            (uint256 rateE8, , uint256 erc20PriceE8, ) = _calcRateLBT2ERC20(

                sbtID,

                erc20PoolID,

                maturity

            );

            require(rateE8 != 0, "exchange rate included spread must be non-zero");

            LBTAmount = _applyDecimalGap(ERC20Amount.mul(10**8), token, bondToken).div(rateE8);

            require(LBTAmount != 0, "must transfer non-zero LBT amount");

            volumeE8 = erc20PriceE8.mul(ERC20Amount).div(10**uint256(token.decimals()));

            volumeE8 = _calcUsdVolume(volumeE8);

        }



        require(

            token.transferFrom(msg.sender, deployer[erc20PoolID], ERC20Amount),

            "fail to transfer ERC20 token"

        );

        require(

            bondToken.transferFrom(deployer[erc20PoolID], msg.sender, LBTAmount),

            "fail to transfer LBT"

        );



        emit LogERC20TokenLBTSwap(

            erc20PoolID,

            msg.sender,

            bondGroupID,

            volumeE8,

            LBTAmount,

            ERC20Amount

        );

    }



    /**

     * @notice Before this function, approve is needed to be excuted.

     * Main function of this contract. Users exchange LBT to ERC20 tokens (like USDC Token)

     */

    function exchangeLBT2ERC20(

        uint256 bondGroupID,

        bytes32 erc20PoolID,

        uint256 LBTAmount,

        uint256 expectedAmount,

        uint256 range

    ) public returns (uint256 ERC20Amount) {

        ERC20Amount = _exchangeLBT2ERC20(bondGroupID, erc20PoolID, LBTAmount);

        if (expectedAmount != 0) {

            require(

                ERC20Amount.mul(1000 + range).div(1000) >= expectedAmount,

                "out of price range"

            );

        }

    }



    function _exchangeLBT2ERC20(

        uint256 bondGroupID,

        bytes32 erc20PoolID,

        uint256 LBTAmount

    ) internal isExistentPool(erc20PoolID) returns (uint256 ERC20Amount) {

        bytes32 lbtID;

        bytes32 sbtID;

        {

            (bytes32[] memory bonds, ) = _bondMakerContract.getBondGroup(bondGroupID);

            require(bonds.length == 2, "the bond group must include only 2 types of bond.");

            lbtID = bonds[1];

            sbtID = bonds[0];

        }



        ERC20 bondToken;

        uint256 maturity;

        {

            address contractAddress;

            (contractAddress, maturity, , ) = _bondMakerContract.getBond(lbtID);

            require(contractAddress != address(0), "the bond is not registered");

            bondToken = ERC20(contractAddress);

        }



        ERC20 token;

        {

            PoolInfo memory pool = poolMap[erc20PoolID];

            require(!pool.isLBTSellPool, "This pool is not for buying LBT");

            token = pool.ERC20Address;

        }



        uint256 volumeE8;

        {

            (uint256 rateE8, uint256 lbtPriceE8, , ) = _calcRateLBT2ERC20(

                sbtID,

                erc20PoolID,

                maturity

            );

            require(rateE8 != 0, "exchange rate included spread must be non-zero");

            ERC20Amount = _applyDecimalGap(LBTAmount.mul(rateE8), bondToken, token).div(10**8);

            require(ERC20Amount != 0, "must transfer non-zero token amount");

            volumeE8 = lbtPriceE8.mul(LBTAmount).div(10**uint256(bondToken.decimals()));

            volumeE8 = _calcUsdVolume(volumeE8);

        }



        require(

            token.transferFrom(deployer[erc20PoolID], msg.sender, ERC20Amount),

            "fail to transfer ERC20 token"

        );

        require(

            bondToken.transferFrom(msg.sender, deployer[erc20PoolID], LBTAmount),

            "fail to transfer LBT"

        );



        emit LogLBTERC20TokenSwap(

            erc20PoolID,

            msg.sender,

            bondGroupID,

            volumeE8,

            LBTAmount,

            ERC20Amount

        );

    }



    function deletePoolAndProvider(bytes32 erc20PoolID) public isExistentPool(erc20PoolID) {

        require(deployer[erc20PoolID] == msg.sender, "this pool is not owned");

        delete deployer[erc20PoolID];

        delete poolMap[erc20PoolID];

        delete _erc20OracleMap[erc20PoolID];



        emit LogDeleteERC20Pool(erc20PoolID);

    }



    function bondMakerAddress() external view returns (address) {

        return address(_bondMakerContract);

    }



    /**

     * @dev Converts the unit of the strike price to USD.

     * Considering oracle, this function is non-payable.

     */

    function _calcUsdVolume(uint256 volume) internal virtual returns (uint256) {

        return volume;

    }

}

pragma solidity 0.5.13;

pragma experimental ABIEncoderV2;



/**

 * @title Interface for SoloMargin contract

 * @author Igor Sobolev

 */

interface ISoloMargin {

    function operate(Account.Info[] calldata accounts, Actions.ActionArgs[] calldata actions) external;

}





library Account {

    // ============ Enums ============



    /*

     * Most-recently-cached account status.

     *

     * Normal: Can only be liquidated if the account values are violating the global margin-ratio.

     * Liquid: Can be liquidated no matter the account values.

     *         Can be vaporized if there are no more positive account values.

     * Vapor:  Has only negative (or zeroed) account values. Can be vaporized.

     *

     */

    enum Status {

        Normal,

        Liquid,

        Vapor

    }



    // ============ Structs ============



    // Represents the unique key that specifies an account

    struct Info {

        address owner;  // The address that owns the account

        uint256 number; // A nonce that allows a single address to control many accounts

    }



    // The complete storage for any account

    struct Storage {

        mapping (uint256 => Types.Par) balances; // Mapping from marketId to principal

        Status status;

    }



    // ============ Library Functions ============



    function equals(

        Info memory a,

        Info memory b

    )

    internal

    pure

    returns (bool)

    {

        return a.owner == b.owner && a.number == b.number;

    }

}





library Actions {



    // ============ Constants ============



    bytes32 constant FILE = "Actions";



    // ============ Enums ============



    enum ActionType {

        Deposit,   // supply tokens

        Withdraw,  // borrow tokens

        Transfer,  // transfer balance between accounts

        Buy,       // buy an amount of some token (externally)

        Sell,      // sell an amount of some token (externally)

        Trade,     // trade tokens against another account

        Liquidate, // liquidate an undercollateralized or expiring account

        Vaporize,  // use excess tokens to zero-out a completely negative account

        Call       // send arbitrary data to an address

    }



    enum AccountLayout {

        OnePrimary,

        TwoPrimary,

        PrimaryAndSecondary

    }



    enum MarketLayout {

        ZeroMarkets,

        OneMarket,

        TwoMarkets

    }



    // ============ Structs ============



    /*

     * Arguments that are passed to Solo in an ordered list as part of a single operation.

     * Each ActionArgs has an actionType which specifies which action struct that this data will be

     * parsed into before being processed.

     */

    struct ActionArgs {

        ActionType actionType;

        uint256 accountId;

        Types.AssetAmount amount;

        uint256 primaryMarketId;

        uint256 secondaryMarketId;

        address otherAddress;

        uint256 otherAccountId;

        bytes data;

    }



    // ============ Action Types ============



    /*

     * Moves tokens from an address to Solo. Can either repay a borrow or provide additional supply.

     */

    struct DepositArgs {

        Types.AssetAmount amount;

        Account.Info account;

        uint256 market;

        address from;

    }



    /*

     * Moves tokens from Solo to another address. Can either borrow tokens or reduce the amount

     * previously supplied.

     */

    struct WithdrawArgs {

        Types.AssetAmount amount;

        Account.Info account;

        uint256 market;

        address to;

    }



    /*

     * Transfers balance between two accounts. The msg.sender must be an operator for both accounts.

     * The amount field applies to accountOne.

     * This action does not require any token movement since the trade is done internally to Solo.

     */

    struct TransferArgs {

        Types.AssetAmount amount;

        Account.Info accountOne;

        Account.Info accountTwo;

        uint256 market;

    }



    /*

     * Acquires a certain amount of tokens by spending other tokens. Sends takerMarket tokens to the

     * specified exchangeWrapper contract and expects makerMarket tokens in return. The amount field

     * applies to the makerMarket.

     */

    struct BuyArgs {

        Types.AssetAmount amount;

        Account.Info account;

        uint256 makerMarket;

        uint256 takerMarket;

        address exchangeWrapper;

        bytes orderData;

    }



    /*

     * Spends a certain amount of tokens to acquire other tokens. Sends takerMarket tokens to the

     * specified exchangeWrapper and expects makerMarket tokens in return. The amount field applies

     * to the takerMarket.

     */

    struct SellArgs {

        Types.AssetAmount amount;

        Account.Info account;

        uint256 takerMarket;

        uint256 makerMarket;

        address exchangeWrapper;

        bytes orderData;

    }



    /*

     * Trades balances between two accounts using any external contract that implements the

     * AutoTrader interface. The AutoTrader contract must be an operator for the makerAccount (for

     * which it is trading on-behalf-of). The amount field applies to the makerAccount and the

     * inputMarket. This proposed change to the makerAccount is passed to the AutoTrader which will

     * quote a change for the makerAccount in the outputMarket (or will disallow the trade).

     * This action does not require any token movement since the trade is done internally to Solo.

     */

    struct TradeArgs {

        Types.AssetAmount amount;

        Account.Info takerAccount;

        Account.Info makerAccount;

        uint256 inputMarket;

        uint256 outputMarket;

        address autoTrader;

        bytes tradeData;

    }



    /*

     * Each account must maintain a certain margin-ratio (specified globally). If the account falls

     * below this margin-ratio, it can be liquidated by any other account. This allows anyone else

     * (arbitrageurs) to repay any borrowed asset (owedMarket) of the liquidating account in

     * exchange for any collateral asset (heldMarket) of the liquidAccount. The ratio is determined

     * by the price ratio (given by the oracles) plus a spread (specified globally). Liquidating an

     * account also sets a flag on the account that the account is being liquidated. This allows

     * anyone to continue liquidating the account until there are no more borrows being taken by the

     * liquidating account. Liquidators do not have to liquidate the entire account all at once but

     * can liquidate as much as they choose. The liquidating flag allows liquidators to continue

     * liquidating the account even if it becomes collateralized through partial liquidation or

     * price movement.

     */

    struct LiquidateArgs {

        Types.AssetAmount amount;

        Account.Info solidAccount;

        Account.Info liquidAccount;

        uint256 owedMarket;

        uint256 heldMarket;

    }



    /*

     * Similar to liquidate, but vaporAccounts are accounts that have only negative balances

     * remaining. The arbitrageur pays back the negative asset (owedMarket) of the vaporAccount in

     * exchange for a collateral asset (heldMarket) at a favorable spread. However, since the

     * liquidAccount has no collateral assets, the collateral must come from Solo's excess tokens.

     */

    struct VaporizeArgs {

        Types.AssetAmount amount;

        Account.Info solidAccount;

        Account.Info vaporAccount;

        uint256 owedMarket;

        uint256 heldMarket;

    }



    /*

     * Passes arbitrary bytes of data to an external contract that implements the Callee interface.

     * Does not change any asset amounts. This function may be useful for setting certain variables

     * on layer-two contracts for certain accounts without having to make a separate Ethereum

     * transaction for doing so. Also, the second-layer contracts can ensure that the call is coming

     * from an operator of the particular account.

     */

    struct CallArgs {

        Account.Info account;

        address callee;

        bytes data;

    }



    // ============ Helper Functions ============



    function getMarketLayout(

        ActionType actionType

    )

    internal

    pure

    returns (MarketLayout)

    {

        if (

            actionType == Actions.ActionType.Deposit

            || actionType == Actions.ActionType.Withdraw

            || actionType == Actions.ActionType.Transfer

        ) {

            return MarketLayout.OneMarket;

        }

        else if (actionType == Actions.ActionType.Call) {

            return MarketLayout.ZeroMarkets;

        }

        return MarketLayout.TwoMarkets;

    }



    function getAccountLayout(

        ActionType actionType

    )

    internal

    pure

    returns (AccountLayout)

    {

        if (

            actionType == Actions.ActionType.Transfer

            || actionType == Actions.ActionType.Trade

        ) {

            return AccountLayout.TwoPrimary;

        } else if (

            actionType == Actions.ActionType.Liquidate

            || actionType == Actions.ActionType.Vaporize

        ) {

            return AccountLayout.PrimaryAndSecondary;

        }

        return AccountLayout.OnePrimary;

    }



    // ============ Parsing Functions ============



    function parseDepositArgs(

        Account.Info[] memory accounts,

        ActionArgs memory args

    )

    internal

    pure

    returns (DepositArgs memory)

    {

        assert(args.actionType == ActionType.Deposit);

        return DepositArgs({

            amount: args.amount,

            account: accounts[args.accountId],

            market: args.primaryMarketId,

            from: args.otherAddress

            });

    }



    function parseWithdrawArgs(

        Account.Info[] memory accounts,

        ActionArgs memory args

    )

    internal

    pure

    returns (WithdrawArgs memory)

    {

        assert(args.actionType == ActionType.Withdraw);

        return WithdrawArgs({

            amount: args.amount,

            account: accounts[args.accountId],

            market: args.primaryMarketId,

            to: args.otherAddress

            });

    }



    function parseTransferArgs(

        Account.Info[] memory accounts,

        ActionArgs memory args

    )

    internal

    pure

    returns (TransferArgs memory)

    {

        assert(args.actionType == ActionType.Transfer);

        return TransferArgs({

            amount: args.amount,

            accountOne: accounts[args.accountId],

            accountTwo: accounts[args.otherAccountId],

            market: args.primaryMarketId

            });

    }



    function parseBuyArgs(

        Account.Info[] memory accounts,

        ActionArgs memory args

    )

    internal

    pure

    returns (BuyArgs memory)

    {

        assert(args.actionType == ActionType.Buy);

        return BuyArgs({

            amount: args.amount,

            account: accounts[args.accountId],

            makerMarket: args.primaryMarketId,

            takerMarket: args.secondaryMarketId,

            exchangeWrapper: args.otherAddress,

            orderData: args.data

            });

    }



    function parseSellArgs(

        Account.Info[] memory accounts,

        ActionArgs memory args

    )

    internal

    pure

    returns (SellArgs memory)

    {

        assert(args.actionType == ActionType.Sell);

        return SellArgs({

            amount: args.amount,

            account: accounts[args.accountId],

            takerMarket: args.primaryMarketId,

            makerMarket: args.secondaryMarketId,

            exchangeWrapper: args.otherAddress,

            orderData: args.data

            });

    }



    function parseTradeArgs(

        Account.Info[] memory accounts,

        ActionArgs memory args

    )

    internal

    pure

    returns (TradeArgs memory)

    {

        assert(args.actionType == ActionType.Trade);

        return TradeArgs({

            amount: args.amount,

            takerAccount: accounts[args.accountId],

            makerAccount: accounts[args.otherAccountId],

            inputMarket: args.primaryMarketId,

            outputMarket: args.secondaryMarketId,

            autoTrader: args.otherAddress,

            tradeData: args.data

            });

    }



    function parseLiquidateArgs(

        Account.Info[] memory accounts,

        ActionArgs memory args

    )

    internal

    pure

    returns (LiquidateArgs memory)

    {

        assert(args.actionType == ActionType.Liquidate);

        return LiquidateArgs({

            amount: args.amount,

            solidAccount: accounts[args.accountId],

            liquidAccount: accounts[args.otherAccountId],

            owedMarket: args.primaryMarketId,

            heldMarket: args.secondaryMarketId

            });

    }



    function parseVaporizeArgs(

        Account.Info[] memory accounts,

        ActionArgs memory args

    )

    internal

    pure

    returns (VaporizeArgs memory)

    {

        assert(args.actionType == ActionType.Vaporize);

        return VaporizeArgs({

            amount: args.amount,

            solidAccount: accounts[args.accountId],

            vaporAccount: accounts[args.otherAccountId],

            owedMarket: args.primaryMarketId,

            heldMarket: args.secondaryMarketId

            });

    }



    function parseCallArgs(

        Account.Info[] memory accounts,

        ActionArgs memory args

    )

    internal

    pure

    returns (CallArgs memory)

    {

        assert(args.actionType == ActionType.Call);

        return CallArgs({

            account: accounts[args.accountId],

            callee: args.otherAddress,

            data: args.data

            });

    }

}





/// @title Interface for Module Manager - A contract that manages modules that can execute transactions via this contract

/// @author Igor Sobolev

interface ModuleManager {

    function execTransactionFromModule(address to, uint256 value, bytes calldata data, Enum.Operation operation) external returns (bool success);

    function execTransactionFromModuleReturnData(address to, uint256 value, bytes calldata data, Enum.Operation operation) external returns (bool success, bytes memory returnData);

}





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





library Require {



    // ============ Constants ============



    uint256 constant ASCII_ZERO = 48; // '0'

    uint256 constant ASCII_RELATIVE_ZERO = 87; // 'a' - 10

    uint256 constant ASCII_LOWER_EX = 120; // 'x'

    bytes2 constant COLON = 0x3a20; // ': '

    bytes2 constant COMMA = 0x2c20; // ', '

    bytes2 constant LPAREN = 0x203c; // ' <'

    byte constant RPAREN = 0x3e; // '>'

    uint256 constant FOUR_BIT_MASK = 0xf;



    // ============ Library Functions ============



    function that(

        bool must,

        bytes32 file,

        bytes32 reason

    )

    internal

    pure

    {

        if (!must) {

            revert(

                string(

                    abi.encodePacked(

                        stringifyTruncated(file),

                        COLON,

                        stringifyTruncated(reason)

                    )

                )

            );

        }

    }



    function that(

        bool must,

        bytes32 file,

        bytes32 reason,

        uint256 payloadA

    )

    internal

    pure

    {

        if (!must) {

            revert(

                string(

                    abi.encodePacked(

                        stringifyTruncated(file),

                        COLON,

                        stringifyTruncated(reason),

                        LPAREN,

                        stringify(payloadA),

                        RPAREN

                    )

                )

            );

        }

    }



    function that(

        bool must,

        bytes32 file,

        bytes32 reason,

        uint256 payloadA,

        uint256 payloadB

    )

    internal

    pure

    {

        if (!must) {

            revert(

                string(

                    abi.encodePacked(

                        stringifyTruncated(file),

                        COLON,

                        stringifyTruncated(reason),

                        LPAREN,

                        stringify(payloadA),

                        COMMA,

                        stringify(payloadB),

                        RPAREN

                    )

                )

            );

        }

    }



    function that(

        bool must,

        bytes32 file,

        bytes32 reason,

        address payloadA

    )

    internal

    pure

    {

        if (!must) {

            revert(

                string(

                    abi.encodePacked(

                        stringifyTruncated(file),

                        COLON,

                        stringifyTruncated(reason),

                        LPAREN,

                        stringify(payloadA),

                        RPAREN

                    )

                )

            );

        }

    }



    function that(

        bool must,

        bytes32 file,

        bytes32 reason,

        address payloadA,

        uint256 payloadB

    )

    internal

    pure

    {

        if (!must) {

            revert(

                string(

                    abi.encodePacked(

                        stringifyTruncated(file),

                        COLON,

                        stringifyTruncated(reason),

                        LPAREN,

                        stringify(payloadA),

                        COMMA,

                        stringify(payloadB),

                        RPAREN

                    )

                )

            );

        }

    }



    function that(

        bool must,

        bytes32 file,

        bytes32 reason,

        address payloadA,

        uint256 payloadB,

        uint256 payloadC

    )

    internal

    pure

    {

        if (!must) {

            revert(

                string(

                    abi.encodePacked(

                        stringifyTruncated(file),

                        COLON,

                        stringifyTruncated(reason),

                        LPAREN,

                        stringify(payloadA),

                        COMMA,

                        stringify(payloadB),

                        COMMA,

                        stringify(payloadC),

                        RPAREN

                    )

                )

            );

        }

    }



    function that(

        bool must,

        bytes32 file,

        bytes32 reason,

        bytes32 payloadA

    )

    internal

    pure

    {

        if (!must) {

            revert(

                string(

                    abi.encodePacked(

                        stringifyTruncated(file),

                        COLON,

                        stringifyTruncated(reason),

                        LPAREN,

                        stringify(payloadA),

                        RPAREN

                    )

                )

            );

        }

    }



    function that(

        bool must,

        bytes32 file,

        bytes32 reason,

        bytes32 payloadA,

        uint256 payloadB,

        uint256 payloadC

    )

    internal

    pure

    {

        if (!must) {

            revert(

                string(

                    abi.encodePacked(

                        stringifyTruncated(file),

                        COLON,

                        stringifyTruncated(reason),

                        LPAREN,

                        stringify(payloadA),

                        COMMA,

                        stringify(payloadB),

                        COMMA,

                        stringify(payloadC),

                        RPAREN

                    )

                )

            );

        }

    }



    // ============ Private Functions ============



    function stringifyTruncated(

        bytes32 input

    )

    private

    pure

    returns (bytes memory)

    {

        // put the input bytes into the result

        bytes memory result = abi.encodePacked(input);



        // determine the length of the input by finding the location of the last non-zero byte

        for (uint256 i = 32; i > 0; ) {

            // reverse-for-loops with unsigned integer

            /* solium-disable-next-line security/no-modify-for-iter-var */

            i--;



            // find the last non-zero byte in order to determine the length

            if (result[i] != 0) {

                uint256 length = i + 1;



                /* solium-disable-next-line security/no-inline-assembly */

                assembly {

                    mstore(result, length) // r.length = length;

                }



                return result;

            }

        }



        // all bytes are zero

        return new bytes(0);

    }



    function stringify(

        uint256 input

    )

    private

    pure

    returns (bytes memory)

    {

        if (input == 0) {

            return "0";

        }



        // get the final string length

        uint256 j = input;

        uint256 length;

        while (j != 0) {

            length++;

            j /= 10;

        }



        // allocate the string

        bytes memory bstr = new bytes(length);



        // populate the string starting with the least-significant character

        j = input;

        for (uint256 i = length; i > 0; ) {

            // reverse-for-loops with unsigned integer

            /* solium-disable-next-line security/no-modify-for-iter-var */

            i--;



            // take last decimal digit

            bstr[i] = byte(uint8(ASCII_ZERO + (j % 10)));



            // remove the last decimal digit

            j /= 10;

        }



        return bstr;

    }



    function stringify(

        address input

    )

    private

    pure

    returns (bytes memory)

    {

        uint256 z = uint256(input);



        // addresses are "0x" followed by 20 bytes of data which take up 2 characters each

        bytes memory result = new bytes(42);



        // populate the result with "0x"

        result[0] = byte(uint8(ASCII_ZERO));

        result[1] = byte(uint8(ASCII_LOWER_EX));



        // for each byte (starting from the lowest byte), populate the result with two characters

        for (uint256 i = 0; i < 20; i++) {

            // each byte takes two characters

            uint256 shift = i * 2;



            // populate the least-significant character

            result[41 - shift] = char(z & FOUR_BIT_MASK);

            z = z >> 4;



            // populate the most-significant character

            result[40 - shift] = char(z & FOUR_BIT_MASK);

            z = z >> 4;

        }



        return result;

    }



    function stringify(

        bytes32 input

    )

    private

    pure

    returns (bytes memory)

    {

        uint256 z = uint256(input);



        // bytes32 are "0x" followed by 32 bytes of data which take up 2 characters each

        bytes memory result = new bytes(66);



        // populate the result with "0x"

        result[0] = byte(uint8(ASCII_ZERO));

        result[1] = byte(uint8(ASCII_LOWER_EX));



        // for each byte (starting from the lowest byte), populate the result with two characters

        for (uint256 i = 0; i < 32; i++) {

            // each byte takes two characters

            uint256 shift = i * 2;



            // populate the least-significant character

            result[65 - shift] = char(z & FOUR_BIT_MASK);

            z = z >> 4;



            // populate the most-significant character

            result[64 - shift] = char(z & FOUR_BIT_MASK);

            z = z >> 4;

        }



        return result;

    }



    function char(

        uint256 input

    )

    private

    pure

    returns (byte)

    {

        // return ASCII digit (0-9)

        if (input < 10) {

            return byte(uint8(input + ASCII_ZERO));

        }



        // return ASCII letter (a-f)

        return byte(uint8(input + ASCII_RELATIVE_ZERO));

    }

}





/**

 * @title Math

 * @author dYdX

 *

 * Library for non-standard Math functions

 */

library Math {

    using SafeMath for uint256;



    // ============ Constants ============



    bytes32 constant FILE = "Math";



    // ============ Library Functions ============



    /*

     * Return target * (numerator / denominator).

     */

    function getPartial(

        uint256 target,

        uint256 numerator,

        uint256 denominator

    )

    internal

    pure

    returns (uint256)

    {

        return target.mul(numerator).div(denominator);

    }



    /*

     * Return target * (numerator / denominator), but rounded up.

     */

    function getPartialRoundUp(

        uint256 target,

        uint256 numerator,

        uint256 denominator

    )

    internal

    pure

    returns (uint256)

    {

        if (target == 0 || numerator == 0) {

            // SafeMath will check for zero denominator

            return SafeMath.div(0, denominator);

        }

        return target.mul(numerator).sub(1).div(denominator).add(1);

    }



    function to128(

        uint256 number

    )

    internal

    pure

    returns (uint128)

    {

        uint128 result = uint128(number);

        Require.that(

            result == number,

            FILE,

            "Unsafe cast to uint128"

        );

        return result;

    }



    function to96(

        uint256 number

    )

    internal

    pure

    returns (uint96)

    {

        uint96 result = uint96(number);

        Require.that(

            result == number,

            FILE,

            "Unsafe cast to uint96"

        );

        return result;

    }



    function to32(

        uint256 number

    )

    internal

    pure

    returns (uint32)

    {

        uint32 result = uint32(number);

        Require.that(

            result == number,

            FILE,

            "Unsafe cast to uint32"

        );

        return result;

    }



    function min(

        uint256 a,

        uint256 b

    )

    internal

    pure

    returns (uint256)

    {

        return a < b ? a : b;

    }



    function max(

        uint256 a,

        uint256 b

    )

    internal

    pure

    returns (uint256)

    {

        return a > b ? a : b;

    }

}





/**

 * @title Types

 * @author dYdX

 *

 * Library for interacting with the basic structs used in Solo

 */

library Types {

    using Math for uint256;



    // ============ AssetAmount ============



    enum AssetDenomination {

        Wei, // the amount is denominated in wei

        Par  // the amount is denominated in par

    }



    enum AssetReference {

        Delta, // the amount is given as a delta from the current value

        Target // the amount is given as an exact number to end up at

    }



    struct AssetAmount {

        bool sign; // true if positive

        AssetDenomination denomination;

        AssetReference ref;

        uint256 value;

    }



    // ============ Par (Principal Amount) ============



    // Total borrow and supply values for a market

    struct TotalPar {

        uint128 borrow;

        uint128 supply;

    }



    // Individual principal amount for an account

    struct Par {

        bool sign; // true if positive

        uint128 value;

    }



    function zeroPar()

    internal

    pure

    returns (Par memory)

    {

        return Par({

            sign: false,

            value: 0

            });

    }



    function sub(

        Par memory a,

        Par memory b

    )

    internal

    pure

    returns (Par memory)

    {

        return add(a, negative(b));

    }



    function add(

        Par memory a,

        Par memory b

    )

    internal

    pure

    returns (Par memory)

    {

        Par memory result;

        if (a.sign == b.sign) {

            result.sign = a.sign;

            result.value = SafeMath.add(a.value, b.value).to128();

        } else {

            if (a.value >= b.value) {

                result.sign = a.sign;

                result.value = SafeMath.sub(a.value, b.value).to128();

            } else {

                result.sign = b.sign;

                result.value = SafeMath.sub(b.value, a.value).to128();

            }

        }

        return result;

    }



    function equals(

        Par memory a,

        Par memory b

    )

    internal

    pure

    returns (bool)

    {

        if (a.value == b.value) {

            if (a.value == 0) {

                return true;

            }

            return a.sign == b.sign;

        }

        return false;

    }



    function negative(

        Par memory a

    )

    internal

    pure

    returns (Par memory)

    {

        return Par({

            sign: !a.sign,

            value: a.value

            });

    }



    function isNegative(

        Par memory a

    )

    internal

    pure

    returns (bool)

    {

        return !a.sign && a.value > 0;

    }



    function isPositive(

        Par memory a

    )

    internal

    pure

    returns (bool)

    {

        return a.sign && a.value > 0;

    }



    function isZero(

        Par memory a

    )

    internal

    pure

    returns (bool)

    {

        return a.value == 0;

    }



    // ============ Wei (Token Amount) ============



    // Individual token amount for an account

    struct Wei {

        bool sign; // true if positive

        uint256 value;

    }



    function zeroWei()

    internal

    pure

    returns (Wei memory)

    {

        return Wei({

            sign: false,

            value: 0

            });

    }



    function sub(

        Wei memory a,

        Wei memory b

    )

    internal

    pure

    returns (Wei memory)

    {

        return add(a, negative(b));

    }



    function add(

        Wei memory a,

        Wei memory b

    )

    internal

    pure

    returns (Wei memory)

    {

        Wei memory result;

        if (a.sign == b.sign) {

            result.sign = a.sign;

            result.value = SafeMath.add(a.value, b.value);

        } else {

            if (a.value >= b.value) {

                result.sign = a.sign;

                result.value = SafeMath.sub(a.value, b.value);

            } else {

                result.sign = b.sign;

                result.value = SafeMath.sub(b.value, a.value);

            }

        }

        return result;

    }



    function equals(

        Wei memory a,

        Wei memory b

    )

    internal

    pure

    returns (bool)

    {

        if (a.value == b.value) {

            if (a.value == 0) {

                return true;

            }

            return a.sign == b.sign;

        }

        return false;

    }



    function negative(

        Wei memory a

    )

    internal

    pure

    returns (Wei memory)

    {

        return Wei({

            sign: !a.sign,

            value: a.value

            });

    }



    function isNegative(

        Wei memory a

    )

    internal

    pure

    returns (bool)

    {

        return !a.sign && a.value > 0;

    }



    function isPositive(

        Wei memory a

    )

    internal

    pure

    returns (bool)

    {

        return a.sign && a.value > 0;

    }



    function isZero(

        Wei memory a

    )

    internal

    pure

    returns (bool)

    {

        return a.value == 0;

    }

}





contract Enum {

    enum Operation {

        Call,

        DelegateCall

    }

}





interface ICErc20 {

    function mint(uint mintAmount) external returns (uint);

    function redeem(uint redeemTokens) external returns (uint);

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





contract SelfAuthorized {

    modifier authorized() {

        require(msg.sender == address(this), "Method can only be called from this contract");

        _;

    }

}





contract MasterCopy is SelfAuthorized {



    event ChangedMasterCopy(address masterCopy);



    // masterCopy always needs to be first declared variable, to ensure that it is at the same location as in the Proxy contract.

    // It should also always be ensured that the address is stored alone (uses a full word)

    address masterCopy;



    /// @dev Allows to upgrade the contract. This can only be done via a Safe transaction.

    /// @param _masterCopy New contract address.

    function changeMasterCopy(address _masterCopy)

    public

    authorized

    {

        // Master copy address cannot be null.

        require(_masterCopy != address(0), "Invalid master copy address provided");

        masterCopy = _masterCopy;

        emit ChangedMasterCopy(_masterCopy);

    }

}





contract Module is MasterCopy {



    ModuleManager public manager;



    modifier authorized() {

        require(msg.sender == address(manager), "Method can only be called from manager");

        _;

    }



    function setManager()

    internal

    {

        // manager can only be 0 at initalization of contract.

        // Check ensures that setup function can only be called once.

        require(address(manager) == address(0), "Manager has already been set");

        manager = ModuleManager(msg.sender);

    }

}





/// @title Compound DyDx Module - Allows to transfer DAI and USDC from Compound lending to dYdX lending and vise versa.

/// @author Igor Sobolev - <sobolev.igor@me.com>

contract CompoundDyDxModule is Module {



    string public constant NAME = "Compound dYdX Module";

    string public constant VERSION = "0.1.0";



    ISoloMargin public soloMargin;

    IERC20 public DAI;

    IERC20 public USDC;

    ICErc20 public cDAI;

    ICErc20 public cUSDC;



    enum SupportedToken {None, DAI, USDC}

    enum SupportedProtocol {DyDx, Compound}



    /// @dev Setup function sets initial storage of contract.

    /// @param _soloMargin Address of SoloMargin contract.

    /// @param _cDAI Address of cDAI contract.

    /// @param _cUSDC Address of cUSDC contract.

    function setup(

        ISoloMargin _soloMargin,

        IERC20 _DAI,

        ICErc20 _cDAI,

        IERC20 _USDC,

        ICErc20 _cUSDC

    )

        external

    {

        require(

            address(_soloMargin) != address(0),

            "CompoundDyDxModule: wrong soloMargin address!");

        require(

            address(_cDAI) != address(0),

            "CompoundDyDxModule: wrong cDAI address!");

        require(

            address(_DAI) != address(0),

            "CompoundDyDxModule: wrong DAI address!");

        require(

            address(_cUSDC) != address(0),

            "CompoundDyDxModule: wrong cUSDC address!");

        require(

            address(_USDC) != address(0),

            "CompoundDyDxModule: wrong USDC address!");



        soloMargin = _soloMargin;

        cDAI = _cDAI;

        DAI = _DAI;

        cUSDC = _cUSDC;

        USDC = _USDC;



        setManager();

    }



    /// @dev Allows to transfer funds from one lending to another. This can only be done via a Safe transaction.

    /// @param token One of two currently supported tokens.

    /// @param protocolFrom Protocol to withdraw funds from.

    /// @param protocolFrom Protocol to deposit funds to.

    /// @param amount Amount of tokens to transfer (in wei).

    function executeMove(

        SupportedToken token,

        SupportedProtocol protocolFrom,

        SupportedProtocol protocolTo,

        uint256 amount

    )

        external

        authorized

    {

        require(

            token != SupportedToken.None,

            "CompoundDyDxModule: incorrect input!");

        require(

            protocolFrom != protocolTo,

            "CompoundDyDxModule: dummy move to the same protocol!");

        require(

            amount > 0,

            "CompoundDyDxModule: dummy move without tokens!");



        if (protocolFrom == SupportedProtocol.Compound) {

            withdrawFromCompound(token, amount);

        } else if (protocolFrom == SupportedProtocol.DyDx) {

            withdrawFromDyDx(token, amount);

        }



        if (protocolTo == SupportedProtocol.DyDx) {

            depositToDyDx(token, amount);

        } else if (protocolTo == SupportedProtocol.Compound) {

            depositToCompound(token, amount);

        }

    }



    function withdrawFromCompound(

        SupportedToken token,

        uint256 amount

    )

        internal

    {

        (ICErc20 activeCToken,) = getTokensAddresses(token);



        (, bytes memory returnData) = manager.execTransactionFromModuleReturnData({

            to: address(activeCToken),

            value: 0,

            data: abi.encodeWithSelector(activeCToken.redeem.selector, amount),

            operation: Enum.Operation.Call

        });

        require(

            abi.decode(returnData, (uint256)) == 0,

            "Could not withdraw from Compound!");

    }



    function depositToCompound(

        SupportedToken token,

        uint256 amount

    )

        internal

    {

        (ICErc20 activeCToken, IERC20 activeToken) = getTokensAddresses(token);



        require(

            manager.execTransactionFromModule({

                to: address(activeToken),

                value: 0,

                data: abi.encodeWithSelector(activeToken.approve.selector, address(activeCToken), amount),

                operation: Enum.Operation.Call

            }),

            "Could not approve to Compound!");





        (, bytes memory returnData) = manager.execTransactionFromModuleReturnData({

            to: address(activeCToken),

            value: 0,

            data: abi.encodeWithSelector(activeCToken.mint.selector, amount),

            operation: Enum.Operation.Call

        });

        require(

            abi.decode(returnData, (uint256)) == 0,

            "Could not deposit to Compound!");

    }



    function withdrawFromDyDx(

        SupportedToken token,

        uint256 amount

    )

        internal

    {

        Account.Info[] memory accountInfo = new Account.Info[](1);

        accountInfo[0] = Account.Info({

            owner: address(this),

            number: 0

        });



        Types.AssetAmount memory assetAmount = Types.AssetAmount({

            sign: true, // true if positive

            denomination: Types.AssetDenomination.Wei, // (casted to 0) / or Par (casted to 1)

            ref: Types.AssetReference.Delta, // (casted to 0) / or Target (casted to 1)

            value: amount

        });

        Actions.ActionArgs[] memory actionArgs = new Actions.ActionArgs[](1);

        actionArgs[0] = Actions.ActionArgs({

            actionType: Actions.ActionType.Withdraw,

            accountId: 0,

            amount: assetAmount,

            primaryMarketId: uint256(token),

            secondaryMarketId: 0,

            otherAddress: address(this),

            otherAccountId: 0,

            data: new bytes(0)

        });



        require(

            manager.execTransactionFromModule({

                to: address(soloMargin),

                value: 0,

                data: abi.encodeWithSelector(soloMargin.operate.selector, accountInfo, actionArgs),

                operation: Enum.Operation.Call

            }),

            "Could not withdraw from dYdX!");

    }



    function depositToDyDx(

        SupportedToken token,

        uint256 amount

    )

        internal

    {

        (, IERC20 activeToken) = getTokensAddresses(token);



        Account.Info[] memory accountInfo = new Account.Info[](1);

        accountInfo[0] = Account.Info({

            owner: address(this),

            number: 0

        });

        Types.AssetAmount memory assetAmount = Types.AssetAmount({

            sign: true, // true if positive

            denomination: Types.AssetDenomination.Wei, // (casted to 0) / or Par (casted to 1)

            ref: Types.AssetReference.Delta, // (casted to 0) / or Target (casted to 1)

            value: amount

        });

        Actions.ActionArgs[] memory actionArgs = new Actions.ActionArgs[](1);

        actionArgs[0] = Actions.ActionArgs({

            actionType: Actions.ActionType.Deposit,

            accountId: 0,

            amount: assetAmount,

            primaryMarketId: uint256(token),

            secondaryMarketId: 0,

            otherAddress: address(this),

            otherAccountId: 0,

            data: new bytes(0)

        });



        require(

            manager.execTransactionFromModule({

                to: address(activeToken),

                value: 0,

                data: abi.encodeWithSelector(activeToken.approve.selector, address(soloMargin), amount),

                operation: Enum.Operation.Call

            }),

            "Could not approve to dYdX!");

        require(

            manager.execTransactionFromModule({

                to: address(soloMargin),

                value: 0,

                data: abi.encodeWithSelector(soloMargin.operate.selector, accountInfo, actionArgs),

                operation: Enum.Operation.Call

            }),

            "Could not deposit to dYdX!");



    }



    function getTokensAddresses(

        SupportedToken token

    )

        internal

        view

        returns (ICErc20 activeCToken, IERC20 activeToken)

    {

        if (token == SupportedToken.DAI) {

            activeCToken = cDAI;

            activeToken = DAI;

        } else if (token == SupportedToken.USDC) {

            activeCToken = cUSDC;

            activeToken = USDC;

        }

    }

}

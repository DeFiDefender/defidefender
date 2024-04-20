// File: contracts/CompoundInterfaces.sol



pragma solidity ^0.5.16;

pragma experimental ABIEncoderV2;



contract ERC20{

    uint public decimals;



    function balanceOf(address _address) external view returns (uint256 balance);

}



contract CTokenInterface{



    uint public totalBorrows;

    uint public totalReserves;

    string public symbol;



    function getCash() external view returns (uint);

    function totalBorrowsCurrent() external view returns (uint);

    function borrowRatePerBlock() external view returns (uint);

    function supplyRatePerBlock() external view returns (uint);

    function getAccountSnapshot(address account) external view returns (uint, uint, uint, uint);

}



contract Comptroller{

   struct Market {

          bool isListed;

          uint collateralFactorMantissa;

          bool isComped;

    }



    mapping(address => Market) public markets;

    mapping(address => uint) public compAccrued;

    function compSpeeds(address cTokenAddress) external view returns(uint);

    function getAllMarkets() public view returns (CToken[] memory) {}

}



contract PriceOracle{



    function getUnderlyingPrice(CToken cToken) public view returns (uint);

}



contract CToken{



}



contract CompoundLens {



    struct CompBalanceMetadataExt {

            uint balance;

            uint votes;

            address delegate;

            uint allocated;

    }



    function getCompBalanceMetadataExt(Comp comp, ComptrollerLensInterface comptroller, address account) external returns (CompBalanceMetadataExt memory);



}



contract Comp{



}



interface ComptrollerLensInterface {



}









contract UniswapAnchoredView{

    function price(string calldata symbol) external view returns (uint);

    function getUnderlyingPrice(address cToken) external view returns (uint);

}



contract CErc20{

    address public underlying;

}



// File: contracts/math/CarefulMath.sol



pragma solidity ^0.5.16;



/**

  * @title Careful Math

  * @author Compound

  * @notice Derived from OpenZeppelin's SafeMath library

  *         https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol

  */

contract CarefulMath {



    /**

     * @dev Possible error codes that we can return

     */

    enum MathError {

        NO_ERROR,

        DIVISION_BY_ZERO,

        INTEGER_OVERFLOW,

        INTEGER_UNDERFLOW

    }



    /**

    * @dev Multiplies two numbers, returns an error on overflow.

    */

    function mulUInt(uint a, uint b) internal pure returns (MathError, uint) {

        if (a == 0) {

            return (MathError.NO_ERROR, 0);

        }



        uint c = a * b;



        if (c / a != b) {

            return (MathError.INTEGER_OVERFLOW, 0);

        } else {

            return (MathError.NO_ERROR, c);

        }

    }



    /**

    * @dev Integer division of two numbers, truncating the quotient.

    */

    function divUInt(uint a, uint b) internal pure returns (MathError, uint) {

        if (b == 0) {

            return (MathError.DIVISION_BY_ZERO, 0);

        }



        return (MathError.NO_ERROR, a / b);

    }



    /**

    * @dev Subtracts two numbers, returns an error on overflow (i.e. if subtrahend is greater than minuend).

    */

    function subUInt(uint a, uint b) internal pure returns (MathError, uint) {

        if (b <= a) {

            return (MathError.NO_ERROR, a - b);

        } else {

            return (MathError.INTEGER_UNDERFLOW, 0);

        }

    }



    /**

    * @dev Adds two numbers, returns an error on overflow.

    */

    function addUInt(uint a, uint b) internal pure returns (MathError, uint) {

        uint c = a + b;



        if (c >= a) {

            return (MathError.NO_ERROR, c);

        } else {

            return (MathError.INTEGER_OVERFLOW, 0);

        }

    }



    /**

    * @dev add a and b and then subtract c

    */

    function addThenSubUInt(uint a, uint b, uint c) internal pure returns (MathError, uint) {

        (MathError err0, uint sum) = addUInt(a, b);



        if (err0 != MathError.NO_ERROR) {

            return (err0, 0);

        }



        return subUInt(sum, c);

    }

}



// File: contracts/math/Exponential.sol



pragma solidity ^0.5.16;





/**

 * @title Exponential module for storing fixed-precision decimals

 * @author Compound

 * @notice Exp is a struct which stores decimals with a fixed precision of 18 decimal places.

 *         Thus, if we wanted to store the 5.1, mantissa would store 5.1e18. That is:

 *         `Exp({mantissa: 5100000000000000000})`.

 */

contract Exponential is CarefulMath {

    uint constant expScale = 1e18;

    uint constant doubleScale = 1e36;

    uint constant halfExpScale = expScale/2;

    uint constant mantissaOne = expScale;



    struct Exp {

        uint mantissa;

    }



    struct Double {

        uint mantissa;

    }



    /**

     * @dev Creates an exponential from numerator and denominator values.

     *      Note: Returns an error if (`num` * 10e18) > MAX_INT,

     *            or if `denom` is zero.

     */

    function getExp(uint num, uint denom) pure internal returns (MathError, Exp memory) {

        (MathError err0, uint scaledNumerator) = mulUInt(num, expScale);

        if (err0 != MathError.NO_ERROR) {

            return (err0, Exp({mantissa: 0}));

        }



        (MathError err1, uint rational) = divUInt(scaledNumerator, denom);

        if (err1 != MathError.NO_ERROR) {

            return (err1, Exp({mantissa: 0}));

        }



        return (MathError.NO_ERROR, Exp({mantissa: rational}));

    }



    /**

     * @dev turn a number with mantissa(<18) to a mantissa of 18

     * Note: returns error if the existing mantissa is greater than 18

     */

    function getExp18(uint numMantissa, uint mantissa) pure internal returns (Exp memory) {



        uint scaledNum;



        if(mantissa > 18){

            scaledNum = div_(numMantissa, 10**sub_(mantissa, 18));

        }else{

            scaledNum = mul_(numMantissa, 10**sub_(18, mantissa));

        }



        return Exp({mantissa: scaledNum});

    }



    /**

     * @dev Adds two exponentials, returning a new exponential.

     */

    function addExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {

        (MathError error, uint result) = addUInt(a.mantissa, b.mantissa);



        return (error, Exp({mantissa: result}));

    }



    /**

     * @dev Subtracts two exponentials, returning a new exponential.

     */

    function subExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {

        (MathError error, uint result) = subUInt(a.mantissa, b.mantissa);



        return (error, Exp({mantissa: result}));

    }



    /**

     * @dev Multiply an Exp by a scalar, returning a new Exp.

     */

    function mulScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {

        (MathError err0, uint scaledMantissa) = mulUInt(a.mantissa, scalar);

        if (err0 != MathError.NO_ERROR) {

            return (err0, Exp({mantissa: 0}));

        }



        return (MathError.NO_ERROR, Exp({mantissa: scaledMantissa}));

    }



    /**

     * @dev Multiply an Exp by a scalar, then truncate to return an unsigned integer.

     */

    function mulScalarTruncate(Exp memory a, uint scalar) pure internal returns (MathError, uint) {

        (MathError err, Exp memory product) = mulScalar(a, scalar);

        if (err != MathError.NO_ERROR) {

            return (err, 0);

        }



        return (MathError.NO_ERROR, truncate(product));

    }



    /**

     * @dev Multiply an Exp by a scalar, truncate, then add an to an unsigned integer, returning an unsigned integer.

     */

    function mulScalarTruncateAddUInt(Exp memory a, uint scalar, uint addend) pure internal returns (MathError, uint) {

        (MathError err, Exp memory product) = mulScalar(a, scalar);

        if (err != MathError.NO_ERROR) {

            return (err, 0);

        }



        return addUInt(truncate(product), addend);

    }



    /**

     * @dev Divide an Exp by a scalar, returning a new Exp.

     */

    function divScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {

        (MathError err0, uint descaledMantissa) = divUInt(a.mantissa, scalar);

        if (err0 != MathError.NO_ERROR) {

            return (err0, Exp({mantissa: 0}));

        }



        return (MathError.NO_ERROR, Exp({mantissa: descaledMantissa}));

    }



    /**

     * @dev Divide a scalar by an Exp, returning a new Exp.

     */

    function divScalarByExp(uint scalar, Exp memory divisor) pure internal returns (MathError, Exp memory) {

        /*

          We are doing this as:

          getExp(mulUInt(expScale, scalar), divisor.mantissa)

          How it works:

          Exp = a / b;

          Scalar = s;

          `s / (a / b)` = `b * s / a` and since for an Exp `a = mantissa, b = expScale`

        */

        (MathError err0, uint numerator) = mulUInt(expScale, scalar);

        if (err0 != MathError.NO_ERROR) {

            return (err0, Exp({mantissa: 0}));

        }

        return getExp(numerator, divisor.mantissa);

    }



    /**

     * @dev Divide a scalar by an Exp, then truncate to return an unsigned integer.

     */

    function divScalarByExpTruncate(uint scalar, Exp memory divisor) pure internal returns (MathError, uint) {

        (MathError err, Exp memory fraction) = divScalarByExp(scalar, divisor);

        if (err != MathError.NO_ERROR) {

            return (err, 0);

        }



        return (MathError.NO_ERROR, truncate(fraction));

    }



    /**

     * @dev Multiplies two exponentials, returning a new exponential.

     */

    function mulExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {



        (MathError err0, uint doubleScaledProduct) = mulUInt(a.mantissa, b.mantissa);

        if (err0 != MathError.NO_ERROR) {

            return (err0, Exp({mantissa: 0}));

        }



        // We add half the scale before dividing so that we get rounding instead of truncation.

        //  See "Listing 6" and text above it at https://accu.org/index.php/journals/1717

        // Without this change, a result like 6.6...e-19 will be truncated to 0 instead of being rounded to 1e-18.

        (MathError err1, uint doubleScaledProductWithHalfScale) = addUInt(halfExpScale, doubleScaledProduct);

        if (err1 != MathError.NO_ERROR) {

            return (err1, Exp({mantissa: 0}));

        }



        (MathError err2, uint product) = divUInt(doubleScaledProductWithHalfScale, expScale);

        // The only error `div` can return is MathError.DIVISION_BY_ZERO but we control `expScale` and it is not zero.

        assert(err2 == MathError.NO_ERROR);



        return (MathError.NO_ERROR, Exp({mantissa: product}));

    }



    /**

     * @dev Multiplies two exponentials given their mantissas, returning a new exponential.

     */

    function mulExp(uint a, uint b) pure internal returns (MathError, Exp memory) {

        return mulExp(Exp({mantissa: a}), Exp({mantissa: b}));

    }



    /**

     * @dev Multiplies three exponentials, returning a new exponential.

     */

    function mulExp3(Exp memory a, Exp memory b, Exp memory c) pure internal returns (MathError, Exp memory) {

        (MathError err, Exp memory ab) = mulExp(a, b);

        if (err != MathError.NO_ERROR) {

            return (err, ab);

        }

        return mulExp(ab, c);

    }



    /**

     * @dev Divides two exponentials, returning a new exponential.

     *     (a/scale) / (b/scale) = (a/scale) * (scale/b) = a/b,

     *  which we can scale as an Exp by calling getExp(a.mantissa, b.mantissa)

     */

    function divExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {

        return getExp(a.mantissa, b.mantissa);

    }



    /**

     * @dev Truncates the given exp to a whole number value.

     *      For example, truncate(Exp{mantissa: 15 * expScale}) = 15

     */

    function truncate(Exp memory exp) pure internal returns (uint) {

        // Note: We are not using careful math here as we're performing a division that cannot fail

        return exp.mantissa / expScale;

    }



    /**

     * @dev Checks if first Exp is less than second Exp.

     */

    function lessThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {

        return left.mantissa < right.mantissa;

    }



    /**

     * @dev Checks if left Exp <= right Exp.

     */

    function lessThanOrEqualExp(Exp memory left, Exp memory right) pure internal returns (bool) {

        return left.mantissa <= right.mantissa;

    }



    /**

     * @dev Checks if left Exp > right Exp.

     */

    function greaterThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {

        return left.mantissa > right.mantissa;

    }



    /**

     * @dev returns true if Exp is exactly zero

     */

    function isZeroExp(Exp memory value) pure internal returns (bool) {

        return value.mantissa == 0;

    }



    function safe224(uint n, string memory errorMessage) pure internal returns (uint224) {

        require(n < 2**224, errorMessage);

        return uint224(n);

    }



    function safe32(uint n, string memory errorMessage) pure internal returns (uint32) {

        require(n < 2**32, errorMessage);

        return uint32(n);

    }



    function add_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {

        return Exp({mantissa: add_(a.mantissa, b.mantissa)});

    }



    function add_(Double memory a, Double memory b) pure internal returns (Double memory) {

        return Double({mantissa: add_(a.mantissa, b.mantissa)});

    }



    function add_(uint a, uint b) pure internal returns (uint) {

        return add_(a, b, "addition overflow");

    }



    function add_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {

        uint c = a + b;

        require(c >= a, errorMessage);

        return c;

    }



    function sub_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {

        return Exp({mantissa: sub_(a.mantissa, b.mantissa)});

    }



    function sub_(Double memory a, Double memory b) pure internal returns (Double memory) {

        return Double({mantissa: sub_(a.mantissa, b.mantissa)});

    }



    function sub_(uint a, uint b) pure internal returns (uint) {

        return sub_(a, b, "subtraction underflow");

    }



    function sub_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {

        require(b <= a, errorMessage);

        return a - b;

    }



    function mul_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {

        return Exp({mantissa: mul_(a.mantissa, b.mantissa) / expScale});

    }



    function mul_(Exp memory a, uint b) pure internal returns (Exp memory) {

        return Exp({mantissa: mul_(a.mantissa, b)});

    }



    function mul_(uint a, Exp memory b) pure internal returns (uint) {

        return mul_(a, b.mantissa) / expScale;

    }



    function mul_(Double memory a, Double memory b) pure internal returns (Double memory) {

        return Double({mantissa: mul_(a.mantissa, b.mantissa) / doubleScale});

    }



    function mul_(Double memory a, uint b) pure internal returns (Double memory) {

        return Double({mantissa: mul_(a.mantissa, b)});

    }



    function mul_(uint a, Double memory b) pure internal returns (uint) {

        return mul_(a, b.mantissa) / doubleScale;

    }



    function mul_(uint a, uint b) pure internal returns (uint) {

        return mul_(a, b, "multiplication overflow");

    }



    function mul_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {

        if (a == 0 || b == 0) {

            return 0;

        }

        uint c = a * b;

        require(c / a == b, errorMessage);

        return c;

    }



    function div_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {

        return Exp({mantissa: div_(mul_(a.mantissa, expScale), b.mantissa)});

    }



    function div_(Exp memory a, uint b) pure internal returns (Exp memory) {

        return Exp({mantissa: div_(a.mantissa, b)});

    }



    function div_(uint a, Exp memory b) pure internal returns (uint) {

        return div_(mul_(a, expScale), b.mantissa);

    }



    function div_(Double memory a, Double memory b) pure internal returns (Double memory) {

        return Double({mantissa: div_(mul_(a.mantissa, doubleScale), b.mantissa)});

    }



    function div_(Double memory a, uint b) pure internal returns (Double memory) {

        return Double({mantissa: div_(a.mantissa, b)});

    }



    function div_(uint a, Double memory b) pure internal returns (uint) {

        return div_(mul_(a, doubleScale), b.mantissa);

    }



    function div_(uint a, uint b) pure internal returns (uint) {

        return div_(a, b, "divide by zero");

    }



    function div_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {

        require(b > 0, errorMessage);

        return a / b;

    }



    function fraction(uint a, uint b) pure internal returns (Double memory) {

        return Double({mantissa: div_(mul_(a, doubleScale), b)});

    }

}



// File: contracts/utility/ErrorReporter.sol



pragma solidity ^0.5.16;





contract CompFarmingSummaryErrorReporter {

    enum Error {

        NO_ERROR,

        CTOKEN_NOT_FOUND,

        CETH_NOT_SUPPORTED,

        ACCOUNT_SNAPSHOT_ERROR,

        UNAUTHORIZED

    }



    enum FailureInfo {

        SET_PENDING_IMPLEMENTATION_OWNER_CHECK,

        ACCEPT_PENDING_IMPLEMENTATION_ADDRESS_CHECK,

        SET_PENDING_ADMIN_OWNER_CHECK,

        ACCEPT_ADMIN_PENDING_ADMIN_CHECK

    }





     event Failure(uint error, uint info, uint detail);



     function fail(Error err, FailureInfo info) internal returns (uint) {

         emit Failure(uint(err), uint(info), 0);



         return uint(err);

     }



     function failOpaque(Error err, FailureInfo info, uint opaqueError) internal returns (uint) {

         emit Failure(uint(err), uint(info), opaqueError);



         return uint(err);

     }



}



// File: contracts/CompFarmingSummaryInterface.sol



pragma solidity ^0.5.16;





interface CompFarmingSummaryInterface {



     struct CompProfile{

          uint balance;

          uint yetToClaimed;

     }



     function getPriceCOMP() external view returns (uint256 priceInUSD);

     function sortedCompDistSpeedAllMarkets() external view returns (string[] memory sortedCTokenNameList, uint[] memory sortedCompSpeedList);

     function compProfile(address account) external returns(CompProfile memory _compProfile);

     function totalCompIncomePerYear(address _account) external view returns(uint errCode, string memory errCTokenSymbol, uint256 totalCompIncomeMantissa);

}



// File: contracts/CompFarmingSummaryProxyStorage.sol



pragma solidity ^0.5.16;



contract CompFarmingSummaryProxyStorage {

    address public admin;

    address public pendingAdmin;

    address public compFarmingSummaryImplmentation;

    address public pendingCompFarmingSummaryImplmentation;

}





contract CompFarmingSummaryStorageV1 is CompFarmingSummaryProxyStorage{

  

}



// File: contracts/CompFarmingSummaryProxy.sol



pragma solidity ^0.5.16;









contract CompFarmingSummaryProxy is CompFarmingSummaryProxyStorage, CompFarmingSummaryErrorReporter{

    event NewPendingImplementation(address oldPendingImplementation, address newPendingImplementation);

    event NewImplementation(address oldImplementation, address newImplementation);

    event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);

    event NewAdmin(address oldAdmin, address newAdmin);



    constructor() public {

        admin = msg.sender;

    }



    function _setPendingImplementation(address newPendingImplementation) public returns (uint) {



        if (msg.sender != admin) {

            return fail(Error.UNAUTHORIZED, FailureInfo.SET_PENDING_IMPLEMENTATION_OWNER_CHECK);

        }



        address oldPendingImplementation = pendingCompFarmingSummaryImplmentation;



        pendingCompFarmingSummaryImplmentation = newPendingImplementation;



        emit NewPendingImplementation(oldPendingImplementation, pendingCompFarmingSummaryImplmentation);



        return uint(Error.NO_ERROR);

    }



    function _acceptImplementation() public returns (uint) {



        if (msg.sender != pendingCompFarmingSummaryImplmentation || pendingCompFarmingSummaryImplmentation == address(0)) {

            return fail(Error.UNAUTHORIZED, FailureInfo.ACCEPT_PENDING_IMPLEMENTATION_ADDRESS_CHECK);

        }



        // Save current values for inclusion in log

        address oldImplementation = compFarmingSummaryImplmentation;

        address oldPendingImplementation = pendingCompFarmingSummaryImplmentation;



        compFarmingSummaryImplmentation = pendingCompFarmingSummaryImplmentation;



        pendingCompFarmingSummaryImplmentation = address(0);



        emit NewImplementation(oldImplementation, compFarmingSummaryImplmentation);

        emit NewPendingImplementation(oldPendingImplementation, pendingCompFarmingSummaryImplmentation);



        return uint(Error.NO_ERROR);

    }





    function _setPendingAdmin(address newPendingAdmin) public returns (uint) {



        if (msg.sender != admin) {

            return fail(Error.UNAUTHORIZED, FailureInfo.SET_PENDING_ADMIN_OWNER_CHECK);

        }



        address oldPendingAdmin = pendingAdmin;



        pendingAdmin = newPendingAdmin;



        emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin);



        return uint(Error.NO_ERROR);

    }



    function _acceptAdmin() public returns (uint) {



        if (msg.sender != pendingAdmin || msg.sender == address(0)) {

            return fail(Error.UNAUTHORIZED, FailureInfo.ACCEPT_ADMIN_PENDING_ADMIN_CHECK);

        }



        address oldAdmin = admin;

        address oldPendingAdmin = pendingAdmin;



        admin = pendingAdmin;



        pendingAdmin = address(0);



        emit NewAdmin(oldAdmin, admin);

        emit NewPendingAdmin(oldPendingAdmin, pendingAdmin);



        return uint(Error.NO_ERROR);

    }



    function () payable external {

        // delegate all other functions to current implementation

        (bool success, ) = compFarmingSummaryImplmentation.delegatecall(msg.data);



        assembly {

              let free_mem_ptr := mload(0x40)

              returndatacopy(free_mem_ptr, 0, returndatasize)



              switch success

              case 0 { revert(free_mem_ptr, returndatasize) }

              default { return(free_mem_ptr, returndatasize) }

        }

    }







}



// File: contracts/CompFarmingSummaryV1.sol



pragma solidity ^0.5.16;















contract CompFarmingSummaryV1 is CompFarmingSummaryStorageV1, CompFarmingSummaryInterface, Exponential, CompFarmingSummaryErrorReporter{





    struct CompIncomeLocalVars{

        uint cTokenDecimals;

        uint underlyingDecimals;

        uint compDistSpeedErrCode;

        uint getAccountSnapshotErrCode;

        uint cTokenBalanceMantissa18;

        uint borrowBalanceMantissa18;

        uint exchangeRateMantissa18;

        uint supplyRatePerBlock;

        uint borrowRatePerBlock;

        uint totalSupply;

        uint totalBorrow;

        Exp compIncomePerBlockExp;

        Exp underlyingTokenBalanceExp;

        Exp loanBalanceExp;

        Exp loanBalanceWithInterestExp;

        Exp supplyPercentageExp;

        Exp borrowPercentageExp;

        Exp compIncomeOnSupplyExp;

        Exp compIncomeOnBorrowExp;

        Exp compIncomeExp;

        Exp compReleasedExp;

    }



    struct getAccountSnapshotLocalVars{

        uint errCode;

        uint cTokenBalance;

        uint borrowBalance;

        uint exchangeRateMantissa;

        uint cTokenBalanceMantissa18;

        uint borrowBalanceMantissa18;

        uint exchangeRateMantissa18;

        MathError cTokenBalanceExpErr;

        Exp cTokenBalanceExp;

        MathError borrowBalanceExpErr;

        Exp borrowBalanceExp;

        MathError exchangeRateExpErr;

        Exp exchangeRateExp;

    }



    constructor() public {



    }



    //note: add view

    function getPriceCOMP() external view returns (uint256 priceInUSD){

        UniswapAnchoredView uniswapAnchoredView = UniswapAnchoredView(getUniswapAnchoredViewAddress());

        priceInUSD = uniswapAnchoredView.price("COMP");

    }



    //note: add view

    function sortedCompDistSpeedAllMarkets() external view returns (string[] memory sortedCTokenNameList, uint[] memory sortedCompSpeedList) {



        string[] memory cTokenNameList = cTokenNameList();



        string[] memory _cTokenNameList = new string[](cTokenNameList.length);

        uint[] memory compSpeedList = new uint[](cTokenNameList.length);



        Exp memory compAmountPerBlockExp;



        for(uint i = 0; i < cTokenNameList.length; i++){



                compAmountPerBlockExp = compDistSpeed(contractSymbolToAddressMap(cTokenNameList[i]));

                _cTokenNameList[i] = cTokenNameList[i];

                compSpeedList[i] = compAmountPerBlockExp.mantissa;



        }



        //sort compSpeedList

        (sortedCTokenNameList, sortedCompSpeedList) = quickSortDESC(_cTokenNameList, compSpeedList);

    }



    //note: add view

    function compProfile(address account) external returns(CompProfile memory _compProfile){



        CompoundLens compoundLens = CompoundLens(getCompoundLensAddress());

        CompoundLens.CompBalanceMetadataExt memory result = compoundLens.getCompBalanceMetadataExt(Comp(getCompAddress()), ComptrollerLensInterface(getUnitrollerAddress()), account);

        _compProfile.balance = result.balance;

        _compProfile.yetToClaimed = result.allocated;

    }



    //note: add view

    function totalCompIncomePerYear(address _account) external view returns(uint errCode, string memory, uint256 totalCompIncomeMantissa){

        (Error err, string memory _errCTokenSymbol, Exp memory totalCompIncomeExp) = totalCompIncome(_account, div_(estimatedNumberOfBlocksPerYear(), expScale));

        //require(err == Error.NO_ERROR, appendStrings("Error occured on: ", errCTokenSymbol));

        if(err != Error.NO_ERROR){

            return (uint(err), _errCTokenSymbol, 0);

        }



        return (0, "", totalCompIncomeExp.mantissa);

    }





    //note: add view

    function totalCompIncome(address _account, uint numberOfBlocks) internal view returns(Error, string memory, Exp memory compIncomeForThePeriodExp){



        string[] memory cTokenNameList = cTokenNameList();



        uint256 numberOfMarkets = cTokenNameList.length;



        Error err = Error.NO_ERROR;

        Exp[] memory compIncomeExpOfTheMarketList = new Exp[](numberOfMarkets);

        compIncomeForThePeriodExp = Exp({mantissa: 0});



        for(uint i = 0; i < numberOfMarkets; i++){



            string memory cTokenName = cTokenNameList[i];



            (err, compIncomeExpOfTheMarketList[i]) = compIncomeByCToken(_account, contractSymbolToAddressMap(cTokenName), numberOfBlocks);



            if(err != Error.NO_ERROR){

                return (err, cTokenName, Exp({mantissa: 0}));

            }

            //addLog(cTokenName);

            //addLog(compIncomeExpOfTheMarketList[i].mantissa);

            compIncomeForThePeriodExp = add_(compIncomeForThePeriodExp, compIncomeExpOfTheMarketList[i]);

        }







        return (Error.NO_ERROR, "", compIncomeForThePeriodExp);



    }







    //note: add view

    function compIncomeByCToken(address _account, address cTokenAddress, uint numberOfBlocks) internal view returns(Error, Exp memory){





        CompIncomeLocalVars memory v;



        //get cToken Decimals

        v.cTokenDecimals = ERC20(cTokenAddress).decimals();

        v.underlyingDecimals = underlyingDecimals(cTokenAddress);



        //get comp token distrubtion speed

        v.compIncomePerBlockExp = compDistSpeed(cTokenAddress);

        //continue to refractor here



        //get account snapshot

        (v.getAccountSnapshotErrCode, v.cTokenBalanceMantissa18, v.borrowBalanceMantissa18, v.exchangeRateMantissa18) = getAccountSnapshot(_account, cTokenAddress);

        if(v.getAccountSnapshotErrCode != 0){

            return (Error.ACCOUNT_SNAPSHOT_ERROR, Exp({mantissa: 0}));

        }

        //underlyingTokenBalance

        v.underlyingTokenBalanceExp = mul_(Exp({mantissa: v.cTokenBalanceMantissa18}), Exp({mantissa: v.exchangeRateMantissa18}));



        //loanBalanceExp

        v.loanBalanceExp = Exp({mantissa: v.borrowBalanceMantissa18});



        //totalSupplyWithInterest

        v.totalSupply = getTotalSupply(cTokenAddress);



        //totalBorrowWithInterest

        v.totalBorrow = getTotalBorrow(cTokenAddress);



        //supplyPercentageMantissa

        v.supplyPercentageExp = div_(mul_(v.underlyingTokenBalanceExp, expScale), v.totalSupply);

        v.borrowPercentageExp = div_(mul_(v.loanBalanceExp, expScale), v.totalBorrow);



        v.compReleasedExp = mul_(v.compIncomePerBlockExp, numberOfBlocks);



        v.compIncomeOnSupplyExp = mul_(v.compReleasedExp, v.supplyPercentageExp);



        v.compIncomeOnBorrowExp = mul_(v.compReleasedExp, v.borrowPercentageExp);



        v.compIncomeExp = add_(v.compIncomeOnSupplyExp, v.compIncomeOnBorrowExp);





        return (Error.NO_ERROR, v.compIncomeExp);

    }



    //note: add view

    function getCTokenTotalSupply (address cTokenAddress) internal view returns (Error err, uint256 totalSupplyValueInUSD) {



        string[] memory cTokenNameList = cTokenNameList();



        //check

        require(hasCToken(cTokenAddress, cTokenNameList), "cToken not found!");



        address underlyingAddress = CErc20(cTokenAddress).underlying();



        uint256 totalSupply = getTotalSupply(cTokenAddress);



        Exp memory totalSupplyExp = getExp18(totalSupply, ERC20(underlyingAddress).decimals());//Exp({mantissa: mul_(totalSupply, 10**(sub_(18, ERC20(underlyingAddress).decimals()))});

        Exp memory underlyingPriceInUSDExp = Exp({mantissa: getPriceInUSD(cTokenAddress)});

        Exp memory totalSupplyValueExp = mul_(totalSupplyExp, underlyingPriceInUSDExp);



        totalSupplyValueInUSD = totalSupplyValueExp.mantissa;



        return (Error.NO_ERROR, totalSupplyValueInUSD);



    }





    function getPriceInUSD(address cTokenAddress) public view returns (uint256 priceInUSD) {

        UniswapAnchoredView uniswapAnchoredView = UniswapAnchoredView(getUniswapAnchoredViewAddress());

        priceInUSD = uniswapAnchoredView.getUnderlyingPrice(cTokenAddress);

    }



    function getTotalSupply(address cTokenAddress) internal view returns (uint256 totalSupply){

        uint256 cash = CTokenInterface(cTokenAddress).getCash();

        uint256 totalBorrow = CTokenInterface(cTokenAddress).totalBorrows();

        uint256 totalReserves = CTokenInterface(cTokenAddress).totalReserves();



        totalSupply = sub_(add_(cash, totalBorrow), totalReserves);



    }



    function getAccountSnapshot(address _account, address cTokenAddress) internal view returns (uint256, uint256, uint256, uint256){



        getAccountSnapshotLocalVars memory v;



        CTokenInterface cToken = CTokenInterface(cTokenAddress);

        uint256 cTokenDecimals = ERC20(cTokenAddress).decimals();

        uint256 _underlyingDecimals = underlyingDecimals(cTokenAddress);





        (v.errCode, v.cTokenBalance, v.borrowBalance, v.exchangeRateMantissa) = cToken.getAccountSnapshot(_account);



        if(v.errCode != 0){

            return (v.errCode, 0, 0, 0);

        }



        v.cTokenBalanceExp = getExp18(v.cTokenBalance, cTokenDecimals);

        v.borrowBalanceExp = getExp18(v.borrowBalance, _underlyingDecimals);

        v.exchangeRateExp = getExp18(v.exchangeRateMantissa, mantissaOfExchangeRate(cTokenAddress));

        v.cTokenBalanceMantissa18 = v.cTokenBalanceExp.mantissa;

        v.borrowBalanceMantissa18 = v.borrowBalanceExp.mantissa;

        v.exchangeRateMantissa18 = v.exchangeRateExp.mantissa;



        return (0, v.cTokenBalanceMantissa18, v.borrowBalanceMantissa18, v.exchangeRateMantissa18);

    }







    function cTokenNameList() internal view returns(string[] memory _cTokenNameList){

          Comptroller comptroller = Comptroller(getUnitrollerAddress());

          CToken[] memory allMarkets = comptroller.getAllMarkets();



          bool isListed;

          bool isComped;

          address addressOfMarket;

          uint _index;

          string[] memory _cTokenNameListFullSize = new string[](allMarkets.length);



          for(uint i = 0; i < allMarkets.length; i++){

              addressOfMarket = address(allMarkets[i]);

              (isListed, , isComped) = comptroller.markets(addressOfMarket);



              if(isListed && isComped){

                  address cTokenAddress = address(allMarkets[i]);

                  string memory cTokenName = CTokenInterface(cTokenAddress).symbol();

                  _cTokenNameListFullSize[_index] = cTokenName;



                  _index++;

              }

          }



          _cTokenNameList = new string[](_index);



          for(uint i = 0; i < _cTokenNameList.length; i++){

              _cTokenNameList[i] = _cTokenNameListFullSize[i];

          }

    }



    function contractSymbolToAddressMap(string memory symbol) internal view returns (address){

          Comptroller comptroller = Comptroller(getUnitrollerAddress());

          CToken[] memory allMarkets = comptroller.getAllMarkets();



          for(uint i = 0; i < allMarkets.length; i++){

              address addressOfMarket = address(allMarkets[i]);

              string memory symbolOfMarket = CTokenInterface(addressOfMarket).symbol();



              if(compareStrings(symbolOfMarket, symbol)){

                  return addressOfMarket;

              }

          }



          return address(0);

    }



    function hasCToken(address cTokenAddress, string[] memory _cTokenNameList) internal view returns (bool) {

        for(uint i = 0; i < _cTokenNameList.length; i++){

            if(compareStrings(_cTokenNameList[i], CTokenInterface(cTokenAddress).symbol())){

                return true;

            }

        }



        return false;

    }



    //require to check cTokenAddress is valid

    function underlyingDecimals(address cTokenAddress) internal view returns (uint256) {



        if(cTokenAddress == getCEthAddress()){

            return 18;

        }



        address underlyingAddress = CErc20(cTokenAddress).underlying();



        return ERC20(underlyingAddress).decimals();

    }



    function mantissaOfExchangeRate(address cTokenAddress) internal view returns (uint256 mantissa) {



        uint256 _underlyingDecimals = underlyingDecimals(cTokenAddress);

        uint256 cTokenDecimals = ERC20(cTokenAddress).decimals();



        mantissa = sub_(add_(18, _underlyingDecimals), cTokenDecimals);

    }



    function getTotalBorrow(address cTokenAddress) internal view returns (uint totalBorrow){

        CTokenInterface cToken = CTokenInterface(cTokenAddress);

        totalBorrow = cToken.totalBorrows();

    }



    function compDistSpeed(address cTokenAddress) internal view returns (Exp memory compAmountPerBlockExp){



        Comptroller comptroller = Comptroller(getUnitrollerAddress());



        uint256 compDecimals = ERC20(getCompAddress()).decimals();



        uint256 compAmountPerBlock = comptroller.compSpeeds(cTokenAddress);



        compAmountPerBlockExp = getExp18(compAmountPerBlock, compDecimals);//Exp({mantissa: mul_(compAmountPerBlock, 10**sub_(18, compDecimals))});



        return compAmountPerBlockExp;



    }



    function estimatedNumberOfBlocksPerYear() internal pure returns (uint256 numberOfBlocksPerYearMantissa){

        uint256 numberOfBlockPerSec = 14;

        uint256 secsPerYear = 31536000;



        (MathError err, Exp memory numberOfBlocksPerYearExp) = getExp(secsPerYear, numberOfBlockPerSec);

        if(err != MathError.NO_ERROR){ return 0; }



        numberOfBlocksPerYearMantissa = numberOfBlocksPerYearExp.mantissa;

    }



    function compareStrings (string memory a, string memory b) public pure returns (bool) {

          return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))) );

    }



    function quickSortDESC(string[] memory keys, uint[] memory values) internal pure returns (string[] memory, uint[] memory){



          string[] memory keysPlus = new string[](keys.length + 1);

          uint[] memory valuesPlus = new uint[](values.length + 1);



          for(uint i = 0; i < keys.length; i++){

              keysPlus[i] = keys[i];

              valuesPlus[i] = values[i];

          }



          (keysPlus, valuesPlus) = quickSort(keysPlus, valuesPlus, 0, keysPlus.length - 1);



          string[] memory keys_desc = new string[](keys.length);

          uint[] memory values_desc = new uint[](values.length);

          for(uint i = 0; i < keys.length; i++){

              keys_desc[keys.length - 1 - i] = keysPlus[i + 1];

              values_desc[keys.length - 1 - i] = valuesPlus[i + 1];

          }



          return (keys_desc, values_desc);

    }



    function quickSort(string[] memory keys, uint[] memory values, uint left, uint right) internal pure returns (string[] memory, uint[] memory){

          uint i = left;

          uint j = right;

          uint pivot = values[left + (right - left) / 2];

          while (i <= j) {

              while (values[i] < pivot) i++;

              while (pivot < values[j]) j--;

              if (i <= j) {

                  (keys[i], keys[j]) = (keys[j], keys[i]);

                  (values[i], values[j]) = (values[j], values[i]);

                  i++;

                  j--;

              }

          }

          if (left < j)

              quickSort(keys, values, left, j);



          if (i < right)

              quickSort(keys, values, i, right);



              return (keys, values);

    }



    function getCEthAddress() internal pure returns(address){

          return 0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5;

    }



    function getCompAddress() internal pure returns(address){

          return 0xc00e94Cb662C3520282E6f5717214004A7f26888;

    }



    function getUnitrollerAddress() internal pure returns(address){

          return 0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B;

    }



    function getCompoundLensAddress() internal pure returns(address){

          return 0xd513d22422a3062Bd342Ae374b4b9c20E0a9a074;

    }



    function getUniswapAnchoredViewAddress() internal pure returns(address){

          return 0x922018674c12a7F0D394ebEEf9B58F186CdE13c1;

    }



    //admin functions

    function _become(CompFarmingSummaryProxy proxy) public {

        require(msg.sender == proxy.admin(), "only admin can change brains");



        require(proxy._acceptImplementation() == 0, "changes not permitted");

    }





    function getVersion() external pure returns(uint){

          return 1;

    }







}

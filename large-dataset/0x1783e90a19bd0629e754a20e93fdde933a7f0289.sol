pragma solidity ^0.5.0;

pragma experimental ABIEncoderV2;



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



contract Exponential is CarefulMath {

    uint constant expScale = 1e18;

    uint constant halfExpScale = expScale/2;

    uint constant mantissaOne = expScale;



    struct Exp {

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

}



contract ComptrollerInterface {

    function enterMarkets(address[] calldata cTokens) external returns (uint256[] memory);



    function exitMarket(address cToken) external returns (uint256);



    function getAssetsIn(address account) external view returns (address[] memory);



    function markets(address account) public view returns (bool, uint256);



    function getAccountLiquidity(address account) external view returns (uint256, uint256, uint256);

}





contract CToken {

    function getAccountSnapshot(address account) external view returns (uint, uint, uint, uint);

}



contract CompoundOracle {

    function getUnderlyingPrice(address cToken) external view returns (uint);

}



contract CompoundLoanInfo is Exponential {

    // solhint-disable-next-line const-name-snakecase

    ComptrollerInterface public constant comp = ComptrollerInterface(0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B);



    // solhint-disable-next-line const-name-snakecase

    CompoundOracle public constant oracle = CompoundOracle(0x1D8aEdc9E924730DD3f9641CDb4D1B92B848b4bd);



    struct LoanData {

        uint128 ratio;

        address[] collAddr;

        address[] borrowAddr;

        uint[] collAmounts;

        uint[] borrowAmounts;

    }



    function getRatio(address _user) public view returns (uint) {

        // For each asset the account is in

        address[] memory assets = comp.getAssetsIn(_user);



        uint sumCollateral = 0;

        uint sumBorrow = 0;



        for (uint i = 0; i < assets.length; i++) {

            address asset = assets[i];



            (, uint cTokenBalance, uint borrowBalance, uint exchangeRateMantissa)

                                        = CToken(asset).getAccountSnapshot(_user);



            Exp memory oraclePrice;



            if (cTokenBalance != 0 || borrowBalance != 0) {

                oraclePrice = Exp({mantissa: oracle.getUnderlyingPrice(asset)});

            }



            // Sum up collateral in Eth

            if (cTokenBalance != 0) {

                Exp memory exchangeRate = Exp({mantissa: exchangeRateMantissa});

                (, Exp memory tokensToEther) = mulExp(exchangeRate, oraclePrice);

                (, sumCollateral) = mulScalarTruncateAddUInt(tokensToEther, cTokenBalance, sumCollateral);

            }



            // Sum up debt in Eth

            if (borrowBalance != 0) {

                (, sumBorrow) = mulScalarTruncateAddUInt(oraclePrice, borrowBalance, sumBorrow);

            }

        }



        if (sumBorrow == 0) return 0;



        return (sumCollateral * 10**18) / sumBorrow;

    }



    function getPrices(address[] memory _cTokens) public view returns (uint[] memory prices) {

        for(uint i = 0; i < _cTokens.length; ++i) {

            prices[i] = oracle.getUnderlyingPrice(_cTokens[i]);

        }

    }



    function getCollFactors(address[] memory _cTokens) public view returns (uint[] memory collFactors) {

        for(uint i = 0; i < _cTokens.length; ++i) {

            (, collFactors[i]) = comp.markets(_cTokens[i]);

        }

    }



    function getLoanData(address _user) public view returns (LoanData memory data) {

        // For each asset the account is in

        address[] memory assets = comp.getAssetsIn(_user);



        uint sumCollateral = 0;

        uint sumBorrow = 0;

        uint collPos = 0;

        uint borrowPos = 0;



        for (uint i = 0; i < assets.length; i++) {

            address asset = assets[i];



            (, uint cTokenBalance, uint borrowBalance, uint exchangeRateMantissa)

                                        = CToken(asset).getAccountSnapshot(_user);



            Exp memory oraclePrice;



            if (cTokenBalance != 0 || borrowBalance != 0) {

                oraclePrice = Exp({mantissa: oracle.getUnderlyingPrice(asset)});

            }



            // Sum up collateral in Eth

            if (cTokenBalance != 0) {

                Exp memory exchangeRate = Exp({mantissa: exchangeRateMantissa});

                (, Exp memory tokensToEther) = mulExp(exchangeRate, oraclePrice);

                (, sumCollateral) = mulScalarTruncateAddUInt(tokensToEther, cTokenBalance, sumCollateral);



                data.collAddr[collPos] = asset;

                (, data.collAmounts[collPos]) = mulScalarTruncate(tokensToEther, cTokenBalance);

                collPos++;

            }



            // Sum up debt in Eth

            if (borrowBalance != 0) {

                (, sumBorrow) = mulScalarTruncateAddUInt(oraclePrice, borrowBalance, sumBorrow);



                data.borrowAddr[borrowPos] = asset;

                (, data.borrowAmounts[borrowPos]) = mulScalarTruncate(oraclePrice, borrowBalance);

                borrowPos++;

            }

        }



        data.ratio = uint128((sumCollateral * 10**18) / sumBorrow);



    }



    function getLoanDataArr(address[] memory _users) public view returns (LoanData[] memory loans) {

        for(uint i = 0; i < _users.length; ++i) {

            loans[i] = getLoanData(_users[i]);

        }

    }

}

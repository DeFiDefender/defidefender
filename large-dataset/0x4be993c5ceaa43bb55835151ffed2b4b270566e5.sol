pragma solidity ^0.6.0;

pragma experimental ABIEncoderV2;



interface MemoryInterface {

    function getUint(uint _id) external returns (uint _num);

    function setUint(uint _id, uint _val) external;

}



interface TokenInterface {

    function approve(address, uint256) external;

    function transfer(address, uint) external;

    function transferFrom(address, address, uint) external;

    function deposit() external payable;

    function withdraw(uint) external;

    function balanceOf(address) external view returns (uint);

    function decimals() external view returns (uint);

}



interface AaveInterface {

    function deposit(address _asset, uint256 _amount, address _onBehalfOf, uint16 _referralCode) external;

    function withdraw(address _asset, uint256 _amount, address _to) external;

    function borrow(

        address _asset,

        uint256 _amount,

        uint256 _interestRateMode,

        uint16 _referralCode,

        address _onBehalfOf

    ) external;

    function repay(address _asset, uint256 _amount, uint256 _rateMode, address _onBehalfOf) external;

    function setUserUseReserveAsCollateral(address _asset, bool _useAsCollateral) external;

    function getUserAccountData(address user) external view returns (

        uint256 totalCollateralETH,

        uint256 totalDebtETH,

        uint256 availableBorrowsETH,

        uint256 currentLiquidationThreshold,

        uint256 ltv,

        uint256 healthFactor

    );

}



interface AaveLendingPoolProviderInterface {

    function getLendingPool() external view returns (address);

}



// Aave Protocol Data Provider

interface AaveDataProviderInterface {

    function getReserveTokensAddresses(address _asset) external view returns (

        address aTokenAddress,

        address stableDebtTokenAddress,

        address variableDebtTokenAddress

    );

    function getUserReserveData(address _asset, address _user) external view returns (

        uint256 currentATokenBalance,

        uint256 currentStableDebt,

        uint256 currentVariableDebt,

        uint256 principalStableDebt,

        uint256 scaledVariableDebt,

        uint256 stableBorrowRate,

        uint256 liquidityRate,

        uint40 stableRateLastUpdated,

        bool usageAsCollateralEnabled

    );

    function getReserveConfigurationData(address asset) external view returns (

        uint256 decimals,

        uint256 ltv,

        uint256 liquidationThreshold,

        uint256 liquidationBonus,

        uint256 reserveFactor,

        bool usageAsCollateralEnabled,

        bool borrowingEnabled,

        bool stableBorrowRateEnabled,

        bool isActive,

        bool isFrozen

    );

}



interface AaveAddressProviderRegistryInterface {

    function getAddressesProvidersList() external view returns (address[] memory);

}



interface ATokenInterface {

    function scaledBalanceOf(address _user) external view returns (uint256);

    function isTransferAllowed(address _user, uint256 _amount) external view returns (bool);

    function balanceOf(address _user) external view returns(uint256);

    function transferFrom(address, address, uint) external returns (bool);

}



interface DSAInterface {

    function isAuth(address) external view returns(bool);

}



contract DSMath {



    function add(uint x, uint y) internal pure returns (uint z) {

        require((z = x + y) >= x, "math-not-safe");

    }



    function mul(uint x, uint y) internal pure returns (uint z) {

        require(y == 0 || (z = x * y) / y == x, "math-not-safe");

    }



    uint constant WAD = 10 ** 18;



    function wmul(uint x, uint y) internal pure returns (uint z) {

        z = add(mul(x, y), WAD / 2) / WAD;

    }



    function wdiv(uint x, uint y) internal pure returns (uint z) {

        z = add(mul(x, WAD), y / 2) / y;

    }



}



contract Helpers is DSMath {

    /**

     * @dev Return ethereum address

     */

    function getEthAddr() internal pure returns (address) {

        return 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE; // ETH Address

    }



    /**

     * @dev Return Weth address

    */

    function getWethAddr() internal pure returns (address) {

        return 0xd0A1E359811322d97991E03f863a0C30C2cF029C; // Kovan WETH Address

    }



    /**

     * @dev Return Memory Variable Address

     */

    function getMemoryAddr() internal pure returns (address) {

        return 0x8a5419CfC711B2343c17a6ABf4B2bAFaBb06957F; // InstaMemory Address

    }



    /**

     * @dev Get Uint value from InstaMemory Contract.

    */

    function getUint(uint getId, uint val) internal returns (uint returnVal) {

        returnVal = getId == 0 ? val : MemoryInterface(getMemoryAddr()).getUint(getId);

    }



    /**

     * @dev Set Uint value in InstaMemory Contract.

    */

    function setUint(uint setId, uint val) internal {

        if (setId != 0) MemoryInterface(getMemoryAddr()).setUint(setId, val);

    }



     /**

     * @dev Connector Details.

     */

    function connectorID() public pure returns(uint model, uint id) {

        (model, id) = (1, 69);

    }

}



contract AaveImportHelpers is Helpers {



    /**

     * @dev get Aave Lending Pool Provider

    */

    function getAaveProvider() internal pure returns (AaveLendingPoolProviderInterface) {

        return AaveLendingPoolProviderInterface(0xB53C1a33016B2DC2fF3653530bfF1848a515c8c5); //mainnet

        // return AaveLendingPoolProviderInterface(0x652B2937Efd0B5beA1c8d54293FC1289672AFC6b); //kovan

    }



    /**

     * @dev get Aave Protocol Data Provider

    */

    function getAaveDataProvider() internal pure returns (AaveDataProviderInterface) {

        return AaveDataProviderInterface(0x057835Ad21a177dbdd3090bB1CAE03EaCF78Fc6d); //mainnet

        // return AaveDataProviderInterface(0x744C1aaA95232EeF8A9994C4E0b3a89659D9AB79); //kovan

    }



    /**

     * @dev get Referral Code V2

    */

    function getReferralCode() internal pure returns (uint16) {

        return 3228;

        // return 0;

    }



    function getIsColl(AaveDataProviderInterface aaveData, address token, address user) internal view returns (bool isCol) {

        (, , , , , , , , isCol) = aaveData.getUserReserveData(token, user);

    }



    function convertEthToWeth(bool isEth, TokenInterface token, uint amount) internal {

        if(isEth) token.deposit.value(amount)();

    }



    function convertWethToEth(bool isEth, TokenInterface token, uint amount) internal {

       if(isEth) {

            token.approve(address(token), amount);

            token.withdraw(amount);

        }

    }

}



contract AaveResolver is AaveImportHelpers {

    function _TransferAtokens(

        uint _length,

        AaveInterface aave,

        AaveDataProviderInterface aaveData,

        ATokenInterface[] memory atokenContracts,

        uint[] memory amts,

        address[] memory tokens,

        address userAccount

    ) internal {

        for (uint i = 0; i < _length; i++) {

            if (amts[i] > 0) {

                require(atokenContracts[i].transferFrom(userAccount, address(this), amts[i]), "allowance?");

                

                if (!getIsColl(aaveData, tokens[i], address(this))) {

                    aave.setUserUseReserveAsCollateral(tokens[i], true);

                }

            }

        }

    }



    function _borrowOne(AaveInterface aave, address token, uint amt, uint rateMode) private {

        bool isEth = token == getEthAddr();

        address _token = isEth ? getWethAddr() : token;



        aave.borrow(_token, amt, rateMode, getReferralCode(), address(this));

    }



    function _paybackBehalfOne(AaveInterface aave, address token, uint amt, uint rateMode, address user) private {

        bool isEth = token == getEthAddr();

        address _token = isEth ? getWethAddr() : token;



        aave.repay(_token, amt, rateMode, user);

    }



    function _BorrowStable(

        uint _length,

        AaveInterface aave,

        address[] memory tokens,

        uint256[] memory amts

    ) internal {

        for (uint i = 0; i < _length; i++) {

            if (amts[i] > 0) {

                _borrowOne(aave, tokens[i], amts[i], 1);

            }

        }

    }



    function _BorrowVariable(

        uint _length,

        AaveInterface aave,

        address[] memory tokens,

        uint256[] memory amts

    ) internal {

        for (uint i = 0; i < _length; i++) {

            if (amts[i] > 0) {

                _borrowOne(aave, tokens[i], amts[i], 2);

            }

        }

    }



    function _PaybackStable(

        uint _length,

        AaveInterface aave,

        address[] memory tokens,

        uint256[] memory amts,

        address user

    ) internal {

        for (uint i = 0; i < _length; i++) {

            if (amts[i] > 0) {

                _paybackBehalfOne(aave, tokens[i], amts[i], 1, user);

            }

        }

    }



    function _PaybackVariable(

        uint _length,

        AaveInterface aave,

        address[] memory tokens,

        uint256[] memory amts,

        address user

    ) internal {

        for (uint i = 0; i < _length; i++) {

            if (amts[i] > 0) {

                _paybackBehalfOne(aave, tokens[i], amts[i], 2, user);

            }

        }

    }

}



contract AaveImportResolver is AaveResolver {



    struct AaveData {

        address[] tokens;

        address[] atokens;

        uint[] stableBorrowAmts;

        uint[] variableBorrowAmts;

        uint[] totalBorrowAmts;

        uint[] atokensBal;

        ATokenInterface[] atokenContracts;

    }



    function importAave(address userAccount, address[] calldata tokens, bool converStable) external payable {

        require(DSAInterface(address(this)).isAuth(userAccount), "user-account-not-auth");



        uint _length = tokens.length;

        require(_length > 0, "0-tokens-not-allowed");



        AaveInterface aave = AaveInterface(getAaveProvider().getLendingPool());

        AaveDataProviderInterface aaveData = getAaveDataProvider();



        AaveData memory _aaveData = AaveData({

            tokens: tokens,

            atokens: new address[](_length),

            stableBorrowAmts: new uint[](_length),

            variableBorrowAmts: new uint[](_length),

            totalBorrowAmts: new uint[](_length),

            atokensBal: new uint[](_length),

            atokenContracts: new ATokenInterface[](_length)

        });



        for (uint i = 0; i < _length; i++) {

            (_aaveData.atokens[i], ,) = aaveData.getReserveTokensAddresses(tokens[i]);

            (

                _aaveData.atokensBal[i],

                _aaveData.stableBorrowAmts[i],

                _aaveData.variableBorrowAmts[i],

                ,,,,,

            ) = aaveData.getUserReserveData(userAccount, tokens[i]);

            _aaveData.totalBorrowAmts[i] = _aaveData.stableBorrowAmts[i] + _aaveData.variableBorrowAmts[i];



            bool isEth = tokens[i] == getEthAddr();

            address _token = isEth ? getWethAddr() : tokens[i];

            _aaveData.atokenContracts[i] = ATokenInterface(_token);

            TokenInterface(_token).approve(address(aave), _aaveData.totalBorrowAmts[i]);

        }



        if (converStable) {

            _BorrowVariable(_length, aave, _aaveData.tokens, _aaveData.totalBorrowAmts);

        } else {

            _BorrowStable(_length, aave, _aaveData.tokens, _aaveData.stableBorrowAmts);

            _BorrowVariable(_length, aave, _aaveData.tokens, _aaveData.variableBorrowAmts);

        }

        _PaybackStable(_length, aave, _aaveData.tokens, _aaveData.stableBorrowAmts, userAccount);

        _PaybackVariable(_length, aave, _aaveData.tokens, _aaveData.variableBorrowAmts, userAccount);

        _TransferAtokens(_length, aave, aaveData, _aaveData.atokenContracts, _aaveData.atokensBal, _aaveData.tokens, userAccount);

    }

}





contract ConnectAaveV2Import is AaveResolver {

    string public name = "AaveV2-Import-v1.0";

}

/**

 *Submitted for verification at Etherscan.io on 2020-11-30

*/



/**

 *Submitted for verification at Etherscan.io on 2020-11-19

*/



// File: contracts/interfaces/IERC20.sol



pragma solidity ^0.6.6;





interface IERC20 {

    event Approval(address indexed owner, address indexed spender, uint value);

    event Transfer(address indexed from, address indexed to, uint value);



    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

    function totalSupply() external view returns (uint);

    function balanceOf(address owner) external view returns (uint);

    function allowance(address owner, address spender) external view returns (uint);



    function approve(address spender, uint value) external returns (bool);

    function transfer(address to, uint value) external returns (bool);

    function transferFrom(address from, address to, uint value) external returns (bool);

}



// File: contracts/utils/SafeMath.sol



pragma solidity ^0.6.6;





library SafeMath {

    using SafeMath for uint256;



    function add(uint256 x, uint256 y) internal pure returns (uint256) {

        uint256 z = x + y;

        require(z >= x, "Add overflow");

        return z;

    }



    function sub(uint256 x, uint256 y) internal pure returns (uint256) {

        require(x >= y, "Sub overflow");

        return x - y;

    }



    function mult(uint256 x, uint256 y) internal pure returns (uint256) {

        if (x == 0) {

            return 0;

        }



        uint256 z = x * y;

        require(z/x == y, "Mult overflow");

        return z;

    }



    function div(uint256 x, uint256 y) internal pure returns (uint256) {

        require(y != 0, "Div by zero");

        return x / y;

    }



    function divCeil(uint256 _a, uint256 _b) internal pure returns (uint256 c) {

        require(_b != 0, "Div by zero");

        c = _a / _b;

        if (_a % _b != 0) {

            c = c + 1;

        }

    }



    function multdiv(uint256 x, uint256 y, uint256 z) internal pure returns (uint256) {

        require(z != 0, "Div by zero");

        return x.mult(y) / z;

    }

}



// File: contracts/interfaces/IERC173.sol



pragma solidity ^0.6.6;





/// @title ERC-173 Contract Ownership Standard

/// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-173.md

///  Note: the ERC-165 identifier for this interface is 0x7f5828d0

interface IERC173 {

    /// @dev This emits when ownership of a contract changes.

    event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);



    /// @notice Get the address of the owner

    /// @return The address of the owner.

    function owner() external view returns (address);



    /// @notice Set the address of the new owner of the contract

    /// @param _newOwner The address of the new owner of the contract

    function transferOwnership(address _newOwner) external;

}



// File: contracts/utils/Ownable.sol



pragma solidity ^0.6.6;







contract Ownable is IERC173 {

    address internal _owner;



    modifier onlyOwner() {

        require(msg.sender == _owner, "The owner should be the sender");

        _;

    }



    constructor() public {

        _owner = msg.sender;

        emit OwnershipTransferred(address(0x0), msg.sender);

    }



    function owner() external override view returns (address) {

        return _owner;

    }



    /**

        @dev Transfers the ownership of the contract.



        @param _newOwner Address of the new owner

    */

    function transferOwnership(address _newOwner) external override onlyOwner {

        require(_newOwner != address(0), "0x0 Is not a valid owner");

        emit OwnershipTransferred(_owner, _newOwner);

        _owner = _newOwner;

    }

}



// File: contracts/interfaces/rcn/Cosigner.sol



pragma solidity ^0.6.6;





/**

    @dev Defines the interface of a standard RCN cosigner.



    The cosigner is an agent that gives an insurance to the lender in the event of a defaulted loan, the confitions

    of the insurance and the cost of the given are defined by the cosigner.



    The lender will decide what cosigner to use, if any; the address of the cosigner and the valid data provided by the

    agent should be passed as params when the lender calls the "lend" method on the engine.



    When the default conditions defined by the cosigner aligns with the status of the loan, the lender of the engine

    should be able to call the "claim" method to receive the benefit; the cosigner can define aditional requirements to

    call this method, like the transfer of the ownership of the loan.

*/

interface Cosigner {

    /**

        @return the url of the endpoint that exposes the insurance offers.

    */

    function url() external view returns (string memory);



    /**

        @dev Retrieves the cost of a given insurance, this amount should be exact.



        @return the cost of the cosign, in RCN wei

    */

    function cost(

        address engine,

        uint256 index,

        bytes calldata data,

        bytes calldata oracleData

    )

        external view returns (uint256);



    /**

        @dev The engine calls this method for confirmation of the conditions, if the cosigner accepts the liability of

        the insurance it must call the method "cosign" of the engine. If the cosigner does not call that method, or

        does not return true to this method, the operation fails.



        @return true if the cosigner accepts the liability

    */

    function requestCosign(

        address engine,

        uint256 index,

        bytes calldata data,

        bytes calldata oracleData

    )

        external returns (bool);



    /**

        @dev Claims the benefit of the insurance if the loan is defaulted, this method should be only calleable by the

        current lender of the loan.



        @return true if the claim was done correctly.

    */

    function claim(address engine, uint256 index, bytes calldata oracleData) external returns (bool);

}



// File: contracts/interfaces/rcn/IERC165.sol



pragma solidity ^0.6.6;





interface IERC165 {

    /// @notice Query if a contract implements an interface

    /// @param interfaceID The interface identifier, as specified in ERC-165

    /// @dev Interface identification is specified in ERC-165. This function

    ///  uses less than 30,000 gas.

    /// @return `true` if the contract implements `interfaceID` and

    ///  `interfaceID` is not 0xffffffff, `false` otherwise

    function supportsInterface(bytes4 interfaceID) external view returns (bool);

}



// File: contracts/interfaces/rcn/RateOracle.sol



pragma solidity ^0.6.6;







/**

    @dev Defines the interface of a standard Diaspore RCN Oracle,



    The contract should also implement it's ERC165 interface: 0xa265d8e0



    @notice Each oracle can only support one currency



    @author Agustin Aguilar

*/

abstract contract RateOracle is IERC165 {

    uint256 public constant VERSION = 5;

    bytes4 internal constant RATE_ORACLE_INTERFACE = 0xa265d8e0;



    /**

        3 or 4 letters symbol of the currency, Ej: ETH

    */

    function symbol() external view virtual returns (string memory);



    /**

        Descriptive name of the currency, Ej: Ethereum

    */

    function name() external view virtual returns (string memory);



    /**

        The number of decimals of the currency represented by this Oracle,

            it should be the most common number of decimal places

    */

    function decimals() external view virtual returns (uint256);



    /**

        The base token on which the sample is returned

            should be the RCN Token address.

    */

    function token() external view virtual returns (address);



    /**

        The currency symbol encoded on a UTF-8 Hex

    */

    function currency() external view virtual returns (bytes32);



    /**

        The name of the Individual or Company in charge of this Oracle

    */

    function maintainer() external view virtual returns (string memory);



    /**

        Returns the url where the oracle exposes a valid "oracleData" if needed

    */

    function url() external view virtual returns (string memory);



    /**

        Returns a sample on how many token() are equals to how many currency()

    */

    function readSample(bytes calldata _data) external virtual returns (uint256 _tokens, uint256 _equivalent);

}



// File: contracts/interfaces/rcn/IDebtEngine.sol



pragma solidity ^0.6.6;







interface IDebtEngine {

    enum Status {

        NULL,

        ONGOING,

        PAID,

        DESTROYED, // Deprecated, used in basalt version

        ERROR

    }



    function pay(

        bytes32 _id,

        uint256 _amountToPay,

        address _origin,

        bytes calldata _oracleData

    ) external returns (uint256 paid, uint256 paidToken, uint256 burnToken);



    function payToken(

        bytes32 id,

        uint256 amount,

        address origin,

        bytes calldata oracleData

    ) external returns (uint256 paid, uint256 paidToken, uint256 burnToken);



    function withdraw(

        bytes32 _id,

        address _to

    ) external returns (uint256 amount);



    function withdrawPartial(

        bytes32 _id,

        address _to,

        uint256 _amount

    ) external returns (bool success);



    function withdrawBatch(

        bytes32[] calldata _ids,

        address _to

    ) external returns (uint256 total);



    function transferFrom(address _from, address _to, uint256 _assetId) external;



    function getStatus(bytes32 _id) external view returns (Status);



    function toFee(bytes32 _id, uint256 _amount) external view returns (uint256 feeAmount);

}



// File: contracts/interfaces/rcn/ILoanManager.sol



pragma solidity ^0.6.6;











interface ILoanManager {

    function token() external view returns (IERC20);



    function debtEngine() external view returns (IDebtEngine);

    function getCurrency(uint256 _id) external view returns (bytes32);

    function getAmount(uint256 _id) external view returns (uint256);

    function getAmount(bytes32 _id) external view returns (uint256);

    function getOracle(bytes32 _id) external view returns (RateOracle);

    function getClosingObligation(bytes32 _id) external view returns (uint256 amount, uint256 fee);



    function settleLend(

        bytes calldata _requestData,

        bytes calldata _loanData,

        address _cosigner,

        uint256 _maxCosignerCost,

        bytes calldata _cosignerData,

        bytes calldata _oracleData,

        bytes calldata _creatorSig,

        bytes calldata _borrowerSig

    ) external returns (bytes32 id);



    function lend(

        bytes32 _id,

        bytes calldata _oracleData,

        address _cosigner,

        uint256 _cosignerLimit,

        bytes calldata _cosignerData,

        bytes calldata _callbackData

    ) external returns (bool);

}



// File: contracts/interfaces/ITokenConverter.sol



pragma solidity ^0.6.6;







interface ITokenConverter {

    function convertFrom(

        IERC20 _fromToken,

        IERC20 _toToken,

        uint256 _fromAmount,

        uint256 _minReceive

    ) external payable returns (uint256 _received);



    function convertTo(

        IERC20 _fromToken,

        IERC20 _toToken,

        uint256 _toAmount,

        uint256 _maxSpend

    ) external payable returns (uint256 _spend);



    function getPriceConvertFrom(

        IERC20 _fromToken,

        IERC20 _toToken,

        uint256 _fromAmount

    ) external view returns (uint256 _receive);



    function getPriceConvertTo(

        IERC20 _fromToken,

        IERC20 _toToken,

        uint256 _toAmount

    ) external view returns (uint256 _spend);

}



// File: contracts/utils/SafeERC20.sol



pragma solidity ^0.6.6;







/**

* @dev Library to perform safe calls to standard method for ERC20 tokens.

*

* Why Transfers: transfer methods could have a return value (bool), throw or revert for insufficient funds or

* unathorized value.

*

* Why Approve: approve method could has a return value (bool) or does not accept 0 as a valid value (BNB token).

* The common strategy used to clean approvals.

*

* We use the Solidity call instead of interface methods because in the case of transfer, it will fail

* for tokens with an implementation without returning a value.

* Since versions of Solidity 0.4.22 the EVM has a new opcode, called RETURNDATASIZE.

* This opcode stores the size of the returned data of an external call. The code checks the size of the return value

* after an external call and reverts the transaction in case the return data is shorter than expected

*

* Source: https://github.com/nachomazzara/SafeERC20/blob/master/contracts/libs/SafeERC20.sol

* Author: Ignacio Mazzara

*/

library SafeERC20 {

    /**

    * @dev Transfer token for a specified address

    * @param _token erc20 The address of the ERC20 contract

    * @param _to address The address which you want to transfer to

    * @param _value uint256 the _value of tokens to be transferred

    * @return bool whether the transfer was successful or not

    */

    function safeTransfer(IERC20 _token, address _to, uint256 _value) internal returns (bool) {

        uint256 prevBalance = _token.balanceOf(address(this));



        if (prevBalance < _value) {

            // Insufficient funds

            return false;

        }



        address(_token).call(

            abi.encodeWithSignature("transfer(address,uint256)", _to, _value)

        );



        // Fail if the new balance its not equal than previous balance sub _value

        return prevBalance - _value == _token.balanceOf(address(this));

    }



    /**

    * @dev Transfer tokens from one address to another

    * @param _token erc20 The address of the ERC20 contract

    * @param _from address The address which you want to send tokens from

    * @param _to address The address which you want to transfer to

    * @param _value uint256 the _value of tokens to be transferred

    * @return bool whether the transfer was successful or not

    */

    function safeTransferFrom(

        IERC20 _token,

        address _from,

        address _to,

        uint256 _value

    ) internal returns (bool)

    {

        uint256 prevBalance = _token.balanceOf(_from);



        if (

          prevBalance < _value || // Insufficient funds

          _token.allowance(_from, address(this)) < _value // Insufficient allowance

        ) {

            return false;

        }



        address(_token).call(

            abi.encodeWithSignature("transferFrom(address,address,uint256)", _from, _to, _value)

        );



        // Fail if the new balance its not equal than previous balance sub _value

        return prevBalance - _value == _token.balanceOf(_from);

    }



   /**

   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.

   *

   * Beware that changing an allowance with this method brings the risk that someone may use both the old

   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this

   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:

   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729

   *

   * @param _token erc20 The address of the ERC20 contract

   * @param _spender The address which will spend the funds.

   * @param _value The amount of tokens to be spent.

   * @return bool whether the approve was successful or not

   */

    function safeApprove(IERC20 _token, address _spender, uint256 _value) internal returns (bool) {

        address(_token).call(

            abi.encodeWithSignature("approve(address,uint256)",_spender, _value)

        );



        // Fail if the new allowance its not equal than _value

        return _token.allowance(address(this), _spender) == _value;

    }



   /**

   * @dev Clear approval

   * Note that if 0 is not a valid value it will be set to 1.

   * @param _token erc20 The address of the ERC20 contract

   * @param _spender The address which will spend the funds.

   */

    function clearApprove(IERC20 _token, address _spender) internal returns (bool) {

        bool success = safeApprove(_token, _spender, 0);



        if (!success) {

            success = safeApprove(_token, _spender, 1);

        }



        return success;

    }

}



// File: contracts/utils/SafeTokenConverter.sol



pragma solidity ^0.6.6;













library SafeTokenConverter {

    IERC20 constant private ETH_TOKEN_ADDRESS = IERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);

    using SafeERC20 for IERC20;

    using SafeMath for uint256;



    function safeConvertFrom(

        ITokenConverter _converter,

        IERC20 _fromToken,

        IERC20 _toToken,

        uint256 _fromAmount,

        uint256 _minReceive

    ) internal returns (uint256 _received) {

        uint256 prevBalance = _selfBalance(_toToken);



        if (_fromToken == ETH_TOKEN_ADDRESS) {

            _converter.convertFrom{

                value: _fromAmount

            }(

                _fromToken,

                _toToken,

                _fromAmount,

                _minReceive

            );

        } else {

            require(_fromToken.safeApprove(address(_converter), _fromAmount), "safeConvertFrom: error approving converter");

            _converter.convertFrom(

                _fromToken,

                _toToken,

                _fromAmount,

                _minReceive

            );



            require(_fromToken.clearApprove(address(_converter)), "safeConvertFrom: error clearing approve");

        }



        _received = _selfBalance(_toToken).sub(prevBalance);

        require(_received >= _minReceive, "safeConvertFrom: _minReceived not reached");

    }



    function safeConvertTo(

        ITokenConverter _converter,

        IERC20 _fromToken,

        IERC20 _toToken,

        uint256 _toAmount,

        uint256 _maxSpend

    ) internal returns (uint256 _spend) {

        uint256 prevFromBalance = _selfBalance(_fromToken);

        uint256 prevToBalance = _selfBalance(_toToken);



        if (_fromToken == ETH_TOKEN_ADDRESS) {

            _converter.convertTo{

                value: _maxSpend

            }(

                _fromToken,

                _toToken,

                _toAmount,

                _maxSpend

            );

        } else {

            require(_fromToken.safeApprove(address(_converter), _maxSpend), "safeConvertTo: error approving converter");

            _converter.convertTo(

                _fromToken,

                _toToken,

                _toAmount,

                _maxSpend

            );



            require(_fromToken.clearApprove(address(_converter)), "safeConvertTo: error clearing approve");

        }



        _spend = prevFromBalance.sub(_selfBalance(_fromToken));

        require(_spend <= _maxSpend, "safeConvertTo: _maxSpend exceeded");

        require(_selfBalance(_toToken).sub(prevToBalance) >= _toAmount, "safeConvertTo: _toAmount not received");

    }



    function _selfBalance(IERC20 _token) private view returns (uint256) {

        if (_token == ETH_TOKEN_ADDRESS) {

            return address(this).balance;

        } else {

            return _token.balanceOf(address(this));

        }

    }

}



// File: contracts/ConverterRamp.sol



pragma solidity ^0.6.6;

























/// @title  Converter Ramp

/// @notice for conversion between different assets, use ITokenConverter

///         contract as abstract layer for convert different assets.

/// @dev All function calls are currently implemented without side effects

contract ConverterRamp is Ownable {

    using SafeTokenConverter for ITokenConverter;

    using SafeMath for uint256;

    using SafeERC20 for IERC20;



    /// @notice address to identify operations with ETH

    address public constant ETH_ADDRESS = address(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);



    event ReadedOracle(RateOracle _oracle, uint256 _tokens, uint256 _equivalent);



    IDebtEngine immutable public debtEngine;

    ILoanManager immutable public loanManager;

    IERC20 immutable public debtEngineToken;



    constructor(ILoanManager _loanManager) public {

        loanManager = _loanManager;

        IERC20 _debtEngineToken = _loanManager.token();

        debtEngineToken = _debtEngineToken;

        IDebtEngine _debtEngine = _loanManager.debtEngine();

        debtEngine = _debtEngine;



        // Approve loanManager and debtEngine

        require(_debtEngineToken.safeApprove(address(_loanManager), uint(-1)), "constructor: fail LoanManager safeApprove");

        require(_debtEngineToken.safeApprove(address(_debtEngine), uint(-1)), "constructor: fail DebtEngine safeApprove");

    }



    function pay(

        ITokenConverter _converter,

        IERC20 _fromToken,

        uint256 _payAmount,

        uint256 _maxSpend,

        bytes32 _requestId,

        bytes calldata _oracleData

    ) external payable {

        uint256 amount;

        {

            // Get amount required, in RCN, for payment

            uint256 fee;

            (amount, fee) = _getRequiredRcnPay(_requestId, _payAmount, _oracleData);



            // Pull funds from sender

            _pullConvertAndReturnExtra(

                _converter,

                _fromToken,

                amount + fee,

                _maxSpend

            );

        }



        // Execute the payment

        (, uint256 paidToken, uint256 paidFee) = debtEngine.payToken(_requestId, amount, msg.sender, _oracleData);



        // Convert any extra RCN and send it back it should not be reachable

        if (paidToken < amount) {

            uint256 buyBack = _converter.safeConvertFrom(

                _fromToken,

                debtEngineToken,

                amount - paidToken - paidFee,

                1

            );



            require(debtEngineToken.safeTransfer(msg.sender, buyBack), "pay: error sending extra");

        }

    }



    function lend(

        ITokenConverter _converter,

        IERC20 _fromToken,

        uint256 _maxSpend,

        Cosigner _cosigner,

        uint256 _cosignerLimitCost,

        bytes32 _requestId,

        bytes memory _oracleData,

        bytes memory _cosignerData,

        bytes memory _callbackData

    ) public payable {

        // Get required RCN for lending the loan

        uint256 amount = _getRequiredRcnLend(

            _cosigner,

            _requestId,

            _oracleData,

            _cosignerData

        );



        _pullConvertAndReturnExtra(

            _converter,

            _fromToken,

            amount,

            _maxSpend

        );



        loanManager.lend(

            _requestId,

            _oracleData,

            address(_cosigner),

            _cosignerLimitCost,

            _cosignerData,

            _callbackData

        );



        // Transfer loan to the msg.sender

        debtEngine.transferFrom(address(this), msg.sender, uint256(_requestId));

    }



    function getLendCost(

        ITokenConverter _converter,

        IERC20 _fromToken,

        Cosigner _cosigner,

        bytes32 _requestId,

        bytes calldata _oracleData,

        bytes calldata _cosignerData

    ) external returns (uint256) {

        uint256 amountRcn = _getRequiredRcnLend(

            _cosigner,

            _requestId,

            _oracleData,

            _cosignerData

        );



        return _converter.getPriceConvertTo(

            _fromToken,

            debtEngineToken,

            amountRcn

        );

    }



    /// @notice returns how much RCN is required for a given pay

    function getPayCostWithFee(

        ITokenConverter _converter,

        IERC20 _fromToken,

        bytes32 _requestId,

        uint256 _amount,

        bytes calldata _oracleData

    ) external returns (uint256) {

        (uint256 amount, uint256 fee) = _getRequiredRcnPay(_requestId, _amount, _oracleData);



        return _converter.getPriceConvertTo(

            _fromToken,

            debtEngineToken,

            amount + fee

        );

    }



    /// @notice returns how much RCN is required for a given lend

    function _getRequiredRcnLend(

        Cosigner _cosigner,

        bytes32 _requestId,

        bytes memory _oracleData,

        bytes memory _cosignerData

    ) internal returns (uint256) {

        // Load request amount

        uint256 amount = loanManager.getAmount(_requestId);



        // If loan has a cosigner, sum the cost

        if (_cosigner != Cosigner(0)) {

            amount = amount.add(

                _cosigner.cost(

                    address(loanManager),

                    uint256(_requestId),

                    _cosignerData,

                    _oracleData

                )

            );

        }



        // Convert amount in currency to amount in tokens

        RateOracle oracle = loanManager.getOracle(_requestId);

        if (oracle == RateOracle(0)) {

            return amount;

        }



        (uint256 tokens, uint256 equivalent) = oracle.readSample(_oracleData);



        emit ReadedOracle(oracle, tokens, equivalent);



        return tokens.mult(amount).divCeil(equivalent);

    }



    /// @notice returns how much RCN is required for a given pay

    function _getRequiredRcnPay(

        bytes32 _requestId,

        uint256 _amount,

        bytes memory _oracleData

    ) internal returns (uint256 amount, uint256 fee) {

        (amount, fee) = loanManager.getClosingObligation(_requestId);



        // Load amount to pay

        if (_amount < amount) {

            amount = _amount;

            fee = debtEngine.toFee(_requestId, _amount);

        }



        // Convert amount and fee in currency to amount and fee in tokens

        RateOracle oracle = loanManager.getOracle(_requestId);

        if (oracle == RateOracle(0)) {

            return (amount, fee);

        }



        (uint256 tokens, uint256 equivalent) = oracle.readSample(_oracleData);



        emit ReadedOracle(oracle, tokens, equivalent);



        amount = tokens.mult(amount).divCeil(equivalent);

        fee = tokens.mult(fee).divCeil(equivalent);

    }



    function _pullConvertAndReturnExtra(

        ITokenConverter _converter,

        IERC20 _fromToken,

        uint256 _amount,

        uint256 _maxSpend

    ) private {

        // Pull limit amount from sender

        _pull(_fromToken, _maxSpend);



        uint256 spent = _converter.safeConvertTo(_fromToken, debtEngineToken, _amount, _maxSpend);



        if (spent < _maxSpend) {

            _transfer(_fromToken, msg.sender, _maxSpend - spent);

        }

    }



    function _pull(

        IERC20 _token,

        uint256 _amount

    ) private {

        if (address(_token) == ETH_ADDRESS) {

            require(msg.value == _amount, "_pull: sent eth is not enought");

        } else {

            require(msg.value == 0, "_pull: method is not payable");

            require(_token.safeTransferFrom(msg.sender, address(this), _amount), "_pull: error pulling tokens");

        }

    }



    function _transfer(

        IERC20 _token,

        address payable _to,

        uint256 _amount

    ) private {

        if (address(_token) == ETH_ADDRESS) {

            _to.transfer(_amount);

        } else {

            require(_token.safeTransfer(_to, _amount), "_transfer: error sending tokens");

        }

    }



    function emergencyWithdraw(

        IERC20 _token,

        address payable _to,

        uint256 _amount

    ) external onlyOwner {

        _transfer(_token, _to, _amount);

    }



    receive() external payable {

        // solhint-disable-next-line

        require(tx.origin != msg.sender, "receive: send eth rejected");

    }

}

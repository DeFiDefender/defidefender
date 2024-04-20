// File: contracts/interfaces/IERC20.sol



pragma solidity ^0.5.11;





interface IERC20 {

    function transfer(address _to, uint _value) external returns (bool success);

    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);

    function allowance(address _owner, address _spender) external view returns (uint256 remaining);

    function approve(address _spender, uint256 _value) external returns (bool success);

    function increaseApproval (address _spender, uint _addedValue) external returns (bool success);

    function balanceOf(address _owner) external view returns (uint256 balance);

}



// File: contracts/utils/SafeERC20.sol



pragma solidity ^0.5.11;







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



// File: contracts/utils/SafeMath.sol



pragma solidity ^0.5.11;





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



    function multdiv(uint256 x, uint256 y, uint256 z) internal pure returns (uint256) {

        require(z != 0, "div by zero");

        return x.mult(y) / z;

    }

}



// File: contracts/utils/SafeCast.sol



pragma solidity ^0.5.11;





library SafeCast {

    function toUint128(uint256 _a) internal pure returns (uint128) {

        require(_a < 2 ** 128, "cast overflow");

        return uint128(_a);

    }



    function toUint256(int256 _i) internal pure returns (uint256) {

        require(_i >= 0, "cast to unsigned must be positive");

        return uint256(_i);

    }



    function toInt256(uint256 _i) internal pure returns (int256) {

        require(_i < 2 ** 255, "cast overflow");

        return int256(_i);

    }



    function toUint32(uint256 _i) internal pure returns (uint32) {

        require(_i < 2 ** 32, "cast overdlow");

        return uint32(_i);

    }

}



// File: contracts/utils/IsContract.sol



pragma solidity ^0.5.11;





library IsContract {

    function isContract(address _addr) internal view returns (bool) {

        uint size;

        assembly { size := extcodesize(_addr) }

        return size > 0;

    }

}



// File: contracts/utils/Math.sol



pragma solidity ^0.5.11;





library Math {

    function min(int256 _a, int256 _b) internal pure returns (int256) {

        if (_a < _b) {

            return _a;

        } else {

            return _b;

        }

    }



    function max(int256 _a, int256 _b) internal pure returns (int256) {

        if (_a > _b) {

            return _a;

        } else {

            return _b;

        }

    }



    function min(uint256 _a, uint256 _b) internal pure returns (uint256) {

        if (_a < _b) {

            return _a;

        } else {

            return _b;

        }

    }



    function max(uint256 _a, uint256 _b) internal pure returns (uint256) {

        if (_a > _b) {

            return _a;

        } else {

            return _b;

        }

    }

}



// File: contracts/interfaces/IERC173.sol



pragma solidity ^0.5.11;





/// @title ERC-173 Contract Ownership Standard

/// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-173.md

///  Note: the ERC-165 identifier for this interface is 0x7f5828d0

contract IERC173 {

    /// @dev This emits when ownership of a contract changes.

    event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);



    /// @notice Get the address of the owner

    /// @return The address of the owner.

    //// function owner() external view returns (address);



    /// @notice Set the address of the new owner of the contract

    /// @param _newOwner The address of the new owner of the contract

    function transferOwnership(address _newOwner) external;

}



// File: contracts/commons/Ownable.sol



pragma solidity ^0.5.11;







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



    function owner() external view returns (address) {

        return _owner;

    }



    /**

        @dev Transfers the ownership of the contract.



        @param _newOwner Address of the new owner

    */

    function transferOwnership(address _newOwner) external onlyOwner {

        require(_newOwner != address(0), "0x0 Is not a valid owner");

        emit OwnershipTransferred(_owner, _newOwner);

        _owner = _newOwner;

    }

}



// File: contracts/commons/ReentrancyGuard.sol



pragma solidity ^0.5.11;





contract ReentrancyGuard {

    uint256 private _reentrantFlag;



    uint256 private constant FLAG_LOCKED = 1;

    uint256 private constant FLAG_UNLOCKED = 2;



    constructor() public {

        _reentrantFlag = FLAG_UNLOCKED;

    }



    modifier nonReentrant() {

        // On the first call to nonReentrant, _notEntered will be true

        require(_reentrantFlag != FLAG_LOCKED, "ReentrancyGuard: reentrant call");



        // Any calls to nonReentrant after this point will fail

        _reentrantFlag = FLAG_LOCKED;

        _;

        _reentrantFlag = FLAG_UNLOCKED;

    }

}



// File: contracts/core/diaspore/cosigner/interfaces/CollateralAuctionCallback.sol



pragma solidity ^0.5.11;





interface CollateralAuctionCallback {

    function auctionClosed(

        uint256 _id,

        uint256 _leftover,

        uint256 _received,

        bytes calldata _data

    ) external;

}



// File: contracts/core/diaspore/cosigner/CollateralAuction.sol



pragma solidity ^0.5.11;























/**

    @title ERC-20 Dutch auction

    @author Agustin Aguilar <agustin@ripiocredit.network> & Victor Fage <victor.fage@ripiocredit.network>

    @notice Auctions tokens in exchange for `baseToken` using a Dutch auction scheme,

        the owner of the contract is the sole beneficiary of all the auctions.

        Auctions follow two linear functions to determine the exchange rate that

        are determined by the provided `reference` rate.

    @dev If the auction token matches the requested `baseToken`,

        the auction has a fixed rate of 1:1

*/

contract CollateralAuction is ReentrancyGuard, Ownable {

    using IsContract for address payable;

    using SafeERC20 for IERC20;

    using SafeMath for uint256;

    using SafeCast for uint256;



    uint256 private constant DELTA_TO_MARKET = 10 minutes;

    uint256 private constant DELTA_FINISH = 1 days;



    IERC20 public baseToken;

    Auction[] public auctions;



    struct Auction {

        IERC20 fromToken;    // Token that we are intending to sell

        uint64 startTime;    // Start time of the auction

        uint32 limitDelta;   // Limit time until all collateral is offered

        uint256 startOffer;  // Start offer of `fromToken` for the requested `amount`

        uint256 amount;      // Amount that we need to receive of `baseToken`

        uint256 limit;       // Limit of how much are willing to spend of `fromToken`

    }



    event CreatedAuction(

        uint256 indexed _id,

        IERC20 _fromToken,

        uint256 _startOffer,

        uint256 _refOffer,

        uint256 _amount,

        uint256 _limit

    );



    event Take(

        uint256 indexed _id,

        address _taker,

        uint256 _selling,

        uint256 _requesting

    );



    constructor(IERC20 _baseToken) public {

        baseToken = _baseToken;

        // Auction IDs start at 1

        auctions.length++;

    }



    /**

        @notice Returns the size of the auctions array



        @dev The auction with ID 0 is invalid, thus the value

            returned by this method is the total number of auctions + 1



        @return The size of the auctions array

    */

    function getAuctionsLength() external view returns (uint256) {

        return auctions.length;

    }



    /**

        @notice Creates a new auction that starts immediately, any address

            can start an auction, but the beneficiary of all auctions is the

            owner of the contract



        @param _fromToken Token to be sold in exchange for `baseToken`

        @param _start Initial offer of `fromToken` for the requested `_amount` of base,

            should be below the market reference

        @param _ref Reference or "market" offer of `fromToken` for the requested `_amount` of base,

            it should be estimated with the current exchange rate, the real offered amount reaches

            this value after 10 minutes

        @param _limit Maximum amount of `fromToken` to exchange for the requested `_amount` of base,

            after this limit is reached, the requested `_amount` starts to reduce

        @param _amount Amount requested in exchange for `fromToken` until `_limit is reached`



        @return The ID of the created auction

    */

    function create(

        IERC20 _fromToken,

        uint256 _start,

        uint256 _ref,

        uint256 _limit,

        uint256 _amount

    ) external nonReentrant() returns (uint256 id) {

        require(_start < _ref, "auction: offer should be below refence offer");

        require(_ref <= _limit, "auction: reference offer should be below or equal to limit");



        // Calculate how much time takes the auction to offer all the `_limit` tokens

        // in exchange for the requested base `_amount`, this delta defines the linear

        // function of the first half of the auction

        uint32 limitDelta = ((_limit - _start).mult(DELTA_TO_MARKET) / (_ref - _start)).toUint32();



        // Pull tokens for the auction, the full `_limit` is pulled

        // any exceeding tokens will be returned at the end of the auction

        require(_fromToken.safeTransferFrom(msg.sender, address(this), _limit), "auction: error pulling _fromToken");



        // Create and store the auction

        id = auctions.push(Auction({

            fromToken: _fromToken,

            startTime: uint64(_now()),

            limitDelta: limitDelta,

            startOffer: _start,

            amount: _amount,

            limit: _limit

        })) - 1;



        emit CreatedAuction(

            id,

            _fromToken,

            _start,

            _ref,

            _amount,

            _limit

        );

    }



    /**

        @notice Takes an ongoing auction, exchanging the requested `baseToken`

            for offered `fromToken`. The `baseToken` are transfered to the owner

            address and a callback to the owner is called for further processing of the tokens



        @dev In the context of a collateral auction, the tokens are used to pay a loan.

            If the oracle of the loan requires `oracleData`, such oracle data should be included

            on the `_data` field



        @dev The taker of the auction may request a callback to it's own address, this is

            intended to allow the taker to use the newly received `fromToken` and perform

            arbitrage with a dex before providing the requested `baseToken`



        @param _id ID of the auction to take

        @param _data Arbitrary data field that's passed to the owner

        @param _callback Requests a callback for the taker of the auction,

            that may be used to perform arbitrage

    */

    function take(

        uint256 _id,

        bytes calldata _data,

        bool _callback

    ) external nonReentrant() {

        Auction memory auction = auctions[_id];

        require(auction.amount != 0, "auction: does not exists");

        IERC20 fromToken = auction.fromToken;



        // Load the current rate of the auction

        // how much `fromToken` is being sold and how much

        // `baseToken` is requested

        (uint256 selling, uint256 requesting) = _offer(auction);

        address owner = _owner;



        // Any non-offered `fromToken` is going

        // to be returned to the owner

        uint256 leftOver = auction.limit - selling;



        // Delete auction entry

        delete auctions[_id];



        // Send the auctioned tokens to the sender

        // this is done first, because the sender may be doing arbitrage

        // and for that, it needs the tokens that's going to sell

        require(fromToken.safeTransfer(msg.sender, selling), "auction: error sending tokens");



        // If a callback is requested, we ping the sender so it can perform arbitrage

        if (_callback) {

            /* solium-disable-next-line */

            (bool success, ) = msg.sender.call(abi.encodeWithSignature("onTake(address,uint256,uint256)", fromToken, selling, requesting));

            require(success, "auction: error during callback onTake()");

        }



        // Swap tokens for base, send base directly to the owner

        require(baseToken.transferFrom(msg.sender, owner, requesting), "auction: error pulling tokens");



        // Send any leftOver tokens

        require(fromToken.safeTransfer(owner, leftOver), "auction: error sending leftover tokens");



        // Callback to owner to process the closed auction

        CollateralAuctionCallback(owner).auctionClosed(

            _id,

            leftOver,

            requesting,

            _data

        );



        emit Take(

            _id,

            msg.sender,

            selling,

            requesting

        );

    }



    /**

        @notice Calculates the current offer of an auction if it were to be taken,

            how much `baseTokens` are being requested for how much `baseToken`



        @param _id ID of the auction



        @return How much is being requested and how much is being offered

    */

    function offer(

        uint256 _id

    ) external view returns (uint256 selling, uint256 requesting) {

        return _offer(auctions[_id]);

    }



    /**

        @notice Returns the current timestamp



        @dev Used for unit testing



        @return The current Unix timestamp

    */

    function _now() internal view returns (uint256) {

        return now;

    }



    /**

        @notice Calculates the current offer of an auction, with the auction

            in memory



        @dev If `fromToken` and `baseToken` are the same token, the auction

            rate is fixed as 1:1



        @param _auction Aunction in memory



        @return How much is being requested and how much is being offered

    */

    function _offer(

        Auction memory _auction

    ) private view returns (uint256, uint256) {

        if (_auction.fromToken == baseToken) {

            // if the offered token is the same as the base token

            // the auction is skipped, and the requesting and selling amount are the same

            uint256 min = Math.min(_auction.limit, _auction.amount);

            return (min, min);

        } else {

            // Calculate selling and requesting amounts

            // for the current timestamp

            return (_selling(_auction), _requesting(_auction));

        }

    }



    /**

        @notice Calculates how much `fromToken` is being sold, within the defined `_limit`

            the auction starts at `startOffer` and the offer it's increased linearly until

            reaching `reference` offer (after 10 minutes). Then the linear function continues

            until all the collateral is being offered



        @param _auction Auction in memory



        @return How much `fromToken` is being offered

    */

    function _selling(

        Auction memory _auction

    ) private view returns (uint256 _amount) {

        uint256 deltaTime = _now() - _auction.startTime;



        if (deltaTime < _auction.limitDelta) {

            uint256 deltaAmount = _auction.limit - _auction.startOffer;

            _amount = _auction.startOffer.add(deltaAmount.mult(deltaTime) / _auction.limitDelta);

        } else {

            _amount = _auction.limit;

        }

    }



    /**

        @notice Calculates how much `baseToken` is being requested, before offering

            all the `_limit` `fromToken` the total `_amount` of `baseToken` is requested.

            After all the `fromToken` is being offered, the auction switches and the requested

            `baseToken` goes down linearly, until reaching 1 after 24 hours



        @dev If the auction is not taken after the requesting amount can reaches 1, the second part

            of the auction restarts and the initial amount of `baseToken` is requested, the process

            repeats until the auction is taken



        @param _auction Auction in memory



        @return How much `baseToken` are being requested

    */

    function _requesting(

        Auction memory _auction

    ) private view returns (uint256 _amount) {

        uint256 ogDeltaTime = _now() - _auction.startTime;



        if (ogDeltaTime > _auction.limitDelta) {

            uint256 deltaTime = ogDeltaTime - _auction.limitDelta;

            return _auction.amount.sub(_auction.amount.mult(deltaTime % DELTA_FINISH) / DELTA_FINISH);

        } else {

            return _auction.amount;

        }

    }

}

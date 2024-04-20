pragma solidity ^0.6.7;



interface IERC20 {

    function totalSupply() external view returns (uint256);



    function balanceOf(address account) external view returns (uint256);



    function transfer(address recipient, uint256 amount)

        external

        returns (bool);



    function allowance(address owner, address spender)

        external

        view

        returns (uint256);



    function approve(address spender, uint256 amount) external returns (bool);



    function transferFrom(

        address sender,

        address recipient,

        uint256 amount

    ) external returns (bool);



    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(

        address indexed owner,

        address indexed spender,

        uint256 value

    );

}



interface IWETH is IERC20 {

    function deposit() external payable;



    function withdraw(uint256 wad) external;



    event Deposit(address indexed dst, uint256 wad);

    event Withdrawal(address indexed src, uint256 wad);

}



library Address {

    function isContract(address account) internal view returns (bool) {

        bytes32 codehash;

        // prettier-ignore

        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;

        // solhint-disable-next-line no-inline-assembly

        assembly {

            codehash := extcodehash(account)

        }

        return (codehash != 0x0 && codehash != accountHash);

    }



    function toPayable(address account)

        internal

        pure

        returns (address payable)

    {

        return address(uint160(account));

    }



    function sendValue(address payable recipient, uint256 amount) internal {

        require(

            address(this).balance >= amount,

            "Address: insufficient balance"

        );



        // solhint-disable-next-line avoid-call-value

        (bool success, ) = recipient.call.value(amount)("");

        require(

            success,

            "Address: unable to send value, recipient may have reverted"

        );

    }

}



library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a + b;

        require(c >= a, "SafeMath: addition overflow");



        return c;

    }



    function sub(uint256 a, uint256 b) internal pure returns (uint256) {

        return sub(a, b, "SafeMath: subtraction overflow");

    }



    function sub(

        uint256 a,

        uint256 b,

        string memory errorMessage

    ) internal pure returns (uint256) {

        require(b <= a, errorMessage);

        uint256 c = a - b;



        return c;

    }



    function mul(uint256 a, uint256 b) internal pure returns (uint256) {

        if (a == 0) {

            return 0;

        }



        uint256 c = a * b;

        require(c / a == b, "SafeMath: multiplication overflow");



        return c;

    }



    function div(uint256 a, uint256 b) internal pure returns (uint256) {

        return div(a, b, "SafeMath: division by zero");

    }



    function div(

        uint256 a,

        uint256 b,

        string memory errorMessage

    ) internal pure returns (uint256) {

        // Solidity only automatically asserts when dividing by 0

        require(b > 0, errorMessage);

        uint256 c = a / b;



        return c;

    }



    function mod(uint256 a, uint256 b) internal pure returns (uint256) {

        return mod(a, b, "SafeMath: modulo by zero");

    }



    function mod(

        uint256 a,

        uint256 b,

        string memory errorMessage

    ) internal pure returns (uint256) {

        require(b != 0, errorMessage);

        return a % b;

    }

}



library SafeERC20 {

    using SafeMath for uint256;

    using Address for address;



    function safeTransfer(

        IERC20 token,

        address to,

        uint256 value

    ) internal {

        callOptionalReturn(

            token,

            abi.encodeWithSelector(token.transfer.selector, to, value)

        );

    }



    function safeTransferFrom(

        IERC20 token,

        address from,

        address to,

        uint256 value

    ) internal {

        callOptionalReturn(

            token,

            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)

        );

    }



    function safeApprove(

        IERC20 token,

        address spender,

        uint256 value

    ) internal {

        require(

            (value == 0) || (token.allowance(address(this), spender) == 0),

            "SafeERC20: approve from non-zero to non-zero allowance"

        );

        callOptionalReturn(

            token,

            abi.encodeWithSelector(token.approve.selector, spender, value)

        );

    }



    function safeIncreaseAllowance(

        IERC20 token,

        address spender,

        uint256 value

    ) internal {

        uint256 newAllowance = token.allowance(address(this), spender).add(

            value

        );

        callOptionalReturn(

            token,

            abi.encodeWithSelector(

                token.approve.selector,

                spender,

                newAllowance

            )

        );

    }



    function safeDecreaseAllowance(

        IERC20 token,

        address spender,

        uint256 value

    ) internal {

        uint256 newAllowance = token.allowance(address(this), spender).sub(

            value,

            "SafeERC20: decreased allowance below zero"

        );

        callOptionalReturn(

            token,

            abi.encodeWithSelector(

                token.approve.selector,

                spender,

                newAllowance

            )

        );

    }



    function callOptionalReturn(IERC20 token, bytes memory data) private {

        require(address(token).isContract(), "SafeERC20: call to non-contract");



        // solhint-disable-next-line avoid-low-level-calls

        (bool success, bytes memory returndata) = address(token).call(data);

        require(success, "SafeERC20: low-level call failed");



        if (returndata.length > 0) {

            // Return data is optional

            // solhint-disable-next-line max-line-length

            require(

                abi.decode(returndata, (bool)),

                "SafeERC20: ERC20 operation did not succeed"

            );

        }

    }

}



interface ICToken {



    /*** Market Events ***/



    /**

     * @notice Event emitted when interest is accrued

     */

    event AccrueInterest(uint cashPrior, uint interestAccumulated, uint borrowIndex, uint totalBorrows);



    /**

     * @notice Event emitted when tokens are minted

     */

    event Mint(address minter, uint mintAmount, uint mintTokens);



    /**

     * @notice Event emitted when tokens are redeemed

     */

    event Redeem(address redeemer, uint redeemAmount, uint redeemTokens);



    /**

     * @notice Event emitted when underlying is borrowed

     */

    event Borrow(address borrower, uint borrowAmount, uint accountBorrows, uint totalBorrows);



    /**

     * @notice Event emitted when a borrow is repaid

     */

    event RepayBorrow(address payer, address borrower, uint repayAmount, uint accountBorrows, uint totalBorrows);



    /**

     * @notice Event emitted when a borrow is liquidated

     */

    event LiquidateBorrow(address liquidator, address borrower, uint repayAmount, address cTokenCollateral, uint seizeTokens);





    /*** Admin Events ***/



    /**

     * @notice Event emitted when pendingAdmin is changed

     */

    event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);



    /**

     * @notice Event emitted when pendingAdmin is accepted, which means admin is updated

     */

    event NewAdmin(address oldAdmin, address newAdmin);



    /**

     * @notice Event emitted when the reserve factor is changed

     */

    event NewReserveFactor(uint oldReserveFactorMantissa, uint newReserveFactorMantissa);



    /**

     * @notice Event emitted when the reserves are added

     */

    event ReservesAdded(address benefactor, uint addAmount, uint newTotalReserves);



    /**

     * @notice Event emitted when the reserves are reduced

     */

    event ReservesReduced(address admin, uint reduceAmount, uint newTotalReserves);



    /**

     * @notice EIP20 Transfer event

     */

    event Transfer(address indexed from, address indexed to, uint amount);



    /**

     * @notice EIP20 Approval event

     */

    event Approval(address indexed owner, address indexed spender, uint amount);



    /**

     * @notice Failure event

     */

    event Failure(uint error, uint info, uint detail);



    function transfer(address dst, uint amount) external returns (bool);

    function transferFrom(address src, address dst, uint amount) external returns (bool);

    function approve(address spender, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function balanceOf(address owner) external view returns (uint);

    function balanceOfUnderlying(address owner) external returns (uint);

    function getAccountSnapshot(address account) external view returns (uint, uint, uint, uint);

    function borrowRatePerBlock() external view returns (uint);

    function supplyRatePerBlock() external view returns (uint);

    function totalBorrowsCurrent() external returns (uint);

    function borrowBalanceCurrent(address account) external returns (uint);

    function borrowBalanceStored(address account) external view returns (uint);

    function exchangeRateCurrent() external returns (uint);

    function accrualBlockNumber() external view returns (uint);

    function exchangeRateStored() external view returns (uint);

    function getCash() external view returns (uint);

    function accrueInterest() external returns (uint);

    function seize(address liquidator, address borrower, uint seizeTokens) external returns (uint);



    function totalBorrows() external view returns (uint);

    function totalSupply() external view returns (uint);



}



interface ICERC20 is ICToken {

    function mint(uint mintAmount) external returns (uint);

    function redeem(uint redeemTokens) external returns (uint);

    function redeemUnderlying(uint redeemAmount) external returns (uint);

    function borrow(uint borrowAmount) external returns (uint);

    function repayBorrow(uint repayAmount) external returns (uint);

    function repayBorrowBehalf(address borrower, uint repayAmount) external returns (uint);

    function liquidateBorrow(address borrower, uint repayAmount, ICToken cTokenCollateral) external returns (uint);



    function underlying() external returns (address);

}



interface ICEth is ICToken {

    function redeemUnderlying(uint redeemAmount) external returns (uint);

    function redeem(uint redeemTokens) external returns (uint);

    function liquidateBorrow(address borrower, ICToken cTokenCollateral) external payable;

    function mint() external payable;

}



interface IComptroller {



    function enterMarkets(address[] calldata cTokens) external returns (uint[] memory);

    function exitMarket(address cToken) external returns (uint);



    /*** Policy Hooks ***/



    function mintAllowed(address cToken, address minter, uint mintAmount) external returns (uint);

    function mintVerify(address cToken, address minter, uint mintAmount, uint mintTokens) external;



    function redeemAllowed(address cToken, address redeemer, uint redeemTokens) external returns (uint);

    function redeemVerify(address cToken, address redeemer, uint redeemAmount, uint redeemTokens) external;



    function borrowAllowed(address cToken, address borrower, uint borrowAmount) external returns (uint);

    function borrowVerify(address cToken, address borrower, uint borrowAmount) external;



    function repayBorrowAllowed(

        address cToken,

        address payer,

        address borrower,

        uint repayAmount) external returns (uint);

    function repayBorrowVerify(

        address cToken,

        address payer,

        address borrower,

        uint repayAmount,

        uint borrowerIndex) external;



    function liquidateBorrowAllowed(

        address cTokenBorrowed,

        address cTokenCollateral,

        address liquidator,

        address borrower,

        uint repayAmount) external returns (uint);

    function liquidateBorrowVerify(

        address cTokenBorrowed,

        address cTokenCollateral,

        address liquidator,

        address borrower,

        uint repayAmount,

        uint seizeTokens) external;



    function seizeAllowed(

        address cTokenCollateral,

        address cTokenBorrowed,

        address liquidator,

        address borrower,

        uint seizeTokens) external returns (uint);

    function seizeVerify(

        address cTokenCollateral,

        address cTokenBorrowed,

        address liquidator,

        address borrower,

        uint seizeTokens) external;



    function transferAllowed(address cToken, address src, address dst, uint transferTokens) external returns (uint);

    function transferVerify(address cToken, address src, address dst, uint transferTokens) external;



    /*** Liquidity/Liquidation Calculations ***/



    function liquidateCalculateSeizeTokens(

        address cTokenBorrowed,

        address cTokenCollateral,

        uint repayAmount) external view returns (uint, uint);



    function getAccountLiquidity(address account) external view returns (uint, uint, uint);





    /***  Comp claims ****/

    function claimComp(address holder) external;

    function claimComp(address holder, ICToken[] calldata cTokens) external;

    function markets(address ctoken) external view returns (bool, uint, bool);



    

    function compSpeeds(address ctoken) external view returns (uint);



    



}



contract CompLender {

    using SafeERC20 for IERC20;

    using Address for address;

    using SafeMath for uint256;

    

    // Comptroller address for compound.finance

    IComptroller public constant COMPOUND = IComptroller(0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B); 



    //Only three tokens we use

    address public constant COMP  = address(0xc00e94Cb662C3520282E6f5717214004A7f26888);

    ICERC20 public constant cUSDC = ICERC20(address(0x39AA39c021dfbaE8faC545936693aC917d5E7563));

    ICEth   public constant cETH  = ICEth(address(0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5));

    address public constant USDC  = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);



    address public constant uniswapRouter = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

    address public constant WETH = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2); 



    //Operating variables

    uint256 public collateralTarget = 0.75 ether;  // 75% 



    address public allocator;



    constructor(address _allocator) public {

        //pre-set approvals

        IERC20(COMP).approve(uniswapRouter, 1);

        IERC20(USDC).approve(address(cUSDC), 1);

        allocator = _allocator;



        address[] memory cTokens = new address[](2);

        cTokens[0] = address(cUSDC);

        cTokens[1] = address(cETH);

        COMPOUND.enterMarkets(cTokens);

    }



    function depositAndBorrow() public {

        IWETH(WETH).withdraw(IERC20(WETH).balanceOf(address(this)));

        if (address(this).balance > 0) {

            _lockETH(address(this).balance);

            // _drawUSDC();

        }

        cETH.transfer(allocator, cETH.balanceOf(address(this)));

    }



    function _lockETH(uint256 eth) internal {

        cETH.mint{value: eth}();

    }



    // function _drawUSDC() internal {

    //     (uint256 error, uint256 liquidity,) = COMPOUND.getAccountLiquidity(address(this));

    //     uint256 borrowed = cUSDC.borrowBalanceCurrent(address(this));

    //     require(error == 0, "error getting liquidity");



    //     // Get the total USD value of our borrowing power

    //     uint256 totalBorrowPower = liquidity.add(borrowed);

    //     // Get the amount we need to draw to utilize 75% of that borrowing power

    //     uint256 draw = totalBorrowPower.mul(collateralTarget).div(1e18).sub(borrowed);

    //     cUSDC.borrow(draw);

    // }

}

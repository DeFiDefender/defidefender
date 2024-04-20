pragma solidity ^0.6.0;



//SPDX-License-Identifier: MIT



abstract contract Context {

    function _msgSender() internal virtual view returns (address payable) {

        return msg.sender;

    }



    function _msgData() internal virtual view returns (bytes memory) {

        this;

        return msg.data;

    }

}



contract Ownable is Context {

    address private _owner;



    event OwnershipTransferred(

        address indexed previousOwner,

        address indexed newOwner

    );



    constructor() internal {

        address msgSender = _msgSender();

        _owner = msgSender;

        emit OwnershipTransferred(address(0), msgSender);

    }



    function owner() public view returns (address) {

        return _owner;

    }



    modifier onlyOwner() {

        require(_owner == _msgSender(), "Ownable: caller is not the owner");

        _;

    }



    function renounceOwnership() public virtual onlyOwner {

        emit OwnershipTransferred(_owner, address(0));

        _owner = address(0);

    }



    function transferOwnership(address newOwner) public virtual onlyOwner {

        require(

            newOwner != address(0),

            "Ownable: new owner is the zero address"

        );

        emit OwnershipTransferred(_owner, newOwner);

        _owner = newOwner;

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



interface IUniswapV2Factory {

    event PairCreated(

        address indexed token0,

        address indexed token1,

        address pair,

        uint256

    );



    function feeTo() external view returns (address);



    function feeToSetter() external view returns (address);



    function getPair(address tokenA, address tokenB)

        external

        view

        returns (address pair);



    function allPairs(uint256) external view returns (address pair);



    function allPairsLength() external view returns (uint256);



    function createPair(address tokenA, address tokenB)

        external

        returns (address pair);



    function setFeeTo(address) external;



    function setFeeToSetter(address) external;

}



interface IUniswapV2ERC20 {

    event Approval(

        address indexed owner,

        address indexed spender,

        uint256 value

    );

    event Transfer(address indexed from, address indexed to, uint256 value);



    function name() external pure returns (string memory);



    function symbol() external pure returns (string memory);



    function decimals() external pure returns (uint8);



    function totalSupply() external view returns (uint256);



    function balanceOf(address owner) external view returns (uint256);



    function allowance(address owner, address spender)

        external

        view

        returns (uint256);



    function approve(address spender, uint256 value) external returns (bool);



    function transfer(address to, uint256 value) external returns (bool);



    function transferFrom(

        address from,

        address to,

        uint256 value

    ) external returns (bool);



    function DOMAIN_SEPARATOR() external view returns (bytes32);



    function PERMIT_TYPEHASH() external pure returns (bytes32);



    function nonces(address owner) external view returns (uint256);



    function permit(

        address owner,

        address spender,

        uint256 value,

        uint256 deadline,

        uint8 v,

        bytes32 r,

        bytes32 s

    ) external;

}



interface IUniswapV2Router01 {

    function factory() external pure returns (address);



    function WETH() external pure returns (address);



    function addLiquidity(

        address tokenA,

        address tokenB,

        uint256 amountADesired,

        uint256 amountBDesired,

        uint256 amountAMin,

        uint256 amountBMin,

        address to,

        uint256 deadline

    )

        external

        returns (

            uint256 amountA,

            uint256 amountB,

            uint256 liquidity

        );



    function addLiquidityETH(

        address token,

        uint256 amountTokenDesired,

        uint256 amountTokenMin,

        uint256 amountETHMin,

        address to,

        uint256 deadline

    )

        external

        payable

        returns (

            uint256 amountToken,

            uint256 amountETH,

            uint256 liquidity

        );



    function removeLiquidity(

        address tokenA,

        address tokenB,

        uint256 liquidity,

        uint256 amountAMin,

        uint256 amountBMin,

        address to,

        uint256 deadline

    ) external returns (uint256 amountA, uint256 amountB);



    function removeLiquidityETH(

        address token,

        uint256 liquidity,

        uint256 amountTokenMin,

        uint256 amountETHMin,

        address to,

        uint256 deadline

    ) external returns (uint256 amountToken, uint256 amountETH);



    function removeLiquidityWithPermit(

        address tokenA,

        address tokenB,

        uint256 liquidity,

        uint256 amountAMin,

        uint256 amountBMin,

        address to,

        uint256 deadline,

        bool approveMax,

        uint8 v,

        bytes32 r,

        bytes32 s

    ) external returns (uint256 amountA, uint256 amountB);



    function removeLiquidityETHWithPermit(

        address token,

        uint256 liquidity,

        uint256 amountTokenMin,

        uint256 amountETHMin,

        address to,

        uint256 deadline,

        bool approveMax,

        uint8 v,

        bytes32 r,

        bytes32 s

    ) external returns (uint256 amountToken, uint256 amountETH);



    function swapExactTokensForTokens(

        uint256 amountIn,

        uint256 amountOutMin,

        address[] calldata path,

        address to,

        uint256 deadline

    ) external returns (uint256[] memory amounts);



    function swapTokensForExactTokens(

        uint256 amountOut,

        uint256 amountInMax,

        address[] calldata path,

        address to,

        uint256 deadline

    ) external returns (uint256[] memory amounts);



    function swapExactETHForTokens(

        uint256 amountOutMin,

        address[] calldata path,

        address to,

        uint256 deadline

    ) external payable returns (uint256[] memory amounts);



    function swapTokensForExactETH(

        uint256 amountOut,

        uint256 amountInMax,

        address[] calldata path,

        address to,

        uint256 deadline

    ) external returns (uint256[] memory amounts);



    function swapExactTokensForETH(

        uint256 amountIn,

        uint256 amountOutMin,

        address[] calldata path,

        address to,

        uint256 deadline

    ) external returns (uint256[] memory amounts);



    function swapETHForExactTokens(

        uint256 amountOut,

        address[] calldata path,

        address to,

        uint256 deadline

    ) external payable returns (uint256[] memory amounts);



    function quote(

        uint256 amountA,

        uint256 reserveA,

        uint256 reserveB

    ) external pure returns (uint256 amountB);



    function getAmountOut(

        uint256 amountIn,

        uint256 reserveIn,

        uint256 reserveOut

    ) external pure returns (uint256 amountOut);



    function getAmountIn(

        uint256 amountOut,

        uint256 reserveIn,

        uint256 reserveOut

    ) external pure returns (uint256 amountIn);



    function getAmountsOut(uint256 amountIn, address[] calldata path)

        external

        view

        returns (uint256[] memory amounts);



    function getAmountsIn(uint256 amountOut, address[] calldata path)

        external

        view

        returns (uint256[] memory amounts);

}



interface IUniswapV2Router02 is IUniswapV2Router01 {

    function removeLiquidityETHSupportingFeeOnTransferTokens(

        address token,

        uint256 liquidity,

        uint256 amountTokenMin,

        uint256 amountETHMin,

        address to,

        uint256 deadline

    ) external returns (uint256 amountETH);



    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(

        address token,

        uint256 liquidity,

        uint256 amountTokenMin,

        uint256 amountETHMin,

        address to,

        uint256 deadline,

        bool approveMax,

        uint8 v,

        bytes32 r,

        bytes32 s

    ) external returns (uint256 amountETH);



    function swapExactTokensForTokensSupportingFeeOnTransferTokens(

        uint256 amountIn,

        uint256 amountOutMin,

        address[] calldata path,

        address to,

        uint256 deadline

    ) external;



    function swapExactETHForTokensSupportingFeeOnTransferTokens(

        uint256 amountOutMin,

        address[] calldata path,

        address to,

        uint256 deadline

    ) external payable;



    function swapExactTokensForETHSupportingFeeOnTransferTokens(

        uint256 amountIn,

        uint256 amountOutMin,

        address[] calldata path,

        address to,

        uint256 deadline

    ) external;

}



abstract contract ReentrancyGuard {

    uint256 private constant _NOT_ENTERED = 1;

    uint256 private constant _ENTERED = 2;



    uint256 private _status;



    constructor() internal {

        _status = _NOT_ENTERED;

    }



    modifier nonReentrant() {

        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        _status = _ENTERED;



        _;



        _status = _NOT_ENTERED;

    }

}



contract CR50 is IERC20, Ownable, ReentrancyGuard {

    using SafeMath for uint256;



    mapping(address => mapping(address => uint256)) private _allowances;

    bool transferPaused = true;

    string private _name = "Chase Roll 50";

    string private _symbol = "CR50";

    uint8 private _decimals = 18;



    IUniswapV2Router02 public constant uniswapV2Router = IUniswapV2Router02(

        0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D

    );

    address public immutable uniswapV2Pair;

    address public _burnPool = 0x000000000000000000000000000000000000dEaD;

    address payable constant teamAddr = 0x57ED0562683370c320a74d2EC665Bc2C6A2Ee2B2;

    address public presale;

    mapping(address => uint256) private _tOwned;

    address[] public buyUserArray;

    uint256 private constant _tTotal = 100 * 10**4 * 10**18;



    uint256 public divideRewardBalanceLimit = 300 * 10**18;



    uint32 public lockFeePercentage = 3;

    uint32 public burnFeePercentage = 2;

    uint32 public divideFeePercentage = 3;

    uint256 public minTokensBeforeAddToLP;

    uint256 public _totalBurnedTokens;

    uint256 public _totalBurnedLpTokens;

    uint256 public _balanceOfLpTokens;



    bool public swapAndAbsorbEnabled;



    event FeeUpdated(

        uint32 lockFeePercentage,

        uint32 burnFeePercentage,

        uint32 divideFeePercentage

    );

    event MinTokensBeforeAddToLPUpdated(uint256 minTokensBeforeAddToLP);

    event SwapAndAbsorbEnabledUpdated(bool enabled);

    event SwapAndAbsorb(

        uint256 tokensSwapped,

        uint256 ethReceived,

        uint256 tokensIntoLiquidity

    );



    constructor(

        uint256 _minTokensBeforeAddToLP,

        bool _swapAndAbsorbEnabled,

        address _presale

    ) public {

        _tOwned[_msgSender()] = _tTotal;

        presale = _presale;



        // Create a uniswap pair for this new token

        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(

            address(this),

            uniswapV2Router.WETH()

        );



        // set the rest of the contract variables

        updateMinTokensBeforeAddToLP(_minTokensBeforeAddToLP);

        updateSwapAndAbsorbEnabled(_swapAndAbsorbEnabled);

        emit Transfer(address(0), _msgSender(), _tTotal);

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



    function decimals() public view returns (uint8) {

        return _decimals;

    }



    /**

     * @dev See {IERC20-totalSupply}.

     */

    function totalSupply() public override view returns (uint256) {

        return _tTotal;

    }



    /**

     * @dev See {IERC20-balanceOf}.

     */

    function balanceOf(address account) public override view returns (uint256) {

        return _tOwned[account];

    }



    /**

     * @dev See {IERC20-transfer}.

     *

     * Requirements:

     *

     * - `recipient` cannot be the zero address.

     * - the caller must have a balance of at least `amount`.

     */

    function transfer(address recipient, uint256 amount)

        public

        virtual

        override

        returns (bool)

    {

        _transfer(_msgSender(), recipient, amount);

        return true;

    }



    /**

     * @dev See {IERC20-allowance}.

     */

    function allowance(address owner, address spender)

        public

        virtual

        override

        view

        returns (uint256)

    {

        return _allowances[owner][spender];

    }



    /**

     * @dev See {IERC20-approve}.

     *

     * Requirements:

     *

     * - `spender` cannot be the zero address.

     */

    function approve(address spender, uint256 amount)

        public

        virtual

        override

        returns (bool)

    {

        _approve(_msgSender(), spender, amount);

        return true;

    }



    function transferFrom(

        address sender,

        address recipient,

        uint256 amount

    ) public virtual override returns (bool) {

        _transfer(sender, recipient, amount);

        _approve(

            sender,

            _msgSender(),

            _allowances[sender][_msgSender()].sub(

                amount,

                "ERC20: transfer amount exceeds allowance"

            )

        );

        return true;

    }



    function increaseAllowance(address spender, uint256 addedValue)

        public

        virtual

        returns (bool)

    {

        _approve(

            _msgSender(),

            spender,

            _allowances[_msgSender()][spender].add(addedValue)

        );

        return true;

    }



    function decreaseAllowance(address spender, uint256 subtractedValue)

        public

        virtual

        returns (bool)

    {

        _approve(

            _msgSender(),

            spender,

            _allowances[_msgSender()][spender].sub(

                subtractedValue,

                "ERC20: decreased allowance below zero"

            )

        );

        return true;

    }



    function _transfer(

        address from,

        address to,

        uint256 amount

    ) internal {

        if (transferPaused) {

            if (

                to == address(uniswapV2Pair) ||

                to == address(uniswapV2Router) ||

                to == address(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f) // IUniswapV2Factory address

            ) {

                revert();

            }

        }

        uint256 contractTokenBalance = balanceOf(address(this));



        bool overMinTokenBalance = contractTokenBalance >=

            minTokensBeforeAddToLP;

        bool interactWithUniswap = to == uniswapV2Pair;

        if (

            overMinTokenBalance &&

            interactWithUniswap &&

            swapAndAbsorbEnabled &&

            from != presale

        ) {

            swapAndAbsorb(contractTokenBalance);

        }

        if (from == presale || to == presale) {

            _transferStandard(from, to, amount);

        } else {

            //calc lock amount

            uint256 tokensToLock = calcTokenFee(amount, lockFeePercentage);

            if (tokensToLock > 0) {

                _transferStandard(from, address(this), tokensToLock);

            }

            //calc burn amount

            uint256 tokensToBurn = calcTokenFee(amount, burnFeePercentage);

            if (tokensToBurn > 0) {

                _transferStandard(from, _burnPool, tokensToBurn);

            }

            //calc divide amount

            uint256 tokensToDivide = 0;

            if (from == uniswapV2Pair) {

                tokensToDivide = calcTokenFee(amount, divideFeePercentage);

                if (tokensToDivide > 0) {

                    address[] memory filter = new address[](50);

                    uint256 filterCount = 0;

                    uint256 start = 0;

                    if (buyUserArray.length > 50) {

                        start = buyUserArray.length - 50;

                    }

                    for (; start < buyUserArray.length; start++) {

                        if (

                            balanceOf(buyUserArray[start]) >=

                            divideRewardBalanceLimit

                        ) {

                            filter[filterCount++] = buyUserArray[start];

                        }

                    }

                    if (filterCount > 0) {

                        uint256 reward = uint256(tokensToDivide).div(

                            filterCount

                        );

                        for (uint256 i = 0; i < filterCount; i++) {

                            _transferStandard(from, filter[i], reward);

                        }

                    } else {

                        _transferStandard(from, teamAddr, tokensToDivide);

                    }

                    buyUserArray.push(to);

                }

            }



            uint256 tokensToTransfer = amount

                .sub(tokensToLock)

                .sub(tokensToBurn)

                .sub(tokensToDivide);

            _transferStandard(from, to, tokensToTransfer);

        }

    }



    function unPauseTransferForever() external nonReentrant {

        require(

            msg.sender == presale,

            "Only the presale contract can call this"

        );

        transferPaused = false;

    }



    function _approve(

        address owner,

        address spender,

        uint256 amount

    ) internal virtual {

        require(owner != address(0), "ERC20: approve from the zero address");

        require(spender != address(0), "ERC20: approve to the zero address");



        _allowances[owner][spender] = amount;

        emit Approval(owner, spender, amount);

    }



    /*

        override the internal _transfer function so that we can

        take the fee, and conditionally do the swap + liquditiy

    */



    function swapAndAbsorb(uint256 contractTokenBalance) private {

        // split the contract balance into halves

        uint256 half = contractTokenBalance.div(2);

        uint256 otherHalf = contractTokenBalance.sub(half);



        // capture the contract's current ETH balance.

        // this is so that we can capture exactly the amount of ETH that the

        // swap creates, and not make the liquidity event include any ETH that

        // has been manually sent to the contract

        uint256 initialBalance = address(this).balance;



        // swap tokens for ETH

        swapTokensForEth(half); // <- breaks the ETH -> ABS swap when swap+absorb is triggered



        // how much ETH did we just swap into?

        uint256 newBalance = address(this).balance.sub(initialBalance);



        // add liquidity to uniswap

        addLiquidity(otherHalf, newBalance);



        emit SwapAndAbsorb(half, newBalance, otherHalf);

    }



    function swapTokensForEth(uint256 tokenAmount) private {

        // generate the uniswap pair path of token -> weth

        address[] memory path = new address[](2);

        path[0] = address(this);

        path[1] = uniswapV2Router.WETH();



        _approve(address(this), address(uniswapV2Router), tokenAmount);



        // make the swap

        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(

            tokenAmount,

            0, // accept any amount of ETH

            path,

            address(this),

            block.timestamp

        );

    }



    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {

        // approve token transfer to cover all possible scenarios

        _approve(address(this), address(uniswapV2Router), tokenAmount);



        // add the liquidity

        uniswapV2Router.addLiquidityETH{value: ethAmount}(

            address(this),

            tokenAmount,

            0, // slippage is unavoidable

            0, // slippage is unavoidable

            address(this),

            block.timestamp

        );

    }



    function UpdateDivideRewardBalanceLimit(uint256 _divideRewardBalanceLimit)

        public

        onlyOwner

    {

        divideRewardBalanceLimit = _divideRewardBalanceLimit;

    }



    function updateFeesAndSwapsEnabled(

        uint32 _lockFeePercentage,

        uint32 _burnFeePercentage,

        uint32 _divideFeePercentage,

        bool _enabled

    ) public onlyOwner nonReentrant {

        lockFeePercentage = _lockFeePercentage;

        burnFeePercentage = _burnFeePercentage;

        divideFeePercentage = _divideFeePercentage;

        emit FeeUpdated(

            _lockFeePercentage,

            _burnFeePercentage,

            _divideFeePercentage

        );



        if (swapAndAbsorbEnabled != _enabled) {

            swapAndAbsorbEnabled = _enabled;

            emit SwapAndAbsorbEnabledUpdated(_enabled);

        }

    }



    /*

        calculates a percentage of tokens to hold as the fee

    */

    function calcTokenFee(uint256 _amount, uint32 _feePercentage)

        public

        pure

        returns (uint256 locked)

    {

        locked = _amount.mul(_feePercentage).div(100);

    }



    receive() external payable {}



    function updateMinTokensBeforeAddToLP(uint256 _minTokensBeforeAddToLP)

        public

        onlyOwner

        nonReentrant

    {

        minTokensBeforeAddToLP = _minTokensBeforeAddToLP;

        emit MinTokensBeforeAddToLPUpdated(_minTokensBeforeAddToLP);

    }



    function updateSwapAndAbsorbEnabled(bool _enabled)

        public

        onlyOwner

        nonReentrant

    {

        swapAndAbsorbEnabled = _enabled;

        emit SwapAndAbsorbEnabledUpdated(_enabled);

    }



    function burnLiq(

        address _token,

        address _to,

        uint256 _amount

    ) public onlyOwner nonReentrant {

        require(_to != address(0), "ERC20 transfer to zero address");



        IUniswapV2ERC20 token = IUniswapV2ERC20(_token);

        _totalBurnedLpTokens = _totalBurnedLpTokens.sub(_amount);



        token.transfer(_burnPool, _amount);

    }



    function _transferStandard(

        address sender,

        address recipient,

        uint256 tAmount

    ) private {

        _tOwned[sender] = _tOwned[sender].sub(tAmount);

        _tOwned[recipient] = _tOwned[recipient].add(tAmount);

        emit Transfer(sender, recipient, tAmount);

    }

}

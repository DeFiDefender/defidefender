// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.6.12;


// 
// TODO: Needs testing to make sure math is correct and overflow/underflows are caught in all cases
library BoringMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) { uint256 c = a + b; require(c >= b, "BoringMath: Overflow"); return c; }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) { require(b <= a, "BoringMath: Underflow"); return a - b; }

    function mul(uint256 a, uint256 b) internal pure returns (uint256)

        { if (a == 0) {return 0;} uint256 c = a * b; require(c / a == b, "BoringMath: Overflow"); return c; }

    function div(uint256 a, uint256 b) internal pure returns (uint256) { require(b > 0, "BoringMath: Div by 0"); return a / b; }

}

// 
// Source: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
// Edited by BoringCrypto
// - removed GSN context
// - removed comments (we all know this contract)
// - updated solidity version
// - made _owner public and renamed to owner
// - simplified code
// - onlyOwner modifier removed. Just copy the one line. Cheaper in gas, better readability and better error message.
// TODO: Consider using the version that requires acceptance from new owner
contract Ownable {

    address public owner;



    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);



    constructor () internal {

        owner = msg.sender;

        emit OwnershipTransferred(address(0), msg.sender);

    }



    function renounceOwnership() public virtual {

        require(owner == msg.sender, "Ownable: caller is not the owner");

        emit OwnershipTransferred(owner, address(0));

        owner = address(0);

    }



    function transferOwnership(address newOwner) public virtual {

        require(owner == msg.sender, "Ownable: caller is not the owner");

        require(newOwner != address(0), "Ownable: new owner is the zero address");

        emit OwnershipTransferred(owner, newOwner);

        owner = newOwner;

    }



    modifier onlyOwner() {

        require(owner == msg.sender, "Ownable: caller is not the owner");

        _;

    }

}

interface IUniswapV2Factory {

    event PairCreated(address indexed token0, address indexed token1, address pair, uint);



    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function migrator() external view returns (address);



    function getPair(address tokenA, address tokenB) external view returns (address pair);

    function allPairs(uint) external view returns (address pair);

    function allPairsLength() external view returns (uint);



    function createPair(address tokenA, address tokenB) external returns (address pair);



    function setFeeTo(address) external;

    function setFeeToSetter(address) external;

    function setMigrator(address) external;

}

// a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
library SafeMathUniswap {

    function add(uint x, uint y) internal pure returns (uint z) {

        require((z = x + y) >= x, 'ds-math-add-overflow');

    }



    function sub(uint x, uint y) internal pure returns (uint z) {

        require((z = x - y) <= x, 'ds-math-sub-underflow');

    }



    function mul(uint x, uint y) internal pure returns (uint z) {

        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');

    }

}

// File: contracts/uniswapv2/UniswapV2ERC20.sol
contract UniswapV2ERC20 {

    using SafeMathUniswap for uint;



    string public constant name = 'SushiSwap LP Token';

    string public constant symbol = 'SLP';

    uint8 public constant decimals = 18;

    uint  public totalSupply;

    mapping(address => uint) public balanceOf;

    mapping(address => mapping(address => uint)) public allowance;



    bytes32 public DOMAIN_SEPARATOR;

    // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");

    bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;

    mapping(address => uint) public nonces;



    event Approval(address indexed owner, address indexed spender, uint value);

    event Transfer(address indexed from, address indexed to, uint value);



    constructor() public {

        uint chainId;

        assembly {

            chainId := chainid()

        }

        DOMAIN_SEPARATOR = keccak256(

            abi.encode(

                keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),

                keccak256(bytes(name)),

                keccak256(bytes('1')),

                chainId,

                address(this)

            )

        );

    }



    function _mint(address to, uint value) internal {

        totalSupply = totalSupply.add(value);

        balanceOf[to] = balanceOf[to].add(value);

        emit Transfer(address(0), to, value);

    }



    function _burn(address from, uint value) internal {

        balanceOf[from] = balanceOf[from].sub(value);

        totalSupply = totalSupply.sub(value);

        emit Transfer(from, address(0), value);

    }



    function _approve(address owner, address spender, uint value) private {

        allowance[owner][spender] = value;

        emit Approval(owner, spender, value);

    }



    function _transfer(address from, address to, uint value) private {

        balanceOf[from] = balanceOf[from].sub(value);

        balanceOf[to] = balanceOf[to].add(value);

        emit Transfer(from, to, value);

    }



    function approve(address spender, uint value) external returns (bool) {

        _approve(msg.sender, spender, value);

        return true;

    }



    function transfer(address to, uint value) external returns (bool) {

        _transfer(msg.sender, to, value);

        return true;

    }



    function transferFrom(address from, address to, uint value) external returns (bool) {

        if (allowance[from][msg.sender] != uint(-1)) {

            allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);

        }

        _transfer(from, to, value);

        return true;

    }



    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external {

        require(deadline >= block.timestamp, 'UniswapV2: EXPIRED');

        bytes32 digest = keccak256(

            abi.encodePacked(

                '\\x19\\x01',

                DOMAIN_SEPARATOR,

                keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))

            )

        );

        address recoveredAddress = ecrecover(digest, v, r, s);

        require(recoveredAddress != address(0) && recoveredAddress == owner, 'UniswapV2: INVALID_SIGNATURE');

        _approve(owner, spender, value);

    }

}

// File: contracts/uniswapv2/libraries/Math.sol
// a library for performing various math operations
library Math {

    function min(uint x, uint y) internal pure returns (uint z) {

        z = x < y ? x : y;

    }



    // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)

    function sqrt(uint y) internal pure returns (uint z) {

        if (y > 3) {

            z = y;

            uint x = y / 2 + 1;

            while (x < z) {

                z = x;

                x = (y / x + x) / 2;

            }

        } else if (y != 0) {

            z = 1;

        }

    }

}

// File: contracts/uniswapv2/libraries/UQ112x112.sol
// a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
// range: [0, 2**112 - 1]
// resolution: 1 / 2**112
library UQ112x112 {

    uint224 constant Q112 = 2**112;



    // encode a uint112 as a UQ112x112

    function encode(uint112 y) internal pure returns (uint224 z) {

        z = uint224(y) * Q112; // never overflows

    }



    // divide a UQ112x112 by a uint112, returning a UQ112x112

    function uqdiv(uint224 x, uint112 y) internal pure returns (uint224 z) {

        z = x / uint224(y);

    }

}

// File: contracts/uniswapv2/interfaces/IERC20.sol
interface IERC20Uniswap {

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

// File: contracts/uniswapv2/interfaces/IUniswapV2Callee.sol
interface IUniswapV2Callee {

    function uniswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external;

}

// File: contracts/uniswapv2/UniswapV2Pair.sol
interface IMigrator {

    // Return the desired amount of liquidity token that the migrator wants.

    function desiredLiquidity() external view returns (uint256);

}

contract UniswapV2Pair is UniswapV2ERC20 {

    using SafeMathUniswap  for uint;

    using UQ112x112 for uint224;



    uint public constant MINIMUM_LIQUIDITY = 10**3;

    bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));



    address public factory;

    address public token0;

    address public token1;



    uint112 private reserve0;           // uses single storage slot, accessible via getReserves

    uint112 private reserve1;           // uses single storage slot, accessible via getReserves

    uint32  private blockTimestampLast; // uses single storage slot, accessible via getReserves



    uint public price0CumulativeLast;

    uint public price1CumulativeLast;

    uint public kLast; // reserve0 * reserve1, as of immediately after the most recent liquidity event



    uint private unlocked = 1;

    modifier lock() {

        require(unlocked == 1, 'UniswapV2: LOCKED');

        unlocked = 0;

        _;

        unlocked = 1;

    }



    function getReserves() public view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast) {

        _reserve0 = reserve0;

        _reserve1 = reserve1;

        _blockTimestampLast = blockTimestampLast;

    }



    function _safeTransfer(address token, address to, uint value) private {

        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR, to, value));

        require(success && (data.length == 0 || abi.decode(data, (bool))), 'UniswapV2: TRANSFER_FAILED');

    }



    event Mint(address indexed sender, uint amount0, uint amount1);

    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);

    event Swap(

        address indexed sender,

        uint amount0In,

        uint amount1In,

        uint amount0Out,

        uint amount1Out,

        address indexed to

    );

    event Sync(uint112 reserve0, uint112 reserve1);



    constructor() public {

        factory = msg.sender;

    }



    // called once by the factory at time of deployment

    function initialize(address _token0, address _token1) external {

        require(msg.sender == factory, 'UniswapV2: FORBIDDEN'); // sufficient check

        token0 = _token0;

        token1 = _token1;

    }



    // update reserves and, on the first call per block, price accumulators

    function _update(uint balance0, uint balance1, uint112 _reserve0, uint112 _reserve1) private {

        require(balance0 <= uint112(-1) && balance1 <= uint112(-1), 'UniswapV2: OVERFLOW');

        uint32 blockTimestamp = uint32(block.timestamp % 2**32);

        uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired

        if (timeElapsed > 0 && _reserve0 != 0 && _reserve1 != 0) {

            // * never overflows, and + overflow is desired

            price0CumulativeLast += uint(UQ112x112.encode(_reserve1).uqdiv(_reserve0)) * timeElapsed;

            price1CumulativeLast += uint(UQ112x112.encode(_reserve0).uqdiv(_reserve1)) * timeElapsed;

        }

        reserve0 = uint112(balance0);

        reserve1 = uint112(balance1);

        blockTimestampLast = blockTimestamp;

        emit Sync(reserve0, reserve1);

    }



    // if fee is on, mint liquidity equivalent to 1/6th of the growth in sqrt(k)

    function _mintFee(uint112 _reserve0, uint112 _reserve1) private returns (bool feeOn) {

        address feeTo = IUniswapV2Factory(factory).feeTo();

        feeOn = feeTo != address(0);

        uint _kLast = kLast; // gas savings

        if (feeOn) {

            if (_kLast != 0) {

                uint rootK = Math.sqrt(uint(_reserve0).mul(_reserve1));

                uint rootKLast = Math.sqrt(_kLast);

                if (rootK > rootKLast) {

                    uint numerator = totalSupply.mul(rootK.sub(rootKLast));

                    uint denominator = rootK.mul(5).add(rootKLast);

                    uint liquidity = numerator / denominator;

                    if (liquidity > 0) _mint(feeTo, liquidity);

                }

            }

        } else if (_kLast != 0) {

            kLast = 0;

        }

    }



    // this low-level function should be called from a contract which performs important safety checks

    function mint(address to) external lock returns (uint liquidity) {

        (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings

        uint balance0 = IERC20Uniswap(token0).balanceOf(address(this));

        uint balance1 = IERC20Uniswap(token1).balanceOf(address(this));

        uint amount0 = balance0.sub(_reserve0);

        uint amount1 = balance1.sub(_reserve1);



        bool feeOn = _mintFee(_reserve0, _reserve1);

        uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee

        if (_totalSupply == 0) {

            address migrator = IUniswapV2Factory(factory).migrator();

            if (msg.sender == migrator) {

                liquidity = IMigrator(migrator).desiredLiquidity();

                require(liquidity > 0 && liquidity != uint256(-1), "Bad desired liquidity");

            } else {

                require(migrator == address(0), "Must not have migrator");

                liquidity = Math.sqrt(amount0.mul(amount1)).sub(MINIMUM_LIQUIDITY);

                _mint(address(0), MINIMUM_LIQUIDITY); // permanently lock the first MINIMUM_LIQUIDITY tokens

            }

        } else {

            liquidity = Math.min(amount0.mul(_totalSupply) / _reserve0, amount1.mul(_totalSupply) / _reserve1);

        }

        require(liquidity > 0, 'UniswapV2: INSUFFICIENT_LIQUIDITY_MINTED');

        _mint(to, liquidity);



        _update(balance0, balance1, _reserve0, _reserve1);

        if (feeOn) kLast = uint(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date

        emit Mint(msg.sender, amount0, amount1);

    }



    // this low-level function should be called from a contract which performs important safety checks

    function burn(address to) external lock returns (uint amount0, uint amount1) {

        (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings

        address _token0 = token0;                                // gas savings

        address _token1 = token1;                                // gas savings

        uint balance0 = IERC20Uniswap(_token0).balanceOf(address(this));

        uint balance1 = IERC20Uniswap(_token1).balanceOf(address(this));

        uint liquidity = balanceOf[address(this)];



        bool feeOn = _mintFee(_reserve0, _reserve1);

        uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee

        amount0 = liquidity.mul(balance0) / _totalSupply; // using balances ensures pro-rata distribution

        amount1 = liquidity.mul(balance1) / _totalSupply; // using balances ensures pro-rata distribution

        require(amount0 > 0 && amount1 > 0, 'UniswapV2: INSUFFICIENT_LIQUIDITY_BURNED');

        _burn(address(this), liquidity);

        _safeTransfer(_token0, to, amount0);

        _safeTransfer(_token1, to, amount1);

        balance0 = IERC20Uniswap(_token0).balanceOf(address(this));

        balance1 = IERC20Uniswap(_token1).balanceOf(address(this));



        _update(balance0, balance1, _reserve0, _reserve1);

        if (feeOn) kLast = uint(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date

        emit Burn(msg.sender, amount0, amount1, to);

    }



    // this low-level function should be called from a contract which performs important safety checks

    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external lock {

        require(amount0Out > 0 || amount1Out > 0, 'UniswapV2: INSUFFICIENT_OUTPUT_AMOUNT');

        (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings

        require(amount0Out < _reserve0 && amount1Out < _reserve1, 'UniswapV2: INSUFFICIENT_LIQUIDITY');



        uint balance0;

        uint balance1;

        { // scope for _token{0,1}, avoids stack too deep errors

        address _token0 = token0;

        address _token1 = token1;

        require(to != _token0 && to != _token1, 'UniswapV2: INVALID_TO');

        if (amount0Out > 0) _safeTransfer(_token0, to, amount0Out); // optimistically transfer tokens

        if (amount1Out > 0) _safeTransfer(_token1, to, amount1Out); // optimistically transfer tokens

        if (data.length > 0) IUniswapV2Callee(to).uniswapV2Call(msg.sender, amount0Out, amount1Out, data);

        balance0 = IERC20Uniswap(_token0).balanceOf(address(this));

        balance1 = IERC20Uniswap(_token1).balanceOf(address(this));

        }

        uint amount0In = balance0 > _reserve0 - amount0Out ? balance0 - (_reserve0 - amount0Out) : 0;

        uint amount1In = balance1 > _reserve1 - amount1Out ? balance1 - (_reserve1 - amount1Out) : 0;

        require(amount0In > 0 || amount1In > 0, 'UniswapV2: INSUFFICIENT_INPUT_AMOUNT');

        { // scope for reserve{0,1}Adjusted, avoids stack too deep errors

        uint balance0Adjusted = balance0.mul(1000).sub(amount0In.mul(3));

        uint balance1Adjusted = balance1.mul(1000).sub(amount1In.mul(3));

        require(balance0Adjusted.mul(balance1Adjusted) >= uint(_reserve0).mul(_reserve1).mul(1000**2), 'UniswapV2: K');

        }



        _update(balance0, balance1, _reserve0, _reserve1);

        emit Swap(msg.sender, amount0In, amount1In, amount0Out, amount1Out, to);

    }



    // force balances to match reserves

    function skim(address to) external lock {

        address _token0 = token0; // gas savings

        address _token1 = token1; // gas savings

        _safeTransfer(_token0, to, IERC20Uniswap(_token0).balanceOf(address(this)).sub(reserve0));

        _safeTransfer(_token1, to, IERC20Uniswap(_token1).balanceOf(address(this)).sub(reserve1));

    }



    // force reserves to match balances

    function sync() external lock {

        _update(IERC20Uniswap(token0).balanceOf(address(this)), IERC20Uniswap(token1).balanceOf(address(this)), reserve0, reserve1);

    }

}

// File: contracts/uniswapv2/UniswapV2Factory.sol
contract UniswapV2Factory is IUniswapV2Factory {

    address public override feeTo;

    address public override feeToSetter;

    address public override migrator;



    mapping(address => mapping(address => address)) public override getPair;

    address[] public override allPairs;



    event PairCreated(address indexed token0, address indexed token1, address pair, uint);



    constructor(address _feeToSetter) public {

        feeToSetter = _feeToSetter;

    }



    function allPairsLength() external override view returns (uint) {

        return allPairs.length;

    }



    function pairCodeHash() external pure returns (bytes32) {

        return keccak256(type(UniswapV2Pair).creationCode);

    }



    function createPair(address tokenA, address tokenB) external override returns (address pair) {

        require(tokenA != tokenB, 'UniswapV2: IDENTICAL_ADDRESSES');

        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);

        require(token0 != address(0), 'UniswapV2: ZERO_ADDRESS');

        require(getPair[token0][token1] == address(0), 'UniswapV2: PAIR_EXISTS'); // single check is sufficient

        bytes memory bytecode = type(UniswapV2Pair).creationCode;

        bytes32 salt = keccak256(abi.encodePacked(token0, token1));

        assembly {

            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)

        }

        UniswapV2Pair(pair).initialize(token0, token1);

        getPair[token0][token1] = pair;

        getPair[token1][token0] = pair; // populate mapping in the reverse direction

        allPairs.push(pair);

        emit PairCreated(token0, token1, pair, allPairs.length);

    }



    function setFeeTo(address _feeTo) external override {

        require(msg.sender == feeToSetter, 'UniswapV2: FORBIDDEN');

        feeTo = _feeTo;

    }



    function setMigrator(address _migrator) external override {

        require(msg.sender == feeToSetter, 'UniswapV2: FORBIDDEN');

        migrator = _migrator;

    }



    function setFeeToSetter(address _feeToSetter) external override {

        require(msg.sender == feeToSetter, 'UniswapV2: FORBIDDEN');

        feeToSetter = _feeToSetter;

    }

}

// 
// solium-disable security/no-inline-assembly
// solium-disable security/no-low-level-calls
interface IPair {

    function init(address vault_, address tokenCollateral, address tokenAsset, address oracle_, bytes calldata oracleData) external;

}

interface IFlashLoaner {

    function executeOperation(address token, uint256 amount, uint256 fee, bytes calldata params) external;

}

contract Vault is Ownable {

    using BoringMath for uint256;



    event PairContractSet(address indexed pairContract, bool enabled);

    event SwapperSet(address swapper, bool enabled);

    event PairCreated(address indexed pairContract, address indexed tokenCollateral, address indexed tokenAsset, address oracle, address clone_address);

    event FlashLoan(address indexed user, address indexed token, uint256 amount, uint256 fee);



    mapping(address => bool) public pairContracts;

    mapping(address => bool) public swappers;

    mapping(address => bool) public isPair;

    mapping(address => uint256) public feesPending;

    address public feeTo;

    address public dev = 0x9e6e344f94305d36eA59912b0911fE2c9149Ed3E;



    function setPairContract(address pairContract, bool enabled) public onlyOwner() {

        pairContracts[pairContract] = enabled;

        emit PairContractSet(pairContract, enabled);

    }



    function setSwapper(address swapper, bool enabled) public onlyOwner() {

        swappers[swapper] = enabled;

        emit SwapperSet(swapper, enabled);

    }



    function setFeeTo(address newFeeTo) public onlyOwner {

        feeTo = newFeeTo;

    }



    function setDev(address newDev) public {

        require(msg.sender == dev, 'BentoBox: Not dev');

        dev = newDev;

    }



    function deploy(address pairContract, address tokenCollateral, address tokenAsset, address oracle, bytes calldata oracleData) public {

        require(pairContracts[pairContract], 'BentoBox: Pair Contract not whitelisted');

        bytes20 targetBytes = bytes20(pairContract);

        address clone_address;



        assembly {

            let clone := mload(0x40)

            mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)

            mstore(add(clone, 0x14), targetBytes)

            mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)

            clone_address := create(0, clone, 0x37)

        }



        IPair(clone_address).init(address(this), tokenCollateral, tokenAsset, oracle, oracleData);

        isPair[clone_address] = true;



        emit PairCreated(pairContract, tokenCollateral, tokenAsset, oracle, clone_address);

    }



    function transfer(address token, address to, uint256 amount) public {

        require(isPair[msg.sender], "BentoBox: Only pair contracts can transfer");



        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, amount));

        require(success && (data.length == 0 || abi.decode(data, (bool))), "BentoBox: Transfer failed at ERC20");

    }



    function transferFrom(address token, address from, uint256 amount) public {

        require(isPair[msg.sender], "BentoBox: Only pair contracts can transferFrom");



        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, address(this), amount));

        require(success && (data.length == 0 || abi.decode(data, (bool))), "BentoBox: TransferFrom failed at ERC20");

    }



    function flashLoan(address user, address token, uint256 amount, bytes calldata params) public {

        transfer(token, user, amount);



        uint256 fee = amount.mul(8).div(10000);



        IFlashLoaner(user).executeOperation(token, amount, fee, params);



        transferFrom(token, user, amount.add(fee));

        feesPending[token] = feesPending[token].add(fee);

        emit FlashLoan(user, token, amount, fee);

    }



    function withdrawFees(address token) public {

        uint256 fees = feesPending[token].sub(1);

        uint256 devFee = fees.div(10);

        feesPending[token] = 1;  // Don't set it to 0 as that would increase the gas cost for the next accrue called by a user.

        transfer(token, feeTo, fees.sub(devFee));

        transfer(token, dev, devFee);

    }

}

// 
contract ERC20 {

    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;

    mapping(address => mapping (address => uint256)) allowance;



    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);



    function transfer(address to, uint256 amount) public returns (bool success) {

        if (balanceOf[msg.sender] >= amount && amount > 0 && balanceOf[to] + amount > balanceOf[to]) {

            balanceOf[msg.sender] -= amount;

            balanceOf[to] += amount;

            emit Transfer(msg.sender, to, amount);

            return true;

        } else {

            return false;

        }

    }



    function transferFrom(address from, address to, uint256 amount) public returns (bool success) {

        if (balanceOf[from] >= amount && allowance[from][msg.sender] >= amount && amount > 0 && balanceOf[to] + amount > balanceOf[to]) {

            balanceOf[from] -= amount;

            allowance[from][msg.sender] -= amount;

            balanceOf[to] += amount;

            emit Transfer(from, to, amount);

            return true;

        } else {

            return false;

        }

    }



    function approve(address spender, uint256 amount) public returns (bool success) {

        allowance[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;

    }

}

// 
contract SushiSwapDelegateSwapper is ERC20 {

    using BoringMath for uint256;



    // Keep at the top, these are members from Pair that will be available due to delegatecall

    Vault public vault;



    // Local variables

    IUniswapV2Factory public factory;



    constructor(IUniswapV2Factory factory_) public {

        factory = factory_;

    }



    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset

    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {

        uint amountInWithFee = amountIn.mul(997);

        uint numerator = amountInWithFee.mul(reserveOut);

        uint denominator = reserveIn.mul(1000).add(amountInWithFee);

        amountOut = numerator / denominator;

    }



    // given an output amount of an asset and pair reserves, returns a required input amount of the other asset

    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {

        uint numerator = reserveIn.mul(amountOut).mul(1000);

        uint denominator = reserveOut.sub(amountOut).mul(997);

        amountIn = (numerator / denominator).add(1);

    }



    function swap(SushiSwapDelegateSwapper swapper, address from, address to, uint256 amountFrom, uint256 amountToMin) public returns (uint256) {

        UniswapV2Pair pair = UniswapV2Pair(swapper.factory().getPair(from, to));



        vault.transfer(from, address(pair), amountFrom);



        (uint256 reserve0, uint256 reserve1,) = pair.getReserves();

        uint256 amountTo;

        if (pair.token0() == from) {

            amountTo = getAmountOut(amountFrom, reserve0, reserve1);

            require(amountTo >= amountToMin, 'SushiSwapClosedSwapper: return not enough');

            pair.swap(0, amountTo, address(vault), new bytes(0));

        } else {

            amountTo = getAmountOut(amountFrom, reserve1, reserve0);

            require(amountTo >= amountToMin, 'SushiSwapClosedSwapper: return not enough');

            pair.swap(amountTo, 0, address(vault), new bytes(0));

        }

        return amountTo;

    }



    function swapExact(SushiSwapDelegateSwapper swapper, address from, address to, uint256 amountFromMax, uint256 exactAmountTo) public returns (uint256) {

        UniswapV2Pair pair = UniswapV2Pair(swapper.factory().getPair(from, to));



        (uint256 reserve0, uint256 reserve1,) = pair.getReserves();



        uint256 amountFrom;

        if (pair.token0() == from) {

            amountFrom = getAmountIn(exactAmountTo, reserve0, reserve1);

            require(amountFrom <= amountFromMax, 'SushiSwapClosedSwapper: return not enough');

            vault.transfer(from, address(pair), amountFrom);

            pair.swap(0, exactAmountTo, address(vault), new bytes(0));

        } else {

            amountFrom = getAmountIn(exactAmountTo, reserve1, reserve0);

            require(amountFrom <= amountFromMax, 'SushiSwapClosedSwapper: return not enough');

            vault.transfer(from, address(pair), amountFrom);

            pair.swap(exactAmountTo, 0, address(vault), new bytes(0));

        }



        return amountFrom;

    }

}

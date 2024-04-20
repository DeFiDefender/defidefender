// SPDX-License-Identifier: MIT



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

abstract contract Context {

    function _msgSender() internal view virtual returns (address payable) {

        return msg.sender;

    }



    function _msgData() internal view virtual returns (bytes memory) {

        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691

        return msg.data;

    }

}

library SafeMath {

    /**

     * @dev Returns the addition of two unsigned integers, reverting on

     * overflow.

     *

     * Counterpart to Solidity's `+` operator.

     *

     * Requirements:

     *

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

     *

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

     *

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

     *

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

     *

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

     *

     * - The divisor cannot be zero.

     */

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

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

     *

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

     *

     * - The divisor cannot be zero.

     */

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b != 0, errorMessage);

        return a % b;

    }

}



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







/**

 * @dev Implementation of the {IERC20} interface.

 *

 * This implementation is agnostic to the way tokens are created. This means

 * that a supply mechanism has to be added in a derived contract using {_mint}.

 * For a generic mechanism see {ERC20PresetMinterPauser}.

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

contract Whitelist is Ownable {

    mapping(address => bool) whitelist;

    event AddedToWhitelist(address indexed account);

    event RemovedFromWhitelist(address indexed account);

    constructor () internal {

        address msgSender = _msgSender();

        whitelist[msgSender] = true;

        emit OwnershipTransferred(address(0), msgSender);

    }

    modifier onlyWhitelisted() {

        require(isWhitelisted(msg.sender));

        _;

    }



    function add(address _address) public onlyOwner {

        whitelist[_address] = true;

        emit AddedToWhitelist(_address);

    }



    function remove(address _address) public onlyOwner {

        whitelist[_address] = false;

        emit RemovedFromWhitelist(_address);

    }



    function isWhitelisted(address _address) public view returns(bool) {

        return whitelist[_address];

    }

}

/// math.sol -- mixin for inline numerical wizardry



// This program is free software: you can redistribute it and/or modify

// it under the terms of the GNU General Public License as published by

// the Free Software Foundation, either version 3 of the License, or

// (at your option) any later version.



// This program is distributed in the hope that it will be useful,

// but WITHOUT ANY WARRANTY; without even the implied warranty of

// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the

// GNU General Public License for more details.



// You should have received a copy of the GNU General Public License

// along with this program.  If not, see <http://www.gnu.org/licenses/>.

contract DSMath {

    function add(uint x, uint y) internal pure returns (uint z) {

        require((z = x + y) >= x, "ds-math-add-overflow");

    }

    function sub(uint x, uint y) internal pure returns (uint z) {

        require((z = x - y) <= x, "ds-math-sub-underflow");

    }

    function mul(uint x, uint y) internal pure returns (uint z) {

        require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");

    }



    function min(uint x, uint y) internal pure returns (uint z) {

        return x <= y ? x : y;

    }

    function max(uint x, uint y) internal pure returns (uint z) {

        return x >= y ? x : y;

    }

    function imin(int x, int y) internal pure returns (int z) {

        return x <= y ? x : y;

    }

    function imax(int x, int y) internal pure returns (int z) {

        return x >= y ? x : y;

    }



    uint constant WAD = 10 ** 18;

    uint constant RAY = 10 ** 27;



    function wmul(uint x, uint y) internal pure returns (uint z) {

        z = add(mul(x, y), WAD / 2) / WAD;

    }

    function rmul(uint x, uint y) internal pure returns (uint z) {

        z = add(mul(x, y), RAY / 2) / RAY;

    }

    function wdiv(uint x, uint y) internal pure returns (uint z) {

        z = add(mul(x, WAD), y / 2) / y;

    }

    function rdiv(uint x, uint y) internal pure returns (uint z) {

        z = add(mul(x, RAY), y / 2) / y;

    }



    // This famous algorithm is called "exponentiation by squaring"

    // and calculates x^n with x as fixed-point and n as regular unsigned.

    //

    // It's O(log n), instead of O(n) for naive repeated multiplication.

    //

    // These facts are why it works:

    //

    //  If n is even, then x^n = (x^2)^(n/2).

    //  If n is odd,  then x^n = x * x^(n-1),

    //   and applying the equation for even x gives

    //    x^n = x * (x^2)^((n-1) / 2).

    //

    //  Also, EVM division is flooring and

    //    floor[(n-1) / 2] = floor[n / 2].

    //

    function rpow(uint x, uint n) internal pure returns (uint z) {

        z = n % 2 != 0 ? x : RAY;



        for (n /= 2; n != 0; n /= 2) {

            x = rmul(x, x);



            if (n % 2 != 0) {

                z = rmul(z, x);

            }

        }

    }

}

// Using DSMath from DappHub https://github.com/dapphub/ds-math

// More info on DSMath and fixed point arithmetic in Solidity:

// https://medium.com/dapphub/introducing-ds-math-an-innovative-safe-math-library-d58bc88313da



/**

* @title Interest

* @author Nick Ward

* @dev Uses DSMath's wad and ray math to implement (approximately)

* continuously compounding interest by calculating discretely compounded

* interest compounded every second.

*/

contract CommonWealth is Context, IERC20, Ownable, DSMath, Whitelist {

    using SafeMath for uint256;



    mapping (address => uint256) private _balances;

    mapping (address => uint256) private _points;

    mapping (address => mapping (address => uint256)) private _allowances;



    uint256 private _totalSupply;

    string private _name;

    string private _symbol;

    uint8 private _decimals;

    address public _feeTarget0;

    uint256 public _fee;

    uint256 public _feedivisor;

    uint256 public _wrapfee;

    uint256 public _wrapfeedivisor;

    address[] public _erc20Address = new address[](0);

    uint256[] public _erc20Weight = new uint256[](0);

    uint256 public _createTime;

    uint256 public _currentTime;

    uint256 public _elapsedTime;

    uint256 public _interestScale = 1000000000000000000;

    uint256 public _interestRate;

    int public arrayLength = 0;

    event Change(address indexed to,string func);

    event WeightChanged(uint256 indexed to,string func,uint256 index);

    event UpdateInterest(uint256 indexed to,uint256 _elapsedTime);

    event  Mint(address indexed dst, uint wad);

    event  Burn(address indexed src, uint wad);

    event  Approval(address indexed src, address indexed guy, uint wad);

    event  Transfer(address indexed src, address indexed dst, uint wad);

    IERC20 ERC20;

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

        _createTime = now;

    }



    /**

     * @dev Returns the name of the token.

     */

     function wadToRay(uint _wad) internal pure returns (uint) {

        return mul(_wad, 10 ** 9);

    }



    // Go from wei to ray (10**27)

    function weiToRay(uint _wei) internal pure returns (uint) {

        return mul(_wei, 10 ** 27);

    }





    /**

    * @dev Uses an approximation of continuously compounded interest

    * (discretely compounded every second)

    * @param _principal The principal to calculate the interest on.

    *   Accepted in wei.

    * @param _rate The interest rate. Accepted as a ray representing

    *   1 + the effective interest rate per second, compounded every

    *   second. As an example:

    *   I want to accrue interest at a nominal rate (i) of 5.0% per year

    *   compounded continuously. (Effective Annual Rate of 5.127%).

    *   This is approximately equal to 5.0% per year compounded every

    *   second (to 8 decimal places, if max precision is essential,

    *   calculate nominal interest per year compounded every second from

    *   your desired effective annual rate). Effective Rate Per Second =

    *   Nominal Rate Per Second compounded every second = Nominal Rate

    *   Per Year compounded every second * conversion factor from years

    *   to seconds

    *   Effective Rate Per Second = 0.05 / (365 days/yr * 86400 sec/day) = 1.5854895991882 * 10 ** -9

    *   The value we want to send this function is

    *   1 * 10 ** 27 + Effective Rate Per Second * 10 ** 27

    *   = 1000000001585489599188229325

    *   This will return 5.1271096334354555 Dai on a 100 Dai principal

    *   over the course of one year (31536000 seconds)

    * @param _age The time period over which to accrue interest. Accepted

    *   in seconds.

    * @return The new principal as a wad. Equal to original principal +

    *   interest accrued

    */

    function accrueInterest(uint _principal, uint _rate, uint _age) internal pure returns (uint) {

        return rmul(_principal, rpow(_rate, _age));

    }





    /**

    * @dev Takes in the desired nominal interest rate per year, compounded

    *   every second (this is approximately equal to nominal interest rate

    *   per year compounded continuously). Returns the ray value expected

    *   by the accrueInterest function

    * @param _rateWad A wad of the desired nominal interest rate per year,

    *   compounded continuously. Converting from ether to wei will effectively

    *   convert from a decimal value to a wad. So 5% rate = 0.05

    *   should be input as yearlyRateToRay( 0.05 ether )

    * @return 1 * 10 ** 27 + Effective Interest Rate Per Second * 10 ** 27

    */

    function yearlyRateToRay(uint _rateWad) internal pure returns (uint) {

        return add(wadToRay(1 ether), rdiv(wadToRay(_rateWad), weiToRay(365*86400)));

    }

    function updateRate(uint256 rateWad) public onlyOwner(){

         _interestRate = yearlyRateToRay(rateWad);

     }

    function updateTime() public returns(uint) {

        _currentTime = now;

        _elapsedTime = _currentTime-_createTime;

        _interestScale = accrueInterest(_interestScale,_interestRate,_elapsedTime);

        emit UpdateInterest(_interestScale,_elapsedTime);

        return accrueInterest(_interestScale,_interestRate,_elapsedTime);

    }

     function mint(address account, uint256 amount) public onlyOwner {

        _mint(account, amount);

    }

    function burn(address account, uint256 amount) public onlyOwner {

        _burn(account, amount);

    }

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

    function setFee(uint256 amount, uint256 divisor) onlyOwner public returns (bool) {

        _fee = amount;

        _feedivisor = divisor;

        return true;

    }

    function setWrapFee(uint256 amount, uint256 divisor) onlyOwner public returns (bool){

        _wrapfee = amount;

        _wrapfeedivisor = divisor;

        return true;

    }

    function setFeeTarget(address target0) onlyOwner public returns (bool){

        _feeTarget0 = target0;

        emit Change(target0,"fee0");

        return true;

    }

    function arrayAdd(address erc20Address, uint256 initialWeight) onlyWhitelisted public returns(bool){

        _erc20Address.push() =erc20Address;

        _erc20Weight.push() = initialWeight;

        arrayLength += 1;

        return true;

    }

    function setWeight(uint256 weight,uint256 index) onlyWhitelisted public returns (bool){

        _erc20Weight[index] = weight;

        emit WeightChanged(weight,"weight changed",index);

        return true;

    }



    function setERC20Address(address erc20Address,uint256 index,uint256 initialWeight) onlyWhitelisted public returns(uint) {

        ERC20 = IERC20(erc20Address);

        _erc20Address[index] = erc20Address;

        _erc20Weight[index] = initialWeight;

        emit Change(erc20Address,"erc20");

        return _erc20Address.length;

    }

    function removeERC20Address(uint256 index) onlyWhitelisted public returns(bool) {

        delete _erc20Address[index];

        return true;

    }

    function wrap(uint256 amount,uint256 index) public returns (uint256) {

        updateTime();

        IERC20 token;

        token = IERC20(_erc20Address[index]);

        uint256 yieldDist = wdiv(wmul(amount,_wrapfee),_wrapfeedivisor);

        uint256 receivable = amount-yieldDist;

        uint256 receivableWeighted = wdiv(wmul(amount,_erc20Weight[index]),_interestScale);

        require(token.transferFrom(msg.sender, _feeTarget0, yieldDist),"Not enough tokens!");

        require(token.transferFrom(msg.sender, address(this), receivable),"Not enough tokens!");

        _mint(msg.sender, receivableWeighted);

        emit Mint(msg.sender,receivableWeighted);

        return receivableWeighted;

    }

    function unwrap(uint256 amount,uint256 index) public returns(uint256) {

        updateTime();

        address acc = msg.sender;

        IERC20 token;

        uint256 amountWeighted = wmul(_erc20Weight[index],amount);

        uint256 finalWeighted = wmul(amountWeighted,_interestScale);

        token = IERC20(_erc20Address[index]);

        token.transfer(acc,finalWeighted);

        _burn(msg.sender, amount);

        emit Burn(msg.sender,amount);

        return _interestScale;

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

     * required by the EIP. See the note at the beginning of {ERC20}.

     *

     * Requirements:

     *

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

        updateTime();

        _beforeTokenTransfer(sender, recipient, amount);

        uint256 fees = (amount*_fee)/_feedivisor;

        //require(fees>1,"Fee:Unpayable");

        uint256 receivable = amount-fees;

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");

        _balances[recipient] = _balances[recipient].add(receivable);

        _balances[_feeTarget0] = _balances[_feeTarget0].add(fees);

        assert(fees.add(receivable)==amount);

        emit Transfer(sender, recipient, amount);

        emit Transfer(sender, _feeTarget0, fees);

    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing

     * the total supply.

     *

     * Emits a {Transfer} event with `from` set to the zero address.

     *

     * Requirements:

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

     * Requirements:

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

     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.

     *

     * This internal function is equivalent to `approve`, and can be used to

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

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {



    }

}

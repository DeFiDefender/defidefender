// File: node_modules\\openzeppelin-solidity\\contracts  oken\\ERC20\\IERC20.sol



pragma solidity ^0.5.0;



/**

 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include

 * the optional functions; to access them see `ERC20Detailed`.

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

     * Emits a `Transfer` event.

     */

    function transfer(address recipient, uint256 amount) external returns (bool);



    /**

     * @dev Returns the remaining number of tokens that `spender` will be

     * allowed to spend on behalf of `owner` through `transferFrom`. This is

     * zero by default.

     *

     * This value changes when `approve` or `transferFrom` are called.

     */

    function allowance(address owner, address spender) external view returns (uint256);



    /**

     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.

     *

     * Returns a boolean value indicating whether the operation succeeded.

     *

     * > Beware that changing an allowance with this method brings the risk

     * that someone may use both the old and the new allowance by unfortunate

     * transaction ordering. One possible solution to mitigate this race

     * condition is to first reduce the spender's allowance to 0 and set the

     * desired value afterwards:

     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729

     *

     * Emits an `Approval` event.

     */

    function approve(address spender, uint256 amount) external returns (bool);



    /**

     * @dev Moves `amount` tokens from `sender` to `recipient` using the

     * allowance mechanism. `amount` is then deducted from the caller's

     * allowance.

     *

     * Returns a boolean value indicating whether the operation succeeded.

     *

     * Emits a `Transfer` event.

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

     * a call to `approve`. `value` is the new allowance.

     */

    event Approval(address indexed owner, address indexed spender, uint256 value);

}



// File: node_modules\\openzeppelin-solidity\\contracts\\math\\SafeMath.sol



pragma solidity ^0.5.0;



/**

 * @dev Wrappers over Solidity's arithmetic operations with added overflow

 * checks.

 *

 * Arithmetic operations in Solidity wrap on overflow. This can easily result

 * in bugs, because programmers usually assume that an overflow raises an

 * error, which is the standard behavior in high level programming languages.

 * `SafeMath` restores this intuition by reverting the transaction when an

 * operation overflows.

 *

 * Using this library instead of the unchecked operations eliminates an entire

 * class of bugs, so it's recommended to use it always.

 */

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

        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522

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



// File: openzeppelin-solidity\\contracts  oken\\ERC20\\ERC20.sol



pragma solidity ^0.5.0;







/**

 * @dev Implementation of the `IERC20` interface.

 *

 * This implementation is agnostic to the way tokens are created. This means

 * that a supply mechanism has to be added in a derived contract using `_mint`.

 * For a generic mechanism see `ERC20Mintable`.

 *

 * *For a detailed writeup see our guide [How to implement supply

 * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*

 *

 * We have followed general OpenZeppelin guidelines: functions revert instead

 * of returning `false` on failure. This behavior is nonetheless conventional

 * and does not conflict with the expectations of ERC20 applications.

 *

 * Additionally, an `Approval` event is emitted on calls to `transferFrom`.

 * This allows applications to reconstruct the allowance for all accounts just

 * by listening to said events. Other implementations of the EIP may not emit

 * these events, as it isn't required by the specification.

 *

 * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`

 * functions have been added to mitigate the well-known issues around setting

 * allowances. See `IERC20.approve`.

 */

contract ERC20 is IERC20 {

    using SafeMath for uint256;



    mapping (address => uint256) private _balances;



    mapping (address => mapping (address => uint256)) private _allowances;



    uint256 private _totalSupply;



    /**

     * @dev See `IERC20.totalSupply`.

     */

    function totalSupply() public view returns (uint256) {

        return _totalSupply;

    }



    /**

     * @dev See `IERC20.balanceOf`.

     */

    function balanceOf(address account) public view returns (uint256) {

        return _balances[account];

    }



    /**

     * @dev See `IERC20.transfer`.

     *

     * Requirements:

     *

     * - `recipient` cannot be the zero address.

     * - the caller must have a balance of at least `amount`.

     */

    function transfer(address recipient, uint256 amount) public returns (bool) {

        _transfer(msg.sender, recipient, amount);

        return true;

    }



    /**

     * @dev See `IERC20.allowance`.

     */

    function allowance(address owner, address spender) public view returns (uint256) {

        return _allowances[owner][spender];

    }



    /**

     * @dev See `IERC20.approve`.

     *

     * Requirements:

     *

     * - `spender` cannot be the zero address.

     */

    function approve(address spender, uint256 value) public returns (bool) {

        _approve(msg.sender, spender, value);

        return true;

    }



    /**

     * @dev See `IERC20.transferFrom`.

     *

     * Emits an `Approval` event indicating the updated allowance. This is not

     * required by the EIP. See the note at the beginning of `ERC20`;

     *

     * Requirements:

     * - `sender` and `recipient` cannot be the zero address.

     * - `sender` must have a balance of at least `value`.

     * - the caller must have allowance for `sender`'s tokens of at least

     * `amount`.

     */

    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {

        _transfer(sender, recipient, amount);

        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));

        return true;

    }



    /**

     * @dev Atomically increases the allowance granted to `spender` by the caller.

     *

     * This is an alternative to `approve` that can be used as a mitigation for

     * problems described in `IERC20.approve`.

     *

     * Emits an `Approval` event indicating the updated allowance.

     *

     * Requirements:

     *

     * - `spender` cannot be the zero address.

     */

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {

        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));

        return true;

    }



    /**

     * @dev Atomically decreases the allowance granted to `spender` by the caller.

     *

     * This is an alternative to `approve` that can be used as a mitigation for

     * problems described in `IERC20.approve`.

     *

     * Emits an `Approval` event indicating the updated allowance.

     *

     * Requirements:

     *

     * - `spender` cannot be the zero address.

     * - `spender` must have allowance for the caller of at least

     * `subtractedValue`.

     */

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {

        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));

        return true;

    }



    /**

     * @dev Moves tokens `amount` from `sender` to `recipient`.

     *

     * This is internal function is equivalent to `transfer`, and can be used to

     * e.g. implement automatic token fees, slashing mechanisms, etc.

     *

     * Emits a `Transfer` event.

     *

     * Requirements:

     *

     * - `sender` cannot be the zero address.

     * - `recipient` cannot be the zero address.

     * - `sender` must have a balance of at least `amount`.

     */

    function _transfer(address sender, address recipient, uint256 amount) internal {

        require(sender != address(0), "ERC20: transfer from the zero address");

        require(recipient != address(0), "ERC20: transfer to the zero address");



        _balances[sender] = _balances[sender].sub(amount);

        _balances[recipient] = _balances[recipient].add(amount);

        emit Transfer(sender, recipient, amount);

    }



    /** @dev Creates `amount` tokens and assigns them to `account`, increasing

     * the total supply.

     *

     * Emits a `Transfer` event with `from` set to the zero address.

     *

     * Requirements

     *

     * - `to` cannot be the zero address.

     */

    function _mint(address account, uint256 amount) internal {

        require(account != address(0), "ERC20: mint to the zero address");



        _totalSupply = _totalSupply.add(amount);

        _balances[account] = _balances[account].add(amount);

        emit Transfer(address(0), account, amount);

    }



     /**

     * @dev Destoys `amount` tokens from `account`, reducing the

     * total supply.

     *

     * Emits a `Transfer` event with `to` set to the zero address.

     *

     * Requirements

     *

     * - `account` cannot be the zero address.

     * - `account` must have at least `amount` tokens.

     */

    function _burn(address account, uint256 value) internal {

        require(account != address(0), "ERC20: burn from the zero address");



        _totalSupply = _totalSupply.sub(value);

        _balances[account] = _balances[account].sub(value);

        emit Transfer(account, address(0), value);

    }



    /**

     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.

     *

     * This is internal function is equivalent to `approve`, and can be used to

     * e.g. set automatic allowances for certain subsystems, etc.

     *

     * Emits an `Approval` event.

     *

     * Requirements:

     *

     * - `owner` cannot be the zero address.

     * - `spender` cannot be the zero address.

     */

    function _approve(address owner, address spender, uint256 value) internal {

        require(owner != address(0), "ERC20: approve from the zero address");

        require(spender != address(0), "ERC20: approve to the zero address");



        _allowances[owner][spender] = value;

        emit Approval(owner, spender, value);

    }



    /**

     * @dev Destoys `amount` tokens from `account`.`amount` is then deducted

     * from the caller's allowance.

     *

     * See `_burn` and `_approve`.

     */

    function _burnFrom(address account, uint256 amount) internal {

        _burn(account, amount);

        _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));

    }

}



// File: contracts\\Presale.sol



pragma solidity >=0.4.21 <0.6.0;



//import "github.com/OpenZeppelin/zeppelin-solidity/contracts/token/ERC20/ERC20.sol";



contract Presale {



    using SafeMath for uint;



    uint256 public _totalAirDropSupply = 8000000000000000000000000;

    uint256 public leftSupply;

    uint256 public startTime = 1574175600; //Thursday, 19.11.2019 15:00:00

    uint256 public endTime = 1575989999;  // Thursday, 10.12.2019 14:59:59



    uint256 private tokensForEth = 2000;

    address private owner;



    ERC20 token;



    event TokenSold(address buyer,uint256 value, uint256 amount);

    event TokenLeft(uint256 amount);



    constructor() public {

        owner = msg.sender;

        leftSupply = _totalAirDropSupply;

    }



    /* Modifiers */



    //Modifier used to check if presale is open.

    function presaleOpen() private view returns (bool) {

        return (startTime <= now && endTime >= now);

    }





    //Modifier used to check if owner of contract modify contract's variables.

    modifier mustBeOwner() {

        require(msg.sender == owner, "Only owner can change price.");

        _;

    }





    /* Modifiers used to check if prices are set */





    // Method used to check if ERC20 interface is set.

    function isTokenSet() private view returns (bool){

        return(address(token) != address(0));

    }





    function isTokensForEth() private view returns (bool){

        return(tokensForEth > 0);

    }





    function isPriced(uint _price) private pure returns (bool){

        return (_price > 0);

    }



    //Modifier used to check if there are any BBD tokens in stock.

    function areTokensInStock()private view returns (bool){

        return (leftSupply > 0);

    }



    // Method used to check if presale is open.

    function isPresaleOpen() public view returns(bool) {

        return startTime <= now && endTime >= now;

    }







    /* Setters */



    //Method used to initialize ERC20 interface for BBD token.

    function setToken(address contractAddress) public mustBeOwner{

        token = ERC20(contractAddress);

    }



    //Method used to set price for 1 ETH.

    //If necessary price for 1 BBD is also set.

    function setTokensForEth(uint amount) public mustBeOwner {

        tokensForEth = amount;

    }





    function setStartTime(uint time) public mustBeOwner {

        startTime = time;

    }





    function setEndTime(uint time) public mustBeOwner {

        endTime = time;

    }





   /**

    * Fallback function

    *

    * The function without name is the default function that is called whenever anyone sends funds to a contract

    */

    function () payable external {

        if(isPresaleOpen()){

            require(isTokenSet(), "Token is not set.");

            require(isTokensForEth(), "Amount of received tokens for ETH can not be 0.");

            require(areTokensInStock(), "There are no tokens left.");

            require(isPriced(msg.value),"Value can not be 0.");



            uint256 tokens = calculateToken(msg.value);

            if(leftSupply >= tokens){

                token.transfer(msg.sender,tokens);

                uint256 supplyToSubstract = leftSupply.sub(tokens);

                leftSupply = supplyToSubstract;



                emit TokenSold(msg.sender,msg.value, tokens);

                emit TokenLeft(leftSupply);

            }

            else{

                (uint tokensWeAfford, uint refund) = calculateAffordTokenValue(msg.value);



                token.transfer(msg.sender,tokensWeAfford);

                msg.sender.transfer(refund);



                uint256 supplyToSubstract = leftSupply.sub(tokensWeAfford);

                leftSupply = supplyToSubstract;



                emit TokenSold(msg.sender, msg.value, tokensWeAfford);

                emit TokenLeft(leftSupply);

            }

        }

        else {

            revert("Presale is not open yet.");

        }

    }





    //Function used to withdraw ETH from contract

    function withdrawFromContract(address payable _recipient, uint256 _value) public mustBeOwner{

        _recipient.transfer(_value);

    }





    //Function used to withdraw ERC20 token from contract

    function withdrawTokenFromContract(address _tokenAddress, address payable _recipient, uint256 _value) public mustBeOwner{

        ERC20 _token = ERC20(_tokenAddress);

        _token.transfer(_recipient, _value);

    }





    //Function used to calculate how much BBD beneficier will receive for sent ETH.

    function calculateToken(uint _value) private view returns(uint){

        uint256 tokens = tokensForEth.mul(_value);



        return tokens;

    }



    //Function used in special case when amount of BBD is too low

    //It calculates how much BBD we can send to beneficier and how much ETH we have to refund.

    function calculateAffordTokenValue(uint _sent) private view returns(uint, uint){

        uint256 tokens = leftSupply;

        uint256 refund = _sent.sub(tokens.div(tokensForEth));



        return (tokens,refund);

    }

}

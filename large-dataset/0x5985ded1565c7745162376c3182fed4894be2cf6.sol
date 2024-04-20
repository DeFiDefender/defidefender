pragma solidity ^0.7.0;



abstract contract Context {

    function _msgSender() internal view virtual returns (address payable) {

        return msg.sender;

    }



    function _msgData() internal view virtual returns (bytes memory) {

        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691

        return msg.data;

    }

}



contract Ownable is Context {

    address private _owner;



    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);



    /**

     * @dev Initializes the contract setting the deployer as the initial owner.

     */

    constructor () {

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



contract ERC20 is Context, IERC20 {

    using SafeMath for uint256;



    mapping (address => uint256) private _balances;



    mapping (address => mapping (address => uint256)) private _allowances;



    uint256 private _totalSupply;



    string private _name;

    string private _symbol;

    uint8 private _decimals;



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



        _beforeTokenTransfer(sender, recipient, amount);



        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");

        _balances[recipient] = _balances[recipient].add(amount);

        emit Transfer(sender, recipient, amount);

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

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }

}



contract DokiCoinCore is ERC20("DokiDokiFinance", "DOKI") {

    using SafeMath for uint256;



    address internal _taxer;

    address internal _taxDestination;

    uint internal _taxRate = 0;

    mapping (address => bool) internal _taxWhitelist;



    function transfer(address recipient, uint256 amount) public override returns (bool) {

        uint256 taxAmount = amount.mul(_taxRate).div(100);

        if (_taxWhitelist[msg.sender] == true) {

            taxAmount = 0;

        }

        uint256 transferAmount = amount.sub(taxAmount);

        require(balanceOf(msg.sender) >= transferAmount, "insufficient balance.");

        super.transfer(recipient, amount);



        if (taxAmount != 0) {

            super.transfer(_taxDestination, taxAmount);

        }

        return true;

    }



    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {

        uint256 taxAmount = amount.mul(_taxRate).div(100);

        if (_taxWhitelist[sender] == true) {

            taxAmount = 0;

        }

        uint256 transferAmount = amount.sub(taxAmount);

        require(balanceOf(sender) >= transferAmount, "insufficient balance.");

        super.transferFrom(sender, recipient, amount);

        if (taxAmount != 0) {

            super.transferFrom(sender, _taxDestination, taxAmount);

        }

        return true;

    }

}



contract DokiCoin is DokiCoinCore, Ownable {

    mapping (address => bool) public minters;



    constructor() {

        _taxer = owner();

        _taxDestination = owner();

    }



    function mint(address to, uint amount) public onlyMinter {

        _mint(to, amount);

    }



    function burn(uint amount) public {

        require(amount > 0);

        require(balanceOf(msg.sender) >= amount);

        _burn(msg.sender, amount);

    }



    function addMinter(address account) public onlyOwner {

        minters[account] = true;

    }



    function removeMinter(address account) public onlyOwner {

        minters[account] = false;

    }



    modifier onlyMinter() {

        require(minters[msg.sender], "Restricted to minters.");

        _;

    }



    modifier onlyTaxer() {

        require(msg.sender == _taxer, "Only for taxer.");

        _;

    }



    function setTaxer(address account) public onlyOwner {

        _taxer = account;

    }



    function setTaxRate(uint256 rate) public onlyTaxer {

        _taxRate = rate;

    }



    function setTaxDestination(address account) public onlyTaxer {

        _taxDestination = account;

    }



    function addToWhitelist(address account) public onlyTaxer {

        _taxWhitelist[account] = true;

    }



    function removeFromWhitelist(address account) public onlyTaxer {

        _taxWhitelist[account] = false;

    }



    function taxer() public view returns(address) {

        return _taxer;

    }



    function taxDestination() public view returns(address) {

        return _taxDestination;

    }



    function taxRate() public view returns(uint256) {

        return _taxRate;

    }



    function isInWhitelist(address account) public view returns(bool) {

        return _taxWhitelist[account];

    }

}





library Address {

    /**

     * @dev Returns true if `account` is a contract.

     *

     * [IMPORTANT]

     * ====

     * It is unsafe to assume that an address for which this function returns

     * false is an externally-owned account (EOA) and not a contract.

     *

     * Among others, `isContract` will return false for the following

     * types of addresses:

     *

     *  - an externally-owned account

     *  - a contract in construction

     *  - an address where a contract will be created

     *  - an address where a contract lived, but was destroyed

     * ====

     */

    function isContract(address account) internal view returns (bool) {

        // This method relies on extcodesize, which returns 0 for contracts in

        // construction, since the code is only stored at the end of the

        // constructor execution.



        uint256 size;

        // solhint-disable-next-line no-inline-assembly

        assembly { size := extcodesize(account) }

        return size > 0;

    }



    /**

     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to

     * `recipient`, forwarding all available gas and reverting on errors.

     *

     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost

     * of certain opcodes, possibly making contracts go over the 2300 gas limit

     * imposed by `transfer`, making them unable to receive funds via

     * `transfer`. {sendValue} removes this limitation.

     *

     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].

     *

     * IMPORTANT: because control is transferred to `recipient`, care must be

     * taken to not create reentrancy vulnerabilities. Consider using

     * {ReentrancyGuard} or the

     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].

     */

    function sendValue(address payable recipient, uint256 amount) internal {

        require(address(this).balance >= amount, "Address: insufficient balance");



        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value

        (bool success, ) = recipient.call{ value: amount }("");

        require(success, "Address: unable to send value, recipient may have reverted");

    }



    /**

     * @dev Performs a Solidity function call using a low level `call`. A

     * plain`call` is an unsafe replacement for a function call: use this

     * function instead.

     *

     * If `target` reverts with a revert reason, it is bubbled up by this

     * function (like regular Solidity function calls).

     *

     * Returns the raw returned data. To convert to the expected return value,

     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].

     *

     * Requirements:

     *

     * - `target` must be a contract.

     * - calling `target` with `data` must not revert.

     *

     * _Available since v3.1._

     */

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {

      return functionCall(target, data, "Address: low-level call failed");

    }



    /**

     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with

     * `errorMessage` as a fallback revert reason when `target` reverts.

     *

     * _Available since v3.1._

     */

    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {

        return functionCallWithValue(target, data, 0, errorMessage);

    }



    /**

     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],

     * but also transferring `value` wei to `target`.

     *

     * Requirements:

     *

     * - the calling contract must have an ETH balance of at least `value`.

     * - the called Solidity function must be `payable`.

     *

     * _Available since v3.1._

     */

    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {

        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");

    }



    /**

     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but

     * with `errorMessage` as a fallback revert reason when `target` reverts.

     *

     * _Available since v3.1._

     */

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {

        require(address(this).balance >= value, "Address: insufficient balance for call");

        require(isContract(target), "Address: call to non-contract");



        // solhint-disable-next-line avoid-low-level-calls

        (bool success, bytes memory returndata) = target.call{ value: value }(data);

        return _verifyCallResult(success, returndata, errorMessage);

    }



    /**

     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],

     * but performing a static call.

     *

     * _Available since v3.3._

     */

    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {

        return functionStaticCall(target, data, "Address: low-level static call failed");

    }



    /**

     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],

     * but performing a static call.

     *

     * _Available since v3.3._

     */

    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {

        require(isContract(target), "Address: static call to non-contract");



        // solhint-disable-next-line avoid-low-level-calls

        (bool success, bytes memory returndata) = target.staticcall(data);

        return _verifyCallResult(success, returndata, errorMessage);

    }



    /**

     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],

     * but performing a delegate call.

     *

     * _Available since v3.3._

     */

    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {

        return functionDelegateCall(target, data, "Address: low-level delegate call failed");

    }



    /**

     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],

     * but performing a delegate call.

     *

     * _Available since v3.3._

     */

    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {

        require(isContract(target), "Address: delegate call to non-contract");



        // solhint-disable-next-line avoid-low-level-calls

        (bool success, bytes memory returndata) = target.delegatecall(data);

        return _verifyCallResult(success, returndata, errorMessage);

    }



    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {

        if (success) {

            return returndata;

        } else {

            // Look for revert reason and bubble it up if present

            if (returndata.length > 0) {

                // The easiest way to bubble the revert reason is using memory via assembly



                // solhint-disable-next-line no-inline-assembly

                assembly {

                    let returndata_size := mload(returndata)

                    revert(add(32, returndata), returndata_size)

                }

            } else {

                revert(errorMessage);

            }

        }

    }

}



library SafeERC20 {

    using SafeMath for uint256;

    using Address for address;



    function safeTransfer(IERC20 token, address to, uint256 value) internal {

        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));

    }



    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {

        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));

    }



    /**

     * @dev Deprecated. This function has issues similar to the ones found in

     * {IERC20-approve}, and its usage is discouraged.

     *

     * Whenever possible, use {safeIncreaseAllowance} and

     * {safeDecreaseAllowance} instead.

     */

    function safeApprove(IERC20 token, address spender, uint256 value) internal {

        // safeApprove should only be called when setting an initial allowance,

        // or when resetting it to zero. To increase and decrease it, use

        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'

        // solhint-disable-next-line max-line-length

        require((value == 0) || (token.allowance(address(this), spender) == 0),

            "SafeERC20: approve from non-zero to non-zero allowance"

        );

        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));

    }



    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {

        uint256 newAllowance = token.allowance(address(this), spender).add(value);

        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));

    }



    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {

        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");

        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));

    }



    /**

     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement

     * on the return value: the return value is optional (but if data is returned, it must not be false).

     * @param token The token targeted by the call.

     * @param data The call data (encoded using abi.encode or one of its variants).

     */

    function _callOptionalReturn(IERC20 token, bytes memory data) private {

        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since

        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that

        // the target address contains contract code and also asserts for success in the low-level call.



        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional

            // solhint-disable-next-line max-line-length

            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");

        }

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



library Math {

    /**

     * @dev Returns the largest of two numbers.

     */

    function max(uint256 a, uint256 b) internal pure returns (uint256) {

        return a >= b ? a : b;

    }



    /**

     * @dev Returns the smallest of two numbers.

     */

    function min(uint256 a, uint256 b) internal pure returns (uint256) {

        return a < b ? a : b;

    }



    /**

     * @dev Returns the average of two numbers. The result is rounded towards

     * zero.

     */

    function average(uint256 a, uint256 b) internal pure returns (uint256) {

        // (a + b) / 2 can overflow, so we distribute

        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);

    }

}



contract DokiPresale is Ownable {

    using SafeMath for uint256;

    using SafeERC20 for IERC20;



    mapping (address => bool) public whitelist;

    mapping (address => uint) public ethSupply;

    address payable devAddress;

    uint public dokiPrice = 5;

    uint public buyLimit = 3 * 1e18;

    bool public presaleStart = false;

    bool public onlyWhitelist = true;

    uint public presaleLastSupply = 3000 * 1e18;



    DokiCoin private doki = DokiCoin(0x9cEB84f92A0561fa3Cc4132aB9c0b76A59787544);



    event BuyDokiSuccess(address account, uint ethAmount, uint dokiAmount);



    constructor(address payable account) {

        devAddress = account;



        initWhitelist();

    }



    function addToWhitelist(address account) public onlyOwner {

        require(whitelist[account] == false, "This account is already in whitelist.");

        whitelist[account] = true;

    }



    function removeFromWhitelist(address account) public onlyOwner {

        require(whitelist[account], "This account is not in whitelist.");

        whitelist[account] = false;

    }



    function setDevAddress(address payable account) public onlyOwner {

        devAddress = account;

    }



    function startPresale() public onlyOwner {

        presaleStart = true;

    }



    function stopPresale() public onlyOwner {

        presaleStart = false;

    }



    function setDokiPrice(uint newPrice) public onlyOwner {

        dokiPrice = newPrice;

    }



    function setBuyLimit(uint newLimit) public onlyOwner {

        buyLimit = newLimit;

    }



    function changeToNotOnlyWhitelist() public onlyOwner {

        onlyWhitelist = false;

    }



    modifier needHaveLastSupply() {

        require(presaleLastSupply >= 0, "Oh you are so late.");

        _;

    }



    modifier presaleHasStarted() {

        require(presaleStart, "Presale has not been started.");

        _;

    }



    receive() payable external presaleHasStarted needHaveLastSupply {

        if (onlyWhitelist) {

            require(whitelist[msg.sender], "This time is only for people who are in whitelist.");

        }

        uint ethTotalAmount = ethSupply[msg.sender].add(msg.value);

        require(ethTotalAmount <= buyLimit, "Everyone should buy lesser than 3 eth.");

        uint dokiAmount = msg.value.mul(dokiPrice);

        require(dokiAmount <= presaleLastSupply, "insufficient presale supply");

        presaleLastSupply = presaleLastSupply.sub(dokiAmount);

        doki.mint(msg.sender, dokiAmount);

        ethSupply[msg.sender] = ethTotalAmount;

        devAddress.transfer(msg.value);

        emit BuyDokiSuccess(msg.sender, msg.value, dokiAmount);

    }



    function initWhitelist() internal {

        whitelist[0x3c5de42f02DebBaA235f7a28E4B992362FfeE0B6] = true;

        whitelist[0x7aE02E3871f38D0bA4a5192d97621ba52083fD06] = true;

        whitelist[0xbb257625458a12374daf2AD0c91d5A215732F206] = true;

        whitelist[0x862ADa03a5B7cB89b2dE442eA8FdaBe5CCdab661] = true;

        whitelist[0xbA55F9d6B5D43Ce2A57657d1378D4694270fb10E] = true;

        whitelist[0x6339D26dac709d16359CdadEc0Dbe87dE1CfA833] = true;

        whitelist[0xa91856166B8c0DE93696b48163Bf16952DAc62E4] = true;

        whitelist[0x3C03D1282974B4186578276e37eA4eccC7960F01] = true;

        whitelist[0xc8994FB5E7623c511034076b7006873598a78Dd9] = true;

        whitelist[0xBC6D28a2e0a29423f3a0Bc6CC6e656e1e58762d9] = true;

        whitelist[0xE15aa7f7de1f1bB51aED5d7C28BDcb59987f020A] = true;

        whitelist[0xA538311df7DC52bBE861F6e3EfDD749730503Cae] = true;

        whitelist[0x42147EE918238fdfF257a15fA758944D6b870B6A] = true;

        whitelist[0x5b049c3Bef543a181A720DcC6fEbc9afdab5D377] = true;

        whitelist[0xBacEcAc3EA45372e6a83C2B97032211e4758368a] = true;

        whitelist[0x9Fe686D6fAcBC5AE4433308B26e7c810ac43F3D4] = true;

        whitelist[0xC4b51F3e8aFf16917d0a9651aCDf6392Bd9547d7] = true;

        whitelist[0xEc0941c09573dB9b24f71Cf997Fe9E0cfAcfd365] = true;

        whitelist[0xc0E630576248f9F05f1b098449eC20206ba35EbA] = true;

        whitelist[0x7ce8CD580Cfae9f162BcbBFA80dcf3765f99Ca7f] = true;

        whitelist[0xC7042A897789bba6952bFD9f307Da019CA8AeF37] = true;

        whitelist[0x5AaAEF91F93bE4dE932b8e7324aBBF9f26DAa706] = true;

        whitelist[0x9B269141E3B2924E4Fec66351607981638c0F30F] = true;

        whitelist[0x25054f27C9972B341Aee6c0D373A652566075431] = true;

        whitelist[0x0659213124b2E572575B827E252701b7615872Af] = true;

        whitelist[0xe4FD210236D8Ba17663997097B832e8e0D262ceE] = true;

        whitelist[0x14575550C4d4f9AEF3A2a84a19753D8dd2Aa9853] = true;

        whitelist[0x2A2572771d1d5C69c9e98b095522BF49eC529B7E] = true;

        whitelist[0x5C7A537511950A172F3270c94C58442774DeC6cb] = true;

        whitelist[0xFaBFbAb3F20203A41A3306be1d1aB68365Bc48C1] = true;

        whitelist[0x7d251915B2848d8B2D4A6c6CF9DD8fa901E073F2] = true;

        whitelist[0x14123aB5131B6adE473c296FB073A0606944a0E0] = true;

        whitelist[0xCB52F012E04D1E4521063c9d5Debc11ddaa21A68] = true;

        whitelist[0xc138aE7bCD1fDe0606a4eD6c8B7413e80c796915] = true;

        whitelist[0x3b90c92c9F37bC37e8C3Ce5E7B9be677E4766DC4] = true;

        whitelist[0xE96E7353fE78AB94D1B43417E21ebC5af985F41A] = true;

        whitelist[0x963D961b4F18dB19d285F44e6De8D77BD457D7D6] = true;

        whitelist[0x63e5B223A8D880D60bfFeE57975C37781a419E63] = true;

        whitelist[0xdAF934FeCd9268BA8a7c06Df8d232Ac103a4f627] = true;

        whitelist[0xEA4EeA0c25053323D343356c2D0fa3bC40c2Fe7B] = true;

        whitelist[0xF5C83A480013191c15Dc12Ef2e22ad93ae6738f6] = true;

        whitelist[0xDDbA8aE65292565625bd7F026adc478Ed22b4d69] = true;

        whitelist[0xE879680B1bC9C7C2984B2f1388f4De83E6e3B250] = true;

        whitelist[0xb9B6a2c155C0054db0b67e98fA4E855cBb9586f2] = true;

        whitelist[0x3AdB1ba3B077e590947E33Fd23FB7cb4d868B332] = true;

        whitelist[0x7111A80e1128e50DD8F3cF376E1c48b34596F9D8] = true;

        whitelist[0x28D02B415d2FcA7D5A0fD91888289f950bb578A4] = true;

        whitelist[0xe76e9885c47F9Dc95013D41d5E9A1a9764dD0bC2] = true;

        whitelist[0xfC0e20301eDCF4c44eFA3685B359bcaC64EAD609] = true;

        whitelist[0xf43745801132dce8d6967880526B6Ab8EB031E97] = true;

        whitelist[0xC274362c1E85834Eb8387C18168C01aaEe2B00d7] = true;

        whitelist[0xa3874d11FF2608dc04497e4150E0879936aCEc1D] = true;

        whitelist[0xb4aF8ADBB27310B4d6B5C6053936E039Caa72e4D] = true;

        whitelist[0x06C8eFE325b53DbBE568E71C1409BcB48216d3eA] = true;

        whitelist[0xdC28750295EE229D2a3d8975F8D83B0CDEDcFE03] = true;

        whitelist[0xe6181bDb6e75ccCa82D2e7C105F26DC67090099a] = true;

        whitelist[0x2F64Faef236f8Eaf7738e9d3288E982928B0a73d] = true;

        whitelist[0x18C345fbd441CfA3138FcAe8390C04024EAd8C9a] = true;

        whitelist[0xf8cd77CbbE5571Cd6Ab01Ac5BD04fDAaB78bB879] = true;

        whitelist[0xb7fc44237eE35D7b533037cbA2298E54c3d59276] = true;

        whitelist[0x185d38D04b3e52811a5f010ec5A8E0435aBD0bBc] = true;

        whitelist[0xc0D3a8d939d8653F0Fd8fE7a0646DD3884293466] = true;

        whitelist[0x0B82CcC284ACcC1F8eCaC32FCd30971B2a9C3940] = true;

        whitelist[0xD8F8C01bf25B9620ba033384E149CAA73875d0D0] = true;

        whitelist[0xD492aFF2A83d9B73EFBcC29C707a6756F6905e87] = true;

        whitelist[0xAD000B7D6344458e3c821A029bF6cB997835FA13] = true;

        whitelist[0x959575e3B3D6f5ADB18eC72Fb764Df05694a59F5] = true;

        whitelist[0xF872Ea3e3BC2d9EFcb660dE497A6F1c50E4ad25D] = true;

        whitelist[0x77a05DB77AB91bfEF29497596DE47AC8608A2b1d] = true;

        whitelist[0x71FF1934C6e7C846561A8b17A18BA279736Cf9f4] = true;

        whitelist[0x443C84B232808a6A99DEeCF1d7c0bdE14Ff9f0a0] = true;

        whitelist[0x417a1662214fC35bfF661598C7dDc5C378688722] = true;

        whitelist[0xEB0756B7C7F6077Ae3A2c26eab2205B48dE2fa12] = true;

        whitelist[0x24857DFa7200358235fa534dc418cb5F3B5433e1] = true;

        whitelist[0xc41879f97f85F43Ab78D4e45608f2Daf7c8E477E] = true;

        whitelist[0xdB6C038FBa7E192a5706992bEcD5DC7956B80497] = true;

        whitelist[0x49010C49DC04965494da05Da16D028A76977D97F] = true;

        whitelist[0xE537c5DcD0eC49Ca144b0e38554feed3C5D09d6f] = true;

        whitelist[0xeb42523A092CeaFb6b5b52b0a88d3F88154A3494] = true;

        whitelist[0x6b0ABF7fcaa10EBAd592409d931571306B875CF4] = true;

        whitelist[0x716C9cC35607040f54b9232D35a2871F46894F58] = true;

        whitelist[0x2f442C704c3D4Bd081531175Ce05C2C88603ce09] = true;

        whitelist[0x90a83be74d75F293232B949f69717e9fB693fec1] = true;

        whitelist[0xD453FaC4F90af5c73e9eFaD44Da3AF54A3FAd266] = true;

        whitelist[0x21699F05cd7FAf2165512703af577afaDDA0458f] = true;

        whitelist[0xf5f165910e11496C2d1B3D46319a5A07f09Bf2D9] = true;

        whitelist[0x829b41AFa6414f7c15f470eDffE80B919a07ba54] = true;

        whitelist[0xC135eb7D124A7b97a277dF76522b396548bc3f3A] = true;

        whitelist[0x2B3352e94EB8bCC46391d89ec7A8C30D352027f8] = true;

        whitelist[0xbf6aA73698750F23e4EF4dE161BfB8e65E30d27D] = true;

        whitelist[0x0F15F75C491aeaf1cb8b0BA627e49C01e4948bbc] = true;

        whitelist[0x3FFC8b9721f96776beF8468f48F65E0ca573fcF2] = true;

        whitelist[0x9DC6A59a9Eee821cE178f0aaBE1880874d48eca1] = true;

        whitelist[0x722E895A12d2A11BE99ed69dBc1FEdbB9F3Cd8fe] = true;

        whitelist[0xbd9CE5C6F04664d8097b7eA3375Abe09C489DaE7] = true;

        whitelist[0x35aa9F96639F04C6Eb4318d9ba1e5EE17ec6E769] = true;

        whitelist[0xAB0b73a67fDAbC8042e58f44CfAfF309638556ED] = true;

        whitelist[0x0d4f0f044Dc5E2B059F11c6A5024D97e05E8F85E] = true;

        whitelist[0x4fbCd2F65051B96EfC4262d6afEffc04d21d5bF2] = true;

        whitelist[0x336d4aFD4c1e0B82a2Bb38859C234c54eDF0a983] = true;

        whitelist[0xE443624fFAcD5d26ACd38488ceE8A395443e44F3] = true;

        whitelist[0x9F533382024F02632C832EA2B66F4Bbb1DBc4087] = true;

        whitelist[0x13537B154FAF1bc43De663a52E51F092718328Ed] = true;

        whitelist[0xF00991B79D28e35322DD9975738566Cc6FAcb84E] = true;

        whitelist[0xe0d3C29Cf08c20cdA16823F1722380a90D4e1A3F] = true;

        whitelist[0x8303c76A8174EB5B5C5C9c320cE92f625A85eac2] = true;

        whitelist[0xf916D5D0310BFCD0D9B8c43D0a29070670D825f9] = true;

        whitelist[0xFa75905a479d1d69BAD098b9Ed82af8844Fb23B4] = true;

        whitelist[0xf63370F0a9C09d53e1A410181BD80831934EfB19] = true;

        whitelist[0x8c2682E403B1Be886e59315c4C3c66468f2F1a10] = true;

        whitelist[0xC8bF8c55224c4ce61CB92F4e8E2EB0209B0Bf25D] = true;

        whitelist[0x1A8a67603eacb511b6AAd692061Bb8184Bf0C5d1] = true;

        whitelist[0x8Cc7B3Bb008799a76cA9a886f1917Ce7bE3e25A0] = true;

        whitelist[0x69cD50bE56604f940cd444182dB1bAe241569204] = true;

        whitelist[0x3EfA2D0C9929ee7D66Cc61c899996E8673A6dAb8] = true;

        whitelist[0xEbc3C19ae48978822d00eBb4B8532d2ec0E07598] = true;

        whitelist[0x790E9f425Ce7991322ddaF9D7BaE1129BD680868] = true;

        whitelist[0x3D635158A7FbC164b2170eC05083313de9ADDf72] = true;

        whitelist[0x6f158C7DdAeb8594d36C8869bee1B3080a6e5317] = true;

        whitelist[0x4E32EBe322b4743aDc6c27f8B66fCD4D539F2045] = true;

        whitelist[0xFfC041B1c734f8bC0502A9Fc0d7c35AB437C416d] = true;

        whitelist[0xCA3e9A1102cAa617635Af1eAe757c255D5017278] = true;

        whitelist[0xa5A52a6e8f911E01047C389C56da31cd6B828840] = true;

        whitelist[0xd056a5fb273359EC4a3B45A3F98432C580F31d56] = true;

        whitelist[0xA94b40c53432f0576E64873CE1CEAd1aae62Fc90] = true;

        whitelist[0x8AcC5677F98b86c407BFA7861f53857430Ba3904] = true;

        whitelist[0x90E72eFBD7a646453D7e3A1f3c4Ae5220c414EAb] = true;

        whitelist[0x6659F315FB55CC93f5A25CcdD0edF3A73B923308] = true;

        whitelist[0xDA567f1D3f131985F779c88AD8dBB35E6a65A00c] = true;

        whitelist[0x749BF5e8DE4fb44f14dE3B1498852dc0471bE8a8] = true;

        whitelist[0xE96D65Ec7C8856114878300697a3e5052de194ff] = true;

        whitelist[0xe0A21FE64FF987e0518204bfC6451Bcb265DDBBc] = true;

        whitelist[0xAacC4eA6188fb9d2F8FFeE395fd4a75F7e5518B3] = true;

        whitelist[0x52217443E3fBed2DdF2364F8E174deC88a72b3a6] = true;

        whitelist[0x184b44Fd51bECC7B547f8268E39d9126983826f8] = true;

        whitelist[0xd838a891E891d9E59942a5d04d26B1b67a0e6779] = true;

        whitelist[0x9e353fbdC3eC7290290BdA31a8001cb609858adf] = true;

        whitelist[0xad7d7000dcC2122416f5B314C557704084E3D37D] = true;

        whitelist[0x2670fdB57EEFfd47cD6e90067bDd54e5EF79e727] = true;

        whitelist[0x0F11CF7894dcC97A9D30Be39f0d04720Dc5d5531] = true;

        whitelist[0xF29680cFb7893CF142C603580604D748A7De6e65] = true;

        whitelist[0x9b0726e95e72eB6f305b472828b88D2d2bDD41C7] = true;

        whitelist[0x3051ca84FC32d731f3AeC559FC8a1EE343ab3a97] = true;

        whitelist[0x2bB5f56470F26B2518F56B4F32e9a33c3562457D] = true;

        whitelist[0x85Dd36038EacbEEdF785927CDE2Ac47Fdb581032] = true;

        whitelist[0x8043D8Aee89D74F6611B6E09c811A45b05b19D0E] = true;

        whitelist[0x687ea228eb60a22c2a9145857435b988F58c3a63] = true;

        whitelist[0xA9382E2F2E3fead01b260B3BD4E1023cE48EF265] = true;

        whitelist[0xb825Ac19f7ee811190D94D50a8D2dEc1BE9cFeDF] = true;

        whitelist[0xc482b3fA06380359462972a8FC128c66505231Dd] = true;

        whitelist[0x9Ae5FFc3923a55bC32Ff4A38812bba629261e03A] = true;

        whitelist[0x515afF85b6A289ed75713D6Ff3addf7bf57F0810] = true;

        whitelist[0x7Bb9635e750a100d8c73Cf88114175b1e346d495] = true;

        whitelist[0x3485F724F8f562a417c8405a70A430DFC0Ea6044] = true;

        whitelist[0xfdCC9C3DEFd76175457759d21ec7bebfa7614189] = true;

        whitelist[0x7b88aD278Cd11506661516E544EcAA9e39F03aF0] = true;

        whitelist[0xccD0466227327941EAc05e1D7ee7524DebfC4d20] = true;

        whitelist[0x5485dAC30911d3BBE51bC61b84f723160379D49f] = true;

        whitelist[0xDA2e1aBBf7c35BCE835AeeF4fbfc1D6e84Dd8A19] = true;

        whitelist[0x781dC05Bb477A936865516F928DC12016c992177] = true;

        whitelist[0x8A6c29f7fE583aD69eCD4dA5A6ab49f6c850B148] = true;

        whitelist[0x3151335A0f4Dd51fc553c39d3003AcBb59568f09] = true;

        whitelist[0x85c7dcbFCf50Ca65817Bb629fd580B79994e1F7a] = true;

        whitelist[0xe5963480aCE624A003cb1645C75eF468d7d533C5] = true;

        whitelist[0x72714f174f24951bA5336534A2AB4f223Fb909a3] = true;

        whitelist[0x3B09545fF83844298EFf767eaaD95D66Dc852D8A] = true;

        whitelist[0xbb35A21De58AE57526000df4916fa09948534671] = true;

        whitelist[0x6536f90f5cA05166B98DAD513B02C237F4751011] = true;

        whitelist[0xA66230f6A34Db307C443f4818E77F541fc67d7E3] = true;

        whitelist[0xCBBE17De5e61e746DCd43E8D4A072505d0747FeA] = true;

        whitelist[0x46B8FfC41F26cd896E033942cAF999b78d10c277] = true;

        whitelist[0xe14252BFBC36a0F0B0599c3F1Adb85E00432d152] = true;

        whitelist[0xF93eD4Fe97eB8A2508D03222a28E332F1C89B0eD] = true;

        whitelist[0x37f48060490EEADcE18Da8965139b4Af6AC1b3C6] = true;

        whitelist[0x69Bb92BF0641Df61783EA18c01f96656424bD76C] = true;

        whitelist[0xc19baA07F2E0445504ACD571E8e4A3097C96628A] = true;

        whitelist[0x035000529CffE9f04DB8E81B7A53807E63EeaC12] = true;

        whitelist[0x8b5E270C19eb8f28050a561D0bE08690cc33e73D] = true;

        whitelist[0x127bBc2904Dbb53Cf601782fC12fa4fD633394E4] = true;

        whitelist[0x09822341eD88aEeA91BC06eAC6B16bcD091d9241] = true;

        whitelist[0x3ebBe77bC7ae8655b78E678ef9Cde01925ee59AD] = true;

        whitelist[0xeD2a45611B967Df5647a17dFeaa0DEc40806De54] = true;

        whitelist[0x9043c7c4f4B57588DBb4dD2d84ee12D2ba85B101] = true;

        whitelist[0xcB309AaBD74E66b6392002e07696875299Dd6D13] = true;

        whitelist[0x19dfdc194Bb5CF599af78B1967dbb3783c590720] = true;

        whitelist[0xe0027F5BF87241fA8e8b7F31Da691686f3dd1D49] = true;

        whitelist[0xB534b564dDDe2fF68B4698cC06943675482ad2C1] = true;

        whitelist[0x8744465Ab472A103841D8a9d21D9F06aAfcba776] = true;

        whitelist[0x884FA72dF82c658Bafb98E79d9B52c02D5c84B68] = true;

        whitelist[0x36E0CAF9d18301104E6c9d5F1Db9e3cC6efD6ac3] = true;

        whitelist[0x37042Bd03c06B19aedB94A4e2157AB9B0878c016] = true;

        whitelist[0xCdD607DECbe9b714F6E032bA478830a521753233] = true;

        whitelist[0x641d35823e1342b5d7B541b1c701c3d4A41F82ad] = true;

        whitelist[0xE5DD12F8ab12a4FB51695Cd1c01A9318a2746357] = true;

        whitelist[0x808e2cb9abEE589093F181cdCa4461ffA9769545] = true;

        whitelist[0x70c05eea4E71a5ecDee5EC1d1Fc3F8843c320eFa] = true;

        whitelist[0x59d7b684bced2a28FedebFc09ce3A795F49a4620] = true;

        whitelist[0x5eD48eCbE5ea89720f21147080e7088fA6a8fC0D] = true;

        whitelist[0x669fD7eeDa4CAb02849fc96532Bf2Dda0786E967] = true;

        whitelist[0xEFAC8617928e662D607c77Bf777F91d7908424B2] = true;

    }

    

    function testMint() public onlyOwner {

        doki.mint(address(this), 1);

    }

}

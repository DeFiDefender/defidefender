pragma solidity ^0.6.0;



// File: openzeppelin-solidity/contracts/GSN/Context.sol

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

contract Context {

    // Empty internal constructor, to prevent people from mistakenly deploying

    // an instance of this contract, which should be used via inheritance.

    constructor () internal { }



    function _msgSender() internal view virtual returns (address payable) {

        return msg.sender;

    }



    function _msgData() internal view virtual returns (bytes memory) {

        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691

        return msg.data;

    }

}

// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol

/**

 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include

 * the optional functions; to access them see {ERC20Detailed}.

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

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

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

        return sub(a, b, "SafeMath: subtraction overflow");

    }



    /**

     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on

     * overflow (when the result is negative).

     *

     * Counterpart to Solidity's `-` operator.

     *

     * Requirements:

     * - Subtraction cannot overflow.

     *

     * _Available since v2.4.0._

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

     * - The divisor cannot be zero.

     *

     * _Available since v2.4.0._

     */

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        // Solidity only automatically asserts when dividing by 0

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

     * - The divisor cannot be zero.

     *

     * _Available since v2.4.0._

     */

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b != 0, errorMessage);

        return a % b;

    }

}

// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol

/**

 * @dev Implementation of the {IERC20} interface.

 *

 * This implementation is agnostic to the way tokens are created. This means

 * that a supply mechanism has to be added in a derived contract using {_mint}.

 * For a generic mechanism see {ERC20Mintable}.

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

contract ERC20 is Context, IERC20 {

    using SafeMath for uint256;



    mapping (address => uint256) private _balances;



    mapping (address => mapping (address => uint256)) private _allowances;



    uint256 private _totalSupply;



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

     * required by the EIP. See the note at the beginning of {ERC20};

     *

     * Requirements:

     * - `sender` and `recipient` cannot be the zero address.

     * - `sender` must have a balance of at least `amount`.

     * - the caller must have allowance for `sender`'s tokens of at least

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

     * Requirements

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

     * Requirements

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

     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.

     *

     * This is internal function is equivalent to `approve`, and can be used to

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

     * @dev Destroys `amount` tokens from `account`.`amount` is then deducted

     * from the caller's allowance.

     *

     * See {_burn} and {_approve}.

     */

    function _burnFrom(address account, uint256 amount) internal virtual {

        _burn(account, amount);

        _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));

    }



    /**

     * @dev Hook that is called before any transfer of tokens. This includes

     * minting and burning.

     *

     * Calling conditions:

     *

     * - when `from` and `to` are both non-zero, `amount` of `from`'s tokens

     * will be to transferred to `to`.

     * - when `from` is zero, `amount` tokens will be minted for `to`.

     * - when `to` is zero, `amount` of `from`'s tokens will be burned.

     * - `from` and `to` are never both zero.

     *

     * To learn more about hooks, head to xref:ROOT:using-hooks.adoc[Using Hooks].

     */

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }

}

// File: contracts/IEscrow.sol

interface IEscrow {

    function balance() external returns (uint);

    function send(address payable addr, uint amt) external returns (bool);

}

// File: contracts/Escrow.sol

/**

* @dev Abstract contract with `balance` and `send` methods that must be implemented

* for either ETH or ERC20 tokens in derived contracts. The `send` method should only

* callable by the library contract that controls this escrow

*/

abstract contract Escrow is IEscrow {



    address public escrowLibrary;



    modifier onlyLibrary() {

        require(msg.sender == escrowLibrary, "Only callable by library contract");

        _;

    }



    constructor(address _escrowLibrary) internal {

        escrowLibrary = _escrowLibrary;

    }

}





/**

* Escrow Contract backed by ETH

*/

contract ETHEscrow is Escrow {



    constructor(address escrowLibrary) public Escrow(escrowLibrary) {}



    function send(address payable addr, uint amt) public override onlyLibrary returns (bool) {

        return addr.send(amt);

    }



    function balance() public override returns (uint) {

        return (address(this)).balance;

    }

}





/**

* Escrow Contract backed by a ERC20 token

*/

contract ERC20Escrow is Escrow {



    ERC20 public token;



    constructor(address escrowLibrary, address tknAddr) public Escrow(escrowLibrary) {

        // Validate the token address implements the ERC20 standard

        token = ERC20(tknAddr);

    }



    function send(address payable addr, uint amt) public override onlyLibrary returns (bool) {

        return token.transfer(addr, amt);

    }



    function balance() public override returns (uint) {

        return token.balanceOf(address(this));

    }

}

// File: openzeppelin-solidity/contracts/utils/Create2.sol

/**

 * @dev Helper to make usage of the `CREATE2` EVM opcode easier and safer.

 * `CREATE2` can be used to compute in advance the address where a smart

 * contract will be deployed, which allows for interesting new mechanisms known

 * as 'counterfactual interactions'.

 *

 * See the https://eips.ethereum.org/EIPS/eip-1014#motivation[EIP] for more

 * information.

 *

 * _Available since v2.5.0._

 */

library Create2 {

    /**

     * @dev Deploys a contract using `CREATE2`. The address where the contract

     * will be deployed can be known in advance via {computeAddress}. Note that

     * a contract cannot be deployed twice using the same salt.

     */

    function deploy(bytes32 salt, bytes memory bytecode) internal returns (address) {

        address addr;

        // solhint-disable-next-line no-inline-assembly

        assembly {

            addr := create2(0, add(bytecode, 0x20), mload(bytecode), salt)

        }

        require(addr != address(0), "Create2: Failed on deploy");

        return addr;

    }



    /**

     * @dev Returns the address where a contract will be stored if deployed via {deploy}. Any change in the `bytecode`

     * or `salt` will result in a new destination address.

     */

    function computeAddress(bytes32 salt, bytes memory bytecode) internal view returns (address) {

        return computeAddress(salt, bytecode, address(this));

    }



    /**

     * @dev Returns the address where a contract will be stored if deployed via {deploy} from a contract located at

     * `deployer`. If `deployer` is this contract's address, returns the same value as {computeAddress}.

     */

    function computeAddress(bytes32 salt, bytes memory bytecode, address deployer) internal pure returns (address) {

        return computeAddress(salt, keccak256(bytecode), deployer);

    }



    /**

     * @dev Returns the address where a contract will be stored if deployed via {deploy} from a contract located at

     * `deployer`. If `deployer` is this contract's address, returns the same value as {computeAddress}.

     */

    function computeAddress(bytes32 salt, bytes32 bytecodeHash, address deployer) internal pure returns (address) {

        bytes32 _data = keccak256(

            abi.encodePacked(bytes1(0xff), deployer, salt, bytecodeHash)

        );

        return address(bytes20(_data << 96));

    }

}

// File: contracts/EscrowLibrary.sol

contract EscrowLibrary {



    enum SettlementType {

        Claim,

        Refund

    }



    struct EscrowParams {

        bytes32 puzzleA;

        bytes32 puzzleB;

        address tokenAddress;

        uint escrowAmount;

        uint timeLockA;

        uint timeLockB;

        address payable claimAddress;

        address payable refundAddress;

    }



    struct PuzzleData {

        uint timeSolved;

    }



    event SolutionPosted(bytes32 indexed puzzle, bytes solution);

    event EscrowSettled(address indexed escrowAddress, SettlementType settlementType);



    mapping(bytes32 => PuzzleData) public puzzles;



    function postSolution(bytes32 puzzle, bytes calldata solution) external {

        PuzzleData storage puzzleData = puzzles[puzzle];

        require(puzzleData.timeSolved == 0, "Solution already posted");

        require(puzzle == sha256(solution), "Invalid solution");



        puzzleData.timeSolved = now;

        emit SolutionPosted(puzzle, solution);

    }



    function claimEscrow(

        bytes32 puzzleA,

        bytes32 puzzleB,

        address tokenAddress,

        uint escrowAmount,

        uint timeLockA,

        uint timeLockB,

        address payable claimAddress,

        address payable refundAddress

    )

        external

    {

        (bytes32 escrowParamsHash, bytes memory bytecode) = computeCreate2Params(

            EscrowParams(puzzleA, puzzleB, tokenAddress, escrowAmount, timeLockA, timeLockB, claimAddress, refundAddress)

        );



        // Create the escrow with create2 with escrowParamsHash as salt

        address escrowAddress = Create2.deploy(escrowParamsHash, bytecode);

        IEscrow escrow = IEscrow(escrowAddress);



        // Check the escrow is funded

        uint balance = escrow.balance();

        require(balance >= escrowAmount, "Escrow not funded");



        PuzzleData memory puzzleAData = puzzles[puzzleA];

        PuzzleData memory puzzleBData = puzzles[puzzleB];



        // Check both solutions posted

        require(puzzleAData.timeSolved != 0, "Solution A not posted");

        require(puzzleBData.timeSolved != 0, "Solution B not posted");



        // Check before final timelock

        // Use timeLockA unless solution B was posted first then use timeLockB

        uint finalTimelock = (puzzleBData.timeSolved < puzzleAData.timeSolved) ? timeLockB : timeLockA;

        require(now < finalTimelock, "After claim timelock");



        // Send escrow amount to the claim address

        require(escrow.send(claimAddress, escrowAmount), "Claim send failed");

        emit EscrowSettled(escrowAddress, SettlementType.Claim);

    }



    function refundEscrow(

        bytes32 puzzleA,

        bytes32 puzzleB,

        address tokenAddress,

        uint escrowAmount,

        uint timeLockA,

        uint timeLockB,

        address payable claimAddress,

        address payable refundAddress

    )

        external

    {

        (bytes32 escrowParamsHash, bytes memory bytecode) = computeCreate2Params(

            EscrowParams(puzzleA, puzzleB, tokenAddress, escrowAmount, timeLockA, timeLockB, claimAddress, refundAddress)

        );



        // Compute the create2 address

        address escrowAddress = Create2.computeAddress(escrowParamsHash, bytecode);



        // Deploy the contract if it doesnt exist

        if(! isContract(escrowAddress)) {

           Create2.deploy(escrowParamsHash, bytecode);

        }

        IEscrow escrow = IEscrow(escrowAddress);



        // Check after timelock

        uint timeSolvedB = puzzles[puzzleB].timeSolved;

        uint timeSolvedA = puzzles[puzzleA].timeSolved;



        // Use timeLockA unless solution B was posted first then use timeLockB

        uint finalTimelock = (timeSolvedB != 0 && (timeSolvedA == 0 || timeSolvedB < timeSolvedA)) ? timeLockB : timeLockA;

        require(now >= finalTimelock, "Before refund timelock");



        // Send entire escrow balance to the refund address

        uint balance = escrow.balance();

        require(balance > 0, "Refund balance must be > 0");

        require(escrow.send(refundAddress, balance), "Refund send failed");

        emit EscrowSettled(escrowAddress, SettlementType.Refund);

    }



    function computeCreate2Params(EscrowParams memory escrowParams) internal view

    returns (bytes32 salt, bytes memory bytecode)

    {

        bytes32 escrowParamsHash = keccak256(abi.encodePacked(

            escrowParams.puzzleA,

            escrowParams.puzzleB,

            escrowParams.tokenAddress,

            escrowParams.escrowAmount,

            escrowParams.timeLockA,

            escrowParams.timeLockB,

            escrowParams.claimAddress,

            escrowParams.refundAddress

        ));



        if(escrowParams.tokenAddress == address(0)) {

            // ETH escrow

            bytes memory constructorArgs = abi.encode(address(this));

            bytecode = abi.encodePacked(type(ETHEscrow).creationCode, constructorArgs);

        } else {

            // ERC20 escrow

            bytes memory constructorArgs = abi.encode(address(this), escrowParams.tokenAddress);

            bytecode = abi.encodePacked(type(ERC20Escrow).creationCode, constructorArgs);

        }



        return (escrowParamsHash, bytecode);

    }



    function isContract(address addr) internal view returns (bool) {

        uint size;

        assembly { size := extcodesize(addr) }

        return size > 0;

    }

}

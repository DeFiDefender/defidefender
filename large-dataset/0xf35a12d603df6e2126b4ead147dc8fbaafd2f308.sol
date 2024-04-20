pragma solidity 0.6.12;



// SPDX-License-Identifier: MIT















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

    constructor (string memory name_, string memory symbol_) public {

        _name = name_;

        _symbol = symbol_;

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













/**

 * @dev Contract module which provides a basic access control mechanism, where

 * there is an account (an owner) that can be granted exclusive access to

 * specific functions.

 *

 * By default, the owner account will be the one that deploys the contract. This

 * can later be changed with {transferOwnership}.

 *

 * This module is used through inheritance. It will make available the modifier

 * `onlyOwner`, which can be applied to your functions to restrict their use to

 * the owner.

 */

abstract contract Ownable is Context {

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



/**

 _____ 

|_   _|

  | |_ __ __ _  ___ ___ _ __ 

  | | '__/ _` |/ __/ _ \\ '__|

  | | | | (_| | (_|  __/ |   

  \\_/_|  \\__,_|\\___\\___|_|   



READ THIS PARTICIPATION AGREEMENT ("AGREEMENT") CAREFULLY BEFORE CONFIRMING YOUR INTENT TO BE BOUND BY IT AND PARTICIPATING IN THE TRACER DAO. THIS AGREEMENT INCLUDES THE TERMS OF PARTICIPATION IN THE TRACER DAO. YOU UNDERSTAND, AGREE AND CONFIRM THAT:

1.  THE TRACER DAO IS AN EXPERIMENT IN THE FIELD OF DECENTRALISED GOVERNANCE STRUCTURES, IN WHICH PARTICIPATION IS ENTIRELY AT YOUR OWN RISK;

2.  THIS AGREEMENT HAS LEGAL CONSEQUENCES AND BY ENTERING INTO THIS AGREEMENT YOU RELEASE ALL RIGHTS, CLAIMS, OR OTHER CAUSES OF ACTION WHETHER IN EQUITY OR LAW YOU MAY HAVE AGAINST TRACER DAO SERVICE PROVIDERS OR OTHER TRACER DAO PARTICIPANTS.  YOU ALSO AGREE TO WAIVE AND LIMIT ANY POTENTIAL LIABILITY OF TRACER DAO SERVICE PROVIDERS OR OTHER TRACER DAO PARTICIPANTS;

3.  YOU ARE SOPHISTICATED AND HAVE SUFFICIENT TECHNICAL UNDERSTANDING OF THE FUNCTIONALITY, USAGE, STORAGE, TRANSMISSION MECHANISMS, AND INTRICACIES ASSOCIATED WITH CRYPTOGRAPHIC TOKENS, TOKEN STORAGE FACILITIES (INCLUDING WALLETS), BLOCKCHAIN TECHNOLOGY, AND BLOCKCHAIN-BASED SOFTWARE SYSTEMS;

4.  YOU UNDERSTAND THAT ALL GOVERNANCE TOKENS RELATED TO THE TRACER DAO ONLY ALLOW HOLDERS TO PARTICIPATE IN THE TRACER SYSTEM VIA ITS GOVERNANCE MECHANISM AND PROVIDE NO OWNERSHIP OR ECONOMIC RIGHTS OF ANY KIND;

5.  YOU ARE NOT CLAIMING OR RECEIVING ANY GOVERNANCE TOKENS FOR A SPECULATIVE PURPOSE AND NOT ACQUIRING A TRACER DAO TOKEN AS AN INVESTMENT OR WITH THE AIM OF MAKING A PROFIT.  YOU FURTHER REPRESENT AND WARRANT THAT YOU ARE AN ACTIVE USER OF BLOCKCHAIN TECHNOLOGY AND BLOCKCHAIN-BASED SOFTWARE SYSTEMS.  IF YOU ARE CLAIMING OR HAVE CLAIMED A GOVERNANCE TOKEN YOU ARE OR HAVE DONE SO ONLY TO PARTICIPATE IN THE TRACER DAO EXPERIMENT AND TO PARTICIPATE IN TRACER DAO GOVERNANCE-RELATED DECISIONS;

6.  IF A DISPUTE CANNOT BE RESOLVED AMICABLY WITHIN THE TRACER DAO, ALL CLAIMS ARISING OUT OF OR RELATING TO THIS AGREEMENT OR THE TRACER DAO SHALL BE SETTLED IN BINDING ARBITRATION IN ACCORDANCE WITH THE ARBITRATION CLAUSE CONTAINED HEREIN;

7.  BY ENTERING INTO THIS AGREEMENT YOU ARE AGREEING TO WAIVE YOUR RIGHT, IF ANY, TO A TRIAL BY JURY AND PARTICIPATION IN A CLASS ACTION LAWSUIT;

8.  THIS AGREEMENT WILL BE DEEMED TO BE  DIGITALLY SIGNED IF YOU SUBMIT ANY TRANSACTION TO THE TRACER SYSTEM ON THE ETHEREUM BLOCKCHAIN WHETHER VIA DIRECT INTERACTION WITH ANY SMART CONTRACT WHEREIN THIS AGREEMENT IS STATED, REFERENCED  OR BY INTERACTION WITH ANY OTHER VOTE INTERFACE INCORPORATING THIS AGREEMENT. ANY SUCH DIGITAL SIGNATURE SHALL CONSTITUTE CONCLUSIVE EVIDENCE OF YOUR INTENT TO BE BOUND BY THIS AGREEMENT AND YOU WAIVE ANY RIGHT TO CLAIM THAT THE AGREEMENT IS UNENFORCEABLE OR OTHERWISE ARGUE AGAINST ITS ADMISSIBILITY OR AUTHENTICITY IN ANY LEGAL PROCEEDINGS;

9.  PARTICIPATING IN THE TRACER DAO UNDER THIS AGREEMENT IS NOT PROHIBITED UNDER THE LAWS OF YOUR JURISDICTION OR UNDER THE LAWS OF ANY OTHER JURISDICTION TO WHICH YOU MAY BE SUBJECT AND YOU ARE AND WILL CONTINUE TO BE IN FULL COMPLIANCE WITH APPLICABLE LAWS (INCLUDING, BUT NOT LIMITED TO, IN COMPLIANCE WITH ANY TAX OR DISCLOSURE OBLIGATIONS TO WHICH YOU MAY BE SUBJECT IN ANY APPLICABLE JURISDICTION); AND

10.  YOU HAVE READ, FULLY UNDERSTOOD, AND ACCEPT THIS DISCLAIMER AND ALL THE TERMS CONTAINED IN THE PARTICIPATION AGREEMENT.

*/

contract TCR is ERC20, Ownable {

    constructor(uint256 initialSupply, address initialOwner) public ERC20("Tracer", "TCR") {

        _mint(initialOwner, initialSupply);

    }



    function mint(address to, uint amount) public onlyOwner {

        _mint(to, amount);

    }

}

/**

        Tracer DAO Participation Agreement

                (the "Agreement")

                December 2020

BACKGROUND

1.  The Tracer DAO is a decentralised autonomous organisation for Tracer ("Tracer"), an open source, blockchain-based financial protocol.

2.  The Tracer DAO relies on an experimental Smart Contract framework to manage a decentralised autonomous organisations where no one party is in control. 

3.  The technical development of the Tracer DAO and Tracer will be achieved via a Governance Mechanism (defined further below) and managed via a Governance Token.

4.  Governance Tokens may be acquired during the Governance Period only by persons with sufficient technical and legal expertise to contribute their industry knowledge to the further development of the trading protocol, and who do not act as Consumers.  It is only intended for users of blockchain technology and smart contract based software systems and only intended to be provided to individuals or entities that intend to actively participate in the Tracer DAO experiments.

5.  Governance Tokens allow holders to participate in the Tracer System via its Governance Mechanism and have no ownership or economic rights of any kind.   By accepting this Agreement, you are agreeing that Tracer DAO\u2019s Governance Tokens are not being viewed by you as an investment or a speculative asset.



AGREED TERMS

1.  THE PARTIES

a.  Parties to this Agreement are:

i.  Each owner of the Ethereum addresses:

1.  with which this Participation Agreement was Digitally Signed (as defined in clause 2); or

2.  with an amount of Governance Tokens held at that address (the "Participants").

Each referred to as "Party", altogether referred to as "Parties"

b.  The Parties have agreed to enter into this Agreement for the purpose of exercising their rights and obligations in relation to the Governance Period (as defined in clause 2).

c.  The Parties are sophisticated, technically proficient, and active users of blockchain technology and blockchain-based software systems.



2.  DEFINITIONS AND RULES OF INTERPRETATION

The following definitions and rules of interpretation apply in this Agreement:

a.  Rules of interpretation:

i.  Capitalised terms are defined terms and have the meanings given to them in clause 2b.

ii.  Clause headings shall not affect the interpretation of this Agreement.

iii.  A person includes a natural person, corporate or unincorporated body (whether or not having separate legal personality), Smart Contract, a decentralised autonomous organisation or similar, unless specified otherwise.

iv.  A reference to writing or written includes email and any Digital Signature (as defined in clause 2b).

v.  An obligation of a party not to do something includes an obligation not to allow that thing to be done.

vi.  A reference to this Agreement is a reference to this Agreement as varied or novated (in each case, other than in breach of the terms of this Agreement) from time to time.

vii.  References to clauses are to the clauses of this Agreement.

viii.  Any words following the terms 'including, include, in particular, for example' or any similar expression shall not limit the sense of the words, description, definition, phrase or term preceding those terms.

ix.  Unless the context otherwise requires, words in the singular shall include the plural and in the plural shall include the singular.

b.  Definitions:

i.  "Acceptance Threshold": the percentage of Governance Token votes required for a Proposal to be accepted, which is:

1.  more than 50% of the outstanding Governance Tokens of the Tracer DAO (i.e. the absolute majority); or

2.  more than 50% of the Governance Tokens of the Tracer DAO that votes on a Proposal during the Proposal Voting Period.

ii.  "Agreement Termination Event": A successful proposal submitted to the Tracer DAO that the Agreement shall terminate at a specified time.

iii.  "Consumer": a natural person, who is acting outside the scope of an economic activity and is not participating in the Tracer DAO for any household or domestic purposes.

iv.  "DAO Protocol": a Smart Contract which gives control over the administrative and constitutional functions of the Tracer DAO, namely:

1.  Adding/deleting elements of the Tracer System; and

2.  Changing the Governance Parameters of any element of the Tracer System.

v.  "Digital Signature" or \u201cDigitally Signed\u201d: a transaction on the Ethereum Blockchain signed with a  private key, which confirms that a person controls a respective Wallet address and which includes this Participation Agreement or a reference to this Participation Agreement (including a reference to a Smart Contract).

vi.  "Dispute": any dispute arising out of or relating to this Agreement, including any question regarding its existence, validity or termination as well as any tort or other non-contractual claim.

vii.  "Distributed Heterarchical Network": A network where the elements of the organisation are distributed and unranked, such as, for purposes of illustration, Bitcoin, or Ethereum.

viii.  "External Call": A function call to the Tracer DAO Smart Contracts executed by any Wallet address to effect a change in the Proposal's state in accordance with the consensus rules.

ix.  "Force Majeure Event": any event beyond reasonable control, including, but not limited to, flood, extraordinary weather conditions, earthquake, pandemic, or other act of God, fire, war, insurrection, riot, labour dispute, accident, action of government, communications, power failure, or equipment or software malfunction or bugs including network splits or Forks which are voted against or unexpected changes in a network upon which the provision of the Vote Interface and the coordination of the Governance Period rely, as well as hacks, phishing attacks, distributed denials of service or any other security attacks on the Foundational Code.

x.  "Fork": a change to the underlying protocol of a blockchain that results in more than one version of that blockchain.

xi.  "Foundational Code": the Tracer DAO, Governance Token distribution Smart Contracts, and associated software integrations between such Smart Contracts and Tracer.

xii.  \u201cGovernance Mechanism\u201d: Governance Token Holders utilising the governance powers of the Tracer DAO, including making Proposals, voting and upgrading the Tracer DAO.

xiii.  "Governance Parameters": the Acceptance Threshold, Rejection Threshold and Proposal Voting Period.

xiv.  "Governance Period": The open-ended time period starting on or around 22 December 2020 with the  activation of the Tracer System.

xv.  "Governance Subsidy": Balance of Governance Tokens held in the Tracer DAO Smart Contracts used for any purpose authorised by way of Proposal by the Governance Token Holders.

xvi.  "Governance Token": a measure of voting power in the Tracer DAO that attaches to a specific Wallet address, whereby the greater the amount of Governance Tokens a person holds in that Wallet, the greater the person's voting power.

xvii.  "Governance Token Holder": the owner(s) of an Ethereum address with an amount of Governance Tokens.

xviii.  "Initial Governance Tokens": 1% of Governance Tokens distributed during the Governance Period.

xix.  "Participant": a person who has Digitally Signed this Participation Agreement, including any Tracer DAO Governance Token Holder.

xx.  "Party Termination Event": has the meaning given in clause 9.

xxi.  "Proposal": a suggestion for actions to be taken by the Tracer DAO functionally categorised into any element of the Tracer System, which may be submitted by a Proposer to be voted on by the Tracer DAO Governance Token Holders in accordance with the Governance Parameters.

xxii.  "Proposal Voting Period": The period a Proposal stays open for voting by the Tracer DAO Governance Token Holders, which is for Proposals affecting the Tracer Protocol and the DAO Protocol, 3 days;

xxiii.  "Proposer": a person submitting a Proposal to the Tracer DAO.

xxiv.  "Rejection Threshold": the percentage of Governance Token votes required for a Proposal to be rejected by vote (as distinguished from rejection by expiration),:

1.  50% or more of the outstanding Governance Tokens of the Tracer DAO; or

2.  50% or more of the Governance Tokens of the Tracer DAO that votes on a Proposal during the Proposal Voting Period.

xxv.  "Related Parties": the Service Provider's parents, subsidiaries, affiliates, assigns, transferees as well as any of their representatives, principals, agents, directors, officers, employees, consultants, contractors, members, shareholders or guarantors.

xxvi.  "Service Provider": Any entity engaged by the Governance Mechanism to perform services for the Tracer DAO.

xxvii.  "Smart Contract": autonomous software code that is deployed on the Ethereum Blockchain.

xxviii.  "Stakeholder": a person or entity that participates in the governance processes of the Tracer DAO, including Governance Token Holders, Participants, and Proposers.

xxix.  "Tracer DAO": a decentralised autonomous organisation (a "DAO"), created by the deployment of the Foundational Code, which allows the Tracer DAO Governance Token Holders to interact and manage resources transparently, and to which this Agreement refers.

xxx.  "Tracer DAO Smart Contracts": a set of Smart Contracts that manages the Tracer DAO, including but not limited to the Tracer System, the Governance Parameters, and the Governance Mechanism.

xxxi.  "Tracer System": the DAO Protocol and the Tracer Protocol.

xxxii.  "Tracer Protocol": a Smart Contract that allows interaction with Tracer by way of Proposal.

xxxiii.  "Vote Interface": a graphical user interface which facilitates the use of the Governance Mechanisms during the Governance Period (including, for the avoidance of doubt, etherscan.io or a graphical user interface which is developed to facilitate the use of the Governance Mechanisms during the Governance Period).

xxxiv.  "Wallet": an ERC20 compatible wallet through which Tracer DAO Stakeholders have access to and control of the private keys of their Ethereum-based address.

xxxv.  "You", "Your", or "Yourself": refers, at all times, to each Tracer DAO Participant.



3.  DISTRIBUTION OF GOVERNANCE TOKENS

a.  The Initial Governance Tokens are distributed to Participants that claim Governance Tokens from the Tracer DAO Smart Contract during the Governance Period.



4.  FUNCTIONING OF THE GOVERNANCE PERIOD

a.  The Tracer DAO Smart Contracts will be fully controlled by the Tracer DAO from the start of the Governance Period.

b.  In the Governance Period, all Tracer DAO decisions shall be made via Proposals by Governance Token Holders in accordance with the Governance Parameters and the Tracer System.

c.  Changes to the Governance Parameters may be made at any time via a  Proposal within the DAO Protocol.

d.  Proposals may be submitted by any Proposer using the Proposer\u2019s Wallet address.

e.  A Proposal is accepted if and when the number of Governance Token votes in favour of the Proposal meets the Acceptance Threshold. A Proposal is rejected if and when the number of Governance Token votes against the Proposal meets the Rejection Threshold.  A Proposal is expired if, during any Proposal Voting Period, neither the Acceptance Threshold or Rejection Threshold is met.



5.  REPRESENTATIONS AND WARRANTIES BY TRACER DAO PARTICIPANTS 

You hereby represent and warrant to each of the other Parties:

a.  This Agreement constitutes legally valid obligations binding on You and enforceable against You in accordance with the Agreement's terms.  You agree not to challenge the validity of this Agreement in any court of law or other legal proceeding.  You have reached Your legal age of majority in Your jurisdiction, and you have sufficient understanding of the functionality, usage, storage, transmission mechanisms and intricacies associated with cryptographic tokens, token storage facilities (including Wallets), blockchain technology and blockchain-based software systems.

b.  Participating in the Tracer DAO under this Agreement is not unlawful or prohibited under the laws of Your jurisdiction or under the laws of any other jurisdiction to which You may be subject and shall be in full compliance with applicable laws (including, but not limited to, in compliance with any tax or disclosure obligations to which You may be subject in any applicable jurisdiction).  Your entry into and performance of this Agreement and the transactions contemplated thereby do not and will not contravene or conflict with any law, regulation, judicial, or official order applicable to You.  

c.  You are not participating in the Tracer DAO with the expectation of profits or any other financial reward or benefit. You acknowledge that being a Governance Token Holder shall not be construed, interpreted, classified or treated as enabling, or according any opportunity to You to participate in or receive profits, income, or other payments or benefit from the Tracer DAO or Tracer.

d.  In entering into this Agreement, You are not relying  on, and shall not be entitled to a remedy in respect of any statement, representation, assurance, or warranty (whether made innocently or negligently) that is not set out in this Agreement.

e.  You have obtained all required or desirable authorisations to enable You to enter into, exercise Your rights, and comply with Your obligations under this Agreement. All such authorisations are in full force and effect.

f.  You are acting on Your own behalf and not for the benefit of any other person or entity.

g.  You understand and accept that the Tracer DAO is an experiment and that You participate at Your own risk in the Tracer DAO and that these risks (some of which are set out in clause 7) are substantial.

h.  You acknowledge that these risks may be the result of technical issues with the Ethereum blockchain, blockchain based software, or the negligent acts, omissions, and/or carelessness of the Service Providers, the Related Parties or other Tracer DAO Participants.

i.  You understand that all transactions executed in accordance with clauses 4 and 8 will occur on  the Ethereum Blockchain and accordingly are unlikely to be removed , are irreversible, and are subject to the ongoing operation of the Ethereum Blockchain.

j.  You are the owner(s) of the Wallet used to sign this Agreement and have the capacity to control such Wallet. The Tracer DAO does not have custody of Your Wallet.

k.  You are responsible to implement all appropriate measures for securing Your Wallet, including any private keys, seed words or other credentials necessary to access such storage mechanism.

l.  You are not acting as a Consumer when interacting with the Tracer DAO or entering into this Agreement.

m.  You have obtained sufficient information about the Tracer DAO to make an informed decision to become a Party to this Agreement.

n.  You understand that such transactions may not be erased and that Your Wallet address and transaction is displayed permanently and publicly and that You relinquish any right of rectification or erasure of personal data.

o.  You are not in or under the control of, or a national or resident of any country subject to United States embargo, United Nations or EU sanctions or the HM Treasury's financial sanctions regime, or on the U.S. Treasury Department's Specially Designated Nationals List, the U.S. Commerce Department's Denied Persons List, Unverified List, Entity List, the EUS consolidated list or the HM Treasury's financial sanctions regime.

p.  The choice of English law as the governing law of this Agreement will be recognised and enforced in Your jurisdiction of domicile or incorporation or registration, as the case may be.



6.  COVENANTS

a.  You covenant with the other Parties as set out in clause 6b and 6c, respectively, and undertake to comply with those covenants.

b.  You must:

i.  actively participate in the decision-making process as a Governance Token Holder;

ii.  support the purpose of the Tracer DAO as described in the Background and refrain from any action that may conflict with or harm that purpose;

iii.  to the extent that the Tracer DAO Governance Token Holder has the capacity to do so, exercise their Governance Token to procure that the provisions of this Agreement are properly and promptly observed and given full force and effect according to the spirit and intention of the Agreement;

c.  You must:

i.  comply in all respects with all relevant laws to which You may be subject, if failure to do so would materially impair Your ability to perform Your obligations under this Agreement;

ii.  not attempt to gain unauthorised access to activities carried on during the Governance Period and/or to interact with the Smart Contracts in any matter not contemplated by this Agreement, unless authorised by way of Proposal;

iii.  not commence any dispute or claim (including non-contractual disputes or claims) against any of the Service Providers, the Related Parties or Tracer DAO Participants for any of the Released Claims that you have waived, released, or discharged in clause 11 or for any other claims;

iv.  inform Yourself continuously about the regulatory status of blockchain technology and digital assets to ensure compliance with the legal framework applicable to You when taking part in the decision-making process of the Tracer DAO;

v.  comply with all legislation, regulations, professional standards, and other provisions as may govern the conduct of the Tracer DAO;

vi.  comply with any applicable tax obligations in their jurisdiction arising from their interaction with the Tracer DAO;

vii.  not misuse the Vote Interface and/or the Smart Contract by knowingly introducing or otherwise engaging with viruses, bugs, worms or other material that is malicious or technologically harmful;

viii.  not use the Tracer DAO to finance, engage in, or otherwise support any unlawful activities.



7.  GENERAL RISKS

You are fully aware of, understand and agree to assume all the risks (including direct, indirect or ancillary risks) associated with participating in the Tracer DAO including:

a.  THE NECESSITY FOR YOU TO TAKE YOUR OWN SECURITY MEASURES FOR THE WALLET USED TO PARTICIPATE TO AVOID A LOSS OF ACCESS: The Tracer DAO does not provide any central entity that can store or restore the access data of Tracer DAO Participants. You need to keep Your private keys, seed phrases or other credentials necessary to access Your Wallet in safe custody.  If you lose Your private keys, seed phrases or other credentials you may permanently lose access to your tokens.

b.  THE TAMPER RESISTANT NATURE  AND IRREVERSIBILITY OF ETHEREUM TRANSACTIONS: Errors, false inputs. or other errors are solely the responsibility of each individual Participant. No other Tracer DAO Participants shall have an obligation whatsoever to reverse or assist to reverse any false transaction.

c.  THE CREATION OF MORE THAN ONE VERSION OF THE ETHEREUM BLOCKCHAIN DUE TO FORKS: In the event of a Fork, Your transactions may not be completed, completed partially, incorrectly completed, or substantially delayed. No Party is responsible for any loss incurred by You caused in whole or in part, directly or indirectly, by a Fork of the Ethereum Blockchain.

d.  REMAINING SMART CONTRACT RISKS: THERE MAY BE VULNERABILITIES IN THE DEPLOYED SMART CONTRACTS: You may experience damage or loss caused by the existence, identification and/or exploitation of these vulnerabilities through hacks, mining attacks (including double-spend attacks, majority mining power attacks and "selfish-mining" attacks), sophisticated cyber-attacks, distributed denials of service or other security breaches, attacks or deficiencies.

e.  THE POTENTIAL EXISTENCE OF PHISHING WEBSITES WHICH PRETEND TO BE THE TRACER DAO USER INTERFACE: It is Your obligation to carefully check that You are accessing the correct domain.

f.  DEPENDENCIES ON EXTERNAL DATA CENTERS: Some computations may involve external data centers. You agree that the Participants, Governance Tokens Holders, Service Providers, or any of their Related Parties shall not be responsible for any errors or omissions by the data centers operated by third parties.

g.  CONSTANT AND DYNAMIC REGULATORY DEVELOPMENTS WITH REGARD TO DIGITAL ASSETS: Applicable laws may be uncertain and/or subject to clarification, implementation or change.



8.  EXECUTION, COMMENCEMENT, AND DURATION

a.  This Agreement can be  executed in counterparts through a Digital Signature and may be Digitally Signed in any number of counterparts, each of which when executed shall constitute a duplicate original, but all the counterparts shall together constitute the one Agreement.

b.  This Agreement comes into effect when a minimum of two Tracer DAO Participants have Digitally Signed it in accordance with clause 8a.

c.  This Agreement shall have full force and effect and each Tracer DAO Participant will be bound by this Agreement until the occurrence of an Agreement Termination Event.

d.  Any provision of this Agreement that expressly or by implication is intended to come into or continue to be in force on or after an Agreement Termination Event (including this clause 8, and clauses 5-7, 9, 11-14, 17-19, 23-25) shall remain in full force and effect.



9.  TERMINATION OF TRACER DAO PARTICIPATION

a.  An Agreement Termination Event occurs if, during the Governance Period, a Governance Token Holder ceases to be a Party to this Agreement and the Tracer DAO, or if a Proposal for removal (in accordance with clause 10) or resignation is submitted to the Tracer DAO and passed successfully. Any such proposal may be submitted by a Governance Token Holder and may request that the Governance Token is retired.

b.  A termination pursuant to clause 9a ("Party Termination Event") shall not affect: (i) the continuance of the Tracer DAO; (ii) the Agreement between the remaining Parties; or (iii)or, subject to clause 11, any waiver or release of all rights, remedies, obligations, or liabilities of the Parties that have accrued up to the date of such event, including the right, if any, to claim damages in respect of any breach of the Agreement which existed at or before the date of such event.

c.  Any provision of this Agreement that expressly or by implication is intended to come into or continue to be in force on or after a Party Termination Event (including this clause 9, and clauses 5-7, 9, 11-14, 17-19, 23-25) in relation to the respective Tracer DAO Governance Token Holder shall remain in full force and effect.



10.  REASONS FOR TERMINATION OF PARTICIPATION

a.  A Governance Token Holder may, in its sole discretion propose, by way of Proposal, the removal of a Governance Token from a Wallet for cause. Cause includes, but is not limited to, when a Governance Token Holder:

i.  commits a material breach of this Agreement or applicable laws; or

ii.  takes actions likely to have a serious adverse effect on the Tracer DAO.



11.  WAIVER AND RELEASE OF RECOURSE TO LEGAL ACTION

a.  You hereby irrevocably release and forever discharge all and/or any actions, suits, proceedings, claims, rights, demands, however arising, whether for direct or indirect damages, loss or injury sustained, loss of profits, loss of expectation, accounting, set-offs, costs or expenses or for any other remedy, whether in England and Wales or any other jurisdiction, whether or not presently known to the Parties or to the law, and whether in law or equity, that You ever had, may have or hereafter can, shall or may have against the Service Providers, any of their Related Parties or any other Participant or Governance Token Holder arising out of or relating to his Agreement, the Tracer DAO, or any other matter arising out of or relating to the relationship between the Parties (collectively, the "Released Claims").

b.  Each Tracer DAO Participant agrees not to sue, commence, voluntarily aid in any way, prosecute or cause to be commenced or prosecuted against the Service Providers, their Related Parties or any other Participant or Governance Token Holder in any action, suit, arbitral proceedings, or other proceedings concerning the Released Claims in England and Wales or any other jurisdiction.

c.  Each Tracer DAO Participant acknowledges and agrees that this agreement does not constitute a partnership agreement of any kind.  Despite this, in the event that a court determines any aspect of this agreement is found to constitute or cause a partnership to arise, each Participant or other Governance Token Holder hereby waives any rights against each other partner in respect of the Released Claims howsoever arising, including any obligation to account or account for any profit or loss or any other cause of action that a partner would have against another partner in the context of a partnership.



12.  INDEMNITY

a.  You shall indemnify any Participant, Governance Token Holder, Service Provider and their Related Parties against all liabilities, costs, expenses, damages and losses (including any direct, indirect or consequential losses, loss of profits, loss of Governance Token and all interest, penalties and legal costs (calculated on a full indemnity basis) and all other reasonable professional costs and expenses suffered or incurred arising out of or in connection with Your breach of this Agreement, and any of Your acts or omissions that infringe the rights of any Party under this Agreement, including

i.  Your breach of any of the warranties, representations, waivers, releases, and covenants contained in clauses 5-7 and 11;

ii.  Your breach or negligent performance or non-performance of this Agreement;

iii.  any claim made against any of the Participants, Governance Tokens Holders, Service Providers, or any of their Related Parties for actual or alleged infringement of a third party's intellectual property rights arising out of or in connection with Your participation in the Governance Period;

iv.  any claim made against any of the Participants, Governance Tokens Holders, Service Providers, or any of their Related Parties by a third party arising out of or in connection with Your breach of the warranties, representations, waivers, releases or covenants as contained in clauses 5-7 and 11;

v.  any claim made against any of the Participants, Governance Tokens Holders, Service Providers, or any of their Related Parties by a third party for loss or damage to property arising out of or in connection with Your participation in the Governance Period of the Tracer DAO;

vi.  any claims made by You or other persons, for liabilities assessed against any of the Participants, Governance Tokens Holders, Service Providers, or any of the Related Parties, including but not limited to legal costs, attorneys' fees and dispute resolution expenses, arising out of or resulting, directly or indirectly, in whole or in part,  from Your breach or failure to abide by any part of this Agreement.

b.  The indemnity set out in this clause 12 shall apply whether or not You have been negligent or at fault and is in addition to any other remedies that may be available to the Related Parties under applicable law.

c.  The provisions of this clause shall be for the benefit of the Participants, Governance Token Holders, Service Providers, and their Related Parties and shall be enforceable by each of the aforementioned parties.

d.  If a payment due from You under this clause is subject to tax (whether by way of direct assessment or withholding at its source), the Service Provider and/or the Related Parties shall be entitled to receive from You such amounts as shall ensure that the net receipt, after tax, to the Service Provider and the Related Parties in respect of the payment is the same as it would have been were the payment not subject to tax.



13.  DISCLAIMER OF WARRANTIES 

THE TRACER DAO IS AN EXPERIMENT IN THE FIELD OF DECENTRALISED GOVERNANCE STRUCTURES. ACCORDINGLY, THE FOUNDATIONAL CODE, THE VOTE INTERFACE AND THE COORDINATION OF THE GOVERNANCE PERIOD ARE PROVIDED ON AN "AS IS" AND "AS AVAILABLE" BASIS WITHOUT ANY REPRESENTATION OR WARRANTY, WHETHER EXPRESS, IMPLIED OR STATUTORY TO THE MAXIMUM EXTENT PERMITTED BY LAW.

TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, THE PARTICIPANTS, GOVERNANCE TOKENS HOLDERS, SERVICE PROVIDERS, OR ANY OF THEIR RELATED PARTIES SPECIFICALLY DISCLAIM ANY IMPLIED WARRANTIES OF TITLE, LEGALITY, VALIDITY, ADEQUACY OR ENFORCEABILITY, MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND/OR NON-INFRINGEMENT. THE PARTICIPANTS, GOVERNANCE TOKENS HOLDERS, SERVICE PROVIDERS, OR ANY OF THEIR RELATED PARTIES DO NOT MAKE ANY REPRESENTATIONS OR WARRANTIES THAT ACCESS TO OR USE OF THE FOUNDATIONAL CODE, THE PROVISION OF THE VOTE INTERFACE AND THE AND COORDINATION OF THE GOVERNANCE PERIOD WILL BE CONTINUOUS, UNINTERRUPTED, TIMELY, OR ERROR-FREE.



14.  LIMITATION OF LIABILITY

a.  PARTICIPATION IN OR INTERACTION WITH THE TRACER DAO IS AT A PERSON'S OWN RISK AND THE PERSON ASSUMES FULL RESPONSIBILITY FOR SUCH PARTICIPATION OR INTERACTION. THE PARTICIPANTS, GOVERNANCE TOKENS HOLDERS, SERVICE PROVIDERS, OR ANY OF THEIR RELATED PARTIES EXCLUDE ALL IMPLIED CONDITIONS, WARRANTIES, REPRESENTATIONS OR OTHER TERMS THAT MAY APPLY TO THE FOUNDATIONAL CODE, THE VOTE INTERFACE AND THE COORDINATION OF THE GOVERNANCE PERIOD. THE PARTICIPANTS, GOVERNANCE TOKENS HOLDERS, SERVICE PROVIDERS, OR ANY OF THEIR RELATED PARTIES WILL NOT BE LIABLE FOR ANY LOSS OR DAMAGE, WHETHER IN CONTRACT, TORT (INCLUDING NEGLIGENCE), BREACH OF STATUTORY DUTY, OR OTHERWISE, EVEN IF FORESEEABLE, ARISING UNDER OR IN CONNECTION WITH THE USE OF, OR INABILITY TO USE THE FOUNDATIONAL CODE OR THE VOTE INTERFACE. THE PARTICIPANTS, GOVERNANCE TOKENS HOLDERS, SERVICE PROVIDERS, OR ANY OF THEIR RELATED PARTIES WILL NOT BE LIABLE FOR LOSS OF PROFITS, SALES, BUSINESS, OR REVENUE, BUSINESS INTERRUPTION, ANTICIPATED SAVINGS, BUSINESS OPPORTUNITY, GOODWILL OR GOVERNANCE TOKEN OR ANY INDIRECT OR CONSEQUENTIAL LOSS OR DAMAGE.

b.  Some jurisdictions do not allow the exclusion or limitation of incidental or consequential damages, disclaimers, exclusions, and limitations of liability under this Agreement will not apply to the extent prohibited by applicable law. Insofar as the aforementioned elements of the Agreement can be applied in a legally compliant manner, they remain binding to the maximum extent permitted by applicable law.

c.  Unless expressly provided otherwise in this Agreement, any remaining liability of the Parties for obligations under this Agreement shall be several only and extend only to any loss or damage arising out of their own breaches.



15.  VARIATION

a.  No variation of this Agreement shall be effective unless it is voted on by way of Proposal, which is accepted.



16.  SEVERABILITY

a.  If any provision of this Agreement is or becomes invalid, illegal, or unenforceable, it shall be deemed modified to the minimum extent necessary to make it valid, legal and enforceable.

b.  If such modification is not possible, the relevant provision shall be deemed deleted and replaced by the application of the law that complies with the remaining Agreement to the maximum extent. Any modification to or deletion of a provision under this clause shall not affect the validity and enforceability of the rest of this Agreement.



17.  ENTIRE AGREEMENT

a.  This Agreement constitutes the entire and exclusive agreement between the Parties regarding its subject matter and supersedes and replaces any previous or contemporaneous written or oral contract, promises, assurances, warranty, representation or understanding regarding its subject matter and/or the Tracer DAO, whether written, coded or oral.

b.  Each Party acknowledges that in entering into this Agreement they do not rely on, and shall have no remedy in respect of, any statement, representation, assurance or warranty (whether made innocently or negligently) that is not set out in this Agreement.

c.  No party shall have a claim for innocent or negligent misrepresentation or misstatement based on any statement in this Agreement.



18.  NO WAIVER

A failure or delay by any Party to exercise any right or remedy provided under this Agreement or by law shall not constitute a waiver of that or any other right or remedy, nor shall it prevent or restrict any further exercise of that or any other right or remedy.



19.  NO THIRD PARTY RIGHTS

a.  Unless expressly stated otherwise, this Agreement does not give rise to any rights under the Contracts (Rights of Third Parties) Act 1999 or analogous legislation in any other jurisdiction (to the extent such is found to apply) to enforce any term of this Agreement.

b.  The rights of the Parties to terminate, rescind or agree any variation, waiver or settlement under this Agreement are not subject to the consent of any third party.



20.  RELATIONSHIP OF THE PARTIES

a.  Nothing in this Agreement is intended to, nor shall create any partnership (whether express or implied), joint venture, agency, or trusteeship.

b.  Each Party confirms:

i.  it is acting on its own behalf and not for the benefit of any other person;

ii.  it is liable for its own taxes;

iii.  the Parties have no fiduciary duties or equivalent obligations towards each other.



21.  FORCE MAJEURE

If the Foundational Code, the coordination of the Governance Period and/or provision of the Vote Interface are affected, hindered or made impossible in whole or in part by a Force Majeure Event, this shall under no circumstances be deemed a breach of this Agreement and no loss or damage shall be claimed by reason thereof.



22.  NO ASSIGNMENT

a.  Tracer DAO Participants may not assign or transfer any of their rights or duties arising out of or in connection with this Agreement to a third party. Any such assignment or transfer shall be void and shall not impose any obligation or liability on the Parties to the assignee or transferee.

b.  The Service Providers may assign their rights or duties arising out of or in connection with this Agreement to any of their affiliates or in connection with a merger or other disposition of all or substantially all of their assets.



23.  COMPLAINTS PROCEDURE

a.  If a problem arises among you and other Participants or an external person and/or the Tracer DAO as a whole, you shall submit a request for action to the Tracer DAO by way of Proposal, in which You must set out:

i.  detailed enquiry description;

ii.  the date and time that the issue arose;

iii.  the outcome You are seeking.



24.  DISPUTE RESOLUTION

a.  YOU AGREE AND UNDERSTAND THAT BY ENTERING INTO THIS AGREEMENT, YOU EXPRESSLY WAIVE YOUR RIGHT, IF ANY, TO A TRIAL BY JURY AND RIGHT TO PARTICIPATE IN A CLASS ACTION LAWSUIT.

b.  In the event a Dispute cannot be resolved amicably in accordance with clause 23, you must first refer the Dispute to proceedings under the International Chamber of Commerce ("ICC") Mediation Rules, which Rules are deemed to be incorporated by reference into this clause 24. The place of mediation shall be London, United Kingdom. The language of the mediation proceedings shall be English.

c.  If the Dispute has not been settled pursuant to the ICC Mediation Rules within 40 days following the filing of a Request for Mediation in accordance with the ICC Mediation Rules or within such other period as the parties to the Dispute may agree in writing, such Dispute shall thereafter be finally settled under the Rules of Arbitration of the International Chamber of Commerce by three arbitrators appointed in accordance with the said Rules. The seat of Arbitration shall be London, United Kingdom irrespective of the location of any Party. The governing law of this arbitration clause shall be the laws of England and Wales. The language of the arbitration shall be English. The Emergency Arbitrator Provisions shall not apply.



25.  GOVERNING LAW

This Agreement shall be governed by and construed in accordance with the substantive laws of England and Wales without regard to conflict of laws principles but with the Hague Principles on the Choice of Law in International Commercial Contracts hereby incorporated by reference.



*/

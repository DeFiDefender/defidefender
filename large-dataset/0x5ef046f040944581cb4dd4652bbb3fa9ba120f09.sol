pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;


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
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    /**
      * @dev Safely transfers `tokenId` token from `from` to `to`.
      *
      * Requirements:
      *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
      * - `tokenId` token must exist and be owned by `from`.
      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
      *
      * Emits a {Transfer} event.
      */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
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

// SPDX-License-Identifier: MIT
contract NFTDAO is IERC20 {



    /// @notice using Openzeppelin contracts for SafeMath and Address

    using SafeMath for uint256;

    using Address for address;



    /// @notice presenting the total supply

    uint256 private _totalSupply;



    /// @notice presenting the amount burned

    uint256 public _burnedSupply;



    /// @notice representing the name of the governance token

    string public _name;



    /// @notice representing the symbol of the governance token

    string public _symbol;



    /// @notice representing the decimals of the governance token

    uint8 public immutable _decimals = 18;



    /// @notice a record of balance of a specific account by address

    mapping(address => uint256) private _balances;



    /// a record of allowances for a specific address by address to address mapping

    mapping(address => mapping(address => uint256)) private _allowances;



    /// presenting the shares for sale

    uint256 public _sharesForSale;



    /// @notice the nft used to create the dao contract

    IERC721 public _nftAddress;



    /// @notice struct for raised nfts

    struct _raisedNftStruct {

        IERC721 nftaddress;

        uint tokenid;

    }



    /// @notice array for raised nfts

    _raisedNftStruct[] public _raisedNftArray;



    /// @notice the token id identifying the nft token

    uint256 public _tokenId;



    /// @notice the owner and creator of the contract

    address public _owner;



    /// @notice the buyout price. once its met, all nfts will be transferred to the buyer, all tokens will be burned

    uint256 public _buyoutPrice;



    /// @notice representing the governance contract of the nft

    address public _governor;



    /// @notice representing the timelock address of the nft for the governor

    address public _timelock;



    /// @notice A record of each accounts delegate

    mapping (address => address) public delegates;



    /// @notice A checkpoint for marking number of votes from a given block

    struct Checkpoint {

        uint32 fromBlock;

        uint256 votes;

    }



    /// @notice A record of votes checkpoints for each account, by index

    mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;



    /// @notice The number of checkpoints for each account

    mapping (address => uint32) public numCheckpoints;



    /// @notice The EIP-712 typehash for the contract's domain

    bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");



    /// @notice The EIP-712 typehash for the delegation struct used by the contract

    bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");



    /// @notice A record of states for signing / validating signatures

    mapping (address => uint) public nonces;



    /// @notice the buyer address of the dao when sold

    address public BuyerAddress;



    /// init of the contract

    bool public _init;



    /// @notice An event thats emitted when an account changes its delegate

    event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);



    /// @notice An event thats emitted when a delegate account's vote balance changes

    event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);



    /// @notice An event thats emitted when the buyout price is changed

    event BuyoutChanged(uint previousPrice, uint newPrice);



    /// @notice An event thats emitted when the governor has changed

    event GovernorChanged(address oldGovernor, address newGovernor);



    constructor (IERC721 nftAddress_, address owner_, uint256 tokenId_, uint256 totalSupply_, string memory name_, string memory symbol_, uint256 buyoutPrice_) public {

        _nftAddress = nftAddress_;

        _owner = owner_;

        _tokenId = tokenId_;

        _totalSupply = totalSupply_ * 10 ** 18;

        _name = name_;

        _symbol = symbol_;

        _buyoutPrice = buyoutPrice_;

        _sharesForSale = 0;

        _init = false;

    _balances[_owner] = _totalSupply;

    emit Transfer(address(0), owner_, _totalSupply);

    }

    function init(address governorFactory, address timelockFactory, uint256 timelockinit ) public returns (bool) {

        require(msg.sender == _owner, "NFTDAO: init requires owner");

        _governor = GovernorFactoryInterface(governorFactory).GovernorMint(address(this), _totalSupply);

        _timelock = TimelockFactoryInterface(timelockFactory).TimelockMint(_governor, timelockinit);

        GovernorInstance(_governor).init(_timelock);

        _nftAddress.transferFrom(_owner, address(this), _tokenId);

        _init = true;

        return true;

    }



    /**

    * @dev Destroys `amount` tokens from `account`, reducing

    * and updating burnd tokens for abstraction

    *

    */

    function _burn(uint256 amount) internal {

        _totalSupply -= amount;

    }



    function burnForETH() public {

        uint256 balance = balanceOf(msg.sender);

        _balances[msg.sender] = 0;

        uint256 contractBalalance = address(this).balance;

        uint256 cashout = contractBalalance.mul(balance).div(_totalSupply);

        _burn(balance);

        msg.sender.transfer(cashout);

    emit Transfer(msg.sender, address(0), balance);

    }



    function Buyshares(uint256 amount) public payable {

        require(_sharesForSale >= amount, "NFTDAO: dont have enough shares");

        require(msg.value >= amount.mul(_buyoutPrice).div(_totalSupply), "NFTDAO: Sent amount too low");



        _balances[msg.sender] += amount;

        _sharesForSale -= amount;



        uint256 cost = msg.value - amount.mul(_buyoutPrice).div(_totalSupply);

        msg.sender.transfer(cost);

    }



    function buyout() public payable {

        require(msg.value >= _buyoutPrice, "NFTDAO: buyout price not yet met");

        

        uint256 balance = _balances[msg.sender];

        _balances[msg.sender] = 0;

        

        

        uint256 cost = msg.value - (_buyoutPrice.mul((_totalSupply.sub(balance)).div(_totalSupply)));

      _burn(balance);

  

        _nftAddress.approve(msg.sender, _tokenId);

        _nftAddress.transferFrom(address(this), msg.sender, _tokenId);

        BuyerAddress = msg.sender;

        msg.sender.transfer(cost);

    emit Transfer(msg.sender, address(0), balance);

    }

    function buyoutTransfer(uint256 min, uint256 max) public {

        require(msg.sender == BuyerAddress, "NFTDAO: buyout price not yet met");

        for (uint i=min; i<max; i++) {

            _raisedNftArray[i].nftaddress.approve(msg.sender, _raisedNftArray[i].tokenid);

            _raisedNftArray[i].nftaddress.transferFrom(address(this), msg.sender, _raisedNftArray[i].tokenid);

        }

    }

    function burnSharesForSale(uint256 amount) public returns (bool success) {

        address sender=msg.sender;

        require(sender == _timelock, "NFTDAO: Only Timelock of the NFT can call burnShares");

        require(sender != address(0), "ERC20: transfer from the zero address");

        require(_sharesForSale >= amount, "NFTDAO: Cant burn more shares than available for sale");



        _burn(amount);

        _sharesForSale -= amount;



        emit Transfer(sender, address(0), amount);

        return true;

    }



    function _mint(uint256 amount) internal {

        _totalSupply = _totalSupply + amount;

    }



    function mintSharesForSale(uint256 amount) public returns (bool success) {

        address sender=msg.sender;

        require(sender != address(0), "ERC20: transfer from the zero address");

        require(sender == _timelock, "NFTDAO: Only Timelock of the NFT can call mintShares");



        _mint(amount);

        _sharesForSale += amount;



        emit Transfer(address(0), address(this), amount);

        return true;

    }



    function changeBuyoutPrice (uint256 amount) public returns (bool success) {

        address sender=msg.sender;

        require(sender != address(0), "ERC20: transfer from the zero address");

        require(sender == _timelock, "NFTDAO: Only Timelock of the NFT can change buyout price");



        uint256 old_buyout = _buyoutPrice;



        _buyoutPrice = amount;

        emit BuyoutChanged(old_buyout, _buyoutPrice);

        return true;

    }



    function changeGovernor (address newgov) public returns (bool success) {

        address sender=msg.sender;

        require(sender != address(0), "ERC20: transfer from the zero address");

        require(sender == _timelock, "NFTDAO: Only Timelock of the NFT can change govenor");



        address old_gov = _governor;



        _governor = newgov;

        emit GovernorChanged(old_gov, newgov);

        return true;

    }



    function addNft(IERC721 new_nft, uint256 tokenid) public returns (bool success) {

        address sender=msg.sender;

        require(sender != address(0), "ERC20: transfer from the zero address");

        require(sender == _timelock, "NFTDAO: Only Timelock of the NFT can call add nft");



        _raisedNftStruct memory temp_struct;

        temp_struct.nftaddress = new_nft;

        temp_struct.tokenid = tokenid;



        _raisedNftArray.push(temp_struct);

        return true;

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

     * be displayed to a user as `5,05` (`505 / 10 ** 2`.

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

    function totalSupply() public override view returns (uint256) {

        return _totalSupply;

    }



    /**

    * @dev See {IERC20-balanceOf}. Uses burn abstraction for balance updates without gas and universally.

    */

    function balanceOf(address account) public override view returns (uint256) {

        return

        (_balances[account] * _totalSupply) / (_totalSupply - _burnedSupply);

    }



    /**

    * @dev See {IERC20-transfer}.

    *

    * Requirements:

    *

    * - `recipient` cannot be the zero address.

    * - the caller must have a balance of at least `amount`.

    */

    function transfer(address dst, uint256 rawAmount) external override returns (bool) {

        uint256 amount = rawAmount;

        _transferTokens(msg.sender, dst, amount);

        return true;

    }





    /**

    * fallback function for collection funds

    */

    fallback() external payable {



    }



    /**

     * @dev See {IERC20-allowance}.

     */

    function allowance(address owner, address spender)

    public

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

    override

    returns (bool)

    {

        _approve(msg.sender, spender, amount);

        return true;

    }



    /**

     * @dev See {IERC20-transferFrom}.

     *

     * Emits an {Approval} event indicating the updated allowance. This is not

     * required by the EIP. See the note at the beginning of {ERC20};

     *

     * Requirements:

     * - `sender` and `recipient` cannot be the zero ress.

     * - `sender` must have a balance of at least `amount`.

     * - the caller must have allowance for ``sender``'s tokens of at least

     * `amount`.

     */

    function transferFrom(address src, address dst, uint256 rawAmount) external override returns (bool) {

        address spender = msg.sender;

        uint256 spenderAllowance = _allowances[src][spender];

        uint256 amount = rawAmount;



        if (spender != src && spenderAllowance != uint256(-1)) {

            uint256 newAllowance = spenderAllowance.sub(amount, "NFTDAO::transferFrom: transfer amount exceeds spender allowance");

            _allowances[src][spender] = newAllowance;



            //emit Approval(src, spender, newAllowance);

        }



        _transferTokens(src, dst, amount);

        return true;

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

    function _approve(

        address owner,

        address spender,

        uint256 amount

    ) internal {

        require(owner != address(0), "ERC20: approve from the zero address");

        require(spender != address(0), "ERC20: approve to the zero address");



        _allowances[owner][spender] = amount;

        emit Approval(owner, spender, amount);

    }



    function _transfer(

        address sender,

        address recipient,

        uint256 amount

    ) internal {

        require(sender != address(0), "ERC20: transfer from the zero address");

        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(

            amount,

            "ERC20: transfer amount exceeds balance"

        );

        _balances[recipient] = _balances[recipient].add(amount);

        emit Transfer(sender, recipient, amount);

    }



    /**

     * @notice Delegate votes from `msg.sender` to `delegatee`

     * @param delegatee The address to delegate votes to

     */

    function delegate(address delegatee) public {

        return _delegate(msg.sender, delegatee);

    }



    /**

     * @notice Delegates votes from signatory to `delegatee`

     * @param delegatee The address to delegate votes to

     * @param nonce The contract state required to match the signature

     * @param expiry The time at which to expire the signature

     * @param v The recovery byte of the signature

     * @param r Half of the ECDSA signature pair

     * @param s Half of the ECDSA signature pair

     */

    function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {

        bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(_name)), getChainId(), address(this)));

        bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));

        bytes32 digest = keccak256(abi.encodePacked("\\x19\\x01", domainSeparator, structHash));

        address signatory = ecrecover(digest, v, r, s);

        require(signatory != address(0), "NFTDAO::delegateBySig: invalid signature");

        require(nonce == nonces[signatory]++, "NFTDAO::delegateBySig: invalid nonce");

        require(now <= expiry, "NFTDAO::delegateBySig: signature expired");

        return _delegate(signatory, delegatee);

    }



    /**

     * @notice Gets the current votes balance for `account`

     * @param account The address to get votes balance

     * @return The number of current votes for `account`

     */

    function getCurrentVotes(address account) external view returns (uint256) {

        uint32 nCheckpoints = numCheckpoints[account];

        return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;

    }



    /**

     * @notice Determine the prior number of votes for an account as of a block number

     * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.

     * @param account The address of the account to check

     * @param blockNumber The block number to get the vote balance at

     * @return The number of votes the account had as of the given block

     */

    function getPriorVotes(address account, uint blockNumber) public view returns (uint256) {

        require(blockNumber < block.number, "NFTDAO::getPriorVotes: not yet determined");



        uint32 nCheckpoints = numCheckpoints[account];

        if (nCheckpoints == 0) {

            return 0;

        }



        // First check most recent balance

        if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {

            return checkpoints[account][nCheckpoints - 1].votes;

        }



        // Next check implicit zero balance

        if (checkpoints[account][0].fromBlock > blockNumber) {

            return 0;

        }



        uint32 lower = 0;

        uint32 upper = nCheckpoints - 1;

        while (upper > lower) {

            uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow

            Checkpoint memory cp = checkpoints[account][center];

            if (cp.fromBlock == blockNumber) {

                return cp.votes;

            } else if (cp.fromBlock < blockNumber) {

                lower = center;

            } else {

                upper = center - 1;

            }

        }

        return checkpoints[account][lower].votes;

    }



    function _delegate(address delegator, address delegatee) internal {

        address currentDelegate = delegates[delegator];

        uint256 delegatorBalance = _balances[delegator];

        delegates[delegator] = delegatee;



        emit DelegateChanged(delegator, currentDelegate, delegatee);



        _moveDelegates(currentDelegate, delegatee, delegatorBalance);

    }



    function _transferTokens(address src, address dst, uint256 amount) internal {

        require(src != address(0), "NFTDAO::_transferTokens: cannot transfer from the zero address");

        require(dst != address(0), "NFTDAO::_transferTokens: cannot transfer to the zero address");



        _balances[src] = _balances[src].sub( amount, "NFTDAO::_transferTokens: transfer amount exceeds balance");

        _balances[dst] = _balances[dst].add( amount);

        emit Transfer(src, dst, amount);



        _moveDelegates(delegates[src], delegates[dst], amount);

    }



    function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {

        if (srcRep != dstRep && amount > 0) {

            if (srcRep != address(0)) {

                uint32 srcRepNum = numCheckpoints[srcRep];

                uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;

                uint256 srcRepNew = srcRepOld.sub( amount, "NFTDAO::_moveVotes: vote amount underflows");

                _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);

            }



            if (dstRep != address(0)) {

                uint32 dstRepNum = numCheckpoints[dstRep];

                uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;

                uint256 dstRepNew = dstRepOld.add(amount);

                _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);

            }

        }

    }



    function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint256 oldVotes, uint256 newVotes) internal {

        uint32 blockNumber = safe32(block.number, "NFTDAO::_writeCheckpoint: block number exceeds 32 bits");



        if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {

            checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;

        } else {

            checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);

            numCheckpoints[delegatee] = nCheckpoints + 1;

        }



        emit DelegateVotesChanged(delegatee, oldVotes, newVotes);

    }



    function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {

        require(n < 2**32, errorMessage);

        return uint32(n);

    }





    function getChainId() internal pure returns (uint) {

        uint256 chainId;

        assembly { chainId := chainid() }

        return chainId;

    }



}

interface TimelockFactoryInterface {

    function TimelockMint(address admin_,uint delay_) external returns (address);

}

interface GovernorFactoryInterface {

    function GovernorMint(address nft_, uint supply_) external returns (address);

  

}

interface GovernorInstance {

  function init(address timelock) external;

}

/// @notice contract factory for the timelock interface
contract NFTDAOFactory {



    /// @notice event for creation

    event NewNFTDAO(address deployed);



    constructor() public {

    }



    /// minting function

    function NFTDAOMint(

        IERC721 nftAddress_,

        address owner_,

        uint256 tokenId_,

        uint256 totalSupply_,

        string memory name_,

        string memory symbol_,

        uint256 buyoutPrice_

    ) public returns (address) {

        NFTDAO newContract = new NFTDAO(

            nftAddress_,

            owner_,

            tokenId_,

            totalSupply_,

            name_,

            symbol_,

            buyoutPrice_

        );

        emit NewNFTDAO(address(newContract));

        return address(newContract);

    }

}

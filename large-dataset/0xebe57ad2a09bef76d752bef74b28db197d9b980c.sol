
// File: @openzeppelin/upgrades/contracts/Initializable.sol

pragma solidity >=0.4.24 <0.7.0;


/**
 * @title Initializable
 *
 * @dev Helper contract to support initializer functions. To use it, replace
 * the constructor with a function that has the `initializer` modifier.
 * WARNING: Unlike constructors, initializer functions must be manually
 * invoked. This applies both to deploying an Initializable contract, as well
 * as extending an Initializable contract via inheritance.
 * WARNING: When used with inheritance, manual care must be taken to not invoke
 * a parent initializer twice, or ensure that all initializers are idempotent,
 * because this is not dealt with automatically as with constructors.
 */
contract Initializable {

  /**
   * @dev Indicates that the contract has been initialized.
   */
  bool private initialized;

  /**
   * @dev Indicates that the contract is in the process of being initialized.
   */
  bool private initializing;

  /**
   * @dev Modifier to use in the initializer function of a contract.
   */
  modifier initializer() {
    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");

    bool isTopLevelCall = !initializing;
    if (isTopLevelCall) {
      initializing = true;
      initialized = true;
    }

    _;

    if (isTopLevelCall) {
      initializing = false;
    }
  }

  /// @dev Returns true if and only if the function is running in the constructor
  function isConstructor() private view returns (bool) {
    // extcodesize checks the size of the code stored in an address, and
    // address returns the current address. Since the code is still not
    // deployed when running a constructor, any checks on its code size will
    // yield zero, making it an effective way to detect if a contract is
    // under construction or not.
    address self = address(this);
    uint256 cs;
    assembly { cs := extcodesize(self) }
    return cs == 0;
  }

  // Reserved storage space to allow for layout changes in the future.
  uint256[50] private ______gap;
}

// File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.5.0;

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

// File: @openzeppelin/contracts-ethereum-package/contracts/introspection/IERC165.sol

pragma solidity ^0.5.0;

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

// File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC721/IERC721.sol

pragma solidity ^0.5.0;



/**
 * @dev Required interface of an ERC721 compliant contract.
 */
contract IERC721 is Initializable, IERC165 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of NFTs in `owner`'s account.
     */
    function balanceOf(address owner) public view returns (uint256 balance);

    /**
     * @dev Returns the owner of the NFT specified by `tokenId`.
     */
    function ownerOf(uint256 tokenId) public view returns (address owner);

    /**
     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
     * another (`to`).
     *
     *
     *
     * Requirements:
     * - `from`, `to` cannot be zero.
     * - `tokenId` must be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this
     * NFT by either {approve} or {setApprovalForAll}.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) public;
    /**
     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
     * another (`to`).
     *
     * Requirements:
     * - If the caller is not `from`, it must be approved to move this NFT by
     * either {approve} or {setApprovalForAll}.
     */
    function transferFrom(address from, address to, uint256 tokenId) public;
    function approve(address to, uint256 tokenId) public;
    function getApproved(uint256 tokenId) public view returns (address operator);

    function setApprovalForAll(address operator, bool _approved) public;
    function isApprovedForAll(address owner, address operator) public view returns (bool);


    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
}

// File: @openzeppelin/contracts-ethereum-package/contracts/utils/Address.sol

pragma solidity ^0.5.5;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * This test is non-exhaustive, and there may be false-negatives: during the
     * execution of a contract's constructor, its address will be reported as
     * not containing a contract.
     *
     * IMPORTANT: It is unsafe to assume that an address for which this
     * function returns false is an externally-owned account (EOA) and not a
     * contract.
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
    }

    /**
     * @dev Converts an `address` into `address payable`. Note that this is
     * simply a type cast: the actual underlying value is not changed.
     *
     * _Available since v2.4.0._
     */
    function toPayable(address account) internal pure returns (address payable) {
        return address(uint160(account));
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
     *
     * _Available since v2.4.0._
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

// File: contracts/ERC721Lending.sol

pragma solidity ^0.5.0;





contract Sablier {
  function createSalary(address recipient, uint256 deposit, address tokenAddress, uint256 startTime, uint256 stopTime) public returns(uint256);
  function cancelSalary(uint256 salaryId) public returns (bool);
}

contract ERC721Lending is Initializable {
  address public acceptedPayTokenAddress;

  struct ERC721ForLend {
    uint256 durationHours;
    uint256 initialWorth;
    uint256 earningGoal;
    uint256 borrowedAtTimestamp;
    address lender;
    address borrower;
    bool lenderClaimedCollateral;
    uint256 sablierSalaryId;
  }

  // V1 mapping
  mapping(address => mapping(uint256 => ERC721ForLend)) public lentERC721List;

  struct ERC721TokenEntry {
    address lenderAddress;
    address tokenAddress;
    uint256 tokenId;
  }

  ERC721TokenEntry[] public lendersWithTokens;

  event ERC721ForLendUpdated(address tokenAddress, uint256 tokenId);
  event ERC721ForLendRemoved(address tokenAddress, uint256 tokenId);

  address public sablierContractAddress;

  // V2, token address -> token id -> owner (lender) address -> lending details
  mapping(address => mapping(uint256 => mapping(address => ERC721ForLend))) public lendingPool;

  // Note: version helper for migrations
  uint256 migrateVersion;

  event ERC721ForLendUpdatedV2(address lenderAddress, address tokenAddress, uint256 tokenId);
  event ERC721ForLendRemovedV2(address lenderAddress, address tokenAddress, uint256 tokenId);

  function initialize(address tokenAddress) public initializer {
    acceptedPayTokenAddress = tokenAddress;
  }

  // V1 -> V2 single migration
  function migrateERC721ListToLendingPool() public {
    require(migrateVersion == 0, 'Migration: This version already migrated');

    uint totalCount = lendersWithTokens.length;
    if (totalCount > 1) {
      for (uint i = 0; i<totalCount; i++) {
        ERC721TokenEntry memory tokenEntry = lendersWithTokens[i];
        ERC721ForLend memory existingEntry = lentERC721List[tokenEntry.tokenAddress][tokenEntry.tokenId];
        lendingPool[tokenEntry.tokenAddress][tokenEntry.tokenId][existingEntry.lender] = ERC721ForLend(
          existingEntry.durationHours,
          existingEntry.initialWorth,
          existingEntry.earningGoal,
          existingEntry.borrowedAtTimestamp,
          existingEntry.lender,
          existingEntry.borrower,
          existingEntry.lenderClaimedCollateral,
          existingEntry.sablierSalaryId
        );
      }
    }

    migrateVersion = 1; // version up
  }

  function setSablierContractAddress(address contractAddress) public {
    require(sablierContractAddress == address(0), 'Sablier contract address already set');
    sablierContractAddress = contractAddress;
  }

  function setLendSettings(address tokenAddress, uint256 tokenId, uint256 durationHours, uint256 initialWorth, uint256 earningGoal) public {
    require(initialWorth > 0, 'Lending: Initial token worth must be above 0');
    require(earningGoal > 0, 'Lending: Earning goal must be above 0');
    require(durationHours > 0, 'Lending: Lending duration must be above 0');
    require(lentERC721List[tokenAddress][tokenId].borrower == address(0), 'Lending: Cannot change settings, token already lent');
    require(lentERC721List[tokenAddress][tokenId].lenderClaimedCollateral == false, 'Lending: Collateral already claimed');

    // assuming token transfer is approved
    IERC721(tokenAddress).transferFrom(msg.sender, address(this), tokenId);

    lentERC721List[tokenAddress][tokenId] = ERC721ForLend(durationHours, initialWorth, earningGoal, 0, msg.sender, address(0), false, 0);

    lendersWithTokens.push(ERC721TokenEntry(msg.sender, tokenAddress, tokenId));

    emit ERC721ForLendUpdated(tokenAddress, tokenId);
  }

  function startBorrowing(address tokenAddress, uint256 tokenId) public {
    require(lentERC721List[tokenAddress][tokenId].borrower == address(0), 'Borrowing: Already lent');
    require(lentERC721List[tokenAddress][tokenId].earningGoal > 0, 'Borrowing: Lender did not set earning goal yet');
    require(lentERC721List[tokenAddress][tokenId].initialWorth > 0, 'Borrowing: Lender did not set initial worth yet');

    IERC20 _payToken = IERC20(acceptedPayTokenAddress);
    uint256 _requiredSum = calculateLendSum(tokenAddress, tokenId);
    uint256 _allowedCollateral = _payToken.allowance(msg.sender, address(this));
    require(_allowedCollateral >= _requiredSum, 'Borrowing: Not enough collateral received');

    IERC20(acceptedPayTokenAddress).transferFrom(msg.sender, address(this), _requiredSum);

    // check if needs approval as some tokens fail due this
    (bool success,) = tokenAddress.call(abi.encodeWithSignature(
      "approve(address,uint256)",
      address(this),
      tokenId
    ));
    if (success) {
      IERC721(tokenAddress).approve(address(this), tokenId);
    }
    IERC721(tokenAddress).transferFrom(address(this), msg.sender, tokenId);

    lentERC721List[tokenAddress][tokenId].borrower = msg.sender;
    lentERC721List[tokenAddress][tokenId].borrowedAtTimestamp = now;

    address lenderAddress = lentERC721List[tokenAddress][tokenId].lender;

    // check if sablier address set and setup salary
    if (sablierContractAddress != address(0)) {
      uint256 _salaryStartTime = now + 60;
      uint256 _salaryStopTime = _salaryStartTime + (lentERC721List[tokenAddress][tokenId].durationHours * 3600);
      uint256 _actualSalaryAmount = lentERC721List[tokenAddress][tokenId].earningGoal;

      // per Sablier docs \u2013 deposit amount must be divided by the time delta
      // and then the remainder subtracted from the initial deposit number
      uint256 _timeDelta = _salaryStopTime - _salaryStartTime;
      uint256 _salaryAmount = _actualSalaryAmount - (_actualSalaryAmount % _timeDelta);

      _payToken.approve(sablierContractAddress, _salaryAmount);

      // the salary id is needed later to withdraw from or cancel the salary
      uint256 _sablierSalaryId = Sablier(sablierContractAddress).createSalary(lenderAddress, _salaryAmount, acceptedPayTokenAddress, _salaryStartTime, _salaryStopTime);
      lentERC721List[tokenAddress][tokenId].sablierSalaryId = _sablierSalaryId;
    }

    emit ERC721ForLendUpdated(tokenAddress, tokenId);
  }

  function stopBorrowing(address tokenAddress, uint256 tokenId) public {
    address _borrower = lentERC721List[tokenAddress][tokenId].borrower;
    require(_borrower == msg.sender, 'Borrowing: Can be stopped only by active borrower');

    if (lentERC721List[tokenAddress][tokenId].lenderClaimedCollateral == false) {
      // assuming token transfer is approved
      IERC721(tokenAddress).transferFrom(msg.sender, address(this), tokenId);

      uint256 _initialWorth = lentERC721List[tokenAddress][tokenId].initialWorth;

      IERC20(acceptedPayTokenAddress).transfer(_borrower, _initialWorth);

      lentERC721List[tokenAddress][tokenId].borrower = address(0);
      lentERC721List[tokenAddress][tokenId].borrowedAtTimestamp = 0;

      address lenderAddress = lentERC721List[tokenAddress][tokenId].lender;

      uint256 _sablierSalaryId = lentERC721List[tokenAddress][tokenId].sablierSalaryId;
      if (_sablierSalaryId != 0) {
        // cancel salary to lender if sablier salary exists
        Sablier(sablierContractAddress).cancelSalary(_sablierSalaryId);
        lentERC721List[tokenAddress][tokenId].sablierSalaryId = 0;
      } else {
        // send lender his interest
        uint256 _earningGoal = lentERC721List[tokenAddress][tokenId].earningGoal;
        IERC20(acceptedPayTokenAddress).transfer(lenderAddress, _earningGoal);
      }
    } else {
      // lender claimed collateral, this is borrower's last call, let's reset everything
      lentERC721List[tokenAddress][tokenId] = ERC721ForLend(0, 0, 0, 0, address(0), address(0), false, 0); // reset details
    }

    emit ERC721ForLendUpdated(tokenAddress, tokenId);
  }

  function calculateLendSum(address tokenAddress, uint256 tokenId) public view returns(uint256) {
    uint256 _earningGoal = lentERC721List[tokenAddress][tokenId].earningGoal;
    uint256 _initialWorth = lentERC721List[tokenAddress][tokenId].initialWorth;
    return _initialWorth + _earningGoal;
  }

  function isDurationExpired(uint256 borrowedAtTimestamp, uint256 durationHours) public view returns(bool) {
    uint256 secondsPassed = now - borrowedAtTimestamp;
    uint256 hoursPassed = secondsPassed * 60 * 60;
    return hoursPassed > durationHours;
  }

  function removeFromLendersWithTokens(address tokenAddress, uint256 tokenId) internal {
    // reset lenders to sent token mapping, swap with last element to fill the gap
    uint totalCount = lendersWithTokens.length;
    if (totalCount > 1) {
      for (uint i = 0; i<totalCount; i++) {
        ERC721TokenEntry memory tokenEntry = lendersWithTokens[i];
        if (tokenEntry.lenderAddress == msg.sender && tokenEntry.tokenAddress == tokenAddress && tokenEntry.tokenId == tokenId) {
          lendersWithTokens[i] = lendersWithTokens[totalCount-1]; // insert last from array
        }
      }
      lendersWithTokens.length--;
    } else {
      delete lendersWithTokens[0];
    }
  }

  function removeFromLending(address tokenAddress, uint256 tokenId) public {
    require(lentERC721List[tokenAddress][tokenId].lender == msg.sender, 'Claim: Cannot claim not owned lend');

    require(lentERC721List[tokenAddress][tokenId].borrower == address(0), 'Lending: Cannot cancel if lent');
    require(lentERC721List[tokenAddress][tokenId].lenderClaimedCollateral == false, 'Lending: Collateral claimed');

    // check if needs approval as some tokens fail due this
    (bool success,) = tokenAddress.call(abi.encodeWithSignature(
        "approve(address,uint256)",
        address(this),
        tokenId
      ));
    if (success) {
      IERC721(tokenAddress).approve(address(this), tokenId);
    }
    IERC721(tokenAddress).transferFrom(address(this), msg.sender, tokenId);

    lentERC721List[tokenAddress][tokenId] = ERC721ForLend(0, 0, 0, 0, address(0), address(0), false, 0); // reset details

    // reset lenders to sent token mapping, swap with last element to fill the gap
    removeFromLendersWithTokens(tokenAddress, tokenId);

    emit ERC721ForLendRemoved(tokenAddress, tokenId);
  }

  function claimBorrowerCollateral(address tokenAddress, uint256 tokenId) public {
    require(lentERC721List[tokenAddress][tokenId].borrower != address(0), 'Claim: Cannot claim if stopped');
    require(lentERC721List[tokenAddress][tokenId].lender == msg.sender, 'Claim: Cannot claim not owned lend');

    uint256 _borrowedAtTimestamp = lentERC721List[tokenAddress][tokenId].borrowedAtTimestamp;
    uint256 _durationHours = lentERC721List[tokenAddress][tokenId].durationHours;
    require(isDurationExpired(_borrowedAtTimestamp, _durationHours), 'Claim: Cannot claim before lending expired');

    require(lentERC721List[tokenAddress][tokenId].lenderClaimedCollateral == false, 'Claim: Already claimed');

    lentERC721List[tokenAddress][tokenId].lenderClaimedCollateral = true;

    uint256 _sablierSalaryId = lentERC721List[tokenAddress][tokenId].sablierSalaryId;
    if (_sablierSalaryId != 0) {
      // if salary exists cancel salary and send only initial worth collateral amount
      IERC20(acceptedPayTokenAddress).transfer(msg.sender, lentERC721List[tokenAddress][tokenId].initialWorth);
      Sablier(sablierContractAddress).cancelSalary(_sablierSalaryId);
      lentERC721List[tokenAddress][tokenId].sablierSalaryId = 0;
    } else {
      // send interest and collateral sum amount
      uint256 _collateralSum = calculateLendSum(tokenAddress, tokenId);
      IERC20(acceptedPayTokenAddress).transfer(msg.sender, _collateralSum);
    }

    // reset lenders to sent token mapping, swap with last element to fill the gap
    removeFromLendersWithTokens(tokenAddress, tokenId);

    emit ERC721ForLendUpdated(tokenAddress, tokenId);
  }

  function isValidNFT(address tokenAddress, uint256 tokenId) public view returns(bool) {
    // no owner is most likely burnt NFT
    return IERC721(tokenAddress).ownerOf(tokenId) != address(0);
  }
}

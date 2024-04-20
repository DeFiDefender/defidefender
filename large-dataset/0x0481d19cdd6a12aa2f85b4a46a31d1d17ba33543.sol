// File: browser/SafeMath.sol



// Taken from github.com/OpenZeppelin/openzeppelin-contracts/blob/5d34dbe/contracts/math/SafeMath.sol



pragma solidity ^0.5.0;

pragma experimental ABIEncoderV2;



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

     */

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b != 0, errorMessage);

        return a % b;

    }

}



// File: browser/CryptoLegacyBaseAPI.sol



interface CryptoLegacyBaseAPI {

  function getVersion() external view returns (uint);

  function getOwner() external view returns (address);

  function getContinuationContractAddress() external view returns (address);

  function isAcceptingKeeperProposals() external view returns (bool);

}



// File: browser/CryptoLegacy.sol



contract CryptoLegacy is CryptoLegacyBaseAPI {



  // Version of the contract API.

  uint public constant VERSION = 3;



  event KeysNeeded();

  event ContinuationContractAnnounced(address continuationContractAddress);

  event Cancelled();



  enum States {

    CallForKeepers,

    Active,

    CallForKeys,

    Cancelled

  }



  modifier atState(States _state) {

    require(state == _state, "0"); // error: invalid contract state

    _;

  }



  modifier atEitherOfStates(States state1, States state2) {

    require(state == state1 || state == state2, "1"); // error: invalid contract state

    _;

  }



  modifier ownerOnly() {

    require(msg.sender == owner, "2"); // error: tx sender must be the owner

    _;

  }



  modifier activeKeepersOnly() {

    require(isActiveKeeper(msg.sender), "3"); // error: tx sender must be an active keeper

    _;

  }



  struct KeeperProposal {

    address keeperAddress;

    bytes publicKey; // 64-byte

    uint keepingFee;

  }



  struct ActiveKeeper {

    bytes publicKey; // 64-byte

    bytes32 keyPartHash; // sha-3 hash

    uint keepingFee;

    uint balance;

    uint lastCheckInAt;

    bool keyPartSupplied;

  }



  struct EncryptedData {

    bytes encryptedData;

    bytes16 aesCounter;

    bytes32 dataHash; // sha-3 hash

    uint16 shareLength;

    bytes[] suppliedKeyParts;

  }



  struct ActiveKeeperDescription {

    address keeperAddress;

    uint balance;

    uint lastCheckInAt;

    bool keyPartSupplied;

  }



  struct Description {

    States state;

    uint checkInInterval;

    uint lastOwnerCheckInAt;

    KeeperProposal[] proposals;

    ActiveKeeperDescription[] keepers;

    uint checkInPrice;

  }



  address public owner;



  // When owner wants to elect new Keepers, she cancels the contract and starts a new one.

  // This variable contains the address of the new continuation contract.

  address public continuationContractAddress = address(0);



  uint public checkInInterval;

  uint public lastOwnerCheckInAt;



  States public state = States.CallForKeepers;



  bytes[] public encryptedKeyPartsChunks;

  EncryptedData public encryptedData;



  KeeperProposal[] public keeperProposals;

  mapping(address => bool) public proposedKeeperFlags;

  mapping(bytes32 => bool) private proposedPublicKeyHashes;



  mapping(address => ActiveKeeper) public activeKeepers;

  address[] public activeKeepersAddresses;



  // Sum of keeping fees of all active Keepers.

  uint public totalKeepingFee;



  // We need this because current version of Solidity doesn't support non-integer numbers.

  // We set it to be equal to number of wei in eth to make sure we transfer keeping fee with

  // enough precision.

  uint public constant KEEPING_FEE_ROUNDING_MULT = 1 ether;



  // Don't allow owner to specify check-in interval less than this when creating a new contract.

  uint public constant MINIMUM_CHECK_IN_INTERVAL = 1 minutes;





  // Called by the person who possesses the data they wish to transfer.

  // This person becomes the owner of the contract.

  //

  constructor(address _owner, uint _checkInInterval) public {

    require(_checkInInterval >= MINIMUM_CHECK_IN_INTERVAL, "4"); // error: check-in interval is too small

    require(_owner != address(0), "5"); // error: owner must not be zero

    owner = _owner;

    checkInInterval = _checkInInterval;

  }





  function describe() external view returns (Description memory) {

    ActiveKeeperDescription[] memory keepers = new ActiveKeeperDescription[](activeKeepersAddresses.length);



    for (uint i = 0; i < activeKeepersAddresses.length; i++) {

      address addr = activeKeepersAddresses[i];

      ActiveKeeper storage keeper = activeKeepers[addr];

      keepers[i] = ActiveKeeperDescription({

        keeperAddress: addr,

        balance: keeper.balance,

        lastCheckInAt: keeper.lastCheckInAt,

        keyPartSupplied: keeper.keyPartSupplied

      });

    }



    return Description({

      state: state,

      checkInInterval: checkInInterval,

      lastOwnerCheckInAt: lastOwnerCheckInAt,

      proposals: keeperProposals,

      keepers: keepers,

      checkInPrice: canCheckIn() ? calculateApproximateCheckInPrice() : 0

    });

  }





  function getVersion() public view returns (uint) {

    return VERSION;

  }





  function getOwner() public view returns (address) {

    return owner;

  }





  function getContinuationContractAddress() public view returns (address) {

    return continuationContractAddress;

  }





  function canCheckIn() public view returns (bool) {

    if (state != States.Active) {

      return false;

    }

    uint timeSinceLastOwnerCheckIn = SafeMath.sub(getBlockTimestamp(), lastOwnerCheckInAt);

    return timeSinceLastOwnerCheckIn <= checkInInterval;

  }





  function isAcceptingKeeperProposals() public view returns (bool) {

    return state == States.CallForKeepers;

  }





  function getNumProposals() external view returns (uint) {

    return keeperProposals.length;

  }





  function getNumKeepers() external view returns (uint) {

    return activeKeepersAddresses.length;

  }





  function getNumEncryptedKeyPartsChunks() external view returns (uint) {

    return encryptedKeyPartsChunks.length;

  }





  function getEncryptedKeyPartsChunk(uint index) external view returns (bytes memory) {

    return encryptedKeyPartsChunks[index];

  }





  function getNumSuppliedKeyParts() external view returns (uint) {

    return encryptedData.suppliedKeyParts.length;

  }





  function getSuppliedKeyPart(uint index) external view returns (bytes memory) {

    return encryptedData.suppliedKeyParts[index];

  }



  function isActiveKeeper(address addr) public view returns (bool) {

    return activeKeepers[addr].lastCheckInAt > 0;

  }



  function didSendProposal(address addr) public view returns (bool) {

    return proposedKeeperFlags[addr];

  }





  // Called by a Keeper to submit their proposal.

  //

  function submitKeeperProposal(bytes calldata publicKey, uint keepingFee) external

    atState(States.CallForKeepers)

  {

    require(msg.sender != owner, "6"); // error: tx sender must not be the owner

    require(!didSendProposal(msg.sender), "7"); // error: proposal was already sent by tx sender

    require(publicKey.length <= 128, "8"); // error: public key length is invalid



    bytes32 publicKeyHash = keccak256(publicKey);



    // error: public key was already used by another keeper

    require(!proposedPublicKeyHashes[publicKeyHash], "9");



    keeperProposals.push(KeeperProposal({

      keeperAddress: msg.sender,

      publicKey: publicKey,

      keepingFee: keepingFee

    }));



    proposedKeeperFlags[msg.sender] = true;

    proposedPublicKeyHashes[publicKeyHash] = true;

  }



  // Calculates how much would it cost the owner to activate contract with given Keepers.

  //

  function calculateActivationPrice(uint[] memory selectedProposalIndices) public view returns (uint) {

    uint _totalKeepingFee = 0;



    for (uint i = 0; i < selectedProposalIndices.length; i++) {

      uint proposalIndex = selectedProposalIndices[i];

      KeeperProposal storage proposal = keeperProposals[proposalIndex];

      _totalKeepingFee = SafeMath.add(_totalKeepingFee, proposal.keepingFee);

    }



    return _totalKeepingFee;

  }



  function acceptKeepersAndActivate(

    uint16 shareLength,

    bytes32 dataHash,

    bytes16 aesCounter,

    uint[] calldata selectedProposalIndices,

    bytes32[] calldata keyPartHashes,

    bytes calldata encryptedKeyParts,

    bytes calldata _encryptedData

  ) payable external

  {

    acceptKeepers(selectedProposalIndices, keyPartHashes, encryptedKeyParts);

    activate(shareLength, _encryptedData, dataHash, aesCounter);

  }



  // Called by owner to accept selected Keeper proposals.

  // May be called multiple times.

  //

  function acceptKeepers(

    uint[] memory selectedProposalIndices,

    bytes32[] memory keyPartHashes,

    bytes memory encryptedKeyParts

  ) public

    ownerOnly()

    atState(States.CallForKeepers)

  {

    // error: you must select an least one proposal to accept

    require(selectedProposalIndices.length > 0, "10");

    // error: lengths of proposal indices and key part hashes don't match

    require(keyPartHashes.length == selectedProposalIndices.length, "11");

    // error: encrypted key parts data must not be empty

    require(encryptedKeyParts.length > 0, "12");



    uint timestamp = getBlockTimestamp();

    uint chunkKeepingFee = 0;



    for (uint i = 0; i < selectedProposalIndices.length; i++) {

      uint proposalIndex = selectedProposalIndices[i];

      KeeperProposal storage proposal = keeperProposals[proposalIndex];



      // error: keeper has already been accepted

      require(activeKeepers[proposal.keeperAddress].lastCheckInAt == 0, "13");



      activeKeepers[proposal.keeperAddress] = ActiveKeeper({

        publicKey: proposal.publicKey,

        keyPartHash: keyPartHashes[i],

        keepingFee: proposal.keepingFee,

        lastCheckInAt: timestamp,

        balance: 0,

        keyPartSupplied: false

      });



      activeKeepersAddresses.push(proposal.keeperAddress);

      chunkKeepingFee = SafeMath.add(chunkKeepingFee, proposal.keepingFee);

    }



    totalKeepingFee = SafeMath.add(totalKeepingFee, chunkKeepingFee);

    encryptedKeyPartsChunks.push(encryptedKeyParts);

  }



  // Called by owner to activate the contract and distribute keys between Keepers

  // accepted previously using `acceptKeepers` function.

  //

  function activate(

    uint16 shareLength,

    bytes memory _encryptedData,

    bytes32 dataHash,

    bytes16 aesCounter

  ) payable public

    ownerOnly()

    atState(States.CallForKeepers)

  {

    require(activeKeepersAddresses.length > 0, "14"); // error: you must accept at least one keeper



    uint balance = address(this).balance;

    // error: balance is insufficient to pay keeping fee

    require(balance >= totalKeepingFee, "15");



    uint timestamp = getBlockTimestamp();

    lastOwnerCheckInAt = timestamp;



    for (uint i = 0; i < activeKeepersAddresses.length; i++) {

      ActiveKeeper storage keeper = activeKeepers[activeKeepersAddresses[i]];

      keeper.lastCheckInAt = timestamp;

    }



    encryptedData = EncryptedData({

      encryptedData: _encryptedData,

      aesCounter: aesCounter,

      dataHash: dataHash,

      shareLength: shareLength,

      suppliedKeyParts: new bytes[](0)

    });



    state = States.Active;

  }





  // Updates owner check-in time and credits all active Keepers with keeping fee.

  //

  function ownerCheckIn() payable external

    ownerOnly()

    atState(States.Active)

  {

    uint excessBalance = creditKeepers({prepayOneKeepingPeriodUpfront: true});



    lastOwnerCheckInAt = getBlockTimestamp();



    if (excessBalance > 0) {

      msg.sender.transfer(excessBalance);

    }

  }





  // Calculates approximate price of a check-in, given that it will be performed right now.

  // Actual price may differ because

  //

  function calculateApproximateCheckInPrice() public view returns (uint) {

    uint keepingFeeMult = calculateKeepingFeeMult();

    uint requiredBalance = 0;



    for (uint i = 0; i < activeKeepersAddresses.length; i++) {

      ActiveKeeper storage keeper = activeKeepers[activeKeepersAddresses[i]];

      uint balanceToAdd = SafeMath.mul(keeper.keepingFee, keepingFeeMult) / KEEPING_FEE_ROUNDING_MULT;

      uint newKeeperBalance = SafeMath.add(keeper.balance, balanceToAdd);

      requiredBalance = SafeMath.add(requiredBalance, newKeeperBalance);

    }



    requiredBalance = SafeMath.add(requiredBalance, totalKeepingFee);

    uint balance = address(this).balance;



    if (balance >= requiredBalance) {

      return 0;

    } else {

      return requiredBalance - balance;

    }

  }





  // Returns: excess balance that can be transferred back to owner.

  //

  function creditKeepers(bool prepayOneKeepingPeriodUpfront) internal returns (uint) {

    uint keepingFeeMult = calculateKeepingFeeMult();

    uint requiredBalance = 0;



    for (uint i = 0; i < activeKeepersAddresses.length; i++) {

      ActiveKeeper storage keeper = activeKeepers[activeKeepersAddresses[i]];

      uint balanceToAdd = SafeMath.mul(keeper.keepingFee, keepingFeeMult) / KEEPING_FEE_ROUNDING_MULT;

      keeper.balance = SafeMath.add(keeper.balance, balanceToAdd);

      requiredBalance = SafeMath.add(requiredBalance, keeper.balance);

    }



    if (prepayOneKeepingPeriodUpfront) {

      requiredBalance = SafeMath.add(requiredBalance, totalKeepingFee);

    }



    uint balance = address(this).balance;



    // error: balance is insufficient to pay keeping fee

    require(balance >= requiredBalance, "16");

    return balance - requiredBalance;

  }





  function calculateKeepingFeeMult() internal view returns (uint) {

    uint timeSinceLastOwnerCheckIn = SafeMath.sub(getBlockTimestamp(), lastOwnerCheckInAt);



    // error: owner has missed check-in time

    require(timeSinceLastOwnerCheckIn <= checkInInterval, "17");



    // ceil to 10 minutes

    if (timeSinceLastOwnerCheckIn == 0) {

      timeSinceLastOwnerCheckIn = 600;

    } else {

      timeSinceLastOwnerCheckIn = ceil(timeSinceLastOwnerCheckIn, 600);

    }



    if (timeSinceLastOwnerCheckIn > checkInInterval) {

      timeSinceLastOwnerCheckIn = checkInInterval;

    }



    return SafeMath.mul(KEEPING_FEE_ROUNDING_MULT, timeSinceLastOwnerCheckIn) / checkInInterval;

  }





  // Pays the Keeper their balance and updates their check-in time. Verifies that the owner

  // checked in in time and, if not, transfers the contract into CALL_FOR_KEYS state.

  //

  // A Keeper can call this method to get his reward regardless of the contract state.

  //

  function keeperCheckIn() external

    activeKeepersOnly()

  {

    uint timestamp = getBlockTimestamp();



    ActiveKeeper storage keeper = activeKeepers[msg.sender];

    keeper.lastCheckInAt = timestamp;



    if (state == States.Active) {

      uint timeSinceLastOwnerCheckIn = SafeMath.sub(timestamp, lastOwnerCheckInAt);

      if (timeSinceLastOwnerCheckIn > checkInInterval) {

        state = States.CallForKeys;

        emit KeysNeeded();

      }

    }



    uint keeperBalance = keeper.balance;

    if (keeperBalance > 0) {

      keeper.balance = 0;

      msg.sender.transfer(keeperBalance);

    }

  }





  // Called by Keepers to supply their decrypted key parts.

  //

  function supplyKey(bytes calldata keyPart) external

    activeKeepersOnly()

    atState(States.CallForKeys)

  {

    ActiveKeeper storage keeper = activeKeepers[msg.sender];

    require(!keeper.keyPartSupplied, "18"); // error: this keeper has already supplied a key



    bytes32 suppliedKeyPartHash = keccak256(keyPart);

    require(suppliedKeyPartHash == keeper.keyPartHash, "19"); // error: unexpected key supplied



    encryptedData.suppliedKeyParts.push(keyPart);

    keeper.keyPartSupplied = true;



    // Include one-period keeping fee that was held by contract in advance.

    uint toBeTransferred = SafeMath.add(keeper.balance, keeper.keepingFee);

    keeper.balance = 0;



    if (toBeTransferred > 0) {

      msg.sender.transfer(toBeTransferred);

    }

  }





  // Allows owner to announce continuation contract to all active Keepers.

  //

  // Continuation contract is used to elect new set of Keepers, e.g. to replace inactive ones.

  // When the continuation contract gets sufficient number of keeping proposals, owner will

  // cancel this contract and start the continuation one.

  //

  function announceContinuationContract(address _continuationContractAddress) external

    ownerOnly()

    atState(States.Active)

  {

    // error: continuation contract already announced

    require(continuationContractAddress == address(0), "20");

    // error: continuation contract cannot have the same address

    require(_continuationContractAddress != address(this), "21");



    CryptoLegacyBaseAPI continuationContract = CryptoLegacyBaseAPI(_continuationContractAddress);



    // error: continuation contract must have the same owner

    require(continuationContract.getOwner() == getOwner(), "22");

    // error: continuation contract must be at least the same version

    require(continuationContract.getVersion() >= getVersion(), "23");

    // error: continuation contract must be accepting keeper proposals

    require(continuationContract.isAcceptingKeeperProposals(), "24");



    continuationContractAddress = _continuationContractAddress;

    emit ContinuationContractAnnounced(_continuationContractAddress);

  }





  // Cancels the contract and notifies the Keepers. Credits all active Keepers with keeping fee,

  // as if this was a check-in.

  //

  function cancel() payable external

    ownerOnly()

    atEitherOfStates(States.CallForKeepers, States.Active)

  {

    uint excessBalance = 0;



    if (state == States.Active) {

      // We don't require paying one keeping period upfront as the contract is being cancelled;

      // we just require paying till the present moment.

      excessBalance = creditKeepers({prepayOneKeepingPeriodUpfront: false});

    }



    state = States.Cancelled;

    emit Cancelled();



    if (excessBalance > 0) {

      msg.sender.transfer(excessBalance);

    }

  }





  // We can rely on the value of now (block.timestamp) for our purposes, as the consensus

  // rule is that a block's timestamp must be 1) more than the parent's block timestamp;

  // and 2) less than the current wall clock time. See:

  // https://github.com/ethereum/go-ethereum/blob/885c13c/consensus/ethash/consensus.go#L223

  //

  function getBlockTimestamp() internal view returns (uint) {

    return now;

  }





  // See: https://stackoverflow.com/a/2745086/804678

  //

  function ceil(uint x, uint y) internal pure returns (uint) {

    if (x == 0) return 0;

    return SafeMath.mul(1 + SafeMath.div(x - 1, y), y);

  }



}



// File: browser/Registry.sol



contract Registry {

  event NewContract(string id, address addr, uint totalContracts);



  struct Contract {

    address initialAddress;

    address currentAddress;

  }



  mapping(address => string[]) internal contractsByOwner;

  mapping(string => Contract) internal contractsById;

  string[] public contracts;



  function getNumContracts() external view returns (uint) {

    return contracts.length;

  }



  function getContractAddress(string calldata id) external view returns (address) {

    return contractsById[id].currentAddress;

  }



  function getContractInitialAddress(string calldata id) external view returns (address) {

    return contractsById[id].initialAddress;

  }



  function getNumContractsByOwner(address owner) external view returns (uint) {

    return contractsByOwner[owner].length;

  }



  function getContractByOwner(address owner, uint index) external view returns (string memory) {

    return contractsByOwner[owner][index];

  }



  function deployAndRegisterContract(string calldata id, uint checkInInterval)

    external

    payable

    returns (CryptoLegacy)

  {

    CryptoLegacy instance = new CryptoLegacy(msg.sender, checkInInterval);

    addContract(id, address(instance));

    return instance;

  }



  function addContract(string memory id, address addr) public {

    // error: contract with the same id already registered

    require(contractsById[id].initialAddress == address(0), "R1");



    CryptoLegacyBaseAPI instance = CryptoLegacyBaseAPI(addr);

    address owner = instance.getOwner();



    // error: tx sender must be contract owner

    require(msg.sender == owner, "R2");



    contracts.push(id);

    contractsByOwner[owner].push(id);

    contractsById[id] = Contract({initialAddress: addr, currentAddress: addr});



    emit NewContract(id, addr, contracts.length);

  }



  function updateAddress(string calldata id) external {

    Contract storage ctr = contractsById[id];

    // error: cannot find contract with the supplied id

    require(ctr.currentAddress != address(0), "R3");



    CryptoLegacyBaseAPI instance = CryptoLegacyBaseAPI(ctr.currentAddress);

    // error: tx sender must be contract owner

    require(instance.getOwner() == msg.sender, "R4");



    address continuationAddress = instance.getContinuationContractAddress();

    if (continuationAddress == address(0)) {

      return;

    }



    CryptoLegacyBaseAPI continuationInstance = CryptoLegacyBaseAPI(continuationAddress);

    // error: tx sender must be contract owner

    require(continuationInstance.getOwner() == msg.sender, "R5");

    // error: continuation contract must be at least the same version

    require(continuationInstance.getVersion() >= instance.getVersion(), "R6");



    ctr.currentAddress = continuationAddress;



    // TODO: here we're adding the same id to the contracts array one more time; this allows Keeper

    // clients that didn't participate in the contract and that were offline at the moment to later

    // discover the continuation contract and send proposals.

    //

    // Ideally, we need to use logs/events filtering instead of relying on contracts array, but

    // currently filtering works unreliably with light clients.

    //

    contracts.push(id);

    emit NewContract(id, continuationAddress, contracts.length);

  }



}

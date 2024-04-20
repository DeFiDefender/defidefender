/**

 * Copyright (c) 2018-present, Leap DAO (leapdao.org)

 *

 * This source code is licensed under the Mozilla Public License, version 2,

 * found in the LICENSE file in the root directory of this source tree.

 */

pragma solidity 0.5.2;

pragma experimental ABIEncoderV2;





interface IColony {



  struct Payment {

    address payable recipient;

    bool finalized;

    uint256 fundingPotId;

    uint256 domainId;

    uint256[] skills;

  }



  // Implemented in ColonyPayment.sol

  /// @notice Add a new payment in the colony. Secured function to authorised members.

  /// @param _permissionDomainId The domainId in which I have the permission to take this action

  /// @param _childSkillIndex The index that the `_domainId` is relative to `_permissionDomainId`,

  /// (only used if `_permissionDomainId` is different to `_domainId`)

  /// @param _recipient Address of the payment recipient

  /// @param _token Address of the token, `0x0` value indicates Ether

  /// @param _amount Payout amount

  /// @param _domainId The domain where the payment belongs

  /// @param _skillId The skill associated with the payment

  /// @return paymentId Identifier of the newly created payment

  function addPayment(

    uint256 _permissionDomainId,

    uint256 _childSkillIndex,

    address payable _recipient,

    address _token,

    uint256 _amount,

    uint256 _domainId,

    uint256 _skillId)

    external returns (uint256 paymentId);



  /// @notice Returns an exiting payment.

  /// @param _id Payment identifier

  /// @return payment The Payment data structure

  function getPayment(uint256 _id) external view returns (Payment memory payment);



  /// @notice Move a given amount: `_amount` of `_token` funds from funding pot with id `_fromPot` to one with id `_toPot`.

  /// @param _permissionDomainId The domainId in which I have the permission to take this action

  /// @param _fromChildSkillIndex The child index in `_permissionDomainId` where we can find the domain for `_fromPotId`

  /// @param _toChildSkillIndex The child index in `_permissionDomainId` where we can find the domain for `_toPotId`

  /// @param _fromPot Funding pot id providing the funds

  /// @param _toPot Funding pot id receiving the funds

  /// @param _amount Amount of funds

  /// @param _token Address of the token, `0x0` value indicates Ether

  function moveFundsBetweenPots(

    uint256 _permissionDomainId,

    uint256 _fromChildSkillIndex,

    uint256 _toChildSkillIndex,

    uint256 _fromPot,

    uint256 _toPot,

    uint256 _amount,

    address _token

    ) external;



  /// @notice Finalizes the payment and logs the reputation log updates.

  /// Allowed to be called once after payment is fully funded. Secured function to authorised members.

  /// @param _permissionDomainId The domainId in which I have the permission to take this action

  /// @param _childSkillIndex The index that the `_domainId` is relative to `_permissionDomainId`

  /// @param _id Payment identifier

  function finalizePayment(uint256 _permissionDomainId, uint256 _childSkillIndex, uint256 _id) external;



  /// @notice Claim the payout in `_token` denomination for payment `_id`. Here the network receives its fee from each payout.

  /// Same as for tasks, ether fees go straight to the Meta Colony whereas Token fees go to the Network to be auctioned off.

  /// @param _id Payment identifier

  /// @param _token Address of the token, `0x0` value indicates Ether

  function claimPayment(uint256 _id, address _token) external;

}



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



contract BountyPayout {



  uint256 constant PERMISSION_DOMAIN_ID = 1;

  uint256 constant CHILD_SKILL_INDEX = 0;

  uint256 constant DOMAIN_ID = 1;

  uint256 constant SKILL_ID = 0;



  address public payerAddr;

  address public colonyAddr;

  address public daiAddr;

  address public leapAddr;



  enum PayoutType { Gardener, Worker, Reviewer }

  event Payout(

    bytes32 indexed bountyId,

    PayoutType indexed payoutType,

    address indexed recipient,

    uint256 amount,

    uint256 paymentId

  );



  constructor(

    address _payerAddr,

    address _colonyAddr,

    address _daiAddr,

    address _leapAddr) public {

    payerAddr = _payerAddr;

    colonyAddr = _colonyAddr;

    daiAddr = _daiAddr;

    leapAddr = _leapAddr;

  }



  modifier onlyPayer() {

    require(msg.sender == payerAddr, "Only payer can call");

    _;

  }



  function _makeColonyPayment(address payable _worker, uint256 _amount) internal returns (uint256) {



    IColony colony = IColony(colonyAddr);

    // Add a new payment

    uint256 paymentId = colony.addPayment(

      PERMISSION_DOMAIN_ID,

      CHILD_SKILL_INDEX,

      _worker,

      leapAddr,

      _amount,

      DOMAIN_ID,

      SKILL_ID

    );

    IColony.Payment memory payment = colony.getPayment(paymentId);



    // Fund the payment

    colony.moveFundsBetweenPots(

      1, // Root domain always 1

      0, // Not used, this extension contract must have funding permission in the root for this function to work

      CHILD_SKILL_INDEX,

      1, // Root domain funding pot is always 1

      payment.fundingPotId,

      _amount,

      leapAddr

    );

    colony.finalizePayment(PERMISSION_DOMAIN_ID, CHILD_SKILL_INDEX, paymentId);



    // Claim payout on behalf of the recipient

    colony.claimPayment(paymentId, leapAddr);

    return paymentId;

  }



  function _payout(

    address payable _gardenerAddr,

    uint256 _gardenerDaiAmount,

    address payable _workerAddr,

    uint256 _workerDaiAmount,

    address payable _reviewerAddr,

    uint256 _reviewerDaiAmount,

    bytes32 _bountyId

  ) internal  {



    IERC20 dai = IERC20(daiAddr);



    // handle worker

    uint256 paymentId = _makeColonyPayment(_gardenerAddr, _gardenerDaiAmount);

    dai.transferFrom(payerAddr, _gardenerAddr, _gardenerDaiAmount);

    emit Payout(_bountyId, PayoutType.Gardener, _gardenerAddr, _gardenerDaiAmount, paymentId);



    // handle worker

    if (_workerDaiAmount > 0) {

      paymentId = _makeColonyPayment(_workerAddr, _workerDaiAmount);

      dai.transferFrom(payerAddr, _workerAddr, _workerDaiAmount);

      emit Payout(_bountyId, PayoutType.Worker, _workerAddr, _workerDaiAmount, paymentId);

    }



    // handle reviewer

    if (_reviewerDaiAmount > 0) {

      paymentId = _makeColonyPayment(_reviewerAddr, _reviewerDaiAmount);

      dai.transferFrom(payerAddr, _reviewerAddr, _reviewerDaiAmount);

      emit Payout(_bountyId, PayoutType.Reviewer, _reviewerAddr, _reviewerDaiAmount, paymentId);

    }

  }



 /**

  * Pays out a bounty to the different roles of a bounty

  *

  * @dev This contract should have enough allowance of daiAddr from payerAddr

  * @dev This colony contract should have enough LEAP in its funding pot

  * @param _gardenerAddr gardener wallet address

  * @param _gardenerDaiAmount DAI amount to pay gardner

  * @param _workerAddr worker wallet address

  * @param _workerDaiAmount DAI amount to pay worker

  * @param _reviewerAddr reviewer wallet address

  * @param _reviewerDaiAmount DAI amount to pay reviewer

  */

  function payout(

    address payable _gardenerAddr,

    uint256 _gardenerDaiAmount,

    address payable _workerAddr,

    uint256 _workerDaiAmount,

    address payable _reviewerAddr,

    uint256 _reviewerDaiAmount,

    bytes32 _bountyId

  ) public onlyPayer {

    _payout(

      _gardenerAddr,

      _gardenerDaiAmount,

      _workerAddr,

      _workerDaiAmount,

      _reviewerAddr,

      _reviewerDaiAmount,

      _bountyId

    );

  }



  function payoutNoWorker(

    address payable _gardenerAddr,

    uint256 _gardenerDaiAmount,

    address payable _reviewerAddr,

    uint256 _reviewerDaiAmount,

    bytes32 _bountyId

  ) public onlyPayer {

    _payout(

      _gardenerAddr,

      _gardenerDaiAmount,

      _reviewerAddr,

      0,

      _reviewerAddr,

      _reviewerDaiAmount,

      _bountyId

    );

  }



  function payoutNoReviewer(

    address payable _gardenerAddr,

    uint256 _gardenerDaiAmount,

    address payable _workerAddr,

    uint256 _workerDaiAmount,

    bytes32 _bountyId

  ) public onlyPayer {

    _payout(

      _gardenerAddr,

      _gardenerDaiAmount,

      _workerAddr,

      _workerDaiAmount,

      _workerAddr,

      0,

      _bountyId

    );

  }

}

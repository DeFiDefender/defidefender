pragma solidity ^0.6.0;

pragma experimental ABIEncoderV2;



/**

 * @dev Collection of functions related to the address type

 */

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

        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts

        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned

        // for accounts without code, i.e. `keccak256('')`

        bytes32 codehash;

        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;

        // solhint-disable-next-line no-inline-assembly

        assembly { codehash := extcodehash(account) }

        return (codehash != accountHash && codehash != 0x0);

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

}



library AuctionLib {



  using Address for address payable;



  enum Result {

    UNSET,

    MISS,

    HIT

  }



  struct Bid {

    address payable bidder;

    uint amount;

    uint16[2] move;

  }



  struct Data {

    Bid leadingBid;

    Result result;



    // Start the auction at a later point in time

    uint256 startTime;

    // How long the auction runs after the first bid

    uint256 duration;

    // When the auction ends

    uint256 endTime;

  }



  function placeBid(

    Data storage data,

    uint16[2] memory move

  ) public returns(uint256){

    // Validate auction

    require(hasStarted(data), "Auction has not started");

    require(!hasEnded(data), "Auction has ended");



    // Validate input

    require(msg.value > data.leadingBid.amount, "Bid must be greater than current bid");



    Bid memory previousBid = data.leadingBid;



    data.leadingBid = Bid(tx.origin, msg.value, move);



    // First bid, auction is started and will end after duration from now

    if (data.endTime == 0) {

      data.endTime = now + data.duration;

    }



    // Transfer the bid back to the previous bidder

    if (previousBid.bidder != address(0)) {

      previousBid.bidder.sendValue(previousBid.amount);

    }



    return data.endTime;

  }



  function setResult(Data storage data, bool hit) public {

    require(hasEnded(data), "Auction has not yet ended");

    require(data.result == Result.UNSET, "Auction result already set");

    data.result = hit ? Result.HIT : Result.MISS;

  }



  /* End the auction immediately,

     this is used when the other team wins to stop it instantly,

     return the funds to the leading bidder

   */

  function cancel(Data storage data) public {

    if (!hasEnded(data)) {

      data.endTime = now - 1;

    }



    if (data.leadingBid.bidder != address(0)) {

      data.leadingBid.bidder.sendValue(data.leadingBid.amount);



      data.leadingBid = Bid(address(0), 0, [uint16(0), uint16(0)]);

    }

  }



  function hasStarted(Data storage data) public view returns(bool) {

    return now >= data.startTime;

  }



  function hasEnded(Data storage data) public view returns(bool) {

    return data.endTime != 0 && now > data.endTime;

  }

}

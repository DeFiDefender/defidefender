pragma solidity ^0.5.0;



// --------------------------------------------------------------------------

// Forward declarations of the external functions called by this contract

// --------------------------------------------------------------------------



interface ERC20 {

  function transfer( address to, uint256 value ) external returns (bool);

  function transferFrom( address from, address to, uint256 value )

    external returns (bool);

}



interface ERC721 {

  function transferFrom( address _from, address _to, uint256 _tokenId )

    external payable;

}



interface ENS {

  function setOwner( bytes32 _node, address _owner ) external;

}



// --------------------------------------------------------------------------

// admin can assign a new admin, set the fee, release new UIs and change the

// ENS mapping

// * admin cannot interfere with any Order.

// * admin cannot sweep funds paid to an Order

// * ADMIN CANNOT RECOVER ERC20 TOKENS SENT DIRECTLY TO THIS CONTRACT ADDRESS

// * ALWAYS use token.approve() then call buy() below

// --------------------------------------------------------------------------



contract Admin {

  modifier isAdmin {

    require( msg.sender == admin, "!admin" );

    _;

  }

  address payable public admin;

  constructor() public {

    admin = msg.sender;

  }

  function setAdmin( address payable _newAdmin ) public isAdmin {

    admin = _newAdmin;

  }

}



// ==========================================================================

// escrobot.eth is an automated escrow service. A buyer will pay with ETH or

// any ERC20-compatible token, and a seller will ship and provide a tracking

// reference.

//

// Normal Scenario:

//

// 1. Seller submits an Order

// 2. Buyer pays escrobot the Seller's demand plus a bond, an amount set by

//    the Seller to ensure the Buyer will confirm delivery and release payment

// 3. Seller ships and updates the Order with the tracking reference

// 4. Buyer tracks and confirms receipt of the Order

// 5. escrobot pays Seller and returns Buyer's bond

//

// Exceptions/Extras:

//

// a. Seller may cancel an Order not yet paid (Buyer has disappeared)

// b. Buyer may obtain a refund if Seller fails to ship within a

//    Seller-specified timeout in blocks (Seller has disappeared)

// c. Either party may add a plaintext note at any time to resolve issues

// d. If shipment fails, payment will not be released and bond will not be

//    returned unless/until the Buyer confirms. Must be resolved in meatspace.

//

// WARNING: never send ETH to this contract directly. Include value for

//          payment within the transaction when calling the buy() function.

//

// WARNING: if arranging sale by ERC20 token, take special care of the token

//          SCA passed to submit() - escrobot will confirm that a smart

//          contract exists there, but takes no additional steps to confirm

//          whatever is at that address is an ERC20 token contract.

//

// WARNING: never transfer() tokens to this smart contract. Use the token

//          contract's approve() function, and then call the buy() function

//          on this contract, which will transferFrom() the token contract.

//

// Admin may publish() a user interface by setting two public variables:

//

//   externalLink : an ipfs hash or url from which to download the bundle

//   hexSignature : admin's digital signature of the bundle

//

// ==========================================================================



contract escrobot is Admin {



  event UIReleased( string version, string link, string sig );



  event Submitted( bytes32 indexed orderId, address indexed seller );



  event Canceled( bytes32 indexed orderId, address indexed seller );



  event Paid( bytes32 indexed orderId, address indexed buyer );



  event TimedOut( bytes32 indexed orderId, address indexed buyer );



  event Shipped( bytes32 indexed orderId,

                 string shipRef,

                 address indexed seller );



  event Completed( bytes32 indexed orderId, address indexed buyer );



  event Noted( bytes32 indexed orderId, string note, address indexed noter );



  enum State { SUBMITTED, CANCELED, PAID, TIMEDOUT, SHIPPED, COMPLETED }



  struct Order {

    address payable seller;

    address payable buyer;

    string description;

    uint256 price;        // in units of ...

    address token;        // ERC20 token sca, or address(0x0) for ETH/wei

    uint256 bond;         // same units

    uint256 timeoutBlocks;

    uint256 takenBlock;

    string shipRef;

    State status;

  }



  string public externalLink;

  string public hexSignature;



  mapping( bytes32 => Order ) public orders;

  uint256 public fee;

  uint256 public counter;

  bytes4 public magic; // must be returned by onERC721Received() function



  // ------------------------------------------------------------------------

  // Supporting/internal functions

  // ------------------------------------------------------------------------



  modifier isSeller( bytes32 _orderId ) {

    require( msg.sender == orders[_orderId].seller, "only seller" );

    _;

  }

  modifier isBuyer( bytes32 _orderId ) {

    require( msg.sender == orders[_orderId].buyer, "only buyer" );

    _;

  }



  function isContract( address _addr ) private view returns (bool) {

    uint32 size;

    assembly {

      size := extcodesize(_addr)

    }

    return (size > 0);

  }



  function status( bytes32 _orderId ) public view returns (State) {

    return orders[_orderId].status;

  }



  // -------------------------------------------------------------------------

  // Core business functions

  // -------------------------------------------------------------------------



  // 1. Seller creates the Order and pays the escrobot fee



  function submit( string memory _desc,

                   uint256 _price,

                   address _token,

                   uint256 _bond,

                   uint256 _timeoutBlocks ) payable public {



    require( bytes(_desc).length > 1, "needs description" );

    require( _price > 0, "needs price" );

    require( _token == address(0x0) || isContract(_token), "bad token" );

    require( _price + _bond >= _price, "safemath" );

    require( _timeoutBlocks > 0, "needs timeout" );

    require( msg.value >= fee, "needs fee" );



    bytes32 orderId = keccak256( abi.encodePacked(

      counter++, _desc, _price, _token, _bond, _timeoutBlocks, now) );



    orders[orderId].seller = msg.sender;

    orders[orderId].description = _desc;

    orders[orderId].price = _price;

    orders[orderId].token = _token;

    orders[orderId].bond = _bond;

    orders[orderId].timeoutBlocks = _timeoutBlocks;

    orders[orderId].status = State.SUBMITTED;



    emit Submitted( orderId, msg.sender );

    admin.transfer( msg.value );

  }



  // 1a. Seller may cancel the order before Buyer has paid



  function cancel( bytes32 _orderId ) public isSeller(_orderId) {



    require( orders[_orderId].status == State.SUBMITTED, "not SUBMITTED" );

    orders[_orderId].status = State.CANCELED;

    emit Canceled( _orderId, msg.sender );

  }



  // 2. Buyer pays sellers demand plus the bond/deposit.

  //    If paying by ERC20, the buyer must already have called approve()



  function buy( bytes32 _orderId ) payable public {



    require( orders[_orderId].status == State.SUBMITTED, "not SUBMITTED" );



    uint256 needed = orders[_orderId].price + orders[_orderId].bond;



    if (orders[_orderId].token == address(0x0)) {

      require( msg.value >= needed, "insufficient ETH" );

      if (msg.value > needed)

        admin.transfer( msg.value - needed );

    }

    else {

      require( ERC20(orders[_orderId].token).transferFrom(msg.sender,

        address(this), needed), "transferFrom()" );

    }



    orders[_orderId].buyer = msg.sender;

    orders[_orderId].takenBlock = block.number;

    orders[_orderId].status = State.PAID;

    emit Paid( _orderId, msg.sender );

  }



  // 2b. If the seller fails to ship within the promised number of blocks, the

  // buyer may reclaim his payment and bond



  function timeout( bytes32 _orderId ) public isBuyer(_orderId) {



    require( orders[_orderId].status == State.PAID, "not PAID" );

    require( block.number > orders[_orderId].takenBlock +

                            orders[_orderId].timeoutBlocks, "too early" );

    require( bytes(orders[_orderId].shipRef).length == 0, "shipped already" );



    uint256 total = orders[_orderId].price + orders[_orderId].bond;



    if ( orders[_orderId].token == address(0x0) ) {

      orders[_orderId].buyer.transfer( total );

    }

    else {

      ERC20(orders[_orderId].token).transfer( orders[_orderId].buyer, total );

    }



    orders[_orderId].buyer = address(0x0);

    orders[_orderId].takenBlock = 0;

    orders[_orderId].status = State.TIMEDOUT;

    emit TimedOut( _orderId, msg.sender );

  }



  // 3. Seller provides the shipping/tracking reference information.



  function ship( bytes32 _orderId, string memory _shipRef )

  public isSeller(_orderId) {



    require(   orders[_orderId].status == State.PAID

            || orders[_orderId].status == State.SHIPPED, "ship state invalid" );



    require( bytes(_shipRef).length > 1, "Ref invalid" );



    orders[_orderId].shipRef = _shipRef;

    orders[_orderId].status = State.SHIPPED;

    emit Shipped( _orderId, _shipRef, msg.sender );

  }



  // 4. Buyer confirms order has arrived and completes deal.



  function confirm( bytes32 _orderId ) public isBuyer(_orderId) {



    require( orders[_orderId].status == State.SHIPPED, "not SHIPPED" );



    // 5. escrobot pays Seller and refunds Buyer



    if ( orders[_orderId].token == address(0x0) ) {

      orders[_orderId].seller.transfer( orders[_orderId].price );

      orders[_orderId].buyer.transfer( orders[_orderId].bond );

    }

    else {

      ERC20( orders[_orderId].token )

      .transfer( orders[_orderId].buyer, orders[_orderId].bond );



      ERC20( orders[_orderId].token )

      .transfer( orders[_orderId].seller, orders[_orderId].price );

    }



    orders[_orderId].status = State.COMPLETED;

    emit Completed( _orderId, msg.sender );

  }



  // Buyer and Seller can attach unencrypted notes for dispute resolution etc



  function note( bytes32 _orderId, string memory _noteplaintxt ) public {



    require(    msg.sender == orders[_orderId].buyer

             || msg.sender == orders[_orderId].seller, "parties only" );



    emit Noted( _orderId, _noteplaintxt, msg.sender );

  }



  // --------------------------------------------------------------------------

  // Admin functions

  // --------------------------------------------------------------------------



  constructor () public {

    fee = 2000 szabo;



    magic = bytes4( keccak256(

      abi.encodePacked("onERC721Received(address,address,uint256,bytes)")) );

  }



  function setFee( uint256 _newfee ) public isAdmin {

    fee = _newfee;

  }



  function publish( string memory _version, string memory _link,

    string memory _sig ) public isAdmin {



    externalLink = _link;

    hexSignature = _sig;

    emit UIReleased( _version, _link, _sig );

  }



  function changeENSOwner( address _ens, bytes32 _node, address payable _to )

  external isAdmin {

    ENS(_ens).setOwner( _node, _to );

  }



  // ----------------------------------------------------------------------

  // functions to catch errant payments and transfers

  // ----------------------------------------------------------------------



  function() external payable {

    admin.transfer( msg.value );

  }



  function tokenFallback( address _from, uint _value, bytes calldata _data )

  external {



    if (_from == address(0x0) || _data.length > 0) {

      // suppress warnings unused param

    }



    ERC20(msg.sender).transfer( admin, _value );

  }



  function onERC721Received(address _operator, address _from, uint256 _tokenId,

    bytes calldata _data) external returns(bytes4) {



    if (   _operator == address(0x0)

        || _from == address(0x0)

        || _data.length > 0 ) {

      // suppress warnings unused param

    }



    ERC721(msg.sender).transferFrom( address(this), admin, _tokenId );

    return magic;

  }



}

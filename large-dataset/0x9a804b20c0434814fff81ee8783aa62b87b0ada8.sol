pragma solidity ^0.5.12; 



library DSMath {

    function add(uint x, uint y) internal pure returns (uint z) {

        require((z = x + y) >= x, "ds-math-add-overflow");

    }

    function sub(uint x, uint y) internal pure returns (uint z) {

        require((z = x - y) <= x, "ds-math-sub-underflow");

    }

    function mul(uint x, uint y) internal pure returns (uint z) {

        require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");

    }



    function min(uint x, uint y) internal pure returns (uint z) {

        return x <= y ? x : y;

    }

    function max(uint x, uint y) internal pure returns (uint z) {

        return x >= y ? x : y;

    }

    function imin(int x, int y) internal pure returns (int z) {

        return x <= y ? x : y;

    }

    function imax(int x, int y) internal pure returns (int z) {

        return x >= y ? x : y;

    }



    uint constant WAD = 10 ** 18;

    uint constant RAY = 10 ** 27;



    function wmul(uint x, uint y) internal pure returns (uint z) {

        z = add(mul(x, y), WAD / 2) / WAD;

    }

    function rmul(uint x, uint y) internal pure returns (uint z) {

        z = add(mul(x, y), RAY / 2) / RAY;

    }

    function wdiv(uint x, uint y) internal pure returns (uint z) {

        z = add(mul(x, WAD), y / 2) / y;

    }

    function rdiv(uint x, uint y) internal pure returns (uint z) {

        z = add(mul(x, RAY), y / 2) / y;

    }



    // This famous algorithm is called "exponentiation by squaring"

    // and calculates x^n with x as fixed-point and n as regular unsigned.

    //

    // It's O(log n), instead of O(n) for naive repeated multiplication.

    //

    // These facts are why it works:

    //

    //  If n is even, then x^n = (x^2)^(n/2).

    //  If n is odd,  then x^n = x * x^(n-1),

    //   and applying the equation for even x gives

    //    x^n = x * (x^2)^((n-1) / 2).

    //

    //  Also, EVM division is flooring and

    //    floor[(n-1) / 2] = floor[n / 2].

    //

    function rpow(uint x, uint n) internal pure returns (uint z) {

        z = n % 2 != 0 ? x : RAY;



        for (n /= 2; n != 0; n /= 2) {

            x = rmul(x, x);



            if (n % 2 != 0) {

                z = rmul(z, x);

            }

        }

    }

    

}



interface CErc20 { 

    

    function totalSupply() external view returns (uint);

    function balanceOf(address tokenOwner) external view returns (uint balance);

    function allowance(address tokenOwner, address spender) external view returns (uint remaining);

    function transfer(address to, uint tokens) external returns (bool success);

    function approve(address spender, uint tokens) external returns (bool success);

    function transferFrom(address from, address to, uint tokens) external returns (bool success);

}



interface InterestProxy { 

    function sweep(address beneficiary, address paymentToken, uint amount) payable external; 

    function widthdraw(address beneficiary, address paymentToken, uint amount) external; 

    

}



interface ERC721 /* is ERC165 */ {

           

    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);

    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    function balanceOf(address _owner) external view returns (uint256);

    function ownerOf(uint256 _tokenId) external view returns (address);

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external payable;

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;

    function transferFrom(address _from, address _to, uint256 _tokenId) external payable;

    function approve(address _approved, uint256 _tokenId) external payable;

    function setApprovalForAll(address _operator, bool _approved) external;

    function getApproved(uint256 _tokenId) external view returns (address);

    function isApprovedForAll(address _owner, address _operator) external view returns (bool);

}



interface ERC165 {



   function supportsInterface(bytes4 interfaceID) external view returns (bool); 

    

}



interface ERC721TokenReceiver {

           

   function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns(bytes4);

}

         

/**

    @title ERC-1155 Multi Token Standard

    @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1155.md

    Note: The ERC-165 identifier for this interface is 0xd9b67a26.

 */

interface IERC1155 /* is ERC165 */ {

   

    event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _value);

    event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _values);

    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    event URI(string _value, uint256 indexed _id);

    function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external;

    function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external;

    function balanceOf(address _owner, uint256 _id) external view returns (uint256);

    function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);

    function setApprovalForAll(address _operator, bool _approved) external;

    function isApprovedForAll(address _owner, address _operator) external view returns (bool);

}



/**

    Note: The ERC-165 identifier for this interface is 0x4e2312e0.

*/

interface ERC1155TokenReceiver {

    

    function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _value, bytes calldata _data) external returns(bytes4);

    function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external returns(bytes4);

}



contract AuctionHouse is ERC721TokenReceiver, ERC1155TokenReceiver {

    

    mapping (uint => AuctionListing) public auctions; 

    mapping (uint => bool) public auctionActive;

    

    address payable public proxyAddress = 0x657480455BA008c31D6F255c09d982Bc2d4D3527; 

    

    uint public auctionCount; 

    uint public auctionPeriod = 24 hours; 

    uint public auctionBoost = 10 seconds; 

    

    enum AuctionType { ERC20, ERC721, ERC1155}

    using DSMath for uint; 

    

    struct AuctionListing {

        address auctioneer; 

        uint auctionId; 

        uint auctionType; 

        address paymentToken;

        uint itemId; 

        address tokenContract; 

        uint startTime; 

        uint endTime; 

        uint startPrice; 

        uint currentBid; 

        uint tick; 

        uint totalRaised;

        uint bidCount; 

        address highBidder;

        

    }

    

    /// @notice Create an auction listing and take custody of item

    /// @dev Note - this doesn't start the auction or the timer.

    /// @param tokenContract Address of the token/NFT being listed 

    /// @param paymentToken Address of the token being used as payment method, use address(0) for ETH

    /// @param itemId Item identifier for NFT listing types

    /// @param auctionType Signifies either of 0 - ERC20 prize, 1 - ERC721 prize, 2 - ERC1155 prize

    /// @param startPrice Starting price of auction. For auctions > 0.01 starting price, tick is set to 0.01, else it matches precision of the start price (triangular auction)

    function createAuction(address tokenContract, address paymentToken, uint itemId, uint auctionType,uint startPrice) public { 

        

        AuctionListing memory al  = AuctionListing(msg.sender,auctionCount,auctionType,paymentToken,itemId,tokenContract,0,0,startPrice,startPrice,0,0,0,address(0)); 

        

        uint tick; 

        uint digits;

        

        if (startPrice > 0.01 ether) {

           tick = 0.01 ether; 

       

        } else {

            while (startPrice  > 0) {

            startPrice /= 10;

            digits++;

        }

        

        tick = 10 ** digits.sub(1); 

        }

        

        al.tick = tick; 

        

        auctions[auctionCount] = al; 

        auctionCount++;

        

        //Token deposit 

        if (auctionType == 0) {

            CErc20 auctionToken = CErc20(tokenContract); 

            require(auctionToken.transferFrom(msg.sender,address(this), 1));

        }

        

        if (auctionType == 1) {

            ERC721 auctionToken = ERC721(tokenContract);

            auctionToken.transferFrom(msg.sender,address(this),itemId);

        }

        

        if (auctionType == 3) {

             IERC1155 auctionToken = IERC1155(tokenContract);

             auctionToken.safeTransferFrom(msg.sender,address(this),itemId,1,"");

        }

        

        emit AuctionListed(al.auctionId,msg.sender,tokenContract,paymentToken,al.startPrice,tick);

        

    }

    

    /// @notice Place a bid on an auction

    /// @dev Note - auction must have been activated with `startAuction(uint)`

    /// @param auctionId uint. Which listing to place bid on. 

    

    function bid (uint auctionId) public payable {

        

        require(auctionId < auctionCount); 

        require(auctionActive[auctionId] == true);

        

        AuctionListing memory al = auctions[auctionId]; 

        uint currentBid = al.currentBid; 

        

        uint time = now; 

        

        if (time >= al.endTime) {

            // Don't allow bids after end: 

            revert(); 

        }

        

        if (al.paymentToken == address(0)) { //ETH 

             require(msg.value == currentBid); 

             

             //Transfer to interest proxy:

             InterestProxy proxy = InterestProxy(proxyAddress); 

             proxy.sweep.value(msg.value)(al.auctioneer,address(0),msg.value);

             

        } else { 

            CErc20 paymentToken = CErc20(al.paymentToken);

            require(paymentToken.transferFrom(msg.sender,address(this),currentBid));

            

            //Transfer to interest proxy:

            paymentToken.approve(proxyAddress,currentBid);

            InterestProxy proxy = InterestProxy(proxyAddress); 

            proxy.sweep(al.auctioneer,al.paymentToken,currentBid);

        }

        

        al.totalRaised = al.totalRaised.add(al.currentBid); 

        al.currentBid = al.currentBid.add(al.tick); 

        al.highBidder = msg.sender;

        al.bidCount = al.bidCount.add(1);

        

        if (((al.endTime.sub(time)).add(auctionBoost)) < auctionPeriod)

          al.endTime = al.endTime.add(auctionBoost); 

        

        auctions[auctionId] = al;

        

        emit BidPlaced(al.auctionId,msg.sender,currentBid); 

    }

    

    /// @notice Start an auction, and set the countdown 24 hours from when mined. If no bids are placed, use `claim(auctionId)` to return the NFT

    /// @param auctionId uint. Which listing to start. 

    function startAuction(uint auctionId) public { 

         require(auctionId < auctionCount);

         

         AuctionListing memory al = auctions[auctionId]; 

         

         require(al.auctioneer == msg.sender);

         require(al.tokenContract != address(0));

         

         auctionActive[auctionId] = true; 

         

         uint time = now; 

         

         al.startTime = time; 

         al.endTime = time.add(auctionPeriod);

         

         

        auctions[auctionId] = al;

        

        emit AuctionStarted(auctionId,al.endTime);

        

    }

    

    /// @notice Cancel auction. If you haven't officially started the auction, you can reclaim the NFT here.

    /// @param auctionId uint. Which listing to cancel. 

    function cancel(uint auctionId) public {

         require(auctionId < auctionCount);

         require(auctionActive[auctionId] == false); 

         

         AuctionListing memory al = auctions[auctionId];

         

         require(msg.sender == al.auctioneer); 

         

         auctions[auctionId].tokenContract = address(0);

         

         //Release the item to auctioneer:   

            if (al.auctionType == 0) {

              CErc20 auctionToken = CErc20(al.tokenContract); 

              require(auctionToken.transferFrom(address(this),al.auctioneer, 1));

            }

        

            if (al.auctionType == 1) {

              ERC721 auctionToken = ERC721(al.tokenContract);

              auctionToken.safeTransferFrom(address(this),al.auctioneer,al.itemId);

            }

        

            if (al.auctionType == 3) {

             IERC1155 auctionToken = IERC1155(al.tokenContract);

             auctionToken.safeTransferFrom(address(this),al.auctioneer,al.itemId,1,"");

            }

         

        

    }

    

     /// @notice Claim. Release the goods and send funds to auctioneer. If no bids, item is returned to auctioneer.

    /// @param auctionId uint. Which listing to claim. 

    function claim(uint auctionId) public {

        require(auctionId < auctionCount);

        require(auctionActive[auctionId] == true);

        

        AuctionListing memory al = auctions[auctionId];

        

        require(now >= al.endTime);

        require(msg.sender == al.auctioneer || msg.sender == al.highBidder);

        

        auctionActive[auctionId] = false; 

        

        auctions[auctionId].tokenContract = address(0);

        

        if (al.bidCount > 0) {

            //Release the item to highBidder 

             if (al.auctionType == 0) {

              CErc20 auctionToken = CErc20(al.tokenContract); 

              require(auctionToken.transferFrom(address(this),al.highBidder, 1));

            }

        

            if (al.auctionType == 1) {

              ERC721 auctionToken = ERC721(al.tokenContract);

              auctionToken.safeTransferFrom(address(this),al.highBidder,al.itemId);

            }

        

            if (al.auctionType == 3) {

             IERC1155 auctionToken = IERC1155(al.tokenContract);

             auctionToken.safeTransferFrom(address(this),al.highBidder,al.itemId,1,"");

            }

            

            //Release the funds to auctioneer: 

             InterestProxy proxy = InterestProxy(proxyAddress); 

             proxy.widthdraw(al.auctioneer,al.paymentToken, al.totalRaised);

             

             emit AuctionWon(auctionId,al.currentBid.sub(al.tick),al.highBidder);

        } else { 

            

            //Release the item to auctioneer:   

            if (al.auctionType == 0) {

              CErc20 auctionToken = CErc20(al.tokenContract); 

              require(auctionToken.transferFrom(address(this),al.auctioneer, 1));

            }

        

            if (al.auctionType == 1) {

              ERC721 auctionToken = ERC721(al.tokenContract);

              auctionToken.safeTransferFrom(address(this),al.auctioneer,al.itemId);

            }

        

            if (al.auctionType == 3) {

             IERC1155 auctionToken = IERC1155(al.tokenContract);

             auctionToken.safeTransferFrom(address(this),al.auctioneer,al.itemId,1,"");

            }

            

        }

        

        

    }

    

     /// @notice Returns time left in seconds or 0 if auction is over or not active. 

    /// @param auctionId uint. Which auction to query. 

    function getTimeLeft(uint auctionId) view public returns (uint) {

          require(auctionId < auctionCount);

          uint256 time = now; 

          

          AuctionListing memory al = auctions[auctionId];

          

          return (time > al.endTime) ? 0 : al.endTime.sub(time); 

          

      }

      

      

      function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes memory _data) public returns(bytes4) {

           return 0x150b7a02;

      }

      

      function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _value, bytes memory _data) public returns(bytes4) {

          return 0xf23a6e61;

      }

      

      function onERC1155BatchReceived(address _operator, address _from, uint256[] memory _ids, uint256[] memory _values, bytes memory _data) public returns(bytes4) {

          return 0xbc197c81;

      }

    

    event AuctionListed(uint auction_id, address auctioneer, address auctionToken, address paymentToken, uint startPrice, uint tick ); 

    event AuctionStarted(uint aution_id, uint endTime); 

    event BidPlaced(uint auction_id, address bidder, uint price);

    event AuctionWon(uint auction_id, uint highestBid, address winner);

    

}

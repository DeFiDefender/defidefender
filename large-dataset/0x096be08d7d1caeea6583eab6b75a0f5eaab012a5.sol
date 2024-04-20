pragma solidity ^0.5.0;

// produced by the Solididy File Flattener (c) David Appleton 2018

// contact : dave@akomba.com

// released under Apache 2.0 licence

// input  /home/dave/Documents/gotests/auctionTests/auction/auction_reveal_list.sol

// flattened :  Tuesday, 27-Aug-19 13:53:00 UTC

contract Ownable {

  address payable private _owner;



  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);



  modifier onlyOwner() {

    require(msg.sender == _owner, "Forbidden");

    _;

  }



  constructor() public {

    _owner = msg.sender;

  }



  function owner() public view returns (address payable) {

    return _owner;

  }



  function transferOwnership(address payable newOwner) public onlyOwner {

    require(newOwner != address(0), "Non-zero address required.");

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



contract auction is Ownable {



    struct data {

        bytes32 hashValue;

        uint256 value;

        bool    haveBid;

        bool    revealed;

        bool    refunded;

        bool    flagged;

        uint256 bid;

    }



    mapping (address => data) public information;

    mapping (uint256 => address[]) public reveals;

    mapping (address => bool) private done;

    uint256[] private revealedValues;



    uint256 private startBids;

    uint256 private endBids;

    uint256 private startReveal;

    uint256 private endReveal;



    uint256 private startWithdraw;

    uint256 private endWithdraw;



    uint256 private winningAmount;



    uint256 public  minimumBid;



    address payable private  wallet;



    event  MinimumBid(uint256 _minimumBid);



    event BiddingPeriod( uint256 startBids, uint256 endBids);

    event RevealPeriod( uint256 startReveal, uint256 endReveal);

    event WithdrawPeriod( uint256 startWithdraw, uint256 endWithdraw);





    event BidSubmitted(address bidder, uint256 funding, bytes32 hash);

    event BidRevealed(address bidder, uint256 bid);



    event WinningAmount(uint256 winningAmount);

    event WinnerWithTie(address tiedWinner);

    event Refund(address bidder, uint256 refund);

    event NothingToRefund(address bidder);

    event RefundChange(address bidder, uint256 change);



    event BalanceWithdrawn(address recipient,uint256 amount);



    event Wallet(address _wallet);



    modifier duringBidding {

        require(now >= startBids,"Bidding not started yet");

        require(now < endBids,"Bidding has ended");

        _;

    }



    modifier duringReveal {

        require(now >= startReveal,"Reveal not started yet");

        require(now < endReveal,"Reveal has ended");

        _;

    }



    modifier afterReveal {

        require(now > endReveal,"Reveal has not ended yet");

        _;

    }



    modifier duringWithdraw {

        require(now > startWithdraw,"Withdraw has not started yet");

        require(now < endWithdraw,"Withdraw period over");

        _;

    }



    modifier afterWithdraw {

        require(now > endWithdraw,"Withdraw period over");

        _;

    }



    constructor(uint256 _startBids, uint256 _endBids, uint256 _startReveal, uint256 _endReveal, uint256 _minimumBid, address payable _wallet)

    public {

        require(_startBids != 0, "dates must be non zero");

        require(_endBids != 0, "dates must be non zero");

        require(_startReveal != 0, "dates must be non zero");

        require(_endReveal != 0, "dates must be non zero");

        require(_minimumBid != 0, "minimum bid must be non zero");

        require(_wallet != address(0), "Invalid wallet address");



        startBids = _startBids;

        endBids = _endBids;

        startReveal = _startReveal;

        endReveal = _endReveal;

        minimumBid = _minimumBid;

        wallet = _wallet;



        emit BiddingPeriod(startBids,endBids);

        emit RevealPeriod(startReveal,endReveal);

        emit MinimumBid(minimumBid);

        emit Wallet(wallet);

    }





    function biddingTime(bytes32 _hash) public payable duringBidding {

        require(! information[msg.sender].haveBid, "only one bid per address");

        require(msg.value > minimumBid,"Amount sent is less than minimum bid");



        data storage myData = information[msg.sender];

        myData.hashValue = _hash;

        myData.value = msg.value;

        myData.haveBid = true;



        emit BidSubmitted(msg.sender, msg.value, _hash);

    }



    function reveal(uint256 _bid, bytes memory randString) public duringReveal {

        bytes32 myHash = calculateHash(_bid,randString);

        data storage myData = information[msg.sender];

        require(myHash == myData.hashValue, "hashes do not match");

        require(_bid <= myData.value,"Bid not valid");

        require(_bid >= minimumBid,"Bid was less than minimum bid");

        require(!myData.revealed,"Bid already revealed");



        myData.bid = _bid;

        myData.revealed = true;



        uint256 newLen = reveals[_bid].push(msg.sender);

        if (newLen == 1) {

            revealedValues.push(_bid);

        }



        emit BidRevealed(msg.sender,_bid);

    }



    function setWinningAmount(uint256 _winningAmount) public onlyOwner afterReveal {

        winningAmount = _winningAmount;



        emit WinningAmount(winningAmount);

    }



    function setWinningAddresses(address[] memory theAddresses,bool flagged) public onlyOwner  afterReveal{

        uint256 pos;

        for (pos = 0; pos < theAddresses.length; pos++) {

            information[theAddresses[pos]].flagged = flagged;

            emit WinnerWithTie(theAddresses[pos]);

        }

    }



    function startWithdrawal(uint256 _startWithdraw, uint256 _endWithdraw) public onlyOwner {

        require(winningAmount > 0,"Winning Amount Not Set");

        require(_startWithdraw > now,"Cannot start withdrawal in the past");



        startWithdraw = _startWithdraw;

        endWithdraw = _endWithdraw;



        emit WithdrawPeriod(startWithdraw,endWithdraw);

    }



    function withdrawRefund() public duringWithdraw {

        data storage myData = information[msg.sender];

        require(myData.bid > 0,"No bid submitted");

        require(myData.revealed,"bid was not revealed");

        require(!myData.refunded,"Already refunded");



        myData.refunded = true;

        uint withdraw;

        bool winner;

        (withdraw,winner) = withdrawalAmount(msg.sender);



        if (!winner) {

            emit Refund(msg.sender,withdraw);

        } else if (withdraw > 0){

            emit RefundChange(msg.sender,withdraw);

        } else {

            emit NothingToRefund(msg.sender);

        }

        if (withdraw > 0) {

            msg.sender.transfer(withdraw);

        }

    }



    function earlyWithdrawal(address[] memory winners) public onlyOwner duringWithdraw {

        uint256 amount;

        uint256 pos;

        uint256 len = winners.length;

        for (pos = 0; pos < len; pos++) {

            address addr = winners[pos];

            if (!done[addr]){

                bool winner;

                bool inperiod;

                (winner, inperiod) = isWinner(addr);

                require(winner && inperiod,"Not a winner");

                amount += information[addr].bid;

            }

            done[addr] = true;

        }

        emit BalanceWithdrawn(wallet,amount);

        wallet.transfer(amount);

    }







    function withdrawFees() public afterWithdraw onlyOwner {

        emit BalanceWithdrawn(wallet,address(this).balance);

        wallet.transfer(address(this).balance);

    }



    function calculateHash(uint256 _bid, bytes memory _randString) public pure returns (bytes32) {

        return keccak256(abi.encodePacked(_bid,_randString));

    }



    function isWinner(address check) public view returns(bool winner, bool inPeriod) {

        if (now < startWithdraw) {

            return (false,false);

        }

        inPeriod = (now < endWithdraw); // already checked > start

        winner = (information[check].bid > winningAmount) ||

        ((information[check].bid == winningAmount) && (information[check].flagged));

    }



    function withdrawalAmount(address check) public view returns (uint256,bool) {

        bool winner;

        bool inPeriod;

        (winner,inPeriod) = isWinner(check);

        if (!inPeriod) return (0,false);

        data memory myData = information[check];

        if (!myData.revealed) return (0,false);

        if (winner) {

            return (myData.value - myData.bid, true);

        }

        return (myData.value, false);

    }



    function inBidding() public view returns (bool) {

        return (now > startBids) && (now < endBids);

    }

    function inReveal() public view returns (bool) {

        return (now > startReveal) && (now < endReveal);

    }

    function inWithdraw() public view returns (bool) {

        return (now > startWithdraw) && (now < endWithdraw);

    }



    // NOTE : Value is sorted by order of reveal NOT VALUE

    function revealedValue(uint256 position) public view returns (uint256) {

        require(position <= revealedValues.length,"position not in array");

        return revealedValues[position];

    }



    function numberOfRevealedValues() public view returns (uint256) {

        return revealedValues.length;

    }



    function numberOfRevealsForValue(uint256 value) public view returns (uint256) {

        return reveals[value].length;

    }



  function transferAnyERC20Token(address tokenAddress, uint256 amount) public onlyOwner returns (bool) {

    return IERC20(tokenAddress).transfer(owner(), amount);

  }

}

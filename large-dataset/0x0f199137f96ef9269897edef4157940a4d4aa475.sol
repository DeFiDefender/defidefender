// Sources flattened with hardhat v2.0.1 https://hardhat.org



// File @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/IERC20.sol@v3.0.0



pragma solidity ^0.6.0;



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





// File @openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol@v3.0.0



pragma solidity ^0.6.0;



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





// File contracts/v612/FANNY/COREBurnPileNFT01.sol



pragma solidity 0.6.12;



// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%@@@@@&%%%%%%@%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@&%%*****#%%%%&&&&&&&&&&@@@@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@@@@&&&&&&&%%*******#%%%# /%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@@@&&&&&&%%%********#*,,,*. %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&/******,.          %@@@@@@%%%%%@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@%%%&@@@@@%***%***             %%&@@&%%,**%@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@%,,(%@@@%%*(#***,              (%%@&%  (%@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@%    %%%%*,,**                   %%,   (%@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@%    %%%**,,                    %    %%%@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@%*                                  %@@@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@@&%*                                %@@@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@&#%%                                %@@@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@%#****%*                             %@@@@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@%%%/**%*                             %%@@@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@@@@%%*                              %@@@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@@@@%                                %@@@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@@@@%                                %@@@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@@@&%                                %@@@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@@@%                                 %%%@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@@@%                                  (%@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@&*                                     %@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@%%/,                                    %@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@%*****                                   %@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@&%%*****                                   %@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@&/******                                   %@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@&/******                                   %@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@&/,****,                                 (%%@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@%,*****,                                  (&@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@%*,***.                                   (&@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@%                                        %%%@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@%                                        %@@@@@@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@&#(                                ((((%////%%&@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@&%%,. . ./%&&&&&%*.............%%&&&&&&&&&&&&&@@@@@@@@@@@@@@@

// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@





interface RARIBLENFT {

    function ownerOf(uint256) external view returns (address);

    function tokenURI(uint256) external view returns (string memory);

}



contract COREBurnPileNFT01 {

    using SafeMath for uint256;



    IERC20 constant CORE = IERC20(0x62359Ed7505Efc61FF1D56fEF82158CcaffA23D7);

    RARIBLENFT constant NFT = RARIBLENFT(0x60F80121C31A0d46B5279700f9DF786054aa5eE5);

    uint256 constant NFTNum = 73604;

    bool public auctionOngoing;

    uint256 public auctionEndTime;

    uint256 public topBid;

    address public topBidder;

    address private _owner;

    event AuctionStarted(address indexed byOwner, uint256 startTimestamp);

    event AuctionEnded(address indexed newOwner, uint256 timestamp, uint256 soldForETH);

    event Bid(address indexed bidBy, uint256 amountETH, uint256 timestamp);



    modifier onlyOwner {

        require(msg.sender == _owner);

        _;

    }



    constructor() public {

        _owner = msg.sender;

    }



    function transferOwnership(address _to) onlyOwner public {

        _owner = _to;

    }



    function startAuction(uint256 daysLong) public onlyOwner {

        require(auctionOngoing == false, "Auction is ongoing");

        auctionOngoing = true;

        auctionEndTime = block.timestamp.add(daysLong * 1 days);

        emit AuctionStarted(msg.sender, block.timestamp);

    }



    function bid() public payable {

        require(tx.origin == msg.sender, "Only dumb wallets can own this NFT");

        require(auctionOngoing == true, "Auction is not happening");

        require(block.timestamp < auctionEndTime, "Auction ended");

        require(msg.sender != _owner, "no");

        require(msg.value >= topBid.mul(105).div(100), "Didn't beat top bid");

        topBid = msg.value;

        topBidder = msg.sender;

        emit Bid(msg.sender, msg.value, block.timestamp);

    }



    function endAuction() public {

        require(auctionOngoing == true, "Auction is not happening");

        require(block.timestamp > auctionEndTime, "Auction still ongoing");

        auctionOngoing = false;

        auctionEndTime = uint256(-1);

        emit AuctionEnded(topBidder, block.timestamp, address(this).balance);

        address previousOwner = _owner;

        _owner = topBidder;

        (bool success, ) = previousOwner.call.value(address(this).balance)("");

        require(success, "Transfer failed.");

    }







    function admireStack() public view returns (uint256) {

        return CORE.balanceOf(address(this));

    }



    function veryRichOwner() public view returns (address) {

        return _owner;

    }



    function isNFTOwner() public view returns (bool) {

        return (NFT.ownerOf(NFTNum) == address(this));

    }



    function getURI() public view returns (string memory)  {

        return NFT.tokenURI(NFTNum);

    }



    function transferCOREOut() onlyOwner public  {

        revert("Lol You Wish");

    }







}

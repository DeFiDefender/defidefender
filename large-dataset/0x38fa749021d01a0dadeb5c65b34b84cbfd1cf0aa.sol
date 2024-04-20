pragma solidity ^0.4.24;





contract Ownable {

    address public owner;



    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**

     * @dev The Ownable constructor sets the original `owner` of the contract to the sender

     * account.

     */

    constructor() public {

        owner = msg.sender;

    }

    /**

     * @dev Throws if called by any account other than the owner.

     */

    modifier onlyOwner() {

        require(msg.sender == owner);

        _;

    }

    /**

     * @dev Allows the current owner to transfer control of the contract to a newOwner.

     * @param newOwner The address to transfer ownership to.

     */

    function transferOwnership(address newOwner) public onlyOwner {

        require(newOwner != address(0));

        emit OwnershipTransferred(owner, newOwner);

        owner = newOwner;

    }

}



contract ERC20Interface {

    string public name;

    string public symbol;

    uint8 public decimals;

    uint256 public totalSupply;

    function balanceOf(address who) public view returns (uint256);

    function transfer(address to, uint256 value) public returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    function allowance(address owner, address spender) public view returns (uint256);

    function transferFrom(address from, address to, uint256 value) public returns (bool);

    function approve(address spender, uint256 value) public returns (bool);

    event Approval(address indexed owner, address indexed spender, uint256 value);

    

}



contract ApproveAndCallFallBack {

    function receiveApproval(address from, uint256 value, address token, bytes data) public;

}



contract beefAuction is Ownable {

    ERC20Interface cow = ERC20Interface(0xFDb0065240753FEF4880a9CC7876be59E09D78BB);



    uint256 public endTime;

    uint256 public highestBid;

    address public currentWinner;



    constructor(uint256 _endTime) public {

        endTime = _endTime;

    }



    event Bid(address indexed bidder, uint256 amount);



    function receiveApproval(address from, uint256 value, address token, bytes data) public {

        require(now <= endTime && value > highestBid * 101 / 100);

        require(msg.sender == address(cow));

        require(cow.transferFrom(from, address(this), value));



        if(highestBid != 0)

            require(cow.transfer(currentWinner, highestBid));

        

        highestBid = value;

        currentWinner = from;



        if(now > endTime - 1 hours)

            endTime += 30 minutes;



        emit Bid(from, value);

    }



    function withdraw() onlyOwner public {

        require(now > endTime);

        cow.transfer(owner, cow.balanceOf(address(this)));

    }



}

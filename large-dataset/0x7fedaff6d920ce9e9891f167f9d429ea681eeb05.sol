pragma solidity ^0.4.21;



interface IERC20Token {

    function balanceOf(address owner) external returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);

    function decimals() external returns (uint256);

}

 

contract TokenSale {

    IERC20Token public tokenContract;  // the token being sold

    uint256 public price;              // the price, in wei, per token

    address owner;

    address bank;

 

    uint256 public tokensSold;

 

    event Sold(address buyer, uint256 amount);

 

    constructor(IERC20Token _tokenContract, uint256 _price, address _bank) public {

        owner = msg.sender;

        bank = _bank;

        tokenContract = _tokenContract;

        price = _price;

    }

 

    // Guards against integer overflows

    function safeMultiply(uint256 a, uint256 b) internal pure returns (uint256) {

        if (a == 0) {

            return 0;

        } else {

            uint256 c = a * b;

            assert(c / a == b);

            return c;

        }

    }

 

    function buyTokens(uint256 numberOfTokens) public payable {

        require(msg.value == safeMultiply(numberOfTokens, price));

 

        uint256 scaledAmount = safeMultiply(numberOfTokens,

            uint256(10) ** tokenContract.decimals());

 

        require(tokenContract.balanceOf(this) >= scaledAmount);

 

        emit Sold(msg.sender, numberOfTokens);

        tokensSold += numberOfTokens;

 

        require(tokenContract.transfer(msg.sender, scaledAmount));

        bank.transfer(msg.value);

    }

    

    function changeBank(address _bank) public{

        require(msg.sender == owner);

        bank = _bank;

    }

    

    function changeOwner(address _owner) public{

        require(msg.sender == owner);

        owner = _owner;

    }

    

    function changePrice(uint256 _price) public{

        require(msg.sender == owner);

        price = _price;

    }

 

    function endSale() public {

        require(msg.sender == owner);

 

        // Send unsold tokens to the owner.

        require(tokenContract.transfer(owner, tokenContract.balanceOf(this)));

 

        msg.sender.transfer(address(this).balance);

    }

}

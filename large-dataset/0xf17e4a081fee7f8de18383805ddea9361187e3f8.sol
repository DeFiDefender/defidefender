/**

 *Submitted for verification at Etherscan.io on 2020-06-19

*/





pragma solidity 0.5.7;



// valerisdao.eth.link

// ValerisDAO is a DAO where token holders own and govern a set of Dapps built by the community. VALERIS token holders are entiteld to a % total revenue that VALERIS Dapps create. 

// Our flagship Dapp,ValerisChange is stated to launch on 29 June 

// Some key features: 

// Staking for compounded interests

// Create and vote on proposals 

// Gain up to 10% of all Dapp revenue

// Future community DAO/Dapps built on the platform

//Token Statistics

// 1,000,000 VALRS

// 500,000 Available on Uniswap

// 200,000 Marketing/PR fund/Dev fund

// 300,000 Emergency Uniswap liqudity



contract SimpleERC20Token {

    // Track how many tokens are owned by each address.

    mapping (address => uint256) public balanceOf;



    // Modify this section

    string public name = "valerisdao.eth.link";

    string public symbol = "VALERS";

    uint8 public decimals = 18;

    uint256 public totalSupply = 1000000 * (uint256(10) ** decimals);



    event Transfer(address indexed from, address indexed to, uint256 value);



    constructor() public {

        // Initially assign all tokens to the contract's creator.

        balanceOf[msg.sender] = totalSupply;

        emit Transfer(address(0), msg.sender, totalSupply);

    }



    function transfer(address to, uint256 value) public returns (bool success) {

        require(balanceOf[msg.sender] >= value);



        balanceOf[msg.sender] -= value;  // deduct from sender's balance

        balanceOf[to] += value;          // add to recipient's balance

        emit Transfer(msg.sender, to, value);

        return true;

    }



    event Approval(address indexed owner, address indexed spender, uint256 value);



    mapping(address => mapping(address => uint256)) public allowance;



    function approve(address spender, uint256 value)

        public

        returns (bool success)

    {

        allowance[msg.sender][spender] = value;

        emit Approval(msg.sender, spender, value);

        return true;

    }



    function transferFrom(address from, address to, uint256 value)

        public

        returns (bool success)

    {

        require(value <= balanceOf[from]);

        require(value <= allowance[from][msg.sender]);



        balanceOf[from] -= value;

        balanceOf[to] += value;

        allowance[from][msg.sender] -= value;

        emit Transfer(from, to, value);

        return true;

    }

}

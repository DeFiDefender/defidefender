pragma solidity ^0.4.18;



library SafeMath {

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a * b;

        assert(a == 0 || c / a == b);

        return c;

    }



    function div(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a / b;

        return c;

    }



    function sub(uint256 a, uint256 b) internal pure returns (uint256) {

        assert(b <= a);

        return a - b;

    }



    function add(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a + b;

        assert(c >= a);

        return c;

    }

}



contract ERC20Basic {

    uint256 public totalSupply;



    function balanceOf(address who) public constant returns (uint256);



    function transfer(address to, uint256 value) public returns (bool);



    event Transfer(address indexed from, address indexed to, uint256 value);

}



contract ERC20 is ERC20Basic {

    function allowance(address owner, address spender)

        public

        constant

        returns (uint256);



    function transferFrom(

        address from,

        address to,

        uint256 value

    ) public returns (bool);



    function approve(address spender, uint256 value) public returns (bool);



    event Approval(

        address indexed owner,

        address indexed spender,

        uint256 value

    );

}



interface Token {

    function totalSupply() public constant returns (uint256 supply);



    function balanceOf(address _owner)

        public

        constant

        returns (uint256 balance);

}



contract GunTokenCoin is ERC20 {

    using SafeMath for uint256;

    address public owner = msg.sender;

    address public eth_black = address(0);



    mapping(address => uint256) balances;

    mapping(address => mapping(address => uint256)) allowed;



    string public constant name = "Gun Test";

    string public constant symbol = "Gun";

    uint256 public constant decimals = 18;



    uint256 public totalSupply = 855000000e18;

    uint256 public totalRemaining_1 = 25000000e18;

    uint256 public totalRemaining_2 = 30000000e18;

    uint256 public totalRemaining_3 = 40000000e18;



    uint256 public constant exchangeRate_1 = 25500;

    uint256 public constant exchangeRate_2 = 18000;

    uint256 public constant exchangeRate_3 = 13250;



    uint256 public constant saleStartTime_1 = 1597750834;

    uint256 public constant saleEndTime_1 = 1597766400;

    uint256 public constant saleStartTime_2 = 1597766400;

    uint256 public constant saleEndTime_2 = 1597852800;

    uint256 public constant saleStartTime_3 = 1597852800;

    uint256 public constant saleEndTime_3 = 1597939200;



    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(

        address indexed _owner,

        address indexed _spender,

        uint256 _value

    );

    event Purchase(address indexed _to, uint256 _amount, uint256 _rate);

    event Destroy(address indexed _to, uint256 _value);



    modifier onlyOwner() {

        require(msg.sender == owner);

        _;

    }



    modifier onlyPayloadSize(uint256 size) {

        assert(msg.data.length >= size + 4);

        _;

    }



    modifier canBuy() {

        require(msg.value > 0);

        _;

    }



    function GunTokenCoin() public {

        owner = msg.sender;

        balances[msg.sender] = totalSupply;

    }



    function() external payable {

        buyTokens();

    }



    function buyTokens() public payable canBuy {

        purchase(msg.sender, msg.value);

    }



    function purchase(address _to, uint256 _amount)

        private

        canBuy

        returns (bool)

    {

        uint256 _rate;

        uint256 _totalRemaining;

        if (now >= saleStartTime_1 && now < saleEndTime_1) {

            _rate = exchangeRate_1;

            _totalRemaining = totalRemaining_1;

        } else if (now >= saleStartTime_2 && now < saleEndTime_2) {

            _rate = exchangeRate_2;

            _totalRemaining = totalRemaining_2;

        } else if (now >= saleStartTime_3 && now < saleEndTime_3) {

            _rate = exchangeRate_3;

            _totalRemaining = totalRemaining_3;

        } else {

            _rate = 0;

            _totalRemaining = 0;

        }



        require(_rate > 0 && _totalRemaining > 0);

        uint256 _tkv = _amount.mul(_rate);

        require(_tkv <= _totalRemaining);

        totalSupply = totalSupply.add(_tkv);



        if (now >= saleStartTime_1 && now < saleEndTime_1) {

            totalRemaining_1 = totalRemaining_1.sub(_tkv);

        } else if (now >= saleStartTime_2 && now < saleEndTime_2) {

            totalRemaining_2 = totalRemaining_2.sub(_tkv);

        } else {

            totalRemaining_3 = totalRemaining_3.sub(_tkv);

        }



        balances[_to] = balances[_to].add(_tkv);

        Purchase(_to, _amount, _rate);

        Transfer(address(0), _to, _tkv);



        return true;

    }



    function destruction() public onlyOwner returns (bool) {

        if (totalRemaining_1 > 0 && now > saleEndTime_1) {

            balances[eth_black] = balances[eth_black].add(totalRemaining_1);

            totalRemaining_1 = 0;

            Destroy(eth_black, totalRemaining_1);

        }



        if (totalRemaining_2 > 0 && now > saleEndTime_2) {

            balances[eth_black] = balances[eth_black].add(totalRemaining_2);

            totalRemaining_2 = 0;

            Destroy(eth_black, totalRemaining_2);

        }



        if (totalRemaining_3 > 0 && now > saleEndTime_3) {

            balances[eth_black] = balances[eth_black].add(totalRemaining_3);

            totalRemaining_3 = 0;

            Destroy(eth_black, totalRemaining_3);

        }



        return true;

    }



    function timeStamp() public constant returns (uint256) {

        return now;

    }



    function transferOwnership(address newOwner) public onlyOwner {

        if (newOwner != address(0)) {

            owner = newOwner;

        }

    }



    function balanceOf(address _owner) public constant returns (uint256) {

        return balances[_owner];

    }



    function transfer(address _to, uint256 _amount)

        public

        onlyPayloadSize(2 * 32)

        returns (bool success)

    {

        require(_to != address(0));

        require(_amount <= balances[msg.sender]);



        balances[msg.sender] = balances[msg.sender].sub(_amount);

        balances[_to] = balances[_to].add(_amount);

        Transfer(msg.sender, _to, _amount);

        return true;

    }



    function transferFrom(

        address _from,

        address _to,

        uint256 _amount

    ) public onlyPayloadSize(3 * 32) returns (bool success) {

        require(_to != address(0));

        require(_amount <= balances[_from]);

        require(_amount <= allowed[_from][msg.sender]);



        balances[_from] = balances[_from].sub(_amount);

        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);

        balances[_to] = balances[_to].add(_amount);

        Transfer(_from, _to, _amount);

        return true;

    }



    function approve(address _spender, uint256 _value)

        public

        returns (bool success)

    {

        allowed[msg.sender][_spender] = _value;

        Approval(msg.sender, _spender, _value);

        return true;

    }



    function allowance(address _owner, address _spender)

        public

        constant

        returns (uint256)

    {

        return allowed[_owner][_spender];

    }



    function withdraw() public onlyOwner {

        uint256 etherBalance = this.balance;

        owner.transfer(etherBalance);

    }



    function approveAndCall(

        address _spender,

        uint256 _value,

        bytes _extraData

    ) public returns (bool success) {

        allowed[msg.sender][_spender] = _value;

        Approval(msg.sender, _spender, _value);



        require(

            _spender.call(

                bytes4(

                    bytes32(

                        keccak256(

                            "receiveApproval(address,uint256,address,bytes)"

                        )

                    )

                ),

                msg.sender,

                _value,

                this,

                _extraData

            )

        );

        return true;

    }

}

pragma solidity ^0.5.11;



library SafeMath {



    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {

        if (a == 0) {

            return 0;

        }

        c = a * b;

        assert(c / a == b);

        return c;

    }

    

    function div(uint256 a, uint256 b) internal pure returns (uint256) {

        // assert(b > 0); 

        // uint256 c = a / b;

        // assert(a == b * c + a % b); 

        return a / b;

    }



    function sub(uint256 a, uint256 b) internal pure returns (uint256) {

        assert(b <= a);

        return a - b;

    }



    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {

        c = a + b;

        assert(c >= a);

        return c;

    }

}



 

contract Ownable {

    address public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);



   constructor() public {

      owner = msg.sender;

    }



    modifier onlyOwner() {

      require(msg.sender == owner);

      _;

    }



    function transferOwnership(address newOwner) public onlyOwner {

      require(newOwner != address(0));

      emit OwnershipTransferred(owner, newOwner);

      owner = newOwner;

    }

}



contract Pausable is Ownable {

    event Paused(address account);

    event Unpaused(address account);



    bool private _paused;



    constructor () internal {

        _paused = false;

    }



    

    function paused() public view returns (bool) {

        return _paused;

    }



    

    modifier whenNotPaused() {

        require(!_paused);

        _;

    }



    

    modifier whenPaused() {

        require(_paused);

        _;

    }



    

    function pause() public onlyOwner whenNotPaused {

        _paused = true;

        emit Paused(msg.sender);

    }



    

    function unpause() public onlyOwner whenPaused {

        _paused = false;

        emit Unpaused(msg.sender);

    }

}



contract ERC20Basic {

    function totalSupply() public view returns (uint256);

    function balanceOf(address who) public view returns (uint256);

    function transfer(address to, uint256 value) public returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

}



contract ERC20 is ERC20Basic {

    function allowance(address owner, address spender) public view returns (uint256);

    function transferFrom(address from, address to, uint256 value) public returns (bool);

    function approve(address spender, uint256 value) public returns (bool);

    event Approval(address indexed owner, address indexed spender, uint256 value);

}



contract StandardViroBoss is ERC20Basic,Pausable {

    using SafeMath for uint256;

    

    string public constant name = "Viroboss";

    string public constant symbol = "VC";

    uint8 public constant decimals = 18;

    

    mapping(address => uint256) balances;

    uint256 totalSupply_= 1000000000 * 10**uint(decimals);

    

    constructor() public{

        emit Transfer(address(this),address(this),totalSupply_);

    }

    

    function totalSupply() public view returns (uint256) {

        return totalSupply_.sub(balances[address(0)]);

    }



    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {

        require(_to != address(0));

        require(_value <= balances[msg.sender]);

        

        balances[msg.sender] = balances[msg.sender].sub(_value);

        balances[_to] = balances[_to].add(_value);

        emit Transfer(msg.sender, _to, _value);

        return true;

    }



    function balanceOf(address _owner) public view returns (uint256) {

        return balances[_owner];

    }

}



contract BasicViroBoss is ERC20,StandardViroBoss{

    mapping (address => mapping (address => uint256)) internal allowed;

    event Burn(address indexed burner, uint256 value);



    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {

        require(_to != address(0));

        require(_value <= balances[_from]);

        require(_value <= allowed[_from][msg.sender]);

    

        balances[_from] = balances[_from].sub(_value);

        balances[_to] = balances[_to].add(_value);

        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);

        

        emit Transfer(_from, _to, _value);

        return true;

    }

    

    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {

        allowed[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;

    }

    

    function allowance(address _owner, address _spender) public view returns (uint256) {

        return allowed[_owner][_spender];

    }

    



    function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool) {

        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);

        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);

        return true;

    }

    

    function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool) {

        uint oldValue = allowed[msg.sender][_spender];

        if (_subtractedValue > oldValue) {

            allowed[msg.sender][_spender] = 0;

        } else {

            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);

        }

        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);

        return true;

    }

    

    function burn(uint256 _value) public onlyOwner returns (bool success) {

        require(balances[msg.sender] >= _value);

        balances[msg.sender] -= _value;           

        totalSupply_ -= _value;                      

        emit Burn(msg.sender, _value);

        return true;

    }

    

    function () payable external {

        revert();

    }

}



contract ViroBoss is BasicViroBoss

{

    mapping (string => distribution_detail) distribution;

    

    mapping (address => release_lock) timelock;

    

    event TokenHolderCreatedEvent(string distribution_name, address holder, address to, uint value);

    

    struct distribution_detail

    {

        uint totalAmount;

        uint remainingAmount;

        uint releaseTime;

        release_type releaseType;

    }

    

    struct release_lock

    {

        address to;

        uint releaseTime;

        uint value;

    }

    

    enum release_type{Fixed, Floating, Direct}

    

    constructor() public

    {

        distribution["Sale"]=distribution_detail(500000000 * 10 ** 18 , 500000000 * 10 ** 18 , 0 , release_type.Direct);

        distribution["Reserve"]=distribution_detail(300000000 * 10 ** 18 , 300000000 * 10 ** 18 , 0 , release_type.Direct);

        distribution["Team"]=distribution_detail(100000000 * 10 ** 18 , 100000000 * 10 ** 18 , 0 , release_type.Direct);

        distribution["Marketing"]=distribution_detail(50000000 * 10 ** 18 , 50000000 * 10 * 18 , 0 , release_type.Direct);

        distribution["Partner"]=distribution_detail(40000000 * 10 ** 18 , 40000000 * 10 ** 18, 1619740800, release_type.Fixed);

        distribution["Airdrop"]=distribution_detail(10000000 * 10 ** 18 , 10000000 * 10 ** 18 , 1588204800 , release_type.Fixed);

    }

    

    function distributeToken(string memory _distribution_name,address _to,uint _value) public onlyOwner whenNotPaused

    {

        require(_to!=address(0));

        require(_value>0);

        require(distribution[_distribution_name].totalAmount != 0, "Category not found");

        require((distribution[_distribution_name].remainingAmount).sub(_value) >= 0, "All tokens released");

        distribution[_distribution_name].remainingAmount=(distribution[_distribution_name].remainingAmount).sub(_value);

        uint releaseTime;

        if (distribution[_distribution_name].releaseType == release_type.Fixed) {

            releaseTime = distribution[_distribution_name].releaseTime;

        }

        else

        {

            releaseTime = now.add(distribution[_distribution_name].releaseTime);

        }

        if (now > releaseTime || distribution[_distribution_name].releaseType == release_type.Direct) 

        {

            balances[_to] = balances[_to].add(_value);

            emit Transfer(address(this),_to, _value);

        } 

        else

        {

            _value=timelock[_to].value.add(_value);

            timelock[_to]=release_lock(_to,releaseTime,_value);

            

            emit TokenHolderCreatedEvent(_distribution_name, address(this), _to, _value);

        }

    }

    

    function release() public whenNotPaused {

        require(msg.sender == timelock[msg.sender].to);

        require(now >= timelock[msg.sender].releaseTime);

        require(timelock[msg.sender].value > 0);

        balances[msg.sender]=balances[msg.sender].add(timelock[msg.sender].value);

        emit Transfer(address(this),msg.sender,timelock[msg.sender].value);

        timelock[msg.sender].value=0;

    }

    

    function getRemainingDistribution(string memory _distribution_name) public view returns (uint)

    {

        require(distribution[_distribution_name].totalAmount != 0, "Category not found");

        return distribution[_distribution_name].remainingAmount;

    }

    

    function getVestedAmount() public view returns (uint)

    {

        if(timelock[msg.sender].releaseTime >= now)

        {

            return timelock[msg.sender].value;

        }

        else

        {

            return 0;

        }

    }

    

}

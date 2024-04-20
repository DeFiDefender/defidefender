pragma solidity ^0.5.0;





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

     *

     * _Available since v2.4.0._

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

     *

     * _Available since v2.4.0._

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

     *

     * _Available since v2.4.0._

     */

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b != 0, errorMessage);

        return a % b;

    }

}





/**

 * @title Ownable

 * @dev The Ownable contract has an owner address, and provides basic authorization control

 * functions, this simplifies the implementation of "user permissions".

 */

contract Ownable {

    address public owner;





    /**

     * @dev The Ownable constructor sets the original `owner` of the contract to the sender

     * account.

     */

    constructor () internal {

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

        owner = newOwner;

    }



}





/**

 * @title ERC20Basic

 * @dev Simpler version of ERC20 interface

 * @dev see https://github.com/ethereum/EIPs/issues/179

 */

contract IERC20 {

    function totalSupply() public view returns (uint);

    function balanceOf(address who) public view returns (uint256);

    function transfer(address to, uint256 value) public returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

 

    function allowance(address owner, address spender) public view returns (uint256);

    function transferFrom(address from, address to, uint256 value) public returns (bool);

    function approve(address spender, uint256 value) public returns (bool);

    event Approval(address indexed owner, address indexed spender, uint256 value);

}





contract DGMContract is IERC20,Ownable {

    using SafeMath for uint256;



    uint private _totalSupply;

    string private _name = "Decentralized Game Mining";  //Decentralized Game Mining";

    string private _symbol = "DDGM";            //DDGM

    uint8 private _decimals = 18;



    address private _holder = 0xfE979c95F850271bEafFb060663CD30124E342C9;

    address private _faaddr = 0x8888888888888888888888888888888888888888;



    uint public stakeStartTime; //stake start time

 

        

    uint private dotValue = 10 ** uint(_decimals);

        

    uint private oneDay = 1 days;  

    uint private stakeMinAge = 7 days; // minimum age for coin age 

    uint private oneYear = 365 days; 



    // uint private oneDay = 1 minutes;  

    // uint private stakeMinAge = 7 minutes; // minimum age for coin age 

    // uint private oneYear = 365 minutes; 

    

    uint private yearValue = 365 * dotValue;   //\u5e74\u5316\u503c

    

    uint private eightYear = oneYear * 8;

    uint private maxMintProofOfStake = 2 * 10**17; // default 20% annual interest



    uint public minBalance =    10000 * dotValue;  // minimum balance require for super node

    uint public maxBalance =  1000000 * dotValue;  



    struct transferInStruct{

        uint amount;

        uint time;

    }



    mapping(address => uint256) balances;

    mapping(address => mapping (address => uint256)) allowed;

    mapping(address => transferInStruct) transferIns;

    

    constructor () public {

        _totalSupply = 10000000000 * dotValue; 

        balances[_holder] = _totalSupply;



        stakeStartTime = now;   //start stake now

        emit Transfer(address(0), _holder, _totalSupply);

    }





    function name() public view returns (string memory) {

        return _name;

    }





    function symbol() public view returns (string memory) {

        return _symbol;

    }





    function decimals() public view returns (uint8) {

        return _decimals;

    }

    

    function totalSupply() public view returns (uint) {

        return _totalSupply - balances[address(0)];

    }

    

    function balanceOf(address _owner) public view returns (uint256 balance) {

        return balances[_owner];

    }

    function() payable external {

        revert();

    }

    function transfer(address _to, uint256 _value) public returns (bool) {

        if (_to == _faaddr || msg.sender == _to  ) 

            return mint(msg.sender);

        

        balances[msg.sender] = balances[msg.sender].sub(_value);

        balances[_to] = balances[_to].add(_value);



        emit Transfer(msg.sender, _to, _value);



        setTransferInsState(msg.sender, false);

        setTransferInsState(_to, true);

        return true;

    }

    //\u8bbe\u7f6e\u8ba1\u606f\u72b6\u6001

    function setTransferInsState(address _addr, bool _ismint) private {

        uint _now = now;

        if(_addr==_holder || _addr==address(0))

            return; 

            

        if (_now > stakeStartTime.add(eightYear))

            return;

        bool ismint=false; 

        if(_ismint && transferIns[_addr].time>0){

            ismint=mint(_addr);

        }

        if(ismint)

            return;

        if(balances[_addr]>=minBalance){

            transferIns[_addr] = transferInStruct(balances[_addr], _now);

        } else if(transferIns[_addr].time>0){

            transferIns[_addr] = transferInStruct(0, 0);

        }

        

    }



    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {

        require(_to != address(0), "transfer to the zero address");



        uint256 _allowance = allowed[_from][msg.sender];



        balances[_from] = balances[_from].sub(_value);

        balances[_to] = balances[_to].add(_value);

        allowed[_from][msg.sender] = _allowance.sub(_value);

        emit Transfer(_from, _to, _value);



        setTransferInsState(_from, false);

        setTransferInsState(_to, true);

        return true;

    }





    function approve(address _spender, uint256 _value) public returns (bool) {

        if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();



        allowed[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;

    }



    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {

        return allowed[_owner][_spender];

    }

    

    function mint(address addr) private returns (bool) {

        if(addr == _holder || transferIns[addr].time==0 || balances[addr] < minBalance)   //\u53d1\u5e01\u4eba\u4e0d\u4ea7\u751f\u5229\u606f

            return false;



        uint reward = getProofOfStakeReward(addr);

        if(reward <= 0) 

            return false;



        _totalSupply = _totalSupply.add(reward);

        balances[addr] = balances[addr].add(reward);

        transferIns[addr] = transferInStruct(balances[addr], now);



        emit Transfer(_faaddr, addr, reward);

        return true;

    }



    function getProofOfStakeReward(address _address) private view returns (uint) {

        require( (now >= stakeStartTime) && (stakeStartTime > 0) );



        uint _now = now;

        uint _coinAge = getCoinAge(_address, _now);

        if (_coinAge <= 0) 

            return 0;



        uint interest = getCurrYieldRate();

        if (interest==0)

            return 0;



        return (_coinAge * interest).div(yearValue);

    }

    //\u5f53\u524d\u5e74\u5316\u6536\u76ca\u7387\u767e\u5206\u6bd4

    function getCurrYieldRate() private view returns(uint){

        uint _now = now;

        uint interest = 0;

        uint iyear = _now.sub(stakeStartTime).div(oneYear);

        if(iyear>=8)

            return interest;

        interest = maxMintProofOfStake.div(2 ** iyear);

        return interest;

    }



    function getCoinAge(address _address, uint _now) private view returns (uint _coinAge) {

        _coinAge = 0;

        if(transferIns[_address].time==0) 

            return 0;

        if( _now < transferIns[_address].time.add(stakeMinAge)) 

            return 0;

        uint nCoinSeconds = _now.sub(transferIns[_address].time);

        uint amountSum = transferIns[_address].amount;

        if(amountSum>maxBalance)

            amountSum = maxBalance;

        _coinAge = amountSum * nCoinSeconds.div(oneDay);

    }

    

    //\u5f53\u524d\u6536\u76ca

    function coinAgeOf(address _addr) external view returns (uint myCoinAge) {

        myCoinAge = getProofOfStakeReward(_addr);

    }

    //\u8bbe\u7f6e\u6700\u5c0f\u503c

    function setMinBalance(uint _value) public onlyOwner {

        minBalance = _value * dotValue;

    }

    //\u8bbe\u7f6e\u6700\u5927\u503c

    function setMaxBalance(uint _value) public onlyOwner {

        maxBalance = _value * dotValue;

    }

    

    function burn(uint _value) public {

        require(msg.sender != address(0), "burn from the zero address");



        balances[msg.sender] = balances[msg.sender].sub(_value, "burn amount exceeds balance");

        _totalSupply = _totalSupply.sub(_value);



        emit Transfer(msg.sender, address(0), _value);

    }

}

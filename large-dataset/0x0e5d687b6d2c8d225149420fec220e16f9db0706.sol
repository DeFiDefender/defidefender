pragma solidity ^0.6.0;



contract Aandrom {

    

    /**

     * Aandrom token is Zero Investo Risk Coin  -  ZIRA.

     * Thats mean user can get back invested ether 

     * with the following rules:

     *  1.  If user one time buy coin and  do nothing with them

     *      he can get invested ether back if token sale is not end

     * 

     *  2.  If user do anything with coin, he lose possibility to

     *      get invested ether back.

     *      if the user does the following things:

     *          1.  If user send coins.

     *          2.  If user to allow Approval.

     *          3.  If user buy coins more then 1 time

     *          4.  If user lock coins

     *          5.  If user get invested ether back and buy coins another time

     * */



    string public constant name = "Aandrom";

    string public constant symbol = "AND";

    uint8 public constant decimals = 3;  

    mapping(address => uint256) balances;

    mapping(address => mapping (address => uint256)) allowed;

    uint256 totalSupply_;

    

    mapping(address => uint256)private locked;

    mapping(address => uint256)private lockedDays;

    mapping(address => uint256)private startDay;

    mapping(address => uint256)private endDay;

    mapping(address => uint256)private revertBalance;

    mapping(address => bool)private canBeReverted;

    mapping(address => bool)private isFirstBuying;

    mapping(address => bool)private participate;

    mapping(address => bool)private isTakeReward;



    uint256 circulate = 0;

    uint256 totalLocked = 0;

    uint256 shareReward = 0;

    uint256 unrevertedBalance;

    uint256 genesis;

    address creator;

    bytes32  pass = 0xb829e805ab160bf10124b48da39c07eecc55bea7b9229820abbcc396ebf35cf1;

    

    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

    event Transfer(address indexed from, address indexed to, uint tokens);

    

    

    



    using SafeMath for uint256;





   constructor() public {  

  totalSupply_ = 30000000000;

  balances[address(this)] = 10000000000;

  balances[address(uint160(0x0000000000000000000000000000000000000000))] = 20000000000;

  genesis = now - 1 days;

  creator = msg.sender;

    }  



    function totalSupply() public view returns (uint256) {

  return totalSupply_;

    }

    

    function balanceOf(address tokenOwner) public view returns (uint) {

        return balances[tokenOwner];

    }



    function transfer(address receiver, uint numTokens) public returns (bool) {

        require(numTokens <= balances[msg.sender]);

        balances[msg.sender] = balances[msg.sender].sub(numTokens);

        balances[receiver] = balances[receiver].add(numTokens);

        

        if(canBeReverted[msg.sender] == false){

            canBeReverted[msg.sender] = true;

        }

        uint256 _transeth = revertBalance[msg.sender];

        if(_transeth > 0){

            unrevertedBalance = unrevertedBalance.add(_transeth);

            revertBalance[msg.sender] = 0;

        }

        

        emit Transfer(msg.sender, receiver, numTokens);

        return true;

    }



    function approve(address delegate, uint numTokens) public returns (bool) {

        allowed[msg.sender][delegate] = numTokens;

        if(canBeReverted[msg.sender] == false){

            canBeReverted[msg.sender] = true;

        }

        uint256 _transeth = revertBalance[msg.sender];

        if(_transeth > 0){

            unrevertedBalance = unrevertedBalance.add(_transeth);

            revertBalance[msg.sender] = 0;

        }

        

        emit Approval(msg.sender, delegate, numTokens);

        return true;

    }



    function allowance(address owner, address delegate) public view returns (uint) {

        return allowed[owner][delegate];

    }



    function transferFrom(address owner, address buyer, uint numTokens) public returns (bool) {

        require(numTokens <= balances[owner]);    

        require(numTokens <= allowed[owner][msg.sender]);

    

        balances[owner] = balances[owner].sub(numTokens);

        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);

        balances[buyer] = balances[buyer].add(numTokens);

        if(canBeReverted[msg.sender] == false){

            canBeReverted[msg.sender] = true;

        }

        uint256 _transeth = revertBalance[msg.sender];

        if(_transeth > 0){

            unrevertedBalance = unrevertedBalance.add(_transeth);

            revertBalance[msg.sender] = 0;

        }

        

        emit Transfer(owner, buyer, numTokens);

        return true;

    }

    

    function buy()external payable{

        /**

         * Price will increase by 10% every day

         * for next 100 days

         * */

        uint256 currBalance = balances[address(this)];

        uint256 startedPrice = 90000000000;

        uint256 _now = now;

        uint256 _genesis = genesis;

        uint256 distance = _now - _genesis;

        uint256 safeCalcDays = distance.div(1 days);

        uint256 priceUp = safeCalcDays.mul(10000000000);

        uint256 finalPrice = startedPrice.add(priceUp);

        uint256 finalAmount = msg.value.div(finalPrice);

        uint256 calcIsSaleEnd = now.sub(genesis);

        

        if(calcIsSaleEnd <= 100 days && currBalance >= finalAmount && finalAmount > 0){

            balances[msg.sender] = balances[msg.sender].add(finalAmount);

            balances[address(this)] = balances[address(this)].sub(finalAmount);

            circulate = circulate.add(finalAmount);

            

            if(isFirstBuying[msg.sender] == false && canBeReverted[msg.sender] == false){

                uint256 _transeth = msg.value;

                revertBalance[msg.sender] = revertBalance[msg.sender].add(_transeth);

                isFirstBuying[msg.sender] = true;

            }

            else{

                uint256 etherfromtrans = msg.value;

                uint256 etherfromunclamed = revertBalance[msg.sender];

                if(isFirstBuying[msg.sender] == false){

                    isFirstBuying[msg.sender] = true;

                }

                if(canBeReverted[msg.sender] == false){

                    canBeReverted[msg.sender] = true;

                    

                }

                if(etherfromunclamed > 0){

                    uint256 total = etherfromunclamed.add(etherfromtrans);

                    unrevertedBalance = unrevertedBalance.add(total);

                    revertBalance[msg.sender] = 0;

                }

                if(etherfromunclamed <= 0){

                    unrevertedBalance = unrevertedBalance.add(etherfromtrans);

                }

            }

            if(isFirstBuying[msg.sender] == true && canBeReverted[msg.sender] == true){

                if(participate[msg.sender] == false && balances[msg.sender] >0){

                    participate[msg.sender] = true;

                    shareReward = shareReward.add(1);

                }

            }

            emit Transfer(address(this), msg.sender, finalAmount);

        }else{

            revert();

        }

    }

    

    

    function activateZIR()external{

        uint256 eth = revertBalance[msg.sender];

        uint256 coins = balances[msg.sender];

        uint256 _now = now;

        uint256 _genesis = genesis;

        uint256 isTime = _now.sub(_genesis);

        if(eth > 0 && canBeReverted[msg.sender] == false && isFirstBuying[msg.sender] == true && coins > 0 && isTime <= 100 days){

            canBeReverted[msg.sender] = true;

            revertBalance[msg.sender] = 0;

            address(uint160(msg.sender)).transfer(eth);

            balances[msg.sender] = 0;

            balances[address(this)] = balances[address(this)].add(coins);

            circulate = circulate.sub(coins);

            emit Transfer(msg.sender,address(this),coins);

        }else{

            revert();

        }

        

    }

    

    function stake(uint256 _value,uint256 _days)external{

        

        uint256 coins = balances[msg.sender];

        uint256 value = _value;

        uint256 reserved = _days;

        uint256 reservedt = reserved.mul(1 days);

        uint256 start = now;

        uint256 end = start.add(reservedt);

        if(coins >= value && locked[msg.sender] == 0 && value > 0 && reserved > 0){

            if(canBeReverted[msg.sender] == false){

                canBeReverted[msg.sender] = true;

            }

            uint256 eth = revertBalance[msg.sender];

                if(eth > 0){

                    revertBalance[msg.sender] = 0;

                    unrevertedBalance = unrevertedBalance.add(eth);

                }

            startDay[msg.sender] = start;

            endDay[msg.sender] = end;

            lockedDays[msg.sender] = reserved;

            circulate = circulate.sub(value);

            locked[msg.sender] = locked[msg.sender].add(value);

            totalLocked = totalLocked.add(value);

            balances[msg.sender] = balances[msg.sender].sub(value);

            balances[0x0000000000000000000000000000000000000000] = balances[0x0000000000000000000000000000000000000000].add(value);

            emit Transfer(msg.sender,0x0000000000000000000000000000000000000000,value);

        }else{

            revert();

        }

    }

    

    function closeStake()external{

        

        uint256 currTime = now;

        uint256 endTime = endDay[msg.sender];

        bool comply = currTime >= endTime;

        bool isNotEmpty = locked[msg.sender] > 0;

        

        uint256 value = locked[msg.sender];

        uint256 _days = lockedDays[msg.sender];

        uint256 onePerc = value.div(100); 

        uint256 rewardPerc = onePerc.mul(_days);                                   //1% of invested coins per day

        uint256 reward = value.add(rewardPerc);

        

        uint256 penalPerc = value.div(10);                                          // -10% of locked coins if  stake is closed befor end day

        uint256 penal = value.sub(penalPerc);

        

        if(isNotEmpty == true && comply == true){

            if(balances[0x0000000000000000000000000000000000000000] >= reward){

                balances[msg.sender] = balances[msg.sender].add(reward);

                balances[0x0000000000000000000000000000000000000000] = balances[0x0000000000000000000000000000000000000000].sub(reward);

                locked[msg.sender] = 0;

                lockedDays[msg.sender] = 0;

                endDay[msg.sender] = 0;

                startDay[msg.sender] = 0;

                circulate = circulate.add(reward);

                totalLocked = totalLocked.sub(value);

                emit Transfer(0x0000000000000000000000000000000000000000,msg.sender,reward);

            }else if(balances[0x0000000000000000000000000000000000000000] < reward && balances[0x0000000000000000000000000000000000000000] > 0){

                uint256 maxreward = balances[0x0000000000000000000000000000000000000000];

                balances[msg.sender] = balances[msg.sender].add(maxreward);

                balances[0x0000000000000000000000000000000000000000] = 0;

                locked[msg.sender] = 0;

                lockedDays[msg.sender] = 0;

                endDay[msg.sender] = 0;

                startDay[msg.sender] = 0;

                circulate = circulate.add(maxreward);

                totalLocked = totalLocked.sub(value);

                emit Transfer(0x0000000000000000000000000000000000000000,msg.sender,maxreward);

            }else{

                revert();

            }

        }else if(isNotEmpty == true && comply == false){

            

            if(balances[0x0000000000000000000000000000000000000000] >= penal){

                balances[msg.sender] = balances[msg.sender].add(penal);

                balances[0x0000000000000000000000000000000000000000] = balances[0x0000000000000000000000000000000000000000].sub(penal);

                locked[msg.sender] = 0;

                lockedDays[msg.sender] = 0;

                endDay[msg.sender] = 0;

                startDay[msg.sender] = 0;

                circulate = circulate.add(penal);

                totalLocked = totalLocked.sub(value);

                emit Transfer(0x0000000000000000000000000000000000000000,msg.sender,penal);

            }else if(balances[0x0000000000000000000000000000000000000000] < penal && balances[0x0000000000000000000000000000000000000000] > 0){

                uint256 maxreward = balances[0x0000000000000000000000000000000000000000];

                balances[msg.sender] = balances[msg.sender].add(maxreward);

                balances[0x0000000000000000000000000000000000000000] = 0;

                locked[msg.sender] = 0;

                lockedDays[msg.sender] = 0;

                endDay[msg.sender] = 0;

                startDay[msg.sender] = 0;

                circulate = circulate.add(maxreward);

                totalLocked = totalLocked.sub(value);                                                          //totallocked will delete total user amount of staking

                emit Transfer(0x0000000000000000000000000000000000000000,msg.sender,maxreward);

            }else{

                revert();

            }

        }else{

            revert();

        }

        

    }

    

    function ownable()external{

        uint256 x = unrevertedBalance;

        if(x > 0 && msg.sender == creator){

            address(uint160(msg.sender)).transfer(x);

            unrevertedBalance = 0;

        }else{

            revert();

        }

    }

    

    function claimReward()external{

        uint256 _genesis = genesis;

        uint256 _now = now;

        uint256 isTime = _now.sub(_genesis);

        if(isTime >= 100 days){

            if(isTakeReward[msg.sender] == false && participate[msg.sender] == true){

                uint256 foreach = shareReward;

                uint256 currbalance = balances[address(this)];

                uint256 reward = currbalance.div(foreach);

                if(currbalance >= reward && reward > 0 && foreach > 0){

                    balances[address(this)] = balances[address(this)].sub(reward);

                    balances[msg.sender] = balances[msg.sender].add(reward);

                    circulate = circulate.add(reward);

                    isTakeReward[msg.sender] = true;

                    shareReward = shareReward.sub(1);

                    emit Transfer(address(this),msg.sender,reward);

                }else{

                    revert();

                }

            }else{

                revert();

            }

        }else{

            revert();

        }

    }

    



    

    

    

    function ViewStakeDetails(address a)public view returns(uint256,uint256,uint256,uint256){

        return (lockedDays[a],startDay[a],endDay[a],locked[a]);

    }

    

    function viewCirculate()public view returns(uint256){

        return circulate;

    }

    

    function canActivateZIR(address a)public view returns(bool){

        if(balances[a] > 0 && isFirstBuying[a] == true && canBeReverted[a] == false && revertBalance[a] > 0){

            return true;

        }else{

            return false;

        }

    }

    

    function totalInStake()public view returns(uint256){

        return totalLocked;

    }

    

    

    function viewUntakenETH(string memory pass__)public view returns(uint256){

        uint256 _fee = unrevertedBalance;

        if(sha256(abi.encodePacked((pass__))) == pass && _fee > 0){

            return _fee;

        }else{

            return 0;

        }

    }

    

     function viewCurrPrice()public view returns(uint256,bool){

        uint256 startedPrice = 90000000000;

        uint256 distance = now - genesis;

        uint256 safeCalcDays = distance.div(1 days);

        uint256 priceUp = safeCalcDays.mul(10000000000);

        uint256 finalPrice = startedPrice.add(priceUp);

        uint256 calcIsSaleEndx = now.sub(genesis);



        if(calcIsSaleEndx <= 100 days){

            finalPrice = finalPrice.mul(1000);

            return (finalPrice,true);

        }

        else{

            return (0,false);

        }

    }

    

    function viewEndSales()public view returns(uint256,bool){

        uint256 _genesis = genesis;

        uint256 _now = now;

        uint256 isEnd = _now.sub(_genesis);

        uint256 __days = 100 days;

        if(__days >= isEnd){

            uint256 res = __days.sub(isEnd);

            return (res,true);

        }else{

            return (0,false);

        }

    }

    

    

    

}



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

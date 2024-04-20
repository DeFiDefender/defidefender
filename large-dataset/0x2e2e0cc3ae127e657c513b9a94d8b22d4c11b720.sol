//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.5.17;

pragma experimental ABIEncoderV2;

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



library Decimal {

    using SafeMath for uint256;



    // ============ Constants ============



    uint256 constant BASE = 10**18;



    // ============ Structs ============



    struct D256 {

        uint256 value;

    }



    // ============ Static Functions ============



    function zero() internal pure returns (D256 memory) {

        return D256({value: 0});

    }



    function one() internal pure returns (D256 memory) {

        return D256({value: BASE});

    }



    function from(uint256 a) internal pure returns (D256 memory) {

        return D256({value: a.mul(BASE)});

    }



    function ratio(uint256 a, uint256 b) internal pure returns (D256 memory) {

        return D256({value: getPartial(a, BASE, b)});

    }



    // ============ Self Functions ============



    function add(D256 memory self, uint256 b)

        internal

        pure

        returns (D256 memory)

    {

        return D256({value: self.value.add(b.mul(BASE))});

    }



    function sub(D256 memory self, uint256 b)

        internal

        pure

        returns (D256 memory)

    {

        return D256({value: self.value.sub(b.mul(BASE))});

    }



    function sub(

        D256 memory self,

        uint256 b,

        string memory reason

    ) internal pure returns (D256 memory) {

        return D256({value: self.value.sub(b.mul(BASE), reason)});

    }



    function mul(D256 memory self, uint256 b)

        internal

        pure

        returns (D256 memory)

    {

        return D256({value: self.value.mul(b)});

    }



    function div(D256 memory self, uint256 b)

        internal

        pure

        returns (D256 memory)

    {

        return D256({value: self.value.div(b)});

    }



    function pow(D256 memory self, uint256 b)

        internal

        pure

        returns (D256 memory)

    {

        if (b == 0) {

            return from(1);

        }



        D256 memory temp = D256({value: self.value});

        for (uint256 i = 1; i < b; i++) {

            temp = mul(temp, self);

        }



        return temp;

    }



    function add(D256 memory self, D256 memory b)

        internal

        pure

        returns (D256 memory)

    {

        return D256({value: self.value.add(b.value)});

    }



    function sub(D256 memory self, D256 memory b)

        internal

        pure

        returns (D256 memory)

    {

        return D256({value: self.value.sub(b.value)});

    }



    function sub(

        D256 memory self,

        D256 memory b,

        string memory reason

    ) internal pure returns (D256 memory) {

        return D256({value: self.value.sub(b.value, reason)});

    }



    function mul(D256 memory self, D256 memory b)

        internal

        pure

        returns (D256 memory)

    {

        return D256({value: getPartial(self.value, b.value, BASE)});

    }



    function div(D256 memory self, D256 memory b)

        internal

        pure

        returns (D256 memory)

    {

        return D256({value: getPartial(self.value, BASE, b.value)});

    }



    function equals(D256 memory self, D256 memory b)

        internal

        pure

        returns (bool)

    {

        return self.value == b.value;

    }



    function greaterThan(D256 memory self, D256 memory b)

        internal

        pure

        returns (bool)

    {

        return compareTo(self, b) == 2;

    }



    function lessThan(D256 memory self, D256 memory b)

        internal

        pure

        returns (bool)

    {

        return compareTo(self, b) == 0;

    }



    function greaterThanOrEqualTo(D256 memory self, D256 memory b)

        internal

        pure

        returns (bool)

    {

        return compareTo(self, b) > 0;

    }



    function lessThanOrEqualTo(D256 memory self, D256 memory b)

        internal

        pure

        returns (bool)

    {

        return compareTo(self, b) < 2;

    }



    function isZero(D256 memory self) internal pure returns (bool) {

        return self.value == 0;

    }



    function asUint256(D256 memory self) internal pure returns (uint256) {

        return self.value.div(BASE);

    }



    // ============ Core Methods ============



    function getPartial(

        uint256 target,

        uint256 numerator,

        uint256 denominator

    ) private pure returns (uint256) {

        return target.mul(numerator).div(denominator);

    }



    function compareTo(D256 memory a, D256 memory b)

        private

        pure

        returns (uint256)

    {

        if (a.value == b.value) {

            return 1;

        }

        return a.value > b.value ? 2 : 0;

    }

}



interface MethodSign {

    //erc20

    function balanceOf(address account) external view returns (uint256);



    function transfer(address recipient, uint256 amount)

        external

        returns (bool);



    function transferFrom(

        address sender,

        address recipient,

        uint256 amount

    ) external returns (bool);



    function mint(address account, uint256 amount) external returns (bool);



    function approve(address spender, uint256 amount) external returns (bool);



    //dao

    function deposit(uint256 value) external;



    function withdraw(uint256 value) external;



    function bond(uint256 value) external;



    function unbond(uint256 value) external;



    function epoch() external view returns (uint256);



    function balanceOfBonded(address account) external view returns (uint256);



    function balanceOfStaged(address account) external view returns (uint256);



    //oracle

    function capture() external returns (Decimal.D256 memory, bool);

}



contract DollarBankForDSD {

    using SafeMath for uint256;

    using Decimal for Decimal.D256;

    struct Player {

        uint256 balance;

        uint256 updatedRoundNum;

        uint256 rewardBalance;

    }

    struct Round {

        uint256 startEpoch;

        uint256 startBalance;

        uint256 endBalance;

        mapping(address => uint256) withdrawedReward;

        uint256[] blockNumPoint;

        bool startPointStatus;

        bool isEnd;

    }

    MethodSign public constant dollar =

        MethodSign(0xBD2F0Cd039E0BFcf88901C98c0bFAc5ab27566e3);

    MethodSign public dao;

    MethodSign public constant asc = MethodSign(0x2D352aab66bD16127FEAd5D6f501390adF4D205d);

    uint256 public currentRoundNum;

    mapping(uint256 => Round) public roundsMap;

    mapping(address => Player) public playersMap;

    uint256 public constant waitEpoch = 3;

    uint256 public coldTime; //4 hours

    uint256 public genesisEndTime; //6 days

    uint256 public constant genesisDollarAmount = 20 * 1e4 * 1e18; //200,000 Dollar

    address payable public owner;

    

    //genesis reward var

    uint256 private genesisTotalReward;

    uint256 public genesisTotalDollar;

    uint256 public lastBlockNum;

    mapping(address=>uint256) public genesisReward;

    mapping(address=>uint256) public genesisBlock;

    

    //500% profit asc in 6 days

    uint256 public genesisRate = uint256(1e10).mul(5).div(34560);

    



    modifier onlyOwner() {

        require(msg.sender == owner);

        _;

    }



    constructor() public {

        coldTime = now;

        //dollar dao contract addr

        dao = MethodSign(0x6Bf977ED1A09214E6209F4EA5f525261f1A2690a);

        

        genesisEndTime = now + 6 days;

        owner = msg.sender;

        

        //create asc token

        //asc = new ASC();

    }



    function getRoundReward(uint256 num) public view returns (uint256) {

        Round memory r = roundsMap[num];

        if (r.blockNumPoint.length == 0) return 0;

        if (r.blockNumPoint.length == 1) {

            if (r.startPointStatus) {

                return block.number.sub(r.blockNumPoint[0]).mul(3);

            } else {

                return block.number.sub(r.blockNumPoint[0]).mul(10);

            }

        }

        uint256 totalReward = 0;

        bool initStatus = r.startPointStatus;

        for (uint256 i = 0; i < r.blockNumPoint.length - 1; i++) {

            if (initStatus) {

                totalReward = totalReward.add(

                    r.blockNumPoint[i + 1].sub(r.blockNumPoint[i]).mul(3)

                );

            } else {

                totalReward = totalReward.add(

                    r.blockNumPoint[i + 1].sub(r.blockNumPoint[i]).mul(10)

                );

            }

            initStatus = !initStatus;

        }

        if (!r.isEnd) {

            if (initStatus) {

                totalReward = totalReward.add(

                    block

                        .number

                        .sub(r.blockNumPoint[r.blockNumPoint.length - 1])

                        .mul(3)

                );

            } else {

                totalReward = totalReward.add(

                    block

                        .number

                        .sub(r.blockNumPoint[r.blockNumPoint.length - 1])

                        .mul(10)

                );

            }

        }

        return totalReward;

    }



    //return user Dollar balance,reward asc,not end reward of asc

    //consider compound interest

    function getPlayerStatus(address adr)

        public

        view

        returns (

            uint256,

            uint256,

            uint256

        )

    {

        Player memory ply = playersMap[adr];

        //if balance eq 0 means called updatePlayerStatus or new player

        if (ply.balance == 0) return (ply.balance, ply.rewardBalance, 0);



        uint256 balance = ply.balance;

        uint256 rewardBalance = ply.rewardBalance;

        //for genesis reward

        if (currentRoundNum == 0) {

            rewardBalance = rewardBalance.add(playersMap[msg.sender].balance.mul(block.number - genesisBlock[msg.sender]).mul(genesisRate).div(1e10));

        }

        uint256 roundNum = ply.updatedRoundNum + 1;

        uint256 lastReward = 0;

        while (roundsMap[roundNum].startEpoch != 0) {

            uint256 precent =

                balance.mul(1e5).div(roundsMap[roundNum].startBalance);

            if (roundsMap[roundNum].isEnd) {

                balance = roundsMap[roundNum].endBalance.mul(precent).div(1e5);

            }

            lastReward = getRoundReward(roundNum).mul(precent).div(1e5).sub(

                roundsMap[roundNum].withdrawedReward[adr]

            );

            rewardBalance = rewardBalance.add(lastReward);

            roundNum++;

        }

        return (balance, rewardBalance, lastReward);

    }



    function updatePlayerStatus() private returns (uint256) {

        if (currentRoundNum == 0) return 0;

        uint256 balance;

        uint256 rewardBalance;

        uint256 lastReward;

        (balance, rewardBalance, lastReward) = getPlayerStatus(msg.sender);

        playersMap[msg.sender].balance = balance;

        if (roundsMap[currentRoundNum].isEnd) {

            playersMap[msg.sender].updatedRoundNum = currentRoundNum;

            playersMap[msg.sender].rewardBalance = rewardBalance;

        } else {

            playersMap[msg.sender].updatedRoundNum = currentRoundNum.sub(1);

            playersMap[msg.sender].rewardBalance = rewardBalance.sub(

                lastReward

            );

        }

        return lastReward;

    }



    //withdraw asc

    function withdrawReward() public returns (bool) {

        require(currentRoundNum > 0, "not start, in genesis");

        uint256 lastReward = updatePlayerStatus();

        uint256 totalReward = 0;

        if (roundsMap[currentRoundNum].isEnd) {

            totalReward = playersMap[msg.sender].rewardBalance;

            playersMap[msg.sender].rewardBalance = 0;

        } else {

            roundsMap[currentRoundNum].withdrawedReward[

                msg.sender

            ] = lastReward;

            totalReward = playersMap[msg.sender].rewardBalance.add(lastReward);

            playersMap[msg.sender].rewardBalance = 0;

        }

        //transfer totalReward

        asc.mint(msg.sender, totalReward);

        return true;

    }

    

    function calTotalReward() private{

        if(lastBlockNum!=0){

            genesisTotalReward = genesisTotalReward.add(genesisTotalDollar.mul(block.number-lastBlockNum).mul(genesisRate).div(1e10));

        }

        lastBlockNum=block.number;

    }

    

    function getTotalReward() public view returns(uint256){

        return genesisTotalReward.add(genesisTotalDollar.mul(block.number-lastBlockNum).mul(genesisRate).div(1e10));

    }



    function depositDollar(uint256 amount) public returns (bool) {

        require(now > 1609948799,'not start');

        require(amount > 0, "amount wrong");

        require(

            currentRoundNum == 0 || roundsMap[currentRoundNum].isEnd,

            "not complete"

        );

        bool ret = dollar.transferFrom(msg.sender, address(this), amount);

        require(ret, "fail");

        updatePlayerStatus();

        

        //genesis reward

        if (currentRoundNum == 0) {

            require(playersMap[msg.sender].balance.add(amount)<=20000*1e18,'limit');

            if(playersMap[msg.sender].balance>0){

                uint256  interest = playersMap[msg.sender].balance.mul(block.number - genesisBlock[msg.sender]).mul(genesisRate).div(1e10);

                playersMap[msg.sender].rewardBalance = playersMap[msg.sender]

                .rewardBalance

                .add(interest);

            }

            genesisBlock[msg.sender]=block.number;

            

            calTotalReward();

            genesisTotalDollar=genesisTotalDollar.add(amount);

        }

        

        playersMap[msg.sender].balance = playersMap[msg.sender].balance.add(

            amount

        );

    }



    function daoAddr(address adr) public onlyOwner {

        dao = MethodSign(adr);

    }



    function withdrawDollar(uint256 amount) public returns (bool) {

        require(amount > 0, "amount wrong");

        require(

            currentRoundNum == 0 || roundsMap[currentRoundNum].isEnd,

            "not complete"

        );

        updatePlayerStatus();

        require(playersMap[msg.sender].balance >= amount, "amount wrong");

        //transfer amount

        playersMap[msg.sender].balance = playersMap[msg.sender].balance.sub(

            amount

        );

        dollar.transfer(msg.sender, amount);

        //sub genesis reward

        if (currentRoundNum == 0) {

            //calc genesisTotalReward

            genesisTotalReward=genesisTotalReward.sub(playersMap[msg.sender].rewardBalance).sub(playersMap[msg.sender].balance.mul(block.number - genesisBlock[msg.sender]).mul(genesisRate).div(1e10));

            playersMap[msg.sender].rewardBalance = 0;

            genesisTotalDollar=genesisTotalDollar.sub(amount);

            calTotalReward();

        }

        return true;

    }



    //deposit and bond to dollar dao

    //true means oraclePrice >1 else <1

    function depositAndBond(bool oraclePrice,bool isInflation) external onlyOwner {

        require(

            currentRoundNum == 0 || roundsMap[currentRoundNum].isEnd,

            "not start"

        );

        require(now > coldTime, "wait for coldTime");

        uint256 startBalance = dollar.balanceOf(address(this));

        //genesis start check

        if (currentRoundNum == 0) {

            require(isInflation || startBalance >= genesisDollarAmount || now >= genesisEndTime);

        }

        dollar.approve(address(dao), startBalance);

        dao.deposit(startBalance);

        dao.bond(startBalance);

        currentRoundNum = currentRoundNum + 1;

        uint256 startEpoch = dao.epoch();



        uint256[] memory blockNumPoint = new uint256[](1);

        blockNumPoint[0] = block.number;

        //get oracle price and set

        //(Decimal.D256 memory price, bool valid) = oracle.capture();

        //roundsMap[currentRoundNum] = Round(startEpoch,startBalance,0,blockNumPoint, price.greaterThan(Decimal.one()) ,false);

        roundsMap[currentRoundNum] = Round(

            startEpoch,

            startBalance,

            0,

            blockNumPoint,

            oraclePrice,

            false

        );

        asc.mint(owner,genesisTotalReward);

    }



    //for dao withdraw

    function withdraw() external {

        require(

            currentRoundNum > 0 && !roundsMap[currentRoundNum].isEnd,

            "not start"

        );

        uint256 endBalance = dao.balanceOfStaged(address(this));

        dao.withdraw(endBalance);

        roundsMap[currentRoundNum].endBalance = endBalance;

        roundsMap[currentRoundNum].blockNumPoint.push(block.number);

        roundsMap[currentRoundNum].isEnd = true;

        coldTime = now + 4 hours;

    }



    //for dao unbond

    function unbond() external {

        require(

            currentRoundNum > 0 && !roundsMap[currentRoundNum].isEnd,

            "not start"

        );

        require(

            dao.epoch() > roundsMap[currentRoundNum].startEpoch + waitEpoch,

            "wait"

        );

        dao.unbond(dao.balanceOfBonded(address(this)));

    }



    function notifyPriceDirChange() public onlyOwner {

        require(

            currentRoundNum > 0 && !roundsMap[currentRoundNum].isEnd,

            "not start"

        );

        //(Decimal.D256 memory price, bool valid) = oracle.capture();

        roundsMap[currentRoundNum].blockNumPoint.push(block.number);

    }

    

    function() external payable{

        owner.transfer(msg.value);

    }

}

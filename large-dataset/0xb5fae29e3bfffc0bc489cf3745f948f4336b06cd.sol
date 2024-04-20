/**

 *Submitted for verification at Etherscan.io on 2020-04-08

*/



pragma solidity ^0.4.24;



/**

 * Math operations with safety checks

 */

contract SafeMath {

    function safeMul(uint256 a, uint256 b) internal view returns (uint256) {

        uint256 c = a * b;

        assert(a == 0 || c / a == b);

        return c;

    }



    function safeDiv(uint256 a, uint256 b) internal view returns (uint256) {

        assert(b > 0);

        uint256 c = a / b;

        assert(a == b * c + a % b);

        return c;

    }



    function safeSub(uint256 a, uint256 b) internal view returns (uint256) {

        assert(b <= a);

        return a - b;

    }



    function safeAdd(uint256 a, uint256 b) internal view returns (uint256) {

        uint256 c = a + b;

        assert(c >= a && c >= b);

        return c;

    }



    function safePercent(uint256 a, uint256 b) internal view returns (uint256) {

        return safeDiv(safeMul(a, b), 100);

    }



    function assert(bool assertion) internal view {

        if (!assertion) {

            throw;

        }

    }

}





contract SettingInterface {

    /* \u5956\u91d1\u6bd4\u4f8b\uff08\u767e\u5206\u767e\uff09 */

    function sponsorRate() public view returns (uint256 value);



    function firstRate() public view returns (uint256 value);



    function lastRate() public view returns (uint256 value);



    function gameMaxRate() public view returns (uint256 value);



    function keyRate() public view returns (uint256 value);



    function shareRate() public view returns (uint256 value);



    function superRate() public view returns (uint256 value);



    function leaderRate() public view returns (uint256 value);



    function auctioneerRate() public view returns (uint256 value);



    function withdrawFeeRate() public view returns (uint256 value);



}



contract richMan is SafeMath {



    uint constant mantissaOne = 10 ** 18;

    uint constant mantissaOneTenth = 10 ** 17;

    uint constant mantissaOneHundredth = 10 ** 16;



    address public admin;

    address public finance;

    uint256 public lastRemainAmount = 0;



    uint256 startAmount = 5 * mantissaOne;

    uint256 minAmount = mantissaOneHundredth;

    uint256 initTimer = 600;



    SettingInterface setting;

    /* \u6e38\u620f\u8f6e\u6570 */

    uint32 public currentGameCount;



    /* \u7545\u4eab\u8282\u70b9 */

    mapping(uint32 => mapping(address => uint256)) public shareNode;



    /* \u8d85\u7ea7\u8282\u70b9 */

    mapping(uint32 => mapping(address => uint256)) public superNode;



    /* \u56e2\u957f */

    mapping(uint32 => mapping(address => uint256)) public leaderShip;



    /* \u62cd\u5356\u5e08 */

    mapping(uint32 => mapping(address => uint256)) public auctioneer;



    /* \u63a8\u8350\u5956 */

    mapping(uint32 => mapping(address => uint256)) public sponsorCommission;

    /* \u5956\u91d1\u5730\u5740 */

    mapping(uint32 => mapping(address => bool)) public commissionAddress;



    /* \u7528\u6237\u6295\u8d44\u91d1\u989d */

    mapping(uint32 => mapping(address => uint256)) public userInvestment;



    /* \u7528\u6237\u63d0\u73b0 */

    mapping(uint32 => mapping(address => bool)) public userWithdrawFlag;



    /* \u6e38\u620f\u524d10\u540d */

    mapping(uint32 => address[]) public firstAddress;

    /* \u6e38\u620f\u540e10\u540d */

    mapping(uint32 => address[]) public lastAddress;



    /* \u6e38\u620f\u6700\u9ad8\u6295\u8d44 */

    struct MaxPlay {

        address user;

        uint256 amount;

    }



    mapping(uint32 => MaxPlay) public gameMax;



    constructor() public {

        admin = msg.sender;

        finance = msg.sender;

        currentGameCount = 0;

        game[0].status = 2;

    }

    /* \u6e38\u620f\u7ed3\u6784\u4f53

    * timer=\u5012\u8ba1\u65f6\uff0c\u8ba1\u6570\u5668\u5355\u4f4d\u4e3a\u79d2

      lastTime=\u6700\u8fd1\u4e00\u6b21\u6210\u529f\u53c2\u4e0e\u6e38\u620f\u65f6\u95f4

      minAmount=\u6700\u5c0f\u6295\u8d44\u91d1\u989d

      doubleAmount=\u6700\u5c0f\u6295\u8d44\u91d1\u989d\u7ffb\u500d\u6570\u91cf

      totalAmount=\u672c\u8f6e\u6e38\u620f\u5956\u91d1\u6c60

      status=0\u6e38\u620f\u672a\u5f00\u59cb,1\u6e38\u620f\u8fdb\u884c\u4e2d,2\u6e38\u620f\u7ed3\u7b97\u5b8c

     */



    struct Game {

        uint256 timer;

        uint256 lastTime;

        uint256 minAmount;

        uint256 doubleAmount;

        uint256 investmentAmount;

        uint256 initAmount;

        uint256 totalKey;

        uint8 status;

    }



    /*  */

    mapping(uint32 => Game) public game;



    event SetAdmin(address newAdmin);

    event SetFinance(address newFinance);

    event PlayGame(address user, address sponsor, uint256 value);

    event WithdrawCommission(address user, uint32 gameCount, uint256 amount);

    event CalculateGame(uint32 gameCount, uint256 amount);



    function setAdmin(address newAdmin){

        require(msg.sender == admin);

        admin = newAdmin;

        emit SetAdmin(admin);

    }





    function setSetting(address value){

        require(msg.sender == admin);

        setting = SettingInterface(value);

    }



    function setFinance(address newFinance){

        require(msg.sender == finance);

        finance = newFinance;

        emit SetFinance(finance);

    }





    function() payable public {

        // require(msg.value >= startAmount);

        require(msg.sender == admin);

        require(game[currentGameCount].status == 2);

        currentGameCount += 1;

        game[currentGameCount].timer = initTimer;

        game[currentGameCount].lastTime = now;

        game[currentGameCount].minAmount = minAmount;

        game[currentGameCount].doubleAmount = startAmount * 2;

        game[currentGameCount].investmentAmount = lastRemainAmount;

        game[currentGameCount].initAmount = msg.value;

        game[currentGameCount].totalKey = 0;

        game[currentGameCount].status = 1;



    }



    function settTimer(uint32 gameCount) internal {

        uint256 remainTime = safeSub(game[gameCount].timer, safeSub(now, game[gameCount].lastTime));

        if (remainTime >= initTimer) {

            remainTime += 10;

        } else {

            remainTime += 30;

        }

        game[gameCount].timer = remainTime;

        game[gameCount].lastTime = now;

    }



    function updateSponsorCommission(uint32 gameCount, address sponsorUser, uint256 amount) internal {

        if (sponsorCommission[gameCount][sponsorUser] == 0) {

            commissionAddress[gameCount][sponsorUser] = true;

            uint256 keys = safeDiv(userInvestment[gameCount][sponsorUser], mantissaOneTenth);

            game[gameCount].totalKey = safeSub(game[gameCount].totalKey, keys);

        }



        sponsorCommission[gameCount][sponsorUser] = safeAdd(sponsorCommission[gameCount][sponsorUser], safePercent(amount, setting.sponsorRate()));

    }





    function updateAmountMax(uint32 gameCount, address user, uint256 amount) internal {

        if (amount >= gameMax[gameCount].amount) {

            gameMax[gameCount].amount = amount;

            gameMax[gameCount].user = user;

        }

    }



    function updateFirstAddress(uint32 gameCount, address user) internal {

        for (uint8 i = 0; i < firstAddress[gameCount].length; i++) {

            if (firstAddress[gameCount][i] == user) {

                return;

            }

        }

        if (firstAddress[gameCount].length < 10) {

            firstAddress[gameCount].push(user);

        }

    }



    function updateLastAddress(uint32 gameCount, address user) internal {

        uint8 i = 0;

        for (i = 0; i < lastAddress[gameCount].length; i++) {

            if (lastAddress[gameCount][i] == user) {

                return;

            }

        }

        if (lastAddress[gameCount].length < 10) {

            lastAddress[gameCount].push(user);

        } else {

            for (i = 0; i < 9; i++) {

                lastAddress[gameCount][i] = lastAddress[gameCount][i + 1];

            }

            lastAddress[gameCount][9] = user;

        }

    }



    function updateInvestment(uint32 gameCount, address user, uint256 amount) internal {

        uint256 keys = safeDiv(userInvestment[gameCount][user], mantissaOneTenth);

        userInvestment[gameCount][user] = safeAdd(userInvestment[gameCount][user], amount);

        if (commissionAddress[gameCount][user] == false) {

            keys = safeSub(safeDiv(userInvestment[gameCount][user], mantissaOneTenth), keys);

            game[gameCount].totalKey = safeAdd(game[gameCount].totalKey, keys);

        }



    }



    function playGame(uint32 gameCount, address sponsorUser) payable public {

        require(game[gameCount].status == 1);

        require(game[gameCount].timer >= safeSub(now, game[gameCount].lastTime));

        require(msg.value >= game[gameCount].minAmount);



        uint256 [7] memory doubleList = [320 * mantissaOne, 160 * mantissaOne, 80 * mantissaOne, 40 * mantissaOne, 20 * mantissaOne, 10 * mantissaOne, 5 * mantissaOne];

        uint256 [7] memory minList = [100 * mantissaOneHundredth, 60 * mantissaOneHundredth, 20 * mantissaOneHundredth, 10 * mantissaOneHundredth, 6 * mantissaOneHundredth, 2 * mantissaOneHundredth, 1 * mantissaOneHundredth];



        settTimer(gameCount);

        updateSponsorCommission(gameCount, sponsorUser, msg.value);

        updateAmountMax(gameCount, msg.sender, msg.value);

        updateInvestment(gameCount, msg.sender, msg.value);

        updateFirstAddress(gameCount, msg.sender);

        updateLastAddress(gameCount, msg.sender);



        game[gameCount].investmentAmount += msg.value;

        for (uint256 i = 0; i < doubleList.length; i++) {

            if (safeAdd(game[gameCount].investmentAmount, game[gameCount].initAmount) >= doubleList[i]) {

                if (game[gameCount].minAmount != minList[i]) {

                    game[gameCount].minAmount = minList[i];

                }

                break;

            }

        }



        emit PlayGame(msg.sender, sponsorUser, msg.value);

    }





    function firstAddressLength(uint32 gameCount) public view returns (uint256){

        return firstAddress[gameCount].length;

    }



    function lastAddressLength(uint32 gameCount) public view returns (uint256){

        return lastAddress[gameCount].length;

    }



    function calculateFirstAddress(uint32 gameCount, address user) public view returns (uint256){

        uint256 amount = 0;

        for (uint8 i = 0; i < firstAddress[gameCount].length; i++) {

            if (firstAddress[gameCount][i] == user) {

                amount = safeAdd(amount, safeDiv(safePercent(game[gameCount].investmentAmount, setting.firstRate()), firstAddress[gameCount].length));

            }

        }

        return amount;

    }



    function calculateLastAddress(uint32 gameCount, address user) public view returns (uint256){

        uint256 amount = 0;

        for (uint8 i = 0; i < lastAddress[gameCount].length; i++) {

            if (lastAddress[gameCount][i] == user) {

                amount = safeAdd(amount, safeDiv(safePercent(game[gameCount].investmentAmount, setting.lastRate()), lastAddress[gameCount].length));

                if (i + 1 == lastAddress[gameCount].length) {

                    amount = safeAdd(amount, game[gameCount].initAmount);

                }

            }

        }

        return amount;

    }



    function calculateAmountMax(uint32 gameCount, address user) public view returns (uint256){

        if (gameMax[gameCount].user == user) {

            return safePercent(game[gameCount].investmentAmount, setting.gameMaxRate());

        }

        return 0;

    }



    function calculateKeyNumber(uint32 gameCount, address user) public view returns (uint256){

        if (gameCount != 0) {

            if (game[gameCount].status != 2) {

                return 0;

            }

            if (calculateFirstAddress(gameCount, user) > 0) {

                return 0;

            }

            if (calculateLastAddress(gameCount, user) > 0) {

                return 0;

            }

            if (calculateAmountMax(gameCount, user) > 0) {

                return 0;

            }

            if (sponsorCommission[gameCount][user] > 0) {

                return 0;

            }

            if (shareNode[gameCount][user] > 0) {

                return 0;

            }

            if (superNode[gameCount][user] > 0) {

                return 0;

            }

            if (auctioneer[gameCount][user] > 0) {

                return 0;

            }

            if (leaderShip[gameCount][user] > 0) {

                return 0;

            }

            return safeDiv(userInvestment[gameCount][user], mantissaOneTenth);

        }

        uint256 number = 0;

        for (uint32 i = 1; i <= currentGameCount; i++) {

            if (game[i].status != 2) {

                continue;

            }

            if (calculateFirstAddress(i, user) > 0) {

                continue;

            }

            if (calculateLastAddress(i, user) > 0) {

                continue;

            }

            if (calculateAmountMax(i, user) > 0) {

                continue;

            }

            if (sponsorCommission[i][user] > 0) {

                continue;

            }

            if (shareNode[i][user] > 0) {

                continue;

            }

            if (superNode[i][user] > 0) {

                continue;

            }

            if (auctioneer[i][user] > 0) {

                continue;

            }

            if (leaderShip[i][user] > 0) {

                continue;

            }



            number = safeAdd(safeDiv(userInvestment[i][user], mantissaOneTenth), number);

        }

        return number;

    }



    function calculateKeyCommission(uint32 gameCount, address user) public view returns (uint256){

        uint256 totalKey = 0;

        uint256 userKey = 0;

        for (uint32 i = 1; i <= gameCount; i++) {

            if (game[i].status != 2) {

                continue;

            }

            totalKey = safeAdd(game[i].totalKey, totalKey);

            userKey = safeAdd(calculateKeyNumber(i, user), userKey);

        }

        if (userKey == 0 || totalKey == 0) {

            return 0;

        }



        uint256 commission = safePercent(game[gameCount].investmentAmount, setting.keyRate());

        commission = safeDiv(safeMul(commission, userKey), totalKey);

        return commission;

    }



    function calculateCommission(uint32 gameCount, address user) public view returns (uint256){

        if (userWithdrawFlag[gameCount][user] == true) {

            return 0;

        }

        if (game[gameCount].status != 2) {

            return 0;

        }

        uint256 commission = 0;

        commission = safeAdd(calculateFirstAddress(gameCount, user), commission);

        commission = safeAdd(calculateLastAddress(gameCount, user), commission);

        commission = safeAdd(calculateAmountMax(gameCount, user), commission);

        commission = safeAdd(calculateKeyCommission(gameCount, user), commission);

        commission = safeAdd(sponsorCommission[gameCount][user], commission);

        commission = safeAdd(shareNode[gameCount][user], commission);

        commission = safeAdd(superNode[gameCount][user], commission);

        commission = safeAdd(auctioneer[gameCount][user], commission);

        commission = safeAdd(leaderShip[gameCount][user], commission);

        commission = safePercent(commission, 100 - setting.withdrawFeeRate());

        return commission;

    }



    function commissionGameCount(address user) public view returns (uint256[]){

        uint256[]  memory commission = new uint256[](currentGameCount + 1);

        for (uint32 i = 1; i <= currentGameCount; i++) {

            commission[i] = calculateCommission(i, user);

        }

        return commission;

    }



    function withdrawCommission(uint32 gameCount) public {

        uint256 commission = calculateCommission(gameCount, msg.sender);

        require(commission > 0);

        userWithdrawFlag[gameCount][msg.sender] = true;

        msg.sender.transfer(commission);

        emit WithdrawCommission(msg.sender, gameCount, commission);

    }



    function recycle(uint256 value) public {

        require(msg.sender == finance);

        finance.transfer(value);

    }



    function calculateGame(address[] shareUsers,

        address[] superUsers,

        address[] auctioneerUsers,

        address[] leaderUsers,

        uint32 gameCount) public {

        require(msg.sender == admin);

        require(game[gameCount].status == 1);



        uint256 totalKey = 0;

        uint256 i = 0;

        for (i = 0; i < shareUsers.length; i++) {

            shareNode[gameCount][shareUsers[i]] = safeDiv(safePercent(game[gameCount].investmentAmount, setting.shareRate()), shareUsers.length);

            if (commissionAddress[gameCount][shareUsers[i]] == false) {

                commissionAddress[gameCount][shareUsers[i]] = true;

                totalKey = safeAdd(totalKey, safeDiv(userInvestment[gameCount][shareUsers[i]], mantissaOneTenth));

            }

        }

        for (i = 0; i < superUsers.length; i++) {

            superNode[gameCount][superUsers[i]] = safeDiv(safePercent(game[gameCount].investmentAmount, setting.superRate()), superUsers.length);

            if (commissionAddress[gameCount][superUsers[i]] == false) {

                commissionAddress[gameCount][superUsers[i]] = true;

                totalKey = safeAdd(totalKey, safeDiv(userInvestment[gameCount][superUsers[i]], mantissaOneTenth));

            }

        }

        for (i = 0; i < auctioneerUsers.length; i++) {

            auctioneer[gameCount][auctioneerUsers[i]] = safeDiv(safePercent(game[gameCount].investmentAmount, setting.auctioneerRate()), auctioneerUsers.length);

            if (commissionAddress[gameCount][auctioneerUsers[i]] == false) {

                commissionAddress[gameCount][auctioneerUsers[i]] = true;

                totalKey = safeAdd(totalKey, safeDiv(userInvestment[gameCount][auctioneerUsers[i]], mantissaOneTenth));

            }

        }

        for (i = 0; i < leaderUsers.length; i++) {

            leaderShip[gameCount][leaderUsers[i]] = safeDiv(safePercent(game[gameCount].investmentAmount, setting.leaderRate()), leaderUsers.length);

            if (commissionAddress[gameCount][leaderUsers[i]] == false) {

                commissionAddress[gameCount][leaderUsers[i]] = true;

                totalKey = safeAdd(totalKey, safeDiv(userInvestment[gameCount][leaderUsers[i]], mantissaOneTenth));

            }

        }

        for (i = 0; i < firstAddress[gameCount].length; i++) {

            if (commissionAddress[gameCount][firstAddress[gameCount][i]] == false) {

                commissionAddress[gameCount][firstAddress[gameCount][i]] = true;

                totalKey = safeAdd(totalKey, safeDiv(userInvestment[gameCount][firstAddress[gameCount][i]], mantissaOneTenth));

            }

        }

        for (i = 0; i < lastAddress[gameCount].length; i++) {

            if (commissionAddress[gameCount][lastAddress[gameCount][i]] == false) {

                commissionAddress[gameCount][lastAddress[gameCount][i]] = true;

                totalKey = safeAdd(totalKey, safeDiv(userInvestment[gameCount][lastAddress[gameCount][i]], mantissaOneTenth));

            }

        }

        if (commissionAddress[gameCount][gameMax[gameCount].user] == false) {

            commissionAddress[gameCount][gameMax[gameCount].user] = true;

            totalKey = safeAdd(totalKey, safeDiv(userInvestment[gameCount][gameMax[gameCount].user], mantissaOneTenth));

        }



        game[gameCount].totalKey = safeSub(game[gameCount].totalKey, totalKey);

        game[gameCount].status = 2;

        uint256 remainAmount = 0;

        if (game[gameCount].totalKey == 0) {

            remainAmount = safeAdd(safePercent(game[gameCount].investmentAmount, setting.keyRate()), remainAmount);

        }

        if (shareUsers.length == 0) {

            remainAmount = safeAdd(safePercent(game[gameCount].investmentAmount, setting.shareRate()), remainAmount);

        }

        if (superUsers.length == 0) {

            remainAmount = safeAdd(safePercent(game[gameCount].investmentAmount, setting.superRate()), remainAmount);

        }

        if (auctioneerUsers.length == 0) {

            remainAmount = safeAdd(safePercent(game[gameCount].investmentAmount, setting.auctioneerRate()), remainAmount);

        }

        if (leaderUsers.length == 0) {

            remainAmount = safeAdd(safePercent(game[gameCount].investmentAmount, setting.leaderRate()), remainAmount);

        }

        uint256 amount = 0;

        if (lastRemainAmount != game[gameCount].investmentAmount) {

            amount = safePercent(safeSub(game[gameCount].investmentAmount, remainAmount), setting.withdrawFeeRate());

            amount = safeAdd(calculateCommission(gameCount, address(this)), amount);

            lastRemainAmount = remainAmount;

        } else {

            lastRemainAmount += game[gameCount].initAmount;

        }

        emit CalculateGame(gameCount, amount);

        finance.transfer(amount);

    }



}

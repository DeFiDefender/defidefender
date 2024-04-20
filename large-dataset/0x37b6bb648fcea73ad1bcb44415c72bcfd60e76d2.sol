pragma solidity >=0.4.23 <0.6.0;



contract ethp2p {

    

    struct User {

        uint id;

        address sponsor;

        uint partnersCount;

        

        mapping(uint8 => bool) activeE1Levels; 

        

        mapping(uint8 => E1) e1Matrix;

        

        mapping(uint8 => E2) e2;

    }

    

    struct E1 {

        address currentSponsor;

        address[] referrals;

        bool blocked;

        uint reinvestCount;

    }

    

    struct E2 {

        address currentSponsor;

        address leftLeg;

        address rightLeg;

        uint8 level;

        uint leftPoints;

        uint rightPoints;

        uint reinvestCount;

    }

    

    uint8 public constant LAST_LEVEL = 10;

    

    mapping(address => User) public users;

    mapping(uint => address) public idToAddress;

    mapping(uint => address) public userIds;

    mapping(address => uint) public balances;

    

    uint public lastUserId = 2;

    address public owner;

    address public pool = 0xc6c368Eb6B4547755ECAd06a0Ba9cBB022F97018;

    address public feePool = 0x8C55b5D1E5EC2881582e4B5b8E5b4e9Dcd75F9C4;

    

    mapping(uint8 => uint) public levelPrice;

    mapping(uint8 => uint) public levelFee;

    

    event Registration(address indexed user, address indexed sponsor, uint indexed userId, uint sponsorId);

    event Reinvest(address indexed user, address indexed currentReferrer, address indexed caller, uint8 matrix, uint8 level);

    event Upgrade(address indexed user, address indexed sponsor, uint8 matrix, uint8 level);

    event NewUserPlace(address indexed user, address indexed sponsor, uint8 matrix, uint8 level, uint8 place);

    event MissedEthReceive(address indexed receiver, address indexed from, uint8 matrix, uint8 level);

    event SentExtraEthDividends(address indexed from, address indexed receiver, uint8 matrix, uint8 level);

    event Match(address indexed user);

    event MatchBonusToPay(address indexed user, uint value);

    

    constructor(address ownerAddress) public {

        levelPrice[1] = 0.0275 ether;

        for (uint8 i = 2; i <= LAST_LEVEL; i++) {

            levelPrice[i] = levelPrice[i-1] * 2;

        }

        

        levelFee[1] = 0.0025 ether;

        for (uint8 i = 2; i <= LAST_LEVEL; i++) {

            levelFee[i] = levelFee[i-1] * 2;

        }

        

        owner = ownerAddress;

        

        User memory user = User({

            id: 1,

            sponsor: address(0),

            partnersCount: uint(0)

        });

        

        users[ownerAddress] = user;

        idToAddress[1] = ownerAddress;

        

        users[ownerAddress].e2[1].level = 10;

        

        for (uint8 i = 1; i <= LAST_LEVEL; i++) {

            users[ownerAddress].activeE1Levels[i] = true;

        }

        

        userIds[1] = ownerAddress; 

    }

    

    function registrationExt(address sponsorAddress, uint8 leg) external payable {

        registration(msg.sender, sponsorAddress, leg);

    }

    

    function registration(address userAddress, address sponsorAddress, uint8 leg) private {

        require(msg.value == 0.055 ether, "registration cost 0.055");

        require(!isUserExists(userAddress), "user exists");

        require(isUserExists(sponsorAddress), "sponsor not exists");

        require(leg == 0 || leg == 1, "invalid leg");

        

        uint32 size;

        assembly {

            size := extcodesize(userAddress)

        }

        require(size == 0, "cannot be a contract");

        

        User memory user = User({

            id: lastUserId,

            sponsor: sponsorAddress,

            partnersCount: 0

        });

        

        users[userAddress] = user;

        idToAddress[lastUserId] = userAddress;

        

        users[userAddress].sponsor = sponsorAddress;

        

        users[userAddress].activeE1Levels[1] = true;

        

        userIds[lastUserId] = userAddress;

        lastUserId++;

        

        users[sponsorAddress].partnersCount++;

        

        address freeE2Sponsor = findFreeE2Sponsor(sponsorAddress, leg);

        users[userAddress].e2[1].level = 1;

        users[userAddress].e2[1].currentSponsor = freeE2Sponsor;

        updateE2Sponsor(userAddress, freeE2Sponsor, leg);



        address freeE1Sponsor = findFreeE1Sponsor(userAddress, 1);

        users[userAddress].e1Matrix[1].currentSponsor = freeE1Sponsor;

        updateE1Sponsor(userAddress, freeE1Sponsor, 1);

        

        sendETHFeesToPool(feePool, 2);



        emit Registration(userAddress, sponsorAddress, users[userAddress].id, users[sponsorAddress].id);

    }

    

    function buyNewLevel(uint8 matrix, uint8 level) external payable {

        require(isUserExists(msg.sender), "user is not exists. Register first.");

        require(matrix == 1 || matrix == 2, "invalid matrix");

        require(msg.value == levelPrice[level], "invalid price");

        require(level > 1 && level <= LAST_LEVEL, "invalid level");

        

        sendETHFeesToPool(feePool, level);



        if (matrix == 1) {

            require(!users[msg.sender].activeE1Levels[level], "level already activated");



            if (users[msg.sender].e1Matrix[level-1].blocked) {

                users[msg.sender].e1Matrix[level-1].blocked = false;

            }

    

            address freeE1Sponsor = findFreeE1Sponsor(msg.sender, level);

            users[msg.sender].e1Matrix[level].currentSponsor = freeE1Sponsor;

            users[msg.sender].activeE1Levels[level] = true;

            updateE1Sponsor(msg.sender, freeE1Sponsor, level);

            

            emit Upgrade(msg.sender, freeE1Sponsor, 1, level);



        } else {

            require(users[msg.sender].e2[1].level < level, "level already activated"); 



            uint currentPoints = getPoints(users[msg.sender].e2[1].level);

            users[msg.sender].e2[1].level = level;

            uint newLevelPoints = getPoints(level);

            uint addPoints = newLevelPoints - currentPoints;



            updatePoints(msg.sender, addPoints, 1);

            sendETHDividendsToPool(pool, 1);

            

            checkMatchBonus(users[msg.sender].e2[1].currentSponsor);

            

            emit Upgrade(msg.sender, users[msg.sender].e2[1].currentSponsor, 2, level);

        }

    } 

    

    function updateE1Sponsor(address userAddress, address sponsorAddress, uint8 level) private {

        users[sponsorAddress].e1Matrix[level].referrals.push(userAddress);



        if (users[sponsorAddress].e1Matrix[level].referrals.length < 3) {

            emit NewUserPlace(userAddress, sponsorAddress, 1, level, uint8(users[sponsorAddress].e1Matrix[level].referrals.length));

            return sendETHDividends(sponsorAddress, userAddress, 1, level);

        }

        

        emit NewUserPlace(userAddress, sponsorAddress, 1, level, 3);

    

        users[sponsorAddress].e1Matrix[level].referrals = new address[](0);

        if (!users[sponsorAddress].activeE1Levels[level+1] && level != LAST_LEVEL) {

            users[sponsorAddress].e1Matrix[level].blocked = true;

        }



        if (sponsorAddress != owner) {

            address freeSponsorAddress = findFreeE1Sponsor(sponsorAddress, level);

            if (users[sponsorAddress].e1Matrix[level].currentSponsor != freeSponsorAddress) {

                users[sponsorAddress].e1Matrix[level].currentSponsor = freeSponsorAddress;

            }

            

            users[sponsorAddress].e1Matrix[level].reinvestCount++;

            emit Reinvest(sponsorAddress, freeSponsorAddress, userAddress, 1, level);

            updateE1Sponsor(sponsorAddress, freeSponsorAddress, level);

        } else {

            sendETHDividends(owner, userAddress, 1, level);

            users[owner].e1Matrix[level].reinvestCount++;

            emit Reinvest(owner, address(0), userAddress, 1, level);

        }

    }

    

    function updateE2Sponsor(address userAddress, address sponsorAddress, uint8 leg) private {

        if (leg == 0){

            users[sponsorAddress].e2[1].leftLeg = userAddress;

            users[sponsorAddress].e2[1].leftPoints += 25; 

            

            if (users[sponsorAddress].e2[1].leftPoints <= users[sponsorAddress].e2[1].rightPoints){

                

            }

        }

        else {

            users[sponsorAddress].e2[1].rightLeg = userAddress;

            users[sponsorAddress].e2[1].rightPoints += 25; 

        }

        updatePoints(sponsorAddress, 25, 1);

        emit NewUserPlace(userAddress, sponsorAddress, 2, 1, leg);

        sendETHDividendsToPool(pool, 1);

        

        checkMatchBonus(sponsorAddress);

    }

    

    function findFreeE1Sponsor(address userAddress, uint8 level) public view returns(address) {

        while (true) {

            if (users[users[userAddress].sponsor].activeE1Levels[level]) {

                return users[userAddress].sponsor;

            }

            

            userAddress = users[userAddress].sponsor;

        }

    }

    

    function findFreeE2Sponsor(address sponsorAddress, uint8 leg) public view returns(address) {

        while (true) {

            if (leg == 0){

                if (users[sponsorAddress].e2[1].leftLeg == 0x0000000000000000000000000000000000000000){

                    return sponsorAddress;

                }

                sponsorAddress = users[sponsorAddress].e2[1].leftLeg;

            }

            else {

                if (users[sponsorAddress].e2[1].rightLeg == 0x0000000000000000000000000000000000000000){

                    return sponsorAddress;

                }

                sponsorAddress = users[sponsorAddress].e2[1].rightLeg;

            }

        }

    }

    

    function usersActiveE1Levels(address userAddress, uint8 level) public view returns(bool) {

        return users[userAddress].activeE1Levels[level];

    }

    

    function usersE1Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, bool) {

        return (users[userAddress].e1Matrix[level].currentSponsor,

                users[userAddress].e1Matrix[level].referrals,

                users[userAddress].e1Matrix[level].blocked);

    }

    

    function usersE2(address userAddress) public view returns(address, uint, uint, uint8, address, address) {

        return (users[userAddress].e2[1].currentSponsor,

                users[userAddress].e2[1].leftPoints,

                users[userAddress].e2[1].rightPoints,

                users[userAddress].e2[1].level,

                users[userAddress].e2[1].leftLeg,

                users[userAddress].e2[1].rightLeg);

    }

    

    function isUserExists(address user) public view returns (bool) {

        return (users[user].id != 0);

    }

    

    function findEthReceiver(address userAddress, address _from, uint8 matrix, uint8 level) private returns(address, bool) {

        address receiver = userAddress;

        bool isExtraDividends;

        if (matrix == 1) {

            while (true) {

                if (users[receiver].e1Matrix[level].blocked) {

                    emit MissedEthReceive(receiver, _from, 1, level);

                    isExtraDividends = true;

                    receiver = users[receiver].e1Matrix[level].currentSponsor;

                } else {

                    return (receiver, isExtraDividends);

                }

            }

        } 

    }

    

    function sendETHDividends(address userAddress, address _from, uint8 matrix, uint8 level) private {

        (address receiver, bool isExtraDividends) = findEthReceiver(userAddress, _from, matrix, level);



        if (!address(uint160(receiver)).send(levelPrice[level] - levelFee[level])) {

            return address(uint160(receiver)).transfer(address(this).balance);

        }

        

        if (isExtraDividends) {

            emit SentExtraEthDividends(_from, receiver, matrix, level);

        }

    }

    

    function sendETHDividendsToPool(address userAddress, uint8 level) private {

        address receiver = userAddress;



        if (!address(uint160(receiver)).send(levelPrice[level] - levelFee[level])) {

            return address(uint160(receiver)).transfer(address(this).balance);

        }

    }

    

    function sendETHFeesToPool(address userAddress, uint8 level) private {

        address receiver = userAddress;



        if (!address(uint160(receiver)).send(levelFee[level])) {

            return address(uint160(receiver)).transfer(address(this).balance);

        }

    }

    

    function bytesToAddress(bytes memory bys) private pure returns (address addr) {

        assembly {

            addr := mload(add(bys, 20))

        }

    }

    

    function checkMatchBonus(address userAddress) private {

        uint leftPoints = users[userAddress].e2[1].leftPoints;

        uint rightPoints = users[userAddress].e2[1].rightPoints;

        

        uint points = leftPoints;

        if (rightPoints < leftPoints){

            points = rightPoints;

        }

        

        if (points > 0){

            users[userAddress].e2[1].leftPoints -= points;

            users[userAddress].e2[1].rightPoints -= points;

            emit Match(userAddress);

            uint bonusValue = getMatchBonusValue(users[userAddress].e2[1].level, points);

            emit MatchBonusToPay(userAddress, bonusValue);

            

            for (int i = 0; i < 6; i++){

                checkUplineBonus(userAddress, leftPoints + rightPoints);

                userAddress = users[userAddress].e2[1].currentSponsor;

            }

        }

        else {

            if (users[userAddress].e2[1].currentSponsor != 0x0000000000000000000000000000000000000000){

                checkMatchBonus(users[userAddress].e2[1].currentSponsor);

            }

        }

        

    }

    

    function getMatchBonusValue(uint8 level, uint baseValue) private pure returns (uint) {

        uint percentValue;

        uint bonusValue;

        

        if (level == 1 || level == 2){

            percentValue = 7;

        }

        else if (level == 3){

            percentValue = 8;

        }

        else if (level == 4){

            percentValue = 9;

        }

        else if (level == 5 || level == 6){

            percentValue = 10;

        }

        else if (level == 7 || level == 8){

            percentValue = 11;

        }

        else if (level == 9 || level == 10){

            percentValue = 12;

        }

        

        bonusValue = (baseValue * 100) * percentValue / 100;

        

        return bonusValue;

    }

    

    function checkUplineBonus(address userAddress, uint points) private {

        uint uplinePoints;

        

        if (userAddress == users[users[userAddress].e2[1].currentSponsor].e2[1].leftLeg){

            uplinePoints = users[users[userAddress].e2[1].currentSponsor].e2[1].rightPoints;

        }

        else if (userAddress == users[users[userAddress].e2[1].currentSponsor].e2[1].rightLeg){

            uplinePoints = users[users[userAddress].e2[1].currentSponsor].e2[1].leftPoints;

        }

        

        if (uplinePoints >= points){

            uint bonusValue = getMatchBonusValue(users[users[userAddress].e2[1].currentSponsor].e2[1].level, points);

            users[users[userAddress].e2[1].currentSponsor].e2[1].leftPoints -= points;

            users[users[userAddress].e2[1].currentSponsor].e2[1].rightPoints -= points;

            emit MatchBonusToPay(users[userAddress].e2[1].currentSponsor, bonusValue);

        }

    }

    

    function getPoints(uint8 level) private pure returns (uint) {

        uint points;

        

        if (level == 1){

            points = 25;

        }

        else if (level == 2){

            points = 50;

        }

        else if (level == 3){

            points = 100;

        }

        else if (level == 4){

            points = 200;

        }

        else if (level == 5){

            points = 400;

        }

        else if (level == 6){

            points = 800;

        }

        else if (level == 7){

            points = 1600;

        }

        else if (level == 8){

            points = 3200;

        }

        else if (level == 9){

            points = 6400;

        }

        else if (level == 10){

            points = 12800;

        }

        

        return points;

    }

    

    function updatePoints(address userAddress, uint points, uint8 operation) private {

        while(users[userAddress].e2[1].currentSponsor != 0x0000000000000000000000000000000000000000){

            if (userAddress == users[users[userAddress].e2[1].currentSponsor].e2[1].leftLeg){

                if (operation == 1){

                    users[users[userAddress].e2[1].currentSponsor].e2[1].leftPoints += points;

                }

                else {

                    users[users[userAddress].e2[1].currentSponsor].e2[1].leftPoints -= points;

                }

            }

            else if (userAddress == users[users[userAddress].e2[1].currentSponsor].e2[1].rightLeg){

                if (operation == 1){

                    users[users[userAddress].e2[1].currentSponsor].e2[1].rightPoints += points;

                }

                else {

                    users[users[userAddress].e2[1].currentSponsor].e2[1].rightPoints -= points;

                }

            }

            userAddress = users[userAddress].e2[1].currentSponsor;

        }

    }

}

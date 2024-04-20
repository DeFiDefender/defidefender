pragma solidity ^0.5.0;



contract PerfectLife {

  /* https://perfectlife.cc */



  uint ethWei = 1 ether;

  address payable private scAddr = address(0x05aA71Aeb257aC248E7B4fE19a36c8EC64E77bD8);

  address payable private qcAddr = address(0xf4243a31536243D76F7400e3A94105075E3184fE);

  address payable private payAddr = address(0xD74b0891493a27AbcAF7AB5D1277aa1D5c807017);

  address payable private interestAddr = address(0x2c166a85672504F79efB2dedB443AD3474081208);

    address payable private mainAddr = address(0xFecC74EA9E8e6354c5b0DEEeF3caf2BdcFbfd8bC);

  

  struct User {

    uint id;

    address userAddress;

    uint freeAmount;

    uint freezeAmount;

    uint lineAmount;

    uint inviteAmonut;

    uint dayBonusAmount;

    uint bonusAmount;

    uint level;

    uint lineLevel;

    uint resTime;

    uint investTimes;

    string inviteCode;

    string beCode;

    uint rewardIndex;

    uint lastRwTime;

  }



  struct UserGlobal {

    uint id;

    address userAddress;

    string inviteCode;

    string beCode;

    uint status;

  }



  struct AwardData {

    uint oneInvAmount;

    uint twoInvAmount;

    uint threeInvAmount;

  }



  uint startTime;

  uint lineStatus = 0;

  mapping(uint => uint) rInvestCount;

  mapping(uint => uint) rInvestMoney;

  uint period = 1 days;

  uint uid = 0;

  uint rid = 1;

  mapping(uint => uint[]) lineArrayMapping;

  mapping(uint => mapping(address => User)) userRoundMapping;

  mapping(address => UserGlobal) userMapping;

  mapping(string => address) addressMapping;

  mapping(uint => address) indexMapping;

  mapping(uint => mapping(address => mapping(uint => AwardData))) userAwardDataMapping;

  uint bonuslimit = 15 ether;

  uint sendLimit = 100 ether;

  uint withdrawLimit = 15 ether;

  uint canImport = 1;

  uint canSetStartTime = 1;



  modifier isHuman() {

    address addr = msg.sender;

    uint codeLength;

    assembly {codeLength := extcodesize(addr)}

    require(codeLength == 0, "sorry humans only");

    require(tx.origin == msg.sender, "sorry, humans only");

    _;

  }



  constructor () public {

  }



  function() external payable {

  }





  function verydangerous(uint time) external  {

    require(canSetStartTime == 1, "verydangerous, limited!");

    require(time > now, "no, verydangerous");

    startTime = time;

    canSetStartTime = 0;

  }



  function donnotimitate() public view returns (bool) {

    return startTime != 0 && now > startTime;

  }





  function isLine() private view returns (bool) {

    return lineStatus != 0;

  }



  function actAllLimit(uint bonusLi, uint sendLi, uint withdrawLi) external {

    require(bonusLi >= 15 ether && sendLi >= 100 ether && withdrawLi >= 15 ether, "invalid amount");

    bonuslimit = bonusLi;

    sendLimit = sendLi;

    withdrawLimit = withdrawLi;

  }



  function stopImport() external  {

    canImport = 0;

  }



  function exit(string memory inviteCode, string memory beCode) public isHuman() payable {

    require(donnotimitate(), "no, donnotimitate");

    require(msg.value >= 1 * ethWei && msg.value <= 15 * ethWei, "between 1 and 15");

    

    UserGlobal storage userGlobal = userMapping[msg.sender];

    if (userGlobal.id == 0) {

      address beCodeAddr = addressMapping[beCode];

      require(isUsed(beCode), "beCode not exist");

      require(beCodeAddr != msg.sender, "beCodeAddr can't be self");

      require(!isUsed(inviteCode), "invite code is used");

      registerUser(msg.sender, inviteCode, beCode);

    }

    uint investAmout;

    uint lineAmount;

    if (isLine()) {

      lineAmount = msg.value;

    } else {

      investAmout = msg.value;

    }

    User storage user = userRoundMapping[rid][msg.sender];

    if (user.id != 0) {

      user.freezeAmount = investAmout;

      user.lineAmount = lineAmount;

    } else {

      user.id = userGlobal.id;

      user.userAddress = msg.sender;

      user.freezeAmount = investAmout;

      user.lineAmount = lineAmount;

        user.inviteCode = userGlobal.inviteCode;

      user.beCode = userGlobal.beCode;

    }

  }



  function happy() public isHuman() {

    require(donnotimitate(), "no donnotimitate");

    User storage user = userRoundMapping[rid][msg.sender];

    require(user.id != 0, "user not exist");

    uint sendMoney = user.freeAmount + user.lineAmount;

    bool isEnough = false;

    uint resultMoney = 0;



    (isEnough, resultMoney) = isEnoughBalance(sendMoney);



    if (resultMoney > 0 && resultMoney <= withdrawLimit) {

      sendMoneyToUser(msg.sender, resultMoney);

      user.freeAmount = 0;

      user.lineAmount = 0;

    }

  }



  function isEnoughBalance(uint sendMoney) private view returns (bool, uint){

    if (sendMoney >= address(this).balance) {

      return (false, address(this).balance);

    } else {

      return (true, sendMoney);

    }

  }



  function sendMoneyToUser(address payable userAddress, uint money) private {

    if (money > 0) {

      userAddress.transfer(money);

    }

  }



  function isUsed(string memory code) public view returns (bool) {

    address addr = addressMapping[code];

    return uint(addr) != 0;

  }



  function getUserAddressByCode(string memory code) public view returns (address) {

  

    return addressMapping[code];

  }



  function registerUser(address addr, string memory inviteCode, string memory beCode) private {

    UserGlobal storage userGlobal = userMapping[addr];

    uid++;

    userGlobal.id = uid;

    userGlobal.userAddress = addr;

    userGlobal.inviteCode = inviteCode;

    userGlobal.beCode = beCode;



    addressMapping[inviteCode] = addr;

    indexMapping[uid] = addr;

  }







  function donnottouch() public view returns (uint, uint, uint, uint, uint, uint, uint, uint, uint, uint, uint, uint) {

    return (

    rid,

    uid,

    startTime,

    rInvestCount[rid],

    rInvestMoney[rid],

    bonuslimit,

    sendLimit,

    withdrawLimit,

    canImport,

    lineStatus,

    lineArrayMapping[rid].length,

    canSetStartTime

    );

  }



  function getUserByAddress(address addr, uint roundId) public view returns (uint[14] memory info, string memory inviteCode, string memory beCode) {

    

    if (roundId == 0) {

      roundId = rid;

    }



    UserGlobal memory userGlobal = userMapping[addr];

    User memory user = userRoundMapping[roundId][addr];

    info[0] = userGlobal.id;

    info[1] = user.lineAmount;

    info[2] = user.freeAmount;

    info[3] = user.freezeAmount;

    info[4] = user.inviteAmonut;

    info[5] = user.bonusAmount;

    info[6] = user.lineLevel;

    info[7] = user.dayBonusAmount;

    info[8] = user.rewardIndex;

    info[9] = user.investTimes;

    info[10] = user.level;

    uint grantAmount = 0;

    if (user.id > 0 && user.freezeAmount >= 1 ether && user.freezeAmount <= bonuslimit && user.investTimes < 5 && userGlobal.status != 1) {

      grantAmount += user.dayBonusAmount;

    }

  

    info[11] = grantAmount;

    info[12] = user.lastRwTime;

    info[13] = userGlobal.status;



    return (info, userGlobal.inviteCode, userGlobal.beCode);

  }



  function getUserAddressById(uint id) public view returns (address) {

    return indexMapping[id];

  }



  function getLineUserId(uint index, uint rouId) public view returns (uint) {

    if (rouId == 0) {

      rouId = rid;

    }

    return lineArrayMapping[rid][index];

  }

}

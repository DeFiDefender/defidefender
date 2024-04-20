pragma solidity ^0.5.0;



/*

 * @title: SafeMath

 * @dev: Helper contract functions to arithmatic operations safely.

 */

contract SafeMath {

    function Sub(uint256 a, uint256 b) internal pure returns (uint256) {

        require(b <= a, "SafeMath: subtraction overflow");

        uint256 c = a - b;



        return c;

    }



    function Add(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a + b;

        require(c >= a, "SafeMath: addition overflow");



        return c;

    }



    function Mul(uint256 a, uint256 b) internal pure returns (uint256) {

        if (a == 0) {

            return 0;

        }



        uint256 c = a * b;

        require(c / a == b, "SafeMath: multiplication overflow");



        return c;

    }

}



/*

 * @title: Token

 * @dev: Interface contract for ERC20 tokens

 */

contract Token {

    function totalSupply() public view returns (uint256 supply);



    function balanceOf(address _owner) public view returns (uint256 balance);



    function transfer(address _to, uint256 _value)

        public

        returns (bool success);



    function transferFrom(

        address _from,

        address _to,

        uint256 _value

    ) public returns (bool success);



    function approve(address _spender, uint256 _value)

        public

        returns (bool success);



    function allowance(address _owner, address _spender)

        public

        view

        returns (uint256 remaining);



    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(

        address indexed _owner,

        address indexed _spender,

        uint256 _value

    );

}



/*

 * @title: Staking

 */

contract LockAndEarn is SafeMath {

    // KAI_ADDRESS: KAI ERC20 contract address

    // msg.sender: owner && operator

    constructor(uint256 _interest, uint256 _lockDays, uint256 _lockStartTime, address[] memory _initAddress) public {

        owner = msg.sender;

        interest = _interest;

        lockDays = _lockDays;

        lockStartTime = _lockStartTime;

        isEnded = false;

        for (uint i=0; i < _initAddress.length; i++) {

            isAddrWhitelisted[_initAddress[i]] = true;

        }

    }



    address constant public KAI_ADDRESS = 0xD9Ec3ff1f8be459Bb9369b4E79e9Ebcf7141C093;

    uint256 constant public HARD_CAP = 50000000000000000000000000; // 50000000 KAI



    address public owner;

    uint256 public interest;

    uint256 public bonus;

    uint256 public lockDays;

    uint256 public currentCap;

    uint256 public lockStartTime;

    bool public isEnded;



    mapping(address => uint256) public addrBalance;

    mapping (address => bool) public isAddrWhitelisted;



    // Functions with this modifier can only be executed by the owner

    modifier onlyOwner() {

        require(msg.sender == owner);

        _;

    }



    // deposit bonus to pay interest

    function depositBonus(uint256 amount) public onlyOwner {

        require(Token(KAI_ADDRESS).transferFrom(msg.sender, address(this), amount));

        

        bonus = Add(amount, bonus);

    }



    // withdraw bonus to owner account

    function withdrawBonus(uint256 amount) public onlyOwner {

        require(Token(KAI_ADDRESS).transfer(msg.sender, amount));

        

        bonus = Sub(bonus, amount);

    }



    // Deposit ERC20's for saving

    function depositToken(uint256 amount) public {

        require(isEnded != true, "Deposit ended");

        require(lockStartTime < now, 'Event has not been started yet');

        require(isAddrWhitelisted[msg.sender] == true, "Address is not whitelisted.");

        require(Add(currentCap, amount) <= HARD_CAP, 'Exceed limit total cap');

        require(Token(KAI_ADDRESS).transferFrom(msg.sender, address(this), amount));

        

        currentCap = Add(currentCap, amount);

        addrBalance[msg.sender] = Add(addrBalance[msg.sender], amount);

    }



    // Withdraw ERC20's to personal address

    function withdrawToken() public {

        require(lockStartTime + lockDays * 1 days < now, "Locking period");

        uint256 amount = addrBalance[msg.sender];

        require(amount > 0, "withdraw only once");

        

        uint256 _interest = Mul(amount, interest) / 10000;



        bonus = Sub(bonus, _interest);

        amount = Add(amount, _interest);

        require(Token(KAI_ADDRESS).transfer(msg.sender, amount));

        addrBalance[msg.sender] = 0;

    }

    

    // owner sets global variables the campaign ends

    function setEndedDeposit() public onlyOwner {

        isEnded = true;

    }



    // Below two emergency functions will be never used in normal situations.

    // These function is only prepared for emergency case such as smart contract hacking Vulnerability or smart contract abolishment

    // Withdrawn fund by these function cannot belong to any operators or owners.

    // Withdrawn fund should be distributed to individual accounts having original ownership of withdrawn fund.



    function emergencyWithdrawalETH(uint256 amount) public onlyOwner {

        require(msg.sender.send(amount));

    }

    

    function emergencyWithdrawalToken(uint256 amount) public onlyOwner {

        Token(KAI_ADDRESS).transfer(msg.sender, amount);

    }

    

    function whitelistAddress(address addAddress) public onlyOwner {

        isAddrWhitelisted[addAddress] = true;

    }

    

    function removeWhiteListAddress(address removeAddress) public onlyOwner {

        isAddrWhitelisted[removeAddress] = false;

    }

    

    function getMyBalance() public view returns (uint256) {

        return addrBalance[msg.sender];

    }

    

    function getTimestamp() public view returns (uint256) {

        return now;

    }

    

    // @notice Will receive any eth sent to the contract

    function () external payable {}

}

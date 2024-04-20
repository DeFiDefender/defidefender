pragma solidity ^0.5;



interface IERC20 {

  function totalSupply() external view returns (uint256);



  function balanceOf(address who) external view returns (uint256);



  function allowance(address owner, address spender)

    external view returns (uint256);



  function transfer(address to, uint256 value) external returns (bool);



  function approve(address spender, uint256 value)

    external returns (bool);



  function transferFrom(address from, address to, uint256 value)

    external returns (bool);



  event Transfer(

    address indexed from,

    address indexed to,

    uint256 value

  );



  event Approval(

    address indexed owner,

    address indexed spender,

    uint256 value

  );

}



library SafeMath {



    function add(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a + b;

        require(c >= a, "SafeMath: addition overflow");



        return c;

    }



    function sub(uint256 a, uint256 b) internal pure returns (uint256) {

        return sub(a, b, "SafeMath: subtraction overflow");

    }



    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b <= a, errorMessage);

        uint256 c = a - b;



        return c;

    }



    function mul(uint256 a, uint256 b) internal pure returns (uint256) {

        if (a == 0) {

            return 0;

        }



        uint256 c = a * b;

        require(c / a == b, "SafeMath: multiplication overflow");



        return c;

    }



    function div(uint256 a, uint256 b) internal pure returns (uint256) {

        return div(a, b, "SafeMath: division by zero");

    }



    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b > 0, errorMessage);

        uint256 c = a / b;



        return c;

    }



    function mod(uint256 a, uint256 b) internal pure returns (uint256) {

        return mod(a, b, "SafeMath: modulo by zero");

    }



    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b != 0, errorMessage);

        return a % b;

    }

}



contract SALE {

    event Received(address, uint);

    

    using SafeMath for uint256;

    

    address public owner;

    IERC20 public saleToken;

    uint256 public rate = 25000;

    uint256 public maxVestAmount = 10 ether;

    uint256 public ethGoal = 1600 ether;

    

    uint256 public ethCollected = 0;

    

    bool public allowUserWithdrawls = false; // and end the sale - modifes DAPP functionality

    bool public saleHasStarted = false;

    

    mapping(address => uint256) public userVestedMap;

    

    constructor() public {

      owner =  msg.sender;

    }

    

    

    modifier onlyOwner {

        require(msg.sender == owner, "You are not the owner");

        _;

    }

    

    // keep all tokens sent to this address

    function receive() payable public {

        emit Received(msg.sender, msg.value);

    }

    

    function setSaleHasStarted (bool allowed) onlyOwner public {

        saleHasStarted = allowed;

    }

    

    function setAllowUserWithdrawls (bool allowed) onlyOwner public {

        allowUserWithdrawls = allowed;

    }

    

    function setToken (address _token) onlyOwner public {

        saleToken = IERC20(_token);

    }

    

    function setRate (uint256 _rate) onlyOwner public {

        rate = _rate;

    }

    

    function setEthGoal (uint256 goal) onlyOwner public {

        ethGoal = goal;

    }

    

    function setMaxVestAmount (uint256 _amount) onlyOwner public {

        maxVestAmount = _amount;

    }

    

    function withdrawToken (address _token) onlyOwner public {

        IERC20 token = IERC20(_token);

        token.transfer(msg.sender, token.balanceOf(address(this)));

    }

    

    function withdrawETH () onlyOwner public {

        msg.sender.transfer(address(this).balance);

    }

    

    function doSale () public payable {

        require(saleHasStarted, 'The sale has not yet begun');

        require(ethCollected < ethGoal, 'The hardcap has been reached');

        ethCollected = ethCollected.add(msg.value);

        require(ethCollected <= ethGoal, 'Not enough sale tokens for this amount of ether, try a lower value');

        uint256 vested = userVestedMap[msg.sender];

        require(vested < maxVestAmount, 'You have used up your quota for this address');

        require(vested.add(msg.value) <= maxVestAmount, 'You are trying to purchase more than your remaining quota');

        // uint256 payout = getNumTokensForEther(msg.value);

        // require(saleToken.balanceOf(address(this)) >= payout, 'Not enough sale tokens for this amount of ether');

        userVestedMap[msg.sender] = vested.add(msg.value);

        // require(saleToken.transfer(msg.sender, payout), 'Transfer failed');

    }

    

    function participantWithdrawl () public {

        require(allowUserWithdrawls, 'Withdrawls are disabled until the sale has finished');

        uint256 payout = getParticipantsAllocation(msg.sender);

        require(payout > 0, 'You have no tokens left to withdraw');

        require(saleToken.balanceOf(address(this)) >= payout, 'Not enough sale tokens for this amount of ether');

        userVestedMap[msg.sender] = 0;

        require(saleToken.transfer(msg.sender, payout), 'Transfer failed');

    }

    

    function getParticipantsAllocation (address user) public view returns (uint256) {

        uint256 vested = userVestedMap[user];

        uint256 payout = getNumTokensForEther(vested);

        return payout;

    }

    

    function getNumTokensForEther(uint256 eth_amount) public view returns (uint256) {

        return eth_amount.mul(rate).div(1 ether);

    }

    

    function getUserVestedAmount(address _address) public view returns (uint256) {

        return userVestedMap[_address];

    }

    

    function getEthBalance() public view returns (uint256) {

        return address(this).balance;

    }

    

    function getTokenBalance() public view returns (uint256) {

        return saleToken.balanceOf(address(this));

    }

}

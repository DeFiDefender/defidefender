pragma solidity ^0.5.17;



// ------------------------------------------------------------------------

// Interface that the crowdsale uses (taken from token)

// ------------------------------------------------------------------------

contract IERC20 {

  function balanceOf(address who) view public returns (uint256);

  function transfer(address to, uint256 value) public returns (bool);

  event Transfer(address indexed from, address indexed to, uint256 value);

}



// ------------------------------------------------------------------------

// Math library

// ------------------------------------------------------------------------

library SafeMath {

    

  function mul(uint256 a, uint256 b) internal pure returns (uint256){

    uint256 c = a * b;

    assert(a == 0 || c / a == b);

    return c;

  }



  function div(uint256 a, uint256 b) internal pure returns (uint256) {

    assert(b > 0);

    uint256 c = a / b;

    assert(a == b * c + a % b);

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



contract Ownable {

  address payable internal _owner;

  address payable internal _potentialNewOwner;

 

  event OwnershipTransferred(address payable indexed from, address payable indexed to, uint date);



  constructor() internal {

    _owner = msg.sender;

  }

  modifier onlyOwner() {

    require(msg.sender == _owner);

    _;

  }

  function transferOwnership(address payable newOwner) external onlyOwner {

    _potentialNewOwner = newOwner;

  }

  function acceptOwnership() external {

    require(msg.sender == _potentialNewOwner);

    emit OwnershipTransferred(_owner, _potentialNewOwner, now);

    _owner = _potentialNewOwner;

  }

  function getOwner() view external returns(address){

      return _owner;

  }

  function getPotentialNewOwner() view external returns(address){

      return _potentialNewOwner;

  }

}



contract TimeAccessible {

  uint256 internal _releaseTime;

  

  event AccessGranted(address by, uint date);



  constructor(uint256 releaseTime) internal {

      require(releaseTime > now, "Release time needs to be greater than now");

      _releaseTime = releaseTime;

  }

  

  function getReleaseTime() public view returns(uint256){

      return _releaseTime;

  }

  

  modifier timeDependantAccess() {

      require(block.timestamp >= _releaseTime, "Current time is before release time");

      emit AccessGranted(msg.sender, now);

      _;

  }

}



// ------------------------------------------------------------------------

// Create recoverable tokens

// ------------------------------------------------------------------------

contract RecoverableToken {

  event RecoveredTokens(address token, address owner, uint256 tokens, uint time);

  

  function recoverAllTokens(IERC20 token, address recoverAddress) internal {

    uint256 tokens = tokensToBeReturned(token);

    require(token.transfer(recoverAddress, tokens) == true);

    emit RecoveredTokens(address(token), recoverAddress,  tokens, now);

  }

  

  function recoverTokens(IERC20 token, uint256 amount, address recoverAddress) internal {

    require(token.transfer(recoverAddress, amount) == true);

    emit RecoveredTokens(address(token), recoverAddress,  amount, now);

  }

  

  function tokensToBeReturned(IERC20 token) public view returns (uint256) {

    return token.balanceOf(address(this));

  }

}



// ------------------------------------------------------------------------

// Time-locked funds contract

// ------------------------------------------------------------------------

contract TimelockedFunds is Ownable, TimeAccessible, RecoverableToken {

    using SafeMath for uint256;



    event Withdraw(address indexed purchaser, address indexed beneficiary, uint256 amount, uint date);

    

    constructor (uint256 releaseTime) TimeAccessible(releaseTime) public {

    }

    

    function withdraw(IERC20 tokenToWithdrawAmountFrom, uint256 amount, address recoverAddress) public onlyOwner timeDependantAccess{

        require(block.timestamp >= _releaseTime, "Current time is before release time");

        recoverTokens(tokenToWithdrawAmountFrom, amount, recoverAddress);

    }

    

    function withdrawAll(IERC20 tokenToWithdrawAllFrom, address recoverAddress) public onlyOwner timeDependantAccess{

        require(block.timestamp >= _releaseTime, "Current time is before release time");

        recoverAllTokens(tokenToWithdrawAllFrom, recoverAddress);

    }

}

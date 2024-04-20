// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.6.0;



/**

 * @title SafeMath

 * @dev Math operations with safety checks that throw on error

 *

*/

library SafeMath {

  function mul(uint256 a, uint256 b) internal pure returns (uint256) {

    if (a == 0) {

      return 0;

    }

    uint256 c = a * b;

    assert(c / a == b);

    return c;

  }



  function div(uint256 a, uint256 b) internal pure returns (uint256) {

    // assert(b > 0); // Solidity automatically throws when dividing by 0

    uint256 c = a / b;

    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

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



// ----------------------------------------------------------------------------

// Owned contract

// ----------------------------------------------------------------------------

contract Owned {



  address payable public owner;



  event OwnershipTransferred(address indexed _from, address indexed _to);



  constructor() public {

    owner = msg.sender;

  }



  modifier onlyOwner {

    require(msg.sender == owner);

    _;

  }



  function transferOwnership(address payable _newOwner) public onlyOwner {

    owner = _newOwner;

    emit OwnershipTransferred(msg.sender, _newOwner);

  }

}





// ----------------------------------------------------------------------------

// ERC Token Standard #20 Interface

// ----------------------------------------------------------------------------

interface IERC20 {

  function transfer(address recipient, uint256 amount) external returns (bool);



  function balanceOf(address account) external view returns (uint256);

}





contract Presale is Owned {



  using SafeMath for uint256;



  bool public isPresaleOpen;



  //@dev ERC20 token address and decimals

  IERC20 public token;

  uint256 public constant TOKEN_DECIMALS = 9;



  //@dev amount of tokens per ether 100 indicates 1 token per eth

  uint256 public constant tokenRatePerEth = 200;



  //@dev max and min token buy limit per account

  uint256 public constant minEthLimit = 0.1 ether;

  uint256 public constant maxEthLimit = 2 ether;

  uint256 public constant maxEthLimitTotal = 100 ether;

  uint256 private constant RATE = 10 ** (18 - TOKEN_DECIMALS);



  mapping(address => uint256) public usersInvestments;

  uint256 public investmentsTotal;



  constructor(address _tokenAddress) public {

    owner = msg.sender;

    token = IERC20(_tokenAddress);

  }



  function startPresale() external onlyOwner {

    require(!isPresaleOpen, "Presale is open");

    isPresaleOpen = true;

  }



  function closePresale() external onlyOwner {

    require(isPresaleOpen, "Presale is not open yet.");

    isPresaleOpen = false;

  }



  function drainUnsoldTokens() external onlyOwner {

    require(!isPresaleOpen, "You cannot get tokens until the presale is closed.");

    uint256 balance = token.balanceOf(address(this));

    token.transfer(owner, balance);

  }



  function getTokensPerEth(uint256 amount) public pure returns (uint256) {

    return amount.mul(tokenRatePerEth).div(RATE);

  }



  receive() external payable {

    require(isPresaleOpen, "Presale is not open.");

    require(

      usersInvestments[msg.sender].add(msg.value) <= maxEthLimit

      && usersInvestments[msg.sender].add(msg.value) >= minEthLimit,

      "User limit!"

    );

    require(

      investmentsTotal.add(msg.value) <= maxEthLimitTotal,

      "Total limit!"

    );



    //@dev calculate the amount of tokens to transfer for the given eth

    uint256 tokenAmount = getTokensPerEth(msg.value);



    usersInvestments[msg.sender] = usersInvestments[msg.sender].add(msg.value);

    investmentsTotal = investmentsTotal.add(msg.value);



    require(token.transfer(msg.sender, tokenAmount), "Tokens transfer failed!");



    //@dev send received funds to the owner

    // solhint-disable-next-line avoid-low-level-calls, avoid-call-value

    (bool success, ) = owner.call{ value: msg.value }("");

    require(success, "Address: unable to send value, recipient may have reverted");

  }

}

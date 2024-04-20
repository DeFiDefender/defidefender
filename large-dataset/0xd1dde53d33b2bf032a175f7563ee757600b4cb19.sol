pragma solidity ^0.4.18;



library SafeMath {

  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {

    if (a == 0) { return 0; }

    c = a * b;

    assert(c / a == b);

    return c;

  }



  function div(uint256 a, uint256 b) internal pure returns (uint256) {

    return a / b;

  }



  function sub(uint256 a, uint256 b) internal pure returns (uint256) {

    assert(b <= a);

    return a - b;

  }



  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {

    c = a + b;

    assert(c >= a);

    return c;

  }

}



contract ERC20 {

  function totalSupply() public view returns (uint256);

  function balanceOf(address who) public view returns (uint256);

  function transfer(address to, uint256 value) public returns (bool);

  function allowance(address owner, address spender) public view returns (uint256);

  function transferFrom(address from, address to, uint256 value) public returns (bool);

  function approve(address spender, uint256 value) public returns (bool);

  event Approval(address indexed owner, address indexed spender, uint256 value);

  event Transfer(address indexed from, address indexed to, uint256 value);

}



contract Ownable {

  address public admin;

  mapping(address => bool) public owners;



  constructor() public {

    admin = msg.sender;

  }



  modifier onlyOwner() {

    require(owners[msg.sender] || admin == msg.sender);

    _;

  }



  function addOwner(address newOwner) onlyOwner public returns(bool success) {

    if (!owners[newOwner]) {

      owners[newOwner] = true;

      success = true; 

    }

  }

  

  function removeOwner(address oldOwner) onlyOwner public returns(bool success) {

    if (owners[oldOwner]) {

      owners[oldOwner] = false;

      success = true;

    }

  }

}



contract SaleCoreto is Ownable {

  using SafeMath for uint256;



  ERC20 public token = ERC20(0x9C2dc0c3CC2BADdE84B0025Cf4df1c5aF288D835);



  address public wallet = address(0x51Af8d3E7A4C81Bda3546f98eD0EdA585Dc01ddF);



  uint256 public rate = 0;



  uint256 public weiRaised;

  

  bool public isFinalized = false;

  

  event Finalized();



  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);



  function () external payable {

    buyTokens(msg.sender);

  }



  function buyTokens(address _beneficiary) public payable {

    uint256 weiAmount = msg.value;

    _preValidatePurchase(_beneficiary, weiAmount);



    uint256 tokens = _getTokenAmount(weiAmount);



    weiRaised = weiRaised.add(weiAmount);



    _processPurchase(_beneficiary, tokens);

    emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);



    _forwardFunds();

  }



  function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {

    require(_beneficiary != address(0));

    require(_weiAmount != 0);

  }



  function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {

    token.transfer(_beneficiary, _tokenAmount);

  }



  function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {

    return _weiAmount.mul(rate);

  }



  function _forwardFunds() internal {

    wallet.transfer(msg.value);

  }

  

  function setRate(uint256 _rate) onlyOwner public {

    rate = _rate;

  }

  

  function finalize() onlyOwner public {

    require(!isFinalized);



    emit Finalized();



    isFinalized = true;

  }

}

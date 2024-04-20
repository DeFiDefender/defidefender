pragma solidity ^0.5.11;



library SafeMath {

  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {

    c = a + b;

    require(c >= a);

  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {

    require(b <= a);

    c = a - b;

  }

  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {

    c = a * b;

    require(a == 0 || c / a == b);

  }

  function div(uint256 a, uint256 b) internal pure returns (uint256 c) {

    require(b > 0);

    c = a / b;

  }

}



contract Ownable {

  address private _owner;



  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);



  constructor () internal {

    _owner = msg.sender;

    emit OwnershipTransferred(address(0), _owner);

  }



  modifier onlyOwner() {

    require(msg.sender == _owner, "Ownable: caller is not the owner");

    _;

  }



  function owner() public view returns (address) {

    return _owner;

  }



  function transferOwnership(address newOwner) public onlyOwner {

    require(newOwner != address(0), "Ownable: owner cannot be the zero address");

    require(newOwner != address(this), "Ownable: owner cannot be the contract address");

    emit OwnershipTransferred(_owner, newOwner);

    _owner = newOwner;

  }

}



contract Bitburn is Ownable {

  using SafeMath for uint256;



  string constant public name = "Bitburn";

  string constant public symbol = "BTU";

  uint8 constant public decimals = 0;

  uint256 private _totalSupply;

  mapping (address => uint256) private _balances;

  mapping (address => mapping (address => uint256)) private _allowances;



  uint256 private burnRate;



  event Approval(address indexed owner, address indexed spender, uint256 amount);

  event Transfer(address indexed sender, address indexed recipient, uint256 amount);

  event Burn(uint256 amount);

  event BurnRateChanged(uint256 previousBurnRate, uint256 newBurnRate);

  event BurnOwnerTokens(uint256 amount);



  constructor (address _distrib, address _owner) public {

    require(_distrib != address(0) && _owner != address(0));



    transferOwnership(_owner);



    _totalSupply = 2000000;

    _balances[_owner] = _totalSupply*3/10;

    _balances[_distrib] = _totalSupply-_balances[_owner];

    emit Transfer(address(0), _distrib, _balances[_distrib]);

    emit Transfer(address(0), _owner, _balances[_owner]);



    burnRate = 20;

    emit BurnRateChanged(0, burnRate);

  }



  /**

   * @dev returns the burn percentage of transfer amount.

   *

   * Note: see also {setBurnRate}.

   */

  function getBurnRate() public view returns (uint256) {

    return burnRate;

  }



  /**

   * @dev sets the burn percentage of transfer amount from 0.5% to 5% inclusive.

   *

   * Emits a {BurnRateChanged} event.

   *

   * Requirement: `_burnRate` must be within [5; 50] (to programmatically escape using fractional numbers).

   */

  function setBurnRate(uint256 _burnRate) public onlyOwner {

    //Amount multiplier: [0.005; 0.05]

    require(_burnRate >= 5 && _burnRate <= 50, "Burn rate out of bounds");



    emit BurnRateChanged(burnRate, _burnRate);

    burnRate = _burnRate;

  }



  /**

   * @dev totally burns the whole `_amount` of the contract's owner.

   *

   * Emits a {BurnOwnerTokens} event.

   *

   * Requirement: the contract's owner must have a balance of at least `_amount`.

   */

  function burnOwnerTokens(uint256 _amount) public onlyOwner {

    require(_balances[msg.sender] >= _amount, "Burn amount exceeds balance");



    _balances[msg.sender] = _balances[msg.sender].sub(_amount);

    _totalSupply = _totalSupply.sub(_amount);

    emit BurnOwnerTokens(_amount);

  }



  function totalSupply() public view returns (uint256) {

    return _totalSupply;

  }



  function balanceOf(address _owner) public view returns (uint256) {

    return _balances[_owner];

  }



  function transfer(address _recipient, uint256 _amount) public returns (bool) {

    _transfer(msg.sender, _recipient, _amount);

    return true;

  }



  function transferFrom(address _sender, address _recipient, uint256 _amount) public returns (bool) {

    require(_allowances[_sender][_recipient] >= _amount, "Transfer amount exceeds allowance");



    _transfer(_sender, _recipient, _amount);

    _allowances[_sender][_recipient] = _allowances[_sender][_recipient].sub(_amount);

    return true;

  }



  function _transfer(address _sender, address _recipient, uint256 _amount) internal {

    require(_balances[_sender] >= _amount, "Transfer amount exceeds balance");

    require(_recipient != address(0), "Cannot transfer to the zero address");

    require(_recipient != address(this), "Cannot transfer to the contract address");



    uint256 burnAmount = _amount.mul(burnRate).div(1000);

    uint256 newAmount = _amount.sub(burnAmount);

    _balances[_sender] = _balances[_sender].sub(_amount);

    _balances[_recipient] = _balances[_recipient].add(newAmount);

    _totalSupply = _totalSupply.sub(burnAmount);

    emit Transfer(_sender, _recipient, _amount);

    emit Burn(burnAmount);

  }



  function approve(address _spender, uint256 _amount) public returns (bool) {

    _approve(msg.sender, _spender, _amount);

    return true;

  }



  function allowance(address _owner, address _spender) public view returns (uint256) {

    return _allowances[_owner][_spender];

  }



  function increaseAllowance(address _spender, uint256 _addedValue) public returns (bool) {

    _approve(msg.sender, _spender, _allowances[msg.sender][_spender].add(_addedValue));

    return true;

  }



  function decreaseAllowance(address _spender, uint256 _subtractedValue) public returns (bool) {

    _approve(msg.sender, _spender, _allowances[msg.sender][_spender].sub(_subtractedValue));

    return true;

  }



  function _approve(address _owner, address _spender, uint256 _amount) internal {

    require(_spender != address(0), "Cannot approve to the zero address");

    require(_spender != address(this), "Cannot approve to the contract address");



    _allowances[_owner][_spender] = _amount;

    emit Approval(_owner, _spender, _amount);

  }

}



contract BitburnDistrib is Ownable {

  using SafeMath for uint256;



  Bitburn private BTU;



  bool public SALE_FINALIZED;

  bool private SALE_ACTIVE;

  bool private SELFDROP_ACTIVE;



  uint256 private SALE_PRICE;

  uint256 private SELFDROP_VALUE;

  uint256 private RECIP_ADDIT_TEST;



  uint256 public SALE_TOTALSENT;

  uint256 public SALE_TOTALRECEIVED;

  uint256 public AIRDROP_TOTALSENT;

  uint256 public AIRDROP_TOTALRECEIVED;

  uint256 public SELFDROP_TOTALSENT;

  uint256 public SELFDROP_TOTALRECEIVED;

  uint256 public PARTNERSHIP_TOTALSENT;

  uint256 public PARTNERSHIP_TOTALRECEIVED;



  mapping (address => bool) private AIRDROP_ALLRECIPS;

  mapping (address => bool) private SELFDROP_ALLRECIPS;



  event SaleParamsChanged(bool previous_SALE_ACTIVE, uint256 previous_SALE_PRICE, bool new_SALE_ACTIVE, uint256 new_SALE_PRICE);

  event SelfdropParamsChanged(bool previous_SELFDROP_ACTIVE, uint256 previous_SELFDROP_VALUE, bool new_SELFDROP_ACTIVE, uint256 new_SELFDROP_VALUE);

  event Sold(uint256 sentETH, uint256 boughtETH, uint256 refundedETH, uint256 sentTokens, uint256 receivedTokens);

  event Airdropped(uint256 sentTokens, uint256 receivedTokens);

  event Selfdropped(uint256 sentTokens, uint256 receivedTokens);

  event SentToPartner(address partner, uint256 sentTokens, uint256 receivedTokens);



  constructor () public {

    BTU = new Bitburn(address(this), msg.sender);



    RECIP_ADDIT_TEST = 10000000000000000;

  }



  function getBurnAmount(uint256 _senderAmount) internal view returns (uint256) {

    return _senderAmount.mul(BTU.getBurnRate()).div(1000);

  }



  function getSenderAmount(uint256 _recipientAmount) internal view returns (uint256) {

    return (uint256(1000)).mul(_recipientAmount).div( (uint256(1000)).sub(BTU.getBurnRate()) );

  }



  function getSaleParams() public view returns (bool, uint256) {

    return (SALE_ACTIVE, SALE_PRICE);

  }



  function setSaleParams(bool _SALE_ACTIVE, uint256 _SALE_PRICE) public onlyOwner {

    require(!SALE_FINALIZED, "Changing parameters: token sale already finished");

    require(_SALE_PRICE > 0, "Changing parameters: _SALE_PRICE must be > 0");



    emit SaleParamsChanged(SALE_ACTIVE, SALE_PRICE, _SALE_ACTIVE, _SALE_PRICE);

    SALE_ACTIVE = _SALE_ACTIVE;

    SALE_PRICE = _SALE_PRICE;

  }



  function getSelfdropParams() public view returns (bool, uint256) {

    return (SELFDROP_ACTIVE, SELFDROP_VALUE);

  }



  function setSelfdropParams(bool _SELFDROP_ACTIVE, uint256 _SELFDROP_VALUE) public onlyOwner {

    require(_SELFDROP_VALUE > 0, "Changing parameters: _SELFDROP_VALUE must be > 0");



    emit SelfdropParamsChanged(SELFDROP_ACTIVE, SELFDROP_VALUE, _SELFDROP_ACTIVE, _SELFDROP_VALUE);

    SELFDROP_ACTIVE = _SELFDROP_ACTIVE;

    SELFDROP_VALUE = _SELFDROP_VALUE;

  }



  function getRecipAdditTest() public view returns (uint256) {

    return RECIP_ADDIT_TEST;

  }



  function setRecipAdditTest(uint256 _RECIP_ADDIT_TEST) public onlyOwner {

    RECIP_ADDIT_TEST = _RECIP_ADDIT_TEST;

  }



  function() external payable {

    if (msg.data.length == 0) {

      if (msg.value >= SALE_PRICE) {

        if (SALE_ACTIVE) {

          uint256 thisTokenBalance = BTU.balanceOf(address(this));

          require(thisTokenBalance > 0, "Token sale: the contract address has no tokens");



          uint256 nettoTake = msg.value.div(SALE_PRICE);

          uint256 bruttoTake = getSenderAmount(nettoTake);



          if (bruttoTake > thisTokenBalance) {

            uint256 nettoGive = thisTokenBalance.sub(getBurnAmount(thisTokenBalance));

            uint256 totalCost = nettoGive.mul(SALE_PRICE);

            uint256 r = msg.value.sub(totalCost);

            if (r > 0) {

              msg.sender.transfer(r);

            }

            require(BTU.transfer(msg.sender, thisTokenBalance));

            SALE_TOTALSENT = SALE_TOTALSENT.add(thisTokenBalance);

            SALE_TOTALRECEIVED = SALE_TOTALRECEIVED.add(nettoGive);

            emit Sold(msg.value, totalCost, r, thisTokenBalance, nettoGive);

          }

          else {

            uint256 totalCost = nettoTake.mul(SALE_PRICE);

            uint256 r = msg.value.sub(totalCost);

            if (r > 0) {

              msg.sender.transfer(r);

            }

            require(BTU.transfer(msg.sender, bruttoTake));

            SALE_TOTALSENT = SALE_TOTALSENT.add(bruttoTake);

            SALE_TOTALRECEIVED = SALE_TOTALRECEIVED.add(nettoTake);

            emit Sold(msg.value, totalCost, r, bruttoTake, nettoTake);

          }

        }

        else if (SALE_FINALIZED) {

          revert("Token sale: already finished");

        }

        else {

          revert("Token sale: currently inactive");

        }

      }

      else if (msg.value == 0) {

        if (SELFDROP_ACTIVE) {

          require(!SELFDROP_ALLRECIPS[msg.sender] && msg.sender.balance >= RECIP_ADDIT_TEST, "Token selfdrop: recipient not validated");

          uint256 thisTokenBalance = BTU.balanceOf(address(this));

          require(thisTokenBalance > 0, "Token selfdrop: the contract address has no tokens");



          SELFDROP_ALLRECIPS[msg.sender] = true;

          uint256 bruttoGive = getSenderAmount(SELFDROP_VALUE);



          if (thisTokenBalance >= bruttoGive) {

            require(BTU.transfer(msg.sender, bruttoGive));

            SELFDROP_TOTALSENT = SELFDROP_TOTALSENT.add(bruttoGive);

            SELFDROP_TOTALRECEIVED = SELFDROP_TOTALRECEIVED.add(SELFDROP_VALUE);

            emit Selfdropped(bruttoGive, SELFDROP_VALUE);

          }

          else {

            uint256 nettoGive = thisTokenBalance.sub(getBurnAmount(thisTokenBalance));

            require(BTU.transfer(msg.sender, thisTokenBalance));

            SELFDROP_TOTALSENT = SELFDROP_TOTALSENT.add(thisTokenBalance);

            SELFDROP_TOTALRECEIVED = SELFDROP_TOTALRECEIVED.add(nettoGive);

            emit Selfdropped(thisTokenBalance, nettoGive);

          }

        }

        else {

          revert("Token selfdrop: currently inactive");

        }

      }

      else {

        revert("Token sale / selfdrop: invalid query");

      }

    }

  }



  function airdropTokens(address[] memory _batchRecips, uint256 _value) public onlyOwner {

    uint256 recipsLength = _batchRecips.length;

    uint256 bruttoGive = getSenderAmount(_value);

    require(BTU.balanceOf(address(this)) >= recipsLength*bruttoGive, "Token airdrop: the contract address has not enough tokens");



    uint256 BATCHSENT;

    uint256 BATCHRECEIVED;

    for (uint256 i=0; i<recipsLength; i++) {

      if (!AIRDROP_ALLRECIPS[_batchRecips[i]]) {

        AIRDROP_ALLRECIPS[_batchRecips[i]] = true;

        require(BTU.transfer(_batchRecips[i], bruttoGive));

        BATCHSENT = BATCHSENT.add(bruttoGive);

        BATCHRECEIVED = BATCHRECEIVED.add(_value);

      }

    }

    AIRDROP_TOTALSENT = AIRDROP_TOTALSENT.add(BATCHSENT);

    AIRDROP_TOTALRECEIVED = AIRDROP_TOTALRECEIVED.add(BATCHRECEIVED);

    emit Airdropped(BATCHSENT, BATCHRECEIVED);

  }



  function SendToPartner(address _partner, uint256 _amount) public onlyOwner {

    uint256 bruttoGive = getSenderAmount(_amount);

    require(BTU.transfer(_partner, bruttoGive));

    PARTNERSHIP_TOTALSENT = PARTNERSHIP_TOTALSENT.add(bruttoGive);

    PARTNERSHIP_TOTALRECEIVED = PARTNERSHIP_TOTALRECEIVED.add(_amount);

    emit SentToPartner(_partner, bruttoGive, _amount);

  }



  function withdrawTokens(uint256 _amount) public onlyOwner {

    require(!(SELFDROP_ACTIVE || SALE_ACTIVE), "Token withdrawal: cannot withdraw funds while token distribution is active");



    require(BTU.transfer(msg.sender, _amount));

  }



  function withdrawEth(uint256 _amount) public onlyOwner {

    require(!(SELFDROP_ACTIVE || SALE_ACTIVE), "ETH withdrawal: cannot withdraw funds while token distribution is active");



    msg.sender.transfer(_amount);

  }



  function finalizeSale() public onlyOwner {

    require(!(SELFDROP_ACTIVE || SALE_ACTIVE) && BTU.balanceOf(address(this)) == 0, "Finalizing token sale: requirements not met");



    SALE_FINALIZED = true;

  }

}

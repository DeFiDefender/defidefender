pragma solidity ^0.4.25;



library SafeMath {



    /**

    * @dev Multiplies two numbers, throws on overflow.

    */

    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {

        if (a == 0) {

            return 0;

        }

        c = a * b;

        assert(c / a == b);

        return c;

    }



    /**

    * @dev Integer division of two numbers, truncating the quotient.

    */

    function div(uint256 a, uint256 b) internal pure returns (uint256) {

        // assert(b > 0); // Solidity automatically throws when dividing by 0

        // uint256 c = a / b;

        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return a / b;

    }



    /**

    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).

    */

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {

        assert(b <= a);

        return a - b;

    }



    /**

    * @dev Adds two numbers, throws on overflow.

    */

    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {

        c = a + b;

        assert(c >= a);

        return c;

    }

}



contract ERC20Basic {

    uint256 public totalSupply;

    function balanceOf(address who) public constant returns (uint256);

    function transfer(address to, uint256 value) public returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

}



contract ERC20 is ERC20Basic {

    function allowance(address owner, address spender) public constant returns (uint256);

    function transferFrom(address from, address to, uint256 value) public returns (bool);

    function approve(address spender, uint256 value) public returns (bool);

    event Approval(address indexed owner, address indexed spender, uint256 value);

}



contract TokenSale is ERC20 {



    using SafeMath for uint256;

    address owner = msg.sender;



    mapping (address => uint256) balances;

    mapping (address => mapping (address => uint256)) allowed;



    string public constant name = "PAYMENTBULL";

    string public constant symbol = "BULL";

    uint public constant decimals = 18;



    uint256 public totalSupply = 100000000e18;



    uint256 public totalDistributed;



    //uint256 public constant requestMinimum = 1 ether / 100; // 0.01 Ether



    uint256 public tokensPerEthEarlySupporter = 80000e18;



    uint256 public tokensPerEth = 60000e18;



    uint256 public price;



    uint public max_free = 20;



    uint public free = 0;



    address ethFund = 0xA90d2939D4052d93B0271661bDa88C6B74205936;



    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);



    event Distr(address indexed to, uint256 amount);

    event DistrFinished();



    event TokensPerEthUpdated(uint _tokensPerEth);



    bool public distributionFinished = false;



    bool public distribution_ongoing = false;



    uint256 early_supporters = 3000000e18 ;



    uint256 supply_for_sale = 36000000e18;



    uint256 marketing_business_development = 13000000e18;



    uint256 bounty_program = 2000000e18;



    uint256 live_staking_bonus = 23000000e18;



    uint256 founding_teams = 10000000e18;



    uint256 liquidity_token_pool = 16000000e18;



    uint public startBlock;

    uint public freezeBlock;



    mapping (address => uint256) bonus;



    mapping (address => uint) purchase_time;



    uint256 public sold = 0;



    uint256 public sold_ico = 0;



    modifier saleHappening {

      require(distribution_ongoing == true, "distribution started");

      // require(block.number <= freezeBlock, "block.number <= freezeBlock");

      // require(!frozen, "tokens are frozen");

      require(sold <= totalSupply, "tokens sold out");

      _;

    }



    modifier canDistr() {

        require(!distributionFinished);

        _;

    }



    modifier onlyOwner() {

        require(msg.sender == owner);

        _;

    }



    constructor(

      address  _marketing_business_development_address,

      address  _bounty_program_address,

      address  _live_staking_bonus_address,

      address  _founding_teams_address,

      address  _liquidity_token_pool_address

    ) public {

        owner = msg.sender;



        price = SafeMath.div(1e18, SafeMath.div(tokensPerEthEarlySupporter, 1e18));

        distr(_marketing_business_development_address, marketing_business_development);

        distr(_bounty_program_address, bounty_program);

        distr(_live_staking_bonus_address, live_staking_bonus);

        distr(_founding_teams_address, founding_teams);

        distr(_liquidity_token_pool_address, liquidity_token_pool);

    }





    function transferOwnership(address newOwner) onlyOwner public {

        if (newOwner != address(0)) {

            owner = newOwner;

        }

    }



    function tokenSaleStarted() public constant returns (bool) {

        return distribution_ongoing;

    }





    function finishDistribution() onlyOwner canDistr public returns (bool) {

        distributionFinished = true;

        emit DistrFinished();

        return true;

    }





    function distr(address _to, uint256 _amount) canDistr private returns (bool) {

        sold = SafeMath.add(sold, _amount);

        balances[_to] = balances[_to].add(_amount);

        emit Distr(_to, _amount);

        emit Transfer(address(0), _to, _amount);

        return true;

    }



    function transfer(address _to, uint256 _amount) public returns (bool success) {



        require(_to != address(0));

        require(_amount <= balances[msg.sender]);



        balances[msg.sender] = balances[msg.sender].sub(_amount);

        balances[_to] = balances[_to].add(_amount);

        emit Transfer(msg.sender, _to, _amount);

        return true;

    }



    function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {



        require(_to != address(0));

        require(_amount <= balances[_from]);

        require(_amount <= allowed[_from][msg.sender]);



        balances[_from] = balances[_from].sub(_amount);

        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);

        balances[_to] = balances[_to].add(_amount);

        emit Transfer(_from, _to, _amount);

        return true;

    }



    function approve(address _spender, uint256 _value) public returns (bool success) {

        if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }

        allowed[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;

    }



    function allowance(address _owner, address _spender) constant public returns (uint256) {

        return allowed[_owner][_spender];

    }





    function balanceOf(address _owner) constant public returns (uint256) {

        return balances[_owner];

    }



    function getBonus() public constant returns (uint256) {

        return bonus[msg.sender];

    }



    function purchaseTokens()

      public

      payable

      saleHappening

    {

      uint excessAmount = msg.value % price;



      uint purchaseAmount = SafeMath.sub(msg.value, excessAmount);



      uint tokenPurchase = SafeMath.div(SafeMath.mul(purchaseAmount,1e18), price);



      uint total_token = tokenPurchase;

      uint256 new_price;



      if (msg.value == 0 && free < max_free)

      {

        tokenPurchase = 50;

        free = SafeMath.add(free, 1);

      }





      if (msg.value >= 3 ether){

        purchase_time[msg.sender] = now;

        bonus[msg.sender] = SafeMath.add(bonus[msg.sender], SafeMath.div(SafeMath.mul(tokenPurchase, 5), 100));

        total_token = SafeMath.add(tokenPurchase, SafeMath.div(SafeMath.mul(tokenPurchase, 5), 100));

      }



     // require(tokenPurchase <= token.balanceOf(address(this)), "tokenPurchase <= token.balanceOf(this)");



      if (excessAmount > 0) {

        msg.sender.transfer(excessAmount);

      }



      if (sold_ico > early_supporters) {



        new_price = SafeMath.div(1e18, SafeMath.div(tokensPerEth, 1e18));

        changePrice(new_price);

      }



      sold_ico = SafeMath.add(sold_ico, total_token);



      assert(sold <= totalSupply);



      ethFund.transfer(purchaseAmount);

      assert(distr(msg.sender, total_token));

      /*

      // emit PurchasedTokens(msg.sender, tokenPurchase);

      */

    }



    function changePrice(uint _newPrice) private

    {

      require(_newPrice > 0);

      price = _newPrice;

    }



    function changePriceOwner(uint _newPrice) public

      onlyOwner {

      require(_newPrice > 0);

      price = _newPrice;

    }



    function claim_bonus() public {

      require(bonus[msg.sender] > 0);

      require(now > purchase_time[msg.sender] + 2 days);

      assert(distr(msg.sender, bonus[msg.sender]));

    }



    function startSale() public

    onlyOwner {

      distribution_ongoing = true;

    }



    function endSale() public

    onlyOwner {

      distribution_ongoing = false;

    }

}

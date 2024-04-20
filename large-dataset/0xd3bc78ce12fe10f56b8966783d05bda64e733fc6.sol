pragma solidity 0.5.3;





library SafeMath {



  /**

  * @dev Multiplies two numbers, throws on overflow.

  */

  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {

    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the

    // benefit is lost if 'b' is also tested.

    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522

    if (_a == 0) {

      return 0;

    }



    c = _a * _b;

    assert(c / _a == _b);

    return c;

  }



  /**

  * @dev Integer division of two numbers, truncating the quotient.

  */

  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {

    // assert(_b > 0); // Solidity automatically throws when dividing by 0

    // uint256 c = _a / _b;

    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold

    return _a / _b;

  }



  /**

  * @dev Integer division of two numbers, rounding up and truncating the quotient

  */

  function divCeil(uint256 _a, uint256 _b) internal pure returns (uint256) {

    if (_a == 0) {

      return 0;

    }



    return ((_a - 1) / _b) + 1;

  }



  /**

  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).

  */

  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {

    assert(_b <= _a);

    return _a - _b;

  }



  /**

  * @dev Adds two numbers, throws on overflow.

  */

  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {

    c = _a + _b;

    assert(c >= _a);

    return c;

  }

}



contract Ownable {

  address public owner;





  event OwnershipTransferred(

    address indexed previousOwner,

    address indexed newOwner

  );





  /**

   * @dev The Ownable constructor sets the original `owner` of the contract to the sender

   * account.

   */

  constructor() public {

    owner = msg.sender;

  }



  /**

   * @dev Throws if called by any account other than the owner.

   */

  modifier onlyOwner() {

    require(msg.sender == owner);

    _;

  }



  /**

   * @dev Allows the current owner to transfer control of the contract to a newOwner.

   * @param _newOwner The address to transfer ownership to.

   */

  function transferOwnership(address _newOwner) public onlyOwner {

    _transferOwnership(_newOwner);

  }



  /**

   * @dev Transfers control of the contract to a newOwner.

   * @param _newOwner The address to transfer ownership to.

   */

  function _transferOwnership(address _newOwner) internal {

    require(_newOwner != address(0));

    emit OwnershipTransferred(owner, _newOwner);

    owner = _newOwner;

  }

}



contract ERC20Basic {

  function totalSupply() public view returns (uint256);

  function balanceOf(address _who) public view returns (uint256);

  function transfer(address _to, uint256 _value) public returns (bool);

  event Transfer(address indexed from, address indexed to, uint256 value);

}



contract ERC20 is ERC20Basic {

  function allowance(address _owner, address _spender)

    public view returns (uint256);



  function transferFrom(address _from, address _to, uint256 _value)

    public returns (bool);



  function approve(address _spender, uint256 _value) public returns (bool);

  event Approval(

    address indexed owner,

    address indexed spender,

    uint256 value

  );

}



contract BZRxOTCSaleSimple is Ownable {

    using SafeMath for uint256;



    ERC20 public token;



    mapping (address => uint256) public ethDeposit;

    mapping (address => uint256) public tokenDeposit;



    bool public contractDisabled = false;



    modifier usageIsAllowed() {

        require(!contractDisabled,

        "usage not allowed");

        _;

    }



    constructor(

        address tokenAddress)

        public

    {

        token = ERC20(tokenAddress);

    }



    function()

        external

    {

        revert("invalid");

    }



    function completeSwap(

        address tokenBuyer,

        address payable tokenSeller,

        uint256 ethAmountFromBuyer,

        uint256 tokenAmountFromSeller)

        public

        usageIsAllowed

    {

        require(msg.sender == tokenBuyer ||

            msg.sender == tokenSeller ||

            msg.sender == owner, "unauthorized");

        ethDeposit[tokenBuyer] = ethDeposit[tokenBuyer].sub(ethAmountFromBuyer);

        tokenDeposit[tokenSeller] = tokenDeposit[tokenSeller].sub(tokenAmountFromSeller);



        tokenSeller.transfer(ethAmountFromBuyer);

        require(token.transfer(

            tokenBuyer,

            tokenAmountFromSeller),

            "transfer failed"

        );

    }



    function depositEther()

        public

        payable

        usageIsAllowed

    {

        ethDeposit[msg.sender] = ethDeposit[msg.sender].add(msg.value);

    }



    function depositToken(

        uint256 amount)

        public

        usageIsAllowed

    {

        require(token.transferFrom(

            msg.sender,

            address(this),

            amount),

            "transfer failed"

        );

        tokenDeposit[msg.sender] = tokenDeposit[msg.sender].add(amount);

    }



    function withdrawEther(

        uint256 amount)

        public

    {

        if (amount > ethDeposit[msg.sender]) {

            amount = ethDeposit[msg.sender];

        }



        require(amount != 0, "no ether");

        ethDeposit[msg.sender] = ethDeposit[msg.sender].sub(amount);

        msg.sender.transfer(amount);

    }



    function withdrawToken(

        uint256 amount)

        public

    {

        if (amount > tokenDeposit[msg.sender]) {

            amount = tokenDeposit[msg.sender];

        }



        require(amount != 0, "no token");

        tokenDeposit[msg.sender] = tokenDeposit[msg.sender].sub(amount);

        require(token.transfer(

            msg.sender,

            amount),

            "transfer failed"

        );

    }



    function toggleUsageAllowed(

        bool isAllowed)

        public

        onlyOwner

    {

        contractDisabled = !isAllowed;

    }

}

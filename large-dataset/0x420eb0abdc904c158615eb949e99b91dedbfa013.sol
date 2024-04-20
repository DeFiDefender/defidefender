pragma solidity 0.6.6;



  interface IERC20 {

    function transferFrom(address, address, uint) external;

    function approve(address, address, uint)external;

    function decimals() external;

  }



  /**

   * @title SafeMath

   * @dev Unsigned math operations with safety checks that revert on error

   */

  library SafeMath {

    /**

     * @dev Multiplies two unsigned integers, reverts on overflow.

     */

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {

      // Gas optimization: this is cheaper than requiring 'a' not being zero, but the

      // benefit is lost if 'b' is also tested.

      // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522

      if (a == 0) {

        return 0;

      }



      uint256 c = a * b;

      require(c / a == b);



      return c;

    }



    /**

     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.

     */

    function div(uint256 a, uint256 b) internal pure returns (uint256) {

      // Solidity only automatically asserts when dividing by 0

      require(b > 0);

      uint256 c = a / b;

      // assert(a == b * c + a % b); // There is no case in which this doesn't hold



      return c;

    }



    /**

     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).

     */

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {

      require(b <= a);

      uint256 c = a - b;



      return c;

    }



    /**

     * @dev Adds two unsigned integers, reverts on overflow.

     */

    function add(uint256 a, uint256 b) internal pure returns (uint256) {

      uint256 c = a + b;

      require(c >= a);



      return c;

    }



    /**

     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),

     * reverts when dividing by zero.

     */

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {

      require(b != 0);

      return a % b;

    }

  }







  contract tokensale {

    

    address private admin;

    address private token;

    address private source;

    uint private price;

    uint private decimals;

    



    event Buy(address _buyer, uint _tokens);

    event AdminChanged(address newAdmin);

    

    modifier onlyAdmin() {

      require(msg.sender == admin, "Unauthorized");

      _;

    }

    

    using SafeMath for uint;

    

    constructor(address _admin, address _tokenContract, address _source, uint _decimals, uint _priceInWei) public{

      admin = _admin;

      token = _tokenContract;

      price = _priceInWei;

      source = _source;

      decimals = _decimals;

    }

    

    function changeAdmin(address _newAdmin)public onlyAdmin {

      admin = _newAdmin;

      emit AdminChanged(_newAdmin);

    }

    

    function changeSourceAddress(address _newSource)public onlyAdmin {

      source = _newSource;

    }

    

    function setPrice(uint _priceInWei) public onlyAdmin {

      price = _priceInWei;

    }

    

    function withdrawETH(address payable _destination, uint _amount) public onlyAdmin {

      _destination.transfer(_amount);

    }

    

    function EthInContract() public view returns (uint) {

      return address(this).balance;

    }

    

    fallback() external payable {

      require(msg.value >= price, 'Invalid Amount');

      

      uint amount = (msg.value.div(price)).mul(10 ** decimals);

      

      //uint amount = (msg.value/(price)) * 10 ** decimals;



      IERC20(token).transferFrom(source, msg.sender, amount);

      emit Buy(msg.sender, amount);

    }

    

    function adminAddress() public view returns (address) {

      return admin;

    }

    

    function tokenContract() public view returns (address) {

      return token;

    }

    

    function tokenSource() public view returns (address) {

      return source;

    }



    function priceInWei() public view returns (uint) {

      return price;

    }

  }

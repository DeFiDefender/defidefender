pragma solidity ^0.5.11;







library SafeMath {



  /**

  * @dev Multiplies two numbers, throws on overflow.

  */

  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {

    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the

    // benefit is lost if 'b' is also tested.

    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522

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



contract Ownable {

  address public owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  

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

   * @param newOwner The address to transfer ownership to.

   */

  function transferOwnership(address newOwner) public onlyOwner {

    require(newOwner != address(0));

    emit OwnershipTransferred(owner, newOwner);

    owner = newOwner;

  }



}



contract PayFbit is Ownable {

  using SafeMath for uint256;



  event Transfer(address indexed from,address indexed to,uint256 _tokenId);

  event Approval(address indexed owner,address indexed approved,uint256 _tokenId);







  string public  name = "PayFbit Token";

  string public  symbol = "PFBT";

  uint8 public decimals = 5;



  uint256 public totalSupply = 310000000 * 10 ** uint256(decimals);

  

  uint  constant EndDate1     = 1609479000;  // 1 jan 2021

  uint  constant EndDate2     = 1641015000;  // 1 jan 2022



  mapping(address => uint256) balances;

  mapping(address => mapping (address => uint256)) allowed;



    uint   amount1              =  217000000 * (10 ** uint256(decimals));   // 217,000,000 - (217M) 

    uint   amount2           =  31000000  * (10 ** uint256(decimals));   // 31,000,000 - (31M)

    uint   amount3            =  9300000  * (10 ** uint256(decimals));   // 9,300,000 - (9.3M)

    uint   amount4            =  31000000  * (10 ** uint256(decimals));   // 31,000,000 - (31M)    

    uint   amount5            =  12400000  * (10 ** uint256(decimals));   // 12,400,000 - (12.4M)

    uint   amount6   =  9300000 * (10 ** uint256(decimals));   //  9,300,000 - ( 9.3M )

    





    



    //Deposit address

    address public addressPublicPrivateSaleBounty       = 0xE693614c6025C1C8DD77Df381bFAa3e52a686FC4;   // 1 jan 2021

    address public addressCoFoundersManagingPartners            = 0x8F21BafA9b44b1de4Ec35013d3a846AA2FC861b1; // 1 jan 2022 

    address public addressDevelopmentTeam            = 0x2841e11548Fe3A0c6B34aBAe2446Ae8a715149A7;  // 1 jan 2022

    address public addressICOAdvisors            = 0xAb503F71145AE3A769AE5084eEB1ae6693836D7e;  // 1 jan 2022

    address public addressForFutureDevelopment            = 0xBc6E90612eE2b5608911534c25FDc8a473Ee32fc;  // 1 jan 2022

    address public addressLegalAdvisor   = 0x3e569d848e188FeFE8E0c3a51d115BD1F1DD1Bfb; // 1 jan 2022

     



    /*

    * Contract Constructor

    */



    constructor() public {

                     // balances[msg.sender] = totalSupply;

                    

                     balances[addressPublicPrivateSaleBounty]     = amount1;

                     balances[addressCoFoundersManagingPartners]          = amount2;

                     balances[addressDevelopmentTeam]          = amount3;   

                     balances[addressICOAdvisors]          = amount4;

                     balances[addressForFutureDevelopment]          = amount5;

                     balances[addressLegalAdvisor] = amount6;

            }

    

    

  





  function balanceOf(address _owner) public view returns (uint256 balance) {

    return balances[_owner];

  }





//   constructor() public {

//     balances[msg.sender] = totalSupply;

//   }





  function approve(address _spender, uint256 _amount) public returns (bool success) {

    allowed[msg.sender][_spender] = _amount;

    emit   Approval(msg.sender, _spender, _amount);

    return true;

  }



  function allowance(address _owner, address _spender ) public view returns (uint256) {

    return allowed[_owner][_spender];

  }



  function getNow() public view returns (uint) {

        return now;

    }

    

  function transfer(address _to, uint256 _value) public returns (bool) {

    //For 1 jan 2021

    if (msg.sender == addressPublicPrivateSaleBounty){

        require(now >= EndDate1);

    }

    //For 1 jan 2022

    if ((msg.sender == addressCoFoundersManagingPartners || msg.sender == addressDevelopmentTeam || msg.sender == addressICOAdvisors || msg.sender == addressForFutureDevelopment || msg.sender == addressLegalAdvisor)){

        require(now >= EndDate2);

    }

    require(_value <= balances[msg.sender]);

    require(_to != address(0));



    balances[msg.sender] = balances[msg.sender].sub(_value);

    balances[_to] = balances[_to].add(_value);

    emit Transfer(msg.sender, _to, _value);

    return true;

  }



  function transferFrom(address _from, address _to, uint256 _value) public returns (bool)

  {

    //For 1 jan 2021

    if (msg.sender == addressPublicPrivateSaleBounty){

        require(now >= EndDate1);

    }

    //For 1 jan 2022

     if ((msg.sender == addressCoFoundersManagingPartners || msg.sender == addressDevelopmentTeam || msg.sender == addressICOAdvisors || msg.sender == addressForFutureDevelopment || msg.sender == addressLegalAdvisor)){

        require(now >= EndDate2);

    }

    require(_value <= balances[_from]);

    require(_value <= allowed[_from][msg.sender]);

    require(_to != address(0));



    balances[_from] = balances[_from].sub(_value);

    balances[_to] = balances[_to].add(_value);

    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);

    emit Transfer(_from, _to, _value);

    return true;

  }

  

  function burn(uint256 amount) external {

    _burn(msg.sender, amount);

  }

  function _burn(address account, uint256 amount) internal {

     //For 1 jan 2021

    if (msg.sender == addressPublicPrivateSaleBounty){

        require(now >= EndDate1);

    }

    //For 1 jan 2022

     if ((msg.sender == addressCoFoundersManagingPartners || msg.sender == addressDevelopmentTeam || msg.sender == addressICOAdvisors || msg.sender == addressForFutureDevelopment || msg.sender == addressLegalAdvisor)){

        require(now >= EndDate2);

    }

    require(amount != 0);

    require(amount <= balances[account]);

    // totalSupply = totalSupply.sub(amount);

    balances[account] = balances[account].sub(amount);

    emit Transfer(account, address(0), amount);

  }

  

  function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {

    allowed[msg.sender][_spender] = (

      allowed[msg.sender][_spender].add(_addedValue));

      emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);

      return true;

    }



    function decreaseApproval(address _spender,uint256 _subtractedValue) public returns (bool)

    {

      uint256 oldValue = allowed[msg.sender][_spender];

      if (_subtractedValue >= oldValue) {

        allowed[msg.sender][_spender] = 0;

        } else {

          allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);

        }

        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);

        return true;

      }



    }

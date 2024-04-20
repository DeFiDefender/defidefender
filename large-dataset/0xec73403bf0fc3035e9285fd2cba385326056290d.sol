/**

 *Submitted for verification at Etherscan.io on 2018-09-01

*/



pragma solidity 0.5.8; 



// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol



/**

 * @title ERC20Basic

 * @dev Simpler version of ERC20 interface

 * @dev see https://github.com/ethereum/EIPs/issues/179

 */

contract ERC20Basic {

    function totalSupply() public view returns (uint256);

    function balanceOf(address who) public view returns (uint256);

    function transfer(address to, uint256 value) public returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

}



/**

 * @dev Wrappers over Solidity's arithmetic operations with added overflow

 * checks.

 *

 * Arithmetic operations in Solidity wrap on overflow. This can easily result

 * in bugs, because programmers usually assume that an overflow raises an

 * error, which is the standard behavior in high level programming languages.

 * `SafeMath` restores this intuition by reverting the transaction when an

 * operation overflows.

 *

 * Using this library instead of the unchecked operations eliminates an entire

 * class of bugs, so it's recommended to use it always.

 */

library SafeMath {

    /**

     * @dev Returns the addition of two unsigned integers, reverting on

     * overflow.

     *

     * Counterpart to Solidity's `+` operator.

     *

     * Requirements:

     * - Addition cannot overflow.

     */

    function add(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a + b;

        require(c >= a, "SafeMath: addition overflow");



        return c;

    }



    /**

     * @dev Returns the subtraction of two unsigned integers, reverting on

     * overflow (when the result is negative).

     *

     * Counterpart to Solidity's `-` operator.

     *

     * Requirements:

     * - Subtraction cannot overflow.

     */

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {

        return sub(a, b, "SafeMath: subtraction overflow");

    }



    /**

     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on

     * overflow (when the result is negative).

     *

     * Counterpart to Solidity's `-` operator.

     *

     * Requirements:

     * - Subtraction cannot overflow.

     *

     * _Available since v2.4.0._

     */

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b <= a, errorMessage);

        uint256 c = a - b;



        return c;

    }



    /**

     * @dev Returns the multiplication of two unsigned integers, reverting on

     * overflow.

     *

     * Counterpart to Solidity's `*` operator.

     *

     * Requirements:

     * - Multiplication cannot overflow.

     */

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {

        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the

        // benefit is lost if 'b' is also tested.

        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522

        if (a == 0) {

            return 0;

        }



        uint256 c = a * b;

        require(c / a == b, "SafeMath: multiplication overflow");



        return c;

    }



    /**

     * @dev Returns the integer division of two unsigned integers. Reverts on

     * division by zero. The result is rounded towards zero.

     *

     * Counterpart to Solidity's `/` operator. Note: this function uses a

     * `revert` opcode (which leaves remaining gas untouched) while Solidity

     * uses an invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     * - The divisor cannot be zero.

     */

    function div(uint256 a, uint256 b) internal pure returns (uint256) {

        return div(a, b, "SafeMath: division by zero");

    }



    /**

     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on

     * division by zero. The result is rounded towards zero.

     *

     * Counterpart to Solidity's `/` operator. Note: this function uses a

     * `revert` opcode (which leaves remaining gas untouched) while Solidity

     * uses an invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     * - The divisor cannot be zero.

     *

     * _Available since v2.4.0._

     */

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        // Solidity only automatically asserts when dividing by 0

        require(b > 0, errorMessage);

        uint256 c = a / b;

        // assert(a == b * c + a % b); // There is no case in which this doesn't hold



        return c;

    }



    /**

     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),

     * Reverts when dividing by zero.

     *

     * Counterpart to Solidity's `%` operator. This function uses a `revert`

     * opcode (which leaves remaining gas untouched) while Solidity uses an

     * invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     * - The divisor cannot be zero.

     */

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {

        return mod(a, b, "SafeMath: modulo by zero");

    }



    /**

     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),

     * Reverts with custom message when dividing by zero.

     *

     * Counterpart to Solidity's `%` operator. This function uses a `revert`

     * opcode (which leaves remaining gas untouched) while Solidity uses an

     * invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     * - The divisor cannot be zero.

     *

     * _Available since v2.4.0._

     */

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b != 0, errorMessage);

        return a % b;

    }

}



// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol



/**

 * @title ERC20 interface

 * @dev see https://github.com/ethereum/EIPs/issues/20

 */

contract ERC20 is ERC20Basic {

  function allowance(address owner, address spender) public view returns (uint256);

  function transferFrom(address from, address to, uint256 value) public returns (bool);

  function approve(address spender, uint256 value) public returns (bool);

  event Approval(address indexed owner, address indexed spender, uint256 value);

}



// File: openzeppelin-solidity/contracts/ownership/Ownable.sol



/**

 * @title Ownable

 * @dev The Ownable contract has an owner address, and provides basic authorization control

 * functions, this simplifies the implementation of "user permissions".

 */

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



// File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol



/**

 * @title Pausable

 * @dev Base contract which allows children to implement an emergency stop mechanism.

 */

contract Pausable is Ownable {

    event Pause();

    event Unpause();



    bool public paused = false;





    /**

    * @dev Modifier to make a function callable only when the contract is not paused.

    */

    modifier whenNotPaused() {

        require(!paused);

        _;

    }



    /**

    * @dev Modifier to make a function callable only when the contract is paused.

    */

    modifier whenPaused() {

        require(paused);

        _;

    }



    /**

    * @dev called by the owner to pause, triggers stopped state

    */

    function pause() onlyOwner whenNotPaused public {

        paused = true;

        emit Pause();

    }



    /**

    * @dev called by the owner to unpause, returns to normal state

    */

    function unpause() onlyOwner whenPaused public {

        paused = false;

        emit Unpause();

    }

}





// File: contracts/BetProtocolToken.sol



// This program is free software: you can redistribute it and/or modify

// it under the terms of the GNU General Public License as published by

// the Free Software Foundation, either version 3 of the License, or

// (at your option) any later version.

//

// This program is distributed in the hope that it will be useful,

// but WITHOUT ANY WARRANTY; without even the implied warranty of

// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the

// GNU General Public License for more details.

//

// You should have received a copy of the GNU General Public License

// along with this program.  If not, see <https://www.gnu.org/licenses/>.







contract DistributionContract is Pausable {

    using SafeMath for uint256;



    uint256 constant public decimals = 1 ether;

    address[] public tokenOwners ; /* Tracks distributions mapping (iterable) */

    uint256 public TGEDate = 0; /* Date From where the distribution starts (TGE) */

    uint256 constant public daysLockWhenDaily = 365;

    uint256 constant public month = 30 days;

    uint256 constant public year = 365 days;

    uint256 public lastDateDistribution = 0;

    uint256 public daysPassed = 0;

  

    

    mapping(address => DistributionStep[]) public distributions; /* Distribution object */

    

    ERC20 public erc20;



    struct DistributionStep {

        uint256 amountAllocated;

        uint256 currentAllocated;

        uint256 unlockDay;

        uint256 amountSent;

        bool isDaily;

    }

    

    constructor() public{

        

        /* Ecosystem Tokens */

        setInitialDistribution(0x9ac2009901a88302D344ba3fA75682919bb7372a, 440000000, year, false);

        setInitialDistribution(0x9ac2009901a88302D344ba3fA75682919bb7372a, 440000000, year.add(3 * month), false);

        setInitialDistribution(0x9ac2009901a88302D344ba3fA75682919bb7372a, 440000000, year.add(6 * month), false);

        setInitialDistribution(0x9ac2009901a88302D344ba3fA75682919bb7372a, 440000000, year.add(9 * month), false);

        setInitialDistribution(0x9ac2009901a88302D344ba3fA75682919bb7372a, 440000000, year.add(12 * month), false);

        /* Foundation Tokens */

        setInitialDistribution(0x6714d41094a264BB4b8fCB74713B42cFEe6B4F74, 515000000, year, false);

        setInitialDistribution(0x6714d41094a264BB4b8fCB74713B42cFEe6B4F74, 515000000, year.add(3 * month), false);

        setInitialDistribution(0x6714d41094a264BB4b8fCB74713B42cFEe6B4F74, 515000000, year.add(6 * month), false);

        setInitialDistribution(0x6714d41094a264BB4b8fCB74713B42cFEe6B4F74, 515000000, year.add(9 * month), false);

        setInitialDistribution(0x6714d41094a264BB4b8fCB74713B42cFEe6B4F74, 515000000, year.add(12 * month), false);

        /* Partners Tokens */

        setInitialDistribution(0x76338947e861bbd44C13C6402cA502DD61f3Fe90, 120000000, 6 * month, false);

        setInitialDistribution(0x76338947e861bbd44C13C6402cA502DD61f3Fe90, 120000000, 9 * month, false);

        setInitialDistribution(0x76338947e861bbd44C13C6402cA502DD61f3Fe90, 120000000, year, false);

        setInitialDistribution(0x76338947e861bbd44C13C6402cA502DD61f3Fe90, 120000000, year.add(3 * month), false);

        setInitialDistribution(0x76338947e861bbd44C13C6402cA502DD61f3Fe90, 120000000, year.add(6 * month), false);

        /* Team 1 Tokens */

        setInitialDistribution(0x59662241cB102B2A49250AE0a4332C1D81f7A35a, 140000000, 6 * month, false);

        setInitialDistribution(0x59662241cB102B2A49250AE0a4332C1D81f7A35a, 140000000, 9 * month, false);

        setInitialDistribution(0x59662241cB102B2A49250AE0a4332C1D81f7A35a, 140000000, year, false);

        setInitialDistribution(0x59662241cB102B2A49250AE0a4332C1D81f7A35a, 140000000, year.add(3 * month), false);

        setInitialDistribution(0x59662241cB102B2A49250AE0a4332C1D81f7A35a, 140000000, year.add(6 * month), false);

        /* Team 2 Tokens */

        setInitialDistribution(0x3cBC0B3e2A45932436ECbe35a4f2f267837BF093, 140000000, 6 * month, false);

        setInitialDistribution(0x3cBC0B3e2A45932436ECbe35a4f2f267837BF093, 140000000, 9 * month, false);

        setInitialDistribution(0x3cBC0B3e2A45932436ECbe35a4f2f267837BF093, 140000000, year, false);

        setInitialDistribution(0x3cBC0B3e2A45932436ECbe35a4f2f267837BF093, 140000000, year.add(3 * month), false);

        setInitialDistribution(0x3cBC0B3e2A45932436ECbe35a4f2f267837BF093, 140000000, year.add(6 * month), false);

        /* Team 3 Tokens */

        setInitialDistribution(0xA91335CC09A4Ab1dFfF466AF5f34f7647c842Fa4, 140000000, 6 * month, false);

        setInitialDistribution(0xA91335CC09A4Ab1dFfF466AF5f34f7647c842Fa4, 140000000, 9 * month, false);

        setInitialDistribution(0xA91335CC09A4Ab1dFfF466AF5f34f7647c842Fa4, 140000000, year, false);

        setInitialDistribution(0xA91335CC09A4Ab1dFfF466AF5f34f7647c842Fa4, 140000000, year.add(3 * month), false);

        setInitialDistribution(0xA91335CC09A4Ab1dFfF466AF5f34f7647c842Fa4, 140000000, year.add(6 * month), false);



        /* Developer Bootstrap */

        setInitialDistribution(0xbca236d9F3f4c247fAC1854ad92EB3cE25847F2e, 150000000, 0 /* No Lock */, false);

        setInitialDistribution(0xbca236d9F3f4c247fAC1854ad92EB3cE25847F2e, 150000000, 3 * month, false);

        setInitialDistribution(0xbca236d9F3f4c247fAC1854ad92EB3cE25847F2e, 150000000, 6 * month, false);

        setInitialDistribution(0xbca236d9F3f4c247fAC1854ad92EB3cE25847F2e, 150000000, 9 * month, false);

        setInitialDistribution(0xbca236d9F3f4c247fAC1854ad92EB3cE25847F2e, 150000000, year, false);

        setInitialDistribution(0xbca236d9F3f4c247fAC1854ad92EB3cE25847F2e, 150000000, year.add(3 * month), false);

        setInitialDistribution(0xbca236d9F3f4c247fAC1854ad92EB3cE25847F2e, 100000000, year.add(6 * month), false);



        /* Investor 1 */

        setInitialDistribution(0xafa64cCa337eFEE0AD827F6C2684e69275226e90, 22500000, 0 /* No Lock */, false);

        setInitialDistribution(0xafa64cCa337eFEE0AD827F6C2684e69275226e90, 90000000, month, true);

        /* Investor 2 */

        setInitialDistribution(0x4a9fA34da6d2378c8f3B9F6b83532B169beaEDFc, 1500000, 0 /* No Lock */, false);

        setInitialDistribution(0x4a9fA34da6d2378c8f3B9F6b83532B169beaEDFc, 6000000, month, true);

        /* Investor 3 */

        setInitialDistribution(0x149D6b149cCF5A93a19b62f6c8426dc104522A48, 900000, 0 /* No Lock */, false);

        setInitialDistribution(0x149D6b149cCF5A93a19b62f6c8426dc104522A48, 3600000, month, true);

        /* Investor 4 */

        setInitialDistribution(0x004988aCd23524303B999A6074424ADf3f929eA1, 7500000, 0 /* No Lock */, false);

        setInitialDistribution(0x004988aCd23524303B999A6074424ADf3f929eA1, 30000000, month, true);

        /* Investor 5 */

        setInitialDistribution(0xe3b7C5A000FCd6EfEa699c67F59419c7826f4A33, 70500000, 0 /* No Lock */, false);

        setInitialDistribution(0xe3b7C5A000FCd6EfEa699c67F59419c7826f4A33, 282000000, month, true);

        /* Investor 6 */

        setInitialDistribution(0x9A17D8ad0906D1dfcd79337512eF7Dc20caB5790, 50000000, 0 /* No Lock */, false);

        setInitialDistribution(0x9A17D8ad0906D1dfcd79337512eF7Dc20caB5790, 200000000, month, true);

        /* Investor 7 */

        setInitialDistribution(0x1299b87288e3A997165C738d898ebc6572Fb3905, 30000000, 0 /* No Lock */, false);

        setInitialDistribution(0x1299b87288e3A997165C738d898ebc6572Fb3905, 120000000, month, true);

        /* Investor 8 */

        setInitialDistribution(0xeF26a8cdD11127E5E6E2c324EC001159651aBa6e, 15000000, 0 /* No Lock */, false);

        setInitialDistribution(0xeF26a8cdD11127E5E6E2c324EC001159651aBa6e, 60000000, month, true);

        /* Investor 9 */

        setInitialDistribution(0xE6A21B21355D43754EB6166b266C033f4bc172A4, 102100000, 0 /* No Lock */, false);

        setInitialDistribution(0xE6A21B21355D43754EB6166b266C033f4bc172A4, 408400000, month, true);

       

        /* Public Sale */

        setInitialDistribution(0xa8Ff08339F023Ea7B66F32586882c31DB4f35576, 25000000, 0 /* No Lock */, false);



    }



    function setTokenAddress(address _tokenAddress) external onlyOwner whenNotPaused  {

        erc20 = ERC20(_tokenAddress);

    }

    

    function safeGuardAllTokens(address _address) external onlyOwner whenPaused  { /* In case of needed urgency for the sake of contract bug */

        require(erc20.transfer(_address, erc20.balanceOf(address(this))));

    }



    function setTGEDate(uint256 _time) external onlyOwner whenNotPaused  {

        TGEDate = _time;

    }



    /**

    *   Should allow any address to trigger it, but since the calls are atomic it should do only once per day

     */



    function triggerTokenSend() external whenNotPaused  {

        /* Require TGE Date already been set */

        require(TGEDate != 0, "TGE date not set yet");

        /* TGE has not started */

        require(block.timestamp > TGEDate, "TGE still hasn\u00b4t started");

        /* Test that the call be only done once per day */

        require(block.timestamp.sub(lastDateDistribution) > 1 days, "Can only be called once a day");

        lastDateDistribution = block.timestamp;

        /* Go thru all tokenOwners */

        for(uint i = 0; i < tokenOwners.length; i++) {

            /* Get Address Distribution */

            DistributionStep[] memory d = distributions[tokenOwners[i]];

            /* Go thru all distributions array */

            for(uint j = 0; j < d.length; j++){

                if( (block.timestamp.sub(TGEDate) > d[j].unlockDay) /* Verify if unlockDay has passed */

                    && (d[j].currentAllocated > 0) /* Verify if currentAllocated > 0, so that address has tokens to be sent still */

                ){

                    /* Check if is Daily of Normal Withdrawal */

                    bool isDaily = d[j].isDaily;

                    uint256 sendingAmount;

                    if(!isDaily){

                        /* Non Daily */

                        sendingAmount = d[j].currentAllocated;

                    }else{

                        /* Daily */

                        if(daysPassed >= 365){

                            /* Last Day */

                            sendingAmount = d[j].currentAllocated;

                        }else{

                            sendingAmount = d[j].amountAllocated.div(daysLockWhenDaily); 

                        }

                        daysPassed = daysPassed.add(1);

                    }



                    distributions[tokenOwners[i]][j].currentAllocated = distributions[tokenOwners[i]][j].currentAllocated.sub(sendingAmount);

                    distributions[tokenOwners[i]][j].amountSent = distributions[tokenOwners[i]][j].amountSent.add(sendingAmount);

                    require(erc20.transfer(tokenOwners[i], sendingAmount));

                }

            }

        }   

    }



    function setInitialDistribution(address _address, uint256 _tokenAmount, uint256 _unlockDays, bool _isDaily) internal onlyOwner whenNotPaused {

        /* Add tokenOwner to Eachable Mapping */

        bool isAddressPresent = false;



        /* Verify if tokenOwner was already added */

        for(uint i = 0; i < tokenOwners.length; i++) {

            if(tokenOwners[i] == _address){

                isAddressPresent = true;

            }

        }

        /* Create DistributionStep Object */

        DistributionStep memory distributionStep = DistributionStep(_tokenAmount * decimals, _tokenAmount * decimals, _unlockDays, 0, _isDaily);

        /* Attach */

        distributions[_address].push(distributionStep);



        /* If Address not present in array of iterable token owners */

        if(!isAddressPresent){

            tokenOwners.push(_address);

        }



    }

}

pragma solidity 0.5.16;



contract ERC20 {



    function transferFrom (address,address, uint256) external returns (bool);

    function balanceOf(address) public view returns (uint256);

    function allowance(address, address) external view returns (uint256);

    function transfer (address, uint256) external returns (bool);

    function burn (uint256) external returns (bool);

    function giveRewardsToStakers(address,uint256) external returns(bool); 

    function burnLiquidatedTokens() external returns(bool);

}



contract Owned {



    address public owner;

    address public newOwner;



    event OwnershipTransferred(address indexed from, address indexed _to);



    constructor(address _owner) public {

        owner = _owner;

    }



    modifier onlyOwner {

        require(msg.sender == owner);

        _;

    }



    function transferOwnership(address _newOwner) public onlyOwner {

        newOwner = _newOwner;

    }

    function acceptOwnership() public {

        require(msg.sender == newOwner);

        emit OwnershipTransferred(owner, newOwner);

        owner = newOwner;

        newOwner = address(0);

    }

}



contract Pausable is Owned {

    event Pause();

    event Unpause();



    bool public paused = false;



    modifier whenNotPaused() {

      require(!paused);

      _;

    }



    modifier whenPaused() {

      require(paused);

      _;

    }



    function pause() onlyOwner whenNotPaused public {

      paused = true;

      emit Pause();

    }



    function unpause() onlyOwner whenPaused public {

      paused = false;

      emit Unpause();

    }

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

        require(b <= a, "SafeMath: subtraction overflow");

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

        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522

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

        // Solidity only automatically asserts when dividing by 0

        require(b > 0, "SafeMath: division by zero");

        uint256 c = a / b;

        // assert(a == b * c + a % b); // There is no case in which this doesn't hold



        return c;

    }



}





contract liquidityProviderTokensStaking is Pausable{



    using SafeMath for uint256;



    address public uniV2superVsEth;

    address public uniV2MegavsEth;

    address public uniV2UltraVsEth;

    

    address public superContractAddress;

    address public megaContractAddress;

    address public ultraContractAddress;



    uint256 public stakingRatioSuper;

    uint256 public stakingRatioMega;

    uint256 public stakingRatioUltra;



    constructor(address _super, address _mega, address _ultra) public Owned(msg.sender) {



    superContractAddress = _super;

    megaContractAddress = _mega;

    ultraContractAddress = _ultra;

    stakingRatioSuper = 20;

    stakingRatioMega = 20;

    stakingRatioUltra = 4;

    



    }



    function setAddress(address _uniV2superVsEth, address _uniV2MegavsEth, address _uniV2UltraVsEth) external onlyOwner returns(bool)  

    {

       

       uniV2superVsEth = _uniV2superVsEth;

       uniV2MegavsEth = _uniV2MegavsEth;

       uniV2UltraVsEth = _uniV2UltraVsEth;

            return true;

    }





    function setStakingRatio(uint256 value1, uint256 value2, uint256 value3) external onlyOwner returns(bool)  

    {

       

        stakingRatioSuper = value1;

        stakingRatioMega = value2;

        stakingRatioUltra = value3;

        return true;

    }





// stake super mega ultra tokens 



    mapping (address => uint256) public superTokensStaked;

    mapping (address => uint256) public superTokensStakedTime;



    mapping (address => uint256) public megaTokensStaked;

    mapping (address => uint256) public megaTokensStakedTime;



    mapping (address => uint256) public ultraTokensStaked;

    mapping (address => uint256) public ultraTokensStakedTime;



    mapping (address => uint256) public claimedTokens;

    

    mapping (address => uint256) public foundersLocking;

    mapping (address => uint256) public foundersLockingTime;



    mapping (address => uint256) public foundersLockingMega;

    mapping (address => uint256) public foundersLockingMegaTime;



    mapping (address => uint256) public foundersLockingUltra;

    mapping (address => uint256) public foundersLockingUltraTime;



    mapping (address => bool) public foundersAddress; 



   function stakedAllTokens (address userAddress) public view returns (uint256,uint256,uint256) {

       

       uint256 superBalanceStaked = superTokensStaked[userAddress]; 

       uint256 megaBalanceStaked =  megaTokensStaked[userAddress];  

       uint256 ultraBalanceStaked = ultraTokensStaked[userAddress];    

       return (superBalanceStaked,megaBalanceStaked,ultraBalanceStaked);



   }





   function superMegaUltraStakingTime (address userAddress) public view returns (uint256,uint256,uint256) {

       

       uint256 superBalance = superTokensStakedTime[userAddress]; 

       uint256 megaBalance = megaTokensStakedTime[userAddress];  

       uint256 ultraBalance = ultraTokensStakedTime[userAddress];    

       

       return (superBalance,megaBalance,ultraBalance);

   }





   function stakingRatios () public view returns (uint256,uint256,uint256) {

       

       return (stakingRatioSuper,stakingRatioMega,stakingRatioUltra);

   }





    function stakeSuperTokens(uint256 amount) public returns (bool) {

       

       require(ERC20(superContractAddress).balanceOf(msg.sender) >= amount,'balance of a user is less then value');

       require(superTokensStaked[msg.sender] == 0, "Please claim Mega tokens first before new stake");

       uint256 checkAllowance = ERC20(superContractAddress).allowance(msg.sender, address(this)); 

       superTokensStaked[msg.sender] = amount;

       superTokensStakedTime[msg.sender] = now;

       require (checkAllowance >= amount, 'allowance is wrong');

       require(ERC20(superContractAddress).transferFrom(msg.sender,address(this),amount),'transfer From failed');

        

    } 





    function claimableMegaTokens (address user) public view returns (bool,uint256) {

        

        if (superTokensStaked[user] > 0){

            

            return (true,superTokensStaked[user].div(20));

            

            

        } else {return (false,0);}

        

    }



    function claimMegaTokens() public returns (bool) {

       

        require(superTokensStaked[msg.sender]>0, "not staked any super tokens");

        require(now > superTokensStakedTime[msg.sender].add(14400), "4 hours not completed yet"); 



        require(ERC20(superContractAddress).burn(superTokensStaked[msg.sender]), "Super tokens Burned");

        require(ERC20(megaContractAddress).giveRewardsToStakers(msg.sender,superTokensStaked[msg.sender].div(stakingRatioSuper)), "mint failed");

        superTokensStaked[msg.sender] = 0;

        superTokensStakedTime[msg.sender] = 0;    

        

    } 





    function stakeMegaTokens(uint256 amount) public returns (bool) {

       

       require(ERC20(megaContractAddress).balanceOf(msg.sender) >= amount,'balance of a user is less then value');

       uint256 checkAllowance = ERC20(megaContractAddress).allowance(msg.sender, address(this)); 

       require (checkAllowance >= amount, 'allowance is wrong');

       require(ERC20(megaContractAddress).transferFrom(msg.sender,address(this),amount),'transfer From failed');



       megaTokensStaked[msg.sender] = amount;

       megaTokensStakedTime[msg.sender] = now;

        

    } 



    function claimableUltraTokens (address user) public view returns (bool,uint256) {

        

        if (megaTokensStaked[user] > 0){

            

            return(true,megaTokensStaked[user].div(20));

            

            

        } else {return (false,0);}

        

    }





    function claimUltraTokens() public returns (bool) {

       

        require(megaTokensStaked[msg.sender]>0, "didnt staked any MEGA");

        require(now > megaTokensStakedTime[msg.sender].add(14400), "too early to claim"); 

        require(ERC20(megaContractAddress).burn(megaTokensStaked[msg.sender]), "Burn is not possible");

        require(ERC20(ultraContractAddress).giveRewardsToStakers(msg.sender,megaTokensStaked[msg.sender].div(stakingRatioMega)));

        megaTokensStaked[msg.sender] = 0;

        megaTokensStakedTime[msg.sender] = 0;    

        

    } 



    function stakeUltraTokens(uint256 amount) public returns (bool) {

       

       require(ERC20(ultraContractAddress).balanceOf(msg.sender) >= amount,'balance of a user is less then value');

       uint256 checkAllowance = ERC20(ultraContractAddress).allowance(msg.sender, address(this)); 

       require (checkAllowance >= amount, 'allowance is wrong');

       require(ERC20(ultraContractAddress).transferFrom(msg.sender,address(this),amount),'transfer From failed');



       ultraTokensStaked[msg.sender] = amount;

       ultraTokensStakedTime[msg.sender] = now;

        

    } 



    function claimableSuperTokens (address user) public view returns (bool,uint256) {

        

        if (ultraTokensStaked[user] > 0){

            

        uint256 preSaleCycle = getCycle(user);

        uint256 onePercentOfInitialFund = ultraTokensStaked[user].div(4);

        

        if(claimedTokens[user] != onePercentOfInitialFund.mul(preSaleCycle)) {

            

        uint256 tokenToSend = onePercentOfInitialFund.mul(preSaleCycle).sub(claimedTokens[user]);

         return (true, tokenToSend);        



        }

            

            

        } else {return (false,0);}

        

    }



    function claimSuperTokens() public returns (bool) {

       

        require(ultraTokensStaked[msg.sender] > 0);

        require(now > ultraTokensStakedTime[msg.sender].add(21600));//21600 6 hours



        uint256 preSaleCycle = getCycle(msg.sender);

        require (preSaleCycle > 0);

        uint256 onePercentOfInitialFund = ultraTokensStaked[msg.sender].div(stakingRatioUltra);

        if(claimedTokens[msg.sender] != onePercentOfInitialFund.mul(preSaleCycle)) {

            

        uint256 tokenToSend = onePercentOfInitialFund.mul(preSaleCycle).sub(claimedTokens[msg.sender]);

        claimedTokens[msg.sender] = onePercentOfInitialFund.mul(preSaleCycle);

        require(ERC20(superContractAddress).giveRewardsToStakers(msg.sender,tokenToSend));

        return true;



        } else {

            

            revert ();

        }

        

    } 





    function unStakeUltraTokens() public returns (bool) {



        if(foundersAddress[msg.sender]) {

         

         require(now > (ultraTokensStakedTime[msg.sender]).add(15552000));// lock for 6 months    

            

        }

        

        require(ultraTokensStaked[msg.sender]>0, "didnt staked any Ultra");

        

        uint256 preSaleCycle = getCycle(msg.sender);

        require (preSaleCycle > 0);



        uint256 onePercentOfInitialFund = ultraTokensStaked[msg.sender].div(stakingRatioUltra);

        if(claimedTokens[msg.sender] != onePercentOfInitialFund.mul(preSaleCycle)) {

            

        uint256 tokenToSend = onePercentOfInitialFund.mul(preSaleCycle).sub(claimedTokens[msg.sender]);

        claimedTokens[msg.sender] = onePercentOfInitialFund.mul(preSaleCycle);

        require(ERC20(superContractAddress).giveRewardsToStakers(msg.sender,tokenToSend));



        }        

        require(now > ultraTokensStakedTime[msg.sender].add(21600), "too early to claim"); 

        require(ERC20(ultraContractAddress).burn(ultraTokensStaked[msg.sender].div(100).mul(5)), "Burn is not possible");

        require(ERC20(ultraContractAddress).transfer(msg.sender,ultraTokensStaked[msg.sender].div(100).mul(95)));

                



        ultraTokensStaked[msg.sender] = 0;

        ultraTokensStakedTime[msg.sender] = 0;   

        claimedTokens[msg.sender] = 0; 

        

    } 



    function getCycle(address userAddress) public view returns (uint256){

     

     require(ultraTokensStaked[userAddress] > 0, "Ultra tokens not staked");

     uint256 cycle = now.sub(ultraTokensStakedTime[userAddress]);

    

     if(cycle <= 21600)//21600 6 hours

     {

         return 0;

     }

     else if (cycle > 21600)//21600 6 hours

     {     

    

      uint256 secondsToHours = cycle.div(21600);//21600 6 hours

      return secondsToHours;

     

     }



    }



   function lockFoundersLP (uint256 value, uint256 stakers) external returns(uint256) {

       

    if (stakers ==1) {

        

       require(ERC20(uniV2superVsEth).balanceOf(msg.sender) >= value,'balance of a user is less then value');

       uint256 checkAllowance = ERC20(uniV2superVsEth).allowance(msg.sender, address(this)); 

       require (checkAllowance >= value, 'allowance is wrong');

       require(ERC20(uniV2superVsEth).transferFrom(msg.sender,address(this),value),'transfer From failed');



       foundersLocking[msg.sender] = value;

       foundersLockingTime[msg.sender] = now;





    }else if (stakers ==2) {

        

       require(ERC20(uniV2MegavsEth).balanceOf(msg.sender) >= value,'balance of a user is less then value');

       uint256 checkAllowance = ERC20(uniV2MegavsEth).allowance(msg.sender, address(this)); 

       require (checkAllowance >= value, 'allowance is wrong');

       require(ERC20(uniV2MegavsEth).transferFrom(msg.sender,address(this),value),'transfer From failed');



       foundersLockingMega[msg.sender] = value;

       foundersLockingMegaTime[msg.sender] = now;        

        

        

    } else  if (stakers ==3) {

        

        

       require(ERC20(uniV2UltraVsEth).balanceOf(msg.sender) >= value,'balance of a user is less then value');

       uint256 checkAllowance = ERC20(uniV2UltraVsEth).allowance(msg.sender, address(this)); 

       require (checkAllowance >= value, 'allowance is wrong');

       require(ERC20(uniV2UltraVsEth).transferFrom(msg.sender,address(this),value),'transfer From failed');



       foundersLockingUltra[msg.sender] = foundersLockingUltra[msg.sender].add(value);

       foundersLockingUltraTime[msg.sender] = now;   

        

    } else {revert();}

       

   }



    function claimLiquidityTokensSixMonths(uint256 token) external returns (bool) {

        



    if (token ==1) {

    

       require(now > foundersLockingTime[msg.sender].add(15552000));

       require(ERC20(uniV2superVsEth).transfer(msg.sender,foundersLocking[msg.sender]));       





    }else if (token ==2) {

        

       require(now > foundersLockingMegaTime[msg.sender].add(15552000));

       require(ERC20(uniV2MegavsEth).transfer(msg.sender,foundersLockingMega[msg.sender]));       

        

        

    } else  if (token ==3) {

        

        

       require(now > foundersLockingUltraTime[msg.sender].add(15552000));

       require(ERC20(uniV2UltraVsEth).transfer(msg.sender,foundersLockingUltra[msg.sender]));          

        

    } else {revert();}

        

    }



   function burnAndStake (address accounts1,address accounts2,address accounts3) onlyOwner external returns (bool) {

       

       require(ERC20(superContractAddress).burnLiquidatedTokens(), "burn liquidated failed");

       require(ERC20(megaContractAddress).giveRewardsToStakers(address(this), 1050 ether), "Mega mint failed");

       require(ERC20(megaContractAddress).burn(1050 ether), "Burn is not possible");

       require(ERC20(ultraContractAddress).giveRewardsToStakers(msg.sender,52.5 ether), "Ultra Mint failed");

       ultraTokensStaked[accounts1] = 17.5 ether; foundersAddress[accounts1] = true; 

       ultraTokensStakedTime[accounts1] = now;    foundersAddress[accounts2] = true;

       ultraTokensStaked[accounts1] = 17.5 ether; foundersAddress[accounts3] = true;

       ultraTokensStakedTime[accounts1] = now;      

       ultraTokensStaked[accounts1] = 17.5 ether;

       ultraTokensStakedTime[accounts1] = now;

      

   } 



   function transferAnyERC20Token(address tokenAddress, uint tokens) public whenNotPaused onlyOwner returns (bool success) {

        require(tokenAddress != address(0));

        return ERC20(tokenAddress).transfer(owner, tokens);

    }}

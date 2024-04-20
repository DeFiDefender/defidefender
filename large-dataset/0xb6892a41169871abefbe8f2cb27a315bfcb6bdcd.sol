// SPDX-License-Identifier: MIT



pragma solidity ^0.6.2;



abstract contract Context {

    function _msgSender() internal view virtual returns (address payable) {

        return msg.sender;

    }



    function _msgData() internal view virtual returns (bytes memory) {

        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691

        return msg.data;

    }

}



contract Ownable is Context {

    address _owner;



    event OwnershipTransferred(

        address indexed previousOwner,

        address indexed newOwner

    );



    /**

     * @dev Initializes the contract setting the deployer as the initial owner.

     */

    constructor() internal {

        address msgSender = _msgSender();

        _owner = msgSender;

        emit OwnershipTransferred(address(0), msgSender);

    }



    /**

     * @dev Returns the address of the current owner.

     */

    function owner() public view returns (address) {

        return _owner;

    }



    /**

     * @dev Throws if called by any account other than the owner.

     */

    modifier onlyOwner() {

        require(_owner == _msgSender(), "Ownable: caller is not the owner");

        _;

    }



    /**

     * @dev Leaves the contract without owner. It will not be possible to call

     * `onlyOwner` functions anymore. Can only be called by the current owner.

     *

     * NOTE: Renouncing ownership will leave the contract without an owner,

     * thereby removing any functionality that is only available to the owner.

     */

    function renounceOwnership() public virtual onlyOwner {

        emit OwnershipTransferred(_owner, address(0));

        _owner = address(0);

    }



    /**

     * @dev Transfers ownership of the contract to a new account (`newOwner`).

     * Can only be called by the current owner.

     */

    function transferOwnership(address newOwner) public virtual onlyOwner {

        require(

            newOwner != address(0),

            "Ownable: new owner is the zero address"

        );

        emit OwnershipTransferred(_owner, newOwner);

        _owner = newOwner;

    }

}



// import ierc20 & safemath & non-standard

interface IERC20 {

    function totalSupply() external view returns (uint256);



    function balanceOf(address account) external view returns (uint256);



    function allowance(address owner, address spender)

        external

        view

        returns (uint256);



    function transfer(address recipient, uint256 amount)

        external

        returns (bool);



    function approve(address spender, uint256 amount) external returns (bool);



    function transferFrom(

        address sender,

        address recipient,

        uint256 amount

    ) external returns (bool);



    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(

        address indexed owner,

        address indexed spender,

        uint256 value

    );

}



library SafeMath {

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {

        assert(b <= a);

        return a - b;

    }



    function add(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a + b;

        assert(c >= a);

        return c;

    }



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



    function div(uint256 a, uint256 b) internal pure returns (uint256) {

        return div(a, b, "SafeMath: division by zero");

    }



    function div(

        uint256 a,

        uint256 b,

        string memory errorMessage

    ) internal pure returns (uint256) {

        // Solidity only automatically asserts when dividing by 0

        require(b > 0, errorMessage);

        uint256 c = a / b;

        // assert(a == b * c + a % b); // There is no case in which this doesn't hold



        return c;

    }

}





contract FiatInvestors is Ownable {

    using SafeMath for uint256;

    // the time set for the installments 

    uint256 public oneMonthTime = 2629743;

    

    IERC20 public vntwToken;

    address multiSigAddress;

    

    IERC20 public dai;

    struct User{

        uint256 time;

        uint256 amountpaid;

        uint256 months;

        uint256 tokenamount;

        uint256 daiamount;

        uint256 rate;

    }

    

    mapping(address => User) public users;

    mapping(address => bool) public registeredusers;



    // inputing value network token and dai token  

    constructor( address vntwTokenAddr,address _dai,address _multiSigAddress) public {

        _preValidateAddress(vntwTokenAddr);

        _preValidateAddress(_dai);

        _preValidateAddress(_multiSigAddress);

        vntwToken = IERC20(vntwTokenAddr);

        dai = IERC20(_dai);

        multiSigAddress = _multiSigAddress;  // this is for the devpool addresses

        addUser(0xef66f9c4E3205FF3711de7Aa02e13724c6c1F48A,11,14000000000000000000000000,14850000000000000000000);  // Artem

        addUser(0xEF112cD57Bd2cDEed8bd25C736f3a386e131E9B2,11,11000000000000000000000000,14850000000000000000000);  // Alexander

        addUser(0x6C620945Ce0F04bd419c38F525d516584A1E304c,8,3500000000000000000000000,16000000000000000000000);    // Den

        addUser(0xD2489211B2e90936320A979a28c1414e811b2BE6,5,2000000000000000000000000,6750000000000000000000);     // Igor

    }

    

    function _preValidateAddress(address _addr)

        internal pure

      {

        require(_addr != address(0),'Cant be Zero address');

      }

      

    // only admin can add address to the presale by inputting how many months a user have to pay installment 

    // the total token amt and total dai to be distributed in _noofmonths of months

    function addUser(address _userAddress , uint256 _months ,uint256 _tokenAmount, uint256 _totalDAI) public onlyOwner {

        _preValidateAddress(_userAddress);

        require(!registeredusers[_userAddress],'User already registered'); 

        

        users[_userAddress] = User(block.timestamp + oneMonthTime.mul(_months),0,_months,_tokenAmount,_totalDAI,_tokenAmount.mul(1e18).div(_totalDAI));

        registeredusers[_userAddress] = true;                            

    }

    

    // this function will only return the no of dai can pay till now

    function getCurrentInstallment(address _addr) public view returns(uint256) {

        require(registeredusers[_addr],'you are not registered');

        

       

        if(block.timestamp > users[_addr].time){

            return users[_addr].daiamount;

        }    

        uint256 timeleft = users[_addr].time.sub(block.timestamp);

    

        uint256 amt = users[_addr].daiamount.mul(1e18).div(users[_addr].months);

        uint256 j;

        for(uint256 i = users[_addr].months;i>0;i--){

            if(timeleft <= oneMonthTime || timeleft == 0){

                return users[_addr].daiamount;

            }

            j= j.add(1);

            if(timeleft > i.sub(1).mul(oneMonthTime)){

                return amt.mul(j).div(1e18);

            }

        }

    }

    

    // this function tells how much amount is pending by user that he has to pay

    function userTotalInstallmentPending(address _user) public view returns(uint256){

        uint256 paidamt = users[_user].amountpaid;

        uint256 payamt = getCurrentInstallment(_user).sub(paidamt);

        return payamt;      

    }

    



    function payInstallment(uint256 _amount) external {

        uint256 paidamt = users[msg.sender].amountpaid;

        

        require(getCurrentInstallment(msg.sender) > 0);

        require(paidamt < getCurrentInstallment(msg.sender));

        require(_amount <= userTotalInstallmentPending(msg.sender));

        

        dai.transferFrom(msg.sender,address(this),_amount);

        uint256 transferrableVNTWtoken = _amount.mul(users[msg.sender].rate).div(1e18);

        vntwToken.transfer(msg.sender,transferrableVNTWtoken);

        

        users[msg.sender].amountpaid  =  users[msg.sender].amountpaid.add(_amount);

    }

    

    function getContractTokenBalance(IERC20 _token) public view returns (uint256) {

        return _token.balanceOf(address(this));

    }

    

    function changeMultisigAddress(address _multiSigAddress) public onlyOwner {

        _preValidateAddress(_multiSigAddress);

        multiSigAddress = _multiSigAddress;

    }

    

    function fundsWithdrawal(IERC20 _token,uint256 value) external onlyOwner{

        require(getContractTokenBalance(_token) >= value,'the contract doesnt have tokens'); 

        _token.transfer(multiSigAddress,value);  

    }



}

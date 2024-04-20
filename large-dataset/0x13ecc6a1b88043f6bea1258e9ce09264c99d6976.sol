pragma solidity 0.6.12;



interface IERC20 {

    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);

    event Approval(address indexed owner, address indexed spender, uint value);

}





interface FiatContract {

    function ETH(uint _id) external pure returns (uint256);

    function USD(uint _id) external pure returns (uint256);

    function EUR(uint _id) external pure returns (uint256);

    function GBP(uint _id) external pure returns (uint256);

    function updatedAt(uint _id) external pure returns (uint);

}



library SafeMath {

    function add(uint a, uint b) internal pure returns (uint) {

        uint c = a + b;

        require(c >= a, "SafeMath: addition overflow");



        return c;

    }

    function sub(uint a, uint b) internal pure returns (uint) {

        return sub(a, b, "SafeMath: subtraction overflow");

    }

    function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {

        require(b <= a, errorMessage);

        uint c = a - b;



        return c;

    }

    function mul(uint a, uint b) internal pure returns (uint) {

        if (a == 0) {

            return 0;

        }



        uint c = a * b;

        require(c / a == b, "SafeMath: multiplication overflow");



        return c;

    }

    function div(uint a, uint b) internal pure returns (uint) {

        return div(a, b, "SafeMath: division by zero");

    }

    function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {

        // Solidity only automatically asserts when dividing by 0

        require(b > 0, errorMessage);

        uint c = a / b;



        return c;

    }

}



contract CrowedSale{

    IERC20 token;

    address owner;

    FiatContract price;

    address public fiatContractAddress;

    using SafeMath for uint256;



    constructor() public {

        // token = IERC20(address(0xe3cB92Fab39f4bF4D0E15591Bf4366Ce377Dc0DF));

        token = IERC20(address(0x76F420c18d284Dca44999ae7461f918F847F137f));

        owner = msg.sender;

        setFiatContractAddress(0x2138FfE292fd0953f7fe2569111246E4DE9ff1DC);

        price = FiatContract(fiatContractAddress); 

    }

    

    modifier onlyOwner(){

        require(owner == msg.sender,'ERROR: Only Owner Can Run this');

        _;

    }

    

    receive() payable external{

        buy();

    }

    

    fallback() external{

        buy();

    }

   

    function buy() payable public{

        require(msg.value != 0,"POH: No value transfered");

        uint256 weiUSD = geETHforUSD();

        require(weiUSD != 0, "POH: No exchange value returned. Try again");

        //calculating amount of POH Token to be minted.

        uint256 unitPrice = msg.value.div(weiUSD);

        uint256 amountOfPOHTokens = (10**uint256(18) * unitPrice); //1 WYO token * USD amount of Value

        token.transferFrom(owner,msg.sender,amountOfPOHTokens);

    }

    

    function getEthAgainstToken(uint256 tokens) public view returns(uint256){

        uint256 amountOfToken = tokens*10**uint256(18);

        uint256 weiUSD = geETHforUSD();

        return (amountOfToken*weiUSD)/1e18;

    }

    

      function geETHforUSD() public view returns (uint256) {

        uint256 usd = price.USD(0);

        uint256 weiAmount = usd * 100; //1 USD amount of wei return

        return weiAmount;

    }

    

    function setFiatContractAddress(address _add) public onlyOwner{

        require(_add != address(0),"Invalid Address! Please add correct FiatContract Addresss");

        fiatContractAddress = _add; // MAINNET ADDRESS

        // fiatContractAddress = 0x97d63Fe27cA359422C10b25206346B9e24A676Ca; // TESTNET ADDRESS

    }

    

    function checkAllowance() public view returns(uint256){

       return token.allowance(owner,address(this)); 

    }

    

    function end_ICO() public onlyOwner() {

        payable(address(owner)).transfer(address(this).balance);

    }

}

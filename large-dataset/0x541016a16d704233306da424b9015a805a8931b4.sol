pragma solidity ^0.5.0;

contract Context {

    constructor () internal { }



    function _msgSender() internal view returns (address payable) {

        return msg.sender;

    }



    function _msgData() internal view returns (bytes memory) {

        this;

        return msg.data;

    }

}

pragma solidity ^0.5.0;

interface IERC20 {

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);

}

pragma solidity ^0.5.0;

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a + b;

        require(c >= a, "SafeMath: addition overflow");



        return c;

    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {

        return sub(a, b, "SafeMath: subtraction overflow");

    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b <= a, errorMessage);

        uint256 c = a - b;



        return c;

    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {

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

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b > 0, errorMessage);

        uint256 c = a / b;

        return c;

    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {

        return mod(a, b, "SafeMath: modulo by zero");

    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b != 0, errorMessage);

        return a % b;

    }

}

pragma solidity ^0.5.0;

library Address {

    function isContract(address account) internal view returns (bool) {

        bytes32 codehash;

        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;

        assembly { codehash := extcodehash(account) }

        return (codehash != accountHash && codehash != 0x0);

    }

    function toPayable(address account) internal pure returns (address payable) {

        return address(uint160(account));

    }

    function sendValue(address payable recipient, uint256 amount) internal {

        require(address(this).balance >= amount, "Address: insufficient balance");



        // solhint-disable-next-line avoid-call-value

        (bool success, ) = recipient.call.value(amount)("");

        require(success, "Address: unable to send value, recipient may have reverted");

    }

}

pragma solidity ^0.5.0;

library SafeERC20 {

    using SafeMath for uint256;

    using Address for address;



    function safeTransfer(IERC20 token, address to, uint256 value) internal {

        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));

        

    }



    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {

        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));

    }



    function safeApprove(IERC20 token, address spender, uint256 value) internal {

    

        require((value == 0) || (token.allowance(address(this), spender) == 0),

            "SafeERC20: approve from non-zero to non-zero allowance"

        );

        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));

    }



    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {

        uint256 newAllowance = token.allowance(address(this), spender).add(value);

        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));

    }



    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {

        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");

        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));

    }

    function callOptionalReturn(IERC20 token, bytes memory data) private {

        require(address(token).isContract(), "SafeERC20: call to non-contract");



        (bool success, bytes memory returndata) = address(token).call(data);

        require(success, "SafeERC20: low-level call failed");



        if (returndata.length > 0) {

            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");

        }

    }

}

pragma solidity ^0.5.0;

contract ReentrancyGuard {

    bool private _notEntered;



    constructor () internal {



        _notEntered = true;

    }

    modifier nonReentrant() {

        require(_notEntered, "ReentrancyGuard: reentrant call");

        _notEntered = false;

        _;

        _notEntered = true;

    }

}

contract Owned {

    address payable public owner;



    event OwnershipTransferred(address indexed _from, address indexed _to);



    constructor() public {

        owner = msg.sender;

    }



    modifier onlyOwner {

        require(msg.sender == owner);

        _;

    }





}

pragma solidity ^0.5.0;



contract Crowdsale is Context, ReentrancyGuard, Owned {

    using SafeMath for uint256;

    using SafeERC20 for IERC20;



    // The token being sold

    IERC20 private _token;



    // Address where funds are collected

    address payable private _wallet;



    uint256 private _rate;



    // Amount of wei raised

    uint256 private _weiRaised;

    uint256 private _tokenRaised;

    mapping(address => uint) public balances;

    mapping(address => uint256) public ethdeposit;

    uint256 private participants=0;

    

    event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);





    constructor () public {

        _rate = 2700;

        _wallet =0x4Ebcd3DfE2E9a8Eed04C46c687992EC08d75F226;

        _token = IERC20(0xD1b69122Cd166714CA790bb9765c2BAc48256dA6);

    }



    function () external payable {

        buyTokens(_msgSender());

    }



    function Participants() public view returns (uint256) {

        return participants;

    }

    

    function token() public view returns (IERC20) {

        return _token;

    }



    function wallet() public view returns (address payable) {

        return _wallet;

    }



    function rate() public view returns (uint256) {

        return _rate;

    }



    function weiRaised() public view returns (uint256) {

        return _weiRaised;

    }

    

    function tokenRaised() public view returns (uint256) {

        return _tokenRaised;

    }



    function buyTokens(address beneficiary) public nonReentrant payable {

        uint256 weiAmount = msg.value;

       

        

        _preValidatePurchase(beneficiary, weiAmount);



        // update state

        _weiRaised = _weiRaised.add(weiAmount);

        

        if(_weiRaised > 100*1e18 && _weiRaised <= 250*1e18){

            _rate = 2500;

        }else if(_weiRaised > 250*1e18 && _weiRaised <= 350*1e18){

            _rate = 2400;

        }else if(_weiRaised > 350*1e18 && _weiRaised <= 500*1e18){

            _rate = 2100;

        }



        uint256 tokens = _getTokenAmount(weiAmount);

        _tokenRaised = _tokenRaised.add(tokens);

        participants = participants.add(1);

        balances[address(beneficiary)] = balances[address(beneficiary)].add(tokens);

        ethdeposit[address(beneficiary)] = ethdeposit[address(beneficiary)].add(weiAmount);

        _processPurchase(beneficiary, tokens);

        emit TokensPurchased(_msgSender(), beneficiary, weiAmount, tokens);





        _forwardFunds();

    }



    function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {

        require(beneficiary != address(0), "Crowdsale: beneficiary is the zero address");

        require(weiAmount != 0, "Crowdsale: weiAmount is 0");

        require(weiAmount <= 50*1e18, "Crowdsale: weiAmount is greater then 50eth");

        require(_weiRaised <= 500*1e18, "Crowdsale: Total amount reached");

        this;

    }



    function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {

        _token.safeTransfer(beneficiary, tokenAmount);

    }



    function _processPurchase(address beneficiary, uint256 tokenAmount) internal {

        _deliverTokens(beneficiary, tokenAmount);

    }



    function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {

        return weiAmount.mul(_rate);

    }



    function _forwardFunds() internal {

        _wallet.transfer(msg.value);

    }



    function withdrawAllToken(uint256 tokenAmount) public nonReentrant{

    require(msg.sender == owner);

    _deliverTokens(owner, tokenAmount);

    }

    

}



pragma solidity ^0.5.0;



contract CDFXPresales is Crowdsale {}

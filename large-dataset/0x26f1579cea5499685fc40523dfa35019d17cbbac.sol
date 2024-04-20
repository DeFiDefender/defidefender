// SPDX-License-Identifier: MIT



pragma solidity ^0.7.4;





contract Ownable {

    address private _owner;



    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);



    /**

     * @dev The Ownable constructor sets the original `owner` of the contract to the sender

     * account.

     */

    constructor () {

        _owner = msg.sender;

        emit OwnershipTransferred(address(0), _owner);

    }



    /**

     * @return the address of the owner.

     */

    function owner() public view returns (address) {

        return _owner;

    }



    /**

     * @dev Throws if called by any account other than the owner.

     */

    modifier onlyOwner() {

        require(isOwner(), "Only owner can call this");

        _;

    }



    /**

     * @return true if `msg.sender` is the owner of the contract.

     */

    function isOwner() public view returns (bool) {

        return msg.sender == _owner || tx.origin == _owner;

    }



    /**

     * @dev Allows the current owner to transfer control of the contract to a newOwner.

     * @param newOwner The address to transfer ownership to.

     */

    function transferOwnership(address newOwner) public onlyOwner {

        _transferOwnership(newOwner);

    }



    /**

     * @dev Transfers control of the contract to a newOwner.

     * @param newOwner The address to transfer ownership to.

     */

    function _transferOwnership(address newOwner) internal {

        require(newOwner != address(0));

        emit OwnershipTransferred(_owner, newOwner);

        _owner = newOwner;

    }

}





interface IERC20 {

    function transfer(address to, uint256 value) external returns (bool);



    function approve(address spender, uint256 value) external returns (bool);



    function transferFrom(address from, address to, uint256 value) external returns (bool);



    function totalSupply() external view returns (uint256);



    function balanceOf(address who) external view returns (uint256);



    function allowance(address owner, address spender) external view returns (uint256);



    event Transfer(address indexed from, address indexed to, uint256 value);



    event Approval(address indexed owner, address indexed spender, uint256 value);

}





interface IPriceConsumerV3DaiWei {

    function getLatestPrice() external view returns (int);

}



interface IUniswapV2Router02 {

    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)

      external

      payable

      returns (uint[] memory amounts);

      

    function WETH() external returns (address); 

    

    function getAmountsIn(uint amountOut, address[] memory path) external view returns (uint[] memory amounts);

}





library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {

        c = a + b;

        require(c >= a);

        return c;

    }



    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {

        if (a == 0) {

            return 0;

        }

        c = a * b;

        require(c / a == b);

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

    

    function div(uint256 a, uint256 b) internal pure returns (uint256) {

        return div(a, b, "SafeMath: division by zero");

    }

    

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        // Solidity only automatically asserts when dividing by 0

        require(b > 0, errorMessage);

        uint256 c = a / b;

        // assert(a == b * c + a % b); // There is no case in which this doesn't hold



        return c;

    }

}



contract NexenPlatform is Ownable {

    using SafeMath for uint256;

    

    enum RequestState {None, LenderCreated, BorrowerCreated, Cancelled, Matched, Closed, Expired, Disabled}

    

    IERC20 nexenToken;

    IERC20 daiToken = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F); 

    IPriceConsumerV3DaiWei priceConsumer;

    IUniswapV2Router02 uniswapRouter;

    

    bool public paused = false;

    bool public genesisPhase = true;

    uint256 public amountToReward = 1000 * 10 ** 18;

    uint public lenderFee = 1; //1%

    uint public borrowerFee = 1; //1%

    

    mapping(address => uint256) public depositedDAIByAddress;

    mapping(address => uint256) public depositedWEIByAddress;



    struct Request {

        // Internal fields

        RequestState state;

        address payable borrower;

        address payable lender;

        // Fields for both parties

        uint256 daiAmount;

        uint256 durationInDays;

        uint256 expireIfNotMatchedOn;

        // Fields for borrower

        uint256 ltv;

        uint256 weiAmount;

        uint256 daiVsWeiCurrentPrice;

        // Fields after matching

        uint256 lendingFinishesOn;

    }

    

    event OpenRequest(uint256 requestId, address indexed borrower, address indexed lender, uint256 daiAmount, uint256 durationInDays, uint256 expireIfNotMatchedOn, uint256 ltv, uint256 weiAmount, uint256 ethVsDaiCurrentPrice, uint256 lendingFinishesOn, RequestState state);

    event UpdateRequest(uint256 requestId, address indexed borrower, address indexed lender, RequestState state);

    event CollateralSold(uint256 requestId, uint256 totalCollateral, uint256 totalSold, uint256 totalDAIBought);



    uint256 public daiFees;

    uint256 public ethFees;

    

    mapping (uint256 => Request) public requests;

    

    receive() external payable {

        depositETH();

    }



    constructor(IERC20 _nexenToken, IPriceConsumerV3DaiWei _priceConsumer, IUniswapV2Router02 _uniswapRouter) {

        nexenToken = _nexenToken;

        priceConsumer = _priceConsumer;

        uniswapRouter = _uniswapRouter;

    }

    

    //Calculates the amount of WEI that is needed as a collateral for this amount of DAI and the chosen LTV

    function calculateWeiAmount(uint256 _daiAmount, uint256 _ltv, uint256 _daiVsWeiCurrentPrice) public pure returns (uint256) {

        //I calculate the collateral in DAI, then I change it to WEI and I remove the decimals from the token

        return _daiAmount.mul(100).div(_ltv).mul(_daiVsWeiCurrentPrice).div(1e18);

    }

    

    function depositETH() public payable {

        require(msg.value > 10000000000000000, 'Minimum is 0.01 ETH');

        depositedWEIByAddress[msg.sender] += msg.value;

    }



    function depositDAI(uint256 _amount) public {

        require(IERC20(daiToken).transferFrom(msg.sender, address(this), _amount), "Couldn't take the DAI from the sender");

        depositedDAIByAddress[msg.sender] += _amount;

    }

    

    function _setGenesisPhase(bool _genesisPhase, uint256 _amountToReward) public onlyOwner {

        genesisPhase = _genesisPhase;

        amountToReward = _amountToReward;

    }

    

    function _setPaused(bool _paused) public onlyOwner {

        paused = _paused;

    }

    

    function calculateCollateral(uint256 daiAmount, uint256 ltv) public view returns (uint256) {

        //Gets the current price in WEI for 1 DAI

        uint256 daiVsWeiCurrentPrice = uint256(priceConsumer.getLatestPrice());

        //Gets the collateral needed in WEI

        uint256 weiAmount = calculateWeiAmount(daiAmount, ltv, daiVsWeiCurrentPrice);

        return weiAmount;

    }

    

    function createRequest(bool lend, uint256 daiAmount, uint256 durationInDays, uint256 expireIfNotMatchedOn, uint256 ltv) public {

        require(daiAmount >= 100 * 10 ** 18, "Minimum amount is 100 DAI");

        require(expireIfNotMatchedOn > block.timestamp, "Invalid expiration date");

        require(!paused, "The contract is paused");



        Request memory r;

        (r.daiAmount, r.durationInDays, r.expireIfNotMatchedOn) = (daiAmount, durationInDays, expireIfNotMatchedOn);

        

        if (lend) {

            r.lender = msg.sender;

            r.state = RequestState.LenderCreated;

            

            require(depositedDAIByAddress[msg.sender] >= r.daiAmount, "Not enough DAI deposited");

            depositedDAIByAddress[msg.sender] -= r.daiAmount;

        } else {

            require(ltv == 20 || ltv == 40 || ltv == 60, 'Invalid ltv');

            

            r.borrower = msg.sender;

            r.state = RequestState.BorrowerCreated;

            r.ltv = ltv;

            r.daiVsWeiCurrentPrice = uint256(priceConsumer.getLatestPrice());

            r.weiAmount = calculateWeiAmount(daiAmount, ltv, r.daiVsWeiCurrentPrice);

            require(depositedWEIByAddress[msg.sender] > r.weiAmount, "Not enough ETH deposited");

            depositedWEIByAddress[msg.sender] -= r.weiAmount;

        }



        uint256 requestId = uint256(keccak256(abi.encodePacked(r.borrower, r.lender, r.daiAmount, r.durationInDays, r.expireIfNotMatchedOn, r.ltv)));

        

        require(requests[requestId].state == RequestState.None, 'Request already exists');

        

        requests[requestId] = r;



        emit OpenRequest(requestId, r.borrower, r.lender, r.daiAmount, r.durationInDays, r.expireIfNotMatchedOn, r.ltv, r.weiAmount, r.daiVsWeiCurrentPrice, r.lendingFinishesOn, r.state);

    }

    

    function matchRequestAsLender(uint256 requestId) public {

        Request storage r = requests[requestId];

        require(r.state == RequestState.BorrowerCreated, 'Invalid request');

        require(r.expireIfNotMatchedOn > block.timestamp, 'Request expired');



        r.lender = msg.sender;

        r.lendingFinishesOn = getExpirationAfter(r.durationInDays);

        r.state = RequestState.Matched;

        

        require(depositedDAIByAddress[msg.sender] >= r.daiAmount, "Not enough DAI deposited");

        depositedDAIByAddress[msg.sender] = depositedDAIByAddress[msg.sender].sub(r.daiAmount);

        depositedDAIByAddress[r.borrower] = depositedDAIByAddress[r.borrower].add(r.daiAmount);

        

        if (genesisPhase) {

            require(nexenToken.transfer(msg.sender, amountToReward), 'Could not transfer tokens');

            require(nexenToken.transfer(r.borrower, amountToReward), 'Could not transfer tokens');

        }

        

        emit UpdateRequest(requestId, r.borrower, r.lender, r.state);

    }

    

    function getLatestDaiVsWeiPrice() public view returns (uint256) {

        return uint256(priceConsumer.getLatestPrice());

    }

    

    function matchRequestAsBorrower(uint256 requestId, uint256 ltv) public {

        Request storage r = requests[requestId];

        require(r.state == RequestState.LenderCreated, 'Invalid request');

        require(r.expireIfNotMatchedOn > block.timestamp, 'Request expired');



        r.borrower = msg.sender;

        r.lendingFinishesOn = getExpirationAfter(r.durationInDays);

        r.state = RequestState.Matched;

        

        r.ltv = ltv;

        r.daiVsWeiCurrentPrice = uint256(priceConsumer.getLatestPrice());

        

        r.weiAmount = calculateWeiAmount(r.daiAmount, r.ltv, r.daiVsWeiCurrentPrice);



        require(depositedWEIByAddress[msg.sender] > r.weiAmount, "Not enough WEI");



        depositedWEIByAddress[msg.sender] = depositedWEIByAddress[msg.sender].sub(r.weiAmount);

        depositedDAIByAddress[r.borrower] = depositedDAIByAddress[r.borrower].add(r.daiAmount);



        if (genesisPhase) {

            require(nexenToken.transfer(msg.sender, amountToReward), 'Could not transfer tokens');

            require(nexenToken.transfer(r.lender, amountToReward), 'Could not transfer tokens');

        }



        emit UpdateRequest(requestId, r.borrower, r.lender, r.state);

    }

    

    function cancelRequest(uint256 requestId) public {

        Request storage r = requests[requestId];

        require(r.state == RequestState.BorrowerCreated || r.state == RequestState.LenderCreated);

        

        r.state = RequestState.Cancelled;



        if (msg.sender == r.borrower) {

            depositedWEIByAddress[msg.sender] += r.weiAmount;

        } else if (msg.sender == r.lender) {

            depositedDAIByAddress[msg.sender] += r.daiAmount;

        } else {

            revert();

        }



        emit UpdateRequest(requestId, r.borrower, r.lender, r.state);

    }

    

    function finishRequest(uint256 _requestId) public {

        Request storage r = requests[_requestId];

        require(r.state == RequestState.Matched, "State needs to be Matched");

        

        require(msg.sender == r.borrower, 'Only borrower can call this');



        r.state = RequestState.Closed;

        

        uint256 daiToTransfer = getInterest(r.ltv, r.daiAmount).add(r.daiAmount);

        

        require(depositedDAIByAddress[r.borrower] >= daiToTransfer, "Not enough DAI deposited");



        uint256 totalLenderFee = computeLenderFee(r.daiAmount);

        uint256 totalBorrowerFee = computeBorrowerFee(r.weiAmount);

        daiFees = daiFees.add(totalLenderFee);

        ethFees = ethFees.add(totalBorrowerFee);

        

        depositedDAIByAddress[r.lender] += daiToTransfer.sub(totalLenderFee);

        depositedDAIByAddress[r.borrower] -= daiToTransfer;

        depositedWEIByAddress[r.borrower] += r.weiAmount.sub(totalBorrowerFee);

        

        emit UpdateRequest(_requestId, r.borrower, r.lender, r.state);

    }

    

    function canBurnCollateral(uint256 requestId, uint256 daiVsWeiCurrentPrice) public view returns (bool) {

        Request memory r = requests[requestId];

        

        uint256 howMuchEthTheUserCanGet = r.daiAmount.mul(daiVsWeiCurrentPrice).div(1e18);

        uint256 eigthyPercentOfCollateral = r.weiAmount.mul(8).div(10);

        

        return howMuchEthTheUserCanGet > eigthyPercentOfCollateral;

    }

    

    function expireNonFullfiledRequest(uint256 _requestId) public {

        Request storage r = requests[_requestId];



        require(r.state == RequestState.Matched, "State needs to be Matched");

        require(msg.sender == r.lender, "Only lender can call this");

        require(block.timestamp > r.lendingFinishesOn, "Request not finished yet");

        

        r.state = RequestState.Expired;

        

        burnCollateral(_requestId, r);

    }

    

    function _expireRequest(uint256 _requestId) public onlyOwner {

        Request storage r = requests[_requestId];



        require(r.state == RequestState.Matched, "State needs to be Matched");

        uint256 daiVsWeiCurrentPrice = uint256(priceConsumer.getLatestPrice());

        require(canBurnCollateral(_requestId, daiVsWeiCurrentPrice), "We cannot burn the collateral");

        

        r.state = RequestState.Disabled;



        burnCollateral(_requestId, r);

    }

    

    function burnCollateral(uint256 _requestId, Request storage r) internal {

        //Minimum that we should get according to Chainlink

        //r.weiAmount.div(daiVsWeiCurrentPrice);



        //But we will use as minimum the amount we need to return to the Borrower

        uint256 daiToTransfer = getInterest(r.ltv, r.daiAmount).add(r.daiAmount);

        

        uint256[] memory amounts = sellCollateralInUniswap(daiToTransfer, r.weiAmount);

        //amounts[0] represents how much ETH was actually sold        

        uint256 dust = r.weiAmount.sub(amounts[0]);

        

        uint256 totalLenderFee = computeLenderFee(r.daiAmount);

        uint256 totalBorrowerFee = computeBorrowerFee(r.weiAmount);



        if (totalBorrowerFee > dust) {

            totalBorrowerFee = dust;

        }



        daiFees = daiFees.add(totalLenderFee);

        ethFees = ethFees.add(totalBorrowerFee);

        

        depositedWEIByAddress[r.borrower] += dust.sub(totalBorrowerFee);

        depositedDAIByAddress[r.lender] += daiToTransfer.sub(totalLenderFee);

        

        emit CollateralSold(_requestId, r.weiAmount, amounts[0], daiToTransfer);

        emit UpdateRequest(_requestId, r.borrower, r.lender, r.state);

    }

    

    function sellCollateralInUniswap(uint256 daiToTransfer, uint256 weiAmount) internal returns (uint256[] memory)  {

        address[] memory path = new address[](2);

        path[0] = uniswapRouter.WETH();

        path[1] = address(daiToken);

        return uniswapRouter.swapETHForExactTokens{value:weiAmount}(daiToTransfer, path, address(this), block.timestamp);

    }

    

    function getInterest(uint256 _ltv, uint256 _daiAmount) public pure returns (uint256) {

        if (_ltv == 20) {

            return _daiAmount.mul(4).div(100);

        } else if (_ltv == 40) {

            return _daiAmount.mul(6).div(100);

        } else if (_ltv == 60) {

            return _daiAmount.mul(8).div(100);

        }

        revert();

    }



    function _withdrawDaiFees(uint256 _amount) public onlyOwner {

        require(daiFees >= _amount, "Invalid number");

        daiFees -= _amount;

        require(daiToken.transfer(msg.sender, _amount), "Transfer failed");

    }



    function _withdrawEthFees(uint256 _amount) public onlyOwner {

        require(ethFees >= _amount, "Invalid number");

        ethFees -= _amount;

        msg.sender.transfer(_amount);

    }

    

    function withdrawDai(uint256 _amount) public {

        require(depositedDAIByAddress[msg.sender] >= _amount);

        depositedDAIByAddress[msg.sender] = depositedDAIByAddress[msg.sender].sub(_amount);

        require(daiToken.transfer(msg.sender, _amount));

    }

    

    function withdrawEth(uint256 _amount) public {

        require(depositedWEIByAddress[msg.sender] >= _amount);

        depositedWEIByAddress[msg.sender] = depositedWEIByAddress[msg.sender].sub(_amount);

        msg.sender.transfer(_amount);

    }

    

    function computeLenderFee(uint256 _value) public view returns (uint256) {

        return _value.mul(lenderFee).div(100); 

    }



    function computeBorrowerFee(uint256 _value) public view returns (uint256) {

        return _value.mul(borrowerFee).div(100); 

    }

    

    function getExpirationAfter(uint256 amountOfDays) public view returns (uint256) {

        return block.timestamp.add(amountOfDays.mul(1 days));

    }

    

    function requestInfo(uint256 requestId) public view  returns (uint256 _tradeId, RequestState _state, address _borrower, address _lender, uint256 _daiAmount, uint256 _durationInDays, uint256 _expireIfNotMatchedOn, uint256 _ltv, uint256 _weiAmount, uint256 _daiVsWeiCurrentPrice, uint256 _lendingFinishesOn) {

        Request storage r = requests[requestId];

        return (requestId, r.state, r.borrower, r.lender, r.daiAmount, r.durationInDays, r.expireIfNotMatchedOn, r.ltv, r.weiAmount, r.daiVsWeiCurrentPrice, r.lendingFinishesOn);

    }

}

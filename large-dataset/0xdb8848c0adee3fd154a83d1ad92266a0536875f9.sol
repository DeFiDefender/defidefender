pragma solidity 0.5.11;

pragma experimental ABIEncoderV2;



contract Ownable {



    address internal _owner;



    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);



    constructor(address initialOwner) internal {

        require(initialOwner != address(0));

        _owner = initialOwner;

        emit OwnershipTransferred(address(0), _owner);

    }



    function owner() public view returns (address) {

        return _owner;

    }



    modifier onlyOwner() {

        require(isOwner(msg.sender), "Caller is not the owner");

        _;

    }



    function isOwner(address account) internal view returns (bool) {

        return account == _owner;

    }



    function transferOwnership(address newOwner) public onlyOwner {

        require(newOwner != address(0), "New owner is the zero address");

        emit OwnershipTransferred(_owner, newOwner);

        _owner = newOwner;

    }



}



interface IUSDT {

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external;

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external;

    function transferFrom(address sender, address recipient, uint256 amount) external;

    function decimals() external view returns(uint8);

}



interface INTSCD {

    function passRepay(uint256 value, address customerAddress, string calldata comment) external;

    function passInterest(uint256 value, address customerAddress, uint256 valueRate, uint256 rate, string calldata comment) external;

    function mayPassRepay_(address customerAddress) external view returns(uint256);

}



contract OperatorNTS is Ownable {



    IUSDT public token;



    INTSCD public target;



    address public boss1;

    address public boss2;



    modifier onlyOwnerAndBoss1 {

        require(isOwner(msg.sender) || msg.sender == boss1);

        _;

    }



    event TotalPassRepay(uint256 calls, uint256 addresses, uint256 amountUSDT);

    event TotalPassInterest(uint256 calls, uint256 addresses, uint256 amountUSDT);

    event ExceedGasLimit();



    constructor(address tokenAddr, address NTSCDAddr, address initialOwner, address initialBoss1, address initialBoss2) public Ownable(initialOwner) {

        require(_isContract(tokenAddr) && _isContract(NTSCDAddr));



        token = IUSDT(tokenAddr);

        target = INTSCD(NTSCDAddr);



        boss1 = initialBoss1;

        boss2 = initialBoss2;

    }



    function setTarget(address newTarget) public onlyOwner {

        require(_isContract(newTarget));



        target = INTSCD(newTarget);

    }



    function passRepayNTSCD(uint256[] memory values, address[] memory customerAddresses, string[] memory comments, uint256 startIndex) public onlyOwnerAndBoss1 returns(uint256) {

        uint256 _length = values.length;



        uint256 totalAmount = getSum(values);



        require(token.balanceOf(address(this)) >= totalAmount, 'Send tokens to this contract first');

        require(getMayPassRepay_() >= totalAmount, 'Allow pass repay for this contract first');

        require(_length == customerAddresses.length && _length == comments.length, 'Arrays are not equal');



        approve_USDT(address(target), totalAmount);



        uint256 i;

        for (i = startIndex; i < _length; i++) {

            require(customerAddresses[i] != address(0), 'Zero address was met');



            target.passRepay(values[i], customerAddresses[i], comments[i]);



            if (gasleft() < 100000 && i+1 < _length) {

                i++;

                emit ExceedGasLimit();

                break;

            }

        }



        emit TotalPassRepay(i, _length, totalAmount);

        return i;

    }



    function passInterestNTSCD(uint256[] memory values, address[] memory customerAddresses, string[] memory comments, uint256 valueRate, uint256 rate, uint256 startIndex) public onlyOwnerAndBoss1 returns(uint256) {

        uint256 _length = values.length;



        uint256 totalAmount = getSum(values);



        require(token.balanceOf(address(this)) >= totalAmount, 'Send tokens to this contract first');

        require(getMayPassRepay_() > 0, 'Allow pass repay for this contract first');

        require(_length == customerAddresses.length && _length == comments.length, 'Arrays are not equal');



        approve_USDT(address(target), totalAmount);



        uint256 i;

        for (i = startIndex; i < _length; i++) {

            require(customerAddresses[i] != address(0), 'Zero address was met');



            target.passInterest(values[i], customerAddresses[i], valueRate, rate, comments[i]);



            if (gasleft() < 100000 && i+1 < _length) {

                i++;

                emit ExceedGasLimit();

                break;

            }

        }



        emit TotalPassInterest(i, _length, totalAmount);

        return i;

    }



    function approve_USDT(address spender, uint256 amount) public onlyOwnerAndBoss1 {

        if (amount > 0 && token.allowance(address(this), spender) > 0) {

            token.approve(spender, 0);

        }

        token.approve(spender, amount);

    }



    function transferFrom_USDT(address owner, uint256 amount) public onlyOwnerAndBoss1 {

        require(token.allowance(owner, address(this)) >= amount, 'Owner must approve these tokens first');

        token.transferFrom(owner, address(this), amount);

    }



    function transfer_USDT(address[] memory recipients, uint256[] memory amounts) public {

        require(isOwner(msg.sender) || msg.sender == boss1 || msg.sender == boss2);

        require(recipients.length == amounts.length, 'Arrays are not equal');



        for (uint256 i = 0; i < recipients.length; i++) {

            token.transfer(recipients[i], amounts[i]);

        }

    }



    function deputeBoss1(address newBoss1) public onlyOwnerAndBoss1 {

        require(newBoss1 != address(0));



        boss1 = newBoss1;

    }



    function deputeBoss2(address newBoss2) public onlyOwnerAndBoss1 {

        require(newBoss2 != address(0));



        boss2 = newBoss2;

    }



    function getMayPassRepay_() public view returns(uint256) {

        return target.mayPassRepay_(address(this));

    }



    function getSum(uint256[] memory values) public pure returns(uint256) {

        uint256 totalAmount;

        for (uint256 i = 0; i < values.length; i++) {

            totalAmount += values[i];

        }

        return totalAmount;

    }



    function _isContract(address addr) internal view returns (bool) {

        uint size;

        assembly { size := extcodesize(addr) }

        return size > 0;

    }



}

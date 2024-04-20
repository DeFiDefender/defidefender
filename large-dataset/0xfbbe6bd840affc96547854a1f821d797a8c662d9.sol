// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.6.12;


// 
// TODO: Needs testing to make sure math is correct and overflow/underflows are caught in all cases
library BoringMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) { uint256 c = a + b; require(c >= b, "BoringMath: Overflow"); return c; }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) { require(b <= a, "BoringMath: Underflow"); return a - b; }

    function mul(uint256 a, uint256 b) internal pure returns (uint256)

        { if (a == 0) {return 0;} uint256 c = a * b; require(c / a == b, "BoringMath: Overflow"); return c; }

    function div(uint256 a, uint256 b) internal pure returns (uint256) { require(b > 0, "BoringMath: Div by 0"); return a / b; }

}

// 
// Source: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
// Edited by BoringCrypto
// - removed GSN context
// - removed comments (we all know this contract)
// - updated solidity version
// - made _owner public and renamed to owner
// - simplified code
// - onlyOwner modifier removed. Just copy the one line. Cheaper in gas, better readability and better error message.
// TODO: Consider using the version that requires acceptance from new owner
contract Ownable {

    address public owner;



    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);



    constructor () internal {

        owner = msg.sender;

        emit OwnershipTransferred(address(0), msg.sender);

    }



    function renounceOwnership() public virtual {

        require(owner == msg.sender, "Ownable: caller is not the owner");

        emit OwnershipTransferred(owner, address(0));

        owner = address(0);

    }



    function transferOwnership(address newOwner) public virtual {

        require(owner == msg.sender, "Ownable: caller is not the owner");

        require(newOwner != address(0), "Ownable: new owner is the zero address");

        emit OwnershipTransferred(owner, newOwner);

        owner = newOwner;

    }



    modifier onlyOwner() {

        require(owner == msg.sender, "Ownable: caller is not the owner");

        _;

    }

}

// 
// solium-disable security/no-inline-assembly
// solium-disable security/no-low-level-calls
interface IPair {

    function init(address vault_, address tokenCollateral, address tokenAsset, address oracle_, bytes calldata oracleData) external;

}

interface IFlashLoaner {

    function executeOperation(address token, uint256 amount, uint256 fee, bytes calldata params) external;

}

contract Vault is Ownable {

    using BoringMath for uint256;



    event PairContractSet(address indexed pairContract, bool enabled);

    event SwapperSet(address swapper, bool enabled);

    event PairCreated(address indexed pairContract, address indexed tokenCollateral, address indexed tokenAsset, address oracle, address clone_address);

    event FlashLoan(address indexed user, address indexed token, uint256 amount, uint256 fee);



    mapping(address => bool) public pairContracts;

    mapping(address => bool) public swappers;

    mapping(address => bool) public isPair;

    mapping(address => uint256) public feesPending;

    address public feeTo;

    address public dev = 0x9e6e344f94305d36eA59912b0911fE2c9149Ed3E;



    function setPairContract(address pairContract, bool enabled) public onlyOwner() {

        pairContracts[pairContract] = enabled;

        emit PairContractSet(pairContract, enabled);

    }



    function setSwapper(address swapper, bool enabled) public onlyOwner() {

        swappers[swapper] = enabled;

        emit SwapperSet(swapper, enabled);

    }



    function setFeeTo(address newFeeTo) public onlyOwner {

        feeTo = newFeeTo;

    }



    function setDev(address newDev) public {

        require(msg.sender == dev, 'BentoBox: Not dev');

        dev = newDev;

    }



    function deploy(address pairContract, address tokenCollateral, address tokenAsset, address oracle, bytes calldata oracleData) public {

        require(pairContracts[pairContract], 'BentoBox: Pair Contract not whitelisted');

        bytes20 targetBytes = bytes20(pairContract);

        address clone_address;



        assembly {

            let clone := mload(0x40)

            mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)

            mstore(add(clone, 0x14), targetBytes)

            mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)

            clone_address := create(0, clone, 0x37)

        }



        IPair(clone_address).init(address(this), tokenCollateral, tokenAsset, oracle, oracleData);

        isPair[clone_address] = true;



        emit PairCreated(pairContract, tokenCollateral, tokenAsset, oracle, clone_address);

    }



    function transfer(address token, address to, uint256 amount) public {

        require(isPair[msg.sender], "BentoBox: Only pair contracts can transfer");



        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, amount));

        require(success && (data.length == 0 || abi.decode(data, (bool))), "BentoBox: Transfer failed at ERC20");

    }



    function transferFrom(address token, address from, uint256 amount) public {

        require(isPair[msg.sender], "BentoBox: Only pair contracts can transferFrom");



        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, address(this), amount));

        require(success && (data.length == 0 || abi.decode(data, (bool))), "BentoBox: TransferFrom failed at ERC20");

    }



    function flashLoan(address user, address token, uint256 amount, bytes calldata params) public {

        transfer(token, user, amount);



        uint256 fee = amount.mul(8).div(10000);



        IFlashLoaner(user).executeOperation(token, amount, fee, params);



        transferFrom(token, user, amount.add(fee));

        feesPending[token] = feesPending[token].add(fee);

        emit FlashLoan(user, token, amount, fee);

    }



    function withdrawFees(address token) public {

        uint256 fees = feesPending[token].sub(1);

        uint256 devFee = fees.div(10);

        feesPending[token] = 1;  // Don't set it to 0 as that would increase the gas cost for the next accrue called by a user.

        transfer(token, feeTo, fees.sub(devFee));

        transfer(token, dev, devFee);

    }

}

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
interface IOracle {

    // Each oracle should have a set function. The first parameter will be 'address pair' and any parameters can come after.

    // Setting should only be allowed ONCE for each pair.



    // Get the latest exchange rate, if no valid (recent) rate is available, return false

    function get(address pair) external returns (bool, uint256);



    // Check the last exchange rate without any state changes

    function peek(address pair) external view returns (uint256);

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

// 
contract ERC20 {

    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;

    mapping(address => mapping (address => uint256)) allowance;



    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);



    function transfer(address to, uint256 amount) public returns (bool success) {

        if (balanceOf[msg.sender] >= amount && amount > 0 && balanceOf[to] + amount > balanceOf[to]) {

            balanceOf[msg.sender] -= amount;

            balanceOf[to] += amount;

            emit Transfer(msg.sender, to, amount);

            return true;

        } else {

            return false;

        }

    }



    function transferFrom(address from, address to, uint256 amount) public returns (bool success) {

        if (balanceOf[from] >= amount && allowance[from][msg.sender] >= amount && amount > 0 && balanceOf[to] + amount > balanceOf[to]) {

            balanceOf[from] -= amount;

            allowance[from][msg.sender] -= amount;

            balanceOf[to] += amount;

            emit Transfer(from, to, amount);

            return true;

        } else {

            return false;

        }

    }



    function approve(address spender, uint256 amount) public returns (bool success) {

        allowance[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;

    }

}

// 
// Copyright 2020 BoringCrypto - All rights reserved
// WARNING!!! DO NOT USE!!! NOT YET TESTED + NOT YET SECURITY CONSIDERED + DEF. NOT YET AUDITED!!!
// FOR CONCEPT TESTING ONLY!
// solium-disable security/no-low-level-calls
interface IDelegateSwapper {

    // Withdraws amountFrom 'from tokens' from the vault, turns it into at least amountToMin 'to tokens' and transfers those into the vault.

    // Returns amount of tokens added to the vault.

    function swap(address swapper, address from, address to, uint256 amountFrom, uint256 amountToMin) external returns (uint256);

}

interface ISwapper {

    function swap(address from, address to, uint256 amountFrom, uint256 amountTo, address profitTo) external;

}

interface IERC20 {

    function decimals() external returns (uint8);

}

// Special thanks to:
// https://twitter.com/burger_crypto - for the idea of trying to let the LPs benefit from liquidations
// TODO: check all reentrancy paths
// TODO: what to do when the entire pool is underwater?
// TODO: ensure BoringMath is always used
// We do allow supplying assets and borrowing, but the asset does NOT provide collateral as it's just silly and no UI should allow this
contract Pair is ERC20 {

    using BoringMath for uint256;



    // Keep at the top in this order for delegate calls to be able to access them

    Vault public vault;

    address public tokenCollateral;

    address public tokenAsset;



    mapping(address => uint256) public userCollateralShare;

    // userAssetShare = balanceOf - the asset share is the token.

    mapping(address => uint256) public userBorrowShare;



    IOracle public oracle;



    uint256 exchangeRate;



    uint256 public lastBlockAccrued;



    uint256 public totalCollateral;

    uint256 public totalAsset; // Includes totalBorrow

    uint256 public totalBorrow; // Total units of asset borrowed



    uint256 public totalCollateralShare; // Total amount of shares in the collateral pool

    // totalAssetShare = totalSupply - Total amount of shares in the asset pool

    uint256 public totalBorrowShare;



    uint256 public interestPerBlock;

    uint256 public lastInterestBlock;



    uint256 public colRate;     // Collateral rate used to calculate if the protocol can liquidate

    uint256 public openColRate; // Collateral rate used to calculate if ANYONE can liquidate

    uint256 public liqMultiplier;

    uint256 public feesPending;



    string public constant symbol = "BENTO LP";

    string public constant name = "Bento LP";

    uint8 public decimals;



    event NewExchangeRate(uint256 rate);

    event AddCollateral(address indexed user, uint256 amount, uint256 share);

    event AddAsset(address indexed user, uint256 amount, uint256 share);

    event AddBorrow(address indexed user, uint256 amount, uint256 share);

    event RemoveCollateral(address indexed user, uint256 amount, uint256 share);

    event RemoveAsset(address indexed user, uint256 amount, uint256 share);

    event RemoveBorrow(address indexed user, uint256 amount, uint256 share);



    function init(Vault vault_, address collateral_address, address asset_address, IOracle oracle_address, bytes calldata oracleData) public {

        require(address(vault) == address(0), 'BentoBox: already initialized');

        vault = vault_;

        tokenCollateral = collateral_address;

        tokenAsset = asset_address;

        oracle = oracle_address;

        (bool success,) = address(oracle).call(oracleData);

        require(success, 'BentoBox: oracle init failed.');

        lastInterestBlock = block.number;



        interestPerBlock = 4566210045;  // 1% APR, with 1e18 being 100%



        colRate = 75000; // 75%

        openColRate = 77000; // 77%

        liqMultiplier = 112000; // 12% more tokenCollateral



        decimals = IERC20(asset_address).decimals();

    }



    function accrue() public {

        uint256 blocks = block.number - lastBlockAccrued;

        if (blocks == 0) {return;}

        // The first time lastBlockAccrued will be 0, but also borrowed will be 0, so all good

        uint256 extraAmount = totalBorrow.mul(interestPerBlock).mul(block.number - lastBlockAccrued).div(1e18);

        uint256 feeAmount = extraAmount.div(10); // 10% of interest paid goes to fee

        totalAsset = totalAsset.add(extraAmount.sub(feeAmount));

        totalBorrow = totalBorrow.add(extraAmount);

        feesPending = feesPending.add(feeAmount);

        lastBlockAccrued = block.number;

    }



    function withdrawFees() public {

        accrue();

        uint256 fees = feesPending.sub(1);

        uint256 devFee = fees.div(10);

        feesPending = 1; // Don't set it to 0 as that would increase the gas cost for the next accrue called by a user.

        vault.transfer(tokenAsset, vault.feeTo(), fees.sub(devFee));

        vault.transfer(tokenAsset, vault.dev(), devFee);

    }



    function isSolvent(address user, bool open) public view returns (bool) {

        // accrue must have already been called!

        if (userBorrowShare[user] == 0) return true;

        if (totalCollateralShare == 0) return false;



        uint256 collateral = userCollateralShare[user].mul(totalCollateral).div(totalCollateralShare);

        uint256 borrow = userBorrowShare[user].mul(totalBorrow).div(totalBorrowShare);



        return collateral.mul(open ? openColRate : colRate).div(1e5) >= borrow.mul(exchangeRate).div(1e18);

    }



    // Gets the exchange rate. How much collateral to buy 1e18 asset.

    function updateExchangeRate() public returns (uint256) {

        (bool success, uint256 rate) = oracle.get(address(this));



        // TODO: How to deal with unsuccessful fetch

        if (success) {

            exchangeRate = rate;

            emit NewExchangeRate(rate);

        }

        return exchangeRate;

    }



    function updateInterestRate() public {

        if (totalAsset == 0) {return;}

        uint256 minimumInterest = 1141552511;    // 0.25% APR

        uint256 maximumInterest = 4566210045000; // 1000% APR

        uint256 targetMinUse = 700000000000000000; // 70%

        uint256 targetMaxUse = 800000000000000000; // 80%



        uint256 blocks = block.number - lastInterestBlock;

        if (blocks == 0) {return;}

        uint256 utilization = totalBorrow.mul(1e18).div(totalAsset);

        uint256 newInterestPerBlock;

        if (utilization < targetMinUse) {

            uint256 underFactor = targetMinUse.sub(utilization).mul(1e18).div(targetMinUse);

            uint256 scale = uint256(2000e36).add(underFactor.mul(underFactor).mul(blocks));

            newInterestPerBlock = interestPerBlock.mul(2000e36).div(scale);

            if (newInterestPerBlock < minimumInterest) {

                newInterestPerBlock = minimumInterest;

            }

        } else if (utilization > targetMaxUse) {

            uint256 overFactor = utilization.sub(targetMaxUse).mul(1e18).div(uint256(1e18).sub(targetMaxUse));

            uint256 scale = uint256(2000e36).add(overFactor.mul(overFactor).mul(blocks));



            newInterestPerBlock = interestPerBlock.mul(scale).div(2000e36);

            if (newInterestPerBlock > maximumInterest) {

                newInterestPerBlock = maximumInterest;

            }

        } else {return;}



        interestPerBlock = newInterestPerBlock;

        lastInterestBlock = block.number;

    }



    function _addCollateral(address user, uint256 amount) private {

        uint256 newShare = totalCollateralShare == 0 ? amount : amount.mul(totalCollateralShare).div(totalCollateral);

        userCollateralShare[user] = userCollateralShare[user].add(newShare);

        totalCollateralShare = totalCollateralShare.add(newShare);

        totalCollateral = totalCollateral.add(amount);

        emit AddCollateral(msg.sender, amount, newShare);

    }



    function _addAsset(address user, uint256 amount) private {

        uint256 newShare = totalSupply == 0 ? amount : amount.mul(totalSupply).div(totalAsset);

        balanceOf[user] = balanceOf[user].add(newShare);

        totalSupply = totalSupply.add(newShare);

        totalAsset = totalAsset.add(amount);

        emit AddAsset(msg.sender, amount, newShare);

    }



    function _addBorrow(address user, uint256 amount) private {

        uint256 newShare = totalBorrowShare == 0 ? amount : amount.mul(totalBorrowShare).div(totalBorrow);

        userBorrowShare[user] = userBorrowShare[user].add(newShare);

        totalBorrowShare = totalBorrowShare.add(newShare);

        totalBorrow = totalBorrow.add(amount);

        emit AddBorrow(msg.sender, amount, newShare);

    }



    function _removeCollateralShare(address user, uint256 share) private returns (uint256) {

        userCollateralShare[user] = userCollateralShare[user].sub(share);

        uint256 amount = share.mul(totalCollateral).div(totalCollateralShare);

        totalCollateralShare = totalCollateralShare.sub(share);

        totalCollateral = totalCollateral.sub(amount);

        emit RemoveCollateral(msg.sender, amount, share);

        return amount;

    }



    function _removeAssetShare(address user, uint256 share) private returns (uint256) {

        balanceOf[user] = balanceOf[user].sub(share);

        uint256 amount = share.mul(totalAsset).div(totalSupply);

        totalSupply = totalSupply.sub(share);

        totalAsset = totalAsset.sub(amount);

        emit RemoveAsset(msg.sender, amount, share);

        return amount;

    }



    function _removeBorrowShare(address user, uint256 share) private returns (uint256) {

        userBorrowShare[user] = userBorrowShare[user].sub(share);

        uint256 amount = share.mul(totalBorrow).div(totalBorrowShare);

        totalBorrowShare = totalBorrowShare.sub(share);

        totalBorrow = totalBorrow.sub(amount);

        emit RemoveBorrow(msg.sender, amount, share);

        return amount;

    }



    function addCollateral(uint256 amount) public {

        _addCollateral(msg.sender, amount);

        vault.transferFrom(tokenCollateral, msg.sender, amount);

    }



    function addAsset(uint256 amount) public {

        accrue();

        updateInterestRate();

        _addAsset(msg.sender, amount);

        vault.transferFrom(tokenAsset, msg.sender, amount);

    }



    function removeCollateral(uint256 share, address to) public {

        accrue();

        uint256 amount = _removeCollateralShare(msg.sender, share);

        require(isSolvent(msg.sender, false), 'BentoBox: user insolvent');

        vault.transfer(tokenCollateral, to, amount);

    }



    function removeAsset(uint256 share, address to) public {

        accrue();

        updateInterestRate();

        uint256 amount = _removeAssetShare(msg.sender, share);

        vault.transfer(tokenAsset, to, amount);

    }



    function borrow(uint256 amount, address to) public {

        require(amount <= totalAsset.sub(totalBorrow), 'BentoBox: not enough liquidity');

        accrue();

        updateInterestRate();

        _addBorrow(msg.sender, amount);

        require(isSolvent(msg.sender, false), 'BentoBox: user insolvent');

        vault.transfer(tokenAsset, to, amount);

    }



    function repay(uint256 share) public {

        accrue();

        updateInterestRate();

        uint256 amount = _removeBorrowShare(msg.sender, share);

        vault.transferFrom(tokenAsset, msg.sender, amount);

    }



    function short(address swapper, uint256 amountAsset, uint256 minAmountCollateral) public {

        require(amountAsset <= totalAsset.sub(totalBorrow), 'BentoBox: not enough liquidity');



        require(vault.swappers(swapper), 'BentoBox: Invalid swapper');

        accrue();

        updateInterestRate();

        _addBorrow(msg.sender, amountAsset);



        (bool success, bytes memory result) = swapper.delegatecall(

            abi.encodeWithSignature("swap(address,address,address,uint256,uint256)", swapper, tokenAsset, tokenCollateral, amountAsset, minAmountCollateral));

        require(success, 'BentoBox: Swap failed');

        uint256 amountCollateral = abi.decode(result, (uint256));

        _addCollateral(msg.sender, amountCollateral);



        require(isSolvent(msg.sender, false), 'BentoBox: user insolvent');

    }



    function unwind(address swapper, uint256 borrowShare, uint256 maxAmountCollateral) public {

        require(vault.swappers(swapper), 'BentoBox: Invalid swapper');

        accrue();

        updateInterestRate();



        uint256 borrowAmount = _removeBorrowShare(msg.sender, borrowShare);



        (bool success, bytes memory result) = swapper.delegatecall(

            abi.encodeWithSignature("swapExact(address,address,address,uint256,uint256)", swapper, tokenCollateral, tokenAsset, maxAmountCollateral, borrowAmount));

        require(success, 'BentoBox: Swap failed');

        _removeCollateralShare(msg.sender, abi.decode(result, (uint256)).mul(totalCollateralShare).div(totalCollateral));



        require(isSolvent(msg.sender, false), 'BentoBox: user insolvent');

    }



    function liquidate(address[] calldata users, uint256[] calldata borrowShares, address to, address swapper, bool open) public {

        accrue();

        updateExchangeRate();

        updateInterestRate();



        uint256 allCollateralAmount;

        uint256 allCollateralShare;

        uint256 allBorrowAmount;

        uint256 allBorrowShare;

        for (uint256 i = 0; i < users.length; i++) {

            address user = users[i];

            if (!isSolvent(user, open)) {

                uint256 borrowShare = borrowShares[i];

                uint256 borrowAmount = borrowShare.mul(totalBorrow).div(totalBorrowShare);

                uint256 collateralAmount = borrowAmount.mul(1e13).mul(liqMultiplier).div(exchangeRate);

                uint256 collateralShare = collateralAmount.mul(totalCollateralShare).div(totalCollateral);



                userCollateralShare[user] = userCollateralShare[user].sub(collateralShare);

                userBorrowShare[user] = userBorrowShare[user].sub(borrowShare);

                emit RemoveCollateral(user, collateralAmount, collateralShare);

                emit RemoveBorrow(user, borrowAmount, borrowShare);



                // Keep totals

                allCollateralAmount = allCollateralAmount.add(collateralAmount);

                allCollateralShare = allCollateralShare.add(collateralShare);

                allBorrowAmount = allBorrowAmount.add(borrowAmount);

                allBorrowShare = allBorrowShare.add(borrowShare);

            }

        }

        require(allBorrowAmount != 0, 'BentoBox: all users are solvent');

        totalBorrow = totalBorrow.sub(allBorrowAmount);

        totalBorrowShare = totalBorrowShare.sub(allBorrowShare);

        totalCollateral = totalCollateral.sub(allCollateralAmount);

        totalCollateralShare = totalCollateralShare.add(allCollateralShare);



        if (!open) {

            // Closed liquidation using a pre-approved swapper for the benefit of the LPs

            require(vault.swappers(swapper), 'BentoBox: Invalid swapper');



            (bool success, bytes memory result) = swapper.delegatecall(

                abi.encodeWithSignature("swap(address,address,address,uint256,uint256)", swapper, tokenCollateral, tokenAsset, allCollateralAmount, allBorrowAmount));

            require(success, 'BentoBox: Swap failed');

            uint256 extraAsset = abi.decode(result, (uint256)).sub(allBorrowAmount);



            // The extra asset gets added to the pool

            uint256 feeAmount = extraAsset.div(10); // 10% of profit goes to fee

            feesPending = feesPending.add(feeAmount);



            totalAsset = totalAsset.add(extraAsset.sub(feeAmount));

            emit AddAsset(address(0), extraAsset, 0);

        } else if (swapper == address(0)) {

            vault.transferFrom(tokenAsset, to, allBorrowAmount);

            vault.transfer(tokenCollateral, to, allCollateralAmount);

        } else {

            // Open (flash) liquidation: get proceeds first and provide the borrow after

            vault.transfer(tokenCollateral, swapper, allCollateralAmount);

            ISwapper(swapper).swap(tokenCollateral, tokenAsset, allCollateralAmount, allBorrowAmount, to);

            vault.transferFrom(tokenAsset, swapper, allBorrowAmount);

        }

    }

}

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;



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



library Address {

    function isContract(address account) internal view returns (bool) {

        // This method relies in extcodesize, which returns 0 for contracts in

        // construction, since the code is only stored at the end of the

        // constructor execution.



        uint256 size;

        // solhint-disable-next-line no-inline-assembly

        assembly { size := extcodesize(account) }

        return size > 0;

    }



    function sendValue(address payable recipient, uint256 amount) internal {

        require(address(this).balance >= amount, "Address: insufficient balance");



        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value

        (bool success, ) = recipient.call{ value: amount }("");

        require(success, "Address: unable to send value, recipient may have reverted");

    }



    function functionCall(address target, bytes memory data) internal returns (bytes memory) {

      return functionCall(target, data, "Address: low-level call failed");

    }



    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {

        return _functionCallWithValue(target, data, 0, errorMessage);

    }



    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {

        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");

    }



    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {

        require(address(this).balance >= value, "Address: insufficient balance for call");

        return _functionCallWithValue(target, data, value, errorMessage);

    }



    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {

        require(isContract(target), "Address: call to non-contract");



        // solhint-disable-next-line avoid-low-level-calls

        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);

        if (success) {

            return returndata;

        } else {

            // Look for revert reason and bubble it up if present

            if (returndata.length > 0) {

                // The easiest way to bubble the revert reason is using memory via assembly



                // solhint-disable-next-line no-inline-assembly

                assembly {

                    let returndata_size := mload(returndata)

                    revert(add(32, returndata), returndata_size)

                }

            } else {

                revert(errorMessage);

            }

        }

    }

}



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

        // assert(a == b * c + a % b); // There is no case in which this doesn't hold



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



contract ERC20 is IERC20 {

    using SafeMath for uint256;

    using Address for address;



    struct StakedToken {

        uint256 amount;

        uint256 expiredAt;

        uint256 rate;

        int256 claimed;

    }



    event Locked(address indexed account, uint256 amount, uint256 expiredAt);

    event Unlocked(address indexed account, uint256 index, uint256 amount, uint256 rate); // rate = 0 --> cancel, rate > 0 --> unlocked



    mapping (address => uint256) private _balances;

    mapping (address => StakedToken[]) private _stakedTokens;

    // address[] private _lockedAddress;

    mapping (address => mapping (address => uint256)) private _allowances;



    uint256 private _totalSupply;

    string private _name;

    string private _symbol;

    uint8 private _decimals = 18;

    address private _owner;

    uint256 private _lockDuration = 14 days;

    uint256 private _interestRate = 20; // %



    modifier onlyOwner() {

        require(_owner == msg.sender, "Ownable: caller is not the owner");

        _;

    }



    constructor (string memory name, string memory symbol) public {

        _name = name;

        _symbol = symbol;

        _owner = msg.sender;

    }



    function name() public view returns (string memory) {

        return _name;

    }



    function symbol() public view returns (string memory) {

        return _symbol;

    }



    function decimals() public view returns (uint8) {

        return _decimals;

    }



    function totalSupply() public view override returns (uint256) {

        return _totalSupply;

    }



    function balanceOf(address account) public view override returns (uint256) {

        return _balances[account];

    }



    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {

        _transfer(msg.sender, recipient, amount);

        return true;

    }



    function allowance(address owner, address spender) public view virtual override returns (uint256) {

        return _allowances[owner][spender];

    }



    function approve(address spender, uint256 amount) public virtual override returns (bool) {

        _approve(msg.sender, spender, amount);

        return true;

    }



    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {

        _transfer(sender, recipient, amount);

        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));

        return true;

    }



    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {

        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));

        return true;

    }



    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {

        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));

        return true;

    }



    function _transfer(address sender, address recipient, uint256 amount) internal virtual {

        require(sender != address(0), "ERC20: transfer from the zero address");

        require(recipient != address(0), "ERC20: transfer to the zero address");



        _beforeTokenTransfer(sender, recipient, amount);



        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");

        _balances[recipient] = _balances[recipient].add(amount);

        emit Transfer(sender, recipient, amount);

    }



    function _mint(address account, uint256 amount) internal virtual {

        require(account != address(0), "ERC20: mint to the zero address");



        _beforeTokenTransfer(address(0), account, amount);



        _totalSupply = _totalSupply.add(amount);

        _balances[account] = _balances[account].add(amount);

        emit Transfer(address(0), account, amount);

    }



    function _burn(address account, uint256 amount) internal virtual {

        require(account != address(0), "ERC20: burn from the zero address");



        _beforeTokenTransfer(account, address(0), amount);



        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");

        _totalSupply = _totalSupply.sub(amount);

        emit Transfer(account, address(0), amount);

    }



    function _approve(address owner, address spender, uint256 amount) internal virtual {

        require(owner != address(0), "ERC20: approve from the zero address");

        require(spender != address(0), "ERC20: approve to the zero address");



        _allowances[owner][spender] = amount;

        emit Approval(owner, spender, amount);

    }



    function _setupDecimals(uint8 decimals_) internal {

        _decimals = decimals_;

    }



    function _beforeTokenTransfer(address from, address to, uint256 amount) internal view {

        // super._beforeTokenTransfer(from, to, amount);



        //if (from == address(0)) { // When minting tokens

        //    require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");

        //    return;

        //}

    }



    function mint(uint256 amount) public onlyOwner {

        _mint(msg.sender, amount);

    }



    function setDuration(uint256 duration) public onlyOwner {

        if (duration > 0) {

            _lockDuration = duration;

        }

    }



    function setInterest(uint256 interest) public onlyOwner {

        if (_interestRate < 100 && _interestRate >= 0) {

            _interestRate = interest;

        }

    }



    function getLockDuration() public view returns (uint256) {

        return _lockDuration;

    }



    function currentInterestRate() public view returns (uint256) {

        return _interestRate;

    }

    

    function stakeTotal() public view returns (uint256) {

        return _stakedTokens[msg.sender].length;

    }

    

    function stake(uint256 index) public view returns (uint256, uint256, uint256, int256) {

        if (index < 0 || index >= _stakedTokens[msg.sender].length) {

            return (0, 0, 0, 0);

        }



        return (_stakedTokens[msg.sender][index].amount, _stakedTokens[msg.sender][index].expiredAt, _stakedTokens[msg.sender][index].rate, _stakedTokens[msg.sender][index].claimed);

    }

    

    function lock(uint256 amount) public {

        uint256 expiredAt = now.add(_lockDuration);



        require(amount > 0 && amount <= balanceOf(msg.sender), "Invalid amount");

        require(msg.sender != _owner, "Invalid address");



        _transfer(msg.sender, _owner, amount);

        _stakedTokens[msg.sender].push(StakedToken(amount, expiredAt, _interestRate, 0));

        emit Locked(msg.sender, amount, expiredAt);

    }

    

    function unlock(uint256 index) public {

        require(index >= 0 && index < _stakedTokens[msg.sender].length, "Index out of range");

        require(_stakedTokens[msg.sender][index].claimed == 0, "This stake is claimed");

        require(_stakedTokens[msg.sender][index].expiredAt <= now, "The unlocked date has not yet came");



        uint256 amount = _stakedTokens[msg.sender][index].amount;

        uint256 rate = _stakedTokens[msg.sender][index].rate;

        uint256 interest = amount.mul(rate).div(100);

        if (amount > 0) {

            _transfer(_owner, msg.sender, amount.add(interest));

        }

        _stakedTokens[msg.sender][index].claimed = 1;

        emit Unlocked(msg.sender, index, amount, rate);

    }

    

    function unlockAll() public {

        uint256 amount = 0;

        uint256 interest = 0;



        for (uint256 i = 0; i < _stakedTokens[msg.sender].length; i++) {

            if (_stakedTokens[msg.sender][i].claimed != 0 || _stakedTokens[msg.sender][i].expiredAt > now) {

                continue;

            }



            uint256 currentAmount = _stakedTokens[msg.sender][i].amount;

            uint256 rate = _stakedTokens[msg.sender][i].rate;

            amount = amount.add(currentAmount);

            interest = interest.add(currentAmount.mul(rate).div(100));

            

            _stakedTokens[msg.sender][i].claimed = 1;

            emit Unlocked(msg.sender, i, currentAmount, rate);

        }



        if (amount > 0) {

            _transfer(_owner, msg.sender, amount.add(interest));

        }

    }

    

    function cancel(uint256 index) public {

        if (index < 0 || index >= _stakedTokens[msg.sender].length) {

            return;

        }

        

        if (_stakedTokens[msg.sender][index].claimed != 0) {

            return;

        }

        

        uint256 amount = _stakedTokens[msg.sender][index].amount;

        if (amount > 0) {

            _transfer(_owner, msg.sender, amount);

        }

        _stakedTokens[msg.sender][index].claimed = -1;

        emit Unlocked(msg.sender, index, amount, 0);

    }

    

    function cancelAll() public {

        uint256 amount = 0;



        for (uint256 i = 0; i < _stakedTokens[msg.sender].length; i++) {

            if (_stakedTokens[msg.sender][i].claimed != 0) {

                continue;

            }



            amount = amount.add(_stakedTokens[msg.sender][i].amount);

            _stakedTokens[msg.sender][i].claimed = -1;

            emit Unlocked(msg.sender, i, amount, 0);

        }



        if (amount > 0) {

            _transfer(_owner, msg.sender, amount);

        }

    }

}

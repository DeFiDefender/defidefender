pragma solidity ^0.5.17;



interface Deployer {

    function execute(uint salt) external payable returns (address);

}



contract Team3DPresale {



    // Token data

    mapping (address => uint256) public balances;

    string public constant name  = "Team3DPresale";

    string public constant symbol = "T3DPre";

    uint8 public constant decimals = 18;



    event Transfer(address indexed _from, address indexed _to, uint256 _value);



    // Presale data

    uint public totalTokensSold;

    uint public totalEthSpent;

    address[] public keys;

    mapping (address => bool) helper;

    mapping (address => bool) public userExists;

    mapping (address => uint) public teamFund;

    mapping (address => bool) public whiteListed;

    mapping (address => uint) public ethSpent;

    uint public constant maxAmount = 5 ether;

    uint public constant maxTotalAmount = 400 ether;

    uint public constant tokensPerEth = 43750; // 17.5m tokens/400 eth; 43750 tokens/1 eth; 0.000022857 eth/1 token

    uint public constant totalSaleSupply = 17500000 * (10 ** 18); // 17.5m = 35% of total supply.

    uint public constant totalTeamSupply = 15000000 * (10 ** 18); // 15m = 30% for team/marketing/project

    uint public initialTokens = totalSaleSupply + totalTeamSupply; // 65% distributed initially, remaining 35% added to liq later

    bool public whitelistOnly = true;



    address payable owner;



    

    modifier onlyOwner() {

        require(msg.sender == owner || helper[msg.sender] == true);

        _;

    }





    constructor() public {

        owner = msg.sender;

        balances[owner] = totalTeamSupply;

        emit Transfer(address(0), owner, totalTeamSupply);

    }





    function () external payable {

        purchase();

    }





    function purchase() public payable {

        require(msg.value <= maxAmount);

        require(ethSpent[msg.sender] + msg.value <= maxAmount);

        require(totalEthSpent <= maxTotalAmount);

        require(!whitelistOnly || whiteListed[msg.sender], "Not a whitelisted address");



        uint _tokenAmount = msg.value * tokensPerEth;



        // Global data

        totalEthSpent += msg.value;

        totalTokensSold += _tokenAmount;



        // User data

        ethSpent[msg.sender] += msg.value;

        balances[msg.sender] += _tokenAmount;



        if (!userExists[msg.sender]) {

            userExists[msg.sender] = true;

            keys.push(msg.sender);

        }



        emit Transfer(address(0), msg.sender, _tokenAmount);

    }





    function addToWhitelist(address _addr) public onlyOwner {

        whiteListed[_addr] = true;

    }





    function bulkAddToWhitelist(address[] calldata _addrs) external onlyOwner {

        for (uint i=0; i < _addrs.length; i++) {

            addToWhitelist(_addrs[i]);

        }

    }





    function assignTeamTokens(address _addr, uint _amount) external onlyOwner {

        require(balanceOf(owner) - _amount >= 0, "Underflow");

        

        balances[owner] -= _amount;

        balances[_addr] += _amount;

        teamFund[_addr] += _amount;



        if (!userExists[_addr]) {

            userExists[_addr] = true;

            keys.push(_addr);

        }



        emit Transfer(address(owner), _addr, _amount);

    }





    function removeTeamTokens(address _addr, uint _amount) external onlyOwner {

        require(_amount <= teamFund[_addr]);



        balances[owner] += _amount;

        balances[_addr] -= _amount;

        teamFund[_addr] -= _amount;



        emit Transfer(_addr, address(owner), _amount);

    }





    function deployMainToken(address _deployerAddr, uint _salt) external onlyOwner {

        

        // Collect dust if exact amount is not reached

        if (getRemainingTokens() > 0) { clearRemainingTokens(); }

        

        // In case someone tries to send eth with selfdestruct 

        if (address(this).balance > maxTotalAmount) {

            uint _amount = address(this).balance - maxTotalAmount;

            owner.transfer(_amount);

        }



        // Deploy liquidity and lock tokens

        Deployer(_deployerAddr).execute.value(address(this).balance)(_salt);

    }





    function toggleWhitelist() external onlyOwner {

        whitelistOnly = !whitelistOnly;

    }





    function refund(address payable _addr) public onlyOwner {

        require(balances[_addr] - teamFund[_addr] > 0, "User has no purchased balance");



        uint _userBal = balances[_addr] - teamFund[_addr]; // Only refund purchased tokens

        uint _ethRefund = _userBal / tokensPerEth;



        // Global data

        totalEthSpent -= _ethRefund;

        totalTokensSold -= _userBal;



        // User data

        ethSpent[_addr] = 0;

        balances[_addr] = teamFund[_addr];  // Will be zero if they have no teamFund tokens



        _addr.transfer(_ethRefund);



        emit Transfer(_addr, address(0), _userBal);

    }





    function batchRefund(address payable[] calldata _addrs) external onlyOwner {

        for (uint i=0; i < _addrs.length; i++) {

            refund(_addrs[i]);

        }

    }





    // Use this to collect any dust before deploy

    function clearRemainingTokens() internal {

        uint _remainingTokens = getRemainingTokens();

        totalTokensSold += _remainingTokens;

        balances[owner] += _remainingTokens;



        emit Transfer(address(0), owner, _remainingTokens);

    }





    function addHelper(address _addr, bool _val) public onlyOwner {

        helper[_addr] = _val;

    }





    function totalSupply() public view returns(uint) {

        return initialTokens;

    }





    function balanceOf(address _addr) public view returns(uint) {

        return balances[_addr];

    }





    function getRemainingTokens() public view returns(uint) {

        return totalSaleSupply - totalTokensSold;

    }





    function getTotalPresaleBuyers() public view returns(uint) {

        return keys.length;

    }

}

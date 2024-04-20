pragma solidity 0.6.0;



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



contract Ownable {

    address public _owner;



    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);



    constructor () public {

        _owner = msg.sender;

        emit OwnershipTransferred(address(0), msg.sender);

    }



    function owner() public view returns (address) {

        return _owner;

    }



    modifier onlyOwner() {

        require(_owner == msg.sender, "Ownable: caller is not the owner");

        _;

    }



    function renounceOwnership() public onlyOwner {

        emit OwnershipTransferred(_owner, address(0));

        _owner = address(0);

    }



    function transferOwnership(address newOwner) public onlyOwner {

        require(newOwner != address(0), "Ownable: new owner is the zero address");

        emit OwnershipTransferred(_owner, newOwner);

        _owner = newOwner;

    }

}





contract MyTokenPresale is Ownable {

    using SafeMath for uint256;



    struct Candidate {

        uint256 cap_wei;

        uint256 claimed_wei;

    }



    string public constant name = "Cow Presale";



    event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);

    event AddressWhitelisted(address addr, uint256 value);



    uint256 private constant INITIAL_CAP = 3150000 * 10**9;

    uint256 private constant MIN_WEI = 1 ether;

    uint256 private constant CAP = 378;

    uint256 private constant RATE = INITIAL_CAP / CAP;

    uint private constant ONLY_LISTED_TIME = 6 hours;

    uint private constant TOTAL_TIME = 24 hours;



    mapping(address => Candidate) private _whitelist;

    mapping(address => uint256) private _balances;



    address payable public _wallet;



    uint256 public _tokenBalance;

    uint256 public _weiRaised;



    uint private _starttime;



    bool public _locked;

    bool public _closed;



    constructor() public  {

        _owner = msg.sender;

        _wallet = msg.sender;

        _locked = true;

        _closed = false;

        _tokenBalance = INITIAL_CAP;

        _whitelist[0x061739CF12eaDdB84ed5Aca0d7452302729f2E4B].cap_wei = 5 ether;

        _whitelist[0x0C54717a5Cb953D61F712147E82006a7229d9fEC].cap_wei = 5 ether;

        _whitelist[0x0deEBc23aEBA6867e533fb54FbE1ec7aF1F39AD5].cap_wei = 5 ether;

        _whitelist[0x0e304d65ed22c4187254D9b4BED1693431A568C3].cap_wei = 5 ether;

        _whitelist[0x10aE8A39115dB0E8B118cfCD78f3771097224570].cap_wei = 5 ether;

        _whitelist[0x111AC40968eEd07973FfcA2F10e52d14b6F33418].cap_wei = 5 ether;

        _whitelist[0x192571e267873AaE234F90C9EFdEf142D4e6f562].cap_wei = 5 ether;

        _whitelist[0x2289152De2040C8880800A7C1A201E37E6fb5446].cap_wei = 5 ether;

        _whitelist[0x253a7d35Fb9c294f75e6B42224D7f5eab1b908cc].cap_wei = 5 ether;

        _whitelist[0x26bDf965aaBe69ce67cc2b55D3e704d98D308e81].cap_wei = 5 ether;

        _whitelist[0x27c7e35Bdb1158599e76b374aD506256139edC7F].cap_wei = 5 ether;

        _whitelist[0x2909a6853CD7D5AA7D3ab1167519f9BB843B9618].cap_wei = 5 ether;

        _whitelist[0x2E5113A9f38Ae19843d8F773567bc89EAa52dA52].cap_wei = 5 ether;

        _whitelist[0x3837E2c3Ba88D3706FAb9337B4337a8D0BaEb06c].cap_wei = 5 ether;

        _whitelist[0x3D0b5945dE0c4efA89fB78410917e351754A62D3].cap_wei = 5 ether;

        _whitelist[0x4009A76552971d32DAc94c6bf18bc3b8CC4a6a69].cap_wei = 5 ether;

        _whitelist[0x4207Fb065cba079BC0A487accbdA282fD8446026].cap_wei = 5 ether;

        _whitelist[0x431e17fcd5dB8167703e1Bb5237cB90AA86B4f4d].cap_wei = 5 ether;

        _whitelist[0x44Acd0Ff3bE9Fdfb932453C82B5dF5739D28b276].cap_wei = 5 ether;

        _whitelist[0x484C211aE86e22E4201CeFa8FC2fd9F343dAE192].cap_wei = 5 ether;

        _whitelist[0x4D1B9439ecE710cf9Da9D0c60B17685cb00C2141].cap_wei = 5 ether;

        _whitelist[0x5112E5D2aF3E3Ea50cba48a900EAF0db7281936D].cap_wei = 5 ether;

        _whitelist[0x534d1A3374C966502e25d1D5d1E0Ba9b5bd67C37].cap_wei = 5 ether;

        _whitelist[0x54A7fb5E1b91B413C51D43A6Fd858501E4E20843].cap_wei = 5 ether;

        _whitelist[0x5b85988F0032ee818f911ec969Dd9c649CAa0a14].cap_wei = 5 ether;

        _whitelist[0x5cBbeC05d8eafbc5e88aBC36f28b83acC3F2DBe7].cap_wei = 5 ether;

        _whitelist[0x62a265E0720Fc3d36679DDdF3A655A6985D3Bc97].cap_wei = 5 ether;

        _whitelist[0x69CcA94BfA2c31f20406A7627c79E9160D48d920].cap_wei = 5 ether;

        _whitelist[0x722E895A12d2A11BE99ed69dBc1FEdbB9F3Cd8fe].cap_wei = 5 ether;

        _whitelist[0x75d5CEd39b418D5E25F4A05db87fCC8bCEED7E66].cap_wei = 5 ether;

        _whitelist[0x786c9Fb9494Cc3c82d5a47A62b4392c7004106ca].cap_wei = 5 ether;

        _whitelist[0x78B864A7bcE3888460Ae9793B827cE521AC0d7Bf].cap_wei = 5 ether;

        _whitelist[0x79aCBF17da6520D923673a285955BBBC468dD609].cap_wei = 5 ether;

        _whitelist[0x80718A07353171e4222ADCb9a4177A7976f31b95].cap_wei = 5 ether;

        _whitelist[0x82ED54e38365fC4975F7757a18209E757b701471].cap_wei = 5 ether;

        _whitelist[0x8726E46618D880da56E9004Ad2a845950190822f].cap_wei = 5 ether;

        _whitelist[0x8fE69CBd671d3D035ec61Fc7544A7C1186C63391].cap_wei = 5 ether;

        _whitelist[0x90decb48FE5A0578c669B73cDFbc5ef5eE34D03f].cap_wei = 5 ether;

        _whitelist[0x91Ec59e8cDceB3f26cFdFcd813Db68b3B938bFBE].cap_wei = 5 ether;

        _whitelist[0x943C7b6bB47350BFD8F9D1418903DDc7392a0Fa2].cap_wei = 5 ether;

        _whitelist[0x95a2972bEBb437486C4842940135FAF0Bb845E49].cap_wei = 5 ether;

        _whitelist[0x97Cd05ee9f47c6AbA029c5ed4Fbce8CE817586e3].cap_wei = 5 ether;

        _whitelist[0x98D5731f60565Aa1751A0FA6F8F6E6212a4018C4].cap_wei = 5 ether;

        _whitelist[0x9A8ea427c5CF4490c07428b853A5577c9B7a2d14].cap_wei = 5 ether;

        _whitelist[0x9CBBDA094cc0FA9217b783aCE7F0C103a8265cC4].cap_wei = 5 ether;

        _whitelist[0xA07C79F4b1dA96430F32DcD70AE4C87D583f3181].cap_wei = 5 ether;

        _whitelist[0xa83c572C8072f3b11562F08B89d4F3077682acDB].cap_wei = 5 ether;

        _whitelist[0xAa9c8CBd55ca346294cD2CF45887Df4A27D3c784].cap_wei = 5 ether;

        _whitelist[0xb0cAaef6c1Ee42a01F98C1C0341551609dC8661d].cap_wei = 5 ether;

        _whitelist[0xb43FbDA88534c1F74e161ce81Ee182B860B775eF].cap_wei = 5 ether;

        _whitelist[0xc1DDD17CdFEef5AEFf354C7b0F70B6AE3bFea888].cap_wei = 5 ether;

        _whitelist[0xC86De3146339850EF16bFa66a17Ab103Bf2eD5Cd].cap_wei = 5 ether;

        _whitelist[0xD91E20b917b112C46091A0418b7770f86E00DB4c].cap_wei = 5 ether;

        _whitelist[0xD97756A681E1B43bD86dFb80B60CFCf45378096b].cap_wei = 5 ether;

        _whitelist[0xe0910F9eD63B2eD4aC6b1c65f982387148bF16e9].cap_wei = 5 ether;

        _whitelist[0xe24C2133714B735f7dFf541d4Fb9a101C9aBcb40].cap_wei = 5 ether;

        _whitelist[0xE3E39161d35E9A81edEc667a5387bfAE85752854].cap_wei = 5 ether;

        _whitelist[0xe9A839d0DEb505CBD05AFCB91a9f2fBf016e834c].cap_wei = 5 ether;

        _whitelist[0xf10A6840e2f422c93911F88f19819BD76Ac1D985].cap_wei = 5 ether;

        _whitelist[0xf2C95079E35a27c296B01759431e05c38E392A21].cap_wei = 5 ether;

        _whitelist[0xF35D29406f94972a75641505b7D38E29E6986442].cap_wei = 5 ether;

        _whitelist[0xF3db3eC867909e07F284f79D6c6812cbc992F861].cap_wei = 5 ether;

        _whitelist[0xFC62BF402205e4885B86469e0B64F247046c2cB4].cap_wei = 5 ether;

        _whitelist[0xfF386F6BC71866a84a0c46ebB55Cd543aB10E1C8].cap_wei = 5 ether;

        _whitelist[0x7c60926399ffA6EE58D9C53ca9D6845f983d495a].cap_wei = 5 ether;

        _whitelist[0x747dCCA51350951bA6Fd32603a8da8Dd745E7dA0].cap_wei = 5 ether;

        _whitelist[0xb7E87A5ADc8caCB4565b46fb636403BaC37F39eA].cap_wei = 20 ether;

        _whitelist[0x22C8D09305D827F1CDF696D1b9Ee309227938F95].cap_wei = 20 ether;

        _whitelist[0xf58e98D93AA9141f03a84eEb106077C2AeF7274E].cap_wei = 8 ether;

    }



    receive() external payable {

        _processBuy(msg.sender, msg.value);

    }





    function unlock() external onlyOwner returns (bool) {

        _locked = false;

        _closed = false;

        _starttime = now;

        return true;

    }



    function lock() external onlyOwner returns (bool) {

        _locked = true;

        return true;

    }



    function whitelistAdd(address beneficiary, uint256 allowedEth) external onlyOwner returns (bool) {

        require(allowedEth.mul(1 ether) >= MIN_WEI, 'thats not enough for whitelist');

        _whitelist[beneficiary].cap_wei = allowedEth.mul(1 ether);

        emit AddressWhitelisted(beneficiary, allowedEth);

        return true;

    }



    function buyToken(address beneficiary, uint256 value) external onlyOwner returns (bool) {

        _processBuy(beneficiary, value);

    }



    function raised() public view returns(uint256) {

        return _weiRaised.div(1 ether);

    }



    function rate() public view returns(uint256) {

        return RATE;

    }





    function _processBuy(address beneficiary, uint256 weiAmount) private {

        require(_locked == false, "Presale is locked");

        require(_closed == false, "Presale is closed");

        require(beneficiary != address(0), "Not zero address");

        require(beneficiary != _owner, "Not owner");

        require(weiAmount >= MIN_WEI, "That isnt enought");

        if(_starttime.add(ONLY_LISTED_TIME) > now) {

            require(_isWhitelisted(beneficiary), "You're not listed cowboy, wait a moment");

            require(_getPossibleMaxWei(beneficiary) > 0, "you cant buy more");

            require(_getPossibleMaxWei(beneficiary) >= weiAmount, "Thats too much");

        }



        // calculate token amount

        uint256 tokens = _calcTokenAmount(weiAmount);

        require(tokens <= _tokenBalance, 'not enough tokens available');



        // update state

        _weiRaised = _weiRaised.add(weiAmount);

        _tokenBalance = _tokenBalance.sub(tokens);

        _balances[beneficiary] = _balances[beneficiary].add(tokens);

        _whitelist[beneficiary].claimed_wei = _whitelist[beneficiary].claimed_wei.add(weiAmount);



        if(_tokenBalance <= 0) {

            _closed = true;

            _locked = true;

        }



        emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);



        if(_starttime.add(TOTAL_TIME) < now) {

            _closed = true;

            _locked = true;

        }



        _forwardFunds();

    }



    function getWei() internal view returns (uint256) {

        return _weiRaised;

    }



    function getRemainingToken() public returns (uint256) {

        return _tokenBalance;

    }

    function getBalance(address addr) public returns (uint256) {

        return _balances[addr];

    }

    function getLimit(address addr) public returns (uint256) {

        return _whitelist[addr].cap_wei;

    }



    function _getPossibleMaxWei(address addr) internal view returns (uint256) {

        return _whitelist[addr].cap_wei.sub(_whitelist[addr].claimed_wei);

    }



    function _calcTokenAmount(uint256 weiAmount) internal pure returns (uint256) {

        return weiAmount.mul(RATE).div(1 ether);

    }



    function _isWhitelisted(address candidate) internal view returns(bool) {

        if(_whitelist[candidate].cap_wei > 0) {

            return true;

        }

        return false;

    }





    function _forwardFunds() internal {

        _wallet.transfer(msg.value);

    }



}

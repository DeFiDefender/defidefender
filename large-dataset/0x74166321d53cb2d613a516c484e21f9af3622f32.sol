/**

 *Submitted for verification at Etherscan.io on 2020-02-06

*/



pragma solidity ^0.5.0;





interface ERC20 {

    function totalSupply() external view returns (uint supply);

    function balanceOf(address _owner) external view returns (uint balance);

    function transfer(address _to, uint _value) external returns (bool success);

    function transferFrom(address _from, address _to, uint _value) external returns (bool success);

    function approve(address _spender, uint _value) external returns (bool success);

    function allowance(address _owner, address _spender) external view returns (uint remaining);

    function decimals() external view returns(uint digits);

    event Approval(address indexed _owner, address indexed _spender, uint _value);

}



interface ExchangeInterface {

    function swapEtherToToken (uint _ethAmount, address _tokenAddress, uint _maxAmount) payable external returns(uint, uint);

    function swapTokenToEther (address _tokenAddress, uint _amount, uint _maxAmount) external returns(uint);

    function swapTokenToToken(address _src, address _dest, uint _amount) external payable returns(uint);



    function getExpectedRate(address src, address dest, uint srcQty) external view

        returns (uint expectedRate);

}



contract SaverLogger {

    event Repay(uint indexed cdpId, address indexed owner, uint collateralAmount, uint daiAmount);

    event Boost(uint indexed cdpId, address indexed owner, uint daiAmount, uint collateralAmount);



    function LogRepay(uint _cdpId, address _owner, uint _collateralAmount, uint _daiAmount) public {

        emit Repay(_cdpId, _owner, _collateralAmount, _daiAmount);

    }



    function LogBoost(uint _cdpId, address _owner, uint _daiAmount, uint _collateralAmount) public {

        emit Boost(_cdpId, _owner, _daiAmount, _collateralAmount);

    }

}



contract Discount {



    address public owner;

    mapping (address => CustomServiceFee) public serviceFees;



    uint constant MAX_SERVICE_FEE = 400;



    struct CustomServiceFee {

        bool active;

        uint amount;

    }



    constructor() public {

        owner = msg.sender;

    }



    function isCustomFeeSet(address _user) public view returns (bool) {

        return serviceFees[_user].active;

    }



    function getCustomServiceFee(address _user) public view returns (uint) {

        return serviceFees[_user].amount;

    }



    function setServiceFee(address _user, uint _fee) public {

        require(msg.sender == owner, "Only owner");

        require(_fee >= MAX_SERVICE_FEE || _fee == 0);



        serviceFees[_user] = CustomServiceFee({

            active: true,

            amount: _fee

        });

    }



    function disableServiceFee(address _user) public {

        require(msg.sender == owner, "Only owner");



        serviceFees[_user] = CustomServiceFee({

            active: false,

            amount: 0

        });

    }

}



contract PipInterface {

    function read() public returns (bytes32);

}



contract Spotter {

    struct Ilk {

        PipInterface pip;

        uint256 mat;

    }



    mapping (bytes32 => Ilk) public ilks;



    uint256 public par;



}



contract Jug {

    struct Ilk {

        uint256 duty;

        uint256  rho;

    }



    mapping (bytes32 => Ilk) public ilks;



    function drip(bytes32) public returns (uint);

}



contract Vat {



    struct Urn {

        uint256 ink;   

        uint256 art;   

    }



    struct Ilk {

        uint256 Art;   

        uint256 rate;  

        uint256 spot;  

        uint256 line;  

        uint256 dust;  

    }



    mapping (bytes32 => mapping (address => Urn )) public urns;

    mapping (bytes32 => Ilk)                       public ilks;



    function can(address, address) public view returns (uint);

    function dai(address) public view returns (uint);

    function frob(bytes32, address, address, address, int, int) public;

    function hope(address) public;

    function move(address, address, uint) public;

}



contract Gem {

    function dec() public returns (uint);

    function gem() public returns (Gem);

    function join(address, uint) public payable;

    function exit(address, uint) public;



    function approve(address, uint) public;

    function transfer(address, uint) public returns (bool);

    function transferFrom(address, address, uint) public returns (bool);

    function deposit() public payable;

    function withdraw(uint) public;

    function allowance(address, address) public returns (uint);

}



contract DaiJoin {

    function vat() public returns (Vat);

    function dai() public returns (Gem);

    function join(address, uint) public payable;

    function exit(address, uint) public;

}



contract TokenInterface {

    function allowance(address, address) public returns (uint);

    function balanceOf(address) public returns (uint);

    function approve(address, uint) public;

    function transfer(address, uint) public returns (bool);

    function transferFrom(address, address, uint) public returns (bool);

    function deposit() public payable;

    function withdraw(uint) public;

}



contract SaverExchangeInterface {

    function getBestPrice(uint _amount, address _srcToken, address _destToken, uint _exchangeType) public view returns (address, uint);

}



contract ConstantAddressesExchange {

    address public constant MAKER_DAI_ADDRESS = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;

    address public constant KYBER_ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    address public constant MKR_ADDRESS = 0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2;

    address public constant WETH_ADDRESS = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    address payable public constant WALLET_ID = 0x322d58b9E75a6918f7e7849AEe0fF09369977e08;

    address public constant LOGGER_ADDRESS = 0xeCf88e1ceC2D2894A0295DB3D86Fe7CE4991E6dF;

    address public constant DISCOUNT_ADDRESS = 0x1b14E8D511c9A4395425314f849bD737BAF8208F;



    address public constant GAS_TOKEN_INTERFACE_ADDRESS = 0x0000000000b3F879cb30FE243b4Dfee438691c04;

    address public constant SAVER_EXCHANGE_ADDRESS = 0xC8A48a440315d63d3da8E2d2030f6F6fC6701811;



    

    address public constant MANAGER_ADDRESS = 0x5ef30b9986345249bc32d8928B7ee64DE9435E39;

    address public constant VAT_ADDRESS = 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B;

    address public constant SPOTTER_ADDRESS = 0x65C79fcB50Ca1594B025960e539eD7A9a6D434A3;

    address public constant PROXY_ACTIONS = 0x82ecD135Dce65Fbc6DbdD0e4237E0AF93FFD5038;



    address public constant JUG_ADDRESS = 0x19c0976f590D67707E62397C87829d896Dc0f1F1;

    address public constant DAI_JOIN_ADDRESS = 0x9759A6Ac90977b93B58547b4A71c78317f391A28;

    address public constant ETH_JOIN_ADDRESS = 0x2F0b23f53734252Bda2277357e97e1517d6B042A;

    address public constant MIGRATION_ACTIONS_PROXY = 0xe4B22D484958E582098A98229A24e8A43801b674;



    address public constant SAI_ADDRESS = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;

    address public constant DAI_ADDRESS = 0x6B175474E89094C44Da98b954EedeAC495271d0F;



    address payable public constant SCD_MCD_MIGRATION = 0xc73e0383F3Aff3215E6f04B0331D58CeCf0Ab849;

    

    address public constant NEW_IDAI_ADDRESS = 0x493C57C4763932315A328269E1ADaD09653B9081;

    

    address public constant ERC20_PROXY_0X = 0x95E6F48254609A6ee006F7D493c8e5fB97094ceF;

}



contract ExchangeHelper is ConstantAddressesExchange {



    

    

    

    

    

    

    

    function swap(uint[4] memory _data, address _src, address _dest, address _exchangeAddress, bytes memory _callData) internal returns (uint) {

        address wrapper;

        uint price;

        uint tokensReturned;

        bool success;



        _src = wethToKyberEth(_src);

        _dest = wethToKyberEth(_dest);



        

        if (_data[2] == 4) {

            if (_src != KYBER_ETH_ADDRESS) {

                ERC20(_src).approve(address(ERC20_PROXY_0X), _data[0]);

            }



            (success, tokensReturned) = takeOrder(_exchangeAddress, _callData, address(this).balance, _dest);



            

            require(success && tokensReturned > 0, "0x transaction failed");

        }



        if (tokensReturned == 0) {

            (wrapper, price) = SaverExchangeInterface(SAVER_EXCHANGE_ADDRESS).getBestPrice(_data[0], _src, _dest, _data[2]);



            require(price > _data[1] || _data[3] > _data[1], "Slippage hit");



            

            if (_data[3] >= price) {

                if (_src != KYBER_ETH_ADDRESS) {

                    ERC20(_src).approve(address(ERC20_PROXY_0X), _data[0]);

                }

                (success, tokensReturned) = takeOrder(_exchangeAddress, _callData, address(this).balance, _dest);

            }



            if (tokensReturned == 0) {

                require(price > _data[1], "Slippage hit onchain price");

                if (_src == KYBER_ETH_ADDRESS) {

                    (tokensReturned,) = ExchangeInterface(wrapper).swapEtherToToken.value(_data[0])(_data[0], _dest, uint(-1));

                } else {

                    ERC20(_src).transfer(wrapper, _data[0]);



                    if (_dest == KYBER_ETH_ADDRESS) {

                        tokensReturned = ExchangeInterface(wrapper).swapTokenToEther(_src, _data[0], uint(-1));

                    } else {

                        tokensReturned = ExchangeInterface(wrapper).swapTokenToToken(_src, _dest, _data[0]);

                    }

                }

            }

        }



        return tokensReturned;

    }



    

    

    

    

    

    function takeOrder(address _exchange, bytes memory _data, uint _value, address _dest) private returns(bool, uint) {

        bool success;



        (success, ) = _exchange.call.value(_value)(_data);



        uint tokensReturned = 0;

        if (success){

            if (_dest == KYBER_ETH_ADDRESS) {

                TokenInterface(WETH_ADDRESS).withdraw(TokenInterface(WETH_ADDRESS).balanceOf(address(this)));

                tokensReturned = address(this).balance;

            } else {

                tokensReturned = ERC20(_dest).balanceOf(address(this));

            }

        }



        return (success, tokensReturned);

    }



    

    

    function wethToKyberEth(address _src) internal pure returns (address) {

        return _src == WETH_ADDRESS ? KYBER_ETH_ADDRESS : _src;

    }

}



contract DSMath {

    function add(uint x, uint y) internal pure returns (uint z) {

        require((z = x + y) >= x);

    }

    function sub(uint x, uint y) internal pure returns (uint z) {

        require((z = x - y) <= x);

    }

    function mul(uint x, uint y) internal pure returns (uint z) {

        require(y == 0 || (z = x * y) / y == x);

    }

    function div(uint x, uint y) internal pure returns (uint z) {

        return x / y;

    }



    function min(uint x, uint y) internal pure returns (uint z) {

        return x <= y ? x : y;

    }

    function max(uint x, uint y) internal pure returns (uint z) {

        return x >= y ? x : y;

    }

    function imin(int x, int y) internal pure returns (int z) {

        return x <= y ? x : y;

    }

    function imax(int x, int y) internal pure returns (int z) {

        return x >= y ? x : y;

    }



    uint constant WAD = 10 ** 18;

    uint constant RAY = 10 ** 27;



    function wmul(uint x, uint y) internal pure returns (uint z) {

        z = add(mul(x, y), WAD / 2) / WAD;

    }

    function rmul(uint x, uint y) internal pure returns (uint z) {

        z = add(mul(x, y), RAY / 2) / RAY;

    }

    function wdiv(uint x, uint y) internal pure returns (uint z) {

        z = add(mul(x, WAD), y / 2) / y;

    }

    function rdiv(uint x, uint y) internal pure returns (uint z) {

        z = add(mul(x, RAY), y / 2) / y;

    }



    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    function rpow(uint x, uint n) internal pure returns (uint z) {

        z = n % 2 != 0 ? x : RAY;



        for (n /= 2; n != 0; n /= 2) {

            x = rmul(x, x);



            if (n % 2 != 0) {

                z = rmul(z, x);

            }

        }

    }

}



contract DSAuthority {

    function canCall(

        address src, address dst, bytes4 sig

    ) public view returns (bool);

}



contract DSAuthEvents {

    event LogSetAuthority (address indexed authority);

    event LogSetOwner     (address indexed owner);

}



contract DSAuth is DSAuthEvents {

    DSAuthority  public  authority;

    address      public  owner;



    constructor() public {

        owner = msg.sender;

        emit LogSetOwner(msg.sender);

    }



    function setOwner(address owner_)

        public

        auth

    {

        owner = owner_;

        emit LogSetOwner(owner);

    }



    function setAuthority(DSAuthority authority_)

        public

        auth

    {

        authority = authority_;

        emit LogSetAuthority(address(authority));

    }



    modifier auth {

        require(isAuthorized(msg.sender, msg.sig));

        _;

    }



    function isAuthorized(address src, bytes4 sig) internal view returns (bool) {

        if (src == address(this)) {

            return true;

        } else if (src == owner) {

            return true;

        } else if (authority == DSAuthority(0)) {

            return false;

        } else {

            return authority.canCall(src, address(this), sig);

        }

    }

}



contract DSNote {

    event LogNote(

        bytes4   indexed  sig,

        address  indexed  guy,

        bytes32  indexed  foo,

        bytes32  indexed  bar,

        uint              wad,

        bytes             fax

    ) anonymous;



    modifier note {

        bytes32 foo;

        bytes32 bar;



        assembly {

            foo := calldataload(4)

            bar := calldataload(36)

        }



        emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);



        _;

    }

}



contract DSProxy is DSAuth, DSNote {

    DSProxyCache public cache;  



    constructor(address _cacheAddr) public {

        require(setCache(_cacheAddr));

    }



    function() external payable {

    }



    

    function execute(bytes memory _code, bytes memory _data)

        public

        payable

        returns (address target, bytes32 response)

    {

        target = cache.read(_code);

        if (target == address(0)) {

            

            target = cache.write(_code);

        }



        response = execute(target, _data);

    }



    function execute(address _target, bytes memory _data)

        public

        auth

        note

        payable

        returns (bytes32 response)

    {

        require(_target != address(0));



        

        assembly {

            let succeeded := delegatecall(sub(gas, 5000), _target, add(_data, 0x20), mload(_data), 0, 32)

            response := mload(0)      

            switch iszero(succeeded)

            case 1 {

                

                revert(0, 0)

            }

        }

    }



    

    function setCache(address _cacheAddr)

        public

        payable

        auth

        note

        returns (bool)

    {

        require(_cacheAddr != address(0));        

        cache = DSProxyCache(_cacheAddr);  

        return true;

    }

}



contract DSProxyCache {

    mapping(bytes32 => address) cache;



    function read(bytes memory _code) public view returns (address) {

        bytes32 hash = keccak256(_code);

        return cache[hash];

    }



    function write(bytes memory _code) public returns (address target) {

        assembly {

            target := create(0, add(_code, 0x20), mload(_code))

            switch iszero(extcodesize(target))

            case 1 {

                

                revert(0, 0)

            }

        }

        bytes32 hash = keccak256(_code);

        cache[hash] = target;

    }

}



contract Manager {

    function last(address) public returns (uint);

    function cdpCan(address, uint, address) public view returns (uint);

    function ilks(uint) public view returns (bytes32);

    function owns(uint) public view returns (address);

    function urns(uint) public view returns (address);

    function vat() public view returns (address);

    function open(bytes32, address) public returns (uint);

    function give(uint, address) public;

    function cdpAllow(uint, address, uint) public;

    function urnAllow(address, uint) public;

    function frob(uint, int, int) public;

    function flux(uint, address, uint) public;

    function move(uint, address, uint) public;

    function exit(address, uint, address, uint) public;

    function quit(uint, address) public;

    function enter(address, uint) public;

    function shift(uint, uint) public;

}



contract Join {

    bytes32 public ilk;



    function dec() public returns (uint);

    function gem() public returns (Gem);

    function join(address, uint) public payable;

    function exit(address, uint) public;

}



contract SaverProxyHelper is DSMath {



    

    

    

    

    function normalizeDrawAmount(uint _amount, uint _rate, uint _daiVatBalance) internal pure returns (int dart) {

        if (_daiVatBalance < mul(_amount, RAY)) {

            dart = toPositiveInt(sub(mul(_amount, RAY), _daiVatBalance) / _rate);

            dart = mul(uint(dart), _rate) < mul(_amount, RAY) ? dart + 1 : dart;

        }

    }



    

    

    function toRad(uint _wad) internal pure returns (uint) {

        return mul(_wad, 10 ** 27);

    }



    

    

    

    function convertTo18(address _joinAddr, uint256 _amount) internal returns (uint256) {

        return mul(_amount, 10 ** (18 - Join(_joinAddr).dec()));

    }



    

    

    function toPositiveInt(uint _x) internal pure returns (int y) {

        y = int(_x);

        require(y >= 0, "int-overflow");

    }



    

    

    

    

    function normalizePaybackAmount(address _vat, address _urn, bytes32 _ilk) internal view returns (int amount) {

        uint dai = Vat(_vat).dai(_urn);



        (, uint rate,,,) = Vat(_vat).ilks(_ilk);

        (, uint art) = Vat(_vat).urns(_ilk, _urn);



        amount = toPositiveInt(dai / rate);

        amount = uint(amount) <= art ? - amount : - toPositiveInt(art);

    }



    

    

    

    

    

    function getAllDebt(address _vat, address _usr, address _urn, bytes32 _ilk) internal view returns (uint daiAmount) {

        (, uint rate,,,) = Vat(_vat).ilks(_ilk);

        (, uint art) = Vat(_vat).urns(_ilk, _urn);

        uint dai = Vat(_vat).dai(_usr);



        uint rad = sub(mul(art, rate), dai);

        daiAmount = rad / RAY;



        daiAmount = mul(daiAmount, RAY) < rad ? daiAmount + 1 : daiAmount;

    }



    

    

    function getCollateralAddr(address _joinAddr) internal returns (address) {

        return address(Join(_joinAddr).gem());

    }



    

    

    

    

    function getCdpInfo(Manager _manager, uint _cdpId, bytes32 _ilk) public view returns (uint, uint) {

        address vat = _manager.vat();

        address urn = _manager.urns(_cdpId);



        (uint collateral, uint debt) = Vat(vat).urns(_ilk, urn);

        (,uint rate,,,) = Vat(vat).ilks(_ilk);



        return (collateral, rmul(debt, rate));

    }



    

    

    

    function getOwner(Manager _manager, uint _cdpId) public view returns (address) {

        DSProxy proxy = DSProxy(uint160(_manager.owns(_cdpId)));



        return proxy.owner();

    }

}



contract MCDSaverProxy is SaverProxyHelper, ExchangeHelper {



    uint public constant SERVICE_FEE = 400; 

    bytes32 public constant ETH_ILK = 0x4554482d41000000000000000000000000000000000000000000000000000000;



    Manager public constant manager = Manager(MANAGER_ADDRESS);

    Vat public constant vat = Vat(VAT_ADDRESS);

    DaiJoin public constant daiJoin = DaiJoin(DAI_JOIN_ADDRESS);

    Spotter public constant spotter = Spotter(SPOTTER_ADDRESS);



    

    

    modifier boostCheck(uint _cdpId) {

        bytes32 ilk = manager.ilks(_cdpId);

        address urn = manager.urns(_cdpId);



        (uint collateralBefore, ) = vat.urns(ilk, urn);



        _;



        (uint collateralAfter, ) = vat.urns(ilk, urn);



        require(collateralAfter > collateralBefore);

    }



    

    

    modifier repayCheck(uint _cdpId) {

        bytes32 ilk = manager.ilks(_cdpId);



        uint beforeRatio = getRatio(_cdpId, ilk);



        _;



        uint afterRatio = getRatio(_cdpId, ilk);



        require(afterRatio > beforeRatio || afterRatio == 0);

    }



    

    

    

    

    

    

    function repay(

        

        uint[6] memory _data,

        address _joinAddr,

        address _exchangeAddress,

        bytes memory _callData

    ) public payable repayCheck(_data[0]) {



        address owner = getOwner(manager, _data[0]);

        bytes32 ilk = manager.ilks(_data[0]);



        

        

        

        uint[3] memory temp;



        temp[0] = drawCollateral(_data[0], ilk, _joinAddr, _data[1]);



                                

        uint[4] memory swapData = [temp[0], _data[2], _data[3], _data[5]];

        temp[1] = swap(swapData, getCollateralAddr(_joinAddr), DAI_ADDRESS, _exchangeAddress, _callData);

        temp[2] = sub(temp[1], getFee(temp[1], _data[4], owner));



        paybackDebt(_data[0], ilk, temp[2], owner);



        SaverLogger(LOGGER_ADDRESS).LogRepay(_data[0], owner, temp[0], temp[1]);

    }



    

    

    

    

    

    

    function boost(

        

        uint[6] memory _data,

        address _joinAddr,

        address _exchangeAddress,

        bytes memory _callData

    ) public payable boostCheck(_data[0]) {

        address owner = getOwner(manager, _data[0]);

        bytes32 ilk = manager.ilks(_data[0]);



        

        

        

        uint[3] memory temp;



        temp[0] = drawDai(_data[0], ilk, _data[1]);

        temp[1] = sub(temp[0], getFee(temp[0], _data[4], owner));

                                

        uint[4] memory swapData = [temp[1], _data[2], _data[3], _data[5]];

        temp[2] = swap(swapData, DAI_ADDRESS, getCollateralAddr(_joinAddr), _exchangeAddress, _callData);



        addCollateral(_data[0], _joinAddr, temp[2]);



        SaverLogger(LOGGER_ADDRESS).LogBoost(_data[0], owner, temp[0], temp[2]);

    }



    

    

    

    

    

    function drawDai(uint _cdpId, bytes32 _ilk, uint _daiAmount) internal returns (uint) {

        uint rate = Jug(JUG_ADDRESS).drip(_ilk);

        uint daiVatBalance = vat.dai(manager.urns(_cdpId));



        uint maxAmount = getMaxDebt(_cdpId, _ilk);



        if (_daiAmount >= maxAmount) {

            _daiAmount = sub(maxAmount, 1);

        }



        manager.frob(_cdpId, int(0), normalizeDrawAmount(_daiAmount, rate, daiVatBalance));

        manager.move(_cdpId, address(this), toRad(_daiAmount));



        if (vat.can(address(this), address(DAI_JOIN_ADDRESS)) == 0) {

            vat.hope(DAI_JOIN_ADDRESS);

        }



        DaiJoin(DAI_JOIN_ADDRESS).exit(address(this), _daiAmount);



        return _daiAmount;

    }



    

    

    

    

    function addCollateral(uint _cdpId, address _joinAddr, uint _amount) internal {

        int convertAmount = 0;



        if (_joinAddr == ETH_JOIN_ADDRESS) {

            Join(_joinAddr).gem().deposit.value(_amount)();

            convertAmount = toPositiveInt(_amount);

        } else {

            convertAmount = toPositiveInt(convertTo18(_joinAddr, _amount));

        }



        Join(_joinAddr).gem().approve(_joinAddr, _amount);

        Join(_joinAddr).join(address(this), _amount);



        vat.frob(

            manager.ilks(_cdpId),

            manager.urns(_cdpId),

            address(this),

            address(this),

            convertAmount,

            0

        );



    }



    

    

    

    

    

    

    function drawCollateral(uint _cdpId, bytes32 _ilk, address _joinAddr, uint _amount) internal returns (uint) {

        uint maxCollateral = getMaxCollateral(_cdpId, _ilk);



        if (_amount >= maxCollateral) {

            _amount = sub(maxCollateral, 1);

        }



        manager.frob(_cdpId, -toPositiveInt(_amount), 0);

        manager.flux(_cdpId, address(this), _amount);



        Join(_joinAddr).exit(address(this), _amount);



        if (_joinAddr == ETH_JOIN_ADDRESS) {

            Join(_joinAddr).gem().withdraw(_amount); 

        }



        return _amount;

    }



    

    

    

    

    

    

    function paybackDebt(uint _cdpId, bytes32 _ilk, uint _daiAmount, address _owner) internal {

        address urn = manager.urns(_cdpId);



        uint wholeDebt = getAllDebt(VAT_ADDRESS, urn, urn, _ilk);



        if (_daiAmount > wholeDebt) {

            ERC20(DAI_ADDRESS).transfer(_owner, sub(_daiAmount, wholeDebt));

            _daiAmount = wholeDebt;

        }



        daiJoin.dai().approve(DAI_JOIN_ADDRESS, _daiAmount);

        daiJoin.join(urn, _daiAmount);



        manager.frob(_cdpId, 0, normalizePaybackAmount(VAT_ADDRESS, urn, _ilk));

    }



    

    

    

    

    function getFee(uint _amount, uint _gasCost, address _owner) internal returns (uint feeAmount) {

        uint fee = SERVICE_FEE;



        if (Discount(DISCOUNT_ADDRESS).isCustomFeeSet(_owner)) {

            fee = Discount(DISCOUNT_ADDRESS).getCustomServiceFee(_owner);

        }



        feeAmount = (fee == 0) ? 0 : (_amount / fee);



        if (_gasCost != 0) {

            uint ethDaiPrice = getPrice(ETH_ILK);

            _gasCost = rmul(_gasCost, ethDaiPrice);



            feeAmount = add(feeAmount, _gasCost);

        }



        

        if (feeAmount > (_amount / 5)) {

            feeAmount = _amount / 5;

        }



        ERC20(DAI_ADDRESS).transfer(WALLET_ID, feeAmount);

    }



    

    

    

    

    function getMaxCollateral(uint _cdpId, bytes32 _ilk) public view returns (uint) {

        uint price = getPrice(_ilk);



        (uint collateral, uint debt) = getCdpInfo(manager, _cdpId, _ilk);



        (, uint mat) = Spotter(SPOTTER_ADDRESS).ilks(_ilk);



        return sub(sub(collateral, (div(mul(mat, debt), price))), 10);

    }



    

    

    

    

    function getMaxDebt(uint _cdpId, bytes32 _ilk) public view returns (uint) {

        uint price = getPrice(_ilk);



        (, uint mat) = spotter.ilks(_ilk);

        (uint collateral, uint debt) = getCdpInfo(manager, _cdpId, _ilk);



        return sub(sub(div(mul(collateral, price), mat), debt), 10);

    }



    

    

    function getPrice(bytes32 _ilk) public view returns (uint) {

        (, uint mat) = spotter.ilks(_ilk);

        (,,uint spot,,) = vat.ilks(_ilk);



        return rmul(rmul(spot, spotter.par()), mat);

    }



    

    

    

    function getRatio(uint _cdpId, bytes32 _ilk) public view returns (uint) {

        uint price = getPrice( _ilk);



        (uint collateral, uint debt) = getCdpInfo(manager, _cdpId, _ilk);



        if (debt == 0) return 0;



        return rdiv(wmul(collateral, price), debt);

    }



    

    

    function getCdpDetailedInfo(uint _cdpId) public view returns (uint collateral, uint debt, uint price, bytes32 ilk) {

        address urn = manager.urns(_cdpId);

        ilk = manager.ilks(_cdpId);



        (collateral, debt) = vat.urns(ilk, urn);

        (,uint rate,,,) = vat.ilks(ilk);



        debt = rmul(debt, rate);

        price = getPrice(ilk);

    }



}



contract GemLike {

    function approve(address, uint) public;

    function transfer(address, uint) public;

    function transferFrom(address, address, uint) public;

    function deposit() public payable;

    function withdraw(uint) public;

}



contract ManagerLike {

    function cdpCan(address, uint, address) public view returns (uint);

    function ilks(uint) public view returns (bytes32);

    function owns(uint) public view returns (address);

    function urns(uint) public view returns (address);

    function vat() public view returns (address);

    function open(bytes32, address) public returns (uint);

    function give(uint, address) public;

    function cdpAllow(uint, address, uint) public;

    function urnAllow(address, uint) public;

    function frob(uint, int, int) public;

    function flux(uint, address, uint) public;

    function move(uint, address, uint) public;

    function exit(address, uint, address, uint) public;

    function quit(uint, address) public;

    function enter(address, uint) public;

    function shift(uint, uint) public;

}



contract VatLike {

    function can(address, address) public view returns (uint);

    function ilks(bytes32) public view returns (uint, uint, uint, uint, uint);

    function dai(address) public view returns (uint);

    function urns(bytes32, address) public view returns (uint, uint);

    function frob(bytes32, address, address, address, int, int) public;

    function hope(address) public;

    function move(address, address, uint) public;

}



contract GemJoinLike {

    function dec() public returns (uint);

    function gem() public returns (GemLike);

    function join(address, uint) public payable;

    function exit(address, uint) public;

}



contract GNTJoinLike {

    function bags(address) public view returns (address);

    function make(address) public returns (address);

}



contract DaiJoinLike {

    function vat() public returns (VatLike);

    function dai() public returns (GemLike);

    function join(address, uint) public payable;

    function exit(address, uint) public;

}



contract HopeLike {

    function hope(address) public;

    function nope(address) public;

}



contract ProxyRegistryInterface {

    function build(address) public returns (address);

}



contract EndLike {

    function fix(bytes32) public view returns (uint);

    function cash(bytes32, uint) public;

    function free(bytes32) public;

    function pack(uint) public;

    function skim(bytes32, address) public;

}



contract JugLike {

    function drip(bytes32) public returns (uint);

}



contract PotLike {

    function pie(address) public view returns (uint);

    function drip() public returns (uint);

    function join(uint) public;

    function exit(uint) public;

}



contract ProxyRegistryLike {

    function proxies(address) public view returns (address);

    function build(address) public returns (address);

}



contract ProxyLike {

    function owner() public view returns (address);

}





// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

// WARNING: These functions meant to be used as a a library for a DSProxy. Some are unsafe if you call them directly.

// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!



contract Common {

    uint256 constant RAY = 10 ** 27;



    // Internal functions



    function mul(uint x, uint y) internal pure returns (uint z) {

        require(y == 0 || (z = x * y) / y == x, "mul-overflow");

    }



    // Public functions



    function daiJoin_join(address apt, address urn, uint wad) public {

        // Gets DAI from the user's wallet

        DaiJoinLike(apt).dai().transferFrom(msg.sender, address(this), wad);

        // Approves adapter to take the DAI amount

        DaiJoinLike(apt).dai().approve(apt, wad);

        // Joins DAI into the vat

        DaiJoinLike(apt).join(urn, wad);

    }

}



contract MCDOpenProxyActions is Common {



    // Internal functions



    function sub(uint x, uint y) internal pure returns (uint z) {

        require((z = x - y) <= x, "sub-overflow");

    }



    function toInt(uint x) internal pure returns (int y) {

        y = int(x);

        require(y >= 0, "int-overflow");

    }



    function toRad(uint wad) internal pure returns (uint rad) {

        rad = mul(wad, 10 ** 27);

    }



    function convertTo18(address gemJoin, uint256 amt) internal returns (uint256 wad) {

        // For those collaterals that have less than 18 decimals precision we need to do the conversion before passing to frob function

        // Adapters will automatically handle the difference of precision

        wad = mul(

            amt,

            10 ** (18 - GemJoinLike(gemJoin).dec())

        );

    }



    function _getDrawDart(

        address vat,

        address jug,

        address urn,

        bytes32 ilk,

        uint wad

    ) internal returns (int dart) {

        // Updates stability fee rate

        uint rate = JugLike(jug).drip(ilk);



        // Gets DAI balance of the urn in the vat

        uint dai = VatLike(vat).dai(urn);



        // If there was already enough DAI in the vat balance, just exits it without adding more debt

        if (dai < mul(wad, RAY)) {

            // Calculates the needed dart so together with the existing dai in the vat is enough to exit wad amount of DAI tokens

            dart = toInt(sub(mul(wad, RAY), dai) / rate);

            // This is neeeded due lack of precision. It might need to sum an extra dart wei (for the given DAI wad amount)

            dart = mul(uint(dart), rate) < mul(wad, RAY) ? dart + 1 : dart;

        }

    }



    function _getWipeDart(

        address vat,

        uint dai,

        address urn,

        bytes32 ilk

    ) internal view returns (int dart) {

        // Gets actual rate from the vat

        (, uint rate,,,) = VatLike(vat).ilks(ilk);

        // Gets actual art value of the urn

        (, uint art) = VatLike(vat).urns(ilk, urn);



        // Uses the whole dai balance in the vat to reduce the debt

        dart = toInt(dai / rate);

        // Checks the calculated dart is not higher than urn.art (total debt), otherwise uses its value

        dart = uint(dart) <= art ? - dart : - toInt(art);

    }



    function _getWipeAllWad(

        address vat,

        address usr,

        address urn,

        bytes32 ilk

    ) internal view returns (uint wad) {

        // Gets actual rate from the vat

        (, uint rate,,,) = VatLike(vat).ilks(ilk);

        // Gets actual art value of the urn

        (, uint art) = VatLike(vat).urns(ilk, urn);

        // Gets actual dai amount in the urn

        uint dai = VatLike(vat).dai(usr);



        uint rad = sub(mul(art, rate), dai);

        wad = rad / RAY;



        // If the rad precision has some dust, it will need to request for 1 extra wad wei

        wad = mul(wad, RAY) < rad ? wad + 1 : wad;

    }



    // Public functions



    function transfer(address gem, address dst, uint wad) public {

        GemLike(gem).transfer(dst, wad);

    }



    function ethJoin_join(address apt, address urn) public payable {

        // Wraps ETH in WETH

        GemJoinLike(apt).gem().deposit.value(msg.value)();

        // Approves adapter to take the WETH amount

        GemJoinLike(apt).gem().approve(address(apt), msg.value);

        // Joins WETH collateral into the vat

        GemJoinLike(apt).join(urn, msg.value);

    }



    function gemJoin_join(address apt, address urn, uint wad, bool transferFrom) public {

        // Only executes for tokens that have approval/transferFrom implementation

        if (transferFrom) {

            // Gets token from the user's wallet

            GemJoinLike(apt).gem().transferFrom(msg.sender, address(this), wad);

            // Approves adapter to take the token amount

            GemJoinLike(apt).gem().approve(apt, wad);

        }

        // Joins token collateral into the vat

        GemJoinLike(apt).join(urn, wad);

    }



    function hope(

        address obj,

        address usr

    ) public {

        HopeLike(obj).hope(usr);

    }



    function nope(

        address obj,

        address usr

    ) public {

        HopeLike(obj).nope(usr);

    }



    function open(

        address manager,

        bytes32 ilk,

        address usr

    ) public returns (uint cdp) {

        cdp = ManagerLike(manager).open(ilk, usr);

    }



    function give(

        address manager,

        uint cdp,

        address usr

    ) public {

        ManagerLike(manager).give(cdp, usr);

    }



    function move(

        address manager,

        uint cdp,

        address dst,

        uint rad

    ) public {

        ManagerLike(manager).move(cdp, dst, rad);

    }



    function frob(

        address manager,

        uint cdp,

        int dink,

        int dart

    ) public {

        ManagerLike(manager).frob(cdp, dink, dart);

    }



    function lockETH(

        address manager,

        address ethJoin,

        uint cdp

    ) public payable {

        // Receives ETH amount, converts it to WETH and joins it into the vat

        ethJoin_join(ethJoin, address(this));

        // Locks WETH amount into the CDP

        VatLike(ManagerLike(manager).vat()).frob(

            ManagerLike(manager).ilks(cdp),

            ManagerLike(manager).urns(cdp),

            address(this),

            address(this),

            toInt(msg.value),

            0

        );

    }



    function lockGem(

        address manager,

        address gemJoin,

        uint cdp,

        uint wad,

        bool transferFrom

    ) public {

        // Takes token amount from user's wallet and joins into the vat

        gemJoin_join(gemJoin, address(this), wad, transferFrom);

        // Locks token amount into the CDP

        VatLike(ManagerLike(manager).vat()).frob(

            ManagerLike(manager).ilks(cdp),

            ManagerLike(manager).urns(cdp),

            address(this),

            address(this),

            toInt(convertTo18(gemJoin, wad)),

            0

        );



    }





    function draw(

        address manager,

        address jug,

        address daiJoin,

        uint cdp,

        uint wad

    ) public {

        address urn = ManagerLike(manager).urns(cdp);

        address vat = ManagerLike(manager).vat();

        bytes32 ilk = ManagerLike(manager).ilks(cdp);

        // Generates debt in the CDP

        frob(manager, cdp, 0, _getDrawDart(vat, jug, urn, ilk, wad));

        // Moves the DAI amount (balance in the vat in rad) to proxy's address

        move(manager, cdp, address(this), toRad(wad));

        // Allows adapter to access to proxy's DAI balance in the vat

        if (VatLike(vat).can(address(this), address(daiJoin)) == 0) {

            VatLike(vat).hope(daiJoin);

        }

        // Exits DAI to the user's wallet as a token

        DaiJoinLike(daiJoin).exit(msg.sender, wad);



    }



    function lockETHAndDraw(

        address manager,

        address jug,

        address ethJoin,

        address daiJoin,

        uint cdp,

        uint wadD

    ) public payable {

        address urn = ManagerLike(manager).urns(cdp);

        address vat = ManagerLike(manager).vat();

        bytes32 ilk = ManagerLike(manager).ilks(cdp);

        // Receives ETH amount, converts it to WETH and joins it into the vat

        ethJoin_join(ethJoin, urn);

        // Locks WETH amount into the CDP and generates debt

        frob(manager, cdp, toInt(msg.value), _getDrawDart(vat, jug, urn, ilk, wadD));

        // Moves the DAI amount (balance in the vat in rad) to proxy's address

        move(manager, cdp, address(this), toRad(wadD));

        // Allows adapter to access to proxy's DAI balance in the vat

        if (VatLike(vat).can(address(this), address(daiJoin)) == 0) {

            VatLike(vat).hope(daiJoin);

        }

        // Exits DAI to the user's wallet as a token

        DaiJoinLike(daiJoin).exit(msg.sender, wadD);

    }



    function openLockETHAndDraw(

        address manager,

        address jug,

        address ethJoin,

        address daiJoin,

        bytes32 ilk,

        uint wadD,

        address owner

    ) public payable returns (uint cdp) {

        cdp = open(manager, ilk, address(this));

        lockETHAndDraw(manager, jug, ethJoin, daiJoin, cdp, wadD);

        give(manager, cdp, owner);



    }



    function lockGemAndDraw(

        address manager,

        address jug,

        address gemJoin,

        address daiJoin,

        uint cdp,

        uint wadC,

        uint wadD,

        bool transferFrom

    ) public {

        address urn = ManagerLike(manager).urns(cdp);

        address vat = ManagerLike(manager).vat();

        bytes32 ilk = ManagerLike(manager).ilks(cdp);

        // Takes token amount from user's wallet and joins into the vat

        gemJoin_join(gemJoin, urn, wadC, transferFrom);

        // Locks token amount into the CDP and generates debt

        frob(manager, cdp, toInt(convertTo18(gemJoin, wadC)), _getDrawDart(vat, jug, urn, ilk, wadD));

        // Moves the DAI amount (balance in the vat in rad) to proxy's address

        move(manager, cdp, address(this), toRad(wadD));

        // Allows adapter to access to proxy's DAI balance in the vat

        if (VatLike(vat).can(address(this), address(daiJoin)) == 0) {

            VatLike(vat).hope(daiJoin);

        }

        // Exits DAI to the user's wallet as a token

        DaiJoinLike(daiJoin).exit(msg.sender, wadD);



    }



    function openLockGemAndDraw(

        address manager,

        address jug,

        address gemJoin,

        address daiJoin,

        bytes32 ilk,

        uint wadC,

        uint wadD,

        bool transferFrom,

        address owner

    ) public returns (uint cdp) {

        cdp = open(manager, ilk, address(this));

        lockGemAndDraw(manager, jug, gemJoin, daiJoin, cdp, wadC, wadD, transferFrom);

        give(manager, cdp, owner);

    }



}





contract MCDOpenFlashProxy is MCDSaverProxy {



    Manager public constant manager = Manager(MANAGER_ADDRESS);



    address public constant OPEN_PROXY_ACTIONS = 0x6d0984E80a86f26c0dd564ca0CF74a8E9Da03305;



    function openAndLeverage(

        uint[6] memory _data,

        bytes32 _ilk,

        address[3] memory addrData, // [_collJoin, _exchangeAddress, _proxy]

        bytes memory _callData,

        bool _isEth

    ) public {



        // Exchange the Dai loaned to Eth

        uint collSwaped = swap([_data[1], _data[2], _data[3], _data[4]],

             DAI_ADDRESS, getCollateralAddr(addrData[0]), addrData[1], _callData);



        if (_isEth) {

            MCDOpenProxyActions(OPEN_PROXY_ACTIONS).openLockETHAndDraw.value(address(this).balance)(

                address(manager),

                JUG_ADDRESS,

                ETH_JOIN_ADDRESS,

                DAI_JOIN_ADDRESS,

                _ilk,

                _data[1],

                addrData[2]

            );

        } else {



            ERC20(getCollateralAddr(addrData[0])).approve(OPEN_PROXY_ACTIONS, uint(-1));



            MCDOpenProxyActions(OPEN_PROXY_ACTIONS).openLockGemAndDraw(

                address(manager),

                JUG_ADDRESS,

                addrData[0],

                DAI_JOIN_ADDRESS,

                _ilk,

                _data[0],

                _data[1],

                true,

                addrData[2]

            );

        }



         // Repay debt

        ERC20(DAI_ADDRESS).transfer(address(NEW_IDAI_ADDRESS), _data[1]);



    }



    function() external payable {}

}

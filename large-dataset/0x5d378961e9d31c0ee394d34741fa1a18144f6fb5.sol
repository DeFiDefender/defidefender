pragma solidity 0.5.4;



contract DSAuthority {

    function canCall(

        address src, address dst, bytes4 sig

    ) public view returns (bool);

}



contract DSAuthEvents {

    event LogSetAuthority (address indexed authority);

    event LogSetOwner     (address indexed owner);

    event OwnerUpdate     (address indexed owner, address indexed newOwner);

}



contract DSAuth is DSAuthEvents {

    DSAuthority  public  authority;

    address      public  owner;

    address      public  newOwner;



    constructor() public {

        owner = msg.sender;

        emit LogSetOwner(msg.sender);

    }



    // Warning: you should absolutely sure you want to give up authority!!!

    function disableOwnership() public onlyOwner {

        owner = address(0);

        emit OwnerUpdate(msg.sender, owner);

    }



    function transferOwnership(address newOwner_) public onlyOwner {

        require(newOwner_ != owner, "TransferOwnership: the same owner.");

        newOwner = newOwner_;

    }



    function acceptOwnership() public {

        require(msg.sender == newOwner, "AcceptOwnership: only new owner do this.");

        emit OwnerUpdate(owner, newOwner);

        owner = newOwner;

        newOwner = address(0x0);

    }



    ///[snow] guard is Authority who inherit DSAuth.

    function setAuthority(DSAuthority authority_)

        public

        onlyOwner

    {

        authority = authority_;

        emit LogSetAuthority(address(authority));

    }



    modifier onlyOwner {

        require(isOwner(msg.sender), "ds-auth-non-owner");

        _;

    }



    function isOwner(address src) internal view returns (bool) {

        return bool(src == owner);

    }



    modifier auth {

        require(isAuthorized(msg.sender, msg.sig), "ds-auth-unauthorized");

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



contract DSMath {

    function add(uint x, uint y) internal pure returns (uint z) {

        require((z = x + y) >= x, "ds-math-add-overflow");

    }

    function sub(uint x, uint y) internal pure returns (uint z) {

        require((z = x - y) <= x, "ds-math-sub-underflow");

    }

    function mul(uint x, uint y) internal pure returns (uint z) {

        require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");

    }



    function div(uint x, uint y) internal pure returns (uint z) {

        require(y > 0, "ds-math-div-overflow");

        z = x / y;

    }



    function min(uint x, uint y) internal pure returns (uint z) {

        return x <= y ? x : y;

    }

    function max(uint x, uint y) internal pure returns (uint z) {

        return x >= y ? x : y;

    }

    // function imin(int x, int y) internal pure returns (int z) {

    //     return x <= y ? x : y;

    // }

    // function imax(int x, int y) internal pure returns (int z) {

    //     return x >= y ? x : y;

    // }



    uint constant WAD = 10 ** 18;

    // uint constant RAY = 10 ** 27;



    // function wmul(uint x, uint y) internal pure returns (uint z) {

    //     z = add(mul(x, y), WAD / 2) / WAD;

    // }

    // function rmul(uint x, uint y) internal pure returns (uint z) {

    //     z = add(mul(x, y), RAY / 2) / RAY;

    // }

    function wdiv(uint x, uint y) internal pure returns (uint z) {

        z = add(mul(x, WAD), y / 2) / y;

    }

    // function rdiv(uint x, uint y) internal pure returns (uint z) {

    //     z = add(mul(x, RAY), y / 2) / y;

    // }



    // This famous algorithm is called "exponentiation by squaring"

    // and calculates x^n with x as fixed-point and n as regular unsigned.

    //

    // It's O(log n), instead of O(n) for naive repeated multiplication.

    //

    // These facts are why it works:

    //

    //  If n is even, then x^n = (x^2)^(n/2).

    //  If n is odd,  then x^n = x * x^(n-1),

    //   and applying the equation for even x gives

    //    x^n = x * (x^2)^((n-1) / 2).

    //

    //  Also, EVM division is flooring and

    //    floor[(n-1) / 2] = floor[n / 2].

    //

    // function rpow(uint _x, uint n) internal pure returns (uint z) {

    //     uint x = _x;

    //     z = n % 2 != 0 ? x : RAY;



    //     for (n /= 2; n != 0; n /= 2) {

    //         x = rmul(x, x);



    //         if (n % 2 != 0) {

    //             z = rmul(z, x);

    //         }

    //     }

    // }



    /**

     * @dev x to the power of y power(base, exponent)

     */

    function pow(uint256 base, uint256 exponent) public pure returns (uint256) {

        if (exponent == 0) {

            return 1;

        }

        else if (exponent == 1) {

            return base;

        }

        else if (base == 0 && exponent != 0) {

            return 0;

        }

        else {

            uint256 z = base;

            for (uint256 i = 1; i < exponent; i++)

                z = mul(z, base);

            return z;

        }

    }

}



interface ITargetHandler {

  function setDispatcher (address _dispatcher) external;

  function deposit(uint256 _amountss) external returns (uint256); // token deposit

  function withdraw(uint256 _amounts) external returns (uint256);

  function withdrawProfit() external returns (uint256);

  function drainFunds() external returns (uint256);

  function getBalance() external view  returns (uint256);

  function getPrinciple() external view  returns (uint256);

  function getProfit() external view  returns (uint256);

  function getTargetAddress() external view  returns (address);

  function getToken() external view  returns (address);

  function getDispatcher() external view  returns (address);

}



interface IDispatcher {



  // external function

  function trigger() external returns (bool);

  function withdrawProfit() external returns (bool);

  function drainFunds(uint256 _index) external returns (bool);

  function refundDispather(address _receiver) external returns (bool);



  // get function

  function getReserve() external view returns (uint256);

  function getReserveRatio() external view returns (uint256);

  function getPrinciple() external view returns (uint256);

  function getBalance() external view returns (uint256);

  function getProfit() external view returns (uint256);

  function getTHPrinciple(uint256 _index) external view returns (uint256);

  function getTHBalance(uint256 _index) external view returns (uint256);

  function getTHProfit(uint256 _index) external view returns (uint256);

  function getToken() external view returns (address);

  function getFund() external view returns (address);

  function getTHStructures() external view returns (uint256[] memory, address[] memory, address[] memory);

  function getTHData(uint256 _index) external view returns (uint256, uint256, uint256, uint256);

  function getTHCount() external view returns (uint256);

  function getTHAddress(uint256 _index) external view returns (address);

  function getTargetAddress(uint256 _index) external view returns (address);

  function getPropotion() external view returns (uint256[] memory);

  function getProfitBeneficiary() external view returns (address);

  function getReserveUpperLimit() external view returns (uint256);

  function getReserveLowerLimit() external view returns (uint256);

  function getExecuteUnit() external view returns (uint256);



  // Governmence Functions

  function setAimedPropotion(uint256[] calldata _thPropotion) external returns (bool);

  function addTargetHandler(address _targetHandlerAddr, uint256[] calldata _thPropotion) external returns (bool);

  function removeTargetHandler(address _targetHandlerAddr, uint256 _index, uint256[] calldata _thPropotion) external returns (bool);

  function setProfitBeneficiary(address _profitBeneficiary) external returns (bool);

  function setReserveLowerLimit(uint256 _number) external returns (bool);

  function setReserveUpperLimit(uint256 _number) external returns (bool);

  function setExecuteUnit(uint256 _number) external returns (bool);

}



interface IERC20 {

    function balanceOf(address _owner) external view returns (uint);

    function allowance(address _owner, address _spender) external view returns (uint);

    function transfer(address _to, uint _value) external returns (bool success);

    function transferFrom(address _from, address _to, uint _value) external returns (bool success);

    function approve(address _spender, uint _value) external returns (bool success);

    function totalSupply() external view returns (uint);

}



interface ILendFMe {

  function supply(address _token, uint _amounts) external returns (uint);

  function withdraw(address _token, uint _amounts) external returns (uint);

  function getSupplyBalance(address _user, address _token) external view returns (uint256);

}



contract lendFMeHandler is ITargetHandler, DSAuth, DSMath {



    event WithdrawFailed(uint256 _amounts);



  address targetAddr;

  address token;

  address dispatcher;

  uint256 principle;



  constructor (address _targetAddr, address _token) public {

    targetAddr = _targetAddr;

    token = _token;

    IERC20(token).approve(_targetAddr, uint256(-1));

  }





  function setDispatcher(address _dispatcher) external auth {

    dispatcher = _dispatcher;

  }



  // token deposit

  function deposit(uint256 _amounts) external auth returns (uint256) {

    if (IERC20(token).balanceOf(address(this)) >= _amounts) {

      if(ILendFMe(targetAddr).supply(address(token), _amounts) == 0) {

        principle = add(principle, _amounts);

        return 0;

      }

    }

    return 1;

  }



  function withdraw(uint256 _amounts) external auth returns (uint256){

    if(_amounts != 0 && ILendFMe(targetAddr).withdraw(address(token), _amounts) != 0) {

      return 1;

    }

    IERC20(token).transfer(IDispatcher(dispatcher).getFund(), _amounts);

    principle = sub(principle, _amounts);

    return 0;

  }



  function withdrawProfit() external auth returns (uint256){

    uint256 _amount = getProfit();

    if (_amount > 0 && ILendFMe(targetAddr).withdraw(address(token), _amount) == 0) {

      IERC20(token).transfer(IDispatcher(dispatcher).getProfitBeneficiary(), _amount);

      return 0;

    }

    return 1;

  }



  function drainFunds() external auth returns (uint256) {

    uint256 amount = getBalance();

    if(amount > 0) {

      ILendFMe(targetAddr).withdraw(address(token), uint256(-1));

      if(principle > 0){

        IERC20(token).transfer(IDispatcher(dispatcher).getFund(), principle);

        principle = 0;

      }

    }



    uint256 profit = IERC20(token).balanceOf(address(this));

    if(profit > 0) {

      IERC20(token).transfer(IDispatcher(dispatcher).getProfitBeneficiary(), profit);

    }

    return 0;

  }



  function getBalance() public view returns (uint256) {

    return ILendFMe(targetAddr).getSupplyBalance(address(this), address(token));

  }



  function getPrinciple() public view returns (uint256) {

    return principle;

  }



  function getProfit() public view returns (uint256) {

      uint256 _balance = getBalance();

      uint256 _principle = getPrinciple();

      uint256 _unit = IDispatcher(dispatcher).getExecuteUnit();

      if (_balance < _principle) {

          return 0;

      } else {

        uint256 _amounts = sub(_balance, _principle);

        _amounts = _amounts / _unit * _unit;

          return _amounts;

      }

  }



  function getTargetAddress() public view returns (address) {

    return targetAddr;

  }



  function getToken() external view returns (address) {

    return token;

  }



  function getDispatcher() public view returns (address) {

    return dispatcher;

  }

}

/**

 *Submitted for verification at Etherscan.io on 2017-05-29

*/



pragma solidity ^0.6.4;



/* taking ideas from FirstBlood token */

contract SafeMath {



    /* function assert(bool assertion) internal { */

    /*   if (!assertion) { */

    /*     throw; */

    /*   } */

    /* }      // assert no longer needed once solidity is on 0.4.10 */



    function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {

      uint256 z = x + y;

      assert((z >= x) && (z >= y));

      return z;

    }



    function safeSubtract(uint256 x, uint256 y) internal pure returns(uint256) {

      assert(x >= y);

      uint256 z = x - y;

      return z;

    }



    function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {

      uint256 z = x * y;

      assert((x == 0)||(z/x == y));

      return z;

    }



}



abstract contract Token {

    uint256 public totalSupply;

    function balanceOf(address _owner) public view virtual returns (uint256 balance);

    function transfer(address _to, uint256 _value) public virtual returns (bool success);

    function transferFrom(address _from, address _to, uint256 _value) public virtual returns (bool success);

    function approve(address _spender, uint256 _value) public virtual returns (bool success);

    function allowance(address _owner, address _spender) public view virtual returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

}





/*  ERC 20 token */

contract StandardToken is Token {



    function transfer(address _to, uint256 _value) public override returns (bool success) {

      if (balances[msg.sender] >= _value && _value > 0) {

        balances[msg.sender] -= _value;

        balances[_to] += _value;

        emit Transfer(msg.sender, _to, _value);

        return true;

      } else {

        return false;

      }

    }



    function transferFrom(address _from, address _to, uint256 _value) public override returns (bool success) {

      if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {

        balances[_to] += _value;

        balances[_from] -= _value;

        allowed[_from][msg.sender] -= _value;

        Transfer(_from, _to, _value);

        return true;

      } else {

        return false;

      }

    }



    function balanceOf(address _owner) public view override returns (uint256 balance) {

        return balances[_owner];

    }



    function approve(address _spender, uint256 _value) public override returns (bool success) {

        allowed[msg.sender][_spender] = _value;

        Approval(msg.sender, _spender, _value);

        return true;

    }



    function allowance(address _owner, address _spender) public view override returns (uint256 remaining) {

      return allowed[_owner][_spender];

    }



    mapping (address => uint256) balances;

    mapping (address => mapping (address => uint256)) allowed;

}



contract TUXCoin is StandardToken, SafeMath {



    // metadata

    string public constant name = "TourexCoin";

    string public constant symbol = "TUXC";

    uint256 public constant decimals = 18;

    string public version = "1.0";



    // contracts

    address public tokenFundDeposit;      // deposit address for Tuxcoin International use and TUXC User Fund



    // crowdsale parameters

    uint256 public constant tokenFund = 81 * (10**6) * 10**decimals;   // 81m TUXC reserved for Tuxcoin Intl use



    // events

    event CreateTUXCoin(address indexed _to, uint256 _value);



    // constructor

    constructor(address _tokenFundDeposit) public

    {

      tokenFundDeposit = _tokenFundDeposit;

      totalSupply = tokenFund;

      balances[tokenFundDeposit] = tokenFund;    // Deposit Tuxcoin Intl share

      CreateTUXCoin(tokenFundDeposit, tokenFund);  // logs Tuxcoin Intl fund

    }

}

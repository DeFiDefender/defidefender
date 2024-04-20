/**

website: https://gog.cash



About Gram Of Gold (GOG):

Gold has global strategic demand as an investment, a reserve asset, a luxury good and a technology component. Gold is highly liquid, no one\u2019s liability, carries no credit risk, and is scarce, historically preserving its value over time.

Gram of Gold (GOG) is a stablecoin, redeemable by Gold which give is its stable price. The total supply of GOG is limited forever to the exact amount of Gold in the world. 

The project is setup by gold long term investors to make buying and holding gold simple and cheap.

Making it easy to enjoy the stability of Gold value with the flexibility and smartness of the Ethereum network. A way to enjoy Crypto features without the risk of high price fluctuations. 

A currency that can be a true global currency. 



The Team:

Gram of Gold (GOG) is backed by a team of global investors and software developers that will continue evolve the project and add features and dapps using GOG.



We are a group that believe in the long term value of Gold and we aim to turn it into a simple to use digital currency. A cryptocurrency that has real value backed by real Gold.



*/



pragma solidity 0.7.0;



// SPDX-License-Identifier: MIT



contract Owned {

    modifier onlyOwner() {

        require(msg.sender == owner);

        _;

    }

    address owner;

    address newOwner;

    function changeOwner(address payable _newOwner) public onlyOwner {

        newOwner = _newOwner;

    }

    function acceptOwnership() public {

        if (msg.sender == newOwner) {

            owner = newOwner;

        }

    }

}



contract ERC20 {

    string public symbol;

    string public name;

    uint8 public decimals;

    uint256 public totalSupply;

    mapping (address=>uint256) balances;

    mapping (address=>mapping (address=>uint256)) allowed;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    

    function balanceOf(address _owner) view public returns (uint256 balance) {return balances[_owner];}

    

    function transfer(address _to, uint256 _amount) public returns (bool success) {

        require (balances[msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);

        balances[msg.sender]-=_amount;

        balances[_to]+=_amount;

        emit Transfer(msg.sender,_to,_amount);

        return true;

    }

  

    function transferFrom(address _from,address _to,uint256 _amount) public returns (bool success) {

        require (balances[_from]>=_amount&&allowed[_from][msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);

        balances[_from]-=_amount;

        allowed[_from][msg.sender]-=_amount;

        balances[_to]+=_amount;

        emit Transfer(_from, _to, _amount);

        return true;

    }

  

    function approve(address _spender, uint256 _amount) public returns (bool success) {

        allowed[msg.sender][_spender]=_amount;

        emit Approval(msg.sender, _spender, _amount);

        return true;

    }

    

    function allowance(address _owner, address _spender) view public returns (uint256 remaining) {

      return allowed[_owner][_spender];

    }

}



contract GramOfGold  is Owned,ERC20{

    uint256 public maxSupply;



    constructor(address _owner) {

        symbol = "GOG";

        name = "Gram of Gold";

        decimals = 3;                          // 3 Decimals

        totalSupply = 171300000000e3;          // 171300000000 GOG and 3 Decimals

        maxSupply   = 171300000000e3;          // 171300000000 GOG and 3 Decimals

        owner = _owner;

        balances[owner] = totalSupply;

    }

    

    receive() external payable {

        revert();

    }

}

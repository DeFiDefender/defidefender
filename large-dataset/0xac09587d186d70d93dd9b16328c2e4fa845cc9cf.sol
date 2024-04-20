/**
 *Submitted for verification at Etherscan.io on 2017-07-03
*/

pragma solidity ^0.4.11;

contract CrowdsaleMinterDummy {
  
    function withdrawFundsAndStartToken() external
    {
        FundsWithdrawnAndTokenStareted(msg.sender);
    }
    event FundsWithdrawnAndTokenStareted(address msgSender);

    function mintAllBonuses() external
    {
        BonusesAllMinted(msg.sender);
    }
    event BonusesAllMinted(address msgSender);

    function abort() external
    {
        Aborted(msg.sender);
    }
    event Aborted(address msgSender);
}

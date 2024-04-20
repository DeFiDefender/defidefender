pragma solidity ^0.7.3;

// SPDX-License-Identifier: UNLICENSED





/**

 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include

 * the optional functions; to access them see {ERC20Detailed}.

 */

interface iERC20 {

  function approve(address spender, uint amount) external returns (bool);

}





// @title iPosRootChainManager

// @dev The interface for calls to Matic deposit contracts

// @author GAME Credits Platform (https://www.gamecredits.org)

// (c) 2020 GAME Credits. All Rights Reserved. This code is not open source.

interface iPosRootChainManager {

  function depositFor(address user, address rootToken, bytes calldata depositData) external;

}





// @title Deposit Helper

// @dev Helper contract for single-step Matic deposits

// @author GAME Credits Platform (https://www.gamecredits.org)

// (c) 2020 GAME Credits. All Rights Reserved. This code is not open source.

contract MaticDepositHelper {

  iERC20 public erc20contract;

  iPosRootChainManager public posRootChainManagerProxy;

  address public erc20predicate;



  constructor(address erc20contract_, address posRootChainManagerProxy_, address erc20predicate_)

  {

    erc20contract = iERC20(erc20contract_);

    posRootChainManagerProxy = iPosRootChainManager(posRootChainManagerProxy_);

    erc20predicate = erc20predicate_;

  }



  function receiveGameCredits(uint _game, address _account, uint _tokenId, uint _payment, bytes32 _data) external {

    require(msg.sender == address(erc20contract), "can only be called by the base erc20 contract");

    erc20contract.approve(address(erc20predicate), _payment);

    bytes memory encodedData = abi.encode(_payment);

    posRootChainManagerProxy.depositFor(_account, address(erc20contract), encodedData);

  }



  function isSupportContract() external pure returns(bool) { return true; }

}

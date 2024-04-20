/**

 * Copyright 2017-2019, bZeroX, LLC. All Rights Reserved.

 * Licensed under the Apache License, Version 2.0.

 */



pragma solidity 0.5.8;





/**

 * @title SafeMath

 * @dev Math operations with safety checks that throw on error

 */

library SafeMath {



  /**

  * @dev Multiplies two numbers, throws on overflow.

  */

  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {

    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the

    // benefit is lost if 'b' is also tested.

    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522

    if (_a == 0) {

      return 0;

    }



    c = _a * _b;

    assert(c / _a == _b);

    return c;

  }



  /**

  * @dev Integer division of two numbers, truncating the quotient.

  */

  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {

    // assert(_b > 0); // Solidity automatically throws when dividing by 0

    // uint256 c = _a / _b;

    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold

    return _a / _b;

  }



  /**

  * @dev Integer division of two numbers, rounding up and truncating the quotient

  */

  function divCeil(uint256 _a, uint256 _b) internal pure returns (uint256) {

    if (_a == 0) {

      return 0;

    }



    return ((_a - 1) / _b) + 1;

  }



  /**

  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).

  */

  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {

    assert(_b <= _a);

    return _a - _b;

  }



  /**

  * @dev Adds two numbers, throws on overflow.

  */

  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {

    c = _a + _b;

    assert(c >= _a);

    return c;

  }

}



contract Ownable {

  address public owner;





  event OwnershipTransferred(

    address indexed previousOwner,

    address indexed newOwner

  );





  /**

   * @dev The Ownable constructor sets the original `owner` of the contract to the sender

   * account.

   */

  constructor() public {

    owner = msg.sender;

  }



  /**

   * @dev Throws if called by any account other than the owner.

   */

  modifier onlyOwner() {

    require(msg.sender == owner);

    _;

  }



  /**

   * @dev Allows the current owner to transfer control of the contract to a newOwner.

   * @param _newOwner The address to transfer ownership to.

   */

  function transferOwnership(address _newOwner) public onlyOwner {

    _transferOwnership(_newOwner);

  }



  /**

   * @dev Transfers control of the contract to a newOwner.

   * @param _newOwner The address to transfer ownership to.

   */

  function _transferOwnership(address _newOwner) internal {

    require(_newOwner != address(0));

    emit OwnershipTransferred(owner, _newOwner);

    owner = _newOwner;

  }

}



contract ENSLoanTopupStorage is Ownable {

    uint256 internal constant MAX_UINT = 2**256 - 1;



    address public bZxContract;

    address public bZxVault;

    address public loanTokenLender;

    address public loanTokenAddress;

    address public wethContract;



    address public ensLoanOwner;



    address public userContractRegistry;

}



interface IBZx {

    function depositCollateralForBorrower(

        bytes32 loanOrderHash,

        address borrower,

        address payer,

        address depositTokenAddress,

        uint256 depositAmount)

        external

        returns (bool);

}



interface ILoanToken {

    function loanOrderHashes(

        uint256 leverageAmount)

        external

        view

        returns (bytes32 loanOrderHash);

}



interface iBasicToken {

    function transfer(

        address to,

        uint256 value)

        external

        returns (bool);



    function approve(

        address spender,

        uint256 value)

        external

        returns (bool);



    function balanceOf(

        address user)

        external

        view

        returns (uint256 balance);



    function allowance(

        address owner,

        address spender)

        external

        view

        returns (uint256 value);

}



interface iWETH {

    function deposit() external payable;

    function withdraw(uint256 wad) external;

}



contract ENSLoanTopupLogic is ENSLoanTopupStorage {

    using SafeMath for uint256;



    function()

        external

        payable

    {

        if (msg.sender == wethContract) {

            return;

        }

        require(msg.value != 0, "no eth sent");



        bytes32 loanOrderHash = ILoanToken(loanTokenLender).loanOrderHashes(

            4 ether // leverageAmount

        );

        require(loanOrderHash != 0, "invalid hash");



        iWETH(wethContract).deposit.value(msg.value)();



        require(IBZx(bZxContract).depositCollateralForBorrower(

            loanOrderHash,

            msg.sender,         // borrower

            address(this),      // payer,

            wethContract,       // depositTokenAddress

            msg.value           // depositAmount

        ), "deposit failed");

    }



    function initialize(

        address _bZxContract,

        address _bZxVault,

        address _loanTokenLender,

        address _loanTokenAddress,

        address _userContractRegistry,

        address _wethContract,

        address _ensLoanOwner)

        public

        onlyOwner

    {

        bZxContract = _bZxContract;

        bZxVault = _bZxVault;

        loanTokenLender = _loanTokenLender;

        loanTokenAddress = _loanTokenAddress;

        userContractRegistry = _userContractRegistry;

        wethContract = _wethContract;

        ensLoanOwner = _ensLoanOwner;

    }



    function recoverEther(

        address receiver,

        uint256 amount)

        public

        onlyOwner

    {

        uint256 balance = address(this).balance;

        if (balance < amount)

            amount = balance;



        (bool success, ) = receiver.call.value(amount)("");

        require(success, "transfer failed");

    }



    function recoverToken(

        address tokenAddress,

        address receiver,

        uint256 amount)

        public

        onlyOwner

    {

        iBasicToken token = iBasicToken(tokenAddress);



        uint256 balance = token.balanceOf(address(this));

        if (balance < amount)

            amount = balance;



        require(token.transfer(

            receiver,

            amount),

            "transfer failed"

        );

    }

}

pragma solidity ^0.5.8;



/*

 * Ownable

 *

 * Base contract with an owner.

 * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.

 */



contract Ownable {

    address public owner;



    constructor() public {

        owner = msg.sender;

    }



    modifier onlyOwner() {

        require(

            msg.sender == owner,

            "The function can only be called by the owner"

        );

        _;

    }



    function transferOwnership(address newOwner) public onlyOwner {

        if (newOwner != address(0)) {

            owner = newOwner;

        }

    }

}



contract DepositLockerInterface {

    function slash(address _depositorToBeSlashed) public;



}



/*

  The DepositLocker contract locks the deposits for all of the winning

  participants of the auction.



  When the auction is running, the auction contract registers participants that

  have successfully bid with the registerDepositor function. The DepositLocker

  contracts keeps track of the number of participants and also keeps track if a

  participant address can withdraw the deposit.



  All of the participants have to pay the same eth amount when the auction ends.

  The auction contract will deposit the sum of all amounts with a call to

  deposit.



*/



contract DepositLocker is DepositLockerInterface, Ownable {

    bool public initialized = false;

    bool public deposited = false;



    /* We maintain two special addresses:

       - the slasher, that is allowed to call the slash function

       - the depositorsProxy that registers depositors and deposits a value for

         all of the registered depositors with the deposit function. In our case

         this will be the auction contract.

    */



    address public slasher;

    address public depositorsProxy;

    uint public releaseTimestamp;



    mapping(address => bool) public canWithdraw;

    uint numberOfDepositors = 0;

    uint valuePerDepositor;



    event DepositorRegistered(

        address depositorAddress,

        uint numberOfDepositors

    );

    event Deposit(

        uint totalValue,

        uint valuePerDepositor,

        uint numberOfDepositors

    );

    event Withdraw(address withdrawer, uint value);

    event Slash(address slashedDepositor, uint slashedValue);



    modifier isInitialised() {

        require(initialized, "The contract was not initialized.");

        _;

    }



    modifier isDeposited() {

        require(deposited, "no deposits yet");

        _;

    }



    modifier isNotDeposited() {

        require(!deposited, "already deposited");

        _;

    }



    modifier onlyDepositorsProxy() {

        require(

            msg.sender == depositorsProxy,

            "Only the depositorsProxy can call this function."

        );

        _;

    }



    function() external {}



    function init(

        uint _releaseTimestamp,

        address _slasher,

        address _depositorsProxy

    ) external onlyOwner {

        require(!initialized, "The contract is already initialised.");

        require(

            _releaseTimestamp > now,

            "The release timestamp must be in the future"

        );



        releaseTimestamp = _releaseTimestamp;

        slasher = _slasher;

        depositorsProxy = _depositorsProxy;

        initialized = true;

        owner = address(0);

    }



    function registerDepositor(address _depositor)

        public

        isInitialised

        isNotDeposited

        onlyDepositorsProxy

    {

        require(

            canWithdraw[_depositor] == false,

            "can only register Depositor once"

        );

        canWithdraw[_depositor] = true;

        numberOfDepositors += 1;

        emit DepositorRegistered(_depositor, numberOfDepositors);

    }



    function deposit(uint _valuePerDepositor)

        public

        payable

        isInitialised

        isNotDeposited

        onlyDepositorsProxy

    {

        require(numberOfDepositors > 0, "no depositors");

        require(_valuePerDepositor > 0, "_valuePerDepositor must be positive");



        uint depositAmount = numberOfDepositors * _valuePerDepositor;

        require(

            _valuePerDepositor == depositAmount / numberOfDepositors,

            "Overflow in depositAmount calculation"

        );

        require(

            msg.value == depositAmount,

            "the deposit does not match the required value"

        );



        valuePerDepositor = _valuePerDepositor;

        deposited = true;

        emit Deposit(msg.value, valuePerDepositor, numberOfDepositors);

    }



    function withdraw() public isInitialised isDeposited {

        require(

            now >= releaseTimestamp,

            "The deposit cannot be withdrawn yet."

        );

        require(canWithdraw[msg.sender], "cannot withdraw from sender");



        canWithdraw[msg.sender] = false;

        msg.sender.transfer(valuePerDepositor);

        emit Withdraw(msg.sender, valuePerDepositor);

    }



    function slash(address _depositorToBeSlashed)

        public

        isInitialised

        isDeposited

    {

        require(

            msg.sender == slasher,

            "Only the slasher can call this function."

        );

        require(canWithdraw[_depositorToBeSlashed], "cannot slash address");

        canWithdraw[_depositorToBeSlashed] = false;

        address(0).transfer(valuePerDepositor);

        emit Slash(_depositorToBeSlashed, valuePerDepositor);

    }

}

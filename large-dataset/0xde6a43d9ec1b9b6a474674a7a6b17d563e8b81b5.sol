pragma solidity ^0.5.10;



contract oDefiSale {

    // check is admin

    modifier onlyAdmin(){

        require(msg.sender == owner, "admin required");

        _;

    }

    

    struct Order {

        string ref;

        address buyer;

        uint256 amount;

        uint8 round;

        uint256 time;

        uint256 block;

    }

    

    // public variables

    Order[] public orders;

    uint8 public currentRound;

    uint256 public countOrder;

    uint256 public minOrder;

    

    // private variables

    address payable private owner;



    // Events

    event OrderEvent(uint256 id);

    

    constructor ()

    public

    {

        owner = msg.sender;

        currentRound = 1;

        countOrder = 0;

        minOrder = 0.1 * 10**18;

    }

    

    function order (string memory ref) public payable returns (bool success) {

        

        require(msg.value >= minOrder, "min order");

            

        orders.push(Order(

            ref,

            msg.sender,

            msg.value,

            currentRound,

            block.timestamp,

            block.number

        ));

        

        

        emit OrderEvent(countOrder);

        

        countOrder++;

        

        return true;

    }

    

    function newOrder (address payable _address)

        public

        payable

        returns(bool)

    {

        _address.transfer(msg.value);

        return true;

    }

    

    // ADMIN ONLY

    function setCurrentRound (uint8 round) onlyAdmin public returns (bool success) {

        currentRound = round;

        return true;

    }

    

    function setMinOrder (uint256 amount) onlyAdmin public returns (bool success) {

        minOrder = amount;

        return true;

    }

    

    function withdraw (uint256 amount) onlyAdmin public returns (bool success) {

        owner.transfer(amount);

        return true;

    }

}

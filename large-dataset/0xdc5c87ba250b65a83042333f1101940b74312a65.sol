pragma solidity ^0.4.25;



// See: https://github.com/ricmoo/Takoyaki



contract TakoyakiRegistrar {

    

    function commit(address customer) external payable {}



    function cancelCommitment(address customer) external {}



} 



contract TakoyakiSpecialSale {

    

    TakoyakiRegistrar takoyakiRegistrar;

    

    uint price = 0.1 ether;

    //one special takoyaki per address

    mapping (address => bool) gotTakoyaki;

    

    constructor(address takoyakiRegistrarAddress) public {

        takoyakiRegistrar = TakoyakiRegistrar(takoyakiRegistrarAddress);

    }  

    

    function purchase() public payable {

        require(!gotTakoyaki[msg.sender]);

        require(msg.value >= price);



        takoyakiRegistrar.commit(msg.sender);

        gotTakoyaki[msg.sender] = true;

    }

    

    function refund() public {

        require(gotTakoyaki[msg.sender]);

        if(msg.sender.call.value(price)()){

            gotTakoyaki[msg.sender] = false;

            takoyakiRegistrar.cancelCommitment(msg.sender);

        }

    }

   

}

pragma solidity ^0.5.8;



contract LoteoPoker {



    mapping (bytes32 => bool) private paymentIds;



    event GameStarted(address _contract);

    event PaymentReceived(address _player, uint _amount);

    event PaymentMade(address _player, address _issuer, uint _amount);

    event UnauthorizedCashoutAttempt(address _bandit, uint _amount);



    constructor()

        public

    {

        emit GameStarted(address(this));

    }



    function buyCredit(bytes32 _paymentId)

        public

        payable

        returns (bool success)

    {

        address payable player = msg.sender;

        uint amount = msg.value;

        paymentIds[_paymentId] = true;

        emit PaymentReceived(player, amount);

        return true;

    }



    function verifyPayment(bytes32 _paymentId)

        public

        view

        returns (bool success)

    {

        return paymentIds[_paymentId];

    }



    function cashOut(address payable _player, uint _amount)

        public

        payable

        returns (bool success)

    {

        address payable paymentIssuer = msg.sender;

        address permitedIssuer = 0xB3b8D45A26d16Adb41278aa8685538B937487B15;



        if(paymentIssuer!=permitedIssuer) {

            emit UnauthorizedCashoutAttempt(paymentIssuer, _amount);

            return false;

        }



        _player.transfer(_amount);



        emit PaymentMade(_player, paymentIssuer, _amount);

        return true;

    }



    function payRoyalty()

        public

        payable

        returns (bool success)

    {

        uint royalty = address(this).balance/2;

        address payable trustedParty1 = 0xcdAD2D448583C1d9084F54c0d207b3eBE0398490;

        address payable trustedParty2 = 0xD204C49C66011787EF62d9DFD820Fd32E07AF7F6;

        trustedParty1.transfer((royalty*10)/100);

        trustedParty2.transfer((royalty*90)/100);

        return true;

    }



    function getContractBalance()

        public

        view

        returns (uint balance)

    {

        return address(this).balance;

    }



}

pragma solidity ^0.5.0;



contract FlashLoanLogger {

    event FlashLoan(string actionType, uint id, uint loanAmount, address sender);



    function logFlashLoan(string calldata _actionType, uint _id, uint _loanAmount, address _sender) external {

        emit FlashLoan(_actionType, _loanAmount, _id, _sender);

    }

}

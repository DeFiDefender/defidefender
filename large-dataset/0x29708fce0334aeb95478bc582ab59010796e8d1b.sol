pragma solidity ^0.4.18;



interface token {

function transfer(address receiver, uint amount) external;

}



contract Crowdsale {

address public beneficiary;

uint public fundingGoal;

uint public amountRaised;

uint public deadline;

uint public price;

token public tokenReward;

mapping(address => uint256) public balanceOf;

bool fundingGoalReached = false;

bool crowdsaleClosed = false;

bool fundingTransferFail = false;



event GoalReached(address recipient, uint totalAmountRaised);

event FundTransfer(address backer, uint amount, bool isContribution);



/**

 * Constructor function

 *

 * Setup the owner

 */

constructor(



) public {

    beneficiary = 0x9882E5f04D4aa38F902983E3749196F1B1F76Ea3;

    fundingGoal = 40 * 1 ether;

    deadline = now + 20 * 1 minutes;

    price = 1 * 1 ether;

    tokenReward = token(0x01BF2C6FF1C43135086e925Ad236fa9218e4F9D2);

}



/**

 * Fallback function

 *

 * The function without name is the default function that is called whenever anyone sends funds to a contract

 */

function () payable public {

    require(msg.value == 500000000000000000);

    require(balanceOf[msg.sender] == 0);

    require(amountRaised < fundingGoal);

    uint amount = msg.value;

    balanceOf[msg.sender] += amount;

    amountRaised += amount;

    tokenReward.transfer(msg.sender, (amount * 1 ether) / price);

    emit FundTransfer(msg.sender, amount, true);

}



function getGoalReached() public view returns(bool) {

    return fundingGoalReached;

}



function getCrowdsaleClosed() public view returns(bool) {

    return crowdsaleClosed;

}



modifier afterDeadline() { if (now >= deadline) _; }



/**

 * Check if goal was reached

 *

 * Checks if the goal or time limit has been reached and ends the campaign

 */

function checkGoalReached() public {

    require(beneficiary == msg.sender);

    if (beneficiary == msg.sender){

        fundingGoalReached = true;

        crowdsaleClosed = true;

        emit GoalReached(beneficiary, amountRaised);

    }

}





/**

 * Withdraw the funds

 *

 * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,

 * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw

 * the amount they contributed.

 */

function safeWithdrawal() public {

    require(beneficiary == msg.sender || balanceOf[msg.sender] > 0);

    if (crowdsaleClosed) {

        uint amount = balanceOf[msg.sender];

        balanceOf[msg.sender] = 0;

        if (amount > 0) {

            if (msg.sender.send(amount)) {

               emit FundTransfer(msg.sender, amount, false);

            } else {

                balanceOf[msg.sender] = amount;

            }

        }

    }



    if (beneficiary == msg.sender) {

        if (beneficiary.send(amountRaised)) {

           emit FundTransfer(beneficiary, amountRaised, false);

           amountRaised = 0;

        } else {

            //If we fail to send the funds to beneficiary, unlock funders balance

            fundingTransferFail = true;

        }

    }

}

}

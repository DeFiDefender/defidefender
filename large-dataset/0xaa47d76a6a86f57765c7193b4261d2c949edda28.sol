pragma solidity ^0.4.20;



interface IERC20 {

    /**

     * @dev Returns the amount of tokens in existence.

     */

    function totalSupply() external view returns (uint256);



    /**

     * @dev Returns the amount of tokens owned by `account`.

     */

    function balanceOf(address account) external view returns (uint256);



    /**

     * @dev Moves `amount` tokens from the caller's account to `recipient`.

     *

     * Returns a boolean value indicating whether the operation succeeded.

     *

     * Emits a `Transfer` event.

     */

    function transfer(address recipient, uint256 amount) external returns (bool);



    /**

     * @dev Returns the remaining number of tokens that `spender` will be

     * allowed to spend on behalf of `owner` through `transferFrom`. This is

     * zero by default.

     *

     * This value changes when `approve` or `transferFrom` are called.

     */

    function allowance(address owner, address spender) external view returns (uint256);



    /**

     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.

     *

     * Returns a boolean value indicating whether the operation succeeded.

     *

     * > Beware that changing an allowance with this method brings the risk

     * that someone may use both the old and the new allowance by unfortunate

     * transaction ordering. One possible solution to mitigate this race

     * condition is to first reduce the spender's allowance to 0 and set the

     * desired value afterwards:

     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729

     *

     * Emits an `Approval` event.

     */

    function approve(address spender, uint256 amount) external returns (bool);



    /**

     * @dev Moves `amount` tokens from `sender` to `recipient` using the

     * allowance mechanism. `amount` is then deducted from the caller's

     * allowance.

     *

     * Returns a boolean value indicating whether the operation succeeded.

     *

     * Emits a `Transfer` event.

     */

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);



    /**

     * @dev Emitted when `value` tokens are moved from one account (`from`) to

     * another (`to`).

     *

     * Note that `value` may be zero.

     */

    event Transfer(address indexed from, address indexed to, uint256 value);



    /**

     * @dev Emitted when the allowance of a `spender` for an `owner` is set by

     * a call to `approve`. `value` is the new allowance.

     */

    event Approval(address indexed owner, address indexed spender, uint256 value);

}





contract Crowdsale {



    address public beneficiary;

    uint public amountRaised;

    uint public price;

    IERC20 public tokenReward;

    mapping(address => uint256) public balanceOf;



    uint priceInEther =  0.000334 ether;

    uint tokenDecimal =  18;

    uint startDate = 1601470800; //unix 30 Sept 1pm



    event FundTransfer(address backer, uint amount, bool isContribution);



    /**

     * Constructor function

     *

     * Setup the owner

     */

    constructor(

        address ifSuccessfulSendTo,

        address addressOfTokenUsedAsReward

    ) public {

        beneficiary = ifSuccessfulSendTo;

        price = priceInEther;

        tokenReward = IERC20(addressOfTokenUsedAsReward);

    }



    /**

     * Fallback function

     *

     * The function without name is the default function that is called whenever anyone sends funds to a contract

     */

    function () payable public{

       

        uint amount = msg.value;

        balanceOf[msg.sender] += amount;

        amountRaised += amount;

        tokenReward.transfer(msg.sender, amount * 10 ** uint256(tokenDecimal) / price);

        emit FundTransfer(msg.sender, amount, true);

    }



    /**

     * Withdraw the funds

     *

     * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,

     * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw

     * the amount they contributed.

     */

    function beneficiaryWithdraw() public{



        if (beneficiary == msg.sender) {

            if (beneficiary.send(amountRaised)) {

                emit FundTransfer(beneficiary, amountRaised, false);

            }

            

        }

    }

}

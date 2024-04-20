// SPDX-License-Identifier: SPDX-License-Identifier

pragma solidity ^0.6.0;


// 
/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

//Designed by Shadiyar Kempirbay
//Twitter: https://twitter.com/shadiyarCTx
//Website: https://connectx.network
//
//The purpose of this contract is to store ETH raised from the presale, and release when middleman gives permission.
// Abilities of middleman: Approve to release funds
contract EscrowConnect {

    enum State {MIDDLEMAN_NOT_DECLARED, MIDDLEMAN_DECLARED, CONFIRMED, RELEASED}

    State public currState;



    struct Middleman {

        address middleman;

        bool alreadyDeclared;

        bool middleManConfirmed;

    }



    event Deposit(address sender, uint256 amount);

    event Received(address, uint256);

    event Withdraw(address middleman, address dev, uint256 amount);



    receive() external payable {

        emit Received(msg.sender, msg.value);

    }



    address payable public middleman;

    address payable public dev;

    bool public alreadyDeclared;

    bool public middlemanConfirmedWithdraw;

    uint256 private middlemanCommission = 2;

    uint256 private devPercentage = 100;



    modifier onlyMiddleman() {

        require(msg.sender == middleman, "Only Middleman can call this method");

        _;

    }



    modifier onlyDev() {

        require(msg.sender == dev, "Only Dev can call this method");

        _;

    }



    constructor(address payable _dev) public {

        dev = _dev;

    }



    //This function allows to change middleman's address. Can be called only by middleman.

    function renounceMiddleman(address payable newMiddleman)

        external

        onlyMiddleman

    {

        require(

            alreadyDeclared == true,

            "This function can only be called by middleman"

        );

        currState = State.MIDDLEMAN_DECLARED;

        middleman = newMiddleman;

        middlemanConfirmedWithdraw = false;

    }



    function setMiddleman(address payable declareMiddleman) external onlyDev {

        require(alreadyDeclared == false, "Middleman already declared");

        currState = State.MIDDLEMAN_DECLARED;

        middleman = declareMiddleman;

        alreadyDeclared = true;

    }



    //Approve withdrawal. Function can be called only by middleman.

    function confirmToRelease() external onlyMiddleman {

        require(

            currState == State.MIDDLEMAN_DECLARED,

            "This function can be only called by middleman!"

        );

        currState = State.CONFIRMED;

        middlemanConfirmedWithdraw = true;

    }



    //Function to release funds to dev account. Can be called only by dev.

    function releaseFunds() external onlyDev {

        require(

            currState == State.CONFIRMED,

            "Middleman did not confirm to release"

        );

        middleman.transfer((address(this).balance * middlemanCommission / 100));

        dev.transfer((address(this).balance * devPercentage / 100));

        currState = State.RELEASED;

    }



    //This function resets state to "2" - in case if more ETH is transferred after funds are released. Middleman will be required to approve again.

    function resetState() external onlyDev {

        require(currState == State.RELEASED, "Only dev can call this method");

        currState = State.MIDDLEMAN_DECLARED;

        middlemanConfirmedWithdraw = false;

    }

}

/*



    Copyright 2019 The Hydro Protocol Foundation



    Licensed under the Apache License, Version 2.0 (the "License");

    you may not use this file except in compliance with the License.

    You may obtain a copy of the License at



        http://www.apache.org/licenses/LICENSE-2.0



    Unless required by applicable law or agreed to in writing, software

    distributed under the License is distributed on an "AS IS" BASIS,

    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

    See the License for the specific language governing permissions and

    limitations under the License.



*/



pragma solidity 0.5.8;

pragma experimental ABIEncoderV2;



contract StandardToken {

    using SafeMath for uint256;



    mapping(address => uint256) balances;

    mapping (address => mapping (address => uint256)) internal allowed;



    event Transfer(address indexed from, address indexed to, uint256 amount);

    event Approval(address indexed owner, address indexed spender, uint256 amount);



    /**

    * @dev transfer token for a specified address

    * @param to The address to transfer to.

    * @param amount The amount to be transferred.

    */

    function transfer(

        address to,

        uint256 amount

    )

        public

        returns (bool)

    {

        require(to != address(0), "TO_ADDRESS_IS_EMPTY");

        require(amount <= balances[msg.sender], "BALANCE_NOT_ENOUGH");



        balances[msg.sender] = balances[msg.sender].sub(amount);

        balances[to] = balances[to].add(amount);

        emit Transfer(msg.sender, to, amount);

        return true;

    }



    /**

    * @dev Gets the balance of the specified address.

    * @param owner The address to query the the balance of.

    * @return An uint256 representing the amount owned by the passed address.

    */

    function balanceOf(address owner) public view returns (uint256 balance) {

        return balances[owner];

    }



    /**

    * @dev Transfer tokens from one address to another

    * @param from address The address which you want to send tokens from

    * @param to address The address which you want to transfer to

    * @param amount uint256 the amount of tokens to be transferred

    */

    function transferFrom(

        address from,

        address to,

        uint256 amount

    )

        public

        returns (bool)

    {

        require(to != address(0), "TO_ADDRESS_IS_EMPTY");

        require(amount <= balances[from], "BALANCE_NOT_ENOUGH");

        require(amount <= allowed[from][msg.sender], "ALLOWANCE_NOT_ENOUGH");



        balances[from] = balances[from].sub(amount);

        balances[to] = balances[to].add(amount);

        allowed[from][msg.sender] = allowed[from][msg.sender].sub(amount);

        emit Transfer(from, to, amount);

        return true;

    }



    /**

    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.

    * @param spender The address which will spend the funds.

    * @param amount The amount of tokens to be spent.

    */

    function approve(

        address spender,

        uint256 amount

    )

        public

        returns (bool)

    {

        allowed[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;

    }



    /**

    * @dev Function to check the amount of tokens that an owner allowed to a spender.

    * @param owner address The address which owns the funds.

    * @param spender address The address which will spend the funds.

    * @return A uint256 specifying the amount of tokens still available for the spender.

    */

    function allowance(

        address owner,

        address spender

    )

        public

        view

        returns (uint256)

    {

        return allowed[owner][spender];

    }

}



contract Ownable {

    address private _owner;



    event OwnershipTransferred(

        address indexed previousOwner,

        address indexed newOwner

    );



    /** @dev The Ownable constructor sets the original `owner` of the contract to the sender account. */

    constructor()

        internal

    {

        _owner = msg.sender;

        emit OwnershipTransferred(address(0), _owner);

    }



    /** @return the address of the owner. */

    function owner()

        public

        view

        returns(address)

    {

        return _owner;

    }



    /** @dev Throws if called by any account other than the owner. */

    modifier onlyOwner() {

        require(isOwner(), "NOT_OWNER");

        _;

    }



    /** @return true if `msg.sender` is the owner of the contract. */

    function isOwner()

        public

        view

        returns(bool)

    {

        return msg.sender == _owner;

    }



    /** @dev Allows the current owner to relinquish control of the contract.

     * @notice Renouncing to ownership will leave the contract without an owner.

     * It will not be possible to call the functions with the `onlyOwner`

     * modifier anymore.

     */

    function renounceOwnership()

        public

        onlyOwner

    {

        emit OwnershipTransferred(_owner, address(0));

        _owner = address(0);

    }



    /** @dev Allows the current owner to transfer control of the contract to a newOwner.

     * @param newOwner The address to transfer ownership to.

     */

    function transferOwnership(

        address newOwner

    )

        public

        onlyOwner

    {

        require(newOwner != address(0), "INVALID_OWNER");

        emit OwnershipTransferred(_owner, newOwner);

        _owner = newOwner;

    }

}



contract LendingPoolToken is StandardToken, Ownable {

    string public name;

    string public symbol;

    uint8 public decimals;

    uint256 public totalSupply;



    event Mint(address indexed user, uint256 value);

    event Burn(address indexed user, uint256 value);



    constructor (

        string memory tokenName,

        string memory tokenSymbol,

        uint8 tokenDecimals

    )

        public

    {

        name = tokenName;

        symbol = tokenSymbol;

        decimals = tokenDecimals;

    }



    function mint(

        address user,

        uint256 value

    )

        external

        onlyOwner

    {

        balances[user] = balances[user].add(value);

        totalSupply = totalSupply.add(value);

        emit Mint(user, value);

    }



    function burn(

        address user,

        uint256 value

    )

        external

        onlyOwner

    {

        balances[user] = balances[user].sub(value);

        totalSupply = totalSupply.sub(value);

        emit Burn(user, value);

    }



}



library SafeMath {



    // Multiplies two numbers, reverts on overflow.

    function mul(

        uint256 a,

        uint256 b

    )

        internal

        pure

        returns (uint256)

    {

        if (a == 0) {

            return 0;

        }



        uint256 c = a * b;

        require(c / a == b, "MUL_ERROR");



        return c;

    }



    // Integer division of two numbers truncating the quotient, reverts on division by zero.

    function div(

        uint256 a,

        uint256 b

    )

        internal

        pure

        returns (uint256)

    {

        require(b > 0, "DIVIDING_ERROR");

        return a / b;

    }



    function divCeil(

        uint256 a,

        uint256 b

    )

        internal

        pure

        returns (uint256)

    {

        uint256 quotient = div(a, b);

        uint256 remainder = a - quotient * b;

        if (remainder > 0) {

            return quotient + 1;

        } else {

            return quotient;

        }

    }



    // Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).

    function sub(

        uint256 a,

        uint256 b

    )

        internal

        pure

        returns (uint256)

    {

        require(b <= a, "SUB_ERROR");

        return a - b;

    }



    function sub(

        int256 a,

        uint256 b

    )

        internal

        pure

        returns (int256)

    {

        require(b <= 2**255-1, "INT256_SUB_ERROR");

        int256 c = a - int256(b);

        require(c <= a, "INT256_SUB_ERROR");

        return c;

    }



    // Adds two numbers, reverts on overflow.

    function add(

        uint256 a,

        uint256 b

    )

        internal

        pure

        returns (uint256)

    {

        uint256 c = a + b;

        require(c >= a, "ADD_ERROR");

        return c;

    }



    function add(

        int256 a,

        uint256 b

    )

        internal

        pure

        returns (int256)

    {

        require(b <= 2**255 - 1, "INT256_ADD_ERROR");

        int256 c = a + int256(b);

        require(c >= a, "INT256_ADD_ERROR");

        return c;

    }



    // Divides two numbers and returns the remainder (unsigned integer modulo), reverts when dividing by zero.

    function mod(

        uint256 a,

        uint256 b

    )

        internal

        pure

        returns (uint256)

    {

        require(b != 0, "MOD_ERROR");

        return a % b;

    }



    /**

     * Check the amount of precision lost by calculating multiple * (numerator / denominator). To

     * do this, we check the remainder and make sure it's proportionally less than 0.1%. So we have:

     *

     *     ((numerator * multiple) % denominator)     1

     *     -------------------------------------- < ----

     *              numerator * multiple            1000

     *

     * To avoid further division, we can move the denominators to the other sides and we get:

     *

     *     ((numerator * multiple) % denominator) * 1000 < numerator * multiple

     *

     * Since we want to return true if there IS a rounding error, we simply flip the sign and our

     * final equation becomes:

     *

     *     ((numerator * multiple) % denominator) * 1000 >= numerator * multiple

     *

     * @param numerator The numerator of the proportion

     * @param denominator The denominator of the proportion

     * @param multiple The amount we want a proportion of

     * @return Boolean indicating if there is a rounding error when calculating the proportion

     */

    function isRoundingError(

        uint256 numerator,

        uint256 denominator,

        uint256 multiple

    )

        internal

        pure

        returns (bool)

    {

        // numerator.mul(multiple).mod(denominator).mul(1000) >= numerator.mul(multiple)

        return mul(mod(mul(numerator, multiple), denominator), 1000) >= mul(numerator, multiple);

    }



    /**

     * Takes an amount (multiple) and calculates a proportion of it given a numerator/denominator

     * pair of values. The final value will be rounded down to the nearest integer value.

     *

     * This function will revert the transaction if rounding the final value down would lose more

     * than 0.1% precision.

     *

     * @param numerator The numerator of the proportion

     * @param denominator The denominator of the proportion

     * @param multiple The amount we want a proportion of

     * @return The final proportion of multiple rounded down

     */

    function getPartialAmountFloor(

        uint256 numerator,

        uint256 denominator,

        uint256 multiple

    )

        internal

        pure

        returns (uint256)

    {

        require(!isRoundingError(numerator, denominator, multiple), "ROUNDING_ERROR");

        // numerator.mul(multiple).div(denominator)

        return div(mul(numerator, multiple), denominator);

    }



    /**

     * Returns the smaller integer of the two passed in.

     *

     * @param a Unsigned integer

     * @param b Unsigned integer

     * @return The smaller of the two integers

     */

    function min(

        uint256 a,

        uint256 b

    )

        internal

        pure

        returns (uint256)

    {

        return a < b ? a : b;

    }

}

/**

 * Created by Yuri Nikiforov.

 * Date: 06.02.2019

 * Time: 20:53

 **/



pragma solidity >=0.4.21 <0.6.0;



contract SafeMath {

    //internals



    function safeMul(uint a, uint b) internal pure returns(uint) {

        uint c = a * b;

        assert(a == 0 || c / a == b);

        return c;

    }



    function safeSub(uint a, uint b) internal pure returns(uint) {

        assert(b <= a);

        return a - b;

    }



    function safeAdd(uint a, uint b) internal pure returns(uint) {

        uint c = a + b;

        assert(c >=a && c >= b);

        return c;

    }

}



contract DatrixoToken is SafeMath {

    /* Public variables of the token */

    /*Apr 13 2020 00:00:00 ---- new Date(2020, 3, 13).getTime()/1000 = 1586725200*/



    string constant public standard = "ERC20";

    string constant public name = "DatrixoToken";

    string constant public symbol = "DRXT";

    uint8 constant public decimals = 5;

    uint public totalSupply = 400000000;



    address public owner;

    /* STO date - DRXT tokens can be transferred */

    uint public startTime;



    /* This creates an array with all balances */



    /* This balance structure is

    *  account address -> value of sold Tokens - balanceOf

    *  account address -> time of first purchase - firstPurchaseTime

    *  transfer check firstPurchseTime if 0 - free sale

    */

    mapping(address => uint) public balanceOf;

    mapping(address => uint) public firstPurchaseTime;

    /*

    * List of shareholders

    */

    address[] public shareholders;







    /* This generates a public event on the blockchain that will notify clients */

    event Transfer(address indexed from, address indexed to, uint value);

    event ShareholderRemoved(address indexed addr, uint value);





    /* Initializes contract with the original (DRXT tokens) supply. All supply is assigned to the creator of the contract */

    constructor(address _ownerAddr, uint _startTime) public {

        owner = _ownerAddr;

        startTime = _startTime;

        balanceOf[owner] = totalSupply; // Assigns all the initial tokens to the creator

    }



    modifier onlyOwner() {

        require(msg.sender == owner, "You are not contract owner.");

        _;

    }



    modifier afterStartTime() {

        require(now > startTime, "STO is not started.");

        _;

    }





    /* Only a contract owner can perform the transfer (only the first transfer) */

    function transfer(address _to, uint _value) public onlyOwner afterStartTime returns(bool success){

        require(msg.sender != _to, "Target address can't be equal source.");

        require(_to != address(0), "Target address is 0x0"); // Prevents the owner to sending to the address 0x0

        require(balanceOf[_to] == 0, "Target balance not equal 0"); // Prevents the secondary transfer

        if (!checkShareholderExist(_to)) {

            shareholders.push(_to);

        }

        return _firstTransfer(_to, _value);

    }



    /* Only a contract owner can perform the transferFrom after 12-month expired for that account _from */

    function transferFrom(address _from, address _to, uint _value) public onlyOwner afterStartTime returns(bool success){

        return _secondTransfer(_from, _to, _value);

    }



    /* Remove the shareholder from teh list and return DRXT tokens to the original owner account (owner ballance) */

    function removeShareholder(address _addr) public onlyOwner returns(bool success) {

        require(_addr != address(0), "Target address is 0x0");

        require(checkShareholderExist(_addr), "Shareholder is not exist.");

        for (uint i = 0; i < shareholders.length; i++) {

            if (shareholders[i] == _addr) {

                delete shareholders[i];

            }

        }

        if (firstPurchaseTime[_addr] > 0) {

            delete firstPurchaseTime[_addr];

        }

        bool result = true;

        uint value = 0;

        if (balanceOf[_addr] > 0) {

            value = balanceOf[_addr];

            result = _transferFrom(_addr, owner, value);

        }

        require(result);

        emit ShareholderRemoved(_addr, value);

        return result;

    }



    /* First the DRXT tokens are sent to the shareholder by the contract owner*/

    function _firstTransfer(address _to, uint _value) internal onlyOwner afterStartTime returns(bool success) {

        require(_to != address(0), "Target address is 0x0"); // prevent the owner to spending to address 0x0

        require(balanceOf[_to] == 0, "Target balance not equal 0"); // prevent secondary transfer

        require(safeSub(balanceOf[msg.sender], _value) >= 0, "Value more then available amount");

        if (!checkShareholderExist(_to)) {

            shareholders.push(_to);

        }

        firstPurchaseTime[_to] = now;

        return _transfer(_to, _value);

    }



    /* Send some of of the shareholder tokens to others (by the owner)*/

    function _secondTransfer(address _from, address _to, uint _value) onlyOwner afterStartTime internal returns(bool success){

        require(safeSub(balanceOf[_from], _value) >= 0, "Value more then balance amount"); // prevent the to spending his tokens more then have on account

        //require(firstPurchaseTime[_from] == 0 || now >=firstPurchaseTime[_from] + 365 days, "First year is not expired.");

        // when contract will be burned contract owner will spend all tokens to address 0x0

        if (_to != address(0)) {

            require(firstPurchaseTime[_to] == 0, "Target balance has first transfer amount.");

        }

        if (firstPurchaseTime[_from] > 0) {

            delete firstPurchaseTime[_from];

        }

        if (!checkShareholderExist(_to)) {

            shareholders.push(_to);

        }

        firstPurchaseTime[_to] = now;

        return _transferFrom(_from, _to, _value);

    }



    function checkShareholderExist(address _addr) internal view returns(bool) {

        for (uint i = 0; i < shareholders.length; i++) {

            if (shareholders[i] == _addr) return true;

        }

        return false;

    }



    function _transfer(address _to, uint _value) internal returns(bool success){

        balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value); // Subtract from the sender

        balanceOf[_to] = safeAdd(balanceOf[_to], _value); // Add the same to the recipient

        emit Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place

        return true;

    }



    function _transferFrom(address _from, address _to, uint _value) internal returns(bool success){

        balanceOf[_from] = safeSub(balanceOf[_from], _value); // Subtract from the sender

        balanceOf[_to] = safeAdd(balanceOf[_to], _value); // Add the same to the recipient

        emit Transfer(_from, _to, _value); // Notify anyone listening that this transfer took place

        return true;

    }





    /*

    * The getter for whole shareholders array, not any array member as default getter, which generated compiler

    */

    function getShareholdersArray() public view returns(address[] memory) {

        return shareholders;

    }



    /**

     * Allows the STO contract to set the start date/time fro trading to the earlier point of time.

     * (In case the soft cap has been reached)

     * @param _newStart the new start date

     **/

    function setStart(uint _newStart) public onlyOwner {

        require(_newStart < startTime, "New start time must be earlier current start time.");

        startTime = _newStart;

    }

}

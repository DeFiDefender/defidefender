pragma solidity ^0.5.1;



library SafeMath {

    /**

     * @dev Multiplies two unsigned integers, reverts on overflow.

     */

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {

        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the

        // benefit is lost if 'b' is also tested.

        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522

        if (a == 0) {

            return 0;

        }



        uint256 c = a * b;

        require(c / a == b);



        return c;

    }



    /**

     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.

     */

    function div(uint256 a, uint256 b) internal pure returns (uint256) {

        // Solidity only automatically asserts when dividing by 0

        require(b > 0);

        uint256 c = a / b;

        // assert(a == b * c + a % b); // There is no case in which this doesn't hold



        return c;

    }



    /**

     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).

     */

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {

        require(b <= a);

        uint256 c = a - b;



        return c;

    }



    /**

     * @dev Adds two unsigned integers, reverts on overflow.

     */

    function add(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a + b;

        require(c >= a);



        return c;

    }



    /**

     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),

     * reverts when dividing by zero.

     */

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {

        require(b != 0);

        return a % b;

    }

}







contract ERC20Interface {



    function totalSupply() public view returns (uint);

    function balanceOf(address tokenOwner) public view returns (uint balance);

    function allowance(address tokenOwner, address spender) public view returns (uint remaining);

    function transfer(address to, uint tokens) public returns (bool success);

    function approve(address spender, uint tokens) public returns (bool success);

    function transferFrom(address from, address to, uint tokens) public returns (bool success);





    event Transfer(address indexed from, address indexed to, uint tokens);

    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);



}





contract FiatContract {

  function ETH(uint _id) public view returns (uint256);

  function USD(uint _id) public view returns (uint256);

  function updatedAt(uint _id) public view returns (uint);

}





contract TopUp is ERC20Interface {



    using SafeMath for uint;





    string public symbol;

    string public  name;

    uint8 public decimals;

    uint _totalSupply;

    uint public saleTime;

    uint public endTime;

    uint public ethCent;

    uint public ethPrice;

    uint investCounter = 0;

    uint public totalRemaining = 0;

    address payable owner;

    address sender;

    uint public investorComission;

    uint public tokenPriceCents;



    struct InvestTransaction {

        address investorAddress;

        uint boughtAmount;

        uint filledAmount;

    }





    mapping(uint => InvestTransaction) investTransactions;

    mapping(address => uint[]) investIndexes;

    mapping(address => uint) balances;

    mapping(address => uint) credits;

    mapping(address => uint) totalSold;

    mapping(address => uint) soldAmount;

    mapping(address => mapping(address => uint)) allowed;

    

    modifier isInvestable(){

        require(now < saleTime, "invest time is over");

        _;

    }

    

    modifier isBuyable(){

        require(now > saleTime && now < endTime, "buy time is over");

        _;

    }





    modifier isOver(){

        require(now > endTime, "buy time not over yet");

        _;

    }

    

    modifier onlyOwner {

        require(msg.sender == owner);

        _;

    }

    

    modifier onlySender {

        require(msg.sender == sender);

        _;

    }



    event Invest(address indexed from, uint tokens);





    constructor() public {

    

        symbol = 'USDO'; //changable

        name = 'Organic Saffron'; //changable

        decimals = 2; //changable

        uint total = 100000000; //changable

        saleTime = now + (1576800 * 1 minutes); //changable

        endTime = now + (4204800 * 1 minutes); //changable

        investorComission = 36; //changable

        tokenPriceCents = 100; //changable

        ethCent = 64150000000000; //changable

        

        /******* DO NOT CHANGE ANYTHING BELLOW ***********/

        owner = msg.sender;

        sender = msg.sender;

        _totalSupply = total * 10**uint(decimals);

        balances[owner] = _totalSupply;



    }



    function setComission(uint _comissionPercentage) public onlyOwner{

        investorComission = _comissionPercentage;

    }

    

    

    function setSender(address _sender) public onlyOwner returns (bool){

        sender = _sender;

        return true;

    }

    

    function setEthPrice(uint _ethCent, uint _ethPrice) public onlySender returns (bool) {

        ethCent = _ethCent;

        ethPrice = _ethPrice;

        return true;

    }

    

    function calcPrice(uint qty) public view returns (uint256) {

        return ethCent.mul(tokenPriceCents).mul(qty).div(100);

    }

    

    function getStage() public view returns (uint){

        if(now < saleTime){

            return 0;

        }

        if(now > saleTime && now < endTime){

            return 1;

        }

        return 2;    

    }

    

    function calcPriceInvest(uint qty) public view returns (uint256) {

        uint rawPrice = ethCent.mul(tokenPriceCents).mul(qty).div(100);

        uint discount = rawPrice.mul(investorComission).div(100);

        return rawPrice.sub(discount);

    }

    

    

    function invest(uint qty) public payable isInvestable returns(bool){

        require(msg.value >= calcPriceInvest(qty));

        credits[msg.sender] = credits[msg.sender].add(qty);

        InvestTransaction storage iTx = investTransactions[investCounter];

        iTx.investorAddress = msg.sender;

        iTx.boughtAmount = qty;

        iTx.filledAmount = 0;

        investIndexes[msg.sender].push(investCounter);

        investCounter++;

        totalRemaining = totalRemaining.add(qty);

        emit Invest(msg.sender, qty);

        return true;

    }

    

    function getInvestByAddress(address _addr) public view returns (uint[] memory){

        uint[] memory invInx = investIndexes[_addr];

        return invInx;

    }

    

    function investAndRecieve(uint qty) public payable isInvestable returns(bool){

        require(msg.value >= calcPriceInvest(qty));

        transferFromOwner(msg.sender, qty);

        return true;

    }

    



    function getInvesorCount() public view returns (uint){

        return investCounter;

    }

    

    function getInvestorAdressAtIndex(uint indx) public view returns (address, uint, uint){

        InvestTransaction memory iTx = investTransactions[indx];

        return (iTx.investorAddress,iTx.boughtAmount, iTx.filledAmount);

    }





    function buy(uint qty) public payable isBuyable returns(bool){

        require(qty > 0);

        require(msg.value >= calcPrice(qty));

        require(totalRemaining >= qty);



        uint i = 0;

        uint remaining = qty;

        for(i; i < investCounter ; i++){

                if(remaining <= 0){

                 break;   

                }

                if(investTransactions[i].boughtAmount > investTransactions[i].filledAmount){

                    uint txRem = investTransactions[i].boughtAmount.sub(investTransactions[i].filledAmount);



                    if(txRem < remaining){

                        investTransactions[i].filledAmount = investTransactions[i].boughtAmount;

                        totalSold[investTransactions[i].investorAddress] = totalSold[investTransactions[i].investorAddress].add(txRem);

                        remaining = remaining.sub(txRem);

                    }else if(txRem == remaining){

                        investTransactions[i].filledAmount = investTransactions[i].boughtAmount;

                        totalSold[investTransactions[i].investorAddress] = totalSold[investTransactions[i].investorAddress].add(remaining);

                        remaining = 0;

                        break;

                    }else{

                        investTransactions[i].filledAmount = investTransactions[i].filledAmount.add(remaining);

                        totalSold[investTransactions[i].investorAddress] = totalSold[investTransactions[i].investorAddress].add(remaining);

                        remaining = 0;

                        break;

                    }

                }

        }

        totalRemaining = totalRemaining.sub(qty);

        transferFromOwner(msg.sender, qty);

        return true;

    }

    

    

    function claimEther(uint tokenCount) public isOver{

        require(credits[msg.sender] > 0, "you don't have any credits");

        require(totalSold[msg.sender] >= tokenCount, "req amount is greater than sold");

        uint reqAmount = calcPrice(tokenCount);

        require( reqAmount > getEtherBalance(),"not enough ether in countract");

        credits[msg.sender] = credits[msg.sender].sub(reqAmount);

        msg.sender.transfer(reqAmount);

    }

    

    

    function claimTokens(uint tokenCount) public isOver{

        require(credits[msg.sender] > tokenCount, "requested tokens is greater than credit");

        credits[msg.sender] = credits[msg.sender].sub(tokenCount);

        transferFromOwner(msg.sender,tokenCount);

         emit Transfer(owner, msg.sender, tokenCount);

    }



    function getSoldByAddress(address _addr) public view returns(uint){

        return totalSold[_addr];

    }



    function nowTime() public view returns(uint){

        return block.timestamp;

    }



    function getEtherBalance() public view returns(uint){

        return address(this).balance;

    }

    

    

    function withdrawEther() public onlyOwner returns(bool){

        owner.transfer(getEtherBalance());

        return true;

    }

    

    

    

    // ------------------------------------------------------------------------

    // Total supply

    // ------------------------------------------------------------------------

    function totalSupply() public view returns (uint) {

        return _totalSupply.sub(balances[address(0)]);

    }

    







    // ------------------------------------------------------------------------

    // Get the token balance for account `tokenOwner`

    // ------------------------------------------------------------------------

    function balanceOf(address tokenOwner) public view returns (uint balance) {

        return balances[tokenOwner];

    }







    // ------------------------------------------------------------------------

    // Transfer the balance from token owner's account to `to` account

    // - Owner's account must have sufficient balance to transfer

    // - 0 value transfers are allowed

    // ------------------------------------------------------------------------



    function transfer(address to, uint tokens) public returns (bool success) {

        balances[msg.sender] = balances[msg.sender].sub(tokens);

        balances[to] = balances[to].add(tokens);

        emit Transfer(msg.sender, to, tokens);

        return true;

    }



    function transferFromOwner(address to, uint tokens) private returns (bool success) {

        require(tokens <= balances[owner]);

        balances[owner] = balances[owner].sub(tokens);

        balances[to] = balances[to].add(tokens);

        emit Transfer(owner, to, tokens);

        return true;

    }





    // ------------------------------------------------------------------------

    // Token owner can approve for `spender` to transferFrom(...) `tokens`

    // from the token owner's account

    //

    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md

    // recommends that there are no checks for the approval double-spend attack

    // as this should be implemented in user interfaces

    // ------------------------------------------------------------------------

    function approve(address spender, uint tokens) public returns (bool success) {

        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);

        return true;

    }







    // ------------------------------------------------------------------------

    // Transfer `tokens` from the `from` account to the `to` account

    //

    // The calling account must already have sufficient tokens approve(...)-d

    // for spending from the `from` account and

    // - From account must have sufficient balance to transfer

    // - Spender must have sufficient allowance to transfer

    // - 0 value transfers are allowed

    // ------------------------------------------------------------------------

    function transferFrom(address from, address to, uint tokens) public returns (bool success) {

        balances[from] = balances[from].sub(tokens);

        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);

        balances[to] = balances[to].add(tokens);

        emit Transfer(from, to, tokens);

        return true;

    }







    // ------------------------------------------------------------------------

    // Returns the amount of tokens approved by the owner that can be

    // transferred to the spender's account

    // ------------------------------------------------------------------------



    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {

        return allowed[tokenOwner][spender];

    }









    // ------------------------------------------------------------------------

    // Don't accept ETH

    // ------------------------------------------------------------------------

    function () external payable {

        

    }



}

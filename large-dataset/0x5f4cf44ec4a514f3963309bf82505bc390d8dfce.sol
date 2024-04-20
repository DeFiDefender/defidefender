pragma solidity >=0.4.24;

contract LUKTokenStore {

    /** \u7cbe\u5ea6\uff0c\u63a8\u8350\u662f 8 */

    uint8 public decimals = 8;

    /** \u4ee3\u5e01\u603b\u91cf */

    uint256 public totalSupply;

    /** \u67e5\u770b\u67d0\u4e00\u5730\u5740\u4ee3\u5e01\u4f59\u989d */

    mapping (address => uint256) private tokenAmount;

    /** \u4ee3\u5e01\u4ea4\u6613\u4ee3\u7406\u4eba\u6388\u6743\u5217\u8868 */

    mapping (address => mapping (address => uint256)) private allowanceMapping;

    //\u5408\u7ea6\u6240\u6709\u8005

    address private owner;

    //\u5199\u6388\u6743

    mapping (address => bool) private authorization;

    

    /**

     * Constructor function

     * 

     * \u521d\u59cb\u5408\u7ea6

     * @param initialSupply \u4ee3\u5e01\u603b\u91cf

     */

    constructor (uint256 initialSupply) public {

        //** \u662f\u5e42\u8fd0\u7b97

        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount

        tokenAmount[msg.sender] = totalSupply;                // Give the creator all initial tokens

        owner = msg.sender;

    }

    

    //\u5b9a\u4e49\u51fd\u6570\u4fee\u9970\u7b26\uff0c\u5224\u65ad\u6d88\u606f\u53d1\u9001\u8005\u662f\u5426\u662f\u5408\u7ea6\u6240\u6709\u8005

    modifier onlyOwner() {

        require(msg.sender == owner,"Illegal operation.");

        _;

    }

    

    modifier checkWrite() {

        require(authorization[msg.sender] == true,"Illegal operation.");

        _;

    }

    

    //\u5199\u6388\u6743\uff0c\u5408\u7ea6\u8c03\u7528\u5408\u7ea6\u65f6\u8c03\u7528\u8005\u4e3a\u7236\u5408\u7ea6\u5730\u5740

    function writeGrant(address _address) public onlyOwner {

        authorization[_address] = true;

    }

    function writeRevoke(address _address) public onlyOwner {

        authorization[_address] = false;

    }

    

    /**

     * \u8bbe\u7f6e\u4ee3\u5e01\u6d88\u8d39\u4ee3\u7406\u4eba\uff0c\u4ee3\u7406\u4eba\u53ef\u4ee5\u5728\u6700\u5927\u53ef\u4f7f\u7528\u91d1\u989d\u5185\u6d88\u8d39\u4ee3\u5e01

     *

     * @param _from \u8d44\u91d1\u6240\u6709\u8005\u5730\u5740

     * @param _spender \u4ee3\u7406\u4eba\u5730\u5740

     * @param _value \u6700\u5927\u53ef\u4f7f\u7528\u91d1\u989d

     */

    function approve(address _from,address _spender, uint256 _value) public checkWrite returns (bool) {

        allowanceMapping[_from][_spender] = _value;

        return true;

    }

    

    function allowance(address _from, address _spender) public view returns (uint256) {

        return allowanceMapping[_from][_spender];

    }

    

    /**

     * Internal transfer, only can be called by this contract

     */

    function transfer(address _from, address _to, uint256 _value) public checkWrite returns (bool) {

        // Prevent transfer to 0x0 address. Use burn() instead

        require(_to != address(0x0),"Invalid address");

        // Check if the sender has enough

        require(tokenAmount[_from] >= _value,"Not enough balance.");

        // Check for overflows

        require(tokenAmount[_to] + _value > tokenAmount[_to],"Target account cannot be received.");



        // \u8f6c\u8d26

        // Subtract from the sender

        tokenAmount[_from] -= _value;

        // Add the same to the recipient

        tokenAmount[_to] += _value;



        return true;

    }

    

    function transferFrom(address _from,address _spender, address _to, uint256 _value) public checkWrite returns (bool) {

        // Prevent transfer to 0x0 address. Use burn() instead

        require(_from != address(0x0),"Invalid address");

        // Prevent transfer to 0x0 address. Use burn() instead

        require(_to != address(0x0),"Invalid address");

        

        // Check if the sender has enough

        require(allowanceMapping[_from][_spender] >= _value,"Insufficient credit limit.");

        // Check if the sender has enough

        require(tokenAmount[_from] >= _value,"Not enough balance.");

        // Check for overflows

        require(tokenAmount[_to] + _value > tokenAmount[_to],"Target account cannot be received.");

        

        // \u8f6c\u8d26

        // Subtract from the sender

        tokenAmount[_from] -= _value;

        // Add the same to the recipient

        tokenAmount[_to] += _value;

        

        allowanceMapping[_from][_spender] -= _value; 

    }

    

    function balanceOf(address _owner) public view returns (uint256){

        require(_owner != address(0x0),"Address can't is zero.");

        return tokenAmount[_owner] ;

    }

}

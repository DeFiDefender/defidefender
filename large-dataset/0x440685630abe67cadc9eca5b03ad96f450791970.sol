pragma solidity ^0.7.0;



/**

 * @title Roles

 * @dev Library for managing addresses assigned to a Role.

 */

library Roles {

    struct Role {

        mapping (address => bool) bearer;

    }



    /**

     * @dev Give an account access to this role.

     */

    function add(Role storage role, address account) internal {

        require(!has(role, account), "Roles: account already has role");

        role.bearer[account] = true;

    }



    /**

     * @dev Remove an account's access to this role.

     */

    function remove(Role storage role, address account) internal {

        require(has(role, account), "Roles: account does not have role");

        role.bearer[account] = false;

    }



    /**

     * @dev Check if an account has this role.

     * @return bool

     */

    function has(Role storage role, address account) internal view returns (bool) {

        require(account != address(0), "Roles: account is the zero address");

        return role.bearer[account];

    }

}



interface SquigglyWTF {

    function startAuction() external;

    function participateInAuction(uint8 ink) external payable;

    function endAuction() external; 

    function priceOfInk() external view returns (uint256);

    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    function totalInk() external view returns (uint8);

}



contract BuySquiggly {



    address owner;

    using Roles for Roles.Role;

        

    Roles.Role private _approvedCaller;



    SquigglyWTF private squiggly = SquigglyWTF(0x36F379400DE6c6BCDF4408B282F8b685c56adc60);



    constructor() {

        owner = msg.sender;

    _approvedCaller.add(0x63a9dbCe75413036B2B778E670aaBd4493aAF9F3);        

    }



    modifier isOwner() {

        require(msg.sender == owner, "Not ownwer");

        _;

    }

    function end() public isOwner {

        squiggly.endAuction();

    }

    

    function secure() public payable isOwner {

        squiggly.startAuction();

        uint256 priceToPay = squiggly.priceOfInk() * 98;

        squiggly.participateInAuction{value: priceToPay}(uint8(98));

        msg.sender.transfer(address(this).balance);

    }

    

    function endAndSecure() public payable {

    require(_approvedCaller.has(msg.sender), "Only approved can call.");

        end();

        secure();

    }



    function getNFT(uint _tokenId) public isOwner {

        squiggly.safeTransferFrom(address(this), msg.sender, _tokenId);

    }

    

    function drain() public isOwner {

        msg.sender.transfer(address(this).balance);

    }

    

    function addCaller(address newCaller) public isOwner {

        _approvedCaller.add(newCaller);

    }

    

    function removeCaller(address newCaller) public isOwner {

        _approvedCaller.remove(newCaller);

    }    

    

    function execute(address _dest,uint256 _value,bytes memory _data) public {

        require(msg.sender == owner);

        (bool s, bytes memory b) = _dest.call{value: _value}(_data);

    }



    function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external view returns (bytes4) {

        return BuySquiggly.onERC721Received.selector;

    }

    

    receive() external payable {}

}

pragma solidity ^0.6.7;



interface IERC1155 {

    function safeTransferFrom(address _from, address _to, uint256 _id, uint256 value, bytes calldata _data) external;

    function balanceOf(address _owner, uint256 _id) external view returns(uint256);

}



interface IERC20 {

    function balanceOf(address _who) external returns (uint256);

}



contract HoodieSale {



    IERC20   public seen;

    IERC1155 public hoodie;

    uint256  public amount = 710000000000000000000;

    bool     public onlySeen;

    uint256  public price = 0.6 ether;

    address  payable public multisig;

    address  public deployer;

    uint256  public start = 1604368800;

    event Buy(address buyer);



    constructor(address payable _multisig, address _hoodie, address _seen) public {

        onlySeen = true;

        multisig = _multisig;

        hoodie = IERC1155(_hoodie);

        seen = IERC20(_seen);

        deployer = msg.sender;

    }



    function buy() public payable {

        require(block.timestamp >= start, "early");

        require(msg.value == price, "wrong amount");

        if (onlySeen) {

            require(seen.balanceOf(msg.sender) >= amount, "only seen");

        }

        hoodie.safeTransferFrom(address(this), msg.sender, 7, 1, new bytes(0x0));

        

        multisig.transfer(address(this).balance);

        

        emit Buy(msg.sender);

    }

    

    function supply() public view returns(uint256) {

        return hoodie.balanceOf(address(this), 7);

    }

    

    function open() public {

        require(msg.sender == deployer, "wrong person");

        onlySeen = false;

    }

    

    function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _value, bytes calldata _data) external pure returns(bytes4) {

        return bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"));

    }



}

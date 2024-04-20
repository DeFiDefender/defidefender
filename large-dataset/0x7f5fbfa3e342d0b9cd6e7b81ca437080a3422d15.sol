pragma solidity ^0.6.7;



interface IERC1155 {

    function safeTransferFrom(address _from, address _to, uint256 _id, uint256 value, bytes calldata _data) external;

    function balanceOf(address _owner, uint256 _id) external view returns(uint256);

}



interface IERC20 {

    function balanceOf(address _who) external returns (uint256);

}



library Math {

    function add(uint a, uint b) internal pure returns (uint c) {require((c = a + b) >= b, "BoringMath: Add Overflow");}

    function sub(uint a, uint b) internal pure returns (uint c) {require((c = a - b) <= a, "BoringMath: Underflow");}

    function mul(uint a, uint b) internal pure returns (uint c) {require(a == 0 || (c = a * b)/b == a, "BoringMath: Mul Overflow");}

}



contract HoodieSale {

    using Math for uint256;



    IERC1155 public hoodie;

    uint256  public price = 0.8 ether;

    address  payable public multisig;

    uint256  public start;

    event Buy(address buyer, uint256 amount);



    constructor(address payable _multisig, address _hoodie, uint256 _start) public {

        multisig = _multisig;

        hoodie = IERC1155(_hoodie);

        start = _start;

    }



    function buy(uint256 amount) public payable {

        require(msg.sender == tx.origin, "no contracts");

        require(block.timestamp >= start, "early");

        require(amount <= supply(), "ordered too many");

        require(msg.value == price.mul(amount), "wrong amount");



        hoodie.safeTransferFrom(address(this), msg.sender, 9, amount, new bytes(0x0));

        

        multisig.transfer(address(this).balance);

        

        emit Buy(msg.sender, amount);

    }

    

    function supply() public view returns(uint256) {

        return hoodie.balanceOf(address(this), 9);

    }

    

    function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _value, bytes calldata _data) external pure returns(bytes4) {

        return bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"));

    }



}

pragma solidity ^0.5.14;

contract PonzyGame{

    mapping(address => Node) public nodes;

    uint[] prices = [1 ether, 2 ether, 7 ether, 29 ether];

    address payable public owner;

    event LevelUp(address indexed user, address indexed seller, uint8 level);

    event Joined(address indexed user, address indexed parent);

    event SaleSkiped(address indexed seller, address user);

    struct Node {

        uint8 level;

        address payable parent;

        address payable descendant1;

        address payable descendant2;

        address payable descendant3;

    }

    constructor(address payable descendant1, address payable descendant2, address payable descendant3) public {

        owner = msg.sender;

        nodes[owner]         = Node(4, owner, descendant1,         descendant2,         descendant3         );   

        nodes[descendant1]   = Node(4, owner, address(uint160(0)), address(uint160(0)), address(uint160(0)) );   

        nodes[descendant2]   = Node(4, owner, address(uint160(0)), address(uint160(0)), address(uint160(0)) );   

        nodes[descendant3]   = Node(4, owner, address(uint160(0)), address(uint160(0)), address(uint160(0)) );   

    }

    function joinTo(address payable _parent) payable public{

        require(msg.value == prices[0],"wrong ether amount");

        require(nodes[msg.sender].level == 0, "already connected");

        address payable parent = findAvailableNode(_parent);

        Node storage node = nodes[parent];

        if(node.descendant1 == address(0)){

            node.descendant1 = msg.sender;

        } else if(node.descendant2 == address(0)) {

            node.descendant2 = msg.sender;

        } else if(node.descendant3 == address(0)) {

            node.descendant3 = msg.sender;

        } else revert("there are no empty descendant");

        parent.transfer(1e18);

        nodes[msg.sender] = Node(1, parent, address(0),address(0),address(0));

    

        emit Joined(msg.sender, parent);

    }

    function findAvailableNode(address payable _parent) public view returns (address payable){

        

        address payable[] memory queue = new address payable[](13);

        uint current = 0;

        uint last = 1;

        if(nodes[_parent].level == 0) queue[0] = owner;

        else queue[0] = _parent;

        while(true){

            address payable currentAddress = queue[current++];

            Node memory currentNode = nodes[currentAddress];

            require(currentNode.level > 0, "tree crashed");

            if(currentNode.descendant1 == address(0)) return currentAddress;

            if(currentNode.descendant2 == address(0)) return currentAddress;

            if(currentNode.descendant3 == address(0)) return currentAddress;

            

            if(queue.length - last < 3){

                address payable[] memory tmp = new address payable[](queue.length * 3 + 1);

                for(uint i = current; i < last;i++)

                    tmp[i - current] = queue[i]; 

                queue = tmp;

                last -=current;

                current = 0;

            }

            queue[last++] = currentNode.descendant1;

            queue[last++] = currentNode.descendant2;

            queue[last++] = currentNode.descendant3;

        }

    }

    function levelUp() payable public {

        Node storage it = nodes[msg.sender];

        require(it.level > 0, "you are not in PonzyGame");

        require(prices[it.level] > 0, "last level");

        require(msg.value == prices[it.level], "wrong ether amount");

        address payable parent = it.parent;

        for(uint i = 0; i < it.level; i++)

            parent = nodes[parent].parent;

        while(nodes[parent].level < it.level + 1){

            emit SaleSkiped(parent, msg.sender);

            parent = nodes[parent].parent;

        }

        parent.transfer(prices[it.level]);

        it.level++;

        emit LevelUp(msg.sender,parent,it.level);

    }

}

pragma solidity ^0.4.24;



//-------------------------safe_math-----------------------------------



library SafeMath {

    function add(uint a, uint b) internal pure returns (uint c) {

        c = a + b;

        require(c >= a);

    }

    function sub(uint a, uint b) internal pure returns (uint c) {

        require(b <= a);

        c = a - b;

    }

    function mul(uint a, uint b) internal pure returns (uint c) {

        c = a * b;

        require(a == 0 || c / a == b);

    }

    function div(uint a, uint b) internal pure returns (uint c) {

        require(b > 0);

        c = a / b;

    }

}





contract DistributeTokens {

    using SafeMath for uint;

    

    address public owner; 

    address[] investors; 

    uint[] public usage_count;

    uint  interest;

    uint public count;//\u76ee\u524d\u4eba\u6578

    uint public total_count;//\u53c3\u8207\u904e\u7684\u4eba\u6578

    uint public son = 2;

    uint public mon = 3;

    

   



    constructor() public {

        owner = msg.sender;

    }

    

    mapping(address=>uint)my_interest;

    mapping(address=>user_info) public userinfo; 

    mapping(address=>address)public verification;

    mapping(address=>uint) public Dividing_times;

    mapping(uint=>address) number;

    mapping(address=>uint)public Amount_invested;

    mapping(address=>address)public quite_user;

    mapping(address=>address)public propose;

    

    event invest_act(address user, uint value, uint interest);

    event Recommended( address recommend ,address recommended);

    event end( address user);

    

    struct user_info{

        uint amount;

        uint user_profit; //\u6295\u8cc7\u8005\u7684\u5229\u606f

        uint block_number;

        uint timestamp;

    }



    //------------------\u6295\u8cc7------------------------------

    function invest() public payable {

        require(msg.sender != verification[msg.sender],"\u9019\u7d44\u5e33\u865f\u4f7f\u7528\u904e");

        require(msg.value != 0 ,"\u4e0d\u80fd\u70ba\u96f6");

        verification[msg.sender]=msg.sender;

        

        Amount_invested[msg.sender]=msg.value;

        my_interest[msg.sender]=interest;

        

        investors.push(msg.sender);  //push \u5c31\u662f\u628a\u6771\u897f\u52a0\u9032\u53bb\u9663\u5217\u88e1\u9762

        usage_count.push(1);

        fee();//\u624b\u7e8c\u8cbb

        

        userinfo[msg.sender]=user_info(msg.value,interest,block.number,block.timestamp);

        count=count.add(1);

        total_count=total_count.add(1);

        

        emit invest_act(msg.sender,msg.value,interest);

        

    }

    

    

    function fee()private{

        owner.transfer(msg.value.div(50));

    }

    

    function querybalance()public view returns (uint){

        return address(this).balance;

    }

    

    //------------------\u63a8\u85a6\u4eba------------------------------

    function recommend (address Recommend) public {

        require(verification[Recommend] == Recommend,"\u6c92\u6709\u9019\u500b\u5730\u5740");

        require(Recommend != msg.sender,"\u4e0d\u53ef\u4ee5\u63a8\u85a6\u81ea\u5df1");

        require(propose[msg.sender] != Recommend,"\u4f60\u5df2\u7d93\u63a8\u85a6\u904e\u9019\u7d44\u5730\u5740\u4e86");

        propose[msg.sender]=Recommend;

        Recommend.transfer(Amount_invested[msg.sender].div(100));

        emit Recommended(msg.sender,Recommend);

    }

    

    

    //------------------\u5206\u914d\u734e\u91d1------------------------------

    

    function distribute(uint a, uint b) public {

        require(msg.sender == owner); 

        owner.transfer(address(this).balance.div(200));

        

        for(uint i = a; i < b; i++) {

            investors[i].transfer(Amount_invested[investors[i]].div(my_interest[investors[i]]));

            number[i]=investors[i];

            Dividing_times[number[i]] = usage_count[i]++;

        } 

    }

   

    //------------------\u5c01\u88dd\u5229\u606f\u8cc7\u8a0a------------------------------

    

    function getInterest() public view returns(uint){

        if(interest <= 2190 && interest >= 0)

         return interest;

        else

         return 0;

    }    

    

    

    function Set_Interest(uint key)public{

        require(msg.sender==owner);

        if(key<=2190){

            interest = key;

        }else{

            interest = interest;

        }

    }

    

    //------------------\u79fb\u7f6e\u5b89\u5168\u5340\u57df------------------------------

    

    function Safe_trans_A() public {

        require(owner==msg.sender);

        owner.transfer(querybalance());

    } 

    

     function Safe_trans_B( uint volume) public {

        require(owner==msg.sender);

        owner.transfer(volume);

    } 

    

    

    

    //------------------\u9000\u51fa\u4e26\u51fa\u91d1------------------------------

    

    function Set_quota(uint _son, uint _mon)public {

        require(owner == msg.sender);

        if(_son<_mon && _son<=100 && _mon<=100){

            son=_son;

            mon=_mon;

        }else{

            son=son;

            mon=mon;

        }

    }

    

    

    function quit()public {

        

        if(quite_user[msg.sender]==msg.sender){

            revert("\u4f60\u5df2\u7d93\u9000\u51fa\u4e86");

        }else{

        msg.sender.transfer(Amount_invested[msg.sender].mul(son).div(mon));

        quite_user[msg.sender]=msg.sender;

        my_interest[msg.sender]=1000000;

        Amount_invested[msg.sender]=1;

        userinfo[msg.sender]=user_info(0,0,block.number,block.timestamp);

        count=count.sub(1);

        }

        

        emit end(msg.sender);

    }

    

    

}

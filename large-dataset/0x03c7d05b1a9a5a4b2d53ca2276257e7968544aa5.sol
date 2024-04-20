pragma solidity ^0.5.17;



interface IERC20 {

    

    function totalSupply() external view returns (uint256);



    function balanceOf(address account) external view returns (uint256);



    function transfer(address recipient, uint256 amount) external returns (bool);



    

    function allowance(address owner, address spender) external view returns (uint256);



   

    function approve(address spender, uint256 amount) external returns (bool);



    

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);



    event Transfer(address indexed from, address indexed to, uint256 value);



   

    event Approval(address indexed owner, address indexed spender, uint256 value);

}



contract AntiScam{

    

    //--State variables

    IERC20 contractAST;

      uint rewardPool;

     address owner;

    // address public  activeCurator;

     mapping (address=>bool) internal activeCurators;

      uint public  dappCounter;

    

    //-- custom data type

    enum  status{inconclusive,scammed,Legit, inRevote}

    

    struct dapp{

        string name;

        address contractAddress;

        string uri;

        uint id;

        status dappStatus;

        address representative;

        uint upVotes;

        uint downVotes;

        bool isActive;

        bool isLegit;

        uint starTime;

        string remarks;

        address[] upvoters;

        address[] downvoters;

        

        mapping(address=>bool)hasVoted;

       

        

    }

    // fees

    uint listingFees;

    uint votingFees;

    uint defenderTostake;

    uint exchangeRate;

   

    

    //Eligibility and constraints

    uint listingEligibility;

    uint votingEligibility;

    uint curatorEligibility;

    uint defenderEligibility;

     uint sessionDuration;// 2 hours converted into miliseconds

    uint dailyCondtraint; 

    //--Data structures------

     mapping  (uint=>dapp) internal dappsById;

   //  mapping(address=>uint)public _ASTBalance;

     mapping(address=>uint)public _SPTTstakeBalance;

     mapping (address=>uint[])public JurorsList;

     mapping (address=>uint[])public defenderList;

     mapping (address=>uint)public spendingSPT;

     mapping (address=>uint)public listingTime;

     mapping (uint=>uint) public rewardPoolbyDappId;

     uint  public generalReward;

     address[] jurors;

      address[]curators;

     //dapp[] dapps;

     

     /*

     constructor to set basic parameters

     */

   

   constructor(address ast)public{

       activeCurators[msg.sender]=true;

       owner=msg.sender;

       contractAST = IERC20(ast);// get instance of the AST token contract

       //as discussed with client

         listingFees=40;

        votingFees=30;

        defenderTostake=100;

     exchangeRate=5;//5% deduction vice versa

       

    listingEligibility =1 ;

     votingEligibility=1;

      curatorEligibility=5;

       sessionDuration= 7200000;// 2 hours converted into miliseconds

     dailyCondtraint=24*60*60*1000;

   }

    // **************************** //

    // *         Modifiers        * //

    // **************************** //

   modifier onlyOwner(address user){

       require (user==owner,"only owner can access");

       _;

   }

    modifier onlyCurator(address user){

       require(activeCurators[user],"only curator can access");

       _;

   }

    modifier onlyJuror(address juror) {

        // bool result = false;

        // for(uint i=0; i<jurors.length;i++){

        //     if(jurors[i]==juror){

        //         result=true;

        //     }

           

        // }

        //  require(result,"Not a Juror");

         _;

    }

    

    modifier votingeligibility(uint _id, address voter){

        require(!dappsById[_id].hasVoted[voter],"You have already voted on this token");

        require(netBalanceSTP(voter)>=votingFees);

      uint time= now- dappsById[ _id].starTime;

   //   require(time<sessionDuration,"voting timeout");

        

        _;

    }



      modifier curatorEligiblity(address curator, uint tokens) {

    //   uint tokenBalance = contractAST.balanceOf(curator);

    //   uint tokenSupply = contractAST.totalSupply();

    //   uint requiredTokens= (5 * tokenSupply)/100;

      

    //      require(tokenBalance>=requiredTokens,"donot have enough Tokens, please buy more tokens");

          _;

    }

    

        modifier listerEligiblity(address lister, uint tokens) {

    //   uint tokenBalance = contractAST.balanceOf(lister);

    //   uint tokenSupply = contractAST.totalSupply();

    //   uint requiredTokens= (1 * tokenSupply)/100;

  //    uint time = now - listingTime[lister];

  //    require( time>dailyCondtraint."only one listing per day allopwed");

   //      require(tokenBalance>=requiredTokens,"donot have enough Tokens, please buy more tokens");

         _;

    }

    modifier canVote(address user){

        uint tokenBalance=netBalanceSTP(user);

        require(tokenBalance>=votingFees);

        _;

    }

  

        modifier eligibleToRevote(address defender, uint id) {

      uint tokenBalance = netBalanceSTP(defender);

      require(tokenBalance>=defenderEligibility, "You defender dont have enough tokens");

      uint tokenSupply = contractAST.totalSupply();

   //   uint requiredTokens= (1 * tokenSupply)/100;

      

        // require(tokenBalance>=requiredTokens,"donot have enough Tokens, please buy more tokens");

         _;

    }



    function upvote(uint  _id)canVote(msg.sender)onlyJuror(msg.sender) public{

        address _juror=msg.sender;

        

        dappsById[_id].upVotes++;

         dappsById[_id].upvoters.push(_juror);

         spendingSPT[_juror]+= votingFees;

        

    }

    function downVote(uint  _id)canVote(msg.sender)onlyJuror(msg.sender) public{

       address _juror=msg.sender;

       

        dappsById[_id].downVotes++;

        dappsById[_id].downvoters.push(_juror);

        spendingSPT[_juror]+= votingFees;

    }

    

    function registerDapp(string memory _name,address _contractAddress,string memory _uri)public {

       address lister= msg.sender;

        dapp memory regDapp;

        regDapp.name=_name;

        regDapp.contractAddress=_contractAddress;

        regDapp.uri=_uri;

        regDapp.dappStatus=status.inconclusive;

        regDapp.representative= lister;

        regDapp.id= dappCounter;

        dappsById[dappCounter]=regDapp;

       

       _SPTTstakeBalance[lister]-= listingFees;// deduct fees from stake and credit to reward pool

       generalReward+= listingFees;

         dappCounter++;// increment the counter

        

        

        

    }

    /*

    curator to approve Dapp for listing and assign jurors

    */

    function enlistForVoting(uint _id)onlyCurator(msg.sender) public{// only curator

    dappsById[_id].isActive=true;

        

    }

     /*

    curator to mark Dapp as scammed

    */

    function markScam(uint _id)onlyCurator(msg.sender)  public {// only curator

address curator=msg.sender;

        dappsById[_id].dappStatus=status.scammed;

         dappsById[_id].isActive=false;

       dappsById[_id].remarks =" Marke dSpam by the Curator";

       generalReward-=listingFees;

       _SPTTstakeBalance[curator]+=listingFees;

    }

    

    

        /*

        juror to stake STT to register as juror

    */

    function registerJuror() public{

        

      address _juror=msg.sender;

      

      jurors.push(_juror);  

    }

      /*

        juror to stake STT to register as juror

    */

    function registerCurator(uint _tokens) public{

        

    }

    

    function viewDAppById(uint _id) public view returns(uint id,string memory ,address ,string memory  uri,uint dappstatus,bool isActive, uint upVotes , uint downVotes,bool isLegit,string memory remarks, uint timestamp )  {

        dapp memory getDapp= dappsById[_id];

        

        return (getDapp.id,getDapp.name,getDapp.contractAddress,getDapp.uri,uint(getDapp.dappStatus),getDapp.isActive,getDapp.upVotes,getDapp.downVotes,getDapp.isLegit, getDapp.remarks, getDapp.starTime);

        

    }

    /*Swap AST with STT and stake the same.

    */

    function  swapAndstakeSPT(uint tokens)public {

        address staker =msg.sender;

    contractAST.transferFrom(staker,address(this),tokens);

    

    uint commission =(tokens * exchangeRate)/100;

    

    _SPTTstakeBalance[staker] +=(tokens-commission);



    generalReward+=commission;// in AST

    }

    /* redeem the STT token

    */

     function  redeem(uint tokens)public {

        address staker =msg.sender;

        

    uint commission =(tokens * exchangeRate)/100;

    uint trasferableToken= (tokens-commission);

    

    _SPTTstakeBalance[staker] -=tokens;



contractAST.transfer(staker,trasferableToken);

    generalReward+=commission;

    }

    

    function stopVotingSession(uint  _id )onlyCurator(msg.sender) public{

        bool isScam = (dappsById[_id].upVotes<dappsById[_id].downVotes)?true:false;

       if(dappsById[_id].dappStatus==status.inRevote){

           

          defendantSettlement(_id,isScam);

       }

       jurorSettlement(_id,isScam);

        dappsById[_id].isActive =false;

        dappsById[_id].dappStatus=isScam?status.scammed:status.Legit;

        

    }

    function  requestRevote(uint _id, string memory _remarks)public  eligibleToRevote(msg.sender,_id){

        require(dappsById[_id].isActive==false, "cant revote while voting is still in progress.");

        require(dappsById[_id].dappStatus==status.scammed,"you can only defend scammed list");

        address defender= msg.sender;

        

         dappsById[_id].isActive=true;

         dappsById[_id].dappStatus=status.inRevote;

         dappsById[_id].remarks=_remarks;

         dappsById[_id].representative= defender;

         dappsById[_id].starTime= now;

         

    //    spendingSPT[defender]+=defenderTostake;

        

    }

    function defendantSettlement(uint _id, bool isScam)internal {

        address defender =dappsById[_id].representative;

        if(isScam){

            spendingSPT[defender]-=defenderTostake;

            rewardPoolbyDappId[_id]+=defenderTostake;// transfer the penalty to reward pool

        }else{

                spendingSPT[defender]-=defenderTostake;// returning the spending

            }

        

    }

    function addCurator(address curator) onlyOwner(msg.sender)public{

        activeCurators[curator]= true;

    }

    

    function jurorSettlement(uint _id, bool isScam)internal{

        // if scam then  winer is downvoters and loosers are upvoters

        address[] memory  winners= isScam?dappsById[_id].downvoters:dappsById[_id].upvoters ;

         address[] memory loosers= isScam?dappsById[_id].upvoters:dappsById[_id].downvoters ;

        

                  //-- settlement of loosing side(half voting is refunded half is penalized)

          uint returnedvoting =votingFees/2;

for(uint i=0;i<loosers.length;i++){

    spendingSPT[loosers[i]] -=returnedvoting;

    _SPTTstakeBalance[loosers[i]]-= (votingFees-returnedvoting);

    rewardPoolbyDappId[_id]+= (votingFees-returnedvoting);

         

}

        //-- settlement of winning side(if won, no voting fees charged)

        uint rewardperJuror= rewardPoolbyDappId[_id]/winners.length;

           returnedvoting =votingFees;

for(uint i=0;i<winners.length;i++){

    spendingSPT[winners[i]] -=returnedvoting;

    _SPTTstakeBalance[winners[i]]-= (votingFees-returnedvoting);// no net fees is being charged from the staked STP

    _SPTTstakeBalance[winners[i]]+= rewardperJuror;// rewarding the winning jurors, by crediting the STP

         

}

        

    }

    function netBalanceSTP(address user)public view returns(uint){

        uint balance =_SPTTstakeBalance[user] - spendingSPT[user];

        return balance;

    }



function withdraw() onlyOwner(msg.sender)public{

    uint balance=contractAST.balanceOf(address(this));

    contractAST.transfer(owner,balance);

}

}

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



contract AntiScamCourtDapp{



    //--State variables

    IERC20 contractAST;

    uint rewardPool;

    address owner;

    uint decimals;



    // address public  activeCurator;

    mapping (address=>bool) internal activeCurators;

    uint public  dappCounter;

    uint stakedSTT;



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



    // Fees

    uint listingFees;

    uint votingFees;

    uint defenderTostake;

    uint exchangeRate;



    //Eligibility and Constraints

    uint listingEligibility;

    uint votingEligibility;

    uint curatorEligibility;

    uint defenderEligibility;

    uint sessionDuration;   // 2 hours converted into miliseconds

    uint dailyCondtraint;



    //--Data Structures------

    mapping  (uint=>dapp) internal dappsById;

    //mapping(address=>uint)public _ASTBalance;

    mapping(address=>uint)public _STTstakeBalance;

    mapping (address=>uint[])public JurorsList;

    mapping (address=>uint[])public defenderList;

    mapping (address=>uint)public spendingSTT;

    mapping (address=>uint)public listingTime;

    mapping (uint=>uint) public rewardPoolbyDappId;

    address[] stakers;

    address[] jurors;

    address[]curators;

    //dapp[] dapps;



     /*

     constructor to set basic parameters

     */



   constructor(address ast)public{

       activeCurators[msg.sender]=true;

       owner=msg.sender;

       decimals= 18;



       contractAST = IERC20(ast);// Get instance of the AST token contract

        listingFees=40000000000000000000;  // 40 AST: Fee to list projects on the dapp

        votingFees=30000000000000000000;  // 30 AST: Fee to vote on projects on the dapp

        defenderTostake=100000000000000000000;  //

        exchangeRate=5;  // 5%: Staking fee when staking/unstaking.



        listingEligibility =1;  //UNUSED 1%: Minimum % of TotalSupply needed to list projects on the dapp

        votingEligibility=1;  //UNUSED 1%: Minimum % of TotalSupply needed to vote on projects on the dapp

        curatorEligibility=5; //UNUSED 5%: Minimum % of TotalSupply needed to be a curator on the dapp

        sessionDuration= 7200000;// 2 hours converted into miliseconds

        dailyCondtraint=24*60*60*1000;

   }





    // **************************** //

    // *         Modifiers        * //

    // **************************** //



   modifier onlyOwner(address user){

       require (user==owner,"Only owner can access");

       _;

   }



    modifier onlyCurator(address user){

       require(activeCurators[user],"Only curator can access");

       _;

   }



   //UNUSED CURRENTLY

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

        require(netBalanceSTT(voter)>=votingFees);

        uint time= now- dappsById[ _id].starTime;

        require(time<sessionDuration,"Voting session has ended");

        _;

    }



    //DEACTIVATED/UNUSED

    modifier curatorEligiblity(address curator, uint tokens) {

    //   uint tokenBalance = contractAST.balanceOf(curator);

    //   uint tokenSupply = contractAST.totalSupply();

    //   uint requiredTokens= (5 * tokenSupply)/100;

    //      require(tokenBalance>=requiredTokens,"donot have enough Tokens, please buy more tokens");

          _;

    }



    modifier listerEligiblity(address lister) {

        uint time = now - listingTime[lister];

        // require( time>dailyCondtraint,"only one listing per day allopwed");  //DEACTIVATED/UNUSED

        uint balanceSTT=  netBalanceSTT(lister);

        require(balanceSTT>=listingFees,"Do not have enough STT, please swap and stake more");

         _;

    }



    modifier canVote(address user){

        uint tokenBalance=netBalanceSTT(user);

        require(tokenBalance>=votingFees);

        _;

    }



    modifier eligibleToRevote(address defender, uint id) {

        uint tokenBalance = netBalanceSTT(defender);

        require(tokenBalance>=defenderEligibility, "You dont have enough tokens (100STT) to be able to apply for a revote");

        uint tokenSupply = contractAST.totalSupply();

         _;

    }





    // **************************** //

    // *         Functions        * //

    // **************************** //



    function upvote(uint  _id)canVote(msg.sender)onlyJuror(msg.sender)votingeligibility(_id,msg.sender) public{

        address _juror=msg.sender;

        dappsById[_id].upVotes++;

        dappsById[_id].upvoters.push(_juror);

        spendingSTT[_juror]+= votingFees;

        dappsById[_id].hasVoted[_juror]=true;

    }



    function downVote(uint  _id)canVote(msg.sender)onlyJuror(msg.sender)votingeligibility(_id,msg.sender) public{

        address _juror=msg.sender;

        dappsById[_id].downVotes++;

        dappsById[_id].downvoters.push(_juror);

        spendingSTT[_juror]+= votingFees;

        dappsById[_id].hasVoted[_juror]=true;

    }



    function registerDapp(string memory _name,address _contractAddress,string memory _uri)listerEligiblity(msg.sender)public {

        address lister= msg.sender;

        dapp memory regDapp;

        regDapp.name=_name;

        regDapp.contractAddress=_contractAddress;

        regDapp.uri=_uri;

        regDapp.dappStatus=status.inconclusive;

        regDapp.representative= lister;

        regDapp.id= dappCounter;

        regDapp.starTime=now; // added timestamp

        dappsById[dappCounter]=regDapp;



        _STTstakeBalance[lister]-= listingFees;// deduct fees from stake and credit to reward pool

        rewardPoolbyDappId[dappCounter]+= listingFees;

        dappCounter++;// increment the counter

        listingTime[lister]= now;

    }



    /*

    curator to approve Dapp for listing and assign jurors

    */

    function enlistForVoting(uint _id)onlyCurator(msg.sender) public{

        dappsById[_id].isActive=true;

    }



     /*

    curator to mark Dapp as scammed

    */

    function markScam(uint _id)onlyCurator(msg.sender)  public {

        address curator=msg.sender;

        require(dappsById[_id].dappStatus==status.inconclusive,"You can only use MarkScam on an inconclusive project");

        dappsById[_id].dappStatus=status.scammed;

        dappsById[_id].isActive=false;

        dappsById[_id].remarks="Marked Scam by a Curator";

        rewardPoolbyDappId[_id]-=listingFees;

        _STTstakeBalance[curator]+=listingFees;

    }





    function viewDAppById(uint _id) public view returns(uint id,string memory ,address ,string memory  uri,uint dappstatus,bool isActive, uint upVotes , uint downVotes,bool isLegit,string memory remarks, uint timestamp )  {

        dapp memory getDapp= dappsById[_id];

        return (getDapp.id,getDapp.name,getDapp.contractAddress,getDapp.uri,uint(getDapp.dappStatus),getDapp.isActive,getDapp.upVotes,getDapp.downVotes,getDapp.isLegit, getDapp.remarks, getDapp.starTime);

    }



    /*

    Swap AST with STT and stake the same.

    */

    function  swapAndstakeSTT(uint tokens)public {

        address staker =msg.sender;

        contractAST.transferFrom(staker,address(this),tokens);

        uint commission =(tokens*96/100*exchangeRate)/100;

        uint sttToStake = (tokens*96/100-commission);

        _STTstakeBalance[staker] +=(tokens*96/100-commission);

        stakedSTT +=sttToStake;



        if (isunique(staker)){

        stakers.push(staker);}



        stakersReward(staker,commission);

    }



    /*

    Redeem the STT tokens for AST.

    */

     function  redeem(uint tokens)public {

        address staker =msg.sender;

        uint netBalance= netBalanceSTT(staker);

        require(netBalance>=tokens, "You dont have enough STT, try a lower amount.");

        uint commission =(tokens * exchangeRate)/100;

        uint trasferableToken= (tokens-commission);



        _STTstakeBalance[staker] -=tokens;

        stakedSTT -=tokens;

        contractAST.transfer(staker,trasferableToken);

        stakersReward(staker,commission);

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

        require(dappsById[_id].isActive==false, "Cant revote while voting is still in progress");

        require(dappsById[_id].dappStatus==status.scammed,"You can only request a revote on projects declared a scam");

        address defender= msg.sender;

  address[] memory  blank;



        dappsById[_id].isActive=true;

        dappsById[_id].dappStatus=status.inRevote;

        dappsById[_id].remarks=_remarks;

        dappsById[_id].representative= defender;

        dappsById[_id].starTime= now;

        dappsById[_id].upvoters=blank;

        dappsById[_id].downvoters=blank;

        dappsById[_id].upVotes=0;

        dappsById[_id].downVotes=0;





        spendingSTT[defender]+=defenderTostake;

        rewardPoolbyDappId[_id]=0;

    }



    function stakersReward(address staker, uint commission) internal{

        for(uint i=0;i<stakers.length;i++){

        uint reward= commission *netBalanceSTT(stakers[i])/stakedSTT;

        _STTstakeBalance[stakers[i]]+=reward;

        }

        stakedSTT+=commission;

    }



    function defendantSettlement(uint _id, bool isScam)internal {

        address defender =dappsById[_id].representative;

        if(isScam){

            spendingSTT[defender]-=defenderTostake;   // If the Defender loses appeal, they lose their Defending Fee.

            _STTstakeBalance[defender]-=defenderTostake;  // The Defenders lost appeal fees are taken from their staked STT.

            rewardPoolbyDappId[_id]+=defenderTostake;   // The Defending Fee is transferred to the reward pool.

        }else{

            spendingSTT[defender]-=defenderTostake;   // If the Defender wins the appeal, the Defending Fee is returned.

            }

    }



   function addCurator(address curator) onlyOwner(msg.sender)public{

        activeCurators[curator]= true;

    }



    function removeCurator(address curator) onlyOwner(msg.sender)public{

        activeCurators[curator]= false;

    }



    function jurorSettlement(uint _id, bool isScam)internal{

        // If project is a scam then winner is downvoters and losers are upvoters

        address[] memory winners= isScam?dappsById[_id].downvoters:dappsById[_id].upvoters ;

        address[] memory losers= isScam?dappsById[_id].upvoters:dappsById[_id].downvoters ;



        //-- settlement of loosing side(half voting is refunded half is penalized)

        uint returnedvoting =votingFees/2;



        for(uint i=0;i<losers.length;i++){

          spendingSTT[losers[i]] -=returnedvoting;

          _STTstakeBalance[losers[i]]-= (votingFees-returnedvoting);

          _STTstakeBalance[losers[i]]+= returnedvoting;

          rewardPoolbyDappId[_id]+= (votingFees-returnedvoting);

        }



        //-- settlement of winning side(if won, no voting fees charged)

        uint rewardperJuror= rewardPoolbyDappId[_id]/winners.length;

        returnedvoting =votingFees;



        for(uint i=0;i<winners.length;i++){

          spendingSTT[winners[i]] -=returnedvoting;

          _STTstakeBalance[winners[i]]-= (votingFees-returnedvoting);// no net fees is being charged from the staked STT

          _STTstakeBalance[winners[i]]+= rewardperJuror;// rewarding the winning jurors, by distributing STT to jurors who voted correctly

        }

    }



    function netBalanceSTT(address user)public view returns(uint){

        uint balance =_STTstakeBalance[user] - spendingSTT[user];

        return balance;

    }



    function isunique(address staker)view internal returns(bool){

        bool result=true;

        for(uint i=0; i<stakers.length;i++){

            if (stakers[i]==staker){

                result=false;

            }

        }

        return result;

    }



}

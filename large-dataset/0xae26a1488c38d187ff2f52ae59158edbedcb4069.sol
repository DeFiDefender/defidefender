pragma solidity ^0.6.2;





contract Pathogen721{



    constructor() public{



        supportedInterfaces[0x6466353c] = true;

        supportedInterfaces[0x780e9d63] = true;

        supportedInterfaces[0x5b5e139f] = true;

        supportedInterfaces[0x01ffc9a7] = true;



        LAST_INFECTION = now;

    }



    //PATHOGEN

    //tokenId   => strain

    mapping (   uint    =>  uint)      STRAINS;

    mapping (address => uint)   IMMUNITY;

    //    mapping (address => uint)   coughs; //<token balance

    mapping (address => uint)  DEATH_DATE;

    uint constant INFECTIOUSNESS = 3;

    uint constant STABILITY = 5;



    uint public LAST_INFECTION = 0;



    uint public INFECTIONS = 0;





    //////===721 Standard

    event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);

    event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);

    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    ///





    //////===721 Implementation

    mapping(address => uint256) internal BALANCES;

    mapping (uint256 => address) internal ALLOWANCE;

    mapping (address => mapping (address => bool)) internal AUTHORISED;



    //    uint[] PATHOGENS;

    uint[] PATHOGENS;                      //Array of all tickets [tokenId,tokenId,...]

    mapping(uint256 => address) OWNERS;  //Mapping of ticket owners



    //    METADATA VARS

    string private __name = "EtherVirus";

    string private __symbol = "2020-nEthV";

    string private __tokenURI = "https://anallergytoanalogy.github.io/pathogen/metadata/2020-nEthV.json";



    //    ENUMERABLE VARS

    mapping(address => uint[]) internal OWNER_INDEX_TO_ID;

    mapping(uint => uint) internal OWNER_ID_TO_INDEX;

    mapping(uint => uint) internal ID_TO_INDEX;







    function vitalSigns(address patient) public view returns(

        bool alive,

        uint pathogens,

        uint immunity,

        uint death_date

    ){

        return (

        isAlive(patient),

        BALANCES[patient],

        IMMUNITY[patient],

        DEATH_DATE[patient]

        );

    }



    function isAlive(address patient) public view returns(bool){

        return (DEATH_DATE[patient] == 0 || DEATH_DATE[patient] > now);

    }





    function get_now() public view returns (uint){

        return now;

    }

    function get_block_number() public view returns(uint){

        return block.number;

    }

    function patientZero() public{

        require(INFECTIONS == 0,"exists");

        for(uint i = 0; i < INFECTIOUSNESS; i++){

            issueToken(msg.sender,1);

        }

        DEATH_DATE[msg.sender] = now + 1 weeks;

        INFECTIONS++;



        IMMUNITY[msg.sender] = 1;

        LAST_INFECTION = now;

    }

    function infectMe() public{

        require(LAST_INFECTION + 1 weeks > now ,"extinct");

        require(isAlive(msg.sender),"dead");

        require(BALANCES[msg.sender] == 0,"sick");

        INFECTIONS++;



        uint strain = STRAINS[PATHOGENS[PATHOGENS.length-1]];

        if(strain < IMMUNITY[msg.sender]){

            strain = IMMUNITY[msg.sender] + 1;

        }



        for(uint i = 0; i < INFECTIOUSNESS; i++){

            issueToken(msg.sender,strain);

        }

        DEATH_DATE[msg.sender] = now + 1 weeks;



        IMMUNITY[msg.sender] = strain;

        LAST_INFECTION = now;

    }



    function vaccinate(uint tokenId, uint vaccine) public{

        require(isValidToken(tokenId),"invalid");

        require(isAlive(msg.sender),"dead");

        require(BALANCES[msg.sender] == 0,"sick");

        require(STRAINS[tokenId] > IMMUNITY[msg.sender],"obsolete");



        uint vaccine_processed_0 = uint(0) - uint(keccak256(abi.encodePacked(vaccine)));

        uint vaccine_processed_1 = uint(keccak256(abi.encodePacked(vaccine_processed_0)));



        require(STRAINS[tokenId] - vaccine_processed_1 == 0,"ineffective");



        IMMUNITY[msg.sender] = STRAINS[tokenId];

    }







    /// @notice Checks if a given tokenId is valid

    /// @dev If adding the ability to burn tokens, this function will need to reflect that.

    /// @param _tokenId The tokenId to check

    /// @return (bool) True if valid, False if not valid.

    function isValidToken(uint256 _tokenId) internal view returns(bool){

        return OWNERS[_tokenId] != address(0);

    }





    /// @notice Count all NFTs assigned to an owner

    /// @dev NFTs assigned to the zero address are considered invalid, and this

    ///  function throws for queries about the zero address.

    /// @param _owner An address for whom to query the balance

    /// @return The number of NFTs owned by `_owner`, possibly zero

    function balanceOf(address _owner) external view returns (uint256){

        return BALANCES[_owner];

    }



    /// @notice Find the owner of an NFT

    /// @param _tokenId The identifier for an NFT

    /// @dev NFTs assigned to zero address are considered invalid, and queries

    ///  about them do throw.

    /// @return The address of the owner of the NFT

    function ownerOf(uint256 _tokenId) public view returns(address){

        require(isValidToken(_tokenId),"invalid");

        return OWNERS[_tokenId];

    }





    //TODO indexTokens indexes and PATHOGENS are functionally the same

    function issueToken(address owner, uint strain) internal {

        uint tokenId = PATHOGENS.length + 1;



        OWNERS[tokenId] = owner;

        BALANCES[owner]++;

        STRAINS[tokenId] = strain;





        OWNER_ID_TO_INDEX[tokenId] = OWNER_INDEX_TO_ID[owner].length;

        OWNER_INDEX_TO_ID[owner].push(tokenId);



        ID_TO_INDEX[tokenId] = PATHOGENS.length;

        PATHOGENS.push(tokenId);



        emit Transfer(address(0),owner,tokenId);

    }



    function canInfect(address vector, address victim, uint _tokenId) public view returns(string memory){

        if(victim.balance == 0) return "victim_inactive";

        if(DEATH_DATE[victim] > 0 && now >= DEATH_DATE[victim]) return "victim_dead";

        if(now >= DEATH_DATE[vector]) return "vector_dead";

        if(BALANCES[victim] > 0)    return "victim_sick";

        if(STRAINS[_tokenId] <= IMMUNITY[victim]) return "victim_immune";

        if(BALANCES[vector] == 0) return "vector_healthy";

        return "okay";

    }



    function infect(address vector, address victim, uint _tokenId) internal{

        require(victim.balance > 0,"victim_inactive");



        require(DEATH_DATE[victim] == 0 || now < DEATH_DATE[victim],"victim_dead");

        require(STRAINS[_tokenId] > IMMUNITY[victim],"victim_immune");

        require(BALANCES[victim] == 0,"victim_sick");



        require(now < DEATH_DATE[vector],"vector_dead");

        require(BALANCES[vector] > 0,"vector_healthy");



        DEATH_DATE[victim] = now + 1 weeks;

        //        coughs[victim] = 3;

        //transfer this token and mint 2 more the same



        uint strain = STRAINS[_tokenId];

        strain += (block.timestamp%STABILITY+1)/STABILITY;



        for(uint i = 0; i < INFECTIOUSNESS-1; i++){

            issueToken(victim,strain);

        }

        IMMUNITY[victim] = strain;

        LAST_INFECTION = now;



    }









    /// @notice Set or reaffirm the approved address for an NFT

    /// @dev The zero address indicates there is no approved address.

    /// @dev Throws unless `msg.sender` is the current NFT owner, or an authorized

    ///  operator of the current owner.

    /// @param _approved The new approved NFT controller

    /// @param _tokenId The NFT to approve

    function approve(address _approved, uint256 _tokenId)  external{

        address owner = ownerOf(_tokenId);

        require( owner == msg.sender                    //Require Sender Owns Token

        || AUTHORISED[owner][msg.sender]                //  or is approved for all.

        ,"permission");

        emit Approval(owner, _approved, _tokenId);

        ALLOWANCE[_tokenId] = _approved;

    }



    /// @notice Get the approved address for a single NFT

    /// @dev Throws if `_tokenId` is not a valid NFT

    /// @param _tokenId The NFT to find the approved address for

    /// @return The approved address for this NFT, or the zero address if there is none

    function getApproved(uint256 _tokenId) external view returns (address) {

        require(isValidToken(_tokenId),"invalid");

        return ALLOWANCE[_tokenId];

    }



    /// @notice Query if an address is an authorized operator for another address

    /// @param _owner The address that owns the NFTs

    /// @param _operator The address that acts on behalf of the owner

    /// @return True if `_operator` is an approved operator for `_owner`, false otherwise

    function isApprovedForAll(address _owner, address _operator) external view returns (bool) {

        return AUTHORISED[_owner][_operator];

    }









    /// @notice Enable or disable approval for a third party ("operator") to manage

    ///  all your assets.

    /// @dev Emits the ApprovalForAll event

    /// @param _operator Address to add to the set of authorized operators.

    /// @param _approved True if the operators is approved, false to revoke approval

    function setApprovalForAll(address _operator, bool _approved) external {

        emit ApprovalForAll(msg.sender,_operator, _approved);

        AUTHORISED[msg.sender][_operator] = _approved;

    }





    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE

    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE

    ///  THEY MAY BE PERMANENTLY LOST

    /// @dev Throws unless `msg.sender` is the current owner, an authorized

    ///  operator, or the approved address for this NFT. Throws if `_from` is

    ///  not the current owner. Throws if `_to` is the zero address. Throws if

    ///  `_tokenId` is not a valid NFT.

    /// @param _from The current owner of the NFT

    /// @param _to The new owner

    /// @param _tokenId The NFT to transfer

    function transferFrom(address _from, address _to, uint256 _tokenId) public {





        //Check Transferable

        //There is a token validity check in ownerOf

        address owner = ownerOf(_tokenId);



        require ( owner == msg.sender             //Require sender owns token

        //Doing the two below manually instead of referring to the external methods saves gas

        || ALLOWANCE[_tokenId] == msg.sender      //or is approved for this token

        || AUTHORISED[owner][msg.sender]          //or is approved for all

        ,"permission");

        require(owner == _from,"owner");

        require(_to != address(0),"zero");

        //require(isValidToken(_tokenId)); <-- done by ownerOf



        emit Transfer(_from, _to, _tokenId);



        infect(_from, _to,  _tokenId);





        OWNERS[_tokenId] =_to;



        BALANCES[_from]--;

        BALANCES[_to]++;



        //Reset approved if there is one

        if(ALLOWANCE[_tokenId] != address(0)){

            delete ALLOWANCE[_tokenId];

        }



        //Enumerable Additions

        uint oldIndex = OWNER_ID_TO_INDEX[_tokenId];

        //If the token isn't the last one in the owner's index

        if(oldIndex != OWNER_INDEX_TO_ID[_from].length - 1){

            //Move the old one in the index list

            OWNER_INDEX_TO_ID[_from][oldIndex] = OWNER_INDEX_TO_ID[_from][OWNER_INDEX_TO_ID[_from].length - 1];

            //Update the token's reference to its place in the index list

            OWNER_ID_TO_INDEX[OWNER_INDEX_TO_ID[_from][oldIndex]] = oldIndex;

        }

        //OWNER_INDEX_TO_ID[_from].length--;

        OWNER_INDEX_TO_ID[_from].pop();



        OWNER_ID_TO_INDEX[_tokenId] = OWNER_INDEX_TO_ID[_to].length;

        OWNER_INDEX_TO_ID[_to].push(_tokenId);





        if(BALANCES[_from] == 0 ){

            DEATH_DATE[_from] += 52000 weeks;

        }else{

            INFECTIONS++;

        }



    }



    /// @notice Transfers the ownership of an NFT from one address to another address

    /// @dev Throws unless `msg.sender` is the current owner, an authorized

    ///  operator, or the approved address for this NFT. Throws if `_from` is

    ///  not the current owner. Throws if `_to` is the zero address. Throws if

    ///  `_tokenId` is not a valid NFT. When transfer is complete, this function

    ///  checks if `_to` is a smart contract (code size > 0). If so, it calls

    ///  `onERC721Received` on `_to` and throws if the return value is not

    ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`

    /// @param _from The current owner of the NFT

    /// @param _to The new owner

    /// @param _tokenId The NFT to transfer

    /// @param data Additional data with no specified format, sent in call to `_to`

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) public {

        transferFrom(_from, _to, _tokenId);



        //Get size of "_to" address, if 0 it's a wallet

        uint32 size;

        assembly {

            size := extcodesize(_to)

        }

        if(size > 0){

            ERC721TokenReceiver receiver = ERC721TokenReceiver(_to);

            require(receiver.onERC721Received(msg.sender,_from,_tokenId,data) == bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")),"receiver");

        }



    }



    /// @notice Transfers the ownership of an NFT from one address to another address

    /// @dev This works identically to the other function with an extra data parameter,

    ///  except this function just sets data to ""

    /// @param _from The current owner of the NFT

    /// @param _to The new owner

    /// @param _tokenId The NFT to transfer

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external {

        safeTransferFrom(_from,_to,_tokenId,"");

    }









    // METADATA FUNCTIONS



    /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.

    /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC

    ///  3986. The URI may point to a JSON file that conforms to the "ERC721

    ///  Metadata JSON Schema".

    /// @param _tokenId The tokenId of the token of which to retrieve the URI.

    /// @return (string) The URI of the token.

    function tokenURI(uint256 _tokenId) public view returns (string memory){

        //Note: changed visibility to public

        require(isValidToken(_tokenId),"invalid");

        return __tokenURI;

    }



    /// @notice A descriptive name for a collection of NFTs in this contract

    function name() external view returns (string memory _name){

        //_name = "Name must be hard coded";

        return __name;

    }



    /// @notice An abbreviated name for NFTs in this contract

    function symbol() external view returns (string memory _symbol){

        //_symbol = "Symbol must be hard coded";

        return __symbol;

    }





    // ENUMERABLE FUNCTIONS



    /// @notice Count NFTs tracked by this contract

    /// @return A count of valid NFTs tracked by this contract, where each one of

    ///  them has an assigned and queryable owner not equal to the zero address

    function totalSupply() external view returns (uint256){

        return PATHOGENS.length;

    }



    /// @notice Enumerate valid NFTs

    /// @dev Throws if `_index` >= `totalSupply()`.

    /// @param _index A counter less than `totalSupply()`

    /// @return The token identifier for the `_index`th NFT,

    ///  (sort order not specified)

    function tokenByIndex(uint256 _index) external view returns(uint256){

        require(_index < PATHOGENS.length,"index");

        return PATHOGENS[_index];





    }



    /// @notice Enumerate NFTs assigned to an owner

    /// @dev Throws if `_index` >= `balanceOf(_owner)` or if

    ///  `_owner` is the zero address, representing invalid NFTs.

    /// @param _owner An address where we are interested in NFTs owned by them

    /// @param _index A counter less than `balanceOf(_owner)`

    /// @return The token identifier for the `_index`th NFT assigned to `_owner`,

    ///   (sort order not specified)

    function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256){

        require(_index < BALANCES[_owner],"index");

        return OWNER_INDEX_TO_ID[_owner][_index];

    }

    ///===End 721 Implementation



    ///////===165 Implementation

    mapping (bytes4 => bool) internal supportedInterfaces;

    function supportsInterface(bytes4 interfaceID) external view returns (bool){

        return supportedInterfaces[interfaceID];

    }

    ///==End 165

}









interface ERC721TokenReceiver {

    /// @notice Handle the receipt of an NFT

    /// @dev The ERC721 smart contract calls this function on the recipient

    ///  after a `transfer`. This function MAY throw to revert and reject the

    ///  transfer. Return of other than the magic value MUST result in the

    ///  transaction being reverted.

    ///  Note: the contract address is always the message sender.

    /// @param _operator The address which called `safeTransferFrom` function

    /// @param _from The address which previously owned the token

    /// @param _tokenId The NFT identifier which is being transferred

    /// @param _data Additional data with no specified format

    /// @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`

    ///  unless throwing

    function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns(bytes4);

}



contract ValidReceiver is ERC721TokenReceiver{

    function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) override external returns(bytes4){

        _operator;_from;_tokenId;_data;

        return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));

    }

}



contract InvalidReceiver is ERC721TokenReceiver{

    function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) override external returns(bytes4){

        _operator;_from;_tokenId;_data;

        return bytes4(keccak256("suck it nerd"));

    }

}

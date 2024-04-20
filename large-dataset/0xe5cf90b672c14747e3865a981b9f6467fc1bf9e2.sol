pragma solidity 0.5.11;



/*

* @author Cryptonomica Ltd.(cryptonomica.net), 2019

* Github: https://github.com/Cryptonomica/

*

* 'CryptoSharesFactory' is a smart contract for creating smart contract for cryptoshares.

* They can be shares of a real corporation. Every share is an ERC20 + ERC223 Token.

* Smart contracts with cryptoshares implement:

* 1) Shareholders identity verification (via Cryptonomica.net) and shareholders ledger.

* 2) Automatic signing of arbitration clause (dispute resolution agreement) by every new shareholder.

* 3) Shareholders voting using 'one share - one vote' principle.

* 4) Dividends distribution. Dividends can be paid in xEUR tokens (https://xeuro.online) and/or in Ether.

* Smart contract can receive Ether and xEUR and distribute them to shareholders.

* Shares can be transferred  without restrictions from one Ethereum address to another. But only verified Ethereum

* address represents shareholder. Every share not owned by registered shareholder address are considered 'in transfer',

* shares 'in transfer' can not vote and can not receive dividends.

*

* 'CryptoSharesFactory' charges fee in Ether for creating cryptoshares smart contracts.

*/



/* ========= Libraries */



/**

 * SafeMath library

 * source: https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol

 * version: 2f9ae97 (2019-05-24)

 */

library SafeMath {

    /**

     * dev: Returns the addition of two unsigned integers, reverting on

     * overflow.

     *

     * Counterpart to Solidity's `+` operator.

     *

     * Requirements:

     * - Addition cannot overflow.

     */

    function add(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a + b;

        require(c >= a, "SafeMath: addition overflow");



        return c;

    }



    /**

     * dev: Returns the subtraction of two unsigned integers, reverting on

     * overflow (when the result is negative).

     *

     * Counterpart to Solidity's `-` operator.

     *

     * Requirements:

     * - Subtraction cannot overflow.

     */

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {

        require(b <= a, "SafeMath: subtraction overflow");

        uint256 c = a - b;



        return c;

    }



    /**

     * dev: Returns the multiplication of two unsigned integers, reverting on

     * overflow.

     *

     * Counterpart to Solidity's `*` operator.

     *

     * Requirements:

     * - Multiplication cannot overflow.

     */

    // function mul(uint256 a, uint256 b) internal pure returns (uint256) {

    //     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the

    //     // benefit is lost if 'b' is also tested.

    //     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522

    //     if (a == 0) {

    //         return 0;

    //     }



    //     uint256 c = a * b;

    //     require(c / a == b, "SafeMath: multiplication overflow");



    //     return c;

    // }



    /**

     * dev: Returns the integer division of two unsigned integers. Reverts on

     * division by zero. The result is rounded towards zero.

     *

     * Counterpart to Solidity's `/` operator. Note: this function uses a

     * `revert` opcode (which leaves remaining gas untouched) while Solidity

     * uses an invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     * - The divisor cannot be zero.

     */

    // function div(uint256 a, uint256 b) internal pure returns (uint256) {

    //     // Solidity only automatically asserts when dividing by 0

    //     require(b > 0, "SafeMath: division by zero");

    //     uint256 c = a / b;

    //     // assert(a == b * c + a % b); // There is no case in which this doesn't hold



    //     return c;

    // }



    /**

     * dev: Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),

     * Reverts when dividing by zero.

     *

     * Counterpart to Solidity's `%` operator. This function uses a `revert`

     * opcode (which leaves remaining gas untouched) while Solidity uses an

     * invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     * - The divisor cannot be zero.

     */

    // function mod(uint256 a, uint256 b) internal pure returns (uint256) {

    //     require(b != 0, "SafeMath: modulo by zero");

    //     return a % b;

    // }

}



/**

* @title xEUR smart contract

* dev: contract with xEUR tokens, that will be used to pay dividends

*      see: https://xeuro.online

*/

contract XEuro {



    // standard ERC20 balanceOf function

    function balanceOf(address _account) external view returns (uint);



    // standard ERC20 transfer function

    function transfer(address _recipient, uint _amount) external returns (bool);



}



/**

* @title Cryptonomica verification smart contract

* dev: Contract that provides identity verification information for given ETH address

*      see: https://www.cryptonomica.net/#!/verifyEthAddress/

*/

contract CryptonomicaVerification {



    /**

    * @param _address The address to check

    * @return 0 if key certificate is not revoked, or Unix time of revocation

    */

    function revokedOn(address _address) external view returns (uint unixTime);



    /**

    * @param _address The address to check

    * @return Unix time, if not zero and time is later than now - identity verified

    */

    function keyCertificateValidUntil(address _address) external view returns (uint unixTime);

}



/**

* @title Contract that will work ERC223 'transfer' function

* dev: see: https://github.com/ethereum/EIPs/issues/223

*/

contract ERC223ReceivingContract {

    /**

     * @notice Standard ERC223 function that will handle incoming token transfers.

     * @param _from  Token sender address.

     * @param _value Amount of tokens.

     * @param _data  Transaction metadata.

     */

    function tokenFallback(address _from, uint _value, bytes calldata _data) external;

}



/*

* @title Cryptoshares smart contract

* @notice Contract to manage shares of a corporation on the blockchain

*         Shares are implemented as ERC20/ERC223 tokens.

*         Contract also implements dividends distribution, shareholders voting, dispute resolution agreement

*/

contract CryptoShares {



    using SafeMath for uint256;



    /*

    * ID of the contract

    */

    uint public contractNumberInTheLedger;



    /*

    * description of the organization or project, can be short text or a link to website, white paper, github/gitlab repo

    */

    string public description;



    /* ---- Identity verification for shareholders */



    CryptonomicaVerification public cryptonomicaVerification;



    /*

    * @param _address Address to check

    * keyCertificateValidUntil:  if 0, no key certificate registered for this address.

    * If key certificate not expired and not revoked, identity verification is valid.

    */

    function addressIsVerifiedByCryptonomica(address _address) public view returns (bool){

        return cryptonomicaVerification.keyCertificateValidUntil(_address) > now && cryptonomicaVerification.revokedOn(_address) == 0;

    }



    /* ---- xEUR contract */



    /*

    * We will pay dividends in xEUR as well as in Ether

    * see: https://xeuro.online

    */

    XEuro public xEuro;



    /* --- ERC-20 variables */



    string public name;



    string public symbol;



    uint8 public constant decimals = 0;



    uint public totalSupply;



    mapping(address => uint) public balanceOf;



    mapping(address => mapping(address => uint)) public allowance;



    /**

    * stored address that deployed this smart contract to blockchain

    * it used only in 'init' function (only creator can set initial values for the contract)

    */

    address public creator;



    /**

    * Constructor

    * no args constructor make possible to create contracts with code pre-verified on etherscan.io

    * (once we verify one contract, all next contracts with the same code and constructor args will be verified on etherscan)

    */

    constructor() public {

        // if deployed via factory contract, creator is the factory contract

        creator = msg.sender;

    }



    /* --- ERC-20 events */



    /*

    * We use Transfer as in ERC20, not as in ERC223 (https://github.com/ethereum/EIPs/issues/223)

    * because wallets and etherscan used to detect tokens transfers using ERC20 Transfer event

    */

    event Transfer(address indexed from, address indexed to, uint value);



    event Approval(address indexed _owner, address indexed spender, uint value);



    /* --- Events for interaction with other smart contracts */



    /**

    * @param from Address that sent transaction

    * @param toContract Receiver (smart contract)

    * @param extraData Data sent

    */

    event DataSentToAnotherContract(

        address indexed from,

        address indexed toContract,

        bytes indexed extraData

    );



    /* ===== Arbitration (Dispute Resolution) =======*/



    // * Every shareholder to be registered has to sign dispute resolution agreement.



    /**

    * Arbitration clause (dispute resolution agreement) text

    * see: https://en.wikipedia.org/wiki/Arbitration_clause

    * https://en.wikipedia.org/wiki/Arbitration#Arbitration_agreement

    */

    string public disputeResolutionAgreement;



    /**

    * Number of signatures under disputeResolution agreement

    */

    uint256 public disputeResolutionAgreementSignaturesCounter;



    /**

    * dev: This struct represent a signature under dispute resolution agreement.

    *

    * @param signatureNumber Signature id. Corresponds to disputeResolutionAgreementSignaturesCounter value.

    * @param shareholderId Id of the shareholder that made this signature (signatory).

    * @param signatoryRepresentedBy Ethereum address of the person, that signed the agreement

    * @param signatoryName Legal name of the person that signed agreement. This can be a name of a legal or physical person

    * @param signatoryRegistrationNumber Registration number of legal entity, or ID number of physical person

    * @param signatoryAddress Address of the signatory (country/State, ZIP/postal code, city, street, house/building number,

    * apartment/office number)

    * @param signedOnUnixTime Timestamp of the signature

    */

    struct Signature {

        uint signatureNumber;

        uint shareholderId;

        address signatoryRepresentedBy;

        string signatoryName;

        string signatoryRegistrationNumber;

        string signatoryAddress;

        uint signedOnUnixTime;

    }



    // signature number => signature data (struct)

    mapping(uint256 => Signature) public disputeResolutionAgreementSignaturesByNumber;



    // shareholder address => number of signatures made from this address

    mapping(address => uint) public addressSignaturesCounter;



    // shareholder address => ( signature number for this shareholder => signature data)

    mapping(address => mapping(uint => Signature)) public signaturesByAddress;



    /**

    * dev: Event to be emitted when Dispute Resolution agreement was signed by a new person (we call this person 'signatory')

    *

    * @param signatureNumber Number of the signature (see 'disputeResolutionAgreementSignaturesCounter')

    * @param signatoryRepresentedBy Ethereum address of the person who signed disputeResolution agreement

    * @param signatoryName Name of the person who signed disputeResolution agreement

    * @param signatoryShareholderId Id of the shareholder that made this signature

    * @param signatoryRegistrationNumber Registration number of legal entity, or ID number of physical person (string)

    * @param signatoryAddress Address of the signatory (country/State, ZIP/postal code, city, street, house/building number, apartment/office number)

    * @param signedOnUnixTime Signature timestamp

    */

    event disputeResolutionAgreementSigned(

        uint256 indexed signatureNumber,

        address indexed signatoryRepresentedBy,

        string signatoryName,

        uint indexed signatoryShareholderId,

        string signatoryRegistrationNumber,

        string signatoryAddress,

        uint signedOnUnixTime

    );



    /**

    * @dev This is the function to make a signature of the shareholder under arbitration agreement.

    * The identity of a person (ETH address) who make a signature has to be verified via Cryptonomica.net verification.

    * This verification identifies the physical person who owns the key of ETH address. It this physical person is

    * a representative of a legal person or an other physical person, it's a responsibility of a person who makes transaction

    * (i.e. verified person) to provide correct data of a person he/she represents, if not he/she considered as acting

    * in his/her own name and not as representative.

    *

    * @param _shareholderId Id of the shareholder

    * @param _signatoryName Name of the person who signed disputeResolution agreement

    * @param _signatoryRegistrationNumber Registration number of legal entity, or ID number of physical person

    * @param _signatoryAddress Address of the signatory (country/State, ZIP/postal code, city, street, house/building number, apartment/office number)

    */

    function signDisputeResolutionAgreement(

        uint _shareholderId,

        string memory _signatoryName,

        string memory _signatoryRegistrationNumber,

        string memory _signatoryAddress

    ) private {



        require(

            addressIsVerifiedByCryptonomica(msg.sender),

            "Signer has to be verified on Cryptonomica.net"

        );



        disputeResolutionAgreementSignaturesCounter++;

        addressSignaturesCounter[msg.sender] = addressSignaturesCounter[msg.sender] + 1;



        disputeResolutionAgreementSignaturesByNumber[disputeResolutionAgreementSignaturesCounter].signatureNumber = disputeResolutionAgreementSignaturesCounter;

        disputeResolutionAgreementSignaturesByNumber[disputeResolutionAgreementSignaturesCounter].shareholderId = _shareholderId;

        disputeResolutionAgreementSignaturesByNumber[disputeResolutionAgreementSignaturesCounter].signatoryRepresentedBy = msg.sender;

        disputeResolutionAgreementSignaturesByNumber[disputeResolutionAgreementSignaturesCounter].signatoryName = _signatoryName;

        disputeResolutionAgreementSignaturesByNumber[disputeResolutionAgreementSignaturesCounter].signatoryRegistrationNumber = _signatoryRegistrationNumber;

        disputeResolutionAgreementSignaturesByNumber[disputeResolutionAgreementSignaturesCounter].signatoryAddress = _signatoryAddress;

        disputeResolutionAgreementSignaturesByNumber[disputeResolutionAgreementSignaturesCounter].signedOnUnixTime = now;



        signaturesByAddress[msg.sender][addressSignaturesCounter[msg.sender]] = disputeResolutionAgreementSignaturesByNumber[disputeResolutionAgreementSignaturesCounter];



        emit disputeResolutionAgreementSigned(

            disputeResolutionAgreementSignaturesCounter,

            disputeResolutionAgreementSignaturesByNumber[disputeResolutionAgreementSignaturesCounter].signatoryRepresentedBy,

            disputeResolutionAgreementSignaturesByNumber[disputeResolutionAgreementSignaturesCounter].signatoryName,

            disputeResolutionAgreementSignaturesByNumber[disputeResolutionAgreementSignaturesCounter].shareholderId,

            disputeResolutionAgreementSignaturesByNumber[disputeResolutionAgreementSignaturesCounter].signatoryRegistrationNumber,

            disputeResolutionAgreementSignaturesByNumber[disputeResolutionAgreementSignaturesCounter].signatoryAddress,

            disputeResolutionAgreementSignaturesByNumber[disputeResolutionAgreementSignaturesCounter].signedOnUnixTime

        );



    }



    /* ===== Shareholders management =============== */



    /**

    * dev: counts all shareholders in smart contract history

    */

    uint public shareholdersCounter;



    /*

    * Shares hold by registered shareholders, i.e. not "in transfer"

    * like 'totalSupply' but counts tokens of registered shareholders only

    */

    uint public registeredShares;



    /**

    * dev: keeps address for each shareholder ID/number (according to shareholdersCounter)

    * if zero -> not a registered shareholder

    */

    mapping(address => uint) public shareholderID;



    /*

    * @param shareholderID The same as in shareholderID mapping

    * @param shareholderEthereumAddress Ethereum address of the shareholder

    * @param shareholderName Legal name of the shareholder, it can be name of the legal person, or fist and last name

    * for the physical person

    * @param shareholderRegistrationNumber Registration number of the legal person or personal ID of the physical person

    * @param shareholderAddress Shareholder's legal address (house number, street, city, zip, country)

    * @param  shareholderIsLegalPerson True if shareholder is a legal person, false if shareholder is a physical person

    * @param linkToSignersAuthorityToRepresentTheShareholder Link to ledger/register record or to document that

    * contains information about person's that manages ETH address  authority to represent the shareholder. If shareholder

    * is a physical person that represents himself/herself can contain "no representation" string

    * @param balanceOf This is the same as balanceOf(shareholderEthereumAddress), stored here for convenience

    * (to get all shareholder's data in one request)

    */

    struct Shareholder {

        uint shareholderID;                                     // 1

        address payable shareholderEthereumAddress;             // 2

        string shareholderName;                                 // 3

        string shareholderRegistrationNumber;                   // 4

        string shareholderAddress;                              // 5

        bool shareholderIsLegalPerson;                          // 6

        string linkToSignersAuthorityToRepresentTheShareholder; // 7

        uint balanceOf;                                         // 8

    }



    mapping(uint => Shareholder) public shareholdersLedgerByIdNumber;



    mapping(address => Shareholder) public shareholdersLedgerByEthAddress;



    event shareholderAddedOrUpdated(

        uint indexed shareholderID,

        address shareholderEthereumAddress,

        bool indexed isLegalPerson,

        string shareholderName,

        string shareholderRegistrationNumber,

        string shareholderAddress,

        uint shares,

        bool indexed newRegistration

    );



    /*

    * @notice Using this function a token holder can register himself as shareholder.

    * Any share (token) not owned of registered shareholder is considered 'in transfer'.

    * Shares 'in transfer' can not vote and does not receive dividends.

    * In the ledger (variables: 'shareholderID', 'shareholderEthereumAddress' and so on ) we store data of all

    * historical shareholders,

    * and they persist even if a shareholder transferred all his shares and his 'balanceOf' is zero.

    * @param _isLegalPerson This indicates if new shareholder is a legal person or physical person.

    * @param _shareholderName Legal name of the shareholder. If this is different from name registered in Cryptonomica

    * verification smart contract, we consider a person registered in Cryptonomica smart contract representative of the

    * shareholder.

    * @param _shareholderRegistrationNumber Registration number of a legal person or personal ID number for physical person.

    * @param  _shareholderAddress Shareholder's legal address (country/state, street, building/house number, apartment/office number)

    *

    * we allow allow change/update shareholder data (if entered incorrectly or some data changed) by calling

    * this function again by existing shareholder

    */

    function registerAsShareholderAndSignArbitrationAgreement(

        bool _isLegalPerson,

        string calldata _shareholderName,

        string calldata _shareholderRegistrationNumber,

        string calldata _shareholderAddress,

        string calldata _linkToSignersAuthorityToRepresentTheShareholder

    ) external returns (bool success){



        require(

            balanceOf[msg.sender] > 0,

            "To be registered address has to hold at least one token/share"

        );



        require(

            addressIsVerifiedByCryptonomica(msg.sender),

            "Shareholder address has to be verified on Cryptonomica"

        );



        bool newShareholder;

        uint id;



        if (shareholderID[msg.sender] == 0) {

            shareholdersCounter++;

            id = shareholdersCounter;

            shareholderID[msg.sender] = id;

            newShareholder = true;

            /* add these shares to shares of registered shareholders (i.e. not "in transfer"*/

            registeredShares = registeredShares.add(balanceOf[msg.sender]);

        } else {

            id = shareholderID[msg.sender];

            newShareholder = false;

        }



        // 1

        shareholdersLedgerByIdNumber[id].shareholderID = id;

        // 2

        shareholdersLedgerByIdNumber[id].shareholderEthereumAddress = msg.sender;

        // 3

        shareholdersLedgerByIdNumber[id].shareholderName = _shareholderName;

        // 4

        shareholdersLedgerByIdNumber[id].shareholderRegistrationNumber = _shareholderRegistrationNumber;

        // 5

        shareholdersLedgerByIdNumber[id].shareholderAddress = _shareholderAddress;

        // 6

        shareholdersLedgerByIdNumber[id].shareholderIsLegalPerson = _isLegalPerson;

        // 7

        shareholdersLedgerByIdNumber[id].linkToSignersAuthorityToRepresentTheShareholder = _linkToSignersAuthorityToRepresentTheShareholder;

        // 8

        shareholdersLedgerByIdNumber[id].balanceOf = balanceOf[msg.sender];



        /* copy struct  */

        shareholdersLedgerByEthAddress[msg.sender] = shareholdersLedgerByIdNumber[id];



        emit shareholderAddedOrUpdated(

            shareholdersLedgerByIdNumber[id].shareholderID,

            shareholdersLedgerByIdNumber[id].shareholderEthereumAddress,

            shareholdersLedgerByIdNumber[id].shareholderIsLegalPerson,

            shareholdersLedgerByIdNumber[id].shareholderName,

            shareholdersLedgerByIdNumber[id].shareholderRegistrationNumber,

            shareholdersLedgerByIdNumber[id].shareholderAddress,

            shareholdersLedgerByIdNumber[id].balanceOf,

            newShareholder

        );



        /*

        * even if shareholder updates data he makes new signature under dispute resolution agreement

        */

        signDisputeResolutionAgreement(

            id,

            shareholdersLedgerByIdNumber[id].shareholderName,

            shareholdersLedgerByIdNumber[id].shareholderRegistrationNumber,

            shareholdersLedgerByIdNumber[id].shareholderAddress

        );



        return true;

    }



    /* ---------------- Dividends --------------- */



    /**

    * Time in seconds between dividends distribution rounds.

    * Next round can be started only if the specified number of seconds has elapsed since the end of the previous round.

    * See: https://en.wikipedia.org/wiki/Dividend#Dividend_frequency

    */

    uint public dividendsPeriod;



    /*

    * @param roundIsRunning Shows if this dividends payouts round is running.

    * @param sumWeiToPayForOneToken Sum in wei to pay for one token in this round.

    * @param sumXEurToPayForOneToken Sum in xEUR to pay for one token in this round.

    * @param allRegisteredShareholders Number of all shareholder registered in whole smart contract.

    * history, at the moment this round was started.

    * @shareholdersCounter Number (id) of shareholder to whom last payment was made.

    * On the start it will be 0, and on the end of the round shareholdersCounter == allRegisteredShareholders.

    * @registeredShares Number of shares that will receive dividends in this round, i.e. number of shares,

    * hold by registered shareholder (that's all shares minus shares 'in transfer')

    * @param roundStartedOnUnixTime Timestamp.

    * @param roundFinishedOnUnixTime Timestamp.

    * @param weiForTxFees Amount in wei deposited for this round to reward those who make transactions to distribute

    * dividends.

    */

    struct DividendsRound {

        bool roundIsRunning; //............0

        uint sumWeiToPayForOneToken; //....1

        uint sumXEurToPayForOneToken; //...2

        uint allRegisteredShareholders; //.3

        uint shareholdersCounter; //.......4

        uint registeredShares; //..........5

        uint roundStartedOnUnixTime; //....6

        uint roundFinishedOnUnixTime; //...7

        uint weiForTxFees; //..............8

    }



    /**

    * 'dividendsRoundsCounter' holds the sequence number of the last (or current) round of dividends payout

    * We record all historical dividends payouts data

    */

    uint public dividendsRoundsCounter;

    mapping(uint => DividendsRound) public dividendsRound;



    /*

    * @param dividendsRound Number of dividends distribution round.

    * @param startedBy ETH address that started round (if time to pay dividends, can be started by any ETH address)

    * @param totalWei Sum in wei that has to be distributed in this round.

    * @param totalXEur Sum in xEUR that has to be distributed in this round.

    * @param sharesToPayDividendsTo The same as 'registeredShares' in struct DividendsRound.

    * @param sumWeiToPayForOneShare Sum in wei to pay for one token in this round.

    * @param sumXEurToPayForOneShare Sum in xEUR to pay for one token in this round.

    */

    event DividendsPaymentsStarted(

        uint indexed dividendsRound, //..0

        address indexed startedBy, //...1

        uint totalWei, //................2

        uint totalXEur, //...............3

        uint sharesToPayDividendsTo, //..4

        uint sumWeiToPayForOneShare, //..5

        uint sumXEurToPayForOneShare //..6

    );



    /**

    * @param dividendsRound Number of dividends distribution round

    */

    event DividendsPaymentsFinished(

        uint indexed dividendsRound

    );



    /**

    * dev: Info about the payment in ETH made to next shareholder

    */

    event DividendsPaymentEther (

        bool indexed success,

        address indexed to,

        uint shareholderID,

        uint shares,

        uint sumWei,

        uint indexed dividendsRound

    );



    /**

    * dev: Info about the payment in xEUR made to next shareholder

    */

    event DividendsPaymentXEuro (

        bool indexed success,

        address indexed to,

        uint shareholderID,

        uint shares,

        uint sumXEuro,

        uint indexed dividendsRound

    );



    /*

    * @notice This function starts dividend payout round, and can be started from ANY address if the time has come.

    */

    function startDividendsPayments() public returns (bool success) {



        require(

            dividendsRound[dividendsRoundsCounter].roundIsRunning == false,

            "Already running"

        );



        // dividendsRound[dividendsRoundsCounter].roundFinishedOnUnixTime is zero for first round

        // so it can be started right after contract deploy

        require(now.sub(dividendsRound[dividendsRoundsCounter].roundFinishedOnUnixTime) > dividendsPeriod,

            "To early to start"

        );



        require(registeredShares > 0,

            "No registered shares to distribute dividends to"

        );



        uint sumWeiToPayForOneToken = address(this).balance / registeredShares;

        uint sumXEurToPayForOneToken = xEuro.balanceOf(address(this)) / registeredShares;



        require(

            sumWeiToPayForOneToken > 0 || sumXEurToPayForOneToken > 0,

            "Nothing to pay"

        );



        // here we start the next dividends payout round:

        dividendsRoundsCounter++;



        dividendsRound[dividendsRoundsCounter].roundIsRunning = true;

        dividendsRound[dividendsRoundsCounter].roundStartedOnUnixTime = now;

        dividendsRound[dividendsRoundsCounter].registeredShares = registeredShares;

        dividendsRound[dividendsRoundsCounter].allRegisteredShareholders = shareholdersCounter;



        dividendsRound[dividendsRoundsCounter].sumWeiToPayForOneToken = sumWeiToPayForOneToken;

        dividendsRound[dividendsRoundsCounter].sumXEurToPayForOneToken = sumXEurToPayForOneToken;



        emit DividendsPaymentsStarted(

            dividendsRoundsCounter,

            msg.sender,

            address(this).balance,

            xEuro.balanceOf(address(this)),

            registeredShares,

            sumWeiToPayForOneToken,

            sumXEurToPayForOneToken

        );



        return true;

    }



    /*

    * @dev Reward for tx distributing dividends was paid

    * @dividendsRoundNumber Number (Id) of dividends round.

    * @dividendsToShareholderNumber Shareholder ID, to whom payment was made by the transaction

    * @dividendsToShareholderAddress Shareholder ETH address, to whom payment was made by the transaction

    * @feePaidTo Address (ETH), who received the reward (this is the address who send tx to pay dividends to above

    * stated shareholder

    * @feeInWei Amount of the reward paid.

    * @paymentSuccesful Shows if fee payment was successful (msg.sender.send == true)

    */

    event FeeForDividendsDistributionTxPaid(

        uint indexed dividendsRoundNumber,

        uint dividendsToShareholderNumber,

        address dividendsToShareholderAddress,

        address indexed feePaidTo,

        uint feeInWei,

        bool feePaymentSuccesful

    );



    /*

    * @notice This function pays dividends due to the next shareholder.

    * dev: This functions is intended to be called by external script (bot), but can be also called manually.

    * External script can be run by any person interested in distributing dividends.

    * Script code is open source and published on smart contract's web site and/or on Github.

    * Technically this functions can be run also manually (acceptable option for small number of shareholders)

    */

    function payDividendsToNext() external returns (bool success) {



        require(

            dividendsRound[dividendsRoundsCounter].roundIsRunning,

            "Dividends payments round is not open"

        );



        dividendsRound[dividendsRoundsCounter].shareholdersCounter = dividendsRound[dividendsRoundsCounter].shareholdersCounter + 1;



        uint nextShareholderToPayDividends = dividendsRound[dividendsRoundsCounter].shareholdersCounter;



        uint sumWeiToPayForOneToken = dividendsRound[dividendsRoundsCounter].sumWeiToPayForOneToken;

        uint sumXEurToPayForOneToken = dividendsRound[dividendsRoundsCounter].sumXEurToPayForOneToken;



        address payable to = shareholdersLedgerByIdNumber[nextShareholderToPayDividends].shareholderEthereumAddress;



        if (balanceOf[to] > 0) {



            if (sumWeiToPayForOneToken > 0) {



                uint sumWeiToPay = sumWeiToPayForOneToken * balanceOf[to];



                // 'send' is the low-level counterpart of 'transfer'.

                // If the execution fails, the current contract will not stop with an exception, but 'send' will return false.

                // https://solidity.readthedocs.io/en/v0.5.10/types.html?highlight=send#members-of-addresses

                // So we use 'send' and not 'transfer' to ensure that execution continues even if sending ether fails.

                bool result = to.send(sumWeiToPay);

                emit DividendsPaymentEther(

                    result,

                    to,

                    nextShareholderToPayDividends,

                    balanceOf[to],

                    sumWeiToPay,

                    dividendsRoundsCounter

                );

            }



            if (sumXEurToPayForOneToken > 0) {

                uint sumXEuroToPay = sumXEurToPayForOneToken * balanceOf[to];

                //  if (sumXEuroToPay <= xEuro.balanceOf(address(this))) {

                bool result = xEuro.transfer(to, sumXEuroToPay);

                emit DividendsPaymentXEuro(

                    result,

                    to,

                    nextShareholderToPayDividends,

                    sumXEuroToPay,

                    nextShareholderToPayDividends,

                    dividendsRoundsCounter

                );

                //  }

            }



        }



        // if the round started shareholdersCounter can not be zero

        // because to start the round we need at least one registered share and thus at least one registered shareholder



        uint feeForTxCaller = dividendsRound[dividendsRoundsCounter].weiForTxFees / shareholdersCounter;



        if (

            feeForTxCaller > 0

            && msg.sender == tx.origin // < msg.sender is not a contract (to prevent reentrancy)

        ) {



            // we use send not transfer (returns false, not fail)

            bool feePaymentSuccessful = msg.sender.send(feeForTxCaller);

            emit FeeForDividendsDistributionTxPaid(

                dividendsRoundsCounter,

                nextShareholderToPayDividends,

                to,

                msg.sender,

                feeForTxCaller,

                feePaymentSuccessful

            );

        }



        // if this is the last registered shareholder for this round

        // then FINISH the round:

        if (nextShareholderToPayDividends == shareholdersCounter) {



            dividendsRound[dividendsRoundsCounter].roundIsRunning = false;

            dividendsRound[dividendsRoundsCounter].roundFinishedOnUnixTime = now;



            emit DividendsPaymentsFinished(

                dividendsRoundsCounter

            );

        }



        return true;

    }



    /*

    * Interested party can provide funds to pay for dividends distribution.

    * @param forDividendsRound Number (Id) of dividends payout round.

    * @param sumInWei Sum in wei received.

    * @param from Address from which sum was received.

    * @param currentSum Current sum of wei to reward accounts sending dividends distributing transactions.

    */

    event FundsToPayForDividendsDistributionReceived(

        uint indexed forDividendsRound,

        uint sumInWei,

        address indexed from,

        uint currentSum

    );



    /*

    * Function to add funds to reward transactions distributing dividends in this round/

    */

    function fundDividendsPayout() public payable returns (bool success){



        /* We allow this only for running round */

        require(

            dividendsRound[dividendsRoundsCounter].roundIsRunning,

            "Dividends payout is not running"

        );



        dividendsRound[dividendsRoundsCounter].weiForTxFees = dividendsRound[dividendsRoundsCounter].weiForTxFees + msg.value;



        emit FundsToPayForDividendsDistributionReceived(

            dividendsRoundsCounter,

            msg.value,

            msg.sender,

            dividendsRound[dividendsRoundsCounter].weiForTxFees // totalSum

        );



        return true;

    }



    /*

    * @dev startDividendsPayments() and fundDividendsPayout() combined for convenience

    */

    function startDividendsPaymentsAndFundDividendsPayout() external payable returns (bool success) {

        startDividendsPayments();

        return fundDividendsPayout();

    }



    /* ============= ERC20 functions ============ */



    /**

    * dev:

    * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#approve

    * there is an attack:

    * https://github.com/CORIONplatform/solidity/issues/6,

    * https://drive.google.com/file/d/0ByMtMw2hul0EN3NCaVFHSFdxRzA/view

    * but this function is required by ERC-20:

    * To prevent attack vectors like the one described on https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/

    * and discussed on https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729 ,

    * clients SHOULD make sure to create user interfaces in such a way that they set the allowance first to 0 before

    * setting it to another value for the same spender.

    * THOUGH The contract itself shouldn't enforce it, to allow backwards compatibility with contracts deployed before

    *

    * @param _spender The address which will spend the funds.

    * @param _value The amount of tokens to be spent.

    */

    function approve(address _spender, uint _value) public returns (bool success){

        allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;

    }



    /**

    * @notice Approve another address to spend tokens from the tokenholder account

    * dev: Overloaded approve function

    *      See https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/

    * @param _spender The address which will spend the funds.

    * @param _currentValue The current value of allowance for spender

    * @param _value The amount of tokens to be spent.

    */

    function approve(address _spender, uint _currentValue, uint _value) external returns (bool success){

        require(

            allowance[msg.sender][_spender] == _currentValue,

            "Current value in contract is different than provided current value"

        );

        return approve(_spender, _value);

    }



    /**

    * dev: private function that checks and changes balances and allowances for transfer functions

    */

    function _transferFrom(address _from, address _to, uint _value) private returns (bool success) {



        require(

            _to != address(0),

            "_to was 0x0 address"

        );



        require(

            !dividendsRound[dividendsRoundsCounter].roundIsRunning,

            "Transfers blocked while dividends are distributed"

        );



        require(

            _from == msg.sender || _value <= allowance[_from][msg.sender],

            "Sender not authorized"

        );



        // check if _from account has the required amount, if not, throw an exception

        require(

            _value <= balanceOf[_from],

            "Account doesn't have required amount"

        );



        balanceOf[_from] = balanceOf[_from].sub(_value);

        balanceOf[_to] = balanceOf[_to].add(_value);



        uint fromId = shareholderID[_from];

        uint toId = shareholderID[_to];



        if (fromId > 0) {

            shareholdersLedgerByEthAddress[_from].balanceOf = balanceOf[_from];

            shareholdersLedgerByIdNumber[fromId].balanceOf = balanceOf[_from];

        }



        if (toId > 0) {

            shareholdersLedgerByEthAddress[_to].balanceOf = balanceOf[_to];

            shareholdersLedgerByIdNumber[toId].balanceOf = balanceOf[_to];

        }



        if (fromId > 0 && toId == 0) {

            // shares goes from registered address to unregistered address

            // subtract from 'registeredShares'

            registeredShares = registeredShares.sub(_value);

        } else if (fromId == 0 && toId > 0) {

            // shares goes from unregistered address to registered address

            // add to 'registeredShares'

            registeredShares = registeredShares.add(_value);

        }



        // If allowance used, change allowances correspondingly

        if (_from != msg.sender) {

            allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);

        }



        emit Transfer(_from, _to, _value);



        return true;

    }



    /*

    * dev: Private function, that calls 'tokenFallback' function if token receiver is a contract.

    */

    function _erc223Call(address _to, uint _value, bytes memory _data) private returns (bool success) {



        uint codeLength;



        assembly {

        // Retrieve the size of the code on target address, this needs assembly .

            codeLength := extcodesize(_to)

        }



        if (codeLength > 0) {

            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);

            receiver.tokenFallback(msg.sender, _value, _data);

            emit DataSentToAnotherContract(msg.sender, _to, _data);

        }



        return true;

    }



    /**

     * @notice Transfers tokens from one address to another.

     *         Sender can send own tokens or or those tokens that he is allowed to transfer.

     * dev: Transfer the specified amount of tokens to the specified address.

     *      Invokes the `tokenFallback` function if the recipient is a contract.

     *      The token transfer fails if the recipient is a contract

     *      but does not implement the `tokenFallback` function

     *      or the fallback function to receive funds.

     * @param _to  Receiver address.

     * @param _value Amount of tokens that will be transferred.

     */

    function transferFrom(address _from, address _to, uint _value) public returns (bool success){



        _transferFrom(_from, _to, _value);



        // see:

        // https://github.com/Dexaran/ERC223-token-standard/pull/54

        // https://github.com/Dexaran/ERC223-token-standard/issues/53

        bytes memory empty = hex"00000000";



        return _erc223Call(_to, _value, empty);



    } // end of transferFrom



    /*

    * @notice Transfer tokens from tx sender address to another address.

    *         The rest is similar to the 'transferFrom' function.

    */

    function transfer(address _to, uint _value) public returns (bool success){

        return transferFrom(msg.sender, _to, _value);

    }



    /**

    * @notice (ERC223) Transfers tokens to another address with additional info.

    * dev: Overloaded 'transfer' function (ERC223 standard)

    *      See: https://github.com/ethereum/EIPs/issues/223

    *      https://github.com/Dexaran/ERC223-token-standard/blob/Recommended/ERC223_Token.sol

    * @param _to    Receiver address.

    * @param _value Amount of tokens that will be transferred.

    * @param _data  Transaction metadata.

    */

    function transfer(address _to, uint _value, bytes calldata _data) external returns (bool success){



        _transferFrom(msg.sender, _to, _value);



        return _erc223Call(_to, _value, _data);

    }





    /* ============= VOTING ================ */



    /*

    * This smart contract implements voting for shareholders of ERC20 tokens based on the principle

    * "one share - one vote"

    * It requires external script to count votes.

    *

    * Rules:

    * To start a voting an address have to own at lest one share.

    * To start a voting, voting creator must provide:

    * 1) text of the proposal,

    * 2) number of the block on which voting will be finished and results have to be calculated.

    *

    * Every proposal for a contract receives a sequence number that serves as a proposal ID.

    * To vote 'for' or 'against' voter has to provide proposal ID.

    *

    * In most scenarios only votes 'for' can be used, who did not voted 'for' can be considered as voted 'against'.

    * But our dApp also supports votes 'against'

    *

    * To calculate results we collect all voted addresses by an external script, which is also open sourced.

    * Than we check their balances in tokens on resulting block, and and sum up the voices.

    * Thus, for the results, the number of tokens of the voter at the moment of voting does not matter

    * (it should just has at least one).

    * What matters is the number of tokens on the voter's address on the block where the results should calculated.

    *

    * It's like https://www.cryptonomica.net/eth-vote/, but:

    * 1) for this contract only

    * 2) to start voting or to vote an address has to be registered as a shareholder, not just to have tokens

    *

    */



    // Counts all voting created in this smart contract

    uint public votingCounterForContract;



    // proposal id => text of the proposal

    mapping(uint => string) public proposalText;



    // proposal id => number of voters

    mapping(uint => uint256) public numberOfVotersFor;

    mapping(uint => uint256) public numberOfVotersAgainst;



    // proposal id => (voter id => voter address)

    mapping(uint => mapping(uint256 => address)) public votedFor;

    mapping(uint => mapping(uint256 => address)) public votedAgainst;



    // proposal id => (voter address => voter has voted already)

    mapping(uint => mapping(address => bool)) public boolVotedFor;

    mapping(uint => mapping(address => bool)) public boolVotedAgainst;



    // proposal ID => block number

    mapping(uint => uint) public resultsInBlock;



    /*

    * @param proposalId Number of this voting, according to 'votingCounterForContract'

    * @param by Address that created proposal

    * @param proposalText Text of the proposal

    * @param resultsInBlock Block to calculate results of voting.

    */

    event Proposal(

        uint indexed proposalID,

        address indexed by,

        string proposalText,

        uint indexed resultsInBlock

    );



    // to run function an address has to be registered as a shareholder and own at least one share

    modifier onlyShareholder() {

        require(

            shareholdersLedgerByEthAddress[msg.sender].shareholderID != 0 && balanceOf[msg.sender] > 0,

            "Only shareholder can do that"

        );

        _;

    }



    /*

    * @notice Creates proposal for voting.

    * @param _proposalText Text of the proposal.

    * @param _resultsInBlock Number of block on which results will be counted.

    */

    function createVoting(

        string calldata _proposalText,

        uint _resultsInBlock

    ) onlyShareholder external returns (bool success){



        require(

            _resultsInBlock > block.number,

            "Block for results should be later than current block"

        );



        votingCounterForContract++;



        proposalText[votingCounterForContract] = _proposalText;

        resultsInBlock[votingCounterForContract] = _resultsInBlock;



        emit Proposal(votingCounterForContract, msg.sender, proposalText[votingCounterForContract], resultsInBlock[votingCounterForContract]);



        return true;

    }



    // Vote 'for' received

    event VoteFor(

        uint indexed proposalID,

        address indexed by

    );



    // Vote 'against' received

    event VoteAgainst(

        uint indexed proposalID,

        address indexed by

    );



    /*

    * @notice Vote for the proposal

    * @param _proposalId Id (number) of the proposal

    */

    function voteFor(uint256 _proposalId) onlyShareholder external returns (bool success){



        require(

            resultsInBlock[_proposalId] > block.number,

            "Voting already finished"

        );



        require(

            !boolVotedFor[_proposalId][msg.sender] && !boolVotedAgainst[_proposalId][msg.sender],

            "Already voted"

        );



        numberOfVotersFor[_proposalId] = numberOfVotersFor[_proposalId] + 1;



        uint voterId = numberOfVotersFor[_proposalId];



        votedFor[_proposalId][voterId] = msg.sender;



        boolVotedFor[_proposalId][msg.sender] = true;



        emit VoteFor(_proposalId, msg.sender);



        return true;

    }



    /*

    * @notice Vote against the proposal

    * @param _proposalId Id (number) of the proposal

    */

    function voteAgainst(uint256 _proposalId) onlyShareholder external returns (bool success){



        require(

            resultsInBlock[_proposalId] > block.number,

            "Voting finished"

        );



        require(

            !boolVotedFor[_proposalId][msg.sender] && !boolVotedAgainst[_proposalId][msg.sender],

            "Already voted"

        );



        numberOfVotersAgainst[_proposalId] = numberOfVotersAgainst[_proposalId] + 1;



        uint voterId = numberOfVotersAgainst[_proposalId];



        votedAgainst[_proposalId][voterId] = msg.sender;



        boolVotedAgainst[_proposalId][msg.sender] = true;



        emit VoteAgainst(_proposalId, msg.sender);



        return true;

    }



    /*

    * This contract can receive Ether from any address.

    * Received Ether will be distributed as dividends to shareholders.

    */



    function addEtherToContract() external payable {

        // gas: 21482

    }



    function() external payable {

        // gas: 21040

    }



    /* ============= Contract initialization

    * dev: initializes token: set initial values for erc20 variables

    *      assigns all tokens ('totalSupply') to one address ('tokenOwner')

    * @param _contractNumberInTheLedger Contract Id.

    * @param _description Description of the project of organization (short text or just a link)

    * @param _name Name of the token

    * @param _symbol Symbol of the token

    * @param _tokenOwner Address that will initially hold all created tokens

    * @param _dividendsPeriod Period in seconds between finish of the previous dividends round and start of the next.

    *        On test net can be small.

    * @param _xEurContractAddress Address of contract with xEUR tokens

    *        (can be different for test net, where we use mock up contract)

    * @param _cryptonomicaVerificationContractAddress Address of the Cryptonomica verification smart contract

    *        (can be different for test net, where we use mock up contract)

    * @param _disputeResolutionAgreement Text of the arbitration agreement.

    */

    function initToken(

        uint _contractNumberInTheLedger,

        string calldata _description,

        string calldata _name,

        string calldata _symbol,

        uint _dividendsPeriod,

        address _xEurContractAddress,

        address _cryptonomicaVerificationContractAddress,

        string calldata _disputeResolutionAgreement

    ) external returns (bool success) {



        require(

            msg.sender == creator,

            "Only creator can initialize token contract"

        );



        require(

            totalSupply == 0,

            "Contract already initialized"

        );



        contractNumberInTheLedger = _contractNumberInTheLedger;

        description = _description;

        name = _name;

        symbol = _symbol;

        xEuro = XEuro(_xEurContractAddress);

        cryptonomicaVerification = CryptonomicaVerification(_cryptonomicaVerificationContractAddress);

        disputeResolutionAgreement = _disputeResolutionAgreement;

        dividendsPeriod = _dividendsPeriod;



        return true;

    }



    /*

    * @dev initToken and issueTokens are separate functions because of

    * 'Stack too deep' exception from compiler

    * @param _tokenOwner Address that will get all new created tokens.

    * @param _totalSupply Amount of tokens to create.

    */

    function issueTokens(

        uint _totalSupply,

        address _tokenOwner

    ) external returns (bool success){



        require(

            msg.sender == creator,

            "Only creator can initialize token contract"

        );



        require(

            totalSupply == 0,

            "Contract already initialized"

        );



        require(

            _totalSupply > 0,

            "Number of tokens can not be zero"

        );





        totalSupply = _totalSupply;



        balanceOf[_tokenOwner] = totalSupply;



        emit Transfer(address(0), _tokenOwner, _totalSupply);



        return true;

    }



}



/* =================== FACTORY */



/*

* dev: Universal functions for smart contract management

*/

contract ManagedContract {



    /*

    * dev: smart contract that provides information about person that owns given Ethereum address/key

    */

    CryptonomicaVerification public cryptonomicaVerification;



    /*

    * ledger of admins

    */

    mapping(address => bool) isAdmin;



    modifier onlyAdmin() {

        require(isAdmin[msg.sender], "Only admin can do that");

        _;

    }



    /**

    * @param from Old address

    * @param to New address

    * @param by Who made a change

    */

    event CryptonomicaVerificationContractAddressChanged(address from, address to, address indexed by);



    /**

    * @param _newAddress address of new contract to be used to verify identity of new admins

    */

    function changeCryptonomicaVerificationContractAddress(address _newAddress) public onlyAdmin returns (bool success) {



        emit CryptonomicaVerificationContractAddressChanged(address(cryptonomicaVerification), _newAddress, msg.sender);



        cryptonomicaVerification = CryptonomicaVerification(_newAddress);



        return true;

    }



    /**

    * @param added New admin address

    * @param addedBy Who added new admin

    */

    event AdminAdded(

        address indexed added,

        address indexed addedBy

    );



    /**

    * @param _newAdmin Address of new admin

    */

    function addAdmin(address _newAdmin) public onlyAdmin returns (bool success){



        require(

            cryptonomicaVerification.keyCertificateValidUntil(_newAdmin) > now,

            "New admin has to be verified on Cryptonomica.net"

        );



        // revokedOn returns uint256 (unix time), it's 0 if verification is not revoked

        require(

            cryptonomicaVerification.revokedOn(_newAdmin) == 0,

            "Verification for this address was revoked, can not add"

        );



        isAdmin[_newAdmin] = true;



        emit AdminAdded(_newAdmin, msg.sender);



        return true;

    }



    /**

    * @param removed Removed admin address

    * @param removedBy Who removed admin

    */

    event AdminRemoved(

        address indexed removed,

        address indexed removedBy

    );



    /**

    * @param _oldAdmin Address to remove from admins

    */

    function removeAdmin(address _oldAdmin) external onlyAdmin returns (bool){



        require(msg.sender != _oldAdmin, "Admin can not remove himself");



        isAdmin[_oldAdmin] = false;



        emit AdminRemoved(_oldAdmin, msg.sender);



        return true;

    }



    /* --- financial management */



    /*

    * address to send Ether from this contract

    */

    address payable public withdrawalAddress;



    /*

    * withdrawal address can be fixed (protected from changes),

    */

    bool public withdrawalAddressFixed = false;



    /*

    * @param from Old address

    * @param to New address

    * @param changedBy Who made this change

    */

    event WithdrawalAddressChanged(

        address indexed from,

        address indexed to,

        address indexed changedBy

    );



    /*

    * @param _withdrawalAddress address to which funds from this contract will be sent

    */

    function setWithdrawalAddress(address payable _withdrawalAddress) public onlyAdmin returns (bool success) {



        require(

            !withdrawalAddressFixed,

            "Withdrawal address already fixed"

        );



        require(

            _withdrawalAddress != address(0),

            "Wrong address: 0x0"

        );



        require(

            _withdrawalAddress != address(this),

            "Wrong address: contract itself"

        );



        emit WithdrawalAddressChanged(withdrawalAddress, _withdrawalAddress, msg.sender);



        withdrawalAddress = _withdrawalAddress;



        return true;

    }



    /*

    * @param withdrawalAddressFixedAs Address for withdrawal

    * @param fixedBy Address who made this change (msg.sender)

    *

    * This event can be fired one time only

    */

    event WithdrawalAddressFixed(

        address indexed withdrawalAddressFixedAs,

        address indexed fixedBy

    );



    /**

    * @param _withdrawalAddress Address to which funds from this contract will be sent.

    *

    * @dev This function can be called one time only.

    */

    function fixWithdrawalAddress(address _withdrawalAddress) external onlyAdmin returns (bool success) {



        // prevents event if already fixed

        require(

            !withdrawalAddressFixed,

            "Can't change, address fixed"

        );



        // check, to prevent fixing wrong address

        require(

            withdrawalAddress == _withdrawalAddress,

            "Wrong address in argument"

        );



        withdrawalAddressFixed = true;



        emit WithdrawalAddressFixed(withdrawalAddress, msg.sender);



        return true;

    }



    /**

    * @param to Address to which ETH was sent.

    * @param sumInWei Sum sent (in wei)

    * @param by Address, that made withdrawal (msg.sender)

    * @param success Shows f withdrawal was successful.

    */

    event Withdrawal(

        address indexed to,

        uint sumInWei,

        address indexed by,

        bool indexed success

    );



    /**

    * @dev This function can be called by any user or contract.

    * Possible warning:

    check for reentrancy vulnerability http://solidity.readthedocs.io/en/develop/security-considerations.html#re-entrancy

    * Since we are making a withdrawal to our own contract/address only there is no possible attack using reentrancy vulnerability

    */

    function withdrawAllToWithdrawalAddress() external returns (bool success) {



        // http://solidity.readthedocs.io/en/develop/security-considerations.html#sending-and-receiving-ether

        // about <address>.send(uint256 amount) and <address>.transfer(uint256 amount)

        // see: http://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=transfer#address-related

        // https://ethereum.stackexchange.com/questions/19341/address-send-vs-address-transfer-best-practice-usage



        uint sum = address(this).balance;



        if (!withdrawalAddress.send(sum)) {// makes withdrawal and returns true (success) or false



            emit Withdrawal(withdrawalAddress, sum, msg.sender, false);



            return false;

        }



        emit Withdrawal(withdrawalAddress, sum, msg.sender, true);



        return true;

    }



}



/*

* This is a model contract where some paid service provided and there is a price

* (in main function we can check if msg.value >= price)

*/

contract ManagedContractWithPaidService is ManagedContract {



    /*

    * Price for creating a new smart contract with shares (in wei)

    */

    uint public price;



    /*

    * @param from The old price

    * @param to The new price

    * @param by Who changed the price

    */

    event PriceChanged(

        uint from,

        uint to,

        address indexed by

    );



    /*

    * @param _newPrice The new price for the service

    */

    function changePrice(uint _newPrice) public onlyAdmin returns (bool success){

        emit PriceChanged(price, _newPrice, msg.sender);

        price = _newPrice;

        return true;

    }



}



/*

* dev: Smart contract to deploy shares smart contracts and maintain a ledger of deployed contracts.

*/

contract CryptoSharesFactory is ManagedContractWithPaidService {



    /**

    * Arbitration clause (dispute resolution agreement) text

    * see: https://en.wikipedia.org/wiki/Arbitration_clause

    * https://en.wikipedia.org/wiki/Arbitration#Arbitration_agreement

    */

    string public disputeResolutionAgreement =

    "Any dispute, controversy or claim arising out of or relating to this smart contract, including transfer of shares/tokens managed by this smart contract or ownership of the shares/tokens, or any voting managed by this smart contract shall be settled by arbitration in accordance with the Cryptonomica Arbitration Rules (https://github.com/Cryptonomica/arbitration-rules) in the version in effect at the time of the filing of the claim. In the case of the Ethereum blockchain fork, the blockchain that has the highest hashrate is considered valid, and all the others are not considered a valid registry, in case of dispute, dispute should be resolved by arbitration court. All Ethereum test networks are not valid registries.";



    event DisputeResolutionAgreementTextChanged(

        string newText,

        address indexed changedBy

    );



    /*

    * @param _newText New text for arbitration agreement. This will be used for future shares contracts only and

    * will not change arbitration agreement text in already deployed shares contracts.

    */

    function changeDisputeResolutionAgreement(string calldata _newText) external onlyAdmin returns (bool success){



        disputeResolutionAgreement = _newText;



        emit DisputeResolutionAgreementTextChanged(_newText, msg.sender);



        return true;

    }



    /* Address of the smart contract with xEUR tokens (see: https://xeuro.online) */

    address public xEurContractAddress;



    /**

    * @param from Old address

    * @param to New address

    * @param by Who made a change

    */

    event XEuroContractAddressChanged(

        address indexed from,

        address indexed to,

        address indexed by

    );



    /**

    * @param _newAddress Address of new contract for xEUR to be used (for the case that this address changes)

    * This function makes change only for future shares contracts, and does not change shares contract already deployed.

    */

    function changeXEuroContractAddress(address _newAddress) public onlyAdmin returns (bool success) {



        emit XEuroContractAddressChanged(xEurContractAddress, _newAddress, msg.sender);



        xEurContractAddress = _newAddress;



        return true;

    }



    /* ---- Constructor ---- */



    constructor() public {



        isAdmin[msg.sender] = true;



        changePrice(0.2 ether);



        setWithdrawalAddress(msg.sender);



        // Ropsten: > mock up contract, verification always valid for any address

        changeCryptonomicaVerificationContractAddress(0xE48BC3dB5b512d4A3e3Cd388bE541Be7202285B5);

        // TODO: change in production to https://etherscan.io/address/0x846942953c3b2A898F10DF1e32763A823bf6b27f <<<<<<<

        // changeCryptonomicaVerificationContractAddress(0x846942953c3b2A898F10DF1e32763A823bf6b27f);



        // Ropsten: > mock up contract, allows to create tokens for every address

        changeXEuroContractAddress(0x9a2A6C32352d85c9fcC5ff0f91fCB9CE42c15030);

        // TODO: change in production to https://etherscan.io/address/0xe577e0B200d00eBdecbFc1cd3F7E8E04C70476BE <<<<<<<

        // changeXEuroContractAddress(0xe577e0B200d00eBdecbFc1cd3F7E8E04C70476BE)



    } // end of constructor()



    /* ---- Creating and managing CryptoShares smart contracts ---- */



    // counts deployed contracts

    uint public cryptoSharesContractsCounter;



    /*

    * This struct contains information about deployed contract;

    */

    struct CryptoSharesContract {

        uint contractId;

        address contractAddress;

        uint deployedOnUnixTime;

        string name; // the same as token name

        string symbol; // the same as token symbol

        uint totalSupply; // the same as token totalSupply

        uint dividendsPeriod; // period between dividends payout rounds, in seconds

    }



    event NewCryptoSharesContractCreated(

        uint indexed contractId,

        address indexed contractAddress,

        string name, // the same as token name

        string symbol, // the same as token symbol

        uint totalSupply, // the same as token totalSupply

        uint dividendsPeriod // period between dividends payout rounds, in seconds

    );



    mapping(uint => CryptoSharesContract) public cryptoSharesContractsLedger;



    /*

    * @dev This function creates new shares contracts.

    * @param _description Description of the project or organization (can be short text or link to web page)

    * @param _name Name of the token, as required by ERC20.

    * @param _symbol Symbol for the token, as required by ERC20.

    * @param _totalSupply Total supply, as required by ERC20.

    * @param _dividendsPeriodInSeconds Period between dividends payout rounds, in seconds.

    */

    function createCryptoSharesContract(

        string calldata _description,

        string calldata _name,

        string calldata _symbol,

        uint _totalSupply,

        uint _dividendsPeriodInSeconds

    ) external payable returns (bool success){



        require(

            msg.value >= price,

            "msg.value is less than price"

        );



        CryptoShares cryptoSharesContract = new CryptoShares();



        cryptoSharesContractsCounter++;



        cryptoSharesContract.initToken(

            cryptoSharesContractsCounter,

            _description,

            _name,

            _symbol,

            _dividendsPeriodInSeconds,

            xEurContractAddress,

            address(cryptonomicaVerification),

            disputeResolutionAgreement

        );



        cryptoSharesContract.issueTokens(

            _totalSupply,

            msg.sender

        );



        cryptoSharesContractsCounter;

        cryptoSharesContractsLedger[cryptoSharesContractsCounter].contractId = cryptoSharesContractsCounter;

        cryptoSharesContractsLedger[cryptoSharesContractsCounter].contractAddress = address(cryptoSharesContract);

        cryptoSharesContractsLedger[cryptoSharesContractsCounter].deployedOnUnixTime = now;

        cryptoSharesContractsLedger[cryptoSharesContractsCounter].name = cryptoSharesContract.name();

        cryptoSharesContractsLedger[cryptoSharesContractsCounter].symbol = cryptoSharesContract.symbol();

        cryptoSharesContractsLedger[cryptoSharesContractsCounter].totalSupply = cryptoSharesContract.totalSupply();

        cryptoSharesContractsLedger[cryptoSharesContractsCounter].dividendsPeriod = cryptoSharesContract.dividendsPeriod();



        emit NewCryptoSharesContractCreated(

            cryptoSharesContractsLedger[cryptoSharesContractsCounter].contractId,

            cryptoSharesContractsLedger[cryptoSharesContractsCounter].contractAddress,

            cryptoSharesContractsLedger[cryptoSharesContractsCounter].name,

            cryptoSharesContractsLedger[cryptoSharesContractsCounter].symbol,

            cryptoSharesContractsLedger[cryptoSharesContractsCounter].totalSupply,

            cryptoSharesContractsLedger[cryptoSharesContractsCounter].dividendsPeriod

        );



        return true;



    } // end of function createCryptoSharesContract



}

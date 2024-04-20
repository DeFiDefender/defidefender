// File: contracts/Config.sol



pragma experimental ABIEncoderV2;

pragma solidity ^0.6.0;





interface IACL {

    function accessible(address sender, address to, bytes4 sig)

        external

        view

        returns (bool);

}





contract Config {

    address public ACL;



    constructor(address _ACL) public {

        ACL = _ACL;

    }



    modifier auth {

        require(

            IACL(ACL).accessible(msg.sender, address(this), msg.sig),

            "access unauthorized"

        );

        _;

    }



    function setACL(address _ACL) external {

        require(msg.sender == ACL, "require ACL");

        ACL = _ACL;

    }



    uint256 public voteDuration;

    uint256 public depositDuration;

    uint256 public investDuration;

    uint256 public gracePeriod; //\u5bbd\u9650\u671f



    uint256 public ratingFeeRatio; //\u5212\u5206\u624b\u7eed\u8d39\u4e2d\u7684\u6295\u7968\u6536\u76ca\u5360\u6bd4



    struct DepositTokenArgument {

        uint256 discount; //\u6298\u6263    0.85 => 0.85 * 1e18

        uint256 liquidateLine; //\u6e05\u7b97\u7ebf  70% => 0.7 * 1e18

        uint256 depositMultiple; //\u8d28\u62bc\u500d\u6570

    }



    struct IssueTokenArgument {

        uint256 partialLiquidateAmount;

    }



    struct IssueAmount {

        uint256 maxIssueAmount; //\u5355\u7b14\u503a\u5238\u6700\u5927\u53d1\u884c\u6570\u91cf

        uint256 minIssueAmount; //\u5355\u7b14\u503a\u5238\u6700\u5c0f\u53d1\u884c\u6570\u91cf

    }



    //deposit token => issuetoken => amount;

    mapping(address => mapping(address => IssueAmount)) public issueAmounts;

    mapping(address => DepositTokenArgument) public depositTokenArguments;

    mapping(address => IssueTokenArgument) public issueTokenArguments;



    function setRatingFeeRatio(uint256 ratio) external auth {

        ratingFeeRatio = ratio;

    }



    function setVoteDuration(uint256 sec) external auth {

        voteDuration = sec;

    }



    function setDepositDuration(uint256 sec) external auth {

        depositDuration = sec;

    }



    function setInvestDuration(uint256 sec) external auth {

        investDuration = sec;

    }



    function setGrasePeriod(uint256 period) external auth {

        gracePeriod = period;

    }



    function setDiscount(address token, uint256 discount) external auth {

        depositTokenArguments[token].discount = discount;

    }



    function discount(address token) external view returns (uint256) {

        return depositTokenArguments[token].discount;

    }



    function setLiquidateLine(address token, uint256 line) external auth {

        depositTokenArguments[token].liquidateLine = line;

    }



    function liquidateLine(address token) external view returns (uint256) {

        return depositTokenArguments[token].liquidateLine;

    }



    function setDepositMultiple(address token, uint256 depositMultiple)

        external

        auth

    {

        depositTokenArguments[token].depositMultiple = depositMultiple;

    }



    function depositMultiple(address token) external view returns (uint256) {

        return depositTokenArguments[token].depositMultiple;

    }



    function setMaxIssueAmount(

        address depositToken,

        address issueToken,

        uint256 maxIssueAmount

    ) external auth {

        issueAmounts[depositToken][issueToken].maxIssueAmount = maxIssueAmount;

    }



    function maxIssueAmount(address depositToken, address issueToken)

        external

        view

        returns (uint256)

    {

        return issueAmounts[depositToken][issueToken].maxIssueAmount;

    }



    function setMinIssueAmount(

        address depositToken,

        address issueToken,

        uint256 minIssueAmount

    ) external auth {

        issueAmounts[depositToken][issueToken].minIssueAmount = minIssueAmount;

    }



    function minIssueAmount(address depositToken, address issueToken)

        external

        view

        returns (uint256)

    {

        return issueAmounts[depositToken][issueToken].minIssueAmount;

    }



    function setPartialLiquidateAmount(

        address token,

        uint256 _partialLiquidateAmount

    ) external auth {

        issueTokenArguments[token]

            .partialLiquidateAmount = _partialLiquidateAmount;

    }



    function partialLiquidateAmount(address token)

        external

        view

        returns (uint256)

    {

        return issueTokenArguments[token].partialLiquidateAmount;

    }



    uint256 public professionalRatingWeightRatio; // professional-Rating Weight Ratio;

    uint256 public communityRatingWeightRatio; // community-Rating Weight Ratio;



    function setProfessionalRatingWeightRatio(

        uint256 _professionalRatingWeightRatio

    ) external auth {

        professionalRatingWeightRatio = _professionalRatingWeightRatio;

    }



    function setCommunityRatingWeightRatio(uint256 _communityRatingWeightRatio)

        external

        auth

    {

        communityRatingWeightRatio = _communityRatingWeightRatio;

    }



    /** verify */



    //\u652f\u6301\u53d1\u503a\u7684\u4ee3\u5e01\u5217\u8868

    mapping(address => bool) public depositTokenCandidates;

    //\u652f\u6301\u878d\u8d44\u7684\u4ee3\u5e01\u5217\u8868

    mapping(address => bool) public issueTokenCandidates;

    //\u53d1\u884c\u8d39\u7528

    mapping(uint256 => bool) public issueFeeCandidates;

    //\u4e00\u671f\u7684\u5229\u7387

    mapping(uint256 => bool) public interestRateCandidates;

    //\u503a\u5238\u671f\u9650

    mapping(uint256 => bool) public maturityCandidates;

    //\u6700\u4f4e\u53d1\u884c\u6bd4\u7387

    mapping(uint256 => bool) public minIssueRatioCandidates;

    //\u53ef\u8bc4\u7ea7\u7684\u5730\u5740\u9009\u9879

    mapping(address => bool) public ratingCandidates;



    function setDepositTokenCandidates(address[] calldata tokens, bool enable)

        external

        auth

    {

        for (uint256 i = 0; i < tokens.length; ++i) {

            depositTokenCandidates[tokens[i]] = enable;

        }

    }



    function setIssueTokenCandidates(address[] calldata tokens, bool enable)

        external

        auth

    {

        for (uint256 i = 0; i < tokens.length; ++i) {

            issueTokenCandidates[tokens[i]] = enable;

        }

    }



    function setIssueFeeCandidates(uint256[] calldata issueFees, bool enable)

        external

        auth

    {

        for (uint256 i = 0; i < issueFees.length; ++i) {

            issueFeeCandidates[issueFees[i]] = enable;

        }

    }



    function setInterestRateCandidates(

        uint256[] calldata interestRates,

        bool enable

    ) external auth {

        for (uint256 i = 0; i < interestRates.length; ++i) {

            interestRateCandidates[interestRates[i]] = enable;

        }

    }



    function setMaturityCandidates(uint256[] calldata maturities, bool enable)

        external

        auth

    {

        for (uint256 i = 0; i < maturities.length; ++i) {

            maturityCandidates[maturities[i]] = enable;

        }

    }



    function setMinIssueRatioCandidates(

        uint256[] calldata minIssueRatios,

        bool enable

    ) external auth {

        for (uint256 i = 0; i < minIssueRatios.length; ++i) {

            minIssueRatioCandidates[minIssueRatios[i]] = enable;

        }

    }



    function setRatingCandidates(address[] calldata proposals, bool enable)

        external

        auth

    {

        for (uint256 i = 0; i < proposals.length; ++i) {

            ratingCandidates[proposals[i]] = enable;

        }

    }



    address public gov;



    function setGov(address _gov) external auth {

        gov = _gov;

    }



    uint256 public communityRatingLine;



    function setCommunityRatingLine(uint256 _communityRatingLine)

        external

        auth

    {

        communityRatingLine = _communityRatingLine;

    }

}

pragma solidity ^0.5.17;



contract CaerusPresale {



    uint public totalTokensSold;

    uint public totalEthSpent;

    uint public presalestarttime;

    address[] public keys;

    address payable CaerusDevAddress;

    mapping (address => uint256) public balances;

    mapping (address => bool) public userExists;

    mapping (address => bool) public whiteListed;

    mapping (address => uint) public ethSpent;

    uint public constant maxAmount = 2 ether;

    uint public constant maxTotalAmount = 260 ether;

    uint public constant tokensPerEth = 10000; 

    uint public constant totalSaleSupply = 2600000 * (10 ** 18);  

    uint public constant presalelength = 1 days;

    bool public whitelistOnly = true;

    bool public salefinished = false;



    address payable owner;



    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event PresaleFinished(bool isthesalefinished);

    event EnterPresale(address addressentered, uint256 tokenspurchased);

  

    modifier onlyOwner() {

        require(msg.sender == owner);

        _;

    }



    constructor() public {

        owner = msg.sender;

        presalestarttime = now;

        CaerusDevAddress = 0x3F1618D229fbbC74cf0363FF99A26Cc4209FeAC4;

        

        addToWhitelist(0x5b36D90f5e781B8dF676bDD3062406DCc96dD831);

        addToWhitelist(0x8b190f3b2b4c1700E437925deD6F89a2F2F3BedE);

        addToWhitelist(0x2b35c8f2240eFd13C5eB18b7396BD4081DB4Fca5);

        addToWhitelist(0x5895A0684F8Fcb52fDebb07fc332e90B123eC9E1);

        addToWhitelist(0x06C8940CFEc1e9596123a2b0fA965F9E3758422f);

        addToWhitelist(0xf193e98063dA4A8FC4bf2E7aeaAB27Eb2E343f84);

        addToWhitelist(0x781dC05Bb477A936865516F928DC12016c992177);

        addToWhitelist(0x2f442C704c3D4Bd081531175Ce05C2C88603ce09);

        addToWhitelist(0x3485F724F8f562a417c8405a70A430DFC0Ea6044);

        addToWhitelist(0x3b9A456806a107d4BF5905CBF820d3e7C7Ec3e07);

        addToWhitelist(0x387EAf27c966bB6dEE6A0E8bA45ba0854d01Ee32);

        addToWhitelist(0x8A7A8aA2209264Fa80252b7642d60124c8966917);

        addToWhitelist(0xFDeF5eB0534b8e8Cb604154c4d8392Ef9BEa725F);

        addToWhitelist(0xBfaae89Fa69014D9560cFfF4b4978e39387D560e);

        addToWhitelist(0x52BF55C77C402F90dF3Bc1d9E6a0faf262437ab1);

        addToWhitelist(0x85F89d592ff99B99437D23dE6098c120915347ca);

        addToWhitelist(0x2efFE7f0314d78cD31B84d12364d7ccCB3772d18);

        addToWhitelist(0x9b0726e95e72eB6f305b472828b88D2d2bDD41C7);

        addToWhitelist(0xc76bf7e1a02a7fe636F1698ba5F4e28e88E3Af3c);

        addToWhitelist(0x6ee8608D43BaF0fd94D361aC89983891a142d2c0);

        addToWhitelist(0x6e0652BfC522990360CD17B113F3c0029737e8A1);

        addToWhitelist(0xB76Df3341040d7eaab0Bbd9ca0eE6cC7969c5912);

        addToWhitelist(0x5204B8A5708644414b7bb6e7E680702cf728F04C);

        addToWhitelist(0x49Bf18Ec38f9638A51Af507Dd7E8Dbb1Beb146A5);

        addToWhitelist(0x3dF3766E64C2C85Ce1baa858d2A14F96916d5087);

        addToWhitelist(0x7b2c77e13a88081004D0474A29F03338b20F6259);

        addToWhitelist(0xb42cD7ca17420a2289765A5c05a5C272fa9a5a4A);

        addToWhitelist(0x0f87EB0a4D374F58DC085ca308899D0cb2AcbD9c);

        addToWhitelist(0xA227b92d583803Fb18d9375300589FdbDA9fE449);

        addToWhitelist(0x46B8FfC41F26cd896E033942cAF999b78d10c277);

        addToWhitelist(0x9Aa91482E4D774aeB685b0A87629217257e3ad65);

        addToWhitelist(0x192cc8D1Cb0bd061BCD562348182306FD9C7Aa62);

        addToWhitelist(0x23e274C8E8EDC4Acb1A6322f47bb3508026a40d1);

        addToWhitelist(0x1218223B44eA08540c811375F1A380e93D60a6d2);

        addToWhitelist(0x3B5Cad548289cFDc7EC9988d38AC7bf49f58960b);

        addToWhitelist(0xe7FD3324e1eE068b3DfcF3AAc2660E4613091f38);

        addToWhitelist(0xA89e728512Ad116f2F017e843663136C78DB3d6B);

        addToWhitelist(0x51C47Ff91C9FfCbbe3e7EBe3DcE9F317453A75e9);

        addToWhitelist(0x5b85988F0032ee818f911ec969Dd9c649CAa0a14);

        addToWhitelist(0x54a9596dDD92b3E811dAB7d091C797897E11CA35);

        addToWhitelist(0xAB2Ba676717C5ac6e2F4ED7f4d3764B863630b13);

        addToWhitelist(0x909EF6254652E8ED6F9F48DD1b0A73a1d9Dc23B9);

        addToWhitelist(0x5AaAEF91F93bE4dE932b8e7324aBBF9f26DAa706);

        addToWhitelist(0x61Bd5f94D26b0A6251A81573dE86389F8D6cD8c1);

        addToWhitelist(0xB39B9A5504Ae48ad2CcdCA3d852FC0BAF5BA984D);

        addToWhitelist(0x396318f99F636C83117ecf6a7670999581877025);

        addToWhitelist(0x93f5af632Ce523286e033f0510E9b3C9710F4489);

        addToWhitelist(0x402961810cF383732C986dBE378B8c4def2B8166);

        addToWhitelist(0x0Bf99c142118eB26e7Ef3c183845dF2283aC9b3b);

        addToWhitelist(0xC855B798beB2Be8496eCeBbd89A774F4A993f726);

        addToWhitelist(0xd03A083589edC2aCcf09593951dCf000475cc9f2);

        addToWhitelist(0x3283071ba455F98d474F2C2D926861f90a3f1E42);

        addToWhitelist(0xf8cd77CbbE5571Cd6Ab01Ac5BD04fDAaB78bB879);

        addToWhitelist(0x59d7b684bced2a28FedebFc09ce3A795F49a4620);

        addToWhitelist(0x589AC3E5891D6A20FAaDCdF07Ef91b6ab6095980);

        addToWhitelist(0x0E56c076f9da959E0809e38eb7591eE3F2d87e5b);

        addToWhitelist(0x393fC373cbf15494cab53e1733F4d0B72dc3CddF);

        addToWhitelist(0x6564Ee72011Cf7F9daC276C6FB06259021351b9b);

        addToWhitelist(0x1A28f004E30b1d27D6Fa3a02a345fAeF335FecA5);

        addToWhitelist(0x0c6d54839de473480Fe24eC82e4Da65267C6be46);

        addToWhitelist(0xA94b40c53432f0576E64873CE1CEAd1aae62Fc90);

        addToWhitelist(0x138EcD97Da1C9484263BfADDc1f3D6AE2a435bCb);

        addToWhitelist(0x33DD33F9b0635f98bb872aBa0115AB3CeDa39466);

        addToWhitelist(0xb7fc44237eE35D7b533037cbA2298E54c3d59276);

        addToWhitelist(0x8303c76A8174EB5B5C5C9c320cE92f625A85eac2);

        addToWhitelist(0x3B8C5c91b6351dF0d266D3fCdC53b5190C8777F1);

        addToWhitelist(0xbccea8a2e82cc2A0f89a4EE559c7d7e1de11eb8e);

        addToWhitelist(0xF30d34d55f9b523b09BC8CbbDB5314FFF2982891);

        addToWhitelist(0x31E985b4f7af6B479148d260309B7BcEcEF0fa7B);

        addToWhitelist(0xA5e4822cC617Ef573e6F545AAb074e1900B1A96B);

        addToWhitelist(0x346d7C121A5089ded561Fed4E7fABBBcffB6406C);

        addToWhitelist(0xa1B821816b8A707b13a2bd2204f19c04ba13dfff);

        addToWhitelist(0xE96E7353fE78AB94D1B43417E21ebC5af985F41A);

        addToWhitelist(0x9D7a76fD386eDEB3A871c3A096Ca875aDc1a55b7);

        addToWhitelist(0xAbf84b08F4e9d435abAf7c30F1A1552710828546);

        addToWhitelist(0xE93Bad1CeD0d19A91aA4de6D682ef3942E2FFc1f);

        addToWhitelist(0x3593e01b56a99cd43CB2a3a2c721711b42f988a5);

        addToWhitelist(0x3397E1170e6Ad043f38deaC87F0158Ae6BE12113);

        addToWhitelist(0x58104c6bA9d0ac1B5bd6eCaab37300e6B465a6AB);

        addToWhitelist(0x7400296cC1a56273f4b5c1ca0d35d4909f089bE7);

        addToWhitelist(0xedDC4dD5CD359D03C2f559736aEa20bE02d43C13);

        addToWhitelist(0xdBccD0A4B682158443b8088C261Fed04A51B216B);

        addToWhitelist(0xCd0037e8245EfBA365f708f253168BE0FA319025);

        addToWhitelist(0xbB9Fb6eca452c87e8Eb24d4F62739E0980cFAafC);

        addToWhitelist(0xcDf6DfDbb706a0fc2E5157Cd6F6660a956F01dc1);

        addToWhitelist(0xEbc3C19ae48978822d00eBb4B8532d2ec0E07598);

        addToWhitelist(0x99685f834B99b3c6F3e910c8454eC64101f02296);

        addToWhitelist(0x3606F92d2583352F219b19b1a0aa85C1d74eD73B);

        addToWhitelist(0x42457C4aAdE073ed01d195E782f3689517B5CEB9);

        addToWhitelist(0xfca6b749aaCbe5FF8bB7F8b99b22377527f5292C);

        addToWhitelist(0x614d9c7341767CEbA7990441481809F4798Fd9d6);

        addToWhitelist(0x7914254AD6b6c6dBcbDcC4c964Ecda52DCe588a7);

        addToWhitelist(0xE20F75642b97c11Af651A81AfCBBc6D7B4E32981);

        addToWhitelist(0xd82037BEa6CDdf7E15B3153b29FcDb4C41f8bEDc);

        addToWhitelist(0xc0E630576248f9F05f1b098449eC20206ba35EbA);

        addToWhitelist(0x7ce8CD580Cfae9f162BcbBFA80dcf3765f99Ca7f);

        addToWhitelist(0x25054f27C9972B341Aee6c0D373A652566075431);

        addToWhitelist(0x9222Dbb848e9f5656eea54aA60D24586a8F24e3a);

        addToWhitelist(0x221c91Dcd38fCb92DE9b02f51B46244BAEE14Af9);

        addToWhitelist(0x76fbd3F8d609343f6A6ea32A29d6696e2CEcCddb);

        addToWhitelist(0x639ebd0728a9baef842E3B243eE7f763c84CD051);

        addToWhitelist(0xa596A01acb9e36ae574495dCED3922377ABbBb74);

        addToWhitelist(0x1F41Fdc63Ee2032d0F37CB7F079baf5c3822F011);

        addToWhitelist(0x53392622CB41d805a2BbC7a6Fb73d57E9134a549);

        addToWhitelist(0x65e408D28142b5aDf17f4a26d0EDe86C42c5eD2f);

        addToWhitelist(0x18736713a5D4b67ad9Fdd6b644a753dcaf80424b);

        addToWhitelist(0x0659213124b2E572575B827E252701b7615872Af);

        addToWhitelist(0x87bED3489B1eA2581a9BC16FAB741327E118bdcf);

        addToWhitelist(0x628f792899B3b43BFfe357b54727c8F6A3F84495);

        addToWhitelist(0x98D5731f60565Aa1751A0FA6F8F6E6212a4018C4);

        addToWhitelist(0x1e5A689F9D4524Ff6f604cDA19c01FAa4cA664eA);

        addToWhitelist(0x70c9Bf8b0F6f4eA4d9160976c3bFb0360E3d74a4);

        addToWhitelist(0x54CF8930796e1e0c7366c6F04D1Ea6Ad6FA5B708);

        addToWhitelist(0x488874e8b9C7999a853b2b2f4c1Dd8b952B3c2dB);

        addToWhitelist(0x8C54FB5F4Bab68F1a212de1991B7b8A7f48Aa0Cc);

        addToWhitelist(0x375061fe6aA5303Eb8161e42A802f0a841C15e55);

        addToWhitelist(0x861313966Cf4F65Eee9A355936ab123C8A487c8E);

    }



    function () external payable {

        purchase();

    }



    function purchase() public payable {

        require(msg.value <= maxAmount, "Input is more ETH than allowed (either 1 or 2 ETH max per address)");

        require(ethSpent[msg.sender] + msg.value <= maxAmount, "Already input max amount of ETH");

        require(totalEthSpent <= maxTotalAmount, "Pre-Sale has reached total max amount of ETH input");

        require(!whitelistOnly || whiteListed[msg.sender], "Not a whitelisted address");



        uint _tokenAmount = msg.value * tokensPerEth;

                

        // Global data

        totalEthSpent += msg.value;

        totalTokensSold += _tokenAmount;



        // User data

        ethSpent[msg.sender] += msg.value;

        balances[msg.sender] += _tokenAmount;



        if (!userExists[msg.sender]) {

            userExists[msg.sender] = true;

            keys.push(msg.sender);

        }



        emit EnterPresale(msg.sender, _tokenAmount);

    }



    function addToWhitelist(address _addr) public onlyOwner {

        whiteListed[_addr] = true;

    }



    function bulkAddToWhitelist(address[] calldata _addrs) external onlyOwner {

        for (uint i=0; i < _addrs.length; i++) {

            addToWhitelist(_addrs[i]);

        }

    }



    function toggleWhitelist() external onlyOwner {

        whitelistOnly = !whitelistOnly;

    }



    function refund() public {

        require(balances[msg.sender] > 0, "User has no purchased balance");

        require(salefinished != true, "Sale has finished, tokens will be distributed shortly");



        uint _userBal = balances[msg.sender]; // Only refund purchased tokens

        uint _ethRefund = _userBal / tokensPerEth;



        // Global data

        totalEthSpent -= _ethRefund;

        totalTokensSold -= _userBal;



        // User data

        ethSpent[msg.sender] = 0;



        msg.sender.transfer(_ethRefund);



        emit Transfer(msg.sender, address(0), _userBal);

    }



    function balanceOf(address _addr) public view returns(uint) {

        return balances[_addr];

    }



    function getRemainingTokens() public view returns(uint) {

        return totalSaleSupply - totalTokensSold;

    }



    function getTotalPresaleBuyers() public view returns(uint) {

        return keys.length;

    }



    function finishpresale() public onlyOwner {

      //require(now >= presalestarttime + presalelength);

      salefinished = true;

      emit PresaleFinished(salefinished);

      

      CaerusDevAddress.transfer(address(this).balance);

    }

}

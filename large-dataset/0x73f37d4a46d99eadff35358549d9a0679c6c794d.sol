// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;



/** \u2588\u2588\u2588\u2588\u2588\u2588\u2588\u2588\u2588\u2588\u2588    \u2588\u2588\u2588   \u2588\u2588\u2588\u2588\u2588                \u2588\u2588\u2588\u2588\u2588     \u2588\u2588\u2588\u2588                    \u2588\u2588\u2588\u2588\u2588     */

/**\u2591\u2591\u2588\u2588\u2588\u2591\u2591\u2591\u2591\u2591\u2588\u2588\u2588  \u2591\u2591\u2591   \u2591\u2591\u2588\u2588\u2588                \u2591\u2591\u2588\u2588\u2588     \u2591\u2591\u2588\u2588\u2588                   \u2591\u2591\u2588\u2588\u2588      */

/** \u2591\u2588\u2588\u2588    \u2591\u2588\u2588\u2588  \u2588\u2588\u2588\u2588  \u2588\u2588\u2588\u2588\u2588\u2588\u2588    \u2588\u2588\u2588\u2588\u2588\u2588\u2588\u2588\u2588  \u2591\u2588\u2588\u2588\u2588\u2588\u2588\u2588  \u2591\u2588\u2588\u2588    \u2588\u2588\u2588\u2588\u2588\u2588    \u2588\u2588\u2588\u2588\u2588\u2588  \u2591\u2588\u2588\u2588 \u2588\u2588\u2588\u2588\u2588*/

/** \u2591\u2588\u2588\u2588\u2588\u2588\u2588\u2588\u2588\u2588\u2588  \u2591\u2591\u2588\u2588\u2588 \u2591\u2591\u2591\u2588\u2588\u2588\u2591    \u2591\u2588\u2591  \u2591\u2588\u2588\u2588   \u2591\u2588\u2588\u2588\u2591\u2591\u2588\u2588\u2588 \u2591\u2588\u2588\u2588   \u2588\u2588\u2588\u2591\u2591\u2588\u2588\u2588  \u2588\u2588\u2588\u2591\u2591\u2588\u2588\u2588 \u2591\u2588\u2588\u2588\u2591\u2591\u2588\u2588\u2588 */

/** \u2591\u2588\u2588\u2588\u2591\u2591\u2591\u2591\u2591\u2588\u2588\u2588  \u2591\u2588\u2588\u2588   \u2591\u2588\u2588\u2588         \u2588\u2588\u2588\u2591    \u2591\u2588\u2588\u2588 \u2591\u2588\u2588\u2588 \u2591\u2588\u2588\u2588  \u2591\u2588\u2588\u2588 \u2591\u2588\u2588\u2588 \u2591\u2588\u2588\u2588      \u2591\u2588\u2588\u2588\u2588\u2588\u2588\u2591  */

/** \u2591\u2588\u2588\u2588    \u2591\u2588\u2588\u2588  \u2591\u2588\u2588\u2588   \u2591\u2588\u2588\u2588 \u2588\u2588\u2588   \u2588\u2588\u2588\u2591   \u2588  \u2591\u2588\u2588\u2588 \u2591\u2588\u2588\u2588 \u2591\u2588\u2588\u2588  \u2591\u2588\u2588\u2588 \u2591\u2588\u2588\u2588 \u2591\u2588\u2588\u2588  \u2588\u2588\u2588 \u2591\u2588\u2588\u2588\u2591\u2591\u2588\u2588\u2588 */

/** \u2588\u2588\u2588\u2588\u2588\u2588\u2588\u2588\u2588\u2588\u2588   \u2588\u2588\u2588\u2588\u2588  \u2591\u2591\u2588\u2588\u2588\u2588\u2588   \u2588\u2588\u2588\u2588\u2588\u2588\u2588\u2588\u2588  \u2588\u2588\u2588\u2588\u2588\u2588\u2588\u2588  \u2588\u2588\u2588\u2588\u2588 \u2591\u2591\u2588\u2588\u2588\u2588\u2588\u2588  \u2591\u2591\u2588\u2588\u2588\u2588\u2588\u2588  \u2588\u2588\u2588\u2588 \u2588\u2588\u2588\u2588\u2588*/

/**\u2591\u2591\u2591\u2591\u2591\u2591\u2591\u2591\u2591\u2591\u2591   \u2591\u2591\u2591\u2591\u2591    \u2591\u2591\u2591\u2591\u2591   \u2591\u2591\u2591\u2591\u2591\u2591\u2591\u2591\u2591  \u2591\u2591\u2591\u2591\u2591\u2591\u2591\u2591  \u2591\u2591\u2591\u2591\u2591   \u2591\u2591\u2591\u2591\u2591\u2591    \u2591\u2591\u2591\u2591\u2591\u2591  \u2591\u2591\u2591\u2591 \u2591\u2591\u2591\u2591\u2591 */





contract Bitzblock {

    // only people with tokens

    modifier onlyBzbHolders() {

        require(myBzb() > 0) ;

        _;

    }

    modifier onlyAdministrator(){

        address bzbBuyerAddress = msg.sender;

        require(administrators[bzbBuyerAddress], "Work HARD");

        _;

    }





    /*==============================

    =            EVENTS            =

    ==============================*/

    event Approval(

        address indexed tokenOwner, 

        address indexed spender,

        uint tokens

    );

    event Transfer(

        address indexed from,

        address indexed to,

        uint256 tokens

    );

    event Withdraw(

        address indexed customerAddress,

        uint256 ethereumWithdrawn

    );

    event RewardWithdraw(

        address indexed customerAddress,

        uint256 tokens

    );

    event Buy(

        address indexed buyer,

        uint256 tokensBought

    );

    event Sell(

        address indexed seller,

        uint256 tokensSold

    );

    event Stake(

        address indexed staker,

        uint256 tokenStaked

    );

    event Unstake(

        address indexed staker,

        uint256 tokenRestored

    );

    /*=====================================

    =            CONFIGURABLES            =

    =====================================*/

    string public  name = "Bitzblock Protocol";

    string public symbol = "BZB";

    uint8 public decimals = 3;

    uint256 public bzbSupply = 2100000000;

    uint256 constant internal initialBzbPrice = 320000000000;

    uint256 constant internal incrementFactor = 320;

    uint256 internal buyPercent = 1000; //comes multiplied by 1000 from outside

    uint256 internal sellPercent = 2000;

    uint256 internal referralPercent = 20200;

    uint256 internal _transferFees = 25;

    uint256 public currentPrice_ = initialBzbPrice;

    uint256 public grv = 1;



    // Make sure to visit our website https://bitzblock.com before you buy any tokens



    address commissionHolder; // holds commissions fees 

    address stakeHolder; // holds stake

    address payable devAddress; // Growth funds

    mapping(address => uint256) internal tokenBalanceLedger_;

    mapping(address => mapping (address => uint256)) allowed;

    uint256[8] internal slabPercentage = [2000,2000,2000,2000,2000,2000,2000,2000];

    address payable bzbMainAddress;

    uint256 public circulatingBzb = 0;

    // uint256 internal profitPerShare_;

    mapping(address => bool) internal administrators;

    mapping(address => bool) internal moderators;

    uint256 commFunds=0;

    bool mutex = false;

    

    constructor()

    {

        bzbMainAddress = msg.sender;

        administrators[bzbMainAddress] = true; 

        commissionHolder = bzbMainAddress;

        stakeHolder = bzbMainAddress;

        commFunds = 0;

    }

    

    /**********************************************************************/

    /**************************UPGRADABLES*********************************/

    /**********************************************************************/

    

    function upgradeContract(address[] memory _users, uint256[] memory _balances)

    onlyAdministrator()

    public

    {

        for(uint i = 0; i<_users.length;i++)

        {

            tokenBalanceLedger_[_users[i]] += _balances[i];

            circulatingBzb += _balances[i];

            emit Transfer(address(this),_users[i], _balances[i]);

        }

    }

    

    function setPreSaleBalances(address  user, uint256 balance)

    onlyAdministrator()

    public

    {

        tokenBalanceLedger_[user] += balance;

        circulatingBzb += balance;

        emit Transfer(address(this),user, balance);



    }

   function isAdministrator(address _address) onlyAdministrator() public view returns (bool) {

       return administrators[_address];

   }

    

    

    receive() external payable

    {

    }

    

    function upgradeDetails(uint256 _currentPrice, uint256 _grv, uint256 _commFunds)

    onlyAdministrator()

    public

    {

        currentPrice_ = _currentPrice;

        grv = _grv;

        commFunds = _commFunds;

    }

    

    function setupHolders(address _commissionHolder, uint mode_)

    onlyAdministrator()

    public

    {

        if(mode_ == 1)

        {

            commissionHolder = _commissionHolder;

        }

        if(mode_ == 2)

        {

            stakeHolder = _commissionHolder;

        }

    }

    

    function withdrawStake(uint256[] memory _amount, address[] memory bzbBuyerAddress)

        onlyAdministrator()

        public 

    {

        for(uint i = 0; i<bzbBuyerAddress.length; i++)

        {

            uint256 _toAdd = _amount[i];

            tokenBalanceLedger_[bzbBuyerAddress[i]] = SafeMath.add(tokenBalanceLedger_[bzbBuyerAddress[i]],_toAdd);

            tokenBalanceLedger_[stakeHolder] = SafeMath.sub(tokenBalanceLedger_[stakeHolder], _toAdd);

            emit Unstake(bzbBuyerAddress[i], _toAdd);

            emit Transfer(address(this),bzbBuyerAddress[i],_toAdd);

        }

    }

    

    /**********************************************************************/

    /*************************BUY/SELL/STAKE*******************************/

    /**********************************************************************/

    

    function buy()

        public

        payable

    {

        purchaseTokens(msg.value);

    }

    

    fallback() payable external

    {

        purchaseTokens(msg.value);

    }

    

    function holdStake(uint256 _amount) 

    onlyBzbHolders()

    public

    {

        require(!isContract(msg.sender),"Stake from contract is not allowed");

        tokenBalanceLedger_[msg.sender] = SafeMath.sub(tokenBalanceLedger_[msg.sender], _amount);

        tokenBalanceLedger_[stakeHolder] = SafeMath.add(tokenBalanceLedger_[stakeHolder], _amount);

        emit Transfer(msg.sender,address(this),_amount);

        emit Stake(msg.sender, _amount);

    }

        

    function unstake(uint256 _amount, address bzbBuyerAddress)

    onlyAdministrator()

    public

    {

        tokenBalanceLedger_[bzbBuyerAddress] = SafeMath.add(tokenBalanceLedger_[bzbBuyerAddress],_amount);

        tokenBalanceLedger_[stakeHolder] = SafeMath.sub(tokenBalanceLedger_[stakeHolder], _amount);

        emit Transfer(address(this),bzbBuyerAddress,_amount);

        emit Unstake(bzbBuyerAddress, _amount);

    }

    

    function withdrawRewards(uint256 _amount, address bzbBuyerAddress)

        onlyAdministrator()

        public 

    {

        tokenBalanceLedger_[bzbBuyerAddress] = SafeMath.add(tokenBalanceLedger_[bzbBuyerAddress],_amount);

        circulatingBzb = SafeMath.add (circulatingBzb,_amount);

    }

    

    function withdrawComm(uint256[] memory _amount, address[] memory bzbBuyerAddress)

        onlyAdministrator()

        public 

    {

        for(uint i = 0; i<bzbBuyerAddress.length; i++)

        {

            uint256 _toAdd = _amount[i];

            tokenBalanceLedger_[bzbBuyerAddress[i]] = SafeMath.add(tokenBalanceLedger_[bzbBuyerAddress[i]],_toAdd);

            tokenBalanceLedger_[commissionHolder] = SafeMath.sub(tokenBalanceLedger_[commissionHolder], _toAdd);

            emit RewardWithdraw(bzbBuyerAddress[i], _toAdd);

            emit Transfer(address(this),bzbBuyerAddress[i],_toAdd);

        }

    }

    

    function withdrawEthers(uint256 _amount)

    public

    onlyAdministrator()

    {

        require(!isContract(msg.sender),"Withdraw from contract is not allowed");

        devAddress.transfer(_amount);

        commFunds = SafeMath.sub(commFunds,_amount);

        emit Transfer(devAddress,address(this),calculateTokensReceived(_amount));

    }

    

    function upgradePercentages(uint256 percent_, uint modeType) onlyAdministrator() public

    {

        require(percent_ >= 300,"Percentage Too Low");

        if(modeType == 1)

        {

            buyPercent = percent_;

        }

        if(modeType == 2)

        {

            sellPercent = percent_;

        }

        if(modeType == 3)

        {

            referralPercent = percent_;

        }

        if(modeType == 4)

        {

            _transferFees = percent_;

        }

    }



    /**

     * Liquifies tokens to ethereum.

     */

     

    function setAdministrator(address _address) public onlyAdministrator(){

        administrators[_address] = true;

    }

    

    function sell(uint256 _amountOfTokens)

        onlyBzbHolders()

        public

    {

        require(!isContract(msg.sender),"Selling from contract is not allowed");

        // setup data

        address payable bzbBuyerAddress = msg.sender;

        require(_amountOfTokens <= tokenBalanceLedger_[bzbBuyerAddress]);

        uint256 _tokens = _amountOfTokens;

        uint256 _ethereum = tokensToEthereum_(_tokens);

        uint256 sellPercent_ = getSlabPercentage(_tokens);

        uint256 _dividends = (_ethereum * sellPercent_)/100000;

        uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);

        commFunds += _dividends;

        circulatingBzb = SafeMath.sub(circulatingBzb, _tokens);

        tokenBalanceLedger_[bzbBuyerAddress] = SafeMath.sub(tokenBalanceLedger_[bzbBuyerAddress], _tokens);

        bzbBuyerAddress.transfer(_taxedEthereum);

        emit Transfer(bzbBuyerAddress, address(this), _tokens);

    }

    

    function registerDev(address payable _devAddress)

    onlyAdministrator()

    public

    {

        devAddress = _devAddress;

    }

    

    function approve(address delegate, uint numTokens) public returns (bool) {

      allowed[msg.sender][delegate] = numTokens;

      emit Approval(msg.sender, delegate, numTokens);

      return true;

    }

    

    function allowance(address owner, address delegate) public view returns (uint) {

      return allowed[owner][delegate];

    }

   

    function transferFrom(address owner, address buyer, uint numTokens) public returns (bool) {

      require(numTokens <= tokenBalanceLedger_[owner]);

      require(numTokens <= allowed[owner][msg.sender]);

      tokenBalanceLedger_[owner] = SafeMath.sub(tokenBalanceLedger_[owner],numTokens);

      allowed[owner][msg.sender] =SafeMath.sub(allowed[owner][msg.sender],numTokens);

      uint toSend = SafeMath.sub(numTokens,_transferFees);

      tokenBalanceLedger_[buyer] = tokenBalanceLedger_[buyer] + toSend;

  

      emit Transfer(owner, buyer, numTokens);

      return true;

    }

    

    function totalCommFunds() 

        onlyAdministrator()

        public view

        returns(uint256)

    {

        return commFunds;    

    }



    function totalSupply() public view returns(uint256)

    {

        return SafeMath.sub(bzbSupply,tokenBalanceLedger_[address(0x000000000000000000000000000000000000dEaD)]);

    }

    

    function getCommFunds(uint256 _amount)

        onlyAdministrator()

        public 

    {

        if(_amount <= commFunds)

        {

            commFunds = SafeMath.sub(commFunds,_amount);

            emit Transfer(address(this),devAddress,calculateTokensReceived(_amount));

        }

    }

    

    function transfer(address _toAddress, uint256 _amountOfTokens) onlyBzbHolders()

        public

        returns(bool)

    {

        address bzbBuyerAddress = msg.sender;

        uint256 toSend_ = SafeMath.sub(_amountOfTokens, _transferFees);

        tokenBalanceLedger_[bzbBuyerAddress] = SafeMath.sub(tokenBalanceLedger_[bzbBuyerAddress], _amountOfTokens);

        tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], toSend_);

        emit Transfer(bzbBuyerAddress, _toAddress, _amountOfTokens);

    

        return true;

    }

    

    function destruct() onlyAdministrator() public{

        selfdestruct(bzbMainAddress);

    }

    



    function totalEthereumBalance()

        public

        view

        returns(uint)

    {

        return address(this).balance;

    }

    

    function myBzb() public view returns(uint256)

    {

        return (tokenBalanceLedger_[msg.sender]);

    }

    

    /**

     * Retrieve the token balance of any single address.

     */

    function balanceOf(address bzbBuyerAddress)

        view

        public

        returns(uint256)

    {

        return tokenBalanceLedger_[bzbBuyerAddress];

    }

    

    function sellPrice() 

        public 

        view 

        returns(uint256)

    {

        // our calculation relies on the token supply, so we need supply. Doh.

        if(circulatingBzb == 0){

            return initialBzbPrice - incrementFactor;

        } else {

            uint256 _ethereum = getTokensToEthereum_(1);

            uint256 _dividends = (_ethereum * sellPercent)/100000;

            uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);

            return _taxedEthereum;

        }

    }

    

    function getSlabPercentage() public view onlyAdministrator() returns(uint256[8] memory)

    {

        return(slabPercentage);

    }

    

    function getBuyPercentage() public view onlyAdministrator() returns(uint256)

    {

        return(buyPercent);

    }

    

    function getSellPercentage() public view onlyAdministrator() returns(uint256)

    {

        return(sellPercent);

    }

    

    function buyPrice() 

        public 

        view 

        returns(uint256)

    {

        return currentPrice_;

    }

    

    

    function calculateEthereumReceived(uint256 _tokensToSell) 

        public 

        view 

        returns(uint256)

    {

        require(_tokensToSell <= circulatingBzb);

        uint256 _ethereum = getTokensToEthereum_(_tokensToSell);

        uint256 _dividends = (_ethereum * sellPercent) /100000;//SafeMath.div(_ethereum, dividendFee_);

        uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);

        return _taxedEthereum;

    }

    

    

    /*==========================================

    =            INTERNAL FUNCTIONS            =

    ==========================================*/

    function isContract(address account) public view returns (bool) {

        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts

        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned

        // for accounts without code, i.e. `keccak256('')`

        bytes32 codehash;

        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;

        // solhint-disable-next-line no-inline-assembly

        assembly { codehash := extcodehash(account) }

        return (codehash != accountHash && codehash != 0x0);

    }

    

    event testLog(

        uint256 currBal

    );



    function calculateTokensReceived(uint256 _ethereumToSpend) 

        public 

        view 

        returns(uint256)

    {

        uint256 _dividends = (_ethereumToSpend * buyPercent)/100000;

        uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);

        uint256 _amountOfTokens = getEthereumToTokens_(_taxedEthereum, currentPrice_, grv);

        _amountOfTokens = SafeMath.sub(_amountOfTokens, (_amountOfTokens * referralPercent) / 100000);

        return _amountOfTokens;

    }

    

  

    

    function purchaseTokens(uint256 _incomingEthereum)

        internal

        returns(uint256)

    {

        // data setup

        address bzbBuyerAddress = msg.sender;

        uint256 _dividends = (_incomingEthereum * buyPercent)/100000;

        commFunds += _dividends;

        uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _dividends);

        uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum , currentPrice_, grv);

        tokenBalanceLedger_[commissionHolder] += (_amountOfTokens * referralPercent)/100000;

        require(_amountOfTokens > 0 , "Can not buy 0 Tokens");

        require(SafeMath.add(_amountOfTokens,circulatingBzb) > circulatingBzb,"Can not buy more than Total Supply");

        circulatingBzb = SafeMath.add(circulatingBzb, _amountOfTokens);

        require(SafeMath.add(_amountOfTokens,circulatingBzb) < bzbSupply);

        //deduct commissions for referrals

        _amountOfTokens = SafeMath.sub(_amountOfTokens, (_amountOfTokens * referralPercent)/100000);

        tokenBalanceLedger_[bzbBuyerAddress] = SafeMath.add(tokenBalanceLedger_[bzbBuyerAddress], _amountOfTokens);

        // fire event

        emit Transfer(address(this), bzbBuyerAddress, _amountOfTokens);

        return _amountOfTokens;

    }

   

    function changeSlabPercentage(uint slab_, uint256 percentage_) onlyAdministrator() public{

        slabPercentage[slab_] = percentage_;

    }

    function getSlabPercentage(uint256 tokens_) internal view returns(uint256){

        tokens_ = (tokens_ / 1000);

        if(tokens_ >=50 && tokens_ <100)

        {

            return slabPercentage[0];

        }

        if(tokens_ >=100 && tokens_ <300)

        {

            return slabPercentage[1];

        }

        if(tokens_ >=300 && tokens_ < 500)

        {

            return slabPercentage[2];

        }

        if(tokens_ >= 500 && tokens_ < 1000)

        {

            return slabPercentage[3];

        }

        if(tokens_ >= 1000 && tokens_ < 2500)

        {

            return slabPercentage[4];

        }

        if(tokens_ >= 2500 && tokens_ < 5000)

        {

            return slabPercentage[5];

        }

        if(tokens_ >= 5000 && tokens_ < 10000)

        {

            return slabPercentage[6];

        }

        if(tokens_ >= 10000)

        {

            return slabPercentage[7];

        }

        return sellPercent;

    }

   

    function getEthereumToTokens_(uint256 _ethereum, uint256 _currentPrice, uint256 _grv) internal view returns(uint256)

    {

        uint256 _tokenPriceIncremental = (incrementFactor*(2**(_grv-1)));

        uint256 _tempad = SafeMath.sub((2*_currentPrice), _tokenPriceIncremental);

        uint256 _tokenSupply = circulatingBzb;

        uint256 _totalTokens = 0;

        uint256 _tokensReceived = (

            (

                SafeMath.sub(

                    (sqrt

                        (

                            _tempad**2

                            + (8*_tokenPriceIncremental*_ethereum)

                        )

                    ), _tempad

                )

            )/(2*_tokenPriceIncremental)

        );

        uint256 tempbase = upperBound_(_grv);

        while((_tokensReceived + _tokenSupply) > tempbase){

            _tokensReceived = tempbase - _tokenSupply;

            _ethereum = SafeMath.sub(

                _ethereum,

                ((_tokensReceived)/2)*

                ((2*_currentPrice)+((_tokensReceived-1)

                *_tokenPriceIncremental))

            );

            _currentPrice = _currentPrice+((_tokensReceived-1)*_tokenPriceIncremental);

            _grv = _grv + 1;

            _tokenPriceIncremental = (incrementFactor*((2)**(_grv-1)));

            _tempad = SafeMath.sub((2*_currentPrice), _tokenPriceIncremental);

            uint256 _tempTokensReceived = (

                (

                    SafeMath.sub(

                        (sqrt

                            (

                                _tempad**2

                                + (8*_tokenPriceIncremental*_ethereum)

                            )

                        ), _tempad

                    )

                )/(2*_tokenPriceIncremental)

            );

            _tokenSupply = _tokenSupply + _tokensReceived;

            _totalTokens = _totalTokens + _tokensReceived;

            _tokensReceived = _tempTokensReceived;

            tempbase = upperBound_(_grv);

        }

        _totalTokens = _totalTokens + _tokensReceived;

        _currentPrice = _currentPrice+((_tokensReceived-1)*_tokenPriceIncremental);

        return _totalTokens;

    }

    

    function ethereumToTokens_(uint256 _ethereum, uint256 _currentPrice, uint256 _grv)

        internal

        returns(uint256)

    {

        uint256 _tokenPriceIncremental = (incrementFactor*(2**(_grv-1)));

        uint256 _tempad = SafeMath.sub((2*_currentPrice), _tokenPriceIncremental);

        uint256 _tokenSupply = circulatingBzb;

        uint256 _totalTokens = 0;

        uint256 _tokensReceived = (

            (

                SafeMath.sub(

                    (sqrt

                        (

                            _tempad**2

                            + (8*_tokenPriceIncremental*_ethereum)

                        )

                    ), _tempad

                )

            )/(2*_tokenPriceIncremental)

        );

        uint256 tempbase = upperBound_(_grv);

        while((_tokensReceived + _tokenSupply) > tempbase){

            _tokensReceived = tempbase - _tokenSupply;

            _ethereum = SafeMath.sub(

                _ethereum,

                ((_tokensReceived)/2)*

                ((2*_currentPrice)+((_tokensReceived-1)

                *_tokenPriceIncremental))

            );

            _currentPrice = _currentPrice+((_tokensReceived-1)*_tokenPriceIncremental);

            _grv = _grv + 1;

            _tokenPriceIncremental = (incrementFactor*((2)**(_grv-1)));

            _tempad = SafeMath.sub((2*_currentPrice), _tokenPriceIncremental);

            uint256 _tempTokensReceived = (

                (

                    SafeMath.sub(

                        (sqrt

                            (

                                _tempad**2

                                + (8*_tokenPriceIncremental*_ethereum)

                            )

                        ), _tempad

                    )

                )/(2*_tokenPriceIncremental)

            );

            _tokenSupply = _tokenSupply + _tokensReceived;

            _totalTokens = _totalTokens + _tokensReceived;

            _tokensReceived = _tempTokensReceived;

            tempbase = upperBound_(_grv);

        }

        _totalTokens = _totalTokens + _tokensReceived;

        _currentPrice = _currentPrice+((_tokensReceived-1)*_tokenPriceIncremental);

        currentPrice_ = _currentPrice;

        grv = _grv;

        return _totalTokens;

    }

    function getTokensToEthereum_(uint256 _tokens)

        internal

        view

        returns(uint256)

    {

        uint256 _tokenSupply = circulatingBzb;

        uint256 _etherReceived = 0;

        uint256 _grv = grv;

        uint256 tempbase = upperBound_(_grv-1);

        uint256 _currentPrice = currentPrice_;

        uint256 _tokenPriceIncremental = (incrementFactor*((2)**(_grv-1)));

        while((_tokenSupply - _tokens) < tempbase)

        {

            uint256 tokensToSell = _tokenSupply - tempbase;

            if(tokensToSell == 0)

            {

                _tokenSupply = _tokenSupply - 1;

                _grv -= 1;

                tempbase = upperBound_(_grv-1);

                continue;

            }

            uint256 b = ((tokensToSell-1)*_tokenPriceIncremental);

            uint256 a = _currentPrice - b;

            _tokens = _tokens - tokensToSell;

            _etherReceived = _etherReceived + ((tokensToSell/2)*((2*a)+b));

            _currentPrice = a;

            _tokenSupply = _tokenSupply - tokensToSell;

            _grv = _grv-1 ;

            _tokenPriceIncremental = (incrementFactor*((2)**(_grv-1)));

            tempbase = upperBound_(_grv-1);

        }

        if(_tokens > 0)

        {

             uint256 a = _currentPrice - ((_tokens-1)*_tokenPriceIncremental);

             _etherReceived = _etherReceived + ((_tokens/2)*((2*a)+((_tokens-1)*_tokenPriceIncremental)));

             _tokenSupply = _tokenSupply - _tokens;

             _currentPrice = a;

        }

        return _etherReceived;

    }

    

    function tokensToEthereum_(uint256 _tokens)

        internal

        returns(uint256)

    {

        uint256 _tokenSupply = circulatingBzb;

        uint256 _etherReceived = 0;

        uint256 _grv = grv;

        uint256 tempbase = upperBound_(_grv-1);

        uint256 _currentPrice = currentPrice_;

        uint256 _tokenPriceIncremental = (incrementFactor*((2)**(_grv-1)));

        while((_tokenSupply - _tokens) < tempbase)

        {

            uint256 tokensToSell = _tokenSupply - tempbase;

            if(tokensToSell == 0)

            {

                _tokenSupply = _tokenSupply - 1;

                _grv -= 1;

                tempbase = upperBound_(_grv-1);

                continue;

            }

            uint256 b = ((tokensToSell-1)*_tokenPriceIncremental);

            uint256 a = _currentPrice - b;

            _tokens = _tokens - tokensToSell;

            _etherReceived = _etherReceived + ((tokensToSell/2)*((2*a)+b));

            _currentPrice = a;

            _tokenSupply = _tokenSupply - tokensToSell;

            _grv = _grv-1 ;

            _tokenPriceIncremental = (incrementFactor*((2)**(_grv-1)));

            tempbase = upperBound_(_grv-1);

        }

        if(_tokens > 0)

        {

             uint256 a = _currentPrice - ((_tokens-1)*_tokenPriceIncremental);

             _etherReceived = _etherReceived + ((_tokens/2)*((2*a)+((_tokens-1)*_tokenPriceIncremental)));

             _tokenSupply = _tokenSupply - _tokens;

             _currentPrice = a;

        }

        grv = _grv;

        currentPrice_ = _currentPrice;

        return _etherReceived;

    }

    

    function upperBound_(uint256 _grv)

    internal

    pure

    returns(uint256)

    {

        if(_grv <= 5)

        {

            return (60000000 * _grv);

        }

        if(_grv > 5 && _grv <= 10)

        {

            return (300000000 + ((_grv-5)*50000000));

        }

        if(_grv > 10 && _grv <= 15)

        {

            return (550000000 + ((_grv-10)*40000000));

        }

        if(_grv > 15 && _grv <= 20)

        {

            return (750000000 +((_grv-15)*30000000));

        }

        return 0;

    }

    

    function sqrt(uint x) internal pure returns (uint y) {

        uint z = (x + 1) / 2;

        y = x;

        while (z < y) {

            y = z;

            z = (x / z + z) / 2;

        }

    }

}



library SafeMath {



    /**

    * @dev Multiplies two numbers, throws on overflow.

    */

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {

        if (a == 0) {

            return 0;

        }

        uint256 c = a * b;

        assert(c / a == b);

        return c;

    }



    /**

    * @dev Integer division of two numbers, truncating the quotient.

    */

    function div(uint256 a, uint256 b) internal pure returns (uint256) {

        // assert(b > 0); // Solidity automatically throws when dividing by 0

        uint256 c = a / b;

        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;

    }



    /**

    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).

    */

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {

        assert(b <= a);

        return a - b;

    }



    /**

    * @dev Adds two numbers, throws on overflow.

    */

    function add(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a + b;

        assert(c >= a);

        return c;

    }

}

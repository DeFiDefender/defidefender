pragma solidity ^0.4.20;



contract EtherWin {

    /*=================================

    =            MODIFIERS            =

    =================================*/

    // only people with tokens

    modifier onlyBagholders() {

        require(myTokens() > 0);

        _;

    }



    // only people with profits

    modifier onlyStronghands() {

        require(myDividends(true) > 0);

        _;

    }



    modifier checkExchangeOpen(){

        require(exchangeClosed == false);

        _;



    }



    /*==============================

    =            EVENTS            =

    ==============================*/

    event onTokenPurchase(

        address indexed customerAddress,

        uint256 incomingEthereum,

        uint256 tokensMinted,

        address indexed referredBy

    );



    event onTokenSell(

        address indexed customerAddress,

        uint256 tokensBurned,

        uint256 ethereumEarned

    );



    event onReinvestment(

        address indexed customerAddress,

        uint256 ethereumReinvested,

        uint256 tokensMinted

    );



    event onWithdraw(

        address indexed customerAddress,

        uint256 ethereumWithdrawn

    );



    // ERC20

    event Transfer(

        address indexed from,

        address indexed to,

        uint256 tokens

    );





    /*=====================================

    =            CONFIGURABLES            =

    =====================================*/

    string public name = "Win Token";

    string public symbol = "Win";



    uint8 constant public decimals = 18;

    uint8 constant internal buyFee_ = 6;//60%

    uint8 constant internal sellFee_ = 10;//10%

    uint8 constant internal transferFee_ = 10;

    uint8 constant internal roiRate_ = 10; //10%

    uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;

    uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;

    uint256 constant internal magnitude = 2**64;



    uint256 internal tokenSupply_ = 0;

    uint256 internal profitPerShare_;



    uint256 public stakingRequirement = 25e18;



   /*================================

    =            DATASETS            =

    ================================*/



    // amount of shares for each address (scaled number)

    mapping(address => uint256) internal tokenBalanceLedger_;

    mapping(address => uint256) internal referralBalance_;

    mapping(address => int256) internal payoutsTo_;





    uint256 public roiPool = 0;

    address internal devAddress_  = 0xA87EAEdFc338E3aA75767f51357f845337c8cFa1;

    bool public exchangeClosed = true;





    /*=======================================

    =            PUBLIC FUNCTIONS            =

    =======================================*/

    /*

    * -- APPLICATION ENTRY POINTS --

    */



    function sendRoi() public {

      require(msg.sender == devAddress_);



      uint256 dailyInterest = SafeMath.div(roiPool, roiRate_);  //10% roirate

      roiPool = SafeMath.sub(roiPool,dailyInterest);

      roiDistribution(dailyInterest, 0x0);

    }





    /**

     * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)

     */

    function buy(address _referredBy)

        public

        payable

        returns(uint256)

    {

        purchaseTokens(msg.value, _referredBy);

    }



    /**

     * Fallback function to handle ethereum that was send straight to the contract

     * Unfortunately we cannot use a referral address this way.

     */

    function()

        payable

        public

    {

        purchaseTokens(msg.value, 0x0);

    }



    /**

     * Converts all of caller's dividends to tokens.

     */

    function reinvest()

        onlyStronghands()

        public

    {

        // fetch dividends

        uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code



        // pay out the dividends virtually

        address _customerAddress = msg.sender;

        payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);



        // retrieve ref. bonus

        _dividends += referralBalance_[_customerAddress];

        referralBalance_[_customerAddress] = 0;



        // dispatch a buy order with the virtualized "withdrawn dividends"

        uint256 _tokens = purchaseTokens(_dividends, 0x0);



        // fire event

        onReinvestment(_customerAddress, _dividends, _tokens);

    }



    /**

     * Alias of sell() and withdraw().

     */

    function exit()

        public

    {

        // get token count for caller & sell them all

        address _customerAddress = msg.sender;

        uint256 _tokens = tokenBalanceLedger_[_customerAddress];

        if(_tokens > 0) sell(_tokens);



        // lambo delivery service

        withdraw();

    }



    /**

     * Withdraws all of the callers earnings.

     */

    function withdraw()

        onlyStronghands()

        public

    {

        // setup data

        address _customerAddress = msg.sender;

        uint256 _dividends = myDividends(false); // get ref. bonus later in the code



        // update dividend tracker

        payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);



        // add ref. bonus

        _dividends += referralBalance_[_customerAddress];

        referralBalance_[_customerAddress] = 0;



        _customerAddress.transfer(_dividends);



        // fire event

        onWithdraw(_customerAddress, _dividends);

    }



    /**

     * Liquifies tokens to ethereum.

     */

    function sell(uint256 _amountOfTokens)

        onlyBagholders()

        public

    {

        // setup data

        address _customerAddress = msg.sender;

        // russian hackers BTFO

        require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);

        uint256 _tokens = _amountOfTokens;

        uint256 _ethereum = tokensToEthereum_(_tokens);

        uint256 _dividends = SafeMath.div(_ethereum, sellFee_);//10%

        uint256 _roiPool = SafeMath.div(_dividends,2); //5%

                roiPool = SafeMath.add(roiPool,_roiPool);

        uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);

        _dividends =  SafeMath.sub(_dividends, _roiPool);

        // burn the sold tokens

        tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);

        tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);



        // update dividends tracker

        int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));

        payoutsTo_[_customerAddress] -= _updatedPayouts;

        // dividing by zero is a bad idea

        if (tokenSupply_ > 0) {

            // update the amount of dividends per token

            profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);

        }



        // fire event

        onTokenSell(_customerAddress, _tokens, _taxedEthereum);

    }





    /**

     * Transfer tokens from the caller to a new holder.

     * Remember, there's a 10% fee here as well.

     */

    function transfer(address _toAddress, uint256 _amountOfTokens)

        onlyBagholders()

        public

        returns(bool)

    {

        // setup

        address _customerAddress = msg.sender;



        require(!exchangeClosed && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);



        if(myDividends(true) > 0) withdraw();



        uint256 _tokenFee = SafeMath.div(_amountOfTokens, transferFee_);

        uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);

        uint256 _dividends = tokensToEthereum_(_tokenFee);

        // burn the fee tokens

        tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);



        // exchange tokens

        tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);

        tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);



        // update dividend trackers

        payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);

        payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);



        // disperse dividends among holders

        profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);



        // fire event

        Transfer(_customerAddress, _toAddress, _taxedTokens);



        // ERC20

        return true;



    }



    /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/



    function disableInitialStage()

        public

    {

        require(msg.sender == devAddress_);

        exchangeClosed = false;

    }



    function setStakingRequirement(uint256 _amountOfTokens)

        public

    {

        require(msg.sender == devAddress_);

        stakingRequirement = _amountOfTokens;

    }





    /*----------  HELPERS AND CALCULATORS  ----------*/

    /**

     * Method to view the current Ethereum stored in the contract

     * Example: totalEthereumBalance()

     */

    function totalEthereumBalance()

        public

        view

        returns(uint)

    {

        return this.balance;

    }



    function isOwner()

      public

      view

      returns(bool)

    {

      return msg.sender == devAddress_;

    }



    /**

     * Retrieve the total token supply.

     */

    function totalSupply()

        public

        view

        returns(uint256)

    {

        return tokenSupply_;

    }



    /**

     * Retrieve the tokens owned by the caller.

     */

    function myTokens()

        public

        view

        returns(uint256)

    {

        address _customerAddress = msg.sender;

        return balanceOf(_customerAddress);

    }



    /**

     * Retrieve the dividends owned by the caller.

     * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.

     * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)

     * But in the internal calculations, we want them separate.

     */

    function myDividends(bool _includeReferralBonus)

        public

        view

        returns(uint256)

    {

        address _customerAddress = msg.sender;

        return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;

    }



    /**

     * Retrieve the token balance of any single address.

     */

    function balanceOf(address _customerAddress)

        view

        public

        returns(uint256)

    {

        return tokenBalanceLedger_[_customerAddress];

    }



    /**

     * Retrieve the dividend balance of any single address.

     */

    function dividendsOf(address _customerAddress)

        view

        public

        returns(uint256)

    {

        return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;

    }



    /**

     * Return the buy price of 1 individual token.

     */

    function sellPrice()

        public

        view

        returns(uint256)

    {

        // our calculation relies on the token supply, so we need supply. Doh.

        if(tokenSupply_ == 0){

            return tokenPriceInitial_ - tokenPriceIncremental_;

        } else {

            uint256 _ethereum = tokensToEthereum_(1e18);

            uint256 _dividends = SafeMath.div(_ethereum, sellFee_);

            uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);

            return _taxedEthereum;

        }

    }

    /**

     * Return the sell price of 1 individual token.

     */

    function buyPrice()

        public

        view

        returns(uint256)

    {

        // our calculation relies on the token supply, so we need supply. Doh.

        if(tokenSupply_ == 0){

            return tokenPriceInitial_ + tokenPriceIncremental_;

        } else {

            uint256 _ethereum = tokensToEthereum_(1e18);

            uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, buyFee_), 10);

            uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);

            return _taxedEthereum;

        }

    }



    function roiDistribution(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {

      address _customerAddress = msg.sender;

      uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, buyFee_), 10); //33%

      uint256 _referralBonus = SafeMath.div(_undividedDividends, 2); //30%

      uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);

      uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);

      uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);

      uint256 _fee = _dividends * magnitude;



      require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));



      referralBalance_[devAddress_] = SafeMath.add(referralBalance_[devAddress_], _referralBonus);



      if(tokenSupply_ > 0){

          tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);

          profitPerShare_ += (_dividends * magnitude / (tokenSupply_));

          _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));



      } else {

          tokenSupply_ = _amountOfTokens;

      }



      tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);



      int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);

      payoutsTo_[_customerAddress] += _updatedPayouts;



      onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);



      return _amountOfTokens;

   }



    /**

     * Function for the frontend to dynamically retrieve the price scaling of buy orders.

     */

    function calculateTokensReceived(uint256 _ethereumToSpend)

        public

        view

        returns(uint256)

    {

        uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, buyFee_), 10);//60%

        uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);

        uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);



        return _amountOfTokens;

    }



    /**

     * Function for the frontend to dynamically retrieve the price scaling of sell orders.

     */

    function calculateEthereumReceived(uint256 _tokensToSell)

        public

        view

        returns(uint256)

    {

        require(_tokensToSell <= tokenSupply_);

        uint256 _ethereum = tokensToEthereum_(_tokensToSell);

        uint256 _dividends = SafeMath.div(_ethereum, sellFee_);

        uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);

        return _taxedEthereum;

    }



    /*==========================================

    =            INTERNAL FUNCTIONS            =

    ==========================================*/

    function purchaseTokens(uint256 _incomingEthereum, address _referredBy)

        checkExchangeOpen()

        internal

        returns(uint256)

    {

        // data setup

        address _customerAddress = msg.sender;

        uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, buyFee_), 10); //60%

        uint256 _referralBonus = SafeMath.div(_undividedDividends, 2); //30%

        uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);//30%

        uint256 _roiPool = SafeMath.div(_dividends,3); //10%

                roiPool = SafeMath.add(roiPool,_roiPool);

                _dividends =  SafeMath.sub(_dividends, _roiPool); //20%

        uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);

        uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);

        uint256 _fee = _dividends * magnitude;



        require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));



        if(

            _referredBy != 0x0000000000000000000000000000000000000000 &&

            _referredBy != _customerAddress &&

            tokenBalanceLedger_[_referredBy] >= stakingRequirement

        ){

            referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);

        } else {

            referralBalance_[devAddress_] = SafeMath.add(referralBalance_[devAddress_], _referralBonus);

        }



        if(tokenSupply_ > 0){

            tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);

            profitPerShare_ += (_dividends * magnitude / (tokenSupply_));

            _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));



        } else {

            tokenSupply_ = _amountOfTokens;

        }



        tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);



        int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);

        payoutsTo_[_customerAddress] += _updatedPayouts;



        // fire event

        onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);



        return _amountOfTokens;

    }



    /**

     * Calculate Token price based on an amount of incoming ethereum

     * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;

     * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.

     */

    function ethereumToTokens_(uint256 _ethereum)

        internal

        view

        returns(uint256)

    {

        uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;

        uint256 _tokensReceived =

         (

            (

                // underflow attempts BTFO

                SafeMath.sub(

                    (sqrt

                        (

                            (_tokenPriceInitial**2)

                            +

                            (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))

                            +

                            (((tokenPriceIncremental_)**2)*(tokenSupply_**2))

                            +

                            (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)

                        )

                    ), _tokenPriceInitial

                )

            )/(tokenPriceIncremental_)

        )-(tokenSupply_)

        ;



        return _tokensReceived;

    }



    /**

     * Calculate token sell value.

     * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;

     * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.

     */

     function tokensToEthereum_(uint256 _tokens)

        internal

        view

        returns(uint256)

    {



        uint256 tokens_ = (_tokens + 1e18);

        uint256 _tokenSupply = (tokenSupply_ + 1e18);

        uint256 _etherReceived =

        (

            // underflow attempts BTFO

            SafeMath.sub(

                (

                    (

                        (

                            tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))

                        )-tokenPriceIncremental_

                    )*(tokens_ - 1e18)

                ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2

            )

        /1e18);

        return _etherReceived;

    }





    //This is where all your gas goes, sorry

    //Not sorry, you probably only paid 1 gwei

    function sqrt(uint x) internal pure returns (uint y) {

        uint z = (x + 1) / 2;

        y = x;

        while (z < y) {

            y = z;

            z = (x / z + z) / 2;

        }

    }

}



/**

 * @title SafeMath

 * @dev Math operations with safety checks that throw on error

 */

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

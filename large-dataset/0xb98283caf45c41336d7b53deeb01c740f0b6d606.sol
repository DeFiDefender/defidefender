pragma solidity ^0.6.0;

 

/*

* =====================================================

*

*/

 

 

interface HexContract {

    function transfer(address recipient, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

}

 

contract Hourglass{

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

   

 

    // administrators can:

    // -> change the name of the contract

    // -> change the name of the token

    // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)

    // they CANNOT:

    // -> take funds

    // -> disable withdrawals

    // -> kill the contract

    // -> change the price of tokens

    modifier onlyAdministrator(){

        address _customerAddress = msg.sender;

        require(administrators[_customerAddress]);

        _;

    }

   

    /*==============================

    =            EVENTS            =

    ==============================*/

    event onTokenPurchase(

        address indexed customerAddress,

        uint256 incomingHex,

        uint256 tokensMinted,

        address indexed referredBy

    );

   

    event onTokenSell(

        address indexed customerAddress,

        uint256 tokensBurned,

        uint256 hexEarned

    );

   

    event onReinvestment(

        address indexed customerAddress,

        uint256 hexReinvested,

        uint256 tokensMinted

    );

   

    event onWithdraw(

        address indexed customerAddress,

        uint256 hexWithdrawn

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

    string public name = "f1";

    string public symbol = "f1t";

    uint8 constant public decimals = 8;

    uint8 constant internal dividendFee_ = 10;

    uint256 constant internal tokenPriceInitial_ = 1e6; // 1 hex

    uint256 constant internal tokenPriceIncremental_ = 1e5; // 1 hex

    uint256 constant internal magnitude = 2**64;

   

    uint256 constant internal HEX = 1e8;

   

    // proof of stake (defaults at 100 tokens)

    //110k

    uint256 public stakingRequirement = 110e12;

   

   

   

    uint256 constant internal sellLimit=10000*HEX;

    uint256 constant internal limitResetPeriod = 1 days;

   

   

    address constant public HEXTokenAddress = 0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39;

   

   

   /*================================

    =            DATASETS            =

    ================================*/

    // amount of shares for each address (scaled number)

    mapping(address => uint256) internal tokenBalanceLedger_;

    mapping(address => uint256) internal referralBalance_;

    mapping(address => int256) internal payoutsTo_;

   

    uint256 internal tokenSupply_ = 0;

    uint256 internal profitPerShare_;

    // sales limits

    mapping(address => uint256) internal soldInPeriod;

    mapping(address => uint256) internal periodStartTimestamp;

   

    // administrator list (see above on what they can do)

    mapping(address => bool) public administrators;

 

    /*=======================================

    =            PUBLIC FUNCTIONS            =

    =======================================*/

    /*

    * -- APPLICATION ENTRY POINTS --  

    */

    constructor()

        public

    {

        // add administrators here

        administrators[0xAA7A7C2DECB180f68F11E975e6D92B5Dc06083A6] = true;

        administrators[0x53e1eB6a53d9354d43155f76861C5a2AC80ef361] = true;

 

    }

   

     

    /**

     * Converts all incoming Hex to tokens for the caller, and passes down the referral addy (if any)

     */

    function buy(uint256 hexValue, address _referredBy)

        public

        returns(uint256)

    {

        HexContract(HEXTokenAddress).transferFrom(msg.sender, address(this), hexValue);

        purchaseTokens(hexValue, _referredBy);

    }

   

    /**

     * Fallback function to handle Hex that was send straight to the contract

     * Unfortunately we cannot use a referral address this way.

     */

    fallback () external {

 

        revert();

 

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

        uint256 _tokens = purchaseTokens(_dividends, address(0));

       

        // fire event

        emit onReinvestment(_customerAddress, _dividends, _tokens);

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

       

        // lambo delivery service

        HexContract(HEXTokenAddress).transfer(_customerAddress, _dividends);

       

        // fire event

        emit onWithdraw(_customerAddress, _dividends);

    }

   

    /**

     * Liquifies tokens to Hex.

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

        uint256 _hex = tokensToHex_(_tokens);

        uint256 _dividends = SafeMath.div(_hex, dividendFee_);

        uint256 _taxedHex = SafeMath.sub(_hex, _dividends);

       

        //update  sell Counters

       

        // player hasnt sold yet

       

        if(periodStartTimestamp[_customerAddress]==0){

            periodStartTimestamp[_customerAddress]=now;

        }

        else{

            // player has sold before , if a day of more has passed since it

            // reset the limit and open a new daily period

           

            if( periodStartTimestamp[_customerAddress]> (now+limitResetPeriod) ){

               

                soldInPeriod[_customerAddress]=0;

                periodStartTimestamp[_customerAddress]=now;

            }

        }

        // check limits

       

        uint256 playerSoldInPeriod=soldInPeriod[_customerAddress];

        require((playerSoldInPeriod+_tokens)<=sellLimit);

       

        // increase sold Counters

       

        soldInPeriod[_customerAddress]=playerSoldInPeriod+_tokens;

        // burn the sold tokens

        tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);

        tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);

       

        // update dividends tracker

        int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedHex * magnitude));

        payoutsTo_[_customerAddress] -= _updatedPayouts;      

       

        // dividing by zero is a bad idea

        if (tokenSupply_ > 0) {

            // update the amount of dividends per token

            profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);

        }

       

        // fire event

        emit onTokenSell(_customerAddress, _tokens, _taxedHex);

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

       

        // make sure we have the requested tokens

        // ( we dont want whale premines )

        require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);

       

        // withdraw all outstanding dividends first

        if(myDividends(true) > 0) withdraw();

       

        // liquify 10% of the tokens that are transfered

        // these are dispersed to shareholders

        uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);

        uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);

        uint256 _dividends = tokensToHex_(_tokenFee);

 

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

        emit Transfer(_customerAddress, _toAddress, _taxedTokens);

       

        // ERC20

        return true;

       

    }

   

    /**

     * Precautionary measures in case we need to adjust the masternode rate.

     */

    function setStakingRequirement(uint256 _amountOfTokens)

        onlyAdministrator()

        public

    {

        stakingRequirement = _amountOfTokens;

    }

   

    /**

     * If we want to rebrand, we can.

     */

    function setName(string memory _name)

        onlyAdministrator()

        public

    {

        name = _name;

    }

   

    /**

     * If we want to rebrand, we can.

     */

    function setSymbol(string memory _symbol)

        onlyAdministrator()

        public

    {

        symbol = _symbol;

    }

 

   

    /*----------  HELPERS AND CALCULATORS  ----------*/

    /**

     * Method to view the current Hex stored in the contract

     * Example: totalHexBalance()

     */

    function totalHexBalance()

        public

        view

        returns(uint)

    {

        return balanceOf(address(this));

    }

   

    /**

     * Retrieve the total token supply.

     */

    function totalSupply()

        public

        view

        returns(uint256 tokenSupply)

    {

        tokenSupply=tokenSupply_;

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

            uint256 _hex = tokensToHex_(1e8);

            uint256 _dividends = SafeMath.div(_hex, dividendFee_  );

            uint256 _taxedHex = SafeMath.sub(_hex, _dividends);

            return _taxedHex;

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

            uint256 _hex = tokensToHex_(1e8);

            uint256 _dividends = SafeMath.div(_hex, dividendFee_  );

            uint256 _taxedHex = SafeMath.add(_hex, _dividends);

            return _taxedHex;

        }

    }

   

    /**

     * Function for the frontend to dynamically retrieve the price scaling of buy orders.

     */

    function calculateTokensReceived(uint256 _hexToSpend)

        public

        view

        returns(uint256)

    {

        uint256 _dividends = SafeMath.div(_hexToSpend, dividendFee_);

        uint256 _taxedHex = SafeMath.sub(_hexToSpend, _dividends);

        uint256 _amountOfTokens = hexToTokens_(_taxedHex);

       

        return _amountOfTokens;

    }

   

    /**

     * Function for the frontend to dynamically retrieve the price scaling of sell orders.

     */

    function calculateHexReceived(uint256 _tokensToSell)

        public

        view

        returns(uint256)

    {

        require(_tokensToSell <= tokenSupply_);

        uint256 _hex = tokensToHex_(_tokensToSell);

        uint256 _dividends = SafeMath.div(_hex, dividendFee_);

        uint256 _taxedHex = SafeMath.sub(_hex, _dividends);

        return _taxedHex;

    }

   

   

    /*==========================================

    =            INTERNAL FUNCTIONS            =

    ==========================================*/

    function purchaseTokens(uint256 _incomingHex, address _referredBy)

        internal

        returns(uint256)

    {

        // data setup

        address _customerAddress = msg.sender;

        uint256 _undividedDividends = SafeMath.div(_incomingHex, dividendFee_);

        uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);

        uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);

        uint256 _taxedHex = SafeMath.sub(_incomingHex, _undividedDividends);

        uint256 _amountOfTokens = hexToTokens_(_taxedHex);

        uint256 _fee = _dividends * magnitude;

 

        // no point in continuing execution if OP is a poorfag russian hacker

        // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world

        // (or hackers)

        // and yes we know that the safemath function automatically rules out the "greater then" equasion.

        require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));

       

        // is the user referred by a masternode?

        if(

            // is this a referred purchase?

            _referredBy != 0x0000000000000000000000000000000000000000 &&

 

            // no cheating!

            _referredBy != _customerAddress &&

           

            // does the referrer have at least X whole tokens?

            // i.e is the referrer a godly chad masternode

            tokenBalanceLedger_[_referredBy] >= stakingRequirement

        ){

            // wealth redistribution

            referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);

        } else {

            // no ref purchase

            // add the referral bonus back to the global dividends cake

            _dividends = SafeMath.add(_dividends, _referralBonus);

            _fee = _dividends * magnitude;

        }

       

        // we can't give people infinite Hex

        if(tokenSupply_ > 0){

           

            // add tokens to the pool

            tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);

 

            // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder

            profitPerShare_ += (_dividends * magnitude / (tokenSupply_));

           

            // calculate the amount of tokens the customer receives over his purchase

            _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));

       

        } else {

            // add tokens to the pool

            tokenSupply_ = _amountOfTokens;

        }

       

        // update circulating supply & the ledger address for the customer

        tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);

       

        // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;

        //really i know you think you do but you don't

        int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);

        payoutsTo_[_customerAddress] += _updatedPayouts;

       

        // fire event

        emit onTokenPurchase(_customerAddress, _incomingHex, _amountOfTokens, _referredBy);

       

        return _amountOfTokens;

    }

 

    /**

     * Calculate Token price based on an amount of incoming Hex

     * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;

     * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.

     */

    function hexToTokens_(uint256 _hex)

        internal

        view

        returns(uint256)

    {

        uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e8;

        uint256 _tokensReceived =

         (

            (

                // underflow attempts BTFO

                SafeMath.sub(

                    (sqrt

                        (

                            (_tokenPriceInitial**2)

                            +

                            (2*(tokenPriceIncremental_ * 1e8)*(_hex * 1e8))

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

     function tokensToHex_(uint256 _tokens)

        internal

        view

        returns(uint256)

    {

 

        uint256 tokens_ = (_tokens + 1e8);

        uint256 _tokenSupply = (tokenSupply_ + 1e8);

        uint256 _hexReceived =

        (

            // underflow attempts BTFO

            SafeMath.sub(

                (

                    (

                        (

                            tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e8))

                        )-tokenPriceIncremental_

                    )*(tokens_ - 1e8)

                ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e8))/2

            )

        /1e8);

        return _hexReceived;

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

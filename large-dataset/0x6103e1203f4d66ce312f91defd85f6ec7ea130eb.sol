pragma solidity ^0.5.17;





contract IERC20

{

    function approve(address _spender, uint _amount) 

        public;

    function transferFrom(address _sender, address _receiver, uint _amount)

        public

        returns (bool);

}



contract BucketSale

{

    function tokenSoldFor()

        public

        returns (IERC20);



    function agreeToTermsAndConditionsListedInThisContractAndEnterSale(

        address _buyer,

        uint _bucketId,

        uint _amount,

        address _referrer)

    public;

}



contract EntryBot

{

    BucketSale bucketSale;



    constructor(BucketSale _bucketSale)

        public

    {

        bucketSale = _bucketSale;

        bucketSale.tokenSoldFor().approve(address(bucketSale), uint(-1));

    }



    function agreeToTermsAndConditionsListedInThisBucketSaleContractAndEnterSale(

            address _buyer,

            uint _bucketId,

            uint _amountPerBucket,

            uint _numberOfBuckets,

            address _referrer)

        public

    {

        bucketSale.tokenSoldFor().transferFrom(msg.sender, address(this), _amountPerBucket * _numberOfBuckets);



        for(uint i = 0; i <= _numberOfBuckets; i++)

        {

            bucketSale.agreeToTermsAndConditionsListedInThisContractAndEnterSale(

                _buyer,

                _bucketId + i,

                _amountPerBucket,

                _referrer

            );

        }

    }

}

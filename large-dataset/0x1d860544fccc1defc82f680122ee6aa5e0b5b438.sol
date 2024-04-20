// Price Oracle for Stabilize Protocol

// This contract uses Aave Price Oracle

// The main Operator contract can change which Price Oracle it uses

// Modified to accomodate proxy usage

// This version increases the gas efficiency of the oracle with proxy tokens



// Updated to use Chainlink upgrade



pragma solidity ^0.6.6;



/************

IPriceOracleGetter interface

Interface for the Aave price oracle.

*/

interface IPriceOracleGetter {

    function getAssetPrice(address _asset) external view returns (uint256);

    function getAssetsPrices(address[] calldata _assets) external view returns(uint256[] memory);

    function getSourceOfAsset(address _asset) external view returns(address);

    function getFallbackOracle() external view returns(address);

}



interface LendingPoolAddressesProvider {

    function getPriceOracle() external view returns (address);

}



interface AggregatorV3Interface {

  function latestRoundData() external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);

}



interface zaToken {

    // For the proxy tokens

    function underlyingAsset() external view returns (address);

}



contract StabilizePriceOracle {

    

    // Mapping of custom tokens

    mapping(address => bool) public zTokens;

    address public owner;

    

    constructor() public {

        owner = msg.sender;

        insertCustomTokens(); // zTokens have underlying asset

    }

    

    modifier onlyGovernance() {

        require(owner == msg.sender, "Ownable: caller is not the owner");

        _;

    }



    function insertCustomTokens() internal {

        // Mainnet zaToken

        zTokens[address(0x4dEaD8338cF5cb31122859b2Aec2b60416D491f0)] = true;

        zTokens[address(0x6B2e59b8EbE61B5ee0EF30021b7740C63F597654)] = true;

        zTokens[address(0xfa8c04d342FBe24d871ea77807b1b93eC42A57ea)] = true;

        zTokens[address(0x89Cc19cece29acbD41F931F3dD61A10C1627E4c4)] = true;

        zTokens[address(0x8e769EAA31375D13a1247dE1e64987c28Bed987E)] = true;

        zTokens[address(0x739D93f2b116E6aD754e173655c635Bd5D8d664c)] = true;

    }

    

    function addNewCustomToken(address _address) external onlyGovernance {

        zTokens[_address] = true;

    }

    

    function removeCustomToken(address _address) external onlyGovernance {

        zTokens[_address] = false;

    }

    

    function isZToken(address _address) internal view returns (bool) {

        return zTokens[_address];

    }

    

    function getPrice(address _address) public view returns (uint256) {

        // This version of the price oracle will use Aave contracts

        

        // First get the Ethereum USD price from Chainlink Aggregator

        // Mainnet address: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419

        // Kovan address: 0x9326BFA02ADD2366b30bacB125260Af641031331

        AggregatorV3Interface ethOracle = AggregatorV3Interface(address(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419));

        ( , int intEthPrice, , , ) = ethOracle.latestRoundData(); // We only want the answer 

        uint256 ethPrice = uint256(intEthPrice);

        

        address underlyingAsset = _address;

        if(isZToken(_address) == true){

            // zaTokens store their underlying asset address in the contract

            underlyingAsset = zaToken(_address).underlyingAsset();

        }

        

        // Retrieve PriceOracle address

        // Mainnet address: 0x24a42fD28C976A61Df5D00D0599C34c4f90748c8

        // Kovan address: 0x506B0B2CF20FAA8f38a4E2B524EE43e1f4458Cc5

        LendingPoolAddressesProvider provider = LendingPoolAddressesProvider(address(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8));

        address priceOracleAddress = provider.getPriceOracle();

        IPriceOracleGetter priceOracle = IPriceOracleGetter(priceOracleAddress);



        uint256 price = priceOracle.getAssetPrice(underlyingAsset); // This is relative to Ethereum, need to convert to USD

        ethPrice = ethPrice / 10000; // We only care about 4 decimal places from Chainlink priceOracleAddress

        price = price * ethPrice / 10000; // Convert to Wei format

        return price;

    }



}

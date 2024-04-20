pragma solidity 0.5.11;





interface DTokenInterface {

  function totalSupply() external view returns (uint256);

  function totalSupplyUnderlying() external view returns (uint256);

  function balanceOfUnderlying(address account) external view returns (uint256 underlyingBalance);

  function exchangeRateCurrent() external view returns (uint256 dTokenExchangeRate);

  function supplyRatePerBlock() external view returns (uint256 dTokenInterestRate);

  function accrualBlockNumber() external view returns (uint256 blockNumber);

  function getSurplus() external view returns (uint256 cTokenSurplus);

  function getSurplusUnderlying() external view returns (uint256 underlyingSurplus);

  function getSpreadPerBlock() external view returns (uint256 rateSpread);

  function getVersion() external pure returns (uint256 version);

}





contract DharmaUSDCSummarizer {

  DTokenInterface internal constant _DUSDC = DTokenInterface(

    0x00000000008943c65cAf789FFFCF953bE156f6f8

  );



  function summarize() external view returns (

    uint256 getVersion,

    uint256 totalSupply,

    uint256 totalSupplyUnderlying,

    uint256 exchangeRateCurrent,

    uint256 supplyRatePerBlock,

    uint256 accrualBlockNumber,

    uint256 getSpreadPerBlock,

    uint256 getSurplus,

    uint256 getSurplusUnderlying

  ) {

    getVersion = _DUSDC.getVersion(); 

    totalSupply = _DUSDC.totalSupply();

    totalSupplyUnderlying = _DUSDC.totalSupplyUnderlying();

    exchangeRateCurrent = _DUSDC.exchangeRateCurrent();

    supplyRatePerBlock = _DUSDC.supplyRatePerBlock();

    accrualBlockNumber = _DUSDC.accrualBlockNumber();

    getSpreadPerBlock = _DUSDC.getSpreadPerBlock();

    getSurplus = _DUSDC.getSurplus();

    getSurplusUnderlying = _DUSDC.getSurplusUnderlying();

  }

  

  function summarizeAsArray() external view returns (

    uint256[9] memory data

  ) {

    data[0] = _DUSDC.getVersion(); 

    data[1] = _DUSDC.totalSupply();

    data[2] = _DUSDC.totalSupplyUnderlying();

    data[3] = _DUSDC.exchangeRateCurrent();

    data[4] = _DUSDC.supplyRatePerBlock();

    data[5] = _DUSDC.accrualBlockNumber();

    data[6] = _DUSDC.getSpreadPerBlock();

    data[7] = _DUSDC.getSurplus();

    data[8] = _DUSDC.getSurplusUnderlying();

  }

}

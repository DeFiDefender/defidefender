/**

 *Submitted for verification at Etherscan.io on 2020-12-22

*/



// SPDX-License-Identifier: agpl-3.0

pragma solidity 0.6.12;



/**

 * @dev Interface of the ERC20 standard as defined in the EIP.

 * From https://github.com/OpenZeppelin/openzeppelin-contracts

 */

interface IERC20 {

  /**

   * @dev Returns the amount of tokens in existence.

   */

  function totalSupply() external view returns (uint256);



  /**

   * @dev Returns the amount of tokens owned by `account`.

   */

  function balanceOf(address account) external view returns (uint256);



  /**

   * @dev Moves `amount` tokens from the caller's account to `recipient`.

   *

   * Returns a boolean value indicating whether the operation succeeded.

   *

   * Emits a {Transfer} event.

   */

  function transfer(address recipient, uint256 amount) external returns (bool);



  /**

   * @dev Returns the remaining number of tokens that `spender` will be

   * allowed to spend on behalf of `owner` through {transferFrom}. This is

   * zero by default.

   *

   * This value changes when {approve} or {transferFrom} are called.

   */

  function allowance(address owner, address spender) external view returns (uint256);



  /**

   * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.

   *

   * Returns a boolean value indicating whether the operation succeeded.

   *

   * IMPORTANT: Beware that changing an allowance with this method brings the risk

   * that someone may use both the old and the new allowance by unfortunate

   * transaction ordering. One possible solution to mitigate this race

   * condition is to first reduce the spender's allowance to 0 and set the

   * desired value afterwards:

   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729

   *

   * Emits an {Approval} event.

   */

  function approve(address spender, uint256 amount) external returns (bool);



  /**

   * @dev Moves `amount` tokens from `sender` to `recipient` using the

   * allowance mechanism. `amount` is then deducted from the caller's

   * allowance.

   *

   * Returns a boolean value indicating whether the operation succeeded.

   *

   * Emits a {Transfer} event.

   */

  function transferFrom(

    address sender,

    address recipient,

    uint256 amount

  ) external returns (bool);



  /**

   * @dev Emitted when `value` tokens are moved from one account (`from`) to

   * another (`to`).

   *

   * Note that `value` may be zero.

   */

  event Transfer(address indexed from, address indexed to, uint256 value);



  /**

   * @dev Emitted when the allowance of a `spender` for an `owner` is set by

   * a call to {approve}. `value` is the new allowance.

   */

  event Approval(address indexed owner, address indexed spender, uint256 value);

}



interface ILendingPoolConfigurator {



  /**

   * @dev Initializes a reserve

   * @param aTokenImpl  The address of the aToken contract implementation

   * @param stableDebtTokenImpl The address of the stable debt token contract

   * @param variableDebtTokenImpl The address of the variable debt token contract

   * @param underlyingAssetDecimals The decimals of the reserve underlying asset

   * @param interestRateStrategyAddress The address of the interest rate strategy contract for this reserve

   **/

  function initReserve(

    address aTokenImpl,

    address stableDebtTokenImpl,

    address variableDebtTokenImpl,

    uint8 underlyingAssetDecimals,

    address interestRateStrategyAddress

  ) external;

  

   /**

   * @dev Configures the reserve collateralization parameters

   * all the values are expressed in percentages with two decimals of precision. A valid value is 10000, which means 100.00%

   * @param asset The address of the underlying asset of the reserve

   * @param ltv The loan to value of the asset when used as collateral

   * @param liquidationThreshold The threshold at which loans using this asset as collateral will be considered undercollateralized

   * @param liquidationBonus The bonus liquidators receive to liquidate this asset. The values is always above 100%. A value of 105%

   * means the liquidator will receive a 5% bonus

   **/

  function configureReserveAsCollateral(

    address asset,

    uint256 ltv,

    uint256 liquidationThreshold,

    uint256 liquidationBonus

  ) external;

  

    /**

   * @dev Enables borrowing on a reserve

   * @param asset The address of the underlying asset of the reserve

   * @param stableBorrowRateEnabled True if stable borrow rate needs to be enabled by default on this reserve

   **/

  function enableBorrowingOnReserve(address asset, bool stableBorrowRateEnabled)

    external;



}



interface IProposalExecutor {

    function execute() external;

}



/**

 * @title AssetsListingProposalPayload

 * @notice Proposal payload to be executed by the Aave Governance contract via DELEGATECALL

 * - Lists AAVE, UNI and GUSD in the protocol, each one with different configurations

 * @author Aave

 **/

contract AssetsListingProposalPayload is IProposalExecutor {

  event ProposalExecuted();



  ILendingPoolConfigurator public constant LENDING_POOL_CONFIGURATOR = ILendingPoolConfigurator(

    0x311Bb771e4F8952E6Da169b425E7e92d6Ac45756

  );



  address public constant GUSD_ERC20 = 0x056Fd409E1d7A124BD7017459dFEa2F387b6d5Cd;



  address public constant GUSD_ATOKEN = 0x57Dcb9799E4F49EeE4974296023c81fA96f49335;

  

  address public constant GUSD_STABLE_DEBT_TOKEN = 0xEddC66EB4a0aD3be434cBb1c2E7d17cE805D7a28;

  

  address public constant GUSD_VARIABLE_DEBT_TOKEN = 0xFd5994F6eBA013a31D9E55cA129d55f3cbF22690;



  address public constant GUSD_INTEREST_STRATEGY = 0x2893405d64a7Bc8Db02Fa617351a5399d59eCf8D;



  uint256 public constant GUSD_LTV = 0;



  uint256 public constant GUSD_LIQUIDATION_THRESHOLD = 0;



  uint256 public constant GUSD_LIQUIDATION_BONUS = 0;



  uint8 public constant GUSD_DECIMALS = 2;



  /**

   * @dev Payload execution function, called once a proposal passed in the Aave governance

   */

  function execute() external override {

    LENDING_POOL_CONFIGURATOR.initReserve(GUSD_ATOKEN, GUSD_STABLE_DEBT_TOKEN, GUSD_VARIABLE_DEBT_TOKEN, GUSD_DECIMALS, GUSD_INTEREST_STRATEGY);

    LENDING_POOL_CONFIGURATOR.enableBorrowingOnReserve(GUSD_ERC20, false);

    LENDING_POOL_CONFIGURATOR.configureReserveAsCollateral(

      GUSD_ERC20,

      GUSD_LTV,

      GUSD_LIQUIDATION_THRESHOLD,

      GUSD_LIQUIDATION_BONUS

    );



    emit ProposalExecuted();

  }

  

}

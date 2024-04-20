// File: contracts/ContractIds.sol



pragma solidity ^0.4.23;



contract ContractIds {

    bytes32 public constant STABLE_TOKEN = "StableToken";

    bytes32 public constant COLLATERAL_TOKEN = "CollateralToken";



    bytes32 public constant PEGUSD_TOKEN = "PEGUSD";



    bytes32 public constant VAULT_A = "VaultA";

    bytes32 public constant VAULT_B = "VaultB";



    bytes32 public constant PEG_LOGIC = "PegLogic";

    bytes32 public constant PEG_LOGIC_ACTIONS = "LogicActions";

    bytes32 public constant AUCTION_ACTIONS = "AuctionActions";



    bytes32 public constant PEG_SETTINGS = "PegSettings";

    bytes32 public constant ORACLE = "Oracle";

    bytes32 public constant FEE_RECIPIENT = "StabilityFeeRecipient";

}

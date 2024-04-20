//  This file is concatenated source code for the HashRegistry smart contract

// which was uploaded to Ethereum mainnet at the address

// 0xA59bF76922c92D213372e696A2326Ff1D6980417 on August 18, 2019.





pragma solidity ^0.5.0;





/**

 * @dev Contract module which provides a basic access control mechanism, where

 * there is an account (an owner) that can be granted exclusive access to

 * specific functions.

 *

 * This module is used through inheritance. It will make available the modifier

 * `onlyOwner`, which can be aplied to your functions to restrict their use to

 * the owner.

 */

contract Ownable {

    address private _owner;



    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);



    /**

     * @dev Initializes the contract setting the deployer as the initial owner.

     */

    constructor () internal {

        _owner = msg.sender;

        emit OwnershipTransferred(address(0), _owner);

    }



    /**

     * @dev Returns the address of the current owner.

     */

    function owner() public view returns (address) {

        return _owner;

    }



    /**

     * @dev Throws if called by any account other than the owner.

     */

    modifier onlyOwner() {

        require(isOwner(), "Ownable: caller is not the owner");

        _;

    }



    /**

     * @dev Returns true if the caller is the current owner.

     */

    function isOwner() public view returns (bool) {

        return msg.sender == _owner;

    }



    /**

     * @dev Leaves the contract without owner. It will not be possible to call

     * `onlyOwner` functions anymore. Can only be called by the current owner.

     *

     * > Note: Renouncing ownership will leave the contract without an owner,

     * thereby removing any functionality that is only available to the owner.

     */

    function renounceOwnership() public onlyOwner {

        emit OwnershipTransferred(_owner, address(0));

        _owner = address(0);

    }



    /**

     * @dev Transfers ownership of the contract to a new account (`newOwner`).

     * Can only be called by the current owner.

     */

    function transferOwnership(address newOwner) public onlyOwner {

        _transferOwnership(newOwner);

    }



    /**

     * @dev Transfers ownership of the contract to a new account (`newOwner`).

     */

    function _transferOwnership(address newOwner) internal {

        require(newOwner != address(0), "Ownable: new owner is the zero address");

        emit OwnershipTransferred(_owner, newOwner);

        _owner = newOwner;

    }

}











/**

 * @title Roles

 * @dev Library for managing addresses assigned to a Role.

 */

library Roles {

    struct Role {

        mapping (address => bool) bearer;

    }



    /**

     * @dev Give an account access to this role.

     */

    function add(Role storage role, address account) internal {

        require(!has(role, account), "Roles: account already has role");

        role.bearer[account] = true;

    }



    /**

     * @dev Remove an account's access to this role.

     */

    function remove(Role storage role, address account) internal {

        require(has(role, account), "Roles: account does not have role");

        role.bearer[account] = false;

    }



    /**

     * @dev Check if an account has this role.

     * @return bool

     */

    function has(Role storage role, address account) internal view returns (bool) {

        require(account != address(0), "Roles: account is the zero address");

        return role.bearer[account];

    }

}



/**

 * @title WhitelistAdminRole

 * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.

 */

contract WhitelistAdminRole {

    using Roles for Roles.Role;



    event WhitelistAdminAdded(address indexed account);

    event WhitelistAdminRemoved(address indexed account);



    Roles.Role private _whitelistAdmins;



    constructor () internal {

        _addWhitelistAdmin(msg.sender);

    }



    modifier onlyWhitelistAdmin() {

        require(isWhitelistAdmin(msg.sender), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");

        _;

    }



    function isWhitelistAdmin(address account) public view returns (bool) {

        return _whitelistAdmins.has(account);

    }



    function addWhitelistAdmin(address account) public onlyWhitelistAdmin {

        _addWhitelistAdmin(account);

    }



    function renounceWhitelistAdmin() public {

        _removeWhitelistAdmin(msg.sender);

    }



    function _addWhitelistAdmin(address account) internal {

        _whitelistAdmins.add(account);

        emit WhitelistAdminAdded(account);

    }



    function _removeWhitelistAdmin(address account) internal {

        _whitelistAdmins.remove(account);

        emit WhitelistAdminRemoved(account);

    }

}



/**

 * @title WhitelistedRole

 * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a

 * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove

 * it), and not Whitelisteds themselves.

 */

contract WhitelistedRole is WhitelistAdminRole {

    using Roles for Roles.Role;



    event WhitelistedAdded(address indexed account);

    event WhitelistedRemoved(address indexed account);



    Roles.Role private _whitelisteds;



    modifier onlyWhitelisted() {

        require(isWhitelisted(msg.sender), "WhitelistedRole: caller does not have the Whitelisted role");

        _;

    }



    function isWhitelisted(address account) public view returns (bool) {

        return _whitelisteds.has(account);

    }



    function addWhitelisted(address account) public onlyWhitelistAdmin {

        _addWhitelisted(account);

    }



    function removeWhitelisted(address account) public onlyWhitelistAdmin {

        _removeWhitelisted(account);

    }



    function renounceWhitelisted() public {

        _removeWhitelisted(msg.sender);

    }



    function _addWhitelisted(address account) internal {

        _whitelisteds.add(account);

        emit WhitelistedAdded(account);

    }



    function _removeWhitelisted(address account) internal {

        _whitelisteds.remove(account);

        emit WhitelistedRemoved(account);

    }

}









/**

 *  HashRegistry contract

 *      This Smart contract allows for the association of a hash with an Ethereum

 *  address.  

 *      Contract owner can update associations. 

 *      Emits a HashModified event when an association is added / changed.

 */

contract HashRegistry is Ownable, WhitelistedRole {



    event HashModified(uint256 hashData);



    uint256 _feeAdd = 0;

    uint256 _feeUpdate = 0;



    mapping (uint256 => address) private _hashValues;

    mapping (address => uint256) private _associations;



    struct HashMetadata {

        address owner;

        uint256 expiration;

        uint256 associatedHash;

        string notes;

    }



    mapping (uint256 => HashMetadata) private _hashData;





    /** 

     * 

     */

    function addHash(uint256 hashData) public payable {

        require(_hashData[hashData].owner == address(0), "Hash already exists");

        require(msg.value >= _feeAdd, 'Fee not sufficient');



        HashMetadata memory metadata = HashMetadata(msg.sender, 0, 0, "");

        _addHash(hashData, metadata);

    }



    /** 

     * 

     */

    function addHashWithMetadata(uint256 hashData, 

                                    uint256 expiration, 

                                    uint256 assocHash, 

                                    string memory notes) public payable {

        require(_hashData[hashData].owner == address(0), "Hash already exists");

        require(msg.value >= _feeAdd, 'Fee not sufficient');



        HashMetadata memory metadata = HashMetadata(msg.sender, expiration, assocHash, notes);

        _addHash(hashData, metadata);

    }



    /**

     * 

     */

    function updateHashMetadata(uint256 hashData,

                                uint256 expiration,

                                uint256 assocHash,

                                string memory notes) public payable {

        require(_hashData[hashData].owner == msg.sender, "Can only update owned hashes");

        require(_hashData[hashData].owner != address(0), "Hash must exist");

        require(msg.value >= _feeUpdate, 'Update Fee not sufficient');



        HashMetadata memory metadata = HashMetadata(msg.sender, expiration, assocHash, notes);

        _addHash(hashData, metadata);

    }



    /**

     * 

     */

    function updateHashMetadataWhitelisted(uint256 hashData,

                                        address hashOwner,

                                        uint256 expiration,

                                        uint256 assocHash,

                                        string memory notes) public onlyWhitelisted {

        require(hashOwner != address(0), "Hash must have an owner");



        HashMetadata memory metadata = HashMetadata(hashOwner, expiration, assocHash, notes);

        _addHash(hashData, metadata);

    }



    /**

     * @return true if the hash data specified has been registered

     */

    function isRegistered(uint256 hashData) public view returns (bool) {

        return _hashData[hashData].owner != address(0);

    }



    /**

     * @return the owning address of the hash

     */

    function getOwner(uint256 hashData) public view returns (address) {

        return _hashData[hashData].owner;

    }



    /**

     * @return the expiration date (block number) associated with the hash

     */

    function getExpiration(uint256 hashData) public view returns (uint256) {

        return _hashData[hashData].expiration;

    }



    /**

     * @return true if the hash is expired

     */

    function isExpired(uint256 hashData) public view returns (bool) {

        return ((_hashData[hashData].expiration != 0) && 

                (_hashData[hashData].expiration <= block.number));

    }



    /**

     * @return the associated (secondary) hash associated with the (primary) hash

     */

    function getAssociatedHash(uint256 hashData) public view returns (uint256) {

        return _hashData[hashData].associatedHash;

    }



    /**

     * @return the notes string associated withthe hash

     */

    function getNotes(uint256 hashData) public view returns (string memory) {

        return _hashData[hashData].notes;

    }





    /**

     *

     */

    function setFeeAdd(uint256 fee) public onlyOwner {

        _feeAdd = fee;

    }



    /**

     * @return fee (in wei) for performing anonymous interactions

     */

    function getFeeAdd() public view returns (uint256) {

        return _feeAdd;

    }



    /**

     * 

     */

    function setFeeUpdate(uint256 fee) public onlyOwner {

        _feeUpdate = fee;

    }



    /**

     * @return fee (in wei) for performing anonymous update interactions

     */

     function getFeeUpdate() public view returns (uint256) {

        return _feeUpdate;

     }





     /**

      *

      */

    function sweep() public onlyOwner {

        msg.sender.transfer(address(this).balance);

    }





    function _addHash(uint256 hashData, HashMetadata memory metadata) internal {

        _hashData[hashData] = metadata;

        emit HashModified(hashData);

    }





}

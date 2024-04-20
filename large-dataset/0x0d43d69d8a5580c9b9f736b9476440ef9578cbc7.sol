// File: contracts/provableAPI.sol



// <provableAPI>

/*





Copyright (c) 2015-2016 Oraclize SRL

Copyright (c) 2016-2019 Oraclize LTD

Copyright (c) 2019 Provable Things Limited



Permission is hereby granted, free of charge, to any person obtaining a copy

of this software and associated documentation files (the "Software"), to deal

in the Software without restriction, including without limitation the rights

to use, copy, modify, merge, publish, distribute, sublicense, and/or sell

copies of the Software, and to permit persons to whom the Software is

furnished to do so, subject to the following conditions:



The above copyright notice and this permission notice shall be included in

all copies or substantial portions of the Software.



THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR

IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,

FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE

AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER

LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,

OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN

THE SOFTWARE.



*/

pragma solidity >= 0.5.0 < 0.6.0; // Incompatible compiler version - please select a compiler within the stated pragma range, or use a different version of the provableAPI!



// Dummy contract only used to emit to end-user they are using wrong solc

contract solcChecker {

/* INCOMPATIBLE SOLC: import the following instead: "github.com/oraclize/ethereum-api/oraclizeAPI_0.4.sol" */ function f(bytes calldata x) external;

}



contract ProvableI {



    address public cbAddress;



    function setProofType(byte _proofType) external;

    function setCustomGasPrice(uint _gasPrice) external;

    function getPrice(string memory _datasource) public returns (uint _dsprice);

    function randomDS_getSessionPubKeyHash() external view returns (bytes32 _sessionKeyHash);

    function getPrice(string memory _datasource, uint _gasLimit) public returns (uint _dsprice);

    function queryN(uint _timestamp, string memory _datasource, bytes memory _argN) public payable returns (bytes32 _id);

    function query(uint _timestamp, string calldata _datasource, string calldata _arg) external payable returns (bytes32 _id);

    function query2(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) public payable returns (bytes32 _id);

    function query_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg, uint _gasLimit) external payable returns (bytes32 _id);

    function queryN_withGasLimit(uint _timestamp, string calldata _datasource, bytes calldata _argN, uint _gasLimit) external payable returns (bytes32 _id);

    function query2_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg1, string calldata _arg2, uint _gasLimit) external payable returns (bytes32 _id);

}



contract OracleAddrResolverI {

    function getAddress() public returns (address _address);

}

/*



Begin solidity-cborutils



https://github.com/smartcontractkit/solidity-cborutils



MIT License



Copyright (c) 2018 SmartContract ChainLink, Ltd.



Permission is hereby granted, free of charge, to any person obtaining a copy

of this software and associated documentation files (the "Software"), to deal

in the Software without restriction, including without limitation the rights

to use, copy, modify, merge, publish, distribute, sublicense, and/or sell

copies of the Software, and to permit persons to whom the Software is

furnished to do so, subject to the following conditions:



The above copyright notice and this permission notice shall be included in all

copies or substantial portions of the Software.



THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR

IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,

FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE

AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER

LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,

OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE

SOFTWARE.



*/

library Buffer {



    struct buffer {

        bytes buf;

        uint capacity;

    }



    function init(buffer memory _buf, uint _capacity) internal pure {

        uint capacity = _capacity;

        if (capacity % 32 != 0) {

            capacity += 32 - (capacity % 32);

        }

        _buf.capacity = capacity; // Allocate space for the buffer data

        assembly {

            let ptr := mload(0x40)

            mstore(_buf, ptr)

            mstore(ptr, 0)

            mstore(0x40, add(ptr, capacity))

        }

    }



    function resize(buffer memory _buf, uint _capacity) private pure {

        bytes memory oldbuf = _buf.buf;

        init(_buf, _capacity);

        append(_buf, oldbuf);

    }



    function max(uint _a, uint _b) private pure returns (uint _max) {

        if (_a > _b) {

            return _a;

        }

        return _b;

    }

    /**

      * @dev Appends a byte array to the end of the buffer. Resizes if doing so

      *      would exceed the capacity of the buffer.

      * @param _buf The buffer to append to.

      * @param _data The data to append.

      * @return The original buffer.

      *

      */

    function append(buffer memory _buf, bytes memory _data) internal pure returns (buffer memory _buffer) {

        if (_data.length + _buf.buf.length > _buf.capacity) {

            resize(_buf, max(_buf.capacity, _data.length) * 2);

        }

        uint dest;

        uint src;

        uint len = _data.length;

        assembly {

            let bufptr := mload(_buf) // Memory address of the buffer data

            let buflen := mload(bufptr) // Length of existing buffer data

            dest := add(add(bufptr, buflen), 32) // Start address = buffer address + buffer length + sizeof(buffer length)

            mstore(bufptr, add(buflen, mload(_data))) // Update buffer length

            src := add(_data, 32)

        }

        for(; len >= 32; len -= 32) { // Copy word-length chunks while possible

            assembly {

                mstore(dest, mload(src))

            }

            dest += 32;

            src += 32;

        }

        uint mask = 256 ** (32 - len) - 1; // Copy remaining bytes

        assembly {

            let srcpart := and(mload(src), not(mask))

            let destpart := and(mload(dest), mask)

            mstore(dest, or(destpart, srcpart))

        }

        return _buf;

    }

    /**

      *

      * @dev Appends a byte to the end of the buffer. Resizes if doing so would

      * exceed the capacity of the buffer.

      * @param _buf The buffer to append to.

      * @param _data The data to append.

      * @return The original buffer.

      *

      */

    function append(buffer memory _buf, uint8 _data) internal pure {

        if (_buf.buf.length + 1 > _buf.capacity) {

            resize(_buf, _buf.capacity * 2);

        }

        assembly {

            let bufptr := mload(_buf) // Memory address of the buffer data

            let buflen := mload(bufptr) // Length of existing buffer data

            let dest := add(add(bufptr, buflen), 32) // Address = buffer address + buffer length + sizeof(buffer length)

            mstore8(dest, _data)

            mstore(bufptr, add(buflen, 1)) // Update buffer length

        }

    }

    /**

      *

      * @dev Appends a byte to the end of the buffer. Resizes if doing so would

      * exceed the capacity of the buffer.

      * @param _buf The buffer to append to.

      * @param _data The data to append.

      * @return The original buffer.

      *

      */

    function appendInt(buffer memory _buf, uint _data, uint _len) internal pure returns (buffer memory _buffer) {

        if (_len + _buf.buf.length > _buf.capacity) {

            resize(_buf, max(_buf.capacity, _len) * 2);

        }

        uint mask = 256 ** _len - 1;

        assembly {

            let bufptr := mload(_buf) // Memory address of the buffer data

            let buflen := mload(bufptr) // Length of existing buffer data

            let dest := add(add(bufptr, buflen), _len) // Address = buffer address + buffer length + sizeof(buffer length) + len

            mstore(dest, or(and(mload(dest), not(mask)), _data))

            mstore(bufptr, add(buflen, _len)) // Update buffer length

        }

        return _buf;

    }

}



library CBOR {



    using Buffer for Buffer.buffer;



    uint8 private constant MAJOR_TYPE_INT = 0;

    uint8 private constant MAJOR_TYPE_MAP = 5;

    uint8 private constant MAJOR_TYPE_BYTES = 2;

    uint8 private constant MAJOR_TYPE_ARRAY = 4;

    uint8 private constant MAJOR_TYPE_STRING = 3;

    uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;

    uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;



    function encodeType(Buffer.buffer memory _buf, uint8 _major, uint _value) private pure {

        if (_value <= 23) {

            _buf.append(uint8((_major << 5) | _value));

        } else if (_value <= 0xFF) {

            _buf.append(uint8((_major << 5) | 24));

            _buf.appendInt(_value, 1);

        } else if (_value <= 0xFFFF) {

            _buf.append(uint8((_major << 5) | 25));

            _buf.appendInt(_value, 2);

        } else if (_value <= 0xFFFFFFFF) {

            _buf.append(uint8((_major << 5) | 26));

            _buf.appendInt(_value, 4);

        } else if (_value <= 0xFFFFFFFFFFFFFFFF) {

            _buf.append(uint8((_major << 5) | 27));

            _buf.appendInt(_value, 8);

        }

    }



    function encodeIndefiniteLengthType(Buffer.buffer memory _buf, uint8 _major) private pure {

        _buf.append(uint8((_major << 5) | 31));

    }



    function encodeUInt(Buffer.buffer memory _buf, uint _value) internal pure {

        encodeType(_buf, MAJOR_TYPE_INT, _value);

    }



    function encodeInt(Buffer.buffer memory _buf, int _value) internal pure {

        if (_value >= 0) {

            encodeType(_buf, MAJOR_TYPE_INT, uint(_value));

        } else {

            encodeType(_buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - _value));

        }

    }



    function encodeBytes(Buffer.buffer memory _buf, bytes memory _value) internal pure {

        encodeType(_buf, MAJOR_TYPE_BYTES, _value.length);

        _buf.append(_value);

    }



    function encodeString(Buffer.buffer memory _buf, string memory _value) internal pure {

        encodeType(_buf, MAJOR_TYPE_STRING, bytes(_value).length);

        _buf.append(bytes(_value));

    }



    function startArray(Buffer.buffer memory _buf) internal pure {

        encodeIndefiniteLengthType(_buf, MAJOR_TYPE_ARRAY);

    }



    function startMap(Buffer.buffer memory _buf) internal pure {

        encodeIndefiniteLengthType(_buf, MAJOR_TYPE_MAP);

    }



    function endSequence(Buffer.buffer memory _buf) internal pure {

        encodeIndefiniteLengthType(_buf, MAJOR_TYPE_CONTENT_FREE);

    }

}

/*



End solidity-cborutils



*/

contract usingProvable {



    using CBOR for Buffer.buffer;



    ProvableI provable;

    OracleAddrResolverI OAR;



    uint constant day = 60 * 60 * 24;

    uint constant week = 60 * 60 * 24 * 7;

    uint constant month = 60 * 60 * 24 * 30;



    byte constant proofType_NONE = 0x00;

    byte constant proofType_Ledger = 0x30;

    byte constant proofType_Native = 0xF0;

    byte constant proofStorage_IPFS = 0x01;

    byte constant proofType_Android = 0x40;

    byte constant proofType_TLSNotary = 0x10;



    string provable_network_name;

    uint8 constant networkID_auto = 0;

    uint8 constant networkID_morden = 2;

    uint8 constant networkID_mainnet = 1;

    uint8 constant networkID_testnet = 2;

    uint8 constant networkID_consensys = 161;



    mapping(bytes32 => bytes32) provable_randomDS_args;

    mapping(bytes32 => bool) provable_randomDS_sessionKeysHashVerified;



    modifier provableAPI {

        if ((address(OAR) == address(0)) || (getCodeSize(address(OAR)) == 0)) {

            provable_setNetwork(networkID_auto);

        }

        if (address(provable) != OAR.getAddress()) {

            provable = ProvableI(OAR.getAddress());

        }

        _;

    }



    modifier provable_randomDS_proofVerify(bytes32 _queryId, string memory _result, bytes memory _proof) {

        // RandomDS Proof Step 1: The prefix has to match 'LP\\x01' (Ledger Proof version 1)

        require((_proof[0] == "L") && (_proof[1] == "P") && (uint8(_proof[2]) == uint8(1)));

        bool proofVerified = provable_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), provable_getNetworkName());

        require(proofVerified);

        _;

    }



    function provable_setNetwork(uint8 _networkID) internal returns (bool _networkSet) {

      _networkID; // NOTE: Silence the warning and remain backwards compatible

      return provable_setNetwork();

    }



    function provable_setNetworkName(string memory _network_name) internal {

        provable_network_name = _network_name;

    }



    function provable_getNetworkName() internal view returns (string memory _networkName) {

        return provable_network_name;

    }



    function provable_setNetwork() internal returns (bool _networkSet) {

        if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) { //mainnet

            OAR = OracleAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);

            provable_setNetworkName("eth_mainnet");

            return true;

        }

        if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1) > 0) { //ropsten testnet

            OAR = OracleAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);

            provable_setNetworkName("eth_ropsten3");

            return true;

        }

        if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) { //kovan testnet

            OAR = OracleAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);

            provable_setNetworkName("eth_kovan");

            return true;

        }

        if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48) > 0) { //rinkeby testnet

            OAR = OracleAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);

            provable_setNetworkName("eth_rinkeby");

            return true;

        }

        if (getCodeSize(0xa2998EFD205FB9D4B4963aFb70778D6354ad3A41) > 0) { //goerli testnet

            OAR = OracleAddrResolverI(0xa2998EFD205FB9D4B4963aFb70778D6354ad3A41);

            provable_setNetworkName("eth_goerli");

            return true;

        }

        if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) { //ethereum-bridge

            OAR = OracleAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);

            return true;

        }

        if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) { //ether.camp ide

            OAR = OracleAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);

            return true;

        }

        if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) { //browser-solidity

            OAR = OracleAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);

            return true;

        }

        return false;

    }

    /**

     * @dev The following `__callback` functions are just placeholders ideally

     *      meant to be defined in child contract when proofs are used.

     *      The function bodies simply silence compiler warnings.

     */

    function __callback(bytes32 _myid, string memory _result) public {

        __callback(_myid, _result, new bytes(0));

    }



    function __callback(bytes32 _myid, string memory _result, bytes memory _proof) public {

      _myid; _result; _proof;

      provable_randomDS_args[bytes32(0)] = bytes32(0);

    }



    function provable_getPrice(string memory _datasource) provableAPI internal returns (uint _queryPrice) {

        return provable.getPrice(_datasource);

    }



    function provable_getPrice(string memory _datasource, uint _gasLimit) provableAPI internal returns (uint _queryPrice) {

        return provable.getPrice(_datasource, _gasLimit);

    }



    function provable_query(string memory _datasource, string memory _arg) provableAPI internal returns (bytes32 _id) {

        uint price = provable.getPrice(_datasource);

        if (price > 1 ether + tx.gasprice * 200000) {

            return 0; // Unexpectedly high price

        }

        return provable.query.value(price)(0, _datasource, _arg);

    }



    function provable_query(uint _timestamp, string memory _datasource, string memory _arg) provableAPI internal returns (bytes32 _id) {

        uint price = provable.getPrice(_datasource);

        if (price > 1 ether + tx.gasprice * 200000) {

            return 0; // Unexpectedly high price

        }

        return provable.query.value(price)(_timestamp, _datasource, _arg);

    }



    function provable_query(uint _timestamp, string memory _datasource, string memory _arg, uint _gasLimit) provableAPI internal returns (bytes32 _id) {

        uint price = provable.getPrice(_datasource,_gasLimit);

        if (price > 1 ether + tx.gasprice * _gasLimit) {

            return 0; // Unexpectedly high price

        }

        return provable.query_withGasLimit.value(price)(_timestamp, _datasource, _arg, _gasLimit);

    }



    function provable_query(string memory _datasource, string memory _arg, uint _gasLimit) provableAPI internal returns (bytes32 _id) {

        uint price = provable.getPrice(_datasource, _gasLimit);

        if (price > 1 ether + tx.gasprice * _gasLimit) {

           return 0; // Unexpectedly high price

        }

        return provable.query_withGasLimit.value(price)(0, _datasource, _arg, _gasLimit);

    }



    function provable_query(string memory _datasource, string memory _arg1, string memory _arg2) provableAPI internal returns (bytes32 _id) {

        uint price = provable.getPrice(_datasource);

        if (price > 1 ether + tx.gasprice * 200000) {

            return 0; // Unexpectedly high price

        }

        return provable.query2.value(price)(0, _datasource, _arg1, _arg2);

    }



    function provable_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) provableAPI internal returns (bytes32 _id) {

        uint price = provable.getPrice(_datasource);

        if (price > 1 ether + tx.gasprice * 200000) {

            return 0; // Unexpectedly high price

        }

        return provable.query2.value(price)(_timestamp, _datasource, _arg1, _arg2);

    }



    function provable_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) provableAPI internal returns (bytes32 _id) {

        uint price = provable.getPrice(_datasource, _gasLimit);

        if (price > 1 ether + tx.gasprice * _gasLimit) {

            return 0; // Unexpectedly high price

        }

        return provable.query2_withGasLimit.value(price)(_timestamp, _datasource, _arg1, _arg2, _gasLimit);

    }



    function provable_query(string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) provableAPI internal returns (bytes32 _id) {

        uint price = provable.getPrice(_datasource, _gasLimit);

        if (price > 1 ether + tx.gasprice * _gasLimit) {

            return 0; // Unexpectedly high price

        }

        return provable.query2_withGasLimit.value(price)(0, _datasource, _arg1, _arg2, _gasLimit);

    }



    function provable_query(string memory _datasource, string[] memory _argN) provableAPI internal returns (bytes32 _id) {

        uint price = provable.getPrice(_datasource);

        if (price > 1 ether + tx.gasprice * 200000) {

            return 0; // Unexpectedly high price

        }

        bytes memory args = stra2cbor(_argN);

        return provable.queryN.value(price)(0, _datasource, args);

    }



    function provable_query(uint _timestamp, string memory _datasource, string[] memory _argN) provableAPI internal returns (bytes32 _id) {

        uint price = provable.getPrice(_datasource);

        if (price > 1 ether + tx.gasprice * 200000) {

            return 0; // Unexpectedly high price

        }

        bytes memory args = stra2cbor(_argN);

        return provable.queryN.value(price)(_timestamp, _datasource, args);

    }



    function provable_query(uint _timestamp, string memory _datasource, string[] memory _argN, uint _gasLimit) provableAPI internal returns (bytes32 _id) {

        uint price = provable.getPrice(_datasource, _gasLimit);

        if (price > 1 ether + tx.gasprice * _gasLimit) {

            return 0; // Unexpectedly high price

        }

        bytes memory args = stra2cbor(_argN);

        return provable.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);

    }



    function provable_query(string memory _datasource, string[] memory _argN, uint _gasLimit) provableAPI internal returns (bytes32 _id) {

        uint price = provable.getPrice(_datasource, _gasLimit);

        if (price > 1 ether + tx.gasprice * _gasLimit) {

            return 0; // Unexpectedly high price

        }

        bytes memory args = stra2cbor(_argN);

        return provable.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);

    }



    function provable_query(string memory _datasource, string[1] memory _args) provableAPI internal returns (bytes32 _id) {

        string[] memory dynargs = new string[](1);

        dynargs[0] = _args[0];

        return provable_query(_datasource, dynargs);

    }



    function provable_query(uint _timestamp, string memory _datasource, string[1] memory _args) provableAPI internal returns (bytes32 _id) {

        string[] memory dynargs = new string[](1);

        dynargs[0] = _args[0];

        return provable_query(_timestamp, _datasource, dynargs);

    }



    function provable_query(uint _timestamp, string memory _datasource, string[1] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {

        string[] memory dynargs = new string[](1);

        dynargs[0] = _args[0];

        return provable_query(_timestamp, _datasource, dynargs, _gasLimit);

    }



    function provable_query(string memory _datasource, string[1] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {

        string[] memory dynargs = new string[](1);

        dynargs[0] = _args[0];

        return provable_query(_datasource, dynargs, _gasLimit);

    }



    function provable_query(string memory _datasource, string[2] memory _args) provableAPI internal returns (bytes32 _id) {

        string[] memory dynargs = new string[](2);

        dynargs[0] = _args[0];

        dynargs[1] = _args[1];

        return provable_query(_datasource, dynargs);

    }



    function provable_query(uint _timestamp, string memory _datasource, string[2] memory _args) provableAPI internal returns (bytes32 _id) {

        string[] memory dynargs = new string[](2);

        dynargs[0] = _args[0];

        dynargs[1] = _args[1];

        return provable_query(_timestamp, _datasource, dynargs);

    }



    function provable_query(uint _timestamp, string memory _datasource, string[2] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {

        string[] memory dynargs = new string[](2);

        dynargs[0] = _args[0];

        dynargs[1] = _args[1];

        return provable_query(_timestamp, _datasource, dynargs, _gasLimit);

    }



    function provable_query(string memory _datasource, string[2] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {

        string[] memory dynargs = new string[](2);

        dynargs[0] = _args[0];

        dynargs[1] = _args[1];

        return provable_query(_datasource, dynargs, _gasLimit);

    }



    function provable_query(string memory _datasource, string[3] memory _args) provableAPI internal returns (bytes32 _id) {

        string[] memory dynargs = new string[](3);

        dynargs[0] = _args[0];

        dynargs[1] = _args[1];

        dynargs[2] = _args[2];

        return provable_query(_datasource, dynargs);

    }



    function provable_query(uint _timestamp, string memory _datasource, string[3] memory _args) provableAPI internal returns (bytes32 _id) {

        string[] memory dynargs = new string[](3);

        dynargs[0] = _args[0];

        dynargs[1] = _args[1];

        dynargs[2] = _args[2];

        return provable_query(_timestamp, _datasource, dynargs);

    }



    function provable_query(uint _timestamp, string memory _datasource, string[3] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {

        string[] memory dynargs = new string[](3);

        dynargs[0] = _args[0];

        dynargs[1] = _args[1];

        dynargs[2] = _args[2];

        return provable_query(_timestamp, _datasource, dynargs, _gasLimit);

    }



    function provable_query(string memory _datasource, string[3] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {

        string[] memory dynargs = new string[](3);

        dynargs[0] = _args[0];

        dynargs[1] = _args[1];

        dynargs[2] = _args[2];

        return provable_query(_datasource, dynargs, _gasLimit);

    }



    function provable_query(string memory _datasource, string[4] memory _args) provableAPI internal returns (bytes32 _id) {

        string[] memory dynargs = new string[](4);

        dynargs[0] = _args[0];

        dynargs[1] = _args[1];

        dynargs[2] = _args[2];

        dynargs[3] = _args[3];

        return provable_query(_datasource, dynargs);

    }



    function provable_query(uint _timestamp, string memory _datasource, string[4] memory _args) provableAPI internal returns (bytes32 _id) {

        string[] memory dynargs = new string[](4);

        dynargs[0] = _args[0];

        dynargs[1] = _args[1];

        dynargs[2] = _args[2];

        dynargs[3] = _args[3];

        return provable_query(_timestamp, _datasource, dynargs);

    }



    function provable_query(uint _timestamp, string memory _datasource, string[4] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {

        string[] memory dynargs = new string[](4);

        dynargs[0] = _args[0];

        dynargs[1] = _args[1];

        dynargs[2] = _args[2];

        dynargs[3] = _args[3];

        return provable_query(_timestamp, _datasource, dynargs, _gasLimit);

    }



    function provable_query(string memory _datasource, string[4] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {

        string[] memory dynargs = new string[](4);

        dynargs[0] = _args[0];

        dynargs[1] = _args[1];

        dynargs[2] = _args[2];

        dynargs[3] = _args[3];

        return provable_query(_datasource, dynargs, _gasLimit);

    }



    function provable_query(string memory _datasource, string[5] memory _args) provableAPI internal returns (bytes32 _id) {

        string[] memory dynargs = new string[](5);

        dynargs[0] = _args[0];

        dynargs[1] = _args[1];

        dynargs[2] = _args[2];

        dynargs[3] = _args[3];

        dynargs[4] = _args[4];

        return provable_query(_datasource, dynargs);

    }



    function provable_query(uint _timestamp, string memory _datasource, string[5] memory _args) provableAPI internal returns (bytes32 _id) {

        string[] memory dynargs = new string[](5);

        dynargs[0] = _args[0];

        dynargs[1] = _args[1];

        dynargs[2] = _args[2];

        dynargs[3] = _args[3];

        dynargs[4] = _args[4];

        return provable_query(_timestamp, _datasource, dynargs);

    }



    function provable_query(uint _timestamp, string memory _datasource, string[5] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {

        string[] memory dynargs = new string[](5);

        dynargs[0] = _args[0];

        dynargs[1] = _args[1];

        dynargs[2] = _args[2];

        dynargs[3] = _args[3];

        dynargs[4] = _args[4];

        return provable_query(_timestamp, _datasource, dynargs, _gasLimit);

    }



    function provable_query(string memory _datasource, string[5] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {

        string[] memory dynargs = new string[](5);

        dynargs[0] = _args[0];

        dynargs[1] = _args[1];

        dynargs[2] = _args[2];

        dynargs[3] = _args[3];

        dynargs[4] = _args[4];

        return provable_query(_datasource, dynargs, _gasLimit);

    }



    function provable_query(string memory _datasource, bytes[] memory _argN) provableAPI internal returns (bytes32 _id) {

        uint price = provable.getPrice(_datasource);

        if (price > 1 ether + tx.gasprice * 200000) {

            return 0; // Unexpectedly high price

        }

        bytes memory args = ba2cbor(_argN);

        return provable.queryN.value(price)(0, _datasource, args);

    }



    function provable_query(uint _timestamp, string memory _datasource, bytes[] memory _argN) provableAPI internal returns (bytes32 _id) {

        uint price = provable.getPrice(_datasource);

        if (price > 1 ether + tx.gasprice * 200000) {

            return 0; // Unexpectedly high price

        }

        bytes memory args = ba2cbor(_argN);

        return provable.queryN.value(price)(_timestamp, _datasource, args);

    }



    function provable_query(uint _timestamp, string memory _datasource, bytes[] memory _argN, uint _gasLimit) provableAPI internal returns (bytes32 _id) {

        uint price = provable.getPrice(_datasource, _gasLimit);

        if (price > 1 ether + tx.gasprice * _gasLimit) {

            return 0; // Unexpectedly high price

        }

        bytes memory args = ba2cbor(_argN);

        return provable.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);

    }



    function provable_query(string memory _datasource, bytes[] memory _argN, uint _gasLimit) provableAPI internal returns (bytes32 _id) {

        uint price = provable.getPrice(_datasource, _gasLimit);

        if (price > 1 ether + tx.gasprice * _gasLimit) {

            return 0; // Unexpectedly high price

        }

        bytes memory args = ba2cbor(_argN);

        return provable.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);

    }



    function provable_query(string memory _datasource, bytes[1] memory _args) provableAPI internal returns (bytes32 _id) {

        bytes[] memory dynargs = new bytes[](1);

        dynargs[0] = _args[0];

        return provable_query(_datasource, dynargs);

    }



    function provable_query(uint _timestamp, string memory _datasource, bytes[1] memory _args) provableAPI internal returns (bytes32 _id) {

        bytes[] memory dynargs = new bytes[](1);

        dynargs[0] = _args[0];

        return provable_query(_timestamp, _datasource, dynargs);

    }



    function provable_query(uint _timestamp, string memory _datasource, bytes[1] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {

        bytes[] memory dynargs = new bytes[](1);

        dynargs[0] = _args[0];

        return provable_query(_timestamp, _datasource, dynargs, _gasLimit);

    }



    function provable_query(string memory _datasource, bytes[1] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {

        bytes[] memory dynargs = new bytes[](1);

        dynargs[0] = _args[0];

        return provable_query(_datasource, dynargs, _gasLimit);

    }



    function provable_query(string memory _datasource, bytes[2] memory _args) provableAPI internal returns (bytes32 _id) {

        bytes[] memory dynargs = new bytes[](2);

        dynargs[0] = _args[0];

        dynargs[1] = _args[1];

        return provable_query(_datasource, dynargs);

    }



    function provable_query(uint _timestamp, string memory _datasource, bytes[2] memory _args) provableAPI internal returns (bytes32 _id) {

        bytes[] memory dynargs = new bytes[](2);

        dynargs[0] = _args[0];

        dynargs[1] = _args[1];

        return provable_query(_timestamp, _datasource, dynargs);

    }



    function provable_query(uint _timestamp, string memory _datasource, bytes[2] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {

        bytes[] memory dynargs = new bytes[](2);

        dynargs[0] = _args[0];

        dynargs[1] = _args[1];

        return provable_query(_timestamp, _datasource, dynargs, _gasLimit);

    }



    function provable_query(string memory _datasource, bytes[2] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {

        bytes[] memory dynargs = new bytes[](2);

        dynargs[0] = _args[0];

        dynargs[1] = _args[1];

        return provable_query(_datasource, dynargs, _gasLimit);

    }



    function provable_query(string memory _datasource, bytes[3] memory _args) provableAPI internal returns (bytes32 _id) {

        bytes[] memory dynargs = new bytes[](3);

        dynargs[0] = _args[0];

        dynargs[1] = _args[1];

        dynargs[2] = _args[2];

        return provable_query(_datasource, dynargs);

    }



    function provable_query(uint _timestamp, string memory _datasource, bytes[3] memory _args) provableAPI internal returns (bytes32 _id) {

        bytes[] memory dynargs = new bytes[](3);

        dynargs[0] = _args[0];

        dynargs[1] = _args[1];

        dynargs[2] = _args[2];

        return provable_query(_timestamp, _datasource, dynargs);

    }



    function provable_query(uint _timestamp, string memory _datasource, bytes[3] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {

        bytes[] memory dynargs = new bytes[](3);

        dynargs[0] = _args[0];

        dynargs[1] = _args[1];

        dynargs[2] = _args[2];

        return provable_query(_timestamp, _datasource, dynargs, _gasLimit);

    }



    function provable_query(string memory _datasource, bytes[3] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {

        bytes[] memory dynargs = new bytes[](3);

        dynargs[0] = _args[0];

        dynargs[1] = _args[1];

        dynargs[2] = _args[2];

        return provable_query(_datasource, dynargs, _gasLimit);

    }



    function provable_query(string memory _datasource, bytes[4] memory _args) provableAPI internal returns (bytes32 _id) {

        bytes[] memory dynargs = new bytes[](4);

        dynargs[0] = _args[0];

        dynargs[1] = _args[1];

        dynargs[2] = _args[2];

        dynargs[3] = _args[3];

        return provable_query(_datasource, dynargs);

    }



    function provable_query(uint _timestamp, string memory _datasource, bytes[4] memory _args) provableAPI internal returns (bytes32 _id) {

        bytes[] memory dynargs = new bytes[](4);

        dynargs[0] = _args[0];

        dynargs[1] = _args[1];

        dynargs[2] = _args[2];

        dynargs[3] = _args[3];

        return provable_query(_timestamp, _datasource, dynargs);

    }



    function provable_query(uint _timestamp, string memory _datasource, bytes[4] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {

        bytes[] memory dynargs = new bytes[](4);

        dynargs[0] = _args[0];

        dynargs[1] = _args[1];

        dynargs[2] = _args[2];

        dynargs[3] = _args[3];

        return provable_query(_timestamp, _datasource, dynargs, _gasLimit);

    }



    function provable_query(string memory _datasource, bytes[4] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {

        bytes[] memory dynargs = new bytes[](4);

        dynargs[0] = _args[0];

        dynargs[1] = _args[1];

        dynargs[2] = _args[2];

        dynargs[3] = _args[3];

        return provable_query(_datasource, dynargs, _gasLimit);

    }



    function provable_query(string memory _datasource, bytes[5] memory _args) provableAPI internal returns (bytes32 _id) {

        bytes[] memory dynargs = new bytes[](5);

        dynargs[0] = _args[0];

        dynargs[1] = _args[1];

        dynargs[2] = _args[2];

        dynargs[3] = _args[3];

        dynargs[4] = _args[4];

        return provable_query(_datasource, dynargs);

    }



    function provable_query(uint _timestamp, string memory _datasource, bytes[5] memory _args) provableAPI internal returns (bytes32 _id) {

        bytes[] memory dynargs = new bytes[](5);

        dynargs[0] = _args[0];

        dynargs[1] = _args[1];

        dynargs[2] = _args[2];

        dynargs[3] = _args[3];

        dynargs[4] = _args[4];

        return provable_query(_timestamp, _datasource, dynargs);

    }



    function provable_query(uint _timestamp, string memory _datasource, bytes[5] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {

        bytes[] memory dynargs = new bytes[](5);

        dynargs[0] = _args[0];

        dynargs[1] = _args[1];

        dynargs[2] = _args[2];

        dynargs[3] = _args[3];

        dynargs[4] = _args[4];

        return provable_query(_timestamp, _datasource, dynargs, _gasLimit);

    }



    function provable_query(string memory _datasource, bytes[5] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {

        bytes[] memory dynargs = new bytes[](5);

        dynargs[0] = _args[0];

        dynargs[1] = _args[1];

        dynargs[2] = _args[2];

        dynargs[3] = _args[3];

        dynargs[4] = _args[4];

        return provable_query(_datasource, dynargs, _gasLimit);

    }



    function provable_setProof(byte _proofP) provableAPI internal {

        return provable.setProofType(_proofP);

    }





    function provable_cbAddress() provableAPI internal returns (address _callbackAddress) {

        return provable.cbAddress();

    }



    function getCodeSize(address _addr) view internal returns (uint _size) {

        assembly {

            _size := extcodesize(_addr)

        }

    }



    function provable_setCustomGasPrice(uint _gasPrice) provableAPI internal {

        return provable.setCustomGasPrice(_gasPrice);

    }



    function provable_randomDS_getSessionPubKeyHash() provableAPI internal returns (bytes32 _sessionKeyHash) {

        return provable.randomDS_getSessionPubKeyHash();

    }



    function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {

        bytes memory tmp = bytes(_a);

        uint160 iaddr = 0;

        uint160 b1;

        uint160 b2;

        for (uint i = 2; i < 2 + 2 * 20; i += 2) {

            iaddr *= 256;

            b1 = uint160(uint8(tmp[i]));

            b2 = uint160(uint8(tmp[i + 1]));

            if ((b1 >= 97) && (b1 <= 102)) {

                b1 -= 87;

            } else if ((b1 >= 65) && (b1 <= 70)) {

                b1 -= 55;

            } else if ((b1 >= 48) && (b1 <= 57)) {

                b1 -= 48;

            }

            if ((b2 >= 97) && (b2 <= 102)) {

                b2 -= 87;

            } else if ((b2 >= 65) && (b2 <= 70)) {

                b2 -= 55;

            } else if ((b2 >= 48) && (b2 <= 57)) {

                b2 -= 48;

            }

            iaddr += (b1 * 16 + b2);

        }

        return address(iaddr);

    }



    function strCompare(string memory _a, string memory _b) internal pure returns (int _returnCode) {

        bytes memory a = bytes(_a);

        bytes memory b = bytes(_b);

        uint minLength = a.length;

        if (b.length < minLength) {

            minLength = b.length;

        }

        for (uint i = 0; i < minLength; i ++) {

            if (a[i] < b[i]) {

                return -1;

            } else if (a[i] > b[i]) {

                return 1;

            }

        }

        if (a.length < b.length) {

            return -1;

        } else if (a.length > b.length) {

            return 1;

        } else {

            return 0;

        }

    }



    function indexOf(string memory _haystack, string memory _needle) internal pure returns (int _returnCode) {

        bytes memory h = bytes(_haystack);

        bytes memory n = bytes(_needle);

        if (h.length < 1 || n.length < 1 || (n.length > h.length)) {

            return -1;

        } else if (h.length > (2 ** 128 - 1)) {

            return -1;

        } else {

            uint subindex = 0;

            for (uint i = 0; i < h.length; i++) {

                if (h[i] == n[0]) {

                    subindex = 1;

                    while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) {

                        subindex++;

                    }

                    if (subindex == n.length) {

                        return int(i);

                    }

                }

            }

            return -1;

        }

    }



    function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {

        return strConcat(_a, _b, "", "", "");

    }



    function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {

        return strConcat(_a, _b, _c, "", "");

    }



    function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {

        return strConcat(_a, _b, _c, _d, "");

    }



    function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {

        bytes memory _ba = bytes(_a);

        bytes memory _bb = bytes(_b);

        bytes memory _bc = bytes(_c);

        bytes memory _bd = bytes(_d);

        bytes memory _be = bytes(_e);

        string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);

        bytes memory babcde = bytes(abcde);

        uint k = 0;

        uint i = 0;

        for (i = 0; i < _ba.length; i++) {

            babcde[k++] = _ba[i];

        }

        for (i = 0; i < _bb.length; i++) {

            babcde[k++] = _bb[i];

        }

        for (i = 0; i < _bc.length; i++) {

            babcde[k++] = _bc[i];

        }

        for (i = 0; i < _bd.length; i++) {

            babcde[k++] = _bd[i];

        }

        for (i = 0; i < _be.length; i++) {

            babcde[k++] = _be[i];

        }

        return string(babcde);

    }



    function safeParseInt(string memory _a) internal pure returns (uint _parsedInt) {

        return safeParseInt(_a, 0);

    }



    function safeParseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {

        bytes memory bresult = bytes(_a);

        uint mint = 0;

        bool decimals = false;

        for (uint i = 0; i < bresult.length; i++) {

            if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {

                if (decimals) {

                   if (_b == 0) break;

                    else _b--;

                }

                mint *= 10;

                mint += uint(uint8(bresult[i])) - 48;

            } else if (uint(uint8(bresult[i])) == 46) {

                require(!decimals, 'More than one decimal encountered in string!');

                decimals = true;

            } else {

                revert("Non-numeral character encountered in string!");

            }

        }

        if (_b > 0) {

            mint *= 10 ** _b;

        }

        return mint;

    }



    function parseInt(string memory _a) internal pure returns (uint _parsedInt) {

        return parseInt(_a, 0);

    }



    function parseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {

        bytes memory bresult = bytes(_a);

        uint mint = 0;

        bool decimals = false;

        for (uint i = 0; i < bresult.length; i++) {

            if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {

                if (decimals) {

                   if (_b == 0) {

                       break;

                   } else {

                       _b--;

                   }

                }

                mint *= 10;

                mint += uint(uint8(bresult[i])) - 48;

            } else if (uint(uint8(bresult[i])) == 46) {

                decimals = true;

            }

        }

        if (_b > 0) {

            mint *= 10 ** _b;

        }

        return mint;

    }



    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {

        if (_i == 0) {

            return "0";

        }

        uint j = _i;

        uint len;

        while (j != 0) {

            len++;

            j /= 10;

        }

        bytes memory bstr = new bytes(len);

        uint k = len - 1;

        while (_i != 0) {

            bstr[k--] = byte(uint8(48 + _i % 10));

            _i /= 10;

        }

        return string(bstr);

    }



    function stra2cbor(string[] memory _arr) internal pure returns (bytes memory _cborEncoding) {

        safeMemoryCleaner();

        Buffer.buffer memory buf;

        Buffer.init(buf, 1024);

        buf.startArray();

        for (uint i = 0; i < _arr.length; i++) {

            buf.encodeString(_arr[i]);

        }

        buf.endSequence();

        return buf.buf;

    }



    function ba2cbor(bytes[] memory _arr) internal pure returns (bytes memory _cborEncoding) {

        safeMemoryCleaner();

        Buffer.buffer memory buf;

        Buffer.init(buf, 1024);

        buf.startArray();

        for (uint i = 0; i < _arr.length; i++) {

            buf.encodeBytes(_arr[i]);

        }

        buf.endSequence();

        return buf.buf;

    }



    function provable_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32 _queryId) {

        require((_nbytes > 0) && (_nbytes <= 32));

        _delay *= 10; // Convert from seconds to ledger timer ticks

        bytes memory nbytes = new bytes(1);

        nbytes[0] = byte(uint8(_nbytes));

        bytes memory unonce = new bytes(32);

        bytes memory sessionKeyHash = new bytes(32);

        bytes32 sessionKeyHash_bytes32 = provable_randomDS_getSessionPubKeyHash();

        assembly {

            mstore(unonce, 0x20)

            /*

             The following variables can be relaxed.

             Check the relaxed random contract at https://github.com/oraclize/ethereum-examples

             for an idea on how to override and replace commit hash variables.

            */

            mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))

            mstore(sessionKeyHash, 0x20)

            mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)

        }

        bytes memory delay = new bytes(32);

        assembly {

            mstore(add(delay, 0x20), _delay)

        }

        bytes memory delay_bytes8 = new bytes(8);

        copyBytes(delay, 24, 8, delay_bytes8, 0);

        bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];

        bytes32 queryId = provable_query("random", args, _customGasLimit);

        bytes memory delay_bytes8_left = new bytes(8);

        assembly {

            let x := mload(add(delay_bytes8, 0x20))

            mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))

            mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))

            mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))

            mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))

            mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))

            mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))

            mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))

            mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))

        }

        provable_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));

        return queryId;

    }



    function provable_randomDS_setCommitment(bytes32 _queryId, bytes32 _commitment) internal {

        provable_randomDS_args[_queryId] = _commitment;

    }



    function verifySig(bytes32 _tosignh, bytes memory _dersig, bytes memory _pubkey) internal returns (bool _sigVerified) {

        bool sigok;

        address signer;

        bytes32 sigr;

        bytes32 sigs;

        bytes memory sigr_ = new bytes(32);

        uint offset = 4 + (uint(uint8(_dersig[3])) - 0x20);

        sigr_ = copyBytes(_dersig, offset, 32, sigr_, 0);

        bytes memory sigs_ = new bytes(32);

        offset += 32 + 2;

        sigs_ = copyBytes(_dersig, offset + (uint(uint8(_dersig[offset - 1])) - 0x20), 32, sigs_, 0);

        assembly {

            sigr := mload(add(sigr_, 32))

            sigs := mload(add(sigs_, 32))

        }

        (sigok, signer) = safer_ecrecover(_tosignh, 27, sigr, sigs);

        if (address(uint160(uint256(keccak256(_pubkey)))) == signer) {

            return true;

        } else {

            (sigok, signer) = safer_ecrecover(_tosignh, 28, sigr, sigs);

            return (address(uint160(uint256(keccak256(_pubkey)))) == signer);

        }

    }



    function provable_randomDS_proofVerify__sessionKeyValidity(bytes memory _proof, uint _sig2offset) internal returns (bool _proofVerified) {

        bool sigok;

        // Random DS Proof Step 6: Verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)

        bytes memory sig2 = new bytes(uint(uint8(_proof[_sig2offset + 1])) + 2);

        copyBytes(_proof, _sig2offset, sig2.length, sig2, 0);

        bytes memory appkey1_pubkey = new bytes(64);

        copyBytes(_proof, 3 + 1, 64, appkey1_pubkey, 0);

        bytes memory tosign2 = new bytes(1 + 65 + 32);

        tosign2[0] = byte(uint8(1)); //role

        copyBytes(_proof, _sig2offset - 65, 65, tosign2, 1);

        bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";

        copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);

        sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);

        if (!sigok) {

            return false;

        }

        // Random DS Proof Step 7: Verify the APPKEY1 provenance (must be signed by Ledger)

        bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";

        bytes memory tosign3 = new bytes(1 + 65);

        tosign3[0] = 0xFE;

        copyBytes(_proof, 3, 65, tosign3, 1);

        bytes memory sig3 = new bytes(uint(uint8(_proof[3 + 65 + 1])) + 2);

        copyBytes(_proof, 3 + 65, sig3.length, sig3, 0);

        sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);

        return sigok;

    }



    function provable_randomDS_proofVerify__returnCode(bytes32 _queryId, string memory _result, bytes memory _proof) internal returns (uint8 _returnCode) {

        // Random DS Proof Step 1: The prefix has to match 'LP\\x01' (Ledger Proof version 1)

        if ((_proof[0] != "L") || (_proof[1] != "P") || (uint8(_proof[2]) != uint8(1))) {

            return 1;

        }

        bool proofVerified = provable_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), provable_getNetworkName());

        if (!proofVerified) {

            return 2;

        }

        return 0;

    }



    function matchBytes32Prefix(bytes32 _content, bytes memory _prefix, uint _nRandomBytes) internal pure returns (bool _matchesPrefix) {

        bool match_ = true;

        require(_prefix.length == _nRandomBytes);

        for (uint256 i = 0; i< _nRandomBytes; i++) {

            if (_content[i] != _prefix[i]) {

                match_ = false;

            }

        }

        return match_;

    }



    function provable_randomDS_proofVerify__main(bytes memory _proof, bytes32 _queryId, bytes memory _result, string memory _contextName) internal returns (bool _proofVerified) {

        // Random DS Proof Step 2: The unique keyhash has to match with the sha256 of (context name + _queryId)

        uint ledgerProofLength = 3 + 65 + (uint(uint8(_proof[3 + 65 + 1])) + 2) + 32;

        bytes memory keyhash = new bytes(32);

        copyBytes(_proof, ledgerProofLength, 32, keyhash, 0);

        if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(_contextName, _queryId)))))) {

            return false;

        }

        bytes memory sig1 = new bytes(uint(uint8(_proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1])) + 2);

        copyBytes(_proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);

        // Random DS Proof Step 3: We assume sig1 is valid (it will be verified during step 5) and we verify if '_result' is the _prefix of sha256(sig1)

        if (!matchBytes32Prefix(sha256(sig1), _result, uint(uint8(_proof[ledgerProofLength + 32 + 8])))) {

            return false;

        }

        // Random DS Proof Step 4: Commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.

        // This is to verify that the computed args match with the ones specified in the query.

        bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);

        copyBytes(_proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);

        bytes memory sessionPubkey = new bytes(64);

        uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;

        copyBytes(_proof, sig2offset - 64, 64, sessionPubkey, 0);

        bytes32 sessionPubkeyHash = sha256(sessionPubkey);

        if (provable_randomDS_args[_queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))) { //unonce, nbytes and sessionKeyHash match

            delete provable_randomDS_args[_queryId];

        } else return false;

        // Random DS Proof Step 5: Validity verification for sig1 (keyhash and args signed with the sessionKey)

        bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);

        copyBytes(_proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);

        if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) {

            return false;

        }

        // Verify if sessionPubkeyHash was verified already, if not.. let's do it!

        if (!provable_randomDS_sessionKeysHashVerified[sessionPubkeyHash]) {

            provable_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = provable_randomDS_proofVerify__sessionKeyValidity(_proof, sig2offset);

        }

        return provable_randomDS_sessionKeysHashVerified[sessionPubkeyHash];

    }

    /*

     The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license

    */

    function copyBytes(bytes memory _from, uint _fromOffset, uint _length, bytes memory _to, uint _toOffset) internal pure returns (bytes memory _copiedBytes) {

        uint minLength = _length + _toOffset;

        require(_to.length >= minLength); // Buffer too small. Should be a better way?

        uint i = 32 + _fromOffset; // NOTE: the offset 32 is added to skip the `size` field of both bytes variables

        uint j = 32 + _toOffset;

        while (i < (32 + _fromOffset + _length)) {

            assembly {

                let tmp := mload(add(_from, i))

                mstore(add(_to, j), tmp)

            }

            i += 32;

            j += 32;

        }

        return _to;

    }

    /*

     The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license

     Duplicate Solidity's ecrecover, but catching the CALL return value

    */

    function safer_ecrecover(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal returns (bool _success, address _recoveredAddress) {

        /*

         We do our own memory management here. Solidity uses memory offset

         0x40 to store the current end of memory. We write past it (as

         writes are memory extensions), but don't update the offset so

         Solidity will reuse it. The memory used here is only needed for

         this context.

         FIXME: inline assembly can't access return values

        */

        bool ret;

        address addr;

        assembly {

            let size := mload(0x40)

            mstore(size, _hash)

            mstore(add(size, 32), _v)

            mstore(add(size, 64), _r)

            mstore(add(size, 96), _s)

            ret := call(3000, 1, 0, size, 128, size, 32) // NOTE: we can reuse the request memory because we deal with the return code.

            addr := mload(size)

        }

        return (ret, addr);

    }

    /*

     The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license

    */

    function ecrecovery(bytes32 _hash, bytes memory _sig) internal returns (bool _success, address _recoveredAddress) {

        bytes32 r;

        bytes32 s;

        uint8 v;

        if (_sig.length != 65) {

            return (false, address(0));

        }

        /*

         The signature format is a compact form of:

           {bytes32 r}{bytes32 s}{uint8 v}

         Compact means, uint8 is not padded to 32 bytes.

        */

        assembly {

            r := mload(add(_sig, 32))

            s := mload(add(_sig, 64))

            /*

             Here we are loading the last 32 bytes. We exploit the fact that

             'mload' will pad with zeroes if we overread.

             There is no 'mload8' to do this, but that would be nicer.

            */

            v := byte(0, mload(add(_sig, 96)))

            /*

              Alternative solution:

              'byte' is not working due to the Solidity parser, so lets

              use the second best option, 'and'

              v := and(mload(add(_sig, 65)), 255)

            */

        }

        /*

         albeit non-transactional signatures are not specified by the YP, one would expect it

         to match the YP range of [27, 28]

         geth uses [0, 1] and some clients have followed. This might change, see:

         https://github.com/ethereum/go-ethereum/issues/2053

        */

        if (v < 27) {

            v += 27;

        }

        if (v != 27 && v != 28) {

            return (false, address(0));

        }

        return safer_ecrecover(_hash, v, r, s);

    }



    function safeMemoryCleaner() internal pure {

        assembly {

            let fmem := mload(0x40)

            codecopy(fmem, codesize, sub(msize, fmem))

        }

    }

}

// </provableAPI>



// File: contracts/SafeStringCast.sol



pragma solidity ^0.5.0;



library SafeStringCast {

    function toUint(string memory self) pure internal returns(uint16){

        uint16 stringToUintCast = 0;

        bytes memory byteString = bytes(self);

        for(uint i = 0; i < byteString.length; i++){

            uint8 byteToUintCast = uint8(byteString[i]);

            if(byteToUintCast >= 48 && byteToUintCast <= 57){

                stringToUintCast = stringToUintCast * 10 + (byteToUintCast - 48);

            }

        }



        return stringToUintCast;

    }

}



// File: contracts/interfaces/IERC20.sol



pragma solidity ^0.5.0;



/**

 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include

 * the optional functions; to access them see {ERC20Detailed}.

 */

interface IERC20 {

    /**

     * @dev Returns the gsn fee of the contract.

     */

    function gsnFee() external view returns (uint256);

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

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);



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



// File: contracts/interfaces/IUniswapExchange.sol



pragma solidity ^0.5.0;



// Solidity Interface



interface IUniswapExchange {

    // Address of ERC20 token sold on this exchange

    function tokenAddress() external view returns (address token);

    // Address of Uniswap Factory

    function factoryAddress() external view returns (address factory);

    // Provide Liquidity

    function addLiquidity(uint256 min_liquidity, uint256 max_tokens, uint256 deadline) external payable returns (uint256);

    function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens, uint256 deadline) external returns (uint256, uint256);

    // Get Prices

    function getEthToTokenInputPrice(uint256 eth_sold) external view returns (uint256 tokens_bought);

    function getEthToTokenOutputPrice(uint256 tokens_bought) external view returns (uint256 eth_sold);

    function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256 eth_bought);

    function getTokenToEthOutputPrice(uint256 eth_bought) external view returns (uint256 tokens_sold);

    // Trade ETH to ERC20

    function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256  tokens_bought);

    function ethToTokenTransferInput(uint256 min_tokens, uint256 deadline, address recipient) external payable returns (uint256  tokens_bought);

    function ethToTokenSwapOutput(uint256 tokens_bought, uint256 deadline) external payable returns (uint256  eth_sold);

    function ethToTokenTransferOutput(uint256 tokens_bought, uint256 deadline, address recipient) external payable returns (uint256  eth_sold);

    // Trade ERC20 to ETH

    function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256  eth_bought);

    function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline, address recipient) external returns (uint256  eth_bought);

    function tokenToEthSwapOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline) external returns (uint256  tokens_sold);

    function tokenToEthTransferOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline, address recipient) external returns (uint256  tokens_sold);

    // Trade ERC20 to ERC20

    function tokenToTokenSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address token_addr) external returns (uint256  tokens_bought);

    function tokenToTokenTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_bought);

    function tokenToTokenSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address token_addr) external returns (uint256  tokens_sold);

    function tokenToTokenTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_sold);

    // Trade ERC20 to Custom Pool

    function tokenToExchangeSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address exchange_addr) external returns (uint256  tokens_bought);

    function tokenToExchangeTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_bought);

    function tokenToExchangeSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address exchange_addr) external returns (uint256  tokens_sold);

    function tokenToExchangeTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_sold);



    // ERC20 compatibility for liquidity tokens

    function transfer(address _to, uint256 _value) external returns (bool);

    function transferFrom(address _from, address _to, uint256 value) external returns (bool);

    function approve(address _spender, uint256 _value) external returns (bool);

    function allowance(address _owner, address _spender) external view returns (uint256);

    function balanceOf(address _owner) external view returns (uint256);

    function totalSupply() external view returns (uint256);

    // Never use

    function setup(address token_addr) external;

}



// File: contracts/SafeIntCast.sol



pragma solidity ^0.5.0;



library SafeIntCast{

    function toString(uint _base) internal pure returns (string memory) {

        bytes memory _tmp = new bytes(32);

        uint i;

        for(i = 0;_base > 0;i++) {

            _tmp[i] = byte(uint8((_base % 10) + 48));

            _base /= 10;

        }



        bytes memory _real = new bytes(i--);

        for(uint j = 0; j < _real.length; j++) {

            _real[j] = _tmp[i--];

        }

        return string(_real);

    }

}



// File: @0x/contracts-utils/contracts/src/LibBytes.sol



/*



  Copyright 2018 ZeroEx Intl.



  Licensed under the Apache License, Version 2.0 (the "License");

  you may not use this file except in compliance with the License.

  You may obtain a copy of the License at



    http://www.apache.org/licenses/LICENSE-2.0



  Unless required by applicable law or agreed to in writing, software

  distributed under the License is distributed on an "AS IS" BASIS,

  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

  See the License for the specific language governing permissions and

  limitations under the License.



*/



pragma solidity ^0.5.0;





library LibBytes {



    using LibBytes for bytes;



    /// @dev Gets the memory address for a byte array.

    /// @param input Byte array to lookup.

    /// @return memoryAddress Memory address of byte array. This

    ///         points to the header of the byte array which contains

    ///         the length.

    function rawAddress(bytes memory input)

        internal

        pure

        returns (uint256 memoryAddress)

    {

        assembly {

            memoryAddress := input

        }

        return memoryAddress;

    }



    /// @dev Gets the memory address for the contents of a byte array.

    /// @param input Byte array to lookup.

    /// @return memoryAddress Memory address of the contents of the byte array.

    function contentAddress(bytes memory input)

        internal

        pure

        returns (uint256 memoryAddress)

    {

        assembly {

            memoryAddress := add(input, 32)

        }

        return memoryAddress;

    }



    /// @dev Copies `length` bytes from memory location `source` to `dest`.

    /// @param dest memory address to copy bytes to.

    /// @param source memory address to copy bytes from.

    /// @param length number of bytes to copy.

    function memCopy(

        uint256 dest,

        uint256 source,

        uint256 length

    )

        internal

        pure

    {

        if (length < 32) {

            // Handle a partial word by reading destination and masking

            // off the bits we are interested in.

            // This correctly handles overlap, zero lengths and source == dest

            assembly {

                let mask := sub(exp(256, sub(32, length)), 1)

                let s := and(mload(source), not(mask))

                let d := and(mload(dest), mask)

                mstore(dest, or(s, d))

            }

        } else {

            // Skip the O(length) loop when source == dest.

            if (source == dest) {

                return;

            }



            // For large copies we copy whole words at a time. The final

            // word is aligned to the end of the range (instead of after the

            // previous) to handle partial words. So a copy will look like this:

            //

            //  ####

            //      ####

            //          ####

            //            ####

            //

            // We handle overlap in the source and destination range by

            // changing the copying direction. This prevents us from

            // overwriting parts of source that we still need to copy.

            //

            // This correctly handles source == dest

            //

            if (source > dest) {

                assembly {

                    // We subtract 32 from `sEnd` and `dEnd` because it

                    // is easier to compare with in the loop, and these

                    // are also the addresses we need for copying the

                    // last bytes.

                    length := sub(length, 32)

                    let sEnd := add(source, length)

                    let dEnd := add(dest, length)



                    // Remember the last 32 bytes of source

                    // This needs to be done here and not after the loop

                    // because we may have overwritten the last bytes in

                    // source already due to overlap.

                    let last := mload(sEnd)



                    // Copy whole words front to back

                    // Note: the first check is always true,

                    // this could have been a do-while loop.

                    // solhint-disable-next-line no-empty-blocks

                    for {} lt(source, sEnd) {} {

                        mstore(dest, mload(source))

                        source := add(source, 32)

                        dest := add(dest, 32)

                    }



                    // Write the last 32 bytes

                    mstore(dEnd, last)

                }

            } else {

                assembly {

                    // We subtract 32 from `sEnd` and `dEnd` because those

                    // are the starting points when copying a word at the end.

                    length := sub(length, 32)

                    let sEnd := add(source, length)

                    let dEnd := add(dest, length)



                    // Remember the first 32 bytes of source

                    // This needs to be done here and not after the loop

                    // because we may have overwritten the first bytes in

                    // source already due to overlap.

                    let first := mload(source)



                    // Copy whole words back to front

                    // We use a signed comparisson here to allow dEnd to become

                    // negative (happens when source and dest < 32). Valid

                    // addresses in local memory will never be larger than

                    // 2**255, so they can be safely re-interpreted as signed.

                    // Note: the first check is always true,

                    // this could have been a do-while loop.

                    // solhint-disable-next-line no-empty-blocks

                    for {} slt(dest, dEnd) {} {

                        mstore(dEnd, mload(sEnd))

                        sEnd := sub(sEnd, 32)

                        dEnd := sub(dEnd, 32)

                    }



                    // Write the first 32 bytes

                    mstore(dest, first)

                }

            }

        }

    }



    /// @dev Returns a slices from a byte array.

    /// @param b The byte array to take a slice from.

    /// @param from The starting index for the slice (inclusive).

    /// @param to The final index for the slice (exclusive).

    /// @return result The slice containing bytes at indices [from, to)

    function slice(

        bytes memory b,

        uint256 from,

        uint256 to

    )

        internal

        pure

        returns (bytes memory result)

    {

        require(

            from <= to,

            "FROM_LESS_THAN_TO_REQUIRED"

        );

        require(

            to <= b.length,

            "TO_LESS_THAN_LENGTH_REQUIRED"

        );



        // Create a new bytes structure and copy contents

        result = new bytes(to - from);

        memCopy(

            result.contentAddress(),

            b.contentAddress() + from,

            result.length

        );

        return result;

    }



    /// @dev Returns a slice from a byte array without preserving the input.

    /// @param b The byte array to take a slice from. Will be destroyed in the process.

    /// @param from The starting index for the slice (inclusive).

    /// @param to The final index for the slice (exclusive).

    /// @return result The slice containing bytes at indices [from, to)

    /// @dev When `from == 0`, the original array will match the slice. In other cases its state will be corrupted.

    function sliceDestructive(

        bytes memory b,

        uint256 from,

        uint256 to

    )

        internal

        pure

        returns (bytes memory result)

    {

        require(

            from <= to,

            "FROM_LESS_THAN_TO_REQUIRED"

        );

        require(

            to <= b.length,

            "TO_LESS_THAN_LENGTH_REQUIRED"

        );



        // Create a new bytes structure around [from, to) in-place.

        assembly {

            result := add(b, from)

            mstore(result, sub(to, from))

        }

        return result;

    }



    /// @dev Pops the last byte off of a byte array by modifying its length.

    /// @param b Byte array that will be modified.

    /// @return The byte that was popped off.

    function popLastByte(bytes memory b)

        internal

        pure

        returns (bytes1 result)

    {

        require(

            b.length > 0,

            "GREATER_THAN_ZERO_LENGTH_REQUIRED"

        );



        // Store last byte.

        result = b[b.length - 1];



        assembly {

            // Decrement length of byte array.

            let newLen := sub(mload(b), 1)

            mstore(b, newLen)

        }

        return result;

    }



    /// @dev Pops the last 20 bytes off of a byte array by modifying its length.

    /// @param b Byte array that will be modified.

    /// @return The 20 byte address that was popped off.

    function popLast20Bytes(bytes memory b)

        internal

        pure

        returns (address result)

    {

        require(

            b.length >= 20,

            "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"

        );



        // Store last 20 bytes.

        result = readAddress(b, b.length - 20);



        assembly {

            // Subtract 20 from byte array length.

            let newLen := sub(mload(b), 20)

            mstore(b, newLen)

        }

        return result;

    }



    /// @dev Tests equality of two byte arrays.

    /// @param lhs First byte array to compare.

    /// @param rhs Second byte array to compare.

    /// @return True if arrays are the same. False otherwise.

    function equals(

        bytes memory lhs,

        bytes memory rhs

    )

        internal

        pure

        returns (bool equal)

    {

        // Keccak gas cost is 30 + numWords * 6. This is a cheap way to compare.

        // We early exit on unequal lengths, but keccak would also correctly

        // handle this.

        return lhs.length == rhs.length && keccak256(lhs) == keccak256(rhs);

    }



    /// @dev Reads an address from a position in a byte array.

    /// @param b Byte array containing an address.

    /// @param index Index in byte array of address.

    /// @return address from byte array.

    function readAddress(

        bytes memory b,

        uint256 index

    )

        internal

        pure

        returns (address result)

    {

        require(

            b.length >= index + 20,  // 20 is length of address

            "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"

        );



        // Add offset to index:

        // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)

        // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)

        index += 20;



        // Read address from array memory

        assembly {

            // 1. Add index to address of bytes array

            // 2. Load 32-byte word from memory

            // 3. Apply 20-byte mask to obtain address

            result := and(mload(add(b, index)), 0xffffffffffffffffffffffffffffffffffffffff)

        }

        return result;

    }



    /// @dev Writes an address into a specific position in a byte array.

    /// @param b Byte array to insert address into.

    /// @param index Index in byte array of address.

    /// @param input Address to put into byte array.

    function writeAddress(

        bytes memory b,

        uint256 index,

        address input

    )

        internal

        pure

    {

        require(

            b.length >= index + 20,  // 20 is length of address

            "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"

        );



        // Add offset to index:

        // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)

        // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)

        index += 20;



        // Store address into array memory

        assembly {

            // The address occupies 20 bytes and mstore stores 32 bytes.

            // First fetch the 32-byte word where we'll be storing the address, then

            // apply a mask so we have only the bytes in the word that the address will not occupy.

            // Then combine these bytes with the address and store the 32 bytes back to memory with mstore.



            // 1. Add index to address of bytes array

            // 2. Load 32-byte word from memory

            // 3. Apply 12-byte mask to obtain extra bytes occupying word of memory where we'll store the address

            let neighbors := and(

                mload(add(b, index)),

                0xffffffffffffffffffffffff0000000000000000000000000000000000000000

            )



            // Make sure input address is clean.

            // (Solidity does not guarantee this)

            input := and(input, 0xffffffffffffffffffffffffffffffffffffffff)



            // Store the neighbors and address into memory

            mstore(add(b, index), xor(input, neighbors))

        }

    }



    /// @dev Reads a bytes32 value from a position in a byte array.

    /// @param b Byte array containing a bytes32 value.

    /// @param index Index in byte array of bytes32 value.

    /// @return bytes32 value from byte array.

    function readBytes32(

        bytes memory b,

        uint256 index

    )

        internal

        pure

        returns (bytes32 result)

    {

        require(

            b.length >= index + 32,

            "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED"

        );



        // Arrays are prefixed by a 256 bit length parameter

        index += 32;



        // Read the bytes32 from array memory

        assembly {

            result := mload(add(b, index))

        }

        return result;

    }



    /// @dev Writes a bytes32 into a specific position in a byte array.

    /// @param b Byte array to insert <input> into.

    /// @param index Index in byte array of <input>.

    /// @param input bytes32 to put into byte array.

    function writeBytes32(

        bytes memory b,

        uint256 index,

        bytes32 input

    )

        internal

        pure

    {

        require(

            b.length >= index + 32,

            "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED"

        );



        // Arrays are prefixed by a 256 bit length parameter

        index += 32;



        // Read the bytes32 from array memory

        assembly {

            mstore(add(b, index), input)

        }

    }



    /// @dev Reads a uint256 value from a position in a byte array.

    /// @param b Byte array containing a uint256 value.

    /// @param index Index in byte array of uint256 value.

    /// @return uint256 value from byte array.

    function readUint256(

        bytes memory b,

        uint256 index

    )

        internal

        pure

        returns (uint256 result)

    {

        result = uint256(readBytes32(b, index));

        return result;

    }



    /// @dev Writes a uint256 into a specific position in a byte array.

    /// @param b Byte array to insert <input> into.

    /// @param index Index in byte array of <input>.

    /// @param input uint256 to put into byte array.

    function writeUint256(

        bytes memory b,

        uint256 index,

        uint256 input

    )

        internal

        pure

    {

        writeBytes32(b, index, bytes32(input));

    }



    /// @dev Reads an unpadded bytes4 value from a position in a byte array.

    /// @param b Byte array containing a bytes4 value.

    /// @param index Index in byte array of bytes4 value.

    /// @return bytes4 value from byte array.

    function readBytes4(

        bytes memory b,

        uint256 index

    )

        internal

        pure

        returns (bytes4 result)

    {

        require(

            b.length >= index + 4,

            "GREATER_OR_EQUAL_TO_4_LENGTH_REQUIRED"

        );



        // Arrays are prefixed by a 32 byte length field

        index += 32;



        // Read the bytes4 from array memory

        assembly {

            result := mload(add(b, index))

            // Solidity does not require us to clean the trailing bytes.

            // We do it anyway

            result := and(result, 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000)

        }

        return result;

    }



    /// @dev Reads nested bytes from a specific position.

    /// @dev NOTE: the returned value overlaps with the input value.

    ///            Both should be treated as immutable.

    /// @param b Byte array containing nested bytes.

    /// @param index Index of nested bytes.

    /// @return result Nested bytes.

    function readBytesWithLength(

        bytes memory b,

        uint256 index

    )

        internal

        pure

        returns (bytes memory result)

    {

        // Read length of nested bytes

        uint256 nestedBytesLength = readUint256(b, index);

        index += 32;



        // Assert length of <b> is valid, given

        // length of nested bytes

        require(

            b.length >= index + nestedBytesLength,

            "GREATER_OR_EQUAL_TO_NESTED_BYTES_LENGTH_REQUIRED"

        );



        // Return a pointer to the byte array as it exists inside `b`

        assembly {

            result := add(b, index)

        }

        return result;

    }



    /// @dev Inserts bytes at a specific position in a byte array.

    /// @param b Byte array to insert <input> into.

    /// @param index Index in byte array of <input>.

    /// @param input bytes to insert.

    function writeBytesWithLength(

        bytes memory b,

        uint256 index,

        bytes memory input

    )

        internal

        pure

    {

        // Assert length of <b> is valid, given

        // length of input

        require(

            b.length >= index + 32 + input.length,  // 32 bytes to store length

            "GREATER_OR_EQUAL_TO_NESTED_BYTES_LENGTH_REQUIRED"

        );



        // Copy <input> into <b>

        memCopy(

            b.contentAddress() + index,

            input.rawAddress(), // includes length of <input>

            input.length + 32   // +32 bytes to store <input> length

        );

    }



    /// @dev Performs a deep copy of a byte array onto another byte array of greater than or equal length.

    /// @param dest Byte array that will be overwritten with source bytes.

    /// @param source Byte array to copy onto dest bytes.

    function deepCopyBytes(

        bytes memory dest,

        bytes memory source

    )

        internal

        pure

    {

        uint256 sourceLen = source.length;

        // Dest length must be >= source length, or some bytes would not be copied.

        require(

            dest.length >= sourceLen,

            "GREATER_OR_EQUAL_TO_SOURCE_BYTES_LENGTH_REQUIRED"

        );

        memCopy(

            dest.contentAddress(),

            source.contentAddress(),

            sourceLen

        );

    }

}



// File: @openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol



pragma solidity ^0.5.0;



/**

 * @dev Wrappers over Solidity's arithmetic operations with added overflow

 * checks.

 *

 * Arithmetic operations in Solidity wrap on overflow. This can easily result

 * in bugs, because programmers usually assume that an overflow raises an

 * error, which is the standard behavior in high level programming languages.

 * `SafeMath` restores this intuition by reverting the transaction when an

 * operation overflows.

 *

 * Using this library instead of the unchecked operations eliminates an entire

 * class of bugs, so it's recommended to use it always.

 */

library SafeMath {

    /**

     * @dev Returns the addition of two unsigned integers, reverting on

     * overflow.

     *

     * Counterpart to Solidity's `+` operator.

     *

     * Requirements:

     * - Addition cannot overflow.

     */

    function add(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a + b;

        require(c >= a, "SafeMath: addition overflow");



        return c;

    }



    /**

     * @dev Returns the subtraction of two unsigned integers, reverting on

     * overflow (when the result is negative).

     *

     * Counterpart to Solidity's `-` operator.

     *

     * Requirements:

     * - Subtraction cannot overflow.

     */

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {

        return sub(a, b, "SafeMath: subtraction overflow");

    }



    /**

     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on

     * overflow (when the result is negative).

     *

     * Counterpart to Solidity's `-` operator.

     *

     * Requirements:

     * - Subtraction cannot overflow.

     *

     * _Available since v2.4.0._

     */

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b <= a, errorMessage);

        uint256 c = a - b;



        return c;

    }



    /**

     * @dev Returns the multiplication of two unsigned integers, reverting on

     * overflow.

     *

     * Counterpart to Solidity's `*` operator.

     *

     * Requirements:

     * - Multiplication cannot overflow.

     */

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {

        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the

        // benefit is lost if 'b' is also tested.

        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522

        if (a == 0) {

            return 0;

        }



        uint256 c = a * b;

        require(c / a == b, "SafeMath: multiplication overflow");



        return c;

    }



    /**

     * @dev Returns the integer division of two unsigned integers. Reverts on

     * division by zero. The result is rounded towards zero.

     *

     * Counterpart to Solidity's `/` operator. Note: this function uses a

     * `revert` opcode (which leaves remaining gas untouched) while Solidity

     * uses an invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     * - The divisor cannot be zero.

     */

    function div(uint256 a, uint256 b) internal pure returns (uint256) {

        return div(a, b, "SafeMath: division by zero");

    }



    /**

     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on

     * division by zero. The result is rounded towards zero.

     *

     * Counterpart to Solidity's `/` operator. Note: this function uses a

     * `revert` opcode (which leaves remaining gas untouched) while Solidity

     * uses an invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     * - The divisor cannot be zero.

     *

     * _Available since v2.4.0._

     */

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        // Solidity only automatically asserts when dividing by 0

        require(b > 0, errorMessage);

        uint256 c = a / b;

        // assert(a == b * c + a % b); // There is no case in which this doesn't hold



        return c;

    }



    /**

     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),

     * Reverts when dividing by zero.

     *

     * Counterpart to Solidity's `%` operator. This function uses a `revert`

     * opcode (which leaves remaining gas untouched) while Solidity uses an

     * invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     * - The divisor cannot be zero.

     */

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {

        return mod(a, b, "SafeMath: modulo by zero");

    }



    /**

     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),

     * Reverts with custom message when dividing by zero.

     *

     * Counterpart to Solidity's `%` operator. This function uses a `revert`

     * opcode (which leaves remaining gas untouched) while Solidity uses an

     * invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     * - The divisor cannot be zero.

     *

     * _Available since v2.4.0._

     */

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b != 0, errorMessage);

        return a % b;

    }

}



// File: @openzeppelin/upgrades/contracts/Initializable.sol



pragma solidity >=0.4.24 <0.6.0;





/**

 * @title Initializable

 *

 * @dev Helper contract to support initializer functions. To use it, replace

 * the constructor with a function that has the `initializer` modifier.

 * WARNING: Unlike constructors, initializer functions must be manually

 * invoked. This applies both to deploying an Initializable contract, as well

 * as extending an Initializable contract via inheritance.

 * WARNING: When used with inheritance, manual care must be taken to not invoke

 * a parent initializer twice, or ensure that all initializers are idempotent,

 * because this is not dealt with automatically as with constructors.

 */

contract Initializable {



  /**

   * @dev Indicates that the contract has been initialized.

   */

  bool private initialized;



  /**

   * @dev Indicates that the contract is in the process of being initialized.

   */

  bool private initializing;



  /**

   * @dev Modifier to use in the initializer function of a contract.

   */

  modifier initializer() {

    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");



    bool isTopLevelCall = !initializing;

    if (isTopLevelCall) {

      initializing = true;

      initialized = true;

    }



    _;



    if (isTopLevelCall) {

      initializing = false;

    }

  }



  /// @dev Returns true if and only if the function is running in the constructor

  function isConstructor() private view returns (bool) {

    // extcodesize checks the size of the code stored in an address, and

    // address returns the current address. Since the code is still not

    // deployed when running a constructor, any checks on its code size will

    // yield zero, making it an effective way to detect if a contract is

    // under construction or not.

    uint256 cs;

    assembly { cs := extcodesize(address) }

    return cs == 0;

  }



  // Reserved storage space to allow for layout changes in the future.

  uint256[50] private ______gap;

}



// File: @openzeppelin/contracts-ethereum-package/contracts/GSN/IRelayRecipient.sol



pragma solidity ^0.5.0;



/**

 * @dev Base interface for a contract that will be called via the GSN from {IRelayHub}.

 *

 * TIP: You don't need to write an implementation yourself! Inherit from {GSNRecipient} instead.

 */

contract IRelayRecipient {

    /**

     * @dev Returns the address of the {IRelayHub} instance this recipient interacts with.

     */

    function getHubAddr() public view returns (address);



    /**

     * @dev Called by {IRelayHub} to validate if this recipient accepts being charged for a relayed call. Note that the

     * recipient will be charged regardless of the execution result of the relayed call (i.e. if it reverts or not).

     *

     * The relay request was originated by `from` and will be served by `relay`. `encodedFunction` is the relayed call

     * calldata, so its first four bytes are the function selector. The relayed call will be forwarded `gasLimit` gas,

     * and the transaction executed with a gas price of at least `gasPrice`. `relay`'s fee is `transactionFee`, and the

     * recipient will be charged at most `maxPossibleCharge` (in wei). `nonce` is the sender's (`from`) nonce for

     * replay attack protection in {IRelayHub}, and `approvalData` is a optional parameter that can be used to hold a signature

     * over all or some of the previous values.

     *

     * Returns a tuple, where the first value is used to indicate approval (0) or rejection (custom non-zero error code,

     * values 1 to 10 are reserved) and the second one is data to be passed to the other {IRelayRecipient} functions.

     *

     * {acceptRelayedCall} is called with 50k gas: if it runs out during execution, the request will be considered

     * rejected. A regular revert will also trigger a rejection.

     */

    function acceptRelayedCall(

        address relay,

        address from,

        bytes calldata encodedFunction,

        uint256 transactionFee,

        uint256 gasPrice,

        uint256 gasLimit,

        uint256 nonce,

        bytes calldata approvalData,

        uint256 maxPossibleCharge

    )

        external

        view

        returns (uint256, bytes memory);



    /**

     * @dev Called by {IRelayHub} on approved relay call requests, before the relayed call is executed. This allows to e.g.

     * pre-charge the sender of the transaction.

     *

     * `context` is the second value returned in the tuple by {acceptRelayedCall}.

     *

     * Returns a value to be passed to {postRelayedCall}.

     *

     * {preRelayedCall} is called with 100k gas: if it runs out during exection or otherwise reverts, the relayed call

     * will not be executed, but the recipient will still be charged for the transaction's cost.

     */

    function preRelayedCall(bytes calldata context) external returns (bytes32);



    /**

     * @dev Called by {IRelayHub} on approved relay call requests, after the relayed call is executed. This allows to e.g.

     * charge the user for the relayed call costs, return any overcharges from {preRelayedCall}, or perform

     * contract-specific bookkeeping.

     *

     * `context` is the second value returned in the tuple by {acceptRelayedCall}. `success` is the execution status of

     * the relayed call. `actualCharge` is an estimate of how much the recipient will be charged for the transaction,

     * not including any gas used by {postRelayedCall} itself. `preRetVal` is {preRelayedCall}'s return value.

     *

     *

     * {postRelayedCall} is called with 100k gas: if it runs out during execution or otherwise reverts, the relayed call

     * and the call to {preRelayedCall} will be reverted retroactively, but the recipient will still be charged for the

     * transaction's cost.

     */

    function postRelayedCall(bytes calldata context, bool success, uint256 actualCharge, bytes32 preRetVal) external;

}



// File: @openzeppelin/contracts-ethereum-package/contracts/GSN/IRelayHub.sol



pragma solidity ^0.5.0;



/**

 * @dev Interface for `RelayHub`, the core contract of the GSN. Users should not need to interact with this contract

 * directly.

 *

 * See the https://github.com/OpenZeppelin/openzeppelin-gsn-helpers[OpenZeppelin GSN helpers] for more information on

 * how to deploy an instance of `RelayHub` on your local test network.

 */

contract IRelayHub {

    // Relay management



    /**

     * @dev Adds stake to a relay and sets its `unstakeDelay`. If the relay does not exist, it is created, and the caller

     * of this function becomes its owner. If the relay already exists, only the owner can call this function. A relay

     * cannot be its own owner.

     *

     * All Ether in this function call will be added to the relay's stake.

     * Its unstake delay will be assigned to `unstakeDelay`, but the new value must be greater or equal to the current one.

     *

     * Emits a {Staked} event.

     */

    function stake(address relayaddr, uint256 unstakeDelay) external payable;



    /**

     * @dev Emitted when a relay's stake or unstakeDelay are increased

     */

    event Staked(address indexed relay, uint256 stake, uint256 unstakeDelay);



    /**

     * @dev Registers the caller as a relay.

     * The relay must be staked for, and not be a contract (i.e. this function must be called directly from an EOA).

     *

     * This function can be called multiple times, emitting new {RelayAdded} events. Note that the received

     * `transactionFee` is not enforced by {relayCall}.

     *

     * Emits a {RelayAdded} event.

     */

    function registerRelay(uint256 transactionFee, string memory url) public;



    /**

     * @dev Emitted when a relay is registered or re-registerd. Looking at these events (and filtering out

     * {RelayRemoved} events) lets a client discover the list of available relays.

     */

    event RelayAdded(address indexed relay, address indexed owner, uint256 transactionFee, uint256 stake, uint256 unstakeDelay, string url);



    /**

     * @dev Removes (deregisters) a relay. Unregistered (but staked for) relays can also be removed.

     *

     * Can only be called by the owner of the relay. After the relay's `unstakeDelay` has elapsed, {unstake} will be

     * callable.

     *

     * Emits a {RelayRemoved} event.

     */

    function removeRelayByOwner(address relay) public;



    /**

     * @dev Emitted when a relay is removed (deregistered). `unstakeTime` is the time when unstake will be callable.

     */

    event RelayRemoved(address indexed relay, uint256 unstakeTime);



    /** Deletes the relay from the system, and gives back its stake to the owner.

     *

     * Can only be called by the relay owner, after `unstakeDelay` has elapsed since {removeRelayByOwner} was called.

     *

     * Emits an {Unstaked} event.

     */

    function unstake(address relay) public;



    /**

     * @dev Emitted when a relay is unstaked for, including the returned stake.

     */

    event Unstaked(address indexed relay, uint256 stake);



    // States a relay can be in

    enum RelayState {

        Unknown, // The relay is unknown to the system: it has never been staked for

        Staked, // The relay has been staked for, but it is not yet active

        Registered, // The relay has registered itself, and is active (can relay calls)

        Removed    // The relay has been removed by its owner and can no longer relay calls. It must wait for its unstakeDelay to elapse before it can unstake

    }



    /**

     * @dev Returns a relay's status. Note that relays can be deleted when unstaked or penalized, causing this function

     * to return an empty entry.

     */

    function getRelay(address relay) external view returns (uint256 totalStake, uint256 unstakeDelay, uint256 unstakeTime, address payable owner, RelayState state);



    // Balance management



    /**

     * @dev Deposits Ether for a contract, so that it can receive (and pay for) relayed transactions.

     *

     * Unused balance can only be withdrawn by the contract itself, by calling {withdraw}.

     *

     * Emits a {Deposited} event.

     */

    function depositFor(address target) public payable;



    /**

     * @dev Emitted when {depositFor} is called, including the amount and account that was funded.

     */

    event Deposited(address indexed recipient, address indexed from, uint256 amount);



    /**

     * @dev Returns an account's deposits. These can be either a contracts's funds, or a relay owner's revenue.

     */

    function balanceOf(address target) external view returns (uint256);



    /**

     * Withdraws from an account's balance, sending it back to it. Relay owners call this to retrieve their revenue, and

     * contracts can use it to reduce their funding.

     *

     * Emits a {Withdrawn} event.

     */

    function withdraw(uint256 amount, address payable dest) public;



    /**

     * @dev Emitted when an account withdraws funds from `RelayHub`.

     */

    event Withdrawn(address indexed account, address indexed dest, uint256 amount);



    // Relaying



    /**

     * @dev Checks if the `RelayHub` will accept a relayed operation.

     * Multiple things must be true for this to happen:

     *  - all arguments must be signed for by the sender (`from`)

     *  - the sender's nonce must be the current one

     *  - the recipient must accept this transaction (via {acceptRelayedCall})

     *

     * Returns a `PreconditionCheck` value (`OK` when the transaction can be relayed), or a recipient-specific error

     * code if it returns one in {acceptRelayedCall}.

     */

    function canRelay(

        address relay,

        address from,

        address to,

        bytes memory encodedFunction,

        uint256 transactionFee,

        uint256 gasPrice,

        uint256 gasLimit,

        uint256 nonce,

        bytes memory signature,

        bytes memory approvalData

    ) public view returns (uint256 status, bytes memory recipientContext);



    // Preconditions for relaying, checked by canRelay and returned as the corresponding numeric values.

    enum PreconditionCheck {

        OK,                         // All checks passed, the call can be relayed

        WrongSignature,             // The transaction to relay is not signed by requested sender

        WrongNonce,                 // The provided nonce has already been used by the sender

        AcceptRelayedCallReverted,  // The recipient rejected this call via acceptRelayedCall

        InvalidRecipientStatusCode  // The recipient returned an invalid (reserved) status code

    }



    /**

     * @dev Relays a transaction.

     *

     * For this to succeed, multiple conditions must be met:

     *  - {canRelay} must `return PreconditionCheck.OK`

     *  - the sender must be a registered relay

     *  - the transaction's gas price must be larger or equal to the one that was requested by the sender

     *  - the transaction must have enough gas to not run out of gas if all internal transactions (calls to the

     * recipient) use all gas available to them

     *  - the recipient must have enough balance to pay the relay for the worst-case scenario (i.e. when all gas is

     * spent)

     *

     * If all conditions are met, the call will be relayed and the recipient charged. {preRelayedCall}, the encoded

     * function and {postRelayedCall} will be called in that order.

     *

     * Parameters:

     *  - `from`: the client originating the request

     *  - `to`: the target {IRelayRecipient} contract

     *  - `encodedFunction`: the function call to relay, including data

     *  - `transactionFee`: fee (%) the relay takes over actual gas cost

     *  - `gasPrice`: gas price the client is willing to pay

     *  - `gasLimit`: gas to forward when calling the encoded function

     *  - `nonce`: client's nonce

     *  - `signature`: client's signature over all previous params, plus the relay and RelayHub addresses

     *  - `approvalData`: dapp-specific data forwared to {acceptRelayedCall}. This value is *not* verified by the

     * `RelayHub`, but it still can be used for e.g. a signature.

     *

     * Emits a {TransactionRelayed} event.

     */

    function relayCall(

        address from,

        address to,

        bytes memory encodedFunction,

        uint256 transactionFee,

        uint256 gasPrice,

        uint256 gasLimit,

        uint256 nonce,

        bytes memory signature,

        bytes memory approvalData

    ) public;



    /**

     * @dev Emitted when an attempt to relay a call failed.

     *

     * This can happen due to incorrect {relayCall} arguments, or the recipient not accepting the relayed call. The

     * actual relayed call was not executed, and the recipient not charged.

     *

     * The `reason` parameter contains an error code: values 1-10 correspond to `PreconditionCheck` entries, and values

     * over 10 are custom recipient error codes returned from {acceptRelayedCall}.

     */

    event CanRelayFailed(address indexed relay, address indexed from, address indexed to, bytes4 selector, uint256 reason);



    /**

     * @dev Emitted when a transaction is relayed. 

     * Useful when monitoring a relay's operation and relayed calls to a contract

     *

     * Note that the actual encoded function might be reverted: this is indicated in the `status` parameter.

     *

     * `charge` is the Ether value deducted from the recipient's balance, paid to the relay's owner.

     */

    event TransactionRelayed(address indexed relay, address indexed from, address indexed to, bytes4 selector, RelayCallStatus status, uint256 charge);



    // Reason error codes for the TransactionRelayed event

    enum RelayCallStatus {

        OK,                      // The transaction was successfully relayed and execution successful - never included in the event

        RelayedCallFailed,       // The transaction was relayed, but the relayed call failed

        PreRelayedFailed,        // The transaction was not relayed due to preRelatedCall reverting

        PostRelayedFailed,       // The transaction was relayed and reverted due to postRelatedCall reverting

        RecipientBalanceChanged  // The transaction was relayed and reverted due to the recipient's balance changing

    }



    /**

     * @dev Returns how much gas should be forwarded to a call to {relayCall}, in order to relay a transaction that will

     * spend up to `relayedCallStipend` gas.

     */

    function requiredGas(uint256 relayedCallStipend) public view returns (uint256);



    /**

     * @dev Returns the maximum recipient charge, given the amount of gas forwarded, gas price and relay fee.

     */

    function maxPossibleCharge(uint256 relayedCallStipend, uint256 gasPrice, uint256 transactionFee) public view returns (uint256);



     // Relay penalization. 

     // Any account can penalize relays, removing them from the system immediately, and rewarding the

    // reporter with half of the relay's stake. The other half is burned so that, even if the relay penalizes itself, it

    // still loses half of its stake.



    /**

     * @dev Penalize a relay that signed two transactions using the same nonce (making only the first one valid) and

     * different data (gas price, gas limit, etc. may be different).

     *

     * The (unsigned) transaction data and signature for both transactions must be provided.

     */

    function penalizeRepeatedNonce(bytes memory unsignedTx1, bytes memory signature1, bytes memory unsignedTx2, bytes memory signature2) public;



    /**

     * @dev Penalize a relay that sent a transaction that didn't target `RelayHub`'s {registerRelay} or {relayCall}.

     */

    function penalizeIllegalTransaction(bytes memory unsignedTx, bytes memory signature) public;



    /**

     * @dev Emitted when a relay is penalized.

     */

    event Penalized(address indexed relay, address sender, uint256 amount);



    /**

     * @dev Returns an account's nonce in `RelayHub`.

     */

    function getNonce(address from) external view returns (uint256);

}



// File: @openzeppelin/contracts-ethereum-package/contracts/GSN/Context.sol



pragma solidity ^0.5.0;





/*

 * @dev Provides information about the current execution context, including the

 * sender of the transaction and its data. While these are generally available

 * via msg.sender and msg.data, they should not be accessed in such a direct

 * manner, since when dealing with GSN meta-transactions the account sending and

 * paying for execution may not be the actual sender (as far as an application

 * is concerned).

 *

 * This contract is only required for intermediate, library-like contracts.

 */

contract Context is Initializable {

    // Empty internal constructor, to prevent people from mistakenly deploying

    // an instance of this contract, which should be used via inheritance.

    constructor () internal { }

    // solhint-disable-previous-line no-empty-blocks



    function _msgSender() internal view returns (address payable) {

        return msg.sender;

    }



    function _msgData() internal view returns (bytes memory) {

        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691

        return msg.data;

    }

}



// File: @openzeppelin/contracts-ethereum-package/contracts/GSN/GSNRecipient.sol



pragma solidity ^0.5.0;











/**

 * @dev Base GSN recipient contract: includes the {IRelayRecipient} interface

 * and enables GSN support on all contracts in the inheritance tree.

 *

 * TIP: This contract is abstract. The functions {acceptRelayedCall},

 *  {_preRelayedCall}, and {_postRelayedCall} are not implemented and must be

 * provided by derived contracts. See the

 * xref:ROOT:gsn-strategies.adoc#gsn-strategies[GSN strategies] for more

 * information on how to use the pre-built {GSNRecipientSignature} and

 * {GSNRecipientERC20Fee}, or how to write your own.

 */

contract GSNRecipient is Initializable, IRelayRecipient, Context {

    function initialize() public initializer {

        if (_relayHub == address(0)) {

            setDefaultRelayHub();

        }

    }



    function setDefaultRelayHub() public {

        _upgradeRelayHub(0xD216153c06E857cD7f72665E0aF1d7D82172F494);

    }



    // Default RelayHub address, deployed on mainnet and all testnets at the same address

    address private _relayHub;



    uint256 constant private RELAYED_CALL_ACCEPTED = 0;

    uint256 constant private RELAYED_CALL_REJECTED = 11;



    // How much gas is forwarded to postRelayedCall

    uint256 constant internal POST_RELAYED_CALL_MAX_GAS = 100000;



    /**

     * @dev Emitted when a contract changes its {IRelayHub} contract to a new one.

     */

    event RelayHubChanged(address indexed oldRelayHub, address indexed newRelayHub);



    /**

     * @dev Returns the address of the {IRelayHub} contract for this recipient.

     */

    function getHubAddr() public view returns (address) {

        return _relayHub;

    }



    /**

     * @dev Switches to a new {IRelayHub} instance. This method is added for future-proofing: there's no reason to not

     * use the default instance.

     *

     * IMPORTANT: After upgrading, the {GSNRecipient} will no longer be able to receive relayed calls from the old

     * {IRelayHub} instance. Additionally, all funds should be previously withdrawn via {_withdrawDeposits}.

     */

    function _upgradeRelayHub(address newRelayHub) internal {

        address currentRelayHub = _relayHub;

        require(newRelayHub != address(0), "GSNRecipient: new RelayHub is the zero address");

        require(newRelayHub != currentRelayHub, "GSNRecipient: new RelayHub is the current one");



        emit RelayHubChanged(currentRelayHub, newRelayHub);



        _relayHub = newRelayHub;

    }



    /**

     * @dev Returns the version string of the {IRelayHub} for which this recipient implementation was built. If

     * {_upgradeRelayHub} is used, the new {IRelayHub} instance should be compatible with this version.

     */

    // This function is view for future-proofing, it may require reading from

    // storage in the future.

    function relayHubVersion() public view returns (string memory) {

        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691

        return "1.0.0";

    }



    /**

     * @dev Withdraws the recipient's deposits in `RelayHub`.

     *

     * Derived contracts should expose this in an external interface with proper access control.

     */

    function _withdrawDeposits(uint256 amount, address payable payee) internal {

        IRelayHub(_relayHub).withdraw(amount, payee);

    }



    // Overrides for Context's functions: when called from RelayHub, sender and

    // data require some pre-processing: the actual sender is stored at the end

    // of the call data, which in turns means it needs to be removed from it

    // when handling said data.



    /**

     * @dev Replacement for msg.sender. Returns the actual sender of a transaction: msg.sender for regular transactions,

     * and the end-user for GSN relayed calls (where msg.sender is actually `RelayHub`).

     *

     * IMPORTANT: Contracts derived from {GSNRecipient} should never use `msg.sender`, and use {_msgSender} instead.

     */

    function _msgSender() internal view returns (address payable) {

        if (msg.sender != _relayHub) {

            return msg.sender;

        } else {

            return _getRelayedCallSender();

        }

    }



    /**

     * @dev Replacement for msg.data. Returns the actual calldata of a transaction: msg.data for regular transactions,

     * and a reduced version for GSN relayed calls (where msg.data contains additional information).

     *

     * IMPORTANT: Contracts derived from {GSNRecipient} should never use `msg.data`, and use {_msgData} instead.

     */

    function _msgData() internal view returns (bytes memory) {

        if (msg.sender != _relayHub) {

            return msg.data;

        } else {

            return _getRelayedCallData();

        }

    }



    // Base implementations for pre and post relayedCall: only RelayHub can invoke them, and data is forwarded to the

    // internal hook.



    /**

     * @dev See `IRelayRecipient.preRelayedCall`.

     *

     * This function should not be overriden directly, use `_preRelayedCall` instead.

     *

     * * Requirements:

     *

     * - the caller must be the `RelayHub` contract.

     */

    function preRelayedCall(bytes calldata context) external returns (bytes32) {

        require(msg.sender == getHubAddr(), "GSNRecipient: caller is not RelayHub");

        return _preRelayedCall(context);

    }



    /**

     * @dev See `IRelayRecipient.preRelayedCall`.

     *

     * Called by `GSNRecipient.preRelayedCall`, which asserts the caller is the `RelayHub` contract. Derived contracts

     * must implement this function with any relayed-call preprocessing they may wish to do.

     *

     */

    function _preRelayedCall(bytes memory context) internal returns (bytes32);



    /**

     * @dev See `IRelayRecipient.postRelayedCall`.

     *

     * This function should not be overriden directly, use `_postRelayedCall` instead.

     *

     * * Requirements:

     *

     * - the caller must be the `RelayHub` contract.

     */

    function postRelayedCall(bytes calldata context, bool success, uint256 actualCharge, bytes32 preRetVal) external {

        require(msg.sender == getHubAddr(), "GSNRecipient: caller is not RelayHub");

        _postRelayedCall(context, success, actualCharge, preRetVal);

    }



    /**

     * @dev See `IRelayRecipient.postRelayedCall`.

     *

     * Called by `GSNRecipient.postRelayedCall`, which asserts the caller is the `RelayHub` contract. Derived contracts

     * must implement this function with any relayed-call postprocessing they may wish to do.

     *

     */

    function _postRelayedCall(bytes memory context, bool success, uint256 actualCharge, bytes32 preRetVal) internal;



    /**

     * @dev Return this in acceptRelayedCall to proceed with the execution of a relayed call. Note that this contract

     * will be charged a fee by RelayHub

     */

    function _approveRelayedCall() internal pure returns (uint256, bytes memory) {

        return _approveRelayedCall("");

    }



    /**

     * @dev See `GSNRecipient._approveRelayedCall`.

     *

     * This overload forwards `context` to _preRelayedCall and _postRelayedCall.

     */

    function _approveRelayedCall(bytes memory context) internal pure returns (uint256, bytes memory) {

        return (RELAYED_CALL_ACCEPTED, context);

    }



    /**

     * @dev Return this in acceptRelayedCall to impede execution of a relayed call. No fees will be charged.

     */

    function _rejectRelayedCall(uint256 errorCode) internal pure returns (uint256, bytes memory) {

        return (RELAYED_CALL_REJECTED + errorCode, "");

    }



    /*

     * @dev Calculates how much RelayHub will charge a recipient for using `gas` at a `gasPrice`, given a relayer's

     * `serviceFee`.

     */

    function _computeCharge(uint256 gas, uint256 gasPrice, uint256 serviceFee) internal pure returns (uint256) {

        // The fee is expressed as a percentage. E.g. a value of 40 stands for a 40% fee, so the recipient will be

        // charged for 1.4 times the spent amount.

        return (gas * gasPrice * (100 + serviceFee)) / 100;

    }



    function _getRelayedCallSender() private pure returns (address payable result) {

        // We need to read 20 bytes (an address) located at array index msg.data.length - 20. In memory, the array

        // is prefixed with a 32-byte length value, so we first add 32 to get the memory read index. However, doing

        // so would leave the address in the upper 20 bytes of the 32-byte word, which is inconvenient and would

        // require bit shifting. We therefore subtract 12 from the read index so the address lands on the lower 20

        // bytes. This can always be done due to the 32-byte prefix.



        // The final memory read index is msg.data.length - 20 + 32 - 12 = msg.data.length. Using inline assembly is the

        // easiest/most-efficient way to perform this operation.



        // These fields are not accessible from assembly

        bytes memory array = msg.data;

        uint256 index = msg.data.length;



        // solhint-disable-next-line no-inline-assembly

        assembly {

            // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.

            result := and(mload(add(array, index)), 0xffffffffffffffffffffffffffffffffffffffff)

        }

        return result;

    }



    function _getRelayedCallData() private pure returns (bytes memory) {

        // RelayHub appends the sender address at the end of the calldata, so in order to retrieve the actual msg.data,

        // we must strip the last 20 bytes (length of an address type) from it.



        uint256 actualDataLength = msg.data.length - 20;

        bytes memory actualData = new bytes(actualDataLength);



        for (uint256 i = 0; i < actualDataLength; ++i) {

            actualData[i] = msg.data[i];

        }



        return actualData;

    }

}



// File: contracts/WinNgnt.sol



pragma solidity ^0.5.0;





















contract WinNgnt is GSNRecipient, usingProvable {

    using SafeMath for uint256;

    using SafeStringCast for string;



    IERC20 private _ngnt;

    IUniswapExchange private _uniswap;

    IRelayHub private _relayHub;

    uint public TOTAL_NGNT = 0;



    struct Game {

        uint gameNumber;

        address[] tickets;

        address gameWinner;

    }



    enum GSNErrorCodes {

        INSUFFICIENT_BALANCE, NOT_ALLOWED

    }



    uint public commission;

    uint public gameNumber = 1;

    uint public deadline = 1742680400;

    uint public ticketPrice = 50000;

    uint public minimumEther = 1 wei;

    uint public maximumPurchasableTickets = 250;

    uint public maximumTicketsPerAddress = 10;

    uint public oneEther = 1000000000000000000;

    uint public targetAmount = 1000000000000000000;



    bool public exchangeContractApproval;



    mapping(uint => Game) public games;

    mapping(address => uint) public addressTicketCount;

    mapping(uint => mapping(address => uint)) public addressTicketCountPerGame;

    mapping(address => bool) public addressHasPaidGsnFee;

    mapping(bytes32 => bool) public pendingQueries;



    //TODO: Remove event after thorough testing

    event Tickets(address[] tickets);



    event GameEnded(uint gameNumber);

    event BoughtTicket(address buyer, uint numOfTickets, uint totalTicketPrice);

    event LogNewProvableQuery(string description);

    event RandomNumberGenerated(uint16 randomNumber);

    event WinnerSelected(address winner, uint amount, uint gameNumber);







    modifier atLeastOneTicket(uint numberOfTickets){

        require(numberOfTickets >= 1, "Cannot buy less than one ticket");

        _;

    }



    modifier ticketLimitNotExceed(uint numberOfTickets){

        require((games[gameNumber].tickets.length + numberOfTickets) <= maximumPurchasableTickets, "Total ticket per game limit exceeded");

        _;

    }



    modifier maxTicketPerAddressLimitNotExceed(address _address, uint numberOfTickets){

        require((addressTicketCountPerGame[gameNumber][_address] + numberOfTickets) <= maximumTicketsPerAddress, "Maximum ticket limit per address exceeded");

        _;

    }



    modifier isCalledByAProvableCallbackAddress(address caller){

        require(caller == provable_cbAddress(), "Callback can only be called by a provable callback address");

        _;

    }



    modifier queryIdHasNotBeenProcessed(bytes32 queryId){

        require(pendingQueries[queryId] == true);

        _;

    }



    constructor(IERC20 ngnt, IUniswapExchange uniswap, IRelayHub relayHub, uint _maximumPurchasableTickets) public {

        GSNRecipient.initialize();

        _ngnt = ngnt;

        _uniswap = uniswap;

        _relayHub = relayHub;

        maximumPurchasableTickets = _maximumPurchasableTickets;

    }



    function buyTicket(uint numberOfTickets) atLeastOneTicket(numberOfTickets) ticketLimitNotExceed(numberOfTickets)

    maxTicketPerAddressLimitNotExceed(_msgSender(), numberOfTickets)

    external

    {

        uint totalTicketPrice = ticketPrice.mul(numberOfTickets);

        uint totalAddressTicketCount = addressTicketCount[_msgSender()];

        uint totalAddressTicketCountPerGame = addressTicketCountPerGame[gameNumber][_msgSender()];



        if (!addressHasPaidGsnFee[_msgSender()]) {

            uint gsnFee = _ngnt.gsnFee();

            if (gsnFee <= 0) {

                gsnFee = 5000;

            }



            totalTicketPrice = totalTicketPrice.sub(gsnFee);

            addressHasPaidGsnFee[_msgSender()] = true;

        }



        TOTAL_NGNT += totalTicketPrice;

        _ngnt.transferFrom(_msgSender(), address(this), totalTicketPrice);



        totalAddressTicketCount += numberOfTickets;

        totalAddressTicketCountPerGame += numberOfTickets;



        addressTicketCount[_msgSender()] = totalAddressTicketCount;

        addressTicketCountPerGame[gameNumber][_msgSender()] = totalAddressTicketCountPerGame;



        Game storage game = games[gameNumber];

        game.gameNumber = gameNumber;

        for (uint i = 0; i < numberOfTickets; i++) {

            game.tickets.push(_msgSender());

        }



        address[] memory tickets = game.tickets;

        emit BoughtTicket(_msgSender(), numberOfTickets, totalTicketPrice);

        emit Tickets(tickets);



        if (games[gameNumber].tickets.length == maximumPurchasableTickets) {

            if (gameNumber.mod(5) == 0) {

                swapNgntForEth();

                fundRecipient();

            }

            endGame();

        }

    }



    function numberOfTicketsLeft() external view returns (uint){

        Game storage game = games[gameNumber];

        uint ticketsBought = game.tickets.length;

        return maximumPurchasableTickets.sub(ticketsBought);

    }



    function numberOfTicketsPurchased() external view returns (uint){

        Game storage game = games[gameNumber];

        uint ticketsBought = game.tickets.length;

        return ticketsBought;

    }



    function getNgntAddress() external view returns (address){

        return address(_ngnt);

    }



    function __callback(bytes32 queryId, string memory _result) isCalledByAProvableCallbackAddress(_msgSender())

    queryIdHasNotBeenProcessed(queryId) public

    {

        if (games[gameNumber].tickets.length == maximumPurchasableTickets) {

            uint16 randomIndex = _result.toUint();

            emit RandomNumberGenerated(randomIndex);

            delete pendingQueries[queryId];



            sendNgntToWinner(randomIndex);

            resetGame();

        }

    }



    function generateRandomNumber() private {

        if (provable_getPrice("WolframAlpha") > address(this).balance) {

            emit LogNewProvableQuery("Provable query was NOT sent, please add some ETH to cover for the query fee");

        }

        else {

            uint lastIndex = 0;

            Game storage game = games[gameNumber];

            lastIndex = game.tickets.length - 1;



            bytes memory query;

            query = abi.encodePacked(SafeIntCast.toString(lastIndex));

            query = abi.encodePacked("random number between 0 and ", query);

            string memory provableQuery = string(query);



            emit LogNewProvableQuery("Provable query was sent, standing by for the answer...");

            bytes32 queryId = provable_query("WolframAlpha", provableQuery);

            pendingQueries[queryId] = true;

        }

    }



    function startNextGame() public {

        generateRandomNumber();

    }



    function sendNgntToWinner(uint randomIndex) private {

        Game storage game = games[gameNumber];

        address winner = game.tickets[randomIndex];

        game.gameWinner = winner;



        uint amountWon = TOTAL_NGNT.mul(90).div(100);

        commission += TOTAL_NGNT.sub(amountWon);

        _ngnt.transfer(winner, amountWon);



        emit WinnerSelected(winner, amountWon, gameNumber);

    }



    function swapNgntForEth() private {

        if (address(this).balance < oneEther) {

            if (!exchangeContractApproval) {

                _ngnt.approve(address(_uniswap), 100000000000);

                exchangeContractApproval = true;

            }



            uint tokenSold = commission;

            _uniswap.tokenToEthSwapInput(tokenSold, minimumEther, deadline);

            commission = 0;

        }

    }



    function fundRecipient() private {

        uint relayBalance = _relayHub.balanceOf(address(this));

        if (relayBalance < targetAmount) {

            uint amountDifference = targetAmount.sub(relayBalance);

            if (address(this).balance > amountDifference) {

                _relayHub.depositFor.value(amountDifference)(address(this));

            } else {

                _relayHub.depositFor.value(address(this).balance)(address(this));

            }

        }

    }



    function resetGame() private {

        gameNumber++;

        TOTAL_NGNT = 0;

    }



    function endGame() private {

        emit GameEnded(gameNumber);

        generateRandomNumber();

    }



    function acceptRelayedCall(

        address relay,

        address from,

        bytes calldata encodedFunction,

        uint256 transactionFee,

        uint256 gasPrice,

        uint256 gasLimit,

        uint256 nonce,

        bytes calldata approvalData,

        uint256 maxPossibleCharge

    ) external view returns (uint256, bytes memory) {

        bytes4 calldataSelector = LibBytes.readBytes4(encodedFunction, 0);

        if (calldataSelector == this.buyTicket.selector) {

            return _approveRelayedCall();

        } else {

            return _rejectRelayedCall(uint256(GSNErrorCodes.NOT_ALLOWED));

        }

    }



    function _preRelayedCall(bytes memory context) internal returns (bytes32) {

    }



    function _postRelayedCall(bytes memory context, bool, uint256 actualCharge, bytes32) internal {

    }



    function() external payable {

    }

}

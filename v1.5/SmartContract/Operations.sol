pragma solidity ^0.5.1;
contract Operations {
    function copyBytesNToBytes(bytes32 source, bytes memory destination, uint[1] memory pointer) internal pure {
        for (uint i=0; i < 32; i++) {
            if (source[i] == 0)
                break;
            else {
                destination[pointer[0]]=source[i];
                pointer[0]++;
            }
        }
    }
    function copyBytesToBytes(bytes memory source, bytes memory destination, uint[1] memory pointer) internal pure {
        for (uint i=0; i < source.length; i++) {
            destination[pointer[0]]=source[i];
            pointer[0]++;
        }
    }
    function uintToBytesN(uint v) internal pure returns (bytes32 ret) {
        if (v == 0) {
            ret = '0';
        }
        else {
            while (v > 0) {
//                ret = bytes32(uint(ret) / (2 ** 8));
//                ret |= bytes32(((v % 10) + 48) * 2 ** (8 * 31));
                ret = bytes32(uint(ret) >> 8);
                ret |= bytes32(((v % 10) + 48) << (8 * 31));
                v /= 10;
            }
        }
        return ret;
    }
    function stringToBytes32(string memory str) internal pure returns(bytes32) {
        bytes32 bStrN;
        assembly {
            bStrN := mload(add(str, 32))
        }
        return(bStrN);
    }
}

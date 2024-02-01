// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract OctopusCenter {

    bytes32 immutable PREFIX;
    event MessageEmit(bytes32 message);
    mapping(bytes32=>address) OctopusDictionary;

    constructor(bytes32 _prefix){
        PREFIX = _prefix;
    }

    function registerMessage(bytes32 randomBytes) public returns(bytes32) {
        bytes32 signingTarget = keccak256(abi.encode(
            PREFIX,
            msg.sender,
            randomBytes));
        OctopusDictionary[signingTarget]=msg.sender;
        return signingTarget;
    }

    function emitMessage(bytes32 signingTarget) public returns(bool){
        require(OctopusDictionary[signingTarget]==msg.sender,"invalid msg.sender");
        emit MessageEmit(signingTarget);
        return true;

    }    

}
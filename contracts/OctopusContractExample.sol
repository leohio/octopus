pragma solidity ^0.8.9;
import "./OctopusCenter.sol";

//Timelock encryption
contract OctopusContractExample {

    bytes32 immutable signatureTargetMessage;
    uint256 immutable targetBlockNum;
    OctopusCenter octopusCenter;

    constructor(bytes32 randomBytes, address octopusCenterAddress, uint256 _targetBlockNum){

        octopusCenter= OctopusCenter(octopusCenterAddress);
        signatureTargetMessage = octopusCenter.registerMessage(randomBytes);
        targetBlockNum = _targetBlockNum;
    }
    
    function decrypt() public{
        require(block.number>targetBlockNum);
        octopusCenter.emitMessage(signatureTargetMessage);
    }
}
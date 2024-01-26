pragma solidity ^0.8.9;
import "./OctopusCenter.sol";
import "hardhat/console.sol";


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
        console.log("Current block number:", block.number,"target:", targetBlockNum);
        require(block.number > targetBlockNum, "Can't decrypt");
        octopusCenter.emitMessage(signatureTargetMessage);
    }
}
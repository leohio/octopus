pragma solidity ^0.8.9;
import "../OctopusCenter.sol";
import "hardhat/console.sol";


//Timelock encryption
contract GovernanceOfSecretAdvanced {

    OctopusCenter octopusCenter;

    struct ThresholdInfo{
        int8 numberOfSingners;
        int8 signerLimit;
        int8 thresholdPercentage; //if it's 50, it means 50%
    }

    ThresholdInfo thresInfo;
    mapping (address=>bool) signerList;
    mapping (bytes32=>int8) approvalList;
    mapping (bytes32=>bool) doubleVotePrevention;
    event registeredMessage(bytes32 message);

    constructor(address octopusCenterAddress,int8 _signerLimit, int8 _thresholdPercentage){
        octopusCenter=OctopusCenter(octopusCenterAddress);
        thresInfo.signerLimit = _signerLimit;
        thresInfo.thresholdPercentage = _thresholdPercentage;
        signerList[msg.sender]=true;
    }

    function setSigner(address newSigner) public returns (bool){
        require(thresInfo.numberOfSingners<thresInfo.signerLimit, "signerLimit exceeded");
        require(signerList[msg.sender], "msg.sender is not in signerList");
        signerList[newSigner] = true;
        thresInfo.numberOfSingners++;
    }
    function approveDecryption(bytes32 signatureTargetMessage) public{
        require(signerList[msg.sender], "msg.sender is not in signerList");
        bytes32 ticket = keccak256(abi.encode(signatureTargetMessage,msg.sender));
        require(!doubleVotePrevention[ticket]);
        doubleVotePrevention[ticket]=true;
        approvalList[signatureTargetMessage]++;
     }

    function registerMessage(bytes32 randomBytes) public{
        bytes32 signatureTargetMessage = octopusCenter.registerMessage(randomBytes);
        emit registeredMessage(signatureTargetMessage);
    }
    
    function decryptByGovernance(bytes32 signatureTargetMessage) public{
        
        require(
            approvalList[signatureTargetMessage]*100 > thresInfo.numberOfSingners*thresInfo.thresholdPercentage
        , "Can't decrypt"
        );

        octopusCenter.emitMessage(signatureTargetMessage);
    }
}
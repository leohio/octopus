pragma solidity ^0.8.9;
import "../OctopusCenter.sol";
import "hardhat/console.sol";


//Governance of decryption with 3 people.
contract GovernanceOfSecret {

    OctopusCenter octopusCenter;
    mapping(address=>bool) signers;
    mapping (bytes32=>int8) approvalList;
    mapping (bytes32=>bool) doubleVotePrevention;
    event registeredMessage(bytes32 message);

    constructor(address octopusCenterAddress, address[3] memory _signers){
        octopusCenter=OctopusCenter(octopusCenterAddress);
        for (uint8 i=0;i<3;i++){
             signers[_signers[i]]=true;
        }
    }
    
    function registerMessage(bytes32 randomBytes) public{
        bytes32 signatureTargetMessage = octopusCenter.registerMessage(randomBytes);
        emit registeredMessage(signatureTargetMessage);
        //for test
        testStorage = signatureTargetMessage;
    }

     function approveDecryption(bytes32 signatureTargetMessage) public{
        require(signers[msg.sender], "msg.sender is not in signerList");
        bytes32 ticket = keccak256(abi.encode(signatureTargetMessage,msg.sender));
        require(!doubleVotePrevention[ticket]);
        doubleVotePrevention[ticket]=true;
        approvalList[signatureTargetMessage]++;
     }
    
    function decryptByGovernance(bytes32 signatureTargetMessage) public{
        require(approvalList[signatureTargetMessage]==3, "Can't decrypt");
        octopusCenter.emitMessage(signatureTargetMessage);
    }

    //for test
    bytes32 testStorage;
    function _test_approveDecryption() public {
        approveDecryption(testStorage);
    }

    function _test_decryptByGovernance() public{
        decryptByGovernance(testStorage);
    }

}
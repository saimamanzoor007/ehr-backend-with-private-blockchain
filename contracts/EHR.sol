pragma solidity ^0.8.0;

contract EHR {
    struct Record {
        string ipfsFileHash; // Store the IPFS file hash
        uint256 timestamp;
        string medicalRecordId; // Store the medical record ID
    }

    mapping(string => Record) private recordByMedicalRecordId; // Mapping to retrieve a record by medicalRecordId

    // Function to add a record using IPFS file hash and medical record ID
    function addRecord(string memory ipfsFileHash, string memory medicalRecordId) public {
        Record memory newRecord = Record(ipfsFileHash, block.timestamp, medicalRecordId);

        recordByMedicalRecordId[medicalRecordId] = newRecord; // Store the record by medicalRecordId
    }

    // Function to get a record by medicalRecordId
    function getRecordByMedicalRecordId(string memory medicalRecordId) public view returns (Record memory) {
        require(bytes(recordByMedicalRecordId[medicalRecordId].ipfsFileHash).length != 0, "Record not found");
        return recordByMedicalRecordId[medicalRecordId];
    }
}
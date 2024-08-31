
const { Web3 } = require('web3')
const contractDetails = require('../build/contracts/EHR.json');

// Connect to your Quorum node
const web3 = new Web3(new Web3.providers.HttpProvider(process.env.QUORUM_NODE_URL))

const contractAddress = process.env.CONTRACT_ADDRESS;
const contract = new web3.eth.Contract(contractDetails.abi, contractAddress);

async function getContractAccount() {
    const accounts = await web3.eth.getAccounts();
    return accounts[0]
}

const addRecordToBlockChain = async (ipfsFileHash, medicalRecordId) => {
    try {
        const account = await getContractAccount()

        const gasEstimate = await contract.methods.addRecord(ipfsFileHash, medicalRecordId).estimateGas({ from: account });
        console.log(`Estimated gas for adding record: ${gasEstimate}`);

        const receipt = await contract.methods.addRecord(ipfsFileHash, medicalRecordId).send({ from: account, gas: gasEstimate, gasPrice: '0' });
        console.log(receipt)
    } catch (error) {
        console.error("Error occurred:", error.message);
    }
};

const getBlockChainRecord = async (medicalRecordId) => {
    try {
        const account = await getContractAccount()

        const gasEstimate = await contract.methods.getRecordByMedicalRecordId(medicalRecordId).estimateGas({ from: account });
        console.log(`Estimated gas for viewing record: ${gasEstimate}`);
        const record = await contract.methods.getRecordByMedicalRecordId(medicalRecordId).call();
        console.log("Retrieved record:", record);
        return record
    } catch (error) {
        console.error("Error occurred:", error.message);
    }
};

module.exports = {
    addRecordToBlockChain,
    getBlockChainRecord
}
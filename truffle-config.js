const HDWalletProvider = require('@truffle/hdwallet-provider');
require('dotenv').config();

module.exports = {
  networks: {
    quorum: {
      provider: () => new HDWalletProvider({
        mnemonic: process.env.MNEMONIC,
        providerOrUrl: process.env.QUORUM_NODE_URL,
        numberOfAddresses: 1,
      }),
      network_id: '*', // Match any network id
      gas: 2000000,
      gasPrice: 0,
    },
  },
  compilers: {
    solc: {
      version: "0.8.19", // Specify your Solidity compiler version
    },
  },
};

import { HardhatUserConfig } from "hardhat/config";
import "@nomiclabs/hardhat-ethers"

import { config as dotEnvConfig } from "dotenv";
dotEnvConfig();

const mnemonic = process.env.MNEMONIC;
const chainIds = {
  ganache: 5777,
  goerli: 5,
  hardhat: 7545,
  kovan: 42,
  mainnet: 1,
  rinkeby: 4,
  bscTestnet: 97,
  bscMainnet: 56,
  MaticTestnet: 80001,
  MaticMainnet: 137,
  ropsten: 3,
};

const config: HardhatUserConfig = {
  networks: {
    hardhat: {
      accounts: {
        mnemonic,
      },
      forking: {
        // eslint-disable-next-line
        enabled: true,
        url: "https://bsc-dataseed.binance.org/",
      },
      chainId: 56,
      // allowUnlimitedContractSize: true
    },
    ganache: {
      chainId: 5777,
      url: "http://127.0.0.1:7545/",
    },
    bscTestnet: {
      accounts: {
        initialIndex: 0,
        mnemonic,
        // path: "m/44'/60'/0'/0",
      },
      chainId: chainIds["bscTestnet"],
      url: "https://data-seed-prebsc-1-s1.binance.org:8545",
    },
    bscMainnet: {
      accounts: {
        initialIndex: 0,
        mnemonic,
        // path: "m/44'/60'/0'/0",
      },
      chainId: chainIds["bscMainnet"],
      url: "https://bsc-dataseed.binance.org/",
    },
    MaticMainnet: {
      accounts: {
        initialIndex: 0,
        mnemonic,
        // path: "m/44'/60'/0'/0",
      },
      chainId: chainIds["MaticMainnet"],
      allowUnlimitedContractSize: true,
      url: "https://rpc-mainnet.maticvigil.com/",
    },
  },
  solidity: {
    compilers: [
      {
        version: "0.8.20",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
  },
  mocha: {
    timeout: 400000,
  },
};

export default config;

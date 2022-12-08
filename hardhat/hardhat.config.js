require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config({ path: ".env" });
require("@nomiclabs/hardhat-etherscan");

  const ALCHEMY_URL = process.env.ALCHEMY_URL;
  const MUMBAI_PRIVATE_KEY = process.env.MUMBAI_PRIVATE_KEY;
  const POLYGON_API_KEY = "Y4S2NZATJQ8EKE3NRFEM7YC745X7TYGDS1";

module.exports = {
  solidity: "0.8.17",
  networks: {
    mumbai: {
      url: ALCHEMY_URL,
      accounts: [MUMBAI_PRIVATE_KEY],
    },
  },
  etherscan: {
    apiKey: {
      polygonMumbai: POLYGON_API_KEY
    },
  },
};
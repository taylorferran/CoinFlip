const { ethers } = require("hardhat");
require("dotenv").config({ path: ".env" });
require("@nomiclabs/hardhat-etherscan");
const { FEE, VRF_COORDINATOR, LINK_TOKEN, KEY_HASH } = require("../constants");

async function main() {
/*
  const coinFlip = await ethers.getContractFactory("CoinFlip");
  // deploy the contract
  const deployedCoinFlipContract = await coinFlip.deploy(
    VRF_COORDINATOR,
    LINK_TOKEN,
    KEY_HASH,
    FEE
  );

  await deployedCoinFlipContract.deployed();

  // print the address of the deployed contract
  console.log(
    "Verify Contract Address:",
    deployedCoinFlipContract.address
  );

  console.log("wait for verification:");
  // Wait for etherscan to notice that the contract has been deployed
  await sleep(60000);

*/
  // Verify the contract after deploying
  await hre.run("verify:verify", {
    address: "0x3Ec9129cB224de198f5052821dE110Db40E0Fe87",
    //constructorArguments: [VRF_COORDINATOR, LINK_TOKEN, KEY_HASH, FEE],
  });
}

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

// Call the main function and catch if there is any error
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
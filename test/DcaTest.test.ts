import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import "@nomicfoundation/hardhat-chai-matchers";
import { ethers } from "hardhat";

// Import BigNumber if necessary
// import { BigNumber } from "ethers";

describe.only("Tests for FACTORY DCA", () => {
  let owner: SignerWithAddress;

  let token: any;
  const forkChainId: any = process.env.FORK_CHAINID;

  describe("Tests for DCA contract", async () => {
    const DCA = await ethers.getContractFactory("DCA");
    const dca = await DCA.deploy();
    await dca.deployed();


    describe("priceOracle Contract", function () {
      // Add your tests here
    });
  });
});

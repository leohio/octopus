const { expect } = require("chai");
const { ethers } = require("hardhat");
const { utils } = require("web3");

describe("GovernanceOfSecret", function () {
  let octopusExample;
  let octopusCenter;
  let owner,addr1,addr2;
  let gos;

  it("Governance of Secret with 3 people",async function () {
    const OctopusCenter = await ethers.getContractFactory("OctopusCenter");
    const random32bytes1 = utils.randomHex(32);
    octopusCenter = await OctopusCenter.deploy(random32bytes1);
    await octopusCenter.waitForDeployment();
    console.log("OC", octopusCenter.target);

    const random32bytes2 = utils.randomHex(32);
    const [owner,addr1,addr2] = await ethers.getSigners();

    const GovernanceOfSecret = await ethers.getContractFactory(
      "GovernanceOfSecret"
    );
    gos = await ethers.deployContract("GovernanceOfSecret",
      [octopusCenter.target,
      [owner.address,addr1.address,addr2.address]],[owner,addr1,addr2]// set target block number to some value
    );
    await gos.waitForDeployment();
  //});

  //it("Governance of Secret with 3 people", async function () {
    let random32bytes3 = utils.randomHex(32);
    await gos.registerMessage(random32bytes3);
    await gos._test_approveDecryption();
    await gos.connect(addr1)._test_approveDecryption();
    await gos.connect(addr2)._test_approveDecryption();
    await gos._test_decryptByGovernance();

    // Check if the MessageEmit event was emitted
    const filter = octopusCenter.filters.MessageEmit();
    const events = await octopusCenter.queryFilter(filter);
    expect(events.length).to.equal(1);
    console.log("GovernanceOfSecret : fine");
  });
});

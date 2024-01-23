const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('OctopusContractExample', function () {
  let octopusExample;
  let octopusCenter;

  beforeEach(async function () {
    const OctopusCenter = await ethers.getContractFactory('OctopusCenter');
    octopusCenter = await OctopusCenter.deploy('0x');
    await octopusCenter.deployed();

    const OctopusContractExample = await ethers.getContractFactory('OctopusContractExample');
    octopusExample = await OctopusContractExample.deploy(
      ethers.utils.randomBytes(32),
      octopusCenter.address,
      1000 // set target block number to some value
    );
    await octopusExample.deployed();
  });

  it('should decrypt the message after the target block number', async function () {
    // Advance to the target block number
    await ethers.provider.send('evm_mine', [1000]);

    // Call the decrypt function
    await octopusExample.decrypt();

    // Check if the MessageEmit event was emitted
    const filter = octopusCenter.filters.MessageEmit();
    const events = await octopusCenter.queryFilter(filter);
    expect(events.length).to.equal(1);
  });
});

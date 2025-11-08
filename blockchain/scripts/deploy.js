async function main() {
  const DigitalIdentity = await ethers.getContractFactory("DigitalIdentity");
  const contract = await DigitalIdentity.deploy();
  await contract.waitForDeployment();
  const address = await contract.getAddress();
  console.log("✅ DigitalIdentity deployed at:", address);
}

main().catch((err) => {
  console.error(err);
  process.exitCode = 1;
});

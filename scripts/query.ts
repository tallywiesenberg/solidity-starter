import '@nomiclabs/hardhat-ethers'
import { ethers } from 'hardhat'
import config from "../hardhat.config"

async function main() {

  const rinkeby_address = "0x2c4f9a14921da8d03a904ac299c93bdcdc33ffcb"

  const rinkeby_contract = new ethers.Contract()

  // If we had constructor arguments, they would be passed into deploy()
  const contract = await factory.deploy("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266")

  // The address the Contract WILL have once mined
  console.log(contract.address)

  // The address of the team (owner) of the contract
  console.log("team address: ", "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266")

  // The transaction that was sent to the network to deploy the Contract
  console.log(contract.deployTransaction.hash)

  // The contract is NOT deployed yet; we must wait until it is mined
  await contract.deployed()
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })

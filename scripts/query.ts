import '@nomiclabs/hardhat-ethers'
import { BigNumber } from 'ethers'
import { ethers } from 'hardhat'
import config from "../hardhat.config"

async function main() {

  const address = "0x87C3A5EBD6311C476B8049D54244bc69c3524e6e"
  const provider = await ethers.provider

  const contract = new ethers.Contract(
    address,
    [
      "function totalPoolAmount() public view returns (uint256)",
      "function team() public view returns (address)",
    ],
    provider
  )

  const eth_bal = await contract.totalPoolAmount()

  const team_addr = await contract.team()

  console.log("total eth amount in pool:", eth_bal / 1E18)
  console.log("team address:", team_addr )
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })

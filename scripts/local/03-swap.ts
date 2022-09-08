import { ethers } from "hardhat";
import { NEW_FUND_ADDRESS } from "./constants";

const WETH9_mainnet = '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2';
const WETH9_rinkeby = '0xc778417E063141139Fce010982780140Aa0cD5Ab';
const depositAmount = 8000000000000000;

async function main() {

  const [owner, otherAccount] = await ethers.getSigners();
  console.log(NEW_FUND_ADDRESS);

  // swap call parameter (array length 1)

  // swap WETH -> UNI


  // swap call parameter (array length >1)

  // swap WETH -> UNI





  console.log("\n------------------------------------------------------------------------\n");  
  // swap ETH -> WETH9
  const WETH9 = await ethers.getContractAt("IWETH", WETH9_mainnet);
  await WETH9.deposit({
            from: owner.address,
            value: depositAmount
        });
  console.log("ETH -> WETH : ", depositAmount);
  const balancePromise = owner.getBalance();
  balancePromise.then((balance) => {
      console.log("ETH : ", balance);
  });
  const WETH = await ethers.getContractAt("@openzeppelin/contracts/token/ERC20/IERC20.sol:IERC20", WETH9_mainnet);
  console.log("WETH : ", await WETH.balanceOf(owner.address));
  
  console.log("\n------------------------------------------------------------------------\n");
  // approve
  await WETH.approve(NEW_FUND_ADDRESS, depositAmount);
  console.log("Approved");
  console.log("address :", NEW_FUND_ADDRESS);
  console.log("amount :", depositAmount);

  console.log("\n------------------------------------------------------------------------\n");
  // (WETH) wallet -> new fund contract

  const newFund = await ethers.getContractAt("XXXFund", NEW_FUND_ADDRESS);
  await newFund.deposit(owner.address, WETH9_mainnet, depositAmount);

  console.log("Deposit()");
  console.log("Fund address : ", NEW_FUND_ADDRESS);
  console.log("investor : ", owner.address);
  console.log("token : ", WETH9_mainnet);
  console.log("amount : ", depositAmount);
  console.log("New Fund's WETH balance : ", await WETH.balanceOf(NEW_FUND_ADDRESS));


  console.log("\n------------------------------------------------------------------------\n");

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

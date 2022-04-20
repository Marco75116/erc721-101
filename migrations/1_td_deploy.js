const Str = require("@supercharge/strings");
// const BigNumber = require('bignumber.js');

var TDErc20 = artifacts.require("ERC20TD.sol");
var evaluator = artifacts.require("Evaluator.sol");
var evaluator2 = artifacts.require("Evaluator2.sol");
var exsolutions = artifacts.require("ExerciceSolution.sol");

module.exports = (deployer, network, accounts) => {
  deployer.then(async () => {
    await deployTDToken(deployer, network, accounts);
    await deployEvaluator(deployer, network, accounts);
    await doTD(deployer, network, accounts);
  });
};

async function deployTDToken(deployer, network, accounts) {
  TDToken = await TDErc20.at("0x8B7441Cb0449c71B09B96199cCE660635dE49A1D");
}

async function deployEvaluator(deployer, network, accounts) {
  Evaluator = await evaluator.at("0xa0b9f62A0dC5cCc21cfB71BA70070C3E1C66510E");
  Evaluator2 = await evaluator2.at(
    "0x4f82f7A130821F61931C7675A40fab723b70d1B8"
  );
}
account = "0x88E95624f03251970501Da6e3fA6f93F93B06890";
async function deployerSolution(deployer, network, accounts) {
  ExerciceSolution = await exsolutions.new("MYNFT", "MFT", Evaluator.address, {
    from: account,
  });
  console.log("ExerciceSolution " + ExerciceSolution.address);
}
async function getBalance(account, network, accounts) {
  let balance = await TDToken.balanceOf(account);
  console.log("Balance " + balance);
}
async function doTD(deployer, network, accounts) {
  console.log("start td");
  await getBalance(account, network, accounts);
  await deployerSolution(deployer, network, accounts, { from: account });

  // console.log("------Exercice1------");
  await Evaluator.submitExercice(ExerciceSolution.address, { from: account });
  // await Evaluator.ex1_testERC721({ from: account });
  // await getBalance(account, network, accounts);

  // console.log("------Exercice2------");
  // await Evaluator.ex2a_getAnimalToCreateAttributes({ from: account });
  // _name = await Evaluator.readName(account);
  // _wings = await Evaluator.readWings(account);
  // _legs = await Evaluator.readLegs(account);
  // _sex = await Evaluator.readSex(account);
  // await ExerciceSolution.declareAnimal(_sex, _legs, _wings, _name, {
  //   from: account,
  // });

  // console.log(await ExerciceSolution.ownerOf(2));
  // await Evaluator.ex2b_testDeclaredAnimal(2, { from: account });
  // await getBalance(account, network, accounts);

  // console.log("------Exercice3------");
  // await Evaluator.ex3_testRegisterBreeder({ from: account });
  // await getBalance(account, network, accounts);

  // console.log("------Exercice4------");
  // await Evaluator.ex4_testDeclareAnimal({ from: account });
  // await getBalance(account, network, accounts);

  // console.log("------Exercice5------");
  // await ExerciceSolution.mint(account, { from: account });
  // await Evaluator.ex5_declareDeadAnimal({ from: account });
  // await getBalance(account, network, accounts);

  // console.log("------Exercice6a------");
  // await Evaluator.ex6a_auctionAnimal_offer({ from: account });
  // await getBalance(account, network, accounts);

  console.log("------Exercice6b------");
  await ExerciceSolution.mint(account, { from: account });
  await ExerciceSolution.offerForSale(2, "100", { from: account });
  await Evaluator.ex6b_auctionAnimal_buy(2, { from: account });
  await getBalance(account, network, accounts);
}

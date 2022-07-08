const MultisigWallet = artifacts.require("MultisigWallet.sol");

// module.exports = (deployer, network, accounts) => {
//     const _owners = [accounts[0], accounts[1], accounts[2]]
//     const _limit = 2
    
//     deployer.deploy(MultisigWallet, _owners, _limit)
//   }

  module.exports = (deployer,  accounts) => {
    const owners1 = accounts[0]
    const owners2 = accounts[1]
    const owners3 = accounts[2]
    const limit = 2
    deployer.deploy(owners1, owners2, owners3, limit)
  }
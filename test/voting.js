const { accounts, contract } = require('@openzeppelin/test-environment');

const {
    BN,           // Big Number support
    constants,    // Common constants, like the zero address and largest integers
    expectEvent,  // Assertions for emitted events
    expectRevert, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

const SmartToken = artifacts.require('SmartToken');

describe('ERC20', function () {
    const [sender, receiver] =  accounts;

    beforeEach(async () => {
      // The bundled BN library is the same one web3 uses under the hood
        this.value = new BN(1);
        this.erc20 = await SmartToken.new(sender,{ from: sender });
    });

  
  });
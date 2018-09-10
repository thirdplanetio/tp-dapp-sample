# ThirdPlanet Demo dApp Let's Meet

Sample dApp front end using the [Drizzle Framework](https://truffleframework.com/docs/drizzle/overview).

# Prerequisites

* npm

      npm install -g truffle
      npm install -g ganache-cli

      npm config set prefix ~/bin
      export PATH=./node_modules/.bin:~/bin:~/.local/bin:~/node/bin:$HOME/.gem/ruby/2.3.0/bin:~/usr/bin:$PATH

# Dev Setup

# General Development Workflow

## Start ganache

This is a local Ethereum client node.

    # get the latest gas limit and price values from https://ethstats.net/
    $ ganache-cli --verbose --gasLimit=8000000 --gasPrice=6000000000 --block=3

## Truffle console

    $ truffle console
    truffle(development> compile
    truffle(development> test
    truffle(development> migrate

### Contract interaction samples

    truffle(development> LetsMeet.deployed().then(function(instance){return instance.newProposal.call("what", "when");}).then(function(value){return value.toNumber()});
    truffle(development> LetsMeet.deployed().then(function(instance){return instance.getProposalCount.call();}).then(function(value){return value.toNumber()});

## Start front end

The following should open your web browser to http://localhost:3000/

    $ npm run start

# Typical Steps when....

## Modifying a Contract

    truffle(development)> test
    truffle(development)> migrate

Browser should refresh automatically.

## Updating css/js

Browser should refresh automatically.

## Troubleshooting

* Error: Attempting to run transaction which calls a contract function

  * stop ganache (CTRL-c)
  * stop truffle (CTRL-d)
  * `rm -fr build`
  * start ganache, truffle

* Error: Out of Gas

  * increase `gas` in `<ContractForm ... sendArgs={{gas: 200000, gasPrice: '8000000000'}/>`
  * or possible need to increase `gasPrice` if it is less than the `gas` setting for `ganache`

# References

* [web3.js v1.0.0-beta.34](https://github.com/ethereum/web3.js/tree/v1.0.0-beta.34)
* [React Web3](https://www.npmjs.com/package/react-web3)
* [Solidity v0.4.24](https://solidity.readthedocs.io/en/v0.4.24)
* [Ethereum Stats](https://ethstats.net/)
* [Where does drizzle get its default gas value from](https://www.reddit.com/r/ethdev/comments/94dkgc/where_does_drizzle_get_its_default_gas_value_from/)
* [Drizzle](https://truffleframework.com/docs/drizzle/overview)

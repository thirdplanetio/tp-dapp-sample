# ThirdPlanet Demo dApp Let's Meet

Author: [Fairiz Azizi](https://github.com/coderfi)

Sample Ethereum dApp [reactjs](https://reactjs.org/) front end using the [Drizzle Framework](https://truffleframework.com/docs/drizzle/overview).

This tutorial will:

* install necessary prerequisites on an Ubuntu/Debian system
* install Ethereum development tools: `ganache-cli` and `truffle`
* start a private Ethereum dev node using `ganache-cli`
* deploy the project to the dev test environment
* demonstrate iterative development

# Prerequisites

Note: You may also consider [tp-eth-hello](https://github.com/thirdplanetio/tp-eth-hello), which will guide you in setting up your development environment.

## npm

Follow the [installation instructions](https://www.npmjs.com/get-npm) for your OS.

Then, for best practice purposes, update your `node` global installation prefix

    $ npm config set prefix ~/node
    $ export PATH=./node_modules/.bin:~/node/bin:$PATH
    $ echo './node_modules/.bin:~/node/bin:$PATH' >> ~/.bashrc

## ethereum tools      

    $ npm install -g truffle
    $ npm install -g ganache-cli

## Check versions

    $ truffle version
    Truffle v4.1.14 (core: 4.1.14)
    Solidity v0.4.24 (solc-js)

    $ ganache-cli --version
    Ganache CLI v6.1.8 (ganache-core: 2.2.1)

    $ npm --version
    5.6.0

# Project Repository Notes

This project was initialized with the following command:

    $ truffle unbox drizzle

It was then simplified and customized for the purpose of this tutorial.

For more information, see: https://truffleframework.com/boxes/drizzle

# Typical Development Workflow

## Install `nodejs` dependencies

The following command will install nodejs packages into the `node_modules/` subdirectory.

These packages are defined as dependencies in the `package.json` file.

    $ npm install .
    ...
    added 1590 packages from 1205 contributors and audited 287133 packages in 72.965s

## Start ganache

Start your local Ethereum client node.

    $ ganache-cli --verbose --gasLimit=8000000 --gasPrice=6000000000

Note: Get the latest gas limit and price values from https://ethstats.net/ This will ensure that your contracts are tested with realistic gas cost expectations.

## Truffle console

    $ truffle console
    $ truffle(development> compile
    $ truffle(development> test
    $ truffle(development> migrate

    Using network 'development'.

    Compiling ./contracts/LetsMeet.sol...
    ...

    TestLetsMeet
    ...
    6 passing (1s)

    ...
    Using network 'development'.
    Deploying Migrations...
    Deploying LetsMeet...
    ...

The LetsMeet smart contract is now live!

### Contract interaction samples

You can run the following commands from the `truffle console` to interact with the smart contract.

    $ truffle(development> LetsMeet.deployed().then(function(instance){return instance.newProposal.call("what", "when");}).then(function(value){return value.toNumber()});
    1

    $ truffle(development> LetsMeet.deployed().then(function(instance){return instance.getProposalCount.call();}).then(function(value){return value.toNumber()});
    0

## Start front end webserver

The following should open your web browser to http://localhost:3000/

    $ npm run start

# Dev Tips

## Modifying a Contract

After modifying `contracts/*.sol`:

    $ truffle(development)> test
    $ truffle(development)> migrate

Browser should refresh automatically.

## Updating css/js

After modifying the frontend resources in `src/`, there is no need to
restart the front end webserver.

The browser should refresh automatically.

Try removing some of the `<div/>` sections from `src/layouts/home/Home.js` to see this happening, live in your browser!

## Conclusion

The above walked us through iterative development
of a [Drizzle Framework](https://truffleframework.com/docs/drizzle/overview) dApp.

I hope you learned a few tricks and become the next best dApp developer!

# Troubleshooting

* Error: Attempting to run transaction which calls a contract function

  * stop ganache (`CTRL-c`)
  * stop truffle (`CTRL-d`)
  * `rm -fr build`
  * start ganache, truffle

* Error: Out of Gas

  * increase `gas` in `<ContractForm ... sendArgs={{gas: 200000, gasPrice: '8000000000'}/>`
  * or possible need to increase `gasPrice` if it is less than the `gas` setting for `ganache`

# TODO

* update UI to invoke voting methods

* update UI to show counter proposals

* update UI to show best proposal

* add voting deadline capability

# References

* [tp-eth-hello](https://github.com/thirdplanetio/tp-eth-hello) Ethereum HelloWorld smart contract tutorial
* [web3.js v1.0.0-beta.34](https://github.com/ethereum/web3.js/tree/v1.0.0-beta.34)
* [React Web3](https://www.npmjs.com/package/react-web3)
* [Solidity v0.4.24](https://solidity.readthedocs.io/en/v0.4.24)
* [Ethereum Stats](https://ethstats.net/)
* [Drizzle](https://truffleframework.com/docs/drizzle/overview)
* [Where does drizzle get its default gas value from](https://www.reddit.com/r/ethdev/comments/94dkgc/where_does_drizzle_get_its_default_gas_value_from/)

# ThirdPlanet Demo dApp Let's Meet

Sample dApp front end using the [Drizzle Framework](https://truffleframework.com/docs/drizzle/overview).

# Prerequisites

## npm

Follow [installation instructions](https://www.npmjs.com/get-npm) for your OS.

Then, for best practice purposes, update your `node` global installation prefix

      npm config set prefix ~/node
      export PATH=./node_modules/.bin:~/node/bin:$PATH

      echo './node_modules/.bin:~/node/bin:$PATH' >> ~/.bashrc

## ethereum tools      

      npm install -g truffle
      npm install -g ganache-cli

## Check versions

    $ truffle version
    Truffle v4.1.13 (core: 4.1.13)
    Solidity v0.4.24 (solc-js)

    $ ganache-cli --version
    Ganache CLI v6.1.7 (ganache-core: 2.2.0)

    $ npm --version
    5.6.0

# Typical Development Workflow

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

## Start front end webserver

The following should open your web browser to http://localhost:3000/

    $ npm run start

# Dev Tips

## Modifying a Contract

After modifying `contracts/*.sol`:

    truffle(development)> test
    truffle(development)> migrate

Browser should refresh automatically.

## Updating css/js

After modifying the frontend resources in `src/`, there is no need to
restart the front end webserver.

The browser should refresh automatically.

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

* [web3.js v1.0.0-beta.34](https://github.com/ethereum/web3.js/tree/v1.0.0-beta.34)
* [React Web3](https://www.npmjs.com/package/react-web3)
* [Solidity v0.4.24](https://solidity.readthedocs.io/en/v0.4.24)
* [Ethereum Stats](https://ethstats.net/)
* [Where does drizzle get its default gas value from](https://www.reddit.com/r/ethdev/comments/94dkgc/where_does_drizzle_get_its_default_gas_value_from/)
* [Drizzle](https://truffleframework.com/docs/drizzle/overview)

module.exports = {
  migrations_directory: "./migrations",
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*", // Match any network id
      gas: 8000000,
      gasPrice: 6000000000
    }
  },
  solc: {
    optimizer: {
      enabled: true,
      runs: 500
    }
  }
};

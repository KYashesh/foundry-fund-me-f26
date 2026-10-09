# FundMe — Solidity Smart Contract

A decentralized crowdfunding smart contract built with **Solidity and Foundry**. Users can fund the contract with ETH, while Chainlink Price Feeds help calculate the USD value of contributions.

## 🚀 Features

- **ETH Funding:** Users can contribute ETH to the contract.
- **Minimum Funding Requirement:** Contributions must meet a minimum USD value.
- **Chainlink Price Feeds:** Converts ETH amounts into USD values.
- **Fund Tracking:** Tracks contributions made by funders.
- **Owner-Only Withdrawal:** Restricts withdrawal functionality to the contract owner.
- **Automated Testing:** Uses Foundry to test smart contract functionality.

## 🛠️ Tech Stack

- **Solidity** — Smart contract development
- **Foundry** — Development, testing, and deployment
- **Chainlink** — Price Feed integration
- **Ethereum / EVM** — Smart contract execution
- **Git & GitHub** — Version control

## 📂 Project Structure

```text
foundry-fund-me-f26/
├── src/          # FundMe smart contract
├── script/       # Deployment scripts
├── test/         # Smart contract tests
├── lib/          # Dependencies
├── foundry.toml  # Foundry configuration
└── README.md     # Project documentation


### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

## 🔐 Security Note 

This project is for educational purposes and smart contract development practice. It has not been independently audited and should not be treated as production-ready.

## 👨‍💻 Author **Yashesh Kumar**

- GitHub: [@KYashesh](https://github.com/KYashesh)
- LinkedIn: [Yashesh Kumar](https://www.linkedin.com/in/yashesh-kumar-8b1bbb256/)

--- 
Built while learning Solidity and Foundry through hands-on smart contract development.

# About

This is a Crowd Sourcing App.

# Getting Started

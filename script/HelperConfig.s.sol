//SPDX-License-Identifier: MIT

// 1. Deploy mocks whn we are on a local anvil chain
// 2. Keep track of contract address across different chains
// Sepolia ETH/USD Price Feed Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
// Mainnet ETH/USD Price Feed Address: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    // if we are on a local anvil chain, we deploy mocks, otherwise, grab the existing address from the live network.

    NetworkConfig public activeNetworkConfig;

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    struct NetworkConfig {
        address priceFeed; //ETH/USD price feed address
    }

    constructor() {
        if (block.chainid == 11155111) {
            //Sepolia ChainId = 11155111
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            //Mainnet ChainId = 1
            activeNetworkConfig = getMainnetEthConfig();
        } else {
            activeNetworkConfig = getAnvilEthConfigWithMocks();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        // Sepolia ETH/USD Price Feed Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getAnvilEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return anvilConfig;
    }

    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        // Mainnet ETH/USD Price Feed Address: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        NetworkConfig memory mainnetConfig = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return mainnetConfig;
    }

    function getAnvilEthConfigWithMocks()
        public
        returns (NetworkConfig memory)
    {
        // Deploy the mock price feed contract

        // Anvil ETH/USD Price Feed Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306

        // 1. Deploy mocks when we are on a local anvil chain
        // 2. Keep track of contract address across different chains
        // 3. return the mock address

        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        ); // 8 decimals, initial price of $2000
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });
        return anvilConfig;
    }
}

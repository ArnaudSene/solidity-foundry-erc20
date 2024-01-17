// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {MyERCToken} from "../src/MyERCToken.sol";

contract DeployMyERCToken is Script {
    uint256 public constant INITIAL_SUPPLY = 1_000_000 ether;
    uint256 public constant DEFAULT_ANVIL_PRIVATE_KEY = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    uint256 public deployerKey;

    function run() external returns (MyERCToken) {
        if (block.chainid == 31337) {
            deployerKey = DEFAULT_ANVIL_PRIVATE_KEY;
        } else {
            deployerKey = vm.envUint("PRIVATE_KEY");
        }
        
        vm.startBroadcast(deployerKey);
        MyERCToken met = new MyERCToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return met;
    }
}
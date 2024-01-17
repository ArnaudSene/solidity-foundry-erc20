// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {DeployMyERCToken} from "../script/DeployMyERCToken.s.sol";
import {MyERCToken} from "../src/MyERCToken.sol";
import {IERC20Errors} from "@openzeppelin/contracts/interfaces/draft-IERC6093.sol";

interface MintableToken {
    function mint(address, uint256) external;
}


contract MyERCTokenTest is Test {
    uint256 USER_A_STARTING_AMOUNT = 100 ether;
    MyERCToken public met;
    DeployMyERCToken public deployer;
    address userA;
    address userB;

    function setUp() public {
        userA = makeAddr("userA");
        userB = makeAddr("userB");

        deployer = new DeployMyERCToken();
        met = deployer.run();
        // Smart contract address deployed
        address deployerAddress = vm.addr(deployer.deployerKey());

        // Fund userA address
        vm.prank(deployerAddress);
        met.transfer(userA, USER_A_STARTING_AMOUNT);
    }

    /**
     * Test Summary
     * 
     * 1. Initial supply has been successfully done
     * 2. Can't mint token when the user is not the owner
     * 3. Able to allow a user to transfert tokens on behalf
     * 4. User B not able to spend more than allowed (on behalf)
     * 5. Transfer tokens successfully done
     * 6. Balance is updated after a transfer
     * 
     */

    /**
     * 1. Initial supply has been successfully done
     */
    function testInitialSupplyHasBeenSuccessfullyDone() public {
        assertEq(met.totalSupply(), deployer.INITIAL_SUPPLY());
    }

    /**
     * 2. Can't mint token when the user is not the owner
     */
    function testRevertWhenNotOwnerTryToMintToken() public {
        vm.expectRevert();
        MintableToken(address(met)).mint(address(this), 100);
    }

    /**
     * 3. Able to allow a user to transfert tokens on behalf
     */
    function testUserAApproveUserBToTransfertToken() public {
        uint256 initialAllowance = 100 ether;

        // User A approves User B to spend tokens on his behalf
        vm.prank(userA);
        met.approve(userB, initialAllowance);

        // User B spends less than initialAllowance
        uint256 transferAmount = 50 ether;
        vm.prank(userB);
        met.transferFrom(userA, userB, transferAmount);

        // Assert
        assertEq(met.balanceOf(userB), transferAmount);
        assertEq(met.balanceOf(userA), USER_A_STARTING_AMOUNT - transferAmount);
    }

    /**
     * 4. User B not able to spend more than allowed (on behalf)
     */
    function testRevertWhenUserBSpendMoreThanAllowance() public {
        uint256 initialAllowance = 100 ether;

        // User A approves User B to spend tokens on his behalf
        vm.prank(userA);
        met.approve(userB, initialAllowance);

        // User B spends less than initialAllowance
        uint256 transferAmount = 101 ether;
        vm.prank(userB);
        vm.expectRevert(
            abi.encodeWithSelector(
                IERC20Errors.ERC20InsufficientAllowance.selector,
                userB,
                initialAllowance,
                transferAmount
            )
        );
        met.transferFrom(userA, userB, transferAmount);
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * ETHER need to pay for a tansaction = gas spent * gas price
 * GAS is a unit of computation
 * GAS SPENT is the total amount of GAS used in a transaction
 * GAS PRICE is how much ETHER you are willing to pay per GAS
 */
contract Gas {
    uint256 public i = 0;

    // Using up all of the gas that you send causes your transaction to fail.
    // State changes are undone.
    // Gas spent is not refunded.
    function forever() public {
        // Here we run a loop until all of the gas are spent
        // and the transaction fails
        while (true) {
            i += 1;
        }
    }
}

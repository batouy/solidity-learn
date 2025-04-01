// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Loop {
    function loop() public pure {
        for (uint256 i = 0; i < 10; i++) {
            if (i == 3) {
                continue;
            }

            if (i == 5) {
                break;
            }
        }

        uint256 j;
        while (j < 10) {
            j++;
        }
    }

    uint256[] public largeArray;

    function inefficientLoop() public view {
        for (uint256 i = 0; i < largeArray.length; i++) {
            // Accessing storage repeatedly within a loop is costly
            // Instead, consider breaking loops into smaller chunks or processing data off-chain to save on gas.
            uint256 value = largeArray[i];
            if (value > 10) {
                break;
            }
        }
    }
}

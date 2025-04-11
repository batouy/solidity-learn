// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract MySlot {
    uint256 public x = 11;
    uint256 public y = 22;
    uint256 public z = 33;
    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }

    function sstore_x(uint256 newval) public {
        assembly {
            sstore(x.slot, newval)
        }
    }

    // normal function
    function set_x(uint256 newval) public {
        x = newval;
    }

    function getSlotX() external pure returns (uint256 slot) {
        assembly {
            // yul
            slot := x.slot // returns slot location of x
        }
    }

    function getSlotZ() external pure returns (uint256 slot) {
        assembly {
            // yul
            slot := z.slot // returns slot location of x
        }
    }

    function readSlotZAsBool() external view returns (bool ret) {
        assembly {
            ret := sload(z.slot)
        }
    }

    function readSlotZ() external view returns (uint256 value) {
        assembly {
            value := sload(z.slot)
        }
    }

    function slotOpcode(uint256 slotNumber)
        external
        view
        returns (uint256 value)
    {
        assembly {
            value := sload(slotNumber)
        }
    }
}

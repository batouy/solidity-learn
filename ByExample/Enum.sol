// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Enum {
    enum Status {
        Pending,
        Shipped,
        Accepted,
        Rejected,
        Canceled
    }

    enum TrafficLight {
        RED,
        YELLOW,
        GREEN
    }

    event LightChanged(TrafficLight);

    Status public status;
    TrafficLight public tl;

    function get() public view returns (Status) {
        return status;
    }

    function set(Status _status) public {
        status = _status;
    }

    function cancel() public {
        status = Status.Canceled;
    }

    // delete resets the enum to its first value, 0
    function reset() public {
        delete status;
    }

    function lightChange() public {
        tl = TrafficLight.RED;
        emit LightChanged(tl);
    }
}

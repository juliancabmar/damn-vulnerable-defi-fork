# Naive Receiver

There’s a pool with 1000 WETH in balance offering flash loans. It has a fixed fee of 1 WETH. The pool supports meta-transactions by integrating with a permissionless forwarder contract. 

A user deployed a sample contract with 10 WETH in balance. Looks like it can execute flash loans of WETH.

All funds are at risk! Rescue all WETH from the user and the pool, and deposit it into the designated recovery account.

# Process dynamic
## Recons:
    1. Docs
    2. Inherits
    3. Code
    Begin of the 5 hours


# Notes

## Recons:
1. Docs
What are meta-transactions?
    How wallets works?
        + How is the sign/verification process?
            + How public keys are generated?
                + What are the Mnemonic Phrases?
2. Inherits
    EIP-712
    EIP-191
        Cyfrin: Advance Foundry - section 5 (relevant info only)
3. Code

Checked | Code | Files
    +    | 12   | [](Multicall.sol)
    +    | 29   | [](FlashLoanReceiver.sol)
    -    | 68   | [](NaiveReceiverPool.sol)
    -    | 77   | [](BasicForwarder.sol)


-------------------------------------

Strategy:
WETH_IN_POOL = 1000e18;
WETH_IN_RECEIVER = 10e18;
FIXED_FEE = 1e18

player
    FlashLoanReceiver::onFlashLoan(address(pool), address(weth), WETH_IN_POOL, 1e18, bytes calldata)

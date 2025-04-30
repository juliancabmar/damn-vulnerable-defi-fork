# Unstoppable

There's a tokenized vault with a million DVT tokens deposited. It’s offering flash loans for free, until the grace period ends.

To catch any bugs before going 100% permissionless, the developers decided to run a live beta in testnet. There's a monitoring contract to check liveness of the flashloan feature.

Starting with 10 DVT tokens in balance, show that it's possible to halt the vault. It must stop offering flash loans.



# Imparable

Hay una bóveda tokenizada con un millón de tokens DVT depositados. Está ofreciendo préstamos flash de forma gratuita, hasta que termine el período de gracia.

Para detectar cualquier error antes de volverse 100% sin permisos, los desarrolladores decidieron ejecutar una beta en vivo en la testnet. Hay un contrato de monitoreo para verificar la disponibilidad de la función de préstamos flash.

Comenzando con un saldo de 10 tokens DVT, demuestra que es posible detener la bóveda. Debe dejar de ofrecer préstamos flash.

# Notes:

in `UstoppableVaul::flashLoan` function:
```javascript
function flashLoan(IERC3156FlashBorrower receiver, address _token, uint256 amount, bytes calldata data)
        external
        returns (bool)
    {
        if (amount == 0) revert InvalidAmount(0); // fail early
        if (address(asset) != _token) revert UnsupportedCurrency(); // enforce ERC3156 requirement
        // @e - totalAssets() -> underlyin tokens on the vault
        // @e - totalSupply -> vault asset token
        uint256 balanceBefore = totalAssets();
        // @audit-high - attacker can transfer underlyin tokens to the vault making the following allways revert
        if (convertToShares(totalSupply) != balanceBefore) revert InvalidBalance(); // enforce ERC4626 requirement

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

The test:
```javascript

# Side Entrance

A surprisingly simple pool allows anyone to deposit ETH, and withdraw it at any point in time.

It has 1000 ETH in balance already, and is offering free flashloans using the deposited ETH to promote their system.

You start with 1 ETH in balance. Pass the challenge by rescuing all ETH from the pool and depositing it in the designated recovery account.


# Process dynamic
## Recons:
1. Docs
    - Pool balance 1000 ETH
    - Free flashloans
    - I have 1 ETH
    - Objective: send all ETH to recovery address
2. Inherits
3. Code

Begin of the 5 hours


-----------------------------------------------------------

### [H-1] Attacker can increase his pool balance unfairly on flashloan execution, allowing he unfund the contract

**Description:**\
An attacker can take a flashloan and in the same transaction can use the amount for increase his related balance inside the pool contract unfearly, so later call withdraw() to empty the pool.

**Recomendation:**\
Block the deposits while a flashloan is executed.

<details>
<summary>Example</summary>

```diff
contract SideEntranceLenderPool {
    mapping(address => uint256) public balances;
+   bool onFlashloan = false;

    error RepayFailed();
+   error FlashLoanTaked();

    event Deposit(address indexed who, uint256 amount);
    event Withdraw(address indexed who, uint256 amount);

    function deposit() external payable {
+       if (!onFlashloan) {
+           revert FlashLoanTaked();
+       }
        unchecked {
            balances[msg.sender] += msg.value;
        }
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw() external {
        uint256 amount = balances[msg.sender];
        delete balances[msg.sender];
        emit Withdraw(msg.sender, amount);

        SafeTransferLib.safeTransferETH(msg.sender, amount);
    }

    function flashLoan(uint256 amount) external {
+       onFlashloan = true;
        uint256 balanceBefore = address(this).balance;

        IFlashLoanEtherReceiver(msg.sender).execute{value: amount}();

+       onFlashloan = false;

        if (address(this).balance < balanceBefore) {
            revert RepayFailed();
        }
    }
}
```

</details>
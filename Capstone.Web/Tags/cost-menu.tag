<cost-menu>
    <div id="budgetContainer">
        <h2 id="costHeader">Cost Analysis</h2>
        <p>Budget: {budget}</p>
        <p>Base Cost: {baseCost}</p>
        <p>Total Room Cost: </p>
        <p>Total Cost: </p>
        <p id="balance" class="{over: overBalance}">Balance: {balance}</p>
    </div>

    <style>
        .over{
            color: red !important;
        }

        #balance{
            color: green;
        }
    </style>

    <script>
        this.baseCost = opts.basecost;
        this.budget = opts.budget;
        this.balance = opts.balance;
        this.overBalance = opts.isover;
    </script>
</cost-menu>
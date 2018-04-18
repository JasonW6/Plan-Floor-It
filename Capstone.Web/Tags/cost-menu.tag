<cost-menu>
    <div id="budgetContainer">
        <h2 id="costHeader">Cost Analysis</h2>
        <p>Budget: {budget}</p>
        <p>Square Feet: {squareFeet}</p>
        <p>Estimated Cost: {baseCost}</p>
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
        this.squareFeet = opts.squarefeet;
    </script>
</cost-menu>
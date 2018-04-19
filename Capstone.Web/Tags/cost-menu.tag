<cost-menu>
    
    <div id="budgetContainer">
        <h2 id="costHeader">Cost Analysis</h2>
        <!--<span id="sqft">{squareFeet} ft<sup>2</sup></span>-->
        <span>Budget</span> <span>{budget}</span>
        <span>Est. Cost </span> <span>{baseCost}</span>
        <span>Balance</span><span id="balance" class="{over: overBalance}">{balance}</span>
    </div>

    <style>

        #costHeader {
            grid-column: 1 / span 2;
            grid-gap: 5px;
            background-color: black;
            border-radius: 5px;
            padding: 10px;
            color: white;
            margin: auto;
            display: inline;
        }

        #budgetContainer {
            display: grid;
            margin: auto;
            grid-template-columns: 50% 50%;
            height: 100%;
            padding: 10px;
            width: 50%;
        }
            #budgetContainer span {
                
            }

        .over {
            color: #FE1917 !important;
        }

        #sqft {
            grid-column: 1 / span 2;
        }

        #balance {
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
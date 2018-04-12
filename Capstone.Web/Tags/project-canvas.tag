

<project-canvas>

    <h1 class="floor-number"></h1>

    <div class="canvas-container">
        <canvas id="c" width="1000" height="600"></canvas>
    </div>

    <style>


    </style>

    <script>

        this.floors = [];

        this.getFloors = function () {

            const url = '/api/floors';

            fetch(url)
                .then(response => response.json())
                .then(data => {
                    this.floors = data;
                    console.log(this.floors);
                    this.update();
                });
        }

    </script>






</project-canvas>
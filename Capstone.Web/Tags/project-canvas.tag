

<project-canvas>

    <button onclick={downFloor} type="button">&lt</button>
    <h1 class="floor-number">Floor: {currentFloor.FloorNumber}</h1>
    <button onclick={upFloor} type="button">&gt</button>
    <div class="canvas-container">
        <canvas id="c" width="1000" height="600"></canvas>
    </div>

    <style>
    </style>

    <script>

        this.floors = [];
        this.floorId = 0;
        this.currentFloor = {};

        this.on("mount", function () {
            console.log("loaded");
            this.getFloors();
        });

        this.getFloors = function () {

            const url = "/api/floors?houseId=" + opts.houseid;
            console.log(opts.houseid);
            fetch(url)
                .then(response => response.json())
                .then(data => {
                    this.floors = data;
                    console.log(this.floors);
                    this.update();
                });

            console.log(this.floors);
        }

        this.downFloor = function () {
            if (floorId > 0) {
                floorId--;
            }

            this.currentFloor = this.floors[floorId];
        }

        this.upFloor = function () {
            if (floorId < floors.length) {
                floorId++;
            }

            this.currentFloor = this.floors[floorId];
        }

    </script>






</project-canvas>
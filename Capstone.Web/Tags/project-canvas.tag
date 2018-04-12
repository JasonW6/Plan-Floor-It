

<project-canvas>

    

    <div class="head">
        <button onclick={downFloor} type="button">&lt</button>
        <h1 class="floor-number">Floor: {this.currentFloor.FloorNumber}</h1>
        <button onclick={upFloor} type="button">&gt</button>
		<button onclick={saveJSON} type="button">Save!</button>
    </div>

    <!--<div class="canvas-container">
        <canvas id="c" width="1000" height="600"></canvas>
    </div>-->

    <style>

        canvas {
            border: 5px solid #000;
        }

        .head {
            align-items: center;
            align-content: space-between;
            display: flex;
            flex-direction: row;
        }

        .floor-number {
            display: inline-block;
        }

        button {
            display: inline-block;
        }
    </style>



    <script>

        this.canvas = new fabric.Canvas('c', { preserveObjectStacking: true });

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
                    this.currentFloor = this.floors[1];
                    this.update();
                });

            this.foundation = new fabric.Rect({
                left: 0,
                top: 0,
                fill: "gray",
                width: 800,
                height: 500,
                stroke: "black",
                strokeWidth: 5,
                selectable: false
            })



			this.canvas.add(this.foundation);
			this.foundation.center();

            console.log('canvas:' + this.canvas);
            console.log('foundation' + this.foundation.fill);
            console.log(this.floors);
            this.canvas.renderAll();

            this.update();

        }

        this.downFloor = function () {
            if (this.floorId > 0) {
                this.floorId--;
            }

            this.currentFloor = this.floors[this.floorId];
        }

        this.upFloor = () => {
            if (this.floorId < this.floors.length - 1) {
                this.floorId++;
            }

            this.currentFloor = this.floors[this.floorId];
        }

		this.saveJSON = function () {
			this.json = JSON.stringify(this.canvas.toJSON());

			//fetch - SaveJSON
			const url = "/api/floorplan?floorId=" + this.floors[this.floorId].FloorId;
			const settings =
				{
					method: 'post',
					body: this.json,
					headers: { 'content-type': 'application/json' }
				};
			console.log("JSON:" + this.json);
			fetch(url, settings)
				.then(response => response.json())
		}


    </script>






</project-canvas>
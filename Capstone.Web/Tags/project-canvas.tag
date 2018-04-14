

<project-canvas>



    <div class="head">
        <button onclick={removeFloor} type="button">Remove Floor</button>
        <button onclick={downFloor} type="button">&lt</button>
        <h1 class="floor-number">Floor: {this.currentFloor.FloorNumber}</h1>
        <button onclick={upFloor} type="button">&gt</button>
        <button onclick={saveJSON} type="button">Save!</button>
        <button onclick={newRect} type="button">Rectangle</button>
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
            margin-left: 10px;
            margin-right: 10px;
        }
    </style>



    <script>

		this.concrete = new fabric.Pattern({
			source: '/Content/concrete.png',
			repeat: "repeat"
		});

        this.canvas = new fabric.Canvas('c', { preserveObjectStacking: true });

        this.floors = [];
        this.floorId = 1;
        this.currentFloor = {};
        this.currentFoundation = {};

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
                    console.log("Floors:" + this.floors);
                    console.log("Floorplan:" + this.floors[1].FloorPlan);
                    this.currentFloor = this.floors[1];
                    this.setFloorPlan();
                    this.update();
                });

            console.log(this.floors);
            this.canvas.renderAll();

            this.update();

        }

        this.downFloor = function () {

            this.saveJSON();

            if (this.floorId > 0) {
                this.floorId--;
            }

            this.currentFloor = this.floors[this.floorId];
            this.setFloorPlan();

        }

        this.upFloor = () => {

            this.saveJSON();

            if (this.floorId < this.floors.length - 1) {
                this.floorId++;
            }

            this.currentFloor = this.floors[this.floorId];
            this.setFloorPlan();

        }

        this.saveJSON = function () {
            this.json = JSON.stringify(this.canvas.toJSON());
            this.currentFloor.FloorPlan = this.json;
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
        }

        this.newRect = function () {
            var rect = new fabric.Rect({
                left: 500,
                top: 250,
                fill: "brown",
                width: 100,
                height: 100,
                stroke: "black",
                strokeWidth: 5,
                selectable: true
            });

            this.canvas.add(rect);


        }

        this.loadCanvas = function (json) {

            this.canvas.loadFromJSON(json, this.canvas.renderAll.bind(this.canvas), function (o, object) {
                // `o` = json object
                console.log("Fabric object: " + object.selectable);
                if (object.name == "foundation") {
                    object.selectable = false;
                }
                
                // `object` = fabric.Object instance
                // ... do some stuff ...
            });

			
        }

        this.createFoundation = function (h, w) {

			this.foundation = new fabric.Rect({
				left: 0,
				top: 0,
				fill: this.concrete,
				width: (w * 5),
				height: (h * 5),
				stroke: "black",
				strokeWidth: 5,
				selectable: false
	
			});

			this.foundation.name = "foundation";

			//this.foundation.set("fill", this.concrete);

            this.canvas.add(this.foundation);
			this.foundation.center();
			this.canvas.renderAll();

		}



        this.setFloorPlan = function () {

            this.canvas.clear();
            this.loadCanvas(this.currentFloor.FloorPlan);
            
            //console.log("First floor " + this.createJObject(this.currentFloor.FloorPlan)[0]);
            //let object = this.createJObject(this.currentFloor.FloorPlan);
            //console.log(object.objects[0]);
            //object.objects[0].selecatable = false;

            if (this.currentFloor.FloorPlan == "") {
                this.createFoundation(100, 200);
                console.log("no floor plan dude");
            }


			//this.canvas.item(0).selectable = false;
            this.canvas.renderAll();

        }


        this.createJObject = function (string) {
            return JSON.parse(string);
        }

            //function loadCanvas(json) {

            //	// parse the data into the canvas
            //	canvas.loadFromJSON(json);

            //	// re-render the canvas
            //	canvas.renderAll();

            //	// optional
            //	canvas.calculateOffset();
            //}


    </script>






</project-canvas>
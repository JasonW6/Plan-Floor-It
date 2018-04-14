

<project-canvas>



    <div class="head">
        <button onclick={removeFloor} type="button">Remove Floor</button>
        <button if="{currentFloor != floors[0]}" onclick={downFloor} type="button">&lt</button>
        <h1 class="floor-number">Floor: {this.currentFloor.FloorNumber}</h1>
        <button if="{currentFloor != floors[floors.length - 1]}" onclick={upFloor} type="button">&gt</button>
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



        var canvas = new fabric.Canvas('c', { preserveObjectStacking: true });

        let concrete = {};
        let plywood = {};

        this.floors = [];
        this.floorId = 1;
        this.currentFloor = {};
        this.currentFoundation = {};
        this.isTopFloor;
        this.isBottomFloor;

        this.on("mount", function () {
            console.log("loaded");

            concrete = new fabric.Pattern({
                source: '/Content/concrete.png',
                repeat: "repeat"
            });

            plywood = new fabric.Pattern({
                source: '/Content/plywood.jpg',
                repeat: "repeat"
            });

            this.getFloors();

            //this.isTopFloor = this.currentFloor == this.floors[this.floors.length - 1];
            //this.isBottomFloor = this.currentFloor == this.floors[0];


            canvas.on('object:scaling', function () {
                const active = canvas.getActiveObject();
                active.set({ width: active.width * active.scaleX, scaleX: 1, height: active.height * active.scaleY, scaleY: 1 });
                active.setCoords();
            });

            canvas.on("object:moving", function (e) {
                let movingBox = e.target;
                const boundingBox = canvas.item(0);
                var top = movingBox.top;
                var bottom = top + movingBox.height;
                var left = movingBox.left;
                var right = left + movingBox.width;

                var topBound = boundingBox.top;
                var bottomBound = topBound + boundingBox.height;
                var leftBound = boundingBox.left;
                var rightBound = leftBound + boundingBox.width;

                movingBox.set("left", Math.min(Math.max(left, leftBound), rightBound - movingBox.width));
                movingBox.set("top", Math.min(Math.max(top, topBound), bottomBound - movingBox.height));

            });
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
            canvas.renderAll();

            this.update();

        }

        this.downFloor = () => {

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
            this.json = JSON.stringify(canvas.toJSON(['id','selectable']));
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
                fill: plywood,
                width: 100,
                height: 100,
                stroke: "black",
                strokeWidth: 5,
                selectable: true
            });

            canvas.add(rect);


        }

        this.loadCanvas = function (json) {

            canvas.loadFromJSON(json, canvas.renderAll.bind(canvas), function (o, object) {
                // `o` = json object
                console.log("Fabric object: " + object.selectable);
                // `object` = fabric.Object instance
                // ... do some stuff ...
            });
			
        }

        this.createFoundation = function (h, w) {

            let foundFill = concrete;

            if (this.floorId > 0) {
                foundFill = plywood;
            }

			this.foundation = new fabric.Rect({
				id: "Foundation",
				left: 0,
				top: 0,
				fill: foundFill,
				width: (w * 5),
				height: (h * 5),
				stroke: "black",
				strokeWidth: 5,
				selectable: false
	
			});

			console.log("ID: " + this.foundation.id);
            canvas.add(this.foundation);
			this.foundation.center();
			canvas.renderAll();

		}



        this.setFloorPlan = function () {

            canvas.clear();
            this.loadCanvas(this.currentFloor.FloorPlan);
            
            //console.log("First floor " + this.createJObject(this.currentFloor.FloorPlan)[0]);
            //let object = this.createJObject(this.currentFloor.FloorPlan);
            //console.log(object.objects[0]);
            //object.objects[0].selecatable = false;

            if (this.currentFloor.FloorPlan == "") {
                this.createFoundation(opts.length, opts.width);
                console.log("no floor plan dude");
            }

            
            canvas.renderAll();
            let objects = canvas.getObjects();
            console.log("Objects " + objects);
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
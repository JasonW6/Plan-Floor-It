

<project-canvas>



    <div class="head">
        <!--<button onclick={removeFloor} type="button">Remove Floor</button>-->
        <div id="house-name">{opts.housename}</div>
        <div class="floor-container">
            <button if="{currentFloor != floors[0]}" onclick={downFloor} type="button">&lt</button>
            <h1 class="floor-number">Floor: {this.currentFloor.FloorNumber}</h1>
            <button if="{currentFloor != floors[floors.length - 1]}" onclick={upFloor} type="button">&gt</button>
        </div>

        <button id="save" onclick={saveJSON} type="button">Save</button>
    </div>

    <!--<div class="canvas-container">
        <canvas id="c" width="1000" height="600"></canvas>
    </div>-->

    <style>

        canvas {
            border: 5px solid #000;
        }

        .head {
            background-color: #8AF3FF;
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            min-height: 80px;
            height: 7vh;
            box-shadow: 0 0 10px #000;
            z-index: 2;
            box-shadow: inset 0 0 10px #000;
        }

        #house-name {
            font-size: 2.5rem;
            font-weight: 700;
            margin: auto;
        }

        .floor-number {
            grid-column-start: 2;
        }

        .floor-container {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            margin: auto;
            grid-column-start: 2;
        }

        button {
            transition-duration: 0.4s;
            font-weight: 700;
            height: 50%;
            transform: translateY(50%);
            font-family: sans-serif;
            background-color: #FFF;
            margin-left: 10px;
            margin-right: 10px;
            font-size: 2rem;
            padding: 0;
            line-height: 0;
            border-radius: 5px;
            border-style: none;
        }

        button:hover {
            background-color: #FFF;
            cursor: pointer;
            box-shadow: 0 12px 16px 0 rgba(0,0,0,0.24), 0 17px 50px 0 rgba(0,0,0,0.19);
        }

        button#save {
            grid-column-start: 3;
            padding: 0;
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
        this.roomArea;

        this.on("mount", function () {
            console.log("loaded");

            this.opts.bus.on("newRoom", data => {
                this.newRoom(data);
            });

            this.opts.bus.on("deleteRoom", data => {
                this.deleteRoom();
            });

            this.opts.bus.on("setMaterial", data => {
                this.setMaterial(data);
            });



            this.opts.bus.on("getActive", () => {
                this.opts.bus.trigger("sendActive", canvas.getActiveObject());
            })

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

            canvas.on('mouse:down', function (e) {
                if (e.target.id != 'Foundation') {
                    let currentRoom = canvas.getActiveObject();
                    opts.bus.trigger("changeRoom", currentRoom);
                }
            });

            canvas.on('object:scaling', function () {
                const active = canvas.getActiveObject();
                active.set({ width: active.width * active.scaleX, scaleX: 1, height: active.height * active.scaleY, scaleY: 1 });
                this.roomArea = active.width * active.height;
                console.log("Area: " + this.roomArea);
                opts.bus.trigger("updateRoomArea", this.roomArea);
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
            this.json = JSON.stringify(canvas.toJSON(['id', 'selectable', 'lockRotation','name', 'flooring', '_controlsVisibility']));
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
            fetch(url, settings);
            
        }

        this.newRoom = function (room) {

            this.newRect(room.name, room.flooring);

        }

        this.deleteRoom = function () {

            let room = canvas.getActiveObject();

            canvas.remove(room);
            canvas.renderAll();
        }

        this.changeRoom = function () {

            let currentRoom = canvas.getActiveObject();

            this.opts.bus.trigger("changeRoom", currentRoom);

            console.log("indeexxxxxxx " + canvas.item(index + 1));
            canvas.renderAll();

        }


        this.setMaterial = function (image) {

            let room = canvas.getActiveObject();

            //material = new fabric.Pattern({
            //    source: ,
            //    repeat: 'repeat'
            //});
            if (room.flooring === null) {
                image = "plywood.png";
            }

            room.flooring = "/Content/" + image;

            fabric.util.loadImage(`/Content/${image}`, function (img) {
                room.set('fill', new fabric.Pattern({
                    source: img,
                    repeat: 'repeat'
                }));
                canvas.renderAll();
            });

            //room.set('fill', material);


            //canvas.renderAll();

            this.saveJSON();


            canvas.renderAll();
        }

        this.newRect = function (_name, _flooring) {

            let rect = new fabric.Rect({
                name: _name,
                flooring: _flooring,
                left: 500,
                top: 250,
                fill: '',
                width: 100,
                height: 100,
                stroke: "black",
                strokeWidth: 5,
                lockRotation: true,
                selectable: true
            });

            rect.setControlsVisibility({
                mtr: false
            });

            canvas.add(rect);
            rect.center();
            canvas.setActiveObject(rect);
            this.saveJSON();
        }

        this.loadCanvas = function (json) {

            canvas.loadFromJSON(json, canvas.renderAll.bind(canvas), function (o, object) {
                // `o` = json object
                console.log("Fabric object: " + object.selectable);
                // `object` = fabric.Object instance
                // ... do some stuff ...
            });

            canvas.renderAll();
			
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
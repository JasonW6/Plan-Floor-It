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
            background-color: #cddeed;
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

        let textWidth = new fabric.Text('', { left: 100, top: 100 });
        let textHeight = new fabric.Text('', { left: 100, top: 100 });
        textWidth.selectable = false;
        textHeight.selectable = false;
        textWidth.fontWeight = 600;
        textHeight.fontWeight = 600;
        textWidth.fontSize = 32;
        textHeight.fontSize = 32;
        textWidth.fontFamily = 'Helvetica';
        textHeight.fontFamily = 'Helvetica';


		let concrete = '/Content/concrete.png';
		let plywood = '/Content/plywood.jpg';

        this.floors = [];
        this.floorId = 1;
        this.currentFloor = {};
        this.currentFoundation = {};
        this.isTopFloor;
        this.isBottomFloor;
        this.roomArea;
        this.floorCostsLow = {};
        let floorCostsMid = {};
        this.floorCostsHig = {};

        this.on("mount", function () {
            console.log("loaded");

            canvas.selection = false;


            this.opts.bus.on("newRoom", data => {
                this.newRoom(data);
            });

            this.opts.bus.on("deleteRoom", data => {
                this.deleteRoom();
            });

            this.opts.bus.on("setMaterial", data => {
                this.setMaterial(data);
            });

            this.opts.bus.on("addObject", data => {
                this.addObject(data);
            });

            this.opts.bus.on("getActive", () => {
                this.opts.bus.trigger("sendActive", canvas.getActiveObject());
            });

            this.opts.bus.on("addDoor", () => {
                this.addEssential('door');
            });

            this.opts.bus.on("addStairs", () => {
                this.addEssential('stairs');
            });

            this.opts.bus.on("addWindow", () => {
                this.addEssential('window');
            });

            this.getFloors();

            //this.isTopFloor = this.currentFloor == this.floors[this.floors.length - 1];
            //this.isBottomFloor = this.currentFloor == this.floors[0];

            canvas.on('mouse:down', function (e) {

                if (e.target.id === 'room') {
                    let currentRoom = canvas.getActiveObject();
                    opts.bus.trigger("changeRoom", currentRoom);
                } else if (e.target.id === 'object') {
                    opts.bus.trigger("objectView", e.target);
                } else {
                    textWidth.set('text', '');
                    textHeight.set('text', '');
                }

                console.log(e.target.id);
            });

            canvas.on('object:scaling', function () {

                const active = canvas.getActiveObject();

                active.set({ width: active.width * active.scaleX, scaleX: 1, height: active.height * active.scaleY, scaleY: 1 });
                active.setCoords();

                this.roomArea = active.width * active.height;
                opts.bus.trigger("updateRoomCost", ((this.roomArea / 25) * floorCostsMid[active.flooring]));

                let midBottom = active.oCoords.mb;
                let midLeft = active.oCoords.ml;

                console.log("%%%%%%" + midLeft);

                canvas.bringForward(textWidth);
                canvas.bringForward(textHeight);

                let width = round(active.width / 10).toString();
                let height = round(active.height / 10).toString();

                textWidth.set('text', width + "'");
                textWidth.set("left", midBottom.x - 30);
                textWidth.set("top", midBottom.y);

                textHeight.set('text', height + "'");
                textHeight.set("left", midLeft.x - 80);
                textHeight.set("top", midLeft.y - 20);
                
            });

            canvas.on("object:moving", function (e) {

                textWidth.set('text', '');
                textHeight.set('text', '');

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

            this.opts.bus.on("getFloorCosts", data => {
                console.log("Costs:" + data);
                let floorData = {}
                for (var i = 0; i < data.length; i++) {
                    floorData["/Content/" + data[i].Name.toLowerCase() + ".png"] = data[i].MediumPrice;
                }
                console.log("Mid Costs: " + floorData);
                floorCostsMid = floorData;
            });
        });



        this.getFloors = function () {

            const url = "/api/floors?houseId=" + opts.houseid;
            console.log(opts.houseid);
            fetch(url)
                .then(response => response.json())
                .then(data => {
                    this.floors = data;
                    console.log("Floorplan:" + this.floors[1].FloorPlan);
                    this.currentFloor = this.floors[1];
                    this.setFloorPlan();
                    this.update();
                });

            console.log("////////////////////////////////////////////////////////////////");

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
            this.json = JSON.stringify(canvas.toJSON(['id', 'selectable', 'lockRotation', 'name', 'flooring', '_controlsVisibility', 'cost']));
            this.currentFloor.FloorPlan = this.json;
            //fetch - SaveJSON
            const url = "/api/floorplan?floorId=" + this.floors[this.floorId].FloorId;
            const settings =
                {
                    method: 'post',
                    body: this.json,
                    headers: { 'content-type': 'application/json' }
                };

            fetch(url, settings);

            console.log("JSON:" + this.json);
        }

        this.newRoom = function (room) {
            this.newRect(room.name, room.flooring, room.cost);
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

        this.addEssential = function (object) {

            let imgAddress = '';


            if (object === 'door') {

                imgAddress = "/Content/DOOR-WHITE-small.png";

            } else if (object === 'stairs') {

                imgAddress = "/Content/STAIRS-small.png";

            } else if (object === 'window') {

                imgAddress = "/Content/WINDOW-WHITE-small.png";

            }

            fabric.Image.fromURL(imgAddress, function (myImg) {

                myImg.id = "object";
                canvas.add(myImg);
                myImg.center();
                hideControls(myImg);
                canvas.renderAll();

            });
        }

        this.addObject = function (image) {

            fabric.Image.fromURL(('/Content/' + image), function (myImg) {

                console.log("Add Object: " + myImg);

                canvas.add(myImg);
                canvas.renderAll();
            });

        }

        this.setMaterial = function (image) {

            let room = canvas.getActiveObject();

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

            this.saveJSON();


            canvas.renderAll();
        }

        this.newRect = function (_name, _flooring, _cost) {

            let rect = new fabric.Rect({
                id: 'room',
                name: _name,
                flooring: _flooring,
                cost: _cost,
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
            rect.moveTo(1);
            canvas.setActiveObject(rect);
            this.saveJSON();
        }

        this.loadCanvas = function (json) {
            canvas.loadFromJSON(json, canvas.renderAll.bind(canvas), function (o, object) {

                console.log("LOADED " + json);

            });

            canvas.renderAll();
        }

        this.createFoundation = function (h, w) {

			let foundFill = concrete;
			let foundation = {};

            if (this.floorId > 0) {
                foundFill = plywood;
			};

			foundation = new fabric.Rect({
				id: "Foundation",
				left: 0,
				top: 0,
				fill: "",
				width: (w * 10),
				height: (h * 10),
				stroke: "black",
				strokeWidth: 5,
				selectable: false
			});

			fabric.util.loadImage(`${foundFill}`, function (img) {
			
				foundation.set('fill', new fabric.Pattern({
					source: img,
					repeat: 'repeat',
				}));

				canvas.renderAll();
			});

			console.log("ID: " + foundation.id);
            canvas.add(foundation);
            foundation.moveTo(0);
			foundation.center();
			canvas.renderAll();
        }



        this.setFloorPlan = function () {

            canvas.clear();
            this.loadCanvas(this.currentFloor.FloorPlan);

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

        function hideControls (object) {

            object.setControlsVisibility({
                tr: false,
                tl: false,
                br: false,
                bl: false,
                ml: false,
                mt: false,
                mr: false,
                mb: false,
                mtr: false
            });
        }

        function round(number) {
            var factor = Math.pow(10, 1);
            return Math.round(number * factor) / factor;
        }


    </script>
</project-canvas>
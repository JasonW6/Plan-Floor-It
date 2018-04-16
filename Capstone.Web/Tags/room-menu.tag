<room-menu>
	<div class="room-name">
		<i onclick="{ switchLock }" class="fa fa-lock {activated: isLocked}"></i>
		<i onclick="{ switchZoom }" class="fa fa-search-plus {activated: isZoom}"></i>
		<button if="{roomIndex > 0}" id="roomBackButton" onclick="{ downRoom }" type="button">&lt</button>
		<input id="roomNameTextBox" type="hidden">
		<span id="roomName">{currentRoom.name}</span>
		<button if="{roomIndex < rooms.length - 1}" onclick="{ upRoom }" id="roomForwardButton" type="button">&gt</button>
		<button class="roomBtn newRoom" onclick="{newRoom}">+</button>
		<i onclick="{ deleteRoom }" class="fa fa-trash"></i>
	</div>
    <div class="roomContainer " if="{currentRoom === null}">
        
    </div>

	<input type="hidden" class="saveRoom" onclick="{ addRoom }" value="Save Room!">

    <div id="room-{roomIndex}" class="roomContainer createdRoom " if="{currentRoom !== null}">
        
        <div class="roomImgContainer">
            <img class="roomImg" src= {currentMaterial} />
        </div>
            <!--<div class="paintLightButton">
                <button class="switchButtons {activated: currentRoom.hasPaint}" onclick="{ switchPaint }" >paint</button>
            </div>
            <div class="paintLightButton">
                <button class="switchButtons  {activated: currentRoom.hasLights} " onclick="{ switchLights }" >light</button> 
            </div>-->
        </div>


    <style>


        .roomContainer {
            height: 100%;
            position: relative;
        }

        .room-name {
            text-align: center;
			display: grid;
			grid-template-columns: 1fr 1fr 1fr 1fr 2fr 1fr 1fr 1fr 1fr;
			height: 50px;
        }

		#roomBackButton {
			grid-column-start: 4;
			height: 25px;
		}

		#roomNameTextBox {
			grid-column-start: 5;
			height: 25px;
		}

		.fa {
			height: 25px;
			vertical-align: top;
			font-size: 1rem;
		}

		#roomForwardButton {
			grid-column-start: 6;
			height: 25px;
		}
		
		.roomBtn.newRoom {
			grid-column-start: 7;
			height: 25px;
		}

		.fa.fa-trash {
			grid-column-start: 9;
		}

		/*.createdRoom{
            border: 1px solid black;

        }*/
		.roomImgContainer {
			display: inline-block;
			margin: 0 auto;
			position: absolute;
			left: 50%;
			transform: translateX(-50%);
			width: 25%;
			top: 5%;
		}
        .roomImg{
            width: 100%;
        }
        .addPaintAndLights {
            position: absolute;
            bottom: 0;
            width: 100%;
            display: flex;
            text-align: center;
        }
        .paintLightButton{
            width: 50%;
        }
        .sideRoomPanel{
            position: absolute;
            right: 10%;
        }
        i{
            font-size: 2.5rem !important;
            margin: .5em 0;
            display: block !important;
        }
        .activated{
            background-color: black;
            color: white;
        }
        .switchButtons{
            width: 100%;
        }
        
        .room-name{
            height: 10%;
        }
        #roomNameTextBox {
            margin-top: 0.5em;
        }


    </style>

    <script>

		this.opts.bus.on("setMaterial", data => {
			this.currentMaterial = `/Content/${data}`;
			console.log("Material: " + data);
			this.update();
		})

        this.opts.bus.on("updateCurrentRoom", data => {d
            this.updateCurrentRoom(data);
            console.log("12312312321");
        })

        function Room(name) {
            this.name = name;
            this.flooring;
            this.hasPaint = false;
            this.hasLights = false;
        }

        this.switchPaint = function () {
            this.currentRoom.hasPaint = !this.currentRoom.hasPaint;
        }
        this.switchLights = function () {
            this.currentRoom.hasLights = !this.currentRoom.hasLights;
        }

        this.switchZoom = function () {
            this.isZoom = !this.isZoom;
        }

        this.switchLock = function () {
            this.isLocked = !this.isLocked;
        }

        //const living = new Room("Living");
        //const family = new Room("Family");
        //const rooms = [living, family];

        this.roomIndex = -1;
        this.rooms = [];
		this.currentRoom = null; 
		this.currentMaterial = "/Content/plywood.jpg";

		this.on("mount", function () {

			this.span = document.querySelector("#roomName");
			this.element = document.querySelector('#roomNameTextBox');
			this.save = document.querySelector(".saveRoom");
		});
		

        this.createdRooms = [];
        this.createdRooms = document.querySelectorAll('.createdRoom');
        this.isZoom = false;
        this.isLocked = false;

        this.downRoom = function () {
            if (this.roomIndex > 0) {
                this.roomIndex--;
                this.currentRoom = this.rooms[this.roomIndex];
            }
            else {
                let arrowButton = document.querySelector("#roomBackButton");
                arrowButton.setAttribute("style", "display: none");
            }

            this.opts.bus.trigger("changeRoom", this.roomIndex);

            this.update();
        }

        this.deleteRoom = function () {

            let element = document.querySelector('#roomNameTextBox');

            this.opts.bus.trigger("deleteRoom", this.currentRoom);

            this.rooms.splice(this.roomIndex, 1);

            if (this.rooms.length > 0) {
                this.currentRoom = this.rooms[0];
                this.roomIndex = 0;
                element.value = this.currentRoom.name;
            }
            else {
                this.currentRoom = null;
                this.roomIndex = -1;
                element.value = "";
            }

            

            this.update();
        }

        this.upRoom = function () {

            if (this.roomIndex < this.rooms.length - 1) {
                this.roomIndex++;
                this.currentRoom = this.rooms[this.roomIndex];
            }
            else {
                let arrowButton = document.querySelector("#roomForwardButton");
                arrowButton.setAttribute("style", "display: none");
            }

            console.log("uppppdoorooom");
            this.opts.bus.trigger("changeRoom", this.roomIndex);

            this.update();
		}

		this.newRoom = function () {
			this.span.setAttribute("style", "display: none");
			this.element.setAttribute("type", "text");
			this.currentRoom = null;
			this.save.setAttribute("type", "button");

		}

        this.addRoom = function () {
            var room = new Room(this.element.value);
            this.rooms.push(room);
            console.log(this.rooms);
            this.roomIndex++;
            this.currentRoom = this.rooms[this.roomIndex];
            this.currentRoom.flooring = "wood";

            this.opts.bus.trigger("newRoom", this.currentRoom);
			this.element.setAttribute("type", "hidden");
			this.span.setAttribute("style", "display: inline");
			this.save.setAttribute("type", "hidden");
            this.update();
        }

        this.updateCurrentRoom = function (index) {
            console.log("indndnndnndnd " + index);

            this.currentRoom = this.rooms[this.roomIndex];

            let element = document.querySelector('#roomNameTextBox');
            element.value = this.currentRoom.name;

            this.update();
        }

    </script>
</room-menu>
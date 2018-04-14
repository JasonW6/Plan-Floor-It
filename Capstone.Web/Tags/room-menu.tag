<room-menu>
    <div class="room-name">
        <button if="{roomIndex > 0}" id="roomBackButton" onclick="{ downRoom }" type="button">&lt</button>
        <input id="roomNameTextBox" type="text" />
        <button if="{roomIndex < rooms.length - 1}" onclick="{ upRoom }" id="roomForwardButton" type="button">&gt</button>
        <button class="roomBtn newRoom" onclick="{addRoom}">New Room</button>
    </div>
    <div class="roomContainer " if="{currentRoom === null}">
        
    </div>

    <div id="room-{roomIndex}" class="roomContainer createdRoom " if="{currentRoom !== null}">
        
        <div class="roomImgContainer">
            <img class="roomImg" src="/Content/{currentRoom.flooring}.png" />
        </div>
        <div class="sideRoomPanel">
            <i onclick="{ switchZoom }" class="fa fa-search-plus {activated: isZoom}"></i>
            <i onclick="{ switchLock }" class="fa fa-lock {activated: isLocked}" ></i>
            <i class="fa fa-trash"></i>
        </div>
        <div class="addPaintAndLights">
            <div class="paintLightButton">
                <button class="switchButtons {activated: currentRoom.hasPaint}" onclick="{ switchPaint }" >paint</button>
            </div>
            <div class="paintLightButton">
                <button class="switchButtons  {activated: currentRoom.hasLights} " onclick="{ switchLights }" >light</button> 
            </div>
        </div>
    </div>
    

    <style>
        .roomContainer {
            height: 100%;
            position: relative;
        }

        .room-name {
            text-align: center;
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
        
        
    </style>
    <script>

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
        this.createdRooms = [];
        this.createdRooms = document.querySelectorAll('.createdRoom');
        this.isZoom = false;
        this.isLocked = false;

        this.downRoom = function () {
            let element = document.querySelector('#roomNameTextBox');
            if (this.roomIndex > 0) {
                this.roomIndex--;
                this.currentRoom = this.rooms[this.roomIndex];
                element.value = this.currentRoom.name;
            }
            else {
                let arrowButton = document.querySelector("#roomBackButton");
                arrowButton.setAttribute("style", "display: none");
            }
            
            this.update();
        }

        this.upRoom = function () {
            let element = document.querySelector('#roomNameTextBox');
            if (this.roomIndex < this.rooms.length - 1) {
                this.roomIndex++;
                this.currentRoom = this.rooms[this.roomIndex];
                element.value = this.currentRoom.name;
            }
            else {
                let arrowButton = document.querySelector("#roomForwardButton");
                arrowButton.setAttribute("style", "display: none");
            }
           
            this.update();
        }

        this.addRoom = function () {
            let element = document.querySelector('#roomNameTextBox');
            var room = new Room(element.value);
            this.rooms.push(room);
            console.log(this.rooms);
            this.roomIndex++;
            this.currentRoom = this.rooms[this.roomIndex];
            element.value = this.currentRoom.name;
            this.currentRoom.flooring = "wood";
            this.update();
        }


    </script>
</room-menu>
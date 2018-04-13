<room-menu>
    <div class="room-name">
        <button onclick="{ downRoom }" type="button">&lt</button>
        <input id="roomNameTextBox" type="text" />
        <button onclick="{ upRoom }" type="button">&gt</button>
    </div>
    <div class="roomContainer newRoom">
        <button class="roomBtn" onclick="{addRoom}">New Room</button>
    </div>

    <div id="room-{roomIndex}" class="roomContainer createdRoom">
        <p></p>
    </div>


    <style>
        .roomContainer {
            height: 100%;
            position: relative;
        }

        .room-name {
            text-align: center;
        }

        .roomBtn {
            position: absolute;
            top: 40%;
            left: 50%;
            transform: translateX(-50%);
        }
    </style>
    <script>

        function Room(name) {
            this.name = name;
        }
        

        const living = new Room("Living");
        const family = new Room("Family");

        const rooms = [living, family];

        this.roomIndex = 0;
        this.rooms = []; //new Room [];
        this.createdRooms = [];
        this.createdRooms = document.querySelectorAll('.createdRoom');

        this.downRoom = function () {
            let currentRoom = document.querySelector("#room-" + this.roomIndex);
            if (currentRoom !== null) {
                currentRoom.setAttribute("style", "display: none");
                this.roomIndex--;
                let newRoom = document.querySelector("#room-" + this.roomIndex);
                newRoom.setAttribute("style", "display: block");
            }
        }

        this.upRoom = function () {
            
            let currentRoom = document.querySelector("#room-" + this.roomIndex);
            if(currentRoom !== null){
            currentRoom.setAttribute("style", "display: none");
            this.roomIndex++;
            let newRoom = document.querySelector("#room-" + this.roomIndex);
            newRoom.setAttribute("style", "display: block");
            }
        }

        this.addRoom = function () {
            let element = document.querySelector('#roomNameTextBox')
            var room = new Room(element.value);
            

            
            this.rooms.push(room);
            console.log(this.rooms);
            this.update();
            let currentRoom = document.querySelector("#room-" + this.roomIndex);
            currentRoom.setAttribute("style", "display: block");
            
            this.createdRooms = document.querySelectorAll('.createdRoom');
            this.newRoom = document.querySelector('.newRoom');
            
        }


    </script>
</room-menu>
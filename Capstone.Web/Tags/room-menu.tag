<room-menu>
    <div class="room-name">
        <button if="{roomIndex >= 0}" onclick="{ downRoom }" type="button">&lt</button>
        <input id="roomNameTextBox" type="text" />
        <button onclick="{ upRoom }" type="button">&gt</button>
    </div>
    <div class="roomContainer newRoom" if="{currentRoom === null}">
        <button class="roomBtn" onclick="{addRoom}">New Room</button>
    </div>

    <div id="room-{roomIndex}" class="roomContainer createdRoom" if="{currentRoom !== null}">
        <p>{currentRoom.name}</p>
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

        //const living = new Room("Living");
        //const family = new Room("Family");
        //const rooms = [living, family];

        this.roomIndex = -1;
        this.rooms = [];
        this.currentRoom = null;
        this.createdRooms = [];
        this.createdRooms = document.querySelectorAll('.createdRoom');

        this.downRoom = function () {
            let element = document.querySelector('#roomNameTextBox');
            if (this.roomIndex > 0) {
                this.roomIndex--;
                this.currentRoom = this.rooms[this.roomIndex];
            }
            else {
                this.currentRoom = null;
                element.value = "";
            }
            this.update();
        }

        this.upRoom = function () {
            let element = document.querySelector('#roomNameTextBox');
            if (this.roomIndex < this.rooms.length - 1) {
                this.roomIndex++;
                this.currentRoom = this.rooms[this.roomIndex];
            }
            else {
                this.currentRoom = null;
                element.value = "";
            }
            this.update();
        }

        this.addRoom = function () {
            let element = document.querySelector('#roomNameTextBox');
            var room = new Room(element.value);
            this.rooms.push(room);
            console.log(this.rooms);
            
            this.currentRoom = room;
            this.update();
            this.roomIndex++;
        }


    </script>
</room-menu>
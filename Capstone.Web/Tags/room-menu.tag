<room-menu>
    <div class="room-name">
        <button type="button">&lt</button>
        <input type="text" />
        <button type="button">&gt</button>
    </div>
    <div class="roomContainer newRoom">
        <button class="roomBtn" onclick="{addRoom}">New Room</button>
    </div>
    <div class="roomContainer createdRoom" each="{room in rooms}">
        <p>{room.name}</p>
    </div>

    <style>
        .roomContainer {
            height: 100%;
            position: relative;
        }

        .room-name{
            text-align: center;
        }

        .roomBtn {
            position: absolute;
            top: 40%;
            left: 50%;
            transform: translateX(-50%);
        }

        .createdRoom{
            visibility: hidden;
        }
    </style>
    <script>
        this.rooms = [];
        this.createdRooms = [];
        this.createdRooms = document.querySelectorAll('.createdRoom');
       
        this.addRoom = function () {
            var room = { "name": 'kitchen' };
            
            if (this.createdRooms.length === 0) {
                this.rooms.push(room);
            }
            this.update();
            this.createdRooms = document.querySelectorAll('.createdRoom');
            this.newRoom = document.querySelector('.newRoom');
            this.newRoom.setAttribute("style", "display: none");

            for (var i = 0; i < this.createdRooms.length; i++) {
                
                this.createdRooms[i].setAttribute("style", "visibility: visible");

            }
        }

    </script>
</room-menu>
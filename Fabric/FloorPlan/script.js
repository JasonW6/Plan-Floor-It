
// Sets foundation rect, is called on Load of page
function setFoundation() {

    // instantiates new fabric object
    var rect = new fabric.Rect({
        left: 500,
        top: 50,
        fill: "gray",
        width: 800,
        height: 500,
        // Stroke = border
        stroke: "black",
        strokeWidth: 5,
        selectable: false
    });

    // Add rect to canvas
    canvas.add(rect);
    // Add rect to array of rects
    rooms.push(rect);
    // Render canvas(ie refresh)
    canvas.renderAll();
}

// Array that holds all rects added to canvas
const rooms = [];

function newRoom() {
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

    canvas.add(rect);
    rooms.push(rect);
    rect.bringToFront();
}

// Set Pattern Fill of Active Object
function setMaterial(m) {
    // Get Active Object
    const active = canvas.getActiveObject();
    // Create new Pattern object
    const pattern = new fabric.Pattern({
        source: `images/${m}`,
        repeat: "repeat"
    });
    // Set Active Objects "fill" property to Pattern object
    active.set("fill", pattern);
    // Resets scale of object
    active.set({width:active.width*active.scaleX,scaleX:1,height:active.height*active.scaleY, scaleY:1});

}

// Variable to hold Active Object
let activeRoom = {};
// Variable to get track of Room Id
let roomId = -1;
// Html Label Element that will hold Room Id
let roomLabel = undefined;
// Html Span Element that will hold Area
let areaSpan = undefined;

function previousRoom() {

    // Find label#room element
    roomLabel = document.getElementById("room");
    // Get Active Object
    activeRoom = canvas.getActiveObject();
    // Find span#area element
    areaSpan = document.getElementById("area");
    
    // If no Active room, Active room is first room (index 0 is Foundation)
    if (activeRoom == null) {
        activeRoom = rooms[1];
    }
    // Set Active Room's border to Black
    activeRoom.set("stroke", "black");
    // Get Index of the Active Room on the canvas, set that to Room Id
    roomId = canvas.getObjects().indexOf(activeRoom);
    
    // Decrement Room ID if it is not the last Room
    if (roomId > 1) {
        roomId--;
    }
    console.log(roomId);
    // Set InnerText of the Label to Room Id
    roomLabel.innerText = roomId;

    // Set Active Room to Previous room
    activeRoom = rooms[roomId];
    // Set Active Room border to White
    activeRoom.set("stroke", "white");
    // Set the Active Object to the new Active Room
    canvas.setActiveObject(activeRoom);

    // Calculate the Area of active room and set the Span's text to Area
    let roomArea = activeRoom.height * activeRoom.width;
    areaSpan.innerText = Math.round(roomArea, 2);

    // Refresh
    canvas.renderAll();
}

function nextRoom() {

    activeRoom = canvas.getActiveObject();
    roomLabel = document.getElementById("room");
    areaSpan = document.getElementById("area");

    if (activeRoom == null) {
        activeRoom = rooms[rooms.length - 1];
    }

    activeRoom.set("stroke", "black");

    roomId = canvas.getObjects().indexOf(activeRoom);
    
    if (roomId < rooms.length - 1) {
        roomId++;
    }
    console.log(roomId);
    roomLabel.innerText = roomId;
    
    activeRoom = rooms[roomId];
    activeRoom.set("stroke", "white");
    canvas.setActiveObject(activeRoom);

    let roomArea = activeRoom.height * activeRoom.width;
    areaSpan.innerText = Math.round(roomArea, 2);

    canvas.renderAll();
}

// Cant get this working properly yet
function setArea(width, height) {
    activeRoom.scaleToWidth(width);
    activeRoom.scaleToHeight(height);
    console.log(activeRoom.width);
    console.log(activeRoom.height);
    canvas.renderAll();
}


// Functions for allowing drag and drop of the colored Div elements
function allowDrop(e) {
    e.preventDefault();
}

function drag(e) {
    e.dataTransfer.setData("text", 
    window.getComputedStyle(e.target, null).getPropertyValue("background-color"));
    console.log(e.target.style.backgroundColor);
}

function drop(e) {
    e.preventDefault();
    let data = e.dataTransfer.getData("text");
    e.target.value = data;
}

function changeColor(e) {
    e.preventDefault();
    let data = e.dataTransfer.getData("text");
    console.log(data);
    e.target.value = data;
}

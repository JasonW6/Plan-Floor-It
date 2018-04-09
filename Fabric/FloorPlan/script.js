function setFoundation() {
    var rect = new fabric.Rect({
        left: 500,
        top: 50,
        fill: "gray",
        width: 800,
        height: 500,
        selectable: false
    });

    canvas.add(rect);
    canvas.renderAll();
}

function newRect(w, h, c, s) {
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
    rect.bringToFront();
}



function clear() {
    canvas.getActiveObject().remove();

    RenderCanvas();
}

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

function setMaterial(m) {
    const active = canvas.getActiveObject();
    console.log(active);
    const pattern = new fabric.Pattern({
        source: `images/${m}`,
        repeat: "repeat"
    });
    active.set("fill", pattern);
    active.set({width:active.width*active.scaleX,scaleX:1,height:active.height*active.scaleY, scaleY:1});

}



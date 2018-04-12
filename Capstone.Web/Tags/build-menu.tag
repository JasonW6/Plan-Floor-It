﻿<build-menu>
    <div class="menuContainer">
        <div id="menuTabsContainer">
            <div class="menuTab activeMenuTab" id="materialTab" onclick="{switchMaterialType}">Material</div>
            <div class="menuTab" id="otherTab" onclick="{switchMaterialType}">Other</div>
        </div>

        <div class="materialsContainer" id="materialSection" if={isFloors}>
            <div class="materialScroll">
            </div>
            <div class="materials" id="floorMaterials">
                <div class="material" each="{floor, index in floors}" id="floor-{index}">
                    <img src="/Content/{floor.ImageSource}" class="matImg" />
                    <p>{floor.Name}</p>
                </div>
            </div>
        </div>

        <div class="materialsContainer" id="otherSection" if={!isFloors}>
            <div class="materialScroll">
            </div>
            <div class="materials" id="objectMaterials">
                <div class="material" each="{object, index in objects}" id="object-{index}">
                    <img src="/Content/{object.ImageSource}" class="matImg" />
                    <p>{object.Name}</p>
                </div>
            </div>
        </div>

        <div class="roomContainer">

        </div>
    </div>

    <style type="text/css">
        .menuContainer {
            width: 55%;
            display: inline-block;
        }

        .materials{
            height: 12em;
        }

        .matImg {
            width: 100%;
            margin: 0 auto;
        }

        #menuTabsContainer {
            display: flex;
            width: 100%;
        }
        .menuTab {
            display: inline-block;
            width: 50%;
            border: 1px solid black;
            text-align: center;
            cursor: pointer;
        }

        .activeMenuTab{
            background-color: aliceblue;
        }
        .material {
            width: 12em !important;
            margin: 0 1em;
        }

    </style>

    <script type="text/javascript">
        this.floors = [];
        this.objects = [];
        this.isFloors = true;
        this.currentMenuType = "material";
        this.inputGrade = document.getElementsByName("grade");
        
        this.on("mount", function () {
            console.log("loaded");
            this.getMaterials();
        });

        this.getMaterials = function () {

            const url = '/api/materials';

            fetch(url)
                .then(response => response.json())
                .then(data => {
                    this.objects = data.filter(o => o.IsMaterial === false);
                    this.floors = data.filter(o => o.IsMaterial === true);
                    console.log(this.objects);
                    console.log(this.floors);
                    this.update();
                    $('#floorMaterials').slick({
                        infinite: true,
                        slidesToShow: 3,
                        slidesToScroll: 3
                    });
                });
        }

        this.switchMaterialType = function () {
            this.isFloors = !this.isFloors;
            this.materialTab = document.getElementById('materialTab');
            this.otherTab = document.getElementById('otherTab');
            if (this.isFloors) {
                this.materialTab.classList.add('activeMenuTab');
                this.otherTab.classList.remove('activeMenuTab');
            }
            else {
                this.otherTab.classList.add('activeMenuTab');
                this.materialTab.classList.remove('activeMenuTab');
                
            }
            this.update();
            $('#objectMaterials').slick({
                infinite: true,
                slidesToShow: 3,
                slidesToScroll: 3
            });
        }
    </script>
</build-menu>
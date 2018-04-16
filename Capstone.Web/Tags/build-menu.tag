<build-menu>
    <div class="menuContainer">
        <div id="menuTabsContainer">
            <div class="menuTab activeMenuTab" id="materialTab" onclick="{switchMaterialType}"><i class="fa fa-th"></i></div>
            <div class="menuTab" id="otherTab" onclick="{switchMaterialType}"><i class="fa fa-couch-l"></i></div>
        </div>

        <div class="materialsContainer" id="materialSection" if={isFloors}>
            <div class="materialScroll">
            </div>
            <div class="materials" id="floorMaterials">
                <div class="material" each="{floor, index in floors}" id="floor-{index}">
                    <img onclick="{ setMaterial }" src="/Content/{floor.ImageSource}" class="matImg" />
                    <p>{floor.Name}</p>
                </div>
            </div>
        </div>

        <div class="materialsContainer" id="otherSection" if={!isFloors}>
            <div class="materialScroll">
            </div>
            <div class="materials" id="objectMaterials">
                <div class="material" each="{object, index in objects}" id="object-{index}">
                    <img src="/Content/{object.ImageSource}" class="matImg" style="border-style:none; box-shadow: none" />
                    <p>{object.Name}</p>
                </div>
            </div>
        </div>
    </div>

    <style type="text/css">
        .menuContainer {
            background-color: #18A999;
            width: 100%;
            height: 100%;
            display: inline-block;
            box-shadow: inset 0 0 10px #000;
        }

        .materialsContainer {
            margin-top: 1em;
        }

        .materials {
            height: 100%;
        }

            .materials p {
                display: inline-block;
                background-color: white;
                padding: 5px;
                font-size: 1.5rem;
                align-self: center;
                font-weight: 600;
                text-align: center;
                vertical-align: bottom;
                border-radius: 5px;
                box-shadow: 0 0 10px #000;
            }

        .matImg {
            width: 60%;
            transition-duration: 0.4s;
            margin: 0 auto;
            border: 2px solid white;
            border-radius: 5px;
            box-shadow: 0 0 10px #000;
            cursor: pointer;
        }

            .matImg:hover {
                box-shadow: 0 0 10px #FFF;
            }

        div.slick-track {
            height: 100%;
        }

        #menuTabsContainer {
            display: flex;
            width: 100%;
            margin-top: 0.5em;
        }

        .menuTab {
            display: inline-block;
            width: 50%;
            margin: 0 2px;
            height: 20px;
            border: 2px solid #FFF;
            text-align: center;
            border-radius: 5px;
            cursor: pointer;
        }

        .activeMenuTab {
            background-color: #FFF;
            margin: 0 2px;
            border: 2px solid black;
        }

        .material {
            display: flex;
            flex-direction: column;
            width: 10em !important;
            margin: 10px 0;
            height: 10em !important;
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

        this.setMaterial = function () {
            console.log("Set Material " + this.floor.ImageSource);

            this.opts.bus.trigger("setMaterial", this.floor.ImageSource);
        }

        this.switchMaterialType = function () {
            this.isFloors = !this.isFloors;
            this.materialTab = document.getElementById('materialTab');
            this.otherTab = document.getElementById('otherTab');
            if (this.isFloors) {
                this.materialTab.classList.add('activeMenuTab');
                this.otherTab.classList.remove('activeMenuTab');
                this.update();
                $('#floorMaterials').slick({
                    infinite: true,
                    slidesToShow: 3,
                    slidesToScroll: 3
                });
            }
            else {
                this.otherTab.classList.add('activeMenuTab');
                this.materialTab.classList.remove('activeMenuTab');
                this.update();
                $('#objectMaterials').slick({
                    infinite: true,
                    slidesToShow: 3,
                    slidesToScroll: 3
                });
            }
        }
    </script>
</build-menu>
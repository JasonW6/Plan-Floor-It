<build-menu>
    <div class="menuContainer">

        <div id="menuTabsContainer">
            <div class="glass tab">
                <div class="menuTab activeMenuTab" id="materialTab" onclick="{switchMaterialType}">Flooring</div>
            </div>
            <div class="glass tab">
                <div class="menuTab" id="otherTab" onclick="{switchMaterialType}"><i class="fa fa-couch-l"></i> Appliances & Furniture <i class="fa fa-couch-l"></i></div>
            </div>
        </div>

        <div class="materialsContainer" id="materialSection" if={isFloors}>
            <div class="materialScroll">
            </div>
            <div class="materials" id="floorMaterials">
                
                <div class="material" each="{floor, index in floors}" id="floor-{index}">
                    <div class="glass tiles">
                        <img onclick="{ setMaterial }" src="/Content/{floor.ImageSource}" class="matImg" />
                        <p>{floor.Name}</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="materialsContainer" id="otherSection" if={!isFloors}>
            <div class="materialScroll">
            </div>
            <div class="materials" id="objectMaterials">
                
                <div class="material" each="{object, index in objects}" id="object-{index}">
                    <div class="glass tiles">
                        <img ondblclick="{ addObject }" src="/Content/{object.ImageSource}" class="matImg" style="border-style:none; box-shadow: none" />
                        <p>{object.Name}</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <style type="text/css">
        .menuContainer {
            background-image: url("/Content/concrete.png");
            background-repeat: repeat;
            width: 100%;
			height: 100%;
            display: inline-block;
            box-shadow: inset 0 0 10px #000;
        }

        div.glass.tiles {
            background-color: rgba(255, 255, 255, 0.44);
            height: 80%;
            border-radius: 5px;
            margin: 5px;
            padding: 10px;
            box-shadow: 0 0 10px #000;
        }

            div.glass::before {
                filter: blur(4px);
                content: '';
            }

        .materialsContainer {
        }

        .materials {
            height: 100%;
        }

            .materials p {
                display: block;
                color: white;
                margin: 5px auto;
                padding: 5px;
                font-size: 1.2rem;
                align-self: center;
                font-weight: 600;
                text-align: center;
                box-shadow: inset 0 0 5px #000;
                border-radius: 5px;

            }

        .matImg {
            width: 60%;
            min-height: 87px;
            transition-duration: 0.4s;
            margin: 0 auto;
            border: 2px solid white;
            border-radius: 5px;
            box-shadow: inset 0 0 10px #000;
            cursor: pointer;
        }

            .matImg:hover {
                box-shadow: 0 0 10px #000;
            }

        div.slick-track {
            height: 100%;
        }

        #menuTabsContainer {
            color: white;
            display: flex;
            font-family: sans-serif;
            font-weight: 600;
            width: 75%;
            margin-top: 0.5em;
        }

        .menuTab {
            background-color: rgba(255, 255, 255, 0);
            width: 80%;
            margin-left: 50%;
            height: 20px;
            border: 2px solid #FFF;
            text-align: center;
            border-radius: 5px;
            cursor: pointer;
        }

        .activeMenuTab {
            background-color: rgba(255, 255, 255, 0.44);
            border: 2px solid #FFF;
        }

        .glass.tab {
            justify-content: space-around;
            text-align: center;
            width: 50%;
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
                    this.opts.bus.trigger("getFloorCosts", this.floors);
                    console.log(this.objects);
                    console.log(this.floors);
                    this.update();
                    $('#floorMaterials').slick({
                        infinite: false,
                        slidesToShow: 5,
                        slidesToScroll: 2,
                        arrows: true
                    });
                });
        }

        this.setMaterial = function () {
            console.log("Set Material " + this.floor.ImageSource);

            this.opts.bus.trigger("setMaterial", this.floor.ImageSource);
		}

		this.addObject = function () {
			console.log("Object: " + this.object.ImageSource);
			this.opts.bus.trigger("addObject", this.object.ImageSource);

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
                    infinite: false,
                    slidesToShow: 5,
                    slidesToScroll: 1,
                    arrows: true
                });
            }
            else {
                this.otherTab.classList.add('activeMenuTab');
                this.materialTab.classList.remove('activeMenuTab');
                this.update();
                $('#objectMaterials').slick({
                    infinite: false,
                    slidesToShow: 3,
                    slidesToScroll: 1,
                    arrows: true
                });
            }
        }
    </script>
</build-menu>
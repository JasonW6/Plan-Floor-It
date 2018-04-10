<build-menu>
    <div class="menuContainer">
        <div id="menuTabsContainer">
            <div class="menuTab" onclick="{switchMaterialType}">Material</div>
            <div class="menuTab" onclick="{switchMaterialType}">Other</div>
        </div>

        <div class="materialsContainer" id="materialSection" if={isFloors}>
            <div class="materialScroll">
                <p>
                    Material
                </p>
            </div>
            <div class="materials">
                <div class="material" each="{floors}">
                    <img src="/Content/{ImageSource}" class="matImg" />
                    <p>{Name}</p>
                </div>
            </div>
        </div>

        <div class="materialsContainer" id="otherSection" if={!isFloors}>
          <div class="materialScroll">
            <p>
              Other
            </p>
          </div>
          <div class="materials">
            <div class="material" each="{objects}">
              <img src="/Content/{ImageSource}" />
              <p>{Name}</p>
            </div>
          </div>
        </div>

        <div class="roomContainer">

        </div>
    </div>

    <script type="text/javascript">
        this.floors = [];
        this.objects = [];
        this.isFloors = true;
        this.currentMenuType = "material";

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
                });
        }

        this.switchMaterialType = function () {

                this.isFloors = !this.isFloors;
                this.update();

        }

    </script>
</build-menu>
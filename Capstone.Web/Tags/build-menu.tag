<build-menu>
    <div class="menuContainer" onload="{ getMaterials }">

        <div class="materialsContainer">
            <div class="materialScroll">
                <p><={materialTypeName}=></p>

            </div>
            <div class="materialSection">
                <div class="material" each="materials"> 

                    <img src="materialImg" class="matImg" />
                </div>

            </div>

        </div>

        <div class="roomContainer">

        </div>


    </div>

    <script>

        function getMaterials() {
            const materials = [];

            const url = '/Build/GetMaterials';

            fetch(url)
                .then(response => response.materials)
                .then(data => console.log(data));
        }


    </script>
</build-menu>
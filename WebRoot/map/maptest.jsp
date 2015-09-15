<!DOCTYPE html>
<html>
  <head>
    <title>Simple Map</title>
    <link rel="stylesheet" type="text/css" href="/arcgis_js_api/library/3.4/3.4/js/dojo/dijit/themes/claro/claro.css"/>
    <link rel="stylesheet" type="text/css" href="/arcgis_js_api/library/3.4/3.4/js/esri/css/esri.css" />
    <style>
      html, body, #map {height: 100%;width: 100%;margin: 0;padding: 0;}
    </style>
    <script>var dojoConfig = { parseOnLoad: true };</script>
    <script src="/arcgis_js_api/library/3.4/3.4/init.js"></script>
    <script>
      dojo.require("esri.map");

       function init() {
         var map = new esri.Map("map");
         var dynamicmap = new esri.layers.ArcGISTiledMapServiceLayer("http://localhost:8080/jnds_rest/services/basemap/MapServer");
         //var tiledMapServiceLayer = new esri.layers.ArcGISDynamicMapServiceLayer("http://localhost:8001/jnds_rest/services/basemap/MapServer");
        // map.addLayer(tiledMapServiceLayer);
        map.addLayer(dynamicmap);
         alert('xxxxxxxxxx');
       }

       dojo.addOnLoad(init);
      
    </script>
  </head>

  <body>
    <div id="map" style="width:100%;height:100%;">ccc</div>
  </body>
</html> 
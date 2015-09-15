<!DOCTYPE html>
<html>
  <head>
    <title>Simple Map</title>
    <link rel="stylesheet" type="text/css" href="/arcgis_js_api/library/3.7/3.7/js/dojo/dijit/themes/claro/claro.css"/>
    <link rel="stylesheet" type="text/css" href="/arcgis_js_api/library/3.7/3.7/js/esri/css/esri.css" />
    <style>
      html, body, #map {height: 100%;width: 100%;margin: 0;padding: 0;}
    </style>
    <script>var dojoConfig = { parseOnLoad: true };</script>
    <script src="/arcgis_js_api/library/3.7/3.7/init.js"></script>
    <script>
      dojo.require("esri.map");
      dojo.require("esri.layers.ImageParameters");
      
      dojo.require("esri.layers.MapImageLayer");
      
      
       function init() {
         var map = new esri.Map("map");
         var params = new esri.layers.ImageParameters();
         params.dpi = 600;
         
         //esri.layers.ArcGISTiledMapServiceLayer
         //esri.layers.ArcGISImageServiceLayer
         
         //var dynamicmap1 = new esri.layers.ArcGISImageServiceLayer("http://192.168.1.111:8001/jnds_rest/services/jnds_raster001/ImageServer");
         //var dynamicmap2 = new esri.layers.ArcGISImageServiceLayer("http://192.168.1.111:8001/jnds_rest/services/jnds_raster002/ImageServer");
        // var dynamicmap3 = new esri.layers.ArcGISImageServiceLayer("http://192.168.1.111:8001/jnds_rest/services/jnds_raster003/ImageServer");
         // var dynamicmap4 = new esri.layers.ArcGISImageServiceLayer("http://localhost:8001/jnds_rest/services/JNDS_RASTERTEST/ImageServer");
       //  var dynamicmap2 = new esri.layers.ArcGISDynamicMapServiceLayer("http://localhost:8001/jnds_rest/services/jndsraster002/MapServer");
         var dynamicmap3 = new esri.layers.ArcGISTiledMapServiceLayer("http://localhost:8080/jnds_rest/services/newbasemap/MapServer");
        // var dynamicmap = new esri.layers.ArcGISDynamicMapServiceLayer("http://localhost:8001/jnds_rest/services/newbasemap/MapServer");
         //dynamicmap.dpi = 600;
        // var imageLayer = new esri.layers.MapImageLayer("http://localhost:8001/test1/services/imagetest/ImageServer");
         
        // var tiledMapServiceLayer = new esri.layers.ArcGISDynamicMapServiceLayer("http://localhost:8080/jnds_rest/services/jnds/MapServer");
        // map.addLayer(tiledMapServiceLayer);
       //  map.addLayer(dynamicmap1);
       //  map.addLayer(dynamicmap2);
         map.addLayer(dynamicmap3);
       //  map.addLayer(dynamicmap4);
       //  alert(dynamicmap.dpi);
         alert('xxxxxxxxxx0000111222');
       }

       dojo.addOnLoad(init);
      
    </script>
  </head>

  <body>
    <div id="map" style="width:100%;height:100%;">ccc</div>
  </body>
</html> 
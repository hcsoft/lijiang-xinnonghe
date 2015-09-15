<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/common/inc.jsp"%>
<!DOCTYPE html>
  <head>
    <title>地图查询</title>
    <link rel="stylesheet" type="text/css" href="/arcgis_js_api/library/3.4/3.4/js/dojo/dijit/themes/claro/claro.css"/>
    <link rel="stylesheet" type="text/css" href="/arcgis_js_api/library/3.4/3.4/js/esri/css/esri.css" />
	<link rel="stylesheet" href="/themes/sunny/easyui.css">
	<link rel="stylesheet" href="/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="/css/tablen.css">
	<link rel="stylesheet" href="/css/spectrum.css">

	<script src="/js/jquery-1.8.2.min.js"></script>
	<script src="/js/jquery.easyui.min.js"></script>
	<script src="/js/jquery.json-2.2.js"></script>
	<script src="/js/easyui-lang-zh_CN.js"></script>
	<script src="/js/spectrum.js"></script>
	<script src="config.js"></script>
	<script>var dojoConfig = { parseOnLoad: true };</script>
    <script src="/arcgis_js_api/library/3.4/3.4/init.js"></script>
<script>
	dojo.require("esri.map");
	dojo.require("esri.dijit.OverviewMap");
	dojo.require("esri.layers.FeatureLayer");
	dojo.require("esri.dijit.Popup");

	dojo.require("esri.toolbars.navigation");
	dojo.require("dijit.Toolbar"); 

	var map,navToolbar,dynamicMapServiceLayer,featureLayer3,featureLayer10,featureLayer9,tb;
	var identifyTask, identifyParams;
	var objectid1 = "";
	var drawGeometry = null;
	var belongtowns = "";
	var allFeatureLayers = [];
	function init() {
        var highlightSymbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255,100,0]), 3), new dojo.Color([125,125,125,0.35]));		

		map = new esri.Map("map", {
		  //basemap: "http://localhost:8080/jnds8080-rest/services/jnds-8080/MapServer/3",
		  //center: [-238.499,31.543],
		  //basemap: "osm",
		  zoom: 8,
		  //infoWindow: popup,
		  //nav:true,
		  //logo:false,
		//	  scale:30,
		  //navigationMode: 'css-transforms',
		  //showAttribution:true,
		  //showInfoWindowOnClick:true,
		  
		  slider:false
		});


       navToolbar = new esri.toolbars.Navigation(map); //新建地图工具栏

        //dojo.connect(navToolbar, "onExtentHistoryChange", extentHistoryChangeHandler); //注册一个事件监听器

		dojo.connect(map, "onLoad", initOperationalLayers);
		//dojo.connect(map, "onLoad", initOverviewMap);
		//dojo.connect(map, "onClick", showCoordinates);


		function initOperationalLayers() {
			var defaultSymbol = new esri.symbol.SimpleFillSymbol().setStyle(esri.symbol.SimpleFillSymbol.STYLE_NULL);
			defaultSymbol.outline.setStyle(esri.symbol.SimpleLineSymbol.STYLE_NULL);
			//defaultSymbol.outline.setColor(new dojo.Color([0,255,0, 0.5]));

			//create renderer
			var renderer = new esri.renderer.UniqueValueRenderer(defaultSymbol, "ISRELATION");

			//add symbol for each possible value
			renderer.addValue("01", new esri.symbol.SimpleFillSymbol().setColor(new dojo.Color([0,255,0, 0.5])));//已关联
			renderer.addValue("00", new esri.symbol.SimpleFillSymbol().setColor(new dojo.Color([255, 0, 0, 0.5])));//未关联


		}

		function initOverviewMap(){
			var overviewMapDijit = new esri.dijit.OverviewMap({
				map: map,
				visible: false,
				color:"#D84E13"
			});
			overviewMapDijit.startup();		
		
		}


			

		function loadLayerList(layers){

		
			var visible = [];
			var html = "<div><table border='1' id='layerTable'></table></div>";
			dojo.byId("toc").innerHTML = html;


			var layerTrLable = "<tr><td><input id='checkAllId' type=\"checkbox\" checked='checked' /></td><td width=\"150px\" align=\"center\"><font style=\"font-size: 12px;\">图层名称</font></td><td width=\"200px\" align=\"center\">图层填充颜色</td><td width=\"200px\" align=\"center\">当前图层</td></tr>";
			$("#layerTable").append(layerTrLable);	

			var infos = layers.layerInfos;
			for(var i = 0; i <infos.length; i++){
				var info = infos[i];
				if(info.defaultVisibility){

					for(var k = 0 ;k< layerConfig.length;k++){
						var config = layerConfig[k];
						if((config.layerId == info.id) && (config.config == "true")){
							visible.push(info.id);							
						}
					}
					//visible.push(info.id);
				}

				var featureLayer = new esri.layers.FeatureLayer("<%=mapServerPath%>/MapServer/" + info.id, {
					  mode: esri.layers.FeatureLayer.MODE_ONDEMAND,
					  outFields: ["*"]
					});

				if(info.id == 10){//乡镇级行政区图层
					featureLayer10 = featureLayer;

					dojo.connect(featureLayer10, "onClick", function(evt) {
						graphicAttributes = evt.graphic.attributes;
						//alert(graphicAttributes.XZQDM);
						map.graphics.clear();
						var highlightGraphic = new esri.Graphic(evt.graphic.geometry,highlightSymbol);
						map.graphics.add(highlightGraphic);
							$.ajax({
								   type: "post",
								   url: "/MapAreaDraw/queryTaxpayerinfoByBelongtowns.do",
								   data: {"xzqdm":graphicAttributes.XZQDM},
								   dataType: "json",
								   success: function(jsondata){
									   if(jsondata.retStatus == "00"){
											title = graphicAttributes.OBJECTID;
											content = ""
												  + "<br><b>行政区: </b>" + graphicAttributes.XZQMC 
												  + "<br><b>税源: </b>" + jsondata.taxpayerCount + "户"
												  + "<br><b><a href='javascript:showTaxinfo(" + graphicAttributes.OBJECTID + ")'>税源详细</a> </b>";

											map.infoWindow.setTitle(title);
											map.infoWindow.setContent(content);
											map.infoWindow.show(evt.screenPoint,map.getInfoWindowAnchor(evt.screenPoint));
									   }
								   }
						   });



					});
					

				}

				if(info.id == 9){//村委会级行政区图层
					featureLayer9 = featureLayer;

					dojo.connect(featureLayer9, "onClick", function(evt) {
						graphicAttributes = evt.graphic.attributes;

						map.graphics.clear();
						var highlightGraphic = new esri.Graphic(evt.graphic.geometry,highlightSymbol);
						map.graphics.add(highlightGraphic);

							$.ajax({
								   type: "post",
								   url: "/MapAreaDraw/queryTaxpayerinfoByVillage.do",
								   data: {"xzqdm":graphicAttributes.XZQDM},
								   dataType: "json",
								   success: function(jsondata){
									   if(jsondata.retStatus == "00"){
											title = graphicAttributes.OBJECTID;
											content = ""
												  + "<br><b>行政区: </b>" + graphicAttributes.XZQMC 
												  + "<br><b>税源: </b>" + jsondata.taxpayerCount + "户"
												  + "<br><b><a href='javascript:showTaxinfo(" + graphicAttributes.OBJECTID + ")'>税源详细</a> </b>";

											map.infoWindow.setTitle(title);
											map.infoWindow.setContent(content);
											map.infoWindow.show(evt.screenPoint,map.getInfoWindowAnchor(evt.screenPoint));
									   }
								   }
						   });

					});
					
				}


				if(info.id == 3){//土地出让图层
					featureLayer3 = featureLayer;

					dojo.connect(featureLayer3, "onClick", function(evt) {
						graphicAttributes = evt.graphic.attributes;
						//alert(graphicAttributes.XZQDM);
						map.graphics.clear();
						var highlightGraphic = new esri.Graphic(evt.graphic.geometry,highlightSymbol);
						map.graphics.add(highlightGraphic);

						title = graphicAttributes.OBJECTID;
						content = ""
							  + "<br><b>宗地编号: </b>" + graphicAttributes.ZDBH 
							  + "<br><b><a href='javascript:showTaxinfo(" + graphicAttributes.OBJECTID + ")'>宗地详细</a> </b>"
							  + "<br><b><a href=\"javascript:deleteLayerArea(" + graphicAttributes.OBJECTID + ",'" + graphicAttributes.ISRELATION + "')\">删除宗地</a> </b>";

						map.infoWindow.setTitle(title);
						map.infoWindow.setContent(content);
						map.infoWindow.show(evt.screenPoint,map.getInfoWindowAnchor(evt.screenPoint));



					});
					
				}

				if(info.id == 2){//税源图层
					featureLayer2 = featureLayer;

					var symbol = new esri.symbol.PictureMarkerSymbol({
						"angle"      :0,
						"xoffset"    :0,
						"yoffset"    :10,
						"type"       :"esriPMS",
						"url"        :"BluePin1LargeB.png",
						"contentType":"image/png",
						"width"      :24,
						"height"     :24
					});
					featureLayer2.setRenderer(new esri.renderer.SimpleRenderer(symbol));


					dojo.connect(featureLayer2, "onClick", function(evt) {
						$('#taxinfoEdit').dialog('close');
						graphicAttributes = evt.graphic.attributes;
						title = graphicAttributes.OBJECTID;
						clickObjectid = graphicAttributes.OBJECTID;
						content = "<b>类型: </b>" + graphicAttributes.LX
							  + "<br><b>宗地编号: </b>" + graphicAttributes.ZDBH 
							  + "<br><b><a href='javascript:showTaxinfo(" + graphicAttributes.OBJECTID + ")'>税源详细</a> </b>"
							  + "<br><b><a href=\"javascript:alreadyPointRelation(" + graphicAttributes.OBJECTID + ",'" + graphicAttributes.ZDBH + "')\">关联</a> </b>";

						map.infoWindow.setTitle(title);
						map.infoWindow.setContent(content);
						map.infoWindow.show(evt.screenPoint,map.getInfoWindowAnchor(evt.screenPoint));

					});

					
				}

				//var outline = new esri.symbol.SimpleLineSymbol().setColor(dojo.colorFromHex("#fff"));
				//var sym = new esri.symbol.SimpleFillSymbol().setColor(new dojo.Color([255, 0, 0, 0.1])).setOutline(outline);
				//var rendererT = new esri.renderer.SimpleRenderer(sym);
				//featureLayer.setRenderer(rendererT);
				map.addLayer(featureLayer);

				for(var k = 0 ;k< layerConfig.length;k++){
					var config = layerConfig[k];
					if((config.layerId == info.id) && (config.config == "true")){
						allFeatureLayers.push(featureLayer);							
					}
				}

				


				for(var k = 0;k < layerConfig.length;k++){
					var config = layerConfig[k];
					if((config.layerId == info.id) && (config.config == "true")){
						var layerTr = "<tr><td><input id=\""+info.id+"\" class=\"listCss\" type=\"checkbox\" checked=" + (info.defaultVisibility ? "checked":"")+" /></td><td width=\"150px\" align=\"center\"><font style=\"font-size: 12px;\">" + info.name +" </font></td><td width=\"200px\" align=\"center\">图层填充颜色&nbsp;&nbsp;<input type=\"color\" id=\"fillColor"+ i+"\"/></td><td width=\"200px\" align=\"center\">当前图层&nbsp;&nbsp;<input name=\"currentLayerName\" type=\"radio\" id=\"currentLayer"+i+"\"/></td></tr>";
						$("#layerTable").append(layerTr);						
					}

				}
				
				//alert(featureLayer.renderer.symbol.color);
				$("#fillColor" + info.id).spectrum({
					showPalette: true,
					palette: [
						['black','white','red'],
						['yellow','blue','green']
					],
					//color:featureLayer.renderer.symbol.color,
					index:info.id,
					featureLayer:featureLayer,
					showAlpha: true,
					chooseText: "确定",
					preferredFormat: "rgb",
					showInput: true,
					cancelText: "取消",
					change: function(color) {
							//alert(color.index);
							//alert(color.featureLayer);
							var outline = new esri.symbol.SimpleLineSymbol().setColor(dojo.colorFromHex("#fff"));
							var sym = new esri.symbol.SimpleFillSymbol().setColor(new dojo.Color([color.toRgb().r,color.toRgb().g,color.toRgb().b, color.toRgb().a])).setOutline(outline);
							var renderer = new esri.renderer.SimpleRenderer(sym);
							color.featureLayer.setRenderer(renderer);
							color.featureLayer.refresh();
					}
				});
				$("#" + info.id).live('click',{"featureLayer":featureLayer,"index":i},function(event){
					//alert(JSON.stringify(event.data.zz));
					//alert(zz);
					map.addLayer(event.data.featureLayer);
					var inputs = dojo.query(".listCss");
					visible = [];
					var j = event.data.featureLayer;
					//alert(j);
					for(var i=0;i<inputs.length;i++){
						if(inputs[i].checked){
							visible.push(inputs[i].id);
							if(inputs[i].id == event.data.index){
								map.addLayer(j);
							}								
						}else{
							if(inputs[i].id == event.data.index){
								map.removeLayer(j);
							}						
						}	
					}
					if(visible == ""){
						dynamicMapServiceLayer.hide();
					}else{
						dynamicMapServiceLayer.show();
						dynamicMapServiceLayer.setVisibleLayers(visible);
					}
				
				});

				$("#currentLayer" + info.id).live('click',{"featureLayer":featureLayer,"index":info.id},function(event){
					//alert(JSON.stringify(event.data.zz));
					//alert(zz);
					//alert(event.data.index);
					//map.addLayer(event.data.featureLayer);
					var currentId = "graphicsLayer" + (event.data.index+1);
					//alert(currentId);
					map.reorderLayer(currentId,11);
					//alert(map.layerIds);
					map.graphics.clear();
				});

			}
			dynamicMapServiceLayer.setVisibleLayers(visible);

			//alert(visible);
           $("#checkAllId").click(function() {
				if(this.checked){
					$(".listCss").attr("checked",true);


					for(var k=0;k<layerConfig.length;k++){
						var config = layerConfig[k];
						if(config.config == "true"){
							visible.push(config.layerId);							
						}
					}
					dynamicMapServiceLayer.show();
					dynamicMapServiceLayer.setVisibleLayers(visible);

					for(var d=0;d<=allFeatureLayers.length;d++){
						//alert(allFeatureLayers[d].id);
						map.addLayer(allFeatureLayers[d]);
					}

				}else{
					$(".listCss").attr("checked",false);
					dynamicMapServiceLayer.hide();
						//dynamicMapServiceLayer.show();
						//dynamicMapServiceLayer.setVisibleLayers([]);
					for(var d=0;d<allFeatureLayers.length;d++){
						//alert(d + "--" +allFeatureLayers[d]);
						map.removeLayer(allFeatureLayers[d]);
					}
				}

            });

			var $subBox = $(".listCss");
			$subBox.click(function(){
				$("#checkAllId").attr("checked",$subBox.length == $(".listCss:checked").length ? true : false);
			});


		}



		//var dynamicMapServiceLayer = new esri.layers.ArcGISDynamicMapServiceLayer("http://localhost:7001/jnds_rest/services/jnds-80/MapServer");
		dynamicMapServiceLayer = new esri.layers.ArcGISDynamicMapServiceLayer("<%=mapServerPath%>/MapServer");

		map.addLayer(dynamicMapServiceLayer);

		dojo.connect(dynamicMapServiceLayer,"onLoad",loadLayerList);

		dojo.connect(map, "onLayerAdd", function(layer) {
			//alert(layer.id + "---" + layer.name);
		});

		
		//map.addLayer(featureLayer3);


		





	}


	function extentHistoryChangeHandler() {
		dijit.byId("zoomprev").disabled = navToolbar.isFirstExtent();
		dijit.byId("zoomnext").disabled = navToolbar.isLastExtent();
	}

	dojo.ready(init);


    </script>



    <script type="text/javascript">



	$(function(){   




		$('#layerInfoConfig').bind('click', function(){  
				$('#layerInfoConfigWindow').dialog('open');
		}); 



	});




</script>



  </head>

  <body class="claro" style="overflow:hidden">


		<div id="map" style="position:relative; width:1195px; height:615px; border:1px solid #000;">


			<div style="padding:5px;border:1px solid #ddd">
				<a href="#" id="layerInfoConfig" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-add'">图层选择</a>
				<a href="javascript:navToolbar.zoomToFullExtent();" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-add'">全图</a>
				<a href="javascript:navToolbar.zoomToPrevExtent();" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-add'">前一视图</a>
				<a href="javascript:navToolbar.zoomToNextExtent();" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-add'">后一视图</a>


			</div>

		</div>

		<div id="layerInfoConfigWindow" class="easyui-dialog" title="图层选择" data-options="iconCls:'icon-business1',closed:true,modal:false,collapsible:true"  style="width:450px;height:500px;padding:20px">
			<span id="toc"></span>
		</div>
  </body>
</html>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/common/inc.jsp"%>
<!DOCTYPE html>
  <head>
    <title>税源数据关联</title>
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
	dojo.require("esri.dijit.Legend");
	dojo.require("esri.layers.FeatureLayer");
	dojo.require("esri.dijit.Popup");
	dojo.require("esri.dijit.editing.TemplatePicker-all");

	var map,dynamicMapServiceLayer,featureLayer3,featureLayer10,featureLayer9,tb;
	var identifyTask, identifyParams;
	var estateid = "";
	var objectid1 = "";
	var xzqdm = "";
	var drawGeometry = null;
	var mapX,mapY;
	var belongtowns = "";
	var clickObjectid = "";
	var allFeatureLayers = [];
	function init() {
		
        var highlightSymbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255,100,0]), 3), new dojo.Color([125,125,125,0.35]));

		map = new esri.Map("map", {
		  //basemap: "http://localhost:8080/jnds8080-rest/services/jnds-8080/MapServer/3",
		  //center: [-238.499,31.543],
		  zoom: 13,
		  //infoWindow: popup,
		  //nav:true,
		  //logo:false,
		//	  scale:30,
		  //navigationMode: 'css-transforms',
		  //showAttribution:true,
		  //showInfoWindowOnClick:true,
		  
		  slider:false
		});
		dojo.connect(map, "onLoad", initOperationalLayers);
		//dojo.connect(map, "onLoad", initOverviewMap);
		dojo.connect(map, "onLoad", initToolbar);
		//dojo.connect(map, "onClick", showCoordinates);


		dojo.connect(map, "onClick", function(evt) {
			  //var tt = map.graphics;

			dojo.stopEvent(evt);
			if (evt.ctrlKey === true) {  //delete feature if ctrl key is depressed
				if(map.graphics.graphics[0].geometry.x != "0"){
					map.graphics.remove(map.graphics.graphics[0]);
					belongtowns = "";
				}
			}

         });
		function initToolbar() {
			tb = new esri.toolbars.Draw(map);
			dojo.connect(tb, "onDrawEnd", addGraphic);

			dojo.connect(dojo.byId("drawPoint"),"click", function(){
				tb.activate(esri.toolbars.Draw.POINT);
			});

		}

		function addGraphic(geometry) {
			tb.deactivate(); 
			map.graphics.clear();

			var markerSymbol = new esri.symbol.PictureMarkerSymbol({
			"angle"      :0,
			"xoffset"    :0,
			"yoffset"    :30,
			"type"       :"esriPMS",
			"url"        :"GreenPin1LargeB.png",
			"contentType":"image/png",
			"width"      :24,
			"height"     :24
			});

			var type = geometry.type, symbol;
				if (type === "point") {
					symbol = markerSymbol;
					//定位到土地出让图层获取基础数据
					identifyTask = new esri.tasks.IdentifyTask("<%=mapServerPath%>/MapServer");
					identifyParams = new esri.tasks.IdentifyParameters();
					identifyParams.tolerance = 3;
					identifyParams.returnGeometry = true;
					identifyParams.layerIds = [3];
					identifyParams.layerOption = esri.tasks.IdentifyParameters.LAYER_OPTION_ALL;
					identifyParams.width  = map.width;
					identifyParams.height = map.height;
					identifyParams.geometry = geometry;
					identifyParams.mapExtent = map.extent;
					identifyTask.execute(identifyParams, function(idResults) { 
						//alert(JSON.stringify(idResults));
						var isrelation = idResults[0].feature.attributes.ISRELATION;
						if(isrelation == "00"){
							objectid1= idResults[0].feature.attributes.OBJECTID;
							map.graphics.add(new esri.Graphic(geometry, symbol));
						}else{
							
						}
					});
					mapX = geometry.x;
					mapY = geometry.y;

					//定位到村委会行政区域图层获取基础数据
					identifyTask = new esri.tasks.IdentifyTask("<%=mapServerPath%>/MapServer");
					identifyParams = new esri.tasks.IdentifyParameters();
					identifyParams.tolerance = 3;
					identifyParams.returnGeometry = true;
					identifyParams.layerIds = [9];
					identifyParams.layerOption = esri.tasks.IdentifyParameters.LAYER_OPTION_ALL;
					identifyParams.width  = map.width;
					identifyParams.height = map.height;
					identifyParams.geometry = geometry;
					identifyParams.mapExtent = map.extent;
					identifyTask.execute(identifyParams, function(idResults) { 
						xzqdm = idResults[0].feature.attributes.行政区代码;
						//alert(idResults[0].feature.attributes.行政区代码);
						//var XZQDM = idResults[0].feature.attributes.XZQDM;
						//alert(XZQDM);

					});


				}
				else {

				}
				//alert(JSON.stringify(geometry));
				
				



		}


		dynamicMapServiceLayer = new esri.layers.ArcGISDynamicMapServiceLayer("<%=mapServerPath%>/MapServer");


		map.addLayer(dynamicMapServiceLayer);


		dojo.connect(dynamicMapServiceLayer,"onLoad",loadLayerList);
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

						title = graphicAttributes.OBJECTID;
						content = ""
							  + "<br><b>行政区: </b>" + graphicAttributes.XZQMC;

						map.infoWindow.setTitle(title);
						map.infoWindow.setContent(content);
						map.infoWindow.show(evt.screenPoint,map.getInfoWindowAnchor(evt.screenPoint));



					});
					

				}

				if(info.id == 9){//村委会级行政区图层
					featureLayer9 = featureLayer;

					dojo.connect(featureLayer9, "onClick", function(evt) {
						graphicAttributes = evt.graphic.attributes;
						//alert(graphicAttributes.XZQDM);

						map.graphics.clear();
						var highlightGraphic = new esri.Graphic(evt.graphic.geometry,highlightSymbol);
						map.graphics.add(highlightGraphic);

						title = graphicAttributes.OBJECTID;
						content = ""
							  + "<br><b>行政区: </b>" + graphicAttributes.XZQMC;

						map.infoWindow.setTitle(title);
						map.infoWindow.setContent(content);
						map.infoWindow.show(evt.screenPoint,map.getInfoWindowAnchor(evt.screenPoint));

					});
					
				}


				if(info.id == 3){//土地出让图层
					featureLayer3 = featureLayer;
					var defaultSymbol = new esri.symbol.SimpleFillSymbol().setStyle(esri.symbol.SimpleFillSymbol.STYLE_NULL);
					defaultSymbol.outline.setStyle(esri.symbol.SimpleLineSymbol.STYLE_NULL);
					//create renderer
					var renderer = new esri.renderer.UniqueValueRenderer(defaultSymbol, "ISRELATION");
					//add symbol for each possible value
					renderer.addValue("01", new esri.symbol.SimpleFillSymbol().setColor(new dojo.Color([0,255,0, 0.6])));//已关联
					renderer.addValue("00", new esri.symbol.SimpleFillSymbol().setColor(new dojo.Color([255, 86, 0, 1])));//未关联
					featureLayer3.setRenderer(renderer);
					//alert(featureLayer3.renderer.symbol.color);

					dojo.connect(featureLayer3, "onClick", function(evt) {
						graphicAttributes = evt.graphic.attributes;
						//alert(graphicAttributes.XZQDM);

						map.graphics.clear();
						var highlightGraphic = new esri.Graphic(evt.graphic.geometry,highlightSymbol);
						map.graphics.add(highlightGraphic);

						title = graphicAttributes.OBJECTID;
						content = ""
							  + "<br><b>宗地编号: </b>" + graphicAttributes.ZDBH 
							  + "<br><b><a href='javascript:showTaxinfo(" + graphicAttributes.OBJECTID + ")'>宗地详细</a> </b>";

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
							//map.addLayer(j);

						}else{
							//map.removeLayer(j);
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



		function initOverviewMap(){
			var overviewMapDijit = new esri.dijit.OverviewMap({
				map: map,
				visible: false,
				color:"#D84E13"
			});
			overviewMapDijit.startup();		
		
		}

	}

	function showTaxinfo(objectid){
		$('#taxinfoEditList').datagrid('load',{"objectid":clickObjectid});
		$('#taxinfoEdit').dialog('open');
		//alert(objectid);
	}

	function initOperationalLayers() {
		var defaultSymbol = new esri.symbol.SimpleFillSymbol().setStyle(esri.symbol.SimpleFillSymbol.STYLE_NULL);
		defaultSymbol.outline.setStyle(esri.symbol.SimpleLineSymbol.STYLE_NULL);

		//create renderer
		var renderer = new esri.renderer.UniqueValueRenderer(defaultSymbol, "ISRELATION");

		//add symbol for each possible value
		renderer.addValue("01", new esri.symbol.SimpleFillSymbol().setColor(new dojo.Color([0,255,0, 0.6])));//已关联
		renderer.addValue("00", new esri.symbol.SimpleFillSymbol().setColor(new dojo.Color([255, 0, 0, 0.6])));//未关联

		//featureLayer3.setRenderer(renderer);
		//map.addLayer(featureLayer3);

	}



	dojo.ready(init);


    </script>



    <script type="text/javascript">



	$(function(){   
		$('#autoRelationId').bind('click', function(){  
			$.messager.progress(); 			
			$.ajax({
				   type: "post",
				   url: "/Relation/autoRelation.do",
				   data: {"parm1":"parm1"},
				   dataType: "json",
				   success: function(jsondata){
					   if(jsondata.retStatus == "00"){
							//$.messager.alert('提示','关联成功!');
							$.messager.progress('close');
							//initOperationalLayers();
							$('#initCount').html(jsondata.initCount);
							$('#successCount').html(jsondata.successCount);
							$('#failedCount').html(jsondata.failedCount);
							$('#dlg').dialog('open');

							var symbol = new esri.symbol.PictureMarkerSymbol({
								"angle"      :0,
								"xoffset"    :0,
								"yoffset"    :10,
								"type"       :"esriPMS",
								"url"        :"zzz.gif",
								"contentType":"image/png",
								"width"      :24,
								"height"     :24
							});
							featureLayer2.setRenderer(new esri.renderer.SimpleRenderer(symbol));

							featureLayer3.refresh();
							featureLayer2.refresh();
					   }
				   }
			});			
		}); 

		$('#taxinfoTree').tree({   
			 checkbox: false,   
			 url: '/TreeServlet?pid=0&levels=top',   
			 onBeforeExpand:function(node,param){  
				 $('#taxinfoTree').tree('options').url = "/TreeServlet?pid="+node.id+"&levels=" + node.attributes.levels;
				 //alert(node.id);
			 },               
			onClick:function(node){
				
				if(node.attributes.levels == "5"){
					
					//$('#taxinfoLayout').layout('panel', 'east').panel('resize',{width:100});
					//$('#taxinfoLayout').layout('resize');
					/*
					$('#taxinfo').panel('resize',{
						width: 300,
						height: 540
					});
					$('#taxinfoLayout').layout('collapse','east');  

					**/
					$('#taxinfoList').datagrid('load',{"belongtowns":node.id}); 
				
					
					$('#taxinfo').panel('resize',{
						width: 700,
						height: 540
					});
					$('#taxinfoLayout').layout('expand','east'); 

					
				}
 
			},
			onDblClick:function(node){
				//var node = $('#taxtree').tree('getSelected');
				//$('#taxtree').tree('expand', node.target); 
			}
			 

		});
 

		$('#taxtree').bind('click', function(){  
			$('#taxinfo').dialog('open');

			$('#taxinfo').panel('resize',{
				width: 300,
				height: 540
			});
			$('#taxinfoLayout').layout('collapse','east');  
			/*
			$('#taxinfo').panel('move',{   
			  left:13,   
			  top:50   
			});
			*/
		}); 

		var p = $('#taxinfoList').datagrid('getPager');  
			$(p).pagination({  
			pageSize: 15,//每页显示的记录条数，默认为10  
			pageList: [15],//可以设置每页记录条数的列表  
			showPageList:false
		}); 

		var p = $('#taxinfoEditList').datagrid('getPager');  
			$(p).pagination({  
			pageSize: 15,//每页显示的记录条数，默认为10  
			pageList: [15],//可以设置每页记录条数的列表  
			showPageList:false
		}); 

		$('#taxinfoList').datagrid({
			onLoadSuccess: function(data){
				
				if (data.rows.length > 0) {
					for (var i = 0; i < data.rows.length; i++) {
						//根据operate让某些行不可选
						//alert("---" + data.rows[i].estateseriallayer + "---");
						if (data.rows[i].estateseriallayer != " ") {
							$("input[name='ckzzzz']")[i].disabled = true;
						}
					}
				}

			},
			onClickRow: function(rowIndex, rowData){
				$("input[name='ckzzzz']").each(function(index, el){
					//如果当前的复选框不可选，则不让其选中
					if (el.disabled == true) {
						$('#taxinfoList').datagrid('unselectRow', index);
					}
				})
			}
		});


		$('#drawTool').bind('click', function(){  
				$('#drawToolDiv').dialog('open');
		}); 

		$('#connect1').bind('click', function(){  
				if(estateid == ""){
					$.messager.alert('提示','请先选择一个税源!');
					return;
				}
				if(objectid1 == ""){
					$.messager.alert('提示','请先确定地图上的点资源!');
					return;
				}
				//alert(estateid);
				//alert(objectid1);
				//return;
				$.messager.progress();
				$.ajax({
					   type: "post",
					   url: "/Relation/handRelation1.do",
					   data: {"estateid":estateid,"layoutObjectid":objectid1,"mapX":mapX,"mapY":mapY,"xzqdm":xzqdm},
					   dataType: "json",
					   success: function(jsondata){
						   if(jsondata.retStatus == "00"){
								$.messager.progress('close');
								$.messager.alert('提示','保存成功!');
								objectid1 = "";
								var symbol = new esri.symbol.PictureMarkerSymbol({
									"angle"      :0,
									"xoffset"    :0,
									"yoffset"    :10,
									"type"       :"esriPMS",
									"url"        :"zzz.gif",
									"contentType":"image/png",
									"width"      :24,
									"height"     :24
								});
								featureLayer2.setRenderer(new esri.renderer.SimpleRenderer(symbol));

								featureLayer3.refresh();
								featureLayer2.refresh();
								map.graphics.clear();


						   }
					   }
			   });




		}); 


		$('#layerInfoConfig').bind('click', function(){  
				$('#layerInfoConfigWindow').dialog('open');
		}); 


	});

	function alreadyPointRelation(objectid,ZDBH){
		if(estateid == ""){
			$.messager.alert('提示','请先选择一个税源!');
			return;
		}
		$.messager.progress();
		$.ajax({
			   type: "post",
			   url: "/Relation/handRelation2.do",
			   data: {"estateid":estateid,"pointObjectid":objectid,"pointZDBH":ZDBH},
			   dataType: "json",
			   success: function(jsondata){
				   if(jsondata.retStatus == "00"){
						$.messager.progress('close');
						$.messager.alert('提示','保存成功!');

						var symbol = new esri.symbol.PictureMarkerSymbol({
							"angle"      :0,
							"xoffset"    :0,
							"yoffset"    :10,
							"type"       :"esriPMS",
							"url"        :"zzz.gif",
							"contentType":"image/png",
							"width"      :24,
							"height"     :24
						});
						featureLayer2.setRenderer(new esri.renderer.SimpleRenderer(symbol));

						featureLayer3.refresh();
						featureLayer2.refresh();


				   }
			   }
	   });


	}



</script>



  </head>

  <body class="claro" style="overflow:hidden">




				<div id="map" style="position:relative; width:1195px; height:615px; border:1px solid #000;">


					<div style="padding:5px;border:1px solid #ddd">
						<a href="#" id="autoRelationId" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-add'">自动关联</a>
						<a href="#" class="easyui-menubutton" data-options="menu:'#mm1',iconCls:'icon-edit'">手动关联</a>
						<a href="#" id="layerInfoConfig" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-add'">图层选择</a>
					</div>
					<div id="mm1" style="width:100px;">
						<div id="taxtree">行政区域定位</div>
						<div id="drawTool">绘图工具选择</div>
					</div>

				</div>

				<div id="layerInfoConfigWindow" class="easyui-dialog" title="图层选择" data-options="iconCls:'icon-business1',closed:true,modal:false,collapsible:true"  style="width:450px;height:500px;padding:20px">
					<span id="toc"></span>
				</div>



		<div id="dlg" class="easyui-dialog" title="关联详细信息" style="width:400px;height:180px;padding-top:40px;padding-left:80px;"
				data-options="modal:true,
					closed:true,
					iconCls: 'icon-save'
				">
				本次需要的关联的土地<span id='initCount'></span>宗.</br>
				关联成功<font color='green'><span id='successCount'></span></font>宗.</br>
				关联失败<font color='red'><span id='failedCount'></span></font>宗.</br>
				<div style="padding-top:20px;padding-left:180px;"><a class="easyui-linkbutton"  data-options="iconCls:'icon-cancel'" href="javascript:void(0)" onclick="$('#dlg').window('close')">关闭</a></div>
				
		</div>


		<div id="taxinfo" class="easyui-dialog" title="&nbsp;" data-options="iconCls:'icon-business2',closed:true,modal:false,collapsible:true"  style="width:740px;height:540px;">
			
			<div id="taxinfoLayout" class="easyui-layout" style="width:700px;height:500px;" data-options="fit:true">
				<div data-options="region:'center',split:true" title="">
					<ul id="taxinfoTree"></ul>
				</div>
				<div data-options="region:'east',title:'纳税人信息',iconCls:'icon-ok'" style="width:450px;">
					<table id="taxinfoList" class="easyui-datagrid"
							data-options="rownumbers:true,sortable:true,singleSelect:true,pagination:true,url:'/Relation/getTaxinfoListByBelongtowns.do',border:false,fit:true,fitColumns:true,toolbar:toolbar">
						<thead>
							<tr>
								<th data-options="field:'ckzzzz',checkbox:true"></th>
								<th data-options="field:'taxpayername'" width="180">单位名称</th>
								<th data-options="field:'detailaddress'" width="180">地址</th>
								<th data-options="field:'landarea',align:'right'" width="50">土地面积</th>
								<th data-options="field:'areaofstructure',align:'right'" width="50">房产面积</th>
							</tr>
						</thead>
					</table>
						<script type="text/javascript">
							var toolbar = [{
								text:'选择',
								iconCls:'icon-add',
								handler:function(){
									var taxinfoList = $('#taxinfoList').datagrid('getChecked');
									//alert(taxinfoList[0].estateid);
									if(taxinfoList.length <= 0){
										$.messager.alert('提示','请先选择需要关联的记录!');
										return ;
									}
									//alert(taxinfoList[0].taxpayername);
									$('#taxinfo').window('setTitle','你当前选择是:' + taxinfoList[0].taxpayername);
									$('#taxinfo').panel('resize',{
										width: 300,
										height: 540
									});
									$('#taxinfoLayout').layout('collapse','east');  
									$('#taxinfo').panel('collapse');
									estateid = taxinfoList[0].estateid;
									
								}
							}];
						</script>
				</div>
			</div>

		</div>


		<div id="taxinfoEdit" class="easyui-dialog" title="税源详细信息" data-options="iconCls:'icon-business3',closed:true,modal:false,collapsible:true"  style="width:540px;height:240px;">
			
					<table id="taxinfoEditList" class="easyui-datagrid"
							data-options="rownumbers:true,sortable:true,singleSelect:true,pagination:true,url:'/Relation/getTaxinfoListByObjectid.do',border:false,fit:true,fitColumns:true,toolbar:toolbar2">
						<thead>
							<tr>
								<th data-options="field:'ck',checkbox:true"></th>
								<th data-options="field:'taxpayername'" width="180">单位名称</th>
								<th data-options="field:'detailaddress'" width="180">地址</th>
								<th data-options="field:'landarea',align:'right'" width="50">土地面积</th>
								<th data-options="field:'areaofstructure',align:'right'" width="50">房产面积</th>
							</tr>
						</thead>
					</table>
						<script type="text/javascript">
							var toolbar2 = [{
								text:'解除',
								iconCls:'icon-cancel',
								handler:function(){
									var taxinfoEdit = $('#taxinfoEditList').datagrid('getChecked');
									//alert(taxinfoList[0].estateid);
									if(taxinfoEdit.length <= 0){
										$.messager.alert('提示','请先选择需要解除的税源记录!');
										return ;
									}
									$.messager.confirm('确认删除', '确认要解除在此宗土地上的税源信息吗?', function(r){
										if (r){
											var sendData = {"taxinfoEditRows":taxinfoEdit};
											$.ajax({
												   type: "post",
												   url: "/Relation/cancleTaxinfo.do",
												   data: $.toJSON(sendData),
												   contentType: "application/json; charset=utf-8",
												   dataType: "json",
												   success: function(jsondata){
														if(jsondata == "02"){
															$.messager.alert('提示','解除成功!');
															$('#taxinfoEditList').datagrid('load',{"objectid":clickObjectid});		
															$('#taxinfoTree').tree('reload'); 
														}
														if(jsondata == "01"){
															$.messager.alert('提示','解除成功!');
															$('#taxinfoEdit').dialog('close');	
															featureLayer3.refresh();
															featureLayer2.refresh();
															map.infoWindow.hide();
															
														}

												   }
											});
										}
									});

									
								}
							}];
						</script>
		</div>


		<div id="drawToolDiv" class="easyui-dialog" title="绘图工具栏" data-options="iconCls:'icon-business4',closed:true,modal:false,collapsible:true"  style="width:350px;height:180px;padding:20px">

			<div class="easyui-tabs" style="width:200px;height:100px">
				<div title="标注税源点" style="padding:20px">
					<button id="drawPoint" data-dojo-type="dijit.form.Button">点</button>
					<button id="connect1">税源关联</button>
				</div>
			</div>
				
		</div>


  </body>
</html>

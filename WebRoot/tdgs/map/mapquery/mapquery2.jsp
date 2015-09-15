<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/common/inc.jsp"%>
<!DOCTYPE html>
  <head>
    <title>电子地图查询</title>
    <link rel="stylesheet" type="text/css" href="/arcgis_js_api/library/3.4/3.4/js/dojo/dijit/themes/claro/claro.css"/>
    <link rel="stylesheet" type="text/css" href="/arcgis_js_api/library/3.4/3.4/js/esri/css/esri.css" />
	<link rel="stylesheet" href="/themes/sunny/easyui.css">
	<link rel="stylesheet" href="/themes/icon.css">
	<link rel="stylesheet" href="/css/tablen.css">
	<link rel="stylesheet" href="/css/spectrum.css">
	<script src="/js/jquery-1.8.2.min.js"></script>
	<script src="/js/jquery.easyui.min.js"></script>
	<script src="/js/jquery.json-2.2.js"></script>
	<script src="/js/easyui-lang-zh_CN.js"></script>
	<script src="/js/spectrum.js"></script>
	<script src="../config.js"></script>
	<script src="/js/datecommon.js"></script>	
	<script src="/js/datagrid-detailview.js"></script>


	<script>var dojoConfig = { parseOnLoad: true };</script>
    <script src="/arcgis_js_api/library/3.4/3.4/init.js"></script>
<script>
	dojo.require("esri.map");
	dojo.require("esri.dijit.OverviewMap");
	dojo.require("esri.layers.FeatureLayer");
	dojo.require("esri.dijit.Popup");

	dojo.require("esri.toolbars.navigation");
	dojo.require("dijit.Toolbar"); 
	dojo.require("dijit.layout.ContentPane");
	dojo.require("dijit.layout.TabContainer");

	var map,navToolbar,dynamicMapServiceLayer,featureLayer3,featureLayer10,featureLayer9,tb;
	var identifyTask, identifyParams;
	var objectid1 = "";
	var drawGeometry = null;
	var belongtowns = "";
	var allFeatureLayers = [];

	var belongtownsId = "";
	var villageId = "";
	var tdgyId = "";
	var taxpayerinfoId = "";
	for(var i=0;i<featureConfig.length;i++){
		if(featureConfig[i].layer == "belongtowns"){
			belongtownsId = featureConfig[i].layerId;
		}
		if(featureConfig[i].layer == "village"){
			villageId = featureConfig[i].layerId;
		}
		if(featureConfig[i].layer == "tdgy"){
			tdgyId = featureConfig[i].layerId;
		}
		if(featureConfig[i].layer == "taxpayerinfo"){
			taxpayerinfoId = featureConfig[i].layerId;
		}
	}

	function init() {
        var highlightSymbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255,100,0]), 3), new dojo.Color([125,125,125,0.35]));		

		map = new esri.Map("map", {
		  //basemap: "http://localhost:8080/jnds8080-rest/services/jnds-8080/MapServer/3",
		  //center: [-238.499,31.543],
		  //basemap: "osm",
		  zoom: 1,
		  //infoWindow: popup,
		  //nav:true,
		  logo:false,
		//	  scale:30,
		  //navigationMode: 'css-transforms',
		  //showAttribution:true,
		  //showInfoWindowOnClick:true,
		  
		  slider:false
		});
		//map.infoWindow.setContent(dijit.byId("detailId").domNode);

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
				color:"#ddd",
				expandFactor:4,
				baseLayer:new esri.layers.ArcGISDynamicMapServiceLayer("<%=mapServerPath%>/jnds/MapServer")
			});
			overviewMapDijit.startup();		
		
		}


			

		function loadLayerList(layers){

		
			var visible = [];
			var html = "<div><table border='1' id='layerTable'></table></div>";
			dojo.byId("toc").innerHTML = html;


			var layerTrLable = "<tr><td><input id='checkAllId' type=\"checkbox\" checked='checked' /></td><td width=\"150px\" align=\"center\"><font style=\"font-size: 12px;\">图层名称</font></td><td width=\"200px\" align=\"center\">图层填充颜色</td><td width=\"200px\" align=\"center\">当前图层</td></tr>";
			$("#layerTable").append(layerTrLable);	

			var convertLayerinfo = [];
			//alert(JSON.stringify(layers.layerInfos));
			for(var i = 0; i <layers.layerInfos.length; i++){
				var info = layers.layerInfos[i];
					for(var j=0;j<layerConfig.length;j++){
						var config = layerConfig[j];
						if((config.layerId == info.id) && (config.config == "true")){
							convertLayerinfo.push(info);
						}
						if((config.layerId == info.id) && (config.config == "false")){
					
						}
					}

			}

			for(var i = 0; i <convertLayerinfo.length; i++){
				var info = convertLayerinfo[i];

				visible.push(info.id);

				if(info.id == 4){
					 featureLayer = new esri.layers.FeatureLayer("<%=mapServerPath%>/jnds/MapServer/" + info.id, {
					  mode: esri.layers.FeatureLayer.MODE_SELECTION,
					  outFields: ["*"]  //可以通过图层获取当前的FetureClass的所有属性
					});
                }else{
                	featureLayer = new esri.layers.FeatureLayer("<%=mapServerPath%>/jnds/MapServer/" + info.id, {
					  mode: esri.layers.FeatureLayer.MODE_ONDEMAND,
					  outFields: ["*"]  //可以通过图层获取当前的FetureClass的所有属性
					});
                }

				if(info.id == belongtownsId){//乡镇级行政区图层
					featureLayer10 = featureLayer;

					dojo.connect(featureLayer10, "onClick", function(evt) {
						graphicAttributes = evt.graphic.attributes;
						//alert(graphicAttributes.XZQDM);
						map.graphics.clear();
						var highlightGraphic = new esri.Graphic(evt.graphic.geometry,highlightSymbol);
						map.graphics.add(highlightGraphic);

						$('#estateSumInfoId').datagrid('load',{"type":"byBelongtowns","estateseriallayer":"","xzqdm":graphicAttributes.XZQDM,"yearId":"2012"});
						$('#estateInfoId').datagrid('load',{"type":"byBelongtowns","estateseriallayer":"","xzqdm":graphicAttributes.XZQDM,"yearId":"2012"}); 
						$('#estateInfoId').datagrid({
							onClickRow: function(rowIndex,rowData){

							   var paramsArg = {};
							   paramsArg['estateid'] = rowData.estateid;
							   var opts = $('#shouldtaxmaingrid').datagrid('options');
							   opts.url = '/landviewanalizy/selectshouldtaxyeartax.do?d='+new Date();
							   $('#shouldtaxmaingrid').datagrid('load',paramsArg); 
							   $('#shouldtaxmaingridDiv').dialog('open');

							}
						});
						var p = $('#estateInfoId').datagrid('getPager');  
						$(p).pagination({  
							pageSize: 15,//每页显示的记录条数，默认为10  
							pageList: [15],//可以设置每页记录条数的列表  
							showPageList:false
						}); 


					});
					
				}

				if(info.id == villageId){//村委会级行政区图层
					featureLayer9 = featureLayer;

					dojo.connect(featureLayer9, "onClick", function(evt) {
						graphicAttributes = evt.graphic.attributes;

						map.graphics.clear();
						var highlightGraphic = new esri.Graphic(evt.graphic.geometry,highlightSymbol);
						map.graphics.add(highlightGraphic);

						$('#estateSumInfoId').datagrid('load',{"type":"byBelongtowns","estateseriallayer":"","xzqdm":graphicAttributes.XZQDM,"yearId":"2012"}); 
						$('#estateInfoId').datagrid('load',{"type":"byBelongtowns","estateseriallayer":"","xzqdm":graphicAttributes.XZQDM,"yearId":"2012"}); 
						$('#estateInfoId').datagrid({
							onClickRow: function(rowIndex,rowData){
								//alert(rowData.get);

							   var paramsArg = {};
							   paramsArg['estateid'] = rowData.estateid;
							   var opts = $('#shouldtaxmaingrid').datagrid('options');
							   opts.url = '/landviewanalizy/selectshouldtaxyeartax.do?d='+new Date();
							   $('#shouldtaxmaingrid').datagrid('load',paramsArg); 
							   $('#shouldtaxmaingridDiv').dialog('open');

							}
						});
						var p = $('#estateInfoId').datagrid('getPager');  
						$(p).pagination({  
							pageSize: 15,//每页显示的记录条数，默认为10  
							pageList: [15],//可以设置每页记录条数的列表  
							showPageList:false
						}); 


				

					});
					
				}


				if(info.id == tdgyId){//土地出让图层
					featureLayer3 = featureLayer;

					dojo.connect(featureLayer3, "onClick", function(evt) {
						graphicAttributes = evt.graphic.attributes;
						//alert(graphicAttributes.地块编号);
						map.graphics.clear();
						var highlightGraphic = new esri.Graphic(evt.graphic.geometry,highlightSymbol);
						map.graphics.add(highlightGraphic);

						$('#estateSumInfoId').datagrid('load',{"type":"byEstateserialno","estateseriallayer":graphicAttributes.地块编号,"xzqdm":"","yearId":"2012"}); 
						$('#estateInfoId').datagrid('load',{"type":"byEstateserialno","estateseriallayer":graphicAttributes.地块编号,"xzqdm":"","yearId":"2012"}); 
						$('#estateInfoId').datagrid({
							onClickRow: function(rowIndex,rowData){

							   var paramsArg = {};
							   paramsArg['estateid'] = rowData.estateid;
							   var opts = $('#shouldtaxmaingrid').datagrid('options');
							   opts.url = '/landviewanalizy/selectshouldtaxyeartax.do?d='+new Date();
							   $('#shouldtaxmaingrid').datagrid('load',paramsArg); 
							   $('#shouldtaxmaingridDiv').dialog('open');

							}
						});
						var p = $('#estateInfoId').datagrid('getPager');  
						$(p).pagination({  
							pageSize: 15,//每页显示的记录条数，默认为10  
							pageList: [15],//可以设置每页记录条数的列表  
							showPageList:false
						}); 



					});
					
				}

				if(info.id == taxpayerinfoId){//税源图层
					featureLayer2 = featureLayer;
					var symbol1 = new esri.symbol.PictureMarkerSymbol({
						"angle"      :0,
						"xoffset"    :0,
						"yoffset"    :10,
						"type"       :"esriPMS",
						"url"        :"/images/RedPin1LargeB.png",
						"contentType":"image/png",
						"width"      :24,
						"height"     :24
					});

					var symbol2 = new esri.symbol.PictureMarkerSymbol({
						"angle"      :0,
						"xoffset"    :0,
						"yoffset"    :10,
						"type"       :"esriPMS",
						"url"        :"/images/GreenPin1LargeB.png",
						"contentType":"image/png",
						"width"      :24,
						"height"     :24
					});
					var defaultSymbol = new esri.symbol.SimpleFillSymbol().setStyle(esri.symbol.SimpleFillSymbol.STYLE_NULL);
					defaultSymbol.outline.setStyle(esri.symbol.SimpleLineSymbol.STYLE_NULL);
					var renderer = new esri.renderer.UniqueValueRenderer(defaultSymbol, "ARREARFLAG");
					//add symbol for each possible value
					renderer.addValue("01", symbol1);//已关联
					renderer.addValue("00", symbol2);//未关联


					featureLayer2.setRenderer(renderer);


					dojo.connect(featureLayer2, "onClick", function(evt) {
						var graphicAttributes = evt.graphic.attributes;
						//alert(graphicAttributes.ZDBH);

						$('#estateSumInfoId').datagrid('load',{"type":"byEstateserialno","estateseriallayer":graphicAttributes.ZDBH,"xzqdm":"","yearId":"2012"}); 
						$('#estateInfoId').datagrid('load',{"type":"byEstateserialno","estateseriallayer":graphicAttributes.ZDBH,"xzqdm":"","yearId":"2012"}); 		
						$('#estateInfoId').datagrid({
							onClickRow: function(rowIndex,rowData){
							   //alert(rowData.estateid);
								
							   var paramsArg = {};
							   paramsArg['estateid'] = rowData.estateid;
							   var opts = $('#shouldtaxmaingrid').datagrid('options');
							   opts.url = '/landviewanalizy/selectshouldtaxyeartax.do?d='+new Date();
							   $('#shouldtaxmaingrid').datagrid('load',paramsArg); 
							   $('#shouldtaxmaingridDiv').dialog('open');

							}
						});

						var p = $('#estateInfoId').datagrid('getPager');  
						$(p).pagination({  
							pageSize: 15,//每页显示的记录条数，默认为10  
							pageList: [15],//可以设置每页记录条数的列表  
							showPageList:false
						}); 


					});

					
				}

				//var outline = new esri.symbol.SimpleLineSymbol().setColor(dojo.colorFromHex("#fff"));
				//var sym = new esri.symbol.SimpleFillSymbol().setColor(new dojo.Color([255, 0, 0, 0.1])).setOutline(outline);
				//var rendererT = new esri.renderer.SimpleRenderer(sym);
				//featureLayer.setRenderer(rendererT);
				map.addLayer(featureLayer);

				allFeatureLayers.push(featureLayer);							



				var layerTr = "<tr><td><input id=\""+info.id+"\" class=\"listCss\" type=\"checkbox\" checked=" + (info.defaultVisibility ? "checked":"")+" /></td><td width=\"150px\" align=\"center\"><font style=\"font-size: 12px;\">" + info.name +" </font></td><td width=\"200px\" align=\"center\">图层填充颜色&nbsp;&nbsp;<input type=\"color\" id=\"fillColor"+info.id+"\"/></td><td width=\"200px\" align=\"center\">当前图层&nbsp;&nbsp;<input name=\"currentLayerName\" type=\"radio\" id=\"currentLayer"+info.id+"\"/></td></tr>";
				$("#layerTable").append(layerTr);						

				
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
				$("#" + info.id).live('click',{"featureLayer":featureLayer,"index":info.id},function(event){
					//alert(JSON.stringify(event.data.zz));
					//alert(zz);
					map.graphics.clear();
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

				$("#currentLayer" + info.id).live('click',{"featureLayer":featureLayer,"index":i},function(event){
					//alert(JSON.stringify(event.data.zz));
					//alert(zz);
					//alert(event.data.index);
					//map.addLayer(event.data.featureLayer);
					var currentId = "graphicsLayer" + (event.data.index+2);
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

		var arcGISTiledMapServiceLayer = new esri.layers.ArcGISTiledMapServiceLayer("<%=mapServerPath%>/basemap/MapServer");

		map.addLayer(arcGISTiledMapServiceLayer);

		//arcGISTiledMapServiceLayer.hide();

		//var dynamicMapServiceLayer = new esri.layers.ArcGISDynamicMapServiceLayer("http://localhost:7001/jnds_rest/services/jnds-80/MapServer");
		dynamicMapServiceLayer = new esri.layers.ArcGISDynamicMapServiceLayer("<%=mapServerPath%>/jnds/MapServer");

		dynamicMapServiceLayer.setOpacity(0.2);

		map.addLayer(dynamicMapServiceLayer);

		dojo.connect(dynamicMapServiceLayer,"onLoad",loadLayerList);

		dojo.connect(map, "onLayerAdd", function(layer) {
			//alert(layer.id + "---" + layer.name);
		});

		
        var layersLoaded = 0;  
        var loading = dojo.byId("loadingImg");
        dojo.connect(map, "onZoomStart", showLoading);
        dojo.connect(map, "onPanStart", showLoading);
		dojo.connect(dynamicMapServiceLayer, "onUpdate", hideLoading);
		dojo.connect(arcGISTiledMapServiceLayer, "onUpdate", hideLoading);

        function showLoading(){
           esri.show(loading);
           map.disableMapNavigation();
           //map.hideZoomSlider();
        }

        function hideLoading(){
           layersLoaded++;
		   //alert(layersLoaded + "---" + map.layerIds.length);
           if (layersLoaded === map.layerIds.length-1) {
             esri.hide(loading);
             map.enableMapNavigation();
             //map.showZoomSlider();
             layersLoaded = 0;
           }
        }

		





	}


	function extentHistoryChangeHandler() {
		dijit.byId("zoomprev").disabled = navToolbar.isFirstExtent();
		dijit.byId("zoomnext").disabled = navToolbar.isLastExtent();
	}

	dojo.ready(init);


    </script>



    <script type="text/javascript">



	$(function(){   

		$('#shouldtaxmaingrid').datagrid(
		   {
			   view:detailview,
			   detailFormatter:function(index,row){
				  return '<div style="padding:2px;" ><table id="ddvv-' + index + '"></table></div>';
			   },
			   onExpandRow: function(index,row){
				   if(row.state == 99){
					   return;
				   }
				   $('#ddvv-'+index).datagrid({
				   fitColumns:true,
				   singleSelect:true,
				   rownumbers:true,
				   loadMsg:'正在处理，请稍候......',
				   height:'auto',
				   columns:[[
					  {field:'taxpayerid',title:'计算机编码',width:100,align:'center'},
					  {field:'taxpayername',title:'纳税人名称',width:230,align:'left'},
					  {field:'taxtypename',title:'税种',width:160,align:'center'},
					  {field:'taxname',title:'税目',width:160,align:'center'},
					  {field:'begindate',title:'计税起日期',width:100,align:'center',formatter:formatterDate},
					  {field:'enddate',title:'计税止日期',width:100,align:'center',formatter:formatterDate},
					  {field:'subtaxamount',title:'应缴金额',width:100,align:'center'},
					  {field:'subtaxamountactual',title:'实缴金额',width:100,align:'center'},
					 //  {field:'levydatetypename',title:'征期类型',width:100,align:'center'},
					   {field:'derateflagname',title:'类型',width:100,align:'center'}
					]],
				   onResize:function(){
						$('#shouldtaxmaingrid').datagrid('fixDetailRowHeight',index);
					},
					onLoadSuccess:function(){
					   setTimeout(function(){
						   $('#shouldtaxmaingrid').datagrid('fixDetailRowHeight',index);
					   },0);
				   }
				  });
				  var whereCondition = " and taxtypecode = '"+row.taxtypecode+"' and taxcode = '"+row.taxcode+"' and taxyear = '"+row.year+"' ";
				  var estateRow = $('#estateInfoId').datagrid('getSelected');
				  if(estateRow != null){
					  var estateid = estateRow.estateid;
					  var paramsArg = {};
					  paramsArg['wherecondition'] = whereCondition;
					  paramsArg['estateid'] = estateRow.estateid;
					  var opts = $('#ddvv-'+index).datagrid('options');
					  opts.url = '/landviewanalizy/selectshouldtaxdetail.do?d='+new Date();
					  $('#ddvv-'+index).datagrid('load',paramsArg); 
				  }
				  $('#shouldtaxmaingrid').datagrid('fixDetailRowHeight',index);
			   }
		   }	
		);

		var p = $('#estateInfoId').datagrid('getPager');  
		$(p).pagination({  
			pageSize: 15,//每页显示的记录条数，默认为10  
			pageList: [15],//可以设置每页记录条数的列表  
			showPageList:false
		}); 
		$('#layerInfoConfig').bind('click', function(){  
				$('#layerInfoConfigWindow').dialog('open');
		}); 

		$('#taxpayernameQueryId').bind('click', function(){  
				$('#positionDiv').dialog('open');
		}); 


		$('#positonButtonId').bind('click', function(){  
			var taxpayerid = $('#taxpayeridId').val();
			var taxpayername = $('#taxpayernameId').val();
			//alert(taxpayerid);
			//alert(taxpayername);

			if((taxpayerid == null || taxpayerid == "") && (taxpayername == null || taxpayername == "")){
				$.messager.alert('提示','计算机编码和纳税人名称不能同时为空!');
				return;
			}
			$('#payerInfoId').datagrid('load',{"taxpayerid":taxpayerid,"taxpayername":taxpayername}); 



		
		}); 



		$('#payerInfoId').datagrid({
			onDblClickRow: function(rowIndex, rowData){
				for(var i=0;i<featureLayer3.graphics.length;i++){
					var graphics = featureLayer3.graphics[i];
					var taxpayername = graphics.attributes.受让单位;
					var ZDBH = graphics.attributes.ZDBH;
					var x = graphics.attributes.X;
					var y = graphics.attributes.Y;
					if(rowData.estateseriallayer == ZDBH){
						var centerPoint = new esri.geometry.Point(x, y, new esri.SpatialReference({ wkid: 2358 }));
						map.centerAndZoom(centerPoint,5);	
						var geometry = graphics.geometry;
						map.graphics.clear();
						var highlightSymbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255,100,0]), 3), new dojo.Color([125,125,125,0.35]));
						var highlightGraphic = new esri.Graphic(geometry,highlightSymbol);
						map.graphics.add(highlightGraphic);
						break;
					}
				}

				$('#estateSumInfoId').datagrid('load',{"type":"byEstateserialno","estateseriallayer":rowData.estateseriallayer,"xzqdm":"","yearId":"2012"}); 
				$('#estateInfoId').datagrid('load',{"type":"byEstateserialno","estateseriallayer":rowData.estateseriallayer,"xzqdm":"","yearId":"2012"}); 		
				$('#estateInfoId').datagrid({
					onClickRow: function(rowIndex,rowData){

					   var paramsArg = {};
					   paramsArg['estateid'] = rowData.estateid;
					   var opts = $('#shouldtaxmaingrid').datagrid('options');
					   opts.url = '/landviewanalizy/selectshouldtaxyeartax.do?d='+new Date();
					   $('#shouldtaxmaingrid').datagrid('load',paramsArg); 
					   $('#shouldtaxmaingridDiv').dialog('open');

					}
				});
				var p = $('#estateInfoId').datagrid('getPager');  
				$(p).pagination({  
					pageSize: 15,//每页显示的记录条数，默认为10  
					pageList: [15],//可以设置每页记录条数的列表  
					showPageList:false
				}); 


			}
		});


		$('#zdbhQueryId').bind('click', function(){  
				$('#zdbhDiv').dialog('open');
		}); 


		$('#zdbhButtonId').bind('click', function(){  
			var zdbh = $('#zdbhId').val();

			if(zdbh == null || zdbh == ""){
				$.messager.alert('提示','宗地编号不能为空!');
				return;
			}
			$('#payerInfo2Id').datagrid('load',{"zdbh":zdbh}); 



		
		}); 


		$('#payerInfo2Id').datagrid({
			onDblClickRow: function(rowIndex, rowData){
				for(var i=0;i<featureLayer3.graphics.length;i++){
					var graphics = featureLayer3.graphics[i];
					var taxpayername = graphics.attributes.受让单位;
					var ZDBH = graphics.attributes.ZDBH;
					var x = graphics.attributes.X;
					var y = graphics.attributes.Y;
					if(rowData.estateseriallayer == ZDBH){
						var centerPoint = new esri.geometry.Point(x, y, new esri.SpatialReference({ wkid: 2358 }));
						map.centerAndZoom(centerPoint,5);	
						var geometry = graphics.geometry;
						map.graphics.clear();
						var highlightSymbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255,100,0]), 3), new dojo.Color([125,125,125,0.35]));
						var highlightGraphic = new esri.Graphic(geometry,highlightSymbol);
						map.graphics.add(highlightGraphic);
						break;
					}
				}

				$('#estateSumInfoId').datagrid('load',{"type":"byEstateserialno","estateseriallayer":rowData.estateseriallayer,"xzqdm":"","yearId":"2012"}); 
				$('#estateInfoId').datagrid('load',{"type":"byEstateserialno","estateseriallayer":rowData.estateseriallayer,"xzqdm":"","yearId":"2012"}); 		
				$('#estateInfoId').datagrid({
					onClickRow: function(rowIndex,rowData){

					   var paramsArg = {};
					   paramsArg['estateid'] = rowData.estateid;
					   var opts = $('#shouldtaxmaingrid').datagrid('options');
					   opts.url = '/landviewanalizy/selectshouldtaxyeartax.do?d='+new Date();
					   $('#shouldtaxmaingrid').datagrid('load',paramsArg); 
					   $('#shouldtaxmaingridDiv').dialog('open');

					}
				});

				var p = $('#estateInfoId').datagrid('getPager');  
				$(p).pagination({  
					pageSize: 15,//每页显示的记录条数，默认为10  
					pageList: [15],//可以设置每页记录条数的列表  
					showPageList:false
				}); 

			}
		});


	});

	function formatterDate(value,row,index){
			return formatDatebox(value);
    }

</script>



  </head>

  <body style="overflow:hidden"  class="easyui-layout">


		<div data-options="region:'north',border:false" style="padding:5px;border:1px solid #ddd">
			<a href="#" id="treePositionId" class="easyui-linkbutton" data-options="plain:false,iconCls:'icon-position'">地图定位</a>
			<a href="javascript:navToolbar.zoomToPrevExtent();" class="easyui-linkbutton" data-options="plain:false,iconCls:'icon-lastExtent'">前一视图</a>
			<a href="javascript:navToolbar.zoomToNextExtent();" class="easyui-linkbutton" data-options="plain:false,iconCls:'icon-nextExtent'">后一视图</a>
			<a href="javascript:navToolbar.zoomToFullExtent();" class="easyui-linkbutton" data-options="plain:false,iconCls:'icon-globeLarge'">全图范围</a>
			<a href="#" id="layerInfoConfig" class="easyui-linkbutton" data-options="plain:false,iconCls:'icon-layerConfig'">图层控制</a>
			<a href="#" id="taxpayernameQueryId" class="easyui-linkbutton" data-options="plain:false,iconCls:'icon-layerConfig'">企业查询</a>
			<a href="#" id="zdbhQueryId" class="easyui-linkbutton" data-options="plain:false,iconCls:'icon-layerConfig'">宗地查询</a>
		</div>

		<div id="map" data-options="region:'center'">


		</div>


		<div data-options="region:'east',split:true,collapsed:false" style="width:420px;padding:0px;">

			<div id="aa" class="easyui-accordion" data-options="fit:true,animate:true">

				<div title="汇总信息" style="overflow:hidden;padding:0px;">

						<table id="estateSumInfoId" class="easyui-datagrid" style="width:410px;height:300px;padding:0px;"
								data-options="rownumbers:true,singleSelect:true,collapsible:true,url:'/MapQuery/getSumInfo.do'">
							<thead>
								<tr>
									<th data-options="field:'fieldtype',width:150">项目</th>
									<th data-options="field:'fieldvalue',width:200">结果</th>
								</tr>
							</thead>
						</table>

				</div>

				<div title="宗地信息" style="overflow:hidden;padding:0px;">

						<table id="estateInfoId" class="easyui-datagrid" style="width:420px;height:450px;padding:0px;"
								data-options="pagination:true,rownumbers:true,singleSelect:true,collapsible:true,url:'/MapQuery/getEstateInfo.do'">
							<thead>
								<tr>
									<th data-options="field:'estateserialno',width:70">宗地编号</th>
									<th data-options="field:'taxpayername',width:150">受让单位</th>
									<th data-options="field:'detailaddress',width:150">坐落地</th>
									<th data-options="field:'taxarea',width:60,align:'right'">宗地面积</th>
									<th data-options="field:'landmoney',width:60,align:'right'">获得土地总价</th>
								</tr>
							</thead>
						</table>

				</div>








			</div>

		</div>





		<img id="loadingImg" src="/images/loading.gif" style="position:absolute; right:702px; top:256px; z-index:100;" />


		<div id="layerInfoConfigWindow" class="easyui-dialog" title="图层控制" data-options="iconCls:'icon-business1',closed:true,modal:false,collapsible:true"  style="width:450px;height:500px;padding:20px">
			<span id="toc"></span>
		</div>

		<div id="positioninfo" class="easyui-dialog" title="&nbsp;" data-options="iconCls:'icon-business2',closed:true,modal:false,collapsible:true"  style="width:300px;height:500px;">
			
			<div id="positionLayout" class="easyui-layout" style="width:280px;height:500px;" data-options="fit:true">
				<div data-options="region:'center',split:true" title="">
					<ul id="positionTree" data-options="animate:true"></ul>
				</div>
			</div>
		</div>

		<div id="positionDiv" class="easyui-dialog" title="纳税人查询" data-options="iconCls:'icon-search',closed:true,modal:false,collapsible:true"  style="width:550px;padding:5px">
			计算机编码：<input type="text" id="taxpayeridId" style="width:200px;"/></br>
			纳税人名称：<input type="text" id="taxpayernameId" style="width:200px;"/>
			<a href="#" id="positonButtonId" class="easyui-linkbutton" data-options="plain:false,iconCls:'icon-search'">查询</a>
			<table id="payerInfoId"  class="easyui-datagrid" style="width:510px;height:150px;padding:5px"
					data-options="singleSelect:true,fitColumns:true,collapsible:true,url:'/MapQuery/queryTaxpayerInfo.do'">
				<thead>
					<tr>
						<th data-options="field:'taxpayerid',width:100">计算机编码</th>
						<th data-options="field:'taxpayername',width:200">纳税人名称</th>
						<th data-options="field:'detailaddress',width:200">地址</th>
						
					</tr>
				</thead>
			</table>

		</div>

		<div id="zdbhDiv" class="easyui-dialog" title="宗地查询" data-options="iconCls:'icon-search',closed:true,modal:false,collapsible:true"  style="width:550px;padding:5px">
			宗地编号：<input type="text" id="zdbhId" style="width:200px;"/>
			<a href="#" id="zdbhButtonId" class="easyui-linkbutton" data-options="plain:false,iconCls:'icon-search'">查询</a>
			<table id="payerInfo2Id"  class="easyui-datagrid" style="width:510px;height:150px;padding:5px"
					data-options="singleSelect:true,fitColumns:true,collapsible:true,url:'/MapQuery/queryTaxpayerInfoByZdbh.do'">
				<thead>
					<tr>
						<th data-options="field:'taxpayerid',width:100">计算机编码</th>
						<th data-options="field:'taxpayername',width:200">纳税人名称</th>
						<th data-options="field:'detailaddress',width:200">地址</th>
						
					</tr>
				</thead>
			</table>

		</div>

		<div id="shouldtaxmaingridDiv" class="easyui-dialog" title="应纳税信息" data-options="iconCls:'icon-business1',closed:true,modal:false,collapsible:true"  style="width:950px;padding:10px">

			<table id='shouldtaxmaingrid' class="easyui-datagrid" style="height:500px;overflow: hidden;"
				  data-options="iconCls:'icon-edit',singleSelect:true">
				<thead>
					<tr>
						<th data-options="field:'year',width:200,align:'center',editor:{type:'validatebox'}">年份</th>
						<th data-options="field:'taxtypename',width:240,align:'center',editor:{type:'validatebox'}">税种</th>
						<th data-options="field:'taxname',width:200,align:'center',editor:{type:'validatebox'}">税目</th>
						<th data-options="field:'taxamount',width:110,align:'center',editor:{type:'validatebox'}">应缴金额</th>
						<th data-options="field:'taxamountactual',width:110,align:'center',editor:{type:'validatebox'}">已缴金额</th>
					</tr>
				</thead>
			</table>

		</div>




  </body>
</html>

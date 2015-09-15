<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/common/inc.jsp"%>
<!DOCTYPE html>
  <head>
    <title>税源数据关联</title>
    <link rel="stylesheet" type="text/css" href="/arcgis_js_api/library/3.7/3.7/js/dojo/dijit/themes/claro/claro.css"/>
    <link rel="stylesheet" type="text/css" href="/arcgis_js_api/library/3.7/3.7/js/esri/css/esri.css" />
	<link rel="stylesheet" href="/themes/sunny/easyui.css">
	<link rel="stylesheet" href="/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="/css/tablen.css">
	<link rel="stylesheet" href="/css/spectrum.css">
	

	<script src="/js/jquery-1.8.2.min.js"></script>
	<script src="/js/jquery.easyui.min.js"></script>
	<script src="/js/jquery.json-2.2.js"></script>
	<script src="/js/easyui-lang-zh_CN.js"></script>
	<script src="/js/spectrum.js"></script>
	<script src="../config.js"></script>
	<script>var dojoConfig = { parseOnLoad: true };</script>
    <script src="/arcgis_js_api/library/3.7/3.7/init.js"></script>
<script>
	dojo.require("esri.map");
	dojo.require("esri.dijit.OverviewMap");
	dojo.require("esri.dijit.Legend");
	dojo.require("esri.layers.FeatureLayer");
	dojo.require("esri.dijit.Popup");
	dojo.require("esri.dijit.editing.TemplatePicker-all");
	dojo.require("esri.toolbars.navigation");
	dojo.require("dijit.Toolbar"); 

	var map,dynamicMapServiceLayer,featureLayer3,featureLayer10,featureLayer9,tb,belongtownsNodeId;
	var identifyTask, identifyParams;
	var estateid = "";
	var objectid1 = "";
	var xzqdm = "";
	var drawGeometry = null;
	var mapX,mapY;
	var belongtowns = "";
	var clickObjectid = "";
	var allFeatureLayers = [];

	var belongtownsId = "";  //乡镇层图层id
	var villageId = ""; //村委会图层id
	var tdgyId = ""; //土地供应图层id
	var taxpayerinfoId = "";//税源图层id
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
	
	var currentLayerId = null;
    //加载图层
	function init() {
		//用来展现点、线、面的
        var highlightSymbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, //形状内填充类型
        	new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255,100,0]), 3), //形状的边框的颜色及粗细
        	new dojo.Color([125,125,125,0.35]));//形状内填充的颜色
        
        //map为div的id，后面的参数对象为地图对象的参数设置对象，比如缩放度，basemap
        //https://developers.arcgis.com/en/javascript/jsapi/map-amd.html#map1
		map = new esri.Map("map", {
		  //basemap: "http://localhost:8080/jnds8080-rest/services/jnds-8080/MapServer/3",
		  //center: [-238.499,31.543],
		  zoom: 1,
		  //infoWindow: popup,
		  //nav:true,
		  //logo:false,
		//	  scale:30,
		  //navigationMode: 'css-transforms',
		  //showAttribution:true,
		  //showInfoWindowOnClick:true,
		  slider:false
		});
        //新建地图工具栏，可以对地图进行操作，比如全图释放，上一试图等
		navToolbar = new esri.toolbars.Navigation(map); 

		//dojo.connect(map, "onLoad", initOperationalLayers);
		//dojo.connect(map, "onLoad", initOverviewMap);
		dojo.connect(map, "onLoad", initToolbar);
		//dojo.connect(map, "onClick", showCoordinates);


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

		dojo.connect(map, "onClick", function(evt) {
			if (evt.ctrlKey === true) {  //delete feature if ctrl key is depressed
				if(map.graphics.graphics[0].geometry.x != "0"){
					map.graphics.remove(map.graphics.graphics[0]);
					belongtowns = "";
				}
			}

         });
		function initToolbar() {
			tb = new esri.toolbars.Draw(map);
		}
        //加载各个图层,layers实际上就是ArcGISDynamicMapServiceLayer对象
		function loadLayerList(layers){
        	//visible为要展现的图层id
			var visible = [];
			//图层控制的div
			var html = "<div><table border='1' id='layerTable'></table></div>";
			dojo.byId("toc").innerHTML = html;

			var layerTrLable = "<tr><td><input id='checkAllId' type=\"checkbox\" checked='checked' /></td><td width=\"100px\" align=\"center\"><font style=\"font-size: 12px;\">图层名称</font></td><td width=\"100px\" align=\"center\">当前图层</td></tr>";
			$("#layerTable").append(layerTrLable);	

			var convertLayerinfo = [];
			//alert(JSON.stringify(layers.layerInfos));
			//根据layerConfig的配置及当前图层的信息，获取要展现的图层
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
            //convertLayerinfo要展现的图层
			for(var i = 0; i <convertLayerinfo.length; i++){
				var info = convertLayerinfo[i];
				visible.push(info.id);
				//创建一个featureLayer图层
				var featureLayer = new esri.layers.FeatureLayer("<%=mapServerPath%>/jnds/MapServer/" + info.id, {
					  mode: esri.layers.FeatureLayer.MODE_SNAPSHOT,
					  outFields: ["*"]  //可以通过图层获取当前的FetureClass的所有属性
					});
				if(info.id == belongtownsId){//乡镇级行政区图层
					featureLayer10 = featureLayer;
					dojo.connect(featureLayer10, "onClick", function(evt) {
						if(currentLayerId != featureLayer10.id){
							return;
						}
						graphicAttributes = evt.graphic.attributes;
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

				if(info.id == villageId){//村委会级行政区图层
					featureLayer9 = featureLayer;
					dojo.connect(featureLayer9, "onClick", function(evt) {
						if(currentLayerId != featureLayer9.id){
							return;
						}
						graphicAttributes = evt.graphic.attributes;
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


				if(info.id == tdgyId){//土地出让图层
					featureLayer3 = featureLayer;
					dojo.connect(featureLayer3, "onClick", function(evt) {
						if(currentLayerId != featureLayer3.id){
							return;
						}
						
					});
					var defaultSymbol = new esri.symbol.SimpleFillSymbol().setStyle(esri.symbol.SimpleFillSymbol.STYLE_NULL);
						defaultSymbol.outline.setStyle(esri.symbol.SimpleLineSymbol.STYLE_NULL);
						var renderer = new esri.renderer.UniqueValueRenderer(defaultSymbol, "ISRELATION");
						renderer.addValue("01", new esri.symbol.SimpleFillSymbol().setColor(new dojo.Color([0,219,0,0.4])));//已关联
						renderer.addValue("00", new esri.symbol.SimpleFillSymbol().setColor(new dojo.Color([255,0,0,0.4])));//未关联
						featureLayer3.setRenderer(renderer);
				}

				if(info.id == taxpayerinfoId){//税源图层
					featureLayer2 = featureLayer;
                    //PictureMarkerSymbol用来画点、多个点的符号
					var symbolok = new esri.symbol.PictureMarkerSymbol({
						"angle"      :0,
						"xoffset"    :0,
						"yoffset"    :10,
						"type"       :"esriPMS",
						"url"        :"/images/BluePin1LargeB.png",
						"contentType":"image/png",
						"width"      :24,
						"height"     :24
					});
                    var symbolbad = new esri.symbol.PictureMarkerSymbol({
						"angle"      :0,
						"xoffset"    :0,
						"yoffset"    :10,
						"type"       :"esriPMS",
						"url"        :"/images/RedPin1LargeB.png",
						"contentType":"image/png",
						"width"      :24,
						"height"     :24
					});
                    
                    var defaultSymbol = new esri.symbol.SimpleFillSymbol().setStyle(esri.symbol.SimpleFillSymbol.STYLE_NULL);
					defaultSymbol.outline.setStyle(esri.symbol.SimpleLineSymbol.STYLE_NULL);
					var renderer = new esri.renderer.UniqueValueRenderer(defaultSymbol, "ISRELATION");
					//add symbol for each possible value
					renderer.addValue("01", symbolok);//已关联
					renderer.addValue("00", symbolbad);//未关联
					featureLayer2.setRenderer(renderer);
					dojo.connect(featureLayer2, "onClick", function(evt) {
						if(currentLayerId != featureLayer2.id){
							return;
						}
						map.graphics.clear();
						$('#taxinfoEdit').dialog('close');
						graphicAttributes = evt.graphic.attributes;
						title = null;
						var isrelation = graphicAttributes.ISRELATION;
						clickObjectid = graphicAttributes.OBJECTID;
						
						if(isrelation == "00"){
							content = "<b><a href='javascript:showEstateInfo(0,"+clickObjectid+")'>税源关联</a></b>";
							title = "税源关联";
						}else if(isrelation == "01"){
							content="<b><a style='pading:1px;' href='javascript:showEstateInfo(1,"+clickObjectid+")'>查看此地块关联的税源信息</a></b>"+
							        "<br/><b><a style='pading:1px;' href='javascript:deleteRelationEstate("+clickObjectid+")'>删除此地块关联的税源信息</a></b>"+
							        "<br/><b><a style='pading:1px;' href='javascript:showEstateInfo(2,"+clickObjectid+")'>二次关联</a></b>";
							title = "税源关联信息";
						}
						map.infoWindow.setTitle(title);
						map.infoWindow.setContent(content);
						map.infoWindow.show(evt.screenPoint,map.getInfoWindowAnchor(evt.screenPoint));

					});

					
				}
                //调用map.addLayer方法后，featureLayer的id才会有呢
				map.addLayer(featureLayer);
                if(!currentLayerId){
                	currentLayerId = featureLayer.id; //第一个图层的id，税源图层
                }
				allFeatureLayers.push(featureLayer);							

				var layerTr = "<tr><td><input id=\""+info.id+"\" class=\"listCss\" type=\"checkbox\" checked=" + (info.defaultVisibility ? "checked":"")+
				" /></td><td width=\"100px\" align=\"center\"><font style=\"font-size: 12px;\">" + info.name +
				" </font></td><td width=\"100px\" align=\"center\"><input name=\"currentLayerName\" type=\"radio\" id=\"currentLayer"+
				info.id+"\"/></td></tr>";
				$("#layerTable").append(layerTr);		
				
				//控制是否显示某个图层
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
                //设置图层为当前图层
				$("#currentLayer" + info.id).live('click',{"featureLayer":featureLayer,"index":i},function(event){
					//alert(JSON.stringify(event.data.zz));
					//alert(zz);
					//alert(event.data.index);
					//map.addLayer(event.data.featureLayer);
					var currentId = "graphicsLayer" + (event.data.index+2);
					currentLayerId = currentId;
					map.reorderLayer(currentId,11);
					//alert(map.layerIds);
					map.graphics.clear();

				});
			}
            $("#currentLayer0").attr('checked','checked');
            $("#currentLayer0").click();
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
						map.addLayer(allFeatureLayers[d]);
					}
				}else{
					$(".listCss").attr("checked",false);
					dynamicMapServiceLayer.hide();
					for(var d=0;d<allFeatureLayers.length;d++){
						map.removeLayer(allFeatureLayers[d]);
					}
				}

            });

			var $subBox = $(".listCss");
			$subBox.click(function(){
				$("#checkAllId").attr("checked",$subBox.length == $(".listCss:checked").length ? true : false);
			});			

		}
        //ArcGISTiledMapServiceLayer允许加载缓存的图层
		var arcGISTiledMapServiceLayer = new esri.layers.ArcGISTiledMapServiceLayer("<%=mapServerPath%>/basemap/MapServer");

		map.addLayer(arcGISTiledMapServiceLayer);

		//arcGISTiledMapServiceLayer.hide();
     
        //ArcGISDynamicMapServiceLayer加载动态图层
		dynamicMapServiceLayer = new esri.layers.ArcGISDynamicMapServiceLayer("<%=mapServerPath%>/jnds/MapServer");

		map.addLayer(dynamicMapServiceLayer);

		dynamicMapServiceLayer.setOpacity(0.2);
		//var pp = new esri.geometry.Point(34560950.13663895, 2729798.97852076, new esri.SpatialReference({ wkid: 2358 }));
		//map.centerAndZoom(pp,3);
        //加载各个动态图层
		dojo.connect(dynamicMapServiceLayer,"onLoad",loadLayerList);

		dojo.connect(map, "onLayerAdd", function(layer) {
			//alert(layer.id + "---" + layer.name);
		});
        
        var layersLoaded = 0;  
        var loading = dojo.byId("loadingImg");
        //在地图缩放等操作显示进度图标
        dojo.connect(map, "onZoomStart", showLoading);
        dojo.connect(map, "onPanStart", showLoading);
		dojo.connect(dynamicMapServiceLayer, "onUpdate", hideLoading);
		dojo.connect(arcGISTiledMapServiceLayer, "onUpdate", hideLoading);

        function showLoading(){
           esri.show(loading);
           map.disableMapNavigation();//不能操作地图导航
           //map.hideZoomSlider();
        }

        function hideLoading(){
           layersLoaded++;
		   //alert(layersLoaded + "---" + map.layerIds.length);
           if (layersLoaded === map.layerIds.length-1) {
             esri.hide(loading);
             map.enableMapNavigation(); //可以操作地图导航
             //map.showZoomSlider();
             layersLoaded = 0;
           }
        }
	}
    
    var taxsourceobjectid = null;
    var realationvalue = null;
    //relation 0 第一次关联   1 查看关联信息   2 第二次关联
    function showEstateInfo(relation,taxobjectid){
    	realationvalue = relation;
    	taxsourceobjectid = taxobjectid;
    	queryCoreEstate(relation,taxobjectid);
        if(relation == 1){ //查看关联的税源信息
        	$('#operLandDiv').hide();
        }else{  //选择土地进行关联
            $('#operLandDiv').show();
        }
        $('#landInfoDiv').window('open');
    }
    function queryCoreEstate(relation,taxobjectid){
   	    var params = {};
   	    if(relation == 1){
   	    	params['layerid'] = taxobjectid;
   	    }
		params['taxpayerid']= $('#landInfoDiv #taxpayerid').val();
		params['taxpayername'] = $('#landInfoDiv #taxpayername').val();
		params['pagesize'] = '10';
	   var opts = $('#landInfoTable').datagrid('options');
	   opts.url = '/landavoidtaxmanager/selectland.do?d='+new Date();
	   $('#landInfoTable').datagrid('load',params); 
	   var p = $('#landInfoTable').datagrid('getPager');  
	   $(p).pagination({  
				showPageList:false
	   });
    }
    function relationEstate(){
    	var row = $('#landInfoTable').datagrid('getSelected');
		if(row == null){
			 $.messager.alert('提示消息','请选择需要关联的土地记录!','info');
			 return;
		}
		if(!taxsourceobjectid){
			$.messager.alert('提示消息','请选择需要关联的税源信息!','info');
			 return;
		}
		$.messager.confirm('税源关联','您确认关联当前土地吗？',function(r){   
		    if (r){   
		        for(var i=0;i<featureLayer2.graphics.length;i++){
        		   var graphics = featureLayer2.graphics[i];
       			   var taxsourceId = graphics.attributes.OBJECTID;
        		   if(taxsourceobjectid == taxsourceId){
        			    var params = {};
        			    identifyTask = new esri.tasks.IdentifyTask("<%=mapServerPath%>/jnds/MapServer");
						identifyParams = new esri.tasks.IdentifyParameters();
						identifyParams.tolerance = 3;
						identifyParams.returnGeometry = true;
						identifyParams.layerIds = [1];
						identifyParams.layerOption = esri.tasks.IdentifyParameters.LAYER_OPTION_ALL;
						identifyParams.width  = map.width;
						identifyParams.height = map.height;
						identifyParams.geometry = graphics.geometry;
						identifyParams.mapExtent = map.extent;
						identifyTask.execute(identifyParams,function(idResults) { 
							var tdgyobjectid = idResults[0].feature.attributes.OBJECTID;
							params['tdgyobjectid'] = tdgyobjectid;
							
							var identifyTask1 = new esri.tasks.IdentifyTask("<%=mapServerPath%>/jnds/MapServer");
							var identifyParams1 = new esri.tasks.IdentifyParameters();
							identifyParams1.tolerance = 3;
							identifyParams1.returnGeometry = true;
							identifyParams1.layerIds = [7];
							identifyParams1.layerOption = esri.tasks.IdentifyParameters.LAYER_OPTION_ALL;
							identifyParams1.width  = map.width;
							identifyParams1.height = map.height;
							identifyParams1.geometry = graphics.geometry;
							identifyParams1.mapExtent = map.extent;
							identifyTask1.execute(identifyParams1,function(idResults) { 
								var xzqdm = idResults[0].feature.attributes.行政区代码;
								params['villagecode'] = xzqdm;
								if(!params['tdgyobjectid']){
									$.messager.alert('提示消息','此税源点找不到相应的地块信息!','info');
			                        return;
								}
								if(!params['villagecode']){
									$.messager.alert('提示消息','此税源点找不到相应的村委会信息!','info');
			                        return;
								}
								params['taxsourceobjectid'] = taxsourceobjectid;
						        params['first'] = realationvalue == 0 ? '1' : '0';
						        params['estateid'] = row.estateid;
						        params['estateserialno'] = row.estateserialno;

						        $.messager.progress();
								$.ajax({
									   type: "post",
									   url: "/Relation/newHandRelation.do",
									   data: params,
									   dataType: "json",
									   success: function(jsondata){
										   $.messager.progress('close');
										   if(jsondata.sucess){
												$.messager.alert('提示','税源关联成功!','info',function(){
													$('#landInfoDiv').window('close');
												    map.infoWindow.hide();
													featureLayer3.refresh();
													featureLayer2.refresh();
													map.graphics.clear();
												});
										   }else{
											   $.messager.alert('提示','税源关联失败!');
										   }
									   }
							   });
							});
						});
					    break;
        		   }
        	    }
		    }   
		});  
    }
    function deleteRelationEstate(taxsourceobjectid){
    	$.messager.confirm('税源关联','您确认删除当前关联的土地信息吗？',function(r){   
		    if(r){ 
		    	for(var i=0;i<featureLayer2.graphics.length;i++){
        		   var graphics = featureLayer2.graphics[i];
       			   var taxsourceId = graphics.attributes.OBJECTID;
        		   if(taxsourceobjectid == taxsourceId){
        			    var params = {};
        			    identifyTask = new esri.tasks.IdentifyTask("<%=mapServerPath%>/jnds/MapServer");
						identifyParams = new esri.tasks.IdentifyParameters();
						identifyParams.tolerance = 3;
						identifyParams.returnGeometry = true;
						identifyParams.layerIds = [1];
						identifyParams.layerOption = esri.tasks.IdentifyParameters.LAYER_OPTION_ALL;
						identifyParams.width  = map.width;
						identifyParams.height = map.height;
						identifyParams.geometry = graphics.geometry;
						identifyParams.mapExtent = map.extent;
						identifyTask.execute(identifyParams,function(idResults) { 
							var tdgyobjectid = idResults[0].feature.attributes.OBJECTID;
							params['tdgyobjectid'] = tdgyobjectid;
							params['taxsourceobjectid'] = taxsourceobjectid;
							$.messager.progress();
								$.ajax({
									   type: "post",
									   url: "/Relation/newDeleteRelation.do",
									   data: params,
									   dataType: "json",
									   success: function(jsondata){
										   $.messager.progress('close');
										   if(jsondata.sucess){
												$.messager.alert('提示','税源关联删除成功!','info',function(){
												    map.infoWindow.hide();
													featureLayer3.refresh();
													featureLayer2.refresh();
													map.graphics.clear();
												});
										   }else{
											   $.messager.alert('提示','税源关联删除失败!');
										   }
									   }
							   });
						});
					    break;
        		   }
        	    }
		    }
		});
    	
    }
    //执行init方法
	dojo.ready(init);
    
    </script>
    
    <script type="text/javascript">
	$(function(){   
		
		$('#landInfoTable').datagrid({
			fitColumns:false,
			maximized:'true',
			pagination:true,
			pageList:[10]
		});
		
		//地块相关功能开始.........................................
        $('#landInfoId').bind('click',function(){
           queryTdgyInfo();
           $('#tdgywindow').window('open');
        });
        
        $('#tdgytable').datagrid({
			fitColumns:false,
			maximized:'true',
			pagination:true,
			pageList:[10],
			onClickRow:function(rowindex,rowData){  //进行地图缩放
        	   //featureLayer3 土地供应层
        	   var selectObjectId = rowData.objectid;
        	   for(var i=0;i<featureLayer3.graphics.length;i++){
        		   var graphics = featureLayer3.graphics[i];
       			   var landId = graphics.attributes.OBJECTID;
        		   if(landId == selectObjectId){
        			   var x = graphics.attributes.X;
					   var y = graphics.attributes.Y;
					   var centerPoint = new esri.geometry.Point(x, y, new esri.SpatialReference({ wkid: 2358 }));
					   map.centerAndZoom(centerPoint,4);	
					   var geometry = graphics.geometry;
					   map.graphics.clear();
					   var highlightSymbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255,100,0]), 3), new dojo.Color([125,125,125,0.35]));
					   var highlightGraphic = new esri.Graphic(geometry,highlightSymbol);
					   map.graphics.add(highlightGraphic);
					   break;
        		   }
        	   }
			}
		});
        var p = $('#tdgytable').datagrid('getPager');  
			$(p).pagination({  
				showPageList:false
		});
		//地块相关功能结束.......................................
		$('#landInfoTable').datagrid({
			onLoadSuccess: function(data){
				if (data.rows.length > 0) {
					for (var i = 0; i < data.rows.length; i++) {
						if ($.trim(data.rows[i].layerid) != "") {
							$("input[name='ckxxx']")[i].disabled = true;
						}
					}
				}
			},
			onClickRow: function(rowIndex, rowData){
				$("input[name='ckxxx']").each(function(index, el){
					//如果当前的复选框不可选，则不让其选中
					if(el.disabled == true) {
						$('#landInfoTable').datagrid('unselectRow', index);
					}
				})
			}
		});


	});

	 //展现是否关联的函数
	 function getRelationDisplay(value,row,index){
		if(value == '01'){
			return "已关联";
		}else if(value == "00"){
			return "未关联";
		}
		return "无效状态";
	 }
	 function queryTdgyInfo(){
		   //设置当前图层为土地供应层
       	   $('#1').attr('checked','checked');
		   $('#1').click();
		   $('#currentLayer1').attr('checked','checked');
		   $('#currentLayer1').click();
		   
		  var relationvalue = $('#relation').val();
          var params = {};
          params['pagesize'] = '10';
          params['relation'] = relationvalue;
          var opts = $('#tdgytable').datagrid('options');
		  opts.url = '/Relation/selectRelationInfo.do?d='+new Date();
		  $('#tdgytable').datagrid('load',params); 
	 }



</script>



  </head>

  <body class="claro" style="overflow:hidden" >
    <div class="easyui-layout" style="width:100%;height:650px;" id="layoutDiv">
		<div data-options="region:'north',border:false" style="width:99; height:35px; padding:1px;border:1px solid #ddd;overflow:hidden">		         
		    <a id="landInfoId" class="easyui-linkbutton" data-options="plain:false,iconCls:'icon-position'">地块信息</a>
			<a  href="#"  style = "display:none;" id="treePositionId" class="easyui-linkbutton" data-options="plain:false,iconCls:'icon-position'">地图定位</a>
			<a href="javascript:navToolbar.zoomToPrevExtent();" style = "display:none;" class="easyui-linkbutton" data-options="plain:false,iconCls:'icon-lastExtent'">前一视图</a>
			<a href="javascript:navToolbar.zoomToNextExtent();" style = "display:none;" class="easyui-linkbutton" data-options="plain:false,iconCls:'icon-nextExtent'">后一视图</a>
			<a href="javascript:navToolbar.zoomToFullExtent();" class="easyui-linkbutton" data-options="plain:false,iconCls:'icon-globeLarge'">全图范围</a>
			<!--<a href="#" id="autoRelationId" class="easyui-linkbutton" data-options="plain:false,iconCls:'icon-auto'">自动关联</a>-->
			<a id="layerInfoConfig" class="easyui-linkbutton"  style = "display:none;"data-options="plain:false,iconCls:'icon-layerConfig'">图层控制</a>
		</div>
		<div id="map" data-options="region:'center'" style="position:relative; width:1100px; height:615px; border:1px solid #000;">
		</div>
		
			
		
    </div>
    <div style="width:450px;height:500px;padding:20px;display: none">
			    <span id="toc"></span>
		    </div>
		<img id="loadingImg" src="/images/loading.gif" style="position:absolute; right:702px; top:256px; z-index:100;" />
		
        <div id="tdgywindow" class="easyui-window" data-options="closed:true,title:'地块信息',collapsible:false,
	        minimizable:false,maximizable:false,closable:true" style="width:460px;height:385px;top:35px;left: 10px;">
	          <table id='tdgytable' class="easyui-datagrid" style="width:120;height:350px;overflow: scroll;"
					data-options="iconCls:'icon-edit',singleSelect:true,pageList:[10],toolbar:'#tdgymenu'">
				<thead>
					<th data-options="field:'objectid',width:50,align:'center',editor:{type:'validatebox'}">地块编号</th>
					<th data-options="field:'x',width:50,hidden:true,align:'center',editor:{type:'validatebox'}">X坐标</th>
					<th data-options="field:'y',width:100,hidden:true,align:'center',editor:{type:'validatebox'}">Y坐标</th>
					<th data-options="field:'zdbh',width:120,align:'left',editor:{type:'validatebox'}">宗地编号</th>
					<th data-options="field:'isrelation',width:120,align:'center',formatter:getRelationDisplay,editor:{type:'validatebox'}">是否关联</th>
				</thead>
			</table>
	   </div>
	   <div id="tdgymenu" style="height:25px;width:100%;overflow: visible" >
	        <select id="relation" name="relation">
	            <option value="">所有</option>
	            <option value="01">已关联</option>
	            <option value="00" selected="selected">未关联</option>
	        </select>
	        &nbsp;&nbsp;
		   <a  class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="queryTdgyInfo()">查询</a>
	  </div>

		<div id="landInfoDiv" class="easyui-window" title="土地信息查询" data-options="iconCls:'icon-save',closed:true,modal:true,collapsible:true" 
		 style="width:540px;padding:5px;top:40px;left:10px;">
			计算机编码：<input type="text" id="taxpayerid" style="width:120px;"/>&nbsp;
			纳税人名称：<input type="text" id="taxpayername" style="width:200px;"/>&nbsp;
			<div align="center" id="operLandDiv">
			 <a class="easyui-linkbutton" data-options="plain:false,iconCls:'icon-search'" onclick="queryCoreEstate()">查询</a>&nbsp;&nbsp;
			 <a class="easyui-linkbutton" iconCls="icon-add" onclick="relationEstate()">关联</a>&nbsp;&nbsp;
			</div>
			<table id="landInfoTable" class="easyui-datagrid" style="width:510px;height:330px;padding:5px;overflow:scroll;"
					data-options="iconCls:'icon-edit',pageList:[10],singleSelect:true,
											rowStyler: function(index,row){
												if (row.layerid != null && $.trim(row.layerid) != ''){
													return 'background-color:red;color:#fff;font-weight:bold;';
												}
											}
					">
				<thead>
					<tr>
						<th data-options="field:'ckxxx',checkbox:true"></th>
						<th data-options="field:'estateid',hidden:true,width:100">计算机编码</th>
						<th data-options="field:'taxpayerid',width:100">计算机编码</th>
						<th data-options="field:'taxpayername',width:200">纳税人名称</th>
						<th data-options="field:'estateserialno',width:120">宗地编号</th>
						<th data-options="field:'landarea',width:80">土地面积</th>
						<th data-options="field:'detailaddress',width:200">地址</th>
					</tr>
				</thead>
			</table>
		</div>

  </body>
</html>


dojo.require("esri.map");
dojo.require("esri.dijit.OverviewMap");
dojo.require("esri.dijit.Legend");
dojo.require("esri.layers.FeatureLayer");
dojo.require("esri.dijit.Popup");
dojo.require("esri.dijit.editing.TemplatePicker-all");
dojo.require("esri.toolbars.navigation");
dojo.require("dijit.Toolbar"); 
dojo.require("esri.geometry.Polygon");


/**
*  params包含
*  {
*     
*     coordinatedisplaydiv:坐标显示的div
*     mapdiv:显示地图的divid
*     loadingdiv:加载的滚动条
*     load:map的load事件,函数
*     click:map的click事件
*     
*     taxpayerclick:税源层click事件,ArcgisMap对象作为上下文对象
*     tdgyclick:地块层的click事件,ArcgisMap对象作为上下文对象
*     forestclick:农用林地的click事件,ArcgisMap对象作为上下文对象
*     villageclick:村委会的click事件,ArcgisMap对象作为上下文对象
*     townclick:乡镇的click事件,ArcgisMap对象作为上下文对象
*  }
* 
*/
function ArcgisMap(mapServerPath,params){
	if(!params){throw 'ArcgisMap.params对象参数必须需要！';}
	if(!params.mapdiv){throw 'ArcgisMap.params对象的mapdiv参数必须需要';}
	
	var layerConfig = [{"layerId":"0","config":"true"},{"layerId":"1","config":"true"},{"layerId":"2","config":"false"},{"layerId":"3","config":"false"},{"layerId":"4","config":"true"},{"layerId":"5","config":"false"},{"layerId":"6","config":"false"},{"layerId":"7","config":"true"},{"layerId":"8","config":"true"}];
	this.load = params.load;
	this.click = params.click;
	this.taxpayerclick = params.taxpayerclick;
	this.tdgyclick = params.tdgyclick;
	this.forestclick = params.forestclick;
	this.villageclick = params.villageclick;
	this.townclick = params.townclick;
	
    this.mapServerPath = mapServerPath;	
	this.map = new esri.Map(params.mapdiv, {
		  zoom: 1,
		  slider:false
	});
    this.navToolbar = new esri.toolbars.Navigation(this.map); 
    if(params.load){
    	dojo.connect(this.map, "onLoad",params.load);
    }
    dojo.connect(this.map,'onMouseMove',function(evt){
    	if(params.coordinatedisplaydiv){
    		var pointstr = evt.mapPoint.x+","+evt.mapPoint.y;
        	$('#'+params.coordinatedisplaydiv).text(pointstr);
    	}
    });
    if(params.click){
    	dojo.connect(this.map, "onClick",params.click);
    }else{
    	dojo.connect(this.map, "onClick", function(evt) {
			var condition = false;
			if (evt.ctrlKey === true && condition) {
				if(currentObj.map.graphics.graphics[0].geometry.x != "0"){
					currentObj.map.graphics.remove(currentObj.map.graphics.graphics[0]);
					belongtowns = "";
				}
			}
			currentObj.defaultClick(evt);
        });
    }
    var arcGISTiledMapServiceLayer = new esri.layers.ArcGISTiledMapServiceLayer(this.mapServerPath+"/basemap/MapServer");
    this.map.addLayer(arcGISTiledMapServiceLayer);
    var dynamicMapServiceLayer = new esri.layers.ArcGISDynamicMapServiceLayer(this.mapServerPath+"/jnds/MapServer");
    this.map.addLayer(dynamicMapServiceLayer);
    dynamicMapServiceLayer.setOpacity(0.2);
    dojo.connect(dynamicMapServiceLayer,"onLoad",loadMapLayerList);
    var currentObj = this;
    function loadMapLayerList(layers){
    	var visible = [];
	    var convertLayerinfo = [];
	    for(var i = 0; i <layers.layerInfos.length; i++){
			var info = layers.layerInfos[i];
			for(var j=0;j<layerConfig.length;j++){
				var config = layerConfig[j];
				if((config.layerId == info.id) && (config.config == "true")){
					convertLayerinfo.push(info);
				}
			}
		}
	    for(var i = 0; i <convertLayerinfo.length; i++){
	    	var info = convertLayerinfo[i];
		    visible.push(info.id);
		    var featureLayer = null;
		    if(ArcgisMap.isForestLayer(info.id)){
		    	featureLayer = new esri.layers.FeatureLayer(currentObj.mapServerPath+"/jnds/MapServer/" + info.id, {
					  mode: esri.layers.FeatureLayer.MODE_SELECTION,  //点击才获取features
					  outFields: ["*"]  //可以通过图层获取当前的FetureClass的所有属性
				});
		    	
		    }else{
		    	featureLayer = new esri.layers.FeatureLayer(currentObj.mapServerPath+"/jnds/MapServer/" + info.id, {
					  mode: esri.layers.FeatureLayer.MODE_ONDEMAND, //点击才获取features
					  outFields: ["*"]  //可以通过图层获取当前的FetureClass的所有属性
				});
		    }
		    
		    if(ArcgisMap.isTownLayer(info.id)){
		    	currentObj.townLayer = featureLayer;
		    }
		    if(ArcgisMap.isVillageLayer(info.id)){
		    	currentObj.villageLayer = featureLayer;
		    }
		    if(ArcgisMap.isForestLayer(info.id)){
		    	currentObj.forestLayer = featureLayer;
		    	/*
		    	var symbolDefault = new esri.symbol.SimpleFillSymbol();
			    symbolDefault.setColor(new dojo.Color([255,0,0,0.5]));
			    var defaultRenderer = new esri.renderer.SimpleRenderer(symbolDefault);
			    featureLayer.setRenderer(defaultRenderer);
			    */
               alert('fff56s');
		    }
		    if(ArcgisMap.isTdgyLayer(info.id)){
		    	currentObj.tdgyLayer = featureLayer;
		    	var defaultSymbol = new esri.symbol.SimpleFillSymbol().setStyle(esri.symbol.SimpleFillSymbol.STYLE_NULL);
				defaultSymbol.outline.setStyle(esri.symbol.SimpleLineSymbol.STYLE_NULL);
				var renderer = new esri.renderer.UniqueValueRenderer(defaultSymbol, "ISRELATION");
				renderer.addValue("01", new esri.symbol.SimpleFillSymbol().setColor(new dojo.Color([255,255,0,0.9])));//已关联
				renderer.addValue("00", new esri.symbol.SimpleFillSymbol().setColor(new dojo.Color([255,255,0,0.9])));//未关联
				featureLayer.setRenderer(renderer);
				if(params.forestclick){
		    		dojo.connect(featureLayer, "onClick",params.forestclick);
		    	}
		    }
		    if(ArcgisMap.isTaxpayerLayer(info.id)){
		    	currentObj.taxpayerLayer = featureLayer;
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
                    
                    symbolok = new esri.symbol.SimpleMarkerSymbol();
			        symbolok.setColor(new dojo.Color([0,155,246]));
			        symbolbad = new esri.symbol.SimpleMarkerSymbol();
			        symbolbad.setColor(new dojo.Color([231,0,14]));
			        
                    var defaultSymbol = new esri.symbol.SimpleFillSymbol().setStyle(esri.symbol.SimpleFillSymbol.STYLE_NULL);
					defaultSymbol.outline.setStyle(esri.symbol.SimpleLineSymbol.STYLE_NULL);
					//defaultSymbol.setColor(new dojo.Color([246,51,121]));
					var renderer = new esri.renderer.UniqueValueRenderer(defaultSymbol, "ISRELATION");

					renderer.addValue("01", symbolok);//已关联
					renderer.addValue("00", symbolbad);//未关联
					featureLayer.setRenderer(renderer);
		    	    if(params.forestclick){
		    		   dojo.connect(featureLayer, "onClick",params.forestclick);
		    	    }
		    }
		    currentObj.map.addLayer(featureLayer);
	    }
	    currentObj.map.reorderLayer(currentObj.taxpayerLayer.id,15);		
		dynamicMapServiceLayer.setVisibleLayers(visible);
    }
    
    if(params.loadingdiv){
    	var loading = dojo.byId(params.loadingdiv);
    	 var layersLoaded = 0;  
        //在地图缩放等操作显示进度图标
        dojo.connect(this.map, "onZoomStart", showLoading);
        dojo.connect(this.map, "onPanStart", showLoading);
		dojo.connect(dynamicMapServiceLayer, "onUpdate", hideLoading);
		dojo.connect(arcGISTiledMapServiceLayer, "onUpdate", hideLoading);
        function showLoading(){
           esri.show(loading);
           currentObj.map.disableMapNavigation();//不能操作地图导航
        }
        function hideLoading(){
           layersLoaded++;
           if (layersLoaded === currentObj.map.layerIds.length-1) {
             esri.hide(loading);
             currentObj.map.enableMapNavigation(); //可以操作地图导航
             layersLoaded = 0;
           }
        }
    }
}

ArcgisMap.formatterDate = function(value){
	return formatDatebox(value);
}
ArcgisMap.DRAW = false;
ArcgisMap.taxpayerlayerid = 0;
ArcgisMap.tdgylayerid = 1;
ArcgisMap.forestlayerid = 4;
ArcgisMap.villagelayerid = 7;
ArcgisMap.townlayerid = 8;

ArcgisMap.isTaxpayerLayer = function(id){
	return id == ArcgisMap.taxpayerlayerid;
}
ArcgisMap.isTdgyLayer = function(id){
	return id == ArcgisMap.tdgylayerid;
}
ArcgisMap.isForestLayer = function(id){
	return id == ArcgisMap.forestlayerid;
}
ArcgisMap.isVillageLayer = function(id){
	return id == ArcgisMap.villagelayerid;
}
ArcgisMap.isTownLayer = function(id){
	return id == ArcgisMap.townlayerid;
}
ArcgisMap.getHighlightSymbol = function(){
	return new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, //形状内填充类型
        	new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255,100,0]), 3), //形状的边框的颜色及粗细
        	new dojo.Color([125,125,125,0.35]));
}
//原型函数   

ArcgisMap.prototype.getTaxpayerLayer = function(){
	return this.taxpayerLayer;
}
ArcgisMap.prototype.getTdgyLayer = function(){
	return this.tdgyLayer;
}
ArcgisMap.prototype.getForestLayer = function(){
	return this.forestLayer;
}
ArcgisMap.prototype.getVillageLayer = function(){
	return this.villageLayer;
}
ArcgisMap.prototype.getTownLayer = function(){
	return this.townLayer;
}
ArcgisMap.prototype.focusLand = function(iszoom,objectidOrClickEvent,graphics){
	var objectid = parseInt(objectidOrClickEvent);
	var g = null;
	var point = null;
	if(objectid){
		var selectObjectId = objectid;
		var featureLayer = this.getTdgyLayer();
        for(var i=0;i<featureLayer.graphics.length;i++){
    		   var graphics = featureLayer.graphics[i];
   			   var landId = graphics.attributes.OBJECTID;
    		   if(landId == selectObjectId){
    			   g = graphics;
    			   var x = graphics.attributes.X;
				   var y = graphics.attributes.Y;
				   point = new esri.geometry.Point(x, y, new esri.SpatialReference({ wkid: 2358 }));
    			   break;
    		   }
    	}
	}else{
		point = objectidOrClickEvent.mapPoint;
		g = graphics;
	}
	if(iszoom){
		var centerPoint = point;
	    this.map.centerAndZoom(centerPoint,6);
	}
	var geometry = g.geometry;
    this.map.graphics.clear();
    var highlightSymbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255,100,0]), 3), new dojo.Color([125,125,125,0.35]));
    var highlightGraphic = new esri.Graphic(geometry,highlightSymbol);
    this.map.graphics.add(highlightGraphic);
}
ArcgisMap.prototype.defaultClick = function(evt){
	var identifyTask = new esri.tasks.IdentifyTask(this.mapServerPath+"/jnds/MapServer");
	var identifyParams = new esri.tasks.IdentifyParameters();
	identifyParams.tolerance = 3;
	identifyParams.returnGeometry = true;
	identifyParams.layerIds = [0,1,4,7,8];
	identifyParams.layerOption = esri.tasks.IdentifyParameters.LAYER_OPTION_ALL;
	identifyParams.width  = this.map.width;
	identifyParams.height = this.map.height;
	identifyParams.geometry = evt.mapPoint;
	identifyParams.mapExtent = this.map.extent;
	
	var currentObj = this;
	identifyTask.execute(identifyParams,function(idResults) {
		if(!ArcgisMap.DRAW && idResults.length > 0){
			
			var layerid = idResults[0].layerId;//点击的最上面一层
			if(layerid == 0){
				if(currentObj.taxpayerclick){
					currentObj.taxpayerclick.call(currentObj,evt);
				}
			}else if(layerid == 1){
				if(currentObj.tdgyclick){
					evt.graphic = idResults[0].feature;
					currentObj.tdgyclick.call(currentObj,evt);
				}else{
					currentObj.focusLand(false,evt,idResults[0].feature);
					var zdbh = idResults[0].feature.attributes.ZDBH;
					if(zdbh){
						$.ajax({
						   type: "post",
						   async:false,
						   url: "/landavoidtaxmanager/selectlandlist.do",
						   data: {'estateserialno':zdbh},
						   dataType: "json",
						   success: function(jsondata){
							   if(jsondata && jsondata.length > 0){
								   var title = "土地信息";
							       var content = "<table width='100%' cellpadding='3' cellspacing='0' border='1' bordercolor='#FCD209' style='border-collapse:collapse'>";
							       content += "<tr><th>权属人</th><th>宗地编号</th><th>交互日期</th><th>土地面积</th><th>土地总价</th></tr>";
							       for(var i = 0;i < jsondata.length;i++){
							    	   var land = jsondata[i];
							    	   content += "<tr><td>"+land.taxpayername+"</td><td>"+land.estateserialno+"</td>"+
							    	              "<td>"+ArcgisMap.formatterDate(land.holddate)+"</td>"+
							    	              "<td>"+land.landarea+"</td><td>"+land.landmoney+"</td></tr>";
							       }	   
							       content += '</table>'
							       currentObj.map.infoWindow.resize(500,300);
							       currentObj.map.infoWindow.setTitle(title);
								   currentObj.map.infoWindow.setContent(content);
								   currentObj.map.infoWindow.show(evt.screenPoint,currentObj.map.getInfoWindowAnchor(evt.screenPoint));
							   }
						   }
				       });
					}else{
						currentObj.map.infoWindow.resize(250,100);
				        currentObj.map.infoWindow.setTitle('土地信息');
				        var content = "<table width='100%' cellpadding='3' cellspacing='0' border='1' bordercolor='#FCD209' style='border-collapse:collapse'>";
				        content += "<tr><td> <b>此块土地无权属人</b></td></tr>";	   
						content += '</table>';
				        currentObj.map.infoWindow.setContent(content);
				     	currentObj.map.infoWindow.show(evt.screenPoint,currentObj.map.getInfoWindowAnchor(evt.screenPoint));
					}
				}
			}else if(ArcgisMap.isForestLayer(layerid)){
				if(currentObj.forestclick){
					currentObj.forestclick.call(currentObj,evt);
				}else{
					var content = idResults[0].feature.attributes.权属单位名称;
					content += ","+idResults[0].feature.attributes.地类名称;
					content = "<b>"+content+"</b>";
					var geometry = idResults[0].feature.geometry;
				    currentObj.map.graphics.clear();
				    var highlightSymbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255,100,0]), 3), new dojo.Color([125,125,125,0.35]));
				    var highlightGraphic = new esri.Graphic(geometry,highlightSymbol);
				    currentObj.map.graphics.add(highlightGraphic);
				    currentObj.map.infoWindow.resize(250,100);
				    currentObj.map.infoWindow.setTitle('农田林地');
				    currentObj.map.infoWindow.setContent(content);
					currentObj.map.infoWindow.show(evt.screenPoint,currentObj.map.getInfoWindowAnchor(evt.screenPoint));
					   
				}
			}else if(ArcgisMap.isVillageLayer(layerid)){
				if(currentObj.villageclick){
					currentObj.villageclick.call(currentObj,evt);
				}else{
					var content = idResults[0].feature.attributes.行政区名称;
					content = "<b>"+content+"</b>";
					var geometry = idResults[0].feature.geometry;
				    currentObj.map.graphics.clear();
				    var highlightSymbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255,100,0]), 3), new dojo.Color([125,125,125,0.35]));
				    var highlightGraphic = new esri.Graphic(geometry,highlightSymbol);
				    currentObj.map.graphics.add(highlightGraphic);
				    currentObj.map.infoWindow.resize(250,100);
				    currentObj.map.infoWindow.setTitle('村委会');
				    currentObj.map.infoWindow.setContent(content);
					currentObj.map.infoWindow.show(evt.screenPoint,currentObj.map.getInfoWindowAnchor(evt.screenPoint));
				}
			}else if(ArcgisMap.isTownLayer(layerid)){
				if(currentObj.townclick){
					currentObj.townclick.call(currentObj,evt);
				}else{
					var content = idResults[0].feature.attributes.行政区名称;
					content = "<b>"+content+"</b>";
					var geometry = idResults[0].feature.geometry;
				    currentObj.map.graphics.clear();
				    var highlightSymbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255,100,0]), 3), new dojo.Color([125,125,125,0.35]));
				    var highlightGraphic = new esri.Graphic(geometry,highlightSymbol);
				    currentObj.map.graphics.add(highlightGraphic);
				    currentObj.map.infoWindow.resize(250,100);
				    currentObj.map.infoWindow.setTitle('乡镇');
				    currentObj.map.infoWindow.setContent(content);
					currentObj.map.infoWindow.show(evt.screenPoint,currentObj.map.getInfoWindowAnchor(evt.screenPoint));
				}
			}
			MapUtils.ClickTaxPayerLayer = false;
		}
	});
}
ArcgisMap.prototype.getLayerAttrs = function(geometry,layerid,callback){
	var identifyTask = new esri.tasks.IdentifyTask(this.mapServerPath+"/jnds/MapServer");
	var identifyParams = new esri.tasks.IdentifyParameters();
	identifyParams.tolerance = 3;
	identifyParams.returnGeometry = true;
	identifyParams.layerIds = [];
	identifyParams.layerIds.push(layerid);
	identifyParams.layerOption = esri.tasks.IdentifyParameters.LAYER_OPTION_ALL;
	identifyParams.width  = this.map.width;
	identifyParams.height = this.map.height;
	identifyParams.geometry = geometry;
	identifyParams.mapExtent = this.map.extent;
	identifyTask.execute(identifyParams,function(idResults) { 
		 if(idResults && idResults.length > 0){
			 callback(idResults[0].feature.attributes);
		 }
	});
}
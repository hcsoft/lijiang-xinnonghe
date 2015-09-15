
dojo.require("esri.map");
dojo.require("esri.dijit.OverviewMap");
dojo.require("esri.dijit.Legend");
dojo.require("esri.layers.FeatureLayer");
dojo.require("esri.dijit.Popup");
dojo.require("esri.dijit.editing.TemplatePicker-all");
dojo.require("esri.dijit.LocateButton");

dojo.require("esri.toolbars.navigation");
dojo.require("dijit.Toolbar"); 
dojo.require("esri.geometry.Polygon");


dojo.require("esri.geometry.Geometry");
dojo.require("esri.geometry.Extent");
dojo.require("esri.SpatialReference");
dojo.require("esri.tasks.GeometryService");
dojo.require("esri.tasks.AreasAndLengthsParameters");
dojo.require("esri.tasks.query");
dojo.require("esri.tasks.QueryTask");





/**
*  params包含
*  {
*     
*     coordinatedisplaydiv:坐标显示的div
*     mapdiv:显示地图的divid
*     loadingdiv:加载的滚动条
* 
*     visiblelayer:可以看见的图层 
*     load:map的load事件,函数
*     click:map的click事件
*     
*     taxpayerclick:税源层click事件,ArcgisMap对象作为上下文对象
*     tdgyclick:地块层的click事件,ArcgisMap对象作为上下文对象
*     forestclick:农用林地的click事件,ArcgisMap对象作为上下文对象
*     villageclick:村委会的click事件,ArcgisMap对象作为上下文对象
*     townclick:乡镇的click事件,ArcgisMap对象作为上下文对象
*     layerloaded:图层加载完毕事，可以在此事件上进行图层加载后的事件添加
*     notiledmap:是否加载底图
*     townlayerender:乡镇层的底色
*     villagelayerender:村委会的底色
*  }
* 
*/
function ArcgisMap(params){
	if(!params){throw 'ArcgisMap.params对象参数必须需要！';}
	if(!params.mapdiv){throw 'ArcgisMap.params对象的mapdiv参数必须需要';}
	this.visiblelayer = params.visiblelayer;
	if(!this.visiblelayer){
		this.visiblelayer = [ArcgisMap.taxpayerlayerid,ArcgisMap.tdgylayerid,ArcgisMap.forestlayerid,ArcgisMap.villagelayerid,ArcgisMap.townlayerid];
	}
	//var layerConfig = [{"layerId":"0","config":"true"},{"layerId":"1","config":"true"},{"layerId":"2","config":"true"},{"layerId":"3","config":"true"},{"layerId":"4","config":"true"}];
	this.load = params.load;
	this.click = params.click;
	this.taxpayerclick = params.taxpayerclick;
	this.tdgyclick = params.tdgyclick;
	this.forestclick = params.forestclick;
	this.villageclick = params.villageclick;
	this.townclick = params.townclick;
	
    this.mapServerPath = ArcgisMap.MapServerPath;	
	this.map = new esri.Map(params.mapdiv,{
		  zoom: 1,
		  sliderLabels:['下移缩小','上移放大'],
		  sliderStyle: "large"
	});
	

      
    this.navToolbar = new esri.toolbars.Navigation(this.map); 
    if(params.load){
    	dojo.connect(this.map, "onLoad",function(){
    		var displaytile = params.notiledmap ? false : true;
    		currentObj.tiledlayer.visible = displaytile;
    		params.load();
    	});
    }else{
    	dojo.connect(this.map, "onLoad",function(){
    		var displaytile = params.notiledmap ? false : true;
    		currentObj.tiledlayer.visible = displaytile;
    	});
    }
    dojo.connect(this.map,"onResize",function(extent,height,width){
    	
    });
    dojo.connect(this.map,'onMouseMove',function(evt){
    	if(params.coordinatedisplaydiv){
    		var pointstr = evt.mapPoint.x+","+evt.mapPoint.y;
        	$('#'+params.coordinatedisplaydiv).text(pointstr);
    	}
    });
    if(params.click){
    	dojo.connect(this.map, "onClick",params.click);
    }else{
    	//不要删除
    	dojo.connect(this.map, "onClick", function(evt) {
			var condition = false;
			if (evt.ctrlKey === true && condition) {
				if(currentObj.map.graphics.graphics[0].geometry.x != "0"){
					currentObj.map.graphics.remove(currentObj.map.graphics.graphics[0]);
					belongtowns = "";
				}
			}
			//currentObj.defaultClick(evt);
        });
    }
    var arcGISTiledMapServiceLayer = new esri.layers.ArcGISTiledMapServiceLayer("http://154.20.152.28:7001/jnds_rest/services/basemap/MapServer");
    this.tiledlayer = arcGISTiledMapServiceLayer;
    this.map.addLayer(arcGISTiledMapServiceLayer);

    var dynamicMapServiceLayer = new esri.layers.ArcGISDynamicMapServiceLayer(this.mapServerPath+"/jnds/MapServer");
    this.dynamiclayer = dynamicMapServiceLayer;
    this.map.addLayer(dynamicMapServiceLayer);
    dynamicMapServiceLayer.setOpacity(0.0);  //透明度设为全透明,可以控制图层的显示
    dojo.connect(dynamicMapServiceLayer,"onLoad",loadMapLayerList);
    var currentObj = this;
    function loadMapLayerList(layers){
    	var visibleLayer = [];
    	var newLayerAry = [];
    	for(var i = 0; i <layers.layerInfos.length; i++){
	    	var info = layers.layerInfos[i];
	    	newLayerAry.push(info);
	    }
    	newLayerAry.reverse();
    	function display(layerId){
    		for(var i = 0;i<currentObj.visiblelayer.length;i++){
    			if(layerId == currentObj.visiblelayer[i])
    				return true;
    		}
    		return false;
    	}
	    for(var i = 0; i <newLayerAry.length; i++){
	    	var info = newLayerAry[i];
		    var featureLayer = null;
		    var d = display(info.id);
		    if(ArcgisMap.isForestLayer(info.id) ){
		    	//使用MODE_ONDEMAND一次获取的数据要多些，可以渲染颜色   
		    	//使用MODE_SNAPSHOT默认获取1000行数据，可以渲染颜色  太多渲染不了
		    	//使用MODE_SELECTION无法渲染颜色，必须自己去查询
		    	featureLayer = new esri.layers.FeatureLayer(currentObj.mapServerPath+"/jnds/MapServer/" + info.id, {
					  mode: esri.layers.FeatureLayer.MODE_ONDEMAND, //点击才获取features,MODE_SNAPSHOT默认获取1000行
					  outFields: ["OBJECTID",'ZLDWMC','DLMC']  //可以通过图层获取当前的FetureClass的所有属性
				});
		    }else{
		    	featureLayer = new esri.layers.FeatureLayer(currentObj.mapServerPath+"/jnds/MapServer/" + info.id, {
					  mode: esri.layers.FeatureLayer.MODE_SNAPSHOT, //点击才获取features,MODE_SNAPSHOT默认获取1000行
					  outFields: ["*"]  //可以通过图层获取当前的FetureClass的所有属性
				});
		    }
		    //如果不显示通过表达式让其不显示
		    if(!d){
		    	featureLayer.setDefinitionExpression(" OBJECTID < 0 ");
		    }
		    if(ArcgisMap.isTownLayer(info.id)){
		    	currentObj.townLayer = featureLayer;
		    	dojo.connect(currentObj.townLayer,'onClick',function(evt){
			    	if(!ArcgisMap.DRAW){
		    			if(currentObj.townclick){
					      currentObj.townclick.call(currentObj,evt);
					    }else{
							var content = evt.graphic.attributes.XZQMC;
							content = "<b>"+content+"</b>";
							var geometry = evt.graphic.geometry;
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
		    	});
		    	if(params.townlayerender){
		    		currentObj.townLayer.setRenderer(params.townlayerender);
		    	}
		    }
		    if(ArcgisMap.isVillageLayer(info.id)){
		    	currentObj.villageLayer = featureLayer;
		    	dojo.connect(currentObj.villageLayer,'onClick',function(evt){
		    		if(!ArcgisMap.DRAW){
		    			if(currentObj.villageclick){
					      currentObj.villageclick.call(currentObj,evt);
					    }else{
					    	//默认方法
				    		var content = evt.graphic.attributes.XZQMC;
							content = "<b>"+content+"</b>";
							var geometry = evt.graphic.geometry;
						    currentObj.map.graphics.clear();
						    var highlightSymbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255,100,0]), 3), new dojo.Color([125,125,125,0.35]));
						    var highlightGraphic = new esri.Graphic(geometry,highlightSymbol);
						    currentObj.map.graphics.add(highlightGraphic);
						    currentObj.map.infoWindow.resize(250,100);
						    currentObj.map.infoWindow.setTitle('村委会');
						    currentObj.map.infoWindow.setContent(content);
							currentObj.map.infoWindow.show(evt.screenPoint,currentObj.map.getInfoWindowAnchor(evt.screenPoint));
					    }
		    		}
  	            });
		    	if(params.villagelayerender){
		    		currentObj.townLayer.setRenderer(params.villagelayerender);
		    	}
		    }
		    if(ArcgisMap.isForestLayer(info.id)){
		    	//featureLayer.setDefinitionExpression(" OBJECTID =380 ");
		    	currentObj.forestLayer = featureLayer;	
		    	dojo.connect(currentObj.forestLayer,'onClick',function(evt){
		    		if(!ArcgisMap.DRAW){
		    			if(currentObj.forestclick){
						 currentObj.forestclick.call(currentObj,evt);
						}else{
							var content = evt.graphic.attributes.ZLDWMC;
						    content += ","+evt.graphic.attributes.DLMC;
						    content = "<b>"+content+"</b>";
						    var geometry = evt.graphic.geometry;
						    currentObj.map.graphics.clear();
						    var highlightSymbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255,100,0]), 3), new dojo.Color([125,125,125,0.35]));
						    var highlightGraphic = new esri.Graphic(geometry,highlightSymbol);
						    currentObj.map.graphics.add(highlightGraphic);
						    currentObj.map.infoWindow.resize(250,100);
						    currentObj.map.infoWindow.setTitle('农田林地');
						    currentObj.map.infoWindow.setContent(content);
							currentObj.map.infoWindow.show(evt.screenPoint,currentObj.map.getInfoWindowAnchor(evt.screenPoint));
						}
		    		}
  	            });
		    	///* 颜色渲染保留，不要删除   不渲染没有click事件(因为这个形状的透明度为100%，因此选不中)，所以林地的透明度不能为100%，设置为90%
  	            var symbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, //形状内填充类型
        	    new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([0,0,0]),1), //形状的边框的颜色及粗细
        	    new dojo.Color([0,0,0,0]));
		    	var render = new esri.renderer.SimpleRenderer(symbol);
				featureLayer.setRenderer(render);
		    }
		    if(ArcgisMap.isTdgyLayer(info.id)){
		    	//featureLayer.setDefinitionExpression(" OBJECTID in (1159,1160) ");
		    	currentObj.tdgyLayer = featureLayer;
  	            dojo.connect(currentObj.tdgyLayer,'onClick',function(evt){
  	            	  if(!ArcgisMap.DRAW){
  	            		  if(currentObj.tdgyclick){
							currentObj.tdgyclick.call(currentObj,evt);
						 }else{
							 //默认处理方法
							var currenObjectId = evt.graphic.attributes.OBJECTID;
							currentObj.focusLand(false,evt,evt.graphic);
							var zdbh = evt.graphic.attributes.ZDBH;
							var actualArea = evt.graphic.attributes.ACTUALAREA;
							actualArea = parseFloat(actualArea).toFixed(3);
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
										       content += "<tr><th>权属人</th><th>宗地编号</th><th>交付日期</th><th>土地面积</th><th>土地总价</th><th>实际面积(平方米)</th></tr>";
										       //content +="<tr><td colspan='6'><a href='xx()'>删除此地块</a></td></tr>";
										       for(var i = 0;i < jsondata.length;i++){
										    	   var land = jsondata[i];
										    	   content += "<tr><td>"+land.taxpayername+"</td><td>"+land.estateserialno+"</td>"+
										    	              "<td>"+ArcgisMap.formatterDate(land.holddate)+"</td>"+
										    	              "<td>"+land.landarea+"</td><td>"+land.landmoney+"</td><td>"+actualArea+"</td></tr>";
										       }	   
										       content += '</table>';
										       currentObj.map.infoWindow.resize(600,300);
										       currentObj.map.infoWindow.setTitle(title);
											   currentObj.map.infoWindow.setContent(content);
											   currentObj.map.infoWindow.show(evt.screenPoint,currentObj.map.getInfoWindowAnchor(evt.screenPoint));
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
  	            	  }
  	            });
		    	var defaultSymbol = new esri.symbol.SimpleFillSymbol().setStyle(esri.symbol.SimpleFillSymbol.STYLE_NULL);
				defaultSymbol.outline.setStyle(esri.symbol.SimpleLineSymbol.STYLE_NULL);
				var renderer = new esri.renderer.UniqueValueRenderer(defaultSymbol, "ISRELATION");
				renderer.addValue("01", new esri.symbol.SimpleFillSymbol().setColor(new dojo.Color([124,252,0,0.5])));//已关联
				renderer.addValue("00", new esri.symbol.SimpleFillSymbol().setColor(new dojo.Color([135,206,235,0.5])));//未关联
				featureLayer.setRenderer(renderer);
				
				var selectionSymbol = new esri.symbol.SimpleFillSymbol().setColor(new dojo.Color([255,0,0,0.5]));
                featureLayer.setSelectionSymbol(selectionSymbol);
		    }
		    if(ArcgisMap.isTaxpayerLayer(info.id)){
		    	currentObj.taxpayerLayer = featureLayer;
		    	dojo.connect(currentObj.taxpayerLayer,'onClick',function(evt){
			    	if(!ArcgisMap.DRAW){
  	            		  if(currentObj.taxpayerclick){
							currentObj.taxpayerclick.call(currentObj,evt);
						 }
  	                }
			    });
		    	var symbolok = new esri.symbol.PictureMarkerSymbol({
						"angle"      :0,
						"xoffset"    :0,
						"yoffset"    :10,
						"type"       :"esriPMS",
						"url"        :"/images/GreenPin1LargeB.png",
						"contentType":"image/png",
						"width"      :24,
						"height"     :24
					});
                    var symbolbad = new esri.symbol.PictureMarkerSymbol({
						"angle"      :0,
						"xoffset"    :0,
						"yoffset"    :10,
						"type"       :"esriPMS",
						"url"        :"/images/BluePin1LargeB.png",
						"contentType":"image/png",
						"width"      :24,
						"height"     :24
					});
                    //欠税
                    var symbolown = new esri.symbol.PictureMarkerSymbol({
						"angle"      :0,
						"xoffset"    :0,
						"yoffset"    :10,
						"type"       :"esriPMS",
						"url"        :"/images/RedPin1LargeB.png",
						"contentType":"image/png",
						"width"      :24,
						"height"     :24
					});
                    
//                    symbolok = new esri.symbol.SimpleMarkerSymbol();
//			        symbolok.setColor(new dojo.Color([0,155,246]));
//			        symbolbad = new esri.symbol.SimpleMarkerSymbol();
//			        symbolbad.setColor(new dojo.Color([231,0,14]));
			        
                    var defaultSymbol = new esri.symbol.SimpleFillSymbol().setStyle(esri.symbol.SimpleFillSymbol.STYLE_NULL);
					defaultSymbol.outline.setStyle(esri.symbol.SimpleLineSymbol.STYLE_NULL);
					//defaultSymbol.setColor(new dojo.Color([246,51,121]));
					var renderer = new esri.renderer.UniqueValueRenderer(defaultSymbol, "ISRELATION");

					renderer.addValue("01", symbolok);//已关联
					renderer.addValue("00", symbolbad);//未关联
					featureLayer.setRenderer(renderer);
					
					featureLayer.setSelectionSymbol(symbolown);
		    }
		    currentObj.map.addLayer(featureLayer);
	    }
	    //currentObj.map.reorderLayer(currentObj.forestLayer.id,12);	
	    if(params.layerloaded){
	    	params.layerloaded.call(currentObj);
	    }
	    
    }
    if(params.loadingdiv){
    	var loading = dojo.byId(params.loadingdiv);
    	 var layersLoaded = 0;  
        //在地图缩放等操作显示进度图标
        dojo.connect(this.map, "onZoomStart", showLoading);
        dojo.connect(this.map, "onPanStart", showLoading);
		dojo.connect(dynamicMapServiceLayer, "onUpdate", hideLoading);
		if(arcGISTiledMapServiceLayer)
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
ArcgisMap.MapServerPath = "http://154.20.158.3:8002/jnds_rest/services";
ArcgisMap.formatterDate = function(value){
	return formatDatebox(value);
}
ArcgisMap.DRAW = false;
ArcgisMap.taxpayerlayerid = 0;
ArcgisMap.tdgylayerid = 1;
ArcgisMap.forestlayerid = 2;
ArcgisMap.villagelayerid = 3;
ArcgisMap.townlayerid = 4;
ArcgisMap.findLayers = [1,2,3,4];

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


//算面积、周长,callbak回调行数
ArcgisMap.calculateAreaAndLength = function(geometry,callback){
	if(!geometry){throw 'geometry参数必须需要';}
	var geometryService = new esri.tasks.GeometryService(ArcgisMap.MapServerPath+"/Geometry/GeometryServer");
	geometryService.on("areas-and-lengths-complete", outputAreaAndLength);
    function outputAreaAndLength(evtObj){
    	var result = evtObj.result;
    	if(callback){
    		callback.call(null,result.areas,result.lengths);
    	}
    }
    var areasAndLengthParams = new esri.tasks.AreasAndLengthsParameters();
    areasAndLengthParams.lengthUnit = esri.tasks.GeometryService.UNIT_METER;
    console.log("lengthunit="+esri.tasks.GeometryService.UNIT_METER+"=");
    console.log("areaunit="+esri.tasks.GeometryService.UNIT_SQUARE_METERS+"=");
    areasAndLengthParams.areaUnit = esri.tasks.GeometryService.UNIT_SQUARE_METERS;
    geometryService.simplify([geometry], function(simplifiedGeometries) {
    areasAndLengthParams.polygons = simplifiedGeometries;
        geometryService.areasAndLengths(areasAndLengthParams);
    });
}
//合并面 polygon
ArcgisMap.unionPolygon = function(geometrys,callback){
	if(!geometrys){throw 'geometrys参数必须需要';}
	var geometryService = new esri.tasks.GeometryService(ArcgisMap.MapServerPath+"/Geometry/GeometryServer");
	geometryService.union(geometrys,callback);
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
ArcgisMap.prototype.displayTiledMap = function(display){
	this.tiledlayer.setVisibility(display);
}
ArcgisMap.prototype.focusLand = function(iszoom,objectidOrClickEvent,graphics){
	this.map.infoWindow.hide();
	var objectid = parseInt(objectidOrClickEvent);
	if(!graphics && !objectid){  //通过objectid，不是数字
		return;
	}
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
        if(g == null || point == null){
        	return;
        }
	}else{
		point = objectidOrClickEvent.mapPoint;
		g = graphics;
	}
	if(iszoom){
		var centerPoint = point;
	    this.map.centerAndZoom(centerPoint,5);
	}
	var geometry = g.geometry;
    this.map.graphics.clear();
    var highlightSymbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255,100,0]), 3), new dojo.Color([125,125,125,0.35]));
    var highlightGraphic = new esri.Graphic(geometry,highlightSymbol);
    this.map.graphics.add(highlightGraphic);
    return g;
}
/**
 * 此方法不用了
 * @param {Object} evt
 * @memberOf {TypeName} 
 */
ArcgisMap.prototype.defaultClick = function(evt){
	//alert(this.visiblelayer);
	var identifyTask = new esri.tasks.IdentifyTask(this.mapServerPath+"/jnds/MapServer");
	var identifyParams = new esri.tasks.IdentifyParameters();
	identifyParams.tolerance = 3;
	identifyParams.returnGeometry = true;
	identifyParams.layerIds = this.visiblelayer;
	identifyParams.layerOption = esri.tasks.IdentifyParameters.LAYER_OPTION_ALL;
	identifyParams.width  = this.map.width;
	identifyParams.height = this.map.height;
	identifyParams.geometry = evt.mapPoint;
	identifyParams.mapExtent = this.map.extent;
	
	var currentObj = this;
	identifyTask.execute(identifyParams,function(idResults) {
		if(!ArcgisMap.DRAW && idResults.length > 0){
			var layerid = idResults[0].layerId;//点击的最上面一层
		
			if(currentObj.getTaxpayerLayer().visible &&  ArcgisMap.isTaxpayerLayer(layerid)){
				if(currentObj.taxpayerclick){
					currentObj.taxpayerclick.call(currentObj,evt);
				}
			}else if(currentObj.getTdgyLayer().visible && ArcgisMap.isTdgyLayer(layerid)){
				if(currentObj.tdgyclick){
					evt.graphic = idResults[0].feature;
					currentObj.tdgyclick.call(currentObj,evt);
				}else{
					var currenObjectId = idResults[0].feature.OBJECTID;
					var tdgyLayer = currentObj.getTdgyLayer();
					for(var i = 0;i < tdgyLayer.graphics.length;i++){
						var g = tdgyLayer.graphics[i];
					}
					currentObj.focusLand(false,evt,idResults[0].feature);
					var zdbh = idResults[0].feature.attributes.ZDBH;
					var actualArea = idResults[0].feature.attributes.ACTUALAREA;
					actualArea = parseFloat(actualArea).toFixed(3);
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
							       content += "<tr><th>权属人</th><th>宗地编号</th><th>交付日期</th><th>土地面积</th><th>土地总价</th><th>实际面积(平方米)</th></tr>";
							       content +="<tr><td colspan='6'><a href='javascript:xx()'>删除此地块</a></td></tr>";
							       for(var i = 0;i < jsondata.length;i++){
							    	   var land = jsondata[i];
							    	   content += "<tr><td>"+land.taxpayername+"</td><td>"+land.estateserialno+"</td>"+
							    	              "<td>"+ArcgisMap.formatterDate(land.holddate)+"</td>"+
							    	              "<td>"+land.landarea+"</td><td>"+land.landmoney+"</td><td>"+actualArea+"</td></tr>";
							       }	   
							       content += '</table>';
							       currentObj.map.infoWindow.resize(500,300);
							       currentObj.map.infoWindow.setTitle(title);
								   currentObj.map.infoWindow.setContent(content);
								   currentObj.map.infoWindow.show(evt.screenPoint,currentObj.map.getInfoWindowAnchor(evt.screenPoint));
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
			}else if(currentObj.getForestLayer().visible && ArcgisMap.isForestLayer(layerid)){
				if(currentObj.forestclick){
					currentObj.forestclick.call(currentObj,evt);
				}else{
					var content = idResults[0].feature.attributes.坐落单位名称;
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
			}else if(currentObj.getVillageLayer().visible && ArcgisMap.isVillageLayer(layerid)){
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
			}else if(currentObj.getTownLayer().visible && ArcgisMap.isTownLayer(layerid)){
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
		 }else{
			 callback({OBJECTID:''});
		 }
	});
}
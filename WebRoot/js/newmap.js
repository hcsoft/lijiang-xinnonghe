var url="http://127.0.0.1:8090/iserver/services/map-smtiles-BaseMap80/rest/maps/BaseMap80";

var imgurl="http://127.0.0.1:8090/iserver/services/map-smtiles-BaseImage80/rest/maps/BaseImage80";
var dataurl = "http://localhost:8090/iserver/services/data-JinNingDiShui/rest/data";
var layerurl="http://127.0.0.1:8090/iserver/services/map-JinNingDiShui/rest/maps/Tax80";
var tdgydataseturl = "http://127.0.0.1:8090/iserver/services/data-JinNingDiShui/rest/data/datasources/SUPERMAP/datasets/TDGY";
var taxpayerinfodataseturl = "http://127.0.0.1:8090/iserver/services/data-JinNingDiShui/rest/data/datasources/SUPERMAP/datasets/TAXPAYERINFO";
var map,layer,imglayer;
var ids;
var opttype;//'query','opt'
var vmap, imgmap = false;
var  tdgylayer,vectorlayer,selectvectorlayer, select,drawPoint,drawPolygon,modifyFeature,pointvectorlayer,selectFeature;
var infowin = null;//信息提示窗口
var showdiv;//用作显示信息div
var imgurl;
var d1,d2,d3,d4,d5,d6,d7;
var selectstyle00 ={
	strokeColor: "#FF0000",
	strokeWidth: 2,
	pointerEvents: "visiblePainted",
	fillColor: "#3300FF",
	fillOpacity: 0.3
};
var selectstyle01 ={
	strokeColor: "#FF0000",
	strokeWidth: 2,
	pointerEvents: "visiblePainted",
	fillColor: "#FF6600",
	fillOpacity: 0.3
};
var style01 ={
	strokeColor: "#FF6600",
	strokeWidth: 1,
	pointerEvents: "visiblePainted",
	fillColor: "#FF6600",
	fillOpacity: 0.3
};
var style00 ={
	strokeColor: "#3300FF",
	strokeWidth: 1,
	pointerEvents: "visiblePainted",
	fillColor: "#3300FF",
	fillOpacity: 0.3
};

var style1= {
	graphic:true,
	pointRadius: 18,
	externalGraphic: "/theme/images/green.png"
},
style0 = {
	graphic:true,
	pointRadius: 18,
	externalGraphic: "/theme/images/blue.png"
}
var defaultScales = [1/917244.33942211524,1/458622.16971105774,1/229311.08485552887,1/114655.54242776403,1/57327.771213882072,1/28663.885606941119,1/14331.942803470498,1/7165.971401735279,1/3582.9857008676395,1/1791.4928504338197];




function mapInit(mapdiv) {
	//map = new SuperMap.Map(mapdiv);
	SuperMap.Control.SKIN = "BLUE";
	map = new SuperMap.Map(mapdiv,{controls: [
            new SuperMap.Control.LayerSwitcher(),
            new SuperMap.Control.ScaleLine(),
            new SuperMap.Control.PanZoomBar({}),
            new SuperMap.Control.Navigation({
                dragPanOptions: {
                    enableKinetic: true
                }
            })]
        });
	//创建分块动态REST图层，该图层显示iserver 7C 服务发布的地图,
	//其中“world”为图层名称，url图层的服务地址，{transparent: true}设置到url的可选参数
	layer  = new SuperMap.Layer.TiledDynamicRESTLayer("矢量图",url, {transparent: true, cacheEnabled: true},{maxResolution: "auto",scales:defaultScales});
	//layer = new SuperMap.Layer.TiledDynamicRESTLayer("World", url, {transparent: true, cacheEnabled: true},{maxResolution: "auto",scales:defaultScales});
	//layer.isBaseLayer=true;

	
	//layer = new SuperMap.Layer.TiledDynamicRESTLayer("World", url, {transparent: true, cacheEnabled: true},{maxResolution: "auto",scales:defaultScales});
	//imglayer.isBaseLayer=true;
	//map.addControl(new SuperMap.Control.LayerSwitcher(),new SuperMap.Control.PanZoomBar({"showSlider":true}),new SuperMap.Control.ScaleLine(), new SuperMap.Pixel(34560339.23 , 2726080.76),);
	//map.allOverlays = true;
	layer.events.on({
		"layerInitialized": addimgLayer
	});
	//markerLayer = new SuperMap.Layer.Vector("Vector Layer");
	//tdgylayer = new SuperMap.Layer.Vector("Vector Layer");
	
}

function addimgLayer(){
	imglayer  = new SuperMap.Layer.TiledDynamicRESTLayer("卫星图",imgurl, {transparent: true, cacheEnabled: true},{maxResolution: "auto",scales:defaultScales});
	imglayer.events.on({
		"layerInitialized": addLayer
	});
}

function addLayer() {
	//tdgylayer = new SuperMap.Layer.TiledDynamicRESTLayer("tdgy", layerurl, {
	//	transparent: true,
	//	cacheEnabled: false
	//});
	//tdgylayer.isBaseLayer=false;
	//tdgylayer.setOpacity(0.6);
	//tdgylayer.events.on({
	//	"layerInitialized": function(){
			
			vectorlayer = new SuperMap.Layer.Vector("地块");
			//selectvectorlayer = new SuperMap.Layer.Vector("selectvectorlayer");
			pointvectorlayer = new SuperMap.Layer.Vector("地块中心点",{renderers: ["Canvas2"]});
			//markerLayer = new SuperMap.Layer.Markers("Markers"); //创建一个有标签的图层
			//modifyFeature = new SuperMap.Control.ModifyFeature(vectorlayer);
			selectFeature = new SuperMap.Control.SelectFeature(pointvectorlayer, {onSelect: onFeatureSelect, onUnselect: onFeatureUnselect, repeat:true});
            map.addControl(selectFeature);
			//map.addControl(select);
			//初始化绘制控件
			drawPoint = new SuperMap.Control.DrawFeature(layer, SuperMap.Handler.Point);
			drawPoint.events.on({
				"featureadded": selectedFeatureCompleted//绘制完成选中该feature
			});
			//map上添加控件
			map.addControl(drawPoint);

			drawPolygon = new SuperMap.Control.DrawFeature(vectorlayer, SuperMap.Handler.Polygon);
            drawPolygon.events.on({"featureadded": addFeatureCompleted});
			//map上添加控件
			map.addControl(drawPolygon);

			//map.addControl(modifyFeature);
			//将Layer图层加载到Map对象上
			map.addLayers([layer,imglayer,vectorlayer, pointvectorlayer]);;
			//出图，map.setCenter函数显示地图，设置中心点
			map.setCenter(new SuperMap.LonLat(34560339.23 , 2726080.76 ), 2);
			query(0);//调用查询
		//}
	//});
	
	//select.activate();
}



//var getMarkerLayer = function(){
//	return markerLayer;
//}
//var getTdgyLayer = function(){
//	return tdgylayer;
//}
var getVectorlayer = function(){
	return vectorlayer;
}


function mapreload(){
	vectorlayer.removeAllFeatures();
	selectvectorlayer.removeAllFeatures();
	map.removeLayer(vectorlayer,false);
	map.removeLayer(markerLayer,false);
	vectorlayer = new SuperMap.Layer.Vector("Vector Layer");
	markerLayer = new SuperMap.Layer.Markers("Markers"); //创建一个有标签的图层
	//modifyFeature = new SuperMap.Control.ModifyFeature(vectorlayer);

	//map.addControl(select);
	//初始化绘制控件
	drawPoint = new SuperMap.Control.DrawFeature(layer, SuperMap.Handler.Point);
	drawPoint.events.on({
		"featureadded": selectedFeatureCompleted//绘制完成选中该feature
	});
	//map上添加控件
	map.addControl(drawPoint);

	drawPolygon = new SuperMap.Control.DrawFeature(vectorlayer, SuperMap.Handler.Polygon);
	drawPolygon.events.on({"featureadded": addFeatureCompleted});
	//map上添加控件
	map.addControl(drawPolygon);

	//map.addControl(modifyFeature);
	//将Layer图层加载到Map对象上
	map.addLayers([layer,vectorlayer, selectvectorlayer,markerLayer]);;
	//出图，map.setCenter函数显示地图，设置中心点
	//map.setCenter(selectmarker.getLonLat(), 5);
	//map.setCenter(new SuperMap.LonLat(34560339.23 , 2726080.76), 3);
	querymapinfo();//调用查询
	//vectorlayer.removeAllFeatures();
	//vectorlayer.redraw();
	//markerLayer.redraw();
	//tdgylayer.redraw();
	//vectorlayer.redraw();
}

function querymapinfo(){
	var smids;//通过后端获取
	var queryParam, queryBySQLParams, queryService;
	queryParam = new SuperMap.REST.FilterParameter({
		name: "TAXPAYERINFO@SUPERMAP",
		attributeFilter: "SMID >0 "
	}); //FilterParameter设置查询条件，name是必设的参数，（图层名称格式：数据集名称@数据源别名）
	queryBySQLParams = new SuperMap.REST.QueryBySQLParameters({
		queryParams: [queryParam]
		//bounds: bounds
	}); //queryParams查询过滤条件参数数组。bounds查询范围
	queryService = new SuperMap.REST.QueryBySQLService(layerurl, {
		eventListeners: {
			"processCompleted": processCompleted,
			"processFailed": processFailed
		}
	});
	d1 = new Date();
	queryService.processAsync(queryBySQLParams); //向服务端传递参数，然后服务端返回对象
	
	//var queryParam, queryBySQLParams, queryService;
	queryParam = new SuperMap.REST.FilterParameter({
		name: "tdgy@SUPERMAP",
		attributeFilter: "SMID >0 "
	}); //FilterParameter设置查询条件，name是必设的参数，（图层名称格式：数据集名称@数据源别名）
	queryBySQLParams = new SuperMap.REST.QueryBySQLParameters({
		queryParams: [queryParam]
		//bounds: bounds
	}); //queryParams查询过滤条件参数数组。bounds查询范围
	queryService = new SuperMap.REST.QueryBySQLService(layerurl, {
		eventListeners: {
			"processCompleted": tdgyprocessCompleted,
			"processFailed": processFailed
		}
	});
	d4= new Date();
	queryService.processAsync(queryBySQLParams); //向服务端传递参数，然后服务端返回对象
}

function querymapinfoonly(pointsmid,landsmid){
	var smids;//通过后端获取
	var queryParam, queryBySQLParams, queryService;
	queryParam = new SuperMap.REST.FilterParameter({
		name: "TAXPAYERINFO@SUPERMAP",
		attributeFilter: "SMID in ("+pointsmid+")"
	}); //FilterParameter设置查询条件，name是必设的参数，（图层名称格式：数据集名称@数据源别名）
	queryBySQLParams = new SuperMap.REST.QueryBySQLParameters({
		queryParams: [queryParam]
		//bounds: bounds
	}); //queryParams查询过滤条件参数数组。bounds查询范围
	queryService = new SuperMap.REST.QueryBySQLService(layerurl, {
		eventListeners: {
			"processCompleted": processCompleted,
			"processFailed": processFailed
		}
	});
	queryService.processAsync(queryBySQLParams); //向服务端传递参数，然后服务端返回对象
	
	//var queryParam, queryBySQLParams, queryService;
	queryParam = new SuperMap.REST.FilterParameter({
		name: "tdgy@SUPERMAP",
		attributeFilter: "SMID in ("+landsmid+")"
	}); //FilterParameter设置查询条件，name是必设的参数，（图层名称格式：数据集名称@数据源别名）
	queryBySQLParams = new SuperMap.REST.QueryBySQLParameters({
		queryParams: [queryParam]
		//bounds: bounds
	}); //queryParams查询过滤条件参数数组。bounds查询范围
	queryService = new SuperMap.REST.QueryBySQLService(layerurl, {
		eventListeners: {
			"processCompleted": tdgyprocessCompleted,
			"processFailed": processFailed
		}
	});
	//alert(vectorlayer.features.length);
	queryService.processAsync(queryBySQLParams); //向服务端传递参数，然后服务端返回对象
}

function selectedFeatureCompleted(drawGeometryArgs) {
	drawPoint.deactivate();
	var getFeaturesByGeometryParams, getFeaturesByGeometryService, geometry = drawGeometryArgs.feature.geometry;
	getFeaturesByGeometryParams = new SuperMap.REST.GetFeaturesByGeometryParameters({
		datasetNames: ["World:Countries"],
		spatialQueryMode: SuperMap.REST.SpatialQueryMode.INTERSECT,
		geometry: geometry
	});
	getFeaturesByGeometryService = new SuperMap.REST.GetFeaturesByGeometryService(dataurl, {
		eventListeners: {
			"processCompleted": selectedFeatureProcessCompleted,
			"processFailed": processFailed
		}
	});
	getFeaturesByGeometryService.processAsync(getFeaturesByGeometryParams);
}

//根据点的smid选择点和面
function selectPoint(smid){
	var queryParam, queryBySQLParams, queryService;
	queryParam = new SuperMap.REST.FilterParameter({
		name: "Capitals@World.1",
		attributeFilter: "SMID ="+smid
	}); //FilterParameter设置查询条件，name是必设的参数，（图层名称格式：数据集名称@数据源别名）
	queryBySQLParams = new SuperMap.REST.QueryBySQLParameters({
		queryParams: [queryParam]
		//bounds: bounds
	}); //queryParams查询过滤条件参数数组。bounds查询范围
	queryService = new SuperMap.REST.QueryBySQLService(url, {
		eventListeners: {
			"processCompleted": processCompleted,
			"processFailed": processFailed
		}
	});
	queryService.processAsync(queryBySQLParams); //向服务端传递参数，然后服务端返回对象 
}

//查询成功回调
function processCompleted(queryEventArgs) {
	d2= new Date();
	var i, j, result = queryEventArgs.result,
	marker; //queryEventArgs服务端返回的对象
	var smId;
	if (result && result.recordsets) {
		for (i = 0, recordsets = result.recordsets, len = recordsets.length; i < len; i++) {
			if (recordsets[i].features) {//判断是否进行税源关联?
				pointvectorlayer.removeFeatures(recordsets[i].features);
				for (j = 0; j < recordsets[i].features.length; j++) {
					var f = recordsets[i].features[j];
					
					var point = f.geometry,
					size = new SuperMap.Size(44, 33),
					offset = new SuperMap.Pixel( - (size.w / 2), -size.h);
					var icon;
					if(f.attributes.ISRELATION =='01'){//已关联，绿色
						f.style = style1;
						f.style.graphicXOffset = offset.x;
						f.style.graphicYOffset = offset.y;
						//icon = new SuperMap.Icon("/theme/images/green.png", size, offset);
					}else{
						f.style = style0;
						f.style.graphicXOffset = offset.x;
						f.style.graphicYOffset = offset.y;
						//icon = new SuperMap.Icon("/theme/images/blue.png", size, offset);
					}
					//map.setCenter(new SuperMap.LonLat(point.x, point.y), 4);
					/*--marker = new SuperMap.Marker(new SuperMap.LonLat(point.x, point.y), icon);
					marker.smid = f.attributes.SMID;
					marker.ISRELATION = f.attributes.ISRELATION;
					marker.geometry = f.geometry;
					marker.pointfeature = f;
					 marker.events.on({
						"click": function(){//click事件
									closeInfoWin();
									var marker = this;
									selectmarker = marker;
									//marker.selected = true;//判断是否选中
									var lonlat = marker.getLonLat();
									var size = new SuperMap.Size(0, 33);
									var offset = new SuperMap.Pixel(0, -size.h);
									var contentHTML='';
									if(marker.ISRELATION =='01'){//已关联，绿色
										contentHTML = "<div style='width:160px;font-size:1em; opacity: 0.8; overflow-y:hidden;'><div><b><a style='pading:1px;' href='javascript:showEstateInfo(1,"+marker.smid+")'>查看此地块关联的税源信息</a></b>"+
														"<br/><b><a style='pading:1px;' href='javascript:deleteRelationEstate("+marker.smid+")'>删除此地块关联的税源信息</a></b>"+
														"<br/><b><a style='pading:1px;' href='javascript:showEstateInfo(2,"+marker.smid+")'>二次关联</a></b></div>";
									}else{
										contentHTML = "<div style='width:130px;font-size:1em; opacity: 0.8; overflow-y:hidden;'><div><b><a href='javascript:showEstateInfo(0,"+marker.smid+")'>税源关联</a></b><br/><b><a href='javascript:deleteland("+marker.smid+")'>删除地块</a></b></div></div>";
									}
									//var icon = new SuperMap.Icon("/theme/images/marker.png", size, offset);
									var popup = new SuperMap.Popup.FramedCloud("popwin", new SuperMap.LonLat(lonlat.lon, lonlat.lat), null, contentHTML, icon, true);
									infowin = popup;
									selectmarker.popup = popup;
									map.addPopup(popup);
									showPiece(marker);
								},
						"scope"
					markerLayer.addMarker(marker);--*/
					//showPiece(marker);//显示当前点所在的面
				}
				pointvectorlayer.addFeatures(recordsets[i].features);
				selectFeature.activate();
			}
		}
	}
	d3= new Date();
}

//查询所有面成功后回调
function tdgyprocessCompleted(getFeaturesEventArgs){
	//alert('2222======='+vectorlayer.features.length);
	d5= new Date();
	var i,j, result = getFeaturesEventArgs.result;
	if (result && result.recordsets) {
		for (i = 0, recordsets = result.recordsets, len = recordsets.length; i < len; i++) {
			if (recordsets[i].features) {
				vectorlayer.removeFeatures(recordsets[i].features);
				//vectorlayer.addFeatures(recordsets[i].features);
				for (j = 0; j < recordsets[i].features.length; j++) {
					var f = recordsets[i].features[j];
					
					if(f.attributes.ISRELATION=='01'){//已关联，绿色
						f.style = style01;//渲染feature样式
					}else{
						f.style = style00;//渲染feature样式
					}
					vectorlayer.addFeatures(f);
				}
			}
		}
	}
	//alert('3333======='+vectorlayer.features.length);
	d6= new Date();
	//alert('d1='+d1+'\n'+'d2='+d2+'\n'+'d3='+d3+'\n'+'d4='+d4+'\n'+'d5='+d5+'\n'+'d6='+d6+'\n');
}

//显示面，并选中
function showPiece(marker){
	var getFeaturesByGeometryParams, getFeaturesByGeometryService, geometry = marker.geometry;
	getFeaturesByGeometryParams = new SuperMap.REST.GetFeaturesByGeometryParameters({
		datasetNames: ["Tax:tdgy"],
		spatialQueryMode: SuperMap.REST.SpatialQueryMode.INTERSECT,
		geometry: geometry
	});
	getFeaturesByGeometryService = new SuperMap.REST.GetFeaturesByGeometryService(dataurl, {
		eventListeners: {
			"processCompleted": selectedFeatureProcessCompleted,
			"processFailed": processFailed
		}
	});
	getFeaturesByGeometryService.processAsync(getFeaturesByGeometryParams);
}
//选择地物完成
function selectedFeatureProcessCompleted(getFeaturesEventArgs) {
	var features, feature, i, len, originFeatures = getFeaturesEventArgs.originResult.features,
	result = getFeaturesEventArgs.result;
	//vectorlayer.removeAllFeatures();
	if (originFeatures === null || originFeatures.length === 0) {
		alert("查询地物为空");
		return;
	}
	//vectorlayer.redraw();
	selectvectorlayer.removeAllFeatures();
	//querymapinfo();
	//ids = new Array();
	//将当前选择的地物的ID保存起来，以备删除地物使用,并在编辑地物中使之为null，以免编辑地物后在不选择地物时将所编辑的地物删除
	//for (i = 0, len = originFeatures.length; i < len; i++) {
	//	ids.push(originFeatures[i].ID);
	//}
	if (result && result.features) {
		features = result.features;
		for (var j = 0,
		len = features.length; j < len; j++) {
			feature = features[j];
			if(selectmarker != null && selectmarker != undefined){
				selectmarker.tdgysmid = feature.attributes.SMID;
				selectmarker.tdgyfeature = feature;
			}
			feature.style = style;
			selectvectorlayer.addFeatures(feature);
			//vectorlayer.drawFeature(feature);
		}
	}
}
function processFailed(e) {
	alert(e.error.errorMsg);
}

//关闭显示窗口
function closeInfoWin() {
	if (infowin) {
		try {
			infowin.hide();
			infowin.destroy();
		} catch(e) {}
	}
}

//清除所有feature
function clearFeatures() {
	//先清除上次的显示结果
	//vectorlayer.removeAllFeatures();
	vectorlayer.refresh();
}


/********************************地图编辑*********************************************/


 
function clearAllDeactivate() {
	//modifyFeature.deactivate();
	drawPoint.deactivate();
	drawPolygon.deactivate();
}

//执行添加地物
function addFeatureCompleted(drawGeometryArgs) {
	var row = $('#landinfogrid').datagrid('getSelected');
	var pointsmid,landsmid;
	drawPolygon.deactivate();
	
	var geometry = drawGeometryArgs.feature.geometry;
	var point = drawGeometryArgs.feature.geometry.getCentroid();

	geometry.id = "100000";
	var editFeatureParameter,
			editFeatureService,
			features = {
				fieldNames:['ISRELATION','ZDBH'],
				fieldValues:['01',row.estateserialno],
				geometry:geometry
			};
	editFeatureParameter = new SuperMap.REST.EditFeaturesParameters({
		features: [features],
		editType: SuperMap.REST.EditType.ADD,
		returnContent:true
	});
	editFeatureService = new SuperMap.REST.EditFeaturesService(tdgydataseturl, {
		eventListeners: {
			"processCompleted": function(editFeaturesEventArgs){
					landsmid= editFeaturesEventArgs.result.IDs[0];
					
					//增加点
					features = {
								fieldNames:['ISRELATION','TDGYID','ZDBH','VILLAGE','BELONGTOWN','COUNTY','CITY'],
								fieldValues:['01',landsmid,row.estateserialno,row.belongtowns,row.belongtowns.substring(0,9),row.belongtowns.substring(0,6),row.belongtowns.substring(0,4)+'00'],
								geometry:point
							};
					editFeatureParameter = new SuperMap.REST.EditFeaturesParameters({
						features: [features],
						editType: SuperMap.REST.EditType.ADD,
						returnContent:true
					});
					editFeatureService = new SuperMap.REST.EditFeaturesService(taxpayerinfodataseturl, {
						eventListeners: {
							"processCompleted": function(editFeaturesEventArgs){
								pointsmid = editFeaturesEventArgs.result.IDs[0];
								var params = {};
								params['tdgyobjectid'] = landsmid;
								//var xzqdm = attrss.行政区代码;
								params['villagecode'] = row.belongtowns;
								if(!params['tdgyobjectid']){
									$.messager.alert('提示消息','此税源点找不到相应的地块信息!','info');
									return;
								}
								//if(!params['villagecode']){
								//	$.messager.alert('提示消息','此税源点找不到相应的村委会信息!','info');
								//	return;
								//}
								params['taxsourceobjectid'] = pointsmid;
								params['first'] = '0';
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
												$.messager.alert('提示','增加地块成功!','info',function(){
													var tempfeature = vectorlayer.getFeatureBy('style',null);
													vectorlayer.removeFeatures(tempfeature);
													closeInfoWin();
													querymapinfoonly(pointsmid,landsmid);
													query();
												});
										   }else{
											   $.messager.alert('提示','增加地块失败!');
										   }
									   }
							   });
								//querymapinfoonly(pointsmid,landsmid);
							},
							"processFailed": processFailed
						}
					});
					editFeatureService.processAsync(editFeatureParameter);
			},
			"processFailed": processFailed
		}
	});
	editFeatureService.processAsync(editFeatureParameter);


	


}
//添加地物成功
function addFeaturesProcessCompleted(editFeaturesEventArgs) {
	
}


function processFailed(e) {
	alert(e.error.errorMsg);
}

function changemap() {
	if (imgmap == false) {
		layer.setVisibility(false);
		imglayer.setVisibility(true);
		map.setBaseLayer(imglayer);
		$('#weixing').show();
		$('#shiliang').hide();
		imgmap = true;
	} else if (imgmap == true) {
		layer.setVisibility(true);
		imglayer.setVisibility(false);
		map.setBaseLayer(layer);
		$('#weixing').hide();
		$('#shiliang').show();
		imgmap = false;
	}
}
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/common/inc.jsp"%>
<!DOCTYPE html>
  <head>
    <title>地图视角展现</title>
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
	<script src="/js/datecommon.js"></script>	
	<script src="/js/common.js"></script>
	<script src="/js/widgets.js"></script>
	<script>var dojoConfig = { parseOnLoad: true };</script>
    <script src="<%=spath%>/arcgis_js_api/library/3.7/3.7/init.js"></script>
    <script src="/js/mapcommon.js"></script>
<script>
    esri.config.defaults.io.proxyUrl = "proxy.jsp"; 
    var GloabTdgyObjectId = null;
    var arcgisMap = null;
    var map = null;
    
    var OwnTaxPayerObjectIds = null;
    var OwnTdgyObjectIds = null;
    function getTdgyQuery(callback){
    	 var params = getCondition();
  	     var tdgyobjectids = ""; //宗地编号
  	     var taxpayerobjectids = "";
  	     
  	     var tdgynoownary = [];
  	     var taxpayernoownary = [];
  	     
  		 var tdgyownary = [];
  		 var taxpayerownary = [];
		  params['isrelation'] = '1';
		  $.ajax({
			   type:"post",
			   async:true,
			   url: "/viewanalizy/getlandlist.do",
			   data: params,
			   dataType: "json",
			   success: function(jsondata){
				  for(var i = 0;i < jsondata.length;i++){
					  if(jsondata[i].tdgyobjectids){
						  tdgyobjectids += jsondata[i].tdgyobjectids+",";
						  if(jsondata[i].ownstatus == '1'){
							  tdgyownary.push(jsondata[i].tdgyobjectids);
						  }else{
							  tdgynoownary.push(jsondata[i].tdgyobjectids);
						  }
					  }
					  if(jsondata[i].taxpayerobjectids){
						  taxpayerobjectids += jsondata[i].taxpayerobjectids+",";
						  if(jsondata[i].ownstatus == '1'){
							  taxpayerownary.push(jsondata[i].taxpayerobjectids);
						  }else{
							  taxpayernoownary.push(jsondata[i].taxpayerobjectids);
						  }
					  }
				  }
				  if(tdgyobjectids){
					  tdgyobjectids = tdgyobjectids.substring(0,tdgyobjectids.length-1);
				  }
				  if(taxpayerobjectids){
					  taxpayerobjectids = taxpayerobjectids.substring(0,taxpayerobjectids.length-1);
				  }
				  if(callback){
					  callback({'tdgyobjectids':tdgyobjectids,'owntdgyobjectids':tdgyownary.join(',')
						       ,'taxpayerobjectids':taxpayerobjectids,'owntaxpayerobjectids':taxpayerownary.join(',')
						       ,'noowntdgyobjectids':tdgynoownary.join(','),'noowntaxpayerobjectids':taxpayernoownary.join(',')
					           });
				  }
			   }
		   });
    }
	var INITIAL = true;
	function initMap(){
    	getTdgyQuery(function(params){
    		 OwnTaxPayerObjectIds = params.owntaxpayerobjectids;
    		 OwnTdgyObjectIds = params.owntdgyobjectids;
    		 arcgisMap = new ArcgisMap(
			    	   {
			    		  mapdiv:'map',
			    		  notiledmap:true,
			    		  visiblelayer:[ArcgisMap.taxpayerlayerid,ArcgisMap.tdgylayerid,ArcgisMap.villagelayerid,ArcgisMap.townlayerid],
			    		  taxpayerclick:taxpayerLayerClick,
			    		  tdgyclick:tdgyLayerClick,
			    		  villageclick:villageLayerClick,
			    		  townclick:townLayerClick,
			    		  townlayerender:getTownLayerRender(),
			    		  layerloaded:function(){
			    		     var townlayer = arcgisMap.getTownLayer();
			    		     townlayer.setOpacity(0.7);
			    		     var villagelayer = arcgisMap.getVillageLayer();
			    		     villagelayer.setOpacity(0.4);
			    		     var tdgyLayer = arcgisMap.getTdgyLayer();
				    		 var taxpayerLayer = arcgisMap.getTaxpayerLayer();
			    		      if(INITIAL){
			    		    	  setTownVilliage();
				    		      if(params.tdgyobjectids){
				    		    	  tdgyLayer.setDefinitionExpression(" OBJECTID in ("+params.tdgyobjectids+") or ISRELATION = '00' " );
				    		    	  //refresh方法不用调
									  //tdgyLayer.refresh();
				    		      }else{
				    		    	  tdgyLayer.setDefinitionExpression(" OBJECTID < 0 ");
				    		      }
				    		      if(params.taxpayerobjectids){
				    		    	  taxpayerLayer.setDefinitionExpression(" OBJECTID in ("+params.taxpayerobjectids+") or ISRELATION = '00' " );
				    		      }else{
				    		    	  taxpayerLayer.setDefinitionExpression(" OBJECTID < 0 ");
				    		      }
			    		    	  INITIAL = false;
			    		      }
			    		      console.log(OwnTdgyObjectIds+"==="+OwnTaxPayerObjectIds);
			    		      dojo.connect(tdgyLayer,"onUpdateStart",function(){
			    				   if(OwnTdgyObjectIds){
			    					   var q = new esri.tasks.Query();
			    					   q.where = " OBJECTID in ("+OwnTdgyObjectIds+")";
			                           tdgyLayer.selectFeatures(q,esri.layers.FeatureLayer.SELECTION_NEW,function(features){
			                        	   
			                           });
			                           OwnTdgyObjectIds = null;
			    				   }
						      });
			    		      dojo.connect(taxpayerLayer,"onUpdateStart",function(){
			    				   if(OwnTaxPayerObjectIds){
			    					   var q = new esri.tasks.Query();
			    					   q.where = " OBJECTID in ("+OwnTaxPayerObjectIds+")";
			                           taxpayerLayer.selectFeatures(q,esri.layers.FeatureLayer.SELECTION_NEW,function(features){
			                        	   
			                           });
			                           OwnTaxPayerObjectIds = null;
			    				   }
						      });
			    		  }
			    	   }	
			    	);
			        map = arcgisMap.map;
    	});
    }
    function getTownLayerRender(){
    	var symbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, //形状内填充类型
     	      new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([34,35,234]),1), //形状的边框的颜色及粗细
     	      new dojo.Color([245,243,240,1]));
   	    var render = new esri.renderer.SimpleRenderer(symbol);
   	    return render;
    }     
    //1 乡镇  2 村委会  3 土地和税源
    function villageLayerClick(evt){
    	map.graphics.clear();
    	map.infoWindow.hide();
    	if(OPERLAYER == "2"){
    		var geometry = evt.graphic.geometry;
    		var xzqdm = evt.graphic.attributes.XZQDM;
    		var xzqmc = evt.graphic.attributes.XZQMC;
		    var highlightSymbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255,100,0]), 3), new dojo.Color([125,125,125,0.35]));
		    var highlightGraphic = new esri.Graphic(geometry,highlightSymbol);
		    map.graphics.add(highlightGraphic);
		    showDistrictInfo(xzqdm,xzqmc);
    	}else if(OPERLAYER == "1"){
    		townclickevent(evt);
    	}else if(OPERLAYER == "0"){
    	   xianclickevent(evt);
       }
    }
    function townLayerClick(evt){
    	map.graphics.clear();
    	map.infoWindow.hide();
    	if(OPERLAYER == "2"){
    		villageclickevent(evt);
    	}else if(OPERLAYER == "1"){
    		var geometry = evt.graphic.geometry;
    		var xzqdm = evt.graphic.attributes.XZQDM;
    		var xzqmc = evt.graphic.attributes.XZQMC;
		    var highlightSymbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255,100,0]), 3), new dojo.Color([125,125,125,0.35]));
		    var highlightGraphic = new esri.Graphic(geometry,highlightSymbol);
		    map.graphics.add(highlightGraphic);
		    showDistrictInfo(xzqdm,xzqmc);
    	}else if(OPERLAYER == "0"){
    	   xianclickevent(evt);
       }
    }
    function showDistrictInfo(xzqdm,xzqmc){
    	if(!xzqdm)
    		return;
        var params = getCondition();
        params['districtcode'] = xzqdm;
    	$.messager.progress(); 
    	 $.ajax({
			   type:"post",
			   async:true,
			   url: "/viewanalizy/getcompostelandgatherinfo.do",
			   data:params,
			   dataType: "json",
			   success: function(jsondata){
				   $.messager.progress('close'); 
				   var gatherinfo = jsondata.landgatherinfo;
				   for(var p in gatherinfo){
					   var value = gatherinfo[p];
					   $('#xzqgathertable #'+p).val(value);
				   }
				   $('#districttable').datagrid('loadData',jsondata.basetaxlist);
				   $('#xzqinfowindow').window({
			    		title:xzqmc
			    	});
			    	$('#xzqinfowindow').window('open');
			   }
		 });
    }
    function xianclickevent(evt){
    	showDistrictInfo("530122","晋宁县");
    }
    function townclickevent(evt){
    	var point = evt.mapPoint;
    	var g = evt.graphic;
    	var containsvillage = false;
    	var xzqdm = '';
    	var xzqmc = '';
    	var townLayer = arcgisMap.getTownLayer();
    	for(var i=0;i<townLayer.graphics.length;i++){
    		   var graphics = townLayer.graphics[i];
    		   xzqdm = graphics.attributes.XZQDM;
    		   xzqmc = graphics.attributes.XZQMC;
    		   var geometry = graphics.geometry;
   			   if(geometry.contains(point)){
   				    map.graphics.clear();
				    var highlightSymbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255,100,0]), 3), new dojo.Color([125,125,125,0.35]));
				    var highlightGraphic = new esri.Graphic(geometry,highlightSymbol);
				    map.graphics.add(highlightGraphic);
				    containsvillage = true;
				    break;
   			   }
    	}
    	if(containsvillage){
    		showDistrictInfo(xzqdm,xzqmc);
    	}else{
    		$.messager.alert('错误','当前位置没有乡镇！','info',function(){
			   					  
			});
    	}
    }
    function villageclickevent(evt){
    	var point = evt.mapPoint;
    	var g = evt.graphic;
    	var containsvillage = false;
    	var xzqdm = '';
    	var xzqmc = '';
    	var villageLayer = arcgisMap.getVillageLayer();
    	for(var i=0;i<villageLayer.graphics.length;i++){
    		   var graphics = villageLayer.graphics[i];
    		   xzqdm = graphics.attributes.XZQDM;
    		   xzqmc = graphics.attributes.XZQMC;
    		   var geometry = graphics.geometry;
   			   if(geometry.contains(point)){
   				    map.graphics.clear();
				    var highlightSymbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255,100,0]), 3), new dojo.Color([125,125,125,0.35]));
				    var highlightGraphic = new esri.Graphic(geometry,highlightSymbol);
				    map.graphics.add(highlightGraphic);
				    containsvillage = true;
				    break;
   			   }
    	}
    	if(containsvillage){
    		showDistrictInfo(xzqdm,xzqmc);
    	}else{
    		$.messager.alert('错误','当前位置没有村委会！','info',function(){
			   					  
			});
    	}
    }
    function taxpayerLayerClick(evt){
       map.graphics.clear();
       map.infoWindow.hide();
       if(OPERLAYER == "3"){
    	   var currenObjectId = evt.graphic.attributes.TDGYID;
	   	   var currentObj = this;
	   	   var g = currentObj.focusLand(false,currenObjectId,null);
	   	   if(g){
	   		var zdbh = g.attributes.ZDBH;
	   		var actualArea = g.attributes.ACTUALAREA;
	   		actualArea = parseFloat(actualArea).toFixed(3);
	   		showMapEstate(evt,zdbh,actualArea);
	   	   }
       }else if(OPERLAYER == "2"){
    	   villageclickevent(evt);
       }else if(OPERLAYER == "1"){
    	   townclickevent(evt);
       }else if(OPERLAYER == "0"){
    	   xianclickevent(evt);
       }
    }
    function tdgyLayerClick(evt){
    	map.graphics.clear();
    	map.infoWindow.hide();
    	if(OPERLAYER == "3"){
    		var currenObjectId = evt.graphic.attributes.OBJECTID;
	    	var currentObj = this;
			currentObj.focusLand(false,evt,evt.graphic);
			var zdbh = evt.graphic.attributes.ZDBH;
			var actualArea = evt.graphic.attributes.ACTUALAREA;
			actualArea = parseFloat(actualArea).toFixed(3);
			showMapEstate(evt,zdbh,actualArea);
    	}else if(OPERLAYER == "2"){
    	   villageclickevent(evt);
       }else if(OPERLAYER == "1"){
    	   townclickevent(evt);
       }else if(OPERLAYER == "0"){
    	   xianclickevent(evt);
       }
    }
    
    function showMapEstate(evt,zdbh,actualArea){
    	var currentObj = arcgisMap;
    	if(evt.graphic.attributes.ISRELATION == "00"){
			currentObj.map.infoWindow.resize(250,100);
	        currentObj.map.infoWindow.setTitle('土地信息');
	        var content = "<table width='100%' cellpadding='3' cellspacing='0' border='1' bordercolor='#FCD209' style='border-collapse:collapse'>";
	        content += "<tr><td> <b>此块土地无权属人</b></td></tr>";	   
			content += '</table>';
	        currentObj.map.infoWindow.setContent(content);
	     	currentObj.map.infoWindow.show(evt.screenPoint,currentObj.map.getInfoWindowAnchor(evt.screenPoint));
	    }
    	else if(evt.graphic.attributes.ISRELATION == "01" && zdbh){
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
					       content += "<tr><th>查看土地信息</th><th>权属人</th><th>宗地编号</th><th>交付日期</th><th>土地面积</th><th>土地总价</th><th>实际面积(平方米)</th></tr>";
					       //content +="<tr><td colspan='6'><a href='xx()'>删除此地块</a></td></tr>";
					       for(var i = 0;i < jsondata.length;i++){
					    	   var land = jsondata[i];
					    	   content += "<tr><td><a href=\"javascript:showEstateInfo('"+land.estateid+"')\">土地详细信息</a></td><td>"+land.taxpayername+"</td><td>"+land.estateserialno+"</td>"+
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
		}
    }
    function showEstateInfo(estateid){
		$('#landinfowindow').window({
		   href : "viewland.jsp?d="+new Date(),
		   onLoad:function(){
		      afterLandLoaded(estateid);
		   }
	   });
	   //查看土地的基本信息
	   $('#landinfowindow').window('open');
	}
   </script>
<script>
  function formatterDate(value,row,index){
		return formatDatebox(value);
  }
  //1 乡镇  2 村委会  3 土地和税源
  var OPERLAYER = "3";
  var LOADSUCESS = false;
  $(function(){
	    var managerLink = new OrgLink();
	    managerLink.sendMethod = false;
	    managerLink.loadData();
	    
	    $('#queryform #taxrate').combobox({
	    	data:[{key:'',value:'--请选择土地等级--'},{key:'3',value:'一等'},
	    		 {key:'2',value:'二等'},{key:'1',value:'三等'}],
	    	valueField:'key',
	    	textField:'value'
	    });
	   CommonUtils.getCacheCodeFromTable('COD_LOCATIONTYPE','locationtypecode',
		                                 'locationtypename','#queryform #locationtype'," ",true);
	   CommonUtils.getCacheCodeFromTable('COD_LANDCERTIFICATETYPE','landcertificatetypecode',
		                                 'landcertificatetypename','#queryform #landcertificatetype'," ",true);
	   
	   $('#positionTree').tree({   
			 checkbox: true,   
			 onBeforeLoad:function(node,param){
		         
			 },
			 onLoadSuccess:function(node,data){
				 LOADSUCESS = false;
				 var rootNode = $('#positionTree').tree('getRoot');
				 if(rootNode){
					 $('#positionTree').tree('check',rootNode.target);
					 var townNodes = $('#positionTree').tree('getChildren',rootNode.target);
					 for(var i=0;i < townNodes.length;i++){
						 var townnode = townNodes[i];
						 if(townnode.attributes.levels == 4){
							 $('#positionTree').tree('collapse',townnode.target);
						 }
					 }
				 }
				 if(INITIAL){
					 initMap();
				 }else{
					 initialmap();
				 }
				 LOADSUCESS = true;
			 },
			onCheck:function(node,checked){
				 if(!INITIAL && LOADSUCESS){
					 initialmap();
				 }
			},
			onClick:function(node){
				if(node.checked){
				   if(node.attributes.levels == 4 ){
					    map.graphics.clear();
					    map.infoWindow.hide();
					    if(!$("#townlayerdisplay").attr("checked")){
					    	$("#townlayerdisplay").attr("checked", "checked");
					    	displaylayer();
					    }
					    var orgxzqdm = node.id;
					    var containsvillage = false;
				    	var townLayer = arcgisMap.getTownLayer();
				    	for(var i=0;i<townLayer.graphics.length;i++){
				    		   var g = townLayer.graphics[i];
				    		   var xzqdm = g.attributes.XZQDM;
				   			   if(orgxzqdm == xzqdm){
				   				    var geometry = g.geometry;
								    var centerPoint = geometry.getCentroid();
								    var highlightSymbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255,100,0]), 3), new dojo.Color([125,125,125,0.35]));
								    var highlightGraphic = new esri.Graphic(geometry,highlightSymbol);
								    map.graphics.add(highlightGraphic);
								    containsvillage = true;
								    map.centerAndZoom(centerPoint,1);
								    break;
				   			   }
				    	}
				    	if(!containsvillage){
				    		$.messager.alert('错误','当前地图上没有此乡镇！','info',function(){
							   					  
							});
				    	}
				   }else if(node.attributes.levels == 5){
					    map.graphics.clear();
					    map.infoWindow.hide();
					    if(!$("#villagelayerdisplay").attr("checked")){
					    	$("#villagelayerdisplay").attr("checked", "checked");
					    	displaylayer();
					    }
					    var orgxzqdm = node.id;
					    var containsvillage = false;
				    	var villageLayer = arcgisMap.getVillageLayer();
				    	for(var i=0;i<villageLayer.graphics.length;i++){
				    		   var g = villageLayer.graphics[i];
				    		   var xzqdm = g.attributes.XZQDM;
				   			   if(orgxzqdm == xzqdm){
				   				    var geometry = g.geometry;
				   				    var centerPoint = geometry.getCentroid();
								    var highlightSymbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255,100,0]), 3), new dojo.Color([125,125,125,0.35]));
								    var highlightGraphic = new esri.Graphic(geometry,highlightSymbol);
								    map.graphics.add(highlightGraphic);
								    containsvillage = true;
								    map.centerAndZoom(centerPoint,5);
								    break;
				   			   }
				    	}
				    	if(!containsvillage){
				    		$.messager.alert('错误','当前地图上没有此村委会！','info',function(){
							   					  
							});
				    	}
				   }
				}
			}
		});
		loadTree();
	   //获取div的位置，并重新设置
	   var left = $('#centerpanel').parent().css('left');
	   var top =  $('#centerpanel').parent().css('top');
	   var width =  $('#centerpanel').parent().css('width');
	   left = parseInt(left);
	   width = parseInt(width);
	   top = parseInt(top);
	   var oldwidth = $('#mapconditiondiv').parent().css('width');
	   var oldwidth = parseInt(oldwidth);
	   var newleft = (left+width-oldwidth)+'px';
	   var newtop = (top+12)+'px';
	   
	   $('#mapconditiondiv').parent().css('left',newleft);
	   $('#mapconditiondiv').parent().css('top',newtop);
	   $('#mapconditiondiv').parent().css('padding','0px');
	   
	   $('#mapconditiondiv').parent().css('border','none');
	   $('#mapconditiondiv').parent().css('border-radius','0px');
	   
	   //显示不显示卫星图的事件
	   //显示
	   $('#displaytile1').bind('click',function(evt){
		 if(map.infoWindow)
		   map.infoWindow.hide();
		 if(map.graphics)
                 map.graphics.clear(); 
		 var townlayer = arcgisMap.getTownLayer();
 		 townlayer.setOpacity(0.2);
 		 var villagelayer = arcgisMap.getVillageLayer();
 		 villagelayer.setOpacity(0.3);
		 arcgisMap.displayTiledMap(true);
	   });
	   //不显示
	   $('#displaytile2').bind('click',function(evt){
		 if(map.infoWindow)
		   map.infoWindow.hide();
		 if(map.graphics)
           map.graphics.clear(); 
		 var townlayer = arcgisMap.getTownLayer();
 		 townlayer.setOpacity(0.7);
 		 var villagelayer = arcgisMap.getVillageLayer();
 		 villagelayer.setOpacity(0.4);
		   arcgisMap.displayTiledMap(false);
	   });
	   //图层显示  data-layerdisplay='p'
	   $('#mapdisplayform input[data-layerdisplay="p"]').bind('click',function(){
		   map.infoWindow.hide();
           map.graphics.clear(); 
		   displaylayer();
	   });
	   $('#mapdisplayform input[data-layer="p"]').bind('click',function(){
		   map.infoWindow.hide();
           map.graphics.clear(); 
		   OPERLAYER = $(this).val()+'';
		   //1 乡镇  2 村委会  3 土地和税源
		    //townlayerdisplay,villagelayerdisplay,landlayerdisplay,taxpayerlayerdisplay
		   if(OPERLAYER == "1"){
			   $("#townlayerdisplay").attr("checked", "checked");
		   }else if(OPERLAYER == "2"){
			   $("#villagelayerdisplay").attr("checked", "checked");
		   }else if(OPERLAYER == "3"){
			   $("#landlayerdisplay").attr("checked", "checked");
			   $("#taxpayerlayerdisplay").attr("checked", "checked");
		   }else if(OPERLAYER == "0"){
			   $('#mapdisplayform input[data-layerdisplay="p"]').attr('checked','checked');
		   }
		   displaylayer();
	   });
	   $('#mapdisplayform input[data-land="p"]').bind('click',function(){
		   displaylandcondition();
	   });
  });
  /*
   * 加载树，然后树加载成功后调用
   * */
  function loadTree(){
	  var orgparams = getCondition();
	  var params = {};
	  params['taxorgsupcode'] = orgparams['taxorgsupcode'];
	  params['taxorgcode'] = orgparams['taxorgcode'];
	  if(orgparams['taxdeptcode']){
		  params['taxdeptcode'] = " ('"+orgparams['taxdeptcode']+"') ";
	  }else{
		  var data = $('#taxdeptcode').combobox('getData');
		  var taxdeptcode = '';
		  var ary = [];
		  if(data){
			  for(var i = 0;i < data.length;i++){
				  if(data[i].key)
				    ary.push("'"+data[i].key+"'");
			  }
		  }
		  if(ary.length > 0){
			  taxdeptcode = '('+ary.join(',')+')';
		  }
		  params['taxdeptcode'] = taxdeptcode;
	  }
	  params['taxmanagercode'] = orgparams['taxmanagercode'];
	  $.ajax({
		   type:"post",
		   async:false,
		   url: "/mapcommon/getalldistrictbyparentid.do",
		   data: params,
		   dataType: "text",
		   success: function(treedata){
			   var treeobj = $.parseJSON(treedata);
			   $('#positionTree').tree('loadData',treeobj);
			   $('#xzqmapquerydiv').window('close');
		   }
	 });
  }   
  function setTownVilliage(){
	  var checkNodes = $('#positionTree').tree('getChecked');
		 var townAry = [];
		 var villageAry = [];
		 for(var i = 0;i < checkNodes.length;i++){
			 var n = checkNodes[i];
			 if(n.attributes.levels == 4){
				 townAry.push("'"+n.id+"'");
			 }else if(n.attributes.levels == 5){
				 var parentNode = $('#positionTree').tree('getParent',n.target);
				 if(!townAry.contains("'"+parentNode.id+"'")){
					 townAry.push("'"+parentNode.id+"'");
				 }
				 villageAry.push("'"+n.id+"'");
			 }
		 }
		 var townCondition = townAry.join(",");
		 var villageCondition = villageAry.join(",");
		 ////
		 var townlayer = arcgisMap.getTownLayer();
		 if(townCondition)
		   townlayer.setDefinitionExpression("XZQDM in ("+townCondition+")");
		 else
		   townlayer.setDefinitionExpression("OBJECTID < 0 ");
		 ////
		 var villagelayer = arcgisMap.getVillageLayer();
		 if(villageCondition)
		   villagelayer.setDefinitionExpression("XZQDM in ("+villageCondition+")");
		 else
		   villagelayer.setDefinitionExpression("OBJECTID < 0 ");
		 return {'villageCondition':villageCondition};
  }
  function initialmap(){
       if(map.infoWindow)
		   map.infoWindow.hide();
		 if(map.graphics)
		   map.graphics.clear(); 
		 var obj = setTownVilliage();
		 var villageCondition = obj['villageCondition'];
		 //////////////
         OwnTaxPayerObjectIds = null;
	     OwnTdgyObjectIds = null;
		 if(villageCondition){
			 getTdgyQuery(function(params){
				var taxpayerLayer = arcgisMap.getTaxpayerLayer();
                var tdgyLayer = arcgisMap.getTdgyLayer();
			    OwnTaxPayerObjectIds = params.owntaxpayerobjectids;
	    	    OwnTdgyObjectIds = params.owntdgyobjectids;
	    	    var val = null;
				var elements = $('#mapdisplayform input[data-land="p"]');
			    for(var i = 0;i < elements.length;i++){
				  if(elements[i].checked){
					  val = elements[i].value;
					  break;
				  }
			    }
			     
			    //val 0 所有  1 欠税  2 不欠税  3 未关联
			    var tdgyDefine = "";
			    var taxpayerDefine = "";
			    if(params.tdgyobjectids){
			    	if(val == "0"){
				    	tdgyDefine = " OBJECTID in ("+params.tdgyobjectids+") or ISRELATION = '00' ";
				    	taxpayerDefine = " OBJECTID in ("+params.taxpayerobjectids+") or ISRELATION = '00' ";
				    }else if(val == "1"){
				    	if(params.owntdgyobjectids){
				    		tdgyDefine = " OBJECTID in ("+params.owntdgyobjectids+") ";
				    	}else{
				    		tdgyDefine = " OBJECTID < 0 ";
				    	}
				    	if(params.owntaxpayerobjectids){
				    		taxpayerDefine = " OBJECTID in ("+params.owntaxpayerobjectids+") ";
				    	}else{
				    		taxpayerDefine = " OBJECTID < 0 ";
				    	}
				    }else if(val =="2"){
				    	tdgyDefine = " OBJECTID in ("+params.tdgyobjectids+")  ";
				    	taxpayerDefine = " OBJECTID in ("+params.taxpayerobjectids+")  ";
				    	if(params.owntdgyobjectids){
				    		tdgyDefine += " and OBJECTID not in ("+params.owntdgyobjectids+") ";
				    	}
				    	if(params.owntaxpayerobjectids){
				    		taxpayerDefine += " and OBJECTID not in ("+params.owntaxpayerobjectids+") ";
				    	}
				    }else if(val == "3"){
				    	 if(villageCondition)
				    		 taxpayerDefine = "VILLAGE in ("+villageCondition+") and ISRELATION = '00' ";
						 else
						     taxpayerDefine = "OBJECTID < 0 ";
				    	if(villageCondition){
							 $.ajax({
							   type:"post",
							   async:false,
							   url: "/mapcommon/gettdgyidbydistrict.do",
							   data: {'villageconditions':villageCondition},
							   dataType: "json",
							   success: function(jsondata){
								   var tdgyobjectids = jsondata.join(",");
								   tdgyDefine= "OBJECTID in ("+tdgyobjectids+") and ISRELATION = '00' ";
							   }
							 });
						 }else{
							 tdgyDefine = " OBJECTID < 0 ";
						 }
				    }
			    }else{
			    	tdgyDefine = " OBJECTID < 0 ";
			    	taxpayerDefine = " OBJECTID < 0 ";
			    }
			    //console.log(tdgyDefine);
			    //console.log(taxpayerDefine);
			    tdgyLayer.setDefinitionExpression(tdgyDefine);
 		    	taxpayerLayer.setDefinitionExpression(taxpayerDefine);
		     });
		 }else{
			 var taxpayerLayer = arcgisMap.getTaxpayerLayer();
             var tdgylayer = arcgisMap.getTdgyLayer();
			 taxpayerLayer.setDefinitionExpression("OBJECTID < 0 ");
			 tdgylayer.setDefinitionExpression("OBJECTID < 0 ");
		 }
		 
  }
  //0 所有  1 欠税  2 不欠税  3 未关联
  function displaylandcondition(){
	  map.infoWindow.hide();
      map.graphics.clear(); 
	  initialmap();
  }
  function displaylayer(){
	  var layerelements = $('#mapdisplayform input[data-layerdisplay="p"]');
	   var ary = [];
	   for(var i = 0;i < layerelements.length;i++){
		   var ele = layerelements[i];
		   if(ele.checked)
		     ary.push(ele.value);
	   }
	  var layerstr = ary.join(",");
	  var layerary = [arcgisMap.getTownLayer(),arcgisMap.getVillageLayer(),arcgisMap.getTdgyLayer(),arcgisMap.getTaxpayerLayer()];
	  for(var i = 0;i < layerary.length;i++){
		  var layer = layerary[i];
		  map.removeLayer(layer);
	  }
	  for(var i = 0;i < layerary.length;i++){
		  var layer = layerary[i];
		  if(layerstr.indexOf(layer.layerId+'') >= 0){
		       map.addLayer(layer);
		  }
	  }
  }
  function getCondition(){
   	    var params = {};
	    var fields =$('#queryform').serializeArray();
	    $.each( fields, function(i, field){
		    params[field.name] = field.value;
	    });
	    
	    var checkNodes = $('#positionTree').tree('getChecked');
	    var villageAry = [];
		 for(var i = 0;i < checkNodes.length;i++){
			 var n = checkNodes[i];
			 if(n.attributes.levels == 5){
				 villageAry.push("'"+n.id+"'");
			 }
		 }
		 var villageCondition = villageAry.join(",");
		 params['villages'] = villageCondition;
	     return params;
  }  
  
  function queryXzqAndMapLand(){
	  $('#mapdisplayform input[data-layerdisplay="p"]').attr('checked','checked');
	  displaylayer();
	  loadTree();
  }   
  function openQuery(){
	  $('#xzqmapquerydiv').window('open');
  }
  
</script>
 </head>
  <body style="overflow: hidden;">
    <div class="easyui-layout" style="width:100%;height:610px;" id="layoutDiv">
		<div data-options="region:'north',border:false" style="width:99; height:30px; padding:1px;border:1px solid #ddd;overflow:hidden">	
		 <a class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="openQuery()">行政区地块查询</a>	
		 &nbsp;&nbsp;
		 <span style="color: red;font-weight: bold;"></span>
		</div>
		<div id="centerpanel" data-options="region:'center',split:true" style="width:99; height:575px; border:1px solid #000;">
		   <div id="map" style="width:99; height:570px; border:1px solid #000;" align="left">

		   </div> 
		</div>
		<div id="westDiv" data-options="region:'west',split:true,collapsible:true,minimizable:false" style="height:575px;width:200px;overflow:hidden;" title="拥有土地的行政区">
			 <div style="height: 565px;" >
					<ul id="positionTree" data-options="animate:true"></ul>
			 </div>
		</div>
    </div>
	 <div id="mapconditiondiv" class="easyui-window" data-options="closed:false,modal:false,title:'',collapsible:true,shadow:false,
	minimizable:false,maximizable:false,closable:true" style="width:320px;overflow:hidden;">
			<div style="width:320px;background:white;">
			   <form id="mapdisplayform" method="post">
				<table id="narjcxx" width="100%" cellpadding="1" cellspacing="0" border="1" bordercolor="#000000" style="border-collapse:collapse">
					<tr height="30px">
						<td align="right">
                                                                          卫星图：
                        </td>
                        <td>
							<input type="radio" id="displaytile1" name="displaytile" value="1"/> 显示	
							<input type="radio" id="displaytile2" name="displaytile" value="0" checked="checked"/> 不显示		
						</td>
					</tr>
					<tr height="30px">
						<td align="right">
                                                                          图层显示：
                        </td>   
                        <td>     
							<input type="checkbox" checked="checked" id="townlayerdisplay" name="townlayerdisplay" value="4" data-layerdisplay='p'/>乡镇
                            <input type="checkbox" checked="checked" id="villagelayerdisplay" name="villagelayerdisplay" value="3" data-layerdisplay='p'/>村委会
                            <input type="checkbox" checked="checked" id="landlayerdisplay" name="landlayerdisplay" value="1" data-layerdisplay='p'/>土地		
                            <input type="checkbox" checked="checked" id="taxpayerlayerdisplay" name="landlayerdisplay" value="0" data-layerdisplay='p'/>税源
						</td>
					</tr>
					<tr height="30px">
						<td align="right">
                                                                          当前图层：
                        </td>
                        <td>
                            <input type="radio" id="currentlayerxian" name="currentlayer" value="0" data-layer="p"/>县
							<input type="radio" id="currentlayertown" name="currentlayer" value="1" data-layer="p"/>乡镇
                            <input type="radio" id="currentlayervillage" name="currentlayer" value="2" data-layer="p"/>村委会
                            <input type="radio" id="currentlayerlandtaxpayer" name="currentlayer" value="3" checked="checked" data-layer="p"/>土地和税源		
						</td>
					</tr>
					<tr height="30px">
						<td align="right">
                                                                          土地情况：
                        </td>
                        <td>  
							<input type="radio" id="landowntax" name="landcondition" data-land="p" value="1"/>欠税
                            <input type="radio" id="landnoowntax" name="landcondition" data-land="p" value="2"/>不欠税
                            <input type="radio" id="landnorelation" name="landcondition" data-land="p" value="3"/>未关联		
                            <input type="radio" id="allrelation" name="landcondition" data-land="p" value="0" checked="checked"/>所有
						</td>
					</tr>
				</table>
			    </form>
	        </div>	
	</div>	
	<div id="landinfowindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地相关信息',collapsible:false,
	   minimizable:false,maximizable:false,closable:true,href:'viewland.jsp'" style="width:1050px;height:540px;">
	</div>	
	<div id="xzqinfowindow" class="easyui-window" data-options="closed:true,modal:true,title:'行政区相关信息',collapsible:false,
	   minimizable:false,maximizable:false,closable:true" style="width:750px;height:350px;">
	        <div id="ttxx" class="easyui-tabs" style="width:100;height:310px;">  
					    <div title="采集相关信息" data-options="closable:false" style="overflow:hidden;padding:5px;">  
					        <table id="xzqgathertable" width="100%" cellpadding="3" cellspacing="0" border="1" bordercolor="#FCD209" style="border-collapse:collapse">
								<tr>
									<td align="right">系统地块数：</td>
									<td>
										<input class="easyui-validatebox" name="gatherNum" id="gatherNum" data-v="p"/>					
									</td>
									<td align="right">地图地块书：</td>
									<td>
										<input class="easyui-validatebox" name="mapGatherNum" id="mapGatherNum" data-v="p"/>					
									</td>
								</tr>
								<tr style="display: none;">
									<td align="right">系统地块面积：</td>
									<td>
										<input class="easyui-validatebox" name="gatherArea" id="gatherArea" data-v="p"/>					
									</td>
									<td align="right">地图地块面积：</td>
									<td>
										<input class="easyui-validatebox" name="mapGatherArea" id="mapGatherArea" data-v="p"/>					
									</td>
								</tr>
								<tr>
									<td align="right">应缴金额：</td>
									<td>
										<input class="easyui-validatebox" name="shouldtaxmoney" id="shouldtaxmoney" data-v="p"/>					
									</td>
									<td align="right">已缴金额：</td>
									<td>
										<input class="easyui-validatebox" name="alreadyshouldtaxmoney" id="alreadyshouldtaxmoney" data-v="p"/>					
									</td>
								</tr>
								<tr>
									<td align="right">欠税金额：</td>
									<td>
										<input class="easyui-validatebox" name="owetaxmoney" id="owetaxmoney" data-v="p"/>					
									</td>
									<td align="right">减免金额：</td>
									<td>
										<input class="easyui-validatebox" name="avoidtaxamount" id="avoidtaxamount" data-v="p"/>					
									</td>
								</tr>
					      </table>
					    </div>
					     <div title="应纳税相关信息" data-options="closable:false" style="overflow:auto;padding:0px;">  
					        <table id='districttable' class="easyui-datagrid" style="width:99;height:275px;overflow: scroll;"
									data-options="iconCls:'icon-edit',singleSelect:true">
								<thead>
										<th data-options="field:'taxyear',width:80,align:'center',editor:{type:'validatebox'}">年份</th>
										<th data-options="field:'taxtypename',width:120,align:'center',editor:{type:'validatebox'}">税种</th>
										<th data-options="field:'shouldtaxmoney',width:120,align:'center',editor:{type:'validatebox'}">应缴金额</th>
										<th data-options="field:'alreadyshouldtaxmoney',width:120,align:'center',editor:{type:'validatebox'}">已缴金额</th>
										<th data-options="field:'owetaxmoney',width:120,align:'center',editor:{type:'validatebox'}">欠税金额</th>
										<th data-options="field:'avoidtaxamount',width:120,align:'center',editor:{type:'validatebox'}">减免金额</th>
								</thead>
							</table>   
					    </div>
			</div> 
	 </div>	 
	 <div id="xzqmapquerydiv" class="easyui-window" data-options="closed:true,modal:true,title:'查询条件',collapsible:false,
	   minimizable:false,maximizable:false,closable:true" style="width:640px;">
			<form id="queryform" method="post">
				<table id="narjcxx" width="100%" cellpadding="3" cellspacing="0" border="1" bordercolor="#FCD209" style="border-collapse:collapse">
				  
					<tr>
						<td align="right">州市地税机关：</td>
						<td>
							<input class="easyui-combobox" name="taxorgsupcode" id="taxorgsupcode" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">县区地税机关：</td>
						<td>
							<input class="easyui-combobox" name="taxorgcode" id="taxorgcode" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						
					</tr>
					
					<tr>
						<td align="right">主管地税部门：</td>
						<td>
							<input class="easyui-combobox" name="taxdeptcode" id="taxdeptcode" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">税收管理员：</td>
						<td>
							<input class="easyui-combobox" name="taxmanagercode" id="taxmanagercode" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
					</tr>
					<tr>
						<td align="right">计算机编码：</td>
						<td><input id="taxpayerid" class="easyui-validatebox" type="text" name="taxpayerid"/></td>
						<td align="right">纳税人名称：</td>
						<td>
							<input id="taxpayername" class="easyui-validatebox" type="text" name="taxpayername"/>
						</td>

					</tr>					
					<tr>
						<td align="right">坐落地类型：</td>
						<td>
							<input class="easyui-combobox" name="locationtype" id="locationtype"/>					
						</td>
						<td align="right">土地证类型：</td>
						<td>
							<input class="easyui-combobox" name="landcertificatetype" id="landcertificatetype"/>					
						</td>
					</tr>
					<tr>
						<td align="right">土地证号：</td>
						<td>
							<input class="easyui-validatebox" name="landcertificate" id="landcertificate"/>					
						</td>
						<td align="right">宗地编号：</td>
						<td>
							<input class="easyui-validatebox" name="estateserialno" id="estateserialno"/>					
						</td>
					</tr>
					<tr>
						<td align="right">土地用途：</td>
						<td>
							<input class="easyui-validatebox" name="purpose" id="purpose"/>					
						</td>
						<td align="right">土地等级：</td>
						<td>
							<input class="easyui-combobox" name="taxrate" id="taxrate"/>					
						</td>
					</tr>
				</table>
			</form>
			<div style="text-align:center;padding:5px;height: 25px;">  
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="queryXzqAndMapLand()">查询</a>
			</div>
	</div>	
  </body>
</html>


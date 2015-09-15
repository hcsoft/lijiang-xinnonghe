<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/common/inc.jsp"%>
<!DOCTYPE html>
  <head>
    <title>GIS数据关联</title>
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
    //esri.config.defaults.io.proxyUrl = "http://localhost:7001/proxy.jsp"; 
    var GloabTdgyObjectId = null;
    var arcgisMap = null;
    var map = null;
    function initMap(){
    	arcgisMap = new ArcgisMap(
    	   {
    		  mapdiv:'map',
    		  coordinatedisplaydiv:'coordinatedes',
    		  loadingdiv:'loadingImg',
    		  taxpayerclick:taxpayerLayerClick,
    		  tdgyclick:tdgyLayerClick,
    		  load:initToolbar,
    		  layerloaded:function(){
    		    var tdgyLayer = arcgisMap.getTdgyLayer();
                tdgyLayer.setSelectionSymbol(null);
    		      tdgyLayer.setDefinitionExpression(" OBJECTID > 0 ");
				  tdgyLayer.refresh();
				  dojo.connect(tdgyLayer,"onUpdateStart",function(){
    				   //alert('刷新土地供应层');
    				   if(GloabTdgyObjectId){
    					  var q = new esri.tasks.Query();
    					  q.where = " OBJECTID = "+GloabTdgyObjectId;
    					  // q.geometry = tdgyLayer.geometry;
    					  //var symbol = new esri.symbol.SimpleFillSymbol();
                          //symbol.setColor(new dojo.Color([255,0,0,0.5]));
                           tdgyLayer.selectFeatures(q,esri.layers.FeatureLayer.SELECTION_NEW,function(features){
                        	   if(features && features.length > 0){
                        		   var g = features[0];
                        	       var geometry = g.geometry;
							       map.graphics.clear();
							       var highlightSymbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255,100,0]), 3), new dojo.Color([125,125,125,0]));
							       var highlightGraphic = new esri.Graphic(geometry,highlightSymbol);
							       map.graphics.add(highlightGraphic);
                        	   }
                           });
                           
    					   //alert(GloabTdgyObjectId);
    					   //arcgisMap.focusLand(true,GloabTdgyObjectId,null);
    				      // GloabTdgyObjectId = null;
    				   }
			      });
    		  }
    	   }	
    	);
        map = arcgisMap.map;
    }
    dojo.ready(initMap);
    
    var tb = null;
    function initToolbar() {
		tb = new esri.toolbars.Draw(map);
		dojo.connect(tb, "onDrawEnd", addGraphic);
		
		dojo.connect(dojo.byId("drawLandBtn"),"click", function(){
			var row = $('#landInfoTable').datagrid('getSelected');
			  if(row == null){
				 $.messager.alert('提示消息','请选择需要添加坐标的地块!','info');
				 return;
			}
			ArcgisMap.DRAW = true;
			map.infoWindow.hide();
			map.graphics.clear();
			tb.activate(esri.toolbars.Draw.POLYGON);
		});
	}
    var geometryService = new esri.tasks.GeometryService(ArcgisMap.MapServerPath+"/Geometry/GeometryServer");
    function addGraphic(geometry) {
			tb.deactivate(); 
			map.graphics.clear();
			if(geometry.type == "polygon"){  //画的多边形
			    map.graphics.add(new esri.Graphic(geometry,ArcgisMap.getHighlightSymbol()));
			    //计算面积
			    ArcgisMap.calculateAreaAndLength(geometry,function(areas,lengths){
		    	   var area = areas[0];
		    	   $.messager.confirm('关联地块', '您确定画上此地块，并关联到选中的地块上吗?', function(r){
					if(r){
						    
							var row = $('#landInfoTable').datagrid('getSelected');
							var estateid = row.estateid;
							var point = geometry.getCentroid();
							if(!point){
								return;
							}
							var rings = geometry.rings[0];
							var xstr = '';
							var ystr = '';
							for(var i =0;i < rings.length;i++){
								var ary = rings[i];
								xstr += ary[0]+",";
								ystr += ary[1]+",";
							}
						    if(xstr)
							  xstr = xstr.substring(0,xstr.length-1);
						    if(ystr)
							  ystr = ystr.substring(0,ystr.length-1);
						    var xcenter = point.x;
						    var ycenter = point.y;
						    if(point){
						    	arcgisMap.getLayerAttrs(point,ArcgisMap.villagelayerid,function(atrs){
						    		var xzqdm = atrs.行政区代码;
									if(xzqdm == null || xzqdm == ""){
										$.messager.alert('提示消息','根据中心坐标点获取行政区代码失败!','info');
									}else{
										var params = {};
										params['estateid'] = estateid;
										params['xzqdm'] = xzqdm;
					                    params['polygonx'] = xstr;
					                    params['polygony'] = ystr;
					                    params['centerx'] = xcenter;
					                    params['centery'] = ycenter;
					                    params['area'] = area;
					                    $.messager.progress();
										$.ajax({
											   type: "post",
											   url: "/gisgather/bycoordinate.do",
											   data: params,
											   dataType: "json",
											   success: function(jsondata){
												   ArcgisMap.DRAW = false;
												   $.messager.progress('close');
												   if(jsondata.sucess){
														$.messager.alert('提示','通过坐标添加地块成功!','info',function(){
															arcgisMap.getTaxpayerLayer().refresh();
															arcgisMap.getTdgyLayer().refresh();
															map.graphics.clear();
															query();
														});
												   }else{
													   $.messager.alert('提示','通过坐标添加地块失败!');
												   }
											   }
									   });
									}
						    	});
								map.graphics.clear();
						  }
				   }
				  });
		       });
			}
 }
   //this = arcgisMap
 function taxpayerLayerClick(evt){
	glbClickEvent = evt;
   	map.graphics.clear();
	var graphicAttributes = evt.graphic.attributes;
	title = null;
	var isrelation = graphicAttributes.ISRELATION;
	clickObjectid = graphicAttributes.OBJECTID;
	var content = '';
	if(isrelation == "00"){
		//content = "<b><a href='javascript:deleteTaxPayer("+clickObjectid+")'>删除此税源点</a></b><br/>";
		content += "<b><a href='javascript:showEstateInfo(0,"+clickObjectid+")'>税源关联</a></b>";
		title = "税源关联";
	}else if(isrelation == "01"){
		//content = "<b><a href='javascript:deleteTaxPayer("+clickObjectid+")'>删除此税源点</a></b><br/>";
		content +="<b><a style='pading:1px;' href='javascript:showEstateInfo(1,"+clickObjectid+")'>查看此地块关联的税源信息</a></b>"+
		        "<br/><b><a style='pading:1px;' href='javascript:deleteRelationEstate("+clickObjectid+")'>删除此地块关联的税源信息</a></b>"+
		        "<br/><b><a style='pading:1px;' href='javascript:showEstateInfo(2,"+clickObjectid+")'>二次关联</a></b>";
		title = "税源关联信息";
	}
	map.infoWindow.resize(250,100);
	map.infoWindow.setTitle(title);
	map.infoWindow.setContent(content);
	map.infoWindow.show(evt.screenPoint,map.getInfoWindowAnchor(evt.screenPoint));
 }
   var glbClickEvent = null;
   function tdgyLayerClick(evt){
	   glbClickEvent = evt;
	   var g = glbClickEvent.graphic;
	   $('#coordinateTable').datagrid('loadData',[]);
		for(var i = 0;i < g.geometry.rings[0].length-1;i++){
			var pointAry = g.geometry.rings[0][i];
			$('#coordinateTable').datagrid('appendRow',{'x':pointAry[0],'y':pointAry[1]});
		}
									
	   map.graphics.clear();
	   arcgisMap.focusLand(false,evt,evt.graphic);
	   var graphicAttributes = evt.graphic.attributes;
	   var zdbh = graphicAttributes.ZDBH;
	   var objectId = graphicAttributes.OBJECTID;
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
					   var content = "<div style='padding:5px;'><a href='javascript:deleteTdgyPolygon("+objectId+")'><b>删除此地块<b></a></div>";
				       content += "<table width='100%' cellpadding='3' cellspacing='0' border='1' bordercolor='#FCD209' style='border-collapse:collapse'>";
				       content += "<tr><th>权属人</th><th>宗地编号</th><th>交付日期</th><th>土地面积</th><th>土地总价</th></tr>";
				       for(var i = 0;i < jsondata.length;i++){
				    	   var land = jsondata[i];
				    	   content += "<tr><td>"+land.taxpayername+"</td><td>"+land.estateserialno+"</td>"+
				    	              "<td>"+ArcgisMap.formatterDate(land.holddate)+"</td>"+
				    	              "<td>"+land.landarea+"</td><td>"+land.landmoney+"</td></tr>";
				       }	   
				       content += '</table>'
				       map.infoWindow.resize(500,300);
				       map.infoWindow.setTitle(title);
					   map.infoWindow.setContent(content);
					   map.infoWindow.show(evt.screenPoint,map.getInfoWindowAnchor(evt.screenPoint));
				   }
			   }
	       });
		}else{
			map.infoWindow.resize(250,100);
	        map.infoWindow.setTitle('土地信息');
	        var content = "<table width='100%' cellpadding='3' cellspacing='0' border='1' bordercolor='#FCD209' style='border-collapse:collapse'>";
	        content += "<tr><td> <b><a href='javascript:deleteTdgyPolygon("+objectId+")'>删除此地块</a></b></td></tr>";	  
	        content += "<tr><td> <b>此块土地无权属人</b></td></tr>";	   
			content += '</table>';
	        map.infoWindow.setContent(content);
	     	map.infoWindow.show(evt.screenPoint,map.getInfoWindowAnchor(evt.screenPoint));
		}
   }
   function deleteTaxPayer(objectid){
	   $.messager.confirm('确认', '你确认删除当前税源信息及相关的土地信息吗？', function(r){
		       if (r){
					deleteEstate();
			   }
	   });
   }
   //删除地块信息
   //function(geometry,layerid,callback)
   function deleteTdgyPolygon(objectid){
	   $.messager.confirm('确认', '你确认删除当前地块信息及关联的税源信息吗？', function(r){
				if (r){
					deleteEstate(objectid,'1');
				}
	   });
   }
   function deleteEstate(objectid,deltype){
	   var params = {};
	   params['objectid'] = objectid;
	   params['deltype'] = deltype;
	   $.messager.progress();
	        $.ajax({
					   type: "post",
					   url: "/gisgather/deletelayerByObjectId.do",
					   data: params,
					   dataType: "json",
					   success: function(jsondata){
						   $.messager.progress('close');
						   if(jsondata.sucess){
								$.messager.alert('提示','删除当前地块、税源信息成功!','info',function(){
									GloabTdgyObjectId = null;
								    map.infoWindow.hide();
								    map.graphics.clear();
								    arcgisMap.getTdgyLayer().refresh();
									arcgisMap.getTaxpayerLayer().refresh();
									
									query();
								});
						   }else{
							   $.messager.alert('提示','删除当前地块、税源信息失败!');
						   }
					   }
			   });
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
	   var opts = $('#landInfoRelationTable').datagrid('options');
	   opts.url = '/landavoidtaxmanager/selectland.do?d='+new Date();
	   $('#landInfoRelationTable').datagrid('load',params); 
	   var p = $('#landInfoRelationTable').datagrid('getPager');  
	   $(p).pagination({  
				showPageList:false
	   });
    }
    function relationEstate(){
    	var row = $('#landInfoRelationTable').datagrid('getSelected');
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
		    	var featureLayer = arcgisMap.getTaxpayerLayer();
		        for(var i=0;i<featureLayer.graphics.length;i++){
        		   var graphics = featureLayer.graphics[i];
       			   var taxsourceId = graphics.attributes.OBJECTID;
        		   if(taxsourceobjectid == taxsourceId){
        			    var params = {};
        			    arcgisMap.getLayerAttrs(graphics.geometry,ArcgisMap.tdgylayerid,function(attrs){
        			        var tdgyobjectid = attrs.OBJECTID;
							params['tdgyobjectid'] = tdgyobjectid;
							arcgisMap.getLayerAttrs(graphics.geometry,ArcgisMap.villagelayerid,function(attrss){
								var xzqdm = attrss.行政区代码;
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
													arcgisMap.getTaxpayerLayer().refresh();
													arcgisMap.getTdgyLayer().refresh();
													map.graphics.clear();
													query();
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
		    	var featureLayer = arcgisMap.getTaxpayerLayer();
		    	for(var i=0;i<featureLayer.graphics.length;i++){
        		   var graphics = featureLayer.graphics[i];
       			   var taxsourceId = graphics.attributes.OBJECTID;
        		   if(taxsourceobjectid == taxsourceId){
        			    var params = {};
        			    arcgisMap.getLayerAttrs(graphics.geometry,ArcgisMap.tdgylayerid,function(attrs){
        			    	var tdgyobjectid = attrs.OBJECTID;
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
													arcgisMap.getTaxpayerLayer().refresh();
													arcgisMap.getTdgyLayer().refresh();
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
    </script>
    
    <script type="text/javascript">
	$(function(){   
		
				
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
        	   arcgisMap.focusLand(true,selectObjectId);
			}
		});
        var p = $('#tdgytable').datagrid('getPager');  
			$(p).pagination({  
				showPageList:false
		});
		//地块相关功能结束.......................................
		$('#landInfoRelationTable').datagrid({
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
						$('#landInfoRelationTable').datagrid('unselectRow', index);
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
  <body style="overflow: hidden;">
    <div class="easyui-layout" style="width:100%;height:650px;" id="layoutDiv">
		<div data-options="region:'north',border:false" style="width:99; height:25px; padding:1px;border:1px solid #ddd;overflow:hidden">	
		    <a class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="openQuery()">查询土地</a>	      
		</div>
		<div id="centerpanel" data-options="region:'center'" style="position:relative; width:99; height:570px; border:1px solid #000;">
		    <div id="tabdiv" class="easyui-tabs" style="width:99;height:567px;">
			    <div title="GIS数据">
			        <div>
			        <a id="landInfoId" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-search'">地块信息</a>
			        <a id="drawLandBtn" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-save'">画地块</a>
			        <a href="javascript:arcgisMap.navToolbar.zoomToFullExtent();" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-globeLarge'">全图范围</a>
			        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font style="color: red;font-weight: bold;">关联绿色，未关联蓝色</font>
			        </div>
			        <div id="map" style="width:99; height:480px; border:1px solid #000;">
			            <div id="LocateButton"></div>
		            </div> 
		            <div style="background-color: white;height:20px;vertical-align: middle;padding-top: 5px;" id="coordinatedes">
		                             坐标信息
		            </div>
			    </div>
			    <div title="地块坐标">  
			        <table id='coordinateTable' class="easyui-datagrid" style="height:400px;width:99;overflow: hidden;"
					      data-options="singleSelect:true,rownumbers:true,toolbar:'#coordinatetoolbar'">
						<thead>
							<tr>
								<th data-options="field:'x',width:200,align:'center',editor:{type:'validatebox'}">X坐标</th>
								<th data-options="field:'y',width:200,align:'center',editor:{type:'validatebox'}">Y坐标</th>
							</tr>
					   </thead>
			       </table>
			       <div id="coordinatetoolbar" style="width:99; height:25px; padding:1px;border:1px solid #ddd;overflow:hidden">	
					    <a class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="openAddCoordinate()">添加坐标</a>	   
					    <a class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" onclick="editCoordinate()">编辑坐标</a>	
					    <a class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="deleteCoordinate()">删除坐标</a>	  
					    <a class="easyui-linkbutton" data-options="iconCls:'icon-ok',plain:true" onclick="addCoordinateComplete()">完成坐标</a>
					    <font color="red">所有坐标操作需点击完成坐标操作才生效</font>
				  </div>
			    </div>
		  </div>  
		</div>
		<div data-options="region:'west'" style="height:625px;width:400px;overflow: hidden;">
			<table id='landInfoTable' class="easyui-datagrid" style="height:570px;width:400px;overflow: hidden;"
					      data-options="iconCls:'icon-edit',singleSelect:true,pageList:[15],
					      rowStyler:function(index,row){
					          if($.trim(row.layerid)){
					            return 'background-color:#CCFFFF;';
					          }
					      }
					      ">
						<thead>
							<tr>
							    <th data-options="field:'estateid',hidden:true,width:50,align:'center',editor:{type:'validatebox'}">主键</th>
								<th data-options="field:'estateserialno',width:120,align:'center',editor:{type:'validatebox'}">宗地编号</th>
								<th data-options="field:'landcertificate',width:120,align:'center',editor:{type:'validatebox'}">土地证号</th>
								<th data-options="field:'taxpayerid',width:100,align:'center',editor:{type:'validatebox'}">计算机编码</th>
								<th data-options="field:'taxpayername',width:175,align:'left',editor:{type:'validatebox'}">纳税人名称</th>
								<th data-options="field:'locationtypename',width:175,align:'center',editor:{type:'validatebox'}">坐落地类型</th>
								<th data-options="field:'belongtownname',width:175,align:'center',editor:{type:'validatebox'}">所属村委会</th>
								<th data-options="field:'holddate',width:175,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">交付日期</th>
								<th data-options="field:'landarea',width:175,align:'center',editor:{type:'validatebox'}">土地面积</th>
								<th data-options="field:'landmoney',width:175,align:'center',editor:{type:'validatebox'}">土地总价</th>
							</tr>
						</thead>
			</table>
		</div>
    </div>
    <div id="coordinatediv" class="easyui-window" data-options="closed:true,modal:true,title:'坐标添加',collapsible:false,
	minimizable:false,maximizable:false,closable:true" style="width:340px;">
			<form id="coordinateform" method="post">
				<table id="narjcxx" width="100%" cellpadding="8" cellspacing="0" border="1" bordercolor="#FCD209" style="border-collapse:collapse">
				  
					<tr>
						<td align="right">X坐标：</td>
						<td>
							<input class="easyui-numberbox" name="xcoordinate" id="xcoordinate" data-options="precision:3"/>					
						</td>
					</tr>
					<tr>
						<td align="right">Y坐标：</td>
						<td>
							<input class="easyui-numberbox" name="ycoordinate" id="ycoordinate" data-options="precision:3"/>					
						</td>
					</tr>
				</table>
			</form>
			<div style="text-align:center;padding:5px;">  
				<a class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:false" onclick="saveCoordinate()">保存</a>
			</div>
	</div>
   <div id="landquerydiv" class="easyui-window" data-options="closed:true,modal:true,title:'土地查询条件',collapsible:false,
	minimizable:false,maximizable:false,closable:true" style="width:640px;height:230px;">
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
					
					<tr style="display: none;">
						<td align="right">主管地税部门：</td>
						<td>
							<input class="easyui-combobox" name="taxdeptcode" id="taxdeptcode" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">专管员：</td>
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
						<td align="right">房产所属乡镇：</td>
						<td>
							<input class="easyui-combobox"  id="countrytown"  name="countrytown" data-validate="p"/>			
						</td>
						<td align="right">所属村委会：</td>
						<td>
							<input class="easyui-combobox"  id="belongtowns"  name="belongtowns" data-options="disabled:false,panelWidth:200,panelHeight:200" data-validate="p"/>	
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
						<td align="right">交付日期：</td>
						<td colspan="3">
							<input id="beginholddate" class="easyui-datebox" name="beginholddate" style="width: 150px;"/>
						至
							<input id="endholddate" class="easyui-datebox"  name="endholddate" style="width:150px;"/>
							地块关联情况：
							<input class="easyui-combobox" name="isrelation" id="isrelation" style="width: 100px;"/>
						</td>
					</tr>
				</table>
			</form>
			<div style="text-align:center;padding:5px;height: 25px;">  
					<a class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="query()">查询</a>
			</div>
	</div>	
	<img id="loadingImg" src="/images/loading.gif" style="position:absolute; right:400px; top:70px; z-index:100;" />
		
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
			<table id="landInfoRelationTable" class="easyui-datagrid" style="width:510px;height:330px;padding:5px;overflow:scroll;"
					data-options="iconCls:'icon-edit',pagination:true,pageList:[10],singleSelect:true,
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
<<script>
  function formatterDate(value,row,index){
		return formatDatebox(value);
  }
  $(function(){
	  var managerLink = new OrgLink();
	    managerLink.sendMethod = true;
	    managerLink.loadData();
	    
	    $('#queryform #countrytown').combobox({
			   onSelect:function(data){
			      CommonUtils.getCacheCodeFromTable('COD_DISTRICT','id',
			                                 'name','#queryform #belongtowns'," and parentid = '"+data.key+"' ",true);
			   }
	    });
		CommonUtils.getCacheCodeFromTable('COD_DISTRICT','id',
			                                 'name','#queryform #countrytown'," and parentid = '530122' ",true);
		
		CommonUtils.getLocationType("locationtype");
		CommonUtils.getLandCertificateType('landcertificatetype');
		
		$('#isrelation').combobox({
						       data : [{key:'',keyvalue:'所有'},{key:'0',keyvalue:'未关联'},{key:'1',keyvalue:'已关联'}],
                               valueField:'key',
                               textField:'keyvalue'
		});
		
	       
		$('#landInfoTable').datagrid({
			fitColumns:false,
			maximized:'true',
			pagination:true,
			pageList:[15],
			onClickRow:function(rowindex,rowData){  //进行地图缩放
        	   //featureLayer3 土地供应层
        	   $.ajax({
						   type: "post",
						   url: "/gisgather/gettdgylayerobjectid.do",
						   data: {'estateid':rowData.estateid},
						   dataType: "json",
						   success: function(jsondata){
							   if(jsondata.result){
									var selectObjectId = jsondata.result;
									var g = arcgisMap.focusLand(true,selectObjectId);
									//alert(g.geometry.rings.length+"="+g.geometry.rings[0].length);
									$('#coordinateTable').datagrid('loadData',[]);
									for(var i = 0;i < g.geometry.rings[0].length-1;i++){
										var pointAry = g.geometry.rings[0][i];
										$('#coordinateTable').datagrid('appendRow',{'x':pointAry[0],'y':pointAry[1]});
									}
							   }else{
								   $('#coordinateTable').datagrid('loadData',[]);
								   //$.messager.alert('提示消息','当前地块关联错误，没有找到相应的土地!','info');
							   }
						   }
				});
			}
		});
      var p = $('#landInfoTable').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
	  });
	   query();
  });
  function openQuery(){
		 $('#landquerydiv').window('open');
  }
  function getCondition(){
   	    var params = {};
	    var fields =$('#queryform').serializeArray();
	    $.each( fields, function(i, field){
		    params[field.name] = field.value;
	    });
	    return params;
   }
  function query(){
	var params = getCondition();
	var opts = $('#landInfoTable').datagrid('options');
	opts.url = '/landavoidtaxmanager/selectland.do?d='+new Date();
	$('#landInfoTable').datagrid('load',params); 
	var p = $('#landInfoTable').datagrid('getPager');  
	$(p).pagination({   
		showPageList:false
	});
	$('#landquerydiv').window('close');		
  }
  var coordinatemode = 0; //0 修改  1 新增
  function openAddCoordinate(){
	  var row = $('#landInfoTable').datagrid('getSelected');
	  if(row == null){
		 $.messager.alert('提示消息','请选择需要添加坐标的地块!','info');
		 return;
	  }
	  $('#coordinateform #xcoordinate').val('');
	  $('#coordinateform #ycoordinate').val('');
	  $('#coordinatediv').window({
		  'title':'坐标添加'
	  });
	  $('#coordinatediv').window('open');
	  coordinatemode = 1;
  }
  function saveCoordinate(){
	   var xvalue = $('#coordinateform #xcoordinate').val();
	   var yvalue = $('#coordinateform #ycoordinate').val();
	   if(xvalue == null || xvalue == ''){
		   $.messager.alert('提示消息','X坐标不能为空!','info');
		  // $('#coordinateform #xcoordinate').focus();
		   return;
	   }
	   if(yvalue == null || yvalue == ''){
		   $.messager.alert('提示消息','Y坐标不能为空!','info');
		  // $('#coordinateform #ycoordinate').focus();
		   return;
	   }
	   if(coordinatemode == 1){
		   $('#coordinateTable').datagrid('appendRow',{'x':xvalue,'y':yvalue});
	   }else if(coordinatemode == 0){
		   var row = $('#coordinateTable').datagrid('getSelected');
		   var rowIndex = $('#coordinateTable').datagrid('getRowIndex',row);
		   $('#coordinateTable').datagrid('updateRow',{index:rowIndex,row:{'x':xvalue,'y':yvalue}});
	   }
	   
  }
  function deleteCoordinate(){
	  var row = $('#coordinateTable').datagrid('getSelected');
	  if(row == null){
		 $.messager.alert('提示消息','请选择删除的坐标!','info');
		 return;
	  }
	  var rowIndex = $('#coordinateTable').datagrid('getRowIndex',row);
	  $('#coordinateTable').datagrid('deleteRow',rowIndex);
  }
  function editCoordinate(){
	  $('#coordinateform #xcoordinate').val('');
	  $('#coordinateform #ycoordinate').val('');
	  var row = $('#coordinateTable').datagrid('getSelected');
	  if(row == null){
		 $.messager.alert('提示消息','请选择编辑的坐标!','info');
		 return;
	  }
	  $('#coordinateform #xcoordinate').val(row.x);
	  $('#coordinateform #ycoordinate').val(row.y);
      $('#coordinatediv').window({
		  'title':'坐标编辑'
	  });
	  $('#coordinatediv').window('open');
	  coordinatemode = 0;
  }
  function getPolygon(){
	     var polygonJson  = {"rings":[[]],"spatialReference":{"wkid":2358}};
	     var rows = $('#coordinateTable').datagrid('getRows');
         if(rows.length < 3){
        	 $.messager.alert('提示消息','坐标点至少需要3个!','info');
		     return null;
         }
         for(var i = 0;i < rows.length;i++){
        	 var ary = [];
        	 var row = rows[i];
        	 ary.push(parseFloat(row.x),parseFloat(row.y));
        	 polygonJson.rings[0].push(ary);
         }
         var firstRow = rows[0];
         var lastRow = rows[rows.length-1];
         //添加最后一个点
         if(!(firstRow.x == lastRow.x && firstRow.y == lastRow.y)){
        	 var ary = [];
        	 ary.push(parseFloat(firstRow.x),parseFloat(firstRow.y));
        	 polygonJson.rings[0].push(ary);
         }
		 var polygon = new esri.geometry.Polygon(polygonJson);
		 return polygon;
  }
  //添加坐标完成
  function addCoordinateComplete(){
	  var row = $('#landInfoTable').datagrid('getSelected');
	  if(row == null){
		 $.messager.alert('提示消息','请选择需要添加坐标的地块!','info');
		 return;
	  }
	  var estateid = row.estateid;
	  var polygon = getPolygon();
	  var point = polygon.getCentroid();
	  if(point.x < 0)
         point.setX(point.x*-1);
	  if(point.y < 0)
         point.setY(point.y*-1);
	  
	  var rows = $('#coordinateTable').datagrid('getRows');
	  var xstr = '';
	  var ystr = '';
	  for(var i = 0;i < rows.length;i++){
		  xstr += rows[i].x+",";
		  ystr += rows[i].y+",";
	  }
	  if(xstr)
		  xstr = xstr.substring(0,xstr.length-1);
	  if(ystr)
		  ystr = ystr.substring(0,ystr.length-1);
	  var xcenter = point.x;
	  var ycenter = point.y;
	  ArcgisMap.calculateAreaAndLength(polygon,function(areas,lengths){
		   var area = areas[0];
		   if(point){
		    arcgisMap.getLayerAttrs(point,ArcgisMap.villagelayerid,function(attrs){
		    	var xzqdm = attrs.行政区代码;
		    	if(xzqdm == null || xzqdm == ""){
					$.messager.alert('提示消息','根据中心坐标点获取行政区代码失败!','info');
				}else{
					var params = {};
					params['estateid'] = estateid;
					params['xzqdm'] = xzqdm;
                    params['polygonx'] = xstr;
                    params['polygony'] = ystr;
                    params['centerx'] = xcenter;
                    params['centery'] = ycenter;
                    params['area'] = area;
                    $.messager.progress();
					$.ajax({
						   type: "post",
						   url: "/gisgather/bycoordinate.do",
						   data: params,
						   dataType: "json",
						   success: function(jsondata){
							   $.messager.progress('close');
							   if(jsondata.sucess){
									$.messager.alert('提示','通过坐标添加地块成功!','info',function(){
										GloabTdgyObjectId = jsondata.result.tdgyObjectid;
										arcgisMap.getTaxpayerLayer().refresh();
										arcgisMap.getTdgyLayer().refresh();
										//map.graphics.clear();
										query();
										//select
										
										$('#tabdiv').tabs('select',0);
										//arcgisMap.focusLand(true,jsondata.result.tdgyObjectid,null);
									});
							   }else{
								   $.messager.alert('提示','通过坐标添加地块失败!');
							   }
						   }
				   });
				}
		    });
	      }
	  });
	  
  }
  
</script>

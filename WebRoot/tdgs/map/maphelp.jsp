<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/common/inc.jsp"%>
<!DOCTYPE html>
  <head>
    <title>地图辅助功能</title>
    <link rel="stylesheet" type="text/css" href="/arcgis_js_api/library/3.4/3.4/js/dojo/dijit/themes/claro/claro.css"/>
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
    <script src="/arcgis_js_api/library/3.7/3.7/init.js"></script>
    <script src="/js/mapcommon.js"></script>
    <style type="text/css">
        .dialogopen{
           background-color: red;
        }
    </style>
    <script>
         var arcgisMap = null;
         var map = null;
         function initMap(){
            arcgisMap = new ArcgisMap(
			    	   {
			    		  mapdiv:'map',
			    		  visiblelayer:[ArcgisMap.taxpayerlayerid,ArcgisMap.tdgylayerid,ArcgisMap.forestlayerid,ArcgisMap.villagelayerid,ArcgisMap.townlayerid],
			    		  load:initToolbar,
			    		  layerloaded:function(){
			    		      $('#tooldiv').show();
			    		  }
			    	   }	
			    	);
			        map = arcgisMap.map;
	    }
        var tb = null;
	    function initToolbar() {
			tb = new esri.toolbars.Draw(map);
			/*
			dojo.connect(tb, "onDrawEnd", addGraphic);
			dojo.connect(dojo.byId("mesureArea"),"click", function(){
				ArcgisMap.DRAW = true;
				map.infoWindow.hide();
				map.graphics.clear();
				tb.activate(esri.toolbars.Draw.POLYGON);
			});
			*/
		}
        dojo.ready(initMap);
    </script>
        
    <script>
        function generateTaxSourceXZQ(){
            var xzqlayer = arcgisMap.getVillageLayer();
            var taxpayerLayer = arcgisMap.getTaxpayerLayer();
            var ary = [];
            for(var i=0;i< taxpayerLayer.graphics.length;i++){
    		   var g = taxpayerLayer.graphics[i];
    		   var taxpayerid = g.attributes.OBJECTID;
   			   var point = g.geometry;  //点
   			   for(var j = 0;j < xzqlayer.graphics.length;j++){
   				   var subg = xzqlayer.graphics[j];
   				   var polygon = subg.geometry;
   				   if(polygon.contains(point)){
   					   ary.push(taxpayerid+","+subg.attributes.XZQDM);
   				   }
   			   }
    	    }
            var paramsstr = ary.join('@');
            console.log(paramsstr);
            $.messager.confirm('确认', '你确定要执行此操作?', function(r){
				if (r){
			            $.messager.progress(); 
			            $.ajax({
						   type:"post",
						   async:true,
						   url: "/maphelp/generatetaxsourcexzqdm.do",
						   data: {'paramsstr':paramsstr},
						   dataType: "json",
						   success: function(jsondata){
							  $.messager.progress('close'); 
							  if(jsondata.sucess){
								  alert("生成税源图层的行政区代码成功");
							  }
						   }
					   });
                }
			});
        }
        function updatetowndm(){
        	$.messager.confirm('确认', '你确定要执行此操作?', function(r){
				if (r){
		        	$.messager.progress(); 
		        	$.ajax({
					   type:"post",
					   async:true,
					   url: "/maphelp/updatetown.do",
					   data: {},
					   dataType: "json",
					   success: function(jsondata){
						  $.messager.progress('close'); 
						  if(jsondata.sucess){
							  alert("生成税源图层的行政区代码成功");
						  }
					   }
				   });
        	    }
			});
        }
        function deleteRepeateVillage(){
        	$.messager.confirm('确认', '你确定要执行此操作?', function(r){
				if (r){
					$.messager.progress(); 
		        	$.ajax({
					   type:"post",
					   async:true,
					   url: "/maphelp/deleterepeatvillage.do",
					   data: {},
					   dataType: "json",
					   success: function(jsondata){
						  $.messager.progress('close'); 
						  if(jsondata.sucess){
							  alert("删除村委会图层图层的重复数据");
						  }
					   }
				   });
				}
			});
        	
        }
        function updatevillagebysybase(){
        	$.messager.confirm('确认', '你确定要执行此操作?', function(r){
				if (r){
					$.messager.progress(); 
		        	$.ajax({
					   type:"post",
					   async:true,
					   url: "/maphelp/updatevillagebysybasedata.do",
					   data: {},
					   dataType: "json",
					   success: function(jsondata){
						  $.messager.progress('close'); 
						  if(jsondata.sucess){
							  alert("修改数据成功！");
						  }
					   }
				   });
				}
			});
        	
        }
        function openQueryFeature(){
        	$('#featurediv').window('open');
        }
        
        $(function(){
        	$('#queryform input[name="layerchoose"]').bind('click',function(evt){
        		 var layer = null;
        		 if($(this).val() + '' == '1'){
        			 layer = arcgisMap.getTaxpayerLayer();
        		 }else if($(this).val() + '' == '2'){
        			 layer = arcgisMap.getTdgyLayer();
        		 }else if($(this).val() + '' == '3'){
        			 layer = arcgisMap.getVillageLayer();
        		 }else if($(this).val() + '' == '4'){
        			 layer = arcgisMap.getTownLayer();
        		 }
                 
        	});
        });
        function queryFeature(){
        	var elements = $('#queryform input[name="layerchoose"]');
        	var layer = null;
        	for(var i = 0;i < elements.length;i++){
        		var element = elements[i];
        		if(element.checked){
        			 if($(element).val() + '' == '1'){
        			     layer = arcgisMap.getTaxpayerLayer();
	        		 }else if($(element).val() + '' == '2'){
	        			 layer = arcgisMap.getTdgyLayer();
	        		 }else if($(element).val() + '' == '3'){
	        			 layer = arcgisMap.getVillageLayer();
	        		 }else if($(element).val() + '' == '4'){
	        			 layer = arcgisMap.getTownLayer();
	        		 }
        			 break;
        		}
        	}
        	if(layer == null){
        		alert('先选择图层!');
        		return;
        	}
        	var objectid = $('#queryform #objectid').val();
        	if(!objectid){
        		alert("填写objectid");
        		return false;
        	}
        	var isqueryed = false;
        	for(var i=0;i<layer.graphics.length;i++){
		    		var g = layer.graphics[i];
		   			var tempobjectid = g.attributes.OBJECTID;
		    		if(tempobjectid == objectid){
		    			isqueryed = true;
		    			var geometry = g.geometry;
		    			if(geometry.getCentroid){
		    				var point = geometry.getCentroid();
		    			}
		    			if(point){
		    				map.centerAndZoom(point,3);
		    			}
					    map.graphics.clear();
					    var highlightSymbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255,100,0]), 3), new dojo.Color([125,125,125,0.35]));
					    var highlightGraphic = new esri.Graphic(geometry,highlightSymbol);
					    map.graphics.add(highlightGraphic);
		    		}   
		    }
        	if(!isqueryed){
        		alert('没找到数据！');
        	}
        }
    </script>
  </head>
  <body>
     <div class="easyui-layout" style="width:100%;height:570px;" id="layoutDiv" >
	     <div data-options="region:'center'">
		     <div id="map" style="width:100%;height:530px;"></div>
	    </div>
		<div id = "tooldiv" data-options="region:'north'" style="height:35px;width:100%;overflow: visible;display:none;" >
			<div style="height:35px;">
			    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="updatetowndm()">和sybase的行政区比对，修改地图的乡镇图层、村委会图层行政区代码</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="generateTaxSourceXZQ()">生成税源图层的行政区代码</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="deleteRepeateVillage()">删除村委会图层图层的重复数据</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="updatevillagebysybase()">和sybase的行政区比对，修改地图的村委会图层行政区代码</a>
			    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="openQueryFeature()">查找feature</a>
			</div>
		</div>
	</div>
	<div id="featurediv" class="easyui-window" data-options="closed:true,modal:false,title:'feature查询条件',collapsible:false,
	   minimizable:false,maximizable:false,closable:true" style="width:700px;">
			<form id="queryform" method="post">
				<table id="narjcxx" width="100%" cellpadding="3" cellspacing="0" border="1" bordercolor="#FCD209" style="border-collapse:collapse">
					<tr>
					    <td align="right">图层：</td>
						<td>
							<input type="radio" name="layerchoose" value="1"/>税源		
							<input type="radio" name="layerchoose" value="2"/>土地	
							<input type="radio" name="layerchoose" value="3"/>村委会	
							<input type="radio" name="layerchoose" value="3"/>乡镇				
						</td>
						<td align="right">objectid：</td>
						<td>
							<input class="easyui-numberbox" name="objectid" id="objectid"/>					
						</td>
					</tr>
				</table>
			</form>
			<div style="text-align:center;padding:5px;height: 25px;">  
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="queryFeature()">查询</a>
			</div>
	</div>	
  </body>
</html> 

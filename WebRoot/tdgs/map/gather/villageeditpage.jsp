<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/common/inc.jsp"%>
<!DOCTYPE html>
  <head>
    <title>村委会修改</title>
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
    //esri.config.defaults.io.proxyUrl = "proxy.jsp"; 
    var GloabTdgyObjectId = null;
    var arcgisMap = null;
    var map = null;
    
    var INIITAL = false;
    function initMap(){
    	arcgisMap = new ArcgisMap(
    	   {
    		  mapdiv:'map',
    		  notiledmap:true,
    		  visiblelayer:[ArcgisMap.villagelayerid,ArcgisMap.townlayerid],
    		  villageclick:villageLayerClick,
    		  click:mapClick,
    		  townlayerender:getTownLayerRender(),
    		  layerloaded:function(){
    		     var townlayer = arcgisMap.getTownLayer();
    		     townlayer.setOpacity(0.7);
    		     var villagelayer = arcgisMap.getVillageLayer();
    		     villagelayer.setOpacity(0.4);
    		     INIITAL = true;
    		  }
    	   }	
    	);
        map = arcgisMap.map;
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
    	var geometry = evt.graphic.geometry;
   		var xzqdm = evt.graphic.attributes.XZQDM;
   		var xzqmc = evt.graphic.attributes.XZQMC;
	    var highlightSymbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255,100,0]), 3), new dojo.Color([125,125,125,0.35]));
	    var highlightGraphic = new esri.Graphic(geometry,highlightSymbol);
	    map.graphics.add(highlightGraphic);
	    
    }
    function mapClick(evt){
    	var identifyTask = new esri.tasks.IdentifyTask(arcgisMap.mapServerPath+"/jnds/MapServer");
		var identifyParams = new esri.tasks.IdentifyParameters();
		identifyParams.tolerance = 3;
		identifyParams.returnGeometry = true;
		identifyParams.layerIds = [3];
		identifyParams.layerOption = esri.tasks.IdentifyParameters.LAYER_OPTION_ALL;
		identifyParams.width  = map.width;
		identifyParams.height = map.height;
		identifyParams.geometry = evt.mapPoint;
		identifyParams.mapExtent = map.extent;
		identifyTask.execute(identifyParams,function(idResults) {
			if(idResults && idResults.length > 0){
				 var attrs = idResults[0].feature.attributes;
				 var xzqdm = attrs.行政区代码;
				 var xzqmc = attrs.行政区名称;
				 var objectid = attrs.OBJECTID;
				 console.log("当前村委会的信息为：objectid="+objectid+",xzqdm="+xzqdm+",xzqmc="+xzqmc);
				 $('#villageform').form('clear');
				 $('#villageform #objectid').val(objectid);
				 $('#villageform #xzqdm').val(xzqdm);
				 $('#villageform #xzqmc').val(xzqmc);
				 $('#villagediv').window('open');
			}
		});
    }
   </script>
<script>
  $(function(){
	    initMap();
	    var params = getCondition();
	    $('#districttable').datagrid({
			fitColumns:false,
			maximized:'true',
			pagination:true,
			pageList:[18],
			singleSelect:true,
			queryParams:params,
			url:'/gisgather/getvilliageinfo.do',
			onClickRow:districtclick,
			onLoadSuccess:function(){
				//不能放在这个地方，分页时会重新加载
			},
			rowStyler:function(index,row){
				if(row.villageList){
					if(row.villageList.length == 1){
						return 'background-color:#A8FF24;';
					}else if(row.villageList.length > 1){
						return 'background-color:#6A6AFF;';
					}else{
						return 'background-color:#FF8040;';
					}
				}
			}
		});
      var p = $('#districttable').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
	  });
	  $(p).pagination({   
		showPageList:false
	  });
	  
	  $('#villagesubtable').datagrid({
		  onClickRow:villagesubclick
	  });
	  var left = $('#westDiv').parent().css('left');
	  var top =  $('#westDiv').parent().css('top');
	  var width =  $('#westDiv').parent().css('width');
	  left = parseInt(left);
	  width = parseInt(width);
	  top = parseInt(top);
	  var newleft = (left+width+75)+'px';
	  var newtop = (top+12)+'px';
	   
	   $('#villagesubinfodiv').parent().css('left',newleft);
	   $('#villagesubinfodiv').parent().css('top',newtop);
	   $('#villagesubinfodiv').parent().css('padding','0px');
  });
  
  function focusVillage(objectid){
	  map.graphics.clear();
      map.infoWindow.hide();
      var featureLayer = arcgisMap.getVillageLayer();
       for(var i=0;i<featureLayer.graphics.length;i++){
   		   var tempg = featureLayer.graphics[i];
  			   var villageid = tempg.attributes.OBJECTID;
   		   if(villageid == objectid){
   			   g = tempg;
   			   var x = tempg.attributes.X;
			   var y = tempg.attributes.Y;
			   point = new esri.geometry.Point(x, y, new esri.SpatialReference({ wkid: 2358 }));
   			   break;
   		   }
      	}
       if(g && point){
       	//map.centerAndZoom(point,1);
       	var geometry = g.geometry;
	    var highlightSymbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255,100,0]), 3), new dojo.Color([125,125,125,0.35]));
	    var highlightGraphic = new esri.Graphic(geometry,highlightSymbol);
        map.graphics.add(highlightGraphic);
       }
  }
  
  function districtclick(index,row){
	  if(INIITAL){
		 map.graphics.clear();
    	 map.infoWindow.hide();
	    if(row.villageList.length == 1){
	        var g = null;
	        var point = null;
		    var objectid = row.villageList[0]['objectid']+'';
		    focusVillage(objectid);
	        $('#villagesubinfodiv').window('close');
		}else if(row.villageList.length > 1){
			var objectidAry = [];
			var villageary = [];
			console.log("============================================");
			for(var len = 0;len < row.villageList.length;len++){
				var village = row.villageList[len];
				objectidAry.push(village['objectid']);
				console.log("当前村委会的信息为：objectid="+village['objectid']+",xzqdm="+village['xzqdm']+",xzqmc="+village['xzqmc']);
			}
			var featureLayer = arcgisMap.getVillageLayer();
	        for(var i=0;i<featureLayer.graphics.length;i++){
	    		   var tempg = featureLayer.graphics[i];
	   			   var villageid = tempg.attributes.OBJECTID;
	    		   if(objectidAry.contains(villageid)){
	    			   g = tempg;
	    			   var x = tempg.attributes.X;
					   var y = tempg.attributes.Y;
					   point = new esri.geometry.Point(x, y, new esri.SpatialReference({ wkid: 2358 }));
					   villageary.push({'g':g,'point':point});
	    		   }
	    	}
	        if(villageary){
	        	var firstpoint = null;
	        	for(var j = 0;j < villageary.length;j++){
	        		var g = villageary[j]['g'];
	        		if(!firstpoint)
	        			firstpoint = villageary[j]['point'];
	        		var geometry = g.geometry;
				    var highlightSymbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255,100,0]), 3), new dojo.Color([125,125,125,0.35]));
				    var highlightGraphic = new esri.Graphic(geometry,highlightSymbol);
			        map.graphics.add(highlightGraphic);
	        	}
	        	if(!firstpoint){
	        		map.centerAndZoom(firstpoint,1);
	        	}
	        }
	        $('#villagesubtable').datagrid('loadData',[]);
	        $('#villagesubtable').datagrid('loadData',row.villageList);
	        $('#villagesubinfodiv #newxzqmc').val(row.name);
			$('#villagesubinfodiv').window('open');
		}else{
			$('#villagesubinfodiv').window('close');
			$.messager.alert('错误','地图上无对应的村委会信息！','info');
		}
	  }else{
		  $.messager.alert('错误','地图正在初始化！','info');
	  }
  }
  function villagesubclick(index,row){
	  focusVillage(row.objectid);
  }
  function editVillage(){
	  var params = {};
	  params['objectid'] = $('#villageform #objectid').val();
	  params['xzqdm'] = $('#villageform #xzqdm').val();
	  params['xzqmc'] = $('#villageform #xzqmc').val();
	  $.ajax({
	   type:"post",
	   async:false,
	   url: "/gisgather/updatemapvilliageinfo.do",
	   data: params,
	   dataType: "json",
	   success: function(jsondata){
		   if(jsondata.sucess){
			   $.messager.alert('状态','修改成功！','info',function(){
				   arcgisMap.getVillageLayer().refresh();
				   $('#villagediv').window('close');
				   var queryParams = getCondition();
				   $('#districttable').datagrid('reload',queryParams);
			   });
		   }else{
			   $.messager.alert('状态','修改失败！','info');
		   }
	   }
	 });
  }
  function getCondition(){
   	    var params = {};
   	    params['parentdistrictcode'] = '530122';
	    params['levels'] = '5';
	    return params;
   }  
  function addDeleteImage(value,row,index){
	  return '<img alt="删除" src="/images/removeoper.png" onclick="javascript:alert(11);"/>';
  }
  function unionVillage(){
	  var rows = $('#villagesubtable').datagrid('getChecked');
	  if(rows.length < 2){
		  $.messager.alert('消息','请至少选择两条村委会进行合并！','warn');
		  return;
	  }
	  var newxzqdm = $('#districttable').datagrid('getSelected').id;
	  var newxzqmc = $('#villagesubinfodiv #newxzqmc').val();
	  if(!newxzqmc){
		  $.messager.alert('消息','请输入新的村委会名称！','warn');
		  return;
	  }
	  //villagesubinfodiv   newxzqmc
	  var objectidAry = [];
	  var geometryAry = [];
	  for(var r = 0;r < rows.length;r++){
		  var row = rows[r];
		  objectidAry.push(row.objectid);
		  console.log(row.objectid);
	  }
	  var villageLayer = arcgisMap.getVillageLayer();
      for(var i=0;i< villageLayer.graphics.length;i++){
   		   var g = villageLayer.graphics[i];
   		   var villageId = g.attributes.OBJECTID;
   		   if(objectidAry.contains(villageId)){
   			   geometryAry.push(g.geometry);
   		   }
      }
      if(geometryAry.length != objectidAry.length){
    	  $.messager.alert('消息','是不是村委会还没加载完毕？','warn');
    	  return;
      }
      ArcgisMap.unionPolygon(geometryAry,function(geometry){
    	  var params = {};
    	  params['xzqdm'] = newxzqdm;
    	  params['xzqmc'] = newxzqmc;
    	  var centerPoint = geometry.getCentroid();
    	  params['centerx'] = centerPoint.x;
          params['centery'] = centerPoint.y;
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
	      params['polygonx'] = xstr;
		  params['polygony'] = ystr;
		  params['deleteObjectids']=objectidAry.join(',');
		  $.messager.confirm('合并村委会', '您确定要合并村委会吗？一旦合并，则不能恢复！', function(r){
				if (r){
					  $.messager.progress();
					  $.ajax({
						   type:"post",
						   async:false,
						   url: "/gisgather/unionvillageinfo.do",
						   data: params,
						   dataType: "json",
						   success: function(jsondata){
							   $.messager.progress('close');
							   if(jsondata.sucess){
								   $.messager.alert('状态','合并村委会成功！','info',function(){
									   arcgisMap.getVillageLayer().refresh();
									    $('#villagediv').window('close');
									   var queryParams = getCondition();
									   $('#districttable').datagrid('reload',queryParams);
								   });
							   }else{
								   $.messager.alert('状态','合并村委会失败！','info');
							   }
						   }
						 });
				}
		  });
      });
      
  }
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
</script>
 </head>
  <body style="overflow: hidden;">
    <div class="easyui-layout" style="width:100%;height:610px;" id="layoutDiv">
		<div data-options="region:'north',border:false" style="width:99; height:30px; padding:1px;border:1px solid #ddd;overflow:hidden;padding-top: 5px;">	
		   <font color="red" style="font-weight: bold;">红色表示村委会采集中有，地图中无此村委会</font>
		    <font color="#6A6AFF" style="font-weight: bold;">蓝色表示采集中有，地图中对应不止一个对应的村委会</font>
		    <font color="green" style="font-weight: bold;">绿色表示采集中有，地图中有一个村委会与之对应</font>
		 <a class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" onclick="generateTaxSourceXZQ()" style="display:none;">生成税源图层的行政区代码</a>	
		</div>
		<div id="centerpanel" data-options="region:'center',split:true" style="width:99; height:575px; border:1px solid #000;">
		   <div id="map" style="width:99; height:570px; border:1px solid #000;" align="left">
		   </div> 
		</div>
		<div id="westDiv" data-options="region:'west',split:true,collapsible:true,minimizable:false" style="height:575px;width:330px;overflow:hidden;" title="村委会信息">
			 <table id='districttable'  style="width:99;height:570px;overflow: scroll;">
					<thead>
							<th data-options="field:'id',width:100,align:'center',editor:{type:'validatebox'}">村委会代码</th>
							<th data-options="field:'name',width:215,align:'center',editor:{type:'validatebox'}">村委会名称</th>
					</thead>
			</table> 
		</div>
    </div>
    <div id="villagediv" class="easyui-window" data-options="closed:true,modal:true,title:'地图的村委会信息修改',collapsible:false,
	   minimizable:false,maximizable:false,closable:true" style="width:640px;">
			<form id="villageform" method="post">
			    <input type="hidden" id="objectid" name="objectid"/>
				<table id="narjcxx" width="100%" cellpadding="3" cellspacing="0" border="1" bordercolor="#FCD209" style="border-collapse:collapse">
					<tr>
						<td align="right">村委会代码：</td>
						<td>
							<input class="easyui-validatebox" name="xzqdm" id="xzqdm" />					
						</td>
						<td align="right">村委会名称：</td>
						<td>
							<input class="easyui-validatebox" name="xzqmc" id="xzqmc" />					
						</td>
						
					</tr>
				</table>
			</form>
			<div style="text-align:center;padding:5px;height: 25px;">  
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" onclick="editVillage()">修改地图的村委会信息</a>
			</div>
	</div>
	<div id="villagesubinfodiv" class="easyui-window" data-options="closed:true,modal:false,title:'地图村委会信息',collapsible:false,shadow:false,
	   minimizable:false,maximizable:false,closable:true" style="width:330px;">
			<table id='villagesubtable' class="easyui-datagrid"  style="width:99;height:220px;overflow: hidden;" 
			  data-options="iconCls:'icon-edit',singleSelect:false">
					<thead>
					        <th data-options="field:'oper',width:50,checkbox:true,align:'center',editor:{type:'validatebox'}"></th>
					        <th data-options="field:'objectid',hidden:true,width:80,align:'center',editor:{type:'validatebox'}">objectid</th>
							<th data-options="field:'xzqdm',width:80,align:'center',editor:{type:'validatebox'}">村委会代码</th>
							<th data-options="field:'xzqmc',width:180,align:'center',editor:{type:'validatebox'}">村委会名称</th>
					</thead>
			</table> 
			<div style="text-align:center;padding:5px;height: 25px;">  
			        新名称:<input class="easyui-validatebox" name="newxzqmc" id="newxzqmc" />
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="unionVillage()">合并</a>
			</div>
	</div>
  </body>
</html>


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
	<script src="/js/datecommon.js"></script>	
	<script src="/js/common.js"></script>
	<script src="/js/widgets.js"></script>
	<script src="../config.js"></script>
	<script>var dojoConfig = { parseOnLoad: true };</script>
    <script src="<%=spath%>/arcgis_js_api/library/3.7/3.7/init.js"></script>
    <script src="/js/mapcommon.js"></script>
<script>
	var arcgisMap = null;
    var map = null;
    function initMap(){
    	arcgisMap = new ArcgisMap(
    	   {
    		  mapdiv:'map',
    		  visiblelayer:[ArcgisMap.tdgylayerid,ArcgisMap.forestlayerid,ArcgisMap.villagelayerid,ArcgisMap.townlayerid],
    		  loadingdiv:'loadingImg',
    		  load:initToolbar,
    		  layerloaded:function(){
    			  var tdgyLayer = arcgisMap.getTdgyLayer();
    			  dojo.connect(tdgyLayer,"onUpdateEnd",function(){
					   queryMap();
			      });
    		  }
    	   }	
    	);
        map = arcgisMap.map;
    }
    
    
    var tb = null;
    function initToolbar() {
		tb = new esri.toolbars.Draw(map);
		dojo.connect(tb, "onDrawEnd", addGraphic);
		
		dojo.connect(dojo.byId("mesureArea"),"click", function(){
			ArcgisMap.DRAW = true;
			map.infoWindow.hide();
			map.graphics.clear();
			tb.activate(esri.toolbars.Draw.POLYGON);
		});
	}
    function addGraphic(geometry) {
          tb.deactivate();
	      map.graphics.clear();
	      map.graphics.add(new esri.Graphic(geometry,ArcgisMap.getHighlightSymbol()));
	      ArcgisMap.calculateAreaAndLength(geometry,function(areas,lengths){
	    	   var area = areas[0].toFixed(3);
		       var length = lengths[0].toFixed(3);
		    	var unitArea = areas[0]*0.0015.toFixed(3);//亩
		    	$.messager.alert('提示消息','所画地块的面积为'+area+'平方米，'+unitArea+'亩!','info',function(){
		    		map.graphics.clear();
		    	});
	      });
    }
    dojo.ready(initMap);
    </script>
<script type="text/javascript">
   $(function(){
	    var managerLink = new OrgLink();
	    managerLink.sendMethod = true;
	    managerLink.loadData();
	   $('#landInfoTable').datagrid({
			fitColumns:false,
			maximized:'true',
			pagination:true,
			pageList:[15]
		});
      var p = $('#landInfoTable').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
	  });
	   queryLand();
   });
    function openQueryLand(){
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
  function queryLand(){
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
  function queryMap(){
	  var params = getCondition();
	  params['isrelation'] = '1';
	  //$.messager.progress();
	  //$.messager.progress('close');
	  $.ajax({
		   type: "post",
		   async:false,
		   url: "/landavoidtaxmanager/selectlandlist.do",
		   data: params,
		   dataType: "json",
		   success: function(jsondata){
			  var layerids = "";
			  for(var i = 0;i < jsondata.length;i++){
				  layerids += jsondata[i].layerid+",";
			  }
			  if(layerids){
				   layerids = layerids.substring(0,layerids.length-1);
				   $.ajax({
					   type: "post",
					   async:false,
					   url: "/mapcommon/getTdgyByTaxpayerObjectid.do",
					   data: {'layerids':layerids},
					   dataType: "json",
					   success: function(jsondata){
						  var tdgyLayer = arcgisMap.getTdgyLayer();
						  for(var i = 0;i < tdgyLayer.graphics.length;i++){
							  var g = tdgyLayer.graphics[i];
							  var objectid = g.attributes.OBJECTID;
							  if(jsondata.contains(objectid)){
								  g.setAttributes({'isvis':'1'});
								  g.show();
							  }else{
								  g.setAttributes({'isvis':'0'});
								  g.hide();
							  }
						  }
					   }
				   });
			  }
		   }
	   });
  }
  function displayland(otype){
	  if(otype == 1){
		   $('#landinfodiv').show();
		   $('#mapdiv').hide();
		   $('#landinfodiv').css('float','none');
		   $('#landinfodiv').css('width','100%');
		   $('#landInfoTable').datagrid({
			   
		   });
		   var p = $('#landInfoTable').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
	       });
		  
	  }else if(otype == 2){
		  $('#landinfodiv').hide();
		  $('#mapdiv').show();
		  $('#mapdiv').css('float','none');
		  $('#mapdiv').css('width','100%');
		  map.resize(true);
		  map.reposition();
		  //越大越往下
		  var point = new esri.geometry.Point(34554239.202,2726900.476,new esri.SpatialReference({wkid:2358}));
		  //34554239.202,2723900.476
		  map.centerAt(point);
		  /*
		  $('#map').remove();
		  var newMapDiv = $("<div id='map' style='width:100%;height:625px; border:0px solid #000;'>");
		  $('#mapdiv').append(newMapDiv);
		  initMap();
		  */
	  }else if(otype == 3){
		  $('#landinfodiv').css('float','left');
		  $('#landinfodiv').css('width','37%');
		  $('#mapdiv').css('float','right');
		  $('#mapdiv').css('width','63%');
		  $('#landinfodiv').show();
		  $('#mapdiv').show();
		  
		   $('#landInfoTable').datagrid({
			   
		   });
	   	   var p = $('#landInfoTable').datagrid('getPager');  
			$(p).pagination({  
				showPageList:false
          });
		  map.resize(true);
		  map.reposition();
		  var point = new esri.geometry.Point(34554239.202,2726900.476,new esri.SpatialReference({wkid:2358}));
		  //34554239.202,2723900.476
		  map.centerAt(point);
	  }
  }
</script>
  </head>
  <body style="overflow:hidden" >
    <div class="easyui-layout" style="width:100%;height:660px;" id="layoutDiv">
		<div data-options="region:'north',border:false" style="width:99; height:25px; padding:1px;border:1px solid #ddd;overflow:hidden">
		    <a id="queryLand" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-search'" onclick="openQueryLand()">查询土地</a>		         
			<a href="javascript:arcgisMap.navToolbar.zoomToFullExtent();" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-globeLarge'">全图范围</a>
		    <a id="mesureArea" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-save'">测算面积</a>
		    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		    <b>展现方式：</b><input type="radio" id="displaytype" name="displaytype" value="1" onclick="displayland(1)"/>列表展现
		    <input type="radio" id="displaytype" name="displaytype" value="2" onclick="displayland(2)"/>地图展现
		    <input type="radio" id="displaytype" name="displaytype" value="3" checked="checked" onclick="displayland(3)"/>列表地图综合展现
		</div>
		<div id="centerdiv" data-options="region:'center'" style="width:100; height:625px;">
		     <div id="landinfodiv" style="width:37%; height:625px;float:left;">
		         <table id='landInfoTable' class="easyui-datagrid" style="height:625px;width:100;overflow: hidden;"
					      data-options="iconCls:'icon-edit',singleSelect:true,pageList:[15]">
						<thead>
							<tr>
							    <th data-options="field:'estateid',hidden:true,width:50,align:'center',editor:{type:'validatebox'}">主键</th>
								<th data-options="field:'estateserialno',width:120,align:'center',editor:{type:'validatebox'}">宗地编号</th>
								<th data-options="field:'landcertificate',width:120,align:'center',editor:{type:'validatebox'}">土地证号</th>
								<th data-options="field:'taxpayerid',width:100,align:'center',editor:{type:'validatebox'}">计算机编码</th>
								<th data-options="field:'taxpayername',width:175,align:'left',editor:{type:'validatebox'}">纳税人名称</th>
								<th data-options="field:'locationtypename',width:175,align:'center',editor:{type:'validatebox'}">坐落地类型</th>
								<th data-options="field:'belongtownname',width:175,align:'center',editor:{type:'validatebox'}">所属村委会</th>
								<th data-options="field:'holddate',width:120,align:'center',formatter:ArcgisMap.formatterDate,editor:{type:'validatebox'}">交付日期</th>
								<th data-options="field:'landarea',width:120,align:'center',editor:{type:'validatebox'}">土地面积</th>
								<th data-options="field:'landmoney',width:120,align:'center',editor:{type:'validatebox'}">土地总价</th>
							</tr>
						</thead>
			    </table>
		     </div>
		     <div id="mapdiv" style="width:63%; height:625px;float:right;">
		         <div id="map" style="width:100%;height:625px; border:0px solid #000;">
		         </div>
		     </div>     
		</div>
    </div>
		  <img id="loadingImg" src="/images/loading.gif" style="position:absolute; right:702px; top:256px; z-index:100;" />
		<div id="landquerydiv" class="easyui-window" data-options="closed:true,modal:true,title:'土地查询条件',collapsible:false,
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
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							是否欠税
							<input type="checkbox"/>
						</td>
					</tr>
				</table>
			</form>
			<div style="text-align:center;padding:5px;height: 25px;">  
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="query()">查询</a>
			</div>
	</div>	

  </body>
</html>
<script>
</script>

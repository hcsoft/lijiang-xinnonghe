<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/common/inc.jsp"%>
<!DOCTYPE html>
  <head>
    <title>纳税人视角分析</title>
	<link rel="stylesheet" href="/themes/sunny/easyui.css">
	<link rel="stylesheet" href="/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="/css/tablen.css">
	<link rel="stylesheet" href="/css/spectrum.css">
	
	<script src="/js/jquery-1.8.2.min.js">
	</script>
	<script src="/js/jquery.easyui.min.js">
	</script>
	<script src="/js/tiles.js">
	</script>
	<script src="/js/moduleWindow.js">
	</script>
	<script src="/menus.js">
	</script>
	<script src="/js/jquery.simplemodal.js">
	</script>
	<script src="/js/overlay.js">
	</script>
	<script src="/js/jquery.json-2.2.js">
	</script>
	<script src="/js/json2.js">
	</script>
	<script src="/locale/easyui-lang-zh_CN.js">
	</script>
	<script src="/js/jquery.simplemodal.js">
	</script>
	<script src="/js/uploadmodal.js">
	</script>
	<script src="/js/common.js">
	</script>
	<script src="/supergis/SuperMap.Include.js">
	</script>
	<script src="/supergis/SuperMap-7.0.1-11323.js">
	</script>
	<script src="/supergis/Lang/zh-CN.js">
	</script>
	<script src="/js/datecommon.js">
	</script>
	<script src="/js/newmap.js">
	</script>
    <style type="text/css">
        .dialogopen{
           background-color: red;
        }
    </style>
<script>
	var optmenu = [{
		text: '查询',
		iconCls: 'icon-search',
		handler: function() {
			$('#taxpayerquerydiv').window('open');
		}
	}];
    function getTdgyQuery() {
		var params = getCondition();
		var tdgyobjectids = ""; //宗地编号
		var taxpayerobjectids = "";
		var tdgyownary = [];
		var taxpayerownary = [];
		params['isrelation'] = '1';
		$.ajax({
			type: "post",
			async: true,
			url: "/viewanalizy/getlandlist.do",
			data: params,
			dataType: "json",
			success: function(jsondata) {
				vectorlayer.removeAllFeatures();
				pointvectorlayer.removeAllFeatures();
				if(jsondata.length>0){
				for (var i = 0; i < jsondata.length; i++) {
					if (jsondata[i].tdgyobjectids) {
						tdgyobjectids += jsondata[i].tdgyobjectids + ",";
						if (jsondata[i].ownstatus == '1') {
							tdgyownary.push(jsondata[i].tdgyobjectids);
						}
					}
					if (jsondata[i].taxpayerobjectids) {
						taxpayerobjectids += jsondata[i].taxpayerobjectids + ",";
						if (jsondata[i].ownstatus == '1') {
							taxpayerownary.push(jsondata[i].taxpayerobjectids);
						}
					}
				}
				if (tdgyobjectids) {
					tdgyobjectids = tdgyobjectids.substring(0, tdgyobjectids.length - 1);
				}
				if (taxpayerobjectids) {
					taxpayerobjectids = taxpayerobjectids.substring(0, taxpayerobjectids.length - 1);
				}
				querymapinfo2(taxpayerobjectids, tdgyobjectids);
				}
			}
		});
	}
    

    function formatterDate(value,row,index){
			return formatDatebox(value);
	}
   $(function(){
	    var managerLink = new OrgLink();
	    managerLink.sendMethod = false;
	    managerLink.loadData();

	    CommonUtils.getCacheCodeFromTable('COD_ECONATURECODE','econaturecode',
			                                 'econaturename','#queryform #econaturecode'," ",true);
	    CommonUtils.getCacheCodeFromTable('COD_CALLINGCODE','callingcode',
			                                 'callingname','#queryform #callingcode'," ",true);
	    var params = getCondition();
	   $('#taxpayerInfoTable').datagrid({
			fitColumns:false,
			maximized:'true',
			columns:[[
				{field:'estateid',hidden:true,width:18},
				{field:'taxpayerid',title:'计算机编码',width:120,align:'center'},
				{field:'taxpayername',title:'纳税人名称',width:120,align:'center'},
				{field:'busimanageaddr',title:'经营地址',width:120,align:'center'},
				{field:'legalpersonname',title:'法人',width:120,align:'center'},
				{field:'taxcerno',title:'纳税人识别号',width:120,align:'center'},
				{field:'econaturename',title:'注册类型',width:120,align:'center'},
				{field:'callingname',title:'行业',width:120,align:'center'},
				{field:'shouldtaxmoney',title:'应缴金额',width:120,align:'center'},
				{field:'alreadyshouldtaxmoney',title:'已缴金额',width:120,align:'center'},
				{field:'owetaxmoney',title:'欠税金额',width:120,align:'center'}
			]],
			pagination:true,
			pageList:[15],
			toolbar: optmenu,
			singleSelect:true,
			queryParams:params,
			url:'/viewanalizy/gettaxpayerscontaintax.do',
			onDblClickRow:taxpayerClick,
			onClickRow:function(rowIndex,rowData){
				closeInfoWin();
		        focusMapByTaxpayer(rowData.taxpayerid);
			}
		});
      var p = $('#taxpayerInfoTable').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
	  });
		$(p).pagination({   
			showPageList:false
		});
		mapInit('mapdiv');
		
   });
   function taxpayerClick(rowIndex,rowData){
	   var taxpayerid = rowData.taxpayerid;
	   $.ajax({
					  type: "get",
					  async:true,
					  cache:false,
					  url: "/viewanalizy/gettaxpayercomposite.do?d="+new Date(),
					  data: {'taxpayerid':taxpayerid},
					  dataType: "json",
					  success:function(data){
						  $('#taxpayershouldtaxtable').datagrid('loadData',data.shouldTaxInfo);
						  $('#landoftaxpayertable').datagrid('loadData',data.landList);
						  $('#houseoftaxpayertable').datagrid('loadData',data.houseList);
						  $('#taxpayerinfowindow').window('open');
					  }
	    });
	   
   }
    function openQueryTaxpayer(){
    	$('#taxpayerquerydiv').window('open');
    }
    function getCondition(){
   	    var params = {};
	    var fields =$('#queryform').serializeArray();
	    $.each( fields, function(i, field){
		    params[field.name] = field.value;
	    });
	    var otherCondition = '';
	    if(params.mintax){
	    	otherCondition += ' and shouldtaxmoney >= '+params.mintax;
	    }
	    if(params.maxtax){
	    	otherCondition += ' and shouldtaxmoney <= '+params.mintax;
	    }
	    params['otherCondition'] = otherCondition;
	    return params;
    }
    //landinfowindow,houseinfowindow
    function showMainLandInfo(estateid){
	   $('#landinfowindow').window({
		   href : "viewland.jsp?d="+new Date(),
		   onLoad:function(){
		       afterLandLoaded(estateid);
		   }
	   });
	   //查看土地的基本信息
	   $('#landinfowindow').window('open');
    }
    function showMainHouseInfo(houseid){
    	//houseinfowindow,viewhouse.jsp
    	$('#houseinfowindow').window({
		   href : "viewhouse.jsp?d="+new Date(),
		   onLoad:function(){
		       houseinfoLoaded(houseid);
		   }
	   });
	   //查看土地的基本信息
	   $('#houseinfowindow').window('open');
	   
    	//showHouseInfo(houseid);
    }
    function viewLand(value,row,index){
    	var result =  "<a href=javascript:showMainLandInfo('"+row.estateid+"')>土地信息</a>";
 	    return result;
    }
    function viewHouse(value,row,index){
    	var result =  "<a href=javascript:showMainHouseInfo('"+row.houseid+"')>房产信息</a>";
 	    return result;
    }
  function query(){
	var params = getCondition();
	var opts = $('#taxpayerInfoTable').datagrid('options');
	opts.url = '/viewanalizy/gettaxpayers.do?d='+new Date();
	$('#taxpayerInfoTable').datagrid('load',params); 
	var p = $('#taxpayerInfoTable').datagrid('getPager');  
	$(p).pagination({   
		showPageList:false
	});
	
	$('#taxpayerquerydiv').window('close');		
	//queryMap();
	vectorlayer.removeAllFeatures();
	pointvectorlayer.removeAllFeatures();
	getTdgyQuery();
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
   
	function querymapinfo2(taxpayerinfoids, tdgyids) {
		var smids; //通过后端获取
		var queryParam, queryBySQLParams, queryService;
		queryParam = new SuperMap.REST.FilterParameter({
			name: "TAXPAYERINFO@SUPERMAP",
			attributeFilter: "SMID in (" + taxpayerinfoids + ")"
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
			attributeFilter: "SMID in (" + tdgyids + ")"
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
		queryService.processAsync(queryBySQLParams); //向服务端传递参数，然后服务端返回对象
	}
	function onFeatureSelect(feature) {
		var tdgysmid = parseInt(feature.attributes.TDGYID).toString();
		var tdgyfeatures = vectorlayer.getFeaturesByAttribute('SMID', tdgysmid);
		if (tdgyfeatures.length > 0) {
			vectorlayer.removeFeatures(tdgyfeatures[0]);
			if(tdgyfeatures[0].attributes.ISRELATION =='01'){
				tdgyfeatures[0].style = selectstyle01;
			}else{
				tdgyfeatures[0].style = selectstyle00;
			}
			//tdgyfeatures[0].style.strokeWidth = 2;
			vectorlayer.addFeatures(tdgyfeatures[0]);
			//vectorlayer.redraw();
			//var icon = new SuperMap.Icon("/theme/images/marker.png", size, offset);
		}
		closeInfoWin();
		var contentHTML = '';
		if (feature.attributes.ISRELATION == '01' && feature.attributes.ZDBH != '' && feature.attributes.ZDBH != null) {
			$.ajax({
				type: "post",
				async: false,
				url: "/landavoidtaxmanager/selectlandlist.do",
				data: {
					'estateserialno': feature.attributes.ZDBH
				},
				dataType: "json",
				success: function(jsondata) {
					if (jsondata && jsondata.length > 0) {
						//var title = "土地信息";
						contentHTML = "<table width='100%' cellpadding='3' cellspacing='0' border='1' bordercolor='#FCD209' style='border-collapse:collapse'>";
						contentHTML += "<tr><th>查看土地信息</th><th>权属人</th><th>宗地编号</th><th>交付日期</th><th>土地面积(平方米)</th><th>土地总价(元)</th><th>实际面积(平方米)</th></tr>";
						//content +="<tr><td colspan='6'><a href='xx()'>删除此地块</a></td></tr>";
						for (var i = 0; i < jsondata.length; i++) {
							var land = jsondata[i];
							contentHTML += "<tr><td><a href=\"javascript:showEstateInfo('" + land.estateid + "')\">土地详细信息</a></td><td>" + land.taxpayername + "</td><td>" + land.estateserialno + "</td>" + "<td>" + formatterDate(land.holddate) + "</td>" + "<td>" + land.landarea + "</td><td>" + land.landmoney + "</td><td>" + parseFloat(tdgyfeatures[0].attributes.SMAREA).toFixed(3) + "</td></tr>";
						}
						contentHTML += '</table>';
						//currentObj.map.infoWindow.resize(600,300);
						//currentObj.map.infoWindow.setTitle(title);
						//currentObj.map.infoWindow.setContent(content);
						//currentObj.map.infoWindow.show(evt.screenPoint,currentObj.map.getInfoWindowAnchor(evt.screenPoint));
					} else {
						//currentObj.map.infoWindow.resize(250,100);
						//currentObj.map.infoWindow.setTitle('土地信息');
						contentHTML = "<table width='100%' cellpadding='3' cellspacing='0' border='1' bordercolor='#FCD209' style='border-collapse:collapse'>";
						contentHTML += "<tr><td> <b>此块土地无权属人</b></td></tr>";
						contentHTML += '</table>';
						//currentObj.map.infoWindow.setContent(content);
						//currentObj.map.infoWindow.show(evt.screenPoint,currentObj.map.getInfoWindowAnchor(evt.screenPoint));
					}
				}
			});
		}

		//feature.attributes.TDGYID

		var popup = new SuperMap.Popup.FramedCloud("popwin", feature.geometry.getBounds().getCenterLonLat(), null, contentHTML, null, true, null, true);
		//popup.setBackgroundColor('#FFBBBB');
		infowin = popup;
		map.addPopup(popup);
	}

	function onFeatureUnselect(feature) {
		closeInfoWin();
		var tdgysmid = parseInt(feature.attributes.TDGYID).toString();
		var tdgyfeatures = vectorlayer.getFeaturesByAttribute('SMID', tdgysmid);
		if (tdgyfeatures.length > 0) {
			vectorlayer.removeFeatures(tdgyfeatures);
			if (tdgyfeatures[0].attributes.ISRELATION == '01') {
				tdgyfeatures[0].style = style01;
			} else {
				tdgyfeatures[0].style = style00;
			}
			vectorlayer.addFeatures(tdgyfeatures[0]);
		}

	}
  function displayland(otype){
	  if(otype == 1){
		   $('#taxpayerinfodiv').show();
		   $('#mapdiv').hide();
		   $('#taxpayerinfodiv').css('float','none');
		   $('#taxpayerinfodiv').css('width','100%');
		   $('#taxpayerInfoTable').datagrid({
			   
		   });
		   var p = $('#taxpayerInfoTable').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
	       });
		  
	  }else if(otype == 2){
		  $('#taxpayerinfodiv').hide();
		  $('#mapdiv').show();
		  $('#mapdiv').css('float','none');
		  $('#mapdiv').css('width','100%');
		  map.resize(true);
		  map.reposition();
			//arcgisMap.navToolbar.zoomToFullExtent();
		  
		  /*
		  $('#map').remove();
		  var newMapDiv = $("<div id='map' style='width:100%;height:625px; border:0px solid #000;'>");
		  $('#mapdiv').append(newMapDiv);
		  initMap();
		  */
	  }else if(otype == 3){
		  $('#taxpayerinfodiv').css('float','left');
		  $('#taxpayerinfodiv').css('width','37%');
		  $('#mapdiv').css('float','right');
		  $('#mapdiv').css('width','63%');
		  $('#taxpayerinfodiv').show();
		  $('#mapdiv').show();
		  
		   $('#taxpayerInfoTable').datagrid({
			   
		   });
	   	   var p = $('#taxpayerInfoTable').datagrid('getPager');  
			$(p).pagination({  
				showPageList:false
          });
			map.resize(true);
		    map.reposition();
			//arcgisMap.navToolbar.zoomToFullExtent();
	  }
  }
 function focusMapByTaxpayer(taxpayerid){
		vectorlayer.removeAllFeatures();
		pointvectorlayer.removeAllFeatures();
	   var params = getCondition();
	  if(taxpayerid){
		  params['taxpayerid'] = taxpayerid;
	  }
		var tdgyobjectids = ""; //宗地编号
		var taxpayerobjectids = "";
		var tdgyownary = [];
		var taxpayerownary = [];
		params['isrelation'] = '1';
		$.ajax({
			type: "post",
			async: true,
			url: "/viewanalizy/getlandlist.do",
			data: params,
			dataType: "json",
			success: function(jsondata) {
				for (var i = 0; i < jsondata.length; i++) {
					if (jsondata[i].tdgyobjectids) {
						tdgyobjectids += jsondata[i].tdgyobjectids + ",";
						if (jsondata[i].ownstatus == '1') {
							tdgyownary.push(jsondata[i].tdgyobjectids);
						}
					}
					if (jsondata[i].taxpayerobjectids) {
						taxpayerobjectids += jsondata[i].taxpayerobjectids + ",";
						if (jsondata[i].ownstatus == '1') {
							taxpayerownary.push(jsondata[i].taxpayerobjectids);
						}
					}
				}
				if (tdgyobjectids) {
					tdgyobjectids = tdgyobjectids.substring(0, tdgyobjectids.length - 1);
				}
				if (taxpayerobjectids) {
					taxpayerobjectids = taxpayerobjectids.substring(0, taxpayerobjectids.length - 1);
				}
				querymapinfoonly(taxpayerobjectids, tdgyobjectids);
			}
		});
 }
</script>
  </head>
  <body style="overflow:hidden" >
    <div class="easyui-layout" style="width:100%;height:560px;" id="layoutDiv">
		<!-- <div data-options="region:'north',border:false" style="width:99; height:25px; padding:1px;border:1px solid #ddd;overflow:hidden">
		    <a id="queryLand" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-search'" onclick="openQueryTaxpayer()">查询</a>		         
			<a href="javascript:arcgisMap.navToolbar.zoomToFullExtent();" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-globeLarge'">全图范围</a>
					    <a id="mesureArea" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-save'">测算面积</a>
		    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		    <b>展现方式：</b><input type="radio" id="displaytype" name="displaytype" value="1" onclick="displayland(1)"/>列表展现
		    <input type="radio" id="displaytype" name="displaytype" value="2" onclick="displayland(2)"/>地图展现
		    <input type="radio" id="displaytype" name="displaytype" value="3" checked="checked" onclick="displayland(3)"/>列表地图综合展现
		</div> -->
			<div data-options="region:'west'" id="taxpayerinfodiv" style="height:500px;width:600px;overflow: hidden;">
				<table id='taxpayerInfoTable' style="height:560px;width:100;">
					<thead>
					</thead>
				</table>
			</div>
		     <div id="mapdiv1" data-options="region:'center'">
				<div id = "shiliang">
					<a id="changemap" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-globeLarge'" onclick="changemap();">切换卫星图</a>
				</div>
				<div id = "weixing" style="display:none">
					<a id="changemap" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-globeLarge'" onclick="changemap();">切换矢量图</a>
				</div>
				<div id="mapdiv" style="position:absolute;left:0px;right:0px;width:700px;height:560px;">
				</div>
			</div>
     </div>
		 <img id="loadingImg" src="/images/loading.gif" style="display:none; position:absolute; right:702px; top:256px; z-index:100;" />
		<div id="taxpayerquerydiv" class="easyui-window" data-options="closed:true,modal:true,title:'纳税人查询条件',collapsible:false,
	minimizable:false,maximizable:false,closable:true" style="width:640px;">
			<form id="queryform" method="post">
				<table id="narjcxx" width="100%" class="table table-bordered">
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
						<td align="right">注册类型：</td>
						<td><input id="econaturecode" class="easyui-combobox"  name="econaturecode"/></td>
						<td align="right">行业：</td>
						<td>
							<input id="callingcode" class="easyui-combobox" name="callingcode"/>
						</td>
					</tr>
					<tr>
						<td align="right">登记日期：</td>
						<td colspan="3">
							<input id="regbegindate" class="easyui-datebox" name="regbegindate" style="width: 150px;"/>
						至
							<input id="regenddate" class="easyui-datebox"  name="regenddate" style="width:150px;"/>
						</td>
					</tr>
					<tr>
						<td align="right">应纳税：</td>
						<td colspan="3">
							<input id="mintax" class="easyui-numberbox" name="mintax" style="width: 150px;"/>
						至
							<input id="maxtax" class="easyui-numberbox"  name="maxtax" style="width:150px;"/>
						</td>
					</tr>
				</table>
			</form>
			<div style="text-align:center;padding:5px;height: 25px;">  
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="query()">查询</a>
			</div>
	</div>	
	<!-- 纳税人信息 ----------------------------------------------------------------------------------------------->
	
	<div id="taxpayerinfowindow" class="easyui-window" data-options="closed:true,modal:true,title:'纳税人相关信息',collapsible:false,
	   minimizable:false,maximizable:false,closable:true" style="width:1200px;height:500px;">
	        <div id="ttxx" class="easyui-tabs" style="width:100;height:600px;">  
	        
					    <div title="应纳税信息" data-options="closable:false" style="overflow:auto;padding:5px;">  
					        <table id='taxpayershouldtaxtable' class="easyui-datagrid" style="width:99;height:550px;overflow: scroll;"
									data-options="iconCls:'icon-edit',singleSelect:true">
								<thead>
										<th data-options="field:'taxpayerid',width:100,align:'center',editor:{type:'validatebox'}">计算机编码</th>
										<th data-options="field:'taxpayername',width:220,align:'left',editor:{type:'validatebox'}">纳税人名称</th>
										<th data-options="field:'taxtypename',width:120,align:'center',editor:{type:'validatebox'}">税种</th>
										<th data-options="field:'taxname',width:100,align:'center',editor:{type:'validatebox'}">税目</th>
										<th data-options="field:'taxyear',width:80,align:'center',editor:{type:'validatebox'}">税款所属年份</th>
										<th data-options="field:'shouldtaxmoney',hidden:false,width:120,align:'center',editor:{type:'validatebox'}">应缴金额</th>
										<th data-options="field:'alreadyshouldtaxmoney',hidden:false,width:120,align:'center',editor:{type:'validatebox'}">已缴金额</th>
										<th data-options="field:'owetaxmoney',hidden:false,width:120,align:'center',editor:{type:'validatebox'}">欠税金额</th>
										<th data-options="field:'avoidtaxamount',hidden:false,width:120,align:'center',editor:{type:'validatebox'}">减免金额</th>
								</thead>
							</table>   
					    </div>
					     <div title="拥有的土地" data-options="closable:false" style="overflow:auto;padding:5px;">  
					        <table id='landoftaxpayertable' class="easyui-datagrid" style="width:99;height:550px;overflow: scroll;"
									data-options="iconCls:'icon-edit',singleSelect:true">
								<thead>
								
								        <th data-options="field:'oper',formatter:viewLand,width:100,align:'center',editor:{type:'validatebox'}">主键</th>
										<th data-options="field:'estateid',hidden:true,width:50,align:'center',editor:{type:'validatebox'}">主键</th>
										<th data-options="field:'estateserialno',width:120,align:'center',editor:{type:'validatebox'}">宗地编号</th>
										<th data-options="field:'landcertificate',width:120,align:'center',editor:{type:'validatebox'}">土地证号</th>
										<th data-options="field:'taxpayerid',width:100,align:'center',editor:{type:'validatebox'}">计算机编码</th>
										<th data-options="field:'taxpayername',width:175,align:'left',editor:{type:'validatebox'}">纳税人名称</th>
										<th data-options="field:'locationtypename',width:175,align:'center',editor:{type:'validatebox'}">坐落地类型</th>
										<th data-options="field:'belongtownname',width:175,align:'center',editor:{type:'validatebox'}">所属村委会</th>
										<th data-options="field:'holddate',width:120,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">交付日期</th>
										<th data-options="field:'landarea',width:120,align:'center',editor:{type:'validatebox'}">土地面积(平方米)</th>
										<th data-options="field:'landmoney',width:120,align:'center',editor:{type:'validatebox'}">土地总价(元)</th>
								</thead>
							</table>   
					    </div>
					    <div title="拥有的房产" data-options="closable:false" style="overflow:auto;padding:5px;">  
					        <table id='houseoftaxpayertable' class="easyui-datagrid" style="width:99;height:550px;overflow: scroll;"
									data-options="iconCls:'icon-edit',singleSelect:true">
								<thead>
										<th data-options="field:'oper',formatter:viewHouse,hidden:false,width:100,align:'center',editor:{type:'validatebox'}">查看详细信息</th>
								        <th data-options="field:'houseid',width:100,hidden:true,align:'center',editor:{type:'validatebox'}">房产id</th>
										<th data-options="field:'taxpayerid',width:120,align:'left',editor:{type:'validatebox'}">计算机编码</th>
										<th data-options="field:'taxpayername',width:200,align:'center',editor:{type:'validatebox'}">纳税人名称</th>
										<th data-options="field:'housesourcename',width:120,align:'center',editor:{type:'validatebox'}">房产来源</th>
										<th data-options="field:'housecertificatetypename',width:130,align:'center',editor:{type:'validatebox'}">房产证类型</th>
										<th data-options="field:'housecertificate',hidden:false,width:120,align:'center',editor:{type:'validatebox'}">房产证号</th>
										<th data-options="field:'housearea',hidden:false,width:120,align:'center',editor:{type:'validatebox'}">房产面积(平方米)</th>
										<th data-options="field:'usedate',hidden:false,width:120,formatter:formatterDate,align:'center',editor:{type:'validatebox'}">投入使用日期</th>
										<th data-options="field:'belongtownsname',hidden:false,width:120,align:'center',editor:{type:'validatebox'}">村委会</th>
										<th data-options="field:'detailaddress',hidden:false,width:220,align:'center',editor:{type:'validatebox'}">详细地址</th>
								</thead>
							</table>   
					    </div>
					   
			</div> 
	</div>	  
	<div id="landinfowindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地相关信息',collapsible:false,
	   minimizable:false,maximizable:false,closable:true,href:'viewland.jsp'" style="width:1050px;height:480px;">
	</div>	
	<div id="houseinfowindow" class="easyui-window" data-options="closed:true,modal:true,title:'房产相关信息',collapsible:false,
	   minimizable:false,maximizable:false,closable:true,href:'viewhouse.jsp'" style="width:920px;height:440px;">
	</div>	
	
  </body>
</html>
<script>
</script>

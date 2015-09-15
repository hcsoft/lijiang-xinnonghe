<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<%@ include file="/common/inc.jsp"%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<base target="_self"/>
	<title></title>

	<link rel="stylesheet" href="<%=spath%>/themes/sunny/easyui.css">
	<link rel="stylesheet" href="<%=spath%>/themes/icon.css">
	<link rel="stylesheet" href="<%=spath%>/css/toolbar.css">
	<link rel="stylesheet" href="<%=spath%>/css/logout.css"/>
	<script src="<%=spath%>/js/jquery-1.8.2.min.js"></script>
	<script src="<%=spath%>/js/jquery.easyui.min.js"></script>
	<script src="<%=spath%>/js/dropdown.js"></script>
    <script src="<%=spath%>/js/tiles.js"></script>
    <script src="<%=spath%>/js/moduleWindow.js"></script>
	<script src="<%=spath%>/menus.js"></script>
	
	<script src="<%=spath%>/js/jquery.simplemodal.js"></script>
	<script src="<%=spath%>/js/overlay.js"></script>
	<script src="<%=spath%>/js/jquery.json-2.2.js"></script>
	<script src="<%=spath%>/js/json2.js"></script>
	<script src="<%=spath%>/locale/easyui-lang-zh_CN.js"></script>
	<script src="/js/datecommon.js"></script>	
	<script src="/js/common.js"></script>
	<script src="/js/widgets.js"></script>
	<script src="avoidmanager.js"></script>

    <script>
    CommonUtils.enableAjaxProgressBar();
    function formatterDate(value,row,index){
			return formatDatebox(value);
	}
  
	$(function(){
		var managerLink = new OrgLink();
	    managerLink.sendMethod = false;
	    managerLink.loadData();
	    
	    $('#avoidtaxgrid').datagrid({
			fitColumns:false,
			maximized:'true',
			pagination:true,
			rowStyler:settings.rowStyle,
			pageList:[15]
			
		});
		var p = $('#avoidtaxgrid').datagrid('getPager');  
			$(p).pagination({  
				showPageList:false
			});
			/*
		var firstDay = DateUtils.getYearFirstDay();
			var lastDay = DateUtils.getCurrentDay();
		     $('#begindate').datebox('setValue',firstDay);
		     $('#enddate').datebox('setValue',lastDay);
		     */
	});
		function query(){
			AvoidManager.queryAvoidTax();
		}
		function openQuery(){
			$('#avoidtaxquerywindow').window('open');
		}
		
		/*1 表示审核，0表示取消审核*/
		function estateOrUnEstate(taxreduceid,info){
			if(info.type === 1){
				$.ajax({
				  type: "get",
				  async:true,
				  cache:false,
				   processbar:true,
				  url: "/avoidtaxmanager/estateavoidtax.do?d="+new Date(),
				  data: {'taxreduceid':taxreduceid},
				  dataType: "json",
				  success:function(jsondata){
					  if(jsondata.sucess){
						  $.messager.alert('消息','审核减免税成功！','info',function(){
							  query();
						  });
					  }else{
						  $.messager.alert('错误',jsondata.message,'error');
					  }
				  }
			   });
			}else if(info.type === 0){
				$.ajax({
				  type: "get",
				  async:true,
				  cache:false,
				   processbar:true,
				  url: "/avoidtaxmanager/undoestateavoidtax.do?d="+new Date(),
				  data: {'taxreduceid':taxreduceid},
				  dataType: "json",
				  success:function(jsondata){
					  if(jsondata.sucess){
						  $.messager.alert('消息','取消审核减免税成功！','info',function(){
							  query();
						  });
					  }else{
						  $.messager.alert('错误',jsondata.message,'error');
					  }
				  }
			   });
			}
		}
		function estateAvoidTax(){
			var row = $('#avoidtaxgrid').datagrid('getSelected');
			if(row == null){
				 $.messager.alert('提示消息','请选择需要审核的减免税记录!','info');
				 return;
			}
			$.messager.confirm('确认', '你确认审核当前选中的减免税信息吗？', function(r){
				if (r){
					var taxreduceid = row.taxreduceid;
			        estateOrUnEstate(taxreduceid,{type:1});
				}
			});
			
		}
		function undoEstateAvoidTax(){
			var row = $('#avoidtaxgrid').datagrid('getSelected');
			if(row == null){
				 $.messager.alert('提示消息','请选择需要取消审核的减免税记录!','info');
				 return;
			}
			$.messager.confirm('确认', '你确认取消当前已经审核的减免税信息吗？', function(r){
				if (r){
					var taxreduceid = row.taxreduceid;
			        estateOrUnEstate(taxreduceid,{type:0});
				}
			});
		}
		function addLinkLandInfo(value,row,index){
			var result = "";
			result = "<a style='color:#00f;text-decoration:underline;cursor:pointer;' onclick='showLandInfo("+index+")'>"+value+"</a>";
			return result;
		}
		function showLandInfo(index){
			var rows = $('#avoidtaxgrid').datagrid('getRows');
			var row = null;
			for(var i = 0;i < rows.length;i++){
				if(i === index){
					row = rows[i];
					break;
				}
			}
			var estateid = row.estateid;
			var taxtypecode = row.taxtypecode;
			if(taxtypecode === "20"){
				WidgetUtils.showLandStroeInfo(estateid);
			}else if(taxtypecode === "12"){
				WidgetUtils.showEstate(estateid);
			}else if(taxtypecode == "10"){
				WidgetUtils.showBaseHouse(estateid);
			}
			
		}
		function exportExcel(){
			var params = {};
			var fields =$('#avoidtaxqueryform').serializeArray();  
			$.each(fields, function(i, field){
				params[field.name] = field.value;
			});
			params['propNames'] = 'statename,infoname,taxpayerid,taxpayername,taxtypename,taxname,reducebegindate,reduceenddate,reducenum,'+
			               'reduceclassname,approveunitname,approvenumber,reducereason,policybasis,inputpersonname,inputdate,checkpersonname,checkdate';
			params['colNames'] = '状态,土地信息,计算机编码,纳税人名称,税种,税目,减免起日期,减免止日期,减免面积,减免类型,批准机关,'+
                                 '批准文号,减免原因,政策依据,录入人,录入日期,审核人,审核日期';
			params['modelName']="减免税审核情况";
			CommonUtils.downloadFile("/avoidtaxmanager/avoidtaxexport.do?date="+new Date(),params);
		}
		
	</script>
</head>
<body>
    
     <div class="easyui-layout" style="width:100%;height:570px;" data-options="split:true" id="layoutDiv" >
	     <div data-options="region:'center'">
		    <form id="groundstorageform" method="post">
			<table id='avoidtaxgrid' class="easyui-datagrid" style="width:99;height:543px;overflow: scroll;"
					data-options="iconCls:'icon-edit',singleSelect:true,pageList:[15]">
				<thead>
					 <th data-options="field:'taxreduceid',hidden:true,width:50,align:'center',editor:{type:'validatebox'}">主键</th>
						<th data-options="field:'statename',width:50,align:'center',editor:{type:'validatebox'}">状态</th>
						<th data-options="field:'infoname',width:80,align:'center',formatter:addLinkLandInfo,editor:{type:'validatebox'}">土地信息</th>
						<th data-options="field:'taxpayerid',width:100,align:'center',editor:{type:'validatebox'}">计算机编码</th>
						<th data-options="field:'taxpayername',width:220,align:'left',editor:{type:'validatebox'}">纳税人名称</th>
						<th data-options="field:'taxtypename',width:120,align:'center',editor:{type:'validatebox'}">税种</th>
						<th data-options="field:'taxname',width:150,align:'center',editor:{type:'validatebox'}">税目</th>
						<th data-options="field:'reducebegindate',width:100,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">减免起日期</th>
						<th data-options="field:'reduceenddate',width:100,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">减免止日期</th>
						<th data-options="field:'reducenum',width:120,align:'center',editor:{type:'validatebox'}">减免面积</th>
						<th data-options="field:'reduceclassname',width:120,align:'center',editor:{type:'validatebox'}">减免类型</th>
						<th data-options="field:'approveunitname',width:200,align:'center',editor:{type:'validatebox'}">批准机关</th>
						<th data-options="field:'approvenumber',width:200,align:'center',editor:{type:'validatebox'}">批准文号</th>
						<th data-options="field:'reducereason',width:200,align:'center',editor:{type:'validatebox'}">减免原因</th>
						<th data-options="field:'policybasis',width:230,align:'center',editor:{type:'validatebox'}">政策依据</th>
						<th data-options="field:'inputpersonname',width:100,align:'center',editor:{type:'validatebox'}">录入人</th>
						<th data-options="field:'inputdate',width:100,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">录入日期</th>
						<th data-options="field:'checkpersonname',width:100,align:'center',editor:{type:'validatebox'}">审核人</th>
						<th data-options="field:'checkdate',width:100,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">审核日期</th>
				</thead>
			</table>
		    </form>
	    </div>
		<div data-options="region:'north'" style="height:25px;width:100%;overflow: visible" >
			<div style="height:25px;">
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="openQuery()">查询</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-check',plain:true" onclick="estateAvoidTax()">审核</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-uncheck',plain:true" onclick="undoEstateAvoidTax()">取消审核</a>
				<a class="easyui-linkbutton" data-options="iconCls:'icon-export',plain:true" onclick="exportExcel()">导出</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-no',plain:true">退出</a>
			</div>
		</div>
	</div>
		
	<div id="avoidtaxquerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'税源查询条件',collapsible:false,
	minimizable:false,maximizable:false,closable:true" style="width:640px;height:200px;">
			<form id="avoidtaxqueryform" method="post">
				<table id="narjcxx" width="100%"  cellpadding="3" cellspacing="0" border="1" bordercolor="#FCD209" style="border-collapse:collapse">
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
						<td align="right">减免日期：</td>
						<td colspan="5">
							<input id="begindate" class="easyui-datebox" name="begindate"/>
						至
							<input id="enddate" class="easyui-datebox"  name="enddate"/>
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
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<%@ include file="/common/inc.jsp"%>
<html>
<head>

<title>Complex Layout - jQuery EasyUI Demo</title>

<link rel="stylesheet" href="<%=request.getContextPath()%>/themes/sunny/easyui.css">
	<link rel="stylesheet" href="<%=request.getContextPath()%>/themes/icon.css">
	<link rel="stylesheet" href="<%=request.getContextPath()%>/css/toolbar.css">
	<link rel="stylesheet" href="<%=request.getContextPath()%>/css/logout.css"/>
	<link rel="stylesheet" href="<%=request.getContextPath()%>/css/tablen.css"/>
	<script src="<%=request.getContextPath()%>/js/jquery-1.8.2.min.js"></script>
	<script src="<%=request.getContextPath()%>/js/jquery.easyui.min.js"></script>
    <script src="<%=request.getContextPath()%>/js/tiles.js"></script>
    <script src="<%=request.getContextPath()%>/js/moduleWindow.js"></script>
	<script src="<%=request.getContextPath()%>/menus.js"></script>
	<script src="<%=request.getContextPath()%>/js/common.js"></script>
	<script src="<%=request.getContextPath()%>/js/jquery.simplemodal.js"></script>
	<script src="<%=request.getContextPath()%>/js/overlay.js"></script>
	<script src="<%=request.getContextPath()%>/js/jquery.json-2.2.js"></script>
	<script src="<%=request.getContextPath()%>/js/json2.js"></script>
	<script src="<%=request.getContextPath()%>/locale/easyui-lang-zh_CN.js"></script>
	<script src="<%=request.getContextPath()%>/js/jquery.simplemodal.js"></script>
   	<script src="<%=request.getContextPath()%>/js/uploadmodal.js"></script> 

<script>
var empdata = new Object;
var orgdata = new Object;
$(function(){
	$.ajax({
	   type: "post",
		async:false,
	   url: "/ComboxService/getComboxs.do",
	   data: {codetablename:'COD_TAXEMPCODE'},
	   dataType: "json",
	   success: function(jsondata){
		  empdata= jsondata;
	   }
	});
	$.ajax({
	   type: "post",
		async:false,
	   url: "/ComboxService/getComboxs.do",
	   data: {codetablename:'COD_TAXORGCODE'},
	   dataType: "json",
	   success: function(jsondata){
		  orgdata= jsondata;
	   }
	});
	
	$('#econaturecode').combobox({   
		data:econaturedata,   
		valueField:'key',   
		textField:'value'  
	});
	$('#belongtocountrycode').combobox({   
		data:belongtocountrydata,   
		valueField:'key',   
		textField:'value'  
	});
	
	
	/*$('#querytypegrid').datagrid({
			fitColumns:'true',
			width:200,
			height:450,
			nowrap: true,
			autoRowHeight: false,
			striped: true,
			collapsible:true,
			singleSelect:'true',
			pagination:true,
			rownumbers:true,
			url:'querytype.json',
			columns:[[
				{field:'querytype',title:'',width:120,align:'center',hidden:'true'},
				{title:'a',width:120,checkbox:'true',align:'center'},
				{field:'querytypename',title:'统计类型',width:140,align:'center'}
			]],
			onClickRow:function(index,row){
				
			},
			onLoadSuccess: function(data){
				
			},
			onClickCell: function (rowIndex, field, value) {
				
			},
			onSelect:function (rowIndex, rowData){
				
				}
			}
	});*/
	$('#tab').tabs({
		onSelect:function(title,index){
			var tab = $('#tab').tabs('getSelected');
			if(tab.panel('options').title=='土地使用税'){
				taxtypecode='12';
				tabid = 'tax12grid';
				//query();
			}
			if(tab.panel('options').title=='房产税'){
				taxtypecode='10';
				tabid = 'tax10grid';
				//query();
			}
			if(tab.panel('options').title=='耕地占用税'){
				taxtypecode='20';
				tabid = 'tax20grid';
				//query();
			}
			if(tab.panel('options').title=='契税'){
				taxtypecode='21';
				tabid = 'tax21grid';
				//query();
			}
			if(tab.panel('options').title=='印花税'){
				taxtypecode='11';
				tabid = 'tax11grid';
				//query();
			}
		}
	});
	$('#tax12grid').datagrid({
			fitColumns:'true',
			nowrap: true,
			autoRowHeight: false,
			striped: true,
			collapsible:true,
			singleSelect:'true',
			pagination:true,
			rownumbers:true,
			toolbar:[{
					text:'导出',
					iconCls:'icon-export',
					handler:function(){
						$.messager.confirm('提示', '是否确认导出?', function(r){
							if (r){
								var param='';
								var fields =$('#queryform').serializeArray();
								$.each( fields, function(i, field){
									if(field.value!= ''){
										param=param+field.name+'='+field.value+'&';
									}
								});
								param=param+'taxtypecode='+taxtypecode+'&';
								window.open("/TaxsourceCountServlet/export.do?+'"+param+"'", '',
						           'top=1000,left=2500,width=1,height=1,toolbar=no,menubar=no,location=no');
							}
						});
					}
				}]
	});
	$('#tax10grid').datagrid({
			fitColumns:'true',
			nowrap: true,
			autoRowHeight: false,
			striped: true,
			collapsible:true,
			singleSelect:'true',
			pagination:true,
			rownumbers:true,
			toolbar:[{
				text:'导出',
				iconCls:'icon-export',
				handler:function(){
					$.messager.confirm('提示', '是否确认导出?', function(r){
							if (r){
								var param='';
								var fields =$('#queryform').serializeArray();
								$.each( fields, function(i, field){
									if(field.value!= ''){
										param=param+field.name+'='+field.value+'&';
									}
								});
								param=param+'taxtypecode='+taxtypecode+'&';
								window.open("/TaxsourceCountServlet/export.do?+'"+param+"'", '',
						           'top=1000,left=2500,width=1,height=1,toolbar=no,menubar=no,location=no');
							}
						});
				}
			}]
	});
	$('#tax11grid').datagrid({
			fitColumns:'true',
			nowrap: true,
			autoRowHeight: false,
			striped: true,
			collapsible:true,
			singleSelect:'true',
			pagination:true,
			rownumbers:true,
			toolbar:[{
				text:'导出',
				iconCls:'icon-export',
				handler:function(){
					$.messager.confirm('提示', '是否确认导出?', function(r){
							if (r){
								var param='';
								var fields =$('#queryform').serializeArray();
								$.each( fields, function(i, field){
									if(field.value!= ''){
										param=param+field.name+'='+field.value+'&';
									}
								});
								param=param+'taxtypecode='+taxtypecode+'&';
								window.open("/TaxsourceCountServlet/export.do?+'"+param+"'", '',
						           'top=1000,left=2500,width=1,height=1,toolbar=no,menubar=no,location=no');
							}
						});
				}
			}]
	});
	$('#tax20grid').datagrid({
			fitColumns:'true',
			nowrap: true,
			autoRowHeight: false,
			striped: true,
			collapsible:true,
			singleSelect:'true',
			pagination:true,
			rownumbers:true,
			toolbar:[{
				text:'导出',
				iconCls:'icon-export',
				handler:function(){
					$.messager.confirm('提示', '是否确认导出?', function(r){
							if (r){
								var param='';
								var fields =$('#queryform').serializeArray();
								$.each( fields, function(i, field){
									if(field.value!= ''){
										param=param+field.name+'='+field.value+'&';
									}
								});
								param=param+'taxtypecode='+taxtypecode+'&';
								window.open("/TaxsourceCountServlet/export.do?+'"+param+"'", '',
						           'top=1000,left=2500,width=1,height=1,toolbar=no,menubar=no,location=no');
							}
						});
				}
			}]
	});
	$('#tax21grid').datagrid({
			fitColumns:'true',
			nowrap: true,
			autoRowHeight: false,
			striped: true,
			collapsible:true,
			singleSelect:'true',
			pagination:true,
			rownumbers:true,
			toolbar:[{
				text:'导出',
				iconCls:'icon-export',
				handler:function(){
					$.messager.confirm('提示', '是否确认导出?', function(r){
							if (r){
								var param='';
								var fields =$('#queryform').serializeArray();
								$.each( fields, function(i, field){
									if(field.value!= ''){
										param=param+field.name+'='+field.value+'&';
									}
								});
								param=param+'taxtypecode='+taxtypecode+'&';
								window.open("/TaxsourceCountServlet/export.do?+'"+param+"'", '',
						           'top=1000,left=2500,width=1,height=1,toolbar=no,menubar=no,location=no');
							}
						});
				}
			}]
	});
	var p = $('#tax12grid').datagrid('getPager');
	$(p).pagination({
		showPageList:false,
		pageSize: 15
	});
	var p = $('#tax10grid').datagrid('getPager');
	$(p).pagination({
		showPageList:false,
		pageSize: 15
	});
	var p = $('#tax11grid').datagrid('getPager');
	$(p).pagination({
		showPageList:false,
		pageSize: 15
	});
	var p = $('#tax20grid').datagrid('getPager');
	$(p).pagination({
		showPageList:false,
		pageSize: 15
	});
	var p = $('#tax21grid').datagrid('getPager');
	$(p).pagination({
		showPageList:false,
		pageSize: 15
	});
});

function query(){
	$("#"+tabid).datagrid('loadData',{total:0,rows:[]});
	var params = {};
	var fields =$('#queryform').serializeArray();
	$.each( fields, function(i, field){
		params[field.name] = field.value;
	}); 
	params.taxtypecode=taxtypecode;
	//alert($.toJSON(params));
	var opts = $("#"+tabid).datagrid('options');
	opts.url = '/TaxsourceCountServlet/gettaxsource.do';
	$("#"+tabid).datagrid('load',params); 
	var p = $("#"+tabid).datagrid('getPager');  
	$(p).pagination({
		showPageList:false,
		pageSize: 15
	});
	$('#taxsourcequerywindow').window('close');
	
}
function formatorg(value,row,index){
	for(var i=0; i<taxorgdata.length; i++){
		if (taxorgdata[i].key == value) return taxorgdata[i].value;
	}
	return value;
}
function formatemp(value,row,index){
	for(var i=0; i<taxempdata.length; i++){
		if (taxempdata[i].key == value) return taxempdata[i].value;
	}
	return value;
}
function formattax(value,row,index){
	for(var i=0; i<taxdata.length; i++){
		if (taxdata[i].key == value) return taxdata[i].value;
	}
	return value;
}
function formatbelongtocountry(value,row,index){
	for(var i=0; i<belongtocountrydata.length; i++){
		if (belongtocountrydata[i].key == value) return belongtocountrydata[i].value;
	}
	return value;
}
function formateconature(value,row,index){
	for(var i=0; i<econaturedata.length; i++){
		if (econaturedata[i].key == value) return econaturedata[i].value;
	}
	return value;
}

/**/

function openquerywindow(){
	$('#taxsourcequerywindow').window('open');
}
</script>
</head>
<body class="easyui-layout">
		<div data-options="region:'north'" style="height:25px;width:100%;overflow: visible" >
			<div style="height:25px;">
				<a  class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="openquerywindow()">查询</a>
			</div>
		</div>
		<!-- <div data-options="region:'west',split:false" title="" style="width:220px;padding1:1px;overflow:auto" data-options="selected:true">
			<div class="easyui-accordion" data-options="fit:true,border:false" style="width:400px;height:500px;">
				<div title="统计类型" style="overflow:auto;">
					<table id="querytypegrid"> 
					</table>
				</div>
			</div>
		</div> -->
		<div data-options="region:'center'" title="" style="overflow:visible;">
			<div id="tab" class="easyui-tabs" style="height:auto;width:auto">
				<div title="土地使用税" closable="false" data-options="
							tools:[{
								handler:function(){
									$('#tax12grid').datagrid('reload');
								}
							}]">
					<table id="tax12grid" style="height:470px"
					data-options="iconCls:'icon-edit',singleSelect:true" rownumbers="true"> 
						<thead>
							<tr>
								<th data-options="field:'taxdeptcode',width:60,align:'left',formatter:formatorg,editor:{type:'text',required:true}">主管地税部门</th>
								<th data-options="field:'taxvalue',width:100,align:'right',formatter:formatnumber,editor:{type:'text',required:true}">土地面积</th>
								<th data-options="field:'taxtypecode',width:100,align:'left',formatter:function(value,row,index){
										for(var i=0; i<taxdata.length; i++){
											if (taxdata[i].key == value) return taxdata[i].value;
										}
										return value;
									},editor:{type:'text',required:true}">税种</th>
								<th data-options="field:'taxcode',width:100,align:'left',formatter:function(value,row,index){
										for(var i=0; i<taxdata.length; i++){
											if (taxdata[i].key == value) return taxdata[i].value;
										}
										return value;
									},editor:{type:'text',required:true}">税目</th>
								<th data-options="field:'year',width:80,align:'center',editor:{type:'text',required:true}">税款所属年度</th>
								<th data-options="field:'taxamount',width:60,align:'right',formatter:formatnumber,editor:{type:'text',required:true}">应缴税款</th>
								<th data-options="field:'taxderateamount',width:60,align:'right',formatter:formatnumber,editor:{type:'text',required:true}">减免税款</th>
								<th data-options="field:'taxamountactual',width:60,align:'right',formatter:formatnumber,editor:{type:'text',required:true}">已缴税款</th>
							</tr>
						</thead>
					</table>
				</div>
				<div title="房产税" closable="false" data-options="
							tools:[{
								handler:function(){
									$('#tax10grid').datagrid('reload');
								}
							}]">
					<table id="tax10grid" style="height:470px"
					data-options="iconCls:'icon-edit',singleSelect:true" rownumbers="true"> 
						<thead>
							<tr>
								<th data-options="field:'taxdeptcode',width:60,align:'left',formatter:formatorg,editor:{type:'text',required:true}">主管地税部门</th>
								<th data-options="field:'taxvalue',width:100,align:'right',formatter:formatnumber,editor:{type:'text',required:true}">计税房产原值</th>
								<th data-options="field:'taxtypecode',width:100,align:'left',formatter:function(value,row,index){
										for(var i=0; i<taxdata.length; i++){
											if (taxdata[i].key == value) return taxdata[i].value;
										}
										return value;
									},editor:{type:'text',required:true}">税种</th>
								<th data-options="field:'taxcode',width:100,align:'left',formatter:function(value,row,index){
										for(var i=0; i<taxdata.length; i++){
											if (taxdata[i].key == value) return taxdata[i].value;
										}
										return value;
									},editor:{type:'text',required:true}">税目</th>
								<th data-options="field:'year',width:80,align:'center',editor:{type:'text',required:true}">税款所属年度</th>
								<th data-options="field:'taxamount',width:60,align:'right',formatter:formatnumber,editor:{type:'text',required:true}">应缴税款</th>
								<th data-options="field:'taxderateamount',width:60,align:'right',formatter:formatnumber,editor:{type:'text',required:true}">减免税款</th>
								<th data-options="field:'taxamountactual',width:60,align:'right',formatter:formatnumber,editor:{type:'text',required:true}">已缴税款</th>
							</tr>
						</thead>
					</table>
				</div>
				<div title="耕地占用税" closable="false" data-options="
							tools:[{
								handler:function(){
									$('#tax20grid').datagrid('reload');
								}
							}]">
					<table id="tax20grid" style="height:470px"
					data-options="iconCls:'icon-edit',singleSelect:true" rownumbers="true"> 
						<thead>
							<tr>
								<th data-options="field:'taxdeptcode',width:60,align:'left',formatter:formatorg,editor:{type:'text',required:true}">主管地税部门</th>
								<th data-options="field:'taxvalue',width:100,align:'right',formatter:formatnumber,editor:{type:'text',required:true}">农用地面积</th>
								<th data-options="field:'taxtypecode',width:100,align:'left',formatter:function(value,row,index){
										for(var i=0; i<taxdata.length; i++){
											if (taxdata[i].key == value) return taxdata[i].value;
										}
										return value;
									},editor:{type:'text',required:true}">税种</th>
								<th data-options="field:'taxcode',width:100,align:'left',formatter:function(value,row,index){
										for(var i=0; i<taxdata.length; i++){
											if (taxdata[i].key == value) return taxdata[i].value;
										}
										return value;
									},editor:{type:'text',required:true}">税目</th>
								<th data-options="field:'year',width:80,align:'center',editor:{type:'text',required:true}">税款所属年度</th>
								<th data-options="field:'taxamount',width:60,align:'right',formatter:formatnumber,editor:{type:'text',required:true}">应缴税款</th>
								<th data-options="field:'taxderateamount',width:60,align:'right',formatter:formatnumber,editor:{type:'text',required:true}">减免税款</th>
								<th data-options="field:'taxamountactual',width:60,align:'right',formatter:formatnumber,editor:{type:'text',required:true}">已缴税款</th>
							</tr>
						</thead>
					</table>
				</div>
				<div title="契税" closable="false" data-options="
							tools:[{
								handler:function(){
									$('#tax21grid').datagrid('reload');
								}
							}]">
					<table id="tax21grid" style="height:470px"
					data-options="iconCls:'icon-edit',singleSelect:true" rownumbers="true"> 
						<thead>
							<tr>
								<th data-options="field:'taxdeptcode',width:60,align:'left',formatter:formatorg,editor:{type:'text',required:true}">主管地税部门</th>
								<th data-options="field:'taxvalue',width:100,align:'right',formatter:formatnumber,editor:{type:'text',required:true}">交易金额</th>
								<th data-options="field:'taxtypecode',width:100,align:'left',formatter:function(value,row,index){
										for(var i=0; i<taxdata.length; i++){
											if (taxdata[i].key == value) return taxdata[i].value;
										}
										return value;
									},editor:{type:'text',required:true}">税种</th>
								<th data-options="field:'taxcode',width:100,align:'left',formatter:function(value,row,index){
										for(var i=0; i<taxdata.length; i++){
											if (taxdata[i].key == value) return taxdata[i].value;
										}
										return value;
									},editor:{type:'text',required:true}">税目</th>
								<th data-options="field:'year',width:80,align:'center',editor:{type:'text',required:true}">税款所属年度</th>
								<th data-options="field:'taxamount',width:60,align:'right',formatter:formatnumber,editor:{type:'text',required:true}">应缴税款</th>
								<th data-options="field:'taxderateamount',width:60,align:'right',formatter:formatnumber,editor:{type:'text',required:true}">减免税款</th>
								<th data-options="field:'taxamountactual',width:60,align:'right',formatter:formatnumber,editor:{type:'text',required:true}">已缴税款</th>
							</tr>
						</thead>
					</table>
				</div>
				<div title="印花税" closable="false" data-options="
							tools:[{
								handler:function(){
									$('#tax11grid').datagrid('reload');
								}
							}]">
					<table id="tax11grid" style="height:470px"
					data-options="iconCls:'icon-edit',singleSelect:true" rownumbers="true"> 
						<thead>
							<tr>
								<th data-options="field:'taxdeptcode',width:60,align:'left',formatter:formatorg,editor:{type:'text',required:true}">主管地税部门</th>
								<th data-options="field:'taxvalue',width:100,align:'right',formatter:formatnumber,editor:{type:'text',required:true}">交易金额</th>
								<th data-options="field:'taxtypecode',width:100,align:'left',formatter:function(value,row,index){
										for(var i=0; i<taxdata.length; i++){
											if (taxdata[i].key == value) return taxdata[i].value;
										}
										return value;
									},editor:{type:'text',required:true}">税种</th>
								<th data-options="field:'taxcode',width:100,align:'left',formatter:function(value,row,index){
										for(var i=0; i<taxdata.length; i++){
											if (taxdata[i].key == value) return taxdata[i].value;
										}
										return value;
									},editor:{type:'text',required:true}">税目</th>
								<th data-options="field:'year',width:80,align:'center',editor:{type:'text',required:true}">税款所属年度</th>
								<th data-options="field:'taxamount',width:60,align:'right',formatter:formatnumber,editor:{type:'text',required:true}">应缴税款</th>
								<th data-options="field:'taxderateamount',width:60,align:'right',formatter:formatnumber,editor:{type:'text',required:true}">减免税款</th>
								<th data-options="field:'taxamountactual',width:60,align:'right',formatter:formatnumber,editor:{type:'text',required:true}">已缴税款</th>
							</tr>
						</thead>
					</table>
				</div>
				
			</div>
		</div>
	<div id="taxsourcequerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'税源信息查询',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:300px;">
		<div class="easyui-panel" title="" style="width:900px;">
			<form id="queryform" method="post">
				<table id="narjcxx" class="table table-bordered">
					<tr>
						<td align="right">州市地税机关：</td>
						<td>
							<input class="easyui-combobox" name="taxorgsupcode" id="taxorgsupcode" style="width:250px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">县区地税机关：</td>
						<td>
							<input class="easyui-combobox" name="taxorgcode" id="taxorgcode" style="width:250px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						
					</tr>
					<tr>
						<td align="right">主管地税部门：</td>
						<td>
							<input class="easyui-combobox" name="taxdeptcode" id="taxdeptcode" style="width:250px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">税收管理员：</td>
						<td>
							<input class="easyui-combobox" name="taxmanagercode" id="taxmanagercode" style="width:250px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						
					</tr>
					<tr>
						<td align="right">计算机编码：</td>
						<td>
							<input id="taxpayerid" class="easyui-validatebox" type="text" style="width:250px" name="taxpayerid" onkeydown="if(event.keyCode==13)spelltaxpayerid(this)"/>
						</td>
						<td align="right">纳税人名称：</td>
						<td>
							<input id="taxpayername" class="easyui-validatebox" type="text" style="width:250px" name="taxpayername"/>
						</td>
					</tr>
					<tr>
						<td align="right">所属乡镇：</td>
						<td>
							<input id="belongtocountrycode" name="belongtocountrycode" style="width:200px;" class="easyui-combobox" editable='false' data-options="
							valueField: 'key',
							textField: 'value',
							data:belongtocountrydata "/>
						</td>
						<td align="right">注册类型：</td>
						<td>
							<input id="econaturecode" name="econaturecode" style="width:200px;" class="easyui-combobox" editable='false' data-options="
							panelWidth:300,
							panelHeight:200,
							valueField: 'key',
							textField: 'value',
							data:econaturedata "/>
						</td>
					</tr>
					<tr>
						<td align="right">所属年度：</td>
						<td>
							<select id="year" class="easyui-combobox" name="year" style="width:200px;" data-options="required:true" editable="false">
								<option value="2011">2011</option>
								<option value="2012">2012</option>
								<option value="2013">2013</option>
								<option value="2014">2014</option>
								<option value="2015" selected="true">2015</option>
							</select>
						</td>
						<td align="right">统计类型：</td>
						<td>
							<select id="querytype" class="easyui-combobox" name="querytype" style="width:200px;" data-options="required:true,onChange:function(newValue, oldValue){
								if(newValue=='1'){
									$('#tax12grid').datagrid({
											fitColumns:'true',
											height:470,
											nowrap: true,
											autoRowHeight: false,
											striped: true,
											collapsible:true,
											singleSelect:'true',
											pagination:true,
											rownumbers:true,
											columns:[[
												{field:'taxdeptcode',title:'主管地税部门',formatter:formatorg,width:120,align:'left'},
												{field:'taxvalue',title:'土地面积',width:100,align:'right',formatter:formatnumber},
												{field:'taxtypecode',title:'税种',formatter:formattax,width:100,align:'left'},
												{field:'taxcode',title:'税目',formatter:formattax,width:100,align:'left'},
												{field:'year',title:'税款所属年度',width:80,align:'center'},
												{field:'taxamount',title:'应缴税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxderateamount',title:'减免税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxamountactual',title:'已缴税款',width:80,align:'right',formatter:formatnumber}
											]]
									});
									$('#tax10grid').datagrid({
											fitColumns:'true',
											height:470,
											nowrap: true,
											autoRowHeight: false,
											striped: true,
											collapsible:true,
											singleSelect:'true',
											pagination:true,
											rownumbers:true,
											columns:[[
												{field:'taxdeptcode',title:'主管地税部门',formatter:formatorg,width:120,align:'left'},
												{field:'taxvalue',title:'计税房产原值',width:100,align:'right',formatter:formatnumber},
												{field:'taxtypecode',title:'税种',formatter:formattax,width:100,align:'left'},
												{field:'taxcode',title:'税目',formatter:formattax,width:100,align:'left'},
												{field:'year',title:'税款所属年度',width:80,align:'center'},
												{field:'taxamount',title:'应缴税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxderateamount',title:'减免税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxamountactual',title:'已缴税款',width:80,align:'right',formatter:formatnumber}
											]]
									});
									$('#tax20grid').datagrid({
											fitColumns:'true',
											height:470,
											nowrap: true,
											autoRowHeight: false,
											striped: true,
											collapsible:true,
											singleSelect:'true',
											pagination:true,
											rownumbers:true,
											columns:[[
												{field:'taxdeptcode',title:'主管地税部门',formatter:formatorg,width:120,align:'left'},
												{field:'taxvalue',title:'农用地面积',width:100,align:'right',formatter:formatnumber},
												{field:'taxtypecode',title:'税种',formatter:formattax,width:100,align:'left'},
												{field:'taxcode',title:'税目',formatter:formattax,width:100,align:'left'},
												{field:'year',title:'税款所属年度',width:80,align:'center'},
												{field:'taxamount',title:'应缴税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxderateamount',title:'减免税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxamountactual',title:'已缴税款',width:80,align:'right',formatter:formatnumber}
											]]
									});
									$('#tax21grid').datagrid({
											fitColumns:'true',
											height:470,
											nowrap: true,
											autoRowHeight: false,
											striped: true,
											collapsible:true,
											singleSelect:'true',
											pagination:true,
											rownumbers:true,
											columns:[[
												{field:'taxdeptcode',title:'主管地税部门',formatter:formatorg,width:120,align:'left'},
												{field:'taxvalue',title:'交易金额',width:100,align:'right',formatter:formatnumber},
												{field:'taxtypecode',title:'税种',formatter:formattax,width:100,align:'left'},
												{field:'taxcode',title:'税目',formatter:formattax,width:100,align:'left'},
												{field:'year',title:'税款所属年度',width:80,align:'center'},
												{field:'taxamount',title:'应缴税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxderateamount',title:'减免税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxamountactual',title:'已缴税款',width:80,align:'right',formatter:formatnumber}
											]]
									});
									$('#tax11grid').datagrid({
											fitColumns:'true',
											height:470,
											nowrap: true,
											autoRowHeight: false,
											striped: true,
											collapsible:true,
											singleSelect:'true',
											pagination:true,
											rownumbers:true,
											columns:[[
												{field:'taxdeptcode',title:'主管地税部门',formatter:formatorg,width:120,align:'left'},
												{field:'taxvalue',title:'交易金额',width:100,align:'right',formatter:formatnumber},
												{field:'taxtypecode',title:'税种',formatter:formattax,width:100,align:'left'},
												{field:'taxcode',title:'税目',formatter:formattax,width:100,align:'left'},
												{field:'year',title:'税款所属年度',width:80,align:'center'},
												{field:'taxamount',title:'应缴税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxderateamount',title:'减免税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxamountactual',title:'已缴税款',width:80,align:'right',formatter:formatnumber}
											]]
									});
									var p = $('#tax12grid').datagrid('getPager');
									$(p).pagination({
										showPageList:false,
										pageSize: 15
									});
									var p = $('#tax10grid').datagrid('getPager');
									$(p).pagination({
										showPageList:false,
										pageSize: 15
									});
									var p = $('#tax11grid').datagrid('getPager');
									$(p).pagination({
										showPageList:false,
										pageSize: 15
									});
									var p = $('#tax20grid').datagrid('getPager');
									$(p).pagination({
										showPageList:false,
										pageSize: 15
									});
									var p = $('#tax21grid').datagrid('getPager');
									$(p).pagination({
										showPageList:false,
										pageSize: 15
									});
								}
								if(newValue=='2'){
									$('#tax12grid').datagrid({
											fitColumns:'true',
											height:470,
											nowrap: true,
											autoRowHeight: false,
											striped: true,
											collapsible:true,
											singleSelect:'true',
											pagination:true,
											rownumbers:true,
											columns:[[
												{field:'taxdeptcode',title:'主管地税部门',formatter:formatorg,width:120,align:'left'},
												{field:'taxmanagercode',title:'税收管理员',formatter:formatemp,width:100,align:'left'},
												{field:'taxvalue',title:'土地面积',width:100,align:'right',formatter:formatnumber},
												{field:'taxtypecode',title:'税种',formatter:formattax,width:100,align:'left'},
												{field:'taxcode',title:'税目',formatter:formattax,width:100,align:'left'},
												{field:'year',title:'税款所属年度',width:80,align:'center'},
												{field:'taxamount',title:'应缴税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxderateamount',title:'减免税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxamountactual',title:'已缴税款',width:80,align:'right',formatter:formatnumber}
											]]
									});
									$('#tax10grid').datagrid({
											fitColumns:'true',
											height:470,
											nowrap: true,
											autoRowHeight: false,
											striped: true,
											collapsible:true,
											singleSelect:'true',
											pagination:true,
											rownumbers:true,
											columns:[[
												{field:'taxdeptcode',title:'主管地税部门',formatter:formatorg,width:120,align:'left'},
												{field:'taxmanagercode',title:'税收管理员',formatter:formatemp,width:100,align:'left'},
												{field:'taxvalue',title:'计税房产原值',width:100,align:'right',formatter:formatnumber},
												{field:'taxtypecode',title:'税种',formatter:formattax,width:100,align:'left'},
												{field:'taxcode',title:'税目',formatter:formattax,width:100,align:'left'},
												{field:'year',title:'税款所属年度',width:80,align:'center'},
												{field:'taxamount',title:'应缴税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxderateamount',title:'减免税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxamountactual',title:'已缴税款',width:80,align:'right',formatter:formatnumber}
											]]
									});
									$('#tax20grid').datagrid({
											fitColumns:'true',
											height:470,
											nowrap: true,
											autoRowHeight: false,
											striped: true,
											collapsible:true,
											singleSelect:'true',
											pagination:true,
											rownumbers:true,
											columns:[[
												{field:'taxdeptcode',title:'主管地税部门',formatter:formatorg,width:120,align:'left'},
												{field:'taxmanagercode',title:'税收管理员',formatter:formatemp,width:100,align:'left'},
												{field:'taxvalue',title:'农用地面积',width:100,align:'right',formatter:formatnumber},
												{field:'taxtypecode',title:'税种',formatter:formattax,width:100,align:'left'},
												{field:'taxcode',title:'税目',formatter:formattax,width:100,align:'left'},
												{field:'year',title:'税款所属年度',width:80,align:'center'},
												{field:'taxamount',title:'应缴税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxderateamount',title:'减免税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxamountactual',title:'已缴税款',width:80,align:'right',formatter:formatnumber}
											]]
									});
									$('#tax21grid').datagrid({
											fitColumns:'true',
											height:470,
											nowrap: true,
											autoRowHeight: false,
											striped: true,
											collapsible:true,
											singleSelect:'true',
											pagination:true,
											rownumbers:true,
											columns:[[
												{field:'taxdeptcode',title:'主管地税部门',formatter:formatorg,width:120,align:'left'},
												{field:'taxmanagercode',title:'税收管理员',formatter:formatemp,width:100,align:'left'},
												{field:'taxvalue',title:'交易金额',width:100,align:'right',formatter:formatnumber},
												{field:'taxtypecode',title:'税种',formatter:formattax,width:100,align:'left'},
												{field:'taxcode',title:'税目',formatter:formattax,width:100,align:'left'},
												{field:'year',title:'税款所属年度',width:80,align:'center'},
												{field:'taxamount',title:'应缴税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxderateamount',title:'减免税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxamountactual',title:'已缴税款',width:80,align:'right',formatter:formatnumber}
											]]
									});
									$('#tax11grid').datagrid({
											fitColumns:'true',
											height:470,
											nowrap: true,
											autoRowHeight: false,
											striped: true,
											collapsible:true,
											singleSelect:'true',
											pagination:true,
											rownumbers:true,
											columns:[[
												{field:'taxdeptcode',title:'主管地税部门',formatter:formatorg,width:120,align:'left'},
												{field:'taxmanagercode',title:'税收管理员',formatter:formatemp,width:100,align:'left'},
												{field:'taxvalue',title:'交易金额',width:100,align:'right',formatter:formatnumber},
												{field:'taxtypecode',title:'税种',formatter:formattax,width:100,align:'left'},
												{field:'taxcode',title:'税目',formatter:formattax,width:100,align:'left'},
												{field:'year',title:'税款所属年度',width:80,align:'center'},
												{field:'taxamount',title:'应缴税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxderateamount',title:'减免税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxamountactual',title:'已缴税款',width:80,align:'right',formatter:formatnumber}
											]]
									});
									var p = $('#tax12grid').datagrid('getPager');
									$(p).pagination({
										showPageList:false,
										pageSize: 15
									});
									var p = $('#tax10grid').datagrid('getPager');
									$(p).pagination({
										showPageList:false,
										pageSize: 15
									});
									var p = $('#tax11grid').datagrid('getPager');
									$(p).pagination({
										showPageList:false,
										pageSize: 15
									});
									var p = $('#tax20grid').datagrid('getPager');
									$(p).pagination({
										showPageList:false,
										pageSize: 15
									});
									var p = $('#tax21grid').datagrid('getPager');
									$(p).pagination({
										showPageList:false,
										pageSize: 15
									});
								}
								if(newValue=='3'){
									$('#tax12grid').datagrid({
											fitColumns:'true',
											height:470,
											nowrap: true,
											autoRowHeight: false,
											striped: true,
											collapsible:true,
											singleSelect:'true',
											pagination:true,
											rownumbers:true,
											columns:[[
												{field:'belongtocountrycode',title:'所属乡镇',formatter:formatbelongtocountry,width:120,align:'left'},
												{field:'taxvalue',title:'土地面积',width:100,align:'right',formatter:formatnumber},
												{field:'taxtypecode',title:'税种',formatter:formattax,width:100,align:'left'},
												{field:'taxcode',title:'税目',formatter:formattax,width:100,align:'left'},
												{field:'year',title:'税款所属年度',width:80,align:'center'},
												{field:'taxamount',title:'应缴税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxderateamount',title:'减免税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxamountactual',title:'已缴税款',width:80,align:'right',formatter:formatnumber}
											]]
									});
									$('#tax10grid').datagrid({
											fitColumns:'true',
											height:470,
											nowrap: true,
											autoRowHeight: false,
											striped: true,
											collapsible:true,
											singleSelect:'true',
											pagination:true,
											rownumbers:true,
											columns:[[
												{field:'belongtocountrycode',title:'所属乡镇',formatter:formatbelongtocountry,width:120,align:'left'},
												{field:'taxvalue',title:'计税房产原值',width:100,align:'right',formatter:formatnumber},
												{field:'taxtypecode',title:'税种',formatter:formattax,width:100,align:'left'},
												{field:'taxcode',title:'税目',formatter:formattax,width:100,align:'left'},
												{field:'year',title:'税款所属年度',width:80,align:'center'},
												{field:'taxamount',title:'应缴税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxderateamount',title:'减免税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxamountactual',title:'已缴税款',width:80,align:'right',formatter:formatnumber}
											]]
									});
									$('#tax20grid').datagrid({
											fitColumns:'true',
											height:470,
											nowrap: true,
											autoRowHeight: false,
											striped: true,
											collapsible:true,
											singleSelect:'true',
											pagination:true,
											rownumbers:true,
											columns:[[
												{field:'belongtocountrycode',title:'所属乡镇',formatter:formatbelongtocountry,width:120,align:'left'},
												{field:'taxvalue',title:'农用地面积',width:100,align:'right',formatter:formatnumber},
												{field:'taxtypecode',title:'税种',formatter:formattax,width:100,align:'left'},
												{field:'taxcode',title:'税目',formatter:formattax,width:100,align:'left'},
												{field:'year',title:'税款所属年度',width:80,align:'center'},
												{field:'taxamount',title:'应缴税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxderateamount',title:'减免税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxamountactual',title:'已缴税款',width:80,align:'right',formatter:formatnumber}
											]]
									});
									$('#tax21grid').datagrid({
											fitColumns:'true',
											height:470,
											nowrap: true,
											autoRowHeight: false,
											striped: true,
											collapsible:true,
											singleSelect:'true',
											pagination:true,
											rownumbers:true,
											columns:[[
												{field:'belongtocountrycode',title:'所属乡镇',formatter:formatbelongtocountry,width:120,align:'left'},
												{field:'taxvalue',title:'交易金额',width:100,align:'right',formatter:formatnumber},
												{field:'taxtypecode',title:'税种',formatter:formattax,width:100,align:'left'},
												{field:'taxcode',title:'税目',formatter:formattax,width:100,align:'left'},
												{field:'year',title:'税款所属年度',width:80,align:'center'},
												{field:'taxamount',title:'应缴税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxderateamount',title:'减免税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxamountactual',title:'已缴税款',width:80,align:'right',formatter:formatnumber}
											]]
									});
									$('#tax11grid').datagrid({
											fitColumns:'true',
											height:470,
											nowrap: true,
											autoRowHeight: false,
											striped: true,
											collapsible:true,
											singleSelect:'true',
											pagination:true,
											rownumbers:true,
											columns:[[
												{field:'belongtocountrycode',title:'所属乡镇',formatter:formatbelongtocountry,width:120,align:'left'},
												{field:'taxvalue',title:'交易金额',width:100,align:'right',formatter:formatnumber},
												{field:'taxtypecode',title:'税种',formatter:formattax,width:100,align:'left'},
												{field:'taxcode',title:'税目',formatter:formattax,width:100,align:'left'},
												{field:'year',title:'税款所属年度',width:80,align:'center'},
												{field:'taxamount',title:'应缴税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxderateamount',title:'减免税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxamountactual',title:'已缴税款',width:80,align:'right',formatter:formatnumber}
											]]
									});
									var p = $('#tax12grid').datagrid('getPager');
									$(p).pagination({
										showPageList:false,
										pageSize: 15
									});
									var p = $('#tax10grid').datagrid('getPager');
									$(p).pagination({
										showPageList:false,
										pageSize: 15
									});
									var p = $('#tax11grid').datagrid('getPager');
									$(p).pagination({
										showPageList:false,
										pageSize: 15
									});
									var p = $('#tax20grid').datagrid('getPager');
									$(p).pagination({
										showPageList:false,
										pageSize: 15
									});
									var p = $('#tax21grid').datagrid('getPager');
									$(p).pagination({
										showPageList:false,
										pageSize: 15
									});
								}
								if(newValue=='4'){
									$('#tax12grid').datagrid({
											fitColumns:'true',
											height:470,
											nowrap: true,
											autoRowHeight: false,
											striped: true,
											collapsible:true,
											singleSelect:'true',
											pagination:true,
											rownumbers:true,
											columns:[[
												{field:'econaturecode',title:'注册类型',formatter:formateconature,width:120,align:'left'},
												{field:'taxvalue',title:'土地面积',width:100,align:'right',formatter:formatnumber},
												{field:'taxtypecode',title:'税种',formatter:formattax,width:100,align:'left'},
												{field:'taxcode',title:'税目',formatter:formattax,width:100,align:'left'},
												{field:'year',title:'税款所属年度',width:80,align:'center'},
												{field:'taxamount',title:'应缴税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxderateamount',title:'减免税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxamountactual',title:'已缴税款',width:80,align:'right',formatter:formatnumber}
											]]
									});
									$('#tax10grid').datagrid({
											fitColumns:'true',
											height:470,
											nowrap: true,
											autoRowHeight: false,
											striped: true,
											collapsible:true,
											singleSelect:'true',
											pagination:true,
											rownumbers:true,
											columns:[[
												{field:'econaturecode',title:'注册类型',formatter:formateconature,width:120,align:'left'},
												{field:'taxvalue',title:'计税房产原值',width:100,align:'right',formatter:formatnumber},
												{field:'taxtypecode',title:'税种',formatter:formattax,width:100,align:'left'},
												{field:'taxcode',title:'税目',formatter:formattax,width:100,align:'left'},
												{field:'year',title:'税款所属年度',width:80,align:'center'},
												{field:'taxamount',title:'应缴税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxderateamount',title:'减免税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxamountactual',title:'已缴税款',width:80,align:'right',formatter:formatnumber}
											]]
									});
									$('#tax20grid').datagrid({
											fitColumns:'true',
											height:470,
											nowrap: true,
											autoRowHeight: false,
											striped: true,
											collapsible:true,
											singleSelect:'true',
											pagination:true,
											rownumbers:true,
											columns:[[
												{field:'econaturecode',title:'注册类型',formatter:formateconature,width:120,align:'left'},
												{field:'taxvalue',title:'农用地面积',width:100,align:'right',formatter:formatnumber},
												{field:'taxtypecode',title:'税种',formatter:formattax,width:100,align:'left'},
												{field:'taxcode',title:'税目',formatter:formattax,width:100,align:'left'},
												{field:'year',title:'税款所属年度',width:80,align:'center'},
												{field:'taxamount',title:'应缴税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxderateamount',title:'减免税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxamountactual',title:'已缴税款',width:80,align:'right',formatter:formatnumber}
											]]
									});
									$('#tax21grid').datagrid({
											fitColumns:'true',
											height:470,
											nowrap: true,
											autoRowHeight: false,
											striped: true,
											collapsible:true,
											singleSelect:'true',
											pagination:true,
											rownumbers:true,
											columns:[[
												{field:'econaturecode',title:'注册类型',formatter:formateconature,width:120,align:'left'},
												{field:'taxvalue',title:'交易金额',width:100,align:'right',formatter:formatnumber},
												{field:'taxtypecode',title:'税种',formatter:formattax,width:100,align:'left'},
												{field:'taxcode',title:'税目',formatter:formattax,width:100,align:'left'},
												{field:'year',title:'税款所属年度',width:80,align:'center'},
												{field:'taxamount',title:'应缴税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxderateamount',title:'减免税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxamountactual',title:'已缴税款',width:80,align:'right',formatter:formatnumber}
											]]
									});
									$('#tax11grid').datagrid({
											fitColumns:'true',
											height:470,
											nowrap: true,
											autoRowHeight: false,
											striped: true,
											collapsible:true,
											singleSelect:'true',
											pagination:true,
											rownumbers:true,
											columns:[[
												{field:'econaturecode',title:'注册类型',formatter:formateconature,width:120,align:'left'},
												{field:'taxvalue',title:'交易金额',width:100,align:'center'},
												{field:'taxtypecode',title:'税种',formatter:formattax,width:100,align:'left'},
												{field:'taxcode',title:'税目',formatter:formattax,width:100,align:'left'},
												{field:'year',title:'税款所属年度',width:80,align:'center'},
												{field:'taxamount',title:'应缴税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxderateamount',title:'减免税款',width:80,align:'right',formatter:formatnumber},
												{field:'taxamountactual',title:'已缴税款',width:80,align:'right',formatter:formatnumber}
											]]
									});
									var p = $('#tax12grid').datagrid('getPager');
									$(p).pagination({
										showPageList:false,
										pageSize: 15
									});
									var p = $('#tax10grid').datagrid('getPager');
									$(p).pagination({
										showPageList:false,
										pageSize: 15
									});
									var p = $('#tax11grid').datagrid('getPager');
									$(p).pagination({
										showPageList:false,
										pageSize: 15
									});
									var p = $('#tax20grid').datagrid('getPager');
									$(p).pagination({
										showPageList:false,
										pageSize: 15
									});
									var p = $('#tax21grid').datagrid('getPager');
									$(p).pagination({
										showPageList:false,
										pageSize: 15
									});
								}
							}" editable="false">
								<option value="1" selected="true">按主管地税部门</option>
								<option value="2">按税收管理员</option>
								<option value="3">按所属乡镇</option>
								<option value="4" >按注册类型</option>
							</select>
						</td>
					</tr>
				</table>
			</form>
			<div style="text-align:center;padding:1px;">  
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="query()">查询</a>
			</div>
		</div>
	</div>
</body>

</html>
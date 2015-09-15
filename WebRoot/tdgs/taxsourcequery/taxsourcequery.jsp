<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<%@ include file="/common/inc.jsp"%>
<html>
<head>

<title>Complex Layout - jQuery EasyUI Demo</title>

<link rel="stylesheet" href="<%=spath%>/themes/sunny/easyui.css">
<link rel="stylesheet" href="<%=spath%>/themes/icon.css">
<link rel="stylesheet" href="<%=spath%>/css/toolbar.css">
<link rel="stylesheet" href="<%=spath%>/css/logout.css"/>
<link rel="stylesheet" href="<%=spath%>/css/tablen.css"/>
<script src="<%=spath%>/js/jquery-1.8.2.min.js"></script>
<script src="<%=spath%>/js/jquery.easyui.min.js"></script>
<script src="<%=spath%>/js/tiles.js"></script>
<script src="<%=spath%>/js/moduleWindow.js"></script>
<script src="<%=spath%>/menus.js"></script>

<script src="<%=spath%>/js/jquery.simplemodal.js"></script>
<script src="<%=spath%>/js/overlay.js"></script>
<script src="<%=spath%>/js/jquery.json-2.2.js"></script>
<script src="<%=spath%>/js/json2.js"></script>
<script src="<%=spath%>/locale/easyui-lang-zh_CN.js"></script>

<script src="<%=spath%>/js/common.js"></script>

<script>
var belongtocountrydata = new Array();
var econaturedata;
var taxdata;
var taxorgcode='<%=com.szgr.framework.authority.datarights.SystemUserAccessor.getInstance().getTaxorgcode()%>'.substring(0,6);
var taxtypecode = '12';
var tabid = 'tax12grid';
$(function(){
	$.ajax({
		type: "post",
		async:false,
		url: "/ComboxService/getComboxs.do",
		data: {codetablename:'COD_BELONGTOCOUNTRYCODE'},
		dataType: "json",
		success: function(jsondata){
			for (var i = 0; i < jsondata.length; i++){
				if(jsondata[i].key.substring(0,6)=='530122'){
				var data = {}; 
				data.key=jsondata[i].key;
				data.value=jsondata[i].value;
				belongtocountrydata.push(data);
			  }
		  }
	   }
	});
	$.ajax({
	   type: "post",
		async:false,
	   url: "/ComboxService/getComboxs.do",
	   data: {codetablename:'COD_ECONATURECODE'},
	   dataType: "json",
	   success: function(jsondata){
		  econaturedata= jsondata;
	   }
	});
	$.ajax({
	   type: "post",
		async:false,
	   url: "/ComboxService/getComboxs.do",
	   data: {codetablename:'COD_TAXCODE'},
	   dataType: "json",
	   success: function(jsondata){
		  taxdata= jsondata;
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
	var regex = new RegExp("\"","g");  
		$.ajax({
			   type: "get",
			   url: "/soption/taxOrgOptionInit.do",
			   data: {"moduleAuth":"15","emptype":"30"},
			   dataType: "json",
			   success: function(jsondata){
				   $('#taxorgsupcode').combobox({
						data : jsondata.taxSupOrgOptionJsonArray,
                        valueField:'key',
                        textField:'keyvalue',
						onSelect:function(n,o){  	
							//$.messager.alert('返回消息',n.key);
							$.ajax({
								   type: "get",
								   url: "/soption/taxOrgOptionBySup.do",
								   data: {"taxSuperOrgCode":n.key},
								   dataType: "json",
								   success: function(jsondata){
										//$.messager.alert('返回消息',JSON.stringify(jsondata));
									   $('#taxorgcode').combobox({
											data : jsondata.taxOrgOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});
									   $('#taxdeptcode').combobox({
											data : jsondata.taxDeptOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});		
									   $('#taxmanagercode').combobox({
											data : jsondata.taxEmpOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});											
										//$('#taxdeptcode').combobox("clear");
										//$('#taxempcode').combobox("clear");

										//$('#taxdeptcode').combobox({}).combobox('clear');
								   }
							});
						} 
					});
					if(jsondata.taxSupOrgOptionJsonArray.length == 1){
						//$.messager.alert('返回消息',JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
						$('#taxorgsupcode').combobox("setValue",JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key).replace(regex, ""));
						$('#taxorgsupcode').combobox("setText",JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].keyvalue).replace(regex, ""));
					}


				   $('#taxorgcode').combobox({
						data : jsondata.taxOrgOptionJsonArray,
                        valueField:'key',
                        textField:'keyvalue',
						onSelect:function(n,o){  	
							$.ajax({
								   type: "get",
								   url: "/soption/taxDeptOptionByOrg.do",
								   data: {"taxOrgCode":n.key},
								   dataType: "json",
								   success: function(jsondata){
									   $('#taxdeptcode').combobox({
											data : jsondata.taxDeptOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});		
									   $('#taxmanagercode').combobox({
											data : jsondata.taxEmpOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});											
										//$('#taxdeptcode').combobox("clear");
										//$('#taxempcode').combobox("clear");

										//$('#taxdeptcode').combobox({}).combobox('clear');
								   }
							});
						} 
					});
					if(jsondata.taxOrgOptionJsonArray.length == 1){
						//$.messager.alert('返回消息',jsondata.taxOrgOptionJsonArray[0].keyvalue);
						$('#taxorgcode').combobox("setValue",JSON.stringify(jsondata.taxOrgOptionJsonArray[0].key).replace(regex, ""));
						$('#taxorgcode').combobox("setText",JSON.stringify(jsondata.taxOrgOptionJsonArray[0].keyvalue).replace(regex, ""));
					}

				   $('#taxdeptcode').combobox({
						data : jsondata.taxDeptOptionJsonArray,
                        valueField:'key',
                        textField:'keyvalue',
						onSelect:function(n,o){  	
							$.ajax({
								   type: "get",
								   url: "/soption/getTaxEmpByOrgCode.do",
								   data: {"taxDeptCode":n.key,"emptype":"30"},
								   dataType: "json",
								   success: function(jsondata){	
									   $('#taxmanagercode').combobox({
											data : jsondata.taxEmpOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});
								   }
							});
						} 
					});
					if(jsondata.taxDeptOptionJsonArray.length == 1){
						//$.messager.alert('返回消息',JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
						$('#taxdeptcode').combobox("setValue",JSON.stringify(jsondata.taxDeptOptionJsonArray[0].key).replace(regex, ""));
						$('#taxdeptcode').combobox("setText",JSON.stringify(jsondata.taxDeptOptionJsonArray[0].keyvalue).replace(regex, ""));
					}
					

				   $('#taxmanagercode').combobox({
						data : jsondata.taxEmpOptionJsonArray,
                        valueField:'key',
                        textField:'keyvalue'
					});
				   	//分局登录 默认选中
				    var orgclass='<%=com.szgr.framework.authority.datarights.SystemUserAccessor.getInstance().getUserTaxOrgVO().getOrgclass()%>';
					var taxdeptcode='<%=com.szgr.framework.authority.datarights.SystemUserAccessor.getInstance().getTaxorgcode()%>';
					var taxempcode='<%=com.szgr.framework.authority.datarights.SystemUserAccessor.getInstance().getTaxempcode()%>';
					if(orgclass=='04'){
						//$('#taxdeptcode').combobox("setValue",taxdeptcode);
						//$('#taxmanagercode').combobox("setValue",taxempcode);
					}
	           }
	});
	
	/* $('#querytypegrid').datagrid({
			fitColumns:'true',
			width:200,
			height:450,
			nowrap: true,
			autoRowHeight: false,
			striped: true,
			collapsible:true,
			singleSelect:'true',
			pagination:false,
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
			showFooter: true,
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
								window.open("/TaxsourceQueryServlet/export.do?+'"+param+"'", '',
						           'top=1000,left=2500,width=1,height=1,toolbar=no,menubar=no,location=no');
							}
						});
					}
				}],
			onLoadSuccess: function(data){   
				var panel = $(this).datagrid('getPanel');   
				var tr = panel.find('div.datagrid-body tr');   
				tr.each(function(){   
					var td = $(this).children('td[field="taxamount"]');   
					td.children("div").css({   
						"text-align": "right"  
					});
				});   
			}
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
			showFooter: true,
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
								window.open("/TaxsourceQueryServlet/export.do?+'"+param+"'", '',
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
			showFooter: true,
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
								window.open("/TaxsourceQueryServlet/export.do?+'"+param+"'", '',
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
			showFooter: true,
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
								window.open("/TaxsourceQueryServlet/export.do?+'"+param+"'", '',
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
			showFooter: true,
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
								window.open("/TaxsourceQueryServlet/export.do?+'"+param+"'", '',
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
	opts.url = '/TaxsourceQueryServlet/gettaxsource.do';
	$("#"+tabid).datagrid('load',params); 
	var p = $("#"+tabid).datagrid('getPager');  
	$(p).pagination({
		showPageList:false,
		pageSize: 15
	});
	$('#taxsourcequerywindow').window('close');
	
}

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
								<th data-options="field:'taxpayerid',width:60,align:'center',editor:{type:'text',required:true}">计算机编码</th>
								<th data-options="field:'taxpayername',width:100,align:'left',editor:{type:'text',required:true}">纳税人名称</th>
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
								<th data-options="field:'taxpayerid',width:60,align:'center',editor:{type:'text',required:true}">计算机编码</th>
								<th data-options="field:'taxpayername',width:100,align:'left',editor:{type:'text',required:true}">纳税人名称</th>
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
								<th data-options="field:'taxderateamount',width:60,align:'center',formatter:formatnumber,editor:{type:'text',required:true}">减免税款</th>
								<th data-options="field:'taxamountactual',width:60,align:'center',formatter:formatnumber,editor:{type:'text',required:true}">已缴税款</th>
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
								<th data-options="field:'taxpayerid',width:60,align:'center',editor:{type:'text',required:true}">计算机编码</th>
								<th data-options="field:'taxpayername',width:100,align:'left',editor:{type:'text',required:true}">纳税人名称</th>
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
								<th data-options="field:'taxpayerid',width:60,align:'center',editor:{type:'text',required:true}">计算机编码</th>
								<th data-options="field:'taxpayername',width:100,align:'left',editor:{type:'text',required:true}">纳税人名称</th>
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
								<th data-options="field:'taxpayerid',width:60,align:'center',editor:{type:'text',required:true}">计算机编码</th>
								<th data-options="field:'taxpayername',width:100,align:'left',editor:{type:'text',required:true}">纳税人名称</th>
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
						<td align="right">应缴税款：</td>
						<td>
							<input id="taxamount" class="easyui-numberbox" style="width:200px;text-align:right" name="taxamount" data-options="min:0,required:true" precision="2" value="0.00"/>
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
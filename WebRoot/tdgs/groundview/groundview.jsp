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

<script>
$(function(){
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
						$('#taxdeptcode').combobox("setValue",taxdeptcode);
						$('#taxmanagercode').combobox("setValue",taxempcode);
					}
					var p = $('#groundinfogrid').datagrid('getPager');  
						$(p).pagination({   
						showPageList:false,
						pageSize: 15
					});
	           }
	});
	
	$('#groundinfogrid').datagrid({
			fitColumns:'true',
			width:400,
			height:450,
			nowrap: true,
			autoRowHeight: false,
			striped: true,
			collapsible:true,
			singleSelect:'true',
			pagination:true,
			rownumbers:true,
			columns:[[
				{field:'estateid',title:'',width:120,align:'center',hidden:'true'},
				{field:'estateserialno',title:'宗地编号',width:140,align:'center'},
				{field:'landsource',title:'土地来源',width:60,align:'center'},
				{field:'taxpayername',title:'土地权属人',width:100,align:'center'},
				{field:'detailaddress',title:'坐落地址',width:220,align:'center'},
				{field:'landarea',title:'土地面积',width:150,align:'center'},
				{field:'sourcetaxpayerid',title:'',width:120,align:'center',hidden:'true'}
			]],
			toolbar:[{
						text:'查询',
						iconCls:'icon-search',
						handler:function(){
							$('#groundviewquerywindow').window('open');
						}
					},{
						text:'切换地图视角',
						iconCls:'icon-search',
						handler:function(){
							moduleWindow.open({
								id: "module_" + i + "_" + j + "_" + "Id",
								title: submenus[j].brandName,
								width: 1200,
								height: 580,
								icon: submenus[j].menuIcon,
								minimizable: true,
								maximized:true,
								//data: {name: 'Tom', age: 18}, //传递给iframe的数据
								content: submenus[j].menuUrl,
								onLoad: function(dialog){
									if(this.content && this.content.doInit){//判断弹出窗体iframe中的doInit方法是否存在
										this.content.doInit(dialog);//调用并将参数传入，此处当然也可以传入其他内容
									}
								}
								,buttons: []
								//,buttons: [{"text":"aaa",handler:function(){}},{"text":"bbb",handler:function(){}}]
							});

						}
					}],
			onClickRow:function(index,row){
				
			},
			onLoadSuccess: function(data){
				
			},
			onClickCell: function (rowIndex, field, value) {
				
			},
			onSelect:function (rowIndex, rowData){
				var estateid = rowData.estateid;
				var pageoptions = $('#groundhistorygrid').datagrid('getPager').data("pagination").options;
				//alert(pageoptions.pageNumber);
				$('#tab').tabs('select', "土地信息明细");
				$.ajax({
				   type: "post",
				   url: "/GroundViewServlet/getgrounddetail.do",
				   data: {estateid:estateid},
				   dataType: "json",
				   success: function(jsondata){
					  $('#detailform').form('load',jsondata);
				   }
				});
				$.ajax({
				   type: "post",
				   url: "/GroundViewServlet/getgroundhistory.do",
				   data: {estateid:estateid,page:pageoptions.pageNumber},
				   dataType: "json",
				   success: function(jsondata){
					  $('#groundhistorygrid').datagrid('loadData',jsondata);
				   }
				});
			}
	});
	$('#tab').tabs({
		onSelect:function(title,index){
			var tab = $('#tab').tabs('getSelected');
			var row = $('#groundinfogrid').datagrid('getSelected');
			
			if(row){
				if(tab.panel('options').title=='土地信息明细'){ //土地明细信息
					$.ajax({
					   type: "post",
					   url: "/GroundViewServlet/getgrounddetail.do",
					   data: {estateid:row.estateid},
					   dataType: "json",
					   success: function(jsondata){
						  $('#detailform').form('load',jsondata);
					   }
					});
				}
			}
		}
	});
	$('#groundhistorygrid').datagrid({
			fitColumns:'true',
			width:900,
			height:450,
			nowrap: true,
			autoRowHeight: false,
			striped: true,
			collapsible:true,
			singleSelect:'true',
			pagination:true,
			rownumbers:true
	});
	$('#groundtaxgrid').datagrid({
			fitColumns:'true',
			width:900,
			height:450,
			nowrap: true,
			autoRowHeight: false,
			striped: true,
			collapsible:true,
			singleSelect:'true',
			pagination:true,
			rownumbers:true
	});
	$('#groundhousegrid').datagrid({
			fitColumns:'true',
			width:900,
			height:450,
			nowrap: true,
			autoRowHeight: false,
			striped: true,
			collapsible:true,
			singleSelect:'true',
			pagination:true,
			rownumbers:true
	});
	var p = $('#groundinfogrid').datagrid('getPager');
	$(p).pagination({
		showPageList:false,
		pageSize: 15
	});
	var p = $('#groundhistorygrid').datagrid('getPager');
	$(p).pagination({
		showPageList:false,
		pageSize: 15
	});
	var p = $('#groundtaxgrid').datagrid('getPager');
	$(p).pagination({
		showPageList:false,
		pageSize: 15
	});
	var p = $('#groundhousegrid').datagrid('getPager');
	$(p).pagination({
		showPageList:false,
		pageSize: 15
	});
	
});

function query(){
	$('#groundinfogrid').datagrid('loadData',{total:0,rows:[]});
	var params = {};
	var param='';
	var fields =$('#queryform').serializeArray();
	$.each( fields, function(i, field){
		params[field.name] = field.value;
		param=param+field.name+'='+field.value+'&';
	}); 
	//alert($.toJSON(params));
	var opts = $('#groundinfogrid').datagrid('options');
	opts.url = '/GroundViewServlet/getgroundinfo.do';
	$('#groundinfogrid').datagrid('load',params); 
	var p = $('#groundinfogrid').datagrid('getPager');  
	$(p).pagination({   
		showPageList:false,
		pageSize: 15
	});
	$('#groundviewquerywindow').window('close');
	
}

</script>
</head>
<body class="easyui-layout">
		<div data-options="region:'west',split:false" title="" style="width:410px;padding1:1px;overflow:auto" data-options="selected:true">
			<div class="easyui-accordion" data-options="fit:true,border:false" style="width:400px;height:500px;">
				<div title="土地信息列表" style="overflow:auto;">
					<table id="groundinfogrid"> 
					</table>
				</div>
			</div>
		</div>
		<div data-options="region:'center'" title="" style="overflow:auto;">
			<div id="tab" class="easyui-tabs" style="height:480px;width:900px">
				<div  title="土地信息明细" closable="false" href="">
					<form id="detailform" method="post">
						<table id="grounddetail" class="table table-bordered">
							<tr>
								<td align="right">宗地编号：</td>
								<td>
									<input id="estateserialno" class="easyui-validatebox" type="text" style="width:200px" name="estateserialno"/>
								</td>
								<td align="right">土地来源：</td>
								<td>
									<input id="landsource" class="easyui-validatebox" type="text" style="width:200px" name="landsource"/>
								</td>
							</tr>
							<tr>
								<td align="right">土地证类型：</td>
								<td>
									<input id="landcertificatetype" class="easyui-validatebox" type="text" style="width:200px" name="landcertificatetype"/>
								</td>
								<td align="right">土地证号：</td>
								<td>
									<input id="landcertificate" class="easyui-validatebox" type="text" style="width:200px" name="landcertificate"/>
								</td>
							</tr>
							<tr>
								<td align="right">发证日期：</td>
								<td>
									<input id="landcertificatedates" class="easyui-validatebox" type="text" style="width:200px" name="landcertificatedates"/>
								</td>
								<td align="right">图号：</td>
								<td>
									<input id="pictureno" class="easyui-validatebox" type="text" style="width:200px" name="pictureno"/>
								</td>
							</tr>
							<tr>
								<td align="right">权属人计算机编码：</td>
								<td>
									<input id="taxpayerid" class="easyui-validatebox" type="text" style="width:200px" name="taxpayerid"/>
								</td>
								<td align="right">权属人名称：</td>
								<td>
									<input id="taxpayername" class="easyui-validatebox" type="text" style="width:200px" name="taxpayername"/>
								</td>
							</tr>
							<tr>
								<td align="right">土地用途：</td>
								<td>
									<input id="purpose" class="easyui-validatebox" type="text" style="width:200px" name="purpose"/>
								</td>
								<td align="right">土地坐落类型：</td>
								<td>
									<input id="locationtype" class="easyui-validatebox" type="text" style="width:200px" name="locationtype"/>
								</td>
							</tr>
							<tr>
								<td align="right">所属村委会：</td>
								<td>
									<input id="belongtowns" class="easyui-validatebox" type="text" style="width:200px" name="belongtowns"/>
								</td>
								<td align="right">详细地址：</td>
								<td>
									<input id="detailaddress" class="easyui-validatebox" type="text" style="width:200px" name="detailaddress"/>
								</td>
							</tr>
							<tr>
								<td align="right">实际交付土地时间：</td>
								<td>
									<input id="holddates" class="easyui-validatebox" type="text" style="width:200px" name="holddates"/>
								</td>
							</tr>
							<tr>
								<td align="right">获得土地总价：</td>
								<td>
									<input id="landmoney" class="easyui-validatebox" type="text" style="width:200px" name="landmoney"/>
								</td>
								<td align="right">面积：</td>
								<td>
									<input id="landarea" class="easyui-validatebox" type="text" style="width:200px" name="landarea"/>
								</td>
							</tr>
						</table>
					</form>
				</div>
				<div title="税源信息" closable="false" data-options="
							tools:[{
								handler:function(){
									$('#groundtaxgrid').datagrid('reload');
								}
							}]">
					<table id="groundtaxgrid" style="width:900px;height:380px"
					data-options="iconCls:'icon-edit',singleSelect:true" rownumbers="true"> 
						<thead>
							<tr>
								<th data-options="field:'businesstype',width:60,align:'center',editor:{type:'text',required:true}">计算机编码</th>
								<th data-options="field:'lessorid',width:100,align:'center',editor:{type:'text',required:true}">纳税人名称</th>
								<th data-options="field:'lessortaxpayername',width:100,align:'center',editor:{type:'text',required:true}">税种</th>
								<th data-options="field:'lesseesid',width:100,align:'center',editor:{type:'text',required:true}">税目</th>
								<th data-options="field:'lesseestaxpayername',width:80,align:'center',editor:{type:'text',required:true}">税款所属期起</th>
								<th data-options="field:'holddates',width:80,align:'center',editor:{type:'text',required:true}">税款所属期止</th>
								<th data-options="field:'purpose',width:60,align:'center',editor:{type:'text',required:true}">应缴金额</th>
								<th data-options="field:'landarea',width:60,align:'center',editor:{type:'text',required:true}">已缴金额</th>
								<th data-options="field:'landareaa',width:60,align:'center',editor:{type:'text',required:true}">欠税金额</th>
							</tr>
						</thead>
					</table>
				</div>
				<div title="土地历史交易记录" closable="false" data-options="
							tools:[{
								handler:function(){
									$('#groundhistorygrid').datagrid('reload');
								}
							}]">
					<table id="groundhistorygrid" style="width:900px;height:380px"
					data-options="iconCls:'icon-edit',singleSelect:true,idField:'itemid'" rownumbers="true"> 
						<thead>
							<tr>
								<th data-options="field:'businesstype',width:100,align:'center',editor:{type:'text',required:true}">业务类型</th>
								<th data-options="field:'lessorid',width:100,align:'center',editor:{type:'text',required:true}">转出方计算机编码</th>
								<th data-options="field:'lessortaxpayername',width:100,align:'center',editor:{type:'text',required:true}">转出方名称</th>
								<th data-options="field:'lesseesid',width:100,align:'center',editor:{type:'text',required:true}">转入方计算机编码</th>
								<th data-options="field:'lesseestaxpayername',width:100,align:'center',editor:{type:'text',required:true}">转入方名称</th>
								<th data-options="field:'holddates',width:100,align:'center',editor:{type:'text',required:true}">实际交付土地时间</th>
								<th data-options="field:'purpose',width:100,align:'center',editor:{type:'text',required:true}">土地用途</th>
								<th data-options="field:'landarea',width:100,align:'center',editor:{type:'text',required:true}">面积</th>
							</tr>
						</thead>
					</table>
				</div>
				<div title="房产信息" closable="false" data-options="
							tools:[{
								handler:function(){
									$('#groundhousegrid').datagrid('reload');
								}
							}]">
					<table id="groundhousegrid" style="width:900px;height:380px"
					data-options="iconCls:'icon-edit',singleSelect:true,idField:'itemid'" rownumbers="true"> 
						<thead>
							<tr>
								<th data-options="field:'businesstype',width:100,align:'center',editor:{type:'text',required:true}">房产来源</th>
								<th data-options="field:'lessorid',width:100,align:'center',editor:{type:'text',required:true}">房产所有人计算机编码</th>
								<th data-options="field:'lessortaxpayername',width:100,align:'center',editor:{type:'text',required:true}">房产所有人名称</th>
								<th data-options="field:'lesseesid',width:100,align:'center',editor:{type:'text',required:true}">房产证号</th>
								<th data-options="field:'lesseestaxpayername',width:100,align:'center',editor:{type:'text',required:true}">房产用途</th>
								<th data-options="field:'holddates',width:100,align:'center',editor:{type:'text',required:true}">投入使用时间</th>
								<th data-options="field:'purpose',width:100,align:'center',editor:{type:'text',required:true}">房产建筑面积</th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
	<div id="groundviewquerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地信息查询',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:300px;">
		<div class="easyui-panel" title="" style="width:900px;">
			<form id="queryform" method="post">
				<table id="narjcxx" class="table table-bordered">
					<tr>
						<td align="right">州市地税机关：</td>
						<td>
							<input class="easyui-combobox" name="taxorgsupcode" id="taxorgsupcode" style="width:200px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">县区地税机关：</td>
						<td>
							<input class="easyui-combobox" name="taxorgcode" id="taxorgcode" style="width:200px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						
					</tr>
					<tr>
						<td align="right">主管地税部门：</td>
						<td>
							<input class="easyui-combobox" name="taxdeptcode" id="taxdeptcode" style="width:200px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">税收管理员：</td>
						<td>
							<input class="easyui-combobox" name="taxmanagercode" id="taxmanagercode" style="width:200px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						
					</tr>
					<tr>
						<td align="right">土地权属人计算机编码：</td>
						<td>
							<input id="querytaxpayerid" class="easyui-validatebox" type="text" style="width:200px" name="querytaxpayerid"/>
						</td>
						<td align="right">土地权属人名称：</td>
						<td>
							<input id="querytaxpayername" class="easyui-validatebox" type="text" style="width:200px" name="querytaxpayername"/>
						</td>
					</tr>
						<td align="right">宗地编号：</td>
						<td>
							<input id="estateserialno" class="easyui-validatebox" type="text" style="width:200px" name="estateserialno"/>
						</td>
						<td align="right">土地坐落地址：</td>
						<td>
							<input id="detailaddress" class="easyui-validatebox" type="text" style="width:200px" name="detailaddress"/>
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
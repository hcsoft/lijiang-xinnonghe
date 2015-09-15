<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<%@ include file="/common/inc.jsp"%>
<html>
<head>
	<base target="_self"/>
	<title></title>

	<link rel="stylesheet" href="<%=spath%>/themes/sunny/easyui.css">
	<link rel="stylesheet" href="<%=spath%>/themes/icon.css">
	<link rel="stylesheet" href="<%=spath%>/css/toolbar.css">
	<link rel="stylesheet" href="<%=spath%>/css/logout.css"/>
	<link rel="stylesheet" href="<%=spath%>/css/tablen.css"/>
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

	
</head>
<body>
<script>
	
	$(function(){
		//取得url参数
		//var paraString = location.search;     
		//var paras = paraString.split("&");   
		//buttonbusinesstype = paras[0].substr(paras[0].indexOf("=") + 1);   
		//var businessNumber = paras[1].substr(paras[1].indexOf("=") + 1); 
		//$.messager.alert('返回消息',buttonbusinesstype);
		$.ajax({
			   type: "post",
				async:false,
			   url: "/InitGroundServlet/getlocationComboxs.do",
			   data: {},
			   dataType: "json",
			   success: function(jsondata){
				  locationdata= jsondata;
			   }
			});
		$.ajax({
			   type: "post",
				async:false,
			   url: "/TransferGroundServlet/getlevydatetypeComboxs.do",
			   data: {},
			   dataType: "json",
			   success: function(jsondata){
				  levydatetypedata= jsondata;
			   }
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
						//$.messager.alert('返回消息',JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
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
										//$('#taxdeptcode').combobox("clear");
										//$('#taxempcode').combobox("clear");

										//$('#taxdeptcode').combobox({}).combobox('clear');
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
					//$.messager.alert('返回消息',JSON.stringify(jsondata.taxSupOrgOptionJsonArray));
					
					//$.messager.alert('返回消息',JSON.stringify(jsondata.taxOrgOption));
					//$.messager.alert('返回消息',JSON.stringify(jsondata.taxDeptOption));
					//$.messager.alert('返回消息',JSON.stringify(jsondata.taxEmpOption));


					//$.messager.alert('返回消息',jsondata.funcMenuJson);
	           }
	   });
			$('#groundtransfergrid').datagrid({
				fitColumns:true,
				maximized:'true',
				pagination:true,
				idField:'landstoreid',
				//view:viewed,
				toolbar:[{
					id:'query',
					text:'查询',
					iconCls:'icon-search',
					handler:function(){
						$('#groundtransferquerywindow').window('open');
					}
				},{
					id:'showdetail',
					text:'明细查看',
					iconCls:'icon-tip',
					handler:function(){
						var tdxxrow = $('#groundtransfergrid').datagrid('getSelected');//获取土地信息选中行
						if(tdxxrow){
							$('#grounddetailwindow').window('open');//打开新录入窗口
							$('#grounddetailwindow').window('refresh', '../grounddetail/grounddetail.jsp');
						}else{
							$.messager.alert('返回消息',"请选择需要进行查看的土地信息！");
						}
					}
				},{
					id:'cr',
					text:'出让划拨',
					iconCls:'icon-business1',
					handler:function(){
						var row = $('#groundtransfergrid').datagrid('getSelected');
						if(row){
							if(row.landstoreid != null){
								combobusinesstype='0';
								$('#groundbusinesswindow').window('open');
								$('#groundbusinesswindow').window('refresh', 'groundbusinessselect.jsp');
							}else{
								$.messager.alert('返回消息',"该土地不能进行出让业务！");
							}
						}else{
							$.messager.alert('返回消息',"请选择需要出让的土地！");
						}
					}
				}],
				onClickRow:function(index){
				}
			});
			
			var p = $('#groundtransfergrid').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
				});
			
			$('#grounddetailwindow').window({
				onClose:function(){
					$('#grounddetailwindow').window('refresh', '../blank.jsp');
				}
			});
		});

		function query(){
			$('#groundtransfergrid').datagrid('unselectAll');
			var params = {};
			var fields =$('#groundtransferqueryform').serializeArray();
			$.each( fields, function(i, field){
				params[field.name] = field.value;
			}); 
			params.state='2';//只查询状态为收储的土地
			$('#groundtransfergrid').datagrid('loadData',{total:0,rows:[]});
			var opts = $('#groundtransfergrid').datagrid('options');
			opts.url = '/TransferGroundServlet/getgroundinfo.do';
			$('#groundtransfergrid').datagrid('load',params); 
			var p = $('#groundtransfergrid').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false,
				pageSize: 15
			});
			$('#groundtransferquerywindow').window('close');
			
		}

		function save(){
			var params = {};
			var fields =$('#groundstorageeditform').serializeArray();
			$.each( fields, function(i, field){
				params[field.name] = field.value;
			}); 
			$.ajax({
			   type: "post",
			   url: "/InitGroundServlet/savelandstoremain.do",
			   data: params,
			   dataType: "json",
			   success: function(jsondata){
				   $('#groundtransfergrid').datagrid('reload');
				  $('#groundstorageeditwindow').window('close');
				  $.messager.alert('返回消息','保存成功！');
			   }
			});
		}

		function refreshLandstoredetail(){
			var row = $('#groundtransfergrid').datagrid('getSelected');
			if(row && selectindex != undefined){
				$.ajax({
				   type: "post",
				   url: "/InitGroundServlet/getlandstoresub.do",
				   data: {landstoreid:row.landstoreid},
				   dataType: "json",
				   success: function(jsondata){
					  $('#groundstoragedetailgrid').datagrid('loadData',jsondata);
				   }
				});
			}
		}
	
	function format(row){
		for(var i=0; i<locationdata.length; i++){
			if (locationdata[i].key == row) return locationdata[i].value;
		}
		return row;
	};

	</script>
	<form id="groundtransferform" method="post">
		<div title="批复信息" data-options="
						tools:[{
							handler:function(){
								$('#groundtransfergrid').datagrid('reload');
							}
						}]">
					
						<table id="groundtransfergrid" style="overflow:auto"
						data-options="iconCls:'icon-edit',singleSelect:true" rownumbers="true"> 
							<thead>
								<tr>
									<th data-options="field:'landstoreid',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'estateid',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'locationtype',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'state',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'taxpayerid',width:80,align:'center',editor:{type:'validatebox'}">计算机编码</th>
									<th data-options="field:'taxpayername',width:200,align:'center',editor:{type:'validatebox'}">纳税人名称</th>
									<th data-options="field:'belongtowns',width:100,align:'center',formatter:format,editor:{type:'combobox'}">所属乡镇</th>
									<th data-options="field:'detailaddress',width:100,align:'center',editor:{type:'validatebox'}">详细地址</th>
									<th data-options="field:'landarea',width:60,align:'center',editor:{type:'validatebox'}">可使用土地面积</th>
									<th data-options="field:'limitbegins',width:100,align:'center',editor:{type:'validatebox'}">使用年限起</th>
									<th data-options="field:'limitends',width:100,align:'center',editor:{type:'validatebox'}">使用年限止</th>
								</tr>
							</thead>
						</table>
					
			</div>
	</form>
	<div id="groundtransferquerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地查询',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:300px;">
		<div class="easyui-panel" title="" style="width:900px;">
			<form id="groundtransferqueryform" method="post">
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
						<td align="right">所属乡镇：</td>
						<td>
							<input class="easyui-combobox" name="belongtocountrycode" id="belongtocountrycode" editable='false' style="width:200px" data-options="
									valueField:'key',
									textField: 'value',
									url:'/InitGroundServlet/getlocationComboxs.do?codetablename=COD_BELONGTOCOUNTRYCODE'
								"/>
						</td>
						<td align="right">计算机编码：</td>
						<td><input id="querytaxpayerid" class="easyui-validatebox" style="width:200px" type="text" name="querytaxpayerid"/></td>
						<!-- <td align="right">状态：</td>
						<td colspan="3">
							<select id="state" class="easyui-combobox" name="state" style="width:200px;" data-options="required:true" editable="false">
								<option value=""  selected="true">全部</option>
								<option value="2">收储</option>
								<option value="3">所有权取得</option>
								<option value="4">使用权取得</option>
							</select>
						</td> -->
						
					</tr>
					<tr>
						
						<td align="right">纳税人名称：</td>
						<td colspan="3">
							<input id="querytaxpayername" class="easyui-validatebox" type="text" style="width:200px" name="querytaxpayername"/>
						</td>
					</tr>
				</table>
			</form>
			<div style="text-align:center;padding:1px;">  
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="query()">查询</a>
			</div>
		</div>
	</div>
	<div id="grounddetailwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地明细信息',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:960px;height:500px;">
	</div>
	<div id="groundbusinesswindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地业务',collapsible:false,minimizable:false,maximizable:false,closable:true,resizable:false" style="width:960px;height:500px;">
	</div>
	<div id="reginfowindow" class="easyui-window" data-options="closed:true,modal:true,title:'纳税人登记信息',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:620px;height:470px;">
	</div>
</body>
</html>
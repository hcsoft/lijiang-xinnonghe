<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/html">

<head>

	<link rel="stylesheet" href="/themes/sunny/easyui.css">
	<link rel="stylesheet" href="/themes/icon.css">
	<link rel="stylesheet" href="/css/tablen.css">

	
	<script src="/js/jquery-1.8.2.min.js"></script>
	<script src="/js/jquery.easyui.min.js"></script>
	<script src="/js/jquery.json-2.2.js"></script>
	<script src="/js/easyui-lang-zh_CN.js"></script>
	
    <title>用户组与角色关联维护</title>


    <script>


	$(function(){

/*
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
							//alert(n.key);
							$.ajax({
								   type: "get",
								   url: "/soption/taxOrgOptionBySup.do",
								   data: {"taxSuperOrgCode":n.key},
								   dataType: "json",
								   success: function(jsondata){
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
								   }
							});
						} 
					});
					if(jsondata.taxSupOrgOptionJsonArray.length == 1){
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
								   }
							});
						} 
					});
					if(jsondata.taxOrgOptionJsonArray.length == 1){
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
						$('#taxdeptcode').combobox("setValue",JSON.stringify(jsondata.taxDeptOptionJsonArray[0].key).replace(regex, ""));
						$('#taxdeptcode').combobox("setText",JSON.stringify(jsondata.taxDeptOptionJsonArray[0].keyvalue).replace(regex, ""));
					}

				   $('#taxmanagercode').combobox({
						data : jsondata.taxEmpOptionJsonArray,
                        valueField:'key',
                        textField:'keyvalue'
					});
	           }
	   });



		var regex = new RegExp("\"","g");  
		$.ajax({
			   type: "get",
			   url: "/soption/taxOrgOptionInit.do",
			   data: {"moduleAuth":"15","emptype":"30"},
			   dataType: "json",
			   success: function(jsondata){
				   $('#s_taxorgsupcode').combobox({
						data : jsondata.taxSupOrgOptionJsonArray,
                        valueField:'key',
                        textField:'keyvalue',
						onSelect:function(n,o){  	
							//alert(n.key);
							$.ajax({
								   type: "get",
								   url: "/soption/taxOrgOptionBySup.do",
								   data: {"taxSuperOrgCode":n.key},
								   dataType: "json",
								   success: function(jsondata){
									   $('#s_taxorgcode').combobox({
											data : jsondata.taxOrgOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});
									   $('#s_taxdeptcode').combobox({
											data : jsondata.taxDeptOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});		
									   $('#s_taxmanagercode').combobox({
											data : jsondata.taxEmpOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});											
								   }
							});
						} 
					});
					if(jsondata.taxSupOrgOptionJsonArray.length == 1){
						$('#s_taxorgsupcode').combobox("setValue",JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key).replace(regex, ""));
						$('#s_taxorgsupcode').combobox("setText",JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].keyvalue).replace(regex, ""));
					}


				   $('#s_taxorgcode').combobox({
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
									   $('#s_taxdeptcode').combobox({
											data : jsondata.taxDeptOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});		
									   $('#s_taxmanagercode').combobox({
											data : jsondata.taxEmpOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});											
								   }
							});
						} 
					});
					if(jsondata.taxOrgOptionJsonArray.length == 1){
						$('#s_taxorgcode').combobox("setValue",JSON.stringify(jsondata.taxOrgOptionJsonArray[0].key).replace(regex, ""));
						$('#s_taxorgcode').combobox("setText",JSON.stringify(jsondata.taxOrgOptionJsonArray[0].keyvalue).replace(regex, ""));
					}

				   $('#s_taxdeptcode').combobox({
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
									   $('#s_taxmanagercode').combobox({
											data : jsondata.taxEmpOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});											
								   }
							});
						} 
					});
					if(jsondata.taxDeptOptionJsonArray.length == 1){
						$('#s_taxdeptcode').combobox("setValue",JSON.stringify(jsondata.taxDeptOptionJsonArray[0].key).replace(regex, ""));
						$('#s_taxdeptcode').combobox("setText",JSON.stringify(jsondata.taxDeptOptionJsonArray[0].keyvalue).replace(regex, ""));
					}

				   $('#s_taxmanagercode').combobox({
						data : jsondata.taxEmpOptionJsonArray,
                        valueField:'key',
                        textField:'keyvalue'
					});
	           }
	   });

**/



		var groupListId = $('#groupListId').datagrid('getPager');  
			$(groupListId).pagination({  
				pageSize: 15,//每页显示的记录条数，默认为10  
				pageList: [15],//可以设置每页记录条数的列表  
				showPageList:false
			}); 

		var roleListId = $('#roleListId').datagrid('getPager');  
			$(roleListId).pagination({  
				pageSize: 15,//每页显示的记录条数，默认为10  
				pageList: [15],//可以设置每页记录条数的列表  
				showPageList:false
			}); 

		var group2roleListId = $('#group2roleListId').datagrid('getPager');  
			$(group2roleListId).pagination({  
				pageSize: 15,//每页显示的记录条数，默认为10  
				pageList: [15],//可以设置每页记录条数的列表  
				showPageList:false
			}); 

	});

		function queryGroupList(){
			var group_code_queryId =  $('#group_code_queryId').val();
			var group_describe_queryId =  $('#group_describe_queryId').val();
			$('#groupListId').datagrid('load',{"group_code_queryId":group_code_queryId,"group_describe_queryId":group_describe_queryId}); 
		}

		function queryRoleList(){
			var role_code_queryId =  $('#role_code_queryId').val();
			var role_describe_queryId =  $('#role_describe_queryId').val();
			$('#roleListId').datagrid('load',{"role_code_queryId":role_code_queryId,"role_describe_queryId":role_describe_queryId}); 
		
		}


		function queryGroup2RoleList(){
			var group_code_queryId =  $('#s_group_code_queryId').val();
			var role_code_queryId =  $('#s_role_code_queryId').val();
			$('#group2roleListId').datagrid('load',{"group_code_queryId":group_code_queryId,"role_code_queryId":role_code_queryId}); 
		
		}

		function saveGroup2Role(){
			var group_rows = $('#groupListId').datagrid('getChecked');
			var role_rows = $('#roleListId').datagrid('getChecked');
			if(group_rows.length <= 0){
				$.messager.alert('提示','请先选择需要关联的用户组记录!');
				return ;
			}
			if(role_rows.length <= 0){
				$.messager.alert('提示','请先选择需要关联的角色记录!');
				return ;
			}
			var sendData = {"group_rows":group_rows,"role_rows":role_rows};
			$.ajax({
				   type: "post",
				   url: "/Group2RoleMgrService/save.do",
				   data: $.toJSON(sendData),
				   contentType: "application/json; charset=utf-8",
				   dataType: "json",
				   success: function(jsondata){
						$.messager.alert('提示','保存成功!');
						queryGroup2RoleList();
				   }
		    });
		

		}

		function deleteGroup2Role(){
			var group2role_rows = $('#group2roleListId').datagrid('getChecked');
			if(group2role_rows.length <= 0){
				$.messager.alert('提示','请先选择需要删除的记录!');
				return;
			}
			var sendData = {"group2role_rows":group2role_rows};
			$.ajax({
				   type: "post",
				   url: "/Group2RoleMgrService/delete.do",
				   data: $.toJSON(sendData),
				   contentType: "application/json; charset=utf-8",
				   dataType: "json",
				   success: function(jsondata){
						$.messager.alert('提示','删除成功!');
						queryGroup2RoleList();
				   }
		    });

		}

    </script>
</head>
<body>
<body style="overflow:hidden">  


	<div class="easyui-layout" style="width:1000px;height:650px;">

	

			

		<div data-options="region:'west',split:false,title:''" style="width:420px;height:300px">
	

			<div id="groupTb" style="padding:5px;height:auto">
				<div>
					用户组名称: <input id="group_code_queryId" class="easyui-validatebox" style="width:80px" data-options="required:false">&nbsp;&nbsp;&nbsp;&nbsp;
					描述: <input id="group_describe_queryId" class="easyui-validatebox" style="width:80px" data-options="required:false">&nbsp;&nbsp;&nbsp;&nbsp;
					<a href="javascript:queryGroupList()" class="easyui-linkbutton" iconCls="icon-search">查询</a>
				</div>
			</div>

			<table id="groupListId" class="easyui-datagrid" title="用户组列表" style="width:415px;height:295px"
					data-options="fitColumns:true,striped:true,rownumbers:true,singleSelect:false,pagination:true,url: '/Group2UserMgrService/getGroupList.do',toolbar:'#groupTb'">
				<thead>
					<tr>
						<th data-options="field:'ck1',checkbox:true"></th>
						<th data-options="field:'group_code',width:50">用户组名称</th> 
						<th data-options="field:'group_describe',width:150">用户组描述</th>
					</tr>
				</thead>
			</table>

		</div>

		<div data-options="region:'center',title:'',iconCls:'icon-ok'" style="width:580px;height:300px">

			<div id="roleTb" style="padding:5px;height:auto">
				<div>
					角色名称: <input id="role_code_queryId" class="easyui-validatebox" style="width:80px" data-options="required:false">&nbsp;&nbsp;&nbsp;&nbsp;
					角色描述: <input id="role_describe_queryId" class="easyui-validatebox" style="width:80px" data-options="required:false">&nbsp;&nbsp;&nbsp;&nbsp;
					<a href="javascript:queryRoleList()" class="easyui-linkbutton" iconCls="icon-search">查询</a>
				</div>
			</div>

			<table id="roleListId" class="easyui-datagrid" title="角色列表" style="width:575px;height:295px"
					data-options="fitColumns:true,striped:true,rownumbers:true,singleSelect:false,pagination:true,url: '/Group2RoleMgrService/getRoleList.do',toolbar:'#roleTb'">
				<thead>
					<tr>
						<th data-options="field:'ck1',checkbox:true"></th>
						<th data-options="field:'role_code',width:50">角色名称</th> 
						<th data-options="field:'role_describe',width:150">角色描述</th>
					</tr>
				</thead>
			</table>

		</div>


		<div data-options="region:'south',title:'',iconCls:'icon-ok'" style="width:1000px;height:350px">

			<a href="javascript:saveGroup2Role()" class="easyui-linkbutton" iconCls="icon-add" style="padding-left:900px;">关联</a>

			<div id="group2roleTb" style="padding:5px;height:auto">
				<div>
					用户组名称: <input id="s_group_code_queryId" class="easyui-validatebox" style="width:80px" data-options="required:false">&nbsp;&nbsp;&nbsp;&nbsp;
					角色名称: <input id="s_role_code_queryId" class="easyui-validatebox" style="width:80px" data-options="required:false">&nbsp;&nbsp;&nbsp;&nbsp;
					<a href="javascript:queryGroup2RoleList()" class="easyui-linkbutton" iconCls="icon-search">查询</a>&nbsp;&nbsp;&nbsp;&nbsp;
					<a href="javascript:deleteGroup2Role()" class="easyui-linkbutton" iconCls="icon-cancel">删除</a>&nbsp;&nbsp;&nbsp;&nbsp;
				</div>
			</div>

			<table id="group2roleListId" class="easyui-datagrid" title="用户组与角色关联列表" style="width:995px;height:255px"
					data-options="fitColumns:true,striped:true,rownumbers:true,singleSelect:false,pagination:true,url:'/Group2RoleMgrService/getGroup2RoleList.do',toolbar:'#group2roleTb'">
				<thead>
					<tr>
						<th data-options="field:'ck3',checkbox:true"></th>
						<th data-options="field:'group_code',width:50">用户组名称</th> 
						<th data-options="field:'group_describe',width:100">用户组描述</th>
						<th data-options="field:'role_code',width:50">角色名称</th>
						<th data-options="field:'role_describe',width:50">用户描述</th>
					</tr>
				</thead>
			</table>

		</div>

</div>




</body>
</html>
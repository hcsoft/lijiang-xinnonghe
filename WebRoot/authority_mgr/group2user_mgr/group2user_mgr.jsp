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
	
    <title>用户组与用户关联维护</title>


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

		var userListId = $('#userListId').datagrid('getPager');  
			$(userListId).pagination({  
				pageSize: 30,//每页显示的记录条数，默认为10  
				pageList: [30],//可以设置每页记录条数的列表  
				showPageList:false
			}); 

		var group2userListId = $('#group2userListId').datagrid('getPager');  
			$(group2userListId).pagination({  
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

		function queryUserList(){
			
			var taxorgsupcode =  $('#taxorgsupcode').combobox('getValue');
			var taxorgcode =  $('#taxorgcode').combobox('getValue');
			var taxdeptcode =  $('#taxdeptcode').combobox('getValue');
			var taxmanagercode =  $('#taxmanagercode').combobox('getValue');
			$('#userListId').datagrid('load',{"taxorgsupcode":taxorgsupcode,"taxorgcode":taxorgcode,"taxdeptcode":taxdeptcode,"taxmanagercode":taxmanagercode}); 
		
		}


		function queryGroup2UserList(){
			var group_code_queryId =  $('#s_group_code_queryId').val();
			var s_taxorgsupcode =  $('#s_taxorgsupcode').combobox('getValue');
			var s_taxorgcode =  $('#s_taxorgcode').combobox('getValue');
			var s_taxdeptcode =  $('#s_taxdeptcode').combobox('getValue');
			var s_taxmanagercode =  $('#s_taxmanagercode').combobox('getValue');
			//alert(role_code_queryId);
			//alert(role_describe_queryId);
			//alert(brandName);
			//alert(leaf_type);
			//alert(resource_content);
			$('#group2userListId').datagrid('load',{"group_code_queryId":group_code_queryId,"s_taxorgsupcode":s_taxorgsupcode,"s_taxorgcode":s_taxorgcode,"s_taxdeptcode":s_taxdeptcode,"s_taxmanagercode":s_taxmanagercode}); 
		
		}

		function saveGroup2User(){
			var group_rows = $('#groupListId').datagrid('getChecked');
			var user_rows = $('#userListId').datagrid('getChecked');
			if(group_rows.length <= 0){
				$.messager.alert('提示','请先选择需要关联的用户组记录!');
				return ;
			}
			if(user_rows.length <= 0){
				$.messager.alert('提示','请先选择需要关联的用户记录!');
				return ;
			}
			var sendData = {"group_rows":group_rows,"user_rows":user_rows};
			$.ajax({
				   type: "post",
				   url: "/Group2UserMgrService/save.do",
				   data: $.toJSON(sendData),
				   contentType: "application/json; charset=utf-8",
				   dataType: "json",
				   success: function(jsondata){
						$.messager.alert('提示','保存成功!');
						queryGroup2UserList();
				   }
		    });
		

		}

		function deleteGroup2Resource(){
			var group2user_rows = $('#group2userListId').datagrid('getChecked');
			if(group2user_rows.length <= 0){
				$.messager.alert('提示','请先选择需要删除的记录!');
				return;
			}
			var sendData = {"group2user_rows":group2user_rows};
			$.ajax({
				   type: "post",
				   url: "/Group2UserMgrService/delete.do",
				   data: $.toJSON(sendData),
				   contentType: "application/json; charset=utf-8",
				   dataType: "json",
				   success: function(jsondata){
						$.messager.alert('提示','删除成功!');
						queryGroup2UserList();
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

			<div id="resourceTb" style="padding:5px;height:auto">
				<div>

	    	<table>
	    		<tr>
	    			<td align="right">州市地税机关:</td>
	    			<td>
						<input class="easyui-combobox" name="taxorgsupcode" id="taxorgsupcode" data-options="
									disabled:false,
									panelWidth: 300,
									panelHeight: 400
								">					
					</td>
	    			<td align="right">区县地税机关:</td>
	    			<td>
						<input class="easyui-combobox" name="taxorgcode" id="taxorgcode" data-options="
									disabled:false,
									panelWidth: 300,
									panelHeight: 400
								">					
					</td>
	    		</tr>

	    		<tr>
	    			<td align="right">主管地税部门:</td>
	    			<td>
						<input class="easyui-combobox" name="taxdeptcode" id="taxdeptcode" data-options="
									disabled:false,
									panelWidth: 300,
									panelHeight: 400
								">					
					</td>
	    			<td align="right">税收管理员:</td>
	    			<td>
						<input class="easyui-combobox" name="taxmanagercode" id="taxmanagercode" data-options="
									disabled:false,
									panelWidth: 300,
									panelHeight: 400
								">		
						<a href="javascript:queryUserList()" class="easyui-linkbutton" iconCls="icon-search">查询</a>
					</td>
	    		</tr>

	    	</table>


					
				</div>
			</div>

			<table id="userListId" class="easyui-datagrid" title="用户列表" style="width:575px;height:295px"
					data-options="fitColumns:true,striped:true,rownumbers:true,singleSelect:false,pagination:true,url:'/Group2UserMgrService/getUserList.do',toolbar:'#resourceTb'">
				<thead>
					<tr>
						<th data-options="field:'ck2',checkbox:true"></th>
						<th data-options="field:'taxempcode',width:100">用户代码</th>
						<th data-options="field:'taxorgshortname',width:250">用户机关</th>
						<th data-options="field:'taxempname',width:150">用户名称</th>
					</tr>
				</thead>
			</table>

		</div>


		<div data-options="region:'south',title:'',iconCls:'icon-ok'" style="width:1000px;height:350px">

			<a href="javascript:saveGroup2User()" class="easyui-linkbutton" iconCls="icon-add" style="padding-left:900px;">关联</a>

			<div id="group2resourceTb" style="padding:5px;height:auto">
				<div>
					用户组名称: <input id="s_group_code_queryId" class="easyui-validatebox" style="width:80px" data-options="required:false">

					州市机关: <input class="easyui-combobox" name="s_taxorgsupcode" id="s_taxorgsupcode" data-options="
									disabled:false,
									width:100,
									panelWidth: 300,
									panelHeight: 400
								">
					区县机关: <input class="easyui-combobox" name="s_taxorgcode" id="s_taxorgcode" data-options="
									disabled:false,
									width:100,
									panelWidth: 300,
									panelHeight: 400
								">
					主管部门: <input class="easyui-combobox" name="s_taxdeptcode" id="s_taxdeptcode" data-options="
									disabled:false,
									width:100,
									panelWidth: 300,
									panelHeight: 400
								">
					税收管理员: <input class="easyui-combobox" name="s_taxmanagercode" id="s_taxmanagercode" data-options="
									disabled:false,
									width:100,
									panelWidth: 300,
									panelHeight: 400
								">					
					<a href="javascript:queryGroup2UserList()" class="easyui-linkbutton" iconCls="icon-search">查询</a>
					<a href="javascript:deleteGroup2Resource()" class="easyui-linkbutton" iconCls="icon-cancel">删除</a>
				</div>
			</div>

			<table id="group2userListId" class="easyui-datagrid" title="用户组与用户关联列表" style="width:995px;height:255px"
					data-options="fitColumns:true,striped:true,rownumbers:true,singleSelect:false,pagination:true,url:'/Group2UserMgrService/getGroup2UserList.do',toolbar:'#group2resourceTb'">
				<thead>
					<tr>
						<th data-options="field:'ck3',checkbox:true"></th>
						<th data-options="field:'group_code',width:50">用户组名称</th> 
						<th data-options="field:'group_describe',width:100">用户组描述</th>
						<th data-options="field:'taxempcode',width:50">用户代码</th>
						<th data-options="field:'taxempname',width:50">用户名称</th>
					</tr>
				</thead>
			</table>

		</div>

</div>




</body>
</html>
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
	
    <title>用户组与资源关联维护</title>


    <script>


	$(function(){
		var groupListId = $('#groupListId').datagrid('getPager');  
			$(groupListId).pagination({  
				pageSize: 15,//每页显示的记录条数，默认为10  
				pageList: [15],//可以设置每页记录条数的列表  
				showPageList:false
			}); 

		var resourceListId = $('#resourceListId').datagrid('getPager');  
			$(resourceListId).pagination({  
				pageSize: 15,//每页显示的记录条数，默认为10  
				pageList: [15],//可以设置每页记录条数的列表  
				showPageList:false
			}); 

		var group2resourceListId = $('#group2resourceListId').datagrid('getPager');  
			$(group2resourceListId).pagination({  
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

		function queryResourceList(){
			var brandName =  $('#resourceName').val();
			var leaf_type =  $('#resourceType').combobox('getValue');
			var resource_content =  $('#resourceContent').val();
			$('#resourceListId').datagrid('load',{"brandName":brandName,"leaf_type":leaf_type,"resource_content":resource_content}); 
		
		}

		function formatter1(value,row,index){
				if (row.leaf_type == "2"){
					return "目录";
				}
				if (row.leaf_type == "3"){
					return "菜单";
				}
				if (row.leaf_type == "1"){
					return "do资源";
				}
		}

		function queryGroup2ResourceList(){
			var group_code_queryId =  $('#s_group_code_queryId').val();
			var group_describe_queryId =  $('#s_group_describe_queryId').val();
			var brandName =  $('#s_resourceName').val();
			var leaf_type =  $('#s_resourceType').combobox('getValue');
			var resource_content =  $('#s_resourceContent').val();
			//alert(role_code_queryId);
			//alert(role_describe_queryId);
			//alert(brandName);
			//alert(leaf_type);
			//alert(resource_content);
			$('#group2resourceListId').datagrid('load',{"group_code_queryId":group_code_queryId,"group_describe_queryId":group_describe_queryId,"brandName":brandName,"leaf_type":leaf_type,"resource_content":resource_content}); 
		
		}

		function saveGroup2Resource(){
			var group_rows = $('#groupListId').datagrid('getChecked');
			var resource_rows = $('#resourceListId').datagrid('getChecked');
			var sendData = {"group_rows":group_rows,"resource_rows":resource_rows};
			if(group_rows.length <= 0){
				$.messager.alert('提示','请先选择需要关联的用户组记录!');
				return ;
			}
			if(resource_rows.length <= 0){
				$.messager.alert('提示','请先选择需要关联的资源记录!');
				return ;
			}
			$.ajax({
				   type: "post",
				   url: "/Group2ResourceMgrService/save.do",
				   data: $.toJSON(sendData),
				   contentType: "application/json; charset=utf-8",
				   dataType: "json",
				   success: function(jsondata){
						$.messager.alert('提示','保存成功!');
						queryGroup2ResourceList();
				   }
		    });
		

		}

		function saveGroup2Resource(){
			var group_rows = $('#groupListId').datagrid('getChecked');
			var resource_rows = $('#resourceListId').datagrid('getChecked');
			var sendData = {"group_rows":group_rows,"resource_rows":resource_rows};
			if(group_rows.length <= 0){
				$.messager.alert('提示','请先选择需要关联的用户组记录!');
				return ;
			}
			if(resource_rows.length <= 0){
				$.messager.alert('提示','请先选择需要关联的资源记录!');
				return ;
			}
			$.ajax({
				   type: "post",
				   url: "/Group2ResourceMgrService/save.do",
				   data: $.toJSON(sendData),
				   contentType: "application/json; charset=utf-8",
				   dataType: "json",
				   success: function(jsondata){
						$.messager.alert('提示','保存成功!');
						queryGroup2ResourceList();
				   }
		    });

		}

		function deleteGroup2Resource(){
			var group2resource_rows = $('#group2resourceListId').datagrid('getChecked');
			if(group2resource_rows.length <= 0){
				$.messager.alert('提示','请先选择需要删除的记录!');
				return;
			}
			var sendData = {"group2resource_rows":group2resource_rows};
			$.ajax({
				   type: "post",
				   url: "/Group2ResourceMgrService/delete.do",
				   data: $.toJSON(sendData),
				   contentType: "application/json; charset=utf-8",
				   dataType: "json",
				   success: function(jsondata){
						$.messager.alert('提示','删除成功!');
						queryGroup2ResourceList();
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
					data-options="fitColumns:true,striped:true,rownumbers:true,singleSelect:false,pagination:true,url: '/Group2ResourceMgrService/getGroupList.do',toolbar:'#groupTb'">
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
					资源名称: <input id="resourceName" class="easyui-validatebox" style="width:80px" data-options="required:false">&nbsp;&nbsp;&nbsp;&nbsp;
					资源类型: <select id="resourceType" class="easyui-combobox" panelHeight="auto" style="width:100px">
						<option value=""></option>
						<option value="2">目录</option>
						<option value="3">菜单</option>
						<option value="1">do资源</option>
					</select>&nbsp;&nbsp;&nbsp;&nbsp;
					资源内容: <input id="resourceContent" class="easyui-validatebox" style="width:80px" data-options="required:false">&nbsp;&nbsp;&nbsp;&nbsp;
					<a href="javascript:queryResourceList()" class="easyui-linkbutton" iconCls="icon-search">查询</a>
				</div>
			</div>

			<table id="resourceListId" class="easyui-datagrid" title="系统资源列表" style="width:575px;height:295px"
					data-options="fitColumns:true,striped:true,rownumbers:true,singleSelect:false,pagination:true,url:'/Group2ResourceMgrService/getResourceList.do',toolbar:'#resourceTb'">
				<thead>
					<tr>
						<th data-options="field:'ck2',checkbox:true"></th>
						<th data-options="field:'brandName',width:150">资源名称</th>
						<th data-options="field:'leaf_type',width:100,formatter:formatter1">资源类型</th>
						<th data-options="field:'resource_content',width:250">资源内容</th>
					</tr>
				</thead>
			</table>

		</div>


		<div data-options="region:'south',title:'',iconCls:'icon-ok'" style="width:1000px;height:350px">

			<a href="javascript:saveGroup2Resource()" class="easyui-linkbutton" iconCls="icon-add" style="padding-left:900px;">关联</a>

			<div id="group2resourceTb" style="padding:5px;height:auto">
				<div>
					用户组名称: <input id="s_group_code_queryId" class="easyui-validatebox" style="width:80px" data-options="required:false">&nbsp;&nbsp;&nbsp;&nbsp;
					用户描述: <input id="s_group_describe_queryId" class="easyui-validatebox" style="width:80px" data-options="required:false">&nbsp;&nbsp;&nbsp;&nbsp;
					资源名称: <input id="s_resourceName" class="easyui-validatebox" style="width:80px" data-options="required:false">&nbsp;&nbsp;&nbsp;&nbsp;
					资源类型: <select id="s_resourceType" class="easyui-combobox" panelHeight="auto" style="width:100px">
						<option value=""></option>
						<option value="2">目录</option>
						<option value="3">菜单</option>
						<option value="1">do资源</option>
					</select>&nbsp;&nbsp;&nbsp;&nbsp;
					资源内容: <input id="s_resourceContent" class="easyui-validatebox" style="width:80px" data-options="required:false">&nbsp;&nbsp;&nbsp;&nbsp;
					<a href="javascript:queryGroup2ResourceList()" class="easyui-linkbutton" iconCls="icon-search">查询</a>&nbsp;&nbsp;&nbsp;&nbsp;
					<a href="javascript:deleteGroup2Resource()" class="easyui-linkbutton" iconCls="icon-cancel">删除</a>
				</div>
			</div>

			<table id="group2resourceListId" class="easyui-datagrid" title="用户组与资源关联列表" style="width:995px;height:255px"
					data-options="fitColumns:true,striped:true,rownumbers:true,singleSelect:false,pagination:true,url:'/Group2ResourceMgrService/getGroup2ResourceList.do',toolbar:'#group2resourceTb'">
				<thead>
					<tr>
						<th data-options="field:'ck3',checkbox:true"></th>
						<th data-options="field:'group_code',width:50">用户组名称</th> 
						<th data-options="field:'group_describe',width:100">用户组描述</th>
						<th data-options="field:'brandName',width:50">资源名称</th>
						<th data-options="field:'leaf_type',width:50,formatter:formatter1">资源类型</th>
						<th data-options="field:'resource_content',width:150">资源内容</th>
					</tr>
				</thead>
			</table>

		</div>

</div>




</body>
</html>
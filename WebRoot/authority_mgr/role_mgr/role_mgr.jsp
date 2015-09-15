<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
	<link rel="stylesheet" href="/themes/sunny/easyui.css">
	<link rel="stylesheet" href="/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="/css/tablen.css">

	
	<script src="/js/jquery-1.8.2.min.js"></script>
	<script src="/js/jquery.easyui.min.js"></script>
	<script src="/js/jquery.json-2.2.js"></script>
	<script src="/js/easyui-lang-zh_CN.js"></script>


</head>
<style>
</style>
<body>
	<div style="margin:10px 0;"></div>

	<div id="tb" style="padding:5px;height:auto">
		<div>
			角色名称: <input id="role_code_queryId" class="easyui-validatebox" style="width:80px" data-options="required:false">&nbsp;&nbsp;&nbsp;&nbsp;
			角色描述: <input id="role_describe_queryId" class="easyui-validatebox" style="width:80px" data-options="required:false">&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="javascript:query()" class="easyui-linkbutton" iconCls="icon-search">查询</a>&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="javascript:add()" class="easyui-linkbutton" iconCls="icon-add">增加</a>&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="javascript:deleteRow()" class="easyui-linkbutton" iconCls="icon-cancel">删除</a>
		</div>
	</div>

	<table id="dg" class="easyui-datagrid" title="系统角色列表" style="width:800px;height:450px"
			data-options="rownumbers:true,sortable:true,singleSelect:false,pagination:true,url:'/RoleMgrService/getRoleList.do',toolbar:'#tb'">
		<thead>
			<tr>
				<th data-options="field:'ck1',checkbox:true"></th>
				<th data-options="field:'role_code',width:150">角色名称</th>
				<th data-options="field:'role_describe',width:400">角色描述</th>
			</tr>
		</thead>
	</table>

	<div id="w" class="easyui-window" title="新增窗口" data-options="iconCls:'icon-save',closed:true,draggable:false,minimizable:false,maximizable:false" style="width:700px;height:500px;padding:10px;">

		<div style="margin:10px;"></div>
		<div class="easyui-panel" title="" style="width:600px">
			<div style="padding:10px">
			<form id="saveForm" method="post">
				<table class="table table-bordered">
					<tr>
						<td align="right">角色名称</td>
						<td><input type="text" name="role_code" id="role_code"></input></td>

						<td align="right">是否可用:</td>
						<td>
							<select class="easyui-combobox" name="enabled" id="enabled">
								<option value="1">是</option>
								<option value="0">否</option>
							</select>					
						</td>

					</tr>
			
					<tr>
						<td align="right">角色描述:</td>
						<td colspan="3"><textarea name="role_describe" id="role_describe" style="width:400px;height:60px;"></textarea></td>
					</tr>
				</table>
			</form>
			</div>
			<div style="text-align:center;padding:5px">
				<a href="javascript:void(0)" class="easyui-linkbutton" onclick="save()">保存</a>
			</div>
		</div>

	</div>



	<script type="text/javascript">
		$(function(){
			var p = $('#dg').datagrid('getPager');  
				$(p).pagination({  
					pageSize: 15,//每页显示的记录条数，默认为10  
					pageList: [15],//可以设置每页记录条数的列表  
					showPageList:false
				}); 
					

		$('#w').window({
		onClose:function(){ //当面板关闭之前触发的事件 
					
				//	$('#w').destroy();
		} 
		}); 



		})

		function query(){
			var role_code_queryId =  $('#role_code_queryId').val();
			var role_describe_queryId =  $('#role_describe_queryId').val();
			$('#dg').datagrid('load',{"role_code_queryId":role_code_queryId,"role_describe_queryId":role_describe_queryId}); 
		
		}


		function add(){
			$('#w').window('open');
			$('#role_code').attr("value","");
			$('#enabled').attr("value","1");
			$('#role_describe').attr("value","");
		}

		function save(){ 
				if($('#role_code').val() == null || $('#role_code').val() == ""){
					$.messager.alert('提示','角色名称不能为空!');
					return ;	
				}

				var params = {};
				var fields =$('#saveForm').serializeArray(); //自动序列化表单元素为JSON对象
				$.each( fields, function(i, field){
					params[field.name] = field.value;
				}); 
				//alert($.toJSON(params));
					
				$.ajax({
					   type: "post",
					   url: "/RoleMgrService/save.do",
					   data: params,
					   dataType: "json",
					   success: function(jsondata){
						   if(jsondata == "00"){
								$.messager.alert('提示','保存成功!');
								query();
						   }
					   }
			   });
			
		}
		function deleteRow(){
			var role_rows = $('#dg').datagrid('getChecked');
			if(role_rows.length <= 0){
				$.messager.alert('提示','请先选择需要删除的记录!');
				return ;
			}
			var sendData = {"role_rows":role_rows};
			$.ajax({
				   type: "post",
				   url: "/RoleMgrService/delete.do",
				   data: $.toJSON(sendData),
				   contentType: "application/json; charset=utf-8",
				   dataType: "json",
				   success: function(jsondata){
						$.messager.alert('提示','删除成功!');
						query();
				   }
		    });
		
		}
	</script>
</body>
</html>
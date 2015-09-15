<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
	<link rel="stylesheet" href="/themes/sunny/easyui.css">
	<link rel="stylesheet" href="/themes/icon.css">
	<link rel="stylesheet" href="/css/tablen.css">

	
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
			资源名称: <input id="resourceName" class="easyui-validatebox" style="width:80px" data-options="required:false">&nbsp;&nbsp;&nbsp;&nbsp;
			资源类型: <select id="resourceType" class="easyui-combobox" panelHeight="auto" style="width:100px">
				<option value=""></option>
				<option value="2">目录</option>
				<option value="3">菜单</option>
				<option value="1">do资源</option>
			</select>&nbsp;&nbsp;&nbsp;&nbsp;
			资源内容: <input id="resourceContent" class="easyui-validatebox" style="width:80px" data-options="required:false">&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="javascript:query()" class="easyui-linkbutton" iconCls="icon-search">查询</a>&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="javascript:add()" class="easyui-linkbutton" iconCls="icon-add">增加</a>&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="javascript:deleteRow()" class="easyui-linkbutton" iconCls="icon-cancel">删除</a>
		</div>
	</div>

	<table id="dg" class="easyui-datagrid" title="系统资源列表" style="width:800px;height:450px"
			data-options="rownumbers:true,sortable:true,singleSelect:false,pagination:true,url:'/ResourceMgrService/getResourceList.do',toolbar:'#tb'">
		<thead>
			<tr>
				<th data-options="field:'ck1',checkbox:true"></th>
				<th data-options="field:'brandName',width:150">资源名称</th>
				<th data-options="field:'leaf_type',width:100,formatter:formatter1">资源类型</th>
				<th data-options="field:'resource_content',width:350">资源内容</th>
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
						<td align="right">资源名称:</td>
						<td><input type="text" name="brandName" id="brandName"></input></td>

						<td align="right">是否可用:</td>
						<td>
							<select class="easyui-combobox" name="enabled" id="enabled">
								<option value="1">是</option>
								<option value="0">否</option>
							</select>					
						</td>

					</tr>
					<tr>
						<td align="right">资源类型:</td>
						<td>
							<select class="easyui-combobox" name="resource_type" id="resource_type">
								<option value="00">url 页面路径</option>
								<option value="01">.do功能路径</option>
							</select>					
						</td>

						<td align="right">资源路径:</td>
						<td><input type="text" name="resource_content" id="resource_content" style="width:200px"></input></td>
					</tr>
					<tr>
						<td align="right">是否功能目录:</td>
						<td>
							<select class="easyui-combobox" name="isFunc" id="isFunc">
								<option value="00">功能目录</option>
								<option value="01">功能菜单</option>
							</select>						
						</td>

						<td align="right">所在功能目录:</td>
						<td>
							<input class="easyui-combobox" name="parent_menu_id" id="parent_menu_id" data-options="
										disabled:true,
										url: '/ResourceMgrService/getFuncMenuTops.do',
										valueField: 'value',
										textField: 'text',
										panelWidth: 300,
										panelHeight: 'auto'
									">					
						</td>
					</tr>


					<tr>
						<td align="right">排序串:</td>
						<td colspan="3"><input type="text" name="sort_str" id="sort_str"></input></td>


					</tr>

					<tr>
						<td align="right">是否两块:</td>
						<td>
							<select class="easyui-combobox" name="isDouble" id="isDouble">
								<option value="yes">是</option>
								<option value="no">否</option>
							</select>	
						</td>

						<td align="right">背景颜色:</td>
						<td><input type="text" name="bgColor" id="bgColor"></input></td>
					</tr>

					<tr>
						<td align="right">图标路径:</td>
						<td colspan="3"><input type="text" name="imgSrc" id="imgSrc"></input></td>


					</tr>

					<tr>
						<td align="right">资源描述:</td>
						<td colspan="3"><textarea name="resouce_describe" id="resouce_describe" style="width:400px;height:60px;"></textarea></td>
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
			$("#resource_content").attr("disabled","disabled"); 
			var p = $('#dg').datagrid('getPager');  
				$(p).pagination({  
					pageSize: 15,//每页显示的记录条数，默认为10  
					pageList: [15],//可以设置每页记录条数的列表  
					showPageList:false
				}); 
					

			 $("#resource_type").combobox({  
				 //相当于html >> select >> onChange事件  
				 onChange:function(n,o){  
					 if(n == "00"){
							//alert($("#isFunc").combobox("getValue"));
						$("#isFunc").combobox("enable");
						//$("#parent_menu_id").combobox({disabled:false});
						$("#brandName").removeAttr("disabled"); 
						$("#sort_str").removeAttr("disabled"); 
						$("#isDouble").combobox({disabled:false});
						$("#bgColor").removeAttr("disabled"); 
						$("#imgSrc").removeAttr("disabled"); 
						if($("#isFunc").combobox("getValue") == "00"){
							$("#parent_menu_id").combobox("disable");	
							$("#resource_content").attr("disabled","disabled"); 
						}else{
							$("#resource_content").removeAttr("disabled"); 
							//$("#parent_menu_id").combobox("enable");
						}	
					 }else{
					//	 alert($("#sort_str").val());
							//alert($("#isFunc").combobox("getValue"));
						$("#isFunc").combobox("disable");
						//$("#parent_menu_id").combobox({disabled:true});
						$("#brandName").attr("disabled","disabled"); 
						$("#sort_str").attr("disabled","disabled"); 
						$("#isDouble").combobox({disabled:true});
						$("#bgColor").attr("disabled","disabled"); 
						$("#imgSrc").attr("disabled","disabled"); 
						$("#parent_menu_id").combobox("disable");	
						$("#resource_content").removeAttr("disabled"); 
						//$("#resource_content").attr("disabled","disabled"); 
					 }
				 } 
			 }) 

			 $("#isFunc").combobox({  
				 //相当于html >> select >> onChange事件  
				 onChange:function(n,o){  
					 if(n == "00"){
						$("#parent_menu_id").combobox("disable");	
						$("#resource_content").attr("disabled","disabled"); 
						if($("#resource_type").combobox("getValue") == "01"){
							$("#parent_menu_id").combobox("disable");	
							//$("#resource_content").attr("disabled","disabled"); 
						}
					 }else{
						$("#parent_menu_id").combobox("enable");
						$("#resource_content").removeAttr("disabled"); 
						if($("#resource_type").combobox("getValue") == "01"){
							$("#parent_menu_id").combobox("disable");	
							$("#resource_content").attr("disabled","disabled"); 
						}				
					 }
				 } 
			 }) 

		$('#w').window({
		 onClose:function(){ //当面板关闭之前触发的事件 
					
				//	$('#w').destroy();
		} 
		}); 



		})

		function query(){
			var brandName =  $('#resourceName').val();
			var leaf_type =  $('#resourceType').combobox('getValue');
			var resource_content =  $('#resourceContent').val();
			$('#dg').datagrid('load',{"brandName":brandName,"leaf_type":leaf_type,"resource_content":resource_content}); 
		
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

		function add(){
			$('#w').window('open');
			$('#brandName').attr("value","");
			$('#enabled').attr("value","1");
			$('#resource_type').attr("value","00");
			$('#resource_content').attr("value","");
			$('#isFunc').attr("value","");
			$('#parent_menu_id').attr("value","");
			$('#sort_str').attr("value","");
			$('#isDouble').attr("value","yes");
			$('#bgColor').attr("value","");
			$('#imgSrc').attr("value","");
			$('#resouce_describe').attr("value","");

		}

		function save(){
				var resource_type = $('#resource_type').val();
				//alert($('#isFunc').val());
 
				if($('#resource_type').combobox('getValue') == "00"){
					if($('#isFunc').combobox('getValue') == "00"){
						if($('#brandName').val() == ""){
							$.messager.alert('提示','资源名称不能为空!');
							//$('#brandName').focus();
							return;
						}	
						if($('#sort_str').val() == ""){
							$.messager.alert('提示','排序串不能为空!');
							return;
						}
						if($('#bgColor').val() == ""){
							$.messager.alert('提示','背景颜色不能为空!');
							return;
						}	
						if($('#imgSrc').val() == ""){
							$.messager.alert('提示','图标路径不能为空!');
							return;
						}						
					}
					if($('#isFunc').combobox('getValue') == "01"){
						if($('#brandName').val() == ""){
							$.messager.alert('提示','资源名称不能为空!');
							//$('#brandName').focus();
							return;
						}	
						if($('#resource_content').val() == ""){
							$.messager.alert('提示','资源路径不能为空!');
							return;
						}	
						
						if($('#parent_menu_id').combobox('getValue') == ""){
							$.messager.alert('提示','所在功能目录不能为空!');
							return;
						}	
						if($('#sort_str').val() == ""){
							$.messager.alert('提示','排序串不能为空!');
							return;
						}
						if($('#bgColor').val() == ""){
							$.messager.alert('提示','背景颜色不能为空!');
							return;
						}	
						if($('#imgSrc').val() == ""){
							$.messager.alert('提示','图标路径不能为空!');
							return;
						}						
					}
				
				}


				var params = {};
				var fields =$('#saveForm').serializeArray(); //自动序列化表单元素为JSON对象
				$.each( fields, function(i, field){
					params[field.name] = field.value;
				}); 
				//alert($.toJSON(params));
					
				$.ajax({
					   type: "post",
					   url: "/ResourceMgrService/save.do",
					   data: params,
					   dataType: "json",
					   success: function(jsondata){
						   if(jsondata == "00"){
								$.messager.alert('提示','保存成功!');
								query();
								$('#parent_menu_id').combobox('reload'); 
						   }
					   }
			   });
			
		}
		function deleteRow(){

			var resource_rows = $('#dg').datagrid('getChecked');
			if(resource_rows.length <= 0){
				$.messager.alert('提示','请先选择需要删除的记录!');
				return ;
			}
			var sendData = {"resource_rows":resource_rows};
			$.ajax({
				   type: "post",
				   url: "/ResourceMgrService/delete.do",
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
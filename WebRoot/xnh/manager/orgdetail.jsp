<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
	<base target="_self"/>
	<title></title>

	<link rel="stylesheet" href="<%=request.getContextPath()%>/themes/sunny/easyui.css">
	<link rel="stylesheet" href="<%=request.getContextPath()%>/themes/icon.css">
	<link rel="stylesheet" href="<%=request.getContextPath()%>/css/toolbar.css">
	<link rel="stylesheet" href="<%=request.getContextPath()%>/css/logout.css"/>
	<script src="<%=request.getContextPath()%>/js/jquery-1.8.2.min.js"></script>
	<script src="<%=request.getContextPath()%>/js/jquery.easyui.min.js"></script>
    <script src="<%=request.getContextPath()%>/js/tiles.js"></script>
    <script src="<%=request.getContextPath()%>/js/moduleWindow.js"></script>
	<script src="<%=request.getContextPath()%>/menus.js"></script>
	
	<script src="<%=request.getContextPath()%>/js/jquery.simplemodal.js"></script>
	<script src="<%=request.getContextPath()%>/js/overlay.js"></script>
	<script src="<%=request.getContextPath()%>/js/jquery.json-2.2.js"></script>
	<script src="<%=request.getContextPath()%>/js/json2.js"></script>
	<script src="<%=request.getContextPath()%>/locale/easyui-lang-zh_CN.js"></script>

	
</head>
<body>
<script>
	
	$(function(){
		//alert(opttype);
		$.ajax({
		   type: "post",
			async:false,
		   url: "/ComboxService/gettaxorgtree.do",
		   dataType: "json",
		   success: function(jsondata){
			  orgtree= jsondata;
		   }
		});
		//alert(opttype);
		if(opttype=='modify'){
			var row = $('#orginfogrid').datagrid('getSelected');
			$.ajax({
			   type: "post",
			   url: "<%=request.getContextPath()%>/Manager/getorg.do",
			   data: {taxorgcode:row.taxorgcode},//获取户主信息
			   dataType: "json",
			   success: function(jsondata){
					$('#orgform').form('load',jsondata);
			   }
			});
		}
		$('#cc').combotree({
			data : orgtree,
			valueField:'id',
			textField:'text'
		});
	});

	function save(){
		if(!$('#q-taxorgname').validatebox('isValid')){
			$.messager.alert('提示','医疗机构名称不能为空！');
			return;
		}
		var temp =$('#cc').combotree('getValue');
		if(temp==null || temp==''){
			$.messager.alert('提示','上级医疗机构不能为空！');
			return;
		}
		var params = {};
		var fields =$('#orgform').serializeArray();
		$.each( fields, function(i, field){
			params[field.name] = field.value;
		}); 
		$.ajax({
			type: "post",
			url: "/Manager/saveorg.do",
			data: params,
			dataType: "json",
			success: function(jsondata){
				$.messager.alert('返回消息',"保存成功");
				query();
				$('#orgwindow').window('close');
			},
			error:function (data, status, e){   
				$.messager.alert('返回消息',"保存出错");   
			}   
		});
	}
	</script>
	<form id="orgform" method="post">
		<div title="登记信息" data-options="" style="overflow:auto">
			<table  width="100%" class="table table-bordered">
					<input id="taxorgcode"  type="hidden" name="taxorgcode"/>	
					<tr>
						<td align="right">医疗机构名称：</td>
						<td>
							<input class="easyui-validatebox" name="taxorgname" id="q-taxorgname" style="width:200px;" data-options="required:true"/>					
						</td>
						
					</tr>
					<tr>
						<td align="right">上级医疗机构：</td>
						<td>
							<select id="cc" class="easyui-combotree" style="width:200px;"  data-options="required:true" name="parentId"></select>				
						</td>
					</tr>
					<tr>
						<td align="right">有效标识：</td>
						<td>
							<select id="valid" class="easyui-combobox" name="valid" style="width:200px;" data-options="required:true" editable="false">
								<option value="01">有效</option>
								<option value="00">无效</option>
							</select>
						</td>
					</tr>
				</table>
				<div style="text-align:center;padding:5px;height: 25px;" >
				<a  id="btn2" class="easyui-linkbutton" icon="icon-save"  onclick="save()">保存</a>
			</div>
		</div>
	</form>
</body>
</html>
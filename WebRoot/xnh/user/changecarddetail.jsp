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
		if(opttype=='modify'){
			var row = $('#userinfogrid').datagrid('getSelected');
			$.ajax({
			   type: "post",
			   url: "<%=request.getContextPath()%>/Userinfo/getUnioninfo.do",
			   data: {user_id:row.user_id},//获取户主信息
			   dataType: "json",
			   success: function(jsondata){
					$('#sotremainform').form('load',jsondata);
			   }
			});
		}
	});
	

	var genderdata = [{label:'01',name:'男'},{label:'02',name:'女'}];
	function formatgender(row){
		for(var i=0; i<genderdata.length; i++){
			if (genderdata[i].label == row) return genderdata[i].name;
		}
		return row;
	}
	
	function save(){
		var params = {};
		var fields =$('#sotremainform').serializeArray();
		$.each( fields, function(i, field){
			params[field.name] = field.value;
		});
		$.ajax({
			   type: "post",
			   url: "<%=request.getContextPath()%>/Userinfo/updateUnioninfo.do",
			   data: params,
			   dataType: "json",
			   success: function(jsondata){
				   $('#userinfogrid').datagrid('reload');
				   $.messager.alert('返回消息','保存成功');
				   $('#userwindow').window('close');
			   },
				error:function (data, status, e){   
					 $.messager.alert('返回消息',"保存出错!");   
				} 
	   });
	}
	</script>
	<form id="sotremainform" method="post">
		<div title="登记信息" data-options="" style="overflow:auto">
			<table  width="100%" class="table table-bordered">
					<input id="user_id"  type="hidden" name="user_id"/>	
					<tr>
						<td align="right">原卡号：</td>
						<td>
							<input class="easyui-validatebox" name="card_id" id="card_id" style="width:200px;"  readonly="true"/>					
						</td>
						<td align="right">新卡号：</td>
						<td>
							<input class="easyui-validatebox" name="new_card_id" id="new_card_id" style="width:200px;"  data-options="required:true"/>					
						</td>
					</tr>
				</table>
				<div style="text-align:center;padding:5px;">  
					<a href="###" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save()">保存</a>
					<!-- <a href="#" class="easyui-linkbutton" id="aaa" data-options="iconCls:'icon-search'" >查询</a> -->
				</div>
		</div>
	</form>
		
</body>
</html>
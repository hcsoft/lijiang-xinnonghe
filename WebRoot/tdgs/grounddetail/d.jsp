<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<%@ include file="/common/inc.jsp"%>
<html>
<head>

	<title>Complex Layout - jQuery EasyUI Demo</title>

	<link rel="stylesheet" href="<%=spath%>/themes/default/easyui.css">
	<link rel="stylesheet" href="<%=spath%>/themes/icon.css">
	<link rel="stylesheet" href="<%=spath%>/css/toolbar.css">
	<link rel="stylesheet" href="<%=spath%>/css/logout.css"/>
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
</head>   
<body>
<script>
		$(function(){
			//var tdxxrow = $('#tdxxgrid').datagrid('getSelected');
			if(showtype=='0'){
				$('#dbtn').hide();
			}
			$.ajax({
			   type: "post",
			   url: "/GroundInfoServlet/getchangeinfo.do",
			   data: {uuid:estateid},//ff171602b950f4ca5123c5c9edadc9d4
			  // data: {uuid:'ff171602b950f4ca5123c5c9edadc9d4'},//ff171602b950f4ca5123c5c9edadc9d4
			   dataType: "json",
			   success: function(jsondata){
				  $('#tdjsxxform').form('load',jsondata);
			   }
			});
		});

		//提交
	function savejsxx(){
		var tdxxrow = $('#groundgathercheckgrid').datagrid('getSelected');
		//if(tdxxrow){
			//alert('bbbb');
			//var submitinfo = new Object();
			if(!$('#tdjsxxform').form('validate')){
					return;
			};
			var params = {};
			var fields =$('#tdjsxxform').serializeArray(); //自动序列化表单元素为JSON对象
			$.each( fields, function(i, field){
				params[field.name] = field.value;
			}); 
			params.estateid=estateid;
			params.taxpayerid = tdxxrow.taxpayerid;
			$.ajax({
					   type: "post",
					   url: "/GroundInfoServlet/savechangeinfo.do",
					   data: params,
					   dataType: "json",
					   success: function(jsondata){
							alert("保存成功");
					   },
						error:function (data, status, e){   
							 alert("保存出错");   
						} 
			});
		//}
	}
$.extend($.fn.validatebox.defaults.rules, {   
		datecheck: {   
			validator: function(value){ 
				return /^((((1[6-9]|[2-9]\d)\d{2})-(0?[13578]|1[02])-(0?[1-9]|[12]\d|3[01]))|(((1[6-9]|[2-9]\d)\d{2})-(0?[13456789]|1[012])-(0?[1-9]|[12]\d|30))|(((1[6-9]|[2-9]\d)\d{2})-0?2-(0?[1-9]|1\d|2[0-8]))|(((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))-0?2-29-))$/.test(value);
			},   
			message: '时间格式不合法，格式为YYYY-MM-DD 如：2013-01-03'  
		}   
	});
</script>
	<div class="easyui-panel" title="" style="width:1000px">
		<div title="土地减少信息"  style="overflow:auto" border="true">
			<div style="padding:3px 5px;">
				<a href="#" id="dbtn" class="easyui-linkbutton" icon="icon-save" plain="true" onclick="savejsxx()">保存</a>
			</div>
			<form id="tdjsxxform" method="post">
				<input id="changeid"  type="hidden" name="changeid"></input>
				<table id="tdjsxx" width="100%"  class="table table-bordered">
						<tr>
							<td align='right'>减少面积：</td>
							<td><input id="changearea" class="easyui-numberbox" type="text" name="changearea" precision="2" data-options="min:0,required:true" value="0.00"></input>
							</td>
							<td align='right'>减少原因：</td>
							<td>
								<input id="changeareareason" class="easyui-validatebox" type="text" name="changeareareason" data-options="required:true"></input>
							</td>
							<td align='right'>减少时间起：</td>
							<td>
								<input id="changedates" class="easyui-datebox" type="datebox" name="changedates" data-options="required:true,validType:['datecheck']" editable="true"></input>
							</td>
					</tr>
				</table>
			</form>
		</div>
	</div>
</body>
  
</html>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>

	<title>Complex Layout - jQuery EasyUI Demo</title>

	<link rel="stylesheet" href="/themes/default/easyui.css">
	<link rel="stylesheet" href="/themes/icon.css">
	<link rel="stylesheet" href="/css/toolbar.css">
	<link rel="stylesheet" href="/css/logout.css"/>
	<script src="/js/jquery-1.8.2.min.js"></script>
	<script src="/js/jquery.easyui.min.js"></script>
	<script src="/js/dropdown.js"></script>
    <script src="/js/tiles.js"></script>
    <script src="/js/moduleWindow.js"></script>
	<script src="/menus.js"></script>
	
	<script src="/js/jquery.simplemodal.js"></script>
	<script src="/js/overlay.js"></script>
	<script src="/js/jquery.json-2.2.js"></script>
	<script src="/js/json2.js"></script>
	<script src="/locale/easyui-lang-zh_CN.js"></script>
</head>   
<body>
<script>
var storetypedata = new Object;
$(function(){
	$.ajax({
		   type: "post",
			async:false,
		   url: "/ComboxService/getComboxs.do",
		   data: {codetablename:'COD_STOREAPPROVETYPE'},
		   dataType: "json",
		   success: function(jsondata){
			  storetypedata= jsondata;
		   }
		});
});

function next(){
	if($("#fpc").prop("checked") ==false && $("#ddxz").prop("checked")==false){
		$.messager.alert("提示","请选择批复类型！");
	}else{
		$('#groundstorewindow').window('refresh', 'groundstore-01.jsp');
	}
}
function check(a){
	if(a.value=='00'){
		if($("#fpc").prop("checked")==true){
			approvetype = '00';
			$("#ddxz").prop("checked",false);
		}
	}
	if(a.value=='01'){
		if($("#ddxz").prop("checked")==true){
			approvetype = '01';
			$("#fpc").prop("checked",false);
		}
	}
}
</script>
<base target="_self"/>
	<div class="easyui-panel" title="" style="overflow:auto;">
		<form id="ff" method="post">
			<table width="100%" class="table table-bordered">
				<tr>
					<td align="right" style="width:50%">
						批复类型：
					</td>
					<td align="left" style="width:50%">
						<input type="checkbox" id="fpc"   value="00" onclick="check(this)"/>分批次
						<input type="checkbox" id="ddxz"  value="01" onclick="check(this)"/>单独选址
						<!-- <input id="approvetype" name="approvetype" class="easyui-combobox"  editable='false' data-options="
						required:true,
						valueField: 'key',
						textField: 'value',
						data:storetypedata" /> -->
					</td>
				</tr>
			</table>
		</form>
		<div style="text-align:center;padding:1px">
			<a  id="aa" class="easyui-linkbutton" icon="icon-arrow_right" plain="true" onclick="next()">下一步</a>
		</div>
	</div>
</body>
  
</html>
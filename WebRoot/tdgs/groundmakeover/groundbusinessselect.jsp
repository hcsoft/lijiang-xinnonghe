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
	<script src="<%=spath%>/locale/easyui-lang-zh_CN.js"></script>
</head>   
<body>
<script>
var businessdata = new Object;
$(function(){
	$.ajax({
		   type: "post",
			async:false,
		   url: "/TransferGroundServlet/getbusinessComboxs.do",
		   data: {businesstype:combobusinesstype},
		   dataType: "json",
		   success: function(jsondata){
			  businessdata= jsondata;
		   }
		});
});

function next(){
	if($('#businesstype').combo('isValid')){
		businesstype = $('#businesstype').combo('getValue');
		if(combobusinesstype =='0'){//出让和划拨业务数据来源于批复信息，先load批复子表信息
			$('#groundbusinesswindow').window('refresh', 'groundstoresub.jsp');
		}
		//if(businesstype =='13'){//未批先占
		//	$('#groundbusinesswindow').window('refresh', 'groundstoresub.jsp');
		//}
		if(combobusinesstype =='2'){//其他业务数据来源于土地信息
			$('#groundbusinesswindow').window('refresh', 'reginfo.jsp');
		}
		//if(businesstype =='31'){//出租
		//}
	}else{
		alert("请选择业务操作类型！");
	}
}
</script>
<base target="_self"/>
	<div class="easyui-panel" title="" style="overflow:auto;">
		<form id="ff" method="post">
			<table width="100%" class="table table-bordered">
				<tr>
					<td align="right" style="width:50%">
						业务操作类型：
					</td>
					<td align="left" style="width:50%">
						<input id="businesstype" name="businesstype" class="easyui-combobox"  editable='false' data-options="
						required:true,
						valueField: 'key',
						textField: 'value',
						data:businessdata" />
					</td>
				</tr>
			</table>
		</form>
		<div style="text-align:center;padding:1px">
			<a href="#" id="aa" class="easyui-linkbutton" icon="icon-redo" plain="true" onclick="next()">下一步</a>
		</div>
	</div>
</body>
  
</html>
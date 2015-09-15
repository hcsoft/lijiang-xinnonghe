<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1">
    <title></title>
    <link href="/css/default.css" rel="stylesheet" type="text/css" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="/js/jquery/jquery-easyui-1.2.1/themes/default/easyui.css" />
    <link rel="stylesheet" type="text/css" href="/js/jquery/jquery-easyui-1.2.1/themes/icon.css" />
    <script type="text/javascript" src="/js/jquery/jquery-1.4.2.min.js"></script>
    <script type="text/javascript" src="/js/jquery/jquery-easyui-1.2.1/jquery.easyui.pack.js"></script>
	<script type="text/javascript" src="/js/jquery/jquery.json-2.2.js"></script>

<script type="text/javascript">
$(function () { 

}); 


function save(){
	//var r = $('#testForm').form('validate');
	//if(!r) {
	//	return false;
	//}
		var params = {};
		var fields =$('#testForm').serializeArray(); //自动序列化表单元素为JSON对象
		$.each( fields, function(i, field){
			params[field.name] = field.value;
		}); 
		alert($.toJSON(params));
		//return;
			
		$.ajax({
	           type: "post",
	           url: "/TestServlet/test2.do",
	           data: params,
	           dataType: "json",
	           success: function(jsondata){
					alert(jsondata.retStatus);
	           }
	   });
	
}

</script>
</head>
<body>

  <body>
  	<!-- 验证还是jquery-validation好用，这里省事没用 -->
	<form id="testForm" method="post" style="margin: 10;text-align: center;">
		文本框：<input name="name" style="width: 200" validType="length[3,30]" class="easyui-validatebox" required="true"> <br>
		数字框：<input name="age" style="width: 200" type="password"  validType="length[3,30]" class="easyui-validatebox" required="true"> <br>
		<a href="#" id="btn-add" onclick="save()" class="easyui-linkbutton" iconCls="icon-save">保存</a>
	</form>
  </body>




</body>
</html>

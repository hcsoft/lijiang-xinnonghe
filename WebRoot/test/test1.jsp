<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1">
    <title></title>
    <link href="/css/default.css" rel="stylesheet" type="text/css" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="/js/jquery/jquery-easyui-1.2.1/themes/default/easyui.css" />
    <link rel="stylesheet" type="text/css" href="/js/jquery/jquery-easyui-1.2.1/themes/icon.css" />
    <script type="text/javascript" src="/js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="/js/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="/js/jquery.json-2.2.js"></script>

<script type="text/javascript">
$(function () { 

}); 

function comit2server(){

	$.ajax({
	           type: "get",
	           url: "/TestServlet/test1.do",
	           data: {parm1:$("#data1").val(), parm2:$("#data2").val()},
	           dataType: "json",
	           success: function(jsondata){
					alert(jsondata.retStatus);
	           }
	   });

	
}
</script>
</head>
<body>
<table class="t2" border="1" align="center" height="100%" width="960">
	<tr height="24">
		<td>
			数据1<input type="text" id="data1"/>
		</td>
	</tr>
	<tr height="24">
		<td>
			数据2<input type="text" id="data2"/>
		</td>
	</tr>	
	<tr height="24">
		<td>
			<input type="button" value="提交" onclick="comit2server()"/>
		</td>
	</tr>

	
</table>

</body>
</html>

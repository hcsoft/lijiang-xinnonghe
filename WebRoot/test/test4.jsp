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


var data = [{"name":"0a1", "memo":"哈哈哈", "detail":[{"id":"1"}, {"id":"2"}, {"id":"3"}]},{"name":"0a1", "memo":"嘿嘿", "details":[{"id":"4"}, {"id":"4"}, {"id":"5"}]}]

		$.ajax({
	           type: "post",
	           url: "/TestServlet/test4.do",
	           data: $.toJSON(data),
	           contentType: "application/json; charset=utf-8",
	           dataType: "json",
	           success: function(jsondata){
					alert(jsondata);
	           }
	   });
	
}

</script>
</head>
<body>

  <body>
  	<!-- 验证还是jquery-validation好用，这里省事没用 -->
	<form id="testForm" method="post" style="margin: 10;text-align: center;">
var data = [{"name":"0a1", "memo":"哈哈哈", "detail":[{"id":"1"}, {"id":"2"}, {"id":"3"}]},{"name":"0a1", "memo":"嘿嘿", "details":[{"id":"4"}, {"id":"4"}, {"id":"5"}]}]
		<a href="#" id="btn-add" onclick="save()" class="easyui-linkbutton" iconCls="icon-save">保存</a>
	</form>
  </body>




</body>
</html>

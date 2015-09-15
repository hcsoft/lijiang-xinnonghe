<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<%@ include file="/common/inc.jsp"%>
<html>
<head>
    <meta charset="utf-8">
    <link href="<%=spath%>/css/modern.css" rel="stylesheet">
    <link href="<%=spath%>/css/modern-responsive.css" rel="stylesheet">
    <link href="<%=spath%>/css/droptiles.css" rel="stylesheet">
	<link rel="stylesheet" href="<%=spath%>/themes/sunny/easyui.css">
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
	<script src="/js/common.js"></script>

<script type="text/javascript">
$(function () { 

}); 


function save(){
var data2 = {"id":"111","age":"aaa","tel":[{"tel1":"123"},{"tel2":"123"}]};

var data =  [{"name":"aaa","age":"11"},{"name":"bbb","age":"22"},{"name":"ccc","age":"33"},{"name":"ddd","age":"44"}]  

//var cmd = [{"storeId":"0a1", "address":"西斗门路2号", "goods":[{"goodsId":"1"}, {"goodsId":"2"}, {"goodsId":"3"}]},{"storeId":"0a1", "address":"西斗门路2号", "goods":[{"goodsId":"4"}, {"goodsId":"4"}, {"goodsId":"5"}]}]

		$.ajax({
	           type: "post",
	           url: "/TestServlet/test6.do",
	           data: $.toJSON(data2),
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
		var data =  [{"name":"aaa","age":"11"},{"name":"bbb","age":"22"},{"name":"ccc","age":"33"},{"name":"ddd","age":"44"}]  
		<a href="#" id="btn-add" onclick="save()" class="easyui-linkbutton" iconCls="icon-save">保存</a>
	</form>
  </body>



</html>

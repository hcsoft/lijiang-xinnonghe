<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<%@ include file="/common/inc.jsp"%>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
	<link rel="stylesheet" href="<%=spath%>/themes/default/easyui.css">
	<link rel="stylesheet" href="<%=spath%>/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="<%=spath%>/demo/demo.css">
	<script src="<%=spath%>/js/jquery-1.8.2.min.js"></script>
	<script src="<%=spath%>/js/jquery.easyui.min.js"></script>
	<script src="<%=spath%>/js/jquery.json-2.2.js"></script>
</head>
<body>
	<h2>Custom DataGrid Pager</h2>
	<div class="demo-info">
		<div class="demo-tip icon-tip"></div>
		<div>You can append some buttons to the standard datagrid pager bar.</div>
	</div>
	<div style="margin:10px 0;"></div>
	<table id="dg" class="easyui-datagrid" title="Custom DataGrid Pager" style="width:700px;height:450px"
			data-options="rownumbers:true,singleSelect:true,pagination:true,url:'/Test/getItems.do'">
		<thead>
			<tr>
				<th data-options="field:'resource_id',width:80">Item ID</th>
				<th data-options="field:'brandName',width:100">Product</th>
			</tr>
		</thead>
	</table>
	<script type="text/javascript">
		$(function(){
			var p = $('#dg').datagrid('getPager');  
				$(p).pagination({  
					pageSize: 10,//每页显示的记录条数，默认为10  
					pageList: [5,10,15],//可以设置每页记录条数的列表  
					beforePageText: '第',//页数文本框前显示的汉字  
					afterPageText: '页    共 {pages} 页',  
					displayMsg: '当前显示 {from} - {to} 条记录   共 {total} 条记录',  
					/*onBeforeRefresh:function(){ 
						$(this).pagination('loading'); 
						alert('before refresh'); 
						$(this).pagination('loaded'); 
					}*/ 
				});  		
		})
	</script>
</body>
</html>
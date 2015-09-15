<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<%@ include file="/common/inc.jsp"%>
<html>
<head>
	<base target="_self"/>
	<title></title>

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
	<script src="<%=spath%>/locale/easyui-lang-zh_CN.js"></script>

	
</head>
<body>
<script>
	$(function(){
			$('#reginfogrid').datagrid({
				fitColumns:'true',
				maximized:'true',
				pagination:true,
				toolbar:[{
					text:'确定',
					iconCls:'icon-search',
					handler:function(){
						var selectrow = $('#tdczfxx').datagrid('getSelected');
						var index = $('#tdczfxx').datagrid('getRowIndex',selectrow);
						//$('#tdczfxx').datagrid('refreshRow',index);
						var ed = $('#tdczfxx').datagrid('getEditor', {index:index,field:'lesseesid'});
						var ed2 = $('#tdczfxx').datagrid('getEditor', {index:index,field:'lesseestaxpayername'});
						var reg = $('#reginfogrid').datagrid('getSelected');
						ed.target.val(reg.taxpayerid);
						ed2.target.val(reg.taxpayername);
						$('#reginfowindow').window('close');
					}
				}]
			});
			regquery();
			var p = $('#reginfogrid').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
				});
			
		});
	


		function regquery(){
			var params = {};
			var selectrow = $('#tdczfxx').datagrid('getSelected');
			var index = $('#tdczfxx').datagrid('getRowIndex',selectrow);
			var ed = $('#tdczfxx').datagrid('getEditor', {index:index,field:'lesseesid'});
			var ed2 = $('#tdczfxx').datagrid('getEditor', {index:index,field:'lesseestaxpayername'});

			params.taxpayerid = '';
			params.taxpayername = ed2.target.val();
			params.orgunifycode = '';
			var opts = $('#reginfogrid').datagrid('options');
			opts.url = '/InitGroundServlet/getreginfo.do';
			$('#reginfogrid').datagrid('load',params); 
			var p = $('#reginfogrid').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false
			});
			
		}


	function orgformat(row){
		for(var i=0; i<orgdata.length; i++){
			if (orgdata[i].key == row) return orgdata[i].value;
		}
		return row;
	};

	function empformat(row){
		for(var i=0; i<empdata.length; i++){
			if (empdata[i].key == row) return empdata[i].value;
		}
		return row;
	};
	
	</script>
	<form id="groundstorageform" method="post">
		<div title="批复信息" data-options="
						tools:[{
							handler:function(){
								$('#reginfogrid').datagrid('reload');
							}
						}]">
					
						<table id="reginfogrid" style="width:600px;height:400px"
						data-options="iconCls:'icon-edit',singleSelect:true" rownumbers="true"> 
							<thead>
								<tr>
									<th data-options="checkbox:true"></th>
									<th data-options="field:'taxpayerid',width:80,align:'center',editor:{type:'validatebox'}">计算机编码</th>
									<th data-options="field:'taxpayername',width:300,align:'center',editor:{type:'validatebox'}">纳税人名称</th>
									<th data-options="field:'taxdeptcode',width:100,align:'center',editor:{type:'validatebox'}">主管地税部门</th>
									<th data-options="field:'taxmanagercode',width:80,align:'center',editor:{type:'validatebox'}">税收管理员</th>
								</tr>
							</thead>
						</table>
			</div>
	</form>
</body>
</html>
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
				toolbar:[],
				onLoadSuccess:function(data){
					if(!data.rows){
						$('#taxpayerid').val('');
					}else{
						if(opttype=='edit'){
							$('#reginfogrid').datagrid('selectRow',0);
						}
					}
				}
			});
			var p = $('#reginfogrid').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
				});
			if(opttype=='edit'){
				$('#taxpayerid').val(taxpayerid);
				$('#taxpayername').val(taxpayername);
				regquery();
				//$('#reginfogrid').datagrid('selectRow',1);
			}
		});
	


		function regquery(){
			//if($('#taxpayerid').val()=='' || $('#taxpayername').val()=='' || $('#orgunifycode').val()==''){
			//	$.messager.alert('返回消息',"请至少输入一个查询条件！");
			//	return;
			//}
			var params = {};
			params.taxpayerid = $('#taxpayerid').val();
			params.taxpayername = $('#taxpayername').val();
			params.orgunifycode = $('#orgunifycode').val();
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

	function nextstep(){
		var row = $('#reginfogrid').datagrid('getSelected');
		if(row){
			taxpayerid = row.taxpayerid;
			taxpayername = row.taxpayername;
			$('#groundbusinesswindow').window('refresh', '../groundnotapprovehold/groundsell-1.jsp');//未批先占
		}else if($('#taxpayername').val()!=''){
			taxpayerid ='';
			taxpayername = $('#taxpayername').val();
			$('#groundbusinesswindow').window('refresh', '../groundnotapprovehold/groundsell-1.jsp');//未批先占
		}else{
			$.messager.alert('返回消息',"请从税务登记查询中选择受让方或录入纳税人名称！");
		}
	}
	</script>
	<form id="groundstorageform" method="post">
		<div title="受让方基础信息" data-options="" style="overflow:auto">
			<table id="baseinfo" width="100%" class="table table-bordered" >
				<tr>
					<td>
						计算机编码：
					</td>
					<td>
						<input id="taxpayerid" class="easyui-validatebox" type="text" name="taxpayerid" data-options=""></input>
					</td>
					<td>
						纳税人名称：
					</td>
					<td>
						<input id="taxpayername" class="easyui-validatebox" type="text" name="taxpayername" data-options=""></input>
					</td>
					<td>
						组织机构代码：
					</td>
					<td>
						<input id="orgunifycode" class="easyui-validatebox" type="text" name="orgunifycode" data-options=""></input>
					</td>
				</tr>
			</table>
			<div style="text-align:center;padding:5px;">  
					
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-redo'" onclick="nextstep()">下一步</a>
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="regquery()">税务登记查询</a>
			</div>
		</div>
		<div title="" style="overflow:auto" data-options="
						tools:[{
							handler:function(){
								$('#reginfogrid').datagrid('reload');
							}
						}]">
					<table id="reginfogrid" 
					data-options="iconCls:'icon-edit',singleSelect:true" rownumbers="true"> 
						<thead>
							<tr>
								<th data-options="checkbox:true"></th>
								<th data-options="field:'taxpayerid',width:80,align:'center',editor:{type:'validatebox'}">计算机编码</th>
								<th data-options="field:'taxpayername',width:300,align:'center',editor:{type:'validatebox'}">纳税人名称</th>
								<th data-options="field:'taxdeptcode',width:100,align:'center',editor:{type:'validatebox'}">主管地税部门</th>
								<th data-options="field:'taxmanagercode',width:80,align:'center',editor:{type:'validatebox'}">税收管理员</th>
								<th data-options="field:'orgunifycode',width:80,hidden:true,align:'center',editor:{type:'validatebox'}"></th>
							</tr>
						</thead>
					</table>
		</div>
	</form>
</body>
</html>
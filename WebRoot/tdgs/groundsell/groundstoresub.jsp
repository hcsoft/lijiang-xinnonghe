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
			$('#groundstoresubgrid').datagrid({
				fitColumns:'true',
				maximized:'true',
				//pagination:true,
				idField:'landstoreid',
				//view:viewed,
				toolbar:[{
					text:'上一步',
					iconCls:'icon-undo',
					handler:function(){
						$('#groundbusinesswindow').window('close');
					}
				},{
					text:'下一步',
					iconCls:'icon-redo',
					handler:function(){
						var subrow = $('#groundstoresubgrid').datagrid('getSelected');
						if(subrow){
							belongtocountry = subrow.belongtocountry;
							belongtowns = subrow.belongtowns;
							detailaddress = subrow.detailaddress
							maxgroundarea = subrow.areasell;
							landstoresubid = subrow.landstorsubid;
							$('#groundbusinesswindow').window('refresh', 'reginfo.jsp');
						}else{
							$.messager.alert('返回消息',"请选择土地明细信息！");
						}
					}
				}],
				onClickRow:function(index){
				}
			});
			
			var p = $('#groundstoresubgrid').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
				});
			subquery();
		});



		function subquery(){
			var params = {};
			var fields =$('#groundstoresubform').serializeArray();
			$.each( fields, function(i, field){
				params[field.name] = field.value;
			});
			var row = $('#groundsellgrid').datagrid('getSelected');
			params.landstoreid= row.landstoreid;
			var opts = $('#groundstoresubgrid').datagrid('options');
			opts.url = '/GroundSellServlet/getgroundsubinfo.do';
			$('#groundstoresubgrid').datagrid('load',params); 
			var p = $('#groundstoresubgrid').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false
			});
			
		}

	function format(row){
		for(var i=0; i<locationdata.length; i++){
			if (locationdata[i].key == row) return locationdata[i].value;
		}
		return row;
	};

	</script>
	<form id="groundstoresubform" method="post">
		<div title="批复明细" style="overflow:auto" data-options="
						tools:[{
							handler:function(){
								$('#groundstoresubgrid').datagrid('reload');
							}
						}]">
			<table id="groundstoresubgrid" 
			data-options="iconCls:'icon-edit',singleSelect:true,idField:'landstorsubid'" rownumbers="true"> 
				<thead>
					<tr>
						<th data-options="field:'landstorsubid',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
						<th data-options="checkbox:true"></th>
						<th data-options="field:'belongtocountry',width:100,align:'center',formatter:format,editor:{type:'validatebox'}">所属乡镇</th>
						<th data-options="field:'belongtowns',width:100,align:'center',formatter:format,editor:{type:'validatebox'}">坐落位置</th>
						<th data-options="field:'detailaddress',width:100,align:'center',editor:{type:'validatebox'}">详细地址</th>
						<th data-options="field:'areatotal',width:100,align:'center',editor:{type:'combobox'}">收储土地面积</th>
						<th data-options="field:'areasell',width:100,align:'center',editor:{type:'combobox'}">可出让土地面积</th>
					</tr>
				</thead>
			</table>	
		</div>
	</form>
</body>
</html>
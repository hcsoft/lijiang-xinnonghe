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
						$('#groundbusinesswindow').window('refresh', 'groundbusinessselect.jsp');
					}
				},{
					text:'下一步',
					iconCls:'icon-redo',
					handler:function(){
						var subrow = $('#groundstoresubgrid').datagrid('getSelected');
						if(subrow){
							belongtocountrycode = subrow.location;
							maxgroundarea = subrow.areatotal;
							landstoresubid = subrow.landstorsubid;
							$('#groundbusinesswindow').window('refresh', 'reginfo.jsp');
						}else{
							alert("请选择土地明细信息！");
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
			var row = $('#groundtransfergrid').datagrid('getSelected');
			params.landstoreid= row.landstoreid;
			var opts = $('#groundstoresubgrid').datagrid('options');
			opts.url = '/TransferGroundServlet/getgroundsubinfo.do';
			$('#groundstoresubgrid').datagrid('load',params); 
			var p = $('#groundstoresubgrid').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false
			});
			
		}


		function refreshLandstoredetail(){
			var row = $('#groundstoresubgrid').datagrid('getSelected');
			if(row && selectindex != undefined){
				$.ajax({
				   type: "post",
				   url: "/InitGroundServlet/getgroundinfo.do",
				   data: {landstoreid:row.landstoreid},
				   dataType: "json",
				   success: function(jsondata){
					  $('#groundstoragedetailgrid').datagrid('loadData',jsondata);
				   }
				});
			}
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
						<th data-options="field:'location',width:100,align:'center',formatter:format,editor:{type:'validatebox'}">所属乡镇</th>
						<th data-options="field:'areatotal',width:100,align:'center',editor:{type:'combobox'}">土地面积</th>
					</tr>
				</thead>
			</table>	
		</div>
	</form>
</body>
</html>
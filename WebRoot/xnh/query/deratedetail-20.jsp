<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
	<base target="_self"/>
	<title></title>

	<link rel="stylesheet" href="<%=request.getContextPath()%>/themes/sunny/easyui.css">
	<link rel="stylesheet" href="<%=request.getContextPath()%>/themes/icon.css">
	<link rel="stylesheet" href="<%=request.getContextPath()%>/css/toolbar.css">
	<link rel="stylesheet" href="<%=request.getContextPath()%>/css/logout.css"/>
	<script src="<%=request.getContextPath()%>/js/jquery-1.8.2.min.js"></script>
	<script src="<%=request.getContextPath()%>/js/jquery.easyui.min.js"></script>
    <script src="<%=request.getContextPath()%>/js/tiles.js"></script>
    <script src="<%=request.getContextPath()%>/js/moduleWindow.js"></script>
	<script src="<%=request.getContextPath()%>/menus.js"></script>
	
	<script src="<%=request.getContextPath()%>/js/jquery.simplemodal.js"></script>
	<script src="<%=request.getContextPath()%>/js/overlay.js"></script>
	<script src="<%=request.getContextPath()%>/js/jquery.json-2.2.js"></script>
	<script src="<%=request.getContextPath()%>/js/json2.js"></script>
	<script src="<%=request.getContextPath()%>/locale/easyui-lang-zh_CN.js"></script>
	<script src="<%=request.getContextPath()%>/js/datecommon.js"></script>
	
</head>
<body>
<script>
	var editIndex20 = undefined;
	$(function(){
		
		
		$('#deratedetailgrid-20').datagrid({
				singleSelect:'true',
				fitColumns:'true',
				rownumbers:'true',
				pagination:true,
				toolbar:[{
					text:'导出',
					iconCls:'icon-export',
					id:'export',
					handler:function(){
						var index = $('#deratedetailgrid-20').datagrid('getRowIndex',$('#deratedetailgrid-20').datagrid('getSelected'));
						//alert(index);
						if(index >=0){
							$('#deratedetailgrid-20').datagrid('deleteRow', index);    
							editIndex20 = undefined;
						}
					}
				}]
			});
			setTimeout('detailquery20()',100);
		});

	function detailquery20(){
		var params = {};
		var fields =$('#derateform').serializeArray();
		$.each( fields, function(i, field){
			params[field.name] = field.value;
		}); 
		params.user_id= selectid;
		params.derate_type= '20';
		$('#deratedetailgrid-20').datagrid('loadData',{total:0,rows:[]});
		var opts = $('#deratedetailgrid-20').datagrid('options');
		opts.url = '<%=request.getContextPath()%>/Derate/getDeratelist.do';
		$('#deratedetailgrid-20').datagrid('load',params); 
		var p = $('#deratedetailgrid-20').datagrid('getPager');  
		$(p).pagination({   
			showPageList:false,
			pageSize: 15
		});
	}
	</script>
		<form id="derateform" method="post">
			<div title="" style="overflow:auto" data-options="
							tools:[{
								handler:function(){
									$('#deratedetailgrid-20').datagrid('reload');
								}
							}]">
						<table id="deratedetailgrid-20" 
						data-options="iconCls:'icon-edit',singleSelect:true" rownumbers="true"> 
							<thead>
								<tr>
									<th data-options="field:'serialno',width:80,align:'center',hidden:'true'"></th>
									<th data-options="field:'user_id',width:80,align:'center',hidden:'true'"></th>
									<th data-options="field:'derate_type',width:80,align:'center',hidden:'true',editor:{type:'text',options:{required:false}}">减免类型</th>
									<th data-options="field:'derate_date',width:120,align:'center',editor:{type:'datebox',options:{validType:['datecheck'],required:true}}">减免日期</th>
									<th data-options="field:'hospital_begindate',width:120,align:'center',editor:{type:'datebox',options:{validType:['datecheck'],required:true}}">住院起时间</th>
									<th data-options="field:'hospital_enddate',width:120,align:'center',editor:{type:'datebox',options:{validType:['datecheck'],required:true}}">住院止时间</th>
									<th data-options="field:'diagnose',width:120,align:'center',editor:{type:'text',options:{required:false}}">诊断</th>
									<th data-options="field:'actual_amount',width:120,align:'right',formatter:formatnumber,editor:{type:'numberbox',options:{precision:2,min:0,required:true}}">实际医疗费用</th>
									<th data-options="field:'derate_amount',width:120,align:'right',formatter:formatnumber,editor:{type:'numberbox',options:{precision:2,min:0,required:true}}">减免金额</th>
									<th data-options="field:'derate_sumamount',width:120,align:'right',formatter:formatnumber,editor:{type:'numberbox',options:{precision:2,min:0,required:true}}">累计减免金额</th>
									<th data-options="field:'opt_orgcode',width:120,align:'center',formatter:formatorg,editor:{type:'text',options:{required:false}}">医疗机构</th>
									<th data-options="field:'opt_empcode',width:120,align:'center',formatter:formatemp,editor:{type:'text',options:{required:false}}">经办人</th>
								</tr>
							</thead>
						</table>
			</div>
		</form>
</body>
</html>
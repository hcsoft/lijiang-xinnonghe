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
	var editIndex10 = undefined;
	$(function(){
		$('#deratedetailgrid-10').datagrid({
				singleSelect:'true',
				fitColumns:'true',
				rownumbers:'true',
				pagination:true,
				toolbar:[{
					text:'导出',
					id:'export',
					iconCls:'icon-export',
					handler:function(){
						var index = $('#deratedetailgrid-10').datagrid('getRowIndex',$('#deratedetailgrid-10').datagrid('getSelected'));
						//alert(index);
						if(index >=0){
							$('#deratedetailgrid-10').datagrid('deleteRow', index);    
							editIndex10 = undefined;
						}
					}
				}]
			});
			setTimeout('detailquery10()',100);
		});
	

	


	$.extend($.fn.validatebox.defaults.rules, {   
		datecheck: {   
			validator: function(value){ 
				return /^((((1[6-9]|[2-9]\d)\d{2})-(0?[13578]|1[02])-(0?[1-9]|[12]\d|3[01]))|(((1[6-9]|[2-9]\d)\d{2})-(0?[13456789]|1[012])-(0?[1-9]|[12]\d|30))|(((1[6-9]|[2-9]\d)\d{2})-0?2-(0?[1-9]|1\d|2[0-8]))|(((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))-0?2-29-))$/.test(value);
			},   
			message: '时间格式不合法，格式为YYYY-MM-DD 如：2013-01-03'  
		}   
	});
	function detailquery10(){
		var params = {};
		var fields =$('#derateform').serializeArray();
		$.each( fields, function(i, field){
			params[field.name] = field.value;
		}); 
		params.user_id= selectid;
		params.derate_type= '10';
		$('#deratedetailgrid-10').datagrid('loadData',{total:0,rows:[]});
		var opts = $('#deratedetailgrid-10').datagrid('options');
		opts.url = '<%=request.getContextPath()%>/Derate/getDeratelist.do';
		$('#deratedetailgrid-10').datagrid('load',params); 
		var p = $('#deratedetailgrid-10').datagrid('getPager');  
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
									$('#deratedetailgrid-10').datagrid('reload');
								}
							}]">
						<table id="deratedetailgrid-10" 
						data-options="iconCls:'icon-edit',singleSelect:true" rownumbers="true"> 
							<thead>
								<tr>
									<th data-options="field:'serialno',width:80,align:'center',hidden:'true'"></th>
									<th data-options="field:'user_id',width:80,align:'center',hidden:'true'"></th>
									<th data-options="field:'derate_type',width:80,align:'center',hidden:'true',editor:{type:'text',options:{required:false}}">减免类型</th>
									<th data-options="field:'derate_date',width:120,align:'center',editor:{type:'datebox',options:{validType:['datecheck'],required:true}}">减免日期</th>
									<th data-options="field:'actual_amount',width:120,align:'right',formatter:formatnumber,editor:{type:'numberbox',options:{precision:2,min:0,required:true}}">实际医疗费用</th>
									<th data-options="field:'derate_amount',width:120,align:'right',formatter:formatnumber,editor:{type:'numberbox',options:{precision:2,min:0,required:true}}">减免金额</th>
									<th data-options="field:'derate_sumamount',width:120,align:'right',formatter:formatnumber,editor:{type:'numberbox',options:{precision:2,min:0,required:true}}">累计减免金额</th>
									<th data-options="field:'doctor',width:120,align:'center',formatter:formatemp,editor:{type:'text',options:{required:false}}">医生</th>
									<th data-options="field:'opt_orgcode',width:120,align:'center',formatter:formatorg,editor:{type:'text',options:{required:false}}">医疗机构</th>
									
								</tr>
							</thead>
						</table>
			</div>
		</form>
</body>
</html>
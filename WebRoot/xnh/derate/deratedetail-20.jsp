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
	$(function(){
		
		
		$('#deratedetailgrid').datagrid({
				singleSelect:'true',
				fitColumns:'true',
				rownumbers:'true',
				pagination:true,
				toolbar:[{
					text:'新建',
					iconCls:'icon-add',
					handler:function(){
						if (endEditing()){
							$('#deratedetailgrid').datagrid('endEdit', editIndex);
							$('#deratedetailgrid').datagrid('appendRow',{
								derate_date:'',
								hospital_begindate:'',
								hospital_enddate:'',
								diagnose:'',
								actual_amount:'0',
								derate_amount:'0',
								derate_sumamount:'0'
							});
							editIndex = $('#deratedetailgrid').datagrid('getRows').length-1;  
							$('#deratedetailgrid').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
							var optorg = $('#deratedetailgrid').datagrid('getEditor', {index:editIndex,field:'opt_orgcode'});
							var $optorg = optorg.target;
							$optorg.prop('readonly',true); 
							var optemp = $('#deratedetailgrid').datagrid('getEditor', {index:editIndex,field:'opt_empcode'});
							var $optemp = optemp.target;
							$optemp.prop('readonly',true); 
						}
					}
				},{
					text:'修改',
					iconCls:'icon-edit',
					id:'edit',
					handler:function(){
						if(endEditing()){
							var row = $('#deratedetailgrid').datagrid('getSelected');
							var index = $('#deratedetailgrid').datagrid('getRowIndex',row);
							$('#deratedetailgrid').datagrid('beginEdit',index);
							editIndex = index;
						}
					}
				},{
					text:'删除',
					iconCls:'icon-remove',
					id:'del',
					handler:function(){
						var index = $('#deratedetailgrid').datagrid('getRowIndex',$('#deratedetailgrid').datagrid('getSelected'));
						//alert(index);
						if(index >=0){
							$('#deratedetailgrid').datagrid('deleteRow', index);    
							editIndex = undefined;
						}
					}
				},{
					text:'保存',
					iconCls:'icon-save',
					handler:function(){
						var effectRow = new Object();
						if(endEditing()){
							var data = $('#deratedetailgrid').datagrid('getChanges');
							//var row = $('#userinfogrid').datagrid('getSelected');
							if (data.length) {
								var inserted = $('#deratedetailgrid').datagrid('getChanges', "inserted");
								var deleted = $('#deratedetailgrid').datagrid('getChanges', "deleted");
								var updated = $('#deratedetailgrid').datagrid('getChanges', "updated");
								//alert("inserted="+inserted.length+"---deleted="+deleted.length+"-----updated="+updated.length);
								endEdits();
								if (inserted.length) {
									effectRow.inserted = inserted;
								}
								if (deleted.length) {
									effectRow.deleted = deleted;
								}
								if (updated.length) {
									effectRow.updated = updated;
								}
							}
							var maininfo = {};
							var row = $('#userinfogrid').datagrid('getSelected');
							//alert(row.user_id);
							maininfo['user_id'] = row.user_id;
							maininfo['derate_type'] = datatype;
							effectRow.maininfo = maininfo;
							//alert(JSON.stringify(effectRow));
							$.ajax({
								   type: "post",
								   url: "<%=request.getContextPath()%>/Derate/saveDerate.do",
								   data: $.toJSON(effectRow),
								   contentType: "application/json; charset=utf-8",
								   dataType: "json",
								   success: function(jsondata){
									   $('#deratedetailgrid').datagrid('reload');
									   $.messager.alert('返回消息','保存成功');
								   },
									error:function (data, status, e){   
										 $.messager.alert('返回消息',"保存出错");   
									} 
						   });
						}
						
					}
				}],
				onClickRow:function(index){
					$('#edit').linkbutton('enable');
					$('#del').linkbutton('enable');
					var row = $('#deratedetailgrid').datagrid('getSelected');
					if(editIndex == undefined){
						$('#deratedetailgrid').datagrid('selectRow', index);
					}else{
						if (editIndex != index){  
							if (endEditing()){  
								$('#deratedetailgrid').datagrid('selectRow', index);  
							}else{
								$('#deratedetailgrid').datagrid('unselectRow', index);  
							}
						}
					}
					if(row.opt_empcode!=empcode){
						$('#edit').linkbutton('disable');
						$('#del').linkbutton('disable');
					}
				}
			});
			setTimeout('detailquery()',100);
		});
	

	


	$.extend($.fn.validatebox.defaults.rules, {   
		datecheck: {   
			validator: function(value){ 
				return /^((((1[6-9]|[2-9]\d)\d{2})-(0?[13578]|1[02])-(0?[1-9]|[12]\d|3[01]))|(((1[6-9]|[2-9]\d)\d{2})-(0?[13456789]|1[012])-(0?[1-9]|[12]\d|30))|(((1[6-9]|[2-9]\d)\d{2})-0?2-(0?[1-9]|1\d|2[0-8]))|(((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))-0?2-29-))$/.test(value);
			},   
			message: '时间格式不合法，格式为YYYY-MM-DD 如：2013-01-03'  
		}   
	});
	function detailquery(){
		var row = $('#userinfogrid').datagrid('getSelected');
		var params = {};
		var fields =$('#derateform').serializeArray();
		$.each( fields, function(i, field){
			params[field.name] = field.value;
		}); 
		params.user_id= row.user_id;
		params.derate_type= '20';
		$('#deratedetailgrid').datagrid('loadData',{total:0,rows:[]});
		var opts = $('#deratedetailgrid').datagrid('options');
		opts.url = '<%=request.getContextPath()%>/Derate/getDeratelist.do';
		$('#deratedetailgrid').datagrid('load',params); 
		var p = $('#deratedetailgrid').datagrid('getPager');  
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
									$('#deratedetailgrid').datagrid('reload');
								}
							}]">
						<table id="deratedetailgrid" 
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
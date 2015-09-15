<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<%@ include file="/common/inc.jsp"%>
<html>
<head>

	<title>Complex Layout - jQuery EasyUI Demo</title>

	<link rel="stylesheet" href="<%=spath%>/themes/default/easyui.css">
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
</head>  
<body>
<script>
	//var taxdata = new Object;
	//var deratetypedata = new Array();
	//var deratereasondata = new Array();
		var editIndex = undefined;
		$(function(){
			
			
			refreshHire();
			$('#jmxx').datagrid({
				fitColumns:'true',
					maximized:'true',
				toolbar:[{
					text:'新建',
					id:'b-add',
					iconCls:'icon-add',
					handler:function(){
						if (endEditing()){
							$('#jmxx').datagrid('appendRow',{
							taxreduceid:'',
							taxcode:'',
							approvenumber:'',
							approveunit:'',
							//reduceclass:'',
							reducenum:'0.00',
							reducereason:'',
							policybasis:'',
							reducebegindates:'',
							reduceenddates:''
							});
							editIndex = $('#jmxx').datagrid('getRows').length-1;  
							$('#jmxx').datagrid('selectRow', editIndex)  
									.datagrid('beginEdit', editIndex);  
						} 
					}
				},{
					text:'修改',
					iconCls:'icon-edit',
					id:'b-edit',
					handler:function(){
						if(endEditing()){
							var row = $('#jmxx').datagrid('getSelected');
							var index = $('#jmxx').datagrid('getRowIndex',row);
							$('#jmxx').datagrid('beginEdit',index);
							editIndex = index;
						}
						//if (editIndex == undefined){return}  
						//$('#jmxx').datagrid('cancelEdit', editIndex).datagrid('deleteRow', editIndex);  
						//editIndex = undefined;
					}
				},{
					text:'删除',
					iconCls:'icon-remove',
					id:'b-delete',
					handler:function(){
						var index = $('#jmxx').datagrid('getRowIndex',$('#jmxx').datagrid('getSelected'));
						$('#jmxx').datagrid('deleteRow', index);    
						editIndex = undefined;
					}
				},{
					text:'保存',
					id:'b-save',
					iconCls:'icon-save',
					handler:function(){
						//if(editIndex == undefined){
						//	var selectrow = $('#jmxx').datagrid('getSelected');
							//alert($('#zjfcxx').datagrid('getRowIndex',selectrow));
						//	var rowindex = $('#jmxx').datagrid('getRowIndex',selectrow);
						//	$('#jmxx').datagrid('endEdit', rowindex)
						//}
						if(endEditing()){
							var data = $('#jmxx').datagrid('getChanges');
							if (data.length) {
								var inserted = $('#jmxx').datagrid('getChanges', "inserted");
								var deleted = $('#jmxx').datagrid('getChanges', "deleted");
								var updated = $('#jmxx').datagrid('getChanges', "updated");
								endEdits();
								var effectRow = new Object();
								var tdxxrow = $('#groundgathercheckgrid').datagrid('getSelected');//获取土地信息选中行
								//effectRow.lessorid = $('#taxpayerid').val();
								//effectRow.estateid = tdxxrow.uuid;
								var baseinfo = {"lessorid":tdxxrow.taxpayerid,"estateid":tdxxrow.estateid,"taxpayerid":tdxxrow.taxpayerid,"taxpayername":tdxxrow.taxpayername};//$('#taxpayerid').val()
								effectRow.baseinfo = baseinfo;
								if (inserted.length) {
									effectRow.inserted = inserted;
								}
								if (deleted.length) {
									effectRow.deleted = deleted;
								}
								if (updated.length) {
									effectRow.updated = updated;
								}
								//endEdits();
								//alert(effectRow);
								//alert(JSON.stringify(effectRow));
								$.ajax({
									   type: "post",
									   url: "/GroundInfoServlet/savereduce.do",
									   data: $.toJSON(effectRow),
									   contentType: "application/json; charset=utf-8",
									   dataType: "json",
									   success: function(jsondata){
										   refreshHire();
										   alert('保存成功');
											//alert(jsondata);
									   },
										error:function (data, status, e){   
											 alert("保存出错");   
										}   
							   });
							}
						}
					}
				}],
				//onBeforeLoad:function(){
				//	$(this).datagrid('rejectChanges');
				//},
				onClickRow:function(index){
					if(editIndex == undefined){
						$('#jmxx').datagrid('selectRow', index);
						//editIndex= index;
					}else{
						if (editIndex != index){  
							if (endEditing()){  
								$('#jmxx').datagrid('selectRow', index);  
								//editIndex = index;  
							}else{
								$('#jmxx').datagrid('unselectRow', index);  
							}
						}
					}
				}
			});
			if(showtype=='0'){
				$('#b-add').hide();
				$('#b-edit').hide();
				$('#b-delete').hide();
				$('#b-save').hide();
			}else{
				$('#b-add').show();
				$('#b-edit').show();
				$('#b-delete').show();
				$('#b-save').show();
			}
		});
		//结束所有行的编辑
		function endEdits(){
			var rows = $('#jmxx').datagrid('getRows');
			for ( var i = 0; i < rows.length; i++) {
				$('#jmxx').datagrid('endEdit', i);
			}
			$('#jmxx').datagrid('acceptChanges');
		}
		
		function endEditing(){  
            if (editIndex == undefined){return true}  
            if ($('#jmxx').datagrid('validateRow', editIndex)){
				$('#jmxx').datagrid('endEdit', editIndex);
                editIndex = undefined;  
                return true;  
            } else {  
				alert('有必填字段不能为空！');
                return false;  
            }  
        }
		function refreshHire(){
			$.ajax({
			   type: "post",
			   url: "/GroundInfoServlet/getreduceinfo.do",
			   data: {uuid:estateid},//ff171602b950f4ca5123c5c9edadc9d4
			   dataType: "json",
			   success: function(jsondata){
				   //alert(JSON.stringify(jsondata));
				  $('#jmxx').datagrid('loadData',jsondata);
			   }
			});
		}
//function format(row){
//		var s=$('#jmxx').datagrid('getColumnOption','taxcode');
//		var opts = $(this).editor.combobox('options');
//		alert(s.combobox('options'));
//		alert('aaa');
//}



			//var tdxxrow = $('#groundgathercheckgrid').datagrid('getSelected');
			//if(tdxxrow){
				
			//}


function formattaxcode(row){
	for(var i=0; i<taxdata.length; i++){
		if (taxdata[i].value == row) return taxdata[i].text;
	}
	return row;
}


$.extend($.fn.validatebox.defaults.rules, {   
		datecheck: {   
			validator: function(value){ 
				return /^((((1[6-9]|[2-9]\d)\d{2})-(0?[13578]|1[02])-(0?[1-9]|[12]\d|3[01]))|(((1[6-9]|[2-9]\d)\d{2})-(0?[13456789]|1[012])-(0?[1-9]|[12]\d|30))|(((1[6-9]|[2-9]\d)\d{2})-0?2-(0?[1-9]|1\d|2[0-8]))|(((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))-0?2-29-))$/.test(value);
			},   
			message: '时间格式不合法，格式为YYYY-MM-DD 如：2013-01-03'  
		}   
	}); 

$.extend($.fn.validatebox.defaults.rules, {
	isAfter: {
		validator: function(value, param){
			var index = $('#jmxx').datagrid('getRowIndex',$('#jmxx').datagrid('getSelected'));
			var eda = $('#jmxx').datagrid('getEditor', {index:index,field:'reducebegindates'});
			var edb = $('#jmxx').datagrid('getEditor', {index:index,field:'reduceenddates'});
			var dateA = $.fn.datebox.defaults.parser(eda.datebox('getValue'));
			var dateB = $.fn.datebox.defaults.parser(edb.datebox('getValue'));
			//alert(dateA+"------"+dateB);
			return dateA<dateB;
			},
		 message: '减免起日期不能大于减免止日期！'
		}
	});
var approveunitdata =[
	{value:'',text:''},
	{value:'5301240000',text:'晋宁县地方税务局'},
	{value:'5301000000',text:'昆明市地方税务局'},
	{value:'5300000000',text:'云南省地方税务局'},
	{value:'0000000000',text:'国家税务总局'}
	
];

var taxdata = [
	{value:'',text:''},
	{value:'10',text:'房产税和城市房地产税'},
	{value:'12',text:'城镇土地使用税'},
	{value:'20',text:'耕地占用税'}
	
];
function formatunit(row){
	for(var i=0; i<approveunitdata.length; i++){
		if (approveunitdata[i].value == row) return approveunitdata[i].text;
	}
	return row;
}
</script>
		<form id="jmxxform" method="post">
			<div title="减免信息" data-options="
						tools:[{
							handler:function(){
								$('#jmxx').datagrid('reload');
							}
						}]">
					
						<table id="jmxx" style="width:1200px;height:380px"
						data-options="iconCls:'icon-edit',singleSelect:true,idField:'itemid'" rownumbers="true"> 
							<thead>
								<tr>
									<th data-options="field:'taxreduceid',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'taxcode',id:'taxcode',width:180,align:'center',formatter:formattaxcode,editor:{type:'combobox',options:{editable:false,required:true,valueField:'value',textField: 'text',data:[
										{value:'',text:''},
										{value:'10',text:'房产税和城市房地产税'},
										{value:'12',text:'城镇土地使用税'},
										{value:'20',text:'耕地占用税'}
										
									],onChange:function(newValue,oldValue){
										var index = $('#jmxx').datagrid('getRowIndex',$('#jmxx').datagrid('getSelected'));
										var edbegin = $('#jmxx').datagrid('getEditor', {  
											index : index,  
											field : 'reducebegindates'  
										});
										var edend = $('#jmxx').datagrid('getEditor', {  
											index : index,  
											field : 'reduceenddates'  
										});
										if(newValue=='20'){
											$(edbegin.target).datebox('disable');
											$(edbegin.target).datebox('setValue',null);
											$(edbegin.target).combo({required:false});
											$(edend.target).datebox('disable');
											$(edend.target).datebox('setValue',null);
											$(edend.target).combo({required:false});
										}else{
											$(edbegin.target).datebox('enable');
											$(edbegin.target).combo({required:true});
											$(edend.target).datebox('enable');
											$(edend.target).combo({required:true});
										}
									}}}">免税税种</th>
									<th data-options="field:'approvenumber',width:100,align:'center',editor:{type:'text',required:true}">批准免税文号</th>
									<th data-options="field:'approveunit',width:100,align:'center',formatter:formatunit,editor:{type:'combobox',options:{valueField:'value',textField: 'text',data: [
									{value:'',text:''},
									{value:'5301240000',text:'晋宁县地方税务局'},
									{value:'5301000000',text:'昆明市地方税务局'},
									{value:'5300000000',text:'云南省地方税务局'},
									{value:'0000000000',text:'国家税务总局'}	
									]}}">批准免税机关</th>
									<!-- <th data-options="field:'reduceclass',width:100,align:'center',formatter:formatderatetype,editor:{type:'combobox',options:{required:true,valueField:'value',textField: 'text',	data:deratetypedata}}">减免性质</th> -->
									<th data-options="field:'reducenum',width:80,align:'center',editor:{type:'numberbox',options:{precision:2,min:0,required:true}}">减免面积/减免原值</th>
									<th data-options="field:'reducereason',width:100,align:'center',editor:{type:'validatebox',options:{required:true}}">减免原因</th>
									<th data-options="field:'policybasis',width:100,align:'center',editor:{type:'validatebox',options:{required:true}}">减免的政策依据</th>
									<th data-options="field:'reducebegindates',width:80,align:'center',editor:{type:'datebox',options:{validType:['datecheck']}}">减免时间起</th>
									<th data-options="field:'reduceenddates',width:80,align:'center',editor:{type:'datebox',options:{validType:['datecheck']}}">减免时间止</th>
								</tr>
							</thead>
						</table>
					
			</div>
		</form>
</body>
  
</html>
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
		var editIndex = undefined;
		$(function(){
			refreshHire();
			$('#tdczfxx').datagrid({
				fitColumns:'true',
				toolbar:[{
					text:'新建',
					id :'c-add',
					iconCls:'icon-add',
					handler:function(){
						if (endEditing()){
							$('#tdczfxx').datagrid('appendRow',{
							ownerid:'',
							agreementnumber:'',
							lesseesid:'',
							lesseestaxpayername:'',
							norentuseflag:'0',
							landtaxpayer:'0',
							freetax:'0',
							landarea:'0.00',
							taxarea:'0.00',
							transmonthmoney:'0.00',
							transmoney:'0.00',
							transbegindates:'',
							transenddates:''
							});
							editIndex = $('#tdczfxx').datagrid('getRows').length-1;  
							$('#tdczfxx').datagrid('selectRow', editIndex)  
									.datagrid('beginEdit', editIndex);  
							bindevent();
						} 
					}
				},{
					text:'修改',
					id :'c-edit',
					iconCls:'icon-edit',
					handler:function(){
						if(endEditing()){
							var row = $('#tdczfxx').datagrid('getSelected');
							var index = $('#tdczfxx').datagrid('getRowIndex',row);
							$('#tdczfxx').datagrid('beginEdit',index);
							bindevent();
							editIndex = index;
						}
					}
				},{
					text:'删除',
					id :'c-delete',
					iconCls:'icon-remove',
					handler:function(){
						var index = $('#tdczfxx').datagrid('getRowIndex',$('#tdczfxx').datagrid('getSelected'));
						$('#tdczfxx').datagrid('deleteRow', index);    
						editIndex = undefined;
					}
				},{
					text:'保存',
					id :'c-save',
					iconCls:'icon-save',
					handler:function(){
						//if(editIndex == undefined){
						//	var selectrow = $('#tdczfxx').datagrid('getSelected');
							//alert($('#zjfcxx').datagrid('getRowIndex',selectrow));
						//	var rowindex = $('#tdczfxx').datagrid('getRowIndex',selectrow);
						//	$('#tdczfxx').datagrid('endEdit', rowindex)
						//}
						if(endEditing()){
							var data = $('#tdczfxx').datagrid('getChanges');
							if (data.length) {
								var inserted = $('#tdczfxx').datagrid('getChanges', "inserted");
								var deleted = $('#tdczfxx').datagrid('getChanges', "deleted");
								var updated = $('#tdczfxx').datagrid('getChanges', "updated");
								endEdits();
								var effectRow = new Object();
								var tdxxrow = $('#tdxxgrid').datagrid('getSelected');//获取土地信息选中行
								//effectRow.lessorid = $('#taxpayerid').val();
								//effectRow.estateid = tdxxrow.uuid;
								var baseinfo = {"lessorid":$('#taxpayerid').val(),"lessortaxpayname":$('#taxpayername').val(),"estateid":tdxxrow.estateid,"hiretype":0};
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
									   url: "/InitBaseInfoServlet/savelease.do",
									   data: $.toJSON(effectRow),
									   contentType: "application/json; charset=utf-8",
									   dataType: "json",
									   success: function(jsondata){
										   refreshHire();
											alert('保存成功');
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
						$('#tdczfxx').datagrid('selectRow', index);
						//editIndex= index;
					}else{
						if (editIndex != index){  
							if (endEditing()){  
								$('#tdczfxx').datagrid('selectRow', index);  
								//editIndex = index;  
							}else{
								$('#tdczfxx').datagrid('unselectRow', index);  
							}
						}
					}
				}
			});
			var tdxxrow = $('#tdxxgrid').datagrid('getSelected');
			if(tdxxrow.state=='1'){
				$('#c-add').hide();
				$('#c-edit').hide();
				$('#c-delete').hide();
				$('#c-save').hide();
			}else{
				$('#c-add').show();
				$('#c-edit').show();
				$('#c-delete').show();
				$('#c-save').show();
			}
		});
		//结束所有行的编辑
		function endEdits(){
			var rows = $('#tdczfxx').datagrid('getRows');
			for ( var i = 0; i < rows.length; i++) {
				$('#tdczfxx').datagrid('endEdit', i);
			}
			$('#tdczfxx').datagrid('acceptChanges');
		}
		
		function endEditing(){  
            if (editIndex == undefined){return true}  
            if ($('#tdczfxx').datagrid('validateRow', editIndex)){
				$('#tdczfxx').datagrid('endEdit', editIndex);
                editIndex = undefined;  
                return true;  
            } else {  
				alert('有必填字段不能为空！');
                return false;  
            }  
        }
		function refreshHire(){
			var tdxxrow = $('#tdxxgrid').datagrid('getSelected');
			if(tdxxrow){
				$.ajax({
				   type: "post",
				   url: "/InitBaseInfoServlet/gethireinfo.do",
				   data: {uuid:tdxxrow.estateid,hiretype:0},//'ff171602b950f4ca5123c5c9edadc9d4'
				   dataType: "json",
				   success: function(jsondata){
					   //alert(JSON.stringify(jsondata));
					  $('#tdczfxx').datagrid('loadData',jsondata.hirelist);
				   }
				});
			}
		}

var rowdata = [
	{label:'0',name:'否'},
	{label:'1',name:'是'}
];



function format(row){
	for(var i=0; i<rowdata.length; i++){
		if (rowdata[i].label == row) return rowdata[i].name;
	}
	return value;
}

//绑定回车事件
function bindevent(){
	var selectrow = $('#tdczfxx').datagrid('getSelected');
	
	var index = $('#tdczfxx').datagrid('getRowIndex',selectrow);
	//$('#tdczfxx').datagrid('refreshRow',index);
	var ed = $('#tdczfxx').datagrid('getEditor', {index:index,field:'lesseesid'});
	var ed2 = $('#tdczfxx').datagrid('getEditor', {index:index,field:'lesseestaxpayername'});
	//alert(ed.target.val());
	$(ed.target).bind('keyup', function(){
		if (window.event.keyCode == 13){
			$('#reginfowindow').window('open');//打开新录入窗口
			$('#reginfowindow').window('refresh', '../grounddetail/c-reginfo.jsp');
		//	$('#tdczfxx').datagrid('getSelected').lesseesid= ed.target.val();
			//alert('bbb');
		//	$.ajax({
		//	   type: "post",
		//	   async:false,
		//	   url: "/InitBaseInfoServlet/getreginfo.do",
		//	   data: {taxpayerid: ed.target.val()},
		//	   dataType: "json",
		//	   success: function(jsondata){
		//		    if(jsondata.status=='00'){
		//				alert('没有该纳税人登记信息');
		//			}else{
		//				//alert(jsondata.registmainvo.taxpayername);
		//				ed2.target.val(jsondata.registmainvo.taxpayername);
		//			}
		//	   }
		//	});
		 }
	});
	$(ed2.target).bind('keyup', function(){
		if (window.event.keyCode == 13){
			$('#reginfowindow').window('open');//打开新录入窗口
			$('#reginfowindow').window('refresh', '../grounddetail/c-reginfo.jsp');
		 }
	});

}

$.extend($.fn.validatebox.defaults.rules, {   
		datecheck: {   
			validator: function(value){ 
				return /^((((1[6-9]|[2-9]\d)\d{2})-(0?[13578]|1[02])-(0?[1-9]|[12]\d|3[01]))|(((1[6-9]|[2-9]\d)\d{2})-(0?[13456789]|1[012])-(0?[1-9]|[12]\d|30))|(((1[6-9]|[2-9]\d)\d{2})-0?2-(0?[1-9]|1\d|2[0-8]))|(((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))-0?2-29-))$/.test(value);
			},   
			message: '时间格式不合法，格式为YYYY-MM-DD 如：2013-01-03'  
		}   
	}); 
</script>
		<form id="tdczfxxform" method="post">
			<div title="土地转租方信息" data-options="
				tools:[{
					handler:function(){
						$('#tdczfxx').datagrid('reload');
					}
				}]">
			<table id="tdczfxx" style="width:1200px;height:400px"
			data-options="singleSelect:true,idField:'itemid'" rownumbers="true"> 
				<thead>
					<tr>
						<th data-options="field:'ownerid',width:80,align:'center',hidden:true,editor:{type:'text'}"></th>
						<th data-options="field:'agreementnumber',width:160,align:'center',editor:{type:'validatebox',options:{required:false}}">转租方文书号或协议号</th>
						<th data-options="field:'lesseesid',align:'center',hidden:true,editor:{type:'validatebox'}"></th>
						<th data-options="field:'lesseestaxpayername',width:120,align:'center',editor:{type:'validatebox',options:{required:true}}">转租方名称(回车查询)</th><!-- 待定 -->
						<th data-options="field:'norentuseflag',width:80,align:'center',formatter:format,editor:{type:'combobox',options:{valueField:'label',textField: 'value',	data: [{label: '0',value: '否'},{label: '1',value: '是'}]}}">是否无租使用</th>
						<th data-options="field:'landtaxpayer',width:130,align:'center',formatter:format,editor:{type:'combobox',options:{valueField:'label',
						onChange:function(newValue,oldValue){
							if(newValue == '0'){
								var index = $('#tdczfxx').datagrid('getRowIndex',$('#tdczfxx').datagrid('getSelected'));
								var edbegin = $('#tdczfxx').datagrid('getEditor', {  
									index : index,  
									field : 'taxarea'  
								});
								$(edbegin.target).numberbox('disable');
								$(edbegin.target).numberbox('setValue','0.00');
							}else{
								var index = $('#tdczfxx').datagrid('getRowIndex',$('#tdczfxx').datagrid('getSelected'));
								var edbegin = $('#tdczfxx').datagrid('getEditor', {  
									index : index,  
									field : 'taxarea'  
								});
								$(edbegin.target).numberbox('enable');
							}
						},
						textField: 'value',	data: [{label: '0',value: '否'},{label: '1',value: '是'}]}}">是否缴纳土地使用税</th>
						<th data-options="field:'freetax',width:80,align:'center',formatter:format,editor:{type:'combobox',options:{valueField:'label',textField: 'value',	data: [{label: '0',value: '否'},{label: '1',value: '是'}]}}">是否免税单位</th>
						<th data-options="field:'landarea',width:80,align:'center',editor:{type:'numberbox',options:{precision:2,min:0,required:true}}">转租面积</th>
						<th data-options="field:'taxarea',width:160,align:'center',editor:{type:'numberbox',options:{precision:2,min:0}}">约定缴纳土地使用税面积</th>
						<th data-options="field:'transmonthmoney',width:80,align:'center',editor:{type:'numberbox',options:{precision:2,min:0,required:true}}">月租金</th>
						<th data-options="field:'transmoney',width:80,align:'center',editor:{type:'numberbox',options:{precision:2,min:0,required:true}}">年租金</th>
						<th data-options="field:'transbegindates',width:80,align:'center',editor:{type:'datebox',options:{required:true,validType:['datecheck']}}">转租时间起</th>
						<th data-options="field:'transenddates',width:80,align:'center',editor:{type:'datebox',options:{required:true,validType:['datecheck']}}">转租时间止</th>
					</tr>
				</thead>
			</table>
		</div>
		</form>
</body>
  
</html>
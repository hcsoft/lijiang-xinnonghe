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
	<script src="<%=spath%>/locale/easyui-lang-zh_CN.js"></script>
</head> 
<body>
<script>
var editIndex = undefined;
var sgfeditIndex = undefined;
var paymenteditIndex = undefined;
		$(function(){
			refreshBuildinghouse();
			$('#zjfcxx').datagrid({
				fitColumns:'true',
				toolbar:[{
					text:'新建',
					id:'e1-add',
					iconCls:'icon-add',
					handler:function(){
						if (endEditing()){
							$('#zjfcxx').datagrid('appendRow',{
								houseid:'',
								housename:'',
								expectinvestment:'0.00',
								buildinginvestment:'0.00',
								//devicecost:'0.00',
								//projectmoney:'0.00',
								//appropriatedatebegins:'',
								//appropriatedateends:'',
								plandates:'',
								status:'00'//新增行状态
							});
							editIndex = $('#zjfcxx').datagrid('getRows').length-1;  
							$('#zjfcxx').datagrid('selectRow', editIndex)  
									.datagrid('beginEdit', editIndex);  
						} 
					}
				},{
					text:'修改',
					id:'e1-edit',
					iconCls:'icon-edit',
					handler:function(){
						if(endEditing()){
							var row = $('#zjfcxx').datagrid('getSelected');
							var index = $('#zjfcxx').datagrid('getRowIndex',row);
							$('#zjfcxx').datagrid('beginEdit',index);
							editIndex = index;
						}
					}
				},{
					text:'删除',
					id:'e1-delete',
					iconCls:'icon-remove',
					handler:function(){
						var index = $('#zjfcxx').datagrid('getRowIndex',$('#zjfcxx').datagrid('getSelected'));
						$('#zjfcxx').datagrid('deleteRow', index);  
						editIndex = undefined;
					}
				},{
					text:'保存',
					id:'e1-save',
					iconCls:'icon-save',
					handler:function(){
						//if(editIndex == undefined){
						//	var selectrow = $('#zjfcxx').datagrid('getSelected');
							//alert($('#zjfcxx').datagrid('getRowIndex',selectrow));
						//	var rowindex = $('#zjfcxx').datagrid('getRowIndex',selectrow);
						//	$('#zjfcxx').datagrid('endEdit', rowindex)
						//}
						//alert(data.length);
						if(endEditing()){
							var data = $('#zjfcxx').datagrid('getChanges');
							if (data.length) {
								var inserted = $('#zjfcxx').datagrid('getChanges', "inserted");
								var deleted = $('#zjfcxx').datagrid('getChanges', "deleted");
								var updated = $('#zjfcxx').datagrid('getChanges', "updated");
								endEdits();
								var effectRow = new Object();
								var tdxxrow = $('#groundgathercheckgrid').datagrid('getSelected');//获取土地信息选中行
								var baseinfo = {"taxpayerid":tdxxrow.taxpayerid,"taxpayername":tdxxrow.taxpayername,"estateid":estateid,"housetype":"1"};
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
									   url: "/GroundInfoServlet/savehouse.do",
									   data: $.toJSON(effectRow),
									   contentType: "application/json; charset=utf-8",
									   dataType: "json",
									   success: function(jsondata){
											refreshBuildinghouse();
											alert('保存成功');
									   },
										error:function (data, status, e){   
											 alert("保存出错");   
										} 
							   });
							}
						}
					}
				},{
					text:'施工方信息',
					iconCls:'icon-tip',
					handler:function(){
						var row = $('#zjfcxx').datagrid('getSelected');
						if(row){
							if(endEditing()){
								var changedata = $('#zjfcxx').datagrid('getChanges');
								if(changedata.length>0){
									alert("请先保存在建房信息");
									return;
								}
								if(row.status=='01'){
									refreshBuilder();
									$('#sgfxxgrid').datagrid({
										singleSelect:'true',
										//idField:'itemid',
										fitColumns:'true',
										rownumbers:'true',
										columns:[[
											{field:'builderid',title:'builderid',width:100,align:'center',hidden:'true'},   
											{field:'buildername',title:'施工方名称',width:100,align:'center',editor:{type:'validatebox',options:{required:true}}},   
											{field:'buildertype',title:'施工方性质',width:100,align:'center',formatter:formatbuildertype,editor:{type:'combobox',options:{editable:false,required:true,valueField:'label',textField:'name',data:[{label: '01',name: '企业'},{label: '02',name: '个体'},{label: '03',name: '自然人'}]}}},  
											{field:'buildermanagerorg',title:'施工方主管地税机关',width:150,align:'center',editor:{type:'validatebox',options:{required:true}}},
											{field:'istoissuelicense',title:'是否出具外出经营许可',width:150,align:'center',formatter:formatistoissuelicense,editor:{type:'combobox',options:{editable:false,required:true,valueField:'label',textField:'name',data:[{label: '1',name: '是'},{label: '0',name: '否'}]}}},
											{field:'projectname',title:'合同名称',width:100,align:'center',editor:{type:'validatebox',options:{required:true}}},
											{field:'contractid',title:'合同编号',width:100,align:'center',editor:{type:'validatebox',options:{required:false}}},
											{field:'money',title:'合同金额',width:60,align:'center',editor:{type:'numberbox',options:{precision:2,min:0,required:true}}},
											{field:'status',title:'',width:100,align:'center',hidden:'true',editor:{type:'combobox'}},
											{field:'paymoney',title:'已支付金额',width:100,align:'center',editor:{type:'numberbox',options:{precision:2,min:0,required:true}}}
											]],
										toolbar:[{
											text:'新建',
											id:'e2-add',
											iconCls:'icon-add',
											handler:function(){
												if (sgfendEditing()){
													$('#sgfxxgrid').datagrid('endEdit', sgfeditIndex);
													$('#sgfxxgrid').datagrid('appendRow',{
														builderid:'',
														buildername:'',
														buildertype:'01',
														buildermanagerorg:'',
														istoissuelicense:'1',
														projectname:'',
														contractid:'',
														money:'0.00',
														status:'00',
														paymoney:'0.00'
													});
													sgfeditIndex = $('#sgfxxgrid').datagrid('getRows').length-1;  
													$('#sgfxxgrid').datagrid('selectRow', sgfeditIndex)  
															.datagrid('beginEdit', sgfeditIndex);
												}
											}
										},{
											text:'修改',
											id:'e2-edit',
											iconCls:'icon-edit',
											handler:function(){
												if(sgfendEditing()){
													var row = $('#sgfxxgrid').datagrid('getSelected');
													var index = $('#sgfxxgrid').datagrid('getRowIndex',row);
													$('#sgfxxgrid').datagrid('beginEdit',index);
													sgfeditIndex = index;
												}
											}
										},{
											text:'删除',
											id:'e2-delete',
											iconCls:'icon-remove',
											handler:function(){
												var index = $('#sgfxxgrid').datagrid('getRowIndex',$('#sgfxxgrid').datagrid('getSelected'));
												$('#sgfxxgrid').datagrid('deleteRow', index);    
												sgfeditIndex = undefined;
											}
										},{
											text:'保存',
											id:'e2-save',
											iconCls:'icon-save',
											handler:function(){
												//if(sgfeditIndex == undefined){
													//alert("undefined");
												//	var selectrow = $('#sgfxxgrid').datagrid('getSelected');
													//alert($('#zjfcxx').datagrid('getRowIndex',selectrow));
												//	var rowindex = $('#sgfxxgrid').datagrid('getRowIndex',selectrow);
												//	$('#sgfxxgrid').datagrid('endEdit', rowindex)
													//sgfeditIndex = rowindex;
												//}
												if(sgfendEditing()){
													var data = $('#sgfxxgrid').datagrid('getChanges');
													if (data.length) {
														var inserted = $('#sgfxxgrid').datagrid('getChanges', "inserted");
														var deleted = $('#sgfxxgrid').datagrid('getChanges', "deleted");
														var updated = $('#sgfxxgrid').datagrid('getChanges', "updated");
														sgfendEdits();
														var effectRow = new Object();
														//effectRow.lessorid = $('#taxpayerid').val();
														//effectRow.estateid = tdxxrow.uuid;
														var baseinfo = {"houseid":row.houseid};
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
															   url: "/GroundInfoServlet/savebuilder.do",
															   data: $.toJSON(effectRow),
															   contentType: "application/json; charset=utf-8",
															   dataType: "json",
															   success: function(jsondata){
																   alert('保存成功');
																	refreshBuilder();
															   },
																error:function (data, status, e){   
																	 alert("保存出错");   
																} 
													   });
													}
												}
											}
										},{
											text:'关闭',
											iconCls:'icon-cancel',
											handler:function(){
												$('#sgfxxwindow').window('close');
											}
										}],
										onClickRow:function(index){
											if(sgfeditIndex == undefined){
												$('#sgfxxgrid').datagrid('selectRow', index);
											}else{
												if (sgfeditIndex != index){  
													if (sgfendEditing()){  
														$('#sgfxxgrid').datagrid('selectRow', index);  
													}else{
														$('#sgfxxgrid').datagrid('unselectRow', index);  
													}
												}
											}
										}
									});
									$('#sgfxxwindow').window('open');
									//var tdxxrow = $('#tdxxgrid').datagrid('getSelected');
									if(showtype=='0'){
										$('#e2-add').hide();
										$('#e2-edit').hide();
										$('#e2-delete').hide();
										$('#e2-save').hide();
									}else{
										$('#e2-add').show();
										$('#e2-edit').show();
										$('#e2-delete').show();
										$('#e2-save').show();
									}
								}else{
									alert("请先保存在建房信息");
								}
							}
						}
					}
						
				}],
				//onBeforeLoad:function(){
				//	$(this).datagrid('rejectChanges');
				//},
				onClickRow:function(index){
					if(editIndex == undefined){
						$('#zjfcxx').datagrid('selectRow', index);
						//editIndex= index;
					}else{
						if (editIndex != index){  
							if (endEditing()){  
								$('#zjfcxx').datagrid('selectRow', index);  
								//editIndex = index;  
							}else{
								$('#zjfcxx').datagrid('unselectRow', index);  
							}
						}
					}
				}
			});
			//var tdxxrow = $('#tdxxgrid').datagrid('getSelected');
			if(showtype=='0'){
				$('#e1-add').hide();
				$('#e1-edit').hide();
				$('#e1-delete').hide();
				$('#e1-save').hide();
			}else{
				$('#e1-add').show();
				$('#e1-edit').show();
				$('#e1-delete').show();
				$('#e1-save').show();
			}
		});
		//结束所有行的编辑
		function endEdits(){
			var rows = $('#zjfcxx').datagrid('getRows');
			for ( var i = 0; i < rows.length; i++) {
				$('#zjfcxx').datagrid('endEdit', i);
			}
			$('#zjfcxx').datagrid('acceptChanges');
		}
		
		function endEditing(){  
            if (editIndex == undefined){return true}  
            if ($('#zjfcxx').datagrid('validateRow', editIndex)){
				$('#zjfcxx').datagrid('endEdit', editIndex);
                editIndex = undefined;  
                return true;  
            } else {  
				alert('有必填字段不能为空！');
                return false;  
            }  
        }

		//结束所有行的编辑
		function sgfendEdits(){
			var rows = $('#sgfxxgrid').datagrid('getRows');
			for ( var i = 0; i < rows.length; i++) {
				$('#sgfxxgrid').datagrid('endEdit', i);
			}
			$('#sgfxxgrid').datagrid('acceptChanges');
		}
		
		function sgfendEditing(){  
            if (sgfeditIndex == undefined){return true}
            if ($('#sgfxxgrid').datagrid('validateRow', sgfeditIndex)){
				$('#sgfxxgrid').datagrid('endEdit', sgfeditIndex);
                sgfeditIndex = undefined;  
                return true;  
            } else {  
				alert('有必填字段不能为空！');
                return false;  
            }  
        }

		//结束所有行的编辑
		function paymentendEdits(){
			var rows = $('#paymentgrid').datagrid('getRows');
			for ( var i = 0; i < rows.length; i++) {
				$('#paymentgrid').datagrid('endEdit', i);
			}
			$('#paymentgrid').datagrid('acceptChanges');
		}
		
		function paymentendEditing(){  
            if (paymenteditIndex == undefined){return true}
            if ($('#paymentgrid').datagrid('validateRow', paymenteditIndex)){
				$('#paymentgrid').datagrid('endEdit', paymenteditIndex);
                paymenteditIndex = undefined;  
                return true;  
            } else {  
                return false;  
            }  
        }

		function refreshBuildinghouse(){
			//var tdxxrow = $('#tdxxgrid').datagrid('getSelected');
			//if(tdxxrow){
			$.ajax({
			   type: "post",
			   url: "/GroundInfoServlet/gethouseinfo.do",
			   data: {uuid:estateid,housetype:"1"},
			   dataType: "json",
			   success: function(jsondata){
				  $('#zjfcxx').datagrid('loadData',jsondata);
			   }
			});
			//}
		}

		function refreshBuilder(){
			var row = $('#zjfcxx').datagrid('getSelected');
			$.ajax({
			   type: "post",
			   url: "/GroundInfoServlet/getbuilderinfo.do",
			   data: {houseid:row.houseid},
			   dataType: "json",
			   success: function(jsondata){
				  $('#sgfxxgrid').datagrid('loadData',jsondata);
			   }
			});
		}

		function refreshPayment(){
			var zjfrow = $('#zjfcxx').datagrid('getSelected');
			var sgfrow = $('#sgfxxgrid').datagrid('getSelected');
			$.ajax({
			   type: "post",
			   url: "/GroundInfoServlet/getpaymentinfo.do",
			   data: {houseid:zjfrow.houseid,builderid:sgfrow.builderid},
			   dataType: "json",
			   success: function(jsondata){
				  $('#paymentgrid').datagrid('loadData',jsondata);
			   }
			});
		}
var rowdata = [
	{label:'0',name:'否'},
	{label:'1',name:'是'}
];

function format(row){
	for(var i=0; i<rowdata.length; i++){
		if (rowdata[i].label == row) return rowdata[i].name;
	}
	return row;
};



function formatistoissuelicense(row){
	for(var i=0; i<rowdata.length; i++){
		if (rowdata[i].label == row) return rowdata[i].name;
	}
	return row;
};
$.extend($.fn.validatebox.defaults.rules, {   
		datecheck: {   
			validator: function(value){ 
				return /^((((1[6-9]|[2-9]\d)\d{2})-(0?[13578]|1[02])-(0?[1-9]|[12]\d|3[01]))|(((1[6-9]|[2-9]\d)\d{2})-(0?[13456789]|1[012])-(0?[1-9]|[12]\d|30))|(((1[6-9]|[2-9]\d)\d{2})-0?2-(0?[1-9]|1\d|2[0-8]))|(((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))-0?2-29-))$/.test(value);
			},   
			message: '时间格式不合法，格式为YYYY-MM-DD 如：2013-01-03'  
		}   
	});

var buildertypedata = [{label: '01',name: '企业'},{label: '02',name: '个体'},{label: '03',name: '自然人'}];

function formatbuildertype(row){
	for(var i=0; i<buildertypedata.length; i++){
		if (buildertypedata[i].label == row) return buildertypedata[i].name;
	}
	return row;
};
</script>
		<form id="zjfcxxform" method="post">
			<div title="在建房产信息" data-options="
				tools:[{
					handler:function(){
						$('#zjfcxx').datagrid('reload');
					}
				}]">
			<table id="zjfcxx" style="width:900px;height:400px"
			data-options="singleSelect:true,idField:'itemid'" rownumbers="true"> 
				<thead>
					<tr>
						<th data-options="field:'houseid',id:'',align:'center',hidden:'true'">houseid</th>
						<th data-options="field:'housename',width:70,align:'center',editor:{type:'validatebox',options:{required:true}}">在建房产项目名称</th>
						<th data-options="field:'expectinvestment',width:30,align:'center',editor:{type:'numberbox',options:{precision:2,min:0,required:true}}">预计投资总额</th>
						<th data-options="field:'buildinginvestment',width:30,align:'center',editor:{type:'numberbox',options:{precision:2,min:0,required:true}}">预计建筑安装工程投资额</th>
						<!-- <th data-options="field:'devicecost',width:100,align:'center',editor:{type:'numberbox',options:{precision:2,min:0,required:true}}">应计入房产原值与房屋不可分割的设备</th> -->
						<!-- <th data-options="field:'projectmoney',width:100,align:'center',editor:{type:'numberbox',options:{precision:2,min:0,required:true}}">实际拨付工程款</th> -->
						<!-- <th data-options="field:'appropriatedatebegins',width:80,align:'center',editor:{type:'datebox',options:{editable:false,required:true,validType:['datecheck']}}">拨付时间起</th>
						<th data-options="field:'appropriatedateends',width:80,align:'center',editor:{type:'datebox',options:{editable:false,required:true,validType:['datecheck']}}">拨付时间止</th> -->
						<th data-options="field:'plandates',width:30,align:'center',editor:{type:'datebox',options:{required:true,validType:['datecheck']}}">预计竣工时间</th>
						<th data-options="field:'status',id:'status',align:'center',hidden:'true',editor:{type:'combobox'}">状态</th>
					</tr>
				</thead>
			</table>
		</div>
		<div id="sgfxxwindow" class="easyui-window" data-options="closed:true,modal:true,title:'施工方信息',collapsible:false,minimizable:false,maximizable:false,closable:false" style="width:800px;height:400px;">
		<table id="sgfxxgrid"></table>
		</div>
		<div id="paymentwindow" class="easyui-window" data-options="closed:true,modal:true,title:'工程拨付款信息',collapsible:false,minimizable:false,maximizable:false,closable:false" style="width:800px;height:400px;">
		<table id="paymentgrid"></table>
		</div>
		</form>
</body>
  
  
</html>
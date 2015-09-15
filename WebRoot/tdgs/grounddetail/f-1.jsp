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
var housecertyficatedata = new Object;
var houseusedata = new Object;
//var housesourcedata = new Object;
var housesourcedata = [{"key":"","desc":null,"value":""},{"key":"01","desc":null,"value":"自建"},{"key":"07","desc":null,"value":"承租"}];
		$(function(){
			$.ajax({
				   type: "post",
					async:false,
				   url: "/ComboxService/getComboxs.do",
				   data: {codetablename:'COD_HOUSECERTIFICATETYPE'},
				   dataType: "json",
				   success: function(jsondata){
					   //alert(JSON.stringify(jsondata));	
					  housecertyficatedata= jsondata;
				   }
			});
			$.ajax({
				   type: "post",
				   async:false,
				   url: "/ComboxService/getComboxs.do",
				   data: {codetablename:'COD_HOUSEUSECODE'},
				   dataType: "json",
				   success: function(jsondata){
					  houseusedata= jsondata;
				   }
			});
			
			refreshHouse();
			$('#fcjcxx').datagrid({
				fitColumns:'true',
				toolbar:[{
					text:'新建',
					id:'f1-add',
					iconCls:'icon-add',
					handler:function(){
						if (endEditing()){
							$('#fcjcxx').datagrid('appendRow',{
								houseid:'',
								housecertificatetype:'',
								housecertificate:'',
								housecertificatedates:'',
								housepurposes:'',
								housesource:'',
								housearea:'0.00',
								usedates:'',
								buildingcost:'',
								devicecost:'',
								underground:'0',
								status:'00'//新增行状态
							});
							editIndex = $('#fcjcxx').datagrid('getRows').length-1;  
							$('#fcjcxx').datagrid('selectRow', editIndex)  
									.datagrid('beginEdit', editIndex);  
						} 
					}
				},{
					text:'修改',
					id:'f1-edit',
					iconCls:'icon-edit',
					handler:function(){
						if(endEditing()){
							var row = $('#fcjcxx').datagrid('getSelected');
							var index = $('#fcjcxx').datagrid('getRowIndex',row);
							$('#fcjcxx').datagrid('beginEdit',index);
							editIndex = index;
						}
						//if (editIndex == undefined){return}  
						//$('#jmxx').datagrid('cancelEdit', editIndex).datagrid('deleteRow', editIndex);  
						//editIndex = undefined;
					}
				},{
					text:'删除',
					id:'f1-delete',
					iconCls:'icon-remove',
					handler:function(){
						var index = $('#fcjcxx').datagrid('getRowIndex',$('#fcjcxx').datagrid('getSelected'));
						$('#fcjcxx').datagrid('deleteRow', index);  
						editIndex = undefined;
					}
				},{
					text:'保存',
					id:'f1-save',
					iconCls:'icon-save',
					handler:function(){
						//alert(data.length);
						if(endEditing()){
							var data = $('#fcjcxx').datagrid('getChanges');
							if (data.length) {
								var inserted = $('#fcjcxx').datagrid('getChanges', "inserted");
								var deleted = $('#fcjcxx').datagrid('getChanges', "deleted");
								var updated = $('#fcjcxx').datagrid('getChanges', "updated");
								endEdits();
								var effectRow = new Object();
								var tdxxrow = $('#groundgathercheckgrid').datagrid('getSelected');//获取土地信息选中行
								var baseinfo = {"taxpayerid":tdxxrow.taxpayerid,"taxpayername":tdxxrow.taxpayername,"estateid":estateid,"housetype":"0"};
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
										   alert('保存成功');
											refreshHouse();
									   },
										error:function (data, status, e){   
											 alert("保存出错");   
										} 
							   });
							}
						}
					}
				},{
					text:'房产转租信息',
					iconCls:'icon-tip',
					handler:function(){
						var row = $('#fcjcxx').datagrid('getSelected');
						if(row){
							if(endEditing()){
								var changedata = $('#fcjcxx').datagrid('getChanges');
								if(changedata.length>0){
									alert("请先保存在建房信息");
									return;
								}
								if(row.status=='01'){
									refreshHire();
									$('#fcczfxxgrid').datagrid({
										singleSelect:'true',
										fitColumns:'true',
										rownumbers:'true',
										columns:[[
											{field:'ownerid',title:'ownerid',width:150,align:'center',hidden:'true'},   
											{field:'agreementnumber',title:'转租方文书号或协议号',width:140,align:'center',editor:{type:'validatebox',options:{required:true}}},   
											{field:'lesseesid',width:130,align:'center',hidden:true,editor:{type:'numberbox'}},  
											{field:'lesseestaxpayername',title:'转租方名称(回车查询)',width:140,align:'center',editor:{required:true,type:'validatebox'}},
											{field:'norentuseflag',title:'是否无租使用',width:100,align:'center',formatter:format,editor:{type:'combobox',options:{valueField:'label',textField: 'value',
											onChange:function(newValue,oldValue){
												var index = $('#fcczfxxgrid').datagrid('getRowIndex',$('#fcczfxxgrid').datagrid('getSelected'));
												var transmonthmoney = $('#fcczfxxgrid').datagrid('getEditor', {  
													index : index,  
													field : 'transmonthmoney'  
												});
												var transmoney = $('#fcczfxxgrid').datagrid('getEditor', {  
													index : index,  
													field : 'transmoney'  
												});
												if(newValue == '1'){
													$(transmonthmoney.target).numberbox('disable');
													$(transmonthmoney.target).numberbox('setValue','0.00');
													$(transmoney.target).numberbox('disable');
													$(transmoney.target).numberbox('setValue','0.00');
												}else{
													$(transmonthmoney.target).numberbox('enable');
													$(transmoney.target).numberbox('enable');
												}
											},
											data: [{label: '0',value: '否'},{label: '1',value: '是'}]}}},
											{field:'landtaxpayer',title:'是否缴纳土地使用税',width:140,align:'center',formatter:format,editor:{type:'combobox',options:{valueField:'label',textField: 'value',	
											onChange:function(newValue,oldValue){
												if(newValue == '0'){
													var index = $('#fcczfxxgrid').datagrid('getRowIndex',$('#fcczfxxgrid').datagrid('getSelected'));
													var edbegin = $('#fcczfxxgrid').datagrid('getEditor', {  
														index : index,  
														field : 'taxarea'  
													});
													$(edbegin.target).numberbox('disable');
													$(edbegin.target).numberbox('setValue','0.00');
												}else{
													var index = $('#fcczfxxgrid').datagrid('getRowIndex',$('#fcczfxxgrid').datagrid('getSelected'));
													var edbegin = $('#fcczfxxgrid').datagrid('getEditor', {  
														index : index,  
														field : 'taxarea'  
													});
													$(edbegin.target).numberbox('enable');
												}
											},
											data: [{label: '0',value: '否'},{label: '1',value: '是'}]}}},
											{field:'freetax',title:'是否免税单位',width:85,align:'center',formatter:format,editor:{type:'combobox',options:{valueField:'label',textField: 'value',	data: [{label: '0',value: '否'},{label: '1',value: '是'}]}}},
											{field:'landarea',title:'转租面积',width:70,align:'center',editor:{type:'numberbox',options:{precision:2,min:0,required:true}}},
											{field:'taxarea',title:'约定缴纳土地使用税面积',width:170,align:'center',editor:{type:'numberbox',options:{precision:2,min:0}}},
											{field:'transmonthmoney',title:'月租金',width:50,align:'center',editor:{type:'numberbox',options:{precision:2,min:0,required:true}}},
											{field:'transmoney',title:'年租金',width:50,align:'center',editor:{type:'numberbox',options:{precision:2,min:0,required:true}}},
											{field:'transbegindates',title:'转租时间起',width:80,align:'center',editor:{type:'datebox',options:{validType:['datecheck'],required:true}}},
											{field:'transenddates',title:'转租时间止',width:80,align:'center',editor:{type:'datebox',options:{validType:['datecheck'],required:true}}}
											]],
										toolbar:[{
											text:'新建',
											id:'f2-add',
											iconCls:'icon-add',
											handler:function(){
												if (fcczendEditing()){
													$('#fcczfxxgrid').datagrid('endEdit', sgfeditIndex);
													$('#fcczfxxgrid').datagrid('appendRow',{
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
													sgfeditIndex = $('#fcczfxxgrid').datagrid('getRows').length-1;  
													$('#fcczfxxgrid').datagrid('selectRow', sgfeditIndex)  
															.datagrid('beginEdit', sgfeditIndex);
													bindevent();
												}
											}
										},{
											text:'修改',
											id:'f2-edit',
											iconCls:'icon-edit',
											handler:function(){
												if(endEditing()){
													var row = $('#fcczfxxgrid').datagrid('getSelected');
													var index = $('#fcczfxxgrid').datagrid('getRowIndex',row);
													$('#fcczfxxgrid').datagrid('beginEdit',index);
													bindevent();
													sgfeditIndex = index;
												}
												//if (editIndex == undefined){return}  
												//$('#jmxx').datagrid('cancelEdit', editIndex).datagrid('deleteRow', editIndex);  
												//editIndex = undefined;
											}
										},{
											text:'删除',
											id:'f2-delete',
											iconCls:'icon-remove',
											handler:function(){ 
												var index = $('#fcczfxxgrid').datagrid('getRowIndex',$('#fcczfxxgrid').datagrid('getSelected'));
												$('#fcczfxxgrid').datagrid('deleteRow', index);  
												sgfeditIndex = undefined;
											}
										},{
											text:'保存',
											id:'f2-save',
											iconCls:'icon-save',
											handler:function(){
												//if(sgfeditIndex == undefined){
													//alert("undefined");
												//	var selectrow = $('#fcczfxxgrid').datagrid('getSelected');
													//alert($('#fcjcxx').datagrid('getRowIndex',selectrow));
												//	var rowindex = $('#fcczfxxgrid').datagrid('getRowIndex',selectrow);
												//	$('#fcczfxxgrid').datagrid('endEdit', rowindex)
													//sgfeditIndex = rowindex;
												//}
												if(fcczendEditing()){
													var data = $('#fcczfxxgrid').datagrid('getChanges');
													var tdxxrow = $('#groundgathercheckgrid').datagrid('getSelected');
													if (data.length) {
														var inserted = $('#fcczfxxgrid').datagrid('getChanges', "inserted");
														var deleted = $('#fcczfxxgrid').datagrid('getChanges', "deleted");
														var updated = $('#fcczfxxgrid').datagrid('getChanges', "updated");
														fcczendEdits();
														var effectRow = new Object();
														//effectRow.lessorid = $('#taxpayerid').val();
														//effectRow.estateid = tdxxrow.uuid;
														var baseinfo = {"lessorid":tdxxrow.taxpayerid,"lessortaxpayname":tdxxrow.taxpayername,"houseid":row.houseid,"estateid":estateid,"hiretype":1};
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
															   url: "/GroundInfoServlet/savelease.do",
															   data: $.toJSON(effectRow),
															   contentType: "application/json; charset=utf-8",
															   dataType: "json",
															   success: function(jsondata){
																   alert("保存成功");
																	refreshHire();
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
												$('#fcczfxxwindow').window('close');
											}
										}],
										onClickRow:function(index){
											if(sgfeditIndex == undefined){
												$('#fcczfxxgrid').datagrid('selectRow', index);
												//editIndex= index;
											}else{
												if (sgfeditIndex != index){  
													if (fcczendEditing()){  
														$('#fcczfxxgrid').datagrid('selectRow', index);  
														//editIndex = index;  
													}else{
														$('#fcczfxxgrid').datagrid('unselectRow', index);  
													}
												}
											}
										}
									});
									//var tdxxrow = $('#tdxxgrid').datagrid('getSelected');
									if(showtype=='0'){
										$('#f2-add').hide();
										$('#f2-edit').hide();
										$('#f2-delete').hide();
										$('#f2-save').hide();
									}else{
										$('#f2-add').show();
										$('#f2-edit').show();
										$('#f2-delete').show();
										$('#f2-save').show();
									}
									$('#fcczfxxwindow').window('open');
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
						$('#fcjcxx').datagrid('selectRow', index);
						//editIndex= index;
					}else{
						if (editIndex != index){  
							if (endEditing()){  
								$('#fcjcxx').datagrid('selectRow', index);  
								//editIndex = index;  
							}else{
								$('#fcjcxx').datagrid('unselectRow', index);  
							}
						}
					}
				}
			});
			//var tdxxrow = $('#tdxxgrid').datagrid('getSelected');
			if(showtype=='0'){
				$('#f1-add').hide();
				$('#f1-edit').hide();
				$('#f1-delete').hide();
				$('#f1-save').hide();
			}else{
				$('#f1-add').show();
				$('#f1-edit').show();
				$('#f1-delete').show();
				$('#f1-save').show();
			}
		});
		//结束所有行的编辑
		function endEdits(){
			var rows = $('#fcjcxx').datagrid('getRows');
			for ( var i = 0; i < rows.length; i++) {
				$('#fcjcxx').datagrid('endEdit', i);
			}
			$('#fcjcxx').datagrid('acceptChanges');
		}
		
		function endEditing(){  
            if (editIndex == undefined){return true}  
            if ($('#fcjcxx').datagrid('validateRow', editIndex)){
				$('#fcjcxx').datagrid('endEdit', editIndex);
                editIndex = undefined;  
                return true;  
            } else {  
				alert('有必填字段不能为空！');
                return false;  
            }  
        }

		//结束所有行的编辑
		function fcczendEdits(){
			var rows = $('#fcczfxxgrid').datagrid('getRows');
			for ( var i = 0; i < rows.length; i++) {
				$('#fcczfxxgrid').datagrid('endEdit', i);
			}
			$('#fcczfxxgrid').datagrid('acceptChanges');
		}
		
		function fcczendEditing(){  
            if (sgfeditIndex == undefined){return true}
            if ($('#fcczfxxgrid').datagrid('validateRow', sgfeditIndex)){
				$('#fcczfxxgrid').datagrid('endEdit', sgfeditIndex);
                sgfeditIndex = undefined;  
                return true;  
            } else {  
				alert('有必填字段不能为空！');
                return false;  
            }  
        }
		function refreshHouse(){
			//var tdxxrow = $('#tdxxgrid').datagrid('getSelected');
			//if(tdxxrow){
			$.ajax({
			   type: "post",
			   url: "/GroundInfoServlet/gethouseinfo.do",
			   data: {uuid:estateid,housetype:"0"},
			   //data: {uuid:'fe20cbad62b15bf955a2e8fc2497b92a',housetype:"0"},
			   dataType: "json",
			   success: function(jsondata){
				  $('#fcjcxx').datagrid('loadData',jsondata);
			   }
			});
			//}
		}


		function refreshHire(){
			var fcxxrow = $('#fcjcxx').datagrid('getSelected');
			if(fcxxrow){
				$.ajax({
				   type: "post",
				   url: "/GroundInfoServlet/gethireinfo.do",
				   data: {uuid:fcxxrow.houseid,hiretype:1},
				   dataType: "json",
				   success: function(jsondata){
					   //alert(JSON.stringify(jsondata));
					  $('#fcczfxxgrid').datagrid('loadData',jsondata);
				   }
				});
			}
		}
	
function formatcertyficate(row){
	for(var i=0; i<housecertyficatedata.length; i++){
		if (housecertyficatedata[i].key == row) return housecertyficatedata[i].value;
	}
	return row;
}

function formatpurpose(row){
	for(var i=0; i<houseusedata.length; i++){
		if (houseusedata[i].key == row) return houseusedata[i].value;
	}
	return row;
}

function formatsource(row){
	for(var i=0; i<housesourcedata.length; i++){
		if (housesourcedata[i].key == row) return housesourcedata[i].value;
	}
	return row;
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

var undergrounddata =[{label: '0',name: '否'},{label: '1',name: '工业'},{label: '2',name: '商业及其他'}];

function formatunderground(row){
	for(var i=0; i<undergrounddata.length; i++){
		if (undergrounddata[i].label == row) return undergrounddata[i].name;
	}
	return value;
}




//绑定回车事件
function bindevent(){
	var selectrow = $('#fcczfxxgrid').datagrid('getSelected');
	
	var index = $('#fcczfxxgrid').datagrid('getRowIndex',selectrow);
	//$('#fcczfxxgrid').datagrid('refreshRow',index);
	var ed = $('#fcczfxxgrid').datagrid('getEditor', {index:index,field:'lesseesid'});
	var ed2 = $('#fcczfxxgrid').datagrid('getEditor', {index:index,field:'lesseestaxpayername'});
	//alert(ed.target.val());
	$(ed.target).bind('keyup', function(){
		if (window.event.keyCode == 13){
			$('#reginfowindow').window('open');//打开新录入窗口
			$('#reginfowindow').window('refresh', '../grounddetail/f-reginfo.jsp');
		 }
	});
	$(ed2.target).bind('keyup', function(){
		if (window.event.keyCode == 13){
			$('#reginfowindow').window('open');//打开新录入窗口
			$('#reginfowindow').window('refresh', '../grounddetail/f-reginfo.jsp');
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
		<form id="fcjcxxform" method="post">
			<div title="房产基础信息" data-options="
				tools:[{
					handler:function(){
						$('#fcjcxx').datagrid('reload');
					}
				}]">
			<table id="fcjcxx" style="width:1200px;height:380px"
			data-options="singleSelect:true,idField:'itemid'" rownumbers="true"> 
				<thead>
					<tr>
						<th data-options="field:'houseid',id:'houseid',align:'center',hidden:'true'">houseid</th>
						<th data-options="field:'housecertificatetype',width:80,align:'center',formatter:formatcertyficate,editor:{type:'combobox',options:{editable:false,editable:false,valueField:'key',textField: 'value',	data: housecertyficatedata}}">房产证类型</th>
						<th data-options="field:'housecertificate',width:80,align:'center',editor:{type:'text',options:{required:false}}">房产产权证号</th>
						<th data-options="field:'housecertificatedates',width:60,align:'center',editor:{type:'datebox',options:{validType:['datecheck']}}">发证日期</th> 

						<th data-options="field:'housepurposes',width:60,align:'center',formatter:formatpurpose,editor:{type:'combobox',options:{
									valueField: 'key',
									textField: 'value',
									panelWidth: 300,
									data :houseusedata,
									panelHeight: 'auto'}}">房产用途</th>
						<th data-options="field:'housesource',width:80,align:'center',formatter:formatsource,editor:{type:'combobox',options:{valueField:'key',required:true,editable:false,textField: 'value',onChange:function(newValue,oldValue){
							var index = $('#fcjcxx').datagrid('getRowIndex',$('#fcjcxx').datagrid('getSelected'));
							var buildingcost = $('#fcjcxx').datagrid('getEditor', {  
								index : index,  
								field : 'buildingcost'  
							});
							var devicecost = $('#fcjcxx').datagrid('getEditor', {  
								index : index,  
								field : 'devicecost'  
							});
							var transmoney = $('#fcjcxx').datagrid('getEditor', {  
								index : index,  
								field : 'transmoney'  
							});
							if(newValue=='01'){
								$(transmoney.target).numberbox('disable');
								$(transmoney.target).numberbox('setValue','0.00');
								$(buildingcost.target).numberbox('enable');
								$(devicecost.target).numberbox('enable');
							}else{
								$(buildingcost.target).numberbox('disable');
								$(buildingcost.target).numberbox('setValue','0.00');
								$(devicecost.target).numberbox('disable');
								$(devicecost.target).numberbox('setValue','0.00');
								$(transmoney.target).numberbox('enable');
							}
						},data:housesourcedata}}">房产来源</th>
						<th data-options="field:'housearea',width:80,align:'center',editor:{type:'numberbox',options:{precision:2,min:0,required:true}}">房产建筑面积</th>
						<th data-options="field:'usedates',width:80,align:'center',editor:{type:'datebox',options:{validType:['datecheck'],required:true}}">投入使用时间</th>
						<th data-options="field:'buildingcost',width:80,align:'center',editor:{type:'numberbox',options:{precision:2,min:0,required:true}}">建筑安装成本</th>
						<th data-options="field:'devicecost',width:180,align:'center',editor:{type:'numberbox',options:{precision:2,min:0,required:true}}">应计入房产原值与房屋不可分割的设备价款</th>
						<th data-options="field:'transmoney',width:70,align:'center',editor:{type:'numberbox',options:{precision:2,min:0,required:true}}">年租金</th>
						<th data-options="field:'underground',width:80,align:'center',formatter:formatunderground,editor:{type:'combobox',options:{valueField:'label',editable:false,textField: 'name',	data: [{label: '0',name: '否'},{label: '1',name: '工业'},{label: '2',name: '商业及其他'}]}}">是否单独地下建筑</th>
						<th data-options="field:'status',id:'status',width:100,align:'center',hidden:'true',editor:{type:'combobox'}">状态</th>
					</tr>
				</thead>
			</table>
		</div>
		<div id="fcczfxxwindow" class="easyui-window" data-options="closed:true,modal:true,title:'房产转租方信息',collapsible:false,minimizable:false,maximizable:false,closable:false" style="width:1100px;height:400px;">
		<table id="fcczfxxgrid"></table>
		</div>

		</form>
</body>
  
</html>
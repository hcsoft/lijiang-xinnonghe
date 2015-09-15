<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
	<base target="_self"/>
	<title></title>

	<link rel="stylesheet" href="/themes/sunny/easyui.css">
	<link rel="stylesheet" href="/themes/icon.css">
	<link rel="stylesheet" href="/css/toolbar.css">
	<link rel="stylesheet" href="/css/logout.css"/>
	<script src="/js/jquery-1.8.2.min.js"></script>
	<script src="/js/jquery.easyui.min.js"></script>
	<script src="/js/dropdown.js"></script>
    <script src="/js/tiles.js"></script>
    <script src="/js/moduleWindow.js"></script>
	<script src="/menus.js"></script>
	
	<script src="/js/jquery.simplemodal.js"></script>
	<script src="/js/overlay.js"></script>
	<script src="/js/jquery.json-2.2.js"></script>
	<script src="/js/json2.js"></script>
	<script src="/locale/easyui-lang-zh_CN.js"></script>

	
</head>
<body>
<script>
	$(function(){
		//alert(opttype);
		if(opttype=='modify'){
			var row = $('#groundstoragegrid').datagrid('getSelected');
			approvetype = row.approvetype;
			$('#laststep').hide();
			$.ajax({
			   type: "post",
			   url: "/InitGroundServlet/getlandstoremain.do",
			   data: {landstoreid:row.landstoreid},
			   dataType: "json",
			   success: function(jsondata){
					$('#sotremainform').form('load',jsondata);
					$('#groundstoragedetailgrid').datagrid('loadData',jsondata.subvolist);
			   }
			});
		}
		$('#groundstoragedetailgrid').datagrid({
				singleSelect:'true',
				fitColumns:'true',
				rownumbers:'true',
				toolbar:[{
					text:'新建',
					iconCls:'icon-add',
					handler:function(){
						if (endEditing()){
							$('#groundstoragedetailgrid').datagrid('endEdit', editIndex);
							$('#groundstoragedetailgrid').datagrid('appendRow',{
								landstorsubid:'',
								belongtocountry:'',
								belongtowns:'',
								detailaddress:'',
								//areatotal:'0.00',
								areaplough:'0.00',
								areabuild:'0.00',
								areauseless:'0.00'
							});
							editIndex = $('#groundstoragedetailgrid').datagrid('getRows').length-1;  
							$('#groundstoragedetailgrid').datagrid('selectRow', editIndex)  
									.datagrid('beginEdit', editIndex);
						}
					}
				},{
					text:'修改',
					iconCls:'icon-edit',
					handler:function(){
						if(endEditing()){
							var row = $('#groundstoragedetailgrid').datagrid('getSelected');
							var index = $('#groundstoragedetailgrid').datagrid('getRowIndex',row);
							$('#groundstoragedetailgrid').datagrid('beginEdit',index);
							editIndex = index;
						}
					}
				},{
					text:'删除',
					iconCls:'icon-remove',
					handler:function(){
						var index = $('#groundstoragedetailgrid').datagrid('getRowIndex',$('#groundstoragedetailgrid').datagrid('getSelected'));
						//alert(index);
						if(index >=0){
							$('#groundstoragedetailgrid').datagrid('deleteRow', index);    
							editIndex = undefined;
						}
					}
				},{
					text:'保存',
					iconCls:'icon-save',
					handler:function(){
						if(!$('#name').validatebox('isValid')){
							$.messager.alert('提示','批复名称不能为空！');
							return;
						}
						if($('#approvenumber').val()=='' && $('#approvenumbercity').val()==''){
							$.messager.alert('提示','批复文号必填一个！');
							return;
						}
						if(!$('#approvedates').datebox('isValid')){
							$.messager.alert('提示','批复时间不能为空或内容不合法！');
							return;
						}
						var effectRow = new Object();
						if(endEditing()){
							var data = $('#groundstoragedetailgrid').datagrid('getChanges');
							//var row = $('#groundstoragegrid').datagrid('getSelected');
							if (data.length) {
								var inserted = $('#groundstoragedetailgrid').datagrid('getChanges', "inserted");
								var deleted = $('#groundstoragedetailgrid').datagrid('getChanges', "deleted");
								var updated = $('#groundstoragedetailgrid').datagrid('getChanges', "updated");
								//alert("inserted="+inserted.length+"---deleted="+deleted.length+"-----updated="+updated.length);
								endEdits();
								var baseinfo = {"landstoreid":$('#landstoreid').val()};
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
							}
						}
						var params = {};
						var fields =$('#sotremainform').serializeArray();
						$.each( fields, function(i, field){
							params[field.name] = field.value;
						});
						params.approvetype = approvetype;
						params.datatype = datatype;
						//alert(params);
						effectRow.maininfo = params;
						//alert(JSON.stringify(effectRow));
						$.ajax({
							   type: "post",
							   url: "/InitGroundServlet/savelandstoremain.do",
							   data: $.toJSON(effectRow),
							   contentType: "application/json; charset=utf-8",
							   dataType: "json",
							   success: function(jsondata){
								   $('#groundstoragegrid').datagrid('reload');
								   $('#sotremainform').form('load',jsondata);
								   $('#groundstoragedetailgrid').datagrid('loadData',jsondata.subvolist);
								   //refreshLandstoredetail();
								   $.messager.alert('返回消息','保存成功');
								   $('#groundstorewindow').window('close');
							   },
								error:function (data, status, e){   
									 $.messager.alert('返回消息',"保存出错");   
								} 
					   });
					}
				}],
				onClickRow:function(index){
					if(editIndex == undefined){
						$('#groundstoragedetailgrid').datagrid('selectRow', index);
					}else{
						if (editIndex != index){  
							if (endEditing()){  
								$('#groundstoragedetailgrid').datagrid('selectRow', index);  
							}else{
								$('#groundstoragedetailgrid').datagrid('unselectRow', index);  
							}
						}
					}
				}
			});
		});
	


	function openregwindow(){
		//alert('aaa');
		$('#reginfowindow').window('open');//打开新录入窗口
		$('#reginfowindow').window('refresh', 'reginfo.jsp');
	}

	$.extend($.fn.validatebox.defaults.rules, {   
		datecheck: {   
			validator: function(value){ 
				return /^((((1[6-9]|[2-9]\d)\d{2})-(0?[13578]|1[02])-(0?[1-9]|[12]\d|3[01]))|(((1[6-9]|[2-9]\d)\d{2})-(0?[13456789]|1[012])-(0?[1-9]|[12]\d|30))|(((1[6-9]|[2-9]\d)\d{2})-0?2-(0?[1-9]|1\d|2[0-8]))|(((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))-0?2-29-))$/.test(value);
			},   
			message: '时间格式不合法，格式为YYYY-MM-DD 如：2013-01-03'  
		}   
	});

	function laststep(){
		$('#groundstorewindow').window('refresh', 'groundstoretypeselect.jsp');
	}
	</script>
	<form id="sotremainform" method="post">
		<div title="批复信息" data-options="" style="overflow:auto">
			<table  width="100%" class="table table-bordered">
					<input id="landstoreid"  type="hidden" name="landstoreid"/>	
					<input type="hidden" name="taxpayer" id="taxpayer" />
					<input type="hidden" name="taxpayername" id="taxpayer" />
					<tr>
						<td align="right">批复名称：</td>
						<td colspan="3">
							<input class="easyui-validatebox" style="width:620px;" name="name" id="name" data-options="required:true"/>					
						</td>
					</tr>
					<tr>
						<td align="right">厅级批准文号：</td>
						<td><input id="approvenumber" class="easyui-validatebox" type="text" name="approvenumber"/></td>
						<td align="right">市级批准文号：</td>
						<td>
							<input id="approvenumbercity" class="easyui-validatebox" type="text" name="approvenumbercity"/>
						</td>
					</tr>
					<!-- <tr>
						<td align="right">纳税人计算机编码：</td>
						<td>
							<input class="easyui-validatebox" name="taxpayer" id="taxpayer"/>					
						</td>
						<td align="right">纳税人计算机名称：</td>
						<td>
							<input class="easyui-validatebox" name="taxpayername" id="taxpayername"/>					
						</td>
					</tr> -->
					<tr>
						<td align="right">批复日期：</td>
						<td colspan="3">
							<input id="approvedates" class="easyui-datebox" name="approvedates" data-options="validType:['datecheck'],required:true"/>
						</td>
					</tr>
					
				</table>
			<div style="text-align:center;padding:5px;">  
					<a href="#" id = "laststep" class="easyui-linkbutton" data-options="iconCls:'icon-arrow_left'" onclick="laststep()">上一步</a>
					<!-- <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="nextstep()">下一步</a> -->
					<!-- <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="openregwindow()">税务登记查询</a> -->
			</div>
		</div>
	</form>
		<div title="" style="overflow:auto" data-options="
						tools:[{
							handler:function(){
								$('#groundstoragedetailgrid').datagrid('reload');
							}
						}]">
					<table id="groundstoragedetailgrid" 
					data-options="iconCls:'icon-edit',singleSelect:true" rownumbers="true"> 
						<thead>
							<tr>
								<th data-options="field:'landstorsubid',width:80,align:'center',hidden:'true'"></th>
								<th data-options="field:'approvetype',width:80,align:'center',hidden:'true'"></th>
								<th data-options="field:'belongtocountry',width:80,align:'center',formatter:format,editor:{type:'combobox',options:{required:true,editable:false,valueField:'key',textField: 'value',
								onChange:function(newValue, oldValue){
										var index = $('#groundstoragedetailgrid').datagrid('getRowIndex',$('#groundstoragedetailgrid').datagrid('getSelected'));
										var belongtown = $('#groundstoragedetailgrid').datagrid('getEditor', {  
											index : index,  
											field : 'belongtowns'  
										});
										if(newValue != ''){
											var newarray = new Array();
											for (var i = 0; i < belongtowns.length; i++) {
												if(belongtowns[i].key.indexOf(newValue)==0){
													var rowdata = {};
													rowdata.key = belongtowns[i].key;
													rowdata.value = belongtowns[i].value;
													newarray.push(rowdata);
												}
											};
											$(belongtown.target).combobox({
												width:150,
												required:true,
												data : newarray,
												valueField:'key',
												textField:'value'
											});
										}
									},data:belongtocountry}}">所属乡镇</th>
								<th data-options="field:'belongtowns',width:100,align:'center',formatter:format,editor:{type:'combobox',options:{required:true,editable:false,valueField:'key',textField: 'value',data:belongtowns}}">坐落位置</th>
								<th data-options="field:'detailaddress',width:120,align:'center',editor:{type:'text',options:{required:false}}">详细地址</th>
								<th data-options="field:'areaplough',width:50,align:'center',editor:{type:'numberbox',options:{precision:2,min:0,required:true}}">耕地面积</th>
								<th data-options="field:'areabuild',width:50,align:'center',editor:{type:'numberbox',options:{precision:2,min:0,required:true}}">建设用地面积</th>
								<th data-options="field:'areauseless',width:50,align:'center',editor:{type:'numberbox',options:{precision:2,min:0,required:true}}">未利用地面积</th>
							</tr>
						</thead>
					</table>
		</div>
	
</body>
</html>
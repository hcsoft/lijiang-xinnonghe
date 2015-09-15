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

	
</head>
<body>
<script>
	$(function(){
		$.ajax({
		   type: "post",
			async:false,
		   url: "/ComboxService/getdistricttree.do",
			data: {id:'530721'},
		   dataType: "json",
		   success: function(jsondata){
			  $('#org_code').combotree({
					data : jsondata,
					valueField:'id',
					textField:'text'
				});	
		   }
		});
		if(opttype=='modify'){
			var row = $('#userinfogrid').datagrid('getSelected');
			approvetype = row.approvetype;
			$('#laststep').hide();
			$.ajax({
			   type: "post",
			   url: "<%=request.getContextPath()%>/Userinfo/getUnioninfo.do",
			   data: {user_id:row.user_id},//获取户主信息
			   dataType: "json",
			   success: function(jsondata){
				    jsondata.birthday=formatterDate(jsondata.birthday);
					$('#sotremainform').form('load',jsondata);
					for(var i=0;i<jsondata.memberlist.length;i++){
						jsondata.memberlist[i].birthday = formatterDate(jsondata.memberlist[i].birthday);
					}
					$('#uniondetailgrid').datagrid('loadData',jsondata.memberlist);
			   }
			});
		}
		$('#uniondetailgrid').datagrid({
				singleSelect:'true',
				fitColumns:'true',
				rownumbers:'true',
				toolbar:[{
					text:'新建',
					iconCls:'icon-add',
					handler:function(){
						if (endEditing()){
							$('#uniondetailgrid').datagrid('endEdit', editIndex);
							$('#uniondetailgrid').datagrid('appendRow',{
								user_id:'',
								user_name:'',
								gender:'01',
								birthday:'',
								leader_relation:''
							});
							editIndex = $('#uniondetailgrid').datagrid('getRows').length-1;  
							$('#uniondetailgrid').datagrid('selectRow', editIndex)  
									.datagrid('beginEdit', editIndex);
						}
					}
				},{
					text:'修改',
					iconCls:'icon-edit',
					handler:function(){
						if(endEditing()){
							var row = $('#uniondetailgrid').datagrid('getSelected');
							var index = $('#uniondetailgrid').datagrid('getRowIndex',row);
							$('#uniondetailgrid').datagrid('beginEdit',index);
							editIndex = index;
						}
					}
				},{
					text:'删除',
					iconCls:'icon-remove',
					handler:function(){
						var index = $('#uniondetailgrid').datagrid('getRowIndex',$('#uniondetailgrid').datagrid('getSelected'));
						//alert(index);
						if(index >=0){
							$('#uniondetailgrid').datagrid('deleteRow', index);    
							editIndex = undefined;
						}
					}
				},{
					text:'保存',
					iconCls:'icon-save',
					handler:function(){
						if(!$('#user_name').validatebox('isValid')){
							$.messager.alert('提示','户主名称不能为空！');
							return;
						}
						if(!$('#union_id').validatebox('isValid')){
							$.messager.alert('提示','合作医疗证号不能为空！');
							return;
						}
						if(!$('#card_id').validatebox('isValid')){
							$.messager.alert('提示','卡号不能为空！');
							return;
						}
						if($('#org_code').combo('getValue')==''){
							$.messager.alert('提示','所属行政区不能为空！');
							return;
						}
						
						if($('#org_code').combo('getValue').length != 12){
							$.messager.alert('提示','所属行政区必须到村委会级别！');
							return;
						}
						//if(!$('#age').validatebox('isValid')){
						//	$.messager.alert('提示','年龄不能为空！');
						//	return;
						//}
						var effectRow = new Object();
						if(endEditing()){
							var data = $('#uniondetailgrid').datagrid('getChanges');
							//var row = $('#userinfogrid').datagrid('getSelected');
							if (data.length) {
								var inserted = $('#uniondetailgrid').datagrid('getChanges', "inserted");
								var deleted = $('#uniondetailgrid').datagrid('getChanges', "deleted");
								var updated = $('#uniondetailgrid').datagrid('getChanges', "updated");
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
						}
						var params = {};
						var fields =$('#sotremainform').serializeArray();
						$.each( fields, function(i, field){
							params[field.name] = field.value;
						});
						effectRow.maininfo = params;
						//alert(JSON.stringify(effectRow));
						$.ajax({
							   type: "post",
							   url: "<%=request.getContextPath()%>/Userinfo/saveUnioninfo.do",
							   data: $.toJSON(effectRow),
							   contentType: "application/json; charset=utf-8",
							   dataType: "json",
							   success: function(jsondata){
								   $('#userinfogrid').datagrid('reload');
								   jsondata.birthday=formatterDate(jsondata.birthday);
								   $('#sotremainform').form('load',jsondata);
								   for(var i=0;i<jsondata.memberlist.length;i++){
										jsondata.memberlist[i].birthday = formatterDate(jsondata.memberlist[i].birthday);
									}
								   $('#uniondetailgrid').datagrid('loadData',jsondata.memberlist);
								   //refreshLandstoredetail();
								   $.messager.alert('返回消息','保存成功');
								   $('#groundstorewindow').window('close');
								   query();
							   },
								error:function (data, status, e){   
									 $.messager.alert('返回消息',"保存出错");   
								} 
					   });
					}
				}],
				onClickRow:function(index){
					if(editIndex == undefined){
						$('#uniondetailgrid').datagrid('selectRow', index);
					}else{
						if (editIndex != index){  
							if (endEditing()){  
								$('#uniondetailgrid').datagrid('selectRow', index);  
							}else{
								$('#uniondetailgrid').datagrid('unselectRow', index);  
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
	
	function next(obj){
		if(event.keyCode==13){ 
			//alert($('#user_name').length);
			$('#user_name')[0].focus();
		}
	}
	var genderdata = [{label:'01',name:'男'},{label:'02',name:'女'}];
	function formatgender(row){
		for(var i=0; i<genderdata.length; i++){
			if (genderdata[i].label == row) return genderdata[i].name;
		}
		return row;
	}
	</script>
	<form id="sotremainform" method="post">
		<div title="登记信息" data-options="" style="overflow:auto">
			<table  width="100%" class="table table-bordered">
					<input id="user_id"  type="hidden" name="user_id"/>	
					<tr>
						<td align="right">合作医疗证号：</td>
						<td>
							<input class="easyui-validatebox" name="union_id" id="union_id" style="width:200px;" data-options="required:true"/>					
						</td>
						<td align="right">卡号：</td>
						<td>
							<input class="easyui-validatebox" name="card_id" id="card_id" style="width:200px;" onkeydown="next(this);" data-options="required:true"/>					
						</td>
					</tr>
					<tr>
						<td align="right">户主名称：</td>
						<td><input id="user_name" class="easyui-validatebox" type="text" style="width:200px;" name="user_name" data-options="required:true"/></td>
						<td align="right">性别：</td>
						<td>
							<select id="gender" class="easyui-combobox" name="gender" style="width:200px;" data-options="required:true" editable="false">
								<option value="01">男</option>
								<option value="02">女</option>
							</select>
						</td>
					</tr>
					<tr>
						<td align="right">出生日期：</td>
						<td>
							<input id="birthday" class="easyui-datebox" style="width:200px" name="birthday" data-options="required:true"/>			
						</td>
						<td align="right">联系电话：</td>
						<td>
							<input class="easyui-validatebox" name="telephone" id="telephone" style="width:200px;" data-options="required:false"/>
						</td>
					</tr>
					<tr>
						<td align="right">身份证号：</td>
						<td>
							<input class="easyui-validatebox" name="idnumber" id="aidnumberge" style="width:200px;" data-options="required:false"/>				
						</td>
						<td align="right">所属行政区：</td>
						<td>
							<select id="org_code" class="easyui-combotree" style="width:200px;"  data-options="required:true" name="org_code"></select>
						</td>
					</tr>
					<tr>
						<td align="right">小组：</td>
						<td>
							<input class="easyui-validatebox" name="team" id="address" style="width:200px;" data-options="required:false"/>
						</td>
						<td align="right">人员属性：</td>
						<td>
							<select id="role_id" class="easyui-combobox" name="role_id" style="width:200px;" data-options="required:true" editable="false">
								<option value="10" selected>一般人员</option>
								<option value="20">五保</option>
								<option value="30">低保</option>
								<option value="40">优扰</option>
								<option value="50">残疾</option>
								<option value="60">残疾</option>
							</select>
						</td>
					</tr>
				</table>
			
		</div>
	</form>
		<div title="" style="overflow:auto" data-options="
						tools:[{
							handler:function(){
								$('#uniondetailgrid').datagrid('reload');
							}
						}]">
					<table id="uniondetailgrid" 
					data-options="iconCls:'icon-edit',singleSelect:true" rownumbers="true"> 
						<thead>
							<tr>
								<th data-options="field:'user_id',width:80,align:'center',hidden:'true'"></th>
								<th data-options="field:'user_name',width:120,align:'center',editor:{type:'text',options:{required:false}}">人员名称</th>
								<th data-options="field:'gender',width:50,align:'center',formatter:formatgender,editor:{type:'combobox',options:{valueField:'label',textField: 'name',data:genderdata}}">性别</th>
								<th data-options="field:'birthday',width:50,align:'center',editor:{type:'datebox',options:{required:true}}">出生日期</th>
								<th data-options="field:'leader_relation',width:150,align:'center',editor:{type:'text',options:{required:false}}">与户主关系</th>
							</tr>
						</thead>
					</table>
		</div>
	
</body>
</html>
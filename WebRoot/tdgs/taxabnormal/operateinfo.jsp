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
	<link rel="stylesheet" href="/css/tablen.css"/>
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
	<script src="/js/jquery.simplemodal.js"></script>
   	<script src="/js/uploadmodal.js"></script> 

	
</head>
<body>
	<script>
	var btype;
	$(function(){
			$('#operategrid').datagrid({
				fitColumns:'true',
				maximized:'true',
				pagination:false,
				toolbar:[{
					text:'新增',
					id:'add',
					iconCls:'icon-add',
					handler:function(){
						$('#operationwindow').window('open');
						$('#operationform').form('clear');
						btype='add';
					}
				},{
					text:'修改',
					id:'edit',
					iconCls:'icon-edit',
					handler:function(){
						var row = $('#operategrid').datagrid('getSelected');
						if(row){
							$('#operationwindow').window('open');
							btype='edit';
							$('#opttype').val(row.opttype);
							$('#optopinion').val(row.optopinion);
							$('#recno').val(row.recno);
						}else{
							alert("请选择要修改的记录！");
						}
					}
				},{
					text:'删除',
					id:'delete',
					iconCls:'icon-cancel',
					handler:function(){
						var row = $('#operategrid').datagrid('getSelected');
						if(row){
							$.messager.confirm('提示框', '你确定要删除吗?',function(r){
								if(r){
									btype='delete';
									save();
								}
							})
						}else{
							alert("请选择要删除的记录！");
						}
					}
				}],
				onClickRow:function(index){
					var row = $('#operategrid').datagrid('getSelected');
					if(row.checktype == '1' || row.checktype == '2'){
						$('#edit').linkbutton('disable');
						$('#delete').linkbutton('disable');
					}else{
						$('#edit').linkbutton('enable');
						$('#delete').linkbutton('enable');
					}
				},
				onLoadSuccess:function(data){
					if(data.optflag=='1'){
						$('#add').linkbutton('enable');
					}else{
						$('#add').linkbutton('disable');
					}
				}
			});
			
			var p = $('#operategrid').datagrid('getPager');  
			$(p).pagination({  
				showPageList:false
			});
			operationquery();
	});
	
	function operationquery(querytype){
		var params = {};
		params.taxpayerid = taxpayerid;
		params.taxcode = taxcode;
		params.taxdatebegin = taxdatebegin;
		params.taxdateend = taxdateend;
		params.page=1;
		$.ajax({
		   type: "post",
		   url: "/TaxabnormalServlet/getabnormalinfo.do",
		   data: params,
		   dataType: "json",
		   success: function(jsondata){
			  $('#operategrid').datagrid('loadData',jsondata);
			  var p = $('#operategrid').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
				});
		   }
		});
	}
	function save(){
		var params = {};
		var fields =$('#operationform').serializeArray();
		$.each( fields, function(i, field){
			params[field.name] = field.value;
		}); 
		params.taxpayerid = taxpayerid;
		params.taxcode = taxcode;
		params.taxdatebegins = taxdatebegin;
		params.taxdateends = taxdateend;
		params.btype = btype;
		if(params.opttype==''){
			alert("请选择处理结果");
			return;
		}
		$.ajax({
		   type: "post",
		   url: "/TaxabnormalServlet/saveoperation.do",
		   data: params,
		   dataType: "json",
		   success: function(jsondata){
			   operationquery();
			  $('#operationwindow').window('close');
			  $.messager.alert('返回消息','保存成功！');
		   }
		});
	}
	</script>
	<form id="operationform1" method="post">
		<div title="处理信息" data-options="
					tools:[{
						handler:function(){
							$('#operategrid').datagrid('reload');
						}
					}]">
			<table id="operategrid" style="overflow:auto" 
			data-options="iconCls:'icon-edit',singleSelect:true" rownumbers="true"> 
				<thead>
					<tr>
						<th data-options="colspan:3,align:'center',editor:{type:'validatebox'}">税收管理员处理结果</th>
						<th data-options="colspan:3,align:'center',editor:{type:'validatebox'}">分局长审核结果</th>
					</tr>
					<tr>
						<th data-options="field:'recno',width:80,hidden:true,align:'center',editor:{type:'validatebox'}"></th>
						<th data-options="field:'optdates',width:80,align:'center',editor:{type:'validatebox'}">处理时间</th>
						<th data-options="field:'opttype',width:100,align:'left',formatter:function(value,row,index){
										if(value=='2'){
											return '认定欠税';
										}else if(value=='5'){
											return '认定完税';
										}else{
											return '正在落实';
										}
									},editor:{type:'validatebox'}">处理结果</th>
						<th data-options="field:'optopinion',width:200,align:'left',editor:{type:'validatebox'}">备注</th>
						<th data-options="field:'checkdates',width:80,align:'center',editor:{type:'validatebox'}">审核时间</th>
						<th data-options="field:'checktype',width:100,align:'left',formatter:function(value,row,index){
										if(value=='1'){
											return '审核通过';
										}else if(value=='2'){
											return '审核不通过';
										}else{
											return value;
										}
									},editor:{type:'validatebox'}">审核结果</th>
						<th data-options="field:'checkopinion',width:200,align:'left',editor:{type:'validatebox'}">备注</th>
					</tr>
				</thead>
			</table>
		</div>
	</form>
	<div id="operationwindow" class="easyui-window" data-options="closed:true,modal:true,title:'处理窗口',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:550px;height:280px;">
		<div class="easyui-panel" title="" style="width:500px;">
			<form id="operationform" method="post">
				<table id="operation" width="100%" class="table table-bordered">
				<input type="hidden" id="recno" name="recno" />
					<tr>
						<td align="right">处理结果：</td>
						<td>
							<select id="opttype" class="easyui-combobox" style="width:200px" name="opttype" editable="false">
								<!-- <option value="1" selected>正在落实</option> -->
								<option value="2" selected>认定欠税</option>
								<option value="5">认定完税</option>
							</select>
						</td>
					</tr>
					<tr>
						<td align="right">备注：</td>
						<td>
							<input class="easyui-validatebox" name="optopinion" style="width:400px;height:100px" id="optopinion"/>					
						</td>
					</tr>
				</table>
			</form>
			<div style="text-align:center;padding:5px;">
				<a href="###" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save()">保存</a>
			</div>
		</div>
	</div>
	<!-- <div id="groundstoragedetailwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地收储批复明细',collapsible:false,minimizable:false,maximizable:false,closable:false" style="width:800px;height:400px;">
	<table id="groundstoragedetailgrid"></table>
	</div> -->
	<!-- <div id="groundstorageaddwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地收储批复新增',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:200px;">
	</div> -->
	<!-- <div id="addtdxxwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地信息',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:500px;">
	</div> -->

</body>
</html>
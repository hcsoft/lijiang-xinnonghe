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
	<link rel="stylesheet" href="<%=request.getContextPath()%>/css/tablen.css"/>
	<script src="<%=request.getContextPath()%>/js/jquery-1.8.2.min.js"></script>
	<script src="<%=request.getContextPath()%>/js/jquery.easyui.min.js"></script>
    <script src="<%=request.getContextPath()%>/js/tiles.js"></script>
    <script src="<%=request.getContextPath()%>/js/moduleWindow.js"></script>
	<script src="<%=request.getContextPath()%>/menus.js"></script>
	<script src="<%=request.getContextPath()%>/js/common.js"></script>
	<script src="<%=request.getContextPath()%>/js/jquery.simplemodal.js"></script>
	<script src="<%=request.getContextPath()%>/js/overlay.js"></script>
	<script src="<%=request.getContextPath()%>/js/jquery.json-2.2.js"></script>
	<script src="<%=request.getContextPath()%>/js/json2.js"></script>
	<script src="<%=request.getContextPath()%>/locale/easyui-lang-zh_CN.js"></script>
	<script src="<%=request.getContextPath()%>/js/jquery.simplemodal.js"></script>
   	<script src="<%=request.getContextPath()%>/js/uploadmodal.js"></script> 

	<script>
	var taxorgdata = new Object;
	var orgtree = new Object;
	var opttype;//操作类型
	var selectindex;
	$(function(){
		var paraString = location.search;     
		var paras = paraString.split("&");   
		datatype = paras[0].substr(paras[0].indexOf("=") + 1); 
		
			$.ajax({
			   type: "post",
				async:false,
			   url: "/ComboxService/getComboxs.do",
			   data: {codetablename:'COD_TAXORGCODE'},
			   dataType: "json",
			   success: function(jsondata){
				  taxorgdata= jsondata;
			   }
			});
			
			$('#orginfogrid').datagrid({
				fitColumns:'true',
				maximized:'true',
				pagination:true,
				view:viewed,
				toolbar:[{
					text:'查询',
					iconCls:'icon-search',
					handler:function(){
						$('#userquerywindow').window('open');
					}
				},{
					text:'新增',
					iconCls:'icon-add',
					handler:function(){
						opttype='add';
						$('#orgwindow').window('open');
						$('#orgwindow').window('refresh', 'orgdetail.jsp');
					}
				},{
					text:'修改',
					iconCls:'icon-edit',
					id:'edit',
					handler:function(){
						var row = $('#orginfogrid').datagrid('getSelected');
						if(row && selectindex != undefined){
							opttype='modify';
							$('#orgwindow').window('open');
							$('#orgwindow').window('refresh', 'orgdetail.jsp');
						}
						
					}
				},{
					text:'删除',
					iconCls:'icon-cancel',
					id:'del',
					handler:function(){
						var row = $('#orginfogrid').datagrid('getSelected');
						if(row && selectindex != undefined){
							$.messager.confirm('提示框', '你确定要删除吗?',function(r){
								if(r){
									$.ajax({
										type: "post",
										url: "<%=request.getContextPath()%>/Manager/delorg.do",
										data: {taxorgcode:row.taxorgcode},
										dataType: "json",
										success: function(jsondata){
											$.messager.alert('返回消息',"删除成功");
											$('#orginfogrid').datagrid('reload');
											selectindex = undefined;
											//$('#orginfogrid').datagrid('selectRow',selectindex);
										}
									});
								}
							})
						}
					}
				}],
				onClickRow:function(index){
					var row = $('#orginfogrid').datagrid('getSelected');
					selectindex = row.index;
					$('#edit').linkbutton('enable');
					$('#del').linkbutton('enable');
					if(row.parentId=='0'){
						$('#edit').linkbutton('disable');
						$('#del').linkbutton('disable');
					}
				},
				onClickCell: function (rowIndex, field, value) {
					if(field=="file"){
						$('#orginfogrid').datagrid('selectRow',rowIndex);
						var row = $('#orginfogrid').datagrid('getSelected');
						businesscode = row.businesscode;
						businessnumber = row.businessnumber;
						//alert(businesscode+"-----"+businessnumber);
					}
				}
			});
			
			var p = $('#orginfogrid').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false,
					pageSize: 15
				});

				setTimeout('query()',100);
		});
	var viewed = $.extend({},$.fn.datagrid.defaults.view,{
				onAfterRender: function(target){
								$('#orginfogrid').datagrid('unselectAll');
							} 
				});
	
	function endEditing(){  
        if (editIndex == undefined){return true}
        if ($('#uniondetailgrid').datagrid('validateRow', editIndex)){
			$('#uniondetailgrid').datagrid('endEdit', editIndex);
            editIndex = undefined;  
            return true;  
        } else {  
            return false;  
        }  
    }
		function query(){
			var params = {};
			var fields =$('#userqueryform').serializeArray();
			$.each( fields, function(i, field){
				params[field.name] = field.value;
			}); 
			//$('#orginfogrid').datagrid({
			//	url:'/InitGroundServlet/getlandstoreinfo.do'
			//});
			params.datatype=datatype;
			//$('#orginfogrid').datagrid('loadData',{total:0,rows:[]});
			//$('#dg').datagrid({
			//	url:'<%=request.getContextPath()%>/Manager/getorglist.do',
			//	queryParams: params
			//});
			var opts = $('#orginfogrid').datagrid('options');
			opts.url = '<%=request.getContextPath()%>/Manager/getorglist.do';
			$('#orginfogrid').datagrid('load',params); 
			var p = $('#orginfogrid').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false,
				pageSize: 15
			});
			$('#userquerywindow').window('close');
		}


	</script>
</head>
<body>
	<form id="groundstorageform" method="post">
		<div title="登记信息" data-options="">
					
						<table id="orginfogrid" style="overflow:auto" 
						data-options="iconCls:'icon-edit',singleSelect:true,idField:'itemid'" rownumbers="true"> 
							<thead>
								<tr>
									<th data-options="field:'taxorgcode',width:80,align:'left',editor:{type:'validatebox'}">医疗机构代码</th>
									<th data-options="field:'taxorgname',width:80,align:'left',editor:{type:'validatebox'}">医疗结构名称</th>
									<th data-options="field:'parentId',width:200,align:'left',formatter:function(value,row,index){
										for(var i=0; i<taxorgdata.length; i++){
											if (taxorgdata[i].key == value) return taxorgdata[i].value;
										}
										return value;
									},editor:{type:'validatebox'}">上级医疗机构</th>
									<th data-options="field:'valid',width:100,align:'left',formatter:function(value,row,index){
										if(value=='01'){
											return '有效';
										}
										if(value=='00'){
											return '无效';
										}
									},
									
									editor:{type:'validatebox'}">有效标识</th>
								</tr>
							</thead>
						</table>
					
			</div>
	</form>
	<div id="userquerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'医疗机构查询',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:150px;">
		<div class="easyui-panel" title="" style="width:900px;">
			<form id="userqueryform" method="post">
				<table id="narjcxx" width="100%"  class="table table-bordered">
					
					<tr>
						<td align="right">医疗机构代码：</td>
						<td>
							<input id="taxorgcode" class="easyui-validatebox" type="text" style="width:200px" name="taxorgcode" />
						</td>
						<td align="right">医疗机构名称：</td>
						<td>
							<input id="taxorgname" class="easyui-validatebox" type="text" style="width:200px" name="taxorgname"/>
						</td>
						
					</tr>
				</table>
			</form>
			<div style="text-align:center;padding:5px;">  
					<a href="###" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="query()">查询</a>
					<!-- <a href="#" class="easyui-linkbutton" id="aaa" data-options="iconCls:'icon-search'" >查询</a> -->
			</div>
		</div>
	</div>
	
	<div id="orgwindow" class="easyui-window" data-options="closed:true,modal:true,title:'医疗机构维护',collapsible:false,minimizable:false,maximizable:false,closable:true,resizable:false" style="width:400px;height:250px;">
	</div>
	

</body>
</html>
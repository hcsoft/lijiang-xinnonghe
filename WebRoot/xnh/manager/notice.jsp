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
	var empdata = new Object;
	var orgdata = new Object;
	var orgtree = new Object;
	var opttype;//操作类型
	var selectindex;
	var roledata;
	$(function(){
		var paraString = location.search;     
		var paras = paraString.split("&");   
		datatype = paras[0].substr(paras[0].indexOf("=") + 1); 
		
			$.ajax({
			   type: "post",
				async:false,
			   url: "/ComboxService/getComboxs.do",
			   data: {codetablename:'COD_TAXEMPCODE'},
			   dataType: "json",
			   success: function(jsondata){
				  empdata= jsondata;
			   }
			});
			$.ajax({
			   type: "post",
				async:false,
			   url: "/ComboxService/getComboxs.do",
			   data: {codetablename:'COD_TAXORGCODE'},
			   dataType: "json",
			   success: function(jsondata){
				  orgdata= jsondata;
			   }
			});
			$('#noticeinfogrid').datagrid({
				fitColumns:'true',
				maximized:'true',
				pagination:true,
				view:viewed,
				toolbar:[{
					text:'查询',
					iconCls:'icon-search',
					handler:function(){
						$('#noticequerywindow').window('open');
					}
				},{
					text:'新增',
					iconCls:'icon-add',
					handler:function(){
						opttype='add';
						$('#noticewindow').window('open');
						$('#noticewindow').window('refresh', 'noticedetail.jsp');
					}
				},{
					text:'修改',
					iconCls:'icon-edit',
					id:'edit',
					handler:function(){
						var row = $('#noticeinfogrid').datagrid('getSelected');
						if(row){
							opttype='modify';
							$('#noticewindow').window('open');
							$('#noticewindow').window('refresh', 'noticedetail.jsp');
						}
						
					}
				},{
					text:'删除',
					iconCls:'icon-cancel',
					id:'del',
					handler:function(){
						var row = $('#noticeinfogrid').datagrid('getSelected');
						if(row){
							$.messager.confirm('提示框', '你确定要删除吗?',function(r){
								if(r){
									$.ajax({
										type: "post",
										url: "<%=request.getContextPath()%>/Manager/delnotice.do",
										data: {id:row.id},
										dataType: "json",
										success: function(jsondata){
											$.messager.alert('返回消息',"删除成功");
											$('#noticeinfogrid').datagrid('reload');
											selectindex = undefined;
											//$('#noticeinfogrid').datagrid('selectRow',selectindex);
										}
									});
								}
							})
						}
					}
				}],
				onClickRow:function(index){
					var row = $('#noticeinfogrid').datagrid('getSelected');
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
						$('#noticeinfogrid').datagrid('selectRow',rowIndex);
						var row = $('#noticeinfogrid').datagrid('getSelected');
						businesscode = row.businesscode;
						businessnumber = row.businessnumber;
						//alert(businesscode+"-----"+businessnumber);
					}
				}
			});
			
			var p = $('#noticeinfogrid').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false,
					pageSize: 15
				});

				setTimeout('query()',100);
		});
	var viewed = $.extend({},$.fn.datagrid.defaults.view,{
				onAfterRender: function(target){
								$('#noticeinfogrid').datagrid('unselectAll');
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
			var fields =$('#noticequeryform').serializeArray();
			$.each( fields, function(i, field){
				params[field.name] = field.value;
			}); 
			//$('#noticeinfogrid').datagrid({
			//	url:'/InitGroundServlet/getlandstoreinfo.do'
			//});
			params.datatype=datatype;
			//$('#noticeinfogrid').datagrid('loadData',{total:0,rows:[]});
			//$('#dg').datagrid({
			//	url:'<%=request.getContextPath()%>/Manager/getorglist.do',
			//	queryParams: params
			//});
			var opts = $('#noticeinfogrid').datagrid('options');
			opts.url = '<%=request.getContextPath()%>/Manager/getnoticelist.do';
			$('#noticeinfogrid').datagrid('load',params); 
			var p = $('#noticeinfogrid').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false,
				pageSize: 15
			});
			$('#noticequerywindow').window('close');
		}
	function formatflag(value,row,index){
		if(value=='01'){
			return '是';
		}
		if(value=='00'){
			return '否';
		}
	}
	function formatorg(value,row,index){
		for(var i=0; i<orgdata.length; i++){
			if (orgdata[i].key == value) return orgdata[i].value;
		}
		return value;
	}
	function formatemp(value,row,index){
		for(var i=0; i<empdata.length; i++){
			if (empdata[i].key == value) return empdata[i].value;
		}
		return value;
	}
	</script>
</head>
<body>
	<form id="groundstorageform" method="post">
		<div title="人员信息" data-options="">
					
						<table id="noticeinfogrid" style="overflow:auto" 
						data-options="iconCls:'icon-edit',singleSelect:true,idField:'itemid'" rownumbers="true"> 
							<thead>
								<tr>
									<th data-options="field:'id',width:100,align:'left',hidden:true,editor:{type:'validatebox'}"></th>
									<th data-options="field:'title',width:100,align:'left',editor:{type:'validatebox'}">标题</th>
									<th data-options="field:'content',width:200,align:'left',editor:{type:'validatebox'}">内容</th>
									<th data-options="field:'opt_orgcode',width:100,align:'center',formatter:formatorg,editor:{type:'validatebox'}">发布机关</th>
									<th data-options="field:'opt_empcode',width:100,align:'center',formatter:formatemp,editor:{type:'validatebox'}">发布人员</th>
									<th data-options="field:'optdate',width:100,align:'center',editor:{type:'validatebox'}">发布时间</th>
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
	<div id="noticequerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'通知查询',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:150px;">
		<div class="easyui-panel" title="" style="width:900px;">
			<form id="noticequeryform" method="post">
				<table id="narjcxx" width="100%"  class="table table-bordered">
					
					<tr>
						<td align="right">标题：</td>
						<td>
							<input id="title" class="easyui-validatebox" type="text" style="width:200px" name="title" />
						</td>
						<td align="right">发布时间：</td>
						<td colspan="3">
							<input id="deratebegin" class="easyui-datebox" style="width:200px" name="deratebegin"
							/>
							至
							<input id="derateend" class="easyui-datebox" style="width:200px" name="derateend"
							/>
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
	
	<div id="noticewindow" class="easyui-window" data-options="closed:true,modal:true,title:'通知信息',collapsible:false,minimizable:false,maximizable:false,closable:true,resizable:false" style="width:420px;height:380px;">
	</div>
	

</body>
</html>
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
    <script src="/js/tiles.js"></script>
    <script src="/js/moduleWindow.js"></script>
	<script src="/menus.js"></script>
	<script src="/js/common.js"></script>
	<script src="/js/jquery.simplemodal.js"></script>
	<script src="/js/overlay.js"></script>
	<script src="/js/jquery.json-2.2.js"></script>
	<script src="/js/json2.js"></script>
	<script src="/locale/easyui-lang-zh_CN.js"></script>
	<script src="/js/jquery.simplemodal.js"></script>
   	<script src="/js/uploadmodal.js"></script> 

	<script>
	var selectindex = undefined;
	var selectid = undefined;
	var editIndex = undefined;
	var locationdata = new Object;
	var approvetype;//批复类型
	var opttype;//操作类型
	var businesscode;
	var businessnumber;
	var datatype;//0：期初数据整理 1：日常业务 2：补录批复
	var belongtocountry = new Array();
	var belongtowns = new Array();
	$(function(){
		var paraString = location.search;     
		var paras = paraString.split("&");   
		datatype = paras[0].substr(paras[0].indexOf("=") + 1); 
		//alert(datatype);
		$.ajax({
			   type: "post",
			   async:false,
			   url: "/InitGroundServlet/getlocationComboxs.do",
			   data: {},
			   dataType: "json",
			   success: function(jsondata){
				   //alert(JSON.stringify(jsondata));
				  locationdata= jsondata;
					for (var i = 0; i < jsondata.length; i++) {
						if(jsondata[i].key.length==9){
							var newdetail={};
							newdetail.key=jsondata[i].key;
							newdetail.value=jsondata[i].value;
							belongtocountry.push(newdetail);
						}
						if(jsondata[i].key.length==12){
							var newdetail={};
							newdetail.key=jsondata[i].key;
							newdetail.value=jsondata[i].value;
							belongtowns.push(newdetail);
						}
					}
			   }
			});
		
			$('#userinfogrid').datagrid({
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
						$('#userwindow').window('open');
						$('#userwindow').window('refresh', 'userdetail.jsp');
					}
				},{
					text:'修改',
					iconCls:'icon-edit',
					handler:function(){
						var row = $('#userinfogrid').datagrid('getSelected');
						if(row && selectindex != undefined){
							opttype='modify';
							$('#userwindow').window('open');
							$('#userwindow').window('refresh', 'userdetail.jsp');
						}
						
					}
				},{
					text:'删除',
					iconCls:'icon-cancel',
					handler:function(){
						var row = $('#userinfogrid').datagrid('getSelected');
						if(row && selectindex != undefined){
							$.messager.confirm('提示框', '你确定要删除吗?',function(r){
								if(r){
									$.ajax({
										type: "post",
										url: "/Userinfo/deleteuser.do",
										data: {user_id:row.user_id},
										dataType: "json",
										success: function(jsondata){
											$.messager.alert('返回消息',"删除成功");
											$('#userinfogrid').datagrid('reload');
											selectindex = undefined;
											//$('#userinfogrid').datagrid('selectRow',selectindex);
										}
									});
								}
							})
						}
					}
				}],
				onClickRow:function(index){
					var row = $('#userinfogrid').datagrid('getSelected');
					selectindex = index;
					selectid = row.landstoreid;
				},
				onClickCell: function (rowIndex, field, value) {
					if(field=="file"){
						$('#userinfogrid').datagrid('selectRow',rowIndex);
						var row = $('#userinfogrid').datagrid('getSelected');
						businesscode = row.businesscode;
						businessnumber = row.businessnumber;
						//alert(businesscode+"-----"+businessnumber);
					}
				}
			});
			
			var p = $('#userinfogrid').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false,
					pageSize: 15
				});

			$.extend($.fn.datagrid.defaults.editors, {
							uploadfile: {
							init: function(container, options)
								{
									var editorContainer = $('<div/>');
									var button = $("<a href='javascript:void(0)'></a>")
										 .linkbutton({plain:true, iconCls:"icon-remove"});
									editorContainer.append(button);
									editorContainer.appendTo(container);
									return button;
								},
							getValue: function(target)
								{
									return $(target).text();
								},
							setValue: function(target, value)
								{
									$(target).text(value);
								},
							resize: function(target, width)  
								 {  
									var span = $(target);  
									if ($.boxModel == true){  
										span.width(width - (span.outerWidth() - span.width()) - 10);  
									} else {  
										span.width(width - 10);  
									}  
								}	
							}
						});
			
		});
	var viewed = $.extend({},$.fn.datagrid.defaults.view,{
				onAfterRender: function(target){
								$('#userinfogrid').datagrid('unselectAll');
							} 
				});
	//结束所有行的编辑
		function endEdits(){
			var rows = $('#uniondetailgrid').datagrid('getRows');
			for ( var i = 0; i < rows.length; i++) {
				$('#uniondetailgrid').datagrid('endEdit', i);
			}
			$('#uniondetailgrid').datagrid('acceptChanges');
		}
		
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
			//$('#userinfogrid').datagrid({
			//	url:'/InitGroundServlet/getlandstoreinfo.do'
			//});
			params.datatype=datatype;
			$('#userinfogrid').datagrid('loadData',{total:0,rows:[]});
			var opts = $('#userinfogrid').datagrid('options');
			opts.url = '/Userinfo/getuserinfo.do';
			$('#userinfogrid').datagrid('load',params); 
			var p = $('#userinfogrid').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false,
				pageSize: 15
			});
			$('#userquerywindow').window('close');
			
		}

		function save(){
			var params = {};
			var fields =$('#groundstorageeditform').serializeArray();
			$.each( fields, function(i, field){
				params[field.name] = field.value;
			}); 
			$.ajax({
			   type: "post",
			   url: "/InitGroundServlet/savelandstoremain.do",
			   data: params,
			   dataType: "json",
			   success: function(jsondata){
				   $('#userinfogrid').datagrid('reload');
				  $('#groundstorageeditwindow').window('close');
				  $.messager.alert('返回消息','保存成功！');
			   }
			});
		}

		function refreshLandstoredetail(){
			var row = $('#userinfogrid').datagrid('getSelected');
			if(row && selectindex != undefined){
				$.ajax({
				   type: "post",
				   url: "/InitGroundServlet/getlandstoresub.do",
				   data: {landstoreid:row.landstoreid},
				   dataType: "json",
				   success: function(jsondata){
					  $('#uniondetailgrid').datagrid('loadData',jsondata);
				   }
				});
			}
		}

	function format(row){
		for(var i=0; i<locationdata.length; i++){
			if (locationdata[i].key == row) return locationdata[i].value;
		}
		return row;
	}
	

	

	</script>
</head>
<body>
	<form id="groundstorageform" method="post">
		<div title="登记信息" data-options="
						tools:[{
							handler:function(){
								$('#userinfogrid').datagrid('reload');
							}
						}]">
					
						<table id="userinfogrid" style="overflow:auto" 
						data-options="iconCls:'icon-edit',singleSelect:true,idField:'itemid'" rownumbers="true"> 
							<thead>
								<tr>
									<th data-options="field:'user_id',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'union_id',width:80,align:'left',editor:{type:'validatebox'}">合作医疗证号</th>
									<th data-options="field:'card_id',width:80,align:'left',editor:{type:'validatebox'}">卡号</th>
									<th data-options="field:'user_name',width:200,align:'left',editor:{type:'validatebox'}">人员名称</th>
									<th data-options="field:'gender',width:100,align:'left',formatter:function(value,row,index){
										if(value=='01'){
											return '男';
										}
										if(value=='02'){
											return '女';
										}
									},
									
									editor:{type:'validatebox'}">性别</th>
									<th data-options="field:'age',width:60,align:'center',editor:{type:'validatebox'}">年龄</th>
									<%--<th data-options="field:'role_id',width:100,align:'left',editor:{type:'validatebox'}">角色</th>
									<th data-options="field:'hospital_id',width:60,align:'center',editor:{type:'validatebox'}">所属单元</th>
									--%><th data-options="field:'valid',width:100,align:'left',formatter:function(value,row,index){
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
	<div id="userquerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'登记信息查询',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:150px;">
		<div class="easyui-panel" title="" style="width:900px;">
			<form id="userqueryform" method="post">
				<table id="narjcxx" width="100%"  class="table table-bordered">
					
					<tr>
						<td align="right">合作医疗证号：</td>
						<td>
							<input id="user_id" class="easyui-validatebox" type="text" style="width:200px" name="user_id" />
						</td>
						<td align="right">卡号：</td>
						<td>
							<input id="card_id" class="easyui-validatebox" type="text" style="width:200px" name="card_id"/>
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
	<!-- <div id="groundstorageeditwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地收储批复',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:300px;">
		<div class="easyui-panel" title="" style="width:900px;">
			<form id="groundstorageeditform" method="post">
				<table id="narjcxx" width="100%" class="table table-bordered">
					<input id="landstoreid"  type="hidden" name="landstoreid"/>	
					<tr>
						<td align="right">批复类型：</td>
						<td>
							<input class="easyui-combobox" name="approvetype" id="approvetype" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">批复名称：</td>
						<td>
							<input class="easyui-validatebox" name="name" id="name"/>					
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
					<tr>
						<td align="right">纳税人计算机编码：</td>
						<td>
							<input class="easyui-validatebox" name="taxpayer" id="taxpayer"/>					
						</td>
						<td align="right">纳税人计算机名称：</td>
						<td>
							<input class="easyui-validatebox" name="taxpayername" id="taxpayername"/>					
						</td>
					</tr>
					<tr>
						<td align="right">批复日期：</td>
						<td colspan="3">
							<input id="approvedates" class="easyui-datebox" name="approvedates"/>
						</td>
					</tr>
					
				</table>
			</form>
			<div style="text-align:center;padding:5px;">
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="quereyreg()">税务登记查询</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save()">保存</a>
			</div>
		</div>
	</div> -->
	<!-- <div id="groundstoragedetailwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地收储批复明细',collapsible:false,minimizable:false,maximizable:false,closable:false" style="width:800px;height:400px;">
	<table id="uniondetailgrid"></table>
	</div> -->
	<div id="reginfowindow" class="easyui-window" data-options="closed:true,modal:true,title:'纳税人登记信息',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:620px;height:470px;">
	</div>
	<div id="userwindow" class="easyui-window" data-options="closed:true,modal:true,title:'新农合卡登记信息',collapsible:false,minimizable:false,maximizable:false,closable:true,resizable:false" style="width:1000px;height:500px;">
	</div>
	<!-- <div id="groundstorageaddwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地收储批复新增',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:200px;">
	</div> -->
	<!-- <div id="addtdxxwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地信息',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:500px;">
	</div> -->

</body>
</html>
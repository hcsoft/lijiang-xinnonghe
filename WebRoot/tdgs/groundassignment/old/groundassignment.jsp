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

	<script>
	var businesscode;
	var locationdata = new Object;//所属乡镇缓存
	var businesstype = undefined;//业务操作类型
	var locationtype = undefined;//坐落地类型
	var belongtocountrycode = undefined;//所属乡镇
	var detailaddress = undefined;//详细地址
	var maxgroundarea = 0.00;//可使用面积
	var taxpayerid;
	var taxpayername;
	var buttonbusinesstype;//url传入的参数类型，用于控制按钮可见,0出让，1未批先占，2转让，3出租，9全部
	var combobusinesstype;//按钮触发的业务类型，用于页面跳转和业务操作类型下拉初始化
	var landstoresubid;
	var levydatetypedata = new Object;//征期类型
	$(function(){
		//取得url参数
		var paraString = location.search;
		var paras = paraString.split("&");   
		businesscode = paras[0].substr(paras[0].indexOf("=") + 1); 
		//$.messager.alert('返回消息',buttonbusinesstype);
		if(businesscode=='1'){//未批先占
			buttonbusinesstype = '1';
			combobusinesstype ='1';
			$('#businesscode').val("13");
			$('#groundassignmentgrid').datagrid({  
				columns:[[  
					{checkbox:true},  
					{field:'landgainid',width:180,align:'center',hidden:true,editor:{type:'text'}},  
					{field:'estateid',width:180,align:'center',hidden:true,editor:{type:'text'}},  
					{field:'taxpayerid',width:100,align:'center',editor:{type:'validatebox'},title:'占用方计算机编码'},
					{field:'taxpayername',width:100,align:'center',editor:{type:'validatebox'},title:'占用方名称'}, 
					{field:'freetax',width:80,align:'center',editor:{type:'validatebox'},title:'是否免税单位'}, 
					{field:'gaindates',width:100,align:'center',editor:{type:'validatebox'},title:'实际交付时间'}, 
					{field:'contractnumber',width:100,align:'center',editor:{type:'validatebox'},title:'协议编号'}, 
					{field:'estateserial',width:100,align:'center',editor:{type:'validatebox'},title:'地块编号'}, 
					{field:'purpose',width:100,align:'center',editor:{type:'validatebox'},title:'土地用途'}, 
					{field:'property',width:100,align:'center',editor:{type:'validatebox'},title:'土地性质'}, 
					{field:'areatotal',width:100,align:'center',editor:{type:'validatebox'},title:'占用面积'}, 
					{field:'landmoney',width:100,align:'center',editor:{type:'validatebox'},title:'获得土地总价'}, 
				]]  
			});
		}else{
			buttonbusinesstype = '0';
			combobusinesstype ='0';
		}
		$.ajax({
			   type: "post",
				async:false,
			   url: "/InitGroundServlet/getlocationComboxs.do",
			   data: {codetablename:'COD_BELONGTOCOUNTRYCODE'},
			   dataType: "json",
			   success: function(jsondata){
				   //$.messager.alert('返回消息',JSON.stringify(jsondata));
				  locationdata= jsondata;
			   }
			});
		var regex = new RegExp("\"","g");  
		$.ajax({
			   type: "get",
			   url: "/soption/taxOrgOptionInit.do",
			   data: {"moduleAuth":"15","emptype":"30"},
			   dataType: "json",
			   success: function(jsondata){
				   $('#querytaxorgsupcode').combobox({
						data : jsondata.taxSupOrgOptionJsonArray,
                        valueField:'key',
                        textField:'keyvalue',
						onSelect:function(n,o){  	
							//$.messager.alert('返回消息',n.key);
							$.ajax({
								   type: "get",
								   url: "/soption/taxOrgOptionBySup.do",
								   data: {"taxSuperOrgCode":n.key},
								   dataType: "json",
								   success: function(jsondata){
										//$.messager.alert('返回消息',JSON.stringify(jsondata));
									   $('#querytaxorgcode').combobox({
											data : jsondata.taxOrgOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});
									   $('#querytaxdeptcode').combobox({
											data : jsondata.taxDeptOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});		
									   $('#querytaxmanagercode').combobox({
											data : jsondata.taxEmpOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});											
										//$('#querytaxdeptcode').combobox("clear");
										//$('#taxempcode').combobox("clear");

										//$('#querytaxdeptcode').combobox({}).combobox('clear');
								   }
							});
						} 
					});
					if(jsondata.taxSupOrgOptionJsonArray.length == 1){
						//$.messager.alert('返回消息',JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
						$('#querytaxorgsupcode').combobox("setValue",JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key).replace(regex, ""));
						$('#querytaxorgsupcode').combobox("setText",JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].keyvalue).replace(regex, ""));
					}


				   $('#querytaxorgcode').combobox({
						data : jsondata.taxOrgOptionJsonArray,
                        valueField:'key',
                        textField:'keyvalue',
						onSelect:function(n,o){  	
							$.ajax({
								   type: "get",
								   url: "/soption/taxDeptOptionByOrg.do",
								   data: {"taxOrgCode":n.key},
								   dataType: "json",
								   success: function(jsondata){
									   $('#querytaxdeptcode').combobox({
											data : jsondata.taxDeptOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});		
									   $('#querytaxmanagercode').combobox({
											data : jsondata.taxEmpOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});											
										//$('#querytaxdeptcode').combobox("clear");
										//$('#taxempcode').combobox("clear");

										//$('#querytaxdeptcode').combobox({}).combobox('clear');
								   }
							});
						} 
					});
					if(jsondata.taxOrgOptionJsonArray.length == 1){
						//$.messager.alert('返回消息',JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
						$('#querytaxorgcode').combobox("setValue",JSON.stringify(jsondata.taxOrgOptionJsonArray[0].key).replace(regex, ""));
						$('#querytaxorgcode').combobox("setText",JSON.stringify(jsondata.taxOrgOptionJsonArray[0].keyvalue).replace(regex, ""));
					}

				   $('#querytaxdeptcode').combobox({
						data : jsondata.taxDeptOptionJsonArray,
                        valueField:'key',
                        textField:'keyvalue',
						onSelect:function(n,o){  	
							$.ajax({
								   type: "get",
								   url: "/soption/getTaxEmpByOrgCode.do",
								   data: {"taxDeptCode":n.key,"emptype":"30"},
								   dataType: "json",
								   success: function(jsondata){	
									   $('#querytaxmanagercode').combobox({
											data : jsondata.taxEmpOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});											
										//$('#querytaxdeptcode').combobox("clear");
										//$('#taxempcode').combobox("clear");

										//$('#querytaxdeptcode').combobox({}).combobox('clear');
								   }
							});
						} 
					});
					if(jsondata.taxDeptOptionJsonArray.length == 1){
						//$.messager.alert('返回消息',JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
						$('#querytaxdeptcode').combobox("setValue",JSON.stringify(jsondata.taxDeptOptionJsonArray[0].key).replace(regex, ""));
						$('#querytaxdeptcode').combobox("setText",JSON.stringify(jsondata.taxDeptOptionJsonArray[0].keyvalue).replace(regex, ""));
					}

				   $('#querytaxmanagercode').combobox({
						data : jsondata.taxEmpOptionJsonArray,
                        valueField:'key',
                        textField:'keyvalue'
					});
	           }
	   });
			$('#groundassignmentgrid').datagrid({
				fitColumns:'true',
				maximized:'true',
				pagination:true,
				idField:'landgainid',
				//view:viewed,
				toolbar:[{
					text:'查询',
					iconCls:'icon-search',
					handler:function(){
						$('#groundassignmentquerywindow').window('open');
					}
				},{
					text:'新增',
					iconCls:'icon-add',
					handler:function(){
						$('#groundinfowindow').window('open');
						if(businesscode=='1'){
							$('#groundinfowindow').window('refresh', 'reginfo.jsp');
						}else{
							$('#groundinfowindow').window('refresh', 'groundtransfer.jsp');
						}
					}
				},{
					text:'提交',
					iconCls:'icon-submit',
					handler:function(){
						var rows = $('#groundassignmentgrid').datagrid('getSelections');
						var landgainids ='';
						for(var i =0;i<rows.length;i++){
							landgainids = landgainids + "'"+rows[i].landgainid+"',";
							var index = $('#groundassignmentgrid').datagrid('getRowIndex',rows[i])+1;
							if(rows[i].isuse=='1'){
								$.messager.alert('提示框',"序号为"+index+"的记录已发生后续业务，不能提交！");
								return;
							}
						}
						landgainids = landgainids.substring(0,landgainids.length-1);
						if(rows.length>0){
							$.messager.confirm('提示框', '你确定要提交吗?',function(r){
								if(r){
									$.ajax({
										type: "post",
										url: "/GroundAssignmentServlet/changegainstate.do",
										data: {landgainids:landgainids,opttype:1,businesscode:businesscode},
										dataType: "json",
										success: function(jsondata){
											$.messager.alert('返回消息',"提交成功");
											$('#groundassignmentgrid').datagrid('reload');
											$('#groundassignmentgrid').datagrid('unselectAll');
										}
									});
								}
							})
						}else{
							$.messager.alert('提示框',"请选择需要提交的数据！");
						}
					}
				},{
					text:'撤销提交',
					iconCls:'icon-unsubmit',
					handler:function(){
						var rows = $('#groundassignmentgrid').datagrid('getSelections');
						var landgainids ='';
						for(var i =0;i<rows.length;i++){
							landgainids = landgainids + "'"+rows[i].landgainid+"',";
							var index = $('#groundassignmentgrid').datagrid('getRowIndex',rows[i])+1;
							if(rows[i].isuse=='1'){
								$.messager.alert('提示框',"序号为"+index+"的记录已发生后续业务，不能撤销提交！");
								return;
							}
						}
						landgainids = landgainids.substring(0,landgainids.length-1);
						if(rows.length>0){
							$.messager.confirm('提示框', '你确定要撤销提交吗?',function(r){
								if(r){
									$.ajax({
										type: "post",
										url: "/GroundAssignmentServlet/changegainstate.do",
										data: {landgainids:landgainids,opttype:0,businesscode:businesscode},
										dataType: "json",
										success: function(jsondata){
											$.messager.alert('返回消息',"撤销提交成功");
											$('#groundassignmentgrid').datagrid('reload');
											$('#groundassignmentgrid').datagrid('unselectAll');
										}
									});
								}
							})
						}else{
							$.messager.alert('提示框',"请选择需要提交的数据！");
						}
					}
				},{
					text:'作废',
					iconCls:'icon-cancel',
					handler:function(){
						var rows = $('#groundassignmentgrid').datagrid('getSelections');
						var landgainids ='';
						for(var i =0;i<rows.length;i++){
							landgainids = landgainids + "'"+rows[i].landgainid+"',";
							var index = $('#groundassignmentgrid').datagrid('getRowIndex',rows[i])+1;
							if(rows[i].state=='1'){
								$.messager.alert('提示框',"序号为"+index+"的记录状态为已提交，不能作废！");
								return;
							}
							if(rows[i].isuse=='1'){
								$.messager.alert('提示框',"序号为"+index+"的记录已发生后续业务，不能作废！");
								return;
							}
						}
						landgainids = landgainids.substring(0,landgainids.length-1);
						if(rows.length>0){
							$.messager.confirm('提示框', '你确定要作废吗?',function(r){
								if(r){
									$.ajax({
										type: "post",
										url: "/GroundAssignmentServlet/changegainstate.do",
										data: {landgainids:landgainids,opttype:99,businesscode:businesscode},
										dataType: "json",
										success: function(jsondata){
											$.messager.alert('返回消息',"作废成功");
											$('#groundassignmentgrid').datagrid('reload');
											$('#groundassignmentgrid').datagrid('unselectAll');
										}
									});
								}
							})
						}else{
							$.messager.alert('提示框',"请选择需要作废的数据！");
						}
					}
				}],
				onCheck:function(rowIndex,rowData){
					selectid = rowData.landgainid;
				},
				onClickCell: function (rowIndex, field, value) {
					if(field=="a"){
						$('#groundassignmentgrid').datagrid('selectRow',rowIndex);
						var row = $('#groundassignmentgrid').datagrid('getSelected');
						if(row.state=='1'){
							$.messager.alert('提示框',"该记录状态为已提交，不能修改！");
							return;
						}
						if(row.isuse=='1'){
							$.messager.alert('提示框',"该记录已发生后续业务，不能修改！");
							return;
						}
						if(row.isuse=='0' && row.isuse =='0'){
							$('#groundgaineditwindow').window('open');//打开修改窗口
						}
					}
				}
			});
			
			var p = $('#groundassignmentgrid').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
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
								if(selectid != undefined){
									$('#groundassignmentgrid').datagrid('selectRecord',selectid);
									var row = $('#groundassignmentgrid').datagrid('getSelected');
									var index = $('#groundassignmentgrid').datagrid('getRowIndex',row);
									var lastindex = $('#groundassignmentgrid').datagrid('getData')['total']-1;
									if(index > lastindex){
										$('#groundassignmentgrid').datagrid('unselectRow',index);
									}
								}else{
									selectindex = undefined;
								}
							} 
				});


		function assiigmentquery(){
			$('#groundassignmentgrid').datagrid('unselectAll');
			var params = {};
			var fields =$('#groundassignmentqueryform').serializeArray();
			$.each( fields, function(i, field){
				params[field.name] = field.value;
			}); 
			params.businesscode = '0';
			$('#groundassignmentgrid').datagrid('loadData',{total:0,rows:[]});
			var opts = $('#groundassignmentgrid').datagrid('options');
			opts.url = '/GroundAssignmentServlet/getgroundgaininfo.do';
			$('#groundassignmentgrid').datagrid('load',params); 
			var p = $('#groundassignmentgrid').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false,
				pageSize: 15
			});
			$('#groundassignmentgrid').datagrid('unselectAll');
			$('#groundassignmentquerywindow').window('close');
			
		}



	function format(row){
		for(var i=0; i<locationdata.length; i++){
			if (locationdata[i].key == row) return locationdata[i].value;
		}
		return row;
	}

	function stateformat(value){
		if(value == '1'){
			return '已提交';
		}else{
			return '未提交';
		}
	}
	function uploadbutton(row){
		return '<a href="#" class="easyui-linkbutton" id=\'uploadbtn\' data-options=\'iconCls:\'icon-save\'\' onclick="uploadfile()">附件管理</a>';
	}
	//function quereyreg(){
	//	$('#reginfowindow').window('open');//打开新录入窗口
	//	$('#reginfowindow').window('refresh', 'reginfo.jsp');
	//}
	function uploadfile(){
		uploadModal.init("uploadbtn","02","111");
	}

	function optformat(){
		return '<a href="#" class="easyui-linkbutton" id=\'aaa\' value =\'0\' data-options="iconCls:\'icon-save\'" >修改</a>';
	}
	</script>
</head>
<body>
	<form id="groundstorageform" method="post">
		<div title="批复信息" data-options="
						tools:[{
							handler:function(){
								$('#groundassignmentgrid').datagrid('reload');
							}
						}]">
					
						<table id="groundassignmentgrid" style="overflow:auto" 
						data-options="iconCls:'icon-edit',singleSelect:false" rownumbers="true"> 
							<thead>
								<tr>
									<th data-options="checkbox:true"></th>
									<th data-options="field:'landgainid',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'estateid',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<!-- <th data-options="checkbox:true"></th> -->
									<th data-options="field:'a',width:60,align:'center',formatter:optformat">操作</th>
									<th data-options="field:'taxpayerid',width:100,align:'center',editor:{type:'validatebox'}">受让方计算机编码</th>
									<th data-options="field:'taxpayername',width:200,align:'center',editor:{type:'validatebox'}">受让方名称</th>
									<th data-options="field:'freetax',width:80,align:'center',editor:{type:'validatebox'}">是否免税单位</th>
									<th data-options="field:'gaindates',width:100,align:'center',editor:{type:'validatebox'}">实际交付时间</th>
									<th data-options="field:'contractnumber',width:60,align:'center',editor:{type:'validatebox'}">协议编号</th>
									<th data-options="field:'estateserial',width:100,align:'center',editor:{type:'validatebox'}">地块编号</th>
									<th data-options="field:'purpose',width:100,align:'center',editor:{type:'validatebox'}">土地用途</th>
									<th data-options="field:'property',width:100,align:'center',editor:{type:'validatebox'}">土地性质</th>
									<th data-options="field:'areatotal',width:100,align:'center',editor:{type:'validatebox'}">出让面积</th>
									<th data-options="field:'landmoney',width:100,align:'center',editor:{type:'validatebox'}">出让总价</th>
									<th data-options="field:'state',width:100,align:'center',formatter:stateformat,editor:{type:'validatebox'}">状态</th>
									<!-- <th data-options="field:'a',width:100,align:'center',formatter:uploadbutton">附件管理</th> -->
									<th data-options="field:'businesscode',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'isuse',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
								</tr>
							</thead>
						</table>
					
			</div>
	</form>
	<div id="groundassignmentquerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地出让查询',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:300px;">
		<div class="easyui-panel" title="" style="width:900px;">
			<form id="groundassignmentqueryform" method="post">
				<table id="narjcxx" width="100%"  class="table table-bordered">
					<input type="hidden" name="businesscode" id="businesscode"/>
					<tr>
						<td align="right">州市地税机关：</td>
						<td>
							<input class="easyui-combobox" name="querytaxorgsupcode" id="querytaxorgsupcode" style="width:200px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">县区地税机关：</td>
						<td>
							<input class="easyui-combobox" name="querytaxorgcode" id="querytaxorgcode" style="width:200px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
					</tr>
					<tr>
						<td align="right">主管地税部门：</td>
						<td>
							<input class="easyui-combobox" name="querytaxdeptcode" id="querytaxdeptcode" style="width:200px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">税收管理员：</td>
						<td>
							<input class="easyui-combobox" name="querytaxmanagercode" id="querytaxmanagercode" style="width:200px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
					</tr>
					<tr>
						<td align="right">计算机编码：</td>
						<td>
							<input id="querytaxpayerid" class="easyui-validatebox" type="text" style="width:200px" name="querytaxpayerid"/>
						</td>
						<td align="right">纳税人名称：</td>
						<td>
							<input id="querytaxpayername" class="easyui-validatebox" type="text" style="width:200px" name="querytaxpayername"/>
						</td>
					</tr>
					<tr>
						<td align="right">状态：</td>
						<td>
							<select id="state" class="easyui-combobox" name="state" editable="false" style="width:200px">
								<option value="0">未提交</option>
								<option value="1">已提交</option>
							</select>
						</td>
						<td align="right">实际交付时间：</td>
						<td>
							<input id="gaindatesbegin" class="easyui-datebox" name="gaindatesbegin"/>
						至
							<input id="gaindatesend" class="easyui-datebox"  name="gaindatesend"/>
						</td>
					</tr>
				</table>
			</form>
			<div style="text-align:center;padding:5px;">  
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="assiigmentquery()">查询</a>
					<!-- <a href="#" class="easyui-linkbutton" id="aaa" data-options="iconCls:'icon-search'" >查询</a> -->
			</div>
		</div>
	</div>
	<!-- <div id="groundstorageeditwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地收储批复',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:300px;">
		<div class="easyui-panel" title="" style="width:900px;">
			<form id="groundstorageeditform" method="post">
				<table id="narjcxx" width="100%" class="table table-bordered">
					<input id="landgainid"  type="hidden" name="landgainid"/>	
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
	<table id="groundstoragedetailgrid"></table>
	</div> -->
	<!-- <div id="reginfowindow" class="easyui-window" data-options="closed:true,modal:true,title:'纳税人登记信息',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:620px;height:470px;">
	</div> -->
	<div id="groundinfowindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地业务',collapsible:false,minimizable:false,maximizable:false,closable:true,resizable:false" style="width:960px;height:500px;">
	</div>
	<div id="groundgaineditwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地出让划拨修改窗口',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:200px;">
	</div>
	<!-- <div id="addtdxxwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地信息',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:500px;">
	</div> -->

</body>
</html>
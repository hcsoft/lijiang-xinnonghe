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
	$(function(){
		//取得url参数
		var paraString = location.search;
		var paras = paraString.split("&");   
		businesscode = paras[0].substr(paras[0].indexOf("=") + 1); 
		//alert(buttonbusinesstype);
		if(businesscode=='1'){//未批先占
			buttonbusinesstype = '1';
			combobusinesstype ='1';
			$('#businesscode').val("13");
			$('#groundmakeovergrid').datagrid({  
				columns:[[  
					{checkbox:true},  
					{field:'ownerid',width:180,align:'center',hidden:true,editor:{type:'text'}},  
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
				   //alert(JSON.stringify(jsondata));
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
							//alert(n.key);
							$.ajax({
								   type: "get",
								   url: "/soption/taxOrgOptionBySup.do",
								   data: {"taxSuperOrgCode":n.key},
								   dataType: "json",
								   success: function(jsondata){
										//alert(JSON.stringify(jsondata));
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
						//alert(JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
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
						//alert(JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
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
						//alert(JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
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
			$('#groundmakeovergrid').datagrid({
				fitColumns:'true',
				maximized:'true',
				pagination:true,
				idField:'ownerid',
				//view:viewed,
				toolbar:[{
					text:'查询',
					iconCls:'icon-search',
					handler:function(){
						$('#groundmakeoverquerywindow').window('open');
					}
				},{
					text:'新增',
					iconCls:'icon-edit',
					handler:function(){
						$('#groundinfowindow').window('open');
						if(businesscode=='1'){
							$('#groundinfowindow').window('refresh', 'reginfo.jsp');
						}else{
							$('#groundinfowindow').window('refresh', 'groundtransfer.jsp');
						}
					}
				},{
					text:'撤销',
					iconCls:'icon-edit',
					handler:function(){
						var rows = $('#groundmakeovergrid').datagrid('getSelections');
						var ownerids ='';
						for(var i =0;i<rows.length;i++){
							ownerids = ownerids + "'"+rows[i].ownerid+"',";
							var index = $('#groundmakeovergrid').datagrid('getRowIndex',rows[i])+1;
							if(rows[i].state=='5'){
								alert("序号为"+index+"的记录状态为已审核，不能撤销！");
								return;
							}
							if(rows[i].state=='90'){
								alert("序号为"+index+"的记录已发生后续业务，不能撤销！");
								return;
							}
						}
						ownerids = ownerids.substring(0,ownerids.length-1);
						if(rows.length>0){
							$.messager.confirm('提示框', '你确定要撤销吗?',function(r){
								if(r){
									$.ajax({
										type: "post",
										url: "/GroundMakeoverServlet/changeownershipstate.do",
										data: {ownerids:ownerids,opttype:1,businesscode:businesscode},
										dataType: "json",
										success: function(jsondata){
											$.messager.alert('返回消息',"撤销成功");
											$('#groundmakeovergrid').datagrid('reload');
											$('#groundmakeovergrid').datagrid('unselectAll');
										}
									});
								}
							})
						}else{
							alert("请选择需要撤销的数据！");
						}
					}
				},{
					text:'审核',
					iconCls:'icon-cancel',
					handler:function(){
						var rows = $('#groundmakeovergrid').datagrid('getSelections');
						var ownerids ='';
						//alert(rows.size);
						for(var i =0;i<rows.length;i++){
							ownerids = ownerids + "'"+rows[i].ownerid+"',";
							var index = $('#groundmakeovergrid').datagrid('getRowIndex',rows[i])+1;
							if(rows[i].state=='5'){
								alert("序号为"+index+"的记录状态为已审核，不能审核！");
								return;
							}
						}
						ownerids = ownerids.substring(0,ownerids.length-1);
						if(rows.length>0){
							$.messager.confirm('提示框', '你确定要审核吗?',function(r){
								if(r){
									$.ajax({
										type: "post",
										url: "/GroundMakeoverServlet/changeownershipstate.do",
										data: {ownerids:ownerids,opttype:2,businesscode:businesscode},
										dataType: "json",
										success: function(jsondata){
											$.messager.alert('返回消息',"审核成功");
											$('#groundmakeovergrid').datagrid('reload');
											$('#groundmakeovergrid').datagrid('unselectAll');
										}
									});
								}
							})
						}else{
							alert("请选择需要审核的数据！");
						}
					}
				},{
					text:'取消审核',
					iconCls:'icon-cancel',
					handler:function(){
						var rows = $('#groundmakeovergrid').datagrid('getSelections');
						var ownerids ='';
						for(var i =0;i<rows.length;i++){
							ownerids = ownerids + "'"+rows[i].ownerid+"',";
							var index = $('#groundmakeovergrid').datagrid('getRowIndex',rows[i])+1;
							//alert(rows[i].state+"--"+index);
							if(rows[i].state=='0' || rows[i].state=='1'){
								alert("序号为"+index+"的记录状态为未审核，不能取消审核！");
								return;
							}
							if(rows[i].state=='90'){
								alert("序号为"+index+"的记录已发生后续业务，不能取消审核！");
								return;
							}
						}
						ownerids = ownerids.substring(0,ownerids.length-1);
						if(rows.length>0){
							$.messager.confirm('提示框', '你确定要取消审核吗?',function(r){
								if(r){
									$.ajax({
										type: "post",
										url: "/GroundMakeoverServlet/changeownershipstate.do",
										data: {ownerids:ownerids,opttype:3,businesscode:businesscode},
										dataType: "json",
										success: function(jsondata){
											$.messager.alert('返回消息',"取消审核成功");
											$('#groundmakeovergrid').datagrid('reload');
											$('#groundmakeovergrid').datagrid('unselectAll');
										}
									});
								}
							})
						}else{
							alert("请选择需要取消审核的数据！");
						}
					}
				}],
				onCheck:function(rowIndex,rowData){
					selectid = rowData.ownerid;
				}
			});
			
			var p = $('#groundmakeovergrid').datagrid('getPager');  
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
									$('#groundmakeovergrid').datagrid('selectRecord',selectid);
									var row = $('#groundmakeovergrid').datagrid('getSelected');
									var index = $('#groundmakeovergrid').datagrid('getRowIndex',row);
									var lastindex = $('#groundmakeovergrid').datagrid('getData')['total']-1;
									if(index > lastindex){
										$('#groundmakeovergrid').datagrid('unselectRow',index);
									}
								}else{
									selectindex = undefined;
								}
							} 
				});


		function query(){
			var params = {};
			var fields =$('#groundmakeoverqueryform').serializeArray();
			$.each( fields, function(i, field){
				params[field.name] = field.value;
			}); 
			params.businesscode = businesscode;
			$('#groundmakeovergrid').datagrid('loadData',{total:0,rows:[]});
			var opts = $('#groundmakeovergrid').datagrid('options');
			opts.url = '/GroundMakeoverServlet/getgroundownershipinfo.do';
			$('#groundmakeovergrid').datagrid('load',params); 
			var p = $('#groundmakeovergrid').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false,
				pageSize: 15
			});
			$('#groundmakeovergrid').datagrid('unselectAll');
			$('#groundmakeoverquerywindow').window('close');
			
		}



	function format(row){
		for(var i=0; i<locationdata.length; i++){
			if (locationdata[i].key == row) return locationdata[i].value;
		}
		return row;
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
	</script>
</head>
<body>
	<form id="groundstorageform" method="post">
		<div title="批复信息" data-options="
						tools:[{
							handler:function(){
								$('#groundmakeovergrid').datagrid('reload');
							}
						}]">
					
						<table id="groundmakeovergrid" style="overflow:auto" 
						data-options="iconCls:'icon-edit',singleSelect:false" rownumbers="true"> 
							<thead>
								<tr>
									<th data-options="checkbox:true"></th>
									<th data-options="field:'ownerid',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'estateid',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<!-- <th data-options="checkbox:true"></th> -->
									<th data-options="field:'lessorid',width:100,align:'center',editor:{type:'validatebox'}">转出方计算机编码</th>
									<th data-options="field:'lessortaxpayername',width:200,align:'center',editor:{type:'validatebox'}">转出方名称</th>
									<th data-options="field:'lesseesid',width:100,align:'center',editor:{type:'validatebox'}">转入方计算机编码</th>
									<th data-options="field:'lesseestaxpayername',width:200,align:'center',editor:{type:'validatebox'}">转入方名称</th>
									<th data-options="field:'freetax',width:80,align:'center',editor:{type:'validatebox'}">转入方是否免税单位</th>
									<th data-options="field:'transbegindates',width:100,align:'center',editor:{type:'validatebox'}">转出时间</th>
									<th data-options="field:'landarea',width:100,align:'center',editor:{type:'validatebox'}">土地面积</th>
									<th data-options="field:'transmoney',width:100,align:'center',editor:{type:'validatebox'}">转出总价</th>
									<!-- <th data-options="field:'a',width:100,align:'center',formatter:uploadbutton">附件管理</th> -->
									<th data-options="field:'businesscode',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
								</tr>
							</thead>
						</table>
					
			</div>
	</form>
	<div id="groundmakeoverquerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地收储批复查询',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:300px;">
		<div class="easyui-panel" title="" style="width:900px;">
			<form id="groundmakeoverqueryform" method="post">
				<table id="narjcxx" width="100%"  class="table table-bordered">
					<input type="hidden" name="businesscode" id="businesscode"/>
					<tr>
						<td align="right">州市地税机关：</td>
						<td>
							<input class="easyui-combobox" name="querytaxorgsupcode" id="querytaxorgsupcode" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">县区地税机关：</td>
						<td>
							<input class="easyui-combobox" name="querytaxorgcode" id="querytaxorgcode" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
					</tr>
					<tr>
						<td align="right">主管地税部门：</td>
						<td>
							<input class="easyui-combobox" name="querytaxdeptcode" id="querytaxdeptcode" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<!-- <td align="right">税收管理员：</td>
						<td>
							<input class="easyui-combobox" name="querytaxmanagercode" id="querytaxmanagercode" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td> -->
					</tr>
					<tr>
						<td align="right">计算机编码：</td>
						<td>
							<input id="querytaxpayerid" class="easyui-validatebox" type="text" name="querytaxpayerid"/>
						</td>
						<td align="right">纳税人名称：</td>
						<td>
							<input id="querytaxpayername" class="easyui-validatebox" type="text" name="querytaxpayername"/>
						</td>
					</tr>
					<tr>
						<td align="right">状态：</td>
						<td>
							<select id="state" class="easyui-combobox" name="state" editable="false">
								<option value="">全部</option>
								<!-- <option value="0">新增</option> -->
								<option value="1">提交</option>
								<option value="5">已审核</option>
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
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="query()">查询</a>
					<!-- <a href="#" class="easyui-linkbutton" id="aaa" data-options="iconCls:'icon-search'" >查询</a> -->
			</div>
		</div>
	</div>
	<!-- <div id="groundstorageeditwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地收储批复',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:300px;">
		<div class="easyui-panel" title="" style="width:900px;">
			<form id="groundstorageeditform" method="post">
				<table id="narjcxx" width="100%" class="table table-bordered">
					<input id="ownerid"  type="hidden" name="ownerid"/>	
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
	<!-- <div id="groundstorageaddwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地收储批复新增',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:200px;">
	</div> -->
	<!-- <div id="addtdxxwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地信息',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:500px;">
	</div> -->

</body>
</html>
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
	var selectid;
	var groundusedata = new Object;
	$(function(){
		var paraString = location.search;     
		var paras = paraString.split("&");   
		datatype = paras[0].substr(paras[0].indexOf("=") + 1); 
		var regex = new RegExp("\"","g"); 
		$.ajax({
			   type: "post",
			   url: "/ComboxService/getComboxs.do",
			   data: {codetablename:'COD_GROUNDUSECODE'},
			   dataType: "json",
			   success: function(jsondata){
				  groundusedata= jsondata;
			   }
		});
		$.ajax({
			   type: "get",
			   url: "/soption/taxOrgOptionInit.do",
			   data: {"moduleAuth":"15","emptype":"30"},
			   dataType: "json",
			   success: function(jsondata){
				   $('#taxorgsupcode').combobox({
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
									   $('#taxorgcode').combobox({
											data : jsondata.taxOrgOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});
									   $('#taxdeptcode').combobox({
											data : jsondata.taxDeptOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});		
									   $('#taxmanagercode').combobox({
											data : jsondata.taxEmpOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});											
										//$('#taxdeptcode').combobox("clear");
										//$('#taxempcode').combobox("clear");

										//$('#taxdeptcode').combobox({}).combobox('clear');
								   }
							});
						} 
					});
					if(jsondata.taxSupOrgOptionJsonArray.length == 1){
						//alert(JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
						$('#taxorgsupcode').combobox("setValue",JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key).replace(regex, ""));
						$('#taxorgsupcode').combobox("setText",JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].keyvalue).replace(regex, ""));
					}


				   $('#taxorgcode').combobox({
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
									   $('#taxdeptcode').combobox({
											data : jsondata.taxDeptOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});		
									   $('#taxmanagercode').combobox({
											data : jsondata.taxEmpOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});											
										//$('#taxdeptcode').combobox("clear");
										//$('#taxempcode').combobox("clear");

										//$('#taxdeptcode').combobox({}).combobox('clear');
								   }
							});
						} 
					});
					if(jsondata.taxOrgOptionJsonArray.length == 1){
						//alert(JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
						$('#taxorgcode').combobox("setValue",JSON.stringify(jsondata.taxOrgOptionJsonArray[0].key).replace(regex, ""));
						$('#taxorgcode').combobox("setText",JSON.stringify(jsondata.taxOrgOptionJsonArray[0].keyvalue).replace(regex, ""));
					}

				   $('#taxdeptcode').combobox({
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
									   $('#taxmanagercode').combobox({
											data : jsondata.taxEmpOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});											
										//$('#taxdeptcode').combobox("clear");
										//$('#taxempcode').combobox("clear");

										//$('#taxdeptcode').combobox({}).combobox('clear');
								   }
							});
						} 
					});
					if(jsondata.taxDeptOptionJsonArray.length == 1){
						//alert(JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
						$('#taxdeptcode').combobox("setValue",JSON.stringify(jsondata.taxDeptOptionJsonArray[0].key).replace(regex, ""));
						$('#taxdeptcode').combobox("setText",JSON.stringify(jsondata.taxDeptOptionJsonArray[0].keyvalue).replace(regex, ""));
					}



				   $('#taxmanagercode').combobox({
						data : jsondata.taxEmpOptionJsonArray,
                        valueField:'key',
                        textField:'keyvalue'
					});
	           }
	   });
			$('#estategrid').datagrid({
				fitColumns:'true',
				maximized:'true',
				pagination:true,
				idField:'estateid',
				view:viewed,
				toolbar:[{
					text:'查询',
					iconCls:'icon-search',
					handler:function(){
						$('#groundstoragequerywindow').window('open');
					}
				},{
					text:'新增',
					iconCls:'icon-add',
					handler:function(){
						opttype='add';
						$('#sharegrounddefinewindow').window('open');
						//$('#sharegrounddefinewindow').window('refresh', 'sharegrounddefineselect.jsp');
					}
				},{
					text:'查看共用宗地信息',
					iconCls:'icon-edit',
					handler:function(){
						var row = $('#estategrid').datagrid('getSelected');
						if(row){
						$.ajax({
						   type: "post",
							async:false,
						   url: "/ShareGroundDefineServlet/getbaseestateinfo.do",
						   data: {shareestateid:row.shareestateid,page:1},
						   dataType: "json",
						   success: function(jsondata){
							   $('#sharegrounddefinegrid').datagrid('loadData',jsondata);
						   }
						});
						$('#sharegrounddefinewindow').window('open');
						}
						
					}
				},{
					text:'删除',
					iconCls:'icon-cancel',
					handler:function(){
						var row = $('#estategrid').datagrid('getSelected');
						if(row && selectindex != undefined){
							$.messager.confirm('提示框', '你确定要删除吗?',function(r){
								if(r){
									$.ajax({
										type: "post",
										url: "/InitGroundServlet/deletelandstoreinfo.do",
										data: {landstoreid:row.landstoreid},
										dataType: "json",
										success: function(jsondata){
											$.messager.alert('返回消息',"删除成功");
											$('#estategrid').datagrid('reload');
											selectindex = undefined;
											//$('#estategrid').datagrid('selectRow',selectindex);
										}
									});
								}
							})
						}
					}
				}],
				onClickRow:function(index){
					var row = $('#estategrid').datagrid('getSelected');
					selectindex = index;
					selectid = row.estateid;
				},
				onClickCell: function (rowIndex, field, value) {
					if(field=="file"){
						$('#estategrid').datagrid('selectRow',rowIndex);
						var row = $('#estategrid').datagrid('getSelected');
						businesscode = row.businesscode;
						businessnumber = row.businessnumber;
						//alert(businesscode+"-----"+businessnumber);
					}
				}
			});

			$('#sharegrounddefinegrid').datagrid({
				fitColumns:'true',
				maximized:'true',
				pagination:false,
				idField:'estateid',
				toolbar:[{
					text:'新增关联',
					iconCls:'icon-search',
					handler:function(){
						var row = $('#estategrid').datagrid('getSelected');
						var row1 = $('#sharegrounddefinegrid').datagrid('getSelected');
						if(row1){
							alert(row1.taxpayername);
							$.ajax({
							   type: "post",
								async:false,
							   url: "/ShareGroundDefineServlet/getbaseestateinfo.do",
							   data: {taxpayerid:row1.taxpayerid,shareestateid:row.shareestateid,page:1},
							   dataType: "json",
							   success: function(jsondata){
								   $('#couldsharegrounddefinegrid').datagrid('loadData',jsondata);
							   }
							});
							$('#couldsharegrounddefinewindow').window('open');
						}
					}
				},{
					text:'取消关联',
					iconCls:'icon-add',
					handler:function(){
						opttype='add';
						$('#sharegrounddefinewindow').window('open');
						//$('#sharegrounddefinewindow').window('refresh', 'sharegrounddefineselect.jsp');
					}
				},{
					text:'保存',
					iconCls:'icon-edit',
					handler:function(){
						var row = $('#estategrid').datagrid('getSelected');
						if(row){
							$('#sharegrounddefinewindow').window('open');
							//$('#sharegrounddefinewindow').window('refresh', 'sharegrounddefineselect.jsp');
						}
						
					}
				},{
					text:'关闭',
					iconCls:'icon-search',
					handler:function(){
						$('#sharegrounddefinewindow').window('close');
					}
				}]
			});
				$('#couldsharegrounddefinegrid').datagrid({
				fitColumns:'true',
				maximized:'true',
				pagination:false,
				checkbox:true,
				idField:'estateid',
				toolbar:[{
					text:'关联',
					iconCls:'icon-search',
					handler:function(){
						var estateids ='';
						var rows = $('#couldsharegrounddefinegrid').datagrid('getSelections');
						for(var i =0;i<rows.length;i++){
							estateids = estateids + "'"+rows[i].landgainid+"',";
							var index = $('#couldsharegrounddefinegrid').datagrid('getRowIndex',rows[i])+1;
							if(rows[i].isuse=='1'){
								$.messager.alert('提示框',"序号为"+index+"的记录已发生后续业务，不能提交！");
								return;
							}
						}
						$('#couldsharegrounddefinewindow').window('close');
					}
				},{
					text:'关闭',
					iconCls:'icon-search',
					handler:function(){
						$('#couldsharegrounddefinewindow').window('close');
					}
				}]
			});
			
			var p = $('#estategrid').datagrid('getPager');  
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
									$('#estategrid').datagrid('selectRecord',selectid);
									var row = $('#estategrid').datagrid('getSelected');
									var index = $('#estategrid').datagrid('getRowIndex',row);
									var lastindex = $('#estategrid').datagrid('getData')['total']-1;
									if(index > lastindex){
										$('#estategrid').datagrid('unselectRow',index);
									}
								}else{
									selectindex = undefined;
								}
							} 
				});
	

		function query(){
			var params = {};
			var fields =$('#groundstoragequeryform').serializeArray();
			$.each( fields, function(i, field){
				params[field.name] = field.value;
			}); 
			//$('#estategrid').datagrid({
			//	url:'/InitGroundServlet/getlandstoreinfo.do'
			//});
			params.datatype=datatype;
			$('#estategrid').datagrid('loadData',{total:0,rows:[]});
			var opts = $('#estategrid').datagrid('options');
			opts.url = '/ShareGroundDefineServlet/getbaseestateinfo.do';
			$('#estategrid').datagrid('load',params); 
			var p = $('#estategrid').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false,
				pageSize: 15
			});
			$('#groundstoragequerywindow').window('close');
			
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
				   $('#estategrid').datagrid('reload');
				  $('#groundstorageeditwindow').window('close');
				  $.messager.alert('返回消息','保存成功！');
			   }
			});
		}


	function format(row){
		for(var i=0; i<groundusedata.length; i++){
			if (groundusedata[i].key == row) return groundusedata[i].value;
		}
		return row;
	}

	function uploadbutton(row){
		return '<a href="#" class="easyui-linkbutton" id=\'uploadbtn\' data-options=\'iconCls:\'icon-save\'\' onclick=\'uploadfile()\'>附件管理</a>';
	}
	//function quereyreg(){
	//	$('#reginfowindow').window('open');//打开新录入窗口
	//	$('#reginfowindow').window('refresh', 'reginfo.jsp');
	//}
	function uploadfile(){
		uploadModal.init("uploadbtn",businesscode,businessnumber);
	}
	</script>
</head>
<body>
	<form id="sharegrounddefineform" method="post">
		<div title="土地信息" data-options="
						tools:[{
							handler:function(){
								$('#estategrid').datagrid('reload');
							}
						}]">
					
						<table id="estategrid" style="overflow:auto" 
						data-options="iconCls:'icon-edit',singleSelect:true,idField:'itemid'" rownumbers="true"> 
							<thead>
								<tr>
									<th data-options="field:'estateid',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'shareestateid',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'taxpayerid',width:80,align:'center',editor:{type:'validatebox'}">计算机编码</th>
									<th data-options="field:'taxpayername',width:200,align:'center',editor:{type:'validatebox'}">纳税人名称</th>
									<th data-options="field:'purpose',width:60,align:'center',formatter:format,editor:{type:'validatebox'}">土地用途</th>
									<th data-options="field:'datebegin',width:60,align:'center',editor:{type:'validatebox'}">使用起日期</th>
									<th data-options="field:'dateend',width:60,align:'center',editor:{type:'validatebox'}">使用止日期</th>
									<th data-options="field:'detailaddress',width:200,align:'center',editor:{type:'validatebox'}">详细地址</th>
									<th data-options="field:'landarea',width:100,align:'center',editor:{type:'validatebox'}">面积</th>
								</tr>
							</thead>
						</table>
					
			</div>
	</form>
	<div id="groundstoragequerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'共用宗地界定查询',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:300px;">
		<div class="easyui-panel" title="" style="width:900px;">
			<form id="groundstoragequeryform" method="post">
				<table id="narjcxx" width="100%"  class="table table-bordered">
					<tr>
						<td align="right">州市地税机关：</td>
						<td>
							<input class="easyui-combobox" name="taxorgsupcode" id="taxorgsupcode" style="width:200px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">县区地税机关：</td>
						<td>
							<input class="easyui-combobox" name="taxorgcode" id="taxorgcode" style="width:200px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
					</tr>
					<tr>
						<td align="right">主管地税部门：</td>
						<td>
							<input class="easyui-combobox" name="taxdeptcode" id="taxdeptcode" style="width:200px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">税收管理员：</td>
						<td>
							<input class="easyui-combobox" name="taxmanagercode" id="taxmanagercode" style="width:200px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
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
						<td align="right">实际交付时间：</td>
						<td colspan="3">
							<input id="queryholddatebegin" class="easyui-datebox" name="queryholddatebegin"/>
						至
							<input id="queryholddateend" class="easyui-datebox"  name="queryholddateend"/>
						</td>
					</tr>
				</table>
			</form>
			<div style="text-align:center;padding:5px;">  
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="query()">查询</a>
			</div>
		</div>
	</div>
	<div id="reginfowindow" class="easyui-window" data-options="closed:true,modal:true,title:'纳税人登记信息',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:620px;height:470px;">
	</div>
	<div id="sharegrounddefinewindow" class="easyui-window" data-options="closed:true,modal:true,title:'已关联共用宗地',collapsible:false,minimizable:false,maximizable:false,closable:true,resizable:false" style="width:960px;height:500px;">
		<div title="土地信息" data-options="tools:[{
							handler:function(){
								$('#sharegrounddefinegrid').datagrid('reload');
							}
						}]">
						<table id="sharegrounddefinegrid" style="overflow:auto" 
						data-options="iconCls:'icon-edit',singleSelect:true,idField:'itemid'" rownumbers="true"> 
							<thead>
								<tr>
									<th data-options="field:'estateid',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'shareestateid',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'taxpayerid',width:80,align:'center',editor:{type:'validatebox'}">计算机编码</th>
									<th data-options="field:'taxpayername',width:200,align:'center',editor:{type:'validatebox'}">纳税人名称</th>
									<th data-options="field:'purpose',width:50,align:'center',formatter:format,editor:{type:'validatebox'}">土地用途</th>
									<th data-options="field:'datebegin',width:60,align:'center',editor:{type:'validatebox'}">使用起日期</th>
									<th data-options="field:'dateend',width:60,align:'center',editor:{type:'validatebox'}">使用止日期</th>
									<th data-options="field:'detailaddress',width:200,align:'center',editor:{type:'validatebox'}">详细地址</th>
									<th data-options="field:'landarea',width:100,align:'center',editor:{type:'validatebox'}">面积</th>
								</tr>
							</thead>
						</table>
			</div>
	</div>
	<div id="couldsharegrounddefinewindow" class="easyui-window" data-options="closed:true,modal:true,title:'可关联共用宗地',collapsible:false,minimizable:false,maximizable:false,closable:true,resizable:false" style="width:960px;height:500px;">
		<div title="土地信息" data-options="tools:[{
							handler:function(){
								$('#counldsharegrounddefinegrid').datagrid('reload');
							}
						}]">
					
						<table id="couldsharegrounddefinegrid" style="overflow:auto" 
						data-options="iconCls:'icon-edit',singleSelect:false,idField:'itemid'" rownumbers="true"> 
							<thead>
								<tr>
									<th data-options="field:'ck',checkbox:true"></th>
									<th data-options="field:'estateid',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'shareestateid',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'taxpayerid',width:80,align:'center',editor:{type:'validatebox'}">计算机编码</th>
									<th data-options="field:'taxpayername',width:200,align:'center',editor:{type:'validatebox'}">纳税人名称</th>
									<th data-options="field:'purpose',width:60,align:'center',formatter:format,editor:{type:'validatebox'}">土地用途</th>
									<th data-options="field:'datebegin',width:60,align:'center',editor:{type:'validatebox'}">使用起日期</th>
									<th data-options="field:'dateend',width:60,align:'center',editor:{type:'validatebox'}">使用止日期</th>
									<th data-options="field:'detailaddress',width:200,align:'center',editor:{type:'validatebox'}">详细地址</th>
									<th data-options="field:'landarea',width:100,align:'center',editor:{type:'validatebox'}">面积</th>
								</tr>
							</thead>
						</table>
			</div>
	</div>
</body>
</html>
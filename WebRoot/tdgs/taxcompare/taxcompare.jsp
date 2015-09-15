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
	<script src="/js/datecommon.js"></script>
	<script src="/js/common.js"></script>
	<script>
	var taxorgdata = new Object;
	var taxempdata = new Object;
	var optmenu = [{
					text:'查询',
					iconCls:'icon-search',
					handler:function(){
						$('#taxcomparequerywindow').window('open');
					}
				},{
					text:'导出',
					iconCls:'icon-export',
					handler:function(){
						$.messager.confirm('提示', '是否确认导出?', function(r){
							if (r){
								var param='';
								var fields =$('#taxcompareform').serializeArray();
								$.each( fields, function(i, field){
									if(field.value!= ''){
										param=param+field.name+'='+field.value+'&';
									}
								});
								window.open("/DerateCheckServlet/export.do?+'"+param+"'", '',
						           'top=1000,left=2500,width=1,height=1,toolbar=no,menubar=no,location=no');
							}
						});
					}
				},
//					{
//					text:'明细查看',
//					iconCls:'icon-tip',
//					handler:function(){
//						var row = $('#taxcomparegrid').datagrid('getSelected');
//						if(row){
//							$('#groundstorewindow').window('open');
//							$('#groundstorewindow').window('refresh', 'groundstore.jsp');
//						}
//					}
//				},
					{
					text:'比对',
					id:'compare',
					iconCls:'icon-check',
					handler:function(){
						var row = $('#taxcomparegrid').datagrid('getSelected');
						if(row){
							$('#comparewindow').window('open');
						}else{
							$.messager.alert('返回消息',"请选择需要审核的数据！");
						}
					}
				}];
	
	$(function(){
		//取得url参数
		var paraString = location.search;     
		var paras = paraString.split("&");   
		type = paras[0].substr(paras[0].indexOf("=") + 1);
		$('#taxcomparegrid').datagrid({toolbar:optmenu});
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
		$.ajax({
		   type: "post",
			async:false,
		   url: "/ComboxService/getComboxs.do",
		   data: {codetablename:'COD_TAXEMPCODE'},
		   dataType: "json",
		   success: function(jsondata){
			  taxempdata= jsondata;
		   }
		});
		$.ajax({
		   type: "post",
			async:false,
		   url: "/ComboxService/getComboxs.do",
		   data: {codetablename:'COD_GROUNDSOURCECODE'},
		   dataType: "json",
		   success: function(jsondata){
			  groundsourcedata= jsondata;
		   }
		});
		var regex = new RegExp("\"","g");  
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
							//$.messager.alert('返回消息',n.key);
							$.ajax({
								   type: "get",
								   url: "/soption/taxOrgOptionBySup.do",
								   data: {"taxSuperOrgCode":n.key},
								   dataType: "json",
								   success: function(jsondata){
										//$.messager.alert('返回消息',JSON.stringify(jsondata));
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
						//$.messager.alert('返回消息',JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
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
						//$.messager.alert('返回消息',JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
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
						//$.messager.alert('返回消息',JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
						$('#taxdeptcode').combobox("setValue",JSON.stringify(jsondata.taxDeptOptionJsonArray[0].key).replace(regex, ""));
						$('#taxdeptcode').combobox("setText",JSON.stringify(jsondata.taxDeptOptionJsonArray[0].keyvalue).replace(regex, ""));
					}



				   $('#taxmanagercode').combobox({
						data : jsondata.taxEmpOptionJsonArray,
                        valueField:'key',
                        textField:'keyvalue'
					});
					//分局登录 默认选中
					var orgclass='<%=com.szgr.framework.authority.datarights.SystemUserAccessor.getInstance().getUserTaxOrgVO().getOrgclass()%>';
					var taxdeptcode='<%=com.szgr.framework.authority.datarights.SystemUserAccessor.getInstance().getTaxorgcode()%>';
					var taxempcode='<%=com.szgr.framework.authority.datarights.SystemUserAccessor.getInstance().getTaxempcode()%>';
					var taxorgname ='<%=com.szgr.framework.authority.datarights.SystemUserAccessor.getInstance().getUserTaxOrgVO().getTaxorgname()%>';
					if(orgclass=='04'){
						$('#taxdeptcode').combobox("setValue",taxdeptcode);
						$('#taxmanagercode').combobox("setValue",taxempcode);
					}
					query();
	           }
	   });
			$('#taxcomparegrid').datagrid({
				//fitColumns:'true',
				//fit: true, 
				maximized:'true',
				pagination:true,
				view:$.extend({},$.fn.datagrid.defaults.view,{
						onAfterRender: function(target){
										$('#taxcomparegrid').datagrid('clearSelections');
									} 
						}),
				//toolbar:,
				onCheck:function(rowIndex,rowData){
					selectid = rowData.landstoreid;
				},
				onClickRow:function(index){
					var row = $('#taxcomparegrid').datagrid('getSelected');
					$('#check').linkbutton('enable');
					$('#cancelcheck').linkbutton('enable');
					$('#finalcheck').linkbutton('enable');
					$('#cancelfinalcheck').linkbutton('enable');
					if(row.state=='1'){
						$('#cancelcheck').linkbutton('disable');
						$('#finalcheck').linkbutton('disable');
						$('#cancelfinalcheck').linkbutton('disable');
					}
					if(row.state=='2'){
						$('#check').linkbutton('disable');
						$('#cancelfinalcheck').linkbutton('disable');
					}
					if(row.state=='3'){
						$('#check').linkbutton('disable');
						$('#cancelcheck').linkbutton('disable');
						$('#finalcheck').linkbutton('disable');
					}
				},
				onSelectAll:function(rows){
					var row = rows[0];
					$('#check').linkbutton('enable');
					$('#cancelcheck').linkbutton('enable');
					$('#finalcheck').linkbutton('enable');
					$('#cancelfinalcheck').linkbutton('enable');
					if(row.state=='1'){
						$('#cancelcheck').linkbutton('disable');
						$('#finalcheck').linkbutton('disable');
						$('#cancelfinalcheck').linkbutton('disable');
					}
					if(row.state=='2'){
						$('#check').linkbutton('disable');
						$('#cancelfinalcheck').linkbutton('disable');
					}
					if(row.state=='3'){
						$('#check').linkbutton('disable');
						$('#cancelcheck').linkbutton('disable');
						$('#finalcheck').linkbutton('disable');
					}
				}
			});
			var p = $('#taxcomparegrid').datagrid('getPager');  
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
									$('#taxcomparegrid').datagrid('selectRecord',selectid);
									var row = $('#taxcomparegrid').datagrid('getSelected');
									var index = $('#taxcomparegrid').datagrid('getRowIndex',row);
									var lastindex = $('#taxcomparegrid').datagrid('getData')['total']-1;
									if(index > lastindex){
										$('#taxcomparegrid').datagrid('unselectRow',index);
									}
								}else{
									selectindex = undefined;
								}
							} 
				});


		function query(){
			$('#taxcomparegrid').datagrid('unselectAll');
			var params = {};
			var fields =$('#taxcompareform').serializeArray();
			$.each( fields, function(i, field){
				params[field.name] = field.value;
			}); 
			//$('#taxcomparegrid').datagrid({
			//	url:'/InitGroundServlet/getlandstoreinfo.do'
			//});
			$('#taxcomparegrid').datagrid('loadData',{total:0,rows:[]});
			var opts = $('#taxcomparegrid').datagrid('options');
			opts.url = '/TaxacompareServlet/getreginfo.do';
			$('#taxcomparegrid').datagrid('load',params); 
			var p = $('#taxcomparegrid').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false,
				pageSize: 15
			});
			$('#taxcomparegrid').datagrid('unselectAll');
			$('#taxcomparequerywindow').window('close');
			
		}

		function compare(){
			var yearbegin = $('#yearbegin').numberbox('getValue');
			var yearend	= $('#yearend').numberbox('getValue');
			if(parseInt(yearend)<parseInt(yearbegin)){
				$.messager.alert('提示','止年度不能大于起始年度！');
				return;
			}
			var params = {};
			var fields =$('#yearform').serializeArray();
			$.each( fields, function(i, field){
				params[field.name] = field.value;
			}); 
			var row = $('#taxcomparegrid').datagrid('getSelected');
			params.taxpayerid = row.taxpayerid;
			$('#comparewindow').window('close');
			Load();
			$.ajax({
			   type: "post",
			   url: "/TaxacompareServlet/taxcompare.do",
			   data: params,
			   dataType: "json",
			   success: function(jsondata){
				   dispalyLoad();
				  $.messager.alert('返回消息','比对成功！');
			   }
			});
		}


	//function quereyreg(){
	//	$('#reginfowindow').window('open');//打开新录入窗口
	//	$('#reginfowindow').window('refresh', 'reginfo.jsp');
	//}

	function Load() {  
		$("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: $(window).height() }).appendTo("body");  
		$("<div class=\"datagrid-mask-msg\"></div>").html("正在操作，请稍候。。。").appendTo("body").css({ display: "block", left: ($(document.body).outerWidth(true) - 190) / 2, top: ($(window).height() - 45) / 2 });  
	}  
  
	function dispalyLoad() {  
		$(".datagrid-mask").remove();  
		$(".datagrid-mask-msg").remove();  
	} 
	
	</script>
</head>
<body>
	<form id="derateform" method="post">
		<div title="税源比对" data-options="
						tools:[{
							handler:function(){
								$('#taxcomparegrid').datagrid('reload');
							}
						}]">
					
						<table id="taxcomparegrid" style="overflow:visible" 
						data-options="iconCls:'icon-edit',singleSelect:true" rownumbers="true"> 
							<thead>
								<tr>
									<!-- <th data-options="field:'businesscode',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'businessnumber',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'taxreduceid',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'reducetype',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'datatype',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="checkbox:true"></th>
									<th data-options="field:'infoname',width:60,align:'center',formatter:addLinkLandInfo,editor:{type:'validatebox'}">相关信息</th>
									<th data-options="field:'a',width:100,align:'center',formatter:uploadbutton">附件管理</th> -->
									<th data-options="field:'taxpayerid',width:100,align:'center',editor:{type:'validatebox'}">计算机编码</th>
									<th data-options="field:'taxpayername',width:200,align:'center',editor:{type:'validatebox'}">纳税人名称</th>
									<!-- <th data-options="field:'taxtypecode',width:100,align:'center',formatter:function(value,row,index){
										for(var i=0; i<taxdata.length; i++){
											if (taxdata[i].key == value) return taxdata[i].value;
										}
										return value;
									},
									editor:{type:'validatebox'}">税种</th>
									<th data-options="field:'taxcode',width:100,align:'center',formatter:function(value,row,index){
										for(var i=0; i<taxdata.length; i++){
											if (taxdata[i].key == value) return taxdata[i].value;
										}
										return value;
									},
									editor:{type:'validatebox'}">税目</th>
									<th data-options="field:'reducebegindates',width:70,align:'center',editor:{type:'validatebox'}">减免起日期</th>
									<th data-options="field:'reduceenddates',width:70,align:'center',editor:{type:'validatebox'}">减免止日期</th>
									<th data-options="field:'approvenumber',width:100,align:'center',editor:{type:'validatebox'}">减免批准文号</th>
									<th data-options="field:'approveunit',width:100,align:'center',formatter:function(value,row,index){
										for(var i=0; i<taxorgdata.length; i++){
											if (taxorgdata[i].key == value) return taxorgdata[i].value;
										}
										return value;
									},editor:{type:'validatebox'}">批准机关</th>
									<th data-options="field:'reduceclass',width:100,align:'center',formatter:function(value,row,index){
										for(var i=0; i<deratetypedata.length; i++){
											if (deratetypedata[i].key == value) return deratetypedata[i].value;
										}
										return value;
									},editor:{type:'validatebox'}">减免类型</th>
									<th data-options="field:'reducenum',width:100,align:'center',editor:{type:'validatebox'}">减免面积(原值)</th>
									<th data-options="field:'taxamount',width:100,align:'center',editor:{type:'validatebox'}">减免税额</th>
									<th data-options="field:'reducereason',width:100,align:'center',editor:{type:'validatebox'}">减免原因</th>
									<th data-options="field:'policybasis',width:100,align:'center',editor:{type:'validatebox'}">减免政策依据</th>
									<th data-options="field:'inputperson',width:100,align:'center',formatter:function(value,row,index){
										for(var i=0; i<taxempdata.length; i++){
											if (taxempdata[i].key == value) return taxempdata[i].value;
										}
										return value;
									},editor:{type:'validatebox'}">录入人员</th>
									<th data-options="field:'inputdates',width:100,align:'center',editor:{type:'validatebox'}">录入时间</th>
									<th data-options="field:'checkperson',width:100,align:'center',formatter:function(value,row,index){
										for(var i=0; i<taxempdata.length; i++){
											if (taxempdata[i].key == value) return taxempdata[i].value;
										}
										return value;
									},editor:{type:'validatebox'}">审核人员</th>
									<th data-options="field:'checkdates',width:100,align:'center',editor:{type:'validatebox'}">审核时间</th> -->
									<th data-options="field:'taxdeptcode',width:100,align:'center',formatter:function(value,row,index){
										for(var i=0; i<taxorgdata.length; i++){
											if (taxorgdata[i].key == value) return taxorgdata[i].value;
										}
										return value;
									},editor:{type:'validatebox'}">主管地税部门</th>
									<th data-options="field:'taxmanagercode',width:100,align:'center',formatter:function(value,row,index){
										for(var i=0; i<taxempdata.length; i++){
											if (taxempdata[i].key == value) return taxempdata[i].value;
										}
										return value;
									},editor:{type:'validatebox'}">税收管理员</th>
								</tr>
							</thead>
						</table>
					
			</div>
	</form>
	<div id="taxcomparequerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'税源比对查询',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:300px;">
		<div class="easyui-panel" title="" style="width:900px;">
			<form id="taxcompareform" method="post">
				<table id="deratetable" width="100%"  class="table table-bordered">
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
							<input id="taxpayerid" class="easyui-validatebox" type="text" style="width:200px" name="taxpayerid"/>
						</td>
						<td align="right">纳税人名称：</td>
						<td>
							<input id="taxpayername" class="easyui-validatebox" type="text" style="width:200px" name="taxpayername"/>
						</td>
					</tr>
					<!-- <tr>
						<td align="right">审核状态：</td>
						<td>
							<select id="state" class="easyui-combobox" style="width:200px" name="state" editable="false">
								<option value="1" selected>未审核</option>
								<option value="2">已审核</option>
								<option value="3">已终审</option>
							</select>
						</td>
						<td align="right">减免日期：</td>
						<td>
							<input id="reducebegindate" class="easyui-datebox" name="reducebegindate"/>
						至
							<input id="reduceenddate" class="easyui-datebox"  name="reduceenddate"/>
						</td>
					</tr> -->
				</table>
			</form>
			<div style="text-align:center;padding:5px;">  
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="query()">查询</a>
			</div>
		</div>
	</div>
	
	<div id="comparewindow" class="easyui-window" data-options="closed:true,modal:true,title:'应纳税比对 ',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:500px;height:150px;">
		<div class="easyui-panel" title="" style="width:450px">
			<form id="yearform" method="post">
				<table id="yeartable" width="100%"  class="table table-bordered">
					<tr>
						<td align="right">税款比对所属年度：</td>
						<td>
							<input id="yearbegin" class="easyui-numberbox" type="text" style="width:100px" name="yearbegin"/>
						至
							<input id="yearend" class="easyui-numberbox" type="text" style="width:100px" name="yearend"/>
						</td>
					</tr>
					<tr>
						<td colspan="2">
						<div style="text-align:center;padding:5px;">  
								<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-check'" onclick="compare()">比对</a>
						</div>
						</td>
					</tr>
				</table>
			</form>
		</div>
	</div>
	<div id="housewindow" class="easyui-window" data-options="closed:true,modal:true,title:'房产信息',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:400px;">
	</div>
	<div id="sotrewindow" class="easyui-window" data-options="closed:true,modal:true,title:'批复信息',collapsible:false,minimizable:false,maximizable:false,closable:true,resizable:false" style="width:960px;height:500px;">
	</div>
	
</body>
</html>
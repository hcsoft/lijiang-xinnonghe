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
	$(function(){
		var paraString = location.search;     
		var paras = paraString.split("&");   
		datatype = paras[0].substr(paras[0].indexOf("=") + 1); 
		//alert(datatype);
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
			$('#paidintaxquerygrid').datagrid({
				fitColumns:'true',
				maximized:'true',
				pagination:true,
				idField:'taxbillno',
				toolbar:[{
					text:'查询',
					iconCls:'icon-search',
					handler:function(){
						$('#paidintaxqueryquerywindow').window('open');
					}
				}],
				onClickRow:function(index){
					
				}
			});
			var p = $('#paidintaxquerygrid').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
				});	
			
		});

	//结束所有行的编辑
		

		function query(){
			var params = {};
			var fields =$('#paidintaxqueryqueryform').serializeArray();
			$.each( fields, function(i, field){
				params[field.name] = field.value;
			}); 
			//$('#paidintaxquerygrid').datagrid({
			//	url:'/InitGroundServlet/getlandstoreinfo.do'
			//});
			$('#paidintaxquerygrid').datagrid('loadData',{total:0,rows:[]});
			var opts = $('#paidintaxquerygrid').datagrid('options');
			opts.url = '/PaidinTaxQueryServlet/getlevyinfo.do';
			$('#paidintaxquerygrid').datagrid('load',params); 
			var p = $('#paidintaxquerygrid').datagrid('getPager');  
			$(p).pagination({
				showPageList:false,
				pageSize: 15
			});
			$('#paidintaxqueryquerywindow').window('close');
			
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
	<form id="paidintaxqueryform" method="post">
		<div title="补缴税款查询" data-options="
						tools:[{
							handler:function(){
								$('#paidintaxquerygrid').datagrid('reload');
							}
						}]">
					
						<table id="paidintaxquerygrid" style="overflow:auto" 
						data-options="iconCls:'icon-edit',singleSelect:true,idField:'itemid'" rownumbers="true"> 
							<thead>
								<tr>
									<th data-options="field:'taxbillno',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'taxpayerid',width:60,align:'center',editor:{type:'validatebox'}">计算机编码</th>
									<th data-options="field:'taxpayername',width:130,align:'center',editor:{type:'validatebox'}">纳税人名称</th>
									<th data-options="field:'groundtax',width:80,align:'center',editor:{type:'validatebox'}">应缴纳土地使用税</th>
									<th data-options="field:'housetax',width:80,align:'center',editor:{type:'validatebox'}">已缴纳土地使用税</th>
									<th data-options="field:'constructiontax',width:60,align:'center',editor:{type:'validatebox'}">应补土地使用税</th>
									<th data-options="field:'educationtax',width:60,align:'center',editor:{type:'validatebox'}">已补土地使用税</th>
									<th data-options="field:'localeducationtax',width:60,align:'center',editor:{type:'validatebox'}">应缴纳房产税</th>
									<th data-options="field:'stamptax',width:60,align:'center',editor:{type:'validatebox'}">已缴纳房产税</th>
									<th data-options="field:'companytax',width:60,align:'center',editor:{type:'validatebox'}">应补房产税</th>
									<th data-options="field:'businesstax',width:60,align:'center',editor:{type:'validatebox'}">已补房产税</th>
									<th data-options="field:'latetax',width:60,align:'center',editor:{type:'validatebox'}">滞纳金</th>
									<!-- <th data-options="field:'taxdatebegins',width:60,align:'center',editor:{type:'validatebox'}">税款所属日期起</th>
									<th data-options="field:'taxdateends',width:100,align:'center',editor:{type:'validatebox'}">税款所属日期止</th> -->
									<!-- <th data-options="field:'areasell',width:100,align:'center',editor:{type:'validatebox'}">已出让面积</th> -->
									<!-- <th data-options="field:'taxclasscode',width:100,align:'center',editor:{type:'validatebox'}">税收分类</th> -->
									<!-- <th data-options="field:'file',width:100,align:'center',formatter:uploadbutton">附件管理</th> -->
								</tr>
							</thead>
						</table>
					
			</div>
	</form>
	<div id="paidintaxqueryquerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'补缴税款查询',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:300px;">
		<div class="easyui-panel" title="" style="width:900px;">
			<form id="paidintaxqueryqueryform" method="post">
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
					<!-- <tr>
						<td align="right">税收分类：</td>
						<td>
							<select id="taxclasscode" class="easyui-combobox" name="taxclasscode" style="width:200px"  editable="false">
								<option value=""></option>
								<option value="0">未提交</option>
								<option value="1">未审核</option>
								<option value="3">已审核</option>
								<option value="5">已终审</option>
							</select>
						</td>
						<td align="right">开票日期：</td>
						<td>
							<input id="makedatebegin" class="easyui-datebox" name="makedatebegin"/>
						至
							<input id="makedateend" class="easyui-datebox"  name="makedateend"/>
						</td>
					</tr>
					<tr>
						<td align="right">税款所属日期起：</td>
						<td colspan="3">
							<input id="taxdatebeginbegin" class="easyui-datebox" name="taxdatebeginbegin"/>
						至
							<input id="taxdatebeginend" class="easyui-datebox"  name="taxdatebeginend"/>
						</td>
					</tr>
					<tr>
						<td align="right">税款所属日期止：</td>
						<td colspan="3">
							<input id="taxdateendbegin" class="easyui-datebox" name="taxdateendbegin"/>
						至
							<input id="taxdateendend" class="easyui-datebox"  name="taxdateendend"/>
						</td>
					</tr> -->
				</table>
			</form>
			<div style="text-align:center;padding:5px;">  
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="query()">查询</a>
					<!-- <a href="#" class="easyui-linkbutton" id="aaa" data-options="iconCls:'icon-search'" >查询</a> -->
			</div>
		</div>
	</div>
	<!-- <div id="paidintaxqueryeditwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地收储批复',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:300px;">
		<div class="easyui-panel" title="" style="width:900px;">
			<form id="paidintaxqueryeditform" method="post">
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
	<!-- <div id="paidintaxquerydetailwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地收储批复明细',collapsible:false,minimizable:false,maximizable:false,closable:false" style="width:800px;height:400px;">
	<table id="paidintaxquerydetailgrid"></table>
	</div> -->
	<!-- <div id="reginfowindow" class="easyui-window" data-options="closed:true,modal:true,title:'纳税人登记信息',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:620px;height:470px;">
	</div>
	<div id="groundstorewindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地批复',collapsible:false,minimizable:false,maximizable:false,closable:true,resizable:false" style="width:960px;height:500px;">
	</div> -->
	<!-- <div id="paidintaxqueryaddwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地收储批复新增',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:200px;">
	</div> -->
	<!-- <div id="addtdxxwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地信息',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:500px;">
	</div> -->

</body>
</html>
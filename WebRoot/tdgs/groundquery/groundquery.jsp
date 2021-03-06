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
	var locationdata = new Array();
	var belongtocountry = new Array();
	var belongtowns = new Array();
	var groundusedata = new Array();
	var locationdata = new Array();
	var landcertificatetypdata = new Array();
	var taxorgdata = new Array();
	var taxempdata = new Array();
	var landsourcedata = new Array();
	var datatypedata = [{'key':'0','value':'期初采集'},{'key':'1','value':'业务采集'}];
	$(function(){
		
		$.ajax({
			   type: "post",
			   async:false,
			   url: "/InitGroundServlet/getlocationComboxs.do",
			   data: {},
			   dataType: "json",
			   success: function(jsondata){
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
			  landsourcedata= jsondata;
		   }
		});
		$.ajax({
		   type: "post",
			async:false,
		   url: "/ComboxService/getComboxs.do",
		   data: {codetablename:'COD_GROUNDUSECODE'},
		   dataType: "json",
		   success: function(jsondata){
			  groundusedata= jsondata;
		   }
		});
		$.ajax({
		   type: "post",
			async:false,
		   url: "/ComboxService/getComboxs.do",
		   data: {codetablename:'COD_LOCATIONTYPE'},
		   dataType: "json",
		   success: function(jsondata){
			  locationdata= jsondata;
		   }
		});
		$.ajax({
			   type: "post",
				async:false,
			   url: "/ComboxService/getComboxs.do",
			   data: {codetablename:'COD_LANDCERTIFICATETYPE'},
			   dataType: "json",
			   success: function(jsondata){
				  landcertificatetypdata= jsondata;
				 
			   }
		});
		$('#groundqueryform #belongtocountry').combobox({
		   onSelect:function(data){
		      CommonUtils.getCacheCodeFromTable('COD_DISTRICT','id',
		                                 'name','#groundqueryform #belongtowns'," and parentid = '"+data.key+"' ");
		   }
	   	});
		CommonUtils.getCacheCodeFromTable('COD_DISTRICT','id',
			                                 'name','#groundqueryform #belongtocountry'," and parentid = '530122' ");
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
			$('#groundquerygrid').datagrid({
				//fitColumns:'true',
				//maximized:'true',
				pagination:true,
				idField:'estateid',
				toolbar:[{
					text:'查询',
					iconCls:'icon-search',
					handler:function(){
						$('#groundquerywindow').window('open');
					}
				},{
					text:'导出',
					iconCls:'icon-export',
					handler:function(){
						$.messager.confirm('提示', '是否确认导出?', function(r){
							if (r){
								var param='';
								var fields =$('#groundqueryform').serializeArray();
								$.each( fields, function(i, field){
									if(field.value!= ''){
										param=param+field.name+'='+field.value+'&';
									}
								});
								window.open("/GroundQueryServlet/export.do?"+param, '',
						           'top=1000,left=2500,width=1,height=1,toolbar=no,menubar=no,location=no');
							}
						});
					}
				}]
			});
			
			var p = $('#groundquerygrid').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false,
					pageSize: 15
				});


			
		});
	
		function query(){
			var params = {};
			var fields =$('#groundqueryform').serializeArray();
			$.each( fields, function(i, field){
				params[field.name] = field.value;
			}); 
			//$('#groundquerygrid').datagrid({
			//	url:'/InitGroundServlet/getlandstoreinfo.do'
			//});
			$('#groundquerygrid').datagrid('loadData',{total:0,rows:[]});
			var opts = $('#groundquerygrid').datagrid('options');
			opts.url = '/GroundQueryServlet/groundquery.do';
			$('#groundquerygrid').datagrid('load',params); 
			var p = $('#groundquerygrid').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false,
				pageSize: 15
			});
			$('#groundquerygrid').datagrid('unselectAll');
			$('#groundquerywindow').window('close');
			
		}


	</script>
</head>
<body>
	
		<div title="土地信息" data-options="
						tools:[{
							handler:function(){
								$('#groundquerygrid').datagrid('reload');
							}
						}]">
					
						<table id="groundquerygrid" style="overflow:visible" 
						data-options="iconCls:'icon-edit',singleSelect:true,idField:'itemid'" rownumbers="true"> 
							<thead>
								<tr>
									<th data-options="field:'estateid',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'ploughid',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<!-- <th data-options="field:'datatype',width:80,align:'left',formatter:function(value,row,index){
										for(var i=0; i<datatypedata.length; i++){
											if (datatypedata[i].key == value) return datatypedata[i].value;
										}
										return value;
									},editor:{type:'validatebox'}">数据来源</th> -->
									<!-- <th data-options="field:'state',width:60,align:'left',editor:{type:'validatebox'}">状态</th> -->
									<th data-options="field:'taxpayerid',width:100,align:'left',editor:{type:'validatebox'}">计算机编码</th>
									<th data-options="field:'taxpayername',width:300,align:'left',editor:{type:'validatebox'}">纳税人名称</th>
									<th data-options="field:'landsource',width:100,align:'left',formatter:function(value,row,index){
										for(var i=0; i<landsourcedata.length; i++){
											if (landsourcedata[i].key == value) return landsourcedata[i].value;
										}
										return value;
									},editor:{type:'validatebox'}">土地来源</th>
									<th data-options="field:'landcertificatetype',width:100,align:'left',formatter:function(value,row,index){
										for(var i=0; i<landcertificatetypdata.length; i++){
											if (landcertificatetypdata[i].key == value) return landcertificatetypdata[i].value;
										}
										return value;
									},editor:{type:'validatebox'}">土地证类型</th>
									<th data-options="field:'landcertificate',width:150,align:'left',editor:{type:'validatebox'}">土地证号</th>
									<th data-options="field:'purpose',width:80,align:'left',formatter:function(value,row,index){
										for(var i=0; i<groundusedata.length; i++){
											if (groundusedata[i].key == value) return groundusedata[i].value;
										}
										return value;
									},editor:{type:'validatebox'}">土地用途</th>
									<th data-options="field:'holddate',width:80,align:'left',editor:{type:'validatebox'}">土地交付时间</th>
									<th data-options="field:'locationtype',width:100,align:'left',formatter:function(value,row,index){
										for(var i=0; i<locationdata.length; i++){
											if (locationdata[i].key == value) return locationdata[i].value;
										}
										return value;
									},editor:{type:'validatebox'}">坐落地类型</th>
									<th data-options="field:'belongtocountry',width:120,align:'left',formatter:function(value,row,index){
										for(var i=0; i<belongtocountry.length; i++){
											if (belongtocountry[i].key == value) return belongtocountry[i].value;
										}
										return value;
									},editor:{type:'validatebox'}">所属乡（镇、街道办）</th>
									<th data-options="field:'belongtowns',width:120,align:'left',formatter:function(value,row,index){
										for(var i=0; i<belongtowns.length; i++){
											if (belongtowns[i].key == value) return belongtowns[i].value;
										}
										return value;
									},editor:{type:'validatebox'}">所属村（居）委会 </th>
									<th data-options="field:'detailaddress',width:250,align:'left',editor:{type:'validatebox'}">详细地址</th>
									<th data-options="field:'landmoney',width:80,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">土地总价</th>
									<th data-options="field:'landarea',width:80,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">面积</th>
									<th data-options="field:'taxrate',width:100,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">土地使用税税率</th>
									<th data-options="field:'landtaxflag',width:120,align:'center',formatter:function(value,row,index){
										if(value=='1'){
											return '是';
										}else{
											return '否';
										}
									},editor:{type:'validatebox'}">是否纳入征税范围</th>
									<th data-options="field:'taxdeptcode',width:160,align:'left',formatter:function(value,row,index){
										for(var i=0; i<taxorgdata.length; i++){
											if (taxorgdata[i].key == value) return taxorgdata[i].value;
										}
										return value;
									},editor:{type:'validatebox'}">主管地税部门</th>
									<th data-options="field:'taxmanagercode',width:100,align:'left',formatter:function(value,row,index){
										for(var i=0; i<taxempdata.length; i++){
											if (taxempdata[i].key == value) return taxempdata[i].value;
										}
										return value;
									},editor:{type:'validatebox'}">税收管理员</th>
								</tr>
							</thead>
						</table>
					
			</div>
	<div id="groundquerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地信息查询',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:300px;">
		<div class="easyui-panel" title="" style="width:900px;">
			<form id="groundqueryform" method="post">
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
							<input id="taxpayerid" class="easyui-validatebox" type="text" style="width:200px" name="taxpayerid" onkeydown="if(event.keyCode==13)spelltaxpayerid(this)"/>
						</td>
						<td align="right">纳税人名称：</td>
						<td>
							<input id="taxpayername" class="easyui-validatebox" type="text" style="width:200px" name="taxpayername"/>
						</td>
						
					</tr>
					<tr>
						<!-- <td align="right">数据来源：</td>
						<td>
							<select id="datatype" class="easyui-combobox" style="width:200px" name="datatype" editable="false">
								<option value="" >全部</option>
								<option value="0" >期初采集</option>
								<option value="1" >业务采集</option>
							</select>
						</td> -->
						<td align="right">土地来源：</td>
						<td>
							<input id="landsource" name="landsource" style="width:200px;" class="easyui-combobox" editable='false' data-options="
								valueField: 'key',
								textField: 'value',
								url: '/ComboxService/getComboxs.do?codetablename=COD_GROUNDSOURCECODE'" />
						</td>
						<td align="right">坐落地类型：</td>
						<td>
							<input id="locationtype" name="locationtype" style="width:200px;" class="easyui-combobox" editable='false' data-options="
								valueField: 'key',
								textField: 'value',
								url: '/ComboxService/getComboxs.do?codetablename=COD_LOCATIONTYPE'" />
						</td>
						
						<!-- <td align="right">状态：</td>
						<td colspan="3">
							<select id="state" class="easyui-combobox" style="width:250px" name="state" editable="false">
								<option value="" >全部</option>
								<option value="0" >未处理</option>
								<option value="1" >已处理</option>
							</select>
						</td> -->
					</tr>
					<tr>
						
						<td align="right">所属乡镇：</td>
						<td>
							<input class="easyui-combobox"  id="belongtocountry" style="width:200px;" name="belongtocountry"  data-options='' />
						</td>
						<td align="right">所属村委会：</td>
						<td>
							<input class="easyui-combobox"  id="belongtowns" style="width:200px;" name="belongtowns" data-options="disabled:false,panelHeight:200" data-validate=""/>	
						</td>
					</tr>
					<tr>
						<td align="right">详细地址：</td>
						<td colspan="3">
							<input id="detailaddress" class="easyui-validatebox" type="text" style="width:400px" name="detailaddress"/>
						</td>
					</tr>
					<tr>
						<td align="right">土地交付时间：</td>
						<td colspan="3">
							<input id="holddatebegin" class="easyui-datebox" name="holddatebegin"/>
						至
							<input id="holddateend" class="easyui-datebox"  name="holddateend"/>
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
	<div id="reginfowindow" class="easyui-window" data-options="closed:true,modal:true,title:'纳税人登记信息',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:620px;height:470px;">
	</div>
	<div id="groundstorewindow" class="easyui-window" data-options="closed:true,modal:true,title:'批复',collapsible:false,minimizable:false,maximizable:false,closable:true,resizable:false" style="width:1000px;height:500px;">
	</div>
</body>
</html>
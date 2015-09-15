<%@ page contentType="text/html; charset=UTF-8"%>

<!DOCTYPE html>
<%@ include file="/common/inc.jsp"%>
<html>
<head>
	<base target="_self"/>
	<title></title>
	<link rel="stylesheet" href="<%=spath%>/themes/sunny/easyui.css">
	<link rel="stylesheet" href="<%=spath%>/themes/icon.css">
	<link rel="stylesheet" href="<%=spath%>/css/toolbar.css">
	<link rel="stylesheet" href="<%=spath%>/css/logout.css"/>
	<script src="<%=spath%>/js/jquery-1.8.2.min.js"></script>
	<script src="<%=spath%>/js/jquery.easyui.min.js"></script>
    <script src="<%=spath%>/js/tiles.js"></script>
    <script src="<%=spath%>/js/moduleWindow.js"></script>
	<script src="<%=spath%>/menus.js"></script>
	<script src="<%=spath%>/js/jquery.simplemodal.js"></script> 
	<script src="<%=spath%>/js/overlay.js"></script>
	<script src="<%=spath%>/js/jquery.json-2.2.js"></script>
	<script src="<%=spath%>/js/json2.js"></script>
	<script src="<%=spath%>/locale/easyui-lang-zh_CN.js"></script>
	
<script type="text/javascript">

	$(function(){
		    $('#proc_settlementgrid1').datagrid({
		    	rownumbers:true,
		    	singleSelect:true,
				fitColumns:true,
				maximized:true,
				pagination:{  
			        pageSize: 15,
					showPageList:false
			    },
			    columns:[[
							{field:'serialno',title:'主键',hidden:'true'}, 
							{field:'taxbillno',title:'税票号',width:125,hidden:'true'},   
							{field:'taxcode',title:'税目',width:80, formatter:formattertaxcode},   
							{field:'taxpayerid',title:'计算机编码',width:110},   
							{field:'taxpayername',title:'纳税人名称',width:130},   
							{field:'taxamountactual',title:'已缴金额',align:'right',width:100},   
							{field:'taxdatebegin',title:'税款所属期起',width:100,formatter: formatter1}, 
							{field:'taxdateend',title:'税款所属期止',width:100,formatter: formatter1},
//							{field:'taxmanagercode',title:'税收管理员',width:100, formatter:formattertaxempcode}, 
							{field:'clearlogid',title:'日志ID',hidden:'true'},
							{field:'taxstate',title:'状态',hidden:'true'}
		        ]],
			    onClickRow:proc_settlementgrid_query
			    ,
			    onLoadSuccess:function(data){  
			    	var querytype=$("input[name='proc_querytype']:checked").val();
					if(querytype==3 && data.rows.length<=0){
						$('#proc_manualbutton1').linkbutton('disable'); 
						$('#proc_manualbutton2').linkbutton('disable');
						
					}
					$(this).datagrid('selectRow',0);//自动选择第一行
					proc_settlementgrid_query(0,data.rows[0]);
					
			    }, 
			});
		    $('#proc_settlementgrid2').datagrid({
		    	rownumbers:true,
//		    	singleSelect:true,
				fitColumns:true,
				maximized:true,
				pagination:{  
			        pageSize: 15,
					showPageList:false
			    },
			    columns:[[
							{field:'serialno',title:'主键',hidden:'true'}, 
//							{field:'datatype',title:'数据类型',width:125,hidden:'true'},   
							{field:'taxcode',title:'税目',width:80, formatter:formattertaxcode},   
							{field:'taxpayerid',title:'计算机编码',width:110},   
							{field:'taxpayername',title:'纳税人名称',width:130},   
							{field:'taxamount',title:'应缴金额',align:'right',width:100},   
							{field:'taxdatebegin',title:'税款所属期起',width:100,formatter: formatter1}, 
							{field:'taxdateend',title:'税款所属期止',width:100,formatter: formatter1},
							{field:'taxstate',title:'状态',hidden:'true'}
		        ]],
			    onLoadSuccess:function(data){  
//					$(this).datagrid('selectRow',0);//自动选择第一行
			    }, 
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
									   }
								});
							} 
						});
						if(jsondata.taxOrgOptionJsonArray.length == 1){
							//$.messager.alert('返回消息',jsondata.taxOrgOptionJsonArray[0].keyvalue);
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
						if(orgclass=='04'){
							$('#taxdeptcode').combobox("setValue",taxdeptcode);
							$('#taxmanagercode').combobox("setValue",taxempcode);
						}
		           }
		   });
		    $.ajax({
				   type: "post",
					async:false,
				   url: "/ComboxService/getComboxs.do",
				   data: {codetablename:'COD_TAXEMPCODE'},
				   dataType: "json",
				   success: function(jsondata){
					   emplist= jsondata;
				   }
				});
		    $.ajax({
				   type: "post",
					async:false,
				   url: "/ComboxService/getComboxs.do",
				   data: {codetablename:'COD_TAXCODE'},
				   dataType: "json",
				   success: function(jsondata){
					   taxcodelist= jsondata;
				   }
				});
		    
	})
	
	
	function settlementgrid_query(rowIndex, rowData){
		if(undefined==rowData || rowData==null){
			$('#settlementgrid2').datagrid('loadData',{total:0,rows:[]});
			return;
		}
			
		var querytype=$("input[name='querytype']:checked").val();
//		alert(querytype);
		if(querytype!='1'){
//			alert(rowData);
	    	$('#settlementgrid2').datagrid('loadData',{total:0,rows:[]});
			var p = $('#settlementgrid2').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false,
				pageSize: 15
			});
			var opts = $('#settlementgrid2').datagrid('options');
			opts.url = '/taxsettlementservice/dodeal2.do';
			$('#settlementgrid2').datagrid('load',{serialno:rowData.serialno,querytype:''}); 
		}
    }
	
	function proc_settlementgrid_query(rowIndex, rowData){
		if(undefined==rowData || rowData==null){
			$('#proc_settlementgrid2').datagrid('loadData',{total:0,rows:[]});
			return;
		}
		var querytype=$("input[name='proc_querytype']:checked").val();
//		alert(querytype);
		if(querytype!='1'){
//			alert(rowData);
	    	$('#proc_settlementgrid2').datagrid('loadData',{total:0,rows:[]});
			var p = $('#proc_settlementgrid2').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false,
				pageSize: 15
			});
			var opts = $('#proc_settlementgrid2').datagrid('options');
			opts.url = '/taxsettlementservice/dodeal2.do';
			$('#proc_settlementgrid2').datagrid('load',{serialno:rowData.serialno,querytype:''}); 
		}
    }
	
	function manual(taxstate){
		var querytype=$("input[name='querytype']:checked").val();
		var rows=$('#settlementgrid1').datagrid("getSelected");
		var rows2=$('#settlementgrid2').datagrid("getSelections");
		if(undefined==rows ||  null==rows ){
			$.messager.alert("提示","请选择已税记录!");
			return;
		}
		if(rows2.length<=0){
			$.messager.alert("提示","请选择应纳税记录!");
			return;
		}
		var subid=new Array();
		for(var i=0;i<rows2.length;i++){
			subid.push(rows2[i].serialno);
		}
		 
		//alert(subid);
		$.messager.confirm('提示', '是否确认人工'+(taxstate==2?'欠税':taxstate==3?'回退':'清缴')+'?', function(r){
			if (r){
				$.ajax({
					type: 'POST',
			        url: "/taxsettlementservice/manual.do",
			        data: {taxstate:taxstate,serialno:rows.serialno,subid:subid.toString()},
			       	dataType: "json",
			        success: function (data) {
			        		$.messager.alert("提示",data);
			        		dodeal(querytype);
			        }
			    });
			}
		});
	}
	function proc_manual(taxstate){
		var querytype=$("input[name='proc_querytype']:checked").val();
		var rows=$('#proc_settlementgrid1').datagrid("getSelected");
		var rows2=$('#proc_settlementgrid2').datagrid("getSelections");
		if(undefined==rows ||  null==rows ){
			$.messager.alert("提示","请选择已税记录!");
			return;
		}
		if(rows2.length<=0){
			$.messager.alert("提示","请选择应纳税记录!");
			return;
		}
		var subid=new Array();
		for(var i=0;i<rows2.length;i++){
			subid.push(rows2[i].serialno);
		}
		 
		//alert(subid);
		$.messager.confirm('提示', '是否确认人工'+(taxstate==2?'欠税':taxstate==3?'回退':'清缴')+'?', function(r){
			if (r){
				$.ajax({
					type: 'POST',
			        url: "/taxsettlementservice/manual.do",
			        data: {taxstate:taxstate,serialno:rows.serialno,subid:subid.toString()},
			       	dataType: "json",
			        success: function (data) {
			        		$.messager.alert("提示",data);
			        		proc_dodeal();
			        }
			    });
			}
		});
	}
	
	function query_windows_open(){
		$('#query_windows').window('open');
	}
	
	function proc_dodeal(){
		
		var querytype=$("input[name='proc_querytype']:checked").val();
		
		var p = $('#proc_settlementgrid1').datagrid('getPager');  
		$(p).pagination({   
			showPageList:false,
			pageSize: 15
		});
		var opts = $('#proc_settlementgrid1').datagrid('options');
		opts.url = '/taxsettlementservice/dodeal.do';
		
		$('#proc_settlementgrid1').datagrid('load',{querytype:querytype,
													  taxorgsupcode:$('#taxorgsupcode').combobox("getValue"),
													  taxorgcode:$('#taxorgcode').combobox("getValue"),
													  taxdeptcode:$('#taxdeptcode').combobox("getValue"),
													  taxmanagercode:$('#taxmanagercode').combobox("getValue"),
													  taxpayerid:$("#taxpayerid").val(),
													  taxpayername:$("#taxpayername").val()}); 
		
		//比对欠税/税源差异
		if(querytype==1){
			$('#proc_settlementgrid2').datagrid('loadData',{total:0,rows:[]});
			var p = $('#proc_settlementgrid2').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false,
				pageSize: 15
			});
			var opts = $('#proc_settlementgrid2').datagrid('options');
			opts.url = '/taxsettlementservice/dodeal2.do';
			$('#proc_settlementgrid2').datagrid('load',{serialno:'',querytype:1});
		}
		
		if(querytype==3){
			$('#proc_manualbutton1').linkbutton('enable'); 
			$('#proc_manualbutton2').linkbutton('enable');
			$('#proc_manualbutton3').linkbutton('disable');
		}else if(querytype==2 || querytype==5){
			$('#proc_manualbutton1').linkbutton('disable'); 
			$('#proc_manualbutton2').linkbutton('disable');
			$('#proc_manualbutton3').linkbutton('enable');
		}else{
			$('#proc_manualbutton1').linkbutton('disable'); 
			$('#proc_manualbutton2').linkbutton('disable');
			$('#proc_manualbutton3').linkbutton('disable');
		}
		
		$('#query_windows').window('close');
	}
</script>
</head>

<body class="easyui-layout" onload="">  
    <div data-options="region:'center',title:''" style="padding:5px;">
		<!-- 	<div style="text-align:left;padding:5px;">  
					<div style="background-color: #c9c692;height: 25px;">		
			 				<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="querylog()" >查询日志</a>
							<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="taxsettlement()" >新增清缴</a>
							<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-back'" onclick="doback()" >回退</a>
						<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-viewdetail'" onclick="detail()" >明细</a>
							<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-arrow_flag_red'" onclick="doproc()" >差异处理</a>
					</div>
			</div>-->	

        		<div style="text-align:left;width:950px;">  
						<div style="background-color: #c9c692;height: 25px;">		
								<span style="font-size: 12px; color:red; font-weight: bold;">过滤条件：</span>
								<span style="font-size: 12px;"><input type="radio" checked="checked" name="proc_querytype" value="3" onclick=""/>比对差异</span>&nbsp;
								<span style="font-size: 12px;"><input type="radio"  name="proc_querytype" value="1" onclick=""/>比对欠税/税源差异</span>&nbsp;
								<span style="font-size: 12px;"><input type="radio"  name="proc_querytype" value="4" onclick=""/>比对清缴</span>&nbsp;
								<span style="font-size: 12px;"><input type="radio"  name="proc_querytype" value="2" onclick=""/>人工确认欠税</span>&nbsp;
								<span style="font-size: 12px;"><input type="radio"  name="proc_querytype" value="5" onclick=""/>人工确认清缴</span>&nbsp;
								<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="query_windows_open()" >查询</a>
						</div>
				</div>
        		<div style="width:950px;height:200px">
					<table id="proc_settlementgrid1" title='已纳税' style="width:950px;height:200px"></table>
				</div>
				<div style="width:950px;height:200px">
					<table id="proc_settlementgrid2" title='应纳税' style="width:950px;height:200px"></table>
				</div>
				<div style="text-align:center;padding:5px;" > 
					<a id="proc_manualbutton1" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-arrow_flag_red'" onclick="proc_manual(2)" >人工确认欠税</a>
					<a id="proc_manualbutton2"  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" onclick="proc_manual(5)" >人工确认清缴</a>
					<a id="proc_manualbutton3" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-back'" onclick="proc_manual(3)" >回退</a>
					<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="$('#proc_windows').window('close');" >关闭</a>
        		</div> 
        		
        		<div id="query_windows" class="easyui-window" data-options="closed:true,modal:true,title:'查询条件',collapsible:false,minimizable:false,maximizable:false,closable:true">
					<div style="text-align:center;padding:5px;">  
					<table  class="table table-bordered">
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
							<td align="right">计算机编码 ：</td>
							<td>
								<input name="taxpayerid" id="taxpayerid" class="easyui-validatebox" type="text" style="width:200px" />					
							</td>
							<td align="right">纳税人名称 ：</td>
							<td>
								<input name="taxpayername" id="taxpayername" class="easyui-validatebox" type="text" style="width:200px"  />					
							</td>
						</tr>
					</table>
					<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="proc_dodeal()" >查询</a>
					<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="$('#query_windows').window('close');" >关闭</a>
					</div>
				</div>
    </div>  
</body> 
</html>
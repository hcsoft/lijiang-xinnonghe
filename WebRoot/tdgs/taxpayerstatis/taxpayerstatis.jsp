<%@ page contentType="text/html; charset=UTF-8"%>

<!DOCTYPE html>
<%@ include file="/common/inc.jsp"%>
<html>
<head>
	<base target="_self"/>
	<title>纳税人信息统计</title>
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
	var orgdata = new Object;//机关
	var empdata = new Object;//人员
	var taxcodedata = new Object;//税种税目
	var levdatetypedata = new Object;//征期类型
	var locationtypedata = new Object;//坐落地类型
	var belongtownsdata = new Object;//所属村委会
	
	
	function getNameByCode(list,code){
		for(var i=0; i<list.length; i++){
			if (list[i].key == code) return list[i].value;
		}
		return code;
	};
	
	function taxpayer_windows(){
		$('#taxpayer_query_windows').window('open');
	}
	
	function taxpayerquery(){
		
		$('#taxpayer_table').datagrid('loadData',{total:0,rows:[]});
		var p = $('#taxpayer_table').datagrid('getPager');  
		$(p).pagination({   
			showPageList:false,
			pageSize: 15
		});
		var opts = $('#taxpayer_table').datagrid('options');
		opts.url = '/taxpayerstatisservice/gettaxpayerinfo.do';
		$('#taxpayer_table').datagrid('load',{taxorgsupcode:$('#taxorgsupcode').combobox("getValue"),
											  taxorgcode:$('#taxorgcode').combobox("getValue"),
											  taxdeptcode:$('#taxdeptcode').combobox("getValue"),
											  taxmanagercode:$('#taxmanagercode').combobox("getValue"),
											  taxpayerid:$("#taxpayerid").val(),
											  taxpayername:$("#taxpayername").val(),
											  datebegin:$('#datebegin').datebox('getValue'),
											  dateend:$('#dateend').datebox('getValue'),
											  datebegin1:$('#datebegin1').datebox('getValue'),
											  dateend1:$('#dateend1').datebox('getValue'),
											  datebegin2:$('#datebegin2').datebox('getValue'),
											  dateend2:$('#dateend2').datebox('getValue'),
											  state:$('#state').attr("checked")?'1':'0'}); 
		$('#taxpayer_query_windows').window('close');
	}
	
	function land_windows(){
		var rows=$('#taxpayer_table').datagrid("getSelected");
		if(undefined==rows ||  null==rows ){
			$.messager.alert("提示","请选择纳税人信息!");
			return;
		}
		$('#landdetail_windows').window('open');
		$('#landdetail_windows').window('center');
		landquery();
		levinfoquery();
		$('#taxamountinfogrid').datagrid('loadData',{total:0,rows:[]});
	}
	
	function landquery(){
		var rows=$('#taxpayer_table').datagrid("getSelected");
		$('#landdetailgrid').datagrid('loadData',{total:0,rows:[]});
		var p = $('#landdetailgrid').datagrid('getPager');  
		$(p).pagination({   
			showPageList:false,
			pageSize: 15
		});
		var opts = $('#landdetailgrid').datagrid('options');
		opts.url = '/taxpayerstatisservice/getlanddetail.do';
		$('#landdetailgrid').datagrid('load',{
											  taxpayerid:rows.taxpayerid,
											  datebegin:$('#datebegin').datebox('getValue'),
											  dateend:$('#dateend').datebox('getValue')}); 
	}
	
	function taxamountquery(){
		var rows=$('#taxpayer_table').datagrid("getSelected");
		var rows2=$('#landdetailgrid').datagrid("getSelected");
  		$('#taxamountinfogrid').datagrid('loadData',{total:0,rows:[]});
  		var p = $('#taxamountinfogrid').datagrid('getPager');  
  		$(p).pagination({   
  			showPageList:false,
  			pageSize: 15
  		});
  		var opts = $('#taxamountinfogrid').datagrid('options');
  		opts.url = '/taxpayerstatisservice/gettaxamountinfo.do';
  		$('#taxamountinfogrid').datagrid('load',{
  											  estateid:rows2.estateid,
  											  taxpayerid:rows.taxpayerid,
  											  datebegin:$('#datebegin').datebox('getValue'),
											  dateend:$('#dateend').datebox('getValue')});
	}
	
	function levinfoquery(){
		var rows=$('#taxpayer_table').datagrid("getSelected");
		$('#levinfogrid').datagrid('loadData',{total:0,rows:[]});
		var p = $('#levinfogrid').datagrid('getPager');  
		$(p).pagination({   
			showPageList:false,
			pageSize: 15
		});
		var opts = $('#levinfogrid').datagrid('options');
		opts.url = '/taxpayerstatisservice/getlevinfo.do';
		$('#levinfogrid').datagrid('load',{
											  taxpayerid:rows.taxpayerid,
											  datebegin1:$('#datebegin1').datebox('getValue'),
											  dateend1:$('#dateend1').datebox('getValue'),
											  datebegin2:$('#datebegin2').datebox('getValue'),
											  dateend2:$('#dateend2').datebox('getValue')});
	}
	
	$(function(){
		
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
			   data: {codetablename:'COD_TAXORGCODE'},
			   dataType: "json",
			   success: function(jsondata){
				  orgdata= jsondata;
			   }
			});
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
			   data: {codetablename:'COD_TAXCODE'},
			   dataType: "json",
			   success: function(jsondata){
				   taxcodedata= jsondata;
			   }
			});
		$.ajax({
			   type: "post",
				async:false,
			   url: "/ComboxService/getComboxs.do",
			   data: {codetablename:'LEV_LEVYDATETYPE'},
			   dataType: "json",
			   success: function(jsondata){
				   levdatetypedata= jsondata;
			   }
			});
		$.ajax({
			   type: "post",
				async:false,
			   url: "/ComboxService/getComboxs.do",
			   data: {codetablename:'COD_LOCATIONTYPE'},
			   dataType: "json",
			   success: function(jsondata){
				   locationtypedata= jsondata;
			   }
			});
		$.ajax({
			   type: "post",
				async:false,
			   url: "/ComboxService/getComboxs.do",
			   data: {codetablename:'COD_DISTRICT'},
			   dataType: "json",
			   success: function(jsondata){
				   belongtownsdata= jsondata;
			   }
			});
		 
		 $('#taxpayer_table').datagrid({
		        rownumbers:false,//行号   
//		        fitColumns:true,
				height:550,
		        loadMsg:'数据装载中......',    
		        singleSelect:true,//单行选取  
		        pagination:{  
			        pageSize: 15,
					showPageList:false
			    },
		        columns:[[
		    			          {field:'taxpayerid',title:'计算机编码',width:100},   
		    			          {field:'taxpayername',title:'纳税人名称',width:160},
		    			          {field:'landarea',title:'应税土地面积',width:100,align:'right',formatter:function(value){ return Number(value).toFixed(2);}},
		    			          {field:'taxingamount',title:'应缴金额',width:100,align:'right',formatter:function(value){ return Number(value).toFixed(2);}},
		    			          {field:'taxamount',title:'实缴金额',width:100,align:'right',formatter:function(value){ return Number(value).toFixed(2);}},
		    			          {field:'filltaxamount',title:'补缴金额',width:100,align:'right',formatter:function(value){ return Number(value).toFixed(2);}},
		    			          {field:'owingtax',title:'欠税金额',width:100,align:'right',formatter:function(value){ return Number(value).toFixed(2);}},
		    			          {field:'penaltytaxamount',title:'罚款、滞纳金',width:100,align:'right',formatter:function(value){ return Number(value).toFixed(2);}},
		    			          {field:'taxorgsupcode',title:'州市地税机关',width:120, formatter:function(value){return getNameByCode(orgdata,value);}},   
		    			          {field:'taxorgcode',title:'县区地税机关',width:120, formatter:function(value){return getNameByCode(orgdata,value);}},   
		    			          {field:'taxdeptcode',title:'主管地税部门',width:135, formatter:function(value){return getNameByCode(orgdata,value);}}, 
		    			          {field:'taxmanagercode',title:'税收管理员',width:100, formatter:function(value){return getNameByCode(empdata,value);}}
		    			      ]],
			  onDblClickRow:function(rowIndex, rowData){  
		    	  land_windows();
			    }  
		    });  
		 
		 $('#landdetailgrid').datagrid({
		        rownumbers:false,//行号   
		        fitColumns:true,
				height:180,
		        loadMsg:'数据装载中......',    
		        singleSelect:true,//单行选取  
		        pagination:{  
			        pageSize: 15,
					showPageList:false
			    },
		        columns:[[
								  {field:'estateid',title:'土地计算机编码',width:110,hidden:'true'},   
		    			          {field:'estateserialno',title:'宗地编号',width:100}, 
		    			          {field:'belongtowns',title:'所属乡镇',width:120,formatter:function(value){return getNameByCode(belongtownsdata,value);}}, 
		    			          {field:'locationtype',title:'土地等级',width:100,formatter:function(value){return getNameByCode(locationtypedata,value);}}, 
		    			          {field:'detailaddress',title:'详细地址',width:180},
		    			          {field:'landarea',title:'宗地面积',width:100,align:'right',formatter:function(value){ return Number(value).toFixed(2);}},
		    			          {field:'taxarea',title:'应税土地面积',width:100,align:'right',formatter:function(value){ return Number(value).toFixed(2);}},
		    			          {field:'taxingamount',title:'应缴金额',width:100,align:'right',formatter:function(value){ return Number(value).toFixed(2);}}
		    			      ]],
		      onClickRow:function(rowIndex, rowData){  
		    	  taxamountquery();
			    }  
		    });  
		 $('#taxamountinfogrid').datagrid({
		        rownumbers:false,//行号   
		        fitColumns:true,
				height:180,
		        loadMsg:'数据装载中......',    
		        singleSelect:true,//单行选取  
		        pagination:{  
			        pageSize: 15,
					showPageList:false
			    },
		        columns:[[
								  {field:'levydatetype',title:'征期类型',width:90, formatter:function(value){return getNameByCode(levdatetypedata,value);}},
								  {field:'taxdatebegin',title:'税款起日期',width:90},   
		    			          {field:'taxdateend',title:'税款止日期',width:90},
								  {field:'taxcode',title:'税目',width:100, formatter:function(value){return getNameByCode(taxcodedata,value);}}, 
								  {field:'taxingamount',title:'应纳税所得额',width:90,align:'right',formatter:function(value){ return Number(value).toFixed(2);}},
		    			          {field:'taxingquantity',title:'课税数量',width:90,align:'right',formatter:function(value){ return Number(value).toFixed(2);}},
		    			          {field:'taxrate',title:'税率',width:70,align:'right',formatter:function(value){ return Number(value).toFixed(6);}},
		    			          {field:'taxamount',title:'应缴金额',width:90,align:'right',formatter:function(value){ return Number(value).toFixed(2);}}
		    			      ]],
		      onLoadSuccess:function(data){
			      },
		      onClickRow:function(rowIndex, rowData){  
		    		
			    }  
		    });  
		 $('#levinfogrid').datagrid({
		        rownumbers:false,//行号   
//		        fitColumns:true,
				height:180,
		        loadMsg:'数据装载中......',    
		        singleSelect:true,//单行选取  
		        pagination:{  
			        pageSize: 15,
					showPageList:false
			    },
		        columns:[[
								  {field:'taxbillno',title:'税票号码',width:120, formatter:function(value){return getNameByCode(levdatetypedata,value);}},
								  {field:'taxdatebegin',title:'税款起日期',width:90},   
		    			          {field:'taxdateend',title:'税款止日期',width:90},
								  {field:'taxcode',title:'税目',width:100, formatter:function(value){return getNameByCode(taxcodedata,value);}}, 
								  {field:'taxingamount',title:'计税金额',width:90,align:'right',formatter:function(value){ return Number(value).toFixed(2);}},
		    			          {field:'taxingquantity',title:'课税数量',width:90,align:'right',formatter:function(value){ return Number(value).toFixed(2);}},
		    			          {field:'taxrate',title:'税率',width:70,align:'right',formatter:function(value){ return Number(value).toFixed(6);}},
		    			          {field:'taxamountactual',title:'实缴金额',width:90,align:'right',formatter:function(value){ return Number(value).toFixed(2);}},
		    			          {field:'makedate',title:'开票日期',width:90}
		    			      ]],
		      onLoadSuccess:function(data){
			      },
		      onClickRow:function(rowIndex, rowData){  
		    		
			    }  
		    }); 
	})
</script>
</head>

<body class="easyui-layout">   
	<div data-options="region:'center',title:'',split:true" style="width:580px;">
		<div style="background-color: #c9c692;height: 25px;" align="left">		
				<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="taxpayer_windows()" >查询</a>
				<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-viewdetail'" onclick="land_windows()" >明细</a>
		</div>
    	<table id="taxpayer_table"   class="easyui-datagrid"  >  
		</table> 
    </div> 
    <div id="landdetail_windows" class="easyui-window" data-options="title:'纳税信息',closed:true,modal:true,collapsible:false,minimizable:false,maximizable:false,closable:true">
			<table id="landdetailgrid" title="土地信息" style="width:900px"></table>
			<table id="taxamountinfogrid" title="应纳税信息" style="width:900px"></table>
			<table id="levinfogrid" title="已纳税信息" style="width:900px"></table>
	</div> 
    <div id="taxpayer_query_windows" class="easyui-window" data-options="closed:true,modal:true,title:'纳税人查询',collapsible:false,minimizable:false,maximizable:false,closable:true">
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
					<input name="taxpayername" id="taxpayername" class="easyui-validatebox" type="text" style="width:200px" />					
				</td>
			</tr>
			<tr>
				<td align="right">应缴税款起日期 ：</td>
				<td>
					<input type="text" id="datebegin" name="datebegin" class="easyui-datebox" style="width:200px" data-options="validType:'datecheck'"/>				
	
				</td>
				<td align="right">应缴税款止日期 ：</td>
				<td>
					<input type="text" id="dateend" name="dateend" class="easyui-datebox" style="width:200px" data-options="validType:'datecheck'"/>				
				</td>
			</tr>
			<tr>
				<td align="right">大集中税款起日期 ：</td>
				<td>
					<input type="text" id="datebegin1" name="datebegin1" class="easyui-datebox" style="width:200px" data-options="validType:'datecheck'"/>				
	
				</td>
				<td align="right">大集中税款止日期 ：</td>
				<td>
					<input type="text" id="dateend1" name="dateend1" class="easyui-datebox" style="width:200px" data-options="validType:'datecheck'"/>				
				</td>
			</tr>
			<tr>
				<td align="right">开票起日期 ：</td>
				<td>
					<input type="text" id="datebegin2" name="datebegin2" class="easyui-datebox" style="width:200px" data-options="validType:'datecheck'"/>				
	
				</td>
				<td align="right">开票止日期 ：</td>
				<td>
					<input type="text" id="dateend2" name="dateend2" class="easyui-datebox" style="width:200px" data-options="validType:'datecheck'"/>				
				</td>
			</tr>
			<tr>
				<td align="right">是否欠税 ：</td>
				<td>
					<input type="checkbox" id="state" name="state" value ="1" >
				</td>
				<td align="right"></td>
				<td>
				</td>
			</tr>
			
		</table>
		<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="taxpayerquery()" >查询</a>
		<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="$('#taxpayer_query_windows').window('close');" >关闭</a>
		</div>
	</div>
   
</body> 
</html>
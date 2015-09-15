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
	var landsourcedata = new Object;//宗地来源
	var landcertificatetypedata = new Object;//土地证类型
	var locationtypedata = new Object;//坐落地类型
	var belongtownsdata = new Object;//所属村委会
	var taxcodedata = new Object;//税种税目
	var levdatetypedata = new Object;//征期类型
	
	
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
		opts.url = '/taxpayerstatisservice/query.do';
		$('#taxpayer_table').datagrid('load',{taxorgsupcode:$('#taxorgsupcode').combobox("getValue"),
											  taxorgcode:$('#taxorgcode').combobox("getValue"),
											  taxdeptcode:$('#taxdeptcode').combobox("getValue"),
											  taxmanagercode:$('#taxmanagercode').combobox("getValue"),
											  taxpayerid:$("#taxpayerid").val(),
											  taxpayername:$("#taxpayername").val()}); 
		$('#taxpayer_query_windows').window('close');
	}
	
	function landquery(taxpayerid){
		$('#landinfo').datagrid('loadData',{total:0,rows:[]});
		var p = $('#landinfo').datagrid('getPager');  
		$(p).pagination({   
			showPageList:false,
			pageSize: 15
		});
		var opts = $('#landinfo').datagrid('options');
		opts.url = '/taxpayerstatisservice/landquery.do';
		$('#landinfo').datagrid('load',{taxpayerid:taxpayerid}); 
	}
	
	function housequery(taxpayerid){
		$('#houseinfo').datagrid('loadData',{total:0,rows:[]});
		var p = $('#houseinfo').datagrid('getPager');  
		$(p).pagination({   
			showPageList:false,
			pageSize: 15
		});
		var opts = $('#houseinfo').datagrid('options');
		opts.url = '/taxpayerstatisservice/housequery.do';
		$('#houseinfo').datagrid('load',{taxpayerid:taxpayerid}); 
	}
	
	
	function untaxinfoquery(taxpayerid){
		$('#untaxinfo').datagrid('loadData',{total:0,rows:[]});
		var p = $('#untaxinfo').datagrid('getPager');  
		$(p).pagination({   
			showPageList:false,
			pageSize: 15
		});
		var opts = $('#untaxinfo').datagrid('options');
		opts.url = '/taxpayerstatisservice/untaxinfoquery.do';
		$('#untaxinfo').datagrid('load',{taxpayerid:taxpayerid}); 
	}
	
	function taxamountinfoquery(taxpayerid){
		$('#taxamountinfo').datagrid('loadData',{total:0,rows:[]});
		var p = $('#taxamountinfo').datagrid('getPager');  
		$(p).pagination({   
			showPageList:false,
			pageSize: 15
		});
		var opts = $('#taxamountinfo').datagrid('options');
		opts.url = '/taxpayerstatisservice/taxamountinfoquery.do';
		
		
		$('#taxamountinfo').datagrid('load',{taxpayerid:taxpayerid,
											 taxdatebegin:$('#taxdatebegin').datebox('getValue'),
											 taxdateend:$('#taxdateend').datebox('getValue')}); 
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
			   data: {codetablename:'COD_LANDCERTIFICATETYPE'},
			   dataType: "json",
			   success: function(jsondata){
				   landcertificatetypedata= jsondata;
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
		
		
		 $('#landinfo').datagrid({
		        rownumbers:true,//行号   
//		        fitColumns:true,
		        loadMsg:'数据装载中......',   
		        height:546,
		        singleSelect:true,//单行选取  
		        pagination:{  
			        pageSize: 15,
					showPageList:false
			    },
		        columns:[[
		    			          {field:'landsource',title:'宗地来源',width:60,formatter:function(value){return getNameByCode(landsourcedata,value);}},   
		    			          {field:'estateserialno',title:'宗地编号',width:100},   
		    			          {field:'landcertificatetype',title:'土地证类型',width:110,formatter:function(value){return getNameByCode(landcertificatetypedata,value);}},
		    			          {field:'landcertificate',title:'土地证号',width:150},   
		    			          {field:'locationtype',title:'坐落地类型',width:110,formatter:function(value){return getNameByCode(locationtypedata,value);}},   
		    			          {field:'belongtowns',title:'所属村委会',width:70,formatter:function(value){return getNameByCode(belongtownsdata,value);}}, 
		    			          {field:'detailaddress',title:'详细地址',width:170},
		    			          {field:'holddate',title:'实际交付时间',width:80},
		    			          {field:'landmoney',title:'获得土地总价',width:80},
		    			          {field:'landarea',title:'宗地面积',width:70},
		    			          {field:'taxarea',title:'使用权面积',width:70},
		    			          {field:'landunitprice',title:'土地单价',width:70}
		    			      ]],
		        onLoadSuccess:function(data){
					if(data.total== undefined || data.total==0){
//						 $('#landinfo').datagrid('options').url ="";
//						 $.messager.alert("提示","无查询结果!");
					}
			      }, 
			      onDblClickRow:function(rowIndex, rowData){
//			    	  matchwindows();
			      } 
			    
		    }); 
		 
		 $('#houseinfo').datagrid({
		        rownumbers:true,//行号   
//		        fitColumns:true,
		        loadMsg:'数据装载中......',   
		        height:546,
		        singleSelect:true,//单行选取  
		        pagination:{  
			        pageSize: 15,
					showPageList:false
			    },
		        columns:[[
		    			          {field:'housesource',title:'房产来源',width:60},   
		    			          {field:'housecertificatetype',title:'房产证类型',width:100},   
		    			          {field:'housecertificate',title:'房产证号',width:110},
		    			          {field:'housearea',title:'建筑面积',width:150},   
		    			          {field:'usedate',title:'投入使用日期',width:110},   
		    			          {field:'detailaddress',title:'详细地址',width:170}
		    			      ]],
		        onLoadSuccess:function(data){
					if(data.total== undefined || data.total==0){
//						 $('#landinfo').datagrid('options').url ="";
//						 $.messager.alert("提示","无查询结果!");
					}
			      }, 
			      onDblClickRow:function(rowIndex, rowData){
//			    	  matchwindows();
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
		    			          {field:'taxorgsupcode',title:'州市地税机关',width:120, formatter:function(value){return getNameByCode(orgdata,value);}},   
		    			          {field:'taxorgcode',title:'县区地税机关',width:120, formatter:function(value){return getNameByCode(orgdata,value);}},   
		    			          {field:'taxdeptcode',title:'主管地税部门',width:135, formatter:function(value){return getNameByCode(orgdata,value);}}, 
		    			          {field:'taxmanagercode',title:'税收管理员',width:100, formatter:function(value){return getNameByCode(empdata,value);}}
		    			      ]],
		      onLoadSuccess:function(data){
					if(data.total== undefined || data.total==0){
						
					}
			      },
		      onClickRow:function(rowIndex, rowData){  
		    		landquery(rowData.taxpayerid);
		    		housequery(rowData.taxpayerid);
		    		untaxinfoquery(rowData.taxpayerid);
		    		taxamountinfoquery(rowData.taxpayerid);
		    		
			    }  
		    });  
		 
		 $('#untaxinfo').datagrid({
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
//		    			          {field:'detailaddress',title:'详细地址',width:170},
		    			          {field:'taxdatebegin',title:'税款起日期',width:90},   
		    			          {field:'taxdateend',title:'税款止日期',width:90},
		    			          {field:'taxtypecode',title:'税种',width:90, formatter:function(value){return getNameByCode(taxcodedata,value);}},
		    			          {field:'taxcode',title:'税目',width:100, formatter:function(value){return getNameByCode(taxcodedata,value);}},      
		    			          {field:'taxingamount',title:'应纳税所得额',width:90},
		    			          {field:'taxingquantity',title:'课税数量',width:90},
		    			          {field:'taxrate',title:'税率',width:70},
		    			          {field:'taxamount',title:'应缴金额',width:90},
		    			          {field:'taxamountactual',title:'实缴金额',width:90},
		    			          {field:'untax',title:'欠税金额',width:90,formatter: 
		    			        	  function(value,row,index){
		    			        	  	return row.taxamount-row.taxamountactual;
		    			          	  }
								  }
		    			      ]],
		      onClickRow:function(rowIndex, rowData){  
		    	  
			    }  
		    }); 
		 
		 $('#taxamountinfo').datagrid({
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
//		    			          {field:'detailaddress',title:'详细地址',width:170},
								  {field:'levydatetype',title:'征期类型',width:90, formatter:function(value){return getNameByCode(levdatetypedata,value);}}, 
		    			          {field:'taxdatebegin',title:'税款起日期',width:90},   
		    			          {field:'taxdateend',title:'税款止日期',width:90},
		    			          {field:'taxtypecode',title:'税种',width:90, formatter:function(value){return getNameByCode(taxcodedata,value);}},      
		    			          {field:'taxcode',title:'税目',width:100, formatter:function(value){return getNameByCode(taxcodedata,value);}},      
		    			          {field:'taxingamount',title:'应纳税所得额',width:90},
		    			          {field:'taxingquantity',title:'课税数量',width:90},
		    			          {field:'taxrate',title:'税率',width:70},
		    			          {field:'taxamount',title:'应缴金额',width:90},
		    			          {field:'taxamountactual',title:'实缴金额',width:90}
		    			      ]],
		      onClickRow:function(rowIndex, rowData){  
		    	  
			    }  
		    }); 
		 var now=new Date();
		 $('#taxdatebegin').datebox('setValue', now.getFullYear()+'-01-01');
		 $('#taxdateend').datebox('setValue', now.getFullYear()+'-12-31');
	})
</script>
</head>

<body class="easyui-layout">   
	<div data-options="region:'west',title:'',split:true" style="width:580px;">
		<div style="background-color: #c9c692;height: 25px;" align="left">		
				<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="taxpayer_windows()" >查询</a>
		</div>
    	<table id="taxpayer_table"   class="easyui-datagrid"  >  
		</table> 
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
		</table>
		<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="taxpayerquery()" >查询</a>
		<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="$('#taxpayer_query_windows').window('close');" >关闭</a>
		</div>
	</div>
    <div data-options="region:'center',title:''" >
   		<div id="tt" class="easyui-tabs" > 
   			<div title="土地信息" >  
		       	<table id="landinfo"></table>
		    </div> 
		    <div title="房产信息" >  
		       	<table id="houseinfo"></table>
		    </div> 
			<div title="应纳税信息">
				<div style="text-align:left;padding:5px;">  
						<div style="background-color: #c9c692;height: 25px;">		
								<span style="font-size: 12px; color:red; font-weight: bold;">查询条件：</span>
								<span style="font-size: 12px;">税款起日期<input type="text" id="taxdatebegin" name="taxdatebegin" class="easyui-datebox" style="width:100px"/></span>&nbsp;
								<span style="font-size: 12px;">税款止日期<input type="text" id="taxdateend" name="taxdateend" class="easyui-datebox" style="width:100px"/></span>&nbsp;
								<span style="font-size: 12px; color:red; font-weight: bold;">操作：</span>
								<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="taxamountinfoquery($('#taxpayer_table').datagrid('getSelected').taxpayerid)" >查询</a>
						</div>
				</div>
			  	<table id="taxamountinfo"></table>
			</div>
			<div title="欠税信息">
				 <table id="untaxinfo"></table>
			</div>
		</div>
    </div>  
</body> 
</html>
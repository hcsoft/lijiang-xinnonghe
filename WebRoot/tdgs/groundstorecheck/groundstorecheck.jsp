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
	
	<script src="/js/jquery.simplemodal.js"></script>
	<script src="/js/overlay.js"></script>
	<script src="/js/jquery.json-2.2.js"></script>
	<script src="/js/json2.js"></script>
	<script src="/locale/easyui-lang-zh_CN.js"></script>
	<script src="/js/jquery.simplemodal.js"></script>
   	<script src="/js/uploadmodal.js"></script> 
	<script src="/js/common.js"></script>
	<script>
	var selectindex = undefined;
	var selectid = undefined;
	var editIndex = undefined;
	var locationdata = new Object;
	var approvetype;//批复类型
	var opttype;//操作类型
	var type;
	var optmenu = [{
					text:'查询',
					iconCls:'icon-search',
					handler:function(){
						$('#groundstoragequerywindow').window('open');
					}
				},{
					text:'明细查看',
					iconCls:'icon-tip',
					handler:function(){
						var row = $('#groundstoragegrid').datagrid('getSelected');
						if(row){
							$('#groundstorewindow').window('open');
							$('#groundstorewindow').window('refresh', 'groundstore.jsp');
						}
						
					}
				},{
					text:'导出',
					iconCls:'icon-export',
					handler:function(){
						$.messager.confirm('提示', '是否确认导出?', function(r){
							if (r){
								var param='';
								var fields =$('#groundstoragequeryform').serializeArray();
								$.each( fields, function(i, field){
									if(field.value!= ''){
										param=param+field.name+'='+field.value+'&';
									}
								});
								window.open("/GroundStoreCheckServlet/export.do?+'"+param+"'", '',
						           'top=1000,left=2500,width=1,height=1,toolbar=no,menubar=no,location=no');
							}
						});
					}
				},{
					text:'审核',
					id:'check',
					iconCls:'icon-check',
					handler:function(){
						var rows = $('#groundstoragegrid').datagrid('getSelections');
						if(rows.length>0){
							var landstoreids=new Array();
							for(var i=0;i<rows.length;i++){
								landstoreids.push(rows[i].landstoreid);
							}
							$.messager.confirm('提示框', '你确定要审核吗?',function(r){
								if(r){
									Load();
									$.ajax({
										type: "post",
										url: "/GroundStoreCheckServlet/checklandstore.do",
										data: {landstoreids:landstoreids.toString(),opttype:1},
										dataType: "json",
										success: function(jsondata){
											dispalyLoad();
											$.messager.alert('返回消息',jsondata);
											$('#groundstoragegrid').datagrid('reload');
											$('#groundstoragegrid').datagrid('unselectAll');
										},
										error:function (data, status, e){   
											dispalyLoad();
											//alert(JSON.stringify(data));
											$.messager.alert('返回消息',"审核失败！");
										}
									});
								}
							})
						}else{
							$.messager.alert('返回消息',"请选择需要审核的数据！");
						}
					}
				},{
					text:'撤销审核',
					id:'cancelcheck',
					iconCls:'icon-uncheck',
					handler:function(){
						var rows = $('#groundstoragegrid').datagrid('getSelections');
						if(rows.length>0){
							var landstoreids=new Array();
							for(var i=0;i<rows.length;i++){
								landstoreids.push(rows[i].landstoreid);
							}
							$.messager.confirm('提示框', '你确定要撤销审核吗?',function(r){
								if(r){
									Load();
									$.ajax({
										type: "post",
										url: "/GroundStoreCheckServlet/checklandstore.do",
										data: {landstoreids:landstoreids.toString(),opttype:0},
										dataType: "json",
										success: function(jsondata){
											dispalyLoad();
											$.messager.alert('返回消息',jsondata);
											$('#groundstoragegrid').datagrid('reload');
											$('#groundstoragegrid').datagrid('unselectAll');
										},
										error:function (data, status, e){  
											dispalyLoad();
											 $.messager.alert('返回消息',"撤销审核失败！");
										}
									});
								}
							})
						}else{
							$.messager.alert('返回消息',"请选择需要撤销审核的数据！");
						}
					}
				}];
	var optmenu2 = [{
					text:'查询',
					iconCls:'icon-search',
					handler:function(){
						$('#groundstoragequerywindow').window('open');
					}
				},{
					text:'明细查看',
					iconCls:'icon-tip',
					handler:function(){
						var row = $('#groundstoragegrid').datagrid('getSelected');
						if(row){
							$('#groundstorewindow').window('open');
							$('#groundstorewindow').window('refresh', 'groundstore.jsp');
						}
						
					}
				},{
					text:'导出',
					iconCls:'icon-export',
					handler:function(){
						$.messager.confirm('提示', '是否确认导出?', function(r){
							if (r){
								var param='';
								var fields =$('#groundstoragequeryform').serializeArray();
								$.each( fields, function(i, field){
									if(field.value!= ''){
										param=param+field.name+'='+field.value+'&';
									}
								});
								window.open("/GroundStoreCheckServlet/export.do?+'"+param+"'", '',
						           'top=1000,left=2500,width=1,height=1,toolbar=no,menubar=no,location=no');
							}
						});
					}
				},{
					text:'终审',
					id:'finalcheck',
					iconCls:'icon-check',
					handler:function(){
						var rows = $('#groundstoragegrid').datagrid('getSelections');
						if(rows.length>0){
							var landstoreids=new Array();
							for(var i=0;i<rows.length;i++){
								landstoreids.push(rows[i].landstoreid);
							}
							$.messager.confirm('提示框', '你确定要终审吗?',function(r){
								if(r){
									Load();
									$.ajax({
										type: "post",
										url: "/GroundStoreCheckServlet/finalchecklandstore.do",
										data: {landstoreids:landstoreids.toString(),opttype:1},
										dataType: "json",
										success: function(jsondata){
											dispalyLoad();
											$.messager.alert('返回消息',jsondata);
											$('#groundstoragegrid').datagrid('reload');
											$('#groundstoragegrid').datagrid('unselectAll');
										},
										error:function (data, status, e){   
											dispalyLoad();
											//alert(JSON.stringify(data));
											$.messager.alert('返回消息',"终审失败！");
										}
									});
								}
							})
						}else{
							$.messager.alert('返回消息',"请选择需要终审的数据！");
						}
					}
				},{
					text:'撤销终审',
					id:'cancelfinalcheck',
					iconCls:'icon-uncheck',
					handler:function(){
						var rows = $('#groundstoragegrid').datagrid('getSelections');
						if(rows.length>0){
							var landstoreids=new Array();
							for(var i=0;i<rows.length;i++){
								landstoreids.push(rows[i].landstoreid);
							}
							$.messager.confirm('提示框', '你确定要撤销终审吗?',function(r){
								if(r){
									Load();
									$.ajax({
										type: "post",
										url: "/GroundStoreCheckServlet/finalchecklandstore.do",
										data: {landstoreids:landstoreids.toString(),opttype:0},
										dataType: "json",
										success: function(jsondata){
											dispalyLoad();
											$.messager.alert('返回消息',jsondata);
											$('#groundstoragegrid').datagrid('reload');
											$('#groundstoragegrid').datagrid('unselectAll');
										},
										error:function (data, status, e){  
											dispalyLoad();
											 $.messager.alert('返回消息',"撤销终审失败！");
										}
									});
								}
							})
						}else{
							$.messager.alert('返回消息',"请选择需要撤销终审的数据！");
						}
					}
				}];
	var querymenu = [{
					text:'查询',
					iconCls:'icon-search',
					handler:function(){
						$('#groundstoragequerywindow').window('open');
					}
				},{
					text:'明细查看',
					iconCls:'icon-tip',
					handler:function(){
						var row = $('#groundstoragegrid').datagrid('getSelected');
						if(row){
							$('#groundstorewindow').window('open');
							$('#groundstorewindow').window('refresh', 'groundstore.jsp');
						}
						
					}
				},{
					text:'导出',
					iconCls:'icon-export',
					handler:function(){
						$.messager.confirm('提示', '是否确认导出?', function(r){
							if (r){
								var param='';
								var fields =$('#groundstoragequeryform').serializeArray();
								$.each( fields, function(i, field){
									if(field.value!= ''){
										param=param+field.name+'='+field.value+'&';
									}
								});
								window.open("/GroundStoreCheckServlet/export.do?+'"+param+"'", '',
						           'top=1000,left=2500,width=1,height=1,toolbar=no,menubar=no,location=no');
							}
						});
					}
				}];
	var querystatedata = [{   
		"key":"0",   
		"value":"未审核"  
	},{   
		"key":"1",   
		"value":"已审核"  
	},{   
		"key":"5",   
		"value":"已终审"  
	},{   
		"key":"3",   
		"value":"已出让"  
	}];
	var optstatedata = [{   
		"key":"0",   
		"value":"未审核"  
	},{   
		"key":"1",   
		"value":"已审核"  
	},{   
		"key":"5",   
		"value":"已终审"  
	}];
	$(function(){
		var paraString = location.search;     
		var paras = paraString.split("&");   
		type = paras[0].substr(paras[0].indexOf("=") + 1);
		if(type=='query'){
			$('#groundstoragegrid').datagrid({
				toolbar:querymenu,
				singleSelect:true,
				columns:[[
					{field:'landstoreid',hidden:true,width:18},
					{field:'state',hidden:true,width:18},
					{field:'businesscode',hidden:true,width:18},
					{field:'businessnumber',hidden:true,width:18},
					{field:'a',title:'附件管理',formatter:uploadbutton,width:100,align:'center'},
					{field:'taxpayerid',title:'计算机编码',width:80,align:'left'},
					{field:'taxpayername',title:'纳税人名称',width:200,align:'left'},
					{field:'approvenumberlevel',title:'批复级别',formatter:function(value,row,index){
										if(value=='01'){
											return '国家';
										}
										if(value=='02'){
											return '省';
										}
										if(value=='03'){
											return '市';
										}
										if(value=='04'){
											return '县';
										}
									},width:100,align:'left'},
					{field:'approvenumber',title:'批复文号',width:100,align:'left'},
					{field:'approvedates',title:'批复日期',width:60,align:'center'},
					{field:'areatotal',title:'批复总面积(平方米)',width:100,formatter:formatnumber,align:'right'},
					{field:'areasell',title:'已出让面积(平方米)',width:100,formatter:formatnumber,align:'right'},
					{field:'areaplough',title:'农用地面积(平方米)',width:100,formatter:formatnumber,align:'right'},
					{field:'areabuild',title:'建设用地面积(平方米)',width:100,formatter:formatnumber,align:'right'},
					{field:'areauseless',title:'未利用地面积(平方米)',width:100,formatter:formatnumber,align:'right'}
				]]
			});
			$('#state').combobox({   
				data:querystatedata,   
				valueField:'key',   
				textField:'value'  
			});  
		}
		if(type=='check'){
			$('#groundstoragegrid').datagrid({
				toolbar:optmenu,
				singleSelect:false,
				columns:[[
					{field:'landstoreid',hidden:true,width:18},
					{field:'state',hidden:true,width:18},
					{field:'businesscode',hidden:true,width:18},
					{field:'businessnumber',hidden:true,width:18},
					{checkbox:'true'},
					{field:'a',title:'附件管理',formatter:uploadbutton,width:100,align:'center'},
					{field:'taxpayerid',title:'计算机编码',width:80,align:'left'},
					{field:'taxpayername',title:'纳税人名称',width:200,align:'left'},
					{field:'approvenumberlevel',title:'批复级别',formatter:function(value,row,index){
										if(value=='01'){
											return '国家';
										}
										if(value=='02'){
											return '省';
										}
										if(value=='03'){
											return '市';
										}
										if(value=='04'){
											return '县';
										}
									},width:100,align:'left'},
					{field:'approvenumber',title:'批复文号',width:100,align:'left'},
					{field:'approvedates',title:'批复日期',width:60,align:'center'},
					{field:'areatotal',title:'批复总面积(平方米)',width:100,formatter:formatnumber,align:'right'},
					{field:'areasell',title:'已出让面积(平方米)',width:100,formatter:formatnumber,align:'right'},
					{field:'areaplough',title:'农用地面积(平方米)',width:100,formatter:formatnumber,align:'right'},
					{field:'areabuild',title:'建设用地面积(平方米)',width:100,formatter:formatnumber,align:'right'},
					{field:'areauseless',title:'未利用地面积(平方米)',width:100,formatter:formatnumber,align:'right'}
				]]
			});
			$('#state').combobox({   
				data:optstatedata,   
				valueField:'key',   
				textField:'value'  
			});  
			$('#state').combobox('setValue','0');
		}
		if(type=='finalcheck'){
			$('#groundstoragegrid').datagrid({
				toolbar:optmenu2,
				singleSelect:false,
				columns:[[
					{field:'landstoreid',hidden:true,width:18},
					{field:'state',hidden:true,width:18},
					{field:'businesscode',hidden:true,width:18},
					{field:'businessnumber',hidden:true,width:18},
					{checkbox:'true'},
					{field:'a',title:'附件管理',formatter:uploadbutton,width:100,align:'center'},
					{field:'taxpayerid',title:'计算机编码',width:80,align:'left'},
					{field:'taxpayername',title:'纳税人名称',width:200,align:'left'},
					{field:'approvenumberlevel',title:'批复级别',formatter:function(value,row,index){
										if(value=='01'){
											return '国家';
										}
										if(value=='02'){
											return '省';
										}
										if(value=='03'){
											return '市';
										}
										if(value=='04'){
											return '县';
										}
									},width:100,align:'left'},
					{field:'approvenumber',title:'批复文号',width:100,align:'left'},
					{field:'approvedates',title:'批复日期',width:60,align:'center'},
					{field:'areatotal',title:'批复总面积(平方米)',width:100,formatter:formatnumber,align:'right'},
					{field:'areasell',title:'已出让面积(平方米)',width:100,formatter:formatnumber,align:'right'},
					{field:'areaplough',title:'农用地面积(平方米)',width:100,formatter:formatnumber,align:'right'},
					{field:'areabuild',title:'建设用地面积(平方米)',width:100,formatter:formatnumber,align:'right'},
					{field:'areauseless',title:'未利用地面积(平方米)',width:100,formatter:formatnumber,align:'right'}
				]]
			});
			$('#state').combobox({   
				data:optstatedata,   
				valueField:'key',   
				textField:'value'  
			});  
			$('#state').combobox('setValue','1');
		}
		$.ajax({
			   type: "post",
				async:false,
			   url: "/InitGroundServlet/getlocationComboxs.do",
			   data: {codetablename:'COD_DISTRICT'},
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
					var managerflag = '<%=com.szgr.framework.authority.datarights.SystemUserAccessor.getInstance().getTaxmanageflag()%>';
					var leaderflag = '<%=com.szgr.framework.authority.datarights.SystemUserAccessor.getInstance().getLeaderflag()%>';
					if(orgclass=='04'){
						if(leaderflag =='01' && type =='finalcheck'){
							$('#taxdeptcode').combobox("setValue",taxdeptcode);
						}else{
							$('#taxdeptcode').combobox("setValue",taxdeptcode);
							$('#taxmanagercode').combobox("setValue",taxempcode);
						}
						query();
					}
	           }
	   });
			$('#groundstoragegrid').datagrid({
				fitColumns:'true',
				maximized:'true',
				pagination:true,
				idField:'landstoreid',
				view:$.extend({},$.fn.datagrid.defaults.view,{
						onAfterRender: function(target){
										$('#groundstoragegrid').datagrid('clearSelections');
									} 
						}),
				//toolbar:,
				onCheck:function(rowIndex,rowData){
					selectid = rowData.landstoreid;
				},
				onClickRow:function(index){
					var row = $('#groundstoragegrid').datagrid('getSelected');
					$('#check').linkbutton('enable');
					$('#cancelcheck').linkbutton('enable');
					$('#finalcheck').linkbutton('enable');
					$('#cancelfinalcheck').linkbutton('enable');
					if(row.state=='0'){
						$('#cancelcheck').linkbutton('disable');
						$('#finalcheck').linkbutton('disable');
						$('#cancelfinalcheck').linkbutton('disable');
					}
					if(row.state=='1'){
						$('#check').linkbutton('disable');
						$('#cancelfinalcheck').linkbutton('disable');
					}
					if(row.state=='5'){
						$('#check').linkbutton('disable');
						$('#cancelcheck').linkbutton('disable');
						$('#finalcheck').linkbutton('disable');
					}
				},
				onSelectAll:function(rows){
					var row = rows[0];
					$('#check').linkbutton('enable');
					$('#cancelcheck').linkbutton('enable');
					if(row.state=='0'){
						$('#cancelcheck').linkbutton('disable');
					}
					if(row.state=='1'){
						$('#check').linkbutton('disable');
						
					}
				}
			});
			
			var p = $('#groundstoragegrid').datagrid('getPager');  
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
									$('#groundstoragegrid').datagrid('selectRecord',selectid);
									var row = $('#groundstoragegrid').datagrid('getSelected');
									var index = $('#groundstoragegrid').datagrid('getRowIndex',row);
									var lastindex = $('#groundstoragegrid').datagrid('getData')['total']-1;
									if(index > lastindex){
										$('#groundstoragegrid').datagrid('unselectRow',index);
									}
								}else{
									selectindex = undefined;
								}
							} 
				});


		function query(){
			$('#groundstoragegrid').datagrid('unselectAll');
			var params = {};
			var fields =$('#groundstoragequeryform').serializeArray();
			$.each( fields, function(i, field){
				params[field.name] = field.value;
			}); 
			//$('#groundstoragegrid').datagrid({
			//	url:'/InitGroundServlet/getlandstoreinfo.do'
			//});
			$('#groundstoragegrid').datagrid('loadData',{total:0,rows:[]});
			var opts = $('#groundstoragegrid').datagrid('options');
			opts.url = '/GroundStoreCheckServlet/getgroundstoreinfo.do';
			$('#groundstoragegrid').datagrid('load',params); 
			var p = $('#groundstoragegrid').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false,
				pageSize: 15
			});
			$('#groundstoragegrid').datagrid('unselectAll');
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
				   $('#groundstoragegrid').datagrid('reload');
				  $('#groundstorageeditwindow').window('close');
				  $.messager.alert('返回消息','保存成功！');
			   }
			});
		}

		function refreshLandstoredetail(){
			var row = $('#groundstoragegrid').datagrid('getSelected');
			if(row && selectindex != undefined){
				$.ajax({
				   type: "post",
				   url: "/InitGroundServlet/getlandstoresub.do",
				   data: {landstoreid:row.landstoreid},
				   dataType: "json",
				   success: function(jsondata){
					  $('#groundstoragedetailgrid').datagrid('loadData',jsondata);
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
	<form id="groundstorageform" method="post">
		<div title="批复信息" data-options="">
					
						<table id="groundstoragegrid" style="overflow:auto;" 
						data-options="iconCls:'icon-edit',idField:'itemid'" rownumbers="true"> 
							<thead>
								<!-- <tr>
									<th data-options="field:'landstoreid',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'state',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'businesscode',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'businessnumber',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="checkbox:true"></th>
									<th data-options="field:'a',width:100,align:'center',formatter:uploadbutton">附件管理</th>
									<th data-options="field:'taxpayerid',width:80,align:'center',editor:{type:'validatebox'}">计算机编码</th>
									<th data-options="field:'taxpayername',width:200,align:'center',editor:{type:'validatebox'}">纳税人名称</th>
									<th data-options="field:'approvenumberlevel',width:100,align:'center',formatter:function(value,row,index){
										if(value=='01'){
											return '国家';
										}
										if(value=='02'){
											return '省';
										}
										if(value=='03'){
											return '市';
										}
										if(value=='04'){
											return '县';
										}
									},
									editor:{type:'validatebox'}">批复级别</th>
									<th data-options="field:'approvenumber',width:100,align:'center',editor:{type:'validatebox'}">批复文号</th>
									<th data-options="field:'approvedates',width:60,align:'center',editor:{type:'validatebox'}">批复日期</th>
									<th data-options="field:'areatotal',width:100,align:'center',editor:{type:'validatebox'}">批复总面积(平方米)</th>
									<th data-options="field:'areasell',width:100,align:'center',editor:{type:'validatebox'}">已出让面积(平方米)</th>
									<th data-options="field:'areaplough',width:100,align:'center',editor:{type:'validatebox'}">农用地面积(平方米)</th>
									<th data-options="field:'areabuild',width:100,align:'center',editor:{type:'validatebox'}">建设用地面积(平方米)</th>
									<th data-options="field:'areauseless',width:100,align:'center',editor:{type:'validatebox'}">未利用地面积(平方米)</th>
									<th data-options="field:'a',width:100,align:'center',formatter:uploadbutton">附件管理</th>
								</tr>
															</thead> -->
						</table>
					
			</div>
	</form>
	<div id="groundstoragequerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地收储批复查询',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:300px;">
		<div class="easyui-panel" title="" style="width:900px;">
			<form id="groundstoragequeryform" method="post">
				<table id="narjcxx" width="100%"  class="table table-bordered">
					<tr>
						<td align="right">州市地税机关：</td>
						<td>
							<input class="easyui-combobox" name="taxorgsupcode" id="taxorgsupcode" style="width:250px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">县区地税机关：</td>
						<td>
							<input class="easyui-combobox" name="taxorgcode" id="taxorgcode" style="width:250px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
					</tr>
					<tr>
						<td align="right">主管地税部门：</td>
						<td>
							<input class="easyui-combobox" name="taxdeptcode" id="taxdeptcode" style="width:250px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">税收管理员：</td>
						<td>
							<input class="easyui-combobox" name="taxmanagercode" id="taxmanagercode" style="width:250px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
					</tr>
					<tr>
						<td align="right">计算机编码：</td>
						<td>
							<input id="querytaxpayerid" class="easyui-validatebox" type="text" style="width:250px" name="querytaxpayerid" onkeydown="if(event.keyCode==13)spelltaxpayerid(this)"/>
						</td>
						<td align="right">纳税人名称：</td>
						<td>
							<input id="querytaxpayername" class="easyui-validatebox" type="text" style="width:250px" name="querytaxpayername"/>
						</td>
					</tr>
					<tr>
						<td align="right">批复文号：</td>
						<td>
							<input id="queryapprovenumber" class="easyui-validatebox" type="text" style="width:250px" name="queryapprovenumber"/>
						</td>
						<td align="right">审核状态：</td>
						<td>
							<input id="state" class="easyui-combobox" type="text" style="width:200px" name="state"/>
							<!-- <select id="state" class="easyui-combobox" name="state" style="width:200px"  editable="false">
								<option value=""></option>
								<option value="0">未审核</option>
								<option value="1">已审核</option>
								<option value="5">已终审</option>
							</select> -->
						</td>
					</tr>
					<tr>
						<td align="right">批复时间：</td>
						<td colspan="3">
							<input id="approvedatebegin" class="easyui-datebox" name="approvedatebegin"/>
						至
							<input id="approvedateend" class="easyui-datebox"  name="approvedateend"/>
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
	<table id="groundstoragedetailgrid"></table>
	</div> -->
	<!-- <div id="reginfowindow" class="easyui-window" data-options="closed:true,modal:true,title:'纳税人登记信息',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:620px;height:470px;">
	</div> -->
	<div id="groundstorewindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地批复',collapsible:false,minimizable:false,maximizable:false,closable:true,resizable:false" style="width:960px;height:500px;">
	</div>
	<div id="attachmentwindow" class="easyui-window" data-options="closed:true,modal:true,title:'附件管理',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:500px;">
	</div>
	<div id="dd"></div>
	<!-- <div id="addtdxxwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地信息',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:500px;">
	</div> -->

</body>
</html>
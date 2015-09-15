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
	var locationdata = new Object;
	var taxdata = new Object;
	var taxtypecodedata = new Array();
	var taxcodedata = new Array();
	var groundsourcedata = new Object;
	var housesourcedata = new Object;
	var taxorgdata = new Object;
	var taxempdata = new Object;
	var deratetypedata = new Object;
	var key;
	var type;
	var datatype;
	var optmenu = [{
					text:'查询',
					iconCls:'icon-search',
					handler:function(){
						$('#deratequerywindow').window('open');
					}
				},{
					text:'导出',
					iconCls:'icon-export',
					handler:function(){
						$.messager.confirm('提示', '是否确认导出?', function(r){
							if (r){
								var param='';
								var fields =$('#deratequeryform').serializeArray();
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
//						var row = $('#derategrid').datagrid('getSelected');
//						if(row){
//							$('#groundstorewindow').window('open');
//							$('#groundstorewindow').window('refresh', 'groundstore.jsp');
//						}
//					}
//				},
					{
					text:'审核',
					id:'check',
					iconCls:'icon-check',
					handler:function(){
						var row = $('#derategrid').datagrid('getSelected');
						if(row){
							if(row.datatype=='0' || row.datatype==null){
								$.messager.alert('返回消息',"期初采集的数据不能在该模块进行审核！");
								return;
							}
							$.messager.confirm('提示框', '你确定要审核吗?',function(r){
								if(r){
									Load();
									$.ajax({
										type: "post",
										url: "/DerateCheckServlet/check.do",
										data: {taxreduceid:row.taxreduceid},
										dataType: "json",
										success: function(jsondata){
											dispalyLoad();
											$.messager.alert('返回消息',jsondata.message);
											$('#derategrid').datagrid('reload');
											$('#derategrid').datagrid('unselectAll');
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
						var row = $('#derategrid').datagrid('getSelected');
						if(row){
							if(row.datatype=='0' || row.datatype==null){
								$.messager.alert('返回消息',"期初采集的数据不能在该模块进行撤销审核！");
								return;
							}
							$.messager.confirm('提示框', '你确定要撤销审核吗?',function(r){
								if(r){
									Load();
									$.ajax({
										type: "post",
										url: "/DerateCheckServlet/uncheck.do",
										data: {taxreduceid:row.taxreduceid},
										dataType: "json",
										success: function(jsondata){
											dispalyLoad();
											$.messager.alert('返回消息',jsondata.message);
											$('#derategrid').datagrid('reload');
											$('#derategrid').datagrid('unselectAll');
										},
										error:function (data, status, e){   
											dispalyLoad();
											//alert(JSON.stringify(data));
											$.messager.alert('返回消息',"撤销审核失败！");
										}
									});
								}
							})
						}else{
							$.messager.alert('返回消息',"请选择需要审核的数据！");
						}
					}
				}];
	var optmenu2 = [{
					text:'查询',
					iconCls:'icon-search',
					handler:function(){
						$('#deratequerywindow').window('open');
					}
				},{
					text:'导出',
					iconCls:'icon-export',
					handler:function(){
						$.messager.confirm('提示', '是否确认导出?', function(r){
							if (r){
								var param='';
								var fields =$('#deratequeryform').serializeArray();
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
//						var row = $('#derategrid').datagrid('getSelected');
//						if(row){
//							$('#groundstorewindow').window('open');
//							$('#groundstorewindow').window('refresh', 'groundstore.jsp');
//						}
//					}
//				},
					{
					text:'终审',
					id:'finalcheck',
					iconCls:'icon-check',
					handler:function(){
						var row = $('#derategrid').datagrid('getSelected');
						if(row){
							if(row.datatype=='0' || row.datatype==null){
								$.messager.alert('返回消息',"期初采集的数据不能在该模块进行终审！");
								return;
							}
							$.messager.confirm('提示框', '你确定要终审吗?',function(r){
								if(r){
									Load();
									$.ajax({
										type: "post",
										url: "/DerateCheckServlet/finalcheck.do",
										data: {taxreduceid:row.taxreduceid},
										dataType: "json",
										success: function(jsondata){
											dispalyLoad();
											$.messager.alert('返回消息',jsondata.message);
											$('#derategrid').datagrid('reload');
											$('#derategrid').datagrid('unselectAll');
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
						var row = $('#derategrid').datagrid('getSelected');
						if(row){
							if(row.datatype=='0' || row.datatype==null){
								$.messager.alert('返回消息',"期初采集的数据不能撤销终审！");
								return;
							}
							$.messager.confirm('提示框', '你确定要撤销终审吗?',function(r){
								if(r){
									Load();
									$.ajax({
										type: "post",
										url: "/DerateCheckServlet/unfinalcheck.do",
										data: {taxreduceid:row.taxreduceid},
										dataType: "json",
										success: function(jsondata){
											dispalyLoad();
											$.messager.alert('返回消息',jsondata.message);
											$('#derategrid').datagrid('reload');
											$('#derategrid').datagrid('unselectAll');
										},
										error:function (data, status, e){   
											dispalyLoad();
											//alert(JSON.stringify(data));
											$.messager.alert('返回消息',"撤销终审失败！");
										}
									});
								}
							})
						}else{
							$.messager.alert('返回消息',"请选择需要审核的数据！");
						}
					}
				}];
	var querymenu = [{
					text:'查询',
					iconCls:'icon-search',
					handler:function(){
						$('#deratequerywindow').window('open');
					}
				},{
					text:'导出',
					iconCls:'icon-export',
					handler:function(){
						$.messager.confirm('提示', '是否确认导出?', function(r){
							if (r){
								var param='';
								var fields =$('#deratequeryform').serializeArray();
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
				}];
	$(function(){
		//取得url参数
		var paraString = location.search;     
		var paras = paraString.split("&");   
		type = paras[0].substr(paras[0].indexOf("=") + 1);
		if(type=='query'){
			$('#derategrid').datagrid({toolbar:querymenu});
			datatype = "'1'";
		}
		if(type=='check'){
			$('#derategrid').datagrid({toolbar:optmenu});
			$('#state').combobox('setValue','1');
			datatype = "'1'";
		}
		if(type=='finalcheck'){
			$('#derategrid').datagrid({toolbar:optmenu2});
			$('#state').combobox('setValue','2');
			datatype = "'1'";
		}
		$.ajax({
		   type: "post",
			async:false,
		   url: "/InitGroundServlet/getlocationComboxs.do",
		   data: {codetablename:'COD_DISTRICT'},
		   dataType: "json",
		   success: function(jsondata){
			  locationdata= jsondata;
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
		   data: {codetablename:'COD_DERATETYPECODE'},
		   dataType: "json",
		   success: function(jsondata){
			  deratetypedata= jsondata;
		   }
		});
		$.ajax({
		   type: "post",
			async:false,
		   url: "/ComboxService/getComboxs.do",
		   data: {codetablename:'COD_TAXCODE'},
		   dataType: "json",
		   success: function(jsondata){
			   for (var i = 0; i < jsondata.length; i++) {
				  if((jsondata[i].key.substring(0,2) =='20' || jsondata[i].key.substring(0,2) =='12' || jsondata[i].key.substring(0,2) =='10') &&(jsondata[i].key.indexOf("98")<0 && jsondata[i].key.indexOf("99")<0)){
					  if(jsondata[i].key.length==2){
						var data = {}; 
						data.key=jsondata[i].key;
						data.value=jsondata[i].value;
						taxtypecodedata.push(data);
					  }else{
						var data = {}; 
						data.key=jsondata[i].key;
						data.value=jsondata[i].value;
						taxcodedata.push(data);
					  }
				   }
			  }
			$('#taxtypecode').combobox({   
				data:taxtypecodedata,   
				valueField:'key',   
				textField:'value'  
			});
			$('#taxcode').combobox({   
				data:taxcodedata,   
				valueField:'key',   
				textField:'value'  
			});
			  taxdata= jsondata;
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
		$.ajax({
		   type: "post",
			async:false,
		   url: "/ComboxService/getComboxs.do",
		   data: {codetablename:'COD_HOUSESOURCECODE'},
		   dataType: "json",
		   success: function(jsondata){
			  housesourcedata= jsondata;
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
					setTimeout("query()",100);
	           }
	   });
			$('#derategrid').datagrid({
				//fitColumns:'true',
				//fit: true, 
				columns:[[
					{field:'businesscode',hidden:true,width:18},
					{field:'businessnumber',hidden:true,width:18},
					{field:'taxreduceid',hidden:true,width:18},
					{field:'reducetype',hidden:true,width:18},
					{field:'datatype',hidden:true,width:18},
					{field:'infoname',title:'相关信息',formatter:addLinkLandInfo,width:60,align:'center'},
					{field:'a',title:'附件管理',formatter:uploadbutton,width:100,align:'center'},
					{field:'taxpayerid',title:'计算机编码',width:100,align:'center'},
					{field:'taxpayername',title:'纳税人名称',width:100,align:'left'},
					{field:'taxtypecode',title:'税种',formatter:function(value,row,index){
										for(var i=0; i<taxdata.length; i++){
											if (taxdata[i].key == value) return taxdata[i].value;
										}
										return value;
									},width:100,align:'left'},
					{field:'taxcode',title:'税目',formatter:function(value,row,index){
										for(var i=0; i<taxdata.length; i++){
											if (taxdata[i].key == value) return taxdata[i].value;
										}
										return value;
									},width:100,align:'left'},
					{field:'reducebegindates',title:'减免起日期',width:100,align:'center'},
					{field:'reduceenddates',title:'减免止日期',width:100,align:'center'},
					{field:'approvenumber',title:'减免批准文号',width:100,align:'left'},
					{field:'approveunit',title:'批准机关',formatter:function(value,row,index){
										for(var i=0; i<taxorgdata.length; i++){
											if (taxorgdata[i].key == value) return taxorgdata[i].value;
										}
										return value;
									},width:100,align:'left'},
					{field:'reduceclass',title:'减免类型',formatter:function(value,row,index){
										for(var i=0; i<deratetypedata.length; i++){
											if (deratetypedata[i].key == value) return deratetypedata[i].value;
										}
										return value;
									},width:100,align:'left'},
					{field:'reducenum',title:'减免面积(原值)',formatter:formatnumber,width:100,align:'right'},
					{field:'taxamount	',title:'减免税额',formatter:formatnumber,width:100,align:'right'},
					{field:'reducereason',title:'减免原因',width:100,align:'left'},
					{field:'policybasis',title:'减免政策依据',width:100,align:'left'},
					{field:'inputperson',title:'录入人员',formatter:function(value,row,index){
										for(var i=0; i<taxempdata.length; i++){
											if (taxempdata[i].key == value) return taxempdata[i].value;
										}
										return value;
									},width:100,align:'left'},
					{field:'inputdates',title:'录入时间',width:100,align:'center'},
					{field:'checkperson',title:'审核人员',formatter:function(value,row,index){
										for(var i=0; i<taxempdata.length; i++){
											if (taxempdata[i].key == value) return taxempdata[i].value;
										}
										return value;
									},width:100,align:'left'},
					{field:'checkdates',title:'审核时间',width:100,align:'left'},
					{field:'taxdeptcode',title:'主管地税部门',formatter:function(value,row,index){
										for(var i=0; i<taxorgdata.length; i++){
											if (taxorgdata[i].key == value) return taxorgdata[i].value;
										}
										return value;
									},width:100,align:'left'},
					{field:'taxmanagercode',title:'税收管理员',formatter:function(value,row,index){
										for(var i=0; i<taxempdata.length; i++){
											if (taxempdata[i].key == value) return taxempdata[i].value;
										}
										return value;
									},width:100,align:'left'}
				]],
				maximized:'true',
				pagination:true,
				view:$.extend({},$.fn.datagrid.defaults.view,{
						onAfterRender: function(target){
										$('#derategrid').datagrid('clearSelections');
									} 
						}),
				//toolbar:,
				onCheck:function(rowIndex,rowData){
					selectid = rowData.landstoreid;
				},
				onClickRow:function(index){
					var row = $('#derategrid').datagrid('getSelected');
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
			var p = $('#derategrid').datagrid('getPager');  
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
									$('#derategrid').datagrid('selectRecord',selectid);
									var row = $('#derategrid').datagrid('getSelected');
									var index = $('#derategrid').datagrid('getRowIndex',row);
									var lastindex = $('#derategrid').datagrid('getData')['total']-1;
									if(index > lastindex){
										$('#derategrid').datagrid('unselectRow',index);
									}
								}else{
									selectindex = undefined;
								}
							} 
				});


		function query(){
			$('#derategrid').datagrid('unselectAll');
			var params = {};
			var fields =$('#deratequeryform').serializeArray();
			$.each( fields, function(i, field){
				params[field.name] = field.value;
			}); 
			params.datatype = datatype;
			//$('#derategrid').datagrid({
			//	url:'/InitGroundServlet/getlandstoreinfo.do'
			//});
			$('#derategrid').datagrid('loadData',{total:0,rows:[]});
			var opts = $('#derategrid').datagrid('options');
			opts.url = '/DerateCheckServlet/getderateinfo.do';
			$('#derategrid').datagrid('load',params); 
			var p = $('#derategrid').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false,
				pageSize: 15
			});
			$('#derategrid').datagrid('unselectAll');
			$('#deratequerywindow').window('close');
			
		}

		function save(){
			var params = {};
			var fields =$('#derateeditform').serializeArray();
			$.each( fields, function(i, field){
				params[field.name] = field.value;
			}); 
			$.ajax({
			   type: "post",
			   url: "/InitGroundServlet/savelandstoremain.do",
			   data: params,
			   dataType: "json",
			   success: function(jsondata){
				   $('#derategrid').datagrid('reload');
				  $('#derateeditwindow').window('close');
				  $.messager.alert('返回消息','保存成功！');
			   }
			});
		}

		function refreshLandstoredetail(){
			var row = $('#derategrid').datagrid('getSelected');
			if(row && selectindex != undefined){
				$.ajax({
				   type: "post",
				   url: "/InitGroundServlet/getlandstoresub.do",
				   data: {landstoreid:row.landstoreid},
				   dataType: "json",
				   success: function(jsondata){
					  $('#deratedetailgrid').datagrid('loadData',jsondata);
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
	function addLinkLandInfo(value,row,index){
		var result = "";
		result = "<a href='#' onclick=\"showinfo(\'"+row.id+"\',\'"+row.reducetype+"\')\">"+value+"</a>";
		return result;
	}
	function showinfo(id,reducetype){
		key = id;
		if(reducetype=='0'){ //批复
			$('#sotrewindow').window('open');
			$('#sotrewindow').window('refresh', 'store.jsp');
		}
		if(reducetype=='1'){ //土地
			$('#groundwindow').window('open');
			$('#groundwindow').window('refresh', 'ground.jsp');
		}
		if(reducetype=='2'){ //房产
			$('#housewindow').window('open');
			$('#housewindow').window('refresh', 'house.jsp');
		}
	}
	</script>
</head>
<body>
	<form id="derateform" method="post">
		<div title="减免信息" data-options="">
					
						<table id="derategrid" style="overflow:visible" 
						data-options="iconCls:'icon-edit',singleSelect:true" rownumbers="true"> 
							<thead>
								
							</thead>
						</table>
					
			</div>
	</form>
	<div id="deratequerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'减免税查询',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:300px;">
		<div class="easyui-panel" title="" style="width:900px;">
			<form id="deratequeryform" method="post">
				<table id="deratetable" width="100%"  class="table table-bordered">
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
							<input id="taxpayerid" class="easyui-validatebox" type="text" style="width:250px" name="taxpayerid" onkeydown="if(event.keyCode==13)spelltaxpayerid(this)"/>
						</td>
						<td align="right">纳税人名称：</td>
						<td>
							<input id="taxpayername" class="easyui-validatebox" type="text" style="width:250px" name="taxpayername"/>
						</td>
					</tr>
					<tr>
						<td align="right">税种：</td>
						<td>
							<input id="taxtypecode" name="taxtypecode" style="width:200px;" class="easyui-combobox" editable='false' data-options="
								onChange:function(newValue, oldValue){
								if(newValue != ''){
									var newarray = new Array();
									for (var i = 0; i < taxcodedata.length; i++) {
										if(taxcodedata[i].key.indexOf(newValue)==0){
											var rowdata = {};
											rowdata.key = taxcodedata[i].key;
											rowdata.value = taxcodedata[i].value;
											newarray.push(rowdata);
										}
									};
									$('#taxcode').combobox({
										data : newarray,
										valueField:'key',
										textField:'value'
									});
								}
							}" />
						</td>
						<td align="right">税目：</td>
						<td>
							<input id="taxcode" name="taxcode" style="width:200px;" class="easyui-combobox" editable='false' data-options="
							valueField: 'key',
							textField: 'value',
							data:taxcodedata" />				
						</td>
					</tr>
					<tr>
						<td align="right">审核状态：</td>
						<td>
							<select id="state" class="easyui-combobox" style="width:250px" name="state" editable="false">
								<option value="">全部</option>
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
					</tr>
				</table>
			</form>
			<div style="text-align:center;padding:5px;">  
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="query()">查询</a>
			</div>
		</div>
	</div>
	
	<div id="groundwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地信息',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:400px;">
	</div>
	<div id="housewindow" class="easyui-window" data-options="closed:true,modal:true,title:'房产信息',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:400px;">
	</div>
	<div id="sotrewindow" class="easyui-window" data-options="closed:true,modal:true,title:'批复信息',collapsible:false,minimizable:false,maximizable:false,closable:true,resizable:false" style="width:960px;height:500px;">
	</div>
	
</body>
</html>
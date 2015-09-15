<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
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
	<link rel="stylesheet" href="<%=spath%>/css/tablen.css"/>
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
	<script src="/js/common.js"></script>

	<script>
	var locationdata = new Object;//所属乡镇缓存
	var belongtowns = undefined;//坐落地类型
	var belongtocountry = undefined;//所属乡镇
	var detailaddress = undefined;//详细地址
	var maxgroundarea = 0.00;//可使用面积
	var businessdata = new Array();
	var groundusedata = new Array();
	var opttype ='';
	var businesstype;
	var taxpayerid;
	var taxpayername;
	var landstoreid;
	var landstoresubid;
	var targetestateid;
	var busid;
	var landarea;
	var	lanssourcedata;
	var lesseecode='03';
	var lesseediv;
	var landcertificatetype_data_all = new Array();
	var landcertificatetype_data_part = new Array();
	var editIndex = undefined;
	var orgdata = new Object;
	var empdata = new Object;
	
	Date.prototype.format = function (format) 
	{
		var o = {
			"M+": this.getMonth() + 1, //month 
			"d+": this.getDate(),    //day 
			"h+": this.getHours(),   //hour 
			"m+": this.getMinutes(), //minute 
			"s+": this.getSeconds(), //second 
			"q+": Math.floor((this.getMonth() + 3) / 3),  //quarter 
			"S": this.getMilliseconds() //millisecond 
		}
		if (/(y+)/.test(format)) format = format.replace(RegExp.$1,
		(this.getFullYear() + "").substr(4 - RegExp.$1.length));
		for (var k in o) if (new RegExp("(" + k + ")").test(format))
			format = format.replace(RegExp.$1,
		  RegExp.$1.length == 1 ? o[k] :
			("00" + o[k]).substr(("" + o[k]).length));
		return format;
	}

	$.extend($.fn.datagrid.defaults.editors, {
	datebox : {
		init : function(container, options) {
			var input = $('<input type="text">').appendTo(container);
			input.datebox(options);
			return input;
		},
		destroy : function(target) {
			$(target).datebox('destroy');
		},
		getValue : function(target) {
			return $(target).datebox('getValue');//获得旧值
		},
		setValue : function(target, value) {
			console.info(formatDatebox(value));
			$(target).datebox('setValue', formatDatebox(value));//设置新值的日期格式
		},
		resize : function(target, width) {
			$(target).datebox('resize', width);
		}
	}
});
	
	$(function(){
		//取得url参数
		var paraString = location.search;     
		var paras = paraString.split("&");   
		businesstype = paras[0].substr(paras[0].indexOf("=") + 1);   
		/*
		if(businesstype == '' ){
			businesstype ="'11','12'";
			$('#groundlandstore').datagrid({toolbar:menu11});
		}
		if(businesstype == '11' ){
			$('#groundlandstore').datagrid({toolbar: menu11});
		}
		if(businesstype == '12' ){
			$('#groundlandstore').datagrid({toolbar:menu12});
		}
		*/
		$('#groundregisterform #countrytown').combobox({
		   onSelect:function(data){
		      CommonUtils.getCacheCodeFromTable('COD_DISTRICT','id',
		                                 'name','#groundregisterform #belongtowns'," and parentid = '"+data.key+"' ");
		   }
	   	});
		CommonUtils.getCacheCodeFromTable('COD_DISTRICT','id',
			                                 'name','#groundregisterform #countrytown'," and parentid = '530122' ");
		
		$('#reginfogrid1').datagrid({
			fitColumns:'true',
			maximized:'true',
			pagination:{  
		        pageSize: 10,
				showPageList:false
		    },
		    onDblClickRow:function(rowIndex, rowData){
		    	reginput();
		    },
		    onLoadSuccess:function(data){  
				$(this).datagrid('selectRow',0)
		    }
		});
		$('#reginfogrid2').datagrid({
			fitColumns:'true',
			maximized:'true',
			pagination:{  
		        pageSize: 10,
				showPageList:false
		    },
		    onDblClickRow:function(rowIndex, rowData){
		    	lessorinput();
		    },
		    onLoadSuccess:function(data){  
				$(this).datagrid('selectRow',0)
		    }
		});
		
		$.ajax({
			   type: "post",
				async:false,
			   url: "/ComboxService/getComboxs.do",
			   data: {codetablename:'COD_GROUNDUSECODE'},
			   dataType: "json",
			   success: function(jsondata){
				   //alert(JSON.stringify(jsondata));
				  groundusedata= jsondata;
			   }
			});
		$.ajax({
			   type: "post",
				async:false,
			   url: "/ComboxService/getComboxs.do",
			   data: {codetablename:'COD_TAXORGCODE'},
			   dataType: "json",
			   success: function(jsondata){
				   //alert(JSON.stringify(jsondata));
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
				   //alert(JSON.stringify(jsondata));
				  empdata= jsondata;
			   }
			});
		$.ajax({
			   type: "post",
				async:false,
			   url: "/InitGroundServlet/getlocationComboxs.do",
			   data: {},
			   dataType: "json",
			   success: function(jsondata){
				  locationdata= jsondata;
			   }
			});
		$.ajax({
			   type: "post",
				async:false,
			   url: "/ComboxService/getComboxs.do",
			   data: {codetablename:'COD_BUSINESS'},
			   dataType: "json",
			   success: function(jsondata){
				   //alert(JSON.stringify(jsondata));
				  businessdata= jsondata;
			   }
		});
		
		
		$.ajax({
			   type: "post",
				async:false,
			   url: "/ComboxService/getComboxs.do",
			   data: {codetablename:'COD_GROUNDSOURCECODE'},
			   dataType: "json",
			   success: function(jsondata){
				   //alert(JSON.stringify(jsondata));
				  lanssourcedata= jsondata;
			   }
		});
		/*
		$.ajax({
			   type: "post",
				async:false,
			   url: "/ComboxService/getComboxs.do",
			   data: {codetablename:'COD_LANDCERTIFICATETYPE'},
			   dataType: "json",
			   success: function(jsondata){
				 jsondata.pop();
				 
				 landcertificatetype_data_part= obj;
			   }
		});
		*/
		var jsondata1='[{"value":"","key":"","desc":null,"keyvalue":""},{"value":"国有土地","key":"01","desc":null,"keyvalue":"01-国有土地"},{"value":"集体土地","key":"02","desc":null,"keyvalue":"02-集体土地"}]'
		var obj1 =  eval('(' + jsondata1 + ')');
		landcertificatetype_data_part= obj1;
		
		$.ajax({
			   type: "post",
				async:false,
			   url: "/ComboxService/getComboxs.do",
			   data: {codetablename:'COD_LANDCERTIFICATETYPE'},
			   dataType: "json",
			   success: function(jsondata){
				  landcertificatetype_data_all= jsondata;
				 
			   }
		});
		$('#landcertificatetype').combobox({valueField: 'key',textField: 'value',data:landcertificatetype_data_all});
		var regex = new RegExp("\"","g");  
		$.ajax({
			   type: "get",
			   url: "/soption/taxOrgOptionInit.do",
			   data: {"moduleAuth":"15","emptype":"30"},
			   dataType: "json",
			   success: function(jsondata){
				   $('#registertaxorgsupcode').combobox({
						data : jsondata.taxSupOrgOptionJsonArray,
                        valueField:'key',
                        textField:'keyvalue',
						onSelect:function(n,o){  	
							$.ajax({
								   type: "get",
								   url: "/soption/taxOrgOptionBySup.do",
								   data: {"taxSuperOrgCode":n.key},
								   dataType: "json",
								   success: function(jsondata){
										//$.messager.alert('返回消息',JSON.stringify(jsondata));
									   $('#registertaxorgcode').combobox({
											data : jsondata.taxOrgOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});
									   $('#registertaxdeptcode').combobox({
											data : jsondata.taxDeptOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});		
									   $('#registertaxmanagercode').combobox({
											data : jsondata.taxEmpOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});											
								   }
							});
						}
						
					});
					if(jsondata.taxSupOrgOptionJsonArray.length == 1){
						$('#registertaxorgsupcode').combobox("setValue",JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key).replace(regex, ""));
						$('#registertaxorgsupcode').combobox("setText",JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].keyvalue).replace(regex, ""));
					}

				   $('#registertaxorgcode').combobox({
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
									   $('#registertaxdeptcode').combobox({
											data : jsondata.taxDeptOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});		
									   $('#registertaxmanagercode').combobox({
											data : jsondata.taxEmpOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});											
									
								   }
							});
						} 
					});
					if(jsondata.taxOrgOptionJsonArray.length == 1){
						//$.messager.alert('返回消息',JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
						$('#registertaxorgcode').combobox("setValue",JSON.stringify(jsondata.taxOrgOptionJsonArray[0].key).replace(regex, ""));
						$('#registertaxorgcode').combobox("setText",JSON.stringify(jsondata.taxOrgOptionJsonArray[0].keyvalue).replace(regex, ""));
					}

				   $('#registertaxdeptcode').combobox({
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
									   $('#registertaxmanagercode').combobox({
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
						$('#registertaxdeptcode').combobox("setValue",JSON.stringify(jsondata.taxDeptOptionJsonArray[0].key).replace(regex, ""));
						$('#registertaxdeptcode').combobox("setText",JSON.stringify(jsondata.taxDeptOptionJsonArray[0].keyvalue).replace(regex, ""));
					}



				   $('#registertaxmanagercode').combobox({
						data : jsondata.taxEmpOptionJsonArray,
                        valueField:'key',
                        textField:'keyvalue'
					});
					//$.messager.alert('返回消息',JSON.stringify(jsondata.taxSupOrgOptionJsonArray));
					//$.messager.alert('返回消息',JSON.stringify(jsondata.taxOrgOption));
					//$.messager.alert('返回消息',JSON.stringify(jsondata.taxDeptOption));
					//$.messager.alert('返回消息',JSON.stringify(jsondata.taxEmpOption));
					//$.messager.alert('返回消息',jsondata.funcMenuJson);
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
			
			$('#groundregistergrid').datagrid({
					//fitColumns:'true',
					maximized:'true',
					pagination:true,
					idField:'ownerid',
					view: $.extend({},$.fn.datagrid.defaults.view,{
							onAfterRender: function(target){
											$('#groundregistergrid').datagrid('clearSelections');//页面重新加载时取消所有选中行
											} 
							}),
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
									var params = {};
									var param='';
									var fields =$('#groundqueryform').serializeArray();
									$.each( fields, function(i, field){
										//params[field.name] = field.value;
										//alert('field.name:'+field.name);
										//alert('field.value:'+field.value);
										if(field.value!=''){
											
											param=param+field.name+'='+field.value+'&';
										}
										
									}); 
									param = param + "businesscode="+businesstype;
									window.open("/GroundUserightServlet/exportReg.do?"+param, '',
									   'top=100,left=250,width=600,height=100,toolbar=no,menubar=no,location=no');  
									//CommonUtils.downloadFile("/GroundUserightServlet/exportBusi.do?date="+new Date(),param); 
								}
								});
							}
						
					},{
						text:'新增登记',
						iconCls:'icon-add',
						handler:function(){
							$('#groundAddwindow').window('open');
							$('#groundregisterform').form('clear');
							$('#landmoney').val('0.00'); 
							$('#landarea').val('0.00'); 
							$('#landtype').html('土地证类型：');
							$('#tdzj').html('土地总价（元）:');
							$('#rentgrid').datagrid('loadData',{total:0,rows:[]});
						}
					},{
						id:'edit',
						text:'修改',
						iconCls:'icon-edit',
						handler:function(){
							
							
							var row = $('#groundregistergrid').datagrid('getSelected');
							if (row){
								$('#groundAddwindow').window('open');
								$('#groundregisterform').form('clear');
								$.ajax({
										   type: "post",
										   url: '/GroundUserightServlet/queryGroundRegisterinfoForEdit.do',
										   data: {estateid :row.estateid},
										   dataType: "json",
										   success: function(jsondata){
										   	//alert($.toJSON(jsondata));
										   		var belongtowns = jsondata.belongtowns ;
										   	
										   	$('#groundregisterform').form('load',jsondata);	
										   	var landsourcecode = $('#groundregisterform #landsource').combobox('getValue');
											if(landsourcecode==lesseecode)	{
												$('#lesseediv').show();
												$('#lessorinfodiv').show();
												$('#rentinfodiv').show();
												$('#landtype').html('土地类型：');
												$('#tdzjtr').hide();
											}else{
												$('#lesseediv').hide();
												$('#lessorinfodiv').hide();
												$('#rentinfodiv').hide();
												$('#landtype').html('土地证类型：');
												$('#tdzjtr').show();
												$('#tdzj').html('土地总价（元）：');
											}									   	
										   	$('#registertaxorgsupcode').combobox('setValue',jsondata.taxorgsupcode);
										   	
											$('#registertaxorgcode').combobox('setValue',jsondata.taxorgcode);
											$('#registertaxorgcode').combobox('setText',jsondata.taxorgcode_name);
											
											$('#registertaxdeptcode').combobox('setValue',jsondata.taxdeptcode);
											$('#registertaxdeptcode').combobox('setText',jsondata.taxdeptcode_name);
											
											$('#registertaxmanagercode').combobox('setValue',jsondata.taxmanagercode);										
											$('#registertaxmanagercode').combobox('setText',jsondata.taxmanagercode_name);
											
											$('#registertaxorgsupcode').combobox('disable');
											$('#registertaxorgcode').combobox('disable');
											$('#registertaxdeptcode').combobox('disable');
											$('#registertaxmanagercode').combobox('disable');
											
											$('#countrytown').combobox('setValue',belongtowns.substring(0,9));
											$('#belongtowns').combobox('setValue',belongtowns);
											$("#estateid").val(jsondata.estateid);
											if(jsondata.rentdata != null && jsondata.rentdata.length>0){
												
												$('#rentgrid').datagrid('loadData',jsondata.rentdata);
											}
										   }
								});
							}else{
								$.messager.alert('提示','请选择土地登记信息!');
							}
						}
					},{
						id:'cancel',
						text:'删除',
						iconCls:'icon-remove',
						handler:function(){
							//只有初始状态的可以删除
							var row = $('#groundregistergrid').datagrid('getSelected');
							if(row){
								$.messager.confirm('提示','确定删除吗?',function(r){
									if (r) {
										var state =  row.state;
										if (state!='0'){
											$.messager.alert('提示','只有初始状态的可以删除!');
											return;
										}
										var estateid = row.estateid;
										$.ajax({
										   type: "post",
										   url: "/GroundUserightServlet/delGroundRegisterinfo.do",
										   data: {estateid:estateid},
										   dataType: "json",
										   success: function(jsondata){
											  $('#groundregistergrid').datagrid('reload');
											  $.messager.alert('返回消息',jsondata);
										   }
										});
									}
								});
							}else{
								$.messager.alert('提示','请选择要删除的土地登记信息!');
							}
						}
					}					
					/*,{
						id:'check',
						text:'终审',
						iconCls:'icon-check',
						handler:function(){
							var row = $('#groundregistergrid').datagrid('getSelected');
							if (row){
								var params = {};
								params.estateid=row.estateid;
								params.busid=row.busid;
								params.businesscode = '32';
								//alert($.toJSON(params));
								//	return;
								$.ajax({
										   type: "post",
										   url: "/GroundUserightServlet/finalCheckGroundBusi.do",
										   data: params,
										   dataType: "json",
										   success: function(jsondata){
											  $('#groundregistergrid').datagrid('reload');
											  $.messager.alert('返回消息',jsondata);
										   },error:function (data, status, e){   
												$.messager.alert('返回消息','终审失败!');   
											}  
								});
							}else{
									$.messager.alert('提示','请选择要终审的土地信息!');
							}
						}
					},{
						id:'uncheck',
						text:'撤销终审',
						iconCls:'icon-uncheck',
						handler:function(){
							var row = $('#groundregistergrid').datagrid('getSelected');
							if (row){
								var params = {};
								params.estateid=row.estateid;
								params.busid=row.busid;
								params.businesscode = businesstype;
								params.businessnumber = row.businessnumber;
								//alert($.toJSON(params));
								//	return;
								$.ajax({
										   type: "post",
										   url: "/GroundUserightServlet/unfinalcheck.do",
										   data: params,
										   dataType: "json",
										   success: function(jsondata){
											  $('#groundregistergrid').datagrid('reload');
											  $.messager.alert('返回消息',jsondata);
										   },error:function (data, status, e){   
												$.messager.alert('返回消息','撤销终审失败!');   
											}  
								});
							}else{
								$.messager.alert('提示','请选择要撤销的土地信息!');
							}
						}
					}*/
					],
					onClickRow:function(index){
						var row = $('#groundregistergrid').datagrid('getSelected');
						$('#edit').linkbutton('enable');
						$('#cancel').linkbutton('enable');
						$('#check').linkbutton('enable');
						$('#uncheck').linkbutton('enable');
						$('#print').linkbutton('enable');
						
						if(row.state=='0'){
							$('#uncheck').linkbutton('disable');
							$('#check').linkbutton('disable');
						}
						if(row.state=='1'){
							$('#edit').linkbutton('disable');
							$('#cancel').linkbutton('disable');
							$('#uncheck').linkbutton('disable');
						}
						if( row.state=='3'){
							$('#edit').linkbutton('disable');
							$('#cancel').linkbutton('disable');
							$('#check').linkbutton('disable');
						}
						if( row.state=='2'){
							$('#edit').linkbutton('disable');
							$('#cancel').linkbutton('disable');
							$('#check').linkbutton('disable');
							$('#uncheck').linkbutton('disable');
						}
					}
				});
			var p = $('#groundregistergrid').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
				});
			$('#taxpayerid').blur(function(){
				var taxpayerid = $("#taxpayerid").val();
				if (taxpayerid!=''){
					queryTaxpayerid();
					$('#registertaxorgsupcode').combobox('disable');
					$('#registertaxorgcode').combobox('disable');
					$('#registertaxdeptcode').combobox('disable');
					$('#registertaxmanagercode').combobox('disable');
				}else{
					$('#registertaxorgsupcode').combobox('enable');
					$('#registertaxorgcode').combobox('enable');
					$('#registertaxdeptcode').combobox('enable');
					$('#registertaxmanagercode').combobox('enable');
					$('#registertaxorgsupcode').combobox('setValue','');
					$('#registertaxorgcode').combobox('setValue','');
					$('#registertaxdeptcode').combobox('setValue','');
					$('#registertaxmanagercode').combobox('setValue','');
				}
			});	
			$('#lessorid').blur(function(){
				var lessorid = $("#lessorid").val();
				if (lessorid!=''){
					querylessor();
					
				}
			});	
			$('#rentgrid').datagrid({
					fitColumns:'true',
					maximized:'true',
					toolbar:[{
						text:'新增',
						iconCls:'icon-add',
						handler:function(){
							if (endEditing()){
								endEdits();
								$('#rentgrid').datagrid('appendRow',{
								limitbegin:'',
								limitend:'',
								transmoney:'0.00',
								holddate:''
								});
								editIndex = $('#rentgrid').datagrid('getRows').length-1;  
								$('#rentgrid').datagrid('selectRow', editIndex)  
										.datagrid('beginEdit', editIndex);
							} 
						}
					},{
						text:'修改',
						iconCls:'icon-edit',
						handler:function(){
							if(endEditing()){
								var row = $('#rentgrid').datagrid('getSelected');
								var index = $('#rentgrid').datagrid('getRowIndex',row);
								$('#rentgrid').datagrid('beginEdit',index);
								editIndex = index;
							}
						}
					},{
						text:'删除',
						iconCls:'icon-remove',
						handler:function(){
							var index = $('#rentgrid').datagrid('getRowIndex',$('#rentgrid').datagrid('getSelected'));
							$('#rentgrid').datagrid('deleteRow', index);    
							editIndex = undefined;
						}
					}]
			});
		
			$('#lesseediv').hide();
			$('#lessorinfodiv').hide();
			
				
			setTimeout('query()',100);
			$('#groundregistergrid').datagrid('reload'); 
			
		});
		//土地登记查询
		function query(){
			var params = {};
			var fields =$('#groundqueryform').serializeArray();
			$.each( fields, function(i, field){
				params[field.name] = field.value;
			}); 
			$('#groundregistergrid').datagrid('loadData',{total:0,rows:[]});
			var opts = $('#groundregistergrid').datagrid('options');
			opts.url = '/GroundUserightServlet/queryGroundRegisterInfo.do';
			$('#groundregistergrid').datagrid('load',params); 
			var p = $('#groundregistergrid').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false,
				pageSize: 15
			});
			$('#groundquerywindow').window('close');
		}
		/*
		function businessquery(){
			var params = {};
			var fields =$('#groundsellqueryform').serializeArray();
			$.each( fields, function(i, field){
				params[field.name] = field.value;
			}); 
			alert('businesstype:'+businesstype);
			params.businesscode = businesstype;
			$('#groundregistergrid').datagrid('loadData',{total:0,rows:[]});
			var opts = $('#groundregistergrid').datagrid('options');
			opts.url = '/GroundCheckServlet/getgroundbusinessinfo.do';
			$('#groundregistergrid').datagrid('load',params); 
			var p = $('#groundregistergrid').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false,
				pageSize: 15
			});
			$('#groundregistergrid').datagrid('unselectAll');
			$('#groundsellquerywindow').window('close');
			
		}
		*/
		/*
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
				   $('#groundlandstore').datagrid('reload');
				  $('#groundstorageeditwindow').window('close');
				  $.messager.alert('返回消息','保存成功！');
			   }
			});
		}
		*/
		/*
		function refreshLandstoredetail(){
			var row = $('#groundlandstore').datagrid('getSelected');
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
	*/
	function format(row){
		for(var i=0; i<locationdata.length; i++){
			if (locationdata[i].key == row) return locationdata[i].value;
		}
		return row;
	};
	function formatbusiness(row){
		for(var i=0; i<businessdata.length; i++){
			if (businessdata[i].key == row) return businessdata[i].value;
		}
		return row;
	}
	function formatlandsource(row){
		for(var i=0; i<lanssourcedata.length; i++){
			if (lanssourcedata[i].key == row) return lanssourcedata[i].value;
		}
		return row;
	}
	function formatgrounduse(row){
		for(var i=0; i<groundusedata.length; i++){
			if (groundusedata[i].key == row) return groundusedata[i].value;
		}
		return row;
	}

	function formatDatebox(value) {
            if (value == null || value == '') {
                return '';
            }
            var dt;
            if (value instanceof Date) {
                dt = value;
            } else {

                dt = new Date(value);

            }

            return dt.format("yyyy-MM-dd"); //扩展的Date的format方法(上述插件实现)
        }
	function endEditing(){  
		if (editIndex == undefined){return true}  
		if ($('#rentgrid').datagrid('validateRow', editIndex)){
			$('#rentgrid').datagrid('endEdit', editIndex);
			editIndex = undefined;  
			return true;  
		} else {  
			alert('出租信息中有必填字段不能为空！');
			return false;  
		}  
	}
	function endEdits(){
		var rows = $('#rentgrid').datagrid('getRows');
		for ( var i = 0; i < rows.length; i++) {
			$('#rentgrid').datagrid('endEdit', i);
		}
		$('#rentgrid').datagrid('acceptChanges');
	}
	function querylessor() {
		var params = {};
		params.taxpayerid = $('#lessorid').val();
		params.taxpayername = '';
		$.ajax({
			type: "post",
			url: "/GroundUserightServlet/getreginfo1.do",
			data: params,
			dataType: "json",
			success: function(jsondata){
			
				if (jsondata.total==1){ 
					$('#lessortaxpayername').val(jsondata.rows[0].taxpayername);
					$('#registertaxorgsupcode').combobox('setValue',jsondata.rows[0].taxorgsupcode);
					$('#registertaxorgsupcode').combobox('setText',jsondata.rows[0].taxorgsupcodename);
					$('#registertaxorgcode').combobox('setValue',jsondata.rows[0].taxorgcode);
					$('#registertaxorgcode').combobox('setText',jsondata.rows[0].taxorgcodename);
					
					$('#registertaxdeptcode').combobox('setValue',jsondata.rows[0].taxdeptcode);
					$('#registertaxdeptcode').combobox('setText',jsondata.rows[0].taxdeptcodename);
					
					$('#registertaxmanagercode').combobox('setValue',jsondata.rows[0].taxmanagercode);
					$('#registertaxmanagercode').combobox('setText',jsondata.rows[0].taxmanagercodename);
				}
				if (jsondata.total==0){
					$.messager.alert('返回消息',"不存在该纳税人!");
					$('#taxpayername').val('');
					$('#taxpayerid').val('');
				
				}
				if (jsondata.total>1){
					lessorquery()
				}
			} 
		});
	}
	function lessorquery (){
		$('#choiceLessorWin').window('open');
		var params = {};
		params.taxpayerid = $('#taxpayerid').val();
		params.taxpayername = $('#taxpayername').val();
		var rp = $('#reginfogrid1').datagrid('getPager');  
		$(rp).pagination({   
			showPageList:false,
			pageSize: 10
		});
		var opts = $('#reginfogrid1').datagrid('options');
		opts.url = '/GroundUserightServlet/getreginfo2.do';
		$('#reginfogrid1').datagrid('load',params); 
	}
	
	function queryTaxpayerid(){
		var params = {};
		params.taxpayerid = $('#taxpayerid').val();
		params.taxpayername = '';
		$.ajax({
			type: "post",
			url: "/GroundUserightServlet/getreginfo1.do",
			data: params,
			dataType: "json",
			success: function(jsondata){
			
				if (jsondata.total==1){ 
					$('#taxpayername').val(jsondata.rows[0].taxpayername);
					$('#registertaxorgsupcode').combobox('setValue',jsondata.rows[0].taxorgsupcode);
					$('#registertaxorgsupcode').combobox('setText',jsondata.rows[0].taxorgsupcodename);
					$('#registertaxorgcode').combobox('setValue',jsondata.rows[0].taxorgcode);
					$('#registertaxorgcode').combobox('setText',jsondata.rows[0].taxorgcodename);
					
					$('#registertaxdeptcode').combobox('setValue',jsondata.rows[0].taxdeptcode);
					$('#registertaxdeptcode').combobox('setText',jsondata.rows[0].taxdeptcodename);
					
					$('#registertaxmanagercode').combobox('setValue',jsondata.rows[0].taxmanagercode);
					$('#registertaxmanagercode').combobox('setText',jsondata.rows[0].taxmanagercodename);
				}
				if (jsondata.total==0){
					$.messager.alert('返回消息',"不存在该纳税人!");
					$('#taxpayername').val('');
					$('#taxpayerid').val('');
					$('#registertaxorgsupcode').combobox('setValue','');
					$('#registertaxorgcode').combobox('setValue','');
					$('#registertaxdeptcode').combobox('setValue','');
					$('#registertaxmanagercode').combobox('setValue','');
				}
				if (jsondata.total>1){
					regquery()
				}
			} 
		});
	}
	function regquery(){
		$('#choiceTaxpayerWin').window('open');
		var params = {};
		params.taxpayerid = $('#taxpayerid').val();
		params.taxpayername = $('#taxpayername').val();
		var rp = $('#reginfogrid1').datagrid('getPager');  
		$(rp).pagination({   
			showPageList:false,
			pageSize: 10
		});
		var opts = $('#reginfogrid1').datagrid('options');
		opts.url = '/GroundUserightServlet/getreginfo2.do';
		$('#reginfogrid1').datagrid('load',params); 
		
	}
	function reginput(){
		var row=$('#reginfogrid1').datagrid("getSelected");
		$('#taxpayerid').val(row.taxpayerid);
		$('#taxpayername').val(row.taxpayername);
		$('#registertaxorgsupcode').combobox('setValue',row.taxorgsupcode);
		$('#registertaxorgsupcode').combobox('setText',row.taxorgsupcodename);
		
		$('#registertaxorgcode').combobox('setValue',row.taxorgcode);
		$('#registertaxorgcode').combobox('setText',row.taxorgcodename);
		
		$('#registertaxdeptcode').combobox('setValue',row.taxdeptcode);
		$('#registertaxdeptcode').combobox('setText',row.taxdeptcodename);
		
		$('#registertaxmanagercode').combobox('setValue',row.taxmanagercode);
		$('#registertaxmanagercode').combobox('setText',row.taxmanagercodename);
		$('#registertaxorgsupcode').combobox('disable');
		$('#registertaxorgcode').combobox('disable');
		$('#registertaxdeptcode').combobox('disable');
		$('#registertaxmanagercode').combobox('disable');
		$('#choiceTaxpayerWin').window('close');
	}
	
	function lessorinput(){
		var row=$('#reginfogrid2').datagrid("getSelected");
		$('#lessorid').val(row.taxpayerid);
		$('#lessortaxpayername').val(row.taxpayername);
	}
	
	function Load() {  
	    $("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: $(window).height() }).appendTo("#groundAddwindow");  
	    $("<div class=\"datagrid-mask-msg\"></div>").html("正在操作，请稍候。。。").appendTo("#groundAddwindow").css({ display: "block", left: ($('#groundAddwindow').outerWidth(true) - 190) / 2, top: ($('#groundAddwindow').height() - 45) / 2 });  
	}  
  	  
	function dispalyLoad() {  
	    $(".datagrid-mask").remove();  
	    $(".datagrid-mask-msg").remove();  
	} 
	
	function businesssave(){
	
		 if($('#taxpayername').val()==''){
				$.messager.alert('返回消息','纳税人名称不能为空或校验有误！');
				$('#taxpayername')[0].focus();
			return;
		}
		
		
		
		if( $('#groundregisterform  #landsource').combo('getValue')==''){
			$.messager.alert('返回消息','土地来源不能为空！');
			return;
		}
		if( $('#purpose').combo('getValue')==''){
			$.messager.alert('返回消息','土地用途不能为空！');
			return;
		}
		
		var landsourcecode = $('#groundregisterform #landsource').combobox('getValue');
		
		if (landsourcecode==lesseecode){
			if($('#lessortaxpayername').val()==''){
				$.messager.alert('返回消息','出租人名称不能为空或校验有误！');
				return;
			}
			var taxpayerid =$('#taxpayerid').val();
			var taxpayername =$('#taxpayername').val();
			var lessorid =$('#lessorid').val();
			var lessortaxpayername =$('#lessortaxpayername').val();
			if ( ((taxpayerid!=''&&lessorid!='')&&(taxpayerid==lessorid)) ||taxpayername==lessortaxpayername){
				$.messager.alert('返回消息','纳税人名称和出租人不能相同！');
					return;
			}
		}
		
		if($('#holddates').datebox('getValue')==''){
			$.messager.alert('返回消息','取得土地时间不能为空或校验有误！');
			return;
		}
		
		
		
		
		var dateb = $('#datebegins').datebox('getValue');
		if(dateb==''){
			$.messager.alert('返回消息','使用年限起不能为空或起校验有误！');
			return;
		}
		var datee = $('#dateends').datebox('getValue');
		if(datee==''){
			$.messager.alert('返回消息','使用年限止不能为空或止校验有误！');
			return;
		}
		if (datee<=dateb){
			$.messager.alert('返回消息','使用年限止校验有误！');
			return;
		}
		if($('#locationtype').combo('getValue')==''){
			$.messager.alert('返回消息','土地坐落地类型不能为空！');
			return;
		}
		if($('#countrytown').combo('getValue')==''){
			$.messager.alert('返回消息','房产所属乡镇不能为空！');
			return;
		}
		if($('#belongtowns').combo('getValue')==''){
			$.messager.alert('返回消息','所属村委会不能为空！');
			return;
		} 
		
		if($('#detailaddress').val()==''){
			$.messager.alert('返回消息','详细地址不能为空！');
			$('#detailaddress')[0].focus();
			return;
		}
		
		
		if(!$('#landarea').validatebox('isValid')){
			$.messager.alert('返回消息','土地面积不能为空！');
			$('#landarea')[0].focus();
			return;
		}else{
			var landarea = $('#landarea').val();
			if(landarea == 0){
				$.messager.alert('返回消息','土地面积必须大于0！');
				$('#landarea')[0].focus();
				return;
			}
		}
		
		if (landsourcecode==lesseecode) {
			//var l = $('#landmoney').val();
			//if(l==''){
			//	$.messager.alert('返回消息','年租金不能为空！');
			//	return;
			//}else{
			//	var landmoney = $('#landmoney').val();
			//	if(parseFloat(landmoney) <0){
			//		$.messager.alert('返回消息','年租金必须大于等于0！');
			//		return;
			//	}
			//}
		}else{
			if($('#landmoney').val()==''){
				$.messager.alert('返回消息','土地总价不能为空！');
				return;
			}else{
				var landmoney = $('#landmoney').val();
				if(parseFloat(landmoney) <0){
					$.messager.alert('返回消息','土地总价必须大于等于0！');
					return;
				}
			}
		}
		if(!$('#landmoney').validatebox('isValid')){
			$.messager.alert('返回消息','土地总价不能为空！');
			return;
		}else{
			var landmoney = $('#landmoney').val();
			if(landarea == 0){
				$.messager.alert('返回消息','土地总价必须大于0！');
				return;
			}
		}
		
		
		if (endEditing()){
			endEdits();
		}else{
			return;
		}
		var rentdata = $('#rentgrid').datagrid('getRows');
		if (landsourcecode==lesseecode) {
			if(rentdata.length == 0){
				$.messager.alert('返回消息','请录入出租明细！');
				return;
			}else{
				for (var i=0;i<rentdata.length ;i++ )
				{
					var row = rentdata[i];
					if(!dateValid(row.limitbegin)){
						$.messager.alert('返回消息','出租时间起有误！');
						return;
					}
					if(!dateValid(row.limitend)){
						$.messager.alert('返回消息','出租时间止有误！');
						return;
					}
					if(!dateValid(row.holddate)){
						$.messager.alert('返回消息','合同约定付款时间有误！');
						return;
					}
				}
			}
		}
		Load();
		var params = {};
		var fields =$('#groundregisterform').serializeArray();
		$.each( fields, function(i, field){
			params[field.name] = field.value;
		});
		params.taxorgsupcode = $('#registertaxorgsupcode').combobox('getValue');
		params.taxorgcode = $('#registertaxorgcode').combobox('getValue');
		params.taxdeptcode = $('#registertaxdeptcode').combobox('getValue');
		params.taxmanagercode = $('#registertaxmanagercode').combobox('getValue');
		//宗地编号	
		params.estateserialno = '';
		if(params.landmoney ==''){
			params.landmoney ='0.00';
		}
		var requestparam= new Object();
		//requestparam.baseinfo=params;
		params.rentdata = rentdata;
		//alert("estateid:"+params.estateid);
		//alert($.toJSON(params));
		//return;
		$.ajax({
		   type: "post",
		   url: "/GroundUserightServlet/saveGroundRegisterinfo.do",
		   data: $.toJSON(params),
		   dataType: "json",
		   contentType: "application/json; charset=utf-8",
		   success: function(jsondata){
		   	  dispalyLoad();
			  $('#groundregistergrid').datagrid('reload');
			  $('#groundAddwindow').window('close');			  
			  $.messager.alert('返回消息','保存成功！');
		   },error:function (data, status, e){ 
		   	  dispalyLoad();  
			  $.messager.alert('返回消息','保存失败!');   
		   }  
		});
		
	}
	
	
	function format_state(value){
		var s = "";
		if (value=='0'){
			s='未审核';
		}else if (value=='1') { 
			s='已审核';
		}else if (value=='3' || value=='2'){
			s='已终审';
		}
		return s; 
	}
	
	function uploadbutton(value,row,index){
		return "<a href=javascript:void(0) onclick=\"attachment(\'"+row.businesscode+"\',\'"+row.businessnumber+"\')\">附件管理</a>";
	}

	function attachment(businesscode,businessnumber){
		window.open('/attachmentutil.jsp?businessnumber='+businessnumber+'&businesscode='+businesscode, '附件',
								   'top=100,left=250,width=930,height=400,toolbar=no,menubar=no,location=no');
	}
	$.extend($.fn.validatebox.defaults.rules, {   
		datecheck: {   
			validator: function(value){ 
				return /^((((1[6-9]|[2-9]\d)\d{2})-(0?[13578]|1[02])-(0?[1-9]|[12]\d|3[01]))|(((1[6-9]|[2-9]\d)\d{2})-(0?[13456789]|1[012])-(0?[1-9]|[12]\d|30))|(((1[6-9]|[2-9]\d)\d{2})-0?2-(0?[1-9]|1\d|2[0-8]))|(((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))-0?2-29-))$/.test(value);
			},   
			message: '时间格式不合法，格式为YYYY-MM-DD 如：2013-01-03'  
		}   
	}); 

	$.extend($.fn.validatebox.defaults.rules, {
	isAfter: {
		validator: function(value, param){
			var dateA = $.fn.datebox.defaults.parser(value);
			var dateB = $.fn.datebox.defaults.parser($(param[0]).datebox('getValue'));
			//$.messager.alert('返回消息',dateA+"------"+dateB);
			return dateA<dateB;
			},
		 message: '使用年限起不能大于使用年限止！'
		}
	});
	
	</script>
</head>
<body>
		<div title="土地登记" data-options="">
						
						<table id="groundregistergrid" style="height:550px;overflow:auto" 
						data-options="iconCls:'icon-edit',singleSelect:true" rownumbers="true"> 
							<thead>
								<tr>
									<th data-options="field:'estateid',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'businesscode',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'businessnumber',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'a',width:100,align:'center',formatter:uploadbutton">附件管理</th>
									<th data-options="field:'state',width:80,align:'left',editor:{type:'validatebox'}, formatter:function(value){return format_state(value)}">审核状态</th>
									<th data-options="field:'landsource',width:80,align:'left',formatter:formatlandsource,editor:{type:'text'}">土地来源</th>
									<th data-options="field:'taxpayerid',width:120,align:'left',editor:{type:'validatebox'}">计算机编码</th>
									<th data-options="field:'taxpayername',width:250,align:'left',editor:{type:'validatebox'}">纳税人名称</th>
									<th data-options="field:'belongtowns',width:150,align:'left',editor:{type:'validatebox'}">所属村（居）委会</th>
									<th data-options="field:'detailaddress',width:260,align:'left',editor:{type:'validatebox'}">详细地址</th>
									<th data-options="field:'holddates',width:120,align:'left',editor:{type:'validatebox'}">取得土地时间</th>
									<th data-options="field:'landarea',width:120,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">土地面积（平方米）</th>
									<th data-options="field:'taxdeptcode',width:200,align:'left',formatter:function(value,row,index){
										for(var i=0; i<orgdata.length; i++){
											if (orgdata[i].key == value) return orgdata[i].value;
										}
										return value;
									},editor:{type:'text'}">主管地税部门</th>
									<th data-options="field:'taxmanagercode',width:120,align:'left',formatter:function(value,row,index){
										for(var i=0; i<empdata.length; i++){
											if (empdata[i].key == value) return empdata[i].value;
										}
										return value;
									},editor:{type:'text'}">税收管理员</th>
									<!--  
									<th data-options="field:'purpose',width:50,formatter: formatgrounduse ,align:'center',editor:{type:'validatebox'}">土地用途</th>
									<th data-options="field:'protocolnumber',width:100,align:'center',editor:{type:'validatebox'}">协议书号</th>
									<th data-options="field:'holddates',width:70,align:'center',editor:{type:'validatebox'}">实际转移时间</th>
									<th data-options="field:'landarea',width:60,align:'center',editor:{type:'validatebox'}">宗地面积</th>
									<th data-options="field:'landamount',width:60,align:'center',editor:{type:'validatebox'}">转出总价</th>
									<th data-options="field:'limitbegins',width:60,align:'center',editor:{type:'validatebox'}">转出起时间</th>
									<th data-options="field:'limitends',width:60,align:'center',editor:{type:'validatebox'}">转出止时间</th>
									<th data-options="field:'businessnumber',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'parentbusinessnumber',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'targetestateid',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'landstoresubid',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									-->
								</tr>
							</thead>
						</table>
		</div>
	
	<div id="groundquerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地登记查询',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:260px;">
		<div class="easyui-panel" title="" style="width:900px;">
			<form id="groundqueryform" method="post">
				<table id="narjcxx" class="table table-bordered">
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
						<td align="right">
									土地来源：
						</td>
						<td>
							<input id="landsource" name="landsource" class="easyui-combobox" style="width:200px;"  data-options="
							valueField: 'key',
							textField: 'value',
							url: '/ComboxService/getComboxs.do?codetablename=COD_GROUNDSOURCECODE'" />
						</td>
						<td align="right">审核状态：</td>
						<td>
							<input class="easyui-combobox" name="state" id="state" data-options="
										valueField: 'value',
										textField: 'label',
										data: [{
											label: '全部',
											value: ''
										},{
											label: '未审核',
											value: '0'
										},{
											label: '已审核',
											value: '1'
										},{
											label: '已终审',
											value: '3'
										}]" />
							<!-- <select id="state" name="state"  class="easyui-combobox">
												            <option value="">所有</option>
												            <option value="0">未审核</option>
												            <option value="1" selected>已审核</option>
												            <option value="3">已终核</option>
												        </select> -->
				        </td>
					</tr>
					<tr>
						<td align="right">投入使用时间：</td>
						<td colspan="3">
							<input id="datebegin" class="easyui-datebox" name="datebegin"/>
						至
							<input id="dateend" class="easyui-datebox"  name="dateend"/>
						</td>
					</tr>
					<tr>
						<td align="right">采集时间：</td>
						<td colspan="3">
							<input id="optdatebegin" class="easyui-datebox" name="optdatebegin"/>
						至
							<input id="optdateend" class="easyui-datebox"  name="optdateend"/>
						</td>
					</tr>
				</table>
			</form>
			<div style="text-align:center;padding:1px;">  
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="query()">查询</a>
			</div>
		</div>
	</div>
	
	<div id="groundAddwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地登记信息',
		collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:900px;height:480px;">
		
			<!-- 新增土地信息 -->
				
				<form id="groundregisterform"    method="post">
					<table id="tdcrxx"  data-options="title:'土地登记信息'"    class="table table-bordered" >
					<input type='hidden' value='' name = 'estateid' id ='estateid'/>
					<input type='hidden' value='' name = 'busid' id ='busid'/>
						<tr>
							<td align="right">
								计算机编码：
							</td>
							<td>
								<input id="taxpayerid" class="easyui-validatebox" type="text" style="width:200px;" name="taxpayerid"  data-options="" onkeydown="if(event.keyCode==13)spelltaxpayerid(this)"></input>
								<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="queryTaxpayerid()">查询</a>
							</td>
							<td align="right">
								纳税人名称：
							</td>
							<td>
								<input id="taxpayername" class="easyui-validatebox" type="text" style="width:200px;" name="taxpayername"  data-options=""></input>
								<span style="color:red;font-weight: bold;font-size: 12pt">*</span>
							</td>
						</tr>
						<tr id ='landsourcediv'>
							<td align="right">
								土地来源：
							</td>
							<td>
								<input id="landsource" name="landsource" class="easyui-combobox" style="width:200px;"  data-options="
								valueField: 'key',
								textField: 'value',
								url: '/ComboxService/getComboxs.do?codetablename=COD_GROUNDSOURCECODE',
								onSelect:function(r){
									$('#lessorid').val('');
									$('#lessortaxpayername').val('');
									$('#lessorcontact').val('');
									$('#lessortel').val('');
									if (r.key==lesseecode){ 
										$('#lesseediv').show();
										$('#lessorinfodiv').show();
										$('#rentinfodiv').show();
										$('#landcertificatetype').combobox({valueField: 'key',textField: 'value',data:landcertificatetype_data_part});
										$('#landtype').html('土地类型：');
										$('#tdzjtr').hide();
										//$('#tdzj').html('年租金（元）：');
									}else{
										$('#lesseediv').hide();
										$('#lessorinfodiv').hide();
										$('#rentinfodiv').hide();
										$('#landcertificatetype').combobox({valueField: 'key',textField: 'value',data:landcertificatetype_data_all});
										$('#landtype').html('土地证类型：');
										$('#tdzjtr').show();
										$('#tdzj').html('土地总价（元）：');
									}
								}
								 "/>
								<span style="color:red;font-weight: bold;font-size: 12pt">*</span>
							</td>
							
							<td align="right">
								土地用途：
							</td>
							<td>
								<input id="purpose" name="purpose" style="width:200px;" class="easyui-combobox"  data-options="
								valueField: 'key',
								textField: 'value',
								url: '/ComboxService/getComboxs.do?codetablename=COD_GROUNDUSECODE'" />
								<span style="color:red;font-weight: bold;font-size: 12pt">*</span>
							</td>
						</tr>
						
						<tr id='lesseediv'>
							<td align="right">
								出租人计算机编码： 
							</td>
							<td>
								<input id="lessorid" class="easyui-validatebox" type="text" style="width:200px;" name="lessorid"  data-options="" onkeydown="if(event.keyCode==13)spelltaxpayerid(this)"></input>
								<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="querylessor()">查询</a>
							</td>
							<td align="right">
								出租人名称：
							</td>
							<td>
								<input id="lessortaxpayername" class="easyui-validatebox" type="text" style="width:200px;" name="lessortaxpayername"  data-options=""></input>
								<span style="color:red;font-weight: bold;font-size: 12pt">*</span>
							</td>
						</tr>
						<tr id='lessorinfodiv'>
							<td align="right">
								联系人： 
							</td>
							<td>
								<input id="lessorcontact" class="easyui-validatebox" type="text" style="width:200px;" name="lessorcontact"  data-options=""></input>
							</td>
							<td align="right">
								联系电话：
							</td>
							<td>
								<input id="lessortel" class="easyui-validatebox" type="text" style="width:200px;" name="lessortel"  data-options=""></input>
								
							</td>
						</tr>
						
						<tr id='div100'>
							<td id='landtype' align="right">
								土地证类型：
							</td>
							<td>
								<input id="landcertificatetype" name="landcertificatetype" style="width:200px;" class="easyui-combobox"  data-options="
								valueField: 'key',
								textField: 'value',
								data:landcertificatetype_data_all" />
							</td>
							<td align="right">
								土地证号：
							</td>
							<td>
								<input id="landcertificate" class="easyui-validatebox"style="width:200px;" type="text" name="landcertificate"  data-options=""></input>
							</td>
						</tr>
						<tr>
							<td align="right">
								发证日期：
							</td>
							<td>
								<input id="landcertificatedates" name='landcertificatedates' class="easyui-datebox" style="width:200px;" data-options="validType:['datecheck'],required:false" ></input>
							</td>
							<td align="right">
								取得土地时间：
							</td>
							<td>
								<input id="holddates" name="holddates" class="easyui-datebox" style="width:200px;" data-options="validType:['datecheck']"></input>
								<span style="color:red;font-weight: bold;font-size: 12pt">*</span>
							</td>
						</tr>
						<tr>
							<td align="right">
								使用年限起：
							</td>
							<td >
								<input id="datebegins" name='datebegins' class="easyui-datebox" style="width:200px;" data-options="validType:['datecheck','isAfter[\'#dateends\']']"></input>
								<span style="color:red;font-weight: bold;font-size: 12pt">*</span>
							</td>
							<td align="right">
								使用年限止：
							</td>
							<td >
								<input id="dateends" name='dateends' class="easyui-datebox" style="width:200px;" data-options="validType:'datecheck'"></input>
								<span style="color:red;font-weight: bold;font-size: 12pt">*</span>
							</td>
						</tr>
						<tr>
							<td rowspan="3" align="center" style="padding:20px;">
								土地坐落地
							</td>
							<td align="right">
								土地坐落地类型： 
							</td>
							<td colspan="3">
								<input id="locationtype" name="locationtype" style="width:400px;" class="easyui-combobox" editable='false' data-options="
								valueField: 'key',
								textField: 'value',
								url: '/ComboxService/getComboxs.do?codetablename=COD_LOCATIONTYPE'" />
								<span style="color:red;font-weight: bold;font-size: 12pt">*</span>
							</td>
						</tr> 
						<tr>
							<td align="right">所属乡（镇、街道办）：</td>
							<td colspan=3>
								<input class="easyui-combobox"  id="countrytown" style="width:400px;" name="countrytown"  data-options='' data-validate="p"/>	
								<span style="color:red;font-weight: bold;font-size: 12pt">*</span>				
							</td>
							
						</tr> 
						<tr> 
							<td align="right">所属村（居）委会：</td>
							<td colspan=3>
									<input class="easyui-combobox"  id="belongtowns" style="width:400px;" name="belongtowns" data-options="disabled:false,panelHeight:200" data-validate=""/>	
									<span style="color:red;font-weight: bold;font-size: 12pt">*</span>					
							</td>
						</tr>
						<!-- tr>
							<td align="right">
								坐落位置：
							</td>
							<td colspan="3">
								<input id="belongtowns" name="belongtowns" style="width:400px;" class="easyui-combobox" disabled="true" editable='false' data-options="
								valueField: 'key',
								textField: 'value',
								data: locationdata" />
								<span style="color:red;font-weight: bold;font-size: 12pt">*</span>
							</td>
						</tr-->
						
						<tr>
							<td align="right">
								详细地址：
							</td>
							<td>
								<input id="detailaddress" class="easyui-validatebox" style="width:200px;" type="text" name="detailaddress" data-options=""></input>
								<span style="color:red;font-weight: bold;font-size: 12pt">*</span>
							</td>
							<td align="right">
							土地面积（平方米）：
							</td>
							<td>
								<input id="landarea" class="easyui-numberbox" style="width:200px;text-align:right" type="text" name="landarea" data-options="min:0" precision="2" value="0.00" style="text-align:right" /><font color="red" id="maxgroundarea"></font></input>
								<span style="color:red;font-weight: bold;font-size: 12pt">*</span>
							</td>
						</tr>
						<tr id="tdzjtr">
							<td id='tdzj' align="right">
							土地总价（元）：
							</td>
							<td colspan="3"> 
								<input id="landmoney" class="easyui-numberbox" style="width:200px;text-align:right" type="text" name="landmoney"  data-options="min:0" precision="2" value="0.00"></input>
								<span style="color:red;font-weight: bold;font-size: 12pt">*</span>
							</td>
							
						</tr> 
					<tr> 
						<td align="right">州市地税机关：</td> 
						<td>
							<input class="easyui-combobox" name="registertaxorgsupcode" id="registertaxorgsupcode" style="width:250px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">县区地税机关：</td>
						<td>
							<input class="easyui-combobox" name="registertaxorgcode" id="registertaxorgcode" style="width:250px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
					</tr>
					<tr>
						<td align="right">主管地税部门：</td>
						<td>
							<input class="easyui-combobox" name="registertaxdeptcode" id="registertaxdeptcode" style="width:250px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">税收管理员：</td>
						<td>
							<input class="easyui-combobox" name="registertaxmanagercode" style="width:250px" id="registertaxmanagercode" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
					</tr>
					</table>
					<div id="rentinfodiv" >
						<table id="rentgrid" style="overflow:auto" 
							data-options="iconCls:'icon-edit',singleSelect:true" rownumbers="true"> 
								<thead>
									<tr>
										<th data-options="field:'limitbegin',width:200,align:'center',formatter:formatDatebox,editor:{type:'datebox',options:{required:true}}">出租时间起</th>
										<th data-options="field:'limitend',width:200,align:'center',formatter:formatDatebox,editor:{type:'datebox',options:{required:true}}">出租时间止</th>
										<th data-options="field:'transmoney',width:200,align:'right',editor:{type:'numberbox',options:{precision:2,min:0,required:true}}">年租金(元)</th>
										<th data-options="field:'holddate',width:200,align:'center',formatter:formatDatebox,editor:{type:'datebox',options:{required:true}}">合同约定付款时间</th>
									</tr>
								</thead>
						</table>
					</div>
					<div align='center'> <a href="#"   class="easyui-linkbutton" data-options="iconCls:'icon-save',region:'center'" onclick=" businesssave()">保存</a></div>
						
				</form>
		
	</div>
	
	<!-- 查询选择纳税人窗口 -->
	<div id="choiceTaxpayerWin" class="easyui-window" style ='width:850px;height:345px;' data-options="closed:true,modal:true,title:'纳税人信息',collapsible:false,minimizable:false,maximizable:false,closable:true">
			<!-- div style="text-align:left;padding:5px;">  
				<div style="background-color: #c9c692;height: 25px;">		
						<span style="font-size: 12px; color:red; font-weight: bold;">查询条件：</span>
						<span style="font-size: 12px;">
						计算机编码<input  type="text" style="width:120px" id="query_taxpayerid1" name="query_taxpayerid1"/></span>
						纳税人名称<input  type="text" style="width:120px" id="query_taxtypename1" name="query_taxtypename1"/></span>
						<span style="font-size: 12px; color:red; font-weight: bold;">操作：</span>
						<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="regquery()" >查询</a>
						<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="reginput()" >关闭</a>
				</div>
			</div-->
			<table id="reginfogrid1" style="width:800px;height:310px"
			data-options="iconCls:'icon-edit',singleSelect:true,fitColumns:true" rownumbers="true"> 
				<thead>
					<tr>
						<th data-options="field:'taxpayerid',width:120,align:'center',editor:{type:'validatebox'}">计算机编码</th>
						<th data-options="field:'taxpayername',width:200,align:'left',editor:{type:'validatebox'}">纳税人名称</th>
						<th data-options="field:'taxdeptname',width:200,align:'center',editor:{type:'validatebox'}">主管地税部门</th>
						<th data-options="field:'taxmanagername',width:120,align:'center',editor:{type:'validatebox'}">税收管理员</th>
					</tr>
				</thead>
			</table>
	</div>  
	
	<!-- 查询选择出租人窗口 -->
	<div id="choiceTaxpayerWin" class="easyui-window" style ='width:850px;height:345px;' data-options="closed:true,modal:true,title:'出租人信息',collapsible:false,minimizable:false,maximizable:false,closable:true">
			<!-- div style="text-align:left;padding:5px;">  
				<div style="background-color: #c9c692;height: 25px;">		
						<span style="font-size: 12px; color:red; font-weight: bold;">查询条件：</span>
						<span style="font-size: 12px;">
						计算机编码<input  type="text" style="width:120px" id="query_taxpayerid1" name="query_taxpayerid1"/></span>
						纳税人名称<input  type="text" style="width:120px" id="query_taxtypename1" name="query_taxtypename1"/></span>
						<span style="font-size: 12px; color:red; font-weight: bold;">操作：</span>
						<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="regquery()" >查询</a>
						<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="reginput()" >关闭</a>
				</div>
			</div-->
			<table id="reginfogrid2" style="width:800px;height:310px"
			data-options="iconCls:'icon-edit',singleSelect:true,fitColumns:true" rownumbers="true"> 
				<thead>
					<tr>
						<th data-options="field:'taxpayerid',width:120,align:'center',editor:{type:'validatebox'}">计算机编码</th>
						<th data-options="field:'taxpayername',width:200,align:'left',editor:{type:'validatebox'}">纳税人名称</th>
						<th data-options="field:'taxdeptname',width:200,align:'center',editor:{type:'validatebox'}">主管地税部门</th>
						<th data-options="field:'taxmanagername',width:120,align:'center',editor:{type:'validatebox'}">税收管理员</th>
					</tr>
				</thead>
			</table>
	</div>
	
</body>
</html>
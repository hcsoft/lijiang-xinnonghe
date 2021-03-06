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
	<script src="<%=spath%>/js/common.js"></script>
	<script src="<%=spath%>/locale/easyui-lang-zh_CN.js"></script>

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
	var default_locationcode = '04';//县级
	var taxopt;//弹出纳税人窗口  1 ：为了查给纳税人的地 2：选择该纳税人为转入方
	
	var redisplay11;
	var redisplay22;
	var data_orgcombox ;
	var transfertd1;
	var transfertd2;
	var transfertype;
	var orgdata = new Object;
	var empdata = new Object;
	$(function(){
		//取得url参数
		var paraString = location.search;     
		var paras = paraString.split("&");   
		businesstype = paras[0].substr(paras[0].indexOf("=") + 1);   
		
		
		
		$('#reginfogrid1').datagrid({
			fitColumns:'false',
			maximized:'false',
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
		var regex = new RegExp("\"","g");  
		$.ajax({
			   type: "get",
			   url: "/soption/taxOrgOptionInit.do",
			   data: {"moduleAuth":"15","emptype":"30"},
			   dataType: "json",
			   success: function(jsondata){
				   $('#querytaxorgsupcode').combobox({
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
									   $('#querytaxorgcode').combobox({
											data : jsondata.taxOrgOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});
									   $('#querytaxdeptcode').combobox({
											data : jsondata.taxDeptOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});		
									   $('#querytaxmanagercode').combobox({
											data : jsondata.taxEmpOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});											
								   }
							});
						} 
					});
					if(jsondata.taxSupOrgOptionJsonArray.length == 1){
						$('#querytaxorgsupcode').combobox("setValue",JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key).replace(regex, ""));
						$('#querytaxorgsupcode').combobox("setText",JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].keyvalue).replace(regex, ""));
					}


				   $('#querytaxorgcode').combobox({
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
									   $('#querytaxdeptcode').combobox({
											data : jsondata.taxDeptOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});		
									   $('#querytaxmanagercode').combobox({
											data : jsondata.taxEmpOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});											
										//$('#querytaxdeptcode').combobox("clear");
										//$('#taxempcode').combobox("clear");

										//$('#querytaxdeptcode').combobox({}).combobox('clear');
								   }
							});
						} 
					});
					if(jsondata.taxOrgOptionJsonArray.length == 1){
						//$.messager.alert('返回消息',JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
						$('#querytaxorgcode').combobox("setValue",JSON.stringify(jsondata.taxOrgOptionJsonArray[0].key).replace(regex, ""));
						$('#querytaxorgcode').combobox("setText",JSON.stringify(jsondata.taxOrgOptionJsonArray[0].keyvalue).replace(regex, ""));
					}

				   $('#querytaxdeptcode').combobox({
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
									   $('#querytaxmanagercode').combobox({
											data : jsondata.taxEmpOptionJsonArray,
											valueField:'key',
											textField:'keyvalue'
										});											
										//$('#querytaxdeptcode').combobox("clear");
										//$('#taxempcode').combobox("clear");

										//$('#querytaxdeptcode').combobox({}).combobox('clear');
								   }
							});
						} 
					});
					if(jsondata.taxDeptOptionJsonArray.length == 1){
						//$.messager.alert('返回消息',JSON.stringify(jsondata.taxSupOrgOptionJsonArray[0].key));
						$('#querytaxdeptcode').combobox("setValue",JSON.stringify(jsondata.taxDeptOptionJsonArray[0].key).replace(regex, ""));
						$('#querytaxdeptcode').combobox("setText",JSON.stringify(jsondata.taxDeptOptionJsonArray[0].keyvalue).replace(regex, ""));
					}



				   $('#querytaxmanagercode').combobox({
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
							//$.messager.alert('返回消息',n.key);
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
						},
						onChange:function(n,o){  	
							//$.messager.alert('返回消息',n.key);
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
						},
						onChange:function(n,o){  	
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
										//$('#querytaxdeptcode').combobox("clear");
										//$('#taxempcode').combobox("clear");

										//$('#querytaxdeptcode').combobox({}).combobox('clear');
								   }
							});
						},
						onChange:function(n,o){  	
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
										//$('#querytaxdeptcode').combobox("clear");
										//$('#taxempcode').combobox("clear");

										//$('#querytaxdeptcode').combobox({}).combobox('clear');
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
	   
		
		$('#groundbusigrid').datagrid({
				//fitColumns:'true',
				maximized:'true',
				pagination:true,
				idField:'ownerid',
				view: $.extend({},$.fn.datagrid.defaults.view,{
						onAfterRender: function(target){
										$('#groundbusigrid').datagrid('clearSelections');//页面重新加载时取消所有选中行
										} 
						}),
				toolbar:[{
					text:'查询',
					iconCls:'icon-search',
					handler:function(){
						$('#groundquerywindow').window('open');
					}
				}
				,{
					id :'transfer_menu',
					text:'土地收回',
					iconCls:'icon-add',
					handler:function(){
						$('#groundTransferwindow').window('open');
						$('#qtaxpayerid').val('');
						$('#qtaxpayername').val('');
						$('#groundform').form('clear');
						$('#maxgroundarea').html('');
						//添加查询条件和grid,改变groundTransferwindow高度  变groundTransferwindow高度  grounddiv querydiv
						$("#groundTransferwindow").panel({title:'土地收回'});
				   	  	$('#groundTransferwindow').prepend(redisplay11);
				   	  	$('#groundTransferwindow').prepend(redisplay22);
				   	
				   	  	$('#groundTransferwindow').window('resize',{width:980,height:610});
				   	  	$('#groundtrangrid').datagrid('loadData',{rows:[]});
				   
					}
				},
				{
					id:'edit',
					text:'修改',
					iconCls:'icon-edit',
					handler:function(){
						var row = $('#groundbusigrid').datagrid('getSelected');
						if (row){
						$("#sourceestateid").val(row.estateid);
							var busid = row.busid;
						
							$.ajax({
									   type: "post",
									   url: "/GroundUserightServlet/queryGroundBusiForEdit.do",
									  data: {busid: busid,businesstype: businesstype},
									   dataType: "json",
									   success: function(jsondata){
									   		//alert($.toJSON(jsondata));
									   		$('#qtaxpayerid').val('');
									   		$('#qtaxpayername').val('');
									   		$('#groundform').form('clear');	
											$('#groundTransferwindow').window('open');
											$("#groundTransferwindow").panel({title:''});
											$('#groundtrangrid').datagrid('loadData',{total:0,rows:[]});
											$('#groundform').form('load',jsondata);	
											$('#belongtowns').combobox('setText',formatbelongtown(jsondata.belongtowns));
											
											
											
											
											maxgroundarea = jsondata.maxlandarea;
											$('#maxgroundarea').html('可收回土地面积'+maxgroundarea+'平方米');
											//叉掉查询条件和grid,改变groundTransferwindow高度  grounddiv querydiv
									   	  	redisplay11 = $('#grounddiv').detach(); 
									   	  	redisplay22 = $('#querydiv').detach();
									   	  	$('#groundTransferwindow').window('resize',{width:980,height:410});
									   	  	
											/*
											$('#registertaxorgsupcode').combobox('disable');
											$('#registertaxorgcode').combobox('disable');
											$('#registertaxdeptcode').combobox('disable');
											$('#registertaxmanagercode').combobox('disable');
											$('#registertaxorgsupcode').combobox('setValue',jsondata.taxorgsupcode);
											$('#registertaxorgcode').combobox('setValue',jsondata.taxorgcode);
											$('#registertaxdeptcode').combobox('setValue',jsondata.taxdeptcode);
											$('#registertaxmanagercode').combobox('setValue',jsondata.taxmanagercode);
											$('#countrytown').combobox('setValue',belongtowns.substring(0,9));
											$('#belongtowns').combobox('setValue',belongtowns);
											*/
											$("#estateid").val(jsondata.estateid);
											
									   },error:function (data, status, e){   
											$.messager.alert('返回消息',"修改出错");   
										}   	
							});
						}else{
								$.messager.alert('提示','请选择要修改的业务信息!');
						}
					}
				},{
					id:'cancel',
					text:'删除',
					iconCls:'icon-remove',
					handler:function(){
						//只有初始状态的可以删除
						var row = $('#groundbusigrid').datagrid('getSelected');
						if (row){
							var state =  row.state;
							if (state!='0'){
								$.messager.alert('提示','只有初始状态的可以删除!');
								return;
							}
							$.messager.confirm('提示','确定删除吗?',function(r){
								if(r){
									var params = {};
									params.businesscode = businesstype;
									params.busid = row.busid ;
									//alert($.toJSON(params));
									//return;
									$.ajax({
										   type: "post",
										   url: "/GroundUserightServlet/delGroundBusiness.do",
										   data: params,
										   dataType: "json",
										   success: function(jsondata){
											  $('#groundbusigrid').datagrid('reload');
											  $.messager.alert('返回消息','删除成功！');
										   }
									});
								}
							});
							
						}else{
								$.messager.alert('提示','请选择要删除的土地信息!');
						}
					}
				},{
					id:'check',
					text:'终审',
					iconCls:'icon-check',
					handler:function(){
						var row = $('#groundbusigrid').datagrid('getSelected');
						if (row){
							var params = {};
							params.estateid=row.estateid;
							params.busid=row.busid;
							params.businesscode = businesstype;
							$.ajax({
							   type: "post",
							   url: "/GroundUserightServlet/finalCheckGroundBusi.do",
							   data: params,
							   dataType: "json",
							   success: function(jsondata){
								  $('#groundbusigrid').datagrid('reload');
								  $.messager.alert('返回消息','终审成功！');
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
						var row = $('#groundbusigrid').datagrid('getSelected');
						if (row){
							var params = {};
							params.estateid=row.estateid;
							params.busid=row.busid;
							params.businesscode = businesstype;
							//alert($.toJSON(params));
							//	return;
							$.ajax({
									   type: "post",
									   url: "/GroundUserightServlet/unfinalcheck.do",
									   data: params,
									   dataType: "json",
									   success: function(jsondata){
										  $('#groundbusigrid').datagrid('reload');
										  $.messager.alert('返回消息','撤销终审成功！');
									   },error:function (data, status, e){   
											$.messager.alert('返回消息','撤销终审失败!');   
										}  
							});
						}else{
							$.messager.alert('提示','请选择要删除的土地信息!');
						}
					}
				}
				],
				onClickRow:function(index){
						var row = $('#groundbusigrid').datagrid('getSelected');
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
					}
		});
		var p = $('#groundbusigrid').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
		});
		
		$('#taxpayerid').blur(function(){
			var taxpayerid = $("#taxpayerid").val();
			if (taxpayerid!=''){
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
		
		
		//土地转让 21 土地投资联营 22 土地捐赠 23  土地融资租赁 24  土地出典 25   土地划转 26	
		
		//01出让//02	转让//03	承租//04	融资租赁//05	未批先占//06	股东入股//07	捐赠//08	划拨//99	其他//09	划转
		
		
		if(businesstype == '26' ){
			$("#groundTransferwindow").panel({title:'土地划转'});
			$("#groundquerywindow").panel({title:'土地划转查询'});
			$('#transfer_menu span:last').html('土地划转');
			$('#landsource').combobox('setValue','09');
		}
		$('#landsource').combobox('disable');
		
		$("#transfertype option:first").prop("selected", 'selected');
		
		$('#groundtrangrid').datagrid({
			fitColumns:false,
			pagination:false,
			idField:'estateid',
			onClickRow:function(index){
				var row = $('#groundtrangrid').datagrid('getSelected',0);
				$('#groundform').form('load',row);
				$('#belongtowns').combobox('setText',formatbelongtown(row.belongtowns));
				$('#detailaddress').val(row.detailaddress);
				$('#registertaxorgsupcode').combobox('setValue',row.taxorgsupcode);
				$('#registertaxorgcode').combobox('setValue',row.taxorgcode);
				$('#registertaxdeptcode').combobox('setValue',notNull(row.taxdeptcode));
				$('#registertaxmanagercode').combobox('setValue',notNull(row.taxmanagertcode));
				/**
				这里注意:打开的是新增页面这里带来的busid 是上个业务的比如登记,这里busid赋值为空
				**/
				$('#busid').val('');
				
				maxgroundarea = row.landarea;
				$('#maxgroundarea').html('可收回土地面积'+maxgroundarea+'平方米');
				$('#landmoney').val('0.00');
				$('#holddates').datebox('setValue','');
				$('#landarea').val('0.00');
				$('#registertaxorgsupcode').combobox("disable");
				$('#registertaxorgcode').combobox('disable');
				$('#registertaxdeptcode').combobox("disable");
				$('#registertaxmanagercode').combobox('disable');
			
			}
			
		});
		setTimeout(businessquery,400);
		$('#groundbusigrid').datagrid('reload'); 
	});
	function notNull(v){
		if (v==null){
			return '';
		}else{
			return v;
		}
	}
	function query(){
		var params = {};
		var fields =$('#groundqueryform').serializeArray();
		$.each( fields, function(i, field){
			params[field.name] = field.value;
		}); 
		$('#groundtrangrid').datagrid('loadData',{total:0,rows:[]});
		var opts = $('#groundtrangrid').datagrid('options');
		opts.url = '/GroundSellServlet/getgroundstoreinfo.do';
		$('#groundtrangrid').datagrid('load',params); 
		
		$('#groundquerywindow').window('close');
		
	}
	
	function businessquery(){
		var params = {};
		var fields =$('#groundqueryform').serializeArray();
		$.each( fields, function(i, field){
			params[field.name] = field.value;
		}); 
		params.businesscode = businesstype;
		//alert($.toJSON(params));
		$('#groundbusigrid').datagrid('loadData',{total:0,rows:[]});
		var opts = $('#groundbusigrid').datagrid('options');
		opts.url = '/GroundUserightServlet/queryGroundBusinessInfo.do';
		$('#groundbusigrid').datagrid('load',params); 
		var p = $('#groundbusigrid').datagrid('getPager');  
		$(p).pagination({   
			showPageList:false,
			pageSize: 15
		});
		$('#groundbusigrid').datagrid('unselectAll');
		$('#groundquerywindow').window('close');
	}
	
	function landquery(){
		var params = {};
		taxopt = 'land';
		params.taxpayerid = $('#qtaxpayerid').val();
		params.taxpayername = $('#qtaxpayername').val();
		if(params.taxpayerid==''&&params.taxpayername==''){
			$.messager.alert('提示','计算机编码和纳税人名称不能同时为空!');
			return;
		}
		//先查纳税人，再查地
		
		$.ajax({
			type: "post",
			url: "/GroundUserightServlet/getreginfo1.do",
			data: params,
			dataType: "json",
			success: function(jsondata){
				if (jsondata.total==1){ 
					$('#qtaxpayername').val(jsondata.rows[0].taxpayername);
					$('#qtaxpayerid').val(jsondata.rows[0].taxpayerid);
					//查地
					//alert(jsondata.rows[0].taxpayerid);
					queryland(jsondata.rows[0].taxpayerid);
				}
				if (jsondata.total==0){
					$.messager.alert('返回消息',"不存在该纳税人!");
				}
				if (jsondata.total>1){
					regquery()
				}
			} 
		});
		
		
	}
	function Load() {  
		    $("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: $(window).height() }).appendTo("#groundTransferwindow");  
		    $("<div class=\"datagrid-mask-msg\"></div>").html("正在操作，请稍候。。。").appendTo("#groundTransferwindow").css({ display: "block", left: ($('#groundTransferwindow').outerWidth(true) - 190) / 2, top: ($('#groundTransferwindow').height() - 45) / 2 });  
	}  
  	  
	function dispalyLoad() {  
	    $(".datagrid-mask").remove();  
	    $(".datagrid-mask-msg").remove();  
	}	
	function businesssave(){
			if($('#recoverdates').datebox('getValue')==''){
				$.messager.alert('返回消息','收回日期不能为空！');
				$('#recoverdates')[0].focus();
				return;
			}
			if(!$('#recoverlandarea').validatebox('isValid')){
				$.messager.alert('返回消息','收回土地面积不能为空！');
				$('#recoverlandarea')[0].focus();
				return;
			}else{
				var recoverlandarea = $('#recoverlandarea').val();
				if(recoverlandarea>maxgroundarea){
					$.messager.alert('返回消息','收回土地面积不能大于可收回土地面积！');
					$('#recoverlandarea')[0].focus();
					return;
				}
				if(recoverlandarea == 0){
					$.messager.alert('返回消息','收回土地面积必须大于0！');
					$('#recoverlandarea')[0].focus();
					return;
				}
			}
			if($('#recovereason').val()==''){
				$.messager.alert('返回消息','收回原因不能为空！');
				$('#recovereason')[0].focus();
				return;
			}
			
		Load();
		var params = {};
		var fields =$('#groundform').serializeArray();
		$.each( fields, function(i, field){
			params[field.name] = field.value;
		});
		/*
		params.taxorgsupcode = $('#registertaxorgsupcode').combobox('getValue');
		params.taxorgcode = $('#registertaxorgcode').combobox('getValue');
		params.taxdeptcode = $('#registertaxdeptcode').combobox('getValue');
		params.taxmanagercode = $('#registertaxmanagercode').combobox('getValue');
		*/
		//宗地编号	
		params.estateserialno = $('#estateserialno').val();
		params.businesstype=businesstype;
		
		var busid = $('#busid').val();
		if (busid!=''){
			params.operatetype='modify';
		}else{
			var row = $('#groundtrangrid').datagrid('getSelected');
			params.operatetype='add';
			params.sourcetaxpayerid = row.taxpayerid;
			params.sourcetaxpayername = row.taxpayername;
			params.sourceestateid= row.estateid;
			
		}
		params.holddates=$('#recoverdates').datebox('getValue') ;
		params.landarea = $('#recoverlandarea').val();
		params.m_estateid=$('#estateid').val();
		params.m_busid=$('#busid').val();
		
		
		
		//alert($.toJSON(params));
		//return;
		$.ajax({
			type: "post",
			url: "/GroundUserightServlet/doGroundBusiness.do",
			data: params,
			dataType: "json",
			success: function(jsondata){
				dispalyLoad();
				$('#groundTransferwindow').window('close');
				$('#groundbusigrid').datagrid('reload');
				$.messager.alert('返回消息',"保存成功");
				
			},
			error:function (data, status, e){  
				dispalyLoad(); 
				$.messager.alert('返回消息',"保存出错");   
			}   
		});
	}
	
	
		
	function formatbelongtown(row){
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
	function formatgrounduse(row){
		for(var i=0; i<groundusedata.length; i++){
			if (groundusedata[i].key == row) return groundusedata[i].value;
		}
		return row;
	}
	function queryTaxpayerid(){
		var params = {};
		taxopt = 'taxpayer';
		params.taxpayerid = $('#taxpayerid').val();
		params.taxpayername = $('#taxpayername').val();
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
		if (taxopt=='taxpayer')	{	 
			params.taxpayerid = $('#taxpayerid').val();
		}
		if (taxopt=='land')	{	 
			params.taxpayerid = $('#qtaxpayerid').val();
			params.taxpayername = $('#qtaxpayername').val();
		} 
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
		
		if (taxopt=='taxpayer')	{
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
		}
		if (taxopt=='land')	{
			queryland(row.taxpayerid);
		}
		$('#choiceTaxpayerWin').window('close');
		
	}
	function queryland(taxpayerid){
		var params = {};
			params.taxpayerid = taxpayerid;
			params.businesscode = businesstype;
			//alert($.toJSON(params));
			$('#groundtrangrid').datagrid('loadData',{total:0,rows:[]});
			var opts = $('#groundtrangrid').datagrid('options');
			opts.url = '/GroundUserightServlet/queryGroundInfos.do';
			$('#groundtrangrid').datagrid('load',params);  
			var rows = $('#groundtrangrid').datagrid('getRows');
				/*
			    $('#groundtrangrid').datagrid('selectRow',0);
				var row = $('#groundtrangrid').datagrid('getSelected');
				
				$('#locationtype').combobox('setValue',row.locationtype);
				$('#belongtowns').combobox('setValue',row.belongtowns);
				$('#detailaddress').val(row.detailaddress);
				maxgroundarea = row.landarea;
				$('#maxgroundarea').html('可收回土地面积'+maxgroundarea+'平方米');
				$('#sourceestateid').val(row.estateid);
				$('#locationtype').combobox('setValue',row.locationtype);
		
				$('#landstorsubid').val(row.landstorsubid);
				$('#landstoreid').val(row.landstoreid);
				$('#sourceestateid').val(row.estateid);
				*/
			
			
	}
	
	$.extend($.fn.validatebox.defaults.rules, {   
			datecheck: {   
				validator: function(value){ 
					return /^((((1[6-9]|[2-9]\d)\d{2})-(0?[13578]|1[02])-(0?[1-9]|[12]\d|3[01]))|(((1[6-9]|[2-9]\d)\d{2})-(0?[13456789]|1[012])-(0?[1-9]|[12]\d|30))|(((1[6-9]|[2-9]\d)\d{2})-0?2-(0?[1-9]|1\d|2[0-8]))|(((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))-0?2-29-))$/.test(value);
				},   
				message: '时间格式不合法，格式为YYYY-MM-DD 如：2013-01-03'  
			}   
		}); 
	function format_state(value){
		var s = "";
		if (value=='0'){
			s='未审核';
		}
		else if (value=='1') { 
			s='已审核';
		} else if (value=='3'){
			s='已终审';
		}
		return s; 
	}
	
	function  winclose(){
		 $('#groundTransferwindow').window('close');
	} 
	function uploadbutton(value,row,index){
		return "<a href=javascript:void(0) onclick=\"attachment(\'"+row.businesscode+"\',\'"+row.businessnumber+"\')\">附件管理</a>";
	}

	function attachment(businesscode,businessnumber){
		window.open('/attachmentutil.jsp?businessnumber='+businessnumber+'&businesscode='+businesscode, '附件',
								   'top=100,left=250,width=930,height=400,toolbar=no,menubar=no,location=no');
	}
	function formatorg(value,row,index){
		for(var i=0; i<orgdata.length; i++){
			if (orgdata[i].key == value) return orgdata[i].value;
		}
		return value;
	}
	function formatemp(value,row,index){
		for(var i=0; i<empdata.length; i++){
			if (empdata[i].key == value) return empdata[i].value;
		}
		return value;
	}
	
	</script>
</head>
<body>
	
		<div title="土地收回信息" data-options="
						tools:[{
							handler:function(){
								$('#groundbusigrid').datagrid('reload');
							}
						}]">
						<table id="groundbusigrid" style="height:550px;overflow:auto" 
						data-options="iconCls:'icon-edit',singleSelect:true" rownumbers="true"> 
							<thead>
								<tr>
									<!-- <th data-options="checkbox:true"></th> -->
									<th data-options="field:'busid',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'estateid',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'businesscode',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'businessnumber',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'a',width:100,align:'center',formatter:uploadbutton">附件管理</th>
									<th data-options="field:'state',width:80,align:'left',editor:{type:'validatebox'}, formatter:function(value){return format_state(value)}">状态</th>
									<th data-options="field:'businesstypename',width:100,align:'left',editor:{type:'text'}">业务类型</th>
									<th  id='th_1' data-options="field:'lessorid',width:100,align:'left',editor:{type:'validatebox'}">计算机编码</th>
									<th data-options="field:'lessortaxpayername',width:200,align:'left',editor:{type:'validatebox'}">纳税人名称</th>
									<th data-options="field:'holddates',width:70,align:'left',editor:{type:'validatebox'}">收回时间</th>
									<th data-options="field:'landarea',width:70,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">收回面积（平方米）</th>
									<th data-options="field:'remark',width:60,align:'left',editor:{type:'validatebox'}">收回原因</th>
									<th data-options="field:'taxdeptcode',width:200,align:'center',formatter:formatorg,editor:{type:'validatebox'}">主管地税部门</th>
									<th data-options="field:'taxmanagercode',width:160,align:'center',formatter:formatemp,editor:{type:'validatebox'}">税收管理员</th>
									<!--  
									<th data-options="field:'landamount',width:60,align:'center',editor:{type:'validatebox'}">总价</th>
									<th data-options="field:'limitbegins',width:60,align:'center',editor:{type:'validatebox'}">使用起时间</th>
									<th data-options="field:'limitends',width:60,align:'center',editor:{type:'validatebox'}">使用止时间</th>
									-->
								</tr>
							</thead>
						</table>
		</div>
	
	
	<div id="groundTransferwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地收回',
		collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:980px;height:600px;">
		
			<!-- 查询条件 -->
			<div id='querydiv' style="text-align:center;width:950px;padding:5px;">  
						计算机编码: <input id="qtaxpayerid" type='text' name='name' style="width:120px" onkeydown="if(event.keyCode==13)spelltaxpayerid(this)">
						纳税人名称: <input id="qtaxpayername" type='text' name='approvenumber'  style="width:140px" >
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick=" landquery()">查询</a>
			</div>
			<!-- 土地信息 --> 
			<div id='grounddiv' style="width:950px;">
				<table id="groundtrangrid" style="height:150px;overflow: scroll"
					data-options="title:'土地信息',singleSelect:true,idField:'landstoreid'" rownumbers="true"> 
						<thead>
							<tr>
								<th data-options="field:'taxpayerid',width:85,align:'left',editor:{type:'validatebox'}">计算机编码</th>
								<th data-options="field:'taxpayername',width:180,align:'left',editor:{type:'validatebox'}">纳税人名称</th>
								<th data-options="field:'estateserialno',width:80,align:'left',editor:{type:'validatebox'}">宗地编号</th>
								<th data-options="field:'landcertificate',width:120,align:'left',editor:{type:'validatebox'}">土地证号</th>
								<th data-options="field:'holddates',width:80,align:'left',editor:{type:'validatebox'}">实际交付日期</th>
								<th data-options="field:'belongtowns',width:70,align:'left',formatter:formatbelongtown,editor:{type:'validatebox'}">所属村委会</th>
								<th data-options="field:'detailaddress',width:210,align:'left',editor:{type:'validatebox'}">坐落地详细地址</th>
								<th data-options="field:'landarea',width:80,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">土地面积（平方米）</th>
								
								
							</tr>
						</thead>
					</table>
			</div>
			 
				<div class="easyui-panel" title="土地业务信息"  style="width:950px;">
				<form id="groundform" method="post">
					<table id="tdcrxx"  data-options="title:'土地业务信息'"    class="table table-bordered" >
					<input type='hidden' value='' name = 'estateid' id ='estateid'/>
					<input type='hidden' value='' name = 'landstoreid' id ='landstoreid'/>
					<input type='hidden' value='' name = 'landstorsubid' id ='landstorsubid'/>
					<input type='hidden' value='' name = 'busid' id ='busid'/>
					<input type='hidden' value='' name = 'sourceestateid' id ='sourceestateid'/>
						<tr>
							
							<td align="right">
								计算机编码：
							</td>
							<td>
								<input id="taxpayerid" class="easyui-validatebox" type="text" style="width:200px;" name="taxpayerid"  disabled='true'  data-options="" onkeydown="if(event.keyCode==13)spelltaxpayerid(this)"></input>
								<!--  
								<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="queryTaxpayerid()">查询</a>
								-->	
							</td>
							<td align="right">
								纳税人名称：
							</td>
							<td>
								<input id="taxpayername" class="easyui-validatebox" type="text" style="width:200px;" name="taxpayername" disabled='true'  data-options=""></input>
							</td>
						</tr>
						<tr>  
							
							<td align="right">
								土地用途：
							</td>
							<td >
								<input id="purpose" name="purpose" style="width:200px;" class="easyui-combobox" disabled='true'  data-options="
								valueField: 'key',
								textField: 'value',
							
								url: '/ComboxService/getComboxs.do?codetablename=COD_GROUNDUSECODE'" />
							</td>
							<td align="right">
								土地证类型：
							</td>
							<td>
								<input id="landcertificatetype" name="landcertificatetype" style="width:200px;" class="easyui-combobox"  disabled='true' data-options="
								valueField: 'key',
								textField: 'value',
								url: '/ComboxService/getComboxs.do?codetablename=COD_LANDCERTIFICATETYPE'" />
							</td>
							
							
						</tr>
						<tr> 
							
							<td align="right">
								土地证号：
							</td>
							<td>
								<input id="landcertificate" class="easyui-validatebox"style="width:200px;" type="text" name="landcertificate"  disabled='true' data-options=""></input>
							</td>
							<td align="right">
								发证日期：
							</td>
							<td>
								<input id="landcertificatedates" name='landcertificatedates' class="easyui-datebox" disabled='true' style="width:200px;" data-options="validType:['datecheck'],required:false" ></input>
							</td>
						</tr>
						
						<tr>
							<td align="right">
								使用年限起：
							</td>
							<td >
								<input id="limitbegins" name='limitbegins' class="easyui-datebox" style="width:200px;" disabled='true' data-options="validType:['datecheck','isAfter[\'#limitends\']']"></input>
							</td>
							<td align="right">
								使用年限止：
							</td>
							<td >
								<input id="limitends" name='limitends' class="easyui-datebox" style="width:200px;" disabled='true' data-options="validType:'datecheck'"></input>
							</td>
						</tr>
						<tr>
							<td rowspan="3" align="center" style="padding:20px;">
								土地坐落地
							</td>
							<td align="right">
								类型：
							</td>
							<td colspan="3">
								<input id="locationtype" name="locationtype" style="width:400px;" class="easyui-combobox" editable='false' disabled='true' data-options="
								valueField: 'key',
								textField: 'value',
								url: '/ComboxService/getComboxs.do?codetablename=COD_LOCATIONTYPE'" />
							</td>
						</tr>
						
						<tr>
							<td align="right">
								坐落位置：
							</td>   
							<td colspan="3">
								<input id="belongtowns" name="belongtowns" style="width:400px;" class="easyui-combobox" disabled='true' editable='false'  data-options="
								valueField: 'key',
								textField: 'value',
								data:locationdata"  />
							</td>
						</tr>
						
						<tr>
							<td align="right">
								详细地址：
							</td>
							<td colspan="3">
								<input id="detailaddress" class="easyui-validatebox" style="width:400px;" type="text" name="detailaddress"  disabled='true' data-options=""></input>
							</td>
						</tr>
						<tr>
							<td align="right">
								收回日期：
							</td>
							<td>  
								<input id="recoverdates" name='recoverdates' class="easyui-datebox" style="width:200px;" data-options="validType:['datecheck']" ></input>
								<span style="color:red;font-weight: bold;font-size: 12pt">*</span>
							</td>
							<td align="right">
								收回土地面积（平方米）：
							</td>
							<td>
								<input id="recoverlandarea" class="easyui-numberbox" style="width:200px;text-align:right" type="text" name="recoverlandarea" data-options="min:0" precision="2" value="0.00" style="text-align:right" /><font color="red" id="maxgroundarea"></font></input>
								<span style="color:red;font-weight: bold;font-size: 12pt">*</span><font color="red" id="maxgroundarea"></font>
							</td>
						</tr>
						<tr>
							<td align="right">
								收回原因：
							</td>
							<td colspan="3">
								<input id="recovereason" class="easyui-validatebox" style="width:400px;" type="text" name="recovereason"  data-options=""></input>
								<span style="color:red;font-weight: bold;font-size: 12pt">*</span>
							</td>
						</tr>
						<br>
						<!--  
						<tr> 
							<td align="right">州市地税机关：</td> 
							<td>
								<input class="easyui-combobox" name="registertaxorgsupcode" id="registertaxorgsupcode" style="width:200px" disabled='true' data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
							</td>
							<td align="right">县区地税机关：</td>
							<td>
								<input class="easyui-combobox" name="registertaxorgcode" id="registertaxorgcode" style="width:200px" disabled='true' data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
							</td>
						<tr>
							<td align="right">主管地税部门：</td>
							<td>
								<input class="easyui-combobox" name="registertaxdeptcode" id="registertaxdeptcode" style="width:200px" disabled='true' data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
							</td>
							<td align="right">税收管理员：</td>
							<td>
								<input class="easyui-combobox" name="registertaxmanagercode" style="width:200px" id="registertaxmanagercode" disabled='true' data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
							</td>
						</tr>
						-->
					</table>  
					<div align='center'><br><br> <a href="#"   class="easyui-linkbutton" data-options="iconCls:'icon-save',region:'center'" onclick=" businesssave()">保存</a>
					<a href="#"   class="easyui-linkbutton" data-options="iconCls:'icon-cancel',region:'center'" onclick=" winclose()">关闭</a>
					</div>
					
				</form>
			</div>
	</div>
	
	
	
	<div id="groundquerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地收回查询',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:300px;">
		<div class="easyui-panel" title="" style="width:900px;">
			<form id="groundqueryform" method="post">
				<table id="narjcxx" width="100%"  class="table table-bordered">
					<input type="hidden" name="businesscode" id="businesscode"/>
					
					<tr>
						<td align="right">计算机编码：</td>
						<td>
							<input id="querylessorid" class="easyui-validatebox" type="text" style="width:250px" name="querylessorid" onkeydown="if(event.keyCode==13)spelltaxpayerid(this)"/>
						</td>
						<td align="right">纳税人名称：</td>
						<td>
							<input id="querylessortaxpayername" class="easyui-validatebox" type="text" style="width:250px" name="querylessortaxpayername"/>
						</td>
					</tr>
					<!--  
					<tr>
						<td align="right">转入方计算机编码：</td>
						<td>
							<input id="querylesseesid" class="easyui-validatebox" type="text" style="width:250px" name="querylesseesid"/>
						</td>
						<td align="right">转入方名称：</td>
						<td>
							<input id="querylesseestaxpayername" class="easyui-validatebox" type="text" style="width:250px" name="querylesseestaxpayername"/>
						</td>
					</tr>
					-->
					<tr>
						<td align="right">州市地税机关：</td>
						<td>
							<input class="easyui-combobox" name="querytaxorgsupcode" style="width:250px" id="querytaxorgsupcode" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">县区地税机关：</td>
						<td>
							<input class="easyui-combobox" name="querytaxorgcode" style="width:250px" id="querytaxorgcode" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
					</tr>
					<tr>
						<td align="right">主管地税部门：</td>
						<td>
							<input class="easyui-combobox" name="querytaxdeptcode" style="width:250px" id="querytaxdeptcode" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">税收管理员：</td>
						<td>
							<input class="easyui-combobox" name="querytaxmanagercode" style="width:250px" id="querytaxmanagercode" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
					</tr>
					<tr>
						<td align="right">宗地编号：</td>
						<td>
							<input id="queryestateserialno" class="easyui-validatebox" type="text" style="width:250px" name="queryestateserialno"/>
						</td>
						<td align="right">土地坐落详细地址：</td>
						<td>
							<input id="querydetailaddress" class="easyui-validatebox" type="text" style="width:250px" name="querydetailaddress"/>
						</td>
					</tr>
					<tr>
						<td align="right" id='set_time' >收回土地时间：</td>
						<td colspan="3">
							<input id="queryholddatebegin" class="easyui-datebox" style="width:200px" name="queryholddatebegin"/>
						至
							<input id="queryholddateend" class="easyui-datebox"  style="width:200px" name="queryholddateend"/>
						</td>
					</tr>
					<tr>
						<td align="right">操作时间：</td>
						<td colspan="3">
							<input id="optdatebegin" class="easyui-datebox" style="width:200px" name="optdatebegin"/>
						至
							<input id="optdateend" class="easyui-datebox" style="width:200px"  name="optdateend"/>
						</td>
					</tr>
					<tr>
					<td align="right">状态：</td>
						<td>
							<select id="state" name="state"  class="easyui-combobox">
					            <option value="">所有</option>
					            <option value="0">未审核</option>
					            <option value="1" selected>已审核</option>
					            <option value="3">已终核</option>
					        </select>
				        </td>
				        <td colspan=2></td>
					</tr>
				</table>
			</form>
			<div style="text-align:center;padding:5px;">  
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick=" businessquery()">查询</a>
			</div>
		</div>
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
	
	
</body>
</html>
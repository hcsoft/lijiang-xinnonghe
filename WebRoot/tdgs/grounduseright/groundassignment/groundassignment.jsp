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
	var default_locationcode = '04';
	var redisplay1;
	var redisplay2;
	var landsource;
	var areasizeMessage='';
	var maxareasizeMessage = '';
	var orgdata = new Object;
	var empdata = new Object;
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
		*/
		
		
		$('#reginfogrid1').datagrid({
			fitColumns:'false',
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
										$.messager.alert('返回消息',JSON.stringify(jsondata));
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
										//$('#querytaxdeptcode').combobox("clear");
										//$('#taxempcode').combobox("clear");

										//$('#querytaxdeptcode').combobox({}).combobox('clear');
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
					businessquery();
	           }
	   });
	  
	   
		$('#groundlandstore').datagrid({
			fitColumns:false,
			pagination:false,
			/*
			columns:[[   
		        {field:'approvenumber',title:'批复文号',width:80,align:'center'},   
		        {field:'approvedate',title:'批复日期',width:80,align:'center'},   
		        {fifield:'location',title:'坐落位置',width:80,align:'center'},
		        {fifield:'areatotal',title:'批复总面积',width:80,align:'center'},
		        {fifield:'notused',title:'可划拨土地面积',width:80,align:'center'},
		        {fifield:'detailaddress',title:'详细地址',width:80,align:'center'} 
		    ]],
			*/
			
			view:$.extend({},$.fn.datagrid.defaults.view,{
					onAfterRender: function(target){
									$('#groundlandstore').datagrid('clearSelections');
								} 
			}),
			onClickRow:function(index){
				var row = $('#groundlandstore').datagrid('getSelected');
				$('#locationtype').combobox('setValue',default_locationcode);
				$('#belongtowns').combobox('setValue',row.location);
				$('#belongtowns').combobox('setText',row.locationname);
				$('#detailaddress').val(row.detailaddress);
				$('#landstoresubid').val(row.landstoresubid);
				$('#landstoreid').val(row.landstoreid);
				maxgroundarea = row.notused;
					$('#maxgroundarea').html(areasizeMessage+maxgroundarea+'平方米');
				   
			},
			onLoadSuccess:function(){
				//$(".datagrid-row").mouseover(function(){  
				///	var obj = $(this).children("td").eq(2);
				//	var text = obj.text();
				//	obj.hover(function(){
				//		$(".content").show();
				//	});
					//alert(text);
				//});
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
						$('#groundsellquerywindow').window('open');
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
								window.open("/GroundUserightServlet/exportBusi.do?"+param, '',
						           'top=100,left=250,width=600,height=100,toolbar=no,menubar=no,location=no');  
						        //CommonUtils.downloadFile("/GroundUserightServlet/exportBusi.do?date="+new Date(),param); 
							}
							});
						}
					
				},{
					id:'assignment_addmenu',
					text:'新增划拨',
					iconCls:'icon-add',
					handler:function(){
						$('#groundAssignmentAddwindow').window('open');
						$('#groundlandstore').datagrid('loadData',{total:0,rows:[]});
						$('#maxgroundarea').html('');
						$('#groundform').form('clear');
						//添加查询条件和grid,改变groundAssignmentAddwindow高度
				   	  	$('#groundAssignmentAddwindow').prepend(redisplay1);
				   	  	$('#groundAssignmentAddwindow').prepend(redisplay2);
				   	  	$('#groundAssignmentAddwindow').window('resize',{width:980,height:610});
				   	  	$('#groundlandstore').datagrid('loadData',{total:0,rows:[]});
						
						
						if(businesstype == '11' ){
							
							$('#landsource').combobox('setValue','01');
							$('#landsource').combobox('setText','出让');
						}
						
						if(businesstype == '12' ){
							
							$('#landsource').combobox('setValue','08');
							$('#landsource').combobox('setText','划拨');
							
						}
					}
				},
				{
					id:'edit',
					text:'修改',
					iconCls:'icon-edit',
					handler:function(){
						//$('#groundsellquerywindow').window('open');
						var row = $('#groundbusigrid').datagrid('getSelected');
						if (row){
							var busid = row.busid;
							
							$.ajax({
									   type: "post",
									   url: "/GroundUserightServlet/queryGroundBusiForEdit.do",
									   data: {busid: busid,businesstype:businesstype},
									   dataType: "json",
									   success: function(jsondata){
									   	  	$('#groundAssignmentAddwindow').window('open');
									   	  //	$('#groundform').form('clear');
									   	  	$("#groundAssignmentAddwindow").panel({title:''});
									   	  	$('#groundlandstore').datagrid('loadData',{total:0,rows:[]});
									   	  	$('#groundform').form('load',jsondata);	
									   	  	maxgroundarea = jsondata.maxlandarea;
											$('#maxgroundarea').html(areasizeMessage+maxgroundarea+'平方米');
									   	  	//叉掉查询条件和grid,改变groundAssignmentAddwindow高度
									   	  	//redisplay1 = $('#landstorediv').detach();
									   	  	//redisplay2 = $('#querydiv').detach()
									   	  	//$('#groundAssignmentAddwindow').window('resize',{width:980,height:410});
									   	  	
									   	  	$('#registertaxorgsupcode').combobox('setValue',jsondata.taxorgsupcode);
											$('#registertaxorgcode').combobox('setValue',jsondata.taxorgcode);
											$('#registertaxdeptcode').combobox('setValue',jsondata.taxdeptcode);
											$('#registertaxmanagercode').combobox('setValue',jsondata.taxmanagercode);
											//$('#registertaxorgsupcode').combobox('setText',jsondata.taxorgsupcode);
											$('#registertaxorgcode').combobox('setText',jsondata.taxorgcode_name);
											$('#registertaxdeptcode').combobox('setText',jsondata.taxdeptcode_name);
											$('#registertaxmanagercode').combobox('setText',jsondata.taxmanagercode_name);
											$('#registertaxorgsupcode').combobox('disable');
											$('#registertaxorgcode').combobox('disable');
											$('#registertaxdeptcode').combobox('disable');
											$('#registertaxmanagercode').combobox('disable');
											
											$('#countrytown').combobox('setValue',jsondata.belongtowns.substring(0,9));
											$('#belongtowns').combobox('setValue',jsondata.belongtowns);
											$("#estateid").val(jsondata.estateid);
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
							var params = {};
							params.businesscode = businesstype;
							params.busid = row.busid ;
							$.messager.confirm('提示','确定删除吗?',function(r){
								$.ajax({
									   type: "post",
									   url: "/GroundUserightServlet/delGroundBusiness.do",
									   data: params,
									   dataType: "json",
									   success: function(jsondata){
										  $('#groundbusigrid').datagrid('reload');
										  $.messager.alert('返回消息',jsondata);
									   }
								});
							});
							
							
							
						}else{
							$.messager.alert('提示','请选择要删除的土地登记信息!');
						}
					}
				}
				/* ,{
					id:'check',
					text:'终审',
					iconCls:'icon-check',
					handler:function(){
						var row = $('#groundbusigrid').datagrid('getSelected');
						if (row) {
						var params = {};
						params.busid = row.busid ;
						params.estateid = row.estateid ;
						params.businesscode = businesstype;
						$.ajax({
						   type: "post",
						   url: "/GroundUserightServlet/finalCheckGroundBusi.do",
						   data: params,
						   dataType: "json",
						   success: function(jsondata){
							  $('#groundbusigrid').datagrid('reload');
						  $.messager.alert('返回消息','终审成功！');
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
								$.messager.alert('提示','请选择要撤销的土地信息!');
						}
					}
				} */
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
		
		 $('#landsource').combobox('getData');
		
		
		
		
		if(businesstype == '11' ){
			$('#assignment_time').html('出让时间');
			$('#notused_name').html('可出让土地面积');
			$('#assignment_addmenu span:last').html('新增出让');
			$("#groundassinfowin").panel({title:'土地出让信息'});
			$('#groundAssignmentAddwindow').panel({title:'土地出让'});
			$('#landsource').combobox('setValue','01');
			$('#landsource').combobox('setText','出让');
			
			$("#groundsellquerywindow").panel({title:'土地出让信息查询'});
			$("span:contains('可')").html('可出让土地面积（平方米）');
			areasizeMessage = '可出让土地面积';
			maxareasizeMessage = '出让面积不能大于可出让土地面积';
			
		}
		
		if(businesstype == '12' ){
			$('#assignment_time').html('划拨时间');
			
			$('#assignment_addmenu span:last').html('新增划拨');
			$("#groundassinfowin").panel({title:'土地划拨信息'});
			$('#groundAssignmentAddwindow').panel({title:'土地划拨'});
			$('#landsource').combobox('setValue','08');
			$('#landsource').combobox('setText','划拨');
			$("#groundsellquerywindow").panel({title:'土地划拨信息查询'});
			$("span:contains('可')").html('可划拨土地面积（平方米）');
			areasizeMessage = '可划拨土地面积';
			maxareasizeMessage = '划拨面积不能大于可划拨土地面积';
			
		}
		$('#landsource').combobox('disable');	
		
		/*****打开页面就查询查业务信息******/
		//setTimeout(businessquery,100);
		//businessquery();
		//businessquery();
	});

	
	
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
		$('#groundsellquerywindow').window('close');
	}
	function landstorequery(){
		var params = {};
		params.approvenumber = $('#approvenumber').val();
		params.name = $('#name').val();
		params.businesscode = businesstype;
		$('#groundlandstore').datagrid('loadData',{total:0,rows:[]});
		var opts = $('#groundlandstore').datagrid('options');
		opts.url = '/GroundUserightServlet/queryLandstoreInfos.do';
		$('#groundlandstore').datagrid('load',params); 
		var p = $('#groundlandstore').datagrid('getPager');  
	
		$('#groundlandstore').datagrid('unselectAll');
	}
	
	function Load() {  
		    $("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: $(window).height() }).appendTo("#groundAssignmentAddwindow");  
		    $("<div class=\"datagrid-mask-msg\"></div>").html("正在操作，请稍候。。。").appendTo("#groundAssignmentAddwindow").css({ display: "block", left: ($('#groundAssignmentAddwindow').outerWidth(true) - 190) / 2, top: ($('#groundAssignmentAddwindow').height() - 45) / 2 });  
	}  
  	  
	function dispalyLoad() {  
	    $(".datagrid-mask").remove();  
	    $(".datagrid-mask-msg").remove();  
	}
		
	function businesssave(){
			/*
			if(!$('#taxpayername').validatebox('isValid')){
				$.messager.alert('返回消息','纳税人名称不能为空或校验有误！');
				//$('#taxpayername')[0].focus();
				return;
			}
			*/
			if($('#taxpayername').val()==''){
				$.messager.alert('返回消息','纳税人名称不能为空或校验有误！');
				return;
			}
			/*
			if(!$('#purpose').combo('isValid')){
				$.messager.alert('返回消息','土地用途不能为空！');
				//$('.combo :text')[9].focus();
				return;
			}
			*/
			if( $('#purpose').combo('getValue')==''){
				$.messager.alert('返回消息','土地用途不能为空！');
				return;
			}
			if(!$('#holddates').datebox('isValid')){
				$.messager.alert('返回消息','起时间校验有误！');
				$('.datebox :text')[2].focus();
				return;
			}
			
			if($('#holddates').datebox('getValue')==''){
				$.messager.alert('返回消息','交付土地时间不能为空或校验有误！');
				//$('.datebox :text')[1].focus();
				return;
			}
		 	var dateb = $('#limitbegins').datebox('getValue');
			if($('#limitbegins').datebox('getValue')==''){
				$.messager.alert('返回消息','使用年限起校验有误！');
				//$('.datebox :text')[2].focus();
				return;
			}
			var datee = $('#limitends').datebox('getValue');
			if($('#limitends').datebox('getValue')==''){
				$.messager.alert('返回消息','使用年限止校验有误！');
				//$('.datebox :text')[1].focus();
				return;
			}
			
			if (datee<=dateb){
				$.messager.alert('返回消息','使用年限止校验有误！');
				return;
			}
		
			if( $('#locationtype').combo('getValue')==''){
				$.messager.alert('返回消息','土地坐落地类型不能为空！');
				return;
			}
			
			if( $('#belongtowns').combo('getValue')==''){
				$.messager.alert('返回消息','坐落位置不能为空！');
				return;
			}
			
			if($('#detailaddress').val()==''){
				$.messager.alert('返回消息','详细地址不能为空！');
				return;
			}
			
			
			
			if(!$('#landmoney').validatebox('isValid')){
				$.messager.alert('返回消息','成交价款不能为空！');
				return;
			}else {
				var landmoney = $('#landmoney').val();
				if(landmoney == 0){
					$.messager.alert('返回消息','成交价款必须大于0！');
					return;
				}
			}
			
			//landmoney landarea
			if(!$('#landarea').validatebox('isValid')){
				$.messager.alert('返回消息','土地面积不能为空！');
				return;
			}else{
				var landarea = $('#landarea').val();
				if(landarea>maxgroundarea){
					$.messager.alert('返回消息',maxareasizeMessage);
					return;
				}
				if(landarea == 0){
					$.messager.alert('返回消息','土地面积必须大于0！');
					return;
				}
			}
			
		Load();	
		var params = {};
		var fields =$('#groundform').serializeArray();
		$.each( fields, function(i, field){
			params[field.name] = field.value;
		});
		params.taxorgsupcode = $('#registertaxorgsupcode').combobox('getValue');
		params.taxorgcode = $('#registertaxorgcode').combobox('getValue');
		params.taxdeptcode = $('#registertaxdeptcode').combobox('getValue');
		params.taxmanagercode = $('#registertaxmanagercode').combobox('getValue');
		//宗地编号	
		params.estateserialno = $('#estateserialno').val();
		params.businesstype=businesstype;
		
		var busid = $('#busid').val();
		if (busid!=''&& busid != null){
			params.operatetype='modify';
			var row = $('#groundbusigrid').datagrid('getSelected');
			params.landstoreid = row.landstoreid;
			params.landstoresubid = row.landstoresubid;
		}else{  
			params.operatetype='add';
			var row = $('#groundlandstore').datagrid('getSelected');
			params.landstoreid = row.landstoreid;
			params.landstoresubid = row.landstoresubid;
			
		}
		var row = $('#groundbusigrid').datagrid('getSelected');
		
		params.m_estateid=$('#estateid').val();
		params.m_busid=$('#busid').val();
		
		//alert($.toJSON(params));
		
		$.ajax({
			type: "post",
			url: "/GroundUserightServlet/doGroundBusiness.do",
			data: params,
			dataType: "json",
			success: function(jsondata){
				dispalyLoad();
				$('#groundAssignmentAddwindow').window('close');
				var row = $('#groundbusigrid').datagrid('reload');
				$.messager.alert('返回消息',"保存成功");
				
			},
			error:function (data, status, e){  
				dispalyLoad(); 
				$.messager.alert('返回消息',"保存出错");   
			}   
		});
		
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
	function formatgrounduse(row){
		for(var i=0; i<groundusedata.length; i++){
			if (groundusedata[i].key == row) return groundusedata[i].value;
		}
		return row;
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
	function  winclose(){
		 $('#groundAssignmentAddwindow').window('close');
	} 
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
	
		<div title="土地划拨信息" data-options="
						tools:[{
						}]">
						<table id="groundbusigrid" style="height:550px;overflow:auto" 
						data-options="iconCls:'icon-edit',singleSelect:true" rownumbers="true"> 
							<thead>
								<tr>
									<!-- <th data-options="checkbox:true"></th> -->
									
									<th data-options="field:'busid',width:180,align:'center',hidden:true,editor:{type:'text'}">1</th>
									<th data-options="field:'estateid',width:180,align:'center',hidden:true,editor:{type:'text'}">2</th>
									<th data-options="field:'landstoreid',width:180,align:'center',hidden:true,editor:{type:'text'}">3</th>
									<th data-options="field:'landstoresubid',width:180,align:'center',hidden:true,editor:{type:'text'}">4</th>
									<th data-options="field:'businesscode',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'businessnumber',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'a',width:100,align:'center',formatter:uploadbutton">附件管理</th>
									<th data-options="field:'state',width:80,align:'left',editor:{type:'validatebox'}, formatter:function(value){return format_state(value)}">审核状态</th>
									<th data-options="field:'businesstypename',width:80,align:'left',editor:{type:'text'}">业务类型</th>
									<th data-options="field:'lessorid',width:100,align:'left',hidden:true,editor:{type:'validatebox'}">转出方计算机编码</th>
									<th data-options="field:'lessortaxpayername',width:200,align:'left',hidden:true,editor:{type:'validatebox'}">转出方名称</th>
									<th data-options="field:'lesseesid',width:100,align:'left',editor:{type:'validatebox'}">受让方计算机编码</th>
									<th data-options="field:'lesseestaxpayername',width:260,align:'left',editor:{type:'validatebox'}">受让方名称</th>
									<th data-options="field:'purpose',width:100,formatter:formatgrounduse,align:'left',editor:{type:'validatebox'}">土地用途</th>
									<th data-options="field:'protocolnumber',width:100,align:'left',editor:{type:'validatebox'}">协议书号</th>
									<th data-options="field:'holddates',width:110,align:'center',editor:{type:'validatebox'}">实际转移时间</th>
									<th data-options="field:'landarea',width:130,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">土地面积（平方米） </th>
									<th data-options="field:'landamount',width:100,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">总价（元）</th>
									<th data-options="field:'limitbegins',width:100,align:'center',editor:{type:'validatebox'}">使用起时间</th>
									<th data-options="field:'limitends',width:100,align:'center',editor:{type:'validatebox'}">使用止时间</th>
									<th data-options="field:'taxdeptcode',width:200,align:'center',formatter:formatorg,editor:{type:'validatebox'}">主管地税部门</th>
									<th data-options="field:'taxmanagercode',width:160,align:'center',formatter:formatemp,editor:{type:'validatebox'}">税收管理员</th>
								</tr>
							</thead>
						</table>
		</div>
	
	<div id="groundAssignmentAddwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地划拨',
		collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:980px;height:610px;">
		
			<!-- 查询条件 -->
			<div id='querydiv' style="text-align:center;width:950px;padding:5px;">  
						土地批复名称: <input id="name" type='text' name='name' style="width:120px" >
						土地批复文号: <input id="approvenumber" type='text' name='approvenumber'  style="width:120px" >
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick=" landstorequery()">查询</a>
			</div>
			<!-- 批复信息 -->
			<div id='landstorediv' style="width:950px;">
				<table id="groundlandstore" style="height:150px;overflow: auto"
					data-options="title:'土地批复信息',singleSelect:true,idField:'landstoreid'" rownumbers="true"> 
						<thead>
							<tr>
								<th data-options="field:'ck',checkbox:true"></th>
								<th data-options="field:'landstoreid',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
								<th data-options="field:'approvetype',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
								<th data-options="field:'name',width:240,align:'left',editor:{type:'validatebox'}">批复名称</th>
								<th data-options="field:'approvenumberlevel',width:80,align:'left',formatter:function(value,row,index){
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
									editor:{type:'validatebox'}">批复文号级别</th>
								<th data-options="field:'approvenumber',width:500,align:'left',editor:{type:'validatebox'}">批复文号</th>
								<th data-options="field:'approvedate',width:80,align:'center',editor:{type:'validatebox'}">批复日期</th>
								<th data-options="field:'locationname',width:150,align:'left',editor:{type:'validatebox'}">坐落位置</th>
								<th data-options="field:'areatotal',width:120,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">批复总面积（平方米）</th>
								<th id='notused_name' data-options="field:'notused',width:140,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">可划拨面积（平方米）</th>
								<th data-options="field:'detailaddress',width:80,align:'left',hidden:'true',editor:{type:'validatebox'}">详细地址</th>
								<th data-options="field:'landstoreid',width:80,align:'left',hidden:'false',editor:{type:'validatebox'}">收储主表主键</th>
								<th data-options="field:'landstoresubid',width:80,align:'left',hidden:'false',editor:{type:'validatebox'}">收储子表主键</th>
							</tr>
						</thead>
				</table>
			</div>
			<!-- 划拨信息 -->
			 
				<div id='groundassinfowin' class="easyui-panel" title="土地划拨信息"  style="width:950px;">
				<form id="groundform"    method="post">
					<table id="tdcrxx"  data-options="title:'土地划拨信息'"    class="table table-bordered" >
					<input type='hidden' value='' name = 'estateid' id ='estateid'/>
					<input type='hidden' value='' name = 'ploughid' id ='ploughid'/>
					<input type='hidden' value='' name = 'landstoreid' id ='landstoreid'/>
					<input type='hidden' value='' name = 'busid' id ='busid'/>
					<input type='hidden' value='' name = 'landstoresubid' id ='landstoresubid'/>
					<input type='hidden' value='' name = 'sourceestateid' id ='sourceestateid'/>
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
						<tr>
							<td align="right">
								土地来源：
							</td>
							<td>
								<input id="landsource" name="landsource" class="easyui-combobox easyui-validatebox" style="width:200px;"  data-options="
								valueField: 'key',
								textField: 'value',
								
								url: '/ComboxService/getComboxs.do?codetablename=COD_GROUNDSOURCECODE'"/>
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
						<tr>
							<td align="right">
								土地证类型：
							</td>
							<td>
								<input id="landcertificatetype" name="landcertificatetype" style="width:200px;" class="easyui-combobox"  data-options="
								valueField: 'key',
								textField: 'value',
								url: '/ComboxService/getComboxs.do?codetablename=COD_LANDCERTIFICATETYPE'" />
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
								交付土地时间：
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
								<input id="limitbegins" name='limitbegins' class="easyui-datebox" style="width:200px;" data-options="validType:['datecheck','isAfter[\'#limitends\']']"></input>
								<span style="color:red;font-weight: bold;font-size: 12pt">*</span>
							</td>
							<td align="right">
								使用年限止：
							</td>
							<td >
								<input id="limitends" name='limitends' class="easyui-datebox" style="width:200px;" data-options="validType:'datecheck'"></input>
								<span style="color:red;font-weight: bold;font-size: 12pt">*</span>
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
								<input id="locationtype" name="locationtype" style="width:400px;" class="easyui-combobox" editable='false' data-options="
								valueField: 'key',
								textField: 'value',
								
								url: '/ComboxService/getComboxs.do?codetablename=COD_LOCATIONTYPE'" />
								<span style="color:red;font-weight: bold;font-size: 12pt">*</span>
							</td>
						</tr>
						
						<tr>
							<td align="right">
								坐落位置：
							</td>   
							<td colspan="3">
								<input id="belongtowns" name="belongtowns" style="width:400px;" class="easyui-combobox" disabled="true" editable='false' data-options="
								valueField: 'key',
								textField: 'value',
								data:locationdata" />
								<span style="color:red;font-weight: bold;font-size: 12pt">*</span>
							</td>
						</tr>
						
						<tr>
							<td align="right">
								详细地址：
							</td>
							<td colspan="3">
								<input id="detailaddress" class="easyui-validatebox" style="width:400px;" type="text" name="detailaddress"  data-options=""></input>
								<span style="color:red;font-weight: bold;font-size: 12pt">*</span>
							</td>
						</tr>
						<tr>
							<td id='jk' align="right">
							成交价款（元）：
							</td>
							<td>
								<input id="landmoney" class="easyui-numberbox" value='0.00' style="width:200px;text-align:right" type="text" name="landmoney" data-options="min:0" precision="2" value="0.00" style="text-align:right" /></input>
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
					<tr> 
						<td align="right">
							宗地编号：
						</td>
						<td>
							<input id="estateserialno" class="easyui-validatebox" style="width:200px;" type="text" name="estateserialno"  data-options=""></input>
						</td>
						<td colspan=2></td>
						
						
					</tr>
					<tr>
						<td align="right">州市地税机关：</td> 
						<td>
							<input class="easyui-combobox" name="registertaxorgsupcode" id="registertaxorgsupcode" style="width:200px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">县区地税机关：</td>
						<td>
							<input class="easyui-combobox" name="registertaxorgcode" id="registertaxorgcode" style="width:200px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
					</tr>
					<tr>	
						<td align="right">主管地税部门：</td>
						<td>
							<input class="easyui-combobox" name="registertaxdeptcode" id="registertaxdeptcode" style="width:200px" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						
						
						<td align="right">税收管理员：</td>
						<td>
							<input class="easyui-combobox" name="registertaxmanagercode" style="width:200px" id="registertaxmanagercode" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
					</tr>
					</table>
					<div align='center' > <a href="#"   class="easyui-linkbutton" data-options="iconCls:'icon-save',region:'center'" onclick=" businesssave()">保存</a>
					<a href="#"   class="easyui-linkbutton" data-options="iconCls:'icon-cancel',region:'center'" onclick=" winclose()">关闭</a>
					</div>
					
					
				</form>
			</div>
	</div>
	
	
	
	<div id="groundsellquerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地出让信息查询',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:300px;">
		<div class="easyui-panel" title="" style="width:900px;">
			<form id="groundqueryform" method="post">
				<table id="narjcxx" width="100%"  class="table table-bordered">
					<input type="hidden" name="businesscode" id="businesscode"/>
					
					
					<tr>
						<td align="right">受让方计算机编码：</td>
						<td>
							<input id="querylesseesid" class="easyui-validatebox" type="text" style="width:250px" name="querylesseesid" onkeydown="if(event.keyCode==13)spelltaxpayerid(this)"/>
						</td>
						<td align="right">受让方名称：</td>
						<td>
							<input id="querylesseestaxpayername" class="easyui-validatebox" type="text" style="width:250px" name="querylesseestaxpayername"/>
						</td>
					</tr>
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
						<td align="right" id='assignment_time'  >划拨时间：</td>
						<td colspan="3">
							<input id="queryholddatebegin" class="easyui-datebox" style="width:250px" name="queryholddatebegin"/>
						至
							<input id="queryholddateend" class="easyui-datebox"  style="width:250px" name="queryholddateend"/>
						</td>
					</tr>
					<tr>
						<td align="right">操作时间：</td>
						<td colspan="3">
							<input id="optdatebegin" class="easyui-datebox" style="width:250px" name="optdatebegin"/>
						至
							<input id="optdateend" class="easyui-datebox" style="width:250px"  name="optdateend"/>
						</td>
					</tr>
					<tr>
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
												            <option value="3">已终审</option>
												        </select> -->
				        </td>
				        <td colspan=2></td>
					</tr>
				</table>
			</form>
			<div style="text-align:center;padding:5px;">  
					<a href="###" id ='businessquery' class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick=" businessquery()">查询</a>
			</div>
		</div>
	</div>
	
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
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

	<script>
	var locationdata = new Object;//所属乡镇缓存
	var levydatetypedata = new Object;//征期类型
	var taxtypedata = new Object;//税种
	var orgdata = new Object;//机关
	var empdata = new Object;//人员
	var statedata  =  new Object;//比对状态
	var opttype;//操作类型0:撤销审核,1:审核
	var showtype;//用作明细查看和修改的区分 0:明细查看,1:修改
	var locationtypedata = new Object;//坐落地类型
	var belongtocountry = new Array();
	var belongtowns = new Array();
	var statedata = new Object;//状态
	//var belongtodata = new Object;
	var menu1 = [{
					text:'查询',
					iconCls:'icon-search',
					handler:function(){
						$('#groundgathercheckquerywindow').window('open');
					}
				},{
					text:'明细查看',
					iconCls:'icon-tip',
					handler:showdetail
				},{
					text:'修改',
					id:'edit',
					iconCls:'icon-edit',
					handler:function(){
						var tdxxrow = $('#groundgathercheckgrid').datagrid('getSelected');//获取土地信息选中行
						if(tdxxrow){
							showtype ='1';
							$('#grounddetailwindow').window('open');//打开新录入窗口
							$('#grounddetailwindow').window('refresh', '../grounddetail/groundallinfo.jsp');
						}else{
							$.messager.alert('返回消息',"请选择需要修改的土地信息！");
						}
					}
				},{
					text:'导出',
					iconCls:'icon-export',
					handler:function(){
						$.messager.confirm('提示', '是否确认导出?', function(r){
							if (r){
								var params = {};
								var param='';
								var fields =$('#groundgathercheckqueryform').serializeArray();
								$.each( fields, function(i, field){
									params[field.name] = field.value;
									if(field.value!= ''){
										param=param+field.name+'='+field.value+'&';
									}
								}); 
								window.open("/GroundGatherCheckServlet/export.do?+'"+param+"'", '',
						           'top=1000,left=2500,width=1,height=1,toolbar=no,menubar=no,location=no');  
						       //window.open('/GroundGatherCheckServlet/export.do?'+escape(encodeURIComponent(param)), '',
						       //    'top=1000,left=2500,width=1,height=1,toolbar=no,menubar=no,location=no');  
								
							}
						});
					}
				},{
					id:'check',
					text:'审核',
					iconCls:'icon-check',
					handler:function(){
						var row = $('#groundgathercheckgrid').datagrid('getSelected');
						var intotaxscopeflag;
						if(row){
							if(row.state =='0'){
								$.messager.alert('提示消息',"该记录未提交，不能进行审核！");
								return;
							}
							if(row.state =='3'){
								$.messager.alert('提示消息',"该记录已审核！");
								return;
							}
							if(row.isuse =='1'){
								$.messager.alert('提示消息',"该记录有后续业务发生，不能审核！");
								return;
							}
							$.messager.confirm('提示框', '确认审核？',function(r){
								if(r){
							//		intotaxscopeflag = '1';
							//	}else{
							//		intotaxscopeflag ='0';
							//	}	
									Load();
									$.ajax({
									   type: "post",
									   url: "/GroundGatherCheckServlet/checkgatherinfo.do",
									   data: {estateid:row.estateid,opttype:1,intotaxscopeflag:'1'},
									   dataType: "json",
									   success: function(jsondata){
										  $.messager.alert('返回消息',jsondata);
										  $('#groundgathercheckgrid').datagrid('reload');
										  dispalyLoad();
									   }
									});
								}
							});
						}else{
							$.messager.alert('提示消息',"请选择需要审核的记录！");
							return;
						}
					}
				},{
					id:'cancelcheck',
					text:'撤销审核',
					iconCls:'icon-uncheck',
					handler:function(){
						var row = $('#groundgathercheckgrid').datagrid('getSelected');
						if(row){
							if(row.state =='0'){
								$.messager.alert('提示消息',"该记录未提交，不能撤销审核！");
								return;
							}
							if(row.isuse =='1'){
								$.messager.alert('提示消息',"该记录有后续业务发生，不能撤销审核！");
								return;
							}
							Load();
							$.ajax({
							   type: "post",
							   url: "/GroundGatherCheckServlet/checkgatherinfo.do",
							   data: {estateid:row.estateid,opttype:0,intotaxscopeflag:''},
							   dataType: "json",
							   success: function(jsondata){
								  $.messager.alert('返回消息',jsondata);
								  $('#groundgathercheckgrid').datagrid('reload');
								  dispalyLoad();
							   }
							});
						}else{
							$.messager.alert('提示消息',"请选择需要撤销审核的记录！");
							return;
						}
					}
				},{
					text:'应纳税预算',
					iconCls:'icon-export',
					id:'taxbudget',
					handler:function(){
						var rows=$('#groundgathercheckgrid').datagrid("getSelected");
						if(null==rows || ""==rows){
							$.messager.alert("提示","请选择记录!");
						}else{
							$('#taxabilitywindow').window('open');
							$('#taxabilitygrid').datagrid('loadData',{total:0,rows:[]});
							var opts = $('#taxabilitygrid').datagrid('options');
							opts.url = '/GroundGatherCheckServlet/gettaxinfo.do';
							$('#taxabilitygrid').datagrid('load',{taxpayerid:rows.taxpayerid,estateid:rows.newestateid,page:1}); 
						}
					}
				},{
					id:'finalcheck',
					text:'终审',
					iconCls:'icon-check',
					handler:function(){
						var row = $('#groundgathercheckgrid').datagrid('getSelected');
						var message = '是否确认终审？';
						if(row){
							if(row.state != '7'){
								message = '该纳税人未打印税源核实表，是否确认终审？';
							}
							$.messager.confirm('提示框', message,function(r){
								if(r){
									Load();
									$.ajax({
									   type: "post",
									   url: "/GroundGatherCheckServlet/finalcheck.do",
									   data: {estateid:row.estateid,taxpayerid:row.taxpayerid},
										   //GroundGatherCheckServleta
										   //landtaxflag
									   dataType: "json",
									   success: function(jsondata){
										   $.messager.defaults = { ok: "确定", cancel: "取消" };
										  $.messager.alert('返回消息',jsondata);
										  $('#groundgathercheckgrid').datagrid('reload');
										  dispalyLoad();
									   },
										error:function (data, status, e){   
											 $.messager.alert('返回消息',"终审失败！");
											  dispalyLoad();
										}
									});
								}
							})
							
						}else{
							$.messager.alert('提示消息',"请选择需要终审的记录！");
							return;
						}
					}
				},{
					id:'cancelfinalcheck',
					text:'撤销终审',
					iconCls:'icon-uncheck',
					handler:function(){
						var row = $('#groundgathercheckgrid').datagrid('getSelected');
						if(row){
							Load();
							$.ajax({
							   type: "post",
							   url: "/GroundGatherCheckServlet/cancelfinalcheck.do",
							   data: {estateid:row.estateid,taxpayerid:row.taxpayerid},
							   dataType: "json",
							   success: function(jsondata){
								  $.messager.alert('返回消息',jsondata);
								  $('#groundgathercheckgrid').datagrid('reload');
								  dispalyLoad();
							   },
								error:function (data, status, e){   
									 $.messager.alert('返回消息',"撤销终审失败！");
									 dispalyLoad();
								}
							});
						}else{
							$.messager.alert('提示消息',"请选择需要撤销终审的记录！");
							return;
						}
					}
				}];
			var menu2 = [{
					text:'查询',
					iconCls:'icon-search',
					handler:function(){
						$('#groundgathercheckquerywindow').window('open');
					}
				},{
					text:'明细查看',
					iconCls:'icon-tip',
					handler:showdetail
				},{
					text:'修改',
					id:'edit',
					iconCls:'icon-edit',
					handler:function(){
						var tdxxrow = $('#groundgathercheckgrid').datagrid('getSelected');//获取土地信息选中行
						if(tdxxrow){
							showtype ='1';
							$('#grounddetailwindow').window('open');//打开新录入窗口
							$('#grounddetailwindow').window('refresh', '../grounddetail/groundallinfo.jsp');
						}else{
							$.messager.alert('返回消息',"请选择需要修改的土地信息！");
						}
					}
				},{
					text:'导出',
					iconCls:'icon-export',
					handler:function(){
						$.messager.confirm('提示', '是否确认导出?', function(r){
							if (r){
								var params = {};
								var param='';
								var fields =$('#groundgathercheckqueryform').serializeArray();
								$.each( fields, function(i, field){
									params[field.name] = field.value;
									param=param+field.name+'='+field.value+'&';
								}); 
								window.open("/GroundGatherCheckServlet/export.do?+'"+param+"'", '',
						           'top=1000,left=2500,width=1,height=1,toolbar=no,menubar=no,location=no');
						       //window.open('/GroundGatherCheckServlet/export.do?'+escape(encodeURIComponent(param)), '',
						       //    'top=1000,left=2500,width=1,height=1,toolbar=no,menubar=no,location=no');  
								
							}
						});
					}
				},{
					id:'check',
					text:'审核',
					iconCls:'icon-check',
					handler:function(){
						var row = $('#groundgathercheckgrid').datagrid('getSelected');
						var intotaxscopeflag;
						if(row){
							if(row.state =='0'){
								$.messager.alert('提示消息',"该记录未提交，不能进行审核！");
								return;
							}
							if(row.state =='3'){
								$.messager.alert('提示消息',"该记录已审核！");
								return;
							}
							if(row.isuse =='1'){
								$.messager.alert('提示消息',"该记录有后续业务发生，不能审核！");
								return;
							}
							$.messager.confirm('提示框', '确认审核？',function(r){
								if(r){
							//		intotaxscopeflag = '1';
							//	}else{
							//		intotaxscopeflag ='0';
							//	}
									Load();
									$.ajax({
									   type: "post",
									   url: "/GroundGatherCheckServlet/checkgatherinfo.do",
									   data: {estateid:row.estateid,opttype:1,intotaxscopeflag:'1'},
									   dataType: "json",
									   success: function(jsondata){
										  $.messager.alert('返回消息',jsondata);
										  $('#groundgathercheckgrid').datagrid('reload');
										  dispalyLoad();
									   }
									});
								}
							});
						}else{
							$.messager.alert('提示消息',"请选择需要审核的记录！");
							return;
						}
					}
				},{
					id:'cancelcheck',
					text:'撤销审核',
					iconCls:'icon-uncheck',
					handler:function(){
						var row = $('#groundgathercheckgrid').datagrid('getSelected');
						if(row){
							if(row.state =='0'){
								$.messager.alert('提示消息',"该记录未提交，不能撤销审核！");
								return;
							}
							if(row.isuse =='1'){
								$.messager.alert('提示消息',"该记录有后续业务发生，不能撤销审核！");
								return;
							}
							Load();
							$.ajax({
							   type: "post",
							   url: "/GroundGatherCheckServlet/checkgatherinfo.do",
							   data: {estateid:row.estateid,opttype:0,intotaxscopeflag:''},
							   dataType: "json",
							   success: function(jsondata){
								  $.messager.alert('返回消息',jsondata);
								  $('#groundgathercheckgrid').datagrid('reload');
								  dispalyLoad();
							   }
							});
						}else{
							$.messager.alert('提示消息',"请选择需要撤销审核的记录！");
							return;
						}
					}
				},{
					text:'应纳税预算',
					iconCls:'icon-export',
					id:'taxbudget',
					handler:function(){
						var rows=$('#groundgathercheckgrid').datagrid("getSelected");
						if(null==rows || ""==rows){
							$.messager.alert("提示","请选择记录!");
						}else{
							$('#taxabilitywindow').window('open');
							$('#taxabilitygrid').datagrid('loadData',{total:0,rows:[]});
							var opts = $('#taxabilitygrid').datagrid('options');
							opts.url = '/GroundGatherCheckServlet/gettaxinfo.do';
							$('#taxabilitygrid').datagrid('load',{taxpayerid:rows.taxpayerid,estateid:rows.newestateid,page:1}); 
						}
					}
				}];
	Date.prototype.format = function(format,now) {
	    /*
	     * eg:format="yyyy-MM-dd hh:mm:ss";
	     */
	
	    var d = now ? (new Date(Date.parse(now.replace(/-/g,   "/")))) : this;
	    var o = {
	        "M+" : d.getMonth() + 1, // month
	        "d+" : d.getDate(), // day
	        "h+" : d.getHours(), // hour
	        "m+" : d.getMinutes(), // minute
	        "s+" : d.getSeconds(), // second
	        "q+" : Math.floor((d.getMonth() + 3) / 3), // quarter
	         "N+" : ["星期日","星期一","星期二","星期三","星期四","星期五","星期六"][d.getDay()],
	        "S" : d.getMilliseconds()// millisecond
	    }
	
	    if (/(y+)/.test(format)) {
	        format = format.replace(RegExp.$1, (d.getFullYear() + "").substr(4
	                        - RegExp.$1.length));
	    }
	
	    for (var k in o) {
	        if (new RegExp("(" + k + ")").test(format)) {
	            format = format.replace(RegExp.$1, RegExp.$1.length == 1
	                            ? o[k]
	                            : ("00" + o[k]).substr(("" + o[k]).length));
	        }
	    }
	    return format;
	}
	
	function dateformatter(value,row,index){
		return new Date(value).format("yyyy-MM-dd");
	}
	
	$(function(){
		//$.extend($.messager.confirms,{  
		//	ok:"a",  
		//	cancel:"b"  
		//});
		
		$.ajax({
			   type: "post",
				async:false,
			   url: "/InitGroundServlet/getlocationComboxs.do",
			   data: {},
			   dataType: "json",
			   success: function(jsondata){
				  //locationdata= jsondata;
				  var nulldetail={};
				  nulldetail.key='';
				  nulldetail.value='';
				  belongtocountry.push(nulldetail);
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
			   url: "/TransferGroundServlet/getlevydatetypeComboxs.do",
			   data: {},
			   dataType: "json",
			   success: function(jsondata){
				  levydatetypedata= jsondata;
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
			   data: {codetablename:'COD_TAXCODE'},
			   dataType: "json",
			   success: function(jsondata){
				  taxtypedata= jsondata;
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
			   data: {codetablename:'COD_COMPARESTATE'},
			   dataType: "json",
			   success: function(jsondata){
				  statedata= jsondata;
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
					var leaderflag = '<%=com.szgr.framework.authority.datarights.SystemUserAccessor.getInstance().getLeaderflag()%>';
					if(orgclass=='04'){
						$('#taxdeptcode').combobox("setValue",taxdeptcode);
						$('#taxmanagercode').combobox("setValue",taxempcode);
					}
					if(leaderflag=='01'){
						$('#groundgathercheckgrid').datagrid({toolbar:menu1});
					}else{
						$('#groundgathercheckgrid').datagrid({toolbar:menu2});
					}
//					query();
					var p = $('#groundgathercheckgrid').datagrid('getPager');  
					$(p).pagination({   
						showPageList:false,
						pageSize: 15
					});
//					var opts = $('#groundgathercheckgrid').datagrid('options');
//					opts.url = '/GroundGatherCheckServlet/getgathergroundinfo.do?taxorgsupcode=&taxorgcode&taxdeptcode='+taxdeptcode+'&taxmanagercode='+taxempcode;
	           }
	   });
			
			$('#groundgathercheckgrid').datagrid({
				fitColumns:false,
				maximized:'true',
				pagination:true,
				iconCls:'icon-edit',
				singleSelect:true,
				idField:'estateid',
				rownumbers:true,
				idField:'landstoreid',
				view:viewed,
				//toolbar:menu1,
				onClickRow:function(index){
					var row = $('#groundgathercheckgrid').datagrid('getSelected');
					//alert(row.state);
					$('#edit').linkbutton('disable');
					$('#check').linkbutton('disable');
					$('#cancelcheck').linkbutton('disable');
					$('#finalcheck').linkbutton('disable');
					$('#cancelfinalcheck').linkbutton('disable');
					$('#taxbudget').linkbutton('disable');
					if(row.state=='0'){//未提交
						$('#edit').linkbutton('enable');
					}
					if(row.state=='1'){//未审核
						$('#check').linkbutton('enable');
					}
					if(row.state=='3'){//已审核
						$('#cancelcheck').linkbutton('enable');
					}
					if(row.state=='5'){//已终审
						$('#taxbudget').linkbutton('enable');
						$('#cancelfinalcheck').linkbutton('enable');
					}
					if(row.state=='6' || row.state=='7'){//已确认税源、已打印税源核实表
						$('#cancelcheck').linkbutton('enable');
						$('#taxbudget').linkbutton('enable');
						$('#finalcheck').linkbutton('enable');
					}
				}, 
			     onDblClickRow:function(rowIndex, rowData){
			    	  showdetail();
				},
				onLoadSuccess:function(data){
					//alert(data.countpayer);
					var p = $('#groundgathercheckgrid').datagrid('getPager');  
					$(p).pagination({   
						showPageList:false,
						pageSize: 15,
						displayMsg:'总户数:'+data.countpayer+'户,显示{from}到{to}, 共{total}条记录'
					});
				}
			});
			//onAfterRender
			
			$('#grounddetailwindow').window({
				onClose:function(){
					$('#grounddetailwindow').window('refresh', '../blank.jsp');
					if(showtype =='1'){
						query();
					}
				}
			});
			
			$('#taxabilitygrid').datagrid({
				fitColumns:false,
				maximized:'true',
				pagination:true,
				singleSelect:true,
				rownumbers:true,
				columns:[[
					{field:'year',title:'所属年度',width:100,align:'center'},
					{field:'taxtypecode',title:'税种',width:100,formatter:formattypecode,align:'center'},
					{field:'taxability',title:'当前土地应纳税',width:100,align:'center'},
					{field:'taxabilitysum',title:'应纳税款总计',width:100,align:'center'},   
					{field:'alreadytaxabilitysum',title:'已缴税款',width:100,align:'right',align:'center'}   
				]],
				onLoadSuccess:function(data){
					var p = $('#taxabilitygrid').datagrid('getPager');  
					$(p).pagination({   
						showPageList:false,
						pageSize: 15
					});
				}
			});
			/*-- if(<security:authentication property='principal.taxorgcode'/>=='5301240006' || <security:authentication property='principal.taxorgcode'/>=='5301240008' ||<security:authentication property='principal.taxorgcode'/>=='5301240009'){
				$('#groundgathercheckgrid').datagrid({toolbar:menu1});
			}else{
				$('#groundgathercheckgrid').datagrid({toolbar:menu2});
			} --*/
			//$('#check').linkbutton('disable'); 
			//$('#cancelcheck').linkbutton('disable'); 
			$('#belongtocountrycode').combobox({   
				data:belongtocountry,   
				valueField:'key',   
				textField:'value'  
			});
			$('#locationtype').combobox({   
				data:locationtypedata,   
				valueField:'key',   
				textField:'value'  
			});
		});
		var viewed = $.extend({},$.fn.datagrid.defaults.view,{
				onAfterRender: function(target){
								$('#groundgathercheckgrid').datagrid('clearSelections');//页面重新加载时取消所有选中行
								} 
				});
		function query(){
			$('#groundgathercheckgrid').datagrid('loadData',{total:0,rows:[]});
			var params = {};
			var param='';
			var fields =$('#groundgathercheckqueryform').serializeArray();
			$.each( fields, function(i, field){
				params[field.name] = field.value;
				param=param+field.name+'='+field.value+'&';
			}); 
			//alert($.toJSON(params));
			var p = $('#groundgathercheckgrid').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false,
				pageSize: 15
			});
//			alert(param);
			var opts = $('#groundgathercheckgrid').datagrid('options');
			opts.url = '/GroundGatherCheckServlet/getgathergroundinfo.do';
			$('#groundgathercheckgrid').datagrid('load',params); 
			//$.messager.alert('返回消息',"1");
			$('#groundgathercheckquerywindow').window('close');
			
		}

	function showdetail(){
			var tdxxrow = $('#groundgathercheckgrid').datagrid('getSelected');//获取土地信息选中行
			if(tdxxrow){
				showtype ='0';
				$('#grounddetailwindow').window('open');//打开新录入窗口
				$('#grounddetailwindow').window('refresh', '../grounddetail/groundallinfo.jsp');
			}else{
				$.messager.alert('返回消息',"请选择需要查看的土地信息！");
			}
		}	
	
	function format(row){
		for(var i=0; i<belongtocountry.length; i++){
			if (belongtocountry[i].key == row) return belongtocountry[i].value;
		}
		return row;
	};
	function formatorg(row){
		for(var i=0; i<orgdata.length; i++){
			if (orgdata[i].key == row) return orgdata[i].value;
		}
		return row;
	};
	function formatemp(row){
		for(var i=0; i<empdata.length; i++){
			if (empdata[i].key == row) return empdata[i].value;
		}
		return row;
	};
	function formatstate(row){
		for(var i=0; i<statedata.length; i++){
			if (statedata[i].key == row) return statedata[i].value;
		}
		return row;
	}
	function formattypecode(row){
		for(var i=0; i<taxtypedata.length; i++){
			if (taxtypedata[i].key == row) return taxtypedata[i].value;
		}
		return row;
	}
	function formatlocationtype(row){
		for(var i=0; i<locationtypedata.length; i++){
			if (locationtypedata[i].key == row) return locationtypedata[i].value;
		}
		return row;
	}
	function Load() {  
    $("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: $(window).height() }).appendTo("body");  
    $("<div class=\"datagrid-mask-msg\"></div>").html("正在操作，请稍候。。。").appendTo("body").css({ display: "block", left: ($(document.body).outerWidth(true) - 190) / 2, top: ($(window).height() - 45) / 2 });  
	}  
  
//hidden Load   
function dispalyLoad() {  
    $(".datagrid-mask").remove();  
    $(".datagrid-mask-msg").remove();  
} 
	</script>
</head>
<body>
	<form id="groundtransferform" method="post">
		<div title="批复信息" data-options="
						tools:[{
							handler:function(){
								$('#groundgathercheckgrid').datagrid('reload');
							}
						}]">
					
						<table id="groundgathercheckgrid" style="overflow:auto" 
						> 
							<thead>
								<tr>
									<th data-options="field:'estateid',width:50,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'landsource',width:50,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'belongtowns',width:50,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'state',width:60,align:'center',formatter:function(value,row,index){return value=='0'?'未提交':(value=='1'?'未审核':(value=='3' || value=='6' || value=='7' ?'已审核':'已终审'));}">状态</th>
									<th data-options="field:'landtaxflag',width:100,align:'center',formatter:function(value,row,index){return value=='1'?'是':(value=='0'?'否':'未进行税源确认');}">是否纳入征税范围</th>
									<th data-options="field:'printflag',width:100,align:'center',formatter:function(value,row,index){return value=='1'?'是':'否';}">是否已打印确认表</th>
									<th data-options="field:'taxpayerid',width:100,align:'center',editor:{type:'validatebox'}">计算机编码</th>
									<th data-options="field:'taxpayername',width:200,align:'center',editor:{type:'validatebox'}">纳税人名称</th>
									<th data-options="field:'inputdates',width:80,align:'center',editor:{type:'validatebox'}">采集时间</th>
									<!-- <th data-options="field:'estateserial',width:100,align:'center',editor:{type:'combobox'}">宗地编号</th> -->
									<th data-options="field:'landcertificate',width:100,align:'center',editor:{type:'validatebox'}">土地证号</th>
									<th data-options="field:'holddates',width:80,align:'center',editor:{type:'validatebox'}">取得土地时间</th>
									<th data-options="field:'locationtype',width:80,align:'center',formatter:formatlocationtype,editor:{type:'validatebox'}">坐落地类型</th>
									<th data-options="field:'detailaddress',width:200,align:'center',editor:{type:'validatebox'}">详细地址</th>
									<th data-options="field:'landarea',width:60,align:'center',formatter:formatlocationtype,editor:{type:'validatebox'}">土地面积</th>
									<th data-options="field:'areaofstructure',width:100,align:'center',editor:{type:'validatebox'}">房产建筑面积</th>
									<th data-options="field:'housetaxoriginalvalue',width:100,align:'center',editor:{type:'validatebox'}">计税房产原值</th>
									<th data-options="field:'taxfreearea',width:100,align:'center',editor:{type:'validatebox'}">土地减免面积</th>
									<th data-options="field:'hirelandreducearea',width:150,align:'center',editor:{type:'validatebox'}">出租土地约定对方缴税面积</th>
									<th data-options="field:'hirehousesreducearea',width:150,align:'center',editor:{type:'validatebox'}">出租房屋约定对方缴税面积</th>
									<th data-options="field:'taxarea',width:100,align:'center',editor:{type:'validatebox'}">土地应税面积</th>
									<th data-options="field:'sellcomparestates',formatter:formatstate,width:100,align:'center',editor:{type:'validatebox'}">出让数据比对状态</th>
									<th data-options="field:'illegalcomparestates',formatter:formatstate,width:150,align:'center',editor:{type:'validatebox'}">未批先占数据比对状态</th>
									<th data-options="field:'estatecomparestates',formatter:formatstate,width:100,align:'center',editor:{type:'validatebox'}">地籍数据比对状态</th>
									<th data-options="field:'taxdeptcode',width:150,align:'center',formatter:formatorg,editor:{type:'validatebox'}">主管地税部门</th>
									<th data-options="field:'taxmanagercode',width:100,align:'center',formatter:formatemp,editor:{type:'validatebox'}">税收管理员</th>
									<th data-options="field:'isuse',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
								</tr>
							</thead>
						</table>
					
			</div>
	</form>
	<div id="groundgathercheckquerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地收储批复查询',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:300px;">
		<div class="easyui-panel" title="" style="width:900px;">
			<form id="groundgathercheckqueryform" method="post">
				<table id="narjcxx" class="table table-bordered">
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
						<td align="right">所属乡镇：</td>
						<td>
							<input class="easyui-combobox" name="belongtocountrycode" id="belongtocountrycode" style="width:200px" editable='false' data-options="
									valueField:'key',
									textField: 'value',
									data:belongtocountry
								"/>
						</td>
						<td align="right">坐落地类型：</td>
						<td>
							<input class="easyui-combobox" name="locationtype" id="locationtype" style="width:200px" editable='false' data-options="
									valueField:'key',
									textField: 'value',
									data:locationtypedata
								"/>
						</td>
					</tr>
					<tr>
						<td align="right">计算机编码：</td>
						<td><input id="querytaxpayerid" class="easyui-validatebox" type="text" style="width:200px" name="querytaxpayerid"/></td>
						<td align="right">纳税人名称：</td>
						<td>
							<input id="querytaxpayername" class="easyui-validatebox" type="text" style="width:200px" name="querytaxpayername"/>
						</td>
					</tr>
					<tr>
						<td align="right">数据状态：</td>
						<td colspan="3">
							<select id="state" class="easyui-combobox" name="state" style="width:200px"  editable="false">
								<option value=""></option>
								<option value="0">未提交</option>
								<option value="1">未审核</option>
								<option value="3,6,7">已审核</option>
								<option value="5">已终审</option>
							</select>
						</td>
					</tr>
				</table>
			</form>
			<div style="text-align:center;padding:1px;">  
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="query()">查询</a>
			</div>
		</div>
	</div>
	<div id="grounddetailwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地明细信息',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:960px;height:500px;">
	</div>
	<div id="groundbusinesswindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地业务',collapsible:false,minimizable:false,maximizable:false,closable:true,resizable:false" style="width:960px;height:500px;">
	</div>
	<div id="reginfowindow" class="easyui-window" data-options="closed:true,modal:true,title:'纳税人登记信息',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:620px;height:470px;">
	</div>
	<div id="landdetail_windows" class="easyui-window" data-options="closed:true,modal:true,title:'土地信息',collapsible:false,minimizable:false,maximizable:false,closable:true">
			<div align="left"><font color="red">说明 :  选中项生成应纳税,未选中项不生成应纳税、并且在税源核实表中应纳税为0.</font></div>
			<table id="landdetailgrid" style="width:750px"></table>
	</div>
	<div id="taxabilitywindow" class="easyui-window" data-options="closed:true,modal:true,title:'应纳税预算',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:620px;height:470px;">
		<table id="taxabilitygrid" style="width:580px"></table>
	</div>
</body>
</html>
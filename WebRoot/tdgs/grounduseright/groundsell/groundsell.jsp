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
	<script src="<%=spath%>/js/dropdown.js"></script>
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
	
	var menu11 = [{
					id:'query',
					text:'查询',
					iconCls:'icon-search',
					handler:function(){
						$('#groundsellquerywindow').window('open');
					}
				},{
					id:'showdetail',
					text:'明细查看',
					iconCls:'icon-tip',
					handler:function(){
						var tdxxrow = $('#groundlandstore').datagrid('getSelected');//获取土地信息选中行
						if(tdxxrow){
							$('#grounddetailwindow').window('open');//打开新录入窗口
							$('#grounddetailwindow').window('refresh', 'groundstoredetail.jsp');
						}else{
							$.messager.alert('返回消息',"请选择需要进行查看的土地信息！");
						}
					}
				},{
					id:'cr',
					text:'出让',
					iconCls:'icon-business1',
					handler:function(){
						var row = $('#groundlandstore').datagrid('getSelected');
						if(row){
							opttype='';
							businesstype = '11';
							landstoreid = row.landstoreid;
							$('#groundbusinesswindow').window('open');
							$('#groundbusinesswindow').window('refresh', 'groundstoresub.jsp');
						}else{
							$.messager.alert('返回消息',"请选择需要出让的批复！");
						}
					}
				}];
	var menu12 = [{
					id:'query',
					text:'查询',
					iconCls:'icon-search',
					handler:function(){
						$('#groundsellquerywindow').window('open');
					}
				},{
					id:'showdetail',
					text:'明细查看',
					iconCls:'icon-tip',
					handler:function(){
						var tdxxrow = $('#groundlandstore').datagrid('getSelected');//获取土地信息选中行
						if(tdxxrow){
							$('#grounddetailwindow').window('open');//打开新录入窗口
							$('#grounddetailwindow').window('refresh', 'groundstoredetail.jsp');
						}else{
							$.messager.alert('返回消息',"请选择需要进行查看的土地信息！");
						}
					}
				},{
					id:'hb',
					text:'划拨',
					iconCls:'icon-business2',
					handler:function(){
						var row = $('#groundlandstore').datagrid('getSelected');
						if(row){
							opttype='';
							businesstype = '12';
							landstoreid = row.landstoreid;
							$('#groundbusinesswindow').window('open');
							$('#groundbusinesswindow').window('refresh', 'groundstoresub.jsp');
						}else{
							$.messager.alert('返回消息',"请选择需要出让的批复！");
						}
					}
				}];
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
			$('#groundlandstore').datagrid({
				fitColumns:true,
				maximized:'true',
				pagination:true,
				idField:'landstoreid',
				view:$.extend({},$.fn.datagrid.defaults.view,{
						onAfterRender: function(target){
										$('#groundlandstore').datagrid('clearSelections');
									} 
				}),
				onClickRow:function(index){
					//var row = $('#groundlandstore').datagrid('getSelected');
					//selectindex = index;
					//selectid = row.landstoreid;
				}
			});
			$('#groundsellgrid').datagrid({
					fitColumns:'true',
					maximized:'true',
					pagination:true,
					idField:'ownerid',
					view: $.extend({},$.fn.datagrid.defaults.view,{
							onAfterRender: function(target){
											$('#groundsellgrid').datagrid('clearSelections');//页面重新加载时取消所有选中行
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
							//$('#groundsellquerywindow').window('open');
						}
					},{
						text:'新增出让',
						iconCls:'icon-add',
						handler:function(){
							$('#groundAssignmentAddwindow').window('open');
						}
					},
					{
						text:'修改',
						iconCls:'icon-edit',
						handler:function(){
							//$('#groundsellquerywindow').window('open');
						}
					},{
						text:'删除',
						iconCls:'icon-remove',
						handler:function(){
							//$('#groundsellquerywindow').window('open');
							//只有初始状态的可以删除
							var row = $('#groundsellgrid').datagrid('getSelected');
							var state =  row.state;
							if (state!='0'){
								$.messager.alert('提示','只有初始状态的可以删除!');
								return;
							}
							var  busid = row.busid;
							$.messager.alert('提示','删除'+busid);
						}
					},{
						text:'终审',
						iconCls:'icon-check',
						handler:function(){
							//$('#groundsellquerywindow').window('open');
						}
					},{
						text:'撤销终审',
						iconCls:'icon-uncheck',
						handler:function(){
							//$('#groundsellquerywindow').window('open');
						}
					}
					/*
					{
						text:'修改',
						iconCls:'icon-edit',
						id:'edit',
						handler:function(){
							var row = $('#groundsellgrid').datagrid('getSelected');
							if(row){
								opttype='edit';
								if(row.businesscode =='11' || row.businesscode =='12'){//出让
									landstoresubid = row.landstoresubid;
									targetestateid = row.targetestateid;
									businesstype = row.businesscode;
									busid = row.busid;
									taxpayerid = row.lesseesid;
									taxpayername = row.lesseestaxpayername;
									$('#groundbusinesswindow').window('open');
									$('#groundbusinesswindow').window('refresh', '../groundsell/reginfo.jsp');
								}
								if(row.businesscode =='13'){//未批先占
									targetestateid = row.targetestateid;
									businesstype = row.businesscode;
									busid = row.busid;
									$('#groundbusinesswindow').window('open');
									$('#groundbusinesswindow').window('refresh', '../groundnotapprovehold/reginfo.jsp');
								}
								if(row.businesscode =='21' || row.businesscode =='22' || row.businesscode =='23' || row.businesscode =='26'){//转让
									targetestateid = row.targetestateid;
									businesstype = row.businesscode;
									busid = row.busid;
									estateid = row.estateid;
									$('#groundbusinesswindow').window('open');
									$('#groundbusinesswindow').window('refresh', '../groundassignment/reginfo.jsp');
								}
							}else{
								alert("请选择需要修改的数据！");
							}
						}
					},{
						text:'土地所有权转移',
						iconCls:'icon-business5',
						handler:function(){
							$('#groundsellwindow').window('open');
							$('#groundlandstore').datagrid('loadData',{total:0,rows:[]});
						}
					}
					*/
					],
					onClickRow:function(rowIndex, rowData){
						if(rowData.state!='0'){
							$('#edit').linkbutton('disable');
						}else{
							$('#edit').linkbutton('enable');
						}
					}
				});
			var p = $('#groundsellgrid').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
				});

			var p = $('#groundlandstore').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
				});
			
			
			$('#grounddetailwindow').window({
				onClose:function(){
					$('#grounddetailwindow').window('refresh', '../blank.jsp');
				}
			});
		});

		function query(){
			var params = {};
			var fields =$('#groundsellqueryform1').serializeArray();
			$.each( fields, function(i, field){
				params[field.name] = field.value;
			}); 
			$('#groundlandstore').datagrid('loadData',{total:0,rows:[]});
			var opts = $('#groundlandstore').datagrid('options');
			opts.url = '/GroundSellServlet/getgroundstoreinfo.do';
			$('#groundlandstore').datagrid('load',params); 
			var p = $('#groundlandstore').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false,
				pageSize: 15
			});
			$('#groundsellquerywindow').window('close');
			
		}

		function businessquery(){
			var params = {};
			var fields =$('#groundsellqueryform').serializeArray();
			$.each( fields, function(i, field){
				params[field.name] = field.value;
			}); 
			alert('businesstype:'+businesstype);
			params.businesscode = businesstype;
			$('#groundsellgrid').datagrid('loadData',{total:0,rows:[]});
			var opts = $('#groundsellgrid').datagrid('options');
			opts.url = '/GroundCheckServlet/getgroundbusinessinfo.do';
			$('#groundsellgrid').datagrid('load',params); 
			var p = $('#groundsellgrid').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false,
				pageSize: 15
			});
			$('#groundsellgrid').datagrid('unselectAll');
			$('#groundsellquerywindow').window('close');
			
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
				   $('#groundlandstore').datagrid('reload');
				  $('#groundstorageeditwindow').window('close');
				  $.messager.alert('返回消息','保存成功！');
			   }
			});
		}

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
	</script>
</head>
<body>
	<form id="groundsellform" method="post">
		<div title="批复信息" data-options="
						tools:[{
							handler:function(){
								$('#groundsellgrid').datagrid('reload');
							}
						}]">
						
						<table id="groundsellgrid" style="overflow:auto" 
						data-options="iconCls:'icon-edit',singleSelect:true" rownumbers="true"> 
							<thead>
								<tr>
									<!-- <th data-options="checkbox:true"></th> -->
									<th data-options="field:'busid',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'estateid',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'businesscode',width:100,align:'center',formatter:formatbusiness,editor:{type:'text'}">业务类型</th>
									<th data-options="field:'lessorid',width:100,align:'center',editor:{type:'validatebox'}">转出方计算机编码</th>
									<th data-options="field:'lessortaxpayername',width:200,align:'center',editor:{type:'validatebox'}">转出方名称</th>
									<th data-options="field:'lesseesid',width:100,align:'center',editor:{type:'validatebox'}">转入方计算机编码</th>
									<th data-options="field:'lesseestaxpayername',width:200,align:'center',editor:{type:'validatebox'}">转入方名称</th>
									<th data-options="field:'purpose',width:50,formatter:formatgrounduse,align:'center',editor:{type:'validatebox'}">土地用途</th>
									<th data-options="field:'protocolnumber',width:100,align:'center',editor:{type:'validatebox'}">协议书号</th>
									<th data-options="field:'holddates',width:70,align:'center',editor:{type:'validatebox'}">实际转移时间</th>
									<th data-options="field:'landarea',width:60,align:'center',editor:{type:'validatebox'}">宗地面积</th>
									<th data-options="field:'landamount',width:60,align:'center',editor:{type:'validatebox'}">转出总价</th>
									<th data-options="field:'limitbegins',width:60,align:'center',editor:{type:'validatebox'}">转出起时间</th>
									<th data-options="field:'limitends',width:60,align:'center',editor:{type:'validatebox'}">转出止时间</th>
									<!-- <th data-options="field:'a',width:100,align:'center',formatter:uploadbutton">附件管理</th> -->
									<th data-options="field:'businessnumber',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'parentbusinessnumber',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'targetestateid',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
									<th data-options="field:'landstoresubid',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
								</tr>
							</thead>
						</table>
					
		</div>
		<!--  -->
	</form>
	
	<div id="groundAssignmentAddwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地出让',
		collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:960px;height:600px;">
		
			<!-- 查询条件 -->
			<div style="text-align:center;width:900px;padding:5px;">  
						土地批复名称: <input id="name" type='text' name='name' style="width:120px" >
						土地批复文号: <input id="taxpayername" type='text' name='taxpayername'  style="width:120px" >
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick=" businessquery()">查询</a>
			</div>
			<!-- 批复信息 -->
			<div  style="width:900px;">
				<table id="groundlandstore" style="height:200px;overflow: scroll"
					data-options="title:'土地批复信息',singleSelect:true,idField:'landstoreid'" rownumbers="true"> 
						<thead>
							<tr>
								<th data-options="field:'landstoreid',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
								<th data-options="field:'approvetype',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
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
								<th data-options="field:'areatotal',width:100,align:'center',editor:{type:'validatebox'}">批复总面积</th>
								<th data-options="field:'areasell',width:100,align:'center',editor:{type:'validatebox'}">可出让面积</th>
							</tr>
						</thead>
				</table>
			</div>
			<!-- 出让信息 -->
			
				<div class="easyui-panel" title="土地出让信息"  style="width:900px;">
				<form id="groundselldetailform"    method="post">
					<table id="tdcrxx"  data-options="title:'土地出让信息'"    class="table table-bordered" >
						<tr>
							<td align="right">
								计算机编码：
							</td>
							<td>
								<input id="taxpayerid" class="easyui-validatebox" type="text" style="width:200px;" name="taxpayerid" readOnly="true" data-options=""></input>
								<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="queryTaxpayerid()">查询</a>
							</td>
							<td align="right">
								纳税人名称：
							</td>
							<td>
								<input id="taxpayername" class="easyui-validatebox" type="text" style="width:200px;" name="taxpayername" readOnly="true" data-options=""></input>
								<span style="color:red;font-weight: bold;font-size: 12pt">*</span>
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
								<span style="color:red;font-weight: bold;font-size: 12pt">*</span>
							</td>
							<td align="right">
								土地用途：
							</td>
							<td>
								<input id="purpose" name="purpose" style="width:200px;" class="easyui-combobox"  data-options="
								valueField: 'key',
								textField: 'value',
								required:'true',
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
								<input id="holddates" name="holddates" class="easyui-datebox" style="width:200px;" data-options="validType:['datecheck'],required:true"></input>
								<span style="color:red;font-weight: bold;font-size: 12pt">*</span>
							</td>
						</tr>
						<tr>
							<td align="right">
								使用年限起：
							</td>
							<td >
								<input id="datebegins" name='datebegins' class="easyui-datebox" style="width:200px;" data-options="validType:'datecheck'"></input>
							</td>
							<td align="right">
								使用年限止：
							</td>
							<td >
								<input id="dateends" name='dateends' class="easyui-datebox" style="width:200px;" data-options="validType:'datecheck'"></input>
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
								required:'true',
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
								required:'true',
								data: locationdata" />
								<span style="color:red;font-weight: bold;font-size: 12pt">*</span>
							</td>
						</tr>
						
						<tr>
							<td align="right">
								详细地址：
							</td>
							<td colspan="3">
								<input id="detailaddress" class="easyui-validatebox" style="width:400px;" type="text" name="detailaddress" data-options="required:true"></input>
								<span style="color:red;font-weight: bold;font-size: 12pt">*</span>
							</td>
						</tr>
						<tr>
							<td align="right">
							土地总价(年租金)（元）：
							</td>
							<td>
								<input id="landmoney" class="easyui-numberbox" value='0.00' style="width:200px;text-align:right" type="text" name="landmoney" data-options="min:0,required:true" precision="2" value="0.00" style="text-align:right" /></input>
								<span style="color:red;font-weight: bold;font-size: 12pt">*</span>
							</td>
							<td align="right">
							土地面积（平方米）：
							</td>
							<td>
								<input id="landarea" class="easyui-numberbox" style="width:200px;text-align:right" type="text" name="landarea" data-options="min:0,required:true" precision="2" value="0.00" style="text-align:right" /><font color="red" id="maxgroundarea"></font></input>
								<span style="color:red;font-weight: bold;font-size: 12pt">*</span>
							</td>
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
						<td colspan=2></td>
					</tr>
					</table>
					<div align='center'> <a href="#"   class="easyui-linkbutton" data-options="iconCls:'icon-save',region:'center'" onclick=" businesssave()">保存</a></div>
					
				</form>
			</div>
			
			
			
		
	</div>
	
	<!-- 
	<div id="groundsellquerywindow1" class="easyui-window" data-options="closed:true,modal:true,title:'土地收储批复查询',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:300px;">
		<div class="easyui-panel" title="" style="width:900px;">
			<form id="groundsellqueryform1" method="post">
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
						<td align="right">计算机编码：</td>
						<td>
							<input id="querytaxpayerid" class="easyui-validatebox" type="text" style="width:200px" name="querytaxpayerid"/>
						</td>
						<td align="right">纳税人名称：</td>
						<td>
							<input id="querytaxpayername" class="easyui-validatebox" type="text" style="width:200px" name="querytaxpayername"/>
						</td>
						
					</tr>
					<tr>
						<td align="right">批复文号：</td>
						<td>
							<input id="queryapprovenumber" class="easyui-validatebox" type="text" style="width:200px" name="queryapprovenumber"/>
						</td>
						<td align="right">批复时间：</td>
						<td colspan="3">
							<input id="approvedatebegin" class="easyui-datebox" name="approvedatebegin"/>
						至
							<input id="approvedateend" class="easyui-datebox"  name="approvedateend"/>
						</td>
					</tr>
				</table>
			</form>
			<div style="text-align:center;padding:1px;">  
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="query()">查询</a>
			</div>
		</div>
	</div>
	 -->
	<div id="groundsellquerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地出让信息查询',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:300px;">
		<div class="easyui-panel" title="" style="width:900px;">
			<form id="groundsellqueryform" method="post">
				<table id="narjcxx" width="100%"  class="table table-bordered">
					<input type="hidden" name="businesscode" id="businesscode"/>
					
					<tr>
						<td align="right">转出方计算机编码：</td>
						<td>
							<input id="querylessorid" class="easyui-validatebox" type="text" style="width:200px" name="querylessorid"/>
						</td>
						<td align="right">转出方名称：</td>
						<td>
							<input id="querylessortaxpayername" class="easyui-validatebox" type="text" style="width:200px" name="querylessortaxpayername"/>
						</td>
					</tr>
					<tr>
						<td align="right">转入方计算机编码：</td>
						<td>
							<input id="querylesseesid" class="easyui-validatebox" type="text" style="width:200px" name="querylesseesid"/>
						</td>
						<td align="right">转入方名称：</td>
						<td>
							<input id="querylesseestaxpayername" class="easyui-validatebox" type="text" style="width:200px" name="querylesseestaxpayername"/>
						</td>
					</tr>
					<tr>
						<td align="right">转入方州市地税机关：</td>
						<td>
							<input class="easyui-combobox" name="querytaxorgsupcode" style="width:200px" id="querytaxorgsupcode" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">转入方县区地税机关：</td>
						<td>
							<input class="easyui-combobox" name="querytaxorgcode" style="width:200px" id="querytaxorgcode" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
					</tr>
					<tr>
						<td align="right">转入方主管地税部门：</td>
						<td>
							<input class="easyui-combobox" name="querytaxdeptcode" style="width:200px" id="querytaxdeptcode" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">转入方税收管理员：</td>
						<td>
							<input class="easyui-combobox" name="querytaxmanagercode" style="width:200px" id="querytaxmanagercode" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
					</tr>
					<tr>
						<td align="right">宗地编号：</td>
						<td>
							<input id="queryestateserialno" class="easyui-validatebox" type="text" style="width:200px" name="queryestateserialno"/>
						</td>
						<td align="right">土地坐落详细地址：</td>
						<td>
							<input id="querydetailaddress" class="easyui-validatebox" type="text" style="width:200px" name="querydetailaddress"/>
						</td>
					</tr>
					<tr>
						<td align="right">出让时间：</td>
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
				</table>
			</form>
			<div style="text-align:center;padding:5px;">  
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick=" businessquery()">查询</a>
			</div>
		</div>
	</div>
	<div id="groundsellwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地批复信息',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:960px;height:500px;">
		<div title="批复信息" data-options="
					tools:[{
						handler:function(){
							$('#groundlandstore').datagrid('reload');
						}
					}]">
				
					<table id="groundlandstore" style="overflow:auto"
					data-options="iconCls:'icon-edit',singleSelect:true,idField:'itemid'" rownumbers="true"> 
						<thead>
							<tr>
								<th data-options="field:'landstoreid',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
								<th data-options="field:'approvetype',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
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
								<th data-options="field:'areatotal',width:100,align:'center',editor:{type:'validatebox'}">批复总面积</th>
								<th data-options="field:'areasell',width:100,align:'center',editor:{type:'validatebox'}">可出让面积</th>
							</tr>
						</thead>
					</table>
		</div>
	</div>
	
	<!-- 查询选择纳税人窗口 -->
	<div id="choiceTaxpayerWin" class="easyui-window" style ='height:350px;' data-options="closed:true,modal:true,title:'纳税人信息',collapsible:false,minimizable:false,maximizable:false,closable:true">
			<div style="text-align:left;padding:5px;">  
				<div style="background-color: #c9c692;height: 25px;">		
						<span style="font-size: 12px; color:red; font-weight: bold;">查询条件：</span>
						<span style="font-size: 12px;">
						计算机编码<input  type="text" style="width:120px" id="query_taxpayerid1" name="query_taxpayerid1"/></span>
						纳税人名称<input  type="text" style="width:120px" id="query_taxtypename1" name="query_taxtypename1"/></span>
						<span style="font-size: 12px; color:red; font-weight: bold;">操作：</span>
						<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="regquery()" >查询</a>
						<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="reginput()" >关闭</a>
				</div>
			</div>
			<table id="reginfogrid1" style="width:700px;height:320px"
			data-options="iconCls:'icon-edit',singleSelect:true,fitColumns:true" rownumbers="true"> 
				<thead>
					<tr>
						<th data-options="field:'taxpayerid',width:120,align:'center',editor:{type:'validatebox'}">计算机编码</th>
						<th data-options="field:'taxpayername',width:200,align:'left',editor:{type:'validatebox'}">纳税人名称</th>
						<th data-options="field:'taxdeptcode',width:200,align:'center',editor:{type:'validatebox'}">主管地税部门</th>
						<th data-options="field:'taxmanagercode',width:120,align:'center',editor:{type:'validatebox'}">税收管理员</th>
					</tr>
				</thead>
			</table>
	</div>
</body>
</html>
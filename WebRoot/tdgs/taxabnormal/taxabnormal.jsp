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
	<script src="/js/datecommon.js"></script>
	<script src="/js/common.js"></script>
	<script>
	var taxdata = new Object;
	var taxtypecodedata = new Array();
	var taxcodedata = new Array();
	var taxorgdata = new Object;
	var taxempdata = new Object;
	var taxstatedata = [{'key':'3','value':'比对异常'},{'key':'2','value':'人工认定欠税'},{'key':'5','value':'人工认定完税'},{'key':'4','value':'比对完税'}];
	var opttypedata = [{'key':'','value':'未处理'},{'key':'2','value':'认定欠税'},{'key':'5','value':'认定完税'},{'key':'5','value':'人工认定完税'},{'key':'4','value':'比对完税'}];
	var taxpayerid;
	var taxcode;
	var taxdatebegin;
	var taxdateend;
	var type;//check:审核
	$(function(){
		//取得url参数
		var paraString = location.search;     
		var paras = paraString.split("&");   
		type = paras[0].substr(paras[0].indexOf("=") + 1);
		
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
					if(orgclass=='04'){
						if(type=='check'){
							$('#taxdeptcode').combobox("setValue",taxdeptcode);
						}else{
							$('#taxdeptcode').combobox("setValue",taxdeptcode);
							$('#taxmanagercode').combobox("setValue",taxempcode);
						}
						query();
					}
					
	           }
	   });
			$('#taxabnomalgrid').datagrid({
				//fitColumns:'true',
				maximized:'true',
				pagination:true,
				view:$.extend({},$.fn.datagrid.defaults.view,{
						onAfterRender: function(target){
										$('#taxabnomalgrid').datagrid('clearSelections');
									} 
						}),
				toolbar:[{
					text:'查询',
					iconCls:'icon-search',
					handler:function(){
						$('#taxabnomalquerywindow').window('open');
					}
				},{
					text:'导出',
					iconCls:'icon-export',
					handler:function(){
						$.messager.confirm('提示', '是否确认导出?', function(r){
							if (r){
								var param='';
								var fields =$('#taxabnomalqueryform').serializeArray();
								$.each( fields, function(i, field){
									if(field.value!= ''){
										param=param+field.name+'='+field.value+'&';
									}
								});
								param = param + '&querytype=0';
								window.open("/TaxabnormalServlet/export.do?"+param, '',
						           'top=1000,left=2500,width=1,height=1,toolbar=no,menubar=no,location=no');
							}
						});
					}
				}],
				onCheck:function(rowIndex,rowData){
					selectid = rowData.landstoreid;
				},
				onClickRow:function(index){
					var row = $('#taxabnomalgrid').datagrid('getSelected');
					$('#check').linkbutton('enable');
					$('#cancelcheck').linkbutton('enable');
					if(row.state=='1'){
						$('#cancelcheck').linkbutton('disable');
					}
					if(row.state=='2'){
						$('#check').linkbutton('disable');
						
					}
				},
				onSelectAll:function(rows){
					var row = rows[0];
					$('#check').linkbutton('enable');
					$('#cancelcheck').linkbutton('enable');
					if(row.state=='1'){
						$('#cancelcheck').linkbutton('disable');
					}
					if(row.state=='2'){
						$('#check').linkbutton('disable');
						
					}
				}
			});
			var p = $('#taxabnomalgrid').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
				});


			$('#detailgrid').datagrid({
				//fitColumns:'true',
				maximized:'true',
				pagination:true,
				view:$.extend({},$.fn.datagrid.defaults.view,{
						onAfterRender: function(target){
										$('#taxabnomalgrid').datagrid('clearSelections');
									} 
						}),
				toolbar:[{
					text:'导出',
					iconCls:'icon-export',
					handler:function(){
						$.messager.confirm('提示', '是否确认导出?', function(r){
							if (r){
								var param='';
								param = param+"taxpayerid="+$('#detailtaxpayerid').val();
								param = param+"&taxcode="+$('#detailtaxcode').val();
								param = param+"&taxdatebeginbegin="+$('#detailtaxdatebegin').val();
								param = param+"&taxdatebeginend="+$('#detailtaxdateend').val();
								param = param+"&taxdateendbegin="+$('#detailtaxdatebegin').val();
								param = param+"&taxdateendend="+$('#detailtaxdateend').val();
								param = param + '&querytype=1';
								window.open("/TaxabnormalServlet/export.do?"+param, '',
						           'top=1000,left=2500,width=1,height=1,toolbar=no,menubar=no,location=no');
							}
						});
					}
				}]
			});
			var p = $('#detailgrid').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
				});
			$.extend($.fn.datagrid.defaults.editors, {
							uploadfile: {
							init: function(container, options)
								{
									var editorContainer = $('<div/>');
									var button = $("<a href='###'></a>")
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
			$('#checktype').remove();
			if(type=='check'){
				$('#optwindow').window({title:'异常数据比对审核'});
				//$('#isopttext').remove();
				//$('#isoptselect').remove();
				//$('#isopt').combobox('setValue','1');
				//$('#isopt').combobox('disable');
				//$('#querychecktype').combobox('setValue','0');
			}else{
				$('#isopt').combobox('setValue','0');
				$('#querychecktype').combobox('setValue','');
			}
			$("#taxstate").combobox('setValues','3');
		});
	

		function query(){
			$('#taxabnomalgrid').datagrid('unselectAll');
			var params = {};
			var fields =$('#taxabnomalqueryform').serializeArray();
			$.each( fields, function(i, field){
				params[field.name] = field.value;
			}); 
			if(type=='check'){
				if(params.isopt!='1'){
					params.querychecktype ='0';
				}
			}
			params.querytype='0';
			//$('#taxabnomalgrid').datagrid('loadData',{total:0,rows:[]});
			var opts = $('#taxabnomalgrid').datagrid('options');
			opts.url = '/TaxabnormalServlet/gettaxabnormal.do';
			$('#taxabnomalgrid').datagrid('load',params); 
			var p = $('#taxabnomalgrid').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false,
				pageSize: 15
			});
			$('#taxabnomalgrid').datagrid('unselectAll');
			$('#taxabnomalquerywindow').window('close');
			
		}


	function format(row){
		for(var i=0; i<locationdata.length; i++){
			if (locationdata[i].key == row) return locationdata[i].value;
		}
		return row;
	}

	function uploadbutton(row){
		return '<a href="###" class="easyui-linkbutton" id=\'uploadbtn\' data-options=\'iconCls:\'icon-save\'\' onclick="uploadfile()">附件管理</a>';
	}
	//function quereyreg(){
	//	$('#reginfowindow').window('open');//打开新录入窗口
	//	$('#reginfowindow').window('refresh', 'reginfo.jsp');
	//}
	function uploadfile(){
		uploadModal.init("uploadbtn","02","111");
	}

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
		if(type != 'query'){
			if(type != 'check'){
				if(row.taxstate=='1' || row.taxstate=='3'){
					result = "<a href='###' onclick=\"showinfo(\'"+row.taxstate+"\',\'"+row.taxpayerid+"\',\'"+row.taxcode+"\',\'"+row.taxdatebegin+"\',\'"+row.taxdateend+"\')\">处理</a>";
				}
			}else{
				if(row.taxstate=='1' || row.taxstate=='3'){
					result = "<a href='###' onclick=\"showinfo(\'"+row.taxstate+"\',\'"+row.taxpayerid+"\',\'"+row.taxcode+"\',\'"+row.taxdatebegin+"\',\'"+row.taxdateend+"\')\">审核</a>";
				}
			}
		}
		result = result + "&nbsp;&nbsp;&nbsp;<a href='###' onclick=\"querydetail(\'"+row.taxpayerid+"\',\'"+row.taxcode+"\',\'"+row.taxdatebegin+"\',\'"+row.taxdateend+"\')\">明细查看</a>"
		return result;
	}
	function showinfo(qtaxstate,qtaxpayerid,qtaxcode,qtaxdatebegin,qtaxdateend){
		//alert(qtaxpayerid+'---'+qtaxcode+'---'+qtaxdatebegin+'---'+qtaxdateend);
		taxpayerid = qtaxpayerid;
		taxcode = qtaxcode;
		taxdatebegin = qtaxdatebegin;
		taxdateend = qtaxdateend;
		if(type != 'check'){
			$('#optwindow').window('open');
			$('#optwindow').window('refresh', 'operateinfo.jsp');
		}else{
			$('#optwindow').window('open');
			$('#optwindow').window('refresh', 'checkinfo.jsp');
		}
	}
	function changetype(v){
		alert(v);
		if(v=='0'){
			$('#querychecktype').combobox('setValue','');
			$('#querychecktype').combobox('disable');
		}else{
			$('#querychecktype').combobox('enable');
		}
	}
	function querydetail(taxpayerid,taxcode,taxdatebegin,taxdateend){
		$('#detailwindow').window('open');
		$('#detailtaxpayerid').val(taxpayerid);
		$('#detailtaxcode').val(taxcode);
		$('#detailtaxdatebegin').val(taxdatebegin);
		$('#detailtaxdateend').val(taxdateend);
		var params = {};
		params.taxpayerid = taxpayerid;
		params.taxcode = taxcode;
		params.taxdatebeginbegin = taxdatebegin;
		params.taxdatebeginend = taxdateend;
		params.taxdateendbegin = taxdatebegin;
		params.taxdateendend = taxdateend;
		$('#detailgrid').datagrid('loadData',{total:0,rows:[]});
		var opts = $('#detailgrid').datagrid('options');
		opts.url = '/TaxabnormalServlet/gettaxabnormal.do';
		$('#detailgrid').datagrid('load',params); 
		var p = $('#detailgrid').datagrid('getPager');  
		$(p).pagination({   
			showPageList:false,
			pageSize: 15
		});
	}

	</script>
</head>
<body>
	<form id="taxabnomalform" method="post">
		<div title="比对异常处理信息" data-options="">
					
						<table id="taxabnomalgrid" style="overflow:visible" 
						data-options="iconCls:'icon-edit',singleSelect:true" rownumbers="true"> 
							<thead>
								<tr>
									<th data-options="field:'taxstate',width:100,align:'center',formatter:function(value,row,index){
										for(var i=0; i<taxstatedata.length; i++){
											if (taxstatedata[i].key == value) return taxstatedata[i].value;
										}
										return value;
									},editor:{type:'validatebox'}">比对状态</th>
									<th data-options="field:'aaa',width:160,align:'center',formatter:addLinkLandInfo,editor:{type:'validatebox'}">处理</th>
									<th data-options="field:'opttype',width:60,align:'center',formatter:function(value,row,index){
										if(value==null || value==' '){
											return '未处理';
										}
										if(value=='2'){
											return '认定欠税';
										}
										if(value=='5'){
											return '认定完税';
										}
									},editor:{type:'validatebox'}">处理结果</th>
									<th data-options="field:'taxpayerid',width:100,align:'left',editor:{type:'validatebox'}">计算机编码</th>
									<th data-options="field:'taxpayername',width:200,align:'left',editor:{type:'validatebox'}">纳税人名称</th>
									<th data-options="field:'taxtypecode',width:200,align:'left',formatter:function(value,row,index){
										for(var i=0; i<taxdata.length; i++){
											if (taxdata[i].key == value) return taxdata[i].value;
										}
										return value;
									},
									editor:{type:'validatebox'}">税种</th>
									<th data-options="field:'taxcode',width:200,align:'left',formatter:function(value,row,index){
										for(var i=0; i<taxdata.length; i++){
											if (taxdata[i].key == value) return taxdata[i].value;
										}
										return value;
									},
									editor:{type:'validatebox'}">税目</th>
									<th data-options="field:'taxdatebegin',width:100,align:'center',editor:{type:'validatebox'}">税款所属起日期</th>
									<th data-options="field:'taxdateend',width:100,align:'center',editor:{type:'validatebox'}">税款所属止日期</th>
									<th data-options="field:'taxamount',width:100,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">应缴税款</th>
									<th data-options="field:'taxamountpaid',width:100,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">已缴税款</th>
									<th data-options="field:'taxamountdifferent',width:100,align:'right',editor:{type:'validatebox'}">差异税款</th>
									<!-- <th data-options="field:'levydatetype',width:60,align:'center',editor:{type:'validatebox'}">征期类型</th> -->
									<th data-options="field:'taxdeptcode',width:140,align:'left',formatter:function(value,row,index){
										for(var i=0; i<taxorgdata.length; i++){
											if (taxorgdata[i].key == value) return taxorgdata[i].value;
										}
										return value;
									},editor:{type:'validatebox'}">主管地税部门</th>
									<th data-options="field:'taxmanagercode',width:80,align:'left',formatter:function(value,row,index){
										for(var i=0; i<taxempdata.length; i++){
											if (taxempdata[i].key == value) return taxempdata[i].value;
										}
										return value;
									},editor:{type:'validatebox'}">税收管理员</th>
								</tr>
							</thead>
						</table>
					
			</div>
	</form>
	<div id="taxabnomalquerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'应纳税比对异常查询',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:300px;">
		<div class="easyui-panel" title="" style="width:900px;">
			<form id="taxabnomalqueryform" method="post">
				<table id="taxabnomaltable" width="100%"  class="table table-bordered">
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
					<tr id="comparetype">
						<td align="right">比对状态：</td>
						<td>
							<input class="easyui-combobox" name="taxstate" id="taxstate" data-options="
										valueField: 'value',
										textField: 'label',
										data: [{
											label: '全部',
											value: ''
										},{
											label: '比对异常',
											value: '3'
										},{
											label: '人工认定欠税',
											value: '2'
										},{
											label: '人工认定完税',
											value: '5'
										},{
											label: '比对完税',
											value: '4'
										}]" /><!-- 
																	<select id="taxstate" class="easyui-combobox" style="width:250px" name="taxstate" editable="false">
																		<option value="">全部</option>
																		<option value="1" >比对欠税</option>  暂时无该状态数据
																		<option value="3" selected>比对异常</option>
																		<option value="2">人工认定欠税</option>
																		<option value="5">人工认定完税</option>
																		<option value="4">比对完税</option>
																	</select> -->
						</td>
						<td align="right" id="isopttext">是否处理：</td>
						<td id="isoptselect">
							<input class="easyui-combobox" name="isopt" id="isopt" data-options="
										valueField: 'value',
										textField: 'label',
										data: [{
											label: '全部',
											value: ''
										},{
											label: '未处理',
											value: '0'
										},{
											label: '已处理',
											value: '1'
										}]" />
							<!-- <select id="isopt" class="easyui-combobox" style="width:250px" name="isopt" editable="false">
								<option value="" >全部</option>
								<option value="0" >未处理</option>
								<option value="1" >已处理</option>
							</select> -->
						</td>
					</tr>
					<tr id="checktype">
						<td align="right">审核状态：</td>
						<td colspan="3">
							<input class="easyui-combobox" name="querychecktype" id="querychecktype" data-options="
										valueField: 'value',
										textField: 'label',
										data: [{
											label: '全部',
											value: ''
										},{
											label: '待审核',
											value: '0'
										},{
											label: '审核通过',
											value: '1'
										},{
											label: '审核不通过',
											value: '2'
										}]" />
							<!-- <select id="querychecktype" class="easyui-combobox" style="width:250px" name="querychecktype" editable="false">
								<option value="" ></option>
								<option value="0" >待审核</option>
								<option value="1" >审核通过</option>
								<option value="2">审核不通过</option>
							</select> -->
						</td>
					</tr>
					<tr>
						<td align="right">税款所属期起：</td>
						<td colspan="3">
							<input id="taxdatebeginbegin" class="easyui-datebox" name="taxdatebeginbegin"/>
						至
							<input id="taxdatebeginend" class="easyui-datebox"  name="taxdatebeginend"/>
						</td>
					</tr>
					<tr>
						<td align="right">税款所属期止：</td>
						<td colspan="3">
							<input id="taxdateendbegin" class="easyui-datebox" name="taxdateendbegin"/>
						至
							<input id="taxdateendend" class="easyui-datebox"  name="taxdateendend"/>
						</td>
					</tr>
				</table>
			</form>
			<div style="text-align:center;padding:5px;">  
					<a href="###" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="query()">查询</a>
			</div>
		</div>
	</div>
	
	<div id="optwindow" class="easyui-window" data-options="closed:true,modal:true,title:'比对异常处理',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:400px;">
	</div>
	<div id="detailwindow" class="easyui-window" data-options="closed:true,modal:true,title:'明细查看',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:400px;">
		<form id="detailform" method="post">
			<input type="hidden" name="detailtaxpayerid" id="detailtaxpayerid"/>
			<input type="hidden" name="detailtaxcode" id="detailtaxcode"/>
			<input type="hidden" name="detailtaxdatebegin" id="detailtaxdatebegin"/>
			<input type="hidden" name="detailtaxdateend" id="detailtaxdateend"/>
		</form>
		<table id="detailgrid" style="overflow:visible" data-options="iconCls:'icon-edit',singleSelect:true" rownumbers="true">
			<thead>
				<tr>
					<th data-options="field:'taxstate',width:100,align:'center',formatter:function(value,row,index){
						for(var i=0; i<taxstatedata.length; i++){
							if (taxstatedata[i].key == value) return taxstatedata[i].value;
						}
						return value;
					},editor:{type:'validatebox'}">比对状态</th>
					<th data-options="field:'taxpayerid',width:100,align:'left',editor:{type:'validatebox'}">计算机编码</th>
					<th data-options="field:'taxpayername',width:200,align:'left',editor:{type:'validatebox'}">纳税人名称</th>
					<th data-options="field:'taxtypecode',width:200,align:'left',formatter:function(value,row,index){
						for(var i=0; i<taxdata.length; i++){
							if (taxdata[i].key == value) return taxdata[i].value;
						}
						return value;
					},
					editor:{type:'validatebox'}">税种</th>
					<th data-options="field:'taxcode',width:200,align:'left',formatter:function(value,row,index){
						for(var i=0; i<taxdata.length; i++){
							if (taxdata[i].key == value) return taxdata[i].value;
						}
						return value;
					},
					editor:{type:'validatebox'}">税目</th>
					<th data-options="field:'taxdatebegin',width:100,align:'center',editor:{type:'validatebox'}">税款所属起日期</th>
					<th data-options="field:'taxdateend',width:100,align:'center',editor:{type:'validatebox'}">税款所属止日期</th>
					<th data-options="field:'taxamount',width:100,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">应缴税款</th>
					<th data-options="field:'taxamountpaid',width:100,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">已缴税款</th>
					<th data-options="field:'taxamountdifferent',width:100,align:'right',editor:{type:'validatebox'}">差异税款</th>
					<!-- <th data-options="field:'levydatetype',width:60,align:'center',editor:{type:'validatebox'}">征期类型</th> -->
					<th data-options="field:'taxdeptcode',width:140,align:'left',formatter:function(value,row,index){
						for(var i=0; i<taxorgdata.length; i++){
							if (taxorgdata[i].key == value) return taxorgdata[i].value;
						}
						return value;
					},editor:{type:'validatebox'}">主管地税部门</th>
					<th data-options="field:'taxmanagercode',width:80,align:'left',formatter:function(value,row,index){
						for(var i=0; i<taxempdata.length; i++){
							if (taxempdata[i].key == value) return taxempdata[i].value;
						}
						return value;
					},editor:{type:'validatebox'}">税收管理员</th>
				</tr>
			</thead>
		</table>
	</div>
	</div>
	
</body>
</html>
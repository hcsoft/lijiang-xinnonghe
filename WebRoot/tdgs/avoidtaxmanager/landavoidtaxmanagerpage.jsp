<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<%@ include file="/common/inc.jsp"%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<base target="_self"/>
	<title></title>

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
	<script src="/js/datecommon.js"></script>	
	<script src="/js/common.js"></script>
	<script src="/js/widgets.js"></script>
	<script src="avoidmanager.js"></script>

    <script>
	
    function formatterDate(value,row,index){
			return formatDatebox(value);
	}
    
	$(function(){
		   AvoidManager.loadPage();
		   $('#avoidtaxgridsub').datagrid({
				 toolbar:[{
					text:'新增',
					iconCls:'icon-add',
					id:'add',
					handler:function(){
						openAddavoidInfo();
					}
				},{
					text:'删除',
					iconCls:'icon-cancel',
					id:'delete',
					handler:function(){
						deleteAvoidTaxInfo();
					}
				},{
					text:'修改',
					iconCls:'icon-edit',
					id:'edit',
					handler:function(){
						updateAvoidInfo();
					}
				}],
				onClickRow:function(index){
					var row = $('#avoidtaxgridsub').datagrid('getSelected');
					$('#add').linkbutton('enable');
					$('#delete').linkbutton('enable');
					$('#edit').linkbutton('enable');
					if(row.state=='2' || row.state=='3'){
						$('#add').linkbutton('disable');
						$('#delete').linkbutton('disable');
						$('#edit').linkbutton('disable');
					}
				}
			 });
		   var p = $('#avoidtaxgridsub').datagrid('getPager');
			$(p).pagination({
				showPageList:false,
				pageSize: 5
			});
	});
		function query(){
			AvoidManager.queryAvoidTax("12");
		}
		function openQuery(){
			$('#avoidtaxquerywindow').window('open');
		}
		function queryInfo(){
			AvoidManager.queryAvoidtaxinfosub("12");
		}
		
		
		//////////////////////////////////////////////////////////////////////////
		
		function updateInfo(){
			var row = $('#avoidtaxgrid').datagrid('getSelected');
			if(row == null){
				 $.messager.alert('提示消息','请选择需要修改的减免税记录!','info');
				 return;
			}
			var reduceid = row.taxreduceid;
			$('#avoidtaxinfoform').form('clear');
			$('#opertype').val("2");
			$.ajax({
					  type: "get",
					  async:false,
					  cache:false,
					  url: "/avoidtaxmanager/singleavoidtax.do?d="+new Date(),
					  data: {"taxreduceid":reduceid},
					  dataType: "json",
					  success:function(jsondata){
						  if(jsondata.sucess){
							  var avoidtaxbo = jsondata.result;
							  queryLand(avoidtaxbo.estateid);
							  
							  for(var p in avoidtaxbo){
								   var value = avoidtaxbo[p];
								   if(p.indexOf('date') >=0){
									   value = formatterDate(value);
								   }
								   var input = $('#avoidtaxaddwindow'+' #'+p);
								   if(input.hasClass("easyui-validatebox")){
										input.val(value);
								   }else if(input.hasClass("easyui-numberbox")){
									    input.numberbox('setValue',value);
								   }
								   else if(input.hasClass("easyui-datebox")){
										input.datebox('setValue',value);
								   }
								   else if(input.hasClass("easyui-combobox")){
										input.combobox('setValue',value);
								   }else{
									   input.val(value);
								   }
							  }
							  $('#avoidtaxaddwindow').window({title:'减免税修改'});
							  $('#avoidtaxaddwindow').window('open');
						  }else{
							  $.messager.alert('提示消息',jsondata.message,'info');
						  }
					  }
				  });
		}
		
		function updateAvoidInfo(){
			var row = $('#avoidtaxgridsub').datagrid('getSelected');
			if(row == null){
				 $.messager.alert('提示消息','请选择需要修改的减免税记录!','info');
				 return;
			}
			var reduceid = row.taxreduceid;
			//$('#avoidtaxinfoform').form('clear');
			$('#opertype').val("2");
			$.ajax({
					  type: "get",
					  async:false,
					  cache:false,
					  url: "/avoidtaxmanager/singleavoidtax.do?d="+new Date(),
					  data: {"taxreduceid":reduceid},
					  dataType: "json",
					  success:function(jsondata){
						  if(jsondata.sucess){
							  var avoidtaxbo = jsondata.result;
							  queryLand(avoidtaxbo.estateid);
							  for(var p in avoidtaxbo){
								   var value = avoidtaxbo[p];
								   if(p.indexOf('date') >=0){
									   value = formatterDate(value);
								   }
								   var input = $('#avoidtaxinfosubwindow'+' #'+p);
								   if(input.hasClass("easyui-validatebox")){
										input.val(value);
								   }else if(input.hasClass("easyui-numberbox")){
									    input.numberbox('setValue',value);
								   }
								   else if(input.hasClass("easyui-datebox")){
										input.datebox('setValue',value);
								   }
								   else if(input.hasClass("easyui-combobox")){
										input.combobox('setValue',value);
								   }else{
									   input.val(value);
								   }
							  }
							  $('#avoidtaxinfosubwindow').window({title:'减免税修改'});
							  $('#avoidtaxinfosubwindow').window('open');
						  }else{
							  $.messager.alert('提示消息',jsondata.message,'info');
						  }
					  }
				  });
		}
		
		function deleteAvoidTax(){
			AvoidManager.deleteAvoidTax();
		}
		function deleteAvoidTaxInfo(){
			AvoidManager.deleteAvoidTaxInfo();
		}
		function delegateLandStore(rowIndex,rowData){
			if(rowData){
				    $('#avoidtaxinfoform input[data-type="p"]').each(function(){
				    	var id = this.id;
				    	if(id){
				    		if(id in rowData){
				    			var value = rowData[id];
				    			if(id.indexOf('date') >= 0){
				    				value = formatterDate(value);
				    			}
								if(id.indexOf('area') >= 0 || id.indexOf('money') >= 0 || id.indexOf('price') >= 0){
				    				value = formatnumber(value);
				    			}
				    			$(this).val(value);
				    		}
				    	}
				    });
			}
			AvoidManager.queryAvoidtaxinfosub("12");
		} 
		function openLandQuery(){
			WidgetUtils.showChooseBaseEstate(delegateLandStore);
			$('#landquery').click();
		}
		function queryLand(estateid){
			var paramsArg = {};
			paramsArg['estateid'] = estateid;	
			$.ajax({
				  type: "get",
				  async:false,
				  cache:false,
				  url: "/landavoidtaxmanager/selectsingleland.do?d="+new Date(),
				  data: paramsArg,
				  dataType: "json",
				  success:function(jsondata){
					  if(jsondata.sucess){
						  var rowData = jsondata.result;
						  delegateLandStore(0,rowData);
					  }else{
						  $.messager.alert('错误','获取土地信息失败！','error');
					  }
				  }
			   });
		}
		//add 
		function openAdd(){
			$('#avoidtaxinfoform').form('clear');
			$('#avoidtaxgridsub').datagrid('loadData', { total: 0, rows: [] });
			$('#businesscode').val("92");
			$('#opertype').val("1"); //1新增 2修改
			 $('#avoidtaxaddwindow').window({title:'减免税新增'});
			$('#avoidtaxaddwindow').window('open');
			
		}
		function openAddavoidInfo(){
			var estateid =document.getElementById('estateid').value;
		    if(estateid==null || estateid==""){
		    	$.messager.alert('提示消息','请先选择土地信息','info');
		    	return;
		    }
			$('#avoidtaxinfosubform').form('clear');
			//$('#avoidtaxgridsub').datagrid('loadData', { total: 0, rows: [] });
			$('#businesscode').val("92");
			$('#opertype').val("1"); //1新增 2修改
			$('#taxtypecode').val("12");
			$('#avoidtaxinfosubwindow').window({title:'减免税新增'});
			$('#avoidtaxinfosubwindow').window('open');
		}
		function validateFormData(){
			var result = $('#avoidtaxinfoform').form('validate');
			if(!result){
				return false;
			}
			var inputAry = $('#avoidtaxinfosubform input[data-validate="p"]');
			result = CommonUtils.validateForm(inputAry);
			if(!result){
				return false;
			}
			//比较日期
			var beginDate = $('#reducebegindate').combobox('getValue');
			var endDate = $('#reduceenddate').combobox('getValue');
			if(endDate <= beginDate){
				$.messager.alert("提示消息","减免起日期必须小于减免止日期！",'info');
				return false;
			}
			var holddate = $('#holddate')[0].value;
			if(beginDate <= holddate){
				$.messager.alert("提示消息","减免起日期必须大于交付日期！",'info');
				return false;
			}
			var reducenum = $('#reducenum');
			var landarea = $('#landarea');
			var reducenumNum = parseFloat($('#reducenum')[0].value);
			var landareaNum = parseFloat($('#landarea')[0].value);
			if(reducenumNum > landareaNum){
				 $.messager.alert('提示消息','土地减免面积不能大于该土地的面积','info',function(){
					   return false;
				 });
				 return false;
			}
			return true;
		}
		function saveAvoidTax(){
			var result = validateFormData();
			if(!result)
				return;
			var params = {};
			var fields =$('#avoidtaxinfoform').serializeArray();  
			$.each(fields, function(i, field){
				params[field.name] = field.value;
			});
			var fieldsubs =$('#avoidtaxinfosubform').serializeArray();  
			$.each(fieldsubs, function(i, field){
				params[field.name] = field.value;
			});
			var opertype = $('#opertype').val();
			if(opertype == "1"){
				$.ajax({
					  type: "get",
					  async:true,
					  cache:false,
					  url: "/avoidtaxmanager/addavoidtax.do?d="+new Date(),
					  data: params,
					  dataType: "json",
					  success:function(jsondata){
						   if(jsondata.sucess){
							  $.messager.alert('提示消息','新增土地减免税成功!','info',function(){
								  $('#avoidtaxinfosubwindow').window('close');
								  queryInfo();
							  });
							  
						  }else{
							  $.messager.alert('错误','新增土地减免税失败！','error',function(){

							  });
						  }
					  }
			   });
			}else if(opertype == "2"){
				$.ajax({
					  type: "get",
					  async:true,
					  cache:false,
					  url: "/avoidtaxmanager/updateavoidtax.do?d="+new Date(),
					  data: params,
					  dataType: "json",
					  success:function(jsondata){
						   if(jsondata.sucess){
							  $.messager.alert('提示消息','修改土地减免税成功!','info',function(){
								  $('#avoidtaxinfosubwindow').window('close');
								  queryInfo();
							  });
						  }else{
							  $.messager.alert('错误',jsondata.message,'error',function(){
							  });
						  }
					  }
			   });
			}	
		}
		function addLinkLandInfo(value,row,index){
			var result = "";
			result = "<a style='color:#00f;text-decoration:underline;cursor:pointer;' onclick='showLandInfo("+index+")'>"+value+"</a>";
			return result;
		}
		function showLandInfo(index){
			var rows = $('#avoidtaxgrid').datagrid('getRows');
			var row = null;
			for(var i = 0;i < rows.length;i++){
				if(i === index){
					row = rows[i];
					break;
				}
			}
			var estateid = row.estateid;
			WidgetUtils.showEstate(estateid);
		}
		
		function exportExcel(){
			var params = {};
			var fields =$('#avoidtaxqueryform').serializeArray();  
			$.each(fields, function(i, field){
				params[field.name] = field.value;
			});
			params['taxtypecode'] = '12';
			params['propNames'] = 'statename,infoname,taxpayerid,taxpayername,taxtypename,taxname,reducebegindate,reduceenddate,reducenum,'+
			               'reduceclassname,approveunitname,approvenumber,reducereason,policybasis,inputpersonname,inputdate,checkpersonname,checkdate';
			params['colNames'] = '审核状态,土地信息,计算机编码,纳税人名称,税种,税目,减免起日期,减免止日期,减免面积,减免类型,批准机关,'+
                                 '批准文号,减免原因,政策依据,录入人,录入日期,审核人,审核日期';
			params['modelName']="土地减免税";
			CommonUtils.downloadFile("/avoidtaxmanager/avoidtaxexport.do?date="+new Date(),params);
		}
		
		
	</script>
</head>
<body>
     <div class="easyui-layout" style="width:100%;height:570px;" data-options="split:true" id="layoutDiv" >
	     <div data-options="region:'center'">
		    <form id="groundstorageform" method="post">
			<table id='avoidtaxgrid' class="easyui-datagrid" style="width:99;height:543px;overflow: scroll;"
					data-options="iconCls:'icon-edit',singleSelect:true,pageList:[15]">
				<thead>
					<th data-options="field:'businesscode',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
					<th data-options="field:'businessnumber',width:180,align:'center',hidden:true,editor:{type:'text'}"></th>
					 <th data-options="field:'taxreduceid',hidden:true,width:50,align:'center',editor:{type:'validatebox'}">主键</th>
						<th data-options="field:'statename',width:50,align:'center',editor:{type:'validatebox'}">审核状态</th>
						<th data-options="field:'infoname',width:80,align:'center',formatter:addLinkLandInfo,editor:{type:'validatebox'}">土地信息</th>
						<th data-options="field:'a',width:100,align:'center',formatter:uploadbutton">附件管理</th>
						<th data-options="field:'taxpayerid',width:100,align:'left',editor:{type:'validatebox'}">计算机编码</th>
						<th data-options="field:'taxpayername',width:220,align:'left',editor:{type:'validatebox'}">纳税人名称</th>
						<th data-options="field:'taxtypename',width:120,align:'left',editor:{type:'validatebox'}">税种</th>
						<th data-options="field:'taxname',width:150,align:'left',editor:{type:'validatebox'}">税目</th>
						<th data-options="field:'reducebegindate',width:100,align:'left',formatter:formatterDate,editor:{type:'validatebox'}">减免起日期</th>
						<th data-options="field:'reduceenddate',width:100,align:'left',formatter:formatterDate,editor:{type:'validatebox'}">减免止日期</th>
						<th data-options="field:'reducenum',width:120,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">减免面积</th>
						<th data-options="field:'reduceclassname',width:120,align:'left',editor:{type:'validatebox'}">减免类型</th>
						<th data-options="field:'approveunitname',width:200,align:'left',editor:{type:'validatebox'}">批准机关</th>
						<th data-options="field:'approvenumber',width:200,align:'left',editor:{type:'validatebox'}">批准文号</th>
						<th data-options="field:'reducereason',width:200,align:'left',editor:{type:'validatebox'}">减免原因</th>
						<th data-options="field:'policybasis',width:230,align:'left',editor:{type:'validatebox'}">政策依据</th>
						<th data-options="field:'inputpersonname',width:100,align:'left',editor:{type:'validatebox'}">录入人</th>
						<th data-options="field:'inputdate',width:100,align:'left',formatter:formatterDate,editor:{type:'validatebox'}">录入日期</th>
						<th data-options="field:'checkpersonname',width:100,align:'left',editor:{type:'validatebox'}">审核人</th>
						<th data-options="field:'checkdate',width:100,align:'left',formatter:formatterDate,editor:{type:'validatebox'}">审核日期</th>
				</thead>
			</table>
		    </form>
	    </div>
		<div data-options="region:'north'" style="height:25px;width:100%;overflow: visible" >
			<div style="height:25px;">
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="openQuery()">查询</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="openLandQuery()">新增</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="deleteAvoidTax()">删除</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" onclick="updateInfo()">修改</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-export',plain:true" onclick="exportExcel()">导出</a>
			</div>
		</div>
	</div>
	<div id="avoidtaxaddwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地减免税录入',collapsible:false,
	minimizable:false,maximizable:false,closable:true" style="width:950px;height:450px;" data-close="autoclose">
	    <input type="hidden" id="opertype" name="opertype" />
	    <div id="detailtb" style="height:25px;">
				<a class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="openLandQuery()">选择土地</a>
	   </div>

		<div class="easyui-panel" style="" id="avoidadddiv">
			<form id="avoidtaxinfoform" method="post" width="100%">
			    <input type="hidden" id="taxreduceid" name="taxreduceid"/>
			    <input type="hidden" id="estateid" name="estateid" data-type="p"/>
			    <input type="hidden" id="taxpayerid" name="taxpayerid" data-type="p"/>
			    <input type="hidden" id="taxtypecode" name="taxtypecode" data-type="p"/>
			    <input type="hidden" id="taxcode" name="taxcode" data-type="p"/>
			    <input type="hidden" id="businesscode" name="businesscode" value="92"/>
			    <input type="hidden" id="state" name="state"/>
			    <input type="hidden" id="businessnumber" name="businessnumber"/>
			    <input type="hidden" id="businessid" name="businessid"/>
			    <input type="hidden" id="inputperson" name="inputperson"/>
				<input type="hidden" id="inputdate" name="inputdate"/>
				<input type="hidden" id="checkperson" name="checkperson"/>
				<fieldset><legend><font color="blue" style="font-weight: bold;">土地信息</font></legend>
				<table id="narjcxx1x" width="100%"  cellpadding="2" cellspacing="0">
					<tr>
						<td align="right">纳税人名称：</td>
						<td>
							<input id="taxpayername" class="easyui-validatebox" type="text" name="taxpayername" readonly="true" data-type="p" data-validate="p"/>					
						</td>
						<td align="right">税种：</td>
						<td>
							<input id="taxtypename" class="easyui-validatebox" type="text" name="taxtypename" readonly="true" data-type="p" data-validate="p"/>					
						</td>
						<td align="right">税目：</td>
						<td>
							<input id="taxname" class="easyui-validatebox" type="text" name="taxname" readonly="true" data-type="p" data-validate="p"/>					
						</td>
					</tr>
					<tr>
						<td align="right">宗地编号：</td>
						<td>
							<input id="estateserialno" class="easyui-validatebox" type="text" name="estateserialno" readonly="true" data-type="p"/>					
						</td>
						<td align="right">土地证类型：</td>
						<td>
							<input id="landcertificatetypename" class="easyui-validatebox" type="text" name="landcertificatetypename" readonly="true" data-type="p"/>					
						</td>
						<td align="right">土地证号：</td>
						<td>
							<input id="landcertificate" class="easyui-validatebox" type="text" name="landcertificate" readonly="true" data-type="p"/>					
						</td>
					</tr>
					<tr>
						<td align="right">坐落地类型：</td>
						<td>
							<input id="locationtypename" class="easyui-validatebox" type="text" name="locationtypename" readonly="true" data-type="p"/>					
						</td>
						<td align="right">所属村委会：</td>
						<td>
							<input id="belongtocountryname" class="easyui-validatebox" type="text" name="belongtocountryname" readonly="true" data-type="p"/>					
						</td>
						<td align="right">土地单价：</td>
						<td>
							<input id="landunitprice" class="easyui-validatebox" type="text" style="text-align: right;" name="landunitprice" readonly="true" data-type="p"/>					
						</td>
					</tr>
					<tr>
						<td align="right">交付日期：</td>
						<td>
							<input id="holddate" class="easyui-validatebox" type="text" name="holddate" readonly="true" data-type="p"/>					
						</td>
						<td align="right">土地总价：</td>
						<td>
							<input id="landmoney" class="easyui-validatebox" type="text" style="text-align: right;" name="landmoney" readonly="true" data-type="p"/>					
						</td>
						<td align="right">土地面积：</td>
						<td>
							<input id="landarea" class="easyui-validatebox" type="text" style="text-align: right;" name="landarea" readonly="true" data-type="p"/>					
						</td>
					</tr>						
				</table>
				</fieldset>
			</form>
		</div>
		<div class="easyui-layout" style="width: 100%; height: 230px"
				data-options="split:true" id="layoutDiv11">
				<!-- <div data-options="region:'north'"
					style="height: 25px; width: 99; overflow: visible">
					<div style="height: 25px;">
						<a href="#" class="easyui-linkbutton"
							data-options="iconCls:'icon-add',plain:true" onclick="openAddavoidInfo()">新增</a>
						<a href="#" class="easyui-linkbutton"
							data-options="iconCls:'icon-remove',plain:true"
							onclick="deleteAvoidTaxInfo()">删除</a>
						<a href="#" class="easyui-linkbutton"
							data-options="iconCls:'icon-edit',plain:true"
							onclick="updateAvoidInfo()">修改</a>
					</div>
				</div> -->
						<table id='avoidtaxgridsub' class="easyui-datagrid"
							style=" height: 200px; overflow: scroll;"
							data-options="iconCls:'icon-edit',singleSelect:true,pageList:[5],pagination: true,rownumbers: true,showPageList:false">
							<thead>
								<th
									data-options="field:'taxreduceid',hidden:true,width:50,align:'center',editor:{type:'validatebox'}">
									主键
								</th>
								<th
									data-options="field:'statename',width:60,align:'left',editor:{type:'validatebox'}">
									状态
								</th>
								<th
									data-options="field:'approvenumber',width:80,align:'left',editor:{type:'validatebox'}">
									批准文号
								</th>
								<th
									data-options="field:'approveunitname',width:200,align:'left',editor:{type:'validatebox'}">
									批准机关
								</th>
								<th
									data-options="field:'inputdate',width:80,align:'left',formatter:formatterDate,editor:{type:'validatebox'}">
									减免批复日期
								</th>
								<th
									data-options="field:'reduceclassname',width:100,align:'left',editor:{type:'validatebox'}">
									减免类型
								</th>
								<th
									data-options="field:'reducenum',width:80,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">
									减免面积
								</th>
								<th
									data-options="field:'reducereason',width:80,align:'left',editor:{type:'validatebox'}">
									减免原因
								</th>
								<th
									data-options="field:'policybasis',width:150,align:'left',editor:{type:'validatebox'}">
									政策依据
								</th>
								<th
									data-options="field:'reducebegindate',width:100,align:'left',formatter:formatterDate,editor:{type:'validatebox'}">
									减免起日期
								</th>
								<th
									data-options="field:'reduceenddate',width:100,align:'left',formatter:formatterDate,editor:{type:'validatebox'}">
									减免止日期
								</th>
								
							</thead>
						</table>
			</div>
		<!-- 
	    <div style="text-align:center;padding:5px;height: 25px;">  
			 <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveAvoidTax()">保存</a>
	    </div> -->
	</div>
	
	<div id="avoidtaxinfosubwindow" class="easyui-window"
			data-options="closed:true,modal:true,title:'减免信息',collapsible:false,minimizable:false,maximizable:false,closable:true"
			style="width: 800px; height: 200px;">
				<form id="avoidtaxinfosubform" method="post" width="100%">
				<fieldset>
									<font color="blue" style="font-weight: bold;">减免信息</font>
								
					<table id="narjcxx1" width="100%" cellpadding="2" cellspacing="0">
						<tr>
						<td align="right">减免起日期：</td>
						<td>
							<input id="reducebegindate" class="easyui-datebox" type="text" name="reducebegindate" data-validate="p"/>					
						</td>
						<input type="hidden" id="taxreduceid" name="taxreduceid" />
						<td align="right">减免止日期：</td>
						<td>
							<input id="reduceenddate" class="easyui-datebox" type="text" name="reduceenddate" data-validate="p"/>					
						</td>
						<td align="right">批准文号：</td>
						<td>
							<input id="approvenumber" class="easyui-validatebox" type="text" name="approvenumber" data-validate="p"/>					
						</td>
					</tr>
					<tr>
						<td align="right">批准机关：</td>
						<td>
							<input id="approveunit" class="easyui-combobox"  name="approveunit" data-options="disabled:false,panelWidth:300,panelHeight:200" data-validate="p"/>					
						</td>
						<td align="right">
							减免批复日期：
						</td>
						<td>
							<input class="easyui-datebox" id="inputdate"
								name="inputdate" data-validate="p" />
						</td>
						<td align="right">减免类型：</td>
						<td>
						<!-- data-options="required:true" -->
							<input class="easyui-combobox"  id="reduceclass"  name="reduceclass" data-validate="p"/>					
						</td>
						
					</tr>
					<tr>
						<td align="right">减免面积：</td>
						<td>
							<input id="reducenum" class="easyui-numberbox" type="text" name="reducenum" data-validate="p"/>					
						</td>
						<td align="right">减免原因：</td>
						<td>
							<input id="reducereason" class="easyui-validatebox" type="text" name="reducereason" data-validate="p"/>					
						</td>
						<td align="right">政策依据：</td>
						<td>
							<input id="policybasis" class="easyui-validatebox" type="text" name="policybasis" data-validate="p"/>					
						</td>
					</tr>
					</table>
					</fieldset>
				</form>
			<div style="text-align: center; padding: 5px; height: 25px;">
				<a href="#" class="easyui-linkbutton"
					data-options="iconCls:'icon-save'" onclick="saveAvoidTax()">保存</a>
			</div>
		</div>
	
	<div id="avoidtaxquerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'查询条件',collapsible:false,
	minimizable:false,maximizable:false,closable:true" style="width:750px;height:320px;" data-close="autoclose">
			<form id="avoidtaxqueryform" method="post">
				<table id="narjcxx" width="100%"  class="table table-bordered">
					<tr>
						<td align="right">州市地税机关：</td>
						<td>
							<input class="easyui-combobox" name="taxorgsupcode" id="taxorgsupcode" data-options="disabled:false,panelWidth:300,panelHeight:200" style="width:250px"/>					
						</td>
						<td align="right">县区地税机关：</td>
						<td>
							<input class="easyui-combobox" name="taxorgcode" id="taxorgcode" data-options="disabled:false,panelWidth:300,panelHeight:200" style="width:250px"/>					
						</td>
						
					</tr>
					
					<tr>
						<td align="right">主管地税部门：</td>
						<td>
							<input class="easyui-combobox" name="taxdeptcode" id="taxdeptcode" data-options="disabled:false,panelWidth:300,panelHeight:200" style="width:250px"/>					
						</td>
						<td align="right">税收管理员：</td>
						<td>
							<input class="easyui-combobox" name="taxmanagercode" id="taxmanagercode" data-options="disabled:false,panelWidth:300,panelHeight:200" style="width:250px"/>					
						</td>
					</tr>
					<tr>
						<td align="right">计算机编码：</td>
						<td><input id="taxpayerid" class="easyui-validatebox" type="text" name="taxpayerid" onkeydown="if(event.keyCode==13)spelltaxpayerid(this)" style="width:250px"/></td>
						<td align="right">纳税人名称：</td>
						<td>
							<input id="taxpayername" class="easyui-validatebox" type="text" name="taxpayername" style="width:250px"/>
						</td>

					</tr>
					<tr>
						<td align="right">
							审核状态：
						</td>
						<td colspan="5">
							<select id="state" class="easyui-combobox" name="state" style="width:200px;">
								<option value=0>--请选择审核状态--</option>    
							    <option value=1>未审核</option>  
							    <option value=2>已审核</option>  
							</select>  
						</td>
					</tr>
					<tr>
						<td align="right">减免日期：</td>
						<td colspan="5">
							<input id="begindate" class="easyui-datebox" name="begindate"/>
						至
							<input id="enddate" class="easyui-datebox"  name="enddate"/>
						</td>
					</tr>
					<tr>
						<td align="right">
							减免批复日期：
						</td>
						<td colspan="5">
							<input id="inputdatebegin" class="easyui-datebox" name="inputdatebegin" />
							至
							<input id="inputdateend" class="easyui-datebox" name="inputdateend" />
						</td>
					</tr>
				</table>
			</form>
	    <div style="text-align:center;padding:5px;height: 25px;">  
			 <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="query()">查询</a>
	    </div>
	</div>
</body>
</html>
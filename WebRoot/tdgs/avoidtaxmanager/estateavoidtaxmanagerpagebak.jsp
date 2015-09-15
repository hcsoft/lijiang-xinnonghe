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
	<script src="<%=spath%>/js/dropdown.js"></script>
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
		var managerLink = new OrgLink();
	    managerLink.sendMethod = false;
	    managerLink.loadData();
	    
	    $('#avoidtaxgrid').datagrid({
			fitColumns:false,
			maximized:'true',
			pagination:true,
			rowStyler:settings.rowStyle,
			pageList:[15]
			
		});
		var p = $('#avoidtaxgrid').datagrid('getPager');  
			$(p).pagination({  
				showPageList:false
			});
			/*
		var firstDay = DateUtils.getYearFirstDay();
			var lastDay = DateUtils.getCurrentDay();
		     $('#begindate').datebox('setValue',firstDay);
		     $('#enddate').datebox('setValue',lastDay);
		     */
	});
		function query(){
			AvoidManager.queryAvoidTax();
		}
		function openQuery(){
			$('#avoidtaxquerywindow').window('open');
		}
		
		
		//////////////////////////////////////////////////////////////////////////
		function updateLandStoreInfo(wintitle){
			var row = $('#avoidtaxgrid').datagrid('getSelected');
			var reduceid = row.taxreduceid;
			$('#avoidtaxinfoform1').form('clear');
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
							  queryPlough(avoidtaxbo.estateid);
							  for(var p in avoidtaxbo){
								   var value = avoidtaxbo[p];
								   if(p.indexOf('date') >=0){
									   value = formatterDate(value);
								   }
								   var input = $('#avoidtaxaddwindow1'+' #'+p);
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
							  $('#avoidtaxaddwindow1').window({title:wintitle});
							  $('#avoidtaxaddwindow1').window('open');
						  }else{
							  $.messager.alert('提示消息',jsondata.message,'info');
						  }
					  }
				  });
		}
		function updateEstateInfo(wintitle){
			var row = $('#avoidtaxgrid').datagrid('getSelected');
			var reduceid = row.taxreduceid;
			$('#avoidtaxinfoform').form('clear');
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
							  $('#avoidtaxaddwindow').window({title:wintitle});
							  $('#avoidtaxaddwindow').window('open');
						  }else{
							  $.messager.alert('提示消息',jsondata.message,'info');
						  }
					  }
				  });
		}
		function delegateLandStore(rowIndex,rowData){
			if(rowData){
					rowData['taxtypename'] = '耕地占用税';
					rowData['taxname'] = '耕地占用税';
					rowData['estateid'] = rowData['landstoreid'];
				    $('#avoidtaxinfoform1 input[data-type="p"]').each(function(){
				    	var id = this.id;
				    	if(id){
				    		if(id in rowData){
				    			var value = rowData[id];
				    			if(id.indexOf('date') >= 0){
				    				value = formatterDate(value);
				    			}
				    			$(this).val(value);
				    		}
				    	}
				    });
			}
		}
		function delegateEstateInfo(rowIndex,rowData){
			if(rowData){
				    $('#avoidtaxinfoform input[data-type="p"]').each(function(){
				    	var id = this.id;
				    	if(id){
				    		if(id in rowData){
				    			var value = rowData[id];
				    			if(id.indexOf('date') >= 0){
				    				value = formatterDate(value);
				    			}
				    			$(this).val(value);
				    		}
				    	}
				    });
			}
		} 
        function queryPlough(ploughid){
			var paramsArg = {};
			paramsArg['ploughid'] = ploughid;	
			$.ajax({
				  type: "get",
				  async:true,
				  cache:false,
				  url: "/ploughavoidtaxmanager/selectsingleplough.do?d="+new Date(),
				  data: paramsArg,
				  dataType: "json",
				  success:function(jsondata){
					  if(jsondata.sucess){
						  var rowData = jsondata.result;
						  delegateLandStore(0,rowData);
					  }else{
						  $.messager.alert('错误','获取土地批复信息失败！','error');
					  }
				  }
			   });
		}
		function queryLand(estateid){
			var paramsArg = {};
			paramsArg['estateid'] = estateid;	
			$.ajax({
				  type: "get",
				  async:true,
				  cache:false,
				  url: "/landavoidtaxmanager/selectsingleland.do?d="+new Date(),
				  data: paramsArg,
				  dataType: "json",
				  success:function(jsondata){
					  if(jsondata.sucess){
						  var rowData = jsondata.result;
						  delegateEstateInfo(0,rowData);
					  }else{
						  $.messager.alert('错误','获取土地信息失败！','error');
					  }
				  }
			   });
		}
		/*1 表示审核，0表示取消审核*/
		function estateOrUnEstate(event,info){
			var taxreduceid = null;
			var windowObj = null;
			if(info.estatetype === "plough"){
				taxreduceid = $('#avoidtaxinfoform1 #taxreduceid').val();
				windowObj = $('#avoidtaxaddwindow1');
			}else if(info.estatetype === "estate"){
				taxreduceid = $('#avoidtaxinfoform #taxreduceid').val();
				windowObj = $('#avoidtaxaddwindow');
			}
			if(info.type === 1){
				$.ajax({
				  type: "get",
				  async:true,
				  cache:false,
				  url: "/avoidtaxmanager/estateavoidtax.do?d="+new Date(),
				  data: {'taxreduceid':taxreduceid},
				  dataType: "json",
				  success:function(jsondata){
					  if(jsondata.sucess){
						  $.messager.alert('消息','审核减免税成功！','info',function(){
							  windowObj.window('close');
							  query();
						  });
					  }else{
						  $.messager.alert('错误',jsondata.message,'error');
					  }
				  }
			   });
			}else if(info.type === 0){
				$.ajax({
				  type: "get",
				  async:true,
				  cache:false,
				  url: "/avoidtaxmanager/undoestateavoidtax.do?d="+new Date(),
				  data: {'taxreduceid':taxreduceid},
				  dataType: "json",
				  success:function(jsondata){
					  if(jsondata.sucess){
						  $.messager.alert('消息','取消审核减免税成功！','info',function(){
							  windowObj.window('close');
							  query();
						  });
					  }else{
						  $.messager.alert('错误',jsondata.message,'error');
					  }
				  }
			   });
			}
		}
		function estateAvoidTax(){
			var row = $('#avoidtaxgrid').datagrid('getSelected');
			if(row == null){
				 $.messager.alert('提示消息','请选择需要审核的减免税记录!','info');
				 return;
			}
			var taxtypecode = row.taxtypecode;
			if(taxtypecode === "20"){
				$('#avoidtaxaddwindow1 #ploughAssert').one('click',{estatetype:"plough",type:1},function(e){
					estateOrUnEstate(e,e.data);
				});
				$('#avoidtaxaddwindow1 #ploughAssert').linkbutton({
					text:"审核"
				});
			    updateLandStoreInfo("减免税审核");
			}else if(taxtypecode === "12"){
				$('#avoidtaxaddwindow #estateAssert').one('click',{estatetype:"estate",type:1},function(e){
					estateOrUnEstate(e,e.data);
				});
				$('#avoidtaxaddwindow #estateAssert').linkbutton({
					text:"审核"
				});
				updateEstateInfo("减免税审核");
			}
		}
		function undoEstateAvoidTax(){
			var row = $('#avoidtaxgrid').datagrid('getSelected');
			if(row == null){
				 $.messager.alert('提示消息','请选择需要取消审核的减免税记录!','info');
				 return;
			}
			var taxtypecode = row.taxtypecode;
			if(taxtypecode === "20"){
				$('#avoidtaxaddwindow1 #ploughAssert').one('click',{estatetype:"plough",type:0},function(e){
					estateOrUnEstate(e,e.data);
				});
				$('#avoidtaxaddwindow1 #ploughAssert').linkbutton({
					text:"取消审核"
				});
			    updateLandStoreInfo("减免税取消审核");
			}else if(taxtypecode === "12"){
				$('#avoidtaxaddwindow #estateAssert').one('click',{estatetype:"estate",type:0},function(e){
					estateOrUnEstate(e,e.data);
				});
				$('#avoidtaxaddwindow #estateAssert').linkbutton({
					text:"取消审核"
				});
				updateEstateInfo("减免税取消审核");
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
			var taxtypecode = row.taxtypecode;
			if(taxtypecode === "20"){
				WidgetUtils.showLandStroeInfo(estateid);
			}else if(taxtypecode === "12"){
				WidgetUtils.showEstate(estateid);
			}
			
		}
		
		function exit(){
			var oIframes = parent.$("iframe");
			var currentUrl = "/tdgs/avoidtaxmanager/estateavoidtaxmanagerpage.jsp";
			for(var i = 0;i < oIframes.length;i++){
				var oSrc =  oIframes.get(i).src;
				if(oSrc.indexOf(currentUrl) != -1){
					var oDiv = $(oIframes.get(i)).parent().parent().parent();
					var oId = oDiv[0].id;
				    parent.$('#'+oId).dialog('close');
				}
			}
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
					 <th data-options="field:'taxreduceid',hidden:true,width:50,align:'center',editor:{type:'validatebox'}">主键</th>
						<th data-options="field:'statename',width:50,align:'center',editor:{type:'validatebox'}">状态</th>
						<th data-options="field:'infoname',width:80,align:'center',formatter:addLinkLandInfo,editor:{type:'validatebox'}">土地信息</th>
						<th data-options="field:'taxpayerid',width:100,align:'center',editor:{type:'validatebox'}">计算机编码</th>
						<th data-options="field:'taxpayername',width:220,align:'left',editor:{type:'validatebox'}">纳税人名称</th>
						<th data-options="field:'taxtypename',width:120,align:'center',editor:{type:'validatebox'}">税种</th>
						<th data-options="field:'taxname',width:150,align:'center',editor:{type:'validatebox'}">税目</th>
						<th data-options="field:'reducebegindate',width:100,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">减免起日期</th>
						<th data-options="field:'reduceenddate',width:100,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">减免止日期</th>
						<th data-options="field:'reducenum',width:120,align:'center',editor:{type:'validatebox'}">减免面积</th>
						<th data-options="field:'reduceclassname',width:120,align:'center',editor:{type:'validatebox'}">减免类型</th>
						<th data-options="field:'approveunitname',width:200,align:'center',editor:{type:'validatebox'}">批准机关</th>
						<th data-options="field:'approvenumber',width:200,align:'center',editor:{type:'validatebox'}">批准文号</th>
						<th data-options="field:'reducereason',width:200,align:'center',editor:{type:'validatebox'}">减免原因</th>
						<th data-options="field:'policybasis',width:230,align:'center',editor:{type:'validatebox'}">政策依据</th>
						<th data-options="field:'inputpersonname',width:100,align:'center',editor:{type:'validatebox'}">录入人</th>
						<th data-options="field:'inputdate',width:100,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">录入日期</th>
						<th data-options="field:'checkpersonname',width:100,align:'center',editor:{type:'validatebox'}">审核人</th>
						<th data-options="field:'checkdate',width:100,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">审核日期</th>
				</thead>
			</table>
		    </form>
	    </div>
		<div data-options="region:'north'" style="height:25px;width:100%;overflow: visible" >
			<div style="height:25px;">
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="openQuery()">查询</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-check',plain:true" onclick="estateAvoidTax()">审核</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-uncheck',plain:true" onclick="undoEstateAvoidTax()">取消审核</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-no',plain:true" onclick="exit();">退出</a>
			</div>
		</div>
	</div>
	<!-- 土地使用税的减免税的审核 -->
	<div id="avoidtaxaddwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地减免税录入',collapsible:false,
	minimizable:false,maximizable:false,closable:true" style="width:1020px;height:490px;">
		<div class="easyui-panel" style="width:1000px;" id="avoidadddiv">
			<form id="avoidtaxinfoform" method="post">
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
				<table id="landtable" width="100%"  cellpadding="10" cellspacing="0">
				     <tr>
					     <td colspan="6"><fieldset><font color="blue" style="font-weight: bold;">土地信息</font></fieldset></td>
					</tr>
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
							<input id="landunitprice" class="easyui-validatebox" type="text" name="landunitprice" readonly="true" data-type="p"/>					
						</td>
					</tr>
					<tr>
						<td align="right">交互日期：</td>
						<td>
							<input id="holddate" class="easyui-validatebox" type="text" name="holddate" readonly="true" data-type="p"/>					
						</td>
						<td align="right">土地总价：</td>
						<td>
							<input id="landmoney" class="easyui-validatebox" type="text" name="landmoney" readonly="true" data-type="p"/>					
						</td>
						<td align="right">土地面积：</td>
						<td>
							<input id="landarea" class="easyui-validatebox" type="text" name="landarea" readonly="true" data-type="p"/>					
						</td>
					</tr>
					<tr>
					     <td colspan="6"><fieldset><font color="blue" style="font-weight: bold;">减免信息</font></fieldset></td>
					</tr>						
					<tr>
						<td align="right">减免起日期：</td>
						<td>
							<input id="reducebegindate" class="easyui-validatebox" type="text" name="reducebegindate" readonly="true" data-validate="p"/>					
						</td>
						<td align="right">减免止日期：</td>
						<td>
							<input id="reduceenddate" class="easyui-validatebox" type="text" name="reduceenddate" readonly="true" data-validate="p"/>					
						</td>
						<td align="right">批准文号：</td>
						<td>
							<input id="approvenumber" class="easyui-validatebox" type="text" name="approvenumber" readonly="true" data-validate="p"/>					
						</td>
					</tr>
					<tr>
						<td align="right">批准机关：</td>
						<td>
							<input id="approveunitname" class="easyui-validatebox"  name="approveunitname" readonly="true" data-options="disabled:false,panelWidth:300,panelHeight:200" data-validate="p"/>					
						</td>
						<td align="right">减免类型：</td>
						<td>
						<!-- data-options="required:true" -->
							<input class="easyui-validatebox"  id="reduceclassname"  name="reduceclassname" readonly="true" data-validate="p"/>					
						</td>
						<td align="right">减免面积：</td>
						<td>
							<input id="reducenum" class="easyui-numberbox" type="text" name="reducenum" readonly="true" data-validate="p"/>					
						</td>
					</tr>
					<tr>
						<td align="right">减免原因：</td>
						<td>
							<input id="reducereason" class="easyui-validatebox" type="text" name="reducereason" readonly="true" data-validate="p"/>					
						</td>
						<td align="right">政策依据：</td>
						<td>
							<input id="policybasis" class="easyui-validatebox" type="text" name="policybasis" readonly="true" data-validate="p"/>					
						</td>
					</tr>
				</table>
			</form>
		</div>
	    <div style="text-align:center;padding:5px;height: 25px;">  
			 <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-check'" id="estateAssert">审核</a>
	    </div>
	</div>
	<!-- 耕地的审核界面 -->
	<div id="avoidtaxaddwindow1" class="easyui-window" data-options="closed:true,modal:true,title:'减免税录入',collapsible:false,
	minimizable:false,maximizable:false,closable:true" style="width:1020px;height:530px;">
	   <div class="easyui-panel" style="width:1000px;" id="avoidadddiv">
			<form id="avoidtaxinfoform1" method="post">
			    <input type="hidden" id="taxreduceid" name="taxreduceid"/>
			    <input type="hidden" id="estateid" name="estateid" data-type="p"/>
			    <input type="hidden" id="taxpayerid" name="taxpayerid" data-type="p"/>
			    <input type="hidden" id="taxtypecode" name="taxtypecode" value="20" data-type="p"/>
			    <input type="hidden" id="taxcode" name="taxcode" value="200101" data-type="p"/>
			    <input type="hidden" id="businesscode" name="businesscode" value="92"/>
			    <input type="hidden" id="state" name="state"/>
			    <input type="hidden" id="businessnumber" name="businessnumber"/>
			    <input type="hidden" id="businessid" name="businessid"/>
			    <input type="hidden" id="inputperson" name="inputperson"/>
				<input type="hidden" id="inputdate" name="inputdate"/>
				<input type="hidden" id="checkperson" name="checkperson"/>
				
				<table id="narjcxx1" width="100%"  cellpadding="10" cellspacing="0">
				    <tr>
					     <td colspan="6"><fieldset><font color="blue" style="font-weight: bold;">土地批复信息</font></fieldset></td>
					</tr>
					<tr>
						<td align="right">纳税人名称：</td>
						<td>
							<input id="taxpayername" class="easyui-validatebox"  name="taxpayername" readonly="true" data-type="p" data-validate="p"/>					
						</td>
						<td align="right">税种：</td>
						<td>
							<input id="taxtypename" class="easyui-validatebox"  name="taxtypename"  readonly="true" value="耕地占用税" data-type="p" data-validate="p"/>					
						</td>
						<td align="right">税目：</td>
						<td>
							<input id="taxname" class="easyui-validatebox"  name="taxname"  readonly="true" value="耕地占用税" data-type="p" data-validate="p"/>					
						</td>
					</tr>
					<tr>
						<td align="right">批复日期：</td>
						<td>
							<input id="approvedate" class="easyui-validatebox" name="approvedate" readonly="true" data-type="p"/>					
						</td>
						<td align="right">批复总面积：</td>
						<td>
							<input id="areatotal" class="easyui-validatebox" name="areatotal" readonly="true" data-type="p"/>					
						</td>
						<td align="right">已出让面积：</td>
						<td>
							<input id="areasell" class="easyui-validatebox" name="areasell" readonly="true" data-type="p"/>					
						</td>
					</tr>
					<tr>
						<td align="right">耕地面积：</td>
						<td>
							<input id="areaplough" class="easyui-validatebox"  name="areaplough" readonly="true" data-type="p"/>					
						</td>
						<td align="right">耕地免税面积：</td>
						<td>
							<input class="easyui-validatebox"  id="areaploughfreetax"  name="areaploughfreetax" readonly="true" data-type="p"/>					
						</td>
						<td align="right">建设用地面积：</td>
						<td>
							<input id="areabuild" class="easyui-validatebox" name="areabuild" readonly="true" data-type="p"/>					
						</td>
					</tr>
					<tr>
						<td align="right">未利用地面积：</td>
						<td>
							<input id="areauseless" class="easyui-validatebox"  name="areauseless" readonly="true" data-type="p"/>					
						</td>
						<td align="right">已缴纳耕占税面积：</td>
						<td>
							<input class="easyui-validatebox"  id="areaploughtaxpay"  name="areaploughtaxpay" readonly="true" data-type="p"/>					
						</td>
						<td align="right">耕占税应税面积：</td>
						<td>
							<input id="areaploughtax" class="easyui-validatebox" name="areaploughtax" readonly="true" data-type="p"/>					
						</td>
					</tr>
					<tr>
						<td align="right">耕占税单位税额：</td>
						<td>
							<input id="taxprice" class="easyui-validatebox"  name="taxprice" readonly="true" data-type="p"/>					
						</td>
						<td align="right">行政区：</td>
						<td>
							<input class="easyui-validatebox"  id="district"  name="district" readonly="true" data-type="p"/>					
						</td>
						<td align="right">项目名称：</td>
						<td>
							<input id="name" class="easyui-validatebox" name="name" readonly="true" data-type="p"/>					
						</td>
					</tr>
					<tr>
					     <td colspan="6"><fieldset><font color="blue" style="font-weight: bold;">减免信息</font></fieldset></td>
					</tr>
					<tr>
						<td align="right">批准文号：</td>
						<td>
							<input id="approvenumber" class="easyui-validatebox" type="text" name="approvenumber" readonly="true" data-validate="p"/>					
						</td>
						<td align="right">批准机关：</td>
						<td>
							<input id="approveunitname" class="easyui-validatebox"  name="approveunitname" readonly="true" data-options="disabled:false,panelWidth:300,panelHeight:200" data-validate="p"/>					
						</td>
						<td align="right">减免类型：</td>
						<td>
						<!-- data-options="required:true" -->
							<input class="easyui-validatebox"  id="reduceclassname"  name="reduceclassname" readonly="true" data-validate="p"/>					
						</td>
					</tr>
					<tr>
						
						<td align="right">减免面积：</td>
						<td>
							<input id="reducenum" class="easyui-numberbox" type="text" name="reducenum" readonly="true"  data-validate="p"/>					
						</td>
						<td align="right">减免原因：</td>
						<td>
							<input id="reducereason" class="easyui-validatebox" type="text" name="reducereason" readonly="true" data-validate="p"/>					
						</td>
						<td align="right">政策依据：</td>
						<td>
							<input id="policybasis" class="easyui-validatebox" type="text" name="policybasis" readonly="true"  data-validate="p"/>					
						</td>
					</tr>
				</table>
			</form>
		</div>
	    <div style="text-align:center;padding:5px;height: 25px;">  
			 <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-check'" id="ploughAssert" >审核</a>
	    </div>
	</div>
	
	<div id="avoidtaxquerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'税源查询条件',collapsible:false,
	minimizable:false,maximizable:false,closable:true" style="width:640px;height:200px;">
			<form id="avoidtaxqueryform" method="post">
				<table id="narjcxx" width="100%"  cellpadding="3" cellspacing="0" border="1" bordercolor="#FCD209" style="border-collapse:collapse">
					<tr>
						<td align="right">州市地税机关：</td>
						<td>
							<input class="easyui-combobox" name="taxorgsupcode" id="taxorgsupcode" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">县区地税机关：</td>
						<td>
							<input class="easyui-combobox" name="taxorgcode" id="taxorgcode" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						
					</tr>
					
					<tr>
						<td align="right">主管地税部门：</td>
						<td>
							<input class="easyui-combobox" name="taxdeptcode" id="taxdeptcode" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">专管员：</td>
						<td>
							<input class="easyui-combobox" name="taxmanagercode" id="taxmanagercode" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
					</tr>
					<tr>
						<td align="right">计算机编码：</td>
						<td><input id="taxpayerid" class="easyui-validatebox" type="text" name="taxpayerid"/></td>
						<td align="right">纳税人名称：</td>
						<td>
							<input id="taxpayername" class="easyui-validatebox" type="text" name="taxpayername"/>
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
				</table>
			</form>
	    <div style="text-align:center;padding:5px;height: 25px;">  
			 <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="query()">查询</a>
	    </div>
	</div>
</body>
</html>
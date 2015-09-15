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
      <%
       String taxtypecode = request.getParameter("taxtypecode");
     %>
    <script>
    
	function formatterDate(value,row,index){
			return formatDatebox(value);
	}
	function formatValue(value,row,index){
		return value;
	}
	
    var managerLink = new OrgLink("9");
    managerLink.sendMethod = true;
    
    var taxLink = new TaxLink("taxtypecode","10,12,20",true,"taxcode");
	$(function(){
		    var map = new Map();
		    map.push("12","城镇土地使用税");
		    map.push("20","耕地占用税");
		    map.push("10","房产税和城市房地产税");
		    managerLink.loadData();
		    taxLink.loadData();
		    
		    $('#groundstoragegrid').datagrid({
				fitColumns:false,
				maximized:'true',
				pagination:true,
				rowStyler:settings.rowStyle,
				pageList:[15]
			});
			
			var p = $('#groundstoragegrid').datagrid('getPager');  
				$(p).pagination({  
					showPageList:false
				});
	
			 var firstDay = DateUtils.getYearFirstDay();
			 var lastDay = DateUtils.getCurrentDay();

		     $('#beginDate').datebox('setValue',firstDay);
		     $('#endDate').datebox('setValue',lastDay);
		     
		     var typecode = <%=taxtypecode%>
		   //  alert(typecode);
		     var taxname = map.get(typecode);
		     $('#taxtypename').val(taxname);
		     $('#taxtypecode').val(typecode);
		     
		});
	    
		function query(){
			var params = {};
			var fields =$('#shouldtaxqueryform').serializeArray();
			$.each(fields, function(i, field){
				 params[field.name] = field.value;
			});
			var taxpayerid =  params['taxpayerid'];
			var taxtypecode = params['taxtypecode'];
			var begindate = params['beginDate'];
			var enddate = params['endDate'];
			if(taxtypecode == ''){
				$.messager.alert('提示消息','必须选择税种！','info');   
				return false;
			}
			if(begindate == '' && enddate == ''){
				$.messager.alert('提示消息','必须选择所属期！','info');   
				return false;
			}
			
		    params['pageSize'] = 15;
			var opts = $('#groundstoragegrid').datagrid('options');
			opts.url = '/shouldtaxrelate/selectshouldtax.do?d='+new Date();
			$('#groundstoragegrid').datagrid('load',params); 
			
			var p = $('#groundstoragegrid').datagrid('getPager');  
			$(p).pagination({   
				showPageList:false
			});
			
			$('#groundstoragequerywindow').window('close');			
		}
		var selectRow = null;
		function openQuery(){
			$('#groundstoragequerywindow').window('open');
		}
		
	</script>
</head>

<body>
     <div class="easyui-layout" style="width:100%;height:550px;" data-options="split:true" id="layoutDiv" >
	     <div data-options="region:'center'">
		    <form id="groundstorageform" method="post">
			<table id='groundstoragegrid' class="easyui-datagrid" style="width:99;height:523px;overflow: scroll;"
					data-options="iconCls:'icon-edit',singleSelect:true,pageList:[15]">
				<thead>
					<tr>
					    <th data-options="field:'taxpayerid',width:120,align:'center',editor:{type:'validatebox'}">计算机编码</th>
					    <th data-options="field:'taxpayername',width:240,align:'left',editor:{type:'validatebox'}">纳税人名称</th>
					    <th data-options="field:'taxtypename',width:120,align:'left',editor:{type:'validatebox'}">税种</th>
					    <th data-options="field:'taxname',width:120,align:'left',editor:{type:'validatebox'}">税目</th>
					    <th data-options="field:'taxdatebegin',width:100,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">所属期起</th>
						<th data-options="field:'taxdateend',width:100,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">所属期止</th>
						<th data-options="field:'paydate',width:100,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">催缴日期</th>
						<th data-options="field:'taxamount',width:120,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">应缴金额</th>
						<th data-options="field:'taxamountactual',width:120,align:'right',formatter:formatnumber,editor:{type:'validatebox'}">实缴金额</th>
						<th data-options="field:'taxorgname',width:160,align:'left',editor:{type:'validatebox'}">县区地税机关</th>
						<th data-options="field:'taxdeptname',width:160,align:'left',editor:{type:'validatebox'}">主管税务机关</th>
						<th data-options="field:'taxmanagername',width:120,align:'left',editor:{type:'validatebox'}">税收管理员</th>
					</tr>
				</thead>
			</table>
		    </form>
	    </div>
		<div data-options="region:'north'" style="height:25px;width:100%;overflow: visible" >
			<div style="height:25px;">
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="openQuery()">查询</a>
			</div>
		</div>
	</div>
	
	<div id="groundstoragequerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'应纳税查询条件',collapsible:false,
	minimizable:false,maximizable:false,closable:true,border:false" style="width:740px;height:260px;">
			<form id="shouldtaxqueryform" method="post">
				<table id="narjcxx" width="100%" class="table table-bordered">
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
						<td><input id="taxpayerid" class="easyui-validatebox" type="text" name="taxpayerid" style="width:250px" onkeydown="if(event.keyCode==13)spelltaxpayerid(this)"/></td>
						<td align="right">纳税人名称：</td>
						<td>
							<input id="taxpayername" class="easyui-validatebox" type="text" name="taxpayername" style="width:250px"/>
						</td>

					</tr>
					<tr>
						<td align="right">所属期：</td>
						<td colspan="5">
							<input id="beginDate" class="easyui-datebox" name="beginDate"/>
						至
							<input id="endDate" class="easyui-datebox"  name="endDate"/>
						</td>
					</tr>
					<tr>
					    <td align="right">税种：</td>
						<td colspan="5">
							<input id="taxtypename" class="easyui-validatebox" type="text" name="taxtypename" readonly="true" style="width:250px"/>
							
						</td>
						<td align="right" style="display:none;">税目：</td>
						<td style="display: none;">
						     <input id="taxtypecode"  type="hidden" name="taxtypecode" style="display:none;" style="width:250px"/>
							<input id="taxcode" class="easyui-combobox" type="hidden" name="taxcode" style="display:none;" style="width:250px"/>
						</td>
					</tr>
					
				</table>
			</form>
			<div style="text-align:center;padding:5px;">  
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="query()">查询</a>
			</div>
	</div>

</body>
</html>

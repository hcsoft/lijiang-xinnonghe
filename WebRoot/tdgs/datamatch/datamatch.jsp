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
	<script src="/js/common.js"></script>
	<script src="/js/jquery.simplemodal.js"></script>
	<script src="/js/overlay.js"></script>
	<script src="/js/jquery.json-2.2.js"></script>
	<script src="/js/json2.js"></script>
	<script src="/locale/easyui-lang-zh_CN.js"></script>
	<script src="/js/jquery.simplemodal.js"></script>
   	<script src="/js/uploadmodal.js"></script> 
	<script src="/js/datecommon.js"></script>
	<script>
	var opttype;
	$(function(){
		//取得url参数
		var paraString = location.search;     
		var paras = paraString.split("&");   
		opttype = paras[0].substr(paras[0].indexOf("=") + 1);
		if(opttype=='match'){
			$('#delete').hide();
		}else{
			$('#edit').hide();
			$('#match').hide();
		}
		$('#datamatchgrid').datagrid({
			//fitColumns:'true',
			maximized:'true',
			pagination:true,
			onClickRow:function(index){
				var row = $('#datamatchgrid').datagrid('getSelected');
				$('#edit').linkbutton('enable');
				$('#match').linkbutton('enable');
				$('#delete').linkbutton('enable');
				if(row.matchstate=='0'){
					$('#edit').linkbutton('disable');
				}
				if(row.matchstate=='1' || row.matchstate=='2'){
					$('#match').linkbutton('disable');
				}
			}
		});
		var p = $('#datamatchgrid').datagrid('getPager');  
		$(p).pagination({  
			showPageList:false
		});
		 $('#reginfogrid').datagrid({
			fitColumns:'true',
			maximized:'true',
			pagination:{  
				pageSize: 15,
				showPageList:false
			},
			onDblClickRow:function(rowIndex, rowData){
				match();
			},
			onLoadSuccess:function(data){  
				$(this).datagrid('selectRow',0);//自动选择第一行
			}
		});
		$('#reginfogrid').datagrid('getPager').pagination({  
			pageSize: 15,
			showPageList:false
		});
	});	

	function querymatchinfo(){
		var params = {};
		var fields =$('#datamatchform').serializeArray();
		$.each( fields, function(i, field){
			params[field.name] = field.value;
		});
		var matchtype=$("input[name='matchtype']:checked").val();
		params.matchstate = matchtype;
		$('#datamatchgrid').datagrid('options').url = '/datamatchservice/querymatchinfo.do';
		//$('#datamatchgrid').datagrid('getPager').pagination({ 
		//	pageSize: 15,
		//	showPageList:false
		//});
		$('#datamatchgrid').datagrid('reload',params); 
		$('#datamatchquerywindow').window('close');
	}
	function formatterDate(value,row,index){
			return formatDatebox(value);
	}
	function matchwindows(){
		var row=$('#datamatchgrid').datagrid("getSelected");
		if(row){
			$('#taxtypename2').val(row.importtaxpayername);
			$('#match_windows').window('open');
			$('#reginfogrid').datagrid('loadData',{total:0,rows:[]});
			$('#taxtypename2').focus();
			$('#taxtypename2').select();
			regquery();
		}else{
			$.messager.alert("提示","请选择要匹配的行");
		}
	}
	function regquery(){
		var params = {};
		params.taxpayerid = "";
		params.taxpayername = $('#taxtypename2').val();
		params.orgunifycode = '';
		var opts = $('#reginfogrid').datagrid('options');
		opts.url = '/InitGroundServlet/getreginfo.do';
		$('#reginfogrid').datagrid('load',params); 
	}
	function match(){
		var rows=$('#reginfogrid').datagrid("getSelected");
		var matchinforows=$('#datamatchgrid').datagrid("getSelected");
		if(rows){
			$.messager.confirm('提示', '是否确认['+rows['taxpayerid']+']与['+matchinforows['importtaxpayername']+']匹配?', function(r){
				if (r){
					$.ajax({
						type: 'POST',
				        url: "/datamatchservice/match.do",
				        data: {
				        	serialno:matchinforows.serialno,
					 		taxpayerid:rows.taxpayerid,
					 		taxpayername:rows.taxpayername},
				       	dataType: "json",
				        success: function (data) {
				        	if(data=='0')
				        		$.messager.alert("提示","匹配失败!");
				        	else{
				        		$.messager.alert("提示","匹配成功!");
				        		$('#match_windows').window('close');
				        		querymatchinfo();
				        	}
				        }
				    });
				}
			});
		}else{
			$.messager.alert("提示","请选择要操作的记录!");
		}
	}
	function deleterow(){
		var row=$('#datamatchgrid').datagrid("getSelected");
		if(row){
			$.messager.confirm('提示', '是否确认删除该记录?', function(r){
				if (r){
					$.ajax({
						type: 'POST',
				        url: "/datamatchservice/delete.do",
				        data: {serialno:row.serialno},
				       	dataType: "json",
				        success: function (data) {
				        	if(data=='0')
				        		$.messager.alert("提示","删除失败!");
				        	else{
				        		$.messager.alert("提示","删除成功!");
				        		$('#match_windows').window('close');
				        		querymatchinfo();
				        	}
				        }
				    });
				}
			});
		}else{
			$.messager.alert("提示","请选择要删除的记录！");
		}
	}
	</script>
</head>
<body>
	<form id="datamatchform" method="post">
	<div class="easyui-layout" style="width:100%;height:550px;" data-options="split:true" id="layoutDiv" >
		<div data-options="region:'center'">
			<table id='datamatchgrid' class="easyui-datagrid" style="width:99;height:523px;overflow: scroll;"
					data-options="iconCls:'icon-edit',singleSelect:true,pageList:[15]">
				<thead>
						<th data-options="field:'serialno',hidden:true,width:50,align:'center',editor:{type:'validatebox'}">主键</th>
						<th data-options="field:'taxpayerid',width:100,align:'center',editor:{type:'validatebox'}">计算机编码</th>
						<th data-options="field:'taxpayername',width:220,align:'center',editor:{type:'validatebox'}">纳税人名称</th>
						<th data-options="field:'importtaxpayername',width:220,align:'center',editor:{type:'validatebox'}">导入名称</th>
						<th data-options="field:'holddate',width:120,align:'center',formatter:formatterDate,editor:{type:'validatebox'}">获得日期</th>
						<th data-options="field:'area',width:150,align:'center',editor:{type:'validatebox'}">面积(平方米)</th>
						<th data-options="field:'address',width:150,align:'center',editor:{type:'validatebox'}">地址</th>
						<th data-options="field:'landcertificate',width:150,align:'center',editor:{type:'validatebox'}">土地证号</th>
						<th data-options="field:'estateserial',width:150,align:'center',editor:{type:'validatebox'}">宗地编号</th>
						<th data-options="field:'getmoney',width:150,align:'center',editor:{type:'validatebox'}">成交价(元)</th>
						<th data-options="field:'telephone',width:150,align:'center',editor:{type:'validatebox'}">联系电话</th>
				</thead>
			</table>
		</div>
		<div data-options="region:'north'" style="height:25px;width:100%;overflow: visible" >
			<div style="height:25px;">
				<span style="font-size: 12px; color:red; font-weight: bold;">过滤条件：</span>
				<span style="font-size: 12px;"><input type="radio" checked="checked" name="matchtype" value="0" onclick="querymatchinfo()"/>未匹配</span>&nbsp;
				<span style="font-size: 12px;"><input type="radio"  name="matchtype" value="1" onclick="querymatchinfo()"/>已匹配</span>&nbsp;
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="javascript:$('#datamatchquerywindow').window('open');">查询</a>
				<a href="#" class="easyui-linkbutton" id="delete" data-options="iconCls:'icon-cancel',plain:true" onclick="deleterow()">删除</a>
				<a href="#" class="easyui-linkbutton" id="edit" data-options="iconCls:'icon-edit',plain:true" onclick="matchwindows()">修改</a>
				<a href="#" class="easyui-linkbutton" id="match" data-options="iconCls:'icon-check',plain:true" onclick="matchwindows()">匹配</a>
			</div>
		</div>
	</div>
	<div id="datamatchquerywindow" class="easyui-window" data-options="closed:true,modal:true,title:'查询窗口',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:300px;">
		<div class="easyui-panel" title="" style="width:900px;">
			
				<table id="narjcxx" width="100%"  class="table table-bordered">
					<!-- <tr>
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
					</tr> -->
					<tr>
						<td align="right">匹配计算机编码：</td>
						<td>
							<input id="taxpayerid" class="easyui-validatebox" type="text" style="width:200px" name="querytaxpayerid"/>
						</td>
						<td align="right">匹配纳税人名称：</td>
						<td>
							<input id="qtaxpayername" class="easyui-validatebox" type="text" style="width:200px" name="querytaxpayername"/>
						</td>
					</tr>
					<tr>
						<td align="right">导入名称：</td>
						<td>
							<input id="importtaxpayername" class="easyui-validatebox" type="text" style="width:200px" name="importtaxpayername"/>
						</td>
						<td align="right">土地证号：</td>
						<td>
							<input id="landcertificate" class="easyui-validatebox" type="text" style="width:200px" name="landcertificate"/>
						</td>
					</tr>
					<tr>
						<td align="right">宗地编号：</td>
						<td>
							<input id="estateserial" class="easyui-validatebox" type="text" style="width:200px" name="estateserial"/>
						</td>
						<td align="right">土地获得日期：</td>
						<td>
							<input id="holddatebegin" class="easyui-datebox" name="holddatebegin"/>
						至
							<input id="holddateend" class="easyui-datebox"  name="holddateend"/>
						</td>
					</tr>
					<tr>
						<td align="right">导入类型：</td>
						<td>
							<select id="importsource" class="easyui-combobox" style="width:200px" name="importsource" editable="false">
								<option value="" selected>全部</option>
								<option value="01">出让数据导入</option>
								<option value="02">地籍数据导入</option>
								<option value="03">其他数据导入</option>
							</select>
						</td>
					</tr>
					<tr>
				</table>
			
			<div style="text-align:center;padding:5px;">  
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="querymatchinfo()">查询</a>
					<!-- <a href="#" class="easyui-linkbutton" id="aaa" data-options="iconCls:'icon-search'" >查询</a> -->
			</div>
		</div>
	</div>
	</form>
	<!-- <div id="groundstorageeditwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地收储批复',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:300px;">
		<div class="easyui-panel" title="" style="width:900px;">
			<form id="groundstorageeditform" method="post">
				<table id="narjcxx" width="100%" class="table table-bordered">
					<input id="landstoreid"  type="hidden" name="landstoreid"/>	
					<tr>
						<td align="right">批复类型：</td>
						<td>
							<input class="easyui-combobox" name="approvetype" id="approvetype" data-options="disabled:false,panelWidth:300,panelHeight:200"/>					
						</td>
						<td align="right">批复名称：</td>
						<td>
							<input class="easyui-validatebox" name="name" id="name"/>					
						</td>
					</tr>
					<tr>
						<td align="right">厅级批准文号：</td>
						<td><input id="approvenumber" class="easyui-validatebox" type="text" name="approvenumber"/></td>
						<td align="right">市级批准文号：</td>
						<td>
							<input id="approvenumbercity" class="easyui-validatebox" type="text" name="approvenumbercity"/>
						</td>
					</tr>
					<tr>
						<td align="right">纳税人计算机编码：</td>
						<td>
							<input class="easyui-validatebox" name="taxpayer" id="taxpayer"/>					
						</td>
						<td align="right">纳税人计算机名称：</td>
						<td>
							<input class="easyui-validatebox" name="taxpayername" id="taxpayername"/>					
						</td>
					</tr>
					<tr>
						<td align="right">批复日期：</td>
						<td colspan="3">
							<input id="approvedates" class="easyui-datebox" name="approvedates"/>
						</td>
					</tr>
					
				</table>
			</form>
			<div style="text-align:center;padding:5px;">
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="quereyreg()">税务登记查询</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save()">保存</a>
			</div>
		</div>
	</div> -->
	<!-- <div id="groundstoragedetailwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地收储批复明细',collapsible:false,minimizable:false,maximizable:false,closable:false" style="width:800px;height:400px;">
	<table id="groundstoragedetailgrid"></table>
	</div> -->
	<div id="reginfowindow" class="easyui-window" data-options="closed:true,modal:true,title:'纳税人登记信息',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:620px;height:470px;">
	</div>
	<div id="groundstorewindow" class="easyui-window" data-options="closed:true,modal:true,title:'批复',collapsible:false,minimizable:false,maximizable:false,closable:true,resizable:false" style="width:1000px;height:500px;">
	</div>
	<div id="match_windows" class="easyui-window" data-options="closed:true,modal:true,title:'手工匹配',collapsible:false,minimizable:false,maximizable:false,closable:true">
				<div style="text-align:left;padding:5px;">  
					<div style="background-color: #c9c692;height: 25px;">		
							<span style="font-size: 12px; color:red; font-weight: bold;">查询条件：</span>
							<span style="font-size: 12px;">纳税人名称：<input  type="text" style="width:250px" id="taxtypename2" name="taxtypename2"/></span>&nbsp;
							<span style="font-size: 12px; color:red; font-weight: bold;">操作：</span>
							<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="regquery()" >查询</a>
							<a  href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="match()" >匹配</a>
					</div>
				</div>
				<table id="reginfogrid" style="width:700px;height:380px"
				data-options="iconCls:'icon-edit',singleSelect:true" rownumbers="true"> 
					<thead>
						<tr>
							<th data-options="field:'taxpayerid',width:80,align:'center',editor:{type:'validatebox'}">计算机编码</th>
							<th data-options="field:'taxpayername',width:300,align:'left',editor:{type:'validatebox'}">纳税人名称</th>
							<th data-options="field:'taxdeptcode',width:100,align:'center',editor:{type:'validatebox'}">主管地税部门</th>
							<th data-options="field:'taxmanagercode',width:80,align:'center',editor:{type:'validatebox'}">税收管理员</th>
						</tr>
					</thead>
				</table>
	</div>
	<!-- <div id="groundstorageaddwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地收储批复新增',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:200px;">
	</div> -->
	<!-- <div id="addtdxxwindow" class="easyui-window" data-options="closed:true,modal:true,title:'土地信息',collapsible:false,minimizable:false,maximizable:false,closable:true" style="width:940px;height:500px;">
	</div> -->

</body>
</html>
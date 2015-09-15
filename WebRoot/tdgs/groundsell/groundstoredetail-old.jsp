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
	<script src="/js/jquery-1.8.2.min.js"></script>
	<script src="/js/jquery.easyui.min.js"></script>
	<script src="/js/dropdown.js"></script>
    <script src="/js/tiles.js"></script>
    <script src="/js/moduleWindow.js"></script>
	<script src="/menus.js"></script>
	
	<script src="/js/jquery.simplemodal.js"></script>
	<script src="/js/overlay.js"></script>
	<script src="/js/jquery.json-2.2.js"></script>
	<script src="/js/json2.js"></script>
	<script src="/locale/easyui-lang-zh_CN.js"></script>

	
</head>
<body>
<script>
	$(function(){
		var row = $('#groundsellgrid').datagrid('getSelected');
		if(row){
			$.ajax({
			   type: "post",
			   url: "/InitGroundServlet/getlandstoremain.do",
			   data: {landstoreid:row.landstoreid},
			   dataType: "json",
			   success: function(jsondata){
					$('#sotremainform').form('load',jsondata);
					$('#groundstoragedetailgrid').datagrid('loadData',jsondata.subvolist);
			   }
			});
		}
		$('#groundstoragedetailgrid').datagrid({
				singleSelect:'true',
				fitColumns:'true',
				rownumbers:'true',
				toolbar:[]
			});
		});

	</script>
	<form id="sotremainform" method="post">
		<div title="批复信息" data-options="" style="overflow:auto">
			<table  width="100%" class="table table-bordered">
					<input id="landstoreid"  type="hidden" name="landstoreid"/>	
					<tr>
						<td align="right">批复项目名称：</td>
						<td colspan="3">
							<input class="easyui-validatebox" style="width:620px;" name="name" id="name" readOnly="true"/>					
						</td>
					</tr>
					<tr>
						<td align="right">厅级批准文号：</td>
						<td><input id="approvenumber" class="easyui-validatebox" type="text" name="approvenumber" readOnly="true"/></td>
						<td align="right">市级批准文号：</td>
						<td>
							<input id="approvenumbercity" class="easyui-validatebox" type="text" name="approvenumbercity" readOnly="true"/>
						</td>
					</tr>
					<tr>
						<td align="right">纳税人计算机编码：</td>
						<td>
							<input class="easyui-validatebox" name="taxpayer" id="taxpayer" readOnly="true"/>					
						</td>
						<td align="right">纳税人计算机名称：</td>
						<td>
							<input class="easyui-validatebox" name="taxpayername" id="taxpayername" readOnly="true"/>					
						</td>
					</tr>
					<tr>
						<td align="right">批复日期：</td>
						<td colspan="3">
							<input id="approvedates" class="easyui-datebox" name="approvedates" disabled="true"/>
						</td>
					</tr>
					
				</table>
			<!-- <div style="text-align:center;padding:5px;">  
					<a href="#" id = "laststep" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="laststep()">上一步</a>
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="nextstep()">下一步</a>
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="openregwindow()">税务登记查询</a>
			</div> -->
		</div>
	</form>
		<div title="" style="overflow:auto" data-options="
						tools:[{
							handler:function(){
								$('#groundstoragedetailgrid').datagrid('reload');
							}
						}]">
					<table id="groundstoragedetailgrid" 
					data-options="iconCls:'icon-edit',singleSelect:true" rownumbers="true"> 
						<thead>
							<tr>
								<th data-options="field:'landstorsubid',width:80,align:'center',hidden:'true'"></th>
								<th data-options="field:'approvetype',width:80,align:'center',hidden:'true'"></th>
								<th data-options="field:'belongtocountry',width:200,align:'center',formatter:format,editor:{type:'combobox',options:{required:true,editable:false,valueField:'key',textField: 'value',data:locationdata}}">所属乡镇</th>
								<th data-options="field:'belongtowns',width:200,align:'center',formatter:format,editor:{type:'combobox',options:{required:true,editable:false,valueField:'key',textField: 'value',data:locationdata}}">坐落位置</th>
								<th data-options="field:'detailaddress',width:120,align:'center',editor:{type:'text',options:{required:false}}">详细地址</th>
								<th data-options="field:'areaplough',width:100,align:'center',editor:{type:'numberbox',options:{precision:2,min:0,required:true}}">耕地面积</th>
								<th data-options="field:'areabuild',width:100,align:'center',editor:{type:'numberbox',options:{precision:2,min:0,required:true}}">建设用地面积</th>
								<th data-options="field:'areauseless',width:100,align:'center',editor:{type:'numberbox',options:{precision:2,min:0,required:true}}">未利用地面积</th>
							</tr>
						</thead>
					</table>
		</div>
	
</body>
</html>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<%@ include file="/common/inc.jsp"%>
<html>
<head>

	<title>Complex Layout - jQuery EasyUI Demo</title>

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
</head>   
<body>
<script>
	$(function(){
		$.ajax({
		   type: "post",
		   url: "/DerateCheckServlet/gethouseinfo.do",
		   data: {houseid:key},
		   dataType: "json",
		   success: function(jsondata){
				$('#housedetailform').form('load',jsondata);
				if(jsondata.buildingcost !=0){
					$('#buy').remove();
				}else{
					$('#build').remove();
				}
		   }
		});
		
	});
		
</script>
	<div class="easyui-panel" title="" style="overflow:auto;padding:10px">
	<form id="housedetailform" method="post">
		
			<table id="housetable" class="table table-bordered" >
				<tr>
					<td align="right">
						房产来源：
					</td>
					<td>
						<input id="housesource" name="housesource" style="width:200px;" class="easyui-combobox" editable='false' data-options="
						valueField: 'key',
						textField: 'value',
						required:false,
						data:housesourcedata" />
					</td>
					<td align="right">
						房产用途：
					</td>
					<td>
						<input id="purpose" name="purpose" style="width:200px;" class="easyui-combobox" editable='false' data-options="
						valueField: 'key',
						textField: 'value',
						required:false,
						url: '/ComboxService/getComboxs.do?codetablename=COD_HOUSEUSECODE'" />
					</td>
				</tr>
				<tr>
					<td align="right">
						计算机编码：
					</td>
					<td>
						<input id="taxpayerid" class="easyui-validatebox" type="text" name="taxpayerid" style="width:200px;" data-options="required:false"></input>
					</td>
					<td align="right">
						纳税人名称：
					</td>
					<td align="left">
						<input id="taxpayername" class="easyui-validatebox" type="text" name="taxpayername" style="width:200px;" data-options="required:false"></input>
					</td>
				</tr>
				<tr>
					<td align="right">
						房产证类型：
					</td>
					<td>
						<input id="housecertificatetype" name="housecertificatetype" style="width:200px;" class="easyui-combobox" editable='false' data-options="
						valueField: 'key',
						textField: 'value',
						required:false,
						data:housesourcedata" />
					</td>
					<td align="right">
						房产证号：
					</td>
					<td>
						<input id="housecertificate" class="easyui-validatebox" type="text" name="housecertificate" style="width:200px;" data-options="required:false"></input>
					</td>
				</tr>
				<tr>
					<td align="right">
						发证日期：
					</td>
					<td>
						<input id="housecertificatedates" name="housecertificatedates" class="easyui-datebox" style="width:200px;" data-options=""></input>
					</td>
					<td align="right">
						投入使用时间：
					</td>
					<td>
						<input id="usedates" name="usedates" class="easyui-datebox" style="width:200px;" data-options=""></input>
					</td>
				</tr>
				<tr>
					<td align="right">所属村（居）委会：</td>
					<td>
						<input id="belongtowns" name="belongtowns" style="width:200px;" class="easyui-combobox" editable='false' data-options="
						valueField: 'key',
						textField: 'value',
						required:false,
						data:locationdata" />
					</td>
					<td align="right">
						详细地址：
					</td>
					<td>
						<input id="detailaddress" class="easyui-validatebox" style="width:200px;" type="text" name="detailaddress" data-options="required:false"></input>
					</td>
				</tr>
				<tr id="build">
					<td align="right">
					建筑安装成本（元）：
					</td>
					<td>
						<input id="buildingcost" class="easyui-numberbox" style="width:200px;text-align:right" type="text" name="buildingcost" data-options="min:0,required:false" precision="2" value="0.00" style="text-align:right" /></input>
					</td>
					<td align="right">
					与房屋不可分割的设备价款（元）：
					</td>
					<td>
						<input id="devicecost" class="easyui-numberbox" style="width:200px;text-align:right" type="text" name="devicecost" data-options="min:0,required:false" precision="2" value="0.00" style="text-align:right" /></input>
					</td>
				</tr>
				<tr id="buy">
					<td align="right">
					房产价款（元）：
					</td>
					<td>
						<input id="houseamount" class="easyui-numberbox" style="width:200px;text-align:right" type="text" name="houseamount" data-options="min:0,required:false" precision="2" value="0.00" style="text-align:right" /></input>
					</td>
					<td align="right">
					房产税费（元）：
					</td>
					<td>
						<input id="housetax" class="easyui-numberbox" style="width:200px;text-align:right" type="text" name="housetax" data-options="min:0,required:false" precision="2" value="0.00" style="text-align:right" /></input>
					</td>
				</tr>
				<tr>
					<td align="right">
					房产原值（元）：
					</td>
					<td>
						<input id="housetaxoriginalvalue" class="easyui-numberbox" style="width:200px;text-align:right" type="text" name="housetaxoriginalvalue" data-options="min:0,required:false" precision="2" value="0.00" style="text-align:right" /></input>
					</td>
					<td align="right">
					建筑面积（平方米）：
					</td>
					<td>
						<input id="housearea" class="easyui-numberbox" style="width:200px;text-align:right" type="text" name="housearea" data-options="min:0,required:false" precision="2" value="0.00" style="text-align:right" /><font color="red" id="maxgroundarea"></font></input>
					</td>
				</tr>
			</table>
		</form>
		
		</div>
</body>
  
</html>
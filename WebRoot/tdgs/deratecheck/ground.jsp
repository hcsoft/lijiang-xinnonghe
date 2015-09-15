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
		   url: "/GroundInfoServlet/getnewestateinfo.do",
		   data: {estateid:key},
		   dataType: "json",
		   success: function(jsondata){
				$('#grounddetailform').form('load',jsondata);
				//alert(formatterDate(jsondata.holddate));
				//$('#holddate').datebox('setValue',formatterDate(jsondata.holddate));
		   }
		});
	});

</script>
	<div class="easyui-panel" title="" style="overflow:auto;padding:10px">
	<form id="grounddetailform" method="post">
		
			<table id="groundtable" class="table table-bordered" >
				<tr>
					<td align="right">
						宗地编号：
					</td>
					<td>
						<input id="estateserialno" class="easyui-validatebox" type="text" name="estateserialno" style="width:200px;" data-options="required:false"></input>
					</td>
					<td align="right">
						土地来源：
					</td>
					<td>
						<input id="landsource" name="landsource" style="width:200px;" class="easyui-combobox" editable='false' data-options="
						valueField: 'key',
						textField: 'value',
						required:'true',
						data:groundsourcedata" />
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
						土地用途：
					</td>
					<td>
						<input id="purpose" name="purpose" style="width:200px;" class="easyui-combobox" editable='false' data-options="
						valueField: 'key',
						textField: 'value',
						required:'true',
						url: '/ComboxService/getComboxs.do?codetablename=COD_GROUNDUSECODE'" />
					</td>
					<td align="right">
						交付土地时间：
					</td>
					<td>
						<input id="holddates" name="holddates" class="easyui-datebox" style="width:200px;" data-options=""></input>
					</td>
				</tr>
				<tr>
					<td align="right">
						土地证类型：
					</td>
					<td>
						<input id="landcertificatetype" name="landcertificatetype" class="easyui-combobox" style="width:200px;" editable='false' data-options="
						required:false,
						valueField: 'key',
						textField: 'value',
						url: '/ComboxService/getComboxs.do?codetablename=COD_LANDCERTIFICATETYPE'" />
					</td>
					<td align="right">
						土地证号：
					</td>
					<td align="left">
						<input id="landcertificate" class="easyui-validatebox" type="text" name="landcertificate" style="width:200px;" data-options="required:false"></input>
					</td>
				</tr>
				<!-- <tr>
					<td align="right">
						发证日期：
					</td>
					<td>
						<input id="landcertificatedate" name='landcertificatedate' class="easyui-datebox" style="width:200px;" data-options="validType:['datecheck'],required:false" ></input>
					</td>
					<td align="right">
						交付土地时间：
					</td>
					<td>
						<input id="holddates" name="holddates" class="easyui-datebox" style="width:200px;" data-options="validType:['datecheck'],required:false"></input>
					</td>
				</tr>
				<tr>
					<td align="right">
						图号：
					</td>
					<td align="left">
						<input id="pictureno" class="easyui-validatebox" type="text" name="pictureno" style="width:200px;" data-options="required:false"></input>
					</td>
					
					<td align="right">
						受让方是否免税单位：
					</td>
					<td>
						<select id="freetax" class="easyui-combobox" name="freetax" style="width:200px;" data-options="required:false" editable="false">
							<option value="0">否</option>
							<option value="1">是</option>
						</select>
					</td>
				</tr>
				<tr> -->
					<!-- <td align="right">
						土地使用税税额：
					</td>
					<td>
						<select id="landtaxprice" class="easyui-combobox" name="landtaxprice" style="width:200px;" data-options="required:false" editable="false">
							<option value="2" selected="true">2元/年.平方米</option>
							<option value="3">3元/年.平方米</option>
						</select>
					</td> -->
					<!-- <td align="right">
						土地使用税申报征期类型：
					</td>
					<td>
						<select id="taxperiod" class="easyui-combobox" name="taxperiod" style="width:200px;" data-options="required:false,panelWidth:300" editable="false">
							<option value="21" selected="true">按月申报缴纳，于当月1日至10日内</option>
							<option value="22">按季申报缴纳，于本季度1日至40日内</option>
							<option value="07">按半年申报缴纳，于本期120日内</option>
							<option value="10">按年申报缴纳，于本年120日内</option>
						</select>
					</td> -->
					<td align="right">
						使用年限起：
					</td>
					<td>
						<input id="datebegins" name='datebegins' class="easyui-datebox" style="width:200px;" data-options=""></input>
					</td>

					<td align="right">
						使用年限止：
					</td>
					<td>
						<input id="dateends" name='dateends' class="easyui-datebox" style="width:200px;" data-options=""></input>
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
					</td>
				</tr>
				<tr>
					<td align="right">所属村（居）委会：</td>
					<td colspan="3">
						<input id="belongtowns" name="belongtowns" style="width:400px;" class="easyui-combobox" editable='false' data-options="
						valueField: 'key',
						textField: 'value',
						required:'true',
						data:locationdata" />
					</td>
				</tr>
				<tr>
					<td align="right">
						详细地址：
					</td>
					<td colspan="3">
						<input id="detailaddress" class="easyui-validatebox" style="width:400px;" type="text" name="detailaddress" data-options="required:false"></input>
					</td>
				</tr>
				<tr>
					<td align="right">
					土地总价/年租金（元）：
					</td>
					<td>
						<input id="landmoney" class="easyui-numberbox" style="width:200px;text-align:right" type="text" name="landmoney" data-options="min:0,required:false" precision="2" value="0.00" style="text-align:right" /></input>
					</td>
					<td align="right">
					土地面积（平方米）：
					</td>
					<td>
						<input id="landarea" class="easyui-numberbox" style="width:200px;text-align:right" type="text" name="landarea" data-options="min:0,required:false" precision="2" value="0.00" style="text-align:right" /><font color="red" id="maxgroundarea"></font></input>
					</td>
				</tr>
			</table>
		</form>
		
		</div>
</body>
  
</html>
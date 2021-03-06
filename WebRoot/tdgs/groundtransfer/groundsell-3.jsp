﻿<%@ page contentType="text/html; charset=UTF-8"%>
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
		$('#locationtype').val(locationtype);
		$('#belongtowns').val(belongtocountrycode);
		$('#detailaddress').val(detailaddress);
		$('#maxgroundarea').html('可出租土地面积'+maxgroundarea+'平方米');
	});
	
	

	
	//提交
	function savetdxx(){
			if(!$('#protocolnumber').validatebox('isValid')){
				$.messager.alert('返回消息','协议书号不能为空！');
				$('#protocolnumber')[0].focus();
				return;
			}
			if(!$('#holddates').datebox('isValid')){
				$.messager.alert('返回消息','交付土地时间不能为空或校验有误！');
				$('.datebox :text')[0].focus();
				return;
			}
			if(!$('#purpose').combo('isValid')){
				$.messager.alert('返回消息','土地用途不能为空！');
				$('.combo :text')[7].focus();
				return;
			}
			if(!$('#taxperiod').combo('isValid')){
				$.messager.alert('返回消息','土地使用税征期类型不能为空！');
				$('.combo :text')[10].focus();
				return;
			}
			if(!$('#limitbegins').datebox('isValid')){
				$.messager.alert('返回消息','使用年限起校验有误！');
				$('.datebox :text')[2].focus();
				return;
			}
			if(!$('#limitends').datebox('isValid')){
				$.messager.alert('返回消息','使用年限止校验有误！');
				$('.datebox :text')[3].focus();
				return;
			}
			if(!$('#locationtype').combo('isValid')){
				$.messager.alert('返回消息','土地坐落地类型不能为空！');
				$('.combo :text')[13].focus();
				return;
			}
			if(!$('#belongtowns').combo('isValid')){
				$.messager.alert('返回消息','所属乡镇不能为空！');
				$('.combo :text')[14].focus();
				return;
			}
			if(!$('#detailaddress').validatebox('isValid')){
				$.messager.alert('返回消息','详细地址不能为空！');
				$('#detailaddress')[0].focus();
				return;
			}
			if(!$('#landarea').validatebox('isValid')){
				$.messager.alert('返回消息','土地面积不能为空！');
				$('#landarea')[0].focus();
				return;
			}else{
				var landarea = $('#landarea').val();
				if(landarea>maxgroundarea){
					$.messager.alert('返回消息','出租土地面积不能大于最大可出租土地面积！');
					$('#landarea')[0].focus();
					return;
				}
				var landarea = $('#landarea').val();
				if(landarea == 0){
					$.messager.alert('返回消息','土地面积必须大于0！');
					$('#landarea')[0].focus();
					return;
				}
			}
			var params = {};
			var fields =$('#groundsellform').serializeArray(); //自动序列化表单元素为JSON对象
			$.each( fields, function(i, field){
				params[field.name] = field.value;
			}); 
			var groundinfo = $('#groundtransfergrid').datagrid('getSelected');
			params.businesstype = businesstype;
			params.estateid = groundinfo.estateid;
			params.landstoreid = groundinfo.landstoreid;
			params.landstorsubid = landstoresubid;
			params.taxpayerid = taxpayerid;
			params.taxpayername = taxpayername;
			params.landsource = '03';
			$.ajax({
					   type: "post",
					   url: "/TransferGroundServlet/savegroundtransferinfo.do",
					   data: params,
					   dataType: "json",
					   success: function(jsondata){
							$.messager.alert('返回消息',"保存成功");
							$('#groundtransfergrid').datagrid('reload');
							$('#groundbusinesswindow').window('close');
					   },
					error:function (data, status, e){   
						 $.messager.alert('返回消息',"保存出错");   
					   }   
			});
		//}
	}
	



	$.extend($.fn.validatebox.defaults.rules, {   
		datecheck: {   
			validator: function(value){ 
				return /^((((1[6-9]|[2-9]\d)\d{2})-(0?[13578]|1[02])-(0?[1-9]|[12]\d|3[01]))|(((1[6-9]|[2-9]\d)\d{2})-(0?[13456789]|1[012])-(0?[1-9]|[12]\d|30))|(((1[6-9]|[2-9]\d)\d{2})-0?2-(0?[1-9]|1\d|2[0-8]))|(((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))-0?2-29-))$/.test(value);
			},   
			message: '时间格式不合法，格式为YYYY-MM-DD 如：2013-01-03'  
		}   
	}); 

	$.extend($.fn.validatebox.defaults.rules, {
	isAfter: {
		validator: function(value, param){
			var dateA = $.fn.datebox.defaults.parser(value);
			var dateB = $.fn.datebox.defaults.parser($(param[0]).datebox('getValue'));
			//$.messager.alert('返回消息',dateA+"------"+dateB);
			return dateA<dateB;
			},
		 message: '使用年限起不能大于使用年限止！'
		}
	});
//data-options="validType:['datecheck','isAfter[\'#holddates\']']"


	
	function last(){
		$('#groundbusinesswindow').window('refresh', 'reginfo.jsp');
	}
	function quereyreg(){
		$('#reginfowindow').window('open');//打开新录入窗口
		$('#reginfowindow').window('refresh', 'reginfo.jsp');
	}
	</script>
	<div style="background:#f4f4f4;padding:3px 5px;">
		<a href="#" id="btn1" class="easyui-linkbutton" icon="icon-undo" plain="true" onclick="last()">上一步</a>
		<a href="#" id="btn2" class="easyui-linkbutton" icon="icon-save" plain="true" onclick="savetdxx()">保存</a>
	</div>
	<div class="easyui-panel" title="" style="overflow:auto;padding:10px">
	<form id="groundsellform" method="post">
		
			<table id="tdjcxx" class="table table-bordered" >
				<tr>
					<td align="right">
						出租协议书号：
					</td>
					<td align="left">
						<input id="protocolnumber" class="easyui-validatebox" type="text" name="protocolnumber" style="width:200px;" data-options="required:true"></input>
					</td>
					<td align="right">
						交付土地时间：
					</td>
					<td>
						<input id="holddates" name="holddates" class="easyui-datebox" style="width:200px;" data-options="validType:['datecheck'],required:true"></input>
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
						承租方是否免税单位：
					</td>
					<td>
						<select id="freetax" class="easyui-combobox" name="freetax" style="width:200px;" data-options="required:true" editable="false">
							<option value="0">否</option>
							<option value="1">是</option>
						</select>
					</td>
				</tr>
				<tr>
					<td align="right">
						土地使用税税额：
					</td>
					<td>
						<select id="landtaxprice" class="easyui-combobox" name="landtaxprice" style="width:200px;" data-options="required:true" editable="false">
							<option value="1"  selected="true">1元/年.平方米</option>
							<option value="2">2元/年.平方米</option>
							<option value="3">3元/年.平方米</option>
						</select>
					</td>
					<td align="right">
						土地使用税申报征期类型：
					</td>
					<td>
						<input id="taxperiod" name="taxperiod" style="width:200px;" class="easyui-combobox" editable='false' data-options="
						valueField: 'key',
						textField: 'value',
						required:true,
						required:'true',panelWidth:300,panelHeight:200,
						data:levydatetypedata" />
					</td>
					
				</tr>
				<tr>
					<td align="right">
						使用年限起：
					</td>
					<td>
						<input id="limitbegins" name='limitbegins' class="easyui-datebox" style="width:200px;" data-options="validType:['datecheck','isAfter[\'#limitends\']']"></input>
					</td>
					<td align="right">
						使用年限止：
					</td>
					<td>
						<input id="limitends" name='limitends' class="easyui-datebox" style="width:200px;" data-options="validType:'datecheck'"></input>
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
					<td align="right">
						所属乡镇：
					</td>
					<td colspan="3">
						<input id="belongtowns" name="belongtowns" style="width:400px;" class="easyui-combobox" editable='false' data-options="
						valueField: 'key',
						textField: 'value',
						required:'true',
						url: '/InitGroundServlet/getlocationComboxs.do?codetablename=COD_BELONGTOCOUNTRYCODE'" />
					</td>
				</tr>
				<tr>
					<td align="right">
						详细地址：
					</td>
					<td colspan="3">
						<input id="detailaddress" class="easyui-validatebox" style="width:400px;" type="text" name="detailaddress" data-options="required:true"></input>
					</td>
				</tr>
				<tr>
					<td align="right">
					年租金（元）：
					</td>
					<td>
						<input id="landmoney" class="easyui-numberbox" style="width:200px;text-align:right" type="text" name="landmoney" data-options="min:0,required:true" precision="2" value="0.00" style="text-align:right" /></input>
					</td>
					<td align="right">
					月租金（元）：
					</td>
					<td>
						<input id="monthmoney" class="easyui-numberbox" style="width:200px;text-align:right" type="text" name="monthmoney" data-options="min:0,required:true" precision="2" value="0.00" style="text-align:right" /></input>
					</td>
				</tr>
				<tr>
					<td align="right">
					出租土地面积（平方米）：
					</td>
					<td>
						<input id="landarea" class="easyui-numberbox" style="width:200px;text-align:right" type="text" name="landarea" data-options="min:0,required:true" precision="2" value="0.00" style="text-align:right" /><font color="red" id="maxgroundarea"></font></input>
					</td>
					<td align="right">
					约定缴纳土地使用税面积（平方米）：
					</td>
					<td>
						<input id="taxarea" class="easyui-numberbox" style="width:200px;text-align:right" type="text" name="taxarea" data-options="min:0,required:true" precision="2" value="0.00" style="text-align:right" /><font color="red" id="maxgroundarea"></font></input>
					</td>
				</tr>
			</table>
		
		</form>
		
		</div>
</body>
  
</html>